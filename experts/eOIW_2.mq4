	/**
		\version	0.0.0.0
		\date		2013.09.24
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

//{ === DEFINES
#define EXP	"eOIW"	/** имя эксперта */
#define VER	"3.0.1.22_2013.09.19"
#define DATE "2013.09.05"	/** extert date */	
//}	

bool isStarted=true;
int max_start_timer=0;
int elt_start=0;
int cfp = 0;
int cnv_all = 0;
int cnt=0;
int cnv=0;
int sp=0;
int set=0;
int np=0;
int set_mn=0;
int elt_mn_flt=0;
int elt_mn_sl=0;
int set_sp=0;
int set_so=0;
int elt_so_flt=0;
int elt_so_sl=0;

	
//{ === EXTERN VARIABLES
extern	string	s1="==== MAIN ====="; //{
extern	int			Step=20;	//Шаг между ордерами в пунктах.	
extern	int			TP=150;		//тейкпрофит сетки в пунктах.
extern	double		Lot=0.1;	//Лот родительского ордера.
extern	double		Multy=0.6;	//коэф. для вычисления начального лота. следующих сеток.	
extern	double		Fix=200;	//профит в валюте депозита.
extern	string	e1="==== EXPERT END =====";//}
//}
	
#include <sysELT3.mqh>		//Подключение различных библиотек.
#include <sysSQLite.mqh>	//подключение врппера sqlite
#include <sysSQLite_OE.mqh>	//подключение библиотеки работы с sqlite	
#include <libCloseOrders.mqh>

#define SELECT " SELECT * FROM main "
	
int init(){
	SQL_init();
	return(0);
}

int deinit(){
	SQL_deinit();
	return(0);
}

int start(){
	
	startext();
	
	return(0);
}

int startext(){
	/**
		\version	0.0.0.0
		\date		2013.09.25
		\author		Morochin <artamir> Artiom
		\details	основная функция советника.
		\internal
			>Hist:
			>Rev:0
	*/

	//Print("startext");
	ELT_start();
	SQL_start();	//на каждом запуске этой функции перечитываем данные по ордерам.
	
	//{   Блок закрытия
	//libCO_CFP_Check();
	if(isExpertsTickets()){
		if(FixProfit()){	
			SQL_DELETE();
			return(0);
		}
	}	
	//..  Блок сопровождения
	CheckNets();
	Convoy();
	//..  Блок открытия ордеров.	
		Autoopen();
	//}  
	
}

//{ === Autoopen
void Autoopen(){
	/**
		\version	0.0.0.0
		\date		2013.09.26
		\author		Morochin <artamir> Artiom
		\details	Выставляет отложенные стоповые ордера на расстоянии шаг от цены.
					Условие: если нет живых приказов советника.
					Переписан под sqlite
		\internal
			>Hist:
			>Rev:0
	*/
	if(!isExpertsTickets()){
		SendParent(OP_BUYSTOP, Lot,true); //создаем новую сессию
		SendParent(OP_SELLSTOP, Lot,false);//берем значение максимальной сессии.
	}	
}
//..  Функции советника.
bool isExpertsTickets(){
	/**
		\version	0.0.0.1
		\date		2013.09.04
		\author		Morochin <artamir> Artiom
		\details	проверяет, если существует хоть один живой тикет, который принадлежит советнику.
					Переписана под sqlite
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.04@artamir	[+]	isExpertsTickets
			>Rev:0
	*/
	string fn="isExpertsTickets";
	string	q=  " SELECT * FROM main ";
			q=q+" WHERE ";
			q=q+" MN="+TR_MN;
			q=q+" AND ";
			q=q+" IT="+1;
	
	int qry=Sqlite_Query(SQL_DB,q);
	int rows = Sqlite_RowCount(qry);
	if(rows>=1){return(true);}
	Sqlite_DestroyQuery(qry);
	
	return(false);
}

