#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATR042  º Autor ³ Flávia Rocha       º Data ³  21/02/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Fretes x Faturamento                          º±±
±±º          ³ Por: Localidade / Região / UF                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamado: 00000618 - Depto. Logistica                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR042


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "FRETES x FATURAMENTO - POR LOCALIDADE/REGIAO/UF"
Local cPict          := ""
Local nLin         := 80
Local Cabec1       := ""

//Local Cabec2       := "Localidade                      UF   Regiao        Fat.KG      Qt.Volumes        Fat. R$"
//Local Cabec2       := "Localidade                      UF   Regiao          Fat.KG        Fat.R$         Vlr.Frete      %Frete sob Fat.R$    Vl.Frete c/ Icms     NF/SERIE"
Local Cabec2       := "Localidade                      UF   Regiao          Fat.KG       Vlr.Frete c/ Icms    %Frete sob Fat.KG        NF/SERIE"
                      
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132 //220  
Private tamanho          := "M" //"G"  
Private nomeprog         := "FATR042" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "FATR042"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FATR042" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SF2"
Private titulo       := ""

dbSelectArea("SF2")
dbSetOrder(1)


pergunte(cPerg,.T.)

If !Empty(MV_PAR01)
	Cabec1 += " Periodo a partir de: " + DtoC(MV_PAR01) 
Endif

If !Empty(MV_PAR02)
	Cabec1 += " ate: " + DtoC(MV_PAR02) 
Endif
titulo       := "FRETE x FATURAMENTO"
If MV_PAR03 = 1 //POR 1-REGIAO / 2-UF / 3-LOCALIDADE / 4-GERAL
	If !Empty(MV_PAR04)
		Cabec1 += " - Por Regiao: "
		titulo += " - Por Regiao"
		If MV_PAR04 = '000001'    //nordeste
			Cabec1 += "NORDESTE " 
			titulo       += " - POR REGIÃO: NORDESTE"             
		Elseif MV_PAR04 = '000002' //sudeste
			Cabec1 += "SUDESTE"
			titulo       += " - POR REGIÃO: SUDESTE"             
		Elseif MV_PAR04 = '000003' // centro-oeste
			Cabec1 += "CENTRO-OESTE"       
			titulo       += " - POR REGIÃO: CENTRO-OESTE"             
		Elseif MV_PAR04 = '000004' // norte
			Cabec1 += "NORTE"              
			titulo       += " - POR REGIÃO: NORTE"             
		Elseif MV_PAR04 = '000005' // sul
			Cabec1 += "SUL"
			titulo       += " - POR REGIÃO: SUL"             
		Endif 
		
	Endif 
Elseif MV_PAR03 = 2
	Cabec1 += " - Por: UF "
	titulo       += " - POR: UF"             
Elseif MV_PAR03 = 3
	Cabec1 += " - Por: LOCALIDADE "
	titulo       += " - POR: LOCALIDADE"             
Endif

//titulo += " - Periodo: " + Dtoc(MV_PAR01) + " a " + Dtoc(MV_PAR02)

If SM0->M0_CODFIL = '03'
  //Cabec2       := "Localidade                      UF   Regiao        Fat.QTD     Qt.Volumes        Fat. R$"
  //	Cabec2       := "Localidade                      UF   Regiao           Fat.QTD       Fat.R$       Vlr.Frete      %Frete sob Fat.R$    Vl.Frete c/ Icms     NF/SERIE"
  	Cabec2       := "Localidade                      UF   Regiao           Fat.QTD     Vlr.Frete c/ Icms   %Frete sob Fat.QTD       NF/SERIE"
