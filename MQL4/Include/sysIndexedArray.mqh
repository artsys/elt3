	/**
		\version	3.1.0.32
		\date		2014.03.12
		\author		Morochin <artamir> Artiom
		\details	Работа с индексированным массивом.
		\internal
			>Hist:																																
					 @3.1.0.32@2014.03.12@artamir	[]	AId_Init2
					 @3.1.0.30@2014.03.06@artamir	[]	AId_QuickSort2
					 @3.1.0.29@2014.03.06@artamir	[]	AId_QuickSort2
					 @3.1.0.28@2014.03.06@artamir	[]	AId_Get2
					 @3.1.0.27@2014.03.06@artamir	[+]	AId_Sum2
					 @3.1.0.26@2014.03.03@artamir	[+]	AId_RFF2
					 @3.1.0.25@2014.03.03@artamir	[+]	AId_STF2
					 @3.1.0.24@2014.03.03@artamir	[!]	AId_SearchLess2
					 @3.1.0.23@2014.03.03@artamir	[!]	AId_SearchGreat2
					 @3.1.0.22@2014.03.03@artamir	[!]	AId_SearchLast2
					 @3.1.0.21@2014.03.03@artamir	[!]	AId_SearchFirst2
					 @3.1.0.20@2014.03.03@artamir	[+]	AId_CopyRow2
					 @3.1.0.19@2014.03.03@artamir	[+]	AId_AddRow2
					 @3.1.0.18@2014.02.28@artamir	[+]	AId_Print2
					 @3.1.0.17@2014.02.28@artamir	[+]	AId_Select2
					 @3.1.0.16@2014.02.28@artamir	[+]	AIF_filterAdd_AND
					 @3.1.0.15@2014.02.28@artamir	[+]	AIF_filterAdd
					 @3.1.0.14@2014.02.28@artamir	[+]	AIF_AddRow
					 @3.1.0.13@2014.02.28@artamir	[+]	AIF_init
					 @3.1.0.12@2014.02.26@artamir	[+]	AId_SearchLess2
					 @3.1.0.11@2014.02.26@artamir	[+]	AId_SearchGreat2
					 @3.1.0.10@2014.02.26@artamir	[+]	AId_SearchLast2
					 @3.1.0.9@2014.02.26@artamir	[+]	AId_SearchFirst2
					 @3.1.0.8@2014.02.26@artamir	[*]	AId_QuickSearch2
					 @3.1.0.7@2014.02.26@artamir	[*]	AId_QuickSearch2
					 @3.1.0.6@2014.02.26@artamir	[+]	AId_QuickSearch2
					 @3.1.0.5@2014.02.25@artamir	[+]	AId_Compare
					 @3.1.0.4@2014.02.25@artamir	[+]	AId_QuickSort2
					 @3.1.0.3@2014.02.25@artamir	[+]	AId_Get2
					 @3.1.0.2@2014.02.25@artamir	[+]	AI_Swap
					 @3.1.0.1@2014.02.25@artamir	[+]	AI_setInterval
			>Rev:0
	*/

bool AI_BSEL=false;
	
#define AI_NONE         -2147483648

void AI_Union(int &a1[],int &a2[]){
	/**
		\version	0.0.0.2
		\date		2014.03.12
		\author		Morochin <artamir> Artiom
		\details	Объединение двух индексов. Объединеный индексный массив возвращается в a1[]
		\internal
			>Hist:		
					 @0.0.0.2@2014.03.12@artamir	[*]	Добавлена сортировка по умолчанию.
					 @0.0.0.1@2013.11.06@artamir	[+]	
			>Rev:0
	*/
	
	string fn="AI_Union";
	int r2=ArrayRange(a2,0);
	
	int r1=r2+ArrayRange(a1,0);
	
	ArrayResize(a1,r1,1000);
	
	for(int i=0;i<r2;i++){
	   a1[(r1-r2)+i]=a2[i];
	}

}
	
