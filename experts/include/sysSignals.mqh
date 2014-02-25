	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.19
		>Hist	:	
					@0.0.1@2013.02.19@artamir	[]	
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/

int SG_PB2MA_Get(int ma1_per, int ma2_per, double pr){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.19
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double ema1_pr = iMA_getMA(ma1_per,1);
	double ema2_pr = iMA_getMA(ma2_per,1);
	
	if(ema1_pr > ema2_pr){
		if(ema1_pr > pr && pr > ema2_pr){
			return(OP_BUYSTOP);
		}
	}
	
	if(ema1_pr < ema2_pr){
		if(ema2_pr > pr && pr > ema1_pr){
			return(OP_SELLSTOP);
		}
	}
	
	return(-1);
}