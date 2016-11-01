//+------------------------------------------------------------------+
//|                                                   stopLossEA.mq4 |
//|                                                   Istvan Kosztik |
//|                                https://www.kosztik.hu/stoplossea |
//+------------------------------------------------------------------+
#property copyright "Istvan Kosztik"
#property link      "https://www.kosztik.hu/stoplossea"
#property version   "1.00"
#property strict

#include <mt4gui2.mqh>

//--- input parameters
extern int    Length=10;
extern int    ATRperiod=5;
extern double Kv=3.5;
extern int    breakevent=15;

int Size=0, cnt, orderType, StopLevel, flipflop=0, Size_now;
string orderSymbol;
double smin, smax, slSell, slBuy, profit;

int hwnd=0;

int Button0, Button1,Button2,Button3,ButtonADXoff,ButtonADXon,panel, label0, label1;

// Settings

int GUIXadxoff = 350;
int GUIYadxoff = 50;

int GUIXadxon = 350;
int GUIYadxon = 100;

int GUIX0 = 50;
int GUIY0 = 50;
int GUIX = 50;
int GUIY = 100;
int GUIX2 = 50;
int GUIY2 = 150;
int GUIX3 = 50;
int GUIY3 = 200;
int ButtonWidth=150;
int ButtonHeight=30;

int GUIX3label0 = 50;
int GUIY3label0 = 300;

int GUIX3label1 = 50;
int GUIY3label1 = 320;

int rsiStopMode=0;
int adxStopMode=0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   hwnd=WindowHandle(Symbol(),Period());
// Lets remove all Objects from Chart before we start
   guiRemoveAll(hwnd);
// Lets build the Interface
   BuildInterface();
   return(0);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   // Very important to cleanup and remove all gui items from chart      
   if(hwnd>0) { guiRemoveAll(hwnd);     guiCleanup(hwnd); }

  }



void BuildInterface()
  {
  
   ButtonADXoff=guiAdd(hwnd,"button",GUIXadxoff,GUIYadxoff+ButtonHeight*1+5,220,ButtonHeight,"exit adx off");
   guiSetBgColor(hwnd,ButtonADXoff,Green);
   
   ButtonADXon=guiAdd(hwnd,"button",GUIXadxon,GUIYadxon+ButtonHeight*1+5,220,ButtonHeight,"exit adx on");
   guiSetBgColor(hwnd,ButtonADXon,Red);
   
   Button0=guiAdd(hwnd,"button",GUIX0,GUIY0+ButtonHeight*1+5,220,ButtonHeight,"exit rsi off");
   guiSetBgColor(hwnd,Button0,Green);
  
   Button1=guiAdd(hwnd,"button",GUIX,GUIY+ButtonHeight*1+5,220,ButtonHeight,"exit rsi50");
   guiSetBgColor(hwnd,Button1,Red);

   Button2=guiAdd(hwnd,"button",GUIX2,GUIY2+ButtonHeight*1+5,220,ButtonHeight,"exit rsi60-40");
   guiSetBgColor(hwnd,Button2,Red);

   Button3=guiAdd(hwnd,"button",GUIX3,GUIY3+ButtonHeight*1+5,220,ButtonHeight,"atr sl");
   guiSetBgColor(hwnd,Button3,Yellow);
   
   
   
   label0 = guiAdd(hwnd, "label", GUIX3label0, GUIY3label0, 130, 20, "--");
   guiSetBgColor(hwnd, label0, Black);
   guiSetTextColor(hwnd, label0, White);
   
   label1 = guiAdd(hwnd, "label", GUIX3label1, GUIY3label1, 130, 20, "--");
   guiSetBgColor(hwnd, label1, Black);
   guiSetTextColor(hwnd, label1, White);
   
  }
  

