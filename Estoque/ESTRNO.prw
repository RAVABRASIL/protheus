#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  15/08/08   ���
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

User Function ESTRNO()

*************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Levantamento de estornos"
Local cPict          := ""
Local titulo         := "Levantamento de estornos"
Local nLin           := 80
					   //01234567890123456789012345678901234567890123456789012345678901234567890123456789
   					   //          10        20        30        40        50        60        70
   					   //XXXXXXXXX XXXXXXXXXXXXXXXXXX  999.999.99  99/99/99   Alexandre
Local Cabec1         := " PRODUTO | CODIGO DE BARRAS | QUATIDADE | EMISSAO |   USUARIO   |"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "ESTRNO" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ESTRNO" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Pergunte("ESTRNO",.T.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"ESTRNO",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  15/08/08   ���
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
Local cQuery := ""
cQuery+="select D3_COD, D3_CODBAR, D3_QUANT,D3_EMISSAO, D3_USUARIO "
cQuery+="from   "+retSqlName("SD3")+" "
cQuery+="where  D3_CODBAR between '"+mv_par01+"' and '"+mv_par02+"' and D3_EMISSAO between '"+dtos(mv_par03)+"' and '"+dtos(mv_par04)+"' and "
cQuery+="D3_FILIAL = '"+xFilial("SD3")+"' and D3_CF = 'ER0' and D3_TM = '999' and D_E_L_E_T_ != '*' "
cQuery+="order by D3_EMISSAO "
TCQUERY cQuery NEW ALIAS "_TMPX"
_TMPX->( dbGoTop() )

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

While _TMPX->( !EOF() )

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

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   //01234567890123456789012345678901234567890123456789012345678901234567890123456789
   //          10        20        30        40        50        60        70
   //XXXXXXXXX XXXXXXXXXXXXXXXXXX  999.999.99  99/99/99   Alexandre   
   @nLin,00 PSAY _TMPX->D3_COD
   @nLin,13 PSAY _TMPX->D3_CODBAR   
   @nLin,30 PSAY transform(_TMPX->D3_QUANT,"@E 999,999.99")
   @nLin,42 PSAY stod(_TMPX->D3_EMISSAO)
   @nLin,54 PSAY _TMPX->D3_USUARIO

   nLin := nLin + 1 // Avanca a linha de impressao

   _TMPX->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
   incRegua()
EndDo
_TMPX->( dbCloseArea() )
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