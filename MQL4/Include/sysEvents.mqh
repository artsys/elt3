	/**
		\version	3.1.0.6
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	События ордеров. Для работы библиотеки требуется библиотека sysOE.mqh
		\internal
			>Hist:						
					 @3.1.0.6@2014.03.06@artamir	[!]	EVENT_Closed
					 @3.1.0.5@2014.03.03@artamir	[]	E_End
					 @3.1.0.4@2014.03.03@artamir	[+]	E_End
					 @3.1.0.3@2014.03.03@artamir	[+]	E_Events
					 @3.1.0.2@2014.03.03@artamir	[+]	E_Start
					 @3.1.0.1@2014.03.03@artamir	[+]	aE_Init
			>Rev:0
	*/

double 	aEC[][OE_MAX];
double	aEO[][OE_MAX];

#define E_TI	0
#define E_EVT	1
#define	E_MAX	2

#define EVT_NEW	0
#define EVT_CHTY	1
#define EVT_CLS	2
double	aE[][E_MAX];

void E_Init(void){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Инициализация массивов.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	
			>Rev:0
	*/
	ArrayResize(aEC,0);
	ArrayResize(aEO,0);
	ArrayResize(aE,0);
}

void E_Start(void){
	/**
		\version	0.0.0.2
		\date		2014.07.07
		\author		Morochin <artamir> Artiom
		\details	По идее должна вызываться в начале каждого цикла работы советника. (ф-ция старт)
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	E_Start
			>Rev:0
	*/
	DAIdPRINTALL(aOE,"__________");
	string fn="aE_Start";
	
	ArrayResize(aEC,0);	//Обнулили массив текущих ордеров, которые есть в терминале.
	ArrayResize(aE,0);	//Обнулили массив событий
	for(int i=0;i<=OrdersTotal();i++){
		if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
		if(OrderSymbol() != Symbol()) continue;
		
		DAIdPRINTALL3(aOE,"before setSTD aOE.ti="+OrderTicket())   
		
		int idx=OE_FIBT(OrderTicket());
		
		DAIdPRINTALL3(aOE,"after setSTD aOE.ti="+OrderTicket())
		
		if(idx>-1){
			AId_CopyRow2(aOE,aEC,idx);
		}
		
		DAIdPRINTALL3(aOE,"after CopyROW aOE.ti="+OrderTicket());
		
	}
	
	E_Events();
	E_End();
}

void E_End(){
	/**
		\version	0.0.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Копирование текущих ордеров в массив aEO
		\internal
			>Hist:		
					 @0.0.0.2@2014.03.03@artamir	[*]	Исправлено копирование массива текущих ордеров.
					 @0.0.0.1@2014.03.03@artamir	[+]	E_End
			>Rev:0
	*/
	
	//int aIC[];AId_Init2(aEC,aIC);
	//AId_Print2(aEC,aIC,4,"aEC_all");
	//int aIO[];AId_Init2(aEO,aIO);
	//AId_Print2(aEO,aIO,4,"aEO_all");
	
	
	string fn="E_End";
	ArrayResize(aEO,ArrayRange(aEC,0));
	if(ArrayRange(aEC,0)>0){
		ArrayCopy(aEO,aEC,0,0,WHOLE_ARRAY);
	}
}

void E_Events(void){

	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	E_Events
			>Rev:0
	*/
	string fn="E_Events";
	
	int aIC[]; 			int aIO[];
	ArrayResize(aIC,0);	ArrayResize(aIO,0);
	AId_Init2(aEC,aIC); AId_Init2(aEO,aIO);
	
	for(int ic=0;ic<ArrayRange(aIC,0);ic++){
		int cti=(int)AId_Get2(aEC,aIC,ic,OE_TI);
		int io=AId_SearchFirst2(aEO, aIO, OE_TI, cti);
		
		if(io==AI_NONE){
			EVENT_New(cti);
			continue;
		}
	
		//Изменился тип ордера.
		int cty=(int)AId_Get2(aEC,aIC,ic,OE_TY);
		int oty=(int)AId_Get2(aEO,aIO,io,OE_TY);
		if(cty!=oty){
			EVENT_ChTY(cti);
		}
	}
	
	for(int io=0; io<ArrayRange(aIO,0);io++){
		int oti=(int)AId_Get2(aEO,aIO,io,OE_TI);
		int ic=(int)AId_SearchFirst2(aEC, aIC, OE_TI, oti);
		
		if(ic==AI_NONE){
			//Print(fn,"->EVENT_Closed()");
			EVENT_Closed(oti);
		}
	}
	
}

//События
void EVENT_New(int ti){
	/**
		\version	0.0.0.0
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Событие - открытие новой позиции/ордера.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="EVENT_New";
	int idx=AId_AddRow2(aE);
	aE[idx][E_TI]=ti;
	aE[idx][E_EVT]=EVT_NEW;
}

void EVENT_ChTY(int ti){
	/**
		\version	0.0.0.0
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Событие - изменение типа позиции/ордера.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="EVENT_New";
	int idx=AId_AddRow2(aE);
	aE[idx][E_TI]=ti;
	aE[idx][E_EVT]=EVT_CHTY;
}

void EVENT_Closed(int ti){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Событие - закрытие/удаление позиции/ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[!]	EVENT_Closed
			>Rev:0
	*/
	string fn="EVENT_Closed";
	int idx=AId_AddRow2(aE);
	aE[idx][E_TI]=ti;
	aE[idx][E_EVT]=EVT_CLS;
	//Print(fn,"->OE_setCLS()");
	OE_setCLS(ti);
}