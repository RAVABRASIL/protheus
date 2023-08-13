#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
//#include  "Tbiconn.ch "


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :ESTR014 ³ Autor :Gustavo Costa           ³ Data :09/02/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Rotina de conferência das notas fiscais de saída.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTR016()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cCliente   	:= Space(50)
Private cCodBarNF  	:= Space(45)
Private cCodBarPro 	:= Space(13)
Private cNunNF     	:= Space(9)
Private cSerieNF    	:= Space(3)
Private coTbl1
Private aCampos		:= {}
Private aProdutos		:= {}
Private cExpedidor	:= ""
Private cSeparador	:= ""

_cMVSepa:=SUPERGETMV("RV_USSEPA",,"11100019/11100272/11129045/11156827/11101082/11101171")  // CRACHA DE QUEM E SEPARADOR 


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oDlg1","oPanel1","oPanel2","oGet1","oGet2","oSay1","oSay2","oGet3","oGet4")
SetPrvt("oBrw1","oBtn2","oBtn3","oBtn4","oSay3","oSay4")
SetPrvt("oFontLista","oDlgLista","oPanelLista","oLBoxLista","oSayLista")

//*****************************
//Cria a tabela temporaria
//*****************************
oTbl1()

AADD(aCampos,{"ITEM"  			,"","Item"       	,""  	})					//Flag marcacao
AADD(aCampos,{"CODIGO" 			,"","Codigo"  	,""  	})					//Data PDCessa
AADD(aCampos,{"DESC" 			,"","Produto"		,""  	})					//Documento
AADD(aCampos,{"UM" 				,"","UM"			,""  	})					//Documento
AADD(aCampos,{"QUANT"			,"","Quant." 		,"@E 999,999.99"		})					//Total
//AADD(aCampos,{"VALFRET"		,"","Frete" 	,"@E 999,999,999.99"		})					//Frete

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Calibri",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 175,260,556,1161,"Expedição - Conferência da Nota Fiscal de Saída",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,449,052,.T.,.F. )
oPanel2    := TPanel():New( 162,000,"",oDlg1,,.F.,.F.,,,448,026,.T.,.F. )

