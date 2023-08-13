#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"

//--------------------------------------------------------------------------
//Programa: ESTR007
//Objetivo: Relatório de custo de frete por NF DE ENTRADA
//          
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 07/04/2011
//--------------------------------------------------------------------------

*************************
User Function ESTR007() 
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG,limite" )

tamanho   := "M"
titulo    := PADC("CUSTO FRETE x NF ENTRADA" , 74 )
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de custo de frete por notas de entrada. "
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "ESTR007"
cPerg     := "ESTR007"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "ESTR007"
M_PAG     := 1
li		  := 80
limite	  := 132

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .T. )               // Pergunta no SX1

cString := "SF1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se teclar ESC, sair³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

RptStatus({|| RptDetail()})  // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
Return



//------------------------------
Static Function RptDetail()     
//------------------------------

Local  cCodMoti    := ""
Local  cDescMoti   := ""
Local  nQtd		   := 0
Local aResult   := {}
Local LF		:= CHR(13) + CHR(10)
Local nTotGeral := 0    ///TOTAL GERAL DO FRETE
Local nTotGerNF	:= 0    ///TOTAL GERAL DAS NFS
Local nToTransp	:= 0		///TOTAL POR TRANSP
Local nTotConhec:= 0
Local nTotNF	:= 0
Local cTipoNf	:= ""
Local nRateio 	:= 0
Local nQtas		:= 0  
Local cConhecAnt:= ""
Local nPrimeira := 0  
Local cConhecto := ""
Local nCta		:= 0


//Parâmetros:
//--------------------------------
// mv_par01 - Emissao de
// mv_par02 - Emissao até
// mv_par03 - NF De
// mv_par04 - NF Até
// mv_par05 - Serie 
// mv_par06 - Transportadora De
// mv_par07 - Transportadora Até
//---------------------------------


//titulo    := PADC("CUSTO FRETE x NF ENTRADA - Periodo: " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 ), 80 )
If mv_par08 = 1
	titulo    := PADC("CUSTO FRETE x NF ENTRADA - Periodo: " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 ), 80 )
Else
	titulo    := PADC("NOTAS SEM ASSOCIAÇÃO ao CTRC - Periodo: " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 ), 80 )
Endif

/*
Cabec1 := "NF SAÍDA/      DT.SAÍDA    CODIGO      NOME CLIENTE             VALOR NF       VALOR FRETE    %FRETE   CONHECTO    TIPO"
Cabec2 := "SÉRIE                    CLIENTE/LJ                                                         SOB.VLR.NF   " 
Cabec3 := ""
*/

Cabec1 := "NF COMPRA/       EMISSAO    CODIGO      NOME FORNECEDOR       VALOR NF       VALOR FRETE    %FRETE      CONHECTO"
Cabec2 := "SÉRIE                      FORNEC/LJ                                                       SOB.VLR.NF          " 
Cabec3 := ""
//         999999999   99/99/99  999999/99     XXXXXXXXXXXXXXXXXXXX  9,999,999.99  9,999,999.99     9999.99%   999999999
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13



