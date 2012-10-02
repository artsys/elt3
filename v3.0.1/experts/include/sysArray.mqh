	/*
		>Ver	:	0.0.9
		>Date	:	2012.10.02
		>Hist	:
			@0.0.9@2012.10.02@artamir	[]
			@0.0.8@2012.10.02@artamir	[]
			@0.0.7@2012.10.02@artamir	[]
			@0.0.6@2012.10.02@artamir	[]
			@0.0.5@2012.10.02@artamir	[]
			@0.0.4@2012.10.02@artamir	[]
			@0.0.3@2012.10.02@artamir	[]
			@0.0.2@2012.10.02@artamir	[]
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	function to work with arrays
		>Pref	:	A
				:	d - for double arrays
	*/

//==========================================================
//..	//=== TEMPORAR ARRAY

//==========================================================
double	dArrayTemp2[];	// double temporar 2 dim array
int		dArrayTemp2.COLS = 0;

//==========================================================
void A.d.setArray(double &d[][]){//..
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
	A.d.eraseArray2(dArrayTemp2);
	
	//------------------------------------------------------
	A.d.Copy2To1(d, dArrayTemp2);
}//.

//==========================================================
int	A.d.addRow(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Add new row to temporar array
	*/
	
	string fn = "A.d.addRow";
	
	//------------------------------------------------------
	int ROWS = ArrayRange(dArrayTemp2, 0);
	int newSize = ROWS+dArrayTemp2.COLS;
	
	//BP(fn, "ROWS = ", ROWS, "newSize = ", newSize);
	//------------------------------------------------------
	ArrayResize(dArrayTemp2, newSize);
	
	//BP(fn, "ArrayRange = ", ArrayRange(dArrayTemp2, 0), "ArrayRange(dArrayTemp2, 0)/dArrayTemp2.COLS = ",ArrayRange(dArrayTemp2, 0)/dArrayTemp2.COLS - 1);
	//------------------------------------------------------
	return(ArrayRange(dArrayTemp2, 0)/dArrayTemp2.COLS - 1);
}//.

//==========================================================
void A.d.setPropByIndex(int idx, int prop, int val){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	set property value by index to temporar array
	*/
	
	//------------------------------------------------------
	string fn = "A.d.setPropByIndex";
	
	//------------------------------------------------------
	dArrayTemp2[(idx*dArrayTemp2.COLS)+prop] = val;
	
	//------------------------------------------------------
	if(Debug){//..
		//A.d.PrintArray1(dArrayTemp2, 4, fn);
	}//.	
}//.

//==========================================================
void A.d.releaseArray(double &d[][]){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.10.02
		>Hist	:
			@0.0.3@2012.10.02@artamir	[]
			@0.0.2@2012.10.02@artamir	[]
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	copy temporar array to d[][] and erase temporar array
	*/
	
	//------------------------------------------------------
	string fn = "A.d.releaseArray";
	
	//------------------------------------------------------
	A.d.eraseArray2(d);
	
	//------------------------------------------------------
	//ArrayCopy(d, dArrayTemp2, 0, 0, WHOLE_ARRAY);
	
	A.d.Copy1To2(dArrayTemp2, d, dArrayTemp2.COLS);
	
	//double dTemp[];
	//ArrayCopy(dTemp, dArrayTemp2, 0, 0, WHOLE_ARRAY);
	//------------------------------------------------------
	A.d.eraseArray2(dArrayTemp2);
	
	//------------------------------------------------------
	if(Debug){//..
		//A.d.PrintArray2(d, 4, fn);
		//A.d.PrintArray1(dTemp, 4, fn);
	}//.
}//.

//.

//==========================================================
//..	//=== ARRAY FUNCTIONS	============================

//==========================================================
void	A.d.eraseArray2(double	&d[][]){//..
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
}//.

//==========================================================
void	A.d.Copy1To2(double &s[], double &d[][], int d.COLS = 1){//..
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
	int COLS = d.COLS;	//destination COUMNS
	
	for(int idx = 0; idx < s.ROWS; idx++){//..
		
		//--------------------------------------------------
		int idx_1 = MathFloor(idx/COLS);
		int idx_2 = idx - idx_1*COLS;
		
		//--------------------------------------------------
		int d.ROWS = ArrayRange(d, 0);
		
		//--------------------------------------------------
		if(d.ROWS <= idx_1){//..
			ArrayResize(d, (idx_1+1));
		}//.
		
		//--------------------------------------------------
		d[idx_1][idx_2] = s[idx];
	}//.
}//.

//==========================================================
void	A.d.Copy2To1(double &s[][], double &d[]){//..
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
	int d.idx	= 0;	
	
	//------------------------------------------------------
	for(int idx_1 = 0; idx_1 < s.ROWS; idx_1++){//..
		
		for(int idx_2 = 0; idx_2 < s.COLS; idx_2++){//..
		
			//----------------------------------------------
			double val = s[idx_1][idx_2];
			
			//----------------------------------------------
			int d.ROWS = ArrayRange(d, 0);
			
			//----------------------------------------------
			if(d.ROWS <= d.idx){//..
				ArrayResize(d, d.idx+1);
			}//.
			
			//----------------------------------------------
			d[d.idx] = val;
			
			//----------------------------------------------
			d.idx++;
		}//.
	}//.
}//.
//.

//==========================================================
//..	//=== FOR DEBUGING

//==========================================================
void A.d.PrintArray2(double &a[][], int d = 4, string fn = "PrintArray_"){//..
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

//==========================================================
void A.d.PrintArray1(double &a[], int d = 4, string fn = "PrintArray_"){//..
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
	
	//------------------------------------------------------
	fn = fn+i+".arr";
	
	//------------------------------------------------------
	int handle = FileOpen(fn, FILE_CSV|FILE_WRITE, "\t");
	
	for(int idx_1 = 0; idx_1 < ROWS; idx_1++){
			FileWrite(handle, idx_1, DoubleToStr(a[idx_1], d));
	}
	
	if(handle != 0) FileClose(handle);
	
}//.

//.