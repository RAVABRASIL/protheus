#include "FINA680A.CH"
#Include "FILEIO.CH"
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FINA680A ³ Autor ³ Alessandro de Farias  ³ Data ³ 11.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Bancario - Via CNAB                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINA680A                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FINA680A()

Private oLeTxt
Private cString := "Z15"

dbSelectArea(cString)
//dbSetOrder(1)

ValidPerg("FIN68A")
Pergunte("FIN68A",.F.)

@ 200,001 TO 380,390 DIALOG oLeTxt TITLE OemToAnsi("Captura do Extrato Bancario")
@ 002,010 TO 080,185
@ 010,015 Say " Este programa ira ler o conteudo de um arquivo texto, conforme os"
@ 018,015 Say " parametros definidos pelo usuario.                               "
@ 026,015 Say "                                                                  "

@ 070,088 BMPBUTTON TYPE 01 ACTION OkLeTxt() // 01
@ 070,118 BMPBUTTON TYPE 11 ACTION Perg()
@ 070,148 BMPBUTTON TYPE 02 ACTION Close(oLeTxt) // 02

Activate Dialog oLeTxt Centered

Return

Static Function Perg

pergunte("FIN68A",.T.)

Return

Static Function OkLeTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros 		³
//³ mv_par01       // Do Banco         	   ³
//³ mv_par02       // Da Agencia       	   ³
//³ mv_par03       // Da Conta       	      ³
//³ mv_par04       // Arquivo Config   	   ³
//³ mv_par05       // Arquivo Extrato  	   ³
//³ mv_par06       // Padrao Banco/Febraban  ³
//³ mv_par07       // Data do Extrato        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| Fin680aProc() },"Processando...")

Return


***************
Static Function ValidPerg(cPerg)
***************

PutSx1(cPerg,'01','Do Banco              ?','Do Banco              ?','Do Banco              ?','mv_ch1','C',03,0,1,'G','','SA6','','','mv_par01',''     ,'','','',''        ,'','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'02','Da Agencia            ?','Da Agencia            ?','Da Agencia            ?','mv_ch2','C',05,0,1,'G','',''   ,'','','mv_par02',''     ,'','','',''        ,'','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'03','Da Conta              ?','Da Conta              ?','Da Conta              ?','mv_ch3','C',10,0,2,'G','',''   ,'','','mv_par03',''     ,'','','',''        ,'','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'04','Arquivo Config        ?','Arquivo Config        ?','Arquivo Config        ?','mv_ch4','C',20,0,2,'G','',''   ,'','','mv_par04',''     ,'','','',''        ,'','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'05','Arquivo Extrato       ?','Arquivo Extrato       ?','Arquivo Extrato       ?','mv_ch5','C',20,0,2,'G','',''   ,'','','mv_par05',''     ,'','','',''        ,'','','','','','','','','','','',{},{},{})
PutSx1(cperg,'06','Padrao Banco/Febraban ?','Padrao Banco/Febraban ?','Padrao Banco/Febraban ?','mv_ch5','N',01,0,1,'C','',''   ,'','','mv_par06','Banco','','','','Febraban','','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'07','Data do Extrato       ?','Data do Extrato       ?','Data do Extrato       ?','mv_ch7','D',08,0,2,'G','',''   ,'','','mv_par07',''     ,'','','',''        ,'','','','','','','','','','','',{},{},{})

Return Nil


Static Function Fin680aProc()

LOCAL nHdlConf
LOCAL nHdlBco
LOCAL cData, dData , nValor , nTotCred , nTotDeb, dDataf
LOCAL nLidos := 0
LOCAL aPosicoes:={ }
LOCAL nSaldoInicial := 0
Local cSitLanc := ""
Local cCtaArq := ""
Local cAgeArq := ""
Local nValPagTit :=  nValPagCheq := nValRecTit := nValPagTed := nDarfValPag := nINSSValPag := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no cadastro de bancos.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! SA6->(dbSeek( xFilial("SA6")+mv_par01+mv_par02+mv_par03 ) )
	Help(" ",1, "AFR680BCO" )
	Return
Endif
dbSelectArea("SEE")
If ! SEE->(dbSeek(xFilial("SEE")+mv_par01+mv_par02+mv_par03))
	//Help(" ",1,"PAR150")
	//Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo Configurador.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdlConf := Fopen(Alltrim(mv_par04) ,64)
If nHdlConf < 0
	Help(" ",1, "AFR680CFG" )
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo Configurador.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdlBco := Fopen( Alltrim(mv_par05) ,64)
If nHdlBco < 0
	Help(" ",1, "AFR680BCO" )
	Return
Endif
/*
cArqCNAB := Substr(Alltrim(mv_par05),3,7) // para o banco bradesco os 2 primeiros caracteres sao "CC2302A00.RET"
dDtMov := Ctod(Substr(cArqCNAB,1,2)+"/"+SubStr(cArqCNAB,3,2)+"/"+Strzero(Year(dDataBase),4,0),"ddmmyy" ) // melhorar depois
*/

dDtMov := mv_par07

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ja existe movimento.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Z15->( DbSeek( xFilial("Z15")+mv_par01+mv_par02+mv_par03+DTOS(dDtMov)+"0" ) )
	Help(" ",1,"CHK200FILE")  // Arquivo de Trans.Banc. j  processado
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le arquivo de configuracao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLidos:=0
Fseek(nHdlConf,0,0)
nTamArq:=FSEEK(nHdlConf,0,2)
Fseek(nHdlConf,0,0)

Do While nTamArq >= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de qual registro foi lido ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer := Space(85)
	FREAD(nHdlConf,@xBuffer,85)
	IF SubStr(xBuffer,1,1) == CHR(1)
		nTamArq-=85
		Loop
	EndIF
	Aadd( aPosicoes, { Substr(xBuffer,2,15),Val(Substr(xBuffer,17,3)),1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3))) })
	nTamArq -=85
	
