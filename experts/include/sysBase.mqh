	/**
		\version	0.0.0.5
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	���� ��� ����������. ������� ��������� ��������/�������.
		��� ���������� ������ ����������, ���� � ���������� ���� ���������� ���������: EXP - ���������� ��� ��������, ������ ��� �������� ������ ������ ��������.
		\internal
			>Hist:					
					 @0.0.0.5@2014.03.06@artamir	[]	B_Select
					 @0.0.0.4@2014.03.03@artamir	[+]	B_Start
					 @0.0.0.3@2014.03.03@artamir	[+]	B_Init
					 @0.0.0.2@2014.03.03@artamir	[+]	B_Deinit
					 @0.0.0.1@2014.03.03@artamir	[+]	B_DBOE
			>Rev:0
	*/
	
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property strict

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
		\details	������������� ��������� ��������. �������� ����������� ������.
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
		\details	��������������� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	B_Deinit
			>Rev:0
	*/
	string file_oe=B_DBOE();
	AId_STF2(aOE,file_oe);
}

void B_Start(){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	���������� �� ������� ����� ���������.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	B_Start
			>Rev:0
	*/

	E_Start();
}

string B_DBOE(){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	��� �����-��������� ������ aOE.
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
		\details	������� �� �������.
		\internal
			>Hist:			
					 @0.0.0.2@2014.03.06@artamir	[!]	�������� ������������ ����� �� ������.
					 @0.0.0.1@2014.01.23@artamir	[+]	Select
			>Rev:0
	*/

	string fn="Select";
	
	f=StringConcatenate(OE_MN,"==",TR_MN," AND ");	
	AIF_init();
	
	//1. ������������ ������ f �� ����������� " AND "
	string del=" AND ";
	string aAnd[];
	ArrayResize(aAnd,0);
	
	StringToArrayString(aAnd, f, del);
	int and_rows=ArrayRange(aAnd,0);

	for(int i=0;i<and_rows;i++){
		string e=aAnd[i];
		string aE[];
		
		//{		EQ "=="
		ArrayResize(aE,0);
		StringToArrayString(aE,e,"==");
		int e_rows=ArrayRange(aE,0);
		int col=-1,val=0.0;
		
		if(e_rows>1){
			int col=StrToInteger(aE[0]);
			double val=StrToDouble(aE[1]);
			
			AIF_filterAdd_AND(col,AI_EQ,val,val);	
		}
		
		//..	GREAT ">>"
		ArrayResize(aE,0);
		StringToArrayString(aE,e,">>");
		e_rows=ArrayRange(aE,0);
		if(e_rows>1){
			col=StrToInteger(aE[0]);
			val=StrToDouble(aE[1]);
			
			AIF_filterAdd_AND(col,AI_GREAT,val,val);	
		}	
		//..	LESS "<<"
		ArrayResize(aE,0);
		StringToArrayString(aE,e,"<<");
		e_rows=ArrayRange(aE,0);
		if(e_rows>1){
			col=StrToInteger(aE[0]);
			val=StrToDouble(aE[1]);
			AIF_filterAdd_AND(col,AI_LESS,val,val);	
		}	
		//}
	
	}
	
	//-------------------------------------------
	AId_Select2(a,aI);
}
