#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO24    º Autor ³ AP6 IDE            º Data ³  08/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR026()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "VOLUME DE PROCUCAO"
Local cPict          := ""
Local nLin           := 80
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "G"
Private nomeprog     := "PCPR026" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}//{ "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR026"
             //          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150
             //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Private Cabec1:="Linha         Tipo            Meta Mes      Meta Dia      Prod Dia      Meta Acum     Prod Acum     Dif Quant     Meta Dia Restante   Nova Prod.   Nova Prod. Ac.                                                       "
Private Cabec2         := ""
Private titulo         := "VOLUME DE PROCUCAO"
nProdEx:=0

Private cString := ""

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")



hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)

Pergunte('PCPR026',.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo         := "VOLUME DE PROCUCAO "+DTOC(MV_PAR01)

wnrel := SetPrint(cString,NomeProg,"PCPR026",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
//wnrel := SetPrint(cString,NomeProg,"PCPR026",@titulo,cDesc1,cDesc2,cDesc3,.F.,.F.,.F.,Tamanho,,.F.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  08/10/13   º±±
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)

fLinha(@nLin) // producao por linha 
@nLin++
@nLin++,000 PSAY replicate('_',220)
@nLin++
fExtrusao(@nLin) // extrusoras 
@nLin++
@nLin++,000 PSAY replicate('_',220)
@nLin++
@nLin++,000 PSAY 'Apara Meta '+ALLTRIM(STR(MV_PAR18))+'%'
fapara(@nLin) // informacao da apara corte solda, picotadeira e extrusora 
@nLin++
@nLin++,000 PSAY replicate('_',220)
@nLin++,000 PSAY 'Eficiencia'
@nLin++,000 PSAY replicate('_',220)
fViaEfic(@nLin) // eficiencia 
@nLin++
@nLin++,000 PSAY replicate('_',220)
@nLin++,000 PSAY "Parametros"
@nLin++,000 PSAY replicate('_',220)
fLegenda(@nLin) // eficiencia 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	//msgAlert("entrou no ourspool")
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

***************

Static Function fProd(nLinha,cStatus,nTipo)

***************
local cQuery:=''
LOCAL nRet:=0
cQuery := "SELECT   "
cQuery += "CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') "
cQuery += "THEN 'ROLO' ELSE 'NORMAL' END TIPO, "
cQuery += "ISNULL ( SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO "
cQuery += "FROM Z00020 Z00 WITH (NOLOCK) "
cQuery += ",SC2020 SC2 WITH (NOLOCK)  "
cQuery += ",SB1010 SB1 WITH (NOLOCK) "
if cStatus='DIA'
   //cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par01 )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
     cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR >= '" + Dtos( mv_par01 )+hora1+"' AND Z00.Z00_DATHOR < '" + Dtos( mv_par01+1 )+hora1+"' "
elseif cStatus='ACUMULADO'
   //cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR BETWEEN '" +dtos( Firstday( mv_par01 ) )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
     cQuery += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR >= '" +dtos( Firstday( mv_par01 ) )+hora1+"' AND Z00.Z00_DATHOR < '" + Dtos( mv_par01+1 )+hora1+"' "

Endif
cQuery += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
if nlinha=1 // domestica
   cQuery += "AND B1_GRUPO in('E','D') 
   if nTipo=1 // rolo 
      cQuery += "AND CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END ='ROLO' " 
   elseif nTipo=2 // normal  
      cQuery += "AND CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END ='NORMAL'  "  
   endif
ELSEif nlinha=2 // HOSPITALAR
   cQuery += "AND B1_GRUPO in('C') 
   if nTipo=1 //INFECTANTE 
      //cQuery += "AND SUBSTRING(B1_COD,1,3) IN ('CAB', 'CDB', 'CGB', 'CIB', 'CKB') " 
      cQuery += "AND SUBSTRING(B1_COD,1,1) IN ('C') AND SUBSTRING(B1_COD,3,1) IN ('B') " 
   elseif nTipo=2 // HAMPER  CORDAO 
      cQuery += "AND ltrim(rtrim(B1_COD)) IN ('CAA024','CAA026','CAA050','CAD024','CAD026','CAD050','CAE024','CAE026','CAE050','CAF021','CAF024','CAF026','CAF031','CAF050','CAF051') " 
   elseif nTipo=3 // HAMPER  FITA 
      cQuery += "AND ltrim(rtrim(B1_COD)) IN ('CAA010','CAA020','CAA040','CAD010','CAD020','CAD040','CAE011','CAE020','CAE040','CAF010','CAF020','CAF040') " 
   elseif nTipo=4 // OBITO
      cQuery += "AND ( (SUBSTRING(B1_COD,1,3) IN ('CTG')) OR  ( B1_TIPO IN('IS') ) )" 
   elseif nTipo=5 // CORTINA
      cQuery += " AND B1_SETOR IN ('59') " 
   endif
ELSEIF nlinha=3 // INSTITUCIONAL 
   cQuery += "AND B1_GRUPO IN ('A','B','G') 
   if nTipo=1 // GERAL 
      cQuery += " AND SUBSTRING(B1_COD,4,1) <> 'R' " 
   elseif nTipo=2 // ROLO 
      cQuery += " AND SUBSTRING(B1_COD,4,1) = 'R' " 
   endif
ELSEIF nlinha=4 // ME 
   cQuery += "AND B1_GRUPO in('ME') 
Endif

cQuery += "AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' '  "
cQuery += "AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "AND C2_PRODUTO=B1_COD "
cQuery += "AND SC2.D_E_L_E_T_ = ' '  "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY  "
cQuery += "CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END "

TCQUERY cQuery NEW ALIAS  "TMPX"

if TMPX->(!EOF())
   nRet:=TMPX->PESO
ENDIF

TMPX->(dbclosearea())

Return nRet

***************

Static Function fNewProd(nLinha,cStatus,nTipo)

***************
local cQuery:=''
LOCAL nRet:=0

cQuery := " SELECT SUM(ZZ2_QUANT) AS PESO FROM ZZ2020 Z WITH (NOLOCK)  "
cQuery += " INNER JOIN SB1010 B WITH (NOLOCK) "
cQuery += " ON ZZ2_PROD = B1_COD "
cQuery += " WHERE Z.D_E_L_E_T_ <> '*' "
cQuery += " AND B.D_E_L_E_T_ <> '*' "
if cStatus='DIA'
//   cQuery += " AND ZZ2_DATA+ZZ2_HORA BETWEEN '" + Dtos( mv_par01 )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
   cQuery += " AND ZZ2_DATA+ZZ2_HORA >= '" + Dtos( mv_par01 )+hora1+"' AND ZZ2_DATA+ZZ2_HORA < '" + Dtos( mv_par01+1 )+hora1+"' "
elseif cStatus='ACUMULADO'
//   cQuery += " AND ZZ2_DATA+ZZ2_HORA BETWEEN '" +dtos( Firstday( mv_par01 ) )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
   cQuery += " AND ZZ2_DATA+ZZ2_HORA >= '" +dtos( Firstday( mv_par01 ) )+hora1+"' AND ZZ2_DATA+ZZ2_HORA < '" +dtos( mv_par01+1)+hora1+"' "
Endif

If nlinha=1 // domestica
   cQuery += " AND B1_GRUPO in('E','D') "
   If nTipo=1 // rolo 
      cQuery += "AND CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END ='ROLO' " 
   ElseIf nTipo=2 // normal  
      cQuery += "AND CASE when (Substring( B1_COD, 3, 1 ) = 'R') or (Substring( B1_COD, 4, 1 ) = 'R') THEN 'ROLO' ELSE 'NORMAL' END ='NORMAL'  "  
   EndIf
End
if nlinha=2 // HOSPITALAR
   cQuery += " AND B1_GRUPO in('C') "
   if nTipo=1 //INFECTANTE 
      cQuery += " AND B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') " 
   elseif nTipo=2 // HAMPER  CORDAO 
      cQuery += " AND B1_SETOR IN ('56') " 
   elseif nTipo=3 // HAMPER  FITA 
      cQuery += " AND B1_SETOR IN ('05','37','40') " 
   elseif nTipo=4 // OBITO
      cQuery += " AND B1_SETOR IN ('06','54','98') " 
   elseif nTipo=5 // CORTINA
      cQuery += " AND B1_SETOR IN ('59') " 
   endif
EndIf
IF nlinha=3 // INSTITUCIONAL 
   cQuery += "AND B1_GRUPO IN ('A','B','G') 
   if nTipo=1 // GERAL 
      cQuery += " AND SUBSTRING(B1_COD,4,1) <> 'R' " 
   elseif nTipo=2 // ROLO 
      cQuery += " AND SUBSTRING(B1_COD,4,1) = 'R' " 
   endif
ELSEIF nlinha=4 // ME 
   cQuery += "AND B1_GRUPO in('ME') 
Endif
/*
AND B1_SETOR IN ('05','37','40') -- 'Hamper Fita'
AND B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') -- 'Infectantes'
AND B1_SETOR IN ('56')           -- 'Hamper Cordão'
AND B1_SETOR IN ('06','54','98') -- 'Obitos'
AND B1_SETOR IN ('23')           -- 'Dona Limpeza Pacote'
AND B1_SETOR IN ('24','25')      -- 'Dona Limpeza Rolo'
AND B1_SETOR IN ('26')           -- 'Brasileirinho Pacote'
AND B1_SETOR IN ('27','28')      -- 'Brasileirinho Rolo'
*/

TCQUERY cQuery NEW ALIAS  "TMPX"

if TMPX->(!EOF())
   nRet:=TMPX->PESO
ENDIF

TMPX->(dbclosearea())

Return nRet

***************

Static Function fextrusao(nLin)

***************

@nLin,00 PSAY 'Extrusao'

nMetaMes:=MV_PAR13
nMetaDia:=nMetaMes / MV_PAR03
@nLin,30 PSAY transform(nMetaMes ,"@E 9,999,999.99")
@nLin,44 PSAY transform(nMetaDia ,"@E 9,999,999.99")
nProd:=fProdEx('DIA')
@nLin,58 PSAY transform(nProd ,"@E 9,999,999.99")
nMetaAcu:=nMetaDia*MV_PAR16
@nLin,72 PSAY transform( nMetaAcu ,"@E 9,999,999.99")
nProdEx:=fProdEx('ACUMULADO')
@nLin,86 PSAY transform( nProdEx ,"@E 9,999,999.99")
@nLin,100 PSAY transform( nMetaAcu - nProdEx ,"@E 9,999,999.99")
nDifDias:= MV_PAR03-MV_PAR16 
@nLin++,114 PSAY transform( (nMetaMes - nProdEx)/( nDifDias ),"@E 9,999,999.99")

Return 

***************

Static Function fProdEx(cStatus)

***************

local cQry:=''
local nRet:=0

cQry:="SELECT	ISNULL(SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO  "
cQry+="FROM Z00020 Z00 WITH (NOLOCK) "
cQry+="WHERE Z00_FILIAL = '  '  "
if cStatus='DIA'
   //cQry += "AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par01 )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
     cQry += "AND Z00.Z00_DATHOR >= '" + Dtos( mv_par01 )+hora1+"' AND Z00.Z00_DATHOR < '" + Dtos( mv_par01+1 )+hora1+"' "
elseif cStatus='ACUMULADO'
//   cQry += "AND Z00.Z00_DATHOR BETWEEN '" +dtos( Firstday( mv_par01 ) )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
   cQry += "AND Z00.Z00_DATHOR >= '" +dtos(Firstday( mv_par01 ))+hora1+"' AND Z00.Z00_DATHOR < '" + Dtos( mv_par01+1 )+hora1+"' "
Endif
cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('E0') "
cQry+="AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' "
TCQUERY cQry NEW ALIAS  "TMPEX"

if TMPEX->(!EOF())
   nRet:=TMPEX->PESO
ENDIF

TMPEX->(dbclosearea())

Return nRet


***************

Static Function fLinha(nLin)

***************

local aLinha:={{'Domestica',{'Rolo','Pacote'}},{'Hospitalar',{'Infectante','Hamper Cordao','Hamper Fita','Obito'}},{'Institucional',{'Geral','Rolo'}},{'Capa',{'Geral'}} }
local TMetaMes:=0
local TMetaDia:=0
local TProd:=0
local TMetaAcu:=0
local TProdAcu:=0
local TMetaRest:=0
local TNewProd:=0
local TNewProdAcu:=0



For _X:=1 to Len(aLinha)

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

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
   cnt:=1

   for _Y:=1 to len(alinha[_X][2])
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    @nLin,00 PSAY iif(cnt=1,alinha[_X][1],space(12))
    @nLin,14 PSAY alinha[_X][2][_Y]
    
    nMetaMes:=iif(_X=4,0,&("MV_PAR"+STRZERO(_Y + iif(_X=1,4,iif(_X=2,6,IIf(_Y=1,10,19))),2)) )
    
    nMetaDia:=nMetaMes / iif(_X=1 .AND._Y=1,MV_PAR04,MV_PAR02)
    @nLin,30 PSAY transform(nMetaMes ,"@E 9,999,999.99") 
    @nLin,44 PSAY transform(nMetaDia ,"@E 9,999,999.99") 
    nProd:=fProd(_X,'DIA',_Y)
    @nLin,58 PSAY transform(nProd ,"@E 9,999,999.99") 
    nMetaAcu:=nMetaDia*iif(_X=1 .AND._Y=1,MV_PAR17,MV_PAR15)
    @nLin,72 PSAY transform( nMetaAcu ,"@E 9,999,999.99") 
    nProdAcu:=fProd(_X,'ACUMULADO',_Y)
    @nLin,86 PSAY transform( nProdAcu ,"@E 9,999,999.99") 
    @nLin,100 PSAY transform( IIF(_X=4,0,nMetaAcu - nProdAcu) ,"@E 9,999,999.99")     
    nDifDias:= iif(_X=1 .AND._Y=1,MV_PAR04-MV_PAR17 , MV_PAR02 - MV_PAR15 )    
    nMetaRest:=IIF(_X=4,0,(nMetaMes - nProdAcu)/( nDifDias ))
    @nLin,114 PSAY transform( nMetaRest ,"@E 9,999,999.99")     

    nNewProd:=fNewProd(_X,'DIA',_Y)
    @nLin,128 PSAY transform(nNewProd ,"@E 9,999,999.99") 

    nNewProdAcu:=fNewProd(_X,'ACUMULADO',_Y)
    @nLin++,142 PSAY transform( nNewProdAcu ,"@E 9,999,999.99") 

    cnt+=1
    // total 
    TMetaMes+=nMetaMes 
    TMetaDia+=nMetaDia
    TProd+=nProd
    TMetaAcu+=nMetaAcu
    TProdAcu+=nProdAcu
    TMetaRest+=nMetaRest
	TNewProd+=nNewProd
	TNewProdAcu+=nNewProdAcu
   
   Next
Next

if (MV_PAR04-MV_PAR17) = (MV_PAR02 - MV_PAR15)
       TMetaRest:= (TMetaMes - TProdAcu)/(MV_PAR02 - MV_PAR15) 
endif          

// totais 
@nLin++
@nLin,00 PSAY 'TOTAL :'
@nLin,30 PSAY transform(TMetaMes ,"@E 9,999,999.99")
@nLin,44 PSAY transform(TMetaDia ,"@E 9,999,999.99")
@nLin,58 PSAY transform(TProd ,"@E 9,999,999.99")
@nLin,72 PSAY transform( TMetaAcu ,"@E 9,999,999.99")
@nLin,86 PSAY transform( TProdAcu ,"@E 9,999,999.99")
@nLin,100 PSAY transform( TMetaAcu - TProdAcu ,"@E 9,999,999.99")
@nLin,114 PSAY transform( TMetaRest,"@E 9,999,999.99")
@nLin,128 PSAY transform( TNewProd ,"@E 9,999,999.99")
@nLin++,142 PSAY transform( TNewProdAcu ,"@E 9,999,999.99")

return 



***************

Static Function fapara(nLin)

***************

local TMetaMes:=0
local TMetaDia:=0
local TProd:=0
local TMetaAcu:=0
local TProdAcu:=0
local TMetaRest:=0

// corte e solda 
@nLin,00 PSAY 'Corte Solda'
//nMetaMes:=MV_PAR12*(MV_PAR18/100)
nMetaMes:=(MV_PAR06+MV_PAR07+MV_PAR08+MV_PAR09+MV_PAR10+MV_PAR11)*(MV_PAR18/100)
TMetaMes+=nMetaMes
nMetaDia:=nMetaMes / MV_PAR02
TMetaDia+=nMetaDia
@nLin,30 PSAY transform(nMetaMes ,"@E 9,999,999.99")
@nLin,44 PSAY transform(nMetaDia ,"@E 9,999,999.99")
nProd:=fProdApa('DIA','COR')
TProd+=nProd
@nLin,58 PSAY transform(nProd ,"@E 9,999,999.99")
nMetaAcu:=nMetaDia*MV_PAR15
TMetaAcu+=nMetaAcu
@nLin,72 PSAY transform( nMetaAcu ,"@E 9,999,999.99")
nProdAcu:=fProdApa('ACUMULADO','COR')
TProdAcu+=nProdAcu
@nLin,86 PSAY transform( nProdAcu ,"@E 9,999,999.99")
@nLin,100 PSAY transform( nMetaAcu - nProdAcu ,"@E 9,999,999.99")
nDifDias:= MV_PAR02-MV_PAR15
nMetaRest:=(nMetaMes - nProdAcu)/( nDifDias )
TMetaRest+=nMetaRest
@nLin++,114 PSAY transform( nMetaRest,"@E 9,999,999.99")
// picodadeira
@nLin,00 PSAY 'Picotadeira'
//nMetaMes:=MV_PAR14*(MV_PAR18/100)
nMetaMes:=MV_PAR05*(MV_PAR18/100)
TMetaMes+=nMetaMes
nMetaDia:=nMetaMes / MV_PAR04
TMetaDia+=nMetaDia
@nLin,30 PSAY transform(nMetaMes ,"@E 9,999,999.99")
@nLin,44 PSAY transform(nMetaDia ,"@E 9,999,999.99")
nProd:=fProdApa('DIA','PIC')
TProd+=nProd
@nLin,58 PSAY transform(nProd ,"@E 9,999,999.99")
nMetaAcu:=nMetaDia*MV_PAR17
TMetaAcu+=nMetaAcu
@nLin,72 PSAY transform( nMetaAcu ,"@E 9,999,999.99")
nProdAcu:=fProdApa('ACUMULADO','PIC')
TProdAcu+=nProdAcu
@nLin,86 PSAY transform( nProdAcu ,"@E 9,999,999.99")
@nLin,100 PSAY transform( nMetaAcu - nProdAcu ,"@E 9,999,999.99")
nDifDias:= MV_PAR04-MV_PAR17
nMetaRest:=(nMetaMes - nProdAcu)/( nDifDias )
TMetaRest+=nMetaRest
@nLin++,114 PSAY transform( nMetaRest,"@E 9,999,999.99")
// Extrusora
@nLin,00 PSAY 'Extrusora'
nMetaMes:=MV_PAR13*(MV_PAR18/100)
TMetaMes+=nMetaMes
nMetaDia:=nMetaMes / MV_PAR03
TMetaDia+=nMetaDia
@nLin,30 PSAY transform(nMetaMes ,"@E 9,999,999.99")
@nLin,44 PSAY transform(nMetaDia ,"@E 9,999,999.99")
nProd:=fProdApa('DIA','EXT')
TProd+=nProd
@nLin,58 PSAY transform(nProd ,"@E 9,999,999.99")
nMetaAcu:=nMetaDia*MV_PAR16
TMetaAcu+=nMetaAcu
@nLin,72 PSAY transform( nMetaAcu ,"@E 9,999,999.99")
nProdAcu:=fProdApa('ACUMULADO','EXT')
TProdAcu+=nProdAcu
@nLin,86 PSAY transform( nProdAcu ,"@E 9,999,999.99")
@nLin,100 PSAY transform( nMetaAcu - nProdAcu ,"@E 9,999,999.99")
nDifDias:= MV_PAR03-MV_PAR16
nMetaRest:=(nMetaMes - nProdAcu)/( nDifDias )
TMetaRest+=nMetaRest
@nLin++,114 PSAY transform( nMetaRest,"@E 9,999,999.99")
// TOTAL 
@nLin++
@nLin,00 PSAY 'TATAL :'
@nLin,30 PSAY transform(TMetaMes ,"@E 9,999,999.99")
@nLin,44 PSAY transform(TMetaDia ,"@E 9,999,999.99")
@nLin,58 PSAY transform(TProd ,"@E 9,999,999.99")
@nLin,72 PSAY transform(TMetaAcu ,"@E 9,999,999.99")
@nLin,86 PSAY transform(TProdAcu ,"@E 9,999,999.99")
@nLin,100 PSAY transform(TMetaAcu - TProdAcu ,"@E 9,999,999.99")
@nLin++,114 PSAY transform( TMetaRest,"@E 9,999,999.99")
// % apara geral 
@nLin++
@nLin,00 PSAY 'Apara Geral :'
@nLin,15 PSAY transform((TProdAcu/nProdEx)*100 ,"@E 999.99")+"%"


Return 

**************
Static Function fProdApa(cStatus,cMaq)
***************
local cQry:=''
local nret:=0

cQry:="SELECT ISNULL(SUM(Z00.Z00_PESO),0) AS PESO "
cQry+="FROM Z00020 Z00 WITH (NOLOCK) "
cQry+="WHERE Z00.Z00_FILIAL = '  ' "
if cStatus='DIA'
   //cQry += "AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par01 )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
   cQry += "AND Z00.Z00_DATHOR >= '" + Dtos( mv_par01 )+hora1+"' AND Z00.Z00_DATHOR < '" + Dtos( mv_par01+1 )+hora1+"'  "
elseif cStatus='ACUMULADO'
   //cQry += "AND Z00.Z00_DATHOR BETWEEN '" +dtos( Firstday( mv_par01 ) )+ "05:20' AND '"+ Dtos( mv_par01+1 ) +"05:19' "
   cQry += "AND Z00.Z00_DATHOR >= '" +dtos( Firstday( mv_par01 ) )+hora1+"' AND Z00.Z00_DATHOR < '" + Dtos( mv_par01+1 )+hora1+"'  "
Endif
if cMaq='COR'
   cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2) LIKE '[C][0123456789]%'  "
