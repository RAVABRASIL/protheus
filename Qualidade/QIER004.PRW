#INCLUDE "QIER270.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Programa: QIER004 - ETIQUETA DO LAUDO QUALIDADE
Autoria : Flávia Rocha
Data    : 08/06/2011
Objetivo: Imprimir a etiqueta do Laudo de Qualidade, acrescentando 
          a Justificativa do Laudo
Melhoria das perguntas (SX1), reduzindo apenas para 3: NF, SÉRIE, PRODUTO
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//Function QIER270 (cProg,nMv_par11, nMv_par12,aVetQEK,lImpFic,lEtiqRast)
User Function QIER004()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Se for chamado pelo cadastro Entradas ou pelo menu, nao passa o vetor com ³ 
//³  a chave de cada Entrada												   ³ 
//³  Se for chamado pela importacao, passa o vetor com as Entradas para a im-  ³ 
//³  pressao das etiquetas.													   ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel   := "QIER004" //"QIER270"
Local cString := "QEK"
Local cDesc1  := STR0001 //"Ser„o impressas as etiquetas de Laudo.          "
Local cDesc2  := STR0002 //"           "
Local cDesc3  := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Guarda aquivo e indices correntes    ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAlias    := Alias()
Local nOldOrder := IndexOrd()

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo	 := STR0003	// "Etiqueta de Laudo"
Private cTamanho := "P"
Private nPagina	 := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault    ³
//³  e SetPrint                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0004, 1,STR0005,  1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nLastKey := 0
Private cPerg    := "QER270_" //"QER270"
Private nRecno   := QEK->(Recno())
Private lEnd     := .F.
Private nLimite  := 80
Private cProg := ""
Default cProg := "QIER004 " //"QIER270"
//ANTIGO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					     ³
//³ mv_par01			  // Fornecedor de					     ³
//³ mv_par02			  // Fornecedor ate		    		   	 ³
//³ mv_par03			  // Loja Fornecedor de	 				 ³
//³ mv_par04			  // Loja Fornecedor ate   				 ³
//³ mv_par05			  // Produto de							 ³
//³ mv_par06			  // Produto ate 						 ³
//³ mv_par07			  // Data Entrada de					 ³
//³ mv_par08           	  // Data Entrada ate                    ³
//³ mv_par09              // Lote de                             ³
//³ mv_par10              // Lote ate                            ³
//³ mv_par11              // Assumir Tam.Lote                    ³
//³ mv_par12              // N§ de Etiquetas se Nao Usar Tam.Lote³
//³ mv_par13              // Considera Entrada 1)Normal			 ³
//³											   2)Beneficiamento  ³
//³ 										   3)Devolucao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

//NOVOS
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					     ³
//³ mv_par01			  // NF         					     ³
//³ mv_par02			  // Série         		    		   	 ³
//³ mv_par03			  // Produto             				 ³
//³ mv_par04			  // Nr. Etiquetas        				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)
/*
If cProg $ "QIEA200.QIER220"
	mv_par11 := nMv_par11
	mv_par12 := nMv_par12
	cPerg    := ""  // Desabilita a pergunte
EndIf
*/

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Assume valores caso usu rio nao digite ou digite zero ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//IF(mv_par11<1,mv_par11:=1,)
//IF(mv_par12<1,mv_par12:=1,)
//IF(cProg == NIL, cProg := "",)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,cTamanho,"",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se apertou o botao cancela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return .F.
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .F.
EndIf

