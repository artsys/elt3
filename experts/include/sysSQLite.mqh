/**
	\version	0.0.0.24
	\date		2013.05.10
	\author		Morochin <artamir> Artiom
	\details	Detailed description
	\internal
		>Hist:																								
				 @0.0.0.24@2013.05.10@artamir	[]	SQL_getColName
				 @0.0.0.23@2013.05.10@artamir	[]	SQL_Query
				 @0.0.0.22@2013.05.10@artamir	[]	SQL_AddHandle
				 @0.0.0.21@2013.05.10@artamir	[]	SQL_setStandartDataByTI
				 @0.0.0.20@2013.05.10@artamir	[]	SQL_setStandartDataByTI
				 @0.0.0.19@2013.05.10@artamir	[]	SQL_TEST_SETSTANDARTDATA
				 @0.0.0.18@2013.05.10@artamir	[]	SQL_getColName
				 @0.0.0.17@2013.05.10@artamir	[]	SQL_TEST_SELECTBYTI
				 @0.0.0.16@2013.05.10@artamir	[]	SQL_TEST_SELECTBYTI
				 @0.0.0.15@2013.05.10@artamir	[]	SQL_SelectByTI
				 @0.0.0.14@2013.05.08@artamir	[]	SQL_CheckTable
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

#define SQLVER	"0.0.0.24_2013.05.10"

#define SQLSTRUC_HA		0	//Handle
#define SQLSTRUC_COLS	1	//COUNT COLS
#define SQLSTRUC_ROWS	2	//COUNT ROWS
#define SQLSTRUC_MAX	3	//MAX ROWS IN STRUC

#define	SQL_TI	0	//OrderTicket()
#define	SQL_TY	1	//OrderType()
#define	SQL_OOP	2	//OrderOpenPrice()
#define	SQL_OOT	3	//OrderOpenTime()
#define	SQL_TP	4	//OrderTakeProfit()
#define	SQL_SL	5	//OrderStopLoss()
#define	SQL_MN	6	//OrderMagicNumber()
#define	SQL_LOT	7	//OrderLots()
#define	SQL_SY	8	//OrderSymbol()
#define SQL_OP	9	//OrderProfit()
#define	SQL_IW	10	//Is in Terminal() if order is in terminal
#define	SQL_IM	11	//IsMarket() if order type is OP_BUY || OP_SELL
#define	SQL_IP	12	//IsPending() if order type >= 2
#define SQL_IC	13	//IsClosed()
#define SQL_CT	14	//CloseTime()
#define SQL_CP	15	//ClosePrice()
#define SQL_MAX 16	//MAX COLS


string	SQL_DB = "";
int	SQL_Handles[];
string SQL_ColsDesc[];

string 	SQL_getColName(int col){
	/**
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_getColName
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_getColName
			>Rev:0
	*/

	
	if(col == 0){
		return("TI");
	}
	
	if(col == 1){
		return("TY");
	}
	
	if(col == 2){
		return("OOP");
	}
	
	if(col == 3){
		return("OOT");
	}
	
	if(col == 4){
		return("TP");
	}
	
	if(col == 5){
		return("SL");
	}
	
	if(col == 6){
		return("MN");
	}
	
	if(col == 7){
		return("LOT");
	}
	
	if(col == 8){
		return("SY");
	}
	
	if(col == 9){
		return("OP");
	}
	
	if(col == 10){
		return("IW");
	}
	
	if(col == 11){
		return("IP");
	}
	
	if(col == 12){
		return("IM");
	}
	
	if(col == 13){
		return("IC");
	}
	
	if(col == 14){
		return("CT");
	}
	
	if(col == 15){
		return("CP");
	}
	
}

