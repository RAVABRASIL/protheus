#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/05/01
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function CLI()

SetPrvt("lRET,")

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±± Nome     : Eurivan Marques Candido                    Data  : 06/11/02  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±± Descricao: Verificar situacao Financeira do cliente no Faturamento      ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

dbselectarea( "SA1" )
dbsetorder( 1 )

lRET := .T.
if dbSeek( xFilial( "SA1" ) + M->C5_CLIENTE, .T. )

   if SA1->A1_ATR > 0 .AND. SA1->A1_LIBCR # "S"

      MsgBox ( "O Cliente: " + AllTrim( SA1->A1_NREDUZ ) + " possui titulos em atraso.";
              + CHR(13) + CHR(13) + "Consulte Departamento Financeiro.", "Aviso!!!", "STOP" )
      lRET := .F.

   elseif SA1->A1_ATR > 0 .AND. SA1->A1_LIBCR = "S"

      if RecLock( "SA1", .F. )
         SA1->A1_LIBCR := "N"
         SA1->( DbUnlock() )
         SA1->( DbCommit() )
      endif

   endif

endif

Return( lRET )
