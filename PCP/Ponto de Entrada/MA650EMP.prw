#Include 'Protheus.ch'

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MA650EMP
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/12/13 | Gustavo Costa     | PE para alterar o armazém dos empenhos para o de processo.
// ---------+-------------------+-----------------------------------------------------------
// LOCALIZAÇÃO : Function MontEstru() - Responsável por montar array com estrutura do produto.
// EM QUE PONTO : É executado no final da função MontEstru(Monta array com estrutura do produto)
// permite manipular informações de empenhos, op´s ou solicitação de compras geradas.


User Function A650LEMP

//Local aLinCol   := aClone(PARAMIXB[1])  	//Conteudo da linha do aCols possicionado
//Local cRetLocal := aLinCol[3]				//Verifca se o produto é 'MP' e o Armazém é '87' altera conteúdo para '20'

//If (aLinCol[1]=='MP'+Space(13)) .And. (aLinCol[3]=='87')       

cRetLocal := '02'

//EndIf

Return cRetLocal

