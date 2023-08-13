#include "Protheus.Ch"
#include 'fivewin.ch'
#include "msgraphi.ch"
//#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/06/02
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณDescri…o ณ Relatorio Cobran็a externa - por empresa                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Siscob - Rava Embalagens                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function COBR11()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Ambientais                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01        	// Da empresa                               ณ
//ณ mv_par02        	// Ate a empresa                            ณ
//ณ mv_par03        	// M๊s/Ano para a Analise                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aFaixas
Private CbTxt     := ""
Private CbCont    := ""
Private nOrdem    := 0
Private Alfa      := 0
Private Z         := 0
Private M         := 0
Private tamanho   := "P"
Private nTipo     := 18
Private limite    := 80
Private Titulo    := PadC("Analise Cobranca Externa", 74)
Private cDesc1    := PADC("Este programa ira imprimir a analise das",74)
Private cDesc2    := "empresas que fazem a cobranca externa"
Private cDesc3    := ""
Private cNatureza := ""
Private aReturn   := { "Financeiro", 1,"Administracao", 1, 2, 1,"",1 }
Private nomeprog  := "COBR11"
Private cPerg     := "COBR11"
Private nLastKey  := 0
Private lContinua := .T.
Private nLin      := 9
Private wnrel     := "COBR11"
Private M_PAG     := 1
Private cabec1:= "Faixa  |       TOTAL      |  Tํtulos Aberto  | Tํt Recuperados  |   %   |  Taxa |"
Private Cabec2:= "Dias   |  Qtd        Valor|  Qtd        Valor|  Qtd        Valor| Recup | M้dia |"
//                 90-120 9,999 9,999,999.99 9,999 9,999,999.99 9,999 9,999,999.99  999.99  999.99
//                012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//                          1         2         3         4         5         6         7         8         9         0         1         2         3


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

ValidPerg()

Pergunte(cPerg,.T.)               // Pergunta no SX1

cString := "SE1"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80
m_pag    := 1
nCliente := 0
nIncons  := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


RptStatus({|| RptDetail()})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRptDetail บ Autor ณ Eurivan Marques    บ Data ณ  10/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RptDetail()

dIniDia  := STOD(mv_par03+'01')
dUltDia  := STOD(mv_par03+'31')
cUltDia := mv_par03+'31'
If Empty(dUltDia)
	dUltDia := STOD(mv_par03+'30')
	cUltDia := mv_par03+'30'
Endif
If Empty(dUltDia)
	dUltDia := STOD(mv_par03+'29')
	cUltDia := mv_par03+'29'
Endif
If Empty(dUltDia)
	dUltDia := STOD(mv_par03+'28')
	cUltDia := mv_par03+'28'
Endif
If Empty(dUltDia)
	Alert("Data Invalida. Rever Parametro 3")
	Return
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtra os Tํtulos que serao processados conforme parametro              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

For i := 1 To 2
	
	If i == 1
		cQry := " SELECT Count(ZZN_BCO) CONTAR"
	Else
		cQry := " SELECT ZZN_BCO, ZZN_DATA, ZZN_TIPOOP, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, "
		cQry += " E1_EMISSAO, E1_VENCTO, E1_NATUREZ, E1_FILIAL, E1_SALDO, E1_BAIXA"
	Endif
	
	cQry += " FROM "+RetSqlname("SE1")+" SE1, "+RetSqlname("ZZN")+" ZZN, "+RetSqlname("SA6")+" SA6"
	cQry += " WHERE E1_SITUACA = '5' "//COBRANCA EXTERNA
	cQry += " AND E1_PREFIXO = ZZN_PREFIX"
	cQry += " AND E1_NUM = ZZN_NUM"
	cQry += " AND E1_PARCELA = ZZN_PARC"
	cQry += " AND E1_TIPO = ZZN_TIPO"
	cQry += " AND ZZN_DATA = "
	cQry += " (SELECT MAX(ZZN_DATA) "
	cQry += " FROM "+RetSqlName("ZZN")+" XZN"
	cQry += " WHERE XZN.ZZN_PREFIX = ZZN.ZZN_PREFIX"
	cQry += " AND XZN.ZZN_NUM = ZZN.ZZN_NUM"
	cQry += " AND XZN.ZZN_PARC = ZZN.ZZN_PARC"
	cQry += " AND XZN.ZZN_TIPO = ZZN.ZZN_TIPO"
	cQry += " AND XZN.ZZN_DATA <= '"+cUltDia+"' "
	cQry += " AND XZN.D_E_L_E_T_ = ''"
	cQry += " )"
	cQry += " AND ZZN_TIPOOP = 'E' " //TIPO DA OPERACAO ENVIO
	cQry += " AND ZZN_BCO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "//TIPO DA OPERACAO ENVIO
	cQry += " AND E1_PORTADO = ZZN_BCO"
	cQry += " AND ZZN_BCO = A6_COD"
	cQry += " AND A6_COBEXT = 'S'"
	cQry += " AND SE1.D_E_L_E_T_ = ''"
	cQry += " AND SA6.D_E_L_E_T_ = ''"
	cQry += " AND ZZN.D_E_L_E_T_ = ''"
	If i == 2
		cQry += " ORDER BY ZZN_BCO, E1_VENCTO"
	Endif
	
	TCQUERY cQry ALIAS SE1N NEW
	
	Dbselectarea("SE1N")
	If i == 1
		nRegSE1 := SE1N->CONTAR
		dbclosearea()
	Endif
	
