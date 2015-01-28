#define DEBUG

#define sPref "SlosFiboNet"

struct signal_info_struc{
	int fibo1;
	int fibo2;
	int tf;
	double pvt_pr;
};

int aFibo[200];
int StartFiboIndex=0;

input ENUM_TIMEFRAMES TFPivot=PERIOD_D1;
input int MaxLevels=10;
input int StartLevel=21;
input bool drawPVT=false;

void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

#include  <sysBase.mqh>

//+------------------------------------------------------------------+
//|EXP_EventMNGR                                                                  |
//+------------------------------------------------------------------+
void EXP_EventMNGR(int ti, int event){
}

void OnInit(){
	CalcFiboLevels();
}

void OnTick(){
	DPRINT("=== START ===");
	startext();
}

void startext(){
	
	DPRINT("");
	Autoopen();
	DPRINT("Autoopen");
	signal_info_struc sig=GetSignal();
	DPRINT("GetSignal");
	Comment(""
				,"\n","s.fibo1=",sig.fibo1
				,"\n","s.fibo2=",sig.fibo2
				,"\n","s.tf=",sig.tf
				,"\n","s.pvt=",sig.pvt_pr);
}

void Autoopen(){
	signal_info_struc sig=GetSignal();
	
	double _lvl_up_pr=sig.pvt_pr+(sig.fibo1>sig.fibo2)?sig.fibo1:sig.fibo2*Point;
	double _lvl_dw_pr=sig.pvt_pr+(sig.fibo1<sig.fibo2)?sig.fibo1:sig.fibo2*Point;
}

signal_info_struc GetSignal(){
	signal_info_struc sig;
	
	double pvt_pr=GetPVT();
	
	int f1,f2=0;
	GetNearestFibo(pvt_pr,f1,f2);
	
	sig.pvt_pr=pvt_pr;
	sig.fibo1=f1;
	sig.fibo2=f2;
	sig.tf=TFPivot;
	return(sig);
}

void GetNearestFibo(double pvt, int &f1, int &f2){
	double _pr=(Bid);
	int _cnt=ROWS(aFibo);
	
	struct fibo_struct{
		int _this;
		int prev;
	};
	
	int _plus_this=0;
	int _plus_prev=0;
	int _minus_this=0;
	int _minus_prev=0;
	int _res_this=0;
	int _res_prev=0;
	
	for(int i=StartFiboIndex; i<10;i++){
		
		int k=(Digits==3 || Digits==5)?10:1;
		
		_plus_this=aFibo[i]*k;
		double this_pr=pvt+_plus_this*Point;
		double prev_pr=pvt+_plus_prev*Point;
		if(_pr>prev_pr && _pr<this_pr){
			_res_this=_plus_this;
			_res_prev=_plus_prev;
			break;
		}

		_minus_this=aFibo[i]*k;
		this_pr=pvt-_minus_this*Point;
		prev_pr=pvt-_minus_prev*Point;
		if(_pr<prev_pr && _pr>this_pr){
			_res_this=-_minus_this;
			_res_prev=-_minus_prev;
			break;
		}
		
		_plus_prev=_plus_this;
		_minus_prev=_minus_this;
	}
	
	if(_res_prev!=_res_this){
		f1=_res_prev;
		f2=_res_this;
	}
}

double GetPVT(){
	int start_bar=iBarShift(NULL,0,iTime(NULL,TFPivot,1));
	DPRINT("start_bar="+start_bar);
	int end_bar=iBarShift(NULL,0,iTime(NULL,TFPivot,0));
	
	int cnt=start_bar-end_bar;
	int min_bar=iLowest(NULL,0,MODE_LOW,cnt,end_bar);
	int max_bar=iHighest(NULL,0,MODE_HIGH,cnt,end_bar);
	
	double _c=0;//iClose(NULL,0,(end_bar+1));
	double _h=0;//iHigh(NULL,0,max_bar);
	double _l=0;//iLow(NULL,0,min_bar);
	
	for(int i=0; i<cnt;i++){
		_c+=iClose(NULL,0,(start_bar-i));
		_h+=iHigh(NULL,0,(start_bar-i));
		_l+=iLow(NULL,0,(start_bar-i));
	}
	
	_c/=cnt;
	_h/=cnt;
	_l/=cnt;
	
	double pvt=(_h+_l+_c)/3;
	string name=sPref+"#PVT#"+(int)Time[start_bar];
	if(drawPVT){
		DrawTLine(name,Time[end_bar],pvt,(Time[end_bar]+60*TFPivot),pvt,1);
	}
	
	return(pvt);
}

void DrawTLine(string Name, datetime dtTime1, double dPr1, datetime dtTime2, double dPr2, int w=1){
	if(ObjectFind(Name)<=-1){
		ObjectCreate(Name,OBJ_TREND,0,dtTime1,dPr1,dtTime2,dPr2);
	}
	
	ObjectSet(Name,OBJPROP_TIME1,dtTime1);
	ObjectSet(Name,OBJPROP_PRICE1,dPr1);
	ObjectSet(Name,OBJPROP_TIME2,dtTime2);
	ObjectSet(Name,OBJPROP_PRICE2,dPr2);
	ObjectSet(Name,OBJPROP_RAY,false);
	ObjectSet(Name,OBJPROP_WIDTH,w);
}


void CalcFiboLevels(){
	for(int i=1;i<50;i++){
		if(i==1){
			aFibo[i]=1;
		}else{
			aFibo[i]=GetNextFibo(aFibo[i-1]);
		}	
	}
}

int GetNextFibo(int thisFibo){
	int a=1,b=1,i=1;
	while(b<thisFibo+1){
		b=a+b;
		a=b-a;
		i++;
	}
	return(b);
}
