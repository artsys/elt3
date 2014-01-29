	/**
		\version	0.0.0.9
		\date		2014.01.28
		\author		Morochin <artamir> Artiom
		\details	������ � ��������������� ��������.
		\internal
			>Hist:									
					 @0.0.0.9@2014.01.28@artamir	[+]	AI_Union
					 @0.0.0.8@2014.01.13@artamir	[+]	AId_SearchLess
					 @0.0.0.7@2014.01.13@artamir	[+]	AId_Sum
					 @0.0.0.6@2014.01.09@artamir	[]	AId_SearchFirst
					 @0.0.0.5@2014.01.09@artamir	[]	AId_SearchLast
					 @0.0.0.4@2013.12.13@artamir	[]	AId_SearchFirst
					 @0.0.0.3@2013.11.07@artamir	[+]	AId_SearchFirst
					 @0.0.0.2@2013.11.06@artamir	[+]	AId_Swap
					 @0.0.0.1@2013.11.06@artamir	[+]	AId_Init2
			>Rev:0
			>Desc: ����� ������� ����� ���� �������� (����������, �������)
			���������� ������������������� ����� ��������.
	*/

//int AI_idx[];
int maxQScount=0;

void AId_Init2(double &a[][], int &aI[]){
	/**
		\version	0.0.0.1
		\date		2013.11.06
		\author		Morochin <artamir> Artiom
		\details	������������� ������� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.11.06@artamir	[+]	
			>Rev:0
	*/

	ArrayResize(aI,ArrayRange(a,0));
	for(int i=0; i<ArrayRange(a,0);i++){
		aI[i]=i;
	}
}

void AI_SetIndex(int &sI[], int &dI[]){
	/**
		\version	0.0.0.0
		\date		2013.11.08
		\author		Morochin <artamir> Artiom
		\details	��������� � ���� ��������� ������� ����������� �������.
		\internal
			>Hist:
			>Rev:0
	*/
	ArrayResize(dI,ArrayRange(sI,0));
	ArrayCopy(dI,sI);
}

int AI_Union(int &s1[], int &s2[], int &d[]){
	/**
		\version	0.0.0.1
		\date		2014.01.28
		\author		Morochin <artamir> Artiom
		\details	���������� ������� �������� � �������������� ������.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.28@artamir	[+]	AI_Union
			>Rev:0
	*/

	string fn="AI_Union";
	
	rows_d=ArrayRange(d,0);
	rows_s1=ArrayRange(s1,0);
	rows_s2=ArrayRange(s2,0);
	
	rows_total=rows_d+rows_s1+rows_s2;
	ArrayResize(d,rows_total);
	
	for(int i=0;i<rows_s1;i++){
		d[(rows_d+i)]=s1[i];
	}
	
	for(i=0;i<rows_s2;i++){
		d[(rows_d+rows_s1+i)]=s2[i];
	}
	
	return(rows_total);
}

// void AI_ReturnIndexArray(int &d[]){
	// /**
		// \version	0.0.0.0
		// \date		2013.11.07
		// \author		Morochin <artamir> Artiom
		// \details	������� ����� ���������� �������.
		// \internal
			// >Hist:
			// >Rev:0
	// */
	// ArrayResize(d,ArrayRange(AI_idx,0));
	// ArrayCopy(d,AI_idx);
// }

void AI_IndexSetInterval(int &aI[], int first=-2, int last=-2){
	/*
		\version	0.0.0.0
		\date		2013.11.07
		\author		Morochin <artamir> Artiom
		\details	�������� �������� ������ �� ��������� ���������.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="AI_IndexSetInterval";
	if(BP_SRT){
		Print(fn);
	}
	if(first==-1||last==-1){
		ArrayResize(aI,0);
		return;
	}
	
	if(last==-2){
		last=ArrayRange(aI,0)-1;
	}
	
	if(first==-2){
		first=0;
	}
	
	int temp[];
	ArrayResize(temp,last-first+1);
	for(int i=0;i<=last-first; i++){
		temp[i]=aI[i+first];
	}
	ArrayResize(aI,ArrayRange(temp,0));
	ArrayCopy(aI,temp);
}

void AId_Swap(int &aI[], int i, int j){
	/**
		\version	0.0.0.1
		\date		2013.11.06
		\author		Morochin <artamir> Artiom
		\details	������ ������� ��� �������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.11.06@artamir	[+]	AId_Swap
			>Rev:0
	*/
	
	int t=aI[i];
	aI[i]=aI[j];
	aI[j]=t;
}

