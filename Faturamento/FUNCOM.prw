#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "TOTVS.CH"  

#DEFINE PROGR 001
#DEFINE IMEDI 002

#DEFINE CAIXA 001
#DEFINE SACOS 002

#DEFINE DIRET 001
#DEFINE COORD 002
#DEFINE REPRE 003

#DEFINE NORTE    001
#DEFINE NORDESTE 002
#DEFINE COESTE   003
#DEFINE SUDESTE  004
#DEFINE SUL      005
#DEFINE TODAS    006

#DEFINE ANUAL   001
#DEFINE MENSAL  002
#DEFINE PERIODO 003

#DEFINE HOSPIT  001
#DEFINE DOMEST  002
#DEFINE INSTIT  003
#DEFINE TLINHAS 004

***********************************************************************
User Function MetaRava(cAno,nRegiao,cUF,nRelato,cCod,nProd,nPer,nLinha)
***********************************************************************
Local aRet := Array(3)

//Cálculo da Meta
if nRelato == DIRET  
   cQuery := "SELECT MVALOR=SUM(MVALOR), MFATOR=SUM(MFATOR), MCOBER=SUM(MCOBER) FROM ( "
   cQuery += "SELECT 0 AS MVALOR, "
   cQuery += "SUM(Z51_MVALOR*Z51_MFATOR)/CASE WHEN SUM(Z51_MVALOR)=0 THEN 1 ELSE SUM(Z51_MVALOR) END AS MFATOR, "
   cQuery += "0 AS MCOBER "
   cQuery += "FROM "+RetSqlName("Z51")+" " 
   cQuery += "WHERE Z51_ANO = '"+AllTrim(cAno)+"' AND Z51_MVALOR > 0 AND Z51_MFATOR > 0 "
   if cUF <> nil .and. !Empty(cUF)
      cQuery += "AND Z51_UF = '"+cUF+"' "
   endif
   /*
   if nRegiao == NORTE
      cQuery += "AND Z51_UF IN ('AC','AM','AP','PA','RO','RR','TO') "
   elseif nRegiao == NORDESTE
      cQuery += "AND Z51_UF IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') "
   elseif nRegiao == COESTE
      cQuery += "AND Z51_UF IN ('GO','MT','MS','DF') "
   elseif nRegiao == SUDESTE
      cQuery += "AND Z51_UF IN ('MG','ES','RJ','SP') "
   elseif nRegiao == SUL
      cQuery += "AND Z51_UF IN ('RS','PR','SC') "
   endif
   */
   Do Case
    	Case nRegiao == 1 //Gildo
    		cQuery += "AND Z51_UF IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') "
    	Case nRegiao == 2 //Marcos
    		cQuery += "AND Z51_UF IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') "
   EndCase
   
   if nLinha <> TLINHAS
      if nLinha == DOMEST
         cQuery += "AND Z51_LINHA = 'DOME' "
      elseif nLinha == INSTIT
         cQuery += "AND Z51_LINHA = 'INST' "
      elseif nLinha == HOSPIT
         cQuery += "AND Z51_LINHA = 'HOSP' "
      endif   
   endif

   cQuery += "AND D_E_L_E_T_ <> '*' "

   cQuery += "UNION "

   cQuery += "SELECT SUM(Z51_MVALOR"+if(nPer=MENSAL,"/12","")+") AS MVALOR, "
   cQuery += "0 AS MFATOR, 0 AS MCOBER "
   cQuery += "FROM "+RetSqlName("Z51")+" " 
   cQuery += "WHERE Z51_ANO = '"+AllTrim(cAno)+"' "
   if cUF <> nil .and. !Empty(cUF)
      cQuery += "AND Z51_UF = '"+cUF+"' "
   endif
/*
   if nRegiao == NORTE
      cQuery += "AND Z51_UF IN ('AC','AM','AP','PA','RO','RR','TO') "
   elseif nRegiao == NORDESTE
      cQuery += "AND Z51_UF IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') "
   elseif nRegiao == COESTE
      cQuery += "AND Z51_UF IN ('GO','MT','MS','DF') "
   elseif nRegiao == SUDESTE
      cQuery += "AND Z51_UF IN ('MG','ES','RJ','SP') "
   elseif nRegiao == SUL
      cQuery += "AND Z51_UF IN ('RS','PR','SC') "
   endif
*/
   Do Case
    	Case nRegiao == 1 //Gildo
    		cQuery += "AND Z51_UF IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') "
    	Case nRegiao == 2 //Marcos
    		cQuery += "AND Z51_UF IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') "
   EndCase

   if nLinha <> TLINHAS
      if nLinha == DOMEST
         cQuery += "AND Z51_LINHA = 'DOME' "
      elseif nLinha == INSTIT
         cQuery += "AND Z51_LINHA = 'INST' "
      elseif nLinha == HOSPIT
         cQuery += "AND Z51_LINHA = 'HOSP' "
      endif   
   endif

   cQuery += "AND D_E_L_E_T_ <> '*' "

   cQuery += "UNION "

   cQuery += "SELECT 0 AS MVALOR, "
   cQuery += "0 AS MFATOR, SUM(Z51_COBERT"+if(nPer=MENSAL,"/12","")+") AS MCOBER "
   cQuery += "FROM "+RetSqlName("Z51")+" " 
   cQuery += "WHERE Z51_ANO = '"+AllTrim(cAno)+"' "
   if cUF <> nil .and. !Empty(cUF)
      cQuery += "AND Z51_UF = '"+cUF+"' "
   endif
/*   if nRegiao == NORTE
      cQuery += "AND Z51_UF IN ('AC','AM','AP','PA','RO','RR','TO') "
   elseif nRegiao == NORDESTE
      cQuery += "AND Z51_UF IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') "
   elseif nRegiao == COESTE
      cQuery += "AND Z51_UF IN ('GO','MT','MS','DF') "
   elseif nRegiao == SUDESTE
      cQuery += "AND Z51_UF IN ('MG','ES','RJ','SP') "
   elseif nRegiao == SUL
      cQuery += "AND Z51_UF IN ('RS','PR','SC') "
   endif
*/
   Do Case
    	Case nRegiao == 1 //Gildo
    		cQuery += "AND Z51_UF IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') "
    	Case nRegiao == 2 //Marcos
    		cQuery += "AND Z51_UF IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') "
   EndCase

   if nLinha <> TLINHAS
      if nLinha == DOMEST
         cQuery += "AND Z51_LINHA = 'DOME' "
      elseif nLinha == INSTIT
         cQuery += "AND Z51_LINHA = 'INST' "
      elseif nLinha == HOSPIT
         cQuery += "AND Z51_LINHA = 'HOSP' "
      endif   
   endif

   cQuery += "AND D_E_L_E_T_ <> '*' "
   cQuery += ") AS META  "
elseif nRelato ==  COORD
   cQuery := "SELECT SUM(Z51_MVALOR"+if(nPer=MENSAL,"/12","")+") AS MVALOR, "
   cQuery += "SUM(Z51_MVALOR*Z51_MFATOR)/CASE WHEN SUM(Z51_MVALOR)=0 THEN 1 ELSE SUM(Z51_MVALOR) END AS MFATOR, "   
   cQuery += "SUM(Z51_COBERT"+if(nPer=MENSAL,"/12","")+") AS MCOBER "
   cQuery += "FROM "+RetSqlName("Z51")+" "
   cQuery += "WHERE Z51_ANO = '"+AllTrim(cAno)+"' AND Z51_COORD = '"+Alltrim(cCod)+"' "
   cQuery += "AND D_E_L_E_T_ <> '*' "
elseif nRelato == REPRE
   cQuery := "SELECT SUM(Z51_MVALOR"+if(nPer=MENSAL,"/12","")+") AS MVALOR, "
   cQuery += "SUM(Z51_MVALOR*Z51_MFATOR)/CASE WHEN SUM(Z51_MVALOR)=0 THEN 1 ELSE SUM(Z51_MVALOR) END AS MFATOR, "   
   cQuery += "SUM(Z51_COBERT"+if(nPer=MENSAL,"/12","")+") AS MCOBER "
   cQuery += "FROM "+RetSqlName("Z51")+" Z51 "
   cQuery += "WHERE Z51_ANO = '"+Alltrim(cAno)+"' AND Z51_REPRES = '"+Alltrim(cCod)+"' "
   cQuery += "AND Z51.D_E_L_E_T_ <> '*' "
endif

