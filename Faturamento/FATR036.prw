#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATR036  º Autor ³ Flávia Rocha       º Data ³  30/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento por Localidade                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamado: 00000232 - Depto. Logistica                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR036


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "FATURAMENTO POR LOCALIDADE"
Local cPict          := ""
Local titulo         := "FATURAMENTO POR LOCALIDADE - KG e QTD"
Local nLin           := 80
Local Cabec1         := ""
//Local Cabec2       := "Fat. KG                 Fat. R$            Localidade                  UF   Regiao           Qt.Volumes"
Local Cabec2         := "Localidade                      UF   Regiao        Fat.KG      Qt.Volumes        Fat. R$"

Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132  //80
Private tamanho      := "M"  //"P"
Private nomeprog     := "FATR036" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "FATR036"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR036" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF2"

dbSelectArea("SF2")
dbSetOrder(1)


pergunte(cPerg,.T.)

If !Empty(MV_PAR01)
	Cabec1 += " Emissao a partir de: " + DtoC(MV_PAR01) 
Endif

If !Empty(MV_PAR02)
	Cabec1 += " ate: " + DtoC(MV_PAR02) 
Endif

//expedição de / até
//If !Empty(MV_PAR03)
	Cabec1 += " - Expedicao a partir de: " + DtoC(MV_PAR03) 
//Endif

//If !Empty(MV_PAR04)
	Cabec1 += " ate: " + DtoC(MV_PAR04) 
//Endif

If !Empty(MV_PAR09)
	Cabec1 += " - Regiao: "
	If MV_PAR09 = '000001'    //nordeste
		Cabec1 += "NORDESTE " 
	Elseif MV_PAR09 = '000002' //sudeste
		Cabec1 += "SUDESTE"
	Elseif MV_PAR09 = '000003' // centro-oeste
		Cabec1 += "CENTRO-OESTE"
	Elseif MV_PAR09 = '000004' // norte
		Cabec1 += "NORTE"
	Elseif MV_PAR09 = '000005' // sul
		Cabec1 += "SUL"
	Endif              
Endif

If SM0->M0_CODFIL = '03'
	Cabec2       := "Localidade                      UF   Regiao        Fat.QTD     Qt.Volumes        Fat. R$"
