	/*
		>Ver	:	0.0.0.50
		>Date	:	2013.11.05
		>Hist	:																																			
					@0.0.0.50@2013.11.05@artamir	[!!]	A_d_Sort2 - Перенаправление на Ad_SortShell.
					@0.0.0.49@2013.10.24@artamir	[!*]	A_d_Compare (необходимо тестирование)
					@0.0.0.48@2013.10.22@artamir	[!]	A_d_Select
					@0.0.0.47@2013.09.13@artamir	[*]	A_d_Select
					@0.0.0.46@2013.08.29@artamir	[]	A_d_Select
					@0.0.0.45@2013.08.06@artamir	[+]	A_s_PrintArray2
					@0.0.0.44@2013.06.28@artamir	[]	A_d_releaseArray
					@0.0.0.43@2013.06.25@artamir	[!]	A_d_Select	Добавлено обнуление массива-приемника по требованию.
					@0.0.0.42@2013.06.12@artamir	[]	A_d_Select
					@0.0.0.41@2013.05.20@artamir	[]	A_d_Compare
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	function to work with arrays
		>Pref	:	A
				:	d - for double arrays
	*/

#define ARRVER	"0.0.0.50_2013.11.05"
	
//{ === TEMPORAR ARRAY

double	dArrayTemp2[];	// double temporar 2 dim array
int		dArrayTemp2.COLS = 0;

void A_d_setArray(double &d[][]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	copy d[][] to temporar array
	*/
	
	//------------------------------------------------------
	dArrayTemp2.COLS = ArrayRange(d, 1);
	
	//------------------------------------------------------
	A_d_eraseArray2(dArrayTemp2);
	
	//------------------------------------------------------
	A_d_Copy2To1(d, dArrayTemp2);
}

int	A_d_addRow(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Add new row to temporar array
	*/
	
	string fn = "A_d_addRow";
	
	//------------------------------------------------------
	int ROWS = ArrayRange(dArrayTemp2, 0);
	int newSize = ROWS+dArrayTemp2.COLS;
	
	//BP(fn, "ROWS = ", ROWS, "newSize = ", newSize);
	//------------------------------------------------------
	ArrayResize(dArrayTemp2, newSize);
	
	//BP(fn, "ArrayRange = ", ArrayRange(dArrayTemp2, 0), "ArrayRange(dArrayTemp2, 0)/dArrayTemp2.COLS = ",ArrayRange(dArrayTemp2, 0)/dArrayTemp2.COLS - 1);
	//------------------------------------------------------
	return(ArrayRange(dArrayTemp2, 0)/dArrayTemp2.COLS - 1);
}

void A_d_setPropByIndex(int idx, int prop, double val){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.23
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	set property value by index to temporar array
	*/
	
	//------------------------------------------------------
	string fn = "A_d_setPropByIndex";
	
	//------------------------------------------------------
	dArrayTemp2[(idx*dArrayTemp2.COLS)+prop] = val;
		
}

#define	A_RA_COPY	1
#define	A_RA_DONT	2

void A_d_releaseArray(double &d[][], int mode = 1){
	/*
		>Ver	:	0.0.4
		>Date	:	2012.10.02
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	copy temporar array to d[][] and erase temporar array
	*/
	
	//------------------------------------------------------
	string fn = "A_d_releaseArray";
	
	//------------------------------------------------------
	if(mode == A_RA_DONT){
		return;
	}
	
	//------------------------------------------------------
	A_d_eraseArray2(d);
	
	//------------------------------------------------------
	//ArrayCopy(d, dArrayTemp2, 0, 0, WHOLE_ARRAY);
	
	A_d_Copy1To2(dArrayTemp2, d, dArrayTemp2.COLS);
	
	//------------------------------------------------------
	A_d_eraseArray2(dArrayTemp2);
}

//}

//{ === ARRAY FUNCTIONS	============================

