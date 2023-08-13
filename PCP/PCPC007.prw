#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

User Function PCPC007()
***********************


aRotina := {;
{"Pesquisar"   , "AxPesqui"     , 0, 1},;
{"Incluir"     , "U_CAD_Z59(1)" , 0, 3},;
{"Visualizar"  , "U_CAD_Z59(2)" , 0, 2},;
{"Editar"      , "U_CAD_Z59(3)" , 0, 4} }

cCadastro := OemToAnsi("Valor Padrão")
cAlias:='Z59'
DbSelectArea(cAlias)
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, cAlias,,,,,,{} )

Return




User Function CAD_Z59(Funcao)
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
space(15)
public nSlit,nAlinha,nCamera,nGelad,nNeve,nBobi,nTrat,nEdit,nCircAgua
public cEXT:=space(3)
public cPROD:=space(15)
Public nList
lDisable:=.F.
Public aItems:={;
"Sim",;
"Nao";
}
//cSlit:=cAlinha:=cCamera:=cGeladeira:=cSensor:=cTratamento := cBobina:="SIM"
if xFuncao==1
	if  !PERGUNTE ('PCPC006',.T.)
		return
	endif
	MV_PAR01:=UPPER(MV_PAR01)
	MV_PAR02:=UPPER(MV_PAR02)
	cQry :=""
	cQry+=" select Z59_ITEM ITEM , Z59_VALOR VALOR, Z59_VALOR2 VALOR2"          +chr(10)
	cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 " +chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                 +chr(10)
	cQry+=" AND Z59_PRODUT="+valtosql(upper(MV_PAR02))  +chr(10)
	cQry+=" AND Z59_EXTRUS="+valtosql(upper(MV_PAR01))  +chr(10)
	cQry+=" order by Z59_ITEM"                         + chr(10)
	TCQUERY cQry   NEW ALIAS 'AUX1'
	aCampos1:={}
	while !AUX1->(EOF())
		aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
		AUX1->(dbskip())
	enddo
	AUX1->(DBCLOSEAREA())
	if len(aCampos1)!=0
		alert('Ja existe produto cadastrado para essa extrusora.')
		return
	endif
endif



