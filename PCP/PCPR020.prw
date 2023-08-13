#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
#include "Ap5mail.ch"

User Function PCPR020()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rela็ใo de Solicita็๕es e Pedidos de Compra em andamento"
Local cPict          := ""
Local titulo         := "Percentual de Ocorrencias Check-List"//+ PERIODO...
Local nLin           := 80
//                                                                                                                          1         1         1         1         1         1         1         1         1
                       //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
                       //         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
                       //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       :=   "     Extrusora  |   Item     |   Descri็ใo Ocorrencia        |Quant | Percentual |"
Local Cabec2       :=   "                |            |                               |      |            |"         
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130 //220
Private tamanho      := "P" //"G"
Private nomeprog     := "PCPR020" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR020" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg	:= "PCPR020"
Public  extende:= 36
Private nTotal := 0
Private xTotal := 0
Private nPerce := 0
 
 Pergunte( cPerg ,.F. )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  10/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
 */

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local Cabec3  :=   "       Item     |   Descri็ใo Ocorrencia        |Quant | Percentual |"
Local Cabec4  :=   "                |                               |      |            |" 
local cQuery  :=''
local cQueryx :=''
local cQueryA :=''
 
Titulo:=ALLTRIM(Titulo) +" De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02) 

//Novo
IF !Empty(MV_PAR03)
		cQueryx := "SELECT Z60_EXTRUS EXTRUS, Z60_ITEM ITEM, Z60_ITEMD DESCRICAO,"
		cQueryx += "COUNT(Z60_ITEM) QUANT FROM Z60020 Z60 WHERE Z60.Z60_DATAI  BETWEEN " + DtoS( MV_PAR01 ) + " AND " + DtoS( MV_PAR02 ) + " AND "
		cQueryx += "Z60.D_E_L_E_T_='' AND Z60_EXTRUS = '" + ALLTRIM(MV_PAR03) + "' GROUP BY Z60_ITEM, Z60_EXTRUS, Z60_ITEMD "
	ELSE
		cQueryx := "SELECT Z60_EXTRUS EXTRUS, Z60_ITEM ITEM, Z60_ITEMD DESCRICAO, "
		cQueryx += "COUNT(Z60_ITEM) QUANT FROM Z60020 Z60 WHERE Z60.Z60_DATAI  BETWEEN " + DtoS( MV_PAR01 ) + " AND " + DtoS( MV_PAR02 ) + " AND "  
		cQueryx += "Z60.D_E_L_E_T_='' " 
		cQueryx += "GROUP BY Z60_EXTRUS, Z60_ITEM, Z60_ITEMD ORDER BY Z60_EXTRUS"
ENDIF

TCQUERY cQueryx NEW ALIAS "TMPX"
TMPX->(DbGoTop())

   while TMPX->( !EOF() ) //.AND. cExt== TMP1->EXTRUS 
      xTotal := QUANT + xTotal
      TMPX->(DbSkip())     
   EndDo
   
   TMPX->(DbCloseArea())
   
//Fim

SetRegua(0)

IF !Empty(MV_PAR03)
/*Escolhendo extrusora*/							   
	cQuery := "SELECT Z60_EXTRUS EXTRUS, Z60_ITEM ITEM, Z60_ITEMD DESCRICAO, "
	cQuery += "COUNT(Z60_ITEM) QUANT FROM Z60020 Z60 WHERE Z60.Z60_DATAI  BETWEEN " + DtoS( MV_PAR01 ) + " AND " + DtoS( MV_PAR02 ) + " AND "  
	cQuery += "Z60.D_E_L_E_T_='' AND (Z60.Z60_OBS!='' OR Z60.Z60_PENDEN='S') " 
	cQuery += "AND Z60_EXTRUS = '" + ALLTRIM(MV_PAR03) + "' GROUP BY Z60_ITEM, Z60_EXTRUS, Z60_ITEMD "

