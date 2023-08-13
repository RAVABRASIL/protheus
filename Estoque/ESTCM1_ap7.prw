#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTCM1()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRUT,CARQTMP,CFILTRO,CCHAVE,CINDTMP,CCOD")
SetPrvt("CLOCAL,NVALCUST,NQTD,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  ESTCM1  ³ Autor ³   Silvano Araujo      ³ Data ³ 25/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acerto do valor do custo medio pelas nf de entrada         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava Embalagens                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Data Digitacao                    ³
//³ mv_par02             // Ate Data Digitacao                   ³
//³ mv_par03             // Data Gravacao Saldo Inicial          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte( "ESTCM1",.f.)
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Geracao do Custo Medio Inicial"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("ESTCM1")
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
Close(oDlg1)
Processa( {|| CalcCm1() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(CalcCm1) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function CalcCm1
Static Function CalcCm1()

SB1->( dbSetOrder( 1 ) )
SB1->( dbGoTop() )

SD1->( dbSetOrder( 6 ) )
SD1->( dbSeek( xFilial( "SD1" ) + Dtos( mv_par01 ), .t. ) )
ProcRegua( SD1->( lastrec() ) - SD1->( Recno() )  )

SD1->( dbSetOrder( 7 ) )
while SB1->( !Eof() )

   cCod   := SB1->B1_COD
   cLocal := SB1->B1_LOCPAD

   if SB1->B1_TIPO <> "PA"

      SD1->( dbSeek( xFilial( "SD1" ) + cCod + cLocal + Dtos( mv_par01 ), .t. ) )
      nValCust := nQtd := 0

      Do While SD1->D1_COD + SD1->D1_LOCAL == cCod + cLocal .and. SD1->D1_DTDIGIT <= mv_par02 .and. SD1->( ! Eof() )
         nValCust += SD1->D1_TOTAL - SD1->D1_VALICM
         nQtd     += SD1->D1_QUANT
         SD1->( dbSkip() )
      EndDo

      If nQTD > 0 .and. SB2->( dbSeek( xFilial( "SB2" ) + cCOD + cLOCAL ) ) //.and. SB2->B2_CM1 <= 0
         RecLock( "SB2", .f. )
         SB2->B2_CM1   := nVALCUST / nQTD
         SB2->B2_VATU1 := SB2->B2_QATU * SB2->B2_CM1
         SB2->B2_VFIM1 := SB2->B2_QFIM * SB2->B2_CM1
         SB2->( MsUnlock() )
         SB2->( dbCommit() )

         If SB9->( dbSeek( xFilial( "SB9" ) + cCOD + cLOCAL + Dtos( mv_par03 ) ) )
            RecLock( "SB9", .f. )
            SB9->B9_VINI1 := SB9->B9_QINI * SB2->B2_CM1
            SB9->B9_VINI2 := 0
            SB9->( MsUnlock() )
            SB9->( dbCommit() )
         endIf

      endIf

   endif

   SB1->( dbSkip() )
   IncProc()

End
Return NIL
