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
		//���������� ������������� ������.
		//�����������, ���� ������� ��� ������,
		//������� ������������ ��������.
		int SessionId; 
		
	public:
		CSqlEA(){};
		~CSqlEA(){};
		
	public:
		void Init();
		void Start();
	
	public:
		string QText; //����� �������	
	private:
		string m_CompText; //����� ������� � �������������� �����������.
	
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
			
			//����� ���������� �������, ��� ������������� 
			//��������� ������������.
			//� ��� ������ ������� � �������� �������
			//��������� ����� �������� ������.
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