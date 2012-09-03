/*
		>Ver	:	0.0.1
		>Date	:	2012.08.29
		>Hist:
		>Desc:
			ќсновной блок сопровождени€ ордера.
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
	>Desc: –одительские ордера, выставленные вручную или
			сторонними советниками.
*/

double	libCY.array_dParents[];								//“икеты родительских ордеров.
//.

#include <libSTOPTRAL.mqh>									//libSOTr
//#include <libLIMITGRID.mqh>									//libLG

int libCY.Main(int PARENT = -1){//..
	//=== LIMIT GRID ---------------------------------------
	//libLG.Main(PARENT);										//
	
	//------------------------------------------------------
	libSOTr.Main(PARENT);
}//.
