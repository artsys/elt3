/*	
		\version	0.1.14
		\date		2013.04.16
		\details
			ѕомошник реализации различных стратегий сопровождени€ открытых позиций
			»м€ файла дл€ сохранени€ массива array_dExtraOrders[][]:
			»м€Ёксперта.—чет.ѕара.extra.arr
		\internal
			History:									
					@0.1.3@2013.02.21@artamir	[*] aoPB2MA: трейлинг отложенных ордеров по их ма, выставление тп и сл	
					@0.1.2@2013.02.19@artamir	[]	start
*/	

#define	EXP	"PB2MA"
#define	VER	"0.1.14_2013.04.16"
//...	@VARS
string	fnExtra	= ""	;	//Filename for array storage

//----------------------------------------------------------
bool	isStart = true	;	//Flag for control first run of the expert
int		CircleCount = 0	;	//Count of incoming ticks

extern  bool 	Debug	= false;
extern bool	BP_Trades 	= false;
extern bool BP_Like		= false;
extern bool	BP_OE 		= false;
extern bool	BP_PB2MA	= false;
extern bool BP_LOA	 	= false;
extern bool BP_DelUnused 	= false;
extern bool	BP_Array	= false;
extern bool BP_Events_NEW 	= false;
extern bool BP_Events_CL 	= false;
extern bool BP_Events_CHOP 	= false;
extern bool BP_Events_CHSL 	= false;
extern bool BP_Events_CHTY 	= false;
extern bool BP_AOM		= false;
extern bool BP_Terminal = false;


//.

//==========================================================
#include	<sysELT3.mqh>

#include	<sysSignals.mqh>
#include	<sysAOM.mqh>

//==========================================================
int init(){
	
	fnExtra = getExtraFN();

	
	//------------------------------------------------------
	ELT_init(fnExtra);
}

//==========================================================
int deinit(){
	ELT_deinit(fnExtra);
}

//==========================================================
int start(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>History:
			@0.0.1@2012.10.02@artamir	[]
		>Description:
			start function of EA_
	*/
	
	Comment(	"EXP ver: "	,VER	,"\n"
			,	"Sys ver: "	,ELTVER	,"\n"
			,	"CircleCount: "	,CircleCount	,"\n"
			,	"OH: "	,ArrayRange(aOE,0)	,"\n"
			,	"16/64 Signal = ", SG_PB2MA_Get(16, 64, Close[1])	,"\n"
			,	"64/256 Signal = ", SG_PB2MA_Get(64, 256, Close[1])	,"\n"
			,	"256/1048 Signal = ", SG_PB2MA_Get(256, 1048, Close[1])	,"\n");
	
	//------------------------------------------------------
	if(isStart) isStart = false;

	CircleCount++;
	
	/* if(CircleCount == 7){
		TR_SendBUY();
	}
	
	if(CircleCount == 10){
		TR_CloseByTicket(1);
	} 
	*/
	//------------------------------------------------------
	Main();													//called from sysELT3
	AOM_Main();
	
	OE_eraseArray();
	//------------------------------------------------------
	//mngAO_Main();											//Main function of autoopen manager.
	
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
	
	string fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"ExtrA_arr";

	//------------------------------------------------------
	return(fn);
}

//==========================================================
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
