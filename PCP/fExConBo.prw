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



/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇 Declara豫o de Variaveis do Tipo Local, Private e Public                 굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/
Private coTbl1

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇 Declara豫o de Variaveis Private dos Objetos                             굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/
SetPrvt("oDlg1","oBrw1","oBtn1")
	
// consulta
cQry := "select DISTINCT ZZ4_CONTAG from ZZ4020 ZZ4 WHERE ZZ4.D_E_L_E_T_='' ORDER BY ZZ4_CONTAG "

If Select("TABY") > 0
	DbSelectArea("TABY")
	TABY->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'TABY'                      


/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇 Definicao do Dialog e todos os seus componentes.                        굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/
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


/*컴컴컴쩡컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴컴컴컴컴컴
Function  � oTbl1() - Cria temporario para o Alias: TMP
컴컴컴컴컴탠컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"CODIGO" ,"C",006,000} )


coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 

