#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function FATRET()
Private nLin
Private cQuery := ''
//variáveis das regiões do brasil com seus respectivos estados
Private cRGNO := "AC AM AP PA RO RR TO"
Private cRGNE := "MA PI CE RN PB PE AL BA SE"
Private cRGCE := "GO MT MS DF"
Private cRGSD := "MG ES RJ SP"
Private cRGSL := "RS PR SC"
Private cRegiao	:= ""
//contadores de entregas por região
Private nCTNO := nCTNE := nCTCE := nCTSD := nCTSL := 0
//acumuladores de dias de entrega
Private nDIANO := nDIANE := nDIACE := nDIASD := nDIASL := 0
//variável de pico de entrega (entrega mais demorada)
Private nTOPNO := nTOPNE := nTOPCE := nTOPSD := nTOPSL := 0
Private cRedesp := ""
Private cTransp := ""
Private cCodTransp := ""
Private cLocal	:= ""
Private cSegmento := ""
Private LF		:= CHR(13) + CHR(10)

tamanho   := "G" // "M" //P = 80 Colunas, M = 130 Colunas, G = 220 Colunas
titulo    := PADC("Relatorio de Eficacia de Transportadora", 74)
cDesc1    := PADC("Relatorio de Eficacia de Transportadora", 74)
cDesc2    := PADC("", 74)
cDesc3    := PADC("", 74)
cNatureza := ""
aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATRET"
cPerg     := "FATRET"
nLastKey  := 0
lContinua := .T.
nLin      := 90
wnrel     := "FATRET"
M_PAG     := 1
nAtacad   := nUmDiaAtacad := 0 //Variável que acumulará os clientes atrasados como Atacadistas
nDistri   := nUmDiaDistri := 0 //Variável que acumulará os clientes atrasados como Distribuidores
nRevend   := nUmDiaRevend := 0 //Variável que acumulará os clientes atrasados como Revendedores
nBranco   := nUmDiaBranco := 0
nOutro    := nUmDiaOutro  := 0 
nConAtz_NE := nConAtz_NO := nConAtz_SL := nConAtz_SD := nConAtz_CE := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .T. )
cString := " "
titulo    := PADC("Relatorio de Eficacia de Transportadora de "+dtoc(mv_par03)+" até "+dtoc(mv_par04)+" ", 74)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
	Static Function RptDetail()
#ENDIF


/*
// mv_par01 = Transportadora
// mv_par02 = Cliente
// mv_par03 = De(Saída)
// mv_par04 = Até(Saída)
// mv_par05 = Segmento
*/

Do case
	Case mv_par09 = 1
		cRegiao := "('AC','AM','AP','PA','RO','RR','TO')"
	Case mv_par09 = 2
		cRegiao := "('MA','PI','CE','RN','PB','PE','AL','BA','SE')"
	Case mv_par09 = 3
		cRegiao := "('GO','MT','MS','DF')"
	Case mv_par09 = 4
		cRegiao := "('MG','ES','RJ','SP')"
	Case mv_par09 = 5
		cRegiao := "('RS','PR','SC')"
EndCase	
////Faz a comparação da data inicial selecionada
////para saber se utiliza o método antigo ou o novo relatório do Pós-Vendas
If mv_par03 <= Ctod("17/12/2009")   ////VERIFICAÇÃO PÓS-VENDAS ANTIGO / NOVO

	//Msgbox("Antigo")
	////INICIO DO ANTIGO REL PÓS-VENDAS
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio do Programa                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery := " select  Z04_PROROG ,Z04_RETENC,SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, Z04.Z04_DOC, Z04.Z04_DATSAI, Z04.Z04_PRAZO," +LF
	cQuery += " Z04.Z04_DATCHE, SF2.F2_EMISSAO, SZZ.ZZ_PRZENT, Z04_OBS, SA1.A1_SATIV1 " +LF
	cQuery += " from " + RetSqlName("Z04") + " Z04, " + RetSqlName("SF2") + " SF2, " + RetSqlName("SA4") + " SA4, " +LF
	cQuery += " " + RetSqlName("SZZ") + " SZZ, " + RetSqlName("SA1") + " SA1 " +LF
	cQuery += " where Z04.Z04_DATSAI <> '' and Z04.Z04_DATCHE <> '' " +LF
	cQuery += " and Z04.Z04_DOC = SF2.F2_DOC " +LF
	cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD " +LF
	cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " +LF
	cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " +LF
	
	cQuery += " and A4_COD <>'024' " + LF // TIRAR CLIENTE RETIRA 
		
	cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " +LF
	
	IF !empty(mv_par01)
		cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  " +LF
	ENDIF
	
	IF !empty(mv_par02)
		cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  " +LF
	ENDIF
	
	IF !empty(mv_par03)
		cQuery += " and Z04.Z04_DATSAI >= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
		IF mv_par04 == stod(" ")
			cQuery += " and Z04.Z04_DATSAI <= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
		ENDIF
	ENDIF
	
	IF !empty(mv_par04)
		cQuery += " and Z04.Z04_DATSAI <= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
		IF mv_par03 == stod(" ")
			cQuery += " and Z04.Z04_DATSAI >= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
		ENDIF
	ENDIF
	
	IF !empty(mv_par05)
		cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "'  " +LF
	ENDIF
	cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF

	IF mv_par08 = 1
		cQuery += " and SF2.F2_EST IN " + cRegiao + LF
	ENDIF
	
	If mv_par10 = 2
		cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	EndIf
	cQuery += " and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' " +LF
	cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and Z04.Z04_FILIAL = '" + xFilial("Z04") + "' " +LF
	cQuery += " and SA1.A1_FILIAL = '" + xFilial("SA1") + "' " +LF
	cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and Z04.D_E_L_E_T_ = ' ' " +LF
	cQuery += " and SA1.D_E_L_E_T_ = ' ' " +LF
	cQuery += " order by SA4.A4_NREDUZ, SZZ.ZZ_DESC, Z04.Z04_DATSAI" +LF
	cQuery := ChangeQuery( cQuery )
	MemoWrite("C:\Z04-1.SQL", cQuery)
	
	TCQUERY cQuery NEW ALIAS "TMP"
	TMP->( DbGoTop() )
	
	    //TAMANHO M - 130 COLUNAS
	   //         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	   //         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15
	   //        "|  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA (CLIENTE) | QNT. DE DIAS | TES"
        //            999999999    xxxxxxxxxxxxxxxxxxxx       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     99/99/99        99/99/99         99/99/99           99/99/99         9999
        
 cCabec_01 :=    "|  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA (CLIENTE) | QNT. DE DIAS |   TES"
	aResult  := {}
	aAtrasos := {}
	nAtX  := nAdX  := nTmX  := 0
	nAtMX := nAdMX := nTmMX := 0
	If TMP->( EoF() )			////SE A QUERY NÃO TEVE RESULTADOS, PODE SER PQ A TRANSP É REDESPACHO, ENTÃO REFAÇO A QUERY CONSIDERANDO REDESPACHO
								////F2_REDESP = A4_COD
		//Msgbox("Antigo(1): A transp é redespacho")
		
		cQuery := " select  Z04_PROROG ,Z04_RETENC,SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, Z04.Z04_DOC, Z04.Z04_DATSAI, Z04.Z04_PRAZO," +LF
		cQuery += " Z04.Z04_DATCHE, SF2.F2_EMISSAO, SZZ.ZZ_PRZENT, Z04_OBS, SA1.A1_SATIV1 " +LF
		cQuery += " from " + RetSqlName("Z04") + " Z04, " + RetSqlName("SF2") + " SF2, " + RetSqlName("SA4") + " SA4, " +LF
		cQuery += " " + RetSqlName("SZZ") + " SZZ, " + RetSqlName("SA1") + " SA1 " +LF
		cQuery += " where Z04.Z04_DATSAI <> '' and Z04.Z04_DATCHE <> '' " +LF
		cQuery += " and Z04.Z04_DOC = SF2.F2_DOC " +LF
		cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD " +LF
		cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " +LF
		cQuery += " and SF2.F2_REDESP = SA4.A4_COD " +LF
		cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP " +LF
		cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " +LF
		
		IF !empty(mv_par01)
			cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  " +LF
		ENDIF
		
		IF !empty(mv_par02)
			cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  " +LF
		ENDIF
		
		IF !empty(mv_par03)
			cQuery += " and Z04.Z04_DATSAI >= '"+ alltrim(dtos(mv_par03)) + "'  " +LF
			IF mv_par04 == stod(" ")
				cQuery += " and Z04.Z04_DATSAI <= '"+ alltrim(dtos(mv_par03)) + "'  " +LF
			ENDIF
		ENDIF
		
		IF !empty(mv_par04)
			cQuery += " and Z04.Z04_DATSAI <= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
			IF mv_par03 == stod(" ")
				cQuery += " and Z04.Z04_DATSAI >= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
			ENDIF
		ENDIF
		
		IF !empty(mv_par05)
			cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "'  " +LF
		ENDIF
		
		cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF
		IF mv_par08 = 1
			cQuery += " and SF2.F2_EST IN " + cRegiao + LF
		ENDIF
		
		If mv_par10 = 2
			cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
		EndIf
		cQuery += " and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' " +LF
		cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and Z04.Z04_FILIAL = '" + xFilial("Z04") + "' " +LF
		cQuery += " and SA1.A1_FILIAL = '" + xFilial("SA1") + "' " +LF
		cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and Z04.D_E_L_E_T_ = ' ' " +LF
		cQuery += " and SA1.D_E_L_E_T_ = ' ' " +LF
		cQuery += " order by SA4.A4_NREDUZ, SZZ.ZZ_DESC, Z04.Z04_DATSAI" +LF
		cQuery := ChangeQuery( cQuery )
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		Endif
		MemoWrite("C:\Z04-RED.SQL", cQuery)
		TCQUERY cQuery NEW ALIAS "TMP"
	
	Endif
	
	TMP->( DbGoTop() )	
	while ! TMP->( EoF() )
		aMediana := {}
		aNotas := {}
		nMDEntreg := nMDAtraso := nProm := 0
		cTransp := alltrim(TMP->A4_NREDUZ) //nome da transportadora
		cMunicp := alltrim(TMP->ZZ_DESC)   //nome do municipio
		x := 0
		nAt := nAd := nTm := 0
		cSegmento := ""
		while !TMP->( EoF() ) .AND. (alltrim(TMP->ZZ_DESC) == cMunicp) .AND. (alltrim(TMP->A4_NREDUZ) == cTransp)
	        if Empty(TMP->Z04_PROROG) .AND. Empty(TMP->Z04_RETENC)		
				nMDAtraso += stod(TMP->Z04_DATCHE) - stod(TMP->Z04_PRAZO)
				nMDEntreg += stod(TMP->Z04_DATCHE) - stod(TMP->Z04_DATSAI)
				nProm := TMP->ZZ_PRZENT
				DO CASE
					CASE stod(TMP->Z04_DATCHE) - stod(TMP->Z04_PRAZO) == 0
						nTm++
					CASE stod(TMP->Z04_DATCHE) - stod(TMP->Z04_PRAZO) > 0
						nAt++
						aAdd(aAtrasos, {cMunicp, stod(TMP->Z04_DATCHE) - stod(TMP->Z04_PRAZO), TMP->A1_NREDUZ,alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;
										TMP->Z04_DOC, alltrim(TMP->Z04_OBS) } )
					CASE stod(TMP->Z04_DATCHE) - stod(TMP->Z04_PRAZO) < 0
						nAd++
		   	    ENDCASE
	   		    x++                                                                                           //datafat
	        endif
	        
	        DbselectArea("SX5")
		    Dbsetorder(1)
		    SX5->(Dbseek(xFilial("SX5") + 'T3' + TMP->A1_SATIV1 ))
		    cSegmento := Alltrim( Substr(SX5->X5_DESCRI,1,35) )
	        //					1				2				3				4				5				6				7
	   		aAdd(aNotas, {TMP->Z04_DOC, TMP->A1_NREDUZ, TMP->Z04_DATSAI, TMP->Z04_PRAZO, TMP->Z04_DATCHE, TMP->F2_EMISSAO, cSegmento } )
			TMP->( DbSkip() )
		EndDo
		nAtX += nAt
		nAdX += nAd
		nTmX += nTm
