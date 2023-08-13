// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : COMR018
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 03/07/14 | Gustavo Costa     | Cadastro de solicitacao de verba contabil 
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
//#INCLUDE 'FONT.CH'
//#INCLUDE 'COLORS.CH'
#INCLUDE 'PROTHEUS.CH'
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} COMR018
Controla as solicitações de verba extra para o orçamento contabil.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     16/04/2014
/*/
//------------------------------------------------------------------------------------------
User Function COMR018()
//--< variáveis >---------------------------------------------------------------------------

//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
local cVldAlt := ".T." // Operacao: ALTERACAO
local cVldExc := ".T." // Operacao: EXCLUSAO

//trabalho/apoio
local cArq, cInd
local aStru := {}
private aRotina
Private cAlias	:= "ZB7"

//--< procedimentos >-----------------------------------------------------------------------
dbSelectArea(cAlias)
dbSetOrder(1)
//Titulo a ser utilizado nas operaÃ§Ãµes
private cCadastro := "Solicitação de Verba para Orçamento"
//------------------------------------------------------------------------------------------
// Array (tambem deve ser aRotina sempre) com as definicoes das opcoes
//que apareceram disponiveis para o usuario. Segue o padrao:
//aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;
//              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;
//              . . .
//              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }
// Onde: <DESCRICAO> - Descricao da opcao do menu
//       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas
//                     duplas e pode ser uma das funcoes pre-definidas
//                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA
//                     e AXDELETA) ou a chamada de um EXECBLOCK.
//                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-
//                     clarar uma variavel chamada CDELFUNC contendo
//                     uma expressao logica que define se o usuario po-
//                     dera ou nao excluir o registro, por exemplo:
//                     cDelFunc := 'ExecBlock("TESTE")'  ou
//                     cDelFunc := ".T."
//                     Note que ao se utilizar chamada de EXECBLOCKs,
//                     as aspas simples devem estar SEMPRE por fora da
//                     sintaxe.
//       <TIPO>      - Identifica o tipo de rotina que sera executada.
//                     Por exemplo, 1 identifica que sera uma rotina de
//                     pesquisa, portando alteracoes nao podem ser efe-
//                     tuadas. 3 indica que a rotina e de inclusao, por
//                     tanto, a rotina sera chamada continuamente ao
//                     final do processamento, ate o pressionamento de
//                     <ESC>. Geralmente ao se usar uma chamada de
//                     EXECBLOCK, usa-se o tipo 4, de alteracao.
//------------------------------------------------------------------------------------------
// aRotina padrao. Utilizando a declaracao a seguir, a execucao da
// MBROWSE sera identica a da AXCADASTRO:
//
// cDelFunc  := ".T."
// aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
//                { "Visualizar"   ,"AxVisual" , 0, 2},;
//                { "Incluir"      ,"AxInclui" , 0, 3},;
//                { "Alterar"      ,"AxAltera" , 0, 4},;
//                { "Excluir"      ,"AxDeleta" , 0, 5} }
//
//------------------------------------------------------------------------------------------

//--<  monta 'arotina' proprio >------------------------------------------------------------

aRotina := {;
		{ "Pesquisar", "AxPesqui", 0, 1},;
		{ "Visualizar", "AxVisual", 0, 2},;
		{ "Incluir", "AxInclui", 0, 3},;
		{ "Autoriza", "U_fAutoriz()", 0, 4},;
		{ "Exlcuir", "AxDeleta", 0, 5};
		}
//------------------------------------------------------------------------------------------
// Executa a funcao MBROWSE. Sintaxe:
//
// mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)
// Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera
//                        exibido. Para seguir o padrao da AXCADASTRO
//                        use sempre 6,1,22,75 (o que nao impede de
//                        criar o browse no lugar desejado da tela).
//                        Obs.: Na versao Windows, o browse sera exibi-
//                        do sempre na janela ativa. Caso nenhuma este-
//                        ja ativa no momento, o browse sera exibido na
//                        janela do proprio SIGAADV.
// Alias                - Alias do arquivo a ser "Browseado".
// aCampos              - Array multidimensional com os campos a serem
//                        exibidos no browse. Se nao informado, os cam-
//                        pos serao obtidos do dicionario de dados.
//                        E util para o uso com arquivos de trabalho.
//                        Segue o padrao:
//                        aCampos := { {<CAMPO>,<DESCRICAO>},;
//                                     {<CAMPO>,<DESCRICAO>},;
//                                     . . .
//                                     {<CAMPO>,<DESCRICAO>} }
//                        Como por exemplo:
//                        aCampos := { {"TRB_DATA","Data  "},;
//                                     {"TRB_COD" ,"Codigo"} }
// cCampo               - Nome de um campo (entre aspas) que sera usado
//                        como "flag". Se o campo estiver vazio, o re-
//                        gistro ficara de uma cor no browse, senao fi-
//                        cara de outra cor.
//------------------------------------------------------------------------------------------
//--< procedimentos >-----------------------------------------------------------------------
dbSelectArea(cAlias)
mBrowse( 6, 1, 22, 75, cAlias)


return

//------------------------------------------------------------------------------------------
/*
Valida a data inicial digitada.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------

User function fAutoriz()

Local aArea		:= GetArea()
Local cCampo		:= "ZB7->ZB7_APROV2"
Local lContinua	:= .T.
Local lOk			:= .F.

dbSelectArea("SX5")
dbSetOrder(1)

If !(dbSeek(xFilial("SX5") + "YH" + __CUSERID))
	MsgAlert("Usuário não autorizado!")
	lContinua	:= .F.
EndIf

If Alltrim(ZB7->ZB7_APROV1) == cUserName
	MsgAlert("Você já liberou este registro!")
	lContinua	:= .F.
EndIf	

If Empty(ZB7->ZB7_APROV2) .And. lContinua

	cCampo := "ZB7->ZB7_APROV2"

Else

	If Empty(ZB7->ZB7_APROV3)
	
		If Alltrim(ZB7->ZB7_APROV2) == cUserName
			MsgAlert("Você já liberou este registro!")
			lContinua	:= .F.
		EndIf	
		cCampo := "ZB7->ZB7_APROV3"

	Else
	
		MsgAlert("Registro já Liberado!")
		lContinua	:= .F.
		
	EndIf
	
EndIf

If lContinua

	If 	cCampo == "ZB7->ZB7_APROV3"
	
		dbSelectArea("CV1")
		dbSetOrder(1)
		
		If dbSeek(xFilial("CV1") + ZB7->ZB7_ORCMTO + ZB7->ZB7_CALEND + ZB7->ZB7_MOEDA + ZB7->ZB7_REVISA + ZB7->ZB7_SEQUEN + ZB7->ZB7_PERIOD )
			
			RecLock("CV1", .F.)
			
			Replace CV1->CV1_VALOR With ZB7->ZB7_VATUAL
			
			MsUnLock()
				
			lOk	:= .T.

			MsgAlert("Saldo Atualizado!")
			
		Else
		
			MsgAlert("Saldo Não localizado!")

		EndIf
	
	Else
	
		MsgAlert("Registro Liberado!")
	
	EndIf

	If lOk
	
		RecLock("ZB7", .F.)
		
		Replace &cCampo With cUserName
		
		MsUnLock()
	
	EndIf

EndIf

RestArea(aArea)

Return


//--< fim de arquivo >----------------------------------------------------------------------
