#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function codsd3()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NNUM,CCOD,NREG,")

Set Date Brit
Set Dele On
Set Epoch To 1960
Set Exclusive ON
cls
@ 20,00 Say Time()
Use \DADOSTES\SD3020 New Index \DADOSTES\SD3020 Alias SD3


DbSeek( "01INVENT", .T. )
nNUM := 636
Do While SD3->( ! Eof() )
   cCOD := SD3->D3_DOC
   DbSkip()
   nREG := Recno()
   SD3->( DbSkip( -1 ) )
   Do While SD3->D3_DOC == cDOC
      SD3->D3_DOC := StrZero( nNUM, 6 )
      SD3->( Dbgoto( nREG ) )
      DbSkip()
      nREG := Recno()
      SD3->( DbSkip( -1 ) )
   EndDo
   nNUM++
EndDo
*----------------------------------------------------------------
@ 21,00 Say Time()
Return
