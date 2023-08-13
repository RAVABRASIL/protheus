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
User Function CTBA01()
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
Local LF        := CHR(13) + CHR(10)                              

ProcRegua(0) // Regua

cQuery := "SELECT "
cQuery += "   LP, CHAVE, CONTA, DCONTA, CUSTO, DDATA, TPSALD, " + LF
cQuery += "   DC, LOTE, SUBLOTE, DOC, LINHA, HIST, " + LF
cQuery += "   TIPOLAN, VALOR, EMPORI, FILORI " + LF
cQuery += "FROM " + LF
cQuery += "( " + LF
cQuery += "   SELECT " + LF
cQuery += "      CT2_LP LP, CT2_KEY CHAVE, CT2_FILIAL FILIAL, CT1_CONTA CONTA, ISNULL(CT1_DESC01,'') DCONTA, ISNULL(CT2_CCD,'') CUSTO,ISNULL(CT2_ITEMD,'') ITEM, " + LF
cQuery += "      ISNULL(CT2_CLVLDB,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, " + LF
cQuery += "      ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'') SUBLOTE, " + LF
cQuery += "      ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_CREDIT,'') XPARTIDA, " + LF
cQuery += "      ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '1' TIPOLAN, " + LF
cQuery += "      ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI " + LF
cQuery += "   FROM " + LF
cQuery += "      "+RetSqlName("CT1")+" CT1 LEFT JOIN "+RetSqlName("CT2")+" CT2 " + LF
cQuery += "   ON " + LF
cQuery += "      CT2.CT2_DEBITO = CT1.CT1_CONTA  " + LF
cQuery += "      AND CT2.CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " + LF
cQuery += "      AND CT2.CT2_CCD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + LF
cQuery += "      AND CT2.CT2_ITEMD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + LF
cQuery += "      AND CT2.CT2_CLVLDB BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + LF
cQuery += "      AND CT2.CT2_TPSALD = '"+MV_PAR09+"' " + LF
cQuery += "      AND CT2.CT2_MOEDLC = '"+MV_PAR10+"' " + LF
cQuery += "      AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') " + LF
cQuery += "      AND CT2_VALOR <> 0 " + LF
cQuery += "      AND CT2.D_E_L_E_T_ = ' ' " + LF
cQuery += "   WHERE " + LF
cQuery += "      CT1.CT1_FILIAL = '"+xFilial("CT1")+"' " + LF
cQuery += "      AND CT1.CT1_CLASSE = '2' " + LF
cQuery += "      AND CT1.CT1_CONTA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' " + LF
cQuery += "      AND CT1.D_E_L_E_T_ = '' " + LF
cQuery += "   UNION " + LF
cQuery += "   SELECT " + LF
cQuery += "      CT2_LP LP, CT2_KEY CHAVE, CT2_FILIAL FILIAL, CT1_CONTA CONTA, ISNULL(CT1_DESC01,'') DCONTA, ISNULL(CT2_CCC,'') CUSTO, ISNULL(CT2_ITEMC,'') ITEM, " + LF
cQuery += "      ISNULL(CT2_CLVLCR,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, " + LF
cQuery += "      ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'')SUBLOTE, " + LF
cQuery += "      ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_DEBITO,'') XPARTIDA, " + LF
cQuery += "      ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '2' TIPOLAN, " + LF
cQuery += "      ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI " + LF
cQuery += "   FROM " + LF
cQuery += "      "+RetSqlName("CT1")+" CT1 LEFT JOIN "+RetSqlName("CT2")+" CT2 " + LF
cQuery += "   ON " + LF
cQuery += "      CT2.CT2_CREDIT =  CT1.CT1_CONTA " + LF
cQuery += "      AND CT2.CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " + LF
cQuery += "      AND CT2.CT2_CCC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + LF
cQuery += "      AND CT2.CT2_ITEMC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + LF
cQuery += "      AND CT2.CT2_CLVLCR BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + LF
cQuery += "      AND CT2.CT2_TPSALD = '"+MV_PAR09+"' " + LF
cQuery += "      AND CT2.CT2_MOEDLC = '"+MV_PAR10+"' " + LF
cQuery += "      AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') " + LF
cQuery += "      AND CT2_VALOR <> 0 " + LF
cQuery += "      AND CT2.D_E_L_E_T_ = ' ' " + LF
cQuery += "   WHERE " + LF
cQuery += "      CT1.CT1_FILIAL = '"+xFilial("CT1")+"' " + LF
cQuery += "      AND CT1.CT1_CLASSE = '2' " + LF
cQuery += "      AND CT1.CT1_CONTA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' " + LF
cQuery += "      AND CT1.D_E_L_E_T_ = '' " + LF
cQuery += ") RAZAO " + LF
cQuery += "WHERE " + LF
cQuery += "   VALOR > 0 " + LF
cQuery += "ORDER BY " + LF
cQuery += "   CONTA,DDATA,LOTE,SUBLOTE,DOC,LINHA " + LF
MemoWrite("C:\Temp\CTBA01.SQL" , cQuery )
//cQuery := ChangeQuery(cQuery)			
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'XCT2', .F., .T.)
                                                              
