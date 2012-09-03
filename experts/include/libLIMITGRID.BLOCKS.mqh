/*
		>Ver	:	0.0.1
		>Date	:	2012.08.23
		>Hist:
			@0.0.1@2012.08.23@artamir	[]
		>Desc:
			Настройка и выставление сетки лимитных ордеров
			разбитой на блоки ордеров.
			Setup and sending drid of limit orders, 
			divided on blocks
		>Links to:
			#include <libConvoy.mqh>
			#include <libCalculations.mqh>
			#include <libTerminal.mqh>
*/

extern	bool	libLGB.UseBlocs	=	false;					//Use blocks of limit orders
extern	int		libLGB.Block1.Count		=	5;				//Count orders in block
extern	int		libLGB.Block1.StartStep	=	10;				//Distance between parent and first order in block
extern	int		libLGB.Block1.OrderStep	=	15;				//Distance between orders inside block.

//=== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ================================
//..	//=== МАССИВ КОНТРОЛЯ ЛИМИТНЫХ БЛОК СЕТОК 
	#define	libLGB.BG_PA	1								// Parent
	#define	libLGB.BG_CURL	2								// Curent sended level.
	#define	libLGB.BG_MAX	5
	double	libLGB.array_dBLOCKGRID[][libLGB.BG_MAX];
//.

//=== INCLUDE ==============================================
//..
	#include <libLIMITGRID.BLOCKS.TP.mqh>					// library to work work with takeprofit on blocks of orders	
//.

//===	МАССИВ array_dBLOCKGRID	============================
//..

int libLGB.setBGProbByIndex(int IDX, int PROP, double VAL){//..
	libLGB.array_dBLOCKGRID[IDX][PROP] = VAL;
}//.

//==========================================================
int libLGB.addBGPARENT(int parent = -1){//..
	if(parent <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int ROWS	= ArrayRange(libLGB.array_dBLOCKGRID, 0);	// Количество строк в массиве
	
	//------------------------------------------------------
	int thisIDX	= ROWS;
	
	//------------------------------------------------------
	ArrayResize(libLGB.array_dBLOCKGRID, (ROWS+1));
	
	//------------------------------------------------------
	libLGB.setBGProbByIndex(thisIDX, libLGB.BG_PA, parent);
	
	//------------------------------------------------------
	return(thisIDX);
}//.
//.

//==========================================================
void libLGB.Main(int PARENT_TI){//..
	/*
		>Ver	:	0.0.0
		>Date	:	2012.07.31
		>Hist:
		>Desc:
			Настройка и выставление сетки лимитных ордеров
			разбитой на блоки ордеров.
	*/

	if(!libLGB.UseBlocs){
		return;
	}
	
	//------------------------------------------------------
	libLGB.SendBlock(PARENT_TI, 5, 20, 10);
}//.

//==========================================================
void libLGB.SendBlock(int PARENT_TI, int COUNT, int StartStep, int OrderStep){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.23
		>Hist:
			@0.0.1@2012.08.23@artamir	[]
		>Desc:
			Настройка и выставление сетки лимитных ордеров
			разбитой на блоки ордеров.
	*/
	
	int	MAINPARENT	=	libT.getExtraMAINPARENTByTicket(PARENT_TI);
	
	//------------------------------------------------------
	double StartPrice	=	libT.getCurOPByTicket(PARENT_TI);
	
	//------------------------------------------------------
	//double	block.lot = libCALC.LotMultiplyByTicket(PARENT_TI);
	
	//------------------------------------------------------
	for(int iter = 1; iter <= COUNT; iter++){				//..
		
		//--------------------------------------------------
		int addPip = iif(iter == 1, StartStep, OrderStep);
		
		//--------------------------------------------------
		int ticket = libO.SendBUYLIMIT(StartPrice, addPip);	//Sending limit order
		
		//--------------------------------------------------
		libT.FillArrayCurOrders();							//reload array of current orders.
		
		//--------------------------------------------------
		if(libT.getExtraIndexByTicket(ticket) <= -1){		//..
			
			//----------------------------------------------
			int idx_extra = libT.addExtraTicket(ticket);	//Adding new element in extra array
			
			//----------------------------------------------
			libT.setExtraMAINPARENTByIndex(idx_extra, MAINPARENT);
			libT.setExtraPARENTByIndex(idx_extra, PARENT_TI);
			libT.setExtraGridTypeByIndex(idx_extra, GT.BLB);
		}													//.
		
		//--------------------------------------------------
		StartPrice = libT.getCurOPByTicket(ticket);			//get open price from current sended order.
	}														//.
	
	double d[][libT.OE_MAX];
	
	
	int f.COL = libT.OE_PARENT;
	int f.MAX = libNormalize.Digits(PARENT_TI);
	int f.MIN = libNormalize.Digits(PARENT_TI);
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	f.COL = libT.OE_GRIDTYPE;
	f.MAX = GT.BLB;
	f.MIN = GT.BLB;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//return array of selected rows by filter.
	
	//------------------------------------------------------
	
}//.

//==========================================================