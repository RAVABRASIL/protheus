#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Confcad() บ Autor ณ Gustavo Costa   บ Data ณ  22/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ .		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Confcad()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cCadastro := "Guia de Confer๊ncia"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array (tambem deve ser aRotina sempre) com as definicoes das opcoes ณ
//ณ que apareceram disponiveis para o usuario. Segue o padrao:          ณ
//ณ aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ณ
//ณ              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ณ
//ณ              . . .                                                  ณ
//ณ              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      ณ
//ณ Onde: <DESCRICAO> - Descricao da opcao do menu                      ณ
//ณ       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  ณ
//ณ                     duplas e pode ser uma das funcoes pre-definidas ณ
//ณ                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA ณ
//ณ                     e AXDELETA) ou a chamada de um EXECBLOCK.       ณ
//ณ                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-ณ
//ณ                     clarar uma variavel chamada CDELFUNC contendo   ณ
//ณ                     uma expressao logica que define se o usuario po-ณ
//ณ                     dera ou nao excluir o registro, por exemplo:    ณ
//ณ                     cDelFunc := 'ExecBlock("TESTE")'  ou            ณ
//ณ                     cDelFunc := ".T."                               ณ
//ณ                     Note que ao se utilizar chamada de EXECBLOCKs,  ณ
//ณ                     as aspas simples devem estar SEMPRE por fora da ณ
//ณ                     sintaxe.                                        ณ
//ณ       <TIPO>      - Identifica o tipo de rotina que sera executada. ณ
//ณ                     Por exemplo, 1 identifica que sera uma rotina deณ
//ณ                     pesquisa, portando alteracoes nao podem ser efe-ณ
//ณ                     tuadas. 3 indica que a rotina e de inclusao, porณ
//ณ                     tanto, a rotina sera chamada continuamente ao   ณ
//ณ                     final do processamento, ate o pressionamento de ณ
//ณ                     <ESC>. Geralmente ao se usar uma chamada de     ณ
//ณ                     EXECBLOCK, usa-se o tipo 4, de alteracao.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ณ
//ณ MBROWSE sera identica a da AXCADASTRO:                              ณ
//ณ                                                                     ณ
//ณ cDelFunc  := ".T."                                                  ณ
//ณ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ณ
//ณ                { "Visualizar"   ,"AxVisual" , 0, 2},;               ณ
//ณ                { "Incluir"      ,"AxInclui" , 0, 3},;               ณ
//ณ                { "Alterar"      ,"AxAltera" , 0, 4},;               ณ
//ณ                { "Excluir"      ,"AxDeleta" , 0, 5} }               ณ
//ณ                                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cCadastro := "Guia de Confer๊ncia"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","U_fxAltera('VISUALIZAR')",0,2} ,;
{"Incluir","U_fxAltera('INCLUIR')",0,3} ,;
{"Recontar","U_fxAltera('ALTERAR')",0,4} ,;
{"Legenda","u_Legenda3",0,6} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZAA"
aCores := {{"ZAA_STATUS==' '","BR_VERDE"},;
{"ZAA_STATUS=='X'","BR_VERMELHO"}}

dbSelectArea("ZAA")
dbSetOrder(1)

// Insere um SetKey
SetKEY(VK_F12,{|| MsgAlert("VK_F12")})

//-- Ponto de Entrada para incluir botใo na Pr้-Nota de Entrada

dbSelectArea(cString)
mBrowse(6,1,22,75,cString,,,,,6,aCores)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda3()   บ Autor ณ Gustavo Costa   บ Data ณ  22/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Legenda3()
BrwLegenda(cCadastro,"Status da Confer๊ncia", { 	{"BR_VERDE","Aberta"},;
{"BR_VERMELHO","Finalizada"}})

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fxAltera บ Autor ณ Gustavo Costa      บ Data ณ  25/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Na inclusao utiliza a tela do modelo 3 para inserir os     บฑฑ
ฑฑบ          ณ dados do XML                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fxAltera(cOpcao)

Local aButtons	:= {}
Local aCordW 	:= {}
Local aSize     := {}
Local aSizeAut  := MsAdvSize()
Local aObjects  := {}
Local aPosObj   := {}
Local lVirtual	:= .T.
Local lRet		:= .F.
Local oDlg
Local cCadastro	:= "Guia de Confer๊ncia"

Private cSeqAnt	:= ""
Private aTELA[0][0] // Variแveis que serใo atualizadas pela Enchoice()
Private aGETS[0] 	// e utilizadas pela fun็ใo OBRIGATORIO()
Private aCols
Private aHeader

