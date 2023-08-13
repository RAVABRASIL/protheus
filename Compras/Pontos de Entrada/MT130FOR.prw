#INCLUDE "rwmake.ch"         
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT130FOR º Autor ³ Flávia Rocha       º Data ³  20/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Pto Entrada: Alteração de fornecedores no processo  cotaçãoº±±
±±º          ³  ( [ PARAMIXB ] ) --> aRet                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
Solicitado através do chamado: 00000352 - Marcelo Viana
Dos orçamentos: Desenvolver validações para Cotações: 
Peças para confecção -> Apresentar 1 Cotações. 
Matéria prima -> Apresentar 1 Cotação p/ cada fornecedor homologado. 
Demais itens e serviços -> Apresentar 3 Cotações
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
Detalhes técnicos do P.E.:

LOCALIZAÇÃO : Function A130Grava() - Após clicar em Gera Cotação, o sistema irá escolher
os fornecedores a gerar de acordo com o filtro realizado neste ponto entrada.  
 
Finalidade: Ponto de entrada a ser utilizado para a alteração dos fornecedores envolvidos
no processo de cotacao. 

ALTERACAO DOS FORNECEDORES DA COTACAO


Array multidimensional com a seguinte estrutura: 
PARAMIXB[x][1] -> Codigo do Fornecedor ; 
PARAMIXB[x][2] -> Codigo da Loja ; 
PARAMIXB[x][3] -> Data Ultimo Fornecimento;
PARAMIXB[x][4] -> Sigla da Tabela SA2;
PARAMIXB[x][5] -> Número Registro Tabela SA2
*/

*************************
User Function MT130FOR   
*************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFornece := ""
Local cTipoProd:= ""
Local aRetFor  := {}  //{ "" , "" , Ctod("  /  /    ") , "" , 0 }
Local cProduto := SC1->C1_PRODUTO
Local x        := 0  
Local aForn    := {} 
Local cTipos   := GetMV("RV_COTIPOS") //contém os tipos que são homologados
Local cUrgente := SC1->C1__URGEN
Private cString := "SC1"


//ALERT("ANTES mv_par01: " + str(MV_PAR01) )
//MV_PAR01 := 10
//ALERT("DEPOIS mv_par01: " + str(MV_PAR01) )

SB1->(Dbsetorder(1))
If SB1->(Dbseek(xFilial("SB1") + cProduto))
	If Alltrim(SB1->B1_TIPO) $ Alltrim(cTipos)  //= 'MP' // = 'MP'  //SE FOR MATÉRIA PRIMA, APRESENTAR UMA COTAÇÃO PARA CADA FORNECEDOR HOMOLOGADO
		If Alltrim(SB1->B1_HOMOLG) = "S"  //SE O PRODUTO É HOMOLOGADO
		//se o fornecedor não é homologado, irei buscar no histórico de fornecimentos, um fornecedor homologado
		
			MV_PAR01 := 10  //FR - 25/07/13 - SIM, É POSSÍVEL MANIPULAR O MV_PAR QUE INDICA QTOS FORNECEDORES IRÃO PARTICIPAR DA GERAÇÃO DA COTAÇÃO!
						    //COLOQUEI 10, POIS ACREDITO QUE FICA ADEQUADO PARA A ANÁLISE DE FORNECEDORES HOMOLOGADOS
						    //MAIS QUE ISSO, FICA IMPRODUTIVA A ATUALIZAÇÃO DA COTAÇÃO.
			aForn :=  fTrazForn(cProduto, SB1->B1_TIPO) 		
			x:= 1
			For x := 1 to Len(aForn)			
				Aadd(aRetFor , { aForn[x,1], aForn[x,2] , aForn[x,3] , "SA2" , aForn[x,4] } )
			Next					
		Endif           //b1_homolog
	//FR - 26/03/14
	Elseif Alltrim(cUrgente) = "S" 
		MV_PAR01 := 1 //se a compra for urgente, apresenta apenas uma cotação		
	Endif      //b1_tipo
Endif //seek B1

