
#property strict
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Fx1 Inc
// http://mt4gui.com
// https://fx1.net
// You are not allowed to modify this MQH file
// Last Update: 26.Mar.2014
// This Include file is compatible with latest Metatrader4 version
// This MQH File is designed for mt4gui2.dll _with_ unicode support (MT4 Builds > 0520)
// use mt4gui.mqh for non-unicode support. Unicode support is required 
// for all Metatrader builds > 0550
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Important Links:
// ++ Cheatsheet 					: http://www.mt4gui.com/files/mt4gui-cheatsheet.pdf
// ++ Full Documentation		: http://www.mt4gui.com/docs/
// ++ Download mt4gui.dll		: http://www.mt4gui.com/downloads/
// ++ Download mt4gui2.dll		: http://www.mt4gui.com/downloads/
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#import "mt4gui2.dll"
	 //~~~~~~ Diverse
   string guiVersion			();   
   int guiCleanup				(int hwnd);    
   int guiGetLastError		(int hwnd);
      
   //~~~~~~ Main GUI Function
   // Type:  "button","checkbox","list","label","text","link","radio","image"
   int guiAdd					(int hwnd,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label);

   //~~~~~~ MENU FUNCTIONS
   int  guiAddMenu			(int hwnd,string label,int parentID,int flags); // Flags=1 -> Checkbox
   int  guiSetMenuText		(int hwnd,int menuHandle,string NewLabel);
   int  guiSetMenuTextColor(int hwnd,int menuHandle,int Color);
   int  guiSetMenuBgColor  (int hwnd,int menuHandle,int Color);
   bool guiIsMenuClicked	(int hwnd,int menuHandle);    
   bool guiIsMenuChecked	(int hwnd,int menuHandle);    
   int  guiCheckMenu			(int hwnd,int menuHandle,int Status);    
   int  guiEnableMenu		(int hwnd,int menuHandle,int Status);
   int  guiRemoveMenu		(int hwnd,int menuHandle); 
      
   //~~~~~~ shortcut --- 
   int guiSetShortcut		(int hwnd,int ObjectHandle,string Shortcut); // ihwnd,obj,definition "ctrl+a"
   
   //~~~~~~~ Ticker Functions
   int guiTickerStart		(int hwnd,int TickPeriod);  // minimum Period: 500
   int guiTickerStop			(int hwnd,int TickerHandle);   // 
  
   //~~~~~~~ colors for Objects
   int guiSetBgColor			(int hwnd,int ObjectHandle,int Color);
   int guiSetTextColor		(int hwnd,int ObjectHandle,int Color);
      
   // New functions for buttons only
   int guiSetBorderRadius  (int hwnd,int ObjectHandle,int Radius);
   int guiSetBorderColor	(int hwnd,int ObjectHandle,int BorderColor);
	//int guiSetTexts			(int chart, int wnd, int n, string& texts[], int& fontSizes[], string& fontNames[], int& positions[] );   
   
   int guiSetLink				(int hwnd,int LinkObjectHandle,string Link);
   
   // removing objects from chart
   int guiRemove				(int hwnd,int objHandle);
   int guiRemoveAll			(int hwnd);
   
   // events
   bool guiIsClicked			(int hwnd,int ObjectHandle);
   bool guiIsChecked			(int hwnd,int ObjectHandle);
      
   // properties   
   int    guiSetText			(int hwnd,int ObjectHandle,string NewText,int FontSize,string Fontname);
   string guiGetText			(int hwnd,int ObjectHandle);   
   int    guiSetChecked		(int hwnd,int ObjectHandle,int State);
	int    guiGetWidth		(int hwnd,int ObjectHandle);
   int    guiGetHeight		(int hwnd,int ObjectHandle); 
   int    guiSetPos			(int hwnd,int ObjectHandle,int X,int Y);      
   int    guiSetSize			(int hwnd,int ObjectHandle,int Width,int Height); 
   int    guiEnable			(int hwnd,int ObjectHandle,int State);
   bool   guiIsEnabled		(int hwnd,int ObjectHandle);
   int    guiAppendTextPart   (int hwnd,int ObjectHandle, string Text, int FontSize, string FontName, int Position);
   
   // listbox 
   int guiAddListItem		(int hwnd,int ListObjectHandle,string ItemToAdd);
   int guiGetListSel			(int hwnd,int ListObjectHandle); 
   int guiSetListSel			(int hwnd,int ListObjectHandle,int ItemIndex); 
   int guiRemoveListItem	(int hwnd, int ListObjectHandle, int ItemIndex );
	int guiRemoveListAll	   (int hwnd,int ListObjectHandle );

   // obj management
   int guiSetName				(int hwnd,int ObjectHandle,string NameOfObject); // ihwnd,object,name
   string guiGetName			(int hwnd,int ObjectHandle); // ihwnd,object
   int guiGroupRadio       (int hwnd); 
   
   // Enumeration Functions - Advanced Levels
   int guiObjectsCount		(int hwnd);
   int guiGetByNum			(int hwnd,int Index);
   int guiGetByName			(int hwnd,string Alias);
   int guiGetType				(int hwnd,int ObjectHandle);   
   int guiSetName				(int hwnd,int ObjectHandle,string Alias);
   string guiGetName			(int hwnd,int ObjectHandle);         
   
   // Link Functions
   int guiLinkAdd				(int hwnd,int ParentLinkHandle,string Label,string Link);
   int guiLinkRemove			(int hwnd);

   // Other Helper Functions
   int guiFocusChart			(int hwnd);
	int guiCloseTerminal		();
   int guiMinimizeTerminal ();
   int guiMaximizeTerminal ();   
   int guiCloseChart			(int hwnd);
   int guiChangeSymbol		(int hwnd, string SymbolAndTimeFrame);      
   string guiMD5				(string Content); 
   int guiOpenBrowser 		(string url);
	int guiTimeGMT				();
	string guiCID				();
	int guiCRC32				(string Content);    
	int guiTimeHTTPGMT		(string url);  
	int guiGetChartWidth		(int hwnd);  
	int guiGetChartHeight	(int hwnd);
