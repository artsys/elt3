/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
	>Hist:
			@0.0.1@2012.09.10@artamir	[]
	>Desc:
		Open order, when New ZZ draw.
*/

//==========================================================
int sigMAENV.getSignal(int ma.per = 14, int env.pip = 20){//..
	/*
		>Ver:0.0.0
		>Date:
		>Hist:
	*/
	
	//------------------------------------------------------
	double ma = libI_MA.GetEMA(ma.per);
	
	//------------------------------------------------------
	double price.Ask = Ask;
	double price.Bid = Bid;
	
	//------------------------------------------------------
	if(price.Bid > ma){//..
		if( (price.Bid - ma)/Point >= env.pip){
			return(OP_SELL);
		}//.
	}else{
		if(price.Ask < ma){//..
			if( (ma - price.Ask)/Point >= env.pip){//..
				return(OP_BUY);
			}//.
		}//.
	}//.
	
	//------------------------------------------------------
	return(-1);
}//.