Endif
//Cabec1 += CHR(13) + CHR(10)
/*
PARÂMETROS:
MV_PAR01 - EMISSAO NF DE
MV_PAR02 - EMISSAO NF ATE
MV_PAR03 - IMPRIME POR: REGIAO / UF / LOCALIDADE
MV_PAR04 - REGIAO
MV_PAR05 - UF DE
MV_PAR06 - UF ATÉ  

*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery 	:= ""
Local LF     	:= CHR(13) + CHR(10) 
Local nTotRegs	:= 0 
//subbotais:
Local nTotKG    := 0   
Local nTotRS    := 0
Local nTotVol   := 0
//total geral
Local nTOTGERKG := 0
Local nTOTGERRS := 0
Local nTOTGERVOL:= 0
Local cLocal    := ""
Local aFret     := {}
Local nTotFre   := 0
Local nTotFreic := 0
Local nTotGFre   := 0
Local nTotGFreic := 0
Local nPerFret   := 0          
Local nFatKG     := 0 
Local nFatRS     := 0
Local nFrete     := 0
Local nFreteI    := 0

cQuery := " SELECT " + LF 
cQuery += " F2_DOC, F2_SERIE , " + LF
//cQuery += " F2_TRANSP, F2_LOCALIZ " + LF
//SE EMITIDO NA RAVA/EMB:
If SM0->M0_CODFIL $ '0107'
	If MV_PAR07 = 1 //COM XDD
		cQuery += " FAT_KG = SUM( D2_QUANT  * D2_PESO ) " + LF		
	Else
		cQuery += " FAT_KG = SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0   " + LF
		cQuery += " ELSE D2_QUANT  * D2_PESO END) " + LF		
	Endif
Elseif SM0->M0_CODFIL = '03'
	If MV_PAR07 = 1 //COM XDD
		cQuery += " FAT_KG = SUM( D2_QUANT ) " + LF
	Else                                      
		cQuery += " FAT_KG = SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0   " + LF
		cQuery += " ELSE D2_QUANT  END) " + LF
	Endif
Endif

cQuery += " ,FAT_RS=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0   " + LF
cQuery += " ELSE D2_TOTAL END) " + LF

//If MV_PAR03 = 3
	cQuery += " ,SZZ.ZZ_DESC LOCALI " + LF     
	cQuery += " , SF2.F2_LOCALIZ CODLOCAL " + LF
//Endif

cQuery += " ,SF2.F2_EST UF " + LF
cQuery += " ,REGIAO = (case when SF2.F2_EST IN ('AC', 'AM', 'AP', 'PA', 'RO', 'RR', 'TO') THEN 'NORTE' " + LF
cQuery += "            ELSE CASE WHEN SF2.F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA' , 'SE') THEN 'NORDESTE' " + LF
cQuery += "            ELSE CASE WHEN SF2.F2_EST IN ('GO', 'MT', 'MS' , 'DF') THEN 'CENTRO-OESTE' " + LF
cQuery += "            ELSE CASE WHEN SF2.F2_EST IN ('MG', 'ES', 'RJ', 'SP') THEN 'SUDESTE' " + LF
cQuery += "            ELSE 'SUL' END END END END) " + LF
                                                         
cQuery += " ,Qt_Volumes=SUM(F2_VOLUME1) " + LF 
///em caso de querer saber o valor devolvido, ativar estas 2 linhas
cQuery += " --,DEV_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0   " + LF
cQuery += " --ELSE D2_QTDEDEV * D2_PESO END),  " + LF   

///em caso de querer saber o valor devolvido, ativar esta linha
cQuery += " --,DEV_RS=SUM( D2_QTDEDEV * D2_PRCVEN)  " + LF

cQuery += " FROM "
cQuery += " " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + LF
cQuery += "," + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + LF
cQuery += "," + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + LF
cQuery += "," + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + LF
cQuery += "," + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + LF
cQuery += "," + RetSqlName("SF4") + " SF4 WITH (NOLOCK) " + LF
cQuery += "," + RetSqlName("SZZ") + " SZZ WITH (NOLOCK) " + LF
cQuery += "," + RetSqlName("SA4") + " SA4 WITH (NOLOCK) " + LF

cQuery += " WHERE  " + LF

cQuery += " SF2.F2_FILIAL = '" + xFilial("SF2") + "' " + LF
cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL  " + LF
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC " + LF
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE " + LF
cQuery += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE " + LF
cQuery += " AND SD2.D2_LOJA = SF2.F2_LOJA    " + LF
cQuery += " AND SA3.A3_COD = SF2.F2_VEND1   " + LF

cQuery += " AND SD2.D2_COD = SB1.B1_COD   " + LF

//cQuery += " AND SF2.F2_FILIAL = SZZ.ZZ_FILIAL " + LF
cQuery += " AND SF2.F2_LOCALIZ = SZZ.ZZ_LOCAL " + LF
cQuery += " AND SF2.F2_TRANSP  = SZZ.ZZ_TRANSP " + LF 

cQuery += " AND SF2.F2_TRANSP  = SA4.A4_COD " + LF

cQuery += " and SD2.D2_TES = SF4.F4_CODIGO  " + LF

cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD " + LF
cQuery += " AND SF2.F2_LOJA = SA1.A1_LOJA  " + LF
cQuery += " AND SF2.F2_TPFRETE = 'C' " + LF //só vai mostrar quando for Cif, pois Fob é o cliente que paga
cQuery += " AND SF2.F2_TRANSP  <> '024' " + LF

/*
SELEÇÃO DOS PARÂMETROS:
MV_PAR01 - EMISSAO NF DE
MV_PAR02 - EMISSAO NF ATE
MV_PAR03 - EXPEDICAO NF DE
MV_PAR04 - EXPEDICAO NF ATE
MV_PAR05 - LOCALIDADE DE
MV_PAR06 - LOCALIDADE ATE
MV_PAR07 - UF DE
MV_PAR08 - UF ATE
MV_PAR09 - REGIAO  -> 1-Nordeste , 2-Sudeste, 3-Centro-Oeste, 4-Norte, 5-Sul

*/
//emissao de / até
If !Empty(MV_PAR02)                                              
	cQuery += " and F2_EMISSAO >= '" + Dtos(MV_PAR01) + "' " + LF
	cQuery += " and F2_EMISSAO <= '" + Dtos(MV_PAR02) + "'  " + LF
