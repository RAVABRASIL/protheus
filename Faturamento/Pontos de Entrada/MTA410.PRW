//#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02  
#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

**********************
User Function MTA410()      // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
**********************
/*                                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTA410    ³ Autor ³ Mauricio Barros       ³ Data ³ 08/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ponto de entrada na confirmacao do pedido de venda          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Local lRET       := .T.
Local nPOSPRC    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
Local nPOSTOT    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_VALOR" } )
Local nPOSENTREG := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_ENTREG" } )
Local nPOSPROD   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSQUAN   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_QTDVEN" } )
Local nPOSCFOP   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_CF" } )
Local nPOSQLIB   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_QTDLIB" } )
Local nCONT      := 0
Local lValido    := .T.
Local lMinimo    := .F.
Local lCFOP      := .F.
Local lQlib      := .F.
Local nTotalPED  := 0
Local x          := 0
Local nPerc		  := 0
Local lSenha     := .F. //variável que indica se a senha digitada é OK para liberar uma validação
Local lfNewVLD	:= GetNewPar('RV_XNEWVLD',.T.)
Local lPedInter	:=  alltrim(upper(FunName())) == "FATC019" 

/*If SC5->C5_TIPO $ "N"
	Return .F.
endIf*/


//Comentei pois preciso que seja exetudado na rotina de Pedidos de Intenet
/*
If  alltrim(upper(FunName())) == "FATC019" //SE FOR O PROGRAMA PEDIDOS INTERNET, NÃO FAZ CRÍTICA
	//alert("internet")
	Return .T.
Endif 
*/
//SE FOR O PROGRAMA SOLIC. AMOSTRA, NÃO FAZ CRÍTICA
If  alltrim(upper(FunName())) == "ESTC005" .OR. M->C5_TIPO $ 'B/D'
	//alert("AMOSTRA")
	Return .T.
Endif                                                                         

//**********************************************************************
//se ambos tiverem falso nao aparece a tela e esta liberado.
//**********************************************************************
If M->C5_CLIENTE $ "006543/007005/031732/031733" //valida rava, total e nova
	Return .T.
EndIf

//////////////////////////////////////////////////////////////////////////////
//FR - 23/07/13 - Solicitado por Eurivan, implementar valor mínimo por Região 
//////////////////////////////////////////////////////////////////////////////

//If
	//lSenha := u_senha2("29",1)[1] //EURIVAN
	//If !lSenha
		//Return .F.   
	//Else
		//lMinimo := .T.
	//Endif
//endIf

////FR - 07/06/13
//ACUMULA O C6_VALOR P/ OBTER O TOTAL DO PEDIDO
For x := 1 To Len( aCOLS )
	If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada						
		nTotalPED +=	aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "C6_VALOR" }) ]
    EndIf
    
    If Empty(aCols[x][nPOSCFOP])
    	lCFOP      := .T.
    EndIf
    If aCols[x][nPOSQLIB] = 0 .AND.  M->C5_TIPO = "N" .and. RetCodUsr() <> '000000'
    	lQlib      := .T.
    EndIf
    
Next

If lCFOP
	ALERT('Está faltando validar o TES do(s) produto(s).')
	Return .F.
EndIf
If lQlib
	If msgyesno('Está faltando validar a Quantidade do(s) produto(s). Deseja confirmar?')
		Return .T.
	Else
		Return .F.
	Endif
EndIf

nCONT := 0
//FR - 07/06/13
//verifica se o valor passou do Autorizado (para vendas VD  / 6DD)
If M->C5_DESC1 > 0
	//nPerc	:= fLimXDD()
	nTotFat	:= fLimXDD()
	If nTotFat + nTotalPED  > SUPERGETMV("MV_LIMVD",,220000) 
		//ALERT('Ultrapassado o percentual de ' + Transform(SUPERGETMV("MV_LIMVD",,5),"999.99") + '% vendas. O valor atual está em ' + Transform(nPerc,"999.99") + '%' )
		ALERT('Ultrapassado o valor limite de R$ ' + Transform(SUPERGETMV("MV_LIMVD",,220000),"@R 9,999,999.99") + '. O valor atual está em R$' + Transform(nTotFat + nTotalPED,"@R 9,999,999.99") )
		Return .F. 
    Endif
    //Para XDD ou VD verifica se os produtos estão com o codigo generico - Gustavo Costa
	For x := 1 To Len( aCOLS )
		If Len( AllTrim( aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "C6_PRODUTO" }) ] )) < 8
			ALERT('Está faltando validar o código do(s) produto(s), ou retirar o percentual de desconto.')
			Return .F.
	    EndIf
	Next
Endif

If 'VD' $ M->C5_VEND1 
	//nPerc	:= fLimXDD()
	nTotFat	:= fLimXDD()
	If nTotFat + nTotalPED  > SUPERGETMV("MV_LIMVD",,220000) 
		//ALERT('Ultrapassado o percentual de ' + Transform(SUPERGETMV("MV_LIMVD",,5),"999.99") + '% vendas. O valor atual está em ' + Transform(nPerc,"999.99") + '%' )
		ALERT('Ultrapassado o valor limite de R$ ' + Transform(SUPERGETMV("MV_LIMVD",,220000),"@R 9,999,999.99") + '. O valor atual está em R$' + Transform(nTotFat + nTotalPED,"@R 9,999,999.99") )
		Return .F. 
    Endif
    //Para XDD ou VD verifica se os produtos estão com o codigo generico - Gustavo Costa
	For x := 1 To Len( aCOLS )
		If aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "C6_TES" }) ] <> '599'		
			ALERT('Está faltando verificar o TES do(s) produto(s), ou alterar o vendedor.')
			Return .F.		
	    EndIf
	Next
Endif	         
///FR - 07/06/13

//Flavia Rocha - ch 002203 - regra para validar se o cliente tem pendência no Financeiro, não deixará incluir
If Inclui 
   
   If SC5->C5_TIPO $ "N"
		//chamado 002203 - Flavia Rocha
	   //lValido := U_RegraPAGO(M->C5_CLIENTE,M->C5_LOJACLI)       //VERFICA SE EXISTE NFS NÃO PAGAS HÁ MAIS DE 120 DIAS
	   //desabilitado por Flavia Rocha em 11/08/11 por solicitação de Eurivan
	   if !lValido      
	      lRet := .F.
	      SA1->(DBSETORDER(1))
	      SA1->(Dbseek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI ))
	      MsgBox("O Cliente: " + M->C5_CLIENTE + '/' + M->C5_LOJACLI + ' - ' + SA1->A1_NREDUZ + " Possui Pendências Financeiras." )	      
	   endif
   Endif

Endif

//Regra de validacao dos pedidos. Incluido por Eurivan em 12/01/2008
if Inclui .OR. Altera
   if !U_RegraPed()       //VERFICA SE EXISTE BLOQUEIO NO CLIENTE ( CPO: A1_BLQXDD)
      return .F.
   endif
endif

For nCONT := 1 To Len( aCOLS )
    If ! aCols[ nCONT, Len( aCols[ nCONT ] ) ] .and. aCols[ nCONT ][ nPOSPRC ] <= 0
       lRET := .F.
       Exit
    EndIf
Next
If ! lRET
   MsgBox( "Preco de lista do(s) produto(s) nao foi(foram) informado(s)", "INFO", "STOP" )
Endif

If M->C5_COMIS1 <= 0
	
	If  alltrim(upper(FunName())) == "ESTC005"  //M->C5_CLIENTE='031248' // MIKKIT
	   M->C5_COMIS1:=0
	   lRET := .T.
	Else
	   If ! MsgBox( OemToAnsi( "O campo comissao esta informado com o valor  " + Alltrim( Trans( M->C5_COMIS1, '@E 999.99' ) ) +;
								 "  confirma inclusao ?" ), "Escolha", "YESNO" )
			lRET := .F.
		EndIf
    Endif
EndIf


//Tornar obrigatorio o campo Num.Empenho quando o pedido for associado a um Pre-Pedido.
if Type("cPrePed") == "C" 
   if !Empty(cPrePed) .and. Empty(M->C5_NUMEMP)
      MsgBox( "Como este pedido refere-se a um processo Licitatório, deverá ser informado o número do EMPENHO.", "INFO", "STOP" )         
      lRET := .F.
   endif
   // Chamado 001489
   if !Empty(cPrePed)
      M->C5_OBSFIN:="PEDIDO LICITACAO / "+ M->C5_OBSFIN
   Endif
endif

//Incluido por Eurivan em 08/04/08
//Atualizo a data da ultima alteracao na condicao de pagamento
if lRet
   if Type("lBox") == "L" 
      if lBox
         DbSelectArea("SA1")
         DbSetORder(1)
         SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE))
         RecLock("SA1",.F.)
         SA1->A1_DTCOND := M->C5_ENTREG
         SA1->(MsUnlock())
      endif                    	
   endif

	//Por solicitação da implantação do PCP - Flávia Rocha
	//Gravar nos itens do pedido de venda, a data registrada no C5_ENTREG
	For nLoop := 1 To Len(aCols)	
		aCols[nLoop,nPOSENTREG]	:= M->C5_ENTREG	
	Next nLoop

endif


 DbSelectArea("SA1")
 DbSetORder(1)
 if SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.F.))
    If ALLTRIM(SA1->A1_EST)='MG' //Pedido do Estado de Minas Gerais
       alert('Pedido do Estado de Minas Gerais, não liberar mercadoria após pagamento do diferencial de alíquota.')
    EndIF
    If ( ALLTRIM(SA1->A1_SATIV1)='000009'  .AND. empty(M->C5_INFBANC))   // Informacao de Orgao Publico 
       alert('Favor informar Dados Bancarios.')
       lRET:=.F. 
    EndIF
 EndIf      
            
// justificativa comissao
if Type("_cJustCom") == "C" 
   if !empty(_cJustCom)
      M->C5_JUSTCOM:=_cJustCom
   endif
endif   
 
// Solicitacao de Anostra 
/*
if Type("cSolAmo") == "C" 
  if INCLUI
	  if !empty(cSolAmo)
		 DbSelectArea("Z55")  
		 DbSetOrder(2)
		 for _nI := 1 To Len(aCols)
		   if Z55->(DbSeek(xFilial("Z55")+cSolAmo+aCols[_nI,2]))
		      RecLock("Z55",.F.)
		      Z55->Z55_DTBAIX:=DDATABASE
		      Z55->Z55_NOMBAI:=Soli( substr(cUsuario,7,15) )
		      Z55->Z55_STATUS:='B'
		      Z55->Z55_QTDENT:= aCols[_nI,5] 
		      Z55->Z55_PEDIDO:= M->C5_NUM
		      Z55->( msUnlock() )
		   endif
		 next
	  Endif
  Endif
EndIf
*/

If  Altera
    CrossDoc()
endif


if !bonifica(M->C5_NUM)
    Return .F.
endif

if !Margem()
    Return .F.
endif

If !lValido
	lRet := .F.
Endif

//PlanFin()

If alltrim(M->C5_TIPO) $ "N"
	For _Y := 1 To Len(aCols)
		IF ALLTRIM(posicione('SB1', 1, xFilial('SB1')+aCols[_Y,nPOSPROD], 'B1_TIPO'))!='AP'   .and. ALLTRIM(M->C5_VEND1)=SuperGetMV("RV_VENAPA", ,"000001")  //.and. ALLTRIM(M->C5_VEND1)='0322'
			ALERT("Todos os Itens Devem ser Apara para esse vendedor "+ alltrim(M->C5_VEND1))
			lRet := .F.
		elseif ALLTRIM(posicione('SB1', 1, xFilial('SB1')+aCols[_Y,nPOSPROD], 'B1_TIPO'))='AP' .and. ALLTRIM(M->C5_VEND1)!=SuperGetMV("RV_VENAPA", ,"000001")  //.and. ALLTRIM(M->C5_VEND1)!='0322'
			ALERT("Esse vendedor "+ alltrim(M->C5_VEND1)+" Nao Vende Apara." )
			lRet := .F.
		
		ENDIF
	Next
EndIF

//Execucao da rotina da Campanha de Precos Versus Volume - Eurivan 17/06/16
/*
if lRet .and. SuperGetMV("RV_CAMPV",,.T.)
   U_CFATC02(M->C5_CLIENTE,M->C5_LOJACLI)
endif   
*/


//Apagar do cadastro de prospect, caso o sistema encontre um com o CNPJ do cliente
DbSelectArea("SA1")
DbSetOrder(1)
SA1->( DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI) )

DbSelectArea("SUS")
DbSetOrder(5) //US_FILIAL+US_CGC
if SUS->(DbSeek(xFilial("SUS")+SA1->A1_CGC))
	Reclock("SUS",.F.)
	SUS->(dbDelete())
	MsUnlock()
endif

//Execucao da rotina da Campanha de Precos Versus Volume - Eurivan 17/06/16
//if lRet .and. SuperGetMV("RV_CAMPV",,.T.)
   //U_CFATC03(M->C5_CLIENTE,M->C5_LOJACLI)
//endif   
If M->C5_TIPO == "N"

	lMinimo := minimo()//testa se pedido atingiu o valor mínimo para a sua REGIÃO
	
	If !lRet .And. lMinimo
		lRet := .T.
	EndIf

EndIf
/////
//Valida desconto padrao do cliente e venda abaixo do custo da linha
/////

//DEMONSTRA ESTOQUE DO PEDIDO.
Processa({ || fSldProd()},"Aguarde","Analisando estoque pedido...")

if lRet .AND. M->C5_TIPO $ "N" .AND. lfNewVLD .AND. !lPedInter //.AND. lMinimo

	lRet := fNewVLD(lMinimo)

EndIf


Return lRet


************************
Static Function minimo()
************************

Local nReg
Local nOrder
Local cEST   := ""
Local nIdx   := nTotal := nSufr1 := nSufr2 := 0
Local nInd1  := nInd2  := nInd3  := 0
Local lOk := .F.
//Local nPedMINSC := GETMV("RV_PDMINSC") //sacos  1.600,00
//Local nPedMINCX := GETMV("RV_PDMINCX") //CAIXAS 1.600,00
//Local nPedMINS:= GETMV("RV_PEDMINS") //sacolas 1.000,00

//////////////////////////////////////////////////////////////////////////////
//FR - 23/07/13 - Solicitado por Eurivan, implementar valor mínimo por Região 
//////////////////////////////////////////////////////////////////////////////