Return(aRetFor)
                                          

***************************************
Static Function fTrazForn( cProduto , cTipo )  
***************************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10) 
Local aRetF   := { } 
Local cForn := "" 
Local dUltFor := ""

cQuery := "Select " + LF

If Alltrim(cTipo) = 'MP'      //MP TRARÁ UMA COTAÇÃO PARA CADA FORN HOMOLOGADO
	cQuery += " Distinct (D1_FORNECE+D1_LOJA) as FORN, A2_HMLG1, A2_HMLG2, A2_ULTCOM, SA2.R_E_C_N_O_ RECA2 " + LF 

Else    ////PEÇA PARA CONFECÇÃO, UMA COTAÇÃO APENAS.
	cQuery += " TOP 1 (D1_FORNECE+D1_LOJA) as FORN, A2_HMLG1, A2_HMLG2 " + LF
	cQuery += " ,D1_VUNIT , D1_VALFRE, D1_TOTAL, (D1_VALFRE + D1_VUNIT) CUSTOT , D1_QUANT , F1_COND " + LF
	cQuery += "  ,Diaspag = (select E4_PRZMED FROM SE4010 E4 WHERE SF1.F1_COND = E4.E4_CODIGO AND E4.D_E_L_E_T_ = '') " + LF
	cQuery += " ,D1_EMISSAO, D1_FORNECE, D1_LOJA " + LF
Endif

	cQuery += " FROM " + LF

cQuery += " " + RetSqlname("SD1") + " SD1 " + LF  
cQuery += " , " + RetSqlName("SF1") + " SF1 " + LF
cQuery += " , " + RetSqlName("SA2") + " SA2 " + LF
cQuery += " Where "                        
cQuery += " D1_FILIAL = F1_FILIAL " + LF
cQuery += " AND D1_DOC = F1_DOC " + LF
cQuery += " AND D1_FORNECE = F1_FORNECE " + LF
cQuery += " AND D1_LOJA = F1_LOJA " + LF
cQuery += " and D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA " + LF
cQuery += " and D1_COD = '" + Alltrim(cProduto) + "' " + LF
//cQuery += " and D1_TP = '" + Alltrim(cTipo) + "' " + LF
If Alltrim(cTipo) = 'MP' 
	cQuery += " and A2_HMLG1 = 'S' and A2_HMLG2 = 'S' " + LF     //homologação só para matéria-prima
Else
	cQuery += " and LEFT(D1_EMISSAO,4) = '" + Substr(Dtos(dDatabase),1,4) + "' " + LF
Endif
cQuery += " and SD1.D_E_L_E_T_ = '' " + LF
cQuery += " and SF1.D_E_L_E_T_ = '' " + LF
cQuery += " and SA2.D_E_L_E_T_ = '' " + LF
If Alltrim(cTipo) = 'MP'
	cQuery += " Order by FORN " + LF
Else
	cQuery += " Order by D1_EMISSAO DESC , D1_VUNIT, Diaspag, FORN " + LF  //SE FOR PEÇAS P/ CONFECÇÃO, ORDENARÁ PELA MELHOR CONDIÇÃO PAG/PREÇO
Endif
MemoWrite("\TEMP\fTrazFornD1.sql",cQuery )

If Select("D1XX")  > 0
	DbselectArea("D1XX")
	DbCloseArea()
Endif            

TcQuery cQuery New Alias "D1XX"

///verifica SA5 caso a 1a. query não traga resultado
IF !D1XX->(EOF())      //SE TEM NO A2 x D1

	/*
	aRetFor[x][1]:= aForn[x,1] //-> Codigo do Fornecedor ; 
	aRetFor[x][2]:= aForn[x,2] //->Codigo da Loja ; 
	aRetFor[x][3]:= aForn[x,3] // -> Data Ultimo Fornecimento;
	aRetFor[x][4] := "SA2" //-> Sigla da Tabela SA2;
	aRetFor[x][5] := aForn[x,4] //-> Número Registro Tabela SA2
	*/
					

	D1XX->( DbGoTop() )
	While D1XX->( !EOF() )
		cForn := D1XX->FORN
		dUltFor := D1XX->A2_ULTCOM 
	   	Aadd( aRetF , { Substr(cForn,1,6) , Substr(cForn,7,2), StoD( dUltFor) , D1XX->RECA2 } )
		D1XX->(Dbskip())
	Enddo 

