#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA190DEL()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CARQ,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FA190SEF  �                               � Data � 14/12/99 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Cancelamento do cheque na - Rava                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

msgbox( " sm0 " + sm0->m0_codigo+sef->ef_prefixo,"Info","stop")
//if SM0->M0_CODIGO == "02" .and. SEF->EF_PREFIXO == "UNI"
if SM0->M0_CODIGO == "02" .and. SEF->EF_PREFIXO $ "UNI/0  "
   //��������������������������������������������������������������Ŀ
   //� Cancelamento do cheque - Rava                                �
   //����������������������������������������������������������������

   If Select( "YEF" ) == 0
      cArq := "SEF010"
      Use (cArq) ALIAS YEF VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
	 YEF->( DbSetOrder( 1 ) )
   YEF->( dbSeek( xFilial( "SEF" ) + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM ) )
   msgbox( " YEF " + YEF->ef_banco+YEF->ef_agencia+YEF->ef_conta+YEF->ef_num,"Info","stop")
   If YEF->( !Eof() )

      If Select( "XE2" ) == 0
         cArq := "SE2010"
         Use (cArq) ALIAS XE2 VIA "TOPCONN" NEW SHARED
				 U_AbreInd( cARQ )
      endif
			XE2->( DbSetOrder( 1 ) )
      XE2->( dbSeek( xFilial( "SE2" ) + YEF->EF_PREFIXO + YEF->EF_TITULO + YEF->EF_PARCELA +YEF->EF_TIPO + YEF->EF_FORNECE +YEF->EF_LOJA ) )
      if XE2->( !Eof() )
         RecLock( "XE2", .f. )
         XE2->E2_NUMBCO := Space( 30 )
         XE2->( MsUnLock() )
      endif

      RecLock( "YEF", .f. )
      YEF->( dbDelete() )
      YEF->( msUnlock() )
   endif

endif
Return
