	/**
		\version	0.0.0.10
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	Работа с объектами.
		\internal
			>Hist:										
					 @0.0.0.10@2013.08.06@artamir	[+]	aObj_init
					 @0.0.0.9@2013.08.05@artamir	[*]	aObj_find
					 @0.0.0.8@2013.08.05@artamir	[*]	OBJ_CreateTable
					 @0.0.0.7@2013.08.05@artamir	[+]	OBJ_DrawTable
					 @0.0.0.6@2013.08.05@artamir	[+]	aObj_find
					 @0.0.0.5@2013.08.05@artamir	[+]	aObj_set
					 @0.0.0.4@2013.08.05@artamir	[*]	OBJ_CreateTable
					 @0.0.0.3@2013.08.05@artamir	[*]	OBJ_CreateTable
					 @0.0.0.2@2013.08.02@artamir	[+]	OBJ_CreateWithCheck
					 @0.0.0.1@2013.08.02@artamir	[+]	OBJ_CreateTable
			>Rev:0
	*/

#define OBJ_TABLE	100

string aObjSets[];

void aObj_init(){
	/**
		\version	0.0.0.1
		\date		2013.08.06
		\author		Morochin <artamir> Artiom
		\details	инициализация массива-хранилища настроек.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.06@artamir	[]	aObj_init
			>Rev:0
	*/

	ArrayResize(aObjSets,0);
}

int aObj_set(string param, int idx = -1){
	/**
		\version	0.0.0.1
		\date		2013.08.05
		\author		Morochin <artamir> Artiom
		\details	Устанавливает заданый параметр в заданный индекс массива-хранилища параметров.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.05@artamir	[+]	aObj_set
			>Rev:0
	*/

	int row_idx= idx;
	if(idx == -1){
		int ROWS = ArrayRange(aObjSets,0);
		row_idx = ROWS;
		ArrayResize(aObjSets, (ROWS+1));
	}
	
	aObjSets[row_idx] = param;
	
	return(row_idx);
}

string aObj_find(string val="", int idx = -1){
	/**
		\version	0.0.0.2
		\date		2013.08.05
		\author		Morochin <artamir> Artiom
		\details	Возвращает первый найденый параметр, содержащий последовательность символов val или пустую строку.
					Если idx > -1, то возвращается параметр, заданный в этой ячейке.
		\internal
			>Hist:		
					 @0.0.0.2@2013.08.05@artamir	[*]	aObj_find
					 @0.0.0.1@2013.08.05@artamir	[+]	aObj_find
			>Rev:0
	*/

	if(idx >= 0){
		return(aObjSets[idx]);
	}
	
	int ROWS = ArrayRange(aObjSets,0);
	for(int i=0; i<ROWS; i++){
		string param = aObjSets[i];
		if(StringFind(param, val) > -1){
			return(param);
		}
	}
	
	return("");
}
	
int OBJ_CreateTable(string table_name, string &a[][], string params="@co0@vr5"){
	/**
		\version	0.0.0.4
		\date		2013.08.05
		\author		Morochin <artamir> Artiom
		\details	Создает визуальную таблицу с заданным именем
		\internal
			>Hist:				
					 @0.0.0.4@2013.08.05@artamir	[*]	Рисование таблицы вынесено в отдельную процедуру
					 @0.0.0.3@2013.08.05@artamir	[*]	Расчет высоты в зависимости от угла привязки
					 @0.0.0.2@2013.08.05@artamir	[+]	параметр - угол привязки.
			>Rev:0
			>VARS:
					table_name - имя таблицы в массиве объектов.
					a[][] - строковой массив, на основе которого будет создана таблица
							в 0-й строке заголовки столбцов.
							в 0-х элементах строк параметры отображения данных строки.
					params - строковая структура, содержащая параметры таблицы.
					@vr = высота отображаемой таблицы в строках.
					@co = угол привязки (0-верхний левый,1-верхний правый,2,3) по умолчанию возвращается верхний левый угол.
	*/

	
	
	int idx = aObj_set("@tn"+table_name+params);
	
	OBJ_DrawTable(table_name, a);
	
	return(idx);
} 	

