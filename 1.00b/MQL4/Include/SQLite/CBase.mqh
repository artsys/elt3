//+------------------------------------------------------------------+
//|                                                        CBase.mqh |
//|                                                          artamir |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://www.mql5.com"
#property strict

#include <SQLite\MQH\Lib\SQLite3\SQLite3Base.mqh>

$Revision$

class CCell: public CSQLite3Cell{
	public:
		string ver;
		string key;
		string val;
		
		template<typename T>
		CCell(string k, T val){
			ver="$Revision$";
			key=k;
			Set(val);
		};
		~CCell(){};
};