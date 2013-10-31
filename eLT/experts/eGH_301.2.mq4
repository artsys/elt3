	/**
		\version	0.0.2.1
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Gap harvester v2.
		\internal
			>Hist:		
					 @0.0.2.1@2013.10.30@artamir	[!]	CWT
			$Revision$
	*/
#define	EXP	"eGH"
#define	VER	"0.0.2.1_2013.10.30"

//{	=== Extern 
extern	int		DOW 	= 5;	//(Day Of Week) воскресенье-0,1,2,3,4,5,6
extern string	EXP_11	= "=== PHASE1_1 ==========";			//{
	extern	string	ST_Ph11	 = "23:55:10";	//Время начала фазы 1.1
	extern int TRAL_DeltaPips = 15;	//На каком расстоянии от цены тралится.
extern string	EXP_12	= "=== PHASE1_2 ==========";			//..
	extern	string	ST_Ph12	 = "23:59:00";	//Время начала фазы 1.2
	extern int TRAL_DeltaPips12 = 5;	//На каком расстоянии от цены тралится.

extern string	EXP_13	= "=== PHASE1_3 ==========";			//..
	extern	string	ST_Ph13	= "23:59:50";	//Время начала фазы 1.2
	extern int TRAL_DeltaPips13 = 2;	//На каком расстоянии от цены тралится.
	
extern string	EXP_3	= "=== EXPERT SETUP ====";			//..
	extern	string	ET		 = "24:01:10";	//Время окончания фазы 1.1
	extern double	OPEN_FixLot = 5.00;	//Каким объемом будут открываться ордера.
	extern	int Sleep_ms = 1; 		


string	EXP_2	= "=== PHASE2_1 ==========";			//..	
	bool UsePhase2 = false;
	//extern	int	BU_pip = 2;				//Через сколько пунктов переводим в БУ
	int TRAL_Begin_pip = 2;			//Цена закрытия должна уйти в 2 пункта плюса от сл
	int TRAL_Step_pip = 1;			//если цена ушла больше чем на 2+1 пункт, то двигаем на 1 пункт
	
//}	
//}

//{	=== VARS
string	fnExtra	= ""	;
//----------------------------------------------------------
bool	isStart = true	;
//}

//==========================================================
#include	<sysELT3.mqh>

//==========================================================
int init(){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Инициализация советника.
		\internal
			>Hist:
			>Rev:0
	*/

	ELT_init();
}

//==========================================================
int deinit(){
	ELT_deinit();
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
			Sleep(Sleep_ms); //5 sec.
		}
	}
	//------------------------------------------------------
	return(0);
}

