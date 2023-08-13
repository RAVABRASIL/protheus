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
User Function COPYLOT1()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
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

cQuery := "SELECT  "

cQuery += "CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_DC,CT2_DEBITO,"
cQuery += "CT2_CREDIT,CT2_DCD,CT2_DCC,CT2_MOEDLC,CT2_VLR01,CT2_MOEDAS,CT2_HP,CT2_HIST,"
cQuery += "CT2_CRITER,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_VLR02,"
cQuery += "CT2_VLR03,CT2_VLR04,CT2_VLR05,CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI,"
cQuery += "CT2_INTERC,CT2_IDENTC,CT2_TPSALD,CT2_SEQUEN,CT2_MANUAL,CT2_ORIGEM,CT2_ROTINA,"
cQuery += "CT2_AGLUT,CT2_LP,CT2_SEQHIS,CT2_SEQLAN,CT2_DTVENC,CT2_VALOR,CT2_SLBASE,CT2_DTLP,"
cQuery += "CT2_DATATX,CT2_TAXA,CT2_CRCONV,D_E_L_E_T_,CT2_KEY,CT2_SEGOFI,CT2_DTCV3,CT2_SEQIDX,"
cQuery += "CT2_MLTSLD,CT2_CTLSLD,CT2_CODPAR "

cQuery += "FROM CT2" + StrZero( MV_PAR01, 2 ) + "0 "
cQuery += "WHERE CT2_LOTE >= '" + mv_par02 + "' AND CT2_LOTE <= '" + mv_par03 + "' AND "
cQuery += "CT2_DOC >= '" + mv_par04 + "' AND CT2_DOC <= '" + mv_par05 + "' AND "
cQuery += "CT2_DATA >= '" + Dtos( mv_par06 ) + "' AND CT2_DATA <= '" + Dtos( mv_par07 ) + "' AND "
cQuery += "CT2_FILIAL = '" + xFilial( "CT2" ) + "' AND D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "CT2X"

TCSetField( 'CT2X', "CT2_VALOR",   "N", 12, 2 )
TCSetField( 'CT2X', "CT2_VLMOED2", "N", 12, 2 )
TCSetField( 'CT2X', "CT2_VLMOED3", "N", 12, 2 )
TCSetField( 'CT2X', "CT2_VLMOED4", "N", 12, 2 )
TCSetField( 'CT2X', "CT2_VLMOED5", "N", 12, 2 )

DbSelectArea("CT2")

Begin Transaction

aESTRU := CT2X->( DbStruct() )
while !CT2X->(EOF())
   RecLock("CT2",.T.)
   for nCONT := 1 to len( aESTRU )
	  CT2->( FieldPut( nCONT, CT2X->( FieldGet( nCONT ) ) ) )
   next   
   CT2->(msunlock())
   CT2X->(DbSkip())
end

end Transaction
/*
cARQ := criatrab( .F., .F. )
Copy To ( cARQ )
CT2X->( DbCloseArea() )
DbSelectArea( "CT2" )
DbSetOrder(1)
Append From ( cARQ )
*/
Return NIL
