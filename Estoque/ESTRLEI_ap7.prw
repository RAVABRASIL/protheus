#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTRLE()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//SetPrvt("CVALEXT,AFIELDS,CPATH,")
	SetPrvt( "" )

	#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
	#ENDIF

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ESTRLE  º Autor ³ ESMERINO NETO       º Data ³  28/11/05   º ±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Relatório para idendificação dos produtos que ainda nao    º±±
	±±º          ³ passaram no leitor de codigo de barra                      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ CUSTO/ESTOQUE                                              º±±
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
	//³ mv_par03        	// Do Produto                            ³
	//³ mv_par04        	// Ate Produto                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	tamanho   := "M"
	titulo    := PADC("Relatorio de Produtos nao Lidos no Estoque" ,74)
	cDesc1    := PADC("Este relatório dará a relação de produtos que",74)
	cDesc2    := PADC(" ainda não passaram pelo leitor óptico.", 74)
	cDesc3    := PADC(" ",74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  := "ESTRLE"
	cPerg     := "ESTRLE"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
	wnrel     := "ESTRLE"
	M_PAG     := 1


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( cPerg, .T. )               // Pergunta no SX1

	cString := "Z00"

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

	/*cQuery := "SELECT Z00.Z00_SEQ, Z00.Z00_OP, (SUBSTRING(Z00.Z00_OP,1,6) + Z00.Z00_SEQ) AS COD_BARRA, Z00.Z00_MAQ, SC2.C2_PRODUTO, Z00_DATA, Z00_HORA, Z00_QUANT, SB2.B2_QATU, Z00_USUAR "
	cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00," + RetSqlName( "SC2" ) + " SC2," + RetSqlName( "SB2" ) + " SB2 "
	cQuery += "WHERE SUBSTRING(Z00.Z00_OP,1,6) = SC2.C2_NUM AND SUBSTRING(Z00.Z00_OP,7,2) = SC2.C2_ITEM AND SUBSTRING(Z00.Z00_OP,9,3) = SC2.C2_SEQUEN "
	cQuery += "AND Z00.Z00_DATA >= '" + Dtos(mv_par01) + "' AND Z00.Z00_DATA <= '" + Dtos(mv_par02) + "' AND SC2.C2_PRODUTO >= '" + mv_par03 + "' AND SC2.C2_PRODUTO <= '" + mv_par04 + "' "
	cQuery += "AND Z00.Z00_BAIXA <> 'S' AND Z00_QUANT > 0 AND SC2.C2_PRODUTO = SB2.B2_COD "
	cQuery += "AND SB2.B2_FILIAL = '" + xFilial( "SB2" ) + "' AND SB2.D_E_L_E_T_ = ' ' "
	cQuery += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery += "AND SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY Z00.Z00_DATA" */

	cQuery := "SELECT Z00.Z00_SEQ, Z00.Z00_OP, (SUBSTRING(Z00.Z00_OP,1,6) + Z00.Z00_SEQ) AS COD_BARRA, Z00.Z00_MAQ, SC2.C2_PRODUTO, "
  	cQuery += "Z00.Z00_DATA, Z00.Z00_HORA, Z00.Z00_QUANT, SB2.B2_QATU, "

	If mv_par05 == 1
  	cQuery += "case "
  	cQuery += "when EXISTS(select SD3.D3_ESTORNO from " + RetSqlName("SD3") + " SD3 "
		cQuery += "where  SD3.D3_CODBAR = Z00.Z00_CODBAR "
		cQuery += "AND SD3.D3_ESTORNO = 'S' AND SD3.D3_FILIAL  = '" + xFilial("SD3") + "' AND SD3.D_E_L_E_T_ = ' ') "
  	cQuery += "THEN 'ESTORNO' "
  	cQuery += "ELSE Z00.Z00_USUAR "
  	cQuery += "END AS situacao "
	Else
		cQuery += "Z00.Z00_USUAR AS situacao "
	EndIf

  	cQuery += "FROM   " + RetSqlName("Z00") + " Z00, " + RetSqlName("SC2") + " SC2, " + RetSqlName("SB2") + " SB2 "
  	cQuery += "WHERE  SUBSTRING(Z00.Z00_OP,1,6) = SC2.C2_NUM AND SUBSTRING(Z00.Z00_OP,7,2) = SC2.C2_ITEM AND SUBSTRING(Z00.Z00_OP,9,3) = SC2.C2_SEQUEN "
  	cQuery += "AND Z00.Z00_DATA >= '" + Dtos(mv_par01) + "' AND Z00.Z00_DATA <= '" + Dtos(mv_par02) + "' "
   	cQuery += "AND SC2.C2_PRODUTO >= '"+alltrim(mv_par03)+"' AND SC2.C2_PRODUTO <= '"+alltrim(mv_par04)+"' "
	cQuery += "AND Z00.Z00_BAIXA <> 'S' AND Z00_QUANT > 0 AND SC2.C2_PRODUTO = SB2.B2_COD "

	If mv_par05 != 1
		cQuery += "AND NOT EXISTS(select SD3.D3_ESTORNO from  " + RetSqlName("SD3") + " SD3 "
  		cQuery += "where  SD3.D3_CODBAR = Z00.Z00_CODBAR AND SD3.D3_ESTORNO = 'S' "
		cQuery += "AND SD3.D3_ESTORNO = 'S' AND SD3.D3_FILIAL  = '" + xFilial("SD3") + "' AND SD3.D_E_L_E_T_ = ' ') "
	EndIf

	cQuery += "AND SB2.B2_FILIAL  = '" + xFilial("SB2") + "' AND SB2.D_E_L_E_T_ = ' ' "
	cQuery += "AND Z00.Z00_FILIAL = '" + xFilial("Z00") + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery += "AND SC2.C2_FILIAL  = '" + xFilial("SC2") + "' AND SC2.D_E_L_E_T_ = ' ' "
  	cQuery += "ORDER BY Z00.Z00_DATA"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SZ0X"

	TCSetField( 'SZ0X', "Z00_DATA", "D" )
	TCSetField( 'SZ0X', "Z00_HORA", "H" )
	TCSetField( 'SZ0X', "Z00_QUANT", "C" )
	TCSetField( 'SZ0X', "Z00_SEQ", "C" )
	TCSetField( 'SZ0X', "Z00_OP", "C" )
	TCSetField( 'SZ0X', "C2_QUANT", "N", 8, 2 )
  TCSetField( 'SZ0X', "B2_QATU", "N", 5, 2 )

	SZ0X->( DbGoTop() )
	count to nREGTOT while ! SZ0X->( EoF() )
	SetRegua( nREGTOT )
	SZ0X->( DBGoTop() )

	//Para solucionar sequencias repeditas no relatorio atentar para os protudos cadastrados na tabela SB2010 (SALDO FISICO E FINANCEIRO)

	//MemoWrit( "CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

	/*
	----------------------------------------------------------------
	  LAYOUT DA IMPRESSAO DO RELATORIO
	----------------------------------------------------------------
	*/
	cCabec_01 := "Sequênc.   Numero da       Código     Máq.  Código do  Data da    Hora     Quant.    Quant. no     Nome do"
	cCabec_02 := "do Prod.      O.P.        de Barra           Produto   Pesagem   Pesada    Pesada    Estoque (ML)  Liberador"
	//           "99999999  999999999999  999999999999  XXX   XXXXXXXXX  99/99/99  99:99hs  99.999,99   999.999,99   XXXXXXXXXXXX
	//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//            0         1         2         3         4         5         6         7         8         9        10        11        12

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DADOS IMPRESSOS NO RELATORIO    					         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
	@ Prow() + 1,000 PSay cCabec_01
	@ Prow() + 1,000 PSay cCabec_02
	@ Prow() + 1,000 pSay Repl( '*', 120 )

	While ! SZ0X-> ( EOF() )

		@ Prow() + 1,000 PSay Alltrim(SZ0X->Z00_SEQ)
		@ Prow()    ,010 PSay Alltrim(SZ0X->Z00_OP)
		@ Prow()	,024 PSay Alltrim(SZ0X->COD_BARRA)
		@ Prow()    ,038 PSay Alltrim(SZ0X->Z00_MAQ)
		@ Prow()    ,044 PSay Alltrim(SZ0X->C2_PRODUTO)
		@ Prow()    ,055 PSay Dtoc(SZ0X->Z00_DATA)
		@ Prow()    ,065 PSay SZ0X->Z00_HORA
		@ Prow()    ,074 PSay Round(SZ0X->Z00_QUANT,2)
		@ Prow()    ,086 PSay Round(SZ0X->B2_QATU,2)
		@ Prow()    ,099 PSay SZ0X->situacao

		If Prow() > 58
			nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
			@ Prow() + 1,000 PSay cCabec_01
			@ Prow() + 1,000 PSay cCabec_02
			@ Prow() + 1,000 pSay Repl( '*', 120 )
		endIf

		SZ0X->( dbskip() )
		IncRegua()

	EndDo

	If aReturn[5] == 1
	   Set Printer To
	   Commit
	   ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

	SZ0X->( DbCloseArea() )
	MS_FLUSH()

Return Nil
