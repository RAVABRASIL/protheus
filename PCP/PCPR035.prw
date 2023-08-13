// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPR035
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 14/03/14 | Gustavo Costa     | Cadastro de programação das máquinas
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
//#INCLUDE 'FONT.CH'
//#INCLUDE 'COLORS.CH'
#INCLUDE 'PROTHEUS.CH'
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} PCPR035
Permite a manutenção de dados armazenados em Z91 (Cadastro de programação das máquinas).

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     16/04/2014
/*/
//------------------------------------------------------------------------------------------
User Function PCPR035()
//--< variáveis >---------------------------------------------------------------------------

//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
local cVldAlt := ".T." // Operacao: ALTERACAO
local cVldExc := ".T." // Operacao: EXCLUSAO

//trabalho/apoio
local cAlias	:= "Z91"
local cArq, cInd
local aStru := {}
private aRotina
Private cAlias	:= "Z91"

//--< procedimentos >-----------------------------------------------------------------------
dbSelectArea(cAlias)
dbSetOrder(1)
//Titulo a ser utilizado nas operaÃ§Ãµes
private cCadastro := "Programação das Máquinas"
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
		{ "Copiar", "U_fAxCp35()", 0, 3},;
		{ "Alterar", "U_fAPCR35()", 0, 4},;
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

/*------------------------------------------------------------------------------------------
Valida o formato da hora digitado.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
User Function fVldHora(cID)

Local lRet		:= .T.
Local cCampo	:= "M->Z91_HORA" + Alltrim(UPPER(cID))

If Len(AllTrim(&cCampo)) < 8
	
	MsgAlert("O campo hora tem que está neste formato: HH:MM:SS !")
	lRet := .F.
	
EndIf

Return lRet

//------------------------------------------------------------------------------------------
/*
Valida a data final digitada.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
/*
User Function fxVldDTF()

Local lRet			:= .T.
Local cDifDias	:= Alltrim(Str(M->Z91_DATAF - M->Z91_DATAI))

//A diferenca entre os dias so pode está no mesmo dia = 0 ou no proximo dia = 1
If  !(cDifDias $ '0/1')
	
	MsgAlert("Data inválida! Só é possível colocar no mesmo dia inicial, ou no dia seguinte!")
	lRet := .F.
	
EndIf

Return lRet
*/
//------------------------------------------------------------------------------------------
/*
Altera o registro.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------

USER FUNCTION fAPCR35()
 
Local cAlias	:= "Z91"
LOCAL nReg    := ( cAlias )->( Recno() )
LOCAL aCpos  	:= {"Z91_HORAI","Z91_DATAF","Z91_HORAF","Z91_HORAD"}
 
AxAltera(cAlias,nReg,4,,aCpos)


RETURN NIL

//------------------------------------------------------------------------------------------
/*
Valida a data inicial digitada.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
User Function fVLdti()

Local lRet			:= .T.
Local aArea		:= getArea()

dbSelectArea("Z91")
dbSetOrder(1)
//Se encontrar alguma maquina com a mesma data inicial, impede o cadastro.
If  Z91->(dbSeek(xFilial("Z91") + M->Z91_RECURS + DtoC(M->Z91_DATAI)))
	
	MsgAlert("Data já cadastrada para este recurso!")
	lRet := .F.
	
EndIf

RestArea(aArea)

Return lRet


User function fAxCp35()

Local cRec
Local cHoraI
Local cHoraF
Local cHoraD
local dDataI
local dDataF

private nQdias := 0

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Quantidade de dias para cópia",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Quantos dias?"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,nQdias:=u,nQdias)},oDlg99,060,010,'@E 999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nQdias",,)
oSBtn1     := SButton():New( 008,080,1,{|| oDlg99:End() },oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

cRec		:= Z91->Z91_RECURS 
cHoraI		:= Z91->Z91_HORAI 
cHoraF		:= Z91->Z91_HORAF
cHoraD		:= Z91->Z91_HORAD
dDataI		:= Z91->Z91_DATAI
dDataF		:= Z91->Z91_DATAF

For x := 1 to nQdias

	dDataI := dDataI + 1
	dDataF := dDataF + 1

	If  Z91->(!dbSeek(xFilial("Z91") + cRec + DtoC(dDataI)))
		
		RecLock("Z91", .T.)
		
		Z91->Z91_FILIAL	:= xFilial("Z91")
		Z91->Z91_RECURS	:= cRec
		Z91->Z91_HORAI 	:= cHoraI
		Z91->Z91_HORAF	:= cHoraF
		Z91->Z91_HORAD	:= cHoraD
		Z91->Z91_DATAI	:= dDataI
		Z91->Z91_DATAF	:= dDataF
		
		MsUnLock()
		
	EndIf

nEXT

MsgAlert("Registros Copiado(s)!")

Return




//--< fim de arquivo >----------------------------------------------------------------------
