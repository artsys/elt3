	/**
		\version	0.0.0.4
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	База для советников. Сборник сервисных процедур/функций.
		Для правильной работы необходимо, чтоб в советниках были определены константы: EXP - Уникальное имя эксперта, нужное для создания файлов данных эксперта.
		\internal
			>Hist:				
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
#include <sysEvents.mqh> //}	

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

	E_Start();
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