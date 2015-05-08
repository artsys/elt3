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
	public:
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
	
	public:
		string QText; //текст запроса	
	private:
		string m_CompText; //текст запроса с установленными параметрами.
	
	public:	
		void SetParam(string name, string val){
			string s="";
			if(m_CompText==""){
				s=m_CompText;
			}else{
				s=QText;
			}
			
			StringReplace(s,name,val);
			
			m_CompText=s;
		};
		
		CSQLite3Table	Query(string q=""){
			
			//После выполнения запроса, все установленные 
			//параметры сбрасываются.
			//и для нового запроса с подобным текстом
			//параметры нужно задавать заново.
			CSQLite3Table tbl;
			
			if(q==""){
				if(m_CompText==""){
					q=QText;
				}else{
					q=m_CompText;
				}
			}
			
			int res=sql3.Query(tbl,q);
			if(res!=SQLITE_DONE){
				SQLITE_ERR;
			}	
			
			m_CompText=""
			return(tbl);
		}
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