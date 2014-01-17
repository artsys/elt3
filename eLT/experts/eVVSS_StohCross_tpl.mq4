#import "eVVSS_StohCross.ex4" //{
		//Внешние настройки эксперта
		string eVVSSSC_Ver_get(); //для контроля версии основного советника.
		string eVVSSSC_Exp_get(); //для получения имени эксперта.
		
		void eVVSSSC_SL_set					(int val);
		void eVVSSSC_TP_set					(int val);
		void eVVSSSC_LOT_set				(double val);
		void eVVSSSC_FIXProfit_use_set		(bool val);
		void eVVSSSC_FIXProfit_amount_set	(double val);
		void eVVSSSC_CMFB_use_set			(bool val);
		void eVVSSSC_CMFB_pips_set			(int val);
		
		void eVVSSSC_KPeriod1_set			(int val);
		void eVVSSSC_DPeriod1_set			(int val);
		void eVVSSSC_Slowing1_set			(int val);
		void eVVSSSC_MAMethod1_set			(int val);
		void eVVSSSC_PriceField1_set		(int val);
		
		void eVVSSSC_CloseOnRevers_set		(int val);
		void eVVSSSC_BarsShift_set			(int val);
		
		void eVVSSSC_FHMA_use_set			(bool val);
		void eVVSSSC_FHMA_period_set		(int val);
		void eVVSSSC_FHMA_method_set		(int val);
		void eVVSSSC_FHMA_price_set			(int val);
		void eVVSSSC_FHMA_sdvig_set			(int val);
		void eVVSSSC_FHMA_CheckBar_set		(int val);
		
		void eVVSSSC_FIA_use_set			(bool val);	
		void eVVSSSC_FIA_ExtDepth_set		(int val);
		void eVVSSSC_FIA_ExtDeviation_set	(int val);
		void eVVSSSC_FIA_ExtBackstep_set	(int val);
		void eVVSSSC_FIA_SIGNAL_BAR_set	(int val);
		
		void eVVSSSC_TRAL_Use_set		(bool val);
		void eVVSSSC_TRAL_DeltaPips_set	(int val);
		void eVVSSSC_TRAL_Step_pip_set	(int val);
		
		void eVVSSSC_TRAL_Fr_Use_set	(bool val);
		void eVVSSSC_TRAL_Fr_TF_set		(int val);
		void eVVSSSC_TRAL_Fr_R_set		(int val);
		void eVVSSSC_TRAL_Fr_L_set		(int val);
		
		void eVVSSSC_TRAL_ATR_use_set	(bool val);
		void eVVSSSC_TRAL_ATR_TF_set	(int val);
		void eVVSSSC_TRAL_ATR1_Per_set	(int val);
		void eVVSSSC_TRAL_ATR2_Per_set	(int val);
		void eVVSSSC_TRAL_ATR_COEF_set	(double val);
		void eVVSSSC_TRAL_ATR_INLOSS_set(bool val);
		
		void eVVSSSC_use_Revers_set		(bool val);
		
		int  eVVSSSC_startextern();
#import //}

extern	string	s1="==== MAIN ====="; //{
extern	int SL=50;
extern	int TP=50;
extern	double LOT=0.01;
extern	bool FIXProfit_use=false;	//Закрывать все ордера при достижении заданного профита.
extern	double FIXProfit_amount=500; //Значение фиксированного профита для закрытия всех ордеров.
extern bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
extern int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)

extern int       KPeriod1    	 =  8;
extern int       DPeriod1    	 =  3;
extern int       Slowing1    	 =  3;
extern int       MAMethod1    	=   0;
extern int       PriceField1  	=   1;

extern bool		CloseOnRevers	=false;
extern int		BarsShift		=1;

extern string fs1="=== FILTER VininIHMA ===";
//---- input parameters
extern bool FHMA_use		=false; 
extern int 	FHMA_period		=16; 
extern int 	FHMA_method		=3; // MODE_SMA 
extern int 	FHMA_price		=0; // PRICE_CLOSE 
extern int 	FHMA_sdvig		=0;
extern int 	FHMA_CheckBar	=1; 
extern string fe1="========================";

extern string fs3="=== FILTER indiAlert ===";
extern bool FIA_use				=false;
extern int 	FIA_ExtDepth 		= 37;
extern int 	FIA_ExtDeviation 	= 13;
extern int 	FIA_ExtBackstep 	= 5;
extern int 	FIA_SIGNAL_BAR 		= 1 ;
extern string fe3="========================";