if nRelato <> DIRET
   if cUF <> nil .and. !Empty(cUF)
      cQuery += "AND Z51_UF = '"+cUF+"' "
   endif
   /*
   if nRegiao == NORTE
      cQuery += "AND Z51_UF IN ('AC','AM','AP','PA','RO','RR','TO') "
   elseif nRegiao == NORDESTE
      cQuery += "AND Z51_UF IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') "
   elseif nRegiao == COESTE
      cQuery += "AND Z51_UF IN ('GO','MT','MS','DF') "
   elseif nRegiao == SUDESTE
      cQuery += "AND Z51_UF IN ('MG','ES','RJ','SP') "
   elseif nRegiao == SUL
      cQuery += "AND Z51_UF IN ('RS','PR','SC') "
   endif
   */
   Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " AND Z51_UF IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') "
	Case nRegiao == 2 //Marcos
		cQuery += " AND Z51_UF IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') "
	EndCase
   
   if nLinha <> TLINHAS
      if nLinha == DOMEST
         cQuery += "AND Z51_LINHA = 'DOME' "
      elseif nLinha == INSTIT
         cQuery += "AND Z51_LINHA = 'INST' "
      elseif nLinha == HOSPIT
         cQuery += "AND Z51_LINHA = 'HOSP' "
      endif   
   endif   
endif

MemoWrite("D:\Temp\METARAVA.txt",cQuery)

TCQUERY cQuery NEW ALIAS '_TMPX'
aRet[1] := _TMPX->MVALOR
aRet[2] := _TMPX->MFATOR
aRet[3] := _TMPX->MCOBER
DbCloseArea("_TMPX")

return aRet


****************************************************************************************
User Function FatRava(nRegiao,cUF,nMes,nAno,nRelato,cCod,nProd,nPer,dDtDe,dDtAte,nLinha)
****************************************************************************************
//Retorna Volume KG, Volume R$, Fator, Prz Medio
local aRet := Array(5)
local cQuery1, cQuery2, cQryAux, cQuery, cIni,cFim

if nPer == MENSAL
   cIni := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
   cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))
elseif nPer == ANUAL
   cIni := DtoS(CtoD("01/01/"+Alltrim(Str(nAno))))
   cFim := DtoS(LastDay(Ctod("01/12/"+Alltrim(Str(nAno)))))
else
   cIni := DtoS(dDtDe)
   cFim := DtoS(dDtAte)
endif   
//Primeira parte da query
cQuery1 := "SELECT QUANT=SUM((D2_QUANT-D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+"), "
cQuery1 += "VALOR=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN), DESCONTO=CASE WHEN D2_DESC > 0 THEN SUM(D2_DESCON) ELSE SUM(0) END, "
cQuery1 += "(SUM(((D2_QUANT-D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+")*E4_PRZMED)/CASE WHEN SUM(((D2_QUANT-D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+")) = 0 THEN 1 ELSE "
cQuery1 += "SUM(((D2_QUANT-D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+")) END ) AS PRZMED "
cQuery1 += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA3")+" SA3, "
cQuery1 += RetSqlName("SE4")+" SE4, " + RetSqlName("SC5")+" SC5 " 
//cQuery1 += "WHERE D2_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery1 += "WHERE C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
//Segunda parte da query
cQuery2 := "F2_VEND1 = A3_COD AND F2_COND = E4_CODIGO "
if cUF <> nil .and. !Empty(cUF)
   cQuery2 += "AND F2_EST = '"+cUF+"' "
