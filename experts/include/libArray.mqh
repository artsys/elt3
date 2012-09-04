/*
		>Ver	:	0.0.12
		>Date	:	2012.09.04
		>Hist:
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

//==================================================================================================
void libA.double_eraseArray2(double &a[][], double EM = -1.0){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.08.15
		>Hist:
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Ѕиблиотека работы с массивами ордеров.
		>VARS:
			&a[][]  :	2 dimensional array
			EM		:	Initialising value 
	*/
	
	//----------------------------------------------------------------------------------------------
	ArrayInitialize(a, EM);
}//.

//==================================================================================================
void libA.string_eraseArray2(string &a[][], string EM = ""){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.08
		>Hist:
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Erasing sting array
		>VARS:
			&a[][]  :	array
			EM		:	Initialising value
	*/
	
	//----------------------------------------------------------------------------------------------
	for(int idx_1 = 0; idx_1 < ArrayRange(a, 0); idx_1++){
		for(int idx_2 = 0; idx_2 < ArrayRange(a, 1); idx_2++){//..
			a[idx_1][idx_2]	= EM;
		}//.
	}
	
}//.

//==================================================================================================
void libA.double_PrintArray2(double &a[][], int d = 4, string fn = "PrintArray_"){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.15
		>Hist:
			@0.0.3@2012.08.15@artamir	[]
			@0.0.2@2012.08.15@artamir	[]
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Printing array to file.
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
		for(int idx_2 = 0; idx_2 < COLS; idx_2++){
			FileWrite(handle, idx_1, idx_2, DoubleToStr(a[idx_1][idx_2], d));
		}
	}
	
	if(handle != 0) FileClose(handle);
	
}//.

#define	libA.SAF.COL		0
#define	libA.SAF.MAX		1
#define	libA.SAF.MIN		2
#define	libA.SAF.OP			3
#define libA.SAF.MAXCOLS	4

double libA.array_Filter[][libA.SAF.MAXCOLS];

//==========================================================
void libA.double_eraseFilter2(){//..
	ArrayResize(libA.array_Filter, 0);
}//.

//==========================================================
void libA.double_addFilter2(int COL, double max, double min , int op = 1){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.16
		>Hist:
			@0.0.1@2012.08.16@artamir	[]
		>Desc:	
			Add row to filter array
	*/
	int f.COLS = ArrayRange(libA.array_Filter, 0);
	ArrayResize(libA.array_Filter, f.COLS+1);
	
	//------------------------------------------------------
	libA.array_Filter[f.COLS][libA.SAF.COL] = COL;
	libA.array_Filter[f.COLS][libA.SAF.MAX] = max;
	libA.array_Filter[f.COLS][libA.SAF.MIN] = min;
	libA.array_Filter[f.COLS][libA.SAF.OP ] = op;
}//.

//==========================================================
#define libA.SOP.AND 	1 //Select operation AND
#define libA.SOP.OR		2 //Select operation OR

//==========================================================
void libA.double_SelectArray2(double &a[][], double &d[][], int op = 1){//..
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
		>VARS:
			f[][] : filter array.	[Number of condition][0] = Number of COL from а[][]
									[Number of condition][1] = Min value from а[][]
									[Number of condition][2] = Max value from а[][]
									[Number of condition][3] = Operation of assertion (AND OR)
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
		bool assert = false;								// результат сравнени€;
		
		int iAssert = -1;
		
		//--------------------------------------------------
		for(int f.idx = 0; f.idx < f.ROWS; f.idx++){//..	// circle on count of conditions
			//----------------------------------------------//
			double f.max = NormalizeDouble(libA.array_Filter[f.idx][libA.SAF.MAX], f.DIGITS);	
			double f.min = NormalizeDouble(libA.array_Filter[f.idx][libA.SAF.MIN], f.DIGITS);
			
			int		f.COL = libA.array_Filter[f.idx][libA.SAF.COL];					// number of column in a[][].
			
			//----------------------------------------------
			double	a.val = NormalizeDouble(a[a.idx][f.COL], a.DIGITS);
			
			//----------------------------------------------
			int		f.OP  = libA.array_Filter[f.idx][libA.SAF.OP]; 
			
			//----------------------------------------------
			if(op != libA.SOP.AND){							//«аглушка, на случай, если где-то использовалс€ метод до 2012.09.03
				f.OP = op;
			}
			
			//----------------------------------------------
			
			if(f.min <= a.val && a.val <= f.max){//..
				
				//------------------------------------------
				if(f.OP == libA.SOP.AND){//..
					
					//--------------------------------------
					if(iAssert == -1){//..					// it is first assertion
						iAssert = 1;
					}//.	
				}//.
				
				//------------------------------------------
				if(f.OP == libA.SOP.OR){//..
					iAssert = 1;
				}//.
			}else{
				
				//------------------------------------------
				if(f.OP == libA.SOP.AND){//..				// if op = OR, than we do not change assertion while false.
					iAssert = 0;
				}//.	
				
				//------------------------------------------
				if(f.OP == libA.SOP.OR){//..
					if(iAssert == -1){//..
						iAssert = 0;
					}//.
				}//.
			}//.
			
		}//.
	
		if(iAssert >= 1){//..
			d.idx++;
			ArrayResize(d, (d.idx));
			ArrayCopy(d, a, (d.idx-1)*a.COLS, a.idx*a.COLS, a.COLS);
		}//.
	}
}//.

