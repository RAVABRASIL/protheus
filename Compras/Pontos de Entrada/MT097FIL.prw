
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097FIL  �Autor  �Gustavo Costa       � Data �  10/26/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE Utilizado para filtrar os registros da mBrowse da       ���
���          � libera��o do pedido de compra.                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT097FIL() 

Local cRet := ''

Do Case
//Humberto
Case __cUserId == '000279'

	cRet :=  " SUBSTR( POSICIONE('SC7',1,xFilial('SC7') + Alltrim(CR_NUM),'C7_CC'),1,1)  <> '7'   "

//Orley
Case __cUserId == '000287'

	cRet :=  " SUBSTR( POSICIONE('SC7',1,xFilial('SC7') + Alltrim(CR_NUM),'C7_CC'),1,1)  == '7'   "

Otherwise

	Return nil
	
EndCase

Return cRet