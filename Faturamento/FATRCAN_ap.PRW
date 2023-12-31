#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATRCAN()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt()

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  �  Fatrcan  � Autor �   Diego Araujo      � Data � 06/09/05낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Relatorio de canhotos da nota fiscal                       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico para Rava                                       낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// De Data                               �
//� mv_par02        	// Ate Data                              �
//� mv_par03        	// De Transportador                      �
//� mv_par04        	// Ate Transportador                     �
//� mv_par05        	// De Nota                               �
//� mv_par06        	// Ate Nota                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Pergunte( cPerg, .F. )               // Pergunta no SX1

cString := "SF2"


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica Posicao do Formulario na Impressora                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Inicio do Processamento do Relatorio                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Inicializa  de variaveis                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
cabec1:= "      N.F.    Nome do Cliente                              Cidade                       Transportadora     Emissao"
			   //999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXX-XX XXXXXXXXXXXXXXXXXX 00/00/00
//		  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//        0         1         2         3         4         5         6         7         8         9        10        11        12
cabec2  := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� DESENVOLVIMENTO DO PROGRAMA          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� DADOS IMPRESSOS NO RELATORIO    					         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
