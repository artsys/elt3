	/**
		\version	0.0.1.0
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:								
					 @0.0.0.9@2013.07.25@artamir	[]	iSth_Cross
					 @0.0.0.8@2013.07.25@artamir	[]	iSth_get
					 @0.0.0.7@2013.07.25@artamir	[]	iSth_get
					 @0.0.0.6@2013.07.25@artamir	[]	iSth_get+ST_MODE_AVG
					 @0.0.0.5@2013.07.25@artamir	[]	aSth_set
					 @0.0.0.4@2013.07.17@artamir	[]	iSth_getArray
					 @0.0.0.3@2013.07.17@artamir	[]	iSth_CrossMainSignal
					 @0.0.0.2@2013.07.17@artamir	[]	iSth_Cross
			>Rev:0
			>�����������:
			#include <sysOther.mqh>
			#include <sysNormalize.mqh>
			#include <sysStructure.mqh>
	*/

#define ST_MODE_AVG		10	//=(Main+Signal)/2 :)
	
string aStSets[];

void aSth_Init(){
	/**
		\version	0.0.0.0
		\date		2013.05.20
		\author		Morochin <artamir> Artiom
		\details	������� ���������� ������. ������������ ��� ������ ������� �-��� �����
		\internal
			>Hist:
			>Rev:0
	*/

	ArrayResize(aStSets,0);
}

/*

symbol   -   ���������� ��� �����������, �� ������ �������� ����� ����������� ���������. NULL �������� ������� ������. 
timeframe   -   ������. ����� ���� ����� �� �������� �������. 0 �������� ������ �������� �������. 
%Kperiod   -   ������(���������� �����) ��� ���������� ����� %K. 
%Dperiod   -   ������ ���������� ��� ���������� ����� %D. 
slowing   -   �������� ����������. 
method   -   ����� ����������. ����� ���� ����� �� �������� ������� ����������� �������� (Moving Average). 
price_field   -   �������� ������ ��� ��� �������. ����� ���� ����� �� ��������� �������: 0 - Low/High ��� 1 - Close/Close. 
mode   -   ������ ����� ����������. ����� ���� ����� �� �������� ��������������� ����� �����������. 
shift   -   ������ ����������� �������� �� ������������� ������ (����� ������������ �������� ���� �� ��������� ���������� �������� �����). 

*/

int aSth_set(		int k		= 5			/** %Kperiod 	*/
				, 	int d		= 3			/** %Dperiod 	*/
				,	int sl		= 3			/** slowing 	*/
				,	int me		= MODE_SMA	/** method 		*/
				,	int pr		= 0			/** price_field */
				,	string sy	= ""		/** symbol 		*/
				,	int	tf		= 0			/** timeframe	*/
				,	int shift	= 0			/** shift 		*/){
	/**
		\version	0.0.0.3
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	��������� ��������� ���������� � ������ ��������. ���������� ������ ��������� � �������.
		\internal
			>Hist:			
					 @0.0.0.3@2013.07.25@artamir	[+]	��������� ��������� ����������
			>Rev:0
	*/

	int ROWS = ArrayRange(aStSets,0);
	ROWS++;
	int lastROW=ROWS-1;
	ArrayResize(aStSets, ROWS);
	
	if(sy == ""){
		sy=Symbol();
	}
	
	string s = "";
	s=s+"@k"+k;
	s=s+"@d"+d;
	s=s+"@sl"+sl;
	s=s+"@pr"+pr;
	s=s+"@me"+me;
	s=s+"@sy"+sy;
	s=s+"@tf"+tf;
	s=s+"@sh"+shift;
	
	aStSets[lastROW]=s;
	return(lastROW);
}

double iSth_get(int handle=0, int line=MODE_MAIN, int shift=-1, int dgt=0, bool useSinhro = true /** ������������ ������������� �����������. */){
	/**
		\version	0.0.0.5
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	���������� ���� �������� ����� ���������� �� ��������� ������� � ������� �������� � ������� ����.
					������������� �������� ���������� �� ������� ���� � �������� �������� �� ������� ������.
		\internal
			>Hist:					
					 @0.0.0.5@2013.07.25@artamir	[*]	������������� � �� ��������� �� ��������. 
					 @0.0.0.4@2013.07.25@artamir	[*]	��������� ��������� � ST_MODE_AVG	
					 @0.0.0.3@2013.07.25@artamir	[*]	��������� ��������� tf.
			>Rev:0
	*/

	int 	k	= Struc_KeyValue_int(aStSets[handle]	, "@k");
	int 	d	= Struc_KeyValue_int(aStSets[handle]	, "@d");
	int 	sl	= Struc_KeyValue_int(aStSets[handle]	, "@sl");
	double 	pr 	= Struc_KeyValue_double(aStSets[handle]	, "@pr");
	int 	me	= Struc_KeyValue_int(aStSets[handle]	, "@me");
	string 	sy 	= Struc_KeyValue_string(aStSets[handle]	, "@sy");
	int 	tf 	= Struc_KeyValue_int(aStSets[handle]	, "@tf");
	
	int sh 		= shift;
	if(sh<=-1){
		sh = Struc_KeyValue_int(aStSets[handle], "@sh");
	}
	
	
	if(useSinhro){
		if(tf != Period()){
			sh = iBarShift(sy, tf, iTime(sy, 0, sh));
		}
	}
	
	double stoh = 0.0;
	if(line == ST_MODE_AVG){
		stoh = (iStochastic(sy,tf,k,d,sl,me,pr,MODE_MAIN,sh) + iStochastic(sy,tf,k,d,sl,me,pr,MODE_SIGNAL,sh))/2;
	}else{
		stoh = iStochastic(sy,tf,k,d,sl,me,pr,line,sh);
	}
	
	stoh = Norm_symb(stoh, "", dgt); 
	return(stoh);
}

