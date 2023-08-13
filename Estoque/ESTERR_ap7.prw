#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTERR()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CCOD,CLOCAL,NREGSB1,NCUSMED,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  ESTCM2  ³ Autor ³   Silvano Araujo      ³ Data ³ 30/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acerto do valor do custo medio pela estrutura de produtos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava Embalagens                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Tipo                              ³
//³ mv_par02             // Ate Tipo                             ³
//³ mv_par03             // De Produto                           ³
//³ mv_par04             // Ate Produto                          ³
//³ mv_par05             // Data ATualizacao saldo Inicial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte( "ESTCM2",.f.)
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Geracao do Custo Medio Inicial pelo SB9"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("ESTCM2")
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
Close(oDlg1)
Processa( {|| CalcCm2() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(CalcCm2) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function CalcCm2
Static Function CalcCm2()

SD2->( dbSetOrder( 6 ) )
SD3->( dbSetOrder( 7 ) )
SB1->( dbSetOrder( 1 ) )
SB1->( dbSeek( xFilial( "SB1" ), .t. ) )
SG1->( dbSetOrder( 1 ) )

ProcRegua( SB1->( lastrec() ) )

while SB1->( !Eof() )

   cCod   := SB1->B1_COD
   cLocal := SB1->B1_LOCPAD

   if SB1->B1_TIPO < mv_par01 .or. SB1->B1_TIPO > mv_par02
      SB1->( dbSkip() )
      IncProc()
      Loop
   endif

   if SB1->B1_COD < mv_par03 .or. SB1->B1_COD > mv_par04
      SB1->( dbSkip() )
      IncProc()
      Loop
   endif

   nRegSB1 := SB1->( Recno() )
   SB9->( dbSeek( xFilial( "SB9" ) + cCod + cLocal + Dtos( mv_par05 ), .f. ) )

   /*/
   if SB9->( Eof() )
      nCusMed := 0
   else
      nCusMed := Round( SB9->B9_VINI1/ SB9->B9_QINI, 4 )
   endif

   SB9->( dbSKip() )
   if SB9->B9_COD == cCod
      Reclock( "SB9", .f. )
      SB9->B9_VINI1 := SB9->B9_QINI * nCusMed
      SB9->( MsUnlock() )
      SB9->( dbCommit() )
   endif
   /*/

   SB2->( dbSeek( xFilial( "SB2" ) + cCod + cLocal, .f. ) )
   if SB2->B2_COD + SB2->B2_LOCAL == cCod + cLocal .and. SB2->( !Eof() )
      RecLock( "SB2", .f. )
      SB2->B2_VFIM1 := SB9->B9_VINI1
      SB2->B2_QFIM  := SB9->B9_QINI
      SB2->B2_CM1   := SB9->B9_VINI1 / SB9->B9_QINI

      // SB2->B2_CM2 := 0 SB2->B2_VATU1 := SB2->B2_VATU2 := SB2->B2_VFIM1 := SB2->B2_QFIM := 0
      SB2->( MsUnlock() )
      SB2->( dbCommit() )
   end

   SB1->( dbSkip() )
   IncProc()

End

Return
