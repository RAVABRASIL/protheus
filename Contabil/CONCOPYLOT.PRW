#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Mauricio de Barros Silva                 ³ Data ³ 09/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Copia lotes contabeis entre empresas                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Rava                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 MV_PAR01 = Empresa
 MV_PAR02 = Lote Inicial
 MV_PAR03 = Lote Final
 MV_PAR04 = Doc Inicial
 MV_PAR05 = Doc final
 MV_PAR06 = Data incial
 MV_PAR07 = Data Final
*/

*************
User Function COPYLOT()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
*************

SetPrvt( "cQUERY,")

If Pergunte( "COPLOT" )               // Pergunta no SX1
   If Val( cEMPANT ) == MV_PAR01
			MsgBox( "Empresa nao pode ser a mesma que voce esta", "info", "stop" )
	 else
      Processa( {|| OkProc() } )
	 Endif
EndIf
Return NIL



***************
Static Function OkProc()
***************

cQuery := "SELECT * FROM SI2" + StrZero( MV_PAR01, 2 ) + "0 "
cQuery += "WHERE I2_LOTE >= '" + mv_par02 + "' AND I2_LOTE <= '" + mv_par03 + "' AND "
cQuery += "I2_DOC >= '" + mv_par04 + "' AND I2_DOC <= '" + mv_par05 + "' AND "
cQuery += "I2_DATA >= '" + Dtos( mv_par06 ) + "' AND I2_DATA <= '" + Dtos( mv_par07 ) + "' AND "
cQuery += "I2_FILIAL = '" + xFilial( "SI2" ) + "' AND D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SI2X"

TCSetField( 'SI2X', "I2_VALOR",   "N", 12, 2 )
TCSetField( 'SI2X', "I2_VLMOED2", "N", 12, 2 )
TCSetField( 'SI2X', "I2_VLMOED3", "N", 12, 2 )
TCSetField( 'SI2X', "I2_VLMOED4", "N", 12, 2 )
TCSetField( 'SI2X', "I2_VLMOED5", "N", 12, 2 )

cARQ := criatrab( .F., .F. )
Copy To ( cARQ )
SI2X->( DbCloseArea() )
DbSelectArea( "SI2" )
Append From ( cARQ )
Return NIL
