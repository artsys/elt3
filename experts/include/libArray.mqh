/*
		>Ver	:	0.0.17
		>Date	:	2013.01.16
		>Hist:
			@0.0.17@2013.01.16@artamir	[+] A.d.addPropByIndex2
			@0.0.16@2013.01.16@artamir	[+] A.d.getIndexByProp2
			@0.0.15@2012.12.19@artamir	[]
			@0.0.14@2012.10.15@artamir	[]
			@0.0.13@2012.09.20@artamir	[+] double_Sum2
			@0.0.12@2012.09.04@artamir	[]
			@0.0.11@2012.09.04@artamir	[]
			@0.0.10@2012.09.04@artamir	[]
			@0.0.9@2012.09.03@artamir	[]
			@0.0.7@2012.08.16@artamir	[+] libA.double_addFilter2()
			@0.0.6@2012.08.15@artamir	[]
			@0.0.5@2012.08.15@artamir	[]
			@0.0.4@2012.08.15@artamir	[]
			@0.0.3@2012.08.15@artamir	[]
			@0.0.2@2012.08.08@artamir	[+] libA.string_eraseArray2()
			@0.0.1@2012.08.08@artamir	[+] libA.double_eraseArray2()
		>Descr:
			lib for working with arrays.
*/

void libA.double_eraseArray2(double &a[][]){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.08.15
		>Hist:
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Библиотека работы с массивами ордеров.
		>VARS:
			&a[][]  :	2 dimensional array
			EM		:	Initialising value 
	*/
	
	//------------------------------------------------------
	ArrayResize(a, 0);
}

void libA.string_eraseArray2(string &a[][]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.08
		>Hist:
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Erasing sting array
			Очищает строковый двумерный массив
		>VARS:
			&a[][]  :	array
			EM		:	Initialising value
	*/
	
	//------------------------------------------------------
	ArrayResize(a, 0);
	
}

void libA.double_PrintArray2(double &a[][], int d = 4, string fn = "PrintArray_"){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.15
		>Hist:
			@0.0.3@2012.08.15@artamir	[]
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Printing array to file.
			Печать массива в файл
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
	fn = fn+i+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
		string s = "";
		for(int idx_2 = 0; idx_2 < COLS; idx_2++){
			s = StringConcatenate(s,"\t", DoubleToStr(a[idx_1][idx_2], d));
			//FileWrite(handle, idx_1, idx_2, DoubleToStr(a[idx_1][idx_2], d));
		}
		FileWrite(handle, s);
	}
	
	if(handle != 0) FileClose(handle);
	
}

#define	libA.SAF.COL		0
#define	libA.SAF.MAX		1
#define	libA.SAF.MIN		2
#define	libA.SAF.OP			3
#define libA.SAF.MAXCOLS	4

double libA.array_Filter[][libA.SAF.MAXCOLS];

void libA.double_eraseFilter2(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.19
		>Hist	:
			@0.0.1@2012.12.19@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	erase filter array
					Очищает массив фильтра
	*/
	ArrayResize(libA.array_Filter, 0);
}


void libA.double_addFilter2(int COL, double max, double min , int op = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.16
		>Hist:
			@0.0.1@2012.08.16@artamir	[]
		>Desc:	
			Add row to filter array
			Добавляем строку к массиву фильтра
	*/
	
	int f.COLS = ArrayRange(libA.array_Filter, 0);
	ArrayResize(libA.array_Filter, f.COLS+1);
	
	//------------------------------------------------------
	libA.array_Filter[f.COLS][libA.SAF.COL] = COL;
	libA.array_Filter[f.COLS][libA.SAF.MAX] = max;
	libA.array_Filter[f.COLS][libA.SAF.MIN] = min;
	libA.array_Filter[f.COLS][libA.SAF.OP ] = op;
}

#define libA.SOP.AND 	1 //Select operation AND
#define libA.SOP.OR		2 //Select operation OR

