/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³fUF       ³ Autor ³ Eurivan Marques       ³ Data ³ 19/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Selecionar UFs com base no SX5                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fUF()                												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 	             											  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

static _cUFs_

*******************
User Function fUF()
*******************

Local cTitulo  := ""
Local MvPar
Local MvParDef := ""

Private aUFs:={}

cAlias := Alias() 					 // Salva Alias Anterior

mvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

dbSelectArea("SX5")
if dbSeek(cFilial+"0012")
   cTitulo := Alltrim(Left(X5Descri(),20))
endif

if dbSeek(cFilial+"12")
   CursorWait()
	while !Eof() .And. SX5->X5_Tabela == "12"
		if !Left(SX5->X5_Chave,2) $"EX/FL"
		   Aadd(aUFs,Left(SX5->X5_Chave,2) + " - " + Alltrim(X5Descri()))
		   MvParDef+=Left(SX5->X5_Chave,2) + ";"
		endif
		dbSkip()
	end
	CursorArrow()
endif
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
if f_Opcoes(@MvPar,cTitulo,aUFs,MvParDef,12,49,.F.,3) // Chama funcao f_Opcoes
   //&MvRet := mvpar //Devolve Resultado
   _cUFs_ := mvpar //Devolve Resultado   
endif	

dbSelectArea(cAlias) //Retorna Alias

Return .T.

*************************
user function RetUFs()
*************************

return _cUFs_
