#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

User Function ESTR014()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Stock Out"
Local cPict          := ""
Local titulo         :=" " //"Relatorio Produção Por Linha da data" +  mv_par01 + " até " + mv_par02
Local nLin           := 100

 //                   "123456789112345678921234567893123456789412345678951234567896123456789712345678981234567899123456789112345678911234567892"
Local Cabec2       := "|  Código |      Descrição do Produto                                 |  UM  |  Stock Out "
Local Cabec1       := "|                                                                                                                              
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 170
Private tamanho    := "M"
Private nomeprog   := "ESTR014" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ESTR014" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""


//dbSelectArea("")
//dbSetOrder(1)

Pergunte("ESTR014",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



wnrel := SetPrint(cString,NomeProg,"ESTR014",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//Local dDadad := dtos(MV_PAR01 - 365)

Private nDifdIAS := (mv_par02 - mv_par01) + 1
titulo := "Relatório de Stock Out de " +  DTOC(MV_PAR01) + " à " + DTOC(MV_PAR02) + " - Total de Dias = " + Cvaltochar(nDifdIAS)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  16/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


Local nOrdem
Local cQuery := ''
LOCAL nTOTAL := 0
Local NumItensAc := 0 
Local NumItensMe := 0 
Local NumItensMp := 0 
Local NumItensMs := 0
Local ContAc := 0
Local ContMe := 0
Local ContMp := 0
Local ContMs := 0

IF EMPTY(MV_PAR03)

	cQuery := "SELECT B1_MSBLQL, B1_ESTSEG, B1_EMIN, B1_COD, B1_DESC, B1_TIPO FROM SB1010 WHERE "
	cQuery += "D_E_L_E_T_ = '' AND B1_ATIVO = 'S' AND B1_MSBLQL <> '1' AND B1_TIPO IN ('MP','MS','AC','ME') "
	cQuery += "AND (SUBSTRING(B1_COD,2,1) <> 'D' AND (SUBSTRING(B1_COD,4,1) <> '6')) ORDER BY B1_TIPO "

ELSE

	cQuery := "SELECT B1_MSBLQL, B1_ESTSEG, B1_EMIN, B1_COD, B1_DESC, B1_TIPO FROM SB1010 WHERE "
	cQuery += "D_E_L_E_T_ = '' AND B1_ATIVO = 'S' AND B1_MSBLQL <> '1' AND B1_TIPO = '" + ALLTRIM(MV_PAR03) + "' "
	cQuery += "AND (SUBSTRING(B1_COD,2,1) <> 'D' AND (SUBSTRING(B1_COD,4,1) <> '6')) ORDER BY B1_TIPO "

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)

cTPROD := ""
TCQUERY cQuery NEW ALIAS "TMP"

If !TMP->(EOF())

	TMP->(DbGoTop())
	While !TMP->(EOF())
	    cTPROD := TMP->B1_TIPO
	    NumItensAc := 0
	    ContAc := 0
	    
	   If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 9
	   Endif
	   @nLin,000 PSAY "TIPO PRODUTO ==> " + cTPROD
	   nLin++
	   @nLin,000 PSAY REPLICATE('.' , Limite)
	   nLin++	   
		WHILE !TMP->(EOF()) .and. Alltrim(TMP->B1_TIPO) = Alltrim(cTPROD)
	
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
	
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 9
		   Endif
	
	     		
	   
	   	   	nStockOut := stockout(TMP->B1_COD, MV_PAR01, MV_PAR02+1)
	   	   	@nLin,02 PSAY TMP->B1_COD 
	   	   	@nLin,18 PSAY TMP->B1_DESC
	   	   	@nLin,73 PSAY TMP->B1_TIPO    
	//     	@nLin,82 PSAY TMP->B1_ESTSEG
	//     	@nLin,95 PSAY TMP->B1_EMIN
	   	 	@nLin,82 PSAY nStockOut
	//   	@nLin,92 PSAY TRANSFORM((nStockOut*100)/nDifdIAS, "@E 999,999.99")
			ContAc := ContAc + nStockOut
	   		nLin++
	   		IF (nStockOut = 0)   //(nStockOut <> 0) //FR - PARA MOSTRAR QTOS ITENS FICARAM COM PELO MENOS 1 DIA COM SALDO ZERADO, EU CONTO QDO NSTOCKOUT = 0
	   			NumItensAc := NumItensAc + 1
	   		ENDIF
	   
			incregua()  
	    	TMP->(DbSkip())
	
		EndDo
          
		nLin++
		IF (NumItensAc > 0)
			nLin++	
			@nLin, 02 PSAY " Itens passaram o período com pelo menos 1 dia com saldo zerado"
			@nLin, 70 PSAY NumItensAc
			nLin++		    
			@nLin, 59 PSAY  " Média"
		    @nLin, 65 PSAY TRANSFORM((ContAc/NumItensAc), "@E 999,999.99")
		    nLin++
		ENDIF
		@nLin,000 PSAY REPLICATE('.' , Limite)
	   	nLin++	   
		nLin++
		
		
	Enddo

Endif //eof

TMP->(DbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RODA( 0 , "" , TAMANHO)

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return               

********************************************************
STATIC Function stockout(cProduto, dDataIni, dDataFim)
********************************************************
Local nQuant  := 0
Local aSaldos := {}        
Local nRet    := 0
	
		WHILE (dDataIni < dDataFim)
		
			aSaldos:=CalcEst(cProduto, "01", dDataIni)
			nQuant := aSaldos[1]
		
			IF (nQuant = 0)
		    
				nRet := nRet + 1
		    
			ENDIF
		
			dDataIni := dDataIni + 1
		
		ENDDO   

Return nRet