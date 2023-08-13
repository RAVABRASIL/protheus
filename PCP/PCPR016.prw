#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO14    º Autor ³ AP6 IDE            º Data ³  20/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR016()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Reusumo producao por Produto"
Local cPict          := ""
Local titulo         := "Resumo Producao por Lado e Produto: "
Local nLin           := 80
Local Cabec1         :=" "
Local Cabec2         :=" "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR016" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR016" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Private _aArra:={}
Private _aCabe:={'MAQUINA','LADO','PRODUTO','T1_MR','T1_KG','PERC_APARA_T1','T2_MR','T2_KG','PERC_APARA_T2','T3_MR','T3_KG','PERC_APARA_T3','TOTAL_MR','TOTAL_KG','PERC_APARA_TOTAL','FATURAMENTO_KG','CARTEIRA_KG'}


Pergunte('PCPR016',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"PCPR016",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
titulo:=ALLTRIM(titulo)+' De '+dtoc(MV_PAR01)+' Ate '+ dtoc(MV_PAR02)   

If MV_PAR04=1
            //         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
           //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
   Cabec1 :="Maq-Lado /------------- T U R N O   1 -------------\/----------- T U R N O   2 -----------\/---------- T U R N O   3 ----------\/-----------     TOTAL     -----------\  Faturamento    Carteira"
   Cabec2 := "Produto             (MR)          (KG)     APARA(%)       (MR)          (KG)     APARA(%)      (MR)          (KG)     APARA(%)        (MR)          (KG)     APARA(%)      (KG)          (KG)  "
ElseIf MV_PAR04=2
   Cabec1 :="Maq-Lado /------------- T U R N O   1 -------------\/----------- T U R N O   2 -----------\/---------- T U R N O   3 ----------\/-----------     TOTAL     -----------\  "
   Cabec2 := "Produto             (MR)          (KG)     APARA(%)       (MR)          (KG)     APARA(%)      (MR)          (KG)     APARA(%)        (MR)          (KG)     APARA(%)   "
Endif



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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  20/07/11   º±±
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
local cQry:=''
Local LF  := CHR(13)+CHR(10)   
Local cMaq:=''
Local cLado:=''
Local lOk:=.T.
// maquina
local T1_MR:=T2_MR:=T3_MR:=0
local T1_KG:=T2_KG:=T3_KG:=0
// sub
local SUB_T1_MR:=SUB_T2_MR:=SUB_T3_MR:=0
local SUB_T1_KG:=SUB_T2_KG:=SUB_T3_KG:=0
// total
local TOT_T1_MR:=TOT_T2_MR:=TOT_T3_MR:=0
local TOT_T1_KG:=TOT_T2_KG:=TOT_T3_KG:=0
//
local nApara:=0 
Local cVia:='1'
Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")


if MV_PAR05=1 // PESAGEM 

	cQry:="SELECT "
	cQry+="CASE WHEN SUBSTRING(Z00_MAQ,1,2) IN ('C0','C1','P0','P1','S0','S1') THEN '1' ELSE CASE WHEN SUBSTRING(Z00_MAQ,1,2) IN ('I0','I1') THEN '2' ELSE CASE WHEN (Z00_MAQ) IN ('CX','ICVR','MONT','CVP','PLAST') THEN '3' ELSE CASE WHEN SUBSTRING(Z00_MAQ,1,2) IN ('E0','E1','A0','A1') THEN '4' ELSE CASE WHEN (Z00_MAQ) IN ('EXT','COST') THEN '5' ELSE '6' END END END END END AS VIA_IMPRESSAO "
	cQry+=",Z00_MAQ AS MAQ, Z00_LADO AS LADO,Z00_CODIGO AS PRODUTO,  " +LF
	cQry+="( SELECT ISNULL( SUM(Z01.Z00_QUANT),0) " +LF   
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z01 WITH (NOLOCK)  " +LF 
	cQry+="WHERE Z01.Z00_FILIAL = '"+XFILIAL('Z00')+"' AND   " +LF 
	cQry+="Z01.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND Z01.Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO2,5)+"'  " +LF 
	cQry+="AND CASE WHEN Z01.Z00_HORA >= '"+Left(cTURNO1,5)+"' AND Z01.Z00_HORA < '"+Left(cTURNO2,5)+"'  THEN '1'  END ='1' " +LF
	cQry+="AND Z01.Z00_MAQ = Z00.Z00_MAQ   " +LF 
	cQry+="AND Z01.Z00_LADO = Z00.Z00_LADO  " +LF 
	cQry+="AND Z01.Z00_CODIGO = Z00.Z00_CODIGO   " +LF  
	cQry+="AND Z01.Z00_APARA = ''   " +LF 
	cQry+="AND Z01.D_E_L_E_T_ != '*'   " +LF 
	cQry+=") AS T1_MR,   " +LF 
	cQry+="( SELECT ISNULL( SUM(Z01KG.Z00_PESO+Z01KG.Z00_PESCAP),0)     " +LF 
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z01KG WITH (NOLOCK)  " +LF  
	cQry+="WHERE Z01KG.Z00_FILIAL = '"+XFILIAL('Z00')+"' AND   " +LF 
	cQry+="Z01KG.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND Z01KG.Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO2,5)+"'  " +LF 
	cQry+="AND CASE WHEN Z01KG.Z00_HORA >= '"+Left(cTURNO1,5)+"' AND Z01KG.Z00_HORA < '"+Left(cTURNO2,5)+"'  THEN '1'  END ='1' " +LF
	cQry+="AND Z01KG.Z00_MAQ = Z00.Z00_MAQ   " +LF 
	cQry+="AND Z01KG.Z00_LADO = Z00.Z00_LADO   " +LF 
	cQry+="AND Z01KG.Z00_CODIGO = Z00.Z00_CODIGO   " +LF  
	cQry+="AND Z01KG.Z00_APARA = ''   " +LF 
	cQry+="AND Z01KG.D_E_L_E_T_ != '*'   " +LF 
	cQry+=") AS T1_KG,   " +LF 
	cQry+="( SELECT ISNULL( SUM(Z02.Z00_QUANT),0)   " +LF 
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z02 WITH (NOLOCK)   " +LF 
	cQry+="WHERE Z02.Z00_FILIAL = '"+XFILIAL('Z00')+"' AND   " +LF 
	cQry+="Z02.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO2,5)+"' AND Z02.Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO3,5)+"'  " +LF 
	cQry+="AND CASE WHEN Z02.Z00_HORA >= '"+Left(cTURNO2,5)+"' AND Z02.Z00_HORA <'"+Left(cTURNO3,5)+"'  THEN '2'  END ='2' " +LF
	cQry+="AND Z02.Z00_MAQ = Z00.Z00_MAQ   " +LF 
	cQry+="AND Z02.Z00_LADO = Z00.Z00_LADO  " +LF 
	cQry+="AND Z02.Z00_CODIGO = Z00.Z00_CODIGO   " +LF  
	cQry+="AND Z02.Z00_APARA = ''   " +LF 
	cQry+="AND Z02.D_E_L_E_T_ != '*'   " +LF 
	cQry+=") AS T2_MR,   " +LF 
	cQry+="( SELECT ISNULL( SUM(Z02KG.Z00_PESO+Z02KG.Z00_PESCAP),0)     " +LF 
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z02KG WITH (NOLOCK)   " +LF 
	cQry+="WHERE Z02KG.Z00_FILIAL = '"+XFILIAL('Z00')+"' AND   " +LF 
	cQry+="Z02KG.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO2,5)+"' AND Z02KG.Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO3,5)+"'  " +LF 
	cQry+="AND CASE WHEN Z02KG.Z00_HORA >= '"+Left(cTURNO2,5)+"' AND Z02KG.Z00_HORA <'"+Left(cTURNO3,5)+"'  THEN '2'  END ='2' " +LF
	cQry+="AND Z02KG.Z00_MAQ = Z00.Z00_MAQ   " +LF 
	cQry+="AND Z02KG.Z00_LADO = Z00.Z00_LADO  " +LF 
 	cQry+="AND Z02KG.Z00_CODIGO = Z00.Z00_CODIGO   " +LF  
	cQry+="AND Z02KG.Z00_APARA = ''   " +LF 
	cQry+="AND Z02KG.D_E_L_E_T_ != '*'   " +LF 
	cQry+=") AS T2_KG,    " +LF 
	cQry+="( SELECT ISNULL( SUM(Z03.Z00_QUANT),0)    " +LF 
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z03 WITH (NOLOCK)    " +LF 
	cQry+="WHERE Z03.Z00_FILIAL = '"+XFILIAL('Z00')+"' AND    " +LF 
	cQry+="Z03.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO3,5)+"' AND Z03.Z00_DATHOR < '"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"'   " +LF     
	cQry+="AND CASE WHEN ( (Z03.Z00_HORA >= '"+Left(cTURNO3,5)+"' AND Z03.Z00_HORA <= '24:00')  OR (Z03.Z00_HORA >= '00:00' AND Z03.Z00_HORA < '"+Left(cTURNO1,5)+"' ) ) THEN '3' END='3' " +LF
	cQry+="AND Z03.Z00_MAQ = Z00.Z00_MAQ   " +LF 
	cQry+="AND Z03.Z00_LADO = Z00.Z00_LADO   " +LF 
	cQry+="AND Z03.Z00_CODIGO = Z00.Z00_CODIGO     " +LF  
	cQry+="AND Z03.Z00_APARA = ''    " +LF 
	cQry+="AND Z03.D_E_L_E_T_ != '*'    " +LF 
	cQry+=") AS T3_MR,   " +LF 
	cQry+="( SELECT ISNULL( SUM(Z03KG.Z00_PESO+Z03KG.Z00_PESCAP),0)      " +LF 
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z03KG WITH (NOLOCK)    " +LF 
	cQry+="WHERE Z03KG.Z00_FILIAL = '"+XFILIAL('Z00')+"' AND    " +LF 
	cQry+="Z03KG.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO3,5)+"' AND Z03KG.Z00_DATHOR < '"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"'   " +LF     
	cQry+="AND CASE WHEN ( (Z03KG.Z00_HORA >= '"+Left(cTURNO3,5)+"' AND Z03KG.Z00_HORA <= '24:00')  OR (Z03KG.Z00_HORA >= '00:00' AND Z03KG.Z00_HORA < '"+Left(cTURNO1,5)+"' ) ) THEN '3' END='3' " +LF
	cQry+="AND Z03KG.Z00_MAQ = Z00.Z00_MAQ    " +LF 
	cQry+="AND Z03KG.Z00_LADO = Z00.Z00_LADO   " +LF 
	cQry+="AND Z03KG.Z00_CODIGO = Z00.Z00_CODIGO     " +LF 
	cQry+="AND Z03KG.Z00_APARA = ''    " +LF 
	cQry+="AND Z03KG.D_E_L_E_T_ != '*'    " +LF 
	cQry+=") AS T3_KG   " +LF 
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z00 WITH (NOLOCK)  " +LF 
	// fiocu com left pq algunas maquinas tem producao sem produto
	// nao sei pq
	cQry+="LEFT JOIN SB1010 SB1 WITH (NOLOCK)  "
	cQry+="ON  Z00_CODIGO =B1_COD  "
	cQry+="AND B1_FILIAL = '"+XFILIAL('SB1')+"'  AND SB1.D_E_L_E_T_ != '*' "
	
	cQry+="WHERE Z00_FILIAL = '"+XFILIAL('Z00')+"'    " +LF 
	
	if MV_PAR03 = 1 //Linha Hospitalar
	   cQry+= "AND B1_GRUPO IN ('C') "
	   titulo:=ALLTRIM(titulo)+'-Linha Hospitalar'
	elseif MV_PAR03 = 2 //Linha Domestica
	   cQry+= "AND B1_GRUPO IN ('D','E') "
	   titulo:=ALLTRIM(titulo)+'-Linha Domestica'
	elseif MV_PAR03 = 3 // Linha Institucional
	   cQry+= "AND B1_GRUPO IN ('A','B','F') "
	   titulo:=ALLTRIM(titulo)+'-Linha Institucional'   
	elseif MV_PAR03 = 4 // Sacola
	   cQry+= "AND B1_GRUPO IN ('G','H') "   
	   titulo:=ALLTRIM(titulo)+'-Sacola'   
	elseif MV_PAR03 = 5 // Todas as Linhas
	   titulo:=ALLTRIM(titulo)+'-Todas as Linhas'   
	endif
	
	cQry+="AND Z00.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND Z00.Z00_DATHOR <'"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"'   " +LF 
	//cQry+="AND Z00.Z00_APARA = '' "   +LF  // SEM APARA 
	cQry+="AND Z00.Z00_MAQ NOT IN ('','XXX')    " +LF 
	cQry+="AND Z00.D_E_L_E_T_ != '*'    " +LF 
	cQry+="GROUP BY Z00_MAQ,Z00_LADO,Z00_CODIGO    " +LF 
	cQry+="ORDER BY VIA_IMPRESSAO,Z00_MAQ ,Z00_LADO   " +LF 

ELSE

	// CONSULTA CARRINHO 
	
	DataI:=DtoS(MV_PAR01)
	DataF:=DtoS(MV_PAR02+1)
	hora1:=Left(cTURNO1,5)
	hora2:=Left(cTURNO2,5)
	hora3:=Left(cTURNO3,5)
	
	cQry:= " "
	
	cQry:= "SELECT "
	
	cQry+= "VIA_IMPRESSAO=CASE WHEN SUBSTRING(ZZ2_MAQ,1,2) IN ('C0','C1','P0','P1','S0','S1') THEN '1' ELSE CASE WHEN SUBSTRING(ZZ2_MAQ,1,2) IN ('I0','I1') THEN '2' ELSE CASE WHEN (ZZ2_MAQ) IN ('CX','ICVR','MONT','CVP','PLAST') THEN '3' ELSE CASE WHEN SUBSTRING(ZZ2_MAQ,1,2) IN ('E0','E1','A0','A1') THEN '4' ELSE CASE WHEN (ZZ2_MAQ) IN ('EXT','COST') THEN '5' ELSE '6' END END END END END , "
	cQry+= "ZZ2_MAQ AS MAQ, "
	cQry+= "ZZ2_LADO AS LADO , "
	cQry+= "B1_COD AS PRODUTO, "
	cQry+= "T1_MR=SUM(CASE WHEN TURNO='1' THEN  PESO/B1_PESO ELSE 0 END) , "
	cQry+= "T1_KG=SUM(CASE WHEN TURNO='1' THEN  PESO ELSE 0 END) , "
	cQry+= "T2_MR=SUM(CASE WHEN TURNO='2' THEN  PESO/B1_PESO ELSE 0 END) , "
	cQry+= "T2_KG=SUM(CASE WHEN TURNO='2' THEN  PESO ELSE 0 END) , "
	cQry+= "T3_MR=SUM(CASE WHEN TURNO='3' THEN  PESO/B1_PESO ELSE 0 END) , "
	cQry+= "T3_KG=SUM(CASE WHEN TURNO='3' THEN  PESO ELSE 0 END ) "
	
	cQry+= "FROM ( "
	
	cQry+= "SELECT  "
	cQry+= "ZZ2_MAQ ,ZZ2_LADO,B1_COD,B1_PESO, "
	cQry+= "TURNO=CASE WHEN ZZ2_HORA>= '"+hora1+"' AND ZZ2_HORA< '"+hora2+"'  THEN '1' "
	cQry+= "ELSE CASE WHEN ZZ2_HORA>='"+hora2+"' AND ZZ2_HORA< '"+hora3+"' THEN '2' "
	cQry+= "ELSE CASE WHEN (ZZ2_HORA>='"+hora3+"' OR ZZ2_HORA<'24:00' )AND (ZZ2_HORA>='00:00' OR ZZ2_HORA < '"+hora1+"'  )THEN '3' "
	cQry+= "ELSE 'XXXX' END END END, "
	cQry+= "PESO=ISNULL(sum(ZZ2.ZZ2_QUANT),0) "
	cQry+= "FROM ZZ2020 ZZ2 WITH (NOLOCK),  SC2020 WITH (NOLOCK),  SB1010 SB1 WITH (NOLOCK)  "
	cQry+= "WHERE "
	cQry+= "(ZZ2_DATA+ZZ2_HORA >= '"+DataI+hora1+"' AND ZZ2_DATA+ZZ2_HORA <'"+DataF+hora1+"') "
	
	cQry+= "AND C2_PRODUTO=B1_COD  "
	cQry+= "AND ZZ2_OP=C2_NUM+C2_ITEM+C2_SEQUEN  "
	
	if MV_PAR03 = 1 //Linha Hospitalar
	   cQry+= "AND B1_GRUPO IN ('C') "
	   titulo:=ALLTRIM(titulo)+'-Linha Hospitalar'
	elseif MV_PAR03 = 2 //Linha Domestica
	   cQry+= "AND B1_GRUPO IN ('D','E') "
	   titulo:=ALLTRIM(titulo)+'-Linha Domestica'
	elseif MV_PAR03 = 3 // Linha Institucional
	   cQry+= "AND B1_GRUPO IN ('A','B','F') "
	   titulo:=ALLTRIM(titulo)+'-Linha Institucional'   
	elseif MV_PAR03 = 4 // Sacola
	   cQry+= "AND B1_GRUPO IN ('G','H') "   
	   titulo:=ALLTRIM(titulo)+'-Sacola'   
	elseif MV_PAR03 = 5 // Todas as Linhas
	   titulo:=ALLTRIM(titulo)+'-Todas as Linhas'   
	endif
	
	cQry+= "AND ZZ2.D_E_L_E_T_ = ' ' "
	
	cQry+= "GROUP BY "
	cQry+= "ZZ2_MAQ,ZZ2_LADO,B1_COD,B1_PESO, "
	cQry+= "CASE WHEN ZZ2_HORA>= '"+hora1+"' AND ZZ2_HORA< '"+hora2+"'  THEN '1' "
	cQry+= "ELSE CASE WHEN ZZ2_HORA>='"+hora2+"' AND ZZ2_HORA< '"+hora3+"' THEN '2' "
	cQry+= "ELSE CASE WHEN (ZZ2_HORA>='"+hora3+"' OR ZZ2_HORA<'24:00' )AND (ZZ2_HORA>='00:00' OR ZZ2_HORA < '"+hora1+"'  )THEN '3' "
	cQry+= "ELSE 'XXXX' END END END "
	
	cQry+= ") AS TABX "
	
	
	cQry+= "GROUP BY ZZ2_MAQ,ZZ2_LADO,B1_COD "
	cQry+= "ORDER BY VIA_IMPRESSAO,MAQ ,LADO  "
	
	// FIM DA CONSULTA CARRINHO 

ENDIF

TCQUERY cQry NEW ALIAS "TMP"

If MV_PAR04=1  // Analitico
   titulo:=ALLTRIM(titulo)+'-Analitico'        
ElseIf MV_PAR04=2  // Sintetico
   titulo:=ALLTRIM(titulo)+'-Sintetico'        
Endif


If MV_PAR05=1  // Pesagem 
   titulo:=ALLTRIM(titulo)+'-Pesagem'        
Else  // Carrinho
   titulo:=ALLTRIM(titulo)+'-Carrinho'        
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TMP->(dbGoTop())
While TMP->( !EOF() )
   
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

   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 9
 
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   
cVia:=TMP->VIA_IMPRESSAO 
Do While TMP->( !EOF() ) .AND. TMP->VIA_IMPRESSAO ==cVia
     
   T1_MR:=T2_MR:=T3_MR:=0
   T1_KG:=T2_KG:=T3_KG:=0
   nApara:=0
   cMaq:=TMP->MAQ    
   Do While TMP->( !EOF() ) .AND.TMP->MAQ==cMaq 
	   cLado:=TMP->LADO
	   lOk:=.T.
	   Do While TMP->( !EOF() ) .AND.TMP->MAQ==cMaq .AND. TMP->LADO==cLado	
	      If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	        nLin := 9
	      Endif
   	     if MV_PAR04=1  // Analitico
	   	      IF (TMP->T1_MR!=0 .OR. TMP->T1_KG!=0 .OR.TMP->T2_MR!=0 .OR.TMP->T2_KG!=0 .OR.TMP->T3_MR!=0 .OR.TMP->T3_KG!=0 )
		   	      If lOk
		   	         @nLin++,00 PSAY alltrim(TMP->MAQ)+' - '+TMP->LADO 
		   	         lOk:=.F.
		   	      Endif
		   	      @nLin,00  PSAY SUBSTR(TMP->PRODUTO,1,10)

			      // EXCEL 
			      _FATPROD:=iif(empty(TMP->PRODUTO),0,FatProd(TMP->PRODUTO))
			      _CARTPROD:=iif(empty(TMP->PRODUTO),0,CartProd(TMP->PRODUTO))
   			      AADD(_aArra,{TMP->MAQ,TMP->LADO,TMP->PRODUTO,TMP->T1_MR,TMP->T1_KG,0,TMP->T2_MR,TMP->T2_KG,0,TMP->T3_MR,TMP->T3_KG,0,TMP->T1_MR+TMP->T2_MR+TMP->T3_MR,TMP->T1_KG+TMP->T2_KG+TMP->T3_KG,0,0,0})
   			      _aArra[LEN(_aArra)][16]:=_FATPROD
			      _aArra[LEN(_aArra)][17]:=_CARTPROD
                  //
			      
			      // producao 
			      Escreve(TMP->T1_MR,TMP->T1_KG,TMP->T2_MR,TMP->T2_KG,TMP->T3_MR,TMP->T3_KG,cMaq,@nLin,'',TMP->LADO)
			      // Faturamento 		          
		          @nLin,164 PSAY transform(_FATPROD,"@E 99,999,999.99") 
			      //Carteira
			      @nLin,179 PSAY transform(_CARTPROD,"@E 99,999,999.99")
			      			      
			      nLin := nLin + 1 // Avanca a linha de impressao
	          ENDIF 
	     ENDIF 
	      // variavel 1 Turno
	      TOT_T1_MR+=TMP->T1_MR;SUB_T1_MR+=TMP->T1_MR;T1_MR+=TMP->T1_MR
	      ;TOT_T1_KG+=TMP->T1_KG;SUB_T1_KG+=TMP->T1_KG;T1_KG+=TMP->T1_KG	      
    	  // variavel 2 Turno
	      TOT_T2_MR+=TMP->T2_MR;SUB_T2_MR+=TMP->T2_MR;T2_MR+=TMP->T2_MR
          ;TOT_T2_KG+=TMP->T2_KG;SUB_T2_KG+=TMP->T2_KG;T2_KG+=TMP->T2_KG
          // variavel 3 Turno
	      TOT_T3_MR+=TMP->T3_MR;SUB_T3_MR+=TMP->T3_MR;T3_MR+=TMP->T3_MR
          ;TOT_T3_KG+=TMP->T3_KG;SUB_T3_KG+=TMP->T3_KG;T3_KG+=TMP->T3_KG
	      //
	      IncRegua()
	      TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	   Enddo
   EndDo
      // resumo da Maquina 
      If MV_PAR04=1  // Analitico
         @nLin++,00  PSAY replicate('-',220)
	  Endif
	  @nLin,00  PSAY ALLTRIM(cMaq)
      AADD(_aArra,{ALLTRIM(cMaq),'','',T1_MR,T1_KG,0,T2_MR,T2_KG,0,T3_MR,T3_KG,0,T1_MR+T2_MR+T3_MR,T1_KG+T2_KG+T3_KG,0,0,0})
	  Escreve(T1_MR,T1_KG,T2_MR,T2_KG,T3_MR,T3_KG,'',@nLin,'','')
      nLin := nLin + iif(MV_PAR04=1,2,1) // Avanca a linha de impressao
      
      IF  SUBSTR(TMP->MAQ,1,1)!= SUBSTR(cMaq,1,1)
          @nLin++,00  PSAY replicate('-',220)
          @nLin,00  psay 'Sub'
          AADD(_aArra,{'Sub','','',SUB_T1_MR,SUB_T1_KG,0,SUB_T2_MR,SUB_T2_KG,0,SUB_T3_MR,SUB_T3_KG,0,SUB_T1_MR+SUB_T2_MR+SUB_T3_MR,SUB_T1_KG+SUB_T2_KG+SUB_T3_KG,0,0,0})
          Escreve(SUB_T1_MR,SUB_T1_KG,SUB_T2_MR,SUB_T2_KG,SUB_T3_MR,SUB_T3_KG,cMaq,@nLin,cVia,'')
          nLin := nLin + 1 // Avanca a linha de impressao
          SUB_T1_MR:=SUB_T2_MR:=SUB_T3_MR:=0
          SUB_T1_KG:=SUB_T2_KG:=SUB_T3_KG:=0     
      ENDIF	    
EndDo
@nLin++,00  PSAY replicate('-',220)
@nLin,00  psay 'Total'
AADD(_aArra,{'Total','','',TOT_T1_MR,TOT_T1_KG,0,TOT_T2_MR,TOT_T2_KG,0,TOT_T3_MR,TOT_T3_KG,0,TOT_T1_MR+TOT_T2_MR+TOT_T3_MR,TOT_T1_KG+TOT_T2_KG+TOT_T3_KG,0,0,0})
Escreve(TOT_T1_MR,TOT_T1_KG,TOT_T2_MR,TOT_T2_KG,TOT_T3_MR,TOT_T3_KG,'',@nLin,cVia,'')
nLin := nLin + 1 // Avanca a linha de impressao
TOT_T1_MR:=TOT_T2_MR:=TOT_T3_MR:=0
TOT_T1_KG:=TOT_T2_KG:=TOT_T3_KG:=0
ENDDO

TMP->(DBCLOSEAREA())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


if MV_PAR06=2// SIM 

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY",titulo, _aCabe, _aArra}})})
	If !ApOleClient("MSExcel")
	    MsgAlert("Microsoft Excel não instalado!")
		Return()
	EndIf

ELSE	 // NAO 

	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
    MS_FLUSH()
    
ENDIF

Return

***************

Static Function Apara(cMaq,cTurno,cVia,cLado)

***************
Local cQry:=''
nRet:=0

cQry:="SELECT SUM(Z00_PESO) VALOR "
cQry+="FROM " + RetSqlName( "Z00" ) + " Z00 "
cQry+="WHERE 
// por maquina 
if !empty(cMaq) .AND. EMPTY(cVia)
   cQry+="Z00_MAQ='"+cMaq+"' "
Endif
if !empty(cLado)
   cQry+="AND Z00_LADO = '"+cLado+"' "
EndIf
// sub e total 
if  !empty(cVia)
   if !empty(cMaq)
      cQry+="substring(Z00_MAQ,1,1)='"+substr(cMaq,1,1)+"' "
      cQry+="AND " 
   endif
   cQry+="CASE WHEN SUBSTRING(Z00_MAQ,1,2) IN ('C0','C1','P0','P1','S0','S1') THEN '1'  "
   cQry+="ELSE CASE WHEN SUBSTRING(Z00_MAQ,1,2) IN ('I0','I1') THEN '2'  "
   cQry+="ELSE CASE WHEN (Z00_MAQ) IN ('CX','ICVR','MONT','CVP','PLAST') THEN '3' "
   cQry+="ELSE CASE WHEN SUBSTRING(Z00_MAQ,1,2) IN ('E0','E1','A0','A1') THEN '4' "
   cQry+="ELSE CASE WHEN (Z00_MAQ) IN ('EXT','COST') THEN '5'  "
   cQry+="ELSE '6' END END END END END='"+cVia+"' "
Endif



// 1Turno
If cTurno='1'
   cQry+="AND Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND  Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO2,5)+"'  " 
   cQry+="AND CASE WHEN Z00_HORA >= '"+Left(cTURNO1,5)+"' AND Z00_HORA < '"+Left(cTURNO2,5)+"'  THEN '1'  END ='1' " 
Endif
// 2Turno
If cTurno='2'
   cQry+="AND Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO2,5)+"' AND Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO3,5)+"'  " 
   cQry+="AND CASE WHEN Z00_HORA >= '"+Left(cTURNO2,5)+"' AND Z00_HORA <'"+Left(cTURNO3,5)+"'  THEN '2'  END ='2' "
Endif
// 3Turno
If cTurno='3'
   cQry+="AND Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO3,5)+"' AND Z00_DATHOR < '"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"'   "     
   cQry+="AND CASE WHEN ( (Z00_HORA >= '"+Left(cTURNO3,5)+"' AND Z00_HORA <= '24:00')  OR (Z00_HORA >= '00:00' AND Z00_HORA < '"+Left(cTURNO1,5)+"' ) ) THEN '3' END='3' " 
Endif
// total
If cTurno='T'
   cQry+="AND Z00.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND Z00.Z00_DATHOR <'"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"'   " 
Endif
//
cQry+="AND Z00_APARA NOT IN ('','W')  "
cQry+="AND Z00.Z00_FILIAL = '"+xfilial('Z00')+"' "
cQry+="AND Z00.D_E_L_E_T_ = '' "
TCQUERY cQry NEW ALIAS "AUUX"

IF AUUX->(!EOF())
   nRet:=AUUX->VALOR
ENDIF

AUUX->(DBCLOSEAREA())

Return nRet


***************

Static Function FatProd(cCod)

***************

Local cQry:=''
Local cProd1:=cProd2:=''
nRet:=0

cCod:=AllTrim( cCod )

If Len( cCod  ) >= 8
   cProd1:=U_transgen(cCod)  // normal 
   cProd2:=cCod  // gerenrico
else
   cProd1:=cCod  // normal 
   cProd2:=SUBSTR(cCod,1,1)+'D'+SUBSTR(cCod,2,3)+'6'+SUBSTR(cCod,5,2)   // gerenrico
Endif

cQry:="SELECT  "

cQry+="SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  "
cQry+="ELSE (D2_QUANT*CASE WHEN B1_SETOR='39' THEN 1 ELSE D2_PESO END ) END ) VALOR "

cQry+="FROM " + RetSqlName( "SD2" ) + " SD2 WITH (NOLOCK), " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK), " + RetSqlName( "SF2" ) + " SF2 WITH (NOLOCK)  "
cQry+="WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQry+="AND B1_COD IN ('"+cProd1+"','"+cProd2+"') "
cQry+="AND D2_TIPO = 'N'  "
cQry+="AND D2_TP != 'AP' "
//cQry+="AND RTRIM(D2_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949')  "
cQry+="AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQry+="AND F2_DUPL <> ' '  "
cQry+="AND D2_COD = B1_COD  "
cQry+="AND SD2.D_E_L_E_T_ = ''  "
cQry+="AND SB1.D_E_L_E_T_ = ''  "
cQry+="AND SF2.D_E_L_E_T_ = ''  "
TCQUERY cQry NEW ALIAS "FATPROD"

