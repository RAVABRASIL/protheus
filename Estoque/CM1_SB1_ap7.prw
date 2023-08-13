#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function CM1_SB1()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Silvano da Silva Araujo                  ³ Data ³ 25/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Altualizar CM1 pelo SB1 - Ultima compra                    ³±±
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
//Pergunte("FINATA",.F.)               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Atualizacao CM1 pelo SB1 ULTIMA COMPRA"
//@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("ESTASL")
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return


dbselectarea( "SB1" )
SB1->( dbsetorder( 1 ) )
dbselectarea( "SB2" )
SB2->( dbsetorder( 1 ) )


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()

Close(oDlg1)
Processa( {|| CM1SB1() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(CM1SB1) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function CM1SB1
Static Function CM1SB1()

ProcRegua( SB1->( LastRec() ) )
SB1->( dbSetOrder( 2 ) )
SB1->( dbSeek( xFilial( "SB1" ) + "MP", .t. ) )
While SB1->B1_TIPO == "MP" .and. !SB1->( EOF() )

   If SB2->( dbSeek( xFilial( "SB2" ) + SB1->B1_COD + SB1->B1_LOCPAD ) )
      If RecLock( "SB2", .F. )
         SB2->B2_CM1 := SB1->B1_UPRC
         SB2->( DbUnlock() )
         SB2->( DbCommit() )
      Endif
   EndIf

   SB9->( dbSeek( xFilial( "SB9" ) + SB1->B1_COD + SB1->B1_LOCPAD + "20010630", .t. ) )
   if SB9->B9_COD+SB9->B9_LOCAL+Dtos(SB9->B9_DATA)==SB1->B1_COD+SB1->B1_LOCPAD+"20010630"
      If RecLock( "SB9", .f. )
         SB9->B9_VINI1 := SB9->B9_QINI*SB1->B1_UPRC
         SB9->( MsUnlock() )
         SB9->( dbCommit() )
      endif
   endif

   SB1->( DBSkip() )
   IncProc()
Enddo

RetIndex('SB9')
RetIndex('SB2')
Return NIL
