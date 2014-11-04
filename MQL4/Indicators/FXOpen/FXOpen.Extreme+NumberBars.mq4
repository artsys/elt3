#property copyright "forum.FXOpen.ru - MaxZ"
#property link      "forum.FXOpen.ru"

// Данный индикатор был написан по заказу на форуме FXOpen в теме:
// http://forum.fxopen.ru/showthread.php?91373-%D0%9E%D1%82%D0%B4%D0%B0%D0%BC-%D1%81%D0%BE%D0%B2%D0%B5%D1%82%D0%BD%D0%B8%D0%BA-%D0%B8%D0%BD%D0%B4%D0%B8%D0%BA%D0%B0%D1%82%D0%BE%D1%80-%D0%B8%D0%BB%D0%B8-%D1%81%D0%BA%D1%80%D0%B8%D0%BF%D1%82-%D0%B7%D0%B0-%D0%B8%D0%B4%D0%B5%D1%8E

extern   string   s0                = "--- forum.FXOpen.ru ---";
extern   string   s1                = "Правила определения фрактала:";
extern   int      BarsForward       = 2;
extern   int      BarsBack          = 2;
extern   bool     ModeCE            = true;

extern   string   s2                = "Дополнительные настройки:";
extern   int      NumberOfBarsU_L   = 1;

extern   string   s3                = "Вкл./откл. алгоритмов:";
extern   bool     Algo1_Enable      = false;
extern   bool     Algo2_Enable      = false;

extern   string   s4                = "Настройка толщины и цвета:";
extern   int      Upper_Width       = 0;
extern   color    Upper_Color       = Silver;
extern   int      Lower_Width       = 0;
extern   color    Lower_Color       = Silver;
extern   int      Upper_Algo1_Width = 0;
extern   color    Upper_Algo1_Color = Aqua;
extern   int      Lower_Algo1_Width = 0;
extern   color    Lower_Algo1_Color = Aqua;
extern   int      Upper_Algo2_Width = 0;
extern   color    Upper_Algo2_Color = Magenta;
extern   int      Lower_Algo2_Width = 0;
extern   color    Lower_Algo2_Color = Magenta;
extern   string   s5                = "-----------------------";

#property indicator_chart_window
#property indicator_buffers 6

double   UA0[];
double   LA0[];
double   UA1[];
double   LA1[];
double   UA2[];
double   LA2[];

datetime TimeLastBar;

int      Bar, Pos, Cond;
bool     Upper, Lower;

bool     CE_U, CE_L;
int      CE_U_Bar, CE_L_Bar;

int      Dir;
double   Last;

int      E[];
int      EStep, EBar;

int init()
{
   IndicatorShortName("FXOpen.Extreme");
   SetIndexStyle(0, DRAW_ARROW, EMPTY, Upper_Width, Upper_Color);
   SetIndexStyle(1, DRAW_ARROW, EMPTY, Lower_Width, Lower_Color);
   SetIndexStyle(2, DRAW_ARROW, EMPTY, Upper_Algo1_Width, Upper_Algo1_Color);
   SetIndexStyle(3, DRAW_ARROW, EMPTY, Lower_Algo1_Width, Lower_Algo1_Color);
   SetIndexStyle(4, DRAW_ARROW, EMPTY, Upper_Algo2_Width, Upper_Algo2_Color);
   SetIndexStyle(5, DRAW_ARROW, EMPTY, Lower_Algo2_Width, Lower_Algo2_Color);
   SetIndexArrow(0, 164);
   SetIndexArrow(1, 164);
   SetIndexArrow(2, 164);
   SetIndexArrow(3, 164);
   SetIndexArrow(4, 164);
   SetIndexArrow(5, 164);
   SetIndexBuffer(0, UA0);
   SetIndexBuffer(1, LA0);
   SetIndexBuffer(2, UA1);
   SetIndexBuffer(3, LA1);
   SetIndexBuffer(4, UA2);
   SetIndexBuffer(5, LA2);
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, 0.0);
   SetIndexEmptyValue(2, 0.0);
   SetIndexEmptyValue(3, 0.0);
   SetIndexEmptyValue(4, 0.0);
   SetIndexEmptyValue(5, 0.0);
   SetIndexLabel(0, "Upper");
   SetIndexLabel(1, "Lower");
   SetIndexLabel(2, "Upper_Algo1");
   SetIndexLabel(3, "Lower_Algo1");
   SetIndexLabel(4, "Upper_Algo2");
   SetIndexLabel(5, "Lower_Algo2");
   
   TimeLastBar = 0;
   
   EStep = 0;
   ArrayResize(E, NumberOfBarsU_L);
   ArrayInitialize(E, 0);
}