extern bool		TRAL_Use		=false;
extern int		TRAL_DeltaPips	=10;
extern int		TRAL_Step_pip	=5;

extern bool		TRAL_Fr_Use	=false;
extern int		TRAL_Fr_TF	=0;	//таймфрейм расчета фракталов.
extern int		TRAL_Fr_R	=2;	//количество баров справа для определения фрактала
extern int		TRAL_Fr_L	=2;	//количество баров слева для определения фрактала

extern bool		TRAL_ATR_use	=false;
extern int		TRAL_ATR_TF		=0;
extern int		TRAL_ATR1_Per	=5;
extern int		TRAL_ATR2_Per	=20;
extern double	TRAL_ATR_COEF	=1;
extern bool		TRAL_ATR_INLOSS	=false;

extern bool		use_Revers		=false;
//}

int init(){
	Print(eVVSSSC_Exp_get(), " ver. ",eVVSSSC_Ver_get());
	
	//{ Установка внешних настроек эксперта.
	eVVSSSC_SL_set(SL);					
	eVVSSSC_TP_set(TP);					
	eVVSSSC_LOT_set(LOT);				
	eVVSSSC_FIXProfit_use_set(FIXProfit_use);		
	eVVSSSC_FIXProfit_amount_set(FIXProfit_amount);	
	eVVSSSC_CMFB_use_set(CMFB_use);			
	eVVSSSC_CMFB_pips_set(CMFB_pips);			
	
	eVVSSSC_KPeriod1_set(KPeriod1);			
	eVVSSSC_DPeriod1_set(DPeriod1);			
	eVVSSSC_Slowing1_set(Slowing1);			
	eVVSSSC_MAMethod1_set(MAMethod1);			
	eVVSSSC_PriceField1_set(PriceField1);		
	
	eVVSSSC_CloseOnRevers_set(CloseOnRevers);		
	eVVSSSC_BarsShift_set(BarsShift);			
	
	eVVSSSC_FHMA_use_set(FHMA_use);		
	eVVSSSC_FHMA_period_set(FHMA_period);	
	eVVSSSC_FHMA_method_set(FHMA_method);	
	eVVSSSC_FHMA_price_set(FHMA_price);		
	eVVSSSC_FHMA_sdvig_set(FHMA_sdvig);		
	eVVSSSC_FHMA_CheckBar_set(FHMA_CheckBar);
	
	eVVSSSC_FIA_use_set(FIA_use);			
	eVVSSSC_FIA_ExtDepth_set(FIA_ExtDepth);		
	eVVSSSC_FIA_ExtDeviation_set(FIA_ExtDeviation);	
	eVVSSSC_FIA_ExtBackstep_set(FIA_ExtBackstep);	
	eVVSSSC_FIA_SIGNAL_BAR_set(FIA_SIGNAL_BAR);	
	
	eVVSSSC_TRAL_Use_set(TRAL_Use);		
	eVVSSSC_TRAL_DeltaPips_set(TRAL_DeltaPips);	
	eVVSSSC_TRAL_Step_pip_set(TRAL_Step_pip);		
	
	eVVSSSC_TRAL_Fr_Use_set(TRAL_Fr_Use);
	eVVSSSC_TRAL_Fr_TF_set(TRAL_Fr_TF);	
	eVVSSSC_TRAL_Fr_R_set(TRAL_Fr_R);	
	eVVSSSC_TRAL_Fr_L_set(TRAL_Fr_L);	
	
	eVVSSSC_TRAL_ATR_use_set	(TRAL_ATR_use);	
	eVVSSSC_TRAL_ATR_TF_set		(TRAL_ATR_TF);	
	eVVSSSC_TRAL_ATR1_Per_set	(TRAL_ATR1_Per);	
	eVVSSSC_TRAL_ATR2_Per_set	(TRAL_ATR2_Per);	
	eVVSSSC_TRAL_ATR_COEF_set	(TRAL_ATR_COEF);	
	eVVSSSC_TRAL_ATR_INLOSS_set	(TRAL_ATR_INLOSS);
	
	eVVSSSC_use_Revers_set		(use_Revers);
	//}
}

int start(){
	eVVSSSC_startextern();
}	