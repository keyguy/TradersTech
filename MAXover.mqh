//+------------------------------------------------------------------+
//|                                                      MAXover.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, T Black and Associates"
#property link      "http://winnersedgetrading.com" 

//MAXover() - return -1 for bearish cross, 1 for bullish cross, 0 for no cross
//MAtype 0=sma, 1=ema
//MAPer1 first moving average Period
//MAPer2 second moving average Period
//LookBack how many candles to look back for another cross
//MultiXMaxX how many crosses are acceptable in the look back

int MAXover(int MAType,int TF, int MAPer1,int MAPer2,int LookBack,int MultiXMaxX)
   {
   int  XOver=0;      //-1=bearish cross, 0=no cross, 1=bullish cross
   double MA1_CurrVal,MA2_CurrVal;
   double MA1_PrevVal,MA2_PrevVal;
   double MA1_LookBackVal,MA2_LookBackVal;
   int  CurrLoc=0;   //-1 = below both, 0=between, 1 = above both
   int  PrevLoc=0;
   int  LookBackLoc=0;
   int  i;
   int XCount;

   int FiveDig;
   double AdjPoint;
   if(Digits == 5 || Digits == 3)
      FiveDig = 10;
   else
      FiveDig = 1;

   AdjPoint = Point * FiveDig;
   
   //assign the vars
   MA1_CurrVal = iMA(NULL,TF,MAPer1,0,MAType,PRICE_CLOSE,1); //most recently closed candle
   MA2_CurrVal = iMA(NULL,TF,MAPer2,0,MAType,PRICE_CLOSE,1);
   MA1_PrevVal = iMA(NULL,TF,MAPer1,0,MAType,PRICE_CLOSE,2); //1st prior to most recently closed candle
   MA2_PrevVal = iMA(NULL,TF,MAPer2,0,MAType,PRICE_CLOSE,2);

   double GuardBand=0.1;
   //are we above?
   if(MathAbs(MA1_CurrVal - MA2_CurrVal) > GuardBand * AdjPoint)
      CurrLoc=0;
   else if(MA1_CurrVal > MA2_CurrVal) //yes we're above
      CurrLoc=1;
   else if(MA1_CurrVal < MA2_CurrVal) //No, below       
      CurrLoc=-1;    
   //Were we previously above    
   if(MathAbs(MA1_PrevVal - MA2_PrevVal) > GuardBand * AdjPoint)
      CurrLoc=0;
   else if(MA1_PrevVal > MA2_PrevVal) //yes we're above
      PrevLoc=1;
   else if(MA1_PrevVal < MA2_PrevVal) //no, below       
      PrevLoc=-1;    
   //cross?    
   if(PrevLoc == -1 && CurrLoc == 1)       
      XOver = 1;    
   else if(PrevLoc == 1 && CurrLoc == -1)       
      XOver = -1;    
   else       
      XOver = 0;           
   if(XOver != 0 && LookBack > 0) //check the lookbacks for no XOver - MA must be on same side for last "lookback" bars
      {
      XCount=0;
      for(i=3;i<LookBack+3;i++)          {          MA1_LookBackVal = iMA(NULL,0,MAPer1,0,MAType,PRICE_CLOSE,i);          MA2_LookBackVal = iMA(NULL,0,MAPer2,0,MAType,PRICE_CLOSE,i);                    if(MA1_LookBackVal > MA2_LookBackVal)
            LookBackLoc = 1;
         else if(MA1_LookBackVal < MA2_LookBackVal) //No, below
            LookBackLoc=-1;
         else
            LookBackLoc=0;

         if(PrevLoc != LookBackLoc)
            {
            XCount++;
            } // if(PrevLoc != LookBackLoc)
         } // for(i=3;i<LookBack+3;i++)          if(XCount>MultiXMaxX)
            XOver=0;
      } // if(XOver !=0)

   return(XOver);
   }