void A_d_eraseArray2(double	&d[][]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	ArrayResize(d, 0);
}

void A_d_Copy1To2(double &s[], double &d[][], int d_COLS = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Copy from s:1 dim array to d:2 dim array
	*/
	
	int s.ROWS = ArrayRange(s, 0);
	
	//------------------------------------------------------
	int COLS = d_COLS;	//destination COUMNS
	
	for(int idx = 0; idx < s.ROWS; idx++){
		
		//--------------------------------------------------
		int idx_1 = MathFloor(idx/COLS);
		int idx_2 = idx - idx_1*COLS;
		
		//--------------------------------------------------
		int d_ROWS = ArrayRange(d, 0);
		
		//--------------------------------------------------
		if(d_ROWS <= idx_1){
			ArrayResize(d, (idx_1+1));
		}
		
		//--------------------------------------------------
		d[idx_1][idx_2] = s[idx];
	}
}

void A_d_Copy2To1(double &s[][], double &d[]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int s.ROWS = ArrayRange(s, 0);
	int s.COLS = ArrayRange(s, 1);
	
	//------------------------------------------------------
	int d_idx	= 0;	
	
	//------------------------------------------------------
	for(int idx_1 = 0; idx_1 < s.ROWS; idx_1++){
		
		for(int idx_2 = 0; idx_2 < s.COLS; idx_2++){
		
			//----------------------------------------------
			double val = s[idx_1][idx_2];
			
			//----------------------------------------------
			int d_ROWS = ArrayRange(d, 0);
			
			//----------------------------------------------
			if(d_ROWS <= d_idx){
				ArrayResize(d, d_idx+1);
			}
			
			//----------------------------------------------
			d[d_idx] = val;
			
			//----------------------------------------------
			d_idx++;
		}
	}
}

int A_d_getIndexByProp2(double &d[][], int prop, double val){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.02.20
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int	ROWS = ArrayRange(d, 0);
	
	//------------------------------------------------------
	bool isFind = false;
	
	//------------------------------------------------------
	int idx = -1;
	
	//------------------------------------------------------
	while(!isFind && idx < ROWS){

		//--------------------------------------------------
		idx++;
		
		//--------------------------------------------------
		double d_VAL = d[idx][prop];
		
		//--------------------------------------------------
		val = Norm_symb(val);
		
		//--------------------------------------------------
		d_VAL = Norm_symb(d_VAL);
		
		//--------------------------------------------------
		if(d_VAL == val){
			
			//----------------------------------------------
			isFind = true;
			
			//----------------------------------------------
		}
	}

	//------------------------------------------------------
	if(!isFind){
		return(-1);
	}
	
	//------------------------------------------------------
	return(idx);
}

void A_d_Swap2(double &a[][], int i1, int i2){
	/**
		\version	0.0.0.3
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Меняет местами строки двумерного массива
		\internal
			>Hist:			
					 @0.0.0.3@2013.05.17@artamir	[]	A_d_releaseArray
					 @0.0.0.2@2013.05.17@artamir	[]	A_d_releaseArray
					 @0.0.0.1@2013.05.17@artamir	[]	A_d_releaseArray
			>Rev:0
	*/
	
	int a_COLS = ArrayRange(a, 1);
	
	for(int col = 0; col < a_COLS; col++){
		double temp = a[i1][col];
		a[i1][col] = a[i2][col];
		a[i2][col] = temp;
	}

}

void A_d_CopyRow2(double &a[][], int ifrom, int ito=-1){
	/**
		\version	0.0.0.1
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Копирует строку с индексом ifrom в строку с индексом ito
					Если ito = -1 тогда создается новая строка и нужная строка копируется в эту строку.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.28@artamir	[]	A_d_releaseArray
			>Rev:0
	*/

	int idx_to = ito;
	if(idx_to <= -1){
		int ROWS = ArrayRange(a, 0);
		ArrayResize(a, (ROWS+1));
		idx_to = ROWS;
	}
	
	int COLS = ArrayRange(a, 1);
	for(int ic = 0; ic < COLS; ic++){
		//Цикл по колонкам.
		a[ito][ic] = a[ifrom][ic];
	}
}

