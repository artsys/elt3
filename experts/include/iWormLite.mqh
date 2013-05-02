	/*
		>Ver	:	0.0.3
		>Date	:	2013.01.11
		>Hist	:
			@0.0.3@2013.01.11@artamir	[]
			@0.0.2@2012.11.30@artamir	[]
			@0.0.1@2012.11.28@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
double iWL.getPriceOnBar(int pip, int shift){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.01.11
		>Hist	:
			@0.0.2@2013.01.11@artamir	[]
			@0.0.1@2012.11.28@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/

	double pr = iCustom(NULL, 0, "iWormLite_v1", pip, 0, shift);

	//------------------------------------------------------
	return(pr);
}	

bool iWL.isPriceAbove(double pr, int pip, int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.30
		>Hist	:
			@0.0.1@2012.11.30@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double wl.pr = iWL.getPriceOnBar(pip, shift);
	
	if(pr > wl.pr){
		return(true);
	}
	
	return(false);
}

bool iWL.isPriceUnder(double pr, int pip, int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.30
		>Hist	:
			@0.0.1@2012.11.30@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double wl.pr = iWL.getPriceOnBar(pip, shift);
	
	if(pr < wl.pr){
		return(true);
	}
	
	return(false);
}