bool isFTY(int fty){
	/**
		\version	0.0.0.1
		\date		2013.09.04
		\author		Morochin <artamir> Artiom
		\details	проверяет, если существует хоть один живой тикет, который принадлежит советнику.
					Переписана под sqlite
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.04@artamir	[+]	isExpertsTickets
			>Rev:0
	*/
	string	fn="isFTY";
	string	q=  " SELECT * FROM main ";
			q=q+" WHERE ";
			q=q+" MN="+TR_MN;
			q=q+" AND ";
			q=q+" IT="+1;
			q=q+" AND ";
			q=q+" FTY="+fty;
	
	int qry=Sqlite_Query(SQL_DB,q);
	int rows=Sqlite_RowCount(qry);
	if(rows>=1){return(true);}
	Sqlite_DestroyQuery(qry);
	
	return(false);
}

int SelectFTY(int fty){
	/**
		\version	0.0.0.0
		\date		2013.09.26
		\author		Morochin <artamir> Artiom
		\details	Выборка ордеров советника по fty и gl=1
		\internal
			>Hist:
			>Rev:0
	*/
	
	string	q=  " SELECT * FROM main ";
			q=q+" WHERE ";
			q=q+" MN="+TR_MN;
			q=q+" AND ";
			q=q+" IT=1";
			q=q+" AND ";
			q=q+" GL=1";
			q=q+" AND ";
			q=q+" FTY="+fty;
	
	int qry=Sqlite_Query(SQL_DB,q);
	return(qry);
}

int SelectFTY_all(int fty){
	/**
		\version	0.0.0.0
		\date		2013.09.26
		\author		Morochin <artamir> Artiom
		\details	Выборка ордеров советника по fty и gl=1
		\internal
			>Hist:
			>Rev:0
	*/
	
	string	q=  " SELECT * FROM main ";
			q=q+" WHERE ";
			q=q+" MN="+TR_MN;
			q=q+" AND ";
			q=q+" IT=1";
			q=q+" AND ";
			q=q+" GL=1";
			q=q+" AND ";
			q=q+" FTY="+fty;
	
	int qry=Sqlite_Query(SQL_DB,q);
	return(qry);
}

int SelectSID(int sid){
	/**
		\version	0.0.0.0
		\date		2013.09.29
		\author		Morochin <artamir> Artiom
		\details	Выборка ордеров по ид сессии
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="SelectSID";
	string q="";
	q=q+" select * from main ";
	q=q+" where mn="+TR_MN;
	q=q+" and sid="+sid;
	
	int qry=Sqlite_Query(SQL_DB, q);
	return(qry);
}

int SelectPositions(){
	/**
		\version	0.0.0.0
		\date		2013.09.26
		\author		Morochin <artamir> Artiom
		\details	Выборка рыночных ордеров (позиций)
		\internal
			>Hist:
			>Rev:0
	*/
	
	string	q=  " SELECT * FROM main ";
			q=q+" WHERE ";
			q=q+" MN="+TR_MN;
			q=q+" AND ";
			q=q+" IT=1";
			q=q+" AND ";
			q=q+" IM=1";
	
	int qry=Sqlite_Query(SQL_DB,q);
	//if(Sqlite_RowCount(SQL_QRY)>=1){return(true);}
	//Sqlite_DestroyQuery(SQL_QRY);
	
	return(qry);

}

int SelectNearPrice(double pr){
	/**
		\version	0.0.0.0
		\date		2013.09.26
		\author		Morochin <artamir> Artiom
		\details	Выборка рыночных ордеров (позиций)
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="SelectNearPrice";
	double SPR=MarketInfo(Symbol(), MODE_SPREAD)*Point;
	string	q=  " SELECT * FROM main ";
			q=q+" WHERE ";
			q=q+" MN="+TR_MN;
			q=q+" AND ";
			q=q+" IT=1";
			q=q+" AND ";
			q=q+" OOP BETWEEN "+DoubleToStr((pr-SPR),Digits);
			q=q+		" AND "+DoubleToStr((pr+SPR),Digits);
	int qry=Sqlite_Query(SQL_DB,q);
	//if(Sqlite_RowCount(SQL_QRY)>=1){return(true);}
	//Sqlite_DestroyQuery(SQL_QRY);
	
	return(qry);

}

int CalcLevels(){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	Расчет количества ордеров в сетке от родителя до TP
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.05@artamir	[]	CalcLevels
			>Rev:0
	*/
	return(MathFloor(TP/Step)-1);
}

