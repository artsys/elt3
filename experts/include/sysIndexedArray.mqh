	/**
		\version	3.1.0.11
		\date		2014.02.26
		\author		Morochin <artamir> Artiom
		\details	Работа с индексированным массивом.
		\internal
			>Hist:											
					 @3.1.0.11@2014.02.26@artamir	[+]	AId_SearchGreat2
					 @3.1.0.10@2014.02.26@artamir	[+]	AId_SearchLast2
					 @3.1.0.9@2014.02.26@artamir	[+]	AId_SearchFirst2
					 @3.1.0.8@2014.02.26@artamir	[*]	AId_QuickSearch2
					 @3.1.0.7@2014.02.26@artamir	[*]	AId_QuickSearch2
					 @3.1.0.6@2014.02.26@artamir	[+]	AId_QuickSearch2
					 @3.1.0.5@2014.02.25@artamir	[+]	AId_Compare
					 @3.1.0.4@2014.02.25@artamir	[+]	AId_QuickSort2
					 @3.1.0.3@2014.02.25@artamir	[+]	AId_get2
					 @3.1.0.2@2014.02.25@artamir	[+]	AI_Swap
					 @3.1.0.1@2014.02.25@artamir	[+]	AI_setInterval
			>Rev:0
	*/
	
void AId_Init2(double &a[][], int &aI[]){
	/**
		\version	0.0.0.1
		\date		2013.11.06
		\author		Morochin <artamir> Artiom
		\details	Инициализация массива индексов.
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

double AId_get2(double &a[][], int &aI[], int idx=0, int col=0){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение элемента исходного массива через индекс
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.25@artamir	[+]	
			>Rev:0
	*/

	string fn="AId_get2";
	return(a[aI[idx]][col]);
}

#define AI_EQ		0
#define AI_GREAT	1
#define AI_LESS		2
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
	if(MathAbs(v1-v2)<=0.00001)return(AI_EQ);
	
	if(v1>v2)return(AI_GREAT);
	
	return(AI_LESS);

}

#define AI_WHOLEARRAY	-256
#define AI_EMPTY		-1024
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
	
	if(start_idx==AI_EMPTY || end_idx==AI_EMPTY){
		ArrayResize(aI,0);
		return(0);	//массив индексов обнуляется
	}
	
	int s=0,e=0,t=0;
	if(start_idx==AI_WHOLEARRAY){
		return(ArrayRange(aI,0)); //массив индексов не изменяется. 
	}
	
	if(end_idx==AI_WHOLEARRAY){
		e=ArrayRange(aI,0)-1;//самый большой индекс
	}
	
	int range=e-s+1;//количество элементов всего
	ArrayResize(aT,range);
	
	for(int i=0; i<range; i++){
		aT[i]=aI[s+i];
	}
	
	ArrayResize(aI,range);
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
bool isNewQS=true; int maxQScount=0;
void AId_QuickSort2(double &a[][], int &aI[], int idx_min=-1, int idx_max=-1, int col=0, int mode=0){
	/**
		\version	0.0.0.1
		\date		2014.02.25
		\author		Morochin <artamir> Artiom
		\details	Алгоритм сортировки "быстрая сортировка". По умолчанию сортируется 0-я колонка
		по возрастанию.
		\internal
			>Hist:		
					 @0.0.0.1@2014.02.25@artamir	[+]	AId_QuickSort2
	*/
	static int count;
	if(isNewQS)count=0;
	count++;
	maxQScount=MathMax(maxQScount,count);
	string fn="Ad_QuickSort2";
	
	if(ArrayRange(aI,0)<2){
		return;
	}
	
	if(idx_min<0){idx_min=0;}
	if(idx_max<0){idx_max=ArrayRange(aI,0)-1;}
	
	int i=idx_min, j=idx_max;
	int idx_pivot = MathRound((i+j)/2);
	double pivot_value = (AId_get2(a,aI,i,col)+AId_get2(a,aI,j,col)+AId_get2(a,aI,idx_pivot,col))/3; //усредненное значение первого, последнего и среднего элемента массива. 
	while(i<j){
		double vi=AId_get2(a,aI,i,col),vj=AId_get2(a,aI,j,col);
		if(mode == AI_ASC){
			while(AId_Compare(vi,pivot_value)==AI_LESS ){i++;}
			while(AId_Compare(vj,pivot_value)==AI_GREAT){j--;}
		}
		if(mode == AI_DESC){
			while(AId_Compare(vi,pivot_value)==AI_GREAT){i++;}
			while(AId_Compare(vj,pivot_value)==AI_LESS ){j--;}
		}
		if(i<j){
			AI_Swap(aI, i,j);i++;j--;
		}
	}
	isNewQS=false;
	if(i<idx_max){AId_QuickSort2(a,aI,i,idx_max,col, mode);}
	isNewQS=true;
	isNewQS=false;
	if(idx_min<j){AId_QuickSort2(a,aI,idx_min,j,col, mode);}
	isNewQS=true;	
}

