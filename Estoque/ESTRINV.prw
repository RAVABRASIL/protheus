#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTRINV()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Declaracao de variaveis utilizadas no programa atraves da funcao    Ё
	//Ё SetPrvt, que criara somente as variaveis definidas pelo usuario,    Ё
	//Ё identificando as variaveis publicas do sistema utilizadas no codigo Ё
	//Ё Incluido pelo assistente de conversao do AP5 IDE                    Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	//SetPrvt("CVALEXT,AFIELDS,CPATH,")
	//SetPrvt( "cTam, sMsg, cOrdem, cCod, cString, nLin, cTurno, cEntSai" )

	/*/
	эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
	╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
	╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
	╠╠╨Programa  Ё ESTRINV   ╨ Autor Ё Emmanuel Lacerda  ╨ Data Ё  19/05/06   ╨╠╠
	╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
	╠╠╨Descricao Ё Relatorios para produtos inventariados                     ╨╠╠
	╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
	╠╠╨Uso       Ё Modulo Estoque                                             ╨╠╠
	╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
	╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
	ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
	/*/

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Define Variaveis Ambientais                                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis utilizadas para parametros                         Ё
	//Ё mv_par01        	// Prod. Ativos, Inativos ou Todos          Ё
	//Ё mv_par02        	// Prod. PA's ou Todos                      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	tamanho   := "M"
	titulo    := PADC("Relatorio de produtos INVENTARIADOS", 74)
	cDesc1    := PADC("Relatorio de produtos INVENTARIADOS", 74)
	cDesc2    := PADC("", 74)
	cDesc3    := PADC("", 74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  := "ESTRINV"
	cPerg     := "ESTRIN"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
	wnrel     := "ESTRINV"
	M_PAG     := 1


	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica as perguntas selecionadas, busca o padrao da Nfiscal           Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	Pergunte( cPerg, .F. )               // Pergunta no SX1
	cString := "SB1" //Z00

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Envia controle para a funcao SETPRINT                        Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

	If nLastKey == 27
	   Return
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica Posicao do Formulario na Impressora                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	SetDefault( aReturn, cString )

	If nLastKey == 27
	   Return
	Endif


	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Inicio do Processamento do Relatorio                         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	#IFDEF WINDOWS
	   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
	   Return
		// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
		Static Function RptDetail()
	#ENDIF


	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё DESENVOLVIMENTO DO PROGRAMA         								 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


	DO CASE

		CASE mv_par01 == 1
			cOpcao := "N"

		CASE mv_par01 == 2
			cOpcao := "S"

		OTHERWISE
			cOpcao := " "

	END CASE

	DO CASE

		CASE mv_par02 == 1
			cOpcao_2 := "PA"
			cNegacao := " "

		CASE mv_par02 == 2
			cOpcao_2 := " "
			cNegacao := "NOT"

		OTHERWISE

	END CASE


	cQuery := "select	B1_COD, B1_DESC "
	cQuery += "from " + RetSqlName( "SB1" ) + " "
	cQuery += "where  B1_TIPO " + cNegacao + " in  ('" + cOpcao_2 + "') "
	cQuery += "and B1_ATIVO != '" + cOpcao + "' "
	cQuery += "and len( B1_COD ) < = 7 "
	cQuery += "and B1_COD not IN ('188','189') "
	cQuery += "and B1_FILIAL  = '" + xFilial( "SB1" ) + "' and D_E_L_E_T_ = ' '  "
	cQuery += "order by B1_COD"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SBBX"
	TCSetField( 'SBBX', "B1_COD", "C" )
  TCSetField( 'SBBX', "B1_DESC", "C" )


	//MemoWrit( "CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

	/*
	----------------------------------------------------------------
	  LAYOUT DA IMPRESSAO DO RELATORIO
	----------------------------------------------------------------
	*/
	cCabec_01 := "Codigo  |              Descricao                            |    Quantidade      |   Quantidade de    |   Quantidade de"
	cCabec_02 := "Produto |              do Produto                           |    de Fardos       | Pacotes por Fardos | Sacos por Pacotes"
	//	          xxxxxxx | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx | xxxxxxx | xxxxxxx | xxxxxxx
	//           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//           0         1         2         3         4         5         6         7         8         9        10        11        12        13
	cSeparadores := "|____________________|____________________|____________________|"

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё DADOS IMPRESSOS NO RELATORIO    					         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	SBBX->( DBGoTop() )
	nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1
	@ Prow() + 1,000 PSay cCabec_01
	@ Prow() + 1,000 PSay cCabec_02
	@ Prow() + 1,000 PSay Repl( '-', 124 )
	lSombra := .T.
	nCount := 0
	While !SBBX-> ( EOF() )

		IF lSombra
			@ Prow() + 1,000 PSay AllTrim(SBBX->B1_COD)
			@ Prow()    ,010 PSay SBBX->B1_DESC + cSeparadores
			@ Prow()    ,000 PSay AllTrim(SBBX->B1_COD)
			@ Prow()    ,010 PSay SBBX->B1_DESC + cSeparadores
		   //nCount ++ //contador de n. de registros, apenas para teste!
			lSombra := .F.

		Else
			@ Prow() + 1,000 PSay AllTrim(SBBX->B1_COD)
			@ Prow()    ,010 PSay SBBX->B1_DESC +  cSeparadores
			lSombra := .T.
		  	//nCount ++ //contador de n. de registros, apenas para teste!

		ENDIF

		If Prow() > 58
			nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1
			@ Prow() + 1,000 PSay cCabec_01
			@ Prow() + 1,000 PSay cCabec_02
		  	@ Prow() + 1,000 PSay Repl( '-', 124 )
			lSombra := .T.
		endIf

	SBBX->( dbskip() )

EndDo
		  //	@ Prow() + 2,000 PSay str(nCount) + " produtos cadastrados."


	If aReturn[5] == 1
	   Set Printer To
	   Commit
	   ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

	SBBX->( DbCloseArea() )
	MS_FLUSH()

Return Nil
