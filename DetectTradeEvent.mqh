//+------------------------------------------------------------------+
//|                                             DetectTradeEvent.mqh |
//|                                  Copyright 2013, T Black & Assoc |
//|                                    http://winnersedgetrading.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, T Black & Assoc"
#property link      "http://winnersedgetrading.com"



int DetectTradeEvent(string PairName, int MagicNumber, datetime EntryTime, int Type)
   {
   int Status = 0;  //0 = No Event, -1 = New Short Trade, -2 = New Short Pending, 1 = New Long Trade, 2 = New Long Pending, 10 = Trade Closed
   int i,TotalOrders = OrdersTotal();
   bool OrderFound = false;
   int OType;
   
   for(i = 0; i < TotalOrders; i++)
      {
      OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol() == PairName && (MagicNumber == -1 || MagicNumber == OrderMagicNumber()))
         {
         OrderFound = true;
         
         if(OrderOpenTime() != EntryTime || OrderType() != Type)
            {
            OType = OrderType();
            if(OType == OP_SELLLIMIT || OType == OP_SELLSTOP)
               Status = -2;
            if(OType == OP_BUYLIMIT || OType == OP_BUYSTOP)
               Status = 2;
            if(OType == OP_SELL)
               Status = -1;
            if(OType == OP_BUY)
               Status = 1;
            }  //if(OrderOpenTime() != EntryTime || OrderType() != Type)
            
         break;
         }  //if(OrderSymbol() == PairName && (MagicNumber == -1 || MagicNumber == OrderMagicNumber()))
      }  //for(i = 0;i < TotalOrders;i++)
      
   if(Type != -1 && !OrderFound)  //Was expecting order and none found
      Status = 10;
   
   return(Status);
   }  //int DetectTradeEvent(string PairName, int MagicNumber, datetime EntryTime, int Type)
   