	/*
		>Ver	:	0.1.0.50
		>Date	:	2013.09.06
		>Hist:																						
				 @0.1.0.50@2013.09.06@artamir	[+]	ELT_SelectNearPrice_d2
				 @0.1.0.49@2013.09.05@artamir	[+]	ELT_SelectByFOTY_d2
				 @0.1.0.48@2013.09.04@artamir	[*]	ELT_init
				 @0.1.0.47@2013.08.29@artamir	[]	ELT_start
				 @0.1.0.46@2013.08.28@artamir	[+]	ELT_start
				 @0.1.0.45@2013.08.20@artamir	[+]	ELT_DBFN
				 @0.1.0.44@2013.06.28@artamir	[]	ELT_deinit
				 @0.1.0.43@2013.06.25@artamir	[]	ELT_deinit
				 @0.1.37@2013.04.25@artamir	[]	
				 @0.1.36@2013.04.25@artamir	[*] sysTrades	
				@0.1.34@2013.04.16@artamir	[*] sysELT3	
				 @0.1.32@2013.03.06@artamir	[*] sysEvents	
				 @0.1.31@2013.03.06@artamir	[*] sysArray	
				 @0.1.30@2013.03.04@artamir	[]	
				 @0.1.29@2013.02.26@artamir	[]	ELT_init
				 @0.1.28@2013.02.26@artamir	[]	
				 @0.1.27@2013.02.26@artamir	[*] sysTrades	
				 @0.1.25@2013.02.23@artamir	[*] sysArray	
				 @0.1.24@2013.02.22@artamir	[*] sysTrades: Добавлена функция открытия реверсного ордера.	
				 @0.1.23@2013.02.22@artamir	[*] sysOrdersExtra	
				 @0.1.22@2013.02.22@artamir	[*] sysTrades, 	
				 @0.1.21@2013.02.22@artamir	[*] sysArray исправлена инициализация массива-фильтра в A_d_Select	
				 @0.1.20@2013.02.21@artamir	[*] sysOrdersExtra	
				 @0.1.19@2013.02.21@artamir	[*] 	
				 @0.1.18@2013.02.21@artamir	[*] sysOrdersExtra - Исправлено определение статуса ордера OE_IT	
				 @0.1.17@2013.02.20@artamir	[*] sysArray - Исправлена функция Select	
				 @0.1.16@2013.02.20@artamir	[]	
				 @0.1.15@2013.02.20@artamir	[*] sysArray	
				 @0.1.14@2013.02.19@artamir	[]	
				 @0.1.13@2013.02.16@artamir	[]	
		>Author: Morochin <artamir> Artiom
		>Desc:
			Base include
			Manager for system include files.
		>Pref:
			non
		>Warning:
			DO NOT CHANGE!!!!
	*/

#property stacksize 16192			
	
#define	ELTVER	"0.1.0.50_2013.08.29"

//{	//Include	========================================
//{		@System	----------------------------------------
#include	<WinUser32.mqh>
#include	<sysDebug.mqh>
//----------------------------------------------------------
#include	<sysNormalize.mqh>								//Pref: Norm
#include	<sysStructure.mqh>								//Pref: Struc
#include	<sysOther.mqh>									
#include	<sysMarketInfo.mqh>								//Pref:	MI
//----------------------------------------------------------
#include	<sysArray.mqh>									//Pref:	A
#include	<sysArray2.mqh>									//Pref: A
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
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Отбор по магику
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/

	if(mn == -1){
		mn = TR_MN;
	}
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_MN, mn, -1, AS_OP_EQ);
	
	A_d_Select(s, d);
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByMethod_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	method	  /** magic number*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Отбор по методу
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_AOM, method, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}

int ELT_SelectPositions_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	bool 	add = false	  /** добавлять к массиву приемнику */){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Отбор по рыночным ордерам, которые еще не закрыты
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IM, 1, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}

int ELT_SelectOrders_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	bool	add = false	  /** добавлять к массиву приемнику*/){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Отбор по отложенным ордерам, которые еще не удалены
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_IT, 1, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IP, 1, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}

int ELT_SelectNearPrice_d2(double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	double 	pr=0	  /** уровень цены открытия*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
		
	/**
		\version	0.0.0.1
		\date		2013.09.06
		\author		Morochin <artamir> Artiom
		\details	Фильтрация по цене открытия.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.06@artamir	[]	ELT_DBFN
			>Rev:0
	*/

	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_OP, pr, -1, AS_OP_EQ);
	BP_SNP=false;
	A_d_Select(s, d, add);
	BP_SNP=false;
	//A_d_PrintArray2(s,4,"s");
	//A_d_PrintArray2(d,4,"d");
	return(ArrayRange(d, 0));
}					

int ELT_SelectByGL_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	gl=0	  /** уровень сетки*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Отбор по уровню сетки
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_GL, gl, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByMP_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	mp=0	  /** тикет основного родителя*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Отбор по основному родителю
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_MP, mp, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByLP_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	lp=0	  /** тикет локального родителя*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.0.1
		\date		2013.06.25
		\author		Morochin <artamir> Artiom
		\details	Отбор по локальному родителю.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.25@artamir	[]	ELT_deinit
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_LP, lp, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}


int ELT_SelectByFIR_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	fir=1	  /** is Revers?*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.0.2
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Отбор по признаку реверс ордера.
		\internal
			>Hist:		
					 @0.0.0.2@2013.06.28@artamir	[]	ELT_deinit
			
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_FIR, fir, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}

int ELT_SelectByFOTY_d2(		double	&s[][] /** source array */
							,	double	&d[][] /** destination array */	
							,	int 	foty	  /** first open type*/
							,	bool	add=false	/** добавлять результат к массиву-приемнику*/){
	/**
		\version	0.0.0.3
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	Отбор по признаку начального типа.
		\internal
			>Hist:			
					 @0.0.0.3@2013.09.05@artamir	[]	ELT_DBFN
					 @0.0.0.2@2013.06.28@artamir	[]	ELT_deinit
			
			>Rev:0
	*/
	
	A_eraseFilter();										
	
	A_FilterAdd_AND(OE_FOTY, foty, -1, AS_OP_EQ);
	
	A_d_Select(s, d, add);
	
	return(ArrayRange(d, 0));
}
//}