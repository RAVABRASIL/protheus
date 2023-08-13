#Include "Topconn.ch"
#Include "Rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include "Tbiconn.ch " 

/*
//CHAMADO - 002277 - EDNA/RUBEN
USADO NO CÁLCULO DA DEPRECIAÇÃO
PARA CORRIGIR ALGUNS ITENS QUE FICAREM COM O CT2_VALOR EM DESACORDO COM A REGRA
*/

************************
User Function CTBGRV()
************************

//nOpcLct := aParamixb[1]
//nProgra := aParamixb[2]

Private ddata1 := CT2->CT2_DATA
Private LF     := CHR(13) + CHR(10)
//MSGBOX("DATA DO LANÇTO: " + dtoc(ddata1) )
//If nOpcLct == 3 //inclusao
If ALLTRIM( FUNNAME() ) == "ATFA050"
  
   //CT2->CT2_USUHOR := TIME() // campo de usuario para gravar horario do lancamento
   
   If ALLTRIM(CT2->CT2_ORIGEM) = '820.01'
    	//msginfo("CTBGRV - entrou na função")
		fFuncD()
   Endif

EndIf


Return

***************************
Static Function fFuncD()  
***************************


Local nAcertos	:= 0 
Local nAcertoSN3:= 0
Local aAcertos  := {}
Local dUltDEPR 	:= GetMV("MV_ULTDEPR")
Local nValdepre	:= 0

///CAPTURA OS LANÇTOS CONTÁBEIS DE DEPRECIAÇÃO QUE ESTÃO COM VALOR INCORRETO
///A COMPARAÇÃO É FEITA DIRETAMENTE PELA REGRA DE CÁLCULO
///CORRIGE CT2
cQuery := " Select " + LF
cQuery += " N3_CBASE, N3_ITEM, CT2_HIST,N3_VRDMES1 " + LF
//cQuery += " ,VALORDEPR = ROUND((N3_VORIG1 / N3_TXDEPR1) / 12, 2 ) , CT2_VALOR, N3_TXDEPR1 " + LF
/*
cQuery += " ,VDEPREC = (CASE WHEN LEFT(N3_CBASE,3) IN ('FER','MEQ','MUT' ) THEN  " + LF
cQuery += " round((N3_VORIG1 / 10 / 12 ) ,2) " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('INF','VEI') THEN " + LF
cQuery += " round( (N3_VORIG1 / 5 / 12 ) ,2) " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('PRE') " + LF
cQuery += " THEN round( (N3_VORIG1 / 25 / 12 ),2) END END END ) " + LF
 */ //incorreto
 
//correto
cQuery += " ,VDEPREC = (CASE WHEN LEFT(N3_CBASE,3) IN ('FER','MEQ','MUT' ) THEN   " + LF
cQuery += " round( ( ((N3_VORIG1 * 10) / 100 ) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('INF','VEI') THEN  " + LF
cQuery += " round( ( ((N3_VORIG1 * 5) / 100) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('PRE')  " + LF
cQuery += " THEN round( ( (( N3_VORIG1 * 25) / 100) / 12 ),2) END END END )  " + LF

cQuery += " ,CT2.R_E_C_N_O_ " + LF
cQuery += " ,CT2_HIST " + LF
cQuery += " ,CHAVECT2 = (CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC )  " + LF                                                   

cQuery += " FROM " + LF
cQuery += " " + RetSqlName("CT2") + " CT2, " + LF
cQuery += " " + RetSqlName("SN3") + " SN3  " + LF

cQuery += " WHERE  " + LF

//cQuery += " ( N3_CBASE + '/ ' + N3_ITEM ) in ( LTRIM(RTRIM(CT2_HIST)) ) " + LF
//cQuery += " LEFT(CT2_HIST,14) = (N3_CBASE + N3_ITEM) " + LF
cQuery += " LEFT(CT2_HIST,14) = (N3_CBASE + N3_ITEM ) " + LF 
cQuery += "  AND CT2_ORIGEM = '820.01' " + LF

//cQuery += " and N3_CDEPREC = CT2_DEBITO                        " + LF
cQuery += " AND SN3.D_E_L_E_T_ = '' " + LF
cQuery += " AND CT2.D_E_L_E_T_ = '' " + LF
cQuery += " AND CT2_FILIAL = N3_FILIAL " + LF
cQuery += " AND CT2_FILIAL = '" + xFilial("CT2") + "' " + LF
//cQuery += " AND CT2_DATA = '" + DTOS(dUltDEPR) + "' " + LF
cQuery += " AND CT2_DATA = '" + DTOS(ddata1) + "' " + LF

