/**
	\version	3.0.1.1
	\date		2013.08.28
	\author		Morochin <artamir> Artiom
	\details	Шабон построения советника на базе фреймворка eLT 3.0.1
	\internal
		>Hist:	
				 @3.0.1.1@2013.08.28@artamir	[]	startext
		>Rev:0
*/
	
//{ === DEFINES
#define EXP	"expert_name"	/** имя эксперта */
#define VER	"3.0.1.1"		/** expert_version */
#define DATE "2013.08.20"	/** extert date */	
//}

//{ === expert DEFINES
//}

//{ === EXTERN VARIABLES
//}

//{ === INCLUDES
#include <sysELT3.mqh>
//}

int init(){
	/**
		\version	0.0.0.0
		\date		2013.08.20
		\author		Morochin <artamir> Artiom
		\details	Функция инициализации советника.
		\internal
			>Hist:
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
	int tmr_res = TMR_Stop(h_tmr_start);
	Comment("Start circle = "+tmr_res);
	//-------------------------------------
	return(0);
}

int startext(){
	/**
		\version	0.0.0.1
		\date		2013.08.28
		\author		Morochin <artamir> Artiom
		\details	расширение функции start()
					можно вызывать при наступлении какого-нибудь условия.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.28@artamir	[]	startext
			>Rev:0
	*/

	ELT_start();
	
	//-------------------------------------
	return(0);
}

//{ === expert additional fincrions

//}