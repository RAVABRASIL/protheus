#INCLUDE "rwmake.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Emmanuel Lacerda                         ³ Data ³ 01/12/06 ³±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descricao³ Calcula o a media das NF de Entrada dos produtos que       ³±±
±±³         ³ compoem o PA (Produto Acabado), ou seja Materia Prima,     ³±±
±±³         ³ Acessorios, etc.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Formacao de Precos - Custo/Estoque                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


**********

User Function ESTATPR()

**********

SetPrvt( "CARQ,CCONTEUDO,ODLG,oSBtn1,oSBtn2,oSAY1,oSay2,cSCRIPT," )

@ 00,000 To 50,300 Dialog oDlg1 Title "Calculo de media de precos, deseja continuar?"
@ 10,040 BUTTON "SIM" Action Processa( { |lEnd| Atualiza() } )
@ 10,080 BUTTON "NAO" Action  ( oDlg1:END() )
Activate Dialog oDlg1 Center

Return Nil


**********

Static Function Atualiza()

**********

Pergunte("ESTATP",.T.)
SetPrvt("cQuery,nPrec,oOBJ")

cQuery := "SELECT SB1.B1_COD "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1 "
cQuery += "WHERE SB1.B1_COD >= '" + alltrim(mv_par01) + "' AND SB1.B1_COD <= '" + alltrim(mv_par02) + "' AND SB1.B1_ATIVO = 'S' "

If ! (alltrim(mv_par03) == "" .OR. upper(mv_par03) == "ZZ")
  cQuery += "and SB1.B1_TIPO = '" + upper(mv_par03) + "' "
EndIf

cQuery += "AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ != '*' "
cQuery += "order by SB1.B1_COD asc"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SB1X"

SB1X->( DbGoTop() )
count to nREGTOT while SB1X->B1_COD <= MV_PAR02
ProcRegua( nREGTOT)
SB1X->( DbGoTop() )

If MsgBox( OemToAnsi( alltrim(str(nREGTOT)) + " registros serao alterados, continuar?" ), "Escolha", "YESNO" )
	Do While ! SB1X->( EoF() )

		nPrec := U_CALPREAC( SB1X->B1_COD, 1 )
		DBSelectArea( "SB1" )
		SB1->( DBSetOrder(1) )
		SB1->( DBSeek( xFilial("SB1") + SB1X->B1_COD) )

	  If RecLock( "SB1", .F. )
	 		SB1->B1_UPRC := nPrec
	 		SB1->( MsUnlock() )
	 		SB1->( DBCommit() )
	  Else
	   	MsgAlert( "Nao foi possivel travar o registro do produto: " + alltrim( SD1->D1_COD ) + "Preco nao atualizado!!!" )
	  EndIf

		DBCloseArea("SB1")
		IncProc("Atualizando registros...")
		SB1X->( DBSkip() )
	EndDo
EndIf

SB1X->( DbCloseArea() )

Return oDlg1:END()
