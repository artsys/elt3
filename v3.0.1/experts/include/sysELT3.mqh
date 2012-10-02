	/*
		>Ver:0.0.0
		>Date:
		>Hist:
		>Author: Morochin <artamir> Artiom
		>Desc:
			Base include.
			Manager for system include files.
		>Pref:
			non
		>Warning:
			DO NOT CHANGE!!!!
	*/

//==========================================================
//..	//Include

//--- System	--------------------------------------------
#include	<WinUser32.mqh>
//----------------------------------------------------------
#include	<sysTerminal.mqh>								//Pref: T
//#include	<sysEvents.mqh>									//Pref:	E
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