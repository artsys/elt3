/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
	>Hist:
			@0.0.1@2012.09.10@artamir	[]
	>Desc:
		Open order, when New ZZ draw.
*/

extern string plgAO.MAZZ600 = ">>>>> AUTOOPEN: MA600+ZZ600"; 
extern bool plgAO.MAZZ600.Use = false;						//Use MA600+ZZ600 autoopen method?
extern int  plgAO.MAZZ600.MADelta.Pip = 10;					//На какое расстояние от ма должна уйти цена

int plgAO.MAZZ600.Main(){//..
	
	//------------------------------------------------------
	if(plgAO.MAZZ600.Use){
		plgAO.MAZZ600.checkOpen();
	}
}//.

//==========================================================
int plgAO.MAZZ600.checkOpen(){//..
	
	int Sig = libSM.MAZZ600.Main();
	
	int IDSig = -1;
	//------------------------------------------------------
	if(Sig == OP_BUY){//..
		int COrders = mngAO.IsOrderByMethod(AOM.MAZZ600.B);
		IDSig = AOM.MAZZ600.B;
	}else{
		if(Sig == OP_SELL){//..
			COrders = mngAO.IsOrderByMethod(AOM.MAZZ600.S);
			IDSig = AOM.MAZZ600.S;
		}//.
	}//.	
	
	//------------------------------------------------------
	if(COrders <= 0){
		plgAO.MAZZ600.OpenByIDSignal(IDSig);
	}
}//.

//==========================================================
int plgAO.MAZZ600.OpenByIDSignal(int id){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/
	
	//------------------------------------------------------
	if(id <= -1){//..
		return(-1);
	}//.
	
	Comment("id = ", id);
	//------------------------------------------------------
	if(id == AOM.MAZZ600.B){//..
		
		//--------------------------------------------------
		int ticket = libO.SendBUY(0.1);
	}//.
	
	//------------------------------------------------------
	if(id == AOM.MAZZ600.S){
		
		//--------------------------------------------------
		ticket = libO.SendSELL(0.1);
	}
	
	//------------------------------------------------------
	libT.Start();											//Refresh cur orders and events
	
	//------------------------------------------------------
	if(ticket > 0){//..
		libT.setExtraAOMByTicket(ticket, id);
	}//.
}//.