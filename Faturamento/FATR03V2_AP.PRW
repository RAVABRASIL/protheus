#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATR03V2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("cPRODTmp1,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatrcan  ³ Autor ³   Diego Araujo      ³ Data ³ 12/09/05³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DescriCAo ³       Relacao de pedidos em carteira                       ³±±
±±³Alterado por: Flávia Rocha - 08/03/2010								   ±±
±±³Objetivo    : Criar filtro por TES  									   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Emissao                               ³
//³ mv_par02        	// Ate Emissao                              ³
//³ mv_par03        	// De Pedido                                ³
//³ mv_par04        	// Ate Pedido                               ³
//³ mv_par05        	// De Produto                               ³
//³ mv_par06        	// Ate Produto                              ³
//³ mv_par07        	// De Cliente                               ³
//³ mv_par08        	// Ate a Cliente                            ³
//³ mv_par09        	// Materia Prima                            ³
//  mv_par15			// TES   
//  mv_par16			// Tipo da Carteira: Imediata/Programada/Todas   
//incluído por solicitação do chamado 001505 - JOão Emanuel
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tamanho   := "M"
titulo    := PADC("Relatorio de Pedidos em Carteira",74)
cDesc1    := PADC("Este programa ira Emitir o Relatorio de pedidos em carteira",74)
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATR03V2"
cPerg     := "FATR03"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATR03V2"
M_PAG     := 1

cCabec1 := "/------------- C l i e n t e ------------\ /---- P e d i d o ----\/---- E m i s s a o ----\/---- E s t a d o ----\"
cCabec2 := "Cod          Descricao do Produto                             TES    Quant. 1a Um   Quant.  2a Um    Valor Ped. Marg.    Est.Vir."



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .F. )               // Pergunta no SX1

cString := "SC5"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint( cString, wnrel, ""   , @titulo, cDesc1, cDesc2, cDesc3, .T.,aOrd,.T.,Tamanho,,.T.)
wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .T., "" ,   ,Tamanho,,.T.)

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
RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})

Return

****************************
Static Function RptDetail()
****************************

If Subs( Alltrim( mv_par05 ), 4, 1) == "R"
	cPRODTmp1 := Subs( Alltrim( mv_par05 ), 1, 1 ) + "D" + Subs( Alltrim( mv_par05 ), 2,4)
Else
	cPRODTmp1 := Subs( Alltrim( mv_par05 ), 1, 1 ) + "D" + Subs( Alltrim( mv_par05 ), 2, 3 )
EndIf

cQuery := " SELECT SC5.C5_TIPO, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_EMISSAO, SC5.C5_NUM, SC6.C6_PRODUTO, SC6.C6_PREPED, "
//cQuery += "( SC6.C6_VALOR / SC6.C6_QTDVEN ) AS PRECO, SC6.C6_UM, SC6.C6_SEGUM, SB1.B1_DESC, "
cQuery += " ( SC6.C6_PRUNIT ) AS PRECO, SC6.C6_UM, SC6.C6_SEGUM, SC6.C6_TES, SB1.B1_DESC, "
cQuery += " SC9.C9_QTDLIB AS QUANT, ( SC9.C9_QTDLIB * SB1.B1_PESOR ) AS PESO, SE4.E4_DESCRI, "
cQuery += " SC5.C5_PRIORES, SC6.C6_QTDRESE, SC5.C5_ENTREG "
cQuery += " FROM " + RetSqlName( "SB1" ) + " SB1, " 
cQuery += " " + RetSqlName( "SC5" ) + " SC5, " 
cQuery += " " + RetSqlName( "SC6") + " SC6, " 
cQuery += " " + RetSqlName( "SC9") + " SC9, " 
cQuery += " " + RetSqlName( "SE4") + " SE4 "
cQuery += " WHERE SC5.C5_EMISSAO >= '" +  Dtos( mv_par01 ) + "' AND SC5.C5_EMISSAO <= '" + Dtos( mv_par02 ) + "' "
cQuery += " AND SC5.C5_ENTREG BETWEEN '"+Dtos(MV_PAR12)+"' AND '"+Dtos(MV_PAR13)+"' "
cQuery += " AND ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 " 
/**/
if MV_PAR11 == 1
   cQuery += " and SC6.C6_LOCAL = '01' "
