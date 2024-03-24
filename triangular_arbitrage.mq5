//+------------------------------------------------------------------+
//|                                                   abitrage_1.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include<Trade\Trade.mqh>
 
CTrade trade;
ulong ticket1;
ulong ticket2;
ulong ticket3;
bool test = false;
bool order = false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double Ask_EU = NormalizeDouble(SymbolInfoDouble("EURUSD", SYMBOL_ASK), _Digits);
   double Bid_EU = NormalizeDouble(SymbolInfoDouble("EURUSD", SYMBOL_BID), _Digits);
   double Ask_EG = NormalizeDouble(SymbolInfoDouble("EURGBP", SYMBOL_ASK), _Digits);
   double Bid_EG = NormalizeDouble(SymbolInfoDouble("EURGBP", SYMBOL_BID), _Digits);
   double Ask_GU = NormalizeDouble(SymbolInfoDouble("GBPUSD", SYMBOL_ASK), _Digits);
   double Bid_GU = NormalizeDouble(SymbolInfoDouble("GBPUSD", SYMBOL_BID), _Digits);
   
   double calculation_1 = Ask_EU / Bid_GU;
   double calculation_2 = Ask_EU / Bid_EG;
   double calculation_3 = Ask_EG / Bid_GU;
   
   if (PositionsTotal() == 0 && ((calculation_1 > Ask_EG + 0.005) || (calculation_2 > Ask_GU + 0.005) || (calculation_3 > Ask_EU + 0.005)) && test == false)
   {
      ticket1 = trade.Sell(1, "EURUSD", Bid_EU, 0, 0, "BOT");
      ticket2 = trade.Buy(1, "EURGBP", Ask_EG, 0, 0, "BOT");
      ticket3 = trade.Buy(NormalizeDouble(Ask_GU,2), "GBPUSD", Bid_GU, 0, 0, "BOT");
   }
   
   if ((AccountInfoDouble(ACCOUNT_EQUITY) - AccountInfoDouble(ACCOUNT_BALANCE) > 100) || test == true)
   {
      for(int i = 0; i < PositionsTotal(); i++)
      {
        // Get the ticket number of the position
        ulong ticket = PositionGetTicket(i);
      
        // Close the position by its ticket number
        trade.PositionClose(ticket);
      }
      
      if (PositionsTotal() == 0)
      {
         test = false;
      } else
      {
         test = true;
      }
   }
   
  }
//+------------------------------------------------------------------+
