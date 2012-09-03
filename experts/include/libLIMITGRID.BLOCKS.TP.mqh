/*
		>Ver	:	0.0.1
		>Date	:	2012.08.23
		>Hist:
		>Desc:
			Modify tp for orders from limit grid block.
		>Зависимости:
			#include <libTerminal.mqh>
			#include <libOrders.mqh>
			#include <libTP.mqh>
			#include <libInd_MA.mqh>
*/

extern bool	libLGB.TP.UseParentTP = false;
extern int	libLGB.TP.FixPip = 30;
extern bool libLGB.TP.UseMA600 = false;

int libLGB.TP.Main(int TICKET, int PARENT_TI = -1){			//..
	
	//------------------------------------------------------
	if(libLGB.TP.UseParentTP){	//..
		libLGB.TP.CheckAsParent(TICKET, PARENT_TI);
	}							//.
	
	//------------------------------------------------------
	if(libLGB.TP.UseMA600){	//..
		libLGB.TP.SetTPOnMA600(TICKET);
	}						//.
}															//.

int libLGB.TP.CheckAsParent(int TICKET, int PARENT_TI){		//..
	double	parent_tp	= libT.CurTPByTicket(PARENT_TI);
	double	ticket_tp	= libT.CurTPByTicket(TICKET);
	
	//------------------------------------------------------
	if(ticket_tp == parent_tp){	//..
		return(1);
	}							//.
	
	//------------------------------------------------------
	libTP.SetTPAsOnTicket(PARENT_TI, TICKET);
}															//.

int libLGB.TP.SetTPOnMA600(int TICKET){						//..
	
	//------------------------------------------------------
	double ma600 = libI_MA.GetEMA(600);
	
	//------------------------------------------------------
	double ticket_tp = libT.CurTPByTicket(TICKET);
	
	//------------------------------------------------------
	if(ticket_tp == ma600){	//..
		return(1);
	}						//.
	
	//------------------------------------------------------
	if(libTP.SetTPOnPrice(TICKET, ma600)){	//..
		return(1);
	}else{
		return(0);
	}										//.
}															//.