//RptStatus({|lEnd| A270Imp(@lEnd,wnRel,cString,cProg,aVetQEK,lImpFic,lEtiqRast)},cTitulo)
RptStatus({|lEnd| A270Imp(@lEnd,wnRel,cString,cProg)},cTitulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o arq anterior             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(nOldOrder)
dbGoTo(nRecNo)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ A270Imp  ³ Autor ³ Antonio Aurelio       ³ Data ³ 30.08.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime as Etiquetas dos Produtos da Entregua              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd  - Verifica se o foi cancelada a impressao            ³±±
±±³			 ³ wnRel - Usada na fun‡Æo OurSpool                           ³±±
±±³			 ³ cProg - Usada na verifica‡Æo do prmg chamador desta fun‡Æo ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ A200Imp(QIER200.PRW) e A210Imp(QIER210.PRW)				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function A270Imp(lEnd,wnRel,cString,cProg,aVetQEK,lImpFic,lEtiqRast)
Static Function A270Imp(lEnd,wnRel,cString,cProg)

Local lImp	  := .T.
Local nIEnt	  := 0
Local cIndex1 := ""
Local cFiltro := ""
Local cKey	  := ""

Private  cTamLot := ""
Private  nLin := 0
Private par01
Private par02
Private par03
Private par04
Private par05
Private par06
Private par07
Private par08
Private par09
Private par10
Private par11 := 0
Private par12 := 0
Private par13 := 1
Private LF    := CHR(13) + CHR(10)

Setprc(00,00)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao a partir do menu de Relatorios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !cProg $ "QIEA200.QIER220"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Indice Condicional nos arquivos utilizados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cIndex1 := CriaTrab( Nil, .F. )
	
	///LOCALIZA QEK
    cQuery := " select top 1 R_E_C_N_O_ AS REGISTRO, * from " + RetSqlName("QEK") + " QEK " + LF
    cQuery += " where QEK_NTFISC = '" + Alltrim(mv_par01) + "' " + LF
    cQuery += " and QEK_SERINF = '" + Alltrim(mv_par02) + "' " + LF
    cQuery += " and QEK_PRODUT = '" + Alltrim(mv_par03) + "' " + LF
    
    cQuery += " and QEK_FILIAL = '" + xFilial("QEK") + "' " + LF
    cQuery += " and QEK.D_E_L_E_T_ = '' " + LF
    cQuery += " Order by R_E_C_N_O_ " + LF
        
    MemoWrite("C:\Temp\LOCALQEK.sql", cQuery)
    If Select("QEKX") > 0
		DbSelectArea("QEKX")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QEKX"
	TCSetField( 'QEKX', "QEK_DTENTR", "D" )
	
	QEKX->( DBGoTop() )
	
	Do While !QEKX->( Eof() )
	
		//³ Variaveis utilizadas para parametros					     ³
		//³ mv_par01			  // Fornecedor de					     ³
		//³ mv_par02			  // Fornecedor ate		    		   	 ³
		//³ mv_par03			  // Loja Fornecedor de	 				 ³
		//³ mv_par04			  // Loja Fornecedor ate   				 ³
		//³ mv_par05			  // Produto de							 ³
		//³ mv_par06			  // Produto ate 						 ³
		//³ mv_par07			  // Data Entrada de					 ³
		//³ mv_par08           	  // Data Entrada ate                    ³
		//³ mv_par09              // Lote de                             ³
		//³ mv_par10              // Lote ate                            ³
		//³ mv_par11              // Assumir Tam.Lote                    ³
		//³ mv_par12              // N§ de Etiquetas se Nao Usar Tam.Lote³
		//³ mv_par13              // Considera Entrada 1)Normal			 ³
		//³											   2)Beneficiamento  ³
		//³ 										   3)Devolucao       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
		par01 := QEKX->QEK_FORNEC
		par02 := QEKX->QEK_FORNEC		
		par03 := QEKX->QEK_LOJFOR
		par04 := QEKX->QEK_LOJFOR
		par05 := QEKX->QEK_PRODUT
		par06 := QEKX->QEK_PRODUT
		par07 := QEKX->QEK_DTENTR
		par08 := QEKX->QEK_DTENTR
		par09 := QEKX->QEK_LOTE 
		par10 := QEKX->QEK_LOTE 
			
		DbselectArea("QEKX")
		QEKX->(Dbskip())
	Enddo 
	
	IF(par11 < 1, par11:=1,)
	IF(mv_par04 < 1,mv_par04:=1,)
	//IF(cProg == NIL, cProg := "",)
	
    DbselectArea("QEKX")
    DBCLOSEAREA()

	dbSelectarea("QEK")
	dbSetOrder(1)
	cKey:=IndexKey()
	cFiltro := ' QEK->QEK_FILIAL == "'+xFilial("QEK") +'"'
	cFiltro += '.And. QEK->QEK_FORNEC >="'+ par01+'" .And. QEK->QEK_FORNEC <="' + par02+'" .And.'
	cFiltro += ' QEK->QEK_LOJFOR >="' + par03 + '" .And. QEK->QEK_LOJFOR <="' + par04 + '".And.'
	cFiltro += ' QEK->QEK_PRODUT >="' + par05 + '".And.  QEK->QEK_PRODUT <="' + par06 + '".And.'
	cFiltro += 'DTOS(QEK->QEK_DTENTR) >="'+DTOS(par07)+'".And.DTOS(QEK->QEK_DTENTR) <="'+DTOS(par08)+'".And.'
	cFiltro += 'QEK->QEK_LOTE >="'+ par09 + '".And. QEK->QEK_LOTE <="' + par10 + '"'

	If par13	== 1
		cFiltro += ' .And. (QEK->QEK_TIPONF == "N"'+'.Or. QEK->QEK_TIPONF == " ")'
	ElseIf par13 == 2
		cFiltro += ' .And. QEK->QEK_TIPONF == "B"'
	ElseIf par13 == 3
		cFiltro += ' .And. QEK->QEK_TIPONF == "D"'
	EndIf

	IndRegua("QEK",cIndex1,cKey,,cFiltro,STR0006)	//"Selecionando Registros.."
	nIndex := RetIndex("QEK")

	#IFNDEF TOP
		dbSetIndex(cIndex1+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbSeek( xFilial( "QEK" ) )
	A270ImEt(lEnd,wnRel,cString,cProg)

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao a partir do cadastro de Entradas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aVetQEK == NIL

		// Reposiciona o QEK
		QEK->(dbGoTo(nRecNo))
		par01 := QEK->QEK_FORNEC
		par02 := QEK->QEK_FORNEC
		par03 := QEK->QEK_LOJFOR
		par04 := QEK->QEK_LOJFOR
		par05 := QEK->QEK_PRODUT
		par06 := QEK->QEK_PRODUT
		par07 := QEK->QEK_DTENTR
		par08 := QEK->QEK_DTENTR
		par09 := QEK->QEK_LOTE
		par10 := QEK->QEK_LOTE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utiliza o Tam.Lote corrente ou assume   ³
		//³   o informado na pergunte mv_par12      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par11 == 1
			cTamLot := QEK->QEK_TAMLOT
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Troca a virgula por ponto outros        ³
			//³   caracteres sao bloqueados no cadastro ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AT(",",cTamLot) > 0
				cTamLot := StrTran(cTamLot,",",".")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se o Tam.Lote nao for inteiro ‚ adicionado   ³
			//³  uma etiqueta a mais                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Int(SuperVal(cTamLot)) == SuperVal(cTamLot)
				//mv_par12 := Int(SuperVal(cTamLot))
				mv_par04 := Int(SuperVal(cTamLot))
			Else
				mv_par04 := Int(SuperVal(cTamLot)) + 1
			EndIf
		EndIf
		lImp := .T.

		A270ImEt(lEnd,wnRel,cString,cProg)

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao a partir da importacao de Entradas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nIEnt := 1 To Len(aVetQEK)
            If !lImpFic .and. !lEtiqRast
				aVetQEK[nIEnt] := xFilial("QEK")+aVetQEK[nIEnt]
            Endif
			// Posiciona o QEK
			If QEK->(dbSeek(aVetQEK[nIEnt]))
				par01 := QEK->QEK_FORNEC
				par02 := QEK->QEK_FORNEC
				par03 := QEK->QEK_LOJFOR
				par04 := QEK->QEK_LOJFOR
				par05 := QEK->QEK_PRODUT
				par06 := QEK->QEK_PRODUT
				par07 := QEK->QEK_DTENTR
				par08 := QEK->QEK_DTENTR
				par09 := QEK->QEK_LOTE
				par10 := QEK->QEK_LOTE
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Utiliza o Tam.Lote corrente ou assume   ³
				//³   o informado na pergunte mv_par12      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If par11 == 1
					cTamLot := QEK->QEK_TAMLOT
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Troca a virgula por ponto outros        ³
					//³   caracteres sao bloqueados no cadastro ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If AT(",",cTamLot) > 0
						cTamLot := StrTran(cTamLot,",",".")
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se o Tam.Lote nao for inteiro ‚ adicionado   ³
					//³  uma etiqueta a mais                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//If Int(SuperVal(cTamLot)) == SuperVal(cTamLot)
					//	mv_par04 := Int(SuperVal(cTamLot))
					//Else
					//	mv_par04 := Int(SuperVal(cTamLot))+1
					//EndIf
					
				EndIf
				lImp := .T.
				A270ImEt(lEnd,wnRel,cString,cProg)
			EndIf
		Next
	EndIf
EndIf

Return(.T.)
        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ A270ImEt ³ Autor ³ Antonio Aurelio       ³ Data ³ 04.05.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime as Etiquetas dos Produtos da Entrada               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd  - Verifica se o foi cancelada a impressao            ³±±
±±³			 ³ wnRel - Usada na fun‡Æo OurSpool                           ³±±
±±³			 ³ cProg - Usada na verifica‡Æo do prmg chamador desta fun‡Æo ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³   														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ A270Imp                                         			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270ImEt(lEnd,wnRel,cString,cProg)

Local cFor		  := ""
Local cLojFor	  := ""
Local nC          := 0
Local cEtiq       := ""
Local cChaveQEK1  := ""
Local nDias       := 0
Local nOrdQE6	  := QE6->(IndexOrd())
Local nOrdSAH	  := SAH->(IndexOrd())
Local nOrdQEL     := QEL->(IndexOrd())
Local nOrdQED     := QED->(IndexOrd())
Local nSaltPag    := 0
Local lNFQEL      := IIF(QEL->(FieldPos('QEL_NTFISC')) > 0,.t.,.f.)
Local cSeek       := ""
Local oFont06
Local oPrint
Local lin := 80
Local nEtiqueta  

oFont06		:= TFont():New("Arial",06,08,,.F.,,,,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N§ de Etiquetas a serem impressas 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !cProg $ "QIEA200.QIER220"
	SetRegua( QEK->(RecCount()) )  // Depende da selecao feita na pergunte
Else
	If par11 == 1  // Assume o tamanho do lote
		SetRegua(mv_par04 * QEK->(RecCount()))
	Else
		SetRegua(mv_par04 )  // S¢ o tamanho especificado
	EndIf
EndIf

dbSelectArea("QEK")
oPrint := TMSPrinter():New("")
oPrint:SetPortrait()
While QEK->(!Eof()) .And. xFilial("QEK") == QEK->QEK_FILIAL .And. ;
		QEK->QEK_FORNEC >= par01 .And. QEK->QEK_FORNEC <= par02 .And.;
		QEK->QEK_LOJFOR >= par03 .And. QEK->QEK_LOJFOR <= par04 .And.;
		QEK->QEK_PRODUT >= par05 .And. QEK->QEK_PRODUT <= par06 .And.;
		QEK->QEK_DTENTR >= par07 .And. QEK->QEK_DTENTR <= par08 .And.;
		QEK->QEK_LOTE   >= par09 .And. QEK->QEK_LOTE   <= par10
		
	cChaveQEK1	:= QEK->QEK_PRODUT+Inverte(QEK->QEK_REVI)
	cLojFor	    := QEK->QEK_LOJFOR
	cFor		:= QEK->QEK_FORNEC

	dbSelectArea("QE6")
	dbSetOrder(1)
	QE6->(dbSeek(xFilial("QE6")+cChaveQEK1))

	If QE6->(!Found())
		// "Produto/Revisao nao cadastrados:
		Set Device to Screen
		Help(" ",1,"QE_NAOPRRV",,AllTrim(QEK->QEK_PRODUT)+" / "+QEK->QEK_REVI,2,1)
		Set Device to Printer
		dbSelectArea("QEK")
		QEK->(dbSkip())
		Loop
	EndIf

	cProduto := QE6->QE6_PRODUT+QE6->QE6_REVI

	If QE6->QE6_UNSHEL == "1"  // Dia
		nDias := QE6->QE6_SHLF
	Else
		If QE6->QE6_UNSHEL == "2" // Mes
			nDias := QE6->QE6_SHLF * 30
		Else
			nDias := QE6->QE6_SHLF * 365
		EndIf
	EndIf

	If lNFQEL
		QEL->(dbSetOrder(3))
		cSeek := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO+QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
		Space(TamSX3("QEL_LABOR")[1])
		
	Else
		QEL->(dbSetOrder(1))
		cSeek := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
		Space(TamSX3("QEL_LABOR")[1])
	EndIf
	
	If	QEL->(dbSeek(xFilial("QEL")+cSeek))
		cJustLau := Alltrim(QEL->QEL_JUSTLAU)  //JUSTIFICATIVA DO LAUDO
		If Empty(QEL->(QEL_NUMPER))
			If QED->(dbSeek(xFilial("QED")+QEL->QEL_LAUDO))
				cEtiq := AllTrim(QED->QED_DESCPO)
				
			Else
				cEtiq := STR0010 // EM INSPECAO
			EndIf
		Else
			QF2->(dbSetOrder(1))
			If QF2->(dbSeek(xFilial("QF2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
					QEK->QEK_PRODUT+Dtos(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
					QEL->QEL_NUMPER))
				// Se a PU for Aprovada, o laudo a ser impresso e Liberado
				If QF2->QF2_STATUS == "A"
					cEtiq := STR0012	// "LIBERADO"
				Else
					// Permanece o laudo definido pelo usuario
					If QED->(dbSeek(xFilial("QED")+QEL->QEL_LAUDO))
						cEtiq := AllTrim(QED->QED_DESCPO)
					Else
						cEtiq := STR0010 // EM INSPECAO
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		cEtiq := STR0010 // EM INSPECAO
	EndIf


	If !cProg $ "QIEA200.QIER220"
		If par11 == 1  // Assume o Tam. do Lote
			cTamLot := QEK->QEK_TAMLOT
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Troca a virgula por ponto outros        ³
			//³   caracteres sao bloqueados no cadastro ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AT(",",cTamLot) > 0
				cTamLot := StrTran(cTamLot,",",".")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se o Tam.Lote nao for inteiro ‚ adicionado   ³
			//³  uma etiqueta a mais                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//If Int(SuperVal(cTamLot)) == SuperVal(cTamLot)
			//	mv_par04 := Int(SuperVal(cTamLot))
			//Else
			//	mv_par04 := Int(SuperVal(cTamLot)) + 1
			//EndIf
		EndIf
	EndIf

	If par11 == 1	
		nEtiqueta:= Int(SuperVal(cTamLot))
	Else	
		nEtiqueta:= mv_par04
    Endif


	oPrint:StartPage() 		
	For nC := 1 To mv_par04

		IncRegua()

	   If lEnd
			nLin := nLin + 1
			@ nLin ,001 PSAY STR0007  // "CANCELADO PELO OPERADOR"
			Exit
		EndIf

		nSaltPag:= nSaltPag + 1
		lin += 30

		oPrint:Say(lin,0020,cEtiq,oFont06)        
		lin += 30

		//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		//Produto....: 0123456789012345 - XX
		//              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		//Data Entreg: 99/99/9999 Lote.....: 0123456789012345
		//Validade...: 99/99/9999 Tam.Lote.: 012345678 XXXXXXXXX
		//Nota Fiscal: 0123456789012 012
		// 			1			 2 		  3			4			 5 		  6			7			 8 		  9			10 		 11		  12			13
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		oPrint:Say(lin,0020,"JUSTIF: " + cJustLau,oFont06)        
		lin += 30
		
        oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_PRODUT")[1]),11,".")+" : " +AllTrim(QEK->QEK_PRODUT)+" - Rev: " +QEK->QEK_REVI,oFont06)        
		lin += 30

		//oPrint:Say(lin,0150,QE6->QE6_DESCPO,oFont06)        
		oPrint:Say(lin,0020,QE6->QE6_DESCPO,oFont06)        
		lin += 30

		//oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_DTENTR")[1]),11,".")+" : "+dtoc(QEK->QEK_DTENTR)+"  "+Pad(AllTrim(TitSx3("QEK_LOTE")[1]),10,".")+" : "+AllTrim(QEK->QEK_LOTE),oFont06)        
		oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_DTENTR")[1]),11,".")+" : "+ dtoc(QEK->QEK_DTENTR),oFont06)        
		lin += 30
		
		SAH->(dbSetOrder(1))
		SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
		If !Empty(SAH->AH_UMRES)
			oPrint:Say(lin,0020,STR0011+"    "+dtoc(QEL->QEL_DTVAL)+"  "+Pad(AllTrim(TitSx3("QEK_TAMLOT")[1]),11,".")+" : "+AllTrim(QEK->QEK_TAMLOT)+" "+SAH->AH_UMRES,oFont06) 	// "Validade..: "       
		Else
			oPrint:Say(lin,0020,STR0011+"    "+dtoc(QEL->QEL_DTVAL)+"  "+Pad(AllTrim(TitSx3("QEK_TAMLOT")[1]),11,".")+" : "+AllTrim(QEK->QEK_TAMLOT),oFont06) 	       
		Endif		

		lin += 30
		If !Empty(QEK->QEK_SERINF)   		
			oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_NTFISC")[1]),11,".")+" : "+AllTrim(QEK->QEK_NTFISC)+" - "+QEK->QEK_SERINF,oFont06)        		
		Else
			oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_NTFISC")[1]),11,".")+" : "+AllTrim(QEK->QEK_NTFISC),oFont06)        		
		EndIf
     
		If lin > 2500  
			oPrint:EndPage() 		
			lin := 80
			nSaltPag:= 0
		Else
			If nSaltPag == 	nEtiqueta // Pula de Pagina de acordo com o numero de etiquetas 
				If lin > 2500  
					oPrint:EndPage() 		
					lin := 80
					nSaltPag:= 0
					nSaltPag:= 0           
					oPrint:EndPage() 		
				Endif	
				lin += 100
			Else			
				lin += 100 
			EndIf
	    Endif

	Next

	QEK->(dbSkip())

	If lEnd
		Exit
	EndIf

EndDo

oPrint:Preview()  	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os ¡ndices dos arq. usados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QE6")
dbSetOrder(nOrdQE6)
dbSelectArea("SAH")
dbSetOrder(nOrdSAH)
dbSelectArea("QED")
dbSetOrder(nOrdQED)
dbSelectArea("QEL")
dbSetOrder(nOrdQEL)

Return(.T.)
