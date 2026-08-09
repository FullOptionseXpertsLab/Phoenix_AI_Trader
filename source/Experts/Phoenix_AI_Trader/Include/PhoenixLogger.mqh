//+------------------------------------------------------------------+
//|                                                 PhoenixLogger.mqh|
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Central Logging Service                                |
//|  Version: Alpha 0.1.0                                            |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_LOGGER_MQH__
#define __PHOENIX_LOGGER_MQH__

#include "PhoenixEnums.mqh"
#include "PhoenixConstants.mqh"

//+------------------------------------------------------------------+
//| Logger service                                                   |
//+------------------------------------------------------------------+
class CPhoenixLogger
  {
private:
   ENUM_PHOENIX_LOG_LEVEL m_min_level;
   bool                   m_console_enabled;
   bool                   m_file_enabled;
   bool                   m_initialized;

   int                    m_file_handle;
   string                 m_file_name;

   ulong                  m_message_count;

   //+------------------------------------------------------------------+
   //| Convert log level to text                                        |
   //+------------------------------------------------------------------+
   string LevelToString(ENUM_PHOENIX_LOG_LEVEL level)
     {
      switch(level)
        {
         case PHX_LOG_DEBUG:
            return "DEBUG";

         case PHX_LOG_INFO:
            return "INFO";

         case PHX_LOG_WARNING:
            return "WARNING";

         case PHX_LOG_ERROR:
            return "ERROR";

         case PHX_LOG_CRITICAL:
            return "CRITICAL";
        }

      return "UNKNOWN";
     }

   //+------------------------------------------------------------------+
   //| Convert log level to short code                                  |
   //+------------------------------------------------------------------+
   string LevelToCode(ENUM_PHOENIX_LOG_LEVEL level)
     {
      switch(level)
        {
         case PHX_LOG_DEBUG:
            return "DBG";

         case PHX_LOG_INFO:
            return "INF";

         case PHX_LOG_WARNING:
            return "WRN";

         case PHX_LOG_ERROR:
            return "ERR";

         case PHX_LOG_CRITICAL:
            return "CRT";
        }

      return "UNK";
     }

   //+------------------------------------------------------------------+
   //| Build log filename                                               |
   //+------------------------------------------------------------------+
   string BuildFileName()
     {
      MqlDateTime dt;
      TimeToStruct(TimeCurrent(),dt);

      return StringFormat(
         "%s\\Phoenix_%04d%02d%02d.log",
         PHX_LOG_FOLDER,
         dt.year,
         dt.mon,
         dt.day
      );
     }

   //+------------------------------------------------------------------+
   //| Format timestamp                                                 |
   //+------------------------------------------------------------------+
   string TimeStamp()
     {
      MqlDateTime dt;
      TimeToStruct(TimeCurrent(),dt);

      return StringFormat(
         "%04d-%02d-%02d %02d:%02d:%02d",
         dt.year,
         dt.mon,
         dt.day,
         dt.hour,
         dt.min,
         dt.sec
      );
     }

   //+------------------------------------------------------------------+
   //| Write message to file                                            |
   //+------------------------------------------------------------------+
   void WriteToFile(string line)
     {
      if(!m_file_enabled)
         return;

      //--- Re-open daily file when required
      string expected_file = BuildFileName();

      if(m_file_handle == INVALID_HANDLE ||
         m_file_name != expected_file)
        {
         CloseFile();

         //--- Create directory structure
         FolderCreate(PHX_DATA_FOLDER);
         FolderCreate(PHX_LOG_FOLDER);

         m_file_handle = FileOpen(
            expected_file,
            FILE_READ |
            FILE_WRITE |
            FILE_TXT |
            FILE_ANSI |
            FILE_SHARE_READ |
            FILE_SHARE_WRITE |
            FILE_COMMON
         );

         if(m_file_handle == INVALID_HANDLE)
           {
            PrintFormat(
               "[PHOENIX][LOGGER] Unable to open log file. Error=%d",
               GetLastError()
            );

            return;
           }

         m_file_name = expected_file;

         FileSeek(
            m_file_handle,
            0,
            SEEK_END
         );
        }

      FileWriteString(
         m_file_handle,
         line + "\r\n"
      );

      FileFlush(m_file_handle);
     }

   //+------------------------------------------------------------------+
   //| Close file                                                       |
   //+------------------------------------------------------------------+
   void CloseFile()
     {
      if(m_file_handle != INVALID_HANDLE)
        {
         FileFlush(m_file_handle);
         FileClose(m_file_handle);
         m_file_handle = INVALID_HANDLE;
        }

      m_file_name = "";
     }

   //+------------------------------------------------------------------+
   //| Internal write                                                   |
   //+------------------------------------------------------------------+
   void Write(
      ENUM_PHOENIX_LOG_LEVEL level,
      string message
   )
     {
      if(level < m_min_level)
         return;

      string line = StringFormat(
         "[%s][PHOENIX][%s] %s",
         TimeStamp(),
         LevelToCode(level),
         message
      );

      if(m_console_enabled)
         Print(line);

      WriteToFile(line);

      m_message_count++;
     }

public:

   //+------------------------------------------------------------------+
   //| Constructor                                                      |
   //+------------------------------------------------------------------+
   CPhoenixLogger()
     {
      m_min_level       = PHX_LOG_INFO;
      m_console_enabled = true;
      m_file_enabled    = true;
      m_initialized     = false;

      m_file_handle     = INVALID_HANDLE;
      m_file_name       = "";

      m_message_count   = 0;
     }

   //+------------------------------------------------------------------+
   //| Destructor                                                       |
   //+------------------------------------------------------------------+
   ~CPhoenixLogger()
     {
      Shutdown();
     }

   //+------------------------------------------------------------------+
   //| Initialize                                                       |
   //+------------------------------------------------------------------+
   bool Initialize(
      ENUM_PHOENIX_LOG_LEVEL minimum_level = PHX_LOG_INFO,
      bool console_enabled = true,
      bool file_enabled = true
   )
     {
      m_min_level       = minimum_level;
      m_console_enabled = console_enabled;
      m_file_enabled    = file_enabled;
      m_initialized     = true;

      Info("Phoenix Logger initialized.");

      return true;
     }

   //+------------------------------------------------------------------+
   //| Shutdown                                                         |
   //+------------------------------------------------------------------+
   void Shutdown()
     {
      if(!m_initialized)
         return;

      CloseFile();

      m_initialized = false;
     }

   //+------------------------------------------------------------------+
   //| Set minimum level                                                |
   //+------------------------------------------------------------------+
   void SetMinimumLevel(
      ENUM_PHOENIX_LOG_LEVEL level
   )
     {
      m_min_level = level;
     }

   //+------------------------------------------------------------------+
   //| Enable / disable console                                        |
   //+------------------------------------------------------------------+
   void EnableConsole(bool enabled)
     {
      m_console_enabled = enabled;
     }

   //+------------------------------------------------------------------+
   //| Enable / disable file logging                                   |
   //+------------------------------------------------------------------+
   void EnableFile(bool enabled)
     {
      m_file_enabled = enabled;

      if(!enabled)
         CloseFile();
     }

   //+------------------------------------------------------------------+
   //| Debug                                                            |
   //+------------------------------------------------------------------+
   void Debug(string message)
     {
      Write(PHX_LOG_DEBUG,message);
     }

   //+------------------------------------------------------------------+
   //| Info                                                             |
   //+------------------------------------------------------------------+
   void Info(string message)
     {
      Write(PHX_LOG_INFO,message);
     }

   //+------------------------------------------------------------------+
   //| Warning                                                          |
   //+------------------------------------------------------------------+
   void Warning(string message)
     {
      Write(PHX_LOG_WARNING,message);
     }

   //+------------------------------------------------------------------+
   //| Error                                                            |
   //+------------------------------------------------------------------+
   void Error(string message)
     {
      Write(PHX_LOG_ERROR,message);
     }

   //+------------------------------------------------------------------+
   //| Critical                                                         |
   //+------------------------------------------------------------------+
   void Critical(string message)
     {
      Write(PHX_LOG_CRITICAL,message);
     }

   //+------------------------------------------------------------------+
   //| Structured diagnostic message                                    |
   //+------------------------------------------------------------------+
   void Diagnostic(
      string component,
      ENUM_PHOENIX_LOG_LEVEL level,
      string message
   )
     {
      string formatted = StringFormat(
         "[%s] %s",
         component,
         message
      );

      Write(level,formatted);
     }

   //+------------------------------------------------------------------+
   //| Trade event                                                      |
   //+------------------------------------------------------------------+
   void TradeEvent(
      string symbol,
      string action,
      double volume,
      double price,
      string result
   )
     {
      string message = StringFormat(
         "[TRADE] Symbol=%s | Action=%s | Volume=%.2f | Price=%.*f | Result=%s",
         symbol,
         action,
         volume,
         (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS),
         price,
         result
      );

      Write(PHX_LOG_INFO,message);
     }

   //+------------------------------------------------------------------+
   //| Risk event                                                       |
   //+------------------------------------------------------------------+
   void RiskEvent(
      string symbol,
      string decision,
      double risk_percent,
      string reason
   )
     {
      string message = StringFormat(
         "[RISK] Symbol=%s | Decision=%s | Risk=%.2f%% | Reason=%s",
         symbol,
         decision,
         risk_percent,
         reason
      );

      Write(PHX_LOG_WARNING,message);
     }

   //+------------------------------------------------------------------+
   //| Protection event                                                |
   //+------------------------------------------------------------------+
   void ProtectionEvent(
      ENUM_PHOENIX_PROTECTION_REASON reason,
      string message
   )
     {
      string protection = "UNKNOWN";

      switch(reason)
        {
         case PHX_PROTECT_DAILY_LOSS:
            protection = "DAILY_LOSS";
            break;

         case PHX_PROTECT_WEEKLY_LOSS:
            protection = "WEEKLY_LOSS";
            break;

         case PHX_PROTECT_MONTHLY_LOSS:
            protection = "MONTHLY_LOSS";
            break;

         case PHX_PROTECT_DRAWDOWN:
            protection = "DRAWDOWN";
            break;

         case PHX_PROTECT_MARGIN:
            protection = "MARGIN";
            break;

         case PHX_PROTECT_SPREAD:
            protection = "SPREAD";
            break;

         case PHX_PROTECT_VOLATILITY:
            protection = "VOLATILITY";
            break;

         case PHX_PROTECT_EXPOSURE:
            protection = "EXPOSURE";
            break;

         case PHX_PROTECT_LOSS_STREAK:
            protection = "LOSS_STREAK";
            break;

         case PHX_PROTECT_ACCOUNT:
            protection = "ACCOUNT";
            break;

         case PHX_PROTECT_SYSTEM:
            protection = "SYSTEM";
            break;

         default:
            break;
        }

      Write(
         PHX_LOG_CRITICAL,
         StringFormat(
            "[PROTECTION][%s] %s",
            protection,
            message
         )
      );
     }

   //+------------------------------------------------------------------+
   //| Get message count                                                |
   //+------------------------------------------------------------------+
   ulong MessageCount()
     {
      return m_message_count;
     }

   //+------------------------------------------------------------------+
   //| Is initialized                                                   |
   //+------------------------------------------------------------------+
   bool IsInitialized()
     {
      return m_initialized;
     }
  };

#endif // __PHOENIX_LOGGER_MQH__
//+------------------------------------------------------------------+