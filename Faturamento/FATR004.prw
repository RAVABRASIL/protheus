#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATR004                                � Data �  05/01/10   ���
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

User Function FATR004()

*************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario,"
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Produtos Estoque Minimo"
Local nLin           := 80

Local Cabec1         := "C�digo   Descri��o                                           UM      Pedido    Estoque  Tipo   Ultima   Fornecedor                                     Ultimo    Total Ult.     Estoque"
Local Cabec2         := "                                                                              Seguran�a        Compra                                                   Pre�o      Compra        Atual "
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR004" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR004" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FTR004"
Private cString      := ""


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
Pergunte(cPerg,.T.)               // Pergunta no SX1

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  05/01/10   ���
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
Local LF := CHR(13)+CHR(10)

If mv_par01 = 1
	titulo := "Relatorio - SOMENTE -  dos Produtos c/ Estoque Minimo"
Else
	titulo := "Relatorio de Produtos com ou sem Estoque Minimo"
Endif

cQry+="SELECT B1_COD AS CODIGO,B1_DESC AS DESCRICAO, B1_UM AS UM, "+LF
cQry+="B1_EMIN AS PEDIDO, B1_ESTSEG AS ESTSEG, B1_TIPO AS TIPO, "+LF
cQry+="(SELECT MAX(D1_DTDIGIT) "+LF
cQry+="FROM SD1020 SD1 "+LF
cQry+="WHERE D1_COD = SB1.B1_COD AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '') AS ULTCOMPRA, "+LF
cQry+="(SELECT TOP 1 A2_NOME "+LF
cQry+="FROM SD1020 SD1, SA2010 SA2 "+LF
cQry+="WHERE D1_COD = SB1.B1_COD AND  "+LF
cQry+="D1_TIPO = 'N' AND "+LF
cQry+="D1_FORNECE = A2_COD AND "+LF
cQry+="SD1.D_E_L_E_T_ = '' AND SA2.D_E_L_E_T_ = ''  "+LF
cQry+="GROUP BY D1_DTDIGIT, A2_NOME  "+LF
cQry+="ORDER BY D1_DTDIGIT DESC ) AS FORNECEDOR, "+LF
cQry+="(SELECT TOP 1 D1_VUNIT "+LF
cQry+="FROM SD1020 SD1 "+LF
cQry+="WHERE D1_COD = SB1.B1_COD AND  "+LF
cQry+="D1_TIPO = 'N' AND "                +LF
cQry+="SD1.D_E_L_E_T_ = ''  "+LF
cQry+="ORDER BY D1_DTDIGIT DESC ) AS UTLPRECO, "+LF

cQry+="(SELECT TOP 1 D1_TOTAL "+LF
cQry+="FROM SD1020 SD1 "+LF
cQry+="WHERE D1_COD = SB1.B1_COD AND "+LF
cQry+="D1_TIPO = 'N' AND "+LF
cQry+="SD1.D_E_L_E_T_ = '' "+LF
cQry+="ORDER BY D1_DTDIGIT DESC ) AS TOT_ULTCOM,  "+LF
cQry+="B2_QATU AS EST_ATUAL "+LF

cQry+="FROM SB1010 SB1 LEFT JOIN SB2020 SB2 ON B1_COD = B2_COD AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = ' '  "+LF
cQry+="WHERE B1_ATIVO = 'S' AND B2_QATU > 0 "+LF
If mv_par01 = 1
	cQry+= " AND B1_EMIN > 0 " +LF
Endif
cQry+= " AND RTRIM(B1_TIPO) >= '" + Alltrim(mv_par02) + "' and RTRIM(B1_TIPO) <= '" + Alltrim(mv_par03) + "'  " +LF

cQry+=" AND B1_TIPO IN ('AC','ST','MV','GG','MA','MC','ME','MH','MI','ML','MP','MQ','MR') "+LF
cQry+=" AND LEN(B1_COD) <= 7  "+LF
cQry+=" AND B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ = ' '  "+LF
cQry+=" ORDER BY ULTCOMPRA  DESC"+LF
//MemoWrite("C:\FATR004.SQL",cQry)
TCQUERY cQry NEW ALIAS "TMPZ"
TCSetField( 'TMPZ', "ULTCOMPRA", "D" )
	
TMPZ->( DBGoTop() )

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

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


While TMPZ->(!EOF())

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
   
    @nLin,00 PSAY substr(TMPZ->CODIGO,1,7)+SPACE(2)+TMPZ->DESCRICAO+SPACE(2)+TMPZ->UM+SPACE(2)+TRANSFORM(TMPZ->PEDIDO,"@E 999,999.99")+SPACE(2)+TRANSFORM(TMPZ->ESTSEG,"@E 999,999.99")+SPACE(2)+;
                  TMPZ->TIPO+SPACE(2)+DTOC(TMPZ->ULTCOMPRA)+SPACE(2)+TMPZ->FORNECEDOR+SPACE(2)+TRANSFORM(TMPZ->UTLPRECO,"@E 999,999.9999")+SPACE(2)+TRANSFORM(TMPZ->TOT_ULTCOM,"@E 999,999.99")+SPACE(2)+;
                  TRANSFORM(TMPZ->EST_ATUAL,"@E 999,999.99")

   nLin := nLin + 1 // Avanca a linha de impressao
   TMPZ->(incRegua() )
   TMPZ->( dbSkip() )    // Avanca o ponteiro do registro no arquivo

EndDo

TMPZ->(DBCloseArea())

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
