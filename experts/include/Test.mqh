	/*
		\version	0.1.5.20
		\date	:	2013.05.02			
		\author	:	Morochin <artamir> Artiom		
		>Rev:10
		>template: Mj.Mn.rev.local_inc
		>Rev: lastrevision //if this rev > lastrevision, local_inc = 1 + lastrevision = thisrev + rev = thisrev
		>Hist	:																																																																																																																	
					@0.1.5.20@2013.05.02@artamir	[]	
					@0.1.0.19@2013.05.02@artamir	[]	
					@0.1..018@2013.05.02@artamir	[]	
					@0.1..017@2013.05.02@artamir	[]	
					@0.1.16@2013.04.30@artamir	[]	CNV_Main
					@0.1.15@2013.04.30@artamir	[]	CNV_Main
					@0.1.14@2013.04.30@artamir	[]	CNV_Main
					@0.1.13@2013.04.30@artamir	[]	CNV_Main
					@0.1.12@2013.04.30@artamir	[]	FuncReturnInt
					@0.1.11@2013.04.30@artamir	[]	MyFunc
					@0.1.10@2013.04.30@artamir	[]	MyFunc
					@0.1.9@2013.04.30@artamir	[]	MyFunc
					@0.1.8@2013.04.30@artamir	[]	MyFunc
					@0.1.7@2013.04.30@artamir	[]	FuncReturnInt
					@0.1.6@2013.04.30@artamir	[]	FuncReturnInt
					@0.1.5@2013.04.30@artamir	[]	CNV_Main
					@0.1.4@2013.04.30@artamir	[]	CNV_Main

		>Desc	:	Менеджер аглоритмов сопровождения ордеров
		>Prefix	:	CNV
	*/

#define ELTVER "0.1.5.20_2013.05.02"	
	
#include <cOIW.mqh>											//OrdersInWindow Pref: OIW
	
int CNV_Main(int Myvar1 /*First param desc has symbol ,*/, double MyVar2
			,string MyVar3 = "Some text" /*third param*/,
			bool MyVar4 = false/*four param*/){
	/*
		>Ver	:	0.0.58
		>Date	:	2013.04.30
		>Hist	:																																		
					@0.0.58@2013.04.30@artamir	[]	CNV_Main
					@0.0.57@2013.04.30@artamir	[]	CNV_Main
					@0.0.56@2013.04.30@artamir	[]	CNV_Main
					@0.0.55@2013.04.30@artamir	[]	CNV_Main
					@0.0.54@2013.04.30@artamir	[]	CNV_Main
					@0.0.53@2013.04.30@artamir	[]	CNV_Main
					04.30@artamir	[]	CNV_Main
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
		>VARS	:
			@param int Myvar1		: First param\
				description multiline *!
			@param double MyVar2	: Second param single line description *!
	*/
	
	OIW.Main();
	
	//------------------------------------------------------
	return(0);
}

void MyFunc(){
	/**
		\version	0.0.9
		\date			2013.04.30
		\author		Morochin <artamir> Artiom
		\details		Must be called in begining of "start()" 
		\internal
					>Hist:					
							 @0.0.9@2013.04.30@artamir	[]	MyFunc
							 @0.0.8@2013.04.30@artamir	[]	MyFunc
							 @0.0.7@2013.04.30@artamir	[]	MyFunc
							 @0.0.6@2013.04.30@artamir	[]	MyFunc
							 @0.0.5@2013.04.17@artamir	[]	MyFuncf
							 
	*/
}

int FuncReturnInt(int IntVar /** Description of the param*/){
	/**
		\version	0.0.4
		\date		2013.04.30
		\author		Morochin <artamir> Artiom
		\details	Must be called in begining of "start()" 
		\internal
			>Hist:				
					 @0.0.4@2013.04.30@artamir	[]	FuncReturnInt
					 @0.0.3@2013.04.30@artamir	[]	FuncReturnInt
					 @0.0.2@2013.04.30@artamir	[]	FuncReturnInt
					 @0.0.1@2013.04.17@artamir	[]	FuncReturnInt
			>Rev:209M
		 
	*/

}