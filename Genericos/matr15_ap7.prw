#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function matr15()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,TITULO,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CSTRING,CPERG,WNREL,CNUMERO,NITEM")
SetPrvt("CFORNECE,CLOJA,CDESCRI,CABEC1,CABEC2,CABEC3")
SetPrvt("TAMANHO,CBCONT,CCONTATO,DEMISSAO,LIMITE,LI")
SetPrvt("M_PAG,NPAG,CENDERE,CCIDEST,CFAX,CFILENT")
SetPrvt("LC8FILENT,NREGISTRO,CDESC,NLINREF,MV_PAR06,NBEGIN")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR150  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao das Cotacoes                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Rdmake   ³ Autor ³ Luiz Carlos Vieira          ³ Data ³ Fri  05/12/97 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesc1   := "Emissao das cotacoes de compras"
cDesc2   := ""
cDesc3   := " "

titulo   := "Relacao de Cotacoes"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog := "MATR150"
nLastKey := 0
cString  := "SC8"

cPerg    := "MTR150"
wnrel    := "MATR150"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01              Do Numero                              ³
//³ mv_par02              Ate o Numero                           ³
//³ mv_par03              Do Fornecedor                          ³
//³ mv_par04              Ate o Fornecedor                       ³
//³ mv_par05              Ate a data de validade                 ³
//³ mv_par06              Campo Descricao do Produto             ³
//³ mv_par07              Endrre‡o Fiscal                        ³
//³ mv_par08              Cidade - Estado                        ³
//³ mv_par09              Fax                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("MTR150",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
   Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

