#Include "Rwmake.ch"
#Include "Topconn.ch" 

/*/
//------------------------------------------------------------------------------------
//Programa: WFMP 
//Objetivo: Enviar e-mail avisando sobre entrada/saída de NF de Produto tipo MP
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 21/09/2010
//------------------------------------------------------------------------------------
/*/


********************************
User Function WFMP( cDocto, cSerie, cTipoNF )
********************************

Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10)
Local aDados	:= {}
Local cNomeTipo := ""
Local _nX		:= 0 
Local cFornecedor:= ""
Local cProduto	:= ""
Local cCliente  := ""
Local cTipoMov  := ""

SetPrvt("OHTML,OPROCESS") 

If cTipoNF = "S"

	cNomeTipo := "Saida"
	
	cQuery := " SELECT D2_TIPO as TIPOMOV, D2_DOC AS NOTA, D2_SERIE AS SERIE, D2_CLIENTE AS CLIFOR, D2_LOJA AS LJCLIFOR " + LF
	cQuery += " , D2_EMISSAO as EMISSAO, D2_QUANT AS QTDE, D2_UM AS UM, D2_TES AS TES " + LF
	cQuery += " ,A1_COD, A1_LOJA, A1_NREDUZ AS NOMECLI, A2_COD, A2_LOJA, A2_NREDUZ AS NOMEFOR " + LF
	cQuery += " ,B1_COD, B1_DESC, D2_ITEM AS ITEM, D2_COD AS PRODUTO, D2_TP AS TIPO " + LF
	cQuery += " FROM " + RetSqlName("SD2") + " SD2, " + LF
	cQuery += " " + RetSqlName("SA2") + " SA2, " + LF
	cQuery += " " + RetSqlName("SB1") + " SB1, " + LF
	cQuery += " " + RetSqlName("SA1") + " SA1 " + LF
	cQuery += " WHERE RTRIM(D2_DOC) = '" + Alltrim(cDocto) + "' " + LF
	cQuery += " AND RTRIM(D2_SERIE) = '" + Alltrim(cSerie) + "' " + LF
	cQuery += " AND D2_TP = 'MP' " + LF 
	cQuery += " AND D2_CLIENTE = A2_COD " + LF
	cQuery += " AND D2_CLIENTE = A1_COD " + LF
	cQuery += " AND D2_LOJA = A2_LOJA " + LF
	cQuery += " AND D2_LOJA = A1_LOJA " + LF
	
	cQuery += " AND D2_COD = B1_COD " + LF
	
	cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = '' " + LF
	cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = '' " + LF
	cQuery += " AND A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.D_E_L_E_T_ = '' " + LF
	cQuery += " AND A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' " + LF 

Elseif cTipoNF = "E" 
	
    cNomeTipo := "Entrada"
    
	cQuery := " SELECT D1_TIPO AS TIPOMOV, D1_DOC AS NOTA, D1_SERIE AS SERIE, D1_FORNECE AS CLIFOR, D1_LOJA AS LJCLIFOR " + LF
	cQuery += " , D1_EMISSAO as EMISSAO, D1_DTDIGIT AS DTDIGIT, D1_QUANT AS QTDE, D1_UM AS UM, D1_TES AS TES " + LF
	cQuery += " ,A1_COD, A1_LOJA, A1_NREDUZ AS NOMECLI, A2_COD, A2_LOJA, A2_NREDUZ AS NOMEFOR " + LF
	cQuery += " ,B1_COD, B1_DESC, D1_ITEM AS ITEM, D1_COD AS PRODUTO, D1_TP AS TIPO " + LF
	cQuery += " FROM " + RetSqlName("SD1") + " SD1, " + LF
	cQuery += " " + RetSqlName("SA2") + " SA2, " + LF
	cQuery += " " + RetSqlName("SB1") + " SB1, " + LF
	cQuery += " " + RetSqlName("SA1") + " SA1 " + LF
	cQuery += " WHERE RTRIM(D1_DOC) = '" + Alltrim(cDocto) + "' " + LF
	cQuery += " AND RTRIM(D1_SERIE) = '" + Alltrim(cSerie) + "' " + LF 
	cQuery += " AND D1_TP = 'MP' " + LF 
	cQuery += " AND D1_FORNECE = A2_COD " + LF
	cQuery += " AND D1_FORNECE = A1_COD " + LF
	cQuery += " AND D1_LOJA = A2_LOJA " + LF
	cQuery += " AND D1_LOJA = A1_LOJA " + LF
	
	cQuery += " AND D1_COD = B1_COD " + LF
	
	cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = '' " + LF
	cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = '' " + LF
	cQuery += " AND A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.D_E_L_E_T_ = '' " + LF
	cQuery += " AND A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' " + LF

