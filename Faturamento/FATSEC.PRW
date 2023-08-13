
User Function FATSEC()

//If Subs( SB1->B1_COD, 4, 1 ) == "R"
If Subs( SB1->B1_COD, 4, 1 ) $ "R/D"
	_cCodSec := Subs( M->C6_PRODUTO, 1, 1 ) + "D" + Subs( M->C6_PRODUTO, 2, 4 ) + "6";	
   		      + Subs( M->C6_PRODUTO, 6, 2 ) 
Else
	_cCodSec := Subs( M->C6_PRODUTO, 1, 1 ) + "D" + Subs( M->C6_PRODUTO, 2, 3 ) + "6";
   		      + Subs( M->C6_PRODUTO, 5, 2 ) 
EndIf   		      

Return( xFilial("SB1")+_cCodSec )


User Function NewFATSEC()

//Se NÃO for XDD ou Venda de apara
IF M->C5_DESC1 = 0 .OR. ALLTRIM(M->C6_PRODUTO) $ "188/189/190"

	_cCodSec := M->C6_PRODUTO

Else
	//Se o codigo já tiver transformando nao faz nada
	If Len(ALLTRIM(M->C6_PRODUTO)) >=8
		_cCodSec := M->C6_PRODUTO
	Else
		If Subs( M->C6_PRODUTO, 4, 1 ) $ "R/D"
			_cCodSec := Subs( M->C6_PRODUTO, 1, 1 ) + "D" + Subs( M->C6_PRODUTO, 2, 4 ) + "6";	
		   		      + Subs( M->C6_PRODUTO, 6, 2 ) 
		Else
			_cCodSec := Subs( M->C6_PRODUTO, 1, 1 ) + "D" + Subs( M->C6_PRODUTO, 2, 3 ) + "6";
		   		      + Subs( M->C6_PRODUTO, 5, 2 ) 
		EndIf   		      
	EndIf

EndIf

Return _cCodSec 