#Include 'Protheus.ch'

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MA650EMP
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/12/13 | Gustavo Costa     | PE para alterar o armaz�m dos empenhos para o de processo.
// ---------+-------------------+-----------------------------------------------------------
// LOCALIZA��O : Function MontEstru() - Respons�vel por montar array com estrutura do produto.
// EM QUE PONTO : � executado no final da fun��o MontEstru(Monta array com estrutura do produto)
// permite manipular informa��es de empenhos, op�s ou solicita��o de compras geradas.


User Function A650LEMP

//Local aLinCol   := aClone(PARAMIXB[1])  	//Conteudo da linha do aCols possicionado
//Local cRetLocal := aLinCol[3]				//Verifca se o produto � 'MP' e o Armaz�m � '87' altera conte�do para '20'

//If (aLinCol[1]=='MP'+Space(13)) .And. (aLinCol[3]=='87')       

cRetLocal := '02'

//EndIf

Return cRetLocal

