	/*
		>Ver	:	0.0.6
		>Date	:	2012.11.21
		>Hist	:
			@0.0.6@2012.11.21@artamir	[]
			@0.0.5@2012.11.21@artamir	[]
			@0.0.4@2012.11.21@artamir	[]
			@0.0.3@2012.11.21@artamir	[]
			@0.0.2@2012.11.21@artamir	[]
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double iSAR.Step = 0.02;
	double iSAR.Maximum = 0.2;
	
	void iSAR.Set(double step=0.02, double max=0.2){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		iSAR.Step = step;
		iSAR.Maximum = max;
	}
	
	double iSAR.getPrice(int shift = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return price of sar
	*/
		
		double sar = iSAR(NULL, 0, iSAR.Step, iSAR.Maximum, shift);
		
		return(sar);
	}
	
	bool iSAR.isUp(int shift = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return true if sar is above high of the bar
	*/
		double h = iHigh(NULL, 0, shift);
		
		if(iSAR.getPrice(shift) > h){
			return(true);
		}else{
			return(false);
		}
	}
	
	bool iSAR.isDw(int shift = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return true if sar is under low of the bar
	*/
	
		double l = iLow(NULL, 0, shift);
		
		if(iSAR.getPrice(shift) < l){
			return(true);
		}else{
			return(false);
		}
	}
	
	int iSAR.getNearUp(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return shift of the nearest up sar
	*/
		int idxBar = -1;
		
		int thisBar = shift;
		
		int maxBars = Bars-shift-1;
		int lim = shift+maxBars;
		
		while (thisBar<=lim && !iSAR.isUp(thisBar)){
			thisBar++;
		}
		
		if(thisBar < lim){
			return(thisBar);
		}else{
			return(-1);
		}
	}
	
	int iSAR.getNearDw(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return shift of the nearest down sar
	*/
		int idxBar = -1;
		
		int thisBar = shift;
		
		int maxBars = Bars-shift-1;
		int lim = shift+maxBars;
		
		while (thisBar<=lim && !iSAR.isDw(thisBar)){
			thisBar++;
		}
		
		if(thisBar < lim){
			return(thisBar);
		}else{
			return(-1);
		}
	}
	
	double iSAR.getNearUpPrice(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return price of the nearest up sar
	*/
		double pr.up = 0;
		
		int idxBar = iSAR.getNearUp(shift);
		
		if(idxBar <= -1){
			return(-1);
		}
		
		pr.up = iSAR.getPrice(idxBar);
		
		//--------------------------------------------------
		return(pr.up);
	}
	
	double iSAR.getNearDwPrice(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.21
		>Hist	:
			@0.0.1@2012.11.21@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return price of the nearest down sar
	*/
		double pr.dw = 0;
		
		int idxBar = iSAR.getNearDw(shift);
		
		if(idxBar <= -1){
			return(-1);
		}
		
		pr.dw = iSAR.getPrice(idxBar);
		
		//--------------------------------------------------
		return(pr.dw);
	}