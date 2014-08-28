   /**
		\version	0.0.0.7
		\date		2014.08.06
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


#define SYSBASE

class CDebuggerFix { } ExtDebuggerFix;

string com="";
string comadd=""; 

#ifdef DEBUG
   #define DPRINT(text) if(DEBUG)Print(__FUNCTION__+" :: "+(string)text);
   #define DAIdPRINT(a,aI,text) if(DEBUG){AId_Print2(a,aI,4,__FUNCTION__+"_"+text);}
   #define DAIdPRINTALL(a,text) if(DEBUG){Print("DAIdPRINTALL"); int atI[]; ArrayResize(atI,0,1000); AId_Init2(a,atI); AId_Print2(a,atI,4,__FUNCTION__+"_"+text);}
     
   #define DPRINT2(text)
   #define DAIdPRINT2(a,aI,text)
   #define DAIdPRINTALL2(a,text) 
#else 
   #ifdef DEBUG2
      #define DPRINT2(text) Print(__FUNCTION__+" :: "+(string)text);
      #define DAIdPRINT2(a,aI,text) AId_Print2(a,aI,Digits,__FUNCTION__+"_"+text);
      #define DAIdPRINTALL2(a,text) Print("DAIdPRINTALL"); int atI[]; ArrayResize(atI,0,1000); AId_Init2(a,atI); AId_Print2(a,atI,Digits,__FUNCTION__+"_"+text);
   #else
      #define DPRINT2(text)
      #define DAIdPRINT2(a,aI,text)
      #define DAIdPRINTALL2(a,text)   
   #endif 
   
   #define DPRINT(text)
   #define DAIdPRINT(a,aI,text)
   #define DAIdPRINTALL(a,text)
   
#endif    

bool bDebug3=false;
#ifdef DEBUG3
   input bool Debug=true;
   
   #define DAIdPRINTALL3(a,text) if(Debug){Print("DAIdPRINTALL"); int atI[]; ArrayResize(atI,0,1000); AId_Init2(a,atI); AId_Print2(a,atI,Digits,__FUNCTION__+"_"+text);}
   #define DAIdPRINT3(a,aI,text) AId_Print2(a,aI,Digits,__FUNCTION__+"_"+text);
   #define DPRINT3(text) Print(__FUNCTION__+" :: "+(string)text);
#else 
    #define DAIdPRINTALL3(a,text)
    #define DAIdPRINT3(a,aI,text)
    #define DPRINT3(text)  
#endif 

#define BEFORE(a) AId_Print2(a,aI,4,"line_before"+__LINE__);
#define AFTER(a) AId_Print2(a,aI,4,"line_after"+__LINE__);
#define IFDEBUG_BEFORE #ifdef	DEBUG BEFORE #endif
#define IFDEBUG_AFTER #ifdef DEBUG AFTER #endif 
#define IFDEBUG2_BEFORE(a) #ifdef	DEBUG2 BEFORE(a) #endif
#define IFDEBUG2_AFTER(a) #ifdef DEBUG2 AFTER(a) #endif

#define tmr int tmrstrt=GetTickCount();
#define ctmr " tmr:"+(string)(GetTickCount()-tmrstrt)
#define zx #ifdef TRACING DPRINT2(__FUNCSIG__); #endif 
#define xz

bool SELECT_UsePreselectedArray=false;

#define SELECT(a,text) int aI[]; ArrayResize(aI,0,1000); AId_Init2(a,aI); B_Select(a, aI, text);
#define SELECT2(a,aI,text) if(!SELECT_UsePreselectedArray) {ArrayResize(aI,0,1000); AId_Init2(a,aI);} B_Select(a, aI, text);  SELECT_UsePreselectedArray=false;

#define ROWS(aI) ArrayRange(aI,0)
	
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property strict
#property library

bool bNeedDelClosed=true;  //автоматическое удаление закрытых ордеров.
                           //устанавливается при инициализации советника.
                           //если установлено значение false то необходимо 
                           //обеспечить ручную очистку массива aOE.

bool B_BSEL=false;
bool isTick=false;

#include <sysOther.mqh> //{
#include <sysNormalize.mqh>
#include <sysStructure.mqh>

#include <sysDT.mqh>

#include <sysIndexedArray.mqh>

#include <sysOE.mqh>
#include <sysTerminal.mqh>
#include <sysEvents.mqh> 
#include <sysTrades.mqh>
//}	

#define TOPENBUYPOS if(OrdersTotal()==0){TR_SendBUY(0.1);}

void B_Init(string expert_name="")export{
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
	
	
	if(!IsTesting()){
	   string file_oe=B_DBOE(expert_name);
	   AId_RFF2(aOE,file_oe);
	}   
	
	T_Start();
}

void B_Deinit(string expert_name="")export{
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
	string file_oe=B_DBOE(expert_name);
	AId_STF2(aOE,file_oe);
	//WriteFile();
}

void B_Start(string expert_name="")export{
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
	//if(bNeedDelClosed){OE_delClosed(); bNeedDelClosed=false;}
   if(bNeedDelClosed){OE_delClosed();}
	isTick=true;
	E_Start();
	
	if(!IsTesting()){
	   string file_oe=B_DBOE(expert_name);
	   AId_STF2(aOE,file_oe);
	}
	xz
}

string B_DBOE(string expert_name){
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
	#ifdef EXP
	   expert_name=EXP;
	#endif    
	
	string file=StringConcatenate("OE.",expert_name,".",AccountNumber(),".",Symbol(),".tdb");
	
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
	string fn="B_Select";
	
	#ifdef SYSTRADES
	  // Alert("defined SYSTRADES");
   	if(StringFind(f,((string)OE_MN+"=="))<0)	f=StringConcatenate(OE_MN,"==",TR_MN," AND ",f);	
   	DPRINT2("f="+f);
	#endif 
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
			col=StrToInteger(aTemp[0]);
			val=StrToDouble(aTemp[1]);
			
			AIF_filterAdd_AND(col,AI_EQ,val,val);	
		}
		
		//..	GREAT ">>"
		ArrayResize(aTemp,0);
		StringToArrayString(aTemp,e,">>");
		e_rows=ArrayRange(aTemp,0);
		if(e_rows>1){
			col=StrToInteger(aTemp[0]);
			val=(double)StrToDouble(aTemp[1]);
			
			AIF_filterAdd_AND(col,AI_GREAT,val,val);	
		}	
		
		//..	GREAT ">="
		ArrayResize(aTemp,0);
		StringToArrayString(aTemp,e,">=");
		e_rows=ArrayRange(aTemp,0);
		if(e_rows>1){
			col=StrToInteger(aTemp[0]);
			val=(double)StrToDouble(aTemp[1]);
			
			AIF_filterAdd_AND(col,AI_GREAT_OR_EQ,val,val);	
		}	
		//..	LESS "<<"
		ArrayResize(aTemp,0);
		StringToArrayString(aTemp,e,"<<");
		e_rows=ArrayRange(aTemp,0);
		if(e_rows>1){
			col=StrToInteger(aTemp[0]);
			val=(double)StrToDouble(aTemp[1]);
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
   //if(!bDebug)return;
   int han=FileOpen(folder+".mqh",FILE_WRITE|FILE_TXT|FILE_ANSI," ");
   if(han!=INVALID_HANDLE)
     {
      FileWrite(han,com);
      FileClose(han);
     }
   else Print("File open failed "+folder+".mqh, error",GetLastError());
  }