#include "rwmake.ch"
#include "colors.ch"

User Function TMK001_4()

oDlg4 := MSDIALOG():Create()
oDlg4:cName := "oDlg4"
oDlg4:cCaption := "Consulta produtos do pedido/nota"
oDlg4:nLeft := 0
oDlg4:nTop := 0
oDlg4:nWidth := 660
oDlg4:nHeight := 234
oDlg4:lShowHint := .F.
oDlg4:lCentered := .T.

oSBtn1 := SBUTTON():Create(oDlg4)
oSBtn1:cName := "oSBtn1"
oSBtn1:cCaption := "oSBtn1"
oSBtn1:nLeft := 291
oSBtn1:nTop := 178
oSBtn1:nWidth := 55
oSBtn1:nHeight := 25
oSBtn1:lShowHint := .F.
oSBtn1:lReadOnly := .F.
oSBtn1:Align := 0
oSBtn1:lVisibleControl := .T.
oSBtn1:nType := 1
oSBtn1:bAction := {|| PedConf() }

oSBtn2 := SBUTTON():Create(oDlg4)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "oSBtn2"
oSBtn2:nLeft := 383
oSBtn2:nTop := 178
oSBtn2:nWidth := 55
oSBtn2:nHeight := 25
oSBtn2:lShowHint := .F.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 2
oSBtn2:bAction := {|| Sair4() }

oSBtn3 := TBUTTON():Create(oDlg4)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "&Todos"
oSBtn3:nLeft := 202
oSBtn3:nTop := 178
oSBtn3:nWidth := 55
oSBtn3:nHeight := 25
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:bAction := {|| PedTodos() }

Return NIL
