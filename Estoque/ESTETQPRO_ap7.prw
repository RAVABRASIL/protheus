#include "rwmake.ch"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

USER FUNCTION ESTETQ()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SETPRVT("CPROD,NCONT,NLIN")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Breno Pimentel Lucena                    ³ Data ³ 12/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Impressao de Etiquetas da Producao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Estoque / Custos                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

cALIASANT := alias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Parametros Ambientais                                 ³
//³ MV_PAR01 = TIPO DA ETIQUETA                                  ³
//³ MV_PAR02 = NUMERO DA ORDEM DE PRODUCAO                       ³
//³ MV_PAR03 = CODIGO DO PRODUTO                                 ³
//³ MV_PAR04 = QUANTIDADE DE ETIQUETAS A SEREM IMPRESSAS         ³
//³ MV_PAR05 = NUMERO DO OPERADOR                                ³
//³ MV_PAR06 = NUMERO DA MAQUINA                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cDESC1   := "Impressao de Etiquetas para o Controle de Producao"
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "Financeiro", 2, 2, 1, "", 1 }
cARQUIVO := "SC2"
aORD     := {}
cNOMREL  := "ESTETQ"
cTITULO  := "Impressao de Etiquetas"
nLASTKEY := 0
cTAMANHO := "M"
M_PAG    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( 'ESTETQ', .F. )

cNOMREL := setprint( cARQUIVO, cNOMREL, "ESTETQ", @cTITULO, cDESC1, cDESC2, cDESC3, .F. )

If nLastKey == 27
   Return
Endif

If MV_PAR01 == 1
   SC2->( DBSETORDER( 1 ) )
   SC2->( DBSEEK( XFILIAL( 'SC2' ) + MV_PAR02, .T. ) )
   cPROD := AllTrim( SC2->C2_PRODUTO )
Else
   cPROD := MV_PAR03
EndIf

SB1->( DBSETORDER( 1 ) )
SB1->( DBSEEK( XFILIAL( 'SB1' ) + cPROD, .T. ) )
SB5->( DBSETORDER( 1 ) )
SB5->( DBSEEK( XFILIAL( 'SB5' ) + cPROD, .T. ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do Relatorio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLINHA1 := iif(alltrim(cProd) != "GUB290", Padr( "RAVA EMBALAGENS - Ind. e Com.", 50 ), "GUB290" )
cLINHA2 := Padr( "-Manter fora do alcance de criancas", 50 )
cLINHA3 := Padr( "-Uso exclusivo para lixo normal", 50 )
cLINHA4 := Padr( "-Nao adequado para objetos perfurantes", 50 )
cLINHA5 := Padr( SB1->B1_DESC, 50 )
cLINHA6 := Padr( "Contem: " + AllTrim( Trans( SB5->B5_QTDEMB, "9999") )+''+AllTrim(SB1->B1_UM) + " Cod: " + SubStr( AllTrim( cPROD ), 1, 7 ) + ;
	" Maq: " + Trans( MV_PAR06, "99" ) +"/"+ Trans( MV_PAR05, "999" ) + " Emb.:???" +" LT:"+substr(DTOC( dDATABASE ),4,8 ), 50 )
//cLINHA7 := Padr( "Fab: " + DTOC( dDATABASE ) + "  SAC: 08007271915", 50 )
	cLINHA7 := Padr( "Fab: " + DTOC( dDATABASE ) + "  Val.: Indeterminada/uso unico", 50 )
If substr(SB1->B1_COD, 1, 2 ) == "CT"
 	 cLINHA3 := Padr( "-Uso exclusivo para acondicionamento de cadáveres", 50 )
elseIf substr(SB1->B1_COD, 1, 1 ) == "C"
 	 cLINHA3 := Padr( "-Uso exclusivo para lixo hospitalar", 50 )
EndIf

@ 000,000 TO 275,335 DIALOG oDLG1 TITLE "Layout da etiqueta"
@ 010,010 GET cLINHA1 SIZE 150,10 OBJECT oLINHA1
@ 025,010 GET cLINHA2 SIZE 150,10 OBJECT oLINHA2
@ 040,010 GET cLINHA3 SIZE 150,10 OBJECT oLINHA3
@ 055,010 GET cLINHA4 SIZE 150,10 OBJECT oLINHA4
@ 070,010 GET cLINHA5 SIZE 150,10 OBJECT oLINHA5
@ 085,010 GET cLINHA6 SIZE 150,10 OBJECT oLINHA6
@ 100,010 GET cLINHA7 SIZE 150,10 OBJECT oLINHA7
@ 120,050 BMPBUTTON TYPE 1 ACTION OkProc()   // Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 120,090 BMPBUTTON TYPE 2 ACTION Close( oDLG1 )
ACTIVATE DIALOG oDlg1 CENTER
Return NIL


***************

Static Function OkProc()

***************

Close( oDLG1 )
Processa( {|| Etiqueta() } )   // Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Processa( {|| Execute(Cap_CCP) } )
Return NIL



***************

Static Function Etiqueta()

***************

setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif

nMIDIA := aRETURN[ 5 ]

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF

nLIN  := 0
nCONT := 1

*@nLIN  ,000 psay CHR( 27 ) + CHR( 15 )
Do While nCONT <= ( MV_PAR04 / 4 )
  	@nLIN  ,000 PSAY cLINHA1
   	@nLIN  ,057 PSAY cLINHA1
   	@nLIN  ,113 PSAY cLINHA1
   	@nLIN  ,169 PSAY cLINHA1

   	@++nLIN,000 PSAY cLINHA2
   	@nLIN  ,057 PSAY cLINHA2
   	@nLIN  ,113 PSAY cLINHA2
   	@nLIN  ,169 PSAY cLINHA2

   	@++nLIN,000 PSAY cLINHA3
   	@nLIN  ,057 PSAY cLINHA3
   	@nLIN  ,113 PSAY cLINHA3
		@nLIN  ,169 PSAY cLINHA3

   	@++nLIN,000 PSAY cLINHA4
   	@nLIN  ,057 PSAY cLINHA4
   	@nLIN  ,113 PSAY cLINHA4
   	@nLIN  ,169 PSAY cLINHA4

   	@++nLIN,000 PSAY cLINHA5
   	@nLIN  ,057 PSAY cLINHA5
   	@nLIN  ,113 PSAY cLINHA5
   	@nLIN  ,169 PSAY cLINHA5

   	@++nLIN,000 PSAY cLINHA6
   	@nLIN  ,057 PSAY cLINHA6
   	@nLIN  ,113 PSAY cLINHA6
   	@nLIN  ,169 PSAY cLINHA6

   	@++nLIN,000 PSAY cLINHA7
   	@nLIN  ,057 PSAY cLINHA7
   	@nLIN  ,113 PSAY cLINHA7
   	@nLIN  ,169 PSAY cLINHA7

   	nLIN := nLIN + 3
   ++nCONT
EndDo
*@nLIN  ,000 psay CHR( 27 ) + CHR( 18 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Final da Impressao do Relatorio                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[ 5 ] == 1
   dbCommitAll()
   ourspool( cNOMREL )
Endif

Return NIL


