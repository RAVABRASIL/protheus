#INCLUDE "rwmake.ch"         
#Include "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M130FIL  � Autor � Gustavo Costa      � Data �  13/06/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Adiciona Dados ao Filtro                                   ���
���          �  ( [ PARAMIXB ] ) --> aRet                                 ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************************
User Function M130FIL()   
*************************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cFiltro := ''

//cFiltro := "  C1_APROV  == 'L' "
//cFiltro += "  .And. C1_RESIDUO  == ' ' " 
/*
dbSelectArea("SX5")

If SX5->(dbSeek(xFilial("SX5") + "YY" + __cUserId))
	
	cTipos	:= Alltrim(SX5->X5_DESCRI) + ',' + Alltrim(SX5->X5_DESCSPA) + ',' + Alltrim(SX5->X5_DESCENG) 

	cFiltro += " Alltrim(C1_TPPROD) $ '" + cTipos + "' "  

EndIf
*/
Return (cFiltro)
