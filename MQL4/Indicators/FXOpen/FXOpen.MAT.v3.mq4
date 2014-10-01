#property copyright "MaxZ"
#property link      "zagizop@yandex.ru"
#property version    3.10

// Если у Вас есть идея для написания советника, индикатора или скрипта,
// то Вам может помочь следующая тема:
// http://forum.fxopen.ru/showthread.php?91373

// ТЗ для данного советника было предоставлено Пользователем Sanyok11 на форуме:
// http://forum.fxopen.ru/showthread.php?91373&p=1628399#post1628399

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 CLR_NONE
#property indicator_color2 Red

extern   string   s0             = "--- forum.FXOpen.ru ---";
extern   string   s1             = "Настройки для скользящей средней:";
extern   int      MA_Period      = 45;
extern   int      MA_Shift       = 0;
extern   int      MA_Method      = 1;
extern   int      MA_Price       = 0;

extern   string   s2             = "Дополнительные настройки:";
extern   int      MAT_Digits     = 3;
extern   bool     MAT_Refresh    = true;

extern   string   s3             = "Настройка толщины и цвета:";
extern   int      MAT_Width      = 2;
extern   color    MAT_Color      = Red;
extern   string   s4             = "-----------------------";
extern   bool     DelPropsOnDeinit=true;

string objName="MAT";

double MA[], MAT[];


int init()
{
   SetIndexStyle (0, DRAW_NONE);
   SetIndexBuffer(0, MA);
   SetIndexStyle (1, DRAW_ARROW, EMPTY, MAT_Width, MAT_Color);
   SetIndexBuffer(1, MAT);
   SetIndexArrow (1, 159);
   SetIndexDrawBegin(0, MA_Period+MA_Shift);
   
   string sParams=   ""
                  +  "@1p"
                  +  "@2p"
                  +  "@3p"+(string)MA_Period
                  +  "@4p"+(string)MA_Shift
                  +  "@5p"+(string)MA_Method
                  +  "@6p"+(string)MA_Price
                  +  "@7p"
                  +  "@8p"+(string)MAT_Digits
                  +  "@9p"+(string)MAT_Refresh
                  +  "@10p"
                  +  "@11p"+(string)MAT_Width
                  +  "@12p"+(string)MAT_Color
                  +  "@13p"
                  ;
   
   objName="MAT"+(string)Period();               
   if(ObjectFind(objName)==-1){
      ObjectCreate(objName,OBJ_TEXT,0,0,0,0,0);
      ObjectSetText(objName,sParams,0);
   }  
}

int deinit(){
if(!DelPropsOnDeinit)return; 
   if(ObjectFind(objName)>-1){
      ObjectDelete(objName);
   }
}

int start()
{
   int    i, counted_bars = IndicatorCounted();
   
   if (Bars <= MA_Period)
      return(0);
   
   if (counted_bars < 1)
      for(i = 0; i < Bars; i++)
      {
         MA [i] = EMPTY_VALUE;
         MAT[i] = EMPTY_VALUE;
      }
   
   int limit = Bars-counted_bars;
   if (counted_bars > 0) limit++;
   for (i = limit; i >= 0; i--)
   {
      MA[i] = iMA(NULL, 0, MA_Period, MA_Shift, MA_Method, MA_Price, i);
      if (NormalizeDouble(MA[i], MAT_Digits) > NormalizeDouble(MA[i+1], MAT_Digits)+0.5*Point || NormalizeDouble(MA[i], MAT_Digits) < NormalizeDouble(MA[i+1], MAT_Digits)-0.5*Point)
         MAT[i] = NormalizeDouble(MA[i], MAT_Digits);
   }
}