endif
/*
if nRegiao == NORTE
   cQuery2 += "AND F2_EST IN ('AC','AM','AP','PA','RO','RR','TO') "
elseif nRegiao == NORDESTE
   cQuery2 += "AND F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') "
elseif nRegiao == COESTE
   cQuery2 += "AND F2_EST IN ('GO', 'MT', 'MS', 'DF') "
elseif nRegiao == SUDESTE
   cQuery2 += "AND F2_EST IN ('MG', 'ES', 'RJ', 'SP') "
elseif nRegiao == SUL
   cQuery2 += "AND F2_EST IN ('RS', 'PR', 'SC') "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery2 += "AND F2_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') "
	Case nRegiao == 2 //Marcos
		cQuery2 += "AND F2_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') "
EndCase

if nRelato ==  REPRE
   cQuery2 += "AND RTRIM(A3_COD) LIKE '"+Alltrim(cCod)+"%' "
elseif nRelato == COORD
   cQuery2 += "AND ( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(F2_VEND1) LIKE '"+Alltrim(cCod)+"%' ) "
endif

cQuery2 += "AND D2_TIPO = 'N' AND D2_TP != 'AP' "
cQuery2 += "AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5118','6118','6119','5949','6949','5922','6922','5116','6116' ) "
cQuery2 += "AND D2_CLIENTE NOT IN ('031732','031733','006543','007005') "
cQuery2 += "AND D2_COD = B1_COD "
cQuery2 += "AND SB1.B1_SETOR "+if(nProd==SACOS,"<>","=")+"'39' AND SB1.B1_TIPO = 'PA' "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery2 += "AND B1_GRUPO IN('D','E') "
   elseif nLinha == INSTIT
      cQuery2 += "AND B1_GRUPO IN('A','B','G') "
   elseif nLinha == HOSPIT
      cQuery2 += "AND B1_GRUPO IN('C') "
   endif   
endif

cQuery2 += "AND D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND F2_DUPL <> ' ' "
cQuery2 += "AND D2_FILIAL+D2_PEDIDO = C5_FILIAL+C5_NUM "
cQuery2 += "AND SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' "
cQuery2 += "AND SE4.D_E_L_E_T_ <> '*' "
cQuery2 += "GROUP BY D2_DESC "
//Monto a query com o Union
cQuery := "SELECT SUM(QUANT) AS QUANT, SUM(VALOR) AS VALOR, "
cQuery += "( SUM(QUANT*PRZMED)/CASE WHEN SUM(QUANT) = 0 THEN 1 ELSE SUM(QUANT) END ) AS PRZMED, "
cQuery += "SUM(DESCONTO) AS DESCONTO FROM "
cQuery += "( "
cQuery += cQuery1
cQuery += "NOT ( D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' ) AND " //"NOT" Nao Considero o valor xDD
cQuery += cQuery2
cQuery += "UNION "
cQuery += cQuery1
cQuery += "( D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' ) AND " //Considero o valor xDD
cQuery += cQuery2
cQuery += ") AS FAT "

MemoWrite("C:\Temp\FatRava.sql", cQuery )

TCQUERY cQuery NEW ALIAS '_TMPX'
aRet[1] := _TMPX->QUANT    //Volume Quant/KG
aRet[2] := _TMPX->VALOR    //Volume R$
aRet[3] := aRet[2]/aRet[1] //Fator
aRet[4] := _TMPX->PRZMED   //Prazo Médio
aRet[5] := _TMPX->DESCONTO //Desconto R$

DbCloseArea("_TMPX")

return aRet


*******************************************************************
User Function CliRep(nRegiao,cUF,nMes,nAno,cCod,nProd,lReal,nLinha)
*******************************************************************
//Retorna ABC de Clientes do Rep passado no parametro
Local aRet := {}
Local cQuery1,cQuery2,cQuery3,cQuery4,cQuery,cIni,cFim,cIni1,cFim1

cIni := DtoS(CtoD(StrZero(Day(dDataBase),2)+"/"+StrZero(nMes,2)+"/"+Str(nAno))-120) //Ultimos 3 Meses
cFim := DtoS(CtoD(StrZero(Day(dDataBase),2)+"/"+StrZero(nMes,2)+"/"+Str(nAno)))

cIni1 := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
cFim1 := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))

cQuery := "SELECT "
cQuery += "  CLIENTE=SA1.A1_COD,LOJA=SA1.A1_LOJA,NOME=SA1.A1_NOME, "
cQuery += "  ULTCOM=MAX(SC5.C5_ENTREG), "
if lReal
   cQuery += "  QUANT=SUM(SC6.C6_QTDVEN*SC6.C6_PRUNIT-SC6.C6_VALDESC)/4, "
else
   cQuery += "  QUANT=SUM(SC6.C6_QTDVEN"+if(nProd==SACOS,"*SB1.B1_PESO","")+")/4, "
endif
cQuery += "  QTACUM=ISNULL((SELECT "
if lReal
   cQuery += "                   QUANT=SUM(SC6X.C6_QTDVEN*SC6X.C6_PRUNIT-SC6X.C6_VALDESC) "
else
   cQuery += "                   QUANT=SUM(SC6X.C6_QTDVEN*SB1X.B1_PESO) "
endif
cQuery += "                 FROM "
cquery += "                   "+RetSqlName("SB1")+" SB1X, "+RetSqlName("SC5")+" SC5X,"
cQuery += "                   "+RetSqlName("SC6")+" SC6X "
cQuery += "                 WHERE "
cQuery += "                   SC5X.C5_FILIAL = SC6X.C6_FILIAL AND "
cQuery += "                   SC6X.C6_BLQ <> 'R' AND SB1X.B1_TIPO = 'PA' AND "
cQuery += "                   SC6X.C6_PRODUTO = SB1X.B1_COD AND SC5X.C5_NUM = SC6X.C6_NUM AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "             SB1X.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "             SB1X.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "             SB1X.B1_GRUPO IN('C') AND "
   endif   
endif

cQuery += "                   SC5X.C5_CLIENTE = SA1.A1_COD AND SC5X.C5_LOJACLI = SA1.A1_LOJA AND "
cQuery += "                   SC5X.C5_ENTREG BETWEEN '"+cIni1+"' AND '"+cFim1+"' AND "
cQuery += "                   SC6X.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','5118','6118','6119','6922','5116','6116','6108') AND "
cQuery += "                   SB1X.B1_SETOR "+IF(nProd==SACOS,"<>","=")+"'39' AND "
cQuery += "                   RTRIM(SC5X.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' AND "
cQuery += "                   SC5X.D_E_L_E_T_ <> '*' AND SC6X.D_E_L_E_T_ <> '*' AND SB1X.D_E_L_E_T_ <> '*'),0) "
cQuery += "FROM " 
cQuery += "   "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5,"
cQuery += "   "+RetSqlName("SC6")+" SC6, "+RetSqlName("SA1")+" SA1 "
cQuery += "WHERE "
cQuery += "   SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "   SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "   SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "   SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "   SB1.B1_GRUPO IN('C') AND "
   endif   
endif
cQuery += "   SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "   SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "   SC5.C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim1+"' AND "
cQuery += "   SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "   SB1.B1_SETOR "+IF(nProd==SACOS,"<>","=")+"'39' AND "
cQuery += "   RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' AND "
if cUF <> nil .and. !Empty(cUF)
   cQuery += "AND SA1.A1_EST = '"+cUF+"' "
endif

/*if nRegiao == NORTE
   cQuery += "AND SA1.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') "
elseif nRegiao == NORDESTE
   cQuery += "AND SA1.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') "
elseif nRegiao == COESTE
   cQuery += "AND SA1.A1_EST IN ('GO','MT','MS','DF') "
elseif nRegiao == SUDESTE
   cQuery += "AND SA1.A1_EST IN ('MG','ES','RJ','SP') "
elseif nRegiao == SUL
   cQuery += "AND SA1.A1_EST IN ('RS','PR','SC') "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += "AND SA1.A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') "
	Case nRegiao == 2 //Marcos
		cQuery += "AND SA1.A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') "
EndCase

cQuery += "   SC5.D_E_L_E_T_ <> '*' AND SC6.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY A1_NOME,A1_COD,A1_LOJA "
cQuery += "ORDER BY QUANT DESC "

TCQUERY cQuery NEW ALIAS '_TMPX'
while !_TMPX->(EOF())  
   Aadd( aRet, {_TMPX->CLIENTE,_TMPX->LOJA,Alltrim(_TMPX->NOME),_TMPX->ULTCOM,_TMPX->QUANT,_TMPX->QTACUM } )   
   _TMPX->(DbSkip())
end
DbCloseArea("_TMPX")

return aRet


************************************************************
User Function CartRava(nCart,nRelato,cCod,nProd,cUF,nRegiao,nLinha)
************************************************************
//Retorna Volume KG, Volume R$, Fator
Local cQuery
Local aRet := Array(3)

cQuery := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT )"+if(nProd==SACOS,"*SB1.B1_PESO","")+") AS CARTEIRA_QT, "
cQuery += "SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT - SC6.C6_VALDESC ) AS CARTEIRA_RS "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, "
cQuery += RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
cQuery += RetSqlName( "SA1" ) + " SA1, " +RetSqlName( "SA3" )+ " SA3 "
cQuery += "WHERE "
cQuery += " SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += " SC6.C6_FILIAL = SC9.C9_FILIAL AND "
cQuery += " ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "             SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "             SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "             SB1.B1_GRUPO IN('C') AND "
   endif   
endif
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += " SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119' ) AND "
cQuery += "SB1.B1_SETOR "+if(nProd==SACOS,"<>","=")+"'39' AND "
if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND " 
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

if nCart = PROGR
   cQuery += "SC5.C5_ENTREG > '"+ dtos( lastday( dDatabase ) ) + "' and "
elseif nCart = IMEDI
   cQuery += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDatabase ) ) + "' and "
endif

cQuery += "SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.D_E_L_E_T_ = ' ' " 

if Select("CARX") > 0
	DbSelectArea("CARX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "CARX"

aRet[1] := CARX->CARTEIRA_QT 
aRet[2] := CARX->CARTEIRA_RS
aRet[3] := CARX->CARTEIRA_RS/CARX->CARTEIRA_QT //Fator

DbSelectArea("CARX")
DbCloseArea()

Return aRet


*******************************************************************
User Function SemCre(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinha,lReal)
*******************************************************************
//Retorna Volume KG, Volume R$, Fator
Local cQuery,cIni,cFim
Local aRet := {0,0}

Default nLinha := TLINHAS

cIni := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))

cQuery := "SELECT "
cQuery += "   TIPO     = CASE "
cQuery += "                 WHEN C9_BLCRED IN ('01','04') THEN 'N' " //Não avaliados
cQuery += "                 WHEN C9_BLCRED IN ('09')      THEN 'R' " //Rejeitados
cQuery += "              END,  "
cQuery += "   VOLUMEKG = SUM(C9_QTDLIB2), "
cQuery += "   VTOTAL=ISNULL(SUM((C9_QTDLIB*SC6.C6_PRUNIT)-SC6.C6_VALDESC),0) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SC9")+" SC9, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SB1")+" SB1 , "+RetSqlName("SC6")+" SC6 "
cQuery += "WHERE "
cQuery += "   C9_FILIAL = '"+xFilial("SC9")+"' AND "
cQuery += "   C9_BLCRED IN ('01','04','09' ) AND "
cQuery += "   C9_NFISCAL = '' AND "
cQuery += "   C9_SEQUEN  = '01' AND "
cQuery += "   C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "   A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND "
cQuery += "   C9_PRODUTO = B1_COD AND "
cQuery += "   C5_NUM = C9_PEDIDO AND "
cQuery += "   C5_VEND1 = A3_COD AND "
//cQuery += "   A3_ATIVO <> 'N' AND "
//

cQuery += "   C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "   C5_FILIAL=C6_FILIAL AND "
cQuery += "   C5_NUM = C6_NUM AND "
cQuery += "   C5_CLIENTE + C5_LOJACLI = C9_CLIENTE + C9_LOJA AND "
cQuery += "   C9_ITEM = C6_ITEM  AND "
cQuery += "   C6_PRODUTO = C9_PRODUTO AND "
cQuery += "   C9_PEDIDO = C6_NUM AND "
cQuery += "SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119' ) AND "

//


if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += " SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += " SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += " SB1.B1_GRUPO IN('C') AND "
   endif
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND "
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "   SC6.D_E_L_E_T_ = '' AND "
cQuery += "   SC9.D_E_L_E_T_ = '' AND "
cQuery += "   SA1.D_E_L_E_T_ = '' AND "
cQuery += "   SC5.D_E_L_E_T_ = '' AND "
cQuery += "   SB1.D_E_L_E_T_ = '' AND "
cQuery += "   SA3.D_E_L_E_T_ = '' "

cQuery += "GROUP BY "
cQuery += "   CASE "
cQuery += "      WHEN C9_BLCRED IN ('01','04') THEN 'N' "
cQuery += "      WHEN C9_BLCRED IN ('09')      THEN 'R' "
cQuery += "   END "
cQuery += "ORDER BY "
cQuery += "   TIPO "

if Select("CREX") > 0
	DbSelectArea("CREX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "CREX"

while !CREX->(EOF()) 
   if CREX->TIPO = "N" //NAO AVALIADO
      aRet[1] := IIF(lReal,CREX->VTOTAL,CREX->VOLUMEKG)
   else //REJEITADO
      aRet[2] := IIF(lReal,CREX->VTOTAL,CREX->VOLUMEKG)      
   endif   
   CREX->(DbSkip())
end

DbSelectArea("CREX")
DbCloseArea()

Return aRet


**********************************************************************************
User Function DevRava(nMes,nAno,nRelato,cCod,nProd,cUF,nRegiao,nPer,nLinha,lDoMes)
**********************************************************************************
Local cQuery,cIni,cFim
Local aRet := {0,0}

Default nPer   := MENSAL
Default nLinha := TLINHAS
Default lDoMes := .F.

if nPer == MENSAL
   cIni := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
   cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))
elseif nPer == ANUAL
   cIni := DtoS(CtoD("01/01/"+Alltrim(Str(nAno))))
   cFim := DtoS(LastDay(Ctod("01/12/"+Alltrim(Str(nAno)))))
else
   cIni := DtoS(dDtDe)
   cFim := DtoS(dDtAte)
endif   

cQuery := "SELECT "
cQuery += "   DEV_KG = SUM(SD2.D2_QTDEDEV * SB1.B1_PESO), "
//cQuery += "   DEV_RS = SUM((SD2.D2_QTDEDEV*SD2.D2_PRCVEN) / SB1.B1_PESO) "
  cQuery += "   DEV_RS =ISNULL(SUM((SD2.D2_QTDEDEV*SC6.C6_PRUNIT)-SC6.C6_VALDESC ),0) "
cQuery += "FROM  "
cQuery += "   " + RetSqlName( "SA1" ) + " SA1 (NOLOCK), "
cQuery += "   " + RetSqlName( "SA3" ) + " SA3 (NOLOCK), "
cQuery += "   " + RetSqlName( "SC6" ) + " SC6 (NOLOCK) "
cQuery += "   INNER JOIN " + RetSqlName( "SC5" ) + " SC5 (NOLOCK) "
cQuery += "   ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "   INNER JOIN " + RetSqlName( "SB1" ) + " SB1 (NOLOCK) "
cQuery += "   ON C6_PRODUTO = B1_COD "
cQuery += "   INNER JOIN " + RetSqlName( "SD2" ) + " SD2 (NOLOCK) "
cQuery += "   ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV "
cQuery += "WHERE "
cQuery += "   SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "   SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "   SB1.B1_SETOR <> '39' AND "
cQuery += "   SA1.A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND "
cQuery += "   SA3.A3_COD = SC5.C5_VEND1 AND "
if lDoMes //Vendas no Mes para o Mes
   cQuery += "   SC5.C5_EMISSAO BETWEEN '"+cIni+"' and '"+cFim+"' AND "
endif
cQuery += "   SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "   SC5.C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "   SD2.D2_QTDEDEV > 0 AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += " SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += " SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += " SB1.B1_GRUPO IN('C') AND "
   endif
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND "
   //cQuery += "SA1.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND "   
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   //cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
   //cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "   SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "   SD2.D_E_L_E_T_ = ' ' "

MemoWrite("D:\Temp\DevRava.txt",cQuery)

if Select("DEVX") > 0
	DbSelectArea("DEVX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "DEVX"

aRet[1] := DEVX->DEV_KG
aRet[2] := DEVX->DEV_RS

DbSelectArea("DEVX")
DbCloseArea()

Return aRet


****************************************************************************************
User Function VendRava(nMes,nAno,nRelato,cCod,nProd,cUF,nRegiao,lDet,nPer,nLinha,lDoMes)
****************************************************************************************
//Retorna Volume KG, Volume R$, Fator
Local cQuery,cIni,cFim
Local aRet := {}

Default lDet   := .F.
Default nPer   := MENSAL
Default nLinha := TLINHAS
Default lDoMes := .F.

if nPer == MENSAL
   cIni := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
   cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))
elseif nPer == ANUAL
   cIni := DtoS(CtoD("01/01/"+Alltrim(Str(nAno))))
   cFim := DtoS(LastDay(Ctod("01/12/"+Alltrim(Str(nAno)))))
else
   cIni := DtoS(dDtDe)
   cFim := DtoS(dDtAte)
endif   

//cIni := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
//cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))
if lDet
   cQuery := "SELECT FILIAL, PEDIDO, NOTA, SERIE, SUM(VENDIDO_QT) VENDIDO_QT, SUM(VENDIDO_RS) VENDIDO_RS, SUM(VALDESC) VALDESC, XDD "
   cQuery += "FROM "
   cQuery += "( "
   cQuery += "   SELECT FILIAL=C5_FILIAL,PEDIDO=C5_NUM, NOTA=C6_NOTA,SERIE=C6_SERIE, "
   cQuery += "    SUM((SC6.C6_QTDVEN)"+if(nProd==SACOS,"*SB1.B1_PESO","")+") AS VENDIDO_QT, "
   cQuery += "    SUM(SC6.C6_QTDVEN*SC6.C6_PRUNIT-SC6.C6_VALDESC) AS VENDIDO_RS, "
   cQuery += "    SUM(SC6.C6_VALDESC) AS VALDESC, CASE WHEN C5_DESC1 > 0 THEN 'X' ELSE ' ' END AS XDD "
else
   cQuery := "SELECT SUM(SC6.C6_QTDVEN"+if(nProd==SACOS,"*SB1.B1_PESO","")+") AS VENDIDO_QT, "
   cQuery += "SUM(SC6.C6_QTDVEN*SC6.C6_PRUNIT-SC6.C6_VALDESC) AS VENDIDO_RS, "
   cQuery += "(SUM((SC6.C6_QTDVEN"+if(nProd==SACOS,"*SB1.B1_PESO","")+")*E4_PRZMED)/CASE WHEN SUM((SC6.C6_QTDVEN"+if(nProd==SACOS,"*SB1.B1_PESO","")+")) = 0 THEN 1 ELSE "
   cQuery += "SUM((SC6.C6_QTDVEN"+if(nProd==SACOS,"*SB1.B1_PESO","")+")) END ) AS PRZMED, "
   cQuery += "SUM(SC6.C6_VALDESC) AS VALDESC "
endif

cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, "
cQuery += RetSqlName( "SC6" )+ " SC6, "+RetSqlName( "SA1" ) + " SA1, " +RetSqlName( "SA3" )+ " SA3, " +RetSqlName( "SE4" )+ " SE4 "
	cQuery += "WHERE "
cQuery += "SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
//cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
if lDoMes //Vendas no Mes para o Mes
   cQuery += "SC5.C5_EMISSAO BETWEEN '"+cIni+"' and '"+cFim+"' AND "
endif
cQuery += "SC5.C5_CLIENTE NOT IN ('031732','031733','006543','007005') AND "
cQuery += "SC5.C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "SB1.B1_SETOR "+IF(nProd==SACOS,"<>","=")+"'39' AND "
cQuery += "SC5.C5_CONDPAG = E4_CODIGO AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += " SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += " SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += " SB1.B1_GRUPO IN('C') AND "
   endif
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND "
   //cQuery += "SA1.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND "   
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   //cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
   //cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.D_E_L_E_T_ = ' ' " 

if lDet
   cQuery += "GROUP BY C5_FILIAL, C5_NUM, C6_NOTA, C6_SERIE, C5_DESC1, C5_CONDPA1 "
   cQuery += ") AS RESULTADO "
   cQuery += "GROUP BY FILIAL, PEDIDO, NOTA, SERIE, XDD "
   cQuery += "ORDER BY FILIAL, PEDIDO, NOTA, SERIE "
endif

MemoWrite("D:\Temp\VendRava.txt",cQuery)

if Select("VENX") > 0
	DbSelectArea("VENX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "VENX"

if lDet
   while !VENX->(EOF()) 
      Aadd(aRet, {VENX->FILIAL,VENX->PEDIDO,VENX->NOTA,VENX->SERIE,VENX->VENDIDO_QT,VENX->VENDIDO_RS,VENX->VENDIDO_RS/VENX->VENDIDO_QT,VENX->VALDESC,VENX->XDD})
      VENX->(DbSkip())
   end
else
   aDev := U_DevRava(nMes,nAno,nRelato,cCod,nProd,cUF,nRegiao,nPer,nLinha,lDoMes)
   
   Aadd( aRet, VENX->VENDIDO_QT - aDev[1] )
   Aadd( aRet, VENX->VENDIDO_RS - aDev[2] )
   Aadd( aRet, ( VENX->VENDIDO_RS - aDev[2] ) / ( VENX->VENDIDO_QT  - aDev[1] ) ) //Fator
   Aadd( aRet, VENX->PRZMED )  //Prazo Medio
   Aadd( aRet, VENX->VALDESC ) //Vlr Desconto
endif

DbSelectArea("VENX")
DbCloseArea()

Return aRet


*********************************************************************
User Function CobRava(nMes,nAno,nRelato,cCod,cUF,nRegiao,nPer,nLinha)
*********************************************************************
//Retorna Cobertura de Clientes
Local cQuery,cIni,cFim
Local aRet := {}

Default nPer   := MENSAL
Default nLinha := TLINHAS

if nPer == MENSAL
   cIni := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
   cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))
elseif nPer == ANUAL
   cIni := DtoS(CtoD("01/01/"+Alltrim(Str(nAno))))
   cFim := DtoS(LastDay(Ctod("01/12/"+Alltrim(Str(nAno)))))
endif   

cQuery := "SELECT "
cQuery += "   COBERTURA=COUNT(CLIENTE) "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      CLIENTE=A1_COD "
cQuery += "   FROM "
cQuery += "      "+RetSqlName("SC5")+" SC5 WITH (NOLOCK), "
cQuery += "      "+RetSqlName("SC6")+" SC6 WITH (NOLOCK), "
cQuery += "      "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "
cQuery += "      "+RetSqlName("SE4")+" SE4 WITH (NOLOCK), "
cQuery += "      "+RetSqlName("SA1")+" SA1 WITH (NOLOCK), "
cQuery += "      "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) "
cQuery += "   WHERE "
cQuery += "      SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery += "      SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "      SC5.C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "      SB1.B1_SETOR <> '39' AND "
cQuery += "      SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "      SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "      C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "      A1_COD = C5_CLIENTE AND "
cQuery += "      A3_COD = C5_VEND1 AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += " SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += " SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += " SB1.B1_GRUPO IN('C') AND "
   endif
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND "
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "      SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "      SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' " 
cQuery += "   GROUP BY "
cQuery += "      A1_COD "
cQuery += ") AS COBERTURA "

if Select("COBX") > 0
	DbSelectArea("COBX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "COBX"
aRet := {0,COBX->COBERTURA}

DbSelectArea("COBX")
DbCloseArea()

return aRet

******************************************************************************
User Function RavaTopCli(nMes,nAno,nRelato,cCod,nProd,cUF,nRegiao,nLinha,nTop)
******************************************************************************

local cQuery
local cIni := DtoS(CtoD(StrZero(Day(Date()),2)+"/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno)))-180) //6 meses atras
local cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno)))))
local aRet := {}

Default nTop := 10

cQuery := "SELECT TOP "+Alltrim(Str(nTop))+" "
cQuery += "   COD=A1_COD, "
cQuery += "   NOME=A1_NOME, "
cQuery += "   UF=A1_EST, "
cQuery += "   MEDIAKG=SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO)/6, "
cQuery += "   MEDIARS=SUM(SC6.C6_QTDVEN*SC6.C6_PRUNIT-SC6.C6_VALDESC),
cQuery += "   DTUPED=MAX(C5_ENTREG) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "   "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4  "
cQuery += "WHERE "
cQuery += "   SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "   SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "   SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery += "   SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "   SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "   SC5.C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "   SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "   SB1.B1_SETOR "+IF(nProd==SACOS,"<>","=")+"'39' AND "
cQuery += "   SC5.C5_CONDPAG = E4_CODIGO AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += " SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += " SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += " SB1.B1_GRUPO IN('C') AND "
   endif
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND "
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "   SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "   SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "   SA1.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY "
cQuery += "   A1_COD, A1_NOME, A1_EST "
cQuery += "ORDER BY "
cQuery += "   MEDIAKG DESC "

if Select("VENX") > 0
	DbSelectArea("VENX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "VENX"

while !VENX->(EOF()) 
   Aadd(aRet, {VENX->COD,VENX->NOME,VENX->UF,VENX->MEDIAKG,STOD(VENX->DTUPED),VENX->MEDIARS})
   VENX->(DbSkip())
end

DbSelectArea("VENX")
DbCloseArea()
   
return aRet


*******************************************
Static function volUPed(cCliente,nMes,nAno)
*******************************************

local cQuery := ""
local cIni := DtoS(CtoD(StrZero(Day(Date()),2)+"/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno)))-180) //6 meses atras
local cFim := DtoS(Ctod(StrZero(Day(Date()),2)+"/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno))))
local nRet := 0


cQuery := "SELECT TOP 1 "
cQuery += "   KGUPED=SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "   "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4 "
cQuery += "WHERE "
cQuery += "   SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "   SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "   SC5.C5_CLIENTE = '"+cCliente+"' AND "
cQuery += "   SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery += "   SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "   SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "   SC5.C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "   SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "   SB1.B1_SETOR <> '39' AND "
cQuery += "   SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "   SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "   SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "   SA1.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY "
cQuery += "   C5_EMISSAO "
cQuery += "ORDER BY "
cQuery += "   C5_EMISSAO DESC "
   
if Select("UVENX") > 0
	DbSelectArea("UVENX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "UVENX"

nRet := UVENX->KGUPED

DbSelectArea("UVENX")
DbCloseArea()
   
return nRet


********************************************************************
User Function Parcs(nMes,nAno,nRelato,cCod,nProd,cUF,nRegiao,nLinha)
********************************************************************

local cQuery
local cIni := DtoS(CtoD(StrZero(Day(Date()),2)+"/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno)))-180) //6 meses atras
local cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno)))))
local aRet := {}

cQuery := "SELECT "
cQuery += "   COD=A1_COD, "
cQuery += "   NOME=A1_NOME, "
cQuery += "   UF=A1_EST, "
cQuery += "   MEDIAKG=SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO)/6, "
cQuery += "   DTUPED=MAX(C5_ENTREG) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "   "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4  "
cQuery += "WHERE "
cQuery += "   SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "   SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "   SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery += "   SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "   A1_COD IN "+FormatIN(SuperGetMV("MV_P"+cCod),"/")+" AND "
cQuery += "   SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "   SC5.C5_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
cQuery += "   SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "   SB1.B1_SETOR "+IF(nProd==SACOS,"<>","=")+"'39' AND "
cQuery += "   SC5.C5_CONDPAG = E4_CODIGO AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += " SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += " SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += " SB1.B1_GRUPO IN('C') AND "
   endif
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND "
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "   SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "   SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "   SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "   SA1.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY "
cQuery += "   A1_COD, A1_NOME, A1_EST "
cQuery += "ORDER BY "
cQuery += "   MEDIAKG DESC "

if Select("PARX") > 0
	DbSelectArea("PARX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "PARX"

while !PARX->(EOF()) 
   Aadd(aRet, {PARX->COD,PARX->NOME,PARX->UF,PARX->MEDIAKG,STOD(PARX->DTUPED)})
   PARX->(DbSkip())
end

DbSelectArea("PARX")
DbCloseArea()
   
return aRet

********************************************************************************
User Function InAtiva(nMes,nAno,nRelato,cCod,nProd,cUF,nRegiao,nLinha,lInativos)
********************************************************************************

local cQuery
local cIni := DtoS(CtoD(StrZero(Day(Date()),2)+"/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno)))-300) //10 meses atras (4 para inativar e 6 media de vendas)
local cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Alltrim(Str(nAno)))))
local aRet := {}

Default lInativos := .F.

cQuery := "SELECT "
cQuery += "COD, NOME, TEL, UF, MEDIAKG, MEDIARS, DTUPED, DIAS "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      COD    = A1_COD, "
cQuery += "      NOME   = A1_NOME, "
cQuery += "      TEL    = RTRIM(A1_TEL), "
cQuery += "      UF     = A1_EST, "
cQuery += "      MEDIARS= SUM( SC6.C6_QTDVEN*SC6.C6_PRUNIT-SC6.C6_VALDESC ), "
cQuery += "      MEDIAKG= SUM( SC6.C6_QTDVEN*SB1.B1_PESO)/6, "
cQuery += "      DTUPED = MAX(C5_EMISSAO), "
cQuery += "      DIAS   = CAST(GETDATE() - CONVERT(DATETIME,MAX(SC5.C5_EMISSAO)) AS INTEGER) "
cQuery += "   FROM "
cQuery += "      "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlname("SC6")+" SC6, "
cQuery += "      "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4  "
cQuery += "   WHERE "
cQuery += "      SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
//cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery += "      SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND SA1.A1_ATIVO <> 'N' AND "
cQuery += "      SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "      SC5.C5_EMISSAO BETWEEN '"+cINI+"' AND '"+cFim+"' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "      SB1.B1_SETOR "+IF(nProd==SACOS,"<>","=")+"'39' AND "
cQuery += "      SC5.C5_CONDPAG = E4_CODIGO AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += " SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += " SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += " SB1.B1_GRUPO IN('C') AND "
   endif
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND "
   //cQuery += "SA1.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND "
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   //cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
   //cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "      SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "      SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_COD, A1_NOME, A1_EST, A1_TEL "
cQuery += ") AS VENDIDO "
cQuery += "WHERE DIAS "+if(lInativos,">= 120 ","BETWEEN 31 AND 119 ")+" "
cQuery += "ORDER BY "
cQuery += "   DIAS "

if Select("INAX") > 0
	DbSelectArea("INAX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "INAX"

while !INAX->(EOF()) 
   Aadd(aRet, {INAX->COD,INAX->NOME,INAX->TEL,INAX->UF,INAX->MEDIAKG,STOD(INAX->DTUPED),INAX->DIAS, INAX->MEDIARS})
   INAX->(DbSkip())
end

DbSelectArea("INAX")
DbCloseArea()

return aRet


****************************************************************
User Function BoniRava(nMes,nAno,nRelato,cCod,nProd,cUF,nRegiao,nLinha)
****************************************************************
//Retorna Volume KG, Volume R$
Local cQuery
Local aRet := Array(2)

cQuery := "SELECT QUANT=SUM((D2_QUANT-D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+"), "
cQuery += "VALOR=SUM(((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN)+D2_VALIPI) "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA3")+" SA3, "
cQuery += RetSqlName("SA1")+" SA1, " + RetSqlName("SC5")+" SC5 "
cQuery += "WHERE C5_EMISSAO BETWEEN '"+DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))+"' AND "
cQuery += "'"+DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))+"' "
cQuery += "AND D2_TIPO = 'N' "
cQuery += "AND D2_TES in ( '514' , '542', '548', '550', '561' ) "
cQuery += "AND D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC "
cQuery += "AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE "
cQuery += "AND D2_LOJA=F2_LOJA AND F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA "
cQuery += "AND D2_COD = B1_COD AND F2_VEND1 = A3_COD "
cQuery += "AND SB1.B1_SETOR "+if(nProd==SACOS,"<>","=")+"'39' "
cQuery += "AND D2_FILIAL+D2_PEDIDO=C5_FILIAL+C5_NUM  AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "SB1.B1_GRUPO IN('C') AND "
   endif   
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato ==  REPRE
   cQuery += " RTRIM(A3_COD) LIKE '"+Alltrim(cCod)+"%' AND "
elseif nRelato == COORD
   cQuery += " ( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(F2_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
endif

cQuery += " F2_DUPL = ' ' AND "
cQuery += " SF2.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS '_TMPX'
aRet[1] := _TMPX->QUANT
aRet[2] := _TMPX->VALOR

DbCloseArea("_TMPX")

return aRet


****************************************
User Function MargRava(nFator,nMes,nAno)
****************************************
Local nMargem := nMP := 0

DBSelectArea("SX5")
DbSetOrder(1)
if SX5->(Dbseek(xFilial("SX5") + "Z3" + Alltrim(Str(nAno))+StrZero(nMes,2) ))  
	nMP := Val( Alltrim(SX5->X5_DESCRI) )
endif
nMargem := Round( ((nFator-nMP)/nFator)*100, 2)

return nMargem


**********************************************************************
User Function PVRava(nPed,nRelato,cCod,nProd,cUF,nRegiao,nDias,nLinha)
**********************************************************************

//Retorna "nPed" Pedidos mais atrasados
Local cQuery := ""
Local aRet   := {}

if nDias <> nil .and. !Empty(nDias)
   cQuery := "SELECT C5_NUM, A1_COD, A1_LOJA, A1_NOME, A1_EST, DIAS "
   cQuery += "FROM ( "
   cQuery += "SELECT C5_NUM, A1_COD, A1_LOJA, A1_NOME, A1_EST, "      
else
   cQuery += "SELECT "+IF(nPed<>999," TOP "+AllTrim(Str(nPed)),"")+" C5_NUM, A1_COD, A1_LOJA, A1_NOME, A1_EST, "   
endif
cQuery += "CAST( CONVERT(DATETIME,'"+DtoS(dDataBase)+"') - CONVERT(DATETIME,C5_ENTREG) AS INTEGER ) as DIAS "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, "
cQuery += RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
cQuery += RetSqlName( "SA1" ) + " SA1, " +RetSqlName( "SA3" )+ " SA3 "
cQuery += "WHERE "
cQuery += " SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += " SC6.C6_FILIAL = SC9.C9_FILIAL AND "
cQuery += " ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "SB1.B1_GRUPO IN('C') AND "
   endif   
endif

cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += " SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "SB1.B1_SETOR "+if(nProd==SACOS,"<>","=")+"'39' AND "

if cUF <> nil .and. !Empty(cUF)
   cQuery += "A1_EST = '"+cUF+"' AND "
endif
/*
if nRegiao == NORTE
   cQuery += "A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "A1_EST IN ('RS','PR','SC') AND "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery += " A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') AND "
	Case nRegiao == 2 //Marcos
		cQuery += " A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') AND "
EndCase

if nRelato == REPRE
   cQuery += "SC5.C5_VEND1 LIKE '"+Alltrim(cCod)+"%' AND " 
elseif nRelato == COORD
   cQuery += "( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SC5.C5_VEND1) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SC5.C5_VEND1 = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif
cQuery += "SC5.C5_EMISSAO <= '"+ dtos( dDatabase ) + "' AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.D_E_L_E_T_ = ' ' " 
cQuery += "GROUP BY C5_NUM,A1_COD, A1_LOJA, A1_NOME,C5_ENTREG, A1_EST "
if nDias <> nil .and. !Empty(nDias)
   cQuery += ") AS VENDAS "   
   cQuery += "WHERE DIAS >= "+Alltrim(Str(nDias))+" "
endif
cQuery += "ORDER BY DIAS DESC "

if Select("CARX") > 0
	DbSelectArea("CARX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "CARX"

while !CARX->(EOF())
   Aadd( aRet, {CARX->A1_COD,CARX->A1_LOJA,CARX->A1_NOME,CARX->DIAS,CARX->C5_NUM,CARX->A1_EST } )
   CARX->(DbSkip())
end   

DbCloseArea("CARX")

Return aRet


***********************************
User Function RepUF(cUF,cCoor,cCod)
***********************************
//Retorna lista de representantes da UF
Local cQuery
Local aRet := {}

cQuery := "SELECT COD=A3_COD, NOME=A3_NOME, UF=Z51_UF "
cQuery += "FROM "+RetSqlName("SA3")+" SA3, "+RetSqlName("Z51")+" Z51 "
cQuery += "WHERE A3_COD = Z51_REPRES AND Z51_UF = '"+cUF+"' AND Z51_COORD = '"+cCoor+"' AND Z51_ANO = '"+Alltrim(Str(Year(dDataBase)))+"' "
cQuery += "AND SA3.D_E_L_E_T_ <> '*' AND Z51.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY A3_COD,A3_NOME,Z51_UF "
cQuery += "ORDER BY UF, COD "
if Select("REPX") > 0
	DbSelectArea("REPX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "REPX"

while !REPX->(EOF())
   Aadd( aRet, {REPX->COD,REPX->NOME,REPX->UF } )
   REPX->(DbSkip())
end   

DbCloseArea("REPX")

return aRet

/*
***********************************
User Function RepUF(cUF,cCoor,cCod)
***********************************
//Retorna lista de representantes da UF
Local cQuery
Local aRet := {}
Local cC := ""
if !Empty(cCod)
   cC := Posicione( "SA3", 1, xFilial("SA3") + cCod, "A3_SUPER" )
endif

cQuery := "SELECT COD=A3_COD, NOME=A3_NOME, UF=A3_EST "
cQuery += "FROM "+RetSqlName("SA3")+" WHERE A3_EST = '"+cUF+"' AND "
cQuery += "A3_ATIVO <> 'N' AND D_E_L_E_T_ <> '*' AND A3_SUPER = '"+if(!empty(cC),cC,cCoor)+"' "
cQuery += "GROUP BY A3_COD,A3_NOME,A3_EST "
cQuery += "ORDER BY UF, COD "
if Select("REPX") > 0
	DbSelectArea("REPX")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "REPX"

while !REPX->(EOF())
   Aadd( aRet, {REPX->COD,REPX->NOME,REPX->UF } )
   REPX->(DbSkip())
end   

DbCloseArea("REPX")

return aRet
*/

