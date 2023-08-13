#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'PROTHEUS.CH'


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :NEWSOURCE ³ Autor :TEC1 - Designer       ³ Data :17/02/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FNIVELSAC()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oTree1")
aNodes := {}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 126,254,626,1274,"Nivel do Sac ",,,.F.,,,,,,.T.,,,.F. )
oTree1     := DbTree():New( 012,012,228,488,oDlg1,,,.F.,.F. )

oBtn1      := TButton():New( 232,452,"Imprimir",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction:={|| OK() }

getArvore()

oTree1:PTSendTree( aNodes )


oDlg1:Activate(,,,.T.)

Return


***************

Static Function getArvore()
***************

local cQuery :=''

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf

cQuery := "SELECT Z46_CODIGO, Z46_DESCRI "
cQuery += "FROM "+RetSqlName("Z46")+" "
cQuery += "WHERE Z46_N1 != '' "
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z46_CODIGO"

TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 
nCount:=1
while AUXZ->(!EOF())
    aadd( aNodes, {'00', StrZero(nCount,7), "", Padr(AUXZ->Z46_CODIGO+" - "+Alltrim(AUXZ->Z46_DESCRI),100),,} )
    nCount+=1
    NIVEL2(AUXZ->Z46_CODIGO,2)
    AUXZ->(DbSkip())
end
AUXZ->(DbCloseArea())

Return


*************************************
static function NIVEL2(cCod,nNivel)
*************************************

Local cQuery := ""

If Select("AUX2") > 0
	DbSelectArea("AUX2")
	AUX2->(DbCloseArea())
EndIf

cQuery := "SELECT Z46_CODIGO, Z46_DESCRI "
cQuery += "FROM "+RetSqlName("Z46")+" "
if nNivel = 2
   cQuery += "WHERE Z46_N2 = '"+cCod+"' "
elseif nNivel = 3
   cQuery += "WHERE Z46_N3 = '"+cCod+"' "
elseif nNivel = 4
   cQuery += "WHERE Z46_N4 = '"+cCod+"' "
elseif nNivel = 5
   cQuery += "WHERE Z46_N5 = '"+cCod+"' "
endif       
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z46_CODIGO"

TCQUERY cQuery NEW ALIAS "AUX2"

DbSelectArea("AUX2")
AUX2->(DbGoTop()) 
nCount:=1
while AUX2->(!EOF())
    aadd( aNodes, {'01', StrZero(nCount,7), "", Padr(AUX2->Z46_CODIGO+" - "+Alltrim(AUX2->Z46_DESCRI),100),,} )
    nCount+=1
    NIVEL3(AUX2->Z46_CODIGO,3)
    AUX2->(DbSkip())
end
AUX2->(DbCloseArea())

Return

*************************************
static function NIVEL3(cCod,nNivel)
*************************************

Local cQuery := ""

If Select("AUX3") > 0
	DbSelectArea("AUX3")
	AUX3->(DbCloseArea())
EndIf

cQuery := "SELECT Z46_CODIGO, Z46_DESCRI "
cQuery += "FROM "+RetSqlName("Z46")+" "
if nNivel = 2
   cQuery += "WHERE Z46_N2 = '"+cCod+"' "
elseif nNivel = 3
   cQuery += "WHERE Z46_N3 = '"+cCod+"' "
elseif nNivel = 4
   cQuery += "WHERE Z46_N4 = '"+cCod+"' "
elseif nNivel = 5
   cQuery += "WHERE Z46_N5 = '"+cCod+"' "
endif       
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z46_CODIGO"

TCQUERY cQuery NEW ALIAS "AUX3"

DbSelectArea("AUX3")
AUX3->(DbGoTop()) 
nCount:=1
while AUX3->(!EOF())
    aadd( aNodes, {'02', StrZero(nCount,7), "", Padr(AUX3->Z46_CODIGO+" - "+Alltrim(AUX3->Z46_DESCRI),100),,} )
    nCount+=1
    NIVEL4(AUX3->Z46_CODIGO,4)
    AUX3->(DbSkip())
end
AUX3->(DbCloseArea())

Return

*************************************
static function NIVEL4(cCod,nNivel)
*************************************

Local cQuery := ""

If Select("AUX4") > 0
	DbSelectArea("AUX4")
	AUX4->(DbCloseArea())
EndIf

cQuery := "SELECT Z46_CODIGO, Z46_DESCRI "
cQuery += "FROM "+RetSqlName("Z46")+" "
if nNivel = 2
   cQuery += "WHERE Z46_N2 = '"+cCod+"' "
elseif nNivel = 3
   cQuery += "WHERE Z46_N3 = '"+cCod+"' "
elseif nNivel = 4
   cQuery += "WHERE Z46_N4 = '"+cCod+"' "
elseif nNivel = 5
   cQuery += "WHERE Z46_N5 = '"+cCod+"' "
endif       
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z46_CODIGO"

TCQUERY cQuery NEW ALIAS "AUX4"

DbSelectArea("AUX4")
AUX4->(DbGoTop()) 
nCount:=1
while AUX4->(!EOF())
    aadd( aNodes, {'03', StrZero(nCount,7), "", Padr(AUX4->Z46_CODIGO+" - "+Alltrim(AUX4->Z46_DESCRI),100),,} )
    nCount+=1
    NIVEL5(AUX4->Z46_CODIGO,5)
    AUX4->(DbSkip())
end
AUX4->(DbCloseArea())

Return

*************************************
static function NIVEL5(cCod,nNivel)
*************************************

Local cQuery := ""

If Select("AUX5") > 0
	DbSelectArea("AUX5")
	AUX5->(DbCloseArea())
EndIf

cQuery := "SELECT Z46_CODIGO, Z46_DESCRI "
cQuery += "FROM "+RetSqlName("Z46")+" "
if nNivel = 2
   cQuery += "WHERE Z46_N2 = '"+cCod+"' "
elseif nNivel = 3
   cQuery += "WHERE Z46_N3 = '"+cCod+"' "
elseif nNivel = 4
   cQuery += "WHERE Z46_N4 = '"+cCod+"' "
elseif nNivel = 5
   cQuery += "WHERE Z46_N5 = '"+cCod+"' "
endif       
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z46_CODIGO"

TCQUERY cQuery NEW ALIAS "AUX5"

DbSelectArea("AUX5")
AUX5->(DbGoTop()) 
nCount:=1
while AUX5->(!EOF())
    aadd( aNodes, {'04', StrZero(nCount,7), "", Padr(AUX5->Z46_CODIGO+" - "+Alltrim(AUX5->Z46_DESCRI),100),,} )
    nCount+=1
   AUX5->(DbSkip())
end
AUX5->(DbCloseArea())

Return

********************
Static Function ok()
********************
Private aArray:={}
Private aCabec:={}


FOR Z:=1 TO LEN(aNodes)
    IF ALLTRIM(aNodes[Z][1])=='00'
       
       AADD(aArray,{aNodes[Z][4],"","","","","","","","","","","","","",""})
    
    ELSEIF ALLTRIM(aNodes[Z][1])=='01'

       AADD(aArray,{"",aNodes[Z][4],"","","","","","","","","","","","",""})    

    ELSEIF ALLTRIM(aNodes[Z][1])=='02'

       AADD(aArray,{"","",aNodes[Z][4],"","","","","","","","","","","",""})        

    ELSEIF ALLTRIM(aNodes[Z][1])=='03'

       AADD(aArray,{"","","",aNodes[Z][4],"","","","","","","","","","",""})        

    ELSEIF ALLTRIM(aNodes[Z][1])=='04'

       AADD(aArray,{"","","","",aNodes[Z][4],"","","","","","","","","",""})        

    ENDIF

NEXT

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Depreciacao de Ativo Fixo", aCabec, aArray}})})
	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return()
	EndIf



Return 

