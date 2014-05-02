	/**
		\version	0.0.1.6
		\date		2014.01.23
		\author		Morochin <artamir> Artiom
		\details	Настраиваемый фрактал
		\internal
			>Hist:						
					 @0.0.1.6@2014.01.23@artamir	[]	iFR_isUP Ужесточился метод определения нижнего и верхнего фрактклов.
					 @0.0.1.5@2014.01.23@artamir	[]	iFR_isDW
					 @0.0.1.4@2013.12.27@artamir	[+]	iFR_getNearestDwBarTF
					 @0.0.1.3@2013.12.27@artamir	[+]	iFR_getNearestUpBarTF
					 @0.0.1.2@2013.12.27@artamir	[+]	aFR_getTF
					 @0.0.1.1@2013.12.27@artamir	[+]	aFR_getSY
			>Rev:0
	*/

#define FR_MODE_STD 1	//Поиск фрактала в классическом понимании.
#define FR_MODE_HL 2 //Поиск по последовательным хаям/лоу
	
string aFrSets[];
	
void aFR_init(){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	Очищает стринговый массив.-хранилище настроек.
		\internal
			>Hist:
			>Rev:0
	*/

	ArrayResize(aFrSets,0);
}

int aFR_set(		int nl	= 2				/** количество ближайших баров слева*/
				,	int	nr	= 2				/** количество ближайших баров справа */
				,	int tf = 0				/** таймфрейм в минутах */
				,	string sy = ""			/** валютная пара */
				,	int shift = 3			/** спещение относительно начала графика в право в барах. */
				,	int mode = 1			/** метод поиска фрактала */
			){
	/**
		\version	0.0.0.0
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Сохраняет настройку FR в массив настроек. Возвращает индекс настройки в массиве.
		\internal
			>Hist:			
			>Rev:0
	*/

	int new_row=As_addRow1(aFrSets);
	
	if(sy == ""){
		sy=Symbol();
	}
	
	string s = "";
	s=s+"@nl"+nl;
	s=s+"@nr"+nr;
	s=s+"@mo"+mode;
	
	if(sy=="")sy=Symbol();
	s=s+"@sy"+sy;
	s=s+"@tf"+tf;
	s=s+"@sh"+shift;
	
	aFrSets[new_row]=s;
	return(new_row);
}

string aFR_getSY(int h){
	/**
		\version	0.0.0.1
		\date		2013.12.27
		\author		Morochin <artamir> Artiom
		\details	Возвращает символ из настроек фрактала
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.27@artamir	[+]	aFR_getSY
			>Rev:0
	*/

	string fn="aFR_getSY";
	
	string sy=Struc_KeyValue_string(aFrSets[h],"@sy");
	
	return(sy);
}

int aFR_getTF(int h){
	/**
		\version	0.0.0.1
		\date		2013.12.27
		\author		Morochin <artamir> Artiom
		\details	Возвращает таймфрейм из настроек фрактала
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.27@artamir	[+]	aFR_getTF
			>Rev:0
	*/

	string fn="aFR_getTF";
	
	int tf=0;
	tf=Struc_KeyValue_int(aFrSets[h],"@tf",0);
	
	return(tf);
}

bool iFR_isUP(int h=0 /** handle */
			, int shift=-1
			, bool use_synchro=true){
	/**
		\version	0.0.0.1
		\date		2014.01.23
		\author		Morochin <artamir> Artiom
		\details	Возвращает да, если на заданном баре сформирован верхний фрактал.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.23@artamir	[]	iFR_isUP
			>Rev:0
	*/

	string fn="iFR_isUP";
	
	int 	nl=Struc_KeyValue_int(		aFrSets[h],"@nl");
	int 	nr=Struc_KeyValue_int(		aFrSets[h],"@nr");
	int 	mo=Struc_KeyValue_int(		aFrSets[h],"@mo");
	string 	sy=Struc_KeyValue_string(	aFrSets[h],"@sy");
	int 	tf=Struc_KeyValue_int(		aFrSets[h],"@tf");
	int 	sh=Struc_KeyValue_int(		aFrSets[h],"@sh");
	
	if(shift>-1){
		sh=shift;
	}
	
	if(use_synchro){
		sh=iBarShift(sy, tf, iTime(sy, 0, sh));
	}
	
	if(sh<=nr)return(false);
	
	bool f=true;
	double fbp=iHigh(sy,tf,sh);
	
	//if(sh!=iHighest(sy,tf,MODE_HIGH,nr+1,sh-nr))f=false;
	for(int i=sh-nr;i<sh&&f;i++){
		double hp=iHigh(sy,tf,i);
		if(fbp<=hp) f=false;
	}
	
	if(f){
		//if(sh!=iHighest(sy,tf,MODE_HIGH,nl+1,sh))f=false;
		for(int i=sh+1;i<=(sh+nl)&&f;i++){
			double hp=iHigh(sy,tf,i);
			if(fbp<=hp)f=false;
		}
	}	
	
	return(f);
}

