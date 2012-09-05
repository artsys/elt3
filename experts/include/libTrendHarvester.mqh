/*
		>Ver	:	0.0.3
		>Date	:	2012.09.05
		>Hist:
			@0.0.3@2012.09.05@artamir	[*] ������ ���������� ��������� ��������
			@0.0.2@2012.09.05@artamir	[]
			@0.0.1@2012.09.03@artamir	[]
		>Desc:
			lib Trend Harvester for Vova
*/

extern bool libTH.Use			=	false;					//������������ ��������� ������������� Trend Harvester
extern int	libTH.BackStepPip	=	10;						//���������� �� ������ ���������������� �����������.

int libTH.Main(int parent.ticket){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.09.05
		>Hist:
			@0.0.2@2012.09.05@artamir	[*] �������� ������������ � ����������� ���� ��������.
			@0.0.1@2012.09.03@artamir	[+] ������������ ������� ��� �������.
		>Desc:
			Main function.
		>VARS:
	*/
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	//------------------------------------------------------
	libA.double_eraseFilter2();						//�������� ������
	
	//------------------------------------------------------
	int f.COL = libT.OE_TY;
	double f.MAX = OP_BUY;
	double f.MIN = OP_BUY;
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);			//�������� ������ � �������� AND
	
	//------------------------------------------------------
	f.COL = libT.OE_OP;
	f.MAX = Ask;											//������������ ���� �������� ������ = Ask
	f.MIN = 0;												//����������� ���� = 0;
															//�.�. ���� �������� ��� <= ���
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//������� ��� �������
	
	//------------------------------------------------------
	libTH.checkReversOrders(d);								//�������� �� ������������� ��������������� �������.
		
	//------------------------------------------------------
	libA.double_eraseFilter2();								//������� �������
	
	//------------------------------------------------------
	f.COL	= libT.OE_TY;
	f.MIN	= OP_SELL;
	f.MAX	= OP_SELL;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
	
	//------------------------------------------------------
	f.COL	= libT.OE_OP;
	f.MIN	= Bid;
	f.MAX	= 10000;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.AND);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//������� ������� ���� c ����� �������� > ���

	libTH.checkReversOrders(d);
	
	//------------------------------------------------------
	libA.double_SaveToFile2(d, "test_save");
	
	//------------------------------------------------------
	double t[][libT.OE_MAX];
	libA.double_ReadFromFile2(t, "test_save");
	
}//.

//==========================================================
void libTH.checkReversOrders(double &aParents[][]){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.09.05
		>Hist:
			@0.0.2@2012.09.05@artamir	[]
		>Desc:
			�������� ������� ��������� �����������.
		>VARS:
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(aParents, 0);						//���. ����� ������� ������������ �������.
	
	//------------------------------------------------------
	if(ROWS <= 0){//..
		return;
	}//.
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){//..
		//--------------------------------------------------
		int parent.ticket = aParents[idx][libT.OE_TI];
		
		libTH.checkReversOrdersByParent(parent.ticket);
	}//.	
}//.

void libTH.checkReversOrdersByParent(int parent.ticket){//..
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	
	int SPREAD = MarketInfo(Symbol(), MODE_SPREAD);
	
	//------------------------------------------------------
	double revers.price = libTH.getReversPriceByParent(parent.ticket);
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	libA.double_eraseFilter2();
	//------------------------------------------------------
	if(parent.type == OP_BUY || parent.type == OP_BUYSTOP){//..
		int f.COL = libT.OE_TY;
		double f.MAX = OP_SELL;
		double f.MIN = OP_SELL;
		int f.OP = libA.SOP.OR;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.MAX = OP_SELLSTOP;
		f.MIN = OP_SELLSTOP;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.COL = libT.OE_OP;
		f.MAX = revers.price + SPREAD*Point;
		f.MIN = revers.price - SPREAD*Point;
		f.OP = libA.SOP.AND;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		libA.double_SelectArray2(libT.array_dExtraOrders, d);
		
		//--------------------------------------------------
		int ROWS = ArrayRange(d, 0);
		
		//--------------------------------------------------
		if(ROWS <= 0){
			libO.SendSELLSTOP(revers.price);
		}
	}//.
	
	libA.double_eraseFilter2();
	//------------------------------------------------------
	if(parent.type == OP_SELL || parent.type == OP_SELLSTOP){//..
		f.COL = libT.OE_TY;
		f.MAX = OP_BUY;
		f.MIN = OP_BUY;
		f.OP = libA.SOP.OR;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.MAX = OP_BUYSTOP;
		f.MIN = OP_BUYSTOP;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.COL = libT.OE_OP;
		f.MAX = revers.price + SPREAD*Point;
		f.MIN = revers.price - SPREAD*Point;
		f.OP = libA.SOP.AND;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		libA.double_SelectArray2(libT.array_dExtraOrders, d);
		
		//--------------------------------------------------
		ROWS = ArrayRange(d, 0);
		
		if(ROWS <= 0){
			libO.SendBUYSTOP(revers.price);
		}
	}//.
}//.

//==========================================================
double libTH.getReversPriceByParent(int parent.ticket){//..
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	double parent.op = libT.getExtraOPByTicket(parent.ticket);
	
	if(parent.type == OP_BUY || parent.type == OP_BUYSTOP){//..
		//--------------------------------------------------
		double price = parent.op - libTH.BackStepPip*Point;
		
		//--------------------------------------------------
		price = libNormalize.Digits(price);
		
		//--------------------------------------------------
		return(price);
	}//.
	
	//------------------------------------------------------
	if(parent.type == OP_SELL || parent.type == OP_SELLSTOP){//..
		
		//--------------------------------------------------
		price = parent.op + libTH.BackStepPip*Point;
		
		//--------------------------------------------------
		price = libNormalize.Digits(price);
		
		//--------------------------------------------------
		return(price);
	}//.
	
	return(-1);
}//.