//+------------------------------------------------------------------+
//|                                                 PhoenixConfig.mqh|
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Configuration                                          |
//|  Version: Alpha 0.1.0                                            |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_CONFIG_MQH__
#define __PHOENIX_CONFIG_MQH__

#include "PhoenixEnums.mqh"
#include "PhoenixConstants.mqh"

//+------------------------------------------------------------------+
//| Global configuration                                             |
//+------------------------------------------------------------------+
struct SPhoenixConfig
  {
   //--- General
   bool                         enabled;
   bool                         safe_mode;
   bool                         allow_auto_trading;

   ENUM_PHOENIX_TRADING_MODE    trading_mode;
   ENUM_PHOENIX_RISK_PROFILE     risk_profile;

   //--- Capital protection
   double                       risk_percent;
   double                       max_daily_loss_percent;
   double                       max_drawdown_percent;

   int                          max_consecutive_losses;
   int                          max_total_positions;

   //--- Execution
   int                          max_spread_points;
   int                          max_slippage_points;

   bool                         allow_buy;
   bool                         allow_sell;

   //--- Strategy / signal
   double                       minimum_signal_score;
   double                       strong_signal_score;

   //--- Portfolio
   bool                         enable_portfolio_protection;
   double                       max_portfolio_risk_percent;

   //--- Sessions
   bool                         enable_session_filter;
   bool                         allow_asia;
   bool                         allow_london;
   bool                         allow_new_york;

   //--- Volatility
   bool                         enable_volatility_filter;
   double                       min_volatility;
   double                       max_volatility;

   //--- Symbol management
   bool                         enable_multi_symbol;
   bool                         primary_symbols_only;

   //--- Recovery
   bool                         enable_loss_streak_protection;
   int                          cooldown_minutes;

   //--- Capital modes
   bool                         enable_capital_adaptation;
   double                       micro_capital_threshold;

   //--- Diagnostics
   bool                         enable_diagnostics;
   bool                         enable_detailed_logging;

   //--- Notifications
   bool                         enable_notifications;

   //--- Persistence
   bool                         enable_state_persistence;
  };

