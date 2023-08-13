#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATRCAN()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt()

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatrcan  ³ Autor ³   Diego Araujo      ³ Data ³ 06/09/05³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de canhotos da nota fiscal                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Data                               ³
//³ mv_par02        	// Ate Data                              ³
//³ mv_par03        	// De Transportador                      ³
//³ mv_par04        	// Ate Transportador                     ³
//³ mv_par05        	// De Nota                               ³
//³ mv_par06        	// Ate Nota                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tamanho   := "M"
titulo    := PADC("Relatorio de canhotos",74)
cDesc1    := PADC("Este programa ira Emitir o Relatorio de Canhotos de Nota Fiscal",74)
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATRCAN"
cPerg     := "FATCAN"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATRCAN"
M_PAG     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .F. )               // Pergunta no SX1

cString := "SF2"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1:= "      N.F.    Nome do Cliente                              Cidade                       Transportadora     Emissao"
			   //999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXX-XX XXXXXXXXXXXXXXXXXX 00/00/00
//		  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//        0         1         2         3         4         5         6         7         8         9        10        11        12
cabec2  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DESENVOLVIMENTO DO PROGRAMA          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT SF2.F2_DOC,SA1.A1_NOME,SA1.A1_MUN,SA1.A1_EST,SA4.A4_NREDUZ,SF2.F2_EMISSAO "
cQuery += "FROM " + RetSqlName( "SF2" ) + " SF2," + RetSqlName( "SA1" ) + " SA1," + RetSqlName( "SA4" ) + " SA4 "
cQuery += "WHERE SF2.F2_EMISSAO >= '" + Dtos( mv_par01 ) + "' AND SF2.F2_EMISSAO <= '" + Dtos( mv_par02 ) + "' AND "
cQuery += "SF2.F2_TRANSP >= '" + mv_par03 +  "'AND SF2.F2_TRANSP <= '" + mv_par04 + "' AND "
cQuery += "SF2.F2_DOC >= '" + mv_par05 + "' AND SF2.F2_DOC <= '" + mv_par06 + "' AND "
cQuery += "SA1.A1_COD+SA1.A1_LOJA = SF2.F2_CLIENTE+SF2.F2_LOJA AND SA4.A4_COD = SF2.F2_TRANSP AND SF2.F2_SERIE <> '   ' AND  "
cQuery += "SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' AND "
cQuery += "SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "' AND SA4.D_E_L_E_T_ = ' ' "
cQuery +="ORDER BY SF2.F2_DOC " //"ORDER BY SF2.F2_EMISSAO "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SF2X"
TCSetField( 'SF2X', "F2_EMISSAO", "D" )


//MemoWrit( "Canhoto.SQL", cQuery )   <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DADOS IMPRESSOS NO RELATORIO    					         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2X->( DbGoTop() )
count to nREGTOT while ! SF2X->( EoF() )
SetRegua( nREGTOT )
SF2X->( DBGoTop() )

//SF2X->( DBGoTop() )

nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho

Do While ! SF2X->( Eof() )

	@ nLin,006 pSay  SF2X->F2_DOC
	@ nLin,014 pSay  SF2X->A1_NOME
	@ nLin,059 pSay  Alltrim( SF2X->A1_MUN ) + "-" + SF2X->A1_EST
	@ nLin,089 pSay  AllTrim(SF2X->A4_NREDUZ)
	@ nLin,108 pSay  AllTrim( Trans( SF2X->F2_EMISSAO, "99/99/99"))

	nLin += 10 //8 alteracao feita em 25/05/2009 chamado 001138
	SF2X->( dbskip() )
    IncRegua()
	
	if nLin > 60
		nLin:=Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
	endIf

ENDDO

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif

SF2X->( DbCloseArea() )
MS_FLUSH()


Return Nil
