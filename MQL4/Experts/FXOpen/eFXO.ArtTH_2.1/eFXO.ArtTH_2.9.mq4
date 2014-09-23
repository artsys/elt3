//+------------------------------------------------------------------+
//|                                               eFXO.ArtTH_2.1.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "2.90"
#property strict

#define SAVE_EXPERT_INFO
struct expert_info_struct{
   double closed_profit;
};

expert_info_struct expert_info={0};

input string s1="===== MAIN =====";
input int LevelStep=10;	//Шаг между ордерами
input int TP=15; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=5; //Кол. уровней от позиции.
input int EQLevels=3; //Кол. екви уровней.
input double Lot=0.1;
input double Multy=2;
input bool UseParentLot=true;
 string e1="================";
 bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
 int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)
input string e2="================";
//Закрывать все ордера при достижении заданного профита.
input	bool FIXProfit_use=true;	
//Значение фиксированного профита для закрытия всех ордеров.
input	double FIXProfit_amount=10; 

//Глобальные переменные.
double gdFOP=0.0; //уровень открытия первого ордера.
double fix_profit=0;

//#define DEBUG4
//#define DEBUGERR


void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

#include <sysBase.mqh>

#define OE_MAIN OE_USR1
#define OE_LVLPR OE_USR2
#define OE_FOP OE_USR3
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   if(FIXProfit_use)bNeedDelClosed=false;
   
   B_Init("artTH");

   int rows=ROWS(aTO);
   if(rows<=0){
   return(0);
}
  
  gdFOP=aTO[0][OE_FOP];
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit("artTH");
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

void EXP_EventMNGR(int ti, int event){
   if(event==EVT_CLS){
//      EXP_EventClosed(ti);
   }
}


void startext(){
   DPRINT3(__FUNCTION__);
   TRAC_str="";
   if(ROWS(aTO)<=0){
      fix_profit=0;
      gdFOP=0;
   }
   
   B_Start("artTH");
   
   //Закрытие позиций
      //Фикс профит
      if(FIXProfit()){
         bNeedDelClosed=true;
         expert_info.closed_profit=0.0;
         DAIdPRINTALL5(aOE,"aOE after fix profit");
         return;
      }else{
         bNeedDelClosed=false;
      }
   
   //Открытие позиций
      //Проверка сетки
      TN();
      //Автооткрытие
      Autoopen();
      
   Comment(""
      ,"\ngdFOP="+gdFOP
      ,"\nFIXProfit=",fix_profit
      ,"\nexp.closed_profit=",expert_info.closed_profit
      ,"\naOE=",ROWS(aOE)
      ,"\naTO=",ROWS(aTO)
   );
}

void TN(){
   //Проверка видимой части сетки.
   
   //Проверка сетки в направлении
   
   //Выбираем все бай ордера.
   
   SELECT(aTO,OE_IM+"==1");
   DAIdPRINT3(aTO,aI,"IM_1");
   int rows=ROWS(aI);
   for(int i=0; i<rows; i++){
      int ti=AId_Get2(aTO,aI,i,OE_TI);
      DAIdPRINT3(aTO,aI,"TI="+ti);
      CheckNet(ti);
      CheckNet(ti,true);   
   }
   
}

