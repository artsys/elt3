#property copyright "forum.FXOpen.ru - MaxZ"
#property link      "forum.FXOpen.ru"

// Данный советник был написан по заказу на форуме FXOpen в теме:
// http://forum.fxopen.ru/showthread.php?91373-%D0%9E%D1%82%D0%B4%D0%B0%D0%BC-%D1%81%D0%BE%D0%B2%D0%B5%D1%82%D0%BD%D0%B8%D0%BA-%D0%B8%D0%BD%D0%B4%D0%B8%D0%BA%D0%B0%D1%82%D0%BE%D1%80-%D0%B8%D0%BB%D0%B8-%D1%81%D0%BA%D1%80%D0%B8%D0%BF%D1%82-%D0%B7%D0%B0-%D0%B8%D0%B4%D0%B5%D1%8E

// Советник основан на идеях al22bag.
// За основу советника был взят известный в интернете советник - Buldozer.
// В советнике используется трал первого ордера, идею которого предложил Скиталка.
// В разработке советника (трактовка ТЗ) активное участие принимал - Mik 2806. Огромное Ему спасибо!

extern   string   s0                   = "--- forum.FXOpen.ru ---";
extern   string   s1                   = "Общие параметры:";
extern   int      Slippage             = 2;
extern   int      Magic                = 5032021;
extern   int      TradesMax            = 10;

extern   string   s2                   = "Настройки торгового алгоритма:";
extern   int      SignalMirror         = 0;
extern   int      SignalMode           = 1;
extern   int      SignalTimeFrame      = 3;
extern   int      SignalBars           = 10;
extern   int      SignalDelta          = 36;
extern   int      InverseEnable        = 1;
extern   int      InverseCloseWithMain = 0;
extern   int      EnforceEnable        = 0;
extern   int      EnforcedStart        = 2;
extern   int      EnforcedStop         = 8;

extern   string   s3                   = "Настройки Money Management'а:";
extern   double   Risk                 = 0.1;
extern   double   LotsInit             = 0.01;
extern   double   LotsExp              = 2.0;
extern   double   LotsAdd              = 0.0;
extern   double   LotsPrev             = 0.0;
extern   int      LotsPrevFirst        = 0;
extern   double   LotsMax              = 100;
extern   int      OppositionEnable     = 1;
extern   int      OppositionStart      = 2;
extern   double   OppositionLotsExp    = 0.3;

extern   string   s4                   = "Настройки PipStep'а:";
extern   int      PipStepInit          = 45;
extern   double   PipStepExp           = 1.2;
extern   int      PipStepAdd           = 5;
extern   double   PipStepPrev          = 0.0;
extern   int      PipStepPrevFirst     = 0;
extern   int      PipStepDynamicStart  = 3;
extern   int      PipStepInverseCorrect= 0;

extern   string   s5                   = "Настройки TakeProfit'а:";
extern   int      TakeProfitFirst      = 200;
extern   int      TakeProfitMode       = 1;
extern   int      TakeProfitRound      = 1;
extern   int      TakeProfit           = 200;

extern   string   s6                   = "Параметры для TrailingStop'а первого ордера:";
extern   bool     BreakevenLevelEnable = false;
extern   int      BreakevenLevel       = 10;
extern   bool     TrailingEnable       = false;
extern   int      TrailingStart        = 10;
extern   int      TrailingStop         = 10;
extern   int      TrailingStep         = 1;

extern   string   s7                   = "Дополнительные настройки:";
extern   bool     DebugAlgorithm       = false;
extern   bool     DebugTrade           = false;
extern   bool     ShowInfo             = false;
extern   int      Pause                = 0;
extern   color    Color_Buy            = Blue;
extern   color    Color_Sell           = Red;
extern   string   s8                   = "-------------------------";

string   Symb;
datetime TimeLastBar;
bool     SendB, SendS;

double   Lots, OP, SL, TP, Temp;
int      Pos, Ticket, Error;

int      Bs, Ss, BsTemp, SsTemp;
double   LotsB   , LotsS   , LotsBPrev   , LotsSPrev   , LotsBTemp   , LotsSTemp,
         PipStepB, PipStepS, PipStepBPrev, PipStepSPrev,
         LastB, LastS;
int      BS, EnforcedLast, Signal;
double   BS_SL;

int      TimeFrame[10] = {0, 1, 5, 15, 30, 60, 240, 1440, 10080, 43200};

int init()
{
   Symb = Symbol();
   TimeLastBar = Time[0];
   
   Bs = 0;
   Ss = 0;
   BS = 0;
   EnforcedLast = -1;
}

