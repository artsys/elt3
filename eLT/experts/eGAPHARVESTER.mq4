	/**
		\version	0.0.0.21
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Must be called in begining of "start()" 
		\internal
			>Hist:																		
					 @0.0.0.19@2013.05.17@artamir	[]	CloseAllPendings
					 @0.0.0.18@2013.05.17@artamir	[]	CloseAllPendings
					 @0.0.17@2013.04.30@artamir	[]	startext
					 @0.0.16@2013.04.29@artamir	[]	OpenBSSS
					 @0.0.15@2013.04.29@artamir	[]	startext
					 @0.0.12@2013.04.25@artamir	[]	start
					 @0.0.11@2013.04.25@artamir	[]	start
					 @0.0.10@2013.04.25@artamir	[+]	startext
					 @0.0.9@2013.04.25@artamir	[*]	start
					 @0.0.8@2013.04.25@artamir	[]	OpenBSSS
					 @0.0.7@2013.04.25@artamir	[]	getOrdersByMethod
					 @0.0.6@2013.04.25@artamir	[]	TralBSSS
					 @0.0.5@2013.04.25@artamir	[*]	getTimeByShift
					 @0.0.4@2013.04.25@artamir	[+]	DT_DayStartByShift
					 @0.0.3@2013.04.25@artamir	[*]	getOrdersByMethod
					 @0.0.2@2013.04.25@artamir	[+]	getOrdersByMethod
					 @0.0.1@2013.04.25@artamir	[+]	CWT
	*/

#define	EXP	"eGH"
#define	VER	"0.0.21_2013.04.30"

//{	=== Extern 
extern string	EXP_1	= "=== PHASE1 ==========";			//{
	extern	int	DOW_Ph1	= 5;	//(Day Of Week) воскресенье-0,1,2,3,4,5,6
	extern	int	THS_Ph1 = 23;	//(Time Hour Start) час начала работы первой фазы
	extern	int	TMS_Ph1 = 55;	//(Time Minutes Start) минуты начала первой фазы
	extern	int	THE_Ph1 = 0;	//(Time Hour End) час окончания работы первой фазы
	extern	int	TME_Ph1 = 0;	//(Time Minutes End) минуты окончания первой фазы

	extern string EXP_11= "=== TRAL ==========";			//{
		extern int TRAL_DeltaPips = 5;	//На каком расстоянии от цены тралится.
	//}
	
	extern string EXP_12= "=== OPEN ==========";			//{
		extern double	OPEN_FixLot = 100.00;	//Каким объемом будут открываться ордера.
		extern int		OPEN_TPPips = 0;
		extern int		OPEN_SLPips = 10;		//На всякий пожарный случай.
	//}

extern string	EXP_2	= "=== PHASE2 ==========";			//..	
	extern	bool UsePhase2 = false;
	//extern	int	BU_pip = 2;				//Через сколько пунктов переводим в БУ
	extern	int TRAL_Begin_pip = 2;			//Цена закрытия должна уйти в 2 пункта плюса от сл
	extern	int TRAL_Step_pip = 1;			//если цена ушла больше чем на 2+1 пункт, то двигаем на 1 пункт
extern string	EXP_3	= "=== EXPERT SETUP ====";			//..
	extern	int Sleep_ms = 500; 		
extern string	EXP_BP	= "=== BP   ==========";				//..	BREAK POINTS
	extern bool	Debug			= false;
	extern bool BP_ISPH2		= false;
	extern bool BP_CWT			= false;
	extern bool BP_TRAL			= false;
	extern bool BP_TRMOVE		= false;
	extern bool	BP_Trades 		= false;
	extern bool BP_Like			= false;
	extern bool	BP_OE 			= false;
	extern bool	BP_PB2MA		= false;
	extern bool BP_LOA	 		= false;
	extern bool BP_DelUnused 	= false;
	extern bool	BP_Array		= false;
	extern bool BP_Events_NEW 	= false;
	extern bool BP_Events_CL 	= false;
	extern bool BP_Events_CHOP 	= false;
	extern bool BP_Events_CHSL 	= false;
	extern bool BP_Events_CHTY 	= false;
	extern bool BP_AOM			= false;
	extern bool BP_Terminal 	= false;
//}	

//}

//{	=== VARS
string	fnExtra	= ""	;

