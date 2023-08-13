#INCLUDE "PROTHEUS.ch"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Criar Arquivo Remessa                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rava Embalagens - Cobranca                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COBC031()

PRIVATE lconsBco := GetMv("MV_CONSBCO")
PRIVATE cMarc31   := GetMark()
PRIVATE lInverte := .F.
PRIVATE nPrazo   := 0		//para ponto de entrada
PRIVATE nPrazoMed:= 0		//idem
PRIVATE VALOR	  := 0
PRIVATE nIndice	:= 2 //Cliente + loja + prefixo + numero + parcela + tipo
PRIVATE cCadastro := OemToAnsi("Criar Bordero - Cobranca Externa")
PRIVATE cLote     := '8850'

PRIVATE nMoeda:=1
PRIVATE cPict06014:= PesqPict("SE1","E1_VALOR",16,nMoeda)
PRIVATE cPict06018:= PesqPict("SE1","E1_VALOR",18,nMoeda)
PRIVATE cNumBor:=Space(06),cAgen060:=Space(05),cPadrao,cConta060:=Space(10)
PRIVATE cSituacao := " " ,nCount := 0
PRIVATE cSaveMenuh,nRecBrowse,cCapital,nLimite:=0,nC:=0
PRIVATE nValCred := nValSaldo := 0,lLanc:=.F.,cPictTd:=" "
PRIVATE nTotal:=0,nHdlPrv:=0,cArquivo,lPadrao:=.F.,lDigita:=.T.,j
PRIVATE cChave,lSaida:=.F., cFiltro
PRIVATE lAglut,aStru,aCampos:={},cFileWork,cAliasTRB,cCampo
PRIVATE nRec
PRIVATE nSequencia, ni, nJ
PRIVATE nRegSE1 :=0 , nRegSEA := 0

PRIVATE aTempos     := {}
PRIVATE cClearing   := ""
PRIVATE nTmpPos     := 0
PRIVATE oDlgDesc, cTipoCli, TipoCob
PRIVATE oValor, oQtda, oPrazoMed
PRIVATE bWhile
PRIVATE oCbx
PRIVATE cSituant

PRIVATE cAgeExt1 := GETMV("MV_COBEXT1") //Status para agencia de cobranca 1
PRIVATE cPort060:=Space(3),aSituacoes:={}
PRIVATE dVencIni:=cTod("01/01/1980")//dDataBase
PRIVATE dVencFim:=dDataBase-120
PRIVATE cEstIni:=Space(2),cEstFim:='ZZ'
PRIVATE dEmisDe :=dDataBase
PRIVATE dEmisAte:=dDataBase
PRIVATE cCliDe  := Space(Len(SE1->E1_CLIENTE))
PRIVATE cCliAte := Replicate("Z",Len(SE1->E1_CLIENTE))

aTempos     := {"24"+OemToAnsi(" Horas"),"48"+OemToAnsi(" Horas"),"72"+OemToAnsi(" Horas"),"96"+OemToAnsi(" Horas"),"1 "+OemToAnsi(" Semana"),OemToAnsi("Mais de ")+"1"+OemToAnsi(" Semana")} //  # #  #  #

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return
Endif

pergunte("FIN060",.F.)

