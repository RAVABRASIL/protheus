#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
LOCALIZAÇÃO : Function MontEstru() - Responsável por montar array com estrutura do produto.
EM QUE PONTO : É chamado antes de iniciar a gravação dos empenhos na abertura de uma ordem de produção. 
Utilizado para incluir, alterar ou excluir itens que sejam empenhados na abertura da Ordem de Produção.
Finalidade: Alteração de Itens Empenhados na Abertura da OP.
 
Observações
Não recebe parâmetros, porém neste momento o array aCols que é apresentado na alteração de empenhos quando se abre uma Ordem de Produção está disponível para alterações.
O aCols apresenta neste momento as linhas e colunas preenchidas, de acordo com o empenho padrão a ser efetuado no Sistema.
Basta alterar ou incluir o conteúdo deste array para alterar as informações dos empenhos. A estrutura básica do array aCols é apresentada da seguinte forma na versão 2.07/5.08:

aCols[n,x] - Onde o n e o  número da linha  e x pode ser:
[1] Código do Produto a ser empenhado
[2] Quantidade do empenho
[3] Almoxarifado do empenho
[4] Sequência do componente na estrutura (Campo G1_TRT)
[5] Sub-Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade do tipo "S")
[6] Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade)
[7] Data de validade do Lote (Somente deve ser preenchido se o  produto utilizar rastreabilidade)
[8] Localização utilizada no empenho (Somente deve ser preenchido se o produto utilizar controle de localização física) 
[9] Número de Série (Somente deve ser preenchido se o produto utilizar controle de localização física)
[10] 1a. Unidade de Medida do Produto
[11] Quantidade do Empenho na 2a. Unidade de Medida
[12] 2a. Unidade de Medida do Produto
[13] Coluna com valor lógico que indica se a linha está deletada (.T.) ou não (.F.)

Vale ressaltar que as colunas que não forem preenchidas, devem ser inicializadas com a função Criavar dos respectivos campos. Basta pesquisar qual o campo tomado como base para criação das colunas.

Neste ponto está disponível também o Array aColsDele, que indica quais linhas do array aCols estão deletadas através de seu conteúdo numérico.


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