string OBJ_DrawTable(string table_name, string &a[][]){
	/**
		\version	0.0.0.1
		\date		2013.08.05
		\author		Morochin <artamir> Artiom
		\details	Рисует таблицу. Параметры берутся из массива параметров объектов.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.05@artamir	[+]	OBJ_DrawTable
			>Rev:0
			>Описание:
				общие параметры таблицы задаются в OBJ_CreateTable()
				Параметры строки задаются в 0-м элементе строки
				Параметры колонки задаются в соответствующей колонке в нулевой строке
				
				Используемые параметры:
				Для строки: 
					@clr - цвет задается строкой с названием цвета.
				Для колонки:
					@alg - выравнивание: r - право (левая часть дополняется пробелами), l - лево (правая часть дополняется пробелами)
	*/
	
	string params = aObj_find("@tn"+table_name);
	
	int ROWS = ArrayRange(a,0);
	int COLS = ArrayRange(a,1);
	
	string ne = "";
	int max_len = 0;
	string te = ""; //thiselement
	string tr = "";	//thisrow
	
	//Настройки таблицы
	int vr = Struc_KeyValue_int(params, "@vr")+1;
	int co = Struc_KeyValue_int(params, "@co",0);
	
	if(vr>ROWS){
		ArrayResize(a,(vr));
	}
	
	A_s_PrintArray2(a,"a_");
	int max_row = vr;
	
	for(int r=1; r<max_row; r++){
		ne = table_name+"R"+r;
		tr = "";
		OBJ_CreateWithCheck(ne, OBJ_LABEL);
		for(int c=1; c<COLS; c++){
			max_len = A_s_MaxLen2(a,c);
			max_len = max_len;
			
			string salg = Struc_KeyValue_string(a[0][c], "@alg", "l");
			
			if(r < ROWS){
				if(salg == "l"){
					te = " "+AddSymbolsRight(a[r][c], max_len)+" ";
				}
				
				if(salg == "r"){
					te = " "+AddSymbolsLeft(a[r][c], max_len)+" ";
				}
			}else{
			
				if(salg == "l"){
					te = " "+AddSymbolsRight("",max_len)+" ";
				}

				if(salg == "r"){
					te = " "+AddSymbolsLeft("",max_len)+" ";
				}	
			}	
			tr = tr + te;
		}
		
		int ydist = 0;
		int row_h = 20;
		ydist = iif(co >= 2, max_row, 0)*row_h;
		ydist = ydist+iif(co >= 2, -r, r)*row_h;
		
		ObjectSetText(ne, tr, 10, "Terminal");
		ObjectSet(ne, OBJPROP_CORNER, co);
		ObjectSet(ne, OBJPROP_XDISTANCE, 10);
		ObjectSet(ne, OBJPROP_YDISTANCE, ydist);
		
		//{ === Параметры отображения строки
		
		string sclr = Struc_KeyValue_string(a[r][0], "@clr", "Gray");
		color clr = StringToColor(sclr);
		ObjectSet(ne, OBJPROP_COLOR, clr);
		//}
	}

}

//{ --- PRIVATE
void OBJ_CreateWithCheck(string name, int type){
	/**
		\version	0.0.0.1
		\date		2013.08.02
		\author		Morochin <artamir> Artiom
		\details	Если нет объекта с заданным именем, то создаем его.
		\internal
			>Hist:	
					 @0.0.0.1@2013.08.02@artamir	[]	OBJ_CreateWithCheck
			>Rev:0
	*/
	
	if(ObjectFind(name) == -1){
		ObjectCreate(name, type, 0, 0, 0, 0, 0, 0, 0);
	}
}
//}