#include "protheus.ch"
#include "topconn.ch"
#include "font.ch"

*************

User Function SENHA( cTIPO )  // Funcao padrao retorna somente .T. ou .F.

*************

Private cNome   := Space( 15 )
Private _cSenha := Space( 20 )
Private cOpera  := Space( 01 )
Private hTemp   := 0
Private cBitmap := "LOGIN"
Private dData   := Ddatabase
Private lRetor  := .F.
Private aArq
Private oDlg0

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlg0 FROM 40, 30 TO 335,495 TITLE "Advanced Protheus" PIXEL OF oMainWnd
@ 000, 000 BITMAP oBmp RESNAME cBitMap oF oDlg0 SIZE 48,488 NOBORDER WHEN .F. PIXEL

@ 008, 085 SAY oObj VAR OemToAnsi( "Data Base" ) SIZE 53, 7 OF oDlg0 PIXEL ; oObj:SetFont( oFont )
@ 017, 085 MSGET oData VAR dData  WHEN .F. PICTURE "@D" SIZE 60, 10 OF oDlg0 PIXEL  ; oData:SetFont( oFont )

@ 030, 085 SAY oObj PROMPT OemToAnsi( "Usuario" ) SIZE 060, 007 OF oDlg0 PIXEL ; oObj:SetFont( oFont )
@ 039, 085 MSGET oNome VAR cNome SIZE 060, 010 OF oDlg0 PIXEL  VALID ( oNome:oGet:Assign(),;
oNome:oGet:UpdateBuffer(),lNome := ESTSEN_1( _cSenha, cNome ), lNome )
oNome:SetFont( oFont )
oNome:bGotFocus:= {|| oSenha:Enable(),If( hTemp == oSenha:hWnd, ( oCbx:Disable(),oBut1:Enable() ), ) }

@ 030, 152 SAY oObj VAR Capital( OemToAnsi( "Senha" ) ) SIZE 53, 7 OF oDlg0 PIXEL; oObj:SetFont( oFont )
@ 039, 152 MSGET oSenha VAR _cSenha  SIZE 60, 10 PASSWORD OF oDlg0 PIXEL VALID ( CursorWait(), oSenha:oGet:Assign(),;
oSenha:oGet:UpdateBuffer(),lSenha := ESTSEN_2( _cSenha, cNome ) , CursorArrow(), lSenha) //.And. ! Empty( _cSenha )

DEFINE SBUTTON oObj  FROM 126, 150 TYPE 1 ENABLE OF oDlg0 PIXEL ACTION {|| ESTSEN_ALT( cNome, cTipo, _cSenha ) }
DEFINE SBUTTON oObj  FROM 126, 182 TYPE 2 ENABLE OF oDlg0 PIXEL ACTION {|| oDLG0:End() }
ACTIVATE MSDIALOG oDlg0 CENTERED
return( lRetor )



***************

Static Function ESTSEN_1( cSen, cNom )

***************

Local aArea
Local lRETORNO := .T.

aArea := GETAREA()
// Checar senha
PswOrder( 2 )
IF ! PswSeek( cNom )
	Alert( "Nome invalido" )
	RETURN( .F. )
ENDIF

*if ! EMPTY( cSEN )
*	If ! PswName( cSen ) //senha
*		Alert( "Senha ou nome invalidos " )
*		lRETORNO := .F.
*	EndIf
*ENDIF

RESTAREA( aArea )
// Fim checar
Return lRETORNO



***************

Static Function ESTSEN_2( cSen, cNom )

***************

Local aArea
Local lRETORNO := .T.

aArea:= GETAREA()
// Checar senha
PswOrder( 2 )
IF ! PswSeek( cNom )
	Alert( "Nome invalido" )
	RETURN( .F. )
ENDIF

if ! EMPTY( cSEN )
	If ! PswName( cSen ) //senha
		Alert( "Senha ou nome invalidos " )
		lRETORNO := .F.
	EndIf