oSay1      := TSay():New( 002,008,{||"Codigo de barras da nota fiscal"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,010)
oGet1      := TGet():New( 013,008,,oPanel1,224,011,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodBarNF",,)
oGet1:bChange := {||fNotaFiscal(Alltrim(cCodBarNF))}
oGet1:bValid := {|| !Empty(cCodBarNF) }
oGet1:bSetGet := {|u| If(PCount()>0,cCodBarNF:=u,cCodBarNF)}

oSay2      := TSay():New( 012,333,{||"Crachá/Produto:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,085,008)
oGet2      := TGet():New( 024,333,,oPanel1,112,018,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodBarProd",,)
oGet2:bSetGet := {|u| If(PCount()>0,cCodBarProd:=u,cCodBarProd)}
oGet2:bValid := {|| fIncluiProd(Alltrim(cCodBarProd)) }
//oGet2:bChange := {|| fIncluiProd(cCodBarProd) }

oSay3      := TSay():New( 026,008,{||"Nota Fiscal"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,010)
oGet3      := TGet():New( 036,008,,oPanel1,052,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNunNF",,)
oGet3:bSetGet := {|u| If(PCount()>0,cNunNF:=u,cNunNF)}
oGet3:Disable()	

oSay4      := TSay():New( 026,063,{||"Cliente"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,010)
oGet4      := TGet():New( 036,063,,oPanel1,169,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCliente",,)
oGet4:bSetGet := {|u| If(PCount()>0,cCliente:=u,cCliente)}
oGet4:Disable()	

oBtn1      := TButton():New( 003,004,"Listar Todos",oPanel2,,052,017,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {|| fListaTodos() }

DbSelectArea("XMP")
oBrw1      := MsSelect():New( "XMP","","",aCampos,.F.,,{052,000,163,449},,, oDlg1 ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK
oBtn2      := TButton():New( 003,313,"Cancelar",oPanel2,,056,017,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {|| oDlg1:end() }

oBtn3      := TButton():New( 003,385,"Confirmar",oPanel2,,056,017,,,,.T.,,"",,,,.F. )
oBtn3:bAction := {|| fGravaOK() }
oBtn3:Disable()

oBtn4      := TButton():New( 003,072,"Limpar Tudo",oPanel2,,057,017,,,,.T.,,"",,,,.F. )
oBtn4:bAction := {|| fLimpaTela() }
oBtn4:Disable()

oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: XMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"ITEM"  	,"C",003,000} )
Aadd( aFds , {"CODIGO"  	,"C",015,000} )
Aadd( aFds , {"DESC"  	,"C",060,000} )
Aadd( aFds , {"UM"  		,"C",002,000} )
Aadd( aFds , {"QUANTNF" 	,"N",012,002} )
Aadd( aFds , {"QUANT"  	,"N",012,002} )

//coTbl1 := CriaTrab( aFds, .T. )
//Use (coTbl1) Alias XMP New Exclusive

cNomeArq := CriaTrab(aFds,.T.)
dbUseArea( .T.,, cNomeArq, "XMP", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("XMP",cNomeArq,"CODIGO",,,OemToAnsi("Selecionando Registros..."))  //

Return 


//------------------------------------------------------------------------------------------
/*
Pega as informações da Nota Fiscal.

@author    Gustavo Costa
@version   1.xx
@since     09/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fNotaFiscal(cNum)

local lRet		:= .F.
Local nTotal	:= 0
Local cQuery	:= ""
Local nSaldo	:= 0


cQuery := " SELECT D2_ITEM, D2_COD, B5_COD, B1_DESC, B1_UM, D2_QUANT, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, B5_QTDFIM, B5_QE1, B5_QE2, B5_QTDEN FROM " + RetSqlName( "SF2" ) + " F2 "
cQuery += " INNER JOIN " + RetSqlName( "SD2" ) + " D2 "
cQuery += " ON F2_FILIAL = D2_FILIAL "
cQuery += " AND F2_DOC = D2_DOC "
cQuery += " AND F2_SERIE = D2_SERIE "
cQuery += " AND F2_TIPO = D2_TIPO "
cQuery += " AND F2_CLIENTE = D2_CLIENTE "
cQuery += " AND F2_LOJA = D2_LOJA "
cQuery += " INNER JOIN " + RetSqlName( "SB1" ) + " B1 " 
// Nao Tava Considerando Produto Rolo 
//cQuery += " ON CASE WHEN LEN(LTRIM(RTRIM(D2_COD))) = 6 THEN D2_COD ELSE SUBSTRING(D2_COD,1,1) + SUBSTRING(D2_COD,3,3) + SUBSTRING(D2_COD,7,2) END = B1_COD "
//cQuery += " ON case when len(D2_COD) >= 8 then case when ( SUBSTRING( D2_COD, 4, 1 ) IN( 'R','D')) or ( SUBSTRING( D2_COD, 5, 1 ) IN( 'R','D')) then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) end else D2_COD END = B1_COD  "
/// PROBLEMA COM OS CODIGOS HAMPER EX: CAD020 - CDAD0620 

cQuery += " ON  case when len(D2_COD) >= 8 then case when len(D2_COD) = 8 then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) end else D2_COD END = B1_COD  "
cQuery += " INNER JOIN " + RetSqlName( "SB5" ) + " B5 "

// Nao Tava Considerando Produto Rolo 
//cQuery += " ON CASE WHEN LEN(LTRIM(RTRIM(D2_COD))) = 6 THEN D2_COD ELSE SUBSTRING(D2_COD,1,1) + SUBSTRING(D2_COD,3,3) + SUBSTRING(D2_COD,7,2) END = B5_COD "
//cQuery += " ON case when len(D2_COD) >= 8 then case when ( SUBSTRING( D2_COD, 4, 1 ) IN( 'R','D') ) or ( SUBSTRING( D2_COD, 5, 1 ) IN( 'R','D')) then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) end else D2_COD END = B5_COD  "
/// PROBLEMA COM OS CODIGOS HAMPER EX: CAD020 - CDAD0620 
cQuery += " ON case when len(D2_COD) >= 8 then case when len(D2_COD) = 8 then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) end else D2_COD END   = B5_COD  "
cQuery += " WHERE F2.D_E_L_E_T_ <> '*' "
cQuery += " AND D2.D_E_L_E_T_ <> '*' "
cQuery += " AND B1.D_E_L_E_T_ <> '*' "
cQuery += " AND B5.D_E_L_E_T_ <> '*' "
cQuery += " AND F2_CHVNFE = '" + cNum + "' "

If Select("GLO") > 0
	DbSelectArea("GLO")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "GLO"
dbselectArea("GLO")
dbGoTop("GLO")

If Empty(GLO->D2_ITEM)

	MsgAlert("NOTA FISCAL NÃO ENCONTRADA!!!!")
	cCodBarNF	:= Space(45)
	ObjectMethod( oGet1, "SetFocus()" ) //Codigo de barras do produto	
	oDlg1:Refresh()
	DbSelectArea("GLO")
	DbCloseArea()
	Return .F.

EndIf

dbSelectArea("ZZ9")
dbSetOrder(1)
If ZZ9->(Dbseek(xFilial("ZZ9") + GLO->F2_DOC + GLO->F2_SERIE))

	MsgAlert("NOTA FISCAL JÁ EXPEDIDA!!!!")
	cCodBarNF	:= Space(45)
	ObjectMethod( oGet1, "SetFocus()" ) //Codigo de barras do produto	
	oDlg1:Refresh()
	DbSelectArea("GLO")
	DbCloseArea()
	Return .F.
	
EndIf

dbselectArea("GLO")

cNunNF		:= GLO->F2_DOC
cSerieNF	:= GLO->F2_SERIE
cCliente	:= Posicione("SA1",1,xFilial("SA1") + GLO->F2_CLIENTE + GLO->F2_LOJA, "A1_NOME")

While GLO->(!EOF())
	
	RecLock("XMP",.T.)
	
	XMP->ITEM			:= GLO->D2_ITEM
	XMP->CODIGO			:= GLO->B5_COD
	XMP->DESC			:= GLO->B1_DESC
	XMP->UM				:= GLO->B1_UM
	XMP->QUANTNF		:= IIF(GLO->B1_UM == "FD",GLO->D2_QUANT / (GLO->B5_QTDFIM/GLO->B5_QTDEN) , (GLO->D2_QUANT * 1000)/GLO->B5_QTDFIM )
	XMP->QUANT			:= 0
	
	
	XMP->(MsUnLock())

	GLO->(dbSkip())
		
EndDo
	
dbSelectArea("XMP")
XMP->(dbGoTop())

oBtn3:Enable() 	//Confirmar
oBtn4:Enable()	//Limpar Tudo
oGet1:Disable()	//Codigo de barras na NF
ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto
oDlg1:Refresh()
oBrw1:oBrowse:Refresh()


Return

//------------------------------------------------------------------------------------------
/*
Pega o codigo do produto e verifica se esta na lista dos produtos da NF.

@author    Gustavo Costa
@version   1.xx
@since     10/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fIncluiProd(cCB)

Local nTotal			:= 0
Local cQuery			:= ""
Local nQuant			:= 0

If Empty(cCB)
	
	Return .T.
	
EndIf

//Força o primeiro codigo ser um crachá
If Empty(cSeparador)
	
	If Len(Alltrim(cCB)) = 12
		
		MsgAlert("INFORME O CRACHÁ PRIMEIRO!!!!")
		cCodBarProd	:= Space(13)
		ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
		oDlg1:Refresh()
		Return .F.
	
	Else
				
		cSeparador	:= fPegaSep(cCB)
		
		If   Empty(cSeparador)
	
			MsgAlert("CRACHÁ NÃO LOCALIZADO, PROCURE O RH!!!!")
			cCodBarProd	:= Space(13)
			ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
			oDlg1:Refresh()
			Return .F.
		
		ELSE
		
			IF ! ALLTRIM(SubStr(cCB,2,10)) $  _cMVSepa // CRACHA DE QUEM E SEPARADOR 
    
	            MsgAlert("INFORME O CRACHÁ DE UM SEPARADOR !!!!")
				cCodBarProd	:= Space(13)
				ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
				oDlg1:Refresh()
				Return .F.
	

            ENDIF

		
		
		EndIf
		
	EndIf

EndIf

// se o codigo informado for diferente de 12, é um crachá
If Len(Alltrim(cCB)) <> 12
	
	cSeparador	:= fPegaSep(cCB)

	If Empty(cSeparador)

		MsgAlert("CRACHÁ NÃO LOCALIZADO, PROCURE O RH!!!!")
		cCodBarProd	:= Space(13)
		ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
		oDlg1:Refresh()
		Return .F.
		
	ELSE
		
		IF ! ALLTRIM(SubStr(cCB,2,10)) $ _cMVSepa // CRACHA DE QUEM E SEPARADOR 
    
	          MsgAlert("INFORME O CRACHÁ DE UM SEPARADOR !!!!")
		  	  cCodBarProd	:= Space(13)
			  ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
			  oDlg1:Refresh()
			  Return .F.
	

        ENDIF

	
	EndIf

	cCodBarProd	:= Space(13)
	ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
	oDlg1:Refresh()
	Return .F.

EndIf

cQuery := " SELECT Z00_CODIGO FROM " + RetSqlName( "Z00" ) + " Z "
cQuery += " WHERE Z.D_E_L_E_T_ <> '*' "
cQuery += " AND Z00_SEQ = '" + Substr(cCB,7,6) + "' "

If Select("XIT") > 0
	DbSelectArea("XIT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XIT"

dbselectArea("XIT")
dbGoTop("XIT")

If Empty(XIT->Z00_CODIGO)

	MsgAlert("CÓDIGO DE BARRAS NÃO ENCONTRADO!!!!")
	cCodBarProd	:= Space(13)
	ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
	oDlg1:Refresh()
	Return .F.

Else
	
	dbSelectArea("XMP")
	
	If dbseek(XIT->Z00_CODIGO)
	
		If XMP->QUANT + 1 > XMP->QUANTNF
		
			AADD(aProdutos, {cCB, cUserName, cSeparador, "M", cCB})
			MsgAlert("QUANTIDADE DE PRODUTO MAIOR QUE A NOTA FISCAL!!!!")
			cCodBarProd	:= Space(13)
			ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
			oDlg1:Refresh()
			Return .F.
		
		EndIf
		
		nItem	:= aScan(aProdutos, {|x| x[1] == cCB} )
		
		IF nItem = 0
		
			AADD(aProdutos, {cCB, cUserName, cSeparador, "C", cCB})
		
			RecLock("XMP",.F.)
		
			XMP->QUANT		:= XMP->QUANT + 1
		
			XMP->(MsUnLock())
			XMP->(dbGoTop())

		Else
		
			AADD(aProdutos, {cCB, cUserName, cSeparador, "D", cCB})
			
			MsgAlert("PRODUTO JÁ REGISTRADO!!!!")
			cCodBarProd	:= Space(13)
			ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
			oDlg1:Refresh()
			Return .F.
		
		EndIf

	Else
	
		AADD(aProdutos, {cCB, cUserName, cSeparador, "E", cCB})
		MsgAlert("ESTE PRODUTO NÃO FAZ PARTE DESTA NOTA FISCAL!!!!!")
		cCodBarProd	:= Space(13)
		ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
		oDlg1:Refresh()
		Return .F.
	
	EndIf

EndIf

oGet1:Disable()	//Codigo de barras na NF
cCodBarProd	:= Space(13)
ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto
oDlg1:Refresh()
oBrw1:oBrowse:Refresh()

XIT->(DbCloseArea("XIT"))

Return .T.


***************

Static Function fLimpaTela()

***************

//Limpa as variaveis
oGet1:Enable()
oBtn3:Disable() 	//Confirmar
oBtn4:Disable()	//Limpar Tudo

cCodBarNF		:= Space(45)
cCodBarProd	:= Space(13)
cNunNF			:= Space(9)
cSerieNF		:= Space(3)
cCliente  		:= Space(50)
aProdutos		:= {}
cSeparador		:= ""

oDlg1:Refresh()
ObjectMethod( oGet1, "SetFocus()" )  // Codigo de barras NF

dbSelectArea("XMP")
XMP->(dbGoTop())

While XMP->(!EOF())

	RecLock("XMP",.F.)
	
	dbDelete()
	
	XMP->(MsUnLock())
	
	XMP->(dbSkip())

EndDo

Return 


//------------------------------------------------------------------------------------------
/*
Verifica as quantidades e validações para gravar o processo de expediç.

@author    Gustavo Costa
@version   1.xx
@since     11/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fGravaOK()

Local lFaltaProd	:= .F.
Local cJustif		:= ""
Local aJusti		:= {}

XMP->(dbGoTop())

//Verifica se a contagem está OK
While XMP->(!EOF())

	IF XMP->QUANTNF <> XMP->QUANT
	
		MsgAlert("FALTA DO PRODUTO - " + XMP->DESC )
		lFaltaProd	:= .T.
		AADD(aJusti, XMP->CODIGO)
	
	EndIf
	XMP->(dbSkip())

EndDo

If lFaltaProd

		If MsgYesNo(OemToAnsi("Confirma mesmo faltando produto(s)?"),OemToAnsi("Confirmação"))
		
			aUSUARIO := U_senha2( "13", 1 )
			If ! aUSUARIO[ 1 ]

				XMP->(dbGoTop())
				MsgAlert("Usuário não autorizado!")
				Return NIL
			
			Else
				
				cJustif	:= fOBS()
			
			EndIf
		
		Else
		
			XMP->(dbGoTop())
			cCodBarProd	:= Space(13)
			ObjectMethod( oGet2, "SetFocus()" ) //Codigo de barras do produto	
			oDlg1:Refresh()
			Return
		
		Endif
		
EndIf

For _i := 1 To len(aProdutos)

	dbSelectArea("ZZ9")
	RecLock("ZZ9",.T.)
	
	ZZ9->ZZ9_FILIAL		:= xFilial("ZZ9")
	ZZ9->ZZ9_DOC			:= cNunNF
	ZZ9->ZZ9_SERIE		:= cSerieNF
	ZZ9->ZZ9_DATA			:= date() 
	ZZ9->ZZ9_HORA			:= Time() 
	ZZ9->ZZ9_EXPEDI		:= aProdutos[_i][2] 
	ZZ9->ZZ9_SEPARA		:= aProdutos[_i][3] 
	ZZ9->ZZ9_STATUS		:= aProdutos[_i][4] 
	ZZ9->ZZ9_PRODOP		:= aProdutos[_i][5] 
	//MsgAlert(cJustif)
	ZZ9->(MsUnLock())
	
Next _i

if  len(aJusti)>0

	For _j := 1 To len(aJusti)
	
		dbSelectArea("ZZA")
		RecLock("ZZA",.T.)
		
		ZZA->ZZA_FILIAL		:= xFilial("ZZA")
		ZZA->ZZA_DOC			:= cNunNF
		ZZA->ZZA_SERIE		:= cSerieNF
		ZZA->ZZA_PROD			:= aJusti[_j]
		ZZA->ZZA_JUSTIF		:= cJustif
	
		ZZA->(MsUnLock())
		
	Next _j

else

	if !empty(cJustif) // chamou a tela de senha , justificou nota como por exemplo so DANfe.
	   
	   dbSelectArea("ZZA")
	   RecLock("ZZA",.T.)
		
		ZZA->ZZA_FILIAL		:= xFilial("ZZA")
		ZZA->ZZA_DOC		:= cNunNF
		ZZA->ZZA_SERIE		:= cSerieNF
		ZZA->ZZA_JUSTIF		:= cJustif
	
		ZZA->(MsUnLock())

	endif
	

endif

fLimpaTela()
MsgAlert("Conluido!!!")

Return


//------------------------------------------------------------------------------------------
/*
Pega o nome do separador.

@author    Gustavo Costa
@version   1.xx
@since     13/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fPegaSep(cCracha)	

local cRet		:= ""
Local cQuery	:= ""


cQuery := " SELECT RA_NOME FROM " + RetSqlName("SRA")
cQuery += " WHERE D_E_L_E_T_ <> '*' AND RA_SITFOLH<>'D' "
cQuery += " AND RA_CRACHA LIKE '%" + SubStr(cCracha,2,10) + "%' "

If Select("TSE") > 0
	DbSelectArea("TSE")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TSE"
dbselectArea("TSE")
dbGoTop("TSE")

While TSE->(!EOF())
		
	cRet := TSE->RA_NOME

	TSE->(dbSkip())
		
EndDo
	
dbCloseArea("TSE")
	
Return cRet




//------------------------------------------------------------------------------------------
/*
Lista todos os codigos de barras já bipados.

@author    Gustavo Costa
@version   1.xx
@since     13/03/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fListaTodos()

Local aLista	:= {}

If len(aProdutos) > 0

	For _i := 1 To len(aProdutos)
	
		AADD(aLista,aProdutos[_i][1]) 
		
	Next _i

Else

	AADD(aLista,"NENHUM PRODUTO") 

EndIf

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFontLista := TFont():New( "Arial Black",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgLista  := MSDialog():New( 163,528,643,742,"Produtos Bipados",,,.F.,,,,,,.T.,,,.F. )
oPanelList := TPanel():New( 000,000,"",oDlgLista,,.F.,.F.,,,100,020,.T.,.F. )
oLBoxLista := TListBox():New( 020,000,,aLista,110,209,,oDlgLista,,CLR_BLACK,CLR_WHITE,.T.,,,oFontLista,"",,,,,,, )
oSayLista  := TSay():New( 003,002,{||"Produtos já bipados"},oPanelLista,,oFontLista,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,107,013)

oDlgLista:Activate(,,,.T.)


Return

//------------------------------------------------------------------------------------------
/*
Lista todos os codigos de barras já bipados.

@author    Gustavo Costa
@version   1.xx
@since     13/03/2015
/*/
//------------------------------------------------------------------------------------------

Static Function fOBS()

private cOBS := Space(50)

SetPrvt( "oDlg99,oSay99,oOBS,oSBtnOBS," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99    	:= MSDialog():New( 159,315,227,860,"Justificativa",,,,,,,,,.T.,,, )
oSay99    	:= TSay():New( 004,004,{||"Informar:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oOBS   	:= TGet():New( 014,004,{|u| If(PCount()>0,cOBS:=u,cOBS)},oDlg99,232,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","cOBS",,)
oSBtnOBS  	:= SButton():New( 014,240,1,{|| oDlg99:End() },oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return cOBS