#define A_ABOVE 0
#define A_EQ 1
#define A_UNDER 2

bool A_d_Compare(double &a[][], int i1, int i2, string compare = ""){
	/**
		\version	0.0.0.3
		\date		2013.10.24
		\author		Morochin <artamir> Artiom
		\details	Сравнение двух строк массива
		\internal
			>Hist:			
					 @0.0.0.3@2013.10.24@artamir	[!*]	Сравнение по нескольким колонкам
						колонки и операции сравнения задаются строкой вида:
						<КолонкаИОперация>[<КолонкаИОперация>]
						КолонкаИОперация:=<НомерКолонки><Пробел><ОперацияСравнения><ТочкаСЗапятой>
						Если значения по текущей колонке равны, то переходим к следующей колонке из списка.
					 @0.0.0.1@2013.05.20@artamir	[+]	A_d_Compare
			>Rev:0
			compare может быть строкой формата "<номер колонки для сравнения><пробел><операция сравнения><точкасзапятой>"
			"5 >;" или "7 <=;"
	*/

	string fn="A_d_Compare";	
	string subs[];
	ArrayResize(subs,0);
	int subs_ROWS = 0;
	StringToArray(subs, compare, ";");	//Разбиваем на массив параметров сравнения т.е. на элементы: <НомерКолонки><Пробел><ОперацияСравнения>
	subs_ROWS = ArrayRange(subs,0)-1;
	
	//A_s_PrintArray1(subs, "subs");
	
	for(int i = 0; i < subs_ROWS; i++){	//цикл по количеству сравниваемых колонок.
		string co[0];
		ArrayResize(co,0);
		int co_ROWS = 0;
		StringToArray(co, subs[i], " ");	
		co_ROWS = ArrayRange(co,0);	//Количество строк массива индексов колонок для сравнения.
	
		if(co_ROWS > 0){
			int col = StrToInteger(co[0]);
			string op = co[1];
			
			int assertion;
			if(a[i1,col]>a[i2,col]){assertion=A_ABOVE;}
			if(a[i1,col]==a[i2,col]){assertion=A_EQ;}
			if(a[i1,col]<a[i2,col]){assertion=A_UNDER;}
			if(BP_SRT){Print (fn+": col = "+col, " op = "+op, " assertion="+assertion, " subs_ROWS="+subs_ROWS);}
			if(assertion==A_ABOVE 	&& (op==">" ||op==">=")){return(true);}
			if(assertion==A_UNDER 	&& (op=="<" ||op=="<=")){return(true);}
			if(assertion==A_EQ){continue;}	//значения колонок равны, но не было совпадения с операциями сравнения.
		}
	}
	return(false);
}
//}

//{ === SELECT FUNCTIONS	============================

#define SEL_OP_AND	1										/*Operation AND*/
#define SEL_OP_OR	2										//Operation OR

#define AS_OP_EQ	1										// Операция сравнения на равенство значению Макс фильтра
#define AS_OP_NOT	2										// Операция сравнения на не равенство значению Макс фильтра
#define AS_OP_ABOVE	5										// Больще заданного значения
#define AS_OP_GREAT 5
#define AS_OP_UNDER	6										// Меньше заданного значения
#define AS_OP_LESS	6
#define AS_OP_IN	3										// Операция сравнения на вхождение в диапазон включая границы.
#define AS_OP_OUT	4										// значение колонки вне диапазона

//===	Filter array cols

#define F_COL		0										/*колонка фильтра*/
#define F_MAX		1										//макс. значение фильтра
#define F_MIN		2										//мин. значение фильтра
#define F_SEL_OP	3										//операция объединения условий (or and)
#define F_AS_OP		4										//операция проверки значения ячейки.
#define F_TOT		5

