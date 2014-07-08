	/**
		\version	3.1.0.14
		\date		2014.07.07
		\author		Morochin <artamir> Artiom
		\details	Расширенная информация об ордерах.
		\internal
			>Hist:													
			       @3.1.0.14@2014.07.07@artamir	[+]	OE_USR2
					 @3.1.0.13@2014.03.08@artamir	[+]	OE_delClosed
					 @3.1.0.12@2014.03.07@artamir	[!]	OE_FIBT
					 @3.1.0.10@2014.03.07@artamir	[+]	OE_delClosed
					 @3.1.0.9@2014.03.06@artamir	[*]	OE_setCLS
					 @3.1.0.8@2014.03.05@artamir	[+]	OE_getPBT
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
#define	OE_TI    0	//OrderTicket()
#define	OE_TY	   1	//OrderType()
#define  OE_OOP	2	//то же самое что и пункт выше.
#define	OE_OOT	3	//OrderOpenTime()
#define	OE_TP	   4	//OrderTakeProfit()
#define	OE_SL	   5	//OrderStopLoss()
#define	OE_MN	   6	//OrderMagicNumber()
#define	OE_LOT	7	//OrderLots()
#define  OE_OPR	8	//OrderProfit()
#define	OE_IT	   9	//Is in Terminal() if order is in terminal
#define	OE_IM	   10	//IsMarket() if order type is OP_BUY || OP_SELL
#define  OE_IP	   11	//IsPending() if order type >= 2
#define  OE_OCT	12	//CloseTime()
#define  OE_OCP	13	//ClosePrice()
#define  OE_IC	   14	//IsClosed() }

//------ Close data {
#define OE_CPP		15	//Close profit in pips with sign (-/+)
#define	OE_CTY	16	//Closed by sl/tp/from market (1,2,3);
#define OE_CP2SL	17	//Разность между ценой закрытия и сл в пунктах
#define OE_CP2TP	18	//Разность между ценой закрытия и тп в пунктах
#define OE_CP2OOP	19	//Разность между ценой закрытия и ценой открытия в пунктах }

#define OE_BOT    20 //

#define OE_USR1   21
#define OE_USR2   22
#define OE_MAX		23

double	aOE[][OE_MAX];

string OE2Str(int i){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Строковое представление контсант-индексов колонок
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
		case 20: return("OE_BOT");
		case 21: return("OE_USR1");
		case 22: return("OE_USR2");
		default: return("UDF");
	}
}


void OE_init(void){
	/**
		\version	0.0.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Инициализация массива ордеров.
		\internal
			>Hist:		
					 @0.0.0.2@2014.03.03@artamir	[!]	Исправлена критическая ошибка.
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
		\details	Добавляет новую строку к массиву ордеров и устанавливает значение свойства тикет.
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
		\version	0.0.0.3
		\date		2014.03.07
		\author		Morochin <artamir> Artiom
		\details	Поиск индекса элемента с заданным значением 
		\internal
			>Hist:		
					 @0.0.0.3@2014.03.07@artamir	[!]	Исправлен баг с поиском элемента.
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_FIBT
			>Rev:0
	*/
	string fn="OE_FIBT";
	int aI[];
	ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	AId_InsertSort2(aOE,aI,OE_TI);
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
		\details	Установка значения заданного свойства по тикету ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.01@artamir	[+]	OE_setPBT
			>Rev:0
	*/
	zx
	string fn="OE_setPBT";
	int idx=OE_FIBT(ti);
	aOE[idx][prop]=val;
	
	//zxadd("aOE["+(string)idx+"]["+(string)prop+"]="+(string)aOE[idx][prop])
	//xz
	
	return(idx);
}	

