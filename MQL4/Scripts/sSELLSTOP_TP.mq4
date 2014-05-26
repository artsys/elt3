//+------------------------------------------------------------------+
//|                                                  sBYUSTOP_TP.mq4 |
//|                                          Copyright 2012, artamir |
//|                                                 forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, artamir"
#property link      "http:\\forexmd.ucoz.org"

#property show_inputs

extern double PriceStart = 0.0;
extern int    StartStep = 5; //���������� �� ��������� ���� �� ������� ������
extern int    EndStep = 10; //���������� �� ���������� ������ �� ������ ��
extern int    OrderStep = 3; //���������� ����� ��������
extern int    TP = 50; //�� � ������� �� ������� ������
extern double Lot = 0.1; //��� ������������ �������.
extern double LotPlus = 0.1; //����������� ���
extern int    EQLevels = 5; //���������� ������� � ���������� �������.
extern int	  KolSetok=1; //���������� ������������ �����.

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
SendingOrders();
//----
   return(0);
  }
//+------------------------------------------------------------------+

void SendingOrders(){
/*
*/
SendingSELLSTOP();
}

void SendingSELLSTOP(){
/*
*/

int realLength = TP-EndStep;
int numberOfOrders = realLength / OrderStep;
double startPriceToSend = MarketInfo(Symbol(), MODE_ASK);
if(PriceStart > 0){
   startPriceToSend = PriceStart;
}
//--------------------------------------
int plusPips = StartStep;
int sendTP = TP;
//--------------------------------------
for(int i = 0; i < numberOfOrders; i++){
   if(i > 0){
      plusPips = plusPips+OrderStep;
      sendTP = sendTP-OrderStep;
   }   
	for(int k=0; k<KolSetok;k++){
		OpenSELLSTOP(startPriceToSend, plusPips, CalcLots(i), sendTP);   
	}	
} 
}

double CalcLots(int l /**�����*/){
   
   int koef = MathRound(l/EQLevels);
   
   double r = Lot+koef*LotPlus;
   
   return(r);
}

int OpenSELLSTOP(double startPrice, int plusPips, double sendLot = 0.1, int tp_pip = 0){
   string osy = Symbol();
   int oty = OP_SELLSTOP;
   double op = startPrice - plusPips*Point;
   double ol = sendLot;
   double otp = op-tp_pip*Point;   
   
   SendOrder(oty, ol, op, 0, otp);
}

int SendOrder(int ty, double l = 0.1, double p = 0, double psl = 0, double ptp = 0, string c = "", int m = 0, string sy = "", datetime ex = 0, color cl = CLR_NONE){
/*
*/
   //---------------------------------------------------------
   if(sy == ""){
      sy = Symbol();
   }
   //---------------
   string osy = sy;
   int oty = ty;
   double ol = l;
   double op = p;
   double osl = psl;
   double otp = ptp;
   string oc = c;
   int omn = m;
   datetime oex = ex;
   color ocl = cl;
   
   //---------------------------------------------------------
   OrderSend(osy, oty, ol, op, 1, osl, otp, oc, omn, oex, ocl);
}