***************************
User Function RegiaoBR(cUF)
***************************
//Retorna regiao da cUF passada
Local cRegiao

if cUF $ "AC AM AP PA RO RR TO"
   nRegiao := NORTE   
elseif cUF $ "MA PI CE RN PB PE AL BA SE"
   nRegiao := NORDESTE   
elseif cUF $ "GO MT MS DF"
   nRegiao := COESTE   
elseif cUF $ "MG ES RJ SP"
   nRegiao := SUDESTE   
elseif cUF $ "RS PR SC"
   nRegiao := SUL
endif

return nRegiao

*******************************
User Function UFRegiao(nRegiao)
*******************************
//Retorna Ufs da cRegiao passada
Local aRet := {}
Local aReg := {}

//gildo
Aadd( aReg,{"NORTE"   ,{'ES','RJ','DF','MT','MS','PR','RS','SC','BA','PE','MG','SP','PB','GO'}} )
//marcos
Aadd( aReg,{"NORDESTE",{'AL','BA','CE','MA','PI','RN','SE','AC','AM','AP','PA','RO','RR','TO'}} )
//Aadd( aReg,{"NORTE"   ,{'AC','AM','AP','PA','RO','RR','TO'}} )
//Aadd( aReg,{"NORDESTE",{'AL','BA','CE','MA','PB','PE','PI','RN','SE'}} )
Aadd( aReg,{"C.OESTE" ,{'DF','GO','MT','MS'}} )
Aadd( aReg,{"SUDESTE" ,{'ES','MG','RJ','SP'}} ) 
Aadd( aReg,{"SUL"     ,{'PR','RS','SC'}} )

