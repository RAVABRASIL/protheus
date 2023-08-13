#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"

//--------------------------------------------------------------------------
//Programa: FATR026
//Objetivo: Relatório de custo de frete por NF 
//          
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 29/12/2010
//--------------------------------------------------------------------------

*************************
User Function FATR026() 
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

tamanho   := "G"
titulo    := PADC("CUSTO FRETE x NF SAÍDA" , 74 )
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de custo de frete por notas faturadas. "
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "FATR026"
cPerg     := "FATR026"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATR026"
M_PAG     := 1
li		  := 80
limite	  := 220

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄFÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
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
LOCAL nPesoT:=nPeso:=0
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
local aRegiao:={'Centro-Oeste','Nordeste','Norte','Sudeste','Sul'}

//Parâmetros:
//--------------------------------
// mv_par01 - Emissao de
// mv_par02 - Emissao até
// mv_par03 - NF De
// mv_par04 - NF Até
// mv_par05 - Serie 
// mv_par06 - Transportadora De
// mv_par07 - Transportadora Até 
// mv_par08 - 1-Com Associação ao CTRC / 2-Sem Associação ao CTRC
// mv_par09 - Imprime 6DD ? 1-Sim / 2-Nao
// mv_par10 - Imprime Bonificação ? 1-Sim / 2-Nao
// mv_par11 - Imprime Amostra ? 1-Sim / 2-Nao
// mv_par12 - regiao : 1-Centro-Oeste/2-Nordeste/3-Norte/4-Sudeste/5-Sul
// mv_par13 - imprime por regiao ? 1-Sim / 2-Nao
//---------------------------------

If mv_par08 = 1
	titulo    := PADC("CUSTO FRETE x NF SAÍDA - Periodo: " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )+IIF(EMPTY(MV_PAR15),iif(MV_PAR13=1,' Regiao: '+aRegiao[MV_PAR12],''),' Uf: '+UPPER(MV_PAR15)) , 80 )
Else
	titulo    := PADC("CUSTO FRETE x NF SAÍDA - NFs S/ ASSOCIAÇÃO ao CTRC - Periodo: " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )+IIF(EMPTY(MV_PAR15),iif(MV_PAR13=1,' Regiao: '+aRegiao[MV_PAR12],''),' Uf: '+UPPER(MV_PAR15)), 80 )
Endif
//N.FISCAL
// VALOR
// PESO
// VALOR FRETE
// % FRETE 
//LOCALIDADE
// UF 
//REGIÃO
If mv_par08 = 1     //imprime nfs com conhecimento - CTRC
	Cabec1 := "NF SAÍDA/      DT.SAÍDA    CODIGO      NOME CLIENTE             VALOR NF       VALOR FRETE    %FRETE   CONHECTO TIPO  PESO          LOCALIDADE                        UF  REGIAO"
	Cabec2 := "SÉRIE                    CLIENTE/LJ                                                         SOB.VLR.NF   " 
Else
	Cabec1 := "NF SAÍDA/      DT.SAÍDA    CODIGO      NOME CLIENTE             VALOR NF          PESO              LOCALIDADE                  UF   REGIAO"
	Cabec2 := "SÉRIE                    CLIENTE/LJ                                                                      " 
Endif
Cabec3 := ""
//         999999999  99/99/99   999999/99     XXXXXXXXXXXXXXXXXXXX  9,999,999.99  9,999,999.99     9999.99%   999999999
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13

//depois do dia 11/03/11 passou a gravar na nova tabela ZC1


