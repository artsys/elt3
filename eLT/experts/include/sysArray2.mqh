/**
	\version	0.0.1.1
	\date		2013.12.17
	\author		Morochin <artamir> Artiom
	\details	Detailed description
	\internal
		>Hist:											
				 @0.0.1.1@2013.12.17@artamir	[]	Ad_CrossByIdx
				@0.0.1.0@2013.10.10@artamir	[-] ����������� ����������. -��������.
				 @0.0.0.10@2013.10.10@artamir	[*] Ad_CopyRow2To2	
				 @0.0.0.9@2013.10.07@artamir	[+]	As_addRow1
				 @0.0.0.8@2013.10.01@artamir	[!] Ad_Sum2	
				 @0.0.0.7@2013.10.01@artamir	[+]	Ad_addRow1
				 @0.0.0.6@2013.09.30@artamir	[+]	Ad_Sum
				 @0.0.0.5@2013.09.18@artamir	[+]	Ad_CrossByIdx
				 @0.0.0.4@2013.09.04@artamir	[*]	Ad_AddRow2
				 @0.0.0.3@2013.08.29@artamir	[+]	Ad_AddRow2	
				 @0.0.0.2@2013.08.29@artamir	[+]	
				 @0.0.0.1@2013.08.29@artamir	[+]	
		>Rev:0
*/

#define A_MODE_ASC	0
#define A_MODE_DESC	1

#define A_MODE_ADD	2	//����� ����������
#define A_MODE_REPL	3	//����� ���������

#define A_CROSS_NO	0	//����������� �� ����.
#define A_CROSS_UP	1	//������� ������ ���������� ��������� ����� �����.
#define A_CROSS_DW	2	//������� ������ ���������� ��������� ������ ����.

//{  === � ��������� ������.
//{ 	=== ��������� ������
int Ad_CopyCol2To1(double &s[][], double &d[], int col){
	/**
		\version	0.0.0.0
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	�������� ������� ���������� ������� � ����������.
		\internal
			��������.
			>Hist:
			>Rev:0
	*/

}

int Ad_AddRow2(double &a[][]){
	/**
		\version	0.0.0.2
		\date		2013.09.04
		\author		Morochin <artamir> Artiom
		\details	��������� ����� ������ � �������. ���������� ������ ����� ������
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.04@artamir	[*] ��������� ������ ������� ������ ��������.	
					 @0.0.0.1@2013.08.29@artamir	[+]	
			>Rev:0
	*/
	int ROWS = ArrayRange(a,0);
	ArrayResize(a,(ROWS+1));
	return(ArrayRange(a,0)-1);
}

int Ad_CopyRow2To2(	double &s[][]	/** ������ ��������*/
					,	double &d[][]	/** ������ ����������*/
					,	int sr=0 /** ������ ������ ������� ��������� */
					,	int dr=0 /** ������ ������ ������� ����������*/
					,	int from_col=0	/** ������ ������� ��������, � ������� ���������� ����������� ������ */
					,	int to_col=-1	/** ������ ������� ��������, � �������� ������������� ����������� ������ */
					,	int mode=2 /** ����� ����������� (�� ��������� ����������)*/){
	/**
		\version	0.0.0.2
		\date		2013.10.10
		\author		Morochin <artamir> Artiom
		\details	�������� ������ �� ������ ������� � ������. ���������� ������ ������ �� d
		\internal
			>Hist:		
					 @0.0.0.2@2013.10.10@artamir	[*] ��������� ����������� �������� �������� ���������� �������.	
					 @0.0.0.1@2013.08.29@artamir	[+]	
			>Rev:0
	*/

	int idx_d = dr;
	if(mode == A_MODE_ADD){
		idx_d = Ad_AddRow2(d);
	}
	
	int to=to_col;
	if(to<0){
		to=ArrayRange(s,1);
	}
	
	for(int c = from_col; c<to; c++){
		d[idx_d][c] = s[sr][c];
	}
	
	return(idx_d);
}

int Ad_CopyRow2To1(double &s[][], double &d[], int sr=0){
	/**
		\version	0.0.0.0
		\date		2013.11.04
		\author		Morochin <artamir> Artiom
		\details	�������� ������ �� ������� ��������� � ������ ��������.
		\internal
			>Hist:
			>Rev:0
	*/
	
	ArrayResize(d,ArrayRange(s,1));
	for(int i=0;i<ArrayRange(s,1);i++){
		d[i]=s[sr][i];
	}
}

