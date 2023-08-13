#INCLUDE "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMR009   � Autor � Eurivan Marques    � Data �  09/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Cruzamento Pedido Versus Ultimo Preco         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMR009()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Comparativo Ultimo Preco"
Local cPict          := ""
Local titulo         := "Comparativo Ultimo Preco"
Local nLin           := 80

Local Cabec1         := "                                                                                        |      Ultima Compra       |"
Local Cabec2         := "Codigo           Descricao                                              Preco Unitario  |  Preco Unitario  Data    |"
                     // "XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   9.999.999,99       9.999.999,99  99/99/99
                     //  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
                     //           10        20        30        40        50        60        70        80        90        100       100
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 120
Private tamanho      := "M"
Private nomeprog     := "COMR009" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "COMR009"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMR009" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC7"


pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  09/06/11   ���
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

local cQuery

cQuery := "SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_PRECO,C7_EMISSAO, "
cQuery += "(SELECT TOP 1 D1_VUNIT "
cQuery += " FROM "+RetSqlName("SD1")+" SD1X "
cQuery += " WHERE SD1X.D1_FILIAL='"+XFILIAL("SD1")+"' AND SD1X.D1_COD = SC7.C7_PRODUTO AND SD1X.D1_TIPO = 'N' AND SD1X.D_E_L_E_T_ = '' "
cQuery += " ORDER BY SD1X.D1_DTDIGIT DESC ) AS C7_ULTPRC, "
cQuery += "(SELECT TOP 1 D1_DTDIGIT "
cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " WHERE SD1.D1_FILIAL='"+XFILIAL("SD1")+"' AND SD1.D1_COD = SC7.C7_PRODUTO AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY SD1.D1_DTDIGIT DESC ) AS C7_ULTCOM "
cQuery += "FROM "+RetSqlName("SC7")+" SC7 "
cQuery += "WHERE C7_FILIAL='"+XFILIAL("SC7")+"' AND C7_NUM = '"+MV_PAR01+"' AND SC7.D_E_L_E_T_ = '' "
cQuery += "ORDER BY C7_ITEM "

TCQUERY cQuery NEW ALIAS "SC7X"
TCSetField( 'SC7X', "C7_EMISSAO", "D")
TCSetField( 'SC7X', "C7_ULTCOM" , "D")

Cabec1       := "Pedido: "+SC7X->C7_NUM+" - Emissao: "+DtoC(SC7X->C7_EMISSAO)+"                                                      |      Ultima Compra       |"

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(0)

DbSelectArea("SC7X")

While !SC7X->(EOF())

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
      nLin := 9
   Endif

   @nLin,000 PSAY SC7X->C7_PRODUTO
   @nLin,017 PSAY SC7X->C7_DESCRI
   @nLin,074 PSAY SC7X->C7_PRECO  Picture "@E 9,999,999.99"
   @nLin,093 PSAY SC7X->C7_ULTPRC Picture "@E 9,999,999.99"
   @nLin,107 PSAY DTOC(SC7X->C7_ULTCOM)

   nLin := nLin + 1 // Avanca a linha de impressao
   SC7X->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   IncRegua()   
   
EndDo

SC7X->(DbCloseArea())

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
