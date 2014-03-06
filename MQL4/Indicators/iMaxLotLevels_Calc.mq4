//+------------------------------------------------------------------+
//|                                                iMaxLotLevels.mq4 |
//|                                          Copyright 2014, artamir |
//|                                          http:\\forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "1.00"
#property strict
#property indicator_chart_window
double MarginPerLot=0.0;
double TickValuePerLot=0.0;
double TickSizePerPoint=0.0;

input double Multy=1;//Увеличение депозита на 100%
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
   
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
   MarginPerLot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   TickValuePerLot=MarketInfo(Symbol(),MODE_TICKVALUE);
   TickSizePerPoint=MarketInfo(Symbol(),MODE_TICKSIZE);
   
   double start_price=Bid;
   int levels=5;
   int step=0;
   double lot_this=0.0;
   
   double TotalProfit=0.0;
   double lot_prev=0.0;
   double lot_prev_total=0.0;
   double CalcProfit=AccountBalance()*Multy;
   int LSP=0;
   int LSP_total=0;
   int eq_levels=0;
   
   string c="";
   int i=-1;
   while(TotalProfit<CalcProfit){
      i++;
      double MPL=MarginPerLot;
      double LotStep=MarketInfo(Symbol(),MODE_LOTSTEP);
      double LotStepMargin=MPL*LotStep;
      int LotStepPoints=0;
      if(lot_prev_total>0){
         LotStepPoints=LotStepMargin/(TickValuePerLot*lot_prev_total);
      }   
      
      LSP=MathMax(LSP,LotStepPoints);
      LSP_total+=LSP;
      
      TotalProfit+=lot_prev_total*LSP*TickValuePerLot;
      lot_this=(AccountBalance()+TotalProfit)/MPL-lot_prev_total;
      lot_this=NormalizeDouble(lot_this,2);
      
      if(lot_this==lot_prev&&eq_levels>0){
         eq_levels++;
      }else{
         if(eq_levels==0){
            eq_levels++;
         }
      }
      
      double tv=TickValuePerLot*lot_this;
      
      c=StringConcatenate(c,"\n","lvl=",i
      ,"; L=",DoubleToStr(lot_this,2)
      ,"; S=",LSP
      ,"; M=",DoubleToStr(MPL,2)
      ,"; TP=",DoubleToStr(TotalProfit,2)
      ,"; TV=",DoubleToStr(tv,2)
      ,"; TS=",TickSizePerPoint
      ,"; LP=",DoubleToStr(lot_prev,2)
      ,"; LPT=",DoubleToStr(lot_prev_total,2));
      
      lot_prev=lot_this;
      lot_prev_total+=lot_this;
      
   }
   
   Comment(c
   ,"\n"
   ,"TP=",LSP_total
   ,"; EQ_LVL=",eq_levels
   );
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
