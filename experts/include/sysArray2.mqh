/**
	\version	0.0.0.5
	\date		2013.09.18
	\author		Morochin <artamir> Artiom
	\details	Detailed description
	\internal
		>Hist:					
				 @0.0.0.5@2013.09.18@artamir	[+]	Ad_CrossByIdx
				 @0.0.0.4@2013.09.04@artamir	[*]	Ad_AddRow2
				 @0.0.0.3@2013.08.29@artamir	[+]	Ad_AddRow2	
				 @0.0.0.2@2013.08.29@artamir	[+]	
				 @0.0.0.1@2013.08.29@artamir	[+]	
		>Rev:0
*/
#property stacksize 16368

#define A_MODE_ASC	0
#define A_MODE_DESC	1

#define A_MODE_ADD	2	//режим добавления
#define A_MODE_REPL	3	//режим замещения

#define A_CROSS_NO	0	//пересечения не было.
#define A_CROSS_UP	1	//Быстрый массив пересекает медленный снизу вверх.
#define A_CROSS_DW	2	//Быстрый массив пересекает медленный сверху вниз.

//{ === С плавающей точкой.
//{ 	=== двумерный массив
int Ad_CopyCol2To1(double &s[][], double &d[], int col){
	/**
		\version	0.0.0.0
		\date		2013.09.05
		\author		Morochin <artamir> Artiom
		\details	Копирует колонку двумерного массива в одномерный.
		\internal
			Прототип.
			>Hist:
			>Rev:0
	*/

}

int Ad_AddRow2(double &a[][]){
	/**
		\version	0.0.0.2
		\date		2013.09.04
		\author		Morochin <artamir> Artiom
		\details	добавляет новую строку к массиву. Возвращает индекс новой строки
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.04@artamir	[*] Исправлен расчет индекса нового элемента.	
					 @0.0.0.1@2013.08.29@artamir	[+]	
			>Rev:0
	*/
	int ROWS = ArrayRange(a,0);
	ArrayResize(a,(ROWS+1));
	return(ArrayRange(a,0)-1);
}

int Ad_CopyRow2To2(	double &s[][]	/** массив источник*/
					,	double &d[][]	/** массив получатель*/
					,	int sr=0 /** индекс строки массива источника */
					,	int dr=0 /** индекс строки массива получателя*/
					,	int mode=2 /** режим копирования (по умолчанию добавление)*/){
	/**
		\version	0.0.0.1
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	Копирует строку из одного массива в другой. Возвращает индекс строки из d
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.29@artamir	[+]	
			>Rev:0
	*/

	int idx_d = dr;
	if(mode == A_MODE_ADD){
		idx_d = Ad_AddRow2(d);
	}
	
	for(int i = 0; i<ArrayRange(s,1); i++){
		d[idx_d][i] = s[sr][i];
	}
	
	return(idx_d);
}

void Ad_Swap2(double &a[][], int i1, int i2){
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

void Ad_QuickSort2(double &a[][], int idx_min=-1, int idx_max=-1, int col=0, int mode = 0){
	/**
		\version	0.0.0.1
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	Алгоритм сортировки "быстрая сортировка". По умолчанию сортируется 0-я колонка
		по возрастанию.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.29@artamir	[+]	
			>Rev:0
	*/

	if(ArrayRange(a,0)<2){return;}
	
	if(idx_min<0){idx_min=0;}
	if(idx_max<0){idx_max=ArrayRange(a,0)-1;}
	
	int i=idx_min, j=idx_max;
	int idx_pivot = MathRound((i+j)/2);
	double pivot_value = (a[i][col]+a[j][col]+a[idx_pivot][col])/3; //усредненное значение первого, последнего и среднего элемента массива. 
	
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


//..	=== одномерный массив
void Ad_Copy1To1(double &s[], double &d[]){
	/**
		\version	0.0.0.0
		\date		2013.08.29
		\author		Morochin <artamir> Artiom
		\details	копирует массив s в массив d
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
		\details	меняет местами два элемента массива.
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
		\details	Алгоритм "быстрая сортировка" для одномерного массива
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
	double pivot_value = (a[i]+a[j]+a[idx_pivot])/3; //усредненное значение первого, последнего и среднего элемента массива. 
	
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
		\details	Сворачивание одномерного массива.
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
		\details	Вычисляет, было ли пересечение на заданном индексе двух массивов.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.18@artamir	[]	Ad_CrossByIdx
			>Rev:0
	*/

	if(ArrayRange(f,0)<=0){return(A_CROSS_NO);}
	if(ArrayRange(s,0)<=0){return(A_CROSS_NO);}
	
	double f2=Norm_symb(f[idx],2),		s2=Norm_symb(s[idx],2);
	double f1=Norm_symb(f[idx-1],2),	s1=Norm_symb(s[idx-1],2);
	double f3=Norm_symb(f[idx+1],2), 	s3=Norm_symb(s[idx+1],2);
	
	if(f2>s2){if(s1>f1){return(A_CROSS_UP);}}
	
	if(f2<s2){if(s1<f1){return(A_CROSS_DW);}}
	
	if(f2==s2){
		if(f1<s1 && f3>s3){return(A_CROSS_UP);}
		if(f1>s1 && f3<s3){return(A_CROSS_DW);}
	}
	
	return(A_CROSS_NO);
}
//}
//}	