if xFuncao!=3
	if xFuncao!=1
		cQry :=""
		cQry+=" select  Z59_VALOR VALOR,Z59_VALOR2 VALOR2 ,  Z59_ITEM ITEM" +chr(10)
		cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "        +chr(10)
		cQry+=" WHERE D_E_L_E_T_=''"                        +chr(10)
		cQry+=" AND Z59_PRODUT="+valtosql(Z59->Z59_PRODUT)  +chr(10)
		cQry+=" AND Z59_EXTRUS="+valtosql(Z59->Z59_EXTRUS)  +chr(10)
		cQry+=" order by Z59_ITEM"                          + chr(10)
		
		TCQUERY cQry   NEW ALIAS 'AUX2'
		aCampos2:={}
		aCampos3:={}
		while !AUX2->(EOF())
			PswOrder(1)
			aadd(aCampos2,VALOR,ITEM)
			aadd(aCampos3,VALOR2)
			
			AUX2->(dbskip())
		enddo
		AUX2->(DBCLOSEAREA())
		cZona1:=    aCampos2[12]
		cZona11:=    aCampos3[12]
		
		cMatriz1 := aCampos2[13]
		cMatriz11:= aCampos3[13]
		
		cSlit:=      aCampos2[14]
		
		cLinear:=    aCampos2[6]
		cLinear1:=   aCampos3[6]
		
		cGrama :=    aCampos2[7]
		cGrama1:=    aCampos3[7]
		
		cEspes:=     aCampos2[8]
		cEspes1:=    aCampos3[8]
		
		cAltura :=    aCampos2[9]
		cAltura1:=    aCampos3[9]
		
		cLargura :=   aCampos2[10]
		cLargura1:=   aCampos3[10]
		
		cAlinha:=     aCampos2[11]
		cCamera:=     aCampos2[1]
		cGeladeira:=  aCampos2[2]
		cSensor:=     aCampos2[3]
		cTratamento:= aCampos2[4]
		cBobina:=     aCampos2[5]
		
		cZona2 :=    aCampos2[15]
		cZona22:=    aCampos3[15]
		
		cZona3 :=    aCampos2[16]
		cZona33:=    aCampos3[16]
		
		cZona4 :=    aCampos2[17]
		cZona44:=    aCampos3[17]
		
		cZona5 :=    aCampos2[18]
		cZona55:=    aCampos3[18]
		
		cZona6 :=    aCampos2[19]
		cZona66:=    aCampos3[19]
		
		cZona7 :=    aCampos2[20]
		cZona77:=    aCampos3[20]
		
		cMatriz2 := aCampos2[21]
		cMatriz22:= aCampos3[21]
		
		cMatriz3 := aCampos2[22]
		cMatriz33:= aCampos3[22]
		
		cMatriz4 := aCampos2[23]
		cMatriz44:= aCampos3[23]
		
		cFiltro := aCampos2[25]
		cFiltro1:= aCampos3[25]
		
		cFlange := aCampos2[26]
		cFlange1:= aCampos3[26]
		
		cCalib := aCampos2[27]
		cCalib1:= aCampos3[27]
		
		cHelic := aCampos2[28]
		cHelic1:= aCampos3[28]
		           
		cCircAgua:=aCampos2[24]
		
		cEXT:=Z59->Z59_EXTRUS
		cPROD:=Z59->Z59_PRODUT
		lDisable:=.T.
	endif
	oDlg1      := MSDialog():New( 152,327,712,1022,"Valor Padrão",,,.F.,,,,,,.T.,,,.F. )
	
	
	oGrp0      := TGroup():New( 004,002,038,344,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1     := TSay():New( 011,008,{||"Extrusora:" },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
	oSay1     := TSay():New( 011,056,{||"Produto:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	
	
	
	if xFuncao == 2
		oGetEXT := TGet():New( 019,008,{|u| If(PCount()>0,cEXT:=u,cEXT)          },oGrp0,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cEXT" ,, )
		oGetEXT:bValid:={|| cEXT:=upper(cEXT) }
	else
		oGetEXT := TGet():New( 019,008,{|u| If(PCount()>0,MV_PAR01:=u,MV_PAR01)  },oGrp0,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","MV_PAR01" ,, )
		oGetEXT:bValid:={|| MV_PAR01:=upper(MV_PAR01) }
	endif
	oGetEXT:disable()
	
	
	
	if xFuncao == 2
		oGetPROD:= TGet():New( 019,056,{|u| If(PCount()>0,cPROD:=u,cPROD)},oGrp0,070,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPROD",,)
		oGetPROD:bValid:={|| cPROD:=upper(cPROD) }
	else
		oGetPROD:= TGet():New( 019,056,{|u| If(PCount()>0,MV_PAR02:=u,MV_PAR02)},oGrp0,070,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","MV_PAR02",,)
		oGetPROD:bValid:={|| MV_PAR02:=upper(MV_PAR02) }
	endif
	oGetPROD:disable()
	
	oGrp1      := TGroup():New( 042,002,255,114," Temperatura ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSBox1     := TScrollBox():New( oGrp1,052,007,199,103,.T.,.T.,.T. )
	nIni:=0
	
 
	
	oSay   := TSay():New( nIni,001,    {|| 'Zona 1'                         }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                            }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona1:=u,cZona1  )}  ,oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona1'   ,,)
	   oZona11:bValid:={|| cZona1:=upper(cZona1) }
	   travar(oZona11)
	  
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                               }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona12:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona11:=u,cZona11    ) }  ,oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona11'   ,,)
	   oZona12:bValid:={|| cZona11:=upper(cZona11) }
	   travar(oZona12)
	
	oSay   := TSay():New( nIni+=20,001 ,   {|| 'Zona 2'                     }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                            }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona21 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona2:=u,cZona2)} ,oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona2'   ,,)
	   oZona21:bValid:={|| cZona2:=upper(cZona2) }
	   travar(oZona21)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }                ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona22:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona22:=u,cZona22    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona22'   ,,)
	   oZona22:bValid:={|| cZona22:=upper(cZona22) }
	   travar(oZona22)
	
	oSay   := TSay():New( nIni +=20,001 ,  {|| 'Zona 3'              }         ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }             ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona31 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona3:=u,cZona3 )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona3'   ,,)
	   oZona31:bValid:={|| cZona3:=upper(cZona3) }
	   travar(oZona31)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }                ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona32:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona33:=u,cZona33    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona33'   ,,)
	   oZona32:bValid:={|| cZona33:=upper(cZona33) }
	   travar(oZona32)
	
	oSay   := TSay():New( nIni+=20,001 ,    {|| 'Zona 4'              }        ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }             ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona41 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona4:=u,cZona4 )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona4'   ,,)
	   oZona41:bValid:={|| cZona4:=upper(cZona4) }
	   travar(oZona41)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }                ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona42:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona44:=u,cZona44    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona44'   ,,)
	   oZona42:bValid:={|| cZona44:=upper(cZona44) }
	   travar(oZona42)
	
	
	
	oSay   := TSay():New( nIni+=20,001 ,    {|| 'Zona 5'              }        ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona51 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona5:=u,cZona5      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona5'   ,,)
	   oZona51:bValid:={|| cZona5:=upper(cZona5) }
	   travar(oZona51)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona52:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona55:=u,cZona55    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona55'   ,,)
	   oZona52:bValid:={|| cZona55:=upper(cZona55) }
	   travar(oZona52)
	
	
	
	
	oSay   := TSay():New( nIni+=20,001 ,    {|| 'Zona 6'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona61 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona6:=u,cZona6      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona6'   ,,)
	   oZona61:bValid:={|| cZona6:=upper(cZona6) }
	   travar(oZona61)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona62:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona66:=u,cZona66    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona66'   ,,)
	   oZona62:bValid:={|| cZona66:=upper(cZona66) }
	   travar(oZona62)
	
	
	
	
	oSay   := TSay():New( nIni+=20,001 ,   {|| 'Zona 7'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona71 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cZona7:=u,cZona7      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona7'   ,,)
	   oZona71:bValid:={|| cZona7:=upper(cZona7) }
	   travar(oZona71)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oZona72:= TGet():New( nIni,051,{|u| If(PCount()>0,cZona77:=u,cZona77    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cZona77'   ,,)
	   oZona72:bValid:={|| cZona77:=upper(cZona77) }
	   travar(oZona72)
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 1'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz1:=u,cMatriz1      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz1'   ,,)
	   oMatriz11:bValid:={|| cMatriz1:=upper(cMatriz1) }
	   travar(oMatriz11)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz12:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz11:=u,cMatriz11    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz11'   ,,)
	   oMatriz12:bValid:={|| cMatriz11:=upper(cMatriz11) }
	   travar(oMatriz12)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 2'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz21 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz2:=u,cMatriz2      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz2'   ,,)
	   oMatriz21:bValid:={|| cMatriz2:=upper(cMatriz2) }
	   travar(oMatriz21)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz22:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz22:=u,cMatriz22    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz22'   ,,)
	   oMatriz22:bValid:={|| cMatriz22:=upper(cMatriz22) }
	   travar(oMatriz22)
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 3'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz31 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz3:=u,cMatriz3      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz3'   ,,)
	   oMatriz31:bValid:={|| cMatriz3:=upper(cMatriz3) }
	   travar(oMatriz31)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz32:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz33:=u,cMatriz33    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz33'   ,,)
	   oMatriz32:bValid:={|| cMatriz33:=upper(cMatriz33) }
	   travar(oMatriz32)
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Matriz 4'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz41:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cMatriz4:=u,cMatriz4      )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz4'   ,,)
	   oMatriz41:bValid:={|| cMatriz4:=upper(cMatriz4) }
	   travar(oMatriz41)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oMatriz42:= TGet():New( nIni,051,{|u| If(PCount()>0,cMatriz44:=u,cMatriz44    )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cMatriz44'   ,,)
	   oMatriz42:bValid:={|| cMatriz44:=upper(cMatriz44) }
	   travar(oMatriz42)
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Temperatura de Filtro'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oFiltro11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cFiltro :=u,cFiltro       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFiltro'   ,,)
	   oFiltro11:bValid:={|| cFiltro:=upper(cFiltro ) }
	   travar(oFiltro11)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oFiltro12:= TGet():New( nIni,051,{|u| If(PCount()>0,cFiltro1 :=u,cFiltro1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFiltro1'   ,,)
	   oFiltro12:bValid:={|| cFiltro1 :=upper(cFiltro1 ) }
	   travar(oFiltro12)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Flange'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay     := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oFlange11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cFlange :=u,cFlange       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFlange'   ,,)
	   oFlange11:bValid:={|| cFlange:=upper(cFlange ) }
	   travar(oFlange11)
	
	   oSay     := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oFlange12:= TGet():New( nIni,051,{|u| If(PCount()>0,cFlange1 :=u,cFlange1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cFlange1'   ,,)
	   oFlange12:bValid:={|| cFlange1 :=upper(cFlange1 ) }
	   travar(oFlange12)
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Calibrador'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oCalib11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cCalib :=u,cCalib       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCalib'   ,,)
	   oCalib11:bValid:={|| cCalib:=upper(cCalib ) }
	   travar(oCalib11)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oCalib12:= TGet():New( nIni,051,{|u| If(PCount()>0,cCalib1 :=u,cCalib1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCalib1'   ,,)
	   oCalib12:bValid:={|| cCalib1 :=upper(cCalib1 ) }
	   travar(oCalib12)
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Helicoidal'              }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oHelic11 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,cHelic :=u,cHelic       )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cHelic'   ,,)
	   oHelic11:bValid:={|| cHelic:=upper(cHelic ) }
	   travar(oHelic11)
	
	   oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oHelic12:= TGet():New( nIni,051,{|u| If(PCount()>0,cHelic1 :=u,cHelic1     )},oSBox1,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cHelic1'   ,,)
	   oHelic12:bValid:={|| cHelic1 :=upper(cHelic1 ) }
	   travar(oHelic12)
	
	
	
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Conformidade d0 Slit'                  }  ,oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,010 )
	   if xFuncao == 2
	   	 oSlit := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSlit:=u,cSlit        )},oSBox1,080,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cSlit'    ,,)
	   	 oSlit:bValid:={||cSlit:=upper(cSlit) }
	   else
	   	 oSlit:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSlit:=u,nSlit)},aSlit:=aItems,80,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	     ASize(aSlit,Len(aSlit))
	   	 oSlit:aItems:=aSlit
	   	 oSlit:nAT:=1
	   	 oSlit:bValid:={||cSlit:=upper(aItems[oSlit:nAT]) }
	   endif
	   travar(oSlit)
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Circulação de Agua'                            },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,020 )
	   if xFuncao == 2
		 oCircAgua := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCircAgua:=u,cCircAgua )  },oSBox1,080,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCircAgua' ,,)
		 oCircAgua:bValid:={||cCircAgua:=upper(cCircAgua) }
	   else
		 oCircAgua:=	TComboBox():New(nIni+=10,001,{|u| if(Pcount()>0,nCircAgua:=u,nCircAgua)},aCircAgua:=aItems,80,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aSlit,Len(aCircAgua))
		 oCircAgua:aItems:=aCircAgua
		 oCircAgua:nAT:=1
		 oCircAgua:bValid:={||cCircAgua:=upper(aItems[oCircAgua:nAT]) }
	   endif
	   travar(oCircAgua)
	
	
	
	oGrp2      := TGroup():New( 042,117,255,229," Gravimetro ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSBox2     := TScrollBox():New( oGrp2,052,121,199,103,.T.,.T.,.T. )
	nIni:=0
	
	oSay   := TSay():New( nIni    ,001,{|| 'Linear'              }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	oSay     := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oLinear11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cLinear :=u,cLinear       )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLinear'   ,,)
	oLinear11:bValid:={|| cLinear:=upper(cLinear ) }
	travar(oLinear11)
	
	oSay     := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oLinear12:= TGet():New( nIni,051,{|u| If(PCount()>0,cLinear1 :=u,cLinear1     )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLinear1'   ,,)
	oLinear12:bValid:={|| cLinear1 :=upper(cLinear1 ) }
	travar(oLinear12)
	
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Grama/Metro'         }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oGrama11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cGrama :=u,cGrama       )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cGrama'   ,,)
	oGrama11:bValid:={|| cGrama:=upper(cGrama ) }
	travar(oGrama11)
	
	oSay   := TSay():New( nIni,041,{|| 'Ate:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	oGrama12:= TGet():New( nIni,051,{|u| If(PCount()>0,cGrama1 :=u,cGrama1     )},oSBox2,030,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cGrama1'   ,,)
	oGrama12:bValid:={|| cGrama1 :=upper(cGrama1 ) }
	travar(oGrama12)
	
	
	
	
	
	oSay        := TSay():New( nIni+=20,001,{|| 'Espessura do Filme'  }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   oSay     := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oEspess11:= TGet():New( nIni    ,010,{|u| If(PCount()>0,cEspes:=u,cEspes      )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEspes'   ,,)
	   oEspess11:bValid:={|| cEspes:=upper(cEspes) }
	   travar(oEspess11)
	
	   oSay   := TSay():New( nIni,050,{|| 'Ate:'                    }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oEspess12:= TGet():New( nIni,060,{|u| If(PCount()>0,cEspes1:=u,cEspes1    )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEspes1'   ,,)
	   oEspess12:bValid:={|| cEspes1:=upper(cEspes1) }
	   travar(oEspess12)   
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Altura do Balao'     }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	  oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	  oAltura11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cAltura:=u,cAltura      )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cAltura'   ,,)
	  oAltura11:bValid:={|| cAltura:=upper(cAltura) }
	  travar(oAltura11)
	
	  oSay   := TSay():New( nIni,050,{|| 'Ate:'                    }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	  oAltura12:= TGet():New( nIni,060,{|u| If(PCount()>0,cAltura1:=u,cAltura1    )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cAltura1'   ,,)
	  oAltura12:bValid:={|| cAltura1:=upper(cAltura1) }
	  travar(oAltura12)
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Largura bobina'      }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                 }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oLargura11:= TGet():New( nIni    ,0010,{|u| If(PCount()>0,cLargura:=u,cLargura      )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLargura'   ,,)
	   oLargura11:bValid:={|| cLargura:=upper(cLargura) }
	   travar(oLargura11)
	
	   oSay   := TSay():New( nIni,050,{|| 'Ate:'                    }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oLargura12:= TGet():New( nIni,060,{|u| If(PCount()>0,cLargura1:=u,cLargura1    )},oSBox2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cLargura1'   ,,)
	   oLargura12:bValid:={|| cLargura1:=upper(cLargura1) }
	   travar(oLargura12)
	
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Alinhamento bobina'  }  ,oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
	   if xFuncao == 2
		 oAlinha := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cAlinha:=u,cAlinha)},oSBox2,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cAlinha',,)
		 oAlinha:bValid:={||cAlinha:=upper(cAlinha) }
	   else
		 oAlinha:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nAlinha:=u,nAlinha)},aAlinha:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aAlinha,Len(aAlinha))
		 oAlinha:aItems:=aAlinha
		 oAlinha:nAT:=1
		 oAlinha:bValid:={|| cAlinha:=upper(aAlinha[oAlinha:nAT]) }
	   endif
	   travar(oAlinha)
	
	
	
	oGrp3      := TGroup():New( 042,232,255,344," Ferramenta ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSBox3     := TScrollBox():New( oGrp3,052,236,199,103,.T.,.T.,.T. )
	nIni:=0
	
	oSay   := TSay():New( nIni    ,001,{|| 'Câmera'              }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oCamera := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCamera:=u,cCamera)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cCamera',,)
		 oCamera:bValid:={||cCamera:=upper(cCamera) }
	   else
		 oCamera:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCamera:=u,nCamera)},aCamera:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aCamera,Len(aCamera))
		 oCamera:aItems:=aCamera
		 oCamera:nAT:=1
		 //	iif (cCamera == aCamera[1],oGet31:nAT:=1,oGet31:nAT:=2)
		 oCamera:bValid:={|| cCamera:=upper(aItems[oCamera:nAT]) }
	   endif
	   travar(oCamera)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Geladeira'           }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oGeladeira := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cGeladeira:=u,cGeladeira)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cGeladeira',,)
		 oGeladeira:bValid:={||cGeladeira:=upper(cGeladeira) }
	   else
		 oGeladeira:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nGelad:=u,nGelad)},aGelad:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aGelad,Len(aGelad))
		 oGeladeira:aItems:=aGelad
		 oGeladeira:nAT:=1
		 //iif (cGeladeira == aGelad[1],oGet32:nAT:=1,oGet32:nAT:=2)
		 oGeladeira:bValid:={|| cGeladeira:=upper(aItems[oGeladeira:nAT]) }
	   endif
	   travar(oGeladeira)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Sensor Ponto de Neve'}  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oSensor := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSensor:=u,cSensor        )},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cSensor'    ,,)
		 oSensor:bValid:={||cSensor:=upper(cSensor) }
	   else
		 oSensor:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nNeve:=u,nNeve)},aNeve:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aNeve,Len(aNeve))
		 oSensor:aItems:=aNeve
		 oSensor:nAT:=1
		 //iif (cSensor == aNeve[1],oGet33:nAT:=1,oGet33:nAT:=2)
		 oSensor:bValid:={|| cSensor:=upper(aItems[oSensor:nAT]) }
	   endif
	   travar(oSensor)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Tratamento'          }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oTrat := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cTratamento:=u,cTratamento)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cTratamento',,)
		 oTrat:bValid:={||cTratamento:=upper(cTratamento) }
	   else
		 oTrat:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nTrat:=u,nTrat)},aTrat:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aTrat,Len(aTrat))
		 oTrat:aItems:=aTrat
		 oTrat:nAT:=1
		 //iif (cTratamento == aTrat[1],oGet34:nAT:=1,oGet34:nAT:=2)
		 oTrat:bValid:={|| cTratamento:=upper(aItems[oTrat:nAT]) }
	   endif
	   travar(oTrat)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Bobinadeira'         }  ,oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
	   if xFuncao == 2
	     oBobina := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cBobina:=u,cBobina)},oSBox3,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cBobina',,)
		 oBobina:bValid:={||cBobina:=upper(cBobina) }
	   else
		 oBobina:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nBobi:=u,nBobi)},aBobi:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aBobi,Len(aBobi))
		 oBobina:aItems:=aBobi
		 oBobina:nAT:=1
		 //iif (cBobina == aBobi[1],oGet35:nAT:=1,oGet35:nAT:=2)
		 oBobina:bValid:={|| cBobina:=upper(aItems[oBobina:nAT]) }
	   endif
	   travar(oBobina)    
	               
	
	if xFuncao == 2
		oSBtn1     := SButton():New( 260,311,1,{|| oDlg1:end()  },oDlg1,,"", )
	else
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
		@oGeladeira,            ;// 25
		@oSensor   ,            ;// 26
		@oTrat     ,            ;// 27
		@oBobina                ;// 28
	}
	
		oSBtn1     := SButton():New( 260,276,1,{|| GRAVAR(aObj)},oDlg1,,"", )
		oSBtn2     := SButton():New( 260,311,2,{|| oDlg1:end() },oDlg1,,"", )
	endif
	oDlg1:Activate(,,,.T.)
