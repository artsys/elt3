//+------------------------------------------------------------------+
//|                                              iCandlesPropHBL.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.10"
#property strict
#property indicator_chart_window

enum CANDLE_PROP{
   CP_HIGH=0,
   CP_BODY=1,
   CP_LOW=2,
};
//--- input parameters
input int      AVG_Period=15;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   double h=iCustom(Symbol(),0,"iCandleProp2Os",AVG_Period,"",CP_HIGH,true,0,1);
   double b=iCustom(Symbol(),0,"iCandleProp2Os",AVG_Period,"",CP_BODY,true,0,1);
   double l=iCustom(Symbol(),0,"iCandleProp2Os",AVG_Period,"",CP_LOW,true,0,1);
   
   string s="";
   
   int bw=f_iGetBodyBW(1);
   s=bw==1?"1":"0";
   s=s+f_sGetBody(bw,b)+f_sGetShadowUp(h)+f_sGetShadowDw(l);
   
   Comment(    "HIGH="+DoubleToStr(h,2)+"\n"
            +  "BODY="+DoubleToStr(b,2)+"\n"
            +  "LOW="+DoubleToStr(l,2)+"\n"
            +  "CODE="+s);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

int f_iGetBodyBW(int n=1){
   int s=0;
   if(Open[n]<Close[n]) s=1;
   else s=0;
   
   return(s);
}

string f_sGetBody(const int bw, const double prc){
   string s="";
   
   if(prc==0){
      //отсутствует тело
      if(bw==1){s=s+"00";}else{s=s+"11";}
   }   
   if(prc>0&&prc<30){
      //малое тело
      if(bw==1){s=s+"01";}else{s=s+"10";}
   }   
   if(prc>30&&prc<70){
      //срденее тело
      if(bw==1){s=s+"10";}else{s=s+"01";}
   }   
   if(prc>70){   
      //большое тело
      if(bw==1){s=s+"11";}else{s=s+"00";}
   }
   
   return(s);
}

string f_sGetShadowUp(const double prc){
   string s="";
   
   if(prc==0){
      //отсутствует тень
      s=s+"00";
   } 
   
   if(prc>0 && prc<30){
      //малая тень
      s=s+"01";
   } 
   
   if(prc>30 && prc<70){
      //средняя тень
      s=s+"10";
   } 
    
   if(prc>70){
      //большая тень
      s=s+"11";
   }  
   
   return(s);
}

string f_sGetShadowDw(const double prc){
   string s="";
   
   if(prc==0){
      //отсутствует тень
      s=s+"11";
   } 
   
   if(prc>0 && prc<30){
      //малая тень
      s=s+"10";
   } 
   
   if(prc>30 && prc<70){
      //средняя тень
      s=s+"01";
   } 
    
   if(prc>70){
      //большая тень
      s=s+"00";
   }  
   
   return(s);
}