void AId_Init2(double &a[][], int &aI[], int c=-1){
	/**
		\version	0.0.0.2
		\date		2014.03.12
		\author		Morochin <artamir> Artiom
		\details	Инициализация массива индексов.
		\internal
			>Hist:		
					 @0.0.0.2@2014.03.12@artamir	[*]	Добавлена сортировка по умолчанию.
					 @0.0.0.1@2013.11.06@artamir	[+]	
			>Rev:0
	*/

	ArrayResize(aI,ArrayRange(a,0),1000);
	for(int i=0; i<ArrayRange(a,0);i++){
		aI[i]=i;
	}
	
	if(c>-1){
		//AId_QuickSort2(a,aI,-1,-1,c);
		//AId_InsertSort2(a,aI,c);
	}  
}

double AId_Get2(double &a[][], int &aI[], int idx=0, int col=0){
	/**
		\version	0.0.0.2
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение элемента исходного массива через индекс
		\internal
			>Hist:		
					 @0.0.0.2@2014.03.06@artamir	[]	AId_Get2
					 @0.0.0.1@2014.02.25@artamir	[+]	
			>Rev:0
	*/

	string fn="AId_Get2";
	int rows=ArrayRange(aI,0); 
	if(rows<=0)return((double)AI_NONE);
	
	if(idx>=rows){
		DPRINT2("idx>rows ("+idx+">"+rows+")");
		return(AI_NONE);
	}	
	
	double val=a[aI[idx]][col];
	return(val);
}

int AId_AddRow2(double &a[][]){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Добавляет новую строку к массиву. 069011273
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	AId_AddRow2
			>Rev:0
	*/
	string fn="AId_AddRow2";
	int t=ArrayRange(a,0);t++;
	ArrayResize(a,t);t--;
	return(t);
}

int AId_CopyRow2(double &s[][], double &d[][], int i=0){
	/**
		\version	0.0.0.1
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Копирование строки с заданным индексом в массиве индеков из массива источника в новую строку массива приемника.
		Второе измерение массива приемника должно быть больше или равно второму измерению массива источника.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.03@artamir	[+]	AId_CopyRow2
			>Re v:0
	*/
	string fn="AId_CopyRow2";
	int idx=AId_AddRow2(d);
	int cols=ArrayRange(s,1);
	for(int c=0;c<cols;c++){
		d[idx][c]=s[i][c];
	}
	
	return(idx);
}

double AId_Sum2(double &a[][], int &aI[], int col){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Суммирует значения заданной колонки.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	AId_Sum2
			>Rev:0
	*/
	string fn="AId_Sum2";
	double sum=0.0;
	
	int rows=ArrayRange(aI,0);
	for(int i=0;i<rows;i++){
		sum+=AId_Get2(a,aI,i,col);
	}
	
	return(sum);
}

enum AI_ASSERTIONS{
   AI_EQ=0,
   AI_GREAT=1,
   AI_GREAT_OR_EQ=2,
   AI_LESS=3
};
double AId_Compare(double v1, double v2){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	Возвращает результат сравнения двух вещественных параметров.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.25@artamir	[+]	AId_Compare
			>Rev:0
	*/
	
	string fn="AId_Compare";
	if(MathAbs(v1-v2)<=0.00000001)return(AI_EQ);
	
	if(v1>v2)return(AI_GREAT);
	
	return(AI_LESS);

}

#define AI_WHOLEARRAY	-256
#define AI_EMPTY		   -1024

