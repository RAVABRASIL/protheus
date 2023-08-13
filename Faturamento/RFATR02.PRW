#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'
#include "ap5mail.ch"

***********************
User Function RFATR02()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "Meta Diaria de Vendas"
Local cPict  := ""
Local titulo := cDesc3
Local nLin   := 80

Local Cabec1        := ""
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
Private cPerg       := "RFATR02"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFATR02" // Coloque aqui o nome do arquivo usado para impressao em disco
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

Local cQuery 	 := ""
Local lContinua := .T.

SetRegua(0)


//Local aMeta := U_MetaDia( 200000, 30000, 22, 6 )

cQuery := "SELECT " 
cQuery += "   META=SUM(Z51_MVALOR)/12 "
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z51")+" "
cQuery += "WHERE "
cQuery += "   Z51_ANO = '"+Alltrim(Str(MV_PAR02))+"' AND "
if !Empty(MV_PAR05)
   cQuery += "   Z51_COORD = '"+MV_PAR05+"' AND "
endif
if !Empty(MV_PAR06)
   cQuery += "   Z51_REPRES = '"+MV_PAR06+"' AND "
endif   
if !Empty(MV_PAR07)
   cQuery += "   Z51_UF = '"+MV_PAR07+"' AND "
endif   
if MV_PAR08 = 1
   cQuery += "   Z51_LINHA = 'INST' AND "
elseif MV_PAR08 = 2   
   cQuery += "   Z51_LINHA = 'DOME' AND "
elseif MV_PAR08 = 3
   cQuery += "   Z51_LINHA = 'HOSP' AND "
endif      
cQuery += "   D_E_L_E_T_ <> '*' "

If Select("TMP") > 0
   DbSelectArea("TMP")
   DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
nMeta := TMP->META

DbSelectArea("TMP")