//----------------------------------------------------------
bool	isStart = true	;

//--- Debug on condition 
bool BP_Condition_select = false;

//}

//==========================================================
#include	<sysELT3.mqh>

//#include	<sysSignals.mqh>
//#include	<sysAOM.mqh>

//==========================================================
int init(){
	
	fnExtra = getExtraFN();

	
	//------------------------------------------------------
	ELT_init(fnExtra);
}

//==========================================================
int deinit(){
	ELT_deinit(fnExtra);
}

//==========================================================
int start(){
	/*
		>Ver	:	0.0.4
		>Date	:	2013.04.25
		>History:			
					@0.0.4@2013.04.25@artamir	[]	Изменил проверку зацикливания на IsStopped
					@0.0.3@2013.04.25@artamir	[]	Изменил зацикливание
					@0.0.2@2013.04.25@artamir	[]	start
			@0.0.1@2012.10.02@artamir	[*] убрал все содержимое в startext
		>Description:
			start function of EA.
	*/
	if(IsTesting()){
		startext();
	}else{
		while(IsExpertEnabled()){
			startext();
			Sleep(500); //5 sec.
		}
	}
	//------------------------------------------------------
	return(0);
}

int startext(){
	/**
		\version	0.0.3
		\date		2013.04.30
		\author		Morochin <artamir> Artiom
		\details	Расширение функции старт.
					т.е. ее основная начинка
		\internal
			>Hist:			
					 @0.0.3@2013.04.30@artamir	[+]	Добавлен вывод соощения если Торговля запрещена или Рынок закрыт
					 @0.0.2@2013.04.29@artamir	[]	startext
					 @0.0.1@2013.04.25@artamir	[]	startext
	*/

	string CommAdd = "";									//Добавочный комментарий
	
	//{ === Собираем параметры счета и проверяем настройки + вывод сообщений в коммент.
		
		//{  === Параметры счета
		CommAdd = CommAdd + "FREEZE = "+ MarketInfo(Symbol(), MODE_FREEZELEVEL)+"\n";
		CommAdd = CommAdd + "STOP = "+ MarketInfo(Symbol(), MODE_STOPLEVEL)+"\n";
		CommAdd = CommAdd + "IsExpertEnabled = "+ IsExpertEnabled()+"\n"; 
		CommAdd = CommAdd + "IsTradeAllowed	= "+ IsTradeAllowed() +"\n"; 
	
		//.. === Настройки советника
		CommAdd = CommAdd + "----------SETUP ---------------"+"\n";
		CommAdd = CommAdd + "DOW_Ph1 = "+ DOW_Ph1 +"\n";
		CommAdd = CommAdd + "Start = "+THS_Ph1+":"+TMS_Ph1+"\n";
		CommAdd = CommAdd + "End   = "+THE_Ph1+":"+TME_Ph1+"\n";
		
		CommAdd = CommAdd + "TRAL   = "+TRAL_DeltaPips+"\n";
		
		CommAdd = CommAdd + "OPEN_FixLot   = "+OPEN_FixLot+"\n";
		CommAdd = CommAdd + "OPEN_SLPips   = "+OPEN_SLPips+"\n";
		CommAdd = CommAdd + "OPEN_TPPips   = "+OPEN_TPPips+"\n";
		
		//.. === Проверка на закрытый рынок
		CommAdd = CommAdd + "\n\n";
		if(GetLastError() == 132){
			CommAdd = CommAdd + "MARKET IS CLOSED" +"\n";
		}
		
		CommAdd = CommAdd + "\n\n";
		if(GetLastError() == 133){
			CommAdd = CommAdd + "TRADE IS DENIED" +"\n";
		}
		//}
	//}	
	
	Comment(	"EXP ver: "	,VER		,"\n"
			,	"Sys ver: "	,ELTVER		,"\n"
			,	"DOW = "	,DayOfWeek(),"\n"
			,	"GTBS_S = ", getTimeByShift(0, THS_Ph1, TMS_Ph1), "\n"
			,	"GTBS_S(0,21,50) = ", getTimeByShift(0, 21, 50), "\n"
			,	CommAdd);
	
	//------------------------------------------------------
	if(isStart) isStart = false;

	//------------------------------------------------------
	Main();													//called from sysELT3
	
	//------------------------------------------------------
	//mngAO.Main();											//Main function of autoopen manager.
	
	//------------------------------------------------------
	//libCY.Main();											//Main function of convoys manager.

	if(isPhase1()){
		eGH_Phase1();
	}
	
	if(isPhase2()){
		eGH_Phase2();
	}
	
	//------------------------------------------------------
	return(0);
}


