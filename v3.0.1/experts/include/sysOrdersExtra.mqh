	/*
		>Ver	:	0.0.4
		>Date	:	2012.10.03
		>Hist	:
			@0.0.4@2012.10.03@artamir	[]
			@0.0.3@2012.10.03@artamir	[]
			@0.0.2@2012.10.03@artamir	[]
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
//..	//=== ARRAY	========================================

//--- Main info
#define	OE_TI	0	//OrderTicket()
#define	OE_TY	1	//OrderType()
#define	OE_OP	2	//OrderOpenPrice()
#define	OE_OT	3	//OrderOpenTime()
#define	OE_TP	4	//OrderTakeProfit()
#define	OE_SL	5	//OrderStopLoss()
#define	OE_MN	6	//OrderMagicNumber()
#define	OE_LOT	7	//OrderLots()
//--- Aditional info
//------ Parents
#define	OE_MP		10	//Main parent of the grid
#define	OE_LP		11	//Local parent
//------ Partial close
#define	OE_FROM		15	//If was partial close 
//------ Grid
#define	OE_GT		20	//Grid type
#define	OE_GL		21	//Grid level
//------ First open data
#define	OE_FOP		25	//First open price
#define	OE_FOT		26	//First open type
#define	OE_FOL		27	//First open lot
//------ Other
#define	OE_OFF		35	//If expert do not work with this order
  

#define	OE_MAX	36
//----------------------------------------------------------
double	aOE[][OE_MAX];
//.	--------------------------------------------------------

//..	//=== PRIVATE

int	OE.findIndexByTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(aOE, 0);
	
	//------------------------------------------------------
	int idx = -1;
	
	//------------------------------------------------------
	bool isFind = false;
	
	//------------------------------------------------------
	while(!isFind && idx < ROWS){//..
		
		//--------------------------------------------------
		idx++;
		
		//--------------------------------------------------
		int aOE.TI = aOE[idx][OE_TI];
		
		//--------------------------------------------------
		if(aOE.TI == ticket){//..
			
			//----------------------------------------------
			isFind = true;
		}//.
	}//.
	
	//------------------------------------------------------
	if(!isFind){//..
	
		//--------------------------------------------------
		return(-1);
	}//.
	
	//------------------------------------------------------
	return(idx);
}//.--------------------------------------------------------

//.---------------------------------------------------------

//..	//=== ADD ROW


//.---------------------------------------------------------

//..	//=== GET

double	OE.getPropByIndex(int idx, int prop){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	//------------------------------------------------------
	if(idx <= -1){//..
		
		//--------------------------------------------------
		return(-1);
	}//.
	
	//------------------------------------------------------
	double val = aOE[idx][prop];
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

//..	//====== BY TICKET
int		OE.getTYByTicket(int ti){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE.findIndexByTicket(ti);
	
	//------------------------------------------------------
	int val = OE.getPropByIndex(idx, OE_TY);
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

double	OE.getOPByTicket(int ti){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE.findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE.getPropByIndex(idx, OE_OP);
	
	//------------------------------------------------------
	val = Norm.symb(val);
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

int		OE.getOTByTicket(int ti){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE.findIndexByTicket(ti);
	
	//------------------------------------------------------
	int val = OE.getPropByIndex(idx, OE_OT);
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

double	OE.getTPByTicket(int ti){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE.findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE.getPropByIndex(idx, OE_TP);
	
	//------------------------------------------------------
	val = Norm.symb(val);
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

double	OE.getSLByTicket(int ti){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE.findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE.getPropByIndex(idx, OE_SL);
	
	//------------------------------------------------------
	val = Norm.symb(val);
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

int		OE.getMNByTicket(int ti){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE.findIndexByTicket(ti);
	
	//------------------------------------------------------
	int val = OE.getPropByIndex(idx, OE_MN);
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

double	OE.getLOTByTicket(int ti){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE.findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE.getPropByIndex(idx, OE_LOT);
	
	//------------------------------------------------------
	val = Norm.vol(val);
	
	//------------------------------------------------------
	return(val);
}//.--------------------------------------------------------

//.---------------------------------------------------------

//.---------------------------------------------------------