void CheckNets(){
	/**
		\version	0.0.0.1
		\date		2013.09.12
		\author		Morochin <artamir> Artiom
		\details	Проверяет, если существуют сетки.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.12@artamir	[]	CheckNets
			>Rev:0
	*/
	double a[][OE_MAX];
	if(isExpertsTickets()){
		double _lot=-1;
		if(isFTY(OP_BUYSTOP)<=0){
			_lot=getNextLot(OP_BUYSTOP);
			SendParent(OP_BUYSTOP,_lot);
		}
		
		if(isFTY(OP_SELLSTOP)<=0){
			_lot=getNextLot(OP_SELLSTOP);
			SendParent(OP_SELLSTOP,_lot);
		}
	}
}

void Convoy(){
	/**
		\version	0.0.0.2
		\date		2013.09.11
		\author		Morochin <artamir> Artiom
		\details	Сопровождение позиций.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.11@artamir	[]	Convoy
					 @0.0.0.1@2013.09.05@artamir	[+]	Convoy
			>Rev:0
	*/
	string fn="Convoy";
	int qPos = SelectPositions();
	int pos_rows = Sqlite_RowCount(qPos);
	
	for(int pos_i=0;pos_i<pos_rows;pos_i++){
		int parent_ti=SQL_FieldAsInt(qPos,SQL_TI);//aPos[pos_i][OE_TI];
		int parent_ty=SQL_FieldAsInt(qPos,SQL_TY);//aPos[pos_i][OE_TY];
		double parent_op=SQL_FieldAsDouble(qPos,SQL_OOP);//aPos[pos_i][OE_OP];
		double child_op = 0.00;
		if(parent_ty==OP_BUY||parent_ty==OP_BUYSTOP){
			child_op=parent_op-Step*Point;
		}
		
		if(parent_ty==OP_SELL||parent_ty==OP_SELLSTOP){
			child_op=parent_op+Step*Point;
		}
		
		child_op=Norm_symb(child_op);
		int qNP=SelectNearPrice(child_op);	
		int np_rows=Sqlite_RowCount(qNP);	
		
		bool isChild = false;
		for(int np_i=0; np_i<np_rows;np_i++){
			int ty = SQL_FieldAsInt(qNP, SQL_TY);
			if(parent_ty==OP_BUY || parent_ty==OP_BUYSTOP){
				if(ty==OP_SELL || ty==OP_SELLSTOP || ty==OP_SELLLIMIT){
					isChild=true;
					break;
				}
			}
			if(parent_ty==OP_SELL || parent_ty==OP_SELLSTOP){
				if(ty==OP_BUY || ty==OP_BUYSTOP || ty==OP_BUYLIMIT){
					isChild=true;
					break;
				}
			}
			Sqlite_Next(qNP);
		}
		Sqlite_DestroyQuery(qNP);
		
		if(!isChild){SendChild(parent_ti);}
		Sqlite_Next(qPos);
	}
	Sqlite_DestroyQuery(qPos);
}

double getNextLot(int fty){
	/**
		\version	0.0.0.2
		\date		2013.09.19
		\author		Morochin <artamir> Artiom
		\details	Лотность родительского ордера умноженного на коэффицент.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.19@artamir	[+]	getNextLot
			>Rev:0
	*/
	string fn="getNextLot";
	Print(fn);
	string q="";
	q=q+" select MAX(LOT) as LOT from main ";
	q=q+" where fty="+fty;
	q=q+" and mn="+TR_MN;
	q=q+" and gl=1";
	
	int qry=Sqlite_Query(SQL_DB,q);
	int fty_rows = Sqlite_RowCount(qry);
	
	if(fty_rows <= 0){return(Lot);}
	
	double next_lot = Norm_vol(SQL_FieldAsDouble(qry,SQL_LOT)*Multy);
	Sqlite_DestroyQuery(qry);
	return(next_lot);
}

