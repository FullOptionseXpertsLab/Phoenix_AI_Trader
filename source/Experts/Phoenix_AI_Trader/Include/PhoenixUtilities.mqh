//+------------------------------------------------------------------+
//|                                              PhoenixUtilities.mqh |
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Common Utility Functions                               |
//|  Version: Alpha 0.1.0                                            |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_UTILITIES_MQH__
#define __PHOENIX_UTILITIES_MQH__

#include "PhoenixConstants.mqh"
#include "PhoenixTypes.mqh"

//+------------------------------------------------------------------+
//| Utility class                                                     |
//+------------------------------------------------------------------+
class CPhoenixUtilities
  {
public:

   //+------------------------------------------------------------------+
   //| Check numeric value                                             |
   //+------------------------------------------------------------------+
   static bool IsValidNumber(double value)
     {
      return MathIsValidNumber(value) &&
             value != EMPTY_VALUE;
     }

   //+------------------------------------------------------------------+
   //| Clamp double value                                              |
   //+------------------------------------------------------------------+
   static double Clamp(
      double value,
      double minimum,
      double maximum
   )
     {
      if(value < minimum)
         return minimum;

      if(value > maximum)
         return maximum;

      return value;
     }

   //+------------------------------------------------------------------+
   //| Clamp integer value                                             |
   //+------------------------------------------------------------------+
   static int ClampInt(
      int value,
      int minimum,
      int maximum
   )
     {
      if(value < minimum)
         return minimum;

      if(value > maximum)
         return maximum;

      return value;
     }

   //+------------------------------------------------------------------+
   //| Percentage to money                                             |
   //+------------------------------------------------------------------+
   static double PercentToMoney(
      double base_amount,
      double percent
   )
     {
      return base_amount * percent * PHX_PERCENT_FACTOR;
     }

   //+------------------------------------------------------------------+
   //| Money to percentage                                             |
   //+------------------------------------------------------------------+
   static double MoneyToPercent(
      double base_amount,
      double money
   )
     {
      if(base_amount <= 0.0)
         return 0.0;

      return (money / base_amount) * 100.0;
     }

   //+------------------------------------------------------------------+
   //| Calculate drawdown percentage                                   |
   //+------------------------------------------------------------------+
   static double CalculateDrawdownPercent(
      double peak_equity,
      double current_equity
   )
     {
      if(peak_equity <= 0.0)
         return 0.0;

      if(current_equity >= peak_equity)
         return 0.0;

      return ((peak_equity - current_equity) /
              peak_equity) * 100.0;
     }

   //+------------------------------------------------------------------+
   //| Normalize price                                                 |
   //+------------------------------------------------------------------+
   static double NormalizePrice(
      double price,
      int digits
   )
     {
      if(digits < 0)
         digits = 0;

      return NormalizeDouble(price,digits);
     }

   //+------------------------------------------------------------------+
   //| Normalize volume according to broker rules                     |
   //+------------------------------------------------------------------+
   static double NormalizeVolume(
      string symbol,
      double volume
   )
     {
      double minimum =
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);

      double maximum =
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);

      double step =
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);

      if(minimum <= 0.0 ||
         maximum <= 0.0 ||
         step <= 0.0)
         return 0.0;

      if(volume < minimum)
         return 0.0;

      volume = MathMin(volume,maximum);

      double steps =
         MathFloor((volume - minimum) / step + 0.5);

      double normalized =
         minimum + steps * step;

      normalized =
         MathMax(minimum,
                 MathMin(maximum,normalized));

      return NormalizeDouble(
         normalized,
         VolumeDigits(step)
      );
     }

   //+------------------------------------------------------------------+
   //| Determine volume decimal digits                                |
   //+------------------------------------------------------------------+
   static int VolumeDigits(double step)
     {
      if(step <= 0.0)
         return 2;

      int digits = 0;

      while(digits < 8 &&
            MathAbs(step - NormalizeDouble(step,digits)) > PHX_EPSILON)
        {
         digits++;
        }

      return digits;
     }

   //+------------------------------------------------------------------+
   //| Calculate risk money                                            |
   //+------------------------------------------------------------------+
   static double CalculateRiskMoney(
      double balance,
      double risk_percent
   )
     {
      if(balance <= 0.0 ||
         risk_percent <= 0.0)
         return 0.0;

      return PercentToMoney(
         balance,
         risk_percent
      );
     }

   //+------------------------------------------------------------------+
   //| Calculate price distance                                        |
   //+------------------------------------------------------------------+
   static double PriceDistance(
      double price_a,
      double price_b
   )
     {
      return MathAbs(price_a - price_b);
     }

   //+------------------------------------------------------------------+
   //| Price distance in points                                        |
   //+------------------------------------------------------------------+
   static double PriceDistancePoints(
      string symbol,
      double price_a,
      double price_b
   )
     {
      double point =
         SymbolInfoDouble(symbol,SYMBOL_POINT);

      if(point <= 0.0)
         return 0.0;

      return PriceDistance(
         price_a,
         price_b
      ) / point;
     }

   //+------------------------------------------------------------------+
   //| Get symbol digits                                               |
   //+------------------------------------------------------------------+
   static int SymbolDigits(string symbol)
     {
      return (int)SymbolInfoInteger(
         symbol,
         SYMBOL_DIGITS
      );
     }

   //+------------------------------------------------------------------+
   //| Get symbol point                                                |
   //+------------------------------------------------------------------+
   static double SymbolPoint(string symbol)
     {
      return SymbolInfoDouble(
         symbol,
         SYMBOL_POINT
      );
     }

   //+------------------------------------------------------------------+
   //| Get bid                                                         |
   //+------------------------------------------------------------------+
   static double Bid(string symbol)
     {
      return SymbolInfoDouble(
         symbol,
         SYMBOL_BID
      );
     }

   //+------------------------------------------------------------------+
   //| Get ask                                                         |
   //+------------------------------------------------------------------+
   static double Ask(string symbol)
     {
      return SymbolInfoDouble(
         symbol,
         SYMBOL_ASK
      );
     }

   //+------------------------------------------------------------------+
   //| Calculate spread in points                                      |
   //+------------------------------------------------------------------+
   static double SpreadPoints(string symbol)
     {
      double bid = Bid(symbol);
      double ask = Ask(symbol);
      double point = SymbolPoint(symbol);

      if(bid <= 0.0 ||
         ask <= 0.0 ||
         point <= 0.0)
         return 0.0;

      return (ask - bid) / point;
     }

   //+------------------------------------------------------------------+
   //| Check if symbol is visible                                     |
   //+------------------------------------------------------------------+
   static bool IsSymbolVisible(string symbol)
     {
      if(!SymbolSelect(symbol,true))
         return false;

      return (bool)SymbolInfoInteger(
         symbol,
         SYMBOL_VISIBLE
      );
     }

   //+------------------------------------------------------------------+
   //| Check if symbol can be traded                                  |
   //+------------------------------------------------------------------+
   static bool IsSymbolTradeAllowed(string symbol)
     {
      long trade_mode =
         SymbolInfoInteger(
            symbol,
            SYMBOL_TRADE_MODE
         );

      return
         trade_mode != SYMBOL_TRADE_MODE_DISABLED &&
         trade_mode != SYMBOL_TRADE_MODE_CLOSEONLY;
     }

   //+------------------------------------------------------------------+
   //| Get broker symbol from candidate names                         |
   //+------------------------------------------------------------------+
   static string FindBrokerSymbol(
      string base_symbol
   )
     {
      //--- Exact match first
      if(SymbolSelect(base_symbol,true))
         return base_symbol;

      int total =
         SymbolsTotal(false);

      for(int i = 0; i < total; i++)
        {
         string candidate =
            SymbolName(i,false);

         if(candidate == "")
            continue;

         string upper_candidate =
            StringToUpper(candidate);

         string upper_base =
            StringToUpper(base_symbol);

         //--- Exact text contained in broker symbol
         if(StringFind(
               upper_candidate,
               upper_base
            ) >= 0)
           {
            return candidate;
           }
        }

      return "";
     }

   //+------------------------------------------------------------------+
   //| Find common priority symbol                                    |
   //+------------------------------------------------------------------+
   static string FindPrioritySymbol(
      ENUM_PHOENIX_SYMBOL_PRIORITY priority
   )
     {
      switch(priority)
        {
         case PHX_PRIORITY_PRIMARY_1:
            return FindBrokerSymbol("XAUUSD");

         case PHX_PRIORITY_PRIMARY_2:
            return FindBrokerSymbol("EURUSD");

         case PHX_PRIORITY_PRIMARY_3:
            return FindBrokerSymbol("GBPUSD");

         case PHX_PRIORITY_PRIMARY_4:
            return FindBrokerSymbol("BTCUSD");

         case PHX_PRIORITY_PRIMARY_5:
            return FindBrokerSymbol("USDJPY");
        }

      return "";
     }

   //+------------------------------------------------------------------+
   //| Detect account mode                                             |
   //+------------------------------------------------------------------+
   static ENUM_PHOENIX_ACCOUNT_MODE DetectAccountMode()
     {
      ENUM_ACCOUNT_TRADE_MODE mode =
         (ENUM_ACCOUNT_TRADE_MODE)
         AccountInfoInteger(
            ACCOUNT_TRADE_MODE
         );

      switch(mode)
        {
         case ACCOUNT_TRADE_MODE_DEMO:
            return PHX_ACCOUNT_DEMO;

         case ACCOUNT_TRADE_MODE_REAL:
            return PHX_ACCOUNT_REAL;

         case ACCOUNT_TRADE_MODE_CONTEST:
            return PHX_ACCOUNT_CONTEST;
        }

      return PHX_ACCOUNT_UNKNOWN;
     }

   //+------------------------------------------------------------------+
   //| Detect position accounting mode                                |
   //+------------------------------------------------------------------+
   static ENUM_PHOENIX_POSITION_MODE DetectPositionMode()
     {
      ENUM_ACCOUNT_MARGIN_MODE mode =
         (ENUM_ACCOUNT_MARGIN_MODE)
         AccountInfoInteger(
            ACCOUNT_MARGIN_MODE
         );

      switch(mode)
        {
         case ACCOUNT_MARGIN_MODE_RETAIL_NETTING:
         case ACCOUNT_MARGIN_MODE_EXCHANGE:
            return PHX_POSITION_MODE_NETTING;

         case ACCOUNT_MARGIN_MODE_RETAIL_HEDGING:
            return PHX_POSITION_MODE_HEDGING;
        }

      return PHX_POSITION_MODE_UNKNOWN;
     }

   //+------------------------------------------------------------------+
   //| Check if trading environment allows experts                   |
   //+------------------------------------------------------------------+
   static bool IsExpertTradingAllowed()
     {
      return
         (bool)TerminalInfoInteger(
            TERMINAL_TRADE_ALLOWED
         ) &&
         (bool)MQLInfoInteger(
            MQL_TRADE_ALLOWED
         );
     }

   //+------------------------------------------------------------------+
   //| Check account trade permission                                 |
   //+------------------------------------------------------------------+
   static bool IsAccountTradingAllowed()
     {
      return (bool)AccountInfoInteger(
         ACCOUNT_TRADE_ALLOWED
      );
     }

   //+------------------------------------------------------------------+
   //| Account balance                                                 |
   //+------------------------------------------------------------------+
   static double AccountBalance()
     {
      return AccountInfoDouble(
         ACCOUNT_BALANCE
      );
     }

   //+------------------------------------------------------------------+
   //| Account equity                                                  |
   //+------------------------------------------------------------------+
   static double AccountEquity()
     {
      return AccountInfoDouble(
         ACCOUNT_EQUITY
      );
     }

   //+------------------------------------------------------------------+
   //| Free margin                                                     |
   //+------------------------------------------------------------------+
   static double FreeMargin()
     {
      return AccountInfoDouble(
         ACCOUNT_MARGIN_FREE
      );
     }

   //+------------------------------------------------------------------+
   //| Calculate margin required for order                            |
   //+------------------------------------------------------------------+
   static double CalculateMargin(
      string symbol,
      ENUM_ORDER_TYPE order_type,
      double volume,
      double price
   )
     {
      double margin = 0.0;

      if(!OrderCalcMargin(
            order_type,
            symbol,
            volume,
            price,
            margin
         ))
        {
         return -1.0;
        }

      return margin;
     }

   //+------------------------------------------------------------------+
   //| Check sufficient margin                                         |
   //+------------------------------------------------------------------+
   static bool HasSufficientMargin(
      string symbol,
      ENUM_ORDER_TYPE order_type,
      double volume,
      double price
   )
     {
      double margin =
         CalculateMargin(
            symbol,
            order_type,
            volume,
            price
         );

      if(margin < 0.0)
         return false;

      return FreeMargin() >= margin;
     }

   //+------------------------------------------------------------------+
   //| Build account snapshot                                         |
   //+------------------------------------------------------------------+
   static SPhoenixAccountSnapshot
   BuildAccountSnapshot()
     {
      SPhoenixAccountSnapshot snapshot;

      snapshot.login =
         (long)AccountInfoInteger(
            ACCOUNT_LOGIN
         );

      snapshot.broker =
         AccountInfoString(
            ACCOUNT_COMPANY
         );

      snapshot.server =
         AccountInfoString(
            ACCOUNT_SERVER
         );

      snapshot.currency =
         AccountInfoString(
            ACCOUNT_CURRENCY
         );

      snapshot.balance =
         AccountBalance();

      snapshot.equity =
         AccountEquity();

      snapshot.margin =
         AccountInfoDouble(
            ACCOUNT_MARGIN
         );

      snapshot.free_margin =
         FreeMargin();

      snapshot.margin_level =
         AccountInfoDouble(
            ACCOUNT_MARGIN_LEVEL
         );

      snapshot.profit =
         AccountInfoDouble(
            ACCOUNT_PROFIT
         );

      snapshot.leverage =
         (long)AccountInfoInteger(
            ACCOUNT_LEVERAGE
         );

      snapshot.account_mode =
         DetectAccountMode();

      snapshot.position_mode =
         DetectPositionMode();

      snapshot.trade_allowed =
         IsAccountTradingAllowed();

      snapshot.expert_allowed =
         IsExpertTradingAllowed();

      snapshot.timestamp =
         TimeCurrent();

      return snapshot;
     }

   //+------------------------------------------------------------------+
   //| Build symbol context                                            |
   //+------------------------------------------------------------------+
   static SPhoenixSymbolContext
   BuildSymbolContext(string symbol)
     {
      SPhoenixSymbolContext context;

      context.symbol = symbol;
      context.broker_symbol = symbol;

      context.priority = 0;

      context.enabled = true;

      context.available =
         SymbolSelect(symbol,true);

      context.trade_allowed =
         IsSymbolTradeAllowed(symbol);

      context.priority_level =
         PHX_PRIORITY_CUSTOM;

      context.bid = Bid(symbol);
      context.ask = Ask(symbol);

      context.spread_points =
         SpreadPoints(symbol);

      context.point =
         SymbolInfoDouble(
            symbol,
            SYMBOL_POINT
         );

      context.tick_size =
         SymbolInfoDouble(
            symbol,
            SYMBOL_TRADE_TICK_SIZE
         );

      context.tick_value =
         SymbolInfoDouble(
            symbol,
            SYMBOL_TRADE_TICK_VALUE
         );

      context.contract_size =
         SymbolInfoDouble(
            symbol,
            SYMBOL_TRADE_CONTRACT_SIZE
         );

      context.volume_min =
         SymbolInfoDouble(
            symbol,
            SYMBOL_VOLUME_MIN
         );

      context.volume_max =
         SymbolInfoDouble(
            symbol,
            SYMBOL_VOLUME_MAX
         );

      context.volume_step =
         SymbolInfoDouble(
            symbol,
            SYMBOL_VOLUME_STEP
         );

      context.digits =
         SymbolDigits(symbol);

      context.stops_level =
         (int)SymbolInfoInteger(
            symbol,
            SYMBOL_TRADE_STOPS_LEVEL
         );

      context.freeze_level =
         (int)SymbolInfoInteger(
            symbol,
            SYMBOL_TRADE_FREEZE_LEVEL
         );

      context.market_regime =
         PHX_REGIME_UNKNOWN;

      context.session =
         PHX_SESSION_UNKNOWN;

      context.last_tick_time =
         0;

      context.last_analysis_time =
         0;

      return context;
     }

   //+------------------------------------------------------------------+
   //| Check minimum viable capital                                    |
   //+------------------------------------------------------------------+
   static bool IsMicroCapital()
     {
      return AccountBalance() <
             PHX_MICRO_CAPITAL_THRESHOLD;
     }

   //+------------------------------------------------------------------+
   //| Safe division                                                    |
   //+------------------------------------------------------------------+
   static double SafeDivide(
      double numerator,
      double denominator
   )
     {
      if(MathAbs(denominator) < PHX_EPSILON)
         return 0.0;

      return numerator / denominator;
     }

   //+------------------------------------------------------------------+
   //| Normalize percentage                                            |
   //+------------------------------------------------------------------+
   static double NormalizePercent(
      double value
   )
     {
      return Clamp(value,0.0,100.0);
     }

   //+------------------------------------------------------------------+
   //| Convert direction to order type                                 |
   //+------------------------------------------------------------------+
   static ENUM_ORDER_TYPE
   DirectionToOrderType(
      ENUM_PHOENIX_DIRECTION direction
   )
     {
      if(direction == PHX_DIRECTION_BUY)
         return ORDER_TYPE_BUY;

      if(direction == PHX_DIRECTION_SELL)
         return ORDER_TYPE_SELL;

      return WRONG_VALUE;
     }

   //+------------------------------------------------------------------+
   //| Convert order type to direction                                 |
   //+------------------------------------------------------------------+
   static ENUM_PHOENIX_DIRECTION
   OrderTypeToDirection(
      ENUM_ORDER_TYPE order_type
   )
     {
      if(order_type == ORDER_TYPE_BUY)
         return PHX_DIRECTION_BUY;

      if(order_type == ORDER_TYPE_SELL)
         return PHX_DIRECTION_SELL;

      return PHX_DIRECTION_NONE;
     }
  };

#endif // __PHOENIX_UTILITIES_MQH__
//+------------------------------------------------------------------+