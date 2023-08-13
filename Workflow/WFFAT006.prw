 
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch" 
#include "Ap5mail.ch"             
//SITUAÇÃO PEDIDOS SP
//E-mail para os envolvidos informando as etapas em que se encontram os pedidos da filial SP

*************

User Function WFFAT006()
 
*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  //RAVA EMB
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT006 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec() 
 
   
Else
  conOut( "Programa WFFAT006 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT006 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return 

/////////////////////O MESMO PARA RAVA CAIXAS
*************

User Function WFFAT06X()
 
*************

If Select( 'SX2' ) == 0
    
  //RAVA CAIXAS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFFAT06X" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT06X - Caixas - na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
  
Else
  conOut( "Programa WFFAT06X sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT06X em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec()

***************

LOCAL lOK:=.F.
Local cQuery:=' '
Local LF	:= CHR(13) + CHR(10)
Local cRetencao := ""
Local dAgendaCli:= Ctod("  /  /    ")
Local cObserv	:= ""
Local cAgenda	:= ""

cQuery:="SELECT F2_REALCHG,F2_PREVCHG, F2_RETENC, F2_DTAGCLI, A1_COD,A1_NOME CLIENTE, A1_EST UF,C5_NUM PEDIDO ,C5_EMISSAO DIGITACAO,  " +LF
cQuery+="C9_DTBLCRE LIBERACAO,   " +LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS DIAS1,  " +LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')   " +LF
cQuery+="THEN   " +LF
cQuery+="'Aguardando...'   " +LF
cQuery+="ELSE  " +LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')   " +LF
cQuery+="THEN  " +LF
cQuery+=" 'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " +LF
cQuery+="ELSE "  +LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " +LF
cQuery+="THEN   " +LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " +LF
cQuery+="ELSE   " +LF
cQuery+="'NAO' " +LF
cQuery+="END  "     +LF
cQuery+="END "   +LF
cQuery+="END	AS FATURAMENTO, "  +LF
cQuery+="D2_DOC NOTA,F2_OBS OBS,  " +LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END AS DIAS2, " +LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)>CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END PROGRAMADO,  " +LF

//cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2)  ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) END  END AS ENTREGA,  "
cQuery += " CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2)  " +LF
///EM 24/11/2010 - FR - Daniela solicitou que se incluísse na coluna "Entrega" a data de agendamento feita pelo cliente (caso haja)
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
////////
cQuery += " ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2) " +LF
cQuery += " ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery += " END  END END END AS ENTREGA, "  +LF


cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END AS DIAS3, " +LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS TOTALDIAS " +LF
 

cQuery+="FROM SC5020 SC5  " +LF
cQuery+="JOIN SC6020 SC6 " +LF
cQuery+="ON SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_BLQ <> 'R' AND SC6.D_E_L_E_T_ = '' " +LF
cQuery+="JOIN SC9020 SC9  " +LF
cQuery+="ON SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM AND SC9.D_E_L_E_T_ = ''  " +LF
cQuery+="JOIN SB1010 SB1  " +LF
cQuery+="ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_TIPO = 'PA' AND SB1.D_E_L_E_T_ = ''  " +LF
cQuery+="JOIN SA1010 SA1  " +LF
cQuery+="ON SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA AND  " +LF
cQuery+="SA1.A1_EST in ('SP','PR','ES','SC','MG','RJ') AND SA1.D_E_L_E_T_ = ''  " +LF
cQuery+="LEFT JOIN SD2020 SD2  " +LF
cQuery+="ON D2_PEDIDO = C5_NUM AND D2_ITEMPV = C6_ITEM AND D2_SERIE!='' AND SD2.D_E_L_E_T_ = ''  AND SD2.D2_FILIAL ='" +xFilial('SD2')+"' " + LF
cQuery+="AND D2_DOC=C9_NFISCAL " +LF
cQuery+="LEFT JOIN SF2020 SF2 " +LF
cQuery+="ON F2_DOC+F2_SERIE=D2_DOC+D2_SERIE AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL ='" +xFilial('SF2')+"' " + LF

cQuery+="WHERE  (  SC6.C6_QTDVEN - SC6.C6_QTDENT  > 0  OR C9_NFISCAL <> '' AND D2_EMISSAO >= '20100101' ) " +LF
// colocado em 22/02/2011 para otimizar a query 
cQuery+="AND( (F2_REALCHG ='' OR F2_REALCHG IS NULL) OR CAST(CONVERT(datetime,'"+DTOS(ddatabase)+"',112) - CONVERT(datetime,F2_REALCHG,112)AS INT)<8 ) " + LF
//
cQuery+="AND SC6.C6_BLQ <> 'R'     " +LF
cQuery+="AND SB1.B1_TIPO = 'PA'    " +LF
cQuery+="AND SC5.C5_TRANSP!='024'  " +LF
cQuery+="AND SC6.C6_TES != '540'  " +LF
cQuery+="AND SC6.C6_TES != '516'  " +LF

cQuery += " AND F2_REALCHG >= '20101025' " + LF 		//usado para testes - desabilitar

cQuery+="AND SC5.C5_FILIAL='"+xFilial('SC5')+"' " + LF 
cQuery+="AND SC5.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SC6.D_E_L_E_T_ = '' AND SC6.C6_FILIAL ='" +xFilial('SC6')+"' " + LF
cQuery+="AND SC9.D_E_L_E_T_ = '' AND SC9.C9_FILIAL ='" +xFilial('SC9')+"' " + LF
cQuery+="AND SB1.D_E_L_E_T_ = '' " + LF

cQuery+="GROUP BY F2_REALCHG,F2_PREVCHG, F2_RETENC, F2_DTAGCLI, A1_COD,A1_NOME,A1_EST ,C5_NUM ,C5_EMISSAO, " +LF
cQuery+="C9_DTBLCRE , " +LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END , " +LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')  " +LF
cQuery+="THEN  " +LF
cQuery+="'Aguardando...'  " +LF
cQuery+="ELSE  " +LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')  " +LF
cQuery+="THEN  " +LF
cQuery+="'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " +LF
cQuery+="ELSE  " +LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " +LF
cQuery+="THEN  " +LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " +LF
cQuery+="ELSE   " +LF
cQuery+="'NAO'  " +LF
cQuery+="END  "     +LF
cQuery+="END  "  +LF
cQuery+="END, "  +LF
cQuery+="D2_DOC ,F2_OBS , " +LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END , " +LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)>CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END , " +LF

//cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2)  ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) END  END , "
cQuery+= " CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2)  " + LF
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
cQuery+= " ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2)  " + LF
cQuery+= " ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery+= " END  END END END, "  +LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END , " +LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END  " +LF

cQuery+="ORDER BY C5_NUM " +LF
Memowrite("C:\Temp\WFfat006.sql",cQuery)
TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( 'AUUX', "DIGITACAO", "D")
TCSetField( 'AUUX', "LIBERACAO", "D")
TCSetField( 'AUUX', "PROGRAMADO", "D")
TCSetField( 'AUUX', "F2_DTAGCLI", "D")

AUUX->(DbGoTop())


if !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT006","WFFAT006")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT006.html")
	//oProcess:NewTask('Inicio',"\workflow\http\teste\WFFAT006.html")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF()) 
		cRetencao := ""
		dAgendaCli:= Ctod("  /  /    ")
		cObserv	:= ""
	    cAgenda	:= ""                
	   Iif(EMPTY(AUUX->F2_REALCHG),lOK:=.T.,iif(ddatabase-StoD(AUUX->F2_REALCHG)<8,lOK:=.T.,lOK:=.F.))  
	   
	    If lOK 
	    
	    	
	    	       
	    //essa variável indica que só irá enviar as informações de pedidos em que a NF ainda tem o cpo F2_REALCHG = branco ou Database - Dt. F2_REALCHG < 8 dias
	       aadd( oHtml:ValByName("it.cCli") , AUUX->CLIENTE)
	       aadd( oHtml:ValByName("it.cUf") , AUUX->UF)

           aadd( oHtml:ValByName("it.cPedido") , AUUX->PEDIDO)

           aadd( oHtml:ValByName("it.dEmiss") , DTOC(AUUX->DIGITACAO))

	       aadd( oHtml:ValByName("it.dLibCred") , DTOC(AUUX->LIBERACAO))
	
	       aadd( oHtml:ValByName("it.cDias1") , STR(AUUX->DIAS1))
	
	       aadd( oHtml:ValByName("it.dFat") , AUUX->FATURAMENTO)
	
	       aadd( oHtml:ValByName("it.cNF") , IIF(!EMPTY(AUUX->NOTA),AUUX->NOTA,"&nbsp;"))
	
	      // aadd( oHtml:ValByName("it.cObs") , IIF(!EMPTY(AUUX->OBS),AUUX->OBS,"---" ))
	
	       aadd( oHtml:ValByName("it.cDias2") , STR(AUUX->DIAS2))
	
	       aadd( oHtml:ValByName("it.cProgram") , IIF(!EMPTY(AUUX->PROGRAMADO),DTOC(AUUX->PROGRAMADO),"Imediato") )
	
	       aadd( oHtml:ValByName("it.dEntreg") , IIF(!EMPTY(AUUX->ENTREGA),AUUX->ENTREGA,"&nbsp;"))
	       //aadd( oHtml:ValByName("it.dEntreg") , IIF(!EMPTY(AUUX->ENTREGA),AUUX->ENTREGA,cAgenda ))
	
	       aadd( oHtml:ValByName("it.cDias3") , STR(AUUX->DIAS3))
	       
	       aadd( oHtml:ValByName("it.cDiastot") , STR(AUUX->TOTALDIAS))
	       
	       IF !EMPTY(AUUX->NOTA)
				cDepto 		:= ""
				cOcorren 	:= ""
				cRetencao := AUUX->F2_RETENC 	//INDICA RETENÇÃO SIM OU NÃO
				
				
				If Alltrim(cRetencao) = 'S'
					cObserv	:= "Retenção Fiscal"
					//msgbox("retenção fiscal")
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
				
				aadd( oHtml:ValByName("it.cOcorr") ,  IIF(!EMPTY(cOcorren) , cOcorren, "&nbsp;"))
				aadd( oHtml:ValByName("it.cDepto") ,  IIF(!EMPTY(cDepto)   , cDepto  , "&nbsp;"))
				aadd( oHtml:ValByName("it.cRet_Agd") , cObserv )
				
				
				
	       ELSE
	       		aadd( oHtml:ValByName("it.cOcorr") ,  "&nbsp;")
				aadd( oHtml:ValByName("it.cDepto") ,  "&nbsp;")
				aadd( oHtml:ValByName("it.cRet_Agd") ,IIF(!EMPTY(cObserv)   , cObserv  , "&nbsp;")  )
			      
	       ENDIF
	       
       endif
	AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 
	 
	 oProcess:cTo := ""
	 //Chamado: 001840 - Em 14/10 alterei pq João Emanuel solicitou receber também este email. 
	  oProcess:cTo := "vendas.sp@ravaembalagens.com.br"
	  oProcess:cTo += ";pedidosp@ravaembalagens.com.br"
	  oProcess:cTo += ";joao.emanuel@ravaembalagens.com.br"
	 //Flavia Rocha - 08/09/11 - Daniela solicitou retirar o email de Andreia Sabino do recebimento deste email.
	  oProcess:cCC := "" //"flavia.rocha@ravaembalagens.com.br"	 
	  	 
	 //oProcess:cBCC	  := ""
	 subj	:= "Situação dos pedidos São Paulo ,Paraná,Espirito Santo,Santa Catarina,Minas Gerais e Rio de Janeiro."
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
	 //msginfo("Processo Finalizado")
endif
AUUX->(DbCloseArea())
Return     




