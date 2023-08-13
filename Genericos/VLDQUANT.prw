#INCLUDE "Topconn.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDQUANT  ºAutor  ³Eurivan Marques     º Data ³  05/25/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao para nao permitir quantidades que nao seja multi- º±±
±±º          ³plas da quantidade de embalagem, na digitacao do P.Venda    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDQUANT  ºAutor  ³Eurivan Marques     º Data ³  05/25/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao para nao permitir quantidades que nao seja multi- º±±
±±º          ³plas da quantidade de embalagem, na digitacao do P.Venda    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*User function VldQuant()

local lAchou := .F.
local lOk  := .T.
local nOpc
local nVal
local nPosPro
local nPosTes
local cTes := ""
local nMult
local nResto
local cProduto
local lFatQbr := GetMV("MV_FATQBR")

if ! lFatQbr
	if AllTrim(Upper(FunName())) = "MATA410"
		nOpc     := 1
		nPosPro  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
		nPosTes  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES" } )
		cProduto := U_TransGen(aCols[n,nPosPro])
		cTes     := aCols[n,nPosTes]
	elseif AllTrim(Upper(FunName())) = "MATA415"
		nOpc     := 2
		cProduto := U_TransGen(TMP1->CK_PRODUTO )
	elseif AllTrim(Upper(FunName())) = "LIBERESTN" .OR. AllTrim(Upper(FunName())) = "LIBERAEST" .OR. AllTrim(Upper(FunName())) = "LIBESTX"
		nOpc     := 3
		cProduto := U_TransGen(ITE->PRODUTO)
		cTes     := ITE->TES
	endif

	if cTes $ "515/516/506/535"
		return .T.
	endif
	
	if Substr( cProduto,1,3 ) # "CTG/PI0"
		
		DbSelectArea("SB5")
		SB5->(DbSetOrder(1))
		
		lAchou := SB5->( DbSeek( xFilial("SB5") + cProduto ) )
		nMult := SB5->B5_QTDEN / SB5->B5_PRVL
		if nMult = 0
			nMult := 1
		endif
		
		if nOpc = 1
			nResto := Mod( M->C6_QTDVEN, nMult )
		elseif nOpc = 2
			nResto := Mod( TMP1->CK_QTDVEN, nMult )
		elseif nOpc = 3
			nResto := Mod( nQtd, nMult )
		endif
		
		if lAchou
			if nResto != 0
				lOk := .F.
				Alert( "A quantidade digitada não é multipla da quantidade da embalagem: " + AllTrim(Str( SB5->B5_QTDEN ) ) )
			endif
		endif
	endif
endif

return lOk*/

User function VldQuant()

local lAchou := .F.
local lOk  := .T.
local nOpc
local nVal
local nPosPro
local nPosTes
local cTes := ""
local nMult
local nResto
local cProduto := ""
Local nReg
Local nOrder
Local cEST := "" 
Local cTESExc := GETMV("RV_TESC6")
Local lRet
Local aArea	:= getArea()

//local lFatQbr := GetMV("MV_FATQBR")
//if ! lFatQbr
If  alltrim(upper(FunName())) == "ESTC005" //SE FOR O PROGRAMA SOLIC. AMOSTRA, NÃO FAZ CRÍTICA
	Return .T.
Endif

//If  alltrim(upper(FunName())) == "FATC019" //SE FOR O PROGRAMA PEDIDOS INTERNET, NÃO FAZ CRÍTICA
//	Return .T.
//Endif

if AllTrim(Upper(FunName())) $ "MATA410/FATC019/MATA416" 
	nOpc     := 1
	nPosPro  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
	nPosTes  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES" } )
	cProduto := U_TransGen(aCols[n,nPosPro])
	cTes     := aCols[n,nPosTes]
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	DbSeek( xFilial("SA1") +M->C5_CLIENTE + M->C5_LOJACLI )// alteracao feita em 29/01/09 chamado 000781*/
	if SA1->A1_SATIV1 == "000009"
		return .T.		
	endIf
	If Empty(cTes)
		cTes := SA1->A1_TES	
	Endif
	
	//FR - 13/08/13 - incluído parâmetro para exceção de Tes
	//devido a pedidos de ressarcimento (Tes 619) que não exigem que a quantidade no C6_QTDVEN seja "cheia"
	if Alltrim(cTes) $ cTESExc
		return .T.
	endif         
	