While .T.
	
	cFilDe  := xFilial("SE1")
	cFilAte := xFilial("SE1")
	
	dbSelectArea( "SE1" )
	nSavRec:=RecNo()
	VALOR 	 := 0
	nValSaldo := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vai pegar o ultimo N£mero de bordero utilizado 				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
	If (!RecLock("SX6",.F.) )
		Exit
	EndIf
	
	aTipoCli := {"Fisica","Juridica", "Ambos"}
	cTipoCli  := aTipoCli[3]
	
	aTipoCob := {"Primeira Cobranca","Segunda Cobranca"}
	cTipoCob  := aTipoCli[1]
	
	cPict06014:= PesqPict("SE1","E1_VALOR",16,nMoeda)
	cPict06018:= PesqPict("SE1","E1_VALOR",18,nMoeda)
	
	nOpca := 0
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Border“ - Cobranca Externa") FROM 5,0 To 23,65 OF oMainWnd
	@ 1.0, 2   Say OemToAnsi("Border“ N§")
	@ 1.0, 7.5 MSGET cNumBor  Picture "@!"       Valid !Empty(cNumBor) .And. FA060Num(cNumBor)
	
	@ 1.0,15   Say OemToAnsi("Cobranca")
	@ 12 ,150  COMBOBOX oCbx VAR cTipoCob ITEMS aTipoCob Valid !Empty(cTipoCob) SIZE 70,27 Of oDlg Pixel
	
	@ 2.0, 2   Say OemToAnsi("Venc Real ")
	@ 2.0, 7.5 MSGET dVencIni SIZE 37,10 OF oDlg
	@ 2.0,12.5 Say OemToAnsi("a")
	@ 2.0,14.0 MSGET dVencFim Valid FA060DATA(dVencIni,dVencFim) SIZE 37,10 OF oDlg
	
	@ 3.0, 2   Say OemToAnsi("Valor Minimo")
	@ 3.0, 7.5 MSGET nLimite Picture cPict06018 Valid nLimite >= 0 SIZE 50,10 of oDlg
	
	@ 4.0, 2   Say OemToAnsi("Estado ")
	@ 4.0, 7.5 MSGET cEstIni SIZE 10,10 OF oDlg
	@ 4.0,10.5 Say OemToAnsi("a")
	@ 4.0,12.0 MSGET cEstFim SIZE 10,10 OF oDlg
	
	@ 5.0, 2   Say OemToAnsi("Emiss„o")
	@ 5.0, 7.5 MSGET dEmisDe SIZE 37,10 of oDlg
	@ 5.0,12.5 Say OemToAnsi("a")
	@ 5.0,14.0 Get dEmisAte   Valid dEmisAte >= dEmisDe SIZE 37,10 of oDlg
	
	@ 6.0, 2   Say OemToAnsi("Cliente")
	@ 6.0, 7.5 MSGET cCliDe F3 "CLI" SIZE 70,10 of oDlg
	@ 6.0,17.0 Say OemToAnsi("a")
	@ 6.0,18.5 MSGet cCliAte F3 "CLI" Valid cCliAte >= cCliDe SIZE 70.5,10 of oDlg
	
	@ 7.0, 2   Say OemToAnsi("Tipo Cliente")
	@ 90,60	  COMBOBOX oCbx VAR cTipoCli ITEMS aTipoCli Valid !Empty(cTipoCli) SIZE 70,27 Of oDlg Pixel
	
	@ 8.0, 2   Say OemToAnsi("Banco ")
	@ 8.0, 7.5 MSGET cPort060  Picture "@!" F3 "EXT" Valid CarregaSa6(@cPort060,@cAgen060,@cConta060,.F.) SIZE 10,10
	@ 8.0,12.5 Say OemToAnsi("Agˆncia")
	@ 8.0,15.4 MSGET cAgen060	Picture "@!"  Valid CarregaSa6(@cPort060,@cAgen060,@cConta060,.F.)
	@ 8.0,21.0 Say OemToAnsi("Conta")
	@ 8.0,24.0 MSGET cConta060 Picture "@!"  Valid CarregaSa6(@cPort060,@cAgen060,@cConta060,.F.) SIZE 55,10
	
	
	@	 .2,.5 TO 08.5,31.7 OF oDlg
	
	DEFINE SBUTTON FROM 119,176.4 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 119,203.3 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED VALID (iif(nOpca==1,F060Vld(cPort060,cAgen060,cConta060,'5'),.t.))
	

	cSituacao := "5" //Cobranca com Advogado SubStr(cComboSit,1,1)
	
	cStatCob := ''
	
	IF Subst(cTipoCob,1,1) == "P"
		cStatCob := StrTran(cAgeExt1,",","','")
	Endif
	
	If nOpca == 0
		Return
	Endif
	
	cFil060 := ".T."
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Implementa‡Æo de performace para atender a versÆo 2.06 e ++.     ³
	//³ Fazer o Browse() e a IndRegua() em uma area de trabalho a partir ³
	//³ do SE1.                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nQtdTit31 := 0
	nValor31  := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem de array para tratamento na MarkBrowse com o arquivo TRB  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	cCampos := "E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_STATCOB"
	AADD(aCampos,{"E1_OK"     ,""," "," "})
	AADD(aCampos,{"E1_CLIENTE","","Cliente" ,"@!"})
	AADD(aCampos,{"E1_LOJA"   ,"","Loja"    ,"@!"})
	AADD(aCampos,{"E1_NOMCLI" ,"","Nome"    ,"@!"})
	AADD(aCampos,{"E1_PREFIXO","","Prefixo" ,"@!"})
	AADD(aCampos,{"E1_NUM"    ,"","Numero"  ,"@!"})
	AADD(aCampos,{"E1_PARCELA","","Par"     ,"@!"})
	AADD(aCampos,{"E1_TIPO"   ,"","Tipo"    ,"@!"})
	AADD(aCampos,{"E1_NATUREZ","","Natureza","@!"})
	AADD(aCampos,{"E1_EMISSAO","","Emissao" ,""})
	AADD(aCampos,{"E1_VENCREA","","Vencto " ,""})
	AADD(aCampos,{"E1_VALOR"  ,"","Valor"   ,"@E 999,999.99"})
	AADD(aCampos,{"E1_SALDO"  ,"","Saldo"   ,"@E 999,999.99"})
	AADD(aCampos,{"E1_STATCOB","","Status"  ,"@!"})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria‡Æo da estrutura de TRB com base em SE1.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(nIndice)
	aStru   := dbStruct()
	AADD(aStru,{"RECSE1","N",10,0})
	cFileWork := CriaTrab(aStru,.T.)
	
	USE &cFileWork ALIAS TRB EXCLUSIVE NEW
	IndRegua("TRB",cFileWork,SE1->(IndexKey()),,,OemToAnsi("Selecionando Registros..."))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Titulos a Receber conforme parametros.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SE1")
	dbSetOrder(7)            // Chave (Vencimento)
	
	cQuery := "SELECT SE1.*, A1_NOME "
	cQuery += "  FROM "+	RetSqlName("SE1") + " SE1, "+RetSqlName("SA1") + " SA1"
	cQuery += " WHERE E1_NUMBOR = '' "
	cQuery += "   AND E1_EMISSAO Between '" + DTOS(dEmisDe) + "' AND '" + DTOS(dEmisAte) + "'"
	cQuery += "   AND E1_VENCREA between '" + DTOS(dVencIni)+ "' AND '" + DTOS(dVencFim) + "'"
	cQuery += "   AND E1_CLIENTE between '" + cCliDe + "' AND '" + cCliAte + "'"
	cQuery += "   AND E1_SALDO > "+Str(nlimite)
	If Subst(cTipoCob,1,1) == "P" //Se for primeira cobranca filtra pelos status cadastrados no parametro
		//		cQuery += "   AND E1_STATCOB IN ('"+cStatCob+"')"
		cQuery += "   AND E1_SITUACA = '0' " //Titulos em carteira
	else //Segunda Cobranca
		cQuery += "   AND E1_SITUACA = '1' AND E1_PORTADO = 'RET' " //Titulos com portador RET e situacao 5
		cQuery += "   AND NOT EXISTS	(SELECT ZZN_BCO	"
		cQuery += "   FROM "+	RetSqlName("ZZN") + " ZZN "
		cQuery += "   WHERE ZZN_PREFIX = E1_PREFIXO"
		cQuery += "   AND ZZN_NUM = E1_NUM"
		cQuery += "   AND ZZN_PARC = E1_PARCELA "
		cQuery += "   AND ZZN_TIPO = E1_TIPO"
		cQuery += "   AND ZZN_CLIENT = E1_CLIENTE"
		cQuery += "   AND ZZN_LOJA = E1_LOJA"
		cQuery += "   AND ZZN_TIPOOP = 'E'"
		cQuery += "   AND ZZN_BCO = '" + cPort060 + "'"
		cQuery += "   AND ZZN.D_E_L_E_T_ = '' )"
	Endif
	cQuery += "   AND SE1.D_E_L_E_T_ = '' "
	cQuery += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
	cQuery += "   AND A1_EST BETWEEN '" + cEstIni + "' AND '" + cEstFim + "'"
	If Subst(cTipoCli,1,1) == "F"
		cQuery += "   AND A1_PESSOA = 'F' "
	ElseIf Subst(cTipoCli,1,1) == "J"
		cQuery += "   AND A1_PESSOA = 'J' "
	Endif
	cQuery += "   AND SA1.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_VENCREA"
	
	cQuery := ChangeQuery(cQuery)
	
	dbSelectArea("SE1")
	dbCloseArea()
	dbSelectArea("SA1")
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F. , .T.)
	
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
	
	While !Eof() .and. SE1->E1_FILIAL >= cFilDe .and. SE1->E1_FILIAL <= cFilAte .and. DTOS(SE1->E1_VENCREA) <= DTOS(dVencFim)
		
		If SE1->E1_TIPO $ MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVENVBCOR
			dbSkip()
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar campos de TRB.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		For ni := 1 to SE1->(FCount())
			If TRB->(FieldName(nI)) == SE1->(FieldName(nI)) .And. TRB->(FieldName(nI)) <> 'E1_NOMCLI'
				If SE1->(ValType(FieldName(nI))) # "M"
					TRB->(FieldPut(nI,SE1->(FieldGet(ni))))
				EndIf
			EndIf
		Next
		TRB->E1_NOMCLI := SE1->A1_NOME
		TRB->RECSE1 	:= SE1->R_E_C_N_O_
		TRB->E1_OK  	:= Space(2)
		MsUnLock()
		dbSelectArea("SE1")
		dbSkip()
	Enddo
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(12)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existencia de registros no TRB.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbGotop()
	lSaida := .T.
	If BOF() .And. EOF()
		Help(" ",1,"RECNO")
		Exit
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Disparar chamada do Browse de sele‡Æo ou markBrowse para TRB.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpca := fA060MarkB("TRB",nLimite,dVencIni,dVencFim,cSituacao,oPrazoMed,ovalor,aCampos,cNumbor)
	If nOpca == 2
		Exit
	ElseIf nOpca == 0
		dbSelectArea("TRB")
		dbCloseArea()
		Ferase(cFileWork+".DBF")
		Ferase(cFileWork+OrdBagExt())
		dbSelectArea("SE1")
		dbSetOrder(nIndice)
		lSaida := .F.
		Loop
	EndIf
	dbSelectArea("SE1")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso o nenhum titulo tenha sido selecionado, n„o gera bordero³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nValor31 = 0 .and. Abs(nQtdTit31) = 0		// Nenhum titulo Selecionado
		Help(" ",1,"FA060VALOR")
		Exit
	EndIf
	
	nValCred := nValor31
	
	If nOpcA == 2
		dbSelectArea("TRB")
		dbCloseArea()
		Ferase(cFileWork+".DBF")
		Ferase(cFileWork+OrdBagExt())
		dbSelectArea("SE1")
		dbSetOrder(nIndice)
		lSaida := .F.
		Loop
	ElseIf nOpcA == 1
		lLanc  := .F.
		lSaida := .T.
		dbSelectArea( "SE5" )
		dbGoto(0)
		dbSelectArea("TRB")
		dbGoTop()
		While !Eof()
			dbSelectArea("SE1")
			dbGoto(TRB->RECSE1)
			IF TRB->E1_OK == cMarc31
				nC++
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica qual o Lanc Padrao que sera utilizado 	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				cPadrao:=fA060Pad(cSituacao)
				lPadrao:=VerPadrao(cPadrao)
				
				IF !lLanc .And. lPadrao
					lLanc:=.T.
					nHdlPrv:=HeadProva(cLote,"FINA060",Substr(cUsuario,7,6),@cArquivo)
				EndIF
				
				//Verifica qual e a proxima sequencia
				Dbselectarea("ZZN")
				Dbsetorder(1)
				Dbseek(xFilial()+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
				cSequen :=  ''
				While !eof() .And. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO == ZZN->ZZN_PREFIX+ZZN->ZZN_NUM+ZZN->ZZN_PARC+ZZN->ZZN_TIPO
					If ZZN->ZZN_SEQUEN > cSequen
						cSequen := ZZN->ZZN_SEQUEN
					Endif
					dbskip()
				End
				cSequen := SOMA1(cSequen,2)
				//Criar registro no controle de envio a cobranca externa
				RecLock("ZZN",.T.)
				ZZN->ZZN_FILIAL   := xFilial()
				ZZN->ZZN_PREFIX   := SE1->E1_PREFIXO
				ZZN->ZZN_NUM      := SE1->E1_NUM
				ZZN->ZZN_PARC     := SE1->E1_PARCELA
				ZZN->ZZN_TIPO     := SE1->E1_TIPO
				ZZN->ZZN_SALDO    := SE1->E1_SALDO
				ZZN->ZZN_SEQUEN   := cSequen
				ZZN->ZZN_CLIENT   := SE1->E1_CLIENTE
				ZZN->ZZN_LOJA	   := SE1->E1_LOJA
				ZZN->ZZN_BCO      := cPort060
				ZZN->ZZN_AGEN     := cAgen060
				ZZN->ZZN_CONTA    := cConta060
				ZZN->ZZN_SITUAC   := "5"
				ZZN->ZZN_BCOANT   := SE1->E1_PORTADO
				ZZN->ZZN_AGEANT   := SE1->E1_AGEDEP
				ZZN->ZZN_CONANT   := SE1->E1_CONTA
				ZZN->ZZN_SITANT   := SE1->E1_SITUACA
				ZZN->ZZN_DATA     := dDatabase
				ZZN->ZZN_TIPOOP   := "E"
				ZZN->ZZN_NUMBOR   := cNumBor
				MsUnlock()
				
				dbSelectArea("SE1")
				cSituant := SE1->E1_SITUACA
				RecLock("SE1",.F.)
				SE1->E1_PORTADO := cPort060
				SE1->E1_AGEDEP  := cAgen060
				SE1->E1_SITUACA := cSituacao
				SE1->E1_NUMBOR  := cNumBor
				SE1->E1_DATABOR := dDataBase
				SE1->E1_MOVIMEN := dDataBase
				SE1->E1_CONTA	 := cConta060
				
				MsUnlock()
				RecLock("SEA",.T.)
				SEA->EA_FILIAL  := xFilial()
				SEA->EA_NUMBOR  := cNumBor
				SEA->EA_DATABOR := dDataBase
				SEA->EA_PORTADO := cPort060
				SEA->EA_AGEDEP  := cAgen060
				SEA->EA_NUMCON  := cConta060
				SEA->EA_NUM 	 := SE1->E1_NUM
				SEA->EA_PARCELA := SE1->E1_PARCELA
				SEA->EA_PREFIXO := SE1->E1_PREFIXO
				SEA->EA_TIPO	 := SE1->E1_TIPO
				SEA->EA_CART	 := "R"
				SEA->EA_SITUACA := cSituacao
				IF FieldPos("EA_SITUANT") > 0
					SEA->EA_SITUANT := '0'
				Endif
				MsUnlock()
				
				//Informa envio do titulo no Siscob
				Dbselectarea("ZZ6")
				Dbsetorder(1)
				If Dbseek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
					mCob := ZZ6->ZZ6_MEMO
					mCob := Trim(ZZ6->ZZ6_MEMO)+IIF(!Empty(mCob),Chr(13)+chr(10),'') //Aplica um enter se ja tiver informacao
					mCob := Trim(mCob)+"Tit. "+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+;
					        " Enviado a cobranca Externa: "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+;
					         Trim(Subst(cUsuario,7,15))+" Para o Banco : "+cPort060+" Agencia : "+cAgen060+" Conta : "+cConta060
					
					Reclock("ZZ6",.F.)
					Replace ZZ6_MEMO With mCob
					Msunlock()
				Endif
				IF lPadrao
					nTotal+=DetProva(nHdlPrv,cPadrao,"FINA060",cLote)
				EndIF
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se vai baixar o titulo.             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				nValSaldo += SE1->E1_SALDO // Saldo do titulo para contabilizacao de diferenca
			endif
			
			dbSelectArea("TRB")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PONTO DE ENTRADA		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF ExistBlock("FA60BDE")
				ExecBlock("FA60BDE",.F.,.F.)
			Endif
			
			dbSkip()
		Enddo
		
		dbSelectArea("SE1")
		dbSetOrder(7)
		dbGoto(nRegSE1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona Registros para contabilizacao		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")
		dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
		dbSelectArea("SA6")
		dbSeek(cFilial+SE1->E1_PORTADO+SE1->E1_AGEDEP)
		dbSelectArea("SEA")
		dbGoto(nRegSEA)
		dbSelectArea("SE1")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia para Lancamento Contabil, se gerado arquivo   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF nC > 0 .And. lLanc
			RodaProva(nHdlPrv,nTotal)
			lDigita:= IIF(mv_par01==1,.T.,.F.)
			lAglut := IIF(mv_par02==1,.T.,.F.)
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut )
		EndIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o N£mero do bordero atualizado								  ³
		//³ Posicionar no sx6 sempre usando GetMv. N„o utilize Seek !!!  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX6")
		PutMv("MV_NUMBORR",cNumBor)
	EndIf
	Exit
EndDo
dbSelectArea("SX6")
GetMV("MV_NUMBORR")
MsUnlock()

IF lSaida
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura os indices 													  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cFileWork+".DBF")
	Ferase(cFileWork+OrdBagExt())
	dbSelectArea("SE1")
	dbSetOrder(nIndice)