// breakevent-be huzas
void slBrk() {
   
   double temp_brk; // a tényleges breakevent szint spreaddel
   
   Size = OrdersTotal(); 
   for (int cnt=0;cnt<Size;cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      orderType = OrderType(); // megnézem a tipusát, az sl beállítása végett OP_BUY/OP_SELL
      orderSymbol = OrderSymbol(); // DEvizapár
      StopLevel = MarketInfo(orderSymbol, MODE_STOPLEVEL) + MarketInfo(orderSymbol, MODE_SPREAD);
      profit = OrderProfit();
      
      
      //Print (OrderOpenPrice() - NormalizeDouble(Bid - Ask,5) );
      
      //breakevent = MathAbs(Ask-iCustom(orderSymbol,PERIOD_M15,"ATRStops_v11.1",1,0,1));
      // Print ("breakevent: ", breakevent);
         
      if (profit> breakevent) {
      
         // Kiszamolom a jo breakevent erteket
         if (orderType == OP_BUY) {
                 temp_brk = OrderOpenPrice() + NormalizeDouble(Bid - Ask,5);       
         } 
            
         if (orderType == OP_SELL) {
                 temp_brk = OrderOpenPrice() - NormalizeDouble(Bid - Ask,5);
         }
         
         // csak akkor nyulok hozzá, ha még nincs breakeventben az sl.
         if (   (temp_brk > OrderStopLoss() &&  orderType == OP_BUY ) || (temp_brk < OrderStopLoss() &&  orderType == OP_SELL)  ) { 
            Print ("breakevent modositas: ", temp_brk);
            bool res=OrderModify(OrderTicket(),OrderOpenPrice(), temp_brk,OrderTakeProfit(),0,Blue);
            if(!res) 
            {
                 Print("Error in OrderModify. Error code=",GetLastError());
            }
            else 
            {
                 Print("Order modified successfully.");
            }
       }
     }
         
   }
   

}

void rsiStop(int mode) {

   Size = OrdersTotal(); 
   for (int cnt=0;cnt<Size;cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      orderType = OrderType(); // megnézem a tipusát, az sl beállítása végett
      orderSymbol = OrderSymbol(); // DEvizapár
      StopLevel = MarketInfo(orderSymbol, MODE_STOPLEVEL) + MarketInfo(orderSymbol, MODE_SPREAD);
      
      if (orderSymbol == Symbol() ) {
      
         /*
       
            OP_BUY  0
   	      OP_SELL 1
   	   
   	      csak ezzel a kettő értékkel foglalkozom, semmilyen más tipussal.
         */
    
          //  A Buy is closed with a Sell at Bid, a Sell is closed with a Buy at Ask.
          if (mode == 6040) {
               if (orderType == OP_BUY && iRSI(orderSymbol,0,14,PRICE_CLOSE,1) <= 60) {
                  OrderClose(OrderTicket(),OrderLots(),Bid,3,Red);
                  
                  guiSetBgColor(hwnd,Button0,Green);
                  guiSetBgColor(hwnd,Button1,Red);
                  guiSetBgColor(hwnd,Button2,Red);
               }
               
               if (orderType == OP_SELL && iRSI(orderSymbol,0,14,PRICE_CLOSE,1) >= 40) {
                  OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);
                  
                  guiSetBgColor(hwnd,Button0,Green);
                  guiSetBgColor(hwnd,Button1,Red);
                  guiSetBgColor(hwnd,Button2,Red);
               }
           }
           
           if (mode == 50) {
               if (orderType == OP_BUY && iRSI(orderSymbol,0,14,PRICE_CLOSE,1) <= 51) {
                  OrderClose(OrderTicket(),OrderLots(),Bid,3,Red);
                  
                  guiSetBgColor(hwnd,Button0,Green);
                  guiSetBgColor(hwnd,Button1,Red);
                  guiSetBgColor(hwnd,Button2,Red);
               }
               
               if (orderType == OP_SELL && iRSI(orderSymbol,0,14,PRICE_CLOSE,1) >= 49) {
                  OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);
                  
                  guiSetBgColor(hwnd,Button0,Green);
                  guiSetBgColor(hwnd,Button1,Red);
                  guiSetBgColor(hwnd,Button2,Red);
               }
           
           }
            
        } // end of if       
    } // end of for
}

