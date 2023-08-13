#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110LOK º Autor ³ Flávia Rocha       º Data ³  30/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida a inclusão do Produto na SC                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MT110LOK - valida a inclusão da linha na GetDados          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
LOCALIZAÇÃO : Function A110LinOk() responsável pela validação de cada linha
da GetDados da Solicitação de Compras .
EM QUE PONTO : O ponto se encontra no final da função e deve ser utilizado 
para validações especificas do usuario onde será controlada pelo retorno 
do ponto de entrada o qual se for .F. o processo será interrompido 
e se .T. será validado.
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/



***********************
User Function MT110LOK
***********************

Local lOK 		:= .T.
Local cProduto	:= aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_PRODUTO" } )]
Local lBloqPto  := GetMv("RV_BLQPTO")  
Local nLote     := 0

Private cString := "SC1"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBloqPto
	SB1->(Dbsetorder(1))
	If SB1->(Dbseek(xFilial("SB1") + cProduto ))
		If SM0->M0_CODFIL = "01"
		   	nLote := SB1->B1_EMIN       	
		Elseif SM0->M0_CODFIL = "03"
		   	nLote := SB1->B1_EMINCX
		Else
		  	nLote := 0
		Endif
		If nLote > 0  //se tiver pto pedido
			Aviso("M E N S A G E M", "Este Produto Possui Ponto de Pedido, Inclusão Manual na SC não Permitida!!" + CHR(13) + CHR(10);
			   + "Somente Com a Senha do Diretor Poderá ser Liberado.", {"OK"})
			lOk := U_senha2( "28", 5 )[ 1 ] 
			//Alert("Este Produto possui Ponto de Pedido, Inclusão manual na SC não Permitida!!")
			   
			If !lOk
				Alert("Acesso Negado !!!")	
			Endif
		Endif
	//Else
		//Alert("Produto não é pto pedido")
	Endif
Endif  //se bloqueia
Return(lOk)