cIni := DtoS(CtoD("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02)))
cFim := DtoS(LastDay(Ctod("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02))))

cQuery := "SELECT "
cQuery += "   REAL=SUM(VEN_KG-DEV_KG)"
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      GERCOD, GERNOM=ISNULL((SELECT RTRIM(A3_NOME) FROM "+RetSqlName("SA3")+" WHERE A3_COD = GERCOD AND D_E_L_E_T_ <> '*'), '' ), "
cQuery += "      REPCOD, REPNOM, "
cQuery += "      UF, "
cQuery += "      LINHA, "
cQuery += "      VEN_KG, "
cQuery += "      DEV_KG "
cQuery += "   FROM "
cQuery += "   ( "
cQuery += "      SELECT "
cQuery += "         REPCOD=LEFT(C5_VEND1,4), REPNOM=A3_NOME, "
cQuery += "         GERCOD=A3_SUPER, "
cQuery += "         UF=A1_EST,
cQuery += "         LINHA= "
cQuery += "            CASE "
cQuery += "               WHEN B1_GRUPO IN('D','E') THEN 'DOME' "
cQuery += "               WHEN B1_GRUPO IN('A','B','G') THEN 'INST' "
cQuery += "               WHEN B1_GRUPO IN('C') THEN 'HOSP' "
cQuery += "               ELSE B1_GRUPO "
cQuery += "            END, "
cQuery += "         VEN_KG = SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
cQuery += "         DEV_KG = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0) "
cQuery += "      FROM  "
cQuery += "         "+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery += "         left  JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery += "         ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "         AND SC5.C5_ENTREG BETWEEN '"+cIni+"' AND '"+cFim+"'  AND SC5.D_E_L_E_T_='' "
cQuery += "         JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += "         ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  "
cQuery += "         JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery += "         ON SA3.A3_COD = LEFT(SC5.C5_VEND1,4) AND SA3.D_E_L_E_T_='' "
cQuery += "         JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery += "         ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_=''  "
cQuery += "         left JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery += "         ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ = ' '  "
cQuery += "         AND SD2.D2_QTDEDEV > 0 "
cQuery += "      WHERE "
cQuery += "         SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "         SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery += "         SC6.D_E_L_E_T_ = ' ' "
cQuery += "      GROUP BY "
cQuery += "         LEFT(C5_VEND1,4), A3_NOME, A3_SUPER, A1_EST, "
cQuery += "         CASE "
cQuery += "            WHEN B1_GRUPO IN('D','E') THEN 'DOME' "
cQuery += "            WHEN B1_GRUPO IN('A','B','G') THEN 'INST' "
cQuery += "            WHEN B1_GRUPO IN('C') THEN 'HOSP' "
cQuery += "            ELSE B1_GRUPO "
cQuery += "         END "
cQuery += "   ) AS TABX "

cQuery += "   WHERE   "

if MV_PAR08 = 1
   cQuery += "LINHA = 'INST' AND "
elseif MV_PAR08 = 2
   cQuery += "LINHA = 'DOME' AND "
elseif MV_PAR08 = 3
   cQuery += "LINHA = 'HOSP' AND "
endif

if !Empty(MV_PAR07)
   cQuery += "UF = '"+MV_PAR07+"' AND "
endif

if !Empty(MV_PAR06)
   cQuery += "REPCOD LIKE '"+Alltrim(MV_PAR06)+"%' AND "
endif

if !Empty(MV_PAR05)
   cQuery += "GERCOD LIKE '"+Alltrim(MV_PAR05)+"%' AND "
endif

cQuery += "VEN_KG > 0 "

cQuery += ") AS TABX"

   
If Select("TMP") > 0
   DbSelectArea("TMP")
   DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
nReal := TMP->REAL

DbSelectArea("TMP")

if nLin > 55
   nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
endif

aMeta := U_MetaDia( nMeta, nReal, MV_PAR03, MV_PAR04 )

@nLin,000 PSAY "--- PARAMETROS ---";nLin++;nLin++
@nLin,000 PSAY "Mês        ? "+StrZero(MV_PAR01,2);nLin++
@nLin,000 PSAY "Ano        ? "+Alltrim(Str(MV_PAR02));nLin++
@nLin,000 PSAY "Dias Uteis ? "+Alltrim(Str(MV_PAR03));nLin++
@nLin,000 PSAY "Dias Corri ? "+Alltrim(Str(MV_PAR04));nLin++
@nLin,000 PSAY "Coord      ? "+if(!Empty(MV_PAR05),MV_PAR05+" - "+Alltrim(Posicione("SA3",1,xFilial("SA3")+MV_PAR05,"A3_NOME")),"TODOS");nLin++
@nLin,000 PSAY "Repres     ? "+if(!Empty(MV_PAR06),MV_PAR06+" - "+Alltrim(Posicione("SA3",1,xFilial("SA3")+MV_PAR06,"A3_NOME")),"TODOS");nLin++
@nLin,000 PSAY "UF         ? "+if(!Empty(MV_PAR07),MV_PAR07,"TODAS AS UFs");nLin++
@nLin,000 PSAY "Linha      ? "+if(MV_PAR08=1,"Institucional",if(MV_PAR08=2,"Domestica",if(MV_PAR08=3,"Hospitalar","Todas")))

nLin++;nLin++;nLin++
      
@nLin,000 PSAY "Meta Mensal  : "+Transform(nMeta   , "@E 999,999.99" )+" Kg";nLin++         
@nLin,000 PSAY "Realizado    : "+Transform(nReal   , "@E 999,999.99" )+" Kg";nLin++
@nLin,000 PSAY "Ideal Acum.  : "+Transform(aMeta[1], "@E 999,999.99" )+" Kg";nLin++
@nLin,000 PSAY "Dif.Acumul.  : "+Transform(aMeta[2], "@E 999,999.99" )+" Kg";nLin++
@nLin,000 PSAY "Meta Prox.Dia: "+Transform(ameta[3], "@E 999,999.99" )+" Kg";nLin++
@nLin,000 PSAY "Tendencia Mes: "+Transform(ameta[4], "@E 999,999.99" )+" Kg";nLin++
@nLin,000 PSAY "Meta Ult.Dia : "+Transform(ameta[5], "@E 999,999.99" )+" Kg";nLin++


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
******************************
Static Function CriaSX1(cPerg)
******************************

PutSx1( cPerg, '01', 'Mês       ?', '', '', 'mv_ch1', 'N', 02, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Ano       ?', '', '', 'mv_ch2', 'N', 04, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '03', 'Dias Uteis?', '', '', 'mv_ch3', 'N', 02, 0, 0, 'G', '', ''   , '', '', 'mv_par03', '', '', '', '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '04', 'Dias Corri?', '', '', 'mv_ch4', 'N', 02, 0, 0, 'G', '', ''   , '', '', 'mv_par04', '', '', '', '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '05', 'Coord     ?', '', '', 'mv_ch5', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par05', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '06', 'Repres    ?', '', '', 'mv_ch6', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par06', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '07', 'UF        ?', '', '', 'mv_ch7', 'C', 02, 0, 0, 'G', '', '12' , '', '', 'mv_par07', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '08', 'Linha     ?', '', '', 'mv_ch8', 'N', 01, 0, 1, 'C', '', ''   , '', '', 'mv_par08', 'Institucional', '', '', '' , 'Domestica', '', '', 'Hospitalar', '', '', 'Todas', '', '', '', '', '', {}, {}, {} )

Return NIL