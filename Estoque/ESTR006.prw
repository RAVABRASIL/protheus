#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Programa: ESTR006 - Relatório Metas de Consumo
//Data    : 09/04/2010
//Chamado : 001496 - item (2)
//Autoria : Flávia Rocha
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ESTR006()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Consumo de Materiais "
Local cPict          := ""
Local titulo         := "Consumo de Materiais - Por Tipo de Produto"
Local nLin           := 80
					   //         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160
				       //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

Local Cabec1         := " "
Local Cabec2         := " "
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130 //220
Private tamanho      := "M"
Private nomeprog     := "ESTR006" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ESTR006" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "ESTR06"

Private cString := ""
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if MV_PAR05=01  // ANALITICO 
   limite       := 220
   tamanho      := "G"
ENDIF
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF MV_PAR05=02 // SINTETICO
   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
ELSEIF MV_PAR05=01    
   RptStatus({|| RunReport1(Cabec1,Cabec2,Titulo,nLin) },Titulo)
ENDIF
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

////SINTÉTICO

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery 
Local LF 		:= CHR(13)+CHR(10) 
Local dData1	:= mv_par03
Local dData2	:= mv_par04
Local nPeriodo	:= 0 
Local aDados	:= {}
Local cTipo		:= ""
Local fr		:= 0
Local nEstq		:= 0
Local aEstq		:= {}

titulo         := "Consumo de Materiais - Por Tipo de Produto - Sintético - Periodo: " + Dtoc(dData1) + " a " + Dtoc(dData2) + ""
Cabec1         := "Tipo     Descrição                        Meta Consumo/Periodo       Consumo Real     Meta Estoque        Estoque Real "
Cabec2         := "                                               R$                          R$              R$                   R$     "

nPeriodo := (dData2 - dData1) 
If nPeriodo = 0
nPeriodo := 1
Endif

nPeriodo := Round( (nPeriodo / 30),2)

If nPeriodo <1 // QUANDO O PERIODO FOR MENOR QUE UM MES 
nPeriodo := 1
Endif


/*
////////////////////////////
// mv_par01 - Tipo de
// mv_par02 - Tipo até
// mv_par03 - Período de
// mv_par04 - Período até
// MV_PAR05 - Tipo de Relatorio (Sintetico ou Analitico)
// MV_PAR06 - Considera s/ Estoque ? (Sim/Não)
// MV_PAR07 - Considera s/ Consumo ? (Sim/Nao)
// MV_PAR08 - Considera Genericos ? (Sim/Nao)
////////////////////////////
*/


cQuery := " SELECT B1_COD AS PRODUTO , B1_TIPO AS TIPO, B1_ATIVO " + LF
cQuery += " ,(SELECT TOP 1 Round(D1_VUNIT,2) FROM "+RetSqlName("SD1")+" SD1 WHERE RTRIM(SD1.D1_COD) = RTRIM(SB1.B1_COD) AND RTRIM(SD1.D1_UM) = RTRIM(SB1.B1_UM) AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '' ORDER BY D1_DTDIGIT DESC) AS ULTPRECO "+LF
cQuery += " ,Round(SUM(ISNULL(D3_QUANT,0)/ " + Alltrim(Str(nPeriodo)) + "),2) AS CONSUMO_REAL "+LF
cQuery += " ,LEFT(D3_EMISSAO,6) AS EMISSAO " + LF
cQuery += " ,ISNULL(ZB2_META,0) AS META_CONSUMO ,ISNULL(ZB2_ANOMES,'') AS ANOMES, ISNULL(ZB2_METAES,0) AS META_ESTOQUE " + LF
cQuery += " FROM " +LF
cQuery += " " + RetSqlName("SB1") + " SB1 "+LF
cQuery += " LEFT JOIN SD3020 SD3 ON RTRIM(B1_COD) = RTRIM(D3_COD) AND RTRIM(B1_UM) = RTRIM(D3_UM) AND D3_TM >= '500' AND SD3.D_E_L_E_T_ = '' "+LF
cQuery += " AND D3_EMISSAO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' " +LF
cQuery += " LEFT JOIN ZB2020 ZB2 ON RTRIM(B1_TIPO) = RTRIM(ZB2_TIPO) AND RTRIM(ZB2_ANOMES) >= '" + Alltrim(Substr(Dtos(mv_par03),1,6)) + "' "+LF
cQuery += " AND RTRIM(ZB2_ANOMES) <= '" + Alltrim(Substr(Dtos(mv_par04),1,6)) + "'  AND  ZB2.D_E_L_E_T_ = '' " + LF

cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' '  AND B1_ATIVO <> 'N' " + LF
cQuery += " AND RTRIM(B1_TIPO) >= '" +  Alltrim(mv_par01) + "' AND RTRIM(B1_TIPO) <= '" + Alltrim(mv_par02) + "' " + LF

//cQuery += " AND RTRIM(B1_COD) = 'MP0742' "+LF 

If mv_par08 = 2
	cQuery += " AND LEN(RTRIM(B1_COD)) <= 7 "
Endif
cQuery += " GROUP BY B1_COD, B1_TIPO, B1_ATIVO, LEFT(D3_EMISSAO,6), ZB2_META, ZB2_ANOMES, ZB2_METAES, B1_UM " + LF
cQuery += " ORDER BY B1_TIPO, ZB2_ANOMES, B1_COD "+LF

//MemoWrite("C:\ESTR006.SQL",cQuery)
If Select("EST06") > 0
DbSelectArea("EST06")
DbCloseArea()
EndIf

TcQuery cQuery NEW ALIAS "EST06"
//TCSetField( 'EST06', "D3_EMISSAO", "D" )

SetRegua(0)


EST06->( DBGoTop() )
While EST06->(!EOF())

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
      
    cTipo 		:= EST06->TIPO    
    cAnoMes 	:= EST06->ANOMES
    nMetaestoq	:= EST06->META_ESTOQUE
   	nMetaconsumo:= EST06->META_CONSUMO
    cDescTipo	:= ""    
    nValconsumo := 0
    nEstqReal	:= 0
    nEstq		:= 0
    
    Do While Alltrim(EST06->TIPO) == Alltrim(cTipo) .and. Alltrim(EST06->ANOMES) == Alltrim(cAnoMes)
    
    	cProduto	:= EST06->PRODUTO     	
    	nQTconsumo	:= EST06->CONSUMO_REAL
    	nValcompra	:= EST06->ULTPRECO
    	
    
		////estoque do tipo
		nEstq := 0
		aEstq := {}
		
		aEstq := CalcEst( cProduto, "01", MV_PAR04 )
		nEstq := aEstq[1]		
		nEstqReal += Round(nEstq * nValcompra,2)
		nValconsumo += Round( nQTconsumo * nValcompra , 2 )		
					
		
	    Dbselectarea("EST06")
	    EST06->(Dbskip())
	    incregua()
    Enddo
    	
    ///////////////////////////		
    Dbselectarea("SX5")
    SX5->(Dbsetorder(1))
    If SX5->(Dbseek(xFilial("SX5") + '02' + cTipo )) 
	   cDescTipo := Alltrim(SX5->X5_DESCRI)
    Endif

    
	    Aadd (aDados, {cTipo, cDescTipo, nMetaconsumo, cAnoMes , nValconsumo, nMetaestoq, nEstqReal  } )      
	    //				Tipo, Descrição, Meta consumo, Per.Meta, Consumo real, Meta Estoq.,Estoq. Real 
	    //				1		2			3				4		5				6			7			
	    //////////////////////////// 
	
	   
Enddo
EST06->( dbCloseArea() )   	
   	

If Len(aDados) > 0

For fr := 1 to Len(aDados)

	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Verifica o cancelamento pelo usuario...                             ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	*/
	
	If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   	Endif
   	
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Impressao do cabecalho do relatorio. . .                            ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 8
      	nLin++
   	Endif
   	
   	   //Tipo     Descrição                        Meta Consumo/Periodo     Consumo Real     Meta Estoque        Estoque Real "
	   //                                               R$                        R$              R$                   R$     "
   	   //         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160
       //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789   	
           //XX     XXXXXXXXXXXXXXXXXXXXXXXXX          999,999,999.99 99/9999     999,999,999.99    999,999,999.99    999,999,999.99
   	@nLin,000 PSAY aDados[fr][1] PICTURE "@!"
   	@nLin,007 PSAY 	Substr(aDados[fr][2],1,25) PICTURE "@!"
   	@nLin,042 PSAY TRANSFORM(aDados[fr][3],"@E 999,999,999.99")
	@nLin,058 PSAY SUBSTR(aDados[fr][4],5,2) +"/" + SUBSTR(aDados[fr][4],1,4)
	@nLin,069 PSAY TRANSFORM(aDados[fr][5],"@E 999,999,999.99")
	@nLin,087 PSAY TRANSFORM(aDados[fr][6],"@E 999,999,999.99")
	@nLin,105 PSAY TRANSFORM(aDados[fr][7],"@E 999,999,999.99")
	      
   
    nLin++ // Avanca a linha de impressao
    incRegua()
   
Next

