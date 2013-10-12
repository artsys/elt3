/**
	\version	3.0.1.43
	\date		2013.10.12
	\author		Morochin <artamir> Artiom
	\details	Шабон построения советника на базе фреймворка eLT 3.0.1
				Orders in window.
	\internal
		Вместо отбора по локальному родителю использовать отбор по ценовому уровню.
		>Hist:																																										
				 @3.0.1.43@2013.10.12@artamir	[*] Заменил Quicksort на обычную сортировку пузырьком, чтоб избавиться от рекурсии.	
				 @3.0.1.40@2013.10.12@artamir	[*]	SendLikeOrder
				 @3.0.1.38@2013.10.12@artamir	[!] Оптимизация по событиям ордеров.	
				 @3.0.1.37@2013.10.10@artamir	[+]	sendLikeOrder, закрытие противоположных ордеров при тп.
				 @3.0.1.36@2013.10.10@artamir	[!]	Убраны замеры времени выполнения.
				 @3.0.1.35@2013.10.10@artamir	[]	
				 @3.0.1.34@2013.10.06@artamir	[!]	Изменен параметр stacksize
				 @3.0.1.33@2013.10.04@artamir	[+] Tral	
				 @3.0.1.31@2013.10.03@artamir	[]	isChildNearPrice
				 @3.0.1.30@2013.10.03@artamir	[]	SendChild
				 @3.0.1.29@2013.09.30@artamir	[!]	getNextLot
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
#define VER	"3.0.1.43_2013.10.12"
#define DATE "2013.09.05"	/** extert date */	
//}

//{ === expert DEFINES
//}

//{ === EXTERN VARIABLES
extern	string	s1="==== MAIN ====="; //{
extern	int			Step=20;	//Шаг между ордерами в пунктах.	
extern	int			TP=150;		//тейкпрофит сетки в пунктах.
extern	double		Lot=0.1;	//Лот родительского ордера.
extern	double		Multy=0.6;	//коэф. для вычисления начального лота. следующих сеток.	
extern	double		Fix=200;	//фиксированный профит по ордерам сессии.
extern	bool		useCloseRevers=false; //пытаемся перекрыть тикет который в прибыли с противоположным в убытке на каждом тике.
extern	bool		useCloseReversTP=false; //После срабатывания тп сетки закрывает противоположные позиции на величину полученной прибыли.
extern	bool		TRAL_Use=false;
extern	int			TRAL_Begin_pip=0;
extern	int			TRAL_DeltaPips=10;
extern	int			TRAL_Step_pip=5;
extern	string	e1="==== EXPERT END =====";//}
//}

//{ === INCLUDES
#include <sysELT3.mqh>
#include <libCloseOrders.mqh>
//}

//{ === Expert VARS
bool isFixProfit=false;
bool isStarted=true;
//}

int init(){
	/**
		\version	0.0.0.0
		\date		2013.08.20
		\author		Morochin <artamir> Artiom
		\details	Функция инициализации советника.
		\internal
			>Hist:			
					 @3.0.1.40@2013.10.12@artamir	[]	
					 @3.0.1.42@2013.10.12@artamir	[]	
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
	
	startext();
	string comm=StringConcatenate( 	"ver: ",VER,"\n",
									"date: ",DATE);
	Comment(comm);	
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
	
	ELT_start();
	//-------------------------------------
	
	//{		=== Блок закрытия позиций
		if(isExpertsTickets()){
			if(FixProfit()){
				isFixProfit=true;
				OE_eraseArray();
				return(0);
			}
			
			Tral();
			
			CloseRevers();
		}
	//..	=== Блок сопровождения позиций
		
		/*	Основной блок советника.
			Описание: для каждой живой позиции на расстоянии шага должен находиться 
			противоположный ордер с тейком противоположной сетки.
		*/
		//if(ArrayRange(aEvents,0)<=0){isStarted=0; return(0);}
		if(ArrayRange(aEvents,0)<=0 && !isStarted){isStarted=0; return(0);}
		CheckNets();
		Convoy();
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
	double sum = Ad_Sum2(aT, OE_OPR);
	
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
	
	int pos_rows=SelectPositions(aPos);
	
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
		
		double aT[][OE_MAX];
		int t_rows=SelectExpertTickets(aT);
		
		double aNP[][OE_MAX];
		int np_rows=ELT_SelectNearPrice_d2(aT, aNP, child_op);
		
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
	string fn="CheckNets";
	double a[][OE_MAX];
	if(SelectExpertTickets(a)>0){
		int close_ty=-1;
		double aB[][OE_MAX];
		double _lot=-1;
		bool new_sid_false=false;
		bool sendRevers2Step_true=true;
		if(ELT_SelectByFOTY_d2(a,aB,OP_BUYSTOP)<=0){
			Print(fn+".OP_BUYSTOP");
			_lot=getNextLot(OP_BUYSTOP);
			SendParent(OP_BUYSTOP,_lot,new_sid_false,sendRevers2Step_true);
			close_ty=OP_SELL;
		}
		
		if(ELT_SelectByFOTY_d2(a,aB,OP_SELLSTOP)<=0){
			Print(fn+".OP_SELLSTOP");
			_lot=getNextLot(OP_SELLSTOP);
			SendParent(OP_SELLSTOP,_lot,new_sid_false,sendRevers2Step_true);
			close_ty=OP_BUY;
		}
		
		if(close_ty>-1){
			Print(fn);
			CloseReversTP(close_ty);
		}	
	}
}
//}

