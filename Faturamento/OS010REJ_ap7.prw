#include "rwmake.ch"
#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � OS010REJ � Autor � Esmerino Neto         � Data � 15/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exclui da tabela Tabela de Precos os produtos genericos e  ���
���	         � produtos inativos                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function OS010REJ()

	Local cQuerys1

	If SB1->B1_ATIVO $ 'N' //.OR. Len( Alltrim( DA1->DA1_CODPRO ) ) > 7

		cQuerys1 := "UPDATE " + RetSqlName("DA1")
		cQuerys1 += " SET D_E_L_E_T_ = '*' "
		cQuerys1 += "WHERE DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1_CODTAB = '" + DA1->DA1_CODTAB + "' AND DA1_CODPRO = '" + DA1->DA1_CODPRO + "' "
		TcSqlExec(cQuerys1)

	EndIf

Return
