/*
		>Ver	:	0.1.1
		>Date	:	2012.10.02
		>History:
			@0.1.1@2012.10.02@artamir	[]
		>Description:
			ѕомошник реализации различных стратегий сопровождени€ открытых позиций
			»м€ файла дл€ сохранени€ массива array_dExtraOrders[][]:
			»м€Ёксперта.—чет.ѕара.extra.arr
*/	

/*
		>Ver	:	0.1.0
		>Date	:	2012.10.02
		>Hist	:
*/			

#define	EXP	"eLT3"
#define	VER	"0.1.1n_2012.10.02"

//==========================================================
// VARS:
//..	//--------------------------------------------------
string	fnExtra	= ""	;
bool 	Debug	= false	;

//----------------------------------------------------------
bool	isStart = true	;
//.

//==========================================================
#include	<sysELT3.mqh>


//==========================================================
int init(){//..
	
	//fnExtra = libMain.getExtraFN();

	//libA.double_ReadFromFile2(libT.array_dExtraOrders, fnExtra);
	
	//------------------------------------------------------
	//libT.checkExtraIsClosedStatuses();
}//.

//==========================================================
int deinit(){//..
	//libA.double_SaveToFile2(libT.array_dExtraOrders, fnExtra,8);
}//.

//==========================================================
int start(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>History:
			@0.0.1@2012.10.02@artamir	[]
		>Description:
			start function of EA.
	*/
	
	Comment(VER, "\n");
	
	//------------------------------------------------------
	if(isStart) isStart = false;

	//------------------------------------------------------
	Main();													//called from sysELT3
	
	//------------------------------------------------------
	//mngAO.Main();											//Main function of autoopen manager.
	
	//------------------------------------------------------
	//libCY.Main();											//Main function of convoys manager.

}//.


//==========================================================
string getExtraFN(){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.09.10
		>Hist:
			@0.0.3@2012.09.10@artamir	[]
			@0.0.2@2012.09.10@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
		>Description:
	*/
	
	string fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"Extra.arr";

	//------------------------------------------------------
	return(fn);
}//.

double iif( bool condition, double ifTrue, double ifFalse ){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.04.04
		>History:
	*/
	if( condition ) return( ifTrue );
	//---
	return( ifFalse );
}