if nRegiao == NORTE
   Aadd( aRet, aReg[1] )
elseif nRegiao == NORDESTE
   Aadd( aRet, aReg[2] )
elseif nRegiao == COESTE
   Aadd( aRet, aReg[3] )
elseif nRegiao == SUDESTE
   Aadd( aRet, aReg[4] )
elseif nRegiao == SUL
   Aadd( aRet, aReg[5] )
else
   Return aReg   
endif

return aRet


*****************************************************************
User Function SendPSV60(cMailTo,cCopia,cAssun,cCorpo,cDir,cAnexo)
*****************************************************************

Local cEmailCc := cCopia
Local lResult  := .F.
Local lEnviado := .F.
Local cError   := ""

Local cAccount	 := GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	 := GetMV( "MV_RELSERV" )
Local cFrom		 := "ravasiga@ravaembalagens.com.br"
Local cArq      := cAnexo
Local cDes      := cDir+cAnexo

//U_ERavaMail(cMailTo,cCopia,cAssun,cCorpo,cDes)

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cDes; 	
	RESULT lEnviado
  
   nTent := 0
   while !lEnviado .and. nTent <= 5
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		conout(Replicate("*",60))
		conout("PSV60")
		conout("Posição de Vendas 6.0 " + Dtoc( Date() ) + ' - ' + Time() )
		conout(cAssun)
		conout("E-mail nao enviado. Erro encontrado: "+cError)			
		conout(Replicate("*",60))
	   
	   SEND MAIL FROM cFrom;
   	TO cMailTo;
	   CC cCopia;
	   SUBJECT cAssun;
	   BODY cCorpo;
	   ATTACHMENT cDes; 	
	   RESULT lEnviado      
	   nTent += 1
   end
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return ( lResult .And. lEnviado )


