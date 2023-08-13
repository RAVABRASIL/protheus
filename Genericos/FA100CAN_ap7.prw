#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA100CAN()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
���Fun��o    �FA100CA2  �                               � Data � 20/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exclui movimento bancario emp 01                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

if SM0->M0_CODIGO == "02" .and. SE5->E5_BANCO $ "CX1 004  030 001"
   //��������������������������������������������������������������Ŀ
   //� Movimenta na   Rava                                          �
   //����������������������������������������������������������������

   If Select( "XE5" ) == 0
      cArq := "SE5010"
      Use (cArq) ALIAS XE5 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
      XE5->( dbSetOrder( 8 ) )
   endif

   XE5->( dbSeek( xFilial( "SE5" ) + SE5->E5_DOCUMEN ) )
   if SE5->E5_DOCUMEN == XE5->E5_DOCUMEN .and. XE5->( !Eof() )
      RecLock( "XE5", .F. )
      XE5->E5_SITUACA := SE5->E5_SITUACA
      XE5->( MsUnlock() )
      XE5->( dbCommit() )
   endif
Endif

Return
