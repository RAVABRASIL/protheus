#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

****************************
User Function WFCOM001()
****************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFCOM001" Tables "SC7"   //SACOS
  sleep( 5000 )
  conOut( "Programa WFCOM001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFCOM001" Tables "SC7"   //CAIXAS
  sleep( 5000 )
  conOut( "Programa WFCOM001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec() 
  
Else
  conOut( "Programa WFCOM001 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  //conOut( "Finalizando programa WFCOM001 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return
                      

**********************
Static Function Exec()
**********************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10)       
Local cCodZ78 := ""
Local cNomefo := ""
Local cTefefo := ""

cQuery := "SELECT C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, C7_CONTATO, C7_ITEM, C7_PRODUTO, " + LF
cQuery += " B1_DESC, B1_TIPO, C7_QUANT, C7_DATPRF, C7_EMISSAO, C7_NUMSC, B1_EMIN, " + LF
cQuery += " CASE " + LF
cQuery += "	WHEN C7_DATPRF = (SELECT CONVERT(varchar(10), getdate(),112)) THEN '1' " + LF
cQuery += "	WHEN C7_DATPRF = (SELECT CONVERT(varchar(10), getdate(),112)-1) THEN '2' " + LF
cQuery += "	WHEN C7_DATPRF = (SELECT CONVERT(varchar(10), getdate(),112)-2) THEN '2' " + LF
cQuery += "	WHEN C7_DATPRF = (SELECT CONVERT(varchar(10), getdate(),112)-3) THEN '2' " + LF 
cQuery += "	ELSE '3' " + LF
cQuery += " END AS 'LISTA' " + LF
cQuery += " FROM " + LF
cQuery += " SC7020 C7, " + LF  
cQuery += " SB1010 B1  " + LF
cQuery += " WHERE B1_COD = C7_PRODUTO " + LF
cQuery += " AND B1.D_E_L_E_T_ = '' " + LF
cQuery += " AND C7.D_E_L_E_T_ = '' " + LF
cQuery += " AND C7_FILIAL = '"+xFilial("SC7")+"' "
//cQuery += " AND C7_EMISSAO > '20140201' AND (B1_TIPO IN ('MP','AC','MS','ME') OR B1_ESTSEG <> 0) " + LF 
cQuery += " AND B1_TIPO  IN ('AC','AE','CI','CL','CP','EP','EM','FD','FI','GG','MA','MC','ME','MH','MK','MI','ML','MP','MQ','MR','MS','MV','PR','PV','SG','ST','TR','VC','VE') "
cQuery += " AND C7_NUM >= '039000' "    // marco zero 
// NAO CONSIDERA O QUE VEIO DE ponto de pedido 
cQuery += " and C7_NUMSC NOT IN (select C1_NUM from SC1020 SC1 "
cQuery += "                     WHERE C1_OBS LIKE '%SC.Pto Pedido:%' AND SC1.C1_NUM=C7.C7_NUMSC "
cQuery += "                     AND C1_ORIGEM LIKE '%WFGERASC%' "
cQuery += "                     AND SC1.D_E_L_E_T_='' "
cQuery += "                     ) "

cQuery += "	AND C7_CONAPRO = 'L' AND C7_RESIDUO <> 'S' AND C7_ENCER <> 'E' " + LF
cQuery += " and C7_NUM not in (SELECT Z78_PEDIDO FROM Z78020 Z78 WHERE Z78.D_E_L_E_T_='') " 
cQuery += " GROUP BY C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, C7_ITEM, C7_PRODUTO, " + LF
cQuery += " B1_DESC, B1_TIPO, C7_QUANT, C7_DATPRF, C7_EMISSAO, C7_NUMSC, B1_EMIN, C7_CONTATO " + LF
cQuery += " ORDER BY C7_FILIAL, C7_NUM" + LF           

//MemoWrite("C:\TEMP\WFCOM001.SQL" , cQuery )

If Select("TEMP1") > 0
	DbSelectArea("TEMP1")
	DbCloseArea()	
EndIf
                  
TCQUERY cQuery NEW ALIAS "TEMP1" 
TCSetField( "TEMP1" , "C7_DATPRF",  "D")
TCSetField( "TEMP1" , "C7_EMISSAO", "D")

TEMP1->(DbGoTop())

If !TEMP1->(Eof())  
	While !TEMP1->(EOF())
 	   cPedido:= TEMP1->C7_NUM
 	                                                              
 	   	cCodZ78  := GetSx8Num( "Z78", "Z78_CODIGO" )  // GetSxENum("Z78","Z78_CODIGO")   //captura o próximo código da Z78
 	   	
		///while Z78->( DbSeek( xFilial( "Z78" ) + cCodZ78 ) )  //faz um loop pra procurar se este código já existe
		// ConfirmSX8()                 //cada vez q encontrar, dá commit 
		// cCodZ78 := GetSxeNum("Z78","Z78_CODIGO")  //e pega o próximo
		//enddo      //só sai daqui qdo o código não existir na base, ou seja, é um código prontinho pra usar, novo
		 
 	   While !TEMP1->(EOF()) .AND. TEMP1->C7_NUM == cPedido
		
		DbSelectArea("Z78")
	 	DbSetOrder(2)
		 
		
		IF !Z78->(DBSEEK(XFILIAL("Z78") + TEMP1->C7_NUM + TEMP1->C7_FORNECE + TEMP1->C7_LOJA + TEMP1->C7_PRODUTO))  //SE NÃO ACHAR, GRAVA
            
			cNomefo := Posicione( "SA2", 1, xFilial("SA2") + TEMP1->C7_FORNECE, "A2_NOME" )
			cTelefo := Posicione( "SA2", 1, xFilial("SA2") + TEMP1->C7_FORNECE, "A2_TEL" )
			
			RECLOCK("Z78" , .T. )
				Z78->Z78_FILIAL  := TEMP1->C7_FILIAL
				Z78->Z78_CODIGO  := cCodZ78
				Z78->Z78_PEDIDO  := TEMP1->C7_NUM
				Z78->Z78_FORNEC  := TEMP1->C7_FORNECE
				Z78->Z78_LOJA    := TEMP1->C7_LOJA
				Z78->Z78_CONTAT  := TEMP1->C7_CONTATO
				Z78->Z78_NUMSC   := TEMP1->C7_NUMSC
			   	Z78->Z78_STATUS  := '1'
				Z78->Z78_ITEM    := TEMP1->C7_ITEM
				Z78->Z78_PRODUTO := TEMP1->C7_PRODUTO
			  	Z78->Z78_LISTA   := TEMP1->LISTA
				Z78->Z78_QUANTI  := TEMP1->C7_QUANT
				Z78->Z78_EMISSA  := TEMP1->C7_EMISSAO
				Z78->Z78_DTENTR  := TEMP1->C7_DATPRF
				Z78->Z78_NOMEFO  := cNomefo
				Z78->Z78_TELEFO  := cTelefo
			Z78->(MSUNLOCK())
			
			CONFIRMSX8()
			
		ENDIF            
		
		DBSELECTAREA("TEMP1")
		TEMP1->(DBSKIP())
		
	  ENDDO

    ENDDO
	
Endif 

If Select( 'SX2' ) == 0
   Reset Environment
else
alert("Follow up Atualizado.")
endif


TEMP1->(dbclosearea())

Return
