#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO14    บ Autor ณ AP6 IDE            บ Data ณ  19/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FATPCP01()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Analise de Programacao "
Local cPict          := ""
Local titulo         := "Analise de Programacao "
Local nLin           := 80
                      //          10        20        30        40        50        60        70        80        90        100
                      //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789001234567890
Local Cabec1         := "             Producao        Vendas      Faturamento           Regra                                               Analise "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATPCP01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATPCP01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := ""

PERGUNTE('FATPCP01',.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel  := SetPrint(cString,NomeProg,"FATPCP01",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
titulo := "Analise de Programacao de "+Dtoc(MV_PAR01)+' Ate '+Dtoc(MV_PAR02)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  19/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
LOCAL cQry:=''
nFatC:=nFatS:=0

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")


SetRegua(0)
incregua()
//
// PRODUCAO 
// SACO
cQry:="SELECT	ISNULL(SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO "
cQry+="FROM Z00020 Z00  "
cQry+="WHERE  "
cQry+="Z00_FILIAL = '" + xFilial( "Z00" ) + "' "
//cQry+= "AND Z00_DATHOR BETWEEN '" + Dtos(MV_PAR01) + "05:35'" + " AND '" + Dtos(MV_PAR02+1) + "05:34' "
cQry+= "AND Z00_DATHOR>='"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"'  AND Z00_DATHOR<'"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"' "
cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQry+="AND Z00.Z00_APARA = ' ' "
cQry+="AND Z00.D_E_L_E_T_ = ' '  "
TCQUERY cQry NEW ALIAS 'PROD_S'
incregua()
// CAIXA
cQry:="SELECT	ISNULL(SUM(Z00.Z00_QUANT),0) AS PESO "
cQry+="FROM Z00020 Z00 "
cQry+="WHERE "
cQry+="Z00_FILIAL = '" + xFilial( "Z00" ) + "'  "
//cQry+= "AND Z00_DATHOR BETWEEN '" + Dtos(MV_PAR01) + "05:35'" + " AND '" + Dtos(MV_PAR02+1) + "05:34' "
cQry+= "AND Z00_DATHOR>='"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"'  AND Z00_DATHOR<'"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"' "
//cQry+="AND Z00.Z00_MAQ IN ('CX','ICVR','MONT','CVP','PLAST' )  " 
cQry+="AND Z00.Z00_MAQ = 'MONT'  "
cQry+="AND Z00.Z00_APARA = ' '  "
cQry+="AND Z00.D_E_L_E_T_ = ' '  "
TCQUERY cQry NEW ALIAS 'PROD_C'
incregua()
// VENDAS 
// SACOS
cQry:="SELECT SUM(C6_QTDVEN * B1_PESO) AS VENDAS "
cQry+="FROM SB1010 SB1, SC5020 SC5 , SC6020 SC6,SC9020 SC9  "
cQry+="WHERE   SC6.C6_PRODUTO = SB1.B1_COD "
cQry+="AND SC5.C5_NUM = SC6.C6_NUM  "
cQry+="AND RTRIM(SB1.B1_TIPO) != 'AP' " //Despreza Apara 
cQry+="AND RTRIM(SB1.B1_SETOR) <> '39' "
cQry+="AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949')  "
cQry+="AND SB1.B1_TIPO = 'PA' "
cQry+="AND SC6.C6_TES NOT IN( '540','516')  "
cQry+="AND SC6.C6_CLI NOT IN ('031732','031732' ) "//Despreza faturamento entre filiais
//cQry+="AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'  "
cQry+="AND SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM "
//cQry+="AND SC9.C9_BLCRED IN ('','10') " // ''- LIBERADO PELO FIANCEIRO E 10 FATURADO 
// NOVA LIBERACAO DE CRETIDO
cQry+="AND SC9.C9_BLCRED IN ('','04','10') " // ''- LIBERADO PELO FIANCEIRO E 10 FATURADO 
cQry+="AND C5_ENTREG BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'  "
cQry+="AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' "
cQry+="AND SB1.D_E_L_E_T_ = ''  "
cQry+="AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' "
cQry+="AND SC5.D_E_L_E_T_ = '' "
cQry+="AND SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' "
cQry+="AND SC6.D_E_L_E_T_ = ''  "
cQry+="AND SC9.D_E_L_E_T_ = ''  "
TCQUERY cQry NEW ALIAS 'VEND_S'
incregua()
// CAIXA
cQry:="SELECT SUM(C6_QTDVEN ) AS VENDAS "
cQry+="FROM SB1010 SB1, SC5020 SC5 , SC6020 SC6,SC9020 SC9 "
cQry+="WHERE   SC6.C6_PRODUTO = SB1.B1_COD "
cQry+="AND SC5.C5_NUM = SC6.C6_NUM  "
cQry+="AND RTRIM(SB1.B1_TIPO) != 'AP' " //Despreza Apara 
cQry+="AND RTRIM(SB1.B1_SETOR) = '39' "
cQry+="AND RTRIM(C6_CF) IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949') "
cQry+="AND SB1.B1_TIPO = 'PA' "
cQry+="AND SC6.C6_TES NOT IN( '540','516') "
cQry+="AND SC6.C6_CLI NOT IN ('031732','031732' ) "//Despreza faturamento entre filiais
//cQry+="AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
cQry+="AND SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM "
//cQry+="AND SC9.C9_BLCRED IN ('','10') " // ''- LIBERADO PELO FIANCEIRO E 10 FATURADO 
cQry+="AND SC9.C9_BLCRED IN ('','04','10') " // ''- LIBERADO PELO FIANCEIRO E 10 FATURADO 
cQry+="AND C5_ENTREG BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'  "
cQry+="AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' "
cQry+="AND SC5.D_E_L_E_T_ = '' "
cQry+="AND SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' "
cQry+="AND SC6.D_E_L_E_T_ = ''  "
cQry+="AND SC9.D_E_L_E_T_ = ''  "
TCQUERY cQry NEW ALIAS 'VEND_C'
incregua()
// FATURAMENTO 
cQry:="SELECT SETOR= CASE WHEN B1_SETOR='39' THEN 'CAIXA' ELSE 'SACO' END , "
cQry+="PESO=CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN Sum(0) "
cQry+="ELSE SUM((D2_QUANT-D2_QTDEDEV) * CASE WHEN B1_SETOR='39' THEN 1 ELSE D2_PESO END ) END  "
cQry+="FROM SD2020 SD2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK), SF2020 SF2 WITH (NOLOCK) "
cQry+="WHERE D2_EMISSAO BETWEEN '"+dTOS(MV_PAR01) +"' AND '"+dTOS(MV_PAR02) +"' "
cQry+="AND D2_FILIAL = '" + xFilial( "SD2" ) + "' AND D2_TIPO = 'N' " 
cQry+="AND D2_TP != 'AP'  "
//cQry+="AND RTRIM(D2_CF) IN ('511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949','6949','5922','6922','5116','6116' ) "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD " 
cQry+="AND SB1.D_E_L_E_T_ = '' " 
cQry+="AND D2_TES NOT IN ( '540','516') " 
cQry+="AND substrING(D2_COD,1,1) != 'M' "
//cQry+="AND D2_TES NOT IN ( '540','516') " 
//cQry+="AND substrING(D2_COD,1,1) != 'M' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA  "
// IGUAL AO CONSULTA 
cQry+="AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116' ) "
cQry+="AND SD2.D2_CLIENTE NOT IN ('031732','031732' ) "//Despreza faturamento entre filiais
//
cQry+="AND F2_DUPL <> ' '  " 
cQry+="AND SF2.D_E_L_E_T_ = ''   "
cQry+="GROUP BY B1_SETOR,D2_SERIE, F2_VEND1  "
cQry+="ORDER BY B1_SETOR,D2_SERIE, F2_VEND1  "
TCQUERY cQry NEW ALIAS 'FAT'
incregua()
//


FAT->( dbGoTop() )
Do While FAT->( !EOF() )
  If ALLTRIM(FAT->SETOR)='CAIXA'
     nFatC+=FAT->PESO
  ELSEIf ALLTRIM(FAT->SETOR)='SACO'
     nFatS+=FAT->PESO
  ENDIF
  INCREGUA()
  FAT->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica o cancelamento pelo usuario...                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If lAbortPrint
   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
   //Exit
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho do relatorio. . .                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif
   

// Coloque aqui a logica da impressao do seu programa...
// Utilize PSAY para saida na impressora. Por exemplo:
@nLin,00   PSAY "Saco "
@nLin,07   PSAY transform(PROD_S->PESO,"@E 999,999,999.99")
@nLin,23   PSAY transform(VEND_S->VENDAS,"@E 999,999,999.99")
@nLin,39   PSAY transform(nFatS,"@E 999,999,999.99")

if PROD_S->PESO >= VEND_S->VENDAS
   @nLin,63 PSAY 'Faturamento deveria ser Igual ou Maior a Vendas'
   IF nFatS>=VEND_S->VENDAS
      @nLin++,115 PSAY "Positivo"
   ELSE
      @nLin++,115 PSAY "Negativo"
   ENDIF
ELSE
   @nLin,63 PSAY 'Faturamento deveria ser Igual ou Maior a Producao'
   IF nFatS>=PROD_S->PESO
      @nLin++,115 PSAY "Positivo"
   ELSE
      @nLin++,115 PSAY "Negativo"
   ENDIF
ENDIF


/*
@nLin,63 PSAY iif(PROD_S->PESO >= VEND_S->VENDAS,'Faturamento deveria ser Igual ou Maior a Vendas',iif(PROD_S->PESO < VEND_S->VENDAS,'Faturamento deveria ser Igual ou Maior a Producao',)) 
@nLin++,115 PSAY
*/

@nLin++
@nLin,00   PSAY "Caixa "
@nLin,07   PSAY transform(PROD_C->PESO,"@E 999,999,999.99")
@nLin,23   PSAY transform(VEND_C->VENDAS,"@E 999,999,999.99")
@nLin,39   PSAY transform(nFatC,"@E 999,999,999.99")

if PROD_C->PESO >= VEND_C->VENDAS
   @nLin,63 PSAY 'Faturamento deveria ser Igual ou Maior a Vendas'
   IF nFatC>=VEND_C->VENDAS
      @nLin++,115 PSAY "Positivo"
   ELSE
      @nLin++,115 PSAY "Negativo"
   ENDIF
ELSE
   @nLin,63 PSAY 'Faturamento deveria ser Igual ou Maior a Producao'
   IF nFatC>=PROD_C->PESO
      @nLin++,115 PSAY "Positivo"
   ELSE
      @nLin++,115 PSAY "Negativo"
   ENDIF
ENDIF

/*
@nLin++,63 PSAY iif(PROD_C->PESO >= VEND_C->VENDAS,'Faturamento deveria ser Igual ou Maior a Vendas',iif(PROD_C->PESO < VEND_C->VENDAS,'Faturamento deveria ser Igual ou Maior a Producao',)) 
@nLin++,115 PSAY
*/
PROD_S->(DBCLOSEAREA())
PROD_C->(DBCLOSEAREA())
VEND_S->(DBCLOSEAREA())
VEND_C->(DBCLOSEAREA())
FAT->(DBCLOSEAREA())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