If mv_par08 = 1     //imprime nfs com conhecimento - CTRC

	cQuery := " Select " + LF
	cQuery += "  SF8.F8_NFDIFRE as CONHECTO , SF8.F8_SEDIFRE AS SERICON, SF8.F8_DTDIGIT " + LF
	cQuery += "  ,FRET.F1_DOC F1CONHE , FRET.F1_SERIE F1SRCON, FRET.F1_VALBRUT VALFRETE " + LF
	cQuery += "  ,COMP.F1_DOC NFCOMPRA, COMP.F1_SERIE SRCOMPRA, COMP.F1_FORNECE FORNECEDOR, COMP.F1_LOJA LOJA " + LF
	cQuery += "  ,FORC.A2_NREDUZ FORCOMP, FORF.A2_NREDUZ FORFRE " + LF
	cQuery += "  ,A4_COD, A4_NOME  " + LF
	cQuery += "  ,F8_NFORIG, F8_SERORIG, F8_DTDIGIT, F8_FORNECE, F8_LOJA,F8_TRANSP, F8_LOJTRAN   " + LF
	cQuery += "  ,COMP.F1_EMISSAO DTCOMPRA, COMP.F1_VALBRUT VALCOMPRA, COMP.F1_VALMERC VALMERC " + LF 
	
	cQuery += "  FROM  " + LF
	cQuery += "  " + RetSqlName("SF1") + " COMP, " + LF       //alias do SF1 PARA COMPRA
	cQuery += "  " + RetSqlName("SA2") + " FORC, " + LF       //ALIAS DO SA2 PARA COMPRA
	cQuery += "  " + RetSqlName("SA2") + " FORF,  " + LF      //ALIAS DO SA2 PARA FORNEC. FRETE
	cQuery += "  " + RetSqlName("SA4") + " SA4,  " + LF       //ALIAS DA TRANSPORTADORA
	cQuery += "  " + RetSqlName("SF1") + " FRET,  " + LF      //ALIAS DO SF1 PARA FRETE
	cQuery += "  " + RetSqlName("SF8") + " SF8  " + LF        //ALIAS DO FRETE
	
	cQuery += "  WHERE " + LF
	cQuery += " COMP.F1_TIPO = 'N'  AND " + LF
	cQuery += " COMP.F1_EMISSAO >= '" + DtoS(MV_PAR01) + "' AND COMP.F1_EMISSAO <= '" + DtoS(MV_PAR02) + "'  AND" + LF
	cQuery += " (COMP.F1_DOC + COMP.F1_SERIE ) = (SF8.F8_NFORIG + SF8.F8_SERORIG) AND " + LF

	cQuery += " COMP.F1_DOC >= '" + Alltrim(MV_PAR03) + "' AND COMP.F1_DOC <= '" + Alltrim(MV_PAR04) + "'  AND " + LF
	
	cQuery += " (FRET.F1_FORNECE + FRET.F1_LOJA ) = (FORF.A2_COD + FORF.A2_LOJA) AND " + LF
	cQuery += " (SF8.F8_TRANSP + SF8.F8_LOJTRAN) = (FORF.A2_COD + FORF.A2_LOJA) AND " + LF
    cQuery += "	(COMP.F1_FORNECE + COMP.F1_LOJA ) = (FORC.A2_COD + FORC.A2_LOJA) AND " + LF	
	cQuery += " (SF8.F8_NFDIFRE + SF8.F8_SEDIFRE )= ( FRET.F1_DOC + FRET.F1_SERIE ) AND " + LF
	cQuery += " SA4.A4_COD >= '" + Alltrim(MV_PAR05) + "' AND SA4.A4_COD <= '" + Alltrim(MV_PAR06) + "' AND" + LF
	cQuery += "  LEFT(SA4.A4_CGC,8) = LEFT(FORF.A2_CGC,8) AND  " + LF
	
	cQuery += " COMP.F1_FILIAL = '" + xFilial("SF1") + "'  AND " + LF
	 
	cQuery += " COMP.D_E_L_E_T_ = '' AND " + LF
	cQuery += " FRET.D_E_L_E_T_ = '' AND " + LF
	cQuery += " FORC.D_E_L_E_T_ = '' AND " + LF
	cQuery += " FORF.D_E_L_E_T_ = '' AND " + LF
	cQuery += " SA4.D_E_L_E_T_ = '' AND " + LF
	cQuery += " SF8.D_E_L_E_T_ = ''  " + LF
	
	cQuery += " GROUP BY " + LF
	cQuery += "  SF8.F8_NFDIFRE , SF8.F8_SEDIFRE , SF8.F8_DTDIGIT " + LF
	cQuery += "  ,FRET.F1_DOC , FRET.F1_SERIE , FRET.F1_VALBRUT " + LF
	cQuery += "  ,COMP.F1_DOC , COMP.F1_SERIE , COMP.F1_FORNECE , COMP.F1_LOJA " + LF
	cQuery += "  ,FORC.A2_NREDUZ , FORF.A2_NREDUZ " + LF
	cQuery += "  ,A4_COD, A4_NOME  " + LF
	cQuery += "  ,F8_NFORIG, F8_SERORIG, F8_DTDIGIT, F8_FORNECE, F8_LOJA,F8_TRANSP, F8_LOJTRAN   " + LF
	cQuery += "  ,COMP.F1_EMISSAO , COMP.F1_VALBRUT , COMP.F1_VALMERC  " + LF 
	cQuery += " ORDER BY A4_COD, SF8.F8_NFDIFRE, SF8.F8_SEDIFRE   " + LF


	
	