Endif


If MV_PAR03 = 1	//região

	If MV_PAR04 = '000001'    //nordeste
		cQuery += " and F2_EST in ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA' , 'SE') " + LF
	Elseif MV_PAR04 = '000002' //sudeste
		cQuery += " and F2_EST in ('MG', 'ES', 'RJ', 'SP') "  + LF
	Elseif MV_PAR04 = '000003' // centro-oeste
		cQuery += " and F2_EST in ('GO', 'MT', 'MS' , 'DF') " + LF
	Elseif MV_PAR04 = '000004' // norte
		cQuery += " and F2_EST in ('AC', 'AM', 'AP', 'PA', 'RO', 'RR', 'TO') " + LF
	Elseif MV_PAR04 = '000005' // sul
		cQuery += " and F2_EST in ('RS', 'SC' , 'PR' ) " + LF
	Endif

ElseIf MV_PAR03 = 2 //POR UF 
		//uf de / até
	If !Empty(MV_PAR06)                                             
		cQuery += " and F2_EST >= '" + Alltrim(MV_PAR05) + "' " + LF
		cQuery += " and F2_EST <= '" + Alltrim(MV_PAR06) + "'  " + LF
	Endif
/*
Elseif MV_PAR03 = 3 // POR LOCALIDADE
	If !Empty(MV_PAR05)
		cQuery += " and F2_LOCALIZ >= '" + Alltrim(MV_PAR05) + "' " + LF
	Endif
	
	If !Empty(MV_PAR06)
		cQuery += " and F2_LOCALIZ <= '" + Alltrim(MV_PAR06) + "'  " + LF
	Endif
*/
Endif

cQuery += " AND F2_DUPL <> ' '  " + LF
If SM0->M0_CODFIL = '03'                    //se filial Caixas, filtra o setor do B1 = 39 (Caixas)
	cQuery += " AND B1_SETOR = '39'  " + LF   
ElseIf SM0->M0_CODFIL $ '0107'
	cQuery += " AND B1_SETOR <> '39'  " + LF   //DIFERENTE DE CAIXAS
Endif
cQuery += " AND B1_TIPO != 'AP'  " + LF  //EXCLUI APARAS
cQuery += " AND D2_TIPO = 'N'   " + LF
cQuery += " and F2_TIPO = 'N' " + LF
cQuery += " AND D2_TP != 'AP'  " + LF
cQuery += " AND B1_TIPO != 'AP'   " + LF

cQuery += " AND F4_TEXTO LIKE  '%VENDA%'   " + LF
cQuery += " AND F4_DUPLIC = 'S' " + LF   //QUE GERE DUPLICATA
cQuery += " AND SD2.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SF2.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SZZ.D_E_L_E_T_='' " + LF

//ORDER BY:
If MV_PAR03 = 1    //REGIÃO
	cQuery += " GROUP BY SF2.F2_EST, SF2.F2_LOCALIZ,SZZ.ZZ_DESC, SF2.F2_DOC, SF2.F2_SERIE " + LF
	cQuery += " ORDER BY REGIAO, FAT_KG DESC, SZZ.ZZ_DESC, SF2.F2_DOC, SF2.F2_SERIE  " + LF
Elseif MV_PAR03 = 2        //UF
	cQuery += " GROUP BY SF2.F2_EST, SF2.F2_LOCALIZ,SZZ.ZZ_DESC, SF2.F2_DOC, SF2.F2_SERIE" + LF
	cQuery += " ORDER BY SF2.F2_EST, FAT_KG DESC, SZZ.ZZ_DESC, SF2.F2_DOC, SF2.F2_SERIE " + LF
