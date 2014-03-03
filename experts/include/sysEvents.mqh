	/**
		\version	3.1.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	События ордеров. Для работы библиотеки требуется библиотека sysOE.mqh
		\internal
			>Hist:		
					 @3.1.0.2@2014.03.03@artamir	[+]	E_Start
					 @3.1.0.1@2014.03.03@artamir	[+]	aE_Init
			>Rev:0
	*/

double 	aEC[][OE_MAX];
double	aEO[][OE_MAX];

#define E_TI	0
#define E_EVT	1
#define	E_MAX	2
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
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	По идее должна вызываться в начале каждого цикла работы советника. (ф-ция старт)
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	E_Start
			>Rev:0
	*/
	string fn="aE_Start";
	
	ArrayResize(aEC,0);	//Обнулили массив текущих ордеров, которые есть в терминале.
	
	for(int i=0;i<=OrdersTotal();i++){
		if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
		int idx=OE_setSTD(OrderTicket());
		if(idx>-1){
			AId_CopyRow2(aOE,aEC,idx);
		}
	}
}

void E_Events(void){
	/**
		\version	0.0.0.0
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="E_Events";
	
	
}