int AI_setInterval(int &aI[], int start_idx=0, int end_idx=-256){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	Обрезает индекс по интервалу.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.25@artamir	[+]	AI_setInterval
			>Rev:0
	*/

	string fn="AI_setInterval";
	int aT[];
	ArrayResize(aT,0);
	
	if((start_idx==AI_EMPTY || start_idx==AI_NONE) || (end_idx==AI_EMPTY || end_idx==AI_NONE)){
		ArrayResize(aI,0);
		return(0);	//массив индексов обнуляется
	}
	
	int s=start_idx,e=end_idx,t=0;
	if(start_idx==AI_WHOLEARRAY){
		return(ArrayRange(aI,0)); //массив индексов не изменяется. 
	}
	
	if(end_idx==AI_WHOLEARRAY){
		e=ArrayRange(aI,0)-1;//самый большой индекс
	}
	
	int range=e-s+1;//количество элементов всего
	ArrayResize(aT,range,1000);
	
	for(int i=0; i<range; i++){
		aT[i]=aI[s+i];
	}
	
	ArrayResize(aI,range,1000);
	ArrayCopy(aI,aT,0,0,WHOLE_ARRAY);
	return(range);
}

void AI_Swap(int &aI[], int i=0, int j=0){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	Меняет местами два индекса
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.25@artamir	[+]	AI_Swap
			>Rev:307
	*/
	string fn="AI_Swap";
	int t=aI[i];
	aI[i]=aI[j];
	aI[j]=t;
}

#define AI_ASC	0
#define AI_DESC	1
bool isNewQS=true; int maxQScount=0; int CallCounter=0;
void AId_QuickSort2(double &a[][], int &aI[], int idx_min=-1, int idx_max=-1, int col=0, int mode=0){
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
	static int count;
	if(isNewQS){
		count=0;
		//aCol[col]++;
	}	
	count++;
	maxQScount=MathMax(maxQScount,count);
	if(isTick){CallCounter=1; isTick=false;}
	else CallCounter++;
	
	string fn="AId_QuickSort2";
	
	if(ArrayRange(aI,0)<2){
		return;
	}
	
	if(idx_min<0){idx_min=0;}
	if(idx_max<0){idx_max=ArrayRange(aI,0)-1;}
	
	int i=idx_min, j=idx_max;
	int idx_pivot = (int)MathRound((i+j)/2);
	double pivot_value = NormalizeDouble((a[aI[i]][col]+a[aI[j]][col]+a[aI[idx_pivot]][col])/3,8); //усредненное значение первого, последнего и среднего элемента массива. 
	while(i<j){
		if(mode == AI_ASC){
			while(NormalizeDouble(a[aI[i]][col],8)<NormalizeDouble(pivot_value,8)){i++;}
			while(NormalizeDouble(a[aI[j]][col],8)>NormalizeDouble(pivot_value,8)){j--;}
		}
		if(mode == AI_DESC){
			while(a[aI[i]][col]>pivot_value){i++;}
			while(a[aI[j]][col]<pivot_value){j--;}
		}
		if(i<j){
			AI_Swap(aI, i,j);i++;j--;
		}
	}
	isNewQS=false;
	if(i<idx_max){AId_QuickSort2(a,aI,i,idx_max,col, mode);}
	isNewQS=false;
	if(idx_min<j){AId_QuickSort2(a,aI,idx_min,j,col, mode);}
	isNewQS=true;
}

void AId_InsertSort2(double &a[][], int &aI[], int col=0){
   int l=0, r=ArrayRange(aI,0);
   //AId_Print2(a,aI,4,"Insert_before_"+(string)col);
   for(int i=1; i<r; i++){
      //Будем считать, что до i-1 элемента у нас отсортированная последовательность.
      //нужно в ней найти место для и-го элемента.
      double e=AId_Get2(a,aI,i,col);
      int ig=AId_SearchGreat2(a,aI,col,e,i-1);
      if(ig==AI_NONE)continue;
      
      for(int j=ig; j<i; j++){
         AI_Swap(aI,i,j);
      }
   }   
   
   //AId_Print2(a,aI,4,"Insert_after_"+(string)col); 
}

