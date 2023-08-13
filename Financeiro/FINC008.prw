#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FINC008  บ Autor ณ Flแvia Rocha       บ Data ณ  18/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para consulta dos Pedidos Liberados( permite visualizarฑฑ
ฑฑบ          ณ quem liberou estoque, cr้dito, a data e hora               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro - Regina                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

**********************
User Function FINC008 
**********************


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cFiltro	:= ""
Local aIndexSC9	:= {} 
Local aCores		:= {	{ '!Empty(C9_NFISCAL)' , 'BR_VERMELHO'  },;	// Faturado
							{ 'Empty(C9_NFISCAL)'  , 'BR_VERDE' } }     //EM ABERTO
						


Private cCadastro := "Consulta a Libera็๕es Pedidos"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }
*/

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2},;
             {"Legenda","U_FNC008Leg",0,5} }


Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SC9"
Private bFiltraBrw := {} 
Private aCampos    := {}

dbSelectArea("SC9")
dbSetOrder(1)

//cPerg   := "Z3"

//Pergunte(cPerg,.F.)
//SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa a funcao MBROWSE. Sintaxe:                                  ณ
//ณ                                                                     ณ
//ณ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ณ
//ณ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ณ
//ณ                        exibido. Para seguir o padrao da AXCADASTRO  ณ
//ณ                        use sempre 6,1,22,75 (o que nao impede de    ณ
//ณ                        criar o browse no lugar desejado da tela).   ณ
//ณ                        Obs.: Na versao Windows, o browse sera exibi-ณ
//ณ                        do sempre na janela ativa. Caso nenhuma este-ณ
//ณ                        ja ativa no momento, o browse sera exibido naณ
//ณ                        janela do proprio SIGAADV.                   ณ
//ณ Alias                - Alias do arquivo a ser "Browseado".          ณ
//ณ aCampos              - Array multidimensional com os campos a serem ณ
//ณ                        exibidos no browse. Se nao informado, os cam-ณ
//ณ                        pos serao obtidos do dicionario de dados.    ณ
//ณ                        E util para o uso com arquivos de trabalho.  ณ
//ณ                        Segue o padrao:                              ณ
//ณ                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     . . .                           ณ
//ณ                                     {<CAMPO>,<DESCRICAO>} }         ณ
//ณ                        Como por exemplo:                            ณ
//ณ                        aCampos := { {"TRB_DATA","Data  "},;         ณ
//ณ                                     {"TRB_COD" ,"Codigo"} }         ณ
//ณ cCampo               - Nome de um campo (entre aspas) que sera usadoณ
//ณ                        como "flag". Se o campo estiver vazio, o re- ณ
//ณ                        gistro ficara de uma cor no browse, senao fi-ณ
//ณ                        cara de outra cor.                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//aCampos := { {"Data", "X5_CHAVE"},; 
//			{"Valor MP", "X5_DESCRI"} }   
			
aCampos := { {"Pedido", "C9_PEDIDO"},; 
			{"Dt.Lib.Credito", "C9_DTBLCRE"},;
			{"Hora Lib.Credito", "C9_HRBLCRE"},;
			{"Quem Lib.Credito", "C9_USRLBCR"},;
			{"Dt.Lib.Estoque", "C9_DTBLEST"},;
			{"Hora Lib.Estoque", "C9_HRBLEST"},;
			{"Quem Lib.Estoque", "C9_USRLBES"} }


cFiltro	:= ""  //"X5_TABELA = 'Z3' "


If !Empty(cFiltro)
	bFiltraBrw	:= { || FilBrowse("SC9", @aIndexSC9, @cFiltro) }
	Eval(bFiltraBrw)
EndIf


dbSelectArea(cString)
//mBrowse( 6,1,22,75,cString, aCampos)
mBrowse( 6, 1,22,75, cString, aCampos,,,,,aCores)

//Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
If !Empty(cFiltro)
	EndFilBrw("SC9", aIndexSX5)
EndIf

Return

******************************************************************************************************
User Function FNC008Leg()
******************************************************************************************************



BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"Pedido Faturado"} ,;
									{"BR_VERDE" ,	"Pedido em Aberto"} } )

Return .T.