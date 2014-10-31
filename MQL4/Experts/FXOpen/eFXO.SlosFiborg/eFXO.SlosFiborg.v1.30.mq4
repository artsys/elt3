//+------------------------------------------------------------------+
//|                                               eFXO.SlosFiborg.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.30"
#property strict

//#define DEBUG5

string sPref="eSlosFiborg";

#define SAVE_EXPERT_INFO
struct expert_info_struct{};
expert_info_struct expert_info;

struct signal_info{
   int cmd;
   int ma_lvl;
   int tf;
};

signal_info last_signal_buy={-1,0,0};
signal_info last_signal_sell={-1,0,0};

int aFibo[200];
int StartFiboIndex=0;

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
//Если Multy <=0 тогда считаем, что усреднение отключено.
//input string IndicatorFolder="FXOpen";
input ENUM_TIMEFRAMES TFPivot=PERIOD_D1;
input int MaxLevels=10;
input int StartLevel=21;

input bool useDynDelta=false; //use Dynamic delta

input bool drawPVT=false;

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
	B_Init("FXO.SlosFiborg");
   if(Multy<=0){
   	Print("Усреднение отключено!");
   }
   
   TR_bUseColors=true;
   
   CalcFiboLevels();
   
   int i=1;
   while(StartLevel>aFibo[i]){
   	i++;
   }
   
   StartFiboIndex=i-1;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit("FXO.SlosFiborg");
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
      EXP_EventClosed(ti);
   }
}

void EXP_EventClosed(int ti){
	int _dty=OE_getPBT(ti,OE_DTY);
	string f=OE_IP+"==1 AND "+OE_DTY+"=="+_dty;
	int aI[];
	SELECT2(aTO,aI,f);
	
	int r_ord=ROWS(aI);
	if(r_ord>0){
		int aIP[];
		f=OE_IM+"==1 AND "+OE_DTY+"=="+_dty;
		SELECT2(aTO,aIP,f);
		int r_pos=ROWS(aIP);
		
		if(r_pos>0){
			return; // у нас еще есть рыночные ордера
		}
		
		for(int i=0;i<r_ord;i++){
			TR_CloseByTicket(AId_Get2(aTO,aI,i,OE_TI));
		}
		
		if(_dty==OE_DTY_BUY){
			last_signal_buy=GetEmptySignal();
		}else{
			last_signal_sell=GetEmptySignal();
		}
	}else{
		int aIP[];
		f=OE_IM+"==1 AND "+OE_DTY+"=="+_dty;
		SELECT2(aTO,aIP,f);
		int r_pos=ROWS(aIP);
		
		if(r_pos<=0){
			if(_dty==OE_DTY_BUY){
				last_signal_buy=GetEmptySignal();
			}else{
				last_signal_sell=GetEmptySignal();
			}
		}	
	}
}

void startext(){
   B_Start("FXO.SlosFiborg");
   
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
      
      TR_MoveOrderBetterPrice(AId_Get2(aTO,aI,i,OE_TI),(pr+dynDelta));
      //TR_MoveOrder(AId_Get2(aTO,aI,i,OE_TI),(pr+dynDelta));
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
            if(Multy<=0){ 
            	return; //Усреднение отключено.
            }
            	
            DPRINT5("sig.ma_lvl="+signal.ma_lvl);
            if(MathAbs(signal.ma_lvl)<=MathAbs((signal.cmd==OP_BUYSTOP)?last_signal_buy.ma_lvl:last_signal_sell.ma_lvl)) return;
            
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

int GetNextFibo(int thisFibo){
	int a=1,b=1,i=1;
	while(b<thisFibo+1){
		b=a+b;
		a=b-a;
		i++;
	}
	return(b);
}

void DrawTLine(string Name, datetime dtTime1, double dPr1, datetime dtTime2, double dPr2, int w=1){
	if(ObjectFind(Name)<=-1){
		ObjectCreate(Name,OBJ_TREND,0,dtTime1,dPr1,dtTime2,dPr2);
	}
	
	ObjectSet(Name,OBJPROP_TIME1,dtTime1);
	ObjectSet(Name,OBJPROP_PRICE1,dPr1);
	ObjectSet(Name,OBJPROP_TIME2,dtTime2);
	ObjectSet(Name,OBJPROP_PRICE2,dPr2);
	ObjectSet(Name,OBJPROP_RAY,false);
	ObjectSet(Name,OBJPROP_WIDTH,w);
}

void DeleteObjects(){
	int t=ObjectsTotal();
	for(int i=t-1;i>=0;i--){
		string n=ObjectName(i);
		if(StringFind(n,sPref)>=0){
			ObjectDelete(n);
		}
	}
}

double GetPVT(){
	int start_bar=iBarShift(NULL,0,iTime(NULL,TFPivot,1));
	int end_bar=iBarShift(NULL,0,iTime(NULL,TFPivot,0));
	
	int cnt=start_bar-end_bar;
	int min_bar=iLowest(NULL,0,MODE_LOW,cnt,end_bar);
	int max_bar=iHighest(NULL,0,MODE_HIGH,cnt,end_bar);
	
	double _c=iClose(NULL,0,(end_bar+1));
	double _h=iHigh(NULL,0,max_bar);
	double _l=iLow(NULL,0,min_bar);
	
	double pvt=(_h+_l+_c)/3;
	string name=sPref+"#PVT#"+(int)Time[start_bar];
	if(drawPVT){
		DrawTLine(name,Time[end_bar],pvt,(Time[end_bar]+60*TFPivot),pvt,1);
	}
	
	return(pvt);
}

signal_info GetSignal(){
   signal_info sig=GetEmptySignal();
   
   double pvt=	GetPVT();//iCustom(NULL,0
   				//		,(IndicatorFolder=="")?"":(IndicatorFolder+"\\")+"iFXO.PivotAbsolutFibo",TFPivot,false,0,1);
   
   int rows=MaxLevels;
   int fibo=StartLevel-1;
   int dig=(Digits==3||Digits==5)?10:1;
   for(int i=0;i<rows;i++){
      
      fibo=aFibo[StartFiboIndex+i];//GetNextFibo(fibo);
     
     for(int j=0;j<2;j++){
     	fibo=-1*fibo;
      double dFiboLvl=pvt+fibo*(dig)*Point;
      if(fibo!=0){
         if(High[1]>dFiboLvl && Low[1]<dFiboLvl){
            if(fibo<0){
               sig.cmd=OP_BUYSTOP;
            }else{
               sig.cmd=OP_SELLSTOP;
            }
            sig.ma_lvl=fibo;
         }
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

void CalcFiboLevels(){
	for(int i=1;i<50;i++){
		if(i==1){
			aFibo[i]=1;
		}else{
			aFibo[i]=GetNextFibo(aFibo[i-1]);
		}	
	}
}