int startext(){
	/**
		\version	0.0.0.4
		\date		2013.06.12
		\author		Morochin <artamir> Artiom
		\details	Расширение функции старт.
					т.е. ее основная начинка
		\internal
			>Hist:				
					 @0.0.0.4@2013.06.12@artamir	[]	startext
					 @0.0.3@2013.04.30@artamir	[+]	Добавлен вывод соощения если Торговля запрещена или Рынок закрыт
					 @0.0.2@2013.04.29@artamir	[]	startext
					 @0.0.1@2013.04.25@artamir	[]	startext
	*/

	string CommAdd = "";	
	Comment(	"EXP ver: ",VER,"\n"
			,	CommAdd);
	
	//------------------------------------------------------
	if(isStart) isStart = false;

	//------------------------------------------------------
	ELT_start();											//called from sysELT3
	
	int phase = 0;
	
	if(isPhase11()){
		phase = 11;
	}
	
	if(isPhase12()){
		phase = 12;
	}
	
	if(isPhase13()){
		phase = 13;
	}
	
	if(isPhase2()){
		phase = 2;
	}
	
	if(phase == 11){
		eGH_Phase11();
	}
	
	if(phase == 12){
		eGH_Phase12();
	}
	
	if(phase == 13){
		eGH_Phase13();
	}
	
	if(phase == 2){
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

//{	Expert functions
bool isPhase11(){
	return(CWT(DOW,ST_Ph11,ET));
}

bool isPhase12(){
	return(CWT(DOW,ST_Ph12,ET));
}

bool isPhase13(){
	return(CWT(DOW,ST_Ph13,ET));
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

//{	=== PHASE 11
void eGH_Phase11(){											
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
	tppips = 0;//OPEN_TPPips;
	slpips = 0;//OPEN_SLPips;
	
	//{		=== Open BS
	RefreshRates();
	sp = MarketInfo(Symbol(), MODE_ASK);
	TR_SendBUYSTOP_array(bs, sp, ap, vol, tppips, slpips, ""+TR_MN, -1);
	
	//..	=== Open SS
	RefreshRates();
	sp = MarketInfo(Symbol(), MODE_BID);
	TR_SendSELLSTOP_array(ss, sp, ap, vol, tppips, slpips, ""+TR_MN, -1);
	//}

}

void	TralBSSS(){
	/**
		\version	0.0.0.2
		\date		2013.06.12
		\author		Morochin <artamir> Artiom
		\details	Трейлинг отложенных ордеров в дельте от цены.
		\internal
			>Hist:		
					 @0.0.0.2@2013.06.12@artamir	[]	TralBSSS
			@0.0.1@2013.04.25@artamir	[]	TralBSSS
	*/
	
	double d[][OE_MAX];
	int dROWS = 0;
	int didx;
	int oti = -1;
	int oty = -1;
	double new_pr = 0.00;
	
	
	getOrdersByMethod(d);	//забираем ордера с текущим магиком.
	
	A_d_Sort2(d, OE_CP2OP+" <;"); //сортировка по убыванию
	
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

//{	=== PHASE 12
void eGH_Phase12(){											
	/**
		\version	0.0.0.1
		\date		2013.06.11
		\author		Morochin <artamir> Artiom
		\details	Must be called in begining of "start()" 
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.11@artamir	[]	TralBSSS
	*/

	if(isOrdersByMN()){
		TralBSSS12();
	}else{
		OpenBSSS12();
	}
}

void	OpenBSSS12(){
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
	ap = TRAL_DeltaPips12;
	tppips = 0;//OPEN_TPPips12;
	slpips = 0;//OPEN_SLPips12;
	
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

void	TralBSSS12(){
	/**
		\version	0.0.0.2
		\date		2013.06.12
		\author		Morochin <artamir> Artiom
		\details	Трейлинг отложенных ордеров в дельте от цены.
		\internal
			>Hist:		
					 @0.0.0.2@2013.06.12@artamir	[]	TralBSSS
			@0.0.1@2013.04.25@artamir	[]	TralBSSS
	*/
	
	double d[][OE_MAX];
	int dROWS = 0;
	int didx;
	int oti = -1;
	int oty = -1;
	double new_pr = 0.00;
	
	
	getOrdersByMethod(d);	//забираем ордера с текущим магиком.
	
	A_d_Sort2(d, OE_CP2OP+" <;"); //сортировка по убыванию
	
	dROWS = ArrayRange(d, 0);
	
	for(didx = 0; didx < dROWS; didx++){
		oti = d[didx][OE_TI];
		oty = d[didx][OE_TY];
		
		if(oty == OP_BUYSTOP){
			new_pr = MarketInfo(Symbol(), MODE_ASK)+TRAL_DeltaPips12*Point;
			TR_MoveOrder(oti, new_pr);
		}
		
		if(oty == OP_SELLSTOP){
			new_pr = MarketInfo(Symbol(), MODE_BID)-TRAL_DeltaPips12*Point;
			TR_MoveOrder(oti, new_pr);
		}
		
	}

}
//}

//{	=== PHASE 13
void eGH_Phase13(){											
	/**
		\version	0.0.0.1
		\date		2013.06.11
		\author		Morochin <artamir> Artiom
		\details	Must be called in begining of "start()" 
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.11@artamir	[]	TralBSSS
	*/

	if(isOrdersByMN()){
		TralBSSS13();
	}else{
		OpenBSSS13();
	}
}

void	OpenBSSS13(){
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
	ap = TRAL_DeltaPips13;
	tppips = 0;//OPEN_TPPips13;
	slpips = 0;//OPEN_SLPips13;
	
	//{		=== Open BS
	RefreshRates();
	sp = MarketInfo(Symbol(), MODE_ASK);
	TR_SendBUYSTOP_array(bs, sp, ap, vol, tppips, slpips, ""+TR_MN, -1);
	
	//..	=== Open SS
	RefreshRates();
	sp = MarketInfo(Symbol(), MODE_BID);
	TR_SendSELLSTOP_array(ss, sp, ap, vol, tppips, slpips, ""+TR_MN, -1);
	//}

}

void	TralBSSS13(){
	/**
		\version	0.0.0.2
		\date		2013.06.12
		\author		Morochin <artamir> Artiom
		\details	Трейлинг отложенных ордеров в дельте от цены.
		\internal
			>Hist:		
					 @0.0.0.2@2013.06.12@artamir	[]	TralBSSS
			@0.0.1@2013.04.25@artamir	[]	TralBSSS
	*/
	
	double d[][OE_MAX];
	int dROWS = 0;
	int didx;
	int oti = -1;
	int oty = -1;
	double new_pr = 0.00;
	
	
	getOrdersByMethod(d);	//забираем ордера с текущим магиком.
	
	A_d_Sort2(d, OE_CP2OP+" <;"); //сортировка по убыванию
	
	dROWS = ArrayRange(d, 0);
	
	for(didx = 0; didx < dROWS; didx++){
		oti = d[didx][OE_TI];
		oty = d[didx][OE_TY];
		
		if(oty == OP_BUYSTOP){
			new_pr = MarketInfo(Symbol(), MODE_ASK)+TRAL_DeltaPips13*Point;
			TR_MoveOrder(oti, new_pr);
		}
		
		if(oty == OP_SELLSTOP){
			new_pr = MarketInfo(Symbol(), MODE_BID)-TRAL_DeltaPips13*Point;
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
		\version	0.0.0.5
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:					
					 @0.0.0.5@2013.06.25@artamir	[]	CloseAllPendings
					 @0.0.0.4@2013.05.17@artamir	[]	CloseAllPendings
					 @0.0.0.3@2013.05.15@artamir	[]	CloseAllPendings
					 @0.0.0.2@2013.05.15@artamir	[]	CloseAllPendings
					 @0.0.0.1@2013.05.15@artamir	[]	CloseAllPendings
			>Rev:0
	*/

	double d[][OE_MAX];
	//{ --- Если СЛ > 0
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
	//}
	
	//{ --- Если СЛ = 0
	ArrayResize(d, 0);
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MN, TR_MN, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_SL, 0, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_CP2OP, (TRAL_DeltaPips), -1, AS_OP_ABOVE);
	
	A_d_Select(aOE, d);
	
	ROWS = ArrayRange(d, 0);
	
	for(idx = 0; idx < ROWS; idx++){
		ti = d[idx][OE_TI];
		TR_ModifySLByPrice(ti, TRAL_Step_pip);
	}
	//}
}	

//}


//}

//{	CAN WE TRADE
bool	CWT(	int d 	=	-1	/**	day of week*/
			,	string st="00:00:01"
			,	string et="00:00:10"){
	/**
		\version	0.0.0.2
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Проверяет если текущее смоделированное время сервера находится в заданном диапазоне.
		\internal
			>Hist:			
					 @0.0.0.2@2013.10.30@artamir	[!]	CWT
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
		datetime MC=DT_ModeledCurrent();
		res=DTs_isTimeBetween(MC,st,et);
	}
	
	//------------------------------------------------------
	return(res);
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
