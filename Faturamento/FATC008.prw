***************

User Function FATC008(cLocaliz) 

***************
Local  cUF:=''
Local nOpc:=''

if alltrim(upper(FunName())) == "ESTC005"
   return .T.
Endif

if !empty(cLocaliz)
	//DbSelectArea("SX5")
	//DbSetOrder(1)
	//If SX5->( dbSeek( xFilial( "SX5" ) + "ZZ"+cLocaliz , .t. ) )
	
	DbSelectArea("CC2")
	DbSetOrder(3)
	If CC2->( dbSeek( xFilial( "CC2" ) + cLocaliz , .t. ) )
	   
       if alltrim(upper(FunName())) == "FATC019"

		   If ALLTRIM(M->ZC5_TIPO)='N' // normal 
			  DbSelectArea("SA1")
			  DbSetOrder(1)
			  SA1->(DbSeek(xFilial("SA1")+M->ZC5_CLIENT+M->ZC5_LOJACL))   
		      cUF:=SA1->A1_EST
		      nOpc:='1'
		   ElseIf ALLTRIM(M->ZC5_TIPO)$'B/D' // devolucao
	          DbSelectArea("SA2")
			  DbSetOrder(1)
			  SA2->(DbSeek(xFilial("SA2")+M->ZC5_CLIENT+M->ZC5_LOJACL))   
		      cUF:=SA2->A2_EST
	          nOpc:='2'
	       EndIf		      
	
       else
    
		   If ALLTRIM(M->C5_TIPO)='N' // normal 
			  DbSelectArea("SA1")
			  DbSetOrder(1)
			  SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))   
		      cUF:=SA1->A1_EST
		      nOpc:='1'
		   ElseIf ALLTRIM(M->C5_TIPO)$'B/D' // devolucao
	          DbSelectArea("SA2")
			  DbSetOrder(1)
			  SA2->(DbSeek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI))   
		      cUF:=SA2->A2_EST
	          nOpc:='2'
	       EndIf		      
	
       endif
	   
	   /*
	   IF SUBSTR(SX5->X5_DESCRI,AT('(',SX5->X5_DESCRI)+1,2)!=ALLTRIM(cUF)
		   ALERT('O Estado( '+SUBSTR(SX5->X5_DESCRI,AT('(',SX5->X5_DESCRI)+1,2) + ' )da Localizacao nao bate com o Estado( '+ALLTRIM(cUF)+ ' )do '+iif(nOpc='1','Cliente',iif(nOpc='2','Fornecedor','') )  )
		   Return .F. 
	   ENDIF
	   */
	   IF CC2->CC2_EST != ALLTRIM(cUF)
		   ALERT('O Estado( '+CC2->CC2_EST+ ' )da Localizacao nao bate com o Estado( '+ALLTRIM(cUF)+ ' )do '+iif(nOpc='1','Cliente',iif(nOpc='2','Fornecedor','') )  )
		   Return .F. 
	   ENDIF
	   
	endif
endif

Return .T. 