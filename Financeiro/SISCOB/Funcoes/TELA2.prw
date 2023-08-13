User Function IoDlg2()

Local oDlg2,oSay1,oGrp2,oPRODUTO,oDESCPDT,oSay5,oOCORRENCIA,oSay7,oQUANTP,oSay10,oQUANTA,oSay13,oVLPEDIT,oSay15,oSay17,oVLNEGIT,oSay19,oAREA,oNOMAREA,oSay22,oPARECER,oSay25,oMOTIVO,oGrp27,oSay28,oOBS1,oOBS2,oOBS3,oOBS4,oOBS5,oITCONF,oITCANC,oPedido,oFRACAO,oVLCALCIT
oDlg2 := MSDIALOG():Create()
oDlg2:cName := "oDlg2"
oDlg2:cCaption := "Itens do atendimento"
oDlg2:nLeft := 0
oDlg2:nTop := 0
oDlg2:nWidth := 708
oDlg2:nHeight := 388
oDlg2:lShowHint := .F.
oDlg2:lCentered := .T.

oSay1 := TSAY():Create(oDlg2)
oSay1:cName := "oSay1"
oSay1:cCaption := "Produto:"
oSay1:nLeft := 15
oSay1:nTop := 23
oSay1:nWidth := 49
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oGrp2 := TGROUP():Create(oDlg2)
oGrp2:cName := "oGrp2"
oGrp2:cCaption := "Dados do item"
oGrp2:nLeft := 5
oGrp2:nTop := 2
oGrp2:nWidth := 691
oGrp2:nHeight := 268
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oPRODUTO := TGET():Create(oDlg2)
oPRODUTO:cF3 := "SB1"
oPRODUTO:cName := "oPRODUTO"
oPRODUTO:nLeft := 66
oPRODUTO:nTop := 18
oPRODUTO:nWidth := 123
oPRODUTO:nHeight := 21
oPRODUTO:lShowHint := .F.
oPRODUTO:lReadOnly := .F.
oPRODUTO:Align := 0
oPRODUTO:cVariable := "cPRODUTO"
oPRODUTO:bSetGet := {|u| If(PCount()>0,cPRODUTO:=u,cPRODUTO) }
oPRODUTO:lVisibleControl := .T.
oPRODUTO:lPassword := .F.
oPRODUTO:lHasButton := .F.
oPRODUTO:bValid := {|| VldProduto() }

oDESCPDT := TSAY():Create(oDlg2)
oDESCPDT:cName := "oDESCPDT"
oDESCPDT:cCaption := "_________________________________________________________________"
oDESCPDT:nLeft := 206
oDESCPDT:nTop := 21
oDESCPDT:nWidth := 368
oDESCPDT:nHeight := 17
oDESCPDT:lShowHint := .F.
oDESCPDT:lReadOnly := .F.
oDESCPDT:Align := 0
oDESCPDT:cVariable := "cDESCPDT"
oDESCPDT:bSetGet := {|u| If(PCount()>0,cDESCPDT:=u,cDESCPDT) }
oDESCPDT:lVisibleControl := .T.
oDESCPDT:lWordWrap := .F.
oDESCPDT:lTransparent := .F.

oSay5 := TSAY():Create(oDlg2)
oSay5:cName := "oSay5"
oSay5:cCaption := "Ocorrência:"
oSay5:nLeft := 15
oSay5:nTop := 49
oSay5:nWidth := 65
oSay5:nHeight := 17
oSay5:lShowHint := .F.
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .F.

oOCORRENCIA := TCOMBOBOX():Create(oDlg2)
oOCORRENCIA:cName := "oOCORRENCIA"
oOCORRENCIA:nLeft := 81
oOCORRENCIA:nTop := 44
oOCORRENCIA:nWidth := 406
oOCORRENCIA:nHeight := 21
oOCORRENCIA:lShowHint := .F.
oOCORRENCIA:lReadOnly := .F.
oOCORRENCIA:Align := 0
oOCORRENCIA:cVariable := "cOCORRENCIA"
oOCORRENCIA:bSetGet := {|u| If(PCount()>0,cOCORRENCIA:=u,cOCORRENCIA) }
oOCORRENCIA:lVisibleControl := .T.
oOCORRENCIA:aItems := { "1"}
oOCORRENCIA:nAt := 0

