#Include 'Protheus.ch'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun����o    � fAjustaRFH � Autor � Gustavo Costa     � Data �  08/04/13  ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao Corrigir as marca��es duplicadas em um periodo fechado���
���          � .                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fAjustaRFH()

Local cQuery	:= ''
Local nRet		:= 0
Local cChave	:= ""
Local cRecno

cQuery := " SELECT * "
cQuery += " FROM " + RetSqlName("SPG")
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND PG_DATA BETWEEN '20130221' AND '20130320' "
//cQuery += " AND PG_MAT = '00760 ' "
cQuery += " ORDER BY PG_FILIAL, PG_MAT, PG_DATA, PG_HORA "


If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField("TMP","PG_DATA","D")

TMP->( DbGoTop() )

While TMP->(!EOF())
	
	//Pega a chave anterior
	cChave		:= TMP->PG_FILIAL + TMP->PG_MAT + TMP->PG_ORDEM + DtoS(TMP->PG_DATA) + STR(TMP->PG_HORA,5,2)
	
	//Passa para o proximo registro
	TMP->(dbSkip())
	
	//Pega o recno da segunda linha.
	cRecno	:= TMP->R_E_C_N_O_
	
	//Se o proximo registro for igual ao anterior, apaga o segundo
	If cChave	== TMP->PG_FILIAL + TMP->PG_MAT + TMP->PG_ORDEM + DtoS(TMP->PG_DATA) + STR(TMP->PG_HORA,5,2)
		
		dbSelectArea("SPG")
		
		dbGoTo(cRecno) 
			
		If SPG->(!EOF())
		
			RecLock("SPG",.F.)
		
			dbDelete()
		
			MsUnLock()
		
		EndIf
		
	EndIf
	//Volta para o temporario
	dbSelectArea("TMP")

EndDo

Return