#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
	
///Adicionar botões na atualização de orçamentos de venda
*************
User Function MA415BUT()

*************

aBotao :={{"POSCLI",{|| U_fCargaProd()},"Dica"}}

Return(aBotao)


**************************
Static Function fCarga()

local cQry		:= ''
Local nItem		:= 1
Local cProds	:= "'CKB159','CDB154','ADC145'"
Local lFirstLine	:= .T.

cQry := " SELECT B1_COD, B1_DESC, B1_UM FROM  " + RetSqlName("SB1") + " B1 "
cQry += " WHERE B1_COD IN (" + cProds + ")"

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

While TMP5->(!EOF())

	If lFirstLine
		RecLock("TMP1", .F.)
		lFirstLine := .F.
	Else
		RecLock("TMP1", .T.)
		TMP1->CK_ITEM 		:= StrZero(nItem,2)
	EndIf
	TMP1->CK_PRODUTO	:= TMP5->B1_COD
	TMP1->CK_DESCRI		:= TMP5->B1_DESC
	TMP1->CK_UM 		:= TMP5->B1_UM
	
	RunTrigger(2,nil,nil,,'CK_PRODUTO')
	
	TMP5->(dbSkip())
	
	nItem++

EndDo

TMP5->(dbclosearea())

TMP1->(dbGoTop())

oGetDad:oBrowse:Refresh()

Return

User function fCargaProd()


Local oPanel
Local oNewPag
Local cNome   := ""
Local cFornec := ""
Local cCombo1 := ""
Local oStepWiz := nil
Local oDlg := nil
Local oPanelBkg

aSize := MsAdvSize()

If Empty(M->CJ_CLIENTE)
	MsgAlert("Primeiramente deve-se selecionar um cliente!")
EndIf

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
	{{005,070,110,175,215,280}} )
nGetLin := aPosObj[3,1]

DEFINE MSDIALOG oDlg TITLE 'Carga de Produtos' From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

//DEFINE DIALOG oDlg TITLE 'Carga de Produtos' PIXEL
//oDlg:nWidth := 1100
//oDlg:nHeight := 800
oPanelBkg:= tPanel():New(0,0,"",oDlg,,,,,,300,300)
oStepWiz:= FWWizardControl():New(oPanelBkg)//Instancia a classe FWWizard
oStepWiz:ActiveUISteps()
 
//----------------------
// Pagina 1
//----------------------
oNewPag := oStepWiz:AddStep("1")
//Altera a descrição do step
oNewPag:SetStepDescription("Primeiro passo")
//Define o bloco de construção
oNewPag:SetConstruction({|Panel|cria_pg1(Panel, @cNome, @cFornec)})
//Define o bloco ao clicar no botão Próximo
oNewPag:SetNextAction({||valida_pg1(@cNome, @cFornec)})
//Define o bloco ao clicar no botão Cancelar
oNewPag:SetCancelAction({||Alert("Cancelou na pagina 1"), .T.})
 
//----------------------
// Pagina 2
//----------------------
oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel, @cCombo1)})
oNewPag:SetStepDescription("Segundo passo")
oNewPag:SetNextAction({||valida_pg2(@cCombo1)})
//Define o bloco ao clicar no botão Voltar
oNewPag:SetCancelAction({||Alert("Cancelou na pagina 2"), .T.})
oNewPag:SetPrevAction({||Alert("Ops, voce não pode voltar a partir daqui"), .F.})
oNewPag:SetPrevTitle("Voltar(ou não)")
 
//----------------------
// Pagina 3
//----------------------
oNewPag := oStepWiz:AddStep("3", {|Panel|cria_pn3(Panel)})
oNewPag:SetStepDescription("Terceiro passo")
oNewPag:SetNextAction({||Alert("Fim"), .T.})
oNewPag:SetCancelAction({||Alert("Cancelou na pagina 3"), .T.})
oNewPag:SetCancelWhen({||.F.})
oStepWiz:Activate()
ACTIVATE DIALOG oDlg CENTER
oStepWiz:Destroy()

*/
Return
 
//--------------------------
// Construção da página 1
//--------------------------
Static Function cria_pg1(oPanel, cNome, cFornec)

Local oTGet1
Local oTGet2
Local aItems := {'Item1','Item2','Item3'}
Local oCombo1

oSay1:= TSay():New(10,10,{||'Cliente'},oPanel,,,,,,.T.,,,200,20)
cNome := Space(30)
oTGet1 := TGet():New( 20,10,{|u| if( PCount() > 0, cNome := u, cNome ) } ,oPanel,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cNome,,,, )
oSay2:= TSay():New(40,10,{||'Fornecedor'},oPanel,,,,,,.T.,,,200,20)
cFornec := Space(30)
oTGet2 := TGet():New( 50,10,{|u| if( PCount() > 0, cFornec := u, cFornec ) },oPanel,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cFornec,,,, )
cCombo1:= aItems[1]   
oCombo1 := TComboBox():New(20,20,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,100,20,oPanel,,{|| },,,,.T.,,,,,,,,,'cCombo1')

Return
  
 
//----------------------------------------
// Validação do botão Próximo da página 1
//----------------------------------------
Static Function valida_pg1(cNome, cFornec)
MsgInfo("Cliente: " + cNome + chr(13)+chr(10) + "Fornecedor: " + cFornec)
Return .T.
 
//--------------------------
// Construção da página 2
//--------------------------
Static Function cria_pg2(oPanel, cCombo1)
local cQry		:= ''
Local nItem		:= 1
Local cProds	:= "'CKB159','CDB154','ADC145'"
Local lFirstLine	:= .T.

