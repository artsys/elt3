	/**
		\version	1.0.0.28
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Советник работает по индикатору StohCross
		\internal
			$Revision: 275 $
			>Hist:																								
					 @1.0.0.28@2014.01.08@artamir	[]	start
					 @1.0.0.27@2014.01.08@artamir	[+]	Select_SessionTI
					 @1.0.0.26@2014.01.08@artamir	[+]	Добавлен трал по АТР
					 @1.0.0.25@2014.01.06@artamir	[]	Tral_Fr
					 @1.0.0.24@2014.01.06@artamir	[!]	Tral_Fr
					 @1.0.0.23@2014.01.06@artamir	[+] Добавлена настройка открытия реверсного ордера.	
					 @1.0.0.22@2014.01.06@artamir	[]	Tral
					 @1.0.0.21@2014.01.06@artamir	[*] Исправлен IndexedArray	
					 @1.0.0.20@2013.12.31@artamir	[+]	GetSignal
					 @1.0.0.19@2013.12.31@artamir	[*]	Autoopen
					 @1.0.0.18@2013.12.31@artamir	[!!]	Tral
					 @1.0.0.17@2013.12.30@artamir	[!!]	Tral_Fr
					 @1.0.0.16@2013.12.30@artamir	[!]	Tral_Fr
					 @1.0.0.15@2013.12.30@artamir	[*]	start
					 @1.0.0.14@2013.12.30@artamir	[]	Autoclose
					 @1.0.0.13@2013.12.30@artamir	[+]	Autoclose
					 @1.0.0.12@2013.12.30@artamir	[-] Оставлен только трейлинг стоп по фракталам.	
					 @1.0.0.11@2013.12.30@artamir	[]	
					 @1.0.0.10@2013.12.27@artamir	[+]	добавлена возможность альтернативного определения фракталов.
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

int session_id=0;

#define EXP	"eVVSS_StohCross"	
#define VER	"1.0.0.28_2014.01.08"

extern	string	s1="==== MAIN ====="; //{
extern	int SL=50;
extern	int TP=50;
extern	double LOT=0.01;

extern int       KPeriod1     =  8;
extern int       DPeriod1     =  3;
extern int       Slowing1     =  3;
extern int       MAMethod1    =   0;
extern int       PriceField1  =   1;
extern bool		CloseOnRevers=false;
extern int	BarsShift=1;
extern string s2="=== FILTER VininIHMA ===";
//---- input parameters
extern bool FHMA_use=false; 
extern int FHMA_period=16; 
extern int FHMA_method=3; // MODE_SMA 
extern int FHMA_price=0; // PRICE_CLOSE 
extern int FHMA_sdvig=0;
extern int FHMA_CheckBar=1; 
extern string e2="========================";

//-----

extern bool		TRAL_Use=false;
int			TRAL_Begin_pip=0;
extern int			TRAL_DeltaPips=10;
extern int			TRAL_Step_pip=5;

extern bool		TRAL_Fr_Use=false;
extern int		TRAL_Fr_TF=0;	//таймфрейм расчета фракталов.
extern int		TRAL_Fr_R=2;	//количество баров справа для определения фрактала
extern int		TRAL_Fr_L=2;	//количество баров слева для определения фрактала

extern bool		TRAL_ATR_use=false;
extern int		TRAL_ATR_TF=0;
extern int		TRAL_ATR1_Per=5;
extern int		TRAL_ATR2_Per=20;
extern double	TRAL_ATR_COEF=1;
extern bool		TRAL_ATR_INLOSS=false;

extern bool		use_Revers=false;
extern	string	e1="==== EXPERT END =====";//}

#include <sysELT3.mqh>
#include <sysObjects2.mqh>	
#include <iFractal.mqh>

string a[][9];
int htable = -1;

int init(){
	/**
		\version	0.0.0.2
		\date		2013.12.30
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.12.30@artamir	[]	init
					 @0.0.0.1@2013.12.27@artamir	[*]	init
			>Rev:0
	*/

	ArrayResize(a, 0);
	ArrayResize(a,2);
	Print("init");
	int tmr=GetTickCount();
	double i=iCustom(NULL,0,"StochCrossingf_e",KPeriod1,DPeriod1,Slowing1,PriceField1,0,BarsShift);
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
		\version	0.0.0.2
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2014.01.08@artamir	[!]	start
					 @0.0.0.1@2013.12.30@artamir	[+]	Добавлена проверка статусов ордеров бд.
			>Rev:0
	*/
	string fn="start";
	ELT_start();
	if(OrdersTotal()>0){
		//DrawTable();
		//A_d_PrintArray2(aOE,4,"OE");
	}
	
	
	OE_delClosed();
	
	OE_eraseArray();
	
	OE_RecheckStatuses();
	
	if(OrdersTotal() <=0){
		session_id++;
	}
	
	int ret = startext();
	
	//-------------------------------------------
	return(ret);
}