//==========================================================
string getExtraFN(){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.09.10
		>Hist:
			@0.0.3@2012.09.10@artamir	[]
			@0.0.2@2012.09.10@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
		>Description:
	*/
	
	string fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"Extra.arr";

	//------------------------------------------------------
	return(fn);
}

double iif( bool condition, double ifTrue, double ifFalse ){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.04.04
		>History:
	*/
	if( condition ) return( ifTrue );
	//---
	return( ifFalse );
}

//{	Expert functions
bool isPhase1(){
	return(CWT(DOW_Ph1, THS_Ph1, TMS_Ph1, THE_Ph1, TME_Ph1));
}

bool isPhase2(){
	//return(CWT(DOW_Ph2, THS_Ph2, TMS_Ph2, THE_Ph2, TME_Ph2));
	if(!UsePhase2) return(false);
	
	double d[][OE_MAX];
	
	A_eraseFilter();
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MN, TR_MN, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IM, 1, -1, AS_OP_EQ);
	
	A_d_Select(aOE, d);
	
	int ROWS = ArrayRange(d,0);
	
	if(ROWS > 0){
		return(true);
	}
	
	return(false);
}

//{	=== PHASE 1
void eGH_Phase1(){											
	/**
		\version	0.0.0
		\date		2013.04.25
		\author		Morochin <artamir> Artiom
		\details	Must be called in begining of "start()" 
		\internal
			>Hist:
	*/

	if(isOrdersByMN()){
		TralBSSS();
	}else{
		OpenBSSS();
	}
}

void	OpenBSSS(){
	/**
		\version	0.0.2
		\date		2013.04.29
		\author		Morochin <artamir> Artiom
		\details	Процедура открывает Байстоп и СеллСтоп ордера с заданными настройками. 
		\internal
			>Hist:		
					 @0.0.2@2013.04.29@artamir	[]	OpenBSSS
					 @0.0.1@2013.04.25@artamir	[]	Изменил расчет стартовой цены открытия ордеров.
	*/

	double bs[], ss[];	//Массивы выставленных ордеров.
	double sp, vol;
	int ap, tppips, slpips;
	
	vol = OPEN_FixLot;
	ap = TRAL_DeltaPips;
	tppips = OPEN_TPPips;
	slpips = OPEN_SLPips;
	
	//{		=== Open BS
	RefreshRates();
	sp = MarketInfo(Symbol(), MODE_ASK);
	TR_SendBUYSTOP_array(bs, sp, ap, vol, tppips, slpips, "eGH_BS_"+TR_MN, -1);
	
	//..	=== Open SS
	RefreshRates();
	sp = MarketInfo(Symbol(), MODE_BID);
	TR_SendSELLSTOP_array(ss, sp, ap, vol, tppips, slpips, "eGH_SS_"+TR_MN, -1);
	//}

}

void	TralBSSS(){
	/**
		\version	0.0.1
		\date		2013.04.25
		\author		Morochin <artamir> Artiom
		\details	Трейлинг отложенных ордеров в дельте от цены.
		\internal
			>Hist:	
			@0.0.1@2013.04.25@artamir	[]	TralBSSS
	*/
	
	double d[][OE_MAX];
	int dROWS = 0;
	int didx;
	int oti = -1;
	int oty = -1;
	double new_pr = 0.00;
	
	
	getOrdersByMethod(d);	//забираем ордера с текущим магиком.
	
	if(Debug && BP_TRAL){
		A_d_PrintArray2(d, 4, "TRAL_");
	}
	
	dROWS = ArrayRange(d, 0);
	
	for(didx = 0; didx < dROWS; didx++){
		oti = d[didx][OE_TI];
		oty = d[didx][OE_TY];
		
		if(oty == OP_BUYSTOP){
			new_pr = MarketInfo(Symbol(), MODE_ASK)+TRAL_DeltaPips*Point;
			TR_MoveOrder(oti, new_pr);
		}
		
		if(oty == OP_SELLSTOP){
			new_pr = MarketInfo(Symbol(), MODE_BID)-TRAL_DeltaPips*Point;
			TR_MoveOrder(oti, new_pr);
		}
		
	}

}
//}

