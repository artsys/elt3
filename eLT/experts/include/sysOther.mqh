	/**
		\version	0.0.0.2
		\date		2013.07.29
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
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
		>Ver	:	0.0.0.2
		>Date	:	2013.07.29
		>History:	
					@0.0.0.2@2013.07.29@artamir	[]	iif
	*/
	if( condition ) return( ifTrue );
	//---
	return( ifFalse );
}