Enddo

nTamArq := Fseek( nHdlBco,0, 2 )
Fseek( nHdlBco, 0, 0 )
nBytes := 0
nTamLin := IIF(SEE->EE_BYTESXT > 0, 202, 202 )
xBuffer := Space(nTamLin)				// Registro Header
Fread( nHdlBco, @xBuffer, nTamLin )

ProcRegua(nTamArq/Len(xBuffer)) // Numero de registros a processar

Do While .T.
	
	xBuffer := Space( nTamLin )			// Lancamentos
	Fread( nHdlBco, @xBuffer, nTamLin )
	
	If	Empty(xBuffer)
		Exit
	Endif
	
	RecLock("Z15",.T.)
	Z15->Z15_FILIAL  := xFilial("Z15")
	Z15->Z15_BANCO   := mv_par01
	Z15->Z15_AGENCI  := mv_par02
	Z15->Z15_NUMCON  := mv_par03
	Z15->Z15_ARQCNA  := Alltrim(MV_PAR05)
	Z15->Z15_DTCNAB  := dDtMov
	
	If (SubStr(xBuffer,1,1) == "1" .And. SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3]) == "0")
		// SALDO INICIAL
		cData 	:= SubStr(xBuffer,aPosicoes[6,2],aPosicoes[6,3] )
		dData 	:= CtoD(Substr(cData,1,2)+"/"+SubStr(cData,3,2)+"/"+SubStr( cData,5,4),"ddmmyy" )
		cSitLanc := SubStr(xBuffer,aPosicoes[7,2],aPosicoes[7,3] )
		nSaldoInicial := Val(SubStr(xBuffer,aPosicoes[5,2],aPosicoes[5,3] ))/100
		
		Z15->Z15_DOCUME  := "000000"
		Z15->Z15_HIST    := "SALDO INICIAL"
		Z15->Z15_DATA    := dData
		Z15->Z15_TIPO    := "0"
		Z15->Z15_VALOR   := nSaldoInicial
		Z15->Z15_TPDC    := cSitLanc
		
		IncProc()
		
	ElseIf (SubStr(xBuffer,1,1) == "1" .And. SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3]) == "1")
		// LANCAMENTOS
		cCodMov	:= Substr(xBuffer,aPosicoes[11,2],aPosicoes[11,3])
		cData  	:= SubStr(xBuffer,aPosicoes[9,2],aPosicoes[9,3] )
		cData  	:= ChangDate(cData,SEE->EE_TIPODAT)
		dData  	:= CtoD(Substr( cData,1,2)+"/"+SubStr( cData,3,2)+"/"+SubStr( cData,5,4),"ddmmyy" )
		cNum   	:= SubStr(xBuffer,aPosicoes[8,2],aPosicoes[8,3] )
		cDesc  	:= SubStr(xBuffer,aPosicoes[12,2],aPosicoes[12,3] )
		nValor 	:= Val(SubStr(xBuffer,aPosicoes[10,2],aPosicoes[10,3] ))/100
		cSitLanc := SubStr(xBuffer,43,1 )
		If cSitLanc == "2"
			nSaldoInicial += nValor
		Else
			nSaldoInicial -= nValor
		Endif
		
		Z15->Z15_DATA    := dData
		Z15->Z15_DOCUME  := cNum
		Z15->Z15_TIPO    := "1"
		Z15->Z15_HIST    := Substr(cDesc,1,30)//+SubStr(xBuffer,106, 25 )
		Z15->Z15_VALOR   := nValor
		Z15->Z15_TPDC    := cSitLanc
		If  Alltrim(Substr(cDesc,1,30)) $ "PAGTO TIT*PAGAMENT TITULO"
			nValPagTit += nValor
		ElseIf "DARF" $ Substr(cDesc,1,30) .And. cSitLanc == "1"
			nDarfValPag += nValor
		ElseIf "INSS" $ Substr(cDesc,1,30) .And. cSitLanc == "1"
			nINSSValPag += nValor
		ElseIf "TED" $ Left(Substr(cDesc,1,30),3) .And. cSitLanc == "1"
			nValPagTed += nValor
		ElseIf "COBRANCA" $ Substr(cDesc,1,30) .And. cSitLanc == "2"
			nValRecTit += nValor
		ElseIf "FOLHA" $ Substr(cDesc,1,30)
			RecFolha(nValor)
		ElseIf "CH PAGO" $ Substr(cDesc,1,30) .Or. "CH COMPE" $ Substr(cDesc,1,30)
			nValPagCheq += nValor
			SE5->( dbSetOrder(12) )     // R4. // E5_FILIAL, E5_NUMCHEQ, E5_BANCO, E5_AGENCIA, E5_CONTA
			cSeek := xFilial("SE5") + cNum + Space(09) + mv_par01 + mv_par02 + mv_par03
			If SE5->( dbSeek( cSeek ) )
				Do While ! SE5->( Eof() ) .And. ;
					cSeek == SE5->E5_FILIAL+SE5->E5_NUMCHEQ+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
					IF SE5->E5_TIPODOC $ 'CH*PA' .OR. (SE5->E5_TIPODOC == 'VL' .AND. SE5->E5_MOTBX='NOR')
						RecLock("SE5",.F.)
						SE5->E5_RECONC := 'x'
						SE5->( MSUnLock() )
					Endif
					SE5->( DbSkip() )
				EndDo
			EndIf
		Endif
		
		IncProc()
		
	ElseIf (SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3]) == "2")
		// SALDO FINAL
		cSitLanc := SubStr(xBuffer,aPosicoes[16,2],aPosicoes[16,3] )
		nValor := Val(SubStr(xBuffer,aPosicoes[15,2],aPosicoes[15,3] ))/100
		cData := SubStr(xBuffer,aPosicoes[14,2],aPosicoes[14,3] )