/*
cQuery += " AND CT2_VALOR <> (CASE WHEN LEFT(N3_CBASE,3) IN ('FER','MEQ','MUT' ) THEN   " + LF
cQuery += " round( ( ((N3_VORIG1 * 10) / 100 ) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('INF','VEI') THEN  " + LF
cQuery += " round( ( ((N3_VORIG1 * 5) / 100) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('PRE')  " + LF
cQuery += " THEN round( ( (( N3_VORIG1 * 25) / 100) / 12 ),2) END END END )  " + LF
*/
cQuery += " ORDER BY N3_CBASE, N3_ITEM " + LF 


MemoWrite("C:\Temp\ATFC001_.sql",cQuery)  

If Select("ATFX") > 0
	DbSelectArea("ATFX")
	DbCloseArea()
EndIf
		
TCQUERY cQuery NEW ALIAS "ATFX"
                                        

ATFX->(DbGoTop())
nValdepre := 0
///ACERTA CT2_VALOR
If !ATFX->(EOF())
	While !ATFX->(EOF()) 
	 	CT2->(DBSETORDER(1))      //CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC                                                     
	 	If CT2->(Dbseek( ATFX->CHAVECT2 ) )
	 		Do Case
		 		Case SUBSTR(CT2->CT2_HIST,1,3) $ "FER/MEQ/MUT"
		 			nValdepre := Round( ( (SN3->N3_VORIG1 * 10) / 100 ) / 12 ,2)
		 		Case SUBSTR(CT2->CT2_HIST,1,3) $ "INF/VEI"
		 			nValdepre := Round( ( (SN3->N3_VORIG1 * 5) / 100 ) / 12 ,2)
		 		Case SUBSTR(CT2->CT2_HIST,1,3) $ "PRE"
		 			nValdepre := Round( ( (SN3->N3_VORIG1 * 25) / 100 ) / 12 ,2)		 	
		 	Endcase
		 	
		 	If CT2->CT2_VALOR != nValdepre
		 		RECLOCK("CT2", .F.)
		 		CT2->CT2_VALOR := ATFX->VDEPREC 
		 		nAcertos++
		 		CT2->(MsUnlock())
		 	Endif
	 	
	 	//Else
	 		//MSGBOX("REGISTRO NÃO ENCONTRADO! " + ATFX->CT2_HIST )
	 	Endif
	    DbSelectArea("ATFX")	
		ATFX->(DBSKIP())
	Enddo
	
Endif

DbSelectArea("ATFX")
DbcloseArea()

//Aadd(aAcertos, nAcertos ) 

///AJUSTA SN3
///CAPTURA OS LANÇTOS CONTÁBEIS DE DEPRECIAÇÃO QUE ESTÃO COM VALOR INCORRETO
///A COMPARAÇÃO É FEITA DIRETAMENTE PELA REGRA DE CÁLCULO

cQuery := " Select " + LF
cQuery += " N3_CBASE, N3_ITEM, CT2_HIST,N3_VRDMES1 " + LF
//cQuery += " ,VALORDEPR = ROUND((N3_VORIG1 / N3_TXDEPR1) / 12, 2 ) , CT2_VALOR, N3_TXDEPR1 " + LF
/*
cQuery += " ,VDEPREC = (CASE WHEN LEFT(N3_CBASE,3) IN ('FER','MEQ','MUT' ) THEN  " + LF
cQuery += " round((N3_VORIG1 / 10 / 12 ) ,2) " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('INF','VEI') THEN " + LF
cQuery += " round( (N3_VORIG1 / 5 / 12 ) ,2) " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('PRE') " + LF
cQuery += " THEN round( (N3_VORIG1 / 25 / 12 ),2) END END END ) " + LF
*/ //incorreto

//correto
cQuery += " ,VDEPREC = (CASE WHEN LEFT(N3_CBASE,3) IN ('FER','MEQ','MUT' ) THEN   " + LF
cQuery += " round( ( ((N3_VORIG1 * 10) / 100 ) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('INF','VEI') THEN  " + LF
cQuery += " round( ( ((N3_VORIG1 * 5) / 100) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('PRE')  " + LF
cQuery += " THEN round( ( (( N3_VORIG1 * 25) / 100) / 12 ),2) END END END )  " + LF