//							1		2		3		  4	 5	 6    7	   8   9    10		11			12		
		aAdd(aResult, {cTransp, cMunicp, nMDAtraso/x, 1, 0, nTm, nAt, nAd, x, aNotas, nMDEntreg/x, nProm} )
	EndDo
	
	Cabec(titulo, "", "", nomeprog, tamanho, 15)
	@ PRow() + 1,000 PSay cCabec_01
	@ PRow() + 1,000 PSay Repl( '-', 201) // linha 7
	cTrn := ''
	
	    //TAMANHO M - 130 COLUNAS
	   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	   //         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
	   //         |  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA | QNT. DE DIAS | QT.DIAS PRORROGADOS"
        //            999999999    xxxxxxxxxxxxxxxxxxxx       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     99/99/99        99/99/99         99/99/99           99/99/99         9999              9999
	
	FOR Y := 1 TO Len(aResult)
		FOR Z := 1 TO Len(aResult[Y][10])
			IF PRow() > 55
				Cabec(titulo, "", "", nomeprog, tamanho, 15)
				@ PRow() + 1,000 PSay cCabec_01
				@ PRow() + 1,000 PSay Repl( '-', 201)
			ENDIF//somei dezessete aos três últimos
			@ PRow() + 1,004 PSay alltrim(aResult[Y][10][Z][1])   	//NF
			@ PRow()    ,017 PSay alltrim(aResult[Y][10][Z][2])     //CLIENTE
			@ PRow()	,044 Psay alltrim(aResult[Y][10][Z][7])		//SEGMENTO
			@ PRow()    ,084 PSay stod(aResult[Y][10][Z][6])        //DT. EMISSÃO
			@ PRow()    ,100 PSay stod(aResult[Y][10][Z][3])		//DT. EXPEDIÇÃO
			@ PRow()    ,117 PSay (stod(aResult[Y][10][Z][4]) + 1)		//DT. PREVISÃO CHEGADA
			@ PRow()    ,136 PSay stod(aResult[Y][10][Z][5])		//DT. REAL CHEGADA
			@ PRow()	,153 PSay alltrim(str( aResult[Y][10][Z][5] - ( aResult[Y][10][Z][3] + 1 )  ) ) + " " + "Dia(s)"
			//em 22/03/10 foi solicitado por Alexandre que alterasse o método de cálculo da coluna dias (Dt. Chegada - (Dt.Expedição + 1) )
			
		NEXT
		
		IF PRow() > 54
			Cabec(titulo, "", "", nomeprog, tamanho, 15)
		ENDIF
		
		@ PRow() + 2,004 PSay "TRANSP.:" +" "+ alltrim(aResult[Y][1])
		@ PRow() + 1,004 PSay "MUNCIP.:" +" "+ alltrim(aResult[Y][2])
		@ PRow() + 1,004 PSay "MEDIA DE ATRASO:"     +" "+ alltrim(transform(aResult[Y][3],  "@E 999,999.99")) +" | "+;
		"MEDIA DE DIAS:"       +" "+ alltrim(transform(aResult[Y][11], "@E 999,999.99")) +" | "+;
		"DIAS TRANSPORTADORA:" +" "+ alltrim(transform(aResult[Y][12], "@E 999,999.99"))
		@ PRow() + 1,004 PSay "QTD. DE ENTREGAS:" +" "+ alltrim(str(aResult[Y][9]))
		@ PRow() + 1,004 PSay "NO VENCIMENTO: "+ alltrim(str(aResult[Y][6])) +"  "+;
		"ATRASADAS: "+ alltrim(str(aResult[Y][7])) +"  "+;
		"ADIANTADAS: "+ alltrim(str(aResult[Y][8]))+;
		iif( Y != Len(aResult), iif( aResult[Y][1] != aResult[ Y + 1 ][1],;
		" ** "+"FIM DAS INFORMACOES DA TRANSP. " + alltrim(aResult[Y][1])+" ** ","" ),;
		" ** "+"FIM DAS INFORMACOES DA TRANSP. " + alltrim(aResult[Y][1])+" ** " )
		@ PRow() + 1,000 PSay Repl('-', 164)
		
	NEXT
	TMP->( dbCLoseArea() )
	
	cQuery := " select distinct Z04_DOC, F2_DOC, Z04_DATSAI, Z04_DATCHE, Z04_PRAZO, A1_EST, F2_EST " +LF
	cQuery += " from   " + retSqlName('Z04') + " Z04, " + retSqlName('SA1') + " SA1, " + retSqlName('SF2') + " SF2, " + retSqlName('SA4') + " SA4 " +LF
	cQuery += " where  Z04_FILIAL = '"+xFilial('Z04')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and A4_FILIAL = '"+xFilial('SA4')+"' " +LF
	cQuery += " and F2_DOC = Z04_DOC " +LF
	cQuery += " and F2_CLIENTE = A1_COD " +LF
	cQuery += " and F2_LOJA = A1_LOJA " +LF
	cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " +LF
	cQuery += " and F2_EMISSAO >= '"+ alltrim(dtos(mv_par03)) +"' and  F2_EMISSAO <= '"+ alltrim(dtos(mv_par04)) +"' " +LF
	If mv_par10 = 2
		cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	EndIf
	
	IF !empty(mv_par01)
		cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  " +LF
	ENDIF
	IF !empty(mv_par02)
		cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  " +LF
	ENDIF
	
	IF !empty(mv_par05)
		cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "' " +LF
	ENDIF                                                                   
	
	cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF

	IF mv_par08 = 1
		cQuery += " and SF2.F2_EST IN " + cRegiao + LF
	ENDIF
	
	cQuery += " and Z04_DATCHE <> '' and Z04_PRAZO <> '' " +LF
	cQuery += " and Z04.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' and SF2.D_E_L_E_T_ != '*' and SA4.D_E_L_E_T_ != '*' " +LF
	cQuery += " AND Z04_PROROG = '' AND Z04_RETENC = '' " +LF
	cQuery += " order by A1_EST " +LF
	MemoWrite("C:\Z04-2.SQL", cQuery)
	
	TCQUERY cQuery NEW ALIAS 'TMP'
	TMP->( dbGoTop() )
	
	TCSetField('TMP', "Z04_DATSAI", "D")
	TCSetField('TMP', "Z04_DATCHE", "D")
	TCSetField('TMP', "Z04_PRAZO",  "D")
	
	If TMP->( EoF() )
		//msgbox("Antigo(2): a Transp é Redespacho")
		
		cQuery := " select distinct Z04_DOC, F2_DOC, Z04_DATSAI, Z04_DATCHE, Z04_PRAZO, A1_EST, F2_EST " +LF
		cQuery += " from   " + retSqlName('Z04') + " Z04, " + retSqlName('SA1') + " SA1, " + retSqlName('SF2') + " SF2, " + retSqlName('SA4') + " SA4 " +LF
		cQuery += " where  Z04_FILIAL = '"+xFilial('Z04')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and A4_FILIAL = '"+xFilial('SA4')+"' " +LF
		cQuery += " and F2_DOC = Z04_DOC " +LF
		cQuery += " and F2_CLIENTE = A1_COD " +LF
		cQuery += " and F2_LOJA = A1_LOJA " +LF
		If mv_par10 = 2
			cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
		EndIf
		
		cQuery += " and A4_COD <>'024' " + LF // TIRAR CLIENTE RETIRA 
			
		cQuery += " and SF2.F2_REDESP = SA4.A4_COD " +LF
		cQuery += " and F2_EMISSAO >= '"+ alltrim(dtos(mv_par03)) +"' and  F2_EMISSAO <= '"+ alltrim(dtos(mv_par04)) +"' " +LF
		IF !empty(mv_par01)
			cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  " +LF
		ENDIF
		
		IF !empty(mv_par02)
			cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  " +LF
		ENDIF
		
		IF !empty(mv_par05)
			cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "' " +LF
		ENDIF
		
		cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF
		IF mv_par08 = 1
			cQuery += " and SF2.F2_EST IN " + cRegiao + LF
		ENDIF
		
		cQuery += " and Z04_DATCHE <> '' and Z04_PRAZO <> '' " +LF
		cQuery += " and Z04.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' and SF2.D_E_L_E_T_ != '*' and SA4.D_E_L_E_T_ != '*' " +LF
		cQuery += " AND Z04_PROROG = '' AND Z04_RETENC = '' " +LF
		cQuery += " order by A1_EST " +LF
		MemoWrite("C:\Z04-RED2.SQL", cQuery)
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		Endif
		TCQUERY cQuery NEW ALIAS "TMP"
		
		TCSetField('TMP', "Z04_DATSAI", "D")
		TCSetField('TMP', "Z04_DATCHE", "D")
		TCSetField('TMP', "Z04_PRAZO",  "D")
	
	Endif
	
	TMP->( dbGoTop() )
	do While ! TMP->( EOF() )
		
		if TMP->A1_EST $ cRGNO
			nDIANO += TMP->Z04_DATCHE - TMP->Z04_DATSAI
			iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPNO, nTOPNO := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
			nCTNO++
		elseIf TMP->A1_EST $ cRGNE
			nDIANE += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)
			iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPNE, nTOPNE := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
			nCTNE++
		elseIf TMP->A1_EST $ cRGCE
			nDIACE += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)
			iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPCE, nTOPCE := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
			nCTCE++
		elseIf TMP->A1_EST $ cRGSD
			nDIASD += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)
			iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPSD, nTOPSD := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
			nCTSD++
		elseIf TMP->A1_EST $ cRGSL
			nDIASL += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)
			iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPSL, nTOPSL := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
			nCTSL++
		else
			msgAlert("O estado " + TMP->A1_EST + "nao esta cadastrado em nenhuma regiao! ")
			return
		endIf
		TMP->( dbSkip() )
	endDo
	
