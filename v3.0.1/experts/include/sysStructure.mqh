/*
		>Ver	:	0.0.1
		>Date	:	2012.09.04
		>Hist:
			@0.0.1@2012.09.03@artamir	[]
		>Desc:
			function to work with Structure
*/

//==========================================================
int Struc_KeyValue_int(string str, string key = "@p"){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.04.05
		>History:	
		>Description:
			return int value by key from format string
	*/
	
	return(StrToInteger(Struc_StringKeyValue(str,key)));
}//.

//==========================================================
double Struc_KeyValue_double(string str, string key = "@p"){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.04.05
		>History:	
		>Description:
			return double value by key from format string
	*/
	
	return(StrToDouble(Struc_StringKeyValue(str,key)));
}//.

//==========================================================
string Struc_KeyValue_string(string str, string key = "@p"){//..
	return(Struc_StringKeyValue(str,key));
}//.

//==========================================================
string Struc_StringKeyValue(string str = "", string key = "@p", string defolt = "-1", string delimeter = "@"){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.04.04
		>History:
		>Description:
			@str = incoming string of the form "@p123456@l5@w3@d1"; p,l,w,d - name of keys
			@key = <@x>; where @-separator, x-name of key 
			
			on defolt return parent ticket
			if key not found, return defolt value
	*/
	int lPosStart = -1;		//start position of key name
	int lPosEnd = -1;		//end position of key name
	string d = delimeter;   //разделитель
	//---
	if(StringFind(key,d,0) == -1){
		key = d + key;
	}
	//---
	lPosStart	= StringFind(str,key,0);
	
	if(lPosStart == -1){
		return(defolt);
	}
	//---
	int lKeyLen	= StringLen(key);
	lPosEnd		= StringFind(str,d,lPosStart+1);	// find position of "@" in str after lPosStart 
	lPosStart	= lPosStart + lKeyLen;
	int	len		= iif(lPosEnd == -1, -1, lPosEnd - lPosStart);
	//---
	return(StringSubstr(str, lPosStart, len));
}//.