void AI_PrintIndex(int &aI[], string fn="AI_PrintIndex"){
	
	string s=fn+": indexes: ";
	for(int i=0; i<ArrayRange(aI,0);i++){
		s=s+" "+aI[i];
	}
	Print(s);
}

double AId_Sum(double &a[][], int &aI[], int col=0){
	/**
		\version	0.0.0.1
		\date		2014.01.13
		\author		Morochin <artamir> Artiom
		\details	���������� ����� �� �������� ������� � ������ ������� ��������.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.13@artamir	[]	AId_Sum
			>Rev:0
	*/
	
	string fn="AId_Sum";
	double res=0;
	
	int rows=ArrayRange(aI,0);
	for(int i=0;i<rows;i++){
		res=res+a[aI[i]][col];
	}
	
	return(res);
}

#define AI_ABOVE	0
#define AI_EQ		1
#define AI_UNDER	2

bool AId_Compare(double &a[][], int i1, int i2, string compare = ""){
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
			if(a[i1,col]>a[i2,col]){assertion=AI_ABOVE;}
			if(a[i1,col]==a[i2,col]){assertion=AI_EQ;}
			if(a[i1,col]<a[i2,col]){assertion=AI_UNDER;}
			//if(BP_SRT){Print (fn+": col = "+col, " op = "+op, " assertion="+assertion, " subs_ROWS="+subs_ROWS);}
			if(assertion==AI_ABOVE 	&& (op==">" ||op==">=")){return(true);}
			if(assertion==AI_UNDER 	&& (op=="<" ||op=="<=")){return(true);}
			if(assertion==AI_EQ){continue;}	//�������� ������� �����, �� �� ���� ���������� � ���������� ���������.
		}
	}
	return(false);
}

