	/**
		\version	1.509.4.7
		\date		2014.03.04
		\author		Morochin <artamir> Artiom
		\details	Советник работает по индикатору StohCross
		\internal
		>Hist:																																																						
				 @1.509.4.7@2014.03.04@artamir	[+]	TN_check
				 @1.509.4.6@2014.03.04@artamir	[+]	TN_checkMP
				 @1.509.4.5@2014.03.04@artamir	[+]	TN
				 @1.509.4.4@2014.02.06@artamir	[+]	MOIS_check
				 @1.509.4.3@2014.02.06@artamir	[+]	MOIS_main
				 @1.509.4.2@2014.02.06@artamir	[*]	Autoopen
				 @1.0.3.11@2014.01.31@artamir	[!]	Autoopen
				 @1.0.3.10@2014.01.31@artamir	[+]	GetLot
				 @1.0.3.9@2014.01.23@artamir	[!] Ужесточились правила расчета фрактала.	
				 @1.0.3.8@2014.01.22@artamir	[*]	Tral_Fr
				 @1.0.3.7@2014.01.22@artamir	[*]	Tral_Fr
				 @1.0.3.6@2014.01.22@artamir	[*]	Tral_Fr
				 @1.0.3.5@2014.01.22@artamir	[*]	Tral_Fr
				 @1.0.3.4@2014.01.17@artamir	[!]	Исправление в функциях нужных для шаблона.
				 @1.0.3.3@2014.01.17@artamir	[*]	Autoclose
				 @1.0.2.4@2014.01.17@artamir	[!]	init
				 @1.0.2.3@2014.01.17@artamir	[!]	start
				 @1.0.2.2@2014.01.16@artamir	[]	GetSignal
				 @1.0.1.11@2014.01.15@artamir	[]	start
				 @1.0.1.10@2014.01.15@artamir	[]	CMFB
				 @1.0.1.9@2014.01.15@artamir	[!]	GetSignal
				 @1.0.1.8@2014.01.15@artamir	[+]	GetSignal
				 @1.0.1.7@2014.01.15@artamir	[+]	CMFB
				 @1.0.1.6@2014.01.13@artamir	[+]	startext
				 @1.0.1.5@2014.01.13@artamir	[+]	GetSignal
					 @1.0.1.4@2014.01.13@artamir	[!]	GetSignal
					 @1.0.1.3@2014.01.13@artamir	[!]	isNewBar
					 @1.0.1.2@2014.01.08@artamir	[]	Tral_ATR
					 @1.0.1.1@2014.01.08@artamir	[]	FIXProfit
			>Rev:0
	*/
	
bool IsNewBar=false;
datetime lastBarTime=0;

int hfr=-1;

int session_id=0;

double ZeroBalance=0;
bool needEraseOE=false;

int MOIS_count=0;
int MOIS_type=-1;

#define EXP	"eVVSS_StohCross"	
#define VER	"1.509.4.7_2014.03.04"

extern	string	s1="==== MAIN ====="; //{
extern	int SL=50;
extern	int TP=50;
extern	double LOT=0.01;
extern	bool Autolot_use=false; //Разрешает использовать автоматический расчет объема выставляемой позиции.
extern double MaxRisk=1; //Процент от свободных средств, которые можно использовать для открытия позиции.

extern	bool FIXProfit_use=false;	//Закрывать все ордера при достижении заданного профита.
extern	double FIXProfit_amount=500; //Значение фиксированного профита для закрытия всех ордеров.
extern bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
extern int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)

extern bool MOIS_use=false; //Разрешает советнику использовать максимальное количество ордеров в серии.
extern int	MOIS_amount=50; //Максимальное количество ордеров в серии.

extern string s2="===== TREND NET =====";
extern bool TN_use=false; //Использовать сетку ордеров.
extern int TN_step=20; //В пунктах
extern int TN_levels=5; //количество уровней сетки.

extern string os="===== STOHCROSS OPEN =====";
extern int       KPeriod1    	 =  8;
extern int       DPeriod1    	 =  3;
extern int       Slowing1    	 =  3;
extern int       MAMethod1    	=   0;
extern int       PriceField1  	=   1;
extern bool		CloseOnRevers	=false;
extern int		MinClosePips 	=5; //Минимальное количество пунктов, ближе которых к цене открытия ордер закрываться не будет по обратному сигналу.
extern int		BarsShift		=1;
extern string fs1="=== FILTER VininIHMA ===";
//---- input parameters
extern bool FHMA_use		=false; 
extern int 	FHMA_period		=16; 
extern int 	FHMA_method		=3; // MODE_SMA 
extern int 	FHMA_price		=0; // PRICE_CLOSE 
extern int 	FHMA_sdvig		=0;
extern int 	FHMA_CheckBar	=1; 
extern string fe1="========================";

extern string fs2="=== FILTER Trendsignal ===";
extern bool FTS_use=false;
extern int FTS_RISK=3;
extern int FTS_CountBars=300;
extern int FTS_SignalBar = 1; 
extern string fe2="========================";

extern string fs3="=== FILTER indiAlert ===";
extern bool FIA_use				=false;
extern int 	FIA_ExtDepth 		= 37;
extern int 	FIA_ExtDeviation 	= 13;
extern int 	FIA_ExtBackstep 	= 5;
extern int 	FIA_SIGNAL_BAR 		= 1 ;
extern string fe3="========================";
//-----

extern bool		TRAL_Use		=false;
extern int		TRAL_DeltaPips	=10;
extern int		TRAL_Step_pip	=5;

extern bool		TRAL_Fr_Use	=false;
extern int		TRAL_Fr_TF	=0;	//таймфрейм расчета фракталов.
extern int		TRAL_Fr_R	=2;	//количество баров справа для определения фрактала
extern int		TRAL_Fr_L	=2;	//количество баров слева для определения фрактала
extern int		TRAL_Fr_Filter_pip=0; //количество пунктов фильтра для установки стоплосса. К ценовуму уровню хая или лоу фрактала добавляется или отнимается заданное количество пунктов.  

