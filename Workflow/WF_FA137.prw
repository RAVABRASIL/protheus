#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "Directry.ch"
#include "ap5mail.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  04/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*************

User Function WFFA137()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFA137" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa WFFA137 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  FA137()
Else
  conOut( "Programa WFFA137 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  MsAguarde( { || FA137(), "Aguarde por favor.", "Gerando os e-mails..."} )
EndIf
conOut( "Finalizando programa WFFA137 em " + Dtoc( DATE() ) + ' - ' + Time() )

return

*************

Static Function FA137()

*************

Local cQry      := ""
Local cDesc1    :="Posicao dos Titulos a Receber por Vendedor"
Local cDesc2    :=""
Local cDesc3    :=""
Local cString   :="SE1"
Local nValor
Local nSaldo    := 0
Local dOldDtBase:= dDataBase
Private wnrel
Private titulo  :=""
Private cabec1  :=""
Private cabec2  :=""
Private aLinha  :={}
Private aReturn :={,1,, 1, 1, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg	:="FIN137"
Private nJuros  :=0
Private nLastKey:=0
Private nomeprog:="FINR137"
Private tamanho :="G"
Private aTam    :={}
Private aCampos :={}
Private cArquivo:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "Posicao dos Titulos a Receber por Vendedor"
cabec1 := "PRF NUMERO PARC TIPO  CLIENTE LOJA  NOME DO CLIENTE           EMISSAO      VENCIMENTO                     VALOR             SALDO  NATUREZA   DESCRICAO                        VALOR DE JUROS  ATRASO"
cabec2 := ""

//PutDtBase() Não funcionou

pergunte("FIN137",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Variaveis utilizadas para parametros
mv_par01 := "      "       // Do Cliente
mv_par02 := "  "		 // Da Loja
mv_par03 := "ZZZZZZ" // Ate o Cliente
mv_par04 := "ZZ"// Ate a Loja
mv_par05 := stod(alltrim(str(year(dDataBase))) + "0101")//dDataBase - 9// Da Emissao 
mv_par06 := stod(alltrim(str(year(dDataBase))) + "1231")//dDataBase - 3// Ate Emissao
mv_par07 := dDataBase - 9//firstDay(dDataBase)// Do vencimento
mv_par08 := dDataBase - 3//stod(alltrim(str(year(dDataBase))) + "1231")// Ate o vencimento
//mv_par09		 // Do vendedor
//mv_par10		 // Ate o vendedor
mv_par11 := "                                        "// Considera Tipos
mv_par12 := "TP,TBX,TSP,TCC,TX                       "// Nao considera tipos
mv_par13 := 1    // Qual moeda
mv_par14 := 2    // Outras Moedas : 1-converte 2=nao imprime
mv_par15 := 2    // Compoe Sld Retroativ: 1-Sim, 2=Nao
mv_par16 := dDataBase // Database - Como será rodado toda terça-feira, dDataBase
mv_par17 := 1    // Considera Filiais abaixo (1=Sim/2=Nao)
mv_par18 := "  "   // Filial De
mv_par19 := "ZZ" // Filial Ate
mv_par20 := 1	 // Salta Pag. Vendedor
mv_par21 := 1    //Converte valores pela taxa do dia ou taxa do mov.

titulo += GetMv("MV_MOEDA" + Str(mv_par13,1,0) ) //" Valores em  "

cQry += "select A3_COD, A3_NOME "
cQry += "from   "+retSqlName("SA3")+" "
cQry += "where  A3_ATIVO = 'S' and A3_FILIAL = '"+xFilial("SA3")+"' and "
cQry += "D_E_L_E_T_ != '*' "
TCQUERY cQry NEW ALIAS "_TMPZ"
_TMPZ->( dbGoTop() )
do While !_TMPZ->( EoF() )
	mv_par09 := mv_par10 := _TMPZ->A3_COD
	wnrel:=alltrim(criatrab(,.F.))//colocar para só criar se não for EoF
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,Tamanho,,,,,,.T.)
	SetDefault(aReturn,cString)
	RptStatus({|lEnd| RFA137(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio		
	_TMPZ->( dbSkip() )
    sleep( 10000 )
endDo
_TMPZ->( dbCloseArea() )

If mv_par15 == 1
	dDataBase := dOldDtBase
Endif	

Return

***************

Static Function RFA137(lEnd, WnRel, cString)

***************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nTotal := 0
Local nTotalGeral := 0
Local cVend
Local nAtraso
Local lFirst := .T.
Local aArea := GetArea()
Local nTotJur := 0
Local nAbatim := 0
Local aLiquid   := {}
Local cVendedor
Local nVend	:= 0
Local nSaldo := 0
Local nX, nY, nHdl
Local lLiq := .F.
Local lExiste := .F.
#IFDEF TOP
	Local cQuery:= ""
	Local nI := 0
	Local aStru := SE1->(dbStruct())
#ENDIF

cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Geracao do arquivo de Trabalho	        			         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aTam:=TamSX3("E1_VEND1")
AADD(aCampos,{"CODVEND"  ,"C",aTam[1],aTam[2]})

aTam:=TamSX3("E1_FILIAL")
AADD(aCampos,{"FILIAL"    ,"C",aTam[1],aTam[2]})

aTam:=TamSX3("E1_PREFIXO")
AADD(aCampos,{"PREFIXO"    ,"C",aTam[1],aTam[2]})

aTam:=TamSX3("E1_NUM")
AADD(aCampos,{"NUM"    ,"C",aTam[1],aTam[2]})

aTam:=TamSX3("E1_PARCELA")
AADD(aCampos,{"PARCELA"    ,"C",aTam[1],aTam[2]})

aTam:=TamSX3("E1_TIPO")
AADD(aCampos,{"TIPO"    ,"C",aTam[1],aTam[2]})

aTam:=TamSX3("E1_SALDO")
AADD(aCampos,{"SALDO"    ,"N",aTam[1],aTam[2]})

cArq:=CriaTrab(aCampos)
dbUseArea( .T.,, cArq, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cArq,"CODVEND",,,"Selecionando Registros...") //"Selecionando Registros..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par17 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par18	// Todas as filiais
	cFilAte:= mv_par19
Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

//Acerta a database de acordo com o parametro
If mv_par15 == 1    // Considera Data Base
	dDataBase := mv_par16
Endif	

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte

	dbSelectArea("SE1")
	cFilAnt := SM0->M0_CODFIL

	#IFDEF TOP
		cQuery := "SELECT * FROM" + RetSqlName("SE1") + " WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND "
		cQuery += "E1_CLIENTE >= '" + MV_PAR01 + "' AND E1_CLIENTE <= '" + MV_PAR03 + "' AND "
		cQuery += "E1_LOJA >= '" + MV_PAR02 + "' AND E1_LOJA <= '" + MV_PAR04 + "' AND " 		
	  	cQuery += "E1_EMISSAO >= '" + DTOS(MV_PAR05) + "' AND E1_EMISSAO <= '" + DTOS(MV_PAR06) + "' AND "
		cQuery += "E1_VENCTO >= '" + DTOS(MV_PAR07) + "' AND E1_VENCTO <= '" + DTOS(MV_PAR08) + "'AND "
		cQuery += "D_E_L_E_T_=' ' "
		cQuery := ChangeQuery(cQuery)
		dbSelectArea("SE1")
		dbCloseArea()
		dbSelectArea("SA1")
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SE1",.F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("SE1", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		dbSelectArea("SE1")
		dbGoTop()
	#ELSE
		cString := 'E1_FILIAL=="'+xFilial("SE1")+'".And.'
		cFiltro := "E1_CLIENTE >= '" + MV_PAR01 + "' .AND. E1_CLIENTE <= '" + MV_PAR03 + "' .AND. "
		cFiltro += "E1_LOJA >= '" + MV_PAR02 + "' .AND. E1_LOJA <= '" + MV_PAR04 + "' .AND. "
	  	cFiltro += "DTOS(E1_EMISSAO) >= '" + DTOS(MV_PAR05) + "' .AND. DTOS(E1_EMISSAO) <= '" + DTOS(MV_PAR06) + "' .AND. "
		cFiltro += "DTOS(E1_VENCTO)  >= '" + DTOS(MV_PAR07) + "' .AND. DTOS(E1_VENCTO)  <= '" + DTOS(MV_PAR08) + "'"
		cIndTmp := CriaTrab(nil,.F.)
		IndRegua("SE1",cIndTmp,IndexKey(),,cFiltro,STR0006)
		nIndexSE1 := RetIndex("SE1")
		dbSetIndex(cIndTmp+OrdBagExt())
		dbSetOrder(nIndexSe1+1)
		dbSelectArea("SE1")
		dbSeek(xFilial("SE1"))
	#ENDIF
	
	cFilterUser:=aReturn[7]         

	If Select("__SE1") == 0
		ChkFile("SE1",.F.,"__SE1")
	Endif

	dbSelectArea("SE1")
	
	While !Eof() .and. SE1->E1_FILIAL == xFilial("SE1")

		lLiq 		:= .F.
		aLiquid 	:= {}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser).and.!(&cFilterUser)
			SE1->(dbSkip())
			Loop
		Endif

		If !Empty(mv_par11)
			If !SE1->E1_TIPO $ mv_par11
				SE1->(dbSkip())
				Loop
			Endif
		Endif
	    
		If !Empty(mv_par12)
			If SE1->E1_TIPO $ mv_par12
				SE1->(dbSkip())
				Loop
			Endif
		Endif

		If mv_par14 == 2 .And. SE1->E1_MOEDA != mv_par13
			SE1->(dbSkip())
			Loop
		EndIf
                                                       
		If SE1->E1_EMISSAO > mv_par16
			SE1->(dbSkip())
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se é título Liquidado.                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SE1->E1_NUMLIQ) .And. SE1->E1_SALDO <> 0 .And. ! SE1->E1_TIPO $ MV_CRNEG 
			If mv_par15 == 2
				nSaldo:=xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,MV_PAR13,,,Iif(MV_PAR21==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Else
				nSaldo:=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par13,mv_par16,,SE1->E1_LOJA,,Iif(MV_PAR21==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Endif

			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( MV_PAR15 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,,SE1->E1_CLIENTE,SE1->E1_LOJA)
					If STR(nSaldo,17,2) == STR(nAbatim,17,2)
						nSaldo := 0
					Else
						nSaldo-= nAbatim
					Endif
				Endif	
			Else
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif

			nSaldo:=Round(NoRound(nSaldo,3),2)
	
			If nSaldo <= 0
				SE1->(dbSkip())
				Loop
			Endif
	
			Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid)		    
			nVend := fa440CntVen()

			For nX := 1 To Len(aLiquid)
				dbSelectArea("__SE1")
				__SE1->(MsGoto(aLiquid[nX]))
				// Processa a quantidade de vendedores
				For nY := 1 To nVend
					cVendedor := "E1_VEND" + AllTrim(Str(nY))
					If __SE1->&(cVendedor) >= mv_par09 .AND. __SE1->&(cVendedor) <= mv_par10 .AND. !Empty(__SE1->&(cVendedor))
						R137TMP(__SE1->&(cVendedor),nSaldo)
					EndIf
				Next
			Next
			lLiq := .T.
			dbSelectArea("SE1")
			dbSkip()
			Loop
      EndIf

		If mv_par15 == 2 .and. SE1->E1_SALDO == 0
			SE1->(dbSkip())
			Loop
		Endif
		
		If Empty(SE1->E1_VEND1+SE1->E1_VEND2+SE1->E1_VEND3+SE1->E1_VEND4+SE1->E1_VEND5)
			SE1->(dbSkip())
			Loop
		EndIf
	      
		 // Tratamento da correcao monetaria para a Argentina
		If  cPaisLoc=="ARG" .And. mv_par13 <> 1  .And.  SE1->E1_CONVERT=='N'
				SE1->(dbSkip())
				Loop
		Endif

		If !lLiq		//Se não for titulo liquidado
			If mv_par15 == 2
				nSaldo:=xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,MV_PAR13,,,Iif(MV_PAR21==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			ELSE         	
				nSaldo:=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par13,mv_par16,,SE1->E1_LOJA,,Iif(MV_PAR21==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
			Endif
	
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( MV_PAR15 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,,SE1->E1_CLIENTE,SE1->E1_LOJA)
					If STR(nSaldo,17,2) == STR(nAbatim,17,2)
						nSaldo := 0
					Else
						nSaldo-= nAbatim
					Endif
				Endif	
			Else
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif
			nSaldo:=Round(NoRound(nSaldo,3),2)
	
			If nSaldo <= 0
				SE1->(dbSkip())
				Loop
			Endif    
			
			nVend := fa440CntVen()

			For nY := 1 To nVend
				cVendedor := "E1_VEND" + AllTrim(Str(nY))
				If SE1->&(cVendedor) >= mv_par09 .And. SE1->&(cVendedor) <= mv_par10 .AND. !Empty(SE1->&(cVendedor))
					R137TMP(SE1->&(cVendedor),nSaldo)
				EndIf
			Next

			dbSelectArea("SE1")
			dbSkip()
		EndIf
	Enddo

	If Empty(xFilial("SE1"))
		Exit
	Endif

	dbSelectArea("SM0")
	dbSkip()
	Loop
Enddo	

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL

#IFDEF TOP
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	dbSetOrder(1)
#ENDIF

TRB->(dbgotop())

While !TRB->(EOF())

	IF li > 58
		li:=	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		li++
	Endif
	
	cVar:= TRB->CODVEND
	nTotal := 0
	nTotJur := 0 
	cVend:=Space(06)
	While !TRB->(EOF()) .AND. cVar==TRB->CODVEND
		lExiste := .T.
		cVend:=TRB->CODVEND
		
		IF li > 58
			li:=	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			li++
		Endif
		
		If lFirst
			dbSelectArea("SA3")
			dbSetOrder(1)
			Dbseek(xFilial("SA3") + cVend)
			@Li, 0 PSAY cVend + "-" + SA3->A3_NOME
			lFirst := .F.
			Li+=2	
		Endif		

		SE1->(dbSeek(TRB->(FILIAL+PREFIXO+NUM+PARCELA+TIPO)))
		nValor:=xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR13,,,Iif(MV_PAR21==2,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0))
		nAtraso:=(mv_par16-SE1->E1_VENCTO)
		nAtraso:= If(nAtraso < 0, 0, nAtraso)
				
		@Li,000 PSAY TRB->PREFIXO
		@Li,004 PSAY TRB->NUM
		@Li,014 PSAY TRB->PARCELA
		@Li,017 PSAY TRB->TIPO
		@Li,023 PSAY SE1->E1_CLIENTE
		@Li,035 PSAY SE1->E1_LOJA
		@Li,041 PSAY SE1->E1_NOMCLI
		@Li,066 PSAY SE1->E1_EMISSAO
		@Li,079 PSAY SE1->E1_VENCTO
		@Li,103 PSAY nValor PICTURE "@E 99999,999.99"
		@Li,121 PSAY TRB->SALDO PICTURE "@E 99999,999.99"
	
		dbSelectArea("SE1")
		nJuros := 0
		fa070juros(mv_par13)
		@Li,131 PSAY nJuros	PICTURE "@E 99999,999.99"
		@Li,144 PSAY TRB->SALDO+nJuros PICTURE "@E 99999,999.99"
		@Li,157 PSAY SE1->E1_NATUREZ
		
		dbSelectArea("SED")
		dbSetOrder(1)
		MsSeek(xFilial("SED") + SE1->E1_NATUREZ)
	
		@Li,168 PSAY SED->ED_DESCRIC
		@Li,199 PSAY nAtraso Picture "9999"
	
		nTotJur += nJuros
		If SE1->E1_TIPO $ MV_CRNEG+"/"+MVRECANT
			nTotal -=  TRB->SALDO
		Else
			nTotal +=  TRB->SALDO
		Endif
		li++

		TRB->(dBskip())
	Enddo
    lFirst := .T.
	dbSelectArea("SA3")
	dbSetOrder(1)
	Dbseek(xFilial("SA3") + cVend)

	Li++
	@Li, 000 PSAY "TOTAL DO VENDEDOR : " + cVar + " " + SA3->A3_NOME //"TOTAL DO VENDEDOR : "
	@Li, 121 PSAY nTotal	PICTURE "@E 99999,999.99" 
	@Li, 131 PSAY nTotJur	PICTURE "@E 99999,999.99"
	@Li, 144 PSAY nTotal+nTotJur	PICTURE "@E 99999,999.99"
	Li++
    	
	nTotalGeral += nTotal+nTotJur
	li+=2

	If mv_par20 == 1
		li:=	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		li++
	Endif	
Enddo

If nTotalGeral > 0
	li+=2
	@li,   0 PSAY "TOTAL GERAL : "
	@li ,144 PSAY nTotalGeral		PICTURE	 "@E 99999,999.99"
	li++
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
	Ferase(cArq+GetDBExtension())      // Elimina arquivos de Trabalho
	Ferase(cArq+OrdBagExt())			  // Elimina arquivos de Trabalho
	aCampos := {}
Endif

RestArea(aArea)
//Set Device To Screen
MS_FLUSH()

iif(lExiste,EVMAIL2(_TMPZ->A3_NOME,wnrel),FErase( iif( Select('SX2')==0, "\RELATO\",alltrim(pswRet()[2][3]))+wnrel+".##r" ) )

/*Set Device To Screen
Set Filter to

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()*/

Return


***************
Static Function EVMAIL2(cRepres,cRel)
***************

Local lResult, lText
Local cDesc, cTitle, cFrom, cEmail, __cMailAdt
Local cAttach 		:= iif( Select( 'SX2' ) != 0, alltrim(pswRet()[2][3]), "\RELATO\" ) + cRel + ".##r"
//Local cAttach 		:= "\RELATO\"+cRel+".##r"
Local __cAccount	:= GetMV( "MV_RELACNT" )
Local __cPassword	:= GetMV( "MV_RELPSW"  )
Local __cServer		:= GetMV( "MV_RELSERV" )
Local __nTimeOut    := GetMV( "MV_RELTIME",,30)
LocaL aFiles        := {}

__cMailAdt := ""
cDesc   := "Segue em anexo o relatório de "+"Títulos Vencidos"+" do representante " + cRepres
cTitle  := ""+"Títulos Vencidos"+" do representante " + cRepres
cFrom   := "ravaembalagens@ravaembalagens.com.br"
   cEmail  := "alessandra@ravaembalagens.com.br;alcineide@ravaembalagens.com.br"    //"jacqueline@ravaembalagens.com.br" 
cAttach := strtran(cAttach, "\\", "\")

nHdl1 := FOpen(cAttach)

If FSeek(nHdl1,0,2) <= 0	 // Verifica o tamanho do arquivo
   return
endIf

lResult := MailSmtpOn(__cServer,__cAccount,__cPassword,__nTimeOut)

cArquivo := cAttach
If File(cArquivo)
	cNewFile := Subs(cArquivo,1,At(".",cArquivo))+"TXT"//cNewFile := Subs(cArquivo,1,At(".",cArquivo))+".TMP"
	__CopyFile(cArquivo,cNewFile)
	nHdl := If(File(cNewFile),1,-1)//para testar se o novo arqvuio foi criado
	aAdd(aFiles, cNewFile )
Else
	cNewFile := cArquivo
	nHdl := -1
	conout("WF_FA137 -- Erro na abertura do arquivo de relatório no envio do email!")
	return
EndIf
lResult := MailAuth(__cAccount,__cPassword)
If !lResult
	lResult := MailUser()
EndIf
If lResult
	cDesc   := Trim(cDesc)
	cDesc   := If(Empty(cDesc),"",("Descrição:"+"<br>"+cDesc)) //Descrição:"
	cTitle  := Trim(cTitle)
	cTitle  := If(Empty(cTitle),"",(cTitle)) //Advanced Protheus Report - "		
	lResult := MailSend(cFrom,{cEmail},{},{},cTitle,cDesc,aFiles,lText)
	If lResult
		cMsgInfo := "O e-mail foi enviado com sucesso." //O e-mail foi enviado com sucesso."
	Else
		cMsgInfo := "O e-mail não pode ser enviado."+Chr(13)+Chr(10)+"Error:"+AllTrim(MailGetErr()) //O e-mail não pode ser enviado."
	EndIf
	MailSmtpOff()
Else                                                                                                       
	cMsgInfo := "Não foi possível conectar ao servidor de e-mail."+__cServer+Chr(13)+Chr(10)+"Error:"+AllTrim(MailGetErr()) //Não foi possível conectar ao servidor de e-mail."
EndIf

FClose(nHdl1)
FErase(cAttach)
FErase(cNewFile)
Return



**************************************
Static Function R137TMP(cCampo,nSaldo)
**************************************

Local aArea := GetArea()

Reclock("TRB", .T.)
TRB->CODVEND:=cCampo
TRB->FILIAL :=SE1->E1_FILIAL
TRB->PREFIXO:=SE1->E1_PREFIXO
TRB->NUM:=SE1->E1_NUM
TRB->PARCELA:=SE1->E1_PARCELA
TRB->TIPO:=SE1->E1_TIPO
TRB->SALDO:=nSaldo
Msunlock()
RestArea( aArea )

Return