oSay7 := TSAY():Create(oDlg2)
oSay7:cName := "oSay7"
oSay7:cCaption := "Quant. pedido:"
oSay7:nLeft := 513
oSay7:nTop := 49
oSay7:nWidth := 79
oSay7:nHeight := 17
oSay7:lShowHint := .F.
oSay7:lReadOnly := .F.
oSay7:Align := 0
oSay7:lVisibleControl := .T.
oSay7:lWordWrap := .F.
oSay7:lTransparent := .F.

oQUANTP := TSAY():Create(oDlg2)
oQUANTP:cName := "oQUANTP"
oQUANTP:cCaption := "_______________"
oQUANTP:nLeft := 595
oQUANTP:nTop := 49
oQUANTP:nWidth := 93
oQUANTP:nHeight := 17
oQUANTP:lShowHint := .F.
oQUANTP:lReadOnly := .F.
oQUANTP:Align := 0
oQUANTP:cVariable := "nQUANTP"
oQUANTP:bSetGet := {|u| If(PCount()>0,nQUANTP:=u,nQUANTP) }
oQUANTP:lVisibleControl := .T.
oQUANTP:lWordWrap := .F.
oQUANTP:lTransparent := .F.

oSay10 := TSAY():Create(oDlg2)
oSay10:cName := "oSay10"
oSay10:cCaption := "Quant. ocorrencia:"
oSay10:nLeft := 15
oSay10:nTop := 75
oSay10:nWidth := 94
oSay10:nHeight := 17
oSay10:lShowHint := .F.
oSay10:lReadOnly := .F.
oSay10:Align := 0
oSay10:lVisibleControl := .T.
oSay10:lWordWrap := .F.
oSay10:lTransparent := .F.

oQUANTA := TGET():Create(oDlg2)
oQUANTA:cName := "oQUANTA"
oQUANTA:nLeft := 109
oQUANTA:nTop := 70
oQUANTA:nWidth := 69
oQUANTA:nHeight := 21
oQUANTA:lShowHint := .F.
oQUANTA:lReadOnly := .F.
oQUANTA:Align := 0
oQUANTA:cVariable := "nQUANTA"
oQUANTA:bSetGet := {|u| If(PCount()>0,nQUANTA:=u,nQUANTA) }
oQUANTA:lVisibleControl := .T.
oQUANTA:lPassword := .F.
oQUANTA:Picture := "999999"
oQUANTA:lHasButton := .F.
oQUANTA:bValid := {|| CalcItem() }

oSay13 := TSAY():Create(oDlg2)
oSay13:cName := "oSay13"
oSay13:cCaption := "Valor pedido:"
oSay13:nLeft := 288
oSay13:nTop := 75
oSay13:nWidth := 71
oSay13:nHeight := 17
oSay13:lShowHint := .F.
oSay13:lReadOnly := .F.
oSay13:Align := 0
oSay13:lVisibleControl := .T.
oSay13:lWordWrap := .F.
oSay13:lTransparent := .F.

oVLPEDIT := TSAY():Create(oDlg2)
oVLPEDIT:cName := "oVLPEDIT"
oVLPEDIT:cCaption := "____________________"
oVLPEDIT:nLeft := 359
oVLPEDIT:nTop := 72
oVLPEDIT:nWidth := 102
oVLPEDIT:nHeight := 17
oVLPEDIT:lShowHint := .F.
oVLPEDIT:lReadOnly := .F.
oVLPEDIT:Align := 0
oVLPEDIT:cVariable := "nVLPEDIT"
oVLPEDIT:bSetGet := {|u| If(PCount()>0,nVLPEDIT:=u,nVLPEDIT) }
oVLPEDIT:lVisibleControl := .T.
oVLPEDIT:lWordWrap := .F.
oVLPEDIT:lTransparent := .F.

oSay15 := TSAY():Create(oDlg2)
oSay15:cName := "oSay15"
oSay15:cCaption := "Valor calculado ocorr.:"
oSay15:nLeft := 482
oSay15:nTop := 75
oSay15:nWidth := 107
oSay15:nHeight := 17
oSay15:lShowHint := .F.
oSay15:lReadOnly := .F.
oSay15:Align := 0
oSay15:lVisibleControl := .T.
oSay15:lWordWrap := .F.
oSay15:lTransparent := .F.