int Ad_Copy1ToRow2(double &s[], double &d[][], int dr=0){
	/**
		\version	0.0.0.0
		\date		2013.11.04
		\author		Morochin <artamir> Artiom
		\details	�������� ������ �������� � ������ ������� ���������.
		\internal
			>Hist:
			>Rev:0
	*/

	for(int i=0; i<ArrayRange(d,1); i++){
		d[dr][i]=s[i];
	}
}

void Ad_Swap2(double &a[][], int i1, int i2){
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

}

#define A_ABOVE 0
#define A_EQ 1
#define A_UNDER 2

bool Ad_Compare21(double &a2[][], int i1, double &a1[], string compare = ""){
	/**
		\version	0.0.0.3
		\date		2013.10.24
		\author		Morochin <artamir> Artiom
		\details	��������� ���� ����� �������
		\internal
			>Hist:			
					 @0.0.0.3@2013.10.24@artamir	[!*]	��������� �� ���������� ��������
						������� � �������� ��������� �������� ������� ����:
						<����������������>[<����������������>]
						����������������:=<������������><������><�����������������><�������������>
						���� �������� �� ������� ������� �����, �� ��������� � ��������� ������� �� ������.
					 @0.0.0.1@2013.05.20@artamir	[+]	A_d_Compare
			>Rev:0
			compare ����� ���� ������� ������� "<����� ������� ��� ���������><������><�������� ���������><�������������>"
			"5 >;" ��� "7 <=;"
	*/

	string fn="A_d_Compare";	
	string subs[];
	ArrayResize(subs,0);
	int subs_ROWS = 0;
	StringToArray(subs, compare, ";");	//��������� �� ������ ���������� ��������� �.�. �� ��������: <������������><������><�����������������>
	subs_ROWS = ArrayRange(subs,0)-1;
	
	//A_s_PrintArray1(subs, "subs");
	
	for(int i = 0; i < subs_ROWS; i++){	//���� �� ���������� ������������ �������.
		string co[0];
		ArrayResize(co,0);
		int co_ROWS = 0;
		StringToArray(co, subs[i], " ");	
		co_ROWS = ArrayRange(co,0);	//���������� ����� ������� �������� ������� ��� ���������.
	
		if(co_ROWS > 0){
			int col = StrToInteger(co[0]);
			string op = co[1];
			
			int assertion;
			if(a2[i1,col]>a1[col]){assertion=A_ABOVE;}
			if(a2[i1,col]==a1[col]){assertion=A_EQ;}
			if(a2[i1,col]<a1[col]){assertion=A_UNDER;}
			if(BP_SRT){Print (fn+": col = "+col, " op = "+op, " assertion="+assertion, " subs_ROWS="+subs_ROWS);}
			if(assertion==A_ABOVE 	&& (op==">" ||op==">=")){return(true);}
			if(assertion==A_UNDER 	&& (op=="<" ||op=="<=")){return(true);}
			if(assertion==A_EQ){continue;}	//�������� ������� �����, �� �� ���� ���������� � ���������� ���������.
		}
	}
	return(false);
}


void Ad_QuickSort2(double &a[][], int idx_min=-1, int idx_max=-1, int col=0, int mode = 0){
	/**
		\version	0.0.0.1
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	�������� ���������� "������� ����������". �� ��������� ����������� 0-� �������
		�� �����������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.29@artamir	[+]	
			>Rev:0
	*/
	string fn="Ad_QuickSort2";
	if(ArrayRange(a,0)<2){
		string	order="";
				order=order+col+" ";
				if(mode==A_MODE_ASC)
					order=order+">;";
				else
					order=order+"<;";
		A_d_Sort2( a, order);
		return;}
	
	if(idx_min<0){idx_min=0;}
	if(idx_max<0){idx_max=ArrayRange(a,0)-1;}
	
	int i=idx_min, j=idx_max;
	int idx_pivot = MathRound((i+j)/2);
	double pivot_value = (a[i][col]+a[j][col]+a[idx_pivot][col])/3; //����������� �������� �������, ���������� � �������� �������� �������. 
	while(i<j){
		if(mode == A_MODE_ASC){
			while(a[i][col]<pivot_value){i++;}
			while(a[j][col]>pivot_value){j--;}
		}
		if(mode == A_MODE_DESC){
			while(a[i][col]>pivot_value){i++;}
			while(a[j][col]<pivot_value){j--;}
		}
		if(i<j){Ad_Swap2(a, i,j);i++;j--;}
	}
	if(i<idx_max){Ad_QuickSort2(a,i,idx_max,col, mode);}
	if(idx_min<j){Ad_QuickSort2(a,idx_min,j,col, mode);}
}	