else
	Alert( "Senha ou nome invalidos " )
	lRETORNO := .F.
ENDIF

RESTAREA( aArea )
// Fim checar
Return lRETORNO



***************

Static Function ESTSEN_3( cSen )

***************

Local cArea := GETAREA()
Local lRETORNO := .T.

PswOrder( 3 )
IF ! PswSeek( cSEN )
	Alert( "Senha invalida" )
	lRETORNO := .F.
ENDIF
RESTAREA( cArea )
Return lRETORNO



***************

Static Function ESTSEN_ALT( cUsu, cOpc, cSen )

***************

Local cChaveX5 := STRZERO( VAL( cOpc), 2 ) 
Local cQuery   := ""
Local cAcess   := ""
lSenha := ESTSEN_2( cSen, cUsu )
If ! lSenha
	lRetor := .T.
	Return( lRetor )
Endif

//NÃO ESTAVA ENCONTRANDO A CHAVE PELO DBSEEK
//SX5->( DBSETORDER( 1 ) )
//SX5->(DBGOTOP())
//If SX5->( DBSEEK(xFILIAL( "SX5" ) + "ZY" + cChaveX5 ) )
//	alert("encontrou X5")
//Else
//	ALERT("NÃO ENCONTROU: " + cChaveX5)	
//Endif

cQuery := "Select * from " + RetSqlName("SX5") + " SX5 "
cQuery += " Where X5_TABELA = 'ZY' AND X5_CHAVE = '" + Alltrim(cChaveX5) + "' "
cQuery += " and X5_FILIAL = '" + xFilial("SX5") + "' and SX5.D_E_L_E_T_ = '' "  
//Memowrite("C:\TEMP\X5ZY.SQL",cQuery)
If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()
EndIf
			
TCQUERY cQuery NEW ALIAS "TMPX"
If !TMPX->(EOF())
	TMPX->(dbGoTop())
	While !TMPX->(EOF())
		cAcess := TMPX->X5_DESCRI + TMPX->X5_DESCENG + TMPX->X5_DESCSPA
		TMPX->(DBSKIP())		
	Enddo
Endif
DbSelectArea("TMPX")
DbCloseArea()

//If AllTrim( UPPER( cUSU ) ) $ SX5->X5_DESCRI + SX5->X5_DESCENG + SX5->X5_DESCSPA
If AllTrim( UPPER( cUSU ) ) $ cAcess
	oDlg0:End()
	lRetor := .T.
	Return( lRetor )
ELSE
	MSGSTOP( "Usuario sem permissao" )
ENDIF
lRetor := .F.
Return( lRetor )



*************
User Function SENHA2( cTipo )  // Retorna um array { .T. ou .F., Nome do Usuario }
*************

Private cNome   := Space( 20 )
Private _cSenha := Space( 20 )
Private cOpera  := Space( 01 )
Private hTemp   := 0
Private cBitmap := "LOGIN"
Private dData   := Ddatabase
Private lRetor  := .F.
Private aArq
Private oDlg0

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlg0 FROM 40, 30 TO 335,495 TITLE "Advanced Protheus" PIXEL OF oMainWnd
@ 000, 000 BITMAP oBmp RESNAME cBitMap oF oDlg0 SIZE 48,488 NOBORDER WHEN .F. PIXEL

@ 008, 085 SAY oObj VAR OemToAnsi( "Data Base" ) SIZE 53, 7 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 017, 085 MSGET oData VAR dData  WHEN .F. PICTURE "@D" SIZE 60, 10 OF oDlg0 PIXEL  ; oData:SetFont(oFont)

@ 030, 085 SAY oObj PROMPT OemToAnsi( "Usuario" ) SIZE 060, 007 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 039, 085 MSGET oNome VAR cNome SIZE 060, 010 OF oDlg0 PIXEL  VALID ( oNome:oGet:Assign(),;
oNome:oGet:UpdateBuffer(),lNome := ESTSEN_1(_cSenha,cNome),lNome)
oNome:SetFont(oFont)
oNome:bGotFocus:= {|| oSenha:Enable(),If(hTemp==oSenha:hWnd,(oCbx:Disable(),oBut1:Enable()),)}

