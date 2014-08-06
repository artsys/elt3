/*
		>Ver	:	0.0.1.0
		>Date	:	2013.12.24
		>Hist:			
				 @0.0.0.4@2013.08.05@artamir	[*]	Struc_KeyValue_string
				 @0.0.0.4@2013.08.05@artamir	[*]	Struc_KeyValue_int
				 @0.0.0.3@2013.08.05@artamir	[*]	Struc_StringKeyValue
				 @0.0.0.2@2013.08.02@artamir	[+]	Struc_setValue
		>Desc:
			function to work with Structure
			#include <sysOther.mqh>
*/

int Struc_KeyValue_int(string str, string key = "@p", int def = -1){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.08.05
		>History:		
					@0.0.0.2@2013.08.05@artamir	[*]	Добавлен параметр, возвращающий значение по умолчанию 
		>Description:
			return int value by key from format string
	*/
	
	return(StrToInteger(Struc_StringKeyValue(str,key,(string)def)));
}

double Struc_KeyValue_double(string str, string key = "@p"){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.04.05
		>History:	
		>Description:
			return double value by key from format string
	*/
	
	return(StrToDouble(Struc_StringKeyValue(str,key)));
}

string Struc_KeyValue_string(string str, string key = "@p", string def = ""){
	return(Struc_StringKeyValue(str,key,def));
}

string Struc_StringKeyValue(string str = "", string key = "@p", string def = "-1", string del = "@"){
	/*
		>Ver	:	0.0.0.3
		>Date	:	2013.08.05
		>History:	
					@0.0.0.3@2013.08.05@artamir	[*]	Изменились названия параметров функции.
		>Description:
			@str = incoming string of the form "@p123456@l5@w3@d1"; p,l,w,d - name of keys
			@key = <@x>; where @-separator, x-name of key 
			
			on defolt return parent ticket
			if key not found, return defolt value
	*/
	int lPosStart = -1;		//start position of key name
	int lPosEnd = -1;		//end position of key name
	string d = del;   //разделитель
	//---
	if(StringFind(key,d,0) == -1){
		key = d + key;
	}
	//---
	lPosStart	= StringFind(str,key,0);
	
	if(lPosStart == -1){
		return(def);
	}
	//---
	int lKeyLen	= StringLen(key);
	lPosEnd		= StringFind(str,d,lPosStart+1);	// find position of "@" in str after lPosStart 
	lPosStart	= lPosStart + lKeyLen;
	int	len		= (int)iif(lPosEnd == -1, -1, lPosEnd - lPosStart);
	//---
	return(StringSubstr(str, lPosStart, len));
}

string Struc_setValue(string str, string key = "p", string value = "0", string del = "@"){
	/**
		\version	0.0.0.1
		\date		2013.08.02
		\author		Morochin <artamir> Artiom
		\details	Устанавливает значение, соответствующее ключу в строку str
		возвращает измененную строку.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.02@artamir	[]	Struc_setValue
			>Rev:0
	*/

	key = O_StringReplace(key,del,"");
	string lkey = del+key;
	int start_pos = StringFind(str, lkey); 
	
	if(start_pos == -1){
		str = str+lkey+value;
		return(str);
	}
	
	string old_value = Struc_KeyValue_string(str, lkey);
	str = O_StringReplace(str, lkey+old_value, lkey+value);
	return(str);
}