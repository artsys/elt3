/*
		>Ver	:	0.0.0.7
		>Date	:	2013.05.20
		>Hist:						
				 @0.0.0.7@2013.05.20@artamir	[]	aMA_set
				 @0.0.0.6@2013.05.20@artamir	[]	iMA_getByHandle
				 @0.0.5@2013.02.19@artamir	[]	iMA_isCrossDw
				 @0.0.4@2013.02.19@artamir	[]	iMA_isCrossDw
				 @0.0.3@2013.02.14@artamir	[]	iMA_isCrossDw
				 @0.0.2@2013.02.14@artamir	[+]	iMA_getLastCrossBar
		>Descr:
			Библиотека функций для работы с машками
		>Зависимости:
			#include <libNormalizE_mqh>
*/

string aMASets[];

void aMA_Init(){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Очищает стринговый массив. Использовать при каждом запуске ф-ции старт
		\internal
			>Hist:
			>Rev:0
	*/

	ArrayResize(aMASets,0);
}

int aMA_set(int per = 21, int mode_ma = MODE_EMA, int app_price = PRICE_CLOSE, string sy=""){
	/**
		\version	0.0.0.1
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.20@artamir	[]	aMA_set
			>Rev:0
	*/

	int ROWS = ArrayRange(aMASets,0);
	ROWS++;
	int lastROW=ROWS-1;
	ArrayResize(aMASets, ROWS);
	
	if(sy == ""){
		sy=Symbol();
	}
	
	string s = "";
	s=s+"@p"+per;
	s=s+"@m"+mode_ma;
	s=s+"@ap"+app_price;
	s=s+"@sy"+sy;
	
	aMASets[lastROW]=s;
	return(lastROW);
}

double iMA_getByHandle(int handle=0, int shift=0, int d=0){
	/**
		\version	0.0.0.1
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.20@artamir	[]	iMA_getByHandle
			>Rev:0
	*/

	int p = Struc_KeyValue_int(aMASets[handle], "@p");
	int mode = Struc_KeyValue_int(aMASets[handle], "@m");
	int ap = Struc_KeyValue_int(aMASets[handle], "@ap");
	string sy = Struc_KeyValue_string(aMASets[handle], "@sy");
	double ma = iMA(sy,0,p,0,mode,ap,shift);
	ma = Norm_symb(ma, "", d); 
	return(ma);
}

double iMA_getLevel(int handle=0, int shift=0, int level_pip = 50){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

	double ma = iMA_getByHandle(handle, shift);
	
	return(Norm_symb(ma+level_pip*Point));
}

bool iMA_isPinAbove(int handle=0, int shift=0, int level_pip=50){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Вычисляет если лоу бара по смещению shift было ниже ма на том же баре, а мин(закрытие/открытие) 
					бара было выше ма.
		\internal
			>Hist:
			>Rev:0
	*/

	double ma = iMA_getLevel(handle, shift, level_pip);
	if(iLow(Symbol(), 0, shift) <= ma && MathMin(iOpen(Symbol(), 0, shift), iClose(Symbol(), 0, shift)) > ma){
		return(true);
	}
	
	return(false);
}

bool iMA_isPinBelow(int handle=0, int shift=0, int level_pip=50){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Вычисляет если хай бара по смещению shift было выше ма на том же баре, а мин(закрытие/открытие) 
					бара было ниже ма.
		\internal
			>Hist:
			>Rev:0
	*/

	double ma = iMA_getLevel(handle, shift, level_pip);
	if(iHigh(Symbol(), 0, shift) >= ma && MathMax(iOpen(Symbol(), 0, shift), iClose(Symbol(), 0, shift)) < ma){
		return(true);
	}
	
	return(false);
}



double iMA_getMA(int per = 21, int shift = 0, int d = 0, int ty = MODE_EMA){
	/* 
		>Ver	:	0.0.5
		>Date	:	2012.08.30
		>Hist:
			@0.0.5@2012.08.30@artamir	[]
			@0.0.4@2012.08.03@artamir	[*] изменение в поведении переменной d
			@0.0.3@2012.08.03@artamir	[]
		>Description:	Возвращает значение ЕМА для заданного  
						периода и смещения по текущему таймфрейму 
		>VARS: 
			per = период МА 
			shift = номер бара для расчета МА 
			d = число добавляемых знаков после запятой к текущему инструменту.
	*/ 
	 
	//=============================================== 
	double	ma = iMA(Symbol(), 0, per, 0, ty, 0, shift); 
			ma = Norm_symb(ma, "", d); 
	//===============================================                
	return(ma);
}