void Ad_SortShell2(double &a[][], string order="0 >;"){
	/**
		\version	0.0.0.0
		\date		2013.11.04
		\author		Morochin <artamir> Artiom
		\details	���������� ������� �����
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="Ad_SortShell2";
	//Print(fn);
	int size=ArrayRange(a,0);
	int gap=size/2;
	while(gap>0){
		for(int i=gap; i<size; i++){
			double t[];
			Ad_CopyRow2To1(a,t,i);
			for(int j=i-gap;(j>=0)&&!Ad_Compare21(a, j, t, order); j-=gap){
				Ad_Swap2(a,j+gap,j);
			}
			Ad_Copy1ToRow2(t,a,j+gap);
			
		}
		gap=gap/2;
	}
}

int Ad_Select2(double &s[][], double &d[][], bool add_rows=false){
	/**
		\version	0.0.0.0
		\date		2013.11.05
		\author		Morochin <artamir> Artiom
		\details	������� �� ������� ��������� ������� ��������� �������
		\internal
			>Hist:
			>Rev:0
	*/

	//���������� ������ ������ �������� ���.
	
}

double Ad_Sum2(double &a[][], int col=0){
	/**
		\version	0.0.0.2
		\date		2013.10.01
		\author		Morochin <artamir> Artiom
		\details	���������� ����� ��������� �������� ������� �������.
		\internal
			>Hist:		
					 @0.0.0.2@2013.10.01@artamir	[!] ���������� �������� Ad_Sum => Ad_Sum2	
					 @0.0.0.1@2013.09.30@artamir	[+]	Ad_Sum
			>Rev:0
	*/

	int rows = ArrayRange(a,0);
	double sum = 0;
	for(int i=0; i<rows; i++){
		sum=sum+a[i][col];
	}
	
	return(sum);
}
//..	=== ���������� ������

int Ad_addRow1(double &a[]){
	/**
		\version	0.0.0.1
		\date		2013.10.01
		\author		Morochin <artamir> Artiom
		\details	�������� ����������� ������� �� +1. ���������� ������ ���������� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.10.01@artamir	[+]
			>Rev:0
	*/

	int rows=ArrayRange(a,0)+1;
			 ArrayResize(a,rows);
			 
	return(rows-1);		 
}

void Ad_Copy1To1(double &s[], double &d[]){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	�������� ������ s � ������ d
		\internal
			>Hist:
			>Rev:0
	*/

	ArrayResize(d, ArrayRange(s,0));
	ArrayCopy(d, s);
}

void Ad_Swap1(double &a[], int i, int j){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	������ ������� ��� �������� �������.
		\internal
			>Hist:
			>Rev:0
	*/
	if(i==j){return;}
	double tmp = a[i];
	a[i]=a[j];
	a[j]=tmp;
}

void Ad_QuickSort1(double &a[], int idx_min=-1, int idx_max=-1, int mode = 0){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	�������� "������� ����������" ��� ����������� �������
		\internal
			>Hist:
			>Rev:0
	*/

	int ROWS = ArrayRange(a,0);
	if(ROWS <= 2){
		return;
	}
	
	if(idx_min < 0){idx_min=0;}
	if(idx_max < 0){idx_max=ArrayRange(a,0)-1;}
	
	int i=idx_min, j=idx_max;
	int idx_pivot = MathRound((i+j)/2);
	double pivot_value = (a[i]+a[j]+a[idx_pivot])/3; //����������� �������� �������, ���������� � �������� �������� �������. 
	
	while(i<j){
		if(mode == A_MODE_ASC){
			while(a[i]<pivot_value){i++;}
			while(a[j]>pivot_value){j--;}
		}
		
		if(mode == A_MODE_DESC){
			while(a[i]>pivot_value){i++;}
			while(a[j]<pivot_value){j--;}
		}
		if(i<j){Ad_Swap1(a, i,j);i++;j--;}
	}
	if(i<idx_max){Ad_QuickSort1(a,i,idx_max);}
	if(idx_min<j){Ad_QuickSort1(a,idx_min,j);}
}