*****************************************************************
User Function SendPSV(cMailTo,cCopia,cAssun,cCorpo,cDir,cAnexo)
*****************************************************************

Local cEmailCc := cCopia

Local cUser	  := Alltrim(GetMV( "MV_RELACNT" ))
Local cPass   := Alltrim(GetMV( "MV_RELPSW"  ))
Local cServer := Alltrim(GetMV( "MV_RELSERV" ))
Local cFrom	  := Alltrim(GetMV( "MV_RELACNT" ))//"ravasiga@ravaembalagens.com.br"
Local cFile   := cDir+cAnexo

Local xRet
Local oServer, oMessage
      
oMessage := TMailMessage():New()
oMessage:Clear()
   
oMessage:cDate := cValToChar( Date() )
oMessage:cFrom := cFrom
oMessage:cTo := cMailTo
oMessage:cSubject := cAssun
oMessage:cBody := cCorpo
xRet := oMessage:AttachFile( cFile )
if xRet < 0
    cMsg := "Could not attach file " + cFile
    conout( cMsg )
    return
endif  
Sleep(5000)
oServer := tMailManager():New()

//oServer:SetUseSSL( .T. )
     
xRet := oServer:Init( "", cServer, cUser, cPass, 0, 25 )
if xRet != 0
   cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif
   