void libA.double_SelectArray2(double &a[][], double &d[][], int op = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.09.04
		>Hist:
			@0.0.3@2012.09.04@artamir	[*] changes in filter.
			@0.0.2@2012.09.04@artamir	[*] changes in assertion module.
			@0.0.1@2012.09.03@artamir	[*] opperation of assertion is stored in filter.
		>Desc:
			Fill array d[][] with rows from array a[][]
			which have value in range from f[][]
			Заполняет массив d[][] строками из массива a[][]
			значения "колонок" которых удовлетворяет условиям
			фильтров f[][]
		>VARS:
			f[][] : filter array.	[Number of condition][0] = Number of COL from а[][]
									[Number of condition][1] = Min value from а[][]
									[Number of condition][2] = Max value from а[][]
									[Number of condition][3] = Operation of assertion (AND OR)
									
			f[][] : массив фильтра.	[Номер условия][0] = Индекс "колонки" из а[][], начиная с 0
									[Номер условия][1] = Min возможное значение а[][]
									[Номер условия][2] = Max возможное значение а[][]
									[Номер условия][3] = Операция соединения условий (AND OR)						
	*/
	
	
	ArrayResize(d, 0);										//change size of array массив d[][]
	int d.idx = 0;
	//------------------------------------------------------
	int f.ROWS = ArrayRange(libA.array_Filter, 0);			// count of conditions.
	int a.ROWS = ArrayRange(a, 0);							// count of rows of a[ROWS][]
	int a.COLS = ArrayRange(a, 1);							// count of COLS of a[][COLS]
	
	int f.DIGITS = 4;
	int a.DIGITS = 4;
	//------------------------------------------------------
	for(int a.idx = 0; a.idx < a.ROWS; a.idx++){
		bool assert = false;								// результат сравнения;
		
		int iAssert = -1;
		
		//--------------------------------------------------
		for(int f.idx = 0; f.idx < f.ROWS; f.idx++){		// circle on count of conditions
			//----------------------------------------------//
			double f.max = NormalizeDouble(libA.array_Filter[f.idx][libA.SAF.MAX], f.DIGITS);	
			double f.min = NormalizeDouble(libA.array_Filter[f.idx][libA.SAF.MIN], f.DIGITS);
			
			int		f.COL = libA.array_Filter[f.idx][libA.SAF.COL];					// number of column in a[][].
			
			//----------------------------------------------
			double	a.val = NormalizeDouble(a[a.idx][f.COL], a.DIGITS);
			
			//----------------------------------------------
			int		f.OP  = libA.array_Filter[f.idx][libA.SAF.OP]; 
			
			//----------------------------------------------
			if(op != libA.SOP.AND){							//Заглушка, на случай, если где-то использовался метод до 2012.09.03
				f.OP = op;
			}
			
			//----------------------------------------------
			
			if(f.min <= a.val && a.val <= f.max){
				
				//------------------------------------------
				if(f.OP == libA.SOP.AND){
					
					//--------------------------------------
					if(iAssert == -1){						// it is first assertion
						iAssert = 1;
					}	
				}
				
				//------------------------------------------
				if(f.OP == libA.SOP.OR){
					iAssert = 1;
				}
			}else{
				
				//------------------------------------------
				if(f.OP == libA.SOP.AND){					// if op = OR, than we do not change assertion while false.
					iAssert = 0;
				}	
				
				//------------------------------------------
				if(f.OP == libA.SOP.OR){
					if(iAssert == -1){
						iAssert = 0;
					}
				}
			}
			
		}
	
		if(iAssert >= 1){
			d.idx++;
			ArrayResize(d, (d.idx));
			ArrayCopy(d, a, (d.idx-1)*a.COLS, a.idx*a.COLS, a.COLS);
		}
	}
}

