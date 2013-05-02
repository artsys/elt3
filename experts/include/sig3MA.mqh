	/*
		>Ver	:	0.0.4
		>Date	:	2012.11.20
		>Hist	:
			@0.0.4@2012.11.20@artamir	[]
			@0.0.3@2012.11.15@artamir	[]
			@0.0.2@2012.11.15@artamir	[]
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	int s3MA.MAF.per = 5;
	int s3MA.MAM.per = 21;
	int s3MA.MAS.per = 55;
	
	void s3MA.Set(int maf.per = 5, int mam.per = 21, int mas.per = 55){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	set periods for ma
	*/
		s3MA.MAF.per = maf.per;
		s3MA.MAM.per = mam.per;
		s3MA.MAS.per = mas.per;
	}
	
	int s3MA.getSignal(int maxCB = 1000){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.11.20
		>Hist	:
			@0.0.3@2012.11.20@artamir	[*] checking for last
			@0.0.2@2012.11.15@artamir	[]
			@0.0.1@2012.11.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		
		int cb = -1;										// cross bar
		
		//..	@CHECK IF WAS BUY SIGNAL
		
			if(iEMA.isPriceAbove(s3MA.MAM.per, iClose(NULL, 0, 1), 1)){
				cb = iEMA.getLastCrossBar(s3MA.MAF.per, s3MA.MAM.per, 1);	//получаем номер бара последнего пересечения
																			//двух EMA - быстрой и средней
				
				//------------------------------------------
				if(cb >= 0 && cb <= maxCB){									//если номер бара пересечения меньше максимально разрешенного
					if(iEMA.isCrossUp(s3MA.MAF.per, s3MA.MAM.per, cb)){		//если последнее пересечение было : быстрая пересекла среднюю ЕМА снизу вверх
						
						//----------------------------------
						if(iEMA.isPriceAbove(s3MA.MAS.per, iEMA.getEMA(s3MA.MAM.per, cb), cb)){ //если на момент пересечения средняя ЕМА была выше медленной, 
							return(OP_BUY);									// тогда покупаем :))))
						}
					}
				}
			}
		//.
		
		//..	@CHECK IF WAS SELL SIGNAL
		
		
			if(iEMA.isPriceUnder(s3MA.MAM.per, iClose(NULL, 0, 1), 1)){
				cb = iEMA.getLastCrossBar(s3MA.MAF.per, s3MA.MAM.per, 1);
					
				//------------------------------------------
				if(cb >= 0 && cb <= maxCB){
					if(iEMA.isCrossDw(s3MA.MAF.per, s3MA.MAM.per, cb)){
						
						//----------------------------------
						if(iEMA.isPriceUnder(s3MA.MAS.per, iEMA.getEMA(s3MA.MAM.per, cb), cb)){
							return(OP_SELL);
						}
					}
				}
			}
		//.
		
		return(-1);											// NO SIGNAL
	}