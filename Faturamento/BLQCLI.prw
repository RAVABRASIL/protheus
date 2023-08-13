#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

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
��              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
***********************
User Function BLQCLI()
***********************

Local aCores := {{"A1_BLQXDD $ ' /N'", "BR_VERDE"},;
	   			 {"A1_BLQXDD == 'S'", "BR_VERMELHO"}}

aRotina := {{"Pesquisar"   , "AxPesqui" , 0, 1},;
            {"Visualizar"  , "axVisual" , 0, 2},;
            {"Bloqueia"    , "U_BloCli(1)", 0, 4},;
            {"Desbloqueia" , "U_BloCli(2)", 0, 4},;
            {"Legenda"     , "U_LegCli"   , 0, 6}}

cCadastro := OemToAnsi("Bloqueio/Desbloqueio de Clientes")

DbSelectArea("SA1")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "SA1",,,,,,aCores )

Return

***************************
User Function BloCli(nOpc)
***************************
local lVolta := .F.

if nOpc = 1
   if SA1->A1_BLQXDD $ " /N"
      RecLock("SA1")
      SA1->A1_BLQXDD := "S"
      SA1->(MsUnlock())
   else
      Aviso("Aten��o","Cliente ja est� bloqueado.", {"Ok"} )
   endif   
elseif nOpc = 2

   if SA1->A1_BLQXDD == "S"
      RecLock("SA1")
      SA1->A1_BLQXDD := "N"
      SA1->(MsUnlock())

      lVolta := MsgYesNo("Deseja bloquea-lo ap�s pr�ximo Faturamento?")
      RecLock("SA1")
      if lVolta
         SA1->A1_BKBLQ := "S"
      else
         SA1->A1_BKBLQ := "N"
      endif
      SA1->(MsUnlock())    
   else
      Aviso("Aten��o", "Cliente sem bloqueio.",{"OK"} )   
   endif
endif
   
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LegCli    �Autor  �Eurivan Marques     � Data �  27/05/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Legenda da MBrowse do cadastro de Clientes                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �LegCli                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
***********************
User Function LegCli()
***********************

Local aLegenda := {{"BR_VERDE"   ,"Cliente sem bloqueio"},;
	   			   {"BR_VERMELHO","Cliente bloqueado"}}


BrwLegenda("Clientes","Legenda",aLegenda)		   		

Return .T.