Elseif MV_PAR03 = 3 //LOCALIDADE
	cQuery += " GROUP BY SF2.F2_LOCALIZ, SF2.F2_EST, SZZ.ZZ_DESC , SF2.F2_DOC, SF2.F2_SERIE" + LF                                    
	cQuery += " ORDER BY FAT_KG DESC, SZZ.ZZ_DESC, SF2.F2_DOC, SF2.F2_SERIE " + LF	
Else //GERAL                                                                                                                         
	cQuery += " GROUP BY SF2.F2_LOCALIZ, SF2.F2_EST, SZZ.ZZ_DESC , SF2.F2_DOC, SF2.F2_SERIE" + LF                                    
	cQuery += " ORDER BY FAT_KG DESC " + LF
Endif

MEMOWrite("C:\TEMP\FATR042.SQL", cQuery )
If Select("TEMP1") > 0
	DbSelectArea("TEMP1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TEMP1"
//TCSetField( "REP", "C5_EMISSAO", "D")
If !TEMP1->(EOF())
	TEMP1->( DbGoTop() )
	
	While TEMP1->( !EOF() )
		nTotRegs++
		TEMP1->(DBSKIP())
	Enddo

	SetRegua( nTotRegs)

	TEMP1->( DbGoTop() )
	While TEMP1->( !EOF() )
	
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 9
	   Endif 
	   cLaco := ""
	   cWhile:= ""
	   If MV_PAR03 = 1
	   		cLaco := TEMP1->REGIAO
	   		cWhile:= ' !TEMP1->(EOF()) .and. Alltrim(TEMP1->REGIAO) = Alltrim(cLaco)'
	   Elseif MV_PAR03 = 2
	   		cLaco := TEMP1->UF 
	   		cWhile:= ' !TEMP1->(EOF()) .and. Alltrim(TEMP1->UF) = Alltrim(cLaco)'
	   Elseif MV_PAR03 = 3
	   		cLaco := TEMP1->CODLOCAL //LOCALI
	   		cWhile:= ' !TEMP1->(EOF()) .and. Alltrim(TEMP1->CODLOCAL) = Alltrim(cLaco)'
	   Else
	   		cLaco := ""
	   		cWhile:= ' !TEMP1->(EOF())'
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Verifica o cancelamento pelo usuario...                             ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   //cWhile += cLaco
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Impressao do cabecalho do relatorio. . .                            ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   
	   //If MV_PAR03 = 1 
	   //		@nLin,000 PSAY Alltrim(cLaco) + ":"	   	
	   //Endif
	   
	   If MV_PAR03 = 1 .or. MV_PAR03 = 2		
	   		@nLin,000 PSAY Alltrim(cLaco) + ":"
	   		nLin++
	   		nLin++
	   //Elseif MV_PAR03 = 3
	   //		@nLin,000 PSAY TEMP1->LOCALI + ":"
	   //		nLin++
	   //		nLin++
	   Endif
	   While  &cWhile //!TEMP1->(EOF()) .and. Alltrim(TEMP1->UF) == Alltrim(cLocal) 
		  //variáveis para cálculo do valor do frete 
		  nAd_valoren := 0
          nFret_pes   := 0
          nTaxaFixa   := 0
          nADM		  := 0
          nPedagio	  := 0
          nSuframa	  := 0 
          nFretIcms	  := 0
          nFrete	  := 0
          nGRIS		  := 0
          nTDE		  := 0 
          
          //Aadd(aFrete, { nFretpeso, nFretIcms} )          
          aFret := fTrazFrete(TEMP1->F2_DOC, TEMP1->F2_SERIE)
          nFret_pes := Round(aFret[1,1],2)
          nFretIcms := Round(aFret[1,2],2)
          
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 9
		   Endif
		   cLocali := ""
		   If MV_PAR03 = 3
		   	cLocali := Substr(TEMP1->LOCALI,1,30)
		   Endif
		   cUF     := TEMP1->UF
		   cRegiao := TEMP1->REGIAO
		   //nFatKG  += TEMP1->FAT_KG
		   //nFatRS  += TEMP1->FAT_RS
		   nFrete  += nFret_pes
		   nFreteI += nFretIcms
		   
		   @nLin, 000 PSAY Substr(TEMP1->LOCALI,1,30)
		   @nLin, 032 PSAY TEMP1->UF
		   @nLin, 035 PSAY TEMP1->REGIAO
		   @nLin, 049 PSAY TEMP1->FAT_KG  Picture "@E 99,999,999.99"

		   //@nLin, 064 PSAY TEMP1->FAT_RS  Picture "@E 999,999,999.99"
		   //@nLin, 083 PSAY nFret_pes Picture "@E 999,999.99" //valor frete              
		   @nLin,064 PSAY nFretIcms Picture "@E 999,999.99" //valor frete icms
		   //nPerFret := ( nFret_pes / TEMP1->FAT_RS ) * 100 
		   nPerFret := ( nFretIcms / TEMP1->FAT_KG ) * 100 
		   @nLin,086 PSAY nPerFret Picture "@E 999.99" //percentual frete sobre faturado
		   //@nLin,115 PSAY nFretIcms Picture "@E 999,999.99" //valor frete icms
		   @nLin,110 PSAY TEMP1->F2_DOC + '/' + TEMP1->F2_SERIE
		   nLin++ // Avanca a linha de impressao
		   
		   
		   //subtotais por localidade
		   nTotKG += TEMP1->FAT_KG
		   nTotRS += TEMP1->FAT_RS
		   //nTotVol+= TEMP1->Qt_Volumes
		   nTotFre+= nFret_pes
		   nTotFreic+= nFretIcms
		   
		   //acumula total geral
			nTOTGERKG += TEMP1->FAT_KG
			nTOTGERRS += TEMP1->FAT_RS
			//nTOTGERVOL+= TEMP1->Qt_Volumes
			nTotGFre+= nFret_pes
		    nTotGFreic+= nFretIcms
		   
			TEMP1->(DBSKIP())
		Enddo
		 
		If MV_PAR03 = 1 .or. MV_PAR03 = 2
			@nLin,000 PSAY Replicate("-" , limite)
			nLin++
			@nLin,049 PSAY nTotKG  Picture "@E 99,999,999.99"    //SUBTOTAL EM KG			
			//@nLin,064 PSAY nTotRS  Picture "@E 999,999,999.99"   //SUBTOTAL EM R$
			//@nLin,083 PSAY nTotFre Picture "@E 999,999.99" //valor frete       
			@nLin,064 PSAY nTotFreic Picture "@E 999,999.99" //valor frete icms
			//nPerFret := ( nTotFre / nTotRS ) * 100 
			nPerFret := ( nTotFreic / nTotKG ) * 100 
		    @nLin,086 PSAY nPerFret Picture "@E 999.99" //% frete sob faturado
		    //@nLin,115 PSAY nTotFreic Picture "@E 999,999.99" //valor frete icms
			   
			//@nLin,105 PSAY "<=== SUBTOTAL - " + cLaco //cLocal
			@nLin,020 PSAY "SUBTOTAL ===> " 
			//If MV_PAR03 = 2			
				@nLin,035 PSAY cLaco //cLocal
			//Endif
		
			nLin++                             
			@nLin,000 PSAY Replicate("_" , limite)
			nLin++                     
			nLin++
		Endif
		
		
		
		//reinicia os subtotais
		nTotKG := 0
		nTotRS := 0 
		nTotVol:= 0 
		nTotFre:= 0
		nTotFreic:= 0
	Enddo 
	//TOTAL GERAL:
	nLin++
	@nLin,000 PSAY Replicate("=" , limite)
	nLin++
                                                                          
	@nLin,049 PSAY nTOTGERKG  Picture "@E 99,999,999.99"    //SUBTOTAL EM KG
	//@nLin,064 PSAY nTOTGERRS  Picture "@E 999,999,999.99"   //SUBTOTAL EM R$
	//@nLin,083 PSAY nTotGFre Picture "@E 999,999.99" //valor frete       
	@nLin,064 PSAY nTotGFreic Picture "@E 999,999.99" //valor frete icms
	//nPerFret := ( nTotGFre / nTOTGERRS ) * 100 
	nPerFret := ( nTotGFreic / nTOTGERKG ) * 100 
	@nLin,086 PSAY nPerFret Picture "@E 999.99" //% frete sob faturado
    //@nLin,115 PSAY nTotGFreic Picture "@E 999,999.99" //valor frete icms
	
	//@nLin,105 PSAY "<==== TOTAL GERAL"    
	@nLin,020 PSAY "TOTAL GERAL ===> " 
	nLin++
	@nLin,000 PSAY Replicate("=" , limite)

	DbSelectArea("TEMP1")
	DbCloseArea()
Endif   //se não é fim de arquivo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda(0, "" , tamanho)

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


//CÁLCULO FRETE 
*****************************************
Static Function fTrazFrete(cNota, cSerie)
*****************************************   

Local aFrete := {}
Local cTransp:= ""
Local cRedesp:= ""
Local cLocali:= "" 
Local ZZFRPESO := 0
Local nFretpeso:= 0
Local nTaxaFixa := 0
Local nGRIS     := 0
Local nADM      := 0
Local nTDE      := 0
Local nPedagio  := 0
Local nSuframa  := 0
Local nFrete    := 0
Local nFretIcms := 0
Local nPerc     := 0 
Local nValDna   := 0

SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cNota + cSerie ))
	cTransp := SF2->F2_TRANSP
	cRedesp := SF2->F2_REDESP
	cLocali := SF2->F2_LOCALIZ
	SA1->(Dbsetorder(1))
	SA1->(Dbseek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA ))
	
	SZZ->(Dbsetorder(1))
	If Empty(cRedesp)
		SZZ->(Dbseek(xFilial("SZZ") + cTransp + cLocali ))
		ZZFRPESO := SZZ->ZZ_FR_PESO
		SA4->(Dbsetorder(1))
		SA4->(Dbseek(xFilial("SA4") + cTransp))
	Else                           
		SZZ->(Dbseek(xFilial("SZZ") + cRedesp + cLocali ))
		ZZFRPESO := SZZ->ZZ_FR_PESO            
		SA4->(Dbsetorder(1))
		SA4->(Dbseek(xFilial("SA4") + cRedesp))
	Endif
	
	

          If SF2->F2_PLIQUI > 150
          	nFretpeso := (SF2->F2_PLIQUI * ZZFRPESO)
            //SE O FRETE PESO CALCULADO FOR MENOR QUE O MÍNIMO, PEGA O MÍNIMO DO SA4
            If SZZ->ZZ_TIPO = 'C'    //CAPITAL
            	If nFretpeso < SA4->A4_FREMINC
            		nFretpeso := SA4->A4_FREMINC
            	Endif
            Elseif SZZ->ZZ_TIPO = 'I'   //INTERIOR
            	If nFretpeso < SA4->A4_FREMINI
            		nFretpeso := SA4->A4_FREMINI
            	Endif            
            Endif
            	
          ElseIf (SF2->F2_PLIQUI >= 101 .and. SF2->F2_PLIQUI <= 150)
          	If !Empty(SZZ->ZZ_101150K) 
          		nFretpeso := SZZ->ZZ_101150K
          	Else
          		nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          	Endif          	
          
          //FR - Flávia Rocha
          //chamado 002208:	Joao Emanuel
          //Para calculo de frete, quando a transportadora for cod 30
          // e o peso for até 10 KG, favor calcular só os valores abaixo:
          // Valor do campo de 1 a 10KG + Ad valorem (0,5%) sobre o valor da nota fiscal + Gris + Icms  
          ElseIf SF2->F2_PLIQUI <= 10
            	If !Empty(SZZ->ZZ_1A10KG) 
          			nFretpeso := SZZ->ZZ_1A10KG
          			If Alltrim( cTransp ) = "30"
          				nGRIS := ( SF2->F2_VALBRUT * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
						//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
						If !Empty(SZZ->ZZ_GRISMIN)
							If nGRIS <= SZZ->ZZ_GRISMIN
								nGRIS := SZZ->ZZ_GRISMIN
							Endif
						Endif
          				nFretpeso := SZZ->ZZ_1A10KG + ( SF2->F2_VALBRUT * 0.5 / 100 ) + nGRIS
          			Endif 
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 20
          		If !Empty(SZZ->ZZ_11A20KG)
          			nFretpeso := SZZ->ZZ_11A20KG
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 30
          		If !Empty(SZZ->ZZ_21A30KG)
          			nFretpeso := SZZ->ZZ_21A30KG
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 40
          		If !Empty(SZZ->ZZ_31A40KG)
          			nFretpeso := SZZ->ZZ_31A40KG 
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 50
          		If !Empty(SZZ->ZZ_41A50KG)
          			nFretpeso := SZZ->ZZ_41A50KG 
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 60
          		If !Empty(SZZ->ZZ_51A60KG)
          			nFretpeso := SZZ->ZZ_51A60KG 
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 70
          		If !Empty(SZZ->ZZ_61A70KG)
          			nFretpeso := SZZ->ZZ_61A70KG
          			Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 80
          		If !Empty(SZZ->ZZ_71A80KG)
          			nFretpeso := SZZ->ZZ_71A80KG
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 90
          		If !Empty(SZZ->ZZ_81A90KG)
          			nFretpeso := SZZ->ZZ_81A90KG
          		Else
          			nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Else
          	If !Empty(SZZ->ZZ_91A100K)
          		nFretpeso := SZZ->ZZ_91A100K          	
          	Else
          		nFretpeso := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		
          	Endif          	
          
          Endif
          
          //TAXA FIXA
           	If !Empty(SZZ->ZZ_TXFIXA)
	     		nTaxaFixa := SZZ->ZZ_TXFIXA
	  		Endif
          	
          	//AD-VALOREM
          	If !Empty(SZZ->ZZ_ADVALOR)
	        	nAd_valoren := ( SF2->F2_VALBRUT * SZZ->ZZ_ADVALOR / 100 )	 
	        	         
			Elseif Alltrim( cTransp ) == "03" .and. Alltrim( SZZ->ZZ_LOCAL ) $ "07 09 20 59 94 46"
	      		nAd_valoren := ( SF2->F2_VALBRUT * 0.3 / 100 )
	      	Else
	      		nAd_valoren := 0
			Endif
			
			//GRIS
			nGRIS := ( SF2->F2_VALBRUT * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
			//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
			If !Empty(SZZ->ZZ_GRISMIN)
				If nGRIS <= SZZ->ZZ_GRISMIN
					nGRIS := SZZ->ZZ_GRISMIN
				Endif
			Endif
			
			//ADM
			If !Empty(SZZ->ZZ_ADM)
				nADM := SZZ->ZZ_ADM
			Endif   
            
            //TDE
          	nTDE := SZZ->ZZ_TDE  
          	
            //PEDAGIO E SUFRAMA
            If SF2->F2_PLIQUI >= 100
	            Do Case
	            	Case ( SF2->F2_PLIQUI >= 100 .And. SF2->F2_PLIQUI < 101)
			            If !Empty(SZZ->ZZ_PEDAGIO)
			            	nPedagio := SZZ->ZZ_PEDAGIO
			            Endif
			            
			            If !Empty(SZZ->ZZ_SUFRAMA)
			            	nSuframa := SZZ->ZZ_SUFRAMA
			            Endif
	   	       		
	   	       		Case (SF2->F2_PLIQUI >= 101 .And. SF2->F2_PLIQUI <= 200 )
	   	       			If !Empty(SZZ->ZZ_PEDAGIO)
	   	       				nPedagio := ( SZZ->ZZ_PEDAGIO * 2 )
	   	       			Endif
	   	       			
	   	       			If !Empty(SZZ->ZZ_SUFRAMA)
	   	       				nSuframa := ( SZZ->ZZ_SUFRAMA * 2 )
	   	       			Endif
		  			
		  			Case (SF2->F2_PLIQUI >= 201)
		  				If !Empty(SZZ->ZZ_PEDAGIO)
		  					nPedagio := ( SF2->F2_PLIQUI / 100) * SZZ->ZZ_PEDAGIO
		  				Endif
		  				
		  				If !Empty(SZZ->ZZ_SUFRAMA)
		  					nSuframa := ( SF2->F2_PLIQUI / 100) * SZZ->ZZ_SUFRAMA
		  				Endif
		  				
		  		Endcase
	  		            
	  		Endif
            
            
          	
            
            //SE A SOMA DAS TAXAS FOR MENOR QUE O VALOR DO FRETE MÍNIMO, ASSUME O FRETE MÍNIMO
	      	If SF2->F2_PLIQUI > 100
		      	If ( nFretpeso + nTaxaFixa + nAd_valoren + nGRIS + nADM + nPedagio + nSuframa + nTDE ) >= SA4->A4_FREMINI
	          		nFrete := ( nFretpeso + nTaxaFixa + nAd_valoren + nGRIS + nADM + nPedagio + nSuframa + nTDE ) 	
	          	Else
	          		nFrete := SA4->A4_FREMINI          	
	          	Endif
	        
	        ElseIf SF2->F2_PLIQUI <= 10
            	If !Empty(SZZ->ZZ_1A10KG) 
          			nFrete := (SZZ->ZZ_1A10KG + nPedagio)           		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 20
          		If !Empty(SZZ->ZZ_11A20KG)
          			nFrete := (SZZ->ZZ_11A20KG + nPedagio)           		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Elseif SF2->F2_PLIQUI <= 30
          		If !Empty(SZZ->ZZ_21A30KG)
          			nFrete := (SZZ->ZZ_21A30KG + nPedagio)     		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Elseif SF2->F2_PLIQUI <= 40
          		If !Empty(SZZ->ZZ_31A40KG)
          			nFrete := (SZZ->ZZ_31A40KG + nPedagio)          		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 50
          		If !Empty(SZZ->ZZ_41A50KG)
          			nFrete := (SZZ->ZZ_41A50KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 60
          		If !Empty(SZZ->ZZ_51A60KG)
          			nFrete := (SZZ->ZZ_51A60KG + nPedagio)        		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 70
          		If !Empty(SZZ->ZZ_61A70KG)
          			nFrete := (SZZ->ZZ_61A70KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 80
          		If !Empty(SZZ->ZZ_71A80KG)
          			nFrete := (SZZ->ZZ_71A80KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Elseif SF2->F2_PLIQUI <= 90
          		If !Empty(SZZ->ZZ_81A90KG)
          			nFrete := (SZZ->ZZ_81A90KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Else
	          	If !Empty(SZZ->ZZ_91A100K)
	          		nFrete := (SZZ->ZZ_91A100K + nPedagio)          		
	          	Else
	          		nFrete := SA4->A4_FREMINI
	          	Endif          
          	Endif           
	      	 	  	
	
          ///FR - 20/08/13
          	//nFretIcms :=  ( nFrete / ( 1 - (SA4->A4_ICMS / 100) )  ) //COMENTADO, POIS AGORA É UMA NOVA REGRA:
          	
          	//TRANSPORTADORA AGAPE , SEMPRE ZERO
          	IF ALLTRIM(SF2->F2_TRANSP)!='80' // TRANSPORTADORA AGAPE E SEMPRE ZERO
            	nFretIcms :=  ( nFrete / ( 1 - (IIF(ALLTRIM(SA1->A1_TIPO)<> 'F' , SA4->A4_ICMS,17) / 100) )  )
			ELSE
	            nFretIcms :=  ( nFrete / ( 1 - (SA4->A4_ICMS / 100) )  ) //SE NO CADASTRO DELA ESTIVER 0, SERÁ ZERO.
	   		ENDIF
	
	        
          
          nValDna   := nValDna + SF2->F2_VALBRUT
          nPerc     := ( nFretIcms * 100 / nValDna ) 
         
          ///////////////////////////////////////////////////////
	      ///SE FOR AMOSTRA/CORTESIA, OS VALORES SERÃO ZERADOS   
	      ///08/10/13 - FR -> SE FOR NOTA EM PROCESSO DE DEVOLUÇÃO,
	      ///OS VALORES SERÃO ZERADOS TAMBÉM
	      ///////////////////////////////////////////////////////
	      /*
	      cD2TES := ""
	      cTESAM := GETMV("RV_TESAM")
          SD2->(Dbsetorder(3))
          If SD2->(Dbseek(xFilial("SD2") + cNota + cSerie ) )
          	While SD2->(!EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == cNota .and. SD2->D2_SERIE == cSerie
          		cD2TES := SD2->D2_TES
          		//SF4->(Dbsetorder(1))
          		//SF4->(Dbseek(xFilial("SF4") + cD2TES ))
          		//If 'AMOSTRA/CORTESIA/GRATIS ' $ SF4->F4_TEXTO
          		If cD2TES $ cTESAM //'516'
          			nFretpeso := 0
          			nTaxaFixa := 0
          			nGRIS     := 0
          			nADM      := 0
          			nTDE      := 0
          			nPedagio  := 0
          			nSuframa  := 0
          			nFrete    := 0
          			nFretIcms := 0
          			nPerc     := 0
          		Endif
          		
          		If SD2->D2_QTDEDEV > 0  //NF em processo de devolução - VALORES FRETE ZERADOS
          			nFretpeso := 0
          			nTaxaFixa := 0
          			nGRIS     := 0
          			nADM      := 0
          			nTDE      := 0
          			nPedagio  := 0
          			nSuframa  := 0
          			nFrete    := 0
          			nFretIcms := 0
          			nPerc     := 0
          		Endif	
          			
          		SD2->(Dbskip())
          	Enddo
          Endif                     
          */
Endif //seek no Sf2
          
Aadd(aFrete, { nFretpeso, nFretIcms} )          
//FIM CÁLCULO FRETE
Return(aFrete)