Next

TCSetField("SE1N", "E1_VENCTO" ,"D",8,0)
TCSetField("SE1N", "E1_EMISSAO","D",8,0)
TCSetField("SE1N", "ZZN_DATA"  ,"D",8,0)
TCSetField("SE1N", "E1_SALDO"  ,"N",12,2)
TCSetField("SE1N", "E1_BAIXA"  ,"D",8,0)

aFaixas := {}

AADD(aFaixas,{' 90-120', {} })
AADD(aFaixas,{'121-150', {} })
AADD(aFaixas,{'150-180', {} })
AADD(aFaixas,{'181-210', {} })
AADD(aFaixas,{'211-240', {} })
AADD(aFaixas,{'241-270', {} })
AADD(aFaixas,{'271-450', {} })
AADD(aFaixas,{'451-630', {} })
AADD(aFaixas,{'631-990', {} })
AADD(aFaixas,{'991 >  ', {} })
AADD(aFaixas,{'Total  ', {} })

Dbselectarea("SE1N")
Dbgotop()

SetRegua(nRegSE1)

While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	//Variaveis por faixa de analise
	
	//Faixa 1 90-120 dias
	nQtdTo1 := 0 //Quantidade Total
	nVlrTo1 := 0 //Valor Total
	nQtdAb1 := 0 //Quantidade em Aberto
	nVlrAb1 := 0 //Valor em Aberto
	nQtdRe1 := 0 //Quantidade Recuperado
	nVlrRe1 := 0 //Valor Recuperado
	
	//Faixa 2 121-150
	nQtdTo2 := 0 //Quantidade Total
	nVlrTo2 := 0 //Valor Total
	nQtdAb2 := 0 //Quantidade em Aberto
	nVlrAb2 := 0 //Valor em Aberto
	nQtdRe2 := 0 //Quantidade Recuperado
	nVlrRe2 := 0 //Valor Recuperado
	
	//Faixa 3 151-180
	nQtdTo3 := 0 //Quantidade Total
	nVlrTo3 := 0 //Valor Total
	nQtdAb3 := 0 //Quantidade em Aberto
	nVlrAb3 := 0 //Valor em Aberto
	nQtdRe3 := 0 //Quantidade Recuperado
	nVlrRe3 := 0 //Valor Recuperado
	
	//Faixa 4 181-210
	nQtdTo4 := 0 //Quantidade Total
	nVlrTo4 := 0 //Valor Total
	nQtdAb4 := 0 //Quantidade em Aberto
	nVlrAb4 := 0 //Valor em Aberto
	nQtdRe4 := 0 //Quantidade Recuperado
	nVlrRe4 := 0 //Valor Recuperado
	
	//Faixa 5 211-240
	nQtdTo5 := 0 //Quantidade Total
	nVlrTo5 := 0 //Valor Total
	nQtdAb5 := 0 //Quantidade em Aberto
	nVlrAb5 := 0 //Valor em Aberto
	nQtdRe5 := 0 //Quantidade Recuperado
	nVlrRe5 := 0 //Valor Recuperado
	
	//Faixa 6 241-270
	nQtdTo6 := 0 //Quantidade Total
	nVlrTo6 := 0 //Valor Total
	nQtdAb6 := 0 //Quantidade em Aberto
	nVlrAb6 := 0 //Valor em Aberto
	nQtdRe6 := 0 //Quantidade Recuperado
	nVlrRe6 := 0 //Valor Recuperado
	
	//Faixa 7 271-450
	nQtdTo7 := 0 //Quantidade Total
	nVlrTo7 := 0 //Valor Total
	nQtdAb7 := 0 //Quantidade em Aberto
	nVlrAb7 := 0 //Valor em Aberto
	nQtdRe7 := 0 //Quantidade Recuperado
	nVlrRe7 := 0 //Valor Recuperado
	
	//Faixa 8 451-630
	nQtdTo8 := 0 //Quantidade Total
	nVlrTo8 := 0 //Valor Total
	nQtdAb8 := 0 //Quantidade em Aberto
	nVlrAb8 := 0 //Valor em Aberto
	nQtdRe8 := 0 //Quantidade Recuperado
	nVlrRe8 := 0 //Valor Recuperado
	
	//Faixa 9 631-990
	nQtdTo9 := 0 //Quantidade Total
	nVlrTo9 := 0 //Valor Total
	nQtdAb9 := 0 //Quantidade em Aberto
	nVlrAb9 := 0 //Valor em Aberto
	nQtdRe9 := 0 //Quantidade Recuperado
	nVlrRe9 := 0 //Valor Recuperado
	
	//Faixa 10 991 >
	nQtdTo0 := 0 //Quantidade Total
	nVlrTo0 := 0 //Valor Total
	nQtdAb0 := 0 //Quantidade em Aberto
	nVlrAb0 := 0 //Valor em Aberto
	nQtdRe0 := 0 //Quantidade Recuperado
	nVlrRe0 := 0 //Valor Recuperado
	
	cBco := SE1N->ZZN_BCO
	
	Dbselectarea("SA6")
	Dbsetorder(1)
	Dbseek(xFilial()+cBco)
	cNome := SA6->A6_NOME
	@ nlin,000 pSay "Empresa : "+cBco+" - "+SA6->A6_NOME
	
	nlin := nlin +2
	
	Dbselectarea("SE1N")
	
	While !Eof() .And. cBco == SE1N->ZZN_BCO
		
		IncRegua()
		
		nDias     := dUltDia-SE1N->E1_VENCTO //Dias de vencido
		
		nValorIni := U_SldTitu(SE1N->E1_PREFIXO, SE1N->E1_NUM, SE1N->E1_PARCELA,SE1N->E1_TIPO, SE1N->E1_NATUREZ, "R",;
		SE1N->E1_CLIENTE, 1 , dIniDia , dIniDia ,SE1N->E1_LOJA,SE1N->E1_FILIAL)
		
		If nValorIni == 0 //Foi pago antes do periodo, pula o registro
			dbskip()
			Loop
		Endif
		
		nValorFim := U_SldTitu(SE1N->E1_PREFIXO, SE1N->E1_NUM, SE1N->E1_PARCELA,SE1N->E1_TIPO, SE1N->E1_NATUREZ, "R",;
		SE1N->E1_CLIENTE, 1 , dUltDia , dUltDia ,SE1N->E1_LOJA,SE1N->E1_FILIAL)
		
		If nDias >= 90 .And. nDias <= 120  //Faixa 1
			
			nQtdTo1 ++  //Quantidade Total
			nVlrTo1 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb1 ++ //Quantidade em Aberto
				nVlrAb1 += nValorFim //Valor em Aberto
			Else
				nQtdRe1 ++ //Quantidade Recuperado
				nVlrRe1 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb1 ++ //Quantidade em Aberto
				nVlrAb1 += nValorFim//Valor em Aberto
			Endif
			
			
		ElseIf nDias >= 121 .And. nDias <= 150  //Faixa 2
			
			nQtdTo2 ++  //Quantidade Total
			nVlrTo2 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb2 ++ //Quantidade em Aberto
				nVlrAb2 += nValorFim //Valor em Aberto
			Else
				nQtdRe2 ++ //Quantidade Recuperado
				nVlrRe2 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb2 ++ //Quantidade em Aberto
				nVlrAb2 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 151 .And. nDias <= 180  //Faixa 3
			
			nQtdTo3 ++  //Quantidade Total
			nVlrTo3 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb3 ++ //Quantidade em Aberto
				nVlrAb3 += nValorFim //Valor em Aberto
			Else
				nQtdRe3 ++ //Quantidade Recuperado
				nVlrRe3 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb3 ++ //Quantidade em Aberto
				nVlrAb3 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 181 .And. nDias <= 210  //Faixa 4
			
			nQtdTo4 ++  //Quantidade Total
			nVlrTo4 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb4 ++ //Quantidade em Aberto
				nVlrAb4 += nValorFim //Valor em Aberto
			Else
				nQtdRe4 ++ //Quantidade Recuperado
				nVlrRe4 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb4 ++ //Quantidade em Aberto
				nVlrAb4 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 211 .And. nDias <= 240  //Faixa 5
			
			nQtdTo5 ++  //Quantidade Total
			nVlrTo5 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb5 ++ //Quantidade em Aberto
				nVlrAb5 += nValorFim //Valor em Aberto
			Else
				nQtdRe5 ++ //Quantidade Recuperado
				nVlrRe5 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb5 ++ //Quantidade em Aberto
				nVlrAb5 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 241 .And. nDias <= 270  //Faixa 6
			
			nQtdTo6 ++  //Quantidade Total
			nVlrTo6 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb6 ++ //Quantidade em Aberto
				nVlrAb6 += nValorFim //Valor em Aberto
			Else
				nQtdRe6 ++ //Quantidade Recuperado
				nVlrRe6 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb6 ++ //Quantidade em Aberto
				nVlrAb6 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 271 .And. nDias <= 450  //Faixa 7
			
			nQtdTo7 ++  //Quantidade Total
			nVlrTo7 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb7 ++ //Quantidade em Aberto
				nVlrAb7 += nValorFim //Valor em Aberto
			Else
				nQtdRe7 ++ //Quantidade Recuperado
				nVlrRe7 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb7 ++ //Quantidade em Aberto
				nVlrAb7 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 451 .And. nDias <= 630  //Faixa 8
			
			nQtdTo8 ++  //Quantidade Total
			nVlrTo8 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb8 ++ //Quantidade em Aberto
				nVlrAb8 += nValorFim //Valor em Aberto
			Else
				nQtdRe8 ++ //Quantidade Recuperado
				nVlrRe8 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb8 ++ //Quantidade em Aberto
				nVlrAb8 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 631 .And. nDias <= 990  //Faixa 9
			
			nQtdTo9 ++  //Quantidade Total
			nVlrTo9 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb9 ++ //Quantidade em Aberto
				nVlrAb9 += nValorFim //Valor em Aberto
			Else
				nQtdRe9 ++ //Quantidade Recuperado
				nVlrRe9 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb9 ++ //Quantidade em Aberto
				nVlrAb9 += nValorFim//Valor em Aberto
			Endif
			
		ElseIf nDias >= 991  //Faixa 10
			
			nQtdTo0 ++  //Quantidade Total
			nVlrTo0 += nValorIni //Valor Total
			
			If nValorFim == nValorIni //Nao sofreu baixa
				nQtdAb0 ++ //Quantidade em Aberto
				nVlrAb0 += nValorFim //Valor em Aberto
			Else
				nQtdRe0 ++ //Quantidade Recuperado
				nVlrRe0 += nValorIni-nValorFim //Valor Recuperado
				
				nQtdAb0 ++ //Quantidade em Aberto
				nVlrAb0 += nValorFim//Valor em Aberto
			Endif
			
		Endif
		Dbselectarea("SE1N")
		dbskip()
	End
	//"Faixa  |       TOTAL      |  Tํtulos Aberto  | Tํt Recuperados  |   %   |  Taxa |"
	//"Dias   |  Qtd        Valor|  Qtd        Valor|  Qtd        Valor| Recup | M้dia |"
	//  90-120 9,999 9,999,999.99 9,999 9,999,999.99 9,999 9,999,999.99  999.99  999.99
	// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//           1         2         3         4         5         6         7         8         9         0         1         2         3
	
	//Imprime valores
	@ nlin, 000 pSay " 90-120"
	@ nlin, 008 pSay nQtdTo1 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo1 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb1 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb1 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe1 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe1 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer1 := Round((nVlrRe1/nVlrTo1)*100,2)
	@ nlin, 066 pSay nPer1 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "121-150"
	@ nlin, 008 pSay nQtdTo2 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo2 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb2 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb2 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe2 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe2 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer2 := Round((nVlrRe2/nVlrTo2)*100,2)
	@ nlin, 066 pSay nPer2 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "151-180"
	@ nlin, 008 pSay nQtdTo3 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo3 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb3 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb3 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe3 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe3 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer3 := Round((nVlrRe3/nVlrTo3)*100,2)
	@ nlin, 066 pSay nPer3 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "181-210"
	@ nlin, 008 pSay nQtdTo4 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo4 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb4 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb4 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe4 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe4 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer4 := Round((nVlrRe4/nVlrTo4)*100,2)
	@ nlin, 066 pSay nPer4 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "211-240"
	@ nlin, 008 pSay nQtdTo5 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo5 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb5 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb5 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe5 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe5 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer5 := Round((nVlrRe5/nVlrTo5)*100,2)
	@ nlin, 066 pSay nPer5 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "241-270"
	@ nlin, 008 pSay nQtdTo6 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo6 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb6 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb6 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe6 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe6 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer6 := Round((nVlrRe6/nVlrTo6)*100,2)
	@ nlin, 066 pSay nPer6 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "271-450"
	@ nlin, 008 pSay nQtdTo7 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo7 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb7 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb7 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe7 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe7 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer7 := Round((nVlrRe7/nVlrTo7)*100,2)
	@ nlin, 066 pSay nPer7 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "451-630"
	@ nlin, 008 pSay nQtdTo8 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo8 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb8 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb8 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe8 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe8 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer8 := Round((nVlrRe8/nVlrTo8)*100,2)
	@ nlin, 066 pSay nPer8 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "631-990"
	@ nlin, 008 pSay nQtdTo9 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo9 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb9 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb9 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe9 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe9 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer9 := Round((nVlrRe9/nVlrTo9)*100,2)
	@ nlin, 066 pSay nPer9 Picture "@E 999.99" //Percentual Recuperado
	nlin ++
	@ nlin, 000 pSay "991 >  "
	@ nlin, 008 pSay nQtdTo0 Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrTo0 Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAb0 Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAb0 Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdRe0 Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrRe0 Picture "@E 9,999,999.99" //Valor Recuperado
	nPer0 := Round((nVlrRe0/nVlrTo0)*100,2)
	@ nlin, 066 pSay nPer0 Picture "@E 999.99" //Percentual Recuperado
	
	//Soma os Totais
	nQtdToT := nQtdTo1+nQtdTo2+nQtdTo3+nQtdTo4+nQtdTo5+nQtdTo6+nQtdTo7+nQtdTo8+nQtdTo9+nQtdTo0
	nVlrToT := nVlrTo1+nVlrTo2+nVlrTo3+nVlrTo4+nVlrTo5+nVlrTo6+nVlrTo7+nVlrTo8+nVlrTo9+nVlrTo0
	nQtdAbT := nQtdAb1+nQtdAb2+nQtdAb3+nQtdAb4+nQtdAb5+nQtdAb6+nQtdAb7+nQtdAb8+nQtdAb9+nQtdAb0
	nVlrAbT := nVlrAb1+nVlrAb2+nVlrAb3+nVlrAb4+nVlrAb5+nVlrAb6+nVlrAb7+nVlrAb8+nVlrAb9+nVlrAb0
	nQtdReT := nQtdRe1+nQtdRe2+nQtdRe3+nQtdRe4+nQtdRe5+nQtdRe6+nQtdRe7+nQtdRe8+nQtdRe9+nQtdRe0
	nVlrReT := nVlrRe1+nVlrRe2+nVlrRe3+nVlrRe4+nVlrRe5+nVlrRe6+nVlrRe7+nVlrRe8+nVlrRe9+nVlrRe0
	nlin ++
	@ nlin, 000 pSay "Totais:"
	@ nlin, 008 pSay nQtdToT Picture "@E 9,999" //Quantidade Total
	@ nlin, 014 pSay nVlrToT Picture "@E 9,999,999.99" //Valor Total
	@ nlin, 027 pSay nQtdAbT Picture "@E 9,999" //Quantidade em Aberto
	@ nlin, 033 pSay nVlrAbT Picture "@E 9,999,999.99" //Valor em Aberto
	@ nlin, 046 pSay nQtdReT Picture "@E 9,999" //Quantidade Recuperado
	@ nlin, 052 pSay nVlrReT Picture "@E 9,999,999.99" //Valor Recuperado
	nPerT := Round((nVlrReT/nVlrToT)*100,2)
	@ nlin, 066 pSay nPerT Picture "@E 999.99" //Percentual Recuperado
	
	//Adiciona valores no array aFaixas
	AADD( aFaixas[1,2] , {cBco+" - "+Subst(cNome,1,20), nPer1 , nVlrRe1 })
	AADD( aFaixas[2,2] , {cBco+" - "+Subst(cNome,1,20), nPer2 , nVlrRe2 })
	AADD( aFaixas[3,2] , {cBco+" - "+Subst(cNome,1,20), nPer3 , nVlrRe3 })
	AADD( aFaixas[4,2] , {cBco+" - "+Subst(cNome,1,20), nPer4 , nVlrRe4 })
	AADD( aFaixas[5,2] , {cBco+" - "+Subst(cNome,1,20), nPer5 , nVlrRe5 })
	AADD( aFaixas[6,2] , {cBco+" - "+Subst(cNome,1,20), nPer6 , nVlrRe6 })
	AADD( aFaixas[7,2] , {cBco+" - "+Subst(cNome,1,20), nPer7 , nVlrRe7 })
	AADD( aFaixas[8,2] , {cBco+" - "+Subst(cNome,1,20), nPer8 , nVlrRe8 })
	AADD( aFaixas[9,2] , {cBco+" - "+Subst(cNome,1,20), nPer9 , nVlrRe9 })
	AADD( aFaixas[10,2], {cBco+" - "+Subst(cNome,1,20), nPer0 , nVlrRe0 })
	AADD( aFaixas[11,2], {cBco+" - "+Subst(cNome,1,20), nPerT , nVlrReT })
	
	nlin := 90