elseif cMaq='PIC'
   cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2) LIKE '[P][0123456789]%'  "
elseif cMaq='EXT'
   cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2) LIKE '[E][0123456789]%'  "
ENDIF
cQry+="AND Z00.Z00_APARA not in ('','W')  "
cQry+="AND Z00.D_E_L_E_T_ = ' '   "

TCQUERY cQry NEW ALIAS  "TMPAP"

if TMPAP->(!EOF())
   nRet:=TMPAP->PESO
ENDIF

TMPAP->(dbclosearea())

Return nRet


*************

Static function fEfic()

*************

local nEfiRealC:=nEfiRealP:=0
local nEfiMetaC:=nEfiMetaP:=0
local aInfoEfi :={}
local aEfiDia:={}
         
ddataI:= FirstDay(MV_PAR01)
//ddataI:= MV_PAR01
ddataF:=MV_PAR01
while ddataI <= ddataF
		nEfiRealC:=0  // REAL CORTE 
		nEfiMetaC:=0 // META  CORTE 
		
		nEfiRealP:=0  // REAL PICOTADEIRA 
		nEfiMetaP:=0 // META  PICOTADEIRA 
		
		aInfoEfi := U_PCPC018(Dtos(ddataI),'','','ZZZZZZZZZZ','',.F.)
		For x := 1 to LEN(aInfoEfi)
		   	if SUBSTR(aInfoEfi[x][1],1,1)='C'
			   // somatario produzido
			   	if aInfoEfi[x][9]>0    // so soma o realizado se tiver meta
					//nEfiRealC+=aInfoEfi[x][3] // PRODUCAO EM MR 
				   nEfiRealC+=aInfoEfi[x][12]   // PRODUCAO KG 
				ENDIF				
				if aInfoEfi[x][10]>0
					//nEfiRealC+=aInfoEfi[x][4] 
					nEfiRealC+=aInfoEfi[x][13]
				endIF				
				if aInfoEfi[x][11]>0
					//nEfiRealC+=aInfoEfi[x][5]
					nEfiRealC+=aInfoEfi[x][14]
				endIF			
				// somatario Meta
				nEfiMetaC:= nEfiMetaC+aInfoEfi[x][9]+aInfoEfi[x][10]+aInfoEfi[x][11]
			ELSEIF SUBSTR(aInfoEfi[x][1],1,1)='P'
			// somatario produzido
				if aInfoEfi[x][9]>0    // so soma o realizado se tiver meta
					//nEfiRealP+=aInfoEfi[x][3]
				    nEfiRealP+=aInfoEfi[x][12]
				ENDIF				
				if aInfoEfi[x][10]>0
					//nEfiRealP+=aInfoEfi[x][4]
					nEfiRealP+=aInfoEfi[x][13]
				endIF				
				if aInfoEfi[x][11]>0
					//nEfiRealP+=aInfoEfi[x][5]
					nEfiRealP+=aInfoEfi[x][14]
				endIF			
				// somatario Meta
				nEfiMetaP:= nEfiMetaP+aInfoEfi[x][9]+aInfoEfi[x][10]+aInfoEfi[x][11]
			endif
		Next
		Aadd( aEfiDia, { ddataI,nEfiRealC,nEfiMetaC,nEfiRealP,nEfiMetaP  } )
	    ddataI:=ddataI+1
