	/**
		\version	0.0.0.8
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:										
					 @0.0.0.8@2013.10.30@artamir	[]	SelectedSymbols
					 @0.0.0.7@2013.08.06@artamir	[+]	UCase
					 @0.0.0.6@2013.08.06@artamir	[+]	StringToColor
					 @0.0.0.5@2013.08.06@artamir	[*]	StringReplace
					 @0.0.0.4@2013.08.06@artamir	[+]	StringReplace
					 @0.0.0.3@2013.08.02@artamir	[+]	AddSymbolsRight
					 @0.0.0.2@2013.07.29@artamir	[+]	iif
					 @0.0.0.1@2013.06.12@artamir	[+]	StringToArray
			>Rev:0
	*/

int StringToArray(string &a[], string s, string del = ";"){
	/**
		\version	0.0.0.1
		\date		2013.06.12
		\author		Morochin <artamir> Artiom
		\details	Разбивает строку на подстроки разделителем. если разделителя нет, то в массиве возврящается строка.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.12@artamir	[]	StringToArray
			>Rev:0
	*/
	
	int pR = StringFind(s, del, 0);
	int ROWS = ArrayRange(a,0);
	int lastROW = ROWS-1;
	if(pR > -1){
		ROWS = ROWS + 1;
		ArrayResize(a, ROWS);
		
		lastROW++;
		a[lastROW] = StringSubstr(s, 0, pR);
		s=StringSubstr(s, pR+1, StringLen(s)-pR+1);
		StringToArray(a, s, del);
	}else{
		ROWS = ROWS + 1;
		ArrayResize(a, ROWS);
		
		lastROW++;
		a[lastROW] = s;
		return(ROWS);
	}
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
		\details	Увеличивает строку до заданной длины заданным символом.
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
		\details	Увеличивает строку до заданной длины заданным символом.
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

string StringReplace(string str, string sfind, string srep){
	/**
		\version	0.0.0.2
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	Заменяет sfind на srep в строке str.
		\internal
			>Hist:		
					 @0.0.0.2@2013.08.06@artamir	[*]	Исправлено зацикливание, если sfind = srep
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

color StringToColor(string sclr = "CLR_NONE"){
	/**
		\version	0.0.0.1
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	Возвращает цвет по его символьному представлению
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
		\details	Переводит строку в верхний регистр
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

//Получение списка валют из обзора рынка.
//файл symbols.sel

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

	int h = FileOpenHistory("symbols.sel",FILE_BIN|FILE_READ);	//открываем файл обзора рынка.
	int symbols_count = (FileSize(h)-2)/130+1; //всего выбрано валютных пар.
	
	int start_ofset = 4;// первые 4 байта пропускаем.
	
	string s = "";
	
	for(int i = 0; i<symbols_count; i++){
		int total_ofset = start_ofset+128*i;	//расчет офсета с начала файла.
		FileSeek(h,total_ofset,SEEK_SET);		//переводим курсор на расчитанный офсет.
		s = FileReadString(h,10);				//читаем 10 байт (содержат название валютной пары)
		Print(i+": "+s);						//делаем с названием что хотим.
	}
	FileClose(h);	//закрываем файл.
}

string Bool2Str(bool assertion){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Озвучка булевого результата.
		\internal
			>Hist:
			>Rev:0
	*/

	if(assertion)	return("true");
	else 			return("false");
}