int getMaxGL(int foty){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	Возвращает максимальный уровень сетки для начального типа.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.05@artamir	[+]	getMaxGL
			>Rev:0
	*/

	string	q="";
			q=q+" SELECT MAX(GL) AS GL FROM main";
			q=q+" WHERE ";
			q=q+" MN="+TR_MN;
			q=q+" AND ";
			q=q+" IT=1";
			q=q+" AND ";
			q=q+" FTY="+foty;
			
	int qry=Sqlite_Query(SQL_DB,q);
	int rows=Sqlite_RowCount(qry);
	
	if(rows<=0){return(1);}
	
	int res=1;
	res=SQL_FieldAsInt(qry,SQL_GL);
	Sqlite_DestroyQuery(qry);
	return(res);
}

double getTPNet(int ty){
	/**
		\version	0.0.0.0
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	Возвращает тп по типу ордеров в сетке.
		\internal
			>Hist:
			>Rev:0
	*/
	

	int qFty=SelectFTY(ty);
	int gl_rows=Sqlite_RowCount(qFty);
	if(gl_rows<=0){return(0);} //нет родителя сетки.
	
	double tp = SQL_FieldAsDouble(qFty,SQL_TP); //если есть хоть один родитель сетки, то он будет в 0-м индексе.
	
	Sqlite_DestroyQuery(qFty);
	
	return(tp);
	
}

int getMaxSID(){
	/**
		\version	0.0.0.0
		\date		2013.09.29
		\author		Morochin <artamir> Artiom
		\details	Возвращает максимальный ИД Сессии.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="getMaxSID";
	//Print(fn);
	string q="";
	q=q+" SELECT MAX(SID) AS SID FROM main ";
	//q=q+" where mn="+TR_MN;
	int qry=Sqlite_Query(SQL_DB,q);
	//Print(fn+".qry="+qry);
	int rows=Sqlite_RowCount(qry);
	if(rows<=0){return(1);}
	int res=SQL_FieldAsInt(qry,SQL_SID);
	Sqlite_DestroyQuery(qry);
	
	return(res);
}
//..  Выставление ордеров
int SendParent(int ty, double lot=-1, bool new_sid=false){
	/**
		\version	0.0.0.0
		\date		2013.09.12
		\author		Morochin <artamir> Artiom
		\details	Выставление массива родительских ордеров
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="SendParent";
	Print(fn);
	Print(fn+".new_sid="+new_sid);
	double a[];
	double start_pr=0.00;
	if(lot<=0){lot=MarketInfo(Symbol(), MODE_MINLOT);}
	int rows_a=TR_SendPending_array(a, ty, start_pr, Step, lot);
	
	for(int i=0; i<rows_a;i++){
		SQL_setGLByTicket(a[i],1);
		SQL_setFOD(a[i]);
		int sid = getMaxSID();
		Print(fn+".getSID="+sid);
		if(new_sid){sid=sid+1;}
		Print(fn+".outsid="+sid);
		SQL_setSIDByTicket(a[i], sid);
		TR_ModifyTP(a[i],TP,TR_MODE_PIP);
		SendSTOPNet(a[i]);
	}
}

int SendChild(int parent_ti){
	/**
		\version	0.0.0.4
		\date		2013.09.12
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:				
					 @0.0.0.4@2013.09.12@artamir	[*]	Для выставления байстоп ордера нужно чтоб цена была ниже цены открытия селлового ордера.
					 @0.0.0.3@2013.09.11@artamir	[]	SendChild
					 @0.0.0.2@2013.09.11@artamir	[*]	Выставляется лимитный ордер, если нет возможности поставить стоповый.
					 @0.0.0.1@2013.09.10@artamir	[*]	SendChild
			>Rev:0
	*/

	T_SelOrderByTicket(parent_ti);
	int parent_ty = OrderType();
	double parent_op=OrderOpenPrice();
	double parent_lot=OrderLots();
	
	double dBID = MarketInfo(Symbol(),MODE_BID);
	double dASK = MarketInfo(Symbol(),MODE_ASK);
	
	int ty = -1;
	int foty = -1;
	if(parent_ty == OP_SELL){
		ty=OP_BUYSTOP;
		foty=OP_BUYSTOP;
		if(dBID >= parent_op){
			//ty = OP_BUYLIMIT;
			ty=-1;
		}
	}
	
	if(parent_ty == OP_BUY){
		ty=OP_SELLSTOP;
		foty=OP_SELLSTOP;
		if(dASK <= parent_op){
			//ty = OP_SELLLIMIT;
			ty=-1;
		}
	}
	
	if(ty==-1){return(-1);}
	
	double tp = getTPNet(ty);
	int tp_mode = TR_MODE_PRICE;
	
	if(tp<=0){
		tp = TP;
		tp_mode=TR_MODE_PIP;
	}
	
	int max_gl = getMaxGL(foty);
	
	double a[];
	TR_SendPending_array(a, ty, parent_op, Step, parent_lot);
	int ti = a[0];
	SQL_setFOD(ti);
	SQL_setGLByTicket(ti,(max_gl+1));
	int sid = getMaxSID();
	SQL_setSIDByTicket(ti, sid);
	//SQL_setLPByTicket(ti,parent_ti);
	TR_ModifyTP(ti,tp,tp_mode);
	
	if(max_gl <= 0){
		SendSTOPNet(ti);
	}
}

