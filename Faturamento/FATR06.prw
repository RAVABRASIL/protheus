#INCLUDE "rwmake.ch"
#include "TbiConn.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATR06    � Autor � Eurivan Marques    � Data �  18/05/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rela��o de notas fiscais de devolucao de clientes          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR06


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "Relacao de Notas Fiscais de Devolu��o"
Local cPict  := ""
Local titulo := ""
Local nLin   := 80

Local Cabec1        := "Data      Nota       Cliente                                   UF"
                      //00/00/00  999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX
                      //01234567890123456789012345678901234567890123456789012345678901234
                      //          1         2         3         4         5         6
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "FATR06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "FATR06"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR06" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := ""

ValidPerg()
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

titulo := "NFs de Devolu��o - "+Dtoc(MV_PAR01)+" � "+Dtoc(MV_PAR02)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  18/05/09   ���
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


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

cQuery := "SELECT F1_DTDIGIT, F1_DOC, A1_NOME, A1_EST "
cQuery += "FROM "+RetSqlName("SF1")+" SF1, "+RetSqlname("SA1")+" SA1 "
cQuery += "WHERE A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA AND F1_TIPO = 'D' AND F1_SERIE <> '' "
cQuery += "AND F1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery += "SA1.D_E_L_E_T_ = '' AND SF1.D_E_L_E_T_ = '' "
cQuery += "ORDER BY  F1_DTDIGIT "
TCQUERY cQuery NEW ALIAS "SF1X"
TCSetField('SF1X',"F1_DTDIGIT","D")

While !SF1X->(EOF())

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

   @nLin,00 PSAY Dtoc(SF1X->F1_DTDIGIT)
   @nLin,10 PSAY SF1X->F1_DOC
   @nLin,21 PSAY SF1X->A1_NOME   
   @nLin,63 PSAY SF1X->A1_EST
   nLin := nLin + 1 // Avanca a linha de impressao

   SF1X->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

SF1X->(DbCloseArea())

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

***************************
Static Function ValidPerg()
***************************
PutSx1("FATR06",'01','Da Data  ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{})
PutSx1("FATR06",'02','Ate Data ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{})
Return