elseIf MV_PAR11 == 2
   cQuery += " and SC6.C6_LOCAL = '10' "
else
   cQuery += " and SC6.C6_LOCAL in ('01','10') "
endif

If !empty(MV_PAR14)
    cQuery += " and SC5.C5_VEND1 in ('"+MV_PAR14+"','"+alltrim(MV_PAR14) +"VD'"+") "
Endif

If !Empty(mv_par15)
	cQuery += " AND RTRIM(SC6.C6_TES) = '" + alltrim(mv_par15) + "' "
Endif

cQuery += "  and SC5.C5_CLIENTE >= '"+ mv_par07 + "' AND SC5.C5_CLIENTE <= '"+ mv_par08 + "' "
cQuery += "  and SC5.C5_NUM >= '" + mv_par03 + "' AND SC5.C5_NUM <= '" + mv_par04 + "' "
cQuery += " AND SC6.C6_NUM = SC9.C9_PEDIDO "
cQuery += " AND SC6.C6_ITEM = SC9.C9_ITEM "
//cQuery += " AND SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST <> '10' "
// NOVA LIBERACAO DE CRETIDO
cQuery += " AND SC9.C9_BLCRED IN( '  ','04') AND SC9.C9_BLEST <> '10' "
cQuery += " AND (SB1.B1_COD >= '" + mv_par05 + "' AND SB1.B1_COD <= '" + mv_par06 + "' OR SB1.B1_COD LIKE '" + cPRODTmp1 + "%') "
cQuery += " AND SC6.C6_BLQ <> 'R' " 
cQuery += " AND SB1.B1_TIPO = 'PA' "
cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD "
cQuery += " AND SC5.C5_CONDPAG = SE4.E4_CODIGO "
cQuery += " AND SC5.C5_NUM = SC6.C6_NUM "
if MV_PAR16 = 1 //Carteira Imediata
  cQuery += "AND SC5.C5_ENTREG = SC5.C5_EMISSAO "
elseif MV_PAR16 = 2 //Carteira Programada
  cQuery += "AND SC5.C5_ENTREG > SC5.C5_EMISSAO "
endif
cQuery += " AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " AND SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY SC5.C5_PRIORES, SC5.C5_NUM, SC6.C6_ITEM "
cQuery := ChangeQuery( cQuery )

//MemoWrite("\Temp\CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

TCQUERY cQuery NEW ALIAS "SC5X"
TCSetField( 'SC5X', "C5_EMISSAO", "D" )
TCSetField( 'SC5X', "C5_ENTREG", "D" )
TCSetField( 'SC5X', "QUANT", "N" , 10, 3 )
TCSetField( 'SC5X', "PESO", "N" , 10, 3 )

//COUNT TO nRecCount   <--- Essa Funcao assume o numero de registros do SQL
//( SC6.C6_VALOR / SC6.C6_QTDVEN )  <--- Preço por Milheiro
//( SC6.C6_QTDVEN - SC6.C6_QTDENT )  <--- Quantidade por Milheiro




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DADOS IMPRESSOS NO RELATORIO    					         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SC5X->( DBGoTop() )