//{ === PHASE2
void eGH_Phase2(){
	/**
		\version	0.0.0.3
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.0.3@2013.05.15@artamir	[]	TralBSSS
					 @0.0.0.2@2013.05.15@artamir	[]	TralBSSS
					 @0.0.0.1@2013.05.15@artamir	[]	TralBSSS
			>Rev:0
	*/
	
	PH2_Tral();
	CloseAllPendings();
}

string getOrderForTral(){
	/**
		\version	0.0.0.2
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.15@artamir	[]	getOrderForTral
					 @0.0.0.1@2013.05.15@artamir	[]	getQOrderForTral
			>Rev:0
	*/

	
	string q = " (SELECT * FROM OE ";
	q = q + " WHERE IM=1 ";
	q = q + " AND IW=1";
	q = q + " AND MN="+TR_MN;
	q = q + " AND PIP>"+TRAL_Begin_pip;
	q = q + " AND ABS(OCP-SL)/"+DoubleToStr(Point, Digits)+">"+(TRAL_Begin_pip+TRAL_Step_pip); 
	q = q + ")";
	return(q);
}

string getPendings(){
	string q = "(";
	q = q + " SELECT * FROM OE ";
	q = q + " WHERE IP=1";
	q = q + " AND IW=1";
	q = q + " AND MN="+TR_MN;
	q = q + ")";
	return(q);
}

string getMarkets(){
	string q = "(";
	q = q + " SELECT * FROM OE ";
	q = q + " WHERE IM=1";
	q = q + " AND IW=1";
	q = q + " AND MN="+TR_MN;
	q = q + ")";
	return(q);
}

void CloseAllPendings(){
	/**
		\version	0.0.0.2
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.17@artamir	[]	CloseAllPendings
					 @0.0.0.1@2013.05.15@artamir	[]	CloseAllPendings
			>Rev:0
	*/

	double d[][OE_MAX];
	A_eraseFilter();
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MN, TR_MN, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IP, 1, -1, AS_OP_EQ);
	
	A_d_Select(aOE, d);
	
	int ROWS = ArrayRange(d, 0);
	
	for(int idx = 0; idx < ROWS; idx++){
		
		int ti = d[idx][OE_TI];
		TR_CloseByTicket(ti);
	}
	
}

void PH2_Tral(){
	/**
		\version	0.0.0.4
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:				
					 @0.0.0.4@2013.05.17@artamir	[]	CloseAllPendings
					 @0.0.0.3@2013.05.15@artamir	[]	CloseAllPendings
					 @0.0.0.2@2013.05.15@artamir	[]	CloseAllPendings
					 @0.0.0.1@2013.05.15@artamir	[]	CloseAllPendings
			>Rev:0
	*/

	double d[][OE_MAX];
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MN, TR_MN, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_CP2SL, (TRAL_Begin_pip+TRAL_DeltaPips), -1, AS_OP_ABOVE);
	A_FilterAdd_AND(OE_CP2OP, (TRAL_DeltaPips), -1, AS_OP_ABOVE);
	
	A_d_Select(aOE, d);
	
	int ROWS = ArrayRange(d, 0);
	
	for(int idx = 0; idx < ROWS; idx++){
		int ti = d[idx][OE_TI];
		TR_ModifySLByPrice(ti, TRAL_Step_pip);
	}
}	

//}


//}