elseif AllTrim(Upper(FunName())) == "MATA415"
	nOpc     := 2
	cProduto := U_TransGen(TMP1->CK_PRODUTO )
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	DbSeek( xFilial("SA1") +M->C5_CLIENTE  )// alteracao feita em 29/01/09 chamado 000781*/
	if SA1->A1_SATIV1 == "000009"
		return .T.
	endIf
elseif AllTrim(Upper(FunName())) == "LIBERESTN" .OR. AllTrim(Upper(FunName())) == "LIBERAEST" .OR. AllTrim(Upper(FunName())) == "LIBESTX"
	nOpc     := 3
	cProduto := U_TransGen(ITE->PRODUTO)
	cTes     := ITE->TES
elseif AllTrim(Upper(FunName())) == "TMKA271"	
   nOpc     := 4
   nPosPro  := aScan( aHeader, { |x| AllTrim( x[2] ) == "UB_PRODUTO" } )
	nPosTes  := aScan( aHeader, { |x| AllTrim( x[2] ) == "UB_TES" } )   
   cProduto := U_TransGen( aCols[n,nPosPro] )
   cTes     := aCols[n,nPosTes]
endif

If !Empty(cTes)
	if cTes $ "514/515/516/506/535"
		return .T.
	endif
Endif

if Substr( cProduto,1,3 ) # "CTG/PI0"
	
	DbSelectArea("SB5")
	SB5->(DbSetOrder(1))
	
	lAchou := SB5->( DbSeek( xFilial("SB5") + cProduto ) )
	//nMult := SB5->B5_QTDEN / SB5->B5_QE2//?
	 nMult := SB5->B5_QTDFIM / SB5->B5_QE2  // CHAMADO 001523 FEITO EM 14/04/2010
	if nMult = 0
		nMult := 1
	endif
	
	if nOpc = 1  
		nResto := Mod( M->C6_QTDVEN, nMult )
	elseif nOpc = 2
		nResto := Mod( M->CK_QTDVEN, nMult )	    
	elseif nOpc = 3
		nResto := Mod( nQtd, nMult )
	elseif nOpc = 4  
		nResto := Mod( M->UB_QUANT, nMult )		
	endif
	
	if lAchou   
		if nResto != 0
		   if nOpc = 1  
		      
		      DbSelectArea("SA1")
              SA1->(DbSetOrder(1))
              DbSeek( xFilial("SA1") +M->C5_CLIENTE  )
              if SA1->A1_SATIV1 == "000009"
                 return .T.
              endIf	
              
              alert("Pedido/Faturamento quebrado detectado!")
		         if U_Senha2("13",1)[1]  //MARCELO , RENATO MAIA
		            //if U_Senha2("28",1)[1]
		            	RestArea(aArea)
		    	      return .T.
		         else
				      lOk := .F.
				      Alert( "A Quantidade Digitada NÃO é Múltipla da Quantidade da Embalagem: " + AllTrim(Str( SB5->B5_QE2 ) ) )
		         endIf
		      /*
		      //Posiciona na Tab. de Liberacao Pedido  
		      DbSelectArea("Z40")
              DbSetOrder(1)      
              If DbSeek(xFilial("Z40")+M->C5_NUM+'Q')  
		         If Z40->Z40_STATUS='B'	 // Bloqueado	       
		            Alert( "Pedido ainda não foi Liberado para Qtd Quebrada !!" )
		            lRet := U_Senha2("13",1)[1]
		            RestArea(aArea)
		            Return lRet
		         ElseIf  Z40->Z40_STATUS='J' // Liberado
		            Alert( "Pedido precisa de uma  Nova Liberação para Qtd Quebrada !!" )
		            lRet := U_Senha2("13",1)[1]
		            RestArea(aArea)
		            Return lRet   
		         ElseIf  Z40->Z40_STATUS='L' // Liberando...	
		         	RestArea(aArea)       
		            Return .T.
		         Endif   
		      Else		      
		      	 RecLock("Z40",.T.)
                 Z40->Z40_FILIAL:=xFilial("Z40")
                 Z40->Z40_PEDIDO:=M->C5_NUM
                 Z40->Z40_DTEMIS:=M->C5_EMISSAO
                 Z40->Z40_STATUS:='B'
                 Z40->Z40_TIPO:='Q'
                 Z40->(MsUnLock())
                 Alert( "Pedido precisa de Liberação para Qtd Quebrada !!" )
                 lRet := U_Senha2("13",1)[1]
                 RestArea(aArea)
                 Return lRet          	
		      Endif 
		      */
		   Elseif nOpc >= 2
		         alert("Pedido/Faturamento quebrado detectado!")
		         if U_Senha2("13",1)[1]  //MARCELO , RENATO MAIA
		            //if U_Senha2("28",1)[1]
		            	RestArea(aArea)
		    	      return .T.
		         else
				      lOk := .F.
				      Alert( "A Quantidade Digitada NÃO é Múltipla da Quantidade da Embalagem: " + AllTrim(Str( SB5->B5_QE2 ) ) )
		         endIf 
		   Endif 
		endif
	endif
