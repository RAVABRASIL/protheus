#INCLUDE "rwmake.ch"

User Function FA070CA4()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
Local cUsrLib6DD	:= GetNewPar("MV_XUSR6DD","PENHA/MARCE/ADMIN/INFO/HUMBE")
Local cUsrLibBX	:= GetNewPar("MV_XUSRBXR","NEIDE/REGINA/ANA NOBREGA/")

SetPrvt("LFLAG,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA070CA4  �                               � Data � 11/04/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cancelamento da Baixa dos titulo - Verificacao do usuario   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

lFlag := .F.
/*conout("**********WFBAIXAS************")
conout("WFBAIXAS ESTA FORA DO FA070MDB")
conout("**********WFBAIXAS************")   */
If SE1->E1_PREFIXO # "   " .and. ( Upper( Substr( cUsuario, 7, 7 ) ) $ cUsrLibBX .OR. Upper( Substr( cUsuario, 7, 5 ) ) $ cUsrLib6DD )
   lFlag := .T.
endif

if SE1->E1_PREFIXO == "   " .and. Upper( Substr( cUsuario, 7, 5 ) ) $ cUsrLib6DD
   //conout("WFBAIXAS ENTROU NO SE PENHA MERCE AMIN INFO")	
   lFlag := .T.
//elseif SE1->E1_PREFIXO # "   " .and. Upper( Substr( cUsuario, 7, 5 ) ) $ "NEIDE/REGIN/KATIA/ALESS"
EndIf

Return( lFlag )
