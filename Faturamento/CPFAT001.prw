#Include "RwMake.ch"
//#Include "protheus.ch"
#include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ CPFAT001     Autor ³ Gustavo Costa     ³ Data ³ 03/02/2015  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo ³ Tela de Pesquisa Especifica Cadastro de Transportadoras      ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

User Function CPFAT001()

Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}
Local cLocalidades	:= "024   #"

SA4->(DbClearFilter())

Aadd(aMat,{"A4_COD" 	, "Codigo" , "@!" , "C", 06, 0})
Aadd(aMat,{"A4_NOME" , "Transportadora" , "@!" , "C", 40, 0})

cQuery	:= "SELECT * FROM SZZ010 "
cQuery	+= "WHERE D_E_L_E_T_ <> '*' "
cQuery	+= "AND ZZ_ATIVO = 'S' "
cQuery	+= "AND ZZ_LOCAL = '" + M->C5_LOCALIZ + "' "

If Select("XPI") > 0
	DbSelectArea("XPI")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XPI"

XPI->( DbGoTop() )
			
While XPI->(!EOF())

	cLocalidades	+= XPI->ZZ_TRANSP + '#'
	XPI->(dbSkip())

EndDo

cCondicao := "SA4->A4_COD $ '" + cLocalidades + "' "
bFiltraBrw := {|| FilBrowse("SA4",@aInd,@cCondicao) }

Eval(bFiltraBrw)

@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Transportadora"
@ 006, 005 TO 190, 370 BROWSE "SA4" FIELDS aMat OBJECT oBrowCons

//@ 200, 120 BUTTON "_Pesq Codigo" SIZE 60, 13 ACTION PesqCodSRA()
//@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomSRA()
@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

oDlgPrd:lCentered := .t.
oDlgPrd:Activate()

//alert('Produto escolhido: '+SB1->B1_DESC)

SA4->(DbClearFilter())


Return lOpc

Static Function PesqCodSRA()

Local cCondicao:=''
Local cGet:=Space(06)
Local aInd:={}

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Matricula:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SRA->(dbSetOrder(1))
SRA->(dbSeek(xFilial("SRA")+cGet))

Endif
return


Static Function PesqNOMSRA()
Local cGet:=Space(40)

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Nome:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SRA->(DBSetOrder(3))
SRA->(DBseek(xFilial("SRA")+Rtrim(cGet)))
Endif

return