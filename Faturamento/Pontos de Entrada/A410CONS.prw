#INCLUDE 'RWMAKE.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMISS    �Autor  �Eurivan Marques     � Data �  15/04/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �GAtilho para atualizacao do valor da Comissao do Representan���
���          �te 10% 1o Compra; 08% 2o Compra; 6% 3o Compra               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*************

User Function  A410CONS()

*************

Local aButtons:={}
Public _lCntAlt:=.T.
Public _cJustCom:=space(200)
public cPrePed:=space(6) // variavel do Pre-Pedido
//public cSolAmo:=space(6)             

//aadd(aButtons,{"VENDEDOR",{|| U_FATC006()},"Pre-Pedido",""})  
//aadd(aButtons,{"S4WB009N",{|| U_SoliPed()},"Solicita��o Amostra",""})  

Aadd(aButtons , {'TESTE' ,{|| U_FATC006() },"Pre-Pedido" } ) 

Return aButtons

