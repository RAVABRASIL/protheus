#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MTA410E()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LFLAG,CARQ,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MTA460                                          ³ 03/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cancelamento de Pedidos de vendas - RAVA                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

lFlag := .T.

if SM0->M0_CODIGO == "02" .and. !'VD' $ SF2->F2_VEND1

   if Select( "XC5" ) == 0
      cArq := "SC5010"
      Use ( cArq ) ALIAS XC5 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
   XC5->( DbSetOrder( 1 ) )
   if XC5->( dbSeek( xFilial( "SC5" ) + SC5->C5_NUM, .T. ) )

      RecLock( "XC5", .F. )
      XC5->( dbDelete() )
      XC5->( msUnlock() )

      if Select( "XC6" ) == 0
         cArq := "SC6010"
         Use (cArq) ALIAS XC6 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
      endif
      XC6->( DbSetOrder( 1 ) )
      if XC6->( dbSeek( xFilial( "SC6" ) + SC5->C5_NUM, .t. ) )
         while XC6->C6_NUM == SC5->C5_NUM .and. XC6->( !Eof() )
            RecLock( "XC6", .F. )
            XC6->( dbDelete() )
            XC6->( msUnlock() )
           XC6->( dbSkip() )
         end
      endif
      dbCommit()
   endif   
endif

//Incluido em 10/02/2009 chamado 000784 
If Len(_aQtdAnt)!=0
   
   cNum:=_aQtdAnt[1][1]
   DbSelectArea("SZ6")
   DbSetORder(1)
   SZ6->(DbSeek(xFilial("SZ6")+cNum))

   While  !SZ6->(EOF()) .AND. SZ6->Z6_NUM ==cNum 

       nIdx  := aScan( _aQtdAnt, {|t| t[2]==SZ6->Z6_PRODUTO     } ) 
       if nIdx>0 
          RecLock("SZ6", .F.)
          SZ6->Z6_QTDENT -= _aQtdAnt[nIdx][3]          
          SZ6->( msUnlock() )
          SZ6->( dbCommit() )
         /*
          //Posiciono no cab. Pre-Pedido
          DbSelectArea("SZ5")
          DbSetOrder(1)       
          SZ5->(DbSeek(xFilial("SZ5")+SZ6->Z6_NUM))
           
          //Posiciono no Cab. Edital
          DbSelectArea("Z17")
          DbSetOrder(1)
          if Z17->(DbSeek(xFilial("Z17")+SZ5->Z5_EDITAL))
              RecLock("Z17",.F.)
              if U_GetSldPP(SZ6->Z6_NUM) <= 0
                 Z17->Z17_STATUS := '03' //Edital Concluido
              //else
                 // if U_GetPartRV(SZ5->Z5_EDITAL)
                 //    Z17->Z17_STATUS := '  ' //Edital em Andamento              
                 // else
                 //    Z17->Z17_STATUS := '01' //Edital nao participamos
                 // endif Retirado em 19/06/2008 por Emmanuel Lacerda
              endif
              Z17->(MsUnlock())
          endif*/
	   endif	
       SZ6->(dbSkip())
   EndDo  
  _aQtdAnt:={}
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(lFlag)
Return(lFlag)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
