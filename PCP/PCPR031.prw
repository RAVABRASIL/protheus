// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPR031
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 14/03/14 | Gustavo Costa     | Cadastro de Tara
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'PROTHEUS.CH'
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} PCPR031
Permite a manutenção de dados armazenados em ZZ1 (Cadastro de tara).

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     14/03/2014
/*/
//------------------------------------------------------------------------------------------
User Function PCPR031()
//--< variáveis >---------------------------------------------------------------------------

//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
local cVldAlt := ".T." // Operacao: ALTERACAO
local cVldExc := ".T." // Operacao: EXCLUSAO

//trabalho/apoio
local cAlias	:= "ZZ1"
local cArq, cInd
local aStru := {}
private aRotina

//--< procedimentos >-----------------------------------------------------------------------
dbSelectArea(cAlias)
dbSetOrder(1)
//Titulo a ser utilizado nas operaÃ§Ãµes
private cCadastro := "Cadastro de Taras"
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
		{ "Etiqueta", "U_fImpEtq()", 0, 2},;
		{ "Visualizar", "AxVisual", 0, 2},;
		{ "Incluir", "AxInclui", 0, 3},;
		{ "Alterar", "AxAltera", 0, 4},;
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
/*/{Protheus.doc} doLoadData
Efetua a carga de dados a tabela de trabalho

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
User Function fImpEtq()

Local cPorta	:= "LPT1"  
Local nQuant	:= fQtdImp()
Local cCodBar	:= ZZ1->ZZ1_COD

//MSCBPRINTER("TLP 2844",cPorta,,,.F.) //TLP 2844 
MSCBPRINTER("ZEBRA",cPorta,NIL,,.F.,,,,,,.T.)

For i := 1 To nQuant
	
	//MSCBINFOETI("Etiqueta Termica EXPEDICAO","MODELO 1") 
	MSCBBEGIN(1,1)                             
	 
	//MSCBBOX(02,01,76,35)
	MSCBBOX(02,04,100,55,8)
	
	
	MSCBLineH(02,17,100,3,"B")
	//MSCBLineV(30,01,13)
	
	//MSCBSAY(04,08,"NOME: " + ZZ1->ZZ1_DESC,"N","3","2,2") 
	MSCBSAY(04,08,"NOME: "+ZZ1->ZZ1_DESC,"N","0","40")
	MSCBSAYBAR(35,20,cCodBar,"N","MB07",20,.F.,.F.,.F.,,3,1)
	
	MSCBEND() 
	
	sleep(200)  

Next

MSCBCLOSEPRINTER() 

//Alert("Enviado para impressora")    

Return

***************
Static Function fQtdImp()
***************

private nPesoMan := 0

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Quantidade de Etiquetas",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Quantidade:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,nPesoMan:=u,nPesoMan)},oDlg99,060,010,'@E 999',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nPesoMan",,)
oSBtn1     := SButton():New( 008,080,1,{||oDlg99:End()},oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return nPesoMan

//--< fim de arquivo >----------------------------------------------------------------------