#define AI_NONE -2048
int AId_QuickSearch2(double &a[][], int &aI[], int col=0, double element=0.0, int mode=AI_EQ){
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
	int size=ArrayRange(aI,0);
	
	if(size<=0)return(AI_NONE);
	
	int l=0,r=size-1,m=l+(r-l)/2;
	
	if(mode==AI_EQ){
		while(l<r){
			int c=AId_Compare(AId_get2(a,aI,m,col), element);
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
		
		int c=AId_Compare(AId_get2(a,aI,r,col), element);
		if(c==AI_EQ)return(r);
		else return(AI_NONE);	
	}
	
	if(mode==AI_GREAT){
		while(l<r){
			int c=AId_Compare(AId_get2(a,aI,m,col), element);
			if(c==AI_GREAT){
				r=m;
				l=m;
			}else{
				l=m+1;   
			}
			m=l+(r-l)/2;
		}
		
		int c=AId_Compare(AId_get2(a,aI,r,col), element);
		if(c==AI_GREAT)return(r);
		else return(AI_NONE);	
	}
	
	if(mode==AI_LESS){
		while(l<r){
			int c=AId_Compare(AId_get2(a,aI,m,col), element);
			if(c==AI_LESS){
				r=m;
				l=m;
			}else{
				r=m;   
			}
			m=l+(r-l)/2;
		}
		
		int c=AId_Compare(AId_get2(a,aI,r,col), element);
		if(c==AI_LESS)return(r);
		else return(AI_NONE);	
	}
	//------------------------------------------------
	return(AI_NONE);
}

int AId_SearchFirst2(double &a[][], int &aI[], int col=0, double element=0.0){
	/**
		\version	0.0.0.1
		\date		2014.02.26
		\author		Morochin <artamir> Artiom
		\details	Поиск самого первого совпадения.
		\internal
			>Hist:	
					 @0.0.0.1@2014.02.26@artamir	[]	AId_SearchFirst2
			>Rev:0
	*/
	
	string fn="AId_SearchFirst2";
	
	int found_index=AId_QuickSearch2(a,aI,col,element,AI_EQ);
	if(found_index==AI_NONE)return(AI_NONE);
	
	int r=found_index;
	while(r>=0&&AId_Compare(AId_get2(a,aI,r,col), element)==AI_EQ){
		r--;
	}
	
	if(r<=-1)r=0;
	
	while(AId_Compare(AId_get2(a,aI,r,col), element)!=AI_EQ){
		r++;
	}
	
	return(r);
}

int AId_SearchLast2(double &a[][], int &aI[], int col=0, double element=0.0){
	/**
		\version	0.0.0.1
		\date		2014.02.26
		\author		Morochin <artamir> Artiom
		\details	Поиск самого первого совпадения.
		\internal
			>Hist:		
					 @0.0.0.1@2014.02.26@artamir	[]	AId_SearchLast2
			>Rev:0
	*/
	
	string fn="AId_SearchLast2";
	
	int found_index=AId_QuickSearch2(a,aI,col,element,AI_EQ);
	if(found_index==AI_NONE)return(AI_NONE);
	
	int size=ArrayRange(aI,0);
	
	int l=found_index;
	while(l<size&&AId_Compare(AId_get2(a,aI,l,col), element)==AI_EQ){
		l++;
	}
	
	if(l>=size)l=size-1;
	
	while(l>=0&&AId_Compare(AId_get2(a,aI,l,col), element)!=AI_EQ){
		l--;
	}
	
	return(l);
}

int AId_SearchGreat2(double &a[][], int &aI[], int col=0, double element=0.0){
	/**
		\version	0.0.0.1
		\date		2014.02.26
		\author		Morochin <artamir> Artiom
		\details	Поиск первого сэлемента, большего чем заданный.
		\internal
			>Hist:		
					 @0.0.0.1@2014.02.26@artamir	[+]	AId_SearchGreat2
			>Rev:0
	*/
	
	string fn="AId_SearchGreat2";
	
	int found_index=AId_QuickSearch2(a,aI,col,element,AI_GREAT);
	if(found_index==AI_NONE)return(AI_NONE);
	
	int r=found_index;
	while(r>=0&&AId_Compare(AId_get2(a,aI,r,col), element)==AI_GREAT){
		r--;
	}
	
	if(r<=-1)r=0;
	
	while(AId_Compare(AId_get2(a,aI,r,col), element)!=AI_GREAT){
		r++;
	}
	
	return(r);
}