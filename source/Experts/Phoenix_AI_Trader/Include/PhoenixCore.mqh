//+------------------------------------------------------------------+
//|                                                   PhoenixCore.mqh |
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Main Runtime Orchestrator                              |
//|  Version: Alpha 0.1.0                                            |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_CORE_MQH__
#define __PHOENIX_CORE_MQH__

#include "PhoenixVersion.mqh"
#include "PhoenixEnums.mqh"
#include "PhoenixConstants.mqh"
#include "PhoenixTypes.mqh"
#include "PhoenixConfig.mqh"
#include "PhoenixLogger.mqh"
#include "PhoenixUtilities.mqh"

//+------------------------------------------------------------------+
//| Phoenix Core                                                     |
//+------------------------------------------------------------------+
class CPhoenixCore
  {
private:

   CPhoenixConfig m_config;
   CPhoenixLogger m_logger;

   SPhoenixRuntimeState    m_runtime;
   SPhoenixAccountSnapshot m_account;
   SPhoenixCapitalHealth   m_capital_health;

   string m_symbols[];
   int    m_symbol_count;

   bool m_initialized;
   bool m_timer_initialized;

   datetime m_start_time;
   datetime m_last_cycle_time;

   ulong m_cycle_count;

   //+------------------------------------------------------------------+
   //| Reset runtime state                                             |
   //+------------------------------------------------------------------+
   void ResetRuntime()
     {
      m_runtime.robot_state =
         PHX_ROBOT_UNINITIALIZED;

      m_runtime.trading_mode =
         PHX_TRADING_DISABLED;

      m_runtime.risk_profile =
         PHX_RISK_SHIELD;

      m_runtime.initialized =
         false;

      m_runtime.auto_trading_enabled =
         false;

      m_runtime.safe_mode =
         true;

      m_runtime.emergency_stop =
         false;

      m_runtime.initialization_time =
         0;

      m_runtime.last_update_time =
         0;

      m_runtime.update_count =
         0;

      m_runtime.last_error =
         "";
     }

   //+------------------------------------------------------------------+
   //| Calculate capital health                                       |
   //+------------------------------------------------------------------+
   void UpdateCapitalHealth()
     {
      double balance = m_account.balance;
      double equity  = m_account.equity;

      if(balance <= 0.0)
        {
         m_capital_health.score = 0.0;
         m_capital_health.state =
            PHX_CAPITAL_CRITICAL;

         m_capital_health.trading_allowed =
            false;

         m_capital_health.status_text =
            "Invalid account balance.";

         return;
        }

      double equity_ratio =
         CPhoenixUtilities::SafeDivide(
            equity,
            balance
         );

      double drawdown_percent = 0.0;

      if(equity < balance)
        {
         drawdown_percent =
            CPhoenixUtilities::MoneyToPercent(
               balance - equity,
               balance
            );
        }

      double drawdown_health =
         CPhoenixUtilities::Clamp(
            100.0 - drawdown_percent * 10.0,
            0.0,
            100.0
         );

      double margin_health = 100.0;

      if(m_account.margin > 0.0)
        {
         margin_health =
            CPhoenixUtilities::Clamp(
               m_account.margin_level / 10.0,
               0.0,
               100.0
            );
        }

      m_capital_health.drawdown_percent =
         drawdown_percent;

      m_capital_health.daily_loss_percent = 0.0;
      m_capital_health.margin_health =
         margin_health;

      m_capital_health.loss_streak_health =
         100.0;

      m_capital_health.exposure_health =
         100.0;

      m_capital_health.score =
         (drawdown_health * 0.50) +
         (margin_health * 0.50);

      if(m_capital_health.score >= 80.0)
        {
         m_capital_health.state =
            PHX_CAPITAL_HEALTHY;

         m_capital_health.trading_allowed =
            true;

         m_capital_health.status_text =
            "Capital health is healthy.";
        }
      else
      if(m_capital_health.score >= 60.0)
        {
         m_capital_health.state =
            PHX_CAPITAL_CAUTION;

         m_capital_health.trading_allowed =
            true;

         m_capital_health.status_text =
            "Capital health requires caution.";
        }
      else
      if(m_capital_health.score >= 40.0)
        {
         m_capital_health.state =
            PHX_CAPITAL_WARNING;

         m_capital_health.trading_allowed =
            false;

         m_capital_health.status_text =
            "Trading blocked: capital warning.";
        }
      else
        {
         m_capital_health.state =
            PHX_CAPITAL_CRITICAL;

         m_capital_health.trading_allowed =
            false;

         m_capital_health.status_text =
            "Trading blocked: critical capital condition.";
        }
     }

   //+------------------------------------------------------------------+
   //| Validate trading environment                                   |
   //+------------------------------------------------------------------+
   bool ValidateEnvironment()
     {
      if(!CPhoenixUtilities::IsExpertTradingAllowed())
        {
         m_logger.Warning(
            "Expert trading permission is disabled."
         );
        }

      if(!CPhoenixUtilities::IsAccountTradingAllowed())
        {
         m_logger.Warning(
            "Account trading permission is disabled."
         );

         return false;
        }

      return true;
     }

   //+------------------------------------------------------------------+
   //| Refresh account data                                            |
   //+------------------------------------------------------------------+
   void RefreshAccount()
     {
      m_account =
         CPhoenixUtilities::BuildAccountSnapshot();

      UpdateCapitalHealth();
     }

   //+------------------------------------------------------------------+
   //| Update runtime state                                            |
   //+------------------------------------------------------------------+
   void UpdateRuntime()
     {
      m_runtime.last_update_time =
         TimeCurrent();

      m_runtime.update_count++;

      m_last_cycle_time =
         TimeCurrent();
     }

public:

   //+------------------------------------------------------------------+
   //| Constructor                                                      |
   //+------------------------------------------------------------------+
   CPhoenixCore()
     {
      m_symbol_count = 0;

      m_initialized =
         false;

      m_timer_initialized =
         false;

      m_start_time =
         0;

      m_last_cycle_time =
         0;

      m_cycle_count =
         0;

      ResetRuntime();
     }

   //+------------------------------------------------------------------+
   //| Destructor                                                       |
   //+------------------------------------------------------------------+
   ~CPhoenixCore()
     {
      Shutdown();
     }

   //+------------------------------------------------------------------+
   //| Initialize                                                       |
   //+------------------------------------------------------------------+
   bool Initialize()
     {
      if(m_initialized)
         return true;

      ResetRuntime();

      if(!m_logger.Initialize(
            PHX_LOG_INFO,
            true,
            true
         ))
        {
         return false;
        }

      m_logger.Info(
         "========================================"
      );

      m_logger.Info(
         "PHOENIX AI TRADER INITIALIZATION"
      );

      m_logger.Info(
         "Version: " + PHX_VERSION_STRING
      );

      m_logger.Info(
         "========================================"
      );

      m_runtime.robot_state =
         PHX_ROBOT_INITIALIZING;

      m_runtime.risk_profile =
         m_config.RiskProfile();

      m_runtime.trading_mode =
         m_config.TradingMode();

      m_runtime.safe_mode =
         m_config.SafeMode();

      //--- Read account
      RefreshAccount();

      m_logger.Info(
         StringFormat(
            "Account balance: %.2f %s",
            m_account.balance,
            m_account.currency
         )
      );

      m_logger.Info(
         StringFormat(
            "Account equity: %.2f %s",
            m_account.equity,
            m_account.currency
         )
      );

      m_logger.Info(
         StringFormat(
            "Broker: %s",
            m_account.broker
         )
      );

      m_logger.Info(
         StringFormat(
            "Server: %s",
            m_account.server
         )
      );

      //--- Account type
      if(m_account.account_mode ==
         PHX_ACCOUNT_DEMO)
        {
         m_logger.Info(
            "Account mode: DEMO"
         );
        }
      else
      if(m_account.account_mode ==
         PHX_ACCOUNT_REAL)
        {
         m_logger.Warning(
            "Account mode: REAL"
         );
        }
      else
        {
         m_logger.Warning(
            "Account mode: UNKNOWN"
         );
        }

      //--- Position mode
      if(m_account.position_mode ==
         PHX_POSITION_MODE_HEDGING)
        {
         m_logger.Info(
            "Position mode: HEDGING"
         );
        }
      else
      if(m_account.position_mode ==
         PHX_POSITION_MODE_NETTING)
        {
         m_logger.Info(
            "Position mode: NETTING"
         );
        }

      //--- Micro capital
      if(CPhoenixUtilities::IsMicroCapital())
        {
         m_logger.Warning(
            "Micro-capital account detected. "
            "Capital protection will be prioritized."
         );
        }

      //--- Validate environment
      if(!ValidateEnvironment())
        {
         m_logger.Error(
            "Trading environment validation failed."
         );

         m_runtime.robot_state =
            PHX_ROBOT_ERROR;

         m_runtime.last_error =
            "Trading environment validation failed.";

         return false;
        }

      //--- Initial state
      m_runtime.robot_state =
         PHX_ROBOT_READY;

      m_runtime.initialized =
         true;

      m_runtime.auto_trading_enabled =
         false;

      m_runtime.trading_mode =
         PHX_TRADING_DISABLED;

      m_start_time =
         TimeCurrent();

      m_runtime.initialization_time =
         m_start_time;

      m_initialized =
         true;

      m_logger.Info(
         "Phoenix Core initialized successfully."
      );

      m_logger.Info(
         "Automatic trading remains DISABLED."
      );

      return true;
     }

   //+------------------------------------------------------------------+
   //| Shutdown                                                        |
   //+------------------------------------------------------------------+
   void Shutdown()
     {
      if(!m_initialized)
         return;

      StopAutoTrading();

      m_runtime.robot_state =
         PHX_ROBOT_STOPPED;

      m_logger.Info(
         "Phoenix Core shutting down."
      );

      m_logger.Shutdown();

      m_initialized =
         false;
     }

   //+------------------------------------------------------------------+
   //| Main runtime cycle                                              |
   //+------------------------------------------------------------------+
   void Process()
     {
      if(!m_initialized)
         return;

      m_cycle_count++;

      RefreshAccount();

      //--- Emergency stop has absolute priority
      if(m_runtime.emergency_stop)
        {
         if(m_runtime.robot_state !=
            PHX_ROBOT_EMERGENCY_STOP)
           {
            m_runtime.robot_state =
               PHX_ROBOT_EMERGENCY_STOP;

            m_runtime.trading_mode =
               PHX_TRADING_DISABLED;

            m_runtime.auto_trading_enabled =
               false;

            m_logger.Critical(
               "EMERGENCY STOP ACTIVE."
            );
           }

         UpdateRuntime();

         return;
        }

      //--- Capital protection
      if(!m_capital_health.trading_allowed)
        {
         if(m_runtime.auto_trading_enabled)
           {
            m_logger.Warning(
               "Auto trading blocked by capital protection."
            );
           }

         m_runtime.trading_mode =
            PHX_TRADING_DISABLED;

         m_runtime.auto_trading_enabled =
            false;

         m_runtime.robot_state =
            PHX_ROBOT_PROTECTION;

         UpdateRuntime();

         return;
        }

      //--- Normal state
      if(m_runtime.auto_trading_enabled)
        {
         m_runtime.robot_state =
            PHX_ROBOT_TRADING;
        }
      else
        {
         m_runtime.robot_state =
            PHX_ROBOT_READY;
        }

      UpdateRuntime();
     }

   //+------------------------------------------------------------------+
   //| Start automatic trading                                         |
   //+------------------------------------------------------------------+
   bool StartAutoTrading()
     {
      if(!m_initialized)
        {
         m_logger.Error(
            "Cannot start auto trading: "
            "Core is not initialized."
         );

         return false;
        }

      if(m_runtime.emergency_stop)
        {
         m_logger.Error(
            "Cannot start auto trading: "
            "Emergency stop is active."
         );

         return false;
        }

      if(m_runtime.safe_mode)
        {
         m_logger.Warning(
            "Cannot start auto trading: "
            "Safe Mode is active."
         );

         return false;
        }

      RefreshAccount();

      if(!m_capital_health.trading_allowed)
        {
         m_logger.Warning(
            "Cannot start auto trading: "
            "Capital protection blocked trading."
         );

         return false;
        }

      if(!CPhoenixUtilities::IsAccountTradingAllowed())
        {
         m_logger.Error(
            "Cannot start auto trading: "
            "Account trading is disabled."
         );

         return false;
        }

      m_runtime.auto_trading_enabled =
         true;

      m_runtime.trading_mode =
         PHX_TRADING_AUTO;

      m_runtime.robot_state =
         PHX_ROBOT_TRADING;

      m_logger.Critical(
         "AUTOMATIC TRADING STARTED."
      );

      return true;
     }

   //+------------------------------------------------------------------+
   //| Stop automatic trading                                          |
   //+------------------------------------------------------------------+
   void StopAutoTrading()
     {
      if(!m_runtime.auto_trading_enabled &&
         m_runtime.trading_mode ==
         PHX_TRADING_DISABLED)
         return;

      m_runtime.auto_trading_enabled =
         false;

      m_runtime.trading_mode =
         PHX_TRADING_DISABLED;

      if(!m_runtime.emergency_stop)
        {
         m_runtime.robot_state =
            PHX_ROBOT_READY;
        }

      m_logger.Warning(
         "AUTOMATIC TRADING STOPPED."
      );
     }

   //+------------------------------------------------------------------+
   //| Emergency stop                                                  |
   //+------------------------------------------------------------------+
   void EmergencyStop()
     {
      m_runtime.emergency_stop =
         true;

      m_runtime.auto_trading_enabled =
         false;

      m_runtime.trading_mode =
         PHX_TRADING_DISABLED;

      m_runtime.robot_state =
         PHX_ROBOT_EMERGENCY_STOP;

      m_logger.Critical(
         "EMERGENCY STOP ACTIVATED."
      );
     }

   //+------------------------------------------------------------------+
   //| Reset emergency stop                                            |
   //+------------------------------------------------------------------+
   bool ResetEmergencyStop()
     {
      if(!m_runtime.emergency_stop)
         return true;

      m_runtime.emergency_stop =
         false;

      m_runtime.auto_trading_enabled =
         false;

      m_runtime.trading_mode =
         PHX_TRADING_DISABLED;

      m_runtime.robot_state =
         PHX_ROBOT_READY;

      m_logger.Warning(
         "Emergency stop reset. "
         "Automatic trading remains disabled."
      );

      return true;
     }

   //+------------------------------------------------------------------+
   //| Set safe mode                                                   |
   //+------------------------------------------------------------------+
   void SetSafeMode(bool enabled)
     {
      m_runtime.safe_mode =
         enabled;

      if(enabled)
        {
         StopAutoTrading();

         m_logger.Warning(
            "SAFE MODE enabled."
         );
        }
      else
        {
         m_logger.Info(
            "SAFE MODE disabled."
         );
        }
     }

   //+------------------------------------------------------------------+
   //| Add symbol                                                      |
   //+------------------------------------------------------------------+
   bool AddSymbol(string symbol)
     {
      if(symbol == "")
         return false;

      //--- Avoid duplicates
      for(int i = 0; i < m_symbol_count; i++)
        {
         if(m_symbols[i] == symbol)
            return true;
        }

      int new_size =
         m_symbol_count + 1;

      ArrayResize(
         m_symbols,
         new_size
      );

      m_symbols[m_symbol_count] =
         symbol;

      m_symbol_count =
         new_size;

      m_logger.Info(
         "Symbol added: " + symbol
      );

      return true;
     }

   //+------------------------------------------------------------------+
   //| Remove all symbols                                             |
   //+------------------------------------------------------------------+
   void ClearSymbols()
     {
      ArrayResize(
         m_symbols,
         0
      );

      m_symbol_count =
         0;
     }

   //+------------------------------------------------------------------+
   //| Get symbol count                                                |
   //+------------------------------------------------------------------+
   int SymbolCount()
     {
      return m_symbol_count;
     }

   //+------------------------------------------------------------------+
   //| Get symbol by index                                             |
   //+------------------------------------------------------------------+
   string GetSymbol(int index)
     {
      if(index < 0 ||
         index >= m_symbol_count)
         return "";

      return m_symbols[index];
     }

   //+------------------------------------------------------------------+
   //| Scan configured symbols                                        |
   //+------------------------------------------------------------------+
   void UpdateSymbols()
     {
      for(int i = 0; i < m_symbol_count; i++)
        {
         string symbol =
            m_symbols[i];

         if(symbol == "")
            continue;

         SPhoenixSymbolContext context =
            CPhoenixUtilities::
            BuildSymbolContext(symbol);

         m_logger.Debug(
            StringFormat(
               "Symbol=%s Bid=%.*f Ask=%.*f Spread=%.1f",
               symbol,
               context.digits,
               context.bid,
               context.digits,
               context.ask,
               context.spread_points
            )
         );
        }
     }

   //+------------------------------------------------------------------+
   //| Get runtime state                                               |
   //+------------------------------------------------------------------+
   SPhoenixRuntimeState Runtime()
     {
      return m_runtime;
     }

   //+------------------------------------------------------------------+
   //| Get account snapshot                                            |
   //+------------------------------------------------------------------+
   SPhoenixAccountSnapshot Account()
     {
      return m_account;
     }

   //+------------------------------------------------------------------+
   //| Get capital health                                              |
   //+------------------------------------------------------------------+
   SPhoenixCapitalHealth CapitalHealth()
     {
      return m_capital_health;
     }

   //+------------------------------------------------------------------+
   //| Get configuration                                               |
   //+------------------------------------------------------------------+
   SPhoenixConfig Configuration()
     {
      return m_config.Get();
     }

   //+------------------------------------------------------------------+
   //| Get logger                                                      |
   //+------------------------------------------------------------------+
   CPhoenixLogger &Logger()
     {
      return m_logger;
     }

   //+------------------------------------------------------------------+
   //| Is initialized                                                  |
   //+------------------------------------------------------------------+
   bool IsInitialized()
     {
      return m_initialized;
     }

   //+------------------------------------------------------------------+
   //| Is automatic trading active                                    |
   //+------------------------------------------------------------------+
   bool IsAutoTradingActive()
     {
      return m_runtime.auto_trading_enabled;
     }

   //+------------------------------------------------------------------+
   //| Is emergency stop active                                       |
   //+------------------------------------------------------------------+
   bool IsEmergencyStopActive()
     {
      return m_runtime.emergency_stop;
     }

   //+------------------------------------------------------------------+
   //| Get cycle count                                                 |
   //+------------------------------------------------------------------+
   ulong CycleCount()
     {
      return m_cycle_count;
     }
  };

#endif // __PHOENIX_CORE_MQH__
//+------------------------------------------------------------------+