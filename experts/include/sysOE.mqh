	/**
		\version	3.1.0.7
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	–асширенна€ информаци€ об ордерах.
		\internal
			>Hist:							
					 @3.1.0.7@2014.03.03@artamir	[+]	OE2Str
					 @3.1.0.6@2014.03.03@artamir	[!]	OE_init
					 @3.1.0.5@2014.03.01@artamir	[+]	OE_setPBI
					 @0.0.0.4@2014.03.01@artamir	[+]	OE_addRow
					 @0.0.0.3@2014.03.01@artamir	[+]	OE_setPBT
					 @0.0.0.2@2014.03.01@artamir	[+]	OE_FIBT
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_init
			>Rev:0
	*/

//--- Main info {
#define	OE_TI	0	//OrderTicket()
#define	OE_TY	1	//OrderType()
#define OE_OOP	2	//то же самое что и пункт выше.
#define	OE_OOT	3	//OrderOpenTime()
#define	OE_TP	4	//OrderTakeProfit()
#define	OE_SL	5	//OrderStopLoss()
#define	OE_MN	6	//OrderMagicNumber()
#define	OE_LOT	7	//OrderLots()
#define OE_OPR	8	//OrderProfit()
#define	OE_IT	9	//Is in Terminal() if order is in terminal
#define	OE_IM	10	//IsMarket() if order type is OP_BUY || OP_SELL
#define	OE_IP	11	//IsPending() if order type >= 2
#define OE_OCT	12	//CloseTime()
#define OE_OCP	13	//ClosePrice()
#define OE_IC	14	//IsClosed() }

//------ Close data {
#define OE_CPP		15	//Close profit in pips with sign (-/+)
#define	OE_CTY		16	//Closed by sl/tp/from market (1,2,3);
#define OE_CP2SL	17	//–азность между ценой закрыти€ и сл в пунктах
#define OE_CP2TP	18	//–азность между ценой закрыти€ и тп в пунктах
#define OE_CP2OOP	19	//–азность между ценой закрыти€ и ценой открыти€ в пунктах }
#define OE_MAX		20

double	aOE[][OE_MAX];

string OE2Str(int i){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	—троковое представление контсант-индексов колонок
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	OE2Str
			>Rev:0
	*/

	switch(i){
		case 0: return("OE_TI");
		case 1: return("OE_TY");
		case 2: return("OE_OOP");
		case 3: return("OE_OOT");
		case 4: return("OE_TP");
		case 5: return("OE_SL");
		case 6: return("OE_MN");
		case 7: return("OE_LOT");
		case 8: return("OE_OPR");
		case 9: return("OE_IT");
		case 10: return("OE_IM");
		case 11: return("OE_IP");
		case 12: return("OE_CT");
		case 13: return("OE_CP");
		case 14: return("OE_IC");
		
		case 15: return("OE_CPP(close profit in pips)");
		case 16: return("OE_CTY(closing type)");
		case 17: return("OE_CP2SL");
		case 18: return("OE_CP2TP");
		case 19: return("OE_CP2OP");
		default: return("UDF");
	}
}


void OE_init(void){
	/**
		\version	0.0.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	»нициализаци€ массива ордеров.
		\internal
			>Hist:		
					 @0.0.0.2@2014.03.03@artamir	[!]	»справлена критическа€ ошибка.
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_init
			>Rev:0
	*/
	string fn="OE_init";
	ArrayResize(aOE,0);
}

int OE_addRow(int ti){
	/**
		\version	0.0.0.1
		\date		2014.03.01
		\author		Morochin <artamir> Artiom
		\details	ƒобавл€ет новую строку к массиву ордеров и устанавливает значение свойства тикет.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_addRow
			>Rev:0
	*/
	string fn="OE_addRow";
	int t=ArrayRange(aOE,0);t++;
	ArrayResize(aOE,t);t--;
	return(t);
}