double	A_Filter[][F_TOT];

int A_eraseFilter(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.05
		>Hist	:
			@0.0.1@2012.10.05@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	ArrayResize(A_Filter, 0);
	
	//------------------------------------------------------
	return(0);
}

int A_FilterAdd_AND(int COL, double MAX = 0, double MIN = 0, int as.OP = 3){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.20
		>Hist	:
			@0.0.1@2012.10.05@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	A_d_setArray(A_Filter);
	
	//------------------------------------------------------
	int idx = A_d_addRow();
	
	//------------------------------------------------------
	A_d_setPropByIndex(idx	,F_COL		,COL);
	A_d_setPropByIndex(idx	,F_MAX		,MAX);
	A_d_setPropByIndex(idx	,F_MIN		,MIN);
	A_d_setPropByIndex(idx	,F_SEL_OP	,SEL_OP_AND);
	A_d_setPropByIndex(idx	,F_AS_OP	,as.OP);
	
	//------------------------------------------------------
	A_d_releaseArray(A_Filter);
	
	//------------------------------------------------------
	return(idx);
}

int A_FilterAdd_OR(int COL, double MAX = 0, double MIN = 0, int as.OP = 3){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.05
		>Hist	:
			@0.0.1@2012.10.05@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	A_d_setArray(A_Filter);
	
	//------------------------------------------------------
	int idx = A_d_addRow();
	
	//------------------------------------------------------
	A_d_setPropByIndex(idx	,F_COL		,COL);
	A_d_setPropByIndex(idx	,F_MAX		,MAX);
	A_d_setPropByIndex(idx	,F_MIN		,MIN);
	A_d_setPropByIndex(idx	,F_SEL_OP	,SEL_OP_OR);
	A_d_setPropByIndex(idx	,F_AS_OP	,as.OP);
	
	//------------------------------------------------------
	A_d_releaseArray(A_Filter);
	
	//------------------------------------------------------
	return(idx);
}

bool A_Assertion_EQ(double s_val /*source value*/, double a_val /*assertion value*/){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.19
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(Norm_symb(s_val) == Norm_symb(a_val)){
		return(True);
	}
	
	return(False);
}

bool A_Assertion_NOT(double s_val /*source value*/, double a_val /*assertion value*/){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.19
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(Norm_symb(s_val) != Norm_symb(a_val)){
		return(True);
	}
	
	return(False);
}

bool A_Assertion_ABOVE(double f_val /*filter value*/, double a_val /*assertion value*/){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.06
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(Norm_symb(a_val) > Norm_symb(f_val)){
		return(True);
	}
	
	return(False);
}

bool A_Assertion_UNDER(double f_val /*filter value*/, double a_val /*assertion value*/){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.06
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(Norm_symb(a_val) < Norm_symb(f_val)){
		return(true);
	}
	
	return(false);
}


bool A_Assertion_IN(double		s_max_val	/*source max value*/
					, double	s_min_val	/*source min value*/
					, double	a_val		/*assertion value*/){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.19
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if((Norm_symb(a_val) <= Norm_symb(s_max_val)) && (Norm_symb(a_val) >= Norm_symb(s_min_val))){
		return(True);
	}
	
	return(False);
}

bool A_Assertion_OUT(double		s_max_val	/*source max value*/
					, double	s_min_val	/*source min value*/
					, double	a_val		/*assertion value*/){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.19
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if((Norm_symb(a_val) > Norm_symb(s_max_val)) || (Norm_symb(a_val) < Norm_symb(s_min_val))){
		return(True);
	}
	
	return(False);
}

