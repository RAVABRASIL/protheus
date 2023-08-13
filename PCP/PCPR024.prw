#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCPR024   º Autor ³ AP6 IDE            º Data ³  16/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR024()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Carteira "
Local cPict          := ""
Local titulo         := "Carteira "
Local nLin           := 80
/*
Local Cabec1         := "Pedido  Dt.Fat    Valor Pedido    Codigo           Descricao                                                                 Qtd. Pedido     Qtd.Kg          Etoque Atual    Qtd.Carteira        Estoque Liq.   Cliente"
Local Cabec2         := "                                                                                                                                                                (Kg)             (kg)               (KG)                    "

	    @nLin,00 PSAY iif(nCnt=1,TMPX->C5_NUM,space(6))
  	    @nLin,08 PSAY iif(nCnt=1,TMPX->A1_NREDUZ,space(20))
	    @nLin,30 PSAY iif(nCnt=1,DTOC(STOD(TMPX->C5_ENTREG)),space(8))
	    @nLin,40 PSAY iif(nCnt=1,transform(fValPed(TMPX->C5_NUM), "@E 999,999,999.99"),space(14))
	    @nLin,56 PSAY TMPX->B1_COD
	    @nLin,73 PSAY Posicione("SB1",1,xFilial("SB1") + TMPX->B1_COD, "B1_DESC")
	    @nLin,135 PSAY Transform(TMPX->QTD_PEDIDO, "@E 999,999,999.99")
	    @nLin,151 PSAY Transform(TMPX->QTD_KG, "@E 999,999,999.99")
	    nSaldoAtu:=fSaldoAtu(TMPX->B1_COD,'01')
	    @nLin,167 PSAY Transform(nSaldoAtu, "@E 999,999,999.99")
	    nQtdCart:=fQtdCart(TMPX->B1_COD)
	    @nLin,183 PSAY Transform(nQtdCart, "@E 999,999,999.99")
	    @nLin,199 PSAY Transform(nSaldoAtu-nQtdCart, "@E 999,999,999.99")

*/

                       //          10        20        30        40        50        60        70                   80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678900123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Pedido  Cliente               Dt.Fat    Valor Pedido    Codigo           Descricao                                               Qtd. Pedido     Qtd.Kg       Valor      Etoque Atual    Qtd.Carteira    Estoque Liq.  "
Local Cabec2         := "                                                                                                                                                     (Kg)          (R$)            (KG)                    "

Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR024" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR024" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte('PCPR023',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"PCPR023",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)


if MV_PAR03=1 // SACO
   Cabec2         := "                                                                                                                                                                (R$)             (kg)               (KG)                    "
ELSE // CAIXA
   Cabec2         := "                                                                                                                                                                (R$)             (Un)               (Un)                    "
ENDIF
titulo         := "Carteira de: "+DTOC(MV_PAR01)+' ate: '+DTOC(MV_PAR02)

If MsgYesNo("Exporta Excel?" )
	Processa({|| fExpEX(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Else
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
EndIf

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
Local cQry:=''
local cNum:=''
local nCnt:=1
local nSaldoAtu:=0
local nQtdCart:=0

cQry:="SELECT  "
cQry+="C5_NUM,A1_COD,A1_LOJA,A1_NREDUZ, A1_EST, "
cQry+="C5_ENTREG,  "
cQry+="B1_COD=ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN  "
cQry+="CASE when (Substring( B1_COD, 4, 1 ) IN( 'R','D')) or  (Substring( B1_COD, 5, 1 ) IN( 'R','D')) "
cQry+="then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)  "
cQry+="else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end "
cQry+="ELSE B1_COD END ))) ,  "
cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) ) AS QTD_PEDIDO , "
cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS QTD_KG, "
cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SC6.C6_PRCVEN) AS VALOR "
cQry+="FROM " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + RetSqlName("SC9") + " SC9 WITH (NOLOCK), " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " 
cQry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQry+="SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_FILIAL = SC9.C9_FILIAL AND " 
cQry+="SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND  "
cQry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
IF MV_PAR03=1 // SACO 
   cQry+="SB1.B1_SETOR != '39' AND "
ELSE  // CAIXA 
   cQry+="SB1.B1_SETOR = '39' AND "