//Local nPedMINE := GETMV("RV_VALMINE") //VALOR MÍNIMO REGIÃO NORDESTE
//Local nPedMINO := GETMV("RV_VALMINO") //VALOR MÍNIMO REGIÃO NORTE
//Local nPedMICO := GETMV("RV_VALMICO") //VALOR MÍNIMO REGIÃO CENTRO-OESTE
//Local nPedMISU := GETMV("RV_VALMISU") //VALOR MÍNIMO REGIÃO SUDESTE
//Local nPedMISD := GETMV("RV_VALMISD") //VALOR MÍNIMO REGIÃO SUL
Local nPedMIN := 0 //VALOR MÍNIMO PARA PEDIDOS QUE IRÁ VARIAR DE ACORDO COM A REGIÃO
Local cRegiao  := ""
Local cNomeReg := ""
Local lSacola := .F.  
Local lLIBMIN := .F. //chama a função LIBMIN que é uma "2a. chance" de ver se mesmo abaixo do valor mínimo, o sistema liberará

if M->C5_TIPO $ 'B/D'
   Return .F.
endif

// pedido para grande joao pessoa
 DbSelectArea("SA1")
 DbSetORder(1)
 if SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.F.))
                               // JP  /BAYEX/S.RITA/CABEDELO
    If alltrim(SA1->A1_COD_MUN)$'07507/01807/13703/03209'
       Return .F.
    Endif           
    If SA1->A1_EST $ "AC,/AM/AP/PA/RO/RR/TO"
    	cRegiao := 'NO'  //NORTE
    	nPedMIN := GETMV("RV_VALMINO") 
    	cNomeReg:= "NORTE"
    ElseIf SA1->A1_EST $ "/MA/PI/CE/RN/PB/PE/AL/BA/SE"
    	cRegiao := 'NE'         //NORDESTE
    	nPedMIN := GETMV("RV_VALMINE")
	   	cNomeReg:= "NORDESTE"
	ElseIf SA1->A1_EST $ "GO/MT/MS/DF"
		cRegiao := 'CO'                   //CENTRO-OESTE
		nPedMIN := GETMV("RV_VALMICO")
    	cNomeReg:= "CENTRO-OESTE"
	ElseIf SA1->A1_EST $ "MG/ES/RJ/SP"
		cRegiao := 'SD'               //SUDESTE
		nPedMIN := GETMV("RV_VALMISD")
    	cNomeReg:= "SUDESTE"
	ElseIf SA1->A1_EST $ "RS/PR/SC"
		cRegiao := "SU"	            //SUL
		nPedMIN := GETMV("RV_VALMISU")
    	cNomeReg:= "SUL"
	Endif
 endif
//
nInd1    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_QTDVEN" } )
nInd2    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
nInd3    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES"    } )
nPOSLOC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_LOCAL"  } )
nPOSPROD := aScan( aHeader, { |x| Alltrim( x[2] ) == "C6_PRODUTO"} )
nIndPRC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRCVEN" } )
nPosDel  := Len( aHeader ) + 1

if testaTes(nInd3)
	return .F.
endIf

//VERIFICAR SE FOR SACOLA, O PEDIDO MÍNIMO MUDARÁ
_t := 0
for _t := 1 to len(aCols)
	if Alltrim(aCols[_t][nPOSPROD]) $ "GUB"
		lSacola := .T.
	endIf
next

_t := 0
for _t:=1 to len(aCols)
    if !aCols[_t,nPosDel]
    	If aCols[_t,nInd2] = 0
			nTotal +=aCols[_t,nInd1]*aCols[_t,nIndPRC]    		
		Else
	       	nTotal +=aCols[_t,nInd1]*aCols[_t,nInd2]
	 	Endif
    endif
    /*  //O IPI não Deverá ser considerado na soma do TOTAL P/ verificação de valor mínimo
    IF ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_IPI' ))='S'
       nTotal += nTotal * 1.15
    endif
    */
    /*
    if ! empty( posicione('SA1', 1, xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJAENT, 'A1_SUFRAMA' ) )
        
        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_ICM'))='S' // CALCULA ICM 
           if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJAENT, 'A1_CALCSUF' )) $ 'S/I' 
              nSufr1 := nTotal * 0.12                      
           Endif   
        endif 
                
        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) != '4' // CALCULA PIS/COFINS 
	        if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJAENT, 'A1_CALCSUF' )) $ 'S'       
	           if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) $ '3' // AMBOS
	               nSufr2 := nTotal * 0.0925                    
	           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) $ '1' // PIS	   
	               nSufr2 := nTotal * 0.0165                    	           
	           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) $ '2' // COFINS
	               nSufr2 := nTotal * 0.076                    	           
	           ENDIF
	        ENDIF        
	    Endif
        
        nTotal -= (nSufr1+nSufr2)    
        
    endIf
    */
Next
_t:=1
    if ! empty( posicione('SA1', 1, xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJAENT, 'A1_SUFRAMA' ) )
        
        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_ICM'))='S' // CALCULA ICM 
           if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJAENT, 'A1_CALCSUF' )) $ 'S/I' 
              nSufr1 := nTotal * 0.12                      
           Endif   
        endif 
                
        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) != '4' // CALCULA PIS/COFINS 
	        if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJAENT, 'A1_CALCSUF' )) $ 'S'       
	           if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) $ '3' // AMBOS
	               nSufr2 := nTotal * 0.0925                    
	           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) $ '1' // PIS	   
	               nSufr2 := nTotal * 0.0165                    	           
	           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + aCols[_t,nInd3] , 'F4_PISCOF')) $ '2' // COFINS
	               nSufr2 := nTotal * 0.076                    	           
	           ENDIF
	        ENDIF        
	    Endif
        
        nTotal -= (nSufr1+nSufr2)    
        
    endIf

/*
If !lSacola
	If ALLTRIM(xfilial('SC5'))='01' // SACO
		if nTotal < nPedMINSC  //< 1600 
		   lOk := .F.
		   //msgAlert("O pedido não atingiu o valor mínimo de: R$ 1.000,00" )
		   msgAlert("SACOS: O Pedido Totaliza: " + Transform( nTotal , "@E 999,999,999.99" ) + " e Não Atingiu o Valor Mínimo de: R$ " + Transform( nPedMINSC , "@E 999,999,999.99") )
		   Return LIBMIN()	   
		endif   
	ELSEIf ALLTRIM(xfilial('SC5'))='03' // CAIXA	
		if nTotal < nPedMINCX 	   //<1600
		   lOk := .F.
		   //msgAlert("O pedido não atingiu o valor mínimo de: R$ 500,00" )
		   msgAlert("CAIXAS: O Pedido Totaliza: " + Transform( nTotal , "@E 999,999,999.99" ) + " e Não Atingiu o Valor Mínimo de: R$ " + Transform(nPedMINCX , "@E 999,999,999.99") )
		   Return LIBMIN()	   
		endif   
	ENDIF
Else
	if nTotal < nPedMINS  //< 1000
	   lOk := .F.
	   //msgAlert("O pedido não atingiu o valor mínimo de: R$ 1.000,00" )
	   msgAlert("SACOLA: O Pedido Totaliza: " + Transform( nTotal , "@E 999,999,999.99" ) + " e Não Atingiu o Valor Mínimo de: R$ " + Transform( nPedMINS , "@E 999,999,999.99")  )
	   Return LIBMIN()	   
	endif  
Endif 
*/

//NOVA SISTEMÁTICA DE PEDIDO MÍNIMO POR REGIÃO
if nTotal < nPedMIN
   //lOk := .F.
   
   //Return LIBMIN()	   
	if alltrim(M->C5_TRANSP) $ "024"
	   return .F.
	endIf
	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	DbSeek( xFilial("SA1") +M->C5_CLIENTE  )// alteracao feita em 07/04/09 chamado 001053*/
	if SA1->A1_SATIV1 == "000009"
	   return .F.
	endIf	

   //lLIBMIN := LIBMIN()
   //If !lLIBMIN
   		msgAlert( " O Pedido Totaliza R$:" + Transform( nTotal , "@E 999,999,999.99" ) + CHR(13) + CHR(10) ;
   		+ " Não Atingiu o Valor Mínimo de: R$ " + Transform( nPedMIN , "@E 999,999,999.99") + " Para a Região: " + cNomeReg ) //+ CHR(13) + CHR(10);
   		//+ " , Somente com a Senha Diretor Poderá Ser Liberado..." )
   		lOk := .T.
   //Else
   //		lOk := .F.
   //Endif
   
endif   

return lOk
 

***************
Static Function testaTes(nId3)
***************

Local nCount :=  0
Local lRet   := .T.

for _t := 1 to len(aCols)
	If !(aCols[_t,Len(aHeader)+1]) //se a linha do acols não estiver deletada						
		if aCols[_t][nId3] $ GetNewPar("MV_XTESBN","514/516/561/522/830")
			nCount++
		endIf
	Endif
next

if nCount < len(aCols)
	lRet := .F.
endIf

Return lRet    


***************
     
Static Function LIBMIN()

***************
Local lRet

if alltrim(M->C5_TRANSP) $ "024"
   return .T.
endIf

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
DbSeek( xFilial("SA1") +M->C5_CLIENTE  )// alteracao feita em 07/04/09 chamado 001053*/
if SA1->A1_SATIV1 == "000009"
   return .T.
endIf	

//lRet := U_senha2( "15", 4 )[ 1 ]


//Posiciona na Tab. de Liberacao Pedido  
DbSelectArea("Z40")
DbSetOrder(1)      
If DbSeek(xFilial("Z40")+M->C5_NUM+'V')  
   If Z40->Z40_STATUS='B'	 // Bloqueado	       
      Alert( "Pedido ainda não foi Liberado para o Valor Mínimo !!" )
      Return .F.
   ElseIf  Z40->Z40_STATUS='J' // Liberado
	  Alert( "Pedido precisa de uma  Nova Liberação para o Valor Mínimo !!" )
	  Return .F.   
   ElseIf  Z40->Z40_STATUS='L' // Liberando...	       
      RecLock("Z40",.F.) 
	  Z40->Z40_STATUS:='J'	// finaliza a liberacao e muda o status para liberado	       
	  Z40->(MsUnLock())
      Return .T.
   Endif      
Else
   RecLock("Z40",.T.)
   Z40->Z40_FILIAL:=xFilial("Z40")
   Z40->Z40_PEDIDO:=M->C5_NUM
   Z40->Z40_DTEMIS:=M->C5_EMISSAO
   Z40->Z40_STATUS:='B'
   Z40->Z40_TIPO:='V'
   Z40->(MsUnLock())
   Alert( "Pedido precisa de Liberação para o Valor Mínimo !!" )
   Return .F.
Endif


Return .F.



***************

Static Function getReg(cUF)

***************

Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"

if cUF $ cRGNO
	return "NO"
elseIf cUF $ cRGNE
	return "NE"
elseIf cUF $ cRGCE
	return "CE"
elseIf cUF $ cRGSD
	return "SD"	
elseIf cUF $ cRGSL
	return "SL"				
endIf	
   
Return 

***************

Static Function getRegE(cUF)

***************

if cUF == "NO"
	return "NORTE"
elseIf cUF == "NE"
	return "NORDESTE"
elseIf cUF == "CE"
	return "CENTRO-OESTE"
elseIf cUF == "SD"
	return "SUDESTE"	
elseIf cUF == "SL"
	return "SUL"				  
endIf	

Return

***************

Static Function Soli( cSoli )

***************

local ccod:=''

PswOrder(2)
If PswSeek( cSoli, .T. )
   aUsuarios  := PSWRET() 					
   ccod := Alltrim(aUsuarios[1][1])     	// usuário
Endif 

return ccod

***************

Static Function CrossDoc()

***************
Local cNumPed:=M->C5_NUM 
Local lEmail:=.F.

DbSelectArea("SC6")               				
DbSetOrder(1)      
If DbSeek(xFilial("SC6")+cNumPed)  
   Do While SC6->(!Eof()) .AND. SC6->C6_NUM==cNumPed
      if SC6->C6_CROSSDO='S'
	     RecLock( "SC6", .F. )
         SC6->C6_CROSSDO:=" "
         SC6->C6_QTDRESE:=0
         MsUnLock()
	     lEmail:=.T.
	  endif	       
      SC6->(DbSkip())   
   Enddo
Endif

// email
IF lEmail
   cMailTo  := "pcp@ravaembalagens.com.br;faturamento@ravaembalagens.com.br"
   cAssun   :="Cross-Docking Pedido "+alltrim(cNumPed)+" Alterado"
   cCorpo := "O Pedido "+alltrim(cNumPed)+" foi alterado,logo a Reserva Cross-Docking sera Cancelada"
   U_EnviaMail(cMailTo,cAssun,cCorpo)      
ENDIF
//

Return

***************

Static Function bonifica(_PedBon)

***************
local _nPosTes 	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES"    } )
local _nPosQ2 	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_UNSVEN"    } )
Local lOk   	:= .F.
Local nC5Reg 	:= SC5->( Recno() )
Local nTotKGPai := 0
Local nTotKGKid := 0
Local nDifPed	:= 0
Local nLimite	:= GetNewPar("MV_XLIMPBO",0)

for _X := 1 to len(aCols)
	if aCols[_X][_nPosTes] $ GetNewPar("MV_XTESBN","514/561/550")
		lOk:=.T.
	endIf
next

if  lOk .and. EMPTY(M->C5_NUMPAI)
    ALERT("Pedido de Bonificacao detectado, favor preencher o campo Pedido Pai.")
    Return .F.
ELSEIF lOk .and. !EMPTY(M->C5_NUMPAI)
	DbSelectArea("SC5")
	DbSetORder(1)
	if SC5->(DbSeek(xFilial("SC5")+M->C5_NUMPAI))
	   RecLock("SC5",.F.)
	   SC5->C5_NUMFILH :=_PedBon
	   SC5->(MsUnlock())
       //
       SC5->( dbGoto( nC5Reg ) )
       //
    else
       alert('Pedido Pai nao encontrado')
       Return .F.
    endif
ELSEIF !lOk .and. !EMPTY(M->C5_NUMPAI)
       alert('Pedido Nao e de bonificacao, nao precisa do Pedido Pai.')
       Return .F.
endIf

//**************************************************
//pede senha para liberar a inserçao de bonificação
//**************************************************
if  lOk
	
	nTotKGPai := fPercBon(M->C5_NUMPAI)
	
	for _z := 1 to len(aCols)
		
		nTotKGKid +=  aCols[_z][_nPosQ2]
	
	next
	
	nDifPed	:= ( nTotKGKid/nTotKGPai ) * 100
	
	If nDifPed > nLimite
		
		MsgAlert("Este pedido representa " + Transform( nDifPed , "@E 999.99") + "% do pedido pai." + CHR(13) + CHR(10) +;
		"Solicitar senha da Diretoria !")
		
		if !U_Senha2("07",1)[1]
	       Return .F.
		EndIf
		
	EndIf
	
EndIf

Return .T.  



***************

Static Function  fPercBon(cNumPedPai)

***************

local cQry:=''
Local nRet:=0