int AId_QuickSearch2(double &a[][], int &aI[], int col=0, double element=0.0, int mode=AI_EQ, int last_index=-1){
	/**
		\version	0.0.0.3
		\date		2014.02.26
		\author		Morochin <artamir> Artiom
		\details	Быстрый поиск в отсортированном массиве.
		\internal
			>Hist:			
					 @0.0.0.3@2014.02.26@artamir	[+]	Добавлен поиск любого меншего индекса.
					 @0.0.0.2@2014.02.26@artamir	[+]	Добавлен поиск любого большего индекса.
					 @0.0.0.1@2014.02.26@artamir	[+]	AId_QuickSearch2
			>Rev:0
	*/
	string fn="AId_QuickSearch2";
	int size=last_index+1;
	
	if(size<=0){   
	   size=ArrayRange(aI,0);
	}   
	
	if(size<=0)return(AI_NONE);
	
	int l=0,r=size-1,m=l+(r-l)/2;
	
	if(mode==AI_EQ){
		while(l<r){
			int c=(int)AId_Compare(AId_Get2(a,aI,m,col), element);
			if(c==AI_GREAT){
				r=m;
			}else{
			   if(c==AI_LESS){
					l=m+1;
				}else{
					l=m;
					r=m;
				}   
			}
			m=l+(r-l)/2;
		}
		
		int c=(int)AId_Compare(AId_Get2(a,aI,r,col), element);
		if(c==AI_EQ)return(r);
		else return(AI_NONE);	
	}
	
	if(mode==AI_GREAT){
		while(l<r){
		   double val=AId_Get2(a,aI,m,col);
			int c=(int)AId_Compare(val, element);
			if(c==AI_GREAT){
				r=m;
				l=m;
			}else{
				l=m+1;   
			}
			m=l+(r-l)/2;
		}
		
		int c=(int)AId_Compare(AId_Get2(a,aI,r,col), element);
		if(c==AI_GREAT)return(r);
		else return(AI_NONE);	
	}
	
	if(mode==AI_LESS){
		while(l<r){
			int c=(int)AId_Compare(AId_Get2(a,aI,m,col), element);
			if(c==AI_LESS){
				r=m;
				l=m;
			}else{
				r=m;   
			}
			m=l+(r-l)/2;
		}
		
		int c=(int)AId_Compare(AId_Get2(a,aI,r,col), element);
		if(c==AI_LESS)return(r);
		else return(AI_NONE);	
	}
	//------------------------------------------------
	return(AI_NONE);
}

int AId_SearchFirst2(double &a[][], int &aI[], int col=0, double element=0.0){
	/**
		\version	0.0.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Поиск самого первого совпадения.
		\internal
			>Hist:		
					 @0.0.0.2@2014.03.03@artamir	[!]	Добавлена проверка на размерность массива индексов.
					 @0.0.0.1@2014.02.26@artamir	[]	AId_SearchFirst2
			>Rev:0
	*/
	
	string fn="AId_SearchFirst2";
	
	if(ArrayRange(aI,0)<=0)return(AI_NONE);
	
	int found_index=AId_QuickSearch2(a,aI,col,element,AI_EQ);
	if(found_index==AI_NONE)return(AI_NONE);
	
	int r=found_index;
	while(r>=0&&AId_Compare(AId_Get2(a,aI,r,col), element)==AI_EQ){
		r--;
	}
	
	if(r<=-1)r=0;
	
	while(AId_Compare(AId_Get2(a,aI,r,col), element)!=AI_EQ){
		r++;
	}
	
	return(r);
}

int AId_SearchLast2(double &a[][], int &aI[], int col=0, double element=0.0){
	/**
		\version	0.0.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Поиск самого первого совпадения.
		\internal
			>Hist:			
					 @0.0.0.2@2014.03.03@artamir	[!]	Добавлена проверка на размерность массива индексов.
					 @0.0.0.1@2014.02.26@artamir	[+]	AId_SearchLast2
			>Rev:0
	*/
	
	string fn="AId_SearchLast2";
	
	if(ArrayRange(aI,0)<=0)return(AI_NONE);
	
	int found_index=AId_QuickSearch2(a,aI,col,element,AI_EQ);
	if(found_index==AI_NONE)return(AI_NONE);
	
	int size=ArrayRange(aI,0);
	
	int l=found_index;
	while(l<size&&AId_Compare(AId_Get2(a,aI,l,col), element)==AI_EQ){
		l++;
	}
	
	if(l>=size)l=size-1;
	
	while(l>=0&&AId_Compare(AId_Get2(a,aI,l,col), element)!=AI_EQ){
		l--;
	}
	
	return(l);
}

