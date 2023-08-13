#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATRTAB   º Autor Emmanuel³ AP7 IDE    º Data ³  18/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de geração impressa de tabelas de venda para os   º±±
±±º          ³ representantes.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATRTAB()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Tabela de venda"
Local cPict          := ""
Local titulo         := "Tabela de venda"
Local nLin           := 80
Local Cabec1         := "Impressão das tabelas de venda."
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private tamanho      := "P"
Private nomeprog     := "FATRTAB" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private wnrel        := "FATRTAB" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

oFont01 	:= TFont():New('Arial',25,25,.F.,.T.,5,.T.,5,.T.,.F.)
oFont02 	:= TFont():New('Arial',08,08,.F.,.T.,5,.T.,5,.T.,.F.)
oFont03 	:= TFont():New('Arial',10,10,.T.,.T.,5,.T.,5,.T.,.F.)
//DEFINE FONT oFont01 NAME "Courier New"     SIZE 0, 19 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| Pergunte("FATRTB", .T.),RunReport() },Titulo)

Return


***************

Static Function RunReport()

***************

cQuery := "select SX5.X5_DESCRI, SX6.X5_DESCRI capacidade, SB5.B5_COD, DA0.DA0_DESCRI, "
cQuery += "DA0.DA0_DATDE, DA1.DA1_PRCVEN, SB5.B5_COMPR2, SB5.B5_LARG2 "
cQuery += "from "+ RetSqlName("SX5") +" SX5, "+ RetSqlName("SB5") + " SB5, "+ RetSqlName("DA0")+" DA0, "
cQuery += " "+ RetSqlName("DA1") +" DA1, "+ RetSqlName("SX5") +" SX6 "
cQuery += "where  DA0.DA0_CODTAB = '" + alltrim(mv_par01) + "' and DA0.DA0_CODTAB = DA1.DA1_CODTAB and SB5.B5_COD = DA1.DA1_CODPRO "
cQuery += "and SX5.X5_TABELA = '70'  and SX5.X5_CHAVE = SB5.B5_COR and SX6.X5_TABELA = 'Z0' and SX6.X5_CHAVE = SB5.B5_CAPACID "
cQuery += "and SX6.X5_FILIAL = '"+ xFilial("SX5") +"' and SX5.X5_FILIAL  = '"+ xFilial("SX5") +"' "
cQuery += "and SB5.B5_FILIAL = '01' and DA0.DA0_FILIAL = '01' and DA1.DA1_FILIAL = '01' "
cQuery += "and SX6.D_E_L_E_T_ != '*' and SX5.D_E_L_E_T_ != '*' and SB5.D_E_L_E_T_ != '*' and DA0.D_E_L_E_T_ != '*' and DA1.D_E_L_E_T_ != '*' "
cQuery += "order by SB5.B5_COMPR2, SB5.B5_LARG2 "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "DA0_DATDE", "D")
TMP->( DbGoTop() )

oPrt := TMSPrinter():new("Tabela de Venda")
oPrt:SetPortrait()

nX := 950; nZ := 850; nLinha := 880; nCount := 0

aRet := TransfProd()
cabec()

