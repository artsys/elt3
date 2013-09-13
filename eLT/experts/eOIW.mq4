/**
	\version	3.0.1.17
	\date		2013.09.12
	\author		Morochin <artamir> Artiom
	\details	����� ���������� ��������� �� ���� ���������� eLT 3.0.1
				Orders in window.
	\internal
		������ ������ �� ���������� �������� ������������ ����� �� �������� ������.
		>Hist:																	
				 @3.0.1.17@2013.09.12@artamir	[+]	CheckNets
				 @3.0.1.16@2013.09.12@artamir	[*]	SendChild
				 @3.0.1.15@2013.09.11@artamir	[]	Convoy
				 @3.0.1.14@2013.09.11@artamir	[]	SendChild
				 @3.0.1.13@2013.09.11@artamir	[]	SendChild
				 @3.0.1.12@2013.09.10@artamir	[*]	SendChild ��������� ����������� �����, ���� ��� ������� ������� �����������.
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
#define EXP	"eOIW"	/** ��� �������� */
#define VER	"3.0.1.17_2013.09.12"		/** expert_version */
#define DATE "2013.09.05"	/** extert date */	
//}

//{ === expert DEFINES
//}

//{ === EXTERN VARIABLES
extern	string	s1="==== MAIN ====="; //{
extern	int			Step=20;	//��� ����� �������� � �������.	
extern	int			TP=150;		//���������� ����� � �������.	
extern	string	e1="==== EXPERT END =====";//}
//}

//{ === INCLUDES
#include <sysELT3.mqh>
//}

int init(){
	/**
		\version	0.0.0.0
		\date		2013.08.20
		\author		Morochin <artamir> Artiom
		\details	������� ������������� ���������.
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
		\details	������� ��������������� ���������
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
		\details	������� ����������� � ���������� ������ ����
		\internal
			>Hist:
			>Rev:0
	*/
	
	int h_tmr_start = TMR_Start("start");
	startext();
	int tmr_res = TMR_Stop(h_tmr_start);
	Comment("Start circle = "+tmr_res,"\n",
			"ver: ",VER,"\n",
			"date: ",DATE);
	//-------------------------------------
	return(0);
}

int startext(){
	/**
		\version	0.0.0.1
		\date		2013.08.28
		\author		Morochin <artamir> Artiom
		\details	���������� ������� start()
					����� �������� ��� ����������� ������-������ �������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.28@artamir	[]	startext
			>Rev:0
	*/

	ELT_start();
	//-------------------------------------
	
	//{		=== ���� �������� �������
	
	//..	=== ���� ������������� �������
		
		/*	�������� ���� ���������.
			��������: ��� ������ ����� ������� �� ���������� ���� ������ ���������� 
			��������������� ����� � ������ ��������������� �����.
		*/
		CheckNets();
		Convoy();
		
	//..	=== ���� �������� �������
		Autoopen();
	//}
	
	
	//-------------------------------------
	return(0);
}

//{ === autoopen
void Autoopen(){
	/**
		\version	0.0.0.1
		\date		2013.09.04
		\author		Morochin <artamir> Artiom
		\details	���������� ���������� �������� ������ �� ���������� ��� �� ����.
					�������: ���� ��� ����� �������� ���������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.04@artamir	[+]	Autoopen
			>Rev:0
	*/

	if(!isExpertsTickets()){
		SendParent(OP_BUYSTOP);
		SendParent(OP_SELLSTOP);
	}
}	

void SendSTOPNet(int ti){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	���������� ����� ������� �� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.05@artamir	[+]	SendSTOPNet
			>Rev:0
	*/

	T_SelOrderByTicket(ti);		//������� ������������ �����.
	int levels = CalcLevels();
	double start_price = OrderOpenPrice();
	double parent_tp = OrderTakeProfit();
	int parent_ty = OrderType();
	
	for(int i=1; i<=levels; i++){
		double level_price_pip = Step*i;
		int level_ti = -1;
		if(parent_ty==OP_BUY || parent_ty==OP_BUYSTOP){
			level_ti=TR_SendBUYSTOP(start_price, level_price_pip);
		}

		if(parent_ty==OP_SELL || parent_ty==OP_SELLSTOP){
			level_ti=TR_SendSELLSTOP(start_price, level_price_pip);
		}	
		
		TR_ModifyTP(level_ti,parent_tp);
		OE_setGLByTicket(level_ti,i+1);
		OE_setMPByTicket(level_ti,ti);
	}
	
}

//}