cQry:="SELECT SUM(C6_UNSVEN) VALOR FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK)"
cQry+=" WHERE C6_NUM = '" + cNumPedPai + "'"
cQry+=" AND D_E_L_E_T_ <> '*' "
cQry+=" AND C6_FILIAL = '" + xFilial("SC6") + "' "

TCQUERY cQry NEW ALIAS  "TPB"

nRet:= TPB->VALOR  

TPB->(dbclosearea())

Return nRet


***************

Static Function  Margem()

***************


Return .T.



**************

Static Function fVALORX()

***************
local cQry:=''
Local nRet:=0

cQry:="SELECT VALOR=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN) "
cQry+="FROM  "+retSqlName("SD2")+" SD2 WITH (NOLOCK),  "+retSqlName("SB1")+" SB1 WITH (NOLOCK),  "+retSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQry+="WHERE SUBSTRING(D2_EMISSAO,1,6) ='"+SUBSTR(DTOS(DDATABASE),1,6)+"' "
cQry+="AND D2_SERIE = '' "
cQry+="AND D2_TIPO = 'N' "
cQry+="AND D2_TP != 'AP'  "
cQry+="AND RTRIM(D2_CF) IN ('511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949','6949','5922','6922','5116','6116' ) "
cQry+="AND D2_TES NOT IN ('540','516') "
cQry+="AND SUBSTRING(D2_COD,1,1)!='M'   "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQry+="AND F2_DUPL <> ' ' "
cQry+="AND SF2.D_E_L_E_T_ = ''  "
TCQUERY cQry NEW ALIAS  "TMPM"
/*
//ESTE NÃO TEM COMO FAZER POIS O PEDIDO AINDA SERÁ GRAVADO
cQry:=''
cQry:="SELECT SUM(C6_VALOR) VALOR FROM  "+retSqlName("SC6")+" SC6 "
cQry+="WHERE  C6_FILIAL='"+XFILIAL('SC6')+"' "
cQry+="AND C6_NUM='"+cNum+"'"
cQry+="AND SC6.D_E_L_E_T_<>'*' "
*/
MemoWrite("C:\TEMP\FVALORX.SQL",cQry)
//TCQUERY cQry NEW ALIAS  "TMPN"

nRet:= TMPM->VALOR   //+TMPN->VALOR ESTE NÃO TEM COMO FAZER POIS O PEDIDO AINDA SERÁ GRAVADO

TMPM->(dbclosearea())
//TMPN->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fLimXDD  º Autor ³ Gustavo Costa     º Data ³  14/08/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para calcular o % do XDD           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fLimXDD()

local cQry		:= ''
Local nRet		:= 0
Local nFora	:= 0
Local nTotal	:= 0

cQry:=" SELECT SUM(E1_VALOR) FORA FROM  " + RetSqlName("SE1") + " WITH (NOLOCK) "
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND E1_FILIAL = '" + xFilial("SE1") + "'"
cQry+=" AND E1_EMISSAO >= '" + DtoS(FirstDay(dDataBase)) + "'" 
cQry+=" AND E1_PREFIXO = ''"
cQry+=" AND E1_TIPO = 'NF' "

TCQUERY cQry NEW ALIAS  "TMPM"

dbSelectArea("TMPM")
TMPM->(dbGoTop())

nFora := TMPM->FORA

TMPM->(dbclosearea())

cQry:=" SELECT SUM(D2_TOTAL) VALOR FROM " + RetSqlName("SD2") + " WITH (NOLOCK) "
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND D2_EMISSAO >= '" + DtoS(FirstDay(dDataBase)) + "'"
cQry+=" AND D2_TIPO = 'N' "
cQry+=" AND D2_FILIAL = '" + xFilial("SD2") + "'"
cQry+=" AND substring(D2_CF,1,2) IN ('51','61') "
cQry+=" AND D2_CF NOT IN ('5151','5152') "

TCQUERY cQry NEW ALIAS  "TMPM"

dbSelectArea("TMPM")
TMPM->(dbGoTop())

nTotal := TMPM->VALOR

TMPM->(dbclosearea())

//se não tiver faturamento, considera 100% já utilizado
If nFora = 0 .OR. nTotal = 0
	nRet	:= 100
Else
	nRet	:= ( nFora / nTotal ) * 100
EndIf

Return nFora


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fNewVLD ³ Autor :Gustavo Costa           ³ Data :15/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Valida desconto padrao cliente x produto
±±³            Valida preço medio da linha do pedido com o custo.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fNewVLD(lMinimo)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nPOSPROD   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSDESC   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PDESC" } )
Local nPOSNPRO   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_DESCRI" } )
Local nPOS2VEN   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_UNSVEN" } )
Local nPOSVAL    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_VALOR" } )
Local nPOSQTD    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_QTDVEN" } )
Local nPOSPUNI   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
Local nPOSCOM    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_COMIS1" } )
Local aProdDesc		:= {}
Local aLinhaP		:= {}
Local aCusto		:= {}
Local nDescPad		:= 0
Local lContinua		:= .F.
Local cSetor		:= ""
Local cNomeSetor	:= ""
Local lDesc			:= .F.
Local lQtdMin		:= .F.
Local lCusto		:= .F.
Local lPM			:= .F.
Local lLimXDD		:= .F.
Local lLimSN		:= .F.
Local lLibera		:= .F.
Local lInativo		:= .F.
Local lPercFrt		:= .F.
Local lTransf		:= .F.
Local nPM			:= 0
Local nPMAnt		:= 0
Local nFrtEx		:= 0
Local cTexto		:= ""
Local nUltPrc		:= 0
Local nAumento		:= SuperGetMV("MV_XAUMENT",,1.06)
Local nDescImed		:= SuperGetMV("MV_XDESCIM",,15)
Local nDescGeral	:= SuperGetMV("MV_XDESCGR",,20)
Local lUltPco		:= .F.
Local nQtdMin		:= 0
Local cTexQtdM		:= ""
Local cComDobro		:= ""
Local nComisPrd		:= 0
Local nTotalPV		:= 0
Local nFatSM		:= 0
Local cProdutos		:= ""
Local cProdAux		:= ""
Local nPesoPed		:= 0
Local nValFrete		:= 0
Local nPercFrete	:= 0
Local cAux			:= ""
Local cTipoTabela	:= ""

Private lChk1   		:= .F.
Private coTbl1
Private coTbl2

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oBrw1","oPanel1","oPanel2","oCBox1","oBrw2","oPanel3","oSay1","oSay2","oSay3","oGet3","oBtn1","oMGet1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )

//Cria as tabelas
oTbl2()
oTbl1()

For _i := 1 To Len(aCols)

	cSetor	:= POSICIONE("SB1",1, xFilial("SB1") + aCols[_i][nPOSPROD], "B1_SETOR")
	cUF		:= POSICIONE("SA1",1, xFilial("SA1") + M->C5_CLIENT + M->C5_LOJACLI, "A1_EST")
	//cComDobro	:= Alltrim(POSICIONE("SA1",1, xFilial("SA1") + M->C5_CLIENT + M->C5_LOJACLI, "A1_ORIGEM"))
	nQtdMin	:= POSICIONE("SB1",1, xFilial("SB1") + aCols[_i][nPOSPROD], "B1_LE")
	nComisPrd	:= POSICIONE("SB1",1, xFilial("SB1") + aCols[_i][nPOSPROD], "B1_COMIS")
	aCusto	:= fValCusto(cSetor, cUF)
	nCusto	:= aCusto[1]
	nMargem	:= 1 + (aCusto[2]/100)
	nDescPad:= fDecPad(M->C5_CLIENTE, M->C5_LOJACLI, Alltrim(aCols[_i][nPOSPROD]))
	nUltPrc := fUltPco(M->C5_CLIENTE, M->C5_LOJACLI, Alltrim(aCols[_i][nPOSPROD]), .F.)		//ultimo preco
	nUltPrcAum := fUltPco(M->C5_CLIENTE, M->C5_LOJACLI, Alltrim(aCols[_i][nPOSPROD]), .T.) 	//ultimo preco antes do aumento
	cTipoTabela := POSICIONE("Z36",1, xFilial("Z36") + aCols[_i][nPOSPROD] + cUF, "Z36_TIPO")
	//If aCols[_i][nPOSDESC] > nDescPad
		
		RecLock("XVL", .T.)
		XVL->COD		:= Alltrim(aCols[_i][nPOSPROD])
		XVL->PROD		:= Alltrim(aCols[_i][nPOSNPRO])
		XVL->DESC		:= aCols[_i][nPOSDESC]
		XVL->ULTIMO		:= nDescPad
		XVL->DIF		:= aCols[_i][nPOSDESC] - nDescPad
		XVL->QTDKG		:= aCols[_i][nPOS2VEN]
		XVL->VALKG		:= (aCols[_i][nPOSQTD] * aCols[_i][nPOSPUNI]) / aCols[_i][nPOS2VEN]
		XVL->CUSTO		:= nCusto
		XVL->MARGEM		:= nCusto * nMargem
		XVL->PESO		:= aCols[_i][nPOS2VEN]/aCols[_i][nPOSQTD]
		XVL->ULTPC		:= nUltPrc
		XVL->IDEAL		:= IIF((nUltPrcAum * nAumento) > aCols[_i][nPOSPUNI],(nUltPrcAum * nAumento),nUltPrc)
		XVL->(MsUnLock())
		

		iF (aCols[_i][nPOSQTD] * aCols[_i][nPOSPUNI]) / aCols[_i][nPOS2VEN] < nCusto
			lCusto	:= .T.
		EndIf
		/*
		If (nDescPad - aCols[_i][nPOSDESC] ) < 0 .and. !lDesc
			lDesc	:= .T.
		EndIf
		*/
		/*
		If aCols[_i][nPOSDESC] > IIF (cTipoTabela = "I", nDescImed, nDescGeral	) .and. !lDesc
			lDesc	:= .T.
		EndIf
		*/
		
		/*
		If Mod(aCols[_i][nPOSQTD], nQtdMin) <> 0 .and. nQtdMin > 1
			lQtdMin	:= .T.
			cTexQtdM	:= cTexQtdM + " COD: " + Alltrim(aCols[_i][nPOSPROD]) + " - LE = " + Transform(nQtdMin,"@E 999" ) 
		EndIf
		*/
		/*
		If round((nUltPrcAum * nAumento),2) > aCols[_i][nPOSPUNI] .and. !lUltPco
			lUltPco	:= .T.
		EndIf
		*/
		/*
		If round(nUltPrc,2) > aCols[_i][nPOSPUNI] .and. !lUltPco
			lUltPco	:= .T.
		EndIf
		*/
		//Regra para comissao em dobro Jan e Fev 2018.
		//If cComDobro = "X"
		//	aCols[_i][nPOSCOM] := nComisPrd * 2
		//EndIf
		
		
	//EndIf

    If !Empty(cProdutos)
    	cProdutos := cProdutos + ","
    EndIf
    cProdutos := cProdutos + "'" + AllTrim(U_transgen(aCols[_i][nPOSPROD])) + "'"
    
    nPesoPed := nPesoPed + (aCols[_i][nPOSQTD] * posicione('SB1', 1, xFilial('SB1')+aCols[_i][nPOSPROD], 'B1_PESO'))
    
Next


For _i := 1 To Len(aCols)

	cSetor	:= POSICIONE("SB1",1, xFilial("SB1") + aCols[_i][nPOSPROD], "B1_SETOR")
	cUF		:= POSICIONE("SA1",1, xFilial("SA1") + M->C5_CLIENT + M->C5_LOJACLI, "A1_EST")
	aCusto	:= fValCusto(cSetor, cUF)
	nCusto	:= aCusto[1]
	nMargem	:= 1 + (aCusto[2]/100)
	
    DO CASE
    	CASE cSetor $ GetNewPar('RV_SETINST','48/01/18/02/99/03')
    		cNomeSetor := "INSTITUCIONAL"
    	CASE cSetor $ GetNewPar('RV_SETINSR','57')
    		cNomeSetor := "INS. RECICLADO"
    	CASE cSetor $ GetNewPar('RV_SETINSC','29')
    		cNomeSetor := "INS. SACOLA"
    	CASE cSetor $ GetNewPar('RV_SETINSC','58')
    		cNomeSetor := "INS. TRANSPARENTE"
    	CASE cSetor $ GetNewPar('RV_SETDOMR','24/25/33')
    		cNomeSetor := "DOMESTICA RL"
        CASE cSetor $ GetNewPar('RV_SETDOMP','23/26/27/28/31/32')
        	cNomeSetor := "DOMESTICA PC"
        CASE cSetor $ GetNewPar('RV_SETHOSH','05/37/40/56')
        	cNomeSetor := "HOSP. HAMPER"
        CASE cSetor $ GetNewPar('RV_SETHOSI','08/09/10/11/12/13/14/30/34/35/36/41/55')
        	cNomeSetor := "HOSP. INFEC."
        CASE cSetor $ GetNewPar('RV_SETHOSO','06/54/98')
        	cNomeSetor := "HOSP. OBITO"
        CASE cSetor $ GetNewPar('RV_SETHOCO','59')
        	cNomeSetor := "HOSP. CORTINA"
        OtherWise
        	cNomeSetor := "OUTROS"
    EndCase
 	
    //Total do Pedido de Venda
    nTotalPV	+= (aCols[_i][nPOSQTD] * aCols[_i][nPOSPUNI])
    
	If XLL->(dbSeek( cNomeSetor )) 
		
		RecLock("XLL", .F.)
		XLL->TKG		:= XLL->TKG + aCols[_i][nPOS2VEN]
		XLL->TVALOR		:= XLL->TVALOR + (aCols[_i][nPOSQTD] * aCols[_i][nPOSPUNI])
		XLL->CLINHA		:= Alltrim(XLL->CLINHA) + '/' + AllTrim(cSetor)
		XLL->(MsUnLock())
	
	Else
	
		RecLock("XLL", .T.)
		XLL->LINHA		:= cNomeSetor
		XLL->TKG		:= aCols[_i][nPOS2VEN]
		XLL->TVALOR		:= (aCols[_i][nPOSQTD] * aCols[_i][nPOSPUNI])
		XLL->VALKG		:= 0
		XLL->CUSTO		:= nCusto
		XLL->MARGEM		:= nCusto * nMargem
		XLL->DIF		:= 0
		XLL->CLINHA		:= AllTrim(cSetor)
		XLL->(MsUnLock())
		
	EndIf
	
Next

//nValFrete	:= Processa({ || fCalcFrete(M->C5_NUM, cProdutos, nPesoPed, nTotalPV)},"Aguarde","Analisando Frete do pedido...")
nValFrete	:= fCalcFrete(M->C5_NUM, cProdutos, nPesoPed, nTotalPV)

