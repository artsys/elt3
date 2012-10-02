/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Descr:
			Working with orders events.
		>Pendings:
			#include	<libArray.mqh>
			#include	<libTerminal.mqh>
		>Pref:	E	
*/

//.. //=== GLOBAL VARIABLES

	//.. //=== ������ �������/�������
	#define	E_TI	1	//Ticket 
	#define	E_EVENT	2	//Type of event
	#define	E_MAX	3	//Max index
	
	#define	EVENT_NO	1	//EVENT_NewOrder
	#define	EVENT_CHTY	2	//EVENT_CHangeTYpe
	#define	EVENT_CHOP	3	//EVENT_CHangeOpenPrice
	#define EVENT_CO	4	//EVENT_ClosedOrder
	//======================================
	double	aEvents[][libE.E_MAX];							// array of events
	//.

//.

//==================================================================================================
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

//==================================================================================================
void E.FillEventsArray(){//..
	/*
		>Ver	:0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	int	idx_1 = 0;
	
	//----------------------------------------------------------------------------------------------
	int CurRange = ArrayRange(libT.array_dCurOrders,0);
	int OldRange = ArrayRange(libT.array_dOldOrders,0);
	
	//----------------------------------------------------------------------------------------------
	for(int idxCur = 0; idxCur < CurRange; idxCur++){
		int CurTicket = libT.CurTicketByIndex(idxCur);
		
		//------------------------------------------------------------------------------------------
		libE.FillEvetnByCurIndex(idxCur);					//��������� ������� �� �������� �������
	}
	
	//------------------------------------------------------
	if(OldRange >= 1){//..
		for(int idxOld = 0; idxOld < OldRange; idxOld++){
			
			//----------------------------------------------
			libE.FillEvetnByOldIndex(idxOld);
		}
	}//.
}//.

//==================================================================================================
void libE.FillEvetnByCurIndex(int idxCUR){//..
	/*
		>Ver	:	0.0.5
		>Date	:	2012.09.11
		>Hist:
			@0.0.5@2012.09.11@artamir	[]
			@0.0.4@2012.09.07@artamir	[*] Added set New type in extra array if type changed.
			@0.0.3@2012.08.28@artamir	[]
			@0.0.2@2012.08.11@artamir	[+] ��������� ��������� ��������� ���� ������ � ��������� ���� ��������. 
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
		thisRow = libE.setNewEventOnIndex(thisRow,	curTicket, libE.EVENT_NO); //���������� ����� ���������� �����
		
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
			
			//----------------------------------------------
			libT.setExtraTypeByTicket(curTicket, curType);
		}
		//.
		
		//..	//=== Change OpenPrice
		double	curOP	=	libT.CurOPByIndex(idxCUR);
		double	oldOP	=	libT.OldOPByIndex(idxCUR);
		
		//--------------------------------------------------
		if(curOP != oldOP){
			thisRow = libE.setNewEventOnIndex(thisRow, curTicket, libE.EVENT_CHOP);
			libT.setExtraOPByTicket(curTicket, curOP);
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
			@0.0.2@2012.08.11@artamir	[+] ��������� ��������� ��������� ���� ������ � ��������� ���� ��������. 
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
	
	if(idxCUR <= -1){//..									//this is a Closed order.
		thisRow = libE.setNewEventOnIndex(thisRow,	oldTicket, libE.EVENT_CO); //���������� ����� ���������� �����
		
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
			��������� ������ � ������� �� ��������� �������.
	*/
	if(ticket <= 0) return(idx);							//���� ����� �� �����, �� �������
	
	//----------------------------------------------------------------------------------------------
	int ROWS = ArrayRange(libE.array_dOrdersEvents, 0);		//����� �����
	
	//----------------------------------------------------------------------------------------------
	if(idx >= ROWS){//..									//������ ������ ��� ������������ ���������� �����
		ArrayResize(libE.array_dOrdersEvents, (ROWS+1));	//�������� ������
	}//.
	
	//----------------------------------------------------------------------------------------------
	libE.array_dOrdersEvents[idx][libE.E_TI]	= ticket;
	libE.array_dOrdersEvents[idx][libE.E_TY]	= Event;
	
	//----------------------------------------------------------------------------------------------
	return(idx+1);
}//.