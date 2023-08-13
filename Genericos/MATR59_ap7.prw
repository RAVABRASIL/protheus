#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function MATR59()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,TITULO,CDESC1,CDESC2,CDESC3,WNREL")
SetPrvt("TAMANHO,LIMITE,CSTRING,NVALOR1,NVALOR2,NVALOR3")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,CTABTES")
SetPrvt("LI,M_PAG,NTIPO,LEND,CBCONT,CABEC1")
SetPrvt("CABEC2,ACAMPOS,ATAM,NAG1,NAG2,NAG3")
SetPrvt("NRANK,CCLIENTE,CLOJA,CEST,NMOEDA,CMOEDA")
SetPrvt("NESTV1,NESTV2,NESTV3,NAG4,NAG5,NAG6")
SetPrvt("NESTV4,NESTV5,NESTV6,NVALOR4,NVALOR5,NVALOR6")
SetPrvt("CPICT,CNOMARQ,CNOMARQ1,CNOMARQ2,CDELARQ,NTOTAL")
SetPrvt("NVALICM,NVALIPI,CTESANT,CCHAVE,NTB_VALOR1,NTB_VALOR2")
SetPrvt("NTB_VALOR3,NTB_VALOR4,NTB_VALOR5,NTB_VALOR6,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR590  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faturamento por Cliente                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR590(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rdmake    ³ Autor ³ Luiz Carlos Vieira    ³ Data ³ Wed  05/08/98       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt  := ""
titulo := "Faturamento por Cliente"
cDesc1 := "Este relatorio emite a relacao de faturamento. Podera ser"
cDesc2 := "emitido por ordem de Cliente ou por Valor (Ranking).     "
cDesc3 := "Se no TES estiver gera duplicata (N), nao sera computado."
wnrel  := ""
tamanho:=" "
limite :=132
cString:="SF2"
nValor1:= 0
nValor2:= 0
nValor3:= 0

aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="MATR590"
aLinha  := { }
nLastKey := 0
cPerg   :="MTR590"
cTabTes :=""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
li       := 80
m_pag    := 01


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR590",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Data de                  		           ³
//³ mv_par02        	// Data ate  										  ³ 
//³ mv_par03        	// Cliente de                               ³
//³ mv_par04 	      // Cliente ate                              ³
//³ mv_par05	      // Estado de                                ³
//³ mv_par06	      // Estado ate                               ³
//³ mv_par07	      // Cliente  Valor  Estado                   ³
//³ mv_par08	      // Moeda                                    ³
//³ mv_par09         // Devolucao				                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tes()

nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "MATR590"      
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If nLastKey==27
	Set Filter to
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
   Return
Endif

lEnd := .F.
#IFDEF WINDOWS
    RptStatus({|| C590Imp()},Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     RptStatus({|| Execute(C590Imp)},Titulo)
    Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     Function C590Imp
Static Function C590Imp()
#ENDIF

CbTxt  := ""
titulo := "Faturamento por Cliente"
cDesc1 := "Este relatorio emite a relacao de faturamento. Podera ser"
cDesc2 := "emitido por ordem de Cliente ou por Valor (Ranking).     "
cDesc3 := "Se no TES estiver gera duplicata (N), nao sera computado."
CbCont := ""
cabec1 := ""
cabec2 := ""
tamanho:=" "
limite :=132
aCampos := {}
aTam    := {}
nAg1:=0
nAg2:=0
nAg3:=0
nRank:=0
cCliente := ""
cLoja    := ""
cEst     := ""
nMoeda   := 0
cMoeda:=""
nValor1  := 0
nValor2  := 0
nValor3  := 0
nEstV1:=0
nEstV2:=0
nEstV3:= 0
nAg4:=0
nAg5:=0
nAg6:=0
nEstV4:=0
nEstV5:=0
nEstV6:=0
nValor4  := 0
nValor5  := 0
nValor6  := 0
cPict:="@E) 999,999,999,999.99"
nTipo:=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 00
li       := 80
m_pag    := 01

nMoeda := mv_par08
cMoeda := "mv_moeda"+STR(nMoeda,1)
cMoeda := &cMoeda

IF mv_par07 == 1
    titulo := "FATURAMENTO POR CLIENTE  (CODIGO) - " + cmoeda
ElseIf mv_par07 == 2
    titulo := "FATURAMENTO POR CLIENTE  (RANKING) - "+ cMoeda
Else
    titulo := "FATURAMENTO POR CLIENTE  (ESTADO) - "+ cMoeda
EndIF

cabec1 := "COD/LOJA RAZAO SOCIAL                                    FATURAMENTO          VALOR DA                 VALOR  RANKING"
cabec2 := "                                                           SEM ICM           MERCADORIA                TOTAL         "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("F2_CLIENTE")
AADD(aCampos,{ "TB_CLI"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_LOJA")
AADD(aCampos,{ "TB_LOJA"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_EST")
AADD(aCampos,{ "TB_EST"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_EMISSAO")
AADD(aCampos,{ "TB_EMISSAO","D",aTam[1],aTam[2] } )
AADD(aCampos,{ "TB_VALOR1 ","N",18,2 } )		// Valores de Faturamento
AADD(aCampos,{ "TB_VALOR2 ","N",18,2 } )
AADD(aCampos,{ "TB_VALOR3 ","N",18,2 } )
AADD(aCampos,{ "TB_VALOR4 ","N",18,2 } )		// Valores para devolucao
AADD(aCampos,{ "TB_VALOR5 ","N",18,2 } )
AADD(aCampos,{ "TB_VALOR6 ","N",18,2 } )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq,cNomArq, if(.T. .OR. .F., !.F., NIL), .F. )
cNomArq1 := SubStr(cNomArq,1,7)+"1"
cNomArq2 := SubStr(cNomArq,1,7)+"2"

IndRegua(cNomArq,cNomArq1,"TB_CLI+TB_LOJA",,,"Selecionando Registros...")

dbSelectArea("SF2")
dbSetOrder(2)

SetRegua(RecCount())		// Total de Elementos da regua
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao para gerar arquivo de Trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTrab()

If mv_par09 == 1
	dbSelectArea("SF1")
	dbSetOrder(2)
	IncRegua()
	GeraTrab1()
Endif

DbSelectArea(cNomArq)
DbClearIndex()

If mv_par07 == 1
	IndRegua(cNomArq,cNomArq1,"TB_CLI+TB_LOJA",,,"Selecionando Registros...")
ElseIf mv_par07 == 2
	IndRegua(cNomArq,cNomArq2,"StrZero(1000000000000 - TB_VALOR3 + TB_VALOR6,18,2)",,,"Selecionando Registros...")
Else	
	IndRegua(cNomArq,cNomArq1,"TB_EST+TB_CLI+TB_LOJA",,,"Selecionando Registros...")
Endif

dbSelectArea(cNomArq)
dbGoTop()

While !Eof()
	IncRegua()
		
	#IFNDEF WINDOWS
        If LastKey() == 286    //ALT_A
			lEnd := .t.
		End	
	#ENDIF
	
	If lEnd
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit  
	Endif
	
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	If mv_par07 == 3
		If Empty(cEst)
			cEst := TB_EST
		ElseIf cEst != TB_EST
            li := li + 1
			@li, 00 PSAY "Total do Estado de " + cEst + "--->"
			@li, 50 PSAY nEstV1		PicTure cPict 
			@li, 70 PSAY nEstV2		PicTure cPict 
			@li, 90 PSAY nEstV3		PicTure cPict 

			If nEstv4+nEstv5+nEstv6!=0
				@li, 50 PSAY nEstV4		PicTure cPict 
				@li, 70 PSAY nEstV5		PicTure cPict 
				@li, 90 PSAY nEstV6		PicTure cPict 
				@li, PCol()+12 PSAY "DEV"
			Endif
			cEst := TB_EST
            li := li + 1
			nEstV1:=0
			nEstV2:=0
			nEstV3:=0
			nEstV4:=0
			nEstV5:=0
			nEstV6:=0
            li := li + 1
		EndIf
		@ li,00 PSAY "Estado: " + cEst
        li := li + 1
	EndIf	

	cCliente := TB_CLI
	cLoja    := TB_LOJA
	dbSelectArea("SA1")
    dbSeek(xFilial()+cCliente+cLoja)

	@li,00 PSAY SA1->A1_COD + "/"+ SA1->A1_LOJA+ " " + SA1->A1_NOME

	dbSelectArea(cNomArq)


	nValor1:= TB_VALOR1
	nValor2:= TB_VALOR2
	nValor3:= TB_VALOR3
	nValor4:= TB_VALOR4
	nValor5:= TB_VALOR5
	nValor6:= TB_VALOR6

    nValor4 := nValor4 * (-1)
    nValor5 := nValor5 * (-1)
    nValor6 := nValor6 * (-1)

	@li,50 PSAY nValor1  PICTURE cPict 
	@li,70 PSAY nValor2  PICTURE cPict 
	@li,90 PSAY nValor3  PICTURE cPict 

    IF mv_par07 == 2
        nRank := nRank + 1
		@li,111 PSAY nRank	PICTURE "9999"
	EndIF

	If nValor4+nValor5+nValor6!=0
        li := li + 1
		@li,50 PSAY nValor4  PICTURE cPict 
		@li,70 PSAY nValor5  PICTURE cPict 
		@li,90 PSAY nValor6  PICTURE cPict 
		@li, PCol()+12 PSAY "DEV"
	Endif

    nEstV1 := nEstV1 + nValor1
    nEstV2 := nEstV2 + nValor2
    nEstV3 := nEstV3 + nValor3
    nEstV4 := nEstV4 + nValor4
    nEstV5 := nEstV5 + nValor5
    nEstV6 := nEstV6 + nValor6

    li := li + 1

    nAg1 := nAg1 + nValor1
    nAg2 := nAg2 + nValor2
    nAg3 := nAg3 + nValor3
    nAg4 := nAg4 + nValor4
    nAg5 := nAg5 + nValor5
    nAg6 := nAg6 + nValor6

	dbSkip()
End

IF li != 80
	If mv_par07 == 3
        li := li + 1
		@li, 00 PSAY "Total do Estado de " + cEst + "--->"
		@li, 50 PSAY nEstV1		PicTure cPict 
		@li, 70 PSAY nEstV2		PicTure cPict 
		@li, 90 PSAY nEstV3		PicTure cPict 

		If nEstV4+nEstV5+nEstV6!=0
            li := li + 1
			@li, 50 PSAY nEstV4		PicTure cPict 
			@li, 70 PSAY nEstV5		PicTure cPict 
			@li, 90 PSAY nEstV6		PicTure cPict 
			@li, PCol()+12 PSAY "DEV"
		Endif

        li := li + 2
	EndIf
    li := li + 1
	@li, 00 PSAY "T O T A L --->"
	@li, 50 PSAY nAg1		PicTure cPict 
	@li, 70 PSAY nAg2		PicTure cPict 
	@li, 90 PSAY nAg3		PicTure cPict 

	If nAg4+nAg5+nAg6!=0
        li := li + 1
		@li, 50 PSAY nAg4		PicTure cPict 
		@li, 70 PSAY nAg5		PicTure cPict 
		@li, 90 PSAY nAg6		PicTure cPict 
		@li, PCol()+12 PSAY "DEV"
	Endif

	roda(cbcont,cbtxt)
EndIF

dbSelectArea(cNomArq)
dbCloseArea()

cDelArq := cNomArq+".DBF"
fErase(cDelArq)

fErase(cNomArq1+OrdBagExt())

If mv_par07 == 2
    Ferase(cNomarq2+OrdBagExt())
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
Set Filter To
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(1)
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraTrab  ³ Autor ³ Wagner Xavier         ³ Data ³ 10.01.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho para emissao de Estat.de Fatur.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraTrab()                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> FuncTion GeraTrab
Static FuncTion GeraTrab()
nTOTAL     := 0
nVALICM    := 0
nVALIPI    := 0
cTesAnt    := ""
cChave     := ""
nTB_VALOR1 := 0
nTB_VALOR2 := 0
nTB_VALOR3 := 0
nMoeda     := mv_par08

Set SoftSeek On
dbSeek(xFilial()+mv_par03)
Set SoftSeek Off

While !Eof() .And. xFilial()==SF2->F2_FILIAL .And.;
		 SF2->F2_CLIENTE <= mv_par04

	dbSelectArea("SA1")
	dbSetOrder(1)
    dbSeek ( xFilial() + SF2->F2_CLIENTE+SF2->F2_LOJA )
	dbSelectArea("SF2")
	
	IF SF2->F2_EMISSAO < mv_par01 .Or. SF2->F2_EMISSAO > mv_par02 .Or.;
		SA1->A1_EST 	 < mv_par05 .Or. SA1->A1_EST     > mv_par06
		dbSkip()
		Loop
	EndIF
	
	If At(SF2->F2_TIPO,"DB") != 0	
		Dbskip()
		Loop
	Endif
	
	IncRegua()
	
	dbSelectArea("SD2")
	dbSetOrder(3)
    dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
	nTOTAL :=0.00
	nVALICM:=0.00
	nVALIPI:=0.00

    While !Eof() .And. xFilial()==SD2->D2_FILIAL .And.;
			SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE

		dbSelectArea("SF4")
        dbSeek(xFilial()+SD2->D2_TES)
		
		dbSelectArea("SD2")
		If SF4->F4_DUPLIC=="S" .AND. AT(SD2->D2_TES,cTabTes) #0
            nVALICM := nVALICM + SD2->D2_VALICM
            nVALIPI := nVALIPI + SD2->D2_VALIPI
            nTOTAL  := nTOTAL  + SD2->D2_TOTAL
		Endif
		    
		dbSelectArea("SD2")
		dbSkip()

	End

	If nTOTAL > 0.00
		dbSelectArea(cNomArq)
		dbSeek(SF2->F2_CLIENTE+SF2->F2_LOJA)
		If Found()
			RecLock(cNomArq,.F.)
		Else
			RecLock(cNomArq,.T.)
		EndIF
		Replace TB_CLI     With SF2->F2_CLIENTE
		Replace TB_EST     With SA1->A1_EST
		Replace TB_LOJA    With SF2->F2_LOJA
		Replace TB_EMISSAO With SF2->F2_EMISSAO
		
		nTB_VALOR1 := nTOTAL-nVALICM
		nTB_VALOR2 := IIF(SF2->F2_TIPO == "P",0,nTOTAL)
		nTB_VALOR3 := (IIF(SF2->F2_TIPO == "P",0,nTOTAL) );
                    + nVALIPI+SF2->F2_FRETE+SF2->F2_SEGURO;
  						  + SF2->F2_ICMSRET+SF2->F2_FRETAUT

        nTB_VALOR1:= IF(nMoeda == 1,nTB_VALOR1,ROUND(nTB_VALOR1 / RecMoeda(TB_EMISSAO,nMoeda),2))
        nTB_VALOR2:= IF(nMoeda == 1,nTB_VALOR2,ROUND(nTB_VALOR2 / RecMoeda(TB_EMISSAO,nMoeda),2))
        nTB_VALOR3:= IF(nMoeda == 1,nTB_VALOR3,ROUND(nTB_VALOR3 / RecMoeda(TB_EMISSAO,nMoeda),2))

		Replace TB_VALOR1  With TB_VALOR1+ nTB_VALOR1
		Replace TB_VALOR2  With TB_VALOR2+ nTB_VALOR2
		Replace TB_VALOR3  With TB_VALOR3+ nTB_VALOR3

		MsUnlock()
		
	Endif

	dbSelectArea("SF2")
	dbSkip()
End
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraTrab1 ³ Autor ³ Adriano Sacomani      ³ Data ³ 09.08.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho para emissao de Estat.de Fatur.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraTrab1)                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> FuncTion GeraTrab1
Static FuncTion GeraTrab1()
nTOTAL     := 0
nVALICM    := 0
nVALIPI    := 0
cTesAnt    := ""
nTB_VALOR4 := 0
nTB_VALOR5 := 0
nTB_VALOR6 := 0
nMoeda := mv_par08

Set SoftSeek On
dbSeek(xFilial()+mv_par03)
Set SoftSeek Off
While !Eof() .And. xFilial()==F1_FILIAL .And. F1_FORNECE <= mv_par04

	dbSelectArea("SA1")
	dbSetOrder(1)
    dbSeek( xFilial() + SF1->F1_FORNECE )
	dbSelectArea("SF1")
	
	If SF1->F1_DTDIGIT < mv_par01 .Or. SF1->F1_DTDIGIT > mv_par02 .Or.;
		SA1->A1_EST     < mv_par05 .Or. SA1->A1_EST     > mv_par06
		dbSkip()
		Loop
	EndIf
	
	If SF1->F1_TIPO != "D"	
		Dbskip()
		Loop
	Endif
	
	IncRegua()
	
	dbSelectArea("SD1")
	dbSetOrder(1)
    dbSeek(xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE)
	nTOTAL :=0.00
	nVALICM:=0.00
	nVALIPI:=0.00
	cTesAnt:=SD1->D1_TES
	dbSelectArea("SF4")
    dbSeek(xFilial()+SD1->D1_TES)
	dbSelectArea("SD1")

    While !Eof() .and. xFilial()==SD1->D1_FILIAL .And.;
			SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE ==;
			SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE

		If SD1->D1_TIPO != "D"
			dbSkip()
			Loop
		Endif
 	
 		If cTesAnt #SD1->D1_TES
			dbSelectArea("SF4")
            dbSeek(xFilial()+SD1->D1_TES)
			dbSelectArea("SD1")
		Endif		

		If SF4->F4_DUPLIC=="S" .AND. AT(SD1->D1_TES,cTabTes) #0
            nVALICM := nVALICM + SD1->D1_VALICM
            nVALIPI := nVALIPI + SD1->D1_VALIPI
            nTOTAL  := nTOTAL  + SD1->D1_TOTAL
		Endif
				    
		dbSelectArea("SD1")
		dbSkip()
		cTesAnt := SD1->D1_TES

	End

	If nTOTAL > 0.00
		dbSelectArea(cNomArq)
		dbSeek(SF1->F1_FORNECE+SF1->F1_LOJA)
		If Found()
			RecLock(cNomArq,.F.)
		Else
			RecLock(cNomArq,.T.)
		EndIf

		Replace TB_CLI     With SF1->F1_FORNECE
		Replace TB_EST     With SA1->A1_EST
		Replace TB_LOJA	 With SF1->F1_LOJA
		Replace TB_EMISSAO With SF1->F1_EMISSAO

        nTB_VALOR4 := nTOTAL - nVALICM
		nTB_VALOR5 := nTOTAL
        nTB_VALOR6 := nTOTAL + nVALIPI+SF1->F1_FRETE+SF1->F1_DESPESA+SF1->F1_ICMSRET

        nTB_VALOR4:= IF(nMoeda == 1,nTB_VALOR4,ROUND(nTB_VALOR4 / RecMoeda(TB_EMISSAO,nMoeda),2))
        nTB_VALOR5:= IF(nMoeda == 1,nTB_VALOR5,ROUND(nTB_VALOR5 / RecMoeda(TB_EMISSAO,nMoeda),2))
        nTB_VALOR6:= IF(nMoeda == 1,nTB_VALOR6,ROUND(nTB_VALOR6 / RecMoeda(TB_EMISSAO,nMoeda),2))

		Replace TB_VALOR4  With TB_VALOR4+nTB_VALOR4
		Replace TB_VALOR5  With TB_VALOR5+nTB_VALOR5
		Replace TB_VALOR6  With TB_VALOR6+nTB_VALOR6
	EndIf

	dbSelectArea("SF1")
	dbSkip()
End
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Tes       ³ Autor ³ Adriano Sacomani      ³ Data ³ 09.08.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Carrega cTabTtes com Tipos de Entradas e Saida              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR590                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Tes
Static Function Tes()

dbSelectArea("SF4")
dbSeek(xFilial())
While !Eof() .And. SF4->F4_FILIAL==xFilial()

    cTabTes := cTabTes + SF4->F4_CODIGO+"þ"
	dbSkip()

End

Return
