	#property copyright "Copyright 2014, artamir"
#property link      "http:\\forum.fxopen.ru"
#property version   "2.30"
#property strict
//#property stacksize 256

//#define DEBUG2

double fix_profit=0;
double dZeroPrice=0;
double dBalanceOst=0;

double dNearestBuyPrice=100000;
double dMaxBuyPrice=100000;

double dNearestSellPrice=0;
double dMinSellPrice=0;

input string s1="===== MAIN =====";
input int Step=100;	//Шаг между ордерами
input int TP=100; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=5; //Кол. уровней от позиции.
input int EQLevels=3; //Кол. екви уровней.
input double Lot=0.1;
input double Multy=2;
input string e1="================";
input bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
input int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)
input string e2="================";
//Закрывать все ордера при достижении заданного профита.
input	bool FIXProfit_use=false;	
//Значение фиксированного профита для закрытия всех ордеров.
input	double FIXProfit_amount=500; 


#define EXP "eTH"
#include <sysBase.mqh>
int OnInit(){
	zx
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Инициализация советника
		\internal
			>Hist:
			>Rev:0
	*/
	B_Init();
	
	//--------------------------------------
	xz 
	return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Деинициализация
		\internal
			>Hist:
			>Rev:0
	*/
	if(!IsTesting())B_Deinit();
	WriteFile();
}

void OnTick(){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Раньше была start()
		\internal
			>Hist:
			>Rev:0
	*/
	zx
	
	startext();
	
	xz
}

int startext(void){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Расширение OnTick()
		\internal
			>Hist:
			>Rev:0
	*/
   zx
   DAIdPRINTALL2(aOE,__FUNCTION__+"__________");
	string fn="startext";
   
     
	dMaxBuyPrice=getMaxBuyPrice();
	dMinSellPrice=getMinSellPrice();
	if(dMaxBuyPrice<0)dMaxBuyPrice=1000000;
	if(dMinSellPrice<0)dMinSellPrice=0;
	
	OE_DelPending();
	   
	B_Start();
	
	if(!CMFB_use && !FIXProfit_use)OE_delClosed();
	
	    
	CMFB();
   
  if(FIXProfit()) return(0);
 
	TN();

	Autoopen();

	//DelUnused();
	
	Comment("Balance Ost=",DoubleToStr(dBalanceOst,2)
	      ,"\nFixProfit=",fix_profit
	      ,"\nZeroPrice=",DoubleToStr(dZeroPrice,Digits)
	      ,"\naOE=",ArrayRange(aOE,0)
	      ,"\naEC=",ArrayRange(aEC,0)
	      ,"\nOrdersTotal="+OrdersTotal()
	      ,"\nQSMaxCount=",maxQScount
		  ,"\nCallCounter=",CallCounter
		  ,"\nmax_buy=",dMaxBuyPrice);	  
	xz
	return(0);
}

void DelUnused(){
   string fn="DelUnused";
   
   int aI[];
   ArrayResize(aI,0);
   AId_Init2(aEC,aI,OE_IP);
   
   double pr=dMaxBuyPrice;
   
   string f="";
   f=StringConcatenate(f,""
      ,OE_IP,"==",1
      ," AND "
      ,OE_OOP,">>",pr);
      
   B_Select(aEC,aI,f); 
   
   int r=ArrayRange(aI,0);
   for(int i=0;i<r;i++){
      int ti=AId_Get2(aEC,aI,i,OE_TI);
      TR_CloseByTicket(ti);
   }
   
   //===================================
   ArrayResize(aI,0);
   AId_Init2(aEC,aI,OE_IP);
   
   pr=dMinSellPrice;
   
   f="";
   f=StringConcatenate(f,""
      ,OE_IP,"==",1
      ," AND "
      ,OE_OOP,"<<",pr);
      
   B_Select(aEC,aI,f); 
   
   r=ArrayRange(aI,0);
   for(int i=0;i<r;i++){
      int ti=AId_Get2(aEC,aI,i,OE_TI);
      TR_CloseByTicket(ti);
   }
   //AId_Print2(aEC,aI,4,"aEC_BUY_Above_LastLevel");     
}

double getMaxBuyPrice(){
   double pr=0.0;
   dNearestBuyPrice=getNearestBuyPrice();
   pr=dNearestBuyPrice+Step*Levels*Point;
   
   return(pr);
}

double getMinSellPrice(){
   double pr=0.0;
   dNearestSellPrice=getNearestSellPrice();
   pr=dNearestSellPrice-Step*Levels*Point;
   
   return(pr);
}

