	/**
		\version	3.1.0.3
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	–абота с индексированным массивом.
		\internal
			>Hist:			
					 @3.1.0.3@2014.02.25@artamir	[+]	
					 @3.1.0.2@2014.02.25@artamir	[+]	AI_Swap
					 @3.1.0.1@2014.02.25@artamir	[+]	AI_setInterval
			>Rev:0
	*/
	
void AId_Init2(double &a[][], int &aI[]){
	/**
		\version	0.0.0.1
		\date		2013.11.06
		\author		Morochin <artamir> Artiom
		\details	»нициализаци€ массива индексов.
		\internal
			>Hist:	
					 @0.0.0.1@2013.11.06@artamir	[+]	
			>Rev:0
	*/

	ArrayResize(aI,ArrayRange(a,0));
	for(int i=0; i<ArrayRange(a,0);i++){
		aI[i]=i;
	}
}

double AId_get2(double &a[][], int &aI[], int idx=0, int col=0){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	¬озвращает значение элемента исходного массива через индекс
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.25@artamir	[+]	
			>Rev:0
	*/

	string fn="AId_get2";
	return(a[aI[idx]][col]);
}


#define AI_WHOLEARRAY -256
#define AI_EMPTY -1024
int AI_setInterval(int &aI[], int start_idx=0, int end_idx=-256){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	ќбрезает индекс по интервалу.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.25@artamir	[+]	AI_setInterval
			>Rev:0
	*/

	string fn="AI_setInterval";
	int aT[];
	ArrayResize(aT,0);
	
	if(start_idx==AI_EMPTY || end_idx==AI_EMPTY){
		ArrayResize(aI,0);
		return(0);	//массив индексов обнул€етс€
	}
	
	int s=0,e=0,t=0;
	if(start_idx==AI_WHOLEARRAY){
		return(ArrayRange(aI,0)); //массив индексов не измен€етс€. 
	}
	
	if(end_idx==AI_WHOLEARRAY){
		e=ArrayRange(aI,0)-1;//самый большой индекс
	}
	
	int range=e-s+1;//количество элементов всего
	ArrayResize(aT,range);
	
	for(int i=0; i<range; i++){
		aT[i]=aI[s+i];
	}
	
	ArrayResize(aI,range);
	ArrayCopy(aI,aT,0,0,WHOLE_ARRAY);
	return(range);
}

int AI_Swap(int &aI, int i=0, int j=0){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	ћен€ет местами два индекса
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.25@artamir	[+]	AI_Swap
			>Rev:307
	*/
	string fn="AI_Swap";
	int t=aI[i];
	aI[i]=aI[j];
	aI[j]=t;
}