ENDIF
cQry+="SC5.C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
cQry+="SC6.C6_TES != '540' AND  "
cQry+="SC6.C6_CLI NOT IN ('031732','031733') AND "
cQry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
cQry+="SC5.D_E_L_E_T_ = '' AND "
cQry+="SC6.D_E_L_E_T_ = '' AND "
cQry+="SC9.D_E_L_E_T_ = '' AND  "
cQry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "
cQry+="GROUP BY C5_NUM, "
cQry+="C5_ENTREG, "
cQry+="B1_COD,A1_NREDUZ,A1_EST,A1_COD,A1_LOJA "
cQry+="ORDER BY C5_NUM, "
cQry+="B1_COD "

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMPX"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

TMPX->(dbGoTop())
While TMPX->(!EOF())

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
   cNum:=TMPX->C5_NUM 
   nCnt:=1
   nSaldoAtu:=0
   nQtdCart:=0
   While TMPX->(!EOF()) .AND.  alltrim(TMPX->C5_NUM)==alltrim(cNum)
	   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin := 9
       Endif
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:	    
	    /*
	    @nLin,00 PSAY iif(nCnt=1,TMPX->C5_NUM,space(6))
	    @nLin,08 PSAY iif(nCnt=1,DTOC(STOD(TMPX->C5_ENTREG)),space(8))
	    @nLin,18 PSAY iif(nCnt=1,transform(fValPed(TMPX->C5_NUM), "@E 999,999,999.99"),space(14))
	    @nLin,34 PSAY TMPX->B1_COD
	    @nLin,51 PSAY Posicione("SB1",1,xFilial("SB1") + TMPX->B1_COD, "B1_DESC")
	    @nLin,119 PSAY Transform(TMPX->QTD_PEDIDO, "@E 999,999,999.99")
	    @nLin,135 PSAY Transform(TMPX->QTD_KG, "@E 999,999,999.99")
	    nSaldoAtu:=fSaldoAtu(TMPX->B1_COD,'01')
	    @nLin,151 PSAY Transform(nSaldoAtu, "@E 999,999,999.99")
	    nQtdCart:=fQtdCart(TMPX->B1_COD)
	    @nLin,167 PSAY Transform(nQtdCart, "@E 999,999,999.99")
	    @nLin,183 PSAY Transform(nSaldoAtu-nQtdCart, "@E 999,999,999.99")
*/	    
	    @nLin,00 PSAY iif(nCnt=1,TMPX->C5_NUM,space(6))
  	    @nLin,08 PSAY iif(nCnt=1,TMPX->A1_EST + "-" + TMPX->A1_NREDUZ,space(20))
	    @nLin,30 PSAY iif(nCnt=1,DTOC(STOD(TMPX->C5_ENTREG)),space(8))
	    @nLin,40 PSAY iif(nCnt=1,transform(fValPed(TMPX->C5_NUM), "@E 999,999,999.99"),space(14))
	    @nLin,56 PSAY TMPX->B1_COD
	    @nLin,73 PSAY Posicione("SB1",1,xFilial("SB1") + TMPX->B1_COD, "B1_DESC")
	    @nLin,126 PSAY Transform(TMPX->QTD_PEDIDO, "@E 999,999,999.99")
	    @nLin,137 PSAY Transform(TMPX->QTD_KG, "@E 999,999,999.99")
	    @nLin,153 PSAY Transform(TMPX->VALOR, "@E 999,999,999.99")
	    nSaldoAtu:=fSaldoAtu(TMPX->B1_COD,'01')
	    @nLin,169 PSAY Transform(nSaldoAtu, "@E 999,999,999.99")
	    nQtdCart:=fQtdCart(TMPX->B1_COD)
	    @nLin,185 PSAY Transform(nQtdCart, "@E 999,999,999.99")
	    @nLin,201 PSAY Transform(nSaldoAtu-nQtdCart, "@E 999,999,999.99")


	    nLin := nLin + 1 // Avanca a linha de impressao
	    nCnt+=1	    
	    TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	   ENDDO
EndDo

TMPX->(DBCLOSEAREA())

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

***************
Static Function fSaldoAtu(cPROD)
***************
local nQUANT:=0
local cQry:=''

