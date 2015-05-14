//+------------------------------------------------------------------+
//|                                                        CBase.mqh |
//|                                                          artamir |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://www.mql5.com"
#property strict

#include <SQLite\MQH\Lib\SQLite3\SQLite3Base.mqh>
#define VER ver="$Revision$"

class CCell: public CSQLite3Cell{
	public:
		string ver;
		string key;
		string val;
		
		CCell(const CCell &c){
			VER;
			key=c.key;
			val=c.val;
			Set(c.val);
		};
		
		template<typename T>
		CCell(string k, T v){
			VER;
			key=k;
			val=v;
			Set(v);
		};
		
		~CCell(){};
};

class CRow: public CSQLite3Row{
	public:
		template<typename T>
		void Add(string k, T a){
			CCell c(k,a);
			Add(c);
		};
		
};

class CTbl: public CSQLite3Table{};