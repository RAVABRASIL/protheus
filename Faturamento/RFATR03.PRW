#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'Topconn.ch'
#INCLUDE "ap5mail.ch"

***********************
User Function RFATR03()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "Vendas por Segmento"
Local cPict  := ""
Local titulo := cDesc3
Local nLin   := 80

Local Cabec1        := "Código  Segmento                                   Volume KG  Cobertura"
                     //"999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99.999.999    999.999
                     //"01234567890123456789012345678901234567890123456789012345678901234567890
                     //           1         2         3         4         5         6         7
Local Cabec2        := ""

Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RFATR03"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFATR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := ""

CriaSx1(cPerg)

if pergunte(cPerg,.T.)
   
   wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

   If nLastKey == 27
   	Return
   Endif

   SetDefault(aReturn,cString)

   If nLastKey == 27
      Return
   Endif

   nTipo := If(aReturn[4]==1,15,18)

   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
   
endif

Return


****************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
****************************************************

Local cQuery    := ""
Local lContinua := .T.
Local nTotVol := nTotCob := 0

SetRegua(0)

cQuery := "SELECT "
cQuery += "   SEGCOD, "
cQuery += "   SEGNOM, "
cQuery += "   VEN_KG=SUM(VEN_KG-DEV_KG), "
cQuery += "   COBERTURA=COUNT(CLIENTE) "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      CLIENTE = A1_COD, "
cQuery += "      SEGCOD  = A1_SATIV1, "
cQuery += "      SEGNOM  = UPPER((SELECT RTRIM(X5_DESCRI) FROM "+RetSqlName("SX5")+" SX5 WHERE X5_FILIAL = '01' AND X5_TABELA = 'T3' AND X5_CHAVE = A1_SATIV1 AND D_E_L_E_T_ <> '*')), "
cQuery += "      VEN_KG  = SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
cQuery += "      DEV_KG  = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0) "
cQuery += "   FROM  "
cQuery += "      "+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery += "      LEFT JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery += "      ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "      AND SC5.C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'  AND "
if !Empty(MV_PAR04)
   cQuery += "   SC5.C5_VEND1 LIKE '"+Alltrim(MV_PAR04)+"%' AND "
endif
cQuery += "      SC5.D_E_L_E_T_<>'*' "

cQuery += "      JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += "      ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND "
if !Empty(MV_PAR05)
   cQuery += "   SA1.A1_EST = '"+MV_PAR05+"' AND "
endif
cQuery += "      SA1.D_E_L_E_T_ <> '*'  "

cQuery += "      JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery += "      ON SA3.A3_COD = LEFT(SC5.C5_VEND1,4) AND "
if !Empty(MV_PAR03)
   cQuery += "   (SC5.C5_VEND1 LIKE '"+Alltrim(MV_PAR03)+"%' OR SA3.A3_SUPER LIKE '"+Alltrim(MV_PAR03)+"%' ) AND "
endif
cQuery += "      SA3.D_E_L_E_T_<>'*' "

cQuery += "      JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery += "      ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_<>'*'  "
cQuery += "      LEFT JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery += "      ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ <> '*' "
cQuery += "      AND SD2.D2_QTDEDEV > 0 "
cQuery += "   WHERE "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_COD,A1_SATIV1 "
cQuery += ") AS TABX "
cQuery += "GROUP BY "
cQuery += "   SEGCOD, "
cQuery += "   SEGNOM "
cQuery += "ORDER BY "
cQuery += "   VEN_KG DESC "
   
If Select("TMP") > 0
   DbSelectArea("TMP")
   DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

DbSelectArea("TMP")

if nLin > 55
   nLin := Cabec(Titulo,"PARAMETROS","",wnRel,Tamanho,nTipo)+1
endif

@nLin,000 PSAY "Data De  ? "+DtoC(MV_PAR01);nLin++
@nLin,000 PSAY "Data Ate ? "+DtoC(MV_PAR02);nLin++
@nLin,000 PSAY "Coord.   ? "+if(!Empty(MV_PAR03),MV_PAR03+" - "+Alltrim(Posicione("SA3",1,xFilial("SA3")+MV_PAR03,"A3_NOME")),"TODOS");nLin++
@nLin,000 PSAY "Repres.  ? "+if(!Empty(MV_PAR04),MV_PAR04+" - "+Alltrim(Posicione("SA3",1,xFilial("SA3")+MV_PAR04,"A3_NOME")),"TODOS");nLin++
@nLin,000 PSAY "UF       ? "+if(!Empty(MV_PAR05),MV_PAR05,"TODAS");nLin++
nLin := 80

while !TMP->(EOF())

   if nLin > 55
      nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
   endif
     
   @nLin,000 PSAY TMP->SEGCOD
   @nLin,008 PSAY LEFT(TMP->SEGNOM,40)
   @nLin,050 PSAY Transform(TMP->VEN_KG   , "@E 99,999,999" )
   @nLin,064 PSAY Transform(TMP->COBERTURA, "@E 999,999" )   

   nTotVol += TMP->VEN_KG
   nTotCob += TMP->COBERTURA

   TMP->(DbSkip())
   nLin++
end

@nLin,000 PSAY Replicate("-", limite);nLin++
@nLin,043 PSAY "TOTAL:"
@nLin,050 PSAY Transform(nTotVol, "@E 99,999,999" )
@nLin,064 PSAY Transform(nTotCob,    "@E 999,999" )   


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


//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
********************************
Static Function CriaSX1(cPerg)
********************************

PutSx1( cPerg, '01', 'Data De   ?', '', '', 'mv_ch1', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Data Ate  ?', '', '', 'mv_ch2', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '03', 'Coord.    ?', '', '', 'mv_ch3', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par05', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '04', 'Repres.   ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par06', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '05', 'UF        ?', '', '', 'mv_ch5', 'C', 02, 0, 0, 'G', '', '12' , '', '', 'mv_par07', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )

Return NIL