Endif
//MemoWrite("C:\Temp\WFMP.SQL",cQuery)

If Select("FTMP") > 0
	DbSelectArea("FTMP")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "FTMP"

If cTipoNF = "S"
	TCSetField( 'FTMP', "EMISSAO", "D")

Elseif cTiponF = "E"
	/*
	TCSetField( 'FTMP', "D1_EMISSAO", "D")
	TCSetField( 'FTMP', "D1_DTDIGIT", "D")
    */
    TCSetField( 'FTMP', "EMISSAO", "D")
	TCSetField( 'FTMP', "DTDIGIT", "D")
Endif


FTMP->( DbGotop() )
If !FTMP->(EOF())

	Do While !FTMP->( Eof() ) 

		If cTipoNF = "S"
		 
	        
	        If FTMP->TIPOMOV != "B" .AND. FTMP->TIPOMOV != "D"   //cliente

				Aadd(aDados, { FTMP->CLIFOR, FTMP->LJCLIFOR, FTMP->NOMECLI, FTMP->EMISSAO,;
							FTMP->ITEM, FTMP->PRODUTO, FTMP->TIPO, FTMP->B1_DESC, FTMP->QTDE, FTMP->UM, FTMP->TES } )
				cTipoMov := "N"		//saída normal
			
			Else		//fornecedor

				Aadd(aDados, { FTMP->CLIFOR, FTMP->LJCLIFOR, FTMP->NOMEFOR, FTMP->EMISSAO,;
							FTMP->ITEM, FTMP->PRODUTO, FTMP->TIPO, FTMP->B1_DESC, FTMP->QTDE, FTMP->UM, FTMP->TES } )
				cTipoMov := "B"		//beneficiamento ou dev. compras
			
			Endif
									
		Elseif cTipoNF = "E"

			Aadd(aDados, { FTMP->CLIFOR, FTMP->LJCLIFOR, FTMP->NOMECLI, FTMP->EMISSAO,;
							FTMP->ITEM, FTMP->PRODUTO, FTMP->TIPO, FTMP->B1_DESC, FTMP->QTDE, FTMP->UM, FTMP->TES, FTMP->DTDIGIT } )
		
		Endif
	    FTMP->(Dbskip())
	Enddo