End

dbclosearea()

//Imprime nova pแgina
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 9

//Imprime comparativo
@ nlin, 000 pSay "Comparativo Faixa X Empresa"
nlin := nlin + 2

For i := 1 To Len(aFaixas)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		@ nlin, 000 pSay "Comparativo Faixa X Empresa"
		nlin := nlin + 2
	Endif
	
	cFaixa := aFaixas[i,1]
	aVal   := aFaixas[i,2]
	
	@ nlin,000 pSay cFaixa
	nlin ++
	For t := 1 To Len(aVal)
		@ nlin, 000 pSay aVal[t,1]
		@ nlin, 052 pSay aVal[t,3] Picture "@E 9,999,999.99" //Valor Recuperado Recuperado
		@ nlin, 066 pSay aVal[t,2] Picture "@E 999.99" //Percentual Recuperado
		nlin ++
	Next
	@ nlin,000 psay Replicate("-",80)
	
	nlin ++
	
Next

cbtxt := "Total de registros: " + TransF( nRegSE1, "@E 9,999,999" )
roda(cbcont,cbtxt,tamanho)

If aReturn[5] == 1
	dbCommitAll()
	ourspool(wnrel)
Endif

FT_PFLUSH()

//Gera Grafico
If mv_par04 == 1 .and. IW_MsgBox("Grafico", "Confirma Geracao do Grafico","YESNO" )//Sim = Gera Grafico
	gergrafo(aFaixas)
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณValidPergณAutor ณ Silvano da Silva Araujo   ณDataณ 25/02/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Verifica perguntas, incluindo-as caso nao existam.         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ SX1                                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

