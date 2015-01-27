//+------------------------------------------------------------------+
//|                                                 eFXO.NetStop.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.20"
#property strict

//#define DEBUG
//#define DEBUGERR
//+------------------------------------------------------------------+
//| Основные дефайны                                                 |
//+------------------------------------------------------------------+
#define SAVE_EXPERT_INFO
struct expert_info_struct{
	double buy_lot;
	double buy_tp;
	double buy_pr;
	double sell_lot;
	double sell_tp;
	double sell_pr;
	double start_pr;
	bool Autostart;
	double closed_profit;
};
expert_info_struct expert_info;

//+------------------------------------------------------------------+
//|INPUTS                                                                  |
//+------------------------------------------------------------------+
input int S=20; //Шаг сетки
input int TP=100; //Тейкпрофит
input double Lot=0.1;
input double Multy=2;
input double Plus=0;
input bool LotRevers=true;
input bool useFixProfit=true;
input double FixProfit_Amount=500;
input double TPOnRevers=10;


void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

//+------------------------------------------------------------------+
//|ИНКЛЮДЫ                                                          |
//+------------------------------------------------------------------+
#include <sysBase.mqh>


void EXP_EventMNGR(int ti, int event){
   if(event==EVT_CLS){
      EXP_EventClosed(ti);
   }
}