nLin := Cabec( titulo, cCabec1, cCabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho

//  @ Prow() + 1,000 PSay "/------------- C l i e n t e ------------\ /---- P e d i d o ----\/---- E m i s s a o ----\/---- E s t a d o ----\"
//  @ Prow() + 1,000 PSay "Cod          Descricao do Produto                                   TES  Quant. 1a Um   Quant.  2a Um      Valor Ped.  Marg.   Est.Vir."
//  @ Prow() + 1,000 PSay "Cod          Descricao do Produto                                   TES  Quant. 1a Um   Quant.  2a Um      Valor Ped.  Fator   Est.Vir."
//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                                 1         2         3         4         5         6         7         8         9        10        11        12
// @ Prow() + 1,000 pSay Repl( '*', 130 )

nValTotGer := 0
lVal := .F.
aEst := {}
nFator := nMargem := 0

While ! SC5X-> ( EOF() )
  	 /*dbSelectArea("SA1")
   	 dbSetOrder( 1 )
     SA1->( dbSeek( xFilial('SA1') + SC5X->C5_CLIENTE + SC5X->C5_LOJACLI ,.F.) )*/
	 if mv_par10 == 2//Só licitação
	   	if empty(SC5X->C6_PREPED)//SA1->A1_SATIV1 != "000009"
	   		SC5X->( dbSkip() )
	   		Loop
	   	endIf
 	 Elseif mv_par10 == 3//Só clientes novos e não licitação
 	 	if !empty(SC5X->C6_PREPED) .or. !priCom( SC5X->C5_CLIENTE, SC5X->C5_LOJACLI )//SA1->A1_SATIV1 == "000009"
	   		SC5X->( dbSkip() )
	   		Loop
	   	endIf 	 
 	 endIf

	 If SC5X->C5_TIPO = 'B'
	  	dbSelectArea("SA2")
	   	dbSetOrder( 1 )
		SA2->( dbSeek( xFilial("SA2") + SC5X->C5_CLIENTE, .T. ) )
		cNome := SUBS(SA2->A2_NOME,1,30)
		cUF   := SA2->A2_EST
		cClie := SC5X->C5_CLIENTE
		lVal  := .T.

		//FLAVIA
 	 	/*
 	 	if !cUF $ 'RR/RO/AC/AM/PA/AP/TO'
	   		SC5X->( dbSkip() )
	   		Loop
	   	endIf 	 
        */
		
	 Else
	  	dbSelectArea("SA1")
	   	dbSetOrder( 1 )
		SA1->( dbSeek( xFilial("SA1") + SC5X->C5_CLIENTE, .T. ) )
		cNome := SUBS(SA1->A1_NOME,1,30)
		cUF   := SA1->A1_EST

        //FLAVIA
        /*
 	 	if !cUF $ 'RR/RO/AC/AM/PA/AP/TO'
	   		SC5X->( dbSkip() )
	   		Loop
	   	endIf 	 
        */
		
	 EndIf


	 //SA2->(dbSeek( xFilial( "SC5" )+SC5X->C5_CLIENTE,.t. ))
	 //SA2->( dbSeek( SC5X->C5_FILIAL + SC5X->C5_CLIENTE, .t. ) )
//	 SA2->( dbSeek( '  ' + SC5X->C5_CLIENTE, .T. ) )
	 //@ Prow() + 1,000 PSay Iif(SC5X->C5_TIPO == 'B', SC5X->A2_COD + "-" + SC5X->A2_NOME, SC5X->A1_COD + "-" + SC5X->A1_NOME) + " PEDIDO: " + SC5X->C5_NUM + "     EMISSAO: " + Dtoc(SC5X->C5_EMISSAO) + "      ESTADO: " + SC5X->A1_EST
	 
//			@ Prow() + 1,000 PSay "/------------- C l i e n t e ------------\ /---- P e d i d o ----\/---- E m i s s a o ----\/---- E s t a d o ----\"
// 			@ Prow() + 1,000 PSay "Cod          Descricao do Produto                                   TES  Quant. 1a Um   Quant.  2a Um      Valor Ped.  Fator   Est.Vir."
// 			//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
// 			//                               1         2         3         4         5         6         7         8         9        10        11
//			@ Prow() + 1,000 pSay Repl( '*', 130 )	 
	 
	 @ Prow() + 1,000 PSay "EMISSAO: "+dtoc(SC5X->C5_EMISSAO)
	 @ Prow() + 1,000 PSay alltrim(SC5X->C5_CLIENTE) + "-" + cNome +" PRIORI: "+SC5X->C5_PRIORES+;
                          " PEDIDO: " + alltrim(SC5X->C5_NUM) + "     COND.PAG.: " + alltrim(SC5X->E4_DESCRI) +;
                          " PREV.FAT: " + dtoc(SC5X->C5_ENTREG) +" NDIAS: "+ alltrim(str(dDatabase - SC5X->C5_ENTREG)) +;	
                          "  ESTADO: " + cUF
						  //" PREV.FAT: " + dtoc(SC5X->C5_EMISSAO) +" NDIAS: "+ alltrim(str(dDatabase - stod(SC5X->C5_ENTREG))) +;

     cClie := SC5X->C5_CLIENTE
	 cPedi := SC5X->C5_NUM
     @ Prow() + 1,000 pSay Repl( ' ', 120 )
     cValTot := 0

	 //While ! SC5X-> ( EOF() )  .AND. cClie = Iif(SC5X->C5_TIPO = 'B', SA2->A2_COD, SA1->A1_COD) .AND. cPedi = SC5X->C5_NUM

	 While ! SC5X-> ( EOF() )  .AND. cClie = SC5X->C5_CLIENTE .AND. cPedi = SC5X->C5_NUM
		  cPROD := SC5X->C6_PRODUTO
	      If Len( AllTrim( cPROD ) ) >= 8
	  			 If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
				      cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SC6->C6_PRODUTO ) )
	     		 Else
				      cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SC6->C6_PRODUTO ) )
			     EndIf
	      EndIf

		 @ Prow() + 1,000 PSay Alltrim( cPROD ) 					//Código do Produto
		 @ Prow()    ,013 PSay Alltrim( SC5X->B1_DESC ) 			//Descrição do Produto
		 @ Prow()	 ,063 Psay Alltrim( SC5X->C6_TES )      		//TES
		 @ Prow()    ,067 PSay SC5X->QUANT Picture "@E 999,999.99" 	//Quantidade em Milheiros
		 @ Prow()    ,079 PSay alltrim(SC5X->C6_UM)  				//1ª Un de Medida
		 @ Prow()    ,083 PSay SC5X->PESO  Picture "@E 999,999.99" 	//Quantidade em quilos
		 @ Prow()    ,095 PSay SC5X->C6_SEGUM 						//2ª Un de Medida
		 @ Prow()    ,099 PSay SC5X->PRECO * SC5X->QUANT Picture "@E 999,999.99" //Valor do item de Pedido
		 
		 nFator  := (SC5X->PRECO * SC5X->QUANT) / SC5X->PESO
		 nMargem := Round( ((nFATOR*100)/MV_PAR09) - 100, 2 )
		 
		 @ Prow()    ,111 PSay nMargem Picture "@E 999.99" //Valor da margem
		 /**/
		 //nIdx := aScan(aEst, { |x| x[1] == U_transGen( SC5X->C6_PRODUTO ) } )
		 nIdx := aScan(aEst, { |x| x[1] == cProd } )
         if nIdx  == 0
	           dbSelectArea('SB2')    
	   		   //SB2->( dbSeek( xFilial('SB2') + padr( U_transGen( SC5X->C6_PRODUTO ), 15 ) + '01', .F. ) )
	   		   SB2->( dbSeek( xFilial('SB2') + padr( cProd, 15 ) + '01', .F. ) )
	           //nRes := SB2->B2_QATU - liberad( SC5X->C6_PRODUTO ) - SC5X->C6_QTDRESE
	           nRes := SB2->B2_QATU - liberad( SC5X->C6_PRODUTO, cProd ) - SC5X->C6_QTDRESE
	           //aAdd( aEst, { U_transGen( Alltrim( SC5X->C6_PRODUTO ) ), nRes } )
	           /**/ //Incluído em 22/10/2007
	 		   if SB2->( dbSeek( xFilial('SB2') + padr( cProd, 15 ) + '02', .F. ) )           
	 		     //nRes := SB2->B2_QATU - liberad( SC5X->C6_PRODUTO, cProd ) - SC5X->C6_QTDRESE
	 		     nRes += SB2->B2_QATU
	 		   end
	           /**/
	           aAdd( aEst, { cProd, nRes } )
			   @ Prow() ,119 PSay transform(nRes, '@E 99,999.999')
			   SB2->( dbCloseArea() )
		 else
			   aEst[ nIdx ][2] -= SC5X->C6_QTDRESE
			   @ Prow()    ,119 PSay transform(aEst[ nIdx ][2], '@E 99,999.999')
		 endIf
		 /**/
		 cValTot += (SC5X->PRECO * SC5X->QUANT) //Total do Pedido

		 SC5X->( dbskip() )

		 if Prow() > 58

		  	nLin:=Cabec( titulo, cCabec1, cCabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho

//			@ Prow() + 1,000 PSay "/------------- C l i e n t e ------------\ /---- P e d i d o ----\/---- E m i s s a o ----\/---- E s t a d o ----\"
// 			@ Prow() + 1,000 PSay "Cod          Descricao do Produto                                   TES  Quant. 1a Um   Quant.  2a Um      Valor Ped.  Fator   Est.Vir."
// 			//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
// 			//                               1         2         3         4         5         6         7         8         9        10        11
//			@ Prow() + 1,000 pSay Repl( '*', 130 )

    	endIf

	 EndDo

	   	 @ Prow() + 1,000 pSay Repl( '-', 130 )
	 	 @ Prow() + 1,090 PSay "Total Pedido: " + Trans(cValTot,"@E 999,999.99") //Total do Pedido
	 	 nValTotGer += cValTot

		//SA1->( DbCloseArea() )

		/*If lVal
			SA2->( DbCloseArea() )
		EndIf*/

EndDo
 @ Prow() + 1,000 pSay Repl( '*', 130 )
 @ Prow() + 2,089 PSay "TOTAL GERAL: " + Trans(nValTotGer,"@E 9,999,999.99") //Total Geral dos Pedidos

SC5X->( DbCloseArea() )

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

Return Nil

***************

Static Function liberad( cPrdt, cPrdt1 )

***************

Local cQuery := ''
Local nTotal := 0
cQuery := "select sum( C9_QTDLIB ) TOTAL "
cQuery += "from " + retSqlname('SC9') + " SC9 "
//cQuery += "where C9_PRODUTO in ('" + cPrdt + "','" + U_transGen( cPrdt ) + "') "
cQuery += "where C9_PRODUTO in ('" + cPrdt + "','" + cPrdt1 + "') "
//cQuery += "and C9_BLCRED = ' ' and C9_BLEST = ' ' "
// NOVA LIBERACAO DE CRETIDO
cQuery += "and C9_BLCRED IN( ' ','04') and C9_BLEST = ' ' "
cQuery += "and SC9.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'SC9X'

SC9X->( dbGoTop() )
nTotal += SC9X->TOTAL
SC9X->( dbCloseArea() )

Return nTotal

***************

Static Function priCom( cCliente, cLojacli )

***************

Local cQuery := ""
Local lRet := .F.
cQuery += "select count(*) QTD from "+retSqlName("SF2")+" where F2_CLIENTE = '"+cCliente+"' and F2_LOJA = '"+cLojacli+"' and D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "_TMPL"
_TMPL->( dbGoTop() )

if !_TMPL->( EoF() )
	if _TMPL->QTD < 1
		lRet := .T.
	endIf
endIf
_TMPL->( dbCloseArea() )
Return lRet