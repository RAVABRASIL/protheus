#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FINC008  � Autor � Fl�via Rocha       � Data �  18/04/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para consulta dos Pedidos Liberados( permite visualizar��
���          � quem liberou estoque, cr�dito, a data e hora               ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro - Regina                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

**********************
User Function FINC008 
**********************


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cFiltro	:= ""
Local aIndexSC9	:= {} 
Local aCores		:= {	{ '!Empty(C9_NFISCAL)' , 'BR_VERMELHO'  },;	// Faturado
							{ 'Empty(C9_NFISCAL)'  , 'BR_VERDE' } }     //EM ABERTO
						


Private cCadastro := "Consulta a Libera��es Pedidos"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
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

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

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