Local _sAlias  := Alias()
Local aRegs    := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Da Empresa         :","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","EXT",""})
aAdd(aRegs,{cPerg,"02","Ate a Empresa      :","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","EXT",""})
aAdd(aRegs,{cPerg,"03","Ano e Mes(AAAAMM)  :","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Gera Grafico        ","","","mv_ch4","N",01,0,0,"C","","mv_par04","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELGRAFICOบAutor  ณMarcio de Lima      บ Data ณ  09/13/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tem o objetivo de realizar um pareto com tres series       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function gergrafo(aFaixas)

LOCAL AAREA       := GETAREA()
Local oFld        := Nil
Local oBold       := Nil
Local nSerie      := 0
Local oMSGrap1
Local oMSGrap2
Local oMSGrap3
Local oMSGrap4
Local oMSGrap5
Local oMSGrap6
Local oMSGrap7
Local oMSGrap8
Local oMSGrap9
Local oMSGrap10
Private oGraOk    := Nil
Private cTitulo   := "Comparativo Faixas"

DEFINE MSDIALOG oGraOk FROM 0,0 TO 610,860 TITLE cTitulo PIXEL

DEFINE FONT oBold  NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oBold2 NAME "Arial" SIZE 0, -16 BOLD

@ 014,003 FOLDER oFld OF oGraOk PROMPT "90-120","121-150","151-180","181-210","211-240","241-270","271-450","451-630","631-990","991 >" SIZE 474,340 PIXEL

//Primeiro Folder
@ 005, 005 MSGRAPHIC oMSGrap1 SIZE 400, 230 OF oFld:aDialogs[1] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[1] PIXEL ACTION Grafsavbmp(oMSGrap1)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:l3D := !oMSGrap1:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:lAxisVisib := !oMSGrap1:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[1] PIXEL ACTION oMSGrap1:ZoomOut()

//Segundo Folder
@ 005, 005 MSGRAPHIC oMSGrap2 SIZE 400, 230 OF oFld:aDialogs[2] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION Grafsavbmp(oMSGrap2)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:l3D := !oMSGrap2:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:lAxisVisib := !oMSGrap2:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[2] PIXEL ACTION oMSGrap2:ZoomOut()

//Terceiro Folder
@ 005, 005 MSGRAPHIC oMSGrap3 SIZE 400, 230 OF oFld:aDialogs[3] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[3] PIXEL ACTION Grafsavbmp(oMSGrap3)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:l3D := !oMSGrap3:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:lAxisVisib := !oMSGrap3:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[3] PIXEL ACTION oMSGrap3:ZoomOut()

//Quarto Folder
@ 005, 005 MSGRAPHIC oMSGrap4 SIZE 400, 230 OF oFld:aDialogs[4] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[4] PIXEL ACTION Grafsavbmp(oMSGrap4)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:l3D := !oMSGrap4:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:lAxisVisib := !oMSGrap4:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[4] PIXEL ACTION oMSGrap4:ZoomOut()

//Quinto Folder
@ 005, 005 MSGRAPHIC oMSGrap5 SIZE 400, 230 OF oFld:aDialogs[5] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[5] PIXEL ACTION Grafsavbmp(oMSGrap5)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:l3D := !oMSGrap5:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:lAxisVisib := !oMSGrap5:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[5] PIXEL ACTION oMSGrap5:ZoomOut()

//Sexto Folder
@ 005, 005 MSGRAPHIC oMSGrap6 SIZE 400, 230 OF oFld:aDialogs[6] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[6] PIXEL ACTION Grafsavbmp(oMSGrap6)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:l3D := !oMSGrap6:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:lAxisVisib := !oMSGrap6:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[6] PIXEL ACTION oMSGrap6:ZoomOut()

//Setimo Folder
@ 005, 005 MSGRAPHIC oMSGrap7 SIZE 400, 230 OF oFld:aDialogs[7] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[7] PIXEL ACTION Grafsavbmp(oMSGrap7)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:l3D := !oMSGrap7:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:lAxisVisib := !oMSGrap7:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[7] PIXEL ACTION oMSGrap7:ZoomOut()

//Oitavo Folder
@ 005, 005 MSGRAPHIC oMSGrap8 SIZE 400, 230 OF oFld:aDialogs[8] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[8] PIXEL ACTION Grafsavbmp(oMSGrap8)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:l3D := !oMSGrap8:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:lAxisVisib := !oMSGrap8:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[8] PIXEL ACTION oMSGrap8:ZoomOut()

//Nono Folder
@ 005, 005 MSGRAPHIC oMSGrap9 SIZE 400, 230 OF oFld:aDialogs[9] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[9] PIXEL ACTION Grafsavbmp(oMSGrap9)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:l3D := !oMSGrap9:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:lAxisVisib := !oMSGrap9:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[9] PIXEL ACTION oMSGrap9:ZoomOut()

//Decimo Folder
@ 005, 005 MSGRAPHIC oMSGrap10 SIZE 400, 230 OF oFld:aDialogs[10] //360,200

@ 260, 005 BUTTON "<<" SIZE 10,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:Scroll( GRP_SCRLEFT   , 10 ) // Left 10 %
@ 260, 017 BUTTON "<"  SIZE 10,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:Scroll( GRP_SCRTOP    , 10 ) // Top 10 %
@ 260, 029 BUTTON ">"  SIZE 10,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:Scroll( GRP_SCRBOTTOM , 10 ) // Bottom 10 %
@ 260, 041 BUTTON ">>" SIZE 10,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:Scroll( GRP_SCRRIGHT  , 10 ) // Right 10 %

@ 260, 075 BUTTON "&Salvar"        SIZE 30,14 OF oFld:aDialogs[10] PIXEL ACTION Grafsavbmp(oMSGrap10)
@ 260, 105 BUTTON "&Destaque"      SIZE 30,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:SetAxisProp( CLR_MAGENTA, 8, CLR_CYAN, 8 )
@ 260, 135 BUTTON "&3D"            SIZE 30,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:l3D := !oMSGrap10:l3D
@ 260, 165 BUTTON "[&Max] [Min]"   SIZE 30,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:lAxisVisib := !oMSGrap10:lAxisVisib

@ 260, 215 BUTTON "+"        SIZE 18,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:ZoomIn()
@ 260, 230 BUTTON "-"        SIZE 18,14 OF oFld:aDialogs[10] PIXEL ACTION oMSGrap10:ZoomOut()

/*
For i:= 1 To Len(aFaixas)

nMax := Len(aFaixas[i,2])
aVal := aFaixas[i,2]
nSerie := oMSGraphi:CreateSerie(nCbt1)
xcor=CLR_YELLOW
CorL1='BR_AMARELO'

If nSerie <> GRP_CREATE_ERR

If nCbt1 == GRP_PIE
nMax := 1
Endif

For _n := 1 to nMax
oMSGraphi:Add(nSerie,aVal[_n,2],Subst(aVal[_n,1],1,3),xcor)
//		oMSGraphi:Add(nSerie,aVetGr01[_n][3],aVetGr01[_n][2],xcor)
Next _n

Endif

oMSGraphi:REFRESH()
cGrafic:=.f.
8

Next
*/

GrafGera(oMSGrap1,aFaixas[1,2])
GrafGera(oMSGrap2,aFaixas[2,2])
GrafGera(oMSGrap3,aFaixas[3,2])
GrafGera(oMSGrap4,aFaixas[4,2])
GrafGera(oMSGrap5,aFaixas[5,2])
GrafGera(oMSGrap6,aFaixas[6,2])
GrafGera(oMSGrap7,aFaixas[7,2])
GrafGera(oMSGrap8,aFaixas[8,2])
GrafGera(oMSGrap9,aFaixas[9,2])
GrafGera(oMSGrap10,aFaixas[10,2])

ACTIVATE MSDIALOG oGraOk CENTER ON INIT MyConBar(oGraOk,{||oGraOk:End()},oFld:aDialogs[2],oMSGrap1)

RESTAREA(AAREA)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELGRAFICOบAutor  ณMicrosiga           บ Data ณ  04/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION MyConBar(oObj,bObj,oFlx,oMSGrap1)
LOCAL oBar, lOk, lVolta, lLoop,oDBG10,oDBG02,oBtOk,oNada,oBtcl,oBtcn

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP    OF oObj
DEFINE BUTTON         RESOURCE "S4WB008N"  OF oBar GROUP ACTION Calculadora()                                 TOOLTIP "Calculadora"
DEFINE BUTTON         RESOURCE "S4WB010N"  OF oBar       ACTION OurSpool()                                    TOOLTIP "Gerenciador de Impressใo"
DEFINE BUTTON oBtOk   RESOURCE "CANCEL"    OF oBar       ACTION (lLoop:=lVolta,lOk:=Eval(bObj))              TOOLTIP "Sair - <Alt+F4>"

oBar:bRClicked:={||AllwaysTrue()}
RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELGRAFICOบAutor  ณMicrosiga           บ Data ณ  04/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GRAFGERA(oMSGraphi,aValores)

Local nIndTask := 0
Local nIndTask2:= 0
Local nMax     := 1
oMSGraphi:SetLegenProp( GRP_SCRTOP, CLR_YELLOW,GRP_VALUES, .t.)
oMSGraphi:lShowHint := .t.  // Desabilita Hint
oMSGraphi:SetMargins( 05, 05, 05, 07 )
oMSGraphi:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE)

nSerie := oMSGraphi:CreateSerie(4) 

aColor := {CLR_YELLOW,CLR_RED,CLR_GREEN,CLR_BLUE,CLR_WHITE,CLR_CYAN}

For t := 1 to Len(aValores)
	oMSGraphi:Add(nSerie,aValores[t,2],Subst(aValores[t,1],1,3)+Transform(aValores[t,3],"@E 999,999.99"),aColor[t])
Next

oMSGraphi:REFRESH()

Return
