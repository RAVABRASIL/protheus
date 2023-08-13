#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE 'PROTHEUS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTR011    บ Autor ณ Gustavo Costa     บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Controle de Entradas e Saidas de Materia Prima.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ESTR011


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Controle de Materia Prima"
Local cPict         := ""
Local titulo       	:= "Controle de Materia Prima"
Local nLin         	:= 80

Local Cabec1 		:= "|                                PRODUTOS                                         |                        ENTRADAS                        |                                SAIDAS                                             |"
Local Cabec2 		:= "|  CODIGO      |                    DESCRICAO                        | UM | LOCAL | QTD. INICIAL |   COMPRAS   | INVENTARIO  |    TOTAL    |   PRODUCAO  |    APARA    |  INVENTARIO |    AJUSTE    |    TOTAL    |  QTD. FINAL|  "
Local imprime      	:= .T.
Local aOrd 			:= {}
Local cQuery		:= ""

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "ESTR011" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "ESTR011" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString   	:= "XMP"
Private cPerg    	:= "ESTR11"

ValidPerg()

Pergunte(cPerg,.T.)

cQuery	:= "SELECT B1_COD, B1_DESC, B1_TIPO, B1_UM, B2_LOCAL, B2_QATU FROM " + RetSqlName("SB1") + " B1 "
cQuery	+= "INNER JOIN " + RetSqlName("SB2") + " B2 "
cQuery	+= "ON B2_COD = B1_COD "
cQuery	+= "WHERE B1_TIPO = 'MP' "
cQuery	+= "AND B1.D_E_L_E_T_ <> '*' "
cQuery	+= "AND B2.D_E_L_E_T_ <> '*' "
cQuery	+= "AND B1_ATIVO <> 'N' "

If !Empty(mv_par03)
	cQuery	+= "AND B2_LOCAL = '" + mv_par03 + "' "
EndIf
If !Empty(mv_par04)
	cQuery	+= "AND B1_UM = '" + mv_par04 + "' "
EndIf

cQuery	+= "AND B2_FILIAL = '" + xFilial("SB2") + "' "
cQuery	+= "ORDER BY B1_UM, B1_DESC "

If Select(cString) > 0
	(cString)->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS &cString

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
                                                                              
Titulo	+= " - Data inicial: " + DtoC(mv_par01) + " Data final: " + DtoC(mv_par02)
//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.)

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

(cString)->(dbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
local aD3		:= {}    
Local nSaldoD1  := 0
Local nSaldoD2  := 0
Local nCompra	:= 0    
Local nSaldoAPA	:= 0
Local lCabec  	:= .T.      
Local cUMAnt    := ""      

Local nTQtdI	:= 0
Local nTComp	:= 0
Local nTINVE	:= 0
Local nTTE		:= 0
Local nTProd	:= 0
Local nTApara	:= 0
Local nTINVS	:= 0
Local nTTS		:= 0
Local nTAjuS	:= 0
Local nTQtdF	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cString)
SetRegua(RecCount())
(cString)->(DBGOTOP())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

While (cString)->(!EOF())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//CalcEst(SB1>B1COD,SB1>B1LOCPAD,dDataBase1)
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 60 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin 	:= 8
		lCabec  := .T.
	Endif
	
