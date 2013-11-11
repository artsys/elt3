	/**
		\version	0.0.0.3
		\date		2013.11.07
		\author		Morochin <artamir> Artiom
		\details	Работа с индексированным массивом.
		\internal
			>Hist:			
					 @0.0.0.3@2013.11.07@artamir	[+]	AId_SearchFirst
					 @0.0.0.2@2013.11.06@artamir	[+]	AId_Swap
					 @0.0.0.1@2013.11.06@artamir	[+]	AId_Init2
			>Rev:0
			>Desc: Перед началом каких либо действий (сортировка, выборка)
			необходимо проинициализировать масив индексов.
	*/

//int AI_idx[];
int maxQScount=0;

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

void AI_SetIndex(int &sI[], int &dI[]){
	/**
		\version	0.0.0.0
		\date		2013.11.08
		\author		Morochin <artamir> Artiom
		\details	Установка в виде основного индекса переданного массива.
		\internal
			>Hist:
			>Rev:0
	*/
	ArrayResize(dI,ArrayRange(sI,0));
	ArrayCopy(dI,sI);
}

// void AI_ReturnIndexArray(int &d[]){
	// /**
		// \version	0.0.0.0
		// \date		2013.11.07
		// \author		Morochin <artamir> Artiom
		// \details	создает копию индексного массива.
		// \internal
			// >Hist:
			// >Rev:0
	// */
	// ArrayResize(d,ArrayRange(AI_idx,0));
	// ArrayCopy(d,AI_idx);
// }

