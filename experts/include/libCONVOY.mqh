/*
		>Ver	:	0.0.2
		>Date	:	2012.09.03
		>Hist:
		>Desc:
			Main lib to manage convoy methods
*/

//..	//=== CONVOY DEFINES	============================

#define	GT.BL	2
#define	GT.SL	3
#define	GT.BS	4
#define	GT.SS	5
#define	GT.BLB	6
#define	GT.SLB	7
#define	GT.BSB	8
#define	GT.SSB	9
#define GT.BSTR	10
#define GT.SSTR	11

//.

//..	//=== CONVOY ARRAY OF PARENT ORDERS ================
/*
	>Desc: Родительские ордера, выставленные вручную или
			сторонними советниками.
*/

double	libCY.array_dParents[];								//Тикеты родительских ордеров.
//.

//#include <libSTOPTRAL.mqh>									//libSOTr
//#include <libLIMITGRID.mqh>									//libLG
#include <libTrendHarvester.mqh>							//libTH

int libCY.Main(int PARENT = -1){//..
	//=== LIMIT GRID ---------------------------------------
	//libLG.Main(PARENT);										//
	
	//------------------------------------------------------
	//libSOTr.Main(PARENT);
	
	//------------------------------------------------------
	libTH.Main(PARENT);
}//.
