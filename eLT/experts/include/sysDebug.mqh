/*
		>Ver	:	0.0.0.8
		>Date	:	2013.08.29
		>History:		
					@0.0.0.8@2013.08.29@artamir	[]	TMR_findIndexByName
					@0.0.7@2013.04.25@artamir	[]	BP
			@0.0.6@2012.10.08@artamir	[]
			@0.0.5@2012.10.08@artamir	[]
			@0.0.4@2012.10.08@artamir	[]
			@0.0.3@2012.10.08@artamir	[]
			@0.0.2@2012.10.08@artamir	[]
			@0.0.1@2012.06.25@artamir	[+] BP()
		>Description:
			system. For debugging
*/

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

#define	TMR_ST	0
#define	TMR_ET	1
#define TMR_CN	2
#define TMR_AT	3
#define TMR_MAX 4

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
		string timer.name = asTMR[i];
		
		//--------------------------------------------------
		if(timer.name == name){
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
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	
	*/
	
	//------------------------------------------------------
	int idx = TMR_findIndexByName(name);
	Print("tmr_idx=",idx);
	
	//------------------------------------------------------
	if(idx <= -1){
		
		//--------------------------------------------------
		idx = TMR_addNewTimer(name);
		TMR_setStartTime(idx,TimeLocal());
	}
	
	return(idx);
}

int TMR_Stop(int idx = -1, string name=""){
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
	
	TMR_setPropByIndex(idx, TMR_ET, TimeLocal());
	
	return(aiTMR[idx][TMR_ET]-aiTMR[idx][TMR_ST]);
}