#INCLUDE "rwmake.ch"
#Include 'Topconn.ch'
#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCPR042  º Autor ³ Gustavo Costa.     º Data ³  14/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Controle de estoque das bobinas.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS / PCP                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR042()

//--< variáveis >---------------------------------------------------------------------------

//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
local cVldAlt := ".T." // Operacao: ALTERACAO
local cVldExc := ".T." // Operacao: EXCLUSAO

//trabalho/apoio
local cAlias	:= "ZB9"
local cArq, cInd
local aStru := {}
private aRotina
Private cAlias	:= "ZB9"

//--< procedimentos >-----------------------------------------------------------------------
dbSelectArea(cAlias)
dbSetOrder(1)
//Titulo a ser utilizado nas operaÃ§Ãµes
private cCadastro := "Controle de estoque das bobinas."
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
		{ "Imprimir", "U_fPrtZB9()", 0, 3};
		}


//------------------------------------------------------------------------------------------
// Executa a funcao MBROWSE. Sintaxe:
//
//		{ "Alterar", "U_fAltPCR35()", 0, 4},;
//		{ "Exlcuir", "AxDeleta", 0, 5};
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
Imprime o relatório de saldo das bobinas.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     18/11/2014
/*/
//------------------------------------------------------------------------------------------
User Function fPrtZB9()

Local cPerg	:= 'PCPR42'

criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg, .T.)

oReport:= ReportDef()
oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FINR013  ³ Autor ³ Gustavo Costa          ³ Data ³23.05.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio retorno da cobrança.                               .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function ReportDef()

Local oReport
Local oSection1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= TReport():New("PCPR42","Saldo das Bobinas","PCPR42", {|oReport| ReportPrint(oReport)},"Este relatório irá listar o saldo das bobinas.")

//oReport:SetLandscape()
oReport:SetTotalInLine(.T.)
oReport:PageTotalInLine(.T.)
oReport:SetPortrait()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"Data",{"ZB9"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/,/*uTotalText*/,.T.) 
//oParent,cTitle,uTable,aOrder,lLoadCells,lLoadOrder,uTotalText,lTotalInLine,lHeaderPage,lHeaderBreak,lPageBreak,lLineBreak,nLeftMargin,lLineStyle,nColSpace,lAutoSize,cCharSeparator,nLinesBefore,nCols,nClrBack,nClrFore,nPercentage

TRCell():New(oSection1,'ZB9_COD'	,'','Codigo'	,/*Picture*/	,15		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZB9_DESC'	,'','Produto'	,/*Picture*/	,50		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZB9_SEQ'	,'','Seq.'		,/*Picture*/	,06		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ZB9_SALDO'	,'','Saldo'	,"@E 9,999,999.99"	,12		,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSection1:Cell("ZB9_SALDO"),NIL,"SUM",/*oBreak*/,"Saldo Total",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)

oReport:EndReport() := .T.

Return(oReport)


Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
oReport:SkipLine()
oReport:ThinLine()
oReport:SkipLine()
*/
cQuery := " SELECT * FROM " + RetSqlName("ZB9") + " ZB9 "
cQuery += " WHERE ZB9_FILIAL =  '" + xFilial("ZB9") + "'"
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " AND ZB9_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
If mv_par03 = 1 //Sim
	
	cQuery += " AND ZB9_SALDO > 0 "

EndIf

MemoWrite("C:\TEMP\fPrtZB9.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "TMP"

dbselectArea("TMP")
nCount	:= TMP->(RECCOUNT())
TMP->( DbGoTop() )
		
oReport:SetMeter(nCount)

oSection1:Init()

While !oReport:Cancel() .And. TMP->(!EOF())

	oSection1:Cell("ZB9_COD"):SetValue(TMP->ZB9_COD)
	oSection1:Cell("ZB9_COD"):SetAlign("CENTER")
	oSection1:Cell("ZB9_DESC"):SetValue(TMP->ZB9_DESC)
	oSection1:Cell("ZB9_DESC"):SetAlign("LEFT")
	oSection1:Cell("ZB9_SEQ"):SetValue(TMP->ZB9_SEQ)
	oSection1:Cell("ZB9_SEQ"):SetAlign("CENTER")
	oSection1:Cell("ZB9_SALDO"):SetValue(TMP->ZB9_SALDO)
	oSection1:Cell("ZB9_SALDO"):SetAlign("RIGHT")
	
	oSection1:PrintLine()

	TMP->(dbSkip())
	
EndDo

oSection1:Finish()

Return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Do Produto?'     	, '', '', 'mv_ch1', 'C', 8                     	, 0, 0, 'G', '', 'SB1'  	, '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Codigo do produto inicial"},{},{})
putSx1(cPerg, '02', 'Até Produto?'  	, '', '', 'mv_ch2', 'C', 8                     	, 0, 0, 'G', '', 'SB1'  	, '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Codigo do produto final"},{},{})
putSx1(cPerg, '03', 'Imp. Saldo Zero?'	, '', '', 'mv_ch3', 'N', 1                     	, 0, 0, 'C', '', ''	 	, '', '', 'mv_par03','Sim','','','','Não','','','','','','','','','','','',{"Escolha uma opcao"},{},{})
//putSx1(cPerg, '04', 'Meta Mês?'   		, '', '', 'mv_ch4', 'N', 12                     	, 2, 0, 'G', '', ''	 , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Informe o valor da meta mês."},{},{})
//putSx1(cPerg, '03', 'Do Recurso?'     	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Recurso inicial"},{},{})
//putSx1(cPerg, '04', 'Até Recurso?'    	, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Recurso final"},{},{})

return  

//------------------------------------------------------------------------------------------
/*
Valida a data final digitada.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
User Function VldDTFim()

Local lRet			:= .T.
Local cDifDias	:= Alltrim(Str(M->Z91_DATAF - M->Z91_DATAI))

//A diferenca entre os dias so pode está no mesmo dia = 0 ou no proximo dia = 1
If  !(cDifDias $ '0/1')
	
	MsgAlert("Data inválida! Só é possível colocar no mesmo dia inicial, ou no dia seguinte!")
	lRet := .F.
	
EndIf

Return lRet

//------------------------------------------------------------------------------------------
/*
Altera o registro.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------

USER FUNCTION fAltPCR35()
 
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
User Function fVLDdti()

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


User function fAxCopy35()

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
