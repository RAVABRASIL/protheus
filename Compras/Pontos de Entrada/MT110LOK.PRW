#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110LOK � Autor � Fl�via Rocha       � Data �  30/05/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a inclus�o do Produto na SC                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MT110LOK - valida a inclus�o da linha na GetDados          ���
�������������������������������������������������������������������������ͼ��
LOCALIZA��O : Function A110LinOk() respons�vel pela valida��o de cada linha
da GetDados da Solicita��o de Compras .
EM QUE PONTO : O ponto se encontra no final da fun��o e deve ser utilizado 
para valida��es especificas do usuario onde ser� controlada pelo retorno 
do ponto de entrada o qual se for .F. o processo ser� interrompido 
e se .T. ser� validado.
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/



***********************
User Function MT110LOK
***********************

Local lOK 		:= .T.
Local cProduto	:= aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_PRODUTO" } )]
Local lBloqPto  := GetMv("RV_BLQPTO")  
Local nLote     := 0

Private cString := "SC1"
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
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
			Aviso("M E N S A G E M", "Este Produto Possui Ponto de Pedido, Inclus�o Manual na SC n�o Permitida!!" + CHR(13) + CHR(10);
			   + "Somente Com a Senha do Diretor Poder� ser Liberado.", {"OK"})
			lOk := U_senha2( "28", 5 )[ 1 ] 
			//Alert("Este Produto possui Ponto de Pedido, Inclus�o manual na SC n�o Permitida!!")
			   
			If !lOk
				Alert("Acesso Negado !!!")	
			Endif
		Endif
	//Else
		//Alert("Produto n�o � pto pedido")
	Endif
Endif  //se bloqueia
Return(lOk)
