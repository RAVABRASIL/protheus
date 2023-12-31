#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �         � Autor �                       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
***************************************************
User Function PCPC22(xAutoCab,xAutoItens,nOpcAuto)
***************************************************

Local aCores := {{"Z93_QTDLIB = 0"                      , "BR_VERDE"},;
        			  {"Z93_QTDLIB > 0 .AND. Z93_QTDLIB < 10", "BR_AMARELO"},;
				     {"Z93_QTDLIB = 10"                     , "BR_VERMELHO"}}

//Rotina Automatica
Private lCdaAuto := xAutoCab <> NIL .And. xAutoItens <> NIL
Private aRotina := {{"Pesquisar" , "AxPesqui" , 0, 1},;
                    {"Visualizar", "U_PCPC21" , 0, 2},;
                    {"Incluir"   , "U_PCPC21" , 0, 3},;
                    {"Alterar"   , "U_PCPC21" , 0, 4},;
                    {"Excluir"   , "U_PCPC21" , 0, 5},;                    
                    {"Impress�o" , "U_IMPC21" , 0, 6},;                    
                    {"Legenda"   , "U_LegInsp", 0, 6}}

Private cCadastro := OemToAnsi( "Cadastro de Inspe��o de Sobrepeso" )
Private cAlias1   := "Z94"	    // Alias de detalhe
Private lSemItens := .F.		// Permite a nao existencia de itens
Private cChave	   := "Z93_DOC"  // Chave que ligara a primeira tabela com a segunda
Private cChave1	:= "Z94_DOC"  // Chave que ligara a segunda tabela com a primeira
Private aChaves   := {{"Z94_DOC", "M->Z93_DOC"}}
Private cLinhaOk  := "AllwaysTrue()" //Funcao LinhaOk para a GetDados
Private cTudoOk   := "AllwaysTrue()" //Funcao TudoOk para a GetDados

DbSelectArea("Z93")
DbSetOrder(1)

if ( Type("lCdaAuto") <> "U" .And. lCdaAuto )
   aAutoCab   := xAutoCab
   aAutoItens := xAutoItens
   MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"Z93")
   xAutoCab   := aAutoCab
   xAutoItens := aAutoItens
else
   mBrowse( 06, 01, 22, 75, "Z93",,,,,,aCores )
endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LegPedInt �Autor  �Eurivan Marques     � Data �  18/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Legenda da MBrowse do cadastro de Pedidos de Internet.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LegProj                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LegInsp()

Local aLegenda	:= {{"BR_VERDE"   ,"Inspecao Aberta" },;
                   {"BR_AMARELO" ,"Inspecao com Saldo" },;		
                   {"BR_VERMELHO","Inspecao Fechada" }}

BrwLegenda("Inspecao Sobrepeso","Legenda",aLegenda)		   		

Return .T.