bool A_Assert(int as_op, double a_val, double s_max, double s_min=-1){
	/**
		\version	0.0.0.0
		\date		2013.11.08
		\author		Morochin <artamir> Artiom
		\details	Обобщенная функция сравнения.
		\internal
			>Hist:
			>Rev:0
	*/
	if(as_op==AS_OP_EQ)return(A_Assertion_EQ(s_max,a_val));
	if(as_op==AS_OP_NOT)return(A_Assertion_NOT(s_max,a_val));
	if(as_op==AS_OP_ABOVE)return(A_Assertion_ABOVE(s_max,a_val));
	if(as_op==AS_OP_UNDER)return(A_Assertion_UNDER(s_max,a_val));
	if(as_op==AS_OP_IN)return(A_Assertion_IN(s_min,s_max,a_val));
	if(as_op==AS_OP_OUT)return(A_Assertion_OUT(s_min,s_max,a_val));
	
	return(false);//default
}

int A_d_Select(		double	&s[][] /*source array*/
				,	double	&d[][] /*destination array*/
				,	bool	need_add_rows = false
				,	int 	mode=0 /** направление перебора (по умолчанию по возрастанию)*/){
	/*
		>Ver	:	0.0.0.8
		>Date	:	2013.10.22
		>Hist	:			
					@0.0.0.8@2013.10.22@artamir	[!]	Исправлено сравнение UNDER
					@0.0.0.7@2013.09.13@artamir	[*]	удалил операцию копирования массива фильтра.
					@0.0.0.6@2013.06.25@artamir	[]	A_d_Select
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	string fn="A_d_Select";
	double f[][F_TOT];
	int s_ROWS = 0;
	int f_ROWS = 0;
	int s_COLS = 0;
	int f_COLS = 0;
	
	int s_row = 0;
	int s_col = 0;
	double s_val = 0;
	
	int f_row = 0;
	double f_max = 0;
	double f_min = 0;
	int f_as = 0;
	int f_sel = 0;
	
	bool this_assertion = false;
	bool res_assertion = false;
	
	if(!need_add_rows){ArrayResize(d,0);}
	
	//ArrayResize(f,0);
	int d_idx = ArrayRange(d,0);
	
	ArrayCopy(f, A_Filter, 0, 0, WHOLE_ARRAY);
	s_ROWS = ArrayRange(s,0);
	s_COLS = ArrayRange(s,1);
	f_ROWS = ArrayRange(A_Filter,0);
	
	for(int i = 0; i < s_ROWS; i++){
		//--- цикл по строкам массива-источника
		
		if(mode==0) s_row = i;
		if(mode==1){s_row = s_ROWS-i;}
		
		f_max = 0;	f_min = 0; 
		f_as = 0;	f_sel = 0;
		
		s_val = 0;
		
		res_assertion = false;
		this_assertion = false;	
		
		for(f_row = 0; f_row < f_ROWS; f_row++){
			//--- цикл по строкам массива-фильтра
			//----------------------------------------------
			s_col 	= A_Filter[f_row][F_COL];
			f_max 	= A_Filter[f_row][F_MAX];
			f_min 	= A_Filter[f_row][F_MIN];
			f_as	= A_Filter[f_row][F_AS_OP];
			f_sel 	= A_Filter[f_row][F_SEL_OP];
			
			s_val = s[s_row][s_col];
			
			if(BP_SNP){
				BP("A_d_Select"
					,"s_col=",s_col
					,"f_max=",f_max
					,"f_min=",f_min
					,"f_as=",f_as
					,"f_sel=",f_sel
					,"s_val=",s_val
					,"f_row=",f_row);
			}	
			
			if(f_as == AS_OP_EQ){
				this_assertion = A_Assertion_EQ(f_max, s_val);	
			}
			
			if(f_as == AS_OP_NOT){
				this_assertion = A_Assertion_NOT(f_max, s_val);
			}
			
			if(f_as == AS_OP_ABOVE){
				this_assertion = A_Assertion_ABOVE(f_max, s_val);
			}
			
			if(f_as == AS_OP_UNDER){
				this_assertion = A_Assertion_UNDER(f_max, s_val);
			}
			
			if(f_as == AS_OP_IN){
				this_assertion = A_Assertion_IN(f_max, f_min, s_val);
			}
			
			if(f_as == AS_OP_OUT){
				this_assertion = A_Assertion_OUT(f_max, f_min, s_val);
			}
			
			if(f_sel == SEL_OP_AND && (res_assertion || f_row == 0)){
				res_assertion = this_assertion;
				if(BP_SNP){
					BP(fn+".SEL_OP_AND"
						,	"this_assertion=",this_assertion
						,	"res_assertion=",res_assertion);
				}
			}
			
			if(f_sel == SEL_OP_OR && this_assertion && !res_assertion){
				res_assertion = this_assertion;
			}
		}
		
		if(!res_assertion){
			continue;
		}
		
		if(res_assertion){
			d_idx++;
			ArrayResize(d, (d_idx));
			ArrayCopy(d, s, (d_idx-1)*s_COLS, s_row*s_COLS, s_COLS);
		}
	}
	
}

//}

//{ === SORTING FUNCTIONS
void A_d_Sort2(double& a[][], string order = "0 <;"){
	/**
		\version	0.0.0.5
		\date		2013.11.05
		\author		Morochin <artamir> Artiom
		\details	Сортировка двумерного массива по заданной колонке
		\internal
			>Hist:					
					 @0.0.0.5@2013.11.05@artamir	[]	A_d_Select
					 @0.0.0.4@2013.06.12@artamir	[]	A_d_Select
					 @0.0.0.3@2013.05.20@artamir	[]	A_d_Select
					 @0.0.0.2@2013.05.20@artamir	[]	A_d_Select
					 @0.0.0.1@2013.05.17@artamir	[]	A_d_Select
			>Rev:0
			ордер может быть строкой формата "<номер колонки для сравнения><пробел><операция сравнения><точкасзапятой>"
			"5 >;" или "7 <=;"
			По умолчанию Сортировка 0-колонки по возрастанию
	*/
	string fn="A_d_Sort2";
	
	Ad_SortShell2(a,order);
	return;
	
	int ROWS = ArrayRange(a, 0);
	
	
	
	for(int i = 0; i < ROWS-1; i++){
		for(int j = i+1; j < ROWS; j++){
			if(BP_SRT){Print(fn+": ","order: "+order," i="+i, " j="+j);}
			if(!A_d_Compare(a, i,j,order)){
				if(BP_SRT){
					BP(fn+".!Compare"
						,	"i="		,i
						,	"j="		,j
						,	"order="	,order);
				}
				A_d_Swap2(a,i,j);}
		}
	}
}
//}

