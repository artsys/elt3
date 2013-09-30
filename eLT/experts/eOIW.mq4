/**
	\version	3.0.1.28
	\date		2013.09.30
	\author		Morochin <artamir> Artiom
	\details	Шабон построения советника на базе фреймворка eLT 3.0.1
				Orders in window.
	\internal
		Вместо отбора по локальному родителю использовать отбор по ценовому уровню.
		>Hist:																												
				 @3.0.1.28@2013.09.30@artamir	[*]	SendSTOPNet
				 @3.0.1.27@2013.09.30@artamir	[*]	FixProfit
				 @3.0.1.26@2013.09.30@artamir	[*]	startext
				 @3.0.1.25@2013.09.30@artamir	[*]	SendChild
				 @3.0.1.24@2013.09.30@artamir	[*]	getNextLot
				 @3.0.1.23@2013.09.30@artamir	[+]	SelectPosBySID
				 @3.0.1.22@2013.09.19@artamir	[+]	getNextLot
				 @3.0.1.21@2013.09.19@artamir	[*]	Autoopen
				 @3.0.1.20@2013.09.13@artamir	[]	startext
				 @3.0.1.19@2013.09.13@artamir	[]	startext
				 @3.0.1.18@2013.09.13@artamir	[+] Добавлена библиотека libCloseOrders.	
				 @3.0.1.17@2013.09.12@artamir	[+]	CheckNets
				 @3.0.1.16@2013.09.12@artamir	[*]	SendChild
				 @3.0.1.15@2013.09.11@artamir	[]	Convoy
				 @3.0.1.14@2013.09.11@artamir	[]	SendChild
				 @3.0.1.13@2013.09.11@artamir	[]	SendChild
				 @3.0.1.12@2013.09.10@artamir	[*]	SendChild Добавлено выставление сетки, если нет ордеров нужного направления.
				 @3.0.1.11@2013.09.06@artamir	[]	SelectExpertTickets
				 @3.0.1.10@2013.09.06@artamir	[+]	SelectTINearPrice
				 @3.0.1.9@2013.09.05@artamir	[+]	getMaxGL
				 @3.0.1.8@2013.09.05@artamir	[+]	Convoy
				 @3.0.1.7@2013.09.05@artamir	[+]	SelectPositions
				 @3.0.1.6@2013.09.05@artamir	[+]	SendSTOPNet
				 @3.0.1.5@2013.09.05@artamir	[+]	CalcLevels
				 @3.0.1.4@2013.09.04@artamir	[+]	Autoopen
				 @3.0.1.3@2013.09.04@artamir	[+]	SelectExpertTickets
				 @3.0.1.2@2013.09.04@artamir	[+]	isExpertsTickets
				 @3.0.1.1@2013.08.28@artamir	[+]	startext
		>Rev:0
*/
	
//{ === DEFINES
#define EXP	"eOIW"	/** имя эксперта */
#define VER	"3.0.1.28_2013.09.30"
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
int oe_maxrows=0;

//{ === expert DEFINES
//}

//{ === EXTERN VARIABLES
extern	string	s1="==== MAIN ====="; //{
extern	int			Step=20;	//Шаг между ордерами в пунктах.	
extern	int			TP=150;		//тейкпрофит сетки в пунктах.
extern	double		Lot=0.1;	//Лот родительского ордера.
extern	double		Multy=0.6;	//коэф. для вычисления начального лота. следующих сеток.	
extern	double		Fix=200;	//фиксированный профит по ордерам сессии.
extern	string	e1="==== EXPERT END =====";//}
//}

//{ === INCLUDES
#include <sysELT3.mqh>
#include <libCloseOrders.mqh>
//}

//{ === Expert VARS
bool isFixProfit=false;
//}

int init(){
	/**
		\version	0.0.0.0
		\date		2013.08.20
		\author		Morochin <artamir> Artiom
		\details	Функция инициализации советника.
		\internal
			>Hist:	
					 @3.0.1.18@2013.09.13@artamir	[]	
			>Rev:0
	*/

	ELT_init();
	
	//-------------------------------------
	return(0);
}

int deinit(){
	/**
		\version	0.0.0.0
		\date		2013.08.20
		\author		Morochin <artamir> Artiom
		\details	Функция деинициализации советника
		\internal
			>Hist:
			>Rev:0
	*/

	ELT_deinit();
	//-------------------------------------
	return(0);
}

