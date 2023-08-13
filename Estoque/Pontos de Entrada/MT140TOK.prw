#INCLUDE "RWMAKE.CH"

/* 
PONTO DE ENTRADA : MT140TOK
Localiza��o: Function MA140Tudok() - Respons�vel por validar 
             todos os itens do pr�-documento  
Finalidade : Este ponto � executado ap�s verificar se existem itens
             a serem gravados e tem como objetivo validar 
             todos os itens do pr�-documento, vai validar nesse caso espec�fico, se a 
             entrada em quest�o possui um pedido de compra.
*/

************************
User Function MT140TOK
************************

Local lRetorno := PARAMIXB[1]  
Local lRet:=.T.
Local cPedido := ""
//Local cTipo   := "" //C103TIPO   A VARI�VEL DO TIPO � DO PR�PRIO FONTE, ENT�O VOU UTILIZ�-LA
Local aNFE    := {}
Local aDiverg := {} 
Local cItem   := ""
Local nQuant  := 0
Local nPreco  := 0
Local cMsg    := ""
Local lDiverg := .F.
Local lSenha  := .F.


//MSGBOX("op��o: " + str(nOpc) )

If Inclui
	For x:= 1 to Len(aCols)		
		If !(aCols[x,Len(aHeader)+1]) //se a linha do acols n�o estiver deletada		
			If !cTipo $"D/B"       //se o tipo da nota n�o for Devolu��o / Beneficiamento			
				If !Empty( aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_PEDIDO" }) ] )			
					cPedido:=	aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_PEDIDO" }) ]
				Endif			
		    Endif
		Endif
	Next
	
	//checagem do pedido    
	If Empty(Alltrim(cPedido))
		cMsg := "� Necess�rio um Pedido de Compra para Incluir uma Pr�-Nota !"
	    lRet := .F.		
	Endif  //endif do cPedido vazio
	
	If !lRet
		Alert(cMsg)
	Endif


Endif

Return lRet