//==========================================================
void libA.double_SaveToFile2(double &a[][], string fn, int d = 4){//..
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
		>VARS:
			a[][]	- array
			fn		- filename
			d		- количество знаков после зап€той.
	*/	
	
	int ROWS = ArrayRange(a, 0);
	int COLS = ArrayRange(a, 1);
	
	int H = FileOpen(fn, FILE_CSV|FILE_WRITE);
	
	//------------------------------------------------------
	for(int idx1 = 0; idx1 < ROWS; idx1++){//..
		
		//--------------------------------------------------
		for(int idx2 = 0; idx2 < COLS; idx2++){//..
			
			//----------------------------------------------
			string str = "@idx1_"+idx1
						+"@idx2_"+idx2
						+"@val_"+DoubleToStr(a[idx1][idx2], d);
						
			//----------------------------------------------
			FileWrite(H, str);
		}//.
	}//.
	
	//------------------------------------------------------
	FileFlush(H);
	
	//------------------------------------------------------
	FileClose(H);
	
}//.

//==========================================================
void libA.double_ReadFromFile2(double &a[][], string fn){//..
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
		>VARS:
			a[][]	- array
			fn		- filename
	*/	
	
	//------------------------------------------------------
	ArrayResize(a, 0);
	
	//------------------------------------------------------
	int H = FileOpen(fn, FILE_CSV|FILE_READ);
	
	//------------------------------------------------------
	while(!FileIsEnding(H)){//..
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
	}//.
}//.

//+------------------------------------------------------------------+
//|                                                      ArrayEx.mq4 |
//|                                                             amba |
//|                                                                  |
//+------------------------------------------------------------------+
#property stacksize 32767

#define MODE_QUICK3 0
#define MODE_QUICK3N 1


void Array.Sort(double &a[],int order[],int sort.mode=MODE_QUICK3)
{
    if(sort.mode==MODE_QUICK3)
        Array.Sort.Quick3(a,0,ArrayRange(a,0)-1,order);
        //quicksort(a,0,ArrayRange(a,0)-1,order);
    else if(sort.mode==MODE_QUICK3N)
        Array.Sort.quicksort(a,0,ArrayRange(a,0)-1,order);
}


//   http://www.sorting-algorithms.com/quick-sort-3-way
void Array.Sort.Quick3(double & a[][],int s, int n,int &order[])
{
    if(n<=s) return(0);

    // choose pivot
    Array.Swap(a,n,(s+n+1)/2);

    // 3-way partition
    int i = s, k = s, p = n;
    while (i < p)
    {
        int cmpr=Array.Compare(a,i,n,order);
        if (cmpr<0)         {Array.Swap(a,i,k); i++; k++;}
        else if (cmpr==0)   {p--; Array.Swap(a,i,p);}
        else                i++;
    }

    // move pivots to center
    int m = MathMin(p-k,n-p+1);
    
    int j1=k, j2=n-m+1;
    while(j1<k+m && j2<n+1)
    {
        Array.Swap(a,j1,j2);
        j1++;j2++;
    }

    // recursive sorts
    Array.Sort.Quick3(a,s,k-1,order);
    Array.Sort.Quick3(a,n-p+k+1,n,order);
}

void quicksort(double &a[][], int l, int r, int & order[])
{
    int i = l-1, j = r;
    if (r <= l) return;

    // choose pivot
    Array.Swap(a,l,(l+r+1)/2);

    for (;;)
    { 
        while (i < r) { i++; if(Array.Compare(a,r,i,order)<0) break; }
        while (j > l) { j--; if(Array.Compare(a,r,j,order)<0) break; }
        if (i >= j) break;
        Array.Swap(a, i, j);
    } 
    Array.Swap(a, i, r);
    quicksort(a, l, i-1, order);
    quicksort(a, i+1, r, order);
}