If mv_par08 = 1     //imprime nfs com conhecimento - CTRC

	If DtoS(MV_PAR01) >= '20110210'
	
		cQuery := " select D2_TES, F2_DOC , F2_SERIE , F2_DTEXP, F2_EMISSAO, F2_CLIENTE, F2_LOJA,F2_VALBRUT " + LF
		cQuery += " ,A1_NREDUZ, A2_NREDUZ, A2_CGC " + LF
		cQuery += " ,A4_COD, A4_NOME " + LF
	
		//cQuery += " , ZC1_NFSAID, ZC1_CONHEC " + LF
		cQuery += " , F1_VALBRUT, F1_VALMERC "+ LF
		cQuery += " , F1_DOC as CONHECTO, F1_SERIE AS SRCONHECI, F1_DTDIGIT, F1_FORNECE, F1_LOJA " + LF
		cQuery += " , F2_TRANSP,PESO=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 ELSE (D2_QUANT)*D2_PESO END) "+ LF
		
		cQuery += " ,ZZ_DESC LOCALIDADE, F2_EST "+ LF
		
		cQuery += " ,CASE WHEN F2_EST IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'  "+ LF
		cQuery += "     ELSE CASE WHEN F2_EST  IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') THEN 'Nordeste'  "+ LF
		cQuery += "     ELSE CASE WHEN F2_EST  IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste'  "+ LF
		cQuery += "     ELSE CASE WHEN F2_EST IN ('MG', 'ES', 'RJ', 'SP') THEN 'Sudeste'  "+ LF
		cQuery += "     ELSE CASE WHEN F2_EST  IN ('RS', 'PR', 'SC') THEN 'Sul' ELSE '' END  END END END END REGIAO "+ LF
		
		    
		cQuery += " FROM " + LF
		cQuery += " " + RetSqlName("SF1") + " SF1, " + LF
		cQuery += " " + RetSqlName("SF8") + " SF8, " + LF
		cQuery += " " + RetSqlName("SF2") + " SF2, " + LF
		cQuery += " " + RetSqlName("SD2") + " SD2, " + LF
		cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
		cQuery += " " + RetSqlName("SA2") + " SA2, " + LF 
		cQuery += " " + RetSqlName("SA4") + " SA4, " + LF
		cQuery += " " + RetSqlName("SD1") + " SD1 " + LF
		//cQuery += " " + RetSqlName("ZC1") + " ZC1 " + LF
		
		cQuery += " ," + RetSqlName("SZZ") + " SZZ " + LF
		
		cQuery += " WHERE  "+ LF
	    // REGIAO 
		If empty(MV_PAR15) // uf vazio
			If MV_PAR13=1 // imprime por regiao-Sim
				If MV_PAR12=1
				   cQuery += "F2_EST IN ('GO', 'MT', 'MS', 'DF') AND "+ LF // CENTRO-OESTE
				ElseIf MV_PAR12=2
				   cQuery += "F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') AND "+ LF // NORDESTE
				ElseIf MV_PAR12=3
				   cQuery += "F2_EST IN ('AC','AM','AP','PA','RO','RR','TO') and  "+ LF// norte 
				ElseIf MV_PAR12=4
				   cQuery += "F2_EST IN ('MG', 'ES', 'RJ', 'SP') AND "+ LF // SUDESTE
				ElseIf MV_PAR12=5
				   cQuery += "F2_EST IN ('RS', 'PR', 'SC') AND "+ LF // SUl 
				EndIf
			Endif
		Else
		    cQuery += "F2_EST IN ('"+UPPER(MV_PAR15)+"') AND "+ LF // uf 
		Endif		// valor minimo
		If MV_PAR14=1 // sim 
			   cQuery += "F2_VALBRUT < 1000 AND "+ LF 
		EndIf		
		//
		cQuery += " F2_LOCALIZ = ZZ_LOCAL AND " + LF
		cQuery += " F2_TRANSP = ZZ_TRANSP AND " + LF
		
		cQuery += " F2_FILIAL = D2_FILIAL AND " + LF
		cQuery += " (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE) AND "+ LF
		cQuery += " (F1_DOC + F1_SERIE ) = (D1_DOC + D1_SERIE) AND "+ LF
		cQuery += " F1_FILIAL = D1_FILIAL AND " + LF
		//cQuery += " F1_DOC = ZC1_CONHEC AND "+ LF 
		
		cQuery += " F8_FILIAL = F1_FILIAL AND " + LF
		cQuery += " F8_NFDIFRE = F1_DOC AND " + LF
		cQuery += " F8_SEDIFRE = F1_SERIE AND " + LF
		
		//cQuery += " F2_DOC = ZC1_NFSAID  AND "+ LF
		//cQuery += " F2_DOC = F8_NFORIG  AND "+ LF
		//cQuery += " F2_SERIE = F8_SERORIG AND " + LF
		cQuery += " F2_EMISSAO >= '" + DtoS(MV_PAR01) + "' AND F2_EMISSAO <= '" + DtoS(MV_PAR02) + "'  AND" + LF
		cQuery += " F2_DOC >= '" + Alltrim(MV_PAR03) + "' AND F2_DOC <= '" + Alltrim(MV_PAR04) + "'  AND" + LF
		
		cQuery += " (F2_CLIENTE + F2_LOJA ) = (A1_COD + A1_LOJA) AND" + LF
		cQuery += " (F1_FORNECE + F1_LOJA ) = (A2_COD + A2_LOJA) AND" + LF
		cQuery += " (D1_FORNECE + D1_LOJA)  = (A2_COD + A2_LOJA) AND " + LF
		cQuery += " F2_TRANSP >= '" + Alltrim(MV_PAR05) + "' AND F2_TRANSP <= '" + Alltrim(MV_PAR06) + "' AND" + LF
		cQuery += " F2_TRANSP <> '024' AND" + LF 
		cQuery += " F2_TRANSP <> '025' AND" + LF  // CLIENTE RETIRA  
		cQuery += " F2_TRANSP = A4_COD  AND" + LF
		cQuery += " A2_CGC = A4_CGC AND " + LF
		
				
		If mv_par09 = 2    //exclui 6DD
			cQuery += " SF2.F2_SERIE <> '' AND " + LF
		Endif		
							
		If mv_par10 = 2   //EXCLUI BONIFICAÇÃO
			cQuery += " SD2.D2_TES NOT IN ('514','542','548','550') AND " + LF
		Endif
			
		If mv_par11 = 2    //EXCLUI AMOSTRA
			cQuery += " SD2.D2_TES NOT IN  ('516','507','543','547' ) AND " + LF
		Endif
		
		cQuery += " SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND SF1.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SA4.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = '' AND "+ LF
		//cQuery += " ZC1.ZC1_FILIAL = '" + xFilial("ZC1") + "' AND ZC1.D_E_L_E_T_ = '' AND "+ LF
		cQuery += " SZZ.D_E_L_E_T_ = '' "+ LF
		
		cQuery += " GROUP BY D2_TES, F2_DOC , F2_SERIE , F2_DTEXP, F2_EMISSAO, F2_CLIENTE, F2_LOJA,F2_VALBRUT " + LF
		cQuery += " ,A1_NREDUZ, A2_NREDUZ, A2_CGC " + LF
		cQuery += " ,A4_COD, A4_NOME " + LF
	
		//cQuery += " , ZC1_NFSAID, ZC1_CONHEC " + LF
		cQuery += " , F8_NFDIFRE " + LF
		cQuery += " , F1_DOC,F1_SERIE, F1_VALBRUT,F1_VALMERC, F1_DTDIGIT, F1_FORNECE, F1_LOJA " + LF
		cQuery += " , F2_TRANSP , F2_EST, ZZ_DESC  "+ LF
		cQuery += " ORDER BY F2_TRANSP, F1_DOC, F1_SERIE  "+ LF
	
	//Else   // antes de 10/02/11
	/*
	
		cQuery := " select D2_TES, F2_DOC , F2_SERIE , F2_DTEXP, F2_EMISSAO, F2_CLIENTE, F2_LOJA,F2_VALBRUT " + LF
		cQuery += " ,A1_NREDUZ, A2_NREDUZ, A2_CGC " + LF
		cQuery += " ,A4_COD, A4_NOME " + LF
		cQuery += " , D1_NFFRET1 ,D1_SERFRE1  ,D1_NFFRET2, D1_SERFRE2, D1_NFFRET3, D1_SERFRE3 "+ LF
		cQuery += " , F1_VALBRUT, F1_VALMERC "+ LF
		cQuery += " , F1_DOC as CONHECTO, F1_SERIE AS SRCONHECI, F1_DTDIGIT, F1_FORNECE, F1_LOJA " + LF
		cQuery += " , F2_TRANSP,PESO=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 ELSE (D2_QUANT)*D2_PESO END) "+ LF
		cQuery += " FROM " + LF
		cQuery += " " + RetSqlName("SF1") + " SF1, " + LF
		cQuery += " " + RetSqlName("SF2") + " SF2, " + LF
		cQuery += " " + RetSqlName("SD2") + " SD2, " + LF
		cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
		cQuery += " " + RetSqlName("SA2") + " SA2, " + LF 
		cQuery += " " + RetSqlName("SA4") + " SA4, " + LF
		cQuery += " " + RetSqlName("SD1") + " SD1 " + LF
		cQuery += " WHERE  "+ LF
		
	    // REGIAO 
		If empty(MV_PAR15) // uf vazio
			If MV_PAR13=1 // imprime por regiao-Sim
				If MV_PAR12=1
				   cQuery += "F2_EST IN ('GO', 'MT', 'MS', 'DF') AND "+ LF // CENTRO-OESTE
				ElseIf MV_PAR12=2
				   cQuery += "F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') AND "+ LF // NORDESTE
				ElseIf MV_PAR12=3
				   cQuery += "F2_EST IN ('AC','AM','AP','PA','RO','RR','TO') and  "+ LF// norte 
				ElseIf MV_PAR12=4
				   cQuery += "F2_EST IN ('MG', 'ES', 'RJ', 'SP') AND "+ LF // SUDESTE
				ElseIf MV_PAR12=5
				   cQuery += "F2_EST IN ('RS', 'PR', 'SC') AND "+ LF // SUl 
				EndIf
			Endif
		Else
		    cQuery += "F2_EST IN ('"+UPPER(MV_PAR15)+"') AND "+ LF // uf 
		Endif
		// valor minimo
		If MV_PAR14=1 // sim 
			   cQuery += "F2_VALBRUT < 1000 AND "+ LF 
		EndIf		
		//

		cQuery += " (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE) AND "+ LF
		cQuery += " (F1_DOC + F1_SERIE ) = (D1_DOC + D1_SERIE) AND "+ LF
		
		cQuery += " (F2_DOC IN (D1_NFFRET1, D1_NFFRET2, D1_NFFRET3))  AND "+ LF
		cQuery += " F2_EMISSAO >= '" + DtoS(MV_PAR01) + "' AND F2_EMISSAO <= '" + DtoS(MV_PAR02) + "'  AND" + LF
		cQuery += " F2_DOC >= '" + Alltrim(MV_PAR03) + "' AND F2_DOC <= '" + Alltrim(MV_PAR04) + "'  AND" + LF
		
		//cQuery += " RTRIM(F2_SERIE) = '" + Alltrim(MV_PAR05) + "' AND"+ LF
		cQuery += " (F2_CLIENTE + F2_LOJA ) = (A1_COD + A1_LOJA) AND" + LF
		cQuery += " (F1_FORNECE + F1_LOJA ) = (A2_COD + A2_LOJA) AND" + LF
		cQuery += " (D1_FORNECE + D1_LOJA)  = (A2_COD + A2_LOJA) AND " + LF
		cQuery += " F2_TRANSP >= '" + Alltrim(MV_PAR05) + "' AND F2_TRANSP <= '" + Alltrim(MV_PAR06) + "' AND" + LF
		cQuery += " F2_TRANSP <> '024' AND" + LF 
		cQuery += " F2_TRANSP <> '025' AND" + LF  // cliente retira
		cQuery += " F2_TRANSP = A4_COD  AND" + LF
		cQuery += " A2_CGC = A4_CGC AND " + LF		
	
		If mv_par09 = 2    //exclui 6DD
			cQuery += " SF2.F2_SERIE <> '' AND " + LF
		Endif		
							
		If mv_par10 = 2   //EXCLUI BONIFICAÇÃO
			cQuery += " SD2.D2_TES NOT IN ('514','542','548','550') AND " + LF
		Endif
			
		If mv_par11 = 2    //EXCLUI AMOSTRA
			cQuery += " SD2.D2_TES NOT IN  ('516','507','543','547' ) AND " + LF
		Endif
		
		cQuery += " SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND SF1.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SA4.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' AND"+ LF
		cQuery += " SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = '' "+ LF
		
		cQuery += " GROUP BY D2_TES, F2_DOC , F2_SERIE , F2_DTEXP, F2_EMISSAO, F2_CLIENTE, F2_LOJA,F2_VALBRUT " + LF
		cQuery += " ,A1_NREDUZ, A2_NREDUZ, A2_CGC " + LF
		cQuery += " ,A4_COD, A4_NOME " + LF
		cQuery += " , D1_NFFRET1 ,D1_SERFRE1, D1_NFFRET2, D1_SERFRE2,  D1_NFFRET3, D1_SERFRE3 " + LF
		cQuery += " , F1_DOC,F1_SERIE, F1_VALBRUT,F1_VALMERC, F1_DTDIGIT, F1_FORNECE, F1_LOJA " + LF
		cQuery += " , F2_TRANSP , F2_EST, ZZ_DESC "+ LF
		cQuery += " ORDER BY F2_TRANSP, F1_DOC, F1_SERIE " + LF //, A2_NREDUZ  "+ LF
	*/
	Endif
	
