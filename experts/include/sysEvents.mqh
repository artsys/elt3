	/**
		\version	3.1.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	События ордеров. Для работы библиотеки требуется библиотека sysOE.mqh
		\internal
			>Hist:	
					 @3.1.0.1@2014.03.03@artamir	[+]	
			>Rev:0
	*/

double 	aEC[][OE_MAX];
double	aEO[][OE_MAX];

aE_Init(){
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
}