extern bool		TRAL_ATR_use	=false;
extern int		TRAL_ATR_TF		=0;
extern int		TRAL_ATR1_Per	=5;
extern int		TRAL_ATR2_Per	=20;
extern double	TRAL_ATR_COEF	=1;
extern bool		TRAL_ATR_INLOSS	=false;

extern bool		use_Revers=false;
extern	string	e1="==== EXPERT END =====";//}

#include <sysELT3.mqh>
#include <sysObjects2.mqh>	
#include <iFractal.mqh>

string a[][9];
int htable = -1;

//{ --- Функции установки внешних настроек эксперта.

string eVVSSSC_Ver_get(){
	return(VER);
}
string eVVSSSC_Exp_get(){
	return(EXP);
}

void eVVSSSC_SL_set(int val){
	if(val==EMPTY_VALUE)return;
	SL=val;
}
void eVVSSSC_TP_set(int val){
	if(val==EMPTY_VALUE)return;
	TP=val;
}
void eVVSSSC_LOT_set(double val){
	if(val==EMPTY_VALUE)return;
	LOT=val;
}

void eVVSSSC_FIXProfit_use_set(bool val){
	if(val==EMPTY_VALUE)return;
	FIXProfit_use=val;
}
void eVVSSSC_FIXProfit_amount_set(double val){
	if(val==EMPTY_VALUE)return;
	FIXProfit_amount=val;
}

void eVVSSSC_CMFB_use_set(bool val){
	if(val==EMPTY_VALUE)return;
	CMFB_use=val;
}
void eVVSSSC_CMFB_pips_set(int val){
	if(val==EMPTY_VALUE)return;
	CMFB_pips=val;
}

void eVVSSSC_KPeriod1_set(int val){
	if(val==EMPTY_VALUE)return;
	KPeriod1=val;
}
void eVVSSSC_DPeriod1_set(int val){
	if(val==EMPTY_VALUE)return;
	DPeriod1=val;
}
void eVVSSSC_Slowing1_set(int val){
	if(val==EMPTY_VALUE)return;
	Slowing1=val;
}
void eVVSSSC_MAMethod1_set(int val){
	if(val==EMPTY_VALUE)return;
	MAMethod1=val;
}
void eVVSSSC_PriceField1_set(int val){
	if(val==EMPTY_VALUE)return;
	PriceField1=val;
}

void eVVSSSC_CloseOnRevers_set(bool val){
	if(val==EMPTY_VALUE)return;
	CloseOnRevers=val;
}
void eVVSSSC_BarsShift_set(int val){
	if(val==EMPTY_VALUE)return;
	BarsShift=val;
}

void eVVSSSC_FHMA_use_set(bool val){
	if(val==EMPTY_VALUE)return;
	FHMA_use=val;
}
void eVVSSSC_FHMA_period_set(int val){
	if(val==EMPTY_VALUE)return;
	FHMA_period=val;
}
void eVVSSSC_FHMA_method_set(int val){
	if(val==EMPTY_VALUE)return;
	FHMA_method=val;
}
void eVVSSSC_FHMA_price_set(int val){
	if(val==EMPTY_VALUE)return;
	FHMA_price=val;
}
void eVVSSSC_FHMA_sdvig_set(int val){
	if(val==EMPTY_VALUE)return;
	FHMA_sdvig=val;
}
void eVVSSSC_FHMA_CheckBar_set(int val){
	if(val==EMPTY_VALUE)return;
	FHMA_CheckBar=val;
}

void eVVSSSC_FIA_use_set(bool val){
	if(val==EMPTY_VALUE)return;
	FIA_use=val;
}
void eVVSSSC_FIA_ExtDepth_set(int val){
	if(val==EMPTY_VALUE)return;
	FIA_ExtDepth =val;
}
void eVVSSSC_FIA_ExtDeviation_set(int val){
	if(val==EMPTY_VALUE)return;
	FIA_ExtDeviation=val;
}
void eVVSSSC_FIA_ExtBackstep_set(int val){
	if(val==EMPTY_VALUE)return;
	FIA_ExtBackstep=val;
}	
void eVVSSSC_FIA_SIGNAL_BAR_set(int val){
	if(val==EMPTY_VALUE)return;
	FIA_SIGNAL_BAR =val;
}	

void eVVSSSC_TRAL_Use_set(bool val){
	if(val==EMPTY_VALUE)return;
	TRAL_Use=val;
}	
void eVVSSSC_TRAL_DeltaPips_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_DeltaPips=val;
}	
void eVVSSSC_TRAL_Step_pip_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_Step_pip=val;
}		

void eVVSSSC_TRAL_Fr_Use_set(bool val){
	if(val==EMPTY_VALUE)return;
	TRAL_Fr_Use=val;
}		
void eVVSSSC_TRAL_Fr_TF_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_Fr_TF=val;
}		
void eVVSSSC_TRAL_Fr_R_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_Fr_R=val;
}		
void eVVSSSC_TRAL_Fr_L_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_Fr_L=val;
}			

void eVVSSSC_TRAL_ATR_use_set(bool val){
	if(val==EMPTY_VALUE)return;
	TRAL_ATR_use=val;
}			
void eVVSSSC_TRAL_ATR_TF_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_ATR_TF=val;
}			
void eVVSSSC_TRAL_ATR1_Per_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_ATR1_Per=val;
}			
void eVVSSSC_TRAL_ATR2_Per_set(int val){
	if(val==EMPTY_VALUE)return;
	TRAL_ATR2_Per=val;
}
void eVVSSSC_TRAL_ATR_COEF_set(double val){
	if(val==EMPTY_VALUE)return;
	TRAL_ATR_COEF=val;
}			
void eVVSSSC_TRAL_ATR_INLOSS_set(bool val){
	if(val==EMPTY_VALUE)return;
	TRAL_ATR_INLOSS=val;
}			