void AId_SortShell2(double &a[][], int &aI[], string order="0 >;"){
	/**
		\version	0.0.0.0
		\date		2013.11.04
		\author		Morochin <artamir> Artiom
		\details	���������� ������� �����
		�� ������ ����� ��������������� ������� ����� �������.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="AId_SortShell2";
	int size=ArrayRange(a,0);
	int gap=size/2;
	while(gap>0){
		for(int i=gap; i<size; i++){
			int t=aI[i];
			int last_pos=i;
			for(int j=i-gap;(j>=0); j-=gap){
				
				bool res=AId_Compare(a, aI[j], t, order);
				if(res) continue;
				AId_Swap(aI, last_pos,j);
				last_pos=j;
			}
		}
		gap=MathFloor(gap/2);
	}
}

void AId_SortBubble2(double &a[][], int &aI[], string order="0 >;"){
	for(int i=0; i<ArrayRange(aI,0)-1; i++){
		for(int j=i+1; j<ArrayRange(aI,0); j++){
			if(!AId_Compare(a, aI[i], aI[j], order)){AId_Swap(aI,i,j);}
		}
	}
}

bool isNewQS=true;
void AId_QuickSort2(double &a[][], int &aI[], int idx_min=-1, int idx_max=-1, int col=0, int mode=0){
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
	static int count;
	if(isNewQS)count=0;
	count++;
	maxQScount=MathMax(maxQScount,count);
	string fn="Ad_QuickSort2";
	
	if(ArrayRange(aI,0)<2){
		// string	order="";
				// order=order+col+" ";
				// if(mode==A_MODE_ASC)
					// order=order+">;";
				// else
					// order=order+"<;";
		// AId_SortShell2(a, aI, order);
		
		return;
	}
	
	if(idx_min<0){idx_min=0;}
	if(idx_max<0){idx_max=ArrayRange(aI,0)-1;}
	
	int i=idx_min, j=idx_max;
	int idx_pivot = MathRound((i+j)/2);
	double pivot_value = (a[aI[i]][col]+a[aI[j]][col]+a[aI[idx_pivot]][col])/3; //����������� �������� �������, ���������� � �������� �������� �������. 
	while(i<j){
		if(mode == A_MODE_ASC){
			while(a[aI[i]][col]<pivot_value){i++;}
			while(a[aI[j]][col]>pivot_value){j--;}
		}
		if(mode == A_MODE_DESC){
			while(a[aI[i]][col]>pivot_value){i++;}
			while(a[aI[j]][col]<pivot_value){j--;}
		}
		if(i<j){
			AId_Swap(aI, i,j);i++;j--;
		}
	}
	isNewQS=false;
	if(i<idx_max){AId_QuickSort2(a,aI,i,idx_max,col, mode);}
	isNewQS=true;
	isNewQS=false;
	if(idx_min<j){AId_QuickSort2(a,aI,idx_min,j,col, mode);}
	isNewQS=true;
	
	
}

//------------------------------------------------------------------------
#define AI_SEL_OP_AND	1										//{ //Operation AND 
#define AI_SEL_OP_OR	2										//} //Operation OR		

#define AI_AS_OP_EQ		1										//{ // �������� ��������� �� ��������� �������� ���� �������
#define AI_AS_OP_NOT	2										// �������� ��������� �� �� ��������� �������� ���� �������
#define AI_AS_OP_ABOVE	5										// ������ ��������� ��������
#define AI_AS_OP_GREAT 	5
#define AI_AS_OP_UNDER	6										// ������ ��������� ��������
#define AI_AS_OP_LESS	6
#define AI_AS_OP_IN		3										// �������� ��������� �� ��������� � �������� ������� �������.
#define AI_AS_OP_OUT	4										//} // �������� ������� ��� ���������

//===	Filter array cols
#define AIF_COL		0										//{ //������� �������
#define AIF_MIN		1										//���. �������� �������
#define AIF_MAX		2										//����. �������� �������
#define AIF_SEL_OP	3										//�������� ����������� ������� (or and)
#define AIF_AS_OP	4										//} //�������� �������� �������� ������.
#define AIF_TOT		5

double	AId_Filter[][AIF_TOT];

int AId_eraseFilter(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.05
		>Hist	:
			@0.0.1@2012.10.05@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	ArrayResize(AId_Filter, 0);
	
	//------------------------------------------------------
	return(0);
}

int AId_FilterAdd(int COL, double MIN, double MAX, int as_OP, int sel_OP){
	/**
		\version	0.0.0.0
		\date		2013.11.11
		\author		Morochin <artamir> Artiom
		\details	��������� �������� ������� � ����� ������.
		\internal
			>Hist:
			>Rev:0
	*/
	
	//------------------------------------------------------
	int idx = Ad_AddRow2(AId_Filter);
	
	//------------------------------------------------------
	AId_Filter[idx][AIF_COL]=COL;
	AId_Filter[idx][AIF_MIN]=MIN;
	AId_Filter[idx][AIF_MAX]=MAX;
	AId_Filter[idx][AIF_SEL_OP]=sel_OP;
	AId_Filter[idx][AIF_AS_OP]=as_OP;
	
	//------------------------------------------------------
	return(idx);

}

int AId_FilterAdd_AND(int COL, double MIN = 0, double MAX = 0, int as_OP = 3, bool erase=false){
	/**
		\version	0.0.0.0
		\date		2013.11.11
		\author		Morochin <artamir> Artiom
		\details	��������� ����� ������ ������� � ��������������� ��������� �������-�������.
		\internal
			>Hist:
			>Rev:0
	*/
	if(erase)AId_eraseFilter();
	
	//--------------------------------------
	return(AId_FilterAdd(COL,MIN,MAX,as_OP, AI_SEL_OP_AND));
}

int AId_FilterAdd_OR(int COL, double MIN = 0, double MAX = 0, int as_OP = 3, bool erase=false){
	/**
		\version	0.0.0.0
		\date		2013.11.11
		\author		Morochin <artamir> Artiom
		\details	��������� ����� ������ ������� � ��������������� ��������� �������-�������.
		\internal
			>Hist:
			>Rev:0
	*/
	if(erase)AId_eraseFilter();
	
	//--------------------------------------
	return(AId_FilterAdd(COL,MIN,MAX,as_OP, AI_SEL_OP_OR));
}


