 #include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

*************

User Function MovConta2( nMES, nANO, nMoeda, cConta, nX, cCusto )

*************

Local aArea     := { Alias() , IndexOrd() , Recno() }
Local aAreaSI2  := { SI2->(IndexOrd()) , SI2->(Recno()) }
Local nSldCta   := 0
Local dDtIni    := dDtFim := Ctod("")

dDTREF := Ctod( "01/" + StrZero( nMES, 2 ) + "/" + StrZero( nANO, 4 ) )
dDtIni := CalcData(dDtRef,nMoeda)[1]
dDtFim := CalcData(dDtRef,nMoeda)[2]
cConta := Padr( cConta, 20 )
nX     := If( nX == NIL, 1, 0 )

dbSelectArea("SI2")
dbSetOrder(4)
dbSeek(xFilial("SI2")+cConta+Dtos(dDtIni),.T.)
While ( !Eof() .And. SI2->I2_FILIAL == xFilial("SI2") .And. ;
      SI2->I2_DEBITO == cConta .And. SI2->I2_DATA <= dDtFim )
  If (Empty(cCusto) .Or. SI2->I2_CCD == cCusto) .And. ( ( SI2->I2_DC $ "XD" .and. nX == 1 ) .or. ( SI2->I2_DC $ "D" .and. nX == 0 ) )
    If ( nMoeda == 1 )
      nSldCta += SI2->I2_VALOR
    Else
      nSldCta += SI2->(FieldGet(FieldPos("I2_VLMOED"+StrZero(nMoeda,1))))
    EndIf
  EndIf
  dbSelectArea("SI2")
  dbSkip()
EndDo
/*
dbSelectArea("SI2")
dbSetOrder(5)
dbSeek(xFilial("SI2")+cConta+Dtos(dDtIni),.T.)
While ( !Eof() .And. SI2->I2_FILIAL == xFilial("SI2") .And. SI2->I2_CREDITO == cConta .And. SI2->I2_DATA <= dDtFim )
  If ( (Empty(cCusto) .Or. SI2->I2_CCC == cCusto) .And. SI2->I2_DC $ "XC" )
    If ( nMoeda == 1 )
      nSldCta += SI2->I2_VALOR
    Else
      nSldCta += SI2->(FieldGet(FieldPos("I2_VLMOED"+StrZero(nMoeda,1))))
    EndIf
  EndIf
  dbSelectArea("SI2")
  dbSkip()
EndDo
*/
dbSelectArea( aArea[1])
dbSetOrder( aArea[2])
dbGoTo( aArea[3])

Return( nSldCta )

/*
Local dData
LOCAL nMovim := 0
Local cAliasSI:=IIf(nMoeda==1,"SI1","SI7")
Local aTam := {}
Local cMoeda := ""

Private cMes

nMoeda := Iif( nMoeda = Nil, 1, nMoeda )
cMoeda := Str( nMoeda, 1 )
cArea  := Iif( nMoeda == 1 , "SI1" , "SI7" )

If Empty(nAno)
  If nMES <= 12
    dData := Ctod("01/"+StrZero(nMES,2)+"/"+StrZero(Year(dDataBase),4), "ddmmyy")
  EndIf
Else
  If nMES <= 12
    dData := Ctod("01/"+Strzero(nMES,2)+"/"+AllTrim(Str(nAno,4)), "ddmmyy")
  EndIf
EndIf

// 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
// � Verifica qual e'o periodo de acordo com m늮    �
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If nMES <= 12
  If ! DataMoeda( nMoeda, @cMes, dData )
    Return 0
  End
EndIf

cContaDe  := Trim ( cContaDe )  + Space ( 20 - Len ( Trim ( cContaDe ) ) )
cContaAte := Trim ( cContaAte ) + Space ( 20 - Len ( Trim ( cContaAte ) ) )

IF nMoeda = 1
   dbSelectArea ( "SI1" )
   dbSeek ( cFilial + cContaDe , .T. )
Else
   dbSelectArea ( "SI7" )
   dbSeek ( cFilial + cContaDe + Str ( nMoeda , 1 ) , .T. )
End

While !Eof()

   IF nMoeda == 1
      IF cFilial != I1_FILIAL .or. I1_CODIGO > cContaAte
        Exit
      End
   ElseIf cFilial != I7_FILIAL .or.I7_CODIGO > cContaAte
      Exit
   End

   IF nMoeda != 1
      SI1 -> ( dbSeek ( cFilial + SI7->I7_CODIGO ) )
   End

   IF SI1->I1_CLASSE = "S"
      dbSkip()
      Loop
   End

   IF nMoeda > 1
      If SI7->I7_MOEDA != Str ( nMoeda , 1 )
         dbSkip()
         Loop
      End
   End

   nMovim += ( IIF ( nMoeda == 1, I1_DEBM&cMes - I1_CRDM&cMes , I7_DEBM&cMes - I7_CRDM&cMes ) )

   dbSkip ( )

End
Return nMovim
*/
