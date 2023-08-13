#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATMEM    � Autor � Emmanuel AP6 IDE   � Data �  30/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Realat�rio de impress�o de mem�ria de c�lculo para tabela  ���
���          � de vendas.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATMEM()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de Mem�ria de C�lculo"
Local cPict          := ""
Local titulo         := "Relat�rio de Mem�ria de C�lculo"
Local nLin           := 80
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "FATMEM" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATMEM" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

ValidPerg()
If ! Pergunte( "FATMEM", .T. )               // Pergunta no SX1
   Return Nil
EndIf

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

RptStatus({|| RunReport(Titulo, NomeProg, Tamanho, nTipo) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  30/01/07   ���
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

Static Function RunReport(Titulo, NomeProg, Tamanho, nTipo)

***************

cQuery := "select SB5.B5_COD, SB5.B5_ESPESS2, SB5.B5_LARG2, SB5.B5_COMPR2, SX5.X5_DESCRI CAPACIDADE, DA1.DA1_PRCVEN, DA0.DA0_DESCRI, DA0.DA0_CODTAB "
cQuery += "from   " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " SX5, " + RetSqlName("DA0") + " DA0, "
cQuery += "       " + RetSqlName("DA1") + " DA1 "
cQuery += "where  DA0.DA0_CODTAB = '" + alltrim(mv_par01) + "' and DA0.DA0_CODTAB = DA1.DA1_CODTAB and SB5.B5_COD = DA1.DA1_CODPRO "
cQuery += "and SX5.X5_TABELA = 'Z0'  and SX5.X5_CHAVE = SB5.B5_CAPACID "
cQuery += "and SB5.B5_FILIAL = '01' and DA0.DA0_FILIAL = '01' and DA1.DA1_FILIAL = '01' and SX5.X5_FILIAL = '"+ xFilial("SX5") +"' "
cQuery += "and SB5.D_E_L_E_T_ != '*' and DA0.D_E_L_E_T_ != '*' and DA1.D_E_L_E_T_ != '*' and SX5.D_E_L_E_T_ != '*' "
cQuery += "order by SB5.B5_COMPR2, SB5.B5_LARG2 "
//cQuery += "order by SB5.B5_COD "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "DA0_DATDE", "D")
TMP->( DbGoTop() )
          //           10        20        30        40        50        60        70        80        90        100
            //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
cCabec1 := "CODIGO   | CAPACIDADE | LARGURA | COMPRIMENTO | ESPESSURA | PESO(Kg) | FATOR |   PRECO   | MARGEM "
Cabec(Titulo,cCabec1,"",NomeProg,Tamanho,nTipo)
cDescri := alltrim(TMP->DA0_DESCRI)
cCod := alltrim(TMP->DA0_CODTAB)
While ! TMP->( EOF() )

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If Prow() > 55
      Cabec(Titulo,cCabec1,"",NomeProg,Tamanho,nTipo)
      @Prow() + 1,000 PSAY cCabec1
   Endif

   @Prow() + 1,000 PSAY alltrim(TMP->B5_COD)
   @Prow()    ,010 PSAY substr(alltrim(TMP->CAPACIDADE),1,12)
   @Prow()    ,023 PSAY transform(TMP->B5_LARG2,   "@E 999.999")
   @Prow()    ,034 PSAY transform(TMP->B5_COMPR2,  "@E 999.999")
   @Prow()    ,048 PSAY transform(TMP->B5_ESPESS2, "@E 9.9999")
   nPeso := TMP->B5_LARG2 * TMP->B5_COMPR2 * TMP->B5_ESPESS2
   @Prow()    ,060 PSAY alltrim(transform(nPeso, "@E 999.999"))
   @Prow()    ,069 PSAY transform(TMP->DA1_PRCVEN/nPeso, "@E 999.999")
   @Prow()    ,078 PSAY transform(TMP->DA1_PRCVEN, "@E 999,999.99")
   @Prow()    ,089 PSAY transform((TMP->DA1_PRCVEN/nPeso)/mv_par02, "@E 999.999")

   TMP->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo

@Prow() + 3,000 PSAY "Mem�ria da tabela: " + cDescri + " C�d.: " + cCod
//@Prow()    ,070 PSAY " Cod.:" + alltrim(TMP->DA0_CODTAB)
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

Return Nil


***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg, '01', 'Escolha a tabela: ', 'Escolha a tabela: ', 'Escolha a tabela: ', 'mv_ch1', 'C', 02, 0, 0, 'G', '', 'DA0', '', '', 'mv_par01', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Pre�o da MP: ',      'Pre�o da MP: '     , 'Pre�o da MP: ',      'mv_ch1', 'N', 06, 2, 2, 'G', '',    '', '', '', 'mv_par02', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )

Return Nil