/*	If lCabec   
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "Data inicial: " + DtoC(mv_par01) + " Data final: " + DtoC(mv_par02)
		//nLin := nLin + 2 // Avanca a linha de impressao
        lCabec	:= .F.
		nLin := nLin + 1 // Avanca a linha de impressao
	EndIf
*/	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	// {(cString)->SAI_INV, (cString)->ENT_INV, (cString)->PROD, (cString)->AJUSTE }
	aD3 		:= CalcSD3((cString)->B1_COD, (cString)->B2_LOCAL, mv_par01, mv_par02)
	nCompra     := CalcSD1((cString)->B1_COD, (cString)->B2_LOCAL, mv_par01, mv_par02)
    nSaldoD1	:= CalcEst((cString)->B1_COD,(cString)->B2_LOCAL,mv_par01)[1]
    nSaldoAPA	:= CalcAPARA((cString)->B1_COD, (cString)->B2_LOCAL, mv_par01, mv_par02)

    If mv_par02 = dDataBase
	    nSaldoD2	:= (cString)->B2_QATU
    Else
	    nSaldoD2	:= CalcEst((cString)->B1_COD,(cString)->B2_LOCAL,mv_par02)[1]
    EndIf
	@nLin,000 PSAY (cString)->B1_COD                                                                                        //CODIGO
	@nLin,014 PSAY (cString)->B1_DESC                                                                                       //DESCRICAO
	@nLin,069 PSAY (cString)->B1_UM                                                                                         //UM
	@nLin,076 PSAY (cString)->B2_LOCAL                                                                                      //ARMAZEM
	@nLin,080 PSAY Transform(nSaldoD1,'@E 999,999,999.99')			    													//ESTOQUE D1
	@nLin,094 PSAY Transform(nCompra,'@E 999,999,999.99')       															//COMPRAS
	@nLin,108 PSAY Transform(aD3[2],'@E 999,999,999.99')                                                        		    //ENTRADA INVENTARIO
	@nLin,122 PSAY Transform(nCompra + aD3[2],'@E 999,999,999.99')                                                        	//TOTAL DE ENTRADA
	@nLin,136 PSAY Transform(aD3[3],'@E 999,999,999.99')                                                        			//PRODUCAO
	@nLin,150 PSAY Transform(nSaldoAPA,'@E 999,999,999.99')                                               					//APARA
	@nLin,164 PSAY Transform(aD3[1],'@E 999,999,999.99')                                                        			//SAIDA INNVENTARIO
	@nLin,178 PSAY Transform(aD3[4],'@E 999,999,999.99')                                                        			//AJUSTE
	@nLin,192 PSAY Transform(aD3[1]+aD3[3]+aD3[4],'@E 999,999,999.99')                                             			//TOTAL DE SAIDAS
	@nLin,206 PSAY Transform(nSaldoD2,'@E 999,999,999.99')                                                        			//ESTOQUE D2

	nTQtdI	+= nSaldoD1
	nTComp	+= nCompra
	nTINVE	+= aD3[2]
	nTTE	+= nCompra + aD3[2]
	nTProd	+= aD3[3]
	nTApara	+= nSaldoAPA
	nTINVS	+= aD3[1]
	nTAjuS	+= aD3[4]
	nTTS	+= aD3[1]+aD3[3]+aD3[4]
	nTQtdF	+= nSaldoD2

	cUMAnt    := (cString)->B1_UM
	(cString)->(dbSkip()) // Avanca o ponteiro do registro no arquivo

	//separador dos totalizadores por UM
	IF cUMAnt <> (cString)->B1_UM
		nLin := nLin + 2 // Avanca a linha de impressao
		@nLin,014 PSAY "TOTAL DA UNIDADE DE MEDIDA - " + cUMAnt
		@nLin,080 PSAY Transform(nTQtdI	,'@E 999,999,999.99')	    													//ESTOQUE D1
		@nLin,094 PSAY Transform(nTComp	,'@E 999,999,999.99')  															//COMPRAS
		@nLin,108 PSAY Transform(nTINVE	,'@E 999,999,999.99')                                                  		    //ENTRADA INVENTARIO
		@nLin,122 PSAY Transform(nTTE	,'@E 999,999,999.99')                                                        	//TOTAL DE ENTRADA
		@nLin,136 PSAY Transform(nTProd	,'@E 999,999,999.99')                                                  			//PRODUCAO
		@nLin,150 PSAY Transform(nTApara,'@E 999,999,999.99')                                          					//APARA
		@nLin,164 PSAY Transform(nTINVS	,'@E 999,999,999.99')                                                  			//SAIDA INNVENTARIO
		@nLin,178 PSAY Transform(nTAjuS	,'@E 999,999,999.99')                                                  			//AJUSTE
		@nLin,192 PSAY Transform(nTTS	,'@E 999,999,999.99')	                                             			//TOTAL DE SAIDAS
		@nLin,206 PSAY Transform(nTQtdF	,'@E 999,999,999.99')                                                  			//ESTOQUE D2
		nTQtdI	:= 0
		nTComp	:= 0
		nTINVE	:= 0
		nTTE	:= 0
		nTProd	:= 0
		nTApara	:= 0
		nTINVS	:= 0
		nTTS	:= 0
		nTAjuS	:= 0
		nTQtdF	:= 0
		nLin := nLin + 1 // Avanca a linha de impressao
		@ nLin,000 PSAY Repl("-",220)
		nLin := nLin + 1 // Avanca a linha de impressao
	EndIf
	
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณValidPerg บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Valida ao grupo de perguntas. Caso noa exista, cria.       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg()