Else		//nfs sem associação ao CTRC --> chamado 002034

	///cabeçalho também muda
	Cabec1 := "NF ENTRADA/      DT.ENTRADA    CODIGO      NOME FORNECEDOR      VALOR NF "
	Cabec2 := "SÉRIE                         FORNEC/LJ                                  " 
	Cabec3 := ""
    //         999999999         99/99/99  999999/99     XXXXXXXXXXXXXXXXXXXX   9,999,999.99
    //         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
    //         0         1         2         3         4         5         6         7         8         9        10        11        12        13
	cQuery := " Select " + LF
	cQuery += "  COMP.F1_DOC NFCOMPRA, COMP.F1_SERIE SRCOMPRA, COMP.F1_FORNECE FORNECEDOR, COMP.F1_LOJA LOJA " + LF
	cQuery += "  ,COMP.F1_EMISSAO DTCOMPRA, COMP.F1_VALBRUT VALCOMPRA, COMP.F1_VALMERC VALMERC " + LF 
	cQuery += "  ,FORC.A2_NREDUZ FORCOMP " + LF	
	
	cQuery += "  FROM  " + LF
	cQuery += "  " + RetSqlName("SA2") + " FORC, " + LF       //ALIAS DO SA2 PARA COMPRA
	cQuery += "  " + RetSqlName("SF1") + " COMP " + LF       //alias do SF1 PARA COMPRA
		
	cQuery += " LEFT OUTER JOIN "
	cQuery += " " + RetSqlName("SF8") + " SF8 " + LF
	cQuery += " on (COMP.F1_DOC + COMP.F1_SERIE) IN (SF8.F8_NFORIG + SF8.F8_SERORIG) AND (SF8.F8_NFORIG + SF8.F8_SERORIG) IS NULL " + LF
    cQuery += " and (COMP.F1_FORNECE + COMP.F1_LOJA) IN (SF8.F8_FORNECE + SF8.F8_LOJA) AND (SF8.F8_FORNECE + SF8.F8_LOJA) IS NULL " + LF

    cQuery += " and SF8.F8_FILIAL = '" + xFilial("SF8") + "' AND SF8.D_E_L_E_T_ = '' " + LF
	
	cQuery += "  WHERE " + LF
	cQuery += " COMP.F1_TIPO = 'N'  AND " + LF
	
	cQuery += " COMP.F1_EMISSAO >= '" + DtoS(MV_PAR01) + "' AND COMP.F1_EMISSAO <= '" + DtoS(MV_PAR02) + "'  AND" + LF
	
	cQuery += " COMP.F1_DOC >= '" + Alltrim(MV_PAR03) + "' AND COMP.F1_DOC <= '" + Alltrim(MV_PAR04) + "'  AND " + LF
	
    cQuery += "	(COMP.F1_FORNECE + COMP.F1_LOJA ) = (FORC.A2_COD + FORC.A2_LOJA) AND " + LF	
	
	cQuery += " COMP.F1_FILIAL = '" + xFilial("SF1") + "'  AND " + LF
	 
	cQuery += " COMP.D_E_L_E_T_ = '' AND " + LF
	cQuery += " FORC.D_E_L_E_T_ = '' " + LF
	
	cQuery += " GROUP BY " + LF
	
	cQuery += "  COMP.F1_DOC , COMP.F1_SERIE , COMP.F1_FORNECE , COMP.F1_LOJA " + LF
	cQuery += "  ,COMP.F1_EMISSAO , COMP.F1_VALBRUT , COMP.F1_VALMERC " + LF 
	cQuery += "  ,FORC.A2_NREDUZ " + LF	
	
	cQuery += " ORDER BY COMP.F1_EMISSAO, COMP.F1_DOC, COMP.F1_SERIE    " + LF
	