#import


// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// These functions are just helper functions, they are not required necessarily for your product
// We are using these functions by our demonstrations and thats why they are inside MQH file
// Feel free to remove all functions from here if you know what you are doing. (Fx1.net)
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
string guiPrintXY(string mytext,color clr,int posx,int posy,int size,string font="",string prefix="pxy3txt")
{
   string n=prefix+"_"+DoubleToStr(posx,0)+"_"+DoubleToStr(posy,0);
   int corner=0;
   if (posy<0 && posx<0) corner=3;
   if (posy<0 && posx>0) corner=2;
   ObjectCreate(n, OBJ_LABEL, 0, Time[0], 4);
   ObjectSet(n, OBJPROP_CORNER, corner);
   ObjectSet(n, OBJPROP_XDISTANCE, MathAbs(posx));
   ObjectSet(n, OBJPROP_YDISTANCE, MathAbs(posy));
   ObjectSet(n, OBJPROP_COLOR, clr);
   ObjectSet(n, OBJPROP_BACK, false);
   ObjectSetText(n, mytext, size);
   if (font!="") ObjectSetText(n, mytext, size,font);  
   return(n);
}
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
int guiPrintStartY=50;
int guiPrintY=50;
int guiPrintFontSize=10;
int guiPrintMaxLines=25;
int guiPrintLines=0;
string guiPrint(string mytext,color clr,int posx=100)
{      
   string n="mt4guip_"+DoubleToStr(posx,0)+"_"+DoubleToStr(guiPrintY,0);
   int corner=0;
   ObjectDelete(n);
   ObjectCreate(n, OBJ_LABEL, 0, Time[0], 4);
   ObjectSet(n, OBJPROP_CORNER, corner);
   ObjectSet(n, OBJPROP_XDISTANCE, MathAbs(posx));
   ObjectSet(n, OBJPROP_YDISTANCE, MathAbs(guiPrintY));
   ObjectSet(n, OBJPROP_COLOR, clr);
   ObjectSet(n, OBJPROP_BACK, false);
   ObjectSetText(n, mytext, guiPrintFontSize);   
   guiPrintY+=guiPrintFontSize+5;    
   guiPrintLines++;
   if (guiPrintLines==guiPrintMaxLines) 
   		{   			
   			n="mt4guip_"+DoubleToStr(posx,0)+"_"+DoubleToStr(guiPrintY,0);
   			ObjectDelete(n);
   			guiPrintY=guiPrintStartY;
   			guiPrintLines=0;
   			
   		}
   return(n);
}
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Extracts the "#{OrderID}" from given String
// Returns -1 if nothing found
int ExtractOrderID(string Label)
{
	
	int pos1 = StringFind(Label,"#",0);
	int pos2 = 0;
	if (pos1<0) return(-1);
	for(int i=pos1+1;i<StringLen(Label);i++)
		{
			int CharCode = StringGetChar(Label,i);
			pos2++;			
			if (CharCode<48 || CharCode>57)   {	pos2--;break; }							
		}
	pos2++;
	string Extracted=StringSubstr(Label,pos1+1,pos2);	
	Print("Extracted = "+Extracted);
	return(StrToInteger(Extracted));
}
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
bool _CloseByTicket(int SLIPPAGE,int Ticket)
{	
	if (OrderSelect(Ticket, SELECT_BY_TICKET)) 
	{			 
	  RefreshRates();
	  if (OrderType()==OP_BUY) return(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),SLIPPAGE));
	  if (OrderType()==OP_SELL) return(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),SLIPPAGE));
	  return(OrderDelete(OrderTicket()));  
	}	
	return(-9);
}
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=   
void ButtonBool(int ihwnd,int button,bool state,color truecolor,color falsecolor, string truetxt="",string falsetxt="")
{
if (button>1)
{
	
   if (state) guiSetBgColor(ihwnd,button,truecolor);
   if (!state) guiSetBgColor(ihwnd,button,falsecolor);
   if (truetxt!="" && state) guiSetText(ihwnd,button,truetxt,15,"Times New Roman");
   if (falsetxt!="" && !state) guiSetText(ihwnd,button,falsetxt,15,"Times New Roman");         
}
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// adds a button to chart
int addButton(int ihwnd,int x,int y,int w,int h,string txt,int bgcolor,int txtcolor)
   {   
   int myb = guiAdd(ihwnd,"button",x,y,w,h,txt); guiSetBgColor(ihwnd,myb,bgcolor); guiSetTextColor(ihwnd,myb,txtcolor);
   return (myb);
   }
