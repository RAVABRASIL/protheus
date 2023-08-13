#Include 'Protheus.ch'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun����o    � fNewMat � Autor � Gustavo Costa     � Data �  08/04/13  ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao pegar o sequencial corrigido da matricula na inclusao ���
���          � .                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fNewMat()

Local cQuery	:= ''
Local cRet		:= ""

cQuery := " SELECT TOP 1 RA_MAT "
cQuery += " FROM " + RetSqlName("SRA")
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND RA_MAT < '06' "
cQuery += " AND RA_FILIAL = '" + xFilial("SRA") + "' "
cQuery += " ORDER BY RA_MAT DESC "


If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

cRet	:= StrZero(Val(TMP->RA_MAT) + 1,5)

DbCloseArea()

Return cRet