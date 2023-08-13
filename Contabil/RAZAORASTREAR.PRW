#include "rwmake.ch"                                                 
/*___________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦ Programa ¦         ¦ Autor ¦ Eurivan Marqus Candido¦ Data ¦ 11/02/14 ¦¦¦
¦¦+----------+----------+-------+-----------------------+------+----------+¦¦
¦¦¦Descrição ¦ Relatorio de Rastreamento mov. contabil                    ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦ Uso      ¦ Rava Embalagens - Custo                                    ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

**********************
User Function _CTBA01()
**********************

local cPerg     := "CTBA01"

ValidPerg(cPerg)

if !Pergunte(cPerg,.T.)
   return
endif

Processa({ |lEnd| xCTBA01(),OemToAnsi('Gerando Mov.Contabil Rastreavel...')}, OemToAnsi('Aguarde...'))

return


*************************
Static Function xCTBA01()
*************************

local aCompras  := {}
local aCabec 	 := {}
Local aSumarios := {}                               

ProcRegua(0) // Regua

cQuery := "SELECT "
cQuery += "   LP, CHAVE, CONTA, DCONTA, CUSTO, DDATA, TPSALD, "
cQuery += "   DC, LOTE, SUBLOTE, DOC, LINHA, HIST, "
cQuery += "   TIPOLAN, VALOR, EMPORI, FILORI "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      CT2_LP LP, CT2_KEY CHAVE, CT2_FILIAL FILIAL, CT1_CONTA CONTA, ISNULL(CT1_DESC01,'') DCONTA, ISNULL(CT2_CCD,'') CUSTO,ISNULL(CT2_ITEMD,'') ITEM, "
cQuery += "      ISNULL(CT2_CLVLDB,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "
cQuery += "      ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'') SUBLOTE, "
cQuery += "      ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_CREDIT,'') XPARTIDA, "
cQuery += "      ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '1' TIPOLAN, "
cQuery += "      ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI "
cQuery += "   FROM "
cQuery += "      "+RetSqlName("CT1")+" CT1 LEFT JOIN "+RetSqlName("CT2")+" CT2 "
cQuery += "   ON "
cQuery += "      CT2.CT2_DEBITO = CT1.CT1_CONTA  "
cQuery += "      AND CT2.CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery += "      AND CT2.CT2_CCD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "      AND CT2.CT2_ITEMD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "      AND CT2.CT2_CLVLDB BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += "      AND CT2.CT2_TPSALD = '"+MV_PAR09+"' "
cQuery += "      AND CT2.CT2_MOEDLC = '"+MV_PAR10+"' "
cQuery += "      AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') "
cQuery += "      AND CT2_VALOR <> 0 "
cQuery += "      AND CT2.D_E_L_E_T_ = ' ' "
cQuery += "   WHERE "
cQuery += "      CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += "      AND CT1.CT1_CLASSE = '2' "
cQuery += "      AND CT1.CT1_CONTA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
cQuery += "      AND CT1.D_E_L_E_T_ = '' "
cQuery += "   UNION "
cQuery += "   SELECT "
cQuery += "      CT2_LP LP, CT2_KEY CHAVE, CT2_FILIAL FILIAL, CT1_CONTA CONTA, ISNULL(CT1_DESC01,'') DCONTA, ISNULL(CT2_CCC,'') CUSTO, ISNULL(CT2_ITEMC,'') ITEM, "
cQuery += "      ISNULL(CT2_CLVLCR,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "
cQuery += "      ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'')SUBLOTE, "
cQuery += "      ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_DEBITO,'') XPARTIDA, "
cQuery += "      ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '2' TIPOLAN, "
cQuery += "      ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI "
cQuery += "   FROM "
cQuery += "      "+RetSqlName("CT1")+" CT1 LEFT JOIN "+RetSqlName("CT2")+" CT2 "
cQuery += "   ON "
cQuery += "      CT2.CT2_CREDIT =  CT1.CT1_CONTA "
cQuery += "      AND CT2.CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery += "      AND CT2.CT2_CCC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "      AND CT2.CT2_ITEMC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "      AND CT2.CT2_CLVLCR BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += "      AND CT2.CT2_TPSALD = '"+MV_PAR09+"' "
cQuery += "      AND CT2.CT2_MOEDLC = '"+MV_PAR10+"' "
cQuery += "      AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') "
cQuery += "      AND CT2_VALOR <> 0 "
cQuery += "      AND CT2.D_E_L_E_T_ = ' ' "
cQuery += "   WHERE "
cQuery += "      CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += "      AND CT1.CT1_CLASSE = '2' "
cQuery += "      AND CT1.CT1_CONTA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
cQuery += "      AND CT1.D_E_L_E_T_ = '' "
cQuery += ") RAZAO "
cQuery += "WHERE "
cQuery += "   VALOR > 0 "
cQuery += "ORDER BY "
cQuery += "   CONTA,DDATA,LOTE,SUBLOTE,DOC,LINHA "

//cQuery := ChangeQuery(cQuery)			
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'XCT2', .F., .T.)
                                                              
if !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   return
endIf                                                            
    
aCabec := { "LP","Filial","Conta","Desc.Conta","C.Custo","Desc.C.Custo","Data","LOTE/SUB/DOC/LINHA","Historico",;
            "Documento","Produto","Descrição","Código","Razão Social","Aprovador","Pedido Compra","Comprador","Solicitação Compra","Solicitante",;
            "Valor" }
                
while XCT2->(!Eof())
   aCompras := Rastreia( XCT2->LP, AllTrim(XCT2->CHAVE) )
   cDCusto  := Alltrim(Posicione( "CTT", 1, xFilial("CTT") + XCT2->CUSTO, "CTT_DESC01" ))
   AADD(aSumarios,{XCT2->LP,XCT2->FILORI,XCT2->CONTA,XCT2->DCONTA,XCT2->CUSTO,cDCusto,Dtoc(Stod(XCT2->DDATA)),XCT2->(LOTE+SUBLOTE+DOC+LINHA),;
                   XCT2->HIST,aCompras[1],aCompras[2],aCompras[3],aCompras[4],aCompras[5],aCompras[6],aCompras[7],aCompras[8],;
                   aCompras[9],aCompras[10],XCT2->VALOR })
	IncProc("Gerando arquivo...")   
   XCT2->(dbSkip())    	                                                  
end                 

XCT2->(DbCloseArea())
                 
DlgToExcel({ {"ARRAY", "Movimentação Contabil", aCabec, aSumarios} })

return


************************************
static function Rastreia(cLP,cChave)
************************************

local cQuery
local aRet := {"","","","","","","","","",""}
local lQ   := .F.

if cLP == "650"
   cQuery := "SELECT " 
   cQuery += "   ISNULL(RTRIM(D1_DOC),'') DOC, ISNULL(RTRIM(D1_COD),'') PROD, ISNULL(RTRIM(B1_DESC),'') DESCR, ISNULL(D1_FORNECE,'') FORN, ISNULL(RTRIM(A2_NOME),'') NOME, "
   cQuery += "   ISNULL(RTRIM(C1_NOMAPRO),'') APRO, ISNULL(C1_PEDIDO,'') PC, ISNULL(C7_USER,'') COMP, ISNULL(C1_NUM,'') SC, ISNULL(C1_SOLICIT,'') SOLI "
   cQuery += "FROM "
   cQuery += "   "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA2")+" SA2, SD1020 SD1 "
   cQuery += "   LEFT JOIN SC7020 SC7 ON "
   cQuery += "      D1_FILIAL=C7_FILIAL AND D1_PEDIDO=C7_NUM AND D1_COD = C7_PRODUTO AND SC7.D_E_L_E_T_ <> '*' "
   cQuery += "   LEFT JOIN SC1020 SC1 ON "
   cQuery += "      C1_FILIAL=C7_FILIAL AND C1_PEDIDO = C7_NUM AND C1_PRODUTO = C7_PRODUTO AND SC1.D_E_L_E_T_ <> '*' "
   cQuery += "WHERE  "
   cQuery += "   D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM = '"+cChave+"' AND "
   cQuery += "   B1_COD = D1_COD AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND "
   cQuery += "   SB1.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' "
   lQ := .T.
elseif cLP == "513"
   cQuery := "SELECT " 
   cQuery += "   '', DOC, '' PROD, '' DESCR, E2_FORNECE FORN, RTRIM(A2_NOME) NOME, '' APRO, '' PC, '' COMP, '' SC, '' SOLI "
   cQuery += "FROM "
   cQuery += "   SE2020 SE2, "+RetSqlName("SA2")+" SA2 "
   cQuery += "WHERE  "
   cQuery += "   E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = '"+cChave+"' AND  "
   cQuery += "   A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND "
   cQuery += "   SA2.D_E_L_E_T_ <> '*' AND SE2.D_E_L_E_T_ <> '*' "
   lQ := .T.   
elseif cLP == "530"
   cQuery := "SELECT " 
   cQuery += "   '' DOC, '' PROD, '' DESCR, E5_FORNECE FORN, RTRIM(A2_NOME) NOME, '' APRO, '' PC, '' COMP, '' SC, '' SOLI "
   cQuery += "FROM "
   cQuery += "   SE5020 SE5, "+RetSqlName("SA2")+" SA2 "
   cQuery += "WHERE  "
   cQuery += "   E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_DATA+E5_CLIFOR+E5_LOJA+E5_SEQ = '"+cChave+"' AND  "
   cQuery += "   A2_COD = E5_FORNECE AND A2_LOJA = E5_LOJA AND "
   cQuery += "   SA2.D_E_L_E_T_ <> '*' AND SE5.D_E_L_E_T_ <> '*' "
   lQ := .T.   
endif   

if lQ
   cQuery := ChangeQuery(cQuery)			
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'XTM', .F., .T.)
   
   if !XTM->(EOF())
      aRet[01] := XTM->DOC
      aRet[02] := XTM->PROD
      aRet[03] := XTM->DESCR
      aRet[04] := XTM->FORN
      aRet[05] := XTM->NOME
      aRet[06] := XTM->APRO
      aRet[07] := XTM->PC
      aRet[08] := UsrFullName(XTM->COMP)
      aRet[09] := XTM->SC
      aRet[10] := XTM->SOLI
   endif     
   
   XTM->(DbClosearea())   
endif   

Return aRet


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Cria grupo de Perguntas.
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
********************************
Static Function ValidPerg(cPerg)
********************************

PutSx1( cPerg,'01','Data De     ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Data Ate    ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'03','C.Custo De  ?','','','mv_ch3','C',09,0,0,'G','','CTT','','','mv_par03','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'04','C.Custo Ate ?','','','mv_ch4','C',09,0,0,'G','','CTT','','','mv_par04','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'05','Item Ctb.De ?','','','mv_ch5','C',11,0,0,'G','','','','','mv_par05','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'06','Item Ctb.Ate?','','','mv_ch6','C',11,0,0,'G','','','','','mv_par06','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'07','Cl.Vlr.De   ?','','','mv_ch7','C',09,0,0,'G','','CTH','','','mv_par07','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'08','Cl.Vlr.Ate  ?','','','mv_ch8','C',09,0,0,'G','','CTH','','','mv_par08','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'09','Tipo Saldo  ?','','','mv_ch9','C',01,0,0,'G','','SL','','','mv_par09','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'10','Moeda       ?','','','mv_cha','C',02,0,0,'G','','CTO','','','mv_par10','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'11','Conta De    ?','','','mv_chb','C',20,0,0,'G','','CT1','','','mv_par11','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'12','Conta Ate   ?','','','mv_chc','C',20,0,0,'G','','CT1','','','mv_par12','','','','','','','','','','','','','','','','',{},{},{} )

Return