//		cData := ChangDate(cData,SEE->EE_TIPODAT)
		dData := CtoD(Substr( cData,1,2)+"/"+SubStr( cData,3,2)+"/"+SubStr( cData,5,4),"ddmmyy" )
		dDataf:= dData
		
		Z15->Z15_DOCUME  := "999999"
		Z15->Z15_HIST  	 := "SALDO FINAL"
		Z15->Z15_DATA    := dData
		Z15->Z15_TIPO    := "2"
		Z15->Z15_VALOR   := nValor
		Z15->Z15_TPDC    := cSitLanc
		
	ElseIf (SubStr(xBuffer,1,1) == "9")
		// TOTAL DOS CREDITOS E DEBITOS
		nTotCred := Val(SubStr(xBuffer,aPosicoes[19,2],aPosicoes[19,3] ))/100
		nTotDeb  := Val(SubStr(xBuffer,aPosicoes[18,2],aPosicoes[18,3] ))/100
		
		Z15->Z15_DOCUME  := ""
		Z15->Z15_HIST  	 := "TOTAL DOS CREDITOS E DEBITOS"
		Z15->Z15_DATA    := dDataf
		Z15->Z15_TIPO    := "9"
		Z15->Z15_TOTDEB  := Val(SubStr(xBuffer,aPosicoes[18,2],aPosicoes[18,3] ))/100
		Z15->Z15_TOTCRE  := Val(SubStr(xBuffer,aPosicoes[19,2],aPosicoes[19,3] ))/100
		
	Endif
	
	Z15->( MSUnLock() )
	