ELSE
/*CONSULTA GERAL*/
	cQuery  := "SELECT Z60_EXTRUS EXTRUS, Z60_ITEM ITEM, Z60_ITEMD DESCRICAO, "
	cQuery  += "COUNT(Z60_ITEM) QUANT FROM Z60020 Z60 WHERE Z60.Z60_DATAI  BETWEEN " + DtoS( MV_PAR01 ) + " AND " + DtoS( MV_PAR02 ) + " AND "  
	cQuery  += "Z60.D_E_L_E_T_='' AND (Z60.Z60_OBS!='' OR Z60.Z60_PENDEN='S') " 
	cQuery  += "GROUP BY Z60_EXTRUS, Z60_ITEM, Z60_ITEMD ORDER BY Z60_EXTRUS"

	cQueryA := "SELECT Z60_ITEM ITEM, Z60_ITEMD DESCRICAO, "
	cQueryA += "COUNT(Z60_ITEM) QUANT FROM Z60020 Z60 WHERE Z60.Z60_DATAI  BETWEEN " + DtoS( MV_PAR01 ) + " AND " + DtoS( MV_PAR02 ) + " AND "  
	cQueryA += "Z60.D_E_L_E_T_='' AND (Z60.Z60_OBS!='' OR Z60.Z60_PENDEN='S') " 
	cQueryA += "GROUP BY Z60_ITEM, Z60_ITEMD ORDER BY Z60_ITEM "

ENDIF

TCQUERY cQuery NEW ALIAS "TMP1"
TMP1->(DbGoTop())
aVetor:={}

While TMP1->( !EOF() ) 
   if nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 2
   Endif
 //  cExt:= TMP1->EXTRUS
//  @nLin++,000 psay cExt  
   while TMP1->( !EOF() ) //.AND. cExt== TMP1->EXTRUS 
      nTotal := QUANT + nTotal
      TMP1->(DbSkip())     
   EndDo
   TMP1->( DbGoTop() )  
   while TMP1->( !EOF() ) //.AND. cExt== TMP1->EXTRUS 
      if nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
         nLin := Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 2
      Endif
      incregua()
      @nLin ,000     PSAY Cabec2
      @nLin ,000     PSAY replicate(" ",160+extende)
      @nLin ,000+6   PSAY EXTRUS
      @nLin ,015+6   PSAY ITEM
      @nLin ,034     PSAY DESCRICAO
      @nLin ,048+17  PSAY QUANT  
      @nLin ,055+16  PSAY TRANSFORM((QUANT*100)/xTotal,"@E 99.99") + " %"
  	  nPerce := ((QUANT*100)/xTotal) + nPerce
  	  //@ nLin+1,070 pSay "Distratos.........: "+Transform( nDistrato,"@E 999,999,999.99" )
      nLin++
      TMP1->(DbSkip())     
  EndDo
EndDo
	  @nLin++
	  @nLin ,044     PSAY "Total ->"
	  @nLin ,044+19  PSAY nTotal
	  @nLin ,051+19  PSAY Transform(nPerce, "@E 99.99") + " %"
	  @nLin++
	  @nLin++
	  @nLin++
	  //@nLin ,048+19  PSAY nTotal

TMP1->(DbCloseArea()) 

IF Empty(MV_PAR03)

TCQUERY cQueryA NEW ALIAS "TMPA"
TMPA->(DbGoTop())

   if nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo ,Cabec3,Cabec4,NomeProg,Tamanho,nTipo) + 2
   Endif
 
   TMPA->( DbGoTop() )  
   nLin := Cabec(Titulo ,Cabec3,Cabec4,NomeProg,Tamanho,nTipo) + 2
   while TMPA->( !EOF() ) //.AND. cExt== TMP1->EXTRUS 
      incregua()
      if nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo ,Cabec3,Cabec4,NomeProg,Tamanho,nTipo) + 2
  	  Endif
      @nLin ,000     PSAY Cabec4
      @nLin ,000     PSAY replicate(" ",160+extende)
      @nLin ,000+6   PSAY ITEM
      @nLin ,015+6   PSAY DESCRICAO 
      @nLin ,052     PSAY QUANT
      @nLin ,055+16  PSAY TRANSFORM((QUANT*100)/xTotal,"@E 99.99") + " %"
  	  //nPerce := ((QUANT*100)/xTotal) + nPerce
  	  //@nLin+1,070 pSay "Distratos.........: "+Transform( nDistrato,"@E 999,999,999.99" )
      nLin++
      TMPA->(DbSkip())     
  EndDo
      @nLin++
	  @nLin ,030     PSAY "Total ->"
	  @nLin ,050     PSAY nTotal
	  @nLin ,051+19  PSAY Transform(nPerce, "@E 99.99") + " %"
TMPA->(DbCloseArea())

ENDIF

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


