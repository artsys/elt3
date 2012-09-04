/*
		>Ver	:	0.0.1
		>Date	:	2012.09.03
		>Hist:
			@0.0.1@2012.09.03@artamir	[]
		>Desc:
			lib Trend Harvester for Vova
*/

int libTH.Main(int parent.ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.03
		>Hist:
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
	f.MAX = Bid;											//������������ ���� �������� ������ = ���
	f.MIN = 0;												//����������� ���� = 0;
															//�.�. ���� �������� ��� <= ���
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//������� ��� �������
	
	//------------------------------------------------------
	libA.double_eraseFilter2();								//������� �������
	
	//------------------------------------------------------
	f.COL	= libT.OE_TY;
	f.MIN	= OP_SELL;
	f.MAX	= OP_SELL;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);

	//------------------------------------------------------
	f.COL	= libT.OE_TY;
	f.MIN	= OP_SELLSTOP;
	f.MAX	= OP_SELLSTOP;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
	
	//------------------------------------------------------
	f.COL	= libT.OE_OP;
	f.MIN	= 0;
	f.MAX	= Ask;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.AND);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//������� ������� ���� � �������� � ����� �������� ������ ���
	
	//------------------------------------------------------
	libA.double_PrintArray2(d, 4, "TH_SelectSELL_SELLSTOP_");
	
	//------------------------------------------------------
	libA.double_SaveToFile2(d, "test_save");
	
	//------------------------------------------------------
	double t[][libT.OE_MAX];
	libA.double_ReadFromFile2(t, "test_save");
	
	//------------------------------------------------------
	libA.double_PrintArray2(t, 4, "test_read_from_file");
}//.