#IFDEF WINDOWS
    RptStatus({|| R150Imp()},Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     RptStatus({|| Execute(R150Imp)},Titulo)
    Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     Function R150Imp
Static Function R150Imp()
#ENDIF	

cNumero  := ""
nItem    := 0
cFornece := ""
cLoja    := ""
cDescri  := ""
cabec1   := ""
cabec2   := ""
cabec3   := ""
tamanho  := " "
cbCont   := 0
cContato := ""
dEmissao := CTOD("")

limite   := 132
li       := 80
m_pag    := 1
nPag     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY AvalImp(Limite)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa Numero da Cotacao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC8")
dbSetOrder(1)
dbSeek(xFilial()+mv_par01,.T.)

SetRegua(RecCount())

While xFilial() == SC8->C8_FILIAL .And. SC8->C8_NUM >= mv_par01 .And. SC8->C8_NUM <= mv_par02 .And. !Eof()
        
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Fornecedor                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IF SC8->C8_FORNECE < mv_par03 .OR. SC8->C8_FORNECE > mv_par04
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data de Validade ou se ja tem pedido feito          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IF SC8->C8_VALIDA > mv_par05 .OR. !Empty(SC8->C8_NUMPED)
		dbSkip()
		Loop
	Endif

	cContato := SC8->C8_CONTATO
	dEmissao := SC8->C8_EMISSAO

	IF li > 58
        nPag := nPag + 1
        @00,00 PSAY "PREZADOS SENHORES."
        @00,70 PSAY "COTACAO N. " + SC8->C8_NUM + " Vencimento " + DTOC(SC8->C8_VALIDA) +Space(13)+"Pagina: " + STRZERO(nPag,4)
		dbSelectArea("SA2")
		dbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA)
        @1 ,  0 PSAY SubStr(SA2->A2_NOME,1,40)+" ("+SA2->A2_COD+" - "+SA2->A2_LOJA+")"
		@1 , 58 PSAY "|"
        @2 ,  0 PSAY SA2->A2_END
		@2 , 58 PSAY "| Por favor queira referenciar este numero para quaisquer troca de"
        @3 ,  0 PSAY SA2->A2_BAIRRO
		@3 , 58 PSAY "| informacoes referentes a esta cotacao."
		@4 ,  0 PSAY "Fone: "+SA2->A2_TEL
		@4 , 58 PSAY "|"+Space(28)+"Atenciosamente."
		@5 ,  0 PSAY "Fax : "+SA2->A2_FAX
		@5 , 58 PSAY "| "+ SM0->M0_NOMECOM

		cEndere	:= Iif(Empty(MV_PAR07), Iif(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT), MV_PAR07)
		cCidEst	:= Iif(Empty(MV_PAR08), Iif(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), SM0->M0_CIDCOB + " " + SM0->M0_ESTCOB,  SM0->M0_CIDENT + " " + SM0->M0_ESTENT),MV_PAR08)
		cFax		:= Iif(Empty(MV_PAR09), SM0->M0_FAX, MV_PAR09)

		@6 , 58 PSAY "| "+ cEndere
		@7 ,  0 PSAY "Solicitamos de V Sas. cotacao de precos para os produtos"
		@7 , 58 PSAY "| "+ cCidEst
		@8 ,  0 PSAY "discriminados conforme os padroes abaixo estabelecidos:"
		@8 , 58 PSAY "| Fax : " + cFax
		@9 , 58 PSAY "|"
		@10,  0 PSAY Replicate("-",limite)
		@11,  0 PSAY "ITM N/Vosso Codigo Descricao da Mercadoria        Quantidade UN Valor Unitario      Valor Total IPI  Valor do IPI Pz e Dt Prev Entrg"
		@12,  0 PSAY Replicate("-", 2)
		@12,  3 PSAY Replicate("-",15)
		@12, 19 PSAY Replicate("-",30)
		@12, 50 PSAY Replicate("-",10)
		@12, 61 PSAY Replicate("-", 2)
		@12, 64 PSAY Replicate("-",14)
		@12, 79 PSAY Replicate("-",16)
		@12, 96 PSAY Replicate("-", 3)
		@12,100 PSAY Replicate("-",13)
		@12,114 PSAY Replicate("-",18)
        li := 12
		dbSelectArea("SC8")
        cNumero := SC8->C8_NUM
        cFornece:= SC8->C8_FORNECE
        cLoja   := SC8->C8_LOJA
	Endif
	
	nItem := 0
    While !Eof() .And. SC8->C8_NUM == cNumero .And. cFornece == SC8->C8_FORNECE .And. SC8->C8_LOJA == cLoja
		IF li > 58
            li   := li   + 2
            nPag := nPag + 1
			@ li,00 PSAY Replicate("-",limite-Len(" Continua ..."))+" Continua ..."
			@ 00,00 PSAY "Continuacao ..."+Replicate("-",53)
			@ 00,70 PSAY "COTACAO N. " + SC8->C8_NUM + " Vencimento " + DTOC(SC8->C8_VALIDA) +Space(13)+"Pagina: " + STRZERO(nPag,4) 
			li := 1
		Endif
		
		IncRegua()			
		
        li := li + 1
        nItem := nItem + 1
		@li,  0 PSAY StrZero(nItem,2)
        @li,  3 PSAY SC8->C8_PRODUTO
		ImpDescr()
		cFilEnt := SC8->C8_FILENT
		dbSkip()
	End

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lC8FilEnt := .F.
	If SC8->(Eof()) .Or. cFilEnt != SC8->C8_FILENT
		dbSkip(-1)        // Para ter Certeza que nao e Eof() ou trocou a filial
		lC8FilEnt := .T.  // de Entrega 
	End

	dbSelectArea("SM0")
	dbSetOrder(1)   && forca o indice na ordem certa
	nRegistro := Recno()
	dbSeek(SUBS(cNumEmp,1,2)+SC8->C8_FILENT)

	If lC8FilEnt
		SC8->(dbSkip())
	End

	If li > 50
        li    := li + 2
        nPag  := nPag + 1
		@ li,00 PSAY Replicate("-",limite-Len(" Continua ..."))+" Continua ..."
		@ 00,00 PSAY "Continuacao ..."+Replicate("-",53)
		@ 00,70 PSAY "COTACAO N. " + SC8->C8_NUM + " Vencimento " + DTOC(SC8->C8_VALIDA) +Space(13)+"Pagina: " + STRZERO(nPag,4) 
		li := 1
	Endif
    li := 50
	@li,  0 PSAY Replicate("-",limite)
    li := li + 1
	@li,  0 PSAY "Local de Entrega:"
	@li, 47 PSAY "|  Sub Total"
	@li, 97 PSAY "| Condicao de Pagamento"
    li := li + 1
	@li,  0 PSAY IIf( Empty(SM0->M0_ENDENT), " O mesmo ", SM0->M0_ENDENT )
	@li, 47 PSAY "|  Descontos "
	@li, 97 PSAY "|"
    dbGoTo(nRegistro)
    dbSelectArea("SC8")
	
    li := li + 1
	@li,  0 PSAY "Local de Pagamento:"
	@li, 47 PSAY "|  Total do IPI"
	@li, 97 PSAY "|"
	
    li := li + 1
	@li,  0 PSAY Iif(Empty(SM0->M0_ENDCOB),Iif(Empty(SM0->M0_ENDENT),"O mesmo",SM0->M0_ENDENT),SM0->M0_ENDCOB)
	@li, 47 PSAY "|  Frete"
	@li, 97 PSAY "| Condicao de Reajuste"
	
    li := li + 1
    @li,  0 PSAY "Contato no Fornecedor"
	@li, 47 PSAY "|"+Replicate("-",23)
	@li, 97 PSAY "|"
	
    li := li + 1
    @li,  0 PSAY cContato
	@li, 47 PSAY "|  TOTAL DO PEDIDO"  + Replicate(".",11)
	@li, 97 PSAY "|"

    li := li + 1
    @li,  0 PSAY Replicate("-",limite)

    li := li + 1
    @li,  0 PSAY "Alcada 1"
	@li, 28 PSAY "| Alcada 2"
	@li,111 PSAY "Emitido em :" 
	@li,124 PSAY dEmissao

    li := li + 1
    @li, 0  PSAY Replicate("-",limite)

	dbSelectArea("SC8")
    li   := 80
	nPag := 0
