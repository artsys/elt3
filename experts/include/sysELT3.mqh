	/*
		>Ver	:	0.1.0.40
		>Date	:	2013.05.15
		>Hist:																	
				 @0.1.0.40@2013.05.15@artamir	[]	Main
				 @0.1.0.39@2013.05.14@artamir	[+] sysOrderInfo	
				 @0.1.0.38@2013.05.07@artamir	[]	Main
				 @0.1.37@2013.04.25@artamir	[]	
				 @0.1.36@2013.04.25@artamir	[*] sysTrades	
				 @0.1.34@2013.04.16@artamir	[*] sysELT3	
				 @0.1.32@2013.03.06@artamir	[*] sysEvents	
				 @0.1.31@2013.03.06@artamir	[*] sysArray	
				 @0.1.30@2013.03.04@artamir	[]	
				 @0.1.29@2013.02.26@artamir	[]	ELT_init
				 @0.1.28@2013.02.26@artamir	[]	
				 @0.1.27@2013.02.26@artamir	[*] sysTrades	
				 @0.1.25@2013.02.23@artamir	[*] sysArray	
				 @0.1.24@2013.02.22@artamir	[*] sysTrades: Добавлена функция открытия реверсного ордера.	
				 @0.1.23@2013.02.22@artamir	[*] sysOrdersExtra	
				 @0.1.22@2013.02.22@artamir	[*] sysTrades, 	
				 @0.1.21@2013.02.22@artamir	[*] sysArray исправлена инициализация массива-фильтра в A_d_Select	
				 @0.1.20@2013.02.21@artamir	[*] sysOrdersExtra	
				 @0.1.19@2013.02.21@artamir	[*] 	
				 @0.1.18@2013.02.21@artamir	[*] sysOrdersExtra - Исправлено определение статуса ордера OE_IT	
				 @0.1.17@2013.02.20@artamir	[*] sysArray - Исправлена функция Select	
				 @0.1.16@2013.02.20@artamir	[]	
				 @0.1.15@2013.02.20@artamir	[*] sysArray	
				 @0.1.14@2013.02.19@artamir	[]	
				 @0.1.13@2013.02.16@artamir	[]	
		>Author: Morochin <artamir> Artiom
		>Desc:
			Base includE_
			Manager for system include files.
		>Pref:
			non
		>Warning:
			DO NOT CHANGE!!!!
	*/

#define	ELTVER	"0.1.0.40_2013.05.15"
#define ELTREV	"$rev$"	
//...	//Include	========================================

//..	@System	--------------------------------------------
#include	<WinUser32.mqh>
//----------------------------------------------------------
#include	<sysNormalize.mqh>								//Pref: Norm
#include	<sysStructure.mqh>								//Pref: Struc
#include	<sysMarketInfo.mqh>								//Pref:	MI
#include	<sysOrderInfo.mqh>								//Pref:	OI
//----------------------------------------------------------
#include	<sysArray.mqh>									//Pref:	A
#include	<sysDebug.mqh>
#include	<sysOrdersExtra.mqh>							//Pref:	OE
#include	<sysSQLite.mqh>									//Pref: SQL
#include	<sysTerminal.mqh>								//Pref: T
#include	<sysEvents.mqh>									//Pref:	E
//.. 	@Trades	--------------------------------------------
#include	<sysTrades.mqh>									//Pref:	TR
//..	@Indicators
#include	<iMA.mqh>										//Pref: iMA
//}

int Main(){
	/**
		\brief		Основная функция 
		\version	0.0.0.3
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details		Must be called in begining of "start()" 
		\internal
					>Hist:		
							 @0.0.0.3@2013.05.15@artamir	[]	Main
							 @0.0.0.2@2013.05.07@artamir	[]	Main
						@0.0.1@2012.10.04@artamir	[]
	*/
	//------------------------------------------------------
	T_Start();
	T_End();
	
	SQL_Main();
}

int ELT_init(string fn){
	/**
		\version	0.0.2
		\date		2013.02.26
		\author		Morochin <artamir> Artiom
		\details		import array aOE from file
		\internal
			>Hist:
				@0.0.2 - changed name
	*/
	
	//------------------------------------------------------
	SQL_Init();
	
	A_d_ReadFromFile2(aOE, fn);
	
	OE_RecheckStatuses();
}

int ELT_deinit(string fn){
	/**
		\version	0.0.2
		\date
		\author		Morochin <artamir> Artiom
		\details	export array aOE to filE_
		\internal
			>Hist:
				@0.0.2 - changed name
	*/
	
	SQL_Deinit();
	
	//------------------------------------------------------
	A_d_SaveToFile2(aOE, fn, 8);
}	