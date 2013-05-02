/*
		>Ver	:	0.0.2
		>Date	:	2012.10.01
	>Hist:
			@0.0.2@2012.10.01@artamir	[]
			@0.0.1@2012.10.01@artamir	[]
	>Desc:
*/

//==========================================================
int Sig.MAZZ.getSignal(int MAper = 21, int ZZper = 21){//..
	/*
		>Ver	:	0.0.4
		>Date	:	2012.10.01
		>Hist:
			@0.0.4@2012.10.01@artamir	[*] ���������� ��������� �������
			@0.0.3@2012.10.01@artamir	[]
			@0.0.2@2012.09.14@artamir	[*] changed zz to 30
			@0.0.1@2012.09.10@artamir	[]
	*/
	//------------------------------------------------------
	if(Sig.MAZZ.IsZZNewDraw("", 0, ZZper)){
		
		//--------------------------------------------------
		int Signal = Sig.MAZZ.checkMAZZ(MAper, ZZper);
		
		//--------------------------------------------------
		return(Signal);
	}else{
		return(-1);
	}
}//.

//==========================================================
int Sig.MAZZ.checkMAZZ(int MAper = 21, int ZZper = 21){//..

	//------------------------------------------------------
	double thisMA = libI_MA.GetEMA(MAper);					//�������� ���� ��� � �������� �������� �� 0-� ���� �� ���. ����������� � ����������.
	double thisZZ = libI_ZZ.GetZZExtrByNum(0,"",0, ZZper);  //�������� ���� 0-�� ���������� ������� �� ��������� ExtDepth
	
	//------------------------------------------------------
	if(thisZZ < thisMA){									//���������� ��� ������������� ������ � ����������� �� ��������� ������������ EMA � ZZ
		return(OP_BUY);
	}else{
		return(OP_SELL);
	}
}//.

//==========================================================
bool Sig.MAZZ.IsZZNewDraw (string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.03
		>History:
			@0.0.3@2012.08.03@artamir	[]
			@0.0.2@2012.08.03@artamir	[]
			@0.0.1@2012.07.02@artamir	[*] �������� ������� ����������.
		>Description:
			���������� True, ���� ����������� ����� ��������� �������. ����� ���������� false
		>VARS: 
			sy		= ������������ �����������
			tf		= �������� � �������
			dp		= Depth
			dv		= Deviation
			bc		= Backstep
	*/
	
	if(sy == ""){
		sy = Symbol();
	}	
	
	//----------------------------------------------------------------------------------------------
	datetime ZZ_thisDrawTime = libI_ZZ.GetZZExtrTimeByNum(0, sy, tf, dp, dv, bc);
	static datetime ZZ_lastDrawTime = 0;
	if(ZZ_lastDrawTime < ZZ_thisDrawTime){
		ZZ_lastDrawTime = ZZ_thisDrawTime;
		return(true);
	}else{
		return(false);
	}
}//.