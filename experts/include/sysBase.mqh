	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	���� ��� ����������. ������� ��������� ��������/�������.
		��� ���������� ������ ����������, ���� � ���������� ���� ���������� ���������: EXP - ���������� ��� ��������, ������ ��� �������� ������ ������ ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	B_DBOE
			>Rev:0
	*/
	
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property strict

#include <sysOther.mqh> //{
#include <sysNormalyze.mqh>
#include <sysStructure.mqh>

#include <sysDT.mqh>

#include <sysIndexedArray.mqh>

#include <sysOE.mqh>
#include <sysEvents.mqh> //}	

void B_Init(){
	/**
		\version	0.0.0.0
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	������������� ��������� ��������. �������� ����������� ������.
		\internal
			>Hist:
			>Rev:0
	*/

	string file_oe=B_DBOE();
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