EndIf

dbSelectArea("SE1")
dbSetOrder(nIndice)
Go nSavRec

Return( Nil )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA060Num ³ Autor ³ Eurivan Marques		  ³ Data ³ 11/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o N£mero do bordero informado existe			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ExpL1 := FA060Num(ExpC1)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = .T. se nao existir e .F. se existir					  ³±±
±±³			 ³ ExpC1 = N£mero do bordero informado 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA060																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA060Num(cNumBor)
PRIVATE lRetorna := .T.

dbSelectArea("SEA")
dbSetOrder(1)
dbSeek(cFilial+cNumBor,.t.)
Do While cFilial == EA_FILIAL .and. cNumBor == EA_NUMBOR .and. !eof()
	If EA_CART == "R"
		Help(" ",1,"F240BORDE")
		lRetorna := .F.
		Exit
	Endif
	DbSkip(1)
EndDO
DbSelectArea("SE1")

Return lRetorna

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA060DATA³ Autor ³ Eurivan Marques       ³ Data ³ 11/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se data final ‚ maior que data inicial 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA060DATa(ExpD1,ExpD2)												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data Inicial 												  ³±±
±±³			 ³ ExpD2 = Data Final													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA060																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA060DATA(dVencIni,dVencFim)
PRIVATE lRet:=.T.
IF dVencFim<dVencIni
	Help(" ",1,"DATAMENOR")
	lRet:=.F.