Endif

MemoWrite("C:\Temp\ESTR007.sql", cQuery)


If Select("FRET1") > 0
	DbSelectArea("FRET1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FRET1"
TCSetField( 'FRET1', "F1_DTDIGIT", "D" )
TCSetField( 'FRET1', "F1_EMISSAO", "D" )
TCSetField( 'FRET1', "DTCOMPRA", "D" )


FRET1->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1


aResult 	:= {}

Do While !FRET1->( Eof() )
      
    If mv_par08 = 1 //com associação ao CTRC
    
	    cNomeTransp := FRET1->A4_NOME 
	    cTransp		:= FRET1->A4_COD
	    
	    If lEnd
			@ li,000 PSAY "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		
		If Li > 58
			Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
			li := 9
		Endif
		
			
		@li,000 PSAY "Transportadora: " + cTransp + " - " + Substr(cNomeTransp,1,15)
		//@li,033 PSAY " - Numero Conhecimento: " + cConhecto
		li++
		@li,000 PSAY Replicate("=",limite)
	
		Do While !FRET1->( Eof() ) .and. Alltrim(FRET1->A4_COD) == Alltrim(cTransp)
	    
			If Li > 58
				Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
				li := 9
			Endif
			
			If mv_par07 = 1		//se rateio = Sim
				If Alltrim(FRET1->CONHECTO) != Alltrim(cConhecto) .and. nQtas >= 2 
					li++
					li++
					@li,090 PSAY "Rateio => Valor Frete por NF: " + Transform( (nValFrete / nQtas) , "@E 9,999,999.99")
				
			 	    nQtas := 0			
				
				Elseif Alltrim(FRET1->CONHECTO) != Alltrim(cConhecto)  //if Alltrim(FRET1->CONHECTO) = Alltrim(cConhecto)
					nQtas := 1
				Else
					nQtas++
				Endif
				
				If Alltrim(FRET1->CONHECTO) != Alltrim(cConhecto)
					li++
					If nCta >= 1
						@ li,000 PSAY Replicate("-",limite)
						li++
					Endif
					li++
					@ li,000 PSAY "Conhecimento: " + FRET1->CONHECTO //cConhecto Picture "@X" 
					@ li,024 PSAY "Valor ---> "
					@ li,035 PSAY Transform(FRET1->VALFRETE, "@E 9,999,999.99")			//VALOR FRETE
					li++
				Endif
			Endif
			
			
	        li++
			@ li,000 PSAY FRET1->NFCOMPRA + ' / ' + FRET1->SRCOMPRA                       //NF ENTRADA/SERIE
		 	@ li,018 PSAY Dtoc(FRET1->DTCOMPRA)		Picture "@D"            		//DT.EMISSÃO
		 	@ li,028 PSAY FRET1->FORNECEDOR + "/" + FRET1->LOJA		Picture "@X"	//COD.FORNEC / LOJA
		 	@ li,042 PSAY Substr(FRET1->FORCOMP,1,20) Picture "@!"					//NOME FORNECEDOR
		 	@ li,060 PSAY FRET1->VALCOMPRA Picture "@E 9,999,999.99"					//VALOR COMPRA
			@ li,072 PSAY FRET1->VALFRETE  Picture "@E 9,999,999.99"					//VALOR FRETE
			@ li,091 PSAY Transform( ((VALFRETE / VALCOMPRA) * 100) , "@E 9999.99") + "%"    //% VALOR DO FRETE EM RELAÇÃO AO VALOR DA NF COMPRA
			@ li,104 PSAY FRET1->CONHECTO Picture "@X"    											//CONHECTO
			nToTransp += FRET1->VALFRETE	  	
		 	nTotNF	  += FRET1->VALCOMPRA
			 	
		 	cConhecto := FRET1->CONHECTO
		 	nValFrete := FRET1->VALFRETE
			nCta++		 			 			 	
		 	FRET1->(DBSKIP())         //AVANÇA PARA O PRÓXIMO REGISTRO 	
		    	 	
		Enddo
	 
		 
		 ////rodapé de total por transportadora
		 li++
		 @li,000 PSAY Replicate("-",limite)
		 li++ 
		 @li,000 PSAY "Total da Transportadora: " + Alltrim(Substr(cNomeTransp,1,15))
		 @li,060 PSAY Transform(nToTNF   , "@E 9,999,999.99")         //TOTAL DA NF
		 @li,072 PSAY Transform(nToTransp, "@E 9,999,999.99")         //TOTAL DO FRETE
		 @li,091 PSAY Transform( ((nToTransp / nTotNF) * 100) , "@E 9999.99") + "%"    //% DO FRETE EM RELAÇÃO AO VALOR DA NF
		
		 li++
	     @li,000 PSAY Replicate("=",limite)
		 li++ 
		 li++
		 li++
		 nTotGerNF += nTotNF
		 nTotGeral += nToTransp
		 //nValFrete := 0
		 nTotNF    := 0
		 nToTransp := 0
	 
    Else     ///notas de entrada SEM ASSOCIAÇÃO COM O CTRC
    	
    	Do While !FRET1->( Eof() ) //.and. Alltrim(FRET1->A4_COD) == Alltrim(cTransp)
		     	
			If Li > 58
				Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
				li := 9
			Endif
					
	        
			@ li,000 PSAY FRET1->NFCOMPRA + ' / ' + FRET1->SRCOMPRA                       //NF ENTRADA/SERIE
		 	@ li,018 PSAY Dtoc(FRET1->DTCOMPRA)		Picture "@D"            		//DT.EMISSÃO
		 	@ li,028 PSAY FRET1->FORNECEDOR + "/" + FRET1->LOJA		Picture "@X"	//COD.FORNEC / LOJA
		 	@ li,042 PSAY Substr(FRET1->FORCOMP,1,20) Picture "@!"					//NOME FORNECEDOR
		 	@ li,065 PSAY FRET1->VALCOMPRA Picture "@E 9,999,999.99"					//VALOR COMPRA
			li++
						
		 	nTotNF	  += FRET1->VALCOMPRA
					 	
		 	FRET1->(DBSKIP())         //AVANÇA PARA O PRÓXIMO REGISTRO 
			 	
			    	 	
		Enddo    
    
	    ////rodapé de total 
		 li++
		 @li,000 PSAY Replicate("-",limite)
		 li++ 
		 @li,000 PSAY "Total NF: " 
		 @li,065 PSAY Transform(nToTNF   , "@E 9,999,999.99")         //TOTAL DA NF
		 
		 li++
	     @li,000 PSAY Replicate("=",limite)
		 li++ 
		 li++
		 li++
		 nTotGerNF += nTotNF
		 
		 //nValFrete := 0
		 nTotNF    := 0
		 
    
    Endif
    
    
Enddo 

///imprime o total geral
nLin++
@li,000 PSAY Replicate("*",limite)

li++
@li,012 PSAY "T O T A L   G E R A L  ==> "

If mv_par08 = 1
	@li,060 PSAY Transform(nTotGerNF, "@E 9,999,999.99")    //total geral do valor das nfs
	@li,072 PSAY Transform(nTotGeral, "@E 9,999,999.99")   //total geral do valor de frete
	@li,091 PSAY Transform( ((nTotGeral / nTotGerNF) * 100) , "@E 9999.99") + "%"
Else
	@li,065 PSAY Transform(nTotGerNF, "@E 9,999,999.99")    //total geral do valor das nfs
Endif
li++
@li,000 PSAY Replicate("*",limite)

FRET1->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif


Return NIL
