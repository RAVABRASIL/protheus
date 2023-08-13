#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ESTEST    ³ Autor ³ Manel                 ³ Data ³14/05/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Estoque          ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa de estorno de pacotes via leitura de codigo.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ESTEST()
// Variaveis Locais da Funcao
Local cEdit1	 := Space(12)
Local cEdit2
Local cEdit3
Local cEdit4
Local dEdit5
Local cEdit6
Local cEdit7
Local cEdit8

// Variaveis Private da Funcao
Private oEdit1
Private oEdit2
Private oEdit3
Private oEdit4
Private oEdit5
Private oEdit6
Private oEdit7
Private oEdit8
Private lExist := .F.
Private _oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL   := .F.
Private INCLUI   := .F.
Private ALTERA   := .F.
Private DELETA   := .F.  
Private LPERDINF := .F.

DEFINE FONT oFont1 NAME "Courier New" SIZE 0, 20 BOLD
DEFINE FONT oFont2 NAME "Arial" 			SIZE 0, 40 BOLD
DEFINE FONT oFont3 NAME "Arial" 			SIZE 0, 40 BOLD UNDERLINE

DEFINE MSDIALOG _oDlg TITLE "Estorno de Produtos" FROM C(178),C(181) TO C(665),C(960) PIXEL

	// Cria as Groups do Sistema
	@ C(003),C(004) TO C(243),C(388) LABEL "" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(035),C(032) Say "Produto: "   Size C(039),C(008) FONT oFont1 COLOR CLR_GREEN PIXEL OF _oDlg
	@ C(025),C(090) Say oEdit2 Var cEdit2 Size C(250),C(060) COLOR CLR_CYAN PIXEL OF _oDlg
	@ C(075),C(032) Say "Codigo:"		  Size C(035),C(008) FONT oFont1 COLOR CLR_GREEN PIXEL OF _oDlg
	@ C(068),C(090) Say oEdit3 Var cEdit3 Size C(100),C(060) COLOR CLR_CYAN PIXEL OF _oDlg
	@ C(115),C(032) Say "Quantidade:"     Size C(053),C(008) FONT oFont1 COLOR CLR_GREEN PIXEL OF _oDlg
	@ C(108),C(090) Say oEdit4 Var cEdit4 Size C(070),C(050) COLOR CLR_CYAN PIXEL OF _oDlg

	@ C(180),C(085) Say "( Pesado em:"    Size C(049),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(180),C(119) Say oEdit5 Var dEdit5 Size C(049),C(008) COLOR CLR_CYAN PIXEL OF _oDlg
	@ C(180),C(141) Say "As:"       			Size C(049),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(180),C(151) Say oEdit6 Var cEdit6 Size C(049),C(008) COLOR CLR_CYAN PIXEL OF _oDlg
	@ C(180),C(168) Say "Pesado por:"			Size C(049),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(180),C(199) Say oEdit7 Var cEdit7 Size C(049),C(008) COLOR CLR_CYAN PIXEL OF _oDlg
	@ C(180),C(217) Say "Liberado por:"		Size C(049),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(180),C(250) Say oEdit8 Var cEdit8 Size C(050),C(008) COLOR CLR_CYAN PIXEL OF _oDlg
	@ C(180),C(283) Say " ) "							Size C(049),C(008) COLOR CLR_BLUE PIXEL OF _oDlg

	@ C(201),C(164) MsGet oEdit1 Var cEdit1 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(221),C(148) Button "ESTORNAR"  Size C(037),C(012) PIXEL OF _oDlg ACTION { || iif( lExist, encerra( cEdit1 ), ) }
	@ C(221),C(203) Button "SAIR"  		 Size C(037),C(012) PIXEL OF _oDlg ACTION _oDlg:END()
  oEdit1:bCHANGE := { || iif( len( alltrim( cEdit1 ) ) > 11, procura( cEdit1 ), ) }
	oEdit2:SetFont( oFont2 )
	oEdit3:SetFont( oFont2 )
	oEdit4:SetFont( oFont2 )

	oBmp := TBITMAP():Create(_oDlg)
	oBmp:cName 					 := "oBmp"
	oBmp:cCaption 			 := "oBmp"
	oBmp:nLeft 					 := 020
	oBmp:nTop 					 := 100
	oBmp:nWidth 				 := 750
	oBmp:nHeight 			   := 290
	oBmp:lShowHint 			 := .F.
	oBmp:lReadOnly 			 := .F.
	oBmp:Align 					 := 0
	oBmp:lVisibleControl := .T.
	oBmp:cBmpFile 			 := "LOGO_RAVA6.bmp"
	oBmp:lStretch 			 := .T.
  oBmp:lAutoSize       := .F.

ACTIVATE MSDIALOG _oDlg CENTERED

Return(.T.)

***************

Static Function procura( cCodB )

***************
Local cQuery
cQuery := "select Z00_QUANT, Z00_DATA, Z00_HORA, Z00_NOME, Z00_USUAR , D3_COD , D3_CODBAR ,B1_DESC "
cQuery += "from   Z00020 Z00, SD3020 SD3, SB1010 SB1 "
cQuery += "where	(Z00_CODBAR = D3_CODBAR) and Z00_CODBAR = '" + cCodB + "' and B1_COD = D3_COD "
cQuery += "and Z00_FILIAL = '" + xFilial('Z00') + "' and  Z00.D_E_L_E_T_ = ' ' "
cQuery += "and  D3_FILIAL = '" + xFilial('SD3') + "' and  SD3.D_E_L_E_T_ = ' ' "
cQuery += "and  B1_FILIAL = '" + xFilial('SB1') + "' and  SB1.D_E_L_E_T_ = ' ' "
TCQUERY cQuery NEW ALIAS 'TMP'
TCSetField('TMP', 'Z00_DATA', 'D')
TMP->( dbGoTop() )