xRet := oServer:SetSMTPTimeout( 60 )
if xRet != 0
   cMsg := "Could not set " + cProtocol + " timeout to " + cValToChar( nTimeout )
   conout( cMsg )
endif
   
xRet := oServer:SMTPConnect()
if xRet <> 0
   cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif
   
xRet := oServer:SmtpAuth( cUser, cPass )
if xRet <> 0
   cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   oServer:SMTPDisconnect()
   return
endif
   
xRet := oMessage:Send( oServer )
if xRet <> 0
   cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
   conout( cMsg )
endif
   
xRet := oServer:SMTPDisconnect()
if xRet <> 0
   cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
endif

return


***************************************
User Function CBRava(cCod, nVol, nPrc )
***************************************

Local cQuery
Local aRet := {}

cQuery := "SELECT  "
cQuery += "Z34_PERC1 AS PERCINI, "
cQuery += "ISNULL( "
cQuery += "        case "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL1 and "+Alltrim(Str(nVol))+" <= Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT1 and "+Alltrim(Str(nPrc))+" <= Z34_FAT2 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL1 and "+Alltrim(Str(nVol))+" <= Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT1 and "+Alltrim(Str(nPrc))+" <= Z34_FAT2 ) then Z34_VOL1 "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nVol))+" <= Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 and "+Alltrim(Str(nPrc))+" <= Z34_FAT3 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nVol))+" <= Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 and "+Alltrim(Str(nPrc))+" <= Z34_FAT3 ) then Z34_VOL2 "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 and "+Alltrim(Str(nPrc))+" <= Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 and "+Alltrim(Str(nPrc))+" <= Z34_FAT4 ) then Z34_VOL3 "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL4 and "+Alltrim(Str(nVol))+" <= Z34_VOL5 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 and "+Alltrim(Str(nPrc))+" <= Z34_FAT5 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL5 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 and "+Alltrim(Str(nPrc))+" <= Z34_FAT5 ) then Z34_VOL4 "
cQuery += "        end  "
cQuery += ",0) AS VOLUME, "
cQuery += "ISNULL(  "
cQuery += "        case  "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL1 and "+Alltrim(Str(nVol))+" <= Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT1 and "+Alltrim(Str(nPrc))+" <= Z34_FAT2 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL1 and "+Alltrim(Str(nVol))+" <= Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT1 and "+Alltrim(Str(nPrc))+" <= Z34_FAT2 ) then Z34_FAT1 "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nVol))+" <= Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 and "+Alltrim(Str(nPrc))+" <= Z34_FAT3 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nVol))+" <= Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 and "+Alltrim(Str(nPrc))+" <= Z34_FAT3 ) then Z34_FAT2 "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 and "+Alltrim(Str(nPrc))+" <= Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 and "+Alltrim(Str(nPrc))+" <= Z34_FAT4 ) then Z34_FAT3 "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL4 and "+Alltrim(Str(nVol))+" <= Z34_VOL5 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 and "+Alltrim(Str(nPrc))+" <= Z34_FAT5 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL5 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 and "+Alltrim(Str(nPrc))+" <= Z34_FAT5 ) then Z34_FAT4 "
cQuery += "        end "
cQuery += ",0) AS FATOR, "
cQuery += "ISNULL( "
cQuery += "        case  "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL1 and "+Alltrim(Str(nVol))+" <= Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT1 and "+Alltrim(Str(nPrc))+" <= Z34_FAT2 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL1 and "+Alltrim(Str(nVol))+" <= Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nPrc))+" > Z34_FAT1 and "+Alltrim(Str(nPrc))+" <= Z34_FAT2 ) then ((Z34_PERC2-Z34_PERC1)) "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nVol))+" <= Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 and "+Alltrim(Str(nPrc))+" <= Z34_FAT3 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL2 and "+Alltrim(Str(nVol))+" <= Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nPrc))+" > Z34_FAT2 and "+Alltrim(Str(nPrc))+" <= Z34_FAT3 ) then ((Z34_PERC3-Z34_PERC1)) "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 and "+Alltrim(Str(nPrc))+" <= Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT3 and "+Alltrim(Str(nPrc))+" <= Z34_FAT4 ) then ((Z34_PERC4-Z34_PERC1)) "
cQuery += "          when ( "+Alltrim(Str(nVol))+" > Z34_VOL4 and "+Alltrim(Str(nVol))+" <= Z34_VOL5 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 and "+Alltrim(Str(nPrc))+" <= Z34_FAT5 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL3 and "+Alltrim(Str(nVol))+" <= Z34_VOL4 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 ) or "
cQuery += "               ( "+Alltrim(Str(nVol))+" > Z34_VOL5 and "+Alltrim(Str(nPrc))+" > Z34_FAT4 and "+Alltrim(Str(nPrc))+" <= Z34_FAT5 ) then ((Z34_PERC5-Z34_PERC1)) "
cQuery += "        end "
cQuery += ",0) AS BONUS "
cQuery += "FROM "+RetSqlName("Z34")+" "
cQuery += "WHERE Z34_COORD = '"+cCod+"' AND D_E_L_E_T_ <> '*' "

if Select("Z34X") > 0
	DbSelectArea("Z34X")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "Z34X"