////FIM DO ANTIGO REL 
///////// NOVO ////////FR - FLÁVIA ROCHA
Else

	nLin := 90
	//Msgbox("Novo")
	
	cQuery := "select  " + LF
	cQuery += " CASE WHEN SF2.F2_REALCHG !='' THEN SF2.F2_REALCHG " + LF
	cQuery += " ELSE " + LF
	cQuery += " CASE WHEN SF2.F2_DTTRANS != '' THEN SF2.F2_DTTRANS " + LF
	cQuery += " END END AS REALCHG " + LF
	cQuery += " ,F2_REALCHG,F2_DTTRANS,F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, " +LF
	cQuery += " SF2.F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1, " + LF
	cQuery += " D2_TES,F4_TEXTO,F4_DUPLIC " +LF
	
	
	cQuery += " from " + RetSqlName("SF2") + " SF2, "  +LF
	cQuery += "" + RetSqlName("SA4") + " SA4, " +LF
	cQuery += "" + RetSqlName("SZZ") + " SZZ, "  +LF
	cQuery += "" + RetSqlName("SA1") + " SA1, " +LF
	cQuery += "" + RetSqlName("SD2") + " SD2, " +LF 
	cQuery += "" + RetSqlName("SF4") + " SF4 " +LF 
	
	cQuery += " where F2_DTEXP <> '' and F2_REALCHG <> '' " +LF 
	
	cQuery += " and (SF2.F2_FILIAL) = (SD2.D2_FILIAL) " +LF
	cQuery += " and (SF2.F2_DOC + SF2.F2_SERIE) = (SD2.D2_DOC + SD2.D2_SERIE) " +LF
	cQuery += " and (SD2.D2_TES) = (SF4.F4_CODIGO) " +LF
	
	cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD " +LF
	cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " +LF
	cQuery += " and SF2.F2_TRANSP = SA4.A4_COD " +LF
	cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " +LF
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " +LF
	IF !empty(mv_par01)
		cQuery += "and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  " +LF
	ENDIF
	
	IF !empty(mv_par02)
		cQuery += "and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  " +LF
	ENDIF
	
	//FR - FLAVIA ROCHA - ALTERADO EM 06/06/12 
	//ALTERAR A BUSCA, AO INVÉS DE SER PELA DATA SAÍDA, BUSCAR PELA DATA ENTREGA
	/*
	IF !empty(mv_par03)
		cQuery += "and F2_DTEXP >= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
		IF Empty(mv_par04)
			cQuery += "and F2_DTEXP <= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
		ENDIF
	ENDIF
	
	IF !empty(mv_par04)
		cQuery += "and F2_DTEXP <= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
		IF Empty(mv_par03)
			cQuery += "and F2_DTEXP >= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
		ENDIF
	ENDIF
	*/
	//FR - FLAVIA ROCHA - ALTERADO EM 06/06/12 
	//ALTERAR A BUSCA, AO INVÉS DE SER PELA DATA SAÍDA, BUSCAR PELA DATA ENTREGA
	IF !empty(mv_par03)
		cQuery += "and F2_REALCHG >= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
		IF Empty(mv_par04)
			cQuery += "and F2_REALCHG <= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
		ENDIF
	ENDIF
	
	IF !empty(mv_par04)
		cQuery += "and F2_REALCHG <= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
		IF Empty(mv_par03)
			cQuery += "and F2_REALCHG >= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
		ENDIF
	ENDIF
	//ATÉ AQUI - FR
	IF !empty(mv_par05)
		cQuery += "and RTRIM(A1_SATIV1) = '"+ alltrim(mv_par05) +"'  "		 +LF
	ENDIF
	
	cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF
	IF mv_par08 = 1
		cQuery += " and SF2.F2_EST IN " + cRegiao + LF
	ENDIF
	
	If mv_par10 = 2
		cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	EndIf
	cQuery += " and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' " +LF
	//cQuery += " and SD2.D2_FILIAL = '" + xFilial("SD2") + "' " +LF
	cQuery += " and SF4.F4_FILIAL = '" + xFilial("SF4") + "' " +LF
	cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and SA1.A1_FILIAL = '" + xFilial("SA1") + "' " +LF
	cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and SA1.D_E_L_E_T_ = ' ' " +LF 
	cQuery += " and SD2.D_E_L_E_T_ = ' ' " + LF
	cQuery += " and SF4.D_E_L_E_T_ = ' ' " + LF
	
	cQuery += " and A4_COD <>'024' " + LF // TIRAR CLIENTE RETIRA 
	
	cQuery += " GROUP BY " + LF
	cQuery += " F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG," +LF
	cQuery += " F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1, D2_TES,F4_TEXTO,F4_DUPLIC, " +LF
	cQuery += " SF2.F2_DTTRANS " +LF
	
	cQuery += " order by SF2.F2_TRANSP, SF2.F2_REDESP, SZZ.ZZ_DESC, SF2.F2_DTEXP" +LF
	cQuery := ChangeQuery( cQuery )
	MemoWrite("C:\Temp\FATRET1.SQL", cQuery )
	
	TCQUERY cQuery NEW ALIAS "TMP"
	
	TCSetField( 'TMP', "F2_EMISSAO", "D")
	TCSetField( 'TMP', "F2_DTEXP", "D")
	TCSetField( 'TMP', "F2_PREVCHG", "D")
	TCSetField( 'TMP', "F2_DTAGCLI", "D")
	TCSetField( 'TMP', "REALCHG", "D")
	TCSetField( 'TMP', "F2_DATRASO", "D")
	TCSetField( 'TMP', "F2_DTAGCLI", "D")
	TCSetField( 'TMP', "F2_UFCHG", "D")
	
	TMP->( DbGoTop() )
	If TMP->( EoF() )			////SE A QUERY NÃO TEVE RESULTADOS, PODE SER PQ A TRANSP É REDESPACHO, ENTÃO REFAÇO A QUERY CONSIDERANDO REDESPACHO
								////F2_REDESP = A4_COD
		//Msgbox("Novo(1): A transp é redespacho")
		
		cQuery := "select  " + LF
		cQuery += " CASE WHEN SF2.F2_REALCHG !='' THEN SF2.F2_REALCHG " + LF
		cQuery += " ELSE " + LF
		cQuery += " CASE WHEN SF2.F2_DTTRANS != '' THEN SF2.F2_DTTRANS " + LF
		cQuery += " END END AS REALCHG " + LF
		cQuery += " ,F2_REALCHG,F2_DTTRANS,F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, " +LF
		cQuery += " SF2.F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1, " + LF
		cQuery += " D2_TES,F4_TEXTO,F4_DUPLIC " +LF
				
		cQuery += " from " + RetSqlName("SF2") + " SF2, "  +LF
		cQuery += "" + RetSqlName("SA4") + " SA4, " +LF
		cQuery += "" + RetSqlName("SZZ") + " SZZ, "  +LF
		cQuery += "" + RetSqlName("SA1") + " SA1, " +LF
		cQuery += "" + RetSqlName("SD2") + " SD2, " +LF 
		cQuery += "" + RetSqlName("SF4") + " SF4 " +LF 
		
		cQuery += " where F2_DTEXP <> '' and F2_REALCHG = '' " +LF
				
		cQuery += " and (SF2.F2_FILIAL) = (SD2.D2_FILIAL) " +LF
		cQuery += " and (SF2.F2_DOC + SF2.F2_SERIE) = (SD2.D2_DOC + SD2.D2_SERIE) " +LF
		cQuery += " and (SD2.D2_TES) = (SF4.F4_CODIGO) " +LF
	
		cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD " +LF
		cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA " +LF
		cQuery += " and SF2.F2_REDESP = SA4.A4_COD " +LF
		cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP " +LF
		cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ " +LF
		IF !empty(mv_par01)
			cQuery += "and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  " +LF
		ENDIF
		
		IF !empty(mv_par02)
			cQuery += "and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  " +LF
		ENDIF
		/*
		IF !empty(mv_par03)
			cQuery += "and F2_DTEXP >= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
			IF Empty(mv_par04)
				cQuery += "and F2_DTEXP <= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
			ENDIF
		ENDIF
		
		IF !empty(mv_par04)
			cQuery += "and F2_DTEXP <= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
			IF Empty(mv_par03)
				cQuery += "and F2_DTEXP >= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
			ENDIF
		ENDIF
		*/
		//FR - FLAVIA ROCHA - ALTERADO EM 06/06/12 
		//ALTERAR A BUSCA, AO INVÉS DE SER PELA DATA SAÍDA, BUSCAR PELA DATA ENTREGA
		IF !empty(mv_par03)
			cQuery += "and F2_REALCHG >= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
			IF Empty(mv_par04)
				cQuery += "and F2_REALCHG <= '"+ alltrim(dtos(mv_par03)) +"'  " +LF
			ENDIF
		ENDIF
		
		IF !empty(mv_par04)
			cQuery += "and F2_REALCHG <= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
			IF Empty(mv_par03)
				cQuery += "and F2_REALCHG >= '"+ alltrim(dtos(mv_par04)) +"'  " +LF
			ENDIF
		ENDIF
		//ATÉ AQUI - FR
		IF !empty(mv_par05)
			cQuery += "and RTRIM(A1_SATIV1) = '"+ alltrim(mv_par05) +"'  "		 +LF
		ENDIF
		
		cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF
		IF mv_par08 = 1
			cQuery += " and SF2.F2_EST IN " + cRegiao + LF
		ENDIF
		
		If mv_par10 = 2
			cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
		EndIf
		cQuery += " and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' " +LF
		//cQuery += " and SD2.D2_FILIAL = '" + xFilial("SD2") + "' " +LF
		cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4") + "' " +LF
		cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and SA1.A1_FILIAL = '" + xFilial("SA1") + "' " +LF
		cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and SA1.D_E_L_E_T_ = ' ' " +LF 
		cQuery += " and SD2.D_E_L_E_T_ = ' ' " + LF
		cQuery += " and SA4.D_E_L_E_T_ = ' ' " + LF

	    cQuery += " and A4_COD <>'024' " + LF // TIRAR CLIENTE RETIRA 
		
		cQuery += " GROUP BY " + LF
		cQuery += " F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG," +LF
		cQuery += " F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1, D2_TES,F4_TEXTO,F4_DUPLIC, " +LF
		cQuery += " SF2.F2_DTTRANS " +LF
	
		cQuery += " order by SF2.F2_REDESP, SF2.F2_TRANSP, SZZ.ZZ_DESC, SF2.F2_DTEXP" +LF
		cQuery := ChangeQuery( cQuery )
		MemoWrite("C:\Temp\FATRET2.SQL", cQuery )
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		Endif
	
		TCQUERY cQuery NEW ALIAS "TMP"
		
		TCSetField( 'TMP', "F2_EMISSAO", "D")
		TCSetField( 'TMP', "F2_DTEXP", "D")
		TCSetField( 'TMP', "F2_PREVCHG", "D")
		TCSetField( 'TMP', "F2_DTAGCLI", "D")
		TCSetField( 'TMP', "F2_UFCHG", "D")
		TCSetField( 'TMP', "REALCHG", "D")
		TCSetField( 'TMP', "F2_DATRASO", "D")
		TCSetField( 'TMP', "F2_DTAGCLI", "D")
		TCSetField( 'TMP', "F2_UFCHG", "D")
		
	Endif
	
	    //TAMANHO M - 130 COLUNAS
	   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	   //         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20  
	   //        "|  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA (CLIENTE) | QNT. DE DIAS  | DT.CHEGADA NA UF DESTINO"
        //            999999999    xxxxxxxxxxxxxxxxxxxx       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     99/99/99        99/99/99         99/99/99           99/99/99         9999
	cCabec_01 := "|  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA (CLIENTE) | QT.DIAS UTEIS |   TES"
	aResult  := {}
	aAtrasos := {}
	nAtX  := nAdX  := nTmX  := 0
	nAtMX := nAdMX := nTmMX := 0
	nATUF_X := 0	    //total entregas com atraso no transporte
	nATU1DX	:= 0		//total de entregas com 1 dia de atraso
	nNFNVen  := 0
	nNFNVenX := 0		//total NFs não Vendas (ex: bonificação)
	
	nDiasProrrog 	:= 0
	nTotProrrog 	:= 0
		
	TMP->(Dbgotop())
	while ! TMP->( EoF() )
		aMediana 	:= {}
		aNotas 		:= {}
		nMDEntreg 	:= nMDAtraso := nProm := 0
		cSegmento 	:= ""
		nNFNVen  := 0


		
		If !Empty(TMP->F2_REDESP)
			cCodTransp := alltrim(TMP->F2_REDESP)
			SA4->(Dbsetorder(1))
			SA4->(Dbseek(xFilial("SA4") + cCodTransp) )
			cTransp := Alltrim(SA4->A4_NREDUZ)
			//MSGBOX( "redespacho: " + cTransp )
		Else
			cCodTransp := alltrim(TMP->F2_TRANSP)
			cTransp := alltrim(TMP->A4_NREDUZ) //nome da transportadora
			//MSGBOX( "não redespacho: " + cTransp )
		Endif
		
		
		cMunicp := alltrim(TMP->ZZ_DESC)   //nome do municipio
		x := 0
		nAt := nAd := nTm := 0
		nAtTrans := 0
		nATUMDIA := 0
				
		If Empty(TMP->F2_REDESP)		//SE NÃO É REDESPACHO, FAZ O LOOP COM O F2_TRANSP
			while !TMP->( EoF() ) .AND. (alltrim(TMP->ZZ_DESC) == Alltrim(cMunicp) ) .AND. (alltrim(TMP->F2_TRANSP) == Alltrim(cCodTransp) )
		        if Empty(TMP->F2_DTAGCLI) .AND. TMP->F2_RETENC != "S" //.AND. Empty(TMP->F2_RETENC)		
					
					
					If (TMP->REALCHG) - (TMP->F2_PREVCHG) > 0
						nMDAtraso := nMDAtraso + (TMP->REALCHG) - (TMP->F2_PREVCHG)
					
					Endif
					
					//MSGBOX("dias atraso: " + str(nMDAtraso) )
					
					nMDEntreg += (TMP->REALCHG) - (TMP->F2_DTEXP)
															
	       			nProm := TMP->ZZ_PRZENT		//prazo da transportadora
	       			
	       			If TMP->F4_DUPLIC = 'N'
	       				nNFNVen++
	       			Endif     		
	
					
					DO CASE
						CASE (TMP->REALCHG) - (TMP->F2_PREVCHG) == 0
							nTm++
						CASE (TMP->REALCHG) - (TMP->F2_PREVCHG) > 0
							////Verifica se houve prorrogação  / qtos dias			   	    
			   	    		
			   	    		DbselectArea("SE1")
			   	    		SE1->(Dbsetorder(1))
			   	    		If SE1->(DbSeek(xFilial("SE1") + TMP->F2_SERIE + TMP->F2_DOC )) 
				   	    		//nDiasProrrog := SE1->E1_VENCREA - SE1->E1_VENCTO 
				   	    		nDiasProrrog := 0
				   	    		If (SE1->E1_VENCREA - SE1->E1_VENCTO) >= 2
				   	    			nTotProrrog++
				   	    			nDiasProrrog := (SE1->E1_VENCREA - SE1->E1_VENCTO)			   	    	
				   	    		Endif
				   	    	//Else
				   	    	//	Msgbox("não encontrou: " + TMP->F2_DOC )
				   	    	Endif
			   	    
							//If (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 1		//chamado 002082 - Alexandre(não computar atrasos de apenas um dia)
								nAt++
							//Else
							If (TMP->REALCHG) - (TMP->F2_PREVCHG) = 1
								nATUMDIA++
									DO CASE
										CASE (TMP->A1_SATIV1 = '000001') 
											nUmDiaDistri := nUmDiaDistri + 1
										CASE (TMP->A1_SATIV1 = '000002')
											nUmDiaDistri := nUmDiaDistri + 1
										CASE (TMP->A1_SATIV1 = '000003')
											nUmDiaDistri := nUmDiaDistri + 1
										CASE (TMP->A1_SATIV1 = '000085')
											nUmDiaRevend := nUmDiaRevend + 1
										CASE (TMP->A1_SATIV1 = '000004')
											nUmDiaAtacad := nUmDiaAtacad + 1
									    //CASE (TMP->A1_SATIV1 = '')
									 	//	nBranco := nBranco + 1 
									 	 //OTHERWISE
									 	   //	nUmDiaOutro := nUmDiaOutro + 1
									ENDCASE
							Endif
							
							////FR - FLÁVIA ROCHA - encaixei DENTRO DESTE CASE: TMP->REALCHG - TMP->F2_PREVCHG > 0
							//// e fora do IF !EMPTY(TMP->F2_UFCHG)
							///pois é onde sabemos que a [data Real chegada (F2_REALCHG)] - [data Prevista chegada (F2_PREVCHG)] > 0
							DO CASE
								CASE (TMP->A1_SATIV1 = '000001') 
									nDistri := nDistri + 1
								CASE (TMP->A1_SATIV1 = '000002')
									nDistri := nDistri + 1
								CASE (TMP->A1_SATIV1 = '000003')
									nDistri := nDistri + 1
								CASE (TMP->A1_SATIV1 = '000085')
									nRevend := nRevend + 1
								CASE (TMP->A1_SATIV1 = '000004')
									nAtacad := nAtacad + 1
							    //CASE (TMP->A1_SATIV1 = '')
							 	//	nBranco := nBranco + 1 
							   //	OTHERWISE
							 	 //	nOutro := nOutro + 1
							ENDCASE							
							////FR - FLÁVIA ROCHA até aqui
							
							nUF_REAL := 0
							If !Empty(TMP->F2_UFCHG)           //F2_UFCHG - este campo indica a data de chegada na UF Destino
								If (TMP->REALCHG - TMP->F2_UFCHG) > 0
									nUF_REAL := (TMP->REALCHG - TMP->F2_UFCHG)
									nAtTrans++
							//é adequado encaixar fora deste "if" conforme acima na linha 698
							/*		DO CASE          //retirar daqui
											CASE (TMP->A1_SATIV1 = '000001') 
												nDistri := nDistri + 1
											CASE (TMP->A1_SATIV1 = '000002')
												nDistri := nDistri + 1
											CASE (TMP->A1_SATIV1 = '000003')
												nDistri := nDistri + 1
											CASE (TMP->A1_SATIV1 = '000085')
												nRevend := nRevend + 1
											CASE (TMP->A1_SATIV1 = '000004')
												nAtacad := nAtacad + 1
										    //CASE (TMP->A1_SATIV1 = '')
										 	//	nBranco := nBranco + 1 
										 	//OTHERWISE
										 	//	nOutro := nOutro + 1
									ENDCASE   */
								Endif
							
							Endif
						
							aAdd(aAtrasos, {cMunicp,; 											//1 cidade
										 (TMP->REALCHG) - (TMP->F2_PREVCHG),;				//2 dias atraso (dias decorridos entre a previsão e a chegada real)
										 TMP->A1_NREDUZ,;										//3 nome cliente
										 alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;			//4 localidade
										 TMP->F2_DOC,;											//5 nota
										 alltrim(TMP->F2_OBS) ,;								//6 obs da nf
										 nDiasProrrog,;											//7 dias prorrogados do título
										 TMP->F2_UFCHG,;										//8 data chegada na UF destino
										 nUF_REAL })						 					//9 dias em transporte(dias decorridos entre a chegada na UF e no cliente)
											
						CASE (TMP->REALCHG) - (TMP->F2_PREVCHG) < 0
							nAd++
						
						
			   	    ENDCASE
			   	    
			   	    
			   	    
		   		    // x++ - EM 24/10/11 - CHAMADO 002365 RETIREI O CONTADOR DAQUI E DEIXEI FORA
		   		    //DA CONDIÇÃO SE NÃO HÁ RETENÇÃO NEM AGENDAMENTO
		        endif
		        x++
		        DbselectArea("SX5")
		        Dbsetorder(1)
		        SX5->(Dbseek(xFilial("SX5") + 'T3' + TMP->A1_SATIV1 ))
		        cSegmento := Alltrim( Substr(SX5->X5_DESCRI,1,35) )
		        
		   		aAdd(aNotas, {TMP->F2_DOC, TMP->A1_NREDUZ, TMP->F2_DTEXP, TMP->F2_PREVCHG, TMP->REALCHG, TMP->F2_EMISSAO, cSegmento, TMP->F2_DATRASO, TMP->F2_DTAGCLI, TMP->F2_UFCHG, TMP->D2_TES, TMP->F4_TEXTO } )
		   		////			1				2				3				4				5					6			7				8				9              10            11             12
				TMP->( DbSkip() )
			EndDo
		Else  //TEM QUE FAZER EM CIMA E EM BAIXO
			//msgbox("redespacho")
			nMDAtraso := 0
			while !TMP->( EoF() ) .AND. (alltrim(TMP->ZZ_DESC) == Alltrim(cMunicp) ) .AND. (alltrim(TMP->F2_REDESP) == Alltrim(cCodTransp) )
		        if Empty(TMP->F2_DTAGCLI) .AND. TMP->F2_RETENC != "S" //.AND. Empty(TMP->F2_RETENC)		
					//nMDAtraso += (TMP->F2_REALCHG) - (TMP->F2_PREVCHG)
					If (TMP->REALCHG) - (TMP->F2_PREVCHG) > 0
						nMDAtraso += (TMP->F2_REALCHG) - (TMP->F2_PREVCHG)
					Endif
					nMDEntreg += (TMP->REALCHG) - (TMP->F2_DTEXP)
					
					///fiz esta query, pq pelo dbseek não está encontrando (tamanhos de campos diferentes)
					cQuery := " Select ZZ_TRANSP, ZZ_LOCAL, ZZ_PRZENT "
					cQuery += " From " + RetSqlname("SZZ") + " SZZ "
					cQuery += " Where RTRIM(ZZ_TRANSP) = '" + cCodTransp + "' "
					cQuery += " and RTRIM(ZZ_LOCAL) = '" + Alltrim(TMP->F2_LOCALIZ) + "' "
					cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
					cQuery += " and SZZ.D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery( cQuery )
					//MemoWrite("C:\SZZ-REDESP.SQL", cQuery )
					If Select("SZZ1") > 0
						DbSelectArea("SZZ1")
						DbCloseArea()
					Endif
				
					TCQUERY cQuery NEW ALIAS "SZZ1"
					SZZ1->(DBGOTOP())
					While !SZZ1->( EOF() ) 
						nProm := SZZ1->ZZ_PRZENT
						
						SZZ1->(DBSKIP())
					Enddo 
					
					DbSelectArea("TMP")
					If TMP->F4_DUPLIC = 'N'
	       				nNFNVen++
	       			Endif



					DO CASE
						CASE (TMP->REALCHG) - (TMP->F2_PREVCHG) == 0
							nTm++       //no prazo
						CASE (TMP->REALCHG) - (TMP->F2_PREVCHG) > 0
						
							////Verifica se houve prorrogação  / qtos dias
			   	    		DbselectArea("SE1")
			   	    		SE1->(Dbsetorder(1))
			   	    		If SE1->(DbSeek(xFilial("SE1") + TMP->F2_SERIE + TMP->F2_DOC )) 
				   	    		nDiasProrrog := 0 
				   	    		If (SE1->E1_VENCREA - SE1->E1_VENCTO) >= 2
				   	    			nTotProrrog++
				   	    			nDiasProrrog := (SE1->E1_VENCREA - SE1->E1_VENCTO)			   	    			
				   	    		Endif             
				   	    	//Else
				   	    		//Msgbox("não encontrou: " + TMP->F2_DOC )
				   	    	Endif
			   	    
							//If (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 1		//chamado 002082 - Alexandre(não computar atrasos de apenas um dia)
								nAt++
							
							If (TMP->REALCHG) - (TMP->F2_PREVCHG) = 1
								nATUMDIA++
									DO CASE
										CASE (TMP->A1_SATIV1 = '000001') 
											nUmDiaDistri := nUmDiaDistri + 1
										CASE (TMP->A1_SATIV1 = '000002')
											nUmDiaDistri := nUmDiaDistri + 1
										CASE (TMP->A1_SATIV1 = '000003')
											nUmDiaDistri := nUmDiaDistri + 1
										CASE (TMP->A1_SATIV1 = '000085')
											nUmDiaRevend := nUmDiaRevend + 1
										CASE (TMP->A1_SATIV1 = '000004')
											nUmDiaAtacad := nUmDiaAtacad + 1
									 //   OTHERWISE
									   //		nUmDiaOutro  := nUmDiaOutro + 1
									ENDCASE
							Endif
							
							////FR - FLÁVIA ROCHA  - início
							DO CASE
								CASE (TMP->A1_SATIV1 = '000001') 
									nDistri++
								CASE (TMP->A1_SATIV1 = '000002')
									nDistri++
								CASE (TMP->A1_SATIV1 = '000003')
									nDistri++
								CASE (TMP->A1_SATIV1 = '000085')
									nRevend++
								CASE (TMP->A1_SATIV1 = '000004')
									nAtacad++
							//	CASE (TMP->A1_SATIV1 = '')
							//		nBranco++  
						   //		OTHERWISE
							 //		nOutro := nOutro + 1
							ENDCASE
							///FR - FLÁVIA ROCHA - até aqui
							
							nUF_REAL := 0
							If !Empty(TMP->F2_UFCHG)
								If (TMP->REALCHG - TMP->F2_UFCHG) > 0
									nUF_REAL := (TMP->REALCHG - TMP->F2_UFCHG)
									nAtTrans++
									//idem anterior, é adequado encaixar fora deste "if", como fiz acima na linha 839
									/*	DO CASE
											CASE (TMP->A1_SATIV1 = '000001') 
												nDistri++
											CASE (TMP->A1_SATIV1 = '000002')
												nDistri++
											CASE (TMP->A1_SATIV1 = '000003')
												nDistri++
											CASE (TMP->A1_SATIV1 = '000085')
												nRevend++
											CASE (TMP->A1_SATIV1 = '000004')
												nAtacad++
										   //	CASE (TMP->A1_SATIV1 = '')
										   //		nBranco++  
										   //	OTHERWISE
										   //		nOutro := nOutro + 1
										ENDCASE */
								Endif
							
							Endif
						
							aAdd(aAtrasos, {cMunicp,; 											//1 cidade
										 (TMP->REALCHG) - (TMP->F2_PREVCHG),;				//2 dias atraso (dias decorridos entre a previsão e a chegada real)
										 TMP->A1_NREDUZ,;										//3 nome cliente
										 alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;			//4 localidade
										 TMP->F2_DOC,;											//5 nota
										 alltrim(TMP->F2_OBS) ,;								//6 obs da nf
										 nDiasProrrog,;											//7 dias prorrogados do título
										 TMP->F2_UFCHG,;										//8 data chegada na UF destino
										 nUF_REAL })						 					//9 dias em transporte(dias decorridos entre a chegada na UF e no cliente)
									

						CASE (TMP->REALCHG) - (TMP->F2_PREVCHG) < 0
							nAd++            //adiantado
						
						
			   	    ENDCASE
			   	    			   	    			   	    			   	    
		   		    // x++ - EM 24/10/11 - CHAMADO 002365 RETIREI O CONTADOR DAQUI E DEIXEI FORA
		   		    //DA CONDIÇÃO SE NÃO HÁ RETENÇÃO NEM AGENDAMENTO
		        endif
		        x++
		        DbselectArea("SX5")
		        Dbsetorder(1)
		        SX5->(Dbseek(xFilial("SX5") + 'T3' + TMP->A1_SATIV1 ))
		        cSegmento := Alltrim(Substr(SX5->X5_DESCRI,1,35) )
