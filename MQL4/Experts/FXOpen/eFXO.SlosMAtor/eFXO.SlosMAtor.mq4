//+------------------------------------------------------------------+
//|                                               eFXO.SlosMAtor.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.00"
#property strict

//#define DEBUG5

struct signal_info{
   int cmd;
   int ma_lvl;
};
signal_info last_signal_buy={-1,0};
signal_info last_signal_sell={-1,0};

#define SAVE_EXPERT_INFO
struct expert_info_struct{
	int buy_cmd;
	int buy_ma_lvl;
	int sell_cmd;
	int sell_ma_lvl;
};


expert_info_struct expert_info={-1,0,-1,0};

void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

//+------------------------------------------------------------------+
//| INPUTS
//+------------------------------------------------------------------+
input int TPFix=500;
input int SLFix=500;
input double Lot=0.1;
input double Multy=3;
input bool useDeltaLoss=true;
input double DeltaLoss=100;

input int MAPeriod=50;
input ENUM_MA_METHOD MAMethod=MODE_SMA;
input ENUM_APPLIED_PRICE MAAppPrice=PRICE_CLOSE;

input string MALevels="50;-50;100;-100;200;-200;300;-300";

input bool useDynDelta=false; //use Dynamic delta

#include <eFXO.SlosTraling.mqh>
//#include <sysBase.mqh>

input bool     STR_Use=true;  //Slos traling
input int      STR_PosAmount=2; //Positions amount
input int      STR_PriceStart=250; //Price start
input int      STR_PriceStep=100; //Price step
input double   STR_SLKoef=0.5; //SL koef

input int      STR_XStepsBefore=2; //XStepsBefore     
input double   STR_SLKoefMinus=0.1; //SLKoefMinus
input double   STR_SLMinimum=0.1; //SLMin

//+------------------------------------------------------------------+
//| INCLUDE
//+------------------------------------------------------------------+
#include <sysBase.mqh>

//+------------------------------------------------------------------+
//| DEFINES
//+------------------------------------------------------------------+
#define OE_LVL OE_USR1

//+------------------------------------------------------------------+
//| GLOBAL VARS
//+------------------------------------------------------------------+
bool isNewBar=true;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   B_Init("SlosMator");
   last_signal_buy.cmd=expert_info.buy_cmd;
   last_signal_buy.ma_lvl=expert_info.buy_ma_lvl;
   last_signal_sell.cmd=expert_info.sell_cmd;
   last_signal_sell.ma_lvl=expert_info.sell_ma_lvl;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   expert_info.buy_cmd=last_signal_buy.cmd;
   expert_info.buy_ma_lvl=last_signal_buy.ma_lvl;
   expert_info.sell_cmd=last_signal_sell.cmd;
   expert_info.sell_ma_lvl=last_signal_sell.ma_lvl;
   
   B_Deinit("SlosMator");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   eFXOSlosTraling_Use(STR_Use);
   eFXOSlosTraling_PosAmount(STR_PosAmount);
   eFXOSlosTraling_PriceStart(STR_PriceStart);
   eFXOSlosTraling_PriceStep(STR_PriceStep);
   eFXOSlosTraling_SLKoef(STR_SLKoef);
   eFXOSlosTraling_MN(TR_MN);
   
   eFXOSlosTraling_XStepsBefore(STR_XStepsBefore);
   eFXOSlosTraling_SLKoefMinus(STR_SLKoefMinus);
   eFXOSlosTraling_SLMinimum(STR_SLMinimum);
   
   eFXOSlosTraling_startext();

   startext();   
}
//+------------------------------------------------------------------+

void EXP_EventMNGR(int ti, int event){
   if(event==EVT_CLS){
      //EXP_EventClosed(ti);
   }
}

void startext(){
   B_Start("SlosMator");
   
   fIsNewBar();
   
   TralOrders();
   
   Autoopen();
   
   Comment("\nlsb.cmd="+last_signal_buy.cmd
            ,"\nlsb.ma_lvl="+last_signal_buy.ma_lvl
            ,"\nlss.cmd="+last_signal_sell.cmd
            ,"\nlss.ma_lvl="+last_signal_sell.ma_lvl
            );
}

void TralOrders(){
   if(!isNewBar) return;
   
   string f=OE_IP+"==1";
   SELECT(aTO,f);
   for(int i=0;i<ROWS(aI);i++){
      double pr=0;
      OE_DIRECTION dty=AId_Get2(aTO,aI,i,OE_DTY);
      if(dty==OE_DTY_BUY){
         pr=High[1];
      }else{
         pr=Low[1];
      }
      double dynDelta=((dty==OE_DTY_BUY)?1:-1)*GetDynDelta(dty);
      dynDelta+=dynDelta*0.1;
      TR_MoveOrder(AId_Get2(aTO,aI,i,OE_TI),(pr+dynDelta));
   }
}