oSay17 := TSAY():Create(oDlg2)
oSay17:cName := "oSay17"
oSay17:cCaption := "Valor negociado ocorrencia:"
oSay17:nLeft := 15
oSay17:nTop := 99
oSay17:nWidth := 142
oSay17:nHeight := 17
oSay17:lShowHint := .F.
oSay17:lReadOnly := .F.
oSay17:Align := 0
oSay17:lVisibleControl := .T.
oSay17:lWordWrap := .F.
oSay17:lTransparent := .F.

oVLNEGIT := TGET():Create(oDlg2)
oVLNEGIT:cName := "oVLNEGIT"
oVLNEGIT:nLeft := 157
oVLNEGIT:nTop := 95
oVLNEGIT:nWidth := 98
oVLNEGIT:nHeight := 21
oVLNEGIT:lShowHint := .F.
oVLNEGIT:lReadOnly := .F.
oVLNEGIT:Align := 0
oVLNEGIT:cVariable := "nVLNEGIT"
oVLNEGIT:bSetGet := {|u| If(PCount()>0,nVLNEGIT:=u,nVLNEGIT) }
oVLNEGIT:lVisibleControl := .T.
oVLNEGIT:lPassword := .F.
oVLNEGIT:Picture := "@E 999,999.99"
oVLNEGIT:lHasButton := .F.

oSay19 := TSAY():Create(oDlg2)
oSay19:cName := "oSay19"
oSay19:cCaption := "Área responsável:"
oSay19:nLeft := 286
oSay19:nTop := 99
oSay19:nWidth := 92
oSay19:nHeight := 17
oSay19:lShowHint := .F.
oSay19:lReadOnly := .F.
oSay19:Align := 0
oSay19:lVisibleControl := .T.
oSay19:lWordWrap := .F.
oSay19:lTransparent := .F.

oAREA := TGET():Create(oDlg2)
oAREA:cF3 := "SQB"
oAREA:cName := "oAREA"
oAREA:nLeft := 378
oAREA:nTop := 95
oAREA:nWidth := 46
oAREA:nHeight := 21
oAREA:lShowHint := .F.
oAREA:lReadOnly := .F.
oAREA:Align := 0
oAREA:cVariable := "cAREA"
oAREA:bSetGet := {|u| If(PCount()>0,cAREA:=u,cAREA) }
oAREA:lVisibleControl := .T.
oAREA:lPassword := .F.
oAREA:lHasButton := .F.
oAREA:bValid := {|| VldArea() }

oNOMAREA := TSAY():Create(oDlg2)
oNOMAREA:cName := "oNOMAREA"
oNOMAREA:cCaption := "_____________________________________________"
oNOMAREA:nLeft := 434
oNOMAREA:nTop := 99
oNOMAREA:nWidth := 250
oNOMAREA:nHeight := 17
oNOMAREA:lShowHint := .F.
oNOMAREA:lReadOnly := .F.
oNOMAREA:Align := 0
oNOMAREA:cVariable := "cNOMAREA"
oNOMAREA:bSetGet := {|u| If(PCount()>0,cNOMAREA:=u,cNOMAREA) }
oNOMAREA:lVisibleControl := .T.
oNOMAREA:lWordWrap := .F.
oNOMAREA:lTransparent := .F.

oSay22 := TSAY():Create(oDlg2)
oSay22:cName := "oSay22"
oSay22:cCaption := "Parecer:"
oSay22:nLeft := 421
oSay22:nTop := 294
oSay22:nWidth := 47
oSay22:nHeight := 17
oSay22:lShowHint := .F.
oSay22:lReadOnly := .F.
oSay22:Align := 0
oSay22:lVisibleControl := .T.
oSay22:lWordWrap := .F.
oSay22:lTransparent := .F.

oPARECER := TCOMBOBOX():Create(oDlg2)
oPARECER:cName := "oPARECER"
oPARECER:nLeft := 472
oPARECER:nTop := 293
oPARECER:nWidth := 218
oPARECER:nHeight := 21
oPARECER:lShowHint := .F.
oPARECER:lReadOnly := .F.
oPARECER:Align := 0
oPARECER:cVariable := "cPARECER"
oPARECER:bSetGet := {|u| If(PCount()>0,cPARECER:=u,cPARECER) }
oPARECER:lVisibleControl := .T.
oPARECER:aItems := { "","1 - Aceito","2 - Negado"}
oPARECER:nAt := 0