//									1			2				3				4				5					6			7	   		8					9	          10            11             12
		   		aAdd(aNotas, {TMP->F2_DOC, TMP->A1_NREDUZ, TMP->F2_DTEXP, TMP->F2_PREVCHG, TMP->REALCHG, TMP->F2_EMISSAO, cSegmento, TMP->F2_DATRASO, TMP->F2_DTAGCLI, TMP->F2_UFCHG, TMP->D2_TES, TMP->F4_TEXTO } )
				
				TMP->( DbSkip() )
			EndDo
		Endif		////endif do redespacho
		
		nAtX 		+= (nAt - nATUMDIA)   	////Atrasos - atrasos de 1 dia
		nAdX 		+= (nAd - nNFNVen)		////Adiantados - notas que não são faturamento
		nTmX 		+= (nTm - nNFNVen)		////Total entregue no prazo - notas que não são faturamento
		nATUF_X		+= nAtTrans ////Total entregas atrasadas só no transporte
		nATU1DX		+= nATUMDIA ////Total entregas atrasadas apenas um dia
		nNFNVenX	+= nNFNVen  ////Total de entregas em que a NF não é de Vendas
		
//						1			2		3		  4  5	 6    7    8   9    10		11			12			13		
		aAdd(aResult, {cTransp, cMunicp, nMDAtraso/x, 1, 0, nTm, nAt, nAd, x, aNotas, nMDEntreg/x, nProm, nTotProrrog} )
	EndDo
	
	If nLin > 55
		Cabec(titulo, "", "", nomeprog, tamanho, 15)
		nLin := 8
		@ nLin,000 PSay cCabec_01
		nLin++
		@ nLin,000 PSay Repl( '-', 201) // linha 7
		nLin++
	Endif
	
	cTrn := ''
	
	     //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	     //         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20  	  
         //            999999999    xxxxxxxxxxxxxxxxxxxx       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     99/99/99        99/99/99         99/99/99           99/99/99         9999
	//cCabec_01 := "|  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA (CLIENTE) | QNT. DE DIAS  | TES"
    nDiasUteis := 0    
	FOR Y := 1 TO Len(aResult)
		FOR Z := 1 TO Len(aResult[Y][10])
			IF nLin > 55
				Cabec(titulo, "", "", nomeprog, tamanho, 15)
				nLin := 8
				@ nLin,000 PSay cCabec_01
				nLin++
				@ nLin,000 PSay Repl( '-', 201)
				nLin++			
			ENDIF    //somei dezessete aos três últimos
			
			@ nLin,004 PSay alltrim(aResult[Y][10][Z][1])   	//NF
			@ nLin,017 PSay alltrim( Substr(aResult[Y][10][Z][2] , 1, 24 ) )     //CLIENTE
			@ nLin,044 Psay alltrim( Substr(aResult[Y][10][Z][7] , 1, 35 ) )		//SEGMENTO
			@ nLin,084 PSay Dtoc(aResult[Y][10][Z][6])        	//DT. EMISSÃO
			@ nLin,100 PSay Dtoc(aResult[Y][10][Z][3])			//DT. EXPEDIÇÃO
			//@ nLin,117 PSay Dtoc( aResult[Y][10][Z][4] + 1 )	//DT. PREVISÃO CHEGADA
			@ nLin,117 PSay Dtoc( aResult[Y][10][Z][4] )	//DT. PREVISÃO CHEGADA
			@ nLin,136 PSay Dtoc(aResult[Y][10][Z][5])			//DT. REAL CHEGADA
			//@ nLin,164 PSay alltrim(str( aResult[Y][10][Z][5] - ( aResult[Y][10][Z][3] + 1 )  ) ) + " " + "Dia(s)"
			//em 22/03/10 foi solicitado por Alexandre que alterasse o método de cálculo da coluna dias (Dt. Chegada - (Dt.Expedição + 1) )						
			//Chamado 001896 - Alexandre solicitou que o cálculo de dias seja considerado dias úteis e não corridos
			//msgbox( "dtexp + 1: " + dtoc(aResult[Y][10][Z][3] + 1))  
			
			nDiasUteis := DiasUteis( ( aResult[Y][10][Z][3] + 1 ), aResult[Y][10][Z][5] )
			                          //Dt. Expedição + 1        , Dt. Chegada Real 
			@ nLin,164 PSay alltrim(str( nDiasUteis  ) ) + " " + "Dia(s)"
			@ nLin,179 PSay alltrim(aResult[Y][10][Z][11])		//TES
			@ nLin,182 PSay "-" + alltrim(aResult[Y][10][Z][12])		//TEXTO TES
			
			nLin++
		NEXT
		
		//nLin := 55
		IF nLin > 54
			Cabec(titulo, "", "", nomeprog, tamanho, 15)
			nLin := 8
			@ nLin,000 PSay cCabec_01
			nLin++
			@ nLin,000 PSay Repl( '-', 201)
			nLin++			
		ENDIF
		
		//					1		2		3		    4  5   6    7    8   9    10		11	    	12		13		
		//aAdd(aResult, {cTransp, cMunicp, nMDAtraso/x, 1, 0, nTm, nAt, nAd, x, aNotas, nMDEntreg/x, nProm, nTotProrrog} )
		@ nLin,004 PSay "TRANSP.:" +" "+ alltrim(aResult[Y][1])
		nLin++
		@ nLin,004 PSay "MUNCIP.:" +" "+ alltrim(aResult[Y][2])
		nLin++
		@ nLin,004 PSay "MEDIA DE ATRASO (Dt. Chegada - Dt.PREVISTA / Qtd.Entregas):"     +" "+ alltrim(transform(aResult[Y][3],  "@E 999,999.99")) // +" | "+;
		nLin++
		@ nLin,004 PSay "MEDIA DE DIAS   (Dt.Chegada - Dt.SAÍDA / Qtd.Entregas)    :"     +" "+ alltrim(transform(aResult[Y][11], "@E 999,999.99"))  //+" | "+;		  //que levou da dt. expedição até dt. chegada cliente
		nLin++
		//@ nLin,004 PSay "DIAS TRANSPORTADORA (Qtd. Dias úteis entre Dt.CHEGADA - Dt.SAÍDA):"    +" "+ alltrim(transform(aResult[Y][12], "@E 999,999.99"))
		//@ nLin,004 PSay "PRAZO DA TRANSPORTADORA (Qtd. Dias úteis entre Dt.CHEGADA - Dt.SAÍDA):"    +" "+ alltrim(transform(nDiasUteis, "@E 999,999.99"))
		@ nLin,004 PSay "PRAZO DA TRANSPORTADORA :"    +" "+ alltrim(transform(aResult[Y][12], "@E 999,999.99"))
		nLin++
		@ nLin,004 PSay "QTD. DE ENTREGAS:" +" "+ alltrim(str(aResult[Y][9]))
		nLin++
		@ nLin,004 PSay "NO VENCIMENTO: "+ alltrim(str(aResult[Y][6])) +"  "+ "ATRASADAS: "+ alltrim(str(aResult[Y][7])) +"  "+;
		"ADIANTADAS: "+ alltrim(str(aResult[Y][8]))+;
		iif( Y != Len(aResult), iif( aResult[Y][1] != aResult[ Y + 1 ][1],;
		" ** "+"FIM DAS INFORMACOES DA TRANSP. " + alltrim(aResult[Y][1])+" ** ","" ),;
		" ** "+"FIM DAS INFORMACOES DA TRANSP. " + alltrim(aResult[Y][1])+" ** " )     
		nLin++
		@ nLin,000 PSay Repl('-', 201)
		nLin++
		
	NEXT
	TMP->( dbCLoseArea() )
	
	//cQuery := "select distinct F2_DOC, F2_DTEXP, F2_REALCHG, F2_PREVCHG, F2_DATRASO, F2_DTAGCLI, A1_EST, F2_EST "
	cQuery := "select distinct F2_DOC, F2_DTEXP, F2_PREVCHG, F2_DATRASO, F2_DTAGCLI, A1_EST, F2_EST "
	cQuery += " ,CASE WHEN SF2.F2_REALCHG !='' THEN SF2.F2_REALCHG " + LF
	cQuery += " ELSE " + LF
	cQuery += " CASE WHEN SF2.F2_DTTRANS != '' THEN SF2.F2_DTTRANS " + LF
	cQuery += " END END AS REALCHG " + LF 
	
	cQuery += " from   " + retSqlName('SA1') + " SA1, " 
	cQuery += "" + retSqlName('SF2') + " SF2, "
	cQuery += "" + retSqlName('SA4') + " SA4 "
	cQuery += " where  A1_FILIAL = '" +xFilial('SA1') + "' "
	//cQuery += " and F2_FILIAL = '"+xFilial('SF2') +"' "
	If mv_par10 = 2
		cQuery += " and F2_FILIAL = '" + xFilial("SF2") + "' "
	EndIf
	cQuery += " and A4_FILIAL = '"+xFilial('SA4')+"' "
	
	cQuery += " and A4_COD <>'024' "  // TIRAR CLIENTE RETIRA 
	
	cQuery += " and F2_CLIENTE = A1_COD "
	cQuery += " and F2_LOJA = A1_LOJA "
	cQuery += " and SF2.F2_TRANSP = SA4.A4_COD "
	cQuery += " and F2_EMISSAO >= '"+ alltrim(dtos(mv_par03)) +"' and  F2_EMISSAO <= '"+ alltrim(dtos(mv_par04)) +"' "
	IF !empty(mv_par01)
		cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  "
	ENDIF
	IF !empty(mv_par02)
		cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  "
	ENDIF
	
	IF !empty(mv_par05)
		cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "' "
	ENDIF
	
	cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF
	IF mv_par08 = 1
		cQuery += " and SF2.F2_EST IN " + cRegiao + LF
	ENDIF
	
	cQuery += " and F2_REALCHG <> '' and F2_PREVCHG <> '' "
	cQuery += " and SA1.D_E_L_E_T_ <> '*' and SF2.D_E_L_E_T_ <> '*' and SA4.D_E_L_E_T_ <> '*' "
	cQuery += " AND F2_DTAGCLI = '' AND F2_RETENC = '' "
	cQuery += " order by A1_EST "
	MemoWrite("C:\FATRETb.SQL", cQuery )
	
	TCQUERY cQuery NEW ALIAS 'TMP'
	TMP->( dbGoTop() )
	
	TCSetField('TMP', "F2_EMISSAO", "D")
	TCSetField('TMP', "F2_DTEXP", "D")
	TCSetField('TMP', "F2_DTAGCLI", "D")
	TCSetField('TMP', "REALCHG", "D")
	TCSetField('TMP', "F2_PREVCHG",  "D")
	TCSetField('TMP', "F2_DATRASO",  "D")
	TCSetField('TMP', "F2_DTAGCLI",  "D")
	
	
	If TMP->( EoF() )			////SE A QUERY NÃO TEVE RESULTADOS, PODE SER PQ A TRANSP É REDESPACHO, ENTÃO REFAÇO A QUERY CONSIDERANDO REDESPACHO
								////F2_REDESP = A4_COD
		//Msgbox("Novo(2): A transp é redespacho")
		
		//cQuery := "select distinct F2_DOC, F2_DTEXP, F2_REALCHG, F2_PREVCHG, F2_DATRASO, F2_DTAGCLI, A1_EST, F2_EST "
		cQuery := "select distinct F2_DOC, F2_DTEXP, F2_PREVCHG, F2_DATRASO, F2_DTAGCLI, A1_EST, F2_EST "
		cQuery += " ,CASE WHEN SF2.F2_REALCHG !='' THEN SF2.F2_REALCHG " + LF
		cQuery += " ELSE " + LF
		cQuery += " CASE WHEN SF2.F2_DTTRANS != '' THEN SF2.F2_DTTRANS " + LF
		cQuery += " END END AS REALCHG " + LF 
	
		cQuery += " from   " + retSqlName('SA1') + " SA1, " 
		cQuery += "" + retSqlName('SF2') + " SF2, "
		cQuery += "" + retSqlName('SA4') + " SA4 "
		cQuery += " where  A1_FILIAL = '" +xFilial('SA1') + "' "
		//cQuery += " and F2_FILIAL = '"+xFilial('SF2') +"' "
		If mv_par10 = 2
			cQuery += " and F2_FILIAL = '" + xFilial("SF2") + "' "
		EndIf
		cQuery += " and A4_FILIAL = '"+xFilial('SA4')+"' "
		cQuery += " and F2_CLIENTE = A1_COD "
		cQuery += " and F2_LOJA = A1_LOJA "
		cQuery += " and SF2.F2_REDESP = SA4.A4_COD "
		cQuery += " and F2_EMISSAO >= '"+ alltrim(dtos(mv_par03)) +"' and  F2_EMISSAO <= '"+ alltrim(dtos(mv_par04)) +"' "
		IF !empty(mv_par01)
			cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  "
		ENDIF
		IF !empty(mv_par02)
			cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  "
		ENDIF
		
		IF !Empty(mv_par05)
			cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "' "
		ENDIF
		
		cQuery += " and SF2.F2_EST BETWEEN '" + alltrim(mv_par06) + "' AND '" + alltrim(mv_par07) + "'  " +LF
		IF mv_par08 = 1
			cQuery += " and SF2.F2_EST IN " + cRegiao + LF
		ENDIF
		
		cQuery += " and F2_REALCHG <> '' and F2_PREVCHG <> '' "
		cQuery += " and SA1.D_E_L_E_T_ <> '*' and SF2.D_E_L_E_T_ <> '*' and SA4.D_E_L_E_T_ <> '*' "
		cQuery += " AND F2_DTAGCLI = '' AND F2_RETENC = '' "
		cQuery += " order by A1_EST "
		MemoWrite("C:\FATRETbr.SQL", cQuery )
		
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		Endif
		
		TCQUERY cQuery NEW ALIAS 'TMP'
		TMP->( dbGoTop() )
		
		TCSetField('TMP', "F2_EMISSAO", "D")
		TCSetField('TMP', "F2_DTEXP", "D")
		TCSetField('TMP', "F2_DTAGCLI", "D")
		TCSetField('TMP', "REALCHG", "D")
		TCSetField('TMP', "F2_PREVCHG",  "D")
		TCSetField('TMP', "F2_DATRASO",  "D")
		TCSetField('TMP', "F2_DTAGCLI",  "D")
		
	Endif
	