IF MV_PAR03=1 // SACO 
cQry:="SELECT ISNULL(SUM(SB2.B2_QATU / SB1.B1_CONV),0) AS ESTOQUE "
ELSE // CAIXA 
cQry:="SELECT ISNULL(SUM(SB2.B2_QATU ),0) AS ESTOQUE "
ENDIF
cQry+="FROM " + RetSqlName("SB2") + " SB2 WITH (NOLOCK), " + RetSqlName("SB1") + " SB1 WITH (NOLOCK)  "
cQry+="WHERE SB2.B2_COD = SB1.B1_COD "
cQry+="AND SB2.B2_LOCAL = '01' "
cQry+="and B1_COD='"+cProd+"' "
IF MV_PAR03=1 // SACO 
   cQry+="AND SB1.B1_SETOR != '39'  "                         
ELSE // CAIXA 
   cQry+="AND SB1.B1_SETOR = '39'  "
ENDIF
cQry+="AND SB2.D_E_L_E_T_ = '' "
cQry+="AND SB1.B1_FILIAL = '  '  "
cQry+="AND SB1.D_E_L_E_T_ = ''  "

If Select("TMPY") > 0
	DbSelectArea("TMPY")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMPY"

IF TMPY->(!EOF())
	WHILE  TMPY->(!EOF())
 	  nQUANT+=TMPY->ESTOQUE
 	  TMPY->(DBSKIP())
	ENDDO
ENDIF

TMPY->(dbclosearea())

Return nQUANT 

***************

Static Function fValPed(cPed)

***************          
local cQry:=''

cQry+="SELECT  "
cQry+="SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS "
cQry+="FROM " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + RetSqlName("SC9") + " SC9 WITH (NOLOCK), " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " 
cQry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQry+="C5_NUM='"+cPed+"' AND "
cQry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQry+="SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND "
cQry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
if MV_PAR03=1 // SACO
   cQry+="SB1.B1_SETOR != '39' AND "
else // CAIXA 
   cQry+="SB1.B1_SETOR = '39' AND "
endif
cQry+="SC5.C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
cQry+="SC6.C6_TES != '540' AND "
cQry+="SC6.C6_CLI NOT IN ('031732','031733') AND "
cQry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
cQry+="SC5.D_E_L_E_T_ = '' AND "
cQry+="SC6.D_E_L_E_T_ = '' AND  "
cQry+="SC9.D_E_L_E_T_ = '' AND   "
cQry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "

If Select("TMPZ") > 0
	DbSelectArea("TMPZ")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMPZ"

If TMPZ->(!EOF())
  nRet:=TMPZ->CARTEIRA_RS
ELSE
  nRet:=0
ENDIF

TMPZ->(DBCLOSEAREA())

Return nRet


***************
Static Function fQtdCart(cProd)
***************
LOCAL nRet:=0

cQry:="SELECT  "
IF MV_PAR03=1 // SACO 
   cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA "
ELSE // CAIXA 
   cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) ) AS CARTEIRA "
ENDIF
cQry+="FROM " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + RetSqlName("SC9") + " SC9 WITH (NOLOCK), " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " 
cQry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQry+="SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND  "
cQry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
IF MV_PAR03=1 // SACO 
   cQry+="SB1.B1_SETOR != '39' AND "
ELSE  // CAIXA 
   cQry+="SB1.B1_SETOR = '39' AND "
ENDIF
cQry+="SC5.C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
cQry+="ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN  "
cQry+="CASE when (Substring( B1_COD, 4, 1 ) IN( 'R','D')) or  (Substring( B1_COD, 5, 1 ) IN( 'R','D')) "
cQry+="then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)  "
cQry+="else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end "
cQry+="ELSE B1_COD END )))='"+cProd+"'  AND "
cQry+="SC6.C6_TES != '540' AND  "
cQry+="SC6.C6_CLI NOT IN ('031732','031733') AND "
cQry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
cQry+="SC5.D_E_L_E_T_ = '' AND "
cQry+="SC6.D_E_L_E_T_ = '' AND "
cQry+="SC9.D_E_L_E_T_ = '' AND  "
cQry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "

If Select("TMPR") > 0
	DbSelectArea("TMPR")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMPR"

if TMPR->(!EOF())
   nRet:=TMPR->CARTEIRA
ELSE
   nRet:=0
ENDIF

TMPR->(DbCloseArea())

Return  nRet


//******************************************
// Gera em excel
//******************************************