endif

RestArea(aArea)
return lOk

//*************************************************************
// Valida a quantidade do produto no Orcamento
//*************************************************************

User function VldQtdOrc()

local lAchou := .F.
local lOk  := .T.
local nOpc
local nVal
local nPosPro
local nPosTes
local cTes := ""
local nMult
local nResto
local cProduto
Local nReg
Local nOrder
Local cEST := "" 
Local cTESExc := GETMV("RV_TESC6")


nOpc     := 2
nPosPro  := aScan( aHeader, { |x| AllTrim( x[2] ) == "CK_PRODUTO" } )
nPosTes  := aScan( aHeader, { |x| AllTrim( x[2] ) == "CK_TES" } )
cProduto := TMP1->CK_PRODUTO // aCols[n,nPosPro]
cTes     := TMP1->CK_TES // aCols[n,nPosTes]

//MsgAlert(TMP1->CK_PRODUTO)

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
DbSeek( xFilial("SA1") +M->CJ_CLIENTE + M->CJ_LOJA )// alteracao feita em 29/01/09 chamado 000781*/

If SA1->A1_SATIV1 == "000009"
	return .T.		
endIf
	
if Substr( cProduto,1,3 ) # "CTG/PI0"
	
	DbSelectArea("SB5")
	SB5->(DbSetOrder(1))
	
	lAchou := SB5->( DbSeek( xFilial("SB5") + cProduto ) )
	//nMult := SB5->B5_QTDEN / SB5->B5_QE2//?
	 nMult := SB5->B5_QTDFIM / SB5->B5_QE2  // CHAMADO 001523 FEITO EM 14/04/2010
	If nMult = 0
		nMult := 1
	endif
	
	If nOpc = 1  
		nResto := Mod( M->C6_QTDVEN, nMult )
	elseif nOpc = 2
		nResto := Mod( M->CK_QTDVEN, nMult )	    
	elseif nOpc = 3
		nResto := Mod( nQtd, nMult )
	elseif nOpc = 4  
		nResto := Mod( M->UB_QUANT, nMult )		
	endif
	
	If lAchou   
		If nResto != 0
			If nOpc >= 2
				lOk := .F.
				Alert( "A Quantidade Digitada NÃO é Múltipla da Quantidade da Embalagem: " + AllTrim(Str( SB5->B5_QE2 ) ) )
		   Endif 
		Endif
	Endif
Endif

Return lOk

