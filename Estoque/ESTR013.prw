#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"  

//----------------------------------------------------------
//PROGRAMA: ESTR013 - RELATÓRIO STOCK OUT
//ALTERADO POR: FLÁVIA ROCHA - 30/04/14
//SOLICITADO POR: WAGNER CABRAL - CHAMADO #181
//Separar as informações de Stock Out, por filial.
//Quando gerar um relatorio de Stock Out na filial 03 (Fab Caixas)
//o relatorio deve mostrar apenas os itens
//que são consumidos na fabrica de caixas, e da mesma forma 
//quando for gerar o mesmo relatorio da filial 01(Plasticos).
//----------------------------------------------------------

************************
User Function ESTR013()
************************

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Stock Out"
Local cPict          := ""
Local titulo         :=" " //"Relatorio Produção Por Linha da data" +  mv_par01 + " até " + mv_par02
Local nLin           := 100

 //                   "123456789112345678921234567893123456789412345678951234567896123456789712345678981234567899123456789112345678911234567892"
Local Cabec2       := "|  Código |      Descrição do Produto                                 |  UM  |  Est Seg | Ponto Ped | Stock Out |"
Local Cabec1       := "|                                                                                                                              
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 170
Private tamanho    := "M"
Private nomeprog   := "ESTR013" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ESTR013" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""


//dbSelectArea("")
//dbSetOrder(1)

Pergunte("ESTR013",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



wnrel := SetPrint(cString,NomeProg,"ESTR013",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//Local dDadad := dtos(MV_PAR01 - 365)

titulo := "Relatório de Stock Out - Produtos Ponto de Pedido " +  DTOC(MV_PAR01) + " à " + DTOC(MV_PAR02)

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
Local LF     := CHR(13) + CHR(10)
LOCAL nTOTAL := 0
//Local cCabe1 := "       Linha     |     Código      |   Peso   |        Percentual          |"
//Local cCabe2 := "                 |                 |          |                            |"
//Titulo := "Relatório Mensal"

cQuery := "SELECT B1_MSBLQL, B1_ESTSEG, B1_EMIN, B1_COD, B1_DESC, B1_TIPO " + LF
cQuery += " FROM " + RetSqlName("SB1") + " SB1 " + LF
cQuery += " WHERE " + LF
cQuery += " SB1.D_E_L_E_T_ = '' " + LF
cQuery += " AND B1_ATIVO = 'S' " + LF
cQuery += " AND B1_EMIN <> 0 " + LF
cQuery += " AND B1_MSBLQL <> '1' " + LF
cQuery += " AND B1_TIPO <> 'PA' " + LF

//cQuery += " and B1_COD = 'BS0004' " + LF  //retirar, teste

cQuery += " ORDER BY B1_DESC "


//dbSelectArea(cString)
//dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetRegua(RecCount())
  SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dbGoTop()
//While !EOF()

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(DbGoTop()) 
While TMP->(!EOF())

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

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:   		
   
   nStockOut := stockout(TMP->B1_COD, MV_PAR01, MV_PAR02+1 , xFilial() )
   
   IF (nStockOut <> 0) 
   		@nLin,02 PSAY TMP->B1_COD 
   		@nLin,18 PSAY TMP->B1_DESC
   		@nLin,73 PSAY TMP->B1_TIPO    
   		@nLin,82 PSAY TMP->B1_ESTSEG
   		@nLin,95 PSAY TMP->B1_EMIN
   		@nLin,106 PSAY nStockOut
   		nLin++
   ENDIF
   
incregua()  

   TMP->(DbSkip())

EndDo

//AQUI É FORA DO LOOP

TMP->(DbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

**********************************************************
STATIC Function stockout(cProduto, dDataIni, dDataFim, cFil)
**********************************************************
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
/*Local cQ := ''
Local nRet := 0
//Local dDadade := dtos(MV_PAR01 - 365)
Local cDadaAte := SubStr(dtos(MV_PAR01),1,6)

cQueryA := "SELECT MEDIA=SUM(MULTI)/SUM(QUANT) FROM " 
cQueryA += "(SELECT D1_DOC AS DOC, D1_SERIE AS SERIE,  D1_QUANT QUANT, D1_VUNIT AS VALOR, D1_DTDIGIT AS DIGI, "
cQueryA += "D1_QUANT * D1_VUNIT 'MULTI' "
cQueryA += "FROM SD1020 WHERE SUBSTRING(D1_DTDIGIT,1,6) = '" + cDadaAte + "' " 
cQueryA += " AND D_E_L_E_T_ = '' AND D1_COD = '" + cProduto + "' AND D1_QUANT <> 0 AND D1_PEDIDO <> '' "
cQueryA += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
//cQueryA += "ORDER BY D1_DTDIGIT DESC "
cQueryA += ") AS TABX " 

TCQUERY cQueryA NEW ALIAS "TMX"
     

IF TMX->(!EOF())
	nRet :=TMX->MEDIA
ENDIF
	
TMX->(DbCloseArea())        */

     

Return nRet


