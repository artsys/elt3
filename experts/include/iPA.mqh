	/*
		>Ver	:	0.0.5
		>Date	:	2012.12.20
		>Hist	:
			@0.0.5@2012.12.20@artamir	[]
			@0.0.4@2012.12.20@artamir	[]
			@0.0.3@2012.12.19@artamir	[]
			@0.0.2@2012.12.19@artamir	[]
			@0.0.1@2012.12.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
bool iPA.IsMH(int left = 1, int right = 1, int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.14
		>Hist	:
			@0.0.1@2012.12.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	���������� true, ���� ��� ��������� ����
					����� ���� left ����� ����� � right �����
					������.
		>VARS	:	left - ���������� ����� �����
				:	right - ���������� ����� ������
				:	shift - ����� ������������ ����
	*/
	
	//------------------------------------------------------
	if(shift <= right){
		return(false);										// ��������� ���������� ����� ������
															// ��� ����������� �������������� ���.
	}
	
	//------------------------------------------------------
	if(shift >= Bars - left){
		return(false);										// ��������� ���������� ����� �����
															// ��� ����������� �������������� ���
	}
	
	//------------------------------------------------------
	double h = iHigh(NULL, 0, shift);
	bool is.mh = true;
	
	int idx = shift;
	//------------------------------------------------------
	while(idx <= shift+left && is.mh){
		double hl = iHigh(NULL, 0, idx);					//����� ���
		
		if(h != hl){
			is.mh = false;
		}
		idx++;
	}
	
	//------------------------------------------------------
	idx = shift;
	while(idx >= shift-right && is.mh){						
		double hr = iHigh(NULL, 0, idx);					//������ ���
		
		if(h != hr){
			is.mh = false;
		}
		idx--;
	}
	
	return(is.mh);
}	

bool iPA.IsML(int left = 1, int right = 1, int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.14
		>Hist	:
			@0.0.1@2012.12.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	���������� true, ���� ��� ��������� ����
					����� ��� left ����� ����� � right �����
					������.
		>VARS	:	left - ���������� ����� �����
				:	right - ���������� ����� ������
				:	shift - ����� ������������ ����
	*/
	
	//------------------------------------------------------
	if(shift <= right){
		return(false);										// ��������� ���������� ����� ������
															// ��� ����������� �������������� ���.
	}
	
	//------------------------------------------------------
	if(shift >= Bars - left){
		return(false);										// ��������� ���������� ����� �����
															// ��� ����������� �������������� ���
	}
	
	//------------------------------------------------------
	double l = iLow(NULL, 0, shift);
	bool is.ml = true;
	
	int idx = shift;
	//------------------------------------------------------
	while(idx <= shift+left && is.ml){
		double ll = iLow(NULL, 0, idx);						//����� ���
		
		if(l != ll){
			is.ml = false;
		}
		idx++;
	}
	
	//------------------------------------------------------
	idx = shift;
	while(idx >= shift-right && is.ml){						
		double lr = iLow(NULL, 0, idx);						//������ ���
		
		if(l != lr){
			is.ml = false;
		}
		idx--;
	}
	
	return(is.ml);
}	

bool iPA.IsTH(int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.19
		>Hist	:
			@0.0.1@2012.12.19@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	���������� true ���� High �� ��������� 
					�������� �������� ������� ����.
	*/
	
	//------------------------------------------------------
	return(iPA.IsMH(1,1,shift));
}

bool iPA.IsTL(int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.19
		>Hist	:
			@0.0.1@2012.12.19@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	���������� true ���� Low �� ��������� 
					�������� �������� ������� ���.
	*/
	
	//------------------------------------------------------
	return(iPA.IsML(1,1,shift));
}

bool iPA.IsOB(int shift = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.20
		>Hist	:
			@0.0.1@2012.12.20@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	���������, ���� �������� ��� �������� �������.
					�������. �������� � ������� ����������� ����
					��������� � �������� ��������� � �������� 
					������������ ����.
	*/
	
	double res = false;
	
	//------------------------------------------------------
	double tH = iHigh(NULL, 0, shift);						//this High
	double pH = iHigh(NULL, 0, shift+1);					//prev. High
	
	double tL = iLow(NULL, 0, shift);						//this Low
	double pL = iLow(NULL, 0, shift+1);						//prev. Low
	
	//------------------------------------------------------ 
	if(pH < tH && pL > tL){
		return(true);
	}
	
	//------------------------------------------------------
	return(res);
}

bool iPA.IsOBU(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.20
		>Hist	:
			@0.0.1@2012.12.20@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	��������� ���� ������� ��� �������� ������.
					�������. ��� ������������ ���� ������ ���� 
					�������� ���� ��������, � ��� ����������� 
					���� ������ ���� �������� ���� ��������.
	*/
	
	bool res = false;
	
	//------------------------------------------------------
	double tO = iOpen(NULL, 0, shift);
	double pO = iOpen(NULL, 0, shift+1);
	
	double tC = iClose(NULL, 0, shift);
	double pC = iClose(NULL, 0, shift+1);
	
	//------------------------------------------------------
	if(!iPA.IsOB(shift)){
		return(false);										//��� �� ������� ���
	}
	
	//------------------------------------------------------
	if(tC > tO && pC < pO){
		return(true);
	}
	//------------------------------------------------------
	return(res);
}

bool iPA.IsOBD(int shift){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.12.20
		>Hist	:
			@0.0.1@2012.12.20@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	��������� ���� ������� ��� �������� ���������.
					�������. ��� ������������ ���� ������ ���� 
					�������� ���� ��������, � ��� ����������� 
					���� ������ ���� �������� ���� ��������.
	*/
	
	bool res = false;
	
	//------------------------------------------------------
	double tO = iOpen(NULL, 0, shift);
	double pO = iOpen(NULL, 0, shift+1);
	
	double tC = iClose(NULL, 0, shift);
	double pC = iClose(NULL, 0, shift+1);
	
	//------------------------------------------------------
	if(!iPA.IsOB(shift)){
		return(false);										//��� �� ������� ���
	}
	
	//------------------------------------------------------
	if(tC < tO && pC > pO){
		return(true);
	}
	//------------------------------------------------------
	return(res);
}