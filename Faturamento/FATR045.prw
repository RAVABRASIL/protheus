#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATR045  º Autor ³ Flávia Rocha       º Data ³  14/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Chamado #37 - Criar relatório, que informe os pedidos      º±±
±±º               lançados para uma mesma localidade com informações:     º±± 
±±º               LOCALIDADE - PEDIDO - VALOR - PREV. FATURAMENTO -       º±±
±±º               RESP LANÇAMENTO.                                        º±±    
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Logistica                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR045


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "PEDIDOS LANÇADOS PARA UMA MESMA LOCALIDADE"
Local cPict          := ""
Local titulo       := "PEDIDOS LANÇADOS PARA UMA MESMA LOCALIDADE"
Local nLin         := 80

Local Cabec1       := "LOCALIDADE                         TRANSPORT.          PEDIDO          VALOR   PREV.FATURMTO       RESP.LANÇAMENTO."
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "FATR045" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FATR045" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FATR045"
Private cString := "SC5"

dbSelectArea("SC5")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  14/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*******************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
*******************************************************

Local nOrdem
Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local cRespLan := ""
Local nTotGer  := 0
//dbSelectArea(cString)
//dbSetOrder(1)

cQuery := " Select " + LF
//cQuery += " * " + LF

cQuery += " C5_NUM, C5_USERLGI, C5_USERLGA, C5_CLIENTE , C5_LOJACLI , A1_NREDUZ , C5_LOCALIZ , ZZ_DESC , SUM(C6_VALOR) VALOR, C5_ENTREG , C5_USERLGI , C5_USERLGA " + LF
cQuery += " ,A4_NREDUZ " + LF
cQuery += " , C5__USERIN " + LF
cQuery += " From " + LF
cQuery += " " + RetSqlName("SC5") + " SC5" + LF
cQuery += "," + RetSqlName("SC6") + " SC6" + LF
cQuery += "," + RetSqlName("SA1") + " SA1" + LF
cQuery += "," + RetSqlName("SZZ") + " SZZ" + LF
cQuery += "," + RetSqlName("SA4") + " SA4" + LF

cQuery += " Where " + LF
cQuery += " SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' " + LF
cQuery += " and SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' " + LF
cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' AND SZZ.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA4.D_E_L_E_T_ = '' " + LF
cQuery += " and SC5.C5_FILIAL = SC6.C6_FILIAL " + LF
cQuery += " and SC5.C5_NUM = SC6.C6_NUM " + LF
cQuery += " and SC5.C5_CLIENTE = SA1.A1_COD " + LF
cQuery += " and SC5.C5_LOJACLI = SA1.A1_LOJA " + LF
cQuery += " and SC5.C5_CLIENTE = SC6.C6_CLI " + LF
cQuery += " and SC5.C5_LOJACLI = SC6.C6_LOJA " + LF
cQuery += " and SC5.C5_LOCALIZ = SZZ.ZZ_LOCAL " + LF
cQuery += " and SC5.C5_TRANSP = SA4.A4_COD " + LF
cQuery += " and SZZ.ZZ_TRANSP = SA4.A4_COD " + LF

//não entregues
cQuery += " and (C6_QTDVEN - C6_QTDENT ) > 0 " + LF
//emitidos a partir de 01/01/14
cQuery += " and SC5.C5_EMISSAO >= '20140101' " + LF
//LOCALIDADE
If !Empty(MV_PAR02)
	cQuery += " and SC5.C5_LOCALIZ BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + LF
Endif
cQuery += " GROUP BY " + LF
cQuery += " C5_USERLGI, C5_USERLGA, C5_CLIENTE , C5_LOJACLI , A1_NREDUZ , C5_LOCALIZ , ZZ_DESC , C5_ENTREG , C5_USERLGI , C5_USERLGA " + LF
cQuery += " ,A4_NREDUZ , C5_NUM " + LF
cQuery += ", C5__USERIN " + LF

cQuery += " ORDER BY SZZ.ZZ_DESC, SC5.C5_NUM " + LF
MemoWrite("C:\TEMP\FATR045.SQL", cQuery )
If Select("TEMP1") > 0
	DbselectArea("TEMP1")
	DbcloseArea()
Endif
TCQUERY cQUery NEW ALIAS "TEMP1"
TCSetField( 'TEMP1', 'C5_ENTREG', 'D' )


