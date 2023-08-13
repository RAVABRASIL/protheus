#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     � Autor � AP6 IDE            � Data �  13/08/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATF001()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ7"

dbSelectArea("SZ7")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Metas Representantes",cVldExc,cVldAlt)

Return


//Funcao de validacao do periodo
************************
User Function CKPERIOD()
************************

local lOk1 := VAL(SUBS(M->Z7_MESANO,1,2))>=1.AND.VAL(SUBS(M->Z7_MESANO,1,2))<=12
local lOk2 := Len(Alltrim(SUBS(M->Z7_MESANO,3,4)))=4
local lOk3 := !SZ7->(DbSeek(xFilial("SZ7")+M->Z7_MESANO))

local lOk 

if !lOk1
   Alert( "M�s inv�lido." )
elseif !lOk2
   Alert( "Ano inv�lido. O mesmo de ver� ser no formato 'AAAA'." )
endif

lOk := lOk1 .and. lOk2

if lOk 
   M->Z7_MESANO := StrZero( VAL(SUBS(M->Z7_MESANO,1,2)),2 ) + SUBS(M->Z7_MESANO,3,4)
endif

return lOk