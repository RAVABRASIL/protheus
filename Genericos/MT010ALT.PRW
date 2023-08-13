#IFDEF WINDOWS
	#include "fivewin.ch"
#ENDIF

User Function MT010ALT()

SetPrvt("_cCODSEC,ODLG,CTITULO,CGETDESC,CSAYDESC")

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±± Nome     : Eurivan Marques Candido                    Data  : 04/11/02  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±± Descricao: Alteracao do produto Secundario na alteracao do Primario     ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

if SB1->B1_TIPO == 'PA'
	oDlg     := ""
	cTitulo  := ""
	cTitulo  := "Produto Generico"
	cSayDesc := "Descricao:"
	
//	If Subs( SB1->B1_COD, 4, 1 ) $ "R/D"
//=======
//	If Subs( SB1->B1_COD, 4, 1 ) == "R"
	If Subs( SB1->B1_COD, 4, 1 ) $ "R/D"

		_cCodSec := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 4 ) + "6";
		+ Subs( SB1->B1_COD, 6, 2 )
	Else
		_cCodSec := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 3 ) + "6";
		+ Subs( SB1->B1_COD, 5, 2 )
	EndIf
	
	nPosSB1 := SB1->( Recno() )
	
	dbselectarea( "SX3" )
	dbsetorder( 1 )
	dbseek( "SB1", .T. )
	_aSB1 := {}
	while SX3->X3_ARQUIVO == "SB1"
		//   if empty( SX3->X3_CONTEXT )
		If SX3->X3_CAMPO != "B1_MRP"
			AAdd( _aSB1, AllTrim( SX3->X3_CAMPO ) )		//16/07/2010-Alterado por Flávia Rocha - não deixar copiar o campo B1_MRP
		Endif
		//   endif
		SX3->( dbskip() )
	end
	
	_aCONTEUD := {}
	
	dbselectarea( "SB1" )
	for I := 1 to len( _aSB1 )
		if _aSB1[ I ]$"B1_COD/B1_DESC"
			AAdd( _aCONTEUD, { _aSB1[ I ], " " } )
		else
			AAdd( _aCONTEUD, { _aSB1[ I ], FieldGet( FieldPos( _aSB1[ I ] ) ) } )
		endif
	next
	
	dbselectarea( "SB1" )
	dbsetorder( 1 )
	
	if len( Alltrim( SB1->B1_COD ) ) <= 7
		if dbSeek( xFilial( "SB1" ) + _cCodSec, .T. )
			
			cGetDesc := SB1->B1_DESC
			
			RecLock( "SB1", .F. )
			
			//Altera Descricao Produto generico
        	DEFINE MSDIALOG oDlg TITLE OemtoAnsi( cTitulo ) FROM  00,00 TO 80,400 PIXEL OF oMainWnd
			@ 010, 005 SAY cSayDesc SIZE 040, 0 OF oDlg PIXEL
			@ 019, 005 GET cGetDesc SIZE 160, 0 OF oDlg PIXEL
			DEFINE SBUTTON FROM 018, 170 TYPE 1 ACTION ( SB1->B1_DESC := cGetDesc, oDlg:End() ) ENABLE OF oDlg
			ACTIVATE MSDIALOG oDlg CENTER
			
			for I := 1 to len( _aSB1 )
				if ! ( _aSB1[ I ] $ "B1_COD/B1_DESC" )
					FieldPut( FieldPos( _aCONTEUD[ I, 1 ] ), _aCONTEUD[ I, 2 ] )
				endif
				
			next
			SB1->( MsUnlock() )
			SB1->( dbCommit() )
		else
           SB1->( dbgoto( nPosSB1 ) )
           U_MT010INC()		
		endif
	endif
	
	SB1->( dbgoto( nPosSB1 ) )
endif

Return
   
