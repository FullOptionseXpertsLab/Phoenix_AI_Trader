//+------------------------------------------------------------------+
//|                                                  PhoenixTypes.mqh |
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Shared Data Types                                      |
//|  Version: Alpha 0.1.0                                            |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_TYPES_MQH__
#define __PHOENIX_TYPES_MQH__

#include "PhoenixEnums.mqh"

//+------------------------------------------------------------------+
//| Symbol runtime context                                          |
//+------------------------------------------------------------------+
struct SPhoenixSymbolContext
  {
   string                    symbol;
   string                    broker_symbol;
   int                       priority;

   bool                      enabled;
   bool                      available;
   bool                      trade_allowed;

   ENUM_PHOENIX_SYMBOL_PRIORITY priority_level;

   double                    bid;
   double                    ask;
   double                    spread_points;

   double                    point;
   double                    tick_size;
   double                    tick_value;
   double                    contract_size;

   double                    volume_min;
   double                    volume_max;
   double                    volume_step;

   int                       digits;
   int                       stops_level;
   int                       freeze_level;

   ENUM_PHOENIX_MARKET_REGIME market_regime;
   ENUM_PHOENIX_SESSION       session;

   datetime                  last_tick_time;
   datetime                  last_analysis_time;
  };

//+------------------------------------------------------------------+
//| Market snapshot                                                  |
//+------------------------------------------------------------------+
struct SPhoenixMarketSnapshot
  {
   string symbol;

   datetime timestamp;

   double bid;
   double ask;
   double spread_points;

   double atr;
   double volatility;

   double trend_score;
   double momentum_score;
   double liquidity_score;

   ENUM_PHOENIX_MARKET_REGIME regime;
   ENUM_PHOENIX_SESSION session;
  };

//+------------------------------------------------------------------+
//| Signal                                                           |
//+------------------------------------------------------------------+
struct SPhoenixSignal
  {
   string symbol;

   ENUM_PHOENIX_DIRECTION direction;
   ENUM_PHOENIX_DECISION decision;
   ENUM_PHOENIX_SIGNAL_STRENGTH strength;
   ENUM_PHOENIX_STRATEGY strategy;

   double score;
   double confidence;

   double entry_price;
   double stop_loss;
   double take_profit;

   double risk_reward;

   datetime timestamp;

   bool valid;
  };

//+------------------------------------------------------------------+
//| Risk assessment                                                  |
//+------------------------------------------------------------------+
struct SPhoenixRiskAssessment
  {
   bool approved;

   double account_balance;
   double account_equity;
   double free_margin;

   double risk_percent;
   double risk_money;

   double proposed_volume;
   double maximum_volume;

   double daily_loss_percent;
   double drawdown_percent;

   double capital_health_index;

   int open_positions;
   int consecutive_losses;

   ENUM_PHOENIX_CAPITAL_STATE capital_state;
   ENUM_PHOENIX_PROTECTION_REASON protection_reason;

   string rejection_reason;
  };

//+------------------------------------------------------------------+
//| Trade request                                                    |
//+------------------------------------------------------------------+
struct SPhoenixTradeRequest
  {
   string symbol;

   ENUM_PHOENIX_DIRECTION direction;

   double volume;
   double price;
   double stop_loss;
   double take_profit;

   ulong deviation_points;

   long magic_number;

   string comment;

   ENUM_PHOENIX_STRATEGY strategy;

   double signal_score;
   double risk_percent;

   datetime request_time;
  };

//+------------------------------------------------------------------+
//| Trade result                                                     |
//+------------------------------------------------------------------+
struct SPhoenixTradeResult
  {
   bool success;

   ulong order_ticket;
   ulong deal_ticket;
   ulong position_ticket;

   uint retcode;

   double requested_volume;
   double executed_volume;

   double requested_price;
   double executed_price;

   double sl;
   double tp;

   double commission;
   double swap;

   string symbol;
   string message;

   datetime execution_time;
  };

