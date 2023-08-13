#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
LOCALIZA��O : Function MontEstru() - Respons�vel por montar array com estrutura do produto.
EM QUE PONTO : � chamado antes de iniciar a grava��o dos empenhos na abertura de uma ordem de produ��o. 
Utilizado para incluir, alterar ou excluir itens que sejam empenhados na abertura da Ordem de Produ��o.
Finalidade: Altera��o de Itens Empenhados na Abertura da OP.
 
Observa��es
N�o recebe par�metros, por�m neste momento o array aCols que � apresentado na altera��o de empenhos quando se abre uma Ordem de Produ��o est� dispon�vel para altera��es.
O aCols apresenta neste momento as linhas e colunas preenchidas, de acordo com o empenho padr�o a ser efetuado no Sistema.
Basta alterar ou incluir o conte�do deste array para alterar as informa��es dos empenhos. A estrutura b�sica do array aCols � apresentada da seguinte forma na vers�o 2.07/5.08:

aCols[n,x] - Onde o n e o  n�mero da linha  e x pode ser:
[1] C�digo do Produto a ser empenhado
[2] Quantidade do empenho
[3] Almoxarifado do empenho
[4] Sequ�ncia do componente na estrutura (Campo G1_TRT)
[5] Sub-Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade do tipo "S")
[6] Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade)
[7] Data de validade do Lote (Somente deve ser preenchido se o  produto utilizar rastreabilidade)
[8] Localiza��o utilizada no empenho (Somente deve ser preenchido se o produto utilizar controle de localiza��o f�sica) 
[9] N�mero de S�rie (Somente deve ser preenchido se o produto utilizar controle de localiza��o f�sica)
[10] 1a. Unidade de Medida do Produto
[11] Quantidade do Empenho na 2a. Unidade de Medida
[12] 2a. Unidade de Medida do Produto
[13] Coluna com valor l�gico que indica se a linha est� deletada (.T.) ou n�o (.F.)

Vale ressaltar que as colunas que n�o forem preenchidas, devem ser inicializadas com a fun��o Criavar dos respectivos campos. Basta pesquisar qual o campo tomado como base para cria��o das colunas.

Neste ponto est� dispon�vel tamb�m o Array aColsDele, que indica quais linhas do array aCols est�o deletadas atrav�s de seu conte�do num�rico.


*/

*************

User Function EMP650()

*************
   
If  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "03" // filial caixa
	for x:=1 to LEN(acols)
		aCols[x,3]:= GETMV('MV_ALMOPRO')
	Next
Endif	

Return 