/*

                     ADX STOP
                     DI- �s DI+ fel�lr�l metszi level 20-at.

*/
void adxStop(int mode) {

   Size = OrdersTotal(); 
   for (int cnt=0;cnt<Size;cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      orderType = OrderType(); // megnézem a tipusát, az sl beállítása végett
      orderSymbol = OrderSymbol(); // DEvizapár
      StopLevel = MarketInfo(orderSymbol, MODE_STOPLEVEL) + MarketInfo(orderSymbol, MODE_SPREAD);
      
      if (orderSymbol == Symbol() ) {
      
         /*
       
            OP_BUY  0
   	      OP_SELL 1
   	   
   	      csak ezzel a kettő értékkel foglalkozom, semmilyen más tipussal.
         */
    
          //  A Buy is closed with a Sell at Bid, a Sell is closed with a Buy at Ask.
          if (mode == 1) {
               // (0 - MODE_MAIN, 1 - MODE_PLUSDI, 2 - MODE_MINUSDI
               if (orderType == OP_BUY && iADX(orderSymbol,0,14,PRICE_CLOSE,1,1) < 20) {
                  OrderClose(OrderTicket(),OrderLots(),Bid,3,Red);
                  
                  guiSetBgColor(hwnd,ButtonADXon,Green);
                  guiSetBgColor(hwnd,ButtonADXoff,Red);
                  
               }
               
               if (orderType == OP_SELL && iADX(orderSymbol,0,14,PRICE_CLOSE,2,1) < 20) {
                  OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);
                  
                  guiSetBgColor(hwnd,ButtonADXon,Green);
                  guiSetBgColor(hwnd,ButtonADXoff,Red);
                  
               }
           }
           
           
            
        } // end of if       
    } // end of for
}