nPercFrete	:= (nValFrete / nTotalPV) * 100 

DbSelectArea("XLL")
XLL->(dbGoTop())

While XLL->(!EOF())

	RecLock("XLL", .F.)
	XLL->VALKG		:= XLL->TVALOR / XLL->TKG
	XLL->DIF		:= XLL->VALKG - XLL->CUSTO//XLL->MARGEM
	XLL->(MsUnLock())
	/*
	If XLL->DIF < 0 .and. !lCusto
		lCusto	:= .T.
	EndIf
	*/
	XLL->(dbSkip())

EndDo

//Prazo médio
nPM 	:= POSICIONE("SE4",1, xFilial("SE4") + M->C5_CONDPAG, "E4_PRZMED")
nPMAnt	:= POSICIONE("SE4",1, xFilial("SE4") + fUltCondPG(M->C5_CLIENT, M->C5_LOJACLI), "E4_PRZMED")

If nPM > nPMAnt
//If nPM > GetNewPar("MV_LIMPMV",45)
	//lPM	:= .T.
	//cTexto	:= cTexto + "***BLOQUEIO POR PRAZO MAIOR QUE O DO ÚLTIMO PEDIDO" + ENTER
eNDiF

//Limite do percentual do XDD
If M->C5_DESC1 > GetNewPar("MV_LIMPXDD",40)
	lLimXDD	:= .T.
eNDiF

//Limite do percentual do Frete sobre o pedido
If SA1->A1_EST $ "AC,/AM/AP/PA/RO/RR/TO"
	If nPercFrete > GetNewPar("MV_XFRTPE1",10)
		lPercFrt	:= .T.
		cAux	:= Transform(GetNewPar("MV_XFRTPE1",10),"@E 999.99")
	eNDiF
ElseIf SA1->A1_EST $ "/MA/PI/CE/RN/PB/PE/AL/BA/SE"
	If nPercFrete > GetNewPar("MV_XFRTPE2",4)
		lPercFrt	:= .T.
		cAux	:= Transform(GetNewPar("MV_XFRTPE2",4),"@E 999.99")
	eNDiF
ElseIf SA1->A1_EST $ "GO/MT/MS/DF"
	If nPercFrete > GetNewPar("MV_XFRTPE3",7)
		lPercFrt	:= .T.
		cAux	:= Transform(GetNewPar("MV_XFRTPE3",7),"@E 999.99")
	eNDiF
ElseIf SA1->A1_EST $ "MG/ES/RJ/SP"
	If nPercFrete > GetNewPar("MV_XFRTPE4",6)
		lPercFrt	:= .T.
		cAux	:= Transform(GetNewPar("MV_XFRTPE4",6),"@E 999.99")
	eNDiF
ElseIf SA1->A1_EST $ "RS/PR/SC"
	If nPercFrete > GetNewPar("MV_XFRTPE5",8)
		lPercFrt	:= .T.
		cAux	:= Transform(GetNewPar("MV_XFRTPE5",8),"@E 999.99")
	eNDiF
Endif

//nFrtEx	:= fTotalFE(M->C5_CLIENT, M->C5_LOJACLI)

nFatSM	:= fTotalSN()

//lInativo	:= fUltComp(M->C5_CLIENT, M->C5_LOJACLI)
/*
If nFrtEx > 0 
	cTexto	:= cTexto + "***BLQ. Vlr. Extra em Frete" + ENTER
EndIf
*/

If lCusto 
	cTexto	:= cTexto + "***BLQ. Vlr. Abaixo do Limite" + ENTER
EndIf

If lDesc 
	cTexto	:= cTexto + "***BLOQUEIO POR DESCONTO MAIOR QUE O PERMITIDO" + ENTER
EndIf
/*
If lUltPco 
	cTexto	:= cTexto + "***BLQ. Vlr. Item Sem Reajuste " + Alltrim(STR(nAumento)) + "%" + ENTER
EndIf
*/
If lUltPco 
	cTexto	:= cTexto + "***BLOQUEIO POR PREÇO MENOR QUE O DO ÚLTIMA COMPRA DO PRODUTO" + ENTER
EndIf
/*
If lInativo
	cTexto	:= cTexto + "***BLQ. INATIVIDADE > 180 dias " + ENTER
EndIf
*/
/*
If lPercFrt
	cTexto	:= cTexto + "***BLQ. % Frete > " + cAux + ENTER
EndIf
*/
/*
If lQtdMin
	cTexto	:= cTexto + "***BLQ. QTD. Multiplo do Lote Economico - Segregados" + ENTER
	cTexto	:= cTexto + cTexQtdM
EndIf
*/
//**********************************************************************
//se ambos tiverem falso nao aparece a tela e esta liberado.
//**********************************************************************
If M->C5_CLIENTE $ "006543/007005/031732/031733" //valida rava, total e nova
	lTransf	:= .T.
	cTexto	:= cTexto + "*** PEDIDO TRANSFERÊNCIA ENTRE EMPRESAS" + ENTER
EndIf

	If lDesc .OR. lUltPco .OR. lPM .OR. lMinimo .OR. lLimXDD .OR. lTransf .OR. lCusto
