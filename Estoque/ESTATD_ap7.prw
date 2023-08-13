#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTATD()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CFILTRO,CCHAVE,CINDSB5,NPOSSB5,API,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Adenildo Macedo de Almeida               ³ Data ³ 02/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Alterar Densidade SOMENTE dos PA's   (SB1,SB5,SG1)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Informatica                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*********** ALTERACAO DAS DENSIDADES DOS PA'S C/ BASE NA COR ***********
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

tamanho   := "P"
cDesc1    := PADC( "Este programa ira alterar a densidade dos produtos selecionados", 74 )
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "ESTATD"
cPerg     := "ESTATD"
nLastKey  := 0
wnrel     := "ESTATD"

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString := "SB1"
titulo  := Padc( "Alteracoes na densidade dos produtos", 40 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPERG, @titulo, cDesc1, cDesc2, cDesc3, .T., "",, Tamanho )
If nLastKey == 27
   Return
Endif

SetDefault( aReturn, cString )
If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Ata_Den
dbselectarea( "SB5" )
SB5->( dbsetorder( 1 ) )
dbselectarea( "SB1" )
SB1->( dbsetorder( 1 ) )
dbselectarea( "SG1" )
SG1->( dbsetorder( 1 ) )

// SE FOSSE UTILIZAR FILTRO...
/*
If mv_par01 == 1                                 //AZUL
   cFILTRO  := "SubStr(B5_COD,3,1) == 'A'"
ElseIf  mv_par01 == 2                            //BRANCO
   cFILTRO  := "SubStr(B5_COD,3,1) == 'B'"
ElseIf  mv_par01 == 3                            //PRETO
   cFILTRO  := "SubStr(B5_COD,3,1) == 'C'"
ElseIf  mv_par01 == 4                            //VERMELHO
   cFILTRO  := "SubStr(B5_COD,3,1) == 'D'"
ElseIf  mv_par01 == 5                            //INCOLOR
   cFILTRO  := "SubStr(B5_COD,3,1) == 'Z'"
Endif

cCHAVE   := "xFilial('SB5')+B5_COD"
cIndSB5 := CriaTrab(NIL, .F.)
IndRegua("SB5", cIndSB5, cCHAVE,, cFILTRO, "Selecionando Titulos...")
*/