//{ === READING/WRITING FILE

void A_d_SaveToFile2(double &a[][], string fn, int d = 4){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.02.16
		>Hist:
			@0.0.2@2012.10.03@artamir	[]
			@0.0.1@2012.09.04@artamir	[]
		>Desc:
			Save array to filE_
			format string for store:
			@idx1_valIdx1@idx2_valIdx2@val_val
			
			exemple: a[43][5] = 20.77
			@idx1_43@idx2_5@val_20.77
		>VARS:
			a[][]	- array
			fn		- filename
			d		- количество знаков после запятой.
	*/	
	
	int ROWS = ArrayRange(a, 0);
	int COLS = ArrayRange(a, 1);
	
	int H = FileOpen(fn, FILE_CSV|FILE_WRITE);
	
	//------------------------------------------------------
	for(int idx1 = 0; idx1 < ROWS; idx1++){
		
		//--------------------------------------------------
		for(int idx2 = 0; idx2 < COLS; idx2++){
			
			//----------------------------------------------
			double val = a[idx1][idx2];
			
			//----------------------------------------------
			if(idx2 >= 11){
				
				//------------------------------------------
				if(val == 0.0){
					continue;
				}
			}
			
			//----------------------------------------------
			string str = "@idx1_"+idx1
						+"@idx2_"+idx2
						+"@val_"+DoubleToStr(a[idx1][idx2], d);
						
			//----------------------------------------------
			FileWrite(H, str);
		}
	}
	
	//------------------------------------------------------
	FileFlush(H);
	
	//------------------------------------------------------
	FileClose(H);
	
}