Do While !TMP->( EoF() )

	nY := 100; nK := 409

	oPrt:Box(nX, nY, nZ, nK )
	oPrt:Say(nLinha, 0250, alltrim(TMP->capacidade), oFont02, 300, , , 2)

	oPrt:Box(nX, nY := nK + 2, nZ, nK := nY + 309)
	oPrt:Say(nLinha, 0550, "????", oFont02, 300, , , 2)

	oPrt:Box(nX, nY := nK + 2, nZ, nK := nY + 309)
	oPrt:Say(nLinha, 0860, "??????????", oFont02, 300, , , 2)

	oPrt:Box(nX, nY := nK + 2, nZ, nK := nY + 309)
	oPrt:Say(nLinha, 1190, alltrim(TMP->X5_DESCRI)+"/"+ alltrim(TMP->B5_COD), oFont02, 300, , , 2)

	oPrt:Box(nX, nY := nK + 2, nZ, nK := nY + 309)
  oPrt:Say(nLinha, 1480, alltrim(str(TMP->B5_LARG2))+" x "+alltrim(str(TMP->B5_COMPR2)), oFont02, 300, , , 2)

	oPrt:Box(nX, nY := nK + 2, nZ, nK := nY + 309)
  oPrt:Say(nLinha, 1770, "R$ "+alltrim(str(TMP->DA1_PRCVEN)), oFont02, 300, , , 2)

	oPrt:Box(nX, nY := nK + 2, nZ, nK := nY + 305)
	oPrt:Say(nLinha, 2100, "??????????", oFont02, 300, , , 2)

	nCount++

	If nCount == 20
		obs()
	  cabec()
		TMP->( DbSkip() )
	Else
		tempZ := nZ; tempX := nX
		nZ := nX; nX += 100; nLinha += 100
		TMP->( DbSkip() )
	EndIf

EndDo

obs()
TMP->( DbCloseArea() )
oPrt:Preview()

Return Nil

***************

Static Function cabec()

***************

	nX := 950; nZ := 850; nLinha := 880; nCount := 0

	oPrt:StartPage()
	oPrt:Box(500,100,400,2270)
			 //linha,coluna
  oPrt:Say(400,1150,"TABELA DE PREÇO",oFont01,300,,,2)
	oPrt:Box(750,100,510,2270)
  oPrt:Say(550,760,TMP->DA0_DESCRI, oFont03)
  oPrt:Say(600,760,dtoc(TMP->DA0_DATDE),  oFont03)

	oPrt:Box(840,100,760,409)
	oPrt:Say(785,250,"CAPACIDADE",oFont03,300,,,2)
	oPrt:Box(840,411,760,720)
  oPrt:Say(785,555,"UTILIZAÇÃO",oFont03,300,,,2)
	oPrt:Box(840,722,760,1031)
	oPrt:Say(785,870,"TIPO",oFont03,300,,,2)
	oPrt:Box(840,1033,760,1342)
  oPrt:Say(785,1180,"COR/CÓDIGO",oFont03,300,,,2)
	oPrt:Box(840,1344,760,1653)
	oPrt:Say(785,1490,"MEDIDAS",oFont03,300,,,2)
	oPrt:Box(840,1655,760,1964)
  oPrt:Say(785,1800,"PREÇO/FARDO",oFont03,300,,,2)
	oPrt:Box(840,1966,760,2270)
	oPrt:Say(785,2120,"EMBALAGEM",oFont03,300,,,2)

Return Nil

***************

Static Function obs()

***************

  Local nTY
	//nZ := nX; nX += 100;
	if TMP->( EoF() )
		nZ := tempX + 10; nX += 400
	else
		nZ := nX + 10; nX += 400
	endif
	oPrt:Box(nX,100,nZ,2270)
  //2900
  oPrt:Say( nTY := nZ + 40, 500, "Condição de Pagamento: ",oFont03,300,,,2)
  oPrt:Say( nTY, 800,  alltrim(aRet[1][1])+" dia(s)",oFont03,300,,,2)

  oPrt:Say( nTY += 40, 500, "Desconto À Vista: ",oFont03,300,,,2)
  oPrt:Say( nTY, 800,  alltrim(aRet[1][2])+"%",oFont03,300,,,2)

  oPrt:Say( nTY += 40, 500, "Frete: ",oFont03,300,,,2)
  oPrt:Say( nTY, 800,  alltrim(aRet[1][3]),oFont03,300,,,2)

  oPrt:Say( nTY += 40, 500, "IPI: ",oFont03,300,,,2)
  oPrt:Say( nTY, 800,  alltrim(aRet[1][4])+"%",oFont03,300,,,2)

  oPrt:Say( nTY += 40, 500, "Pedido Mínimo: ",oFont03,300,,,2)
  oPrt:Say( nTY, 1030,"Para Capital: R$ "+alltrim(aRet[1][5])+"  Para o Interior: R$ " + alltrim(aRet[1][6]),oFont03,300,,,2)

  oPrt:Say( nTY += 40, 500, "ICMS: ",oFont03,300,,,2)
  oPrt:Say( nTY, 800, alltrim(aRet[1][7])+"%",oFont03,300,,,2)

  oPrt:Say( nTY += 40, 500, "Prazo de Entrega: ",oFont03,300,,,2)
  oPrt:Say( nTY, 1030,"Para Capital: "+alltrim(aRet[1][8])+" dia(s)  Para o Interior: " + alltrim(aRet[1][9])+ " dia(s)",oFont03,300,,,2)
	oPrt:EndPage()

