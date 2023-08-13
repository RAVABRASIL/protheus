#INCLUDE "rwmake.ch"
#INCLUDE 'COLORS.CH'
//#INCLUDE "MATA030.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATC022 - Confer�ncia de Produtos     � Data �  11/11/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���Autoria   � Fl�via Rocha                                               ���
�������������������������������������������������������������������������͹��
���Solicitado por � Chamado: 002282 - Marcelo em 16/08/2011               ���
���                 Criar bloqueio no lancamento de Pedido de Vendas,     ��� 
���                 para que o sistema nao permita a indica��o de Clientes��� 
���                 e Produtos sem conferencia.                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

**************************
User Function FATC022()  
**************************

Local aIndexSB1 := {}
Local cFiltraSB1:= ""									// Express�o do filtro 
Local nTamanho  := 0
Local nPos		:= 0
Local cPos		:= "" 

Private aRotina		:= {}									// Array com as op��es da rotina
Private bFiltraBrw	:= {|| Nil}	  
PRIVATE ALTERA 	  

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Confer�ncia de Produtos"
       

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Conferir","U_fConfP()",0,4},;
             {"&Legenda","U_FATC022Leg()", 0, 5} }
             
             

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SB1" 
Private aCampos := {}

cFiltro1 := ""
nTamanho := Len(Alltrim(SB1->B1_COD))
nPos     := nTamanho - 3  // 4
cPos	 := str(nPos)
cFiltraSB1 := " LEN(ALLTRIM(B1_COD)) <= 7 "    //mostra produtos n�o-gen�ricos


If !Empty(cFiltraSB1)
	bFiltraBrw	:= { || FilBrowse("SB1", @aIndexSB1, @cFiltraSB1) }
	Eval(bFiltraBrw)
EndIf  


dbSelectArea("SB1")
dbSetOrder(1)

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
//                         essa ordem acima t� inversa - FR - 09/11/11
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������  

aCampos := { {"Dt.Conferido", "B1_DTCONFE"},; 
			{"Conferido Por", "B1_USRCONF"},; 
			{"Codigo", "B1_COD"},;           
            {"Descricao"  ,"B1_DESC"} }  

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString, aCampos ,"B1_CONFERI")

Return

****************************
User Function fConfP( ) 
****************************

Local nOpcA := 0
Local nReg  := SB1->(RECNO())
Local nOpc  := 4
Local aButtons := {}
Local cAlias := "SB1"
Private aRotAuto := Nil
Private lCopia := .F.


If SB1->B1_CONFERI != "S"

	nOpcA:= AxAltera( cAlias, nReg, nOpc,,,,,"A010TUDOOK()" ,,,aButtons)

	If nOpcA = 1
	   //If MsgYesNo("Deseja Confirmar a Confer�ncia deste Cadastro ?","CONFER�NCIA OK")
	   		RecLock("SB1",.F.)
	   		SB1->B1_CONFERI := "S"
	   		SB1->B1_USRCONF := Substr(cUsuario,7,15)
	   		SB1->B1_DTCONFE := Date()
	   		SB1->(MsUnlock() )
	   		Msginfo("Cadastro Conferido com SUCESSO !!")
	   //Endif
	Endif
Endif

Return


******************************************************************************************************
User Function FATC022Leg()
******************************************************************************************************


BrwLegenda( "Legenda", cCadastro, { {"BR_VERMELHO", "Conferido"},{"BR_VERDE", "SEM Conferir"} })

Return(Nil)



