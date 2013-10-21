//+------------------------------------------------------------------+
//|                                                PcntTradeSize.mq4 |
//|                         Copyright © 2011, T Black and Associates |
//|                                    http://winnersedgetrading.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, T Black and Associates"
#property link      "http://winnersedgetrading.com"

double PcntTradeSize(string symbol,int PipRisk,double Pcnt,int NumOfPos=1,bool FixedAmt=false,int Diagnose=1)
   {
   double AcctAmt;
   double TradeSize;
   double Multiplier=Pcnt/100;
   int   FiveDig;
   string Version="v1.13";
   
   if(Digits==5||Digits==3)
      FiveDig = 10;
   else
      FiveDig = 1;
   
   if(Diagnose > 1)
      {
      Print("---PcntTradeSize() AccountBalance()=",AccountBalance(),", AccountEquity()=",AccountEquity(),", MODE_TICKVALUE=",MarketInfo(symbol,MODE_TICKVALUE));
      Print("---PcntTradeSize() MODE_MAXLOT=",MarketInfo(symbol,MODE_MAXLOT),", MODE_MINLOT=",MarketInfo(symbol,MODE_MINLOT),", MODE_LOTSTEP=",MarketInfo(symbol,MODE_LOTSTEP));
      }  //if(Diagnose)
      
   // Use lower of AccountBalanc() & AccountEquity()
   if(AccountBalance() <= AccountEquity())
      AcctAmt = AccountBalance();
   else
      AcctAmt = AccountEquity();
   if(Diagnose > 1)
      Print("---PcntTradeSize() AcctAmt=",AcctAmt,", Multiplier=",Multiplier,", PipRisk=",PipRisk);
   if(!FixedAmt)   
      TradeSize = AcctAmt*Multiplier/PipRisk/(MarketInfo(symbol,MODE_TICKVALUE)*FiveDig);
   else
      TradeSize = Pcnt/PipRisk/(MarketInfo(symbol,MODE_TICKVALUE)*FiveDig);
   if(Diagnose > 1)
      Print("---PcntTradeSize() Interim TradeSize=",TradeSize,", NumOfPos=",NumOfPos);
   TradeSize = TradeSize / NumOfPos;
   if(Diagnose > 1)
      Print("PcntTradeSize() - Initial TradeSize=",TradeSize);
   
   if(TradeSize > MarketInfo(symbol,MODE_MAXLOT))
      TradeSize = MarketInfo(symbol,MODE_MAXLOT);
   if(TradeSize < MarketInfo(symbol,MODE_MINLOT))
      TradeSize = MarketInfo(symbol,MODE_MINLOT);
      
//   Print("TickValue=",MarketInfo(symbol,MODE_TICKVALUE),", LotStep=",MarketInfo(symbol,MODE_LOTSTEP)); 
//   Print("Before=",TradeSize); 
   
   TradeSize = MathRound(TradeSize / MarketInfo(symbol,MODE_LOTSTEP) - 0.5);
   
   TradeSize = TradeSize * MarketInfo(symbol,MODE_LOTSTEP);
   
   if(Diagnose > 0)
      Print("PcntTradeSize() ",Version," ",symbol," Calc Trade Size=",TradeSize,", PipRisk=",PipRisk,", Acct Pcnt=",Pcnt); 
   
   //Normalize TradeSize
   NormalizeDouble(TradeSize,2);
   return(TradeSize);
   }  //double PcntTradeSize(string symbol,int PipRisk,double Pcnt,int NumOfPos=1,bool FixedAmt=false,bool Diagnose=false)