double getNearestBuyPrice(){
   double pr=Ask;
   int aB[];
   ArrayResize(aB,0);
   AId_Init2(aEC,aB,OE_OOP);
   
   string f=StringConcatenate(""
            ,OE_OOP,">>",pr
            ," AND "
            ,OE_TY,"==",OP_BUY);
   B_Select(aEC,aB,f);
   //AId_Print2(aEC,aB,4,"aEC_Select_Buy_Above_Ask");  
   
   int aBS[];
   ArrayResize(aBS,0);
   AId_Init2(aEC,aBS,OE_OOP);
   
   f=StringConcatenate(""
            ,OE_OOP,">>",pr
            ," AND "
            ,OE_TY,"==",OP_BUYSTOP);
   B_Select(aEC,aBS,f);
   //AId_Print2(aEC,aBS,4,"aEC_Select_BuyStop_Above_Ask");  
   
   AI_Union(aB,aBS);
   AId_InsertSort2(aEC,aB,OE_OOP);
  // AId_Print2(aEC,aB,4,"aEC_Union_Buy_BuyStop_Above_Ask");
   
   double oop=AId_Get2(aEC,aB,0,OE_OOP);
   return(oop);          
}

double getNearestSellPrice(){
   double pr=Bid;
   int aB[];
   ArrayResize(aB,0);
   AId_Init2(aEC,aB,OE_OOP);
   
   string f=StringConcatenate(""
            ,OE_OOP,"<<",pr
            ," AND "
            ,OE_TY,"==",OP_SELL);
   B_Select(aEC,aB,f);
   //AId_Print2(aEC,aB,4,"aEC_Select_Buy_Above_Ask");  
   
   int aBS[];
   ArrayResize(aBS,0);
   AId_Init2(aEC,aBS,OE_OOP);
   
   f=StringConcatenate(""
            ,OE_OOP,"<<",pr
            ," AND "
            ,OE_TY,"==",OP_SELLSTOP);
   B_Select(aEC,aBS,f);
   //AId_Print2(aEC,aBS,4,"aEC_Select_BuyStop_Above_Ask");  
   
   AI_Union(aB,aBS);
   AId_InsertSort2(aEC,aB,OE_OOP);
  // AId_Print2(aEC,aB,4,"aEC_Union_Buy_BuyStop_Above_Ask");
   
   double oop=AId_Get2(aEC,aB,(ArrayRange(aB,0)-1),OE_OOP);
   return(oop);          
}


void CMFB(){
	/**
		\version	0.0.0.4
		\date		2014.03.07
		\author		Morochin <artamir> Artiom
		\details	Закрытие минусовых ордеров из средств баланса.
		\internal
			>Hist:				
					 @0.0.0.4@2014.03.07@artamir	[*]	Добавлен удаление закрытых ордеров из массива aOE после срабатывания закрытия по профиту.
					 @0.0.0.3@2014.03.06@artamir	[]	CMFB
					 @0.0.0.2@2014.01.15@artamir	[+]	Добавлено удаление закрытых ордеров, после закрытия хоть одного минусового ордера, если профит по закрытым ордерам не превышает 1.
					 @0.0.0.1@2014.01.15@artamir	[+]	CMFB
			>Rev:0
	*/
   zx
	string fn="CMFB";
	
	if(!CMFB_use)return;
	
	//Получаем сумму всех закрытых ордеров сессии.
	string f="";
	f=StringConcatenate(f
		,OE_IC,"==1");
		
	int aI[];
	ArrayResize(aI,0);
	AId_Init2(aOE,aI,OE_IC);
	
	B_Select(aOE,aI,f);
	
	int rows=ArrayRange(aI,0);
	
	if(rows<=0)return; //Значит у нас нет профита для закрытия минусов.
	
	double profit=AId_Sum2(aOE, aI, OE_OPR)+dBalanceOst;
	//Comment("Closed profit=",profit);
	
	//Выбираем ордера которые ушли в минус больше заданного значения.
	f="";
	f=StringConcatenate(f
		,OE_IM,"==1"
		," AND "
		,OE_CP2OOP,"<<",-CMFB_pips);
	ArrayResize(aI,0,1000);
	AId_Init2(aEC,aI);
	
	B_Select(aEC,aI,f);
	
	rows=ArrayRange(aI,0);
	Comment("Count orders in minus=",rows,"\n"
			,"profit=",profit);
			
	if(profit<=0){xz return;}		
	if(rows<=0){xz return;} //нет таких ордеров.
	int i=0;
	while(profit>0&&i<rows){
	   if(aI[i]>=ArrayRange(aEC,0)){
	      i++;
	      continue;
	      DAIdPRINTALL(aEC,"OUT_OF_RANGE_aI_"+aI[i]);
	   }   
		int ti=aEC[aI[i]][OE_TI];
		double opr=aEC[aI[i]][OE_OPR];
		if(MathAbs(opr)<=profit){
			if(TR_CloseByTicket(ti)){
			   B_Start();
				profit=profit-MathAbs(opr);
				bNeedDelClosed=true;
			}	
		}else{
			break;
		}
		i++;
	}
	
	if(bNeedDelClosed){
	   f=OE_IC+"==1 AND "+OE_IM+"==1";
	   DAIdPRINTALL(aOE,"Before_delClosed");
	   SELECT(aOE,f);
	   DAIdPRINT(aOE,aI,"After_Select");
	   dBalanceOst=AId_Sum2(aOE, aI, OE_OPR)+dBalanceOst;
		OE_delClosed();
		bNeedDelClosed=false;
	}
	xz
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
	string fn="FIXProfit";
	
	if(!FIXProfit_use)return(false);
	
	int aI[]; ArrayResize(aI,0,1000);AId_Init2(aOE,aI);
	fix_profit=AId_Sum2(aOE,aI,OE_OPR);
	DPRINT2("fix_profit="+fix_profit);
	if(fix_profit<FIXProfit_amount){xz return(false);}
	
	CloseAllOrders();
	OE_delClosed();
	bNeedDelClosed=true; 
	xz
	return(true);
}


