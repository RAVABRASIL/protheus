#include "rwmake.ch" 

User Function A410GVLD() 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ı�
�� Funcao     A410GVLD                                    Data   28/09/02  ��
��������������������������������������������������������������������������ı�
�� Descricao  Atualizacao do Pedido de Vendas                              ��
��������������������������������������������������������������������������ı�
�� Autor      Eurivan Marques                                              ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/



/*XE2->( dbSeek( xFilial( "SE2" ) + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO ) )
   if XE2->( !Eof() )
      RecLock( "XE2", .f. )
      XE2->E2_BAIXA   := Ctod( "  /  /  " ); XE2->E2_MOTIVO := Space(30)
      XE2->E2_MOVIMEN := dDatabase         ; XE2->E2_SALDO  := SE2->E2_VALOR
      XE2->E2_DESCONT := 0                 ; XE2->E2_MULTA  := 0
      XE2->E2_JUROS   := 0                 ; XE2->E2_CORREC := 0
      XE2->E2_VALLIQ  := 0
      XE2->( msUnlock() )
      XE2->( dbCommit() )

   endif*/

Return
