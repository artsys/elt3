/*
		>Ver	:	0.0.21
		>Date	:	2012.10.22
		>Hist:
			@0.0.21@2012.10.22@artamir	[]
			@0.0.20@2012.10.15@artamir	[]
			@0.0.19@2012.10.15@artamir	[]
			@0.0.18@2012.10.15@artamir	[]
			@0.0.17@2012.10.01@artamir	[]
			@0.0.16@2012.10.01@artamir	[]
			@0.0.15@2012.10.01@artamir	[*] changed names of variables
			@0.0.14@2012.10.01@artamir	[]
			@0.0.13@2012.10.01@artamir	[]
			@0.0.12@2012.09.20@artamir	[]
			@0.0.11@2012.09.20@artamir	[]
			@0.0.9@2012.09.11@artamir	[]
			@0.0.8@2012.09.11@artamir	[]
			@0.0.7@2012.09.07@artamir	[]
			@0.0.6@2012.09.07@artamir	[*] getDeltaPriceFromTicket
			0.0.4: [+] checking if parent order is market.
		>Desc:
			Manager of STOPORDER Traling.
*/

extern string	SOT.Desc	= ">>>>> STOPORDER TRAL ========";
extern bool		SOT.UseStopOrdersTral = False;
extern int		SOT.StartPip	= 30;					//if price go in loss at 30 and over pips, we send stop order.
extern int		SOT.StepPip		= 10;					//if price go in loss at 30+10 pips we move stoporder at 10 pip
extern double	SOT.LotMultiply = 2;					// if parent.lot = 2 then child.lot = 4

#include "libSTOPTRAL.TP.mqh"
#include "mngSTOPTRAL.TP.mqh"

//----------------------------------------------------------
int libSOTr.Main(int PARENT_TI){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.01
		>Hist:
			@0.0.1@2012.10.01@artamir	[]
		>Desc:
	*/
	
	//------------------------------------------------------
	if(!SOT.UseStopOrdersTral) return;
	
	//------------------------------------------------------
	if(PARENT_TI <= 0){
		libSOTr.CircleOnParents();
	}else{
		//--------------------------------------------------
		libSOTr.CheckChildernsByParent(PARENT_TI);
	}
	
	//------------------------------------------------------
	// circle on this grid type orders
	libSOTr.CircleOnThisGTOrders();
	
	//------------------------------------------------------
	libSOTr.TP.Main();
	
	//------------------------------------------------------
	SOT.CL.MZR.Main();
}

//==========================================================
void libSOTr.CheckChildernsByParent(int parent.ticket){			//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.09.20
		>Hist:
			@0.0.2@2012.09.20@artamir	[]
			@0.0.1@2012.09.20@artamir	[]
		>Desc:
	*/
	//------------------------------------------------------
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	
	//------------------------------------------------------
	if(parent.type != OP_BUY && parent.type != OP_SELL){
		return;												// this parent order is pending.
	}
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	int CountOfChildren = libT.getOrdersByParent(parent.ticket, d);
	
	if(CountOfChildren <= 0){
		libSOTr.SendingChidrens(parent.ticket);
	}
	
	//------------------------------------------------------
	//libT.Start();											//reload array of current orders.
	
}															//.

//==========================================================
int libSOTr.SendingChidrens(int parent.ticket){//..
	/*
		>Ver	:	0.0.6
		>Date	:	2012.10.22
	>Hist:
			@0.0.6@2012.10.22@artamir	[]
			@0.0.5@2012.10.15@artamir	[]
			@0.0.4@2012.10.15@artamir	[]
			@0.0.3@2012.10.15@artamir	[]
			@0.0.2@2012.10.01@artamir	[]
			@0.0.1@2012.10.01@artamir	[*] changed names of variables
	*/
	
	double startPrice = libT.getExtraOPByTicket(parent.ticket);
	int addPip = SOT.StartPip;
	
	//------------------------------------------------------
	int parent.level	= libT.getExtraGLByTicket(parent.ticket);
	int parent.mp		= libT.getExtraMAINPARENTByTicket(parent.ticket);
	
	//------------------------------------------------------
	if(parent.mp <= 0){//..
		parent.mp = parent.ticket;
	}//.
	
	//------------------------------------------------------
	int priceZone = SOT.StartPip+SOT.StepPip;

	//------------------------------------------------------
	int deltaFromParent = libSOTr.getDeltaPriceFromTicket(int parent.ticket);
	
	//------------------------------------------------------
	if(-1 * deltaFromParent < priceZone) return(-1);				//we have no ability to send order.
	
	//------------------------------------------------------
	double lot = libSOTr.CalcLotByParent(parent.ticket);
	
	//------------------------------------------------------
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	
	//------------------------------------------------------
	int ticket = -1;
	
	//------------------------------------------------------
	if(parent.type == OP_BUY){//..
		startPrice = Bid;
	
		//--------------------------------------------------
		ticket = libO.SendBUYSTOP(startPrice, addPip, lot);
		
		//--------------------------------------------------
		int gt = GT.BSTR;
	}//.
	
	//------------------------------------------------------
	if(parent.type == OP_SELL){//..
		startPrice = Ask;
		
		//--------------------------------------------------
		ticket = libO.SendSELLSTOP(startPrice, addPip, lot);
		
		//--------------------------------------------------
		gt = GT.SSTR;
	}//.	
	
	//------------------------------------------------------
	if(ticket > 0){	//..
		
		//--------------------------------------------------
		libT.setExtraStandartData(ticket);
		
		//----------------------------------------------
		libT.setExtraMainParentByTicket(ticket, parent.mp);
		libT.setExtraParentByTicket(ticket, parent.ticket);
		libT.setExtraGridTypeByTicket(ticket, gt);
		libT.setExtraIsParentByTicket(ticket, 1);			//when pending children becames market order (BUY or SELL) it becames a parent order 
		libT.setExtraGLByTicket(ticket, parent.level+1);
	}//.

	//------------------------------------------------------
	return(ticket);
}//.

