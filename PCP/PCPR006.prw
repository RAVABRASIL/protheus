#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO6     � Autor � AP6 IDE            � Data �  26/01/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PCPR006()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Data dos pedidos liberados "
Local cPict          := ""
Local titulo         := "Pedidos Liberados pelo Financeiro"
Local nLin           := 80

Local Cabec1         := "Pedido  Liberado  Emissao     Dias Cliente "
Local Cabec2         := " "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "PCPR006" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR006" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := ""

Pergunte("PCPR006",.F.) 

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"PCPR006",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  26/01/10   ���
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
Local cQry:=''

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������


cQry:="SELECT C5_NUM,C5_EMISSAO,C9_DTBLCRE,A1_NOME, " 
cQry+="CAST(CONVERT(smalldatetime,C9_DTBLCRE,112 ) - CONVERT(smalldatetime,C5_EMISSAO,112 )AS INTEGER )as DIAS "
cQry+="FROM "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "+RetSqlName("SC5")+" SC5 WITH (NOLOCK), "+RetSqlName("SC6")+" SC6 WITH (NOLOCK), "+RetSqlName("SC9")+" SC9 WITH (NOLOCK), "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) "
cQry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 "
cQry+="AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND  "
cQry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND  "
cQry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND  "
//cQry+="SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND  "
cQry+="SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND  "
cQry+="SC9.C9_DTBLCRE!= ' ' AND  "
cQry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND  "
cQry+="SC6.C6_TES != '540' AND  "

// EMISSAO
cQry+="SC5.C5_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' AND "
//LIBERACAO
cQry+="SC9.C9_DTBLCRE BETWEEN '" + DtoS( MV_PAR03 ) + "' AND '" + DtoS( MV_PAR04 ) + "' AND "
// PEDIDO
cQry+="SC5.C5_NUM BETWEEN '" +  MV_PAR05 + "' AND '" + MV_PAR06  + "' AND "

cQry+="SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ = '' AND  "
cQry+="SC5.C5_FILIAL = '"+xFilial('SC5')+"' AND SC5.D_E_L_E_T_ = '' AND  "
cQry+="SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND SC6.D_E_L_E_T_ = '' AND  "
cQry+="SC9.C9_FILIAL = '"+xFilial('SC9')+"' AND SC9.D_E_L_E_T_ = '' AND  " 
cQry+="SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = '' "
cQry+="GROUP BY C5_NUM,C5_EMISSAO,C9_DTBLCRE,A1_NOME "
cQry+="ORDER BY C5_NUM  "

TCQUERY cQry NEW ALIAS "TMPZ"
TCSetField( "TMPZ", "C5_EMISSAO",  "D", 8, 0 )
TCSetField( "TMPZ", "C9_DTBLCRE",  "D", 8, 0 )

TMPZ->(dbGoTop())

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������


While TMPZ->( !EOF() )

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
         @nLin,00 PSAY TMPZ->C5_NUM+SPACE(2)+DTOC(TMPZ->C9_DTBLCRE)+SPACE(2)+DTOC(TMPZ->C5_EMISSAO);
                       +SPACE(4)+TRANSFORM(TMPZ->DIAS,"@E 9999")+SPACE(2)+TMPZ->A1_NOME

   nLin := nLin + 1 // Avanca a linha de impressao
   IncRegua()
   TMPZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo

TMPZ->( DbCloseArea() )

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
