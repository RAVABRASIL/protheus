#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

*************

User Function PCPC006V2()

*************

Local aCores := {;
{"Z60_PENDEN == 'N'", "BR_VERDE"   },;
{"Z60_PENDEN == 'S'  .and. Z60_INICIO != '*' ", "BR_AMARELO" },;
{"Z60_INICIO == '*'", "BR_VERMELHO"};
}

//public cModoProg:='teste'//'real'

public nAtraso:=0,hora:='00:00',encontrou:=0, cPeriodo:="",aTmp:={},cOperador:=space(6)
aRotina := {;
{"Pesquisar"   , "AxPesqui"     , 0, 1},;
{"Incluir"     , "U_CAD_Z60V2(1)" , 0, 3},;
{"Visualizar"  , "U_CAD_Z60V2(2)" , 0, 2},;
{"Corrigir"    , "U_CAD_Z60V2(3)" , 0, 4},;
{"Legenda"     , "U_LegenZ60V2"    , 0, 6}}

cCadastro := OemToAnsi("Inspecao")
cAlias:='Z60'
DbSelectArea(cAlias)
DbSetOrder(1)
Set filter To (  Z60_PENDEN == 'S'    )  
DbGotop()
mBrowse( 06, 01, 22, 75, cAlias,,,,,,aCores )

Return

*************

User Function LegenV2()

*************

				Local aLegenda := {;
{"BR_VERDE"   ,"Inspeção Concluida" },;
{"BR_VERMELHO","Origem da Pendencia"},;
{"BR_AMARELO" ,"Inspeção Pendente"  } ;
}


BrwLegenda("Inspeções","Legenda",aLegenda)

Return .T.

*************

User Function  CAD_Z60V2(Funcao) 

*************

aVariavel := {}

									
encontrou:=0
public;
cTemp       :=;
cZona1      := cZona11   :=;
cZona2      := cZona22   :=;
cZona3      := cZona33   :=;
cZona4      := cZona44   :=;
cZona5      := cZona55   :=;
cZona6      := cZona66   :=;
cZona7      := cZona77   :=;
cMatriz1    := cMatriz11 :=;
cMatriz2    := cMatriz22 :=;
cMatriz3    := cMatriz33 :=;
cMatriz4    := cMatriz44 :=;
cSlit       :=;
cCircAgua   :=;   
cEspes      := cEspes1:=;
cLinear     := cLinear1  :=;
cGrama      := cGrama1   :=;
cAltura     := cAltura1  :=;
cLargura    := cLargura1 :=;
cAlinha     :=;
cCamera     := cGeladeira:=;
cSensor     :=;
cTratamento :=;
cBobina     :=; 
cHelic	    := cHelic1  :=;
cCalib      := cCalib1  :=;
cFlange     := cFlange1 :=;
cFiltro	    := cFiltro1 :=;
cFilReve    :=;
cFilAlim    :=;
cCaroco     :=;
cPlanic     :=;
cKgH	    := cKgH1:=;
cMaqParada  := cCilindro := cOBSMAQ := space(150)
Private cOBS1 := Space(25)
Private cOBS2 := Space(25)
Private cOBS3 := Space(25)
Private cOBS4 := Space(25)
Private cOBS5 := Space(25)
Private cOBS6 := Space(25)
Private cOBS7 := Space(25)
Private cInicio := ""

Private oMaqParada
Private oCilindro 
Private lParada := .F.

Private oZona1
Private oZona2
Private oZona3
Private oZona4
Private oZona5
Private oZona6
Private oZona7
Private oHelic
Private oMatriz1  
Private oMatriz2  
Private oMatriz3  
Private oMatriz4  
Private oFiltro   
Private oFlange   
Private oCalib    
Private oSlit     
Private oCircAgua 
Private oLinear   
Private oGrama    
Private oEspes   
Private oAltura  
Private oLargura 
Private oAlinha  
Private oCamera  
Private oSensor  
Private oTrat   
Private oBobina 
Private oFilReve
Private oFilAlim
Private oCaroco 
Private oPlanic 
Private oKgh    
Private oCilindro
Private oMaqParada

public nSlit,nAlinha,nCamera,nGelad,nNeve,nBobi,nTrat,nEdit,nSensor,nFiltro,nFlange,nHelic,nCalib,nCircAgua,nFilReve,nFilAlim,nCaroco,nPlanic,nMaqParada
public nCilindros

public   cSupervisor:=alltrim(substr(cUsuario,7,15))
public   cCodSup :=__CUSERID //usu(cSupervisor)

public xFuncao:=Funcao
Public aItems:={;
"SIM",;
"NAO";
}

Private LF := chr(13) + chr(10) 
Private PAR04 := 0 
Private PAR01 := "" 
Private cOpcao:= "" 
Private tempo := ""
Private cProdut := ""
Private cDetalhe:= ""

cLinear:='0'  // 
 
