//+------------------------------------------------------------------+
//|                                               eFXO.SlosFiborg.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "2.00"
#property strict

//#define DEBUG5

string sPref="eSlosFiborg";

#define SAVE_EXPERT_INFO
struct expert_info_struct{
	int buy_cmd;
	int buy_ma_lvl;
	int buy_tf;
	double buy_pvt;
	double buy_lot;
	int buy_tralpips;
	double buy_price;
	
	int sell_cmd;
	int sell_ma_lvl;
	int sell_tf;
	double sell_pvt;
	double sell_lot; 
	double sell_tralpips;
	double sell_price;
};
expert_info_struct expert_info;

struct signal_info{
   int		cmd;
   int		ma_lvl;
   int		tf;
   double	pvt;
};

signal_info last_signal_buy={-1,0,0,0};
signal_info last_signal_sell={-1,0,0,0};
signal_info signal={-1,0,0,0};

double gDynDeltaBuy=0;
double gDynDeltaSell=0;

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

input bool	useTralLots=false;
input int	TralLots_pips=10;
input double TralLots_Plus=0.1;

input int DeltaMin=10;
input bool useSimpleMethod=false;
//≈сли Multy <=0 тогда считаем, что усреднение отключено.
//input string IndicatorFolder="FXOpen";
input ENUM_TIMEFRAMES TFPivot=PERIOD_D1;
input int MaxLevels=10;
input int StartLevel=21;

input bool useDynDelta=false; //use Dynamic delta
input double DynDeltaKoef=0.1; //Dynamic delta koef.

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
#define OE_LASTOOP OE_USR1

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
   	Print("”среднение отключено!");
   }
   
   TR_bUseColors=true;
   
   CalcFiboLevels();
   
   int i=1;
   while(StartLevel>aFibo[i]){
   	i++;
   }
   
   StartFiboIndex=i;
   
   GetExpertInfo();
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
   
   if(event==EVT_CHPR){
   	EXP_EventChangedPrice(ti);
   }
}

void EXP_EventChangedPrice(int ti){
	DAIdPRINTALL5(aTO,"___________");
	if(!useTralLots) return;
	
	SELECT(aTO,OE_TI+"=="+ti);
	if(ROWS(aI)<=0)return;
	
	double _oop=AId_Get2(aTO,aI,0,OE_OOP);
	double _last_oop=AId_Get2(aTO,aI,0,OE_LASTOOP);
	double _foop=AId_Get2(aTO,aI,0,OE_FOOP);
	OE_DIRECTION _dty=AId_Get2(aTO,aI,0,OE_DTY);
	
	if(_last_oop<=0){
		_last_oop=_foop;
	}
	
	int _pips=((_dty==OE_DTY_BUY)?(_last_oop-_oop):(_oop-_last_oop))/Point;
	DPRINT5("pips="+_pips);
	if(_pips<TralLots_pips) return;
	
	
	
	double d[];
	TR_SendSTOPLikeOrder_array(d,ti,0,1,TralLots_Plus);
	if(ROWS(d)>0)TR_CloseByTicket(ti);
	for(int i=0; i<ROWS(d); i++){
		int _ti=d[i];
		int idx=OE_FIBT(_ti);
		OE_setPBI(idx, OE_LASTOOP,_oop);
	}
	DAIdPRINTALL5(aTO,"__________");
}

void EXP_EventClosed(int ti){
	int _dty=OE_getPBT(ti,OE_DTY);
	int _ip=OE_getPBT(ti,OE_IP);
	if(_ip>=1)return;
	
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
	
	SetExpertInfo();
}

void SetExpertInfo(){
	expert_info.buy_cmd=last_signal_buy.cmd;
	expert_info.buy_ma_lvl=last_signal_buy.ma_lvl;
	expert_info.buy_pvt=last_signal_buy.pvt;
	expert_info.buy_tf=last_signal_buy.tf;
	
	expert_info.sell_cmd=last_signal_sell.cmd;
	expert_info.sell_ma_lvl=last_signal_sell.ma_lvl;
	expert_info.sell_pvt=last_signal_sell.pvt;
	expert_info.sell_tf=last_signal_sell.tf;
}

void GetExpertInfo(){
	last_signal_buy.cmd=expert_info.buy_cmd;
	last_signal_buy.ma_lvl=expert_info.buy_ma_lvl;
	last_signal_buy.pvt=expert_info.buy_pvt;
	last_signal_buy.tf=expert_info.buy_tf;
	
	last_signal_sell.cmd=expert_info.sell_cmd;
	last_signal_sell.ma_lvl=expert_info.sell_ma_lvl;
	last_signal_sell.pvt=expert_info.sell_pvt;
	last_signal_sell.tf=expert_info.sell_tf;
}