void eVVSSSC_use_Revers_set(bool val){
	if(val==EMPTY_VALUE)return;
	use_Revers=val;
}			

//}

int init(){
	/**
		\version	0.0.1.1
		\date		2014.01.17
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.1.1@2014.01.17@artamir	[!]	Добавлены функции для реализации внешнего запуска эксперта.
					 @0.0.0.2@2013.12.30@artamir	[]	init
					 @0.0.0.1@2013.12.27@artamir	[*]	init
			>Rev:0
	*/
	string fn="init";
	ArrayResize(a, 0);
	ArrayResize(a,2);
	Print(fn);
	int tmr=GetTickCount();
	double i=iCustom(NULL,0,"StochCrossingf_e",KPeriod1,DPeriod1,Slowing1,PriceField1,0,BarsShift);
	Print("tmr=",(GetTickCount()-tmr)/100," sec.");
	
	aFR_init();
	hfr=aFR_set(TRAL_Fr_L,TRAL_Fr_R,TRAL_Fr_TF);
	
	//-------------------
	eVVSSSC_SL_set(EMPTY_VALUE); //{
	eVVSSSC_TP_set(EMPTY_VALUE);
	eVVSSSC_LOT_set(EMPTY_VALUE);
	eVVSSSC_FIXProfit_use_set(EMPTY_VALUE);
	eVVSSSC_FIXProfit_amount_set(EMPTY_VALUE);
	eVVSSSC_CMFB_use_set(EMPTY_VALUE);
	eVVSSSC_CMFB_pips_set(EMPTY_VALUE); //}
	
	eVVSSSC_KPeriod1_set(EMPTY_VALUE); //{
	eVVSSSC_DPeriod1_set(EMPTY_VALUE);
	eVVSSSC_Slowing1_set(EMPTY_VALUE);
	eVVSSSC_MAMethod1_set(EMPTY_VALUE);
	eVVSSSC_PriceField1_set(EMPTY_VALUE); //}
	
	eVVSSSC_CloseOnRevers_set(EMPTY_VALUE); //{
	eVVSSSC_BarsShift_set(EMPTY_VALUE); //}
	
	eVVSSSC_FHMA_use_set(EMPTY_VALUE); //{
	eVVSSSC_FHMA_period_set(EMPTY_VALUE);
	eVVSSSC_FHMA_method_set(EMPTY_VALUE);
	eVVSSSC_FHMA_price_set(EMPTY_VALUE);
	eVVSSSC_FHMA_sdvig_set(EMPTY_VALUE);
	eVVSSSC_FHMA_CheckBar_set(EMPTY_VALUE); //}
	
	eVVSSSC_FIA_use_set(EMPTY_VALUE); //{			
	eVVSSSC_FIA_ExtDepth_set(EMPTY_VALUE);		
	eVVSSSC_FIA_ExtDeviation_set(EMPTY_VALUE);	
    eVVSSSC_FIA_ExtBackstep_set(EMPTY_VALUE);	
    eVVSSSC_FIA_SIGNAL_BAR_set(EMPTY_VALUE); //}

	eVVSSSC_TRAL_Use_set(EMPTY_VALUE);	//{	
	eVVSSSC_TRAL_DeltaPips_set(EMPTY_VALUE);	
	eVVSSSC_TRAL_Step_pip_set(EMPTY_VALUE);	//}	
	
	eVVSSSC_TRAL_Fr_Use_set(EMPTY_VALUE); //{
	eVVSSSC_TRAL_Fr_TF_set(EMPTY_VALUE);	
	eVVSSSC_TRAL_Fr_R_set(EMPTY_VALUE);	
	eVVSSSC_TRAL_Fr_L_set(EMPTY_VALUE);	//}
	
	eVVSSSC_TRAL_ATR_use_set(EMPTY_VALUE); //{		
	eVVSSSC_TRAL_ATR_TF_set(EMPTY_VALUE);			
	eVVSSSC_TRAL_ATR1_Per_set(EMPTY_VALUE);		
	eVVSSSC_TRAL_ATR2_Per_set(EMPTY_VALUE);		
	eVVSSSC_TRAL_ATR_COEF_set(EMPTY_VALUE);		
	eVVSSSC_TRAL_ATR_INLOSS_set(EMPTY_VALUE); //}		
	
	eVVSSSC_use_Revers_set(EMPTY_VALUE);
	//-------------------
	eVVSSSC_Ver_get();
	eVVSSSC_Exp_get();
	
	return(0);
}

int deinit(){
	ELT_deinit();

	return(0);
}

int start(){
	/**
		\version	0.0.0.4
		\date		2014.01.17
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:				
					 @0.0.0.4@2014.01.17@artamir	[!]	Содержимое перенесено в функцию startextern(для возможности вызова из внешнего эксперта)
					 @0.0.0.3@2014.01.15@artamir	[+]	добавлена очистка массива aOE по needEraseOE.
					 @0.0.0.2@2014.01.08@artamir	[!]	start
					 @0.0.0.1@2013.12.30@artamir	[+]	Добавлена проверка статусов ордеров бд.
			>Rev:0
	*/
	string fn="start";
	
	int res=eVVSSSC_startextern();
	
	return(res);
}

int startext(){
	/**
		\version	0.0.0.2
		\date		2014.01.13
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2014.01.13@artamir	[+]	CloseMinusFromBalance.
					 @0.0.0.1@2014.01.08@artamir	[+]	startext
			>Rev:0
	*/
	
	string fn="startext";
	
	if(Autoclose()){
		return(0);
	}
	
	if(FIXProfit())return(0);
	
	CMFB();
	
	Tral();
	
	Tral_Fr();
	
	Tral_ATR();
	
	TN();
	
	Autoopen();
	BP_SEL=false;
	//-------------------------------------------
	return(0);
}

