	/*
		>Ver	:	0.1.1.20
		>Date	:	2013.11.08
		>Author: Morochin <artamir> Artiom
		>Hist:																					
		>Desc:
			Base include
			Manager for system include files.
		>Pref:
			non
		>Warning:
			DO NOT CHANGE!!!!
	*/

#property stacksize 1024			
	
#define	ELTVER	"0.1.1.20_2013.11.08"

//{ GLOBAL VARS
	//Нужны для совместимости с пред. версиями.
bool ELT_useEraseFilter=true; //разрешает процедурам отбора совершать очиску фильтра.
bool ELT_useSelect=true;	//разрешает процедурам отбора совершать физический отбор.

//}

//{	//Include	========================================
//{		@System	----------------------------------------
#include	<WinUser32.mqh>
#include	<sysDebug.mqh>
//----------------------------------------------------------
#include	<sysNormalize.mqh>								//Pref: Norm
#include	<sysStructure.mqh>								//Pref: Struc
#include	<sysOther.mqh>									
#include	<sysDT.mqh>										//Pref: DT
#include	<sysMarketInfo.mqh>								//Pref:	MI
//----------------------------------------------------------
#include	<sysArray.mqh>									//Pref:	A
#include	<sysArray2.mqh>									//Pref: A
#include	<sysIndexedArray.mqh>
#include	<sysOrdersExtra.mqh>							//Pref:	OE
#include	<sysTerminal.mqh>								//Pref: T
#include	<sysEvents.mqh>									//Pref:	E
//.. 	@Trades	----------------------------------------
#include	<sysTrades.mqh>									//Pref:	TR
//..	@Indicators
//#include	<iMA.mqh>										//Pref: iMA
//}
//}

int Main(){
	/**
		\brief		Основная функция 
		\version	0.0.1
		\date		2012.10.04
		\author		Morochin <artamir> Artiom
		\details		Must be called in begining of "start()" 
		\internal
					>Hist:
						@0.0.1@2012.10.04@artamir	[]
	*/
	
	//------------------------------------------------------
	T_Start();
	T_End();
	
	//{ == Перезапись данных по ордерам, которые есть в терминале
	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		OE_setStandartDataByTicket(OrderTicket());
	}
	//}
}

int ELT_init(string fn = ""){
	/**
		\version	0.0.0.3
		\date		2013.09.04
		\author		Morochin <artamir> Artiom
		\details		import array aOE from file
		\internal
			>Hist:	
					 @0.0.0.3@2013.09.04@artamir	[*]	ELT_init добавлена инициализация таймера.
				@0.0.2 - changed name
	*/
	
	//------------------------------------------------------
	if(fn == ""){
		fn = ELT_DBFN();
	}
	
	//------------------------------------------------------
	A_d_ReadFromFile2(aOE, fn);
	
	//------------------------------------------------------
	TMR_init();
}

int ELT_deinit(string fn = ""){
	/**
		\version	0.0.2
		\date
		\author		Morochin <artamir> Artiom
		\details	export array aOE to filE_
		\internal
			>Hist:
				@0.0.2 - changed name
	*/
	
	if(fn == ""){
		fn = ELT_DBFN();
	}
	
	//------------------------------------------------------
	A_d_SaveToFile2(aOE, fn, 8);
}	

int ELT_start(){
	/**
		\version	0.0.0.2
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	Перепроверка данных ордеров в терминале. Заполнение событий.
		\internal
			>Hist:		
					 @0.0.0.2@2013.08.29@artamir	[]	ELT_start
					 @0.0.0.1@2013.08.28@artamir	[]	ELT_start
			>Rev:0
	*/
	string fn="ELT_start";
	double a[];
	int t = T_getTickets(a);

	
	
	for(int i=0; i<t; i++){
		OE_setStandartDataByTicket(a[i]);
	}
	
	T_Start();
	T_End();
}

string ELT_DBFN(string ext=".edb"){
	/**
		\version	0.0.0.1
		\date		2013.08.20
		\author		Morochin <artamir> Artiom
		\details	Возвращает имя файла-хранилища
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.20@artamir	[+]	ELT_DBFN
			>Rev:0
	*/
	
	string fn = "DB."+EXP+"."+AccountNumber()+"."+Symbol()+ext;

	//------------------------------------------------------
	return(fn);
}

//{ === SELECTING
int ELT_SelectByMN_d2(		double &s[][] /** source array */
						,	double &d[][] /** destination array */	
						,	int mn = -1	  /** magic number*/){
	/**
		\version	0.0.1.2
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по магику
		\internal
			>Hist:		
					 @0.0.1.2@2013.10.23@artamir	[!]	Обновлено согласно 0.1.1.0 
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/

	if(mn == -1){
		mn = TR_MN;
	}
	
	if(ELT_useEraseFilter){A_eraseFilter();}
	
	A_FilterAdd_AND(OE_MN, mn, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByMethod_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	method	  /** magic number*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по методу
		\internal
			>Hist:		
					 @0.0.1.1@2013.10.23@artamir	[]	обновлено согласно 0.1.1.0
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	
	if(ELT_useEraseFilter){A_eraseFilter();}
	
	A_FilterAdd_AND(OE_AOM, method, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectPositions_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	bool 	add = false	  /** добавлять к массиву приемнику */){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по рыночным ордерам, которые еще не закрыты
		\internal
			>Hist:		
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IM, 1, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectPosByTY_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int		ty		/** тип отбираемых позиций */
							,	bool 	add = false	  /** добавлять к массиву приемнику */){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по рыночным ордерам, которые еще не закрыты
		\internal
			>Hist:			
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.2@2013.10.10@artamir	[+]	
					 
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IM, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_TY, ty, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}


