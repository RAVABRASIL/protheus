#include "rwmake.ch"

//O P.E. e' chamado antes de qualquer atualizacao na exclusao e deve 
//ser utilizado para validar se a exclusao deve ser efetuada ou nao.

User Function A100DEL()

_nIndD1 := SD1->( IndexOrd() )
_nRecD1 := SD1->( Recno() )
_nIndB1 := SB1->( IndexOrd() )
_nRecB1 := SB1->( Recno() )
_nRecF4 := SF4->( Recno() )


If SM0->M0_CODIGO == "02" .and. SF1->F1_TIPO == "D"
	
	SD1->( DbSetOrder( 1 ) )
	SD1->( DbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA, .T. ) )
	
	
	Do while SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_SERIE + SD1->D1_DOC == SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC
		
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES) )
		if SF4->F4_ESTOQUE = 'S'			
			If Len( AllTrim( SD1->D1_COD ) ) >= 8
				SB1->( DbSetOrder( 1 ) )
				SB1->( DbSeek( xFilial("SB1") + SD1->D1_COD ) )
				nPESO := SB1->B1_PESOR
				lMsErroAuto := .T.
				Do While lMsErroAuto
					
					lMsErroAuto := .F.
					aMATRIZ     := { { "D3_TM", "003", NIL},;
					{ "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
					{ "D3_FILIAL", xFilial( "SD3" ), NIL},;
					{ "D3_LOCAL", "01", NIL },;
					{ "D3_COD", SD1->D1_COD, NIL},;
					{ "D3_QUANT", SD1->D1_QUANT, NIL },;
					{ "D3_EMISSAO", dDATABASE, NIL} }
					
					//   Begin Transaction
					MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
					//      IF lMsErroAuto
					//        DisarmTransaction()
					//      Endif
					//   End Transaction
				EndDo
				cCODSECU := If( Len( AllTrim( SD1->D1_COD ) ) = 8, SUBS( SD1->D1_COD, 1, 1 ) + SUBS( SD1->D1_COD, 3, 3 ) +;
				SUBS( SD1->D1_COD, 7, 2 ), SUBS( SD1->D1_COD, 1, 1 ) + SUBS( SD1->D1_COD, 3, 4 ) +;
				SUBS( SD1->D1_COD, 8, 2 ) )
				
				SB1->( DbSeek( xFilial("SB1") + cCODSECU ) )
				
				lMsErroAuto := .T.
				Do While lMsErroAuto
					lMsErroAuto := .F.
					aMATRIZ     := { { "D3_TM", "503", NIL},;
					{ "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
					{ "D3_FILIAL", xFilial( "SD3" ),Nil},;
					{ "D3_LOCAL", "01", NIL },;
					{ "D3_COD", cCODSECU, NIL},;
					{ "D3_QUANT", SD1->D1_QUANT, NIL },;
					{ "D3_EMISSAO", dDATABASE, NIL} }
					
					//      Begin Transaction
					MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
					//        IF lMsErroAuto
					//            DisarmTransaction()
					//         Endif
					//      End Transaction
				EndDo
			EndIf
		endif
		SD1->( dbSkip() )
	EndDo
	
endif

SD1->( DbSetOrder( _nINDD1 ) )
SD1->( DbGoto( _nRECD1 ) )
SB1->( DbSetOrder( _nINDB1 ) )
SB1->( DbGoto( _nRECB1 ) )
SF4->( DbGoto( _nRECF4 ) )

Return .T.