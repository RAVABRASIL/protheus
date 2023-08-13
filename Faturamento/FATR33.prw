#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATR33  � Autor � Romildo Junior     � Data �  23/07/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Pedidos aguardando liberacao de credito.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR33()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Pedidos aguardando libera��o de Credito"
Local cPict         := ""
Local titulo        := "Pedidos aguardando libera��o de Credito"
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 90
Private tamanho     := "M"
Private nomeprog    := "FATR33" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR33" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SC9"

Private Cab         := "Pedido  Dt.Program  Cliente                                  Dias             Valor"
                      //999999    99/99/99  000000 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  9999
                      //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8			9



//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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

RptStatus({|| RunReport(Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/06/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Titulo,nLin)

Local cQuery := ''
Local aAntec := {}
Local total  := 0

cQuery := "SELECT C5_TIPO, C9_PEDIDO ,C5_ENTREG, C5_CONDPAG, A1_COD, C9_LOJA, A1_NOME, C9_BLCRED, sum( C9_QTDLIB * C9_PRCVEN ) TOTAL "
cQuery += "FROM "+RetSqlName("SC9")+" SC9, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA3")+" SA3 "
cQuery += "WHERE C9_FILIAL = '"+xFilial("SC9")+"' AND (C9_BLCRED = '01' OR C9_BLCRED = '04' OR C9_BLCRED = '09' ) "
cQuery += "AND A3_COD = C5_VEND1 "
cQuery += "AND A1_COD+A1_LOJA = C9_CLIENTE+C9_LOJA AND C5_NUM = C9_PEDIDO AND A3_SUPER = '0320'"
cQuery += "AND SC9.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' "
cQuery += "GROUP BY C5_TIPO, C9_PEDIDO, C5_ENTREG, C5_CONDPAG, A1_COD, C9_LOJA, A1_NOME, C9_BLCRED "
cQuery += "ORDER BY C9_PEDIDO "

TCQUERY cQUery NEW ALIAS "PEDX"
TCSetField( 'PEDX', 'C5_ENTREG', 'D' )
PEDX->( dbGoTop() )

While !PEDX->(EOF())

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
   if PEDX->C5_CONDPAG = '001'
      Aadd( aAntec, {PEDX->C9_PEDIDO,PEDX->C5_ENTREG,PEDX->C5_CONDPAG,PEDX->A1_COD,PEDX->A1_NOME,PEDX->C9_BLCRED} )
   endif   

   If nLin > 55
      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
      @nLin, 00 PSay Cab
      nLin++
      @nLin, 00 PSay Replicate("-",Limite)
      nLin++      
   Endif

   @nLin, 00 PSAY PEDX->C9_PEDIDO
   @nLin, 08 PSAY DTOC( PEDX->C5_ENTREG )
   If PEDX->C5_TIPO $ "B/D"
   		@nLin, 20 PSAY PEDX->A1_COD+" - "+SUBS(POSICIONE("SA2",1,XFILIAL("SA2") + PEDX->A1_COD + PEDX->C9_LOJA, "A2_NOME"),1,30)
   	Else
   		@nLin, 20 PSAY PEDX->A1_COD+" - "+SUBS(PEDX->A1_NOME,1,30)
   EndIf
   @nLin, 61 PSAY iif( PEDX->C9_BLCRED = '09', 'REJEIT. CREDITO', Transform( dDataBase - PEDX->C5_ENTREG, "@E 9999" ) )
   @nLin, 77 PSAY Transform(PEDX->TOTAL, "@E 999,999.99")
   total += PEDX->TOTAL

   nLin ++

   PEDX->(dbSkip())
EndDo

PEDX->(DbCloseArea())
     
nLin++
@nLin, 70 PSAY "Total: " + Transform( total, "@E 999,999.99")

nLin++
@nLin, 00 PSAY Replicate("-",Limite)
nLin++
@nLin, 00 PSAY PadC("Pedidos Antecipados", limite)
nLin++
@nLin, 00 PSAY Replicate("-",Limite)
nLin++
@nLin, 00 PSAY Cab
nLin++
@nLin, 00 PSAY Replicate("-",Limite)
nLin++
nLin++

for nX := 1 to len( aAntec )
   if nLin > 55
      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)
      @nLin, 00 PSay Cab
      nLin++
      @nLin, 00 PSay Replicate("-",Limite)
      nLin++      
   endif

   @nLin, 00 PSAY aAntec[nX,1]
   @nLin, 08 PSAY DTOC( aAntec[nX,2] )
   @nLin, 20 PSAY aAntec[nX,4]+" - "+SUBS(aAntec[nX,5],1,30)
   @nLin, 61 PSAY iif( aAntec[nX,6] = '09', 'REJEIT. CREDITO', Transform( dDataBase - aAntec[nX,2], "@E 9999" ) )

   nLin++
next nX


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