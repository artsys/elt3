	/**
		\version	0.0.0.10
		\date		2013.10.11
		\author		Morochin <artamir> Artiom
		\details	Библиотека работы с MACD. Расширенные параметры. Алгоритм расчета встроен в библиотеку.
		\internal
			ДОПИСАТЬ!!!!
			iMACD_get через индикатор iMACD_sys
			>Hist:									
					 @0.0.0.10@2013.10.11@artamir	[+]	iMACD_getLastCrossBar
			>Rev:0
			>Зависимости:
			#include <sysOther.mqh>
			#include <sysNormalize.mqh>
			#include <sysStructure.mqh>
			#include <sysArray2.mqh>
			#include <iMA.mqh>
	*/

//{   DEFINES	
#define MACD_MODE_AVG		10	//=(Main+Signal)/2 :)
//..  VARS	
string aMACDSets[];
//}

//{ Массив настроек.
void aMACD_Init(){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Очищает стринговый массив.-хранилище настроек.
		\internal
			>Hist:
			>Rev:0
	*/

	ArrayResize(aMACDSets,0);
}

/*

symbol   -   Символьное имя инструмента, на данных которого будет вычисляться индикатор. NULL означает текущий символ. 
timeframe   -   Период. Может быть одним из периодов графика. 0 означает период текущего графика. 
h_fMA   -   хэндл быстрой МА. определяется в коде советника, индикатора или скрипта. 
h_sMA - хэндл медленной МА. определяется в коде советника, индикатора или скрипта.
Signal_per   -   Период усреднения для вычисления сигнальной линии. 
Signal_method   -   Метод усреднения. Может быть любым из значений методов скользящего среднего (Moving Average). 
shift   -   Индекс получаемого значения из индикаторного буфера (сдвиг относительно текущего бара на указанное количество периодов назад). 

*/

int aMACD_set(		int fMA_per	= 12		/** период быстрой ма*/
				,	int	sMA_per	= 26		/** период медленной ма*/
				,	int MACD_me = MODE_EMA	/** метод расчета средней */	
				,	int MACD_pr = PRICE_CLOSE	/** цена по которой  */
				,	int Sig_per	= 6			/** период сигнальной линии	*/
				,	int Sig_me	= MODE_SMA	/** method 		*/
				,	int	tf		= 0			/** timeframe	*/
				,	int shift	= 0			/** shift 		*/
				,	string sy	= ""		/** symbol 		*/){
	/**
		\version	0.0.0.0
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Сохраняет настройку MACD в массив настроек. Возвращает индекс настройки в массиве.
		\internal
			>Hist:			
			>Rev:0
	*/

	int new_row=As_addRow1(aMACDSets);
	
	if(sy == ""){
		sy=Symbol();
	}
	
	string s = "";
	s=s+"@fp"+fMA_per;
	s=s+"@sp"+sMA_per;
	s=s+"@me"+MACD_me;
	s=s+"@pr"+MACD_pr;
	s=s+"@sy"+sy;
	s=s+"@tf"+tf;
	s=s+"@sip"+Sig_per;
	s=s+"@sim"+Sig_me;
	
	s=s+"@sh"+shift;
	
	aMACDSets[new_row]=s;
	return(new_row);
}

//}

double iMACD_get(int handle=0, int line=MODE_MAIN, int shift=-1, int dgt=2, bool useSinhro = true /** использовать синхронизацию таймфреймов. */){
	/**
		\version	0.0.0.0
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение заданной линии MACD по заданному индексу в массиве настроек и индексу бара.
					Синхронизация смещения происходит по времени бара с заданным индексом на текущем фрейме.
		\internal
			>Hist:					
			>Rev:0
	*/

	string fn="iMACD_get";
	
	int 	fMA_per	= Struc_KeyValue_int	(aMACDSets[handle]	, "@fp");
	int 	sMA_per	= Struc_KeyValue_int	(aMACDSets[handle]	, "@sp");
	int		MACD_me = Struc_KeyValue_int	(aMACDSets[handle]	, "@me");
	int		MACD_pr = Struc_KeyValue_int	(aMACDSets[handle]	, "@pr");
	string 	sy 		= Struc_KeyValue_string	(aMACDSets[handle]	, "@sy");
	int 	tf 		= Struc_KeyValue_int	(aMACDSets[handle]	, "@tf");
	int 	sig_per	= Struc_KeyValue_int	(aMACDSets[handle]	, "@sip");
	int 	sig_me	= Struc_KeyValue_int	(aMACDSets[handle]	, "@sim");
	int 	sh 		= shift;
	if(sh<=-1){
		sh 			= Struc_KeyValue_int	(aMACDSets[handle]	, "@sh");
	}
	
	
	if(useSinhro){
		if(tf != Period()){
			sh = iBarShift(sy, tf, iTime(sy, 0, sh));
		}
	}
	
	
	double	res=0;
	double	macd=iCustom(sy,tf,"iMACD_sys",0,sh);
	double	sig =iCustom(sy,tf,"iMACD_sys",1,sh);
			if(line==MODE_MAIN){res=macd;}
			if(line==MODE_SIGNAL){res=sig;}
			if(line==MACD_MODE_AVG){res=(macd+sig)/2;}
			res=Norm_symb(res, "", dgt); 
	return(res);
}

