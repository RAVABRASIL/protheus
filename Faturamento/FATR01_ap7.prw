#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"       
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATR01()

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,CNATUREZA")
SetPrvt("ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN")
SetPrvt("WNREL,M_PAG,NTAMNF,CSTRING,TITULO,CABEC1")
SetPrvt("CABEC2,CINDSF2,CCHAVE,CFILTRO,NTOTAL,NTOTFAT")
SetPrvt("NTOTSIPI,NTOTKG,CDOC,CTES,CNOME,APARCELAS")
SetPrvt("NQTDITEM,NQTDKG,DEMISSAO,CSERIE,NVALBRUT,NVALSIPI")
SetPrvt("NFATOR,CSIT,Y,")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01          // De Serie                                     ³
//³ mv_par02          // Ate Serie                                    ³
//³ mv_par03          // De Emissao                                   ³
//³ mv_par04          // Ate a Emissao                                ³
//³ mv_par05          // De Nota                                      ³
//³ mv_par06          // Ate Nota                                     ³
//³ mv_par07          // De Cliente                                   ³
//³ mv_par08          // Ate a Cliente                                ³
//³ mv_par09          // Tipo Relatorio 1-Mapa diario,2-Relacao N.F.  ³
//³ mv_par10          // Separa Notas 1-Sim, 2-Nao                    ³
//³ mv_par11          // Considera DNS 1-Sim, 2-Nao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M"
limite:=254

cDesc1 :=PADC("Este programa ira Emitir relacao de vendas diaria",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""
aReturn := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="FATR01"
cPerg:="FATR01"
nLastKey:= 0
lContinua := .T.
nLin:=9
wnrel    := "FATR01"
M_PAG    := 1
nTamNf := 72

//Pergunte(cPerg,.F.)

cString:="SF2"
//titulo :=PADC("Relacao de Notas Fiscais",74)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("FATR01",.T.)

titulo :=PADC("Relacao de Notas Fiscais - De: " + Dtoc(MV_PAR03) + " Até: " + Dtoc(MV_PAR04),74)
cabec1 :="Emissão De: " + Dtoc(MV_PAR03) + " Até: " + Dtoc(MV_PAR04)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "FATR01"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

titulo :=PADC("Relacao de Notas Fiscais "+iif(MV_PAR14=1,'So Licitacao',''),74)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if mv_par09 == 1
   Tamanho := "G"

// cabec1  := "N.F.      Nome do Cliente                Cidade              Transportadora  Emissao   Valor Total  Valor s/Ipi  Fator  Pz Med.  Quant.Kg     Quant.Un  Telefone                  Contato         Prz.E Vendedor         Exp "
   cabec2  := "NF/Serie     Pedido  Nome do Cliente       Cidade-UF                Transportadora  Emissao   Valor Total  Valor s/Ipi  Fator  Pz Med.  Quant.Kg  Qt.Cx.      Telefone        Contato         Prz.E  Vendedor         Exp"
             //999999999/999 XXXXXX XXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX-XX XXXXXXXXXXXXXXX 00/00/00 9.999.999,99 9.999.999,99 999,99    99    99.999,99 XXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX   9   XXXXXXXXXXXXXXX  XXX
             //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
             //0         1         2         3         4         5         6         7         8         9        10        11        12        13       14        15        16        17         18        19        20        21        22
   //cabec2  := ""
else
   cabec2  := "NF/Serie    Pedido  Nome do Cliente       Emissao   Valor Total  Situacao              Dt.Venct       Valor Dupl.  Exp"
   //cabec2  := ""
endif

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF

SF1->( dbSetorder( 2 ) )
SD1->( dbSetorder( 1 ) )
SD2->( dbSetorder( 3 ) )
//
SB1->( dbsetorder( 1 ) )
//
dbSelectArea( "SF2" )

cIndSf2 := "SF2" + Substr( Time(), 4, 2 ) + Substr( Time(), 7, 2 )
cChave  := "F2_FILIAL + Dtos( F2_EMISSAO ) + F2_DOC"
cFiltro := "F2_EMISSAO >= mv_par03 .and. F2_EMISSAO <= mv_par04"

IndRegua( "SF2", cIndSf2, cChave, , cFiltro, "Selecionando Notas..." )
dbSeek( xFilial( "SF2" ) + Dtos( mv_par03 ) + mv_par05,.t. )
SetRegua( Lastrec() )

nTotal := nTotFat := nTotsIpi := nTotKg :=nTotCx:= nTCx:=nTSaco:=nTCxsI:=nTSacosI:=0
cDoc   := ""

SX6->( dbSeek( xFilial( "SX6" ) + "MV_TESDNA", .T. ) )

cTes := Alltrim( SX6->X6_CONTEUD )

While SF2->( !Eof() ) .And. SF2->F2_FILIAL == xFilial( "SF2" ) .and. lContinua .And. SF2->F2_EMISSAO <= mv_par04

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se o t¡tulo foi aglutinado em uma fatura            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   IF nLin > 58
      nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
   EndIF

   If MV_PAR14=1 // so licitacao -> sim 
	   if fNaoLici(SF2->F2_DOC)
	      SF2->( dbSkip() )
	      IncRegua()
	      Loop   
	   Endif
   Endif

   if EMPTY(SF2->F2_DUPL) 
      SF2->( dbSkip() )
      IncRegua()
      Loop
   endif


   if SF2->F2_SERIE < mv_par01 .or. SF2->F2_SERIE > mv_par02
      SF2->( dbSkip() )
      IncRegua()
      Loop
   endif

   if SF2->F2_DOC < mv_par05 .or. SF2->F2_DOC > mv_par06
      SF2->( dbSkip() )
      IncRegua()
      Loop
   endif

   if mv_par11 == 2 .and. SF2->F2_SERIE == "   "  
      SF2->( dbSkip() )
      IncRegua()
      Loop
   endif

//   if ! SF2->F2_TIPO $ "N"  .and. (SD2->D2_TES # "514" .or. SD2->D2_TES # "515")
   if ! SF2->F2_TIPO $ "N"  
      SF2->( dbSkip() )
      IncRegua()
      Loop
   endif


   if SF2->F2_CLIENTE < mv_par07 .or. SF2->F2_CLIENTE > mv_par08
      SF2->( dbSkip() )
      Loop
      IncRegua()
   endif

   SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )


    If  MV_PAR13=2 // Nao considera a apara
	   	if alltrim(SD2->D2_TP)= 'AP'  
	       while  SF2->F2_DOC == SD2->D2_DOC .and. SF2->( !Eof() )
	          SF2->( dbSkip() )
	          IncRegua()
	       end
	       Loop
		endif
	Endif

	if alltrim(SD2->D2_CLIENTE)= '031732'  // Despreza faturamento entre filias
      while  SF2->F2_DOC == SD2->D2_DOC .and. SF2->( !Eof() )
         SF2->( dbSkip() )
         IncRegua()
      end
      Loop
	Endif
	
         

