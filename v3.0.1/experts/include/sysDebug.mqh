/*
		>Ver	:	0.0.1
		>Date	:	2012.06.25
		>History:
			@0.0.1@2012.06.25@artamir	[+] BP()
		>Description:
			system. For debugging
*/

void BP(string	txt	= "",
		string	p11	= "",		string p12	= "",
		string	p21	= "",		string p22	= "", 
		string	p31	= "",		string p32	= "",
		string	p41	= "",		string p42	= "",
		string	p51	= "",		string p52	= "",
		bool	useDebug = true					){//..
		
		/*
		>Ver	:	0.0.2
		>Date	:	2012.06.25
		>History:
			@0.0.2@2012.06.25@artamir	[+]	useDebug = проверка на разрешение вызова модальной формы
			@0.0.1@2012.06.25@artamir	[] 
		>Description:
			Break point. Use with vizualization.
		*/
		
		if(!useDebug) return;
		//-------------------
		string strOutput = StringConcatenate(	p11,p12,"\n",
												p21,p22,"\n",
												p31,p32,"\n",
												p41,p42,"\n",
												p51,p52,"\n");
												
		static int	flOK = 1;
		if(flOK == 1){
			flOK = MessageBoxA(WindowHandle(Symbol(),0), strOutput, txt, MB_OKCANCEL);
			return;
		}else{
			return;
		}
}//.