int eVVSSSC_startextern(){
	string fn="startextern";
	Comment(fn+":"+Time[0],"\n"
			,"use_Revers=",use_Revers);
	
	ELT_start();
	if(OrdersTotal()>0){
		//DrawTable();
		//A_d_PrintArray2(aOE,4,"OE");
	}
	
	if(	!FIXProfit_use&&!CMFB_use){
		
		//----------------------
		OE_delClosed();
	}	
	
	if(needEraseOE){
		OE_delClosed();
		needEraseOE=false;
	}
	
	OE_eraseArray();
	
	OE_RecheckStatuses();
	
	if(OrdersTotal() <=0){
		session_id++;
	}
	
	int ret = startext();
	
	//-------------------------------------------
	return(ret);
}

void CMFB(){
	/**
		\version	0.0.0.2
		\date		2014.01.15
		\author		Morochin <artamir> Artiom
		\details	Закрытие минусовых ордеров из средств баланса.
		\internal
			>Hist:		
					 @0.0.0.2@2014.01.15@artamir	[+]	Добавлено удаление закрытых ордеров, после закрытия хоть одного минусового ордера, если профит по закрытым ордерам не превышает 1.
					 @0.0.0.1@2014.01.15@artamir	[+]	CMFB
			>Rev:0
	*/

	string fn="CMFB";
	
	if(!CMFB_use)return;
	
	//Получаем сумму всех закрытых ордеров сессии.
	string f="";
	f=StringConcatenate(f
		,OE_MN,"==",TR_MN
		," AND "
		,OE_IC,"==1");
		
	int aI[];
	ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	
	Select(aOE,aI,f);
	
	int rows=ArrayRange(aI,0);
	
	if(rows<=0)return; //Значит у нас нет профита для закрытия минусов.
	
	double profit=AId_Sum(aOE, aI, OE_OPR);
	//Comment("Closed profit=",profit);
	
	//Выбираем ордера которые ушли в минус больше заданного значения.
	f="";
	f=StringConcatenate(f
		,OE_MN,"==",TR_MN
		," AND "
		,OE_IT,"==1"
		," AND "
		,OE_IM,"==1"
		," AND "
		//,OE_OPR,"<<0"
		//," AND "
		,OE_CP2OP,"<<",-CMFB_pips);
	ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	
	//BP_SEL=true;
	Select(aOE,aI,f);
	BP_SEL=false;
	rows=ArrayRange(aI,0);
	Comment("Count orders in minus=",rows,"\n"
			,"profit=",profit);
			
	if(profit<=0)return;		
	if(rows<=0)return; //нет таких ордеров.
	int i=0;
	while(profit>0&&i<rows){
		int ti=aOE[aI[i]][OE_TI];
		double opr=aOE[aI[i]][OE_OPR];
		if(MathAbs(opr)<=profit){
			if(TR_CloseByTicket(ti)){
				profit=profit-MathAbs(opr);
				needEraseOE=true;
			}	
		}else{
			break;
		}
	}
	
	if(needEraseOE){
		if(profit>0){
			needEraseOE=false;
		}
	}
}

void Autoopen(){
	/**
		\version	0.0.0.3
		\date		2014.01.31
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.0.3@2014.01.31@artamir	[!]	Добавлен автолот.
					 @0.0.0.2@2013.12.31@artamir	[*]	Исправлена проверка , что ордер выставлен на текущем баре.
					 @0.0.0.1@2013.12.13@artamir	[+]	Добавлен выбор объема ордера.
			>Rev:0
	*/
	
	string fn="Autoopen";
	//Print(fn,"-> GetSignal()");
	int op=GetSignal();
	
	//-------------------------------------------
	if(op<0) return;
	
	string f="";
	if(use_Revers){
		if(op==OP_BUY)op=OP_SELL;
		else
			if(op==OP_SELL)op=OP_BUY;
	}	
	
	f=OE_IT+"==1 AND "+OE_IM+"==1 AND "+OE_FOTY+"=="+op+" AND "+OE_FOOT+"=="+Time[BarsShift];
	
	int aI[];
	
	//Print(fn,"-> ArrayResize(aI,0)");
	ArrayResize(aI,0);
	
	//Print(fn,"-> AId_Init2(aOE, aI)");
	AId_Init2(aOE, aI);
		
	//-------------------------------------------
	
	//Print(fn,"-> Select(aOE, aI, f)");
	Select(aOE, aI, f);
	if(ArrayRange(aI,0)>0) return; //есть ордера, открытые по этому сигналу на тек. баре. 
	
	int ti=-1;
	
	//Print(fn,"-> isNewBar()");
	if(isNewBar()){ 
		
		if(!MOIS_check(op))return;
		
		ti=TR_SendMarket(op, GetLot());
		
		if(ti<=0){
			Print(fn,": Cant send order");
			Print(fn,".err=",GetLastError());
			Print(fn,".op=",op);
			return;
		}
		
		TR_ModifyTP(ti,TP,TR_MODE_PIP);
		TR_ModifySL(ti,SL,TR_MODE_PIP);
		OE_setFODByTicket(ti);
		OE_setFOOTByTicket(ti, Time[BarsShift]);
		
		MOIS_main(op);
	}
}

void MOIS_main(int ty){
	/**
		\version	0.0.0.1
		\date		2014.02.06
		\author		Morochin <artamir> Artiom
		\details	Учет серии ордеров.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.06@artamir	[+]	MOIS_main
			>Rev:0
	*/

	if(!MOIS_use) return;
	
	if(ty!=MOIS_type){
		MOIS_count=1;
		MOIS_type=ty;
	}else{
		MOIS_count++;
	}
	
}

bool MOIS_check(int op){
	/**
		\version	0.0.0.1
		\date		2014.02.06
		\author		Morochin <artamir> Artiom
		\details	Возвращае тру, если можно откывать ордер в заданном направлении.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.06@artamir	[+]	MOIS_check
			>Rev:0
	*/
	if(!MOIS_use)return(true);
	
	if(MOIS_type!=op)return(true);
	
	if(MOIS_count<MOIS_amount)return(true);
	
	return(false);
}