ELSE    //se a 1a. query não trouxer nenhum dado, faço esta que captura pelo SA5

	cQuery := "Select " + LF
	If Alltrim(cTipo) = 'MP'      //MP TRARÁ UMA COTAÇÃO PARA CADA FORN HOMOLOGADO	
		cQuery += " Distinct (A5_FORNECE+A5_LOJA) as FORN, A2_HMLG1, A2_HMLG2 , A2_ULTCOM, SA2.R_E_C_N_O_ AS RECA2 " + LF
	
	Else    ////PEÇA PARA CONFECÇÃO, UMA COTAÇÃO APENAS.
		cQuery += " Top 1 (A5_FORNECE+A5_LOJA) as FORN, A2_HMLG1, A2_HMLG2 " + LF
		
	Endif
		cQuery += " FROM " + LF
	
	cQuery += " " + RetSqlname("SA5") + " SA5 " + LF  
	cQuery += " , " + RetSqlName("SA2") + " SA2 " + LF
	cQuery += " Where "                        
	cQuery += " A5_FORNECE = A2_COD " + LF
	cQuery += " AND A5_LOJA = A2_LOJA " + LF
	cQuery += " and A5_PRODUTO = '" + Alltrim(cProduto) + "' " + LF
	If Alltrim(cTipo) = 'MP' 
		cQuery += " and A2_HMLG1 = 'S' and A2_HMLG2 = 'S' " + LF     //homologação só para matéria-prima
	Endif
	cQuery += " and SA5.D_E_L_E_T_ = '' " + LF
	cQuery += " and SA2.D_E_L_E_T_ = '' " + LF
	If Alltrim(cTipo) = 'MP'
		cQuery += " Order by FORN " + LF 	
	Endif                                
	MemoWrite("\TEMP\fTrazForn_A5.sql",cQuery )
	If Select("D1XX")  > 0
		DbselectArea("D1XX")
		DbCloseArea()
	Endif            

	TcQuery cQuery New Alias "D1XX"
	///fim procura SA5

	If !D1XX->(EOF())    //SE TEM NO SA5

		/*
		aRetFor[x][1]:= aForn[x,1] //-> Codigo do Fornecedor ; 
		aRetFor[x][2]:= aForn[x,2] //->Codigo da Loja ; 
		aRetFor[x][3]:= aForn[x,3] // -> Data Ultimo Fornecimento;
		aRetFor[x][4] := "SA2" //-> Sigla da Tabela SA2;
		aRetFor[x][5] := aForn[x,4] //-> Número Registro Tabela SA2
		*/
					
	
		D1XX->( DbGoTop() )
		While D1XX->( !EOF() )
			cForn := D1XX->FORN
			dUltFor := D1XX->A2_ULTCOM 
		   	Aadd( aRetF , { Substr(cForn,1,6) , Substr(cForn,7,2), StoD( dUltFor) , D1XX->RECA2 } )
			D1XX->(Dbskip())
		Enddo 
		DbselectArea("D1XX")
		DbCloseArea()


    ELSE //NÃO ENCONTROU TB NO SA5, PROCURA NO SD1 , SÓ POR TIPO PRODUTO


		//E SE POR FIM, NÃO ENCONTRAR NEM D1 (POR PRODUTO) NEM A5 (POR PRODUTO)
		//PROCURO NO SD1 SÓ PELO TIPO PRODUTO:
		cQuery := "Select " + LF
		If Alltrim(cTipo) = 'MP'      //MP TRARÁ UMA COTAÇÃO PARA CADA FORN HOMOLOGADO	
			cQuery += " Distinct (D1_FORNECE+D1_LOJA) as FORN, A2_HMLG1, A2_HMLG2 , A2_ULTCOM, SA2.R_E_C_N_O_ AS RECA2 " + LF
		
		Else    ////PEÇA PARA CONFECÇÃO, UMA COTAÇÃO APENAS.
			cQuery += " Top 1 (D1_FORNECE+D1_LOJA) as FORN, A2_HMLG1, A2_HMLG2 " + LF
			cQuery += " ,D1_VUNIT , D1_VALFRE, D1_TOTAL, (D1_VALFRE + D1_VUNIT) CUSTOT , D1_QUANT , F1_COND " + LF
			cQuery += "  ,Diaspag = (select E4_PRZMED FROM SE4010 E4 WHERE SF1.F1_COND = E4.E4_CODIGO AND E4.D_E_L_E_T_ = '') " + LF
			cQuery += " ,D1_EMISSAO " + LF
		Endif
			cQuery += " FROM " + LF
		
		cQuery += " " + RetSqlname("SD1") + " SD1 " + LF  
		cQuery += " , " + RetSqlName("SF1") + " SF1 " + LF
		cQuery += " , " + RetSqlName("SA2") + " SA2 " + LF
		cQuery += " Where "                        
		cQuery += " D1_FILIAL = F1_FILIAL " + LF
		cQuery += " AND D1_DOC = F1_DOC " + LF
		cQuery += " AND D1_FORNECE = F1_FORNECE " + LF
		cQuery += " AND D1_LOJA = F1_LOJA " + LF
		cQuery += " and D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA " + LF
		//cQuery += " and D1_COD = '" + Alltrim(cProduto) + "' " + LF   //qdo não houver entrada específica p/ este produto, capturo as entradas do tipo apenas
		cQuery += " and D1_TP = '" + Alltrim(cTipo) + "' " + LF
		If Alltrim(cTipo) = 'MP' 
			cQuery += " and A2_HMLG1 = 'S' and A2_HMLG2 = 'S' " + LF     //homologação só para matéria-prima
		Else
			cQuery += " and LEFT(D1_EMISSAO,4) = '" + Substr(Dtos(dDatabase),1,4) + "' " + LF //captura as entradas do ano corrente
		Endif
		cQuery += " and SD1.D_E_L_E_T_ = '' " + LF
		cQuery += " and SF1.D_E_L_E_T_ = '' " + LF
		cQuery += " and SA2.D_E_L_E_T_ = '' " + LF
		If Alltrim(cTipo) = 'MP'
			cQuery += " Order by FORN " + LF 	
		Else
			cQuery += " Order by D1_EMISSAO DESC , Diaspag DESC " + LF 
		Endif                                
		MemoWrite("C:\TEMP\fTrazForn_tp.sql",cQuery )
		
		If Select("D1XX")  > 0
			DbselectArea("D1XX")
			DbCloseArea()
		Endif            
		
		TcQuery cQuery New Alias "D1XX"
		If !D1XX->(EOF())    //SE TEM NO SD1 POR TIPO APENAS

			/*
			aRetFor[x][1]:= aForn[x,1] //-> Codigo do Fornecedor ; 
			aRetFor[x][2]:= aForn[x,2] //->Codigo da Loja ; 
			aRetFor[x][3]:= aForn[x,3] // -> Data Ultimo Fornecimento;
			aRetFor[x][4] := "SA2" //-> Sigla da Tabela SA2;
			aRetFor[x][5] := aForn[x,4] //-> Número Registro Tabela SA2
			*/						
		
			D1XX->( DbGoTop() )
			While D1XX->( !EOF() )
				cForn := D1XX->FORN
				dUltFor := D1XX->A2_ULTCOM 
			   	Aadd( aRetF , { Substr(cForn,1,6) , Substr(cForn,7,2), StoD( dUltFor) , D1XX->RECA2 } )
				D1XX->(Dbskip())
			Enddo 
			DbselectArea("D1XX")
			DbCloseArea()
		Endif
		
	ENDIF  //2a. query
	
ENDIF  //1a. query
	


Return(aRetF)

