	/*
		>Ver	:	0.0.5
		>Date	:	2012.11.12
		>Hist	:
			@0.0.5@2012.11.12@artamir	[]
			@0.0.4@2012.11.12@artamir	[]
			@0.0.3@2012.11.12@artamir	[]
			@0.0.2@2012.11.12@artamir	[]
			@0.0.1@2012.11.09@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Convoy on breack ZZ extrem
	*/
	
	extern string	SOZZ.Str = ">>>>>  CONVOY ON ZZ EXTREM";
	extern bool		SOZZ.Use = false;							//USE this convoy
	extern int		SOZZ.ZZDepth = 12;
	extern double	SOZZ.LotMultiply = 2;
	
	//------------------------------------------------------
	int SOZZ.Main(int Parent = -1){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.09
		>Hist	:
			@0.0.1@2012.11.09@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		if(!SOZZ.Use){
			return(0);
		}
		
		double d[][libT.OE_MAX];
		
		//..	BYUSTOP
			int ROWS = CY.selectOByGT(d, GT.BSZZ, libT.OE_TY, ">=", 2);
		
			//----------------------------------------------
			if(ROWS >= 1){//..
				SOZZ.CheckOnDownZZ(d);
			}//.
			
		//.

		//..	SELLSTOP
			ROWS = CY.selectOByGT(d, GT.SSZZ, libT.OE_TY, ">=", 2);
		
			//----------------------------------------------
			if(ROWS >= 1){//..
				SOZZ.CheckOnUPZZ(d);
			}//.
			
		//.
		
		//..	OPEN STOP ORDERS
			SOZZ.CheckChildrens();
		//.
		
		libSOTr.TP.Main();
		
	}//.
	
	
	int SOZZ.CheckOnDownZZ(double &d[][]){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		double zzD = libI_ZZ.GetZZExtrDWByNum	(1 ,"" ,0 ,12 ,5 ,3 ,1);
		
		int ROWS = ArrayRange(d, 0);
		
		for(int idx = 0; idx < ROWS; idx++){//..
			int ti = d[idx][libT.OE_TI];
			int ty = d[idx][libT.OE_TY];
			
			//----------------------------------------------
			if(ty <= 1){//..
				continue;
			}//.
			
			libO.ModifyPrice(ti, zzD, libO.MODE_PRICE);
		}//.
		
	}//.
	
	int SOZZ.CheckOnUPZZ(double &d[][]){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		double zzU = libI_ZZ.GetZZExtrUPByNum	(1 ,"" ,0 ,12 ,5 ,3 ,1);
		
		int ROWS = ArrayRange(d, 0);
		
		for(int idx = 0; idx < ROWS; idx++){//..
			int ti = d[idx][libT.OE_TI];
			int ty = d[idx][libT.OE_TY];
			
			//----------------------------------------------
			if(ty <= 1){//..
				continue;
			}//.
			
			libO.ModifyPrice(ti, zzU, libO.MODE_PRICE);
		}//.
		
	}//.
	
	int SOZZ.CheckChildrens(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/


		double d[][libT.OE_MAX];
		int ROWS = libT.SelectExtraParents(d);
		
		if(ROWS >= 1){//..
			
			SOZZ.CircleOnParents(d);
		}//.			
	}//.
	
	int SOZZ.CircleOnParents(double &d[][]){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		int ROWS = ArrayRange(d, 0);
		
		if(ROWS <= 0){//..
			return(0);
		}//.
		
		for(int idx = 0; idx < ROWS; idx++){//..
			int parent.ti = d[idx][libT.OE_TI];
			int parent.ty = d[idx][libT.OE_TY];
			
			int GT = -1;
			if(parent.ty == OP_BUY){
				GT = GT.BSZZ;
			}
			
			if(parent.ty == OP_SELL){
				GT = GT.SSZZ;
			}
			
			SOZZ.CheckChildrenOnParent(parent.ti, parent.ty, GT);
		}//.
	}//.
	
	int SOZZ.CheckChildrenOnParent(int parent.ti, int parent.ty, int GT){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		
		int parent.level	= libT.getExtraGLByTicket(parent.ti);
		int parent.mp		= libT.getExtraMAINPARENTByTicket(parent.ti);
		
		double d[][libT.OE_MAX];
		int ROWS = libT.getOrdersByParent(parent.ti, d);
		
		double lot = SOZZ.CalcLotByParent(parent.ti);
	
		if(parent.ty == OP_BUY){//..
			
			double ZZU = libI_ZZ.GetZZExtrUPByNum(2 ,"" ,0 ,12 ,5 ,3 ,1);
			if(ROWS <= 0)
				int ti = libO.SendBUYSTOP(ZZU, 0, lot);
		}//.
		
		if(parent.ty == OP_SELL){//..
			
			double ZZD = libI_ZZ.GetZZExtrDWByNum(2 ,"" ,0 ,12 ,5 ,3 ,1);
			
			if(ROWS <= 0)
				ti = libO.SendSELLSTOP(ZZD, 0, lot);
		}//.
		
		if(ti > 0){//..
			//--------------------------------------------------
			libT.setExtraStandartData(ti);
			
			//----------------------------------------------
			libT.setExtraMainParentByTicket(ti, parent.mp);
			libT.setExtraParentByTicket(ti, parent.ti);
			libT.setExtraGridTypeByTicket(ti, GT);
			libT.setExtraIsParentByTicket(ti, 1);			//when pending children becames market order (BUY or SELL) it becames a parent order 
			libT.setExtraGLByTicket(ti, parent.level+1);
		}//.
		
	}//.
	
	//==========================================================
double SOZZ.CalcLotByParent(int parent.ticket){//..
	double parent.lot = libT.getExtraLotByTicket(parent.ticket);
	
	//------------------------------------------------------
	return(parent.lot * SOZZ.LotMultiply);
}//.