Enddo

// PAGAMENTOS
cQuery := "SELECT 'E5_VALOR' = SUM(E5_VALOR) "
cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DEB' AND E5_NUMCHEQ='' AND E5_DOCUMEN<>'' AND E5_TIPO<>'NP' AND D_E_L_E_T_=''"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
aCampos	:= SE5->(dbStruct())
For ni := 1 to Len(aCampos)
	If aCampos[ni,2] != 'C'
		TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
	Endif
Next
If TMP->E5_VALOR <= nValPagTit
	DbSelectArea( "TMP" )
	TMP->( dbclosearea('TMP') )
	cQuery := "SELECT *, R_E_C_N_O_ SE5RECNO "
	cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
	cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
	cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DEB' AND E5_NUMCHEQ='' AND E5_DOCUMEN<>'' AND E5_TIPO<>'NP' AND D_E_L_E_T_=''"
	cQuery := ChangeQuery(cQuery)
	MemoWrit('FINA680APag.SQL',cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	aCampos	:= SE5->(dbStruct())
	For ni := 1 to Len(aCampos)
		If aCampos[ni,2] != 'C'
			TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
		Endif
	Next
	TMP->( dbGoTop() )
	Do While ! TMP->( EOF() )
		SE5->( MsGoto( TMP->SE5RECNO ) )
		RecLock("SE5",.F.)
		SE5->E5_RECONC := 'x'
		SE5->( MSUnLock() )
		TMP->( DbSkip() )
	EndDo
	
Endif
DbSelectArea( "TMP" )
TMP->( dbclosearea('TMP') )
SE5->( DbSetOrder(7) )

//RECEBIMENTOS
cQuery := "SELECT 'E5_VALOR' = SUM(E5_VALOR) "
cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
cQuery += " AND E5_RECPAG='R' AND E5_MOTBX='NOR' AND E5_NUMCHEQ='' AND E5_TIPODOC='VL' AND D_E_L_E_T_=''"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
aCampos	:= SE5->(dbStruct())
For ni := 1 to Len(aCampos)
	If aCampos[ni,2] != 'C'
		TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
	Endif
Next

DbSelectArea( "TMP" )
TMP->( dbclosearea('TMP') )
cQuery := "SELECT *, R_E_C_N_O_ SE5RECNO "
cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
cQuery += " AND E5_RECPAG='R' AND E5_MOTBX='NOR' AND E5_NUMCHEQ='' AND E5_TIPODOC='VL' AND D_E_L_E_T_=''"
cQuery := ChangeQuery(cQuery)
MemoWrit('FINA680ARec.SQL',cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
aCampos	:= SE5->(dbStruct())
For ni := 1 to Len(aCampos)
	If aCampos[ni,2] != 'C'
		TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
	Endif
Next
TMP->( dbGoTop() )
Do While ! TMP->( EOF() )
	SE5->( MsGoto( TMP->SE5RECNO ) )
	cReconc := 'x'
	cSeek := xFilial("SE5") + TMP->E5_PREFIXO + TMP->E5_NUMERO + TMP->E5_PARCELA + TMP->E5_TIPO + TMP->E5_CLIFOR + TMP->E5_LOJA + TMP->E5_SEQ
	If SE5->( dbSeek( cSeek ) )
		Do While ! SE5->( Eof() ) .And. cSeek == SE5->E5_FILIAL + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA + SE5->E5_SEQ
			If SE5->E5_TIPODOC == 'ES'
				cReconc := ' '
				Exit
			Endif
			SE5->( DbSkip() )
		EndDo
	Endif
	SE5->( MsGoto( TMP->SE5RECNO ) )
	RecLock("SE5",.F.)
	SE5->E5_RECONC := cReconc
	SE5->( MSUnLock() )
	TMP->( DbSkip() )
EndDo

DbSelectArea( "TMP" )
TMP->( dbclosearea('TMP') )

// CONCILIACAO DAS TED
cQuery := "SELECT 'E5_VALOR' = SUM(E5_VALOR) "
cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='   ' AND E5_TIPODOC='TR' AND E5_NUMCHEQ<>'' AND E5_DOCUMEN='' AND D_E_L_E_T_=''"
cQuery += " OR ( E5_FILIAL = '" + xFilial("SE5")+ "'" +" AND E5_DATA = '" + DTOS(dDtMov)+ "' AND E5_TIPO='NP' "
cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DEB' AND E5_NUMCHEQ=' ' AND E5_DOCUMEN<>' ' AND D_E_L_E_T_='')"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
aCampos	:= SE5->(dbStruct())
For ni := 1 to Len(aCampos)
	If aCampos[ni,2] != 'C'
		TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
	Endif
Next
If TMP->E5_VALOR <= nValPagTed
	DbSelectArea( "TMP" )
	TMP->( dbclosearea('TMP') )
	cQuery := "SELECT *, R_E_C_N_O_ SE5RECNO "
	cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
	cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
	cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='   ' AND E5_TIPODOC='TR' AND E5_NUMCHEQ<>'' AND E5_DOCUMEN='' AND D_E_L_E_T_=''"
	cQuery += " OR ( E5_FILIAL = '" + xFilial("SE5")+ "'" +" AND E5_DATA = '" + DTOS(dDtMov)+ "' AND E5_TIPO='NP' "
	cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DEB' AND E5_NUMCHEQ=' ' AND E5_DOCUMEN<>' ' AND D_E_L_E_T_='')"
	cQuery := ChangeQuery(cQuery)
	MemoWrit('FINA680ATed.SQL',cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	aCampos	:= SE5->(dbStruct())
	For ni := 1 to Len(aCampos)
		If aCampos[ni,2] != 'C'
			TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
		Endif
	Next
	TMP->( dbGoTop() )
	Do While ! TMP->( EOF() )
		SE5->( MsGoto( TMP->SE5RECNO ) )
		RecLock("SE5",.F.)
		SE5->E5_RECONC := 'x'
		SE5->( MSUnLock() )
		TMP->( DbSkip() )
	EndDo
Endif
DbSelectArea( "TMP" )
TMP->( dbclosearea('TMP') )

// DARF
cQuery := "SELECT 'E5_VALOR' = SUM(E5_VALOR) "
cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DDF' AND D_E_L_E_T_=''"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
aCampos	:= SE5->(dbStruct())
For ni := 1 to Len(aCampos)
	If aCampos[ni,2] != 'C'
		TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
	Endif
Next
If TMP->E5_VALOR <= nDarfValPag
	DbSelectArea( "TMP" )
	TMP->( dbclosearea('TMP') )
	cQuery := "SELECT *, R_E_C_N_O_ SE5RECNO "
	cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
	cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
	cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DDF' AND D_E_L_E_T_=''"
	cQuery := ChangeQuery(cQuery)
	MemoWrit('FINA680ADarf.SQL',cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	aCampos	:= SE5->(dbStruct())
	For ni := 1 to Len(aCampos)
		If aCampos[ni,2] != 'C'
			TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
		Endif
	Next
	TMP->( dbGoTop() )
	Do While ! TMP->( EOF() )
		SE5->( MsGoto( TMP->SE5RECNO ) )
		RecLock("SE5",.F.)
		SE5->E5_RECONC := 'x'
		SE5->( MSUnLock() )
		TMP->( DbSkip() )
	EndDo
Endif
DbSelectArea( "TMP" )
TMP->( dbclosearea('TMP') )


//  INSS   
cQuery := "SELECT 'E5_VALOR' = SUM(E5_VALOR) "
cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DGP' AND D_E_L_E_T_=''"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
aCampos	:= SE5->(dbStruct())
For ni := 1 to Len(aCampos)
	If aCampos[ni,2] != 'C'
		TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
	Endif
Next
If TMP->E5_VALOR <= nINSSValPag
	DbSelectArea( "TMP" )
	TMP->( dbclosearea('TMP') )
	cQuery := "SELECT *, R_E_C_N_O_ SE5RECNO "
	cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
	cQuery += " AND E5_DATA = '" + DTOS(dDtMov)+ "'"
	cQuery += " AND E5_RECPAG='P' AND E5_MOTBX='DGP' AND D_E_L_E_T_=''"

	cQuery := ChangeQuery(cQuery)
	MemoWrit('FINA680AINSS.SQL',cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	aCampos	:= SE5->(dbStruct())
	For ni := 1 to Len(aCampos)
		If aCampos[ni,2] != 'C'
			TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
		Endif
	Next
	TMP->( dbGoTop() )
	Do While ! TMP->( EOF() )
		SE5->( MsGoto( TMP->SE5RECNO ) )
		RecLock("SE5",.F.)
		SE5->E5_RECONC := 'x'
		SE5->( MSUnLock() )
		TMP->( DbSkip() )
	EndDo
Endif
DbSelectArea( "TMP" )
TMP->( dbclosearea('TMP') )

Fclose( nHdlBco )  // Fecha sequencial enviado pelo banco
Fclose( nHdlConf ) // Fecha sequencial do configurador
Close(oLeTxt)

Return

Static Function RecFolha(nValor)

// Folha de Pagamento com Cheque ficticio
cQuery := "SELECT Count(E5_FILIAL) AS RECNOS"
cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
cQuery += " AND E5_TIPO = '' AND E5_NUMCHEQ <> '' AND E5_DOCUMEN = '' AND E5_RECPAG = 'P' AND E5_TIPODOC = 'CH' AND E5_MOTBX = ''AND D_E_L_E_T_='' "
cQuery += " AND E5_VALOR = "+Str(nValor)
cQuery := ChangeQuery(cQuery)
MemoWrit('FINA680AFolha.SQL',cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
aCampos	:= SE5->(dbStruct())
For ni := 1 to Len(aCampos)
	If aCampos[ni,2] != 'C'
		TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
	Endif
Next
nRecnos := TMP->Recnos
If nRecnos > 0
	DbSelectArea( "TMP" )
	TMP->( dbclosearea('TMP') )
	cQuery := "SELECT *, R_E_C_N_O_ SE5RECNO "
	cQuery += " FROM " + RetSqlName( 'SE5' ) +" SE5"
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5")+ "'"
	cQuery += " AND E5_TIPO = '' AND E5_NUMCHEQ <> '' AND E5_DOCUMEN = '' AND E5_RECPAG = 'P' AND E5_TIPODOC = 'CH' AND E5_MOTBX = ''AND D_E_L_E_T_='' "
	cQuery += " AND E5_VALOR = "+Str(nValor)
	cQuery := ChangeQuery(cQuery)
	MemoWrit('FINA680AFolha.SQL',cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	aCampos	:= SE5->(dbStruct())
	For ni := 1 to Len(aCampos)
		If aCampos[ni,2] != 'C'
			TCSetField( 'TMP', aCampos[ni,1], aCampos[ni,2],aCampos[ni,3],aCampos[ni,4])
		Endif
	Next
	TMP->( dbGoTop() )
	Do While ! TMP->( EOF() )
		SE5->( MsGoto( TMP->SE5RECNO ) )
		RecLock("SE5",.F.)
		SE5->E5_RECONC := 'x'
		SE5->( MSUnLock() )
		TMP->( DbSkip() )
	EndDo
Endif
DbSelectArea( "TMP" )
TMP->( dbclosearea('TMP') )

Return