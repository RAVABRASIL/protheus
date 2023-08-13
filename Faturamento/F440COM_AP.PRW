#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function F440COM()    // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ F440COM                                 ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Ponto de entrada p/ gravacao do historico do titulo        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Quando serie da nota for '   '                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

SetPrvt( "nCONT,nORDSC5,nREGSC5,nORDSA1,nREGSA1," )

If Type( "PARAMIXB" ) <> "A"
   Return NIL
Endif
nREGSE1 := SE1->( Recno() )
nORDSC5 := SC5->( IndexOrd() )
nREGSC5 := SC5->( Recno() )
nORDSA1 := SA1->( IndexOrd() )
nREGSA1 := SA1->( Recno() )
SC5->( dbSetOrder( 1 ) )
For nCONT := 1 to Len( PARAMIXB )
    SE1->( DbGoto( PARAMIXB[ nCONT ] ) )
    SC5->( dbSeek( xFilial() + SE1->E1_PEDIDO ) )
    If 'VD' $ SC5->C5_VEND1
      SA1->( DbSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI, .T. ) )
      cHist  := Alltrim( SA1->A1_TEL )
      cHIst  := cHist + iif( Substr( SC5->C5_TIPAGTO, 1, 1 )=="C"," - Ch.nao Rc",iif( Substr( SC5->C5_TIPAGTO, 1, 1 )=="R"," - Ch.nao Rc","" ) )
      cHist1 := Alltrim( SA1->A1_TEL )
      cHIst1 := cHist + iif( Substr( SC5->C5_TIPAGTO, 2, 1 )=="C"," - Ch.Receb.",iif( Substr( SC5->C5_TIPAGTO, 2, 1 )=="R"," - Ch.Receb.","" ) )
      Reclock( "SE1", .F. )
      SE1->E1_HIST   := cHIST
      //04/02/2009
      //Alterei de NP para NF pois o Siga nao exclui o titulo na exclusao da NF
      SE1->E1_TIPO   := "NF"
      SE1->E1_COMIS1 := SC5->C5_COMIS1
      SE1->( msUnlock() )
    EndIf
Next
SC5->( DbSetOrder( nORDSC5 ) )
SC5->( DbGoto( nREGSC5 ) )
SA1->( DbSetOrder( nORDSA1 ) )
SA1->( DbGoto( nREGSA1 ) )
SE1->( DbGoto( nREGSE1 ) )
Return NIL