int start()
{
   if (Bars-IndicatorCounted()+1 > BarsForward)
   {
      TimeLastBar = Time[0];
      Bar = Bars-1;
      while (Bar > BarsForward)
      {
         UA0[Bar] = 0.0;
         UA1[Bar] = 0.0;
         UA2[Bar] = 0.0;
         LA0[Bar] = 0.0;
         LA1[Bar] = 0.0;
         LA2[Bar] = 0.0;
         Bar--;
      }
      Bar = Bars-1;
      
      Dir = 0;
      EStep = 0;
      ArrayInitialize(E, 0);
   }
   else
   {
      if (TimeLastBar != Time[0])
      {
         TimeLastBar = Time[0];
         if (CE_U && CE_L)
         {
            CE_U_Bar++;
            CE_L_Bar++;
            Bar = MathMax(CE_U_Bar, CE_L_Bar);
         }
         else
         if (CE_U)
         {
            CE_U_Bar++;
            Bar = CE_U_Bar;
         }  
         else
         if (CE_L)
         {
            CE_L_Bar++;
            Bar = CE_L_Bar;
         }
         else
            Bar = BarsForward+1;
         
         for (Pos = 0; Pos < NumberOfBarsU_L; Pos++)
            if (E[Pos] > 0)
               E[Pos]++;
      }
   }
   
   while (Bar > BarsForward)
   {
      Upper = true;
      Lower = true;
      Cond = Bar+BarsBack;
      for (Pos = Bar+1; Pos <= Cond; Pos++)
         if (High[Bar] <= High[Pos])
         {
            Upper = false;
            break;
         }
      for (Pos = Bar+1; Pos <= Cond; Pos++)
         if (Low [Bar] >= Low [Pos])
         {
            Lower = false;
            break;
         }
      if (Upper)
      {
         if (ModeCE)
         {
            Pos = Bar-1;
            Cond = 0;
            if (High[Bar] == High[Pos])
            {
               CE_U = true;
               CE_U_Bar = Bar;
            }
            while (true)
            {
               if (High[Bar] < High[Pos])
               {
                  CE_U = false;
                  Upper = false;
                  break;
               }
               else
               if (High[Bar] > High[Pos])
                  CE_U = false;
               Pos--;
               Cond++;
               if (CE_U)
               {
                  if (Pos == 0)
                  {
                     Upper = false;
                     break;
                  }
               }
               else
                  if (Cond >= BarsForward)
                     break;
            }
         }
         else
         {
            Cond = Bar-BarsForward;
            for (Pos = Bar-1; Pos >= Cond; Pos--)
               if (High[Bar] < High[Pos])
               {
                  Upper = false;
                  break;
               }
         }
      }
      if (Lower)
      {
         if (ModeCE)
         {
            Pos = Bar-1;
            Cond = 0;
            if (Low [Bar] == Low[Pos])
            {
               CE_L = true;
               CE_L_Bar = Bar;
            }
            while (true)
            {
               if (Low [Bar] > Low [Pos])
               {
                  CE_L = false;
                  Lower = false;
                  break;
               }
               else
               if (Low [Bar] < Low [Pos])
                  CE_L = false;
               Pos--;
               Cond++;
               if (CE_L)
               {
                  if (Pos == 0)
                  {
                     Lower = false;
                     break;
                  }
               }
               else
                  if (Cond >= BarsForward)
                     break;
            }
         }
         else
         {
            Cond = Bar-BarsForward;
            for (Pos = Bar-1; Pos >= Cond; Pos--)
               if (Low [Bar] > Low [Pos])
               {
                  Lower = false;
                  break;
               }
         }
      }
      if (Upper)
      {
         if (Lower)
         {
            Dir = 0;
            UA0[Bar] = High[Bar];
            LA0[Bar] = Low [Bar];
            
            EBar = Bar;
         }
         else
         {
            EBar = Bar;
            
            if (Dir <= 0)
            {
               Dir = +1;
               UA0[Bar] = High[Bar];
               Last     = High[Bar];
            }
            else
            {
               if (High[Bar] > Last)
               {
                  if (Algo1_Enable)
                  {
                     UA1[Bar] = High[Bar];
                     Last     = High[Bar];
                  }
                  else
                     UA0[Bar] = High[Bar];
               }
               else
               if (High[Bar] < Last)
               {
                  if (Algo2_Enable)
                  {
                     UA2[Bar] = High[Bar];
                     Last     = High[Bar];
                  }
                  else
                     UA0[Bar] = High[Bar];
               }
               else
                  UA0[Bar] = High[Bar];
            }
         }
      }
      else
      {
         if (Lower)
         {
            EBar = Bar;
            
            if (Dir >= 0)
            {
               Dir = -1;
               LA0[Bar] = Low [Bar];
               Last     = Low [Bar];
            }
            else
            {
               if (Low [Bar] > Last)
               {
                  if (Algo1_Enable)
                  {
                     LA1[Bar] = Low [Bar];
                     Last     = Low [Bar];
                  }
                  else
                     LA0[Bar] = Low [Bar];
               }
               else
               if (Low [Bar] < Last)
               {
                  if (Algo2_Enable)
                  {
                     LA2[Bar] = Low [Bar];
                     Last     = Low [Bar];
                  }
                  else
                     LA0[Bar] = Low [Bar];
               }
               else
                  LA0[Bar] = Low [Bar];
            }
         }
      }
      
      if (Upper || Lower)
      {
         if (E[EStep] > 0)
         {
            UA0[E[EStep]] = 0.0;
            UA1[E[EStep]] = 0.0;
            UA2[E[EStep]] = 0.0;
            LA0[E[EStep]] = 0.0;
            LA1[E[EStep]] = 0.0;
            LA2[E[EStep]] = 0.0;
         }
         
         E[EStep] = EBar;
         EStep++;
         if (EStep == NumberOfBarsU_L)
            EStep = 0;
      }
      
      Bar--;
   }
}