//contadores de entregas por região
nCTNO := nCTNE := nCTCE := nCTSD := nCTSL := 0
//acumuladores de dias de entrega
nDIANO := nDIANE := nDIACE := nDIASD := nDIASL := 0
//variável de pico de entrega (entrega mais demorada)
nTOPNO := nTOPNE := nTOPCE := nTOPSD := nTOPSL := 0

//msgbox("nDIANE: " + STR(nDIANE))
	TMP->( dbGoTop() )
		
	do While !TMP->( EOF() )
		
		if TMP->A1_EST $ cRGNO
			DO CASE
		    	CASE ((TMP->REALCHG - TMP->F2_PREVCHG) > 0)
		    	nConAtz_NO++
		    END CASE
			nDIANO += ( TMP->REALCHG - (TMP->F2_DTEXP + 1) )
			iif(TMP->REALCHG - TMP->F2_PREVCHG > nTOPNO, nTOPNO := TMP->REALCHG - TMP->F2_PREVCHG, )
			nCTNO++
			//Look IN:
		    //iif (TMP->REALCHG - TMP->F2_PREVCHG > 1 , nContaAtz_NO := nContaAtz_NO + 1 , nContaAtz_NO )
		    //End Look in
		elseIf TMP->A1_EST $ cRGNE
			DO CASE
				CASE ((TMP->REALCHG - TMP->F2_PREVCHG) > 0)
				nConAtz_NE++
			END CASE
			nDIANE += (TMP->REALCHG - (TMP->F2_DTEXP + 1) )
			iif(TMP->REALCHG - TMP->F2_PREVCHG > nTOPNE, nTOPNE := TMP->REALCHG - TMP->F2_PREVCHG, )
			nCTNE++
			//Look IN:
			//iif (TMP->REALCHG - TMP->F2_PREVCHG > 1 , nContaAtz_NE := nContaAtz_NE + 1 , nContaAtz_NE )
		    //End Look in
		elseIf TMP->A1_EST $ cRGCE
			DO CASE
				CASE ((TMP->REALCHG - TMP->F2_PREVCHG) > 0)
				nConAtz_CE++
			END CASE
			nDIACE += (TMP->REALCHG - (TMP->F2_DTEXP + 1) )
			iif(TMP->REALCHG - TMP->F2_PREVCHG > nTOPCE, nTOPCE := TMP->REALCHG - TMP->F2_PREVCHG, )
			nCTCE++
			//Look IN:
			//iif (TMP->REALCHG - TMP->F2_PREVCHG > 1 , nContaAtz_SL := nContaAtz_SL + 1 , nContaAtz_SL )
		    //End Look in
		elseIf TMP->A1_EST $ cRGSD
			DO CASE
				CASE ((TMP->REALCHG - TMP->F2_PREVCHG) > 0)
				nConAtz_SD++
			END CASE
			nDIASD += (TMP->REALCHG - (TMP->F2_DTEXP + 1) )
			iif(TMP->REALCHG - TMP->F2_PREVCHG > nTOPSD, nTOPSD := TMP->REALCHG - TMP->F2_PREVCHG, )
			nCTSD++
			//Look IN:
		    //iif (TMP->REALCHG - TMP->F2_PREVCHG > 1 , nContaAtz_SD := nContaAtz_SD + 1 , nContaAtz_SD )
		    //End Look in
		elseIf TMP->A1_EST $ cRGSL
			DO CASE
				CASE ((TMP->REALCHG - TMP->F2_PREVCHG) > 0)
				nConAtz_SL++
			END CASE
			nDIASL += (TMP->REALCHG - (TMP->F2_DTEXP + 1) )
			iif(TMP->REALCHG - TMP->F2_PREVCHG > nTOPSL, nTOPSL := TMP->REALCHG - TMP->F2_PREVCHG, )
			nCTSL++
			//Look IN:
		    //iif (TMP->REALCHG - TMP->F2_PREVCHG > 1 , nContaAtz_CE := nContaAtz_CE + 1 , nContaAtz_CE )
		    //End Look in
		else
			msgAlert("O estado " + TMP->A1_EST + "nao esta cadastrado em nenhuma regiao! ")
			return
		endIf
		TMP->( dbSkip() )
	endDo

