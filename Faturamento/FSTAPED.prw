#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'PROTHEUS.CH'


*************

User Function FSTAPED()

*************

ValidPerg('FSTAPED')


IF !Pergunte('FSTAPED',.T.)

   Return 

ENDIF


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oTree1")
aNodes := {}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 126,254,626,1274,"Status Pedido ",,,.F.,,,,,,.T.,,,.F. )
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

cQuery := "SELECT C5_NUM  PEDIDO "
cQuery += "FROM "+RetSqlName("SC5")+" "
cQuery += "WHERE C5_NUM  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY PEDIDO "

TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 
nCount:=1
while AUXZ->(!EOF())
    aadd( aNodes, {'00', StrZero(nCount,7), "", Padr(AUXZ->PEDIDO,100),,} )
    nCount+=1
    NIVEL2(AUXZ->PEDIDO)
    AUXZ->(DbSkip())
end
AUXZ->(DbCloseArea())

Return


***************

static function NIVEL2(cCod)

***************

Local cQuery := ""

If Select("AUX2") > 0
	DbSelectArea("AUX2")
	AUX2->(DbCloseArea())
EndIf

cQuery := "SELECT Z46_CODIGO, Z46_DESCRI "
cQuery += "FROM "+RetSqlName("Z46")+" "

cQuery := "SELECT * FROM "+RetSqlName("ZAC")+" ZAC "
cQuery += "WHERE "
cQuery += "ZAC_FILIAL='"+XFILIAL('ZAC')+"' "
cQuery += "AND ZAC_PEDIDO='"+cCod+"' "
cQuery += "AND ZAC.D_E_L_E_T_='' "
cQuery += "ORDER BY ZAC_STATUS,ZAC_DTSTAT "
TCQUERY cQuery NEW ALIAS "AUX2"

DbSelectArea("AUX2")
AUX2->(DbGoTop()) 
nCount:=1
while AUX2->(!EOF())
    aadd( aNodes, {'01', StrZero(nCount,7), "", Padr(AUX2->ZAC_STATUS+" - "+Alltrim(AUX2->ZAC_DESCST)+" - "+DTOC(STOD(AUX2->ZAC_DTSTAT))+" - "+Alltrim(AUX2->ZAC_HRSTAT),100),,} )
    nCount+=1
    AUX2->(DbSkip())
end
AUX2->(DbCloseArea())

Return


***************

Static Function ok()

***************

Private aArray:={}
Private aCabec:={}


FOR Z:=1 TO LEN(aNodes)
    IF ALLTRIM(aNodes[Z][1])=='00'
       
       AADD(aArray,{aNodes[Z][4],"","","","","","","","","","","","","",""})
    
    ELSEIF ALLTRIM(aNodes[Z][1])=='01'

       AADD(aArray,{"",aNodes[Z][4],"","","","","","","","","","","","",""})    

    ENDIF

NEXT

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Depreciacao de Ativo Fixo", aCabec, aArray}})})
	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return()
	EndIf



Return 


***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Pedido De     ?','','','mv_ch1','C',06,0,0,'G','','SC5','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Pedido Ate    ?','','','mv_ch2','C',06,0,0,'G','','SC5','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

Return

