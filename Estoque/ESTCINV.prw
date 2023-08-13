#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  06/03/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************

User Function ESTCINV()

*************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	:= "Relat�rio de confer�ncia de invent�rio"
Local nLin         	:= 80
Local Cabec1       	:= "   C�digo    |               Descri��o                | Qtd. Inventariada |   Saldo no Invent�rio     |        Diferen�a       |"
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 				:= {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "ESTCINV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "ESTCINV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= ""
pergunte("ESTCIN",.T.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"ESTCIN",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  06/03/08   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************

Local nOrdem
Local cQuery := ''

cQuery += "select B7_COD, B7_QUANT, B7_SLDATU, B1_DESC "
cQuery += "from   " + retSqlName('SB7') + " SB7, " + retSqlName('SB1') + " SB1 "
cQuery += "where  SB7.B7_FILIAL = '"+xFilial('SB7')+"' and SB1.B1_FILIAL = '"+xFilial('SB1')+"' "
cQuery += "       and B7_DOC between '"+mv_par01+"' and '"+mv_par02+"' and B7_DATA = '"+dtos(mv_par03)+"' "
cQuery += "       and B7_COD = B1_COD and B1_TIPO = 'PA' "
cQuery += "       and SB1.D_E_L_E_T_ != '*' and SB7.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMPC'
TMPC->( dbGoTop() )

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua( 0 )

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

do While !TMPC->( EoF() )

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   //"   C�digo    |               Descri��o                | Qtd. Inventariada | Saldo Atu. no Invent�rio  |"
   //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //          10        20        30        40        50        60        70        80        90        100
   @nLin,000 PSAY alltrim( TMPC->B7_COD )
   @nLin,014 PSAY substring( alltrim( TMPC->B1_DESC ), 1, 38 )
   @nLin,063 PSAY transform( TMPC->B7_QUANT, "@E 999,999.9999" )
   @nLin,090 PSAY transform( TMPC->B7_SLDATU,"@E 999,999.9999" )
   @nLin,115 PSAY transform( TMPC->B7_QUANT - TMPC->B7_SLDATU,"@E 999,999.9999" )

   nLin := nLin + 1 // Avanca a linha de impressao

   TMPC->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
   incRegua()
EndDo
TMPC->( dbCloseArea() )
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return