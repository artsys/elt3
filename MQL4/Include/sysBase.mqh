   /**
		\version	0.0.0.5
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	База для советников. Сборник сервисных процедур/функций.
		Для правильной работы необходимо, чтоб в советниках были определены константы: EXP - Уникальное имя эксперта, нужное для создания файлов данных эксперта.
		\internal
			>Hist:					
					 @0.0.0.5@2014.03.06@artamir	[]	B_Select
					 @0.0.0.4@2014.03.03@artamir	[+]	B_Start
					 @0.0.0.3@2014.03.03@artamir	[+]	B_Init
					 @0.0.0.2@2014.03.03@artamir	[+]	B_Deinit
					 @0.0.0.1@2014.03.03@artamir	[+]	B_DBOE
			>Rev:0
	*/

string com="";
string comadd="";
#define tmr int tmrstrt=GetTickCount();
#define ctmr " tmr:"+(string)(GetTickCount()-tmrstrt)
#define zx tmr if(bDebug){ com+="if("+__FUNCSIG__+"){\n";comadd="";}
#define zxadd(text) comadd+=text+";\n";
#define xz if(bDebug){com=StringConcatenate(com,StringLen(comadd)>0?comadd+"\n":"",__FUNCTION__+ctmr+"};\n");comadd="";} 
	
#define SELECT(a,text) int aI[]; ArrayResize(aI,0,1000); AId_Init2(a,aI); if(bDebug){AId_Print2(a,aI,4,"line_before"+__LINE__);} B_Select(a, aI, text); if(bDebug){AId_Print2(a,aI,4,"line_after"+__LINE__);}	
	
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property strict

bool bDebug=false;
bool bNeedDelClosed=false;

double dNearestBuyPrice=100000;
double dMaxBuyPrice=100000;

double dNearestSellPrice=0;
double dMinSellPrice=0;

bool B_BSEL=false;
bool isTick=false;

#include <sysOther.mqh> //{
#include <sysNormalize.mqh>
#include <sysStructure.mqh>

#include <sysDT.mqh>

#include <sysIndexedArray.mqh>

#include <sysOE.mqh>
#include <sysEvents.mqh> 

#include <sysTrades.mqh>//}	

void B_Init(){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Инициализация системных массивов. Загрузка сохраненных данных.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	B_Init
			>Rev:0
	*/
	OE_init();
	E_Init();
	
	string file_oe=B_DBOE();
	AId_RFF2(aOE,file_oe);
}

void B_Deinit(){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Деинициализация эксперта.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	B_Deinit
			>Rev:0
	*/
	string file_oe=B_DBOE();
	AId_STF2(aOE,file_oe);
	WriteFile();
}

void B_Start(){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Вызывается из функции старт советника.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	B_Start
			>Rev:0
	*/
	zx
	
	isTick=true;
	E_Start();
	if(bNeedDelClosed)OE_delClosed();
	xz
}

string B_DBOE(){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Имя файла-хранилища масива aOE.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	B_DBOE
			>Rev:0
	*/
	
	string file=StringConcatenate("OE.",EXP,".",AccountNumber(),".",Symbol(),".tdb");
	
	return(file);
}

void B_Select(double &a[][], int &aI[], string f){
	/**
		\version	0.0.0.2
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Выборка из массива.
		\internal
			>Hist:			
					 @0.0.0.2@2014.03.06@artamir	[!]	Добавлен обязательный отбор по магику.
					 @0.0.0.1@2014.01.23@artamir	[+]	Select
			>Rev:0
	*/
   zx
   zxadd(f)
	string fn="B_Select";
	
	if(StringFind(f,((string)OE_MN+"=="))<0)	f=StringConcatenate(OE_MN,"==",TR_MN," AND ",f);	
	
	AIF_init();
	
	//1. Раскладываем строку f по разделителю " AND "
	string del=" AND ";
	string aAnd[];
	ArrayResize(aAnd,0);
	
	StringToArrayString(aAnd, f, del);
	int and_rows=ArrayRange(aAnd,0);

	for(int i=0;i<and_rows;i++){
		string e=aAnd[i];
		string aTemp[];
		
		//{		EQ "=="
		ArrayResize(aTemp,0);
		StringToArrayString(aTemp,e,"==");
		int e_rows=ArrayRange(aTemp,0);
		int col=-1; double val=0.0;
		
		if(e_rows>1){
			int col=StrToInteger(aTemp[0]);
			double val=StrToDouble(aTemp[1]);
			
			AIF_filterAdd_AND(col,AI_EQ,val,val);	
		}
		
		//..	GREAT ">>"
		ArrayResize(aTemp,0);
		StringToArrayString(aTemp,e,">>");
		e_rows=ArrayRange(aTemp,0);
		if(e_rows>1){
			col=StrToInteger(aTemp[0]);
			double val=(double)StrToDouble(aTemp[1]);
			
			AIF_filterAdd_AND(col,AI_GREAT,val,val);	
		}	
		//..	LESS "<<"
		ArrayResize(aTemp,0);
		StringToArrayString(aTemp,e,"<<");
		e_rows=ArrayRange(aTemp,0);
		if(e_rows>1){
			col=StrToInteger(aTemp[0]);
			double val=(double)StrToDouble(aTemp[1]);
			AIF_filterAdd_AND(col,AI_LESS,val,val);	
		}	
		//}
	
	}
	
	//-------------------------------------------
	AId_Select2(a,aI);

   xz
}


void WriteFile(string folder="Трассировка")
  {
   if(!bDebug)return;
   int han=FileOpen(folder+".mqh",FILE_WRITE|FILE_TXT|FILE_ANSI," ");
   if(han!=INVALID_HANDLE)
     {
      FileWrite(han,com);
      FileClose(han);
     }
   else Print("File open failed "+folder+".mqh, error",GetLastError());
  }