void followSl() {
   Size = OrdersTotal(); 
   for (int cnt=0;cnt<Size;cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      orderType = OrderType(); // megnézem a tipusát, az sl beállítása végett
      orderSymbol = OrderSymbol(); // DEvizapár
      StopLevel = MarketInfo(orderSymbol, MODE_STOPLEVEL) + MarketInfo(orderSymbol, MODE_SPREAD);
      /*
    
         OP_BUY  0
	      OP_SELL 1
	   
	      csak ezzel a kettő értékkel foglalkozom, semmilyen más tipussal.
    */
      if (orderType == OP_BUY) {
      
         slBuy = iCustom(orderSymbol,0,"ATRStops_v11.1",1,0,1); 
        // ha a regi sl kisebb mint az ujabb, koveti
        if (OrderStopLoss() < slBuy && slBuy > OrderOpenPrice() ) {
         
         Print ("Follow");
         bool res=OrderModify(OrderTicket(),OrderOpenPrice(), slBuy,OrderTakeProfit(),0,Blue);
         if(!res) 
         {
              Print("Error in OrderModify. Error code=",GetLastError());
         }
         else 
         {
              Print("Order modified successfully.");
         }
        }
      }
    
    if (orderType == OP_SELL) {
    
      
      slSell =  iCustom(orderSymbol,0,"ATRStops_v11.1",1,1,1); 
      // akkor ha a regi sl nagyobb mint az uj
      if (OrderStopLoss() > slSell && slSell < OrderOpenPrice() ) {
      bool res=OrderModify(OrderTicket(),OrderOpenPrice(), slSell,OrderTakeProfit(),0,Red);
         if(!res) 
         {
            Print("Error in OrderModify. Error code=",GetLastError());
         }
       else 
       {
            Print("Order modified successfully.");
       }
    }
    }
   }
}
// ATR-nek megfelelen sl-t állit
void slSet(int mode) {
   Size = OrdersTotal(); 
   for (int cnt=0;cnt<Size;cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      orderType = OrderType(); // megnézem a tipusát, az sl beállítása végett
      orderSymbol = OrderSymbol(); // DEvizapár
      StopLevel = MarketInfo(orderSymbol, MODE_STOPLEVEL) + MarketInfo(orderSymbol, MODE_SPREAD);
      /*
    
         OP_BUY  0
	      OP_SELL 1
	   
	      csak ezzel a kettő értékkel foglalkozom, semmilyen más tipussal.
    */
     // Ha az adott trade-nek nincs SL-je, akkor beálltja azt:
     // Print (OrderStopLoss());
     if (orderSymbol == Symbol() ) {
     
             if (OrderStopLoss() == 0.0 || mode == 1) {
               if (orderType == OP_BUY) {
               
                  slBuy = iCustom(orderSymbol,0,"ATRStops_v11.1",1,0,1); 
               
                  bool res=OrderModify(OrderTicket(),OrderOpenPrice(), slBuy,OrderTakeProfit(),0,Blue);
                  if(!res) 
                  {
                       Print("Error in OrderModify. Error code=",GetLastError());
                  }
                  else 
                  {
                       Print("Order modified successfully.");
                  }
               }
             
             if (orderType == OP_SELL) {
             
               
               slSell =  iCustom(orderSymbol,0,"ATRStops_v11.1",1,1,1); 
               
               bool res=OrderModify(OrderTicket(),OrderOpenPrice(), slSell,OrderTakeProfit(),0,Red);
                  if(!res) 
                  {
                     Print("Error in OrderModify. Error code=",GetLastError());
                  }
                else 
                {
                     Print("Order modified successfully.");
                }
             }
            }
            
         }
         
            
      } // end of for

}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  
   int min, sec;
	
   min = Time[0] + PERIOD_M15*60 - CurTime();
   sec = min%60;
   min =(min - min%60) / 60; // időszámítások, hogy pontosan tudjam mikor van 15. perc

   //Size_now = OrdersTotal(); 
   //if (Size != Size_now ) slSet();  // ha új pozi van, akkor annak nyomban beállítjuk az sl-t
                                    // így nem kell várni a köv. 15. percre. 
                                    // Erre már nincs szükség. folyamatosan vizsgálom.
                     
   if (min != 14) flipflop = 0;
  
   if (min == 14 && flipflop == 0) { // csak minden 15. percben fut le egyszer
      flipflop = 1;
      // 15 percenkent nem csinalok semmit 
      
   }
   
   // figyelem a pozikat és ha valamelyik eléri a küszöböt, akkor  breakeventbe huzom
   //Print (iCustom("USDCAD",PERIOD_M15,"ATRStops_v11.1",1,1,1) );
   //followSl();  
   //slBrk();
   //rsiStop(); slSet();
   
   slSet(0); // ha nincs sl, akkor azt be kell allitani!
   
   if (guiIsClicked(hwnd,Button3))
     { 
         slSet(1); // Itt mar lehet sl, de ha megint helyre akarom allitani az atr alapu sl-t, akkor lefut!
     }
   
   
   if (guiIsClicked(hwnd,ButtonADXoff))
     {
     
         guiSetBgColor(hwnd,ButtonADXoff,Green);
         guiSetBgColor(hwnd,ButtonADXon,Red);
                  
         adxStopMode=0;
         
     }
   if (guiIsClicked(hwnd,ButtonADXon))
     {
     
         guiSetBgColor(hwnd,ButtonADXon,Green);
         guiSetBgColor(hwnd,ButtonADXoff,Red);
                  
         adxStopMode=1;
         
     }
   
   
   
   
   if (guiIsClicked(hwnd,Button0))
     {
     
         guiSetBgColor(hwnd,Button0,Green);
         guiSetBgColor(hwnd,Button1,Red);
         guiSetBgColor(hwnd,Button2,Red);
         
         rsiStopMode=0;
         
     }
   
   if (guiIsClicked(hwnd,Button1))
     {
     
         guiSetBgColor(hwnd,Button0,Red);
         guiSetBgColor(hwnd,Button1,Green);
         guiSetBgColor(hwnd,Button2,Red);
         
         rsiStopMode=50;
         
     }
   
   if (guiIsClicked(hwnd,Button2))
     {
         guiSetBgColor(hwnd,Button0,Red);
         guiSetBgColor(hwnd,Button1,Red);
         guiSetBgColor(hwnd,Button2,Green);
         
         
         rsiStopMode=6040;
     }
   
   rsiStop(rsiStopMode);
   adxStop(adxStopMode);
   
       if ( iCustom(Symbol(),0,"ATRStops_v11.1",1,0,1) == Bid ) 
       {
         guiSetText( 
         hwnd, label1, "Buy SL: n/a"
         ,18, NULL); 
       } else {
         guiSetText( 
         hwnd, label1, "Buy SL: " + 
         NormalizeDouble(Bid - iCustom(Symbol(),0,"ATRStops_v11.1",1,0,1), 4)*10000 
         + " pips"
         ,18, NULL); 
         // Print ((Bid - iCustom(Symbol(),0,"ATRStops_v11.1",1,0,0))*10000);
       }
         // Print ((iCustom(Symbol(),0,"ATRStops_v11.1",1,0,0)),"/",(iCustom(Symbol(),0,"ATRStops_v11.1",1,1,0)),"/", Bid);
   
         guiSetText( 
         hwnd, label0, "Sell SL: " + 
         NormalizeDouble(iCustom(Symbol(),0,"ATRStops_v11.1",1,1,1) - Ask, 4)*10000 
         + " pips"
         ,18, NULL);  
    
         // Print ((iCustom(Symbol(),0,"ATRStops_v11.1",1,1,1) )  );
}
//+------------------------------------------------------------------+