oSay25 := TSAY():Create(oDlg2)
oSay25:cName := "oSay25"
oSay25:cCaption := "Motivo:"
oSay25:nLeft := 16
oSay25:nTop := 293
oSay25:nWidth := 45
oSay25:nHeight := 17
oSay25:lShowHint := .F.
oSay25:lReadOnly := .F.
oSay25:Align := 0
oSay25:lVisibleControl := .T.
oSay25:lWordWrap := .F.
oSay25:lTransparent := .F.

oMOTIVO := TCOMBOBOX():Create(oDlg2)
oMOTIVO:cName := "oMOTIVO"
oMOTIVO:nLeft := 60
oMOTIVO:nTop := 291
oMOTIVO:nWidth := 325
oMOTIVO:nHeight := 21
oMOTIVO:lShowHint := .F.
oMOTIVO:lReadOnly := .F.
oMOTIVO:Align := 0
oMOTIVO:cVariable := "cMOTIVO"
oMOTIVO:bSetGet := {|u| If(PCount()>0,cMOTIVO:=u,cMOTIVO) }
oMOTIVO:lVisibleControl := .T.
oMOTIVO:aItems := { "1"}
oMOTIVO:nAt := 0

oGrp27 := TGROUP():Create(oDlg2)
oGrp27:cName := "oGrp27"
oGrp27:cCaption := "Parecer"
oGrp27:nLeft := 7
oGrp27:nTop := 274
oGrp27:nWidth := 688
oGrp27:nHeight := 47
oGrp27:lShowHint := .F.
oGrp27:lReadOnly := .F.
oGrp27:Align := 0
oGrp27:lVisibleControl := .T.

oSay28 := TSAY():Create(oDlg2)
oSay28:cName := "oSay28"
oSay28:cCaption := "Observacao:"
oSay28:nLeft := 15
oSay28:nTop := 124
oSay28:nWidth := 65
oSay28:nHeight := 17
oSay28:lShowHint := .F.
oSay28:lReadOnly := .F.
oSay28:Align := 0
oSay28:lVisibleControl := .T.
oSay28:lWordWrap := .F.
oSay28:lTransparent := .F.

oOBS1 := TGET():Create(oDlg2)
oOBS1:cName := "oOBS1"
oOBS1:nLeft := 13
oOBS1:nTop := 146
oOBS1:nWidth := 678
oOBS1:nHeight := 21
oOBS1:lShowHint := .F.
oOBS1:lReadOnly := .F.
oOBS1:Align := 0
oOBS1:cVariable := "cOBS1"
oOBS1:bSetGet := {|u| If(PCount()>0,cOBS1:=u,cOBS1) }
oOBS1:lVisibleControl := .T.
oOBS1:lPassword := .F.
oOBS1:lHasButton := .F.

oOBS2 := TGET():Create(oDlg2)
oOBS2:cName := "oOBS2"
oOBS2:nLeft := 13
oOBS2:nTop := 170
oOBS2:nWidth := 678
oOBS2:nHeight := 21
oOBS2:lShowHint := .F.
oOBS2:lReadOnly := .F.
oOBS2:Align := 0
oOBS2:cVariable := "cOBS2"
oOBS2:bSetGet := {|u| If(PCount()>0,cOBS2:=u,cOBS2) }
oOBS2:lVisibleControl := .T.
oOBS2:lPassword := .F.
oOBS2:lHasButton := .F.

oOBS3 := TGET():Create(oDlg2)
oOBS3:cName := "oOBS3"
oOBS3:nLeft := 13
oOBS3:nTop := 194
oOBS3:nWidth := 678
oOBS3:nHeight := 21
oOBS3:lShowHint := .F.
oOBS3:lReadOnly := .F.
oOBS3:Align := 0
oOBS3:cVariable := "cOBS3"
oOBS3:bSetGet := {|u| If(PCount()>0,cOBS3:=u,cOBS3) }
oOBS3:lVisibleControl := .T.
oOBS3:lPassword := .F.
oOBS3:lHasButton := .F.