IF FATPROD->(!EOF())
   nRet:=FATPROD->VALOR
ENDIF

FATPROD->(DBCLOSEAREA())

Return nRet


***************

Static Function CartProd(cCod)

***************

Local cQry:=''
Local cProd1:=cProd2:=''
nRet:=0

cCod:=AllTrim( cCod )

If Len( cCod  ) >= 8
   cProd1:=U_transgen(cCod)  // normal 
   cProd2:=cCod  // gerenrico
else
   cProd1:=cCod  // normal 
   cProd2:=SUBSTR(cCod,1,1)+'D'+SUBSTR(cCod,2,3)+'6'+SUBSTR(cCod,5,2)   // gerenrico
Endif

cQry:="SELECT "

cQry+="SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS VALOR "

cQry+="FROM " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK), " + RetSqlName( "SC5" ) + " SC5 WITH (NOLOCK), " + RetSqlName( "SC6" ) + " SC6 WITH (NOLOCK), " + RetSqlName( "SC9" ) + " SC9 WITH (NOLOCK), " + RetSqlName( "SA1" ) + " SA1 WITH (NOLOCK) "
cQry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQry+="SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQry+="SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQry+="SC6.C6_TES != '540'  AND "
cQry+="SC6.C6_PRODUTO IN ('"+cProd1+"','"+cProd2+"') "
cQry+="and SB1.B1_FILIAL ='"+XFILIAL('SB1')+"' AND "
cQry+="SB1.D_E_L_E_T_ = ''  AND "
cQry+="SC5.D_E_L_E_T_ = ''  AND "
cQry+="SC6.D_E_L_E_T_ = ''  AND "
cQry+="SC9.D_E_L_E_T_ = ''  AND "
cQry+="SA1.A1_FILIAL = '"+XFILIAL('SA1')+"'  AND "
cQry+="SA1.D_E_L_E_T_ = ''   "