EndIF
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³F060Vld   ³ Autor ³ Eurivan Marques  	  ³ Data ³ 11/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida‡Æo de Banco e situa‡Æo na montagem do bordero       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F060Vld() 	                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA060																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function f060Vld(cBanco,cAgencia,cConta,cSitCombo)
PRIVATE lRet := .F.

If CarregaSa6(cBanco,cAgencia,cConta,.T.) .and. Substr(cSitCombo,1,1)$"5" .And. SA6->A6_COBEXT == "S"
	lRet := .T.
Else
	Help(" ",1,"BORD_TRANS")
Endif

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA060MarkB³ Autor ³ Eurivan Marques       ³ Data ³ 11/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ MarkBrowse para Windows 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA060																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060MarkB(cAlias,nLimite,dVencIni,dVencFim,cSituacao,oPrazoMed,oValor,aCampos,cNumBor)

Local nRec
Local oDlg1, nOpca, oFnt

DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD

nPrazo := 0
nValor31 := 0

dbSelectArea(cAlias)
bWhile := { || ! Eof() }
dbSeek(xFilial("SE1"))
nRec:=RecNo()
//DBEVAL( { |a| FA060DBEVA(nLimite,dVencIni,dVencFim,"TRB") } , bWhile )
dbGoto(nRec)
nOpca :=0
DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Bordero de Cobran‡a Externa") From 5,2 To 40,110 OF oMainWnd
@ 1.1 , 00.8 SAY OemToAnsi("Border“ N§") FONT oDlg1:oFont
@ 1.1 , 08   Say cNumbor				Picture "@!" FONT oFnt COLOR CLR_HBLUE
@ 1.8,.8 Say OemToAnsi("Valor Total:")
@ 1.8, 7 Say oValor VAR nValor31 Picture cPict06014 SIZE 60,8
@ 1.8,21 Say OemToAnsi("Quantidade:")
@ 1.8,32 Say oQtda VAR nQtdTit31 Picture "@E 99999" SIZE 50,8

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Dbselectarea(cAlias)