enddo


dbselectarea('Z88')


Return aEfiDia

***************

Static Function fViaEfic(nLin)

***************
local afEfic:=fEfic()
local ncol:=14
local nMeta:=nReal:=0

fcabec(@nLin)
@nLin,00 PSAY 'Corte'
@nLin,08 PSAY transform( MV_PAR19,"@E 999.99")
For _X:=1 to len(afEfic)
    @nLin,ncol PSAY iif( _X>len(afEfic),'',transform( (afEfic[_X][2]/afEfic[_X][3])*100,"@E 999.99"))    
    nMeta+=afEfic[_X][3]
    nReal+=afEfic[_X][2]
    ncol+=6
Next

@nLin,206 PSAY transform( (nReal/nMeta)*100,"@E 999.99")    

nMeta:=0
nReal:=0
@nLin++ 
@nLin,00 PSAY 'Picot'  
@nLin,08 PSAY transform( MV_PAR20,"@E 999.99")
ncol:=14
For _X:=1 to len(afEfic)
    @nLin,ncol PSAY iif( _X>len(afEfic),'',transform( (afEfic[_X][4]/afEfic[_X][5])*100,"@E 999.99"))
    nMeta+=afEfic[_X][5]
    nReal+=afEfic[_X][4]
    ncol+=6
