#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTRPRO()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//SetPrvt("CVALEXT,AFIELDS,CPATH,")
	//SetPrvt( "cTam, sMsg, cOrdem, cCod, cString, nLin, cTurno, cEntSai" )

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ ESTRPRO   º Autor ³ Esmerino Neto     º Data ³  03/06/06   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Relacao de produtos para consulta                          º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Modulo Estoque                                             º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Ambientais                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01        	// Produto de ?	                         ³
	//³ mv_par02        	// Produtos ate ?                        ³
	//³ mv_par03        	// Tipo do Produto de ?                  ³
	//³ mv_par04        	// Tipo do Produto ate ?                 ³
	//³ mv_par05        	// Lista Ativos Sim, Nao, Todos ?        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	tamanho   := "M"
	titulo    := PADC("Relatorio de Produtos ATIVOS para Consulta", 74)
	cDesc1    := PADC("Relatorio de Produtos para Consulta", 74)
	cDesc2    := PADC("", 74)
	cDesc3    := PADC("", 74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  := "ESTRPRO"
	cPerg     := "ESTRPR"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
	wnrel     := "ESTRPRO"
	M_PAG     := 1


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( cPerg, .T. )               // Pergunta no SX1
	cString := "SB1" //Z00

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
	//³ DESENVOLVIMENTO DO PROGRAMA         								 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	cQuery := "SELECT SB1.B1_COD, SB1.B1_DESC "
	cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1 "
	//cQuery += "WHERE SB1.B1_TIPO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND SB1.B1_ATIVO = 'S' "
	cQuery += "WHERE SB1.B1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND SB1.B1_TIPO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "

  /*Modifcado a partir daqui 22/08/06*/
  if mv_par06 != " "

    x := 1
    cLista := " "
    while ( x <= len(alltrim(mv_par06)) )
      IF 2 == len(alltrim(mv_par06))
        cLista +=  "'"+ alltrim(substr(alltrim(mv_par06), x, 3)) + "' "
      ELSE
        IF ( x + 3 >= len(alltrim(mv_par06)) ) .AND. ( x != 1 )
          cLista +=  "'"+ alltrim(substr(alltrim(mv_par06), x, 3)) + "' "
        ELSE
          cLista +=  "'"+ alltrim(substr(alltrim(mv_par06), x, 3)) + "', "
        ENDIF
      ENDIF
      x += 3
    EndDo

    cQuery += "and SB1.B1_TIPO not in ( " + cLista + " ) "
  endif
  /*Modifcado até aqui 22/08/06*/

	If mv_par05 == 'S'
	  cQuery += "AND SB1.B1_ATIVO LIKE 'S%' "
	ElseIf mv_par05 == 'N'
	  cQuery += "AND SB1.B1_ATIVO LIKE 'N%' "
	  titulo := PADC("Relatorio de Produtos INATIVOS para Consulta", 74)
    ElseIf mv_par05 == 'T'
      cQuery += "AND SB1.B1_ATIVO NOT LIKE ' ' "
      titulo := PADC("Relatorio de Produtos ATIVOS E INATIVOS para Consulta", 74)
    Else
      Alert('ATENCAO: Preencha o campo TIPO com S (SIM) ou N (NAO) ou T (TODOS) .')
      Return Nil
    EndIf
	cQuery += "AND LEN(SB1.B1_COD) <= 7  "
	cQuery += "AND B1_FILIAL  = '" + xFilial( "SB1" ) + "' AND D_E_L_E_T_ = ' '  "
	cQuery += "ORDER BY B1_DESC "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "PROX"
	TCSetField( 'PROX', "B1_COD", "C" )
	TCSetField( 'PROX', "B1_DESC", "C" )

	PROX->( DBGoTop() )
	aProds := {}
	nCont := 1

	Do While ! PROX->( Eof() )
		aadd( aProds,{ nCont, PROX->B1_COD, PROX->B1_DESC } )
		PROX->( dbskip() )
		nCont ++
	EndDo

	//MemoWrit( "CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

	/*
	----------------------------------------------------------------
	  LAYOUT DA IMPRESSAO DO RELATORIO
	----------------------------------------------------------------
	*/
	cCabec_01 := "Ord |Codigo |              Descricao                            | Ord |Codigo |             Descricao"
	cCabec_02 := "Num |Produto|              do Produto                           | Num |Produto|             do Produto"
	//	          9999 xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx | 9999 xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	//            012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
	//            0         1         2         3         4         5         6         7         8         9        10        11        12        13

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DADOS IMPRESSOS NO RELATORIO    					         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1
	@ Prow() + 1,000 PSay cCabec_01
	@ Prow() + 1,000 PSay cCabec_02
	@ Prow() + 1,000 PSay Repl( '-', 124 )

	ntotreg := Round( Len( aProds ), 0 )

	For Y := 1 To ntotreg

		@ Prow() + 1,000 PSay StrZero( aProds[Y, 1], 4 )
		@ Prow()    ,005 PSay Alltrim( aProds[Y, 2] )
		@ Prow()    ,012 PSay "-"
		@ Prow()    ,013 PSay Alltrim( aProds[Y, 3] )
		@ Prow()    ,064 PSay "|"

		If Y + 53 < ntotreg
			@ Prow()    ,066 PSay StrZero( aProds[Y + 53, 1], 4 )
			@ Prow()    ,071 PSay Alltrim( aProds[Y + 53, 2] )
			@ Prow()    ,078 PSay "-"
			@ Prow()    ,079 PSay aProds[Y + 53, 3]
		EndIf

		If Prow() > 60
			nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1
			@ Prow() + 1,000 PSay cCabec_01
			@ Prow() + 1,000 PSay cCabec_02
	  	@ Prow() + 1,000 PSay Repl( '-', 124 )
			lSombra := .T.
			Y := Y + 53
		EndIf

	Next

	If aReturn[5] == 1
	   Set Printer To
	   Commit
	   ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

	PROX->( DbCloseArea() )
	MS_FLUSH()

Return Nil
