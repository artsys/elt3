	/*
		>Ver	:	0.0.5
		>Date	:	2012.12.20
		>Hist	:
			@0.0.5@2012.12.20@artamir	[]
			@0.0.4@2012.12.20@artamir	[]
			@0.0.3@2012.12.19@artamir	[]
			@0.0.2@2012.12.19@artamir	[]
			@0.0.1@2012.12.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
bool iPA.IsMH(int left = 1, int right = 1, int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.14
		>Hist	:
			@0.0.1@2012.12.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	¬озвращает true, если хай заданного бара
					равен ха€м left баров слева и right баров
					справа.
		>VARS	:	left - количество баров слева
				:	right - количество баров справа
				:	shift - номер провер€емого бара
	*/
	
	//------------------------------------------------------
	if(shift <= right){
		return(false);										// нехватает количества баров справа
															// дл€ определени€ множественного ха€.
	}
	
	//------------------------------------------------------
	if(shift >= Bars - left){
		return(false);										// нехватает количества баров слева
															// дл€ определени€ множественного ха€
	}
	
	//------------------------------------------------------
	double h = iHigh(NULL, 0, shift);
	bool is.mh = true;
	
	int idx = shift;
	//------------------------------------------------------
	while(idx <= shift+left && is.mh){
		double hl = iHigh(NULL, 0, idx);					//левый хай
		
		if(h != hl){
			is.mh = false;
		}
		idx++;
	}
	
	//------------------------------------------------------
	idx = shift;
	while(idx >= shift-right && is.mh){						
		double hr = iHigh(NULL, 0, idx);					//правый хай
		
		if(h != hr){
			is.mh = false;
		}
		idx--;
	}
	
	return(is.mh);
}	

bool iPA.IsML(int left = 1, int right = 1, int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.14
		>Hist	:
			@0.0.1@2012.12.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	¬озвращает true, если лоу заданного бара
					равен лоу left баров слева и right баров
					справа.
		>VARS	:	left - количество баров слева
				:	right - количество баров справа
				:	shift - номер провер€емого бара
	*/
	
	//------------------------------------------------------
	if(shift <= right){
		return(false);										// нехватает количества баров справа
															// дл€ определени€ множественного лоу.
	}
	
	//------------------------------------------------------
	if(shift >= Bars - left){
		return(false);										// нехватает количества баров слева
															// дл€ определени€ множественного лоу
	}
	
	//------------------------------------------------------
	double l = iLow(NULL, 0, shift);
	bool is.ml = true;
	
	int idx = shift;
	//------------------------------------------------------
	while(idx <= shift+left && is.ml){
		double ll = iLow(NULL, 0, idx);						//левый лоу
		
		if(l != ll){
			is.ml = false;
		}
		idx++;
	}
	
	//------------------------------------------------------
	idx = shift;
	while(idx >= shift-right && is.ml){						
		double lr = iLow(NULL, 0, idx);						//правый лоу
		
		if(l != lr){
			is.ml = false;
		}
		idx--;
	}
	
	return(is.ml);
}	

bool iPA.IsTH(int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.19
		>Hist	:
			@0.0.1@2012.12.19@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	¬озвращает true если High по заданному 
					смещению €вл€етс€ тройным хаем.
	*/
	
	//------------------------------------------------------
	return(iPA.IsMH(1,1,shift));
}

bool iPA.IsTL(int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.19
		>Hist	:
			@0.0.1@2012.12.19@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	¬озвращает true если Low по заданному 
					смещению €вл€етс€ тройным лоу.
	*/
	
	//------------------------------------------------------
	return(iPA.IsML(1,1,shift));
}

bool iPA.IsOB(int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.20
		>Hist	:
			@0.0.1@2012.12.20@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	ѕровер€ет, если заданный бар €вл€етс€ внешним.
					”словие. ћаксимум и минимум предыдущего бара
					наход€тс€ в границах максимума и минимума 
					провер€емого бара.
	*/
	
	double res = false;
	
	//------------------------------------------------------
	double tH = iHigh(NULL, 0, shift);						//this High
	double pH = iHigh(NULL, 0, shift+1);					//prev. High
	
	double tL = iLow(NULL, 0, shift);						//this Low
	double pL = iLow(NULL, 0, shift+1);						//prev. Low
	
	//------------------------------------------------------ 
	if(pH < tH && pL > tL){
		return(true);
	}
	
	//------------------------------------------------------
	return(res);
}

bool iPA.IsOBU(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.20
		>Hist	:
			@0.0.1@2012.12.20@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	ѕровер€ет если внешний бар €вл€етс€ бычьим.
					”словие. ƒл€ провер€емого бара должно быть 
					закрытие выше открыти€, а дл€ предыдущего 
					бара должно быть закрытие ниже открыти€.
	*/
	
	bool res = false;
	
	//------------------------------------------------------
	double tO = iOpen(NULL, 0, shift);
	double pO = iOpen(NULL, 0, shift+1);
	
	double tC = iClose(NULL, 0, shift);
	double pC = iClose(NULL, 0, shift+1);
	
	//------------------------------------------------------
	if(!iPA.IsOB(shift)){
		return(false);										//это не внешний бар
	}
	
	//------------------------------------------------------
	if(tC > tO && pC < pO){
		return(true);
	}
	//------------------------------------------------------
	return(res);
}

bool iPA.IsOBD(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.20
		>Hist	:
			@0.0.1@2012.12.20@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	ѕровер€ет если внешний бар €вл€етс€ медвежьим.
					”словие. ƒл€ провер€емого бара должно быть 
					закрытие ниже открыти€, а дл€ предыдущего 
					бара должно быть закрытие выше открыти€.
	*/
	
	bool res = false;
	
	//------------------------------------------------------
	double tO = iOpen(NULL, 0, shift);
	double pO = iOpen(NULL, 0, shift+1);
	
	double tC = iClose(NULL, 0, shift);
	double pC = iClose(NULL, 0, shift+1);
	
	//------------------------------------------------------
	if(!iPA.IsOB(shift)){
		return(false);										//это не внешний бар
	}
	
	//------------------------------------------------------
	if(tC < tO && pC > pO){
		return(true);
	}
	//------------------------------------------------------
	return(res);
}