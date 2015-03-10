//+------------------------------------------------------------------+
//|                                                       !sqlEA.mqh |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property strict

#define zx
#define xz

#include <System\MQH\Lib\SQLite3\SQLite3Base.mqh>
CSQLite3Base sql3;

#include <System\sysNormalize.mqh>
#include <System\sysTrades.mqh>


#include <System\sqlBase.mqh>
#include <System\sqlTickets.mqh>
#include <System\sqlEvents.mqh>

class CSqlEA: public CSqlBase{
	private:
		CSqlTickets oTickets;
		CSqlEvents oEvents;
	public:
		//уникальный идентификатор сессии.
		//Обновляется, если закрыты все ордера,
		//которые обрабатывает советник.
		int SessionId; 
		
	public:
		CSqlEA(){};
		~CSqlEA(){};
		
	public:
		void Init();
		void Start();
};

CSqlEA::Init(void){
	Print(__FUNCTION__);
	sql3.Connect(DbFileName);
	oTickets.Init();
	oEvents.Init();
}

CSqlEA::Start(void){
	oEvents.Start();
	oTickets.Start();
}