#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QIER001     �                                               ���
��� Data     �  14/02/11                                                  ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���Autoria   � Fl�via Rocha                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Para orientar aos inspetores quais as especifica��es       ���
���            existentes                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function QIER001


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "REL. ESPECIFICA��O DE PRODUTOS"
Local cPict          := ""
Local titulo         := "REL. ESPECIFICA��O DE PRODUTOS"
Local nLin           := 80

Local Cabec1       := "PRODUTO         REV.  DESCRI��O                 TIPO  Und.Medida   Und.AMOSTRA    TIPO            FATOR"
Local Cabec2       := "                                                      PRINCIPAL                  CONVERS�O           "
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "M"
Private nomeprog         := "QIER001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "QIER001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	   := "QIER001"

Private cString := "QE6"

dbSelectArea("QE6")
dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

Pergunte(cPerg,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  14/02/11   ���
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
Local cQuery := ""
Local LF	 := CHR(13) + CHR(10)
Local cProdAnt := ""
Local cProduto := ""
Local cRevisao := ""


cQuery := " Select MAX(QE6_REVI) as REVISAO,QE6_PRODUT,QE6_DESCPO,QE6_TIPO, QE6_UNMED1,QE6_UNAMO1 " + LF
cQuery += " ,QE6_FATCO1,QE6_TIPCO1  " + LF
cQuery += " FROM " + RetSqlName("QE6") + " QE6 " + LF
cQuery += " WHERE QE6_PRODUT >= '" + Alltrim(MV_PAR01) + "' AND QE6_PRODUT <= '" + Alltrim(MV_PAR02) + "' " + LF
cQuery += " AND QE6.D_E_L_E_T_ = '' " + LF
cQuery += " GROUP BY QE6_PRODUT,QE6_DESCPO,QE6_TIPO, QE6_UNMED1,QE6_UNAMO1 " + LF
cQuery += " ,QE6_FATCO1,QE6_TIPCO1 " + LF 
cQuery += " ORDER BY QE6_PRODUT, REVISAO DESC " + LF 
MemoWrite("C:\Temp\QIER001.sql", cQuery)

If Select("TEMPQ") > 0
	DbSelectArea("TEMPQ")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TEMPQ"
TCSetField( 'TEMPQ', "QE6_DTCAD", "D" )


dbSelectArea(cString)
dbSetOrder(1) 


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

dbGoTop()
While TEMPQ->(!EOF())
   cProduto := TEMPQ->QE6_PRODUT 
   cRevisao := TEMPQ->REVISAO
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
   
   //PRODUTO         REV.  DESCRI��O                 TIPO  UM  Und.AMOSTRA  TIPO FATOR          FATOR
   //XXXXXXXXXXXXXXX   99  XXXXXXXXXXXXXXXXXXXXXXXXX  XX   XX     XX        XXXXXXXXXXXXX       999999
   //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //          1         2         3         4         5         6         7         8         9        10        11        12        13        14      
   If Alltrim(cProduto) != Alltrim(cProdAnt)
    //msgbox(cProduto + "/" + cRevisao)
	    @nLin,000 PSAY cProduto                                  //PRODUTO
	    @nLin,018 PSAY cRevisao                                     //REVIS�O
	    @nLin,022 PSAY Substr(TEMPQ->QE6_DESCPO,1,25) Picture "@!"        //DESCRI��O
	    @nLin,049 PSAY TEMPQ->QE6_TIPO                                    //TIPO
	    @nLin,058 PSAY TEMPQ->QE6_UNMED1                                  //UNIDADE MEDIDA (P/ COMPRA)
	    @nLin,070 PSAY TEMPQ->QE6_UNAMO1                                  //UNIDADE MEDIDA (AMOSTRA)
	    @nLin,081 PSAY iif(TEMPQ->QE6_TIPCO1 = "M", "Multiplicador",iif(TEMPQ->QE6_TIPCO1 = "D","Divisor","") )
	    @nLin,097 PSAY iif(TEMPQ->QE6_UNMED1 != TEMPQ->QE6_UNAMO1, Transform(TEMPQ->QE6_FATCO1,"@E 9,9999"), "")
	    
	
	    nLin++
	    cProdAnt := cProduto
   Endif
   TEMPQ->(dbSkip())
EndDo

Roda(0,"",TAMANHO)

DbSelectArea("TEMPQ")
DbCloseArea()

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