//{ === Закрытие дальних противоположных ордеров на величину профита от тп.
void CloseReversTP(int close_ty){
	/**
		\version	0.0.0.0
		\date		2013.10.10
		\author		Morochin <artamir> Artiom
		\details	Закрытие дальних противоположных ордеров на величину профита от тп.
		\internal
			>Hist:
			>Rev:0
	*/
	
	if(!useCloseReversTP){return;}
	
	int sid = getMaxSID();
	double aSID[][OE_MAX];
	
	int rows_sid=SelectPosBySID(aSID, sid);
	
	double aCL[][OE_MAX];
	int rows_cl=ELT_SelectClosedPos_d2(aSID, aCL);
	
	double sum = Ad_Sum2(aCL, OE_OPR);
	
	if(sum>0){
		double aPOS[][OE_MAX];
		int rows_pos=ELT_SelectPosByTY_d2(aSID,aPOS,close_ty);
		bool stop=false;
		if(rows_pos>0){
			//Ad_QuickSort2(aPOS,-1,-1,OE_CP2OP);	//Самый дальний противоположный ордер будет иметь меньший индекс.
			A_d_Sort2(aPOS, ""+OE_CP2OP+" <;");
			int i=-1;
			while(sum>0 && i<rows_pos){
				i++;
				double profit=aPOS[i][OE_OPR];
				if(profit>0){continue;}
				
				profit = MathAbs(profit);
				int ti=aPOS[i][OE_TI];
				if(sum>=profit){
					sum=sum-profit;
					TR_CloseByTicket(ti);
					SendLikeOrder(ti);
				}
				
			}
		}
	}
}	

