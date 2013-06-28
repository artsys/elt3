	/**
		\version	0.1.0.2
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Советник Цена между двух МА
		\internal
			>Hist:												
					 @0.1.0.2@2013.06.28@artamir	[]	iif
					 @0.1.0.1@2013.06.28@artamir	[]	iif
					 @0.0.0.10@2013.06.27@artamir	[]	iif
					 @0.0.0.9@2013.06.27@artamir	[]	iif
					 @0.0.0.8@2013.06.27@artamir	[]	iif
					 @0.0.0.7@2013.06.26@artamir	[]	startext
					 @0.0.0.6@2013.06.26@artamir	[]	iif
					 @0.0.0.5@2013.06.25@artamir	[]	startext
					 @0.0.0.4@2013.06.25@artamir	[]	getExtraFN
					 @0.0.0.3@2013.06.25@artamir	[]	getExtraFN
					 @0.0.0.2@2013.06.25@artamir	[]	getExtraFN
					 @0.0.0.1@2013.06.25@artamir	[]	getExtraFN
			>Rev:0
			>Disclaimer:	Каждый переворот является новым уровнем OE_GL
							Начинаем работать с 0-го уровня.
	*/
	
//{ --- DEFINES
//{		--- MAIN
#define	EXP	"ePB2MA"
#define	VER	"0.1.0.2_2013.06.28"
//..	--- Open methods
#define	AOM_PB2MA		20
#define	AOM_PB2MA1_B	21
#define	AOM_PB2MA2_B	22
#define	AOM_PB2MA3_B	23
#define	AOM_PB2MA1_S	26
#define	AOM_PB2MA2_S	27
#define	AOM_PB2MA3_S	28	
//}
//}	

extern	string	AO_PB2MA_1 	= "=== START PRICE BETWEEN 2 MA ===";	//{
extern	bool	AO_PB2MA_Use = false;
extern	int		AO_PB2MA_MA1_per	= 16;
extern	int		AO_PB2MA_MA2_per	= 64;
extern	int		AO_PB2MA_MA3_per	= 256;
extern	int		AO_PB2MA_MA4_per	= 1024;
extern	int		AO_PB2MA_TP = 50;
extern	int		AO_PB2MA_SL = 20;
extern	double	AO_PB2MA_Lot1	= 0.1;
extern	double	AO_PB2MA_Lot2	= 0.2;
extern	double 	AO_PB2MA_Mylty	= 2;	//Коэф. увеличения объемов след. уровня
extern	bool	AO_PB2MA_revers = false;

int		AO_PB2MA_OpenLastMinutes = -1;	//check if was open any orders last 10 min.
extern	string	AO_PB2MA_2 = "=== END   PRICE BETWEEN 2 MA ===";
extern string	EXP_BP		= "=== BP   ==========";					//..	BREAK POINTS
	extern bool	Debug			= false;
	extern bool BP_PB2MA_AO		= false;
	extern bool BP_PB2MA_Tral	= false;
	extern bool BP_PB2MA_MR		= false;
	extern bool BP_Array_Sort	= false;
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

//{ --- INCLUDES
#include <sysELT3.mqh>
//}

//{ --- VARS	
string fnExtra = "";	//Название файла хранилища основного массива.	

int ma1h;
int ma2h;
int ma3h;
int ma4h;
int shift=1;
//}
	
int	init(){
	fnExtra = getExtraFN();

	//------------------------------------------------------
	ELT_init(fnExtra);

	ma1h = aMA_set(AO_PB2MA_MA1_per, MODE_EMA, PRICE_CLOSE,"",shift);
	ma2h = aMA_set(AO_PB2MA_MA2_per, MODE_EMA, PRICE_CLOSE,"",shift);
	ma3h = aMA_set(AO_PB2MA_MA3_per, MODE_EMA, PRICE_CLOSE,"",shift);
	ma4h = aMA_set(AO_PB2MA_MA4_per, MODE_EMA, PRICE_CLOSE,"",shift);
	
	return(0);
}	

int deinit(){
	ELT_deinit(fnExtra);

	return(0);
}

int start(){

	startext();

	return(0);
}

int startext(){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	функция старт
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	startext
			>Rev:0
	*/

	Comment(
		"EXP:"+EXP+"\n",
		"VER:"+VER+"\n",
		"iMAh_isPriceBetween2Ma("+ma1h+", "+ma2h+")="+iMAh_isPriceBetween2Ma(ma1h,ma2h));
	
	Main();
	
	//{ Проверяем выставленные ордера
		ePB2MA_TralPendings();
	//}
	
	//{ Проверка усреднения
	ePB2MA_Martin();
	//}
	
	//{	--- Автооткрытие ордеров.
		ePB2MA_AO();
	//}

	return(0);
}