void EXP_EventClosed(int ti){
	if(!OrderSelect(ti,SELECT_BY_TICKET)) return;
	
	expert_info.closed_profit+=(OrderProfit()+OrderCommission());
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
	B_Init("NetStop");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
	//DAIdPRINTALL5(aTO,"aTO deinit");
   B_Deinit("NetStop");
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

void startext(){
	B_Start("NetStop");
	
	if(ROWS(aTO)<OrdersTotal()){
		//DAIdPRINTALL5(aTO,"aTO rows less than OrdersTotal");
		DBREACK;
	}
	
	if(ROWS(aTO)<=0){
		expert_info.start_pr=0;
		expert_info.buy_lot=0;
		expert_info.buy_tp=0;
		expert_info.buy_pr=expert_info.start_pr;
		expert_info.sell_lot=0;
		expert_info.sell_tp=0;
		expert_info.sell_pr=expert_info.start_pr;
		expert_info.Autostart=true;
		expert_info.closed_profit=0;
	}
	
	
	CheckNet(OE_DTY_BUY);
	
	CheckNet(OE_DTY_SELL);
	
	FixProfit();
	expert_info.Autostart=false;
	
	Comment(""
		,"\nClosed Profit=",DoubleToStr(expert_info.closed_profit,2)
		,"\nTotal profit=",DoubleToStr(GetTotalProfit(),2)
		,"\nROWS(aTO)=",ROWS(aTO)
		,"\nROWS(aOE)=",ROWS(aOE)
		,"\nGSP(BUY)=",DoubleToStr(GetStartPrice(OE_DTY_BUY),Digits)
		,"\nGSP(SELL)=",DoubleToStr(GetStartPrice(OE_DTY_SELL),Digits)
		);
}

void FixProfit(){
	if(!useFixProfit)return;
	
	double sum=GetTotalProfit();
	
	if(sum>=FixProfit_Amount){
		CloseAllTickets();
	}
}

void CloseAllTickets(){
	TR_CloseAll();
}

double GetTotalProfit(){
	int aI[];
	AId_Init2(aTO,aI);
	double sum=AId_Sum2(aTO,aI,OE_OPR)+expert_info.closed_profit;
	return(sum);
}

void CheckNet(OE_DIRECTION dty){
	double _start_pr=GetStartPrice(dty);
	DPRINT("start_pr="+_start_pr);
	double tp_pr=GetTPPrice(dty);
	DPRINT("tp_pr="+tp_pr);
	if(tp_pr==0){
		//DPRINT5("tp_pr="+tp_pr);
		DBREACK;
	}
	double koef=(dty==OE_DTY_BUY)?1:-1;	
	int cnt=MathAbs(((_start_pr-tp_pr)/Point)/S);
	for(int i=0; i<cnt; i++){
		double _lvl_pr=Norm_symb(_start_pr+koef*i*S*Point);
		CheckLevel(dty,_lvl_pr);
	}
}

void CheckLevel(OE_DIRECTION dty, double lvl_pr){
	string f=OE_DTY+"=="+dty+" AND "+OE_FOOP+"=="+lvl_pr;
	//DAIdPRINTALL5(aTO,"aTO before "+f);
	SELECT(aTO,f);
	//DAIdPRINT5(aTO,aI,"aTO after "+f);
	if(ROWS(aI)>0) return;
	
	int cmd=-1;
	double _tp=-1;
	//-----------------------------------
	if(dty==OE_DTY_BUY){
		cmd=OP_BUYSTOP;
		_tp=GetTPPrice(dty, lvl_pr);//expert_info.buy_tp;
	}else{
		cmd=OP_SELLSTOP;
		_tp=GetTPPrice(dty, lvl_pr);//expert_info.sell_tp;
	}
	double d[];
	TR_SendPending_array(d,cmd,lvl_pr,0,GetLot(dty,lvl_pr),_tp,0,"ns",-1,Symbol(),TR_MODE_PRICE);
}

double GetLot(OE_DIRECTION dty, double lvl_pr){
	double res=-1;
	if(dty==OE_DTY_BUY){
		if(lvl_pr<=expert_info.buy_pr){
			if(LotRevers){
				res=MathMax(expert_info.sell_lot,Lot);
			}else{
				res=MathMax(expert_info.buy_lot,Lot);
			}	
		}else{
			res=MathMax(expert_info.buy_lot,Lot);
		}
	}else{
		if(lvl_pr>=expert_info.sell_pr){
			if(LotRevers){
				res=MathMax(expert_info.buy_lot,Lot);
			}else{
				res=MathMax(expert_info.sell_lot,Lot);
			}	
		}else{
			res=MathMax(expert_info.sell_lot,Lot);
		}
	}
	
	return(res);
}

double GetTPPrice(OE_DIRECTION dty, double lvl_pr=0){

	double _pr=(dty==OE_DTY_BUY)?(expert_info.buy_pr):(expert_info.sell_pr);
	int _tp_pips=TP;
	
	if(TPOnRevers>0 && lvl_pr>0){
		
		if((dty==OE_DTY_BUY&&lvl_pr<_pr) || (dty==OE_DTY_SELL&&lvl_pr>_pr)){
			_tp_pips=TPOnRevers;
			_pr=lvl_pr;
		}	
	}		 
	
	double _tp=(dty==OE_DTY_BUY)?(_pr+_tp_pips*Point)
											:(_pr-_tp_pips*Point);
	return(_tp);											
}

double GetReversDTY(OE_DIRECTION dty){
	if(dty==OE_DTY_BUY){
		return(OE_DTY_SELL);
	}else{
		return(OE_DTY_BUY);
	}
	
	return(-1);
}

double GetStartPrice(OE_DIRECTION dty){
	
	double _start_pr=expert_info.start_pr;
	double _pr=(Bid+Ask)/2;
	
	//DPRINT("ei.Autostart="+ei.Autostart);
	DPRINT("expert_info.Autostart="+expert_info.Autostart);
	
	if(ROWS(aTO)<=0){
		//начало новой серии
		expert_info.start_pr=_pr;
		
		expert_info.buy_pr=_pr+S*Point;
		expert_info.buy_lot=Lot;
		
		expert_info.sell_pr=_pr-S*Point;
		expert_info.sell_lot=Lot;
		
	}
	
	if(expert_info.Autostart){
		if(dty==OE_DTY_BUY){
			return(expert_info.buy_pr);
		}else{
			return(expert_info.sell_pr);
		}
	}
	
	//------------------------------------------------------
	// если дошли сюда, значит у нас есть выставленные ордера.
	// будем проверять, если было закрытие по тп и есть 
	// необходимость переместить уровень открытия.
	
	string f=OE_DTY+"=="+dty;
	SELECT(aTO,f);
	
	if(ROWS(aI)<=0){
		// в заданном направлении выставленных ордеров нет.
		// нужно проверить, если они есть в противоположном.
		f=OE_DTY+"=="+GetReversDTY(dty);
		SELECT2(aTO,aI,f);
		
		if(ROWS(aI)<=0){
			//хм... странно... выставленных ордеров нет,
			//но мы попали в данное место.
			//Выставляем автостарт в тру и вернем то, что нужно
			return(-1);
		}
		
		//ну вот... тикетов заданного направления нет, а 
		// в противоположном есть. 
		// Значит было закрытие по тп или еще как.
		// найдем уровень, с которого будем выставлять ордере
		int _l=MathAbs(_pr-expert_info.start_pr)/Point/S;
		double _k=(dty==OE_DTY_BUY)?1:-1;
		_start_pr=expert_info.start_pr+_k*_l*S*Point;
		
		if(dty==OE_DTY_BUY){
			expert_info.buy_pr=_start_pr;
			expert_info.buy_lot=expert_info.buy_lot*Multy+Plus;
			return(expert_info.buy_pr);
		}else{
			expert_info.sell_pr=_start_pr;
			expert_info.sell_lot=expert_info.sell_lot*Multy+Plus;
			return(expert_info.sell_pr);
		}
		
	}else{
		//в заданном направлении ордера есть.
		//значит нужно просто вернуть цену самого высокого
		//бая или самого низкого селла.
		f=OE_DTY+"=="+GetReversDTY(dty)+" AND "+OE_IM+"==1";
		
		SELECT2(aTO,aI,f);
		
		//проверим, если есть рыночные позиции.
		if(ROWS(aI)<=0){
			return((dty==OE_DTY_BUY)?expert_info.buy_pr:expert_info.sell_pr);
		}
		
		AId_InsertSort2(aTO,aI,OE_FOOP);
		
		if(dty==OE_DTY_BUY){
			return(AId_Get2(aTO,aI,0,OE_FOOP));
			//return(_pr);
		}else{
			return(AId_Get2(aTO,aI,(ROWS(aI)-1),OE_FOOP));
			//return(_pr);
		}
	}
	
	return(-1);
//	//------------------------------------------------------
//	if(expert_info.Autostart){
//		if(dty==OE_DTY_BUY){
//			expert_info.buy_tp=expert_info.buy_pr+TP*Point;
//			expert_info.buy_lot=Lot;
//		}else{
//			expert_info.sell_tp=expert_info.sell_pr-TP*Point;
//			expert_info.sell_lot=Lot;
//		}
//		return(expert_info.start_pr);
//	}
//	
//	string f=OE_DTY+"=="+dty;
//	SELECT(aTO,f);
//	
//	//------------------------------------------------------------
//	if(ROWS(aI)<=0){	
//		double _pr=(Bid+Ask)/2;
//		int _lvl=MathAbs(((_pr-expert_info.start_pr)/Point)/S);
//		double koef=(dty==OE_DTY_BUY)?1:-1;
//		start_pr=expert_info.start_pr+koef*_lvl*S*Point;
//		if(dty==OE_DTY_BUY){
//			expert_info.buy_pr=start_pr;
//			expert_info.buy_lot=expert_info.buy_lot*Multy+Plus;
//			expert_info.buy_tp=expert_info.buy_pr+TP*Point;
//		}else{
//			expert_info.sell_pr=start_pr;
//			expert_info.sell_lot=expert_info.sell_lot*Multy+Plus;
//			expert_info.sell_tp=expert_info.sell_pr-TP*Point;
//		}
//		return(start_pr);
//	}
//	
//	//------------------------------------------------------------
//	OE_DIRECTION rev_dty=(dty==OE_DTY_BUY)?OE_DTY_SELL:OE_DTY_BUY;
//	f=OE_DTY+"=="+rev_dty+" AND "+OE_IM+"==1";
//	SELECT2(aTO,aI,f);
//	if(ROWS(aI)>0){
//		//DAIdPRINT5(aTO, aI, "before sort (dty="+dty+")");
//		AId_InsertSort2(aTO,aI,OE_FOOP);
//		//DAIdPRINT5(aTO, aI, "after sort (dty="+dty+")");
//		
//		start_pr=(dty==OE_DTY_BUY)?AId_Get2(aTO,aI,(0),OE_FOOP)
//											:AId_Get2(aTO,aI,(ROWS(aI)-1),OE_FOOP);
//	}
//	
//	return(start_pr);
}