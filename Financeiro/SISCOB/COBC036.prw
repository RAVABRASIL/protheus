#INCLUDE "RWMAKE.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Carga Expirada                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rava Embalagens - Cobranca                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COBC036()

PRIVATE cMarca   := GetMark()
PRIVATE lInverte := .F.
PRIVATE VALOR	  := 0
PRIVATE nIndice	:= 2 //Cliente + loja + prefixo + numero + parcela + tipo
PRIVATE cCadastro := OemToAnsi("Carga Expirada - Cobranca Externa")

PRIVATE nMoeda:=1
PRIVATE cPort036:=Space(3),cAgen036:=Space(05),cConta036:=Space(10)
PRIVATE nLimite:=0,nC:=0
PRIVATE lSaida:=.F.
PRIVATE aStru,aCampos:={},cFileWork, cAliasTRB, cCampo
PRIVATE nRec
PRIVATE ni, nJ
PRIVATE nRegSE1 :=0

PRIVATE cTipoCli, TipoCob
PRIVATE oValor, oQtda, oPrazoMed
PRIVATE bWhile
PRIVATE oCbx

While .T.
	
	dbSelectArea( "SE1" )
	nSavRec := RecNo()
	VALOR   := 0
	nOpca   := 0
	nDias   := 0
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Border“ - Cobranca Externa") FROM 5,0 To 23,65 OF oMainWnd
	
	@ 1.0, 2   Say OemToAnsi("Banco ")
	@ 1.0, 7.5 MSGET cPort036  Picture "@!" F3 "EXT" Valid CarregaSa6(@cPort036,@cAgen036,@cConta036,.F.) SIZE 10,10
	@ 1.0,12.5 Say OemToAnsi("Agˆncia")
	@ 1.0,15.4 MSGET cAgen036	Picture "@!"  Valid CarregaSa6(@cPort036,@cAgen036,@cConta036,.F.)
	@ 1.0,21.0 Say OemToAnsi("Conta")
	@ 1.0,24.0 MSGET cConta036 Picture "@!"  Valid CarregaSa6(@cPort036,@cAgen036,@cConta036,.F.) SIZE 55,10

	@ 2.0, 2   Say OemToAnsi("Dias de Envio")
	@ 2.0, 7.5 MSGET nDias  Picture "@E 9,999" Valid nDias > 0 SIZE 10,10
	
	@	 .2,.5 TO 08.5,31.7 OF oDlg
	
	DEFINE SBUTTON FROM 119,176.4 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 119,203.3 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED VALID (iif(nOpca==1,F060Vld(cPort036,cAgen036,cConta036,'5'),.t.))
	
	If nOpca == 0
		Return
	Endif
	
	nQtdTit := 0
	nValor  := 0
	dDiaAnt := dDatabase - nDias
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem de array para tratamento na MarkBrowse com o arquivo TRB  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
	//³ Posicionar em SE1 no primeiro registro que satisfa‡a a condi‡Æo  ³
	//³ de filtro considerando E1_NUMBOR = "      " (Space(6)).          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(7)            // Chave (Vencimento)
	
	cQuery := "SELECT SE1.* "
	cQuery += "  FROM "+	RetSqlName("SE1") + " SE1, "+RetSqlName("SA1") + " SA1"
	cQuery += " WHERE E1_PORTADO = '"+cPort036+"' "
	cQuery += "   AND E1_AGEDEP  = '"+cAgen036+"' "
	cQuery += "   AND E1_CONTA   = '"+cConta036+"' "
	cQuery += "   AND E1_SALDO > 0 "
	cQuery += "   AND SE1.D_E_L_E_T_ = '' "
	cQuery += "   AND (SELECT MAX(ZZN_DATA)"
	cQuery += "   FROM "+RetSqlName("ZZN") + " ZZN"
	cQuery += "   WHERE ZZN.ZZN_PREFIX = E1_PREFIXO"
	cQuery += "   AND ZZN.ZZN_NUM = E1_NUM"
	cQuery += "   AND ZZN.ZZN_PARC = E1_PARCELA"
	cQuery += "   AND ZZN.ZZN_TIPO = E1_TIPO"
	cQuery += "   AND ZZN_CLIENT = E1_CLIENTE"
	cQuery += "   AND ZZN_LOJA = E1_LOJA"
	cQuery += "   AND ZZN_TIPOOP = 'E'"
	cQuery += "   AND ZZN_BCO = E1_PORTADO"
	cQuery += "   AND ZZN.D_E_L_E_T_ = ''"
	cQuery += "   ) < '"+Dtos(dDiaAnt)+"'	"
	cQuery += "   AND E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA"
	cQuery += "   AND SA1.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_VENCREA"
	
	cQuery := ChangeQuery(cQuery)
	
	dbSelectArea("SE1")
	dbCloseArea()
	dbSelectArea("SA1")
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
	
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
	
	While !Eof()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar campos de TRB.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		For ni := 1 to SE1->(FCount())
			If TRB->(FieldName(nI)) == SE1->(FieldName(nI))
				If SE1->(ValType(FieldName(nI))) # "M"
					TRB->(FieldPut(nI,SE1->(FieldGet(ni))))
				EndIf
			EndIf
		Next
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
	nOpca := fA060MarkB("TRB",nLimite,ovalor,aCampos)
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
	If nValor = 0 .and. Abs(nQtdTit) = 0		// Nenhum titulo Selecionado
		MsgBox("Nenhum Titulo Selecionado","INFO")
		Exit
	EndIf
	
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
		dbSelectArea( "SE5" )
		dbGoto(0)
		dbSelectArea("TRB")
		dbGoTop()
		While !Eof()
			dbSelectArea("SE1")
			dbGoto(TRB->RECSE1)
			IF TRB->E1_OK == cMarca
				nC++
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
				ZZN->ZZN_BCO      := 'RET'
				ZZN->ZZN_AGEN     := '00000'
				ZZN->ZZN_CONTA    := '0000000000'
				ZZN->ZZN_SITUAC   := '1'
				ZZN->ZZN_BCOANT   := SE1->E1_PORTADO
				ZZN->ZZN_AGEANT   := SE1->E1_AGEDEP
				ZZN->ZZN_CONANT   := SE1->E1_CONTA
				ZZN->ZZN_SITANT   := SE1->E1_SITUACA
				ZZN->ZZN_DATA     := dDatabase
				ZZN->ZZN_TIPOOP   := "R"
				ZZN->ZZN_NUMBOR   := ''
				MsUnlock()
				
				//Apaga registro no SEA (Titulos enviados ao banco)
				Dbselectarea("SEA")
				dbsetorder(1)
				If Dbseek(xFilial()+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					RecLock("SEA",.f.)
					dbdelete()
					MsUnlock()
				Endif        

				dbSelectArea("SE1")
				RecLock("SE1",.F.)
				SE1->E1_PORTADO := 'RET'
				SE1->E1_AGEDEP  := '00000'
				SE1->E1_SITUACA := '1'
				SE1->E1_NUMBOR  := ''
				SE1->E1_DATABOR := CTOD("")
				SE1->E1_MOVIMEN := dDataBase
				SE1->E1_CONTA	 := '0000000000'
				MsUnlock()

				//Informa envio do titulo no Siscob
				Dbselectarea("ZZ6")
				Dbsetorder(1)
				If Dbseek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
				
					mCob := ZZ6->ZZ6_MEMO
					mCob := Trim(ZZ6->ZZ6_MEMO)+IIF(!Empty(mCob),Chr(13)+chr(10),'') //Aplica um enter se ja tiver informacao
					mCob := Trim(mCob)+"Tit. "+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+" Devolvido cobranca Externa: "+cPort036+" - "+DtoC(dDatabase)+" (  "+Time()+ " ) - Pelo Usuario - "+ Trim(Subst(cUsuario,7,15))
					
					Reclock("ZZ6",.F.)
					Replace ZZ6_MEMO With mCob
					Msunlock()
				Endif
				
			endif
			
			dbSelectArea("TRB")
			
			dbSkip()
		Enddo
		
		dbSelectArea("SE1")
		dbSetOrder(7)
		dbGoto(nRegSE1)
		
	EndIf
	Exit
EndDo
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
EndIF

dbSelectArea("SE1")
dbSetOrder(nIndice)
Go nSavRec

Return( Nil )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³F060Vld   ³ Autor ³ Eurivan Marques   	  ³ Data ³ 11/04/05 ³±±
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

If CarregaSa6(cBanco,cAgencia,cConta,.T.) .and. Substr(cSitCombo,1,1)$"5"
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
Static Function Fa060MarkB(cAlias,nLimite,oValor,aCampos)

Local nRec
Local oDlg1, nOpca, oFnt

DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD

nValor := 0

dbSelectArea(cAlias)
bWhile := { || ! Eof() }
dbSeek(xFilial("SE1"))
nRec:=RecNo()
dbGoto(nRec)
nOpca :=0
DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Retorno - Cobran‡a Externa") From 5,2 To 40,110 OF oMainWnd
@ 1.1 , 00.8 SAY OemToAnsi("Portador") FONT oDlg1:oFont
@ 1.1 , 08   Say cPort036+	" - "+SA6->A6_NOME Picture "@!" FONT oFnt COLOR CLR_HBLUE
@ 1.8,.8 Say OemToAnsi("Valor Total:")
@ 1.8, 7 Say oValor VAR nValor Picture "@E 999,999.99" SIZE 60,8
@ 1.8,21 Say OemToAnsi("Quantidade:")
@ 1.8,32 Say oQtda VAR nQtdTit Picture "@E 99999" SIZE 50,8

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Dbselectarea(cAlias)

oMark := MsSelect():New(cAlias,"E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarca,{35,10,260,425})

oMark:bMark := {| | fa060disp(cMarca,lInverte,oValor,oQtda)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || COBC036Inverte(cMarca,oValor,oQtda) }
ACTIVATE MSDIALOG oDlg1 ON INIT  FA060Bar(oDlg1,{|| nOpca := 1,If(ABS(NVALOR)>0,oDlg1:End(),Help(" ",1,"FA060VALOR"))},;
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
DEFINE BUTTON oBtnImp RESOURCE "S4WB011N" OF oBar ACTION COBC036IMP(oMark, cAlias) TOOLTIP OemToAnsi("Imprimir..(CTRL-P)")
DEFINE BUTTON oBtnPsq RESOURCE "AUTOM" OF oBar ACTION Fa060Pesq(oMark, cAlias) TOOLTIP OemToAnsi("Pesquisar..(CTRL-P)")
SetKey(16,oBtnImp:bAction)

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
Static Function Fa060Disp(cMarca,lInverte,oValor,oQtda)
If IsMark("E1_OK",cMarca,lInverte)
	nValor += E1_SALDO
	nQtdTit++
Else
	nValor -= E1_SALDO
	nQtdTit--
	nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
Endif

oValor:Refresh()
oQtda:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBC036   ºAutor  ³Microsiga           º Data ³  05/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function COBC036IMP()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Carga Expirada"
Local cPict          := ""
Local titulo       := "Carga Expirada"
Local nLin         := 80

local cabec1       := "UF Codigo Lj Nome do Cliente                          Contato         CGC/CPF         Telefone        Endereco                                 Bairro                    Municipio            CEP     "
//                     12 123456 12 1234567890123456789012345678901234567890 123456789012345 123456789012345 123456789012345 1234567890123456789012345678901234567890 1234567890123456789012345 12345678901234567890 12345678
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
Local Cabec2       := "Prf  Numero  P  Tipo  Emissao    Vencto          Valor     Saldo"
//                     123  123456  1  123   99/99/9999 99/99/9999 999,999.99 999,999.99
//                     0123456789012345678901234567890123456789012345678901234567890123456
//                               1         2         3         4         5         6

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "CARGA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CARGA" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cComple1 :=Space(79)
PRIVATE cComple2 :=Space(79)
PRIVATE cComple3 :=Space(79)

//Verifica se algum titulo foi selecionado
IF nQtdTit <= 0
	MsgBox("Nenhum Titulo Selecionado","ALERT")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := "SE1"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

DEFINE MSDIALOG oDlg FROM  92,70 TO 221,463 TITLE OemToAnsi("Mensagem Complementar") PIXEL
@ 09, 02 SAY "Linha 1" SIZE 24, 7 OF oDlg PIXEL
@ 24, 02 SAY "Linha 2" SIZE 25, 7 OF oDlg PIXEL
@ 38, 03 SAY "Linha 3" SIZE 25, 7 OF oDlg PIXEL
@ 07, 31 MSGET cComple1 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
@ 21, 31 MSGET cComple2 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
@ 36, 31 MSGET cComple3 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL

DEFINE SBUTTON FROM 50, 139 TYPE 1 ENABLE OF oDlg ACTION (nOpca:=1,oDlg:End())
DEFINE SBUTTON FROM 50, 167 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca#1
	cComple1 :=""
	cComple2 :=""
	cComple3 :=""
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea("TRB")
SetRegua(nQtdTit)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@ nlin, 000 pSay "Ao Portador "+SA6->A6_NOME
nLin ++ // Avanca a linha de impressao
@ nlin, 000 pSay "Titulos com Carga Expirada: "
nlin ++
If !Empty(cComple1) .Or. !Empty(cComple2) .Or. !Empty(cComple3)
	@ nlin, 000 pSay "Observacoes:"
	nlin++
	@ nlin, 000 pSay cComple1
	nlin++
	@ nlin, 000 pSay cComple2
	nlin++
	@ nlin, 000 pSay cComple3
	nlin ++
Endif
nlin ++
@ nlin,000 pSay Replicate("-",220)
nlin ++
@ nlin,000 pSay "DETALHES DOS CLIENTES: "
nlin ++
@ nlin,000 pSay Replicate("-",220)
nlin += 2

nValTot := 0

While !EOF()
	
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
		nLin := 9
	Endif
	
	//Se nao foi selecionado, pula o registro
	IF TRB->E1_OK <> cMarca
		dbskip()
		Loop
	Endif
	
	cCliente := E1_CLIENTE
	cloja    := E1_LOJA
	Dbselectarea("SA1")
	Dbsetorder(1)
	Dbseek(xFilial()+cCliente+cLoja)
	
	@ nlin,000 pSay SA1->A1_CEST     Picture "@!"
	@ nlin,003 pSay SA1->A1_COD      Picture "@!"
	@ nlin,010 pSay SA1->A1_LOJA     Picture "@!"
	@ nlin,013 pSay Subst(SA1->A1_NOME,1,40)     Picture "@!"
	@ nlin,054 pSay Subst(SA1->A1_CONTATO,1,15)  Picture "@!"
	@ nlin,070 pSay SA1->A1_CGC      Picture "@!"
	@ nlin,086 pSay Subst(SA1->A1_TEL,1,15)      Picture "@!"
	@ nlin,102 pSay Subst(SA1->A1_END,1,40)      Picture "@!"
	@ nlin,143 pSay Subst(SA1->A1_BAIRRO,1,25)   Picture "@!"
	@ nlin,169 pSay Subst(SA1->A1_MUN,1,20)      Picture "@!"
	@ nlin,190 pSay SA1->A1_CEP      Picture "@!"
	nlin ++
	nTotCli := 0
	Dbselectarea("TRB")
	While !eof() .And. TRB->E1_CLIENTE+TRB->E1_LOJA == cCliente+cLoja
		
		IncRegua()
		
		//Se nao foi selecionado, pula o registro
		IF TRB->E1_OK <> cMarca
			dbskip()
			Loop
		Endif
		
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
			nLin := 9
		Endif
		
		@ nlin,000 pSay TRB->E1_PREFIXO  Picture "@!"
		@ nlin,005 pSay TRB->E1_NUM      Picture "@!"
		@ nlin,013 pSay TRB->E1_PARCELA  Picture "@!"
		@ nlin,016 pSay TRB->E1_TIPO     Picture "@!"
		@ nlin,022 pSay TRB->E1_EMISSAO
		@ nlin,033 pSay TRB->E1_VENCREA
		@ nlin,044 pSay TRB->E1_VALOR    Picture "@E 999,999.99"
		@ nlin,055 pSay TRB->E1_SALDO    Picture "@E 999,999.99"
		nValTot += TRB->E1_SALDO
		nTotCli += TRB->E1_SALDO
		nlin ++
		dbSkip() // Avanca o ponteiro do registro no arquivo
	End
	@ nlin,000 pSay "Total do cliente: "
	@ nlin,055 pSay nTotCli Picture "@E 999,999.99"
	nlin ++
	@ nlin,000 pSay Replicate("-",220)
	nlin += 2
End

nlin += 2
@ nlin,000 pSay "Titulos Expirados : " + Transform(nQtdTit,"@E 9,999")
nlin++
@ nlin,000 pSay "Total Geral      : "+Transform(nValTot,"@E 999,999.99")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
Static Function COBC036Inverte(cMarca,ovalor,oQtda)

Local nReg   := TRB->(Recno())
Local cAlias := Alias()
dbSelectArea("TRB")
While !Eof()
	RecLock("TRB", .F.)
	If IsMark("E1_OK", cMarca, lInverte) .Or. lInverte
		Replace E1_OK With Space(2)
	Else
		Replace E1_OK With cMarca
	Endif
	MsUnLock()
	If E1_OK == cMarca
		nValor += E1_SALDO
		nQtdTit++
	Else
		nValor -= E1_SALDO
		nQtdTit--
		nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
	Endif
	dbSkip()
Enddo
TRB->(dbGoto(nReg))
oValor:Refresh()
oQtda:Refresh()
oMark:oBrowse:Refresh(.t.)

Return Nil


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
