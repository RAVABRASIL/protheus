#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "
                   

*************

User Function WFFAT008()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT008" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT008 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT008 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT008 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec()

***************

LOCAL lOK:=.F.
Local cQuery:=' '
Local LF	:= CHR(13) + CHR(10)
Local cObserv	:= ""

cQuery:="SELECT F2_REALCHG, F2_PREVCHG, F2_RETENC, F2_DTAGCLI, A1_COD, A1_NOME CLIENTE,C5_NUM PEDIDO ,C5_EMISSAO DIGITACAO,  " + LF
cQuery+="C9_DTBLCRE LIBERACAO,A1_MUN MUNI,A1_EST UF,C5_TRANSP,   " + LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS DIAS1,  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')   " + LF
cQuery+="THEN   " + LF
cQuery+="'Aguardando...'   " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')   " + LF
cQuery+="THEN  " + LF
cQuery+=" 'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " + LF
cQuery+="ELSE "  + LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " + LF
cQuery+="THEN   " + LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " + LF
cQuery+="ELSE   " + LF
cQuery+="'NAO' " + LF
cQuery+="END  "     + LF
cQuery+="END "   + LF
cQuery+="END	AS FATURAMENTO, "  + LF
cQuery+="D2_DOC NOTA,F2_OBS OBS,  " + LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END AS DIAS2, " + LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)> CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END PROGRAMADO,  " + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2)  " + LF
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
cQuery+="ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2)  " + LF
cQuery+="ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery+="END  END END END AS ENTREGA, "  + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END AS DIAS3, " + LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS TOTALDIAS " + LF

cQuery+="FROM SC5020 SC5  " + LF
cQuery+="JOIN SC6020 SC6 " + LF
cQuery+="ON SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_BLQ <> 'R' AND SC6.D_E_L_E_T_ = '' " + LF
cQuery+="JOIN SC9020 SC9  " + LF
cQuery+="ON SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM AND SC9.D_E_L_E_T_ = ''  " + LF
cQuery+="JOIN SB1010 SB1  " + LF
cQuery+="ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_TIPO = 'PA' AND SB1.D_E_L_E_T_ = ''  " + LF
cQuery+="JOIN SA1010 SA1  " + LF
cQuery+="ON SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA AND  " + LF
cQuery+="SA1.A1_SATIV1 IN('000002','000003') AND SA1.D_E_L_E_T_ = ''  " + LF
cQuery+="LEFT JOIN SD2020 SD2  " + LF
cQuery+="ON D2_PEDIDO = C5_NUM AND D2_ITEMPV = C6_ITEM AND D2_SERIE!='' AND SD2.D_E_L_E_T_ = ''  " + LF
cQuery+="AND D2_DOC=C9_NFISCAL  " + LF
cQuery+="LEFT JOIN SF2020 SF2 " + LF
cQuery+="ON F2_DOC+F2_SERIE=D2_DOC+D2_SERIE AND SF2.D_E_L_E_T_ = '' " + LF
                             	
cQuery+="WHERE  (  SC6.C6_QTDVEN - SC6.C6_QTDENT  > 0  OR C9_NFISCAL <> ''  AND D2_EMISSAO >= '20100101' ) " + LF
// colocado em 22/02/2011 para otimizar a query 
cQuery+="AND( (F2_REALCHG ='' OR F2_REALCHG IS NULL) OR CAST(CONVERT(datetime,'"+DTOS(ddatabase)+"',112) - CONVERT(datetime,F2_REALCHG,112)AS INT)<8 ) " + LF
//
cQuery+="AND SC6.C6_BLQ <> 'R'     " + LF
cQuery+="AND SB1.B1_TIPO = 'PA'    " + LF
cQuery+="AND SC5.C5_TIPO='N'  " + LF
cQuery+="AND SC5.C5_TRANSP!='024'  " + LF
cQuery+="AND SC6.C6_TES != '540'  " + LF

cQuery+="AND SC5.C5_FILIAL='"+xFilial('SC5')+"' " + LF 
cQuery+="AND SC5.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SC6.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SC9.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SB1.D_E_L_E_T_ = '' "  + LF

cQuery+="GROUP BY A1_MUN ,A1_EST ,F2_REALCHG,F2_PREVCHG, F2_RETENC, F2_DTAGCLI,A1_COD,A1_NOME ,C5_NUM ,C5_EMISSAO, " + LF
cQuery+="C9_DTBLCRE ,C5_TRANSP, " + LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END , " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')  " + LF
cQuery+="THEN  " + LF
cQuery+="'Aguardando...'  " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')  " + LF
cQuery+="THEN  " + LF
cQuery+="'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " + LF
cQuery+="THEN  " + LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " + LF
cQuery+="ELSE   " + LF
cQuery+="'NAO'  " + LF
cQuery+="END  "     + LF
cQuery+="END  "  + LF
cQuery+="END, "  + LF
cQuery+="D2_DOC ,F2_OBS , " + LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END , " + LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)>CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END , " + LF


cQuery+="  CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2) " + LF
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
cQuery+="  ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2)" + LF
cQuery+= " ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery+= " END  END END END , "  + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END , " + LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END  " + LF

cQuery+="ORDER BY C5_NUM " + LF
//Memowrite("C:\Temp\WFfat008.sql",cQuery)

TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( 'AUUX', "DIGITACAO", "D")
TCSetField( 'AUUX', "LIBERACAO", "D")
TCSetField( 'AUUX', "PROGRAMADO", "D")
TCSetField( 'AUUX', "F2_DTAGCLI", "D")