//aCabec := {}
//aItens := {}

Do Case
	Case cOpcao=="INCLUIR"; nOpcE:=3 ; nOpcG:=3 ; nOpc:=3
	Case cOpcao=="ALTERAR"; nOpcE:=4 ; nOpcG:=4 ; nOpc:=4
	Case cOpcao=="VISUALIZAR"; nOpcE:=2 ; nOpcG:=2 ; nOpc:=2
	Case cOpcao=="EXCLUIR"; nOpcE:=5 ; nOpcG:=5 ; nOpc:=5
EndCase

//adiciona botoes na Enchoice
//aAdd( aButtons, { "PRODUTO", {|| fPedCom(ZF1->ZF1_FORNECE, ZF1->ZF1_LOJA, aCols[n,ascan(aheader,{|x|upper(alltrim(x[2]))=="ZD1_COD"})] )}, "Pedido", "Ped. Compra" } )

If cOpcao<>"VISUALIZAR" .And. cOpcao <> "INCLUIR"
	IF ZAA->ZAA_STATUS == "X"
		MsgAlert("Nใo permitido. Confer๊ncia Encerrada!")
		return
	EndIf
EndIf

DbSelectArea("ZAA")
DbSetOrder(1)

//+--------------------------------------------------------------+
//| Cria variaveis M->????? da Enchoice                          |
//+--------------------------------------------------------------+
IF cOpcao=="ALTERAR"
	RegToMemory("ZAA",.F.)
	cSeqAnt	:= M->ZAA_SEQ
	M->ZAA_SEQ := STRZERO(Val(M->ZAA_SEQ)+1,2)
Else
	RegToMemory("ZAA",(cOpcao=="INCLUIR"))
	
	IF cOpcao=="INCLUIR"
		M->ZAA_SEQ := "01"
	EndIf
	cSeqAnt	:= M->ZAA_SEQ
EndIf
//+--------------------------------------------------------------+
//| Cria aHeader e aCols da GetDados                             |
//+--------------------------------------------------------------+
nUsado:=0
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZAB")
aHeader:={}
While !Eof().And.(x3_arquivo=="ZAB")
	
	If X3USO(x3_usado) .And. cNivel >= x3_nivel //.AND. X3_CAMPO <> 'ZAB_ITEM'
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	SX3->(dbSkip())
End

If cOpcao=="INCLUIR" .OR. cOpcao=="ATERAR"
	
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	
	aCols[1][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_ITEM"})] := "0001"
	
Else
	aCols:={}
	dbSelectArea("ZAB")
	dbSetOrder(1)
	dbSeek(xFilial("ZAB")+M->ZAA_DOC+M->cSeqAnt+M->ZAA_FORNECE+M->ZAA_LOJA)
	While !eof().and. ZAB->ZAB_DOC == M->ZAA_DOC .and. ZAB->ZAB_SEQ == cSeqAnt//M->ZAA_SEQ
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
Endif
If Len(aCols)>0
	
	cTitulo:="Guia de Confer๊ncia"
	cAliasEnchoice:="ZAA"
	cAliasGetD:="ZAB"
	cLinOk:="AllwaysTrue"
	cTudOk:="AllwaysTrue"
	cFieldOk:="ValidTOK()"
	
	aObjects := {}
	AAdd( aObjects, { 315,  50, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],00 To aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
	
	EnChoice( "ZAA" ,0, nOpc, , , , , aPosObj[1],      , 3 )
	
	oGetDad := MSGetDados():New (aPosObj[2,1], aPosObj[2,2], aPosObj[2,3], aPosObj[2,4], nOpc, cLinOk ,cTudOk,"+ZAB_ITEM",.F.)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF( fGrava(nOpc), oDlg:End(), .F.) },;
   													{|| lRet := .F. , oDlg:End()},,aButtons)
	
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGrava     บ Autor ณ Gustavo Costa    บ Data ณ  25/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava as informacoes do browser.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fGrava(nOpc)

Local aCabec := {}
Local aItens := {}

lRet	:= OBRIGATORIO(aGets, aTela)

