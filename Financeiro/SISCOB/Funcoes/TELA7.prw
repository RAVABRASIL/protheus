User Function IoDlg7()

Local oDlg7,oHist1,oSay2,oHist2,oSay4,oSBtn6
oDlg7 := MSDIALOG():Create()
oDlg7:cName := "oDlg7"
oDlg7:cCaption := "Histórico do cliente"
oDlg7:nLeft := 0
oDlg7:nTop := 0
oDlg7:nWidth := 632
oDlg7:nHeight := 265
oDlg7:lShowHint := .F.
oDlg7:lCentered := .T.

oHist1 := TLISTBOX():Create(oDlg7)
oHist1:cName := "oHist1"
oHist1:nLeft := 7
oHist1:nTop := 23
oHist1:nWidth := 300
oHist1:nHeight := 181
oHist1:lShowHint := .F.
oHist1:lReadOnly := .F.
oHist1:Align := 0
oHist1:lVisibleControl := .T.
oHist1:nAt := 0
oHist1:aItems := { "1"}
oHist1:bWhen := {|| HistMov() }
oHist1:bChange := {|| HistMov() }

oSay2 := TSAY():Create(oDlg7)
oSay2:cName := "oSay2"
oSay2:cCaption := "Tipo de atendimento"
oSay2:nLeft := 99
oSay2:nTop := 4
oSay2:nWidth := 102
oSay2:nHeight := 17
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oHist2 := TLISTBOX():Create(oDlg7)
oHist2:cName := "oHist2"
oHist2:nLeft := 320
oHist2:nTop := 23
oHist2:nWidth := 300
oHist2:nHeight := 181
oHist2:lShowHint := .F.
oHist2:lReadOnly := .F.
oHist2:Align := 0
oHist2:lVisibleControl := .T.
oHist2:nAt := 0
oHist2:aItems := { "1"}

oSay4 := TSAY():Create(oDlg7)
oSay4:cName := "oSay4"
oSay4:cCaption := "Ocorrência"
oSay4:nLeft := 444
oSay4:nTop := 3
oSay4:nWidth := 65
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oSBtn6 := SBUTTON():Create(oDlg7)
oSBtn6:cName := "oSBtn6"
oSBtn6:cCaption := "oSBtn6"
oSBtn6:nLeft := 285
oSBtn6:nTop := 208
oSBtn6:nWidth := 55
oSBtn6:nHeight := 25
oSBtn6:lShowHint := .F.
oSBtn6:lReadOnly := .F.
oSBtn6:Align := 0
oSBtn6:lVisibleControl := .T.
oSBtn6:nType := 1
oSBtn6:bAction := {|| Sair7() }

oDlg7:Activate()

Return
