#include "protheus.ch"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ MT100TOK ³ Ponto de entrada na confirmação da nota fiscal de entrada.   º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ Marcelo - Implantação Qualidade Nov/2010 - Fev/2011                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ Flávia Rocha                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//FR - 07/02/2012:
//Alteração: Alterado para validar se pode incluir o Docto Entrada:
// caso não haja divergência
// caso haja, somente com a senha de Marcelo, autoriza a classificação do Docto. Entrada
//FR - 12/06/2012: na nova sistemática de entrada NF , não será mais necessário este pto de entrada
// para validar divergência PC x NF, pois a NF já entrará bloqueada em caso de divergência (e por sujeito à inspeção), e não será
// necessário classificá-la (onde este pto de entrada era acionado).
*****************************
User Function Mt100Tok()
*****************************

Local aArea		:= GetArea()
Local lPode		:= .T.
Local lOk		:= .T.
Local cChave := "" 
Local x         := 0
Local cSituaca := ""
Local lInspeciona := .F.
//Local cTipo     := PARAMIXB[6]  //""
Local lDocEntrada := .F. 
Local cItem   := ""
Local cItemPC := ""
Local nQuant  := 0
Local nPreco  := 0
Local cPedido := ""
Local nTotal  := 0
Local nValipi := 0
Local nipi    := 0
Local aNFE    := {}
Local aDiverg := {}
Local lDiverg := .F. 
Local aSenha  := {}
Local cPodeClas := ""
Local cCodUser := ""
//Local nFreteNF := SF1->F1_VALFRET
Local cCondNF  := SF1->F1_COND
Local lDivQ    := .F.
Local lDivP    := .F.
Local lDivF    := .F.
Local lDivPG   := .F.
Local lDivTot  := .F.					    	
Local lDivipi  := .F.
Local cQuemPode:= ""
Local nPos     := 0
Local nTam     := 0
Local cAux     := ""					    	
/*
QEK->QEK_SITENT == "1" - Laudo pendente  
QEK->QEK_SITENT == "2" - Laudo aprovado                    
QEK->QEK_SITENT == "3" - Laudo reprovado  
QEK->QEK_SITENT == "4" - Laudo c/ liberação urgente  
QEK->QEK_SITENT == "5" - Laudo liberado condicionalmente
QEK->QEK_SITENT == "6" - Laudo s/ movto. estoque
QEK->QEK_SITENT == "7" - Laudo entrada s/ medições


*/

//MSGBOX("cTipo: " + cTipo)
cSeriePode  := GetMV("RV_SERNFE")
cCodEspecie := GetMV("RV_ESPCNFE")
cCodUser  := __CUSERID

// INSERIDO POR ANTONIO
// Retirado em 05/07/2012 - So volta depois que o chamado 002585 for resolvido 
/*
nPosTES := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'    })					    //Posicao TES no acols
nPosTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"})
nTotZ86:=0
cTesFret:=GETMV("MV_TESFRE")
If Inclui 
   if alltrim(aCols[1][nPosTES]) $ cTesFret            
      DbselectArea("Z86")  
      Z86->( dbSetOrder( 1 ) )
      IF  Inclui	      
	      If ! Z86->( dbSeek( xFilial( "Z86" ) + CNFISCAL + CSERIE +CA100FOR+CLOJA ) )     
                ALERT('Frete Não é Mais Lançado Manualmente')
	           RestArea(aArea)
	           //ALERT('Favor entrar em Contado com a Logistica, conhecimento de frete nao cadastrado.')
	           Return .F.
	      Endif	      
      Endif                 
   Endif
EndIF
*/
//

