#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA050B01()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CARQ,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA050B01                                         � 26/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exclusao de contas a pagar - RAVA                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

//if SM0->M0_CODIGO == "02" .and. SE2->E2_PREFIXO == "UNI"
If SM0->M0_CODIGO == "02" .and. SE2->E2_PREFIXO $ "UNI/0  "
   //��������������������������������������������������������������Ŀ
   //� Exclui Duplicatas na Rava                                    �
   //����������������������������������������������������������������

   if Select( "XE2" ) == 0
      cArq := "SE2010"
      Use (cArq) ALIAS XE2 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   XE2->( dbSetOrder( 6 ) )
   XE2->( dbSeek( xFilial( "SE2" ) + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO ) )

   if XE2->E2_FORNECE + XE2->E2_LOJA + XE2->E2_PREFIXO + XE2->E2_NUM == SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM .and. XE2->( !Eof() )
      RecLock( "XE2", .f. )
      XE2->( dbDelete() )
      XE2->( msUnlock() )
      XE2->( dbCommit() )
   endif
endif
Return