Endif
Roda( 0, "", TAMANHO )


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

Return


Static Function RunReport1(Cabec1,Cabec2,Titulo,nLin)

local cQry:=''
Local dData1	:= mv_par03
Local dData2	:= mv_par04
Local nPeriodo	:= 0 
Local aDados	:= {}
Local cTipo		:= ""
Local fr		:= 0
Local nEstq		:= 0
Local aEstq		:= {}

titulo         := "Consumo de Materiais - Por Tipo de Produto - Analítico - Período: " + Dtoc(dData1) + " a " + Dtoc(dData2) + ""
Cabec1         := "Produto           Descrição                                            Meta Consumo       Consumo Real     Meta Estoque      Estoque Real "
Cabec2         := "                                                                           R$                   R$              R$                R$     "

nPeriodo := (dData2 - dData1) 
If nPeriodo = 0
nPeriodo := 1
Endif

nPeriodo := Round( (nPeriodo / 30),2)

If nPeriodo <1 // QUANDO O PERIODO FOR MENOR QUE UM MES 
nPeriodo := 1
Endif

/*
////////////////////////////
// mv_par01 - Tipo de
// mv_par02 - Tipo até
// mv_par03 - Período de
// mv_par04 - Período até
// MV_PAR05 - Tipo de Relatorio (Sintetico ou Analitico)
// MV_PAR06 - Considera s/ Estoque ? (Sim/Não)
// MV_PAR07 - Considera s/ Consumo ? (Sim/Nao)
// MV_PAR08 - Considera Genericos ? (Sim/Nao)
////////////////////////////
*/

cQry:="SELECT B1_COD AS PRODUTO ,B1_DESC ,B1_TIPO AS TIPO "
cQry+=",(SELECT TOP 1 Round(D1_VUNIT,2) FROM "+RetSqlName("SD1")+" SD1  "
cQry+="WHERE RTRIM(SD1.D1_COD) = RTRIM(SB1.B1_COD) AND RTRIM(SD1.D1_UM) = RTRIM(SB1.B1_UM)  "
cQry+="AND SD1.D1_TIPO = 'N' AND SD1.D_E_L_E_T_ = '' ORDER BY D1_DTDIGIT DESC) AS ULTPRECO "
cQry+=",Round(SUM(ISNULL(D3_QUANT,0)/ " + Alltrim(Str(nPeriodo)) + "),2) AS CONSUMO_REAL  "
cQry+="FROM "
cQry+=" " + RetSqlName("SB1") + " SB1  " 
cQry+="LEFT JOIN SD3020 SD3 ON RTRIM(B1_COD) = RTRIM(D3_COD) AND RTRIM(B1_UM) = RTRIM(D3_UM) AND D3_TM >= '500' AND SD3.D_E_L_E_T_ = ''  "
cQry+="AND D3_EMISSAO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' "
cQry+="WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
cQry+="AND SB1.D_E_L_E_T_ = ' ' " 
cQry+="AND B1_ATIVO <> 'N' "
cQry+="AND RTRIM(B1_TIPO) >= '" +  Alltrim(mv_par01) + "' AND RTRIM(B1_TIPO) <= '" +  Alltrim(mv_par02) + "'  "

If mv_par08 = 2    ///(1-Sim / 2-Nao)
	cQry += " AND LEN(RTRIM(B1_COD)) <= 7 "
Endif

cQry+="GROUP BY B1_TIPO,B1_COD,B1_UM,B1_DESC "
cQry+="ORDER BY B1_TIPO, B1_COD " 
TcQuery cQry NEW ALIAS "_TMPZ"

