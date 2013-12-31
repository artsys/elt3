	/**
		\version	1.0.0.11
		\date		2013.12.30
		\author		Morochin <artamir> Artiom
		\details	Советник работает по индикатору NikPSAR2B
		\internal
			>Hist:								
					 @1.0.0.11@2013.12.30@artamir	[]	Tral_Fr
					 @1.0.0.10@2013.12.27@artamir	[+]	добавлена возможность альтернативного определения фракталов.
					 @1.0.0.7@2013.12.27@artamir	[!]	Tral_Fr
					 @1.0.0.6@2013.12.23@artamir	[]	
					 @1.0.0.4@2013.12.18@artamir	[+] Добавлен трейлинг, добавлено смещение на заданное количество баров для открытия ордера по рынку.
					 @1.0.0.3@2013.12.13@artamir	[+]	Select
					 @1.0.0.2@2013.12.13@artamir	[+]	Tral
					 @0.0.0.1@2013.12.13@artamir	[+]	Autoopen
			>Rev:0
	*/
	
bool IsNewBar=false;
datetime lastBarTime=0;

int hfr=-1;

#define EXP	"eVVSS"	
#define VER	"1.0.0.11_2013.12.30"

extern	string	s1="==== MAIN ====="; //{
extern	int SL=50;
extern	int TP=50;
extern	double LOT=0.01;

//-----
extern bool       AlertsEnabled  = true;
extern bool       TF4            = true;
extern bool       TF3            = true;
extern bool       TF2            = true;
//-----
extern double     Step           = 0.04;
extern double     Maximum        = 0.5;
//-----
extern int	BarsShift=1;


extern bool		TRAL_Use=false;
int			TRAL_Begin_pip=0;
extern int			TRAL_DeltaPips=10;
extern int			TRAL_Step_pip=5;

extern bool		TRAL_Fr_Use=false;
extern int		TRAL_Fr_TF=0;	//таймфрейм расчета фракталов.
extern int		TRAL_Fr_R=2;	//количество баров справа для определения фрактала
extern int		TRAL_Fr_L=2;	//количество баров слева для определения фрактала

extern	string	e1="==== EXPERT END =====";//}

#include <sysELT3.mqh>
#include <sysObjects2.mqh>	
#include <iFractal.mqh>

string a[][9];
int htable = -1;

int init(){
	/**
		\version	0.0.0.1
		\date		2013.12.27
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.27@artamir	[*]	init
			>Rev:0
	*/

	ArrayResize(a, 0);
	ArrayResize(a,2);
	Print("init");
	int tmr=GetTickCount();
	double i=iCustom(NULL,0,"NikPSAR2B",AlertsEnabled,TF4,TF3,TF2,Step,Maximum,4,BarsShift);
	Print("tmr=",(GetTickCount()-tmr)/100," sec.");
	
	aFR_init();
	hfr=aFR_set(TRAL_Fr_L,TRAL_Fr_R,TRAL_Fr_TF);
	
	return(0);
}

int deinit(){
	ELT_deinit();

	return(0);
}

int start(){
	/**
		\version	0.0.0.0
		\date		2013.12.06
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

	ELT_start();
	if(OrdersTotal()>0){
		//DrawTable();
		//A_d_PrintArray2(aOE,4,"OE");
	}
	OE_eraseArray();
	int ret = startext();
	
	//-------------------------------------------
	return(ret);
}

int startext(){
	/**
		\version	0.0.0.0
		\date		2013.12.06
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	Tral();
	Tral_Fr();
	Autoopen();
	//-------------------------------------------
	return(0);
}

void Autoopen(){
	/**
		\version	0.0.0.1
		\date		2013.12.13
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.13@artamir	[+]	Добавлен выбор объема ордера.
			>Rev:0
	*/
	int op=GetSignal();
	
	//-------------------------------------------
	if(op<0) return;
	
	string f=OE_IT+"==1 AND "+OE_IM+"==1 AND "+OE_FOTY+"=="+op+" AND "+OE_FOOT+"=="+Time[BarsShift];
	int aI[];
	AId_Init2(aOE, aI);
		
	//-------------------------------------------
	Select(aOE, aI, f);
	if(ArrayRange(aI,0)>0) return; //есть ордера, открытые по этому сигналу на тек. баре. 
	
	int ti=-1;
	if(isNewBar()){ 
		ti=TR_SendMarket(op, LOT);
	}	
	
	if(ti<=0){
		Print("Cant send order");
		return;
	}
	
	TR_ModifyTP(ti,TP,TR_MODE_PIP);
	TR_ModifySL(ti,SL,TR_MODE_PIP);
	OE_setFODByTicket(ti);
	OE_setFOOTByTicket(ti, Time[BarsShift]);
}

