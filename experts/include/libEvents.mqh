/*
		>Ver	:	0.0.5
		>Date	:	2012.08.30
		>Hist:
			@0.0.4@2012.08.28@artamir	[]
			@0.0.3@2012.08.11@artamir	[*] libE.FillEvetnByCurIndex()
			@0.0.2@2012.08.10@artamir	[+] libE.setNewEventOnIndex()
			@0.0.1@2012.08.10@artamir	[+] libE.FillEventsArray()
		>Descr:
			Библиотека работы с событиями ордеров.
		>Зависимости:
			#include	<libArray.mqh>
			#include	<libTerminal.mqh>
*/

//.. //=== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ

	//.. //=== МАССИВ ОРДЕРОВ/СОБЫТИЙ
	#define	libE.E_TI	1	//Ticket 
	#define	libE.E_TY	2	//Type of event
	#define	libE.E_MAX	3	//Max index
	
	#define	libE.EVENT_NO	1	//EVENT_NewOrder
	#define	libE.EVENT_CHTY	2	//EVENT_CHangeTYpe
	#define	libE.EVENT_CHOP	3	//EVENT_CHangeOpenPrice
	#define libE.EVENT_CO	4	//EVENT_ClosedOrder
	//======================================
	double	libE.array_dOrdersEvents[][libE.E_MAX];
	//.

//.

//==================================================================================================
void libE.Start(){//..
	
	//----------------------------------------------------------------------------------------------
	libA.double_eraseArray2(libE.array_dOrdersEvents);		//обнуляем массив событий
	
	//----------------------------------------------------------------------------------------------
	libE.FillEventsArray();									//заполняем массив событий
}//.

//==================================================================================================
void libE.FillEventsArray(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.10
		>Hist:
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Заполнение массива событий ордеров.
	*/
	
	int	idx_1 = 0;
	
	//----------------------------------------------------------------------------------------------
	int CurRange = ArrayRange(libT.array_dCurOrders,0);
	int OldRange = ArrayRange(libT.array_dOldOrders,0);
	
	//----------------------------------------------------------------------------------------------
	for(int idxCur = 0; idxCur < CurRange; idxCur++){
		int CurTicket = libT.CurTicketByIndex(idxCur);
		
		//------------------------------------------------------------------------------------------
		libE.FillEvetnByCurIndex(idxCur);					//заполняем события по текущему индексу
	}
}//.

//==================================================================================================
void libE.FillEvetnByCurIndex(int idxCUR){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.28
		>Hist:
			@0.0.3@2012.08.28@artamir	[]
			@0.0.2@2012.08.11@artamir	[+] Добавлена обработка изменения типа ордера и изменения цены открытия. 
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Filling array of events of current order.
	*/
	
	int ROWS = ArrayRange(libE.array_dOrdersEvents, 0);		//count of rows of array
	int thisRow = ROWS;
	
	/*******************
	BP(		"libE.FillEvetnByCurIndex"
		,	"ROWS = ", ROWS);
	*/
	
	int curTicket = libT.CurTicketByIndex(idxCUR);			//get ticket of current order by index
	int idxOLD = libT.getOldIndexByTicket(curTicket);		//find index in array of old orders
	
	if(idxOLD <= -1){//..									//this is a new placed order.
		thisRow = libE.setNewEventOnIndex(thisRow,	curTicket, libE.EVENT_NO); //Возвращает новое количество строк
		
		libT.setExtraStandartData(curTicket);
	}//.
	
	//------------------------------------------------------
	if(idxOLD >= 0){//..									//this is an old order
	
		//..	//=== Change Type
		int	curType	=	libT.CurTypeByIndex(idxCUR);
		int oldType	=	libT.OldTypeByIndex(idxOLD);
		
		//--------------------------------------------------
		if(curType != oldType){
			thisRow = libE.setNewEventOnIndex(thisRow, curTicket, libE.EVENT_CHTY);
		}
		//.
		
		//..	//=== Change OpenPrice
		double	curOP	=	libT.CurOPByIndex(idxCUR);
		double	oldOP	=	libT.OldOPByIndex(idxCUR);
		
		//--------------------------------------------------
		if(curOP != oldOP){
			thisRow = libE.setNewEventOnIndex(thisRow, curTicket, libE.EVENT_CHOP);
		}
		//.
	
	}//.
	
	/*** BreackPoint
	BP(		"libE.FillEvetnByCurIndex"
		,	"curTicket = ", curTicket
		,	"idxOLD = ", idxOLD
		,	"libE.array_dOrdersEvents["+(thisRow-1)+"][E_TI] = ",libE.array_dOrdersEvents[thisRow-1][libE.E_TI]
		,	"libE.array_dOrdersEvents["+(thisRow-1)+"][E_TY] = ",libE.array_dOrdersEvents[thisRow-1][libE.E_TY]);
	*/	
}//.

//==================================================================================================
void libE.FillEvetnByOldIndex(int idxOLD){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.28
		>Hist:
			@0.0.3@2012.08.28@artamir	[]
			@0.0.2@2012.08.11@artamir	[+] Добавлена обработка изменения типа ордера и изменения цены открытия. 
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Filling array of events of current order.
	*/
	
	int ROWS = ArrayRange(libE.array_dOrdersEvents, 0);		//count of rows of array
	int thisRow = ROWS;
	
	/*******************
	BP(		"libE.FillEvetnByCurIndex"
		,	"ROWS = ", ROWS);
	*/
	
	int oldTicket = libT.OldTicketByIndex(idxOLD);			//get ticket of current order by index
	int idxCUR = libT.getCurIndexByTicket(oldTicket);		//find index in array of old orders
	
	if(idxCUR <= -1){//..									//this is a new placed order.
		thisRow = libE.setNewEventOnIndex(thisRow,	oldTicket, libE.EVENT_CO); //Возвращает новое количество строк
		
		libT.setExtraIsClosedByTicket(oldTicket);
	}//.
	
		
}//.

//==================================================================================================
int libE.setNewEventOnIndex(int idx, int ticket = 0, int Event = -1){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.08.10
		>Hist:
			@0.0.2@2012.08.10@artamir	[]
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Установка тикета и события по заданному индексу.
	*/
	if(ticket <= 0) return(idx);							//если тикет не задан, то выходим
	
	//----------------------------------------------------------------------------------------------
	int ROWS = ArrayRange(libE.array_dOrdersEvents, 0);		//Всего строк
	
	//----------------------------------------------------------------------------------------------
	if(idx >= ROWS){//..									//индекс больше чем максимальное количество строк
		ArrayResize(libE.array_dOrdersEvents, (ROWS+1));	//Добавили строку
	}//.
	
	//----------------------------------------------------------------------------------------------
	libE.array_dOrdersEvents[idx][libE.E_TI]	= ticket;
	libE.array_dOrdersEvents[idx][libE.E_TY]	= Event;
	
	//----------------------------------------------------------------------------------------------
	return(idx+1);
}//.