int start(){
	/**
		\version	0.0.0.0
		\date		2013.08.20
		\author		Morochin <artamir> Artiom
		\details	функция срабатывает с появлением нового тика
		\internal
			>Hist:
			>Rev:0
	*/
	
	int h_tmr_start = TMR_Start("start");
	startext();
	oe_maxrows=MathMax(oe_maxrows, ArrayRange(aOE,0));
	int tmr_res = TMR_Stop(h_tmr_start);
	if(tmr_res>max_start_timer){max_start_timer=tmr_res;}
	string comm=StringConcatenate( 	"Start circle = "+max_start_timer,"\n",
									"ver: ",VER,"\n",
									"date: ",DATE);
	Comment(comm);	
	
	comm=StringConcatenate(comm,
	"elt_start=",elt_start,"\n",
			"cfp=",cfp,"\n",
			"cnv_all=",cnv_all,"\n",
			"cnt=",cnt,"\n",
			"cnv=",cnv,"\n",
			"---sp=",sp,"\n",
			"---set=",set,"\n",
			"--- -set_mn=",set_mn,"\n",
			"--- - - elt_mn_flt=",elt_mn_flt,"\n",
			"--- - - elt_mn_sl=",elt_mn_sl,"\n",
			"--- -set_sp=",set_sp,"\n",
			"--- -set_so=",set_so,"\n",
			"--- - - elt_so_flt=",elt_so_flt,"\n",
			"--- - - elt_so_sl=",elt_so_sl,"\n",
			"---np=",np,"\n",
			"aOE.rows="+ArrayRange(aOE,0)+"\n",
			"OrdersTotal="+OrdersTotal()+"\n",
			"aOE.max_rows="+oe_maxrows);

	int h=FileOpen("eOIW.tmr",FILE_BIN|FILE_WRITE);
			FileWrite(h,comm);
			FileFlush(h);
			FileClose(h);
	//-------------------------------------
	return(0);
}

int startext(){
	/**
		\version	0.0.0.4
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	расширение функции start()
					можно вызывать при наступлении какого-нибудь условия.
		\internal
			>Hist:				
					 @0.0.0.4@2013.09.30@artamir	[*]	Добавлено очищение массивов ордеров после фикс профита.
					 @0.0.0.3@2013.09.13@artamir	[*]	Если не было событий, то выходим из функции
					 @0.0.0.2@2013.09.13@artamir	[*]	Если тестирование и нет ордеров, то очищаем массив ордеров.
					 @0.0.0.1@2013.08.28@artamir	[]	startext
			>Rev:0
	*/
	string fn="startext";
	if(isFixProfit){
		isFixProfit=false;
		A_d_eraseArray2(aOldOrders);
		A_d_eraseArray2(aCurOrders);
		return(0);
	}
	
	OE_eraseArray();
	
	int h_start=TMR_Start("elt_start");
	ELT_start();
	int tmr_elt_start = TMR_Stop(h_start);
	if(tmr_elt_start>elt_start){elt_start=tmr_elt_start;}
	//-------------------------------------
	
	//{		=== Блок закрытия позиций
		int h_cfp=TMR_Start("cfp");
		
		//libCO_CFP_Check();
		if(isExpertsTickets()){
			if(FixProfit()){
				isFixProfit=true;
				OE_eraseArray();
				return(0);
			}
		}
		
		int res_tmr=TMR_Stop(h_cfp);
		if(res_tmr>cfp){cfp=res_tmr;}
	//..	=== Блок сопровождения позиций
		
		/*	Основной блок советника.
			Описание: для каждой живой позиции на расстоянии шага должен находиться 
			противоположный ордер с тейком противоположной сетки.
		*/
		if(ArrayRange(aEvents,0)<=0 && !isStarted){isStarted=0; return(0);}
		
		int h_cnv_all = TMR_Start("cnv_all");
		
		int h_cnt=TMR_Start("cnt");
		CheckNets();
		int res_cnt=TMR_Stop(h_cnt);
		if(res_cnt>cnt){cnt=res_cnt;}
		
		int h_cnv=TMR_Start("cnv");
		Convoy();
		int res_cnv=TMR_Stop(h_cnv);
		if(res_cnv>cnv){cnv=res_cnv;}
		
		int res_cnv_all=TMR_Stop(h_cnv_all);
		if(res_cnv_all>cnv_all){
			if(cnv_all!=0){
				if(res_cnv_all/cnv_all<10){
					cnv_all=res_cnv_all;
				}
			}else{
				cnv_all=res_cnv_all;
			}
		}
		
	//..	=== Блок открытия позиций
		Autoopen();
	//}
	
	
	//-------------------------------------
	return(0);
}