Next

@nLin,206 PSAY transform( (nReal/nMeta)*100,"@E 999.99")    


nMeta:=0
nReal:=0
@nLin++ 
@nLin++ 
@nLin,00 PSAY 'Geral'  
ncol:=14
For _X:=1 to len(afEfic)
    @nLin,ncol PSAY iif( _X>len(afEfic),'',transform( ( ( afEfic[_X][2]+afEfic[_X][4] )/( afEfic[_X][3]+afEfic[_X][5] ) )*100,"@E 999.99"))
    nMeta+=(afEfic[_X][3]+afEfic[_X][5])
    nReal+=( afEfic[_X][2]+afEfic[_X][4] )
    ncol+=6
Next

@nLin,206 PSAY transform( (nReal/nMeta)*100,"@E 999.99")    

Return 


***************

Static Function fcabec(nLin)

***************
local ncol:=15
@nLin,00 PSAY 'Maq'
@nLin,08 PSAY 'Meta'
For _x:=1 to 31
   @nLin,ncol PSAY 'Dia'+strzero(_x,2)
   ncol+=6   
next 
@nLin,206 PSAY "Acumulado"
@nLin++

Return 
***************

Static Function fLegenda(nLin)

***************
@nLin++,00 PSAY 'Qtd Dias Corte Solda: '+ transform(MV_PAR02,"@E 999" )+SPACE(2)+'Qtd Dias Rodados Corte Solda: '+transform(MV_PAR15,"@E 999" )
@nLin++,00 PSAY 'Qtd Dias Extrusora  : '+ transform(MV_PAR03,"@E 999" )+SPACE(2)+'Qtd Dias Rodados Extrusora  : '+transform(MV_PAR16,"@E 999" )
@nLin++,00 PSAY 'Qtd Dias Picotadeira: '+ transform(MV_PAR04,"@E 999" )+SPACE(2)+'Qtd Dias Rodados Picotadeira: '+transform(MV_PAR17,"@E 999" )

Return   