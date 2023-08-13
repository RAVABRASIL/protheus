#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

*************
User Function SldContas( cSTART, cEND, nPer, nMoeda, nAno )
*************

Local cAlias := Alias(), nReg := SI1->(Recno()), nOrd := SI1->(IndexOrd())
Local ni, lOK, cByte, nSaldo := 0
Local cFil := xFilial("SI1")

dbSelectArea("SI1")
dbSeek( cFil + cStart, .T. )
While !Eof() .and. I1_CODIGO <= cEnd .and. I1_FILIAL == cFil
   lOk := .t.
   IF Len(Alltrim(cSTART)) != Len(Alltrim(I1_CODIGO))
      lOk := .f.
   Endif
   IF lOk
      nSaldo += Saldo( I1_CODIGO, nPer, nMoeda, nAno )
      dbSelectArea("SI1")
   Endif
   dbSkip()
End
SI1->( dbGoto( nReg ) )
SI1->( dbSetOrder( nOrd ) )
If ! Empty( cAlias )
   dbSelectArea( cAlias )
Endif
Return nSaldo