double iMACD_getMain(int h=0, int shift=-1){
	/**
		\version	0.0.0.0
		\date		2013.10.08
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение главной линии на заданном баре.
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="iMACD_getMain";
	double macd=iMACD_get(h,MODE_MAIN,shift);
	
	return(macd);
}

double iMACD_getSignal(int h=0, int shift=-1){
	/**
		\version	0.0.0.0
		\date		2013.10.08
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение главной линии на заданном баре.
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="iMACD_getSignal";
	double macd=iMACD_get(h,MODE_SIGNAL,shift);
	
	return(macd);
}


int iMACD_getArray(int h, double &a[], int l=MODE_MAIN, int shift = -1, double def=-1/** если > -1, то заполняет массив переданным значением*/){
	/**
		\version	0.0.0.1
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	Возвращает массив линии индикатора из 3-х элементов.
		\internal
			>Hist:	
					 @0.0.0.1@2013.07.17@artamir	[]	iMACD_getArray
			>Rev:0
	*/
	string fn="iMACD_getArray";
	ArrayResize(a,0);	//Очистили массив.
	int ht;
	for(int i = shift-1; i<= shift+1; i++){
		int idx=Ad_addRow1(a);
		if(def==-1){
			a[idx]=iMACD_get(h, l, i);
		}else{
			a[idx]=def;
		}	
	}
	
	return(ArrayRange(a,0));
}

//{ === Работа с пересечением линий.
int iMACD_CrossMainSignal(int h, int shift = 1){
	/**
		\version	0.0.0.1
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	Проверяет, если на баре с заданным индексом было пересечение главной и сигнальной линий
		\internal
			>Hist:	
					 @0.0.0.1@2013.07.17@artamir	[]	iSth_CrossMainSignal
			>Rev:0
	*/

	double f[];
	double s[];
	
	int ROWS_f = iMACD_getArray(h, f, MODE_MAIN,   shift);
	int ROWS_s = iMACD_getArray(h, s, MODE_SIGNAL, shift);
	return(Ad_CrossByIdx(f,s,1));
}

int iMACD_CrossMainLevel(int h, double l=0.001 /** exemple 80*/, int shift=1){
	/**
		\version	0.0.0.0
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	Пересечение основной линии с заданным уровнем
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="iMACD_CrossMainLevel";
	
	double f[];
	double s[];
	
	int ROWS_f = iMACD_getArray(h, f, MODE_MAIN,   shift);
	
	int ROWS_s = iMACD_getArray(h, s, 0, 0, l);
	
	return(Ad_CrossByIdx(f,s,1));
	
}

int iMACD_getLastCrossBar(int h, int fast_line=MODE_MAIN, int slow_line=MODE_SIGNAL, int shift=1, double h_level=-1.00){
	/**
		\version	0.0.0.1
		\date		2013.10.11
		\author		Morochin <artamir> Artiom
		\details	Находит ближайшее к текущему смещению графика пересечение.
					Линии, для которых производится поиск пересечений задаются 
					следующими переменными:
					fast_line-индекс быстрой линии (MODE_MAIN|MODE_SIGNAL|MACD_MODE_AVG)
					slow_line-индекс медленной линии(см. выше) или -1.
					Если slow_line=-1 тогда будет использоваться горизонтальный уровень, 
					заданный переменной h_levek
		\internal
			>Hist:	
					 @0.0.0.1@2013.10.11@artamir	[]	iMACD_getLastCrossBar
			>Rev:0
	*/

}
//}

//{ === Работа с положением
#define MACD_UNDER	0
#define MACD_ABOVE	1
#define MACD_EQ		2

int iMACD_LineAndLevel(int h, int ln=MODE_MAIN, double lv=0.00, int shift=1){
	/**
		\version	0.0.0.0
		\date		2013.10.08
		\author		Morochin <artamir> Artiom
		\details	Возвращает взаимное расположение линии и уровня.
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="iMACD_isMainUnderLevel";
	double macd=iMACD_get(h,ln,shift);
	
	if(macd<lv){return(MACD_UNDER);}
	if(macd>lv){return(MACD_ABOVE);}
	return(MACD_EQ);
}

bool iMACD_isLineUnderLevel(int h, int ln=MODE_MAIN, double lv=0.00, int sh=1){
	/**
		\version	0.0.0.0
		\date		2013.10.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	
	if(iMACD_LineAndLevel(h,ln,lv,sh)==MACD_UNDER){return(true);}
	return(false);
}

bool iMACD_isLineAboveLevel(int h, int ln=MODE_MAIN, double lv=0.00, int sh=1){
	/**
		\version	0.0.0.0
		\date		2013.10.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	
	if(iMACD_LineAndLevel(h,ln,lv,sh)==MACD_ABOVE){return(true);}
	return(false);
}

//}