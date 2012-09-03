/*
		>Ver	:	0.0.1
		>Date	:	2012.08.23
		>Hist:
		>Desc:
			Manager of limit grids.
*/

extern	bool	libLG.UseLimitsOrders	=	false;			// Use grid of limit orders?

#include <libLIMITGRID.BLOCKS.mqh>							// Convoy by blocks of limit grids 

void libLG.Main(int PARENT_TI){
	if(!libLG.UseLimitsOrders) return;
	
	//------------------------------------------------------
	libLGB.Main(PARENT_TI);
}