int AId_SearchGreat2(double &a[][], int &aI[], int col=0, double element=0.0, int last_index=-1){
	/**
		\version	0.0.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Поиск первого сэлемента, большего чем заданный.
		\internal
			>Hist:			
					 @0.0.0.2@2014.03.03@artamir	[!]	Добавлена проверка на размерность массива индексов.
					 @0.0.0.1@2014.02.26@artamir	[+]	AId_SearchGreat2
			>Rev:0
	*/
	
	string fn="AId_SearchGreat2";
	
	if(ArrayRange(aI,0)<=0)return(AI_NONE);
	
	if(last_index<0)last_index=ArrayRange(aI,0)-1;
	if(AId_Compare(AId_Get2(a,aI,last_index,col),element)!=AI_GREAT)return(AI_NONE);
	
	int found_index=AId_QuickSearch2(a,aI,col,element,AI_GREAT,last_index);
	if(found_index==AI_NONE)return(AI_NONE);
	
	int r=found_index;
	while(r>=0&&AId_Compare(AId_Get2(a,aI,r,col), element)==AI_GREAT){
		r--;
	}
	
	if(r<=-1)r=0;
	
	while(AId_Compare(AId_Get2(a,aI,r,col), element)!=AI_GREAT){
		r++;
	}
	
	return(r);
}

int AId_SearchLess2(double &a[][], int &aI[], int col=0, double element=0.0){
	/**
		\version	0.0.0.2
		\date		2014.03.03
		\author		Morochin <artamir> Artiom
		\details	Поиск самого первого совпадения.
		\internal
			>Hist:				
					 @0.0.0.2@2014.03.03@artamir	[!]	Добавлена проверка на размерность массива индексов.
					 @0.0.0.1@2014.02.26@artamir	[+]	AId_SearchLess2
			>Rev:0
	*/
	
	string fn="AId_SearchLess2";
	
	if(ArrayRange(aI,0)<=0)return(AI_NONE);
	
	int found_index=AId_QuickSearch2(a,aI,col,element,AI_LESS);
	if(found_index==AI_NONE)return(AI_NONE);
	
	int size=ArrayRange(aI,0);
	
	int l=found_index;
	while(l<size&&AId_Compare(AId_Get2(a,aI,l,col), element)==AI_LESS){
		l++;
	}
	
	if(l>=size)l=size-1;
	
	while(l>=0&&AId_Compare(AId_Get2(a,aI,l,col), element)!=AI_LESS){
		l--;
	}
	
	return(l);
}

#define AIF_COL	0	//Индекс колонки по которой будет происходить отбор.
#define AIF_MIN 1	//Возможное минимальное значение элемента массива
#define AIF_MAX 2	//Возможное максимальное значение элемента массива.
#define AIF_AOP	3	//Операция сравнения.
#define AIF_SOP 4	//Операция соединения строк массива-фильтров
#define AIF_TOT 5
double AIF_filter[][AIF_TOT];	//Массив-фильтр для отбора по заданным значениям.

void AIF_init(void){
	/**
		\version	0.0.0.1
		\date		2014.02.28
		\author		Morochin <artamir> Artiom
		\details	Очищение массива-фильтров.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.28@artamir	[+]	AIF_init
			>Rev:0
	*/
	ArrayResize(AIF_filter,0);
}