Local _sAlias 	:= Alias()
Local aHelpPor	:= {}

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,6)

If !dbSeek(cPerg)//+aRegs[i,2])
	PutSx1( cPerg,'01','Data Inicial?' 	,'','','mv_ch1','D',8,0,0,'G','','','','','mv_par01','','','','Data Inicial'	,'','','','','','','','','','','','',{"Data do Saldo Inicial"},{},{} )
	PutSx1( cPerg,'02','Data Final?'   	,'','','mv_ch2','D',8,0,0,'G','','','','','mv_par02','','','','Data Final'  	,'','','','','','','','','','','','',{"Data do Saldo Final. Nใo Pode ser maior que o dia atual."},{},{} )
	PutSx1( cPerg,'03','Armazem'       	,'','','mv_ch3','C',2,0,0,'G','','','','','mv_par03','','','','Armazem'     	,'','','','','','','','','','','','',{"Em Branco para Todos"},{},{} )
	PutSx1( cPerg,'04','Unidade Medida'	,'','','mv_ch4','C',2,0,0,'G','','','','','mv_par04','','','','Unidade Medida'  ,'','','','','','','','','','','','',{"Em Branco para Todos"},{},{} )
Endif

dbSelectArea(_sAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณCalcSD1   บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ calcula o total de entradas no periodo estabelecido.       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CalcSD1(cCod, cLoc, d1, d2)

Local cQuery	:= ""
Local cString	:= "TMPD1"
Local cCodigo	:= cCod
Local cLocal  	:= cLoc
Local nRet		:= 0

cQuery := " SELECT SUM(D1_QUANT) TOTAL FROM " + RetSqlName("SD1") + " D1 "
cQuery += " INNER JOIN " + RetSqlName("SF4") + " F4 "
cQuery += " ON F4_CODIGO = D1_TES "
cQuery += " WHERE D1_DTDIGIT BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' "
cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQuery += " AND D1.D_E_L_E_T_ <> '*' "
cQuery += " AND F4.D_E_L_E_T_ <> '*' "
cQuery += " AND D1_COD = '" + cCodigo + "' "
cQuery += " AND F4_ESTOQUE = 'S' "
If !Empty(cLocal)
	cQuery	+= " AND D1_LOCAL = '" + cLocal + "' "
EndIf

If Select(cString) > 0
	(cString)->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS &cString

(cString)->(DBGOTOP())

nRet	:= (cString)->TOTAL

(cString)->(dbCloseArea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณCalcSD3   บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Calcula o total de entradas, saidas, ajustes e apontamento บฑฑ
ฑฑบ			   de Producao no periodo estabelecido.                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CalcSD3(cCod, cLoc, d1, d2)

Local cQuery	:= ""
Local cString	:= "TMPD3"
Local cCodigo	:= cCod
Local cLocal  	:= cLoc
Local aRet		:= {}

cQuery := " SELECT 	SUM( CASE WHEN D3_TM = '999' THEN D3_QUANT*(G1_QUANT/100) ELSE 0 END) AS SAI_INV, "
cQuery += " 		SUM( CASE WHEN D3_TM = '499' THEN D3_QUANT*(G1_QUANT/100) ELSE 0 END) AS ENT_INV, "
cQuery += " 		SUM( CASE WHEN D3_TM < '499' THEN D3_QUANT*(G1_QUANT/100) ELSE 0 END) AS PROD, "
cQuery += " 		SUM( CASE WHEN D3_TM > '500' AND D3_TM < '999' THEN D3_QUANT*G1_QUANT ELSE 0 END) AS AJUSTE "
cQuery += " FROM " + RetSqlName("SD3") + " D3 "
cQuery += " INNER JOIN " + RetSqlName("SG1") + " G1 "
cQuery += " ON G1_COD = D3_COD "
cQuery += " WHERE G1_COMP = '" + cCodigo + "' "
cQuery += " AND G1.D_E_L_E_T_ <> '*' "
cQuery += " AND D3_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' "
cQuery += " AND D3.D_E_L_E_T_ <> '*' "
cQuery += " AND D3_FILIAL = '" + xFilial("SD3") + "' "
If !Empty(cLocal)
	cQuery	+= " AND D3_LOCAL = '" + cLocal + "' "
EndIf

If Select(cString) > 0
	(cString)->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS &cString

(cString)->(DBGOTOP())

aRet	:= {(cString)->SAI_INV, (cString)->ENT_INV, (cString)->PROD, (cString)->AJUSTE }

(cString)->(dbCloseArea())

Return aRet
          
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณCalcAPARA บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Calcula o total proporcional do produto elimidado por aparaบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CalcAPARA(cCod, cLoc, d1, d2)

Local cQuery	:= ""
Local cString	:= "TAPA"
Local cString2	:= "XAPA"
Local cCodigo	:= cCod
Local cLocal  	:= cLoc
Local nRet		:= 0

cQuery := " SELECT D3_QUANT, D3_OP FROM " + RetSqlName("SD3") + " D3 "
cQuery += " WHERE D3_OP IN ( "
cQuery += " SELECT DISTINCT C2_NUM+C2_ITEM+C2_SEQUEN FROM " + RetSqlName("SC2") + " C2 "
cQuery += " INNER JOIN " + RetSqlName("SG1") + " G1 "
cQuery += " ON G1_COD = C2_PRODUTO "
cQuery += " WHERE C2_FILIAL = '" + xFilial("SD1") + "' "
cQuery += " AND C2.D_E_L_E_T_ <> '*' "
cQuery += " AND (C2_QUJE > 0 OR C2_PERDA > 0) "
//cQuery += " AND C2_QUJE = 0 "
//cQuery += " AND C2_PERDA = 0 "
cQuery += " AND G1.D_E_L_E_T_ <> '*' "
cQuery += " AND G1_COMP = '" + cCodigo + "') "
cQuery += " AND D3_TIPO = 'AP' "
cQuery += " AND D3_TM = '999' "
cQuery += " AND D3.D_E_L_E_T_ <> '*' "
cQuery += " AND D3_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' "
If !Empty(cLocal)
	cQuery	+= " AND D3_LOCAL = '" + cLocal + "' "
EndIf

If Select(cString) > 0
	(cString)->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS &cString

(cString)->(DBGOTOP())

While (cString)->(!EOF())
	
	nRet	+= (cString)->D3_QUANT * fAPARA(cCodigo, cLocal, (cString)->D3_OP)
	
EndDo

(cString)->(dbCloseArea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fAPARA   บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Calcula o total proporcional do produto elimidado por aparaบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fAPARA(cCod, cLoc, OP)

Local cQuery	:= ""
Local cString2	:= "XAPA"
Local cCodigo	:= cCod
Local cLocal  	:= cLoc
Local cOP		:= OP
Local nRet		:= 0

cQuery := " SELECT G1_QUANT FROM " + RetSqlName("SC2") + " C2 "
cQuery += " INNER JOIN " + RetSqlName("SG1") + " G1 "
cQuery += " ON C2_PRODUTO = G1_COD "
cQuery += " WHERE C2.D_E_L_E_T_ <> '*' "
cQuery += " AND G1.D_E_L_E_T_ <> '*' "
cQuery += " AND G1_COMP = '" + cCodigo + "' "
cQuery += " AND C2_FILIAL = '" + xFilial("SC2") + "' "
cQuery += " AND C2_NUM+C2_ITEM+C2_SEQUEN = '" + cOP + "' "

If Select(cString2) > 0
	(cString2)->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS &cString2

(cString2)->(DBGOTOP())

nRet	:= (cString2)->G1_QUANT

(cString2)->(dbCloseArea())

Return nRet