int start()
{
   BsTemp = 0;
   SsTemp = 0;
   for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
      if (OrderSelect(Pos, SELECT_BY_POS))
         if (OrderMagicNumber() == Magic)
            if (OrderSymbol() == Symb)
               if (OrderType() == OP_BUY )
                  BsTemp++;
               else
               if (OrderType() == OP_SELL)
                  SsTemp++;
   if (Bs != BsTemp)
   {
      if (BsTemp > 0)
      {
         Ticket = 0;
         for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
            if (OrderSelect(Pos, SELECT_BY_POS))
               if (OrderMagicNumber() == Magic)
                  if (OrderSymbol() == Symb)
                     if (OrderType() == OP_BUY )
                        if (OrderTicket() > Ticket)
                        {
                           Ticket = OrderTicket();
                           LotsB  = OrderLots();
                           LastB  = OrderOpenPrice();
                        }
         if (BsTemp == 1)
         {
            if (LotsPrevFirst == 0)
               LotsBPrev = 0.0;
            else
               LotsBPrev = LotsB;
         }
         else
         {
            Error  = Ticket;
            Ticket = 0;
            for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
               if (OrderSelect(Pos, SELECT_BY_POS))
                  if (OrderMagicNumber() == Magic)
                     if (OrderSymbol() == Symb)
                        if (OrderType() == OP_BUY )
                           if (OrderTicket() > Ticket)
                              if (OrderTicket() < Error)
                              {
                                 Ticket = OrderTicket();
                                 LotsBPrev  = OrderLots();
                              }
         }
      }
      else
      {
         Bs = 0;
         
         LastB = 0.0;
         PipStepB = 0.0;
         LotsB = 0.0;
         LotsBPrev = 0.0;
         
         if (BS > 0)
         {
            BS = 0;
            EnforcedLast = -1;
            
            if (InverseCloseWithMain != 0)
            {
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_SELL)
                           {
                              RefreshRates();
                              Ticket = OrderTicket();
                              if (OrderClose(Ticket, OrderLots(), Ask, Slippage, Color_Sell))
                              {
                                 if (DebugTrade)
                                    Print("Order SELL close, ticket #", Ticket, ".");
                              }
                              else
                              {
                                 if (DebugTrade)
                                    Print("Order SELL not close, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 return;
                              }
                           }
               Ss = 0;
               SsTemp = 0;
               
               LastS = 0.0;
               PipStepS = 0.0;
               LotsS = 0.0;
               LotsSPrev = 0.0;
            }
         }
      }
   }
   if (Ss != SsTemp)
   {
      if (SsTemp > 0)
      {
         Ticket = 0;
         for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
            if (OrderSelect(Pos, SELECT_BY_POS))
               if (OrderMagicNumber() == Magic)
                  if (OrderSymbol() == Symb)
                     if (OrderType() == OP_SELL)
                        if (OrderTicket() > Ticket)
                        {
                           Ticket = OrderTicket();
                           LotsS  = OrderLots();
                           LastS  = OrderOpenPrice();
                        }
         if (SsTemp == 1)
         {
            if (LotsPrevFirst == 0)
               LotsSPrev = 0.0;
            else
               LotsSPrev = LotsS;
         }
         else
         {
            Error  = Ticket;
            Ticket = 0;
            for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
               if (OrderSelect(Pos, SELECT_BY_POS))
                  if (OrderMagicNumber() == Magic)
                     if (OrderSymbol() == Symb)
                        if (OrderType() == OP_SELL)
                           if (OrderTicket() > Ticket)
                              if (OrderTicket() < Error)
                              {
                                 Ticket = OrderTicket();
                                 LotsSPrev = OrderLots();
                              }
         }
      }
      else
      {
         Ss = 0;
         
         LastS = 0.0;
         PipStepS = 0.0;
         LotsS = 0.0;
         LotsSPrev = 0.0;
         
         if (BS < 0)
         {
            BS = 0;
            EnforcedLast = -1;
            
            if (InverseCloseWithMain != 0)
            {
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_BUY )
                           {
                              RefreshRates();
                              Ticket = OrderTicket();
                              if (OrderClose(Ticket, OrderLots(), Bid, Slippage, Color_Buy ))
                              {
                                 if (DebugTrade)
                                    Print("Order BUY close, ticket #", Ticket, ".");
                              }
                              else
                              {
                                 if (DebugTrade)
                                    Print("Order BUY not close, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 return;
                              }
                           }
               Bs = 0;
               BsTemp = 0;
               
               LastB = 0.0;
               PipStepB = 0.0;
               LotsB = 0.0;
               LotsBPrev = 0.0;
            }
         }
      }
   }
   
   if (Bs != BsTemp || Ss != SsTemp)
   {
      BS = 0;
      if (BsTemp > 1)
         if (BsTemp > SsTemp)
            BS = +1;
      if (SsTemp > 1)
         if (SsTemp > BsTemp)
            BS = -1;
      
      if (PipStepInverseCorrect == 0 || BS == 0)
      {
         if (Bs != BsTemp)
            if (BsTemp > 0)
            {
               Pos = 0;
               while (Pos < BsTemp)
               {
                  Pos++;
                  if (Pos < PipStepDynamicStart)
                  {
                     PipStepB = PipStepInit;
                     if (PipStepPrevFirst == 0)
                        PipStepBPrev = 0.0;
                     else
                        PipStepBPrev = PipStepB;
                  }
                  else
                  {
                     Temp = PipStepB;
                     PipStepB = PipStepB*PipStepExp+PipStepBPrev*PipStepPrev+PipStepAdd;
                     PipStepBPrev = Temp;
                  }
               }
            }
         if (Ss != SsTemp)
            if (SsTemp > 0)
            {
               Pos = 0;
               while (Pos < SsTemp)
               {
                  Pos++;
                  if (Pos < PipStepDynamicStart)
                  {
                     PipStepS = PipStepInit;
                     if (PipStepPrevFirst == 0)
                        PipStepSPrev = 0.0;
                     else
                        PipStepSPrev = PipStepS;
                  }
                  else
                  {
                     Temp = PipStepS;
                     PipStepS = PipStepS*PipStepExp+PipStepSPrev*PipStepPrev+PipStepAdd;
                     PipStepSPrev = Temp;
                  }
               }
            }
      }
      else
      if (BS > 0)
      {
         if (Bs != BsTemp)
            if (BsTemp > 0)
            {
               Pos = 0;
               while (Pos < BsTemp)
               {
                  Pos++;
                  if (Pos < PipStepDynamicStart)
                  {
                     PipStepB = PipStepInit;
                     if (PipStepPrevFirst == 0)
                        PipStepBPrev = 0.0;
                     else
                        PipStepBPrev = PipStepB;
                  }
                  else
                  {
                     Temp = PipStepB;
                     PipStepB = PipStepB*PipStepExp+PipStepBPrev*PipStepPrev+PipStepAdd;
                     PipStepBPrev = Temp;
                  }
               }
            }
         if (Ss != SsTemp)
            if (SsTemp > 0)
            {
               Ticket = 0;
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_SELL)
                              if (Ticket == 0 || OrderTicket() < Ticket)
                                 Ticket = OrderTicket();
               EnforcedLast = -1;
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_BUY )
                              if (OrderTicket() < Ticket)
                                 EnforcedLast++;
               Pos = 0;
               while (Pos < SsTemp+EnforcedLast)
               {
                  Pos++;
                  if (Pos < PipStepDynamicStart)
                  {
                     PipStepS = PipStepInit;
                     if (PipStepPrevFirst == 0)
                        PipStepSPrev = 0.0;
                     else
                        PipStepSPrev = PipStepS;
                  }
                  else
                  {
                     Temp = PipStepS;
                     PipStepS = PipStepS*PipStepExp+PipStepSPrev*PipStepPrev+PipStepAdd;
                     PipStepSPrev = Temp;
                  }
               }
            }
      }
      else
      if (BS < 0)
      {
         if (Ss != SsTemp)
            if (SsTemp > 0)
            {
               Pos = 0;
               while (Pos < SsTemp)
               {
                  Pos++;
                  if (Pos < PipStepDynamicStart)
                  {
                     PipStepS = PipStepInit;
                     if (PipStepPrevFirst == 0)
                        PipStepSPrev = 0.0;
                     else
                        PipStepSPrev = PipStepS;
                  }
                  else
                  {
                     Temp = PipStepS;
                     PipStepS = PipStepS*PipStepExp+PipStepSPrev*PipStepPrev+PipStepAdd;
                     PipStepSPrev = Temp;
                  }
               }
            }
         if (Bs != BsTemp)
            if (BsTemp > 0)
            {
               Ticket = 0;
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_BUY )
                              if (Ticket == 0 || OrderTicket() < Ticket)
                                 Ticket = OrderTicket();
               EnforcedLast = -1;
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_SELL)
                              if (OrderTicket() < Ticket)
                                 EnforcedLast++;
               Pos = 0;
               while (Pos < BsTemp+EnforcedLast)
               {
                  Pos++;
                  if (Pos < PipStepDynamicStart)
                  {
                     PipStepB = PipStepInit;
                     if (PipStepPrevFirst == 0)
                        PipStepBPrev = 0.0;
                     else
                        PipStepBPrev = PipStepB;
                  }
                  else
                  {
                     Temp = PipStepB;
                     PipStepB = PipStepB*PipStepExp+PipStepBPrev*PipStepPrev+PipStepAdd;
                     PipStepBPrev = Temp;
                  }
               }
            }
      }
      
      Bs = BsTemp;
      Ss = SsTemp;
   }
   
   if (Bs == 1 || Ss == 1)
      if (BreakevenLevelEnable || TrailingEnable)
         for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
            if (OrderSelect(Pos, SELECT_BY_POS))
               if (OrderMagicNumber() == Magic)
                  if (OrderSymbol() == Symb)
                     if (OrderType() == OP_BUY )
                     {
                        if (Bs == 1)
                        {
                           Ticket = OrderTicket();
                           OP = OrderOpenPrice();
                           SL = OrderStopLoss();
                           
                           if (BreakevenLevelEnable)
                           {
                              if (SL < OP-0.5*Point || SL == 0.0)
                              {
                                 if (Bid-OP > (BreakevenLevel-0.5)*Point)
                                 {
                                    if (OrderModify(Ticket, OP, OP, OrderTakeProfit(), 0, Color_Buy ))
                                    {
                                       if (DebugTrade)
                                          Print("Order BUY modify, ticket #", Ticket, ".");
                                    }
                                    else
                                       if (DebugTrade)
                                          Print("Order BUY not modify, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 }
                              }
                              else
                              if (TrailingEnable)
                                 if (Bid-SL > (TrailingStop+TrailingStep-0.5)*Point)
                                 {
                                    if (OrderModify(Ticket, OP, Bid-TrailingStop*Point, OrderTakeProfit(), 0, Color_Buy ))
                                    {
                                       if (DebugTrade)
                                          Print("Order BUY modify, ticket #", Ticket, ".");
                                    }
                                    else
                                       if (DebugTrade)
                                          Print("Order BUY not modify, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 }
                           }
                           else
                           if (TrailingEnable)
                              if (Bid-OP > (TrailingStart+TrailingStop+TrailingStep-0.5)*Point)
                                 if (Bid-SL > (TrailingStop+TrailingStep-0.5)*Point || SL == 0.0)
                                 {
                                    if (OrderModify(Ticket, OP, Bid-TrailingStop*Point, OrderTakeProfit(), 0, Color_Buy ))
                                    {
                                       if (DebugTrade)
                                          Print("Order BUY modify, ticket #", Ticket, ".");
                                    }
                                    else
                                       if (DebugTrade)
                                          Print("Order BUY not modify, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 }
                        }
                     }
                     else
                     if (OrderType() == OP_SELL)
                     {
                        if (Ss == 1)
                        {
                           Ticket = OrderTicket();
                           OP = OrderOpenPrice();
                           SL = OrderStopLoss();
                           
                           if (BreakevenLevelEnable)
                           {
                              if (SL > OP+0.5*Point || SL == 0)
                              {
                                 if (OP-Ask > (BreakevenLevel-0.5)*Point)
                                 {
                                    if (OrderModify(Ticket, OP, OP, OrderTakeProfit(), 0, Color_Sell))
                                    {
                                       if (DebugTrade)
                                          Print("Order SELL modify, ticket #", Ticket, ".");
                                    }
                                    else
                                       if (DebugTrade)
                                          Print("Order SELL not modify, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 }
                              }
                              else
                              if (TrailingEnable)
                                 if (SL-Ask > (TrailingStop+TrailingStep-0.5)*Point)
                                 {
                                    if (OrderModify(Ticket, OP, Ask+TrailingStop*Point, OrderTakeProfit(), 0, Color_Sell))
                                    {
                                       if (DebugTrade)
                                          Print("Order SELL modify, ticket #", Ticket, ".");
                                    }
                                    else
                                       if (DebugTrade)
                                          Print("Order SELL not modify, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 }
                           }
                           else
                           if (TrailingEnable)
                              if (OP-Ask > (TrailingStart+TrailingStop+TrailingStep-0.5)*Point)
                                 if (SL-Ask > (TrailingStop+TrailingStep-0.5)*Point || SL == 0.0)
                                 {
                                    if (OrderModify(Ticket, OP, Ask+TrailingStop*Point, OrderTakeProfit(), 0, Color_Sell))
                                    {
                                       if (DebugTrade)
                                          Print("Order SELL modify, ticket #", Ticket, ".");
                                    }
                                    else
                                       if (DebugTrade)
                                          Print("Order SELL not modify, ticket #", Ticket, ", error #", GetLastError(), ".");
                                 }
                        }
                     }
   
   if (TimeLastBar != Time[0])
   {
      TimeLastBar = Time[0];
      Signal = GetSignal();
      
      if (Bs == 0)
      {
         if (Ss == 0 || EnforceEnable == 0)
         {
            if (Ss == 0 || InverseEnable != 0)
               if (SignalMirror == 0)
               {
                  if (Signal == +1)
                     SendB = true;
               }
               else
                  if (Signal == -1)
                     SendB = true;
         }
         else
         if (InverseEnable != 0)
         {
            if (Ss >= EnforcedStart)
            {
               if (Ss < EnforcedStop)
               {
                  SendB = true;
                  if (DebugAlgorithm)
                     Print("Force open first BUY order.");
               }
            }
            else
               if (DebugAlgorithm)
                  Print("Waiting for SellOrders to reach EnforcedStart.");
         }
      }
      else
      {
         if (Bs < TradesMax)
            if (Ask < LastB-PipStepB*Point)
               SendB = true;
      }
      
      if (Ss == 0)
      {
         if (Bs == 0 || EnforceEnable == 0)
         {
            if (Bs == 0 || InverseEnable != 0)
               if (SignalMirror == 0)
               {
                  if (Signal == -1)
                     SendS = true;
               }
               else
                  if (Signal == +1)
                     SendS = true;
         }
         else
         if (InverseEnable != 0)
         {
            if (Bs >= EnforcedStart)
            {
               if (Bs < EnforcedStop)
               {
                  SendS = true;
                  if (DebugAlgorithm)
                     Print("Force open first SELL order.");
               }
            }
            else
               if (DebugAlgorithm)
                  Print("Waiting for BuyOrders to reach EnforcedStart.");
         }
      }
      else
      {
         if (Ss < TradesMax)
            if (Bid > LastS+PipStepS*Point)
               SendS = true;
      }
   }
   
   if (SendB || SendS)
   {
      if (SendB)
      {
         if (Bs == 0)
         {
            if (Ss == 0)
            {
               LotsInit = GetLots(Risk);
               LotsB = LotsInit;
               if (DebugAlgorithm)
                  Print("TotalOrders = 0. Signal: BUY. Sending 1st BUY order...");
            }
            else
            if (OppositionEnable == 0 || Ss < OppositionStart)
            {
               LotsB = LotsInit;
               if (DebugAlgorithm)
               {
                  Print("BuyOrders = 0. Signal: BUY.");
                  Print("Oppositin OFF. Sending 1st BUY order. InitLots = ", LotsB, ".");
               }
            }
            else
            {
               LotsB = LotsS*OppositionLotsExp;
               if (LotsB < LotsInit)
                  LotsB = LotsInit;
               if (LotsB > LotsMax)
                  LotsB = LotsMax;
               if (DebugAlgorithm)
               {
                  Print("BuyOrders = 0. Signal: BUY.");
                  Print("Opposition ON, Sending 1st BUY order, OppositionLots = ", LotsB, ".");
               }
            }
            if (LotsPrevFirst == 0)
               LotsBPrev = 0.0;
            else
               LotsBPrev = LotsB;
         }
         else
         {
            LotsBTemp = LotsBPrev;
            Temp = LotsB;
            LotsB = LotsB*LotsExp+LotsAdd+LotsBPrev*LotsPrev;
            if (LotsB > LotsMax)
               LotsB = LotsMax;
            LotsBPrev = Temp;
            if (DebugAlgorithm)
               Print("Sending BUY order number ", Bs + 1,", LotsB = ", LotsB, ".");
         }
         
         RefreshRates();
         Ticket = OrderSend(Symbol(), OP_BUY,  LotsB, Ask, Slippage, 0.0, 0.0, NULL, Magic,  0, Color_Buy );
         if (Ticket > 0)
         {
            SendB = false;
            if (DebugTrade)
               Print("Order BUY open, ticket #", Ticket, ".");
            
            Bs++;
            if (Bs == 2)
               if (Ss <= 1)
                  BS = +1;
            
            if (BS >= 0 || PipStepInverseCorrect == 0 || EnforceEnable == 0)
            {
               if ((Bs < PipStepDynamicStart))
               {
                  PipStepB = PipStepInit;
                  if (PipStepPrevFirst == 0)
                     PipStepBPrev = 0.0;
                  else
                     PipStepBPrev = PipStepB;
               }
               else
               {
                  Temp = PipStepB;
                  PipStepB = PipStepB*PipStepExp+PipStepBPrev*PipStepPrev+PipStepAdd;
                  PipStepBPrev = Temp;
               }
            }
            else
            if (Bs == 1)
            {
               EnforcedLast = Ss-1;
               PipStepBPrev = PipStepSPrev;
               PipStepB     = PipStepS;
            }
            else
               if ((Bs+EnforcedLast < PipStepDynamicStart))
               {
                  PipStepB = PipStepInit;
                  if (PipStepPrevFirst == 0)
                     PipStepBPrev = 0.0;
                  else
                     PipStepBPrev = PipStepB;
               }
               else
               {
                  Temp = PipStepB;
                  PipStepB = PipStepB*PipStepExp+PipStepBPrev*PipStepPrev+PipStepAdd;
                  PipStepBPrev = Temp;
               }
            
            if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
               LastB = OrderOpenPrice();
            else
            {
               //***********************
            }
            
            if (BS >= 0 || InverseCloseWithMain != 1)
               SL = 0.0;
            else
               SL = BS_SL;
            
            if (Bs == 1)
               Modify("BUY", SL, LastB+TakeProfitFirst*Point, Color_Buy );
            else
            {
               Lots = 0.0;
               OP = 0.0;
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_BUY )
                           {
                              Lots += OrderLots();
                              OP += OrderOpenPrice()*OrderLots();
                           }
               OP /= Lots;
               if (TakeProfitMode == 1)
               {
                  if (TakeProfitRound > 0)
                     TP = MathCeil (OP/Point+TakeProfit*LotsInit/Lots)*Point;
                  else
                  if (TakeProfitRound < 0)
                     TP = MathFloor(OP/Point+TakeProfit*LotsInit/Lots)*Point;
                  else
                     TP = MathRound(OP/Point+TakeProfit*LotsInit/Lots)*Point;
               }
               else
                  TP = NormalizeDouble(OP, Digits)+TakeProfit*Point;
               if (BS > 0)
                  BS_SL = TP+MarketInfo(Symb, MODE_SPREAD)*Point;
               
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_BUY )
                              Modify("BUY", SL, TP, Color_Buy );
                           else
                           if (InverseCloseWithMain == 1)
                              if (BS > 0)
                                 if (OrderType() == OP_SELL)
                                    Modify("SELL", BS_SL, OrderTakeProfit(), Color_Sell);
               
               if (Pause > 0)
               {
                  if (DebugTrade)
                     Print("Waiting ", Pause, " sec...");
                  Sleep(Pause*1000);
               }
            }
         }
         else
         {
            LotsB = LotsBPrev;
            LotsBPrev = LotsBTemp;
            
            Error = GetLastError();
            Print("Order BUY not open, ticket #", Ticket, ", error #", Error, "!");
            if (Error == 4   || // SERVER_BUSY
                Error == 129 || // INVALID_PRICE 
                Error == 135 || // PRICE_CHANGED 
                Error == 136 || // OFF_QUOTES
                Error == 137 || // BROKER_BUSY 
                Error == 138 || // REQUOTE 
                Error == 146)   // TRADE_CONTEXT_BUSY
            {
               if (DebugTrade)
                  Print("Waiting 3 sec...");
               Sleep(3000);
            }
            else
               SendB = false;
         }
      }
      if (SendS)
      {
         if (Ss == 0)
         {
            if (Bs == 0)
            {
               LotsInit = GetLots(Risk);
               LotsS = LotsInit;
            }
            else
            if (OppositionEnable == 0 || Bs < OppositionStart)
            {
               LotsS = LotsInit;
               if (DebugAlgorithm)
               {
                  Print("SellOrders = 0. Signal: SELL.");
                  Print("Opposition OFF. Sending 1st BUY order. InitLot = ", LotsS, ".");
               }
            }
            else
            {
               LotsS = LotsB*OppositionLotsExp;
               if (LotsS < LotsInit)
                  LotsS = LotsInit;
               if (LotsS > LotsMax)
                  LotsS = LotsMax;
               if (DebugAlgorithm)
               {
                  Print("SellOrders = 0. Signal: SELL.");
                  Print("Opposition ON. Sending 1st BUY order. OppositionLots = ", LotsS, ".");
               }
            }
            if (LotsPrevFirst == 0)
               LotsSPrev = 0.0;
            else
               LotsSPrev = LotsS;
         }
         else
         {
            LotsSTemp = LotsSPrev;
            Temp = LotsS;
            LotsS = LotsS*LotsExp+LotsAdd+LotsSPrev*LotsPrev;
            if (LotsS > LotsMax)
               LotsS = LotsMax;
            LotsSPrev = Temp;
            if (DebugAlgorithm)
               Print("Sending SELL order number ", Ss + 1,", LotsS = ", LotsS, ".");
         }
         
         RefreshRates();
         Ticket = OrderSend(Symbol(), OP_SELL, LotsS, Bid, Slippage, 0.0, 0.0, NULL, Magic, 0, Color_Sell);
         if (Ticket > 0)
         {
            SendS = false;
            if (DebugTrade)
               Print("Order SELL open, ticket #", Ticket, ".");
            
            Ss++;
            if (Ss == 2)
               if (Bs <= 1)
                  BS = -1;
            
            if (BS <= 0 || PipStepInverseCorrect == 0 || EnforceEnable == 0)
            {
               if (Ss < PipStepDynamicStart)
               {
                  PipStepS = PipStepInit;
                  if (PipStepPrevFirst == 0)
                     PipStepSPrev = 0.0;
                  else
                     PipStepSPrev = PipStepS;
               }
               else
               {
                  Temp = PipStepS;
                  PipStepS = PipStepS*PipStepExp+PipStepSPrev*PipStepPrev+PipStepAdd;
                  PipStepSPrev = Temp;
               }
            }
            else
            if (Ss == 1)
            {
               EnforcedLast = Bs-1;
               PipStepSPrev = PipStepBPrev;
               PipStepS     = PipStepB;
            }
            else
               if (Ss+EnforcedLast < PipStepDynamicStart)
               {
                  PipStepS = PipStepInit;
                  if (PipStepPrevFirst == 0)
                     PipStepSPrev = 0.0;
                  else
                     PipStepSPrev = PipStepS;
               }
               else
               {
                  Temp = PipStepS;
                  PipStepS = PipStepS*PipStepExp+PipStepSPrev*PipStepPrev+PipStepAdd;
                  PipStepSPrev = Temp;
               }
            
            if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
               LastS = OrderOpenPrice();
            else
            {
               //***********************
            }
            
            if (BS <= 0 || InverseCloseWithMain != 1)
               SL = 0.0;
            else
               SL = BS_SL;
            
            if (Ss == 1)
               Modify("SELL", SL, LastS-TakeProfitFirst*Point, Color_Sell);
            else
            {
               Lots = 0.0;
               OP = 0.0;
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_SELL)
                           {
                              Lots += OrderLots();
                              OP += OrderOpenPrice()*OrderLots();
                           }
               OP /= Lots;
               if (TakeProfitMode == 1)
               {
                  if (TakeProfitRound > 0)
                     TP = MathFloor(OP/Point-TakeProfit*LotsInit/Lots)*Point;
                  else
                  if (TakeProfitRound < 0)
                     TP = MathCeil (OP/Point-TakeProfit*LotsInit/Lots)*Point;
                  else
                     TP = MathRound(OP/Point-TakeProfit*LotsInit/Lots)*Point;
               }
               else
                  TP = NormalizeDouble(OP, Digits)-TakeProfit*Point;
               if (BS < 0)
                  BS_SL = TP-MarketInfo(Symb, MODE_SPREAD)*Point;
               
               for (Pos = OrdersTotal()-1; Pos >= 0; Pos--)
                  if (OrderSelect(Pos, SELECT_BY_POS))
                     if (OrderMagicNumber() == Magic)
                        if (OrderSymbol() == Symb)
                           if (OrderType() == OP_SELL)
                              Modify("SELL", SL, TP, Color_Sell);
                           else
                           if (InverseCloseWithMain == 1)
                              if (BS < 0)
                                 if (OrderType() == OP_BUY )
                                    Modify("SELL", BS_SL, OrderTakeProfit(), Color_Buy );
               
               if (Pause > 0)
               {
                  if (DebugTrade)
                     Print("Waiting ", Pause, " sec...");
                  Sleep(Pause*1000);
               }
            }
         }
         else
         {
            LotsS = LotsSPrev;
            LotsSPrev = LotsSTemp;
            
            Error = GetLastError();
            if (DebugTrade)
               Print("Order SELL not open, ticket #", Ticket, ", error #", Error, "!");
            
            if (Error == 4   || // SERVER_BUSY
                Error == 129 || // INVALID_PRICE 
                Error == 135 || // PRICE_CHANGED 
                Error == 136 || // OFF_QUOTES
                Error == 137 || // BROKER_BUSY 
                Error == 138 || // REQUOTE 
                Error == 146)   // TRADE_CONTEXT_BUSY
            {
               if (DebugTrade)
                  Print("Waiting 3 sec...");
               Sleep(3000);
            }
            else
               SendS = false;
         }
      }
   }
   
   if (ShowInfo)
      Comment("BuyOrders=",  Bs,
            "\nLastPrice=", NormalizeDouble(LastB, Digits), "  PipStep=", NormalizeDouble(PipStepB, 0),
            "\nLastLots=", LotsB, "  PrevLots=", LotsBPrev,
          "\n\nSellOrders=", Ss,
            "\nLastPrice=", NormalizeDouble(LastS, Digits), "  PipStep=", NormalizeDouble(PipStepS, 0),
            "\nLastLots=", LotsS, "  PrevLots=", LotsSPrev,
          "\n\nDirectionMain=", BS, "  EnforcedLast=", EnforcedLast+1);
}

int GetSignal()
{
   if (SignalMode == 0)
   {
      if (iHigh(Symb, TimeFrame[SignalTimeFrame], SignalBars)-iLow(Symb, TimeFrame[SignalTimeFrame], 1) > SignalDelta*Point-0.5*Point)
         return(+1);
      else
      if (iHigh(Symb, TimeFrame[SignalTimeFrame], 1)-iLow(Symb, TimeFrame[SignalTimeFrame], SignalBars) > SignalDelta*Point-0.5*Point)
         return(-1);
   }
   else
   if (SignalMode == 1)
   {
      if (iClose(Symb, TimeFrame[SignalTimeFrame], SignalBars) > iClose(Symb, TimeFrame[SignalTimeFrame], 1))
      {
         if (iHigh(Symb, TimeFrame[SignalTimeFrame], SignalBars)-iLow(Symb, TimeFrame[SignalTimeFrame], 1) > SignalDelta*Point-0.5*Point)
            return(+1);
      }
      else
      {
         if (iHigh(Symb, TimeFrame[SignalTimeFrame], 1)-iLow(Symb, TimeFrame[SignalTimeFrame], SignalBars) > SignalDelta*Point-0.5*Point)
            return(-1);
      }
   }
   else
   if (SignalMode == 2)
   {
      if (iLowest (Symb, TimeFrame[SignalTimeFrame], MODE_LOW , SignalBars, 1) == 1)
      {
         if (iHigh(Symb, TimeFrame[SignalTimeFrame], iHighest(Symb, TimeFrame[SignalTimeFrame], MODE_HIGH, SignalBars, 1))-iLow(Symb, TimeFrame[SignalTimeFrame], 1) > SignalDelta*Point-0.5*Point)
            return(+1);
      }
      else
      if (iHighest(Symb, TimeFrame[SignalTimeFrame], MODE_HIGH, SignalBars, 1) == 1)
      {
         if (iHigh(Symb, TimeFrame[SignalTimeFrame], 1)-iLow(Symb, TimeFrame[SignalTimeFrame], iLowest (Symb, TimeFrame[SignalTimeFrame], MODE_LOW , SignalBars, 1)) > SignalDelta*Point-0.5*Point)
            return(-1);
      }
   }
   return(0);
}

double Modify(string modifyOP, double modifySL, double modifyTP, color modifyCL)
{
   Ticket = OrderTicket();
   OP     = OrderOpenPrice();
   
   while (true)
   {
      if (OrderModify(Ticket, OP, modifySL, modifyTP, 0, modifyCL))
      {
         if (DebugTrade)
            Print("Order ", modifyOP, " modify, ticket #", Ticket,".");
         break;
      }
      else
      {
         Error = GetLastError();
         if (DebugTrade)
            Print("Order ", modifyOP, " not modify, ticket #", Ticket,", error #", Error, "!");
         switch (Error)
         {
            case 130: RefreshRates(); continue;
            case 136: while (!RefreshRates()) Sleep(1); continue;
            case 146: if (DebugTrade) Print("Waiting 5 sec..."); Sleep(500); RefreshRates(); continue;
         }
         break;
      }
   }
}

double GetLots(double Risk)
{
   double Free    = AccountFreeMargin();
   double One_Lot = MarketInfo(Symb, MODE_MARGINREQUIRED);
   double Value;
   
   if (Risk > 0)
   {
      double Step    = MarketInfo(Symb, MODE_LOTSTEP);
      Value   = MathFloor(Free*Risk/100/One_Lot/Step)*Step;
   }
   else
      Value = LotsInit;
   
   double Min_Lot = MarketInfo(Symb, MODE_MINLOT);
   double Max_Lot = MarketInfo(Symb, MODE_MAXLOT);
   
   if (Value < Min_Lot)
      Value = Min_Lot;
   if (Value > Max_Lot)
      Value = Max_Lot;
   if (Value > LotsMax)
      Value = LotsMax;
   
   if (Value*One_Lot > Free)
      return(-Value);
   
   return (Value);
}