bool iFR_isDW(int h=0 /** handle */
			, int shift=-1
			, bool use_synchro=true){
	/**
		\version	0.0.0.1
		\date		2014.01.23
		\author		Morochin <artamir> Artiom
		\details	Возвращает да, если на заданном баре сформирован нижний фрактал.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.23@artamir	[]	iFR_isDW
			>Rev:0
	*/

	string fn="iFR_isDW";
	
	int 	nl=Struc_KeyValue_int(		aFrSets[h],"@nl");
	int 	nr=Struc_KeyValue_int(		aFrSets[h],"@nr");
	int 	mo=Struc_KeyValue_int(		aFrSets[h],"@mo");
	string 	sy=Struc_KeyValue_string(	aFrSets[h],"@sy");
	int 	tf=Struc_KeyValue_int(		aFrSets[h],"@tf");
	int 	sh=Struc_KeyValue_int(		aFrSets[h],"@sh");
	
	if(shift>-1){
		sh=shift;
	}
	
	if(use_synchro){
		sh=iBarShift(sy, tf, iTime(sy, 0, sh));
	}
	
	if(sh<=nr)return(false);
	
	bool f=true;
	double fbp=iLow(sy,tf,sh);
	//if(sh!=iLowest(sy,tf,MODE_LOW,nr+1,sh-nr))f=false;
	for(int i=sh-nr;i<sh&&f;i++){
		double l=iLow(sy,tf,i);
		if(fbp>=l) f=false;
	}
	
	if(f){
		//if(sh!=iLowest(sy,tf,MODE_LOW,nl+1,sh))f=false;
		for(int i=sh+1;i<=(sh+nl)&&f;i++){
			double l=iLow(sy,tf,i);
			if(fbp>=l) f=false;
		}
	}
	return(f);
}

int iFR_getNearestUpBar(int h, int start_bar=0){
	/**
		\version	0.0.0.0
		\date		2013.12.23
		\author		Morochin <artamir> Artiom
		\details	Возвращает номер ближайшего верхнего фрактала, начиная с заданного.
		\internal
			>Hist:
			>Rev:0
	*/

	bool isFind=false;
	int i=start_bar;
	while(i<Bars && !isFind) {
		isFind=iFR_isUP(h,i);
		i++;
	}	
	
	if(isFind){
		i--;
		return(i);
	}
	
	return(-1);
}

int iFR_getNearestDwBar(int h, int start_bar=0){
	/**
		\version	0.0.0.0
		\date		2013.12.23
		\author		Morochin <artamir> Artiom
		\details	Возвращает номер ближайшего нижнего фрактала, начиная с заданного.
		\internal
			>Hist:
			>Rev:0
	*/

	bool isFind=false;
	int i=start_bar;
	while(i<Bars && !isFind) {
		isFind=iFR_isDW(h,i);
		i++;
	}	
	
	if(isFind){
		i--;
		return(i);
	}
	
	return(-1);
}

int iFR_getNearestUpBarTF(int h, int start_bar){
	/**
		\version	0.0.0.1
		\date		2013.12.27
		\author		Morochin <artamir> Artiom
		\details	Возвращает номер бара фрактала на заданном в настройках таймфрейме.
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.27@artamir	[+]	iFR_getNearestUpBarTF
			>Rev:0
	*/

	int i=iFR_getNearestUpBar(h, start_bar);
	int res=-1;
	
	string sy=aFR_getSY(h);
	int tf=aFR_getTF(h);
	
	if(i>-1){
		res=iBarShift(sy,tf,iTime(sy,0,i));
		return(res);
	}
	
	return(-1);
}

int iFR_getNearestDwBarTF(int h, int start_bar){
	/**
		\version	0.0.0.2
		\date		2013.12.27
		\author		Morochin <artamir> Artiom
		\details	Возвращает номер бара фрактала на заданном в настройках таймфрейме.
		\internal
			>Hist:		
					 @0.0.0.2@2013.12.27@artamir	[+]	iFR_getNearestDwBarTF
			>Rev:0
	*/

	int i=iFR_getNearestDwBar(h, start_bar);
	int res=-1;
	
	string sy=aFR_getSY(h);
	int tf=aFR_getTF(h);
	
	if(i>-1){
		res=iBarShift(sy,tf,iTime(sy,0,i));
		return(res);
	}
	
	return(-1);
}

int As_addRow1(string &a[], string val=""){
	/**
		\version	0.0.0.2
		\date		2013.12.17
		\author		Morochin <artamir> Artiom
		\details	Изменяет размерность массива на +1. Возвращает индекс последнего элемента.
					присваивает новому элементу значение переданное в параметре val.
		\internal
			>Hist:			
					 @0.0.0.2@2013.12.17@artamir	[*]	Присвоение значения по умолчанию.
					 @0.0.0.1@2013.10.07@artamir	[+]	As_addRow1
			>Rev:0
	*/

	int rows=ArrayRange(a,0)+1;
		ArrayResize(a,rows);
		a[(rows-1)]=val;	 
	return(rows-1);		 
}