SetRegua(0)
_TMPZ->( DBGoTop() )
Do While _TMPZ->(!EOF())
   	
   	If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   	Endif
   	
   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 9
   	Endif
  
  cTipo:=_TMPZ->TIPO
  nValconsumo := 0
  nEstqReal	:= 0
  nEstq		:= 0
  nMetaCon:=0
  nMetaEst:=0
  @nLin++,00 PSAY  " Tipo: "+_TMPZ->TIPO +' - '+ALLTRIM(Posicione('SX5',1,xFilial("SX5") + '02' +_TMPZ->TIPO ,"X5_DESCRI") )
  Do While _TMPZ->(!EOF()) .AND. _TMPZ->TIPO=cTipo
     
     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 9
   	 Endif
     
     cProd:=_TMPZ->PRODUTO
     nQTconsumo	:= _TMPZ->CONSUMO_REAL
     nValcompra	:=  _TMPZ->ULTPRECO
     Do While _TMPZ->(!EOF()) .AND. _TMPZ->TIPO=cTipo .AND. _TMPZ->PRODUTO=cProd

   	    If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	  nLin := 9
   	    Endif
   	    
   	    
   	    aEstq := CalcEst( cProd, "01", MV_PAR04 )
	    nEstq := aEstq[1]		
	    nEstqReal += Round(nEstq * nValcompra,2)
	    nValconsumo += Round( nQTconsumo * nValcompra , 2 )		
	    nMetaCon+=META(_TMPZ->TIPO)[1][1]
   	    nMetaEst+=META(_TMPZ->TIPO)[1][2]
   	    
   	    If mv_par06 = 1 .and. mv_par07 = 1  	     
		   	    //Codigo     Descrição                        Meta Consumo     Consumo Real     Meta Estoque        Estoque Real "
		        @nLin,00 PSAY  _TMPZ->PRODUTO 
		        @nLin,17 PSAY  _TMPZ->B1_DESC 
		        @nLin,67 PSAY  TRANSFORM(META(_TMPZ->TIPO)[1][1],"@E 999,999,999.99")              	//meta consumo
		        @nLin,83 PSAY  TRANSFORM(Round( nQTconsumo * nValcompra , 2 ),"@E 999,999,999.99") 	//consumo real
		        @nLin,99 PSAY  TRANSFORM(META(_TMPZ->TIPO)[1][2],"@E 999,999,999.99")             	//meta estoque
		        @nLin++,115 PSAY  TRANSFORM(Round(nEstq * nValcompra,2),"@E 999,999,999.99")      	//estoque real
		        
		        //nEstqReal += Round(nEstq * nValcompra,2)
	    		//nValconsumo += Round( nQTconsumo * nValcompra , 2 )		
		
		Elseif (mv_par06 = 2 .and. nEstq > 0 ) .Or. (mv_par07 = 2 .and. nQTconsumo > 0) 
		
			//Codigo     Descrição                        Meta Consumo     Consumo Real     Meta Estoque        Estoque Real "
		        @nLin,00 PSAY  _TMPZ->PRODUTO 
		        @nLin,17 PSAY  _TMPZ->B1_DESC 
		        @nLin,67 PSAY  TRANSFORM(META(_TMPZ->TIPO)[1][1],"@E 999,999,999.99")              	//meta consumo
		        @nLin,83 PSAY  TRANSFORM(Round( nQTconsumo * nValcompra , 2 ),"@E 999,999,999.99") 	//consumo real
		        @nLin,99 PSAY  TRANSFORM(META(_TMPZ->TIPO)[1][2],"@E 999,999,999.99")             	//meta estoque
		        @nLin++,115 PSAY  TRANSFORM(Round(nEstq * nValcompra,2),"@E 999,999,999.99")      	//estoque real
		        
	    Endif
	    
      INCREGUA()
     _TMPZ->(dbskip())
     Enddo  
  Enddo
 @nLin++,00 PSAY replicate("-",129)
 @nLin,67 PSAY  TRANSFORM(nMetaCon,"@E 999,999,999.99")
 @nLin,83 PSAY  TRANSFORM(nValconsumo,"@E 999,999,999.99")
 @nLin,99 PSAY  TRANSFORM(nMetaEst,"@E 999,999,999.99")
 @nLin++,115 PSAY  TRANSFORM(nEstqReal,"@E 999,999,999.99")

Enddo
DbSelectArea("_TMPZ")
DbCloseArea()




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

Return


***************

Static Function META(cTipo)

***************
 
Local cQry   := ''
Local aRet     := {}

cQry:="SELECT ISNULL(SUM(ZB2_META),0) AS META_CONSUMO,ISNULL(SUM(ZB2_METAES),0) AS META_ESTOQUE  "
cQry+="FROM  ZB2020 ZB2 "
cQry+="WHERE " 
cQry+="RTRIM(ZB2_TIPO) = '" +alltrim(cTipo) + "' "
cQry+="AND RTRIM(ZB2_ANOMES) >= '" + Alltrim(Substr(Dtos(mv_par03),1,6)) + "'  "
cQry+="AND RTRIM(ZB2_ANOMES) <= '" + Alltrim(Substr(Dtos(mv_par04),1,6)) + "' "
cQry+="AND  ZB2.D_E_L_E_T_ = '' " 


TCQUERY cQry NEW ALIAS 'AUUX'
AUUX->(DBGOTOP())


do While AUUX->( !EoF() )
	aAdd( aRet, {AUUX->META_CONSUMO,AUUX->META_ESTOQUE  } )
	AUUX->( dbSkip() )
endDo
AUUX->( dbCloseArea() )



Return aRet

