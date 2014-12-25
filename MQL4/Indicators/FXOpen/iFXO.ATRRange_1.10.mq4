//+------------------------------------------------------------------+
//|                                                iFXO.ATRRange.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.20"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot Up
#property indicator_label1  "Up"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrViolet
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Dw
#property indicator_label2  "Dw"
#property indicator_type2   DRAW_SECTION
#property indicator_color2  clrViolet
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Mid
#property indicator_label3  "Mid"
#property indicator_type3   DRAW_SECTION
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

input ENUM_TIMEFRAMES TF=PERIOD_H1;
input ENUM_TIMEFRAMES ATR_TF=PERIOD_D1;
input int ATR_Per=14;
//--- indicator buffers
double         UpBuffer[];
double         DwBuffer[];
double         MidBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,DwBuffer);
   SetIndexBuffer(2,MidBuffer);
   
//---
   return(INIT_SUCCEEDED);
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
   ArrayInitialize(UpBuffer,0.0);
   ArrayInitialize(DwBuffer,0.0);
	ArrayInitialize(MidBuffer,0.0);
  }
  
  if(lim<0)lim=1;
  
  if(lim>1)lim=rates_total;
//--- return value of prev_calculated for next call

	for(int i=lim-1; i>=0; i--){
		
		int H1_open_index=iBarShift(NULL,TF,Time[i]);
		MidBuffer[i]=iOpen(NULL,TF,H1_open_index);
		
		double atr=GetATR(i);
		UpBuffer[i]=MidBuffer[i]+atr/2;
		DwBuffer[i]=MidBuffer[i]-atr/2;
	}
   return(rates_total);
  }
//+------------------------------------------------------------------+

double GetATR(int start_bar){
	double _max=0,_min=100000;
	//for(int i=start_bar; i<start_bar+Per; i++){
		int shift=iBarShift(NULL,ATR_TF,Time[start_bar]);
		double atr=iATR(NULL,ATR_TF,ATR_Per,shift);
		_max=MathMax(_max,atr);
		//_min=MathMin(_min,atr);
	//}
	
	return(_max);
}