cQry := " SELECT B1_COD, B1_DESC, B1_UM FROM  " + RetSqlName("SB1") + " B1 "
cQry += " WHERE B1_COD IN (" + cProds + ")"

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

While TMP5->(!EOF())

	If lFirstLine
		RecLock("TMP1", .F.)
		lFirstLine := .F.
	Else
		RecLock("TMP1", .T.)
		TMP1->CK_ITEM 		:= StrZero(nItem,2)
	EndIf
	TMP1->CK_PRODUTO	:= TMP5->B1_COD
	TMP1->CK_DESCRI		:= TMP5->B1_DESC
	TMP1->CK_UM 		:= TMP5->B1_UM
	
	RunTrigger(2,nil,nil,,'CK_PRODUTO')
	
	TMP5->(dbSkip())
	
	nItem++

EndDo

TMP5->(dbclosearea())

TMP1->(dbGoTop())

oGetDad:oBrowse:Refresh()

Return
  
 
//----------------------------------------
// Validação do botão Próximo da página 2
//----------------------------------------
Static Function valida_pg2(cCombo1)

Local lRet := .T.
/*
If cCombo1 == 'Item3'
    lRet := .T.
Else
    Alert("Você selecionou: " + cCombo1 + " para prossegir selecione Item3")
EndIf
*/
Return lRet
 
//--------------------------
// Construção da página 3
//--------------------------
Static Function cria_pn3(oPanel)
Local oBtnPanel := TPanel():New(0,0,"",oPanel,,,,,,40,40)
MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(030,000,aPosObj[1][3], aPosObj[1][4]-5,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oPanel,aHoBrw1,aCoBrw1 )

//oBtnPanel:Align := CONTROL_ALIGN_TOP
//oTButton1 := TButton():New( 010, 010, "Botão 01",oBtnPanel,{||alert("Botão 01")}, 80,20,,,.F.,.T.,.F.,,.F.,,,.F. )
//oTButton2 := TButton():New( 010, 0200, "Botão 02",oBtnPanel,{||alert("Botão 02")}, 80,20,,,.F.,.T.,.F.,,.F.,,,.F. )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MCoBrwOP      º Autor ³ Gustavo Costa  º Data ³  03/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Monta o aCols										      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MHoBrw1()

Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))

Aadd( aHoBrw1 , {"Codigo"		,"COD"		,"@!"					,006,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"loja"			,"LOJA"	,"@!"					,002,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"Nome"			,"NOME"	,"@!"					,040,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"Classe A"		,"A"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Classe B"		,"B"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Classe C"		,"C"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Classe D"		,"D"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Classe E"		,"E"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Result."		,"RES"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"R$ Vencido"	,"VENCIDO"	,"@E 9,999,999.99"	,014,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"R$ A vencer"	,"AVENCER"	,"@E 9,999,999.99"	,014,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"LC Calc."		,"LCC"		,"@E 9,999,999.99"	,014,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Risco"			,"RISCO"	,"@!"					,001,000,"Pertence('A,B,C,D,E')","û","C"} )

For nI := 1 To noBrw1
	
	Do Case
		Case aHoBrw1[nI][2] = "COD"
			aCoBrw1[1][nI] := CriaVar("A1_COD")
		Case aHoBrw1[nI][2] = "LOJA"
			aCoBrw1[1][nI] := CriaVar("A1_LOJA")
		Case aHoBrw1[nI][2] $ "A#B#C#D#E#RES"
			aCoBrw1[1][nI] := CriaVar("E1_PORCJUR")
		Case aHoBrw1[nI][2] $ "LCC#VENCIDO#AVENCER"
			aCoBrw1[1][nI] := CriaVar("A1_LC")
		Case aHoBrw1[nI][2] = "RISCO"
			aCoBrw1[1][nI] := CriaVar("A1_RISCO")
	EndCase

Next
aCoBrw1[1][noBrw1+1] := .F.
	
Return
        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtAcols1()  º Autor ³ Gustavo Costa   º Data ³  03/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Atualiza o aCols1 - XMP                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MCoBrw1()

Local aAux 	:= {}
local nI	:= 1

dbSelectArea("XE1")
XE1->(dbgoTop())

aCoBrw1 := {}

While XE1->(!EOF())

	Aadd(aCoBrw1,Array(noBrw1+1))
	aCoBrw1[Len(aCoBrw1)][01] := XE1->COD
	aCoBrw1[Len(aCoBrw1)][02] := XE1->LOJA
	aCoBrw1[Len(aCoBrw1)][03] := XE1->NOME
	aCoBrw1[Len(aCoBrw1)][04] := XE1->A
	aCoBrw1[Len(aCoBrw1)][05] := XE1->B
	aCoBrw1[Len(aCoBrw1)][06] := XE1->C
	aCoBrw1[Len(aCoBrw1)][07] := XE1->D
	aCoBrw1[Len(aCoBrw1)][08] := XE1->E
	aCoBrw1[Len(aCoBrw1)][09] := XE1->RES
	aCoBrw1[Len(aCoBrw1)][10] := XE1->VENCIDO
	aCoBrw1[Len(aCoBrw1)][11] := XE1->AVENCER
	aCoBrw1[Len(aCoBrw1)][12] := XE1->LCC
	aCoBrw1[Len(aCoBrw1)][13] := XE1->RISCO
	aCoBrw1[Len(aCoBrw1)][noBrw1+1] := .F.
    
	XE1->(dbSkip())
EndDo

//oBrw1:oBrowse:Refresh()
     
Return