void CloseRevers(){
	/**
		\version	0.0.0.2
		\date		2013.10.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="CloseRevers";
	if(!useCloseRevers){return;}
	
	double aPOS[][OE_MAX];
	int rows_pos=SelectPositions(aPOS);
	
	double aOPR[][OE_MAX];
	int rows_opr=ELT_SelectInProfit_d2(aPOS,aOPR);
	
	if(rows_opr<0){return;}
	
	for(int i=0; i<rows_opr; i++){
		int parent_ti=aOPR[i][OE_TI];
		int parent_ty=aOPR[i][OE_TY];
		double parent_pr=aOPR[i][OE_OOP];
		double profit=aOPR[i][OE_OPR];
		
		int child_ty=-1;
		if(parent_ty==OP_BUY){child_ty=OP_SELL;}
		if(parent_ty==OP_SELL){child_ty=OP_BUY;}
		
		rows_pos=SelectPositions(aPOS, child_ty);
		if(rows_pos<=0){break;}
		
		double aMIN[][OE_MAX];
		int rows_min=ELT_SelectInLoss_d2(aPOS,aMIN);
		
		if(rows_min<=0){break;}
		for(int m=0; m<rows_min;m++){
			double loss=aMIN[m][OE_OPR];
			int child_ti=aMIN[m][OE_TI];
			double child_pr=aMIN[m][OE_OOP];
			
			if(parent_ty==OP_BUY){
				if(child_pr>parent_pr){continue;}
			}
			
			if(parent_ty==OP_SELL){
				if(child_pr<parent_pr){continue;}
			}
			
			if(MathAbs(profit)>MathAbs(loss)){
				//закрываем родительский ордер.
				//и ничего не выставляем, т.е. стоповый выставить не можем.
				TR_CloseByTicket(parent_ti);
				
				//закрываем дочерний ордер с выставлением стопового.
				TR_CloseByTicket(child_ti);
				SendLikeOrder(child_ti);
			}
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

bool isChildNearPrice(double child_op, int parent_ty){
	/**
		\version	0.0.0.1
		\date		2013.10.03
		\author		Morochin <artamir> Artiom
		\details	Проверяет есть ли ордера с заданным фильтром на ценовом уровне.
		\internal
			>Hist:	
					 @0.0.0.1@2013.10.03@artamir	[+]	isChildNearPrice
			>Rev:0
	*/
	string fn="isTINearPrice";
	double aT[][OE_MAX];
	int t_rows=SelectExpertTickets(aT);
	
	double aNP[][OE_MAX];
	int np_rows=ELT_SelectNearPrice_d2(aT, aNP, child_op);
	
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
	
	return(isChild);
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
	
	double aMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aMN);
	
	if(!ROWS_MN){return(0);}
	
	ELT_SelectPositions_d2(aMN, aT);	//из аМН выбираем только позиции	
	
	int ROWS_T = ELT_SelectOrders_d2(aMN, aT, true);	//к ним добавляем ордера.
	
	return(ROWS_T);
}