///NÃO SERÁ MAIS NECESSÁRIA ESTA VERIFICAÇÃO, POIS A MESMA FOI INSERIDA NO PTO ENTRADA A103BLOQ
/*
If !cTipo $"D/B"       //se o tipo da nota não for Devolução / Beneficiamento
    
    If Alltrim(cSerie) != "" .and. !cSerie $ Alltrim(cSeriePode)    //se a série da NF não estiver liberada (parâmetro)
		If !cEspecie $ Alltrim(cCodEspecie)  //se a especie da nota não tá no parâmetro, irá fazer as validações abaixo
		    //msgbox("especie: " + cEspecie)
			For x:= 1 to Len(aCols)
			
				If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada
					cItemPC := ""
					nQuant  := 0
					nPreco  := 0
				    				    
					cProduto:=	aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_COD" }) ]
						
						DbselectArea("SB1")
						Dbsetorder(1)
						If SB1->(Dbseek(xFilial("SB1") + cProduto ))
							If Alltrim(SB1->B1_RAVACQ) = "S"
								lInspeciona := .T.					
							Endif
						Endif
						
						If !Empty( aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_PEDIDO" }) ] )			
							cPedido:= aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_PEDIDO" }) ]						
							cItemPC:= aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_ITEMPC" }) ]
							nQuant := aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_QUANT" }) ] 
							nPreco := aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_VUNIT" }) ]
							nTotal := aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_TOTAL" }) ]
							nValipi:= aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_VALIPI" }) ]
							nipi   := aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_IPI" }) ]
							Aadd(aNFE, { cPedido, cItemPC, nQuant, nPreco, nFreteNF, cCondNF, nTotal, nValipi, nipi } )   //Armazena no array de itens da NF, para comparar com o pedido	 
						Endif			
				Endif
			Next
			
			For y:= 1 to Len(aCols)
				
				If lInspeciona 
					//msgbox("INSPECIONA")
					cItem   := aCols[y][ aScan( aHeader, {|y| alltrim(y[2]) == "D1_ITEM" }) ]
					//cProduto:=	aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_COD" }) ]
				
					DbselectArea("QEK")
						QEK->(Dbsetorder(10)) //QEK_FILIAL+QEK_FORNEC+QEK_LOJFOR+QEK_NTFISC+QEK_SERINF+QEK_ITEMNF+QEK_TIPONF+QEK_NUMSEQ                                                                         
						If QEK->(Dbseek(xFilial("QEK") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE )) //+ cItem + SD1->D1_TIPO ))
							cChave := QEK->QEK_CHAVE
							While !QEK->(EOF()) .and. QEK->QEK_FILIAL == xFilial("QEK")	.and. QEK->QEK_CHAVE == cChave
								If QEK->QEK_SITENT != '2' .or. QEK->QEK_SITENT != '4'  .or. QEK->QEK_SITENT != '5'  .or. QEK->QEK_SITENT != '6'
							    	Do Case
							    	 Case QEK->QEK_SITENT == "1"
							    	  	cSituaca := "Inspeção pendente"
							    	  	lPode := .F.
								     //Case QEK->QEK_SITENT == "2"
								     	//cSituaca := "Inspeção aprovado"
									 Case QEK->QEK_SITENT == "3"
									 	cSituaca := "Inspeção reprovada"
									 	lPode := .F.  
									 //Case QEK->QEK_SITENT == "4"
									 	//cSituaca := "Inspeção c/ liberação urgente"  
									 //Case QEK->QEK_SITENT == "5"
									 	//cSituaca := "Inspeção liberada condicionalmente"
								     //Case QEK->QEK_SITENT == "6"
								     	//cSituaca := "Inspeção s/ movto. estoque"
									Case QEK->QEK_SITENT == "7"
										cSituaca := "Inspeção de entrada s/ medições"
										lPode := .F.
							    	Endcase
							    	
							    					
								Endif
								QEK->(Dbskip())			
							Enddo
						Else
							msgbox("Registro Não Encontrado na Tabela QEK : " + Alltrim(SF1->F1_DOC) + '/' + Alltrim(SF1->F1_SERIE) + " - Favor Entrar em contato com o Administrador." )
						Endif
				
				Endif
				    	
			Next
			
			If !lPode
							
				Aviso(	"Documento de Entrada",;
						"A nota não poderá ser incluída, Motivo: " + cSituaca + ;
						 ". Favor entrar em contato com o Depto. QUALIDADE",;
						{"&Ok"},,;
						"INSPEÇÃO ENTRADA")
				lOk	:= .f.
			//Else
			//	msginfo("INSPEÇÃO APROVADA")
			Endif
			x:= 0
			//
			//checagem do pedido    
			//If !Empty(Alltrim(cPedido))
			If Len(aNFE) > 0
				
				//checagem de divergências com o pedido
				DbselectArea("SC7")
				SC7->(Dbsetorder(1))
				SC7->(Dbgotop())
				//If SC7->(Dbseek(xFilial("SC7") + aNFE[1,1] + aNFE[1,2]   ))  //caso encontre o pedido...	
					//Aadd(aNFE, { cPedido, cItemPC, nQuant, nPreco, nFreteNF, cCondNF, nTotal, nValipi, nipi} )   //Armazena no array de itens da NF, para comparar com o pedido	 
					For x := 1 to Len(aNFE)
						SC7->(Dbsetorder(1))
						SC7->(Dbgotop())
						If SC7->(Dbseek(xFilial("SC7") + aNFE[x,1] + aNFE[x,2]  ))				    
						    //msgbox("ped / item: " + aNFE[x,1] + ' / ' + aNFE[x,2] )
						    If aNFE[x,3] != SC7->C7_QUANT      //DIVERGÊNCIA QTDE
						    	lDiverg := .T. 
						    	lDivQ   := .T.						    	
						    Endif
						    
						    If aNFE[x,4] != SC7->C7_PRECO  //DIVERGÊNCIA PREÇO
						    	lDiverg := .T.
						    	lDivP    := .T. 						    
						    Endif
						    
						    If aNFE[x,5] != SC7->C7_VALFRET  //DIVERGÊNCIA VALOR FRETE
						    	lDiverg := .T.
						    	lDivF   := .T.					    	
						    Endif
						    
						    If Alltrim(aNFE[x,6]) != Alltrim(SC7->C7_COND)  //DIVERGÊNCIA COND.PAGTO
						    	lDiverg := .T.
						    	lDivPG  := .T.
						    Endif
						    
						    If Round(aNFE[x,7],2) != Round(SC7->C7_TOTAL,2)  //DIVERGÊNCIA VAL TOTAL
						    	lDiverg := .T.
						    	lDivTot  := .T.						       
						    Endif
						    
						    If ( aNFE[x,8] != SC7->C7_VALIPI .or. aNFE[x,9] != SC7->C7_IPI )  //DIVERGÊNCIA VAL IPI
						    	lDiverg := .T.
						    	lDivipi  := .T.						    
						    Endif								
						Endif
					Next
				//else
				//	msgbox("não encontrou pedido!")
				//Endif // dbseek no SC7
				If lDiverg
					
					cMsg := "Esta NF Apresentou a(s) Seguinte(s) Divergência(s) com o Pedido de Compra:" + CHR(13) + CHR(10) 
				    If lDivQ
				    	cMsg += " - Quantidade" + CHR(13) + CHR(10)  
				    Endif
				    
				    If lDivP
				    	cMsg += " - Preço" + CHR(13) + CHR(10)  
				    Endif
				    
				    If lDivF
				    	cMsg += " - Valor Frete" + CHR(13) + CHR(10)  					    
				    Endif
				    
				    If lDivPG
				    	cMsg += " - Cond. Pagto." + CHR(13) + CHR(10)  					    				    
				    Endif 
				    
				    If lDivTot
				    	cMsg += " - Valor Total" + CHR(13) + CHR(10)  					    				    
				    Endif 
				    
				    If lDivipi
				    	cMsg += " - Valor IPI" + CHR(13) + CHR(10)  					    				    
				    Endif 
				    
				    SX5->( DBSETORDER( 1 ) )
					SX5->( DBSEEK(xFILIAL( "SX5" ) + "ZY" + STRZERO( VAL( "15"), 2 ) ) )
	                cAux := ALLTRIM(SX5->X5_DESCRI)
	                cQuemPode := fAt(cAux)
	                //cQuemPode:= ALLTRIM(SX5->X5_DESCRI)
				    //cMsg += "Somente Marcelo poderá autorizar esta Operação."+CHR(13)+ CHR(10)
				    cMsg += "Somente:  " + cQuemPode + "  poderá(ão) autorizar esta Operação."+CHR(13)+ CHR(10)
				    	    	
				    	
					//MsgInfo(cMsg)		
					
					//lOk := U_SENHAPRE_NF("15", 0 , "Divergência entre Pedido de Compra e Pré_Nota Entrada") //SENHA3( cTipo, nOpcao, cTITULO )
				
				Endif								
		    //ELSE
		    	//MSGBOX("ARRAY VAZIO!!")
		    Endif
		    
	    Endif  //endif da validação da espécie nf
    //Else 
    	//msgbox("esta série pode")
    Endif
   
Endif
*/
RestArea(aArea)

Return(lOk)

**************************
Static Function fAt(cCF)
**************************

Local nTam := Len(cCF)
Local nConta := 1
Local cPar   := ""

//a função AT retorna um valor numérico
//que corresponde à posição do caracter especificado, ex; a vírgula
//retornou a posição 5 que é a primeira vírgula q ele encontrou


While nConta <= Len( cCF )
	
	If Substr( cCF , nConta, 1 ) != '*'
		cPar += Substr(cCF , nConta , 1 )
	Elseif Substr( cCF , nConta, 1 ) = '*' .and. nConta < nTam
		cPar += " , "
	Elseif Substr( cCF , nConta, 1 ) = '*' .and. nConta = nTam 
		cPar += " "	
	Endif
    nConta++
    
    //MARCELO*EURIVAN*RUBEN*EDNA*                            
Enddo

Return(cPar)


	