#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
 
USER FUNCTION M185GRV()                              

Local lMsErroAuto := .T.
Local aAreaSB1	:= SB1->(GetArea())
Local cSMOCOD := SM0->M0_CODIGO
Local cSMOFIL := SM0->M0_FILIAL                                   
 
SB1->(Dbsetorder(1))				 //USA O INDICE 1
If SB1->(Dbseek(xFilial("SB1") + SCP->CP_PRODUTO))                          

	If Alltrim(SB1->B1_SETOR) $ "00/99" .AND. SM0->M0_CODIGO == "02" .AND. SM0->M0_CODFIL == "03" //.AND. ALLTRIM(SB1->B1_COD) <> ALLTRIM(GETMV("MV_PRDFITA"))
	
//	If  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "03" // filial caixa
   // Alert("Entrou") 
	    DO WHILE lMsErroAuto
	    //   ALERT("Foi Feita a Transferencia")
	       lMsErroAuto := .F.
	       aMATRIZ     := { { "D3_TM", "104", ""},;
	                        { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
	                        { "D3_FILIAL", xFilial( "SD3" ), NIL},;
	                        { "D3_LOCAL", GETMV("MV_ALMOPRO"), NIL },;
	                        { "D3_COD", SD3->D3_COD, NIL},;
	                        { "D3_UM", SD3->D3_UM, NIL },;
	                        { "D3_QUANT", SD3->D3_QUANT, NIL },;
	                        { "D3_EMISSAO", SD3->D3_EMISSAO, NIL} } 
	            MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )      
	            
	            
	            IF lMsErroAuto
	            	MostraErro()
	            
		    Else
                         
                    ENDIF                               
	    ENDDO           		
    ENDIF
ENDIF 

RestArea(aAreaSB1) 

RETURN 