void libA.double_SaveToFile2(double &a[][], string fn, int d = 4){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.04
		>Hist:
			@0.0.1@2012.09.04@artamir	[]
		>Desc:
			Save array to file.
			format string for store:
			@idx1_valIdx1@idx2_valIdx2@val_val
			
			exemple: a[43][5] = 20.77
			@idx1_43@idx2_5@val_20.77
			
			Сохраняет массив в файл.
			форматная строка сохранения:
			@idx1_valIdx1@idx2_valIdx2@val_val
			
			Пример: для ячейки двумерного массива с координатами [43][5]
			a[43][5]=20.77
			сохранится строка вида:
			@idx1_43@idx2_5@val_20.77
		>VARS:
			a[][]	- array / массив
			fn		- filename / имя файла
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

void libA.double_ReadFromFile2(double &a[][], string fn){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.04
		>Hist:
			@0.0.1@2012.09.04@artamir	[]
		>Desc:
			Read array from file.
			format string for read:
			@idx1_valIdx1@idx2_valIdx2@val_val
			
			exemple: a[43][5] = 20.77
			@idx1_43@idx2_5@val_20.77
			
			Чтение массива из файла.
			форматная строка чтения:
			@idx1_valIdx1@idx2_valIdx2@val_val
			
			Пример: @idx1_43@idx2_5@val_20.77
					a[43][5] = 20.77
		>VARS:
			a[][]	- array / массив
			fn		- filename / имя файла
	*/	
	
	//------------------------------------------------------
	ArrayResize(a, 0);
	
	//------------------------------------------------------
	int H = FileOpen(fn, FILE_CSV|FILE_READ);
	
	//------------------------------------------------------
	while(!FileIsEnding(H)){
		string str = FileReadString(H);
		int idx1 = libStruc.KeyValue_int(str, "@idx1_");
		int idx2 = libStruc.KeyValue_int(str, "@idx2_");
		double val = libStruc.KeyValue_double(str, "@val_");
		
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

double libA.double_Sum2(double &a[][], int COL = 0, double def = 0.0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.20
		>Hist:
			@0.0.1@2012.09.20@artamir	[]
		>Desc	:
			Sum by one column
			Суммирование по заданной "колонке" двумерного массива 
		>VARS	:	a[][] 	- двумерный массив
					COL		- Индекс "колонки" начиная с 0
					def		- значение по умолчанию
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	
	//------------------------------------------------------
	if(ROWS <= 0) return(def);
	
	//------------------------------------------------------
	double sum = 0;
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){
		sum = sum + a[idx][COL];
	}
	
	//------------------------------------------------------
	return(sum);
}

int libA.double_IndexByMax2(double &a[][], int COL = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.15
		>Hist	:
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return index of ROW with max value in COL
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	
	//------------------------------------------------------
	if(ROWS <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx.max = -1;
	double val.max = -100000000;
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){
		
		double val = a[idx][COL];
		
		//--------------------------------------------------
		if(val > val.max){
			idx.max = idx;
			val.max = val;
		}
	}
	
	//------------------------------------------------------
	return(idx.max);
}

int libA.double_IndexByMin2(double &a[][], int COL = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.15
		>Hist	:
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return index of ROW with min value in COL
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(a, 0);
	
	//------------------------------------------------------
	if(ROWS <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx.min = -1;
	double val.min = 100000000;
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){
		
		double val = a[idx][COL];
		
		//--------------------------------------------------
		if(val < val.min){
			idx.min = idx;
			val.min = val;
		}
	}
	
	//------------------------------------------------------
	return(idx.min);
}

int		A.d.getIndexByProp2(double &d[][], int prop, double val){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.01.16
		>Hist	:
			@0.0.2@2013.01.16@artamir	[]
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Возвращает индекс строки двумерного массива
					с заданным значением колонки или -1 (минус один)
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
		double d.VAL = d[idx][prop];
		
		//--------------------------------------------------
		val = libNormalize.Digits(val);
		
		//--------------------------------------------------
		d.VAL = libNormalize.Digits(d.VAL);
		
		//--------------------------------------------------
		if(d.VAL == val){
			
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

int		A.d.addPropByIndex2(double &d[][], int idx, int prop, double addVal){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.01.16
		>Hist	:
			@0.0.1@2013.01.16@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Устанавливает новое значение ячейки методом добавления к существующему значению
	*/
	
	double oldVal = 0;
	double newVal = 0;
	
	oldVal = d[idx][prop];
	newVal = oldVal+addVal;
	
	d[idx][prop] = newVal;
	
	//------------------------------------------------------
	return(idx);
}

int		A.d.addNewRow2(double &d[][]){
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Добавляем новую строку к массиву.
	*/

	
	int oldRowsCount = ArrayRange(d, 0);
	ArrayResize(d, (oldRowsCount+1));
	
	//------------------------------------------------------
	return(ArrayRange(d,0)-1);								//индекс новой строки.
}
