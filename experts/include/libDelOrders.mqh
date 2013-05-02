	/*
		>Ver	:	0.0.3
		>Date	:	2012.11.13
		>Hist	:
			@0.0.3@2012.11.13@artamir	[]
			@0.0.2@2012.11.13@artamir	[]
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	void DPO.DeleteOrders(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
		
		double d[][libT.OE_MAX];
		
		int idx = -1;
		
		int ti = -1;
		int parent.ti = -1;
		
		int		f.COL, f.OP;
		double	f.MAX, f.MIN;
		
		libA.double_eraseFilter2();
		
		//..	@SELECT ALL PENDING ORDERS@
		
			f.COL = libT.OE_TY;
			f.OP	= libA.SOP.AND;
			f.MAX	= 5;
			f.MIN	= 2;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		//.
		
		//..	@SELECT ALL NO CLOSED ORDERS@
		
			f.COL = libT.OE_ISCLOSED;
			f.OP	= libA.SOP.AND;
			f.MIN	= -1;
			f.MAX	= 0;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		//.
		
		libA.double_SelectArray2(libT.array_dExtraOrders, d);
		
		int ROWS = ArrayRange(d, 0);
		
		if(ROWS <= 0){
			return;
		}
		
		//--------------------------------------------------
		for(idx = 0; idx < ROWS; idx++){
			
			//----------------------------------------------
			ti = d[idx][libT.OE_TI];
			
			if(ti > 0){
				parent.ti = libT.getExtraPARENTByTicket(ti);
			}

			if(parent.ti > 0){
				
				int isClosedParent = libT.getExtraIsClosedTicket(parent.ti);
				
				if(isClosedParent >= 1){
					libO.DeleteByTicket(ti);
				}
			}
		}
	}