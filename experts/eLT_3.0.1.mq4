/*
		>Ver	:	0.1.4
		>Date	:	2012.10.05
		>History:
		>Description:
			ѕомошник реализации различных стратегий сопровождени€ открытых позиций
			»м€ файла дл€ сохранени€ массива array_dExtraOrders[][]:
			»м€Ёксперта.—чет.ѕара.extra.arr
*/	

#define	EXP	"eLT3"
#define	VER	"0.1.4_2012.10.05"



//...	@VARS
string	fnExtra	= ""	;
bool 	Debug	= false	;

//----------------------------------------------------------
bool	isStart = true	;
//.

//==========================================================
#include	<sysELT3.mqh>


//==========================================================
int init(){
	
	fnExtra = getExtraFN();

	
	//------------------------------------------------------
	ELT.init(fnExtra);
}

//==========================================================
int deinit(){
	ELT.deinit(fnExtra);
}

//==========================================================
int start(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>History:
			@0.0.1@2012.10.02@artamir	[]
		>Description:
			start function of EA.
	*/
	
	Comment(	"EXP ver: "	,VER	,"\n"
			,	"Sys ver: "	,ELTVER	,"\n");
	
	//------------------------------------------------------
	if(isStart) isStart = false;

	//------------------------------------------------------
	Main();													//called from sysELT3
	
	//------------------------------------------------------
	//mngAO.Main();											//Main function of autoopen manager.
	
	//------------------------------------------------------
	//libCY.Main();											//Main function of convoys manager.

	//------------------------------------------------------
	return(0);
}


//==========================================================
string getExtraFN(){
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
}

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
