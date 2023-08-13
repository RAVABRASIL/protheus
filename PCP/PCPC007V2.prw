#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

*************

User Function PCPC007V2()

*************


aRotina := {;
{"Pesquisar"   , "AxPesqui"     , 0, 1},;
{"Incluir"     , "U_CADV2(1)" , 0, 3},;
{"Visualizar"  , "U_CADV2(2)" , 0, 2},;
{"Editar"      , "U_CADV2(3)" , 0, 4} }

cCadastro := OemToAnsi("Valor Padrão")
cAlias:='Z59'
DbSelectArea(cAlias)
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, cAlias,,,,,,{} )

Return

*************

User Function CADV2(Funcao)

*************

Private aVariavel := {}
Private oFlange11
Private oZona61
Private oZona62
Private oZona11
Private oZona12  
Private oZona21   
Private oZona22   
Private oZona31   
Private oZona32   
Private oZona41   
Private oZona42   
Private oZona51   
Private oZona52   
Private oZona61   
Private oZona62   
Private oZona71   
Private oZona72   
Private oMatriz11 
Private oMatriz12 
Private oMatriz21 
Private oMatriz22 
Private oMatriz31 
Private oMatriz32 
Private oMatriz41 
Private oMatriz42 
Private oFiltro11 
Private oFiltro12 
Private oFlange11 
Private oFlange12 
Private oCalib11  
Private oCalib12  
Private oSlit                
Private oCircAgua            
Private oLinear11 
Private oLinear12 
Private oGrama11  
Private oGrama12  
Private oEspess11 
Private oEspess12 
Private oAltura11 
Private oAltura12 
Private oLargura11
Private oLargura12
Private oAlinha            
Private oCamera            
Private oSensor            
Private oTrat   
Private oBobina 
Private oFilReve
Private oFilAlim
Private oCaroco 
Private oPlanic 
Private oKgH11 
Private oKgH12 
Private oCilindro 
Private oMaqParada
public xFuncao:=Funcao

public;
cZona1      := cZona11   :=;// (de ... ate)
cZona2      := cZona22   :=;// (de ... ate)
cZona3      := cZona33   :=;// (de ... ate)
cZona4      := cZona44   :=;// (de ... ate)
cZona5      := cZona55   :=;// (de ... ate)
cZona6      := cZona66   :=;// (de ... ate)
cZona7      := cZona77   :=;// (de ... ate)
cMatriz1    := cMatriz11 :=;// (de ... ate)
cMatriz2    := cMatriz22 :=;// (de ... ate)
cMatriz3    := cMatriz33 :=;// (de ... ate)
cMatriz4    := cMatriz44 :=;// (de ... ate)
cSlit       :=;             // (Sim <> Nao)
cLinear     :=cLinear1   :=;// (de ... ate)
cGrama      :=cGrama1    :=;// (de ... ate)
cEspes      :=cEspes1    :=;// (de ... ate)
cAltura     := cAltura1  :=;// (de ... ate)
cLargura    := cLargura1 :=;// (de ... ate)
cAlinha     :=;             // (Sim <> Nao)
cCamera     :=;             // (Sim <> Nao)
cGeladeira:=;               // (Sim <> Nao)
cSensor     :=;             // (Sim <> Nao)
cTratamento :=;             // (Sim <> Nao)
cBobina     :=;             // (Sim <> Nao)
cHelic	    := cHelic1   :=;// (de ... ate)
cCalib      := cCalib1   :=;// (de ... ate)
cFlange     := cFlange1  :=;// (de ... ate)
cFiltro	    := cFiltro1  :=;// (de ... ate)
cCircAgua   :=;             // (Sim <> Nao)
cFilReve    :=;             // (Sim <> Nao)
cFilAlim    :=;             // (Sim <> Nao)
cCaroco     :=;             // (Sim <> Nao)
cPlanic     :=;
cKgH        :=cKgH1:=;// (de ... ate)
cCilindro   :=;				// (Sim <> Nao)
cMaqParada  :=;				// (Sim <> Nao)
space(15)

//public nSlit,nAlinha,nCamera,nGelad,nNeve,nBobi,nTrat,nEdit,nCircAgua,nFilReve,nFilAlim,nCaroco,nPlanic 
public nSlit,nAlinha,nCamera,nGelad,nNeve,nBobi,nTrat,nEdit,nSensor,nFiltro,nFlange,nHelic,nCalib,nCircAgua,nFilReve,nFilAlim,nCaroco,nPlanic,nCilindro,nMaqParada

public cEXT:=space(3)
public cPROD:=space(15)
Public nList
IIF(xFuncao!=2,lDisable:=.F.,lDisable:=.T.)
Public aItems:={;
"SIM",;
"NAO";
}
nZ59Reg := Z59->( Recno() )
/*
MV_PAR01 - Extrusora  (edit)
MV_PAR02 - Produto    (edit)
MV_PAR03 - Operador   (edit)
*/

/*
ESQUEMA GERAL DOS ITENS CONSTANTES EM CADA EXTRUSORA 
//FR - 26/11/12
//SOLICITADO NO CHAMADO 00000231:                     
---------------------------------------------------------------------------------
ITENS                    | E01      | E02      | E03      | E04      | E05       |
---------------------------------------------------------------------------------
ZONAS                    | 7 ZONAS  | 5 ZONAS  | 5 ZONAS  | 5 ZONAS  | 4 ZONAS   |
MATRIZ                   | 4 MATRIZ | 1 MATRIZ | 3 MATRIZ | 1 MATRIZ | 1 MATRIZ  |
TEMP. DE FILTRO          | SIM      | NÃO      | SIM      | NÃO      | NÃO       |
FLANGE                   | NÃO      | SIM      | NÃO      | NÃO      | NÃO       |
CALIBRADOR               | NÃO      | SIM      | NÃO      | NÃO      | NÃO       |
HELICOIDAL               | NÃO      | NÃO      | NÃO      | SIM      | SIM       |
GELADEIRA                | NÃO      | NÃO      | NÃO      | NÃO      | NÃO       |
FILTRO REVERSÍVEL        | SIM      | SIM      | SIM      | NÃO      | NÃO       |
CILINDRO TORRE GIRATÓRIA | SIM      | SIM      | SIM      | NÃO      | NÃO       |
----------------------------------------------------------------------------------
*/

if xFuncao == 1  // 1INCLUIR
	if  !PERGUNTE ('PCPC007',.T.)
		return
	endif	

	cEXT:=UPPER(MV_PAR01)
	cPROD:=UPPER(MV_PAR02)
    
    If !MaqExt(cEXT) 
       alert('Maquina nao cadastrada ou nao e uma Extrusora')    
       Return 
    Endif
    
    If empty(Posicione("SB1",1,xFilial('SB1')+cPROD,"B1_COD" ) )
       alert('Produto nao cadstrado')    
       Return 
    Endif
    
    DbSelectArea(cAlias)
	if Z59->( dbSeek( xFilial( "Z59" ) +SUBSTR(cEXT,1,3)+cPROD)  )
		alert('Ja existe produto cadastrado para essa extrusora.')
		return 
	endif

