#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³M450LEG    ³ Autor ³ Mauricio Barros      ³ Data ³ 11/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ponto de entrada para incluir opcao na liberacao de credito ³±±
// MATA450 
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Alterado por ³ Gustavo Costa                         ³ Data ³ 28/08/12 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function M450LEG()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//Aadd( aROTINA, { "Estorna liber.", "U_BLOQPED", 0 , 0} )
//Aadd( aROTINA, { "Liber. Cred. 2", "U_LIBERACRED", 0 , 0} )

Return PARAMIXB



*************

User Function BLOQPED()

*************

Local nREG := SC9->( Recno() ), ;
      nORD := SC9->( IndexOrd() ), ;
      cPED := SC9->C9_PEDIDO

//If SC9->C9_BLCRED <> "  "
// NOVA LIBERACAO DE CREDITO
If SC9->C9_BLCRED <> "  "  .OR. SC9->C9_BLCRED <>'04'
   MsgBox( "A liberacao de credito deste pedido nao pode ser estornada.", "info", "stop" )
Else
   If MsgBox( "Estorna liberacao de credito do pedido: " + cPED + " - Cliente: " + SC9->C9_CLIENTE + "-" + SC9->C9_LOJA +  ". Confirma?", "Escolha", "YESNO" )
      SC9->( DbSetOrder( 1 ) )
      SC9->( DbSeek( xFILIAL( "SC9" ) + cPED, .T. ) )
      Do While SC9->C9_PEDIDO == cPED
         //If Empty( SC9->C9_BLCRED )
         // NOVA LIBERACAO DE CRETIDO
           If Empty( SC9->C9_BLCRED ) .OR. SC9->C9_BLCRED='04'          
            MaAvalSC9( "SC9", 4 )  // Estorno da liberacao
            RecLock( "SC9", .F. )
            SC9->C9_BLCRED := "04"  // Altero pra '04' pois o MAAVALSC9 grava '05'
            MsUnLock()
         Endif
         SC9->( DbSkip() )
      EndDo
      SC9->( DbSetorder( nORD ) )
      SC9->( DbGoto( nREG ) )
   EndIf
EndIf
Return NIL
