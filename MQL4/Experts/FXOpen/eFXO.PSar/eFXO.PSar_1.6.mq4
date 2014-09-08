//+------------------------------------------------------------------+
//|                                                    eFXO.PSar.mq4 |
//|                                                    DrJJ, artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "DrJJ, artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.6"
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
input int    Spread_BuyStop=200;
input int    Spread_SellStop=50;
input string h2="Fixed value of tp/sl";
input int    TPFix=200;
input int    SLFix=200;
input string i1="=== PSAR PROPERTIES ===";
input double SAR_Step=0.02;
input double SAR_Maximum=0.2;

void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

#include <sysBase.mqh>

datetime dtNearestSarChange=0;
int      iNearestSarChangeBar=Bars;
int      iLastTiStart=Bars;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   bNeedDelClosed=false;
    int err=GetLastError();
    Print("err1=",err);
   B_Init(EXP);
    err=GetLastError();
    Print("err2=",err);
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
   B_Start(EXP);
   SAR_Traling();
   Traling_TPSL();
   //CheckEvents();
   Autoopen();
   
   int start_bar=GetFirstOpenBar();
   
   int iBarDelHistory=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,start_bar+1);
   OE_DelBeforeDatetime(Time[iBarDelHistory]);
   
   Comment("iNearestSarChangeBar=",iNearestSarChangeBar
         ,"\ndtNearestSarChange=",dtNearestSarChange
         ,"\niLastTiStart=",iLastTiStart
         ,"\naOE=",ROWS(aOE)
         ,"\naTO=",ROWS(aTO));
}

int GetFirstOpenBar(){
   int res=Bars;
   int aI[];
   AId_Init2(aTO,aI);
   AId_InsertSort2(aTO,aI,OE_FOOT);
   if(ROWS(aI)>0){
      res=iBarShift(NULL,0,AId_Get2(aTO,aI,0,OE_FOOT));   
   }
   
   return(res);
}

void EXP_EventMNGR(int ti, int event){
   if(event==EVT_CLS){
      EXP_EventClosed(ti);
   }
}

void EXP_EventClosed(int ti){
   int cls_ty=OE_getPBT(ti,OE_CTY);
   if(cls_ty==OE_CLOSED_BY_TP){
      CheckChild(ti);
   }
}

void SetNearestSarChange(){
   iNearestSarChangeBar=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,0);
   dtNearestSarChange=Time[iNearestSarChangeBar]; 
}

