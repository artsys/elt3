//+------------------------------------------------------------------+
//|                                                  iCandleProp.mq4 |
//|                                          Copyright 2014, artamir |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property version   "1.10"
#property strict
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 clrGray
#property indicator_color2 clrOrange
#property indicator_color3 clrBlue
#property indicator_color4 clrRed


#define NAME "CandleProp2"

string sName="";
string sUsedMode="";

//--- input parameters
input int      AVG_Period=15;
input string   sMode="0-high, 1-body, 2-low";
input int      Mode=0;
input bool     DrawThis=true;
//--- indicator buffers
double         ThisBuffer[];
//double         ThisColor[];
double         AVGBuffer[];
double         MaxBuffer[];
double         MinBuffer[];
//double         ThisUpBuffer[];
//double         ThisDwBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   SetIndexBuffer(0,ThisBuffer,INDICATOR_DATA);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);//,clrGray);

   //SetIndexBuffer(1,ThisColor,INDICATOR_COLOR_INDEX);
   
   //PlotIndexSetInteger(0, PLOT_COLOR_INDEXES,2);
   //PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,clrGreen);
   //PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,clrRed);

  // SetIndexBuffer(1,ThisUpBuffer);
  // SetIndexStyle(1,DRAW_NONE,STYLE_SOLID,2,clrDarkOrange);

   //SetIndexBuffer(2,ThisDwBuffer);
   //SetIndexStyle(2,DRAW_NONE,STYLE_SOLID,2,clrLightYellow);
   
   SetIndexBuffer(1,AVGBuffer);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT,1);//,clrOrange);
   
   SetIndexBuffer(2,MaxBuffer);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1);//,clrBlue);
   
   SetIndexBuffer(3,MinBuffer);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1);//,clrRed);
   
   
      
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
   
   sUsedMode="";
   if(Mode==0)sUsedMode="HIGH";
   if(Mode==1)sUsedMode="BODY";
   if(Mode==2)sUsedMode="LOW";   
   sName="iCandleProp v2 (MODE-"+sUsedMode+")";
   IndicatorShortName(sName);
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
   int limit=rates_total-prev_calculated-1;
   if(limit<0)limit=1;
   
   for(int i=limit;i>0;i--){
      int day_shift=iBarShift(Symbol(),PERIOD_D1,iTime(Symbol(),0,i));
      double dO=iOpen(Symbol(),PERIOD_D1,day_shift);
      double dC=iClose(Symbol(),PERIOD_D1,day_shift);
      double dH=iHigh(Symbol(),PERIOD_D1,day_shift);
      double dL=iLow(Symbol(),PERIOD_D1,day_shift);
      
      
      double dMax=0,dMin=0;
      if(Mode==0){dMax=dH; dMin=MathMax(dO,dC);}
      if(Mode==1){dMax=dO; dMin=dC;}
      if(Mode==2){dMax=MathMin(dO,dC);dMin=dL;}
      
      double val=0;
      val=MathAbs((dMax-dMin)/Point);
      
      ThisBuffer[i]=val;
      
      if(prev_calculated!=0 || i!=limit){
         if(ThisBuffer[i]>ThisBuffer[i+1]){
            //ThisUpBuffer[i]=ThisBuffer[i];
            //ThisDwBuffer[i]=0;
         }
         
         if(ThisBuffer[i]<ThisBuffer[i+1]){
            //ThisUpBuffer[i]=0;
            //ThisDwBuffer[i]=ThisBuffer[i];
         }
      }
      
      MaxBuffer[i]=ThisBuffer[ArrayMaximum(ThisBuffer,AVG_Period,i)];
      MinBuffer[i]=ThisBuffer[ArrayMinimum(ThisBuffer,AVG_Period,i)];
   } 
   
   for(int i=limit;i>0;i--){
      AVGBuffer[i]=iMAOnArray(ThisBuffer,0,AVG_Period,0,MODE_SMA,i);
      
      //if(ThisBuffer[i]>AVGBuffer[i]){
      //   ThisColor[i]=0;
      //}else{
      //   ThisColor[i]=1;
      //}
   }
   
   string txt=sName+": MAX "+sUsedMode+"="+DoubleToStr(MaxBuffer[1],0)+"; "+sUsedMode+"="+DoubleToStr(ThisBuffer[1],0)+"; MIN "+sUsedMode+"="+DoubleToStr(MinBuffer[1],0);
   IndicatorSetString(INDICATOR_SHORTNAME,txt);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

string iif(bool condition, string iftrue, string iffalse){
   if(condition)return(iftrue);
   
   return(iffalse);
}
