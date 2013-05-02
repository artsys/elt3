	/*
		>Ver	:	0.0.17
		>Date	:	2013.01.18
		>Hist	:
			@0.0.17@2013.01.18@artamir	[+] цена расчета фрактала 
			@0.0.12@2013.01.11@artamir	[*] Исправления из поста: http://forum.roboforex.ru/showthread.php?t=1997&p=87457&viewfull=1#post87457
			@0.0.8@2013.01.10@artamir	[+]	Добавились две функции определения фракталов в классическом описании.
										[*] Изменились названия функций предыдущего варианта определения фракталов.
			@0.0.5@2012.11.13@artamir	[]
			@0.0.4@2012.11.13@artamir	[]
			@0.0.3@2012.11.13@artamir	[]
			@0.0.2@2012.11.13@artamir	[]
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Advanced fractal function
		>Благодарности:	vov4ik за проявленный интерес ;)	
	*/
	
	#define iFR.MODE_STD	1								//Фрактал в классическом понимании. Наивысший максимум или наинизший минимум среди заданного количества баров
	#define iFR.MODE_HL		2								//Наивысший максимум среди последовательно поднимающихся а затем последовательно опускающихся максимумов. 
	#define iFR.PR_HL		1								//По типу цены: хай, лоу
	#define iFR.PR_C		2								//По закрытию
	
	int iFR.NL		= 1;									//Nearest left bars
	int	iFR.NR		= 1;									//Nearest right bars
	int iFR.Mode	= 2;									//Mode for find fractal.
	int iFR.Pr		= 1;									//Price for find fractal.
	

	void iFR.Set(int nl=1, int nr=1, int mode = 1, int price = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.01.18
		>Hist	:
			@0.0.3@2013.01.18@artamir	[]
			@0.0.2@2013.01.10@artamir	[]
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	set fractal bars.
	*/
		iFR.NL = nl;
		iFR.NR = nr;
		iFR.Mode = mode;
		iFR.Pr = price;
	}
	
	bool iFR.IsUpMode1(int fb = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.01.18
		>Hist	:
			@0.0.3@2013.01.18@artamir	[+] Добавлен тип цены: закрытие
			@0.0.2@2013.01.11@artamir	[]
			@0.0.1@2013.01.10@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Определение верхнего фрактала в классическом описании. 
	*/
		//--------------------------------------------------
		bool 	f	= true;
		double	h	= 0;
		double fbH	= 0;
		
		//--------------------------------------------------
		int idx = 0;
		
		//--------------------------------------------------
		if(fb < iFR.NR){
			return(false);									//нехватает количества баров справа для определения фрактала.
		}
		
		//--------------------------------------------------
		if(iFR.Pr == iFR.PR_HL){
			fbH = iHigh(NULL, 0, fb);						//Хай заданного бара.
		}	
		if(iFR.Pr == iFR.PR_C){
			fbH = iClose(NULL, 0, fb);						//Закрытие заданного бара.
		}
		
		
		//--------------------------------------------------
		for(idx = fb-1; idx >= (fb-iFR.NR); idx--){
			
			//----------------------------------------------
			if(iFR.Pr == iFR.PR_HL){
				h = iHigh(NULL, 0, idx);
			}	
			
			if(iFR.Pr == iFR.PR_C){
				h = MathMax(iClose(NULL, 0, idx),iOpen(NULL, 0, idx));
			}
			//----------------------------------------------
			if(h > fbH){
				f = false;									// Не прошли условие, что заданный бар самый высокий слева на право 
			}
		}	
		
		//----------------------------------------------
		if(!f){
			return(false);
		}
			
		//----------------------------------------------
		for(idx = fb+1; idx <= (fb+iFR.NL); idx++){
		
			//----------------------------------------------
			if(iFR.Pr == iFR.PR_HL){
				h = iHigh(NULL, 0, idx);
			}
			if(iFR.Pr == iFR.PR_C){
				h = MathMax(iClose(NULL, 0, idx),iOpen(NULL, 0, idx));
			}
			
			//----------------------------------------------
			if(h > fbH){
				f = false;
			}
		}	
		
		//--------------------------------------------------
		return(f);
		
	}
	
	bool iFR.IsDwMode1(int fb = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.01.18
		>Hist	:
			@0.0.3@2013.01.18@artamir	[+] Добавлен тип цены: Закрытие
			@0.0.2@2013.01.11@artamir	[]
			@0.0.1@2013.01.10@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Определение нижнего фрактала в классическом описании. 
	*/
		//--------------------------------------------------
		bool 	f	= true;
		double	l	= 0;
		double fbL	= 0; 
		
		//--------------------------------------------------
		int idx = 0;
		
		//--------------------------------------------------
		if(fb < iFR.NR){
			return(false);									//нехватает количества баров справа для определения фрактала.
		}
		
		//--------------------------------------------------
		if(iFR.Pr == iFR.PR_HL){
			fbL = iLow(NULL, 0, fb);						//Лоу заданного бара.
		}
		if(iFR.Pr == iFR.PR_C){
			fbL = iClose(NULL, 0, fb);						//Закрытие заданного бара.
		}
		
		//--------------------------------------------------
		for(idx = fb-1; idx >= (fb-iFR.NR); idx--){
			
			//----------------------------------------------
			if(iFR.Pr == iFR.PR_HL){
				l = iLow(NULL, 0, idx);
			}
			if(iFR.Pr == iFR.PR_C){
				l = MathMin(iClose(NULL, 0, idx),iOpen(NULL, 0, idx));
			}

			
			//----------------------------------------------
			if(l < fbL){
				f = false;									// Не прошли условие, что заданный бар самый высокий слева на право 
			}
		}	
		
		//----------------------------------------------
		if(!f){
			return(false);
		}
			
		//----------------------------------------------
		for(idx = fb+1; idx <= (fb+iFR.NL); idx++){
		
			//----------------------------------------------
			if(iFR.Pr == iFR.PR_HL){
				l = iLow(NULL, 0, idx);
			}
			if(iFR.Pr == iFR.PR_C){
				l = MathMin(iClose(NULL, 0, idx),iOpen(NULL, 0, idx));
			}
			
			//----------------------------------------------
			if(l < fbL){
				f = false;
			}
		}	
		
		//--------------------------------------------------
		return(f);
		
	}
	
	bool iFR.IsUpMode2(int fb = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.01.18
		>Hist	:
			@0.0.3@2013.01.18@artamir	[+] Добавлен тип цены: Закрытие
			@0.0.2@2013.01.11@artamir	[]
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	check if bar with index fb is up fractal
	*/
	
		bool f = true;
		
		int i = -1;
		
		//-------------------------------------------------
		if(fb < iFR.NR){
			return(false);
		}
		
		//--------------------------------------------------
		for(i = fb; i > fb - iFR.NR; i--){
			
			//----------------------------------------------
			if(iFR.Pr == iFR.PR_HL){
				if(iHigh(NULL, 0, i) < iHigh(NULL, 0, i-1)){
					f = false;
				}
			}
			if(iFR.Pr == iFR.PR_C){
				if(iClose(NULL, 0, i) < MathMax(iClose(NULL, 0, i-1),iOpen(NULL, 0, i-1))){
					f = false;
				}
			}
		}
		
		if(!f){
			return(false);
		}
		
		//--------------------------------------------------
		if(f){
			for(i = fb; i < fb + iFR.NL; i++){
				if(iFR.Pr == iFR.PR_HL){
					if(iHigh(NULL, 0, i) < iHigh(NULL, 0, i+1)){
						f = false;
					}
				}
				if(iFR.Pr == iFR.PR_C){
					if(iClose(NULL, 0, i) < MathMax(iClose(NULL, 0, i+1),iOpen(NULL, 0, i+1))){
						f = false;
					}
				}				
			}
		}
		
		return(f);
	}
	
	bool iFR.IsDwMode2(int fb = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.01.18
		>Hist	:
			@0.0.3@2013.01.18@artamir	[+] Добавлен тип цены: Закрытие
			@0.0.2@2013.01.11@artamir	[]
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	check if bar with index fb is down fractal
	*/
	
		bool f = true;
		
		int i = -1;
		
		//-------------------------------------------------
		if(fb < iFR.NR){
			return(false);
		}
		
		//--------------------------------------------------
		for(i = fb; i > fb - iFR.NR; i--){
			
			//----------------------------------------------
			if(iFR.Pr == iFR.PR_HL){
				if(iLow(NULL, 0, i) > iLow(NULL, 0, i-1)){
					f = false;
				}
			}
			if(iFR.Pr == iFR.PR_C){
				if(iClose(NULL, 0, i) > MathMin(iClose(NULL, 0, i-1),iOpen(NULL, 0, i-1))){
					f = false;
				}
			}
		}
		
		//--------------------------------------------------
		if(!f){
			return(false);
		}
		
		//--------------------------------------------------
		if(f){
			for(i = fb; i < fb + iFR.NL; i++){
				if(iFR.Pr == iFR.PR_HL){
					if(iLow(NULL, 0, i) > iLow(NULL, 0, i+1)){
						f = false;
					}
				}
				if(iFR.Pr == iFR.PR_C){
					if(iClose(NULL, 0, i) > MathMin(iClose(NULL, 0, i+1),iOpen(NULL, 0, i+1))){
						f = false;
					}
				}
			}
		}
		
		return(f);
	}
	
	bool iFR.IsUp(int fb = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.01.10
		>Hist	:
			@0.0.1@2013.01.10@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Обертка для вызова функции определения верхнего фрактала в зависимости от режима. 
	*/
		
		//--------------------------------------------------
		if(iFR.Mode == iFR.MODE_STD){
			return(iFR.IsUpMode1(fb));
		}
		
		//--------------------------------------------------
		if(iFR.Mode == iFR.MODE_HL){
			return(iFR.IsUpMode2(fb));
		}
	}
	
	bool iFR.IsDw(int fb = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.01.10
		>Hist	:
			@0.0.1@2013.01.10@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Обертка для вызова функции определения нижнего фрактала в зависимости от режима. 
	*/
		
		//--------------------------------------------------
		if(iFR.Mode == iFR.MODE_STD){
			return(iFR.IsDwMode1(fb));
		}
		
		//--------------------------------------------------
		if(iFR.Mode == iFR.MODE_HL){
			return(iFR.IsDwMode2(fb));
		}
	}
	
	int iFR.getNearstUp(int startBar = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return index of bar of nearst up fractal
					Возвращает номер бара ближайшего верхнего фрактала.
	*/
	
		bool f = false;
		int i = startBar-1;
		
		while(!f && i < Bars){
			i++;
			
			if(iFR.IsUp(i)){
				f = true;
			}
		}
		
		return(i);
	}
	
	int iFR.getNearstDw(int startBar = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return index of bar of nearst down fractal
					Возвращает номер бара ближайшего верхнего фрактала.
	*/
	
		bool f = false;
		int i = startBar-1;
		
		while(!f && i < Bars){
			i++;
			
			if(iFR.IsDw(i)){
				f = true;
			}
		}
		
		return(i);
	}
	
	double iFR.getNearestUpPrice(int startBar){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return price by nearest up fractal
					Возвращает цену ближайшего верхнего фрактала
	*/
	
		int fb = iFR.getNearstUp(startBar);
		
		return(iHigh(NULL, 0, fb));
	}
	
	double iFR.getNearestDwPrice(int startBar){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.11.13
		>Hist	:
			@0.0.2@2012.11.13@artamir	[]
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return price by nearest down fractal
					Возвращает цену ближайшего нижнего фрактала
	*/
	
		int fb = iFR.getNearstDw(startBar);
		return(iLow(NULL, 0, fb));
	}