void startext(){
   B_Start("FXO.SlosFiborg");
   
   fIsNewBar();
   
   TralOrders();
   
   Autoopen();
   
   if(ROWS(aTO)<=0){
   	last_signal_buy=GetEmptySignal();
   	last_signal_sell=GetEmptySignal();
   }
   
   SetExpertInfo();
   
   Comment("\nlsb.cmd="+last_signal_buy.cmd
            ,"\nlsb.ma_lvl="+last_signal_buy.ma_lvl
            ,"\nlsb.pvt="+DoubleToStr(last_signal_buy.pvt,Digits)
            ,"\nddb="+DoubleToStr(gDynDeltaBuy,Digits)
            ,"\n\n"
            ,"\nb.price="+expert_info.buy_price
            ,"\n\n"
            ,"\nlss.cmd="+last_signal_sell.cmd
            ,"\nlss.ma_lvl="+last_signal_sell.ma_lvl
				,"\nlss.pvt="+DoubleToStr(last_signal_sell.pvt,Digits)
            ,"\ndds="+DoubleToStr(gDynDeltaSell,Digits)
            ,"\n\n"
            ,"\ns.price="+expert_info.sell_price
            ,"\n\n"
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
      dynDelta+=dynDelta*DynDeltaKoef;
      
      TR_MoveOrderBetterPrice(AId_Get2(aTO,aI,i,OE_TI),(pr+dynDelta));
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
         
         if(signal.cmd==OP_BUYSTOP){
         	gDynDeltaBuy=dynDelta;
         }else{
         	gDynDeltaSell=dynDelta;
         }
         
         start_pr+=dynDelta*DynDeltaKoef;
         
         f=OE_IM+"==1 AND "+OE_DTY+"=="+((signal.cmd==OP_BUYSTOP)?OE_DTY_BUY:OE_DTY_SELL);
         DAIdPRINTALL5(aTO,"before select2 "+f);
         SELECT2(aTO,aI,f);
         DAIdPRINT5(aTO,aI,"after select2 "+f);
         double _lot=Lot,_pr=0;
         if(ROWS(aI)>0){
            if(Multy<=0){ 
            	return; //”среднение отключено.
            }
            	
            DPRINT5("sig.ma_lvl="+signal.ma_lvl);
            
            if(!useSimpleMethod){
            	if(MathAbs(signal.ma_lvl)<=MathAbs((signal.cmd==OP_BUYSTOP)?last_signal_buy.ma_lvl:last_signal_sell.ma_lvl)) return;
            }	
            
            AId_InsertSort2(aTO,aI,OE_LOT);
            _lot=AId_Get2(aTO,aI,(ROWS(aI)-1),OE_LOT);
            _lot=_lot*Multy;
            _pr=AId_Get2(aTO,aI,(ROWS(aI)-1),OE_OOP);
            
            if(_pr>0){
            	if(signal.cmd==OP_BUYSTOP){
            		if(start_pr>=_pr-DeltaMin*Point){
            			//÷ена выставлени€ усредн€ющего бай ордера 
            			//будет выше цены последней позиции сетки.
            			return;
            		}
            	}else{
            		if(start_pr<=_pr+DeltaMin*Point){
            			//÷ена выставлени€ усредн€ющего селл ордера 
            			//будет ниже цены последней позиции сетки.
            			return;
            		}
            	}
            }
            
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
      		expert_info.buy_price=start_pr;
      		expert_info.buy_tralpips=0;
         }else{
        		last_signal_sell=signal;
        		expert_info.sell_price=start_pr;
      		expert_info.sell_tralpips=0;
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
   signal_info empty={-1,0,0,0};
   
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
   
   double pvt_buy=0;
   double pvt_sell=0;
   
   if(last_signal_buy.pvt>0 && !useSimpleMethod){
   	pvt_buy=last_signal_buy.pvt;
   }else{
   	pvt_buy=GetPVT();
   }
   
   if(last_signal_sell.pvt>0 && !useSimpleMethod){
   	pvt_sell=last_signal_sell.pvt;
   }else{
   	pvt_sell=GetPVT();
   }
   
   int rows=MaxLevels;
   int fibo=StartLevel-1;
   int dig=(Digits==3||Digits==5)?10:1;
   for(int i=0;i<rows;i++){
      
      fibo=aFibo[StartFiboIndex+i];//GetNextFibo(fibo);
     
     for(int j=0;j<2;j++){
     	double pvt=(j==0)?pvt_buy:pvt_sell;
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
            sig.pvt=pvt;
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