void CheckNet(const int pti, const bool revers=false){
   SELECT(aTO,OE_TI+"=="+pti);
   int      pdty=    AId_Get2(aTO,aI,0,OE_DTY);
   int      pty=     AId_Get2(aTO,aI,0,OE_TY);
   double   pfoop=   AId_Get2(aTO,aI,0,OE_LVLPR);
   double   plot=    AId_Get2(aTO,aI,0,OE_LOT);
   
   int _op=1;
   int _dty=1;
   double _lvl_lot=0.0;
   
   int _start_counter=1;
   int _add_revers=0;
   
   if(revers){
      _start_counter=0;
      _add_revers=1;
   }
   
   for(int i=_start_counter; i<Levels; i++){
      
      if(pdty==OE_DTY_BUY){
         _op=1;
         _dty=OE_DTY_BUY;
         if(revers){
            _op=-1;
            _dty=OE_DTY_SELL;
         }
      }else{
         _op=-1;
         _dty=OE_DTY_SELL;
         if(revers){
            _op=1;
            _dty=OE_DTY_BUY;
         }
      }
      double _lvl_pr=pfoop+(i+_add_revers)*_op*(LevelStep*Point);
      
      int _cnt=0;
      if(_dty==OE_DTY_BUY){
         if(_lvl_pr>=gdFOP){
            _cnt=NormalizeDouble(((_lvl_pr-gdFOP)/Point),0)/LevelStep;
         }
      }else{
         if(_lvl_pr<gdFOP){
            _cnt=NormalizeDouble(((gdFOP-_lvl_pr)/Point),0)/LevelStep;
         }
      }
      
      if(_cnt>0){
         if(revers){
            _cnt--;
         }
         
         _lvl_lot=GetLvlLot(_cnt);
         if(_lvl_lot>10){
            MessageBox("lvl_lot="+_lvl_lot+" _cnt="+_cnt+" line"+__LINE__);
         }
      }else{
         if(UseParentLot){
            _lvl_lot=plot;
         }else{
            _lvl_lot=Lot;
         }
      }
      
      string f=OE_FOOP+"=="+_lvl_pr+" AND "+OE_DTY+"=="+_dty;
      SELECT(aTO,f);
      DAIdPRINT3(aTO,aI,f);
      if(ROWS(aI)<=0){
         double d[];
         int cmd=-1;
         if(_dty==OE_DTY_BUY){
            cmd=OP_BUYSTOP;
         }else{
            cmd=OP_SELLSTOP;
         }
         if(_lvl_lot>10){
            MessageBox("lvl_lot="+_lvl_lot+" "+__LINE__);
         }
         gsComment="PR"+(string)_lvl_pr+"PTI"+(string)pti;
         
         OE_aDataSetProp(OE_FOP,gdFOP);
         OE_aDataSetProp(OE_LVLPR,_lvl_pr);
         TR_SendPending_array(d,cmd,_lvl_pr,0,_lvl_lot,TP);
      }
      
   }
}

double GetLvlLot(int cnt){
   double res=Lot;
   
   for(int i=1;i<=cnt;i++){
      
      if(i%EQLevels==0){
         res*=Multy;
      }
   }
   
   return(res);
}

void Autoopen(){
   if(ArrayRange(aTO,0)>0){
      return; //Есть ордера принадлежащие советнику.
   }
   
   OE_aDataSetProp(OE_MAIN,1);
   int ti=TR_SendBUY(Lot);
   TR_ModifyTP(ti,TP,TR_MODE_PIP);
   SELECT(aTO,OE_TI+"=="+ti);
   int rows=ROWS(aI);
   if(rows<=0){
      return; //Почему то не нашли тикет в ордерах терминала.
   }
   gdFOP=AId_Get2(aTO,aI,0,OE_FOOP);
   
   int idx_OE=OE_FIBT(ti);
   OE_aDataSetProp(OE_FOP,gdFOP);
   OE_aDataSetProp(OE_LVLPR,gdFOP);
   OE_aDataSetInOE(idx_OE);
}

bool FIXProfit(){
	/**
		\version	0.0.0.1
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Закрытие ордеров при достижении фикс профита.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.08@artamir	[]	FIXProfit
			>Rev:0
	*/
   zx
   DAIdPRINTALL4(aOE,"________");
	string fn="FIXProfit";
	
	if(!FIXProfit_use)return(false);
	
	T_Start();   
	int aI[]; ArrayResize(aI,0,1000);AId_Init2(aOE,aI);
	fix_profit=AId_Sum2(aOE,aI,OE_OPR)+expert_info.closed_profit;
	DPRINT2("fix_profit="+fix_profit);
	if(fix_profit<FIXProfit_amount){xz
	   SELECT2(aOE,aI,OE_IC+"==1"); 
	   DAIdPRINT4(aOE,aI,"aOE after select");
	   expert_info.closed_profit+=AId_Sum2(aOE,aI,OE_OPR);
	   OE_delClosed();
	   return(false);
	}
	
	DAIdPRINTALL5(aOE,"aOE before closeAll");
	CloseAllOrders();
	T_Start();
	OE_delClosed();
	expert_info.closed_profit=0;
	DAIdPRINTALL5(aOE, "aOE after closeALL");
	xz
	return(true);
}

void CloseAllOrders(){
   int rows=ROWS(aTO);
   for(int i=0; i<rows; i++){
      int ti=aTO[i][OE_TI];
      TR_CloseByTicket(ti);
      OE_setSTD(ti);
   }
   T_Start();
}