void Traling_TPSL(){
   double sar=SAR_get("",0,SAR_Step,SAR_Maximum,0);
   bool isUP=SAR_isUP("",0,SAR_Step,SAR_Maximum,0);
   
   int typ=-1;
   int add_spread=0;
   if(isUP){
      typ=OP_SELL;
      if(Spread_BuyStop==-1){
         sar+=MarketInfo(NULL,MODE_SPREAD)*Point;
      }else{
         sar+=Spread_BuyStop*Point;
      }
   }else{
      typ=OP_BUY;
      if(Spread_SellStop==-1){
         sar-=MarketInfo(NULL,MODE_SPREAD)*Point;
      }else{
         sar-=Spread_SellStop*Point;
      }
   }
   
   string f=(string)OE_TY+"=="+(string)typ;
   SELECT(aTO,f);
   
   int rows=ROWS(aI);
   for(int i=0; i<rows; i++){
      int ti=AId_Get2(aTO,aI,i,OE_TI);
      TR_ModifySL(ti,sar,TR_MODE_PRICE);
   }
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
   
   DAIdPRINTALL2(aOE, __FUNCTION__+"______________");
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
   DAIdPRINTALL2(aOE,__FUNCTION__+"_________");
   bool isUP=SAR_isUP("",0,SAR_Step,SAR_Maximum,0);
   int SAR_StartBar=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,0);
   double sar=SAR_get("",0,SAR_Step,SAR_Maximum,0);
   
   int tyo=-1, add_spread=0;;
   if(isUP){
      tyo=OP_BUYSTOP;
      if(Spread_BuyStop==-1){
         add_spread=MarketInfo(Symbol(),MODE_SPREAD);
      }else{
         add_spread=Spread_BuyStop;
      }
      
      sar+=add_spread*Point;
   }
   else{
      tyo=OP_SELLSTOP;
      if(Spread_SellStop==-1){
         add_spread=MarketInfo(Symbol(),MODE_SPREAD);
      }else{
         add_spread=Spread_SellStop;
      }
      sar-=add_spread*Point;
   }   
   
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
   DAIdPRINTALL2(aOE,__FUNCTION__+"__________");
   double sar=SAR_get("",0,SAR_Step,SAR_Maximum,0);
   bool isUp=SAR_isUP("",0,SAR_Step,SAR_Maximum,0);
   int SAR_StartBar=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,0);
   DPRINT2("SAR_StartBar="+SAR_StartBar);
   datetime SAR_StartTime=Time[SAR_StartBar];
   
   string add_filter=" AND "+OE_FOOT+">>"+(int)SAR_StartTime;
   
   int ty1=-1,ty2=-1, add_spread=0;
   if(isUp){
      ty1=OP_BUY;
      ty2=OP_BUYSTOP;
      if(Spread_BuyStop==-1){
         add_spread=MarketInfo(Symbol(),MODE_SPREAD);
      }else{
         add_spread=Spread_BuyStop;
      }
   }else{
      ty1=OP_SELL;
      ty2=OP_SELLSTOP;
      if(Spread_SellStop==-1){
         add_spread=MarketInfo(Symbol(),MODE_SPREAD);
      }else{
         add_spread=Spread_SellStop;
      }
   }
   
   int cnt=CntTY(ty1,ty2,add_filter);
   
   if(cnt<=0){
      int pti=0, pty=-1, plevel=0;
      double plot=0;
      
      double send_lot=0;
      
      int last_tickets_start=SAR_getNearestChange("",0,SAR_Step,SAR_Maximum,SAR_StartBar+1);
      iLastTiStart=last_tickets_start;
      int aI[];
      add_filter=" AND "+OE_OOP+"<<"+(int)dtNearestSarChange;
      GetLastTI(aI,last_tickets_start,add_filter);;
      int rows=ROWS(aI);
      if(rows>0){
         pti=AId_Get2(aOE,aI,(rows-1),OE_TI);
         pty=AId_Get2(aOE,aI,(rows-1),OE_TY);
         plot=AId_Get2(aOE,aI,(rows-1),OE_LOT);
         plevel=AId_Get2(aOE,aI,(rows-1),OE_LVL);
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
      
      TR_SendPending_array(d,ty2,sar,add_spread,send_lot,TPFix,SLFix);
      
      OE_aDataErase();
      OE_bAutoEraseOEData=true;
   }
}

void GetLastTI(int &aI[], int start_bar, string add_filter=""){
   DAIdPRINTALL2(aOE,__FUNCTION__+"_________");
   ArrayResize(aI,0);
   datetime start_time=Time[start_bar];
   string f=StringConcatenate(""
            , OE_FOOT,">>",(int)start_time
            , add_filter);
   SELECT2(aOE,aI,f);  
   AId_InsertSort2(aOE,aI,OE_FOOT);       
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
   
   if(shift>Bars){
      return(false);
   }
   
   double sar=SAR_get(sy,tf,step,maximum,shift);
 
   if(sar>=(High[shift]+Low[shift])/2)res=true;
   return(res);
}

bool SAR_isDW(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   bool res=false;
   
   if(shift>Bars){
      return(false);
   }
   
   if(sy=="")sy=Symbol();
   double sar=SAR_get(sy,tf,step,maximum,shift);
   
   if(sar<=(High[shift]-Low[shift])/2)res=true;
   return(res);
}

double SAR_get(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   if(sy=="")sy=Symbol();
   return(iSAR(sy,tf,step,maximum,shift));
}

//} -----------------------------------------------------------------------------