int iSth_getArray(int h, double &a[], int l=MODE_MAIN, int shift = -1, double def=-1/** ���� > -1, �� ��������� ������ ���������� ���������*/){
	/**
		\version	0.0.0.1
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	���������� ������ ����� ���������� �� 3-� ���������.
		\internal
			>Hist:	
					 @0.0.0.1@2013.07.17@artamir	[]	iSth_getArray
			>Rev:0
	*/

	ArrayResize(a,0);	//�������� ������.
	int ROWS = 0;		//��������� ���������� ���������.
	
	for(int i = shift-1; i<= shift+1; i++){
		ROWS++;
		ArrayResize(a,ROWS);
		if(def==-1){
				a[ROWS-1]=iSth_get(h, l, i);
		}else{
			a[ROWS-1]=def;
		}	
	}
	
	return(ROWS);
}

//{ === ������ � ������������ �����.
#define ST_CRNONE	0
#define ST_CRUP	1
#define ST_CRDW	2

int iSth_Cross(		double &f[] /** ������� ������   */
				,	double &s[] /** ��������� ������ */
				, 	int shift=2 /** ������ ���� ��� �������� ����������� */){
	/**
		\version	0.0.0.2
		\date		2013.07.25
		\author		Morochin <artamir> Artiom
		\details	����������, ���� �� �� ���� � �������� �������� ����������� �������� �������� � ���������� �������
					���������� ������ �����������. (0: ��� �����������, 1: ����������� ����� �����, 2: ����������� ������ ����)
		\internal
			>Hist:		
					 @0.0.0.2@2013.07.25@artamir	[]	���������� �����������.
					 @0.0.0.1@2013.07.17@artamir	[]	iSth_Cross
			>Rev:0
	*/

	double f3=Norm_symb(f[shift+1],"",2), f2=Norm_symb(f[shift],"",2), f1=Norm_symb(f[shift-1],"",2);
	double s3=Norm_symb(s[shift+1],"",2), s2=Norm_symb(s[shift],"",2), s1=Norm_symb(s[shift-1],"",2);
	
	int status = ST_CRNONE;
	
	if(f3<s3 && f2>s2){
		status = ST_CRUP;
	}
	
	if(f3>s3 && f2<s2){
		status = ST_CRDW;
	}
	
	if(f2==s2){
		if(f3<s3 && f1>s1){
			status = ST_CRUP;
		}
		
		if(f3>s3 && f1<s1){
			status = ST_CRDW;
		}
	}
	
	return(status);
	
}

int iSth_CrossMainSignal(int h, int shift = 1){
	/**
		\version	0.0.0.1
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	���������, ���� �� ���� � �������� �������� ���� ����������� ������� � ���������� �����
		\internal
			>Hist:	
					 @0.0.0.1@2013.07.17@artamir	[]	iSth_CrossMainSignal
			>Rev:0
	*/

	double f[];
	double s[];
	
	int ROWS_f = iSth_getArray(h, f, MODE_MAIN,   shift);
	int ROWS_s = iSth_getArray(h, s, MODE_SIGNAL, shift);
	return(iSth_Cross(f,s,1));
}

int iSth_CrossMainLevel(int h, int l=80 /** exemple 80*/, int shift=1){
	/**
		\version	0.0.0.0
		\date		2013.07.17
		\author		Morochin <artamir> Artiom
		\details	����������� �������� ����� � �������� �������
		\internal
			>Hist:
			>Rev:0
	*/

	double f[];
	double s[];
	
	int ROWS_f = iSth_getArray(h, f, MODE_MAIN,   shift);
	int ROWS_s = iSth_getArray(h, s, 0, 0, l);
	return(iSth_Cross(f,s,1));
	
}
//}