AUUX->(DbGoTop())


if !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT008","WFFAT008")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT008.html")
	//oProcess:NewTask('Inicio',"\workflow\http\teste\WFFAT008.html")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF())                    
	   Iif(EMPTY(AUUX->F2_REALCHG),lOK:=.T.,iif(ddatabase-StoD(AUUX->F2_REALCHG)<8,lOK:=.T.,lOK:=.F.))  
	    If lOK
	       aadd( oHtml:ValByName("it.cCli") , AUUX->CLIENTE)

           aadd( oHtml:ValByName("it.cMuni") , AUUX->MUNI)
           
           aadd( oHtml:ValByName("it.cUF") , AUUX->UF)
           
           aadd( oHtml:ValByName("it.cPedido") , AUUX->PEDIDO)

           aadd( oHtml:ValByName("it.cTrans") , posicione("SA4",1,xFilial('SA4') + AUUX->C5_TRANSP,"A4_NOME" ))
           
           //aadd( oHtml:ValByName("it.dEmiss") , DTOC(AUUX->DIGITACAO))

	       //aadd( oHtml:ValByName("it.dLibCred") , DTOC(AUUX->LIBERACAO))
	
	       //aadd( oHtml:ValByName("it.cDias1") , STR(AUUX->DIAS1))
	
	       aadd( oHtml:ValByName("it.dFat") , AUUX->FATURAMENTO)
	
	       aadd( oHtml:ValByName("it.cNF") , IIF(!EMPTY(AUUX->NOTA),AUUX->NOTA,"---"))
	
	      // aadd( oHtml:ValByName("it.cObs") , IIF(!EMPTY(AUUX->OBS),AUUX->OBS,"---" ))
	
	      // aadd( oHtml:ValByName("it.cDias2") , STR(AUUX->DIAS2))
	
	       //aadd( oHtml:ValByName("it.cProgram") , IIF(!EMPTY(AUUX->PROGRAMADO),DTOC(AUUX->PROGRAMADO),"Imediato") )
	
	       aadd( oHtml:ValByName("it.dEntreg") , IIF(!EMPTY(AUUX->ENTREGA),AUUX->ENTREGA,"---"))
	
	       aadd( oHtml:ValByName("it.cDias3") , STR(AUUX->DIAS3))
	       
	       aadd( oHtml:ValByName("it.cDiastot") , STR(AUUX->TOTALDIAS))
	       
	       IF !EMPTY(AUUX->NOTA)
				cDepto 		:= ""
				cOcorren 	:= ""
								
				If Alltrim(AUUX->F2_RETENC) = 'S'
					cObserv	:= "Retenção Fiscal"
				
				Else
					cObserv := ""
				Endif
				
								
				cQuery := "	SELECT UC_CODIGO,UD_ITEM,UC_STATUS,UC_PENDENT,UC_NFISCAL,UC_REALCHG,UD_N2,UD_OPERADO,UD_STATUS,UD_RESOLVI " + LF
			 	cQuery += " FROM " + RetSqlName("SUC") + " SUC, " + LF
			 	cQuery += " " + RetSqlName("SUD") + " SUD " + LF
			 
				cQuery += " WHERE RTRIM(UC_NFISCAL) = '" + Alltrim(AUUX->NOTA) + "' "  + LF
				cQuery += " AND UC_CODIGO = UD_CODIGO"  + LF
				cQuery += "	AND SUC.D_E_L_E_T_ = '' "  + LF
				cQuery += "	AND SUD.D_E_L_E_T_ = '' "  + LF
				cQuery += "	AND UC_OBSPRB <> 'S'"  + LF
				cQuery += "	AND UD_OPERADO <> ''"  + LF
				cQuery += "	AND UD_STATUS <> '2'"  + LF
				If Select("OCO") > 0
					DbSelectArea("OCO")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "OCO"			
				OCO->( DbGoTop() )			
				If !OCO->(EOF())
					While OCO->( !EOF() )
						cOcorren += OCO->UC_CODIGO + "-" + OCO->UD_ITEM + " / "
						cDepto   += SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+ OCO->UD_N2,"Z46_DESCRI"),1,15) + " / "
						//msgbox("Ocorrencia: " + cOcorren + " - Depto: " + cDepto )
						OCO->(Dbskip())					
					Enddo
					
				Endif
				
				aadd( oHtml:ValByName("it.cOcorr") ,  IIF(!EMPTY(cOcorren) , cOcorren, "---"))
				aadd( oHtml:ValByName("it.cDepto") ,  IIF(!EMPTY(cDepto)   , cDepto  , "---"))
				aadd( oHtml:ValByName("it.cRet_Agd") , IIF(!EMPTY(cObserv) , cObserv, "---") )
				
				
				
	   		ELSE
	       		aadd( oHtml:ValByName("it.cOcorr") ,  "")
				aadd( oHtml:ValByName("it.cDepto") ,  "")
				aadd( oHtml:ValByName("it.cRet_Agd") , cObserv )
	        ENDIF
	       
       endif
		AUUX->( DBSKIP() )
	
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 //oProcess:cTo := "marcos@ravaembalagens.com.br;antonio.fulgencio@ravaembalagens.com.br" 
	 oProcess:cTo := "antonio.fulgencio@ravaembalagens.com.br" 	          //EM 16/07/2010 Marcos solicitou que retirasse o e-mail dele
	 //oProcess:cTo := "flavia.rocha@ravaembalagens.com.br"
	 subj	:= "Situação de Faturamento ate Entrega"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail() 
endif
AUUX->(DbCloseArea())

Return