Endif

nLin := 90
///////DAQUI CONTINUA NORMAL tanto para antigo como novo pós-vendas
If nLin > 55
	Cabec(titulo, "", "", nomeprog, tamanho, 15)
	nLin := 8                                                           
Endif	
//0123456789012345678901234567890123456789012345678901234567890123456789
//         10        20        30        40        50        60
@nLin, 000 PSAY "Regiao              | Media de entrega no periodo | Pico de atraso no periodo | Quantidade Dias Região | Percentual Dias Região"
nLin++

@nLin, 000 PSAY "Norte"
@nLin    , 032 PSAY transform(nDIANO/nCTNO, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPNO, "@E 99,999")
@nLin    , 085 PSAY transform(nConAtz_NO, "@E 999.99")
@nLin    , 109 PSAY (transform( (nConAtz_NO/(nConAtz_NO+nConAtz_NE+nConAtz_CE+nConAtz_SD+nConAtz_SL))*100,  "@E 999.99"))+" %"
nLin++

@nLin, 000 PSAY "Nordeste"
@nLin    , 032 PSAY transform(nDIANE/nCTNE, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPNe, "@E 99,999")
@nLin    , 085 PSAY transform(nConAtz_NE, "@E 999.99")
@nLin    , 109 PSAY (transform( (nConAtz_NE/(nConAtz_NO+nConAtz_NE+nConAtz_CE+nConAtz_SD+nConAtz_SL))*100,  "@E 999.99"))+" %"
nLin++