If !TEMP1->(EOF())
	
	TEMP1->(Dbgotop())
	While !TEMP1->(EOF())

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Verifica o cancelamento pelo usuario...                             ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Impressao do cabecalho do relatorio. . .                            ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif
	   //"LOCALIDADE            TRANSP.              PEDIDO     VALOR     PREV.FATURAMENTO    RESP.LANÇAMENTO."
	   cRespLan := ""
	   @nLin,000 PSAY TEMP1->ZZ_DESC
	   @nLin,035 PSAY TEMP1->A4_NREDUZ
	   @nLin,055 PSAY TEMP1->C5_NUM
	   @nLin,065 PSAY Transform(TEMP1->VALOR , "@E 999,999,999.99")
	   @nLin,082 PSAY DTOC(TEMP1->C5_ENTREG)
	   cRespLan := Space(15)
	   //SC5->(Dbsetorder(1))
	   //If SC5->(Dbseek(xFilial("SC5") + TEMP1->C5_NUM ))
	   	//cRespLan := //iif(!Empty(TEMP1->C5_USERLGI), FWLeUserlg(TEMP1->C5_USERLGI) , "")  //Embaralha( TEMP1->C5_USERLGI , 1 )
	   	//cRespLan := iif(!Empty(SC5->C5_USERLGI), FWLeUserlg(SC5->C5_USERLGI) , "")  //Embaralha( TEMP1->C5_USERLGI , 1 )
	   	//cRespLan := iif(!Empty(TEMP1->C5_USERLGI, 1, "SC5"), LeUserlg(TEMP1->C5_USERLGI, 1, "SC5") , "")  //Embaralha( TEMP1->C5_USERLGI , 1 )
	   	//If Empty(cRespLan)
	   		//cRespLan := Embaralha( TEMP1->C5_USERLGA , 1 )	//se o user da inclusão estiver vazio, utilizo o da alteração
	   		//cRespLan := iif( !Empty(TEMP1->C5_USERLGA) , FWLeUserlg(TEMP1->C5_USERLGA) , "" )
	   		//cRespLan := iif( !Empty(SC5->C5_USERLGA) , FWLeUserlg(SC5->C5_USERLGA) , "" )
	   		//cRespLan := iif( !Empty(TEMP1->C5_USERLGA, 1, "SC5") , FWLeUserlg(TEMP1->C5_USERLGA, 1 , "SC5") , "" )
	   	//Endif
	   //Endif
	   	/*
		 Embaralha( cString , nAcao )
		 Se nAcao = 0 , embaralha
		 Se nAcao = 1 , desembaralha
		*/
		
		If !Empty(TEMP1->C5__USERIN)
			cRespLan := NomeOp( Alltrim(TEMP1->C5__USERIN) )
			@nLin,102 PSAY cRespLan
		Else
			@nLin,102 PSAY "               "
		Endif
	   	
	   nTotGer += TEMP1->VALOR
	   nLin++
	
	   TEMP1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
		@nLin,000 PSAY REPLICATE('.' , LIMITE)
		nLin++
		@nLin,035 PSAY " TOTAL GERAL ===> " 
		@nLin,065 PSAY Transform(nTotGer , "@E 999,999,999.99")
		nLin++
		@nLin,000 PSAY REPLICATE('.' , LIMITE)
		nLin++
		
		DbselectArea("TEMP1")
		DbcloseArea()
Endif //eof

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda( 0 , "" , tamanho)

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
// para obter as informações de inclusão
cUserI := FWLeUserlg("A1_USERLGI")
cDataI := FWLeUserlg("A1_USERLGI", 2)
// para obter as informações de alteração
cUserA := FWLeUserlg("A1_USERLGA")
cDataA := FWLeUserlg("A1_USERLGA", 2)
*/
********************************************
Static Function LeUserLg(cCampo, nTipo, cAlias)
********************************************

Local nPos			:= 0
Local cAux			:= ""        
Local cID			:= ""             
Local cUsrName 	:= "" 
Local cRet			:= ""                     
//Local cAlias		:= ""
Local cSvAlias  	:= Alias()
Local lChgAlias 	:= .F.
Local lAliasInDic := .T. 

//Default nTipo := 1


//-----------------------------------------------------
// Tratamento para tabelas temporárias
//-----------------------------------------------------
lTemporary := .F. //cSvAlias == "TRB"
/*
If !lTemporary	
	If ( ! AliasInDic( cSvAlias ) )
		cAlias := Subs(cCampo, 1, At('_', cCampo)- 1 )   
		
		If ( len( cAlias ) == 2 )
			cAlias := 'S' + cAlias
		EndIf
	
		lAliasInDic := ( AliasInDic( cAlias ) )
		lTemporary  :=  ! lAliasInDic
	EndIf
EndIf 
*/
If !lTemporary
	//--------------------------------------------------
	// Força a pesquisa do conteúdo do _USERLG na tabela
	// correspondente ao campo
	//--------------------------------------------------
	nPos := At( '->', cCampo) 
	
	If !( nPos == 0 ) 
		cCampo := Subs(cCampo, nPos + 2 )   
	EndIf 
	/*
	If  ( lAliasInDic )
		cAlias := Subs(cCampo, 1, At('_', cCampo)- 1 )   
		
		If ( len(cAlias) == 2 )
			cAlias := 'S'+cAlias
		EndIf
	EndIf
	*/
	//If cAlias != cSvAlias
		DbSelectArea(cAlias)
		lChgAlias := .T.
	//Endif
	
EndIf

//cAux := Embaralha(&cCampo,1)
cAux := Embaralha(cCampo,1)
//cAux := cCampo

If !Empty(cAux)
	If Subs(cAux, 1, 2) == "#@"
		cID := Subs(cAux, 3, 6)
		If Empty(__aUserLg) .Or. Ascan(__aUserLg, {|x| x[1] == cID}) == 0                            
			PSWORDER(1)
			If ( PSWSEEK(cID) )
				cUsrName	:= Alltrim(PSWRET()[1][2])
			EndIf		
			Aadd(__aUserLg, {cID, cUsrName})	
		EndIf
		
		If nTipo == 1 // retorna o usuário
			nPos := Ascan(__aUserLg, {|x| x[1] == cID})
			cRet := __aUserLg[nPos][2]
		Else
			cRet := Dtoc(CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cAux,16)))
		Endif                         
	Else
		If nTipo == 1 // retorna o usuário
			cRet := Subs(cAux,1,15)
		Else   
			cRet := Dtoc(CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cAux,16)))
		Endif                         
	EndIf
EndIf                 

If lChgAlias
	If !Empty(cSvAlias)
		DbSelectArea(cSvAlias)	
	Endif
EndIf

Return cRet



***************

Static Function NomeOp( cOperado )

***************
PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   cNome := Alltrim(aUsuarios[1][4])     	// Nome do usuário
Endif 

return cNome