void TN(){
	/**
		\version	0.0.0.1
		\date		2014.03.04
		\author		Morochin <artamir> Artiom
		\details	Модуль сетки ордеров в направлении тренда.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.04@artamir	[+]	TN
			>Rev:0
	*/
	string fn="TN";
	
	if(!TN_use)return;
	
	//Отбираем ордера у которых не задан MP.
	int aI[]; ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	string f=StringConcatenate(""
	,OE_IT+"==1"
	," AND "
	,OE_MP+"==0");
	
	Select(aOE,aI,f);
	
	if(ArrayRange(aI,0)>0)TN_check(aI);
}

void TN_check(int &aI[]){
	/**
		\version	0.0.0.1
		\date		2014.03.04
		\author		Morochin <artamir> Artiom
		\details	Проверка, есть ли ордера с MP=одному из aI
		если нет, то выставляется сетка таких ордеров.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.04@artamir	[]	TN_check
			>Rev:0
	*/
	string fn="TN_check";
	
	int rows=ArrayRange(aI,0);
	for(int i=0;i<rows;i++){
		int mp_ti=aOE[aI[i]][OE_TI];
		TN_checkMP(mp_ti, aI[i]);
	}
}

void TN_checkMP(int mp, int idx){
	/**
		\version	0.0.0.1
		\date		2014.03.04
		\author		Morochin <artamir> Artiom
		\details	проверяет для заданного mp, есть ли дочерние ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.04@artamir	[]	TN_checkMP
			>Rev:0
	*/
	string fn="";
	int p_ty=aOE[idx][OE_TY];
	
	int aI[]; ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	
	string f=StringConcatenate(""
	, OE_MP+"=="+mp);
	
	Select(aOE,aI,f);
	if(ArrayRange(aI,0)<=0){
		double start_price=Norm_symb(aOE[idx][OE_OOP]);
		for(int lvl=0;lvl<TN_levels;lvl++){
			double d[];
			int AddPips=TN_step*(lvl+1);
			if(p_ty==OP_BUY){
				ArrayResize(d,0);
				TR_SendBUYSTOP_array(d,	start_price, AddPips, GetLot(), TP, SL);
			}

			if(p_ty==OP_SELL){
				ArrayResize(d,0);
				TR_SendSELLSTOP_array(d,	start_price, AddPips, GetLot(), TP, SL);
			}

			int rows=ArrayRange(d,0);
			for(int i=0;i<rows;i++){
				OE_setMPByTicket(d[i],mp);
			}	
		}
	}
}

bool Autoclose(){
	/**
		\version	0.0.0.2
		\date		2014.01.17
		\author		Morochin <artamir> Artiom
		\details	Автозакрытие ордеров.
		\internal
			>Hist:		
					 @0.0.0.2@2014.01.17@artamir	[+]	Добавлена проверка на минимальное количество пунктов для закрытия ордера.
					 @0.0.0.1@2013.12.30@artamir	[+]	Autoclose
			>Rev:0
	*/
	string fn="Autoclose";
	
	bool res=false;
	
	if(!CloseOnRevers)return(false);
	
	int op=GetSignal();
	
	if(op<=-1){return(false);}
	
	if(use_Revers){
		if(op==OP_BUY)op=OP_SELL;
		else 
			if(op==OP_SELL)op=OP_BUY;
	}
	
	if(op==OP_BUY)op=OP_SELL;
	else
		if(op==OP_SELL)op=OP_BUY;
		else
			return(false);
	
	
	string f=OE_IT+"==1 AND "+OE_IM+"==1 AND "+OE_TY+"=="+op;
	
	int aI[];
	AId_Init2(aOE, aI);
		
	//-------------------------------------------
	Select(aOE, aI, f);
	if(ArrayRange(aI,0)<=0) return; //нет ордеров, удовлетворяющих запросу
	
	int rows=ArrayRange(aI,0);
	for(int i=0;i<rows;i++){
		int ti=aOE[aI[i]][OE_TI];
		
		if(MinClosePips>0){
			int pips=aOE[aI[i]][OE_CP2OP];
			pips=MathAbs(pips);
			if(pips<MinClosePips)continue;
		}
		
		TR_CloseByTicket(ti);
		res=true;
	}
	
	return(res);
}