End

dbSelectArea("SC8")
Set Filter To
dbSetOrder(1)

dbSelectArea("SA5")
dbSetOrder(1)

Set device to Screen
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer To
    dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpValores³ Autor ³ Jose Lucas            ³ Data ³ 19.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir Valores da Cotacao.	  									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpValores(Void) 		                        				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                    							     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR150                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function ImpValores
Static Function ImpValores()

dbSelectArea("SB1")
dbSeek(xFilial()+SC8->C8_PRODUTO)

@li, 50 PSAY  SC8->C8_QUANT Picture "9999999.99"
@li, 61 PSAY  SB1->B1_UM
@li,124 PSAY  SC8->C8_DATPRF 

dbSelectArea("SA5")
dbSetOrder(2)
@li,119 PSAY  "dias"
li := li + 1
If dbSeek(xFilial()+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA)
	@li,3 PSAY SA5->A5_CODPRF
Endif
dbSelectArea("SC8")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDescr ³ Autor ³ Jose Lucas            ³ Data ³ 19.07.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir descricao do Produto.	  								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)  			                      				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR150                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function ImpDescr
Static Function ImpDescr()
cDesc   := " "
cDescri := " "
nLinRef := 1

If Empty(mv_par06) 
	mv_par06 := "B1_DESC"
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC8->C8_PRODUTO)
        cDescri := SB5->B5_CEME
	EndIf
ElseIf AllTrim(mv_par06) == "A5_NOMPROD"
	dbSelectArea("SA5")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO)
        cDescri := SA5->A5_NOMPROD
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao do produto do arquivo de Cotacoes.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "C1_DESCRI"
	dbSelectArea("SC1")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC8->C8_NUMSC+SC8->C8_ITEMSC)
    cDescri := SC1->C1_DESCRI
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao do Produto SB1.		         		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cDescri)
	dbSelectArea("SB1")
	dbSeek(xFilial()+SC8->C8_PRODUTO)
	cDescri := SB1->B1_DESC
EndIf

dbSelectArea("SC8")
nBegin := 0
@ li,019 PSAY SubStr(cDescri,1,30)
ImpValores()
For nBegin := 31 To Len(Trim(cDescri)) Step 30
    nLinRef := nLinRef + 1
    li := li + 1
	If nLinRef == 2 
        li := li - 1
	EndIf
	cDesc := Substr(cDescri,nBegin,30)
	@ li,019 PSAY cDesc
Next nBegin
Return
