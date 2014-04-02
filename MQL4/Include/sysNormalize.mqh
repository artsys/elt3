	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.24
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	������������ �������� �����
	*/
	
double Norm_symb(double d, string sy = "", int add = 0){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.07.18
		>Hist:
			@0.0.2@2012.07.18@artamir	[+] ���������� ����� ���������� add 
			@0.0.1@2012.06.25@artamir	[+] ������� ����������
		>Desc:
			����������� �������� ���� double ����������� ������ ����� ������� ��� ��������� �����������.
		>VARS:
			d	: ���������� ���� �����
			sy	: �������� �����������
			add	: ���������� ��������� �������� ���� ����� �������
	*/
	//==================================
	if(sy == ""){
		sy = Symbol();
	}
	//----------------------------------
	if(d == 0){
		return(0);
	}
	//----------------------------------
	int di = MarketInfo(sy,	MODE_DIGITS);
	return(NormalizeDouble(d, di+add));
}//.

double Norm_symb2(double d){
   double tick_size=MarketInfo(Symbol(),MODE_TICKSIZE);
   double norm_d=Norm_symb(d);
   double mod=Norm_symb(MathMod(norm_d,tick_size));
   double res=norm_d-mod+tick_size;
   res=Norm_symb(res);
   return(res);
}

double Norm_vol(double v, string sy = ""){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.07.31
		>History:
			@0.0.2@2012.07.31@artamir	[+] ������� ������������ ������ � ����������� �� ���� ������.
			@0.0.1@2012.07.25@artamir	[]
		>Description: ������������ ������ �� ���� ���������.
	*/
	
	//--------------------------------------------------------------------
	if(sy == ""){
		sy = Symbol();
	}
	
	//--------------------------------------------------------------------
	int d = 2; //
	
	//--------------------------------------------------------------------
	double lotStep = MarketInfo(sy, MODE_LOTSTEP);
	
	//--------------------------------------------------------------------
	if(lotStep == 0.01){
		d = 2;
	}
	//------
	if(lotStep == 0.1){
		d = 1;
	}
	//------
	if(lotStep == 1){
		d = 0;
	}
	//--------------------------------------------------------------------
	return(NormalizeDouble(v, d));
}//.
