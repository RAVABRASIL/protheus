#INCLUDE "rwmake.ch"
#INCLUDE 'COLORS.CH'
//#INCLUDE "MATA030.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATC021 - Confer�ncia de Clientes     � Data �  09/11/11   ���
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
User Function FATC021()   
**************************

Local aIndexSA1 := {}
Local cFiltraSA1:= ""									// Express�o do filtro

Private aRotina		:= {}									// Array com as op��es da rotina
Private bFiltraBrw	:= {|| Nil}		  


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Confer�ncia de Clientes"
//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Conferir","U_fConfere()",0,3},;
 			 {"&Legenda","U_FATC021Leg()", 0, 5} }

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SA1" 
Private aCampos := {}

dbSelectArea("SA1")
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

			
aCampos := { {"Dt.Conferido", "A1_DTCONFE"},; 
			{"Conferido Por", "A1_USRCONF"},; 
			{"Codigo", "A1_COD"},;        
           	{"Loja"  ,"A1_LOJA"},;  
            {"Nome"  ,"A1_NOME"} }
            

cFiltraSA1	:= "A1_ATIVO != 'N' "  //mostra apenas os clientes ATIVOS


If !Empty(cFiltraSA1)
	bFiltraBrw	:= { || FilBrowse("SA1", @aIndexSA1, @cFiltraSA1) }
	Eval(bFiltraBrw)
EndIf  

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString, aCampos ,"A1_CONFERI")

EndFilBrw( "SA1" , aIndexSA1 ) //Inclua esta linha para que o filtro seja liberado....

Return

****************************
User Function fConfere() 
****************************

Local nOpcA := 0
Local nReg  := SA1->(RECNO())
Local nOpc  := 3
Local aButtons := {}
Local cAlias   := "SA1"
LOCAL lACAtivo  := GetNewPar("MV_ACATIVO", .F.) 
Private aRotAuto := Nil

//aadd(aButtons,{"WEB",{|| fGeoWizard("SA1",M->A1_COD+M->A1_LOJA,{"M->A1_END","M->A1_MUN","M->A1_EST","M->A1_CEP","M->A1_BAIRRO"},{|lContinua| CodGeoRev(aCoor,NIL,@lContinua)[6] <> M->A1_CEP })},"teste1", "teste2" })	
//aadd(aButtons,{"BMPVISUAL",{|| fConsWizard({M->A1_NOME, M->A1_PESSOA, M->A1_NREDUZ, M->A1_END, M->A1_CEP, M->A1_DDD, M->A1_TEL, M->A1_CGC, M->A1_RG, M->A1_DTNASC})},"teste3", "teste4" })

If SA1->A1_CONFERI != "S"

	nOpcA := AxAltera(cAlias,nReg,nOpc,/*aAcho*/,/*aCpos*/,/*nColMens*/,/*cMensagem*/,	/*iif(!lAcativo, "MA030TudOk()", "MA030TudOk() .And. AC700ALTALU()")*/,/*cTransact*/,/*cFunc*/,aButtons,/*aParam*/,aRotAuto,/*lVirtual*/)
	If nOpcA = 1
	   //If MsgYesNo("Deseja Confirmar a Confer�ncia deste Cadastro ?","CONFER�NCIA OK")
	   		RecLock("SA1",.F.)
	   		SA1->A1_CONFERI := "S"
	   		SA1->A1_USRCONF := Substr(cUsuario,7,15)
	   		SA1->A1_DTCONFE := Date()
	   		SA1->(MsUnlock() )
	   		Msginfo("Cadastro Conferido com SUCESSO !!")
	   //Else
	   //		Return
	   //Endif
	Endif
//Else
	//MsgInfo("Cadastro J� FOI CONFERIDO !")
Endif

Return 




******************************************************************************************************
User Function FATC021Leg()
******************************************************************************************************


BrwLegenda( "Legenda", cCadastro, { {"BR_VERMELHO", "Conferido"},{"BR_VERDE", "SEM Conferir"} })

Return(Nil)