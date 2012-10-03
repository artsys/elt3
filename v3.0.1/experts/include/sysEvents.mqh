/*
		>Ver	:	0.0.3
		>Date	:	2012.10.03
		>Hist:
			@0.0.3@2012.10.03@artamir	[]
			@0.0.2@2012.10.03@artamir	[]
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Descr:
			Working with orders events.
		>Pendings:
			#include	<libArray.mqh>
			#include	<libTerminal.mqh>
		>Pref:	E	
*/

//..	//=== GLOBAL VARIABLES

//..	//====== ћј——»¬ ќ–ƒ≈–ќ¬/—ќЅџ“»…
	#define	E_TI	1	//Ticket 
	#define	E_EVENT	2	//Type of event
	#define	E_MAX	3	//Max index
	
	#define	EVENT_NO	1	//EVENT_NewOrder
	#define	EVENT_CHTY	2	//EVENT_CHangeTYpe
	#define	EVENT_CHOP	3	//EVENT_CHangeOpenPrice
	#define EVENT_CO	4	//EVENT_ClosedOrder
	//======================================================
	double	aEvents[][E_MAX];								// array of events
//.		----------------------------------------------------

//.		----------------------------------------------------

//==========================================================
void E.Start(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Start func.
	*/
	//----------------------------------------------------------------------------------------------
	A.d.eraseArray2(aEvents);								
	
	//----------------------------------------------------------------------------------------------
	E.FillEventsArray();									
}//.

//==========================================================
void E.FillEventsArray(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Filling array of events
		>Pendings	: 
						#include <sysTerminal.mqh>
	*/
	
	//------------------------------------------------------
	int cur.ROWS = T.CurRows();
	int old.ROWS = T.OldRows();
	
	//------------------------------------------------------
	//checking for new orders
	for(int cur.idx = 0; cur.idx < cur.ROWS; cur.idx++){//..
	
		//--------------------------------------------------
		int	cur.ti	=	T.CurTicketByIndex(cur.idx);
		
		//--------------------------------------------------
		int	old.idx	=	T.OldIndexByTicket(cur.ti);
		
		//--------------------------------------------------
		//--- onNewOrder
		if(old.idx <= -1){//..								// this is new order
			
			//----------------------------------------------
			onNewOrder(cur.ti);
		}//.
		
		//--------------------------------------------------
		if(old.idx >= 0){//..
			
			//----------------------------------------------
			//..	//--- onChangeType
			int cur.ty = T.CurTypeByIndex(cur.idx);
			int old.ty = T.OldTypeByIndex(old.idx);
			
			//----------------------------------------------
			if(cur.ty != old.ty){//..
				onChangeType(cur.ti, cur.ty, old.ty);
			}//.
			//.---------------------------------------------
		
		}//.
	}//.
}//.--------------------------------------------------------

//..	//=== onEvents	====================================

void onNewOrder(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	//TODO: написать обработчик нового ордера.
	//1.добавление в массив екстраордеров
	//2.заполнение стандартных свойств ≈кстраќрдера
	//3.добавление нового событи€ в массив событий
}//.--------------------------------------------------------

void onChangeType(int ticket, int ty.new, int ty.old = -1){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	//TODO: написать обработчик изменени€ типа ордера.
	//1.добавление в массив екстраордеров
	//2.заполнение стандартных свойств ≈кстраќрдера
	//3.добавление нового событи€ в массив событий
}//.--------------------------------------------------------

void onCloseOrder(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	//TODO: написать обработчик закрытого ордера.
	//1.обновление статуса IsClosed массива экстраордеров.
	//2.добавление нового событи€ в массив событий
}//.--------------------------------------------------------


//.	--------------------------------------------------------