//------------------------------------------------------------------------
int AId_QuickSearch(double &a[][], int &aI[], int col, double element){
	/**
		\version	0.0.0.1
		\date		2013.11.07
		\author		Morochin <artamir> Artiom
		\details	���������� ����� ������� ���������� � �������� ���������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.11.07@artamir	[]	AId_SearchFirst
			>Rev:0
	*/
	
   int    i,j,size,m=-1;
   double t_double;
//--- search
	size=ArrayRange(aI,0);
	if(size==1){
		if(a[aI[0]][col]==element){
			return(0);
		}else{
			return(-1);
		}
	}
	
   i=0;
   j=size-1;
   
   while(j>=i)
     {
      //--- ">>1" is quick division by 2
      m=(j+i)>>1;
      if(m<0 || m>=size)
         break;
      t_double=a[aI[m]][col];
      //--- compare with delta
      if(MathAbs(t_double-element)<=0)
         break;
      if(t_double>element)
         j=m-1;
      else
         i=m+1;
     }
//--- position
   return(m);
}

int AId_SearchFirst(double &a[][], int &aI[], int col, double element){
	/**
		\version	0.0.0.3
		\date		2014.01.09
		\author		Morochin <artamir> Artiom
		\details	���������� ����� ������� ���������� � �������� ���������.
		\internal
			>Hist:			
					 @0.0.0.3@2014.01.09@artamir	[]	AId_SearchFirst
					 @0.0.0.2@2013.12.13@artamir	[]	AId_SearchFirst
					 @0.0.0.1@2013.11.07@artamir	[]	AId_SearchFirst
			>Rev:0
	*/
	string fn="AId_SearchFirst";
	
	int pos;
//--- check
	if(ArrayRange(aI,0)==0) return(-1);
   
	if(ArrayRange(aI,0)==1){
		if(a[aI[0]][col]==element){
			return(0);
		}else{
			return(-1);
		}
	}
//--- search
	pos=AId_QuickSearch(a, aI, col, element);
	if(BP_SRT){
		Print(fn,".pos=",pos);
		Print(fn,".a[",aI[pos],"][",col,"]=",a[aI[pos]][col],"; .element=",element);
	}
	if(a[aI[pos]][col]>=element){
		//--- compare with delta
		while(MathAbs(a[aI[pos]][col]-element)<=0){
			pos--;
			if(pos==-1)
				break;
		}	
		return(pos+1);
	}
//--- not found
   return(-1);
}

int AId_SearchLast(double &a[][], int &aI[], int col, double element){
	/**
		\version	0.0.0.2
		\date		2014.01.09
		\author		Morochin <artamir> Artiom
		\details	���������� ����� ������� ���������� � �������� ���������.
		\internal
			>Hist:		
					 @0.0.0.2@2014.01.09@artamir	[]	AId_SearchLast
					 @0.0.0.1@2013.11.07@artamir	[]	AId_SearchFirst
			>Rev:0
	*/
	int pos;
//--- check
   if(ArrayRange(aI,0)==0)
      return(-1);
	  
	if(ArrayRange(aI,0)==1){
		if(a[aI[0]][col]==element){
			return(0);
		}else{
			return(-1);
		}
	}  
//--- search
   pos=AId_QuickSearch(a, aI, col, element);
   if(a[aI[pos]][col]==element)
     {
      //--- compare with delta
		while(MathAbs(a[aI[pos]][col]-element)<=0){
			pos++;
			if(pos==ArrayRange(aI,0))
				break;
		}	
      return(pos-1);
     }
//--- not found
   return(-1);
}

