#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#include "TbiConn.ch"
#include "PROTHEUS.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATR039  บ Autor ณ Flแvia Rocha        บ Data ณ  29/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Prioridade de Faturamento                     บฑฑ
ฑฑบ          ณ Somente Linha Institucional                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function FATR039()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Prioridade de Faturamento"
Local cPict         := ""
Local titulo        := "PRIORIDADE DE FATURAMENTO - LINHA INSTITUCIONAL "
Local nLin          := 80

Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "FATR039" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR039" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SC9" 
Private cPerg       := "FATR039"

//Private Cab         := "Pedido  Dt.Program  Cliente                                  Dias             Valor"
                      //999999    99/99/99  000000 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  9999
                      //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8			9
Private Cabec1        := ""
Private Cabec2        := ""

If xFilial("SC6") == '01'                      
	Cabec1         := "Prioridade  Pedido  Emissao  Cliente                                        Entrega         QTD.Ped  UM     QTDE.em KG     Valor   Cond.Pagto."
Else //se for Caixas, nใo mostra a coluna em KG
	Cabec1         := "Prioridade  Pedido  Emissao  Cliente                                        Entrega         QTDE.    UM                      Valor   Cond.Pagto."                      
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte(cPerg,.F.)               // Pergunta no SX1
//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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

