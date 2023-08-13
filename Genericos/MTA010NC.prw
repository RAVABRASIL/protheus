#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA010NC  � Autor � MP10 IDE            � Data �  16/07/2010���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada no cadastro de produtos, ao escolher      ���
���          � a op��o "C�pia", o programa ir� copiar todos os campos,    ���
���            exceto os campos mencionados no array do ponto de entrada   ���
���			   abaixo.													   ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Produtos  - C�PIA DE PRODUTOS                  ���
// Autoria   : Fl�via Rocha                                                //
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA010NC() 

//Este ponto de entrada ir� impedir a c�pia do campo "Entra MRP" (B1_MRP) para um
// novo cadastro

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local aCpoNC := {}

AAdd( aCpoNC, 'B1_MRP' )

AAdd( aCpoNC, 'B1_UCOM' )
AAdd( aCpoNC, 'B1_DATREF' )
AAdd( aCpoNC, 'B1_UREV' )
AAdd( aCpoNC, 'B1_CONINI' )
AAdd( aCpoNC, 'B1_CODBAR' )
AAdd( aCpoNC, 'B1_NATUREZ' )
AAdd( aCpoNC, 'B1_TIPCAR' )
AAdd( aCpoNC, 'B1_EMIN' )
AAdd( aCpoNC, 'B1_EMINCX' )
AAdd( aCpoNC, 'B1_ESTSEG' )
AAdd( aCpoNC, 'B1_ESTSEGX' )
AAdd( aCpoNC, 'B1_LE' )
AAdd( aCpoNC, 'B1_MRP' )
AAdd( aCpoNC, 'B1_RAVACQ' )
AAdd( aCpoNC, 'B1_POSIPI' )   //FR - 04/09/12 - Solicitado por Eurivan

Return (aCpoNC)


