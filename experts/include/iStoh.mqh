	/**
		\version	0.0.0.9
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:								
					 @0.0.0.9@2013.07.25@artamir	[]	iSth_Cross
					 @0.0.0.8@2013.07.25@artamir	[]	iSth_get
					 @0.0.0.7@2013.07.25@artamir	[]	iSth_get
					 @0.0.0.6@2013.07.25@artamir	[]	iSth_get+ST_MODE_AVG
					 @0.0.0.5@2013.07.25@artamir	[]	aSth_set
					 @0.0.0.4@2013.07.17@artamir	[]	iSth_getArray
					 @0.0.0.3@2013.07.17@artamir	[]	iSth_CrossMainSignal
					 @0.0.0.2@2013.07.17@artamir	[]	iSth_Cross
			>Rev:0
			>Зависимости:
			#include <sysOther.mqh>
			#include <sysNormalize.mqh>
			#include <sysStructure.mqh>
	*/

#define ST_MODE_AVG		10	//=(Main+Signal)/2 :)
	
string aStSets[];

void aSth_Init(){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Очищает стринговый массив. Использовать при каждом запуске ф-ции старт
		\internal
			>Hist:
			>Rev:0
	*/

	ArrayResize(aStSets,0);
}

/*

symbol   -   Символьное имя инструмента, на данных которого будет вычисляться индикатор. NULL означает текущий символ. 
timeframe   -   Период. Может быть одним из периодов графика. 0 означает период текущего графика. 
%Kperiod   -   Период(количество баров) для вычисления линии %K. 
%Dperiod   -   Период усреднения для вычисления линии %D. 
slowing   -   Значение замедления. 
method   -   Метод усреднения. Может быть любым из значений методов скользящего среднего (Moving Average). 
price_field   -   Параметр выбора цен для расчета. Может быть одной из следующих величин: 0 - Low/High или 1 - Close/Close. 
mode   -   Индекс линии индикатора. Может быть любым из значений идентификаторов линий индикаторов. 
shift   -   Индекс получаемого значения из индикаторного буфера (сдвиг относительно текущего бара на указанное количество периодов назад). 

*/

int aSth_set(		int k		= 5			/** %Kperiod 	*/
				, 	int d		= 3			/** %Dperiod 	*/
				,	int sl		= 3			/** slowing 	*/
				,	int me		= MODE_SMA	/** method 		*/
				,	int pr		= 0			/** price_field */
				,	string sy	= ""		/** symbol 		*/
				,	int	tf		= 0			/** timeframe	*/
				,	int shift	= 0			/** shift 		*/){
	/**
		\version	0.0.0.3
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Сохраняет настройку стохастика в массив настроек. Возвращает индекс настройки в массиве.
		\internal
			>Hist:			
					 @0.0.0.3@2013.07.25@artamir	[+]	добавлена настройка таймфрейма
			>Rev:0
	*/

	int ROWS = ArrayRange(aStSets,0);
	ROWS++;
	int lastROW=ROWS-1;
	ArrayResize(aStSets, ROWS);
	
	if(sy == ""){
		sy=Symbol();
	}
	
	string s = "";
	s=s+"@k"+k;
	s=s+"@d"+d;
	s=s+"@sl"+sl;
	s=s+"@pr"+pr;
	s=s+"@me"+me;
	s=s+"@sy"+sy;
	s=s+"@tf"+tf;
	s=s+"@sh"+shift;
	
	aStSets[lastROW]=s;
	return(lastROW);
}