void OE_setPBI(int idx, int prop, double val){
	/**
		\version	0.0.0.1
		\date		2014.03.01
		\author		Morochin <artamir> Artiom
		\details	Устанавливает значение заданного свойства по переданному индексу строки.
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
		\details	Рассчитывает и устанавливает стандартные данные по ордеру.
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
	aOE[idx][OE_OPR]=		OrderProfit()+OrderCommission();
	DPRINT("OrderProfit="+OrderProfit());
	aOE[idx][OE_OCP]=		OrderClosePrice();
	aOE[idx][OE_OCT]=(int)	OrderCloseTime();
	
	if((int)OrderCloseTime() == 0){
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

int OE_setCLS(int ti){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Устанавливает значения закрытого ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	OE_setCLS
			>Rev:0
	*/
	string fn="OE_setCLS";
	if(!OrderSelect(ti,SELECT_BY_TICKET)) return(-1);
	int idx=OE_setSTD(ti);
	
	return(idx);
}

double OE_getPBT(int ti, int prop){
	/**
		\version	0.0.0.1
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение свойства заданного тикета.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.05@artamir	[+]	OE_getPBT
			>Rev:0
	*/
	string fn="OE_getPBT";
	
	int idx=OE_FIBT(ti);
	double val=aOE[idx][prop];
	
	return(val);
}

// Сервисные функции
void OE_delClosed_v0(){
	/**
		\version	0.0.0.1
		\date		2014.03.07
		\author		Morochin <artamir> Artiom
		\details	Удаление закрытых ордеров из массива.
		\internal
			>Hist:		
					 @0.0.0.1@2014.03.07@artamir	[]	OE_delClosed
			>Rev:0
	*/

	string fn="OE_delClosed";
	double t[][OE_MAX];
	ArrayResize(t,0);
	
	string f="";
	f=StringConcatenate(OE_IT,"==1");
		
		int aI[];
		ArrayResize(aI,0);
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		B_Select(aOE, aI, f);
		int rows=ArrayRange(aI,0);
		
		if(rows<=0)return;
		
		for(int idx = 0; idx < rows; idx++){
			AId_CopyRow2(aOE, t, aI[idx]);
		}	
		
		ArrayResize(aOE,ArrayRange(t,0));
		ArrayCopy(aOE,t,0,0,WHOLE_ARRAY);
}

void OE_delClosed(){
	/**
		\version	0.0.0.1
		\date		2014.03.08
		\author		Morochin <artamir> Artiom
		\details	Удаляет закрытые ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.08@artamir	[+]	OE_delClosed
			>Rev:0
	*/

	string fn="OE_delClosed";
	//DPRINT2();
	if(bNeedDelClosed)bNeedDelClosed=false;
	B_Start();
	ArrayResize(aOE,ArrayRange(aEC,0));
	ArrayCopy(aOE,aEC,0,0,WHOLE_ARRAY);
}

void OE_Move(int dest, int src, int count=-1){
   if(count==0 || dest==src)return;
   
   if(dest<src){
      for(int i=0;i<count;i++){
         if(src+i>ArrayRange(aOE,0)-1)continue;
         for(int c=0;c<OE_MAX; c++){
            aOE[dest+i][c]=aOE[src+i][c];
         }
      }
   }
}

void OE_DelPending(){
   int rows=ArrayRange(aOE,0);
   for(int i=rows-1;i>=0;i--){
      if(aOE[i][OE_IC]==1 && aOE[i][OE_IP]==1){
         if(i==ArrayRange(aOE,0)-1){
            ArrayResize(aOE,(rows-1));
            continue;
         }
         OE_Move(i,i+1,rows-i-1);
      }
   }  
}

double aOEData[][OE_MAX];
void OE_aDataErase(){
   ArrayResize(aOEData,0);
}

void OE_aDataSetProp(int col, double val){
   if(ArrayRange(aOEData,0)<=0){
      ArrayResize(aOEData,1);
      ArrayInitialize(aOEData,EMPTY_VALUE);
   }
   
   aOEData[0][col]=val;
}

void OE_aDataSetInOE(int idx_OE=0){
   if(ArrayRange(aOEData,0)<=0)return;
   
   for(int c=0;c<OE_MAX;c++){
      double val=aOEData[0][c];
      
      if(val==EMPTY_VALUE)continue;
      aOE[idx_OE][c]=val;   
   }
   
   OE_aDataErase();
}