void CloseAllOrders(){
	/**
		\version	0.0.0.0
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Закрывает все ордера.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="CloseAllOrders";
	
	string f="";
	f=StringConcatenate(f
		,OE_IT,"==1"
		," AND "
		,OE_MN,"==",TR_MN);
		
	int aI[];
	ArrayResize(aI,0);
	AId_Init2(aOE, aI);
		
	//-------------------------------------------
	B_Select(aOE, aI, f);
	int rows=ArrayRange(aI,0);
	Print(fn, ".rows=",rows);
	for(int idx = 0; idx < rows; idx++){
		int ti = aOE[aI[idx]][OE_TI];
		
		TR_CloseByTicket(ti);
	}
		
}

void TN(){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Трендовая сетка.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	TN
			>Rev:0
	*/
	zx
	string fn="TN";
	
	//Print(fn);	
	int aI[]; ArrayResize(aI,0,1000);
	AId_Init2(aEC,aI,OE_IM);
	//AId_Print2(aEC,aI,4,"TN_IM1_before");
	
	string f=StringConcatenate(OE_IM,"==1");
 	B_Select(aEC,aI,f);
 	//AId_Print2(aEC,aI,4,"TN_IM1_after");
 	
	int rows=ArrayRange(aI,0);
	DPRINT2("rows="+rows);
	//if(rows<=0){xz return;}
	
	for(int i=0;i<rows;i++){
		int 	pti =AId_Get2(aEC,aI,i,OE_TI);
		int 	pty =AId_Get2(aEC,aI,i,OE_TY);
		double 	poop=AId_Get2(aEC,aI,i,OE_OOP);
	   DPRINT2("pti="+pti);
	   DPRINT2("pty="+pty);
	   DPRINT2("poop="+poop);
	   DPRINT2("poop > dNearestBuyPrice"+(string)(poop > dNearestBuyPrice));
	   if(pty==OP_BUY && poop > dMaxBuyPrice)continue;
	   DPRINT2("pty==OP_BUY && poop > dNearestBuyPrice");
	   if(pty==OP_SELL && poop < dMinSellPrice)continue;
	   
		TN_checkCO(pti);	
		//TN_checkRev(pti);
		TN_checkCO(pti,-1);
	}
	xz
}

 


void TN_checkCO(int pti, int RevKoef=1){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.1@2014.03.06@artamir	[+]	TN_checkCO
			>Rev:0
	*/
	DAIdPRINTALL2(aOE,__FUNCTION__+"____ti_"+pti);
	zx
	string fn="TN_checkCO";
	
	OrderSelect(pti,SELECT_BY_TICKET);
	int pty=OrderType();
	double poop=OrderOpenPrice();
	double pol=OrderLots();
	double max_buy=dMaxBuyPrice;
	double min_sell=dMinSellPrice;
	
	int _addPips=0;
	
	for(int lvl=1;lvl<=Levels;lvl++){
		int ty=-1;
		double lvloop=poop+iif((pty==OP_BUY||pty==OP_BUYSTOP),1,-1)*Step*lvl*Point*RevKoef;
		DPRINT2("pt1="+pti+"; lvl="+lvl+"; lvloop="+lvloop);
		if(pty==OP_BUY||pty==OP_BUYSTOP){
			if(RevKoef==1){
   			ty=OP_BUYSTOP;
   			if(lvloop<Ask)continue;
   			if(lvloop>max_buy)continue;
   		}else{
   		 //  _addPips=-Step;
   		   ty=OP_SELLSTOP;
   		   if(lvloop>Bid)continue;
			   if(lvloop<min_sell)continue;
   		}	
		}
		
		if(pty==OP_SELL||pty==OP_SELLSTOP){
			if(RevKoef==1){
   			ty=OP_SELLSTOP;
   			if(lvloop>Bid)continue;
   			if(lvloop<min_sell)continue;
			}else{
			  // _addPips=-Step;
			   ty=OP_BUYSTOP;
   			if(lvloop<Ask)continue;
   			if(lvloop>max_buy)continue;
			}
		}
		
		int aI[];ArrayResize(aI,0);
		AId_Init2(aEC,aI,OE_OOP);
		string f=StringConcatenate(""
			,OE_OOP,"<<",lvloop+(Step-1)*Point
			," AND "
			,OE_OOP,">>",lvloop-(Step-1)*Point);
		
		B_Select(aEC,aI,f);
		
		int rows=ArrayRange(aI,0);
		double d[];
		if(rows<=0){
			ArrayResize(d,0);
			int AddPips=Step*lvl;
			TR_SendPending_array(d, ty,	poop, AddPips, GetLot(ty,poop,AddPips+_addPips,pol), TP);
			B_Start();
		}
	}	
	xz	
}