if ! TMP->( EoF() )
	ObjectMethod( oEdit2, "SetText( TMP->B1_DESC )" )
	ObjectMethod( oEdit2, "Refresh()" )
	ObjectMethod( oEdit3, "SetText( TMP->D3_CODBAR )" )
	ObjectMethod( oEdit3, "Refresh()" )
	ObjectMethod( oEdit4, "SetText( TMP->Z00_QUANT )" )
	ObjectMethod( oEdit4, "Refresh()" )
	ObjectMethod( oEdit5, "SetText( TMP->Z00_DATA )" )
	ObjectMethod( oEdit5, "Refresh()" )
	ObjectMethod( oEdit6, "SetText( TMP->Z00_HORA )" )
	ObjectMethod( oEdit6, "Refresh()" )
	ObjectMethod( oEdit7, "SetText( TMP->Z00_NOME )" )
	ObjectMethod( oEdit7, "Refresh()" )
	ObjectMethod( oEdit8, "SetText( TMP->Z00_USUAR )" )
	ObjectMethod( oEdit8, "Refresh()" )
	lExist := .T.
else
	IW_msgbox( "O codigo de barra "+cCodB+" nao foi encontrado! " )
	ObjectMethod( oEdit2, "SetText( '' )" )
	ObjectMethod( oEdit2, "Refresh()" )
	ObjectMethod( oEdit3, "SetText( '' )" )
	ObjectMethod( oEdit3, "Refresh()" )
	ObjectMethod( oEdit4, "SetText( '' )" )
	ObjectMethod( oEdit4, "Refresh()" )
	ObjectMethod( oEdit5, "SetText( '' )" )
	ObjectMethod( oEdit5, "Refresh()" )
	ObjectMethod( oEdit6, "SetText( '' )" )
	ObjectMethod( oEdit6, "Refresh()" )
	ObjectMethod( oEdit7, "SetText( '' )" )
	ObjectMethod( oEdit7, "Refresh()" )
	ObjectMethod( oEdit8, "SetText( '' )" )
	ObjectMethod( oEdit8, "Refresh()" )
	lExist := .F.
endIf
ObjectMethod( oEdit1, "SetFocus()" )
TMP->( dbCloseArea() )

Return

***************

Static Function encerra( cCodB )

***************
Local aArray := {}
aArray := U_Senha2( '08',,'O ESTORNO SO PODE SER REALIZADO MEDIANTE SENHA DE ADMINISTRADOR' )
 if aArray[1]
	if IW_MsgBox( OemToAnsi( "Voce realmente deseja estornar este produto ?" ),"Escolha", "YESNO" )

		dbSelectArea('SD3')
		SD3->( dbSetOrder( 12 ) )
		if ! SD3->( dbSeek( xFilial('SD3') + cCodB, .T. ) )
			IW_msgbox( "Impossível encontrar o codigo de barra "+ alltrim(cCodB) +"!" )
			IW_msgbox( "ESTORNO ABORTADO ! ! !" )
			Return
		endIf
		Private l250Auto := .T. // ???
		Private lIntQual := .F. // ???
		Private mv_par04 := 2 //Estorna todos os produtos da grade
		Private dDataFec := getMV('MV_ULMES')
		PRIVATE cCusMed  := soma1(GetMv("mv_CusMed"))
		PRIVATE lProdAut := GetMv("MV_PRODAUT")
		PRIVATE LCRIAHEADER := .F.
		PRIVATE CLOTEEST
		PRIVATE cArquivo
		PRIVATE nHdlPrv
		A250Estorn('SD3', SD3->( recno() ), 5)
		SD3->( dbCloseArea() )
	else
		IW_msgbox( "ESTORNO ABORTADO ! ! !" )
		ObjectMethod( oEdit2, "SetText( '' )" )
		ObjectMethod( oEdit2, "Refresh()" )
		ObjectMethod( oEdit3, "SetText( '' )" )
		ObjectMethod( oEdit3, "Refresh()" )
		ObjectMethod( oEdit4, "SetText( '' )" )
		ObjectMethod( oEdit4, "Refresh()" )
		ObjectMethod( oEdit5, "SetText( '' )" )
		ObjectMethod( oEdit5, "Refresh()" )
		ObjectMethod( oEdit6, "SetText( '' )" )
		ObjectMethod( oEdit6, "Refresh()" )
		ObjectMethod( oEdit7, "SetText( '' )" )
		ObjectMethod( oEdit7, "Refresh()" )
		ObjectMethod( oEdit8, "SetText( '' )" )
		ObjectMethod( oEdit8, "Refresh()" )
	endIf
else
	IW_msgbox( "VOCE NAO TEM PERMISSAO PARA ESTORNAR PRODUTOS!" )
endIf
ObjectMethod( oEdit1, "SetFocus()" )
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para tema "Flat"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)