void	SQL_InitColsArray(){
	/**
		\version	0.0.0.0
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

	ArrayResize(SQL_ColsDesc, SQL_MAX);
	SQL_ColsDesc[0] = "@nTI@tINTEGER";
	SQL_ColsDesc[1] = "@nTY@tINTEGER";
	SQL_ColsDesc[2] = "@nOOP@tREAL";
	SQL_ColsDesc[3] = "@nOOT@tINTEGER";
	SQL_ColsDesc[4] = "@nTP@tREAL";
	SQL_ColsDesc[5] = "@nSL@tREAL";
	SQL_ColsDesc[6] = "@nMN@tINTEGER";
	SQL_ColsDesc[7] = "@nLOT@tREAL";
	SQL_ColsDesc[8] = "@nSY@tTEXT";
	SQL_ColsDesc[9] = "@nOP@tREAL";
	SQL_ColsDesc[10] = "@nIW@tINTEGER";
	SQL_ColsDesc[11] = "@nIP@tINTEGER";
	SQL_ColsDesc[12] = "@nIM@tINTEGER";
	SQL_ColsDesc[13] = "@nIC@tINTEGER";
	SQL_ColsDesc[14] = "@nCT@tINTEGER";
	SQL_ColsDesc[15] = "@nCP@tREAL";
	
}

void 	SQL_AddHandle(int h){
	/**
		\version	0.0.0.1
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_AddHandle
			>Rev:0
	*/
	
	int ROWS = ArrayRange(SQL_Handles, 0);
	int New_ROWS = ROWS+1;
	ArrayResize(SQL_Handles, New_ROWS);
	SQL_Handles[New_ROWS-1] = h;
}

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

int		SQL_Exec(string db, string exp){
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
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Exec sqlite query and return handle of the query
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_Query
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_Query
			>Rev:0
	*/
	
	int handle = sqlite_query(db, sql, cols);
	
	SQL_AddHandle(handle);
	
	return(handle);
}

void	SQL_CheckTable(string db){
	/**
		\version	0.0.0.2
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_CheckTable
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_CheckTable
			>Rev:0
	*/

	
	if(SQL_IsTableExist(db, "OE")){
		return;
	}
	
	string q = "CREATE TABLE OE (";
	q = q + " "+SQL_getColName(0)+" INTEGER";	//TI
	q = q + ", "+SQL_getColName(1)+" INTEGER";	//TY
	q = q + ", "+SQL_getColName(2)+" REAL";		//OOP
	q = q + ", "+SQL_getColName(3)+" INTEGER";	//OOT
	q = q + ", "+SQL_getColName(4)+" REAL";		//TP
	q = q + ", "+SQL_getColName(5)+" REAL";		//SL
	q = q + ", "+SQL_getColName(6)+" INTEGER";	//MN
	q = q + ", "+SQL_getColName(7)+" REAL";		//LOT
	q = q + ", "+SQL_getColName(8)+" TEXT";		//SY
	q = q + ", "+SQL_getColName(9)+" REAL";		//OP
	q = q + ", "+SQL_getColName(10)+" INTEGER";	//** is working
	q = q + ", "+SQL_getColName(11)+" INTEGER";	//** is pending
	q = q + ", "+SQL_getColName(12)+" INTEGER";	//** is market
	q = q + ", "+SQL_getColName(13)+" INTEGER";	//** is closed
	q = q + ", "+SQL_getColName(14)+" INTEGER";	//** close time
	q = q + ", "+SQL_getColName(15)+" REAL";		//** close price
	
	q = q + ")";
	
	SQL_Exec(db, q);
		
}

void	SQL_Init(){
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
	
	SQL_DB = TerminalPath()+"\\experts\\files\\"+_fn;
	
	SQL_InitColsArray();
	SQL_CheckTable(SQL_DB);
}

