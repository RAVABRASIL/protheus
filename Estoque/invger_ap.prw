#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function INVGER()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LFLAG,NANOEXERC,NREGTOT,NPRODUCAO,APRODUCAO,NPESQ")
SetPrvt("CTIPOOC,X,NSALDOD,NSALDOI,NVALTOT,CCOD,NC_TOTAL")
SetPrvt("NC_VAR,NC_FIXOD,NC_FIXOI,SAIR,NPOS,NREG,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³INVGER    ³ Autor ³ Mauricio Barros       ³ Data ³ 29/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gerar registros no inventario com todos os produtos         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
mv_par01 - Data do inventario
/*/
Pergunte( "INVGER", .T. )               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Gerar inventario total"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte( "INVGER" )
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()

lFlag := MsgBox ( "Confirma geracao do inventario?", "Escolha", "YESNO" )
if ! lFlag
   Return
endif

Close(oDlg1)
Processa( {|| GeraInv() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(CalcCusto) } )
Return



// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Rotina de Calculo do Custo de Producao.                      ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function CalcCusto
Static Function GeraInv()

SB7->( DbSetOrder( 1 ) )
SB1->( DbGoTop() )
nRegTot := SB1->( LastRec() )
ProcRegua( nREGTOT )
SB7->( dbseek( xFilial( "SB7" ) + Dtos( mv_par01 ), .T. ) )
If MV_PAR01 <> SB7->B7_DATA
    lFlag := MsgBox( "Inventario inexistente, Cadastra?", "Escolha", "YESNO" )
    if ! lFlag
       Return NIL
    endif
    cDOC := Left( Dtoc( MV_PAR01 ), 2 ) + SubStr( Dtoc( MV_PAR01 ), 4, 2 ) + Right( Dtoc( MV_PAR01 ), 2 )
Else
    cDOC := SB7->B7_DOC
EndIf
Do While SB1->( ! Eof() )
  SB7->( DbSeek( xFilial( "SB7" ) + Dtos( mv_par01 ) + SB1->B1_COD, .T. ) )
  If ! SB7->B7_COD == SB1->B1_COD
    If Reclock( "SB7", .T. )
       SB7->B7_FILIAL  := xFilial( "SB7" )
       SB7->B7_COD     := SB1->B1_COD
       SB7->B7_LOCAL   := SB1->B1_LOCPAD
       SB7->B7_TIPO    := SB1->B1_TIPO
       SB7->B7_DOC     := cDOC
       SB7->B7_QUANT   := 0
       SB7->B7_QTSEGUM := 0
       SB7->B7_DATA    := MV_PAR01
       SB7->B7_DTVALID := MV_PAR01
       SB7->( dbunlock() )
    EndIf
  Endif
  SB1->( dbskip() )
  IncProc()
EndDo
Return Nil

