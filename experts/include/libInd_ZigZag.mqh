/*
		>Ver	:	0.0.2
		>Date	:	2012.08.03
		>History:
			@0.0.2@2012.08.03@artamir	[*] ��������� � ��������� ������� �������� ������������� �����
			@0.0.1@2012.08.03@artamir	[+] libI_ZZ.IsZZNewDraw
		>Description:
			���������� ��� ������ � ����������� "ZigZag"
*/

double		libI_ZZ.GetZZExtrByNum		(int num = 0,	string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3, int shift = 0){//..
   /*
      Ver: 0.0.1
      Date: 2012.06.07
      Autor: artamir
      Description: ���������� �������� ���������� ������� �� ��� ����������� ������
      VARS: 
         num = ����� ����������
         sy = ������������ �����������
         tf = �������� � �������
         dp = Depth
         dv = Deviation
         bc = Backstep
         shift = ����� ������ ������� �������� ���������� ������������ 0-�� ���� �� ���������� �����
      Return: ���� ���������� �������   
   */
   if(sy == ""){
      sy = Symbol();
   }
   //---
   string iname = "ZigZag"; // ��� ����������, �� �������� ����� ����������� ����������
   //======================
   int thisBar = 0; // ���, �� ������� �������� �������� �������
   if(shift > 0){
      thisBar = shift;
   }
   
   int thisNum = 0; // ������� ��������� �������
   //---
   while(thisBar < iBars(sy, tf) && thisNum <= num){
      double thisExtr = iCustom(sy, tf, iname, dp, dv, bc, 0, thisBar);
      if(thisExtr > 0){
         thisNum++;
      }
      //---
      thisBar++;
   }
   //---
   return(thisExtr);   
}//.

//--------------------------------------------------------------------------------------------------
int 		libI_ZZ.GetZZExtrBarByNum	(int num = 0,	string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3, int shift = 0){//..
      /*
      Ver: 0.0.1
      Date: 2012.06.07
      Autor: artamir
      Description: ���������� ����� ���� ���������� ������� �� ��� (����������) ����������� ������
      VARS: 
         num = ����� ����������
         sy = ������������ �����������
         tf = �������� � �������
         dp = Depth
         dv = Deviation
         bc = Backstep
         shift = ����� ������ ������� �������� ���������� ������������ 0-�� ���� �� ���������� �����
      Return: ����� ���� ���������� �������   
   */
   if(sy == ""){
      sy = Symbol();
   }
   //---
   string iname = "ZigZag"; // ��� ����������, �� �������� ����� ����������� ����������
   //======================
   int thisBar = 0; // ���, �� ������� �������� �������� �������
   if(shift > 0){
      thisBar = shift;
   }
   
   int thisNum = 0; // ������� ��������� �������
   //---
   while(thisBar < iBars(sy, tf) && thisNum <= num){
      double thisExtr = iCustom(sy, tf, iname, dp, dv, bc, 0, thisBar);
      if(thisExtr > 0){
         thisNum++;
      }
      //---
      thisBar++;
   }
   //---
   return(thisBar-1);   
}//.

//--------------------------------------------------------------------------------------------------
bool		libI_ZZ.IsZZExtrUP			(int num = 0,	string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3, int shift = 0){//..
   /*
      Ver: 0.0.1
      Date: 2012.06.07
      Autor: artamir
      Description: ���������� true, ���� ������� ��������� �������� ��������
      VARS: 
         num = ����� ����������
         sy = ������������ �����������
         tf = �������� � �������
         dp = Depth
         dv = Deviation
         bc = Backstep
         shift = ����� ������ ������� �������� ���������� ������������ 0-�� ���� �� ���������� �����
      Return: true, ���� ������� ��������� �������� ��������
   */
   if(sy == ""){
      sy = Symbol();
   }
   
   double h = iHigh(sy, tf, libI_ZZ.GetZZExtrBarByNum(num, sy, tf, dp, dv, bc, shift));
   double ZZ = libI_ZZ.GetZZExtrByNum(num, sy, tf, dp, dv, bc, shift);
   
   h  = NormalizeDouble(h  ,Digits);
   ZZ = NormalizeDouble(ZZ ,Digits);
   
   if(h == ZZ){
      return(true);
   }else{
      return(false);
   }
}//.

