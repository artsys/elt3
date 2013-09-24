	/**
		\version	0.0.0
		\date		2013.04.19
		\author		Morochin <artamir> Artiom
		\details	Manager of Autoopen methods
		\internal
			>Hist:
	*/


//{ //=== PB2MA	
#define	AOM_PB2MA	20
#define	AOM_PB2MA1_B	21
#define	AOM_PB2MA2_B	22
#define	AOM_PB2MA3_B	23
#define	AOM_PB2MA1_S	26
#define	AOM_PB2MA2_S	27
#define	AOM_PB2MA3_S	28	

#include <aoPB2MA.mqh>
//}

//{ //=== BUYSTOP/SELLSTOP
#define AOM_BSSS_BS		34
#define AOM_BSSS_SS		35	
//}	
	
void AOM_Main(){
	/**
		\version	0.0.0
		\date		2013.04.19
		\author		Morochin <artamir> Artiom
		\details	Main function of this manager
		\internal
			>Hist:
	*/
	
	AO_PB2MA_Main();										//Price between 2 MA		
}

int AOM_getOrdersByMethod(double	&d[][]	/* destination array*/
						,	int		method	/*method of opening*/
						,	int		lastOpenInMin = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.25
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	A_eraseFilter();											//1
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_AOM, method, -1, AS_OP_EQ);
	
	if(lastOpenInMin > -1){
		A_FilterAdd_AND(OE_FOT, (Time[0]-lastOpenInMin*60), Time[-1], AS_OP_IN);
	}
	
	A_d_Select(aOE, d);
	
	if(Debug && BP_AOM){
		A_d_PrintArray2(d, 4, "SelectByMethod"+method);
	}
}

