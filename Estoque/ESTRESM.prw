#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTRESM()

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
  //³ mv_par04          // Ate a data                              ³
  //³ mv_par05      // Detalhamento de exibicao                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	tamanho   := "M"
  titulo    := PADC("Relatorio de Media de Estoque", 74)
  cDesc1    := PADC("Relatorio de Media de Estoque", 74)
	cDesc2    := PADC("", 74)
	cDesc3    := PADC("", 74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
  nomeprog  := "ESTRESM"
  cPerg     := "ESTRES"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
  wnrel     := "ESTRESM"
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
	//³ DESENVOLVIMENTO DO PROGRAMA         								 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


   cQuery := "select B1_DESC, B1_COD, B1_PESOR, B1_CONV, B1_TIPCONV from " + RetSqlName("SB1") + " where B1_ATIVO = 'S' and B1_TIPO = 'PA' "
   cQuery += "and B1_COD >= '" + alltrim(mv_par01) + "' and B1_COD <= '" + alltrim(mv_par02) + "' "
   cQuery += "and B1_FILIAL  = '" + xFilial( "SB1" ) + "' and D_E_L_E_T_ = ' '  "
   cQuery += "and len( B1_COD ) < = 7  "
   
   cQuery += "and B1_SETOR!='39'  " // Diferente Caixa 
   
   cQuery += "order by B1_COD "
   cQuery := ChangeQuery( cQuery )
   TCQUERY cQuery NEW ALIAS "SBBX"

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

   SBBX->( dbgotop() )

   while ! SBBX-> ( EOF() )

     nSoma  := 0
     dDataI := mv_par03
     dDataF := mv_par04
     nDif   := (mv_par04 - mv_par03) + 1

      while dDataI <= dDataF
           /*nao precisa desse*/
        /*IF (dDatai == dDataf) .AND. ( month(dDatai) < month(dDatai + 1) )
          aEstoque := CalcEst(SBBX->B1_COD, '01', dDataI )
          nSoma  += aEstoque[1]
          dDataI++
        ELSE*/                 
          aEstoque := CalcEst(SBBX->B1_COD, '01', dDataI + 1 )
          IF aEstoque != Nil
             nSoma  += aEstoque[1] + CalcEst(SBBX->B1_COD, '02', dDataI + 1 )[1]
//            if SBBX->B1_TIPCONV == "D"
//               nSoma := nSoma / SBBX->B1_CONV
//            elseif SBBX->B1_TIPCONV == "M"
//               nSoma := nSoma * SBBX->B1_CONV            
//            endif
            
            //nSoma  += aEstoque[1]
            dDataI++
          ELSE
            dDataI++                             
          ENDIF
      EndDo

      Aadd(aMedias, {SBBX->B1_COD, SBBX->B1_DESC, (SBBX->B1_PESOR * nSoma),;
                    (SBBX->B1_PESOR * nSoma)/nDif, nSoma/nDif} )
      nTotal  += (SBBX->B1_PESOR * nSoma) //EM KG
      nTotMIL += nSoma  //EM ML
      SBBX->( dbskip() )

   EndDo


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
   MS_FLUSH()

Return Nil