TCQUERY cQry NEW ALIAS "CATPROD"

IF CATPROD->(!EOF())
   nRet:=CATPROD->VALOR
ENDIF

CATPROD->(DBCLOSEAREA())

Return nRet  

***************

Static Function  Escreve(P1_MR,P1_KG,P2_MR,P2_KG,P3_MR,P3_KG,cMaq,nLin,cVia,cLado)

***************
LOCAL nApara:=0
local nCol:=12
// 1turno
@nLin,12  PSAY transform( P1_MR,"@E 99,999,999.99")
@nLin,27  PSAY transform( P1_KG,"@E 99,999,999.99")
// 2turno
@nLin,50  PSAY transform( P2_MR,"@E 99,999,999.99")
@nLin,65  PSAY transform( P2_KG,"@E 99,999,999.99")
// 3turno
@nLin,88  PSAY transform( P3_MR,"@E 99,999,999.99")
@nLin,103 PSAY transform( P3_KG,"@E 99,999,999.99")
// total
@nLin,126 PSAY transform( P1_MR+P2_MR+P3_MR,"@E 99,999,999.99")
@nLin,141 PSAY transform( P1_KG+P2_KG+P3_KG,"@E 99,999,999.99")



if   !empty(cMaq) .or. !empty(cVia)
	// 1Turno
	nApara:=Apara(cMaq,'1',cVia,cLado)
	nApara:=(nApara/(nApara+P1_KG))*100
	@nLin,42  PSAY transform( nApara,"@E 999.99")
	_aArra[LEN(_aArra)][6]:=nApara
	// 2Turno
	nApara:=Apara(cMaq,'2',cVia,cLado)
	nApara:=(nApara/(nApara+P2_KG))*100
	@nLin,80  PSAY transform( nApara,"@E 999.99")
	_aArra[LEN(_aArra)][9]:=nApara
	// 3Turno
	nApara:=Apara(cMaq,'3',cVia,cLado)
	nApara:=(nApara/(nApara+P3_KG))*100
	@nLin,118 PSAY transform( nApara,"@E 999.99")
	_aArra[LEN(_aArra)][12]:=nApara
	// Total
	nApara:=Apara(cMaq,'T',cVia,cLado)
	nApara:=(nApara/(nApara+(P1_KG+P2_KG+P3_KG)))*100
	@nLin,156 PSAY transform( nApara,"@E 999.99")
	_aArra[LEN(_aArra)][15]:=nApara
Endif

Return 