	/*
		>Ver	:	0.0.10
		>Date	:	2013.01.16
		>Hist	:
			@0.0.10@2013.01.16@artamir	[]
			@0.0.9@2012.11.13@artamir	[]
			@0.0.8@2012.11.13@artamir	[]
			@0.0.7@2012.11.13@artamir	[]
			@0.0.6@2012.11.13@artamir	[]
			@0.0.5@2012.11.12@artamir	[]
			@0.0.4@2012.11.12@artamir	[]
			@0.0.3@2012.11.12@artamir	[]
			@0.0.2@2012.11.12@artamir	[]
			@0.0.1@2012.11.09@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Convoy on breack ZZ extrem
	*/
	
	//#include <iFractal.mqh>
	
	extern string	SOFF.Str = ">>>>>  CONVOY ON FRACTAL EXTREM";
	extern bool		SOFF.Use = false;							//USE this convoy
	extern int		SOFF.LeftBars = 2;
	extern int		SOFF.RightBars = 2;
	extern double	SOFF.LotMultiply = 2;
	extern int		SOFF.FreezeLevel = 20;					// do not set stop order in this range near fractal
	//------------------------------------------------------
	int SOFF.Main(int Parent = -1){
	
	/*
		>Ver	:	0.0.3
		>Date	:	2013.01.16
		>Hist	:
			@0.0.3@2013.01.16@artamir	[*] Определение фрактала по Вильямсу
			@0.0.2@2012.11.13@artamir	[]
			@0.0.1@2012.11.09@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		if(!SOFF.Use){
			return(0);
		}
		
		iFR.Set(SOFF.LeftBars, SOFF.RightBars, 1);			//Определение фрактала по Вильямсу
		
		double d[][libT.OE_MAX];
		
		//..	BYUSTOP
			int ROWS = CY.selectOByGT(d, GT.BSFF, libT.OE_TY, ">=", 2);
		
			//----------------------------------------------
			if(ROWS >= 1){
				SOFF.CheckOnUpFF(d);
			}
			
		//.

		//..	SELLSTOP
			ROWS = CY.selectOByGT(d, GT.SSFF, libT.OE_TY, ">=", 2);
		
			//----------------------------------------------
			if(ROWS >= 1){
				SOFF.CheckOnDwFF(d);
			}
			
		//.
		
		//..	@OPEN STOP ORDERS
			SOFF.CheckChildrens();
		//.
		
		libSOTr.TP.Main();
		
	}
		
	int SOFF.CheckOnDwFF(double &d[][]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		double FFD = iFR.getNearestDwPrice(1);
		
		int ROWS = ArrayRange(d, 0);
		
		for(int idx = 0; idx < ROWS; idx++){
			int ti = d[idx][libT.OE_TI];
			int ty = d[idx][libT.OE_TY];
			
			//----------------------------------------------
			if(ty <= 1){
				continue;
			}
			
			if(!SOFF.isPriceInZone(FFD)){
				libO.ModifyPrice(ti, FFD, libO.MODE_PRICE);
			}	
		}
		
	}
	
	int SOFF.CheckOnUpFF(double &d[][]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		double FFU = iFR.getNearestUpPrice(1);
		
		int ROWS = ArrayRange(d, 0);
		
		for(int idx = 0; idx < ROWS; idx++){
			int ti = d[idx][libT.OE_TI];
			int ty = d[idx][libT.OE_TY];
			
			//----------------------------------------------
			if(ty <= 1){
				continue;
			}
			
			if(!SOFF.isPriceInZone(FFU)){
				libO.ModifyPrice(ti, FFU, libO.MODE_PRICE);
			}	
		}
		
	}
	
	int SOFF.CheckChildrens(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/


		double d[][libT.OE_MAX];
		int ROWS = libT.SelectExtraParents(d);
		BP("CheckChildrens", "ROWS = ", ROWS);
		//--------------------------------------------------
		if(ROWS >= 1){
			SOFF.CircleOnParents(d);
		}
	}
	
	int SOFF.CircleOnParents(double &d[][]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.12
		>Hist	:
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
		int ROWS = ArrayRange(d, 0);
		
		if(ROWS <= 0){
			return(0);
		}
		
		for(int idx = 0; idx < ROWS; idx++){
			int parent.ti = d[idx][libT.OE_TI];
			int parent.ty = d[idx][libT.OE_TY];
			
			int GT = -1;
			
			//----------------------------------------------
			if(parent.ty == OP_BUY){
				GT = GT.BSFF;
			}
			
			if(parent.ty == OP_SELL){
				GT = GT.SSFF;
			}
			
			SOFF.CheckChildrenOnParent(parent.ti, parent.ty, GT);
		}
	}
	
	int SOFF.CheckChildrenOnParent(int parent.ti, int parent.ty, int GT){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.11.13
		>Hist	:
			@0.0.3@2012.11.13@artamir	[]
			@0.0.2@2012.11.13@artamir	[]
			@0.0.1@2012.11.12@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		
		//--------------------------------------------------
		int parent.level	= libT.getExtraGLByTicket(parent.ti);
		int parent.mp		= libT.getExtraMAINPARENTByTicket(parent.ti);
		
		//--------------------------------------------------
		double d[][libT.OE_MAX];
		int ROWS = libT.getOrdersByParent(parent.ti, d);
		
		//--------------------------------------------------
		double lot = SOFF.CalcLotByParent(parent.ti);
	
		//--------------------------------------------------
		if(parent.ty == OP_BUY){
			
			//----------------------------------------------
			double FFU = iFR.getNearestUpPrice(1);
			obj.setHLine(Green, "UF", FFU);
			//----------------------------------------------
			if(ROWS <= 0){
			
				if(!SOFF.isPriceInZone(FFU)){
					int ti = libO.SendBUYSTOP(FFU, 0, lot);
				}	
			}	
		}
		
		//--------------------------------------------------
		if(parent.ty == OP_SELL){
			
			//----------------------------------------------
			double FFD = iFR.getNearestDwPrice(1);
			obj.setHLine(Red, "DF", FFD);
			//----------------------------------------------
			if(ROWS <= 0){
				
				if(!SOFF.isPriceInZone(FFD)){
					ti = libO.SendSELLSTOP(FFD, 0, lot);
				}	
			}	
		}
		
		//--------------------------------------------------
		if(ti > 0){
			//----------------------------------------------
			libT.setExtraStandartData(ti);
			
			//----------------------------------------------
			libT.setExtraMainParentByTicket(ti, parent.mp);
			libT.setExtraParentByTicket(ti, parent.ti);
			libT.setExtraGridTypeByTicket(ti, GT);
			libT.setExtraIsParentByTicket(ti, 1);			//when pending children becames market order (BUY or SELL) it becames a parent order 
			libT.setExtraGLByTicket(ti, parent.level+1);
		}
		
	}
	
	double SOFF.CalcLotByParent(int parent.ticket){
		double parent.lot = libT.getExtraLotByTicket(parent.ticket);
	
		//------------------------------------------------------
		return(parent.lot * SOFF.LotMultiply);
	}

	bool SOFF.isPriceInZone(double pr.center){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		
		bool res = false;
		
		//--------------------------------------------------
		double up = libNormalize.Digits(pr.center+SOFF.FreezeLevel*Point);
		double dw = libNormalize.Digits(pr.center-SOFF.FreezeLevel*Point);
		
		//--------------------------------------------------
		if(Bid < up && Bid > dw){
			res = true;
		}
		
		return(res);
	}