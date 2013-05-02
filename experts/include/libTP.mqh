/*
		>Ver	:	0.0.3
		>Date	:	2012.10.25
		>Hist:
			@0.0.3@2012.10.25@artamir	[]
			@0.0.2@2012.10.25@artamir	[]
		>Desc:
			Выставление тейкпраофита для блока сетки лимитных ордеров.
		>Зависимости:
			#include <libTerminal.mqh>
			#include <libOrders.mqh>
*/

extern string GTP.Start = ">>>>>>> USE FIX TP ON PARENTS";
extern bool	GTP.FIXTP.Use = false;
extern int GTP.FIXTP.pip = 50;


int libTP.Main(){
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	
	*/
	
	//------------------------------------------------------
	if(GTP.FIXTP.Use){
		
		//--------------------------------------------------
		libTP.FIXTP.Check();
	}
}

int libTP.FIXTP.Check(){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.25
		>Hist	:
			@0.0.2@2012.10.25@artamir	[]
			@0.0.1@2012.10.25@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	//------------------------------------------------------
	int ROWS = libT.SelectExtraWOTP(d);

	//------------------------------------------------------
	if(ROWS <= 0){
		return(0);
	}
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){
		
		//-------------------------------------------------
		int ti = d[idx][libT.OE_TI];

		//--------------------------------------------------
		libO.ModifyTP(ti, GTP.FIXTP.pip, libO.MODE_PIP);
	}
}

bool libTP.SetTPAsOnTicket(int source_ticket, int dest_ticket){
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double tp_source	= libT.CurTPByTicket(source_ticket);
	double tp_dest		= libT.CurTPByTicket(dest_ticket);
	
	//------------------------------------------------------
	if(tp_dest == tp_source){	
		return(true);
	}							
	
	//------------------------------------------------------
	return(libO.ModifyTP(dest_ticket, tp_source));
}															

bool libTP.SetTPOnPrice(int ticket, double tp_price){		
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	double ticket_tp = libT.CurTPByTicket(ticket);
	
	//------------------------------------------------------
	if(ticket_tp == tp_price){	
		return(true);
	}							
	
	//------------------------------------------------------
	return(libO.ModifyTP(ticket, tp_price));
}															