	/**
		\version	0.0.1.1
		\date		2013.12.23
		\author		Morochin <artamir> Artiom
		\details	�������, ������� �� ����� �� � ���� ����������.
					��������� �� ������������� � ������ 562 � ����.
		\internal
			>Hist:										
			>Rev:0
	*/

int StringToArrayString(string &a[], string s, string del = ";"){
	/**
		\version	0.0.0.1
		\date		2013.06.12
		\author		Morochin <artamir> Artiom
		\details	��������� ������ �� ��������� ������������. ���� ����������� ���, �� � ������� ������������ ������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.12@artamir	[]	StringToArray
			>Rev:0
	*/
	string fn="StringToArrayString";
	int pR = StringFind(s, del, 0);
	int ROWS = ArrayRange(a,0);
	int lastROW = ROWS-1;
	if(pR > -1){
		ROWS = ROWS + 1;
		ArrayResize(a, ROWS,1000);
		
		lastROW++;
		a[lastROW] = StringSubstr(s, 0, pR);
		s=StringSubstr(s, pR+StringLen(del), StringLen(s)-pR+StringLen(del));
		ROWS=StringToArrayString(a, s, del);
	}else{
		ROWS = ROWS + 1;
		ArrayResize(a, ROWS,1000);
		
		lastROW++;
		a[lastROW] = s;
		return(ROWS);
	}
	
	return(ROWS);
}

double iif( bool condition, double ifTrue, double ifFalse ){
	/*
		>Ver	:	0.0.0.3
		>Date	:	2013.08.29
		>History:		
					@0.0.0.3@2013.08.29@artamir	[*]	dif
					@0.0.0.2@2013.07.29@artamir	[]	iif
	*/
	if( condition ) return( ifTrue );
	//---
	return( ifFalse );
}

string AddSymbolsRight(string s, int len, string sy=" "){
	/**
		\version	0.0.0.1
		\date		2013.08.02
		\author		Morochin <artamir> Artiom
		\details	����������� ������ �� �������� ����� �������� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.02@artamir	[]	AddSymbolsRight
			>Rev:0
	*/

	int counts = len - StringLen(s);
	
	if(counts <= 0){return(s);}
	
	for(int i=0; i<counts; i++){
		s=s+sy;
	}
	
	return(s);
}

string AddSymbolsLeft(string s, int len, string sy=" "){
	/**
		\version	0.0.0.1
		\date		2013.08.02
		\author		Morochin <artamir> Artiom
		\details	����������� ������ �� �������� ����� �������� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.02@artamir	[]	AddSymbolsRight
			>Rev:0
	*/

	int counts = len - StringLen(s);
	
	if(counts <= 0){return(s);}
	
	for(int i=0; i<counts; i++){
		s=sy+s;
	}
	
	return(s);
}

string O_StringReplace(string str, string sfind, string srep){
	/**
		\version	0.0.0.2
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	�������� sfind �� srep � ������ str.
		\internal
			>Hist:		
					 @0.0.0.2@2013.08.06@artamir	[*]	���������� ������������, ���� sfind = srep
					 @0.0.0.1@2013.08.06@artamir	[]	StringReplace
			>Rev:0
	*/

	if(sfind == srep){
		return(str);
	}
	
	bool isFind = true;
	
	while(isFind){
		int start_pos = StringFind(str, sfind);
		int end_pos = start_pos+StringLen(sfind);
		
		if(start_pos < 0){
			isFind = false;
			return(str);
		}
		
		string str_left = "";
		if(start_pos > 0){
			str_left = StringSubstr(str,0,start_pos);
		}
		
		string str_right = StringSubstr(str, end_pos);
		
		str = str_left+srep+str_right;
	}
	
	return(str);
}

color O_StringToColor(string sclr = "CLR_NONE"){
	/**
		\version	0.0.0.1
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	���������� ���� �� ��� ����������� �������������
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.06@artamir	[]	StringReplace
			>Rev:0
	*/

	color clr = CLR_NONE;
	
	sclr = UCase(sclr);
	if(sclr == "RED"){
		clr = Red;
	}

	if(sclr == "GREEN"){
		clr = Green;
	}
	
	if(sclr == "GRAY"){
		clr = Gray;
	}
	
	return(clr);
}

string UCase(string str){
	/**
		\version	0.0.0.1
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	��������� ������ � ������� �������
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.06@artamir	[]	UCase
			>Rev:0
	*/

	int l = StringLen(str);
	
	for(int i = 0; i < l; i++){
		int chr = StringGetChar(str, i);
		
		if(chr >= 97 && chr <= 122){
			str = StringSetChar(str,i,(chr-32));
		}
	}
	
	return(str);
}

//��������� ������ ����� �� ������ �����.
//���� symbols.sel

void SelectedSymbols(){
	/**
		\version	0.0.0.1
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.10.30@artamir	[]	SelectedSymbols
			>Rev:0
	*/

	int h = FileOpenHistory("symbols.sel",FILE_BIN|FILE_READ);	//��������� ���� ������ �����.
	int symbols_count = (FileSize(h)-2)/130+1; //����� ������� �������� ���.
	
	int start_ofset = 4;// ������ 4 ����� ����������.
	
	string s = "";
	
	for(int i = 0; i<symbols_count; i++){
		int total_ofset = start_ofset+128*i;	//������ ������ � ������ �����.
		FileSeek(h,total_ofset,SEEK_SET);		//��������� ������ �� ����������� �����.
		s = FileReadString(h,10);				//������ 10 ���� (�������� �������� �������� ����)
		Print(i+": "+s);						//������ � ��������� ��� �����.
	}
	FileClose(h);	//��������� ����.
}

string Bool2Str(bool assertion){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	������� �������� ����������.
		\internal
			>Hist:
			>Rev:0
	*/

	if(assertion)	return("true");
	else 			return("false");
}