If lRet // Se confirmou o OK
	
	IF nOpc = 4 .OR. nOpc = 5   //Altera ou Exclui
		
		BEGIN TRANSACTION
		
		AlteraZAA(nOpc)
		AlteraZAB(nOpc)
		
		END TRANSACTION
		
		IF nOpc = 4 //Altera
			atuGConf(M->ZAA_DOC, cSeqAnt)
			fMandMail()
		EndIf
		
	EndIf
	
	If nOpc = 3  // INCLUIR
		
		aadd(aCabec,{"ZAA_FILIAL"   ,xFilial("ZAA")		,Nil,Nil})
		aadd(aCabec,{"ZAA_DOC"   	,M->ZAA_DOC			,Nil,Nil})
		aadd(aCabec,{"ZAA_SEQ"   	,M->ZAA_SEQ			,Nil,Nil})
		aadd(aCabec,{"ZAA_FORNEC" 	,M->ZAA_FORNEC		,Nil,Nil})
		aadd(aCabec,{"ZAA_LOJA"    	,M->ZAA_LOJA		,Nil,Nil})
		aadd(aCabec,{"ZAA_STATUS"  	,M->ZAA_STATUS		,Nil,Nil})
		
		aadd(aCabec,{"ZAA_EMISSA"	,M->ZAA_EMISSA		,Nil,Nil})
		aadd(aCabec,{"ZAA_PEDCOM"	,M->ZAA_PEDCOM		,Nil,Nil})
		aadd(aCabec,{"ZAA_USUA"		,cUserName			,Nil,Nil})
		
		//Novo produto
		For nX := 1 To Len(aCols)
			
			aLinha := {}
			
			aadd(aLinha,{"ZAB_FILIAL"	,XFilial("ZAB")		,Nil,Nil})
			aadd(aLinha,{"ZAB_ITEM"		,aCols[nX][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_ITEM"})]	,Nil,Nil})
			aadd(aLinha,{"ZAB_COD"  	,aCols[nX][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_COD"})]	,Nil,Nil})
			aadd(aLinha,{"ZAB_DESC"    	,aCols[nX][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_DESC"})]	,Nil,Nil})
			aadd(aLinha,{"ZAB_UM"		,aCols[nX][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_UM"})]		,Nil,Nil})
			aadd(aLinha,{"ZAB_QUANT"	,aCols[nX][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_QUANT"})]	,Nil,Nil})
			aadd(aLinha,{"ZAB_LOCAL"	,aCols[nX][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_LOCAL"})]	,Nil,Nil})
			aadd(aLinha,{"ZAB_FORNEC"	,M->ZAA_FORNEC		,Nil,Nil})
			aadd(aLinha,{"ZAB_LOJA"   	,M->ZAA_LOJA		,Nil,Nil})
			aadd(aLinha,{"ZAB_DOC"    	,M->ZAA_DOC			,Nil,Nil})
			aadd(aLinha,{"ZAB_SEQ"    	,M->ZAA_SEQ			,Nil,Nil})
			aadd(aLinha,{"ZAB_EMISSA"	,M->ZAA_EMISSA		,Nil,Nil})
			aadd(aLinha,{"ZAB_PEDIDO"	,M->ZAA_PEDCOM		,Nil,Nil})
			aadd(aLinha,{"ZAB_ITEMPC"	,POSICIONE("SC7",2,XFILIAL("SC7") + aCols[nX][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_COD"})] +;
			M->ZAA_FORNEC + M->ZAA_LOJA + M->ZAA_PEDCOM, "C7_ITEM")			,Nil,Nil})
			
			aadd(aItens,aLinha)
		Next nX
		
		GravaDados(aCabec,aItens)
		ConfirmSx8()
		fMandMail()
	EndIf
Else
	Return (.F.)
Endif

Return (.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fMandMail  บ Autor ณ Gustavo Costa    บ Data ณ  25/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia email informando que foi cadastrado uma confer๊ncia. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fMandMail()

Local cTitulo  	:= "Guia de Confer๊ncia - " + Alltrim(M->ZAA_DOC) + " Sequ๊ncia - " + Alltrim(M->ZAA_SEQ)
Local cConteudo	:= ""
Local cMailTo	:= GetNewPar('MV_XMAILGC',"gustavo@ravaembalagens.com.br")
//Local cMailTo	:= GetNewPar('MV_XMAILGC',"flavia.rocha@ravaembalagens.com.br")
Local cCopia 	:= ""
Local cAnexo	:= ""
Local lEnviado  := .F.

cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml' >"
cConteudo +="<head>"
cConteudo +="    <title>Untitled Page</title>"
cConteudo +="</head>"
cConteudo +="<body>"
dbSelectArea("SM0")
cConteudo +="Na empresa " + SM0->M0_CODIGO + SM0->M0_CODFIL + " - " + AllTrim(SM0->M0_FILIAL) + ".<br /><br />"
cConteudo +="Foi cadastrado o <strong>Guia de Confer๊ncia</strong> de n๚mero <strong>" + Alltrim(M->ZAA_DOC) + "</strong> " + "<br /><br />"
cConteudo +="Voc๊ jแ pode lan็ar a nota fiscal referente ao <strong>Pedido de Compra</strong> de n๚mero <strong>" + AllTrim(M->ZAA_PEDCOM) + ".</strong> "
cConteudo +="<br /><br /> "
cConteudo +="<strong>Fornecedor</strong> - " + M->ZAA_FORNEC + " - " + AllTrim(POSICIONE("SA2",1,xFilial("SA2")+M->ZAA_FORNEC+M->ZAA_LOJA,"A2_NOME")) + "<br /><br />"
cConteudo +="</body>"
cConteudo +="</html>"

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )

If lEnviado
	MsgAlert("E-mail enviado com sucesso !! ")
Else
	MsgStop("E-mail nใo enviado !! Por favor, informar ao Fiscal a digita็ใo do Guia de Confer๊ncia.")
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidTOK   บ Autor ณ Gustavo Costa    บ Data ณ  25/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo no Ok da enchoicebar.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidTOK()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GravaDados บ Autor ณ Gustavo Costa    บ Data ณ  25/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava as informa็๕es nas tabelas ZAA e ZAB                 บฑฑ
ฑฑบ          ณ 				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GravaDados(aCabec,aItens)

BEGIN TRANSACTION

RecLock("ZAA",.T.)
For nX := 1 to Len(aCabec)
	
	If !empty(aCabec[nX][2])
		cCampo		:= Alltrim("ZAA->"+aCabec[nX][1])
		Replace &cCampo With aCabec[nX][2]
	EndIf
	
Next nX
ZAA->(MsUnlock())

For nY := 1 to Len(aItens)
	
	aProd := aItens[nY]
	
	RecLock("ZAB",.T.)
	For nZ := 1 to Len(aProd)
		If !empty(aProd[nZ][2])
			cCampo	:= Alltrim("ZAB->"+aProd[nZ][1])
			Replace &cCampo With aProd[nZ][2]
		EndIf
	Next nZ
	ZAB->(MsUnlock())
	
Next nY

END TRANSACTION

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ AlteraZAA()                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Executa as altera็๕es na ZAA.			                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AlteraZAA(nOpc)

Local nCont  	:= 0
Local aCampos 	:= {}
Local nUsado
Local aArea		:= getArea()

ZAA->(dbSetOrder(1))

dbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZAA")
aCampos:={}
While !Eof().And.(x3_arquivo=="ZAA")
	//	If X3USO(x3_usado).And.cNivel>=x3_nivel
	Aadd(aCampos,{ TRIM(x3_titulo), x3_campo, x3_picture,;
	x3_tamanho, x3_decimal,"AllwaysTrue()",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	//	Endif
	dbSkip()
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSo chama a rotina se for ALTERACAOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nOpc == 5
	RecLock("ZAA",.F.)
	dbDelete()
	ZAA->(MsUnlock())
Else
	
	RecLock("ZAA",.T.)
	For nX := 1 to Len(aCampos)
		
		If !empty(aCampos[nX][2]) .AND. aCampos[nX][2] <> "ZAA_STATUS" .AND. aCampos[nX][2] <> "ZAA_NOMFOR"
			cCampo		:= Alltrim("ZAA->"+aCampos[nX][2])
			cConteudo	:= "M->" + aCampos[nX][2]
			Replace &cCampo With &cConteudo
		EndIf
		
	Next nX
	ZAA->(MsUnlock())
	
EndIf

RestArea(aArea)

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ AlteraZAB()                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Executa as altera็๕es na ZAB.			                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AlteraZAB(nOpc)

Local nCont  	:= 0
Local nQtd  	:= 0
Local nValUnit  := 0
Local nFator	:= 0
Local cProdF 	:= ""
Local cProd		:= ""
Local cItem		:= ""
Local cDoc		:= ""
Local cLocal	:= ""
Local cDesc		:= ""
Local cSeq		:= ""
Local cUM		:= ""
Local cSerie	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cPedido	:= ""
Local cItemPC	:= ""

ZAB->(dbSetOrder(1))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSo chama a rotina se for ALTERACAOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava os novos registros na tabela ZAB          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nCont := 1 to Len(aCols)
	If !aCols[nCont][nUsado+1] // Verifica se o item estแ deletado.
		cProd		:= aCols[nCont][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_COD"})]
		cDesc		:= aCols[nCont][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_DESC"})]
		cItem		:= aCols[nCont][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_ITEM"})]
		cLocal		:= aCols[nCont][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_LOCAL"})]
		cUM			:= aCols[nCont][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_UM"})]
		cDoc		:= M->ZAA_DOC		//aCols[nCont][nPosDoc]
		cSeq		:= M->ZAA_SEQ		//aCols[nCont][nPosDoc]
		cFornece	:= M->ZAA_FORNEC	//aCols[nCont][nPosCFor]
		cLoja		:= M->ZAA_LOJA		//aCols[nCont][nPosLFor]
		cPedido		:= M->ZAA_PEDCOM	//aCols[nCont][nPosCFor]
		nQtd		:= aCols[nCont][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAB_QUANT"})]
		cItemPC		:= POSICIONE("SC7",2,XFILIAL("SC7") + cProd + cFornece + cLoja + cPedido, "C7_ITEM")
		
		If ZAB->( dbSeek(xFilial("ZAB") + cDoc + cSeq + cFornece + cLoja + cItem ) )
			
			If nOpc == 5
				RecLock('ZAB',.F.)
				dbDelete()
				ZAB->(MsUnLock())
			EndIf
		Else
			RecLock('ZAB',.T.)
			ZAB->ZAB_FILIAL 	:= xFilial("ZAB")
			ZAB->ZAB_ITEM 		:= cItem
			ZAB->ZAB_COD 		:= cProd
			ZAB->ZAB_DESC 		:= cDesc
			ZAB->ZAB_UM 		:= cUM
			ZAB->ZAB_QUANT 		:= nQtd
			ZAB->ZAB_LOCAL 		:= cLocal
			ZAB->ZAB_FORNEC 	:= cFornece
			ZAB->ZAB_LOJA 		:= cLoja
			ZAB->ZAB_DOC 		:= cDoc
			ZAB->ZAB_SEQ 		:= cSeq
			ZAB->ZAB_EMISSA 	:= dDataBase
			ZAB->ZAB_PEDIDO 	:= cPedido
			ZAB->ZAB_ITEMPC 	:= cItemPC
			ZAB->(MsUnLock())
		EndIf
		
	EndIf
Next nCont

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fxDeleta บ Autor ณ Gustavo Costa      บ Data ณ  25/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui a importacao do XML							      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fxDeleta()

Local nOpca := 0
Local aParam := {}
//Private aCpos :={"A1_COD","A1_LOJA","A1_NOME","A1_END", "A1_EST"}  // CAMPOS que serใo exibidos
Private  aButtons := {}
Private cCadastro := "EXCLUIR - Importacao do XML" // tํtulo da tela

//adiciona botoes na Enchoice
aAdd( aButtons, { "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Botใo Teste" } )

//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( aParam,  {|| U_ValExcl() } )  //antes da abertura
aAdd( aParam,  {|| U_TudoOK() } )  //ao clicar no botao ok
aAdd( aParam,  {|| U_Transaction() } )  //durante a transacao
aAdd( aParam,  {|| U_Fim() } )       //termino da transacao

dbSelectArea("ZF1")
//AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons,aParam,aAuto,lMaximized,cTela,aAcho,lPanelFin,oFather,aDim)
nOpca := AxDeleta("ZF1",ZF1->(Recno()),5,"U_Transaction",aCpos,aButtons,aParam,,.T.,,,,,)

Return nOpca

User function ValExcl()
Local lRet	:= .F.
If ZF1->F1_STATUS == "5"
	MsgAlert("Nใo ้ possํvel excluir um XML com Pre Nota gerada!")
	lRet	:= .T.
EndIf
Return lRet

User function Transaction()
MsgAlert("Chamada durante transacao")
Return .T.

User function Fim()
MsgAlert("Fim transacao")
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ atuGConf  บAutor  ณGustavo Costa      บ Data ณ  25/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o status do guia de conferencia da NFE.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function atuGConf(cDoc, cSeq)

Local cQuery

cQuery := " UPDATE " + RetSqlName("ZAA")
cQuery += " SET ZAA_STATUS = 'X' "
cQuery += " WHERE ZAA_FILIAL = '" + xFilial("ZAA") + "' "
cQuery += " AND	ZAA_DOC = '" + cDoc + "' "
cQuery += " AND ZAA_SEQ = '" + cSeq + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "

TcSqlExec(cQuery)

Return