cQuery += " ,N3_VRDACM1 VALACUM " + LF
cQuery += " ,N3_VORIG1 VALORIG " + LF
cQuery += " ,(N3_VORIG1 - N3_VRDACM1) AS SALDO " + LF
cQuery += " ,CT2.R_E_C_N_O_ " + LF
cQuery += " ,CT2_HIST " + LF
cQuery += " ,CHAVECT2 = (CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC )  " + LF                                                   
cQuery += " ,CHAVESN3 = (N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ ) " + LF
                                                                                                                                                                
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("CT2") + " CT2, " + LF
cQuery += " " + RetSqlName("SN3") + " SN3  " + LF

cQuery += " WHERE  " + LF

//cQuery += " ( N3_CBASE + '/ ' + N3_ITEM ) in ( LTRIM(RTRIM(CT2_HIST)) ) " + LF

cQuery += " LEFT(CT2_HIST,14) = (N3_CBASE + N3_ITEM ) " + LF
cQuery += "  AND CT2_ORIGEM = '820.01' " + LF
 
cQuery += " AND SN3.D_E_L_E_T_ = '' " + LF
cQuery += " AND CT2.D_E_L_E_T_ = '' " + LF
cQuery += " AND CT2_FILIAL = N3_FILIAL " + LF
cQuery += " AND CT2_FILIAL = '" + xFilial("CT2") + "' " + LF
//cQuery += " AND CT2_DATA = '" + DTOS(dUltDEPR) + "' " + LF
cQuery += " AND CT2_DATA = '" + DTOS(ddata1) + "' " + LF

/*
cQuery += " AND N3_VRDMES1 <> (CASE WHEN LEFT(N3_CBASE,3) IN ('FER','MEQ','MUT' ) THEN   " + LF
cQuery += " round( ( ((N3_VORIG1 * 10) / 100 ) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('INF','VEI') THEN  " + LF
cQuery += " round( ( ((N3_VORIG1 * 5) / 100) / 12 ) ,2)  " + LF
cQuery += " ELSE CASE WHEN LEFT(N3_CBASE,3) IN ('PRE')  " + LF
cQuery += " THEN round( ( (( N3_VORIG1 * 25) / 100) / 12 ),2) END END END )  " + LF
*/

cQuery += " ORDER BY N3_CBASE, N3_ITEM " + LF 

MemoWrite("C:\Temp\ATFC001_sn3.sql",cQuery)  

If Select("ATFX") > 0
	DbSelectArea("ATFX")
	DbCloseArea()
EndIf
		
TCQUERY cQuery NEW ALIAS "ATFX"
                                        
nValdepre := 0
ATFX->(DbGoTop())

//ACERTA SN3->N3_VRDMES1
If !ATFX->(EOF())
	While !ATFX->(EOF()) 
			 	
	 	SN3->(DBSETORDER(1))      //N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ                                                                                                              
	 	If SN3->(Dbseek( ATFX->CHAVESN3 ) )
	 		Do Case
		 		Case SUBSTR(SN3->N3_CBASE,1,3) $ "FER/MEQ/MUT"
		 			nValdepre := Round( ( (SN3->N3_VORIG1 * 10) / 100 ) / 12 ,2)
		 		Case SUBSTR(SN3->N3_CBASE,1,3) $ "INF/VEI"
		 			nValdepre := Round( ( (SN3->N3_VORIG1 * 5) / 100 ) / 12 ,2)
		 		Case SUBSTR(SN3->N3_CBASE,1,3) $ "PRE"
		 			nValdepre := Round( ( (SN3->N3_VORIG1 * 25) / 100 ) / 12 ,2)		 	
		 	Endcase
		 	
		 	If SN3->N3_VRDMES1 != nValdepre
		 		RECLOCK("SN3", .F.)
		 		SN3->N3_VRDMES1 := ATFX->VDEPREC 
	 			nAcertoSN3++	 			
	 			SN3->(MsUnlock())
	 		Endif
	 		
	 		If (SN3->N3_VORIG1 - SN3->N3_VRDACM1) = 0    //QUANDO ATINGIR A DEPRECIAÇÃO COMPLETA DO BEM, BAIXA O MESMO
	 			RECLOCK("SN3", .F.)
		 		SN3->N3_BAIXA := '1'	 				
	 			SN3->(MsUnlock())
	 		Endif
	 	
	 	//Else
	 		//MSGBOX("REGISTRO NÃO ENCONTRADO! " + ATFX->CT2_HIST )
	 	Endif
	    DbSelectArea("ATFX")	
		ATFX->(DBSKIP())
	Enddo
	
Endif

DbSelectArea("ATFX")
DbcloseArea()

//alert("acerto CT2: " + str(nAcertos) )
//alert("acerto SN3: " + str(nAcertoSN3) )

//Return(aAcertos) 
Return