//--------------------------------------------------------------------------------------------------
bool		libI_ZZ.IsZZExtrDW			(int num = 0,	string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3, int shift = 0){//..
   /*
      Ver: 0.0.1
      Date: 2012.06.07
      Autor: artamir
      Description: ���������� true, ���� ������� ��������� �������� ��������
      VARS: 
         num = ����� ����������
         sy = ������������ �����������
         tf = �������� � �������
         dp = Depth
         dv = Deviation
         bc = Backstep
         shift = ����� ������ ������� �������� ���������� ������������ 0-�� ���� �� ���������� �����
      Return: true, ���� ������� ��������� �������� ��������
   */
   if(sy == ""){
      sy = Symbol();
   }
   
   double l = iLow(sy, tf, libI_ZZ.GetZZExtrBarByNum(num, sy, tf, dp, dv, bc, shift));
   double ZZ = libI_ZZ.GetZZExtrByNum(num, sy, tf, dp, dv, bc, shift);
   
   l  = NormalizeDouble(l  ,Digits);
   ZZ = NormalizeDouble(ZZ ,Digits);
   
   if(l == ZZ){
      return(true);
   }else{
      return(false);
   }
}//.

//--------------------------------------------------------------------------------------------------
double		libI_ZZ.GetZZExtrUPByNum	(int num = 0,	string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3, int shift = 0){//..
   /*
      Ver: 0.0.1
      Date: 2012.06.07
      Autor: artamir
      Description: ���������� ���� ��������� ������ �������
      VARS: 
         num = ����� �������
         sy = ������������ �����������
         tf = �������� � �������
         dp = Depth
         dv = Deviation
         bc = Backstep
         shift = ����� ������ ������� �������� ���������� ������������ 0-�� ���� �� ���������� �����
      Return: ���������� ���� ��������� ������ �������
   */
   
   if(sy == ""){
      sy = Symbol();
   }
   //---
   double thisExtr      = 0;
   int    thisExtrNum   = 0;
   int    thisUPNum     = 0;
   
   while(thisUPNum <= num){
      if(libI_ZZ.IsZZExtrUP(thisExtrNum, sy, tf, dp, dv, bc, shift)){
         thisUPNum++;
         thisExtr = libI_ZZ.GetZZExtrByNum(thisExtrNum, sy, tf, dp, dv, bc, shift);
      }
      thisExtrNum++;   
   }
   return(thisExtr);
}//.

//--------------------------------------------------------------------------------------------------
double		libI_ZZ.GetZZExtrDWByNum	(int num = 0,	string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3, int shift = 0){//..
   /*
      Ver: 0.0.1
      Date: 2012.06.07
      Autor: artamir
      Description: ���������� ���� ��������� ������ �������
      VARS: 
         num = ����� �������
         sy = ������������ �����������
         tf = �������� � �������
         dp = Depth
         dv = Deviation
         bc = Backstep
         shift = ����� ������ ������� �������� ���������� ������������ 0-�� ���� �� ���������� �����
      Return: ���������� ���� ��������� ������ �������
   */
   
   if(sy == ""){
      sy = Symbol();
   }
   //---
   double thisExtr      = 0;
   int    thisExtrNum   = 0;
   int    thisDWNum     = 0;
   
   while(thisDWNum <= num){
      if(libI_ZZ.IsZZExtrDW(thisExtrNum, sy, tf, dp, dv, bc, shift)){
         thisDWNum++;
         thisExtr = libI_ZZ.GetZZExtrByNum(thisExtrNum, sy, tf, dp, dv, bc, shift);
      }
      thisExtrNum++;   
   }
   return(thisExtr);
}//.

//--------------------------------------------------------------------------------------------------
datetime	libI_ZZ.GetZZExtrTimeByNum	(int num = 0,	string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3, int shift = 0){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.07.02
		>History:
			@0.0.1@2012.07.02@artamir	[*] �������� ������� ����������.
		>Description:
			���������� ����� ����������� ���������� ������� �� ������ ����������, ������� � 0
		>VARS: 
			num		= ����� �������/�������
			sy		= ������������ �����������
			tf		= �������� � �������
			dp		= Depth
			dv		= Deviation
			bc		= Backstep
			shift	= ����� ������ ������� �������� ���������� ������������ 0-�� ���� �� ���������� �����	
	*/
	//------------------------------------
	datetime dt = 0;
	//--------------
	if(sy == ""){
		sy = Symbol();
	}
	//------------------------------------
	int bar_Extr = libI_ZZ.GetZZExtrBarByNum(num, sy, tf, dp, dv, bc, shift);
		dt = iTime(sy,	tf,	bar_Extr);
	//------------------------------------
	return(dt);
}//.

//--------------------------------------------------------------------------------------------------
bool		libI_ZZ.IsZZNewDraw			(				string sy = "", int tf = 0, int dp = 12, int dv = 5, int bc = 3){//..
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
	static datetime ZZ_lastDrawTime;
	if(ZZ_lastDrawTime < ZZ_thisDrawTime){
		ZZ_lastDrawTime = ZZ_thisDrawTime;
		return(true);
	}else{
		return(false);
	}
}//.