//   if mv_par09 == 1 .and. ! ALLTRIM(SD2->D2_CF) $ "5101/6101/5102/6102/5109/6109/5107/6107/5949/6949/7501/6108/5108/5922/6922/5116/6116/" .and. (SD2->D2_TES <> "514" .or. SD2->D2_TES <> "515")   //Esmerino Neto em 19/12/06 por Janderley 
//   if mv_par09 == 1 .and. ! ALLTRIM(SD2->D2_CF) $ "5101/5107/5108/6101/5102/6102/6109/6107/6108/5949/6949/5922/6922/5116/6116/6118/6923/"    
     if mv_par09 == 1 .and. ! ALLTRIM(SD2->D2_CF) $ "5101/5107/5108/6101/5102/6102/6109/6107/6108/5118/6118/5949/6949/5922/6922/5116/6116/"  
      while  SF2->F2_DOC == SD2->D2_DOC .and. SF2->( !Eof() )
         SF2->( dbSkip() )
         IncRegua()
      end
      Loop
   endif


   SA1->( dbSeek( xFilial( "SA1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )
   //cNome := Substr( SA1->A1_NOME, 1, 29 )
   cNome := Substr( SA1->A1_NREDUZ, 1, 20 )
   cCid  := alltrim(Substr( SA1->A1_MUN,1,20 )) + "-" + SA1->A1_EST

   SA3->( dbSeek( xFilial( "SA3" ) + SF2->F2_VEND1, .T. ) )
   SA4->( dbSeek( xFilial( "SA4" ) + SF2->F2_TRANSP, .T. ) )

   aParcelas := {}

   if cDoc == SF2->F2_DOC
      nQtdItem := 0
      nQtdKg   := 0
      nQtdCx   := 0
   else
      cDoc := SF2->F2_DOC
      aParcelas:= {}
   endif

   dEmissao := SF2->F2_EMISSAO
   cSerie   := SF2->F2_SERIE
   nValbrut := nValsIpi := 0
   nFator   := nQtdKg   := nQtdItem := nQtdCx :=0
   nPRZMD   := U_GetPrzM()
   nSTCx:=nSTSac:=0
   nSTCxsI:=nSTSacsI:=0
   nPeso:=0
   while SF2->F2_DOC == cDoc .and. SF2->( !Eof() )
      SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
      cExp := SD2->D2_LOCAL      
     
//      nValbrut := nValbrut + IIf( SD2->D2_TES $ "514/515", 0, SF2->F2_VALBRUT )
//      nValsIpi := nValsIpi + IIf( SD2->D2_TES $ "514/515", 0, SF2->F2_VALBRUT - SF2->F2_VALIPI )

        nValbrut := nValbrut +  SF2->F2_VALBRUT 
        nValsIpi := nValsIpi + SF2->F2_VALBRUT - SF2->F2_VALIPI 
     
      SC5->( dbSeek( xFilial( "SC5" ) + SD2->D2_PEDIDO, .T. ) )
      cPedido := ""
      //If MV_PAR12 == 1
        Do while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )
           SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) ) 
	       If SB1->B1_SETOR=='39' //CAIXA 
              If MV_PAR12==1 
                 nQtdCx+=(SD2->D2_QUANT-SD2->D2_QTDEDEV) //SD2->D2_QUANT 
	          Else
	             nQtdCx   := nQtdCx + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, (SD2->D2_QUANT-SD2->D2_QTDEDEV) /*SD2->D2_QUANT*/ )  
	          EndIf
