	/*
		>Ver	:	0.1.3
		>Date	:	2012.10.03
		>Hist:
			@0.1.3@2012.10.03@artamir	[]
			@0.1.5@2012.10.03@artamir	[]
			@0.1.4@2012.10.03@artamir	[]
		>Author: Morochin <artamir> Artiom
		>Desc:
			Base include.
			Manager for system include files.
		>Pref:
			non
		>Warning:
			DO NOT CHANGE!!!!
	*/

	/*
		>Ver	:	0.0.9
		>Date	:	2012.10.03
		>Hist	:
			@0.0.9@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
#define	ELTVER	"0.1.3_2012.10.03"
	
//==========================================================
//..	//Include

//--- System	--------------------------------------------
#include	<WinUser32.mqh>
//----------------------------------------------------------
#include	<sysNormalize.mqh>								//Pref: Norm
//----------------------------------------------------------
#include	<sysOrdersExtra.mqh>							//Pref:	OE
#include	<sysTerminal.mqh>								//Pref: T
#include	<sysEvents.mqh>									//Pref:	E
#include	<sysArray.mqh>									//Pref:	A
#include	<sysDebug.mqh>
//--- Managers	--------------------------------------------

//.
	
//==========================================================
int Main(){//..
	/*
		>Ver:0.0.0
		>Date:
		>Hist:
		>Author: Morochin <artamir> Artiom
		>Desc:
			Must be called in begining of "start()" 
	*/
	
	//------------------------------------------------------
	T.Start();
	T.End();
}//.	