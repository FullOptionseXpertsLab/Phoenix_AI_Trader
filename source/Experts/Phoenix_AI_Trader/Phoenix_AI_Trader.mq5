//+------------------------------------------------------------------+
//|                                           Phoenix_AI_Trader.mq5   |
//|                       PHOENIX AI TRADER                           |
//|                                                                  |
//|  Expert Advisor MT5                                              |
//|  Version: Alpha 0.1.0                                            |
//|                                                                  |
//|  Foundation build:                                               |
//|  - PhoenixVersion                                                 |
//|  - PhoenixEnums                                                   |
//|  - PhoenixConstants                                               |
//|  - PhoenixTypes                                                   |
//|  - PhoenixConfig                                                  |
//|  - PhoenixLogger                                                  |
//|  - PhoenixUtilities                                               |
//|  - PhoenixCore                                                     |
//+------------------------------------------------------------------+
#property copyright "FullOptionsExpertsLab"
#property link      "https://github.com/FullOptionseXpertsLab/Phoenix_AI_Trader"
#property version   "1.00"
#property description "PHOENIX AI TRADER - Capital Protection First"
#property description "Multi-symbol MT5 trading framework."
#property description "Foundation Alpha 0.1.0"

//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include "Include/PhoenixVersion.mqh"
#include "Include/PhoenixEnums.mqh"
#include "Include/PhoenixConstants.mqh"
#include "Include/PhoenixTypes.mqh"
#include "Include/PhoenixConfig.mqh"
#include "Include/PhoenixLogger.mqh"
#include "Include/PhoenixUtilities.mqh"
#include "Include/PhoenixCore.mqh"

//+------------------------------------------------------------------+
//| Global Core                                                      |
//+------------------------------------------------------------------+
CPhoenixCore Phoenix;

//+------------------------------------------------------------------+
//| Inputs                                                            |
//+------------------------------------------------------------------+

input group "===== PHOENIX GENERAL ====="

input bool InpEnableRobot =
   true;

input bool InpSafeMode =
   true;

input bool InpAllowAutoTrading =
   false;

input group "===== RISK PROTECTION ====="

input double InpRiskPercent =
   0.35;

input double InpMaxDailyLossPercent =
   2.00;

input double InpMaxDrawdownPercent =
   5.00;

input int InpMaxConsecutiveLosses =
   3;

input int InpMaxPositions =
   3;

input group "===== EXECUTION ====="

input int InpMaxSpreadPoints =
   50;

input int InpMaxSlippagePoints =
   10;

input bool InpAllowBuy =
   true;

input bool InpAllowSell =
   true;

input group "===== SYMBOLS ====="

input bool InpEnableMultiSymbol =
   true;

input bool InpPrimarySymbolsOnly =
   false;

input string InpSymbols =
   "XAUUSD,EURUSD,GBPUSD,BTCUSD,USDJPY";

input group "===== DIAGNOSTICS ====="

input bool InpEnableDiagnostics =
   true;

input bool InpDetailedLogging =
   true;

//+------------------------------------------------------------------+
//| Timer interval                                                   |
//+------------------------------------------------------------------+
input group "===== ENGINE ====="

input int InpTimerSeconds =
   1;

//+------------------------------------------------------------------+
//| Apply user configuration                                         |
//+------------------------------------------------------------------+
void ApplyInputs()
  {
   SPhoenixConfig config =
      Phoenix.Configuration();

   config.enabled =
      InpEnableRobot;

   config.safe_mode =
      InpSafeMode;

   config.allow_auto_trading =
      InpAllowAutoTrading;

   config.risk_percent =
      InpRiskPercent;

   config.max_daily_loss_percent =
      InpMaxDailyLossPercent;

   config.max_drawdown_percent =
      InpMaxDrawdownPercent;

   config.max_consecutive_losses =
      InpMaxConsecutiveLosses;

   config.max_total_positions =
      InpMaxPositions;

   config.max_spread_points =
      InpMaxSpreadPoints;

   config.max_slippage_points =
      InpMaxSlippagePoints;

   config.allow_buy =
      InpAllowBuy;

   config.allow_sell =
      InpAllowSell;

   config.enable_multi_symbol =
      InpEnableMultiSymbol;

   config.primary_symbols_only =
      InpPrimarySymbolsOnly;

   config.enable_diagnostics =
      InpEnableDiagnostics;

   config.enable_detailed_logging =
      InpDetailedLogging;

   Phoenix.Configuration();

   //--- Configuration will be managed internally
   //--- by PhoenixConfig in the next architecture layer.
  }