void AI_IndexSetInterval(int &aI[], int first, int last){
	/*
		\version	0.0.0.0
		\date		2013.11.07
		\author		Morochin <artamir> Artiom
		\details	Обрезает основной индекс по заданному интервалу.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="AI_IndexSetInterval";
	if(first<=-1&&last<=-1){
		ArrayResize(aI,0);
		return;
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
		\details	Меняет местами два индекса.
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

#define AI_ABOVE	0
#define AI_EQ		1
#define AI_UNDER	2

bool AId_Compare(double &a[][], int i1, int i2, string compare = ""){
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
			if(a[i1,col]>a[i2,col]){assertion=AI_ABOVE;}
			if(a[i1,col]==a[i2,col]){assertion=AI_EQ;}
			if(a[i1,col]<a[i2,col]){assertion=AI_UNDER;}
			//if(BP_SRT){Print (fn+": col = "+col, " op = "+op, " assertion="+assertion, " subs_ROWS="+subs_ROWS);}
			if(assertion==AI_ABOVE 	&& (op==">" ||op==">=")){return(true);}
			if(assertion==AI_UNDER 	&& (op=="<" ||op=="<=")){return(true);}
			if(assertion==AI_EQ){continue;}	//значения колонок равны, но не было совпадения с операциями сравнения.
		}
	}
	return(false);
}

void AId_SortShell2(double &a[][], int &aI[], string order="0 >;"){
	/**
		\version	0.0.0.0
		\date		2013.11.04
		\author		Morochin <artamir> Artiom
		\details	Сортировка методом Шелла
		На выходе имеем отсортированные индексы строк массива.
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
		\details	Алгоритм сортировки "быстрая сортировка". По умолчанию сортируется 0-я колонка
		по возрастанию.
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
		string	order="";
				order=order+col+" ";
				if(mode==A_MODE_ASC)
					order=order+">;";
				else
					order=order+"<;";
		AId_SortShell2(a, aI, order);
		return;}
	
	if(idx_min<0){idx_min=0;}
	if(idx_max<0){idx_max=ArrayRange(aI,0)-1;}
	
	int i=idx_min, j=idx_max;
	int idx_pivot = MathRound((i+j)/2);
	double pivot_value = (a[aI[i]][col]+a[aI[j]][col]+a[aI[idx_pivot]][col])/3; //усредненное значение первого, последнего и среднего элемента массива. 
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

int AId_QuickSearch(double &a[][], int &aI[], int col, double element){
	/**
		\version	0.0.0.1
		\date		2013.11.07
		\author		Morochin <artamir> Artiom
		\details	Устойчивый поиск первого совпадения с заданным значением.
		\internal
			>Hist:	
					 @0.0.0.1@2013.11.07@artamir	[]	AId_SearchFirst
			>Rev:0
	*/
	
   int    i,j,size,m=-1;
   double t_double;
//--- search
	size=ArrayRange(aI,0);
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
		\version	0.0.0.1
		\date		2013.11.07
		\author		Morochin <artamir> Artiom
		\details	Устойчивый поиск первого совпадения с заданным значением.
		\internal
			>Hist:	
					 @0.0.0.1@2013.11.07@artamir	[]	AId_SearchFirst
			>Rev:0
	*/
	int pos;
//--- check
   if(ArrayRange(aI,0)==0)
      return(-1);
//--- search
   pos=AId_QuickSearch(a, aI, col, element);
   if(a[aI[pos]][col]==element)
     {
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
		\version	0.0.0.1
		\date		2013.11.07
		\author		Morochin <artamir> Artiom
		\details	Устойчивый поиск первого совпадения с заданным значением.
		\internal
			>Hist:	
					 @0.0.0.1@2013.11.07@artamir	[]	AId_SearchFirst
			>Rev:0
	*/
	int pos;
//--- check
   if(ArrayRange(aI,0)==0)
      return(-1);
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

void AId_SearchInterval(int &first, int &last, double &a[][], int &aI[], int col, double el){
	first=AId_SearchFirst(a,aI,col,el);
	last=AId_SearchLast(a,aI,col,el);
}

void AId_Select2(double &a[][], int &aI[]){
	/**
		\version	0.0.0.0
		\date		2013.11.08
		\author		Morochin <artamir> Artiom
		\details	Отбор из массива по заданному условию массиву-фильтру.
		\internal
			>Hist:
			>Rev:0
	*/

	//ЗАПРЕЩЕНО ПРИМЕНЯТЬ SEL_OP_OR в фильтрах.
	
	/*
		Идея: В цикле по массиву фильтру делать сортировку и отбор для каждой заданной колонки.
		Тогда самый долгий отбор будет, если в результат попадут все элементы исходного массива.
	*/
	string fn="AId_Select2";
	
	for(int row_f=0;row_f<ArrayRange(A_Filter,0);row_f++){
		if(ArrayRange(aI,0)<=0){
			continue;
		}
		//--------------------------------------------------
		int f_col=A_Filter[row_f][F_COL];//{ Запоминаем текущие значения массива-фильтра.
		double f_min=A_Filter[row_f][F_MIN];
		double f_max=A_Filter[row_f][F_MAX];
		int f_select_operation=A_Filter[row_f][F_SEL_OP];
		int f_assertion_operation=A_Filter[row_f][F_AS_OP];//}
	
		string order=f_col+" <;";//сортировка по возрастанию
		//Print(fn+".order="+order
		//,"; .sop="+f_select_operation
		//,"; .aop="+f_assertion_operation
		//,"; .f_col="+f_col
		//,"; .f_min="+f_min
		//,"; .f_max="+f_max);
		
		//--- Сортировка заданной колонки в пределах массива-индекса.
		
		int ticks=GetTickCount();
		//AId_SortShell2(a, aI, order);
		AId_QuickSort2(a, aI, -1, -1, f_col);
		if(BP_SRT)AId_Print2(a,aI,4,"after_QS("+f_col+")");
		//Print(fn+".AId_QuickSort2 ("+order+")ms="+(GetTickCount()-ticks));
		
		//--- Задание границ отбора по заданной колонке.
		int first=0,last=ArrayRange(aI,0); //в общем случае границы задаются размером массива-индексов.
	
		//--- установка границ в зависимости от операций сравнения (assertion)
		if(f_select_operation==SEL_OP_AND){
			if(f_assertion_operation==AS_OP_EQ){
				AId_SearchInterval(first,last,a,aI,f_col,f_max);
				//нашли границы значения, можно обрезать основной индекс и аерейти к след. фильтру
				AI_IndexSetInterval(aI,first,last);
				if(BP_SRT){AId_Print2(a, aI, 4, "AId_SearchInterval("+f_col+","+first+","+last+")");
					AI_PrintIndex(aI,fn);
				}
				continue;
			}
		
			if(f_assertion_operation==AS_OP_GREAT){
				//все значения больше или равные заданному начинаются с индекса первого совпавшег элемента до конца массива.
				first=AId_SearchFirst(a,aI,f_col, f_max);
				
				//теперь можем обрезать основной индекс по найденому интервалу и перейти к след фильтру
				AI_IndexSetInterval(aI,first,last);
				continue;
			}
		
			if(f_assertion_operation==AS_OP_LESS){
				//все значения меньше или равные заданному начинаются с индекса последнего совпавшег элемента до начала массива.
				last=AId_SearchLast(a,aI,f_col, f_max);
				
				//теперь можем обрезать основной индекс по найденому интервалу и перейти к след фильтру
				AI_IndexSetInterval(aI,first,last);
				continue;
			}
		
			if(f_assertion_operation==AS_OP_IN){
				first=AId_SearchFirst(a,aI,f_col,f_min);
				last=AId_SearchLast(a,aI,f_col,f_max);
				
				AI_IndexSetInterval(aI,first, last);
				continue;
			}
		}
	
		//если дошли сюда, значит не попали по операции объединения условий фильтров или по операции сравнений.
		//будем использовать тупой перебор от first до last с получением значений заданной в фильтре колонки с учетом индекса.
		int a_temp2_idx[];
		int size=0;
		for(int row_i=first; row_i<=last;row_i++){
			double a_val=a[aI[row_i]][f_col];
			if(!A_Assert(f_assertion_operation, a_val, f_max, f_min))continue;
			size=ArrayRange(a_temp2_idx,0)+1;
			ArrayResize(a_temp2_idx,size);
			a_temp2_idx[size-1]=aI[row_i];
		}
		
		AI_SetIndex(a_temp2_idx, aI);	//установили новый индекс.
	}
}

void AId_SetIndexOnArray(double &s[][], int aI[], double &d[][], bool addResult=false){
	/**
		\version	0.0.0.0
		\date		2013.11.08
		\author		Morochin <artamir> Artiom
		\details	Накладывает индекс на массив s и возвращает результирующий массив d.
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

void AId_Print2(double &a[][], int &aI[], int d = 4, string fn = "AId_PrintArray_"){
	/**
		\version	0.0.0.0
		\date		2013.11.06
		\author		Morochin <artamir> Artiom
		\details	Печать в файл двумерного массива согласно индексам.
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
