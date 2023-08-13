#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function PONREN()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//SetPrvt("CVALEXT,AFIELDS,CPATH,")
	SetPrvt( "cTam, sMsg, cOrdem, cCod, cString, nLin, cTurno, cEntSai" )

	#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
	#ENDIF

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³PONREN    º Autor ³ ESMERINO NETO      º Data ³  22/11/05   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Relatório para idendificação das batidas de pontos dos     º±±
	±±º          ³ funcionários por período                                   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ PONTO ELETRONICO E/OU GESTÃO DE PESSOAL                    º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Ambientais                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01        	// De Emissao                            ³
	//³ mv_par02        	// Ate Emissao                           ³
	//³ mv_par03        	// De Funcionário                        ³
	//³ mv_par04        	// Ate Funcionário                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	tamanho   := "M"
	titulo    := PADC("Relatorio de Manutenção de Apontamentos",74)
	cDesc1    := PADC("Este relatório dará as entradas dos funcionários",74)
	cDesc2    := PADC("na RAVA, com o intuito de facilidar a rotina de", 74)
	cDesc3    := PADC("apontamento diário.",74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  := "PONREN"
	cPerg     := "PONREN"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
	wnrel     := "PONREN"
	M_PAG     := 1


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( cPerg, .T. )               // Pergunta no SX1

	cString := "SP8"

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


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DESENVOLVIMENTO DO PROGRAMA          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
	cQuery := "SELECT SA1.A1_COD, SA1.A1_NOME, SA1.A1_MUN, SA1.A1_EST, SC5.C5_EMISSAO, SC5.C5_NUM, SC6.C6_PRODUTO,"
	cQuery += "( SC6.C6_VALOR / SC6.C6_QTDVEN ) AS PRECO, SC6.C6_UM, SC6.C6_SEGUM, SB1.B1_DESC,"
	cQuery += "( SC6.C6_QTDVEN - SC6.C6_QTDENT ) AS QUANT, ( ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESOR ) AS PESO "
	cQuery += "FROM " + RetSqlName( "SA1" ) + " SA1," + RetSqlName( "SB1" ) + " SB1," + RetSqlName( "SC5" ) + " SC5," + RetSqlName( "SC6" ) + " SC6 "
	cQuery += "WHERE SC5.C5_EMISSAO >= '" + Dtos( mv_par01 ) + "' AND SC5.C5_EMISSAO <= '" + Dtos( mv_par02 ) + "' AND "
	cQuery += "SC5.C5_NUM >= '" + mv_par03 +  "'AND SC5.C5_NUM <= '" + mv_par04 + "' AND "
	cQuery += "SB1.B1_COD >= '" + mv_par05 + "' AND SB1.B1_COD <= '" + mv_par06 + "' AND "
	cQuery += "SA1.A1_COD >= '" + mv_par07 + "' AND SA1.A1_COD <= '" + mv_par08 + "' AND "
	cQuery += "( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND SA1.A1_COD = SC5.C5_CLIENTE AND SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
	cQuery += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' AND "
	cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SC5X"
	TCSetField( 'SC5X', "C5_EMISSAO", "D" )
	TCSetField( 'SC5X', "QUANT", "N" , 10, 3 )
	TCSetField( 'SC5X', "PESO", "N" , 10, 3 )
	*/

	cQuery := "SELECT SP8.P8_MAT, SRA.RA_NOME, SP8.P8_DATA, SP8.P8_ORDEM, SP8.P8_HORA, SR6.R6_DESC "
	cQuery += "FROM " + RetSqlName( "SP8" ) + " SP8," + RetSqlName( "SRA" ) + " SRA," + RetSqlName("SR6") + " SR6"
	cQuery += "WHERE SP8.P8_MAT = SRA.RA_MAT AND "
	cQuery += "SP8.P8_TURNO = SR6.R6_TURNO AND "
	cQuery += "SP8.P8_DATA >= '" + Dtos(mv_par01) + "' AND SP8.P8_DATA <= '" + Dtos(mv_par02) + "' AND SP8.P8_MAT >= '" + mv_par03 + "' AND SP8.P8_MAT <= '" + mv_par04 + "' AND "
	cQuery += "SP8.P8_FILIAL = '" + xFilial( "SP8" ) + "' AND SP8.D_E_L_E_T_ = ' ' AND "
	cQuery += "SRA.RA_FILIAL = '" + xFilial( "SRA" ) + "' AND SRA.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SRA.RA_NOME, SP8.P8_DATA"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SP8X"
	TCSetField( 'SP8X', "P8_DATA", "D" )
	TCSetField( 'SP8X', "P8_HORA", "N" , 2, 2 )
	TCSetField( 'SP8X', "R6_DESC", "C" )


	//MemoWrit( "CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

	/*
	----------------------------------------------------------------
	  LAYOUT DA IMPRESSAO DO RELATORIO
	----------------------------------------------------------------
	*/
	cCabec_01 := "Matricula  Nome                               Data          Descricao              -1a-             -2a-             -3a-         Observações"
	cCabec_02 := "           do Funcionario                                                     Entrada  Saida   Entrada  Saida   Entrada  Saida"
	//           "999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99   XXXXXXXXXXXXXXXXXXXX   99:99hs 99:99hs  99:99hs 99:99hs  99:99hs 99:99hs   XXXXXXXXXXXXXXXXXXXXXXXXX
	//            01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	//            0         1         2         3         4         5         6         7         8         9        10        11        12        13         14       15

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DADOS IMPRESSOS NO RELATORIO    					         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SP8X->( DBGoTop() )
	nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
	@ Prow() + 1,000 PSay cCabec_01
	@ Prow() + 1,000 PSay cCabec_02
	@ Prow() + 1,000 pSay Repl( '*', 132 )

	While ! SP8X-> ( EOF() )
		//cCod := SP8X->P8_MAT
		//If cCod == SP8X->P8_MAT
			@ Prow() + 1,000 PSay SP8X->P8_MAT
		   @ Prow()    ,011 PSay SP8X->RA_NOME
		   @ Prow()		,044 PSay SP8X->P8_DATA
			@ Prow()		,053 PSay SP8X->R6_DESC
			cData := SP8X->P8_DATA
		   	If cData == SP8X->P8_DATA
		   		cOrdem := 1
		   		cMat := SP8X->P8_MAT
		   		While cData == SP8X->P8_DATA .AND. cMat == SP8X->P8_MAT
		   			If cOrdem == 1
		   				/*cTmp := Round(SP8X->P8_HORA,2)
		   				//cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				cTam := Len(Str(cTmp))*/
		   				@ Prow()    ,077 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				//@ Prow()    ,115 PSay "________"
		   				/*If cTam == 1
		   					//@ Prow()    ,055 PSay '0' + Alltrim(Str(Round(SP8X->P8_HORA,0))) + ':' + '00hs'
		   					@ Prow()    ,055 PSay Alltrim(Str(Round'(SP8X->P8_HORA,0))) + 'hs'
		   				ElseIf cTam == 2
		   					//@ Prow()    ,055 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   					@ Prow()    ,055 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				ElseIf cTam == 4
		   					//@ Prow()	,055 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   					@ Prow()	,055 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				ElseIf cTam == 5
		   					//@ Prow()	,055 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   					@ Prow()	,055 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				EndIf*/
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 2
		   				@ Prow()    ,063 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				//@ Prow()    ,106 PSay '__________________________'
		   				//cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,063 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,063 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,063 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,063 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf*/
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 3
		   				@ Prow()    ,072 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   			   	//@ Prow()    ,106 PSay '__________________________'
		   				/*cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,072 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,072 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,072 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,072 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf*/
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 4
		   				@ Prow()    ,080 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				//@ Prow()    ,106 PSay '__________________________'
		   				/*cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,080 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,080 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,080 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,080 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf*/
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 5
		   				@ Prow()    ,089 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				//@ Prow()    ,106 PSay '__________________________'
		   				/*cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,089 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,089 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,089 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,089 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf*/
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 6
		   				@ Prow()    ,097 PSay Alltrim(Str(SP8X->P8_HORA)) + 'hs'
		   				//@ Prow()    ,106 PSay '__________________________'
		   				/*cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,097 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,097 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,097 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,097 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf*/
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem > 6
		   				sMsg := "Ponto batido mais q 6 vezes"
		   				@ Prow()    ,106 PSay sMsg
		   				SP8X->( dbskip() )
		   			EndIf
		   		EndDo
		   	EndIf
/*		Else
			cData := SP8X->P8_DATA
		   	@ Prow()	,044 PSay SP8X->P8_DATA
	   		If cData == SP8X->P8_DATA
		   		cOrdem := 1
		   		While cData == SP8X->P8_DATA
		   			If cOrdem == 1
		   				cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,055 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,055 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,055 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,055 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 2
		   				cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,063 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,063 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,063 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,063 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 3
		   				cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,072 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,072 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,072 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,072 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 4
		   				cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,080 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,080 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,080 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,080 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 5
		   				cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,089 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,089 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,089 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,089 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem == 6
		   				cTam := Len(Alltrim(Str(Round(SP8X->P8_HORA,0))))
		   				If cTam == 1
		   					@ Prow()    ,097 PSay '0' + Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 2
		   					@ Prow()    ,097 PSay Alltrim(Str(SP8X->P8_HORA)) + ':' + '00hs'
		   				ElseIf cTam == 4
		   					@ Prow()	,097 PSay '0' + Substr(Alltrim(Str(SP8X->P8_HORA)),1,1) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				ElseIf cTam == 5
		   					@ Prow()	,097 PSay Substr(Alltrim(Str(SP8X->P8_HORA)),1,2) + ':' + Substr(Alltrim(Str(SP8X->P8_HORA)),4,2) + 'hs'
		   				EndIf
		   				cOrdem ++
		   				SP8X->( dbskip() )
		   			ElseIf cOrdem > 6
		   				sMsg := "Ponto batido mais que 6 vezes."
		   				@ Prow()    ,106 PSay sMsg
		   				SP8X->( dbskip() )
		   			EndIf
		   		EndDo
		   	EndIf */
		//EndIf

		If Prow() > 58
			nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
			@ Prow() + 1,000 PSay cCabec_01
			@ Prow() + 1,000 PSay cCabec_02
			@ Prow() + 1,000 pSay Repl( '*', 132 )
		endIf

	EndDo

	If aReturn[5] == 1
	   Set Printer To
	   Commit
	   ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

	SP8X->( DbCloseArea() )
	MS_FLUSH()

Return Nil