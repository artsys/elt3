/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
	>Hist:
			@0.0.1@2012.09.10@artamir	[]
	>Desc:
*/

string libMain.getExtraFN(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
			@0.0.3@2012.09.10@artamir	[]
			@0.0.2@2012.09.10@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
		>Description:
	*/
	
	string fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"Extra.arr";
	
	//------------------------------------------------------
	return(fn);
}//.