void SendSTOPNet(int ti){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	Выставляет сетку ордеров от родителя.
					Переписана под sqlite
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.05@artamir	[+]	SendSTOPNet
			>Rev:0
	*/

	T_SelOrderByTicket(ti);		//Выбрали родительский ордер.
	int levels = CalcLevels();
	double start_price = OrderOpenPrice();
	double parent_tp = OrderTakeProfit();
	int parent_ty = OrderType();
	double parent_lot = OrderLots();
	
	for(int i=1; i<=levels; i++){
		double level_price_pip = Step*i;
		int level_ti = -1;
		if(parent_ty==OP_BUY || parent_ty==OP_BUYSTOP){
			level_ti=TR_SendBUYSTOP(start_price, level_price_pip, parent_lot);
		}

		if(parent_ty==OP_SELL || parent_ty==OP_SELLSTOP){
			level_ti=TR_SendSELLSTOP(start_price, level_price_pip, parent_lot);
		}	
		
		TR_ModifyTP(level_ti,parent_tp);
		SQL_setFOD(level_ti);
		SQL_setGLByTicket(level_ti,i+1);
		SQL_setMPByTicket(level_ti,ti);
		int sid = getMaxSID();
		SQL_setSIDByTicket(level_ti, sid);
	}
	
}

//..  Закрытие ордеров
bool FixProfit(){
	/**
		\version	0.0.0.0
		\date		2013.09.29
		\author		Morochin <artamir> Artiom
		\details	Закрытие по фикс профиту
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="FixProfit";
	//Print(fn);
	int sid=getMaxSID();
	//Print(fn+".sid="+sid);
	int qsid=SelectSID(sid);
	//Print(fn+".qsid="+qsid);
	int rows=Sqlite_RowCount(qsid);
	if(rows<=0){return;}
	
	double sum=0;
	
	for(int i=0; i<rows; i++){
		sum=sum+SQL_FieldAsDouble(qsid,SQL_PID);
		Sqlite_Next(qsid);
	}
	Sqlite_DestroyQuery(qsid);
	
	if(sum>Fix){
		TR_CloseAll(TR_MN);
		return(true);
	}
	
	return(false);
}
//}