void Tral(){
	/**
		\version	0.0.0.3
		\date		2014.01.06
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:								
					 @0.0.0.3@2014.01.06@artamir	[!]	Исправлена работа трала при СЛ>0
					 @0.0.0.2@2013.12.31@artamir	[!]	Исправлена работа трала.
					 @0.0.0.1@2013.12.13@artamir	[+]	Tral
			>Rev:0
	*/

	string fn="Tral";
	if(!TRAL_Use){return;}
	
	double d[][OE_MAX];
	
	string	f="";
			
	//{ --- Если СЛ > 0
		f=OE_IT+"==1 AND "+OE_MN+"=="+TR_MN+" AND "+OE_CP2SL+">>"+(TRAL_Step_pip+TRAL_DeltaPips)+" AND "+OE_CP2OP+">>"+(TRAL_Step_pip+TRAL_DeltaPips);
		
		int aI[];
		ArrayResize(aI,0);
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		Select(aOE, aI, f);
		int rows=ArrayRange(aI,0);
		
		
		for(int idx = 0; idx < rows; idx++){
			int ti = aOE[aI[idx]][OE_TI];
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
	
	rows = ArrayRange(d, 0);
	
	for(idx = 0; idx < rows; idx++){
		ti = d[idx][OE_TI];
		TR_ModifySLByPrice(ti, TRAL_Step_pip);
	}
	//}
	
	ArrayResize(d,0);
}	

void Tral_Fr(){
	/**
		\version	0.0.0.7
		\date		2014.01.22
		\author		Morochin <artamir> Artiom
		\details	Трал по фракталам
		\internal
			>Hist:												
					 @0.0.0.7@2014.01.22@artamir	[*]	Стоплоссы трялятся только в направлении получения профита по ордеру.
					 @0.0.0.6@2014.01.22@artamir	[+]	Добавлен фильтр для установки сл или тп
					 @0.0.0.5@2014.01.22@artamir	[*]	Исправлен расчет Миниального и максимального бара.
					 @0.0.0.4@2014.01.06@artamir	[!]	Tral_Fr
					 @0.0.0.3@2013.12.30@artamir	[!!]	Tral_Fr
					 @0.0.0.2@2013.12.30@artamir	[!]	Исправлен трал селл ордеров.
					 @0.0.0.1@2013.12.13@artamir	[+]	Tral
			>Rev:0
	*/

	string fn="Tral_Fr";
	if(!TRAL_Fr_Use){return;}
	
	double d[][OE_MAX];
	
	int bUP=iFR_getNearestUpBarTF(hfr,1);//iHighest(Symbol(), TRAL_Fr_TF, MODE_HIGH, iFR_getNearestUpBarTF(hfr,1)+1,0);
	int bDW=iFR_getNearestDwBarTF(hfr,1);//iLowest(Symbol(), TRAL_Fr_TF, MODE_LOW, iFR_getNearestDwBarTF(hfr,1)+1,0);
	
	double fUp=iHigh(Symbol(), TRAL_Fr_TF, bUP)+TRAL_Fr_Filter_pip*Point;
	double fDw=iLow(Symbol(), TRAL_Fr_TF, bDW)-TRAL_Fr_Filter_pip*Point;
	
	//Print(fn,".fUp="+fUp,"; .bUP="+bUP);
	//Print(fn,".fDw="+fDw,"; .bDW="+bDW);
	
	string	f="";
			
	//{ --- Тралим баи
		f=StringConcatenate(	OE_IT,"==1"
							,	" AND "
							,	OE_MN,"==",TR_MN
							,	" AND "
							,	OE_TY,"==",OP_BUY);
		
		int aI[];
		ArrayResize(aI,0);
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		Select(aOE, aI, f);
		int rows=ArrayRange(aI,0);
		
		for(int idx = 0; idx < rows; idx++){
			int ti = aOE[aI[idx]][OE_TI];
			double sl=aOE[aI[idx]][OE_SL];
			double tp=aOE[aI[idx]][OE_TP];
			if(use_Revers)
				TR_ModifyTP(ti, fUp);
			else
				if(fDw>sl){
					TR_ModifySL(ti, fDw);
				}	
		}
	//}
	
	f="";
	//{ --- Тралим селлы
		f=StringConcatenate(	OE_IT,"==1"
							,	" AND "
							,	OE_MN,"==",TR_MN
							,	" AND "
							,	OE_TY,"==",OP_SELL);
		
		ArrayResize(aI,0);
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		Select(aOE, aI, f);
		rows=ArrayRange(aI,0);
		
		for(idx = 0; idx < rows; idx++){
			ti = aOE[aI[idx]][OE_TI];
			sl = aOE[aI[idx]][OE_SL];
			if(use_Revers)
				TR_ModifyTP(ti, fDw);
			else
				if(fUp<sl){
					TR_ModifySL(ti, fUp);
				}	
		}
	//}
	
	ArrayResize(d,0);
}	

void Tral_ATR(){
	/**
		\version	0.0.0.1
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.08@artamir	[]	Tral_ATR
			>Rev:0
	*/
	
	if(!TRAL_ATR_use) return;
	//Выбираем живые ордера и тралим их.
	string f="";
	f=StringConcatenate(	OE_IT,"==1"
							,	" AND "
							,	OE_MN,"==",TR_MN);
		
		int aI[];
		ArrayResize(aI,0);
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		Select(aOE, aI, f);
		int rows=ArrayRange(aI,0);
		
		for(int idx = 0; idx < rows; idx++){
			int ti = aOE[aI[idx]][OE_TI];
			
			TrailingByATR(ti, TRAL_ATR_TF, TRAL_ATR1_Per, 0, TRAL_ATR2_Per, 0, TRAL_ATR_COEF, TRAL_ATR_INLOSS);
			
			
		}
	
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

	string fn="FIXProfit";
	
	if(!FIXProfit_use)return;
	
	double profit=Ad_Sum2(aOE,OE_OPR);
	
	Comment("profit=",profit);
	
	if(profit<FIXProfit_amount)return(false);
	
	CloseAllOrders();
	needEraseOE=true;
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
	Select(aOE, aI, f);
	int rows=ArrayRange(aI,0);
	Print(fn, ".rows=",rows);
	for(int idx = 0; idx < rows; idx++){
		int ti = aOE[aI[idx]][OE_TI];
		
		TR_CloseByTicket(ti);
	}
		
}

void Select(double &a[][], int &aI[], string f){
	/**
		\version	0.0.0.1
		\date		2013.12.13
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.13@artamir	[!]	Добавлен разбор >> и ==
			>Rev:0
	*/

	string fn="Select";
	
	if(BP_SEL){
		Print(fn,"-> AId_eraseFilter()");
	}	
	AId_eraseFilter();
	
	//1. Раскладываем строку f по разделителю " AND "
	string del=" AND ";
	string aAnd[];
	ArrayResize(aAnd,0);
	
	if(BP_SEL){
		Print(fn,"-> StringToArray(aAnd, f, del)");
	}
	StringToArray(aAnd, f, del);
	int and_rows=ArrayRange(aAnd,0);

	for(int i=0;i<and_rows;i++){
		string e=aAnd[i];
		string aE[];
		
		//{		EQ "=="
		ArrayResize(aE,0);
		StringToArray(aE,e,"==");
		int e_rows=ArrayRange(aE,0);
		if(e_rows>1){
			int col=StrToInteger(aE[0]);
			double val=StrToDouble(aE[1]);
			
			AId_FilterAdd_AND(col,val,val,AI_AS_OP_EQ);	
		}
		
		//..	GREAT ">>"
		ArrayResize(aE,0);
		StringToArray(aE,e,">>");
		e_rows=ArrayRange(aE,0);
		if(e_rows>1){
			col=StrToInteger(aE[0]);
			val=StrToDouble(aE[1]);
			
			AId_FilterAdd_AND(col,val,val,AI_AS_OP_GREAT);	
		}	
		//..	LESS "<<"
		ArrayResize(aE,0);
		StringToArray(aE,e,"<<");
		e_rows=ArrayRange(aE,0);
		if(e_rows>1){
			col=StrToInteger(aE[0]);
			val=StrToDouble(aE[1]);
			
			AId_FilterAdd_AND(col,val,val,AI_AS_OP_LESS);	
		}	
		//}
	
	}
	
	//-------------------------------------------
	if(BP_SEL){
		Print(fn,"-> AId_Select2(a,aI)");
	}
	AId_Select2(a,aI);
}

bool isNewBar(){
	/**
		\version	0.0.0.1
		\date		2014.01.13
		\author		Morochin <artamir> Artiom
		\details	Определяет факт открытия нового бара.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.13@artamir	[]	isNewBar
			>Rev:0
	*/

	
	if(Time[0]!=lastBarTime){
		IsNewBar=true;
		lastBarTime=Time[0];
	}else{
		IsNewBar=false;
	}
	
	//return(IsNewBar);
	return(true);
}

int GetSignal(){
	/**
		\version	0.0.0.6
		\date		2014.01.16
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:						
					 @0.0.0.6@2014.01.16@artamir	[*]	Исправлен поиск сигнала индикатора indi.
					 @0.0.0.5@2014.01.15@artamir	[!]	Изменено начало поиска направления торгов по индикатору indiAlert.
					 @0.0.0.4@2014.01.15@artamir	[+]	Добавлен фильтр по indiAlert
					 @0.0.0.3@2014.01.13@artamir	[+]	Добавлен фильтр по Trendsignal
					 @0.0.0.2@2014.01.13@artamir	[!]	Исправлена передача настроек в индикатор StohCross.
					 @0.0.0.1@2013.12.31@artamir	[!]	Добавлен фильтр по HMA
			>Rev:0
	*/
	
	string fn="GetSignal";
	int signal=-1;
	string sy=Symbol();
	int tf=0;
	
	//Print(fn);
	//int tmr=GetTickCount();
	double upArrow=iCustom(NULL,0,"StochCrossingf_e",KPeriod1,DPeriod1,Slowing1,MAMethod1,PriceField1,0,BarsShift);
	double dwArrow=iCustom(NULL,0,"StochCrossingf_e",KPeriod1,DPeriod1,Slowing1,MAMethod1,PriceField1,1,BarsShift);
	
	//Print(fn,".getting indicator data tmr=",(GetTickCount()-tmr)/100," sec.");
	
	if(upArrow>0 && upArrow!=EMPTY_VALUE){signal=OP_BUY; }//Print("up");}
	if(dwArrow>0 && dwArrow!=EMPTY_VALUE){signal=OP_SELL; }//Print("down");}
	
	if(FHMA_use && signal>-1){
		double upHMA=iCustom(NULL,0,"VininIHMA",FHMA_period,FHMA_method,FHMA_price,FHMA_sdvig,FHMA_CheckBar,1,1);
		double dwHMA=iCustom(NULL,0,"VininIHMA",FHMA_period,FHMA_method,FHMA_price,FHMA_sdvig,FHMA_CheckBar,2,1);
		
		if(signal==OP_BUY){
			if(upHMA<=0 || upHMA==EMPTY_VALUE){
				signal=-1;
			}
		}
		
		if(signal==OP_SELL){
			if(dwHMA<=0 || dwHMA==EMPTY_VALUE){
				signal=-1;
			}
		}
	}
	
	if(FTS_use && signal>-1){
		double fts_up=0, fts_dw=0;
		int i=0;
		bool isfind=false;
		while(!isfind){
			fts_up=iCustom(Symbol(),0,"Trendsignal_e",FTS_RISK,FTS_CountBars,FTS_SignalBar,1,i);
			fts_dw=iCustom(Symbol(),0,"Trendsignal_e",FTS_RISK,FTS_CountBars,FTS_SignalBar,0,i);
			
			if(fts_up==EMPTY_VALUE)fts_up=0.0;
			if(fts_dw==EMPTY_VALUE)fts_dw=0.0;
			
			if(fts_up>0 || fts_dw>0){
				isfind=true;
			}
			
			i++;
		}
		
		if(fts_up==0&&fts_dw==0)signal=-1;
		if(fts_up>0&&signal!=OP_BUY)signal=-1;
		if(fts_dw>0&&signal!=OP_SELL)signal=-1;
	}
	
	if(FIA_use && signal>-1){
		double fia_up=0, fia_dw=0;
		i=FIA_SIGNAL_BAR;
		isfind=false;
		while(!isfind && i<Bars){
			fia_up=iCustom(Symbol(),0,"indiAlert_e",FIA_ExtDepth,FIA_ExtDeviation,FIA_ExtBackstep,FIA_SIGNAL_BAR,0,i);
			fia_dw=iCustom(Symbol(),0,"indiAlert_e",FIA_ExtDepth,FIA_ExtDeviation,FIA_ExtBackstep,FIA_SIGNAL_BAR,1,i);
			
			if(fia_up==EMPTY_VALUE)fia_up=0.0;
			if(fia_dw==EMPTY_VALUE)fia_dw=0.0;
			
			if(fia_up>0 || fia_dw>0){
				isfind=true;
			}
			
			i++;
		}
		
		if(fia_up==0&&fia_dw==0)signal=-1;
		if(fia_up>0&&signal!=OP_BUY)signal=-1;
		if(fia_dw>0&&signal!=OP_SELL)signal=-1;
	}
	//--------------------------------------
	return(signal);
}

double GetLot(){
	/**
		\version	0.0.0.1
		\date		2014.01.31
		\author		Morochin <artamir> Artiom
		\details	Расчет объема открываемой позиции. 
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.31@artamir	[+]	GetLot
			>Rev:0
	*/
	string fn="GetLot";
	
	if(!Autolot_use)return(LOT);
	
	double _Free=AccountFreeMargin();
	double _One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
	double _Step=MarketInfo(Symbol(),MODE_LOTSTEP);
	double l =MathFloor(_Free*MaxRisk/100/_One_Lot/_Step)*_Step;
	
	return(l);
}

int Select_SessionTI(int &aI[]){
	/**
		\version	0.0.0.1
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Выборка ордеров с заданным значением сессии.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.08@artamir	[+]	Select_SessionTI
			>Rev:0
	*/

	string fn="Select_SessionTI";
	
	string f="";
	
	f=StringConcatenate(f,
		 OE_MN,"==",TR_MN
		," AND "
		,OE_SID,"==",session_id);
		
	ArrayResize(aI,0);
	AId_Init2(aOE, aI);
	
	//-------------------------------------------
	Select(aOE, aI, f);
	int rows=ArrayRange(aI,0);
	
	return(rows);
}

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ ПО ATR (Average True Range, Средний истинный диапазон)  |
//| Функции передаётся тикет позиции, период АТR и коэффициент, на   |
//| который умножается ATR. Т.о. стоплосс "тянется" на расстоянии    |
//| ATR х N от текущего курса; перенос - на новом баре (т.е. от цены |
//| открытия очередного бара)                                        |
//+------------------------------------------------------------------+
void TrailingByATR(int ticket,int atr_timeframe,int atr1_period,int atr1_shift,int atr2_period,int atr2_shift,double coeff,bool trlinloss)
   {
   // проверяем переданные значения   
   if ((ticket==0) || (atr1_period<1) || (atr2_period<1) || (coeff<=0) || (!OrderSelect(ticket,SELECT_BY_TICKET)) || 
   ((atr_timeframe!=1) && (atr_timeframe!=5) && (atr_timeframe!=15) && (atr_timeframe!=30) && (atr_timeframe!=60) && 
   (atr_timeframe!=240) && (atr_timeframe!=1440) && (atr_timeframe!=10080) && (atr_timeframe!=43200)) || (atr1_shift<0) || (atr2_shift<0))
      {
      Print("Трейлинг функцией TrailingByATR() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      }
   
   double curr_atr1; // текущее значение ATR - 1
   double curr_atr2; // текущее значение ATR - 2
   double best_atr; // большее из значений ATR
   double atrXcoeff; // результат умножения большего из ATR на коэффициент
   double newstop; // новый стоплосс
   
   // текущее значение ATR-1, ATR-2
   curr_atr1 = iATR(Symbol(),atr_timeframe,atr1_period,atr1_shift);
   curr_atr2 = iATR(Symbol(),atr_timeframe,atr2_period,atr2_shift);
   
   // большее из значений
   best_atr = MathMax(curr_atr1,curr_atr2);
   
   // после умножения на коэффициент
   atrXcoeff = best_atr * coeff;
              
   // если длинная позиция (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // откладываем от текущего курса (новый стоплосс)
      newstop = Bid - atrXcoeff;           
      
      // если trlinloss==true (т.е. следует тралить в зоне лоссов), то
      if (trlinloss==true)      
         {
         // если стоплосс неопределен, то тралим в любом случае
         if ((OrderStopLoss()==0) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // иначе тралим только если новый стоп лучше старого
         else
            {
            if ((newstop>OrderStopLoss()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      else
         {
         // если стоплосс неопределен, то тралим, если стоп лучше открытия
         if ((OrderStopLoss()==0) && (newstop>OrderOpenPrice()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // если стоп не равен 0, то меняем его, если он лучше предыдущего и курса открытия
         else
            {
            if ((newstop>OrderStopLoss()) && (newstop>OrderOpenPrice()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }
      
   // если короткая позиция (OP_SELL)
   if (OrderType()==OP_SELL)
      {
      // откладываем от текущего курса (новый стоплосс)
      newstop = Ask + atrXcoeff;
      
      // если trlinloss==true (т.е. следует тралить в зоне лоссов), то
      if (trlinloss==true)      
         {
         // если стоплосс неопределен, то тралим в любом случае
         if ((OrderStopLoss()==0) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // иначе тралим только если новый стоп лучше старого
         else
            {
            if ((newstop<OrderStopLoss()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      else
         {
         // если стоплосс неопределен, то тралим, если стоп лучше открытия
         if ((OrderStopLoss()==0) && (newstop<OrderOpenPrice()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // если стоп не равен 0, то меняем его, если он лучше предыдущего и курса открытия
         else
            {
            if ((newstop<OrderStopLoss()) && (newstop<OrderOpenPrice()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }      
   }
//+------------------------------------------------------------------+

int DrawTable(){
	/**
		\version	0.0.0.0
		\date		2013.08.02
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	int t = OrdersTotal();
	
	ArrayResize(a,0);
	ArrayResize(a, t+1);
	int idx = 1;
	
	for(int i=0; i<=t; i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		a[idx][1] = ArrayRange(a,0);
		a[idx][2] = OrderSymbol();
		a[idx][3] = OrderTicket();
		a[idx][4] = OrderType();
		a[idx][5] = DoubleToStr(OrderProfit(),0);
		a[idx][6] = "IT:"+DoubleToStr(OE_getPropByIndex(OE_FIBT(OrderTicket()), OE_IT),0);
		a[idx][8] = "CP2OP:"+DoubleToStr(OE_getPropByIndex(OE_FIBT(OrderTicket()), OE_CP2OP),0)+">>"+DoubleToStr((TRAL_DeltaPips),0);
		idx++;
	}
	
	OBJTBL_Draw(a,"tbl","@fs10");
	return(0); 
}	