RptStatus({|| RunReport(Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Titulo,nLin)

Local cQuery := ''
Local LF     := CHR(13) + CHR(10)
Local cCliAnt:= ""
Local aPref  := {}
Local aPed   := {}   
Local nOrdem := 0 
Local nODR   := 0
Local nTOTGER:= 0 
Local t      := 0
Local x      := 0

//(*) ordem = serแ estabelecida por: cliente , cliente que compra a linha e paga no prazo

///SE1
//SELECT NO D2 PARA OBTER O NฺMERO DAS NFs ( TอTULOS ) referentes a linha institucional
cQuery := "Select E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VENCREA, E1_BAIXA " + LF
cQuery += " ,CAST(CAST(E1_BAIXA AS DATETIME) - CAST(E1_VENCREA AS DATETIME)AS INTEGER) AS DIAS " + LF
cQuery += " from " + LF
cQuery += " " + RetSqlName("SE1") + " SE1 " + LF
cQuery += " Where " + LF                 

cQuery += " E1_BAIXA <> '' AND E1_SALDO = 0   " + LF
cQuery += " AND CAST(CAST(E1_BAIXA AS DATETIME) - CAST(E1_VENCREA AS DATETIME)AS INTEGER) > 0 " + LF
cQuery += " AND E1_CLIENTE IN ('000220','000529','000662','000789','000907','001012','001151' " + LF
cQuery += "                      ,'001728','001926','001995','002044','003048','003214' " + LF
cQuery += "                      ,'004498','004599','004615','004796','004881','005111' " + LF
cQuery += "                      ,'005376','005510','005536','005659','005711','000130' " + LF
cQuery += "                      ,'000108','002442','032081','002288','004241','002543') " + LF
cQuery += " GROUP BY  " + LF
cQuery += " E1_BAIXA  " + LF
cQuery += " ,E1_VENCREA  " + LF
cQuery += " ,E1_CLIENTE,E1_LOJA, E1_NOMCLI " + LF
cQuery += " ORDER BY DIAS,E1_CLIENTE,E1_LOJA " + LF
MemoWrite("C:\TEMP\E130.SQL" , cQuery )
TCQUERY cQUery NEW ALIAS "TEMP1"
TEMP1->( dbGoTop() )
t:= 1      
nORDANT := 0
If !TEMP1->(EOF())
	nORD := TEMP1->DIAS
	nORDANT := TEMP1->DIAS
	While !TEMP1->(EOF())
		If Alltrim(TEMP1->E1_CLIENTE + TEMP1->E1_LOJA) != Alltrim(cCliAnt)
			//adiciona num array primeiro pela ordem de cliente
			If t = 1
				nOrdem := TEMP1->DIAS
			Endif
			If t > 1
				If TEMP1->DIAS = nORD 
					nOrdem := nORDANT + 1
				Elseif TEMP1->DIAS < nORDANT
					nOrdem := nORDANT + 1  //TEMP1->DIAS
					nORD   := nORDANT + 1  //TEMP1->DIAS
				Elseif (TEMP1->DIAS - nORDANT) >= 2  //SE A DIFERENวA ENTRE ELES FOR MAIOR Q 2, ENTรO ASSUMO DE NOVO O nORDANT + 1
					nOrdem := nORDANT + 1  //TEMP1->DIAS
					nORD   := nORDANT + 1  //TEMP1->DIAS
				Else
					nOrdem := TEMP1->DIAS
					nORD   := TEMP1->DIAS
				Endif
				nORDANT := nOrdem
			Endif
			Aadd(aPref , { Alltrim(TEMP1->E1_CLIENTE + TEMP1->E1_LOJA) , nOrdem } )       //O Zero depois serแ alimentado com a ordem(*)
			cCliAnt := (TEMP1->E1_CLIENTE + TEMP1->E1_LOJA)
			
		Endif    
		t++
		TEMP1->(Dbskip())
	Enddo               
	
Endif
nOrdem := 0
nODR   := 0
t      := 0

cQuery := "SELECT C6_FILIAL, C6_NUM ,C5_ENTREG, C5_EMISSAO, C5_CONDPAG, A1_COD, A1_LOJA, A1_NOME " + LF
//If xFilial("SC6") == '01'
	cQuery += " ,SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESO) AS PESO " + LF
//Elseif xFilial("SC6") == '03'
	cQuery += " ,SUM( SC6.C6_QTDVEN - SC6.C6_QTDENT  ) AS QTDE " + LF
//Endif
cQuery += " ,SC6.C6_UM  UM " + LF
cQuery += " ,SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS TOTAL " + CHR(13) + CHR(10)
cQuery += " , A3_COD, A3_EMAIL, A3_SUPER , E4_DESCRI " + LF

cQuery += "FROM "+RetSqlName("SC6")+" SC6 " + LF
cQuery += " , "+RetSqlName("SA1")+" SA1 " + LF
cQuery += " , "+RetSqlName("SB1")+" SB1 " + LF
cQuery += " , "+RetSqlName("SC5")+" SC5 " + LF
cQuery += " , "+RetSqlName("SA3")+" SA3 " + LF 
cQuery += " , "+RetSqlName("SE4")+" SE4 " + LF 

cQuery += " WHERE " + LF 
cQuery += " (SC6.C6_QTDVEN - SC6.C6_QTDENT) > 0  " + LF

If !Empty(MV_PAR01)
	cQuery += " and SC5.C5_EMISSAO >= '" + Dtos(MV_PAR01) + "' " + LF 
Endif

cQuery += " AND C5_FILIAL = '" + xFilial("SC5") + "' " + LF
cQuery += "  AND C5_CONDPAG = E4_CODIGO  " + LF
cQuery += " AND (A1_COD+A1_LOJA) = (C6_CLI + C6_LOJA) " + LF
cQuery += " AND C5_FILIAL = C6_FILIAL " + LF
cQuery += " AND C5_NUM = C6_NUM " + LF
cQuery += " AND C5_VEND1 = A3_COD " + LF

cQuery += " AND C6_PRODUTO = B1_COD " + LF

cQuery += " AND SC6.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SB1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA3.D_E_L_E_T_ = '' " + LF
cQuery += " AND SE4.D_E_L_E_T_ = '' " + LF

cQuery += " AND SA1.A1_COD  IN ('000220','000529','000662','000789','000907','001012','001151' " + LF
cQuery += "                     ,'001728','001926','001995','002044','003048','003214' " + LF
cQuery += "                     ,'004498','004599','004615','004796','004881','005111' " + LF
cQuery += "                     ,'005376','005510','005536','005659','005711','000130' " + LF
cQuery += "                     ,'000108','002442','032081','002288','004241','002543' ) " + LF 

cQuery += " AND B1_GRUPO IN ('A','B') " + LF //linha institucional

cQuery += " GROUP BY " + LF
cQuery += " A1_COD,A1_LOJA, E4_DESCRI, C6_FILIAL, C6_NUM ,C5_ENTREG, C5_EMISSAO, C5_CONDPAG, A1_COD, A1_NOME " + LF
cQuery += " , A3_COD, A3_EMAIL, A3_SUPER, C6_UM " + LF

cQuery += " ORDER BY A1_COD, A1_LOJA , C6_NUM " + LF
MemoWrite("C:\TEMP\FATR039.SQL", cQuery)

TCQUERY cQUery NEW ALIAS "PEDX"
TCSetField( 'PEDX', 'C5_EMISSAO', 'D' )
TCSetField( 'PEDX', 'C5_ENTREG', 'D' )
TCSetField( 'PEDX', 'C9_DATALIB', 'D' )
PEDX->( dbGoTop() )
If !PEDX->(EOF())  
	x := 1
	nORD := aPref[1,2]
	nORDANT := aPref[1,2]
	nOrdem  := aPref[1,2]
	
	While !PEDX->(EOF())
		//adiciona num array primeiro pela ordem de cliente
		t      := 0
		lJa    := .F.
		For t := 1 to Len(aPref)
			If Alltrim(aPref[t,1]) = Alltrim(PEDX->A1_COD + PEDX->A1_LOJA) //se encontrar o cliente no array...pega a ordem que tแ nele (apref[t,2])
				If x = 1
					nOrdem  := aPref[1,2]
				Endif
				
				If x > 1
					If !lJa
						lJa := .T.
						If aPref[t,2] = nORD 
							nOrdem := nORDANT + 1
						Elseif aPref[t,2] < nORDANT
							nOrdem := nORDANT + 1  //TEMP1->DIAS
							nORD   := nORDANT + 1  //TEMP1->DIAS
						Elseif (aPref[t,2] - nORDANT) >= 2  //SE A DIFERENวA ENTRE ELES FOR MAIOR Q 2, ENTรO ASSUMO DE NOVO O nORDANT + 1
							nOrdem := nORDANT + 1  //TEMP1->DIAS
							nORD   := nORDANT + 1  //TEMP1->DIAS
						Else
							nOrdem := aPref[t,2]
							nORD   := aPref[t,2]
						Endif
						nORDANT := nOrdem
					Endif				
				Endif    //x > 1
			Endif
		Next	
			//nOrdem := Ascan( aPref, Alltrim(PEDX->A1_COD + PEDX->A1_LOJA) )
			If nOrdem > 0
				//nODR   := aPref[nOrdem,2]
					Aadd(aPed , {PEDX->C6_NUM,;      	//1
						PEDX->A1_COD,;      //2
						PEDX->A1_LOJA,;     //3
						PEDX->TOTAL,;       //4
						PEDX->C5_ENTREG,;   //5
						PEDX->E4_DESCRI,;   //6
						PEDX->A3_COD,;      //7
						PEDX->A3_SUPER,;    //8
						PEDX->A1_NOME,;     //9
						nOrdem,;              //10
						PEDX->C5_EMISSAO ,;  //11
						PEDX->QTDE, ;		 //12
						PEDX->UM ,;			 //13
						PEDX->PESO;
						} )      
			Endif
	    x++
		PEDX->(Dbskip())
	Enddo               
	aPed   := Asort( aPed,,, { | x, y | Transform(x[ 10 ] , "@E 99999") + x[ 1 ]  <  Transform( y[ 10 ], "@E 99999") + y[ 1 ] } ) //ordem preferencial + n๚mero pedido
Endif

t:= 1
If Len(aPed) > 0

   Do While t <= Len(aPed)
	   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณ Verifica o cancelamento pelo usuario...                             ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      //Exit
	   Endif
	
	   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณ Impressao do cabecalho do relatorio. . .                            ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	   
	
	   If nLin > 55
	      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
	      //@nLin, 00 PSay Cab
	      //nLin++
	      //@nLin, 00 PSay Replicate("-",Limite)
	      //nLin++      
	   Endif
	   
	   @nLin,000 PSAY Transform(aPed[t,10],"@E 9999")  //ordem prioridade
	   @nLin,010 PSAY aPed[t,1] //n๚mero pedido
	   @nLin,018 PSAY DTOC( aPed[t,11] )
	   @nLin,030 PSAY aPed[t,2] + '/' + aPed[t,3] +" - "+SUBS(aPed[t,9],1,30)
	   @nLin,074 PSAY DTOC(aPed[t,5])   
	   @nLin,085 PSAY Transform(aPed[t,12], "@E 9,999,999.9999") //qtde na UM do pedido (ex.: MR - Milheiro)
	   @nLin,101 PSAY aPed[t,13]  //um
	   If xFilial("SC6") == '01'
	   	@nLin,104 PSAY Transform(aPed[t,14],"@E 9,999,999.9999") //qtde em kg
	   Endif
	   
	   @nLin,118 PSAY Transform(aPed[t,4], "@E 9,999,999.99") //valor total
	   @nLin,132 PSAY aPed[t,6]      //condi็ใo pagamento
	   nTOTGER += aPed[t,4]
	   nLin ++
	   t++

	Enddo
	@nLin,000 PSAY REPLICATE(".", limite)
	nLin++
	@nLin,000 PSAY "T O T A L    G E R A L  ==> " 
	@nLin,118 PSAY Transform(nTOTGER, "@E 9,999,999.99")
	nLin++                               
	@nLin,000 PSAY REPLICATE(".", limite)
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Roda( 0, "", TAMANHO )
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

RETURN


         