aPI  := {}
//Processando Complemento de Produtos
ProcRegua( SB5->( LastRec() ) )
SB5->(DBGoTop())
m_PAG  := 1     //Variavel que acumula o numero de pagina
cabec1 := "-PRODUTO-   DENS.ANT.   DENS.ATUAL    PESO ANTERIOR       PESO ATUAL   "
//         0              15           29       37               54
//         999999999      9.999         9.999   999,999.999999   999,999.999999
cabec2 := ""
nLin   := Cabec( titulo, cabec1, cabec2, nomeprog, "P", 18 ) //Impressao do cabecalho
While ! SB5->( EOF() )
   If SB1->( dbSeek( xFilial( "SB1" ) + SB5->B5_COD ) ) .and. ( ( MV_PAR03 == 2 .and. SB1->B1_TIPCAR == "PA    " .and. ;
     SubStr( SB5->B5_COD, 3, 1 ) == MV_PAR01 .and. ;
     ( ( MV_PAR02 == 1 .and. Left( SB5->B5_COD, 1 ) <> "C" .and. SubStr( SB5->B5_COD, 4, 1 ) <> "R" ) .or. ;
			 ( MV_PAR02 == 2 .and. Left( SB5->B5_COD, 1 ) == "C" .and. SubStr( SB5->B5_COD, 4, 1 ) <> "R" ) .or. ;
		   ( MV_PAR02 == 3 .and. SubStr( SB5->B5_COD, 4, 1 ) == "R" ) ) ) .or.;
     ( MV_PAR03 == 1 .and. Empty( MV_PAR01 ) .and. SB1->B1_TIPCAR == "BD    " ) .or. ;
		 ( MV_PAR03 == 2 .and. Empty( MV_PAR01 ) .and. SB1->B1_TIPCAR == "AD    " ) )
      If Subs( SB1->B1_COD, 4, 1 ) == "R"
         _cCodSec := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 4 ) + "6" + Subs( SB1->B1_COD, 6, 2 )
      Else
         _cCodSec := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 3 ) + "6" + Subs( SB1->B1_COD, 5, 2 )
      EndIf

      nPosSB1 := SB1->( Recno() )

      If RecLock( "SB5", .F. )
	 	   If SB5->B5_DENSIDA <> mv_par04
            @ ++nLIN,00 Psay Alltrim( SB5->B5_COD )
            @ nLIN,15 Psay SB5->B5_DENSIDA Picture "@E 9.999"
            @ nLIN,29 Psay mv_par04 Picture "@E 9.999"
         EndIf
         SB5->B5_DENSIDA := mv_par04
         SB5->B5_METRBOB := 1000 / ( SB5->B5_DENSIDA * SB5->B5_LARG * SB5->B5_ESPESS )
         SB5->( MsUnlock() )
         SB5->( DbCommit() )

         //Processando Cadastro de Produtos
         If RecLock( "SB1", .F. )
            nCOMPR := If( Left( SB1->B1_COD, 1 ) == "C" .and. SubStr( SB1->B1_COD, 2, 1 ) $ "DEGIK", SB5->B5_COMPR + 1, SB5->B5_COMPR )
            _nDens := ( SB5->B5_DENSIDA * SB5->B5_LARG * nCOMPR * SB5->B5_ESPESS / 1000 ) * SB5->B5_QE2
            _nFtCo := 1 / ( ( SB5->B5_DENSIDA * SB5->B5_LARG * nCOMPR * SB5->B5_ESPESS / 1000 ) * SB5->B5_QE2 )
            @ nLIN,37 Psay SB1->B1_PESO Picture "@E 999,999.999999"
            @ nLIN,54 Psay _nDens Picture "@E 999,999.999999"
            SB1->B1_PESO := _nDens
            SB1->B1_CONV := _nFtCo
            If Empty( SB1->B1_PESOR )
               SB1->B1_PESOR := _nDens
            EndIf
            SB1->( MsUnlock() )

            //Processando Cadastro de Estruturas dos Produtos
            SG1->( DbSetOrder( 1 ) )
            SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )   // Pesquisa estrutura do PA
            nPosSB5 := SB5->( Recno() )    // Guardar a posicao no SB5
            Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1->B1_COD
               If Subs( SG1->G1_COMP, 1, 2 ) == 'PI' //.and. Empty( Ascan( aPI, SG1->G1_COMP ) )  // Se o componente for PI e ainda nao processado
                  If RecLock( "SG1", .F. )
                     Aadd( aPI, SG1->G1_COMP )
                     SG1->G1_QUANT := SB1->B1_PESO  // Altera peso do PA na estrutura
                     SG1->( MsUnlock() )
                     If SB5->( dbSeek( xFilial( "SB5" ) + SG1->G1_COMP, .T. ) )   // Pesquisa estrutura do PI
                        If RecLock( "SB5", .F. )
				 					If SB5->B5_DENSIDA <> mv_par04
										@ ++nLIN,00 Psay Alltrim( SG1->G1_COMP )
										@ nLIN,15 Psay SB5->B5_DENSIDA Picture "@E 9.999"
	    		 						@ nLIN,29 Psay mv_par04 Picture "@E 9.999"
									EndIf
                           SB5->B5_DENSIDA := mv_par04
                           SB5->B5_METRBOB := 1000 / ( SB5->B5_DENSIDA * SB5->B5_LARGFIL * SB5->B5_ESPESS )
                           SB5->( MsUnlock() )
                        Endif
                     Endif
                  Else
                     Aviso("M E N S A G E M","Codigo -> "+SG1->G1_COD+" - Registro Bloqueado", {"OK"})
                     Loop
                  EndIf
               Endif
               SG1->( DbSkip() )
            EndDo
            SB5->( DBGoTo(nPosSB5) )    //Retornar a posicao no SB5
         Else
            Aviso("M E N S A G E M","Codigo -> "+SB1->B1_COD+" - Registro Bloqueado", {"OK"})
            Loop
         EndIf
      Else
         Aviso("M E N S A G E M","Codigo -> "+SB5->B5_COD+" - Registro Bloqueado", {"OK"})
         Loop
      Endif

      If SB1->( dbSeek( xFilial( "SB1" ) + _cCodSec, .T. ) )
         If RecLock( "SB1", .F. )
            If SB1->B1_PESO <> _nDens
                @ ++nLIN,00 Psay Alltrim( _cCodSec )
               @ nLIN,37 Psay SB1->B1_PESO Picture "@E 999,999.999999"
            @ nLIN,54 Psay _nDens Picture "@E 999,999.999999"
            EndIf
            SB1->B1_PESO := _nDens
            SB1->B1_CONV := _nFtCo
            If Empty( SB1->B1_PESOR )
                SB1->B1_PESOR := _nDens
            EndIf
            SB1->( MsUnlock() )
         Endif
      EndIf
      SB1->( dbgoto( nPosSB1 ) )
   EndIf
   If nLIN > 60
      nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 18 ) //Impressao do cabecalho
   EndIf
   SB5->( DBSkip() )
   IncProc()
Enddo

roda( 0, "" , tamanho )
If aReturn[5] == 1
   dbCommitAll()
   ourspool( wnrel )
Endif
MS_FLUSH()
SAI_PROG()

Return NIL


*****************
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function SAI_PROG
Static Function SAI_PROG()
*****************
RetIndex('SB5')
RetIndex('SB1')
RetIndex('SG1')
Return NIL
