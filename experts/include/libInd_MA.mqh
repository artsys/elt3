/*
		>Ver	:	0.0.9
		>Date	:	2012.11.15
		>Hist:
			@0.0.9@2012.11.15@artamir	[]
			@0.0.8@2012.11.15@artamir	[]
			@0.0.7@2012.11.14@artamir	[]
			@0.0.6@2012.11.14@artamir	[]
			@0.0.5@2012.11.14@artamir	[]
			@0.0.4@2012.11.14@artamir	[]
			@0.0.3@2012.08.30@artamir	[]
			@0.0.2@2012.08.03@artamir	[*] libI_MA.GetEMA
			@0.0.1@2012.08.03@artamir	[+] libI_MA.GetEMA
		>Descr:
			Библиотека функций для работы с машками
		>Зависимости:
			#include <libNormalize.mqh>
*/

double libI_MA.GetEMA(int per = 21, int shift = 0, int d = 0){
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
	double	ma = iMA(Symbol(), 0, per, 0, MODE_EMA, 0, shift); 
			ma = libNormalize.Digits(ma, "", d); 
	//===============================================                
	return(ma);          
} 

double iEMA.getEMA(int per = 21, int shift = 0, int d = 0){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.11.14
		>Hist	:
			@0.0.2@2012.11.14@artamir	[]
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	return(libI_MA.GetEMA(per, shift, d));
}

int iEMA.getLastCrossBar(int f_per = 5, int s_per = 21, int start = 1){ 
   /* 
      Ver: 0.0.1 
      Date: 2012.06.22 
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
      double ma1_1 = iEMA.getEMA(f_per, thisBar,     Digits+2); 
      double ma1_2 = iEMA.getEMA(f_per, thisBar+1,   Digits+2); 
      //-------------------------------------------------- 
      double ma2_1 = iEMA.getEMA(s_per, thisBar,     Digits+2); 
      double ma2_2 = iEMA.getEMA(s_per, thisBar+1,   Digits+2); 
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

bool iEMA.isPriceAbove(int per, double pr, int shift = 0){
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
	double ma = iEMA.getEMA(per, shift);
	
	if(pr > ma){
		return(true);
	}
	
	return(res);
}

bool iEMA.isPriceUnder(int per, double pr, int shift = 0){
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
	double ma = iEMA.getEMA(per, shift);
	
	if(pr < ma){
		return(true);
	}
	
	return(res);
}

bool iEMA.isCrossUp(int per_f = 5, int per_s = 21, int cb = -1){
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
	
	maf = iEMA.getEMA(per_f, prev_bar);
	mas = iEMA.getEMA(per_s, prev_bar);
	
	//------------------------------------------------------
	if(maf == mas){
		prev_bar++;
		
		//--------------------------------------------------
		maf = iEMA.getEMA(per_f, prev_bar);
		mas = iEMA.getEMA(per_s, prev_bar);
	}
	
	//------------------------------------------------------
	if(maf < mas){
		return(true);
	}
	
	//------------------------------------------------------
	return(res);
}

bool iEMA.isCrossDw(int per_f = 5, int per_s = 21, int cb = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.11.15
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
	
	maf = iEMA.getEMA(per_f, prev_bar);
	mas = iEMA.getEMA(per_s, prev_bar);
	
	//------------------------------------------------------
	if(maf == mas){
		prev_bar++;
		
		//--------------------------------------------------
		maf = iEMA.getEMA(per_f, prev_bar);
		mas = iEMA.getEMA(per_s, prev_bar);
	}
	
	//------------------------------------------------------
	if(maf > mas){
		return(true);
	}
	
	//------------------------------------------------------
	return(res);
}