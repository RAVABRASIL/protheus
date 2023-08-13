#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function CONVNAT()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CONVNAT   ³ Autor ³ Silvano Araujo        ³ Data ³ 29/12/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Conversao cadastro de Naturezas                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Pergunte("FIN009",.F.)               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Conversao Cadastro de Natureza"
// @ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("FIN009")
@ 10,040 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,040 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,080 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
Close(oDlg1)
Processa( {|| ConvNatu() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(ConvNatu) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function ConvNatu
Static Function ConvNatu()

// Atualizando o arquivo de Itens de Notas Fiscais - SD1
SD1->( dbSetOrder( 0 ) )
SD1->( dbGotop() )
ProcRegua( SD1->( Lastrec() ) )
while SD1->( !Eof() )

   if Empty( SD1->D1_NATUREZ )
      IncProc()
      SD1->( dbSkip() )
      Loop
   endif

   SED->( dbSeek( xFilial( "SED" ) + SD1->D1_NATUREZ, .T. ) )
   RecLock( "SD1", .f. )
   if Empty( SD1->D1_NATANT )
      SD1->D1_NATANT := SD1->D1_NATUREZ
   endif
   SD1->D1_NATUREZ := SED->ED_NATNOVO
   SD1->( MsUnlock() )
   SD1->( dbCommit() )
   SD1->( dbSkip() )
   IncProc()

End

// Atualizando o arquivo de Itens de Notas Fiscais de saidas - SD1
SD2->( dbSetOrder( 0 ) )
SD2->( dbGotop() )
ProcRegua( SD2->( Lastrec() ) )
while SD2->( !Eof() )

   if Empty( SD2->D2_NATUREZ )
      IncProc()
      SD2->( dbSkip() )
      Loop
   endif

   SED->( dbSeek( xFilial( "SED" ) + SD2->D2_NATUREZ, .T. ) )
   RecLock( "SD2", .f. )
   if Empty( SD2->D2_NATANT )
      SD2->D2_NATANT := SD2->D2_NATUREZ
   endif
   SD2->D2_NATUREZ := SED->ED_NATNOVO
   SD2->( MsUnlock() )
   SD2->( dbCommit() )
   SD2->( dbSkip() )
   IncProc()

End

// Atualizando o arquivo de Contas a Receber - SE1
SE1->( dbSetOrder( 0 ) )
SE1->( dbGotop() )
ProcRegua( SE1->( Lastrec() ) )
while SE1->( !Eof() )

   if Empty( SE1->E1_NATUREZ )
      IncProc()
      SE1->( dbSkip() )
      Loop
   endif

   SED->( dbSeek( xFilial( "SED" ) + SE1->E1_NATUREZ, .T. ) )
   RecLock( "SE1", .f. )
   if Empty( SE1->E1_NATANT )
      SE1->E1_NATANT := SE1->E1_NATUREZ
   endif
   SE1->E1_NATUREZ := SED->ED_NATNOVO
   SE1->( MsUnlock() )
   SE1->( dbCommit() )
   SE1->( dbSkip() )
   IncProc()

End

// Atualizando o arquivo de Contas a Pagar - SE2
SE2->( dbSetOrder( 0 ) )
SE2->( dbGotop() )
ProcRegua( SE2->( Lastrec() ) )
while SE2->( !Eof() )

   if Empty( SE2->E2_NATUREZ )
      IncProc()
      SE2->( dbSkip() )
      Loop
   endif

   SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ, .T. ) )
   RecLock( "SE2", .f. )
   if Empty( SE2->E2_NATANT )
      SE2->E2_NATANT := SE2->E2_NATUREZ
   endif
   SE2->E2_NATUREZ := SED->ED_NATNOVO
   SE2->( MsUnlock() )
   SE2->( dbCommit() )
   SE2->( dbSkip() )
   IncProc()

End

// Atualizando o arquivo de Movimneto Bancario - SE5
SE5->( dbSetOrder( 0 ) )
SE5->( dbGotop() )
ProcRegua( SE5->( Lastrec() ) )
while SE5->( !Eof() )

   if Empty( SE5->E5_NATUREZ )
      IncProc()
      SE5->( dbSkip() )
      Loop
   endif

   SED->( dbSeek( xFilial( "SED" ) + SE5->E5_NATUREZ, .T. ) )
   RecLock( "SE5", .f. )
   if Empty( SE5->E5_NATANT )
      SE5->E5_NATANT := SE5->E5_NATUREZ
   endif
   SE5->E5_NATUREZ := SED->ED_NATNOVO
   SE5->( MsUnlock() )
   SE5->( dbCommit() )
   SE5->( dbSkip() )
   IncProc()

End

// Atualizando o arquivo de natureza - SED
SED->( dbSetOrder( 0 ) )
SED->( dbGotop() )
ProcRegua( SED->( Lastrec() ) )
while SED->( !Eof() )

   if Empty( SED->ED_CODIGO ) .OR. Empty( SED->ED_NATNOVO )
      IncProc()
      SED->( dbSkip() )
      Loop
   endif

   RecLock( "SED", .f. )
   if Empty( SED->ED_NATANT )
      SED->ED_NATANT := SED->ED_CODIGO
   endif
   SED->ED_CODIGO := SED->ED_NATNOVO
   SED->( MsUnlock() )
   SED->( dbCommit() )
   SED->( dbSkip() )
   IncProc()

End

Ferase("\GESTAO\DADOSADV\SD1010.CDX")
Ferase("\GESTAO\DADOSADV\SE1010.CDX")
Ferase("\GESTAO\DADOSADV\SE2010.CDX")
Ferase("\GESTAO\DADOSADV\SE5010.CDX")
Ferase("\GESTAO\DADOSADV\SED010.CDX")

Return
