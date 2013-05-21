	/*
		>Ver	:	0.0.0.41
		>Date	:	2013.05.20
		>Hist	:																										
					@0.0.0.41@2013.05.20@artamir	[]	A_d_Compare
					@0.0.0.40@2013.05.20@artamir	[]	A_d_Select
					@0.0.0.39@2013.05.20@artamir	[]	A_d_Compare
					@0.0.0.38@2013.05.20@artamir	[]	A_d_Select
					@0.0.0.37@2013.05.17@artamir	[+]	A_d_Swap2
					@0.0.0.36@2013.05.17@artamir	[+]	A_d_Sort2
					@0.0.0.35@2013.05.17@artamir	[]	A_d_Select
					@0.0.0.34@2013.05.17@artamir	[]	A_d_releaseArray
					@0.0.33@2013.03.06@artamir	[]	A_Assertion_UNDER
					@0.0.32@2013.03.06@artamir	[]	A_Assertion_UNDER
					@0.0.31@2013.02.23@artamir	[]	A_d_setPropByIndex
					@0.0.30@2013.02.22@artamir	[]	A_d_Select
					@0.0.29@2013.02.21@artamir	[]	A_d_Select
					@0.0.28@2013.02.20@artamir	[]	A_d_Select	-	���������� ������ � ��������.
					@0.0.27@2013.02.20@artamir	[]	A_FilterAdd_AND
					@0.0.25@2013.02.20@artamir	[*] �������� ��������� ������� �������	
					@0.0.24@2013.02.19@artamir	[]	A_d_Select
					@0.0.23@2013.02.19@artamir	[]	A_Assertion_OUT
					@0.0.22@2013.02.19@artamir	[]	A_Assertion_IN
					@0.0.21@2013.02.19@artamir	[]	A_Assertion_NOT
					@0.0.20@2013.02.19@artamir	[]	A_Assertion_EQ
					@0.0.19@2013.02.18@artamir	[]	A_d_Select
					@0.0.18@2013.02.16@artamir	[]	A_FilterAdd_OR
					@0.0.17@2013.02.16@artamir	[]	A_FilterAdd_OR
					@0.0.16@2013.02.16@artamir	[]	A_FilterAdd_OR
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	function to work with arrays
		>Pref	:	A
				:	d - for double arrays
	*/

#define ARRVER	"0.0.0.41_2013.05.17"
	
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
	
	//------------------------------------------------------
	if(Debug){
		//A_d_PrintArray1(dArrayTemp2, 4, fn);
	}	
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
	
	//double dTemp[];
	//ArrayCopy(dTemp, dArrayTemp2, 0, 0, WHOLE_ARRAY);
	//------------------------------------------------------
	A_d_eraseArray2(dArrayTemp2);
	
	//------------------------------------------------------
	if(Debug){
		//A_d_PrintArray2(d, 4, fn);
		//A_d_PrintArray1(dTemp, 4, fn);
	}
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
		\details	������ ������� ������ ���������� �������
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
	
	if(Debug && BP_Array_Sort){
		BP("SWAP", "i1 = ",i1, "i2 = ",i2);
	}

}

bool A_d_Compare(double &a[][], int i1, int i2, string compare = ""){
	/**
		\version	0.0.0.2
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	��������� ���� ����� �������
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.20@artamir	[]	A_d_Compare
					 @0.0.0.1@2013.05.20@artamir	[]	A_d_Compare
			>Rev:0
			compare ����� ���� ������� ������� "<����� ������� ��� ���������><������><�������� ���������><�������������>"
			"5 >;" ��� "7 <=;"
	*/

	string subs[];
	ArrayResize(subs,0);
	int subs_ROWS = 0;
	StringToArray(subs, compare, ";");
	subs_ROWS = ArrayRange(subs,0);
	
	//A_s_PrintArray1(subs, "subs");
	
	for(int i = 0; i < subs_ROWS; i++){
		string co[0];
		ArrayResize(co,0);
		int co_ROWS = 0;
		StringToArray(co, subs[i], " ");
		co_ROWS = ArrayRange(co,0);
	
		if(co_ROWS > 0){
			int col = StrToInteger(co[0]);
			string op = co[1];
			//Print ("col = ",col, " op = ",op);
			if(op == ">"){
				if(a[i1][col] > a[i2][col]){ 
					return(true);
				}else{
					return(false);
				}	
			}
			
			if(op == "<"){
				if(a[i1][col] < a[i2][col]){
					return(true);
				}else{
					return(false);
				}	
			}
		}
	}	
}
//}

//{ === SELECT FUNCTIONS	============================

#define SEL_OP_AND	1										/*Operation AND*/

#define SEL_OP_OR	2										//Openration OR

