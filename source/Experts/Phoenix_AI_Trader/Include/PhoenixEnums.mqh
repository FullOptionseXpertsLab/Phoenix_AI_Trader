//+------------------------------------------------------------------+
//|                                                 PhoenixEnums.mqh |
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Enumerations                                           |
//|  Version: Alpha 0.1.0                                            |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_ENUMS_MQH__
#define __PHOENIX_ENUMS_MQH__

//+------------------------------------------------------------------+
//| Robot lifecycle states                                           |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_ROBOT_STATE
  {
   PHX_STATE_UNINITIALIZED = 0,
   PHX_STATE_INITIALIZING,
   PHX_STATE_READY,
   PHX_STATE_RUNNING,
   PHX_STATE_PAUSED,
   PHX_STATE_STOPPING,
   PHX_STATE_STOPPED,
   PHX_STATE_ERROR,
   PHX_STATE_EMERGENCY_STOP
  };

//+------------------------------------------------------------------+
//| Trading operation modes                                          |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_TRADING_MODE
  {
   PHX_TRADING_DISABLED = 0,
   PHX_TRADING_MANUAL,
   PHX_TRADING_ASSISTED,
   PHX_TRADING_AUTO
  };

//+------------------------------------------------------------------+
//| Environment / account mode                                       |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_ACCOUNT_MODE
  {
   PHX_ACCOUNT_UNKNOWN = 0,
   PHX_ACCOUNT_DEMO,
   PHX_ACCOUNT_REAL,
   PHX_ACCOUNT_CONTEST
  };

//+------------------------------------------------------------------+
//| MT5 position accounting mode                                     |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_POSITION_MODE
  {
   PHX_POSITION_MODE_UNKNOWN = 0,
   PHX_POSITION_MODE_NETTING,
   PHX_POSITION_MODE_HEDGING
  };

//+------------------------------------------------------------------+
//| Risk profiles                                                     |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_RISK_PROFILE
  {
   PHX_RISK_SHIELD = 0,
   PHX_RISK_BALANCED,
   PHX_RISK_DYNAMIC,
   PHX_RISK_CUSTOM
  };

//+------------------------------------------------------------------+
//| Capital protection state                                         |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_CAPITAL_STATE
  {
   PHX_CAPITAL_NORMAL = 0,
   PHX_CAPITAL_CAUTION,
   PHX_CAPITAL_REDUCED_RISK,
   PHX_CAPITAL_RESTRICTED,
   PHX_CAPITAL_LOCKED
  };

//+------------------------------------------------------------------+
//| Market regime                                                     |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_MARKET_REGIME
  {
   PHX_REGIME_UNKNOWN = 0,
   PHX_REGIME_TREND_BULLISH,
   PHX_REGIME_TREND_BEARISH,
   PHX_REGIME_RANGE,
   PHX_REGIME_BREAKOUT,
   PHX_REGIME_HIGH_VOLATILITY,
   PHX_REGIME_LOW_VOLATILITY,
   PHX_REGIME_UNSTABLE
  };

//+------------------------------------------------------------------+
//| Trade direction                                                   |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_DIRECTION
  {
   PHX_DIRECTION_NONE = 0,
   PHX_DIRECTION_BUY,
   PHX_DIRECTION_SELL
  };

//+------------------------------------------------------------------+
//| Signal strength                                                   |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_SIGNAL_STRENGTH
  {
   PHX_SIGNAL_NONE = 0,
   PHX_SIGNAL_WEAK,
   PHX_SIGNAL_MODERATE,
   PHX_SIGNAL_STRONG,
   PHX_SIGNAL_VERY_STRONG
  };

//+------------------------------------------------------------------+
//| Decision type                                                     |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_DECISION
  {
   PHX_DECISION_NONE = 0,
   PHX_DECISION_BUY,
   PHX_DECISION_SELL,
   PHX_DECISION_HOLD,
   PHX_DECISION_REJECT,
   PHX_DECISION_PAUSE
  };

//+------------------------------------------------------------------+
//| Trading session                                                   |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_SESSION
  {
   PHX_SESSION_UNKNOWN = 0,
   PHX_SESSION_ASIA,
   PHX_SESSION_LONDON,
   PHX_SESSION_NEW_YORK,
   PHX_SESSION_LONDON_NEW_YORK_OVERLAP,
   PHX_SESSION_OFF_SESSION
  };

//+------------------------------------------------------------------+
//| Protection reason                                                 |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_PROTECTION_REASON
  {
   PHX_PROTECT_NONE = 0,
   PHX_PROTECT_DAILY_LOSS,
   PHX_PROTECT_WEEKLY_LOSS,
   PHX_PROTECT_MONTHLY_LOSS,
   PHX_PROTECT_DRAWDOWN,
   PHX_PROTECT_MARGIN,
   PHX_PROTECT_SPREAD,
   PHX_PROTECT_VOLATILITY,
   PHX_PROTECT_EXPOSURE,
   PHX_PROTECT_LOSS_STREAK,
   PHX_PROTECT_ACCOUNT,
   PHX_PROTECT_SYSTEM
  };

//+------------------------------------------------------------------+
//| Strategy family                                                  |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_STRATEGY
  {
   PHX_STRATEGY_NONE = 0,
   PHX_STRATEGY_TREND,
   PHX_STRATEGY_MOMENTUM,
   PHX_STRATEGY_BREAKOUT,
   PHX_STRATEGY_RANGE,
   PHX_STRATEGY_SMC,
   PHX_STRATEGY_ICT,
   PHX_STRATEGY_SCALPING,
   PHX_STRATEGY_INTRADAY,
   PHX_STRATEGY_SWING
  };

//+------------------------------------------------------------------+
//| Symbol priority                                                  |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_SYMBOL_PRIORITY
  {
   PHX_PRIORITY_PRIMARY_1 = 1,   // XAUUSD
   PHX_PRIORITY_PRIMARY_2 = 2,   // EURUSD
   PHX_PRIORITY_PRIMARY_3 = 3,   // GBPUSD
   PHX_PRIORITY_PRIMARY_4 = 4,   // BTCUSD
   PHX_PRIORITY_PRIMARY_5 = 5,   // USDJPY / JPY
   PHX_PRIORITY_SECONDARY = 6,
   PHX_PRIORITY_CUSTOM = 99
  };

//+------------------------------------------------------------------+
//| Diagnostic status                                                |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_DIAGNOSTIC_STATUS
  {
   PHX_DIAG_UNKNOWN = 0,
   PHX_DIAG_OK,
   PHX_DIAG_WARNING,
   PHX_DIAG_FAILED,
   PHX_DIAG_BLOCKED
  };

//+------------------------------------------------------------------+
//| Log severity                                                      |
//+------------------------------------------------------------------+
enum ENUM_PHOENIX_LOG_LEVEL
  {
   PHX_LOG_DEBUG = 0,
   PHX_LOG_INFO,
   PHX_LOG_WARNING,
   PHX_LOG_ERROR,
   PHX_LOG_CRITICAL
  };

#endif // __PHOENIX_ENUMS_MQH__
//+------------------------------------------------------------------+