//	          nSTCx+=IIF(SD2->D2_TES $ "514/515", 0,SD2->D2_TOTAL+SD2->D2_VALIPI)
//	          nSTCxsI+=IIF(SD2->D2_TES $ "514/515", 0,SD2->D2_TOTAL)

	          nSTCx+=SD2->D2_TOTAL+SD2->D2_VALIPI
	          nSTCxsI+=SD2->D2_TOTAL

	       Else
              If MV_PAR12==1 
                 nQtdKg:= nQtdKg + IIf( SD2->D2_UM == "KG", (SD2->D2_QUANT-SD2->D2_QTDEDEV) /*SD2->D2_QUANT*/, Round( ( /*SD2->D2_QUANT*/ (SD2->D2_QUANT-SD2->D2_QTDEDEV)* SB1->B1_PESOR  ), 2 ) )
              Else
                 nQtdKg   := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, Round( ( /*SD2->D2_QUANT*/(SD2->D2_QUANT-SD2->D2_QTDEDEV)* SD2->D2_PESO  ), 2 ) )  //Esmerino Neto 19/12/06       
              Endif      	

//              nSTSac+=IIF(SD2->D2_TES $ "514/515", 0,SD2->D2_TOTAL+SD2->D2_VALIPI)
//              nSTSacsI+=IIF(SD2->D2_TES $ "514/515", 0,SD2->D2_TOTAL)

              nSTSac+=SD2->D2_TOTAL+SD2->D2_VALIPI
              nSTSacsI+=SD2->D2_TOTAL

           EndIf
