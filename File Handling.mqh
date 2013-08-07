//+------------------------------------------------------------------+
//|                                                File Handling.mq4 |
//|                                  Copyright 2013, T Black & Assoc |
//|                                    http://winnersedgetrading.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, T Black & Assoc"
#property link      "http://winnersedgetrading.com"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
  
  
bool ReadFile()
   {
   int h;
   int DFVersion;
   bool Success = false;
   
   Print("*** Reading Data File ",DataFileName," ***");
   h =  FileOpen(DataFileName,FILE_BIN|FILE_READ);
   
   if(h != -1)
      {
      //Data File Version
      DFVersion = FileReadInteger(h);
      if(DFVersion == DataFileVersion)
         {         
         //integer PairStatus
         PairStatus = FileReadInteger(h);
      
         //double LastPrice
         LastPrice = FileReadDouble(h);
      
         //boolean TradeLockedIn
         TradeLockedIn = FileReadInteger(h,1);
      
         //string PairName   
         PairName = FileReadString(h);
      
         //dateTime TradeTime
         TradeTime = FileReadInteger(h,4);
      
         FileClose(h);
         Success = true;
         }  //if(DFVersion == DataFileVersion)
      else
         Success = WriteFile(); 

      }  //if(Handle != -1)
   else
      Success = WriteFile();
      
   return(Success);
   }  //void ReadTradeFile()

  
bool WriteFile()
   {
   int h;
   bool Success = false;
   
   Print("***** Writing Data File ",DataFileName," ***");
   
   h =  FileOpen(DataFileName,FILE_BIN|FILE_WRITE);
   
   if(h != -1)
      {
      //Data File Version
      FileWriteInteger(h,DataFileVersion);
      
      //integer PairStatus
      FileWriteInteger(h,PairStatus);
      
      //double LastPrice
      FileWriteDouble(h,LastPrice);
      
      //boolean TradeLockedIn      
      FileWriteInteger(h,TradeLockedIn,1);
      
      //string PairName
      FileWriteString(h,PairName,StringLen(PairName));
      
      //datetime TradeTime
      FileWriteInteger(h,TradeTime,4);
      
      FileClose(h);
      Success = true;
      }  //if(Handle != -1)
   else
      Alert("Error Writing Data File ",DataFileName," Error:",GetLastError());
      
   return(Success);
   }  //void WriteTradeFile()
   
   
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+