void Array.Swap(double & a[][],int i1, int i2)
{
    if(i1==i2) return(0); //||MathMin(i1,i2)<0||MathMax(i1,i2)>ArrayRange(a,0)) return(0);
    double prom=0;
    for(int i=0;i<ArrayRange(a,1);i++)
    {
        prom=a[i1][i];
        a[i1][i]=a[i2][i];
        a[i2][i]=prom;
    }
}

int Array.Compare(double & a[][],int i1, int i2,int &order[])
{
    int col=0,sign=0;
    for(int i=0;i<ArraySize(order);i++)
    {
        col=order[i];
        if(col>0) sign=1;
        if(col<0) sign=-1;
        col=MathAbs(col)-1;
        
        if     (a[i1][col]>a[i2][col]) return(sign);
        else if(a[i1][col]<a[i2][col]) return(-sign);
    }
    return(0);
}  

void Array.Group(double &a[][],int groups[],int sums[],double &dest[][])
{
    int ng=ArraySize(groups),ns=ArraySize(sums),nc=ng+ns;

    if(ArraySize(a)==0
    ||ArrayDimension(a)!=2
    ||ArrayDimension(dest)!=2
    ||ArrayRange(a,1)<nc
    ||ArrayRange(dest,1)<nc)
        return;
    
    Array.Sort(a, groups);
    
    int dest_cnt=1, currow=0, curcol=0;
    
    ArrayResize(dest,dest_cnt);
    ArrayInitialize(dest,0);
    
    for(int i=0;i<ng;i++)
    {
        curcol=MathAbs(groups[i])-1;
        dest[currow][i]=a[currow][curcol];
    }
    
    for(i=ng;i<nc;i++)
    {
        curcol=MathAbs(sums[(i-ng)])-1;
        dest[currow][i]=a[currow][curcol];
    }
    
    for(int r=1;r<ArrayRange(a,0);r++)
    {
        if(Array.Compare(a,r-1,r,groups)!=0)
        {
            dest_cnt++;currow++;
            ArrayResize(dest,dest_cnt);
            
            for(i=0;i<ng;i++)
            {
                curcol=MathAbs(groups[i])-1;
                dest[currow][i]=a[r][curcol];
            }
        }
        
        for(i=ng;i<nc;i++)
        {
            curcol=MathAbs(sums[(i-ng)])-1;
            dest[currow][i]+=a[r][curcol];
        }
    }
}

int Array.Select(double &a[][], double & filter[][], double & dest[][]){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.15
	>Hist:
			@0.0.1@2012.08.15@artamir	[]
	>Desc:
	>Vars:
		a[][]:¬ходной массив
		filter[][0] = Ќомер колонки+1
		filter[][1] = Min выбора
		filter[][2] = Max выбора
		dest[][] : ¬ыходной массив.
	*/

    if(ArrayRange(a,1)!=ArrayRange(dest,1))
         return(0);
         
    ArrayResize(dest,0);

    int col=0, rstart=0, rend=0;
    bool equal=false;
    for(int r=0;r<ArrayRange(a,0);r++)
    {
        equal=false;
        for(int i=0;i<ArrayRange(filter,0);i++)
        {
            col=filter[i][0]-1;
            
            if((a[r][col]<filter[i][1])||(a[r][col]>filter[i][2]))
                {equal=false;break;}
            else    equal=true;
        }
        
        if(equal)
            ArrayCopy(dest,a,ArraySize(dest),r*ArrayRange(a,1),ArrayRange(a,1));
    }
}

// http://www.sorting-algorithms.com/static/QuicksortIsOptimal.pdf
void Array.Sort.quicksort(double & a[], int l, int r, int &order[])
{ 
    int i = l-1, j = r, p = l-1, q = r; 
    
    if (r <= l) return;
    
    // choose pivot
    Array.Swap(a,l,(l+r+1)/2);

    for (;;)
    { 
        while (i<r) { i++; if(Array.Compare(a, i, r, order) >= 0) break; }
        while (j>l) { j--; if(Array.Compare(a, r, j, order) >= 0) break; }
        
        if (i >= j) break;
  
        Array.Swap(a,i,j);
  
        if (Array.Compare(a, i, r, order) == 0) { p++; Array.Swap(a, p, i); }
        if (Array.Compare(a, r, j, order) == 0) { q--; Array.Swap(a, j, q); }
    } 
 
    Array.Swap(a, i, r); j = i-1; i = i+1;
 
    for (int k = l; k < p; k++, j--) Array.Swap(a, k, j);
    for (  k = r-1; k > q; k--, i++) Array.Swap(a, i, k);
 
    Array.Sort.quicksort(a, l, j, order);
    Array.Sort.quicksort(a, i, r, order);
}