Endif
//Cabec1 += CHR(13) + CHR(10)
/*
PARÂMETROS:
MV_PAR01 - EMISSAO NF DE
MV_PAR02 - EMISSAO NF ATE
MV_PAR03 - EXPEDICAO NF DE
MV_PAR04 - EXPEDICAO NF ATE
MV_PAR05 - LOCALIDADE DE
MV_PAR06 - LOCALIDADE ATE
MV_PAR07 - UF DE
MV_PAR08 - UF ATE
MV_PAR09 - REGIAO  
MV_PAR10 - TRANSPORTADORA  
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo       := "FATURAMENTO POR LOCALIDADE - " + IIF(!EMPTY(MV_PAR10),ALLTRIM(posicione('SA4',1,xFilial('SA4')+MV_PAR10,'A4_NOME')),'')

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


cQuery := " SELECT " + LF
//SE EMITIDO NA RAVA/EMB:
//If SM0->M0_CODFIL = '01'
	cQuery += " FAT_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0   " + LF
	cQuery += " ELSE (D2_QUANT - D2_QTDEDEV) * D2_PESO END) " + LF
//Elseif SM0->M0_CODFIL = '03'
//	cQuery += " FAT_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0   " + LF
//	cQuery += " ELSE (D2_QUANT - D2_QTDEDEV )  END) " + LF
//Endif

//cQuery += " ,FAT_RS=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0   " + LF
//cQuery += " ELSE D2_TOTAL END) " + LF

cQuery += " ,FAT_RS=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN)  " + LF

//cQuery += " ,SZZ.ZZ_DESC Localidade " + LF
cQuery += " ,SF2.F2_EST UF " + LF
cQuery += " ,REGIAO = (case when SF2.F2_EST IN ('AC', 'AM', 'AP', 'PA', 'RO', 'RR', 'TO') THEN 'NORTE' " + LF
cQuery += "            ELSE CASE WHEN SF2.F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA' , 'SE') THEN 'NORDESTE' " + LF
cQuery += "            ELSE CASE WHEN SF2.F2_EST IN ('GO', 'MT', 'MS' , 'DF') THEN 'CENTRO-OESTE' " + LF
cQuery += "            ELSE CASE WHEN SF2.F2_EST IN ('MG', 'ES', 'RJ', 'SP') THEN 'SUDESTE' " + LF
cQuery += "            ELSE 'SUL' END END END END) " + LF

cQuery += " ,Qt_Volumes=SUM(F2_VOLUME1), SF2.F2_LOCALIZ ,F2_TRANSP " + LF
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
//cQuery += "," + RetSqlName("SZZ") + " SZZ WITH (NOLOCK) " + LF

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
//cQuery += " AND SF2.F2_LOCALIZ = SZZ.ZZ_LOCAL " + LF
//cQuery += " AND SF2.F2_TRANSP  = SZZ.ZZ_TRANSP " + LF

cQuery += " AND SD2.D2_FILIAL = SF4.F4_FILIAL  " + LF
cQuery += " and SD2.D2_TES = SF4.F4_CODIGO  " + LF

cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD " + LF
cQuery += " AND SF2.F2_LOJA = SA1.A1_LOJA  " + LF
/*
PARÂMETROS:
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
If !Empty(MV_PAR01)
	cQuery += " and F2_EMISSAO >= '" + Dtos(MV_PAR01) + "' " + LF
Endif

If !Empty(MV_PAR02)
	cQuery += " and F2_EMISSAO <= '" + Dtos(MV_PAR02) + "'  " + LF
Endif

//expedição de / até
If !Empty(MV_PAR03)
	cQuery += " and F2_DTEXP >= '" + Dtos(MV_PAR03) + "' " + LF
Endif

If !Empty(MV_PAR04)
	cQuery += " and F2_DTEXP <= '" + Dtos(MV_PAR04) + "'  " + LF
Endif

If Empty(MV_PAR09)  //Só faz as cláusulas abaixo, se a região NÃO ESTIVER ESPECIFICADA
	//localização de / até
     If !Empty(MV_PAR05)
		cQuery += " and F2_LOCALIZ >= '" + Alltrim(MV_PAR05) + "' " + LF
	 Endif
	
	If !Empty(MV_PAR06)
		cQuery += " and F2_LOCALIZ <= '" + Alltrim(MV_PAR06) + "'  " + LF
	Endif
	
	//uf de / até
	If !Empty(MV_PAR07)
		cQuery += " and F2_EST >= '" + Alltrim(MV_PAR07) + "' " + LF
	Endif
	
	If !Empty(MV_PAR08)
		cQuery += " and F2_EST <= '" + Alltrim(MV_PAR08) + "'  " + LF
	Endif

Else
	//região
	//MV_PAR09 - REGIAO  -> 1-Nordeste , 2-Sudeste, 3-Centro-Oeste, 4-Norte, 5-Sul
	If MV_PAR09 = '000001'    //nordeste
		cQuery += " and F2_EST in ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA' , 'SE') " + LF
	Elseif MV_PAR09 = '000002' //sudeste
		cQuery += " and F2_EST in ('MG', 'ES', 'RJ', 'SP') "  + LF
	Elseif MV_PAR09 = '000003' // centro-oeste
		cQuery += " and F2_EST in ('GO', 'MT', 'MS' , 'DF') " + LF
	Elseif MV_PAR09 = '000004' // norte
		cQuery += " and F2_EST in ('AC', 'AM', 'AP', 'PA', 'RO', 'RR', 'TO') " + LF
	Elseif MV_PAR09 = '000005' // sul
		cQuery += " and F2_EST in ('RS', 'SC' , 'PR' ) " + LF
	Endif

Endif

IF !EMPTY(MV_PAR10)  // TRANSPORTADORA 
   cQuery += " AND SF2.F2_TRANSP='"+MV_PAR10+"'
ENDIF

cQuery += " AND F2_DUPL <> ' '   " + LF
If SM0->M0_CODFIL = '03'                    //se filial Caixas, filtra o setor do B1 = 39 (Caixas)
	cQuery += " AND B1_SETOR = '39'  " + LF   
ElseIf SM0->M0_CODFIL = '01'
	cQuery += " AND B1_SETOR <> '39'  " + LF   //DIFERENTE DE CAIXAS
Endif
cQuery += " AND B1_TIPO != 'AP'  " + LF  //EXCLUI APARAS
cQuery += " AND D2_TIPO = 'N'   " + LF
cQuery += " and F2_TIPO = 'N' " + LF
cQuery += " AND D2_TP != 'AP'  " + LF
cQuery += " AND B1_TIPO != 'AP'   " + LF
//RESOLVI NÃO ESPECIFICAR CFOP , pois isto pode limitar quando surge um novo e não é incluído aqui na lista
cQuery += " --AND RTRIM(D2_CF) IN ('511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949','6949','5922','6922','5116','6116' , '6108' ) " + LF
//resolvi considerar apenas o que o texto do TES indica como "VENDA" :
//cQuery += " AND F4_TEXTO LIKE  '%VENDA%'   " + LF
//cQuery += " AND F4_DUPLIC = 'S' " + LF   //QUE GERE DUPLICATA
cQuery += "and   RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' )  " + LF
cQuery += " AND D2_CLIENTE NOT IN ('031732','031733') " + LF
cQuery += " AND SD2.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SB1.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SF2.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SA3.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SA1.D_E_L_E_T_ = ''  " + LF
cQuery += " AND SF4.D_E_L_E_T_ = ''  " + LF

//cQuery += " AND SZZ.D_E_L_E_T_='' " + LF
//cQuery += " GROUP BY SZZ.ZZ_DESC, SZZ.ZZ_LOCAL, SF2.F2_EST, SF2.F2_LOCALIZ " + LF
//cQuery += " ORDER BY SF2.F2_LOCALIZ, FAT_KG DESC " + LF
//cQuery += " ORDER BY SF2.F2_EST, FAT_KG DESC " + LF

cQuery += " GROUP BY  SF2.F2_EST, SF2.F2_LOCALIZ,F2_TRANSP " + LF
cQuery += " ORDER BY SF2.F2_EST, FAT_KG DESC " + LF


MEMOWrite("C:\TEMP\FATR036.SQL", cQuery )
If Select("TEMP1") > 0
	DbSelectArea("TEMP1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TEMP1"
//TCSetField( "REP", "C5_EMISSAO", "D")
If !TEMP1->(EOF())
   //	TEMP1->( DbGoTop() )
	
	/*
	While TEMP1->( !EOF() )
		nTotRegs++
		TEMP1->(DBSKIP())
	Enddo

	SetRegua( nTotRegs)*/
	
    SetRegua(0)

	TEMP1->( DbGoTop() )
	While TEMP1->( !EOF() )
	
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 9
	   Endif
	   cLocal := TEMP1->UF  //TEMP1->Cod_Localidade
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Verifica o cancelamento pelo usuario...                             ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Impressao do cabecalho do relatorio. . .                            ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   //While Alltrim(TEMP1->Cod_Localidade) == Alltrim(cLocal) 
	   While !TEMP1->(EOF()) .and. Alltrim(TEMP1->UF) == Alltrim(cLocal) 
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 9
		   Endif
		   /*
		   @nLin, 000 PSAY TEMP1->FAT_KG  Picture "@E 99,999,999.99"
		   @nLin, 020 PSAY TEMP1->FAT_RS  Picture "@E 999,999,999.99"
		   @nLin, 040 PSAY Substr(TEMP1->Localidade,1,30)
		   @nLin, 072 PSAY TEMP1->UF
		   @nLin, 075 PSAY TEMP1->REGIAO
		   @nLin, 088 PSAY TEMP1->Qt_Volumes Picture "@E 999,999"
		   */                                                    
           _cMun:=posicione("SZZ",1,xFilial("SZZ")+TEMP1->F2_TRANSP+TEMP1->F2_LOCALIZ, "ZZ_DESC")

		   if !empty(_cMun)
		      _cLocax:= _cMun
		   else
		      _cLocax:=   alltrim(TEMP1->F2_TRANSP)+" "+TEMP1->F2_LOCALIZ+' '+fcc2()
		   endif

		   
		   @nLin, 000 PSAY  Substr(_cLocax,1,30)   //Substr(TEMP1->Localidade,1,30)
		   @nLin, 032 PSAY TEMP1->UF
		   @nLin, 035 PSAY TEMP1->REGIAO
		   @nLin, 049 PSAY TEMP1->FAT_KG  Picture "@E 99,999,999.99"
		   @nLin, 064 PSAY TEMP1->Qt_Volumes Picture "@E 9,999,999"
		   @nLin, 078 PSAY TEMP1->FAT_RS  Picture "@E 999,999,999.99"
		   
		   nLin++ // Avanca a linha de impressao
		   //subtotais por localidade
		   nTotKG += TEMP1->FAT_KG
		   nTotRS += TEMP1->FAT_RS
		   nTotVol+= TEMP1->Qt_Volumes
		   
		   //acumula total geral
			nTOTGERKG += TEMP1->FAT_KG
			nTOTGERRS += TEMP1->FAT_RS
			nTOTGERVOL+= TEMP1->Qt_Volumes
  	        IncRegua()
			TEMP1->(DBSKIP())
		Enddo
		@nLin,000 PSAY Replicate("-" , limite)
		nLin++
		/*
		@nLin,000 PSAY nTotKG  Picture "@E 99,999,999.99"    //SUBTOTAL EM KG
		@nLin,020 PSAY nTotRS  Picture "@E 999,999,999.99"   //SUBTOTAL EM R$
		@nLin,088 PSAY nTotVol Picture "@E 999,999"          //SUBTOTAL QTDE VOLUMES
		*/
		@nLin,049 PSAY nTotKG  Picture "@E 99,999,999.99"    //SUBTOTAL EM KG
		@nLin,064 PSAY nTotVol Picture "@E 9,999,999"          //SUBTOTAL QTDE VOLUMES
		@nLin,078 PSAY nTotRS  Picture "@E 999,999,999.99"   //SUBTOTAL EM R$
		
		@nLin,105 PSAY "<=== SUBTOTAL - " + cLocal
		nLin++                             
		@nLin,000 PSAY Replicate("=" , limite)
		nLin++                     
		nLin++
		
		
		//reinicia os subtotais
		nTotKG := 0
		nTotRS := 0 
		nTotVol:= 0 
	Enddo 
	//TOTAL GERAL:
	nLin++
	@nLin,000 PSAY Replicate("=" , limite)
	nLin++
	/*
	@nLin,000 PSAY nTOTGERKG  Picture "@E 99,999,999.99"    //SUBTOTAL EM KG
	@nLin,020 PSAY nTOTGERRS  Picture "@E 999,999,999.99"   //SUBTOTAL EM R$
	@nLin,088 PSAY nTOTGERVOL Picture "@E 999,999"          //SUBTOTAL QTDE VOLUMES
	*/                                                                             
	@nLin,049 PSAY nTOTGERKG  Picture "@E 99,999,999.99"    //SUBTOTAL EM KG
	@nLin,064 PSAY nTOTGERVOL Picture "@E 9,999,999"          //SUBTOTAL QTDE VOLUMES
	@nLin,078 PSAY nTOTGERRS  Picture "@E 999,999,999.99"   //SUBTOTAL EM R$
	
	@nLin,105 PSAY "<==== TOTAL GERAL"    
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


***************

static Function fcc2()

***************

local cQry:=" "
local cRet:=" "
 
cQry:="select CC2_MUN from " + RetSqlName("CC2") + " CC2 "
cQry+="where CC2_EST='"+TEMP1->UF+"'  "
cQry+="and CC2_CODMUN='"+TEMP1->F2_LOCALIZ+"' "
cQry+="and D_E_L_E_T_=' '"

If Select("TEMP9") > 0
	DbSelectArea("TEMP9")
	TEMP9->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TEMP9"

IF TEMP9->(!EOF())

cRet:= TEMP9->CC2_MUN  

ENDIF

TEMP9->(DbCloseArea())

Return cRet
