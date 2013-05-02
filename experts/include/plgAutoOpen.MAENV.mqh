/*
		>Ver	:	0.0.4
		>Date	:	2012.09.13
	>Hist:
			@0.0.4@2012.09.13@artamir	[]
			@0.0.3@2012.09.13@artamir	[]
			@0.0.2@2012.09.13@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
	>Desc:
		Open order, when New ZZ draw.
*/

extern string plgAO.MAENV = ">>>>> AUTOOPEN: MA Envelope"; 
extern bool plgAO.MAENV.Use = false;						//Use MAEnvelope autoopen method?
extern int  plgAO.MAENV.MA.Period = 10;						//Ma period
extern int	plgAO.MAENV.Env.Pip = 50;								//

//==========================================================
int plgAO.MAENV.Main(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.13
		>Hist:
			@0.0.1@2012.09.13@artamir	[]
	*/
	//------------------------------------------------------
	if(plgAO.MAENV.Use){
		plgAO.MAENV.checkOpens();
	}
	
	//------------------------------------------------------
	return(-1);
}//.

//==========================================================
int plgAO.MAENV.checkOpens(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.13
		>Hist:
			@0.0.1@2012.09.13@artamir	[]
	*/
	//------------------------------------------------------
	int Signal = sigMAENV.getSignal(plgAO.MAENV.MA.Period, plgAO.MAENV.Env.Pip);
	
	//------------------------------------------------------
	if(!plgAO.MAENV.continue(Signal)) return(-1);
	
	//------------------------------------------------------
	int IDSignal = -1;
	
	//------------------------------------------------------
	if(Signal == OP_BUY){
		IDSignal = AOM.MAENV.B;
	}
	
	//------------------------------------------------------
	if(Signal == OP_SELL){
		IDSignal = AOM.MAENV.S;
	}
	
	//------------------------------------------------------
	plgAO.MAENV.OpenByIDSignal(IDSignal);
}//.

//==========================================================
bool plgAO.MAENV.continue(int Sig){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.13
		>Hist:
			@0.0.1@2012.09.13@artamir	[]
	*/
	
	//------------------------------------------------------
	if(Sig <= -1) return(false);
	
	//------------------------------------------------------
	if(Sig == OP_BUY){//..
		int COrders = mngAO.IsOrderByMethod(AOM.MAENV.B);
	}//.
	
	//------------------------------------------------------
	if(Sig == OP_SELL){//..
		COrders = mngAO.IsOrderByMethod(AOM.MAENV.S);
	}//.
	
	//------------------------------------------------------
	if(COrders >= 1){
		return(false);
	}
	
	//------------------------------------------------------
	return(true);
}//.

//==========================================================
int plgAO.MAENV.OpenByIDSignal(int id){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.09.13
		>Hist:
			@0.0.2@2012.09.13@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
	*/
	
	//------------------------------------------------------
	if(id <= -1){//..
		return(-1);
	}//.
	
	Comment("id = ", id);
	//------------------------------------------------------
	if(id == AOM.MAENV.B){//..
		
		//--------------------------------------------------
		int ticket = libO.SendBUY(0.1);
	}//.
	
	//------------------------------------------------------
	if(id == AOM.MAENV.S){
		
		//--------------------------------------------------
		ticket = libO.SendSELL(0.1);
	}
	
	//------------------------------------------------------
	//libT.Start();											//Refresh cur orders and events
	
	//------------------------------------------------------
	if(ticket > 0){//..
		libT.setExtraStandartData(ticket);
		libT.setExtraAOMByTicket(ticket, id);
	}//.
}//.