@ 030, 152 SAY oObj VAR Capital( OemToAnsi( "Senha" ) ) SIZE 53, 7 OF oDlg0 PIXEL; oObj:SetFont( oFont )
@ 039, 152 MSGET oSenha VAR _cSenha  SIZE 60, 10 PASSWORD OF oDlg0 PIXEL VALID ( CursorWait(), oSenha:oGet:Assign(),;
oSenha:oGet:UpdateBuffer(),lSenha := ESTSEN_2( _cSenha, cNome ) , CursorArrow(), lSenha) //.And. !Empty(_cSenha)

DEFINE SBUTTON oObj  FROM 126, 150 TYPE 1 ENABLE OF oDlg0 PIXEL ACTION {|| ESTSEN_ALT(cNome,cTipo,_cSenha) }
DEFINE SBUTTON oObj  FROM 126, 182 TYPE 2 ENABLE OF oDlg0 PIXEL ACTION {|| lRetor:=.F.,oDLG0:End() }
ACTIVATE MSDIALOG oDlg0 CENTERED
Return( { lRetor, cNome } )



*************

User Function SENHA3( cTipo, nOpcao, cTITULO )  // Soh pede a senha e retorna o array { .T. ou .F., Nome do Usuario }

*************

Private cNome   := Space( 15 )
Private _cSenha := Space( 20 )
Private cOpera  := Space( 01 )
Private hTemp   := 0
Private cBitmap := "LOGIN"
Private dData   := Ddatabase
Private lRetor  := .F.
Private aArq
Private oDlg0

cTITULO := If( cTITULO == NIL, "Advanced Protheus", cTITULO )

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 15, 25 BOLD
DEFINE MSDIALOG oDlg0 FROM 40, 30 TO 335,495 TITLE cTITULO PIXEL OF oMainWnd
@ 000, 000 BITMAP oBmp RESNAME cBitMap oF oDlg0 SIZE 48,488 NOBORDER WHEN .F. PIXEL

@ 008, 085 SAY oObj VAR OemToAnsi( "Data Base" ) SIZE 53, 7 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 017, 085 MSGET oData VAR dData WHEN .F. PICTURE "@D" SIZE 60, 10 OF oDlg0 PIXEL ; oData:SetFont(oFont)

@ 030, 085 SAY oObj PROMPT OemToAnsi( "Usuario" ) SIZE 060, 007 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 039, 085 MSGET oNome VAR cNome WHEN .F. SIZE 060, 010 OF oDlg0 PIXEL ; oNome:SetFont(oFont)

@ 030, 152 SAY oObj VAR Capital( OemToAnsi( "Senha" ) ) SIZE 53, 7 OF oDlg0 PIXEL; oObj:SetFont( oFont )
@ 039, 152 MSGET oSenha VAR _cSenha SIZE 60, 10 PASSWORD OF oDlg0 PIXEL VALID ( CursorWait(), oSenha:oGet:Assign(),;
oSenha:oGet:UpdateBuffer(),lSenha := ESTSEN_3( _cSenha ), cNOME := If( lSENHA, PswRet()[1][2], Space( 15 ) ), oNOME:Refresh(), CursorArrow(), lSenha) //.And. !Empty(_cSenha)

If nOpcao == 2
   @ 80, 100 SAY oObj PROMPT OemToAnsi( "Reimprime Etiqueta(s) ?" ) SIZE 100, 100 OF oDlg0 PIXEL ; oObj:SetFont(oFont2) ; oObj:SetColor( CLR_HRED )
EndIf

