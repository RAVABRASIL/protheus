#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :24/11/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTPRCT()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc := GD_UPDATE//GD_INSERT+GD_DELETE+
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private noBrw1  := 0
Pergunte("ESTPRC",.T.)
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oGrp1","oGrp2","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 238,418,532,905,"Sequências de Corte",,,.F.,,,,,,.T.,,,.T. )
MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(004,004,112,237,nOpc,'AllwaysTrue()','AllwaysTrue()','',{"Z03_ORDCTE"},0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 )
oGrp1      := TGroup():New( 000,002,116,239,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 116,002,144,239,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 124,080,"&Salvar",oGrp2,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || Salvar()    }
oBtn2      := TButton():New( 124,128,"&Cancelar",oGrp2,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := { || oDlg1:End() }


oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: Z03
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

Local cFCols := "Z03_NUM/Z03_COD/Z03_NUMOP/Z03_ORDCTE/"

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("Z03")
While !Eof() .and. SX3->X3_ARQUIVO == "Z03"
   If cNivel >= SX3->X3_NIVEL .and. Alltrim(SX3->X3_CAMPO) $ cFCols 
      noBrw1++
      Aadd(aHoBrw1,;
         { Trim(X3Titulo()),;
           X3_CAMPO,;
           X3_PICTURE,;
           X3_TAMANHO,;
           X3_DECIMAL,;
           X3_VALID,;
           X3_USADO,;
           X3_TIPO,;
           X3_ARQUIVO,;
           X3_CONTEXT,;
           X3_NIVEL,;
           X3_RELACAO,;
           Trim(X3_INIBRW) } )
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: Z03
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1()

Local aAux := {}
Local cQuery := ""
cQuery := "select Z03_NUM, Z03_COD, Z03_NUMOP, Z03_ORDCTE "
cQuery += "from   "+retSqlName("Z03")+" "
cQuery += "where  Z03_ORDCTE >= 0 and Z03_NUMOP != '' "
cQuery += "and Z03_NUM between '"+mv_par01+"' and '"+mv_par02+"' "
cQuery += "order by Z03_NUM , Z03_ORDCTE "
TCQUERY cQuery NEW ALIAS "_TMPX"
_TMPX->( dbGoTop() )

do while _TMPX->( !EoF() )
	Aadd(aCoBrw1,Array(noBrw1+1))
	For nI := 1 To noBrw1
		aCoBrw1[len(aCoBrw1)][nI] := CriaVar(aHoBrw1[nI][2])
		if alltrim(aHoBrw1[nI][2]) == 'Z03_NUM'
			aCoBrw1[len(aCoBrw1)][nI] := _TMPX->Z03_NUM
		elseIF alltrim(aHoBrw1[nI][2]) == 'Z03_COD'
			aCoBrw1[len(aCoBrw1)][nI] := _TMPX->Z03_COD
		elseIF alltrim(aHoBrw1[nI][2]) == 'Z03_NUMOP'
			aCoBrw1[len(aCoBrw1)][nI] := _TMPX->Z03_NUMOP
		elseIF alltrim(aHoBrw1[nI][2]) == 'Z03_ORDCTE'
			aCoBrw1[len(aCoBrw1)][nI] := _TMPX->Z03_ORDCTE
		endIf
	Next
	aCoBrw1[len(aCoBrw1)][noBrw1+1] := .F.
   _TMPX->( dbSkip() )
endDo
_TMPX->( dbCloseArea() )

Return

***************

Static Function Salvar()

***************
Local nCont := 0

dbSelectArea("Z03")
for _x := 1 to len(oBrw1:Acols)
	if oBrw1:Acols[_x][4] > 0
		Z03->( dbSeek( xFilial("Z03") + oBrw1:Acols[_x][1] + oBrw1:Acols[_x][2] ,.F. ) )
		RecLock("Z03",.F.)
		Z03->Z03_ORDCTE := oBrw1:Acols[_x][4]
		Z03->(MSUnlock())
		nCont++
	endIf
next
msgAlert( alltrim(str(nCont)) + " registros atualizados!" )

Return