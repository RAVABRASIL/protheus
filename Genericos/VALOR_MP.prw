#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALOR_MP � Autor � Fl�via Rocha       � Data �  06/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para consulta do VALOR MP                             ���
���          � (que fica cadastrada no SX5)                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function VALOR_MP


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cFiltro	:= ""
Local aIndexSX5	:= {}

Private cPerg   := "Z3"
Private cCadastro := "Cadastro de Valor MP"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

//Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SX5"
Private bFiltraBrw := {} 
Private aCampos    := {}

dbSelectArea("SX5")
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
			
aCampos := { {"Data", "Substr(X5_CHAVE,5,2) + '/' + Substr(X5_CHAVE,1,4)"},; 
			{"Valor MP", "X5_DESCRI"} }


cFiltro	:= "X5_TABELA = 'Z3' "


If !Empty(cFiltro)
	bFiltraBrw	:= { || FilBrowse("SX5", @aIndexSX5, @cFiltro) }
	Eval(bFiltraBrw)
EndIf


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString, aCampos)

//Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
If !Empty(cFiltro)
	EndFilBrw("SX5", aIndexSX5)
EndIf

Return
