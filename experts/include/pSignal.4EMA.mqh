	/*
		>Ver	:	0.0.4
		>Date	:	2012.10.15
		>Hist	:
			@0.0.4@2012.10.15@artamir	[]
			@0.0.3@2012.10.15@artamir	[]
			@0.0.2@2012.10.15@artamir	[]
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int	pS4EMA.MA1.per = 0;											//EMA1 
	int pS4EMA.MA2.per = 0;								
	int	pS4EMA.MA3.per = 0;
	int pS4EMA.MA4.per = 0;
	
//======================================================
int pS4EMA.setEMA(int ma1.per = 64, int ma2.per = 128, int ma3.per = 256, int ma4.per = 512){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.15
		>Hist	:
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
		pS4EMA.MA1.per = ma1.per;
		pS4EMA.MA2.per = ma2.per;
		pS4EMA.MA3.per = ma3.per;
		pS4EMA.MA4.per = ma4.per;
}//.
	

double pS4EMA.getEMAAbovePrice(double price = -1){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.15
		>Hist	:
			@0.0.2@2012.10.15@artamir	[]
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		//--------------------------------------------------
		if(price <= -1){//..
			return(-1);
		}//.
		
		//--------------------------------------------------
		double ema = 10000;
		double ema1 = 10000;
		double ema2 = 10000;
		double ema3 = 10000;
		double ema4 = 10000;
		//--------------------------------------------------
		ema1 = libI_MA.GetEMA(pS4EMA.MA1.per);
		if(ema1 < price){//..
			ema1 = 10000;
		}//.
		
		//--------------------------------------------------
		ema2 = libI_MA.GetEMA(pS4EMA.MA2.per);
		if(ema2 < price){//..
			ema2 = 10000;
		}//.
		
		//--------------------------------------------------
		ema3 = libI_MA.GetEMA(pS4EMA.MA3.per);
		if(ema3 < price){//..
			ema3 = 10000;
		}//.
		
		//--------------------------------------------------
		ema4 = libI_MA.GetEMA(pS4EMA.MA4.per);
		if(ema4 < price){//..
			ema4 = 10000;
		}//.
		
		//--------------------------------------------------
		ema = MathMin(MathMin(ema1,ema2), MathMin(ema3,ema4));
		
		//--------------------------------------------------
		if(ema >= 10000){//..
			ema = -1;
		}//.
		
		return(ema);
}//.	

double pS4EMA.getEMAUnderPrice(double price = -1){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.10.15
		>Hist	:
			@0.0.3@2012.10.15@artamir	[*] get max price of EMA under price 
			@0.0.2@2012.10.15@artamir	[]
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		//--------------------------------------------------
		if(price <= -1){//..
			return(-1);
		}//.
		
		//--------------------------------------------------
		double	ema = -1;
		double	ema1 = -1;
		double	ema2 = -1;
		double 	ema3 = -1;
		double 	ema4 = -1;
		
		//--------------------------------------------------
		ema1 = libI_MA.GetEMA(pS4EMA.MA1.per);
		if(ema1 > price){//..
			ema1 = -1;
		}//.
		
		//--------------------------------------------------
		ema2 = libI_MA.GetEMA(pS4EMA.MA2.per);
		if(ema2 > price){//..
			ema2 = -1;
		}//.
		
		//--------------------------------------------------
		ema3 = libI_MA.GetEMA(pS4EMA.MA3.per);
		if(ema3 > price){//..
			ema3 = -1;
		}//.
		
		//--------------------------------------------------
		ema4 = libI_MA.GetEMA(pS4EMA.MA4.per);
		if(ema4 > price){//..
			ema4 = -1;
		}//.
		
		//--------------------------------------------------
		ema = MathMax(MathMax(ema1, ema2), MathMax(ema3, ema4));
	
		//--------------------------------------------------
		return(ema);
}//.--------------------------------------------------------