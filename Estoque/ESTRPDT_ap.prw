#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTRPDT()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³  ESTRPDT  ³ Autor ³   Mauricio Barros     ³ Data ³20/06/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de estruturas dos produtos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Cliente Rava Embalagens                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Do Produto                           ³
//³ mv_par02             // Ate Produto                          ³
//³ mv_par03             // Da Familia                           ³
//³ mv_par04             // Ate Familia                          ³
//³ mv_par05             // Do Tipo                              ³
//³ mv_par06             // Ate Tipo                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tamanho   := "G"
titulo    := "RELACAO DE ESTRUTURA DOS PRODUTOS"
cDesc1    := "Este programa ira emitir relacao de estruturas"
cDesc2    := "dos produtos."
cDesc3    := ""
cNatureza := ""
aReturn   := { "Estoque", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "ESTRPDT"
cPerg     := "ESTRPD"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "ESTRPDT"
M_PAG     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Validperg()
Pergunte( cPerg, .F. )               // Pergunta no SX1

cString := "SB1"

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

Cabec1 := "            /-------- D I M E N S O E S ---------\                                          /-----EMBALAGEM-----\   /------------------------------------- S A C O   C A P A ------------------------------------\"
Cabec2 := "CAPACIDADE             INTERNO             EXTERNO  TIPO  PRODUTO     COR         PESO(Kg)  QTD.1   QTD.2   QTD.3   PRODUTO 1            DIMENSOES  PRODUTO 2            DIMENSOES  PRODUTO 3            DIMENSOES"
//         XXXXXXXXXX  999 x 999 x 9,9999  999 x 999 x 9,9999  XXX   9999999999  XXXXXXXXXX   999,999   9999    9999    9999   9999999999  999 x 999 x 9,9999  9999999999  999 x 999 x 9,9999  9999999999  999 x 999 x 9,9999
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567012345678901234567890123456789012345678901234567
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16      17        18        19        20        21
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT SB1.B1_SETOR,SB1.B1_COD,SB5.B5_COMPR,SB5.B5_LARG,SB5.B5_ESPESS,SB5.B5_COMPR2,SB5.B5_LARG2,SB5.B5_ESPESS2,"
cQuery += "SB1.B1_PESO,SB5.B5_QE1,SB5.B5_QTDEN,SB5.B5_TIPO,SB5.B5_CAPACID,SB5.B5_QTDFIM,SB5.B5_COR, SB5.B5_DESCOM "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1," + RetSqlName( "SB5" ) + " SB5 "
cQuery += "WHERE SB5.B5_COD = SB1.B1_COD AND SB1.B1_TIPO IN ('PA','ME') AND SB1.B1_ATIVO = 'S' AND SB1.B1_SETOR >= '" + mv_par01 + "' AND "
cQuery += "SB1.B1_SETOR <= '" + mv_par02 + "' AND SUBSTRING( SB1.B1_COD, 2, 1 ) >= '" + mv_par03 + "' AND "
cQuery += "SUBSTRING( SB1.B1_COD, 2, 1 ) <= '" + mv_par04 + "' AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND SB5.D_E_L_E_T_=' ' "
cQuery += "ORDER BY SB1.B1_SETOR,SUBSTRING( SB1.B1_COD, 2, 1 ),1000-(SB5.B5_COMPR*SB5.B5_LARG*SB5.B5_ESPESS),SB1.B1_COD "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SB1X"

SB1X->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1
nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1  // Impressao do cabecalho
Do While ! SB1X->( Eof() )
	 cFAM := SB1X->B1_SETOR
	 SX5->( DbSeek( xFilial( "SX5" ) + "72" + padr( SB1X->B1_SETOR, 6 ) ) )
	 nLIN++
   @ nLIN,001 PSAY SB1X->B1_SETOR + " - " + SX5->X5_DESCRI
	 nLIN += 2
	 Do While ! SB1X->( Eof() ) .and. SB1X->B1_SETOR == cFAM
  		SG1->( DbSeek( xFilial( "SG1" ) + SB1X->B1_COD, .T. ) )  // Pesquisa estrutura do PA
  		If SG1->G1_COD == SB1X->B1_COD
				 SX5->( dbSeek( xFilial( "SX5" ) + "Z0" + padr( Left( SB1X->B5_CAPACID, 1 ), 6 ) ) )
				 @ nLIN,001 PSAY Left( SX5->X5_DESCRI, 10 )
				 @ nLIN,012 PSAY Trans( SB1X->B5_LARG, "999" ) + " x " + Trans( SB1X->B5_COMPR + SB1X->B5_DESCOM, "999" ) + " x " + Trans( SB1X->B5_ESPESS, "@E 9.9999" )
				 If SB1X->B5_LARG2 + SB1X->B5_COMPR2 + SB1X->B5_ESPESS2 > 0
				    @ nLIN,032 PSAY Trans( SB1X->B5_LARG2, "999" ) + " x " + Trans( SB1X->B5_COMPR2, "999" ) + " x " + Trans( SB1X->B5_ESPESS2, "@E 9.9999" )
				 EndIf
				 @ nLIN,052 PSAY If( SB1X->B5_TIPO == "1", "LEV", If( SB1X->B5_TIPO == "2", "MED", If( SB1X->B5_TIPO == "3", "REF", If( SB1X->B5_TIPO == "4", "SRF", "   " ) ) ) )
				 @ nLIN,058 PSAY Left( SB1X->B1_COD, 10 )
				 SX5->( dbSeek( xFilial( "SX5" ) + "70" + padr( SubStr( SB1X->B1_COD, 3, 1 ), 6 ) ) )
				 @ nLIN,070 PSAY Left( SX5->X5_DESCRI, 10 )
				 @ nLIN,083 PSAY SB1X->B1_PESO Picture "@E 999.999"
				 @ nLIN,093 PSAY SB1X->B5_QE1 Picture "9999"
				 @ nLIN,101 PSAY SB1X->B5_QTDEN Picture "99999"
				 nREG  := SG1->( Recno() )
				 nCONT := 0
  		   Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1X->B1_COD
  		      If Left( SG1->G1_COMP, 2 ) == 'ME'
							 ncONT++
						EndIf
  		      SG1->( DbSkip() )
  		   EndDo
				 If nCONT > 2 .and. SB1X->B5_QTDFIM > 0
				    @ nLIN,109 PSAY SB1X->B5_QTDFIM Picture "99999"
				 EndIf
				 SG1->( DbGoto( nREG ) )
				 nCOL := 116
  		   Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1X->B1_COD
  		      If Left( SG1->G1_COMP, 2 ) == 'ME'
							 If SB5->( DbSeek( xFilial( "SB5" ) + SG1->G1_COMP ) )
						 		  @ nLIN,nCOL PSAY Left( SG1->G1_COMP, 10 )
							    @ nLIN,nCOL + 12 PSAY Trans( SB5->B5_LARG, "999" ) + " x " + Trans( SB5->B5_COMPR + SB1X->B5_DESCOM, "999" ) + " x " + Trans( SB5->B5_ESPESS, "@E 9.9999" )
									nCOL += 32
							 EndIf
						EndIf
  		      SG1->( DbSkip() )
  		   EndDo
				 nLIN++
				 if nLIN > 62
				    nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1  // Impressao do cabecalho
				 EndIf
  		Endif
  		SB1X->( DbSkip() )
  		IncProc()
	 EndDo
Enddo
SB1X->( DbCloseArea() )
Roda( 0, "", TAMANHO )
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif
Return NIL


***************

Static Function ValidPerg()

***************
PutSx1( cPerg, '01', 'Da Familia         ?', '', '', 'mv_ch1', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Ate Familia        ?', '', '', 'mv_ch2', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '03', 'Da Capacidade      ?', '', '', 'mv_ch3', 'C', 1, 0, 0, 'G', '', ''   , '', '', 'mv_par03', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '04', 'Ate Capacidade     ?', '', '', 'mv_ch4', 'C', 1, 0, 0, 'G', '', ''   , '', '', 'mv_par04', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )                
/*_sAlias := Alias()
dbSelectArea( "SX1" )
dbSetOrder( 1 )
cPerg := PADR( cPerg, 6 )
aRegs := {}
AADD(aRegs,{cPerg,"01","Da Familia         ?","","","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","72","S","",""})
AADD(aRegs,{cPerg,"02","Ate Familia        ?","","","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","72","S","",""})
AADD(aRegs,{cPerg,"03","Da Capacidade      ?","","","mv_ch3","C",1,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","Z0","S","",""})
AADD(aRegs,{cPerg,"04","Ate Capacidade     ?","","","mv_ch4","C",1,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","Z0","S","",""})
For i:=1 to Len( aRegs )
    If ! dbSeek( cPerg + aRegs[ i, 2 ] )
   		 RecLock( "SX1", .T. )
		   For j := 1 to FCount()
			     FieldPut( j, aRegs[ i, j ] )
		   Next
		   MsUnlock()
       dbCommit()
	  Endif
Next
dbSelectArea( _sAlias )*/
Return NIL