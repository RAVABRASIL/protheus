// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : COMC007
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 19/09/12 | TOTVS Developer Studio | Gerado pelo Assistente de C�digo
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#Include 'Protheus.ch'

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manuten��o de dados armazenados em ZB4.

@author    TOTVS Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     19/09/2012
/*/
//------------------------------------------------------------------------------------------
User Function COMC006()
//--< vari�veis >---------------------------------------------------------------------------
//--< vari�veis >---------------------------------------------------------------------------

//Indica a permiss�o ou n�o para a opera��o (pode-se utilizar 'ExecBlock')
local cVldAlt := ".T." // Opera��o: ALTERA��O
local cVldExc := ".T." // Opera��o: EXCLUS�O

//trabalho/apoio
local cAlias                                            

Private cCadastro  := OemToAnsi( "Autoriza��o de servi�o" )

//--< procedimentos >-----------------------------------------------------------------------
cAlias := "ZB4"
chkFile(cAlias)
dbSelectArea(cAlias)
//indices
dbSetOrder(1)
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
	{ "Alterar", "U_fMyAltD()", 0, 4},;
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
//--< fim de arquivo >----------------------------------------------------------------------

User Function fMyAltD()
       
AxAltera("ZB4",recno(),4)

RecLock("ZB4",.F.)

ZB4->ZB4_DATAA 	:= DDATABASE
ZB4->ZB4_HORAA	:= Left(time(),5)

MsUnLock()

Return

