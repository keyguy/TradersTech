//+------------------------------------------------------------------+
//|                                                     SMACross.mq4 |
//|                                  Copyright 2013, T Black & Assoc |
//|                                    http://winnersedgetrading.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, T Black & Assoc"
#property link      "http://winnersedgetrading.com"
#include <MAXover.mqh>
#include <PcntTradeSize.mqh>

//--- input parameters
extern double    RiskPcnt=2.0;
extern int       MA1=3;
extern int       MA2=30;
extern int       SLPips=15;
extern int       TPPips=25;
extern int       TriggerTF=240;
extern bool      UseATR=true;
extern int       ATRTF=1440;
extern int       ATRBars=100;
extern double    ATRSLFactor=0.5;
extern double    ATRTPFactor=1.0;
extern int       MagicNumber=1234567;

static datetime LastTradeTime = 0;
double AdjPoint;   

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   int FiveDig;
   if(Digits == 5 || Digits == 3)
      FiveDig = 10;
   else
      FiveDig = 1;

   AdjPoint = Point * FiveDig;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
  
  
bool NewBar()
   {
   datetime CurrBarTime = iTime(NULL,TriggerTF,0);
   bool NewBar = false;
   if(CurrBarTime > LastTradeTime)
      {
      NewBar = true;
      }

   return(NewBar);
   }
    
    
bool IsThereAnOpenTrade()
   {
   bool OpenTrade = false;
   int i;
   for (i = 0; i < OrdersTotal(); i++)
      {
      OrderSelect(i,SELECT_BY_POS);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         {
         OpenTrade = true;
         break;
         }
      }
   return(OpenTrade);
   }
    
    
void OpenTrade(int TradeDir)
   {
   double TP,SL,TradeSize;
   int Ticket;
   bool ModifyResult;
   int SLNewPips,TPNewPips;
   double ATR;
   int ATRPips;

   TradeSize = PcntTradeSize(Symbol(),SLPips,RiskPcnt);
   
   if(UseATR)
      {
      ATR=iATR(NULL,ATRTF,ATRBars,0);  
      ATRPips = ATR / AdjPoint;
      SLNewPips = ATRPips * ATRSLFactor;
      TPNewPips = ATRPips * ATRTPFactor;    
      }  //if(UseATR)
   else
      {
      SLNewPips = SLPips;
      TPNewPips = TPPips;
      }  //else

   if(TradeDir == 1)  //Long Trade
      {
      TP = Bid + (TPNewPips * AdjPoint);
      SL = Bid - (SLNewPips * AdjPoint);
      while(IsTradeContextBusy())  //our loop for the busy trade context
         Sleep(100);  //sleep for 100 ms and test the trade context again
      RefreshRates();  //refreshing all the variables when the 
                      //trade context is no longer busy
      Print("Long Trade Price=",Ask,", SL=",SL,", TP=",TP,", Size=",TradeSize);
      Ticket = OrderSend(Symbol(),OP_BUY,NormalizeDouble(TradeSize,2),
                        NormalizeDouble(Ask,Digits),2.0,0.0,0.0,"Trade Comment",
                        MagicNumber,Blue);
      if(Ticket >= 0)
         {
         while(IsTradeContextBusy())
            Sleep(100);
         RefreshRates();
         OrderSelect(Ticket,SELECT_BY_TICKET);
         ModifyResult = OrderModify(Ticket,OrderOpenPrice(),
                                    NormalizeDouble(SL,Digits),
                                    NormalizeDouble(TP,Digits),0,Blue);
         if(!ModifyResult)
            Alert("Stop Loss and Take Profit not set on order ",Ticket);
         }  //if(Ticket >= 0)
      else
         {
         Alert("Trade Not Entered");
         }  //else
      }  //if(TradeDir == 1)
   if(TradeDir == -1)
      {
      TP = Ask - (TPNewPips * AdjPoint);
      SL = Ask + (SLNewPips * AdjPoint);
      while(IsTradeContextBusy())  //our loop for the busy trade context
         Sleep(100);  //sleep for 100 ms and test the trade context again
      RefreshRates();  //refreshing all the variables when the 
                      //trade context is no longer busy
      Print("Short Trade Price=",Bid,", SL=",SL,", TP=",TP,", Size=",TradeSize);
      Ticket = OrderSend(Symbol(),OP_SELL,NormalizeDouble(TradeSize,2),
                        NormalizeDouble(Bid,Digits),2.0,0.0,0.0,"Trade Comment",
                        MagicNumber,Blue);
      if(Ticket >= 0)
         {
         while(IsTradeContextBusy())
            Sleep(100);
         RefreshRates();
         OrderSelect(Ticket,SELECT_BY_TICKET);
         ModifyResult = OrderModify(Ticket,OrderOpenPrice(),
                                    NormalizeDouble(SL,Digits),
                                    NormalizeDouble(TP,Digits),0,Blue);
         if(!ModifyResult)
            Alert("Stop Loss and Take Profit not set on order ",Ticket);
         }  //if(Ticket >= 0)
      else
         {
         Alert("Trade Not Entered");
         }  //else
      }  //if(TradeDir == -1)
   }  //void OpenTrade()     
            
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
   {
   int CrossOver;
   if(!IsThereAnOpenTrade())
      {
      //Enter code that executes if there is no open trade here.
      CrossOver = MAXover(MODE_SMA,TriggerTF,MA1,MA2,0,0);
      if(CrossOver != 0)
         {
         //Enter code that executes if there is a crossover
         if(NewBar())
           {
           //Set LastTradeTime to iTime(NULL,0,0)
           LastTradeTime = iTime(NULL,TriggerTF,0);
           //Enter code to trigger a trade
           OpenTrade(CrossOver);
           }
         }
      }
   }
//+------------------------------------------------------------------+