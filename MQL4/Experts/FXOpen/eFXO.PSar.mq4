//+------------------------------------------------------------------+
//|                                                    eFXO.PSar.mq4 |
//|                                                    DrJJ, artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "DrJJ, artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.00"
#property strict

#define EXP "eFXO.PSar"
#define OE_PTI OE_USR1
#define OE_LVL OE_USR2

input double SAR_Step=0.02;
input double SAR_Maximum=0.2;

#include <sysBase.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   B_Init(EXP);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit(EXP);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   startext(); 
  }
//+------------------------------------------------------------------+

void startext()export{
   B_Start();
   
   Autoopen();
}

void Autoopen(){
   double sar=SAR_get("",0,SAR_Step,SAR_Maximum,1);
   bool isUp=SAR_isUP("",0,SAR_Step,SAR_Maximum,1);
   int SAR_StartBar=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,1);
   datetime SAR_StartTime=Time[SAR_StartBar];
   
   string add_filter=" AND "+OE_OOT+">>"+(int)SAR_StartTime;
   
   int ty1=-1,ty2=-1;
   if(isUp){
      ty1=OP_BUY;
      ty2=OP_BUYSTOP;
   }else{
      ty1=OP_SELL;
      ty2=OP_SELLSTOP;
   }
   
   int cnt=CntTY(ty1,ty2,add_filter);
   
   if(cnt<=0){
      double d[];
      ArrayResize(d,0);
      TR_SendPending_array(d,ty2,sar,0,0.1,50,50);
   }
   Comment(add_filter,"\nsar=",sar);
}

int CntTY(int ty1=-1, int ty2=-1, string addF=""){
   int res=0;
   string f="";
   
   if(ty1==-1 && ty2==-1){
      return(ArrayRange(aTO,0));
   }
   
   if(ty2>-1){
      res=CntTY(ty2);
   }
   
   f=StringConcatenate("" 
      , OE_TY,"==",ty1
      , addF);
   
   SELECT(aTO,f);
   int rows=ROWS(aI);
   
   res+=rows;   
   return(res);
}

int SAR_getNearestChange(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   
   if(sy=="")sy=Symbol();
   bool isUP=SAR_isUP(sy,tf,step,maximum,shift);
   int bar=shift;
   while((isUP==SAR_isUP(sy,tf,step,maximum,bar) && bar<Bars)){
      bar++;
   }
   
   return(bar);
}

bool SAR_isUP(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   bool res=false;
   if(sy=="")sy=Symbol();
   double sar=SAR_get(sy,tf,step,maximum,shift);
   
   if(sar>=High[shift])res=true;
   return(res);
}

bool SAR_isDW(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   bool res=false;
   if(sy=="")sy=Symbol();
   double sar=SAR_get(sy,tf,step,maximum,shift);
   
   if(sar<=Low[shift])res=true;
   return(res);
}

double SAR_get(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   if(sy=="")sy=Symbol();
   return(iSAR(sy,tf,step,maximum,shift));
}