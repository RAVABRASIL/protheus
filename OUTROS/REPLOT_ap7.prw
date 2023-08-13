#INCLUDE "rwmake.ch"

User Function REPLOT()

SetPrvt(" ")

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���  Autor  � Breno Pimentel Lucena                    � Data � 12/01/04 ���
������������������������������������������������������������������������Ĵ��
���Descricao� Replicador de Lotes Contabeis                              ���
������������������������������������������������������������������������Ĵ��
���   Uso   � Contabilidade                                              ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������

��������������������������������������������������
����������������������������������������������Ŀ��
�� PARAMETROS                                   ��
��    MV_PAR01 : N�mero do Lote                 ��
��    MV_PAR02 : Data do Lote                   ��
��    MV_PAR03 : N�mero do Documento            ��
�����������������������������������������������ٱ�
��������������������������������������������������
*/

Pergunte( 'REPLOT', .T. )

If Select( "XI2" ) == 0
   cArq := "SI2010"
   Use (cArq) ALIAS XI2 VIA "TOPCONN" NEW SHARED
Endif

aESTRU := XI2->( DbStruct() )

DbSeek( xFilial( "SX6" ) )

Do While .T.
   RecLock( "XI2", .T. )
   For nCONT := 1 To Len( aESTRU )
     XI2->( FieldPut( nCONT, SI2->( FieldGet( nCONT ) ) ) )
   Next
   SI2->( DbSkip() )
EndDo

XI2->( msunlock() )
XI2->( dbcommit() )