else
	
	
	
	
	oDlg1      := MSDialog():New( 152,327,620,1120,"Valor Padrão",,,.F.,,,,,,.T.,,,.F. )
	
	// dbselectarea( 'Z60' )
	//Z60->( dbsetorder( 1 ) )
	//dbSeek(;
	// xFilial("Z60") +;
	// alltrim(Z60->Z60_EXTRUS) +;
	// alltrim(Z60->Z60_PRODUT) +;
	// alltrim(Z60->Z60_ITEM  ) +;
	// alltrim(Z60->Z60_DATAI ) +;
	// alltrim(Z60->Z60_HORAI ),.T.)
	
	cQry :=""
	cQry+=" select  Z59_VALOR VALOR,Z59_VALOR2 VALOR2 ,  Z59_ITEM ITEM , Z59_EXTRUS EXT, Z59_PRODUT PROD" +chr(10)
	cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "        +chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                        +chr(10)
	cQry+=" AND Z59_PRODUT="+valtosql(Z59->Z59_PRODUT)  +chr(10)
	cQry+=" AND Z59_EXTRUS="+valtosql(Z59->Z59_EXTRUS)  +chr(10)
	cQry+=" order by Z59_ITEM"                         + chr(10)
	TCQUERY cQry   NEW ALIAS 'AUX2'
	cItem:=Z59->Z59_ITEM
	aCampos2:={}
	while !AUX2->(EOF())
		aadd(aCampos2,{EXT,PROD,ITEM,VALOR,VALOR2})
		AUX2->(dbskip())
	enddo
	AUX2->(DBCLOSEAREA())
	
	//aItens:={/*'TEMP DE MASSA',*/'Zonas','Matrizes','Slit','Linear','Grama/Metro','Espessura Filme','Altura do Balão','Largura Bobina','Alinhamento Bobina','Camera','Geladeira','Sensor Ponto de Neve','Tratamento','Bobinadeira'}
	aItens:={/*'TEMP DE MASSA',*/;
	'Camera',;              //  1
	'Geladeira',;           //  2
	'Sensor Ponto de Neve',;//  3
	'Tratamento',;          //  4
	'Bobinadeira',;         //  5
	'Linear',;              //  6
	'Grama/Metro',;         //  7
	'Espessura Filme',;     //  8
	'Altura do Balão',;     //  9
	'Largura Bobina',;      // 10
	'Alinhamento Bobina',;  // 11
	'Zona 1',;              // 12
	'Matriz 1',;            // 13
	'Conformidade do Slit',;// 14
	'Zona 2',;              // 15
	'Zona 3',;              // 16
	'Zona 4',;              // 17
	'Zona 5',;              // 18
	'Zona 6',;              // 19
	'Zona 7',;              // 20
	'Matriz 2',;            // 21
	'Matriz 3',;            // 22
	'Matriz 4',;            // 23
	'Circ de Agua',;        // 24
	'Temp de Filtro',;      // 25
	'Flange',;              // 26
	'Calibrador',;          // 27
	'Helicoidal';          // 28
	}
	
	
	ini:=10
	tab1:=15
	tab2:=40
	oGrp0      := TGroup():New( 0,10,020,390,"INSPEÇÃO",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay0      := TSay():New( ini,15,{|| "Extrusora:"  },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,45,{|| aCampos2[1,1] },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	oSay0      := TSay():New( ini,75,{|| "Produto:"    },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,102,{|| aCampos2[1,2]},oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	
	ini:=35
	tab1:=15
	tab2:=50
	oGrp1      := TGroup():New( 25,10,210,105,"TEMPERATURA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	//oSay1      := TSay():New( ini,tab1,{|| aItens[1]         },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[1][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	//oSay1      := TSay():New( ini,tab2,{|| aCampos2[1][4]    },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	//ini+=10
	aVetT:={12,15,16,17,18,19,20,13,21,22,23,25,26,27,28,14,24}
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[1]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[1]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[1]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[1]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[2]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[2]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[2]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[2]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[3]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[3]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[3]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[3]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[4]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[4]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[4]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[4]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[5]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[5]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[5]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[5]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[6]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[6]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[6]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[6]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[7]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[7]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[7]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[7]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10

	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[8]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[8]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[8]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[8]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[9]]             },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[9]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[9]][4] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[9]][5] },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[10]]            },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[10]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[10]][4]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[10]][5]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[11]]            },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[11]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[11]][4]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[11]][5]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[12]]            },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[12]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[12]][4]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[12]][5]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[13]]            },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[13]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[13]][4]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[13]][5]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[14]]            },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[14]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[14]][4]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[14]][5]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	oSay1      := TSay():New( ini,tab1   ,{|| aItens[aVetT[15]]            },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[15]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetT[15]][4]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+25,{|| "Ate:"+aCampos2[aVetT[15]][5]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[16]]              },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[16]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2+30,{|| aCampos2[aVetT[16]][4]        },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[17]]              },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[17]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	   oSay1   := TSay():New( ini,tab2+30,{|| aCampos2[aVetT[17]][4]        },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	
	ini:=35
	tab1:=115
	tab2:=170
	oGrp2      := TGroup():New( 25,110,210,255,"GRAVIMETRO",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	aVetG:={6,7,8,9,10,11}
	oSay1      := TSay():New( ini,tab1,{|| aItens[aVetG[1]]               },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[1]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetG[1]][4]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+30,{|| "Ate:"+aCampos2[aVetG[1]][5]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	                                                          
	oSay1      := TSay():New( ini,tab1,{|| aItens[aVetG[2]]               },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[2]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetG[2]][4]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+30,{|| "Ate:"+aCampos2[aVetG[2]][5]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens[aVetG[3]]               },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[3]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetG[3]][4]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+30,{|| "Ate:"+aCampos2[aVetG[3]][5]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens[aVetG[4]]               },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[4]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetG[4]][4]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+30,{|| "Ate:"+aCampos2[aVetG[4]][5]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens[aVetG[5]]               },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[5]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,050,008)
	   oSay1   := TSay():New( ini,tab2   ,{|| "De: "+aCampos2[aVetG[5]][4]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   oSay1   := TSay():New( ini,tab2+30,{|| "Ate:"+aCampos2[aVetG[5]][5]},oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens[aVetG[6]]               },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[6]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetG[6]][4]          },oGrp2,,,.F.,.F.,.F.,.T.,CLR_GREEN, CLR_WHITE ,070,008)
	ini+=10
	
	ini:=35
	tab1:=265
	tab2:=340
	oGrp3      := TGroup():New( 25,260,210,390,"FERRAMENTA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	aVetF:={1,2,3,4,5}
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[1]]   },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[1]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,100,008)
	   oSay1   := TSay():New( ini,tab2,{|| aCampos2[aVetF[1]][4]},oGrp3,,,.F.,.F.,.F.,.T.,CLR_GREEN, CLR_WHITE ,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[2]]   },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[2]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,100,008)
	   oSay1   := TSay():New( ini,tab2,{|| aCampos2[aVetF[2]][4]},oGrp3,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[3]]   },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[3]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,100,008)
	   oSay1   := TSay():New( ini,tab2,{|| aCampos2[aVetF[3]][4]},oGrp3,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,070,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[4]]   },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[4]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,100,008)
	   oSay1   := TSay():New( ini,tab2,{|| aCampos2[aVetF[4]][4]},oGrp3,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,100,008)
	   ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[5]]   },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[5]][3]!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE,100,008)
	   oSay1   := TSay():New( ini,tab2,{|| aCampos2[aVetF[5]][4]},oGrp3,,,.F.,.F.,.F.,.T.,CLR_GREEN, CLR_WHITE ,070,008)
	   ini+=10
	
	cEdit:=cEdit2:=space(15)
	oSay1      := TSay():New( 217.5,10,{|| "Editar:"  },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	
	if cItem $ 'T03 T13 G06 F01 F02 F03 F04 F05'
		nTipo:=1
		oGetEDIT:=	TComboBox():New(217,43,{|u| if(Pcount()>0,nEdit:=u,nEdit)},aEdit:=aItems,90,20,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		ASize(aEdit,Len(aEdit))
		oGetEDIT:aItems:=aEdit
		oGetEDIT:nAT:=1
		oGetEDIT:bValid:={|| cEdit:=upper(aItems[oGetEDIT:nAT]) }
	elseif cItem $ 'T01 T02 T04 T05 T06 T07 T08 T09 T10 T11 T12 T14 T15 T16 T17 G01 G02 G03 G04 G05'
		ntipo:=2
		oSay     := TSay():New( 217,40,{|| 'De:'                            } ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
		oGetEDIT := TGet():New( 217,50,{|u| If(PCount()>0,cEdit:=u,cEdit    )},oDlg1,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEdit'   ,,)
		oGetEDIT:bValid:={|| cEdit:=upper(cEdit) }
		oSay     := TSay():New( 217,90, {|| 'Ate:'                          } ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
		oGetEDIT2:= TGet():New( 217,100,{|u| If(PCount()>0,cEdit2:=u,cEdit2 )},oDlg1,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEdit2'   ,,)
		oGetEDIT2:bValid:={|| cEdit2:=upper(cEdit2) }
	else
		nTipo:=1
		oGetEDIT  := TGet():New( 217,43,{|u| If(PCount()>0,cEdit:=u,cEdit)  },oDlg1,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,.F.,.F.,,'cEdit',,)
		oGetEDIT2:=0
		cEdit2:=""
	endif
	oSBtn1     := SButton():New( 217  ,283,1, {||  Edit(cEdit,cEdit2,@oDlg1,nTipo,@oGetEDIT,@oGetEDIT2)   },oDlg1,,"", )
	oSBtn2     := SButton():New( 217.2,313,2, {||  oDlg1:end()                       },oDlg1,,"", )
	
	oDlg1:Activate(,,,.T.)
	
	
endif
Return

static function GRAVAR(aObj)

Local aVetor:={;
cZona1      ,cZona11    ,; //  1
cZona2      ,cZona22    ,; //  2
cZona3      ,cZona33    ,; //  3
cZona4      ,cZona44    ,; //  4
cZona5      ,cZona55    ,; //  5
cZona6      ,cZona66    ,; //  6
cZona7      ,cZona77    ,; //  7
cMatriz1    ,cMatriz11  ,; //  8
cMatriz2    ,cMatriz22  ,; //  9
cMatriz3    ,cMatriz33  ,; // 10
cMatriz4    ,cMatriz44  ,; // 11
cFiltro     ,cFiltro1   ,; // 12
cFlange     ,cFlange1   ,; // 13
cCalib      ,cCalib1    ,; // 14
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
cGeladeira  ,;             // 25
cSensor     ,;             // 26
cTratamento ,;             // 27
cBobina;                   // 28
}
 
Local aMsg  :={;
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
"FLANGE (De)"         ,"FLANGE (Ate)"        ,;  // 13
"CALIBRADOR (De)"     ,"CALIBRADOR (Ate)"    ,;  // 14
"HELICOIDAL (De)"     ,"HELICOIDAL (Ate)"    ,;  // 15
"CONFORMIDADE DO SLIT",;                         // 16
"CIRCULACAO DE AGUA " ,;                         // 17
;                                                   
"LINEAR (De)"         ,"LINEAR (Ate)"     ,;     // 18
"GRAMA/METRO (De)"    ,"GRAMA/METRO (Ate)",;     // 19
"ESPESSURA (De)"      ,"ESPESSURA (Ate)"  ,;     // 20
"ALTURA (De)"         ,"ALTURA  (Ate)"    ,;     // 21
"LARGURA (De)"        ,"LARGURA (Ate)"    ,;     // 22
"ALINHAMENTO"         ,;                         // 23
;
"CAMERA"              ,;                         // 24
"GELADEIRA"           ,;                         // 25
"SENSOR PONTO DE NEVE",;                         // 26
"TRATAMENTO"          ,;                         // 27
"BOBINADEIRA"          ;                         // 28
}

cVazio:=''
cMsg:='Confime o campo'

for x:=1 to len(avetor)
	if alltrim(aVetor[x]) == cVazio
		alert (cMsg+" "+aMsg[x])
		aObj[x]:SetFocus() 
		return
	endif
next

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
{cFlange    ,"T15",cFlange1  ,"FLANGE"               },; // 13
{cCalib     ,"T16",cCalib1   ,"CALIBRADOR"           },; // 14
{cHelic     ,"T17",cHelic1   ,"HELICOIDAL"           },; // 15
{cSlit      ,"T03",""        ,"CONFORMIDADE DO SLIT" },; // 16
{cCircAgua  ,"T13",""        ,"CIRCULACAO DE AGUA "  },; // 17
{cLinear    ,"G01",cLinear1  ,"LINEAR"               },; // 18
{cGrama     ,"G02",cGrama1   ,"GRAMA/METRO"          },; // 19
{cEspes     ,"G03",cEspes1   ,"ESPESSURA"            },; // 20
{cAltura    ,"G04",cAltura1  ,"ALTURA DO BALAO"      },; // 21
{cLargura   ,"G05",cLargura1 ,"LARGURA DA BOBINA"    },; // 22
{cAlinha    ,"G06",""        ,"ALINHAMENTO BOBINA"   },; // 23
{cCamera    ,"F01",""        ,"CAMERA"               },; // 24
{cGeladeira ,"F02",""        ,"GELADEIRA"            },; // 25
{cSensor    ,"F03",""        ,"SENSOR PONTO DE NEVE" },; // 26
{cTratamento,"F04",""        ,"TRATAMENTO"           },; // 27
{cBobina    ,"F05",""        ,"BOBINADEIRA"          } ; // 28
}


FOR nCont:=1 to len(aValores)
	RecLock('Z59',.T.)
	Z59->Z59_FILIAL:=xFilial("Z59")
	Z59->Z59_EXTRUS:=upper(MV_PAR01)
	Z59->Z59_PRODUT:=upper(MV_PAR02)
	
	Z59->Z59_ITEM :=aValores[nCont][2]
	Z59->Z59_ITEMD:=aValores[nCont][4]
	
	Z59->Z59_VALOR :=aValores[nCont][1]
	Z59->Z59_VALOR2:=aValores[nCont][3]
	
	Z59->(MsUnlock())
	CONFIRMSX8()
next nCont
oDlg1:end()
return


 


static function  travar(oObj)
if lDisable
	oObj:disable()
endif
return





static function Edit(cEdit,cEdit2,oObj,nTipo,oGetEDIT,oGetEDIT2)

if(empty(cEdit))
	alert("Campo de edição não foi preenchido.")
	oGetEDIT:SetFocus()
	return
endif
if nTipo == 2
	if(empty(cEdit2))
		alert("Segundo Campo de edição não foi preenchido.")
		oGetEDIT2:SetFocus()
		return
	endif
endif

RecLock('Z59',.F.)
Z59->Z59_VALOR:=cEdit
Z59->Z59_VALOR2:=cEdit2
Z59->(MsUnlock())
oObj:end()


return