If nOpcao == 3
   @ 70, 70 SAY oObj PROMPT OemToAnsi( "Libera fardo(s) FORA da margem de peso?" ) SIZE 150, 150 OF oDlg0 PIXEL ; oObj:SetFont(oFont2) ; oObj:SetColor( CLR_HRED )
EndIf

If nOpcao == 4
   @ 70, 70 SAY oObj PROMPT OemToAnsi( "Libera quantidade acima do estoque disponivel?" ) SIZE 150, 150 OF oDlg0 PIXEL ; oObj:SetFont(oFont2) ; oObj:SetColor( CLR_HRED )
EndIf 

If nOpcao == 5
   @ 70, 70 SAY oObj PROMPT OemToAnsi( "Libera Valor Frete ?" ) SIZE 150, 150 OF oDlg0 PIXEL ; oObj:SetFont(oFont2) ; oObj:SetColor( CLR_HRED )
EndIf

DEFINE SBUTTON oObj  FROM 126, 150 TYPE 1 ENABLE OF oDlg0 PIXEL ACTION {|| If( ! ESTSEN_ALT( cNome, cTipo, _cSenha ), ( cNOME := Space( 15 ), oSENHA:SetFocus() ), NIL ) }
DEFINE SBUTTON oObj  FROM 126, 182 TYPE 2 ENABLE OF oDlg0 PIXEL ACTION {|| oDLG0:End() }
ACTIVATE MSDIALOG oDlg0 CENTERED
Return( { lRetor, cNome } )


*************

User Function SENHAPRE_NF( cTipo, nOpcao, cTITULO )  // Soh pede a senha e retorna o array { .T. ou .F., Nome do Usuario }

*************

Private cNome   := Space( 15 )
Private _cSenha := Space( 20 )
Private cOpera  := Space( 01 )
Private hTemp   := 0
Private cBitmap := "LOGIN"
Private dData   := Ddatabase
Private lRetor  := .F.
Private aArq
Private oDlg0

cTITULO := If( cTITULO == NIL, "Advanced Protheus", cTITULO )

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 15, 25 BOLD
DEFINE MSDIALOG oDlg0 FROM 40, 30 TO 335,495 TITLE cTITULO PIXEL OF oMainWnd
@ 000, 000 BITMAP oBmp RESNAME cBitMap oF oDlg0 SIZE 48,488 NOBORDER WHEN .F. PIXEL

@ 008, 085 SAY oObj VAR OemToAnsi( "Data Base" ) SIZE 53, 7 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 017, 085 MSGET oData VAR dData WHEN .F. PICTURE "@D" SIZE 60, 10 OF oDlg0 PIXEL ; oData:SetFont(oFont)

@ 030, 085 SAY oObj PROMPT OemToAnsi( "Usuario" ) SIZE 060, 007 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 039, 085 MSGET oNome VAR cNome WHEN .F. SIZE 060, 010 OF oDlg0 PIXEL ; oNome:SetFont(oFont)