int SelectPositions(double &a[][], int ty=-1){
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
	
	if(ty<0){
		ELT_SelectPositions_d2(aMN, a);	//из аМН выбираем только позиции	
	}else{
		ELT_SelectPosByTY_d2(aMN, a, ty);
	}	
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

int SendChild(int parent_ti, int step_koef=1){
	/**
		\version	0.0.0.6
		\date		2013.10.03
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:						
					 @0.0.0.6@2013.10.03@artamir	[*]	Добавлен параметр коэф. шага.
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
	if(parent_ty == OP_SELL || parent_ty == OP_SELLSTOP){
		ty=OP_BUYSTOP;
		foty=OP_BUYSTOP;
		if(dBID >= parent_op && parent_ty == OP_SELL){
			//ty = OP_BUYLIMIT;
			ty=-1;
		}
	}
	
	if(parent_ty == OP_BUY || parent_ty == OP_BUYSTOP){
		ty=OP_SELLSTOP;
		foty=OP_SELLSTOP;
		if(dASK <= parent_op && parent_ty == OP_BUY){
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
	TR_SendPending_array(a, ty, parent_op, Step*step_koef, parent_lot);
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

int SendParent(		int ty	/** тип родителя */
				,	double lot=-1 /** объем родителя */
				,	bool new_sid=false /** создавать новую сессию? */
				,	bool sendRevers2Step=false /** выставлять реверс в 2-х шагах (для закрытия по тп)*/){
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
	double _tp=0, _sl=0;
	string _comm="", _sy="";
	int _mn=-1, _mode=TR_MODE_PIP, _pr_mode=TR_MODE_AVG;
	
	if(lot<=0){lot=MarketInfo(Symbol(), MODE_MINLOT);}
	
	int sid=getMaxSID();
	if(new_sid){
		sid=sid+1;
	}
	
	int rows_a=TR_SendPending_array(a, ty, start_pr, Step, lot, _tp, _sl, _comm, _mn, _sy, _mode, _pr_mode);
	
	for(int i=0; i<rows_a;i++){
		OE_setGLByTicket(a[i],1);
		OE_setSIDByTicket(a[i],sid);
		TR_ModifyTP(a[i],TP,TR_MODE_PIP);
		SendSTOPNet(a[i]);
		
		if(sendRevers2Step){
			SendChild(a[i], 2);
		}
	}
	
	ArrayResize(a,0);
}

void SendLikeOrder(int parent_ti){
	/**
		\version	0.0.0.2
		\date		2013.10.10
		\author		Morochin <artamir> Artiom
		\details	Выставляет похожий ордер и устанавливает параметр MP
		\internal
			>Hist:		
					 @0.0.0.2@2013.10.10@artamir	[*]	Исправлено копирование строки массива родительского ордера.
					 @0.0.0.1@2013.10.10@artamir	[+]	sendLikeOrder
			>Rev:0
	*/

	double a[];
	int rows_a=TR_SendPendingLikeOrder(a, parent_ti);
	for(int i=0;i<rows_a;i++){
		int ti=a[i];
		int idx_child=OE_setStandartDataByTicket(ti);
		int idx_parent=OE_FIBT(parent_ti);
		Ad_CopyRow2To2(aOE, aOE, idx_parent, idx_child, OE_MP, -1, A_MODE_REPL);
	}
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
	if(foty_rows>0){
		return(aFOTY[0][OE_TP]);
	}
	
	return(0);
	//double aGL[][OE_MAX];
	//int gl_rows=ELT_SelectByGL_d2(aFOTY,aGL,1);
	
	//if(gl_rows<=0){return(0);} //нет родителя сетки.
	
	//double tp = aGL[0][OE_TP]; //если есть хоть один родитель сетки, то он будет в 0-м индексе.
	
	ArrayResize(aT,0);
	ArrayResize(aFOTY,0);
	//ArrayResize(aGL,0);
	
	//return(tp);
	
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
	
	//Ad_QuickSort2(aFOTY, -1, -1, OE_GL, A_MODE_DESC);
	A_d_Sort2(aFOTY, ""+OE_GL+">;");
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
	
	//Ad_QuickSort2(aT, -1, -1, OE_SID, A_MODE_DESC);
	A_d_Sort2(aT,""+OE_SID+" >;");
	int res=aT[0][OE_SID];
	ArrayResize(aT,0);
	return(res);
}

double getNextLot(int foty){
	/**
		\version	0.0.0.4
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Лотность родительского ордера умноженного на коэффицент.
		\internal
			>Hist:				
					 @0.0.0.4@2013.09.30@artamir	[!]	Исправлено получение лота последней сетки.
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
	
	double aGL[][OE_MAX];
	int gl_rows=ELT_SelectByGL_d2(aFOTY, aGL, 1);
	if(gl_rows<0){return(Lot);}
	
	A_d_Sort2(aGL,""+OE_LOT+"<;");
	//Print(fn+".Ad_QuickSort2.Start");
	//Ad_QuickSort2(aGL, -1, -1, OE_LOT, A_MODE_DESC);
	//Print(fn+".Ad_QuickSort2.End");
	
	double next_lot = Norm_vol(aGL[0][OE_LOT]*Multy);
	
	ArrayResize(aT,0);
	ArrayResize(aFOTY,0);
	ArrayResize(aGL,0);
	
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

void Tral(){
	/**
		\version	0.0.0.5
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:					
					 @0.0.0.5@2013.06.25@artamir	[]	CloseAllPendings
					 @0.0.0.4@2013.05.17@artamir	[]	CloseAllPendings
					 @0.0.0.3@2013.05.15@artamir	[]	CloseAllPendings
					 @0.0.0.2@2013.05.15@artamir	[]	CloseAllPendings
					 @0.0.0.1@2013.05.15@artamir	[]	CloseAllPendings
			>Rev:0
	*/

	if(!TRAL_Use){return;}
	
	double d[][OE_MAX];
	//{ --- Если СЛ > 0
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MN, TR_MN, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_CP2SL, (TRAL_Begin_pip+TRAL_DeltaPips), -1, AS_OP_ABOVE);
	A_FilterAdd_AND(OE_CP2OP, (TRAL_DeltaPips), -1, AS_OP_ABOVE);
	
	A_d_Select(aOE, d);
	
	int ROWS = ArrayRange(d, 0);
	
	for(int idx = 0; idx < ROWS; idx++){
		int ti = d[idx][OE_TI];
		TR_ModifySLByPrice(ti, TRAL_Step_pip);
	}
	//}
	
	//{ --- Если СЛ = 0
	ArrayResize(d, 0);
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MN, TR_MN, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_SL, 0, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_CP2OP, (TRAL_DeltaPips), -1, AS_OP_ABOVE);
	
	A_d_Select(aOE, d);
	
	ROWS = ArrayRange(d, 0);
	
	for(idx = 0; idx < ROWS; idx++){
		ti = d[idx][OE_TI];
		TR_ModifySLByPrice(ti, TRAL_Step_pip);
	}
	//}
	
	ArrayResize(d,0);
}	
//}