oMark := MsSelect():New(cAlias,"E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarc31,{35,10,260,425})

oMark:bMark := {| | fa060disp(cMarc31,lInverte,oValor,oQtda,oPrazoMed)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || COBC031Inverte(cMarc31,oValor,oQtda,oPrazoMed) }
ACTIVATE MSDIALOG oDlg1 ON INIT  FA060Bar(oDlg1,{|| nOpca := 1,If(ABS(NVALOR31)>0,oDlg1:End(),Help(" ",1,"FA060VALOR"))},;
{|| nOpca := 2,oDlg1:End()}, oMark, "SE1" )
Return nOpca

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa060Bar	³ Autor ³ Eurivan Marques       ³ Data ³11.04.05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra a EnchoiceBar na tela - WINDOWS 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060Bar(oDlg,bOk,bCancel,oMark,cAlias)

Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
DEFINE BUTTON RESOURCE "S4WB005N" OF oBar ACTION NaoDisp() TOOLTIP OemToAnsi("Recortar")
DEFINE BUTTON RESOURCE "S4WB006N" OF oBar ACTION NaoDisp() TOOLTIP OemToAnsi("Copiar")
DEFINE BUTTON RESOURCE "S4WB007N" OF oBar ACTION NaoDisp() TOOLTIP OemToAnsi("Colar")
DEFINE BUTTON RESOURCE "S4WB008N" OF oBar GROUP ACTION Calculadora() TOOLTIP OemToAnsi("Calculadora...")
DEFINE BUTTON RESOURCE "S4WB009N" OF oBar ACTION Agenda() TOOLTIP OemToAnsi("Agenda...")
DEFINE BUTTON RESOURCE "S4WB010N" OF oBar ACTION OurSpool() TOOLTIP OemToAnsi("Gerenciador de ImpressÆo...")
DEFINE BUTTON RESOURCE "S4WB016N" OF oBar GROUP ACTION HelProg() TOOLTIP OemToAnsi("Help de Programa...")
DEFINE BUTTON oBtnPsq RESOURCE "S4WB011N" OF oBar ACTION Fa060Pesq(oMark, cAlias) TOOLTIP OemToAnsi("Pesquisar..(CTRL-P)")
DEFINE BUTTON RESOURCE "PRECO" OF oBar ACTION Siscob() TOOLTIP OemToAnsi("Siscob")

SetKey(16,oBtnPsq:bAction)
oBar:nGroups += 6
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP OemToAnsi("Confirma - <Ctrl-O>")
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //

SetKEY(24,oBtCan:bAction)
oDlg:bSet15 := oBtOk:bAction
oDlg:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}
Return nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA060Disp ³ Autor ³ Eurivan Marques       ³ Data ³ 11/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA060																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060Disp(cMarc31,lInverte,oValor,oQtda,oPrazoMed)
Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
If !Empty(TRB->E1_OK) .And. TRB->E1_OK <> cMarc31
	cMarc31 := TRB->E1_OK