if xFuncao==1 // incluir

	/*
	MV_PAR01 - Extrusora  (edit)
	MV_PAR02 - Produto    (edit)
	MV_PAR03 - Operador   (edit)
	MV_PAR04 - Status Maquina -> 1-Em Funcionamento , 2- Parada , 3-Setup (combo)
	*/
	cOpcao := " - Incluir"    
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	If SX1->(dbSeek( "PCPC006   "+"04" )   )
		RecLock( "SX1", .F. )
		X1_CNT01:=""
		SX1->(MsUnlock())
	Endif
	
	Do while .T.
	   if !PERGUNTE ('PCPC006',.T.)
	       return
	   endif 
	   if  alltrim(MV_PAR03)!=""
	       exit
	   else
		   alert("Campo Extrusor é obrigatório")
	   endif
	enddo
	
	MV_PAR01:=UPPER(MV_PAR01)
	MV_PAR02:=UPPER(MV_PAR02)
	cOperador:=Upper(MV_PAR03)
	PAR04 := MV_PAR04

	If !OperExt(MV_PAR03)  
       alert('Operador nao e um Extrusor')    
       Return 
    Endif
    
	If !MaqExt(MV_PAR01) 
       alert('Maquina nao cadastrada ou nao e uma Extrusora')    
       Return 
    Endif
 
    IF PAR04 = 1
        //FR - 26/11/2012 - RETIRAR O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
        //CHAMADO - 00000231
        
	    IF Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"
	    	//FR - 26/11/12 - CHAMADO 00000231 
	    	//SE EXTRUSORA É DIFERENTE DE E04 e E05, ou seja E01, E02, E03:
	    	// TEM CILINDRO TORRE GIRATÓRIA 
	    	// TEM FILTRO REVERSÍVEL
	    	
	    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
			IF PAR04 = 1  //MÁQUINA FUNCIONANDO
			/*
			MV_PAR01 - Extrusora  (edit)
			MV_PAR02 - Produto    (edit)
			MV_PAR03 - Operador   (edit)
			MV_PAR04 - Status Maquina -> 1-Em Funcionamento , 2- Parada , 3-Setup (combo)
			*/
			
			//FR - 26/11/12 - CHAMADO 00000231 
			//SE EXTRUSORA É DIFERENTE DE E04 e E05, OU SEJA AS EXTRUSORAS : E01, E02, E03:
			//NÃO POSSUEM HELICOIDAL    
	        	IF Alltrim(MV_PAR01) = "E01"
	        		//7 ZONAS   
	        		//4 MATRIZ
	        		//NÃO TEM FLANGE
	        		//NÃO TEM CALIBRADOR
	        		//NÃO TEM HELICOIDAL
	        		
	        		aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
							{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
							{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
							{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
							{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
							{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
							{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
							{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
							{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
							{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
							{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },;
							{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
							{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
							{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
							{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
							{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
							{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
							{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
							{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
							{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
							{"cCaroco"    ,"G07",""          ,"Caroco"                },;
							{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
							{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
							{"cCamera"    ,"F01",""          ,"Camera"                },;							
							{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
							{"cTratamento","F04",""          ,"Tratamento"            },;
							{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
							{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
							{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
							{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } } 
							                                                                              
							
							//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
							//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO
							//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO						
	        
				ELSEIF Alltrim(MV_PAR01) = "E02"
					//5 ZONAS
					//TEMP DE FILTRO NÃO
					//1 MATRIZ 
					//NÃO TEM HELICOIDAL
					
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
									{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;									
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },;
									{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;							
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;							
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
									{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
									{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } } 
									
								//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; okretirado da E01, E02, E03
								//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },; ok retirado de todos os itens
								//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;  //RETIRADO
								//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;  //RETIRADO
								//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
								//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
								//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
								//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
								
					ELSEIF Alltrim(MV_PAR01) = "E03"
					//5 ZONAS 
					//3 MATRIZ
					//NÃO TEM FLANGE 
					//NÃO TEM CALIBRADOR
					//NÃO TEM HELICOIDAL
					
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
									{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;									
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
									{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
									{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
									{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;							
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;							
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
									{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
									{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } } 
									
								//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; retirado da E01, E02, E03
								//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  retirado de todos os itens
								//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;  //RETIRADO
								//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;  //RETIRADO
								//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
								//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
								//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO						
								
					ENDIF //E01, E02, E03		
							
			ELSE  //MÁQUINA PARADA
			
				IF Alltrim(MV_PAR01) = "E01"
					//7 ZONAS  
					//4 MATRIZ
					//NÃO TEM FLANGE
					//NÃO TEM CALIBRADOR
					//NÃO TEM HELICOIDAL
					
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
							{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
							{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
							{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
							{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
							{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
							{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
							{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
							{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
							{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
							{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },;
							{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
							{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
							{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
							{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
							{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
							{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
							{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
							{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
							{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
							{"cCaroco"    ,"G07",""          ,"Caroco"                },;
							{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
							{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
							{"cCamera"    ,"F01",""          ,"Camera"                },;							
							{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
							{"cTratamento","F04",""          ,"Tratamento"            },;
							{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
							{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
							{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
							{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
							{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
							{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
							
							//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; retirado da E01, E02, E03
							//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  retirado de todos os itens
							//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
							//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO						
							
				ELSEIF Alltrim(MV_PAR01) = "E02"
					//5 ZONAS
					//TEMP DE FILTRO NÃO 
					//1 MATRIZ          
					//NÃO TEM HELICOIDAL
					
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
							{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
							{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
							{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
							{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
							{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
							{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },;
							{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;							
							{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
							{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
							{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
							{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
							{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
							{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
							{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
							{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
							{"cCaroco"    ,"G07",""          ,"Caroco"                },;
							{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
							{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
							{"cCamera"    ,"F01",""          ,"Camera"                },;							
							{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
							{"cTratamento","F04",""          ,"Tratamento"            },;
							{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
							{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
							{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
							{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
							{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
							{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
							
							//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; retirado da E01, E02, E03
							//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  retirado de todos os itens 
							//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;  //RETIRADO
							//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
							//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
							//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
							//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
							//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },;	//RETIRADO						
							
				ELSEIF Alltrim(MV_PAR01) = "E03"
					//5 ZONAS
					//3 MATRIZ
					//NÃO TEM FLANGE
					//NÃO TEM CALIBRADOR
					//NÃO TEM HELICOIDAL
					
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
							{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
							{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
							{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
							{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
							{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
							{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
							{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
							{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
							{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
							{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
							{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
							{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
							{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
							{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
							{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
							{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
							{"cCaroco"    ,"G07",""          ,"Caroco"                },;
							{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
							{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
							{"cCamera"    ,"F01",""          ,"Camera"                },;							
							{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
							{"cTratamento","F04",""          ,"Tratamento"            },;
							{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
							{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
							{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
							{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
							{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
							{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
							
							//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; retirado da E01, E02, E03
							//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  retirado de todos os itens 
							//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;  //RETIRADO
							//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
							//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
							//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
							//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO						
							
				ENDIF //E01, E02, E03
													
			ENDIF		//MAQ PARADA
	    	
	    
	    ELSE     //E04, E05
	    
	    		//FR - 26/11/12 - CHAMADO 00000231 
	    		//SE EXTRUSORA É = E04 e E05, 
	           //NÃO TEM CILINDRO TORRE GIRATÓRIA
	           //NÃO TEM FILTRO REVERSÍVEL 
	           //TEM HELICOIDAL
	    	
	    	IF PAR04 = 1 //MÁQUINA FUNCIONANDO
		    	/*
				MV_PAR01 - Extrusora  (edit)
				MV_PAR02 - Produto    (edit)
				MV_PAR03 - Operador   (edit)
				MV_PAR04 - Status Maquina -> 1-Em Funcionamento , 2- Parada , 3-Setup (combo)
				*/    
				IF Alltrim(MV_PAR01) = "E04"
					//5 ZONAS
					//TEMP DE FILTRO NÃO
					//1 MATRIZ 
					//NÃO TEM CALIBRADOR
					//NÃO TEM FILTRO REVERSÍVEL
					//NÃO TEM CILINDRO

					
			    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
									{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;									
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;						
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;							
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  } }  
									
									//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;	//RETIRADO
									//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO 
									//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
									//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
									//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
									//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
									//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO
									//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO
									//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO						
														 
				ELSEIF Alltrim(MV_PAR01) = "E05"			
					//4 ZONAS 
					//TEMP DE FILTRO NÃO
					//1 MATRIZ 
					//NÃO TEM FLANGE
					//NÃO TEM CALIBRADOR
					//NÃO TEM FILTRO REVERSÍVEL
					//NÃO TEM CILINDRO
					
					//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;									
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;
									{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;						
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;							
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  } }  
									
									//{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;	//RETIRADO
									//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;	//RETIRADO
									//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO 
									//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
									//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
									//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
									//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
									//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO						
									//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO						
									//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO						
					
				ENDIF //E04, E05
				
	    	ELSE   //MÁQUINA PARADA
	    		IF Alltrim(MV_PAR01) = "E04"
	    			//5 ZONAS 
	    			//TEMP DE FILTRO NÃO
	    			//1 MATRIZ
	    			//NÃO TEM FLANGE
	    			//NÃO TEM CALIBRADOR 
	    			//NÃO TEM FILTRO REVERSIVEL
	    			//NÃO TEM CILINDRO
	    						
		    		aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
								{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
								{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
								{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
								{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;								
								{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
								{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
								{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
								{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
								{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
								{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
								{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
								{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
								{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
								{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
								{"cCaroco"    ,"G07",""          ,"Caroco"                },;
								{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
								{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
								{"cCamera"    ,"F01",""          ,"Camera"                },;						
								{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
								{"cTratamento","F04",""          ,"Tratamento"            },;
								{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;						
								{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;						
								{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
								{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
								
								//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;//RETIRADO
								//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;//RETIRADO
								//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
								//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
								//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
								//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO 
								////{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
								//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO						
								//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO						
								//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO						
								
				ELSEIF Alltrim(MV_PAR01) = "E05"
	    			//4 ZONAS	
	    			//TEMP DE FILTRO NÃO
	    			//1 MATRIZ 
	    			//NÃO TEM FLANGE
	    			//NÃO TEM CALIBRADOR
	    			//NÃO TEM FILTRO REVERSÍVEL
	    			//NÃO TEM CILINDRO
	    					
		    		aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
								{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
								{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
								{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;								
								{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
								{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
								{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
								{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
								{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
								{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
								{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
								{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
								{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
								{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
								{"cCaroco"    ,"G07",""          ,"Caroco"                },;
								{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
								{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
								{"cCamera"    ,"F01",""          ,"Camera"                },;						
								{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
								{"cTratamento","F04",""          ,"Tratamento"            },;
								{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;						
								{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;						
								{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
								{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
								
								//{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;//RETIRADO
								//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;//RETIRADO
								//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;//RETIRADO 
								//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;//RETIRADO
								//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
								//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
								//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
								//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
								//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO						
								//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO						
								//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO						
								
				ENDIF //E04, E05			
							
	    	ENDIF //IF DA MÁQUINA FUNCIONANDO OU PARADA
	    ENDIF
    
	    IF PAR04 =  1  //SE ESTIVER EM FUNCIONAMENTO, EXIGE O PREENCHIMENTO DO PRODUTO		
	
		    If empty(Posicione("SB1",1,xFilial('SB1')+MV_PAR02,"B1_COD" ) )
		       alert('Produto Não Cadastrado')    
		       Return 
		    Endif    
		    //ALERT("QUERY 1 FEED ACAMPOS1")
			cQry :=""
			cQry+=" select Z59_ITEM ITEM , Z59_VALOR VALOR, Z59_VALOR2 VALOR2, Z59_ITEMD "    + chr(13) + chr(10)
			cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "       + chr(13) + chr(10)
			cQry+=" WHERE D_E_L_E_T_=''"                       + chr(13) + chr(10)
			cQry+=" AND Z59_PRODUT = '" + Alltrim(upper(MV_PAR02)) + "' " + chr(13) + chr(10)
			cQry+=" AND Z59_EXTRUS = '" + Alltrim(upper(MV_PAR01)) + "' " + chr(13) + chr(10)
			//FR - 26/11/12 - CHAMADO 00000231 
			IF Alltrim(MV_PAR01) = "E04" .or. Alltrim(MV_PAR01) = "E05" 
				cQry+=" AND Z59_ITEM <> 'F08' " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04 ou E05, não seleciona o ITEM = CILINDRO F08
				cQry+=" AND Z59_ITEM <> 'F06' " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04 ou E05, não seleciona o ITEM = FILTRO REVERSÍVEL F06
				IF Alltrim(MV_PAR01) = "E04"
					cQry+=" AND Z59_ITEM NOT IN( 'T08' , 'T09') " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04 NÃO SELECIONA ZONA 6 e 7
				ENDIF
				
				IF Alltrim(MV_PAR01) = "E05"
					cQry+=" AND Z59_ITEM NOT IN( 'T07', 'T08' , 'T09') " + chr(13) + chr(10)  //SE FOR EXTRUSORA E05 NÃO SELECIONA ZONAS 5, 6 e 7
				ENDIF
				cQry+=" AND Z59_ITEM <> 'T14' " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 não seleciona o ITEM = TEMP. FILTRO T14
				cQry+=" AND Z59_ITEM NOT IN ( 'T10' , 'T11', 'T12' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 SÓ TEM 1 MATRIZ
				cQry+=" AND Z59_ITEM NOT IN ( 'T15' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 NÃO TEM FLANGE 
				cQry+=" AND Z59_ITEM NOT IN ( 'T16' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 NÃO TEM CALIBRADOR
				
			ELSE  //E01, E02, E03
				//FR - 26/11/12 - CHAMADO 00000231 
				IF Alltrim(MV_PAR01) = "E01"
					cQry+=" AND Z59_ITEM NOT IN ( 'T15' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01 NÃO TEM FLANGE
					cQry+=" AND Z59_ITEM NOT IN ( 'T16' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01, E05 NÃO TEM CALIBRADOR
				
				ELSEIF Alltrim(MV_PAR01) = "E02"
					cQry+=" AND Z59_ITEM NOT IN ('T14' ) " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01, E02, E03 não seleciona o ITEM = TEMP. FILTRO T14 
					cQry+=" AND Z59_ITEM NOT IN ( 'T10' , 'T11', 'T12' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E02 NÃO SELECIONA MATRIZ: 2,3,4
					cQry+=" AND Z59_ITEM NOT IN ( 'T08' , 'T09' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E02 NÃO SELECIONA ZONAS: 6, 7 
				
				ELSEIF Alltrim(MV_PAR01) = "E03"
					cQry+=" AND Z59_ITEM NOT IN ( 'T12' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO SELECIONA MATRIZ 4
					cQry+=" AND Z59_ITEM NOT IN ( 'T15' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO TEM FLANGE
					cQry+=" AND Z59_ITEM NOT IN ( 'T16' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO TEM CALIBRADOR
					cQry+=" AND Z59_ITEM NOT IN ( 'T08' , 'T09' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO SELECIONA ZONAS: 6, 7 
				ENDIF
				
				cQry+=" AND Z59_ITEM <> 'T17' " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01, E02, E03 não seleciona o ITEM = HELICOIDAL T17
			ENDIF                                                                                                                         
			cQry+=" AND Z59_ITEM <> 'F02' " + chr(13) + chr(10)  //ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS
			cQry+=" AND Z59_ITEM <> 'F09' " + chr(13) + chr(10)  //F09 = MAQ. PARADA, SE A MÁQUINA ESTIVER EM FUNCIONAMENTO, NÃO PRECISA ADICIONAR ESTE VALOR
			cQry+=" order by Z59_ITEM"                         + chr(13) + chr(10)
			MemoWrite("C:\TEMP\1feedAcampos1.sql", cQry)
			TCQUERY cQry   NEW ALIAS 'AUX1'
			aCampos1:={}
			while !AUX1->(EOF())
				aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
				AUX1->(dbskip())
			enddo
			AUX1->(DBCLOSEAREA())
			if len(aCampos1)==0
				alert('Nao ha cadastro desse produto para essa extrusora.')
				return
			endif
		
		ELSE   //máquina parada ou setup
				
			cQry :="" + LF
			cQry+=" select Z59_ITEM ITEM , Z59_VALOR VALOR, Z59_VALOR2 VALOR2"  + LF
			cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "       + LF
			cQry+=" WHERE D_E_L_E_T_=''"                        + LF
			//cQry+=" AND Z59_PRODUT="+valtosql(upper(MV_PAR02)) + chr(10)
			cQry+=" AND Z59_EXTRUS="+valtosql(upper(MV_PAR01))  + LF
			cQry+="GROUP BY Z59_ITEM  , Z59_VALOR , Z59_VALOR2 "     + LF
			cQry+=" order by Z59_ITEM"                        + LF
			MemoWrite("C:\TEMP\paradaAcampos1.sql", cQry)
			
			TCQUERY cQry   NEW ALIAS 'AUX1'
			aCampos1:={}
			while !AUX1->(EOF())
				aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
				AUX1->(dbskip())
			enddo
			AUX1->(DBCLOSEAREA())
		
		ENDIF  //MV_PAR04 -> MAQ. EM FUNCIONAMENTO / SETUP / PARADA
    
    ELSE
    	cOBSMAQ := MV_PAR05 + " " + MV_PAR06
    	cProdut := MV_PAR02
    	lParada := .T.
    	//If MsgYesNo("Deseja Confirmar Máquina Parada / Setup ? ")
    	//	grava(lParada)
    	//Else
    		//alert("sem ação")
    	//Endif
    ENDIF //ENDIF DO PAR04 = 1 -> se for diferente, não irá mostrar a 2a. TELA
    
//else

endif  //endif do xfuncao == 1 
 
SetPrvt("oDlg1","oGrp1","oSBox1","oSay1","oGet1","oGrp2","oSBox2","oSay2","oGet2","oGrp3","oSBox3","oSay3","oGrp4","oSBox4" )
SetPrvt("oGrp4","oSay16","oSay17","oSay4","oSay5","oGet16","oGet17","oGet4","oGet5","oSBtn1","oSBtn2")


if xFuncao!=3  // 3 corrigir
	IF xFuncao != 1
		MV_PAR01 := Z60->Z60_EXTRUS
	    MV_PAR02 := Z60->Z60_PRODUT		
		MV_PAR03 := Z60->Z60_OPERA
					
		z60CODIGO := Z60->Z60_CODIGO   //editar		
		cProduto := Z60->Z60_PRODUT
		cExtrusora := Z60->Z60_EXTRUS
		cSuperi    := Z60->Z60_SUPERI
		cMaqParada := Z60->Z60_VALOR
		cOBSMAQ    := Z60->Z60_STAOBS
		While Z60->Z60_CODIGO == z60CODIGO .and. xFilial("Z60") == Z60->Z60_FILIAL
			If Alltrim(Z60->Z60_ITEM) = "F09"
				//ALERT("Z60->Z60_VALOR: " + Z60->Z60_VALOR )
				PAR04 := iif( Z60->Z60_VALOR = 'NAO' , 1 , 2 )	//máquina parada? SIM / NÃO	
			Endif
					
			If !Empty(Alltrim(Z60->Z60_PRODUT))  //se tiver preenchido o produto, é porque a máquina estava em funcionamento
				PAR04 := 1
			Endif
			Z60->(Dbskip())
		Enddo 
	ENDIF
	
	//IF PAR04 = 1   //MÁQUINA EM FUNCIONAMENTO

		If xFuncao == 2
			cOpcao := " - Visualizar" 		
		Elseif xfuncao == 1
			cOpcao := " - Incluir"    
			PAR04 := MV_PAR04
		Endif 
	
			
			IF Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"
			
				IF PAR04 <> 1  //MAQUINA PARADA ou SETUP 
				//FR - 26/11/12 - CHAMADO 00000231 
		    	//SE EXTRUSORA É = E01, E02, E03:
		    	//TEM CILINDRO TORRE GIRATÓRIA
		    	//TEM FILTRO REVERSÍVEL
		    	//NÃO TEM HELICOIDAL
		    		IF Alltrim(MV_PAR01) = "E01"
		    			//7 ZONAS 
		    			//4 MATRIZ
		    			//NÃO TEM FLANGE
		    			//NÃO TEM CALIBRADOR
		    			//NÃO TEM HELICOIDAL
		    			 
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
										{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
										{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },;
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
										{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
								
								//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; RETIRADO DAS EXTRUSORAS E01, E02, E03
								//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  RETIRADO DE TODOS OS ITENS
								//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
								//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
								
					ELSEIF Alltrim(MV_PAR01) = "E02"
						//5 ZONAS
						//NÃO TEM TEMP DE FILTRO 
						//1 MATRIZ
						//NÃO TEM HELICOIDAL
						
										    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },;
										{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
										{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
										
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									   	//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
									   	//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
									   	//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; RETIRADO
									   	
					ELSEIF Alltrim(MV_PAR01) = "E03"
						//5 ZONAS
						//3 MATRIZ
						//NÃO TEM FLANGE
						//NÃO TEM CALIBRADOR
						//NÃO TEM HELICOIDAL
										    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
										{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }
										
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									   	//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
									   	//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
									   	//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
					                    //{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO 
					                    //{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO
					                    
					ENDIF //E01, E02, E03			
	    	
	            ELSE //MAQUINA EM FUNCIONAMENTO
	            //FR - 26/11/12 - CHAMADO 00000231 
	            //SE EXTRUSORA É = E01, E02, E03:
		    	//TEM CILINDRO TORRE GIRATÓRIA
		    	//TEM FILTRO REVERSÍVEL
		    	//NÃO TEM HELICOIDAL
	            	IF Alltrim(MV_PAR01) = "E01"
	            		//7 ZONAS
	            		//4 MATRIZ
	            		//NÃO TEM FLANGE
	            		//NÃO TEM CALIBRADOR
	            		//NÃO TEM HELICOIDAL
	            		
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
										{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
										{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },;
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } } 
										
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; RETIRADO DAS EXTRUSORAS E01, E02, E03
										//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  RETIRADO DE TODOS OS ITENS						
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
										
					ELSEIF Alltrim(MV_PAR01) = "E02"
	            		//5 ZONAS
	            		//NÃO TEM TEMP DE FILTRO
	            		//1 MATRIZ
	            		//NÃO TEM HELICOIDAL
	            		
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;										
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },;
										{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } } 
										
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; RETIRADO DAS EXTRUSORAS E01, E02, E03
										//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  RETIRADO DE TODOS OS ITENS
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
										//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										
					ELSEIF Alltrim(MV_PAR01) = "E03"
	            		//5 ZONAS 
	            		//3 MATRIZ
	            		//NÃO TEM FLANGE
	            		//NÃO TEM CALIBRADOR
	            		//NÃO TEM HELICOIDAL
	            		
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;									
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } } 
										
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; RETIRADO DAS EXTRUSORAS E01, E02, E03
										//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;  RETIRADO DE TODOS OS ITENS												
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
										
										
					ENDIF //E01, E02, E03	
	            ENDIF
	    ELSE   
	    	//FR - 26/11/12 - CHAMADO 00000231 
	    	//SE EXTRUSORA É = E04 e E05:
		    //NÃO TEM CILINDRO TORRE GIRATÓRIA
		    //NÃO TEM FILTRO REVERSÍVEL
		    //TEM HELICOIDAL
	    	
	    	IF PAR04 <> 1 //MÁQUINA PARADA ou SETUP
	    	
	    		IF Alltrim(MV_PAR01) = "E04"
	    			//5 ZONAS
	    			//NÃO TEM TEMP DE FILTRO
	    			//1 MATRIZ
	    			//NÃO TEM FLANGE
	    			//NÃO TEM CALIBRADOR
	    			//NÃO TEM FILTRO REVERSÍVEL
	    			//NÃO TEM CILINDRO
	    			
			    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
									{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;						
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;					
									{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
									{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }						 
									
									//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
									//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
									//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
									//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
									//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
									//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
									//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
	    	    ELSEIF Alltrim(MV_PAR01) = "E05"
	    			//4 ZONAS
	    			//NÃO TEM TEMP DE FILTRO
	    			//1 MATRIZ
	    			//NÃO TEM FLANGE
	    			//NÃO TEM CALIBRADOR
	    			//NÃO TEM FILTRO REVERSÍVEL
	    			//NÃO TEM CILINDRO
	    			
			    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;						
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;					
									{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
									{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }						 
									
									//{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },; //RETIRADO
									//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
									//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
									//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
									//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
									//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
									//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
									//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
									
	    	    ENDIF //E04, E05
	    	    
	    	ELSE //MÁQUINA EM FUNCIONAMENTO
	    	
	    		IF Alltrim(MV_PAR01) = "E04"
	    			//5 ZONAS
	    			//NÃO TEM TEMP DE FILTRO
	    			//1 MATRIZ
	    			//NÃO TEM FLANGE
	    			//NÃO TEM CALIBRADOR
	    			//NÃO TEM FILTRO REVERSÍVEL
	    			//NÃO TEM CILINDRO
	    			
			    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
									{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;						
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  } }					
								
									//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
									//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
									//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
									//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
									//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
									//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
									//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
	    	    ELSEIF Alltrim(MV_PAR01) = "E05"
	    			//4 ZONAS
	    			//NÃO TEM TEMP DE FILTRO
	    			//1 MATRIZ
	    			//NÃO TEM FLANGE
	    			//NÃO TEM CALIBRADOR
	    			//NÃO TEM FILTRO REVERSÍVEL
	    			//NÃO TEM CILINDRO
	    			
			    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
					aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
									{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
									{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
									{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
									{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
									{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
									{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
									{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
									{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
									{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
									{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
									{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
									{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
									{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
									{"cCaroco"    ,"G07",""          ,"Caroco"                },;
									{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
									{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
									{"cCamera"    ,"F01",""          ,"Camera"                },;
									{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
									{"cTratamento","F04",""          ,"Tratamento"            },;
									{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;						
									{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  } }					
								
									
									//{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },; //RETIRADO
									//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
									//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
									//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
									//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
									//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
									//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
									//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
									//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
									
	    	    ENDIF
	    	/*
	    		//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
			aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
							{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
							{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
							{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
							{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
							{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
							{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
							{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
							{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
							{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
							{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },;
							{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
							{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },;
							{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;
							{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
							{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
							{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
							{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
							{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
							{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
							{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
							{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
							{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
							{"cCaroco"    ,"G07",""          ,"Caroco"                },;
							{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
							{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
							{"cCamera"    ,"F01",""          ,"Camera"                },;
							{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
							{"cTratamento","F04",""          ,"Tratamento"            },;
							{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;						
							{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  } }						 
	    					*/
	    					
	    	ENDIF
	    	
	    ENDIF    //EXTRUSORA != E04, E05
		
			aCampos1:={}    // z59 tabela do cadastro
			
			    
			IF  PAR04 =  1          //SÓ FAZ SE A MÁQUINA ESTIVER EM FUNCIONAMENTO 1=Em funcionamento
				//ALERT("QUERY 2 Feed aCampos1 ")
				cQry :=""
				cQry+=" select Z59_ITEM ITEM , 	Z59_VALOR VALOR , Z59_VALOR2 VALOR2, Z59_ITEMD "    + chr(13) + chr(10)
				cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "       + chr(13) + chr(10)
				cQry+=" WHERE D_E_L_E_T_=''"                       + chr(13) + chr(10)
				if xFuncao==1 // 1 incluir 
			   		cQry+=" AND Z59_PRODUT = '" + Alltrim(upper(MV_PAR02)) + "' " + chr(13) + chr(10)	
				   	cQry+=" AND Z59_EXTRUS = '" + Alltrim(upper(MV_PAR01)) + "' " + chr(13) + chr(10)
				   	//FR - 26/11/12 - CHAMADO 00000231 
					IF Alltrim(MV_PAR01) = "E04" .or. Alltrim(MV_PAR01) = "E05" 
						cQry+=" AND Z59_ITEM <> 'F08' " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04 ou E05, não seleciona o ITEM = CILINDRO F08
						cQry+=" AND Z59_ITEM <> 'F06' " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04 ou E05, não seleciona o ITEM = FILTRO REVERSÍVEL F06
						IF Alltrim(MV_PAR01) = "E04"
							cQry+=" AND Z59_ITEM NOT IN( 'T08' , 'T09') " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04 NÃO SELECIONA ZONA 6 e 7
						ENDIF
						
						IF Alltrim(MV_PAR01) = "E05"
							cQry+=" AND Z59_ITEM NOT IN( 'T07', 'T08' , 'T09') " + chr(13) + chr(10)  //SE FOR EXTRUSORA E05 NÃO SELECIONA ZONAS 5, 6 e 7
						ENDIF
						cQry+=" AND Z59_ITEM NOT IN ( 'T14' ) " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 não seleciona o ITEM = TEMP. FILTRO T14 
						cQry+=" AND Z59_ITEM NOT IN ( 'T10' , 'T11', 'T12' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 SÓ TEM 1 MATRIZ
						cQry+=" AND Z59_ITEM NOT IN ( 'T15' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 NÃO TEM FLANGE 
						cQry+=" AND Z59_ITEM NOT IN ( 'T16' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E04, E05 NÃO TEM CALIBRADOR
						
					ELSE  //E01, E02, E03
						//FR - 26/11/12 - CHAMADO 00000231 
						IF Alltrim(MV_PAR01) = "E01"
							cQry+=" AND Z59_ITEM NOT IN ( 'T15' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01 NÃO TEM FLANGE
							cQry+=" AND Z59_ITEM NOT IN ( 'T16' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01, E05 NÃO TEM CALIBRADOR
						
						ELSEIF Alltrim(MV_PAR01) = "E02"
							cQry+=" AND Z59_ITEM NOT IN ( 'T14' ) " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01, E02, E03 não seleciona o ITEM = TEMP. FILTRO T14 
							cQry+=" AND Z59_ITEM NOT IN ( 'T10' , 'T11', 'T12' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E02 NÃO SELECIONA MATRIZ: 2,3,4
							cQry+=" AND Z59_ITEM NOT IN ( 'T08' , 'T09' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E02 NÃO SELECIONA ZONAS: 6, 7 
						
						ELSEIF Alltrim(MV_PAR01) = "E03"
							cQry+=" AND Z59_ITEM NOT IN ( 'T12' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO SELECIONA MATRIZ 4
							cQry+=" AND Z59_ITEM NOT IN ( 'T15' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO TEM FLANGE
							cQry+=" AND Z59_ITEM NOT IN ( 'T16' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO TEM CALIBRADOR
							cQry+=" AND Z59_ITEM NOT IN ( 'T08' , 'T09' )  " + chr(13) + chr(10)  //SE FOR EXTRUSORA E03 NÃO SELECIONA ZONAS: 6, 7 
						ENDIF
						
						cQry+=" AND Z59_ITEM <> 'T17' " + chr(13) + chr(10)  //SE FOR EXTRUSORA E01, E02, E03 não seleciona o ITEM = HELICOIDAL T17
					ENDIF                                                                                                                         
					cQry+=" AND Z59_ITEM <> 'F02' " + chr(13) + chr(10)  //ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS
									
				else  //é visualizar ou corrigir
				   	cQry+=" AND Z59_PRODUT="+valtosql(Z60->Z60_PRODUT) + chr(13) + chr(10)
				    cQry+=" AND Z59_EXTRUS="+valtosql(Z60->Z60_EXTRUS) + chr(13) + chr(10)
				endif
				cQry+=" AND Z59_ITEM <> 'F09' " + LF    //ITEM RELATIVO A MÁQUINA PARADA
				//FR - 26/11/12 - CHAMADO 00000231 
				cQry+=" AND Z59_ITEM <> 'F02' " + LF    //ITEM RELATIVO A GELADEIRA QUE FOI RETIRADO DE TODOS OS ITENS
				cQry+=" order by Z59_ITEM"                         + chr(13) + chr(10)
				MemoWrite("C:\TEMP\2feed_acampos1.sql", cQry)
				TCQUERY cQry   NEW ALIAS 'AUX1' 
				
				aCampos1:={}
				Do while !AUX1->(EOF())
				   aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
				   AUX1->(dbskip())
				enddo
				AUX1->(DBCLOSEAREA())
			
			ELSE       //MAQ. PARADA ou em SETUP
				cQry :=""
				cQry+=" select Z59_ITEM ITEM , 	Z59_VALOR VALOR , Z59_VALOR2 VALOR2"    + LF  
				//qdo a máquina está parada ou em setup, pode não haver produto nela
				//então faço group by 1 na extrusora para pegar o 1o. dado que encontrar
				cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "        + LF 
				cQry+=" WHERE D_E_L_E_T_=''"                       + LF 
				if xFuncao==1 // 1 incluir 
			   		//cQry+=" AND Z59_PRODUT="+valtosql(upper(MV_PAR02)) + chr(10)	 //pode não haver produto
				   	cQry+=" AND Z59_EXTRUS="+valtosql(upper(MV_PAR01))  + LF 
				else
				   	//cQry+=" AND Z59_PRODUT="+valtosql(Z60->Z60_PRODUT) + chr(10)
				    cQry+=" AND Z59_EXTRUS="+valtosql(Z60->Z60_EXTRUS)  + LF 
				endif
				cQry+=" Group by Z59_ITEM  , 	Z59_VALOR  , Z59_VALOR2 "     + LF 
				cQry+=" order by Z59_ITEM"                          + LF 
				MemoWrite("C:\TEMP\acampos1_parada.sql", cQry)
				TCQUERY cQry   NEW ALIAS 'AUX1' 
				
				aCampos1:={}
				Do while !AUX1->(EOF())
				   aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
				   AUX1->(dbskip())
				enddo
				AUX1->(DBCLOSEAREA())
			
			ENDIF
	
		
			aCampos2:={}
			if xFuncao==1   //  1 incluir 
			    dDia:=Date() //dtos(ddatabase) 
				IF  PAR04 =  1          //SÓ FAZ SE A MÁQUINA ESTIVER EM FUNCIONAMENTO 1=Em funcionamento
					//QUERY PARA VER QTO TEMPO PASSOU DA ÚLTIMA INSPEÇÃO, E NÃO DEIXA INSERIR DADOS COM MENOS DE 2H DA ÚLTIMA INSPEÇÃO
					// z60 tabela da inspecao
					cQry:="select  Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2 ,Z60_HORAI HORAI, Z60_ITEM ITEM " + chr(10)           
					cQry+="  FROM "+ RetSqlName( "Z60" ) +" Z60                          " + chr(10)
					cQry+="  WHERE D_E_L_E_T_=''                                         " + chr(10)
					cQry+="  AND Z60_EXTRUS="+valtosql(upper(MV_PAR01))                    + chr(10)
					cQry+="  AND Z60_PRODUT="+valtosql(upper(MV_PAR02))                    + chr(10)
			        cQry+="  AND Z60_CODIGO = (                                          " + chr(10)
			        cQry+="        SELECT top 1 Z60_CODIGO                               " + chr(10)
			        cQry+="        FROM "+ RetSqlName( "Z60" ) +" Z60                    " + chr(10)
			        cQry+="        WHERE D_E_L_E_T_=''                                   " + chr(10)
			        cQry+="		   AND Z60_EXTRUS="+valtosql(upper(MV_PAR01))              + chr(10)
					cQry+="		   AND Z60_PRODUT="+valtosql(upper(MV_PAR02))              + chr(10)	    
			        cQry+="        and Z60_DATAI="+valtoSql(dDia)                          + chr(10)
			        cQry+="        order by Z60_CODIGO desc                              " + chr(10)
					cQry+="              )                                               " + chr(10)
					cQry+=" order by Z60_ITEM"                         + chr(10) 
					MemoWrite("C:\TEMP\Z60_verinsp.sql", cQry )                                                                                         
					TCQUERY cQry   NEW ALIAS 'AUX2'
				                                 
					aCampos2:={} 
					lInterval:=.T.  
				    cHrAtual:= left(TIME(),5)//substr(MV_PAR03,1,5) //"00:00:00" */TIME()
				    hora:=substr(cHrAtual,1,5)
				     if !AUX2->(EOF())
				       	cTempo := ElapTime( HORAI+":00", cHrAtual+":00")
				       	 
				       	if val(substr(cTempo,1,2))<2  
				         alert("Não é permitido incluir uma nova inspeçao no intervalo menor que 2 horas ")
				          AUX2->(DBCLOSEAREA())     //voltar
				       	  return                    //voltar
				        endif
				     
				     endif 
				     
				     while !AUX2->(EOF())
						aadd(aCampos2,{PENDEN,VALOR,VALOR2,,,,VALOR2,HORAI,ITEM})
						AUX2->(dbskip())
					enddo
					AUX2->(DBCLOSEAREA())
				ELSE  //máquina parada ou em setup
					//qdo a máquina está parada ou em setup, pode não haver produto nela
					//então faço group by 1 na extrusora para pegar o 1o. dado que encontrar 
					// z60 tabela da inspecao
					cQry:="select  Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2 ,Z60_HORAI HORAI, Z60_ITEM ITEM " + LF           
					cQry+="  FROM "+ RetSqlName( "Z60" ) +" Z60                          "  + LF
					cQry+="  WHERE D_E_L_E_T_=''                                         "  + LF
					cQry+="  AND Z60_EXTRUS="+valtosql(upper(MV_PAR01))                     + LF
					//cQry+="  AND Z60_PRODUT="+valtosql(upper(MV_PAR02))                    + chr(10)
			        cQry+="  AND Z60_CODIGO = (                                          "  + LF
			        cQry+="        SELECT top 1 Z60_CODIGO                               "  + LF
			        cQry+="        FROM "+ RetSqlName( "Z60" ) +" Z60                    "  + LF
			        cQry+="        WHERE D_E_L_E_T_=''                                   "  + LF
			        cQry+="		   AND Z60_EXTRUS="+valtosql(upper(MV_PAR01))              + LF
					//cQry+="		   AND Z60_PRODUT="+valtosql(upper(MV_PAR02))              + chr(10)	    
			        cQry+="        and Z60_DATAI="+valtoSql(dDia)                           + LF
			        cQry+="        order by Z60_CODIGO desc                              "  + LF
					cQry+="              )                                               " + LF
					cQry+=" GROUP BY Z60_PENDEN , Z60_VALOR, Z60_VALOR2  ,Z60_HORAI , Z60_ITEM  "  + LF
					cQry+=" order by Z60_ITEM"                          + LF 
					MemoWrite("C:\TEMP\Z60_verinsp1.sql", cQry )                                                                                         
					TCQUERY cQry   NEW ALIAS 'AUX2'
				                                 
					aCampos2:={} 
					lInterval:=.T.  
				    cHrAtual:= left(TIME(),5)//substr(MV_PAR03,1,5) //"00:00:00" */TIME()
				    hora:=substr(cHrAtual,1,5)
				     if !AUX2->(EOF())
				       	cTempo := ElapTime( HORAI+":00", cHrAtual+":00") 
				       	if val(substr(cTempo,1,2))< 2  
				         alert("Não é Permitido incluir uma Nova Inspeçã num intervalo Menor que 2 horas ")
				          AUX2->(DBCLOSEAREA())     //voltar
				       	  return                    //voltar
				        endif
				     endif 
				     
				     while !AUX2->(EOF())
						aadd(aCampos2,{PENDEN,VALOR,VALOR2,,,,VALOR2,HORAI,ITEM})
						AUX2->(dbskip())
					enddo
					AUX2->(DBCLOSEAREA())
				
				
				ENDIF  //endif da máq. parada ou setup
		      
			  
			else  // 2 visualizar 
			   
				IF  PAR04 =  1          //SÓ FAZ SE A MÁQUINA ESTIVER EM FUNCIONAMENTO 1=Em funcionamento
					cQry:="select Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2,Z60_CODIGO COD,Z60_EXTRUS EXT,Z60_PRODUT PROD,Z60_SUPERI SUPI,Z60_HORAI HORAI, Z60_ITEM ITEM "+ LF           
					cQry+="FROM "+ RetSqlName( "Z60" ) +" Z60                                        "+ LF
					cQry+="WHERE D_E_L_E_T_=''                                                       "+ LF
					cQry+="  AND Z60_PRODUT = '"+ Alltrim(cProduto) + "' "                     + LF
					cQry+="  AND Z60_EXTRUS = '" + Alltrim(cExtrusora) + "' "                    + LF
			        cQry+="  AND Z60_CODIGO = '" + Alltrim(z60CODIGO) + "' "                    + LF 
			        //cQry+=" AND Z60_ITEM <> 'F09' " + chr(13) + chr(10)  //SE A MÁQUINA ESTIVER EM FUNCIONAMENTO, NÃO PRECISA ADICIONAR ESTE VALOR
					cQry+=" order by Z60_ITEM"                         + LF   
					MemoWrite("C:\TEMP\VIS_Acampos2.sql",cQry )
					TCQUERY cQry   NEW ALIAS 'AUX2'
					aCampos2:={}
					while !AUX2->(EOF())
						aadd(aCampos2,{PENDEN,VALOR,COD,EXT,PROD,SUPI,VALOR2,,ITEM})
						AUX2->(dbskip())
					enddo
					AUX2->(DBCLOSEAREA()) 
				ELSE
					//qdo a máquina está parada ou em setup, pode não haver produto nela
					//então faço group by 1 na extrusora para pegar o 1o. dado que encontrar 				
					cQry:="select Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2,Z60_CODIGO COD,Z60_EXTRUS EXT,Z60_PRODUT PROD,Z60_SUPERI SUPI,Z60_HORAI HORAI, Z60_ITEM ITEM "+ chr(10)           
					cQry+="FROM "+ RetSqlName( "Z60" ) +" Z60                                        "+ chr(10)
					cQry+="WHERE D_E_L_E_T_=''                                                       "+ chr(10)
					cQry+="  AND Z60_EXTRUS = '" + Alltrim(cExtrusora) + "' "                             + chr(10)
			        cQry+="  AND Z60_CODIGO = '" + Alltrim(z60CODIGO)  + "' "                             + chr(10)			        
					cQry+=" GROUP BY Z60_PENDEN , Z60_VALOR, Z60_VALOR2 ,Z60_CODIGO ,Z60_EXTRUS ,Z60_PRODUT ,Z60_SUPERI ,Z60_HORAI , Z60_ITEM  "+ chr(10)           
					cQry+=" order by Z60_ITEM"                         + chr(10)   
					MemoWrite("C:\TEMP\VIS_Acampos2.sql",cQry )
					TCQUERY cQry   NEW ALIAS 'AUX2'
					aCampos2:={}
					while !AUX2->(EOF())
						aadd(aCampos2,{PENDEN,VALOR,COD,EXT,PROD,SUPI,VALOR2,,ITEM})
						AUX2->(dbskip())
					enddo
					AUX2->(DBCLOSEAREA()) 
				
				ENDIF
				
			endif //ENDIF do xfuncao = 2 visualizar
		
			if xFuncao!=3 // 3 corrigir 
		
			   // Alimento as variaveis com os valores do Banco
			  If(len(aCampos2))!=0
				 For _X:=1 to len(aVariavel)
					 nRegx := ASCAN(aCampos2, {|x| x[9] ==aVariavel[_X][2] })  
					 if nRegx>0
					    &(aVariavel[_X][1]):= aCampos2[nRegx,2]  
					    If ! empty(aVariavel[_X][3]) 
				   		   &(aVariavel[_X][3]):=aCampos2[nRegx,7]
			    	    Endif
				     endif
				 Next
			  Endif			
				       
			endif  //endif do xfuncao corrigir
		
		    //  tela com a estrutura do produto 
			  if xfuncao == 1 .AND. MV_PAR04=1 // QUANDO FORM INCLUI E A MAQUINA ESTIVER EM FUNCIONAMENTO 
			     U_fTelaEst(MV_PAR02)
			  endif 
			//
			if xfuncao=2
			  oDlg1      := MSDialog():New( 152,327,712,1259,"Inspeção de Extrusora" + cOpcao,,,.F.,,,,,,.T.,,,.F. )
			else
			  oDlg1      := MSDialog():New( 152,327,712,1022,"Inspeção de Extrusora" + cOpcao,,,.F.,,,,,,.T.,,,.F. )
			endif
			oGrp1      := TGroup():New( 042,002,255,114," Temperatura ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSBox1     := TScrollBox():New( oGrp1,052,007,199,103,.T.,.T.,.T. )
			nIni:=-20
			
			IF PAR04 = 1
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cZona1'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay   := TSay():New( nIni +=20,001,{|| 'Zona 1'                                  },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
				If PAR04 = 1
					oZona1 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona1:=u,cZona1)          },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona1'   ,,)
				Else 
					oZona1 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona1:=u,cZona1)          },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona1'   ,,)
					oZona1:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oZona1,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. PAR04 <>  1
				     oZona1:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
			        
			    // com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cZona2'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				// 
				oSay   := TSay() :New( nIni -10,050,{|| 'Zona 2'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
				If PAR04 = 1
					oZona2 := TGet():New( nIni    ,050,{|u| If(PCount()>0,cZona2:=u,cZona2)         },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona2'   ,,)
				Else
					oZona2 := TGet():New( nIni    ,050,{|u| If(PCount()>0,cZona2:=u,cZona2)         },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona2'   ,,)
					oZona2:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oZona2,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oZona2:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cZona3'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay    := TSay():New( nIni +=20,001,{|| 'Zona 3'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
				If PAR04 = 1
					oZona3 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona3:=u,cZona3)         },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona3'   ,,)
				Else 
					oZona3 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona3:=u,cZona3)         },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona3'   ,,)
					oZona3:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oZona3,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oZona3:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cZona4'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay    := TSay():New( nIni  -10,050,{|| 'Zona 4'                                },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
				If PAR04 = 1
					oZona4 := TGet():New( nIni     ,050,{|u| If(PCount()>0,cZona4:=u,cZona4)        },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona4'   ,,)
				Else 
					oZona4 := TGet():New( nIni     ,050,{|u| If(PCount()>0,cZona4:=u,cZona4)        },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona4'   ,,)
					oZona4:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oZona4,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oZona4:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
			
				
				IF Alltrim(MV_PAR01) != "E05"     
					//FR - 26/11/12 - CHAMADO 00000231:
					//E05 só tem 4 zonas
				 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cZona5'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay    := TSay():New( nIni +=20,001,{|| 'Zona 5'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
					If PAR04 = 1
						oZona5 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona5:=u,cZona5)         },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona5'   ,,)
					Else 
						oZona5 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona5:=u,cZona5)         },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona5'   ,,)
						oZona5:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oZona5,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 
					     oZona5:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif
				ENDIF	
				
				IF Alltrim(MV_PAR01) = "E01"     
					//FR - 26/11/12 - CHAMADO 00000231:
					//E01 tem 7 zonas
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cZona6'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay    := TSay():New( nIni  -10,050,{|| 'Zona 6'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
					If PAR04 = 1
						oZona6 := TGet():New( nIni     ,050,{|u| If(PCount()>0,cZona6:=u,cZona6)         },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona6'   ,,)
					Else 
						oZona6 := TGet():New( nIni     ,050,{|u| If(PCount()>0,cZona6:=u,cZona6)         },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona6'   ,,)
						oZona6:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oZona6,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2  //.or. MV_PAR04 <>  1
					     oZona6:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif	
				
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cZona7'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay    := TSay():New( nIni +=20,001,{|| 'Zona 7'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
					If PAR04 = 1
						oZona7 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona7:=u,cZona7)         },oSBox1,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona7'   ,,)
					Else
						oZona7 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona7:=u,cZona7)         },oSBox1,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cZona7'   ,,)
						oZona7:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oZona7,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 //.or. MV_PAR04 <>  1
					     oZona7:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif	
			    
			  	ENDIF  //E01 - 7 ZONAS
			  	
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cMatriz1'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay    := TSay():New( nIni+=20,001,{|| 'Matriz 1'                             },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
				If PAR04 = 1
					oMatriz1:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMatriz1:=u,cMatriz1)   },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz1',,)
				Else
					oMatriz1:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMatriz1:=u,cMatriz1)   },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz1',,)
					oMatriz1:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oMatriz1,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2  //.or. MV_PAR04 <>  1
				     oMatriz1:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				IF Alltrim(MV_PAR01) != "E05" .AND. Alltrim(MV_PAR01) != "E04" .AND. Alltrim(MV_PAR01) != "E02"     
					//FR - 26/11/12 - CHAMADO 00000231:
					//E05, E04, E02 só tem 1 MATRIZ
				
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cMatriz2'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay    := TSay():New( nIni  -10,050,{|| 'Matriz 2'                            },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
					If PAR04 = 1
						oMatriz2:= TGet():New( nIni    ,050,{|u| If(PCount()>0,cMatriz2:=u,cMatriz2)  },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz2',,)
					Else
						oMatriz2:= TGet():New( nIni    ,050,{|u| If(PCount()>0,cMatriz2:=u,cMatriz2)  },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz2',,)
						oMatriz2:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oMatriz2,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 //.or. MV_PAR04 <>  1
					     oMatriz2:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif	
					
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cMatriz3'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay    := TSay():New( nIni+=20,001,{|| 'Matriz 3'                             },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
					If PAR04 = 1
						oMatriz3:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMatriz3:=u,cMatriz3)  },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz3',,)
					Else
						oMatriz3:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMatriz3:=u,cMatriz3)  },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz3',,)
						oMatriz3:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oMatriz3,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 //.or. MV_PAR04 <>  1
					     oMatriz3:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif	
			    ENDIF //1 MATRIZ PARA E05, E04, E02
				
				IF Alltrim(MV_PAR01) = "E01"     
					//FR - 26/11/12 - CHAMADO 00000231:
					//E01 TEM 4 MATRIZES
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cMatriz4'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay    := TSay():New( nIni  -10,050,{|| 'Matriz 4'                            },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
					If PAR04 = 1
						oMatriz4:= TGet():New( nIni    ,050,{|u| If(PCount()>0,cMatriz4:=u,cMatriz4)  },oSBox1,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz4',,)
					Else 
						oMatriz4:= TGet():New( nIni    ,050,{|u| If(PCount()>0,cMatriz4:=u,cMatriz4)  },oSBox1,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMatriz4',,)
						oMatriz4:lReadOnly := .T.
					Endif
						If nRegC>0  
					   		desabilita(@oMatriz4,aCampos2[nRegC,1])
				    	Else
						   if xfuncao=2 //.or. MV_PAR04 <>  1
						     oMatriz4:lVisibleControl := .F. 
						     oSay:lVisibleControl   := .F. 
					   		endif
						Endif 
				ENDIF //4 MATRIZES PARA E01	
			                           	
				IF Alltrim(MV_PAR01) != "E05" .AND. Alltrim(MV_PAR01) != "E04" .AND. Alltrim(MV_PAR01) != "E02"
				     //FR - 26/11/12 - CHAMADO 00000231:
				     //E05, E04, E02 NÃO TEM TEMP. DE FILTRO
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cFiltro'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay   := TSay():New( nIni+=20,001,{|| 'Temperatura de Filtro'                },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
					If PAR04 = 1
						oFiltro:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cFiltro:=u,cFiltro)    },oSBox1,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cFiltro'    ,,)
					Else
						oFiltro:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cFiltro:=u,cFiltro)    },oSBox1,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cFiltro'    ,,)
						oFiltro:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oFiltro,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 //.or. MV_PAR04 <>  1
					     oFiltro:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif
				ENDIF //E05, E04, E02: TEMP DE FILTRO	
				                                
				IF Alltrim(MV_PAR01) = "E02"
					//FR - 26/11/12 - CHAMADO 00000231:
					//SÓ A E02 TEM FLANGE   
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cFlange'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//
					oSay   := TSay():New( nIni+=20,001,{|| 'Flange'                               },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
					If PAR04 = 1
						oFlange:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cFlange:=u,cFlange)    },oSBox1,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cFlange'    ,,)
					Else 
						oFlange:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cFlange:=u,cFlange)    },oSBox1,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cFlange'    ,,)
						oFlange:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oFlange,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 //.or. MV_PAR04 <>  1
					     oFlange:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif
				ENDIF //FLANGE: SÓ A E02	
				                                	
				IF Alltrim(MV_PAR01) = "E02"
					//FR - 26/11/12 - CHAMADO 00000231:
					//SÓ A E02 TEM CALIBRADOR
					// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cCalib'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//	
					oSay   := TSay():New( nIni+=20,001,{|| 'Calibrador'                                   },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
					If PAR04 = 1
						oCalib:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCalib:=u,cCalib)            },oSBox1,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cCalib'    ,,)
					Else 
						oCalib:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCalib:=u,cCalib)            },oSBox1,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cCalib'    ,,)
						oCalib:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oCalib,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 //.or. MV_PAR04 <>  1
					     oCalib:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif
				ENDIF  //CALIBRADOR: SÓ PARA E02	
				                                	
						
				If Alltrim(MV_PAR01) = "E04" .or. Alltrim(MV_PAR01) = "E05"
					//FR - 26/11/12 - CHAMADO 00000231:
					//SOMENTE E04 e E05 POSSUEM HELICOIDAL      
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cHelic'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					//		
					oSay   := TSay():New( nIni+=20,001,{|| 'Helicoidal'                                   },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
					If PAR04 = 1
						oHelic:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cHelic:=u,cHelic)            },oSBox1,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cHelic'    ,,)
					Else 
						oHelic:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cHelic:=u,cHelic)            },oSBox1,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cHelic'    ,,)
						oHelic:lReadOnly := .T.
					Endif
					If nRegC>0  
					   desabilita(@oHelic,aCampos2[nRegC,1])
				    Else
					   if xfuncao=2 //.or. MV_PAR04 <>  1
					     oHelic:lVisibleControl := .F. 
					     oSay:lVisibleControl   := .F. 
					   Endif
					Endif
				Endif	//HELICOIDAL: APENAS PARA E04 e E05
				                                	
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cSlit'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//		
				oSay   := TSay():New( nIni+=20,001,{|| 'Conformidade do Slit'                                      },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
				if xFuncao == 2
					oSlit := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSlit:=u,cSlit)          },oSBox1,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cSlit'  ,,)
					oSlit:bValid:={|| cSlit:=upper(cSlit) }
				else
					If PAR04 = 1
						oSlit:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSlit:=u,nSlit)},aSlit:=aItems,90,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
						ASize(aSlit,Len(aSlit))
						oSlit:aItems:=aSlit
						oSlit:nAT:=1
						oSlit:bValid:={|| cSlit:=upper(aItems[oSlit:nAT]) } 
					Else 
						oSlit:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSlit:=u,nSlit)},aSlit:=aItems,90,20,oSBox1,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
						oSlit:lReadOnly := .T.
					Endif
				endif 
				If nRegC>0  
				   desabilita(@oSlit,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 
				     oSlit:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
			
			    // com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cCircAgua'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//		
				oSay   := TSay():New( nIni+=20,001,{|| 'Circulação de Água'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
				if xFuncao == 2
					oCircAgua := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCircAgua:=u,cCircAgua)          },oSBox1,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cCircAgua'  ,,)
					oCircAgua:bValid:={|| cCircAgua:=upper(cCircAgua) }
				else
					If PAR04 = 1
						oCircAgua:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCircAgua:=u,nCircAgua)    },aCircAgua:=aItems,90,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
						ASize(aCircAgua,Len(aCircAgua))
						oCircAgua:aItems:=aCircAgua
						oCircAgua:nAT:=1
						oCircAgua:bValid:={|| cCircAgua:=upper(aItems[oCircAgua:nAT]) }
					Else
						oCircAgua:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCircAgua:=u,nCircAgua)    },aCircAgua:=aItems,90,20,oSBox1,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
						oSlit:lReadOnly := .T.
					Endif
				endif 
				If nRegC>0  
				   desabilita(@oCircAgua,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2  //.or. MV_PAR04 <>  1
				     oCircAgua:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
			ENDIF //PAR04 = 1
				
				oGrp2      := TGroup():New( 042,117,255,229," Gravimetro ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
				oSBox2     := TScrollBox():New( oGrp2,052,121,199,103,.T.,.T.,.T. )
				nIni:=0
				
			IF PAR04 = 1
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cLinear'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//		
				oSay   := TSay():New( nIni    ,001,{|| 'Linear'                                  },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				If PAR04 = 1
					oLinear := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cLinear:=u,cLinear)        },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cLinear',,)
					oLinear:lReadOnly := .T.
				Else 
					oLinear := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cLinear:=u,cLinear)        },oSBox2,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cLinear',,)
					oLinear:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oLinear,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oLinear:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
			
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cGrama'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//		
				oSay   := TSay():New( nIni+=20,001,{|| 'Grama/Metro'                             },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				If PAR04 = 1
					oGrama := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cGrama:=u,cGrama)          },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cGrama',,)
				Else 
					oGrama := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cGrama:=u,cGrama)          },oSBox2,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cGrama',,)
					oGrama:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oGrama,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2  //.or. MV_PAR04 <>  1
				     oGrama:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
			
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cEspes'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//		
				oSay   := TSay():New( nIni+=20,001,{|| 'Espessura do Filme'                      },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				If PAR04 = 1
					oEspes := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cEspes:=u,cEspes)  },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cEspes',,)
				Else
					oEspes := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cEspes:=u,cEspes)  },oSBox2,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cEspes',,)
					oEspes:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oEspes,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oEspes:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cAltura'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//		
				oSay   := TSay():New( nIni+=20,001,{|| 'Altura do Balao'                         },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				If PAR04 = 1
					oAltura := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cAltura:=u,cAltura)        },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cAltura',,)
				Else
					oAltura := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cAltura:=u,cAltura)        },oSBox2,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cAltura',,)
					oEspes:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oAltura,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oAltura:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cLargura'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay   := TSay():New( nIni+=20,001,{|| 'Largura bobina'                          },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				If PAR04 = 1
					oLargura := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cLargura:=u,cLargura)      },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cLargura',,)
				Else 
					oLargura := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cLargura:=u,cLargura)      },oSBox2,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cLargura',,)
					oLargura:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oLargura,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oLargura:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
			   
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cAlinha'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay   := TSay():New( nIni+=20,001,{|| 'Alinhamento bobina'                      },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				   if xFuncao == 2
					 oAlinha := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cAlinha:=u,cAlinha)    },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cAlinha'  ,,)
					 oAlinha:bValid:={|| cAlinha:=upper(cAlinha) }
				   else
				   		If PAR04 = 1
							 oAlinha:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nAlinha:=u,nAlinha) },aAlinha:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aAlinha,Len(aAlinha))
							 oAlinha:aItems:=aAlinha
							 oAlinha:nAT:=1
							 oAlinha:bValid:={|| cAlinha:=upper(aItems[oAlinha:nAT]) }
						Else 
							oAlinha:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nAlinha:=u,nAlinha) },aAlinha:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
					        oAlinha:lReadOnly := .T.
						Endif
				   endif 
				If nRegC>0  
				   desabilita(@oAlinha,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oAlinha:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
			
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cCaroco'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				//novo  campo 
			    oSay   := TSay():New( nIni+=20,001,{|| 'Caroço'+ CHR(13) + CHR(10)+ 'Tem:'  }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
				   if xFuncao == 2
					 oCaroco := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cCaroco:=u,cCaroco)         },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cCaroco'  ,,)
					 oCaroco:bValid:={|| cCaroco:=upper(cCaroco) }
				   else
				   		If PAR04 = 1
							 oCaroco:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nCaroco:=u,nCaroco)      },aCaroco:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aCaroco,Len(aCaroco))
							 oCaroco:aItems:=aCaroco
						 	 oCaroco:nAT:=1
						     oCaroco:bValid:={|| cCaroco:=upper(aItems[oCaroco:nAT]) }
						Else 
							oCaroco:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nCaroco:=u,nCaroco)      },aCaroco:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oCaroco:lReadOnly := .T.
						Endif
				   endif 	   
				   If nRegC>0  
					  desabilita(@oCaroco,aCampos2[nRegC,1])
				   Else
					  if xfuncao=2 //.or. MV_PAR04 <>  1
					     oCaroco:lVisibleControl := .F. 
					     oSay:lVisibleControl    := .F. 
					  Endif
				   Endif	
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cPlanic'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				//novo  campo 
				oSay   := TSay():New( nIni+=20,001,{|| 'Planicidade'                                  },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				   if xFuncao == 2
					 oPlanic := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cPlanic:=u,cPlanic)         },oSBox2,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cPlanic'  ,,)
					 oPlanic:bValid:={|| cPlanic:=upper(cPlanic) }
				   else
				  		If PAR04 = 1
							 oPlanic:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nPlanic:=u,nPlanic)      },aPlanic:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aPlanic,Len(aPlanic))
							 oPlanic:aItems:=aPlanic
						 	 oPlanic:nAT:=1
						     oPlanic:bValid:={|| cPlanic:=upper(aItems[oPlanic:nAT]) }
						Else 
							oPlanic:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nPlanic:=u,nPlanic)      },aPlanic:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oPlanic:lReadOnly := .T.
						Endif
				   endif 	   
				   If nRegC>0  
					  desabilita(@oPlanic,aCampos2[nRegC,1])
				   Else
					  if xfuncao=2 //.or. MV_PAR04 <>  1
					     oPlanic:lVisibleControl := .F. 
					     oSay:lVisibleControl    := .F. 
					  Endif
				   Endif	
			
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cKgH'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay   := TSay():New( nIni +=20,001,{|| 'Kg/h'                                  },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
				If PAR04 = 1
					oKgH := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cKgH:=u,cKgH)          },oSBox2,030,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cKgH'   ,,)
				Else
					oKgH := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cKgH:=u,cKgH)          },oSBox2,030,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cKgH'   ,,)
					oKgH:lReadOnly := .T.
				Endif
				If nRegC>0  
				   desabilita(@oKgH,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oKgH:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif
			
			ENDIF //PAR04 = 1	
		 
		  
			oGrp3      := TGroup():New( 042,232,255,344," Ferramenta ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSBox3     := TScrollBox():New( oGrp3,052,236,199,103,.T.,.T.,.T.)
			nIni:=0
		
		    IF PAR04 = 1
			    // com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cCamera'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
				oSay   := TSay():New( nIni    ,001,{|| 'Câmera'                                  },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				   if xFuncao == 2
					 oCamera := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCamera:=u,cCamera)    },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cCamera'  ,,)
				 	 oCamera:bValid:={|| cCamera:=upper(cCamera) }
				   else
				   		If PAR04 = 1
							 oCamera:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCamera:=u,nCamera) },aCamera:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aCamera,Len(aCamera))
							 oCamera:aItems:=aCamera
							 oCamera:nAT:=1
							 oCamera:bValid:={|| cCamera:=upper(aItems[oCamera:nAT]) } 
						Else 
							oCamera:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCamera:=u,nCamera) },aCamera:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oCamera:lReadOnly := .T.
						Endif
						
				   endif 
				If nRegC>0  
				   desabilita(@oCamera,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2  //.or. MV_PAR04 <>  1
				     oCamera:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				//FR - 26/11/2012 - O ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS
				//CONFORME CHAMADO 00000231
				/*
			    // com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cGeladeira'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//	
				oSay  := TSay():New( nIni+=20,001,{|| 'Geladeira'                               },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
				  if xFuncao == 2
				   	oGeladeira:=TGet():New( nIni+=10,001,{|u| If(PCount()>0,cGeladeira:=u,cGeladeira)},oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cGeladeira'  ,,)
				 	oGeladeira:bValid:={|| cGeladeira:=upper(cGeladeira) }
				  else
				  		If PAR04 = 1
						 	oGeladeira:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nGelad:=u,nGelad)   },aGelad:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
						 	ASize(aGelad,Len(aGelad))
						 	oGeladeira:aItems:=aGelad
						  	oGeladeira:nAT:=1
						  	oGeladeira:bValid:={|| cGeladeira:=upper(aItems[oGeladeira:nAT]) }  
						Else
							oGeladeira:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nGelad:=u,nGelad)   },aGelad:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oGeladeira:lReadOnly := .T.
						Endif
				  endif 
				If nRegC>0  
				   desabilita(@oGeladeira,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oGeladeira:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				*/
					
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cSensor'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//	
				oSay   := TSay():New( nIni+=20,001,{|| 'Sensor Ponto de Neve'                    },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
					if xFuncao == 2
					  oSensor := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSensor:=u,cSensor)    },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cSensor'  ,,)
					  oSensor:bValid:={|| cSensor:=upper(cSensor) }
				    else
				    	If PAR04 = 1
							  oSensor:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSensor:=u,nSensor) },aSensor:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							  ASize(aSensor,Len(aSensor))
							  oSensor:aItems:=aSensor
							  oSensor:nAT:=1
							  oSensor:bValid:={|| cSensor:=upper(aItems[oSensor:nAT]) } 
						Else
							oSensor:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSensor:=u,nSensor) },aSensor:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oSensor:lReadOnly := .T.
						Endif
				    endif 
				If nRegC>0  
				   desabilita(@oSensor,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oSensor:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cTratamento'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//	
			    oSay   := TSay():New( nIni+=20,001,{|| 'Tratamento'+ CHR(13) + CHR(10)+ 'Ligado:'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
				   if xFuncao == 2
					 oTrat := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cTratamento:=u,cTratamento) },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cTratamento'  ,,)
					 oTrat:bValid:={|| cTratamento:=upper(cTratamento) }
			       else
			       		If PAR04 = 1
							 oTrat:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nTrat:=u,nTrat)      },aTrat:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aTrat,Len(aTrat))
							 oTrat:aItems:=aTrat
							 oTrat:nAT:=1
							 oTrat:bValid:={|| cTratamento:=upper(aItems[oTrat:nAT]) } 
						Else
							oTrat:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nTrat:=u,nTrat)      },aTrat:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oTrat:lReadOnly := .T.
						Endif
				   endif 
				If nRegC>0  
				   desabilita(@oTrat,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2 //.or. MV_PAR04 <>  1
				     oTrat:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif	
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cBobina'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
			    oSay   := TSay():New( nIni+=20,001,{|| 'Bobinadeira'+ CHR(13) + CHR(10)+ 'Automatico:'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
				   if xFuncao == 2
					 oBobina := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cBobina:=u,cBobina)         },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cBobina'  ,,)
					 oBobina:bValid:={|| cBobina:=upper(cBobina) }
				   else
				   		If PAR04 = 1
							 oBobina:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nBobi:=u,nBobi)      },aBobi:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aBobi,Len(aBobi))
							 oBobina:aItems:=aBobi
						 	 oBobina:nAT:=1
						     oBobina:bValid:={|| cBobina:=upper(aItems[oBobina:nAT]) }
						Else
							oBobina:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nBobi:=u,nBobi)      },aBobi:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oBobina:lReadOnly := .T.
						Endif
				   endif 
				If nRegC>0  
				   desabilita(@oBobina,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2  //.or. MV_PAR04 <>  1
				     oBobina:lVisibleControl := .F. 
				     oSay:lVisibleControl   := .F. 
				   Endif
				Endif
				
								
				If !Alltrim(MV_PAR01) $ "E04/E05" 
					//FR - 26/11/12 - CHAMADO 00000231:     
			    	//O FILTRO DO REVERSÍVEL não existe nas estrusoras: E04 e E05, 
			    	//então, não mostrar se forem estas extrusoras
					nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cFilReve'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
					// 
				    //novo  campo
				    If Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"       
				    	oSay   := TSay():New( nIni+=20,001,{|| 'Filtro do Reversivel'+ CHR(13) + CHR(10)+ 'Limpo:'         }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
				    Endif
					   if xFuncao == 2 
					   	If Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"      
						 	oFilReve := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cFilReve:=u,cFilReve)         },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cFilReve'  ,,)
						 	oFilReve:bValid:={|| cFilReve:=upper(cFilReve) } 
						Endif
					   else
					   		If PAR04 = 1
								 oFilReve:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nFilReve:=u,nFilReve)      },aFilReve:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
								 ASize(aFilReve,Len(aFilReve))
								 oFilReve:aItems:=aFilReve
							 	 oFilReve:nAT:=1
							     oFilReve:bValid:={|| cFilReve:=upper(aItems[oFilReve:nAT]) }
							Else
								oFilReve:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nFilReve:=u,nFilReve)      },aFilReve:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
								oFilReve:lReadOnly := .T.
							Endif
					   endif 
					   If Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"      
						   If nRegC>0  
							  desabilita(@oFilReve,aCampos2[nRegC,1])
						   Else
							  if xfuncao=2
							  	If !Alltrim(MV_PAR01) != "E04" .and. !Alltrim(MV_PAR01) != "E05"       
							     	//oFilReve:lVisibleControl := .F. 
							     	//oSay:lVisibleControl     := .F. 
							     	oFilReve:lReadOnly := .T.
							    Endif  
							  endif
						   Endif
					   Endif	
				Endif
				
				// com o nome da variavel pego o item que ela corresponde e passo para o vetor dos campos pelo item 
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cFilAlim'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				//
			    //novo  campo 
			    oSay   := TSay():New( nIni+=20,001,{|| 'Filtro do Alimentador'+ CHR(13) + CHR(10)+ 'Limpo:'         }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
				   if xFuncao == 2
					 oFilalim := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cFilalim:=u,cFilalim)         },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cFilalim'  ,,)
					 oFilalim:bValid:={|| cFilalim:=upper(cFilalim) }
				   else
				   		If PAR04 = 1
							 oFilalim:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nFilalim:=u,nFilalim)      },aFilalim:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aFilalim,Len(aFilalim))
							 oFilalim:aItems:=aFilalim
						 	 oFilalim:nAT:=1
						     oFilalim:bValid:={|| cFilalim:=upper(aItems[oFilalim:nAT]) } 
						Else 
							oFilalim:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nFilalim:=u,nFilalim)      },aFilalim:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
							oFilalim:lReadOnly := .T.
						Endif
				   endif 
				   
				   If nRegC>0  
					  desabilita(@oFilalim,aCampos2[nRegC,1])
				   Else
					  if xfuncao=2 //.or. MV_PAR04 <>  1
					     oFilalim:lVisibleControl := .F. 
					     oSay:lVisibleControl     := .F. 
					  Endif
				   Endif
				
				//05/09/12 - Flavia Rocha - NOVO CAMPO - CHAMADO: 00000029 - INCLUIR NO CHEQLIST DAS EXTRUSORAS 1,2 E 3 
				//LIMPEZA DOS CILINDROS DA TORRE GIRATORIA LIMPO = SIM E SUJO NÃO
			    //FR
			    If !Alltrim(MV_PAR01) $ "E04/E05"      
			    //os cilindros da torre giratória não existem nas estrusoras: E04 e E05, 
			    //então, não mostrar se forem estas extrusoras
				    nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cCilindro'} )
				    aVariavel[nRegV][2] 
				    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } ) 
				    IF PAR04 = 1   //MAQ. EM FUNCIONAMENTO
						If Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"      
							oSay   := TSay():New( nIni+=20,001,{|| 'Cilindros Torre Girat.' + CHR(13) + CHR(10)+ 'Limpos?'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
						Endif
						   if xFuncao == 2
							 If Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"      
							 	oCilindro := TGet():New( nIni+=15,001,{|u| If(PCount()>0,cCilindro:=u,cCilindro)         },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cCilindro'  ,,)
							 	oCilindro:bValid:={|| cCilindro:=upper(cCilindro) }
							 Endif
						   else
							 	If PAR04 = 1
									 oCilindro:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nCilindros:=u,nCilindros)      },aCilindro:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
									 ASize(aCilindro,Len(aCilindro))
									 oCilindro:aItems:=aCilindro
								 	 oCilindro:nAT:=1
								     oCilindro:bValid:={|| cCilindro:=upper(aItems[oCilindro:nAT]) } 
								Else
									oCilindro:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nCilindros:=u,nCilindros)      },aCilindro:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
									oFilalim:lReadOnly := .T.
								Endif
						   endif 
						   If Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"      
							   If nRegC>0  
								  desabilita(@oCilindro,aCampos2[nRegC,1])
							   Else
								  if xfuncao=2 
								     //oCilindro:lVisibleControl := .F.
								     //oSay:lVisibleControl     := .F. 
								     If !Alltrim(MV_PAR01) != "E04" .and. !Alltrim(MV_PAR01) != "E05"      
								     	oCilindro:lReadOnly := .T.  
								     Endif								     
								  Endif
							   Endif
						   Endif
					ENDIF  //MAQ. EM FUNCIONAMENTO
				Endif
				
			ENDIF //PAR04 = 1		
			//
			if xfuncao=2  
			   oGrp4 := TGroup():New( 042,347,255,459," Estrutura ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
               oSBox4     := TScrollBox():New( oGrp4,052,351,199,103,.T.,.T.,.T.)
               nIni:=0
               IF Type("aCoBrw1Est") <> "U" 
	               aSoEst:=fSoEst(z60CODIGO)      
	               for _X:=1 to len(aSoEst) 
		               oSayA      := TSay():New( nIni,005,,oSBox4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,300,008)    
		               cProdEst:=substr(aSoEst[_X][1],1,AT('-',aSoEst[_X][1])-1)
		               oSayA:cCaption:=cProdEst+'-'+ Posicione("SB1",1,xFilial("SB1") + cProdEst, "B1_DESC")
		               nIni+=08      
		               oSayB      := TSay():New( nIni,005,,oSBox4,,,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,072,008)             
		               oSayB:cCaption:=aSoEst[_X][2]
					   nIni+=10      
				   next
			   ENDIF
			endif 
			// 
			//FR			
		
		    //05/09/12 - Flavia Rocha - NOVO CAMPO - CHAMADO: 00000014 - INDICAR SE MÁQ. PARADA OU SETUP
		    //FR
		    //IF xFuncao <> 1  //VISUALIZAR OU CORRIGIR
			    If PAR04 <> 1
			    	nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cMaqParada'} )
			    	aVariavel[nRegV][2] 
			    	nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } ) 
			     
					//oSay   := TSay():New( nIni+=20,001,{|| 'Maquina Parada?'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )//original
				   if xFuncao == 2  //visualizar
				   	 oSay   := TSay():New( 028,001,{|| 'Maquina Parada?'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
					 //oMaqParada := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMaqParada:=u,cMaqParada)         },oSBox3,090,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMaqParada'  ,,)
					 //oMaqParada := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMaqParada:=u,cMaqParada)         },oSBox3,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMaqParada'  ,,)
					 oMaqParada := TGet():New( 038,001,{|u| If(PCount()>0,cMaqParada:=u,cMaqParada)         },oSBox3,090,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cMaqParada'  ,,)
					 oMaqParada:bValid:={|| cMaqParada:=upper(cMaqParada) }
				   else
				   		oSay   := TSay():New( nIni+=20,001,{|| 'Maquina Parada?'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
				   		If PAR04 <> 1
							 oMaqParada:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nMaqParada:=u,nMaqParada)      },aMaqParada:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
							 ASize(aMaqParada,Len(aMaqParada))
							 oMaqParada:aItems:=aMaqParada
						 	 oMaqParada:nAT:=1
						     oMaqParada:bValid:={|| cMaqParada:=upper(aItems[oMaqParada:nAT]) }
						Else
							oMaqParada:=	TComboBox():New( nIni+=15,001,{|u| if(Pcount()>0,nMaqParada:=u,nMaqParada)      },aMaqParada:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_HGRAY,.T.,,"",,,,,,, )
						Endif
				   endif 
				   
				   If nRegC>0  
					  desabilita(@oMaqParada,aCampos2[nRegC,1])
				   Else
					  if xfuncao=2  //VISUALIZAR
					     //oMaqParada:lVisibleControl := .F. 
					  		oMaqParada:lReadOnly := .T. 
					     //oSay:lVisibleControl     := .F. 
					  //elseif xfuncao= 1  .and. MV_PAR04 = 1  //incluir
					  //		oMaqParada:lReadOnly := .T.  
					  Endif
					  
				   Endif
				ENDIF //PAR04 <> 1 
			//ENDIF		
			
			///campo OBS para especificar o porque da máquina parada ou em setup
			//If (xfuncao = 1 .or. xfuncao = 2) .and. PAR04 <> 1 
			If PAR04 <> 1
				nRegV:=ASCAN(aVariavel, {|x| x[1] == 'cOBSMAQ'} )
			    aVariavel[nRegV][2] 
			    nRegC := ASCAN(aCampos2, {|x| x[9] ==aVariavel[nRegV][2] } )  
				cOBS1 := Substr(cOBSMAQ,1,24)  //23 fim
				cOBS2 := Substr(cOBSMAQ,25,24) //48 fim
				cOBS3 := Substr(cOBSMAQ,49,24) //72 fim
				cOBS4 := Substr(cOBSMAQ,73,24) //96 fim
				cOBS5 := Substr(cOBSMAQ,97,24) //120 fim
				cOBS6 := Substr(cOBSMAQ,121,24) //144 fim
				cOBS7 := Substr(cOBSMAQ,145,6) //150 fim
				//
				if xFuncao == 2  //visualizar
					oSay    := TSay():New( 052,001,{|| 'OBS Maquina:'                             },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,60,010 )
					//oOBSMAQ:= TGet():New(  060,001,{|u| If(PCount()>0,cOBSMAQ:=u,cOBSMAQ)   },oSBox3,080,028,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBSMAQ',,)
					oOBSMAQ:= TGet():New(  060,001,{|u| If(PCount()>0,cOBS1:=u,cOBS1)   },oSBox3,086,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBS1',,)
					oOBSMAQ:= TGet():New(  070,001,{|u| If(PCount()>0,cOBS2:=u,cOBS2)   },oSBox3,086,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBS2',,)
					oOBSMAQ:= TGet():New(  080,001,{|u| If(PCount()>0,cOBS3:=u,cOBS3)   },oSBox3,086,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBS3',,)
					oOBSMAQ:= TGet():New(  090,001,{|u| If(PCount()>0,cOBS4:=u,cOBS4)   },oSBox3,086,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBS4',,)
					oOBSMAQ:= TGet():New(  100,001,{|u| If(PCount()>0,cOBS5:=u,cOBS5)   },oSBox3,086,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBS5',,)
					oOBSMAQ:= TGet():New(  110,001,{|u| If(PCount()>0,cOBS6:=u,cOBS6)   },oSBox3,086,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBS6',,)
					oOBSMAQ:= TGet():New(  120,001,{|u| If(PCount()>0,cOBS7:=u,cOBS7)   },oSBox3,086,008,,,CLR_BLACK,CLR_HGRAY,,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBS7',,)
				else			
					oSay    := TSay():New( nIni+=20,001,{|| 'OBS Maquina:'                             },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,60,010 )
					oOBSMAQ:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cOBSMAQ:=u,cOBSMAQ)   },oSBox3,080,008,,,CLR_BLACK,iif(nRegC>0,inconforme(aCampos2[nRegC,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(nRegC>0,inconforme(aCampos2[nRegC,1],2),.F.),.F.,,'cOBSMAQ',,)		
				endif
				If nRegC>0  
				   desabilita(@oOBSMAQ,aCampos2[nRegC,1])
			    Else
				   if xfuncao=2
				     //oOBSMAQ:lVisibleControl := .F. 
				     //oSay:lVisibleControl   := .F.
				     oOBSMAQ:lReadOnly := .T.  
				   elseif xfuncao= 1  .and. MV_PAR04 = 1  //incluir
				  		oOBSMAQ:lReadOnly := .T. 			  
				   Endif
				Endif 
			Endif
			
			
			
			//FR - 05/09/12 - Flavia Rocha - FIM CHAMADO 00000014
			/*
			MV_PAR01 - Extrusora  (edit)
			MV_PAR02 - Produto    (edit)
			MV_PAR03 - Operador   (edit)
			MV_PAR04 - Status Maquina -> 1-Em Funcionamento , 2- Parada , 3-Setup (combo)
			*/
			if xFuncao==1
				cCod:=GetSx8Num( 'Z60', "Z60_CODIGO" )
			else
				
				IF PAR04 = 1
					cCod:=aCampos2[1,3]
					MV_PAR02:=aCampos2[1,5]
					PswOrder(1)
					If PswSeek( aCampos2[1,6], .T. )
						aUsua := PSWRET() 						// Retorna vetor com informações do usuário
						cSupervisor := Alltrim(aUsua[1][2])		// Nome do usuário
					Endif
				ELSE
					cCod:= z60CODIGO
					MV_PAR01 := cExtrusora
					MV_PAR02 := " --- "
					PswOrder(1)
					If PswSeek( cSuperi, .T. )
						aUsua := PSWRET() 						// Retorna vetor com informações do usuário
						cSupervisor := Alltrim(aUsua[1][2])		// Nome do usuário
					Endif
				ENDIF
				
			endif
			oGrp4      := TGroup():New( 004,002,038,344,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSay16     := TSay():New( 011,008,{||"Código:"    },oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
			oSay17     := TSay():New( 011,056,{||"Extrusora:" },oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
			oSay4      := TSay():New( 011,156,{||"Supervisor:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oSay5      := TSay():New( 011,091,{||"Produto:"   },oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			
			oGet1      := TGet():New( 019,008,{|u| If(PCount()>0,cCod:=u,cCod)              },oGrp4,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"cCod",,,         )
			oGet2      := TGet():New( 019,056,{|u| If(PCount()>0,MV_PAR01:=u,MV_PAR01)      },oGrp4,030,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","MV_PAR01",,   )
			oGet3      := TGet():New( 019,156,{|u| If(PCount()>0,cSupervisor:=u,cSupervisor)},oGrp4,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSupervisor",,)
			oGet4      := TGet():New( 019,091,{|u| If(PCount()>0,MV_PAR02:=u,MV_PAR02)      },oGrp4,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","MV_PAR02",,   )
			oGet1:disable()
			oGet2:disable()
			oGet3:disable()
			oGet4:disable()
			
			//FR - 26/11/2012
			//CHAMADO 00000231 - O ITEM GELADEIRA FOI RETIRADO DE TODAS AS EXTRUSORAS
			
			if xFuncao==1
				IF PAR04 <> 1     //SE NÃO ESTIVER EM FUNCIONAMENTO...
					IF Alltrim(MV_PAR01) != "E04" .AND. Alltrim(MV_PAR01) != "E05" 
					//FR - 26/11/12 - 00000231
					//se A EXTRUSORA É E01, E02, E03, OU SEJA, FOR DIFERENTE DE E04 ou E05:
					// POSSUI CILINDROS     
					// POSSUI FILTRO REVERSÍVEL
					// NÃO POSSUI HELICOIDAL
						IF Alltrim(MV_PAR01) = "E01"
							//FR - 26/11/12 - CHAMADO: 00000231
							//7 ZONAS
							//TEMP DE FILTRO
							//4 MATRIZES
							//NÃO TEM FLANGE
							//NÃO TEM CALIBRADOR            
							//NÃO TEM HELICOIDAL
							//TEM FILTRO REVERSÍVEL
							//TEM CILINDRO
							
							aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5
							@oZona6    ,;//  6
							@oZona7    ,;//  7
							@oMatriz1  ,;//  8
							@oMatriz2  ,;//  9
							@oMatriz3  ,;// 10
							@oMatriz4  ,;// 11
							@oFlange   ,;// 12
							@oSlit     ,;// 13
							@oCircAgua ,;// 14
							@oLinear   ,;// 15
							@oGrama    ,;// 16
							@oEspes    ,;// 17
							@oAltura   ,;// 18
							@oLargura  ,;// 19
							@oAlinha   ,;// 20
							@oCamera   ,;// 21						
							@oSensor   ,;// 22
							@oTrat     ,;// 23
							@oBobina   ,;// 24
					        @oFilReve  ,;// 25
						    @oFilAlim  ,;// 26
						    @oCaroco   ,;// 27	
						    @oPlanic   ,;// 28	
						    @oKgh      ,;// 29	
						    @oCilindro ,;// 30
						    @oMaqParada} // 31
						    
						    //@oHelic    ,;// 15  //RETIRADO
						    //@oFiltro   ,;// 12  //RETIRADO
						    //@oCalib    ,;// 14  //RETIRADO
						    
					    ELSEIF Alltrim(MV_PAR01) = "E02"
					    	//FR - 26/11/12 - CHAMADO: 00000231
					    	//5 ZONAS
					    	//NÃO TEM TEMP DE FILTRO        
					    	//1 MATRIZ 
					    	//TEM FLANGE
					    	//TEM CALIBRADOR
					    	//NÃO TEM HELICOIDAL
					    	//TEM FILTRO REVERSÍVEL
					    	//TEM CILINDRO
					    	
							aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5
							@oMatriz1  ,;//  6
							@oFlange   ,;// 7
							@oCalib    ,;// 8
							@oSlit     ,;// 9
							@oCircAgua ,;// 10
							@oLinear   ,;// 11
							@oGrama    ,;// 12
							@oEspes    ,;// 13
							@oAltura   ,;// 14
							@oLargura  ,;// 15
							@oAlinha   ,;// 16
							@oCamera   ,;// 17						
							@oSensor   ,;// 18
							@oTrat     ,;// 19
							@oBobina   ,;// 20
					        @oFilReve  ,;// 21
						    @oFilAlim  ,;// 22
						    @oCaroco   ,;// 23	
						    @oPlanic   ,;// 24	
						    @oKgh      ,;// 25	
						    @oCilindro ,;// 26
						    @oMaqParada} // 27
						    
						    //@oHelic    ,;// 15  //RETIRADO
						    //@oZona6    ,;//  6  //RETIRADO
							//@oZona7    ,;//  7    //RETIRADO
							//@oFiltro   ,;// 12  //RETIRADO
							//@oMatriz2  ,;//  9  //RETIRADO
							//@oMatriz3  ,;// 10  //RETIRADO
							//@oMatriz4  ,;// 11 //RETIRADO
							
	                    ELSEIF Alltrim(MV_PAR01) = "E03"
	                    	//FR - 26/11/12 - CHAMADO: 00000231
	                    	//5 ZONAS
	                    	//TEM TEMP DE FILTRO
	                    	//NÃO TEM FLANGE
	                    	//NÃO TEM CALIBRADOR
	                    	//NÃO TEM HELICOIDAL
	                    	//TEM FILTRO REVERSÍVEL
	                    	//TEM CILINDRO
	                    	
	                    	aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5							
							@oMatriz1  ,;//  6
							@oMatriz2  ,;//  7
							@oMatriz3  ,;// 8
							@oFiltro   ,;// 9
							@oSlit     ,;// 10
							@oCircAgua ,;// 11
							@oLinear   ,;// 12
							@oGrama    ,;// 13
							@oEspes    ,;// 14
							@oAltura   ,;// 15
							@oLargura  ,;// 16
							@oAlinha   ,;// 17
							@oCamera   ,;// 18						
							@oSensor   ,;// 19
							@oTrat     ,;// 20
							@oBobina   ,;// 21
					        @oFilReve  ,;// 22
						    @oFilAlim  ,;// 23
						    @oCaroco   ,;// 24	
						    @oPlanic   ,;// 25	
						    @oKgh      ,;// 26	
						    @oCilindro ,;// 27
						    @oMaqParada} // 28
						    
						    //@oHelic    ,;// 15  //RETIRADO
						    //@oZona6    ,;//  6  //RETIRADO
							//@oZona7    ,;//  7  //RETIRADO
							//@oMatriz4  ,;// 11  //RETIRADO 
							//@oFlange   ,;// 13  //RETIRADO
							//@oCalib    ,;// 14  //RETIRADO
	                    ENDIF
	                    
					ELSE  //E04 ou E05
						IF Alltrim(MV_PAR01) = "E04"
							//FR - 26/11/12 - 00000231
							//5 ZONAS
							//NÃO TEM TEMP DE FILTRO
							//1 MATRIZ
							//NÃO TEM FLANGE
							//NÃO TEM CALIBRADOR
							//TEM HELICOIDAL
							//NÃO TEM FILTRO REVERSÍVEL
							//NÃO TEM CILINDRO

						
							aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5
							@oMatriz1  ,;//  6
							@oHelic    ,;// 7
							@oSlit     ,;// 8
							@oCircAgua ,;// 9
							@oLinear   ,;// 10
							@oGrama    ,;// 11
							@oEspes    ,;// 12
							@oAltura   ,;// 13
							@oLargura  ,;// 14
							@oAlinha   ,;// 15
							@oCamera   ,;// 16						
							@oSensor   ,;// 17
							@oTrat     ,;// 18
							@oBobina   ,;// 19				        
						    @oFilAlim  ,;// 20
						    @oCaroco   ,;// 21	
						    @oPlanic   ,;// 22	
						    @oKgh      ,;// 23					    
						    @oMaqParada}  //24  
						    
						    //@oZona6    ,;//  6 //RETIRADO
							//@oZona7    ,;//  7 //RETIRADO
					        //@oMatriz2  ,;//  9 //RETIRADO
							//@oMatriz3  ,;// 10 //RETIRADO
							//@oMatriz4  ,;// 11 //RETIRADO
					        //@oFlange   ,;// 13 //RETIRADO
					        //@oCalib    ,;// 14 //RETIRADO
					        //@oFiltro   ,;// 12 //RETIRADO
					        //@oCilindro ,;// 27 //RETIRADO
					        
					    ELSEIF Alltrim(MV_PAR01) = "E05"
					    	//FR - 26/11/12 - CHAMADO: 00000231
					    	//4 ZONAS
					    	//NÃO TEM TEMP DE FILTRO
					    	//1 MATRIZ 
					    	//NÃO TEM FLANGE
					    	//NÃO TEM CALIBRADOR
					    	//TEM HELICOIDAL
					    	//NÃO TEM FILTRO REVERSÍVEL
					    	//NÃO TEM CILINDRO
					    	
					    	aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oMatriz1  ,;//  5
							@oHelic    ,;// 6
							@oSlit     ,;// 7
							@oCircAgua ,;// 8
							@oLinear   ,;// 9
							@oGrama    ,;// 10
							@oEspes    ,;// 11
							@oAltura   ,;// 12
							@oLargura  ,;// 13
							@oAlinha   ,;// 14
							@oCamera   ,;// 15						
							@oSensor   ,;// 16
							@oTrat     ,;// 17
							@oBobina   ,;// 18				        
						    @oFilAlim  ,;// 19
						    @oCaroco   ,;// 20	
						    @oPlanic   ,;// 21	
						    @oKgh      ,;// 22					    
						    @oMaqParada}  //23
						    
						    //@oZona5    ,;//  5 //RETIRADO
							//@oZona6    ,;//  6 //RETIRADO
							//@oZona7    ,;//  7 //RETIRADO
					        //@oFiltro   ,;// 12 //RETIRADO
					        //@oCilindro ,;// 15 //RETIRADO
					        //@oMatriz2  ,;//  9 //RETIRADO
							//@oMatriz3  ,;// 10 //RETIRADO
							//@oMatriz4  ,;// 11 //RETIRADO
							//@oFlange   ,;// 13 //RETIRADO
							//@oCalib    ,;// 14 //RETIRADO
					    ENDIF
					ENDIF   //E04 - E05
					//cOBSMAQ := MV_PAR05 + " " + MV_PAR06
			    	//cProdut := MV_PAR02
			    	lParada := .T.
			    	//If MsgYesNo("Deseja Confirmar Máquina Parada / Setup ? ")
			    	//	grava(lParada)
			    	//Else
			    		//alert("sem ação")
			    	//Endif
				
				ELSE //MÁQ. FUNCIONANDO
				
					IF !Alltrim(MV_PAR01) $ "E04/E05"
						IF Alltrim(MV_PAR01) = "E01"
							//FR - 26/11/12 - CHAMADO: 00000231
							//7 ZONAS
							//TEMP DE FILTRO
							//4 MATRIZES
							//NÃO TEM FLANGE
							//NÃO TEM CALIBRADOR            
							//NÃO TEM HELICOIDAL
							//TEM FILTRO REVERSÍVEL
							//TEM CILINDRO
							
							aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5
							@oZona6    ,;//  6
							@oZona7    ,;//  7
							@oMatriz1  ,;//  8
							@oMatriz2  ,;//  9
							@oMatriz3  ,;// 10
							@oMatriz4  ,;// 11
							@oFlange   ,;// 12
							@oSlit     ,;// 13
							@oCircAgua ,;// 14
							@oLinear   ,;// 15
							@oGrama    ,;// 16
							@oEspes    ,;// 17
							@oAltura   ,;// 18
							@oLargura  ,;// 19
							@oAlinha   ,;// 20
							@oCamera   ,;// 21						
							@oSensor   ,;// 22
							@oTrat     ,;// 23
							@oBobina   ,;// 24
					        @oFilReve  ,;// 25
						    @oFilAlim  ,;// 26
						    @oCaroco   ,;// 27	
						    @oPlanic   ,;// 28	
						    @oKgh      ,;// 29	
						    @oCilindro }// 30
						    
						    //@oHelic    ,;// 15  //RETIRADO
						    //@oFiltro   ,;// 12  //RETIRADO
						    //@oCalib    ,;// 14  //RETIRADO
						    
					    ELSEIF Alltrim(MV_PAR01) = "E02"
					    	//FR - 26/11/12 - CHAMADO: 00000231
					    	//5 ZONAS
					    	//NÃO TEM TEMP DE FILTRO        
					    	//1 MATRIZ 
					    	//TEM FLANGE
					    	//TEM CALIBRADOR
					    	//NÃO TEM HELICOIDAL
					    	//TEM FILTRO REVERSÍVEL
					    	//TEM CILINDRO
					    	
							aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5
							@oMatriz1  ,;//  6
							@oFlange   ,;// 7
							@oCalib    ,;// 8
							@oSlit     ,;// 9
							@oCircAgua ,;// 10
							@oLinear   ,;// 11
							@oGrama    ,;// 12
							@oEspes    ,;// 13
							@oAltura   ,;// 14
							@oLargura  ,;// 15
							@oAlinha   ,;// 16
							@oCamera   ,;// 17						
							@oSensor   ,;// 18
							@oTrat     ,;// 19
							@oBobina   ,;// 20
					        @oFilReve  ,;// 21
						    @oFilAlim  ,;// 22
						    @oCaroco   ,;// 23	
						    @oPlanic   ,;// 24	
						    @oKgh      ,;// 25	
						    @oCilindro }// 26
						    
						    //@oHelic    ,;// 15  //RETIRADO
						    //@oZona6    ,;//  6  //RETIRADO
							//@oZona7    ,;//  7    //RETIRADO
							//@oFiltro   ,;// 12  //RETIRADO
							//@oMatriz2  ,;//  9  //RETIRADO
							//@oMatriz3  ,;// 10  //RETIRADO
							//@oMatriz4  ,;// 11 //RETIRADO
							
	                    ELSEIF Alltrim(MV_PAR01) = "E03"
	                    	//FR - 26/11/12 - CHAMADO: 00000231
	                    	//5 ZONAS
	                    	//TEM TEMP DE FILTRO
	                    	//NÃO TEM FLANGE
	                    	//NÃO TEM CALIBRADOR
	                    	//NÃO TEM HELICOIDAL
	                    	//TEM FILTRO REVERSÍVEL
	                    	//TEM CILINDRO
	                    	
	                    	aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5							
							@oMatriz1  ,;//  6
							@oMatriz2  ,;//  7
							@oMatriz3  ,;// 8
							@oFiltro   ,;// 9
							@oSlit     ,;// 10
							@oCircAgua ,;// 11
							@oLinear   ,;// 12
							@oGrama    ,;// 13
							@oEspes    ,;// 14
							@oAltura   ,;// 15
							@oLargura  ,;// 16
							@oAlinha   ,;// 17
							@oCamera   ,;// 18						
							@oSensor   ,;// 19
							@oTrat     ,;// 20
							@oBobina   ,;// 21
					        @oFilReve  ,;// 22
						    @oFilAlim  ,;// 23
						    @oCaroco   ,;// 24	
						    @oPlanic   ,;// 25	
						    @oKgh      ,;// 26	
						    @oCilindro }// 27
						    
						    //@oHelic    ,;// 15  //RETIRADO
						    //@oZona6    ,;//  6  //RETIRADO
							//@oZona7    ,;//  7  //RETIRADO
							//@oMatriz4  ,;// 11  //RETIRADO 
							//@oFlange   ,;// 13  //RETIRADO
							//@oCalib    ,;// 14  //RETIRADO
	                    ENDIF
					    
					ELSE  //É E04 ou E05
						IF Alltrim(MV_PAR01) = "E04"
							//FR - 26/11/12 - 00000231
							//5 ZONAS
							//NÃO TEM TEMP DE FILTRO
							//1 MATRIZ
							//NÃO TEM FLANGE
							//NÃO TEM CALIBRADOR
							//TEM HELICOIDAL
							//NÃO TEM FILTRO REVERSÍVEL
							//NÃO TEM CILINDRO

						
							aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oZona5    ,;//  5
							@oMatriz1  ,;//  6
							@oHelic    ,;// 7
							@oSlit     ,;// 8
							@oCircAgua ,;// 9
							@oLinear   ,;// 10
							@oGrama    ,;// 11
							@oEspes    ,;// 12
							@oAltura   ,;// 13
							@oLargura  ,;// 14
							@oAlinha   ,;// 15
							@oCamera   ,;// 16						
							@oSensor   ,;// 17
							@oTrat     ,;// 18
							@oBobina   ,;// 19				        
						    @oFilAlim  ,;// 20
						    @oCaroco   ,;// 21	
						    @oPlanic   ,;// 22	
						    @oKgh     } // 23					    
						    
						    //@oZona6    ,;//  6 //RETIRADO
							//@oZona7    ,;//  7 //RETIRADO
					        //@oMatriz2  ,;//  9 //RETIRADO
							//@oMatriz3  ,;// 10 //RETIRADO
							//@oMatriz4  ,;// 11 //RETIRADO
					        //@oFlange   ,;// 13 //RETIRADO
					        //@oCalib    ,;// 14 //RETIRADO
					        //@oFiltro   ,;// 12 //RETIRADO
					        //@oCilindro ,;// 27 //RETIRADO
					        
					    ELSEIF Alltrim(MV_PAR01) = "E05"
					    	//FR - 26/11/12 - CHAMADO: 00000231
					    	//4 ZONAS
					    	//NÃO TEM TEMP DE FILTRO
					    	//1 MATRIZ 
					    	//NÃO TEM FLANGE
					    	//NÃO TEM CALIBRADOR
					    	//TEM HELICOIDAL
					    	//NÃO TEM FILTRO REVERSÍVEL
					    	//NÃO TEM CILINDRO
					    	
					    	aObj:={;
							@oZona1    ,;//  1
							@oZona2    ,;//  2
							@oZona3    ,;//  3
							@oZona4    ,;//  4
							@oMatriz1  ,;//  5
							@oHelic    ,;// 6
							@oSlit     ,;// 7
							@oCircAgua ,;// 8
							@oLinear   ,;// 9
							@oGrama    ,;// 10
							@oEspes    ,;// 11
							@oAltura   ,;// 12
							@oLargura  ,;// 13
							@oAlinha   ,;// 14
							@oCamera   ,;// 15						
							@oSensor   ,;// 16
							@oTrat     ,;// 17
							@oBobina   ,;// 18				        
						    @oFilAlim  ,;// 19
						    @oCaroco   ,;// 20	
						    @oPlanic   ,;// 21	
						    @oKgh      }// 22					    
						    
						    //@oZona5    ,;//  5 //RETIRADO
							//@oZona6    ,;//  6 //RETIRADO
							//@oZona7    ,;//  7 //RETIRADO
					        //@oFiltro   ,;// 12 //RETIRADO
					        //@oCilindro ,;// 15 //RETIRADO
					        //@oMatriz2  ,;//  9 //RETIRADO
							//@oMatriz3  ,;// 10 //RETIRADO
							//@oMatriz4  ,;// 11 //RETIRADO
							//@oFlange   ,;// 13 //RETIRADO
							//@oCalib    ,;// 14 //RETIRADO
					    ENDIF
	
					
					ENDIF	//E04 - E05	    
			
				ENDIF    //MÁQ. FUNCIONANDO
				
				oSBtn1     := SButton():New( 260,276,1,{|| grava(lParada,@oDlg1,aObj) },oDlg1,,"", )
				oSBtn2     := SButton():New( 260,311,2,{|| oDlg1:end(),RollBackSX8()  },oDlg1,,"", )
			else
				oSBtn2     := SButton():New( 260,311,1,{|| oDlg1:end()  },oDlg1,,"", )
			endif //endif do xfuncao = 1
			
			
			
			oDlg1:Activate(,,,.T.)
	//ENDIF //PAR04 = 1
	
else   //else do if xfuncao != 3 -> corrigir
	z60CODIGO := Z60->Z60_CODIGO
	z60ITEM   := Z60->Z60_ITEM 		
	cProduto := Z60->Z60_PRODUT
	cExtrusora := Z60->Z60_EXTRUS
	cSuperi    := Z60->Z60_SUPERI
	cMaqParada := Z60->Z60_VALOR
	cOBSMAQ    := Z60->Z60_STAOBS
	PAR01      := cExtrusora
	z60VALOR   := Z60->Z60_VALOR
	//While Z60->Z60_CODIGO == z60CODIGO .and. xFilial("Z60") == Z60->Z60_FILIAL
		If Alltrim(z60ITEM) = "F09"
			//ALERT("Z60->Z60_VALOR: " + Z60->Z60_VALOR )
			PAR04 := iif( z60VALOR = 'NAO' , 1 , 2 )	//máquina parada? 2-SIM / 1-NÃO	
		ElseIf !Empty(Alltrim(cProduto))  //se tiver preenchido o produto, é porque a máquina estava em funcionamento
			PAR04 := 1
		Endif
		//Z60->(Dbskip())
	//Enddo
	//IF PAR04 = 1	
		   
		   	//if Z60->Z60_INICIO !='*'
			//	alert("A correção só está disponível para um item que ORIGINOU a pendência")     //31/10/12 - Robinson avisou que não está correto isto
				//return
			//endif
			
			////aVariavel
			IF Alltrim(PAR01) != "E04" .and. Alltrim(PAR01) != "E05" 
		    	//FR - 26/11/12 - 00000231
		    	//SE EXTRUSORA É DIFERENTE DE E04 e E05:
		    	//TEM CILINDRO TORRE GIRATÓRIA 
		    	//TEM FILTRO REVERSÍVEL
		    	//NÃO TEM HELICOIDAL
		    	
		    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
				IF PAR04 = 1    //maq. FUNCIONANDO = 1
					/*
					MV_PAR01 - Extrusora  (edit)
					MV_PAR02 - Produto    (edit)
					MV_PAR03 - Operador   (edit)
					MV_PAR04 - Status Maquina -> 1-Em Funcionamento , 2- Parada , 3-Setup (combo)
					*/    
		        	//FR - 26/11/2012
		        	//CHAMADO 00000231 - FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
		        	IF Alltrim(PAR01) = "E01"
		        		//FR - 26/11/12 - CHAMADO: 00000231  
		        		//7 ZONAS
		        		//TEM TEMP DE FILTRO
		        		//4 MATRIZ
		        		//NÃO TEM FLANGE
		        		//NÃO TEM CALIBRADOR
		        		//NÃO TEM HELICOIDAL
		        		//TEM FILTRO REVERSÍVEL
		        		//TEM CILINDRO
		        	
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },; //1
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },; //2
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },; //3
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },; //4
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },; //5
										{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //6
										{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //7
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },; //8
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //9
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //10
										{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //11
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //12
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },; //13
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },; //14
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },; //15
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },; //16
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },; //17
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },; //18
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },; //19
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },; //20
										{"cCaroco"    ,"G07",""          ,"Caroco"                },; //21
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },; //22
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },; //23
										{"cCamera"    ,"F01",""          ,"Camera"                },; //24								
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },; //25
										{"cTratamento","F04",""          ,"Tratamento"            },; //26
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },; //27
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //28
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },; //29
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } } //30
										
										//{"cGeladeira" ,"F02","cGeladeira","Geladeira"            },;
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO							
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO
										
					ELSEIF Alltrim(PAR01) = "E02"
						//FR - 26/11/12 - CHAMADO: 00000231
						//5 ZONAS       
						//NÃO TEM TEMP DE FILTRO
						//1 MATRIZ 
						//TEM FLANGE
						//TEM CALIBRADOR
						//NÃO TEM HELICOIDAL
						//TEM FILTRO REVERSÍVEL
						//TEM CILINDRO
						
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },;
										{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;								
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;								
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } }
										
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
										//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO
										
					ELSEIF Alltrim(PAR01) = "E03"
						//FR - 26/11/12 - CHAMADO: 00000231
						//5 ZONAS
						//TEM TEMP DE FILTRO
						//3 MATRIZ 
						//NÃO TEM FLANGE 
						//NÃO TEM CALIBRADOR
						//NÃO TEM HELICOIDAL
						//TEM FILTRO REVERSÍVEL
						//TEM CILINDRO
						
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
										{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;								
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." } }
										
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO
										
										
					ENDIF  //E01, E02, E03
								
				ELSE   //MÁQUINA PARADA
					
					IF Alltrim(PAR01) = "E01"
		        		//FR - 26/11/12 - CHAMADO: 00000231  
		        		//7 ZONAS
		        		//TEM TEMP DE FILTRO
		        		//4 MATRIZ
		        		//NÃO TEM FLANGE
		        		//NÃO TEM CALIBRADOR
		        		//NÃO TEM HELICOIDAL
		        		//TEM FILTRO REVERSÍVEL
		        		//TEM CILINDRO
		        	
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
										{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
										{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },;
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;								
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
										{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }						
										
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO							
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO
										
					ELSEIF Alltrim(PAR01) = "E02"
						//FR - 26/11/12 - CHAMADO: 00000231
						//5 ZONAS       
						//NÃO TEM TEMP DE FILTRO
						//1 MATRIZ 
						//TEM FLANGE
						//TEM CALIBRADOR
						//NÃO TEM HELICOIDAL
						//TEM FILTRO REVERSÍVEL
						//TEM CILINDRO
						
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },;
										{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;								
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;								
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
							   			{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }						
										
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
										//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO
										
					ELSEIF Alltrim(PAR01) = "E03"
						//FR - 26/11/12 - CHAMADO: 00000231
						//5 ZONAS
						//TEM TEMP DE FILTRO
						//3 MATRIZ 
						//NÃO TEM FLANGE 
						//NÃO TEM CALIBRADOR
						//NÃO TEM HELICOIDAL
						//TEM FILTRO REVERSÍVEL
						//TEM CILINDRO
						
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },;
										{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },;
										{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },;
										{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;								
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;
										{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },;
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
										{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }						
										
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },; //RETIRADO
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },;	//RETIRADO
										
										
					ENDIF  //E01, E02, E03    
				
				
								
				ENDIF  //MAQ PARADA ou FUNCIONANDO						
	    	
	    
		    ELSE   //E04 e E05
		    
		    //FR - 26/11/12 - CHAMADO: 00000231
		    //SE EXTRUSORA É = E04 e E05:
		    //NÃO TEM CILINDRO TORRE GIRATÓRIA
		    //NÃO TEM FILTRO REVERSÍVEL
		    //TEM HELICOIDAL
		    
		    //FR - 26/11/2012 - CHAMADO: 00000231
	        //CHAMADO 00000231 - FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
		    	
		    	IF PAR04 = 1
			    	/*
					MV_PAR01 - Extrusora  (edit)
					MV_PAR02 - Produto    (edit)
					MV_PAR03 - Operador   (edit)
					MV_PAR04 - Status Maquina -> 1-Em Funcionamento , 2- Parada , 3-Setup (combo)
					*/    
					IF Alltrim(PAR01) = "E04"  
						//FR - 26/11/12 - CHAMADO: 00000231
						//5 ZONAS
						//NÃO TEM TEMP DE FILTRO
						//1 MATRIZ
						//NÃO TEM FLANGE
						//NÃO TEM CALIBRADOR 
						//TEM HELICOIDAL
						//NÃO TEM FILTRO REVERSÍVEL
						//NÃO TEM CILINDRO
						
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;							
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;								
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  } }
										
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
										//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
										//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO 
										//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO
										
					ELSEIF Alltrim(PAR01) = "E05"
						//FR - 26/11/12 - CHAMADO: 00000231
						//4 ZONAS
						//NÃO TEM TEMP DE FILTRO
						//1 MATRIZ 
						//NÃO TEM FLANGE
						//NÃO TEM CALIBRADOR
						//TEM HELICOIDAL
						//NÃO TEM FILTRO REVERSÍVEL 
						//NÃO TEM CILINDRO
						
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;							
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;								
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  } }
										 
										//{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },; //RETIRADO
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
										//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
										//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO 
										//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO
					ENDIF		
		    	ELSE     //MAQ. PARADA
		    	
		    		IF Alltrim(PAR01) = "E04"  
						//FR - 26/11/12 - CHAMADO: 00000231
						//5 ZONAS
						//NÃO TEM TEMP DE FILTRO
						//1 MATRIZ
						//NÃO TEM FLANGE
						//NÃO TEM CALIBRADOR 
						//TEM HELICOIDAL
						//NÃO TEM FILTRO REVERSÍVEL
						//NÃO TEM CILINDRO
						
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;							
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;								
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
										{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }						
										
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
										//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
										//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO 
										//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO
										
					ELSEIF Alltrim(PAR01) = "E05"
						//FR - 26/11/12 - CHAMADO: 00000231
						//4 ZONAS
						//NÃO TEM TEMP DE FILTRO
						//1 MATRIZ 
						//NÃO TEM FLANGE
						//NÃO TEM CALIBRADOR
						//TEM HELICOIDAL
						//NÃO TEM FILTRO REVERSÍVEL 
						//NÃO TEM CILINDRO
						
				    	//                VARIAVEL     ITEM  VARIAVEL2    DESCRICAO 
						aVariavel:={    {"cZona1"     ,"T01","cZona11"   ,"Zona 1"                },;
										{"cZona2"     ,"T04","cZona22"   ,"Zona 2"                },;
										{"cZona3"     ,"T05","cZona33"   ,"Zona 3"                },;
										{"cZona4"     ,"T06","cZona44"   ,"Zona 4"                },;
										{"cMatriz1"   ,"T02","cMatriz11" ,"Matriz 1"              },;
										{"cHelic"     ,"T17","cHelic1"   ,"Helicoidal"            },;
										{"cSlit"      ,"T03",""          ,"Conformidade Do Slit"  },;
										{"cCircAgua"  ,"T13",""          ,"Circulacao De Agua"    },;
										{"cLinear"    ,"G01","cLinear1"  ,"Linear"                },;
										{"cGrama"     ,"G02","cGrama1"   ,"Grama/Metro"           },;
										{"cEspes"     ,"G03","cEspes1"   ,"Espessura"             },;
										{"cAltura"    ,"G04","cAltura1"  ,"Altura Do Balao"       },;
										{"cLargura"   ,"G05","cLargura1" ,"Largura Da Bobina"     },;
										{"cAlinha"    ,"G06",""          ,"Alinhamento Bobina"    },;
										{"cCaroco"    ,"G07",""          ,"Caroco"                },;
										{"cPlanic"    ,"G08",""          ,"Planicidade"           },;
										{"cKgH"       ,"G09","cKgH1"     ,"Kg/h"                  },;
										{"cCamera"    ,"F01",""          ,"Camera"                },;							
										{"cSensor"    ,"F03",""          ,"Sensor Ponto De Neve"  },;
										{"cTratamento","F04",""          ,"Tratamento"            },;
										{"cBobina"    ,"F05",""          ,"Bobinadeira"           },;								
										{"cFilAlim"   ,"F07",""          ,"Fitro Do Alimentador"  },;
										{"cMaqParada" ,"F09",""          ,"Maquina Parada?"   },;
							   			{"cOBSMAQ"    ,"F10",""          ,"OBS Maquina:"   } }						
										 
										//{"cZona5"     ,"T07","cZona55"   ,"Zona 5"                },; //RETIRADO
										//{"cZona6"     ,"T08","cZona66"   ,"Zona 6"                },; //RETIRADO
										//{"cZona7"     ,"T09","cZona77"   ,"Zona 7"                },; //RETIRADO
										//{"cFiltro"    ,"T14","cFiltro1"  ,"Temp De Filtro"        },; //RETIRADO
										//{"cMatriz2"   ,"T10","cMatriz22" ,"Matriz 2"              },; //RETIRADO
										//{"cMatriz3"   ,"T11","cMatriz33" ,"Matriz 3"              },; //RETIRADO
										//{"cMatriz4"   ,"T12","cMatriz44" ,"Matriz 4"              },; //RETIRADO
										//{"cFlange"    ,"T15","cFlange1"  ,"Flange"                },; //RETIRADO
										//{"cCalib"     ,"T16","cCalib1"   ,"Calibrador"            },; //RETIRADO
										//{"cFilReve"   ,"F06",""          ,"Fitro Do Reversivel"   },; //RETIRADO 
										//{"cCilindro"  ,"F08",""          ,"Limpeza Cilindro Torre Girat." },; //RETIRADO
					ENDIF	//E04 , E05	
		    		
		    	ENDIF  //MAQ. PARADA - FUNCIONANDO
		    	
		    ENDIF  //E04 , E05
			
			
			////aVarivel
			
			cOpcao := " - Corrigir"
			
			//DIALOG DO CORRIGIR
			cObs:=space(100)
			//oDlg1      := MSDialog():New( 152,327,620,1020,"Correção da Inspeção" + cOpcao,,,.F.,,,,,,.T.,,,.F. )
			oDlg1      := MSDialog():New( 152,327,712,1259,"Correção da Inspeção" + cOpcao,,,.F.,,,,,,.T.,,,.F. )
		
			cQry :=""
			cQry+=" select  Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2, Z60_ITEM ITEM ,Z60_CODIGO COD,Z60_EXTRUS EXT,Z60_PRODUT PROD,Z60_SUPERI SUPI,Z60_HORAI HORAI,Z60_ITEMD ITEMD" +chr(10)
			cQry+=" FROM "+ RetSqlName( "Z60" ) +" Z60 "         + chr(10)
			cQry+=" WHERE D_E_L_E_T_=''"                         + chr(10)
			cQry+=" AND Z60_PRODUT = '" + Alltrim(cProduto) + "' "   + LF
			cQry+=" AND Z60_EXTRUS = '" + Alltrim(cExtrusora) + "' " + LF
			cQry+="  AND Z60_CODIGO= '" + Alltrim(z60CODIGO)  + "' " + LF
			IF PAR04 = 1
				cQry+=" AND Z60_ITEM NOT IN ('F09','F02','T15','T16','T17') " + chr(13) + chr(10)  //SE A MÁQUINA ESTIVER EM FUNCIONAMENTO, NÃO PRECISA ADICIONAR ESTE VALOR
			ELSEIF Alltrim(z60ITEM) = 'F09'
				cQry+=" AND Z60_ITEM = 'F09' " + chr(13) + chr(10)  //SE A MÁQUINA NÃO ESTIVER EM FUNCIONAMENTO, SÓ ADICIONAR ESTE VALOR
			ENDIF
			cQry+=" order by Z60_ITEM"                           + chr(10)
		    MemoWrite("C:\Temp\CORRIGIR.SQL",cQry)
			//cItem:=Z60->Z60_ITEM   //FR
			
			TCQUERY cQry   NEW ALIAS 'AUX2'
			aCampos2:={}
			while !AUX2->(EOF())
				PswOrder(1)
				aadd(aCampos2,{PENDEN,"",ITEM,VALOR,COD,EXT,PROD,SUPI,VALOR2,ITEMD})
				AUX2->(dbskip())
			enddo
			AUX2->(DBCLOSEAREA())
			If PswSeek( aCampos2[1,8], .T. )
				aUsua := PSWRET() 						// Retorna vetor com informações do usuário
				cSupervisor := Alltrim(aUsua[1][2])		// Nome do usuário
			Endif
			 
			ini:=10
			tab1:=15
			tab2:=40
			///dialog Corrigir
			oGrp0      := TGroup():New( 0,10,020,340,"INSPEÇÃO",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSay0      := TSay():New( ini,15,{|| "Codigo:"      },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
			oSay0      := TSay():New( ini,35,{|| aCampos2[1,5]  },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
			
			oSay0      := TSay():New( ini,75,{|| "Extrusora:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
			oSay0      := TSay():New( ini,102,{|| aCampos2[1,6] },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
			
			oSay0      := TSay():New( ini,130,{|| "Produto:"    },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
			oSay0      := TSay():New( ini,153,{|| aCampos2[1,7] },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
			
			oSay0      := TSay():New( ini,185,{|| "Supervisor:" },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
			oSay0      := TSay():New( ini,215,{|| cSupervisor   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
			
		
		oGrp1 := TGroup():New( 25,10,210,105,"TEMPERATURA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oGrp2 := TGroup():New( 25,110,210,205,"GRAVIMETRO",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oGrp3 := TGroup():New( 25,210,210,305,"FERRAMENTA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

        oGrp4 := TGroup():New( 25,310,210,455,"ESTRUTURA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		nLinT:=nLinG:=nLinF:=nLinE:=035
		
		For _x:=1 to len(aCampos2)
		
		    nRegD := ASCAN(aVariavel, {|x| alltrim(x[2]) == alltrim(aCampos2[_x][3]) })           
		    
		    If SUBSTR(aCampos2[_x][3],1,1)='T'  // TEMPERATURA  
		       // item 
		       oSay1 := TSay():New( nLinT,015,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][3]!=z60ITEM,CLR_BLACK,CLR_HRED ),CLR_WHITE,050,008)
		       oSay1:cCaption:=aVariavel[nRegD][4]    
		       // valor
		       oSay2 := TSay():New( nLinT,070,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
		       oSay2:cCaption:= aCampos2[_x][4]     
		       nLinT+=10
		    Endif
			
		    If SUBSTR(aCampos2[_x][3],1,1)='G' // GRAVIMETRO
		       // item 
		       oSay1 := TSay():New( nLinG,115,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][3]!=z60ITEM,CLR_BLACK,CLR_HRED ),CLR_WHITE,050,008)
		       oSay1:cCaption:=aVariavel[nRegD][4]    
		       // valor
		       oSay2 := TSay():New( nLinG,180,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
		       oSay2:cCaption:= aCampos2[_x][4]     
		       nLinG+=10
		    Endif
		
		    If SUBSTR(aCampos2[_x][3],1,1)= 'F' // FERRAMENTA
			   // item 
		       oSay1 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][3]!=Z60ITEM,CLR_BLACK,CLR_HRED ),CLR_WHITE,050,008)
		       oSay1:cCaption:=aVariavel[nRegD][4]    
		       // valor
		       oSay2 := TSay():New( nLinF,290,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
		       oSay2:cCaption:= aCampos2[_x][4]     
		       nLinF+=10
		       
		       IF PAR04 <> 1
			       	cOBS1 := Substr(cOBSMAQ,1,24)  //23 fim
					cOBS2 := Substr(cOBSMAQ,25,24) //48 fim
					cOBS3 := Substr(cOBSMAQ,49,24) //72 fim
					cOBS4 := Substr(cOBSMAQ,73,24) //96 fim
					cOBS5 := Substr(cOBSMAQ,97,24) //120 fim
					cOBS6 := Substr(cOBSMAQ,121,24) //144 fim
					cOBS7 := Substr(cOBSMAQ,145,6) //150 fim
			
			       // obs maq 
			       oSay1 := TSay():New( nLinF + 5,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
			       oSay1:cCaption:= "OBS Maquina:"
			       nLinF+=15    
			       // valor
			       oSay2 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE ,080,008)
			       oSay2:cCaption:= cOBS1
			       nLinF+=13     
			       oSay3 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE ,080,008)
			       oSay3:cCaption:= cOBS2 
			       nLinF+=13    
			       oSay4 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE ,080,008)
			       oSay4:cCaption:= cOBS3     
			       nLinF+=13
			       oSay5 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE ,080,008)
			       oSay5:cCaption:= cOBS4     
			       nLinF+=13
			       oSay6 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE ,080,008)
			       oSay6:cCaption:= cOBS5     
			       nLinF+=13
			       oSay7 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE ,080,008)
			       oSay7:cCaption:= cOBS6     
			       nLinF+=13
			       oSay8 := TSay():New( nLinF,215,,oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE ,080,008)
			       oSay8:cCaption:= cOBS7     
			       
		       ENDIF
		    Endif

		    If SUBSTR(aCampos2[_x][3],1,1)='E' // ESTRUTURA
		       // item 
		       oSay1 := TSay():New( nLinE,315,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][3]!=z60ITEM,CLR_BLACK,CLR_HRED ),CLR_WHITE,100,008)
		       cProdEst:=substr(aCampos2[_x][10],1,AT('-',aCampos2[_x][10])-1)
		       oSay1:cCaption:=cProdEst+'-'+Posicione("SB1",1,xFilial("SB1")+cProdEst, "B1_DESC")
		       // valor
		       oSay2 := TSay():New( nLinE,420,,oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[_x][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
		       oSay2:cCaption:= aCampos2[_x][4]     		       
		       nLinE+=10 
		       
		    Endif
		    
		next
			
			
			oSay1      := TSay():New( 217.5,10,{|| "Observação:"  },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
			oGetObs := TGet():New( 217,43,{|u| If(PCount()>0,cObs:=u,cObs)},oDlg1,235,10,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,.F.,.F.,,'cObs',,)
			
			oSBtn1     := SButton():New( 217  ,283,1, {||  corrige(@oGetObs,cObs,@oDlg1,cExtrusora,cProduto,z60ITEM)   },oDlg1,,"", )
			//oSBtn2     := SButton():New( 217.2,313,2, {|| Z60->Z60_PENDEN:="S" ,oDlg1:end()},oDlg1,,"", )
			oSBtn2     := SButton():New( 217.2,313,2, {|| oDlg1:end()},oDlg1,,"", )
			
			oDlg1:Activate(,,,.T.)
			
			
	//ENDIF   // PAR04 = 1
endif //endif do xfuncao != 3 -> corrigir

Return


***************

Static Function Usu( cSoli )

***************

local ccod:=''

PswOrder(2)
If PswSeek( cSoli, .T. )
	aUsuarios  := PSWRET()
	ccod       := Alltrim(aUsuarios[1][1])     	// usuário
Endif

return ccod

***************

Static Function Inconforme(pendente,parametro)

***************

if parametro ==1
	if pendente=="S"
		return CLR_HGRAY
	else
		return CLR_WHITE
	endif
else
	if xFuncao ==2
		return  pendente=='S' .or. !xFuncao==2
	else
		return  pendente=='S'
	endif
endif

RETURN



***************

Static Function Desabilita(obj,pendente)

***************

if xFuncao==2
	obj:disable()
endif
if pendente=="S"
	obj:disable()
	return
endif
return

***************

Static Function Grava(lParada, oObj,aObj)

***************

Local aVetor := {}
Local aMsg  :={}

Begin Transaction
If MV_PAR04 = 1  //MÁQUINA EM FUNCIONAMENTO

	IF Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05"    
		//AS OUTRAS EXTRUSORAS TEM CILINDROS, EXCETO A E04 / E05
		//AS OUTRAS EXTRUSORAS TEM FILTRO REVERSÍVEL, EXCETO A E04 / E05 
		//AS EXTRUSORAS E01, E02 , E03 não possuem HELICOIDAL
		//FR - 26/11/2012
	    //CHAMADO 00000231 - FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS 
    	IF Alltrim(MV_PAR01) = "E01"
    		//FR - 26/11/12 - CHAMADO: 00000231
    		//7 ZONAS
    		//TEM TEMP DE FILTRO
    		//4 MATRIZ
    		//NÃO TEM FLANGE
    		//NÃO TEM CALIBRADOR
    		//NÃO TEM HELICOIDAL
    		//TEM FILTRO REVERSÍVEL
    		//TEM CILINDRO
    		
    	
			aVetor:={;
			cZona1     ,;//  1
			cZona2     ,;//  2
			cZona3     ,;//  3
			cZona4     ,;//  4
			cZona5     ,;//  5
			cZona6     ,;//  6
			cZona7     ,;//  7
			cMatriz1   ,;//  8
			cMatriz2   ,;//  9
			cMatriz3   ,;// 10
			cMatriz4   ,;// 11
			cFiltro    ,;// 12
			cSlit      ,;// 13
			cCircAgua  ,;// 14
			cLinear    ,;// 15
			cGrama     ,;// 16
			cEspes     ,;// 17
			cAltura    ,;// 18
			cLargura   ,;// 19
			cAlinha    ,;// 20
			cCamera    ,;// 21	
			cSensor    ,;// 22
			cTratamento,;// 23
			cBobina    ,;// 24  
			cFilReve   ,;// 25  
			cFilAlim   ,;// 26  
			cCaroco    ,; //27
			cPlanic    ,; //28
			cKgH       ,; //29
			cCilindro }  //30
		    
			//cFlange    ,;// 13 //RETIRADO
			//cHelic     ,;// 15 //RETIRADO
		    //cCalib     ,;// 14 //RETIRADO
		
			aMsg := {;
			"Zona 1"               ,;//  1
			"Zona 2"               ,;//  2
			"Zona 3"               ,;//  3
			"Zona 4"               ,;//  4
			"Zona 5"               ,;//  5
			"Zona 6"               ,;//  6
			"Zona 7"               ,;//  7
			"Matriz 1"             ,;//  8
			"Matriz 2"             ,;//  9
			"Matriz 3"             ,;// 10
			"Matriz 4"             ,;// 11
			"Temperatura de Filtro",;// 12
			"Conformidade Slit"    ,;// 13
			"Circulação de Agua"   ,;// 14
			"Linear"               ,;// 15
			"Grama/Metro"          ,;// 16
			"Espessura"            ,;// 17
			"Altura"               ,;// 18
			"Largura"              ,;// 19
			"Alinhamento"          ,;// 20
			"Camera"               ,;// 21
			"Sensor Ponto de Neve" ,;// 22
			"Tratamento"           ,;// 23
			"Bobinadeira"         ,; // 24
			"filtro do reversivel" ,;// 25
			"filtro do alimentador",;// 26
			"caroco" ,;              // 27
			"planicidade" ,;          //28
			"Kg/h" ,;                 //29
			"Cilindro torre girat." } //30
			
			//"Flange"               ,;// 13 //RETIRADO
			//"Calibrador"           ,;// 14 //RETIRADO
			//"Helicoidal"           ,;// 15 //RETIRADO
			
		ELSEIF Alltrim(MV_PAR01) = "E02"
			//FR - 26/11/12 - CHAMADO: 00000231
			//5 ZONAS
			//NÃO TEM TEMP DE FILTRO
			//1 MATRIZ                     
			//TEM FLANGE
			//TEM CALIBRADOR
			//NÃO TEM HELICOIDAL
			//TEM FILTRO REVERSÍVEL
			//TEM CILINDRO
			
			aVetor:={;
			cZona1     ,;//  1
			cZona2     ,;//  2
			cZona3     ,;//  3
			cZona4     ,;//  4
			cZona5     ,;//  5
			cMatriz1   ,;//  6
			cFlange    ,;// 7
			cCalib     ,;// 8
			cSlit      ,;// 9
			cCircAgua  ,;// 10
			cLinear    ,;// 11
			cGrama     ,;// 12
			cEspes     ,;// 13
			cAltura    ,;// 14
			cLargura   ,;// 15
			cAlinha    ,;// 16
			cCamera    ,;// 17	
			cSensor    ,;// 18
			cTratamento,;// 19
			cBobina    ,;// 20  
			cFilReve   ,;// 21  
			cFilAlim   ,;// 22  
			cCaroco    ,; //23
			cPlanic    ,; //24
			cKgH       ,; //25
			cCilindro }  //26
		    
			//cZona6     ,;//  6 //RETIRADO
			//cZona7     ,;//  7 //RETIRADO
			//cFiltro    ,;// 12 //RETIRADO
			//cMatriz2   ,;//  9 //RETIRADO
			//cMatriz3   ,;// 10 //RETIRADO
			//cMatriz4   ,;// 11 //RETIRADO
			//cHelic     ,;// 15 //RETIRADO
		
		
			aMsg := {;
			"Zona 1"               ,;//  1
			"Zona 2"               ,;//  2
			"Zona 3"               ,;//  3
			"Zona 4"               ,;//  4
			"Zona 5"               ,;//  5
			"Matriz 1"             ,;//  6
			"Flange"               ,;// 7
			"Calibrador"           ,;// 8
			"Conformidade Slit"    ,;// 9
			"Circulação de Agua"   ,;// 10
			"Linear"               ,;// 11
			"Grama/Metro"          ,;// 12
			"Espessura"            ,;// 13
			"Altura"               ,;// 14
			"Largura"              ,;// 15
			"Alinhamento"          ,;// 16
			"Camera"               ,;// 17
			"Sensor Ponto de Neve" ,;// 18
			"Tratamento"           ,;// 19
			"Bobinadeira"         ,; // 20
			"filtro do reversivel" ,;// 21
			"filtro do alimentador",;// 22
			"caroco" ,;              // 23
			"planicidade" ,;          //24
			"Kg/h" ,;                 //25
			"Cilindro torre girat." } //26
			
			//"Zona 6"               ,;//  6 //RETIRADO
			//"Zona 7"               ,;//  7 //RETIRADO
			//"Temperatura de Filtro",;// 12 //RETIRADO
			//"Matriz 2"             ,;//  9 //RETIRADO
			//"Matriz 3"             ,;// 10 //RETIRADO
			//"Matriz 4"             ,;// 11 //RETIRADO
			//"Helicoidal"           ,;// 15 //RETIRADO
			
		ELSEIF Alltrim(MV_PAR01) = "E03"
			//FR - 26/11/12 - CHAMADO: 00000231
			//5 ZONAS 
			//TEM TEMP DE FILTRO
			//3 MATRIZ
			//NÃO TEM FLANGE
			//NÃO TEM CALIBRADOR            
			//NÃO TEM HELICOIDAL
			//TEM FILTRO REVERSÍVEL
			//TEM CILINDRO
			
			aVetor:={;
			cZona1     ,;//  1
			cZona2     ,;//  2
			cZona3     ,;//  3
			cZona4     ,;//  4
			cZona5     ,;//  5
			cMatriz1   ,;//  6
			cMatriz2   ,;//  7
			cMatriz3   ,;// 8
			cFiltro    ,;// 9
			cSlit      ,;// 10
			cCircAgua  ,;// 11
			cLinear    ,;// 12
			cGrama     ,;// 13
			cEspes     ,;// 14
			cAltura    ,;// 15
			cLargura   ,;// 16
			cAlinha    ,;// 17
			cCamera    ,;// 18	
			cSensor    ,;// 19
			cTratamento,;// 20
			cBobina    ,;// 21  
			cFilReve   ,;// 22  
			cFilAlim   ,;// 23  
			cCaroco    ,; //24
			cPlanic    ,; //25
			cKgH       ,; //26
			cCilindro }  //27
		
			//cZona6     ,;//  6  //RETIRADO
			//cZona7     ,;//  7  //RETIRADO
			//cMatriz4   ,;// 11  //RETIRADO
			//cFlange    ,;// 13  //RETIRADO
			//cCalib     ,;// 14  //RETIRADO
			//cHelic     ,;// 15  //RETIRADO
		
		
			aMsg := {;
			"Zona 1"               ,;//  1
			"Zona 2"               ,;//  2
			"Zona 3"               ,;//  3
			"Zona 4"               ,;//  4
			"Zona 5"               ,;//  5
			"Matriz 1"             ,;//  6
			"Matriz 2"             ,;//  7
			"Matriz 3"             ,;// 8
			"Temperatura de Filtro",;// 9
			"Conformidade Slit"    ,;// 10
			"Circulação de Agua"   ,;// 11
			"Linear"               ,;// 12
			"Grama/Metro"          ,;// 13
			"Espessura"            ,;// 14
			"Altura"               ,;// 15
			"Largura"              ,;// 16
			"Alinhamento"          ,;// 17
			"Camera"               ,;// 18
			"Sensor Ponto de Neve" ,;// 19
			"Tratamento"           ,;// 20
			"Bobinadeira"         ,; // 21
			"filtro do reversivel" ,;// 22
			"filtro do alimentador",;// 23
			"caroco" ,;              // 24
			"planicidade" ,;          //25
			"Kg/h" ,;                 //26
			"Cilindro torre girat." } //27
			
			//"Zona 6"               ,;//  6 //RETIRADO
			//"Zona 7"               ,;//  7 //RETIRADO
			//"Matriz 4"             ,;// 11 //RETIRADO
			//"Flange"               ,;// 13 //RETIRADO
			//"Calibrador"           ,;// 14 //RETIRADO
			//"Helicoidal"           ,;// 15 //RETIRADO
		
		ENDIF    //E01, E02, E03
		
    ELSE //EXTRUSORA E04 / E05 
	    //FR - 26/11/2012
	    //CHAMADO 00000231:
	    //FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
	    //não possuem cilindros
	    //NÃO POSSUI FILTRO REVERSÍVEL
	    //POSSUI HELICOIDAL
	    
	    //FR - 26/11/2012
	    //CHAMADO 00000231 - FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
    	IF Alltrim(MV_PAR01) = "E04"
    		//FR - 26/11/12 - CHAMADO: 00000231
    		//5 ZONAS
    		//NÃO TEM TEMP DE FILTRO  
    		//1 MATRIZ 
    		//NÃO TEM FLANGE
    		//NÃO TEM CALIBRADOR
    		//TEM HELICOIDAL
    		//NÃO TEM FILTRO REVERSÍVEL
    		//NÃO TEM CILINDRO
    		
	    	aVetor:={;
			cZona1     ,;//  1
			cZona2     ,;//  2
			cZona3     ,;//  3
			cZona4     ,;//  4
			cZona5     ,;//  5
			cMatriz1   ,;//  8
			cHelic     ,;// 15
			cSlit      ,;// 16
			cCircAgua  ,;// 17
			cLinear    ,;// 18
			cGrama     ,;// 19
			cEspes     ,;// 20
			cAltura    ,;// 21
			cLargura   ,;// 22
			cAlinha    ,;// 23
			cCamera    ,;// 24	
			cSensor    ,;// 25
			cTratamento,;// 26
			cBobina    ,;// 27  
			cFilAlim   ,;// 28
			cCaroco    ,; //29
			cPlanic    ,; //30
			cKgH       } //31
				
			//cZona6     ,;//6 //RETIRADO
			//cZona7     ,;//  7 //RETIRADO
			//cFiltro    ,;// 12 //RETIRADO
			//cMatriz2   ,;//  9 //RETIRADO
			//cMatriz3   ,;// 10 //RETIRADO
			//cMatriz4   ,;// 11 //RETIRADO
			//cFlange    ,;// 13 //RETIRADO
			//cCalib     ,;// 14 //RETIRADO
			
			aMsg := {;
			"Zona 1"               ,;//  1
			"Zona 2"               ,;//  2
			"Zona 3"               ,;//  3
			"Zona 4"               ,;//  4
			"Zona 5"               ,;//  5
			"Matriz 1"             ,;//  8
			"Helicoidal"           ,;// 15
			"Conformidade Slit"    ,;// 16
			"Circulação de Agua"   ,;// 17
			"Linear"               ,;// 18
			"Grama/Metro"          ,;// 19
			"Espessura"            ,;// 20
			"Altura"               ,;// 21
			"Largura"              ,;// 22
			"Alinhamento"          ,;// 23
			"Camera"               ,;// 24	
			"Sensor Ponto de Neve" ,;// 25
			"Tratamento"           ,;// 26
			"Bobinadeira"         ,; // 27		
			"filtro do alimentador",;// 28
			"caroco" ,;              // 29
			"planicidade" ,;          // 30
			"Kg/h" }                 // 31
			
			//"Zona 6"               ,;//  6 //RETIRADO
			//"Zona 7"               ,;//  7 //RETIRADO
	        //"Temperatura de Filtro",;// 12 //RETIRADO
	        //"Matriz 2"             ,;//  9 //RETIRADO
			//"Matriz 3"             ,;// 10 //RETIRADO
			//"Matriz 4"             ,;// 11 //RETIRADO
			//"Flange"               ,;// 13 //RETIRADO 
			//"Calibrador"           ,;// 14 //RETIRADO
			
	    ELSEIF ALLTRIM(MV_PAR01) = "E05" 
	    	//4 ZONAS
	    	//NÃO TEM TEMP DE FILTRO 
	    	//1 MATRIZ  
	    	//NÃO TEM FLANGE
	    	//NÃO TEM CALIBRADOR
	    	//TEM HELICOIDAL
	    	//NÃO TEM FILTRO REVERSÍVEL
	    	//NÃO TEM CILINDRO
	    	
	    	 
	    	aVetor:={;
			cZona1     ,;//  1
			cZona2     ,;//  2
			cZona3     ,;//  3
			cZona4     ,;//  4
			cMatriz1   ,;//  8
			cHelic     ,;// 15
			cSlit      ,;// 16
			cCircAgua  ,;// 17
			cLinear    ,;// 18
			cGrama     ,;// 19
			cEspes     ,;// 20
			cAltura    ,;// 21
			cLargura   ,;// 22
			cAlinha    ,;// 23
			cCamera    ,;// 24	
			cSensor    ,;// 25
			cTratamento,;// 26
			cBobina    ,;// 27  
			cFilAlim   ,;// 28
			cCaroco    ,; //29
			cPlanic    ,; //30
			cKgH       } //31
			
			//cZona5     ,;//  5 //RETIRADO
			//cZona6     ,;//  6 //RETIRADO
			//cZona7     ,;//  7 //RETIRADO  
			//cFiltro    ,;// 12 //RETIRADO
			//cMatriz2   ,;//  9 //RETIRADO
			//cMatriz3   ,;// 10 //RETIRADO
			//cMatriz4   ,;// 11 //RETIRADO
			//cFlange    ,;// 13 //RETIRADO
			//cCalib     ,;// 14 //RETIRADO	
			
			aMsg := {;
			"Zona 1"               ,;//  1
			"Zona 2"               ,;//  2
			"Zona 3"               ,;//  3
			"Zona 4"               ,;//  4
			"Matriz 1"             ,;//  8
			"Helicoidal"           ,;// 15
			"Conformidade Slit"    ,;// 16
			"Circulação de Agua"   ,;// 17
			"Linear"               ,;// 18
			"Grama/Metro"          ,;// 19
			"Espessura"            ,;// 20
			"Altura"               ,;// 21
			"Largura"              ,;// 22
			"Alinhamento"          ,;// 23
			"Camera"               ,;// 24	
			"Sensor Ponto de Neve" ,;// 25
			"Tratamento"           ,;// 26
			"Bobinadeira"         ,; // 27		
			"filtro do alimentador",;// 28
			"caroco" ,;              // 29
			"planicidade" ,;          // 30
			"Kg/h" }                 // 31
			
			//"Zona 5"               ,;//  5 //RETIRADO
			//"Zona 6"               ,;//  6 //RETIRADO
			//"Zona 7"               ,;//  7 //RETIRADO
	        //"Temperatura de Filtro",;// 12 //RETIRADO
	        //"Matriz 2"             ,;//  9 //RETIRADO
			//"Matriz 3"             ,;// 10 //RETIRADO
			//"Matriz 4"             ,;// 11 //RETIRADO 
			//"Flange"               ,;// 13 //RETIRADO
	        //"Calibrador"           ,;// 14 //RETIRADO
	        
	    ENDIF  //E04, E05
    ENDIF

//Else    //MÁQUINA PARADA / SETUP 
//	aVetor:={ cMaqParada, cOBSMAQ }//  2
//	aMsg:={ "Maquina Parada?", "OBS Maquina:"  }        
	
//Endif


	cVazio:=''
	cMsg:='FAVOR CONFIRMAR o Campo'
	
	for x:=1 to len(avetor)
	    if alltrim(aVetor[x]) == cVazio
	     alert (cMsg+" "+aMsg[x])
	     aObj[x]:SetFocus()
		 ObjectMethod( oObj, "Refresh()" )
		 return                          
		endif
	next  

	//tempo:=ddatabase
	tempo:=DATE()
	tempo:=dtos(tempo)
	tempo:=substr(tempo,1,8)
	

	
	IF Alltrim(MV_PAR01) != "E04" .and. Alltrim(MV_PAR01) != "E05" 
	//FR - 26/11/2012
    //CHAMADO 00000231:
    //FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS   
	//AS OUTRAS EXTRUSORAS (E01, E02, E03) TEM CILINDROS, EXCETO A E04 / E05
	//AS OUTRAS EXTRUSORAS (E01, E02, E03) TEM FILTRO REVERSÍVEL, EXCETO A E04 / E05
	//AS EXTRUSORAS E04 , E05 SOMENTE ESTAS POSSUEM HELICOIDAL
	
	//FR - 26/11/2012
    //CHAMADO 00000231 - FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
    
		IF PAR04 <> 1    //MÁQUINA PARADA OU SETUP
			IF Alltrim(MV_PAR01) = "E01"
				//7 ZONAS
				//TEM TEMP DE FILTRO
				//4 MATRIZ
				//NÃO TEM FLANGE
				//NÃO TEM CALIBRADOR
				//NÃO TEM HELICOIDAL
				//TEM FILTRO REVERSÍVEL
				//TEM CILINDRO
			
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; // 01	
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 
					{cFilReve   ,"F06",0  ,"FITRO DO REVERSIVEL"  },; // 05
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //06
					{cCilindro  ,"F08",0  ,"CILINDROS TORRE GIRAT."},; //07
					{cMaqParada ,"F09",0  ,"MAQUINA PARADA?"      },;  //08
					{cOBSMAQ    ,"F10",0  ,"OBS MAQUINA:"         },;  //09
					{cLinear    ,"G01",1  ,"LINEAR"               },; // 10
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 11
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 12
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 13
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 14
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 15
					{cCaroco    ,"G07",0  ,"CAROCO"               },; // 16 
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 17
					{cKgH       ,"G09",1  ,"KG/H"                 },; // 18
					{cZona1     ,"T01",1  ,"ZONA 1"               },; // 19
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 20
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 21
					{cZona2     ,"T04",1  ,"ZONA 2"               },; // 22
					{cZona3     ,"T05",1  ,"ZONA 3"               },; // 23
					{cZona4     ,"T06",1  ,"ZONA 4"               },; // 24
					{cZona5     ,"T07",1  ,"ZONA 5"               },; // 25
					{cZona6     ,"T08",1  ,"ZONA 6"               },; // 26
					{cZona7     ,"T09",1  ,"ZONA 7"               },; // 27
					{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 28
					{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 29
					{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 30
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 31
					{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       } } // 32
				
					
					//{cHelic     ,"T17",1  ,"HELICOIDAL"           };  // 35 15  //RETIRADO
					//{cFlange    ,"T15",1  ,"FLANGE"               },; // 33 13 //RETIRADO
					//{cCalib     ,"T16",1  ,"CALIBRADOR"           }; // 34 14	 //RETIRADO
					
			ELSEIF Alltrim(MV_PAR01) = "E02"
				//5 ZONAS
				//NÃO TEM TEMP DE FILTRO
				//1 MATRIZ
				//TEM FLANGE
				//TEM CALIBRADOR
				//NÃO TEM HELICOIDAL
				//TEM FILTRO REVERSÍVEL
				//TEM CILINDRO
				
				
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; // 01	
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 
					{cFilReve   ,"F06",0  ,"FITRO DO REVERSIVEL"  },; // 05
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //06
					{cCilindro  ,"F08",0  ,"CILINDROS TORRE GIRAT."},; //07
					{cMaqParada ,"F09",0  ,"MAQUINA PARADA?"      },;  //08
					{cOBSMAQ    ,"F10",0  ,"OBS MAQUINA:"         },;  //09
					{cLinear    ,"G01",1  ,"LINEAR"               },; // 10
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 11
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 12
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 13
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 14
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 15
					{cCaroco    ,"G07",0  ,"CAROCO"               },; // 16 
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 17
					{cKgH       ,"G09",1  ,"KG/H"                 },; // 18
					{cZona1     ,"T01",1  ,"ZONA 1"               },; // 19
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 20
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 21
					{cZona2     ,"T04",1  ,"ZONA 2"               },; // 22
					{cZona3     ,"T05",1  ,"ZONA 3"               },; // 23
					{cZona4     ,"T06",1  ,"ZONA 4"               },; // 24
					{cZona5     ,"T07",1  ,"ZONA 5"               },; // 25
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 26
					{cFlange    ,"T15",1  ,"FLANGE"               },; // 27
					{cCalib     ,"T16",1  ,"CALIBRADOR"           }} // 28					
				
					
					//{cHelic     ,"T17",1  ,"HELICOIDAL"           };  // 35 15  //RETIRADO	
					//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 26 06  //RETIRADO
					//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 27 07  //RETIRADO
			        //{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 32 12  //RETIRADO
			        //{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 28 09  //RETIRADO
					//{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 29 10  //RETIRADO
					//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 30 11  //RETIRADO
					
			ELSEIF Alltrim(MV_PAR01) = "E03"
				//5 ZONAS
				//NÃO TEM TEMP DE FILTRO 
				//3 MATRIZ
				//NÃO TEM FLANGE 
				//NÃO TEM CALIBRADOR
				//NÃO TEM HELICOIDAL
				//TEM FILTRO REVERSÍVEL
				//TEM CILINDRO
				
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; // 01	
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 
					{cFilReve   ,"F06",0  ,"FITRO DO REVERSIVEL"  },; // 05
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //06
					{cCilindro  ,"F08",0  ,"CILINDROS TORRE GIRAT."},; //07
					{cMaqParada ,"F09",0  ,"MAQUINA PARADA?"      },;  //08
					{cOBSMAQ    ,"F10",0  ,"OBS MAQUINA:"         },;  //09
					{cLinear    ,"G01",1  ,"LINEAR"               },; // 10
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 11
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 12
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 13
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 14
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 15
					{cCaroco    ,"G07",0  ,"CAROCO"               },; // 16 
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 17
					{cKgH       ,"G09",1  ,"KG/H"                 },; // 18
					{cZona1     ,"T01",1  ,"ZONA 1"               },; // 19
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 20
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 21
					{cZona2     ,"T04",1  ,"ZONA 2"               },; // 22
					{cZona3     ,"T05",1  ,"ZONA 3"               },; // 23
					{cZona4     ,"T06",1  ,"ZONA 4"               },; // 24
					{cZona5     ,"T07",1  ,"ZONA 5"               },; // 25
					{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 26
					{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 27
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   } } // 28

					
					//{cHelic     ,"T17",1  ,"HELICOIDAL"           };  // 35 15  //RETIRADO 
					//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 26 06 //RETIRADO
					//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 27 07 //RETIRADO
					//{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 32 12 //RETIRADO
					//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 30 11 //RETIRADO
					//{cFlange    ,"T15",1  ,"FLANGE"               },; // 33 13 //RETIRADO
					//{cCalib     ,"T16",1  ,"CALIBRADOR"           }; // 34 14  //RETIRADO
			
			ENDIF   //DIFERENTE DE E04, E05
			
		ELSE //MÁQUINA EM FUNCIONAMENTO
			IF Alltrim(MV_PAR01) = "E01"
				//7 ZONAS
				//TEM TEMP DE FILTRO
				//4 MATRIZ
				//NÃO TEM FLANGE
				//NÃO TEM CALIBRADOR
				//NÃO TEM HELICOIDAL
				//TEM FILTRO REVERSÍVEL
				//TEM CILINDRO
			
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; // 01	
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 
					{cFilReve   ,"F06",0  ,"FITRO DO REVERSIVEL"  },; // 05
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //06
					{cCilindro  ,"F08",0  ,"CILINDROS TORRE GIRAT."},;  //07 
					{cLinear    ,"G01",1  ,"LINEAR"               },; // 8
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 9
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 10
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 11
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 12
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 13
					{cCaroco    ,"G07",0  ,"CAROCO"               },; // 14 
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 15
					{cKgH       ,"G09",1  ,"KG/H"                 },; // 16
					{cZona1     ,"T01",1  ,"ZONA 1"               },; // 17
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 18
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 19
					{cZona2     ,"T04",1  ,"ZONA 2"               },; // 20
					{cZona3     ,"T05",1  ,"ZONA 3"               },; // 21
					{cZona4     ,"T06",1  ,"ZONA 4"               },; // 22
					{cZona5     ,"T07",1  ,"ZONA 5"               },; // 23
					{cZona6     ,"T08",1  ,"ZONA 6"               },; // 24
					{cZona7     ,"T09",1  ,"ZONA 7"               },; // 25
					{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 26
					{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 27
					{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 28
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 29
					{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       }} // 30

					
					//{cHelic     ,"T17",1  ,"HELICOIDAL"           };  // 35 15  //RETIRADO
					//{cFlange    ,"T15",1  ,"FLANGE"               },; // 33 13 //RETIRADO
					//{cCalib     ,"T16",1  ,"CALIBRADOR"           }; // 34 14	 //RETIRADO
					
			ELSEIF Alltrim(MV_PAR01) = "E02"
				//5 ZONAS
				//NÃO TEM TEMP DE FILTRO
				//1 MATRIZ
				//TEM FLANGE
				//TEM CALIBRADOR
				//NÃO TEM HELICOIDAL
				//TEM FILTRO REVERSÍVEL
				//TEM CILINDRO
				
				
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; // 01	
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 
					{cFilReve   ,"F06",0  ,"FITRO DO REVERSIVEL"  },; // 05
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //06
					{cCilindro  ,"F08",0  ,"CILINDROS TORRE GIRAT."},; //07
					{cLinear    ,"G01",1  ,"LINEAR"               },; // 08
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 09
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 10
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 11
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 12
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 13
					{cCaroco    ,"G07",0  ,"CAROCO"               },; // 14
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 15
					{cKgH       ,"G09",1  ,"KG/H"                 },; // 16
					{cZona1     ,"T01",1  ,"ZONA 1"               },; // 17
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 18
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 19
					{cZona2     ,"T04",1  ,"ZONA 2"               },; // 20
					{cZona3     ,"T05",1  ,"ZONA 3"               },; // 21
					{cZona4     ,"T06",1  ,"ZONA 4"               },; // 22
					{cZona5     ,"T07",1  ,"ZONA 5"               },; // 23
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 24
					{cFlange    ,"T15",1  ,"FLANGE"               },; // 25
					{cCalib     ,"T16",1  ,"CALIBRADOR"           } } // 26					

					
					//{cHelic     ,"T17",1  ,"HELICOIDAL"           };  // 35 15  //RETIRADO	
					//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 26 06  //RETIRADO
					//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 27 07  //RETIRADO
			        //{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 32 12  //RETIRADO
			        //{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 28 09  //RETIRADO
					//{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 29 10  //RETIRADO
					//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 30 11  //RETIRADO
					
			ELSEIF Alltrim(MV_PAR01) = "E03"
				//5 ZONAS
				//NÃO TEM TEMP DE FILTRO 
				//3 MATRIZ
				//NÃO TEM FLANGE 
				//NÃO TEM CALIBRADOR
				//NÃO TEM HELICOIDAL
				//TEM FILTRO REVERSÍVEL
				//TEM CILINDRO
				
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; // 01	
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 
					{cFilReve   ,"F06",0  ,"FITRO DO REVERSIVEL"  },; // 05
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //06
					{cCilindro  ,"F08",0  ,"CILINDROS TORRE GIRAT."},; //07
					{cLinear    ,"G01",1  ,"LINEAR"               },; // 08
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 09
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 10
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 11
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 12
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 13
					{cCaroco    ,"G07",0  ,"CAROCO"               },; // 14 
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 15
					{cKgH       ,"G09",1  ,"KG/H"                 },; // 16
					{cZona1     ,"T01",1  ,"ZONA 1"               },; // 17
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 18
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 19
					{cZona2     ,"T04",1  ,"ZONA 2"               },; // 20
					{cZona3     ,"T05",1  ,"ZONA 3"               },; // 21
					{cZona4     ,"T06",1  ,"ZONA 4"               },; // 22
					{cZona5     ,"T07",1  ,"ZONA 5"               },; // 23
					{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 24
					{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 25
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 26
					{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       }} // 27

					
					//{cHelic     ,"T17",1  ,"HELICOIDAL"           };  // 35 15  //RETIRADO 
					//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 26 06 //RETIRADO
					//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 27 07 //RETIRADO
					//{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 32 12 //RETIRADO
					//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 30 11 //RETIRADO
					//{cFlange    ,"T15",1  ,"FLANGE"               },; // 33 13 //RETIRADO
					//{cCalib     ,"T16",1  ,"CALIBRADOR"           }; // 34 14  //RETIRADO
			
			ENDIF   //DIFERENTE DE E04, E05
			
		ENDIF //MÁQ FUNCIONANDO ?
			
	ELSE  //extrusora = E04 ou E05
	
	//FR - 26/11/2012
    //CHAMADO 00000231:
    //FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS   
	//AS OUTRAS EXTRUSORAS (E01, E02, E03) TEM CILINDROS, EXCETO A E04 / E05
	//AS OUTRAS EXTRUSORAS (E01, E02, E03) TEM FILTRO REVERSÍVEL, EXCETO A E04 / E05
	//AS EXTRUSORAS E04 , E05, SOMENTE ESTAS POSSUEM HELICOIDAL
	
			
		IF PAR04 <> 1  //MÁQUINA PARADA OU SETUP 
		
			IF Alltrim(MV_PAR01) = "E04"  
			
				//FR - 26/11/2012
    			//CHAMADO 00000231:                                  
				//5 ZONAS
				//NÃO TEM TEMP DE FILTRO
				//1 MATRIZ
				//NÃO TEM FLANGE
				//NÃO TEM CALIBRADOR 
				//TEM HELICOIDAL
				//NÃO TEM FILTRO REVERSÍVEL
				//NÃO TEM CILINDRO
				
				aValores:={;
				{cCamera    ,"F01",0  ,"CAMERA"               },; // 01				
				{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
				{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
				{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 			
				{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //05		
				{cMaqParada ,"F09",0  ,"MAQUINA PARADA?"      },;  //06
				{cOBSMAQ    ,"F10",0  ,"OBS MAQUINA:"         },;  //07
				{cLinear    ,"G01",1  ,"LINEAR"               },; // 08
				{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 09
				{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 10
				{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 11
				{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 12
				{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 13
				{cCaroco    ,"G07",0  ,"CAROCO"               },; // 14
				{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 15
				{cKgH       ,"G09",1  ,"KG/H"                 },; // 16
				{cZona1     ,"T01",1  ,"ZONA 1"               },; // 17
				{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 18
				{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 19
				{cZona2     ,"T04",1  ,"ZONA 2"               },; // 20
				{cZona3     ,"T05",1  ,"ZONA 3"               },; // 21
				{cZona4     ,"T06",1  ,"ZONA 4"               },; // 22
				{cZona5     ,"T07",1  ,"ZONA 5"               },; // 23
				{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 24
				{cHelic     ,"T17",1  ,"HELICOIDAL"           } }  //25
				
				//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 24 06 //RETIRADO
				//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 25 07 //RETIRADO
				//{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 30 12 //RETIRADO
				//{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 26 09 //RETIRADO
				//{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 27 10 //RETIRADO
				//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 28 11 //RETIRADO
				//{cFlange    ,"T15",1  ,"FLANGE"               },; // 31 13 //RETIRADO
				//{cCalib     ,"T16",1  ,"CALIBRADOR"           },; // 32 14 //RETIRADO
			
			ELSEIF Alltrim(MV_PAR01) = "E05"
				//FR - 26/11/2012
    			//CHAMADO 00000231:   
				//4 ZONAS  
				//NÃO TEM TEMP DE FILTRO
				//1 MATRIZ
				//NÃO TEM FLANGE 
				//NÃO TEM CALIBRADOR  
				//TEM HELICOIDAL
				//NÃO TEM FILTRO REVERSÍVEL
				//NÃO TEM CILINDRO
				
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; //01				
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; //02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; //03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; //04 			
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },; //05		
					{cMaqParada ,"F09",0  ,"MAQUINA PARADA?"      },; //06
					{cOBSMAQ    ,"F10",0  ,"OBS MAQUINA:"         },; //07
					{cLinear    ,"G01",1  ,"LINEAR"               },; //08
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; //09
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; //10
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; //11
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; //12
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; //13
					{cCaroco    ,"G07",0  ,"CAROCO"               },; //14
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; //15
					{cKgH       ,"G09",1  ,"KG/H"                 },; //16
					{cZona1     ,"T01",1  ,"ZONA 1"               },; //17
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; //18
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; //19
					{cZona2     ,"T04",1  ,"ZONA 2"               },; //20
					{cZona3     ,"T05",1  ,"ZONA 3"               },; //21
					{cZona4     ,"T06",1  ,"ZONA 4"               },; //22
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; //23
					{cHelic     ,"T17",1  ,"HELICOIDAL"           } } //24
					
					//{cZona5     ,"T07",1  ,"ZONA 5"               },; // 23 05 //RETIRADO
					//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 24 06 //RETIRADO
					//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 25 07 //RETIRADO
					//{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 30 12 //RETIRADO
					//	{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 26 09 //RETIRADO
					//{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 27 10   //RETIRADO
					//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 28 11   //RETIRADO
					//{cFlange    ,"T15",1  ,"FLANGE"               },; // 31 13 //RETIRADO
					//{cCalib     ,"T16",1  ,"CALIBRADOR"           },; // 32 14 //RETIRADO
					
			ENDIF  //EXT É = E04 , E05
			
	    ELSE   //MÁQ. FUNCIONANDO
	    
	    //FR - 26/11/2012
        //CHAMADO 00000231 - FOI RETIRADO O ITEM GELADEIRA DE TODAS AS EXTRUSORAS
        	IF Alltrim(MV_PAR01) = "E04"  
			
				//FR - 26/11/2012
    			//CHAMADO 00000231:                                  
				//5 ZONAS
				//NÃO TEM TEMP DE FILTRO
				//1 MATRIZ
				//NÃO TEM FLANGE
				//NÃO TEM CALIBRADOR 
				//TEM HELICOIDAL
				//NÃO TEM FILTRO REVERSÍVEL
				//NÃO TEM CILINDRO
				
				aValores:={;
				{cCamera    ,"F01",0  ,"CAMERA"               },; // 01				
				{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
				{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
				{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 			
				{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },; // 05		
				{cLinear    ,"G01",1  ,"LINEAR"               },; // 06
				{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 07
				{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 08
				{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 09
				{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 10
				{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 11
				{cCaroco    ,"G07",0  ,"CAROCO"               },; // 12
				{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 13
				{cKgH       ,"G09",1  ,"KG/H"                 },; // 14
				{cZona1     ,"T01",1  ,"ZONA 1"               },; // 15
				{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 16
				{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 17
				{cZona2     ,"T04",1  ,"ZONA 2"               },; // 18
				{cZona3     ,"T05",1  ,"ZONA 3"               },; // 19
				{cZona4     ,"T06",1  ,"ZONA 4"               },; // 20
				{cZona5     ,"T07",1  ,"ZONA 5"               },; // 21
				{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 22
				{cHelic     ,"T17",1  ,"HELICOIDAL"           } }  //23
				
				//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 24 06 //RETIRADO
				//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 25 07 //RETIRADO
				//{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 30 12 //RETIRADO
				//{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 26 09 //RETIRADO
				//{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 27 10 //RETIRADO
				//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 28 11 //RETIRADO
				//{cFlange    ,"T15",1  ,"FLANGE"               },; // 31 13 //RETIRADO
				//{cCalib     ,"T16",1  ,"CALIBRADOR"           },; // 32 14 //RETIRADO
			
			ELSEIF Alltrim(MV_PAR01) = "E05"
				//FR - 26/11/2012
    			//CHAMADO 00000231:   
				//4 ZONAS  
				//NÃO TEM TEMP DE FILTRO
				//1 MATRIZ
				//NÃO TEM FLANGE 
				//NÃO TEM CALIBRADOR  
				//TEM HELICOIDAL
				//NÃO TEM FILTRO REVERSÍVEL
				//NÃO TEM CILINDRO
				
				aValores:={;
					{cCamera    ,"F01",0  ,"CAMERA"               },; // 01				
					{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 02
					{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 03
					{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 04 			
					{cFilAlim   ,"F07",0  ,"FITRO DO ALIMENTADOR" },;  //05		
					{cLinear    ,"G01",1  ,"LINEAR"               },; // 06
					{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 07
					{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 08
					{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 09
					{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 10
					{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 11
					{cCaroco    ,"G07",0  ,"CAROCO"               },; // 12
					{cPlanic    ,"G08",0  ,"PLANICIDADE"          },; // 13
					{cKgH       ,"G09",1  ,"KG/H"                 },; // 14
					{cZona1     ,"T01",1  ,"ZONA 1"               },; // 15
					{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 16
					{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 17
					{cZona2     ,"T04",1  ,"ZONA 2"               },; // 18
					{cZona3     ,"T05",1  ,"ZONA 3"               },; // 19
					{cZona4     ,"T06",1  ,"ZONA 4"               },; // 20
					{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 21
					{cHelic     ,"T17",1  ,"HELICOIDAL"           } } //22
					
					//{cZona5     ,"T07",1  ,"ZONA 5"               },; // 23 05 //RETIRADO
					//{cZona6     ,"T08",1  ,"ZONA 6"               },; // 24 06 //RETIRADO
					//{cZona7     ,"T09",1  ,"ZONA 7"               },; // 25 07 //RETIRADO
					//{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 30 12 //RETIRADO
					//	{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 26 09 //RETIRADO
					//{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 27 10   //RETIRADO
					//{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 28 11   //RETIRADO
					//{cFlange    ,"T15",1  ,"FLANGE"               },; // 31 13 //RETIRADO
					//{cCalib     ,"T16",1  ,"CALIBRADOR"           },; // 32 14 //RETIRADO
					
			ENDIF  //EXT É = E04 , E05
			
	    ENDIF      //MAQ. PARADA
		    
	ENDIF  //EXTRUSORA E04 ou E05
		  
	nPenden:=0   
	cDetalhe:=""
                       		
	// se o vetor de campos tiver menor que o vetor de valores de inspecao entao e necessario alterar o cadastro para o sistema incluir os novos campos
	//voltar
	IF PAR04 = 1  //só compara se estiver em funcionamento
		If len(aCampos1) < len(aValores)       //aValores foi alimentado na tela
		   alert('E Necessario Atualizar o Cadastro Do Produto '+alltrim(upper(MV_PAR02))+' na Extrusora '+alltrim(upper(MV_PAR01)) +' Para Continuar a Inspeção.' )
		   oDlg1:end()
		   Return
		Endif 
	ENDIF
	
ENDIF //PAR04 = 1

IF PAR04 = 1
	FOR nCont:=1 to len(aCampos1)
		//relaciono com o item pra ter a certeza que estou retorno o valor da variavel daquele item. Faço isso pq aumentou o numero de registro de 28 para 32 e isso mexeu na ordem 
		
		nRegI := ASCAN(aValores, {|x| alltrim(x[2]) == alltrim(aCampos1[nCont][2]) })  
		
		If nRegI < 0  
		  alert('O Item '+alltrim(aCampos1[nCont][4])+' Nao se encontra na Inspecao, favor contactar o setor de T.I.' )
	      oDlg1:end()	      
		Endif
		
		cExtrus :=upper(MV_PAR01)
		cProdut :=upper(MV_PAR02)
		cItem   :=aValores[nRegI][2]
		cItemD  :=aValores[nRegI][4]
		nValor1 :=aValores[nRegI][1]
		//nValor2 :=""
		nValor2 :=aCampos1[nCont][4]
		nProgra :=aCampos1[nCont][3]
		if aValores[nRegI][3]==1	
				
				cPendente:=iif( ;
				transform(val(strtran(alltrim(aValores[nRegI][1]),',','.')),"@R 999,999.9")  >=;
				transform(val(strtran(alltrim(aCampos1[nCont][3]),',','.')),"@R 999,999.9");
				.and.;
				transform(val(strtran(alltrim(aValores[nRegI][1]),',','.')),"@R 999,999.9")  <=;
				transform(val(strtran(alltrim(aCampos1[nCont][4]),',','.')),"@R 999,999.9");
				,"N","S")		
			
		       If  alltrim(cItem)='G01' // LINEAR AGORA E VALIDADO PELA ESTRUTURA DO PRODUTO 
		           cPendente:='N'  // AQUI NAO GERA PENDENCIA 
		       ENDIF
		else  
		 cPendente:=iif( upper(alltrim(aValores[nRegI][1]))== upper(alltrim(aCampos1[nCont][3])),"N","S")
		endif
		cQry := " "
		cQry += " select  Z60_EXTRUS EXT ,Z60_PRODUT PROD ,Z60_ITEM ITEM ,Z60_PENDEN PENDEN "    + chr(10)
		cQry += " FROM "+ RetSqlName( "Z60" ) +" Z60 "   + chr(10)
		cQry += " WHERE D_E_L_E_T_ =''"                  + chr(10)
		cQry += " AND Z60_PRODUT   = "+valtosql(cPRODUT) + chr(10)
		cQry += " AND Z60_EXTRUS   = "+valtosql(cEXTRUS) + chr(10)
		cQry += " AND Z60_ITEM     = "+valtosql(cItem)   + chr(10)
	   	cQry += " AND Z60_PENDEN   = 'S' "               + chr(10)
	   	cQry += " AND Z60_INICIO   = '*' "               + chr(10)
	   	cQry+=" order by Z60_ITEM"                         + chr(10)
		MemoWrite("C:\TEMP\SEL_GRAVA.SQL", cQry )
		TCQUERY cQry NEW ALIAS 'AUX3'
		
	   if (cPendente == 'S') .and. AUX3->(EOF())
			cInicio:='*'
		else
			cInicio:=''
		endif
	  	
		AUX3->(DBCLOSEAREA())
		
		
		RecLock('Z60',.T.)
		Z60->Z60_FILIAL:= xFilial("Z60")
		Z60->Z60_CODIGO:= cCod
		Z60->Z60_EXTRUS:= cExtrus
		Z60->Z60_PRODUT:= cProdut
		Z60->Z60_ITEM  := cItem
		Z60->Z60_ITEMD := cItemD
		Z60->Z60_VALOR := nValor1
		Z60->Z60_VALOR2:= nValor2
		Z60->Z60_PROGRA:= nProgra
		Z60->Z60_PENDEN:= cPendente
		
		Z60->Z60_INICIO:= cInicio
		Z60->Z60_DATAI := stod(tempo)
		Z60->Z60_HORAI := hora
		Z60->Z60_SUPERI:= cCodSup
		
		Z60->Z60_OPERA:= cOperador
		Z60->Z60_STAOBS := cOBSMAQ    
		// NOVO 
		Z60->Z60_OPEMAQ := iif(MV_PAR07=1,'SIM','NÃO')
		If MV_PAR07=2 // Ruim 
		   Z60->Z60_MOTIVO := iif(MV_PAR08=1,'FURO DE BALAO',iif(MV_PAR08=2,'HOMOGENIZACAO',iif(MV_PAR08=3,'FALTA DE PRODUTO',iif(MV_PAR08=4,'MATERIAL MOLHADO',iif(MV_PAR08=5,'INSTABILIDADE DO BALAO','')))))
		   Z60->Z60_OBSOPE := MV_PAR09
		endIf
		// 
		if cPendente == 'S'
			nPenden++ 
			
			if aValores[nRegI][3]==1    	
			   cProg:= "De: ( "+alltrim(aCampos1[nCont][3])+" ) Ate: ( "+alltrim(aCampos1[nCont][4])+" )"
			else  
			   cProg:=iif(substr(nValor1,1,1)=='S','NAO','SIM')
			endif
			
			 cDetalhe+="<tr><td>"+cItemD+"</td> <td>"+nValor1+"</td>  <td>"+cProg+"</td></tr>" 
		endif
		
		Z60->(MsUnlock())
	
	next nCont

    gravaEst()

    oObj:end() 
    CONFIRMSX8()
    
ELSE // MÁQUINA PARADA OU EM SETUP
	lParou := .F.
	If MsgYesNo("Deseja Confirmar Máquina Parada / Setup ? ")
    	lParou := .T.		
		cCod:=GetSx8Num( 'Z60', "Z60_CODIGO" )
		cExtrus :=upper(MV_PAR01)
		cProdut :=upper(MV_PAR02)
		cItem   := "F09" //aValores[nCont][2]
		cItemD  := "MAQUINA PARADA?" //aValores[nCont][4]
		nValor1 := "SIM" //aValores[nCont][1]
	
		nValor2 := ""  //aCampos1[nCont][4]
		nProgra := "NAO" //aCampos1[nCont][3]
		
		cPendente := "S"
		
	   if (cPendente == 'S') //.and. AUX3->(EOF())
			cInicio:='*'
	   else
			cInicio:=''
	   endif
		  	
		//AUX3->(DBCLOSEAREA())
		tempo:=DATE()
		tempo:=dtos(tempo)
		tempo:=substr(tempo,1,8)
		
		RecLock('Z60',.T.)
		Z60->Z60_FILIAL:= xFilial("Z60")
		Z60->Z60_CODIGO:= cCod
		Z60->Z60_EXTRUS:= cExtrus
		Z60->Z60_PRODUT:= cProdut
		Z60->Z60_ITEM  := cItem
		Z60->Z60_ITEMD := cItemD
		Z60->Z60_VALOR := nValor1
		Z60->Z60_VALOR2:= nValor2
		Z60->Z60_PROGRA:= nProgra
		Z60->Z60_PENDEN:= cPendente
			
		Z60->Z60_INICIO:= cInicio
		Z60->Z60_DATAI := stod(tempo)
		Z60->Z60_HORAI := hora
		Z60->Z60_SUPERI:= cCodSup
			
		Z60->Z60_OPERA:= cOperador
		Z60->Z60_STAOBS := cOBSMAQ
		// NOVO 
		Z60->Z60_OPEMAQ := iif(MV_PAR07=1,'SIM','NÃO')
		If MV_PAR07=2 // Ruim 
		   Z60->Z60_MOTIVO := iif(MV_PAR08=1,'FURO DE BALAO',iif(MV_PAR08=2,'HOMOGENIZACAO',iif(MV_PAR08=3,'FALTA DE PRODUTO',iif(MV_PAR08=4,'MATERIAL MOLHADO',iif(MV_PAR08=5,'INSTABILIDADE DO BALAO','')))))
		   Z60->Z60_OBSOPE := MV_PAR09
		endIf
		// 
		if cPendente == 'S'
			//nPenden++ 
			cDetalhe+="<tr><td>"+cOBSMAQ+"</td></tr>" 
		endif
			
		Z60->(MsUnlock())
	   //ENDIF  //SE O ITEM FOR F09 - MÁQUINA PARADA?
	    
		CONFIRMSX8()
	Else
		MsgInfo("Parada / Setup -> NÃO CONFIRMADO!")
		oDlg1:End()
	Endif   //If msgYesno
	
ENDIF 

	
              

if PAR04 = 1  // SE A MAQUINA ESTÁ EM FUNCIONAMENTO
	if nPenden>=1
		cInicio:=" "
		cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' 
		cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> ' 
		cInicio+='<head> '                                                                     
		cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> ' 
		cInicio+='<title>Untitled Document</title> '                                           
		cInicio+='</head> '                                                                    
		cInicio+='<body> '                                                                     
		cInicio+='<center>'                                                                    
	 
		cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> ' 
		cInicio+=' <br>'                                    
	 
		cInicio+='<h4>Na inspeçao abaixo fo'+iif(nPenden>1,'ram','i')+' encontrad'+iif(nPenden>1,'as','a')+' divergenci'+iif(nPenden>1,'as','a')+' </h4>'                 
		cInicio+='<table width="100%" border="1"  align="center"  >' 
		cInicio+="<tr><td bgcolor='green'><font color='white'><b> Codigo </b></font></td> <td bgcolor='green'><font color='white'><b> Maquina </b></font></td>  <td bgcolor='green'><font color='white'><b> Produto</b></font></td> </tr>"      
	    cInicio+="<tr><td>"+cCod+"</td> <td>"+cExtrus+"</td> <td>"+cProdut+"</td></tr>"  
	    cInicio+='</table>'                                                                
	    cInicio+='<br>Segue abaixo os detalhes:<br>'
	 
		cInicio+='<table width="100%" border="1"    align="center"  >' 
		cInicio+="<tr> "
		cInicio+=" <td bgcolor='green'><font color='white'><b> Item     <b></font></td> "
		cInicio+=" <td bgcolor='green'><font color='white'><b> Inspeção <b></font></td> "
		cInicio+=" <td bgcolor='green'><font color='white'><b> Padrão   <b></font></td> "
		cInicio+="</tr>"                                  
		cInicio+=cDetalhe    
	    cInicio+='</table>'  
	    cInicio+='</center>' 
	    cInicio+="<tr>Extrusor, Uso do recliclado 3º de Acordo com OP? <td>"+iif(MV_PAR07=1,'SIM','NÃO')+"</td></tr></h4> "  
	    
	    If MV_PAR07=2 // Ruim 
		   cInicio+=" Motivo: "+iif(MV_PAR08=1,'FURO DE BALAO',iif(MV_PAR08=2,'HOMOGENIZACAO',iif(MV_PAR08=3,'FALTA DE PRODUTO',iif(MV_PAR08=4,'MATERIAL MOLHADO',iif(MV_PAR08=5,'INSTABILIDADE DO BALAO','')))))+"</td></tr></h4> "  
		   cInicio+=" OBS da Condicao Ruim da Maquina: <td> "+MV_PAR09+"</td></tr></h4> "     
		endIf
		
	    cInicio+='</body>'   
	    cInicio+='</html>'    
	    
        
	    cEmail:="marcelo@ravaembalagens.com.br"
	    cEmail+=";giancarlo.sousa@ravaembalagens.com.br"
	    cEmail+=";valdir.silva@ravaembalagens.com.br"
     
	 //      cEmail:="antonio@ravaembalagens.com.br"
	     
	     
	   	     
	    //cEmail:= ""                             //retirar
		//cEmail:="romildo@ravaembalagens.com.br" //retirar
	     
	   
        ALERT(cDetalhe)
        if MsgBox( OemToAnsi( "confirma as divergencias??" ), "Escolha", "YESNO" )       	    

	    else
	       DisarmTransaction()
		   Return
	    endif 
	    // voltar 
	    cAssunto := 'Divergencia'+iif(nPenden>1,'s','')+' Check-List extrusora'
	    U_SendMailSC(cEmail ,"" , cAssunto, cInicio,"" )
	    //ACSendMail(,,,,cEmail,cAssunto,cInicio,)
	
	endif 

Else
	If lParou
		if cPendente = "S"
		
			cInicio:=" "
			cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' 
			cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> ' 
			cInicio+='<head> '                                                                     
			cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> ' 
			cInicio+='<title>Untitled Document</title> '                                           
			cInicio+='</head> '                                                                    
			cInicio+='<body> '                                                                     
			cInicio+='<center>'                                                                    
		 
			cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> ' 
			cInicio+=' <br>'                                    
		 
			cInicio+='<h4>A Maquina abaixo encontra-se : ' + IIF(PAR04 = 2, 'Parada' , 'Setup' ) + ' </h4>'                 
			cInicio+='<table width="100%" border="1"  align="center"  >' 
			cInicio+="<tr><td bgcolor='green'><font color='white'><b> Codigo </b></font></td> <td bgcolor='green'><font color='white'><b> Maquina </b></font></td>  <td bgcolor='green'><font color='white'><b> Produto</b></font></td> </tr>"      
		    cInicio+="<tr><td>"+cCod+"</td> <td>"+cExtrus+"</td>  <td>"+cProdut+"</td> </tr>"  
		    cInicio+='</table>'                                                                
		    cInicio+='<br>Segue abaixo os detalhes.<br>'
		 
			cInicio+='<table width="100%" border="1"    align="center"  >' 
			cInicio+="<tr> "
			cInicio+=" <td bgcolor='green'><font color='white'><b>Observação<b></font></td> "
			//cInicio+=" <td bgcolor='green'><font color='white'><b> Inspeção <b></font></td> "
			//cInicio+=" <td bgcolor='green'><font color='white'><b> Padrão   <b></font></td> "
			cInicio+="</tr>"                                  
			cInicio+=cDetalhe    
		    cInicio+='</table>'  
		    cInicio+='</center>' 
		    cInicio+='</body>'   
		    cInicio+='</html>'    
		    
		
		    cEmail:="marcelo@ravaembalagens.com.br"
		    cEmail+=";marcio@ravaembalagens.com.br"
		    cEmail+=";orley@ravaembalagens.com.br"
		    cEmail+=";robinson@ravaembalagens.com.br"
		    cEmail+=";marcos.azevedo@ravaembalagens.com.br"
		    
		    //cEmail:= ""                                   //retirar
		    //cEmail+=";flavia.rocha@ravaembalagens.com.br" //retirar
		     
		    
		    cAssunto := 'Maquina encontra-se : ' + IIF(PAR04 = 2, 'Parada' , ' em Setup' ) + ' - Check-List extrusora'
		    //ACSendMail(,,,,cEmail,cAssunto,cInicio,)
		    U_SendMailSC(cEmail ,"" , cAssunto, cInicio,"" )
		    oDlg1:End()
		
		endif 
    Endif //lParou
Endif
  
End Transaction
   
return

***************

Static Function Corrige(oGetObs,cObs,oObj,EXT,PROD,IT)

***************

if(empty(cObs))
	alert("Campo observação não foi preenchido.")
	oGetObs:SetFocus()
	return
endif
cSupervisor:=alltrim(substr(cUsuario,7,15))
cCodSup := __CUSERID //usu(cSupervisor)


tempo:=Date() //ddatabase
tempo:=dtos(tempo)
tempo:=substr(tempo,1,8)

nRecno   := Z60->(RecNo())

DbSelectArea('Z60')
DbSetOrder(2)
IF Z60->( DBSEEK(xFilial("Z60")+EXT+PROD+IT+'S')  )  
	//alert("encontrou para corrigir")
	while(	DBSEEK(xFilial("Z60")+EXT+PROD+IT+'S') )
			RecLock('Z60',.F.)
			Z60->Z60_PENDEN :='N'
			Z60->Z60_INICIO :=''
			Z60->Z60_OBS    :=cObs
			Z60->Z60_SUPERC :=cCodSup
			Z60->Z60_DATAC  :=stod(tempo)
			Z60->Z60_HORAC  :=hora
			Z60->(MsUnlock())
			//Z60->DBSKIP())
	enddo
ENDIF
DbSelectArea('Z60')
DbSetOrder(1)
Z60->(dbGoto(nRecno))
oObj:end()
return
         
***************

Static Function Tempo(cTurno,cLimite,cAgora)

***************

cMsg:="Inspeção ( "+cTurno
cMsg+=" ) está atrasada em "
cAtraso:=ElapTime( cLimite,cAgora )
nHr :=val(substr(cAtraso,1,2))
nMin:=val(substr(cAtraso,4,2))

if nHr>0
	cMsg+=alltrim(str(nHr))+" hora"+iif(nHr>1,"s "," ")
endif

if nMin>0
	cMsg+=iif(nHr>0,"e ","")+alltrim(str(nMin))+" minuto"+iif(nMin>1,"s "," ")
endif
if !((nHr==0) .and. (nMin==0))
	alert(cMsg)
endif

return cMsg      

***************

Static Function Email()

***************

	cInicio:=" "
	cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' 
	cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> ' 
	cInicio+='<head> '                                                                     
	cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> ' 
	cInicio+='<title>Untitled Document</title> '                                           
	cInicio+='</head> '                                                                    
	cInicio+='<body> '                                                                     
	cInicio+='<center>'                                                                    
 
	cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> ' 
	cInicio+=' <br>'                                    
 
	//cInicio+='<h4> A '+U_itos(nAtraso)+'ª inspeção do dia  '+dtoc(stod(ddia2))+'  não foi realizada. </h4><br>'
	cInicio+='<h4> A inspeção do dia  '+dtoc(stod(ddia2))+'  não foi realizada. </h4><br>' 
	cInicio+=" Periodo ( "+ aTmp[nAtraso][3] +" ás "+ aTmp[nAtraso][4]+" )."                
   /*
   	cInicio+='<table width="100%" border="1"  align="center"  >' 
	cInicio+="<tr>"
	cInicio+=" <td bgcolor='green'><font color='white'><b> Codigo     </b></font></td> "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Maquina    </b></font></td>  "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Produto    </b></font></td> "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Supervisor </b></font></td> "
	cInicio+="</tr>"      
    cInicio+="<tr>"
    cInicio+=" <td>"+cCod                          +"</td> "
    cInicio+=" <td>"+upper(MV_PAR01)               +"</td> "
    cInicio+=" <td>"+upper(MV_PAR02)               +"</td> "
    cInicio+=" <td>"+alltrim(substr(cUsuario,7,15))+"</td> "
    cInicio+="</tr>"  
    cInicio+='</table>'                                                                
    */ 
    cInicio+='</center>' 
    cInicio+='</body>'   
    cInicio+='</html>'    
    
 
   
    cEmail:="marcelo@ravaembalagens.com.br"
    cEmail+=";marcos.azevedo@ravaembalagens.com.br"
    cEmail+=";giancarlo.sousa@ravaembalagens.com.br"
    cEmail+=";robinson@ravaembalagens.com.br"
    
    //cEmail:= ""                                   //retirar
    //cEmail+=";flavia.rocha@ravaembalagens.com.br" //retirar
   
    cAssunto := 'Inspecao check-list extrusora( NAO REALIZADA )'
    //ACSendMail(,,,,cEmail,cAssunto,cInicio,)
    U_SendMailSC(cEmail ,"" , cAssunto, cInicio,"" )
    
return
       
***************

Static Function query(cX,ant1,ant2,dDia)

***************

//alert("periodo "+cX+"  "+ant1+"  "+ant2)
cQry:="select top 1 Z60_HORAI HORAI" + chr(10)           
cQry+="  FROM "+ RetSqlName( "Z60" ) +" Z60                          " + chr(10)
cQry+="  WHERE D_E_L_E_T_=''                                         " + chr(10)
cQry+="  AND Z60_HORAI between "+VALTOSQL(ant1)                  + chr(10)
cQry+="                    AND "+VALTOSQL(ant2)                  + chr(10)
cQry+="  AND Z60_DATAI = "+VALTOSQL(dDia)	 
TCQUERY cQry   NEW ALIAS 'AUX3'
lRet:=.F.
while !AUX3->(EOF())
 lRet:=.T.		 
 AUX3->(dbskip())
enddo 	           
 
AUX3->(DBCLOSEAREA())   

return lRet 

***************

Static Function Hms2Seg(HMS)    

***************

nHr :=val(substr(HMS,1,2))
nMin:=val(substr(HMS,4,2))
//nSeg:=val(substr(HMS,7,2)) 

return ((   (nHr*60) +nMin   )*60)//+nSeg

***************

Static Function Seg2Hms(Seg)    

***************

nSeg:=seg%60 
nMin:=seg/60
nHr :=int(nMin/60)
nMin:=nMin%60

return strzero(nHr,2)+":"+strzero(nMin,2)//+":"+strzero(nSeg,2) 



*************

user function ItosV2(nInt)

*************

return alltrim(str(nInt))   


*************

User Function INSPEC_V2()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "INSPEC_Z60V2" Tables "Z60"
  sleep( 5000 )
  conOut( "Programa INSPEC_V2 na emp. 01 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa INSPEC_V2 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa INSPEC_V2 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec() 

***************

PUBLIC  nAtraso:=0
PUBLIC  cHrAtual:= left(TIME(),5)//substr(MV_PAR03,1,5) //"00:00:00" */TIME() 
PUBLIC  dDia:= Date() //dtos(ddatabase)    
PUBLIC  nTmp:=Hms2Seg(cHrAtual)  
PUBLIC  aTmp:=;
 {;//----- anterior ----|-- Periodo atual-------|- vira dia -| ant |atu|                
  {"20:00","23:59"      , "00:00","02:59"       ,      .T.   , 6   , 1 },;
  {"03:00","08:59"      , "09:00","11:59"       ,      .F.   , 2   , 3 },;
  {"09:00","11:59"      , "12:00","15:59"       ,      .F.   , 3   , 4 },;
  {"12:00","15:59"      , "16:00","19:59"       ,      .F.   , 4   , 5 },;
  {"16:00","19:59"      , "20:00","23:59"       ,      .F.   , 5   , 6 };
  }      

//  {"00:00","02:59"      , "03:00","08:59"       ,      .F.   , 1   , 2 },;
for x:=1 to len(aTmp)
	if nTmp>=Hms2Seg(aTmp[x][3]) .and. nTmp<=Hms2Seg(aTmp[x][4])
		//dDia2:=dtos(ddatabase-iif(aTmp[x][5],1,0))		
		dDia2:=dtos(Date()-iif(aTmp[x][5],1,0))		
		lanterior:=query(U_itos(aTmp[x][6]),aTmp[x][1],aTmp[x][2],dDia2)  
		if !lAnterior //.and. !lAtual 
			     nAtraso:=aTmp[x][6]  
			     cPeriodo:="Periodo ( "+aTmp[x][1]+" Ate  "+aTmp[x][2]+" )"
			     eMAIL()
			exit
		endif
	endif
next
RETURN

*************

User Function Test_V2()

*************

exec()

return

***************

Static Function USU_Cod2Nome(cCod)

***************

PswOrder(1)
	If PswSeek( cCod, .T. )
		aUsuarios  := PSWRET()
		cCod := Alltrim(aUsuarios[1][2])// usuário
	Endif

return cCod


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


***************

Static Function OperExt(cMat)

***************

local cQry:=''
local lret:=.F. 
Local cCodFunc := GetMv("RV_OPEREXT")   //parametro que armazena os códigos de função para operador extrusora 

cQry:="SELECT * FROM "+ RetSqlName( "SRA" ) +"  SRA "
cQry+="WHERE "
cQry+="RA_MAT='"+cMat+"' "                
cQry+="AND RA_SITFOLH=''  "
//cQry+="AND RA_CODFUNC IN ('0261','0262','0263','0264','0265','0025')   "
cQry+="AND RA_CODFUNC IN (" + cCodFunc + ")   "

cQry+="AND SRA.D_E_L_E_T_!='*' "
MemoWrite("C:\TEMP\Operext.sql", cQry )
TCQUERY cQry NEW ALIAS "AUXZ"

IF AUXZ->(!EOF())
   lret:=.T.                                       	
ENDIF

AUXZ->(DBCLOSEAREA())

Return lret

**************************
User Function LegenZ60V2
**************************

BrwLegenda("Legenda" , "Check-List Extrusora",{ {"BR_VERDE" ,	"Sem Pendência"},;
												{"BR_AMARELO" ,	"Com Pendência"},;
									     		{ "BR_VERMELHO",  "Encerrada" } } )

Return .T.

***************
Static Function gravaEst()
***************           

cLote := "Sem Lote"

If len(aCoBrw1Est) <= 0
	alert('Nenhum item na inspecao da estrutura, favor contactar o setor de T.I.' )
	oDlg1:end()
Endif


	FOR nCont:=1 to len(aCoBrw1Est)
			
		cExtrus :=upper(MV_PAR01)
		cProdut :=upper(MV_PAR02)
		cItem   := "E"+alltrim(strzero(nCont,2)) 
		cItemD  :=alltrim(aCoBrw1Est[nCont][1])+'-'+alltrim(aCoBrw1Est[nCont][2])
		nValor1 :=(aCoBrw1Est[nCont][4])
		nValor2 :=(aCoBrw1Est[nCont][3])+(aCoBrw1Est[nCont][3]*10/100) // alterado de 5 para 10% a pedido de orley 
		nProgra :=(aCoBrw1Est[nCont][3])-(aCoBrw1Est[nCont][3]*10/100)
		
		IF !EMPTY(aCoBrw1Est[nCont][5])
			cLote := (aCoBrw1Est[nCont][5])
		ENDIF
		
		if nValor1>=nProgra .AND. nValor1<=nValor2
		    cPendente:='N'		
		ELSE
            cPendente:='S'				
		ENDIF	
		cQry := " "
		cQry += " select  Z60_EXTRUS EXT ,Z60_PRODUT PROD ,Z60_ITEM ITEM ,Z60_PENDEN PENDEN "    + chr(10)
		cQry += " FROM "+ RetSqlName( "Z60" ) +" Z60 "   + chr(10)
		cQry += " WHERE D_E_L_E_T_ =''"                  + chr(10)
		cQry += " AND Z60_PRODUT   = "+valtosql(cPRODUT) + chr(10)
		cQry += " AND Z60_EXTRUS   = "+valtosql(cEXTRUS) + chr(10)
		cQry += " AND Z60_ITEM     = "+valtosql(cItem)   + chr(10)
	   	cQry += " AND Z60_PENDEN   = 'S' "               + chr(10)
	   	cQry += " AND Z60_INICIO   = '*' "               + chr(10)
	   	cQry+=" order by Z60_ITEM"                         + chr(10)
		MemoWrite("C:\TEMP\SEL_GRAVA.SQL", cQry )
		TCQUERY cQry NEW ALIAS 'AUX3'
		
	   if (cPendente == 'S') .and. AUX3->(EOF())
			cInicio:='*'
		else
			cInicio:=''
		endif
	  	
		AUX3->(DBCLOSEAREA())
		
		
		RecLock('Z60',.T.)
		Z60->Z60_FILIAL:= xFilial("Z60")
		Z60->Z60_CODIGO:= cCod
		Z60->Z60_EXTRUS:= cExtrus
		Z60->Z60_PRODUT:= cProdut
		Z60->Z60_ITEM  := cItem
		Z60->Z60_ITEMD := cItemD
		Z60->Z60_VALOR := ALLTRIM(transform(nvalor1,'@E 999.99'))
		Z60->Z60_VALOR2:= ALLTRIM(transform(nvalor2,'@E 999.99'))
		Z60->Z60_PROGRA:= ALLTRIM(transform(nProgra ,'@E 999.99'))
		Z60->Z60_PENDEN:= cPendente
		
		Z60->Z60_INICIO:= cInicio
		Z60->Z60_DATAI := stod(tempo)
		Z60->Z60_HORAI := hora
		Z60->Z60_SUPERI:= cCodSup
		
		Z60->Z60_OPERA:=   cOperador
		Z60->Z60_STAOBS := cOBSMAQ
		Z60->Z60_LOTE :=   cLote
		// NOVO 			
		Z60->Z60_OPEMAQ := iif(MV_PAR07=1,'SIM','NÃO')
		If MV_PAR07=2 // Ruim 
		   Z60->Z60_MOTIVO := iif(MV_PAR08=1,'FURO DE BALAO',iif(MV_PAR08=2,'HOMOGENIZACAO',iif(MV_PAR08=3,'FALTA DE PRODUTO',iif(MV_PAR08=4,'MATERIAL MOLHADO',iif(MV_PAR08=5,'INSTABILIDADE DO BALAO','')))))
		   Z60->Z60_OBSOPE := MV_PAR09
		endIf
		// 
 
		if cPendente == 'S'
			nPenden++ 						
			 cProg:= "De: ( "+alltrim(transform(nProgra,'@E 999.99'))+" ) Ate: ( "+alltrim(transform(nvalor2,'@E 999.99'))+" )"			
			 cDetalhe+="<tr><td>"+cItemD+"</td> <td>"+alltrim(transform(nvalor1,'@E 999.99'))+"</td>  <td>"+cProg+"</td></tr>" 
		endif
		
		Z60->(MsUnlock())
	
	next nCont


Return 

**************
Static Function fSoEst(cCodigo)
***************
local cQry:=''
Local aRet:={}

If Select("TMPY") > 0
	DbSelectArea("TMPY")
	DbCloseArea()
EndIf

cQry := "SELECT * FROM "+ RetSqlName( "Z60" ) +" Z60 " 
cQry += "WHERE SUBSTRING(Z60_ITEM,1,1)='E' "
cQry += "AND Z60_CODIGO='"+cCodigo+"' "
cQry += "AND Z60_FILIAL='"+XFILIAL('Z60')+"' "
cQry += "AND Z60.D_E_L_E_T_='' "
TCQUERY cQry NEW ALIAS 'TMPY'

if TMPY->(!EOF())
   DO WHILE  TMPY->(!EOF())
      aadd(aRet,{TMPY->Z60_ITEMD,TMPY->Z60_VALOR})
      TMPY->(DBSKIP())      
   ENDDO
ELSE
      aadd(aRet,{" "," "})
ENDIF


Return aRet