	/*
		>Ver	:	0.0.3
		>Date	:	2012.11.14
		>Hist	:
			@0.0.3@2012.11.14@artamir	[]
			@0.0.2@2012.11.14@artamir	[]
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	extern string AO.3MA.NAME = ">>>>> AUTOOPEN BY 3 MA";
	extern bool	AO.3MA.Use	= false;
	extern int AO.3MA.MAF.per = 5;
	extern int AO.3MA.MAM.per = 21;
	extern int AO.3MA.MAS.per = 55;
	extern int AO.3MA.LastCross = 5;
	
	void AO.3MA.Main(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		if(!AO.3MA.Use){
			return;
		}
		
		//--------------------------------------------------
		AO.3MA.check();
	}
	
	int AO.3MA.check(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		//--------------------------------------------------
		int sig = -1;
		
		s3MA.Set(AO.3MA.MAF.per, AO.3MA.MAM.per, AO.3MA.MAS.per);
		
		sig = s3MA.getSignal(AO.3MA.LastCross);
		
		//--------------------------------------------------
		if(sig <= -1){
			return(-1);
		}
		
		//--------------------------------------------------
		if(sig == OP_BUY){
			AO.3MA.OpenBUY();
		}
		
		//--------------------------------------------------
		if(sig == OP_SELL){
			AO.3MA.OpenSELL();
		}
	}
	
	int AO.3MA.OpenBUY(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		
		int ti = -1;
		
		//--------------------------------------------------
		if(mngAO.IsOrderByMethod(AOM.3MA.B) <= 0){
			ti = libO.SendBUY(0.1);
		}
		
		//--------------------------------------------------
		if(ti > 0){
			libT.setExtraStandartData(ti);
			libT.setExtraAOMByTicket(ti, AOM.3MA.B);
		}
	}
	
	int AO.3MA.OpenSELL(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		
		int ti = -1;
		
		//--------------------------------------------------
		if(mngAO.IsOrderByMethod(AOM.3MA.S) <= 0){
			ti = libO.SendSELL(0.1);
		}
		
		//--------------------------------------------------
		if(ti > 0){
			libT.setExtraStandartData(ti);
			libT.setExtraAOMByTicket(ti, AOM.3MA.S);
		}
	}