//+------------------------------------------------------------------+
//| Position snapshot                                                |
//+------------------------------------------------------------------+
struct SPhoenixPositionSnapshot
  {
   ulong ticket;

   string symbol;

   ENUM_PHOENIX_DIRECTION direction;

   double volume;
   double open_price;
   double current_price;

   double stop_loss;
   double take_profit;

   double profit;
   double swap;
   double commission;

   double risk_money;
   double risk_percent;

   long magic_number;

   datetime open_time;
  };

//+------------------------------------------------------------------+
//| Account snapshot                                                 |
//+------------------------------------------------------------------+
struct SPhoenixAccountSnapshot
  {
   long login;

   string broker;
   string server;
   string currency;

   double balance;
   double equity;

   double margin;
   double free_margin;
   double margin_level;

   double profit;

   long leverage;

   ENUM_PHOENIX_ACCOUNT_MODE account_mode;
   ENUM_PHOENIX_POSITION_MODE position_mode;

   bool trade_allowed;
   bool expert_allowed;

   datetime timestamp;
  };

//+------------------------------------------------------------------+
//| Daily performance                                                |
//+------------------------------------------------------------------+
struct SPhoenixDailyPerformance
  {
   datetime day_start;

   double starting_balance;
   double starting_equity;

   double current_balance;
   double current_equity;

   double realized_profit;
   double floating_profit;

   double gross_profit;
   double gross_loss;

   double daily_profit_percent;
   double daily_loss_percent;

   int total_trades;
   int winning_trades;
   int losing_trades;

   int consecutive_losses;

   double largest_win;
   double largest_loss;

   bool daily_loss_limit_reached;
  };

//+------------------------------------------------------------------+
//| Capital Health Index                                             |
//+------------------------------------------------------------------+
struct SPhoenixCapitalHealth
  {
   double score;

   double drawdown_percent;
   double daily_loss_percent;
   double margin_health;
   double loss_streak_health;
   double exposure_health;

   ENUM_PHOENIX_CAPITAL_STATE state;

   bool trading_allowed;

   string status_text;
  };

//+------------------------------------------------------------------+
//| Diagnostic result                                                |
//+------------------------------------------------------------------+
struct SPhoenixDiagnostic
  {
   string name;

   ENUM_PHOENIX_DIAGNOSTIC_STATUS status;

   string message;
   string recommendation;

   datetime timestamp;
  };

//+------------------------------------------------------------------+
//| Robot runtime state                                              |
//+------------------------------------------------------------------+
struct SPhoenixRuntimeState
  {
   ENUM_PHOENIX_ROBOT_STATE robot_state;
   ENUM_PHOENIX_TRADING_MODE trading_mode;

   ENUM_PHOENIX_RISK_PROFILE risk_profile;

   bool initialized;
   bool auto_trading_enabled;

   bool safe_mode;
   bool emergency_stop;

   datetime initialization_time;
   datetime last_update_time;

   uint update_count;

   string last_error;
  };

//+------------------------------------------------------------------+
//| Portfolio exposure                                               |
//+------------------------------------------------------------------+
struct SPhoenixPortfolioExposure
  {
   double total_risk_money;
   double total_risk_percent;

   double total_volume;

   int total_positions;

   double buy_exposure;
   double sell_exposure;

   double correlation_risk;

   bool exposure_limit_reached;
  };

//+------------------------------------------------------------------+
//| Scanner result                                                   |
//+------------------------------------------------------------------+
struct SPhoenixScannerResult
  {
   string symbol;

   bool analyzed;
   bool opportunity_found;

   SPhoenixMarketSnapshot market;
   SPhoenixSignal signal;
   SPhoenixRiskAssessment risk;

   datetime scan_time;
  };

//+------------------------------------------------------------------+
//| Learning record                                                  |
//+------------------------------------------------------------------+
struct SPhoenixLearningRecord
  {
   datetime timestamp;

   string symbol;

   ENUM_PHOENIX_STRATEGY strategy;
   ENUM_PHOENIX_DIRECTION direction;

   double signal_score;
   double confidence;

   double volatility;
   double spread_points;

   double risk_percent;

   double result_money;
   double result_percent;

   bool winning_trade;
  };

#endif // __PHOENIX_TYPES_MQH__
//+------------------------------------------------------------------+