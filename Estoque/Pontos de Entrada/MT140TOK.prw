#INCLUDE "RWMAKE.CH"

/* 
PONTO DE ENTRADA : MT140TOK
Localização: Function MA140Tudok() - Responsável por validar 
             todos os itens do pré-documento  
Finalidade : Este ponto é executado após verificar se existem itens
             a serem gravados e tem como objetivo validar 
             todos os itens do pré-documento, vai validar nesse caso específico, se a 
             entrada em questão possui um pedido de compra.
*/

************************
User Function MT140TOK
************************

Local lRetorno := PARAMIXB[1]  
Local lRet:=.T.
Local cPedido := ""
//Local cTipo   := "" //C103TIPO   A VARIÁVEL DO TIPO É DO PRÓPRIO FONTE, ENTÃO VOU UTILIZÁ-LA
Local aNFE    := {}
Local aDiverg := {} 
Local cItem   := ""
Local nQuant  := 0
Local nPreco  := 0
Local cMsg    := ""
Local lDiverg := .F.
Local lSenha  := .F.


//MSGBOX("opção: " + str(nOpc) )

If Inclui
	For x:= 1 to Len(aCols)		
		If !(aCols[x,Len(aHeader)+1]) //se a linha do acols não estiver deletada		
			If !cTipo $"D/B"       //se o tipo da nota não for Devolução / Beneficiamento			
				If !Empty( aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_PEDIDO" }) ] )			
					cPedido:=	aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_PEDIDO" }) ]
				Endif			
		    Endif
		Endif
	Next
	
	//checagem do pedido    
	If Empty(Alltrim(cPedido))
		cMsg := "É Necessário um Pedido de Compra para Incluir uma Pré-Nota !"
	    lRet := .F.		
	Endif  //endif do cPedido vazio
	
	If !lRet
		Alert(cMsg)
	Endif


Endif

Return lRet