else // 2-visualizar , 3-EDITAR     
	cEXT:=Z59->Z59_EXTRUS
	cPROD:=Z59->Z59_PRODUT
	
    IF Alltrim(cEXT) != "E04" .and. Alltrim(cEXT) != "E05" 
    	//ENTRA AQUI SE FOR: E01, E02, E03
    	//FR - 26/11/2012
		//CONFORME CHAMADO 00000231:
    	//SE EXTRUSORA É = E04 e E05: 
	    //NÃO TEM CILINDRO TORRE GIRATÓRIA
	    //NÃO TEM FILTRO REVERSÍVEL
	    //TEM HELICOIDAL
	    //O ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS
	    
	    IF Alltrim(cEXT) = "E02" 
	       //TEM CALIBRADOR
	       //TEM FLANGE
	       //NÃO TEM TEMP. DE FILTRO T14
	       //TEM APENAS UMA MATRIZ (MATRIZ 1)
	       //TEM 5 ZONAS
	       	
		    aVariavel:={ {"cZona1"     ,"T01","cZona11"   },;
	                 {"cZona2"     ,"T04","cZona22"   },;
	                 {"cZona3"     ,"T05","cZona33"   },;
	                 {"cZona4"     ,"T06","cZona44"   },;
	                 {"cZona5"     ,"T07","cZona55"   },;	                 
	                 {"cMatriz1"   ,"T02","cMatriz11" },;             
	                 {"cFlange"    ,"T15","cFlange1"  },;
	                 {"cCalib"     ,"T16","cCalib1"   },;
	                 {"cSlit"      ,"T03",""          },;
	                 {"cCircAgua"  ,"T13",""          },;
	                 {"cLinear"    ,"G01","cLinear1"  },;
	                 {"cGrama"     ,"G02","cGrama1"   },;
	                 {"cEspes"     ,"G03","cEspes1"   },;
	                 {"cAltura"    ,"G04","cAltura1"  },;
	                 {"cLargura"   ,"G05","cLargura1" },;
	                 {"cAlinha"    ,"G06",""          },;
	                 {"cCaroco"    ,"G07",""          },;
	                 {"cPlanic"    ,"G08",""          },;       
	                 {"cKgH"       ,"G09","cKgH1"     },;
	                 {"cCamera"    ,"F01",""          },;	                 
	                 {"cSensor"    ,"F03",""          },;
	                 {"cTratamento","F04",""          },;
	                 {"cBobina"    ,"F05",""          },; 
	                 {"cFilReve"   ,"F06",""          },;
	                 {"cFilAlim"   ,"F07",""          },;
	                 {"cCilindro"  ,"F08",""          },;
					 {"cMaqParada" ,"F09",""          } }
					 
					 //{"cHelic"     ,"T17","cHelic1"   },; //RETIRADO
					 //{"cFiltro"    ,"T14","cFiltro1"  },; //RETIRADO
					 //{"cMatriz2"   ,"T10","cMatriz22" },; //RETIRADO
	                 //{"cMatriz3"   ,"T11","cMatriz33" },; //RETIRADO
	                 //{"cMatriz4"   ,"T12","cMatriz44" },;	//RETIRADO 
	                 //{"cZona6"     ,"T08","cZona66"   },; //RETIRADO
	                 //{"cZona7"     ,"T09","cZona77"   },; //RETIRADO               
					 
		ELSEIF  Alltrim(cEXT) = "E01"   
	      //NÃO TEM CALIBRADOR (E01, E03)
	      //TEM TEMP DE FILTRO T14
	      //TEM 4 MATRIZES
	      //TEM 7 ZONAS
	      				 
			    aVariavel:={ {"cZona1"     ,"T01","cZona11"   },;
			                 {"cZona2"     ,"T04","cZona22"   },;
			                 {"cZona3"     ,"T05","cZona33"   },;
			                 {"cZona4"     ,"T06","cZona44"   },;
			                 {"cZona5"     ,"T07","cZona55"   },;
			                 {"cZona6"     ,"T08","cZona66"   },;
			                 {"cZona7"     ,"T09","cZona77"   },;
			                 {"cMatriz1"   ,"T02","cMatriz11" },;
			                 {"cMatriz2"   ,"T10","cMatriz22" },;
			                 {"cMatriz3"   ,"T11","cMatriz33" },;
			                 {"cMatriz4"   ,"T12","cMatriz44" },;
			                 {"cFiltro"    ,"T14","cFiltro1"  },;			                 
			                 {"cSlit"      ,"T03",""          },;
			                 {"cCircAgua"  ,"T13",""          },;
			                 {"cLinear"    ,"G01","cLinear1"  },;
			                 {"cGrama"     ,"G02","cGrama1"   },;
			                 {"cEspes"     ,"G03","cEspes1"   },;
			                 {"cAltura"    ,"G04","cAltura1"  },;
			                 {"cLargura"   ,"G05","cLargura1" },;
			                 {"cAlinha"    ,"G06",""          },;
			                 {"cCaroco"    ,"G07",""          },;
			                 {"cPlanic"    ,"G08",""          },;       
			                 {"cKgH"       ,"G09","cKgH1"     },;
			                 {"cCamera"    ,"F01",""          },;	                 
			                 {"cSensor"    ,"F03",""          },;
			                 {"cTratamento","F04",""          },;
			                 {"cBobina"    ,"F05",""          },; 
			                 {"cFilReve"   ,"F06",""          },;
			                 {"cFilAlim"   ,"F07",""          },;
			                 {"cCilindro"  ,"F08",""          },;
							 {"cMaqParada" ,"F09",""          } }
						 
						 //{"cHelic"     ,"T17","cHelic1"   },; //RETIRADO
						 //{"cFlange"    ,"T15","cFlange1"  },; //RETIRADO
			             //{"cCalib"     ,"T16","cCalib1"   },; //RETIRADO
		ELSEIF Alltrim(cEXT) = "E03"   
		//NÃO TEM CALIBRADOR (E01, E03)
	    //TEM TEMP DE FILTRO T14
	    //TEM 3 MATRIZES
	    //TEM 5 ZONAS				 
	    
			    aVariavel:={ {"cZona1"     ,"T01","cZona11"   },;
			                 {"cZona2"     ,"T04","cZona22"   },;
			                 {"cZona3"     ,"T05","cZona33"   },;
			                 {"cZona4"     ,"T06","cZona44"   },;
			                 {"cZona5"     ,"T07","cZona55"   },;			                
			                 {"cMatriz1"   ,"T02","cMatriz11" },;
			                 {"cMatriz2"   ,"T10","cMatriz22" },;
			                 {"cMatriz3"   ,"T11","cMatriz33" },;			                
			                 {"cFiltro"    ,"T14","cFiltro1"  },;			                 
			                 {"cSlit"      ,"T03",""          },;
			                 {"cCircAgua"  ,"T13",""          },;
			                 {"cLinear"    ,"G01","cLinear1"  },;
			                 {"cGrama"     ,"G02","cGrama1"   },;
			                 {"cEspes"     ,"G03","cEspes1"   },;
			                 {"cAltura"    ,"G04","cAltura1"  },;
			                 {"cLargura"   ,"G05","cLargura1" },;
			                 {"cAlinha"    ,"G06",""          },;
			                 {"cCaroco"    ,"G07",""          },;
			                 {"cPlanic"    ,"G08",""          },;       
			                 {"cKgH"       ,"G09","cKgH1"     },;
			                 {"cCamera"    ,"F01",""          },;	                 
			                 {"cSensor"    ,"F03",""          },;
			                 {"cTratamento","F04",""          },;
			                 {"cBobina"    ,"F05",""          },; 
			                 {"cFilReve"   ,"F06",""          },;
			                 {"cFilAlim"   ,"F07",""          },;
			                 {"cCilindro"  ,"F08",""          },;
							 {"cMaqParada" ,"F09",""          } }
						 
						 //{"cHelic"     ,"T17","cHelic1"   },; //RETIRADO
						 //{"cFlange"    ,"T15","cFlange1"  },; //RETIRADO
			             //{"cCalib"     ,"T16","cCalib1"   },; //RETIRADO
			             // {"cMatriz4"   ,"T12","cMatriz44" },; //RETIRADO
			             // {"cZona6"     ,"T08","cZona66"   },; //RETIRADO
			             // {"cZona7"     ,"T09","cZona77"   },; //RETIRADO
			             
		ENDIF   //E02
					 
	ELSEIF Alltrim(cEXT) = "E04"    
	//SE EXTRUSORA É = E04 e E05, 
	//FR - 26/11/2012
	//CONFORME CHAMADO 00000231:
    //SE EXTRUSORA É = E04 e E05: 
	//NÃO TEM CILINDRO TORRE GIRATÓRIA
	//NÃO TEM FILTRO REVERSÍVEL
	//TEM HELICOIDAL
	//O ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS
	//NÃO TEM CALIBRADOR
	//NÃO TEM TEMP. DE FILTRO T14
	//SÓ TEM UMA MATRIZ (MATRIZ 1)
	//TEM 5 ZONAS
	
	    aVariavel:={ {"cZona1"     ,"T01","cZona11"   },;
	                 {"cZona2"     ,"T04","cZona22"   },;
	                 {"cZona3"     ,"T05","cZona33"   },;
	                 {"cZona4"     ,"T06","cZona44"   },;
	                 {"cZona5"     ,"T07","cZona55"   },;	                 
	                 {"cMatriz1"   ,"T02","cMatriz11" },;	                 
	                 {"cFlange"    ,"T15","cFlange1"  },;	                 
	                 {"cHelic"     ,"T17","cHelic1"   },;
	                 {"cSlit"      ,"T03",""          },;
	                 {"cCircAgua"  ,"T13",""          },;
	                 {"cLinear"    ,"G01","cLinear1"  },;
	                 {"cGrama"     ,"G02","cGrama1"   },;
	                 {"cEspes"     ,"G03","cEspes1"   },;
	                 {"cAltura"    ,"G04","cAltura1"  },;
	                 {"cLargura"   ,"G05","cLargura1" },;
	                 {"cAlinha"    ,"G06",""          },;
	                 {"cCaroco"    ,"G07",""          },;
	                 {"cPlanic"    ,"G08",""          },;       
	                 {"cKgH"       ,"G09","cKgH1"     },;
	                 {"cCamera"    ,"F01",""          },;	                 
	                 {"cSensor"    ,"F03",""          },;
	                 {"cTratamento","F04",""          },;
	                 {"cBobina"    ,"F05",""          },; 	                 
	                 {"cFilAlim"   ,"F07",""          },;
	                 {"cMaqParada" ,"F09",""          } } 
	                 
	                 // {"cCalib"     ,"T16","cCalib1"   },;  //RETIRADO
	                 //{"cFiltro"    ,"T14","cFiltro1"  },;   //RETIRADO
	                 //{"cMatriz2"   ,"T10","cMatriz22" },;   //RETIRADO
	                 //{"cMatriz3"   ,"T11","cMatriz33" },;   //RETIRADO
	                 //{"cMatriz4"   ,"T12","cMatriz44" },;   //RETIRADO  
	                 //{"cZona6"     ,"T08","cZona66"   },;   //RETIRADO
	                 //{"cZona7"     ,"T09","cZona77"   },;   //RETIRADO
	                 
	ELSEIF Alltrim(cEXT) = "E05"    
	//SE EXTRUSORA É = E04 e E05, 
	//FR - 26/11/2012
	//CONFORME CHAMADO 00000231:
    //SE EXTRUSORA É = E04 e E05: 
	//NÃO TEM CILINDRO TORRE GIRATÓRIA
	//NÃO TEM FILTRO REVERSÍVEL
	//TEM HELICOIDAL
	//O ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS
	//NÃO TEM CALIBRADOR
	//NÃO TEM TEMP. DE FILTRO T14
	//SÓ TEM UMA MATRIZ (MATRIZ 1)
	//TEM 4 ZONAS
	
	    aVariavel:={ {"cZona1"     ,"T01","cZona11"   },;
	                 {"cZona2"     ,"T04","cZona22"   },;
	                 {"cZona3"     ,"T05","cZona33"   },;
	                 {"cZona4"     ,"T06","cZona44"   },;	                 
	                 {"cMatriz1"   ,"T02","cMatriz11" },;	                 
	                 {"cFlange"    ,"T15","cFlange1"  },;	                 
	                 {"cHelic"     ,"T17","cHelic1"   },;
	                 {"cSlit"      ,"T03",""          },;
	                 {"cCircAgua"  ,"T13",""          },;
	                 {"cLinear"    ,"G01","cLinear1"  },;
	                 {"cGrama"     ,"G02","cGrama1"   },;
	                 {"cEspes"     ,"G03","cEspes1"   },;
	                 {"cAltura"    ,"G04","cAltura1"  },;
	                 {"cLargura"   ,"G05","cLargura1" },;
	                 {"cAlinha"    ,"G06",""          },;
	                 {"cCaroco"    ,"G07",""          },;
	                 {"cPlanic"    ,"G08",""          },;       
	                 {"cKgH"       ,"G09","cKgH1"     },;
	                 {"cCamera"    ,"F01",""          },;	                 
	                 {"cSensor"    ,"F03",""          },;
	                 {"cTratamento","F04",""          },;
	                 {"cBobina"    ,"F05",""          },; 	                 
	                 {"cFilAlim"   ,"F07",""          },;
	                 {"cMaqParada" ,"F09",""          } } 
	                 
	                 // {"cCalib"     ,"T16","cCalib1"   },;  //RETIRADO
	                 //{"cFiltro"    ,"T14","cFiltro1"  },;   //RETIRADO
	                 //{"cMatriz2"   ,"T10","cMatriz22" },;   //RETIRADO
	                 //{"cMatriz3"   ,"T11","cMatriz33" },;   //RETIRADO
	                 //{"cMatriz4"   ,"T12","cMatriz44" },;   //RETIRADO
	                 //{"cZona5"     ,"T07","cZona55"   },;   //RETIRADO
	                 //{"cZona6"     ,"T08","cZona66"   },;     //RETIRADO
	                 //{"cZona7"     ,"T09","cZona77"   },;     //RETIRADO
	                 
	ENDIF

    // Alimento as variaveis com os valores do Banco
	For _X:=1 to len(aVariavel)
		&(aVariavel[_X][1]):= upper(Posicione("Z59",1,xFilial('Z59') +SUBSTR(cEXT,1,3)+cPROD+aVariavel[_X][2] ,"Z59_VALOR" ))   
		If ! empty(aVariavel[_X][3]) 
	   		&(aVariavel[_X][3]):= upper(Posicione("Z59",1,xFilial('Z59') +SUBSTR(cEXT,1,3)+cPROD+aVariavel[_X][2] ,"Z59_VALOR2" ))  
    	Endif
	Next


endif

oDlg1      := MSDialog():New( 152,327,712,1022,"Valor Padrão",,,.F.,,,,,,.T.,,,.F. )


oGrp0      := TGroup():New( 004,002,038,344,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1     := TSay():New( 011,008,{||"Extrusora:" },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
oSay1     := TSay():New( 011,056,{||"Produto:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)

// EXTRUSORA
oGetEXT := TGet():New( 019,008,{|u| If(PCount()>0,cEXT:=u,cEXT)          },oGrp0,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cEXT" ,, )
oGetEXT:bValid:={|| cEXT:=upper(cEXT) }
oGetEXT:disable()

// PRODUTO
oGetPROD:= TGet():New( 019,056,{|u| If(PCount()>0,cPROD:=u,cPROD)},oGrp0,070,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPROD",,)
oGetPROD:bValid:={|| cPROD:=upper(cPROD) }
oGetPROD:disable()


oGrp1      := TGroup():New( 042,002,255,114," Temperatura ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBox1     := TScrollBox():New( oGrp1,052,007,199,103,.T.,.T.,.T. )
nIni:=0

oSay   := TSay():New( nIni,001,    {|| 'Zona 1'                         }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                            }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona1:=u,cZona1  )}  ,oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona1'   ,,)
cZona1:=upper(cZona1) 
travar(oZona11)

oSay   := TSay():New( nIni,041,{|| 'Ate:'                               }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona12:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona11:=u,cZona11    ) }  ,oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona11'   ,,)
cZona11:=upper(cZona11) 
travar(oZona12)

oSay   := TSay():New( nIni+=20,001 ,   {|| 'Zona 2'                     }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                            }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona21 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona2:=u,cZona2)} ,oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona2'   ,,)
cZona2:=upper(cZona2) 
travar(oZona21)

oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }                ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona22:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona22:=u,cZona22    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona22'   ,,)
cZona22:=upper(cZona22) 
travar(oZona22)

oSay   := TSay():New( nIni +=20,001 ,  {|| 'Zona 3'              }         ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }             ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona31 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona3:=u,cZona3 )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona3'   ,,)
cZona3:=upper(cZona3) 
travar(oZona31)

oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }                ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona32:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona33:=u,cZona33    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona33'   ,,)
cZona33:=upper(cZona33) 
travar(oZona32)

oSay   := TSay():New( nIni+=20,001 ,    {|| 'Zona 4'              }        ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }             ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona41 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona4:=u,cZona4 )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona4'   ,,)
cZona4:=upper(cZona4) 
travar(oZona41)

oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }                ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oZona42:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona44:=u,cZona44    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona44'   ,,)
cZona44:=upper(cZona44) 
travar(oZona42)

///FR - 26/11/12 - CH 00000231
///NA E05 SÓ TEM 4 ZONAS 
IF Alltrim(cEXT) != "E05"
	oSay   := TSay():New( nIni+=20,001 ,    {|| 'Zona 5'              }        ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oZona51 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona5:=u,cZona5      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona5'   ,,)
	cZona5:=upper(cZona5) 
	travar(oZona51)
	
	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oZona52:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona55:=u,cZona55    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona55'   ,,)
	cZona55:=upper(cZona55) 
	travar(oZona52) 
ENDIF

///FR - 26/11/12 - CH 00000231 
///ZONA 7 SÓ TEM NA E01
IF Alltrim(cEXT) = "E01"

	oSay   := TSay():New( nIni+=20,001 ,    {|| 'Zona 6'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oZona61 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona6:=u,cZona6      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona6'   ,,)
	cZona6:=upper(cZona6) 
	travar(oZona61)
	
	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oZona62:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona66:=u,cZona66    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona66'   ,,)
	cZona66:=upper(cZona66) 
	travar(oZona62)


	oSay   := TSay():New( nIni+=20,001 ,   {|| 'Zona 7'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oZona71 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona7:=u,cZona7      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona7'   ,,)
	cZona7:=upper(cZona7) 
	travar(oZona71)


	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oZona72:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona77:=u,cZona77    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona77'   ,,)
	cZona77:=upper(cZona77) 
	travar(oZona72)
ENDIF

oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 1'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oMatriz11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz1:=u,cMatriz1      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz1'   ,,)
cMatriz1:=upper(cMatriz1) 
travar(oMatriz11)

oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oMatriz12:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz11:=u,cMatriz11    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz11'   ,,)
cMatriz11:=upper(cMatriz11) 
travar(oMatriz12)

///FR - 26/11/12 - CH 00000231 
IF Alltrim(cEXT) != "E02" .AND. Alltrim(cEXT) != "E04" .AND. Alltrim(cEXT) != "E05"
	oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 2'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oMatriz21 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz2:=u,cMatriz2      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz2'   ,,)
	cMatriz2:=upper(cMatriz2) 
	travar(oMatriz21)

	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oMatriz22:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz22:=u,cMatriz22    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz22'   ,,)
	cMatriz22:=upper(cMatriz22) 
	travar(oMatriz22)

	oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 3'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oMatriz31 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz3:=u,cMatriz3      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz3'   ,,)
	cMatriz3:=upper(cMatriz3) 
	travar(oMatriz31)

	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oMatriz32:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz33:=u,cMatriz33    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz33'   ,,)
	oMatriz32:bValid:={|| cMatriz33:=upper(cMatriz33) }
	travar(oMatriz32)
    
	IF Alltrim(cEXT) = "E01" 
	///FR - 26/11/12 - CH 00000231 
		oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 4'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
		oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
		oMatriz41:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz4:=u,cMatriz4      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz4'   ,,)
		cMatriz4:=upper(cMatriz4) 
		travar(oMatriz41)
	
		oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
		oMatriz42:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz44:=u,cMatriz44    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz44'   ,,)
		cMatriz44:=upper(cMatriz44)
		travar(oMatriz42)
	ENDIF

ENDIF

///FR - 26/11/12 - CH 00000231 
///TEMP DE FILTRO T14 SÓ TEM NA E01 / E03
IF Alltrim(cEXT) $ "E01/E03"
	oSay   := TSay():New( nIni+=20,001,{|| 'Temperatura de Filtro'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oFiltro11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cFiltro :=u,cFiltro       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFiltro'   ,,)
	cFiltro:=upper(cFiltro ) 
	travar(oFiltro11)


	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oFiltro12:= TGet():New( nIni,051,{|u| If(PCount()>0,cFiltro1 :=u,cFiltro1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFiltro1'   ,,)
	cFiltro1 :=upper(cFiltro1 ) 
	travar(oFiltro12)
ENDIF

///FR - 26/11/12 - CH 00000231 
//FLANGE SÓ TEM NA E02
IF Alltrim(cEXT) = "E02"
	oSay   := TSay():New( nIni+=20,001,{|| 'Flange'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay     := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oFlange11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cFlange :=u,cFlange       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFlange'   ,,)
	cFlange:=upper(cFlange ) 
	travar(oFlange11)


	oSay     := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oFlange12:= TGet():New( nIni,051,{|u| If(PCount()>0,cFlange1 :=u,cFlange1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFlange1'   ,,)
	cFlange1 :=upper(cFlange1 ) 
	travar(oFlange12) 
ENDIF

///FR - 26/11/12 - CH 00000231 
//CALIBRADOR SÓ TEM NA E02
IF Alltrim(cEXT) = "E02"
	oSay   := TSay():New( nIni+=20,001,{|| 'Calibrador'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oCalib11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cCalib :=u,cCalib       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCalib'   ,,)
	cCalib:=upper(cCalib ) 
	travar(oCalib11)

	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oCalib12:= TGet():New( nIni,051,{|u| If(PCount()>0,cCalib1 :=u,cCalib1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCalib1'   ,,)
	cCalib1 :=upper(cCalib1 ) 
	travar(oCalib12)  
ENDIF

IF Alltrim(cEXT) $ "E04/E05"
	//SE EXTRUSORA É = E04 e E05, 
	//FR - 26/11/2012
	//CONFORME CHAMADO 00000231:
   	//SE EXTRUSORA É = E04 e E05: 
	//NÃO TEM CILINDRO TORRE GIRATÓRIA
	//NÃO TEM FILTRO REVERSÍVEL
	//TEM HELICOIDAL
	//O ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS 

	oSay   := TSay():New( nIni+=20,001,{|| 'Helicoidal'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oHelic11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cHelic :=u,cHelic       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cHelic'   ,,)
	cHelic:=upper(cHelic ) 
	travar(oHelic11)

	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oHelic12:= TGet():New( nIni,051,{|u| If(PCount()>0,cHelic1 :=u,cHelic1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cHelic1'   ,,)
	cHelic1 :=upper(cHelic1 ) 
	travar(oHelic12) 
ENDIF

oSay   := TSay():New( nIni+=20,001,{|| 'Conformidade do Slit'                  }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,010 )
if xFuncao == 2
	oSlit := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSlit:=u,cSlit        )},oSBox1,080,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cSlit'    ,,)
    cSlit:=upper(cSlit) 
else
	oSlit:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSlit:=u,nSlit)},aItems,80,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oSlit:nAT:= IIF(upper(alltrim(cSlit))!='NAO', 1,2)
	oSlit:bValid:={||cSlit:=upper(aItems[oSlit:nAT]) }
	 
endif
travar(oSlit)

oSay   := TSay():New( nIni+=20,001,{|| 'Circulação de Agua'                            },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,020 )
if xFuncao == 2
	oCircAgua := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCircAgua:=u,cCircAgua )  },oSBox1,080,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCircAgua' ,,)
    cCircAgua:=upper(cCircAgua) 
else
	oCircAgua:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCircAgua:=u,nCircAgua)},aItems,80,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oCircAgua:nAT:= IIF(upper(alltrim(cCircAgua))!='NAO', 1,2)
	oCircAgua:bValid:={||cCircAgua:=upper(aItems[oCircAgua:nAT]) }
endif
travar(oCircAgua)



oGrp2      := TGroup():New( 042,117,255,229," Gravimetro ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBox2     := TScrollBox():New( oGrp2,052,121,199,103,.T.,.T.,.T. )
nIni:=0

oSay   := TSay():New( nIni    ,001,{|| 'Linear'              }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
oSay     := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oLinear11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cLinear :=u,cLinear       )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLinear'   ,,)
cLinear:=upper(cLinear ) 
travar(oLinear11)

oSay     := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oLinear12:= TGet():New( nIni,051,{|u| If(PCount()>0,cLinear1 :=u,cLinear1     )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLinear1'   ,,)
cLinear1 :=upper(cLinear1 ) 
travar(oLinear12)


oSay   := TSay():New( nIni+=20,001,{|| 'Grama/Metro'         }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oGrama11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cGrama :=u,cGrama       )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cGrama'   ,,)
cGrama:=upper(cGrama ) 
travar(oGrama11)

oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oGrama12:= TGet():New( nIni,051,{|u| If(PCount()>0,cGrama1 :=u,cGrama1     )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cGrama1'   ,,)
cGrama1 :=upper(cGrama1 ) 
travar(oGrama12)


oSay        := TSay():New( nIni+=20,001,{|| 'Espessura do Filme'  }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
oSay     := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oEspess11:= TGet():New( nIni    ,010,{|u| If(PCount()>0,cEspes:=u,cEspes      )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEspes'   ,,)
cEspes:=upper(cEspes) 
travar(oEspess11)

oSay   := TSay():New( nIni,050,{|| 'Ate:'                    }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oEspess12:= TGet():New( nIni,060,{|u| If(PCount()>0,cEspes1:=u,cEspes1    )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEspes1'   ,,)
cEspes1:=upper(cEspes1) 
travar(oEspess12)


oSay   := TSay():New( nIni+=20,001,{|| 'Altura do Balao'     }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oAltura11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cAltura:=u,cAltura      )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cAltura'   ,,)
cAltura:=upper(cAltura) 
travar(oAltura11)

oSay   := TSay():New( nIni,050,{|| 'Ate:'                    }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oAltura12:= TGet():New( nIni,060,{|u| If(PCount()>0,cAltura1:=u,cAltura1    )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cAltura1'   ,,)
cAltura1:=upper(cAltura1) 
travar(oAltura12)

oSay   := TSay():New( nIni+=20,001,{|| 'Largura bobina'      }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oLargura11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cLargura:=u,cLargura      )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLargura'   ,,)
cLargura:=upper(cLargura) 
travar(oLargura11)

oSay   := TSay():New( nIni,050,{|| 'Ate:'                    }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oLargura12:= TGet():New( nIni,060,{|u| If(PCount()>0,cLargura1:=u,cLargura1    )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLargura1'   ,,)
cLargura1:=upper(cLargura1) 
travar(oLargura12)

oSay   := TSay():New( nIni+=20,001,{|| 'Alinhamento bobina'  }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oAlinha := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cAlinha:=u,cAlinha)},oSBox2,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cAlinha',,)
    cAlinha:=upper(cAlinha) 
else
    oAlinha:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nAlinha:=u,nAlinha)},aItems,80,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oAlinha:nAT:= IIF(upper(alltrim(cAlinha))!='NAO', 1,2)
	oAlinha:bValid:={||cAlinha:=upper(aItems[oAlinha:nAT]) }
endif
travar(oAlinha)

oSay   := TSay():New( nIni+=20,001,{|| 'Caroço'+ CHR(13) + CHR(10)+ 'Tem:'  }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oCaroco := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cCaroco :=u,cCaroco )},oSBox2,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCaroco ',,)
    cCaroco :=upper(cCaroco ) 
else
	oCaroco:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nCaroco:=u,nCaroco)},aItems,80,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oCaroco:nAT:= IIF(upper(alltrim(cCaroco))!='NAO', 1,2)
	oCaroco:bValid:={||cCaroco:=upper(aItems[oCaroco:nAT]) }
endif
travar(oCaroco )

oSay   := TSay():New( nIni+=20,001,{|| 'Planicidade'  }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oPlanic := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cPlanic:=u,cPlanic)},oSBox2,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cPlanic',,)
    cPlanic:=upper(cPlanic) 
else
	oPlanic:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nPlanic:=u,nPlanic)},aItems,80,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oPlanic:nAT:= IIF(upper(alltrim(cPlanic))!='NAO', 1,2)
	oPlanic:bValid:={||cPlanic:=upper(aItems[oPlanic:nAT]) }
endif
travar(oPlanic)

oSay   := TSay():New( nIni+=20,001,{|| 'Kg/h'         }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oKgH11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cKgH :=u,cKgH       )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cKgH'   ,,)
cKgH:=upper(cKgH ) 
travar(oKgH11)

oSay   := TSay():New( nIni,050,{|| 'Ate:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
oKgH12:= TGet():New( nIni,060,{|u| If(PCount()>0,cKgH1 :=u,cKgH1     )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cKgH1'   ,,)
cKgH1 :=upper(cKgH1 ) 
travar(oKgH12)



oGrp3      := TGroup():New( 042,232,255,344," Ferramenta ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBox3     := TScrollBox():New( oGrp3,052,236,199,103,.T.,.T.,.T. )
nIni:=0

oSay   := TSay():New( nIni    ,001,{|| 'Câmera'              }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
if xFuncao == 2
	oCamera := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCamera:=u,cCamera)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCamera',,)
    cCamera:=upper(cCamera) 
else
	oCamera:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCamera:=u,nCamera)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oCamera:nAT:= IIF(upper(alltrim(cCamera))!='NAO', 1,2)
	oCamera:bValid:={||cCamera:=upper(aItems[oCamera:nAT]) }
endif
travar(oCamera)

///FR - 26/11/12 - CH 00000231 - o item GELADEIRA foi retirado de todas as extrusoras
/*
oSay   := TSay():New( nIni+=20,001,{|| 'Geladeira'           }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
if xFuncao == 2
	oGeladeira := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cGeladeira:=u,cGeladeira)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cGeladeira',,)
    cGeladeira:=upper(cGeladeira) 
else
	oGeladeira:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nGelad:=u,nGelad)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oGeladeira:nAT:= IIF(upper(alltrim(cGeladeira))!='NAO', 1,2)
	oGeladeira:bValid:={||cGeladeira:=upper(aItems[oGeladeira:nAT]) }
endif
travar(oGeladeira)
*/

oSay   := TSay():New( nIni+=20,001,{|| 'Sensor Ponto de Neve'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
if xFuncao == 2
	oSensor := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSensor:=u,cSensor        )},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cSensor'    ,,)
    cSensor:=upper(cSensor) 
else
	oSensor:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSensor:=u,nSensor)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oSensor:nAT:= IIF(upper(alltrim(cSensor))!='NAO', 1,2)
	oSensor:bValid:={||cSensor:=upper(aItems[oSensor:nAT]) }	
endif
travar(oSensor)

oSay   := TSay():New( nIni+=20,001,{|| 'Tratamento'+ CHR(13) + CHR(10)+ 'Ligado:'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oTrat := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cTratamento:=u,cTratamento)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cTratamento',,)
	cTratamento:=upper(cTratamento) 
else
	oTrat:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nTrat:=u,nTrat)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oTrat:nAT:= IIF(upper(alltrim(cTratamento))!='NAO', 1,2)
	oTrat:bValid:={||cTratamento:=upper(aItems[oTrat:nAT]) }	
endif
travar(oTrat)

oSay   := TSay():New( nIni+=20,001,{|| 'Bobinadeira'+ CHR(13) + CHR(10)+ 'Automatico:'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oBobina := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cBobina:=u,cBobina)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cBobina',,)
    cBobina:=upper(cBobina) 
else
	oBobina:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nBobi:=u,nBobi)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oBobina:nAT:= IIF(upper(alltrim(cBobina))!='NAO', 1,2)
	oBobina:bValid:={||cBobina:=upper(aItems[oBobina:nAT]) }
endif
travar(oBobina)

///26/11/12 - FR - relativo ao chamado 00000231
If Alltrim(cEXT) != "E04" .and. Alltrim(cEXT) != "E05"     
	oSay   := TSay():New( nIni+=20,001,{|| 'Filtro do Reversivel'+ CHR(13) + CHR(10)+ 'Limpo:'         }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
	if xFuncao == 2
		oFilReve := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cFilReve:=u,cFilReve)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFilReve',,)
	    cFilReve:=upper(cFilReve) 
	else
		oFilReve:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nFilReve:=u,nFilReve)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		oFilReve:nAT:= IIF(upper(alltrim(cFilReve))!='NAO', 1,2)
		oFilReve:bValid:={||cFilReve:=upper(aItems[oFilReve:nAT]) }	
	endif
	travar(oFilReve)
Endif

oSay   := TSay():New( nIni+=20,001,{|| 'Filtro do Alimentador'+ CHR(13) + CHR(10)+ 'Limpo:'         }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oFilAlim := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cFilAlim :=u,cFilAlim )},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFilAlim ',,)
    cFilAlim :=upper(cFilAlim ) 
else
	oFilAlim:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nFilAlim:=u,nFilAlim)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oFilAlim:nAT:= IIF(upper(alltrim(cFilAlim))!='NAO', 1,2)
	oFilAlim:bValid:={||cFilAlim:=upper(aItems[oFilAlim:nAT]) }	
endif
travar(oFilAlim)

///24/09/12 - FR - relativo aos chamados 00000014 e 00000029
If Alltrim(cEXT) != "E04" .and. Alltrim(cEXT) != "E05"     
	oSay   := TSay():New( nIni+=20,001,{|| 'Cilindros Torre Girat.'+ CHR(13) + CHR(10)+ 'Limpos?'         }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
	if xFuncao == 2 
		oCilindro:= TGet():New( nIni+=15,001,{|u| If(PCount()>0,cCilindro :=u,cCilindro )},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCilindro ',,)
	    cCilindro :=upper(cCilindro ) 
	else
		oCilindro:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nCilindro:=u,nCilindro)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		oCilindro:nAT:= IIF(upper(alltrim(cCilindro))!='NAO', 1,2)
		oCilindro:bValid:={||cCilindro:=upper(aItems[oCilindro:nAT]) }	
	endif 
Endif 

oSay   := TSay():New( nIni+=20,001,{|| 'Maquina Parada?'         }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oMaqParada:= TGet():New( nIni+=11,001,{|u| If(PCount()>0,cMaqParada :=u,cMaqParada )},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMaqParada ',,)
    cMaqParada :=upper(cMaqParada ) 
else
	oMaqParada:=	TComboBox():New( nIni+=11,001,{|u| if(Pcount()>0,nMaqParada:=u,nMaqParada)},aItems,80,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oMaqParada:nAT:= IIF(upper(alltrim(cCilindro))!='NAO', 1,2)
	oMaqParada:bValid:={||cMaqParada:=upper(aItems[oMaqParada:nAT]) }	
endif
///FR


if xFuncao == 2   // visualizar 
	Z59->( dbGoto( nZ59Reg ) )
	oSBtn1     := SButton():New( 260,311,1,{|| oDlg1:end()  },oDlg1,,"", )
else
	
	IF Alltrim(cEXT) != "E04" .and. Alltrim(cEXT) != "E05"  //QQ EXTRUSORA DIFERENTE DE E04 / E05: 
																	//POSSUI CILINDROS TORRE GIRATÓRIA
																	//POSSUI FILTRO REVERSÍVEL
		aObj:={;                                                    //NÃO POSSUI HELICOIDAL
		@oZona11   ,@oZona12   ,;//  1
		@oZona21   ,@oZona22   ,;//  2
		@oZona31   ,@oZona32   ,;//  3
		@oZona41   ,@oZona42   ,;//  4
		@oZona51   ,@oZona52   ,;//  5
		@oZona61   ,@oZona62   ,;//  6
		@oZona71   ,@oZona72   ,;//  7
		@oMatriz11 ,@oMatriz12 ,;//  8
		@oMatriz21 ,@oMatriz22 ,;//  9
		@oMatriz31 ,@oMatriz32 ,;// 10
		@oMatriz41 ,@oMatriz42 ,;// 11
		@oFiltro11 ,@oFiltro12 ,;// 12
		@oFlange11 ,@oFlange12 ,;// 13
		@oCalib11  ,@oCalib12  ,;// 14
		@oSlit      ,           ;// 16
		@oCircAgua ,            ;// 17
		@oLinear11 ,@oLinear12 ,;// 18
		@oGrama11  ,@oGrama12   ,;// 19
		@oEspess11 ,@oEspess12 ,;// 20
		@oAltura11 ,@oAltura12 ,;// 21
		@oLargura11,@oLargura12,;// 22
		@oAlinha   ,            ;// 23
		@oCamera   ,            ;// 24		
		@oSensor   ,            ;// 25
		@oTrat     ,            ;// 26
		@oBobina   ,            ;// 27
	    @oFilReve  ,            ;// 28
		@oFilAlim  ,            ;// 29
		@oCaroco  ,             ;// 30	
		@oPlanic   ,            ;// 31	
		@oKgH11    ,            ;//32
		@oKgH12    ,            ;//33
		@oCilindro ,            ;//34
		@oMaqParada   }			//35
		
		//@oHelic11  ,@oHelic12  ,;// 15 //RETIRADO
	
	ELSE //SE FOR E04 / E05
				aObj:={;
		@oZona11   ,@oZona12   ,;//  1
		@oZona21   ,@oZona22   ,;//  2
		@oZona31   ,@oZona32   ,;//  3
		@oZona41   ,@oZona42   ,;//  4
		@oZona51   ,@oZona52   ,;//  5
		@oZona61   ,@oZona62   ,;//  6
		@oZona71   ,@oZona72   ,;//  7
		@oMatriz11 ,@oMatriz12 ,;//  8
		@oMatriz21 ,@oMatriz22 ,;//  9
		@oMatriz31 ,@oMatriz32 ,;// 10
		@oMatriz41 ,@oMatriz42 ,;// 11
		@oFiltro11 ,@oFiltro12 ,;// 12
		@oFlange11 ,@oFlange12 ,;// 13
		@oCalib11  ,@oCalib12  ,;// 14
		@oHelic11  ,@oHelic12  ,;// 15
		@oSlit      ,           ;// 16
		@oCircAgua ,            ;// 17
		@oLinear11 ,@oLinear12 ,;// 18
		@oGrama11  ,@oGrama12   ,;// 19
		@oEspess11 ,@oEspess12 ,;// 20
		@oAltura11 ,@oAltura12 ,;// 21
		@oLargura11,@oLargura12,;// 22
		@oAlinha   ,            ;// 23
		@oCamera   ,            ;// 24
		@oSensor   ,            ;// 25
		@oTrat     ,            ;// 26
		@oBobina   ,            ;// 27
	    @oFilAlim  ,            ;// 28
		@oCaroco  ,             ;// 29	
		@oPlanic   ,            ;// 30	
		@oKgH11    ,            ;//31
		@oKgH12    ,            ;//32
		@oMaqParada   }			//33
	ENDIF
	
	oSBtn1     := SButton():New( 260,276,1,{|| GRAVAR(aObj)},oDlg1,,"", )
	oSBtn2     := SButton():New( 260,311,2,{|| Z59->( dbGoto( nZ59Reg ) ),oDlg1:end() },oDlg1,,"", )

endif
oDlg1:Activate(,,,.T.)

Return  


***************

Static Function Gravar(aObj)

***************

Local aVetor:={} 
Local aMsg  := {}

IF Alltrim(cEXT) != "E04" .and. Alltrim(cEXT) != "E05"  //as EXTRUSORAS DIFERENTES DE E04 e E05:
																// POSSUEM CILINDROS
																// POSSUEM FILTRO REVERSÍVEL
																//NÃO POSSUEM HELICOIDAL
																//FR - 26/11/12 - CHAMADO 00000231 - RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
	IF Alltrim(cEXT) = "E01"
		//FR - 26/11/12 - CHAMADO: 00000231
		//7 ZONAS 
		//TEM TEMP DE FILTRO
		//4 MATRIZ
		//NÃO TEM FLANGE 
		//NÃO TEM CALIBRADOR 
		//NÃO TEM HELICOIDAL
		//TEM FILTRO REVERSÍVEL
		//TEM CILINDRO
		
		aVetor := {;
		cZona1      ,cZona11    ,; //  1
		cZona2      ,cZona22    ,; //  2
		cZona3      ,cZona33    ,; //  3
		cZona4      ,cZona44    ,; //  4
		cZona5      ,cZona55    ,; //  5
		cZona6      ,cZona66    ,; //  6  //RETIRADO
		cZona7      ,cZona77    ,; //  7  //RETIRADO
		cMatriz1    ,cMatriz11  ,; //  8
		cMatriz2    ,cMatriz22  ,; //  9
		cMatriz3    ,cMatriz33  ,; // 10
		cMatriz4    ,cMatriz44  ,; // 11
		cFiltro     ,cFiltro1   ,; // 12
		cSlit       ,;             // 13
		cCircAgua   ,;             // 14
		cLinear     ,cLinear1   ,; // 15
		cGrama      ,cGrama1    ,; // 16
		cEspes      ,cEspes1,;     // 17
		cAltura     ,cAltura1   ,; // 18
		cLargura    ,cLargura1  ,; // 19
		cAlinha     ,;             // 20
		cCamera     ,;             // 21
		cSensor     ,;             // 22
		cTratamento ,;             // 23
		cBobina,;                  // 24  
		cFilReve,;                 // 25  
		cFilAlim,;                 // 26  
		cCaroco,;                  //27
		cPlanic,;                  //28
		cKgH   ,;                  //29
		cKgH1  ,; 				  // 30
		cCilindro,;               //31
		cMaqParada   }			  //32
		
		
		//cFlange     ,cFlange1   ,; // 13  //RETIRADO
		//cCalib      ,cCalib1    ,; // 14	//RETIRADO
		//cHelic      ,cHelic1    ,; // 15 //RETIRADO
		
		aMsg := {;
		"ZONA 1 (De)"         ,"ZONA 1 (Ate)"  ,;        //  1
		"ZONA 2 (De)"         ,"ZONA 2 (Ate)"  ,;        //  2
		"ZONA 3 (De)"         ,"ZONA 3 (Ate)"  ,;        //  3
		"ZONA 4 (De)"         ,"ZONA 4 (Ate)"  ,;        //  4
		"ZONA 5 (De)"         ,"ZONA 5 (Ate)"  ,;        //  5
		"ZONA 6 (De)"         ,"ZONA 6 (Ate)"  ,;        //  6
		"ZONA 7 (De)"         ,"ZONA 7 (Ate)"  ,;        //  7
		"MATRIZ 1 (De)"       ,"MATRIZ 1 (Ate)",;        //  8
		"MATRIZ 2 (De)"       ,"MATRIZ 2 (Ate)",;        //  9
		"MATRIZ 3 (De)"       ,"MATRIZ 3 (Ate)",;        // 10
		"MATRIZ 4 (De)"       ,"MATRIZ 4 (Ate)",;        // 11
		"TEMP DE FILTRO (De)" ,"TEMP DE FILTRO (Ate)",;  // 12
		"CONFORMIDADE DO SLIT",;                         // 13
		"CIRCULACAO DE AGUA " ,;                         // 14                                                   
		"LINEAR (De)"         ,"LINEAR (Ate)"     ,;     // 15
		"GRAMA/METRO (De)"    ,"GRAMA/METRO (Ate)",;     // 16
		"ESPESSURA (De)"      ,"ESPESSURA (Ate)"  ,;     // 17
		"ALTURA (De)"         ,"ALTURA  (Ate)"    ,;     // 18
		"LARGURA (De)"        ,"LARGURA (Ate)"    ,;     // 19
		"ALINHAMENTO"         ,;                         // 20
		"CAMERA"              ,;                         // 21
		"SENSOR PONTO DE NEVE",;                         // 22
		"TRATAMENTO"          ,;                         // 23
		"BOBINADEIRA"         ,;                         // 24
		"FILTRO DO REVERSIVEL" ,;                        // 25
		"FILTRO DO ALIMENTADOR",;                        // 26
		"Caroço" ,;                                      // 27
		"PLANICIDADE" ,;                                 // 28
		"Kg/h (De)"  ,;                                  //29
		"Kg/h (Ate)"  ,;            					 //30
		"Cilindro Torre Girat. Limpos?" ,;               //31
		"Maquina Parada?"  }                             //32
	    
		//"FLANGE (De)"         ,"FLANGE (Ate)"        ,;  // 13 //RETIRADO
		//"HELICOIDAL (De)"     ,"HELICOIDAL (Ate)"    ,;  // 15 //RETIRADO 
		//"CALIBRADOR (De)"     ,"CALIBRADOR (Ate)"    ,;  // 14 //RETIRADO
    
	ELSEIF Alltrim(cEXT) = "E02" 
		//FR - 26/11/2012 - CHAMADO: 00000231
		//5 ZONAS
		//NÃO TEM TEMP DE FILTRO  
		//1 MATRIZ
		//TEM FLANGE
		//TEM CALIBRADOR
		//NÃO TEM HELICOIDAL 
		//TEM FILTRO REVERSÍVEL
		//TEM CILINDRO
		
		aVetor := {;
		cZona1      ,cZona11    ,; //  1
		cZona2      ,cZona22    ,; //  2
		cZona3      ,cZona33    ,; //  3
		cZona4      ,cZona44    ,; //  4
		cZona5      ,cZona55    ,; //  5
		cMatriz1    ,cMatriz11  ,; //  8
		cFlange     ,cFlange1   ,; // 13
		cCalib      ,cCalib1    ,; // 14	
		cSlit       ,;             // 16
		cCircAgua   ,;             // 17
		cLinear     ,cLinear1   ,; // 18
		cGrama      ,cGrama1    ,; // 19
		cEspes      ,cEspes1,;     // 20
		cAltura     ,cAltura1   ,; // 21
		cLargura    ,cLargura1  ,; // 22
		cAlinha     ,;             // 23
		cCamera     ,;             // 24
		cSensor     ,;             // 25
		cTratamento ,;             // 26
		cBobina,;                  // 27  
		cFilReve,;                 // 28  
		cFilAlim,;                 // 29  
		cCaroco,;                  //30
		cPlanic,;                  //31
		cKgH   ,;                  //32
		cKgH1  ,; 				  // 33
		cCilindro,;               //34
		cMaqParada   }			  //35
		
		//cZona6      ,cZona66    ,; //  6 //RETIRADO
		//cZona7      ,cZona77    ,; //  7 //RETIRADO
		//cFiltro     ,cFiltro1   ,; // 12 //RETIRADO 
		//cMatriz2    ,cMatriz22  ,; //  9 //RETIRADO
		//cMatriz3    ,cMatriz33  ,; // 10 //RETIRADO
		//cMatriz4    ,cMatriz44  ,; // 11 //RETIRADO
		//cHelic      ,cHelic1    ,; // 15 //RETIRADO
		
		aMsg := {;
		"ZONA 1 (De)"         ,"ZONA 1 (Ate)"  ,;        //  1
		"ZONA 2 (De)"         ,"ZONA 2 (Ate)"  ,;        //  2
		"ZONA 3 (De)"         ,"ZONA 3 (Ate)"  ,;        //  3
		"ZONA 4 (De)"         ,"ZONA 4 (Ate)"  ,;        //  4
		"ZONA 5 (De)"         ,"ZONA 5 (Ate)"  ,;        //  5
		"MATRIZ 1 (De)"       ,"MATRIZ 1 (Ate)",;        //  8
		"FLANGE (De)"         ,"FLANGE (Ate)"        ,;  // 13
		"CALIBRADOR (De)"     ,"CALIBRADOR (Ate)"    ,;  // 14
		"CONFORMIDADE DO SLIT",;                         // 16
		"CIRCULACAO DE AGUA " ,;                         // 17                                                   
		"LINEAR (De)"         ,"LINEAR (Ate)"     ,;     // 18
		"GRAMA/METRO (De)"    ,"GRAMA/METRO (Ate)",;     // 19
		"ESPESSURA (De)"      ,"ESPESSURA (Ate)"  ,;     // 20
		"ALTURA (De)"         ,"ALTURA  (Ate)"    ,;     // 21
		"LARGURA (De)"        ,"LARGURA (Ate)"    ,;     // 22
		"ALINHAMENTO"         ,;                         // 23
		"CAMERA"              ,;                         // 24
		"SENSOR PONTO DE NEVE",;                         // 26
		"TRATAMENTO"          ,;                         // 27
		"BOBINADEIRA"         ,;                         // 28
		"FILTRO DO REVERSIVEL" ,;                        // 29
		"FILTRO DO ALIMENTADOR",;                        // 30
		"CAROÇO" ,;                                      // 31
		"PLANICIDADE" ,;                                 // 32
		"Kg/h (De)"  ,;                                  //33
		"Kg/h (Ate)"  ,;            					 //34
		"Cilindro Torre Girat. Limpos?" ,;               //35
		"Maquina Parada?"  }                             //36
		
		//"ZONA 6 (De)"         ,"ZONA 6 (Ate)"  ,;        //  6 //RETIRADO
		//"ZONA 7 (De)"         ,"ZONA 7 (Ate)"  ,;        //  7 //RETIRADO 
		//"TEMP DE FILTRO (De)" ,"TEMP DE FILTRO (Ate)",;  // 12 //RETIRADO 
		//"MATRIZ 2 (De)"       ,"MATRIZ 2 (Ate)",;        //  9 //RETIRADO
		//"MATRIZ 3 (De)"       ,"MATRIZ 3 (Ate)",;        // 10   //RETIRADO
		//"MATRIZ 4 (De)"       ,"MATRIZ 4 (Ate)",;        // 11   //RETIRADO
	
	ELSEIF Alltrim(cEXT) = "E03"
		//FR - 26/11/2012 - CHAMADO: 00000231
		//5 ZONAS
		//TEM TEMP DE FILTRO  
		//3 MATRIZ
		//NÃO TEM FLANGE
		//NÃO TEM CALIBRADOR
		//NÃO TEM HELICOIDAL 
		//TEM FILTRO REVERSÍVEL
		//TEM CILINDRO
		
		aVetor := {;
		cZona1      ,cZona11    ,; //  1
		cZona2      ,cZona22    ,; //  2
		cZona3      ,cZona33    ,; //  3
		cZona4      ,cZona44    ,; //  4
		cZona5      ,cZona55    ,; //  5
		cMatriz1    ,cMatriz11  ,; //  8
		cMatriz2    ,cMatriz22  ,; //  9
		cMatriz3    ,cMatriz33  ,; // 10
		cFiltro     ,cFiltro1   ,; // 12
		cSlit       ,;             // 16
		cCircAgua   ,;             // 17
		cLinear     ,cLinear1   ,; // 18
		cGrama      ,cGrama1    ,; // 19
		cEspes      ,cEspes1,;     // 20
		cAltura     ,cAltura1   ,; // 21
		cLargura    ,cLargura1  ,; // 22
		cAlinha     ,;             // 23
		cCamera     ,;             // 24
		cSensor     ,;             // 25
		cTratamento ,;             // 26
		cBobina,;                  // 27  
		cFilReve,;                 // 28  
		cFilAlim,;                 // 29  
		cCaroco,;                  //30
		cPlanic,;                  //31
		cKgH   ,;                  //32
		cKgH1  ,; 				  // 33
		cCilindro,;               //34
		cMaqParada   }			  //35
		
		//cZona6      ,cZona66    ,; //  6 //RETIRADO
		//cZona7      ,cZona77    ,; //  7 //RETIRADO
		//cFiltro     ,cFiltro1   ,; // 12 //RETIRADO 
		//cMatriz2    ,cMatriz22  ,; //  9 //RETIRADO
		//cMatriz3    ,cMatriz33  ,; // 10 //RETIRADO
		//cMatriz4    ,cMatriz44  ,; // 11 //RETIRADO
		//cFlange     ,cFlange1   ,; // 13 //RETIRADO 
		//cCalib      ,cCalib1    ,; // 14	//RETIRADO
		//cHelic      ,cHelic1    ,; // 15 //RETIRADO
		
		aMsg := {;
		"ZONA 1 (De)"         ,"ZONA 1 (Ate)"  ,;        //  1
		"ZONA 2 (De)"         ,"ZONA 2 (Ate)"  ,;        //  2
		"ZONA 3 (De)"         ,"ZONA 3 (Ate)"  ,;        //  3
		"ZONA 4 (De)"         ,"ZONA 4 (Ate)"  ,;        //  4
		"ZONA 5 (De)"         ,"ZONA 5 (Ate)"  ,;        //  5
		"MATRIZ 1 (De)"       ,"MATRIZ 1 (Ate)",;        //  8
		"MATRIZ 2 (De)"       ,"MATRIZ 2 (Ate)",;        //  9
		"MATRIZ 3 (De)"       ,"MATRIZ 3 (Ate)",;        // 10
		"TEMP DE FILTRO (De)" ,"TEMP DE FILTRO (Ate)",;  // 12
		"CONFORMIDADE DO SLIT",;                         // 16
		"CIRCULACAO DE AGUA " ,;                         // 17                                                   
		"LINEAR (De)"         ,"LINEAR (Ate)"     ,;     // 18
		"GRAMA/METRO (De)"    ,"GRAMA/METRO (Ate)",;     // 19
		"ESPESSURA (De)"      ,"ESPESSURA (Ate)"  ,;     // 20
		"ALTURA (De)"         ,"ALTURA  (Ate)"    ,;     // 21
		"LARGURA (De)"        ,"LARGURA (Ate)"    ,;     // 22
		"ALINHAMENTO"         ,;                         // 23
		"CAMERA"              ,;                         // 24
		"SENSOR PONTO DE NEVE",;                         // 26
		"TRATAMENTO"          ,;                         // 27
		"BOBINADEIRA"         ,;                         // 28
		"FILTRO DO REVERSIVEL" ,;                        // 29
		"FILTRO DO ALIMENTADOR",;                        // 30
		"CAROÇO" ,;                                      // 31
		"PLANICIDADE" ,;                                 // 32
		"Kg/h (De)"  ,;                                  //33
		"Kg/h (Ate)"  ,;            					 //34
		"Cilindro Torre Girat. Limpos?" ,;               //35
		"Maquina Parada?"  }                             //36
	    
	    //"ZONA 6 (De)"         ,"ZONA 6 (Ate)"  ,;        //  6 //RETIRADO
		//"ZONA 7 (De)"         ,"ZONA 7 (Ate)"  ,;        //  7 //RETIRADO
		//"MATRIZ 4 (De)"       ,"MATRIZ 4 (Ate)",;        // 11 //RETIRADO
		//"FLANGE (De)"         ,"FLANGE (Ate)"        ,;  // 13 //RETIRADO
		//"HELICOIDAL (De)"     ,"HELICOIDAL (Ate)"    ,;  // 15 //RETIRADO 
		//"CALIBRADOR (De)"     ,"CALIBRADOR (Ate)"    ,;  // 14 //RETIRADO
	
	
	ENDIF
Else  //é EXTRUSORA E04 ou E05  
//-> NÃO POSSUEM CILINDROS, NÃO POSSUEM FILTRO REVERSÍVEL
//POSSUI HELICOIDAL
	IF Alltrim(cEXT) = "E04" 
		//FR - 26/11/12 - CHAMADO: 00000231
		//5 ZONAS 
		//NÃO TEM TEMP DE FILTRO
		//1 MATRIZ      
		//NÃO TEM FLANGE
		//NÃO TEM CALIBRADOR
		//TEM HELICOIDAL
		//NÃO TEM FILTRO REVERSÍVEL
		//NÃO TEM CILINDRO
		
			aVetor := {;
		cZona1      ,cZona11    ,; //  1
		cZona2      ,cZona22    ,; //  2
		cZona3      ,cZona33    ,; //  3
		cZona4      ,cZona44    ,; //  4
		cZona5      ,cZona55    ,; //  5
		cMatriz1    ,cMatriz11  ,; //  8
		cHelic      ,cHelic1    ,; // 15
		cSlit       ,;             // 16
		cCircAgua   ,;             // 17
		cLinear     ,cLinear1   ,; // 18
		cGrama      ,cGrama1    ,; // 19
		cEspes      ,cEspes1,;     // 20
		cAltura     ,cAltura1   ,; // 21
		cLargura    ,cLargura1  ,; // 22
		cAlinha     ,;             // 23
		cCamera     ,;             // 24
		cSensor     ,;             // 25
		cTratamento ,;             // 26
		cBobina,;                  // 27  
		cFilAlim,;                 // 28  
		cCaroco,;                  //29
		cPlanic,;                  //30
		cKgH   ,;                  //31
		cKgH1  ,; 				  // 32
		cMaqParada   }			  //33  
		
		//cZona6      ,cZona66    ,; //  6 //RETIRADO
		//cZona7      ,cZona77    ,; //  7 //RETIRADO
		//cFiltro     ,cFiltro1   ,; // 12 //RETIRADO 
		//cMatriz2    ,cMatriz22  ,; //  9 //RETIRADO
		//Matriz3    ,cMatriz33  ,; // 10  //RETIRADO
		//cMatriz4    ,cMatriz44  ,; // 11 //RETIRADO
		//cFlange     ,cFlange1   ,; // 13 //RETIRADO
		//cCalib      ,cCalib1    ,; // 14 //RETIRADO
		
		aMsg := {;
		"ZONA 1 (De)"         ,"ZONA 1 (Ate)"  ,;        //  1
		"ZONA 2 (De)"         ,"ZONA 2 (Ate)"  ,;        //  2
		"ZONA 3 (De)"         ,"ZONA 3 (Ate)"  ,;        //  3
		"ZONA 4 (De)"         ,"ZONA 4 (Ate)"  ,;        //  4
		"ZONA 5 (De)"         ,"ZONA 5 (Ate)"  ,;        //  5
		"MATRIZ 1 (De)"       ,"MATRIZ 1 (Ate)",;        //  8
		"HELICOIDAL (De)"     ,"HELICOIDAL (Ate)"    ,;  // 15
		"CONFORMIDADE DO SLIT",;                         // 16
		"CIRCULACAO DE AGUA " ,;                         // 17                                                 
		"LINEAR (De)"         ,"LINEAR (Ate)"     ,;     // 18
		"GRAMA/METRO (De)"    ,"GRAMA/METRO (Ate)",;     // 19
		"ESPESSURA (De)"      ,"ESPESSURA (Ate)"  ,;     // 20
		"ALTURA (De)"         ,"ALTURA  (Ate)"    ,;     // 21
		"LARGURA (De)"        ,"LARGURA (Ate)"    ,;     // 22
		"ALINHAMENTO"         ,;                         // 23
		"CAMERA"              ,;                         // 24
		"SENSOR PONTO DE NEVE",;                         // 25
		"TRATAMENTO"          ,;                         // 26
		"BOBINADEIRA"         ,;                         // 27
		"FILTRO DO ALIMENTADOR",;                        // 28
		"CAROÇO" ,;                                      // 29
		"PLANICIDADE" ,;                                 // 30
		"Kg/h (De)"  ,;                                  //31
		"Kg/h (Ate)"  ,;            					 //32
		"Maquina Parada?"  }                             //33
		
		//"ZONA 6 (De)"         ,"ZONA 6 (Ate)"  ,;        //  6 //RETIRADO
		//"ZONA 7 (De)"         ,"ZONA 7 (Ate)"  ,;        //  7 //RETIRADO
        //"TEMP DE FILTRO (De)" ,"TEMP DE FILTRO (Ate)",;  // 12 //RETIRADO 
        //"MATRIZ 2 (De)"       ,"MATRIZ 2 (Ate)",;        //  9 //RETIRADO
		//"MATRIZ 3 (De)"       ,"MATRIZ 3 (Ate)",;        // 10 //RETIRADO
		//"MATRIZ 4 (De)"       ,"MATRIZ 4 (Ate)",;        // 11 //RETIRADO
        //"FLANGE (De)"         ,"FLANGE (Ate)"        ,;  // 13 //RETIRADO
        //"CALIBRADOR (De)"     ,"CALIBRADOR (Ate)"    ,;  // 14 //RETIRADO
        
    ELSEIF Alltrim(cEXT) = "E05"
    	//FR - 26/11/12 - CHAMADO: 00000231
    	//4 ZONAS
    	//NÃO TEM TEMP DE FILTRO
    	//NÃO TEM FLANGE
    	//NÃO TEM CALIBRADOR
    	//TEM HELICOIDAL
    	//NÃO TEM FILTRO REVERSÍVEL
    	//NÃO TEM CILINDRO
    	
	    aVetor := {;
		cZona1      ,cZona11    ,; //  1
		cZona2      ,cZona22    ,; //  2
		cZona3      ,cZona33    ,; //  3
		cZona4      ,cZona44    ,; //  4
		cMatriz1    ,cMatriz11  ,; //  8
		cHelic      ,cHelic1    ,; // 15
		cSlit       ,;             // 16
		cCircAgua   ,;             // 17
		cLinear     ,cLinear1   ,; // 18
		cGrama      ,cGrama1    ,; // 19
		cEspes      ,cEspes1,;     // 20
		cAltura     ,cAltura1   ,; // 21
		cLargura    ,cLargura1  ,; // 22
		cAlinha     ,;             // 23
		cCamera     ,;             // 24
		cSensor     ,;             // 25
		cTratamento ,;             // 26
		cBobina,;                  // 27  
		cFilAlim,;                 // 28  
		cCaroco,;                  //29
		cPlanic,;                  //30
		cKgH   ,;                  //31
		cKgH1  ,; 				  // 32
		cMaqParada   }			  //33
		
		//cZona5      ,cZona55    ,; //  5 //RETIRADO
		//cZona6      ,cZona66    ,; //  6 //RETIRADO
		//cZona7      ,cZona77    ,; //  7 //RETIRADO 
		//cFiltro     ,cFiltro1   ,; // 12 //RETIRADO
		//cMatriz2    ,cMatriz22  ,; //  9 //RETIRADO
		//cMatriz3    ,cMatriz33  ,; // 10 //RETIRADO
		//cMatriz4    ,cMatriz44  ,; // 11 //RETIRADO    
		//cFlange     ,cFlange1   ,; // 13 //RETIRADO
		//cCalib      ,cCalib1    ,; // 14 //RETIRADO
		
		aMsg := {;
		"ZONA 1 (De)"         ,"ZONA 1 (Ate)"  ,;        //  1
		"ZONA 2 (De)"         ,"ZONA 2 (Ate)"  ,;        //  2
		"ZONA 3 (De)"         ,"ZONA 3 (Ate)"  ,;        //  3
		"ZONA 4 (De)"         ,"ZONA 4 (Ate)"  ,;        //  4
		"MATRIZ 1 (De)"       ,"MATRIZ 1 (Ate)",;        //  8
		"HELICOIDAL (De)"     ,"HELICOIDAL (Ate)"    ,;  // 15
		"CONFORMIDADE DO SLIT",;                         // 16
		"CIRCULACAO DE AGUA " ,;                         // 17                                                 
		"LINEAR (De)"         ,"LINEAR (Ate)"     ,;     // 18
		"GRAMA/METRO (De)"    ,"GRAMA/METRO (Ate)",;     // 19
		"ESPESSURA (De)"      ,"ESPESSURA (Ate)"  ,;     // 20
		"ALTURA (De)"         ,"ALTURA  (Ate)"    ,;     // 21
		"LARGURA (De)"        ,"LARGURA (Ate)"    ,;     // 22
		"ALINHAMENTO"         ,;                         // 23
		"CAMERA"              ,;                         // 24
		"SENSOR PONTO DE NEVE",;                         // 25
		"TRATAMENTO"          ,;                         // 26
		"BOBINADEIRA"         ,;                         // 27
		"FILTRO DO ALIMENTADOR",;                        // 28
		"CAROÇO" ,;                                      // 29
		"PLANICIDADE" ,;                                 // 30
		"Kg/h (De)"  ,;                                  //31
		"Kg/h (Ate)"  ,;            					 //32
		"Maquina Parada?"  }                             //33
		
		//"ZONA 5 (De)"         ,"ZONA 5 (Ate)"  ,;        //  5 //RETIRADO
		//"ZONA 6 (De)"         ,"ZONA 6 (Ate)"  ,;        //  6 //RETIRADO
		//"ZONA 7 (De)"         ,"ZONA 7 (Ate)"  ,;        //  7 //RETIRADO   
		//"TEMP DE FILTRO (De)" ,"TEMP DE FILTRO (Ate)",;  // 12 //RETIRADO
		//"MATRIZ 2 (De)"       ,"MATRIZ 2 (Ate)",;        //  9 //RETIRADO
		//"MATRIZ 3 (De)"       ,"MATRIZ 3 (Ate)",;        // 10 //RETIRADO
		//"MATRIZ 4 (De)"       ,"MATRIZ 4 (Ate)",;        // 11 //RETIRADO 
		//"FLANGE (De)"         ,"FLANGE (Ate)"        ,;  // 13 //RETIRADO
        //"CALIBRADOR (De)"     ,"CALIBRADOR (Ate)"    ,;  // 14 //RETIRADO
        
    ENDIF
    
Endif
 
cVazio:=''
cMsg:='FAVOR CONFIRMAR o Campo'

for x:=1 to len(avetor)
	if alltrim(aVetor[x]) == cVazio
		alert (cMsg+" "+aMsg[x])
		aObj[x]:SetFocus() 
		return
	endif
next

If Alltrim(cEXT) != "E04" .and. Alltrim(cEXT) != "E05"

//as EXTRUSORAS DIFERENTES DE E04 e E05:
// POSSUEM CILINDROS
// POSSUEM FILTRO REVERSÍVEL
//NÃO POSSUEM HELICOIDAL
//FR - 26/11/12 - CHAMADO 00000231 - RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
	If Alltrim(cEXT) = "E01"
		//FR - 26/11/12 - CHAMADO: 00000231
		//7 ZONAS
		//TEM TEMP DE FILTRO
		//4 MATRIZ
		//NÃO TEM FLANGE
		//NÃO TEM CALIBRADOR
		//NÃO TEM HELICOIDAL
		//TEM FILTRO REVERSÍVEL
		//TEM CILINDRO
		
		aValores:={;                // 12345678901234567890
		{cZona1     ,"T01",cZona11   ,"ZONA 1"               },; // 01
		{cZona2     ,"T04",cZona22   ,"ZONA 2"               },; // 02
		{cZona3     ,"T05",cZona33   ,"ZONA 3"               },; // 03
		{cZona4     ,"T06",cZona44   ,"ZONA 4"               },; // 04
		{cZona5     ,"T07",cZona55   ,"ZONA 5"               },; // 05
		{cZona6     ,"T08",cZona66   ,"ZONA 6"               },; // 06
		{cZona7     ,"T09",cZona77   ,"ZONA 7"               },; // 07
		{cMatriz1   ,"T02",cMatriz11 ,"MATRIZ 1"             },; // 08
		{cMatriz2   ,"T10",cMatriz22 ,"MATRIZ 2"             },; // 09
		{cMatriz3   ,"T11",cMatriz33 ,"MATRIZ 3"             },; // 10
		{cMatriz4   ,"T12",cMatriz44 ,"MATRIZ 4"             },; // 11
		{cFiltro    ,"T14",cFiltro1  ,"TEMP DE FILTRO"       },; // 12
		{cSlit      ,"T03",""        ,"CONFORMIDADE DO SLIT" },; // 16
		{cCircAgua  ,"T13",""        ,"CIRCULACAO DE AGUA "  },; // 17
		{cLinear    ,"G01",cLinear1  ,"LINEAR"               },; // 18
		{cGrama     ,"G02",cGrama1   ,"GRAMA/METRO"          },; // 19
		{cEspes     ,"G03",cEspes1   ,"ESPESSURA"            },; // 20
		{cAltura    ,"G04",cAltura1  ,"ALTURA DO BALAO"      },; // 21
		{cLargura   ,"G05",cLargura1 ,"LARGURA DA BOBINA"    },; // 22
		{cAlinha    ,"G06",""        ,"ALINHAMENTO BOBINA"   },; // 23
		{cCaroco    ,"G07",""        ,"CAROCO"               },; // 24
		{cPlanic    ,"G08",""        ,"PLANICIDADE"          },; // 25
		{cKgH       ,"G09",cKgH1     ,"KG/H"                 },; // 33
		{cCamera    ,"F01",""        ,"CAMERA"               },; // 26
		{cSensor    ,"F03",""        ,"SENSOR PONTO DE NEVE" },; // 28
		{cTratamento,"F04",""        ,"TRATAMENTO"           },; // 29
		{cBobina    ,"F05",""        ,"BOBINADEIRA"          },; // 30
		{cFilReve   ,"F06",""        ,"FILTRO DO REVERSIVEL"  },; // 31
		{cFilAlim   ,"F07",""        ,"FILTRO DO ALIMENTADOR" },;  // 32
		{cCilindro  ,"F08",""        ,"CILINDROS TORRE GIRAT.LIMPOS?" },;  // 33
		{cMaqParada ,"F09",""        ,"MAQUINA PARADA?" };  // 34
		}
		
		//{cFlange    ,"T15",cFlange1  ,"FLANGE"               },; // 13 //RETIRADO
		//{cCalib     ,"T16",cCalib1   ,"CALIBRADOR"           },; // 14 //RETIRADO
		//	{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 15 //RETIRADO
		
	ELSEIF Alltrim(cEXT) = "E02"
		//FR - 26/11/12 - CHAMADO: 00000231
		//5 ZONAS
		//NÃO TEM TEMP DE FILTRO
		//1 MATRIZ 
		//TEM FLANGE 
		//TEM CALIBRADOR
		//NÃO TEM HELICOIDAL
		//TEM FILTRO REVERSÍVEL
		//TEM CILINDRO
		
				aValores:={;                // 12345678901234567890
		{cZona1     ,"T01",cZona11   ,"ZONA 1"               },; // 01
		{cZona2     ,"T04",cZona22   ,"ZONA 2"               },; // 02
		{cZona3     ,"T05",cZona33   ,"ZONA 3"               },; // 03
		{cZona4     ,"T06",cZona44   ,"ZONA 4"               },; // 04
		{cZona5     ,"T07",cZona55   ,"ZONA 5"               },; // 05
		{cMatriz1   ,"T02",cMatriz11 ,"MATRIZ 1"             },; // 08
		{cFlange    ,"T15",cFlange1  ,"FLANGE"               },; // 13
		{cCalib     ,"T16",cCalib1   ,"CALIBRADOR"           },; // 14
		{cSlit      ,"T03",""        ,"CONFORMIDADE DO SLIT" },; // 16
		{cCircAgua  ,"T13",""        ,"CIRCULACAO DE AGUA "  },; // 17
		{cLinear    ,"G01",cLinear1  ,"LINEAR"               },; // 18
		{cGrama     ,"G02",cGrama1   ,"GRAMA/METRO"          },; // 19
		{cEspes     ,"G03",cEspes1   ,"ESPESSURA"            },; // 20
		{cAltura    ,"G04",cAltura1  ,"ALTURA DO BALAO"      },; // 21
		{cLargura   ,"G05",cLargura1 ,"LARGURA DA BOBINA"    },; // 22
		{cAlinha    ,"G06",""        ,"ALINHAMENTO BOBINA"   },; // 23
		{cCaroco    ,"G07",""        ,"CAROCO"               },; // 24
		{cPlanic    ,"G08",""        ,"PLANICIDADE"          },; // 25
		{cKgH       ,"G09",cKgH1     ,"KG/H"                 },; // 33
		{cCamera    ,"F01",""        ,"CAMERA"               },; // 26
		{cSensor    ,"F03",""        ,"SENSOR PONTO DE NEVE" },; // 28
		{cTratamento,"F04",""        ,"TRATAMENTO"           },; // 29
		{cBobina    ,"F05",""        ,"BOBINADEIRA"          },; // 30
		{cFilReve   ,"F06",""        ,"FILTRO DO REVERSIVEL"  },; // 31
		{cFilAlim   ,"F07",""        ,"FILTRO DO ALIMENTADOR" },;  // 32
		{cCilindro  ,"F08",""        ,"CILINDROS TORRE GIRAT.LIMPOS?" },;  // 33
		{cMaqParada ,"F09",""        ,"MAQUINA PARADA?" };  // 34
		}
		
		//{cZona6     ,"T08",cZona66   ,"ZONA 6"               },; // 06 //RETIRADO
		//{cZona7     ,"T09",cZona77   ,"ZONA 7"               },; // 07  //RETIRADO 
		//{cFiltro    ,"T14",cFiltro1  ,"TEMP DE FILTRO"       },; // 12  //RETIRADO
		//{cMatriz2   ,"T10",cMatriz22 ,"MATRIZ 2"             },; // 09  //RETIRADO
		//{cMatriz3   ,"T11",cMatriz33 ,"MATRIZ 3"             },; // 10  //RETIRADO
		//{cMatriz4   ,"T12",cMatriz44 ,"MATRIZ 4"             },; // 11  //RETIRADO
		//	{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 15 //RETIRADO
		
	ELSEIF Alltrim(cEXT) = "E03"
		//5 ZONAS
		//TEM TEMP DE FILTR
		//3 MATRIZ
		//NÃO TEM FLANGE
		//NÃO TEM CALIBRADOR
		//NÃO TEM HELICOIDAL 
		//TEM FILTRO REVERSÍVEL
		//TEM CILINDRO
		
				aValores:={;                // 12345678901234567890
		{cZona1     ,"T01",cZona11   ,"ZONA 1"               },; // 01
		{cZona2     ,"T04",cZona22   ,"ZONA 2"               },; // 02
		{cZona3     ,"T05",cZona33   ,"ZONA 3"               },; // 03
		{cZona4     ,"T06",cZona44   ,"ZONA 4"               },; // 04
		{cZona5     ,"T07",cZona55   ,"ZONA 5"               },; // 05
		{cMatriz1   ,"T02",cMatriz11 ,"MATRIZ 1"             },; // 08
		{cMatriz2   ,"T10",cMatriz22 ,"MATRIZ 2"             },; // 09
		{cMatriz3   ,"T11",cMatriz33 ,"MATRIZ 3"             },; // 10
		{cFiltro    ,"T14",cFiltro1  ,"TEMP DE FILTRO"       },; // 12
		{cSlit      ,"T03",""        ,"CONFORMIDADE DO SLIT" },; // 16
		{cCircAgua  ,"T13",""        ,"CIRCULACAO DE AGUA "  },; // 17
		{cLinear    ,"G01",cLinear1  ,"LINEAR"               },; // 18
		{cGrama     ,"G02",cGrama1   ,"GRAMA/METRO"          },; // 19
		{cEspes     ,"G03",cEspes1   ,"ESPESSURA"            },; // 20
		{cAltura    ,"G04",cAltura1  ,"ALTURA DO BALAO"      },; // 21
		{cLargura   ,"G05",cLargura1 ,"LARGURA DA BOBINA"    },; // 22
		{cAlinha    ,"G06",""        ,"ALINHAMENTO BOBINA"   },; // 23
		{cCaroco    ,"G07",""        ,"CAROCO"               },; // 24
		{cPlanic    ,"G08",""        ,"PLANICIDADE"          },; // 25
		{cKgH       ,"G09",cKgH1     ,"KG/H"                 },; // 33
		{cCamera    ,"F01",""        ,"CAMERA"               },; // 26
		{cSensor    ,"F03",""        ,"SENSOR PONTO DE NEVE" },; // 28
		{cTratamento,"F04",""        ,"TRATAMENTO"           },; // 29
		{cBobina    ,"F05",""        ,"BOBINADEIRA"          },; // 30
		{cFilReve   ,"F06",""        ,"FILTRO DO REVERSIVEL"  },; // 31
		{cFilAlim   ,"F07",""        ,"FILTRO DO ALIMENTADOR" },;  // 32
		{cCilindro  ,"F08",""        ,"CILINDROS TORRE GIRAT.LIMPOS?" },;  // 33
		{cMaqParada ,"F09",""        ,"MAQUINA PARADA?" };  // 34
		}
		
		//{cZona6     ,"T08",cZona66   ,"ZONA 6"               },; // 06 //RETIRADO
		//{cZona7     ,"T09",cZona77   ,"ZONA 7"               },; // 07 //RETIRADO
		//{cMatriz4   ,"T12",cMatriz44 ,"MATRIZ 4"             },; // 11 //RETIRADO
		//{cFlange    ,"T15",cFlange1  ,"FLANGE"               },; // 13 //RETIRADO
		//{cCalib     ,"T16",cCalib1   ,"CALIBRADOR"           },; // 14 //RETIRADO
		//	{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 15 //RETIRADO
	ENDIF
Else   // E04 ou E05

//as EXTRUSORAS = E04 e E05:
//NÃO POSSUEM CILINDROS
//NÃO POSSUEM FILTRO REVERSÍVEL
//POSSUEM HELICOIDAL
//FR - 26/11/12 - CHAMADO 00000231 - RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
	IF Alltrim(cEXT) = "E04"                                                         
		//5 ZONAS
		//NÃO TEM TEMP DE FILTRO
		//1 MATRIZ  
		//NÃO TEM FLANGE
		//NÃO TEM CALIBRADOR
		//TEM HELICOIDAL
		//NÃO TEM FILTRO REVERSÍVEL
		//NÃO TEM CILINDRO
		
		aValores:={;                // 12345678901234567890
		{cZona1     ,"T01",cZona11   ,"ZONA 1"               },; // 01
		{cZona2     ,"T04",cZona22   ,"ZONA 2"               },; // 02
		{cZona3     ,"T05",cZona33   ,"ZONA 3"               },; // 03
		{cZona4     ,"T06",cZona44   ,"ZONA 4"               },; // 04
		{cZona5     ,"T07",cZona55   ,"ZONA 5"               },; // 05
		{cMatriz1   ,"T02",cMatriz11 ,"MATRIZ 1"             },; // 08
		{cSlit      ,"T03",""        ,"CONFORMIDADE DO SLIT" },; // 16
		{cCircAgua  ,"T13",""        ,"CIRCULACAO DE AGUA "  },; // 17
		{cLinear    ,"G01",cLinear1  ,"LINEAR"               },; // 18
		{cGrama     ,"G02",cGrama1   ,"GRAMA/METRO"          },; // 19
		{cEspes     ,"G03",cEspes1   ,"ESPESSURA"            },; // 20
		{cAltura    ,"G04",cAltura1  ,"ALTURA DO BALAO"      },; // 21
		{cLargura   ,"G05",cLargura1 ,"LARGURA DA BOBINA"    },; // 22
		{cAlinha    ,"G06",""        ,"ALINHAMENTO BOBINA"   },; // 23
		{cCaroco    ,"G07",""        ,"CAROCO"               },; // 24
		{cPlanic    ,"G08",""        ,"PLANICIDADE"          },; // 25
		{cKgH       ,"G09",cKgH1     ,"KG/H"                 },; // 33
		{cCamera    ,"F01",""        ,"CAMERA"               },; // 26
		{cGeladeira ,"F02",""        ,"GELADEIRA"            },; // 27
		{cSensor    ,"F03",""        ,"SENSOR PONTO DE NEVE" },; // 28
		{cTratamento,"F04",""        ,"TRATAMENTO"           },; // 29
		{cBobina    ,"F05",""        ,"BOBINADEIRA"          },; // 30
		{cFilAlim   ,"F07",""        ,"FILTRO DO ALIMENTADOR" },;  // 32
		{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 35
		{cMaqParada ,"F09",""        ,"MAQUINA PARADA?" };  // 34
		}
		
		//{cZona6     ,"T08",cZona66   ,"ZONA 6"               },; // 06 //RETIRADO
		//{cZona7     ,"T09",cZona77   ,"ZONA 7"               },; // 07 //RETIRADO
		//{cFiltro    ,"T14",cFiltro1  ,"TEMP DE FILTRO"       },; // 12 //RETIRADO
		//{cMatriz2   ,"T10",cMatriz22 ,"MATRIZ 2"             },; // 09 //RETIRADO
		//{cMatriz3   ,"T11",cMatriz33 ,"MATRIZ 3"             },; // 10 //RETIRADO
		//{cMatriz4   ,"T12",cMatriz44 ,"MATRIZ 4"             },; // 11 //RETIRADO
		//{cFlange    ,"T15",cFlange1  ,"FLANGE"               },; // 13 //RETIRADO
		//{cCalib     ,"T16",cCalib1   ,"CALIBRADOR"           },; // 14 //RETIRADO
		//{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 15 //RETIRADO
		
	ELSEIF Alltrim(cEXT) = "E05"
		//4 ZONAS
		//NÃO TEM TEMP DE FILTRO
		//1 MATRIZ  
		//NÃO TEM FLANGE
		//NÃO TEM CALIBRADOR
		//TEM HELICOIDAL
		//NÃO TEM FILTRO REVERSÍVEL
		//NÃO TEM CILINDRO
		
		aValores:={;                // 12345678901234567890
		{cZona1     ,"T01",cZona11   ,"ZONA 1"               },; // 01
		{cZona2     ,"T04",cZona22   ,"ZONA 2"               },; // 02
		{cZona3     ,"T05",cZona33   ,"ZONA 3"               },; // 03
		{cZona4     ,"T06",cZona44   ,"ZONA 4"               },; // 04
		{cMatriz1   ,"T02",cMatriz11 ,"MATRIZ 1"             },; // 08
		{cSlit      ,"T03",""        ,"CONFORMIDADE DO SLIT" },; // 16
		{cCircAgua  ,"T13",""        ,"CIRCULACAO DE AGUA "  },; // 17
		{cLinear    ,"G01",cLinear1  ,"LINEAR"               },; // 18
		{cGrama     ,"G02",cGrama1   ,"GRAMA/METRO"          },; // 19
		{cEspes     ,"G03",cEspes1   ,"ESPESSURA"            },; // 20
		{cAltura    ,"G04",cAltura1  ,"ALTURA DO BALAO"      },; // 21
		{cLargura   ,"G05",cLargura1 ,"LARGURA DA BOBINA"    },; // 22
		{cAlinha    ,"G06",""        ,"ALINHAMENTO BOBINA"   },; // 23
		{cCaroco    ,"G07",""        ,"CAROCO"               },; // 24
		{cPlanic    ,"G08",""        ,"PLANICIDADE"          },; // 25
		{cKgH       ,"G09",cKgH1     ,"KG/H"                 },; // 33
		{cCamera    ,"F01",""        ,"CAMERA"               },; // 26
		{cGeladeira ,"F02",""        ,"GELADEIRA"            },; // 27
		{cSensor    ,"F03",""        ,"SENSOR PONTO DE NEVE" },; // 28
		{cTratamento,"F04",""        ,"TRATAMENTO"           },; // 29
		{cBobina    ,"F05",""        ,"BOBINADEIRA"          },; // 30
		{cFilAlim   ,"F07",""        ,"FILTRO DO ALIMENTADOR" },;  // 32
		{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 35
		{cMaqParada ,"F09",""        ,"MAQUINA PARADA?" };  // 34
		} 
		
		//{cZona5     ,"T07",cZona55   ,"ZONA 5"               },; // 05
		//{cZona6     ,"T08",cZona66   ,"ZONA 6"               },; // 06 //RETIRADO
		//{cZona7     ,"T09",cZona77   ,"ZONA 7"               },; // 07 //RETIRADO
		//{cFiltro    ,"T14",cFiltro1  ,"TEMP DE FILTRO"       },; // 12 //RETIRADO
		//{cMatriz2   ,"T10",cMatriz22 ,"MATRIZ 2"             },; // 09 //RETIRADO
		//{cMatriz3   ,"T11",cMatriz33 ,"MATRIZ 3"             },; // 10 //RETIRADO
		//{cMatriz4   ,"T12",cMatriz44 ,"MATRIZ 4"             },; // 11 //RETIRADO
		//{cFlange    ,"T15",cFlange1  ,"FLANGE"               },; // 13 //RETIRADO
		//{cCalib     ,"T16",cCalib1   ,"CALIBRADOR"           },; // 14 //RETIRADO
		//{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 15 //RETIRADO
	
	ENDIF  // = E04, E05
	
Endif

FOR nCont:=1 to len(aValores)
    Z59->(dbsetorder(1))
    if Z59->( dbSeek( xFilial("Z59") +SUBSTR(cEXT,1,3)+cPROD+aValores[nCont][2],.F. ) )  .and. XFuncao==3  // alterar  
       RecLock('Z59',.F.)
	   Z59->Z59_VALOR :=aValores[nCont][1]
	   Z59->Z59_VALOR2:=aValores[nCont][3] 
	   Z59->(MsUnlock())
    Else
       RecLock('Z59',.T.)  
	   Z59->Z59_EXTRUS:=cEXT
	   Z59->Z59_PRODUT:=cPROD
	   Z59->Z59_FILIAL:=xFilial("Z59")
	   Z59->Z59_ITEM :=aValores[nCont][2]
	   Z59->Z59_ITEMD:=aValores[nCont][4]             		
	   Z59->Z59_VALOR :=aValores[nCont][1]
	   Z59->Z59_VALOR2:=aValores[nCont][3]
	   Z59->(MsUnlock())
    EndIf
next nCont
IF XFuncao==3  // alterar
   Z59->( dbGoto( nZ59Reg ) )
Endif

oDlg1:end()

return


*************** 

Static Function  Travar(oObj)

***************

if lDisable
	oObj:disable()
endif

return
                       
***************

Static Function MaqExt(cExt)

***************

local cQry:=''
local lret:=.F.
cQry:="SELECT H1_CODIGO MAQUINA FROM "+ RetSqlName( "SH1" ) +" SH1 "
cQry+="WHERE  H1_FILIAL='"+xfilial('SH1')+"' "
cQry+="AND H1_CODIGO='"+cExt+"'  "
cQry+="AND H1_CODIGO LIKE '[E][0123456789]%'  "
cQry+="AND SH1.D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "AUXX"

IF AUXX->(!EOF())
   lret:=.T.
ENDIF

AUXX->(DBCLOSEAREA())

Return lret