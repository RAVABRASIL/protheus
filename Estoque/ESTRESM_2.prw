#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTRESM2()

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
  ±±ºPrograma  ³ ESTRESM   º Autor ³ Emmanuel Lacerda  º Data ³  19/06/06   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
  ±±ºDescricao ³ Relatorios para estoque de produtos                        º±±
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
  //³ mv_par01          // De produto                              ³
  //³ mv_par02          // Ate Produto                             ³
  //³ mv_par03          // Da data                                 ³
  //³ mv_par04          // Ate a data 								³
  //³ mv_par05			// Detalhamento de exibicao					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	tamanho   := "M"
  titulo    := PADC("Relatorio de Media de Estoque", 74)
  cDesc1    := PADC("Relatorio de Media de Estoque", 74)
	cDesc2    := PADC("", 74)
	cDesc3    := PADC("", 74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
  nomeprog  := "ESTRESM_2"
  cPerg     := "ESTRES"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
  wnrel     := "ESTRESM_2"
	M_PAG     := 1


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  Pergunte( cPerg, .F. )
  cString := "SB1"

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
  //³ DESENVOLVIMENTO DO PROGRAMA                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   cQuery2 := "select SD2.D2_QUANT, SD2.D2_EMISSAO, SD2.D2_CF "
   cQuery2 += "from " + RetSqlName("SD2") + " SD2, "+ RetSqlName("SB1") + " SB1 "
   cQuery2 += "where  SD2.D2_EMISSAO >= '" + dtos(mv_par03) + "' and SD2.D2_EMISSAO <= '" + dtos(mv_par04) + "' "
   cQuery2 += "and SD2.D2_COD = '" + alltrim(mv_par01) + "' and SD2.D2_COD = SB1.B1_COD "
   cQuery2 += "and SB1.B1_ATIVO   = 'S' and len(SB1.B1_COD) <= 7 and SB1.B1_TIPO  = 'PA'  "
   cQuery2 += "and SB1.B1_FILIAL  = '" + xFilial( "SB1" ) + "' and SB1.D_E_L_E_T_ = ' ' "
   cQuery2 += "and SD2.D2_FILIAL  = '" + xFilial( "SD2" ) + "' and SD2.D_E_L_E_T_ = ' ' "
   cQuery2 += "order by SD2.D2_EMISSAO"
   cQuery2 := ChangeQuery( cQuery2 )
   TCQUERY cQuery2 NEW ALIAS "SBBY"
   SBBY->( DbGoTop() )

   cQuery := "select SB9.B9_QINI, SD3.D3_COD, SD3.D3_EMISSAO, SD3.D3_CF, SD3.D3_QUANT, SB1.B1_PESOR, SB1.B1_DESC "
   cQuery += "from  "+ RetSqlName("SD3") +" SD3, "+ RetSqlName("SB9") +" SB9, " + RetSqlName("SB1") + " SB1, "
   cQuery += "where SD3.D3_EMISSAO >= '" + dtos(mv_par03) + "' and  SD3.D3_EMISSAO <= '" + dtos(mv_par04) + "' "
   cQuery += "and SD3.D3_COD = '" + alltrim(mv_par01) + "' and SB1.B1_COD = SB9.B9_COD "
   cQuery += "and SB9.B9_COD = SD3.D3_COD and SB9.B9_DATA = '" + dtos( mv_par03 - day(mv_par03) ) + "' "
   cQUery += "and SB1.B1_TIPO = 'PA' and len(SB1.B1_COD) <= 7 and SB1.B1_ATIVO = 'S'  "
   cQuery += "and SD3.D3_FILIAL  = '" + xFilial( "SD3" ) + "' and SD3.D_E_L_E_T_ = ' '  "
   cQuery += "and SB9.B9_FILIAL  = '" + xFilial( "SB9" ) + "' and SB9.D_E_L_E_T_ = ' '  "
   cQuery += "and SB1.B1_FILIAL  = '" + xFilial( "SB1" ) + "' and SB1.D_E_L_E_T_ = ' '  "
   cQuery += "order by SD3.D3_EMISSAO"
   cQuery := ChangeQuery( cQuery )
   TCQUERY cQuery NEW ALIAS "SBBX"
   SBBX->( DbGoTop() )

	//MemoWrit( "CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

	/*
	----------------------------------------------------------------
	  LAYOUT DA IMPRESSAO DO RELATORIO
	----------------------------------------------------------------
	*/
   cCabec_01 := "PRODUTO  |                       DESCRICAO                       |  TOT. SALDO(KG)|  MEDIA(Kg)|  MEDIA(Ml)|"
    //           xxxxxxx  |  xxxxxxx                                              |                |   XXXXX   |   XXXXX
	//           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//           0         1         2         3         4         5         6         7         8         9        10        11        12        13

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DADOS IMPRESSOS NO RELATORIO    					         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   aEstoque := {}
   aMedias  := {}
   nTotal   := 0
   nTotMIL  := 0
   dDataI :=  stod(alltrim( substring(dtos(mv_par03),1,6) + '01' ))
   dDataF := mv_par04
   nDif   := (mv_par04 - mv_par03) + 1

   while ! SBBX-> ( EOF() )

     cProduto := SBBX->D3_COD
     cDesc    := SBBX->B1_DESC
     nPesor   := SBBX->B1_PESOR
     nSoma    := 0

     while SBBX->D3_COD == cProduto

      IF stod(SBBX->D3_EMISSAO) > dDataI
        IF day(dDataI) == 1
          nAux := nSoma := SBBX->B9_QINI
        ELSE
          nSoma += nAux
        ENDIF
        dDatai++
      Else
        DO CASE
          CASE (SBBX->D3_CF == 'PR0') .OR. (SBBX->D3_CF == 'DE0')
            nAux := nSoma += SBBX->D3_QUANT
          CASE SBBX->D3_CF == 'RE0'
            nAux := nSoma -= SBBX->D3_QUANT
        EndCase

        IF SBBX->D3_EMISSAO == SBBY->D2_EMISSAO
          dAux2 := stod(SBBY->D2_EMISSAO)
          while dAux2 = stod(SBBY->D2_EMISSAO)

            if SBBY->D2_CF $ "511  /5101 /611  /6101 /512 /5102 /612  /6102 /6109 /6107 /5949 /6949 /6910" //6910
              nAux := nSoma -= SBBY->D2_QUANT
            endif
            SBBY->( DbSkip() )

          enddo//fim do while logo acima
        ENDIF

        dAux := stod(SBBX->D3_EMISSAO)
        SBBX->( dbskip() )
        IF dAux < stod(SBBX->D3_EMISSAO)
          dDatai++
        ENDIF
      ENDIF

     EndDo //fim do while dos produtos iguais, segundo while

     IF dDataI < dDataF
     ENDIF

     Aadd(aMedias, {cProduto, cDesc, (nPesor * nSoma),;
                   (nPesor * nSoma)/nDif, nSoma/nDif} )
     nTotal  += (nPesor * nSoma) //EM KG
     nTotMIL += nSoma  //EM ML

   EndDo //fim do 1º while, controle de fim do arquivo


   if(mv_par05 == 1)

     Cabec( titulo, "", "", nomeprog, tamanho, 15 )
     @ PRow() + 1, 000 PSay cCabec_01
     @ PRow()    , 107 PSay mv_par03
     @ PRow()    , 116 PSay mv_par04
     @ PRow() + 1, 000 PSay Repl('-', 124)

     FOR X := 1 TO Len(aMedias)
       If PRow() > 58
         Cabec( titulo, "", "", nomeprog, tamanho, 15 )
         @ Prow() + 1, 000 PSay cCabec_01
         @ PRow()    , 107 PSay mv_par03
         @ PRow()    , 116 PSay mv_par04
         @ Prow() + 1, 000 PSay Repl( '-', 124 )
       endIf

       @ Prow() + 1,000 PSay AllTrim(aMedias[X,1])
       @ Prow()    ,011 PSay AllTrim(aMedias[X,2])
       @ Prow()    ,071 PSay transform(aMedias[X,3], "@E 999,999.99")
       @ Prow()    ,084 PSay transform(aMedias[X,4], "@E 999,999.99")
       @ Prow()    ,094 PSay transform(aMedias[X,5], "@E 999,999.99")
     NEXT

       @ Prow() + 4,000 PSay "MEDIA TOTAL NO INTERVALO DE " +alltrim(str(nDif))+ " DIAS :"
       @ Prow() + 1,000 PSay Repl( '-', 113 )
       @ Prow() + 1,082 PSay transform(nTotal/nDif, "@E 999,999.99") + " Kgs |" + transform(nTotMIL/nDif, "@E 999,999.99")+" Mls"

   elseif(mv_par05 == 2)
     Cabec( titulo, "", "", nomeprog, tamanho, 15 )
     @ Prow() + 1,000 PSay "MEDIA TOTAL NO INTERVALO DE " +alltrim(str(nDif))+ " DIAS :"
     @ PRow()    ,065 PSay mv_par03
     @ PRow()    ,075 PSay mv_par04
     @ Prow() + 1,000 PSay Repl( '-', 083 )
     @ Prow() + 1,069 PSay transform(nTotal/nDif, "@E 999,999.99")+" Kgs"
   endif

	If aReturn[5] == 1
	   Set Printer To
	   Commit
	   ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

   SBBX->( DbCloseArea() )
   SBBY->( DbCloseArea() )
   MS_FLUSH()

Return Nil

