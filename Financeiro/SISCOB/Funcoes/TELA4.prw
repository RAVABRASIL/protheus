User Function IoDlg4()

Local oDlg4,oSBtn1,oSBtn2
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
oSBtn1:nLeft := 268
oSBtn1:nTop := 178
oSBtn1:nWidth := 52
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
oSBtn2:nLeft := 346
oSBtn2:nTop := 178
oSBtn2:nWidth := 52
oSBtn2:nHeight := 25
oSBtn2:lShowHint := .F.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 2
oSBtn2:bAction := {|| Sair4() }

oDlg4:Activate()

Return
