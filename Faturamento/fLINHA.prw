/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³fLINHA    ³ Autor ³ Eurivan Marques       ³ Data ³ 28/10/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Selecionar LINHAS DE PRODUTO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fLINHA()             												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 	             											  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

static _cLINHAs_

**********************
User Function fLINHA()
**********************

Local cTitulo  := ""
Local MvPar
Local MvParDef := ""

Private aLinhas := {}

cAlias := Alias() 					 // Salva Alias Anterior

mvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

cTitulo := "LINHAS DE PRODUTOS"

Aadd(aLINHAs,"INST - INSTITUCIONAL")
Aadd(aLINHAs,"HOSP - HOSPITALAR")
Aadd(aLINHAs,"DOME - DOMESTICA")
MvParDef += "INST;HOSP;DOME;"

/*
Function f_Opcoes(	uVarRet			,;	//Variavel de Retorno
					      cTitulo			,;	//Titulo da Coluna com as opcoes
							aOpcoes			,;	//Opcoes de Escolha (Array de Opcoes)
							cOpcoes			,;	//String de Opcoes para Retorno
							nLin1			   ,;	//Nao Utilizado
							nCol1			   ,;	//Nao Utilizado
							l1Elem			,;	//Se a Selecao sera de apenas 1 Elemento por vez
							nTam			   ,;	//Tamanho da Chave
							nElemRet		   ,;	//No maximo de elementos na variavel de retorno
							lMultSelect		,;	//Inclui Botoes para Selecao de Multiplos Itens
							lComboBox		,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
							cCampo			,;	//Qual o Campo para a Montagem do aOpcoes
							lNotOrdena		,;	//Nao Permite a Ordenacao
							lNotPesq		   ,;	//Nao Permite a Pesquisa	
							lForceRetArr   ,;	//Forca o Retorno Como Array
							cF3				 ;	//Consulta F3	
				  		)
*/
if f_Opcoes(@MvPar,cTitulo,aLINHAs,MvParDef,12,49,.F.,5) // Chama funcao f_Opcoes
   //&MvRet := mvpar //Devolve Resultado
   _cLINHAs_ := mvpar //Devolve Resultado   
endif	

dbSelectArea(cAlias) //Retorna Alias

Return .T.

*************************
user function RetLINHAs()
*************************

return _cLINHAs_