#define AS_OP_EQ	1										// �������� ��������� �� ��������� �������� ���� �������
#define AS_OP_NOT	2										// �������� ��������� �� �� ��������� �������� ���� �������
#define AS_OP_ABOVE	5										// ������ ��������� ��������
#define AS_OP_UNDER	6										// ������ ��������� ��������
#define AS_OP_IN	3										// �������� ��������� �� ��������� � ��������
#define AS_OP_OUT	4										// �������� ������� ��� ���������

//===	Filter array cols

#define F_COL		0										/*������� �������*/
#define F_MAX		1										//����. �������� �������
#define F_MIN		2										//���. �������� �������
#define F_SEL_OP		3										//�������� ����������� ������� (or and)
#define F_AS_OP		4										//�������� �������� �������� ������.
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

int A_FilterAdd_AND(int COL, int MAX = 0, int MIN = 0, int as.OP = 3){
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

int A_FilterAdd_OR(int COL, int MAX = 0, int MIN = 0, int as.OP = 3){
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
		return(True);
	}
	
	return(False);
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


int A_d_Select(double &s[][] /*source array*/, double &d[][] /*destination array*/){
	/*
		>Ver	:	0.0.5
		>Date	:	2013.02.22
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
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
	
	ArrayResize(d,0);
	ArrayResize(f,0);
	int d_idx = 0;
	
	ArrayCopy(f, A_Filter, 0, 0, WHOLE_ARRAY);
	s_ROWS = ArrayRange(s,0);
	s_COLS = ArrayRange(s,1);
	f_ROWS = ArrayRange(f,0);
	
	for(s_row = 0; s_row < s_ROWS; s_row++){
		
		f_max = 0;	f_min = 0; 
		f_as = 0;	f_sel = 0;
		
		s_val = 0;
		
		res_assertion = false;
		this_assertion = false;
		
		if(Debug && BP_Array){
			BP("Select", "f_ROWS = ",f_ROWS);
		}	
		
		//--- ���� �� ������� �������-���������
		//--------------------------------------------------
		
		for(f_row = 0; f_row < f_ROWS; f_row++){
			//--- ���� �� ������� �������-�������
			//----------------------------------------------
			s_col = f[f_row][F_COL];
			f_max = f[f_row][F_MAX];
			f_min = f[f_row][F_MIN];
			f_as = f[f_row][F_AS_OP];
			f_sel = f[f_row][F_SEL_OP];
			
			s_val = s[s_row][s_col];
			
			if(Debug && BP_Condition_select){
				BP("SELECT", "f_as = ", f_as
							, "f_max = ", f_max
							, "f_min = ", f_min
							, "f_sel = ", f_sel
							, "s_val = ", s_val);
			}
			
			if(f_as == AS_OP_EQ){
				this_assertion = A_Assertion_EQ(f_max, s_val);
				
				if(Debug && BP_Array){
					BP("A_d_Select", "this_assertion = ", this_assertion);
				}	
			}
			
			if(f_as == AS_OP_NOT){
				this_assertion = A_Assertion_NOT(f_max, s_val);
			}
			
			if(f_as == AS_OP_ABOVE){
				this_assertion = A_Assertion_ABOVE(f_max, s_val);
			}
			
			if(f_as == AS_OP_UNDER){
				this_assertion = A_Assertion_ABOVE(f_max, s_val);
			}
			
			if(f_as == AS_OP_IN){
				this_assertion = A_Assertion_IN(f_max, f_min, s_val);
			}
			
			if(f_as == AS_OP_OUT){
				this_assertion = A_Assertion_OUT(f_max, f_min, s_val);
			}
			
			if(f_sel == SEL_OP_AND && (res_assertion || f_row == 0)){
				res_assertion = this_assertion;
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
void A_d_Sort2(double& a[][], int col, string order = ""){
	/**
		\version	0.0.0.3
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	������� ���������� ���������� ������� �� �������� �������
		\internal
			>Hist:			
					 @0.0.0.3@2013.05.20@artamir	[]	A_d_Select
					 @0.0.0.2@2013.05.20@artamir	[]	A_d_Select
					 @0.0.0.1@2013.05.17@artamir	[]	A_d_Select
			>Rev:0
			����� ����� ���� ������� ������� "<����� ������� ��� ���������><������><�������� ���������><�������������>"
			"5 >;" ��� "7 <=;"
	*/

	int ROWS = ArrayRange(a, 0);
	
	for(int i = 0; i < ROWS; i++){
		for(int j = 1; j < ROWS; j++){
			
			if(!A_d_Compare(a, i,j,order)){A_d_Swap2(a,i,j);}
			//if(a[i][col] > a[j][col]){A_d_Swap2(a,i,j);}
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
			d		- ���������� ������ ����� �������.
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
			s = StringConcatenate(s,"\t", "["+idx_1+"]["+idx_2+"]",DoubleToStr(a[idx_1][idx_2], d));
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

//}