Endif
If IsMark("E1_OK",cMarc31,lInverte)
	If E1_TIPO $ MVABATIM
		nValor31 -= E1_SALDO
		If VALTYPE(oPrazoMed) == "O"
			If ExistBlock("F060DPM")
				nData := ExecBlock("F060DPM",.F.,.F.)
			Else
				nData := E1_VENCREA - E1_EMISSAO
			Endif
			nPrazo	-= ( nData * E1_SALDO )
		EndIf
	Else
		nValor31 += E1_SALDO
		If VALTYPE(oPrazoMed) == "O"
			If ExistBlock("F060DPM")
				nData := ExecBlock("F060DPM",.F.,.F.)
			Else
				nData := E1_VENCREA - E1_EMISSAO
			Endif
			nPrazo	+= ( nData * E1_SALDO )
		EndIf
	EndIf
	nQtdTit31++
Else
	If E1_TIPO $ MVABATIM
		nValor31 += E1_SALDO
		If VALTYPE(oPrazoMed) == "O"
			If ExistBlock("F060DPM")
				nData := ExecBlock("F060DPM",.F.,.F.)
			Else
				nData := E1_VENCREA - E1_EMISSAO
			Endif
			nPrazo	+= ( nData * E1_SALDO )
		EndIF
	Else
		nValor31 -= E1_SALDO
		If VALTYPE(oPrazoMed) == "O"
			If ExistBlock("F060DPM")
				nData := ExecBlock("F060DPM",.F.,.F.)
			Else
				nData := E1_VENCREA - E1_EMISSAO
			Endif
			nPrazo	-= ( nData * E1_SALDO )
		EndIf
	EndIf
	nQtdTit31--
	nQtdTit31:= Iif(nQtdTit31<0,0,nQtdTit31)