int AIF_addRow(void){
	/**
		\version	0.0.0.1
		\date		2014.02.28
		\author		Morochin <artamir> Artiom
		\details	Добавление новой строки к массиву-фильтру. Изменение размерности массива-фильтров. Возвращает индекс созданной строки.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.28@artamir	[+]	AIF_AddRow
			>Rev:0
	*/

	string fn="AIF_addRow";
	int t=ArrayRange(AIF_filter,0);
	t++;
	ArrayResize(AIF_filter,t);
	t--;
	return(t);
}

#define AI_AND	0
#define AI_OR	1 //Пока не используется

void AIF_filterAdd(int col, int aop=AI_EQ, double min=0, double max=0, int sop=AI_AND){
	/**
		\version	0.0.0.1
		\date		2014.02.28
		\author		Morochin <artamir> Artiom
		\details	Добавляет в массив-фильтров новую строку с переданными параметрами.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.28@artamir	[+]	AIF_filterAdd
			>Rev:0
	*/
	
	string fn="AIF_filterAdd";
	
	int row=AIF_addRow();
	AIF_filter[row][AIF_COL]=col;
	AIF_filter[row][AIF_MIN]=min;
	AIF_filter[row][AIF_MAX]=max;
	AIF_filter[row][AIF_AOP]=aop;
	AIF_filter[row][AIF_SOP]=sop;
}

void AIF_filterAdd_AND(int col, int aop=AI_EQ, double min=0, double max=0){
	/**
		\version	0.0.0.1
		\date		2014.02.28
		\author		Morochin <artamir> Artiom
		\details	Добавляет к массиву фильтров строку с соединением AND
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.28@artamir	[+]	AIF_filterAdd_AND
			>Rev:0
	*/
	string fn="AIF_filterAdd_AND";
	AIF_filterAdd(col, aop, min, max, AI_AND);
}

void AId_Select2(double &a[][], int &aI[]){
	/**
		\version	0.0.0.1
		\date		2014.02.28
		\author		Morochin <artamir> Artiom
		\details	Выборка из двумерного массива по заданному массив-фильтров. После выполнения остается отобранный массив индексов.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.28@artamir	[+]	AId_Select2
			>Rev:0
	*/
	
	string fn="AId_Select2";
	int filter_rows=ArrayRange(AIF_filter,0);
	
	if(filter_rows<=0){
		return; //Если массив-фильтров не задан, то выходим из процедуры.
	}	
	
	for(int filter_idx=0; filter_idx<filter_rows; filter_idx++){
		int		f_col=(int)AIF_filter[filter_idx][AIF_COL];
		int		f_aop=(int)AIF_filter[filter_idx][AIF_AOP];
		double	f_min=AIF_filter[filter_idx][AIF_MIN];
		double	f_max=AIF_filter[filter_idx][AIF_MAX];
		
		//----------------------------------------------
		//Далее отсортируем по возрастанию значение 
		//колонки f_col
		
		//AId_QuickSort2(a, aI, -1,-1,f_col);
		AId_InsertSort2(a,aI,f_col);
		
		int first=AI_NONE, last=AI_NONE;
		
		
		if(f_aop==AI_EQ){
			first=AId_SearchFirst2(a, aI, f_col, f_min);
			last=AId_SearchLast2(a, aI, f_col, f_min);
			DAIdPRINT2(a,aI,"before AI_EQ col_"+OE2Str(f_col)+"_val_"+(string)f_min);
		}
		
		if(f_aop==AI_GREAT){
		   DPRINT2("AI_GREAT::before search::f_col="+f_col+" :f_min="+f_min);
         DAIdPRINT2(a,aI,"before AI_GREAT col_"+OE2Str(f_col)+"_val_"+(string)f_min);
			first=AId_SearchGreat2(a,aI,f_col,f_min);
			last=AI_WHOLEARRAY;
			
		}
		
		if(f_aop==AI_GREAT_OR_EQ){
		   DPRINT2("AI_GREAT_OR_EQ::before search::f_col="+f_col+" :f_min="+f_min);
		   
		   first=first=AId_SearchFirst2(a, aI, f_col, f_min);
		   if(first==AI_NONE){
		      first=AId_SearchGreat2(a,aI,f_col,f_min);
		   }
		   last=AI_WHOLEARRAY;
		   DAIdPRINT2(a,aI,"before AI_GREAT_OR_EQ col_"+OE2Str(f_col)+"_val_"+(string)f_min);
		}
		
		if(f_aop==AI_LESS){
		   DPRINT2("AI_LESS::before search::f_col="+f_col+" :f_min="+f_min);
			if(B_BSEL){
				Print(fn,".AI_LESS");
			}
			first=0;
			DAIdPRINT2(a,aI,"before AI_LESS col_"+OE2Str(f_col)+"_val_"+(string)f_min);
			last=AId_SearchLess2(a,aI,f_col,f_min);
		}
	   
		AI_setInterval(aI,first,last);
      DAIdPRINT2(a,aI,"after setInterval col_"+OE2Str(f_col)+"_val_"+(string)f_min);
   }
	
	
}

