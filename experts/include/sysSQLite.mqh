/**
	\version	0.0.0.13
	\date		2013.05.08
	\author		Morochin <artamir> Artiom
	\details	Detailed description
	\internal
		>Hist:													
				 @0.0.0.13@2013.05.08@artamir	[]	SQL_Exec
				 @0.0.0.12@2013.05.08@artamir	[]	SQL_Main
				 @0.0.0.11@2013.05.08@artamir	[]	SQL_Insert
				 @0.0.0.10@2013.05.08@artamir	[]	SQL_TESTS
				 @0.0.0.9@2013.05.08@artamir	[]	SQL_TEST_INSERT
				 @0.0.0.8@2013.05.08@artamir	[]	SQL_Insert
				 @0.0.0.7@2013.05.08@artamir	[]	SQL_Query
				 @0.0.0.6@2013.05.07@artamir	[]	SQL_Main
				 @0.0.0.5@2013.05.07@artamir	[]	SQL_CheckTable
				 @0.0.0.4@2013.05.07@artamir	[]	SQL_Exec
				 @0.0.0.3@2013.05.07@artamir	[]	SQL_Exec
				 @0.0.0.2@2013.05.07@artamir	[]	SQL_IsTableExist
		>Rev:0
*/


// * SQLite interface for MT4
#import "sqlite3_wrapper.dll"	//{
int sqlite_exec (string db_fname, string sql);
int sqlite_table_exists (string db_fname, string table);
int sqlite_query (string db_fname, string sql, int& cols[]);
int sqlite_next_row (int handle);
string sqlite_get_col (int handle, int col);
int sqlite_free_query (int handle);
string sqlite_get_fname (string db_fname);
void sqlite_set_busy_timeout (int ms);
void sqlite_set_journal_mode (string mode);
#import	//}

string	SQL_DB = "";

bool	SQL_IsTableExist(string db, string table){
	/**
		\version	0.0.0.1
		\date		2013.05.07
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_IsTableExist
			>Rev:0
	*/
	
	int res = sqlite_table_exists (db, table);

    if (res < 0) {
        Print ("Check for table existence failed with code " + res);
        return (false);
    }

    return (res > 0);
}

int	SQL_Exec(string db, string exp){
	/**
		\version	0.0.0.3
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.0.3@2013.05.08@artamir	[]	SQL_Exec
					 @0.0.0.2@2013.05.07@artamir	[]	SQL_Exec
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_Exec
			>Rev:0
	*/
	
	int res = sqlite_exec (db, exp);
    
    if (res != 0)
        Print ("Expression '" + exp + "' failed with code " + res);
		
	return(res);	
}

int		SQL_Query(string db, string sql, int& cols[]){
	/**
		\version	0.0.0.1
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Exec sqlite query and return handle of the query
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_Query
			>Rev:0
	*/

	return(sqlite_query(db,sql,cols));
}

void	SQL_CheckTable(string db){
	/**
		\version	0.0.0.1
		\date		2013.05.07
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_CheckTable
			>Rev:0
	*/

	
	if(SQL_IsTableExist(db, "OE")){
		return;
	}
	
	string q = "CREATE TABLE OE (";
	q = q + "	TI	INTEGER";
	q = q + ",	TY	INTEGER";
	q = q + ",	LOT REAL";
	q = q + ",	OOP REAL";
	q = q + ",	OOT INTEGER";
	q = q + ",	TP	REAL";
	q = q + ",	SL	REAL";
	q = q + ")";
	
	SQL_Exec(db, q);
		
}

void	SQL_Main(){
	/**
		\version	0.0.0.2
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_Main
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_Main
			>Rev:0
	*/
	string _fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"OE.db";
	Print(_fn);
	
	SQL_DB = TerminalPath()+"\\experts\\files\\"+_fn;
	Print(SQL_DB);
	SQL_CheckTable(SQL_DB);
}

int	SQL_Insert(string& aKeyVal[][], string select = ""){
	/**
		\version	0.0.0.2
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Create new row and fill cols
					if select != "" then insert used with select
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_Insert
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_Insert
			>Rev:0
	*/

	int ROWS = ArrayRange(aKeyVal,0);
	int idx = 0;
	
	string q = "INSERT OR REPLACE INTO OE ";
	string q_cols = "(";
	string q_vals = "VALUES (";
	
	for(idx = 0; idx < ROWS; idx++){
		//BP("SQL_Insert", "aKeyVal["+idx+"][0] = ", aKeyVal[idx][0], "StringLen() = ", StringLen(aKeyVal[idx][0]));
		if(StringLen(aKeyVal[idx][0]) == 0) continue;
		
		if(idx >= 1){
			q_cols = q_cols + ", ";
			q_vals = q_vals + ", ";
		}
		
		q_cols = q_cols + aKeyVal[idx][0];
		q_vals = q_vals + aKeyVal[idx][1];
	}
	
	q_cols = q_cols + ")";
	q_vals = q_vals + ")";
	
	q = q + q_cols +" "+ q_vals;
	//BP("SQL_Insert","SQL_DB = ", SQL_DB);
	
	if(StringLen(select) > 0){
		q = select;
	}
	
	return(SQL_Exec(SQL_DB, q));	
}

//{	=== TESTS
void	SQL_TESTS(){
	/**
		\version	0.0.0.1
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_TESTS
			>Rev:0
	*/

	//=== INSERT OR REPLACE
	SQL_TEST_INSERT();
}

int SQL_TEST_INSERT(){
	/**
		\version	0.0.0.1
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_TEST_INSERT
			>Rev:0
	*/
	
	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		string a[10][2];
		a[0][0] = "TI";
		a[0][1] = OrderTicket();
		
		string select = "'SELECT * FROM OE'";
		a[1][0] = "select";
		a[1][1] = select;
		//a[1][0] = "TY";
		//a[1][1] = OrderType();
		
		int res = SQL_Insert(a);
	}
}	
//}