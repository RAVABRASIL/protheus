User Function IoDlg6()

Local oDlg6,oPARECE1,oPARECE2,oPARECE3,oPARECE4,oPARECE5,oSBtn6,oSBtn7
oDlg6 := MSDIALOG():Create()
oDlg6:cName := "oDlg6"
oDlg6:cCaption := "Parecer do atendimento"
oDlg6:nLeft := 0
oDlg6:nTop := 0
oDlg6:nWidth := 620
oDlg6:nHeight := 191
oDlg6:lShowHint := .F.
oDlg6:lCentered := .F.

oPARECE1 := TGET():Create(oDlg6)
oPARECE1:cName := "oPARECE1"
oPARECE1:nLeft := 6
oPARECE1:nTop := 6
oPARECE1:nWidth := 603
oPARECE1:nHeight := 21
oPARECE1:lShowHint := .F.
oPARECE1:lReadOnly := .F.
oPARECE1:Align := 0
oPARECE1:cVariable := "cPARECE1"
oPARECE1:bSetGet := {|u| If(PCount()>0,cPARECE1:=u,cPARECE1) }
oPARECE1:lVisibleControl := .T.
oPARECE1:lPassword := .F.
oPARECE1:lHasButton := .F.

oPARECE2 := TGET():Create(oDlg6)
oPARECE2:cName := "oPARECE2"
oPARECE2:nLeft := 6
oPARECE2:nTop := 30
oPARECE2:nWidth := 603
oPARECE2:nHeight := 21
oPARECE2:lShowHint := .F.
oPARECE2:lReadOnly := .F.
oPARECE2:Align := 0
oPARECE2:cVariable := "cPARECE2"
oPARECE2:bSetGet := {|u| If(PCount()>0,cPARECE2:=u,cPARECE2) }
oPARECE2:lVisibleControl := .T.
oPARECE2:lPassword := .F.
oPARECE2:lHasButton := .F.

oPARECE3 := TGET():Create(oDlg6)
oPARECE3:cName := "oPARECE3"
oPARECE3:nLeft := 6
oPARECE3:nTop := 54
oPARECE3:nWidth := 603
oPARECE3:nHeight := 21
oPARECE3:lShowHint := .F.
oPARECE3:lReadOnly := .F.
oPARECE3:Align := 0
oPARECE3:cVariable := "cPARECE3"
oPARECE3:bSetGet := {|u| If(PCount()>0,cPARECE3:=u,cPARECE3) }
oPARECE3:lVisibleControl := .T.
oPARECE3:lPassword := .F.
oPARECE3:lHasButton := .F.

oPARECE4 := TGET():Create(oDlg6)
oPARECE4:cName := "oPARECE4"
oPARECE4:nLeft := 6
oPARECE4:nTop := 78
oPARECE4:nWidth := 603
oPARECE4:nHeight := 21
oPARECE4:lShowHint := .F.
oPARECE4:lReadOnly := .F.
oPARECE4:Align := 0
oPARECE4:cVariable := "cPARECE4"
oPARECE4:bSetGet := {|u| If(PCount()>0,cPARECE4:=u,cPARECE4) }
oPARECE4:lVisibleControl := .T.
oPARECE4:lPassword := .F.
oPARECE4:lHasButton := .F.

oPARECE5 := TGET():Create(oDlg6)
oPARECE5:cName := "oPARECE5"
oPARECE5:nLeft := 6
oPARECE5:nTop := 105
oPARECE5:nWidth := 603
oPARECE5:nHeight := 21
oPARECE5:lShowHint := .F.
oPARECE5:lReadOnly := .F.
oPARECE5:Align := 0
oPARECE5:cVariable := "cPARECE5"
oPARECE5:bSetGet := {|u| If(PCount()>0,cPARECE5:=u,cPARECE5) }
oPARECE5:lVisibleControl := .T.
oPARECE5:lPassword := .F.
oPARECE5:lHasButton := .F.

oSBtn6 := SBUTTON():Create(oDlg6)
oSBtn6:cName := "oSBtn6"
oSBtn6:cCaption := "oSBtn6"
oSBtn6:nLeft := 264
oSBtn6:nTop := 132
oSBtn6:nWidth := 55
oSBtn6:nHeight := 25
oSBtn6:lShowHint := .F.
oSBtn6:lReadOnly := .F.
oSBtn6:Align := 0
oSBtn6:lVisibleControl := .T.
oSBtn6:nType := 1
oSBtn6:bAction := {|| Parececnf() }

oSBtn7 := SBUTTON():Create(oDlg6)
oSBtn7:cName := "oSBtn7"
oSBtn7:cCaption := "oSBtn7"
oSBtn7:nLeft := 331
oSBtn7:nTop := 132
oSBtn7:nWidth := 55
oSBtn7:nHeight := 25
oSBtn7:lShowHint := .F.
oSBtn7:lReadOnly := .F.
oSBtn7:Align := 0
oSBtn7:lVisibleControl := .T.
oSBtn7:nType := 2
oSBtn7:bAction := {|| Sair6() }

oDlg6:Activate()

Return