//{ === FixProfit
bool FixProfit(){
	/**
		\version	0.0.0.1
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Собирает фиксированный профит по позициям.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.30@artamir	[]	FixProfit
			>Rev:0
	*/
	string fn="FixProfit";
	bool res=false;
	int sid = getMaxSID();
	double aT[][OE_MAX];
	
	SelectPosBySID(aT, sid);
	double sum = Ad_Sum(aT, OE_OPR);
	
	if(sum >= Fix){
		TR_CloseAll(TR_MN);
		return(true);
	}
	
	ArrayResize(aT,0);
	return(res);
}
//}

//{ === autoopen
void Autoopen(){
	/**
		\version	0.0.0.2
		\date		2013.09.19
		\author		Morochin <artamir> Artiom
		\details	Выставляет отложенные стоповые ордера на расстоянии шаг от цены.
					Условие: если нет живых приказов советника.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.19@artamir	[*]	Добавлен лот родительского ордера.
					 @0.0.0.1@2013.09.04@artamir	[+]	Autoopen
			>Rev:0
	*/

	if(!isExpertsTickets()){
		SendParent(OP_BUYSTOP, Lot,true);
		SendParent(OP_SELLSTOP, Lot, false);
	}
}	

void SendSTOPNet(int ti){
	/**
		\version	0.0.0.2
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Выставляет сетку ордеров от родителя.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.30@artamir	[*]	Добавлена установка SID
					 @0.0.0.1@2013.09.05@artamir	[+]	SendSTOPNet
			>Rev:0
	*/

	T_SelOrderByTicket(ti);		//Выбрали родительский ордер.
	int levels = CalcLevels();
	double start_price = OrderOpenPrice();
	double parent_tp = OrderTakeProfit();
	int parent_ty = OrderType();
	double parent_lot=OrderLots();
	int sid=getMaxSID();
	
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
		OE_setGLByTicket(level_ti,i+1);
		OE_setMPByTicket(level_ti,ti);
		OE_setSIDByTicket(level_ti,sid);
	}
	
}

//}

//{ === convoy
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
	
	double aPos[][OE_MAX];
	
	int h_sp=TMR_Start("sp");
	int pos_rows=SelectPositions(aPos);
	int res_sp=TMR_Stop(h_sp);
	if(res_sp>sp){sp=res_sp;}
	
	if(pos_rows<=0){return;} //значит у нас нет позиций.
	
	for(int pos_i=0;pos_i<pos_rows;pos_i++){
		int parent_ti=aPos[pos_i][OE_TI];
		int parent_ty=aPos[pos_i][OE_TY];
		double parent_op=aPos[pos_i][OE_OP];
		
		double child_op = 0.00;
		if(parent_ty==OP_BUY||parent_ty==OP_BUYSTOP){
			child_op=parent_op-Step*Point;
		}
		
		if(parent_ty==OP_SELL||parent_ty==OP_SELLSTOP){
			child_op=parent_op+Step*Point;
		}
		
		child_op=Norm_symb(child_op);
		
		int h_set=TMR_Start("set");
		double aT[][OE_MAX];
		int t_rows=SelectExpertTickets(aT);
		int res_set=TMR_Stop(h_set);
		if(res_set>set){set=res_set;}
		
		int h_np=TMR_Start("np");
		double aNP[][OE_MAX];
		int np_rows=ELT_SelectNearPrice_d2(aT, aNP, child_op);
		int res_np=TMR_Stop(h_np);
		if(res_np>np){np=res_np;}
		
		
		bool isChild = false;
		for(int np_i=0; np_i<np_rows;np_i++){
			int ty = aNP[np_i][OE_TY];
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
		}
		
		if(!isChild){SendChild(parent_ti);}
	}
}
//}