int AId_SearchGreat(double &a[][], int &aI[], int col, double element){
	/**
		\version	0.0.0.0
		\date		2013.12.18
		\author		Morochin <artamir> Artiom
		\details	����� � ��������������� ������� ���������� �������� ��������.
		���������� � ����������� ���������� � ������� aI[]
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="AId_SearchGreat";
	
	int l=0;
	int r=ArrayRange(aI,0)-1;
	
	while(l!=r){
		int m=(l+r)/2;
		if(a[aI[m]][col]<=element){
			l=m+1;
		}else{
			r=m;
		}
	}
	
	if(a[aI[l]][col]<=element){
		return(-1);
	}
	
	while(a[aI[r]][col]>element && r>=l){
		r--;
	}
	
	r++;
	
	return(r);
}

int AId_SearchLess(double &a[][], int &aI[], int col, double element){
	/**
		\version	0.0.0.1
		\date		2014.01.13
		\author		Morochin <artamir> Artiom
		\details	����� � ��������������� ������� ���������� �������� ��������.
		���������� � ����������� ���������� � ������� aI[]
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.13@artamir	[+]	AId_SearchLess
			>Rev:0
	*/
	string fn="AId_SearchLess";
	
	int l=0;
	int size=ArrayRange(aI,0)-1;
	int r=size;
	int m=-1;
	
	if(BP_SEL){
		Print(fn);
		Print(fn,".l="+l,"; .r="+r);
		Print(fn,".while()");
	}
	
	while(l<=r){
		m=(l+r)/2;
		if(m<0||m>=size)break;
		
		double t=a[aI[m]][col];
		
		if(BP_SEL){
			Print(fn,".l="+l,"; .r="+r,"; .m="+m,"; .t="+t);
		}	
		
		if(t>=element){
			r=m-1;
		}else{
			r=m;
			break;
		}
	}
	
	if(a[aI[m]][col]>=element){
		return(-1);
	}
	
	while(r>=m){
		t=a[aI[m]][col];
		if(t>=element)break;
		
		//-------------------
		m++;
	}
	
	m--;
	return(m);
}


void AId_SearchInterval(int &first, int &last, double &a[][], int &aI[], int col, double el){
	string fn="AId_SearchInterval";
	
	if(BP_SEL){
		Print(fn,"-> AId_SearchFirst(a,aI,col,el)");
	}
	first=AId_SearchFirst(a,aI,col,el);
	if(BP_SEL){
		Print(fn,"-> AId_SearchLast(a,aI,col,el)");
	}
	last=AId_SearchLast(a,aI,col,el);
}

void AId_Select2(double &a[][], int &aI[]){
	/**
		\version	0.0.0.0
		\date		2013.11.08
		\author		Morochin <artamir> Artiom
		\details	����� �� ������� �� ��������� ������� �������-�������.
		\internal
			>Hist:
			>Rev:0
	*/

	//��������� ��������� SEL_OP_OR � ��������.
	
	/*
		����: � ����� �� ������� ������� ������ ���������� � ����� ��� ������ �������� �������.
		����� ����� ������ ����� �����, ���� � ��������� ������� ��� �������� ��������� �������.
	*/
	string fn="AId_Select2";
	
	for(int row_f=0;row_f<ArrayRange(AId_Filter,0);row_f++){
		if(ArrayRange(aI,0)<=0){
			continue;
		}
		//--------------------------------------------------
		int f_col=AId_Filter[row_f][AIF_COL];//{ ���������� ������� �������� �������-�������.
		double f_min=AId_Filter[row_f][AIF_MIN];
		double f_max=AId_Filter[row_f][AIF_MAX];
		int f_select_operation=AId_Filter[row_f][AIF_SEL_OP];
		int f_assertion_operation=AId_Filter[row_f][AIF_AS_OP];//}
	
		string order=f_col+" <;";//���������� �� �����������
		// Print(fn+".order="+order
		// ,"; .sop="+f_select_operation
		// ,"; .aop="+f_assertion_operation
		// ,"; .f_col="+f_col
		// ,"; .f_min="+f_min
		// ,"; .f_max="+f_max);
		
		//--- ���������� �������� ������� � �������� �������-�������.
		
		int ticks=GetTickCount();
		//AId_SortShell2(a, aI, order);
		AId_QuickSort2(a, aI, -1, -1, f_col);
		if(BP_SRT || BP_SEL)AId_Print2(a,aI,4,"after_QS("+f_col+")");
		//Print(fn+".AId_QuickSort2 ("+order+")ms="+(GetTickCount()-ticks));
		
		//--- ������� ������ ������ �� �������� �������.
		int first=0,last=ArrayRange(aI,0); //� ����� ������ ������� �������� �������� �������-��������.
	
		//--- ��������� ������ � ����������� �� �������� ��������� (assertion)
		if(f_select_operation==AI_SEL_OP_AND){
			if(f_assertion_operation==AI_AS_OP_EQ){
				if(BP_SEL){
					Print(fn,"-> AId_SearchInterval(first,last,a,aI,f_col="+f_col+",f_max="+f_max+")");
				}
				AId_SearchInterval(first,last,a,aI,f_col,f_max);
				//����� ������� ��������, ����� �������� �������� ������ � ������� � ����. �������
				AI_IndexSetInterval(aI,first,last);
				if(BP_SRT || BP_SEL){AId_Print2(a, aI, 4, "AId_SearchInterval("+f_col+","+first+","+last+")");
					AI_PrintIndex(aI,fn);
				}
				continue;
			}
		
			if(f_assertion_operation==AI_AS_OP_GREAT){
				//��� �������� ������ ��� ������ ��������� ���������� � ������� ������� ��������� �������� �� ����� �������.
				first=AId_SearchGreat(a,aI,f_col, f_max);
				//������ ����� �������� �������� ������ �� ��������� ��������� � ������� � ���� �������
				AI_IndexSetInterval(aI,first);
				if(BP_SRT || BP_SEL){AId_Print2(a, aI, 4, "AId_SearchInterval("+f_col+","+first+","+last+")");
					AI_PrintIndex(aI,fn);
				}
				continue;
			}
		
			if(f_assertion_operation==AI_AS_OP_LESS){
				//��� �������� ������ ��� ������ ��������� ���������� � ������� ���������� ��������� �������� �� ������ �������.
				last=AId_SearchLess(a,aI,f_col, f_max);
				
				//������ ����� �������� �������� ������ �� ��������� ��������� � ������� � ���� �������
				AI_IndexSetInterval(aI,first,last);
				if(BP_SRT || BP_SEL){AId_Print2(a, aI, 4, "AId_AId_SearchLess("+f_col+","+first+","+last+")");
					AI_PrintIndex(aI,fn);
				}
				continue;
			}
		
			if(f_assertion_operation==AI_AS_OP_IN){
				first=AId_SearchFirst(a,aI,f_col,f_min);
				last=AId_SearchLast(a,aI,f_col,f_max);
				
				AI_IndexSetInterval(aI,first, last);
				continue;
			}
		}
	
		//���� ����� ����, ������ �� ������ �� �������� ����������� ������� �������� ��� �� �������� ���������.
		//����� ������������ ����� ������� �� first �� last � ���������� �������� �������� � ������� ������� � ������ �������.
		int a_temp2_idx[];
		int size=0;
		for(int row_i=first; row_i<=last;row_i++){
			double a_val=a[aI[row_i]][f_col];
			if(!A_Assert(f_assertion_operation, a_val, f_max, f_min))continue;
			size=ArrayRange(a_temp2_idx,0)+1;
			ArrayResize(a_temp2_idx,size);
			a_temp2_idx[size-1]=aI[row_i];
		}
		
		AI_SetIndex(a_temp2_idx, aI);	//���������� ����� ������.
	}
}

