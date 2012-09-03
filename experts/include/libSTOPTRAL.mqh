/*
		>Ver	:	0.0.5
		>Date	:	2012.08.30
		>Hist:
			0.0.4: [+] checking if parent order is market.
		>Desc:
			Manager of STOPORDER Traling.
*/

extern bool		libSOTr.UseStopOrdersTral = False;
extern int		libSOTr.StartPip	= 30;					//if price go in loss at 30 and over pips, we send stop order.
extern int		libSOTr.StepPip		= 10;					//if price go in loss at 30+10 pips we move stoporder at 10 pip
extern double	libSOTr.LotMultiply = 2;					// if parent.lot = 2 then child.lot = 4

#include <libSTOPTRAL.TP.mqh>

//----------------------------------------------------------
int libSOTr.Main(int PARENT_TI){//..
	//------------------------------------------------------
	if(!libSOTr.UseStopOrdersTral) return;
	
	//------------------------------------------------------
	if(PARENT_TI <= 0){//..
		libSOTr.CircleOnParents();
	}else{
		//--------------------------------------------------
		libSOTr.CheckChildernsByParent(PARENT_TI);
	}//.
	
	//------------------------------------------------------
	// circle on this grid type orders
	libSOTr.CircleOnThisGTOrders();
	
	//------------------------------------------------------
	libSOTr.TP.Main();
}//.

//==========================================================
void libSOTr.CheckChildernsByParent(int parent.ticket){			//..
	
	//------------------------------------------------------
	int parent.type = libT.getCurTypeByTicket(parent.ticket);
	
	//------------------------------------------------------
	if(parent.type != OP_BUY && parent.type != OP_SELL){
		return;												// this parent order is pending.
	}
	
	//------------------------------------------------------
	int CountOfChildren = libT.getCountOrdersByParent(parent.ticket);
	
	if(CountOfChildren <= 0){
		libSOTr.SendingChidrens(parent.ticket);
	}
	
	//------------------------------------------------------
	libT.Start();											//reload array of current orders.
	
}															//.

//==========================================================
int libSOTr.SendingChidrens(int parent.ticket){//..
	
	double startPrice = libT.getCurOPByTicket(parent.ticket);
	int addPip = libSOTr.StartPip;
	
	//------------------------------------------------------
	int priceZone = libSOTr.StartPip+libSOTr.StepPip;
	
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
	}//.
	
	//------------------------------------------------------
	if(parent.type == OP_SELL){//..
		startPrice = Ask;
		
		//--------------------------------------------------
		ticket = libO.SendSELLSTOP(startPrice, addPip, lot);
	}//.	
	
	//------------------------------------------------------
	if(ticket > 0){	//..
		
		//------------------------------------------
		if(libT.getExtraIndexByTicket(ticket) <= -1){//..
	
			//----------------------------------------------
			int idx_extra = libT.addExtraTicket(ticket);	//Adding new element in extra array
			
			//----------------------------------------------
			libT.setExtraMAINPARENTByIndex(idx_extra, parent.ticket);
			libT.setExtraPARENTByIndex(idx_extra, parent.ticket);
			libT.setExtraGridTypeByIndex(idx_extra, GT.SSTR);
			libT.setExtraIsParentByIndex(idx_extra, 1);		//when pending children becames market order (BUY or SELL) it becames a parent order 
		}//.
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
	int deltaFromParent = libSOTr.getDeltaPriceFromTicket(int parent.ticket);

	//------------------------------------------------------
	int deltaFromTicket = libSOTr.getDeltaPriceFromTicket(int ticket);
	
	//------------------------------------------------------
	int priceZone = libSOTr.StartPip+libSOTr.StepPip;
	
	//------------------------------------------------------
	if(deltaFromTicket > priceZone){//..					// we must move stoporder
		
		int addPip = libSOTr.StartPip;
		double newOrderPrice = libSOTr.getPriceFromTicket(ticket, addPip); 
		
		//--------------------------------------------------
		libO.ModifyPrice(ticket, newOrderPrice);
	}//.
	
	libT.Start();
}//.

//==========================================================
int libSOTr.getDeltaPriceFromTicket(int ticket){//..
	
	//------------------------------------------------------
	double	op		= libT.getCurOPByTicket(ticket);
	int		type	= libT.getCurTypeByTicket(ticket);
	
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
double libSOTr.getPriceFromTicket(int ticket, int addPip){//..
	
	//------------------------------------------------------
	int type = libT.getCurTypeByTicket(ticket);
	
	//------------------------------------------------------
	double thisPrice = libMI.getMarketClosePriceByCMD(type);
	
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
	
	//--- BUYSTOP TRAL -------------------------------------
	int count = libT.getCountOrdersByGT(GT.BSTR);
	
	for(int idx = 0; idx < count; idx++){//..
		int ticket = libT.getTicketByGTAndIndex(GT.BSTR, idx);
		
		//--------------------------------------------------
		if(ticket <= 0) continue;
		
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
	
	//------------------------------------------------------
	double parents[][libT.OE_MAX];
	libT.SelectExtraParents(parents);

	
	//------------------------------------------------------
	int rows = ArrayRange(parents, 0);
	if(rows > 0){//..
		for(int idx = 0; idx < rows; idx++){//..
			int parent.ticket = parents[idx][libT.OE_TI];
			
			//----------------------------------------------
			//Alert("parent.ticket = ", parent.ticket);
			libSOTr.CheckChildernsByParent(parent.ticket);
		}//.
	}//.
}//.

//==========================================================
double libSOTr.CalcLotByParent(int parent.ticket){//..
	double parent.lot = libT.getExtraLotByTicket(parent.ticket);
	
	//------------------------------------------------------
	return(parent.lot * libSOTr.LotMultiply);
}//.