Static Function fExpEX(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQry:=''
local cNum:=''
local nCnt:=1
local nSaldoAtu:=0
local nQtdCart:=0
Local cArquivo		:= GetTempPath(.T.)+'PCPR024.xml'
Local cWorkSheet	:= "DETALHES"
Local cTitulo		:= Titulo
Local cCopia 		:= ""
Local cAssun  		:= Titulo
Local cAnexo  		:= "PCPR024.xml"

cQry:="SELECT  "
cQry+="C5_NUM,A1_COD,A1_LOJA,A1_NREDUZ, A1_EST, "
cQry+="C5_ENTREG,  "
cQry+="B1_COD=ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN  "
cQry+="CASE when (Substring( B1_COD, 4, 1 ) IN( 'R','D')) or  (Substring( B1_COD, 5, 1 ) IN( 'R','D')) "
cQry+="then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)  "
cQry+="else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end "
cQry+="ELSE B1_COD END ))) ,  "
cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) ) AS QTD_PEDIDO , "
cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS QTD_KG, "
cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SC6.C6_PRCVEN) AS VALOR "
cQry+="FROM " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), " + RetSqlName("SC9") + " SC9 WITH (NOLOCK), " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " 
cQry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQry+="SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_FILIAL = SC9.C9_FILIAL AND " 
cQry+="SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND  "
cQry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
IF MV_PAR03=1 // SACO 
   cQry+="SB1.B1_SETOR != '39' AND "
ELSE  // CAIXA 
   cQry+="SB1.B1_SETOR = '39' AND "
ENDIF
cQry+="SC5.C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
cQry+="SC6.C6_TES != '540' AND  "
cQry+="SC6.C6_CLI NOT IN ('031732','031733') AND "
cQry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
cQry+="SC5.D_E_L_E_T_ = '' AND "
cQry+="SC6.D_E_L_E_T_ = '' AND "
cQry+="SC9.D_E_L_E_T_ = '' AND  "
cQry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "
cQry+="GROUP BY C5_NUM, "
cQry+="C5_ENTREG, "
cQry+="B1_COD,A1_NREDUZ,A1_EST,A1_COD,A1_LOJA "
cQry+="ORDER BY C5_NUM, "
cQry+="B1_COD "

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMPX"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TMPX->(dbGoTop())
//While TMPX->(!EOF())

	oFWMsExcel := FWMSExcel():New()
		
		//Aba 01 - Teste
	oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
	//Criando a Tabela
	oFWMsExcel:AddTable(cWorkSheet,cTitulo)
	//Criando Colunas
	
	//nAlign	Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	
	//nFormat	Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Pedido",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Cliente",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Dt.Fat",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Valor Pedido",3,2) 
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Codigo",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Descricao",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Qtd. Pedido",3,2)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Qtd.Kg",3,2)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Valor",3,2)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Etoque Atual",3,2)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Qtd.Carteira",3,2)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"Estoque Liq.",3,2)
	
	//Criando as Linhas
	TMPX->(dbGoTop())
	While !(TMPX->(EoF()))
	
		nSaldoAtu:=fSaldoAtu(TMPX->B1_COD,'01')
		nQtdCart:=fQtdCart(TMPX->B1_COD)
		
		oFWMsExcel:AddRow(cWorkSheet,cTitulo,{;
											TMPX->C5_NUM ,;
											TMPX->A1_EST + "-" + TMPX->A1_NREDUZ ,;
											DTOC(STOD(TMPX->C5_ENTREG)) ,;
											transform(fValPed(TMPX->C5_NUM), "@E 999,999,999.99") ,;
											TMPX->B1_COD ,;
											Posicione("SB1",1,xFilial("SB1") + TMPX->B1_COD, "B1_DESC") ,;
											Transform(TMPX->QTD_PEDIDO, "@E 999,999,999.99") ,;
											Transform(TMPX->QTD_KG, "@E 999,999,999.99") ,;
											Transform(TMPX->VALOR, "@E 999,999,999.99") ,;
											Transform(nSaldoAtu, "@E 999,999,999.99") ,;
											Transform(nQtdCart, "@E 999,999,999.99") ,;
											Transform(nSaldoAtu-nQtdCart, "@E 999,999,999.99") ;
											})
	
		//Pulando Registro
		TMPX->(DbSkip())
	EndDo

TMPX->(DBCLOSEAREA())

		cArquivo  := cGetFile( '*.XML |*.XML|',"Inclua o nome do arquivo",,,.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE,.F.)  //"Escolha o arquivo de Mala Direta"
		
		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)
		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
		oExcel:SetVisible(.T.) 				//Visualiza a planilha
		oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas


Return