void TN_checkRev(int pti){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Проверка противоположных ордеров.
		\internal
			>Hist:		
					 @0.0.0.1@2014.03.06@artamir	[+]	TN_checkRev
			>Rev:0
	*/
	string fn="TN_checkRev";
	OrderSelect(pti,SELECT_BY_TICKET);
	int pty=OrderType();
	double poop=Norm_symb(OrderOpenPrice());
	double pol=OrderLots();
	
	int typ=-1,tyo=-1;
	double roop=-1;
	if(pty==OP_BUY){
		typ=OP_SELL;
		tyo=OP_SELLSTOP;
		roop=Norm_symb(poop)-Step*Point;
		if(Ask<=roop) return;
	}

	if(pty==OP_SELL){
		typ=OP_BUY;
		tyo=OP_BUYSTOP;
		roop=Norm_symb(poop)+Step*Point;
		if(Bid>=roop)return;
	}
	
	int cntp=TI_count(typ,roop);
	int cnto=TI_count(tyo,roop);
	if(cntp<=0&&cnto<=0){		
		double d[];
		ArrayResize(d,0);
		int AddPips=Step;
		//TR_SendPending_array(d, tyo, poop, AddPips, GetLot(), TP);
		TR_SendPending_array(d, tyo, poop, AddPips, pol, TP);
		B_Start();
		int rows=ArrayRange(d,0);
		for(int i=0;i<rows;i++){
			TN_checkCO(d[i]);
		}
	}	
}

int TI_count(int ty, double oop){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Возвращает количество ордеров по заданной цене и типу
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	TI_count
			>Rev:0
	*/

	string fn="TI_count";
	
	int aI[];ArrayResize(aI,0);
	AId_Init2(aEC,aI);
	string f=StringConcatenate(""
		,OE_OOP,">>",Norm_symb(oop)-1*Point
		," AND "
		,OE_OOP,"<<",Norm_symb(oop)+1*Point
		," AND "
		,OE_TY,"==",ty);
	
	DAIdPRINT2(aEC,aI,"before");	
	B_Select(aEC,aI,f);
	DAIdPRINT2(aEC,aI,"after");
		
	int rows=ArrayRange(aI,0);
	
	return(rows);
}

void Autoopen(){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Автооткрытие позиций/ордеров.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	Autoopen
			>Rev:0
	*/
	zx
	string fn="Autoopen";
	
	if(OrdersTotal()==0){
		int ti=TR_SendBUY(Lot);
		TR_ModifyTP(ti,TP,TR_MODE_PIP);
		dZeroPrice=OE_getPBT(ti,OE_OOP);//-(Step/2)*Point;
	}	
}

double GetLot(int ty=-1, double oop=0, int add_pips=0, double pol=0){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Определение объема выставляемой позиции.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	GetLot
			>Rev:0
	*/
	if(ty==-1)return(Lot);
	
	double _send_price=0;
	int _pips_to_zero=0;
	int _koef=1;
   if(ty==OP_BUYSTOP){
      _send_price=Norm_symb(oop)+add_pips*Point;
      _pips_to_zero=(Norm_symb(_send_price)-Norm_symb(dZeroPrice))/Point;
   }
   
   if(ty==OP_SELLSTOP){
      _send_price=Norm_symb(oop)-add_pips*Point;
      _pips_to_zero=(Norm_symb(dZeroPrice)-Norm_symb(_send_price))/Point;
   }
   _koef=MathCeil(_pips_to_zero/(Step*EQLevels));
   
   double res=Lot;
   for(int i=0; i<_koef&&_koef>0; i++){
      res*=Multy;
   }
   
   res=MathMax(MathMax(res,Lot),pol);
   
   
   
	return(res);
}