//	If lDesc .OR. lCusto .OR. lPM .OR. lMinimo .OR. nFrtEx > 0 .OR. lLimXDD .OR. lUltPco .OR. lQtdMin .Or. lInativo
	
		oDlg1      := MSDialog():New( 300,300,750,1210,"VALIDAÇÃO ---  DESCONTO E LIMITE DE PREÇO POR LINHA",,,.F.,,,,,,.T.,,,.F. )
	
		DbSelectArea("XVL")
		XVL->(dbGoTop())
		
		oBrw1      := MsSelect():New( "XVL","","",{	{"COD",		"","Cod.",""},;
													{"PROD",	"","Produto",""},;
													{"DESC",	"","Desconto ped.","@E 9,999,999.99"},;
													{"ULTIMO",	"","Desconto cad.","@E 9,999,999.99"},;
													{"DIF",		"","Diferenca","@E 9,999,999.99"},;
													{"ULTPC",	"","Ultimo Prc.","@E 9,999,999.99"},;
													{"IDEAL",	"","Prc. Ideal","@E 9,999,999.99"}},.F.,,{020,000,103,455},,, oDlg1 ) 
		
		oBrw1:oBrowse:nClrPane := CLR_BLACK
		oBrw1:oBrowse:nClrText := CLR_BLACK
		oBrw1:oBrowse:bLDBLClick := {|| fDetDesc(M->C5_CLIENT, M->C5_LOJACLI, XVL->COD) }
		
		oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,455,020,.T.,.F. )
		oPanel2    := TPanel():New( 100,000,"",oDlg1,,.F.,.F.,,,455,022,.T.,.F. )
		
		oCBox1     := TCheckBox():New( 004,301,"Atualizar Desconto Padrão",{|u| If(PCount()>0,lChk1:=u,lChk1)},oPanel2,107,011,,,oFont1,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
		
		DbSelectArea("XLL")
		XLL->(dbGoTop())
		oBrw2      := MsSelect():New( "XLL","","",{	{"LINHA",	"","Linha",""},;
													{"TKG",		"","Total KG","@E 9,999,999.99"},;
													{"TVALOR",	"","Total R$","@E 9,999,999.99"},;
													{"VALKG",	"","Valor KG","@E 9,999,999.99"},;
													{"CUSTO",	"","Minimo","@E 9,999,999.99"},;
													{"MARGEM",	"","Margem Serv.","@E 9,999,999.99"},;
													{"DIF",		"","Diferenca","@E 9,999,999.99"}},.F.,,{120,000,172,455},,, oDlg1 ) 
		
		
		oBrw2:oBrowse:nClrPane := CLR_BLACK
		oBrw2:oBrowse:nClrText := CLR_BLACK
		oBrw2:oBrowse:bLDBLClick := {|| fDetGrupo() }
		
		oPanel3    := TPanel():New( 172,000,"",oDlg1,,.F.,.F.,,,455,060,.T.,.F. )
		oSay1      := TSay():New( 007,004,{||"Desconto padrão"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
		
		oSay3      := TSay():New( 007,104,{||"Prazo Médio"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
		oGet1      := TGet():New( 007,150,{|u| If(PCount()>0,nPM:=u,nPM)},oDlg1,030,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nPM",,)
		
		oBtn5      := TButton():New( 007,320,"Média Comp.",oDlg1,,050,012,,,,.T.,,"",,,,.F. )
		oBtn5:bAction := {|| fMedCompra(M->C5_CLIENT, M->C5_LOJACLI)}

		//nFrtEx	:= fTotalFE(M->C5_CLIENT, M->C5_LOJACLI)
		oSay4      := TSay():New( 007,204,{||"Frete Extra"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
		oGet2      := TGet():New( 007,250,{|u| If(PCount()>0,nFrtEx:=u,nFrtEx)},oDlg1,070,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nFrtEx",,)
		//oGet2:cPlaceHold := "N"
		oBtn4      := TButton():New( 007,380,"Detalhe Frt Ex",oDlg1,,050,012,,,,.T.,,"",,,,.F. )
		oBtn4:bAction := {|| fFrtEx(M->C5_CLIENT, M->C5_LOJACLI)}
	
		oSay2      := TSay():New( 007,004,{||"Linha abaixo do mínimo"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
		If lMinimo
			oSay2      := TSay():New( 007,104,{||"***BLQ. Vlr. Mínimo"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
			cTexto	:= cTexto + "*** BLOQUEIO POR PEDIDO MÍNIMO MENOR QUE O PERMITIDO" + ENTER
			
		EndIf
		If lLimXDD
			oSay2      := TSay():New( 007,144,{||"***BLQ. % XDD"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
			cTexto	:= cTexto + "***BLOQUEIO POR XDD MAIOR QUE 50%" + ENTER
		EndIf
		
		oBtn1      := TButton():New( 001,329,"Liberar",oPanel3,,062,012,,,,.T.,,"",,,,.F. )
		oBtn1:bAction := {|| lLibera := .T., oDlg1:end() }
		
		oBtn2      := TButton():New( 001,395,"Cancelar",oPanel3,,062,012,,,,.T.,,"",,,,.F. )
		oBtn2:bAction := {|| lContinua	:= .F., oDlg1:end()}
	
		oBtn3      := TButton():New( 001,260,"Enviar Pedido",oPanel3,,062,012,,,,.T.,,"",,,,.F. )
		oBtn3:bAction := {|| MsAguarde({|| fEnviaPed()},"Aguarde...","Enviando Email...") }
		
		oSay2      := TSay():New( 005,005,{||"RESUMO"},oPanel3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
		oSay3      := TSay():New( 005,105,{||"% Frete"},oPanel3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,014)
		oGet3      := TGet():New( 003,140,{|u| If(PCount()>0,nPercFrete:=u,nPercFrete)},oPanel3,030,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nPercFrete",,)
		oGet3      := TGet():New( 003,180,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oPanel3,030,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nValFrete",,)

		oMGet1     := TMultiGet():New( 013,001,,oPanel3,455,040,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
		oMGet1:bSetGet := {|u| If(PCount()>0,cTexto:=u,cTexto)}
	
		oDlg1:Activate(,,,.T.)
	
	Else
	
		lContinua	:= .T.
		
	EndIf
	
	If lLibera
		lContinua := fLibera()
	EndIf
/*
Else

	lContinua	:= .T.

EndIf
*/
XVL->(dbCloseArea())
XLL->(dbCloseArea())

Return lContinua

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: XVL
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"COD"     ,"C",015,000} )
Aadd( aFds , {"PROD"    ,"C",030,000} )
Aadd( aFds , {"DESC"    ,"N",014,002} )
Aadd( aFds , {"ULTIMO"  ,"N",014,002} )
Aadd( aFds , {"DIF"     ,"N",014,002} )
Aadd( aFds , {"QTDKG"    ,"N",014,002} )
Aadd( aFds , {"VALKG"    ,"N",014,002} )
Aadd( aFds , {"CUSTO"    ,"N",014,002} )
Aadd( aFds , {"MARGEM"   ,"N",014,002} )
Aadd( aFds , {"PESO"    ,"N",014,002} )
Aadd( aFds , {"ULTPC"    ,"N",014,002} )
Aadd( aFds , {"IDEAL"    ,"N",014,002} )

If Select("XVL") > 0
	DbSelectArea("XVL")
	XVL->(DbCloseArea())	
EndIf

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias XVL New Exclusive
Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: XLL
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl2()

Local aFds := {}

Aadd( aFds , {"LINHA"   ,"C",025,000} )
Aadd( aFds , {"TKG"	    ,"N",014,002} )
Aadd( aFds , {"TVALOR"	,"N",014,002} )
Aadd( aFds , {"VALKG"   ,"N",014,002} )
Aadd( aFds , {"CUSTO"   ,"N",014,002} )
Aadd( aFds , {"MARGEM"  ,"N",014,002} )
Aadd( aFds , {"DIF"     ,"N",014,002} )
Aadd( aFds , {"CLINHA"  ,"C",030,000} )

If Select("XLL") > 0
	DbSelectArea("XLL")
	XLL->(DbCloseArea())	
EndIf

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias XLL New Exclusive
Index On LINHA To ( coTbl2 )
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fDecPad  º Autor ³ Gustavo Costa       º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o desconto padrao do cliente por produto.            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fDecPad(cCli, cLoja, cProd)

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT * FROM  " + RetSqlName("ZBB") 
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND ZBB_CLIENT = '" + cCli + "'"
cQry+=" AND ZBB_LOJA >= '" + cLoja + "'" 
cQry+=" AND ZBB_PROD = '" + cProd + "'"

If Select("TMP1") > 0
	DbSelectArea("TMP1")
	TMP1->(DbCloseArea())	
EndIf

TCQUERY cQry NEW ALIAS  "TMP1"

dbSelectArea("TMP1")
TMP1->(dbGoTop())

If Select("TMP1") > 0

	nRet := TMP1->ZBB_PERC

EndIf

TMP1->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fUltPco  º Autor ³ Gustavo Costa       º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o ultimo preco do cliente por produto.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fUltPco(cCli, cLoja, cProd, lAntesAum)

local cQry		:= ''
Local nRet		:= 0
Local cData		:= SuperGetMV("MV_XAUMEND",,"201803")

cQry:=" SELECT TOP 1 C6_PRUNIT FROM " + RetSqlName("SC6") + " C6 "
cQry+=" INNER JOIN " + RetSqlName("SC5") + " C5 "
cQry+=" ON C6_FILIAL = C5_FILIAL "
cQry+=" AND C6_NUM = C5_NUM "
cQry+=" WHERE C6.D_E_L_E_T_ <> '*' "
cQry+=" AND C6_NOTA <> '' "
If lAntesAum
	cQry+=" AND C6_DATFAT < '" + cData + "' "
EndIf
cQry+=" AND C6_SERIE <> 'UNI' "
cQry+=" AND C6_FILIAL = '" + xFilial("SC6") + "'"
cQry+=" AND C5_CLIENTE = '" + cCli + "'"
cQry+=" AND C5_LOJACLI = '" + cLoja + "'" 
cQry+=" AND C6_PRODUTO = '" + cProd + "'"
cQry+=" ORDER BY C6_DATFAT DESC"

If Select("TMP3") > 0
	DbSelectArea("TMP3")
	TMP3->(DbCloseArea())	
EndIf

TCQUERY cQry NEW ALIAS  "TMP3"

dbSelectArea("TMP3")
TMP3->(dbGoTop())

If Select("TMP3") > 0

	nRet := TMP3->C6_PRUNIT

EndIf

TMP3->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fValCusto  º Autor ³ Gustavo Costa     º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o desconto padrao do cliente por produto.            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fValCusto(cSetor, cUF)

local cQry		:= ''
Local aRet		:= {}

cQry:=" SELECT TOP 1 * FROM " + RetSqlName("ZBC") 
cQry+=" WHERE ZBC_SETOR LIKE '%" + cSetor + "%' "
cQry+=" AND ZBC_UF = '" + cUF + "' "
cQry+=" AND D_E_L_E_T_ <> '*'"
cQry+=" ORDER BY ZBC_DATA DESC "

TCQUERY cQry NEW ALIAS  "TMPX"

dbSelectArea("TMPX")
TMPX->(dbGoTop())

If Select("TMPX") > 0

	AADD(aRet,TMPX->ZBC_CUSTO)
	AADD(aRet,TMPX->ZBC_MARGEM)

EndIf

TMPX->(dbclosearea())

Return aRet

//**********************************************
//Rotina para liberar 
//**********************************************

Static Function fLibera()

Local lRet	:= .F.

lRet := U_senha2( "15", 4 )[ 1 ]

//atualiza os descontos dos itens
If lRet .AND. lChk1

	DbSelectArea("XVL")
	XVL->(dbGoTop())
	
	DbSelectArea("ZBB")
	
	While XVL->(!EOF())
	
		If ZBB->(dbSeek(xFilial("ZBB") + M->C5_CLIENTE + M->C5_LOJACLI + XVL->COD))

			RecLock("ZBB",.F.)
			
			ZBB->ZBB_DATA := dDataBase
			ZBB->ZBB_PERC := XVL->DESC
			
			ZBB->(MsUnLock())

		Else

			RecLock("ZBB",.T.)
			
			ZBB->ZBB_CLIENT := M->C5_CLIENTE
			ZBB->ZBB_LOJA 	:= M->C5_LOJACLI
			ZBB->ZBB_PROD 	:= XVL->COD 
			ZBB->ZBB_DATA 	:= dDataBase
			ZBB->ZBB_PERC 	:= XVL->DESC
			
			ZBB->(MsUnLock())

		EndIf
		XVL->(dbSkip())
	
	EndDo

EndIf

//depois de dobrar a comissao retira o cliente da lista
dbSelectArea("SA1")
dbSeek(xFilial("SA1") + M->C5_CLIENT + M->C5_LOJACLI)

If !empty(SA1->A1_ORIGEM)
	RecLock("SA1",.F.)
	
	SA1->A1_ORIGEM := ""
	
	SA1->(MsUnLock())
EndIf

DbSelectArea("XVL")

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fDetGrupo ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Detalha o sub grupo do pedido de venda                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fDetGrupo()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nPOSPROD   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSNPRO   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_DESCRI" } )
Local nPOS2VEN   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_UNSVEN" } )
Local nPOSVAL    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_VALOR" } )
Local nPOSQTD    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_QTDVEN" } )
Local nPOSPUNI   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
Local cNGrupo	 := XLL->LINHA
Local cQtdGRP	 := Transform(XLL->TKG,"@E 9,999,999.99")
Local cTOTGRP	 := Transform(XLL->TVALOR,"@E 9,999,999.99")


Private coTbl3

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg2","oBrw3","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg2      := MSDialog():New( 241,176,451,1103,"DETALHE SUB-GRUPO",,,.F.,,,,,,.T.,,,.F. )
oTbl3()

For _i := 1 To Len(aCols)

	cSetor	:= POSICIONE("SB1",1, xFilial("SB1") + aCols[_i][nPOSPROD], "B1_SETOR")

	If AllTrim(cSetor) $ XLL->CLINHA
		
		RecLock("XDET", .T.)
		XDET->COD		:= aCols[_i][nPOSPROD]
		XDET->PRODUTO	:= aCols[_i][nPOSNPRO]
		XDET->QTDKG		:= aCols[_i][nPOS2VEN] 
		XDET->VALKG		:= ((aCols[_i][nPOSQTD] * aCols[_i][nPOSPUNI])) / aCols[_i][nPOS2VEN]
		XDET->TOTAL		:= (aCols[_i][nPOSQTD] * aCols[_i][nPOSPUNI])
		XDET->VALMIN	:= XLL->CUSTO
		XDET->DIF		:= XLL->CUSTO - XDET->VALKG
		XDET->(MsUnLock())
		
	EndIf
	
Next

XDET->(dbGoTop())
DbSelectArea("XDET")
oBrw3      := MsSelect():New( "XDET","","",{{"COD"		,"","Codigo",""},;
											{"PRODUTO"	,"","Produto",""},;
											{"QTDKG"	,"","Qtd. KG","@E 9,999,999.99"},;
											{"VALKG"	,"","Val. KG","@E 9,999,999.99"},;
											{"TOTAL"	,"","Total","@E 9,999,999.99"},;
											{"VALMIN"	,"","Val. Minimo","@E 9,999,999.99"},;
											{"DIF"		,"","Diferença","@E 9,999,999.99"}},.F.,,{000,000,080,461},,, oDlg2 ) 
oBrw3:oBrowse:nClrPane := CLR_BLACK
oBrw3:oBrowse:nClrText := CLR_BLACK

oGrp1      := TGroup():New( 080,000,103,171,"SUB GRUPO",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 087,008,{|| If(PCount()>0,cNGrupo:=u,cNGrupo) },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,091,013)
oGrp2      := TGroup():New( 080,172,103,319,"QUANT. TOTAL",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay2      := TSay():New( 088,179,{|| If(PCount()>0,cQtdGRP:=u,cQtdGRP) },oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,107,013)
oGrp3      := TGroup():New( 080,321,103,461,"VALOR TOTAL",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay3      := TSay():New( 088,328,{|| If(PCount()>0,cTOTGRP:=u,cTOTGRP) },oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,013)

oDlg2:Activate(,,,.T.)

XDET->(DbCloseArea())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl3() - Cria temporario para o Alias: XDET
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl3()

Local aFds := {}

Aadd( aFds , {"COD"     ,"C",015,000} )
Aadd( aFds , {"PRODUTO" ,"C",040,000} )
Aadd( aFds , {"QTDKG"   ,"N",014,002} )
Aadd( aFds , {"VALKG"   ,"N",014,002} )
Aadd( aFds , {"TOTAL"   ,"N",014,002} )
Aadd( aFds , {"VALMIN"  ,"N",014,002} )
Aadd( aFds , {"DIF"     ,"N",014,002} )

If Select("XDET") > 0
	DbSelectArea("XDET")
	XDET->(DbCloseArea())	
EndIf

coTbl3 := CriaTrab( aFds, .T. )
Use (coTbl3) Alias XDET New Exclusive
Return 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fEnviaPed º Autor ³ Gustavo Costa     º Data ³  22/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para enviar um email com as          º±±
±±º          ³ pendencias do pedido bloqueado.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fEnviaPed()

Local cTitulo  	:= "PEDIDO COM BLOQUEIO - " + M->C5_NUM
Local cCopia 	:= ""//GetNewPar('RV_XCOPBLQ',"gustavo@ravaembalagens.com.br")
Local cMailTo 	:= ""//"gustavo@ravaembalagens.com.br"
Local cConteudo	:= ""
Local cCodUser 	:= __CUSERID
local cMotivo	:= ""


PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cMailTo := Alltrim(aUsua[1][14])  	     // e-mail 
Endif

/*
DbselectArea("SA3")
DbsetOrder(1)
//email do vendedor
If SA3->(Dbseek(xFilial("SA3") + M->C5_VEND1 ))
	cMailTo := cMailTo + "; " + AllTrim(SA3->A3_EMAIL)           
Endif
*/

DbselectArea("SA3")
DbsetOrder(1)

//email do Gerente
If SA3->(Dbseek(xFilial("SA3") + M->C5_VEND2 ))
	cMailTo := cMailTo + "; " + AllTrim(SA3->A3_EMAIL)           
Endif

cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml'>"
cConteudo +="<head>"
cConteudo +="<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
cConteudo +="<title>Untitled Document</title>"
cConteudo +="</head>"

cConteudo +="<body>"
cConteudo +="<table width='1014' height='63' border='1'>"
  cConteudo +="<tr>"
    cConteudo +="<td height='23' colspan='9' bgcolor='#66FF99'><div align='center'><strong>PEDIDO BLOQUEADO POR DESCONTO E/OU PREÇO MÍNIMO</strong></div></td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>PEDIDO</strong></td>"
    cConteudo +="<td colspan='2'>" + M->C5_NUM + "</td>"
    cConteudo +="<td width='74' height='23'><strong>DATA</strong></td>"
    cConteudo +="<td width='434' colspan='5'>" + DtoC(M->C5_EMISSAO) + "</td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>CLIENTE</strong></td>"
    cConteudo +="<td colspan='8'>" + M->C5_CLIENTE + '/' + M->C5_LOJACLI + ' - ' + AllTrim(Posicione('SA1',1,xFilial('SA1')+M->C5_CLIENTE + M->C5_LOJACLI,'A1_NOME')) + " </td>"
  cConteudo +="</tr>"
cConteudo +="</table>"
cConteudo +="<p>&nbsp;</p>"
cConteudo +="<table width='1014' height='93' border='1'>"
  cConteudo +="<tr>"
    cConteudo +="<td height='23' colspan='9' bgcolor='#999999'><div align='center'><strong>BLOQUEIO POR DESCONTO</strong></div></td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='91' height='23' bgcolor='#999999'><div align='center'><strong>COD.</strong></div></td>"
    cConteudo +="<td width='275' bgcolor='#999999'><div align='center'><strong>PRODUTO</strong></div></td>"
    cConteudo +="<td width='51' bgcolor='#999999'><div align='center'><strong>PESO</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>QTD. KG</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>VLR. KG</strong></div></td>"
    cConteudo +="<td width='91' bgcolor='#999999'><div align='center'><strong>DESC.</strong></div></td>"
    cConteudo +="<td width='110' bgcolor='#999999'><div align='center'><strong>TOTAL</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>ULT. DESC.</strong></div></td>"
    cConteudo +="<td width='69' bgcolor='#999999'><div align='center'><strong>MOTIVO</strong></div></td>"
  cConteudo +="</tr>"

dbSelectArea("XVL")
XVL->(dbGoTop())

While XVL->(!EOF())
  
    If XVL->DESC > XVL->ULTIMO
    	cMotivo :="%DESC."
    Else
    	cMotivo :=""
    EndIf
    
    If XVL->VALKG < XVL->CUSTO
    	cMotivo +="/VALOR"
    Else
    	cMotivo +=""
    EndIf

  cConteudo +="<tr>"
    cConteudo +="<td height='23'>" + XVL->COD + "</td>"
    cConteudo +="<td>" + XVL->PROD + "</td>"
    cConteudo +="<td><div align='right'>" + Transform(XVL->PESO,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XVL->QTDKG,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XVL->VALKG,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XVL->DESC,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XVL->QTDKG * XVL->VALKG,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XVL->ULTIMO,"@E 999,999,999.99") + "</div></td>"
    If Empty(cMotivo)
    	cConteudo +="<td><div align='center'>OK</div></td>"
    Else
    	cConteudo +="<td><div align='center'>" + cMotivo + "</div></td>"
    EndIf
  cConteudo +="</tr>"
  
  XVL->(dbSkip())

EndDo
XVL->(dbGoTop())

cConteudo +="</table>"

cConteudo +="<p>&nbsp;</p>"
cConteudo +="<table width='1014' height='93' border='1'>"
  cConteudo +="<tr>"
    cConteudo +="<td height='23' colspan='8' bgcolor='#999999'><div align='center'><strong>BLOQUEIO POR LINHA</strong></div></td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='274' height='23' bgcolor='#999999'><strong>LINHA</strong></td>"
    cConteudo +="<td width='140' bgcolor='#999999'><div align='center'><strong>TOTAL KG</strong></div></td>"
    cConteudo +="<td width='140' bgcolor='#999999'><div align='center'><strong>TOTAL R$</strong></div></td>"
    cConteudo +="<td width='140' bgcolor='#999999'><div align='center'><strong>VALOR KG</strong></div></td>"
    cConteudo +="<td width='140' bgcolor='#999999'><div align='center'><strong>MÍNIMO</strong></div></td>"
    cConteudo +="<td width='140' bgcolor='#999999'><div align='center'><strong>DIF.</strong></div></td>"
  cConteudo +="</tr>"
  
dbSelectArea("XLL")
XLL->(dbGoTop())

While XLL->(!EOF())

  cConteudo +="<tr>"
    cConteudo +="<td height='23'>" + XLL->LINHA + "</td>"
    cConteudo +="<td><div align='right'>" + Transform(XLL->TKG,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XLL->TVALOR,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XLL->VALKG,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XLL->CUSTO,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(XLL->DIF,"@E 999,999,999.99") + "</div></td>"
  cConteudo +="</tr>"

  XLL->(dbSkip())

EndDo

XLL->(dbGoTop())

cConteudo +="</table>"
cConteudo +="</body>"
cConteudo +="</html>"

cAnexo	:= ""
Memowrite("D:\Temp\pedido.html", cConteudo)
ConOut("**** CONTEUDO ****")
ConOut(cConteudo)

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )

If lEnviado
	MsgAlert("Email enviado com sucesso! " + cMailTo)
Else
	MsgAlert("Problema no envio do email!")
EndIf

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl4() - Cria temporario para o Alias: XDES
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl4()

Local aFds := {}

Aadd( aFds , {"SERIE" 	,"C",003,000} )
Aadd( aFds , {"NOTA" 	,"C",009,000} )
Aadd( aFds , {"PEDIDO" 	,"C",006,000} )
Aadd( aFds , {"EMISSAO" ,"D",008,000} )
Aadd( aFds , {"QTD"   	,"N",014,002} )
Aadd( aFds , {"VALOR"  	,"N",014,002} )
Aadd( aFds , {"TOTAL"   ,"N",014,002} )
Aadd( aFds , {"DESCONTO","N",014,002} )
Aadd( aFds , {"PRAZO"	,"N",006,000} )

If Select("XDES") > 0
	DbSelectArea("XDES")
	XDES->(DbCloseArea())	
EndIf

coTbl4 := CriaTrab( aFds, .T. )
Use (coTbl4) Alias XDES New Exclusive

Return 


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl5() - Cria temporario para o Alias: XFRT
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl5()

Local aFds := {}

Aadd( aFds , {"NFORI" 	,"C",009,000} )
Aadd( aFds , {"NREDUZ" 	,"C",020,000} )
Aadd( aFds , {"PRODUTO"	,"C",020,000} )
Aadd( aFds , {"EMISSAO" ,"D",008,000} )
Aadd( aFds , {"VALOR"  	,"N",014,002} )

If Select("XFRT") > 0
	DbSelectArea("XFRT")
	XFRT->(DbCloseArea())	
EndIf

coTbl5 := CriaTrab( aFds, .T. )
Use (coTbl5) Alias XFRT New Exclusive

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fDetDesc ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Mostra as 5 ultimas compras deste produto para o cliente  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fDetDesc(cCli, cLoja, cProd)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

Private coTbl4

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg2","oBrw3","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

oTbl4()

cQry:=" SELECT TOP 10 D2_COD, D2_DOC, D2_SERIE, D2_EMISSAO, C6_NUM, C6_PDESC, C6_QTDVEN, C6_PRUNIT, "
cQry+=" C6_QTDVEN * C6_PRUNIT TOTAL, E4_PRZMED  FROM " + RetSqlName("SD2") + " D "
cQry+=" INNER JOIN " + RetSqlName("SC6") + " C "
cQry+=" ON C6_NUM = D2_PEDIDO "
cQry+=" AND C6_PRODUTO = D2_COD "
cQry+=" INNER JOIN SF2020 "
cQry+=" ON F2_FILIAL = D2_FILIAL "
cQry+=" AND F2_DOC = D2_DOC "
cQry+=" AND F2_SERIE = D2_SERIE "
cQry+=" INNER JOIN SE4010 "
cQry+=" ON F2_COND = E4_CODIGO "
cQry+=" WHERE D2_CLIENTE = '" + cCli + "' "
cQry+=" AND D2_LOJA = '" + cLoja + "' "
cQry+=" AND D2_COD = '" + cProd + "' "
cQry+=" AND D.D_E_L_E_T_ <> '*' "
cQry+=" AND C.D_E_L_E_T_ <> '*' "
cQry+=" ORDER BY D2_EMISSAO DESC "

TCQUERY cQry NEW ALIAS  "TMP4"

dbSelectArea("TMP4")
TMP4->(dbGoTop())

While TMP4->(!EOF())

	RecLock("XDES", .T.)
	
	XDES->SERIE		:= TMP4->D2_SERIE
	XDES->NOTA		:= TMP4->D2_DOC
	XDES->PEDIDO	:= TMP4->C6_NUM
	XDES->EMISSAO	:= StoD(TMP4->D2_EMISSAO) 
	XDES->QTD		:= TMP4->C6_QTDVEN
	XDES->VALOR		:= TMP4->C6_PRUNIT
	XDES->TOTAL		:= TMP4->TOTAL
	XDES->DESCONTO	:= TMP4->C6_PDESC
	XDES->PRAZO		:= TMP4->E4_PRZMED
	
	XDES->(MsUnLock())
		
	TMP4->(dbSkip())
	
EndDo

TMP4->(dbclosearea())

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg2      := MSDialog():New( 241,176,451,1103,"DETALHE DESCONTOS",,,.F.,,,,,,.T.,,,.F. )


XDES->(dbGoTop())
DbSelectArea("XDES")
oBrw3      := MsSelect():New( "XDES","","",{{"SERIE"	,"","Serie",""},;
											{"NOTA"		,"","Nota",""},;
											{"EMISSAO"	,"","Emissao",""},;
											{"PEDIDO"	,"","Pedido",""},;
											{"QTD"		,"","Quant.","@E 9,999,999.99"},;
											{"VALOR"	,"","Valor","@E 9,999,999.99"},;
											{"TOTAL"	,"","Total","@E 9,999,999.99"},;
											{"DESCONTO"	,"","Desconto","@E 9,999,999.99"},;
											{"PRAZO"	,"","Prazo Med.","@E 999,999"}},.F.,,{001,001,090,461},,, oDlg2 ) 
oBrw3:oBrowse:nClrPane := CLR_BLACK
oBrw3:oBrowse:nClrText := CLR_BLACK
/*
oGrp1      := TGroup():New( 080,000,103,171,"SUB GRUPO",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 087,008,{|| If(PCount()>0,cNGrupo:=u,cNGrupo) },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,091,013)
oGrp2      := TGroup():New( 080,172,103,319,"QUANT. TOTAL",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay2      := TSay():New( 088,179,{|| If(PCount()>0,cQtdGRP:=u,cQtdGRP) },oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,107,013)
oGrp3      := TGroup():New( 080,321,103,461,"VALOR TOTAL",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay3      := TSay():New( 088,328,{|| If(PCount()>0,cTOTGRP:=u,cTOTGRP) },oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,013)
*/
oDlg2:Activate(,,,.T.)

XDES->(DbCloseArea())

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fFrtEx ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Mostra as 10 ultimas compras deste cliente tem Extra de frete³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fFrtEx(cCli, cLoja)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

Private coTbl5

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg5","oBrw5","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

oTbl5()

cQry:=" SELECT D1_NFORI, A2_NREDUZ, B1_DESC, D1_TOTAL, D1_EMISSAO  FROM " + RetSqlName("SD1") + " D1 "
cQry+=" INNER JOIN " + RetSqlName("SA2") + " A2 "
cQry+=" ON A2_COD = D1_FORNECE "
cQry+=" AND A2_LOJA = D1_LOJA "
cQry+=" INNER JOIN " + RetSqlName("SB1") + " B1 "
cQry+=" ON B1_COD = D1_COD "
cQry+=" WHERE D1.D_E_L_E_T_ <> '*' "
cQry+=" AND D1_NFORI + D1_SERIORI IN ( "
cQry+=" SELECT TOP 10 F2_DOC + F2_SERIE FROM " + RetSqlName("SF2") + " F2 " 
cQry+=" WHERE F2.D_E_L_E_T_ <> '*' "
cQry+=" AND F2_CLIENTE = '" + cCli + "' "
cQry+=" AND F2_LOJA = '" + cLoja + "' "
cQry+=" ORDER BY F2_EMISSAO DESC ) "
cQry+=" AND D1_TP = 'FR' "

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

While TMP5->(!EOF())

	RecLock("XFRT", .T.)
	
	XFRT->NFORI		:= TMP5->D1_NFORI
	XFRT->NREDUZ	:= TMP5->A2_NREDUZ
	XFRT->PRODUTO	:= TMP5->B1_DESC
	XFRT->EMISSAO	:= StoD(TMP5->D1_EMISSAO) 
	XFRT->VALOR		:= TMP5->D1_TOTAL
	
	XFRT->(MsUnLock())
		
	TMP5->(dbSkip())
	
EndDo

TMP5->(dbclosearea())

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg5      := MSDialog():New( 241,176,451,1103,"DETALHE FRETE EXTRA",,,.F.,,,,,,.T.,,,.F. )


XFRT->(dbGoTop())
DbSelectArea("XFRT")
oBrw5      := MsSelect():New( "XFRT","","",{{"NFORI"	,"","Nota Original",""},;
											{"NREDUZ"	,"","Transportadora",""},;
											{"PRODUTO"	,"","Motivo",""},;
											{"EMISSAO"	,"","Data CTE",""},;
											{"VALOR"	,"","Valor","@E 9,999,999.99"}},.F.,,{001,001,090,461},,, oDlg5 ) 
oBrw5:oBrowse:nClrPane := CLR_BLACK
oBrw5:oBrowse:nClrText := CLR_BLACK

oDlg5:Activate(,,,.T.)

XFRT->(DbCloseArea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fTotalFE ³ Autor :Gustavo Costa         ³ Data :14/06/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Retorna o total de Extra de frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fTotalFE(cCli, cLoja)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT D1_NFORI, A2_NREDUZ, B1_DESC, D1_TOTAL, D1_EMISSAO  FROM " + RetSqlName("SD1") + " D1 "
cQry+=" INNER JOIN " + RetSqlName("SA2") + " A2 "
cQry+=" ON A2_COD = D1_FORNECE "
cQry+=" AND A2_LOJA = D1_LOJA "
cQry+=" INNER JOIN " + RetSqlName("SB1") + " B1 "
cQry+=" ON B1_COD = D1_COD "
cQry+=" WHERE D1.D_E_L_E_T_ <> '*' "
cQry+=" AND D1_NFORI + D1_SERIORI IN ( "
cQry+=" SELECT TOP 10 F2_DOC + F2_SERIE FROM " + RetSqlName("SF2") + " F2 " 
cQry+=" WHERE F2.D_E_L_E_T_ <> '*' "
cQry+=" AND F2_CLIENTE = '" + cCli + "' "
cQry+=" AND F2_LOJA = '" + cLoja + "' "
cQry+=" ORDER BY F2_EMISSAO DESC ) "
cQry+=" AND D1_TP = 'FR' "
cQry+=" AND D1_COD <> 'FR0001' "

TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

While TMP5->(!EOF())

	nRet	:= nRet + TMP5->D1_TOTAL
	
	TMP5->(dbSkip())

EndDo

TMP5->(dbclosearea())

Return nRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fTotalSN ³ Autor :Gustavo Costa         ³ Data :14/06/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Retorna o total de Faturado no Simples Nacional           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fTotalSN()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

//TOTAL FATURADO
cQry := " SELECT Sum((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ) VENDAS "
cQry += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQry += "         WHERE D2_FILIAL = '06' AND "
cQry += "         SUBSTRING(SD2.D2_CF,1,2) IN ('51','61','59','69') AND " 
cQry += " 		SD2.D2_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND " 
cQry += "         SD2.D_E_L_E_T_ =   '' "
cQry += " 		AND D2_SERIE <> '' " 


TCQUERY cQry NEW ALIAS  "TMP6"

dbSelectArea("TMP6")
TMP6->(dbGoTop())

While TMP6->(!EOF())

	nRet	:= nRet + TMP6->VENDAS
	
	TMP6->(dbSkip())

EndDo

TMP6->(dbclosearea())

//TOTAL PEDIDO LIBERADO
cQry := " SELECT "
cQry += "SUM( C6_QTDVEN*C6_PRCVEN ) AS EMPEDIDO "  
cQry += "FROM SC6020 SC6 WITH (NOLOCK) "
cQry += "INNER JOIN SC5020 SC5 WITH (NOLOCK) "
cQry += "ON C6_FILIAL + C6_NUM = C5_FILIAL + C5_NUM  "
cQry += "WHERE C6_FILIAL = '06' AND  "
cQry += "SUBSTRING(SC6.C6_CF,1,2) IN ('51','61','59','69') AND  "
cQry += "SC5.C5_EMISSAO BETWEEN '" + DtoS(FirstDate(ddatabase)) + "' AND '" + DtoS(ddatabase) + "' AND "  
cQry += "SC6.D_E_L_E_T_ =   '' AND  "
cQry += "SC5.D_E_L_E_T_ =   '' AND "
cQry += "SC6.C6_NOTA = '' " 


TCQUERY cQry NEW ALIAS  "TMP7"

dbSelectArea("TMP7")
TMP7->(dbGoTop())

While TMP7->(!EOF())

	nRet	:= nRet + TMP7->EMPEDIDO
	
	TMP7->(dbSkip())

EndDo

TMP7->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fUltComp  º Autor ³ Gustavo Costa       º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o ultimo preco do cliente por produto.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fUltComp(cCli, cLoja)

local cQry		:= ''
Local lRet		:= .F.
Local nDias		:= SuperGetMV("MV_XDIAINA",,180)

cQry:=" SELECT TOP 1 CAST( getdate() - CONVERT(smalldatetime, D2_EMISSAO,101) AS INT) VALOR "
cQry+=" FROM " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) "
cQry+=" WHERE SD2.D_E_L_E_T_ = '' "
cQry+=" AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) " 
cQry+=" AND D2_CLIENTE IN ('" + cCli + "') "
cQry+=" ORDER BY D2_EMISSAO DESC "

If Select("TMP8") > 0
	DbSelectArea("TMP8")
	TMP8->(DbCloseArea())	
EndIf

TCQUERY cQry NEW ALIAS  "TMP8"

dbSelectArea("TMP8")
TMP8->(dbGoTop())

If Select("TMP8") > 0

	If TMP8->VALOR >= nDias
		lRet := .T.
	EndIf 

EndIf

TMP8->(dbclosearea())

Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fSldProd ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Faz a validação do estoque dos produtos                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fSldProd()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0
Local nPOSPROD   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSNPRO   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_DESCRI" } )
Local nPOSQTD    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_QTDVEN" } )
Local nPOSLOC    := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_LOCAL" } )
Local nPOSPUNI   := aScan( aHeader,{ |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
Local nComSaldo	:= 0 
Local nSemSaldo	:= 0 
Local nSaldo	:= 0

Private coTbl6

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg6","oBrw6","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

oTbl6()

For _i := 1 To Len(aCols)

	dbSelectArea("SB2")
	dbSeek(xFilial("SB2") + aCols[_i][nPOSPROD] + aCols[_i][nPOSLOC])
	nSaldo	:= B2_QATU - B2_RESERVA - B2_QEMP- B2_QACLASS - B2_QEMPSA - B2_QEMPPRJ - B2_QTNP 
	
	If nSaldo - aCols[_i][nPOSQTD] >= 0
		nComSaldo	+= aCols[_i][nPOSPUNI] * aCols[_i][nPOSQTD]
	Else
		nSemSaldo	+= aCols[_i][nPOSPUNI] * aCols[_i][nPOSQTD]
	EndIf

	dbSelectArea("XEST")
	RecLock("XEST", .T.)
	
	XEST->PROD		:= aCols[_i][nPOSPROD]
	XEST->DESC		:= aCols[_i][nPOSNPRO]
	XEST->QUANT		:= aCols[_i][nPOSQTD]
	XEST->SALDO		:= nSaldo
	XEST->PROV		:= nSaldo - aCols[_i][nPOSQTD]
	
	XEST->(MsUnLock())
	
Next

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Arial",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg6      := MSDialog():New( 241,176,550,1103,"RESUMO SALDO DOS PRODUTOS DESTE PEDIDO",,,.F.,,,,,,.T.,,,.F. )

oSay1      := TSay():New( 001,010,{||"R$ Com Saldo"},oDlg6,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
oGet1      := TGet():New( 001,070,{|u| If(PCount()>0,nComSaldo:=u,nComSaldo)},oDlg6,050,008,"@E 999,999,999.99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nComSaldo",,)
oSay2      := TSay():New( 001,130,{||"R$ Sem Saldo"},oDlg6,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,097,009)
oGet2      := TGet():New( 001,190,{|u| If(PCount()>0,nSemSaldo:=u,nSemSaldo)},oDlg6,050,008,"@E 999,999,999.99",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"nSemSaldo",,)

XEST->(dbGoTop())
DbSelectArea("XEST")
oBrw6      := MsSelect():New( "XEST","","",{{"PROD"		,"","Produto",""},;
											{"DESC"		,"","Descricao",""},;
											{"QUANT"	,"","Qtd. Pedido","@E 999,999,999.99"},;
											{"SALDO"	,"","Sld. Disponivel","@E 999,999,999.99"},;
											{"PROV"		,"","Provisao","@E 999,999,999.99"}},.F.,,{016,001,140,461},,, oDlg6 ) 
oBrw6:oBrowse:nClrPane := CLR_BLACK
oBrw6:oBrowse:nClrText := CLR_BLACK
oBrw6:oBrowse:bLDBLClick := {|| fTransfPrd(XEST->PROD) }

oDlg6:Activate(,,,.T.)

XEST->(DbCloseArea())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl5() - Cria temporario para o Alias: XFRT
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl6()

Local aFds := {}

Aadd( aFds , {"PROD" 	,"C",015,000} )
Aadd( aFds , {"DESC" 	,"C",050,000} )
Aadd( aFds , {"QUANT"  	,"N",016,002} )
Aadd( aFds , {"SALDO"  	,"N",016,002} )
Aadd( aFds , {"PROV"  	,"N",016,002} )

If Select("XEST") > 0
	DbSelectArea("XEST")
	XEST->(DbCloseArea())	
EndIf

coTbl6 := CriaTrab( aFds, .T. )
Use (coTbl6) Alias XEST New Exclusive

Return 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fTransfPrd ³ Autor :Gustavo Costa         ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Mostra as sugestôes de troca do produto                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fTransfPrd(_Prod)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQuery		:= ''
Local cProduto		:= U_Transgen(_Prod)
Local cFamilia 		:= SubStr(cProduto,1,1)
Local cCor   		:= SubStr(cProduto,3,1)
Local nPesoOrig		:= Posicione("SB1",1,xFilial("SB1") + cProduto, "B1_PESO")
Local nPercMenos	:= 15 //nPesoOrig - (nPesoOrig * (mv_par02/100))
Local nPercMais		:= 15 //nPesoOrig + (nPesoOrig * (mv_par03/100))

If nPesoOrig > 0
	nPercMenos	:= nPesoOrig - (nPesoOrig * (15/100))
	nPercMais	:= nPesoOrig + (nPesoOrig * (15/100))
Else
	MsgAlert("Produto sem peso - " + cProduto)
	Return
EndIf


If cFamilia = 'C'
	cFamilia	:= "('C')"
Else
	cFamilia	:= "('A','B','D','E','G')"
EndIf

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg7","oBrw5","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

cQuery := " SELECT B2_FILIAL, B2_COD, B1_DESC, B5_ESPESS, B1_UM, B2_QATU, B1_PESO, PESO, ((B1_PESO - PESO) / B1_PESO)*100 PERC FROM ( "
cQuery += " SELECT B2_FILIAL, B2_COD, B1_DESC, B5_ESPESS, B1_UM, B2_QATU, " 
cQuery += " CASE WHEN B1_UM = 'FD' THEN (B1_PESO / B5_QTDEN)*1000 ELSE B1_PESO END AS B1_PESO, " 
cQuery += " (SELECT B1_PESO FROM SB1010 WHERE B1_COD = '" + cProduto + "' ) PESO "
cQuery += " FROM SB1010 B1 "
cQuery += " INNER JOIN SB2020 B2 "
cQuery += " ON B1_COD = B2_COD "
cQuery += " INNER JOIN SB5010 B5 "
cQuery += " ON B1_COD = B5_COD "
cQuery += " WHERE SUBSTRING(B1_COD,1,1) IN " + cFamilia + " "
cQuery += " AND  SUBSTRING(B1_COD,3,1) = '" + cCor + "' "
cQuery += " AND B1.D_E_L_E_T_ <> '*' "
cQuery += " AND B2.D_E_L_E_T_ <> '*' "
cQuery += " AND B5.D_E_L_E_T_ <> '*' "
cQuery += " AND B2_QATU > 0 "
cQuery += " AND B2_LOCAL = '01' "
cQuery += " AND B2_FILIAL + B2_COD <> '" + xFilial("SB2") + cProduto + "' "
cQuery += " ) AS TAB "
cQuery += " WHERE B1_PESO BETWEEN '" + STR(nPercMenos) + "' AND '" + STR(nPercMais) + "' "
cQuery += " ORDER BY B1_PESO DESC " 

If Select("TMP7") > 0
	DbSelectArea("TMP7")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP7"

TMP7->( DbGoTop() )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg7      := MSDialog():New( 241,176,551,1203,"SUGESTAO DE TRANSFORMACAO DE PRODUTO",,,.F.,,,,,,.T.,,,.F. )


oBrw7      := MsSelect():New( "TMP7","","",{{"B2_FILIAL"	,"","Filial"	,""},;
											{"B2_COD"		,"","Codigo"	,""},;
											{"B1_DESC"		,"","Produto"	,""},;
											{"B5_ESPESS"	,"","Espessura"	,"@E 9,999.99999"},;
											{"B2_QATU"		,"","Saldo"		,"@E 9,999,999.99"},;
											{"B1_PESO"		,"","Peso Dest.","@E 9,999.99999999"},;
											{"PESO"			,"","Peso Orig.","@E 9,999.99999999"},;
											{"PERC"			,"","% Variação","@E 9,999.99999999"}},.F.,,{001,001,090,561},,, oDlg7 ) 
oBrw7:oBrowse:nClrPane := CLR_BLACK
oBrw7:oBrowse:nClrText := CLR_BLACK

oDlg7:Activate(,,,.T.)

TMP7->(DbCloseArea())

Return




*************
Static Function fCalcFrete(cDoc, cProdutos, nPesoPed, nTotPed)
*************

//local nPosDel:= len(aHeader)+1
Local nVlrCubagem := 0
Local nVlrCUBA4   := 0
Local nQTVOLUMES  := 0
Local LF	   		:= CHR(13) + CHR(10)
Local aRet			:={}
Local cUF			:= Posicione("SA1",1, xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_EST")

local nPosVALOR  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_VALOR" })

local cQry		:= ''
Local nCUBAGEM		:= 0
Local nCUBAGPed		:= 0

//TOTAL FATURADO
cQry := "SELECT SUM( B5_COMPRI * B5_LARGURA * B5_ALTURA ) CUBAGEM FROM  " + RetSqlName("SB5") 
cQry += " WHERE B5_COD IN (" + cProdutos + ") "
cQry += " AND D_E_L_E_T_ = '' "


TCQUERY cQry NEW ALIAS  "TMP8"

dbSelectArea("TMP8")
TMP8->(dbGoTop())

While TMP8->(!EOF())

	nCUBAGPed	:= TMP8->CUBAGEM
	
	TMP8->(dbSkip())

EndDo

TMP8->(dbCloseArea())

aFrete := {}

SZZ->(Dbsetorder(1))
	   //  SZZ->(Dbsetorder(3))  // FILIAL+TRANSP+UF+LOCALIDADE   
If Empty( M->C5_REDESP )   		
	SZZ->( dbSeek( xFilial( "SZZ" ) + M->C5_TRANSP + M->C5_LOCALIZ ) )
	
	Aadd( aFrete, { M->C5_TRANSP, M->C5_NUM, "", M->C5_LOCALIZ, " ", cUF + SZZ->ZZ_TIPO,ALLTRIM(getReg(cUF)), nCUBAGPed, M->C5_VOLUME1, cUF } )
	   //						1                 2              3                4           5        6                                 7                        8               9             10
Else   
    SZZ->( dbSeek( xFilial( "SZZ" ) + M->C5_REDESP + M->C5_LOCALIZ ) )
	
	Aadd( aFrete, { M->C5_TRANSP, M->C5_NUM, "", M->C5_LOCRED, " ", cUF + SZZ->ZZ_TIPO,ALLTRIM(getReg(cUF)),nCUBAGPed, M->C5_VOLUME1,cUF } )
	Aadd( aFrete, { M->C5_REDESP, M->C5_NUM, "", M->C5_LOCALIZ,"R", cUF + SZZ->ZZ_TIPO,ALLTRIM(getReg(cUF)),nCUBAGPed, M->C5_VOLUME1,cUF } )
	//                     1			2				3				4			 5	    	6				                    7				     8               9            10
Endif

aFre_nf := Asort( aFrete,,, { |X,Y| X[7]+X[6]+X[1]+X[2]<Y[7]+Y[6]+Y[1]+Y[2] } )   
nDna    := nTot  := nFre := nTotal := nTotFret := nTotFrIcms := nTotIcms := nTotDna :=nTotRed := nTotpes:= nTotPesoFrete := 0
nDnaG   := nTotG := nFreG:= nTotGicms := 0
nDnaCI  := nTotCI:= nFreCI:= nTotCIicms := 0
//REGIAO
nTotCE:=nTotNE:=nTotNO:=nTotSD:=nTotSL:=0
nTotCEicms :=nTotNEicms :=nTotNOicms :=nTotSDicms :=nTotSLicms := 0
nFreCE :=nFreNE :=nFreNO :=nFreSD :=nFreSL :=0
nDnaCE :=nDnaNE :=nDnaNO :=nDnaSD :=nDnaSL :=0

nCubagem := 0
nQTVOLUMES := 0


if len(aFre_nf) > 0
	cEstCI  := Substr( aFre_nf[ 1, 6 ], 1, 2 )
endIf

For x := 1 to Len( aFre_nf )   
    cEstado := aFre_nf[ x, 6 ] 
    SX5->(DBSETORDER(1))
    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ) ) )    
    //While aFre_nf[ x, 6 ] == cEstado       
       cTransp := aFre_nf[ x, 1 ]
       nCubagem    := 0
       nVlrCubagem := 0
       nVlrCUBA4   := 0                   //VLR CUBAGEM CADASTRADO NO SA4
       nQTVOLUMES  := aFre_nf[x,9]        //QTDE DE VOLUMES NA NOTA FISCAL               
       SA4->(DBSETORDER(1))
       If SA4->( dbSeek( xFilial( "SA4" ) + aFre_nf[ x, 1 ] ) )
       	nVlrCUBA4 := SA4->A4_VLRCUB     //VALOR DA CUBAGEM POR TRANSPORTADORA NO SA4
       Endif			
       //While aFre_nf[ x, 1 ] == cTransp .and. aFre_nf[ x, 6 ] == cEstado
       
          nAd_valoren := 0
          nFluvial    := 0
          nFret_pes   := 0
          nTaxaFixa   := 0
          nADM		  := 0
          nPedagio	  := 0
          nSuframa	  := 0 
          nFretIcms	  := 0
          nFrete	  := 0
          nGRIS		  := 0
          nTDE		  := 0
          
          nCubagem:= aFre_nf[ x, 8 ]     //resultado da multiplicação (ALT X LARG X COMPRIMENTO)
           
          nVlrCubagem := (nCubagem * nVlrCUBA4 * nQTVOLUMES)   //valor a ser impresso no relatório
          
          SZZ->(DBSETORDER(1))
          //  SZZ->(DBSETORDER(3))  // FILIAL+TRANSP+UF+LOCALIDADE          

          SZZ->( dbSeek( xFilial( "SZZ" ) + aFre_nf[ x, 1 ]  + aFre_nf[ x, 4 ] ) )   
          //SZZ->( dbSeek( xFilial( "SZZ" ) + aFre_nf[ x, 1 ] + aFre_nf[ x, 10 ] + aFre_nf[ x, 4 ] ) )   
          
          //SF2->(DBSETORDER(1))
          //SF2->( dbSeek( xFilial( "SF2" ) + aFre_nf[ x, 2 ] + aFre_nf[ x, 3 ] ) )  //F2_DOC + F2_SERIE
          

          nValDna := 0
          
           // NOVO CALCULO DO FRETE 
          If nPesoPed > 150
          	nFret_pes := (nPesoPed * SZZ->ZZ_FR_PESO)
            //SE O FRETE PESO CALCULADO FOR MENOR QUE O MÍNIMO, PEGA O MÍNIMO DO SA4
            If SZZ->ZZ_TIPO = 'C'    //CAPITAL
            	If nFret_pes < SA4->A4_FREMINC
            		nFret_pes := SA4->A4_FREMINC
            	Endif
            Elseif SZZ->ZZ_TIPO = 'I'   //INTERIOR
            	If nFret_pes < SA4->A4_FREMINI
            		nFret_pes := SA4->A4_FREMINI
            	Endif            
            Endif
            	
          ElseIf (nPesoPed >= 101 .and. nPesoPed <= 150)
          	If !Empty(SZZ->ZZ_101150K) 
          		nFret_pes := SZZ->ZZ_101150K
          	Else
          		nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          	Endif          	
          
          //FR - Flávia Rocha
          //chamado 002208:	Joao Emanuel
          //Para calculo de frete, quando a transportadora for cod 30
          // e o peso for até 10 KG, favor calcular só os valores abaixo:
          // Valor do campo de 1 a 10KG + Ad valorem (0,5%) sobre o valor da nota fiscal + Gris + Icms  
          ElseIf nPesoPed <= 10
            	If !Empty(SZZ->ZZ_1A10KG) 
          			nFret_pes := SZZ->ZZ_1A10KG
          			If Alltrim( cTransp ) = "30"
          				nGRIS := ( nTotPed * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
						//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
						If !Empty(SZZ->ZZ_GRISMIN)
							If nGRIS <= SZZ->ZZ_GRISMIN
								nGRIS := SZZ->ZZ_GRISMIN
							Endif
						Endif
          				nFret_pes := SZZ->ZZ_1A10KG + ( nTotPed * 0.5 / 100 ) + nGRIS
          			Endif 
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif nPesoPed <= 20
          		If !Empty(SZZ->ZZ_11A20KG)
          			nFret_pes := SZZ->ZZ_11A20KG
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif nPesoPed <= 30
          		If !Empty(SZZ->ZZ_21A30KG)
          			nFret_pes := SZZ->ZZ_21A30KG
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif nPesoPed <= 40
          		If !Empty(SZZ->ZZ_31A40KG)
          			nFret_pes := SZZ->ZZ_31A40KG 
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif nPesoPed <= 50
          		If !Empty(SZZ->ZZ_41A50KG)
          			nFret_pes := SZZ->ZZ_41A50KG 
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif nPesoPed <= 60
          		If !Empty(SZZ->ZZ_51A60KG)
          			nFret_pes := SZZ->ZZ_51A60KG 
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif nPesoPed <= 70
          		If !Empty(SZZ->ZZ_61A70KG)
          			nFret_pes := SZZ->ZZ_61A70KG
          			Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif nPesoPed <= 80
          		If !Empty(SZZ->ZZ_71A80KG)
          			nFret_pes := SZZ->ZZ_71A80KG
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif nPesoPed <= 90
          		If !Empty(SZZ->ZZ_81A90KG)
          			nFret_pes := SZZ->ZZ_81A90KG
          		Else
          			nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Else
          	If !Empty(SZZ->ZZ_91A100K)
          		nFret_pes := SZZ->ZZ_91A100K          	
          	Else
          		nFret_pes := ( nPesoPed * SZZ->ZZ_FR_PESO )
          		
          	Endif          	
          
          Endif          
           
           //
           ///Modificação feita através do Chamado 001517 - 04/05/2010           
           	//TAXA FIXA
           	If !Empty(SZZ->ZZ_TXFIXA)
                // so considera taxa adm para primeira nota 
	     		nTaxaFixa := iif(n=1,SZZ->ZZ_TXFIXA,0)
	  		Endif
          	
          	//AD-VALOREM
          	If !Empty(SZZ->ZZ_ADVALOR)
	        	nAd_valoren := ( nTotPed * SZZ->ZZ_ADVALOR / 100 )	 
	        	         
			Elseif Alltrim( cTransp ) == "03" .and. Alltrim( SZZ->ZZ_LOCAL ) $ "07 09 20 59 94 46"
	      		nAd_valoren := ( nTotPed * 0.3 / 100 )
	      	Else
	      		nAd_valoren := 0
			Endif
			
			// TX FLUVIAL
			If !Empty(SZZ->ZZ_FLUVIAL)
	        	nFluvial := ( nTotPed * SZZ->ZZ_FLUVIAL / 100 )	 
	        Else
			    nFluvial := 0
			Endif
			
			
			//GRIS
			nGRIS := ( nTotPed * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
			//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
			If !Empty(SZZ->ZZ_GRISMIN)
				If nGRIS <= SZZ->ZZ_GRISMIN
					nGRIS := SZZ->ZZ_GRISMIN
				Endif
			Endif
			
			//ADM
			If !Empty(SZZ->ZZ_ADM)
				// so considera taxa adm para primeira nota 
				nADM := IIF(n=1,SZZ->ZZ_ADM,0) 
			Endif   
            
            //TDE
          	Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_TDE")
          	nTDE := IIF(SA1->A1_TDE>0,SA1->A1_TDE,SZZ->ZZ_TDE)  
          	
            //PEDAGIO E SUFRAMA
            If nPesoPed >= 100
	            Do Case
	            	Case ( nPesoPed >= 100 .And. nPesoPed < 101)
			            If !Empty(SZZ->ZZ_PEDAGIO)
			            	nPedagio := SZZ->ZZ_PEDAGIO
			            Endif
			            
			            If !Empty(SZZ->ZZ_SUFRAMA)
			            	nSuframa := SZZ->ZZ_SUFRAMA
			            Endif
	   	       		
	   	       		Case (nPesoPed >= 101 .And. nPesoPed <= 200 )
	   	       			If !Empty(SZZ->ZZ_PEDAGIO)
	   	       				nPedagio := ( SZZ->ZZ_PEDAGIO * 2 )
	   	       			Endif
	   	       			
	   	       			If !Empty(SZZ->ZZ_SUFRAMA)
	   	       				nSuframa := ( SZZ->ZZ_SUFRAMA * 2 )
	   	       			Endif
		  			
		  			Case (nPesoPed >= 201)
		  				If !Empty(SZZ->ZZ_PEDAGIO)
		  					nPedagio := ( nPesoPed / 100) * SZZ->ZZ_PEDAGIO
		  				Endif
		  				
		  				If !Empty(SZZ->ZZ_SUFRAMA)
		  					nSuframa := ( nPesoPed / 100) * SZZ->ZZ_SUFRAMA
		  				Endif
		  				
		  		Endcase
	  		            
	  		Endif
            
            //SE A SOMA DAS TAXAS FOR MENOR QUE O VALOR DO FRETE MÍNIMO, ASSUME O FRETE MÍNIMO
	      	If ( nFret_pes + nTaxaFixa + nAd_valoren + nGRIS + nADM + nPedagio + nSuframa + nTDE + nFluvial ) >= SA4->A4_FREMINI
                nFrete :=round( nFret_pes,2) + round(nTaxaFixa,2) + round(nAd_valoren,2) + round(nGRIS,2) + round(nADM,2) + round(nPedagio,2) + round(nSuframa,2) + round(nTDE,2)+ round(nFluvial,2) 	          	    
          	Else
          		nFrete := round(SA4->A4_FREMINI,2)          	
          	Endif 
	                  
          Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT, "A1_TIPO")
          
          IF ALLTRIM(M->C5_TRANSP)!='80' // TRANSPORTADORA AGAPE E SEMPRE ZERO 
             nFretIcms :=  ( nFrete / ( 1 - (IIF(ALLTRIM(SA1->A1_TIPO)<>'F',SA4->A4_ICMS,17) / 100) )  )
          ELSE
             nFretIcms :=  ( nFrete / ( 1 - (SA4->A4_ICMS / 100) )  )
          ENDIF
          nValDna   := nValDna + nTotPed
          nPerc     := ( nFretIcms * 100 / nValDna ) 
          
/*          aCols[n][nPosFrete]:=   round(nFretIcms,2) // FRETE COM ICMS 
          
          IF ALLTRIM(M->C5_TRANSP)!='80' // TRANSPORTADORA AGAPE E SEMPRE ZERO 
              aCols[n][nPosICMS]:=IIF(ALLTRIM(SA1->A1_TIPO)<>'F',SA4->A4_ICMS,17) 
          ELSE
              aCols[n][nPosICMS]:=SA4->A4_ICMS  
	      ENDIF

	      aCols[n][nPosFSICMS]:= round(nFrete,2) // FRETE SEM ICMS
	     
	      If xFilial("SF2") != '03'    //SE NÃO FOR FILIAL CAIXAS, SEGUE NORMAL
	         aCols[n][nPosFREPES]:=round(nFret_pes,2)         
	      Elseif xFilial("SF2") = '03' 
	         If nPesoPed > nVlrCubagem
		        aCols[n][nPosFREPES]:=round(nFret_pes,2)
		     Else
		        aCols[n][nPosFREPES]:= round((nVlrCubagem * SZZ->ZZ_FR_PESO),2)
		     Endif
	      Endif

	      aCols[n][nPosTXFIXA]:= round(nTaxaFixa,2)
	      aCols[n][nPosADVALO]:= round(nAd_valoren,2) 
	      aCols[n][nPosflu]:= round(nFluvial,2) 
	      aCols[n][nPosGRIS]:= round(nGRIS,2)	
	      aCols[n][nPosADM]:= round(nADM,2)		
	      aCols[n][nPosTDE]:= round(nTDE,2)		
	      aCols[n][ nPosPEDAGI]:= round(nPedagio,2)	
	      aCols[n][nPosSUFRAM]:= round(nSuframa,2) 
	      aCols[n][nPosVALOR]:=nTotPed  	       
	                         
          
          oSayT:SetText(transform( fValor() ,'@E 999,999.99')) 
          ObjectMethod( oSayT, "Refresh()" )
*/          
          //Return nFretIcms
       
       //enddo
    //Enddo    
Next


Return nFretIcms

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fUltCondPG  º Autor ³ Gustavo Costa  º Data ³  14/02/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna a ultima condicao de pagamento do cliente.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fUltCondPG(cCli, cLoja)

local cQry		:= ''
Local cRet		:= ""

cQry:=" SELECT TOP 1 F2_COND COND "
cQry+=" FROM " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) "
cQry+=" INNER JOIN " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " 
cQry+=" ON D2_FILIAL = F2_FILIAL " 
cQry+=" AND D2_DOC = F2_DOC " 
cQry+=" AND D2_SERIE = F2_SERIE " 
cQry+=" WHERE SD2.D_E_L_E_T_ = '' "
cQry+=" AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) " 
cQry+=" AND D2_CLIENTE IN ('" + cCli + "') "
cQry+=" ORDER BY D2_EMISSAO DESC "

If Select("TMP9") > 0
	DbSelectArea("TMP9")
	TMP9->(DbCloseArea())	
EndIf

TCQUERY cQry NEW ALIAS  "TMP9"

dbSelectArea("TMP9")
TMP9->(dbGoTop())

If Select("TMP9") > 0

	cRet := TMP9->COND

EndIf

TMP9->(dbclosearea())

Return cRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fMedCompra ³ Autor :Gustavo Costa        ³ Data :21/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :  Mostra a Média de compra dos ultimos 3 meses              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fMedCompra(cCli, cLoja)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0

Private coTbl7

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg5","oBrw5","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

oTbl7()

cQry:=" SELECT D2A.D2_CLIENTE + D2A.D2_LOJA COD, AVG((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN) MEDIA, "
cQry+=" ISNULL((SELECT TOP 1 substring(C5_EMISSAO,7,2) + '/' + substring(C5_EMISSAO,5,2) + '/' + substring(C5_EMISSAO,1,4) FROM SD2020 D2 "
cQry+=" INNER JOIN SC5020 SC5 WITH (NOLOCK) ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM  "
cQry+=" WHERE D2_CLIENTE + D2_LOJA = D2A.D2_CLIENTE + D2A.D2_LOJA AND D2.D_E_L_E_T_ <> '*' "
cQry+=" 		AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQry+=" 		AND D2_QUANT-D2_QTDEDEV > 0 "
cQry+=" 		ORDER BY D2_EMISSAO DESC ),'') DATA_ULTCOM, "

cQry+=" ISNULL((SELECT TOP 1 F2_VALBRUT FROM SD2020 D2 "
cQry+=" INNER JOIN SC5020 SC5 WITH (NOLOCK) ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM " 
cQry+=" INNER JOIN SF2020 SF2 WITH (NOLOCK) ON D2_FILIAL + D2_DOC = F2_FILIAL + F2_DOC  "
cQry+=" WHERE D2_CLIENTE + D2_LOJA = D2A.D2_CLIENTE + D2A.D2_LOJA AND D2.D_E_L_E_T_ <> '*' "
cQry+=" 		AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQry+=" 		AND D2_QUANT-D2_QTDEDEV > 0 "
cQry+=" 		ORDER BY D2_EMISSAO DESC ),'') VAL_ULTCOM "
cQry+="  FROM SD2020 D2A "
cQry+=" INNER JOIN SC5020 SC5 WITH (NOLOCK) ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM " 
cQry+=" INNER JOIN SF2020 SF2 WITH (NOLOCK) ON D2_FILIAL + D2_DOC = F2_FILIAL + F2_DOC " 
cQry+=" WHERE D2A.D_E_L_E_T_ <> '*' "
cQry+=" AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQry+=" AND D2_CLIENTE + D2_LOJA = '" + cCli + cLoja + "' "
cQry+=" AND C5_EMISSAO BETWEEN '" + DtoS(ddatabase - 91) + "' AND '" + DtoS(ddatabase - 1) + "' "
cQry+=" GROUP BY D2A.D2_CLIENTE + D2A.D2_LOJA "


TCQUERY cQry NEW ALIAS  "TMP7"

dbSelectArea("TMP7")
TMP7->(dbGoTop())

While TMP7->(!EOF())

	RecLock("X90D", .T.)
	
	X90D->MEDIA		:= TMP7->MEDIA
	X90D->DATAUC	:= CtoD(TMP7->DATA_ULTCOM)
	X90D->VALORUC	:= TMP7->VAL_ULTCOM
	
	X90D->(MsUnLock())
		
	TMP7->(dbSkip())
	
EndDo

TMP7->(dbclosearea())

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg7      := MSDialog():New( 241,176,451,1103,"MEDIA 90 DIAS - DATA E VALOR DA ULTIMA COMPRA",,,.F.,,,,,,.T.,,,.F. )


X90D->(dbGoTop())
DbSelectArea("X90D")
oBrw7      := MsSelect():New( "X90D","","",{{"MEDIA"	,"","Media 90D","@E 9,999,999.99"},;
											{"VALORUC"	,"","Val. Ult.C.","@E 9,999,999.99"},;
											{"DATAUC"	,"","Data Ult.C.",""}},.F.,,{001,001,090,461},,, oDlg7 ) 
oBrw7:oBrowse:nClrPane := CLR_BLACK
oBrw7:oBrowse:nClrText := CLR_BLACK

oDlg7:Activate(,,,.T.)

X90D->(DbCloseArea())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl7() - Cria temporario para o Alias: X90D
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl7()

Local aFds := {}

Aadd( aFds , {"MEDIA"  	,"N",014,002} )
Aadd( aFds , {"VALORUC"	,"N",014,002} )
Aadd( aFds , {"DATAUC" ,"D",008,000} )

If Select("X90D") > 0
	DbSelectArea("X90D")
	X90D->(DbCloseArea())	
EndIf

coTbl7 := CriaTrab( aFds, .T. )
Use (coTbl7) Alias X90D New Exclusive

Return 


User Function MT410TOK()

Local lRet         	:= .T.				// Conteudo de retorno
Local cMsg         	:= ""				// Mensagem de alerta
Local nOpc         	:= PARAMIXB[1]	// Opcao de manutencao
Local aRecTiAdt 	:= PARAMIXB[2]	// Array com registros de adiantamentoc
Local aAreaSC9		:= getArea("SC9")
Local cPedido       := SC5->C5_NUM				// Mensagem de alerta

If SC5->C5_TIPO = 'N'

	dbSelectArea("SC9")
	SC9->(DBSETORDER(1))

	If SC9->(Dbseek(xFilial("SC9") + cPedido )) 

		While SC9->(!EOF()) .AND. SC9->C9_FILIAL == xFilial("SC9") .AND. SC9->C9_PEDIDO == cPedido
			
			Reclock("SC9",.F.)
			
			If SC9->C9_CLIENTE $ ('031732/031733/006543/007005')

				SC9->C9_BLCRED	:= "" 
				SC9->C9_BLEST 	:= ""
				SC9->C9_USRLBCR := "MT410TOK"
			Else
				SC9->C9_BLCRED:= "01" 
			Endif
			
			SC9->(MsUnlock())
			SC9->(DBSKIP())
		Enddo
	EndIf
	
	RestArea(aAreaSC9)

EndIf

Return(lRet)
