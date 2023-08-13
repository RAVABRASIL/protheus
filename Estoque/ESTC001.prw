#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :29/04/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTC001()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cCodbar    := Space(12)
Private nCount     := 0
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oSay2","oSay3","oGet1","oSBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-32,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 218,350,577,1045,"Saída de Sacos-capa",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 000,002,175,343,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay2      := TSay():New( 023,102,{||""},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,236,016)
oSay4      := TSay():New( 055,102,{||""},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,236,016)
oSay6      := TSay():New( 083,102,{||""},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,236,016)
oGet1      := TGet():New( 136,143,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodbar",,)
oGet1:bChange := {| | leCodBar(cCodbar),ObjectMethod( oGet1, "SetFocus()" ),ObjectMethod( oGet1,  "Refresh()" ) }

oGet1:bSetGet := {|u| If(PCount()>0,cCodbar:=u,cCodbar)}

//oSBtn1     := SButton():New( 164,316,2,,oGrp1,,"", )
oSay1      := TSay():New( 023,016,{||"Código:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,016)
oSay3      := TSay():New( 055,016,{||"Descr.:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,071,016)
oSay5      := TSay():New( 083,016,{||"Quant.:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,071,016)
oBtn1      := TButton():New( 156,154,"Sair",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oSay7      := TSay():New( 112,016,{||"0"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,133,012)

oDlg1:Activate(,,,.T.)

Return

***************

Static Function leCodBar( cCod )

***************
Local cQuery := ""
Local lRet   := .F.
lMsErroAuto  := .F.
cQuery := "select Z00_QUANT, Z00_CODIGO from "+retSqlName('Z00')+" where Z00_CODBAR = '"+cCod+"' and Z00_BAIXAC != 'S' and D_E_L_E_T_ != '*' "
cQuery += "and Z00_FILIAL = '"+xFilial("Z00")+"' "
TCQUERY cQuery NEW ALIAS "_TMPZ"
_TMPZ->( dbGoTop() )
oSay2:nClrText := CLR_BLACK
oSay4:nClrText := CLR_BLACK
oSay6:nClrText := CLR_BLACK
Z00->( dbSetOrder(7) )
if ! _TMPZ->( EoF() )
	oSay2:SetText( _TMPZ->Z00_CODIGO )
	oSay2:Refresh()
	oSay4:SetText( posicione("SB1",1,xFilial("SB1") + _TMPZ->Z00_CODIGO, "B1_DESC") )
	oSay4:Refresh()	
	oSay6:SetText( transform(_TMPZ->Z00_QUANT,"@E 999,999.99") )	
	oSay6:Refresh()
	MsAguarde( { || Sleep(2000) }, "Aguarde...", "Procurando fardo..." )
	if !msgYesNo("Deseja baixar o produto do estoque ?")
		_TMPZ->(dbCloseArea())
		Return
	endIf
	aMATRIZ     := { { "D3_TM",      "503",					NIL },;
	                 { "D3_FILIAL",  xFilial( "SD3" ),		NIL },;
	                 { "D3_LOCAL",	 "01",					NIL },;
	                 { "D3_COD",     _TMPZ->Z00_CODIGO,		NIL },;
	                 { "D3_QUANT",   _TMPZ->Z00_QUANT/1000,	NIL },;
	                 { "D3_EMISSAO", dDATABASE,				NIL },;
	                 { "D3_CODBAR" , cCod, 					NIL },;
	                 { "D3_OBS",	 "Uso de Saco-capa",	NIL } }
	Begin Transaction
		MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )	
		IF lMsErroAuto .or. !Z00->( dbSeek( xFilial("Z00") + cCod, .F. ) )
			DisarmTransaction()
		else
			Z00->( dbSeek( xFilial("Z00") + cCod, .F. ) )
		 	Reclock( "Z00", .F. )
			Z00->Z00_BAIXAC := "S"
			Z00->( MsUnlock() )
		Endif
	End Transaction
	IF lMsErroAuto
		MsgAlert("ERRO NA OPERAÇÃO")
	else
		oSay2:nClrText := CLR_RED
		oSay4:nClrText := CLR_RED
		oSay6:nClrText := CLR_RED
		nCount++
		oSay7:SetText( str(nCount) )
	EndIf
else
	msgAlert("Código de barras já lido ou inexistente!")
endIF
_TMPZ->( dbCloseArea() )
Return