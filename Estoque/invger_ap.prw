#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function INVGER()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("LFLAG,NANOEXERC,NREGTOT,NPRODUCAO,APRODUCAO,NPESQ")
SetPrvt("CTIPOOC,X,NSALDOD,NSALDOI,NVALTOT,CCOD,NC_TOTAL")
SetPrvt("NC_VAR,NC_FIXOD,NC_FIXOI,SAIR,NPOS,NREG,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿔NVGER    � Autor � Mauricio Barros       � Data � 29/07/04 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿒erar registros no inventario com todos os produtos         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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



// 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
// � Rotina de Calculo do Custo de Producao.                      �
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