//{	CAN WE TRADE
bool	CWT(	int d 	=	-1	/**	day of week*/
			,	int hs	=	0	/**	hour start*/
			,	int	ms	=	0	/**	min. start*/
			,	int	he	=	0	/**	hour end*/
			,	int	me	=	0	/**	min. end*/){
	/**
		\version	0.0.2
		\date		2013.04.25
		\author		Morochin <artamir> Artiom
		\details	checking if we can trade 
		\internal
			>Hist:		
					 @0.0.2@2013.04.25@artamir	[]	getTimeByShift
					 @0.0.1@2013.04.25@artamir	[]	CWT
	*/
	
	bool res = true;
	datetime dtS, dtE;
	string sy = Symbol();
	
	//------------------------------------------------------
	res = iif(d<=-1,
					true,	/*можем работать в любой день*/
						iif(DayOfWeek() != d,
											false,	/*день не равен заданному*/
													true));	
	
	//------------------------------------------------------
	if(res){												//если прошли проверку на день
		
		dtS = getTimeByShift(0, hs, ms);
		dtE = getTimeByShift(0, he, me);
		
		if(Debug && BP_CWT){
			BP(		"CWT"
				,	"dtS = ", TimeToStr(dtS, TIME_DATE|TIME_MINUTES)
				, 	"dtE = ", TimeToStr(dtE, TIME_DATE|TIME_MINUTES)
				, 	"tc = ", TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES)
				,	"ds = ", getTimeByShift(0, 0, 0));
		}
		
		if(dtS < dtE){
			if(TimeCurrent() >= dtS && TimeCurrent() <= dtE){
				return(true);
			}else{	
				return(false);
			}
		}
	
		if(dtS > dtE){
			if(TimeCurrent() <= dtS || TimeCurrent() >= dtE){
				return(true);
			}else{
				return(false);
			}
		}
	}
	
	//------------------------------------------------------
	return(res);
}

datetime	getTimeByShift(int shift, int h, int m, string symb = ""){
	string sy = symb;

	if(symb == ""){
		sy = Symbol();
	}
	
	//------------------------------------------------------
	return(DT_DayStartByShift(shift)	/*Начало дня*/ 
				+ HoursToSeconds(h)		/* добавили часы*/
				+ MinutesToSeconds(m)	/* добавили минуты*/);
}

datetime	DT_DayStartByShift(int shift = 0){
	/**
		\version	0.0.1
		\date		2013.04.25
		\author		Morochin <artamir> Artiom
		\details	Возвращает datetime начала дня по заданному индексу бара
		\internal
			>Hist:	
					 @0.0.1@2013.04.25@artamir	[]	DT_DayStartByShift
	*/
	string sy =	Symbol();		//текущий символ
	int tf = 0;					//текущий тф.
	datetime dtTimeShift = 0;	//датавремя открытия бара по индексу.
	
	//------------------------------------------------------
	string sDateShift = "";
	datetime dtDayStart = 0;
	
	dtTimeShift = iTime(sy, tf, shift);
	sDateShift = TimeToStr(dtTimeShift, TIME_DATE);
	
	dtDayStart = StrToTime(sDateShift);
	
	//------------------------------------------------------
	return(dtDayStart);
}

int HoursToSeconds(int h){
	return(h*60*60);
}

int MinutesToSeconds(int m){
	return(m*60);
}
//}

//{	=== AOM

//==========================================================
int getOrdersByMethod(		double	&d[][]		/**	destination array*/
						,	int		method = -1	/**	method of opening*/
						,	int		magic = -1	/** Magic Number of orders 
													\details if -1: will be used TR_MN*/){
	/**
		\version	0.0.3
		\date		2013.04.25
		\author		Morochin <artamir> Artiom
		\details	Собирает в массив ордера, открытые заданным методом открытия.
		\internal
			>Hist:			
					 @0.0.3@2013.04.25@artamir	[*]	Изменил фильтр по магику
					 @0.0.2@2013.04.25@artamir	[+]	использование всех методов по умолчанию
					 @0.0.1@2013.04.25@artamir	[]	getOrdersByMethod
	*/

	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	
	if(method >= 0){
		A_FilterAdd_AND(OE_AOM, method, -1, AS_OP_EQ);
	}	
	
	if(magic == -1){
		A_FilterAdd_AND(OE_MN, TR_MN, -1, AS_OP_EQ);
	}else{
		A_FilterAdd_AND(OE_MN, magic, -1, AS_OP_EQ);
	}
	
	A_d_Select(aOE, d);
	
	if(Debug && BP_AOM){
		A_d_PrintArray2(d, 4, "SelectByMethod_"+method+"_"+magic);
	}
}

//==========================================================
bool isOrdersByMN(int mn = -1){
	/**
		\version	0.0.0
		\date		2013.04.25
		\author		Morochin <artamir> Artiom
		\details	Проверяет, если есть ордера с заданным магиком
		\internal
			>Hist:
	*/

	double d[][OE_MAX];
	getOrdersByMethod(d);									//Будет промзведен подбор ордеров по мн
	
	if(ArrayRange(d, 0) >= 1){
		return(true);
	}else{
		return(false);
	}
}
//}