void Ad_Collapse1(double &a[]){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	������������ ����������� �������.
		\internal
			>Hist:
			>Rev:0
	*/

	int ROWS = ArrayRange(a,0);
	Ad_QuickSort1(a);
	
	double tmp=a[0],d[1];
	d[0]=tmp;
	for(int i=1; i<ROWS; i++){
		if(a[i] != tmp){
			ArrayResize(d,(ArrayRange(d,0)+1));
			d[(ArrayRange(d,0)-1)]=a[i];
			tmp = a[i];
		}
	}
	
	Ad_Copy1To1(d,a);
}

int Ad_CrossByIdx(double &f[], double &s[], int idx){
	/**
		\version	0.0.0.1
		\date		2013.09.18
		\author		Morochin <artamir> Artiom
		\details	���������, ���� �� ����������� �� �������� ������� ���� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.18@artamir	[]	Ad_CrossByIdx
			>Rev:0
	*/
	
	string fn = "Ad_CrossByIdx";
	
	if(ArrayRange(f,0)<=0){return(A_CROSS_NO);}
	if(ArrayRange(s,0)<=0){return(A_CROSS_NO);}
	
	
	double f2=Norm_symb(f[idx],"",2),		s2=Norm_symb(s[idx],"",2);
	
	double f1=Norm_symb(f[idx-1],"",2),	s1=Norm_symb(s[idx-1],"",2);
	
	double f3=Norm_symb(f[idx+1],"",2), 	s3=Norm_symb(s[idx+1],"",2);
	
	if(f2>s2){if(s1>f1){return(A_CROSS_UP);}}
	
	if(f2<s2){if(s1<f1){return(A_CROSS_DW);}}
	
	if(f2==s2){
		if(f1<s1 && f3>s3){return(A_CROSS_UP);}
		if(f1>s1 && f3<s3){return(A_CROSS_DW);}
	}
	
	return(A_CROSS_NO);
}
//}

//.. === ���������
//{		=== ��������� ������
void As_PrintArray2(string &a[][], string fn = "PrintArray_"){
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
			s = StringConcatenate(s,"\t", "["+idx_1+"]["+idx_2+","+idx_2+"]",a[idx_1][idx_2]);
			//FileWrite(handle, idx_1, idx_2, DoubleToStr(a[idx_1][idx_2], d));
		}
		FileWrite(handle, s);
	}
	
	if(handle != 0) FileClose(handle);
	
}

//..	=== ���������� ������
int As_addRow1(string &a[], string val=""){
	/**
		\version	0.0.0.2
		\date		2013.12.17
		\author		Morochin <artamir> Artiom
		\details	�������� ����������� ������� �� +1. ���������� ������ ���������� ��������.
					����������� ������ �������� �������� ���������� � ��������� val.
		\internal
			>Hist:			
					 @0.0.0.2@2013.12.17@artamir	[*]	���������� �������� �� ���������.
					 @0.0.0.1@2013.10.07@artamir	[+]	As_addRow1
			>Rev:0
	*/

	int rows=ArrayRange(a,0)+1;
		ArrayResize(a,rows);
		a[(rows-1)]=val;	 
	return(rows-1);		 
}

int As_findIndexByVal(string &a[], string val=""){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.08.29
		>Hist	:	
					@0.0.0.2@2013.08.29@artamir	[]	TMR_findIndexByName
			@0.0.1@2012.10.08@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(a,0);
	
	//------------------------------------------------------
	int		idx = -1;
	bool	isFind = false;
	
	//------------------------------------------------------
	for(int i=0; i<ROWS && !isFind;i++){
		
		//--------------------------------------------------
		string el = a[i];
		
		//--------------------------------------------------
		if(el == val){
			isFind = true;
			idx = i;
		}
	}
	
	//------------------------------------------------------
	return(idx);
}
//}
//}	