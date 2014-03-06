	/**
		\version	0.0.1.0
		\date		2013.12.34
		\author		Morochin <artamir> Artiom
		\details	Функции работы с объектом datetime и локальным/серверным временем.
		\internal
			>Hist:
			>Rev:0
	*/

int DT_delta(){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Возвращает минимальную разницу между локальным временем и серверным.
		\internal
			>Hist:
			>Rev:0
	*/
	
	string 		fn="DT_delta";
	
	//------------------------------------------------------
	static int 	delta;
	datetime 	TC_old;
	bool 		TC_changed=false;
	
	//------------------------------------------------------
	datetime TC=TimeCurrent();
	datetime TL=TimeLocal();
	if(TC>TC_old){
		TC_old=TC;
		TC_changed=true;
	}else{TC_changed=false;}
	
	//------------------------------------------------------
	if(TC_changed){
		if(delta>0){delta=MathMin(delta,TL-TC);}
		else{delta=TL-TC;}
	}
	
	//------------------------------------------------------
	return(delta);
}

datetime DT_ModeledCurrent(){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Возвращает смоделированное серверное время через локальное.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="DT_ModeledCurrent";
	
	//------------------------------------------------------
	int delta=DT_delta();
	datetime TL=TimeLocal();
	
	//------------------------------------------------------
	datetime MC=TL-delta;
	
	//------------------------------------------------------
	return(MC);
}

int DT_Str2Seconds(string t="00:00:05"){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Перевод из строки времени в секунды.
					Обязательно! строка времени должна передаваться в формате:
					ЧЧ:ММ:СС
		\internal
			>Hist:
			>Rev:0
			#include <sysOther.mqh>
	*/
	string fn="DT_Str2Seconds";
	string a[];
	ArrayResize(a,0);
	StringToArrayString(a,t,":");
	int rows_a=ArrayRange(a,0);
	int res_sec=0;
	if(rows_a>0){
		res_sec=StrToInteger(a[0])*3600+StrToInteger(a[1])*60+StrToInteger(a[2]);
	}
	
	return(res_sec);
}

int DT_Time2Seconds(datetime t){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Возвращает количество секунд во времени, переданном в параметре t.
					Другими словами-количество секунд, прошедшее с начала дня из параметра t.
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="DT_Time2Secinds";
	
	int res_sec=TimeHour(t)*3600+TimeMinute(t)*60+TimeSeconds(t);
	
	return(res_sec);
}

string DT_Time2Str(datetime t){
	/**
		\version	0.0.0.0
		\date		2013.10.31
		\author		Morochin <artamir> Artiom
		\details	Переводит количество секунд, прошедших с начала дня в строку формата HH:MM:SS
		\internal
			>Hist:
			>Rev:0
	*/
	
	string res=TimeHour(t)+":"+TimeMinute(t)+":"+TimeSeconds(t);
	
	return(res);
}

bool DTs_isTimeBetween(datetime t, string st="00:00:01", string et="00:00:03"){
	/**
		\version	0.0.0.0
		\date		2013.10.30
		\author		Morochin <artamir> Artiom
		\details	Проверяет, если время заданное в параметре t находится между заданным интервалом.
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="DTs_isTimeBetween";
	bool res=false;
	
	int iST=DT_Str2Seconds(st);	//время начала в секундах
	int iET=DT_Str2Seconds(et);	//время окончания интервала в секундах
	int iTT=DT_Time2Seconds(t);	//текущее время в секундах, прошедших с начала дня.
	
	if(iST < iET){if(iST<iTT && iTT<iET){res=true;}}
	
	if(iST > iET){if(iTT<iET || iTT>iST){res=true;}}
	
	return(res);
}