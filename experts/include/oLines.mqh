	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
void obj.setHLine(color cl, string nm="", double p1=0, int st=0, int wd=1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if (nm=="") nm=DoubleToStr(Time[0], 0);
	if (p1<=0) p1=Bid;
	if (ObjectFind(nm)<0) ObjectCreate(nm, OBJ_HLINE, 0, 0,0);
	ObjectSet(nm, OBJPROP_PRICE1, p1);
	ObjectSet(nm, OBJPROP_COLOR , cl);
	ObjectSet(nm, OBJPROP_STYLE , st);
	ObjectSet(nm, OBJPROP_WIDTH , wd);
}

void obj.setTRay(color cl, string nm="", datetime t1=0, double p1=0, datetime t2=0, double p2=0, int st=0, int wd=1, bool bg = true){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if (nm=="") nm=DoubleToStr(Time[0], 0);
	if (p1<=0) p1=Bid;
	if (p2<=0) p2=p1;
	
	if (ObjectFind(nm)<0) ObjectCreate(nm, OBJ_TREND, 0, 0,0,0,0);
	ObjectSet(nm, OBJPROP_TIME1	, t1);
	ObjectSet(nm, OBJPROP_PRICE1  , p1);
	ObjectSet(nm, OBJPROP_TIME2	, t2);
	ObjectSet(nm, OBJPROP_PRICE2  , p2);
	
	ObjectSet(nm, OBJPROP_RAY 	 , false);
	ObjectSet(nm, OBJPROP_BACK  , bg);
	ObjectSet(nm, OBJPROP_COLOR , cl);
	ObjectSet(nm, OBJPROP_STYLE , st);
	ObjectSet(nm, OBJPROP_WIDTH , wd);
}