double iSth_get(int handle=0, int line=MODE_MAIN, int shift=-1, int dgt=0, bool useSinhro = true /** использовать синхронизацию таймфреймов. */){
	/**
		\version	0.0.0.5
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Возвращает цену заданной линии стохастика по заданному индексу в массиве настроек и индексу бара.
					Синхронизация смещения происходит по времени бара с заданным индексом на текущем фрейме.
		\internal
			>Hist:					
					 @0.0.0.5@2013.07.25@artamir	[*]	синхронизация с тф отличными от текущуго. 
					 @0.0.0.4@2013.07.25@artamir	[*]	Изменения связанные с ST_MODE_AVG	
					 @0.0.0.3@2013.07.25@artamir	[*]	Добавлено получение tf.
			>Rev:0
	*/

	int 	k	= Struc_KeyValue_int(aStSets[handle]	, "@k");
	int 	d	= Struc_KeyValue_int(aStSets[handle]	, "@d");
	int 	sl	= Struc_KeyValue_int(aStSets[handle]	, "@sl");
	double 	pr 	= Struc_KeyValue_double(aStSets[handle]	, "@pr");
	int 	me	= Struc_KeyValue_int(aStSets[handle]	, "@me");
	string 	sy 	= Struc_KeyValue_string(aStSets[handle]	, "@sy");
	int 	tf 	= Struc_KeyValue_int(aStSets[handle]	, "@tf");
	
	int sh 		= shift;
	if(sh<=-1){
		sh = Struc_KeyValue_int(aStSets[handle], "@sh");
	}
	
	
	if(useSinhro){
		if(tf != Period()){
			sh = iBarShift(sy, tf, iTime(sy, 0, sh));
		}
	}
	
	double stoh = 0.0;
	if(line == ST_MODE_AVG){
		stoh = (iStochastic(sy,tf,k,d,sl,me,pr,MODE_MAIN,sh) + iStochastic(sy,tf,k,d,sl,me,pr,MODE_SIGNAL,sh))/2;
	}else{
		stoh = iStochastic(sy,tf,k,d,sl,me,pr,line,sh);
	}
	
	stoh = Norm_symb(stoh, "", dgt); 
	return(stoh);
}

int iSth_getArray(int h, double &a[], int l=MODE_MAIN, int shift = -1, double def=-1/** если > -1, то заполняет массив переданным значением*/){
	/**
		\version	0.0.0.1
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	Возвращает массив линии индикатора из 3-х элементов.
		\internal
			>Hist:	
					 @0.0.0.1@2013.07.17@artamir	[]	iSth_getArray
			>Rev:0
	*/

	ArrayResize(a,0);	//Очистили массив.
	int ROWS = 0;		//Начальное количество элементов.
	
	for(int i = shift-1; i<= shift+1; i++){
		ROWS++;
		ArrayResize(a,ROWS);
		if(def==-1){
				a[ROWS-1]=iSth_get(h, l, i);
		}else{
			a[ROWS-1]=def;
		}	
	}
	
	return(ROWS);
}

//{ === Работа с пересечением линий.
#define ST_CRNONE	0
#define ST_CRUP	1
#define ST_CRDW	2

int iSth_Cross(		double &f[] /** быстрый массив   */
				,	double &s[] /** медленный массив */
				, 	int shift=2 /** индекс бара для проверки пересечения */){
	/**
		\version	0.0.0.2
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Определяем, было ли на баре с заданным индексом пересечение значений быстрого и медленного массива
					Возвращает статус пересечения. (0: нет пересечения, 1: пересечение снизу вверх, 2: пересечение сверху вниз)
		\internal
			>Hist:		
					 @0.0.0.2@2013.07.25@artamir	[]	изменились определения.
					 @0.0.0.1@2013.07.17@artamir	[]	iSth_Cross
			>Rev:0
	*/

	double f3=Norm_symb(f[shift+1],"",2), f2=Norm_symb(f[shift],"",2), f1=Norm_symb(f[shift-1],"",2);
	double s3=Norm_symb(s[shift+1],"",2), s2=Norm_symb(s[shift],"",2), s1=Norm_symb(s[shift-1],"",2);
	
	int status = ST_CRNONE;
	
	if(f3<s3 && f2>s2){
		status = ST_CRUP;
	}
	
	if(f3>s3 && f2<s2){
		status = ST_CRDW;
	}
	
	if(f2==s2){
		if(f3<s3 && f1>s1){
			status = ST_CRUP;
		}
		
		if(f3>s3 && f1<s1){
			status = ST_CRDW;
		}
	}
	
	return(status);
	
}

int iSth_CrossMainSignal(int h, int shift = 1){
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
	
	int ROWS_f = iSth_getArray(h, f, MODE_MAIN,   shift);
	int ROWS_s = iSth_getArray(h, s, MODE_SIGNAL, shift);
	return(iSth_Cross(f,s,1));
}

int iSth_CrossMainLevel(int h, int l=80 /** exemple 80*/, int shift=1){
	/**
		\version	0.0.0.0
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	Пересечение основной линии с заданным уровнем
		\internal
			>Hist:
			>Rev:0
	*/

	double f[];
	double s[];
	
	int ROWS_f = iSth_getArray(h, f, MODE_MAIN,   shift);
	int ROWS_s = iSth_getArray(h, s, 0, 0, l);
	return(iSth_Cross(f,s,1));
	
}
//}