int startext(){
	/**
		\version	0.0.0.1
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.08@artamir	[]	startext
			>Rev:0
	*/
	
	string fn="startext";
	
	if(Autoclose()){
		return(0);
	}
	
	Tral();
	Tral_Fr();
	Tral_ATR();
	
	Autoopen();
	//-------------------------------------------
	return(0);
}

void Autoopen(){
	/**
		\version	0.0.0.2
		\date		2013.12.31
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.12.31@artamir	[*]	Исправлена проверка , что ордер выставлен на текущем баре.
					 @0.0.0.1@2013.12.13@artamir	[+]	Добавлен выбор объема ордера.
			>Rev:0
	*/
	
	string fn="Autoopen";
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
	ArrayResize(aI,0);
	AId_Init2(aOE, aI);
		
	//-------------------------------------------
	Select(aOE, aI, f);
	if(ArrayRange(aI,0)>0) return; //есть ордера, открытые по этому сигналу на тек. баре. 
	
	int ti=-1;
	if(isNewBar()){ 
		ti=TR_SendMarket(op, LOT);
		
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
	}
}

bool Autoclose(){
	/**
		\version	0.0.0.1
		\date		2013.12.30
		\author		Morochin <artamir> Artiom
		\details	Автозакрытие ордеров.
		\internal
			>Hist:	
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
		\version	0.0.0.4
		\date		2014.01.06
		\author		Morochin <artamir> Artiom
		\details	Трал по фракталам
		\internal
			>Hist:									
					 @0.0.0.4@2014.01.06@artamir	[!]	Tral_Fr
					 @0.0.0.3@2013.12.30@artamir	[!!]	Tral_Fr
					 @0.0.0.2@2013.12.30@artamir	[!]	Исправлен трал селл ордеров.
					 @0.0.0.1@2013.12.13@artamir	[+]	Tral
			>Rev:0
	*/

	string fn="Tral_Fr";
	if(!TRAL_Fr_Use){return;}
	
	double d[][OE_MAX];
	
	int bUP=iHighest(Symbol(), TRAL_Fr_TF, MODE_HIGH, iFR_getNearestUpBarTF(hfr,1),0);
	int bDW=iLowest(Symbol(), TRAL_Fr_TF, MODE_LOW, iFR_getNearestDwBarTF(hfr,1),0);
	
	double fUp=iHigh(Symbol(), TRAL_Fr_TF, bUP);
	double fDw=iLow(Symbol(), TRAL_Fr_TF, bDW);
	
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
			
			if(use_Revers)
				TR_ModifyTP(ti, fUp);
			else	
				TR_ModifySL(ti, fDw);
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
			
			if(use_Revers)
				TR_ModifyTP(ti, fDw);
			else
				TR_ModifySL(ti, fUp);
		}
	//}
	
	ArrayResize(d,0);
}	

void Tral_ATR(){
	/**
		\version	0.0.0.0
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
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
		\version	0.0.0.1
		\date		2013.12.31
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.31@artamir	[!]	Добавлен фильтр по HMA
			>Rev:0
	*/
	
	string fn="GetSignal";
	int signal=-1;
	string sy=Symbol();
	int tf=0;
	
	//Print(fn);
	//int tmr=GetTickCount();
	double upArrow=iCustom(NULL,0,"StochCrossingf_e",KPeriod1,DPeriod1,Slowing1,PriceField1,0,BarsShift);
	double dwArrow=iCustom(NULL,0,"StochCrossingf_e",KPeriod1,DPeriod1,Slowing1,PriceField1,1,BarsShift);
	
	//Print(fn,".getting indicator data tmr=",(GetTickCount()-tmr)/100," sec.");
	
	if(upArrow>0 && upArrow!=EMPTY_VALUE){signal=OP_BUY; }//Print("up");}
	if(dwArrow>0 && dwArrow!=EMPTY_VALUE){signal=OP_SELL; }//Print("down");}
	
	if(FHMA_use){
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
	//--------------------------------------
	return(signal);
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
		a[idx][7] = "CP2SL:"+DoubleToStr(OE_getPropByIndex(OE_FIBT(OrderTicket()), OE_CP2SL),0)+">>"+DoubleToStr((TRAL_Begin_pip+TRAL_DeltaPips),0);
		a[idx][8] = "CP2OP:"+DoubleToStr(OE_getPropByIndex(OE_FIBT(OrderTicket()), OE_CP2OP),0)+">>"+DoubleToStr((TRAL_DeltaPips),0);
		idx++;
	}
	
	OBJTBL_Draw(a,"tbl","@fs10");
	return(0); 
}	