Else       ///caso a query não traga resultados

	If cTipoNF = "S"
	    
		DbselectArea("SD2")
		SD2->(Dbsetorder(2))
		If SD2->(Dbseek(xFilial("SD2") + cDocto + cSerie ))
			While !SD2->(EOF()) .AND. SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC == cDocto .and. SD2->D2_SERIE == cSerie
					If Alltrim(SD2->D2_TP) = 'MP'
					
						If SD2->D2_TIPO != "B" .AND. SD2->D2_TIPO != "D"   //cliente
						
							SA1->(Dbsetorder(1))
							If SA1->(Dbseek(xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA ))				
								cCliente := Alltrim(SA1->A1_NREDUZ)
							Endif
							
							SB1->(Dbsetorder(1))
							If SB1->(Dbseek(xFilial("SB1") + SD2->D2_COD ))
								cProduto := Alltrim(SB1->B1_DESC)
							Endif
							
							Aadd(aDados, { SD2->D2_CLIENTE,;
											SD2->D2_LOJA,;
											cCliente,;
											SD2->D2_EMISSAO,;
											SD2->D2_ITEM,;
											SD2->D2_COD,;
											SD2->D2_TP,;
											cProduto,;
											SD2->D2_QUANT,;
											SD2->D2_UM,;
											SD2->D2_TES } )
						
						Else		//fornecedor
						
							SA2->(Dbsetorder(1))
							If SA2->(Dbseek(xFilial("SA2") + SD2->D2_CLIENTE + SD2->D2_LOJA ))				
								cFornecedor := Alltrim(SA2->A2_NREDUZ)
							Endif
							
							SB1->(Dbsetorder(1))
							If SB1->(Dbseek(xFilial("SB1") + SD2->D2_COD ))
								cProduto := Alltrim(SB1->B1_DESC)
							Endif
							
							Aadd(aDados, { SD2->D2_CLIENTE,;
											SD2->D2_LOJA,;
											cFornecedor,;
											SD2->D2_EMISSAO,;
											SD2->D2_ITEM,;
											SD2->D2_COD,;
											SD2->D2_TP,;
											cProduto,;
											SD2->D2_QUANT,;
											SD2->D2_UM,;
											SD2->D2_TES } )
						
						Endif		//endif se é saída para cliente ou fornecedor
					
					Endif		//endif se é MP
			
				SD2->(Dbskip())
			Enddo
		//Else
			//msgbox("nf não encontrada SD2")
		Endif
	
	
	Elseif cTipoNF = "E"
	
		DbselectArea("SD1")
		SD1->(Dbsetorder(1))
		If SD1->(Dbseek(xFilial("SD1") + cDocto + cSerie ))
			While !SD1->(EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == cDocto .and. SD1->D1_SERIE == cSerie
					If Alltrim(SD1->D1_TP) = 'MP'
						SA2->(Dbsetorder(1))
						If SA2->(Dbseek(xFilial("SA2") + SD1->D1_FORNECE + SD1->D1_LOJA ))				
							cFornecedor := Alltrim(SA2->A2_NREDUZ)
						Endif
						
						SB1->(Dbsetorder(1))
						If SB1->(Dbseek(xFilial("SB1") + SD1->D1_COD ))
							cProduto := Alltrim(SB1->B1_DESC)
						Endif
						
						Aadd(aDados, { SD1->D1_FORNECE,;    //1
										SD1->D1_LOJA,;      //2
										cFornecedor,;       //3
										SD1->D1_EMISSAO,;   //4
										SD1->D1_ITEM,;      //5
										SD1->D1_COD,;       //6
										SD1->D1_TP,;        //7
										cProduto,;          //8
										SD1->D1_QUANT,;     //9
										SD1->D1_UM,;        //10
										SD1->D1_TES,;       //11
										SD1->D1_DTDIGIT } ) //12
					
					Endif
			
				SD1->(Dbskip())
			Enddo
		//Else
			//msgbox("nf não encontrada SD1")
		Endif
	
	Endif
	
Endif

DbSelectArea("FTMP")
DbCloseArea()	

If Len(aDados) > 0

	// Inicialize a classe de processo:
	oProcess:=TWFProcess():New("AVISO NF MP","NOVA NF MP")
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WFMP.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:ValByName("cNomeTipo", cNomeTipo )
	oHtml:ValByName("cNota", cDocto )
	oHtml:ValByName("cSerie", cSerie )
	oHtml:ValByName("dEmissao", Dtoc(aDados[1][4]) )
	
	If cTipoNF = "E"
		oHtml:ValByName("dDigit", Dtoc(aDados[1][12]) )
	Else
		oHtml:ValByName("dDigit", Dtoc( Date() ) )
	Endif                             
	oHtml:ValByName("cCliFor", iif(cTipoNF = "E", "Fornecedor: ", iif( cTipoMov = "N" , "Cliente: " , "Fornecedor: " )) )
	oHtml:ValByName("cNome", aDados[1][3] )


	/*
						1				2				3			4
	Aadd(aDados, { FTMP->CLIFOR, FTMP->LJCLIFOR, FTMP->NOMECLI, FTMP->EMISSAO,;
					FTMP->ITEM, FTMP->PRODUTO, FTMP->TIPO,   FTMP->B1_DESC, FTMP->QTDE, FTMP->UM, FTMP->TES, FTMP->DTDIGIT } )
						5			6				7				8		    9			10		11   			12
	*/

	
	For _nX := 1 to Len(aDados)
	     
	   aadd( oHtml:ValByName("it.cItem"), aDados[_nX,5] )
	   aadd( oHtml:ValByName("it.cProd"),  aDados[_nX,6] )
	   aadd( oHtml:ValByName("it.cTipoProd"),  aDados[_nX,7] )		
	   aadd( oHtml:ValByName("it.cDesc") , Alltrim(aDados[_nX,8]) )
	   aadd( oHtml:ValByName("it.nQtde"), aDados[_nX,9] )
	   aadd( oHtml:ValByName("it.cUM"), aDados[_nX,10] )
	   aadd( oHtml:ValByName("it.cTES"), aDados[_nX,11] )
	   
	   	
	
	Next _nX
		
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:cTo    :=  "flavia.rocha@ravaembalagens.com.br"
	oProcess:cTo      :=  "alexandre@ravaembalagens.com.br;joao.emanuel@ravaembalagens.com.br;almoxarifado@ravaembalagens.com.br"
	//oProcess:cCC	  := "flavia.rocha@ravaembalagens.com.br"
	oProcess:cBCC	  := ""
	//oProcess:bReturn  := "U_TMKRetorno()" 	//Não será necessária no novo fluxo
	oProcess:cSubject := "Nova Nota Fiscal de " + cNomeTipo + " de MP no Sistema"
		
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	oProcess:Start()
	
	WfSendMail()
	
	//msginfo("email enviado")
//Else
	//msgbox("array vazio")
Endif

Return