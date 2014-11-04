//+------------------------------------------------------------------+
//|                                        iFXO.PivotAbsolutFibo.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.10"
#property strict
#property indicator_chart_window

#property indicator_buffers 1
#property indicator_plots   1
//--- plot MAT
#property indicator_label1  "Pivot"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

input ENUM_TIMEFRAMES TFPivot=PERIOD_D1;
input bool DrawLevels=true;
input int DrawBegin=300;
input int MaxLevels=3;
input int StartLevel=21;
//ряд фибо=1,1,2,3,5,8,13,21,34,55,89,144,

string sPref="#PivotAbs"+(int)TimeLocal();
double Pivot[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
  if(Period()>TFPivot){
  	Print("ERROR in TFPivot");
  	Print("Выберите для расчета пивота больший таймфрейм");
  	Print("Или запустите индикатор на меньшем таймфрейме");
  	return(INIT_PARAMETERS_INCORRECT);
  } 
  
  SetIndexBuffer(0,Pivot);
//---
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason){
	if(DrawLevels){
		DeleteObjects();
	}
}  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
                
  {
//---
	  if(rates_total<Bars)return(0);
	
	  int lim=rates_total-prev_calculated;
	  
	  if(lim>1){
	   ArrayInitialize(Pivot,0.0);
	  }
	  
	  if(lim<0)lim=1;
	  
	  if(lim>1)lim=rates_total;
	  
	  lim--;
	  
	  for(int i=lim;i>=0;i--){
	  	//для текущего бара найдем индекс соответствующего бара TFPivot.
	  	int tfpBar=iBarShift(NULL,TFPivot,Time[i],true);
	  	if(tfpBar<0){
	  		Print("Нет истории для тф:"+TFPivot+" за "+(datetime)Time[i]);
	  		continue;
	  	}
	  	
	  	tfpBar++;//получили индекс бара для нахождения пивота.
	  	Pivot[i]=(iHigh(NULL,TFPivot,tfpBar)
	  				+iLow(NULL,TFPivot,tfpBar)
	  				+iClose(NULL,TFPivot,tfpBar))/3;
	  				
	  				if(DrawLevels&&tfpBar<=DrawBegin){
	  					pDrawLevels(i,(tfpBar-1));
	  				}
	  	
	  }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

int aFibo[];

int GetNextFibo(int thisFibo){
	int a=1,b=1,i=1;
	while(b<thisFibo+1){
		b=a+b;
		a=b-a;
		i++;
	}

	return(b);
}

void pDrawLevels(int BarIndex, int tfpBarIndex){
	int thisFibo=StartLevel-1;
	for(int i=0; i<MaxLevels; i++){
		thisFibo=GetNextFibo(thisFibo);
		
		datetime dtStart=iTime(NULL,TFPivot,tfpBarIndex);
		datetime dtEnd=iTime(NULL,TFPivot,tfpBarIndex-1);
		double w=MathFloor((double)i/((double)MaxLevels/3.0)+1);
		
		if(dtEnd<=0){
			dtEnd=dtStart+TFPivot*60;
		}
		
		double pvt=Pivot[BarIndex];
		
		int dig=(Digits==3||Digits==5)?10:1;
		double pr=pvt+thisFibo*dig*Point;
		string name=sPref+"@l"+thisFibo+"@t"+(int)dtStart;
		DrawTLine(name,dtStart,pr,dtEnd,pr,w);
		
		pr=pvt-thisFibo*dig*Point;
		name=sPref+"@l-"+thisFibo+"@t"+(int)dtStart;
		DrawTLine(name,dtStart,pr,dtEnd,pr,w);
	}
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

void DeleteObjects(){
	int t=ObjectsTotal();
	for(int i=t-1;i>=0;i--){
		string n=ObjectName(i);
		if(StringFind(n,sPref)>=0){
			ObjectDelete(n);
		}
	}
}