//{ === convoy
void Convoy(){
	/**
		\version	0.0.0.2
		\date		2013.09.11
		\author		Morochin <artamir> Artiom
		\details	������������� �������.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.11@artamir	[]	Convoy
					 @0.0.0.1@2013.09.05@artamir	[+]	Convoy
			>Rev:0
	*/
	
	double aPos[][OE_MAX];
	int pos_rows=SelectPositions(aPos);
	if(pos_rows<=0){return;} //������ � ��� ��� �������.
	
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

//��������� �����, ���� ��� ������������.
//���� �����-�� ����� �� ����������, ����� ���������� �����.
//�� ��� �������, ��� ���� ����� ������ ��������.
void CheckNets(){
	/**
		\version	0.0.0.1
		\date		2013.09.12
		\author		Morochin <artamir> Artiom
		\details	���������, ���� ���������� �����.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.12@artamir	[]	CheckNets
			>Rev:0
	*/

	double a[][OE_MAX];
	if(SelectExpertTickets(a)>0){
		double aB[][OE_MAX];
		if(ELT_SelectByFOTY_d2(a,aB,OP_BUYSTOP)<=0){
			if(Bid > 1.3280){
				A_d_PrintArray2(a,4,"eT");
				A_d_PrintArray2(aB,4,"eT");
			}
			SendParent(OP_BUYSTOP);
		}
		
		if(ELT_SelectByFOTY_d2(a,aB,OP_SELLSTOP)<=0){
			SendParent(OP_SELLSTOP);
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
		\details	���������, ���� ���������� ���� ���� ����� �����, ������� ����������� ���������.
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
		\details	���������� ���������� ������� �������� ��������.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.06@artamir	[*]	SelectExpertTickets ��������� �������� �������.
					 @0.0.0.1@2013.09.04@artamir	[+]	SelectExpertTickets
			>Rev:0
	*/
	
	double aMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aMN);
	if(!ROWS_MN){return(0);}
	ELT_SelectPositions_d2(aMN, aT);	//�� ��� �������� ������ �������	
	int ROWS_T = ELT_SelectOrders_d2(aMN, aT, true);	//� ��� ��������� ������.
	return(ROWS_T);
}

int SelectPositions(double &a[][]){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	�������� ����� ������� ��������
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.05@artamir	[+]	SelectPositions
			>Rev:0
	*/

	double aMN[][OE_MAX];
	int ROWS_MN = ELT_SelectByMN_d2(aOE, aMN);
	if(!ROWS_MN){return(0);}
	
	ELT_SelectPositions_d2(aMN, a);	//�� ��� �������� ������ �������	
	
	return(ArrayRange(a,0));
}

int SelectTINearPrice(double &a[][], double pr){
	/**
		\version	0.0.0.1
		\date		2013.09.06
		\author		Morochin <artamir> Artiom
		\details	����� ������� ����� ����.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.06@artamir	[+]	SelectTINearPrice
			>Rev:0
	*/

	double aT[][OE_MAX];
	int t_rows = SelectExpertTickets(aT);
	
	if(t_rows<=0){return(0);}
	
	int np_rows = ELT_SelectNearPrice_d2(aT, a, pr);
}

int SendChild(int parent_ti){
	/**
		\version	0.0.0.4
		\date		2013.09.12
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:				
					 @0.0.0.4@2013.09.12@artamir	[*]	��� ����������� ������� ������ ����� ���� ���� ���� ���� ���� �������� ��������� ������.
					 @0.0.0.3@2013.09.11@artamir	[]	SendChild
					 @0.0.0.2@2013.09.11@artamir	[*]	������������ �������� �����, ���� ��� ����������� ��������� ��������.
					 @0.0.0.1@2013.09.10@artamir	[*]	SendChild
			>Rev:0
	*/

	T_SelOrderByTicket(parent_ti);
	int parent_ty = OrderType();
	double parent_op=OrderOpenPrice();
	
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
	TR_SendPending_array(a, ty, parent_op, Step);
	int ti = a[0];
	OE_setGLByTicket(ti,(max_gl+1));
	OE_setLPByTicket(ti,parent_ti);
	TR_ModifyTP(ti,tp,tp_mode);
	
	if(max_gl <= 0){
		SendSTOPNet(ti);
	}
}

int SendParent(int ty){
	/**
		\version	0.0.0.0
		\date		2013.09.12
		\author		Morochin <artamir> Artiom
		\details	����������� ������� ������������ �������
		\internal
			>Hist:
			>Rev:0
	*/

	double a[];
	double start_pr=0.00;
	int rows_a=TR_SendPending_array(a, ty, start_pr, Step);
	
	for(int i=0; i<rows_a;i++){
		OE_setGLByTicket(a[i],1);
		TR_ModifyTP(a[i],TP,TR_MODE_PIP);
		SendSTOPNet(a[i]);
	}
}

double getTPNet(int ty){
	/**
		\version	0.0.0.0
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	���������� �� �� ���� ������� � �����.
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
	
	if(gl_rows<=0){return(0);} //��� �������� �����.
	
	double tp = aGL[0][OE_TP]; //���� ���� ���� ���� �������� �����, �� �� ����� � 0-� �������.
	
	return(tp);
	
}

int getMaxGL(int foty){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	���������� ������������ ������� ����� ��� ���������� ����.
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
	
	return(aFOTY[0][OE_GL]);
}

int CalcLevels(){
	/**
		\version	0.0.0.1
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	������ ���������� ������� � ����� �� �������� �� TP
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.05@artamir	[]	CalcLevels
			>Rev:0
	*/
	return(MathFloor(TP/Step)-1);
}
//}