//+------------------------------------------------------------------+
//| Configure symbols                                                |
//+------------------------------------------------------------------+
void ConfigureSymbols()
  {
   Phoenix.ClearSymbols();

   string symbols[];

   int count =
      StringSplit(
         InpSymbols,
         ',',
         symbols
      );

   if(count <= 0)
     {
      Phoenix.Logger().Warning(
         "No symbols configured."
      );

      return;
     }

   for(int i = 0; i < count; i++)
     {
      string symbol =
         symbols[i];

      StringTrimLeft(symbol);
      StringTrimRight(symbol);

      if(symbol == "")
         continue;

      string broker_symbol =
         CPhoenixUtilities::
         FindBrokerSymbol(symbol);

      if(broker_symbol == "")
        {
         Phoenix.Logger().Warning(
            "Symbol not found at broker: " +
            symbol
         );

         continue;
        }

      Phoenix.AddSymbol(
         broker_symbol
      );
     }

   Phoenix.Logger().Info(
      StringFormat(
         "Configured symbols: %d",
         Phoenix.SymbolCount()
      )
   );
  }

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print(
      "========================================"
   );

   Print(
      "PHOENIX AI TRADER"
   );

   Print(
      "Foundation Alpha 0.1.0"
   );

   Print(
      "Initialization started..."
   );

   //--- Initialize Core
   if(!Phoenix.Initialize())
     {
      Print(
         "PHOENIX initialization FAILED."
      );

      return INIT_FAILED;
     }

   //--- Configure symbols
   ConfigureSymbols();

   //--- Timer
   int timer_seconds =
      InpTimerSeconds;

   if(timer_seconds < 1)
      timer_seconds = 1;

   if(!EventSetTimer(timer_seconds))
     {
      Phoenix.Logger().Error(
         StringFormat(
            "Unable to create timer. Error=%d",
            GetLastError()
         )
      );

      Phoenix.Shutdown();

      return INIT_FAILED;
     }

   //--- Successful initialization
   Phoenix.Logger().Info(
      "PHOENIX AI TRADER initialized."
   );

   Phoenix.Logger().Info(
      "Foundation mode: NO TRADE EXECUTION."
   );

   Phoenix.Logger().Info(
      "Capital protection architecture active."
   );

   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(
   const int reason
)
  {
   EventKillTimer();

   Phoenix.Logger().Info(
      StringFormat(
         "EA deinitialization. Reason=%d",
         reason
      )
   );

   Phoenix.Shutdown();

   Print(
      "PHOENIX AI TRADER stopped."
   );
  }

//+------------------------------------------------------------------+
//| Tick event                                                       |
//+------------------------------------------------------------------+
void OnTick()
  {
   //--- Foundation build intentionally does
   //--- not execute trades from OnTick.
   //
   //--- Trading engines will be connected
   //--- during subsequent development phases.
  }

//+------------------------------------------------------------------+
//| Timer event                                                      |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!Phoenix.IsInitialized())
      return;

   Phoenix.Process();

   Phoenix.UpdateSymbols();
  }

//+------------------------------------------------------------------+
//| Trade transaction event                                         |
//+------------------------------------------------------------------+
void OnTradeTransaction(
   const MqlTradeTransaction &trans,
   const MqlTradeRequest &request,
   const MqlTradeResult &result
)
  {
   if(!Phoenix.IsInitialized())
      return;

   Phoenix.Logger().Debug(
      StringFormat(
         "Trade transaction received. "
         "Type=%d Order=%I64u Deal=%I64u",
         trans.type,
         trans.order,
         trans.deal
      )
   );
  }
//+------------------------------------------------------------------+