void AId_SetIndexOnArray(double &s[][], int aI[], double &d[][], bool addResult=false){
	/**
		\version	0.0.0.0
		\date		2013.11.08
		\author		Morochin <artamir> Artiom
		\details	����������� ������ �� ������ s � ���������� �������������� ������ d.
		\internal
			>Hist:
			>Rev:0
	*/

	if(!addResult){
		ArrayResize(d, 0);
	}
	
	for(int i=0; i<ArrayRange(aI,0); i++){
		for(int j=0; j<ArrayRange(s,1);j++){
			ArrayResize(d,i+1);
			d[i][j]=s[aI[i]][j];
		}
	}
}

//------------------------------------------------------------------------
void AId_Print2(double &a[][], int &aI[], int d = 4, string fn = "AId_PrintArray_"){
	/**
		\version	0.0.0.0
		\date		2013.11.06
		\author		Morochin <artamir> Artiom
		\details	������ � ���� ���������� ������� �������� ��������.
		\internal
			>Hist:
			>Rev:0
	*/


	static int	i;
	
	i++;
	//------------------------------------------------------
	int ROWS = ArrayRange(aI, 0);
	int COLS = ArrayRange(a,1);
	
	//------------------------------------------------------
	fn = i+"_"+fn+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
		string s = "";
		for(int idx_2 = 0; idx_2 < COLS; idx_2++){
			s = StringConcatenate(s,"\t", "["+idx_1+","+aI[idx_1]+"]["+idx_2+","+OE2Str(idx_2)+"]",DoubleToStr(a[aI[idx_1]][idx_2], d));
		}
		FileWrite(handle, s);
	}
	
	if(handle != 0) FileClose(handle);
	
}