Endif
oValor:Refresh()
oQtda:Refresh()

If VALTYPE(oPrazoMed) == "O"
	If nValor31 != 0
		nPrazoMed := nPrazo / nValor31
	Else
		nPrazoMed := 0
	EndIf
	oPrazoMed:Refresh()
EndIf

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA060Inver³ Autor ³ Eurivan Marques       ³ Data ³ 17/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inverte marcacoes - Windows										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA060																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function COBC031Inverte(cMarc31,oQtda)

Local nReg   := TRB->(Recno())
Local cAlias := Alias()
dbSelectArea("TRB")

While !Eof()
	RecLock("TRB", .F.)
	If !Empty(TRB->E1_OK) .And. TRB->E1_OK <> cMarc31
		cMarc31 := TRB->E1_OK
	Endif
	
	
	If IsMark("E1_OK", cMarc31, lInverte) .Or. lInverte
		Replace E1_OK With Space(2)
	Else
		Replace E1_OK With cMarc31
	Endif
	MsUnLock()
	If E1_OK == cMarc31
		nValor31 += E1_SALDO
		nQtdTit31++
	Else
		nValor31 -= E1_SALDO
		nQtdTit31--
		nQtdTit31:= Iif(nQtdTit31<0,0,nQtdTit31)
	Endif
	dbSkip()
