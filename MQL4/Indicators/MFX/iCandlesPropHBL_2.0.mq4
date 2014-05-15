//+------------------------------------------------------------------+
//|                                              iCandlesPropHBL.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "2.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1

enum CANDLE_PROP{
   CP_HIGH=0,
   CP_BODY=1,
   CP_LOW=2,
};
//--- input parameters
input int      AVG_Period=15;

double CodeBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,CodeBuffer);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2,clrAqua);
   
   SetIndexEmptyValue(0,0.0);
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
   if(rates_total<AVG_Period)return(0);
   
   int lim=rates_total-prev_calculated-1;
   if(lim<=0)lim=1;
   
   string comm="";
   
   for(int i=lim;i>0;i--){
   
      double h=iCustom(Symbol(),0,"iCandleProp2Os",AVG_Period,"",CP_HIGH,true,0,i);
      double b=iCustom(Symbol(),0,"iCandleProp2Os",AVG_Period,"",CP_BODY,true,0,i);
      double l=iCustom(Symbol(),0,"iCandleProp2Os",AVG_Period,"",CP_LOW,true,0,i);
   
      string s="";
      int rows=ArrayRange(open,0);
      int bw=f_iGetBodyBW(open[i],close[i]);
      s=bw==1?"1":"0";
      s=s+f_sGetBody(bw,b)+f_sGetShadowUp(h)+f_sGetShadowDw(l);
      
      int code=f_iCalcCode(s);
      
      CodeBuffer[i]=code;
      
      comm="HIGH="+DoubleToStr(h,2)+"\n"+  "BODY="+DoubleToStr(b,2)+"\n"+  "LOW="+DoubleToStr(l,2)+"\n"+  "CODE="+s+"\n"+"CODE="+code;
   
   }
   Comment(comm);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

int f_iCalcCode(string s){
   int res=0;
   
   int len=StringLen(s);
   for(int i=len-1;i>=0;i--){
      int c=StringGetChar(s,i);
      string a=StringSetChar("",0,c);
      int in=StringToInteger(a);
      int r=MathPow(2,(len-1)-i);
      
      res+=in*r;
   }
   
   return(res);
}

int f_iGetBodyBW(double o, double c){
   int s=0;
   if(o<c) s=1;
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

class CDebuggerFix { } ExtDebuggerFix;