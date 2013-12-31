/*
		>Ver	:	0.0.0.9
		>Date	:	2013.09.04
		>History:			
					@0.0.0.9@2013.09.04@artamir	[*]	TMR_Start
					@0.0.0.8@2013.08.29@artamir	[]	TMR_findIndexByName
					@0.0.7@2013.04.25@artamir	[]	BP
		>Description:
			system. For debugging
*/
bool BP_SNP=false;	//Точка условной остановки. SelectNearPrice.
bool BP_SRT=false; //Точка условной остановки SORTING

void BP(string	txt	= "",
		string	p11	= "",		string p12	= "",
		string	p21	= "",		string p22	= "", 
		string	p31	= "",		string p32	= "",
		string	p41	= "",		string p42	= "",
		string	p51	= "",		string p52	= "",
		string	p61 = "",		string p62	= "",
		string	p71 = "",		string p72	= "",
		bool	useDebug = true					){
		
		/*
		>Ver	:	0.0.4
		>Date	:	2013.04.25
		>History:	
					@0.0.4@2013.04.25@artamir	[]	BP
			@0.0.3@2012.10.08@artamir	[]
			@0.0.2@2012.06.25@artamir	[+]	useDebug = проверка на разрешение вызова модальной формы
			@0.0.1@2012.06.25@artamir	[] 
		>Description:
			Break poinT_ Use with vizualization.
		*/
		
		//--------------------------------------------------
		if(!useDebug) return;
		
		//--------------------------------------------------
		//if(!Debug) return;
		
		//--------------------------------------------------
		string strOutput = StringConcatenate(	p11,p12,"\n",
												p21,p22,"\n",
												p31,p32,"\n",
												p41,p42,"\n",
												p51,p52,"\n",
												p61,p62,"\n",
												p71,p72,"\n");
												
		static int	flOK = 1;
		if(flOK == 1){
			flOK = MessageBoxA(WindowHandle(Symbol(),0), strOutput, txt, MB_OKCANCEL);
			return;
		}else{
			return;
		}
}

#define	TMR_ST	0	//start time
#define	TMR_ET	1	//end time
#define TMR_RES	2	//result in sec 	
#define TMR_MAX 3

string	asTMR[]				;	//name of timer
int		aiTMR[][TMR_MAX]	;	//timer

void TMR_init(){
	ArrayResize(asTMR,0);
	ArrayResize(aiTMR,0);
}

int TMR_findIndexByName(string name){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.08.29
		>Hist	:	
					@0.0.0.2@2013.08.29@artamir	[]	TMR_findIndexByName
			@0.0.1@2012.10.08@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(asTMR,0);
	
	//------------------------------------------------------
	int		idx = -1;
	bool	isFind = false;
	
	//------------------------------------------------------
	for(int i=0; i<ROWS && !isFind;i++){
		
		//--------------------------------------------------
		string timer_name = asTMR[i];
		
		//--------------------------------------------------
		if(timer_name == name){
			isFind = true;
			idx = i;
		}
	}
	
	//------------------------------------------------------
	return(idx);
}

//..	//=== GET PROP

int	TMR.getPropByIndex(int idx = 0, int prop = 0){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.08
		>Hist	:
			@0.0.2@2012.10.08@artamir	[]
			@0.0.1@2012.10.08@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	return(aiTMR[idx][prop]);
}


//..	//=== SET PROP

int	TMR_setPropByIndex(int idx = 0, int prop = 0, int val = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.08
		>Hist	:
			@0.0.1@2012.10.08@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	aiTMR[idx][prop] = val;
	
	//------------------------------------------------------
	return(idx);
}

int TMR_setStartTime(int idx, int st){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	Установка локального времени запуска таймера.
		\internal
			>Hist:
			>Rev:0
	*/

	
	//------------------------------------------------------
	TMR_setPropByIndex(idx, TMR_ST, st);
}

//..	//=== ADD NEW TIMER

int TMR_addNewTimer(string name = ""){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	Создает новый таймер. если имя не заданно, то присваевается вместо имени текущее локальное время.
		\internal
			>Hist:
			>Rev:0
	*/

	if(name == ""){
		name = "TMR_"+TimeLocal();
	}
	
	int idx =	ArrayResize(asTMR,ArrayRange(asTMR,0)+1)-1;
				ArrayResize(aiTMR,(idx+1));
	asTMR[idx] = name;
	
	return(idx);
}

int TMR_Start(string name = ""){
	/*
		>Ver	:	0.0.0.1
		>Date	:	2013.09.04
		>Hist	:	
					@0.0.0.1@2013.09.04@artamir	[*]	TMR_Start
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	
	*/
	
	//------------------------------------------------------
	int idx = TMR_findIndexByName(name);
	
	//------------------------------------------------------
	if(idx <= -1){
		
		//--------------------------------------------------
		idx = TMR_addNewTimer(name);
	}
	
	TMR_setStartTime(idx,GetTickCount());
	
	return(idx);
}

int TMR_Stop(int &idx, string name=""){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	Останавливает таймер по индексу или по имени.
		\internal
			>Hist:
			>Rev:0
	*/

	if(idx<0){
		idx=TMR_findIndexByName(name);
	}
	
	
	TMR_setPropByIndex(idx, TMR_ET, GetTickCount());
	
	//-------------------------------------
	int res_sec =  (aiTMR[idx][TMR_ET]-aiTMR[idx][TMR_ST]);
	TMR_setPropByIndex(idx, TMR_RES, res_sec);
	idx=aiTMR[idx][TMR_ET];
	//-------------------------------------
	return(res_sec);
}