@nLin, 000 PSAY "Centro-Oeste"
@nLin    , 032 PSAY transform(nDIACE/nCTCE, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPCE, "@E 99,999")
@nLin    , 085 PSAY transform(nConAtz_CE, "@E 999.99")
@nLin    , 109 PSAY (transform( (nConAtz_CE/(nConAtz_NO+nConAtz_NE+nConAtz_CE+nConAtz_SD+nConAtz_SL))*100,  "@E 999.99"))+" %"
nLin++

@nLin, 000 PSAY "Sudeste"
@nLin    , 032 PSAY transform(nDIASD/nCTSD, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPSD, "@E 99,999")
@nLin    , 085 PSAY transform(nConAtz_SD, "@E 999.99")
@nLin    , 109 PSAY (transform( (nConAtz_SD/(nConAtz_NO+nConAtz_NE+nConAtz_CE+nConAtz_SD+nConAtz_SL))*100,  "@E 999.99"))+" %"
nLin++

@nLin, 000 PSAY "Sul"
@nLin    , 032 PSAY transform(nDIASL/nCTSL, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPSL, "@E 99,999")
@nLin    , 085 PSAY transform(nConAtz_SL, "@E 999.99")
@nLin    , 109 PSAY (transform( (nConAtz_SL/(nConAtz_NO+nConAtz_NE+nConAtz_CE+nConAtz_SD+nConAtz_SL))*100,  "@E 999.99"))+" %"
nLin++
nLin++