void	SQL_Deinit(){
	/**
		\version	0.0.0.0
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Деинициализация SQLite
		\internal
			>Hist:
			>Rev:0
	*/

	int ROWS = ArrayRange(SQL_Handles,0);
	for(int i = 0; i<ROWS; i++){
		sqlite_free_query(SQL_Handles[i]);
	}
	
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

int SQL_Update(string& aKeyVal[][], string where = ""){
	/**
		\version	0.0.0.0
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	string q = "UPDATE OE SET ";
	string exp = "";
	
	int ROWS = ArrayRange(aKeyVal,0);
	
	for(int idx = 0; idx < ROWS; idx++){
		
		if(StringLen(aKeyVal[idx][0]) == 0) continue;
		
		if(idx > 0){
			exp = exp + ",";
		}
		
		exp = exp + aKeyVal[idx][0] +"="+ aKeyVal[idx][1];
	}
	
	q = q + exp + " WHERE " + where;
	
	return(SQL_Exec(SQL_DB, q));
}

int SQL_SelectByTI(int ti /** ticket*/, int& struc[]	/** array 0 - handle 1 - row counts	*/){
	/**
		\version	0.0.0.1
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Return handle of query by col TI
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_SelectByTI
			>Rev:0
	*/

	string select = "SELECT * FROM OE WHERE TI = "+ti;
	
	int cols[1];
	
	int handle = SQL_Query(SQL_DB, select, cols);
	
	int rows = 0;
	while(sqlite_next_row(handle) == 1){
		rows++;
	}
	
	struc[0] = handle;
	struc[1] = cols[0];
	struc[2] = rows;
	
	//------------------------------------
	return(rows);
}

//{ === SET STANDART DATA
int SQL_setStandartDataByTI(int ti){
	/**
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Устанавливает стандартные данные по тикету
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_setStandartDataByTI
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_setStandartDataByTI
			>Rev:0
	*/

	int struc[SQLSTRUC_MAX];
	
	if(!OrderSelect(ti, SELECT_BY_TICKET)) return(-1);
	
	int ROWS = SQL_SelectByTI(ti, struc);
	
	string aKeyVal[SQL_MAX][2];
	
	int r = -1;
	
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_TI); aKeyVal[r][1] = OrderTicket();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_TY); aKeyVal[r][1] = OrderType();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_OOP); aKeyVal[r][1] = Norm_symb(OrderOpenPrice(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_OOT); aKeyVal[r][1] = OrderOpenTime();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_TP); aKeyVal[r][1] = Norm_symb(OrderTakeProfit(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_SL); aKeyVal[r][1] = Norm_symb(OrderStopLoss(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_MN); aKeyVal[r][1] = OrderMagicNumber();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_LOT); aKeyVal[r][1] = Norm_symb(OrderLots(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_SY); aKeyVal[r][1] = "'"+OrderSymbol()+"'";
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_OP); aKeyVal[r][1] = Norm_symb(OrderProfit(), Symbol(), 2);
	
	int res = -1;
	
	if(ROWS >= 1){
		res = SQL_Update(aKeyVal, "TI="+ti);
	}else{
		res = SQL_Insert(aKeyVal);
	}
	
	Print("SQL_setStandartDataByTI res = "+res);
} 
//}

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
		
		/*
			static int test_insert;
			if(test_insert <= 0){//
				SQL_TEST_INSERT();
				test_insert++;
			}//

			static int test_update;
			if(test_update <= 0){//
				SQL_TEST_UPDATE();
				test_update++;
			}//
		*/
	
	static int test_setstandartdata;
	if(test_setstandartdata <= 1){
		test_setstandartdata++;
		
		SQL_TEST_SETSTANDARTDATA();
	}
	
	static int test_select;
	if(test_select <= 10){
		SQL_TEST_SELECT();
		test_select++;
	}
	
	static int test_selectByTI;
	if(test_selectByTI <= 1){
		SQL_TEST_SELECTBYTI();
		test_selectByTI++;
	}
}

int SQL_TEST_INSERT(){
	/**
		\version	0.0.0.1
		\date		2013.05.08
		\author		Morochin "artamir" Artiom
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
		
		//a[1][0] = "TY";
		//a[1][1] = OrderType();
		
		int res = SQL_Insert(a);
	}
}	

int SQL_TEST_UPDATE(){
	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		string a[10][2];
		a[0][0] = "TY";
		a[0][1] = OrderType();
		
		a[1][0] = "LOT";
		a[1][1] = OrderLots();
		
		a[2][0] = "SY";
		a[2][1] = "'"+OrderSymbol()+"'";
		
		string where = "TI="+OrderTicket();
		
		int res = SQL_Update(a, where);
	}
}

int SQL_TEST_SELECT(){
	/**
		\version	0.0.0.0
		\date		2013.05.09
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

	string select = "SELECT * FROM OE";
	int cols[1];
	
	int handle = sqlite_query(SQL_DB, select, cols);
	
	while(sqlite_next_row(handle) == 1){
		for(int i = 0; i < cols[0]; i++){
			Print(sqlite_get_col(handle, i));
		}
	}
	
	sqlite_free_query(handle);
}

int SQL_TEST_SELECTBYTI(){
	/**
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_TEST_SELECTBYTI
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_TEST_SELECTBYTI
			>Rev:0
	*/

	int struc[3];
	
	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		SQL_SelectByTI(OrderTicket(), struc);
		A_d_PrintArray1(struc, 0, "SelectByTI_struc");
	}
	
	SQL_SelectByTI(1234567, struc);
	A_d_PrintArray1(struc, 0, "SelectByTI_struc");

}



int SQL_TEST_SETSTANDARTDATA(){
	/**
		\version	0.0.0.1
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_TEST_SETSTANDARTDATA
			>Rev:0
	*/

	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		SQL_setStandartDataByTI(OrderTicket());
	}

}	
//}