Else		//nfs sem associação ao CTRC --> chamado 002034

	///cabeçalho também muda
	//Cabec1 := "NF SAÍDA/      DT.SAÍDA    CODIGO      NOME CLIENTE             VALOR NF    TIPO   PESO       LOCALIDADE                        UF    REGIAO"
	//Cabec2 := "SÉRIE                    CLIENTE/LJ                                                " 
	//Cabec3 := ""
    //         999999999      99/99/99   999999/99   XXXXXXXXXXXXXXXXXXXX  9,999,999.99    XXXXX
    //         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
    //         0         1         2         3         4         5         6         7         8         9        10        11        12        13

	
	//msgbox("ZC1")
	cQuery := " select D2_TES, F2_DOC , F2_SERIE , F2_DTEXP, F2_EMISSAO, F2_CLIENTE, F2_LOJA,F2_VALBRUT " + LF
	cQuery += " ,A1_NREDUZ " + LF
	cQuery += " ,A4_COD, A4_NOME " + LF
	cQuery += " , ZC1_NFSAID, ZC1_CONHEC " + LF
	cQuery += " , F2_TRANSP,PESO=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 ELSE (D2_QUANT)*D2_PESO END) "+ LF
	
	cQuery += " ,ZZ_DESC LOCALIDADE, F2_EST "+ LF
		
	cQuery += " ,CASE WHEN F2_EST IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'  "+ LF
	cQuery += "     ELSE CASE WHEN F2_EST  IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') THEN 'Nordeste'  "+ LF
	cQuery += "     ELSE CASE WHEN F2_EST  IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste'  "+ LF
	cQuery += "     ELSE CASE WHEN F2_EST IN ('MG', 'ES', 'RJ', 'SP') THEN 'Sudeste'  "+ LF
	cQuery += "     ELSE CASE WHEN F2_EST  IN ('RS', 'PR', 'SC') THEN 'Sul' ELSE '' END  END END END END REGIAO "+ LF
		
		
	cQuery += " FROM " + LF
	
	cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
	cQuery += " " + RetSqlName("SA4") + " SA4, " + LF
	cQuery += " " + RetSqlName("SZZ") + " SZZ, " + LF
	cQuery += " " + RetSqlName("SD2") + " SD2, " + LF
	cQuery += " " + RetSqlName("SF2") + " SF2 " + LF
		
	cQuery += " LEFT OUTER JOIN "
	cQuery += " " + RetSqlName("ZC1") + " ZC1 " + LF
	cQuery += " on SF2.F2_DOC IN (ZC1.ZC1_NFSAID) AND ZC1.ZC1_NFSAID IS NULL " + LF
    cQuery += " and ZC1.ZC1_FILIAL = '" + xFilial("ZC1") + "' AND ZC1.D_E_L_E_T_ = '' " + LF
	
	cQuery += " WHERE  "+ LF		
	
	    // REGIAO 
	    
		If empty(MV_PAR15) // uf vazio
			If MV_PAR13=1 // imprime por regiao-Sim
				If MV_PAR12=1
				   cQuery += "F2_EST IN ('GO', 'MT', 'MS', 'DF') AND "+ LF // CENTRO-OESTE
				ElseIf MV_PAR12=2
				   cQuery += "F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') AND "+ LF // NORDESTE
				ElseIf MV_PAR12=3
				   cQuery += "F2_EST IN ('AC','AM','AP','PA','RO','RR','TO') and  "+ LF// norte 
				ElseIf MV_PAR12=4
				   cQuery += "F2_EST IN ('MG', 'ES', 'RJ', 'SP') AND "+ LF // SUDESTE
				ElseIf MV_PAR12=5
				   cQuery += "F2_EST IN ('RS', 'PR', 'SC') AND "+ LF // SUl 
				EndIf
			Endif
		Else
		    cQuery += "F2_EST IN ('"+UPPER(MV_PAR15)+"') AND "+ LF // uf 
		Endif
		// valor minimo
		If MV_PAR14=1 // sim 
			   cQuery += "F2_VALBRUT < 1000 AND "+ LF 
		EndIf		
		//
		cQuery += " F2_LOCALIZ = ZZ_LOCAL AND " + LF
		cQuery += " F2_TRANSP = ZZ_TRANSP AND " + LF
		
	
	cQuery += " F2_EMISSAO >= '" + DtoS(MV_PAR01) + "' AND F2_EMISSAO <= '" + DtoS(MV_PAR02) + "'  AND" + LF
	cQuery += " F2_DOC >= '" + Alltrim(MV_PAR03) + "' AND F2_DOC <= '" + Alltrim(MV_PAR04) + "'  AND" + LF
		
	cQuery += " (F2_CLIENTE + F2_LOJA ) = (A1_COD + A1_LOJA) AND" + LF
	cQuery += " (F2_DOC + F2_SERIE ) = (D2_DOC + D2_SERIE ) AND" + LF
	
	cQuery += " F2_TRANSP >= '" + Alltrim(MV_PAR05) + "' AND F2_TRANSP <= '" + Alltrim(MV_PAR06) + "' AND" + LF
	cQuery += " F2_TRANSP <> '024' AND" + LF 
	cQuery += " F2_TRANSP <> '025' AND" + LF  // cliente retira
	cQuery += " F2_TRANSP = A4_COD  AND" + LF
	
	If mv_par09 = 2    //exclui 6DD
		cQuery += " SF2.F2_SERIE <> '' AND " + LF
	Endif		
							
	If mv_par10 = 2   //EXCLUI BONIFICAÇÃO
		cQuery += " SD2.D2_TES NOT IN ('514','542','548','550') AND " + LF
	Endif
			
	If mv_par11 = 2    //EXCLUI AMOSTRA
		cQuery += " SD2.D2_TES NOT IN  ('516','507','543','547' ) AND " + LF
	Endif
		
	cQuery += " SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' AND"+ LF
	cQuery += " SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' AND"+ LF
	cQuery += " SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' AND"+ LF
	cQuery += " SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SA4.D_E_L_E_T_ = '' "+ LF
		
	cQuery += " GROUP BY D2_TES, F2_DOC , F2_SERIE , F2_DTEXP, F2_EMISSAO, F2_CLIENTE, F2_LOJA,F2_VALBRUT " + LF
	cQuery += " ,A1_NREDUZ " + LF
	cQuery += " ,A4_COD, A4_NOME " + LF
	cQuery += " , ZC1_NFSAID, ZC1_CONHEC " + LF
	cQuery += " , F2_TRANSP , F2_EST, ZZ_DESC "+ LF
	cQuery += " ORDER BY F2_TRANSP, REGIAO, F2_DOC, F2_SERIE  "+ LF