int iMA_getLastCrossBar(int f_per = 5, int s_per = 21, int start = 1, int ty = MODE_EMA){ 
   /* 
      Ver: 0.0.2 
      Date: 2013.02.14 
      Author: artamir 
      Description:   Возвращает номер бара последнего пересечения быстрой 
                     и медленной ЕМА на текущем инструменте, по текущему 
                     таймфрейму 
      VARS: 
         f_per = период быстрой ЕМА 
         s_per = период медленной ЕМА 
         start = номер бара, с которого начинается расчет в сторону увеличения номеров баров.                      
   */ 
    
   int   limit    = Bars - 1; 
   //===================================================== 
   bool  isCross  = false; 
   int   thisBar  = start; 
   int   crossBar = limit; 
   //-------------------- 
   while(thisBar < limit && !isCross){ 
      //-------------------------------------------------- 
      double ma1_1 = iMA_getMA(f_per, thisBar,     Digits+2,	ty); 
      double ma1_2 = iMA_getMA(f_per, thisBar+1,   Digits+2,	ty); 
      //-------------------------------------------------- 
      double ma2_1 = iMA_getMA(s_per, thisBar,     Digits+2,	ty); 
      double ma2_2 = iMA_getMA(s_per, thisBar+1,   Digits+2,	ty); 
      //================================================== 
      if(ma1_1 > ma2_1 && ma1_2 < ma2_2){ 
         isCross  = true; 
         crossBar = thisBar; 
      } 
      //================================================== 
      if(ma1_1 < ma2_1 && ma1_2 > ma2_2){ 
         isCross  = true; 
         crossBar = thisBar; 
      } 
      thisBar++; 
   } 
   //===================================================== 
   return(crossBar);  
}  

bool iMA_isPriceAbove(int per, double pr, int shift = 0, int ty = MODE_EMA){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Возвращает true, если заданная цена
					выше цены EMA с заданным периодом
					и на заданном баре
		>VARS	:	per - период ЕМА
					pr	- значение цены для проверки
					shift	- индекс бара, для которого проверяется 
							  положение заданной цены относительно ЕМА
	*/
	
	bool res = false;
	double ma = iMA_getMA(per, shift, 0, ty);
	
	if(pr > ma){
		return(true);
	}
	
	return(res);
}

bool iMA_isPriceUnder(int per, double pr, int shift = 0, int ty = MODE_EMA){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Возвращает true, если заданная цена
					ниже цены EMA с заданным периодом
					и на заданном баре
		>VARS	:	per - период ЕМА
					pr	- значение цены для проверки
					shift	- индекс бара, для которого проверяется 
							  положение заданной цены относительно ЕМА
	*/
	
	bool res = false;
	double ma = iMA_getMA(per, shift, 0, ty);
	
	if(pr < ma){
		return(true);
	}
	
	return(res);
}

bool iMA_isCrossUp(int per_f = 5, int per_s = 21, int cb = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.11.15
		>Hist	:
			@0.0.2@2012.11.15@artamir	[]
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Возвращает true если на предыдущем баре 
					до бара с заданным номером быстрая EMA
					была ниже медленной  EMA
	*/
	
	double maf, mas = 0;
	
	bool res = false;
	
	//------------------------------------------------------
	if(cb <= -1){
		return(false);
	}
	
	//------------------------------------------------------
	int prev_bar = cb+1;
	
	maf = iMA_getMA(per_f, prev_bar);
	mas = iMA_getMA(per_s, prev_bar);
	
	//------------------------------------------------------
	if(maf == mas){
		prev_bar++;
		
		//--------------------------------------------------
		maf = iMA_getMA(per_f, prev_bar);
		mas = iMA_getMA(per_s, prev_bar);
	}
	
	//------------------------------------------------------
	if(maf < mas){
		return(true);
	}
	
	//------------------------------------------------------
	return(res);
}

bool iMA_isCrossDw(int per_f = 5, int per_s = 21, int cb = -1){
	/*
		>Ver	:	0.0.4
		>Date	:	2013.02.19
		>Hist	:
			@0.0.2@2012.11.15@artamir	[]
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Возвращает true если на предыдущем баре 
					до бара с заданным номером быстрая EMA
					была выше медленной  EMA
	*/
	
	double maf, mas = 0;
	
	bool res = false;
	
	//------------------------------------------------------
	if(cb <= -1){
		return(false);
	}
	
	//------------------------------------------------------
	int prev_bar = cb+1;
	
	maf = iMA_getMA(per_f, prev_bar);
	mas = iMA_getMA(per_s, prev_bar);
	
	//------------------------------------------------------
	if(maf == mas){
		prev_bar++;
		
		//--------------------------------------------------
		maf = iMA_getMA(per_f, prev_bar);
		mas = iMA_getMA(per_s, prev_bar);
	}
	
	//------------------------------------------------------
	if(maf > mas){
		return(true);
	}
	
	//------------------------------------------------------
	return(res);
}

bool iMA_isPriceBetween2Ma(int per_f, int per_s, double pr, int shift = 0, int ty = MODE_EMA){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.14
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	bool res = false;
	
	//------------------------------------------------------
	double ma_f = iMA_getMA(per_f, shift, 0, ty);
	double ma_s = iMA_getMA(per_s, shift, 0, ty);
	
	if((ma_f > pr && pr > ma_s) || (ma_s > pr && pr > ma_f)) return(true);
	//------------------------------------------------------
	return(res);
}