iif( nAtX < 0, nAtX := 0, nAtX := nAtX)
@nLin, 000 PSAY "Total de entregas atrasadas             : " + alltrim(str(nAtX))       +"             "+alltrim(transform( (nAtX/(nAtX+nAdX+nTmX+nNFNVenX+nATU1DX))*100,  "@E 999.99"))+" %"
nLin++   
	@nLin, 005 PSAY "Atacadista                         : "  + alltrim(str(nAtacad))    +" Cliente(s)  "+alltrim(transform( (nAtacad/nAtx)*100, "@E 999.99"))+" %"
	nLin++
	@nLin, 005 PSAY "Distribuidor                       : "  + alltrim(str(nDistri))    +" Cliente(s)  "+alltrim(transform( (nDistri/nAtx)*100, "@E 999.99"))+" %"
	nLin++
	@nLin, 005 PSAY "Revendedor                         : "  + alltrim(str(nRevend))    +" Cliente(s)  "+alltrim(transform( (nRevend/nAtx)*100, "@E 999.99"))+" %"
	nLin++
  /*  @nLin, 005 PSAY "Em Branco                          : "  + alltrim(str(nBranco))    +" Dias"
	nLin++ */
  //  @nLin, 005 PSAY "Outros                             : "  + alltrim(str(nOutro))     +" Clientes(s)"
//	nLin++

//nATU1DX		+= nATUMDIA
@nLin, 000 PSAY "Total de entregas atrasadas 1 DIA       : " + alltrim(str(nATU1DX))    +"             "+alltrim(transform( (nATU1DX / (nAtX+nAdX+nTmX+nATU1DX))*100,  "@E 999.99"))+" %"
nLin++
	@nLin, 005 PSAY "Atacadista                         : "  + alltrim(str(nUmDiaAtacad)) + " Clientes(s) "+alltrim(transform( (nUmDiaAtacad/nATU1DX)*100, "@E 999.99"))+" %"
	nLin++
	@nLin, 005 PSAY "Distribuidor                       : "  + alltrim(str(nUmDiaDistri)) + " Clientes(s) "+alltrim(transform( (nUmDiaDistri/nATU1DX)*100, "@E 999.99"))+" %"
	nLin++
	@nLin, 005 PSAY "Revendedor                         : "  + alltrim(str(nUmDiaRevend)) + " Clientes(s) "+alltrim(transform( (nUmDiaRevend/nATU1DX)*100, "@E 999.99"))+" %" 
	nLin++
  //  @nLin, 005 PSAY "Outros                             : "  + alltrim(str(nUmDiaOutro))  + " Clientes(s)"
//	nLin++ 

@nLin, 000 PSAY "Total de entregas c/ vencto prorrogados : " + alltrim(str(nTotProrrog))+"             "+alltrim(transform( (nTotProrrog/(nAtX+nAdX+nTmX+nTotProrrog))*100,  "@E 999.99"))+" %"
nLin++

iif( nAdX < 0, nAdX := 0, nAdX := nAdX)
@nLin, 000 PSAY "Total de entregas adiantadas            : " + alltrim(str(nAdX))       +"             "+alltrim(transform( (nAdX/(nAtX+nAdX+nTmX))*100,  "@E 999.99"))+" %"
nLin++

iif( nTmX < 0, nTmX := 0, nTmX := nTmX)                                                           
@nLin, 000 PSAY "Total de entregas no vencimento         : " + alltrim(str(nTmX))       +"             "+alltrim(transform( (nTmX/(nAtX+nAdX+nTmX))*100,  "@E 999.99"))+" %"
nLin++

////15/10/2010: solicitado por Alexandre
@nLin, 000 PSAY "Total de atrasos apenas no transporte   : " + alltrim(str(nATUF_X))    +"             "+alltrim(transform( (nATUF_X/(nAtX+nAdX+nTmX+nATUF_X))*100,  "@E 999.99"))+" %"
nLin++

//nNFNVenX	+= nNFNVen  ////Total de entregas em que a NF não é de Vendas
@nLin, 000 PSAY "Total de entregas NF não-Vendas         : " + alltrim(str(nNFNVenX))   +"             "+alltrim(transform( (nNFNVenX/(nAtX+nAdX+nTmX+nATU1DX+nNFNVenX))*100,  "@E 999.99"))+" %"
nLin++


nLin := 90

If nLin > 55                                                                                                            
	Cabec(titulo, padr("Atrasos",140)    , "Localidade                    | Dias de atraso | Cliente                   | Nota     | Observacao                              | QTD. Dias Prorrogados | Dt.Chegada UF Destino | Dias Atraso no Transporte", nomeprog, tamanho, 15)
	nLin := 9
Endif
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          10        20        30        40        50        60        70        80        90
/*
aAdd(aAtrasos, {cMunicp,; 											//1 cidade
			 (TMP->F2_REALCHG) - (TMP->F2_PREVCHG),;				//2 dias atraso (dias decorridos entre a previsão e a chegada real)
			 TMP->A1_NREDUZ,;										//3 nome cliente
			 alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;			//4 localidade
			 TMP->F2_DOC,;											//5 nota
			 alltrim(TMP->F2_OBS) ,;								//6 obs da nf
			 nDiasProrrog,;											//7 dias prorrogados do título
			 TMP->F2_UFCHG,;										//8 data chegada na UF destino
			 (TMP->REALCHG - TMP->F2_UFCHG) }) 					//9 dias em transporte(dias decorridos entre a chegada na UF e no cliente)
*/

aSort(aAtrasos,,,{ |x,y| x[4]+x[1]+ strzero(x[2],4) + x[3] < y[4]+y[1]+ strzero(y[2],4) + y[3] } )
for t := 1 to len(aAtrasos)				  //          10        20        30        40        50        60        70        80        90        100       110     120       130       140       150       160       170       180       190       200       210
	if nLin > 54                          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		Cabec(titulo, padr("Atrasos",140), "Localidade                    | Dias de atraso | Cliente                   | Nota     | Observacao                              | QTD. Dias Prorrogados | Dt.Chegada UF Destino | Dias Atraso no Transporte", nomeprog, tamanho, 15)
////                                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9999            XXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          9999 dia(s)        99/99/99		         9999 dia(s)
		nLin := 9
	endIf
	//
	if t>1
		if alltrim(aAtrasos[t][1])!=alltrim(aAtrasos[t-1][1])
			@nLin,000 PSAY replicate("-",30)
		endif
		if alltrim(aAtrasos[t][4])!=alltrim(aAtrasos[t-1][4])
			@nLin,000 PSAY replicate("-",176)
		endif
		nLin++
	endif
	//
	@nLin,000 PSAY substr( alltrim(aAtrasos[t][1]), 1, 30 )			Picture "@!"			///LOCALIDADE
	@nLin,032 PSAY alltrim( str( aAtrasos[t][2] ) ) + " dia(s)"		Picture "@E 9999"     ////QT.DIAS ATRASO
	@nLin,048 PSAY substr( alltrim(aAtrasos[t][3]), 1, 26 ) 		Picture "@!"         ////CLIENTE
	@nLin,076 PSAY alltrim(aAtrasos[t][5])                        						////NOTA
    @nLin,088 PSAY alltrim( Substr(aAtrasos[t][6] , 1, 40) )       						////OBSERVAÇÃO
    @nLin,138 PSAY alltrim( str( aAtrasos[t][7] ) ) + " dia(s)" 	Picture "@E 9999"		////QTD.DIAS PRORROGADOS
    @nLin,157 PSAY Dtoc(aAtrasos[t][8])								Picture "@D 99/99/99"	//DT. CHEGADA UF DESTINO
    @nLin,181 PSAY alltrim( str( aAtrasos[t][9] ) ) + " dia(s)"		Picture "@E 9999"     ////QT.DIAS ATRASO NO TRANSPORTE
	nLin++
	
next
//@nLin++,000 PSAY replicate("-",30)
nLin++
@nLin,000 PSAY replicate("-",200)

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool( wnrel ) //Chamada do Spool de Impressa
Endif

TMP->( DbCloseArea() )
MS_FLUSH()

Return Nil


**********
Static Function MODA(aArr)
**********

Local x := 1
Local nMaior := 0
Local nMod := aArr[1]
Local nAnterior
Local y
aSort(aArr)
while (x <= len(aArr))
	
	y := 0
	nAnterior := aArr[x]
	
	while (x <= len(aArr)) .AND. (nAnterior == aArr[x])
		nAnterior := aArr[x]
		x++
		y++
	endDo
	
	IF nMaior < y
		nMaior := y
		nMod := nAnterior //Qual o nº modal até o momento;
	ENDIF
	
EndDo

Return nMod

////Função para Cálculo de dias úteis dentro de um período
*********************************
Static Function DiasUteis( dDtIni, dDtFim )
*********************************

Local nDUtil := 0
Local dDtMov := dDtIni
Local dValida:= Ctod("  /  /    ") 

While dDtMov <= dDtFim
	
	If DataValida(dDtMov) = dDtMov
		nDUtil := nDUtil + 1
	Endif
		dDtMov := dDtMov + 1
EndDo
                  

Return(nDUtil) 