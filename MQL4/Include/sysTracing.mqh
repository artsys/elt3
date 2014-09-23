//+------------------------------------------------------------------+
//|                                                   sysTracing.mqh |
//|                                                          artamir |
//|                                          http://forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forexmd.ucoz.org"
#property strict

int TRAC_Handle=-1;

string TRAC_str="";

void TRAC_Init(){
   TRAC_Handle=FileOpen("Tracing.xml",FILE_TXT|FILE_READ|FILE_WRITE);
   TRAC_AddString("if{"+__FILE__);
}

void TRAC_AddString(string str){
   TRAC_str=StringConcatenate(TRAC_str,str);
}

void TRAC_Deinit(){
   TRAC_AddString(__FILE__+"}");
   FileClose(TRAC_Handle);
}

void TRAC_WriteFile(){
   FileWriteString(TRAC_Handle,TRAC_str);
   FileClose(TRAC_Handle);
}