void AId_Print2(double &a[][], int &aI[], int d = 4, string fn = "AId_PrintArray_"){
	/**
		\version	0.0.0.1
		\date		2014.02.28
		\author		Morochin <artamir> Artiom
		\details	Печать в файл двумерного массива согласно индексам.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.28@artamir	[+]	AId_Print2
			>Rev:0
	*/


	static int	i;
	
	i++;
	//------------------------------------------------------
	int rows = ArrayRange(aI, 0);
	int cols = ArrayRange(a,1);
	
	//------------------------------------------------------
	fn = (string)i+"_"+(string)fn+".iar";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	for(int idx_1 = 0; idx_1 < rows; idx_1++){
		string s = "";
		for(int idx_2 = 0; idx_2 < cols; idx_2++){
			s = StringConcatenate(s,"\t", "[aI["+(string)idx_1+"],"+(string)aI[idx_1]+"]["+(string)idx_2+"]_"+OE2Str(idx_2),DoubleToStr(a[aI[idx_1]][idx_2], d));
		}
		FileWrite(handle, s);
	}
	
	if(handle != 0) FileClose(handle);
	
}

void AId_STF2(double &a[][], string fn, int d = 8){
	/*
		>Ver	:	0.0.0.5
		>Date	:	2014.03.03
		>Hist:		
				 @0.0.0.5@2014.03.03@artamir	[]	AId_STF2
				 @0.0.0.4@2013.12.30@artamir	[]	A_d_Select
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
	
	int rows = ArrayRange(a, 0);
	int cols = ArrayRange(a, 1);
	
	if(FileIsExist(fn)){FileDelete(fn);}
	
	int H = FileOpen(fn, FILE_TXT|FILE_WRITE);
	
	//------------------------------------------------------
	for(int idx1 = 0; idx1 < rows; idx1++){
		
		//--------------------------------------------------
		for(int idx2 = 0; idx2 < cols; idx2++){
			
			//----------------------------------------------
			double val = a[idx1][idx2];
			
			//----------------------------------------------
			string str = "@idx1_"+(string)idx1
						+"@idx2_"+(string)idx2
						+"@val_"+DoubleToStr(a[idx1][idx2], d)
						+"@des_"+OE2Str(idx2);
						
			//----------------------------------------------
			FileWrite(H, str);
		}
	}
	
	//------------------------------------------------------
	FileFlush(H);
	
	//------------------------------------------------------
	FileClose(H);
	
}

void AId_RFF2(double &a[][], string fn){
	/*
		>Ver	:	0.0.0.3
		>Date	:	2014.03.03
		>Hist:	
				 @0.0.0.3@2014.03.03@artamir	[]	AId_RFF2
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
		int rows = ArrayRange(a, 0);
		
		//--------------------------------------------------
		if(idx1 >= rows){
			ArrayResize(a, idx1+1);
		}
		
		//--------------------------------------------------
		a[idx1][idx2] = val;
	}
}

//}