@ 030, 152 SAY oObj VAR Capital( OemToAnsi( "Senha" ) ) SIZE 53, 7 OF oDlg0 PIXEL; oObj:SetFont( oFont )
@ 039, 152 MSGET oSenha VAR _cSenha SIZE 60, 10 PASSWORD OF oDlg0 PIXEL VALID ( CursorWait(), oSenha:oGet:Assign(),;
oSenha:oGet:UpdateBuffer(),lSenha := ESTSEN_3( _cSenha ), cNOME := If( lSENHA, PswRet()[1][2], Space( 15 ) ), oNOME:Refresh(), CursorArrow(), lSenha) //.And. !Empty(_cSenha)
/*
If nOpcao == 2
   @ 80, 100 SAY oObj PROMPT OemToAnsi( "Reimprime Etiqueta(s) ?" ) SIZE 100, 100 OF oDlg0 PIXEL ; oObj:SetFont(oFont2) ; oObj:SetColor( CLR_HRED )
EndIf

If nOpcao == 3
   @ 70, 70 SAY oObj PROMPT OemToAnsi( "Libera fardo(s) FORA da margem de peso?" ) SIZE 150, 150 OF oDlg0 PIXEL ; oObj:SetFont(oFont2) ; oObj:SetColor( CLR_HRED )
EndIf

If nOpcao == 4
   @ 70, 70 SAY oObj PROMPT OemToAnsi( "Libera quantidade acima do estoque disponivel?" ) SIZE 150, 150 OF oDlg0 PIXEL ; oObj:SetFont(oFont2) ; oObj:SetColor( CLR_HRED )
EndIf
*/
DEFINE SBUTTON oObj  FROM 126, 150 TYPE 1 ENABLE OF oDlg0 PIXEL ACTION {|| If( ! ESTSEN_ALT( cNome, cTipo, _cSenha ), ( cNOME := Space( 15 ), oSENHA:SetFocus() ), NIL ) }
DEFINE SBUTTON oObj  FROM 126, 182 TYPE 2 ENABLE OF oDlg0 PIXEL ACTION {|| oDLG0:End() }
ACTIVATE MSDIALOG oDlg0 CENTERED
Return(lRetor)


*************

User Function SENHA4( cTipo, nOpcao, cTITULO )  // para alterações generalizadas no SZZ - Cad. Transp x Localidade

*************

Private cNome   := Space( 15 )
Private _cSenha := Space( 20 )
Private cOpera  := Space( 01 )
Private hTemp   := 0
Private cBitmap := "LOGIN"
Private dData   := Ddatabase
Private lRetor  := .F.
Private aArq
Private oDlg0

cTITULO := If( cTITULO == NIL, "Advanced Protheus", cTITULO )

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 15, 25 BOLD
DEFINE MSDIALOG oDlg0 FROM 40, 30 TO 335,495 TITLE cTITULO PIXEL OF oMainWnd
@ 000, 000 BITMAP oBmp RESNAME cBitMap oF oDlg0 SIZE 48,488 NOBORDER WHEN .F. PIXEL

@ 008, 085 SAY oObj VAR OemToAnsi( "Data Base" ) SIZE 53, 7 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 017, 085 MSGET oData VAR dData WHEN .F. PICTURE "@D" SIZE 60, 10 OF oDlg0 PIXEL ; oData:SetFont(oFont)

@ 030, 085 SAY oObj PROMPT OemToAnsi( "Usuario" ) SIZE 060, 007 OF oDlg0 PIXEL ; oObj:SetFont(oFont)
@ 039, 085 MSGET oNome VAR cNome WHEN .F. SIZE 060, 010 OF oDlg0 PIXEL ; oNome:SetFont(oFont)

@ 030, 152 SAY oObj VAR Capital( OemToAnsi( "Senha" ) ) SIZE 53, 7 OF oDlg0 PIXEL; oObj:SetFont( oFont )
@ 039, 152 MSGET oSenha VAR _cSenha SIZE 60, 10 PASSWORD OF oDlg0 PIXEL VALID ( CursorWait(), oSenha:oGet:Assign(),;
oSenha:oGet:UpdateBuffer(),lSenha := ESTSEN_3( _cSenha ), cNOME := If( lSENHA, PswRet()[1][2], Space( 15 ) ), oNOME:Refresh(), CursorArrow(), lSenha) //.And. !Empty(_cSenha)

DEFINE SBUTTON oObj  FROM 126, 150 TYPE 1 ENABLE OF oDlg0 PIXEL ACTION {|| If( ! ESTSEN_ALT( cNome, cTipo, _cSenha ), ( cNOME := Space( 15 ), oSENHA:SetFocus() ), NIL ) }
DEFINE SBUTTON oObj  FROM 126, 182 TYPE 2 ENABLE OF oDlg0 PIXEL ACTION {|| oDLG0:End() }
ACTIVATE MSDIALOG oDlg0 CENTERED
Return(lRetor)