Aadd( aRet, Z34X->BONUS )   //Bonus Concedido
Aadd( aRet, Z34X->VOLUME )  //Volume Acima
Aadd( aRet, Z34X->FATOR )   //Fator Acima
Aadd( aRet, Z34X->PERCINI ) //Percentual Comissao Padrao

DbCloseArea("Z34X")

Return aRet

****************************************************************************************
User Function fDevFat(nRegiao,cUF,nMes,nAno,nRelato,cCod,nProd,nPer,dDtDe,dDtAte,nLinha)
****************************************************************************************
//Retorna Volume KG, Volume R$, Fator, Prz Medio
local aRet := Array(5)
local cQuery1, cQuery2, cQryAux, cQuery, cIni,cFim

if nPer == MENSAL
   cIni := DtoS(CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)))
   cFim := DtoS(LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))))
elseif nPer == ANUAL
   cIni := DtoS(CtoD("01/01/"+Alltrim(Str(nAno))))
   cFim := DtoS(LastDay(Ctod("01/12/"+Alltrim(Str(nAno)))))
else
   cIni := DtoS(dDtDe)
   cFim := DtoS(dDtAte)
endif   
//Primeira parte da query
cQuery1 := "SELECT QUANT=SUM((D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+"), "
cQuery1 += "VALOR=SUM((D2_QTDEDEV)*D2_PRCVEN), DESCONTO=CASE WHEN D2_DESC > 0 THEN SUM(D2_DESCON) ELSE SUM(0) END, "
cQuery1 += "(SUM(((D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+")*E4_PRZMED)/CASE WHEN SUM(((D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+")) = 0 THEN 1 ELSE "
cQuery1 += "SUM(((D2_QTDEDEV)"+if(nProd==SACOS,"*D2_PESO","")+")) END ) AS PRZMED "
cQuery1 += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA3")+" SA3, "
cQuery1 += RetSqlName("SE4")+" SE4 " 
cQuery1 += "WHERE D2_EMISSAO BETWEEN '"+cIni+"' AND '"+cFim+"' AND "
//Segunda parte da query
cQuery2 := "F2_VEND1 = A3_COD AND F2_COND = E4_CODIGO "
if cUF <> nil .and. !Empty(cUF)
   cQuery2 += "AND F2_EST = '"+cUF+"' "
endif
/*
if nRegiao == NORTE
   cQuery2 += "AND F2_EST IN ('AC','AM','AP','PA','RO','RR','TO') "
elseif nRegiao == NORDESTE
   cQuery2 += "AND F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') "
elseif nRegiao == COESTE
   cQuery2 += "AND F2_EST IN ('GO', 'MT', 'MS', 'DF') "
elseif nRegiao == SUDESTE
   cQuery2 += "AND F2_EST IN ('MG', 'ES', 'RJ', 'SP') "
elseif nRegiao == SUL
   cQuery2 += "AND F2_EST IN ('RS', 'PR', 'SC') "
endif
*/
Do Case
	Case nRegiao == 1 //Gildo
		cQuery2 += " AND F2_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') "
	Case nRegiao == 2 //Marcos      
		cQuery2 += " AND F2_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') "
EndCase

if nRelato ==  REPRE
   cQuery2 += "AND RTRIM(A3_COD) LIKE '"+Alltrim(cCod)+"%' "
elseif nRelato == COORD
   cQuery2 += "AND ( RTRIM(A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(F2_VEND1) LIKE '"+Alltrim(cCod)+"%' ) "
endif

cQuery2 += "AND D2_TIPO = 'N' AND D2_TP != 'AP' "
cQuery2 += "AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5118','6118','6119','5949','6949','5922','6922','5116','6116' ) "
cQuery2 += "AND D2_CLIENTE NOT IN ('031732','031733','006543','007005') "
cQuery2 += "AND D2_COD = B1_COD "
cQuery2 += "AND SB1.B1_SETOR "+if(nProd==SACOS,"<>","=")+"'39' AND SB1.B1_TIPO = 'PA' "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery2 += "AND B1_GRUPO IN('D','E') "
   elseif nLinha == INSTIT
      cQuery2 += "AND B1_GRUPO IN('A','B','G') "
   elseif nLinha == HOSPIT
      cQuery2 += "AND B1_GRUPO IN('C') "
   endif   
endif

cQuery2 += "AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND F2_DUPL <> ' ' "
cQuery2 += "AND SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' "
cQuery2 += "AND SE4.D_E_L_E_T_ <> '*' "
cQuery2 += "GROUP BY D2_DESC "
//Monto a query com o Union
cQuery := "SELECT SUM(QUANT) AS QUANT, SUM(VALOR) AS VALOR, "
cQuery += "( SUM(QUANT*PRZMED)/CASE WHEN SUM(QUANT) = 0 THEN 1 ELSE SUM(QUANT) END ) AS PRZMED, "
cQuery += "SUM(DESCONTO) AS DESCONTO FROM "
cQuery += "( "
cQuery += cQuery1
cQuery += "NOT ( D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' ) AND " //"NOT" Nao Considero o valor xDD
cQuery += cQuery2
cQuery += "UNION "
cQuery += cQuery1
cQuery += "( D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' ) AND " //Considero o valor xDD
cQuery += cQuery2
cQuery += ") AS FAT "

TCQUERY cQuery NEW ALIAS '_TMPX'
aRet[1] := _TMPX->QUANT    //Volume Quant/KG
aRet[2] := _TMPX->VALOR    //Volume R$
aRet[3] := aRet[2]/aRet[1] //Fator
aRet[4] := _TMPX->PRZMED   //Prazo Médio
aRet[5] := _TMPX->DESCONTO //Desconto R$

DbCloseArea("_TMPX")

return aRet





****************************************************************************************
User Function fTMeta(MetaKG, RealKG)
****************************************************************************************

Local FMetaKG       := MetaKG
Local FRealKG       := RealKG
Local FDiasUteis    := DateWorkDay(FirstDate(dDataBase), LastDay(dDataBase)) //DiasUteis
Local FDiasCorridos := DateWorkDay(FirstDate(dDataBase), dDataBase) //DiasCorridos
Local FMetaDia      := 0
Local FDifAcum      := 0
Local FIdealAcum    := 0
Local FNovaMeta     := 0
Local FTendencia    := 0
Local FPerc5        := 0.125 // Percentual para os 5 primeiros dias
Local FPercP        := 0.660 // Percentual para os dias entre o sexto e o penultimo
Local FPercU        := 0.215 // Percentual para o ultimo dia
Local Ajuste5, AjusteP, AjusteU    := 0
Local Dias5, DiasP, DiasU          :=0
Local nRet	:= 0


   FMeta5 := (FMetaKG*FPerc5)/5              // Meta diaria para os 5 primeiros dias
   FMetaP := (FMetaKG*FPercP)/(FDiasUteis-6) // Meta diaria entre o sexto e o penultimo dia
   FMetaU := FMetaKG*FPercU                  // Meta para o ultimo dia

   if FDiasCorridos < 5 
      FIdealAcum := FMeta5*FDiasCorridos
   else 
   		if ( FDiasCorridos > 5 ) .and. ( FDiasCorridos < FDiasUteis )
      		FIdealAcum := (FMeta5*5)+(FMetaP*(FDiasCorridos-5))
      	else
      		FIdealAcum := (FMeta5*5)+(FMetaP*(FDiasCorridos-6))+FMetaU
      	EndIf
   EndIf
   
   FDifAcum := FIdealAcum - FRealKG

   if FDifAcum > 0 
      Ajuste5 := FDifAcum * FPerc5
   EndIf
   
   if FDiasCorridos < 5 
      Dias5 := 5 - FDiasCorridos
   EndIf
   
   if FDifAcum > 0 
      AjusteP := FDifAcum * FPercP
   EndIf
   
   if FDiasCorridos < (FDiasUteis - 1)
      DiasP := FDiasUteis - FDiasCorridos - Dias5 - 1
   EndIf
   
   if FDifAcum > 0
      AjusteU := FDifAcum * FPercU
   EndIf
   
   if FDiasCorridos < FDiasUteis 
      DiasU := 1
   EndIf
   
   if FDiasCorridos > 0 

      if FDiasCorridos <= 5 
         FNovaMeta := FMeta5 + ( Ajuste5/Dias5 )
      else 
      		if FDiasCorridos < (FDiasUteis-1)
      			FNovaMeta := FMetaP + Ajuste5 + (AjusteP/DiasP )
      		else
      			FNovaMeta := FMetaU + Ajuste5 + AjusteP + AjusteU
      		EndIf
      EndIf
   else
      FNovaMeta := FMeta5
      
   EndIf

	   if FIdealAcum > 0
	      FTendencia := ( FRealKG / FIdealAcum ) * FMetaKG
	   EndIf

Return 