//{ --- Дополнительные функции
//==========================================================
string getExtraFN(){
	
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
//}

//{ --- Expert functions

//{ --- Autoopen
void ePB2MA_AO(){
	/**
		\version	0.0.0.2
		\date		2013.06.26
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.06.26@artamir	[]	iif
					 @0.0.0.1@2013.06.25@artamir	[]	getExtraFN
			>Rev:0
	*/
	double aOByMN[][OE_MAX];
	ELT_SelectByMN_d2(aOE,aOByMN);
	
	double aO[][OE_MAX];
	ELT_SelectPositions_d2(aOByMN, aO);
	if(Debug && BP_PB2MA_AO){
		A_d_PrintArray2(aOByMN, 4, "aOByMN");
		A_d_PrintArray2(aO, 4, "aO1");
	}
	ELT_SelectOrders_d2(aOByMN, aO, true);
	if(Debug && BP_PB2MA_AO){
		A_d_PrintArray2(aO, 4, "aO2");
	}
	
	double aO1BS[][OE_MAX];
	double aO2BS[][OE_MAX];
	double aO3BS[][OE_MAX];
	
	if(iMAh_isPriceBetween2Ma(ma1h, ma2h, Close[1])){
		
		ELT_SelectByMethod_d2(aO, aO1BS, AOM_PB2MA1_B);
		if(ELT_SelectByMethod_d2(aO, aO1BS, AOM_PB2MA1_S, true) == 0){
			if(iMAh_isHierarhyUp(ma1h,ma2h)){
				ePB2MA_Open(AOM_PB2MA1_B);
			}else{
				ePB2MA_Open(AOM_PB2MA1_S);
			}
		}
	}
	
	if(iMAh_isPriceBetween2Ma(ma2h, ma3h, Close[1])){
		ELT_SelectByMethod_d2(aO, aO2BS, AOM_PB2MA2_B);
		if(ELT_SelectByMethod_d2(aO, aO2BS, AOM_PB2MA2_S, true) == 0){
			if(iMAh_isHierarhyUp(ma2h,ma3h)){
				ePB2MA_Open(AOM_PB2MA2_B);
			}else{
				ePB2MA_Open(AOM_PB2MA2_S);
			}
		}
	}
	
	if(iMAh_isPriceBetween2Ma(ma3h, ma4h, Close[1])){
		ELT_SelectByMethod_d2(aO, aO3BS, AOM_PB2MA3_B);
		if(ELT_SelectByMethod_d2(aO, aO3BS, AOM_PB2MA3_S, true) == 0){
			if(iMAh_isHierarhyUp(ma3h,ma4h)){
				ePB2MA_Open(AOM_PB2MA3_B);
			}else{
				ePB2MA_Open(AOM_PB2MA3_S);
			}
		}
	}
}

void ePB2MA_Open(int method){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Открывает отложенные ордера в зависимости от метода.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	getExtraFN
			>Rev:0
	*/

	double aMO[];	//Main orders;
	double ma;
	
	int op = -1;
	
	int ROWS_MO = 0;
	
	//{	--- OP_BUYSTOP
	if(method == AOM_PB2MA1_B){
		ma = iMAh_get(ma1h,0);
		op = OP_BUYSTOP;
	}
	
	if(method == AOM_PB2MA2_B){
		ma = iMAh_get(ma2h,0);
		op = OP_BUYSTOP;
	}
	
	if(method == AOM_PB2MA3_B){
		ma = iMAh_get(ma3h,0);
		op = OP_BUYSTOP;
	}
	//}
	
	//{	--- OP_SELLSTOP
	if(method == AOM_PB2MA1_S){
		ma = iMAh_get(ma1h,0);
		op = OP_SELLSTOP;
	}
	
	if(method == AOM_PB2MA2_S){
		ma = iMAh_get(ma2h,0);
		op = OP_SELLSTOP;
	}
	
	if(method == AOM_PB2MA3_S){
		ma = iMAh_get(ma3h,0);
		op = OP_SELLSTOP;
	}
	//}
	
	if(op == OP_BUYSTOP){
		if(!AO_PB2MA_revers){
			ROWS_MO = TR_SendBUYSTOP_array(aMO , ma, 0, AO_PB2MA_Lot1 ,0 ,0 ,method);
		}else{
			ROWS_MO = TR_SendSELLLIMIT_array(aMO , ma, 0, AO_PB2MA_Lot1, 0, 0, method);
		}	
	}
	
	if(op == OP_SELLSTOP){
		if(!AO_PB2MA_revers){
			ROWS_MO = TR_SendSELLSTOP_array(aMO, ma, 0, AO_PB2MA_Lot1 ,0 ,0 ,method);
		}else{
			ROWS_MO = TR_SendBUYLIMIT_array(aMO, ma, 0, AO_PB2MA_Lot1, 0, 0, method);
		}
	} 
	
	ROWS_MO = ArrayRange(aMO, 0);
	if(ROWS_MO > 0){
		for(int idx_MO = 0; idx_MO < ROWS_MO; idx_MO++){
			int ti = aMO[idx_MO];
			ePB2MA_ModifySLTP(ti);
			ePB2MA_OpenRevers(ti, method, AO_PB2MA_Lot2, 0);
			ePB2MA_setStandartData(ti, method, 0);
		}
	}
}

void ePB2MA_ModifySLTP(int ti){
	TR_ModifyTP(ti, AO_PB2MA_TP, TR_MODE_PIP);
	TR_ModifySL(ti, AO_PB2MA_SL, TR_MODE_PIP);
}

void ePB2MA_OpenRevers(int ti, int method, double lot, int gl){
	int ti_rev = TR_SendREVERSOrder(ti, lot);
	ePB2MA_ModifySLTP_revers(ti, ti_rev);
	ePB2MA_setStandartData(ti_rev, method, gl, ti);
	OE_setFIRByTicket(ti_rev, 1);
}

void ePB2MA_ModifySLTP_revers(int ti, int ti_rev){
	TR_ModifyTP(ti_rev, AO_PB2MA_TP, TR_MODE_PIP);
	TR_ModifySLOnTP(ti, ti_rev);
}

void ePB2MA_setStandartData(int ti, int method, int gl=0, int mp=0){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	getExtraFN
			>Rev:0
	*/
	OE_setStandartDataByTicket(ti);
	OE_setFODByTicket(ti);
	OE_setAOMByTicket(ti, method);
	OE_setGLByTicket(ti, gl);
	OE_setMPByTicket(ti, mp);
}
//}

//{ --- Tral orders
void ePB2MA_TralPendings(){
	/**
		\version	0.0.0.1
		\date		2013.06.27
		\author		Morochin <artamir> Artiom
		\details	Трал отложенников по соответствующим МА.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.27@artamir	[]	iif
			>Rev:0
	*/

	double aOByMN[][OE_MAX];
	ELT_SelectByMN_d2(aOE, aOByMN);
	
	double aO[][OE_MAX];			//Orders - отложенные ордера
	ELT_SelectOrders_d2(aOByMN, aO);
	
	//{ --- Проверка условий трала отложенников
	// 1. уровень = 0;
	// 2. маин парент = 0 или = тикету ордера.
	double aPGL[][OE_MAX];
	int ROWS_PGL=ELT_SelectByGL_d2(aO,aPGL);
	
	if(Debug && BP_PB2MA_Tral){
		A_d_PrintArray2(aO,4,"aP");
		A_d_PrintArray2(aPGL,4,"aPGL");
	}
	
	if(ROWS_PGL <= 0){return;}

	for(int idx_PGL = 0; idx_PGL < ROWS_PGL; idx_PGL++){
		int mp = aPGL[idx_PGL][OE_MP];
		int ti = aPGL[idx_PGL][OE_TI];
		if(!mp){
			ePB2MA_MoveMP(idx_PGL, aPGL);
		}
	}
	//}
}

void ePB2MA_MoveMP(int idx, double &aP[][]){
	/**
		\version	0.0.0.1
		\date		2013.06.27
		\author		Morochin <artamir> Artiom
		\details	Двигает ордер на цену Соответствующей ма
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.27@artamir	[]	iif
			>Rev:0
	*/

	int mah;
	
	int ti = aP[idx][OE_TI];
	int aom = aP[idx][OE_AOM];
	
	if(aom == AOM_PB2MA1_B || aom == AOM_PB2MA1_S){mah=ma1h;}
	if(aom == AOM_PB2MA2_B || aom == AOM_PB2MA2_S){mah=ma2h;}
	if(aom == AOM_PB2MA3_B || aom == AOM_PB2MA3_S){mah=ma3h;}
	
	TR_MoveOrder(ti, iMAh_get(mah));
	
	ePB2MA_MoveRevers(ti);
}

void ePB2MA_MoveRevers(int mp){
	/**
		\version	0.0.0.1
		\date		2013.06.27
		\author		Morochin <artamir> Artiom
		\details	Подтягивает реверсный ордер к родителю.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.27@artamir	[]	iif
			>Rev:0
	*/

	double aPRev[][OE_MAX];
	int ROWS_PRev = ELT_SelectByMP_d2(aOE, aPRev, mp);
	
	if(Debug && BP_PB2MA_MR){
		A_d_PrintArray2(aOE, 4, "aP");
		A_d_PrintArray2(aPRev, 4, "aPRev");
	} 
	
	//-------------------------------------
	if(ROWS_PRev <= 0){return;}
	
	//-------------------------------------
	for(int idx = 0; idx < ROWS_PRev; idx++){
		int ti_rev = aPRev[idx][OE_TI];
		TR_MoveToOrder(ti_rev, mp);
	}
	
}
//}

//{ --- Martin 
void ePB2MA_Martin(){
	/**
		\version	0.0.0.0
		\date		2013.06.27
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	
	//{ Определение условий усреднения.
	//1. если Закрыт основной ордитель, а его реверс еще не закрыт,
	//то для реверсного ордера переносим сл в безубыток.
	double aOByMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aOByMN);
	if(ROWS_MN <= 0){return;}				//Если нет ордеров советника, то и нечего тралить
	
	double aP[][OE_MAX];
	int ROWS_P = ELT_SelectPositions_d2(aOByMN, aP);
	if(ROWS_P <= 0){return;}	//если нет рыночных ордеров, то и нечего продолжать
	
	double aPRev[][OE_MAX];		//Из рыночных выбираем реверсные
	int ROWS_Rev = ELT_SelectByFIR_d2(aP, aPRev);
	if(ROWS_Rev <= 0){return;}
	
	for(int idx = 0; idx < ROWS_Rev; idx++){
		//Цикл по реверсным ордерам.
		//если родитель закрыт, то значит эта позиция подходит для безубытка и мартина.
		
		int ti = aPRev[idx][OE_TI];
		int mp = aPRev[idx][OE_MP];
		if(!OE_getICByTicket(mp)){continue;}
		
		//Безубыток.
		double op = Norm_symb(aPRev[idx][OE_OP]);
		TR_ModifySL(ti, op);
		
		ePB2MA_Martin_Open(ti);
	}
	//}
}

void ePB2MA_Martin_Open(int mp){
	/**
		\version	0.0.0.1
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.28@artamir	[]	iif
			>Rev:0
	*/

	//Отбор ордеров по MP.
	double aMP[][OE_MAX];
	int ROWS_MP = ELT_SelectByMP_d2(aOE, aMP, mp);

	if(ROWS_MP >= 1){return;}	//если есть ордера с заданным мп, то выходим.
	
	//МП - это реверсный ордер. Чтоб узнать цену открытия увеличенного ордера,
	//нужно выбрать мп от мп. и посмотреть его цену, а так же foty, чтоб выставить провильный ордер.
	int ti_mp_mp = OE_getMPByTicket(mp);
	
	ePB2MA_OpenNextLevel(mp, ti_mp_mp);
	
}

void ePB2MA_OpenNextLevel(int ti_mp/** реверсный ордер */, int ti_mp_mp/** родитель текущего уровня*/){
	/**
		\version	0.0.0.0
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Выставляет ордера нового уровня.
		\internal
			>Hist:
			>Rev:0
	*/

	//Выставляет основной ордер нового уровня.
	int this_level = OE_getGLByTicket(ti_mp_mp);
	int next_level = this_level+1;

	double this_lot = OE_getLOTByTicket(ti_mp_mp);
	double next_lot = this_lot*AO_PB2MA_Mylty;
	
	double this_lot_rev = OE_getLOTByTicket(ti_mp);
	double next_lot_rev = this_lot_rev*AO_PB2MA_Mylty;

	int this_type = OE_getFOTYByTicket(ti_mp_mp);
	int next_type = this_type;
	
	double this_op = OE_getOPByTicket(ti_mp_mp);
	double next_op = this_op;
	
	int this_method = OE_getAOMByTicket(ti_mp_mp);
	int next_method = this_method;
	
	double aO[];
	int ROWS_MO = TR_SendPending_array(aO, next_type, next_op, 0, next_lot, 0, 0, "lvl "+next_level, -1);
	
	for(int idx = 0; idx<ROWS_MO; idx++){
		int ti = aO[idx];
			ePB2MA_ModifySLTP(ti);
			ePB2MA_OpenRevers(ti, next_method, next_lot_rev, next_level);
			ePB2MA_setStandartData(ti, next_method, next_level, ti_mp);
		
	}
}

int MAH_By_Method(int method){
	/**
		\version	0.0.0.0
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Возвращает хэндл ма по методу открытия.
		\internal
			>Hist:
			>Rev:0
	*/
	
	if(method == AOM_PB2MA1_B || method == AOM_PB2MA1_S){return(ma1h);}
	if(method == AOM_PB2MA2_B || method == AOM_PB2MA2_S){return(ma2h);}
	if(method == AOM_PB2MA3_B || method == AOM_PB2MA3_S){return(ma3h);}
}
//}
//}