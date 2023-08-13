#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

static _cRtConBo:=" "

*************

User Function fExConBo()

*************

Local cQry := ""



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oBtn1")
	
// consulta
cQry := "select DISTINCT ZZ4_CONTAG from ZZ4020 ZZ4 WHERE ZZ4.D_E_L_E_T_='' ORDER BY ZZ4_CONTAG "

If Select("TABY") > 0
	DbSelectArea("TABY")
	TABY->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'TABY'                      


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 148,385,347,853,"Contagem de Bobina",,,.F.,,,,,,.T.,,,.F. )
oTbl1()
DbSelectArea("TMP")
oBrw1      := MsSelect():New( "TMP","","",{{"CODIGO","","Codigo",""}},.F.,,{004,003,064,227},,, oDlg1 )
oBtn1      := TButton():New( 072,190,"Ok",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {|| oDlg1:End() }

TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA

while TABY->(!EOF()) 

	RecLock("TMP",.T.)
	TMP->CODIGO	:= TABY->ZZ4_CONTAG
	TMP->(MsUnLock())
	TABY->(dbskip())
		
EndDo

TMP->( DbGotop() )

oBrw1:oBrowse:Refresh()

oDlg1:Activate(,,,.T.)

_cRtConBo:=TMP->CODIGO

TMP->(DBCloseArea())
Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO


Return  .T. 



*************

user function FRtConBo()

*************			

//_cRtConBo:=TMP->CODIGO
//oDlg1:End()

return _cRtConBo


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"CODIGO" ,"C",006,000} )


coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 

