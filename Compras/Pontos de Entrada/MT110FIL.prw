#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110FIL  � Autor � Gustavo Costa      � Data �  12/04/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Filtro no browser da Fun��o da Solicita��o de Compras.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT110FIL()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cFiltro := ''

//cFiltro := "  C1_APROV  == 'L' "
//cFiltro += "  .And. C1_RESIDUO  == ' ' " 

dbSelectArea("SX5")

If SX5->(dbSeek(xFilial("SX5") + "YY" + __cUserId))
	
	cTipos	:= Alltrim(SX5->X5_DESCRI) + ',' + Alltrim(SX5->X5_DESCSPA) + ',' + Alltrim(SX5->X5_DESCENG) 

	cFiltro += " Alltrim(C1_TPPROD) $ '" + cTipos + "' "  

EndIf

Return (cFiltro)
