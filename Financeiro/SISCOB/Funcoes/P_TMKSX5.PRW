#include "rwmake.ch"
#include "topconn.ch"

*************

User Function TMKSX5()

*************

U_ManutSX5( "ZJ    *ZS    *ZT    *ZV    *ZX    *ZP    *ZR    *" )
Return NIL



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ManutSX5³ Autor ³ Eveli Morasco           ³ Data ³ 12/09/92 ³±±
±± Alterada por ³ Mauricio Barros                       ³ Data ³ 27/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de manutencao de uma tabela                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
/*
User Function MANUTSX5( cFILTRO )

LOCAL cArquivo,cIndex,cSixChave

PRIVATE aRotina := { { "Pesquisar" , "AxPesqui"  , 0 , 1},;
				         { "Visualizar", "C160Visual", 0 , 2},;
	 						{ "Alterar",    "C160Altera", 0 , 4} }

cCadastro := OemToAnsi( "Tabelas" )
DbSelectArea( "SX5" )
Set filter To ( X5_TABELA $ cFILTRO .or. X5_CHAVE $ cFILTRO )
DbGotop()
mBrowse( 06, 01, 22, 75, "SX5" )
Set filter To
Return NIL
*/