oOBS4 := TGET():Create(oDlg2)
oOBS4:cName := "oOBS4"
oOBS4:nLeft := 13
oOBS4:nTop := 217
oOBS4:nWidth := 678
oOBS4:nHeight := 21
oOBS4:lShowHint := .F.
oOBS4:lReadOnly := .F.
oOBS4:Align := 0
oOBS4:cVariable := "cOBS4"
oOBS4:bSetGet := {|u| If(PCount()>0,cOBS4:=u,cOBS4) }
oOBS4:lVisibleControl := .T.
oOBS4:lPassword := .F.
oOBS4:lHasButton := .F.

oOBS5 := TGET():Create(oDlg2)
oOBS5:cName := "oOBS5"
oOBS5:nLeft := 13
oOBS5:nTop := 242
oOBS5:nWidth := 678
oOBS5:nHeight := 21
oOBS5:lShowHint := .F.
oOBS5:lReadOnly := .F.
oOBS5:Align := 0
oOBS5:cVariable := "cOBS5"
oOBS5:bSetGet := {|u| If(PCount()>0,cOBS5:=u,cOBS5) }
oOBS5:lVisibleControl := .T.
oOBS5:lPassword := .F.
oOBS5:lHasButton := .F.

oITCONF := SBUTTON():Create(oDlg2)
oITCONF:cName := "oITCONF"
oITCONF:nLeft := 302
oITCONF:nTop := 332
oITCONF:nWidth := 58
oITCONF:nHeight := 24
oITCONF:lShowHint := .F.
oITCONF:lReadOnly := .F.
oITCONF:Align := 0
oITCONF:lVisibleControl := .T.
oITCONF:nType := 1
oITCONF:bAction := {|| ItConfirma() }

oITCANC := SBUTTON():Create(oDlg2)
oITCANC:cName := "oITCANC"
oITCANC:nLeft := 379
oITCANC:nTop := 332
oITCANC:nWidth := 58
oITCANC:nHeight := 24
oITCANC:lShowHint := .F.
oITCANC:lReadOnly := .F.
oITCANC:Align := 0
oITCANC:lVisibleControl := .T.
oITCANC:nType := 2
oITCANC:bAction := {|| Sair2() }

oPedido := SBUTTON():Create(oDlg2)
oPedido:cName := "oPedido"
oPedido:cCaption := "&Pedido"
oPedido:nLeft := 587
oPedido:nTop := 19
oPedido:nWidth := 100
oPedido:nHeight := 22
oPedido:lShowHint := .F.
oPedido:lReadOnly := .F.
oPedido:Align := 0
oPedido:lVisibleControl := .T.
oPedido:nType := 1
oPedido:bAction := {|| MostraPdt() }

oFRACAO := TCHECKBOX():Create(oDlg2)
oFRACAO:cName := "oFRACAO"
oFRACAO:cCaption := "Fracionado?"
oFRACAO:nLeft := 179
oFRACAO:nTop := 73
oFRACAO:nWidth := 89
oFRACAO:nHeight := 17
oFRACAO:lShowHint := .F.
oFRACAO:lReadOnly := .F.
oFRACAO:Align := 0
oFRACAO:cVariable := "lFRACAO"
oFRACAO:bSetGet := {|u| If(PCount()>0,lFRACAO:=u,lFRACAO) }
oFRACAO:lVisibleControl := .T.
oFRACAO:bValid := {|| CalcItem() }

oVLCALCIT := TSAY():Create(oDlg2)
oVLCALCIT:cName := "oVLCALCIT"
oVLCALCIT:cCaption := "______________"
oVLCALCIT:nLeft := 594
oVLCALCIT:nTop := 76
oVLCALCIT:nWidth := 90
oVLCALCIT:nHeight := 17
oVLCALCIT:lShowHint := .F.
oVLCALCIT:lReadOnly := .F.
oVLCALCIT:Align := 0
oVLCALCIT:cVariable := "nVLCALCIT"
oVLCALCIT:bSetGet := {|u| If(PCount()>0,nVLCALCIT:=u,nVLCALCIT) }
oVLCALCIT:lVisibleControl := .T.
oVLCALCIT:lWordWrap := .F.
oVLCALCIT:lTransparent := .F.

oDlg2:Activate()

Return