Return Nil


***************

Static Function TransfProd()

***************
// Variaveis Locais da Funcao
 Local aRet := {}
 Local aComboBx1 := {"CIF","FOB"}
 Local aComboBx2 := {"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23",;
										 "24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44",;
										 "45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60"}
 Local aComboBx3 := {"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23",;
										 "24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44",;
										 "45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60"}
 Local cComboBx1
 Local cComboBx2
 Local cComboBx3
 Local oEdit1
 Local oEdit2
 Local oEdit4
 Local oEdit5
 Local oEdit6
 Local oEdit7
 Local cEdit1	 := Space(25)
 Local cEdit2	 := Space(25)
 Local cEdit4	 := Space(25)
 Local cEdit5	 := Space(25)
 Local cEdit6	 := Space(25)
 Local cEdit7	 := Space(25)

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
																								 //C(183),C(200) TO C(489),C(562)
DEFINE MSDIALOG _oDlg TITLE " Observações " FROM C(150),C(200) TO C(489),C(562) PIXEL

	// Cria as Groups do Sistema
	//C(001),C(003) TO C(156),C(180)
	@ C(001),C(003) TO C(170),C(180) LABEL "" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(016),C(078) MsGet oEdit1 Var cEdit1 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(018),C(012) Say "Condição de Pagamento :" Size C(063),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(036),C(078) MsGet oEdit2 Var cEdit2 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(038),C(012) Say "Desconto À Vista :" Size C(046),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(055),C(078) ComboBox cComboBx1 Items aComboBx1 Size C(062),C(010) PIXEL OF _oDlg
	@ C(059),C(012) Say "Frete :" Size C(017),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(075),C(078) MsGet oEdit4 Var cEdit4 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(079),C(012) Say "IPI :" Size C(011),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(089),C(118) Say "Interiror" Size C(019),C(006) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(091),C(082) Say "Capital" Size C(018),C(007) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(098),C(078) MsGet oEdit5 Var cEdit5 Size C(028),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(098),C(116) MsGet oEdit6 Var cEdit6 Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(099),C(012) Say "Pedido Mínimo :" Size C(040),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(114),C(080) MsGet oEdit7 Var cEdit7 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(119),C(012) Say "ICMS :" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(130),C(074) Say "Capital" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(130),C(123) Say "Interior" Size C(018),C(007) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(139),C(012) Say "Prazo P/ Entrega :" Size C(046),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(139),C(067) ComboBox cComboBx2 Items aComboBx2 Size C(035),C(010) PIXEL OF _oDlg
	@ C(139),C(116) ComboBox cComboBx3 Items aComboBx3 Size C(035),C(010) PIXEL OF _oDlg
	@ C(153),C(075) Button "Gerar" Size C(037),C(012) PIXEL OF _oDlg ACTION   { || aAdd(aRet,{cEdit1,cEdit2,cComboBx1,cEdit4,;
																																														cEdit5,cEdit6,cEdit7,cComboBx2,cComboBx3}),;
																																										      	_oDlg:End() }
ACTIVATE MSDIALOG _oDlg CENTERED

Return aRet

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
