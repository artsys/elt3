/*
		>Ver	:	0.0.6
		>Date	:	2012.11.14
		>Hist:
			@0.0.6@2012.11.14@artamir	[]
			@0.0.5@2012.11.13@artamir	[]
			@0.0.4@2012.11.12@artamir	[]
			@0.0.3@2012.10.15@artamir	[]
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
#define GT.BSZZ	12
#define GT.SSZZ	13
#define GT.BSFF	14
#define GT.SSFF	15


//.

//..	//=== @CONVOY ARRAY	OF PARENT ORDERS@ ================
/*
	>Desc: –одительские ордера, выставленные вручную или
			сторонними советниками.
*/

double	libCY.array_dParents[];								//“икеты родительских ордеров.
//.

#include "STOPTRAL\libSTOPTRAL.mqh"							//libSOTr
#include <SOFF.mqh>

//#include <SOZZ.mqh>
//#include <libLIMITGRID.mqh>								//libLG

int libCY.Main(int PARENT = -1){//..
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	//=== LIMIT GRID ---------------------------------------
	//libLG.Main(PARENT);									//
	
	//------------------------------------------------------
	libSOTr.Main(PARENT);
	
	//------------------------------------------------------
	//SOZZ.Main(PARENT);
	
	//------------------------------------------------------
	SOFF.Main(PARENT);
	
}//.

int CY.selectOByGT(double &d[][], int gt, int col = 0, string comparison = "", int value = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.11.12
		>Hist	:
			@0.0.2@2012.11.12@artamir	[]
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return count of rows from ExtraOrders.
	*/
	
	libA.double_eraseFilter2();
	
	//------------------------------------------------------
	//..	SELECT BY GRID TYPE
	int		f.COL	= libT.OE_GRIDTYPE;
	double	f.MAX	= gt;
	double	f.MIN	= gt;
	int		f.OP	= libA.SOP.AND;
	//.
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	
	//------------------------------------------------------
	//..	SELECT NON CLOSED
	f.COL	= libT.OE_ISCLOSED;
	f.MAX	= 0;
	f.MIN	= -1;
	f.OP	= libA.SOP.AND;
	//.
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	
	//------------------------------------------------------
	//..	SELECT IF NEED COMPARISION
	if(comparison != ""){
		if(value > -1){
			
			f.COL = col;
			f.OP = libA.SOP.AND;
			//----------------------------------------------
			if(comparison == ">="){
				f.MIN = value;
				f.MAX = 100000;
			}
			
			//----------------------------------------------
			if(comparison == ">"){
				f.MIN = value+1;
				f.MAX = 100000;
			}
			
			//----------------------------------------------
			if(comparison == "<="){
				f.MIN = -100000;
				f.MAX = value;
			}
			
			//----------------------------------------------
			if(comparison == "<"){
				f.MIN = -100000;
				f.MAX = value-1;
			}
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		}
	}
	//.
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);
	
	//------------------------------------------------------
	int RES.ROWS = ArrayRange(d, 0);
	
	//------------------------------------------------------
	if(RES.ROWS <= 0){
		RES.ROWS = -1;
	}
	
	//------------------------------------------------------
	return(RES.ROWS);
	
}

int CY.selectOByGT2(double &d[][], int gt1, int gt2, int col = 0, string comparison = "", int value = -1){
	/*
		>Ver	:	0.0.4
		>Date	:	2012.11.14
		>Hist	:
			@0.0.4@2012.11.14@artamir	[]
			@0.0.3@2012.11.13@artamir	[]
			@0.0.2@2012.11.12@artamir	[]
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return count of rows from ExtraOrders.
	*/
	
	libA.double_eraseFilter2();
	
	//------------------------------------------------------
	//..	SELECT BY GRID TYPE 1
	int		f.COL	= libT.OE_GRIDTYPE;
	double	f.MAX	= gt1;
	double	f.MIN	= gt1;
	int		f.OP	= libA.SOP.OR;
	//.
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	
	//------------------------------------------------------
	//..	SELECT BY GRID TYPE 2
	f.COL	= libT.OE_GRIDTYPE;
	f.MAX	= gt2;
	f.MIN	= gt2;
	f.OP	= libA.SOP.OR;
	//.
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	
	/*	- artamir: I need select closed orders too
	//------------------------------------------------------
	//..	SELECT NON CLOSED
	f.COL	= libT.OE_ISCLOSED;
	f.MAX	= 0;
	f.MIN	= -1;
	f.OP	= libA.SOP.AND;
	//.
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	*/
	
	//------------------------------------------------------
	//..	SELECT IF NEED COMPARISION
	if(comparison != ""){
		if(value > -1){
			
			f.COL = col;
			f.OP = libA.SOP.AND;
			//----------------------------------------------
			if(comparison == ">="){
				f.MIN = value;
				f.MAX = 100000;
			}
			
			//----------------------------------------------
			if(comparison == ">"){
				f.MIN = value+1;
				f.MAX = 100000;
			}
			
			//----------------------------------------------
			if(comparison == "<="){
				f.MIN = -100000;
				f.MAX = value;
			}
			
			//----------------------------------------------
			if(comparison == "<"){
				f.MIN = -100000;
				f.MAX = value-1;
			}
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		}
	}
	//.
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);
	
	//------------------------------------------------------
	int RES.ROWS = ArrayRange(d, 0);
	
	//------------------------------------------------------
	if(RES.ROWS <= 0){
		RES.ROWS = -1;
	}
	
	//------------------------------------------------------
	return(RES.ROWS);
	
}

