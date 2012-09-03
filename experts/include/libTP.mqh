/*
		>Ver	:	0.0.1
		>Date	:	2012.08.23
		>Hist:
		>Desc:
			Выставление тейкпраофита для блока сетки лимитных ордеров.
		>Зависимости:
			#include <libTerminal.mqh>
			#include <libOrders.mqh>
*/

bool libTP.SetTPAsOnTicket(int source_ticket, int dest_ticket){	//..
	double tp_source	= libT.CurTPByTicket(source_ticket);
	double tp_dest		= libT.CurTPByTicket(dest_ticket);
	
	//------------------------------------------------------
	if(tp_dest == tp_source){	//..
		return(true);
	}							//.
	
	//------------------------------------------------------
	return(libO.ModifyTP(dest_ticket, tp_source));
}																//.

bool libTP.SetTPOnPrice(int ticket, double tp_price){		//..
	
	//------------------------------------------------------
	double ticket_tp = libT.CurTPByTicket(ticket);
	
	//------------------------------------------------------
	if(ticket_tp == tp_price){	//..
		return(true);
	}							//.
	
	//------------------------------------------------------
	return(libO.ModifyTP(ticket, tp_price));
}															//.