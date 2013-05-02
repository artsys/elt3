	/*
		>Ver	:	0.0.2
		>Date	:	2012.11.16
		>Hist	:
			@0.0.2@2012.11.16@artamir	[]
			@0.0.1@2012.11.16@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Выставление СЛ для ордеров, у которых нет СЛ
	*/
	
	extern string GSL.Start = ">>>>> USE FIX SL ON PARENT";
	extern bool		GSL.FIXSL.Use = false;
	extern int 		GSL.FIXSL.pip = 50;
	
	int libSL.Main(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.16
		>Hist	:
			@0.0.1@2012.11.16@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		//--------------------------------------------------
		if(!GSL.FIXSL.Use){
			return(0);
		}
		
		//--------------------------------------------------
		libSL.FIXSL.check();
	}
	
	int libSL.FIXSL.check(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.16
		>Hist	:
			@0.0.1@2012.11.16@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		double d[][libT.OE_MAX];
		
		int ROWS = libT.SelectExtraWOSL(d);

	//------------------------------------------------------
	if(ROWS <= 0){
		return(0);
	}
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){
		
		//-------------------------------------------------
		int ti = d[idx][libT.OE_TI];

		//--------------------------------------------------
		libO.ModifySL(ti, GSL.FIXSL.pip, libO.MODE_PIP);
	}
	
	}