void A_d_ReadFromFile2(double &a[][], string fn){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.03
		>Hist:
			@0.0.2@2012.10.03@artamir	[]
			@0.0.1@2012.09.04@artamir	[]
		>Desc:
			Read array from filE_
			format string for read:
			@idx1_valIdx1@idx2_valIdx2@val_val
			
			exemple: a[43][5] = 20.77
			@idx1_43@idx2_5@val_20.77
		>VARS:
			a[][]	- array
			fn		- filename
	*/	
	
	//------------------------------------------------------
	ArrayResize(a, 0);
	
	//------------------------------------------------------
	int H = FileOpen(fn, FILE_CSV|FILE_READ);
	
	//------------------------------------------------------
	while(!FileIsEnding(H)){
		string	str	= FileReadString(H);
			int		idx1 	= Struc_KeyValue_int(	str, "@idx1_");
			int		idx2 	= Struc_KeyValue_int(	str, "@idx2_");
			double	val		= Struc_KeyValue_double(str, "@val_");
		
		//--------------------------------------------------
		int ROWS = ArrayRange(a, 0);
		
		//--------------------------------------------------
		if(idx1 >= ROWS){
			ArrayResize(a, idx1+1);
		}
		
		//--------------------------------------------------
		a[idx1][idx2] = val;
	}
}

//}

//{ === STRING ARRAY

//{ === COPY
void A_s_CopyCol2To1(string &s[][], string &d[], int col = 0){
	/**
		\version	0.0.0.0
		\date		2013.08.02
		\author		Morochin <artamir> Artiom
		\details	Выгружает колонку двумерного массива в одномерный
		\internal
			>Hist:
			>Rev:0
	*/

	int ROWS = ArrayRange(s,0);
	ArrayResize(d,0);
	ArrayResize(d,ROWS);
	
	for(int i=0; i<ROWS; i++){
		d[i] = s[i][col];
	}
}
//}


int A_s_MaxLen2(string &a[][], int col = -1){
	/**
		\version	0.0.0.0
		\date		2013.08.02
		\author		Morochin <artamir> Artiom
		\details	Поиск макс. длины строки в двумерном строковом массиве. по заданной колонке
					Если колонка  = -1, то поиск производится во всем массиве.
		\internal
			>Hist:
			>Rev:0
	*/

	int ROWS = ArrayRange(a,0);
	int COLS = ArrayRange(a,1);
	
	int start_col = 0;
	int end_col = COLS-1;
	
	int max_len = 0;
	
	if(col > -1){
		start_col = col;
		end_col = col;
	}
	
	for(int r=0; r<ROWS; r++){
		for(int c=start_col; c<=end_col; c++){
			max_len = MathMax(max_len, StringLen(a[r][c]));
		}
	}
	
	return(max_len);
}
//}

//{ === FOR DEBUGING
void A_d_PrintArray2(double &a[][], int d = 4, string fn = "PrintArray_"){
	/*
		>Ver	:	0.0.5
		>Date	:	2013.02.16
		>Hist:
			@0.0.3@2012.08.15@artamir	[]
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Printing array to filE_
		>VARS:
			&a[][]  :	array
			d		:	count of digits.
			fn		:	filename
	*/

	static int	i;
	
	i++;
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	int COLS = ArrayRange(a,1);
	
	//------------------------------------------------------
	fn = i+"_"+fn+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
		string s = "";
		for(int idx_2 = 0; idx_2 < COLS; idx_2++){
			s = StringConcatenate(s,"\t", "["+idx_1+"]["+idx_2+","+OE2Str(idx_2)+"]",DoubleToStr(a[idx_1][idx_2], d));
			//FileWrite(handle, idx_1, idx_2, DoubleToStr(a[idx_1][idx_2], d));
		}
		FileWrite(handle, s);
	}
	
	if(handle != 0) FileClose(handle);
	
}

