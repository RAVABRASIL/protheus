#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO20    บ Autor ณ AP6 IDE            บ Data ณ  15/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PCPR040()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

local avetor         :={'Saco','Caixa'}
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Historico Pedido"
Local cPict          := ""
Local titulo         := "Historico Pedido"
Local nLin           := 80
                       //          10        20        30        40        50        60        70        80        90        100       110       120       130
                       //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Regra          Institucional  Hospitalar     Domestica      Pedido  Data      Data        Data        Data        Data        Data        Dias        Dias        Dias        Dias    "
Local Cabec2         := "                                                                    Pedido    Programada  Financeiro  Estoque     Logistica   Expedicao   Financeiro  Estoque     Logistica   Expedicao                               "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR040" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR040" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte('PCPR040',.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"PCPR040",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Historico Pedido "+avetor[MV_PAR03]+' De '+dtoc(MV_PAR01)+' Ate '+dtoc(MV_PAR02)

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  15/01/14   บฑฑ
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
local cQry:=''
Local aFilial:={'01','06'}

cQry:="SELECT "
cQry+="REGRA=CASE "
cQry+="WHEN( INSTITUCIONAL>HOSPITALAR AND  INSTITUCIONAL>DOMESTICA )THEN 'INSTITUCIONAL' "
cQry+="WHEN( HOSPITALAR>DOMESTICA AND HOSPITALAR>INSTITUCIONAL  )THEN 'HOSPITALAR' "
cQry+="WHEN( DOMESTICA>HOSPITALAR AND DOMESTICA>INSTITUCIONAL  )THEN 'DOMESTICA' "
cQry+="ELSE 'OUTROS'"
cQry+="END, "
cQry+="INSTITUCIONAL, "
cQry+="HOSPITALAR, "
cQry+="DOMESTICA, "
cQry+="PEDIDO, "
cQry+="ISNULL(DT_PEDIDO,'') DT_PEDIDO, "
cQry+="ISNULL(DT_ENTREG,'') DT_ENTREG, "
cQry+="ISNULL(DT_FINANCEIRO,'')DT_FINANCEIRO, "
cQry+="ISNULL(DT_ESTOQUE,'') DT_ESTOQUE, "
cQry+="ISNULL(DT_LOGISTICA,'') DT_LOGISTICA, "
cQry+="ISNULL(DT_EXPEDICAO,'')DT_EXPEDICAO, "
//cQry+="ISNULL(CASE WHEN DT_FINANCEIRO <>' ' THEN CAST(CONVERT(DATETIME,DT_FINANCEIRO) - CONVERT(DATETIME,CASE WHEN DT_FINANCEIRO>DT_ENTREG THEN DT_ENTREG ELSE CASE WHEN DT_FINANCEIRO>DT_PEDIDO THEN DT_PEDIDO ELSE DT_FINANCEIRO END  END) AS INTEGER)END,'') as DIAS_FINANCEIRO, "
cQry+="ISNULL(CASE WHEN DT_FINANCEIRO <>' ' THEN CAST(CONVERT(DATETIME,DT_FINANCEIRO) - CONVERT(DATETIME,CASE WHEN DT_FINANCEIRO>DT_ENTREG THEN DT_ENTREG ELSE DT_FINANCEIRO  END) AS INTEGER)END,'') as DIAS_FINANCEIRO, "
//cQry+="ISNULL(CASE WHEN DT_ESTOQUE<>' ' THEN CAST(CONVERT(DATETIME,DT_ESTOQUE) - CONVERT(DATETIME,CASE WHEN DT_FINANCEIRO>DT_ENTREG THEN DT_FINANCEIRO ELSE CASE WHEN DT_ESTOQUE < DT_ENTREG THEN DT_FINANCEIRO ELSE DT_ENTREG END END) AS INTEGER) END,'') as DIAS_ESTOQUE, "
cQry+="ISNULL(CASE WHEN DT_ESTOQUE<>' ' THEN CAST(CONVERT(DATETIME,DT_ESTOQUE) - CONVERT(DATETIME,CASE WHEN DT_FINANCEIRO>DT_ENTREG THEN DT_FINANCEIRO ELSE CASE WHEN DT_ESTOQUE < DT_ENTREG THEN DT_ESTOQUE ELSE DT_ENTREG END END) AS INTEGER) END,'') as DIAS_ESTOQUE, "
cQry+="ISNULL(CASE WHEN DT_LOGISTICA<>' ' THEN CAST(CONVERT(DATETIME,DT_LOGISTICA) - CONVERT(DATETIME,CASE WHEN DT_ESTOQUE<>'' THEN  ISNULL(DT_ESTOQUE,'') ELSE ISNULL(DT_LOGISTICA,'') END) AS INTEGER) END,'') as DIAS_LOGISTICA, "
cQry+="ISNULL(CASE WHEN DT_EXPEDICAO<>' ' THEN CAST(CONVERT(DATETIME,DT_EXPEDICAO) - CONVERT(DATETIME,DT_LOGISTICA) AS INTEGER) END,'') as DIAS_EXPEDICAO "
cQry+="FROM ( "
cQry+="select "
cQry+="INSTITUCIONAL=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN  ) / SB1.B1_CONV),0) FROM SC6020 SC6, SB1010 SB1 WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_GRUPO in('A','B','G') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' ), "
cQry+="HOSPITALAR=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN ) / SB1.B1_CONV ),0) FROM SC6020 SC6, SB1010 SB1 WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_GRUPO in('C') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' ),  "
cQry+="DOMESTICA=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN  ) / SB1.B1_CONV),0) FROM SC6020 SC6, SB1010 SB1 WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_GRUPO in('D','E') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' ) ,  "
cQry+="C5_NUM PEDIDO,ISNULL(C5_EMISSAO,'') DT_PEDIDO,ISNULL(C5_ENTREG,'') DT_ENTREG, "
cQry+="ISNULL((SELECT TOP 1 ZB3_DATALI FROM ZB3020 ZB3 WHERE ZB3_PEDIDO = SC5.C5_NUM AND ZB3.D_E_L_E_T_ = '' ORDER BY ZB3_DATALI), C9_DATALIB) DT_FINANCEIRO, "
cQry+="ISNULL(C9_DTBLEST,'') DT_ESTOQUE, "
cQry+="ISNULL(D2_EMISSAO,'') DT_LOGISTICA, "
cQry+="ISNULL(F2_DTEXP,'') DT_EXPEDICAO "
cQry+="FROM SC5020 SC5 WITH (NOLOCK) "
cQry+="JOIN SC6020 SC6 WITH (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C6_NUM=C5_NUM  AND C6_CLI+C6_LOJA=C5_CLIENTE+C5_LOJACLI AND SC6.C6_BLQ <> 'R'  AND SC6.D_E_L_E_T_='' "
cQry+="JOIN SC9020 SC9 WITH (NOLOCK) ON C5_FILIAL = C9_FILIAL AND C9_PEDIDO=C5_NUM  and SC9.C9_ITEM = SC6.C6_ITEM  AND SC9.D_E_L_E_T_=''  "
cQry+="LEFT JOIN SD2020 SD2 WITH (NOLOCK) ON C5_FILIAL = D2_FILIAL AND D2_PEDIDO=C5_NUM AND D2_CLIENTE+D2_LOJA=C5_CLIENTE+C5_LOJACLI AND D2_COD=C6_PRODUTO  AND SD2.D_E_L_E_T_='' "
cQry+="LEFT JOIN SF2020 SF2 WITH (NOLOCK) ON C5_FILIAL = F2_FILIAL AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA  AND SF2.D_E_L_E_T_='' "
cQry+="WHERE  "
cQry+="C5_FILIAL IN ('01','06') "
cQry+="and C5_ENTREG between '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' "
cQry+="AND C5_TIPO='N'  "
cQry+="AND SC6.C6_BLQ <> 'R'  "
cQry+="AND C5_CLIENTE NOT IN ('031732','031733') "
cQry+="AND C9_PEDIDO=C5_NUM  and SC9.C9_ITEM = SC6.C6_ITEM AND SC9.D_E_L_E_T_='' "
cQry+="AND SC5.D_E_L_E_T_='' "
cQry+="AND C6_NUM=C5_NUM  AND SC6.D_E_L_E_T_='' "
cQry+="AND C6_NUM=C5_NUM  AND C5_CLIENTE+C5_LOJACLI=C6_CLI+C6_LOJA AND SC6.D_E_L_E_T_='' "
cQry+=") AS TABX  "
cQry+="GROUP BY INSTITUCIONAL,HOSPITALAR,DOMESTICA,PEDIDO,DT_PEDIDO,DT_FINANCEIRO,DT_ESTOQUE,DT_LOGISTICA,DT_EXPEDICAO,DT_ENTREG "
cQry+="ORDER BY PEDIDO,DT_PEDIDO,DT_FINANCEIRO,DT_ESTOQUE,DT_LOGISTICA,DT_EXPEDICAO,DT_ENTREG "

MemoWrite("C:\Temp\PCPR040.SQL",cQry)

TCQUERY cQry NEW ALIAS "TMPZ"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

TMPZ->(dbGoTop())
While TMPZ->(!EOF())

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    nCOl:=0
    @nLin,nCOl PSAY TMPZ->REGRA 
    nCOl+=15    
    @nLin,nCOl PSAY TRANSFORM(TMPZ->INSTITUCIONAL,"@E 99,999,999.99")
    nCOl+=15    
    @nLin,nCOl PSAY TRANSFORM(TMPZ->HOSPITALAR,"@E 99,999,999.99")
    nCOl+=15    
    @nLin,nCOl PSAY TRANSFORM(TMPZ->DOMESTICA,"@E 99,999,999.99")
    nCOl+=15    
    @nLin,nCOl PSAY TMPZ->PEDIDO 
    nCOl+=8
    @nLin,nCOl PSAY dtoc(stod(TMPZ->DT_PEDIDO))
    nCOl+=12
    @nLin,nCOl PSAY dtoc(stod(TMPZ->DT_ENTREG)) 
    nCOl+=12
    @nLin,nCOl PSAY dtoc(stod(TMPZ->DT_FINANCEIRO))
    nCOl+=12                                                            
    @nLin,nCOl PSAY dtoc(stod(TMPZ->DT_ESTOQUE))
    nCOl+=12
    @nLin,nCOl PSAY dtoc(stod(TMPZ->DT_LOGISTICA))
    nCOl+=12
    @nLin,nCOl PSAY dtoc(stod(TMPZ->DT_EXPEDICAO))
    nCOl+=12
    @nLin,nCOl PSAY TRANSFORM(TMPZ->DIAS_FINANCEIRO,"@E 99999999")
    nCOl+=12
    @nLin,nCOl PSAY TRANSFORM(TMPZ->DIAS_ESTOQUE,"@E 99999999")
    nCOl+=12
    @nLin,nCOl PSAY TRANSFORM(TMPZ->DIAS_LOGISTICA,"@E 99999999")
    nCOl+=12
    @nLin,nCOl PSAY TRANSFORM(TMPZ->DIAS_EXPEDIDCAO,"@E 99999999")
         
    nLin := nLin + 1 // Avanca a linha de impressao

    TMPZ->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TMPZ->(DbCloseArea())

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
