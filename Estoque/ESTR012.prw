#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

User Function ESTR012()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Produção Por Linha"
Local cPict          := ""
Local titulo         :=" " //"Relatorio Produção Por Linha da data" +  mv_par01 + " até " + mv_par02
Local nLin           := 80


Local Cabec2       := "|  Código |      Descrição do Produto                                 |Media Consumo | Melhor Preço |  Custo A  |  Data Melhor Compra |  Ultimo Preço   |  Custo B  |Data Ultimo Preço| Média Ponderada | % de Variação|"
Local Cabec1       := "|                                                                                                                              
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "ESTR012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ESTR012" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""


//dbSelectArea("")
//dbSetOrder(1)

Pergunte("ESTR012",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



wnrel := SetPrint(cString,NomeProg,"ESTR012",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//Local dDadad := dtos(MV_PAR01 - 365)

titulo := "Relatório Analítico de Compra de MP's " +  DTOC(MV_PAR01-365) + " à " + DTOC(MV_PAR01)

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
//Local cCabe1 := "       Linha     |     Código      |   Peso   |        Percentual          |"
//Local cCabe2 := "                 |                 |          |                            |"
//Titulo := "Relatório Mensal"

cQuery := "SELECT Z69_FILIAL, Z69_CODIGO, Z69_DESC, Z69_QUANT FROM Z69020 "
cQuery += "WHERE D_E_L_E_T_ = '' AND Z69_FILIAL = '" + xFilial("Z69") + "' "


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

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:   		
   
   @nLin,02 PSAY TMP->Z69_CODIGO 
   @nLin,18 PSAY TMP->Z69_DESC
   @nLin,70 PSAY  transform(TMP->Z69_QUANT, "@E 999,999,999.99")   //Consumo
    
   aMelhorPre := MelhorPrc(TMP->Z69_CODIGO)
   if len(aMelhorPre) <> 0
   	@nLin,82  PSAY transform(aMelhorPre[1], '@E 999,999,999.99')		//Melhor preço de Compra
   	@nLin,99  PSAY transform((aMelhorPre[1]*TMP->Z69_QUANT), '@E 999,999,999.99')  //Custo
   	@nLin,120 PSAY DTOC(STOD(aMelhorPre[2])) 						//Data Melhor Compra
   else
   	@nLin,82  PSAY transform(0, '@E 999,999,999.99')		//Melhor preço de Compra
  	@nLin,99  PSAY transform((0*TMP->Z69_QUANT), '@E 999,999,999.99')  //Custo
   	@nLin,120 PSAY DTOC(STOD("")) 						//Data Melhor Compra
   endif
   
   
   aUltimoPre := UltimoPrc(TMP->Z69_CODIGO)
   
   if len(aUltimoPre) <> 0
  	 @nLin,133  PSAY transform(aUltimoPre[1], '@E 999,999,999.99')
     @nLin,150  PSAY transform((aUltimoPre[1]*TMP->Z69_QUANT), '@E 999,999,999.99')
   	 @nLin,172 PSAY DTOC(STOD(aUltimoPre[2]))
   	 @nLin,181  PSAY transform(MediaPonde(TMP->Z69_CODIGO), '@E 999,999,999.99') 
  	 @nLin,203 PSAY TRANSFORM((100-((aMelhorPre[1]*100)/MediaPonde(TMP->Z69_CODIGO))),'@E 999.99') + " %"
   else
   	@nLin,133  PSAY transform(0, '@E 999,999,999.99')
     @nLin,150  PSAY transform((0*TMP->Z69_QUANT), '@E 999,999,999.99')
   	 @nLin,172 PSAY DTOC(STOD(""))
   	 @nLin,181  PSAY transform(MediaPonde(TMP->Z69_CODIGO), '@E 999,999,999.99')
   endif
   
   
   
   nLin++
   
incregua()  

   TMP->(DbSkip())

EndDo

	nLin++
    nLin++
    @nLin,18  PSAY "Legenda das Colunas do Relatório:"
    nLin++
    nLin++
    @nLin,18  PSAY "Média de Consumo -> Média dos Últimos 12 Meses de Consumo do Produto ao Almoxarifado."
    nLin++
    nLin++
    @nLin,18  PSAY "Melhor Preço     -> Melhor Preço de Compra dos Últimos 12 Meses de Entrada do Produto na Empresa."
    nLin++
    nLin++
    @nLin,18  PSAY "Custo A          -> Igual a Média de Consumo vezes Melhor Preço."
    nLin++
    nLin++
    @nLin,18  PSAY "Dt Melhor Compra -> Data que foi Feita a entrada dessa Melhor Compra."
    nLin++
    nLin++
    @nLin,18  PSAY "Último Preço     -> Último Preço de Compra desse Produto na Empresa."
    nLin++
    nLin++
    @nLin,18  PSAY "Custo B          -> Igual a Média de Consumo vezes Último Preço."
	nLin++
    nLin++
	@nLin,18  PSAY "Dt Último Preço  -> Data que foi Feita a entrada desse Última Compra."
	nLin++
    nLin++
	@nLin,18  PSAY "Média Ponderada  -> Média Ponderada das últimas 3 entradas do Produto em questão."
	nLin++
    nLin++
	@nLin,18  PSAY "% de Variação    -> Variação em Percentual do Melhor Preço pelo Média Ponderada."

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

Static Function MelhorPrc(cProduto)

Local cQueryA := ''
Local aRet := {}
//Local dDadade := dtos(dDataBase - 365)
//Local dDadaAte := dtos(dDatabase)
Local dDadade := dtos(MV_PAR01 - 365)
Local dDadaAte := dtos(MV_PAR01)

cQueryA := " SELECT TOP 1 D1_DOC AS DOC, D1_SERIE AS SERIE,  D1_VUNIT AS VALOR, D1_DTDIGIT AS DIGI "
cQueryA += "FROM SD1020 WHERE D1_DTDIGIT BETWEEN '" + dDadade + "' AND '" + dDadaAte + "' "
cQueryA += "AND D_E_L_E_T_ = '' AND D1_COD = '" + cProduto + "' AND D1_QUANT <> 0 AND D1_PEDIDO <> '' "
cQueryA += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQueryA += "ORDER BY D1_VUNIT, D1_DTDIGIT DESC "

TCQUERY cQueryA NEW ALIAS "TMX"

if TMX->(!EOF())

    //aRet :=TMX->VALOR
	AADD(aRet, TMX->VALOR)
	AADD(aRet, TMX->DIGI)

ENDIF

TMX->(DbCloseArea())

Return aRet
	
STATIC Function UltimoPrc(cProduto)

Local cQ := ''
Local aRet := {}
Local dDadade := dtos(MV_PAR01 - 365)
Local dDadaAte := dtos(MV_PAR01)

cQueryA := " SELECT TOP 1 D1_DOC AS DOC, D1_SERIE AS SERIE,  D1_VUNIT AS VALOR, D1_DTDIGIT AS DIGI "
cQueryA += "FROM SD1020 WHERE D1_DTDIGIT BETWEEN '" + dDadade + "' AND '" + dDadaAte + "' "
cQueryA += "AND D_E_L_E_T_ = '' AND D1_COD = '" + cProduto + "' AND D1_QUANT <> 0 AND D1_PEDIDO <> '' "
cQueryA += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQueryA += "ORDER BY D1_DTDIGIT DESC "

TCQUERY cQueryA NEW ALIAS "TMX"

if TMX->(!EOF())

    //aRet :=TMX->VALOR
	AADD(aRet, TMX->VALOR)
	AADD(aRet, TMX->DIGI)

ENDIF

TMX->(DbCloseArea())

Return aRet

STATIC Function MediaPonde(cProduto)

Local cQ := ''
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
	
TMX->(DbCloseArea())

Return nRet