if !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   return
endIf                                                            

/*    
aCabec := { "LP","Filial","Conta","Desc.Conta","C.Custo","Desc.C.Custo","Data","LOTE/SUB/DOC/LINHA","Historico",;
            "Documento","Produto","Descrição","Código","Razão Social","Aprovador","Pedido Compra","Comprador","Solicitação Compra","Solicitante",;
            "Valor" }
*/
aCabec := { "LP","Filial","Conta","Desc.Conta","C.Custo","Desc.C.Custo","Data","LOTE/SUB/DOC/LINHA","Historico",;
        "Documento","Valor Unitario","Quantidade","Produto","Descrição","Código","Razão Social","Aprovador","Pedido Compra","Comprador","Solicitação Compra","Solicitante",;
            "Valor" }            
                
while XCT2->(!Eof())
	cChave := AllTrim(XCT2->CHAVE)
	nTam   := Len(cChave)
	If Substr(cChave,nTam,1) = "N"
		cChave := Substr(cChave,1, nTam - 1 )
	Endif
   //aCompras := Rastreia( XCT2->LP, AllTrim(XCT2->CHAVE) )
   aCompras := Rastreia( XCT2->LP, cChave )
   cDCusto  := Alltrim(Posicione( "CTT", 1, xFilial("CTT") + XCT2->CUSTO, "CTT_DESC01" ))
   /*
   AADD(aSumarios,{XCT2->LP,XCT2->FILORI,XCT2->CONTA,XCT2->DCONTA,XCT2->CUSTO,cDCusto,Dtoc(Stod(XCT2->DDATA)),XCT2->(LOTE+SUBLOTE+DOC+LINHA),;
                   XCT2->HIST,aCompras[1],aCompras[2],aCompras[3],aCompras[4],aCompras[5],aCompras[6],aCompras[7],aCompras[8],;
                   aCompras[9],aCompras[10],XCT2->VALOR })
   */
   AADD(aSumarios,{XCT2->LP,XCT2->FILORI,XCT2->CONTA,XCT2->DCONTA,XCT2->CUSTO,cDCusto,Dtoc(Stod(XCT2->DDATA)),(XCT2->LOTE+ '/' + XCT2->SUBLOTE + '/' + XCT2->DOC + '/' + XCT2->LINHA),;
                   XCT2->HIST,aCompras[1],aCompras[11],aCompras[12],aCompras[2],aCompras[3],aCompras[4],aCompras[5],aCompras[6],aCompras[7],aCompras[8],;
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

local cQuery := ""
local aRet := {"","","","","","","","","","","",""}
local lQ   := .F. 
LOCAL LF   := CHR(13) + CHR(10)

if cLP == "650"
   cQuery := "  " + LF
   cQuery += "SELECT /* 650 */ "  + LF
   cQuery += "   ISNULL(RTRIM(D1_DOC),'') DOC," + LF
   cQuery += "   ISNULL(RTRIM(D1_COD),'') PROD," + LF
   cQuery += "   ISNULL(RTRIM(B1_DESC),'') DESCR," + LF
   cQuery += "   ISNULL(D1_VUNIT,'') VALUNI," + LF  //FR - 28/05/14 - SOLICITADO POR RODRIGO TORRES
   cQuery += "   ISNULL(D1_QUANT,'') QTDE , " + LF  //FR - 28/05/14 - SOLICITADO POR RODRIGO TORRES
   cQuery += "   ISNULL(D1_FORNECE,'') FORN," + LF
   cQuery += "   ISNULL(RTRIM(A2_NOME),'') NOME, "
   cQuery += "   ISNULL(RTRIM(C1_NOMAPRO),'') APRO," + LF
   //cQuery += "   ISNULL(C1_PEDIDO,'') PC," + LF
   cQuery += "   ISNULL(D1_PEDIDO,'') PC," + LF
   cQuery += "   ISNULL(C7_USER,'') COMP," + LF
   //cQuery += "   ISNULL(C1_NUM,'') SC," + LF
   cQuery += "   ISNULL(C7_NUMSC,'') SC," + LF
   cQuery += "   ISNULL(C1_SOLICIT,'') SOLI " + LF
   
   cQuery += "FROM " + LF
   cQuery += "   "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA2")+" SA2, SD1020 SD1 "  + LF
   cQuery += "   LEFT JOIN SC7020 SC7 ON "  + LF
   cQuery += "      D1_FILIAL=C7_FILIAL AND D1_PEDIDO=C7_NUM AND D1_COD = C7_PRODUTO AND SC7.D_E_L_E_T_ <> '*' "  + LF
   cQuery += "   LEFT JOIN SC1020 SC1 ON " + LF
   cQuery += "      C1_FILIAL=C7_FILIAL AND C1_PEDIDO = C7_NUM AND C1_PRODUTO = C7_PRODUTO AND SC1.D_E_L_E_T_ <> '*' " + LF
   cQuery += "WHERE  " + LF
   //cQuery += "   D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM = '"+cChave+"' AND " + LF
   cQuery += "   D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = '"+cChave+"' AND " + LF
   cQuery += "   B1_COD = D1_COD AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND " + LF
   cQuery += "   SB1.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' " + LF
   MemoWrite("C:\Temp\Rastreia_D1.sql", cQuery )  
   lQ := .T.
elseif cLP == "513"
   cQuery := "  " + LF
   cQuery += "SELECT /* 513 */ "  + LF
   cQuery += "   '' DOC, '' PROD, '' DESCR, E2_FORNECE FORN, RTRIM(A2_NOME) NOME, '' APRO, '' PC, '' COMP, '' SC, '' SOLI " + LF
   cQuery += "FROM " + LF
   cQuery += "   SE2020 SE2, "+RetSqlName("SA2")+" SA2 " + LF
   cQuery += "WHERE  " + LF
   cQuery += "   E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = '"+cChave+"' AND  " + LF
   cQuery += "   A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND " + LF
   cQuery += "   SA2.D_E_L_E_T_ <> '*' AND SE2.D_E_L_E_T_ <> '*' " + LF
   MemoWrite("C:\Temp\Rastreia_E2.sql", cQuery )  
   lQ := .T.   
elseif cLP == "530" 
   cQuery := " " + LF
   cQuery += "SELECT  /* 530 */ "  + LF
   cQuery += "   '' DOC, '' PROD, '' DESCR, E5_FORNECE FORN, RTRIM(A2_NOME) NOME, '' APRO, '' PC, '' COMP, '' SC, '' SOLI " + LF
   cQuery += "FROM " + LF
   cQuery += "   SE5020 SE5, "+RetSqlName("SA2")+" SA2 " + LF
   cQuery += "WHERE  " + LF
   cQuery += "   E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_DATA+E5_CLIFOR+E5_LOJA+E5_SEQ = '"+cChave+"' AND  " + LF
   cQuery += "   A2_COD = E5_FORNECE AND A2_LOJA = E5_LOJA AND " + LF
   cQuery += "   SA2.D_E_L_E_T_ <> '*' AND SE5.D_E_L_E_T_ <> '*' " + LF
   lQ := .T. 
   MemoWrite("C:\Temp\Rastreia_E5.sql", cQuery )    
endif 
//MemoWrite("C:\Temp\Rastreia.sql", cQuery )  

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
      if cLP == "650"
      	aRet[11] := XTM->VALUNI
      	aRet[12] := XTM->QTDE
      endif
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