//{ === checkNets
//проверяем сетки, чтоб они существовали.
//если какой-то сетки не существует, тогда выставляем новую.
//но при условии, что есть живые тикеты эксперта.
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
	if(SelectExpertTickets(a)>0){
		double aB[][OE_MAX];
		double _lot=-1;
		if(ELT_SelectByFOTY_d2(a,aB,OP_BUYSTOP)<=0){
			_lot=getNextLot(OP_BUYSTOP);
			SendParent(OP_BUYSTOP,_lot);
		}
		
		if(ELT_SelectByFOTY_d2(a,aB,OP_SELLSTOP)<=0){
			_lot=getNextLot(OP_SELLSTOP);
			SendParent(OP_SELLSTOP,_lot);
		}
	}
}
//}

//{ === expert additional fincrions
bool isExpertsTickets(){
	/**
		\version	0.0.0.1
		\date		2013.09.04
		\author		Morochin <artamir> Artiom
		\details	проверяет, если существует хоть один живой тикет, который принадлежит советнику.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.04@artamir	[+]	isExpertsTickets
			>Rev:0
	*/

	double a[][OE_MAX];
	if(SelectExpertTickets(a)>0){return(true);}
	
	return(false);
}

int SelectExpertTickets(double &aT[][]){
	/**
		\version	0.0.0.2
		\date		2013.09.06
		\author		Morochin <artamir> Artiom
		\details	возвращает количество рабочих приказов эксперта.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.06@artamir	[*]	SelectExpertTickets исправлен параметр функции.
					 @0.0.0.1@2013.09.04@artamir	[+]	SelectExpertTickets
			>Rev:0
	*/
	
	int h_set_mn=TMR_Start("set_mn");
	double aMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aMN);
	int res_set_mn=TMR_Stop(h_set_mn);
	if(res_set_mn>set_mn){set_mn=res_set_mn;}
	
	if(!ROWS_MN){return(0);}
	
	int h_set_sp=TMR_Start("set_sp");
	ELT_SelectPositions_d2(aMN, aT);	//из аМН выбираем только позиции	
	int res_set_sp=TMR_Stop(h_set_sp);
	if(res_set_sp>set_sp){set_sp=res_set_sp;}
	
	int h_set_so=TMR_Start("set_so");
	int ROWS_T = ELT_SelectOrders_d2(aMN, aT, true);	//к ним добавляем ордера.
	int res_set_so=TMR_Stop(h_set_so);
	if(res_set_so>set_so){set_so=res_set_so;}
	
	return(ROWS_T);
}

int SelectPositions(double &a[][]){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	Выбирает живые позиции эксперта
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.05@artamir	[+]	SelectPositions
			>Rev:0
	*/

	double aMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aMN);
	if(!ROWS_MN){return(0);}
	
	ELT_SelectPositions_d2(aMN, a);	//из аМН выбираем только позиции	
	ArrayResize(aMN,0);
	return(ArrayRange(a,0));
}

int SelectPosBySID(double &a[][], int sid){
	/**
		\version	0.0.0.1
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Выбирает позиции эксперта с заданным sid
		\internal
			>Hist:		
					 @0.0.0.1@2013.09.30@artamir	[+]	SelectPosBySID
			>Rev:0
	*/

	double aMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aMN);
	if(!ROWS_MN){return(0);}
	
	ELT_SelectPosBySID_d2(aMN, a, sid);	//из аМН выбираем только позиции	
	ArrayResize(aMN,0);
	return(ArrayRange(a,0));
}

int SelectTIBySID(double &a[][], int sid){
	/**
		\version	0.0.0.1
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Выбирает ордера эксперта с заданным sid
		\internal
			>Hist:		
					 @0.0.0.1@2013.09.30@artamir	[+]	SelectPosBySID
			>Rev:0
	*/

	double aMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aMN);
	if(!ROWS_MN){return(0);}
	
	ELT_SelectTicketsBySID_d2(aMN, a, sid);	//из аМН выбираем только позиции	
	ArrayResize(aMN,0);
	return(ArrayRange(a,0));
}