void Autoopen(){
   signal_info signal=GetSignal();
   
   if(signal.cmd>-1){
      
      string f=OE_IP+"==1 AND "+OE_DTY+"=="+((signal.cmd==OP_BUYSTOP)?OE_DTY_BUY:OE_DTY_SELL);
      SELECT(aTO,f);
      
      if(ROWS(aI)<=0){
         double d[];
         double start_pr=iif(signal.cmd==OP_BUYSTOP,High[1],Low[1]);
         double dynDelta=iif(signal.cmd==OP_BUYSTOP,1,-1)*GetDynDelta((signal.cmd==OP_BUYSTOP)?OE_DTY_BUY:OE_DTY_SELL);
         start_pr+=dynDelta;
         
         f=OE_IM+"==1 AND "+OE_DTY+"=="+((signal.cmd==OP_BUYSTOP)?OE_DTY_BUY:OE_DTY_SELL);
         DAIdPRINTALL5(aTO,"before select2 "+f);
         SELECT2(aTO,aI,f);
         DAIdPRINT5(aTO,aI,"after select2 "+f);
         double _lot=Lot;
         if(ROWS(aI)>0){
            DPRINT5("sig.ma_lvl="+signal.ma_lvl);
            
            if(!useDeltaLoss||!SimpleOpens(signal.cmd)){
            	if(MathAbs(signal.ma_lvl)<=MathAbs((signal.cmd==OP_BUYSTOP)?last_signal_buy.ma_lvl:last_signal_sell.ma_lvl)) return;
            }
            
            AId_InsertSort2(aTO,aI,OE_LOT);
            _lot=AId_Get2(aTO,aI,(ROWS(aI)-1),OE_LOT);
            _lot=_lot*Multy;
         }else{
            if(signal.cmd==OP_BUYSTOP){
               last_signal_buy=GetEmptySignal();
            }else{
               last_signal_sell=GetEmptySignal();
            }
         }
         
         TR_SendPending_array(d,signal.cmd,start_pr,0,_lot,TPFix,SLFix);
         
         if(signal.cmd==OP_BUYSTOP){
           last_signal_buy=signal;
         }else{
           last_signal_sell=signal;
         }
      }
   }
}

bool SimpleOpens(int ty){
	bool res=false;
	
	int dty=(ty==OP_BUYSTOP)?OE_DTY_BUY:OE_DTY_SELL;
	
	SELECT(aTO,OE_DTY+"=="+dty);
	int rows=ROWS(aI);
	if(rows>0){
		AId_InsertSort2(aTO,aI,OE_OOP);
		double oop=(dty==OE_DTY_BUY)
							?(AId_Get2(aTO,aI,0,OE_OOP))
							:(AId_Get2(aTO,aI,rows-1,OE_OOP));
		res=(dty==OE_DTY_BUY)
					?(Bid<oop-DeltaLoss*Point)
					:(Bid>oop+DeltaLoss*Point);					
	}
	
	return(res);
}

double GetDynDelta(OE_DIRECTION dty){
   if(!useDynDelta)return(0);
   
   double res=0;
   double sum=0;
   int cnt=0;
   //Print("dty="+dty);
   for(int i=1;i<100;i++){
      double pr1=0,pr2=0;
      if(dty==OE_DTY_BUY){
         if(High[i]>High[i+1]){
            sum+=High[i]-High[i+1];
            cnt++;
         }
      }else{
         if(Low[i]<Low[i+1]){
            sum+=Low[i+1]-Low[i];
            cnt++;
         }
      }
   }   
   
   if(sum>0){
      res=sum/cnt;
   }
   //Print("dynDelta="+DoubleToStr(res,Digits)+" sum="+DoubleToStr(sum,Digits));
   return(res);
}

signal_info GetEmptySignal(){
   signal_info empty={-1,0};
   
   return(empty);
}

signal_info GetSignal(){
   signal_info sig=GetEmptySignal();
   
   double ma=iMA(NULL,0,MAPeriod,0,MAMethod,MAAppPrice,1);
   
   string asMALvl[];
   ArrayResize(asMALvl,0);
   StringToArrayString(asMALvl,MALevels,";");
   
   int rows=ROWS(asMALvl);
   for(int i=0;i<rows;i++){
      string sMALvl=asMALvl[i];
      int iMALvl=StringToInteger(sMALvl);
      double dMALvl=ma+iMALvl*Point;
      if(iMALvl!=0){
         if(High[1]>dMALvl && Low[1]<dMALvl){
            if(iMALvl<0){
               sig.cmd=OP_BUYSTOP;
            }else{
               sig.cmd=OP_SELLSTOP;
            }
            sig.ma_lvl=iMALvl;
         }
      }
   }
   
   return(sig);
}

void fIsNewBar(){
   static datetime last_bar_open;
   
   if(Time[0]>last_bar_open){
      isNewBar=true;
      last_bar_open=Time[0];
   }else{
      isNewBar=false;
   }
}