void A_d_PrintArray1(double &a[], int d = 4, string fn = "PrintArray_"){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.15
		>Hist:
			@0.0.3@2012.08.15@artamir	[]
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Printing array to filE_
		>VARS:
			&a[][]  :	array
			d		:	count of digits.
			fn		:	filename
	*/

	static int	i;
	
	i++;
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	
	//------------------------------------------------------
	fn = fn+i+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
			FileWrite(handle, idx_1, DoubleToStr(a[idx_1], d));
	}
	
	if(handle != 0) FileClose(handle);
	
}

void A_i_PrintArray2(int &a[][], int d = 4, string fn = "PrintArray_"){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.08.29
		>Hist:	
				 @0.0.0.2@2013.08.29@artamir	[]	A_d_Select
			
		>Descr:
			Printing array to filE_
		>VARS:
			&a[][]  :	array
			d		:	count of digits.
			fn		:	filename
	*/

	static int	i;
	
	i++;
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	int COLS = ArrayRange(a,1);
	
	//------------------------------------------------------
	fn = i+"_"+fn+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
		string s = "";
		for(int idx_2 = 0; idx_2 < COLS; idx_2++){
			s = StringConcatenate(s,"\t", "["+idx_1+"]["+idx_2+"]",DoubleToStr(a[idx_1][idx_2], d));
			//FileWrite(handle, idx_1, idx_2, DoubleToStr(a[idx_1][idx_2], d));
		}
		FileWrite(handle, s);
	}
	
	if(handle != 0) FileClose(handle);
	
}

void A_i_PrintArray1(int &a[], int d = 4, string fn = "PrintArray_"){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.15
		>Hist:
			@0.0.3@2012.08.15@artamir	[]
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Printing array to filE_
		>VARS:
			&a[][]  :	array
			d		:	count of digits.
			fn		:	filename
	*/

	static int	i;
	
	i++;
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	
	//------------------------------------------------------
	fn = fn+i+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
			FileWrite(handle, idx_1, DoubleToStr(a[idx_1], d));
	}
	
	if(handle != 0) FileClose(handle);
	
}

void A_s_PrintArray1(string &a[], string fn = "PrintArray_"){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.15
		>Hist:
			@0.0.3@2012.08.15@artamir	[]
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Printing array to filE_
		>VARS:
			&a[][]  :	array
			d		:	count of digits.
			fn		:	filename
	*/

	static int	i;
	
	i++;
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	
	//------------------------------------------------------
	fn = fn+i+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
			FileWrite(handle, idx_1, a[idx_1]);
	}
	
	if(handle != 0) FileClose(handle);
	
}

void A_s_PrintArray2(string &a[][], string fn = "PrintArray_"){
	/**
		\version	0.0.0.1
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	Печатает двумерный строковой массив в файл.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.06@artamir	[+]	A_d_Select
			>Rev:0
	*/


	static int	i;
	
	i++;
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	int COLS = ArrayRange(a, 1);
	
	//------------------------------------------------------
	fn = fn+i+".arr";
	string s = "";
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	
	for(int idx_1=0; idx_1<ROWS; idx_1++){
		s="";
		for(int idx_2=0; idx_2<COLS; idx_2++){	
			s = StringConcatenate(s,"\t", "["+idx_1+"]["+idx_2+"]", a[idx_1][idx_2]);
		}	
		FileWrite(handle, idx_1, s);
	}
	
	if(handle != 0) FileClose(handle);
	
}
//}