int SelectTINearPrice(double &a[][], double pr){
	/**
		\version	0.0.0.1
		\date		2013.09.06
		\author		Morochin <artamir> Artiom
		\details	выбор тикетов возле цены.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.06@artamir	[+]	SelectTINearPrice
			>Rev:0
	*/

	double aT[][OE_MAX];
	int t_rows = SelectExpertTickets(aT);
	
	if(t_rows<=0){return(0);}
	
	int np_rows = ELT_SelectNearPrice_d2(aT, a, pr);
	
	ArrayResize(aT,0);
}

int SendChild(int parent_ti){
	/**
		\version	0.0.0.5
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:					
					 @0.0.0.5@2013.09.30@artamir	[*]	Выставление лотом родительского ордера.
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
	int sid = getMaxSID();
	OE_setGLByTicket(ti,(max_gl+1));
	OE_setLPByTicket(ti,parent_ti);
	OE_setSIDByTicket(ti, sid);
	TR_ModifyTP(ti,tp,tp_mode);
	
	if(max_gl <= 0){
		SendSTOPNet(ti);
	}
}

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

	double a[];
	double start_pr=0.00;
	if(lot<=0){lot=MarketInfo(Symbol(), MODE_MINLOT);}
	
	int sid=getMaxSID();
	if(new_sid){
		sid=sid+1;
	}
	
	int rows_a=TR_SendPending_array(a, ty, start_pr, Step, lot);
	
	for(int i=0; i<rows_a;i++){
		OE_setGLByTicket(a[i],1);
		OE_setSIDByTicket(a[i],sid);
		TR_ModifyTP(a[i],TP,TR_MODE_PIP);
		SendSTOPNet(a[i]);
	}
	
	ArrayResize(a,0);
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
	

	double aT[][OE_MAX];
	int ti_rows=SelectExpertTickets(aT);
	int foty = -1;
	double aFOTY[][OE_MAX];
	int foty_rows=ELT_SelectByFOTY_d2(aT,aFOTY,ty);
	double aGL[][OE_MAX];
	int gl_rows=ELT_SelectByGL_d2(aFOTY,aGL,1);
	
	if(gl_rows<=0){return(0);} //нет родителя сетки.
	
	double tp = aGL[0][OE_TP]; //если есть хоть один родитель сетки, то он будет в 0-м индексе.
	
	ArrayResize(aT,0);
	ArrayResize(aFOTY,0);
	ArrayResize(aGL,0);
	
	return(tp);
	
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

	double aT[][OE_MAX];
	int t_rows = SelectExpertTickets(aT);
	double aFOTY[][OE_MAX];
	int foty_rows = ELT_SelectByFOTY_d2(aT, aFOTY, foty);
	
	if(foty_rows <= 0){return(0);}
	
	Ad_QuickSort2(aFOTY, -1, -1, OE_GL, A_MODE_DESC);
	int res=aFOTY[0][OE_GL];
	
	ArrayResize(aT,0);
	ArrayResize(aFOTY,0);
	
	return(res);
}

int getMaxSID(){
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

	double aT[][OE_MAX];
	ArrayCopy(aT, aOE);
	
	Ad_QuickSort2(aT, -1, -1, OE_SID, A_MODE_DESC);
	int res=aT[0][OE_SID];
	ArrayResize(aT,0);
	return(res);
}

double getNextLot(int foty){
	/**
		\version	0.0.0.3
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Лотность родительского ордера умноженного на коэффицент.
		\internal
			>Hist:			
					 @0.0.0.3@2013.09.30@artamir	[*]	Выборка ордеров по sid
					 @0.0.0.2@2013.09.19@artamir	[+]	getNextLot
			>Rev:0
	*/
	string fn="getNextLot";
	double aT[][OE_MAX];
	int sid = getMaxSID();
	int t_rows = SelectTIBySID(aT, sid);
	
	double aFOTY[][OE_MAX];
	int foty_rows = ELT_SelectByFOTY_d2(aT, aFOTY, foty);
	if(foty_rows <= 0){return(Lot);}
	
	Ad_QuickSort2(aFOTY, -1, -1, OE_GL, A_MODE_DESC);
	
	double next_lot = Norm_vol(aFOTY[0][OE_LOT]*Multy);
	
	ArrayResize(aT,0);
	ArrayResize(aFOTY,0);
	
	return(next_lot);
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
//}