int OE_FIBT(int ti){
	/**
		\version	0.0.0.1
		\date		2014.03.01
		\author		Morochin <artamir> Artiom
		\details	ѕоиск индекса элемента с заданным значением 
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_FIBT
			>Rev:0
	*/
	string fn="OE_FIBT";
	int aI[];
	ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	int idx=AId_SearchFirst2(aOE,aI,OE_TI,ti);
	if(idx==AI_NONE){
		idx=OE_addRow(ti);
	}else{
		idx=aI[idx];
	}
	return(idx);
}

int OE_setPBT(int ti, int prop, double val){
	/**
		\version	0.0.0.1
		\date		2014.03.01
		\author		Morochin <artamir> Artiom
		\details	”становка значени€ заданного свойства по тикету ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_setPBT
			>Rev:0
	*/
	string fn="OE_setPBT";
	int idx=OE_FIBT(ti);
	aOE[idx][prop]=val;
	return(idx);
}	

void OE_setPBI(int idx, int prop, double val){
	/**
		\version	0.0.0.1
		\date		2014.03.01
		\author		Morochin <artamir> Artiom
		\details	”станавливает значение заданного свойства по переданному индексу строки.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_setPBI
			>Rev:0
	*/
	aOE[idx][prop]=val;
}

int OE_setSTD(int ti){
	/**
		\version	0.0.0.0
		\date		2014.03.01
		\author		Morochin <artamir> Artiom
		\details	–ассчитывает и устанавливает стандартные данные по ордеру.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="OE_setSTD";
	if(!OrderSelect(ti, SELECT_BY_TICKET)) return(-1); //если ордер не найден, то выходим.
	int idx=OE_FIBT(ti);
	
	aOE[idx][OE_TI]	=		OrderTicket();
	aOE[idx][OE_TY]	=		OrderType();
	aOE[idx][OE_OOP]=		OrderOpenPrice();
	aOE[idx][OE_OOT]=(int)	OrderOpenTime();
	aOE[idx][OE_TP]	=		OrderTakeProfit();
	aOE[idx][OE_SL]	=		OrderStopLoss();
	aOE[idx][OE_MN]	=		OrderMagicNumber();
	aOE[idx][OE_LOT]=		OrderLots();
	aOE[idx][OE_OPR]=		OrderProfit();
	aOE[idx][OE_OCP]=		OrderClosePrice();
	aOE[idx][OE_OCT]=		OrderCloseTime();
	
	if(OrderCloseTime() == 0){
		aOE[idx][OE_IT]=	1;
		aOE[idx][OE_IC]=	0;
	}else{
		aOE[idx][OE_IT]=	0;
		aOE[idx][OE_IC]=	1;
	}
	
	if(OrderType()<=1){
		aOE[idx][OE_IM]=	1;
		aOE[idx][OE_IP]=	0;
	}else{
		aOE[idx][OE_IM]=	0;
		aOE[idx][OE_IP]=	1;
	}
	
	if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP){
		aOE[idx][OE_CPP]=	(OrderClosePrice()-OrderOpenPrice())/Point;
		aOE[idx][OE_CP2OOP]	=	(OrderClosePrice()-OrderOpenPrice())/Point;
	}else{
		aOE[idx][OE_CPP]=	(OrderOpenPrice()-OrderClosePrice())/Point;
		aOE[idx][OE_CP2OOP]	=	(OrderOpenPrice()-OrderClosePrice())/Point;
	}

	
	if(OrderStopLoss()>0){
		aOE[idx][OE_CP2SL]	=	MathAbs((OrderClosePrice()-OrderStopLoss())/Point);
	}else{
		aOE[idx][OE_CP2SL]	=	0;
	}	
	
	if(OrderTakeProfit()>0){
		aOE[idx][OE_CP2TP]	=	MathAbs((OrderClosePrice()-OrderTakeProfit())/Point);
	}else{
		aOE[idx][OE_CP2TP]	=	0;
	}

	return(idx);
}