//           nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )  //Esmerino Neto 19/12/06 //retirado a pedido de janderley em 28/02/07
//           nFator := nFator + IIf( SD2->D2_UM == "KG", Round( SD2->D2_TOTAL / SD2->D2_QUANT, 2 ),Round( ( SD2->D2_TOTAL / SD2->D2_QUANT ) * SB1->B1_PESOR, 2 ) )
//           nQtdItem := nQtdItem + 1
			cPedido := SD2->D2_PEDIDO
           SD2->( dbSkip() )
        EndDo
      //Else          
      
        //nQtdKg   := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, SF2->F2_PLIQUI )  //Esmerino Neto 19/12/06       
      
     // EndIf

      if mv_par10 == 1
         aParcelas := {}
      endif

      SE1->( dbSeek( xFilial( "SE1" ) + SF2->F2_SERIE + SF2->F2_DOC, .T. ) )
      SZZ->( dbSeek( xFilial( "SZZ" ) + SC5->C5_TRANSP + SC5->C5_LOCALIZ ) )

      while SE1->E1_PREFIXO + SE1->E1_NUM == SF2->F2_SERIE + SF2->F2_DOC .and. SE1->( !Eof() )
         SC5->( dbSeek( xFilial( "SC5" ) + SE1->E1_PEDIDO, .T. ) )
         SA6->( dbSeek( xFilial( "SA6" ) + SE1->E1_PORTADO, .T. ) )
         SE4->( dbSeek( xFilial( "SE4" ) + SF2->F2_COND ) )
         cSit := ""

         //if Substr( SC5->C5_TIPAGTO, 1, 1 ) == "C" .and. SE1->E1_SERIE == "UNI" .or. Substr( SC5->C5_TIPAGTO, 2, 1 ) == "C" .and. SE1->E1_SERIE == "   "
         if Substr( SC5->C5_TIPAGTO, 1, 1 ) == "C" .and. SE1->E1_SERIE $ "UNI/0  " .or. Substr( SC5->C5_TIPAGTO, 2, 1 ) == "C" .and. SE1->E1_SERIE == "   "
            cSit := "Cheque"
         elseif Val( SE4->E4_COND ) <= 7
            cSit := "A Vista"
         elseif SE1->E1_SITUACA $ "0 "
            cSit := "Carteira"
         else
            cSit := SA6->A6_NREDUZ
         endif

         Aadd( aParcelas, { SE1->E1_VENCTO, SE1->E1_VALOR, cSit } )
         SE1->( dbSkip() )
      end

      SF2->( dbSkip() )
      IncRegua()

      if SF2->F2_SERIE < mv_par01 .or. SF2->F2_SERIE > mv_par02
         SF2->( dbSkip() )
         IncRegua()
      endif

      if mv_par10 == 1
         exit
      endif

      /*if cDoc == SF2->F2_DOC
         nQtdItem := 0
         nQtdKg   := 0
      endif*/
   end

   nFator := IIF(nQtdKg==0,0,Round( nSTSacsI / nQtdKg, 2 )) // Round( nValsIpi / nQtdKg, 2 )
   //MAPA DIÁRIO
   //NF/Serie     Pedido  Nome do Cliente       Cidade                  Transportadora  Emissao   Valor Total  Valor s/Ipi  Fator  Pz Med.  Quant.Kg  Qt.Cx.      Telefone        Contato         Prz.E  Vendedor         Exp"
   //999999999/9  999999  XXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX-XX XXXXXXXXXXXXXXX 00/00/00 9.999.999,99 9.999.999,99  999,99   99    999.999,99 999,999,999 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX  999   XXXXXXXXXXXXXXX  XXX
   //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //0         1         2         3         4         5         6         7         8         9        10        11        12        13       14        15        16        17         18        19        20        21        22
   
   
   //REL. NOTAS
   //"NF/Serie    Pedido  Nome do Cliente       Emissao   Valor Total  Situacao              Dt.Venct       Valor Dupl.  Exp"
   //999999999/9  999999  XXXXXXXXXXXXXXXXXXX  00/00/00  9.999.999,99 XXXXXXXXXXXXXXXXXXXX  00/00/00     9,999.999,99    XXX
   //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //0         1         2         3         4         5         6         7         8         9        10        11        12        13       14        15        16        17         18        19        20        21        22

   @ nLin,000 pSay cDoc + iif( mv_par10==1,"/"+alltrim(cSerie),"")
   //FR - 24/03/14 - CHAMADO 614 , INSERIR NÚMERO DO PEDIDO A QUE SE REFERE A NF:
   @ nLin,013 pSay cPedido
   @ nLin,021 pSay cNome

   cExp := iif(cExp=="01","JPA","SPA")

   if mv_par09 == 1
      @ nLin,043 pSay cCid //IMPRIME: CIDADE INFORM NA NOTA + UF
      @ nLin,067 pSay Substr( SA4->A4_NREDUZ,1,15 )//IMPRIME: NOME REDUZIDO DO CLIENTE
      @ nLin,083 pSay dEmissao//IMPRIME: DATA DA EMISSAO DA NOTA
      @ nLin,092 pSay nValbrut   Picture "@E 9,999,999.99"//IMPRIME: VALOR BRUTO DA NOTA
      @ nLin,105 pSay nValsIpi   Picture "@E 9,999,999.99"//IMPRIME: VALOR SEM IPI DA NOTA
      @ nLin,119 pSay nFator     Picture "@E 999.99"//IMPRIME: FATOR CALCULADO NA NOTA
      @ nLin,128 pSay nPRZMD     Picture "@E 99"//IMPRIME: PRAZO MEDIO DA COND PAG //Eurivan
      @ nLin,135 pSay nQtdKg     Picture "@E 999,999.99"//IMPRIME: QTD EM KILOS TOTAL DA NOTA

      @ nLin, 146  pSay  transform(nQtdCx,"@E 999,999,999")

      @ nLin, 158  pSay Transform( Substr(SA1->A1_TEL,1,10) , PesqPict("SA1", "A1_TEL") )//IMPRIME: TELEFONE DE CONTATO DO CADASTRO DE CLIENTE
      @ nLin, 174  pSay SA1->A1_CONTATO//IMPRIME: CONTATO COM O CLIENTE
      @ nLin, 191  pSay SZZ->ZZ_PRZENT Picture "@E 999"//IMPRIME: PRAZO PARA ENTREGA DA TRASNPORTADORA
      @ nLin, 197  pSay SA3->A3_NREDUZ//IMPRIME: NOME REDUZIDO DO CADASTROS DOS VENDEDORES
      @ nLin, 214  pSay cExp//por onde o produto foi expedido
         
  
   else
   //N.F.      Nome do Cliente                Emissao   Valor Total Situacao          Dt.Venct     Valor Dupl.  Exp"
   //999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 9,999,999.99 XXXXXXXXXXXXXXX   00/00/00    9.999.999,99  XXX
   //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //0         1         2         3         4         5         6         7         8         9        10  

      @ nLin,043 pSay dEmissao//IMPRIME: DATA DA EMISSAO DA NOTA
      @ nLin,053 pSay nValbrut Picture "@E 9,999,999.99"//IMPRIME: VALOR BRUTO APRESENTADO NA NOTA

      
      For Y := 1 to Len( aParcelas )//PARA: Y INICIANDO EM 1 ATÉ O TAMANHO DE ITENS DAS PARCELAS
          
          @ nLin, 068 pSay Substr(aParcelas[ y, 3 ],1,20) //IMPRIME: SITUAÇÃO DA NOTA
          @ nLin, 090 pSay aParcelas[ y, 1 ]//IMPRIME: VENCIMENTO DOS TITULOS DA NOTA
          @ nLin, 103 pSay aParcelas[ y, 2 ] Picture "@E 9,999,999.99"//IMPRIME: VALOR DA NOTA
          If Y = 1
          	@ nLin, 117 pSay cExp//por onde o produto foi expedido
          Endif
          nLin := nLin + 1//RECEBE: INCREMENTO DE Y+1
      Next
      //@ nLin, 117 pSay cExp//por onde o produto foi expedido

      if Len( aParcelas ) == 0//SE: TAMANHO DO ARQUIVO DE PARCELAS = 0
         nLin := nLin + 1//RECEBE: INCREMENTA NUMERO DE LINHAS
      endif

      @ nLin, 000 pSay Replicate( "-", 132 )//IMPRIME: LINHA SEPARADORA
   endif
   nTotKg   := nTotKg + nQtdKg//RECEBE: QTD DE KG DA NOTA
   nTotCx   := nTotCx + nQtdCx
   nTotFat  := nTotFat  + nFator//RECEBE: FATOR CALCULADO PARA A NOTA
   nTotal   := nTotal   + nValbrut//RECEBE: VALOR BRUTO DA NOTA
   nTotsIpi := nTotsIpi + nValsIpi//RECEBE: VALOR SEM IPI
   nTCx+= nSTCx
   nTSaco+= nSTSac
   nTCxsI+= nSTCxsI
   nTSacosI+= nSTSacsI
   nLin     := nLin     + 1//RECEBE: INCREMENTO DO CONTADOR DA LINHA DO RELATÓRIO

