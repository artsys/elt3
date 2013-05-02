/*
		>Ver	:	0.0.2
		>Date	:	2012.09.13
	>Hist:
			@0.0.2@2012.09.13@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
	>Desc:
		Open order, when New ZZ draw.
*/

extern string O.MAZZ = ">>>>> AUTOOPEN: MA+ZZ =============="; 
extern bool AO.MAZZ.Use = false;							//Use MA600+ZZ600 autoopen method?
extern int  AO.MAZZ.MAper = 50;								//На какое расстояние от ма должна уйти цена
extern int  AO.MAZZ.ZZper = 50;								//На какое расстояние от ма должна уйти цена

int AO.MAZZ.Main(){//..
	
	//------------------------------------------------------
	if(AO.MAZZ.Use){
		AO.MAZZ.checkOpen();
	}
}//.

//==========================================================
int AO.MAZZ.checkOpen(){//..
	
	int Sig = -1;
	
	//-----------------------------------------------------
	if(AO.MAZZ.IsZZNewDraw("", 0, AO.MAZZ.ZZper)){//..
		
		//--------------------------------------------------
		Sig = Sig.MAZZ.checkMAZZ(AO.MAZZ.MAper, AO.MAZZ.ZZper);
		
	}//.
	
	int IDSig = -1;
	//------------------------------------------------------
	if(Sig == OP_BUY){//..
		int COrders = mngAO.IsOrderByMethod(AOM.MAZZ.B);
		IDSig = AOM.MAZZ.B;
	}else{
		if(Sig == OP_SELL){//..
			COrders = mngAO.IsOrderByMethod(AOM.MAZZ.S);
			IDSig = AOM.MAZZ.S;
		}//.
	}//.	
	
	//------------------------------------------------------
	if(COrders <= 0){
		plgAO.MAZZ.OpenByIDSignal(IDSig);
	}
}//.

//==========================================================
int plgAO.MAZZ.OpenByIDSignal(int id){//..
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
	if(id == AOM.MAZZ.B){//..
		
		//--------------------------------------------------
		int ticket = libO.SendBUY(0.1);
	}//.
	
	//------------------------------------------------------
	if(id == AOM.MAZZ.S){
		
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

//==========================================================
bool AO.MAZZ.IsZZNewDraw (string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.03
		>History:
			@0.0.3@2012.08.03@artamir	[]
			@0.0.2@2012.08.03@artamir	[]
			@0.0.1@2012.07.02@artamir	[*] Добавлен базовый функционал.
		>Description:
			Возвращает True, если образовался новый экстремум зигзага. Иначе возвращает false
		>VARS: 
			sy		= Наименование инструмента
			tf		= таймфейм в минутах
			dp		= Depth
			dv		= Deviation
			bc		= Backstep
	*/
	
	if(sy == ""){
		sy = Symbol();
	}	
	
	//----------------------------------------------------------------------------------------------
	datetime ZZ_thisDrawTime = libI_ZZ.GetZZExtrTimeByNum(0, sy, tf, dp, dv, bc);
	static datetime ZZ_lastDrawTime = 0;
	if(ZZ_lastDrawTime < ZZ_thisDrawTime){
		ZZ_lastDrawTime = ZZ_thisDrawTime;
		return(true);
	}else{
		return(false);
	}
}//.