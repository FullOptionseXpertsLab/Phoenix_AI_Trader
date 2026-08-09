//+------------------------------------------------------------------+
//|                                             PhoenixConstants.mqh |
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Core Constants                                         |
//|  Version: Alpha 0.1.0                                            |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_CONSTANTS_MQH__
#define __PHOENIX_CONSTANTS_MQH__

//+------------------------------------------------------------------+
//| General system constants                                         |
//+------------------------------------------------------------------+
#define PHX_EMPTY_STRING           ""
#define PHX_INVALID_INT            (-1)
#define PHX_INVALID_DOUBLE         (-1.0)

#define PHX_TRUE                   true
#define PHX_FALSE                  false

//+------------------------------------------------------------------+
//| Time constants                                                   |
//+------------------------------------------------------------------+
#define PHX_SECONDS_PER_MINUTE     60
#define PHX_SECONDS_PER_HOUR       3600
#define PHX_SECONDS_PER_DAY        86400
#define PHX_SECONDS_PER_WEEK       604800

#define PHX_MINUTES_PER_HOUR       60
#define PHX_HOURS_PER_DAY          24
#define PHX_DAYS_PER_WEEK          7

//+------------------------------------------------------------------+
//| Default timer configuration                                      |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_TIMER_SECONDS  1

//+------------------------------------------------------------------+
//| Diagnostic constants                                             |
//+------------------------------------------------------------------+
#define PHX_DIAGNOSTIC_TIMEOUT_SEC 5

//+------------------------------------------------------------------+
//| Symbol scanning                                                  |
//+------------------------------------------------------------------+
#define PHX_MAX_SYMBOLS            64
#define PHX_MAX_PRIMARY_SYMBOLS    5

//+------------------------------------------------------------------+
//| Primary symbol priorities                                        |
//+------------------------------------------------------------------+
#define PHX_PRIMARY_PRIORITY_XAU   1
#define PHX_PRIMARY_PRIORITY_EUR   2
#define PHX_PRIMARY_PRIORITY_GBP   3
#define PHX_PRIMARY_PRIORITY_BTC   4
#define PHX_PRIMARY_PRIORITY_JPY   5

//+------------------------------------------------------------------+
//| Default confidence thresholds                                    |
//|                                                                  |
//| These are engine defaults, not user risk settings.               |
//+------------------------------------------------------------------+
#define PHX_MIN_SIGNAL_SCORE       60.0
#define PHX_STRONG_SIGNAL_SCORE    80.0

//+------------------------------------------------------------------+
//| Capital Health Index                                             |
//+------------------------------------------------------------------+
#define PHX_CHI_MIN                0.0
#define PHX_CHI_MAX                100.0

#define PHX_CHI_NORMAL_MIN         90.0
#define PHX_CHI_CAUTION_MIN        70.0
#define PHX_CHI_REDUCED_MIN        40.0
#define PHX_CHI_RESTRICTED_MIN     20.0

//+------------------------------------------------------------------+
//| Default risk boundaries                                          |
//|                                                                  |
//| These are deliberately conservative foundation limits.           |
//| Final user-configurable risk settings will live in Config.       |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_RISK_PERCENT   0.35
#define PHX_MIN_RISK_PERCENT       0.05
#define PHX_MAX_RISK_PERCENT       2.00

//+------------------------------------------------------------------+
//| Daily loss protection defaults                                   |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_DAILY_LOSS_PCT 2.00
#define PHX_MAX_DAILY_LOSS_PCT     5.00

//+------------------------------------------------------------------+
//| Drawdown protection defaults                                     |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_DRAWDOWN_PCT   5.00
#define PHX_MAX_DRAWDOWN_PCT       15.00

//+------------------------------------------------------------------+
//| Loss streak protection                                           |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_MAX_LOSS_STREAK 3
#define PHX_MAX_LOSS_STREAK         10

//+------------------------------------------------------------------+
//| Exposure protection                                              |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_MAX_POSITIONS   3
#define PHX_MAX_POSITIONS            20

//+------------------------------------------------------------------+
//| Spread protection                                                |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_MAX_SPREAD_POINTS  50
#define PHX_MAX_SPREAD_POINTS          5000

//+------------------------------------------------------------------+
//| Execution protection                                             |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_MAX_SLIPPAGE_POINTS  20
#define PHX_MAX_SLIPPAGE_POINTS          500

//+------------------------------------------------------------------+
//| Minimum account balance target                                   |
//|                                                                  |
//| IMPORTANT: This does NOT guarantee that $10 is sufficient to      |
//| trade every symbol. Broker margin/volume constraints are checked. |
//+------------------------------------------------------------------+
#define PHX_MIN_TARGET_CAPITAL       10.0

//+------------------------------------------------------------------+
//| Minimum operational balance warning                              |
//+------------------------------------------------------------------+
#define PHX_MICRO_CAPITAL_THRESHOLD  100.0

//+------------------------------------------------------------------+
//| Trading pause durations                                          |
//+------------------------------------------------------------------+
#define PHX_DEFAULT_COOLDOWN_MINUTES 30
#define PHX_MAX_COOLDOWN_MINUTES     1440

//+------------------------------------------------------------------+
//| Logging                                                           |
//+------------------------------------------------------------------+
#define PHX_LOG_MAX_MESSAGE_LENGTH   1024
#define PHX_LOG_MAX_BUFFER_ENTRIES   500

//+------------------------------------------------------------------+
//| Internal identifiers                                              |
//+------------------------------------------------------------------+
#define PHX_MAGIC_BASE               26080901
#define PHX_MAGIC_XAU                26080911
#define PHX_MAGIC_EUR                26080912
#define PHX_MAGIC_GBP                26080913
#define PHX_MAGIC_BTC                26080914
#define PHX_MAGIC_JPY                26080915

//+------------------------------------------------------------------+
//| File / persistence constants                                     |
//+------------------------------------------------------------------+
#define PHX_DATA_FOLDER              "Phoenix_AI_Trader"
#define PHX_LOG_FOLDER               "Phoenix_AI_Trader\\Logs"
#define PHX_DATA_FILE_PREFIX         "PHX_"

//+------------------------------------------------------------------+
//| Numerical safety                                                 |
//+------------------------------------------------------------------+
#define PHX_EPSILON                 0.00000001
#define PHX_PERCENT_FACTOR          0.01

//+------------------------------------------------------------------+
//| Mathematical constants                                           |
//+------------------------------------------------------------------+
#define PHX_PI                      3.14159265358979323846

#endif // __PHOENIX_CONSTANTS_MQH__
//+------------------------------------------------------------------+