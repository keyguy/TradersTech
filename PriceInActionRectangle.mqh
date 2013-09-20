//+------------------------------------------------------------------+
//|                                       PriceInActionRectangle.mq4 |
//|                                  Copyright 2013, T Black & Assoc |
//|                                    http://winnersedgetrading.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, T Black & Assoc"
#property link      "http://winnersedgetrading.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2005

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);

// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex4"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

bool fPIARPriceInRect,fPIARPriceNearRect,fPIARTimeInRect;

string PriceInActionRectangle(color ActionColor=Blue,int NearRectPips=5,int TF=0)
   {
   int i,TotalObjects=ObjectsTotal();
   string name,RectName="";
   double Price1, Price2;
   datetime Time1, Time2;
   int FiveDig;
   double AdjPoint;
   
   if(Digits==5||Digits==3)
      FiveDig = 10;
   else
      FiveDig = 1;
   AdjPoint = Point * FiveDig;

   fPIARPriceInRect = false;
   fPIARPriceNearRect = false;
   for(i=0;i<TotalObjects;i++)
      {
      //first find if there are any action rectangles
      name = ObjectName(i);
      if(ObjectType(name) == OBJ_RECTANGLE && ObjectGet(name,OBJPROP_COLOR) == ActionColor)
         {
         //if there is, is price in it or near it?
         Price1 = ObjectGet(name,OBJPROP_PRICE1);
         Price2 = ObjectGet(name,OBJPROP_PRICE2);
         Time1 = ObjectGet(name, OBJPROP_TIME1);
         Time2 = ObjectGet(name,OBJPROP_TIME2);
         if(Price1 < Price2)
            {
            if(Price1 < Bid && Bid < Price2)
               fPIARPriceInRect = true;
            }  //if(Price1 < Price2)
         if(Price1 >= Price2)
            {
            if(Price2 < Bid && Bid < Price1)
               fPIARPriceInRect = true;
            }  //else
         //if not in it, near it?
         if(!fPIARPriceInRect && (MathAbs(Price1 - Bid) / AdjPoint < NearRectPips || MathAbs(Price2 - Bid) / AdjPoint < NearRectPips))
            fPIARPriceNearRect = true;
            
         //if there is, is time in it?
         if(Time1 < Time2)
            {
            if(Time1 < iTime(NULL,TF,0) < Time2)
               fPIARTimeInRect = true;
            }  //if(Time1 < Time2)
         if(Time1 >= Time2)
            {
            if(Time2 < iTime(NULL,TF,0) < Time1)
               fPIARTimeInRect = true;
            }  //else
         //if price is in or near, let's jump out and end this thing
         if((fPIARPriceInRect || fPIARPriceNearRect) && fPIARTimeInRect)
            {
            RectName = name;
            break;
            }  //if((fPIARPriceInRect || fPIARPriceNearRect) && fPIARTimeInRect)
         }  //if(ObjectGet(name,OBJPROP_COLOR))
      }  //for(i=0;i<TotalObjects;i++)
   
   return(RectName);
   }  //string PriceInActionRectangle(color ActionColor)