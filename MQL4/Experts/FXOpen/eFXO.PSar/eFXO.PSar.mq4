//+------------------------------------------------------------------+
//|                                                    eFXO.PSar.mq4 |
//|                                                    DrJJ, artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "DrJJ, artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.10a"
#property strict

//#define DEBUG2

#define EXP "eFXO.PSar"
#define OE_PTI OE_USR1
#define OE_LVL OE_USR2

input string e1="=== EXPERT PROPERTIES ===";
input double Lot=0.1;
input double Multy=2;
input int    MaxLevel=10; //Максимальное колено
input string h1="Spread =-1: Спред вал. пары";
input int    Spread=-1;
input string i1="=== PSAR PROPERTIES ===";
input double SAR_Step=0.02;
input double SAR_Maximum=0.2;

#include <sysBase.mqh>

datetime dtNearestSarChange=0;
int      iNearestSarChangeBar=Bars;
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
   DAIdPRINTALL2(aOE,"startext________");
   SetNearestSarChange();
   B_Start();
   SAR_Traling();
   CheckEvents();
   Autoopen();
   
   Comment("iNearestSarChangeBar=",iNearestSarChangeBar);
}

void SetNearestSarChange(){
   iNearestSarChangeBar=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,0);
   dtNearestSarChange=Time[iNearestSarChangeBar]; 
}

void CheckEvents(){
   int events_cnt=ROWS(aE);
   for(int i=0; i<events_cnt;i++){
      int event=aE[i][E_EVT];
      int ti=aE[i][E_TI];
      
      if(event==EVT_CLS){
         int cls_ty=OE_getPBT(ti,OE_CTY);
         if(cls_ty==OE_CLOSED_BY_TP){
            CheckChild(ti);
         }
      }
   }
}

void CheckChild(int ti){
   string f=StringConcatenate(""
            ,OE_PTI,"==",ti
            ," AND "
            ,OE_TY,">>",1);
            
   SELECT(aTO,f);
   int cnt=ROWS(aI);
   if(cnt<=0)return;
   
   for(int i=0;i<cnt;i++){
      int child_ti=AId_Get2(aTO,aI,i,OE_TI);
      int child_ty=AId_Get2(aTO,aI,i,OE_TY);
      double _oop=AId_Get2(aTO,aI,i,OE_OOP);
      double _tp=AId_Get2(aTO,aI,i,OE_TP);
      double _sl=AId_Get2(aTO,aI,i,OE_SL);
      int lvl=1;
      
      TR_CloseByTicket(child_ti);
      
      OE_bAutoEraseOEData=false;
      OE_aDataErase();
      OE_aDataSetProp(OE_LVL,lvl);
      double d[];
      TR_SendPending_array(d,child_ty,_oop,0,Lot,_tp,_sl,"",-1,"",TR_MODE_PRICE);
      OE_aDataErase();
      OE_bAutoEraseOEData=true;
   }            
}

void SAR_Traling(){
   bool isUP=SAR_isUP("",0,SAR_Step,SAR_Maximum,0);
   int SAR_StartBar=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,0);
   double sar=SAR_get("",0,SAR_Step,SAR_Maximum,0);
   
   int tyo=-1, add_spread=0;;
   if(isUP){
      tyo=OP_BUYSTOP;
      if(Spread==-1){
         add_spread=MarketInfo(Symbol(),MODE_SPREAD);
      }else{
         add_spread=Spread;
      }
      
      sar+=add_spread*Point;
   }
   else tyo=OP_SELLSTOP;
   
   string add_filter=" AND "+OE_TY+"=="+tyo;
   int aI[];
   GetLastTI(aI,SAR_StartBar,add_filter);
   
   int cnt=ROWS(aI);
   if(cnt<=0) return;
   
   for(int i=0;i<cnt;i++){
      int ti=AId_Get2(aOE,aI,i,OE_TI);
      TR_MoveOrder(ti,sar,TR_MODE_PRICE);
   }   
}

void Autoopen(){
   double sar=SAR_get("",0,SAR_Step,SAR_Maximum,0);
   bool isUp=SAR_isUP("",0,SAR_Step,SAR_Maximum,0);
   int SAR_StartBar=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,0);
   datetime SAR_StartTime=Time[SAR_StartBar];
   
   string add_filter=" AND "+OE_OOT+">>"+(int)SAR_StartTime;
   
   int ty1=-1,ty2=-1, add_spread=0;
   if(isUp){
      ty1=OP_BUY;
      ty2=OP_BUYSTOP;
      if(Spread==-1){
         add_spread=MarketInfo(Symbol(),MODE_SPREAD);
      }else{
         add_spread=Spread;
      }
   }else{
      ty1=OP_SELL;
      ty2=OP_SELLSTOP;
   }
   
   int cnt=CntTY(ty1,ty2,add_filter);
   
   if(cnt<=0){
      int pti=0, pty=-1, plevel=0;
      double plot=0;
      
      double send_lot=0;
      
      int last_tickets_start=SAR_getNearestChange("",add_spread,SAR_Step,SAR_Maximum,SAR_StartBar);
      int aI[];
      string add_filter=" AND "+OE_OOP+"<<"+(int)dtNearestSarChange;
      GetLastTI(aI,last_tickets_start,add_filter);;
      int rows=ROWS(aI);
      if(rows>0){
         pti=AId_Get2(aOE,aI,0,OE_TI);
         pty=AId_Get2(aOE,aI,0,OE_TY);
         plot=AId_Get2(aOE,aI,0,OE_LOT);
         plevel=AId_Get2(aOE,aI,0,OE_LVL);
      }
      
      int lvl=plevel+1;
      send_lot=iif(plot>0,plot,Lot);
      
      if(lvl<=1 || lvl>MaxLevel){
         send_lot=Lot;
         lvl=1;
      }else{
         send_lot*=Multy;
      }
      
      OE_bAutoEraseOEData=false;
      OE_aDataErase();
      OE_aDataSetProp(OE_LVL,lvl);
      OE_aDataSetProp(OE_PTI, pti);
      double d[];
      ArrayResize(d,0);
      
      TR_SendPending_array(d,ty2,sar,0,send_lot,50,50);
      
      OE_aDataErase();
      OE_bAutoEraseOEData=true;
   }
   Comment(add_filter,"\nsar=",sar,"\nisUp=",isUp,"\ncnt=",cnt);
}

void GetLastTI(int &aI[], int start_bar, string add_filter=""){
   ArrayResize(aI,0);
   datetime start_time=Time[start_bar];
   string f=StringConcatenate(""
            , OE_OOT,">>",(int)start_time
            , add_filter);
   SELECT2(aOE,aI,f);         
}

int CntTY(int ty1=-1, int ty2=-1, string addF=""){
   int res=0;
   string f="";
   
   if(ty1==-1 && ty2==-1){
      return(ArrayRange(aTO,0));
   }
   
   if(ty2>-1){
      res=CntTY(ty2,-1,addF);
   }
   
   f=StringConcatenate("" 
      , OE_TY,"==",ty1
      , addF);
   
   SELECT(aTO,f);
   int rows=ROWS(aI);
   
   res+=rows;   
   return(res);
}


//{ === SAR ====================================================================
int SAR_getNearestChange(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   
   if(sy=="")sy=Symbol();
   bool isUP=SAR_isUP(sy,tf,step,maximum,shift);
   int bar=shift;
   while((isUP==SAR_isUP(sy,tf,step,maximum,bar) && bar<Bars)){
      bar++;
   }
   bar--;
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

//} -----------------------------------------------------------------------------