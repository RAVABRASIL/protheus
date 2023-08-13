#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATC010                                                     ���
���Autor     � Fl�via Rocha                                               ���
���Data      �  14/09/10                                                  ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Valida��o do CEP                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*****************************
User Function FATC010(cCEP)
*****************************

//valida o Cep na digita��o do campo A1_CEP

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local lRet := .F.


dbSelectArea("SZM")
dbSetOrder(1)
If SZM->(Dbseek(xFilial("SZM") + cCEP ))
	lRet := .T.
Else           
	MsgBox("CEP Inv�lido !!! Por favor, revise o CEP ou inclua-o no Cad. CEPs")
Endif


Return(lRet)

****************************
User Function FATC010A(cCEP1)
****************************  

//valida o CEP caso seja necess�rio inclui-lo na tabela SZM
//Caso exista, n�o deixa incluir e avisa ao usu�rio

Local lRetorno := .F.
Local cEnd	   := ""

dbSelectArea("SZM")
dbSetOrder(1)
If !SZM->(Dbseek(xFilial("SZM") + cCEP1 ))
	lRet := .T.     
Else
	cEnd := SZM->ZM_END           
	MsgBox("CEP J� Existe !!!  --> " + cEnd)
Endif 

Return(lRetorno)