EndDo

IF nLin > 58//SE: NUMERO DE LINHAS DO RELATORIO FOR MAIOR QUE O LIMITE

   nLin := cabec( titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2 //RECEBE: ????????????????

EndIF

//nLin := nLin + 1//RECEBE: INCREMENTO PARA O CONTADOR DE LINHAS

//N.F.   Nome do Cliente                          Cidade                       Transportadora  Emissao   Valor Total  Valor s/Ipi  Fator  Pz Med.  Quant.Kg Telefone                  Contato         Prz.Entr. Vendedor"
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX-XX XXXXXXXXXXXXXXX 00/00/00 9.999.999,99 9.999.999,99 999,99    99    99.999,99 XXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX     9     XXXXXXXXXXXXXXX
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210

IF nLin > 59
    nLin := cabec( titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
    //nLin :=8 
EndIF

if mv_par09 == 1//SE: TIPO DO RELATORIO FOR MAPA DIÁRIO
   @ nLin,00 pSay "Total Saco ==>"//IMPRIME: STRING AO LADO
   @ nLin, 83/*102*/  pSay nTSaco    Picture "@E 999,999,999.99"//IMPRIME: TOTAL DA NOTA
   @ nLin, 98/*115*/  pSay nTSacosI  Picture "@E 999,999,999.99"//IMPRIME: TOTAL SEM IPI DA NOTA
   //@ nLin,128 pSay Round( nTotsIpi/nTotKg, 2 )  Picture "@E 999.99"//IMPRIME: FATOR DA NOTA
   @ nLin, 113/*128*/ pSay IIF(nTotKg=0,0,Round( nTSacosI/nTotKg, 2 ))  Picture "@E 999.99"//IMPRIME: FATOR DA NOTA
   @ nLin, 129/*142*/ pSay nTotKg Picture "@E 9999,999.99"//IMPRIME: TOTAL EM KG DOS ITENS DA NOTA
   @ nLin,143  pSay nTotCx Picture "@E 9999,999.99"
   nLin++
   IF nLin > 59
     nLin := cabec( titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
      //nLin :=8 
   EndIF

   @ nLin,00 pSay "Total Caixa ==>"
   @ nLin,83  pSay nTotal-nTSaco      Picture "@E 999,999,999.99"
   @ nLin,98  pSay nTotsIpi-nTSacosI Picture "@E 999,999,999.99"
   
   nLin++
   IF nLin > 59
      nLin := cabec( titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
      //nLin :=8       
   EndIF

   @ nLin,00 pSay "Total Geral ==>"
   @ nLin,83  pSay nTotal   Picture "@E 999,999,999.99"
   @ nLin,98  pSay nTotsIpi Picture "@E 999,999,999.99"
   
   
else//SENAO: TIPO DO RELATORIO FOR RELAÇÃO DE NOTAS FISCAIS
   @ nLin,00 pSay "Total ==>"//IMPRIME: STRING AO LADO
   @ nLin,077 pSay nTotal  Picture "@E 999,999,999.99"//IMPRIME: TOTAL DAS NOTAS

endif
nLin++
roda( cbcont, cbtxt, tamanho )//IMPRIME: RODAPÉ

Retindex( "SD2" )// ?????????
Retindex( "SF1" )// ?????????
Retindex( "SD1" )// ?????????
dbSelectArea( "SF2" )//DEFINE: AREA DE EXECURSÃO NO ARQUIVO DE CABEÇALHO DE NOTA FISCAL DE SAIDA
RetIndex( "SF2" )//EXECUTA: RETORNO DOS INDICES PARA O AQUIVO

Ferase( cIndSf2+".idx" )// ?????????

If aReturn[5] == 1//SE: O VALOR DE ARETURN FOR 1

   dbCommitAll()//EXECUTA: COMMIT EM TODOS OS ARQUIVOS ALTERADOS
   ourspool( wnrel )//EXECUTA: ABERTURA DO SPOOL DE IMPRESSAO NO ARQUIVO INDICADO NO WNREL

Endif

Return(.T.)

***************

Static Function fNaoLici(cDoc)

***************
Local cQry:=''
lRet:=.T.

cQry:="SELECT D2_DOC,D2_PEDIDO,C6_PREPED "
cQry+="FROM SD2020 SD2  "
cQry+="JOIN SC6020 SC6 ON C6_NUM=D2_PEDIDO "
cQry+="WHERE "
cQry+="C6_PREPED<>'' "
cQry+="AND D2_DOC='"+cDoc+"' "
cQry+="AND SC6.D_E_L_E_T_=''  "
cQry+="AND SD2.D_E_L_E_T_='' "
cQry+="GROUP BY D2_DOC,D2_PEDIDO,C6_PREPED "

If Select("TMPZ") > 0
	DbSelectArea("TMPZ")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMPZ"

If TMPZ->(!EOF())
   lRet:=.F.
ENDIF

Return lRet