Endif
MemoWrite("C:\Temp\FATR026.sql", cQuery)


If Select("FRET1") > 0
	DbSelectArea("FRET1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FRET1"
TCSetField( 'FRET1', "F1_DTDIGIT", "D" )
TCSetField( 'FRET1', "F1_EMISSAO", "D" )
TCSetField( 'FRET1', "F2_DTEXP", "D" )
TCSetField( 'FRET1', "F2_EMISSAO", "D" )


FRET1->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1


aResult 	:= {}

Do While !FRET1->( Eof() )
  
    
    
    cNomeTransp := FRET1->A4_NOME 
    cTransp		:= FRET1->F2_TRANSP
    
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
	//li++
	

	Do While !FRET1->( Eof() ) .and. Alltrim(FRET1->F2_TRANSP) == Alltrim(cTransp)
	
     If mv_par08 = 1
     
     	cTipoNf := ""
          			
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
				@ li,035 PSAY Transform(FRET1->F1_VALBRUT, "@E 9,999,999.99")			//VALOR FRETE
				li++
			Endif
		Endif
		
		//MARCAR AS NOTAS DE AMOSTRA E BONIFICAÇÃO
		//TES:
		/*
		516	AMOSTRA  GRATIS     
		507	AMOSTRA GRATIS      
		543	AMOSTRA GRATIS      
		547	AMOSTRA GRATIS SUFRA
		514	BONIFICACAO         
		542	BONIFICACAO         
		548	BONIFICACAO CF      
		550	BONIFICACAO SUFRAMA 
		*/
			
		If FRET1->D2_TES $ "516/507/543/547"
			cTipoNf := "AMOSTRA"
		Elseif FRET1->D2_TES $ "514/542/548/550"
			cTipoNf := "BONIFICAÇÃO"				
		Else
			cTipoNf := ""
		Endif
		
            
        li++
		@ li,000 PSAY FRET1->F2_DOC + ' / ' + FRET1->F2_SERIE                          				//NF SAÍDA/SERIE
		@ li,015 PSAY Dtoc(FRET1->F2_DTEXP)		Picture "@D"            	//DT.EXPEDIÇÃO
		@ li,026 PSAY FRET1->F2_CLIENTE + "/" + FRET1->F2_LOJA		Picture "@X"			//COD.CLIENTE / LOJA
		@ li,038 PSAY Substr(FRET1->A1_NREDUZ,1,20) Picture "@!"			//NOME CLIENTE
		@ li,060 PSAY FRET1->F2_VALBRUT Picture "@E 9,999,999.99"		//VALOR NF
			 	
		If Alltrim(FRET1->CONHECTO) != Alltrim(cConhecto)		 		
			@ li,074 PSAY Transform(FRET1->F1_VALBRUT, "@E 9,999,999.99")			//VALOR FRETE
			nToTransp  += FRET1->F1_VALBRUT //nValFrete
		Endif
		
		If FRET1->F1_VALBRUT < FRET1->F2_VALBRUT //SEMPRE FAZ O MENOR DIVIDIDO PELO MAIOR
			@ li,091 PSAY Transform( ( (FRET1->F1_VALBRUT / FRET1->F2_VALBRUT) * 100) , "@E 9999.99" )  + "%"
		Else 
			@ li,091 PSAY Transform( ( (FRET1->F2_VALBRUT / FRET1->F1_VALBRUT) * 100) , "@E 9999.99" )  + "%"
		Endif
		@ li,102 PSAY FRET1->CONHECTO //cConhecto Picture "@X"
		If !Empty(cTipoNf)
			@ li,112 PSAY Substr(cTipoNf,1,5)
		Elseif Alltrim(FRET1->F2_SERIE) = ''
			cTipoNf := "6DD"                 
			@ li,112 PSAY Substr(cTipoNf,1,5)
		Endif
				 	
        @ li,119 PSAY Round( FRET1->PESO, 2 )
		
		@ li,130 PSAY SUBSTR(FRET1->LOCALIDADE,1,30)
		@ li,167 PSAY FRET1->F2_EST
		@ li,170 PSAY FRET1->REGIAO
		
		nPeso+=Round( FRET1->PESO, 2 )
		
		nTotNF	  += FRET1->F2_VALBRUT
				 	
		cConhecto := FRET1->CONHECTO
		nValFrete := FRET1->F1_VALBRUT
		nCta++
				
			 		 			 			 	
		FRET1->(DBSKIP())         //AVANÇA PARA O PRÓXIMO REGISTRO 
		 	
	 	 
	 Else		//imprime notas sem associação com CTRC
	 	
	 	cTipoNf := ""
	 	If Li > 58
			Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
			li := 9
		Endif		
		
	    //MARCAR AS NOTAS DE AMOSTRA E BONIFICAÇÃO
		//TES:
		
		//516	AMOSTRA  GRATIS     
		//507	AMOSTRA GRATIS      
		//543	AMOSTRA GRATIS      
		//547	AMOSTRA GRATIS SUFRA
		//514	BONIFICACAO         
		//542	BONIFICACAO         
		//548	BONIFICACAO CF      
		//550	BONIFICACAO SUFRAMA 
		
					
		If FRET1->D2_TES $ "516/507/543/547"
			cTipoNf := "AMOSTRA"
		Elseif FRET1->D2_TES $ "514/542/548/550"
			cTipoNf := "BONIFICAÇÃO"
		Else
			cTipoNf := ""
		Endif
		
	    li++
		@ li,000 PSAY FRET1->F2_DOC + ' / ' + FRET1->F2_SERIE               //NF SAÍDA/SERIE
		@ li,015 PSAY Dtoc(FRET1->F2_DTEXP)		Picture "@D"            	//DT.EXPEDIÇÃO
		@ li,026 PSAY FRET1->F2_CLIENTE + "/" + FRET1->F2_LOJA		Picture "@X"			//COD.CLIENTE / LOJA
		@ li,038 PSAY Substr(FRET1->A1_NREDUZ,1,20) Picture "@!"			//NOME CLIENTE
		@ li,060 PSAY FRET1->F2_VALBRUT Picture "@E 9,999,999.99"		//VALOR NF		 
		If !Empty(cTipoNf)
			@ li,076 PSAY Substr(cTipoNf,1,5)
			
		Elseif Alltrim(FRET1->F2_SERIE) = ''
			cTipoNf := "6DD"                 
			@ li,076 PSAY Substr(cTipoNf,1,5)
		Endif	 
		 	
	    @ li,083 PSAY Round(FRET1->PESO,2)
	 	
	 	@ li,100 PSAY SUBSTR(FRET1->LOCALIDADE,1,30)
		@ li,130 PSAY FRET1->F2_EST
		@ li,134 PSAY FRET1->REGIAO
		
	 	nPeso+=Round( FRET1->PESO, 2 )
	 	
	 	nTotNF	  += FRET1->F2_VALBRUT	 		 			 
		 		 	
	 	FRET1->(DBSKIP())         //AVANÇA PARA O PRÓXIMO REGISTRO 
		 	
		 
	 	
	 	
	 	
	 Endif    //ENDIF DO MV_PAR08 = 1 / 2
	    	 	
	Enddo
	 
		 
	 ////rodapé de total por transportadora
	 li++
	 @li,000 PSAY Replicate("-",limite)
	 li++ 
	 @li,000 PSAY "Total da Transportadora: " + Substr(cNomeTransp,1,15)
	 @li,060 PSAY Transform(nToTNF   , "@E 9,999,999.99")
	 If mv_par08 = 1
		 @li,074 PSAY Transform(nToTransp, "@E 9,999,999.99")
		 @li,091 PSAY Transform( ((nToTransp / nTotNF) * 100) , "@E 9999.99") + "%"
		 @li,113 PSAY Transform(nPeso, "@E 9,999,999.99")
	 Else
	 	@li,077 PSAY Transform(nPeso, "@E 9,999,999.99")
	 Endif
	  
	  
	 li++
     @li,000 PSAY Replicate("=",limite)
	 li++ 
	 li++
	 li++
	 nTotGerNF += nTotNF
	 nTotGeral += nToTransp
	 nPesoT += nPeso
	 //nValFrete := 0
	 nTotNF    := 0
	 nToTransp := 0
	 nPeso:=0

Enddo 

///imprime o total geral
nLin++
@li,000 PSAY Replicate("*",limite)

li++
@li,012 PSAY "T O T A L   G E R A L  ==> "
@li,060 PSAY Transform(nTotGerNF, "@E 9,999,999.99")    //total geral do valor das nfs
If mv_par08 = 1
	@li,074 PSAY Transform(nTotGeral, "@E 9,999,999.99")   //total geral do valor de frete
	@li,091 PSAY Transform( ((nTotGeral / nTotGerNF) * 100) , "@E 9999.99") + "%"
	@li,113 PSAY Transform(nPesoT, "@E 9,999,999.99")   
Else
	@li,077 PSAY Transform(nPesoT, "@E 9,999,999.99")   
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
