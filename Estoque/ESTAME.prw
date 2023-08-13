#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTAME()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTOTQUANT,I,CPARQUANT,CFILTRO,CCHAVE,CINDSB1")
SetPrvt("CCODPI,NPOSPA,NCONT,API,ACOMP,NPOSPI")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Adenildo Macedo de Almeida               ³ Data ³ 02/04/01 ³±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Alterado ³ Mauricio Barros                         ³ Data ³ 26/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Alterar a estrutura dos PI's pelo padrao da cor            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Informatica                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

tamanho   := "M"
cDesc1    := PADC( "Este programa ira alterar a estrutra dos Produtos selecionados", 74 )
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "ESTAME"
cPerg     := "ESTAME"
nLastKey  := 0
wnrel     := "ESTAME"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao no SX1               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .F. )               // Pergunta no SX1

cString := "SB1"
titulo  := Padc( "LOG de alteracoes na estrutura dos PI'S", 40 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "ESTAME"            //Nome Default do relatorio em Disco

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .T., "",, Tamanho )
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


dbselectarea( "SB1" )
SB1->( dbsetorder( 1 ) )
dbselectarea( "SG1" )
SG1->( dbsetorder( 1 ) )

aPI       := {}
aCOMP     := {}
nTOTQUANT := 0
For I := 3 To 8 Step 2
   nTOTQUANT += &( 'mv_par' + StrZero( I, 2 ) )
   If ! Empty( &( 'mv_par' + StrZero( I, 2 ) ) )  // Adiciona a matriz os componentes informados nos parametros
      Aadd( aCOMP, { &( 'mv_par' + StrZero( I - 1, 2 ) ), &( 'mv_par' + StrZero( I, 2 ) ) } )
   EndIf
Next

If nTOTQUANT == 100
   Processa( {|| Est_Aep() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Processa( {|| Execute(Est_Aep) } )
Else
   MSGBOX( 'Formulacao Incorreta - (Diferente de 100)', "M E N S A G E M" , "STOP" )
Endif
Return


Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Est_Aep
Static Function Est_Aep()

DBSelectArea("SB1")
DBSelectArea("SB5")
SB5->( DBSetOrder( 1 ) )
cCorME := alltrim(mv_par01)
cCHAVE  := "xFilial('SB1')+B1_COD"
cIndSB1 := CriaTrab( NIL, .F. )
IndRegua( "SB1", cIndSB1, cCHAVE,, "SubStr( B1_COD, 8, 1 ) == ' ' .and. SubStr( B1_COD, 1, 2 ) == 'ME' .and. B1_TIPO == 'ME' .and. SB1->B1_ATIVO # 'N'", "Selecionando Produtos..")

//Processando Cadastro de Produtos
ProcRegua( SB1->( LastRec() ) )
m_PAG  := 1     //Variavel que acumula o numero de pagina
cabec1 := "----ME----   ----PI----   Componente   ------------------------------------ O c o r r e n c i a ------------------------------------"
//         0            13           26           39
cabec2 := ""
nCount := 0
nLin   := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
SB1->( DBGoTop() )
Do While ! SB1->( Eof() )
  SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )  // Pesquisa estrutura do ME
	SB5->( DBSeek( xFilial( "SB5" ) + SB1->B1_COD, .T. ) )  // Para checar a cor do ME
  If (SG1->G1_COD == SB1->B1_COD) .AND. (alltrim(SB5->B5_COR) == cCorME)
     Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1->B1_COD
        nPOSME := SG1->( RecNo() )
        If Left( SG1->G1_COMP, 2 ) == 'PI' .and. Empty( Ascan( aPI, SG1->G1_COMP ) )  // Se o componente for PI e ainda nao processado
           Aadd( aPI, SG1->G1_COMP )
           cCODPI := SG1->G1_COMP
           SG1->( DbSeek( xFilial( "SG1" ) + cCODPI, .T. ) )  // Pesquisa estrutura do PI
           If SG1->G1_COD == cCODPI
              nCONT  := 0
              lFLAG  := .F.
              nPOSPI := SG1->( Recno() )
              Do While ! SG1->( Eof() ) .and. SG1->G1_COD == cCODPI  // Verifica se estrutura e igual a informada nos parametros
                 If Empty( Ascan( aCOMP, { |X| X[1] == SG1->G1_COMP } ) )
                    lFLAG := .T.
                    Exit
                 EndIf
                 nCONT++
                 SG1->( DbSkip() )
              EndDo
              If lFLAG
                 @ nLIN,00 Psay Alltrim( SB1->B1_COD )
                 @ nLIN,13 Psay Alltrim( cCODPI )
                 @ nLIN,26 Psay AllTrim( SG1->G1_COMP )
                 @ nLIN,39 Psay "PI do ME tem componente diferente na estrutura."
                 nLIN++
              ElseIf nCONT # Len( aCOMP )
                 @ nLIN,00 Psay Alltrim( SB1->B1_COD )
                 @ nLIN,13 Psay Alltrim( cCODPI )
                 @ nLIN,39 Psay "PI do ME tem numero de componentes diferentes dos informados."
								 nLIN++
              Else
                SG1->( DBGoTo( nPOSPI ) )
								cValues := ""
								cComplm := ""
								nCol := 0
								@ nLIN,00 Psay Alltrim( SB1->B1_COD )
							  @ nLIN,13 Psay Alltrim( cCODPI )
                Do While ! SG1->( Eof() ) .and. SG1->G1_COD == cCODPI
                   I := Ascan( aCOMP, { |X| X[1] == SG1->G1_COMP } )
									 If nCol < 3
											cValues += alltrim(aCOMP[I, 1])+" De: " + alltrim(str(SG1->G1_QUANT)) +" Para: " +;
													 				 ""+alltrim(str(aCOMP[ I, 2 ]))+" | "
											nCol++
									 Else
											cComplm += alltrim(aCOMP[I, 1])+" De: " + alltrim(str(SG1->G1_QUANT)) +" Para: " +;
													 				 ""+alltrim(str(aCOMP[ I, 2 ]))+" | "
									 EndIf
                   If RecLock( "SG1", .F. )
                      SG1->G1_QUANT := aCOMP[ I, 2 ]
                      SG1->( DBCommit() )
                      SG1->( MsUnlock() )
                   Endif
                   SG1->( DbSkip() )
                EndDo
								@ nLIN,39 Psay alltrim(cValues)
								nLIN++
								If cComplm != ""
									@ nLIN,39 Psay alltrim(cComplm)
									nLIN++
								Endif
              EndIf
           Else
              @ nLIN,00 Psay Alltrim( SB1->B1_COD )
              @ nLIN,13 Psay Alltrim( cCODPI )
              @ nLIN,39 Psay "PI do ME nao possui estrutura."
              nLIN++
           Endif
           If nLIN > 60
              nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
           EndIf
           SG1->( DBGoTo( nPOSME ) )
        Endif
        SG1->( DbSkip() )
     EndDo
  Else
     @ nLIN,00 Psay Alltrim( SB1->B1_COD )
		 if (alltrim(SB5->B5_COR) != cCorME) .AND. (SG1->G1_COD == SB1->B1_COD)
     		@ nLIN,39 Psay "ME tem cor diferente. Original: "+alltrim(SB5->B5_COR)+" Parametro: "+cCorME
		 Else
				@ nLIN,39 Psay "ME nao possui estrutura."
		 EndIf
     nLIN++
     If nLIN > 60
        nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
     EndIf
  Endif
  SB1->( DbSkip() )
	nCount++
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
*** **************
RetIndex('SB1')
RetIndex('SG1')
Return NIL