//==========================================================
void libSOTr.CheckAbilityToMove(int ticket){//..
	
	//------------------------------------------------------
	int		parent.ticket	= libT.getExtraPARENTByTicket(ticket);
	double	parent.op		= libT.getCurOPByTicket(parent.ticket);
	
	//------------------------------------------------------
	if(ticket == parent.ticket) return;
	
	//------------------------------------------------------
	if(libT.getExtraIsClosedTicket(ticket) >= 1) return;
	
	//------------------------------------------------------
	int deltaFromParent = libSOTr.getDeltaPriceFromTicket(int parent.ticket);

	//------------------------------------------------------
	int deltaFromTicket = libSOTr.getDeltaPriceFromTicket(int ticket);
	
	//------------------------------------------------------
	int priceZone = SOT.StartPip+SOT.StepPip;
	
	double op = libT.getExtraOPByTicket(ticket);
	//------------------------------------------------------
	if(deltaFromTicket > priceZone){//..					// we must move stoporder		
		
		int addPip = SOT.StartPip;
		double newOrderPrice = libSOTr.getPriceFromTicket(ticket, addPip); 
		
		//BP("libSOTr.CheckAbilityToMove","ticket = ", ticket, "deltaFromTicket = ", deltaFromTicket, "OP = ", op, "Bid = ", Bid, "Ask = ", Ask);
		//BP("libSOTr.CheckAbilityToMove","ticket = ", ticket, "newOrderPrice = ", newOrderPrice);
		//--------------------------------------------------
		libO.ModifyPrice(ticket, newOrderPrice);
	}//.
	
	//libT.Start();
}//.

//==========================================================
int libSOTr.getDeltaPriceFromTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.07
		>Hist:
			@0.0.1@2012.09.07@artamir	[*] changed geting info from array Cur to array Extra.
		>Desc:
	*/
	//------------------------------------------------------
	double	op		= libT.getExtraOPByTicket(ticket);
	int		type	= libT.getExtraTypeByTicket(ticket);
	
	//------------------------------------------------------
	double  thisPrice = libMI.getMarketClosePriceByCMD(type);
	
	//------------------------------------------------------
	if(type == OP_BUY){
		return((thisPrice - op)/Point);
	}
	
	//------------------------------------------------------
	if(type == OP_SELL){
		return((op-thisPrice)/Point);
	}
	
	//------------------------------------------------------
	if(type == OP_SELLSTOP){
		return((thisPrice-op)/Point);
	}
	
	//------------------------------------------------------
	if(type == OP_BUYSTOP){
		return((op-thisPrice)/Point);
	}
}//.

//==========================================================
double libSOTr.getPriceFromTicket(int ticket, int addPip = 0){//..
	
	//------------------------------------------------------
	int type = libT.getExtraTypeByTicket(ticket);
	
	//------------------------------------------------------
	double thisPrice = libMI.getMarketClosePriceByCMD(type);
	//BP("libSOTr.getPriceFromTicket","thisPrice = ", thisPrice, "addPip = ", addPip, "addPip*Point = "+addPip*Point);
	//------------------------------------------------------
	if(type == OP_SELLSTOP){
		return(libNormalize.Digits(thisPrice - addPip*Point));
	}
	
	//------------------------------------------------------
	if(type == OP_BUYSTOP){
		return(libNormalize.Digits(thisPrice + addPip*Point));
	}
}//.

//==========================================================
void libSOTr.CircleOnThisGTOrders(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.07
		>Hist:
			@0.0.1@2012.09.07@artamir	[]
	*/
	
	//--- BUYSTOP TRAL -------------------------------------
	int count = libT.getCountOrdersByGT(GT.BSTR);
	
	for(int idx = 0; idx < count; idx++){//..
		int ticket = libT.getTicketByGTAndIndex(GT.BSTR, idx);
		
		//--------------------------------------------------
		if(ticket <= 0) continue;
		
		//--------------------------------------------------
		if(libT.getExtraIsClosedTicket(ticket) >= 1) continue;	//Ордер закрыт
		
		//--------------------------------------------------
		libSOTr.CheckAbilityToMove(ticket);
	}//.
	
	//--- SELLSTOP TRAL -------------------------------------
	count = libT.getCountOrdersByGT(GT.SSTR);
	
	for(idx = 0; idx < count; idx++){//..
		ticket = libT.getTicketByGTAndIndex(GT.SSTR, idx);
		
		//--------------------------------------------------
		if(ticket <= 0) continue;
		
		//--------------------------------------------------
		libSOTr.CheckAbilityToMove(ticket);
	}//.
}//.

//==========================================================
void libSOTr.CircleOnParents(){//..
	/*
		>Ver:0.0.0
		>Date:
		>Hist:
		>Desc:
	*/
	//------------------------------------------------------
	double parents[][libT.OE_MAX];
	libT.SelectExtraParents(parents);

	//------------------------------------------------------
	int rows = ArrayRange(parents, 0);
	if(rows > 0){//..
		for(int idx = 0; idx < rows; idx++){//..
			int parent.ticket = parents[idx][libT.OE_TI];
			
			//----------------------------------------------
			libSOTr.CheckChildernsByParent(parent.ticket);
			
		}//.
	}//.
}//.

//==========================================================
double libSOTr.CalcLotByParent(int parent.ticket){//..
	double parent.lot = libT.getExtraLotByTicket(parent.ticket);
	
	//------------------------------------------------------
	return(parent.lot * SOT.LotMultiply);
}//.
