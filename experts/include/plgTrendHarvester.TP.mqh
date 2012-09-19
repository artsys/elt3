/*
		>Ver	:	0.0.3
		>Date	:	2012.09.17
	>Hist:
			@0.0.3@2012.09.17@artamir	[]
			@0.0.2@2012.09.17@artamir	[]
			@0.0.1@2012.09.17@artamir	[]
	>Desc:
		Plugin for calc tp for orders
*/

extern bool plgTHTP.UseFix = false;
extern int	plgTHTP.TPpip = 25;

//==========================================================
int plgTHTP.Main(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.17
		>Hist:
			@0.0.1@2012.09.17@artamir	[]
		>Desc:
	*/
	
	//------------------------------------------------------
	if(!plgTHTP.UseFix){
		return(-1);
	}
	
	//------------------------------------------------------
	plgTHTP.checkFixTP();
}//.

//==========================================================
int plgTHTP.checkFixTP(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.17
		>Hist:
			@0.0.1@2012.09.17@artamir	[]
		>Desc:
	*/
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	libA.double_eraseFilter2();
	
	int f.COL = libT.OE_ISCLOSED;
	double f.MAX = 0;
	double f.MIN = -10000;
	int f.OP = libA.SOP.AND;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);
	
	//------------------------------------------------------
	int ROWS = ArrayRange(d, 0);
	
	//------------------------------------------------------
	if(ROWS >= 1){//..
		for(int idx = 0; idx < ROWS; idx ++){//..
			int ticket = d[idx][libT.OE_TI];
			
			plgTHTP.checkFixTPOnTicket(ticket);
		}//.
	}//.
}//.

int plgTHTP.checkFixTPOnTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.17
		>Hist:
			@0.0.1@2012.09.17@artamir	[]
		>Desc:
	*/
	
	//------------------------------------------------------
	libO.ModifyTP(ticket, plgTHTP.TPpip, libO.MODE_PIP);
}//.