//+------------------------------------------------------------------+
//| Configuration manager                                             |
//+------------------------------------------------------------------+
class CPhoenixConfig
  {
private:
   SPhoenixConfig m_config;

public:

   //+------------------------------------------------------------------+
   //| Constructor                                                       |
   //+------------------------------------------------------------------+
   CPhoenixConfig()
     {
      ResetDefaults();
     }

   //+------------------------------------------------------------------+
   //| Reset configuration to Phoenix Shield defaults                  |
   //+------------------------------------------------------------------+
   void ResetDefaults()
     {
      //--- General
      m_config.enabled             = true;
      m_config.safe_mode           = true;
      m_config.allow_auto_trading  = false;

      m_config.trading_mode        = PHX_TRADING_DISABLED;
      m_config.risk_profile        = PHX_RISK_SHIELD;

      //--- Capital protection
      m_config.risk_percent        = PHX_DEFAULT_RISK_PERCENT;
      m_config.max_daily_loss_percent =
         PHX_DEFAULT_DAILY_LOSS_PCT;

      m_config.max_drawdown_percent =
         PHX_DEFAULT_DRAWDOWN_PCT;

      m_config.max_consecutive_losses =
         PHX_DEFAULT_MAX_LOSS_STREAK;

      m_config.max_total_positions =
         PHX_DEFAULT_MAX_POSITIONS;

      //--- Execution
      m_config.max_spread_points =
         PHX_DEFAULT_MAX_SPREAD_POINTS;

      m_config.max_slippage_points =
         PHX_DEFAULT_MAX_SLIPPAGE_POINTS;

      m_config.allow_buy  = true;
      m_config.allow_sell = true;

      //--- Signal
      m_config.minimum_signal_score =
         PHX_MIN_SIGNAL_SCORE;

      m_config.strong_signal_score =
         PHX_STRONG_SIGNAL_SCORE;

      //--- Portfolio
      m_config.enable_portfolio_protection = true;

      m_config.max_portfolio_risk_percent =
         PHX_DEFAULT_RISK_PERCENT;

      //--- Sessions
      m_config.enable_session_filter = true;

      m_config.allow_asia     = true;
      m_config.allow_london   = true;
      m_config.allow_new_york = true;

      //--- Volatility
      m_config.enable_volatility_filter = true;

      m_config.min_volatility = 0.0;
      m_config.max_volatility = 0.0;

      //--- Symbols
      m_config.enable_multi_symbol = true;

      // By default we permit all configured symbols.
      // The symbol engine will later decide which ones
      // are actually available at the broker.
      m_config.primary_symbols_only = false;

      //--- Recovery
      m_config.enable_loss_streak_protection = true;

      m_config.cooldown_minutes =
         PHX_DEFAULT_COOLDOWN_MINUTES;

      //--- Capital adaptation
      m_config.enable_capital_adaptation = true;

      m_config.micro_capital_threshold =
         PHX_MICRO_CAPITAL_THRESHOLD;

      //--- Diagnostics
      m_config.enable_diagnostics       = true;
      m_config.enable_detailed_logging  = true;

      //--- Notifications
      m_config.enable_notifications = false;

      //--- Persistence
      m_config.enable_state_persistence = true;
     }

   //+------------------------------------------------------------------+
   //| Return complete configuration                                    |
   //+------------------------------------------------------------------+
   SPhoenixConfig Get()
     {
      return m_config;
     }

   //+------------------------------------------------------------------+
   //| Set complete configuration                                      |
   //+------------------------------------------------------------------+
   void Set(const SPhoenixConfig &config)
     {
      m_config = config;
     }

   //+------------------------------------------------------------------+
   //| Risk profile                                                     |
   //+------------------------------------------------------------------+
   ENUM_PHOENIX_RISK_PROFILE RiskProfile()
     {
      return m_config.risk_profile;
     }

   void SetRiskProfile(ENUM_PHOENIX_RISK_PROFILE profile)
     {
      m_config.risk_profile = profile;
     }

   //+------------------------------------------------------------------+
   //| Trading mode                                                     |
   //+------------------------------------------------------------------+
   ENUM_PHOENIX_TRADING_MODE TradingMode()
     {
      return m_config.trading_mode;
     }

   void SetTradingMode(ENUM_PHOENIX_TRADING_MODE mode)
     {
      m_config.trading_mode = mode;
     }

   //+------------------------------------------------------------------+
   //| Automatic trading                                                |
   //+------------------------------------------------------------------+
   bool AutoTradingAllowed()
     {
      return m_config.allow_auto_trading;
     }

   void SetAutoTrading(bool enabled)
     {
      m_config.allow_auto_trading = enabled;

      if(enabled)
         m_config.trading_mode = PHX_TRADING_AUTO;
      else
         m_config.trading_mode = PHX_TRADING_DISABLED;
     }

   //+------------------------------------------------------------------+
   //| Safe mode                                                        |
   //+------------------------------------------------------------------+
   bool SafeMode()
     {
      return m_config.safe_mode;
     }

   void SetSafeMode(bool enabled)
     {
      m_config.safe_mode = enabled;
     }

   //+------------------------------------------------------------------+
   //| Risk                                                             |
   //+------------------------------------------------------------------+
   double RiskPercent()
     {
      return m_config.risk_percent;
     }

   void SetRiskPercent(double value)
     {
      if(value < PHX_MIN_RISK_PERCENT)
         value = PHX_MIN_RISK_PERCENT;

      if(value > PHX_MAX_RISK_PERCENT)
         value = PHX_MAX_RISK_PERCENT;

      m_config.risk_percent = value;
     }

   //+------------------------------------------------------------------+
   //| Daily loss                                                       |
   //+------------------------------------------------------------------+
   double MaxDailyLossPercent()
     {
      return m_config.max_daily_loss_percent;
     }

   void SetMaxDailyLossPercent(double value)
     {
      if(value < 0.0)
         value = 0.0;

      if(value > PHX_MAX_DAILY_LOSS_PCT)
         value = PHX_MAX_DAILY_LOSS_PCT;

      m_config.max_daily_loss_percent = value;
     }

   //+------------------------------------------------------------------+
   //| Maximum drawdown                                                 |
   //+------------------------------------------------------------------+
   double MaxDrawdownPercent()
     {
      return m_config.max_drawdown_percent;
     }

   void SetMaxDrawdownPercent(double value)
     {
      if(value < 0.0)
         value = 0.0;

      if(value > PHX_MAX_DRAWDOWN_PCT)
         value = PHX_MAX_DRAWDOWN_PCT;

      m_config.max_drawdown_percent = value;
     }

   //+------------------------------------------------------------------+
   //| Position limit                                                   |
   //+------------------------------------------------------------------+
   int MaxTotalPositions()
     {
      return m_config.max_total_positions;
     }

   void SetMaxTotalPositions(int value)
     {
      if(value < 1)
         value = 1;

      if(value > PHX_MAX_POSITIONS)
         value = PHX_MAX_POSITIONS;

      m_config.max_total_positions = value;
     }

   //+------------------------------------------------------------------+
   //| Loss streak                                                      |
   //+------------------------------------------------------------------+
   int MaxConsecutiveLosses()
     {
      return m_config.max_consecutive_losses;
     }

   void SetMaxConsecutiveLosses(int value)
     {
      if(value < 1)
         value = 1;

      if(value > PHX_MAX_LOSS_STREAK)
         value = PHX_MAX_LOSS_STREAK;

      m_config.max_consecutive_losses = value;
     }

   //+------------------------------------------------------------------+
   //| Signal score                                                     |
   //+------------------------------------------------------------------+
   double MinimumSignalScore()
     {
      return m_config.minimum_signal_score;
     }

   void SetMinimumSignalScore(double value)
     {
      if(value < 0.0)
         value = 0.0;

      if(value > 100.0)
         value = 100.0;

      m_config.minimum_signal_score = value;
     }

   //+------------------------------------------------------------------+
   //| Multi-symbol                                                     |
   //+------------------------------------------------------------------+
   bool MultiSymbolEnabled()
     {
      return m_config.enable_multi_symbol;
     }

   void SetMultiSymbolEnabled(bool enabled)
     {
      m_config.enable_multi_symbol = enabled;
     }

   //+------------------------------------------------------------------+
   //| Primary symbols only                                            |
   //+------------------------------------------------------------------+
   bool PrimarySymbolsOnly()
     {
      return m_config.primary_symbols_only;
     }

   void SetPrimarySymbolsOnly(bool enabled)
     {
      m_config.primary_symbols_only = enabled;
     }

   //+------------------------------------------------------------------+
   //| Diagnostics                                                      |
   //+------------------------------------------------------------------+
   bool DiagnosticsEnabled()
     {
      return m_config.enable_diagnostics;
     }

   bool DetailedLoggingEnabled()
     {
      return m_config.enable_detailed_logging;
     }

   //+------------------------------------------------------------------+
   //| State persistence                                                |
   //+------------------------------------------------------------------+
   bool StatePersistenceEnabled()
     {
      return m_config.enable_state_persistence;
     }
  };

#endif // __PHOENIX_CONFIG_MQH__
//+------------------------------------------------------------------+