int ELT_SelectOrders_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	bool	add = false	  /** добавлять к массиву приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по отложенным ордерам, которые еще не удалены
		\internal
			>Hist:		
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.1@2013.06.25@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IP, 1, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByTY_d2(			double	&s[][]	/** source array */
							,	double	&d[][]	/** destination array */	
							,	int 	ty		/** first open type*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по типу тикета.
		\internal
			>Hist:				
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.2@2013.06.28@artamir	[+]
			
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_TY, ty, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectNearPrice_d2(double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	double 	pr=0	  /** уровень цены открытия*/
							,	int		delta_pip=0 /** количество пунктов для задания диапазона*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
		
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Фильтрация по цене открытия.
		\internal
			>Hist:		
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.1@2013.09.06@artamir	[+]	
			>Rev:0
	*/

	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	double max_pr=pr+delta_pip*Point;
	double min_pr=pr-delta_pip*Point;
	
	A_FilterAdd_AND(OE_OP, max_pr, min_pr, AS_OP_IN);
	if(ELT_useSelect){A_d_Select(s, d, add);}

	return(ArrayRange(d, 0));
}					

int ELT_SelectByGL_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	gl=0	  /** уровень сетки*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по уровню сетки
		\internal
			>Hist:		
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.1@2013.06.25@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_GL, gl, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByMP_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	mp=0	  /** тикет основного родителя*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по основному родителю
		\internal
			>Hist:		
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.1@2013.06.25@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_MP, mp, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByLP_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	lp=0	  /** тикет локального родителя*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по локальному родителю.
		\internal
			>Hist:		
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.1@2013.06.25@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_LP, lp, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}


int ELT_SelectByFIR_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	fir=1	  /** is Revers?*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по признаку реверс ордера.
		\internal
			>Hist:			
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.2@2013.06.28@artamir	[+]	
			
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_FIR, fir, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByFOTY_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	foty	  /** first open type*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по признаку начального типа.
		\internal
			>Hist:				
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.2@2013.06.28@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_FOTY, foty, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectPosBySID_d2(		double	&s[][]		/** source array */
							,	double	&d[][]		/** destination array */	
							,	int		sid			/** ИД сессии */
							,	bool 	add = false	/** добавлять к массиву приемнику */){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по рыночным ордерам, которые еще не закрыты
		\internal
			>Hist:			
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.2@2013.09.30@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_IM, 1  , -1, AS_OP_EQ); //Выбираем все рыночные ордера
	A_FilterAdd_AND(OE_SID, sid, -1, AS_OP_EQ); //у которых sid=
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectTicketsBySID_d2(	double	&s[][]		/** source array */
							,	double	&d[][]		/** destination array */	
							,	int		sid			/** ИД сессии */
							,	bool 	add = false	/** добавлять к массиву приемнику */){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по всем ордерам, у которых sid=sid
		\internal
			>Hist:			
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.2@2013.09.30@artamir	[+]
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_SID, sid, -1, AS_OP_EQ); //Выбираем ордера с заданным sid.
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectClosedPos_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	bool 	add = false	  /** добавлять к массиву приемнику */){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по рыночным ордерам, которые еще не закрыты
		\internal
			>Hist:			
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.2@2013.10.10@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_IC, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IM, 1, -1, AS_OP_EQ);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectInProfit_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по параметру OPR>0
		\internal
			>Hist:				
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_OPR, 0, -1, AS_OP_ABOVE);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectInLoss_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по параметру OPR>0
		\internal
			>Hist:				
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_OPR, 0, -1, AS_OP_UNDER);
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	
	return(ArrayRange(d, 0));
}

int ELT_SelectInLossCP_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int		ty=-1 /** тип отбираемых ордеров*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.1.1
		\date		2013.10.23
		\author		Morochin <artamir> Artiom
		\details	Отбор по параметру CP2OP<0
		\internal
			>Hist:					
					 @0.0.1.1@2013.10.23@artamir	[*]	обновлено согласно 0.1.1.0
					 @0.0.0.4@2013.10.22@artamir	[+]	
			>Rev:0
	*/
	
	if(ELT_useEraseFilter){A_eraseFilter();}										
	
	A_FilterAdd_AND(OE_CP2OP, 0, -1, AS_OP_UNDER);
	
	if(ty >= 0){
	//	A_FilterAdd_AND(OE_FOTY, ty, -1, AS_OP_EQ);
	}
	
	if(ELT_useSelect){A_d_Select(s, d, add);}
	return(ArrayRange(d, 0));
}


//