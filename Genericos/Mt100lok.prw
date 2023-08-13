#include "protheus.ch"

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � MT100LOK � Ponto de entrada nas linhas da nota fiscal de entrada.       ���
���             �          � Torna obrigat�rio  o preenchimento da classifica��o fiscal   ���
���             �          � do produto na nota de entrada.                               ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � CHAMADO 001964 - 04/02/11                                               ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � Fl�via Rocha                                                            ���
�����������������������������������������������������������������������������������������͹��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/

User Function Mt100Lok()

Local aArea		:= GetArea()
Local lOk		:= .T.
Local cNCM		:= BuscAcols("D1_TEC")
Local cTES		:= BuscAcols("D1_TES")

//�����������������������������������������������������������
//�So faz as validacoes para as linhas ativas (nao deletadas)�
//�����������������������������������������������������������

If !(aCols[n,Len(aHeader)+1])
	If !cTipo $"D/B"
		If Alltrim(cTES) != "102"
			If Empty(cNCM)
					Aviso(	"Documento de Entrada",;
					"Falta informar a Pos.IPI/NCM para o item "+BuscAcols("D1_ITEM")+".",;
					{"&Ok"},,;
					"Classifica��o Fiscal")
					lOk	:= .f.
			Endif	
		Endif
		
	EndIf    
	
EndIf

RestArea(aArea)

Return(lOk)