Enddo
TRB->(dbGoto(nReg))
oQtda:Refresh()
oMark:oBrowse:Refresh(.t.)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBC031   ºAutor  ³Microsiga           º Data ³  06/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Siscob()


aAreaATU := GetArea()

Dbselectarea("SA1")
Dbsetorder(1)
If Dbseek(Xfilial()+TRB->E1_CLIENTE+TRB->E1_LOJA)
	//Chama funcao do Siscob
	U_COBC011()
Else
	Alert("Cliente nao encontrado!!!")
Endif

RestArea(aAreaATU)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa060Pesq ³ Autor ³ Eurivan Marques       ³ Data ³08.02.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ tela de pesquisa - WINDOWS 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060Pesq(oMark, cAlias)
Local cAliasAnt := Alias(),;
nRecno				  ,;
nRecTrb				  ,;
cCampos

DbSelectArea(cAlias)
nRecno  := Recno()
nRecTrb := TRB->(RecNo())
cCampos := TRB->(IndexKey())
// Obtem os campos de pesquisa de cAlias, para pesquisar no TRB, pois
// os indice do TRB eh unico (FILIAL+PREFIXO+NUMERO+PARCELA+TIPO) e em
// AxPesqui, o usuario pode escolher a chave desejada.
TCampos := cAlias + "->(" + cCampos + ")"

AxPesqui()  

// Posiciona no TRB o conteudo do registro de cAlias
If !TRB->(DbSeek(XFilial("SE1")+Se1->e1_cliente+Se1->e1_LOJA,.f.))
	dbGoto(nRecNo)
	Trb->(DbGoto(nRecTrb))
Endif
oMark:oBrowse:Refresh(.T.)

DbSelectArea(cAliasAnt)

Return Nil

