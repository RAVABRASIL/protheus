#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     � Autor � AP6 IDE            � Data �  14/10/08   ���
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

User Function FATET1()

*************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Formul�rio de Resposta - Etapa 1"
Local cPict          := ""
Local titulo         := "Formul�rio de Resposta - Etapa 1"
Local nLin           := 80
                       //          10        20        30        40        50        60        70        80        90       100      110      120
                       //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012456789012456789012456789012456789
                       //XXXXXXXXXXXXXXX    999.999.999,99        99.99%          999.999.999,99       99.99%  999.999.999,99
Local Cabec1         := "     Produto    Preco Concorrente   Margem Rava   Preco Concorrente +5%  Margem Rava  PrcMin.+60/85%  Concorrente    Cliente  "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATET1" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATET1" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Pergunte("FATET1",.T.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"FATET1",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  14/10/08   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local nPreco := nFator1 := nFator2 := 0
Local cQuery := ""
cQuery += "select Z30_CODPES, Z30_PRODUT, Z30_VALOR, Z30_QUANTI, Z30_IPI, Z30_CONCOR, Z30_PROSPE, Z30_CODCLI "
cQuery += "from   Z29020 Z29 join Z30020 Z30 on Z29_FILIAL + Z29_CODIGO = Z30_FILIAL + Z30_CODPES "
cQuery += "and Z29_FILIAL = '"+xFilial("Z29")+"' and Z29.D_E_L_E_T_ != '*' and Z30_FILIAL = '"+xFilial("Z30")+"' and Z30.D_E_L_E_T_ != '*' "
cQuery += "where  Z29_CODIGO between '' and 'ZZZZZZ' "
cQuery += "order by Z30_CODPES, Z30_CONCOR asc, Z30_PRODUT "
TCQUERY cQuery NEW ALIAS "_TMPZ"
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(0)

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

_TMPZ->( dbGoTop() )
While _TMPZ->( !EOF() )

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
 //          10        20        30        40        50        60        70        80        90        100
 //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
 //XXXXXXXXXXXXXXX    999.999.999,99        99.99%          999.999.999,99       99.99%  999.999.999,99    
//"     Produto    Preco Concorrente   Margem Rava   Preco Concorrente +5%  Margem Rava      Preco Rava"   
//cQuery += "select Z30_CODPES, Z30_PRODUT, Z30_VALOR, Z30_QUANTI, Z30_IPI, Z30_CONCOR, Z30_PROSPE, Z30_CODCLI "
   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
  										  
   nFator1 := (_TMPZ->Z30_VALOR / ( 1 + ( _TMPZ->Z30_IPI/100 ) ) ) / ( ( 1000 / posicione("SB5",1,xFilial("SB5")+_TMPZ->Z30_PRODUT, "B5_QE2") );
  										                           / posicione("SB1",1,xFilial("SB1")+_TMPZ->Z30_PRODUT, "B1_CONV") )
   nFator2 :=((_TMPZ->Z30_VALOR / ( 1 + ( _TMPZ->Z30_IPI/100 ) ) ) / ( ( 1000 / posicione("SB5",1,xFilial("SB5")+_TMPZ->Z30_PRODUT, "B5_QE2") );
  										                           / posicione("SB1",1,xFilial("SB1")+_TMPZ->Z30_PRODUT, "B1_CONV") ) ) * 1.05
   @nLin,00 PSAY _TMPZ->Z30_PRODUT//Produto
   @nLin,19 PSAY transform( _TMPZ->Z30_VALOR / ( 1 + ( _TMPZ->Z30_IPI/100 ) ),"@E 999,999,999.99")//Pre�o concorrente   
   @nLin,41 PSAY transform( ( (nFator1/mv_par01) * 100 ) - 100, "@E 999.99")//Margem 1
   @nLin,57 PSAY transform( ( _TMPZ->Z30_VALOR / ( 1 + ( _TMPZ->Z30_IPI/100 ) ) ) * 1.05,"@E 999,999,999.99")//Pre�o concorrente +5%
   @nLin,78 PSAY transform( ( (nFator2/mv_par01) * 100 ) - 100, "@E 999.99")//Margem 2
   @nLin,86 PSAY transform( mv_par01 * (posicione("SB1",1,xFilial("SB1")+_TMPZ->Z30_PRODUT, "B1_PESO") /posicione("SB5",1,xFilial("SB5")+_TMPZ->Z30_PRODUT, "B5_QE2")*1000)*;
                 iif( substr(_TMPZ->Z30_PRODUT,1,1) $ "/A/F", 1.6, iif( substr(_TMPZ->Z30_PRODUT,1,1) $ "/D/E", 1.85, 1 ) ) ,"@E 999,999,999.99" )//pre�o rava
   @nLin,102 PSAY substr( Posicione( "Z16", 1, xFilial('Z16') + _TMPZ->Z30_CONCOR, "Z16_NOME"  ),1,13 )
   @nLin,117 PSAY substr( Posicione( "SA1", 1, xFilial('SA1') + _TMPZ->Z30_CODCLI, "A1_NREDUZ" ),1,13 )
   cAnt := _TMPZ->Z30_CONCOR
   nLin := nLin + 1 // Avanca a linha de impressao
   _TMPZ->( dbSkip() )// Avanca o ponteiro do registro no arquivo
   incRegua()
   if cAnt != _TMPZ->Z30_CONCOR
      nLin := nLin + 1 // Avanca a linha de impressao
   endIf
EndDo
_TMPZ->( dbCloseArea() )
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