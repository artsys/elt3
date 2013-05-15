	/**
		\version	0.0.0.6
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	
		\internal
			>Hist:						
					 @0.0.0.6@2013.05.15@artamir	[]	OI_ProfitInPipsBySelected
					 @0.0.0.5@2013.05.14@artamir	[]	OI_CloseMethodBySelected
					 @0.0.0.4@2013.05.14@artamir	[]	OI_isWorkedBySelected
					 @0.0.0.3@2013.05.14@artamir	[]	OI_isClosedBySelected
					 @0.0.0.2@2013.05.14@artamir	[]	OI_isMarketByType
					 @0.0.0.1@2013.05.14@artamir	[+]	OI_isPendingByType
			>Rev:0
	*/

bool OI_isPendingByType(int type){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	O_isPendingByType
			>Rev:0
	*/

	if(type <= 1){
		return(false);
	}
	
	return(true);
}

bool OI_isMarketByType(int type){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.1@2013.05.14@artamir	[]	OI_isPendingByType
					 @0.0.0.1@2013.05.14@artamir	[]	O_isPendingByType
			>Rev:0
	*/

	if(type <= 1){
		return(true);
	}
	
	return(false);
}

bool OI_isClosedBySelected(){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	OI_isClosedBySelected
			>Rev:0
	*/

	if(OrderCloseTime() > 0){
		return(true);
	}
	
	return(false);
}

bool OI_isWorkedBySelected(){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Возвращает true если ордер не был закрыт или удален.
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	OI_isWorkedBySelected
			>Rev:0
	*/

	if(OI_isClosedBySelected()){
		return(false);
	}
	
	return(true);
}

#define OI_CM_Market	0			//Закрытие с рынка
#define OI_CM_TP		1			//Закрытие по тп
#define OI_CM_SL		2			//Закрытие по sl
#define OI_CM_DEL		3			//Удаление отложенного ордера.
#define OI_CM_IW		100			//Ордер рабочий (т.е. еще в рынке)
int OI_CloseMethodBySelected(){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	OI_CloseMethodBySelected
			>Rev:0
	*/

	if(OrderCloseTime() <= 0){
		return(OI_CM_IW);
	}
	
	if(OrderType() >= 2){
		return(OI_CM_DEL);
	}
	
	if(Norm_symb(OrderClosePrice()) == Norm_symb(OrderTakeProfit())){
		return(OI_CM_TP);
	}
	
	if(Norm_symb(OrderClosePrice()) == Norm_symb(OrderStopLoss())){
		return(OI_CM_SL);
	}
	
	return(OI_CM_Market);
	
}

int OI_ProfitInPipsBySelected(){
	/**
		\version	0.0.0.1
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.15@artamir	[]	OI_ProfitInPipsBySelected
			>Rev:0
	*/

	int pips = 0;
	
	if(OI_isPendingByType(OrderType())) return(0);
	
	//-------------------------------------
	pips = (OrderClosePrice()-OrderOpenPrice())/Point;

	return(pips);	
}