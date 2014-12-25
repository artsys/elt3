//+------------------------------------------------------------------+
//|                                               eFXO.SlosFiborg.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "2.10"
#property strict

//#define DEBUG5

string sPref="eSlosFiborg";

#define SAVE_EXPERT_INFO
struct expert_info_struct{
	int buy_cmd;
	int buy_ma_lvl;
	int buy_tf;
	double buy_pvt;
	int buy_level;
	
	int sell_cmd;
	int sell_ma_lvl;
	int sell_tf;
	double sell_pvt;
	int sell_level;
};
expert_info_struct expert_info;

struct signal_info{
   int		cmd;
   int		ma_lvl;
   int		tf;
   double	pvt;
   int		level;
};

signal_info last_signal_buy={-1,0,0,0};
signal_info last_signal_sell={-1,0,0,0};
signal_info signal={-1,0,0,0};

double gDymDeltaBuy=0;
double gDymDeltaSell=0;

int aFibo[200];
int StartFiboIndex=0;

void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

//+------------------------------------------------------------------+
//| INPUTS
//+------------------------------------------------------------------+
input bool useTWIX=false;
input int TPFix=500;
input int SLFix=500;
input double Lot=0.1;
input double Multy=3;
input bool useMulty=false;
input double Multy1=1;
input double Multy2=1;
input double Multy3=2;
input double Multy4=3;
input double Multy5=5;
input int DeltaMin=10;
input bool useSimpleMethod=false;

input int MaxNodes=100; //Кол. узлов в сетке

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


//+------------------------------------------------------------------+
//|EXP_EventMNGR                                                                  |
//+------------------------------------------------------------------+
void EXP_EventMNGR(int ti, int event){
   if(event==EVT_CLS){
      EXP_EventClosed(ti);
   }
}


//+------------------------------------------------------------------+
//|EXP_EventClosed                                                                  |
//+------------------------------------------------------------------+
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
	
	SetExpertInfo();
}

//+------------------------------------------------------------------+
//|SetExpertInfo                                                                  |
//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//|GetExpertInfo                                                                  |
//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//|  startext                                                                |
//+------------------------------------------------------------------+
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
            ,"\nddb="+DoubleToStr(gDymDeltaBuy,Digits)
            ,"\nlss.cmd="+last_signal_sell.cmd
            ,"\nlss.ma_lvl="+last_signal_sell.ma_lvl
				,"\nlss.pvt="+DoubleToStr(last_signal_sell.pvt,Digits)
            ,"\ndds="+DoubleToStr(gDymDeltaSell,Digits)
            );
            
}

//+------------------------------------------------------------------+
//|TralOrders                                                                  |
//+------------------------------------------------------------------+
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
      //TR_MoveOrder(AId_Get2(aTO,aI,i,OE_TI),(pr+dynDelta));
   }
}

//+------------------------------------------------------------------+
//|Autoopen                                                                  |
//+------------------------------------------------------------------+
void Autoopen(){
   signal_info signal=GetSignal();
   
   //+++++++++++++++++++++++++++++
   int _cmd=signal.cmd;
   
   if(_cmd<=-1)return;
   
   if(useTWIX){
   	if(signal.cmd==OP_BUYSTOP){
   		if(last_signal_buy.ma_lvl==signal.ma_lvl) return;
   	}else{
   		if(last_signal_sell.ma_lvl==signal.ma_lvl) return;
   	}
   }
   
   if(useTWIX){
   	_cmd=TR_GetReversOP(_cmd);
   }
   //+++++++++++++++++++++++++++++
   if(_cmd>-1){
      
      string f=OE_IP+"==1 AND "+OE_DTY+"=="+(((_cmd==OP_BUYSTOP))?OE_DTY_BUY:OE_DTY_SELL);
      SELECT(aTO,f); //выборка ордеров совы по заданному направлению.
      
      if(ROWS(aI)<=0){ //если в заданном направлении ордеров нет.
         double d[];
         double start_pr=iif((_cmd==OP_BUYSTOP),High[1],Low[1]);
         double dynDelta=iif((_cmd==OP_BUYSTOP),1,-1)*GetDynDelta((_cmd==OP_BUYSTOP)?OE_DTY_BUY:OE_DTY_SELL);
         
         if(_cmd==OP_BUYSTOP){
         	gDymDeltaBuy=dynDelta;
         }else{
         	gDymDeltaSell=dynDelta;
         }
         
         start_pr+=dynDelta*DynDeltaKoef;
         
         f=OE_IM+"==1 AND "+OE_DTY+"=="+(((_cmd==OP_BUYSTOP))?OE_DTY_BUY:OE_DTY_SELL);
     
         SELECT2(aTO,aI,f);//выборка всех позиций заданного направления.
   
         double _lot=Lot,_pr=0;
         int _lvl=0;
         
         if(ROWS(aI)>0){ //если есть позиции.
            if(Multy<=0){ 
            	return; //Усреднение отключено.
            }
            
            if(!useSimpleMethod){
            	if(MathAbs(signal.ma_lvl)<=MathAbs((signal.cmd==OP_BUYSTOP)?last_signal_buy.ma_lvl:last_signal_sell.ma_lvl)) return;
            }	
            
            AId_InsertSort2(aTO,aI,OE_OOT);
       
            _lvl=AId_Get2(aTO,aI,(ROWS(aI)-1),OE_LVL);
            _lot=AId_Get2(aTO,aI,(ROWS(aI)-1),OE_LOT);
           
           if(_lvl>=MaxNodes){
            	//Если количество уровней больше заданного, 
            	//то прервем выставление ордеров. 
            	return;
            }
            
            double _multy=Multy;
            if(useMulty){
            	if(_lvl==0) _multy=Multy1;
            	if(_lvl==1) _multy=Multy2;
            	if(_lvl==2) _multy=Multy3;
            	if(_lvl==3) _multy=Multy4;
            	if(_lvl>=4) _multy=Multy5;
            }
            
            _lvl++;
            _lot=_lot*_multy;
            _pr=AId_Get2(aTO,aI,(ROWS(aI)-1),OE_OOP);
            
            if(!useTWIX && _pr>0){
            	if(_cmd==OP_BUYSTOP){
            		if(start_pr>=_pr-DeltaMin*Point){
            			//Цена выставления усредняющего бай ордера 
            			//будет выше цены последней позиции сетки.
            			return;
            		}
            	}else{
            		if(start_pr<=_pr+DeltaMin*Point){
            			//Цена выставления усредняющего селл ордера 
            			//будет ниже цены последней позиции сетки.
            			return;
            		}
            	}
            }
            
         }else{ //если позиций нет
            if(signal.cmd==OP_BUYSTOP){
               last_signal_buy=GetEmptySignal();
            }else{
               last_signal_sell=GetEmptySignal();
            }
         }
         
         TR_SendPending_array(d,_cmd,start_pr,0,_lot,TPFix,SLFix);
         
         for(int i=0; i<ROWS(d);i++){
         	OE_setPBT(d[i],OE_LVL,_lvl);
         }
         
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