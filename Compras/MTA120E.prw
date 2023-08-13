
*************

User Function MTA120E()

*************
Local cNumSC:=SC7->C7_NUMSC
Local aArea	:= GetArea()

//Se for gerado pela rotina de medições de contratos
If AllTrim(Upper(FunName())) == "CNTA120"

	Return .T.

EndIf

// Solicitacao de Compra
DbSelectArea("SC1")
DbSetOrder(1)          
If SC1->(DbSeek(xFilial("SC1")+cNumSC,.F. ))	
   // Tab. de Config. do Solicitante
//   DbSelectArea("SAI")
//   DbSetOrder(2)
//   If SAI->(DbSeek(xFilial("SAI")+SC1->C1_USER,.F. ))
      Do while ! SC1->( EOF() ) .AND. SC1->C1_NUM=cNumSC 
	     RecLock("SC1",.F.)
//	     If alltrim(SAI->AI_DOMINIO)=='E' // Exclui 	        
//	        SC1->C1_APROV:='B' // Bloqueado      
	        SC1->C1_RESIDUO:=''
//	     elseif alltrim(SAI->AI_DOMINIO)=='I' // Inclui	        
//	        SC1->C1_APROV:='L' // Liberado 	        
//     	    SC1->C1_RESIDUO:=''
//	     EndIf  
         SC1->(MsUnLock())
         SC1->(DbSkip())
      EndDo
//   EndIf
EndIf

RestArea(aArea)

Return .T.