void Tral(){
	/**
		\version	0.0.0.1
		\date		2013.12.13
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:						
					 @0.0.0.1@2013.12.13@artamir	[+]	Tral
			>Rev:0
	*/

	string fn="Tral";
	if(!TRAL_Use){return;}
	
	double d[][OE_MAX];
	
	string	f="";
			
	//{ --- Если СЛ > 0
		f=OE_IT+"==1 AND "+OE_MN+"=="+TR_MN+" AND "+OE_CP2SL+">>"+(TRAL_Begin_pip+TRAL_DeltaPips)+" AND "+OE_CP2OP+">>"+TRAL_DeltaPips;
		
		int aI[];
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		Select(aOE, aI, f);
		int rows=ArrayRange(aI,0);
		if(rows>0){ 
			AId_SetIndexOnArray(aOE,aI,d);
		}
		
		
		for(int idx = 0; idx < rows; idx++){
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
		\version	0.0.0.3
		\date		2013.12.30
		\author		Morochin <artamir> Artiom
		\details	Трал по фракталам
		\internal
			>Hist:								
					 @0.0.0.3@2013.12.30@artamir	[!]	Исправлен трал селловых ордеров.
					 @0.0.0.2@2013.12.27@artamir	[]	Tral_Fr
					 @0.0.0.1@2013.12.13@artamir	[+]	Tral
			>Rev:0
	*/

	string fn="Tral_Fr";
	if(!TRAL_Fr_Use){return;}
	
	double d[][OE_MAX];
	
	double fUp=iHigh(Symbol(), TRAL_Fr_TF, iFR_getNearestUpBarTF(hfr,1));
	double fDw=iLow(Symbol(), TRAL_Fr_TF, iFR_getNearestDwBarTF(hfr,1));
	
	string	f="";
			
	//{ --- Тралим баи
		f=StringConcatenate(	OE_IT,"==1"
							,	" AND "
							,	OE_MN,"==",TR_MN
							,	" AND "
							,	OE_TY,"==",OP_BUY);
		
		int aI[];
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		Select(aOE, aI, f);
		int rows=ArrayRange(aI,0);
		if(rows>0){ 
			AId_SetIndexOnArray(aOE,aI,d);
		}
		
		
		for(int idx = 0; idx < rows; idx++){
			int ti = d[idx][OE_TI];
			TR_ModifySL(ti, fDw);
		}
	//}
	
	f="";
	//{ --- Тралим баи
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
		if(rows>0){ 
			AId_SetIndexOnArray(aOE,aI,d);
		}
		
		
		for(idx = 0; idx < rows; idx++){
			ti = d[idx][OE_TI];
			TR_ModifySL(ti, fUp);
		}
	//}
	
	ArrayResize(d,0);
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

	AId_eraseFilter();
	
	//1. Раскладываем строку f по разделителю " AND "
	string del=" AND ";
	string aAnd[];
	ArrayResize(aAnd,0);
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
		//}
	
	}
	
	//-------------------------------------------
	AId_Select2(a,aI);
}

bool isNewBar(){
	if(Time[0]!=lastBarTime){
		IsNewBar=true;
		lastBarTime=Time[0];
	}else{
		IsNewBar=false;
	}
	
	return(IsNewBar);
}

int GetSignal(){
	/**
		\version	0.0.0.0
		\date		2013.12.06
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	
	string fn="GetSignal";
	int signal=-1;
	string sy=Symbol();
	int tf=0;
	
	//Print(fn);
	//int tmr=GetTickCount();
	double upArrow=iCustom(sy,tf,"NikPSAR2B",AlertsEnabled,TF4,TF3,TF2,Step,Maximum,4,BarsShift);
	double dwArrow=iCustom(sy,tf,"NikPSAR2B",AlertsEnabled,TF4,TF3,TF2,Step,Maximum,5,BarsShift);
	
	//Print(fn,".getting indicator data tmr=",(GetTickCount()-tmr)/100," sec.");
	
	if(upArrow>0 && upArrow!=EMPTY_VALUE){signal=OP_BUY; Print("up");}
	if(dwArrow>0 && dwArrow!=EMPTY_VALUE){signal=OP_SELL; Print("down");}
	
	
	//--------------------------------------
	return(signal);
}

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
		a[idx][7] = "CP2SL:"+DoubleToStr(OE_getPropByIndex(OE_FIBT(OrderTicket()), OE_CP2SL),0)+">>"+DoubleToStr((TRAL_Begin_pip+TRAL_DeltaPips),0);
		a[idx][8] = "CP2OP:"+DoubleToStr(OE_getPropByIndex(OE_FIBT(OrderTicket()), OE_CP2OP),0)+">>"+DoubleToStr((TRAL_DeltaPips),0);
		idx++;
	}
	
	OBJTBL_Draw(a,"tbl","@fs10");
	return(0); 
}	