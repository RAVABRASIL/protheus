#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
#include "Ap5mail.ch"

User Function PCPR021()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rela豫o de Solicita寤es e Pedidos de Compra em andamento"
Local cPict          := ""
Local titulo         := "Percentual de Ocorrencias Check-List"
Local nLin           := 80
//                                                                                                                          1         1         1         1         1         1         1         1         1
                       //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
                       //         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
                       //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       :=   "       Cod Ensaio     |   Descri豫o Ensaio        |Quant | Percentual |"
Local Cabec2       :=   "                      |                           |      |            |"         
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130 //220
Private tamanho      := "P" //"G"
Private nomeprog     := "PCPR021" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR021" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg	:= "PCPR021"
Public  extende:= 36
Private nTotal := 0
Private xTotal := 0
Private nPerce := 0
 
 Pergunte( cPerg ,.F. )
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta a interface padrao com o usuario...                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔un뇙o    쿝UNREPORT � Autor � AP6 IDE            � Data �  10/03/10   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 볍�
굇�          � monta a janela com a regua de processamento.               볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Programa principal                                         볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
 */

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

local cQuery  :=''
local cQueryx :=''
 
Titulo:=ALLTRIM(Titulo) +" De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02) 

SetRegua(0)
cQuery := "SELECT QPR_ENSAIO ENSAIO, QP1_DESCPO DESCRICAO, COUNT(QPR_ENSAIO) QUANT FROM QPR020 QPR, QP1020 QP1 WHERE " 
cQuery += "QPR.QPR_ENSAIO = QP1.QP1_ENSAIO AND " 
cQuery += "QPR_RESULT = 'R' AND QPR.D_E_L_E_T_ = '' AND (QPR.QPR_DTMEDI BETWEEN " + DtoS( MV_PAR01 ) + " AND " + DtoS( MV_PAR02 ) + ") GROUP BY QPR_ENSAIO, QP1_DESCPO, QPR_RESULT "
cQuery += "ORDER BY QPR_ENSAIO, QPR_RESULT "

cQueryx := "SELECT QPR_ENSAIO ENSAIO, QP1_DESCPO DESCRICAO, COUNT(QPR_ENSAIO) QUANT FROM QPR020 QPR, QP1020 QP1 WHERE "
cQueryx += "QPR.QPR_ENSAIO = QP1.QP1_ENSAIO AND "				   
cQueryx += "QPR.D_E_L_E_T_ = '' AND (QPR.QPR_DTMEDI BETWEEN " + DtoS( MV_PAR01 ) + " AND " + DtoS( MV_PAR02 ) + ") GROUP BY QPR_ENSAIO, QP1_DESCPO, QPR_RESULT "
cQueryx += "ORDER BY QPR_ENSAIO, QPR_RESULT "

TCQUERY cQueryx NEW ALIAS "TMPX"
TMPX->(DbGoTop())
while TMPX->( !EOF() ) //.AND. cExt== TMP1->EXTRUS 
      xTotal := QUANT + xTotal
      TMPX->(DbSkip())     
EndDo
TMPX->(DbCloseArea())

TCQUERY cQuery NEW ALIAS "TMP1"
TMP1->(DbGoTop())
aVetor:={}

While TMP1->( !EOF() ) 
   if nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 2
   Endif

   while TMP1->( !EOF() ) //.AND. cExt== TMP1->EXTRUS 
      nTotal := QUANT + nTotal
      TMP1->(DbSkip())     
   EndDo
   
   TMP1->( DbGoTop() )  
   while TMP1->( !EOF() ) //.AND. cExt== TMP1->EXTRUS 
      if nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
         nLin := Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 2
      Endif
      incregua()
      @nLin ,000     PSAY Cabec2
 //   @nLin ,000     PSAY replicate(" ",160+extende)
      @nLin ,000+12   PSAY ENSAIO
      @nLin ,015+12   PSAY DESCRICAO
      @nLin ,055      PSAY QUANT
      @nLin ,048+14  PSAY TRANSFORM((QUANT*100)/xTotal,"@E 99.99") + " %" 
   	  nPerce := ((QUANT*100)/xTotal) + nPerce
  	  //@ nLin+1,070 pSay "Distratos.........: "+Transform( nDistrato,"@E 999,999,999.99" )
      nLin++
      TMP1->(DbSkip())     
  EndDo
EndDo
	  @nLin++
	  @nLin ,040  PSAY "Total ->"
	  @nLin ,053  PSAY nTotal
	  @nLin ,061  PSAY Transform(nPerce, "@E 99.99") + " %"
	  @nLin++
	  @nLin++
	  @nLin++
	  //@nLin ,048+19  PSAY nTotal

TMP1->(DbCloseArea()) 

SET DEVICE TO SCREEN

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

