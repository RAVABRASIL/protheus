#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
///////////////////////////////////////////////////////////////////////////
//Programa: FA440VLD - Pto de entrada no recálculo das comissões
//Autoria : Flávia Rocha
//Data    : 10/06/2011
//Objetivo: No recálculo de comissões, os bônus estavam sendo apagados,
//          Para serem novamente gerados, implementei este P.E.
///////////////////////////////////////////////////////////////////////////
*/
*************************
User Function FA440VLD(nOPCAO) 
************************* 

Local cQuery := ""
Local nReg	 := 0 
Local nRegTot:= 0
Local nDias	 := 0 
Local dEmis  
Local nBase
Local cBE
Local cPed
Local cSeq
Local cOrig
Local dVenc 
Local cUF
Local LF := CHR(13) + CHR(10) 
Local lBonus := .F.
Local nPerc := 0
Local nPrzEnt := 0

Local dData1 := mv_par01
Local dData2 := mv_par02

X := 1          //no programa antigo havia esta linha

//alert("entrou no F440DEL")
If Alltrim( UPPER(FUNNAME()) ) == "FINA440"

	cQuery := "SELECT E3_FILIAL, E3_VEND, E3_BONUS, A1_SATIV1, E3_NUM, E3_PREFIXO, E3_PARCELA, E3_EMISSAO, E3_DATA, E3_TIPO "  + LF
	cQuery += " ,E3_BASE, E3_SEQ, E3_VENCTO, E3_BAIEMI, E3_ORIGEM, E3_BASE, E3_PEDIDO, A1_EST, E3_CODCLI, E3_LOJA, E1_BAIXA, E1_EMISSAO "  + LF
	cQuery += " FROM " + LF
	cQuery += " " + RetSqlName("SE3") + " SE3 , " + LF
	cQuery += " " + RetSqlName("SA1") + " SA1 , " + LF
	cQuery += " " + RetSqlName("SE1") + " SE1   "  + LF
	cQuery += " where E3_EMISSAO >= '" + DtoS(dData1) + "' AND E3_EMISSAO <= '" + DtoS(dData2) + "'  "  + LF
	//cQuery += " AND E3_VEND = '" + Alltrim(cVendedor) + "' " + LF
	
	cQuery += " AND SE3.D_E_L_E_T_ = '' AND SE3.E3_FILIAL = '" + xFilial("SE3") + "' "  + LF
	cQuery += " AND SA1.D_E_L_E_T_ = '' "  + LF
	cQuery += " AND SE1.D_E_L_E_T_ = '' AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "  + LF
	
	cQuery += " AND E3_CODCLI = A1_COD "  + LF
	cQuery += " AND E3_LOJA = A1_LOJA "  + LF
	
	
	cQuery += " AND E1_PREFIXO = E3_PREFIXO "  + LF
	cQuery += " AND E1_NUM = E3_NUM "  + LF
	cQuery += " AND E1_PARCELA = E3_PARCELA "  + LF
	cQuery += " AND E1_CLIENTE = E3_CODCLI "  + LF
	cQuery += " AND E1_LOJA = E3_LOJA "  + LF
	cQuery += " AND A1_SATIV1 = '000009' "  + LF
	cQuery += " ORDER BY E3_NUM,E3_PARCELA "  + LF
	
	MemoWrite("C:\Temp\F440DEL.sql", cQuery )
	
	If Select("SE3X") > 0
		DbSelectArea("SE3X")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "SE3X"
	
	TCSetField( "SE3X", "E3_EMISSAO", "D")
	TCSetField( "SE3X", "E1_EMISSAO", "D")
	TCSetField( "SE3X", "E1_BAIXA", "D")
	TCSetField( "SE3X", "E3_DATA", "D")   
	TCSetField( "SE3X", "E3_VENCTO", "D")   
	
	
	SE3X->( DbGoTop() )
	
	SE3X->( DbGoTop() )
	While SE3X->( !EOF() )
		lBonus:= .F.
		nPerc    := 0		
	    cVend    := SE3X->E3_VEND 
	    cCliente := SE3X->E3_CODCLI
	    cLoja	 := SE3X->E3_LOJA
	    nDias	 := 0
	    cUF		 := SE3X->A1_EST
		    
	    SE3->(DBSETORDER(1))
	    SE3->(Dbseek(xFilial("SE3") + SE3X->E3_PREFIXO + SE3X->E3_NUM + SE3X->E3_PARCELA))
		    
	    WHILE SE3->(!EOF()) .AND. SE3->E3_FILIAL == SE3X->E3_FILIAL .AND. SE3->E3_PREFIXO == SE3X->E3_PREFIXO;
	     .AND. SE3->E3_NUM == SE3X->E3_NUM .AND. SE3->E3_PARCELA == SE3X->E3_PARCELA
	     	If Alltrim(SE3->E3_BONUS) = "S"
	     		lBonus := .T.
	     	Endif
		     	
	    	SE3->(DBSKIP()) 
	    ENDDO
	    
	    If !lBonus
		   	//SE FOR HILTON (VEND. FUNCIONÁRIO) NÃO GERA -> VENDEDOR: 0220
		    If Alltrim(cVend) != '0220'
			    
		    	cModal := U_GetModali(SE3X->E3_PEDIDO)
			    	
		    	If  alltrim(cModal) != "XX"
			    	
					if cUF != "SP" //Orgaos Publicos e diferentes de SP
					
				        nDias := (SE3X->E1_BAIXA - SE3X->E1_EMISSAO) 
				        nPrzEnt := U_fPrazoMin(cUF)
			     		nPerc := U_FINC002(SE3X->E3_PEDIDO, nDias, nPrzEnt)
								
			   		endif		//if do orgãos públicos e diferente de SP
				
				endif	//if do cModal				           
			        
		    	If nPerc > 0
					DbselectArea("SE3")
					//SE3->( dbSetOrder( 1 ) )
					//SE3->( dbSeek( xFilial( "SE3" ) + SE3X->E3_PREFIXO + SE3X->E3_NUM + SE3X->E3_PARCELA  ) )
						
					//Salvo os valores da comissao já gerada, Perc., e Vlr. Comissão
					dEmis := SE3X->E3_EMISSAO; nBase := SE3X->E3_BASE; cBE   := SE3X->E3_BAIEMI 
						cPed  := SE3X->E3_PEDIDO;  cSeq  := SE3X->E3_SEQ;  cOrig := SE3X->E3_ORIGEM  
						dVenc := SE3X->E3_VENCTO
					
						RecLock("SE3", .T.)
						SE3->E3_FILIAL  := xFilial("SE3")
						SE3->E3_VEND    := cVend
						SE3->E3_NUM     := SE3X->E3_NUM
						SE3->E3_EMISSAO := dEmis
						SE3->E3_SERIE   := SE3X->E3_PREFIXO
						SE3->E3_CODCLI  := cCliente
						SE3->E3_LOJA    := cLoja
						SE3->E3_BASE    := nBase
						SE3->E3_PORC    := nPerc  //Calcular com base na modalidade
						SE3->E3_COMIS   := (nBase * nPerc)/100  //Calcular com base na modalidade
						SE3->E3_PREFIXO := SE3X->E3_PREFIXO
				        SE3->E3_PARCELA := SE3X->E3_PARCELA
				        SE3->E3_TIPO    := SE3X->E3_TIPO
				        SE3->E3_BAIEMI  := cBE
				        SE3->E3_PEDIDO  := cPed
				        SE3->E3_SEQ     := cSeq
				        SE3->E3_ORIGEM  := cOrig
				        SE3->E3_VENCTO  := dVenc
				        SE3->E3_BONUS   := "S"
				        MsUnLock() 
				        //nReg++  
			        Endif		//nperc > 0
			    Endif		//endif do vendedor diferente de 0220
		    Endif 	//SE NÃO TEM BONUS
		    //nRegTot++
		    DBSELECTAREA("SE3X")              
		    SE3X->(DBSKIP())
		    
		
		Enddo 
Endif		//endif se funname = fina440
  
Return .T.
