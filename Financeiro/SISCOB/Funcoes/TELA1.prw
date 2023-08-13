User Function IoDlg1()

Local oDlg1,oCODCLI,oGrp2,oSay3,oNOMECLI,oSay5,oSay9,oPEDIDO,oSay11,oNOTA,oSay13,oNOMREP,oSay16,oSay18,oDTATEND,oSay21,oDTRECMERC,oSay27,oCONTATO,oSay29,oOPERADOR,oNOMOPER,oHISTOR,oSay34,oTRANSP,oPOSCLI,oINCLUI,oGrp42,oSay43,oVLPED,oSay46,oSay48,oSay54,oRESP,oSay56,oDTSOLUC,oSay58,oSOLUCAO,oSay60,oCOMISSAO,oDTSAIMERC,oALTERA,oEXCLUI,oQUESTION,oITPARECER,oVLCALC,oVLNEG,oSay70,oPERC,oConfirmar,oSair,oTIPO,oLOJCLI,oSay68,oNUMERO,oATDPAREC,oCOMENT,oSay72,oLOCAL,oDESCLOC
oDlg1 := MSDIALOG():Create()
oDlg1:cName := "oDlg1"
oDlg1:cCaption := "SAC - Serviço de Atendimento a Clientes"
oDlg1:nLeft := 28
oDlg1:nTop := 14
oDlg1:nWidth := 785
oDlg1:nHeight := 580
oDlg1:lShowHint := .F.
oDlg1:lCentered := .T.

oCODCLI := TGET():Create(oDlg1)
oCODCLI:cF3 := "SA1"
oCODCLI:cName := "oCODCLI"
oCODCLI:nLeft := 58
oCODCLI:nTop := 43
oCODCLI:nWidth := 65
oCODCLI:nHeight := 21
oCODCLI:lShowHint := .F.
oCODCLI:lReadOnly := .F.
oCODCLI:Align := 0
oCODCLI:cVariable := "cCODCLI"
oCODCLI:bSetGet := {|u| If(PCount()>0,cCODCLI:=u,cCODCLI) }
oCODCLI:lVisibleControl := .T.
oCODCLI:lPassword := .F.
oCODCLI:lHasButton := .F.

oGrp2 := TGROUP():Create(oDlg1)
oGrp2:cName := "oGrp2"
oGrp2:cCaption := "Dados do atendimento"
oGrp2:nLeft := 5
oGrp2:nTop := 1
oGrp2:nWidth := 769
oGrp2:nHeight := 184
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oSay3 := TSAY():Create(oDlg1)
oSay3:cName := "oSay3"
oSay3:cCaption := "Cliente:"
oSay3:nLeft := 17
oSay3:nTop := 46
oSay3:nWidth := 42
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oNOMECLI := TSAY():Create(oDlg1)
oNOMECLI:cName := "oNOMECLI"
oNOMECLI:cCaption := "____________________________________________________________"
oNOMECLI:nLeft := 168
oNOMECLI:nTop := 46
oNOMECLI:nWidth := 359
oNOMECLI:nHeight := 17
oNOMECLI:lShowHint := .F.
oNOMECLI:lReadOnly := .F.
oNOMECLI:Align := 0
oNOMECLI:cVariable := "cNOMECLI"
oNOMECLI:bSetGet := {|u| If(PCount()>0,cNOMECLI:=u,cNOMECLI) }
oNOMECLI:lVisibleControl := .T.
oNOMECLI:lWordWrap := .F.
oNOMECLI:lTransparent := .F.

oSay5 := TSAY():Create(oDlg1)
oSay5:cName := "oSay5"
oSay5:cCaption := "Tipo:"
oSay5:nLeft := 543
oSay5:nTop := 20
oSay5:nWidth := 35
oSay5:nHeight := 17
oSay5:lShowHint := .F.
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .F.

oSay9 := TSAY():Create(oDlg1)
oSay9:cName := "oSay9"
oSay9:cCaption := "Num. pedido:"
oSay9:nLeft := 361
oSay9:nTop := 75
oSay9:nWidth := 65
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .F.

oPEDIDO := TGET():Create(oDlg1)
oPEDIDO:cName := "oPEDIDO"
oPEDIDO:nLeft := 429
oPEDIDO:nTop := 72
oPEDIDO:nWidth := 123
oPEDIDO:nHeight := 21
oPEDIDO:lShowHint := .F.
oPEDIDO:lReadOnly := .F.
oPEDIDO:Align := 0
oPEDIDO:cVariable := "cPEDIDO"
oPEDIDO:bSetGet := {|u| If(PCount()>0,cPEDIDO:=u,cPEDIDO) }
oPEDIDO:lVisibleControl := .T.
oPEDIDO:lPassword := .F.
oPEDIDO:lHasButton := .F.
oPEDIDO:bValid := {|| VldPed() }

oSay11 := TSAY():Create(oDlg1)
oSay11:cName := "oSay11"
oSay11:cCaption := "Nota Fiscal:"
oSay11:nLeft := 573
oSay11:nTop := 75
oSay11:nWidth := 65
oSay11:nHeight := 17
oSay11:lShowHint := .F.
oSay11:lReadOnly := .F.
oSay11:Align := 0
oSay11:lVisibleControl := .T.
oSay11:lWordWrap := .F.
oSay11:lTransparent := .F.

oNOTA := TGET():Create(oDlg1)
oNOTA:cName := "oNOTA"
oNOTA:nLeft := 644
oNOTA:nTop := 72
oNOTA:nWidth := 121
oNOTA:nHeight := 21
oNOTA:lShowHint := .F.
oNOTA:lReadOnly := .F.
oNOTA:Align := 0
oNOTA:cVariable := "cNOTA"
oNOTA:bSetGet := {|u| If(PCount()>0,cNOTA:=u,cNOTA) }
oNOTA:lVisibleControl := .T.
oNOTA:lPassword := .F.
oNOTA:lHasButton := .F.
oNOTA:bValid := {|| VldNota() }

oSay13 := TSAY():Create(oDlg1)
oSay13:cName := "oSay13"
oSay13:cCaption := "Representante:"
oSay13:nLeft := 17
oSay13:nTop := 102
oSay13:nWidth := 77
oSay13:nHeight := 17
oSay13:lShowHint := .F.
oSay13:lReadOnly := .F.
oSay13:Align := 0
oSay13:lVisibleControl := .T.
oSay13:lWordWrap := .F.
oSay13:lTransparent := .F.

oNOMREP := TSAY():Create(oDlg1)
oNOMREP:cName := "oNOMREP"
oNOMREP:cCaption := "__________________________________________________"
oNOMREP:nLeft := 97
oNOMREP:nTop := 102
oNOMREP:nWidth := 303
oNOMREP:nHeight := 17
oNOMREP:lShowHint := .F.
oNOMREP:lReadOnly := .F.
oNOMREP:Align := 0
oNOMREP:cVariable := "cNOMREP"
oNOMREP:bSetGet := {|u| If(PCount()>0,cNOMREP:=u,cNOMREP) }
oNOMREP:lVisibleControl := .T.
oNOMREP:lWordWrap := .F.
oNOMREP:lTransparent := .F.

oSay16 := TSAY():Create(oDlg1)
oSay16:cName := "oSay16"
oSay16:cCaption := "Data da reclamação:"
oSay16:nLeft := 300
oSay16:nTop := 131
oSay16:nWidth := 106
oSay16:nHeight := 17
oSay16:lShowHint := .F.
oSay16:lReadOnly := .F.
oSay16:Align := 0
oSay16:lVisibleControl := .T.
oSay16:lWordWrap := .F.
oSay16:lTransparent := .F.

oSay18 := TSAY():Create(oDlg1)
oSay18:cName := "oSay18"
oSay18:cCaption := "Saída da mercadoria:"
oSay18:nLeft := 539
oSay18:nTop := 133
oSay18:nWidth := 111
oSay18:nHeight := 17
oSay18:lShowHint := .F.
oSay18:lReadOnly := .F.
oSay18:Align := 0
oSay18:lVisibleControl := .T.
oSay18:lWordWrap := .F.
oSay18:lTransparent := .F.

oDTATEND := TGET():Create(oDlg1)
oDTATEND:cName := "oDTATEND"
oDTATEND:nLeft := 403
oDTATEND:nTop := 129
oDTATEND:nWidth := 112
oDTATEND:nHeight := 21
oDTATEND:lShowHint := .F.
oDTATEND:lReadOnly := .F.
oDTATEND:Align := 0
oDTATEND:cVariable := "dDTATEND"
oDTATEND:bSetGet := {|u| If(PCount()>0,dDTATEND:=u,dDTATEND) }
oDTATEND:lVisibleControl := .T.
oDTATEND:lPassword := .F.
oDTATEND:Picture := "99/99/99"
oDTATEND:lHasButton := .F.

oSay21 := TSAY():Create(oDlg1)
oSay21:cName := "oSay21"
oSay21:cCaption := "Receb. da mercadoria:"
oSay21:nLeft := 18
oSay21:nTop := 156
oSay21:nWidth := 115
oSay21:nHeight := 17
oSay21:lShowHint := .F.
oSay21:lReadOnly := .F.
oSay21:Align := 0
oSay21:lVisibleControl := .T.
oSay21:lWordWrap := .F.
oSay21:lTransparent := .F.

oDTRECMERC := TGET():Create(oDlg1)
oDTRECMERC:cName := "oDTRECMERC"
oDTRECMERC:nLeft := 134
oDTRECMERC:nTop := 152
oDTRECMERC:nWidth := 91
oDTRECMERC:nHeight := 21
oDTRECMERC:lShowHint := .F.
oDTRECMERC:lReadOnly := .F.
oDTRECMERC:Align := 0
oDTRECMERC:cVariable := "dDTRECMERC"
oDTRECMERC:bSetGet := {|u| If(PCount()>0,dDTRECMERC:=u,dDTRECMERC) }
oDTRECMERC:lVisibleControl := .T.
oDTRECMERC:lPassword := .F.
oDTRECMERC:Picture := "99/99/99"
oDTRECMERC:lHasButton := .F.

oSay27 := TSAY():Create(oDlg1)
oSay27:cName := "oSay27"
oSay27:cCaption := "Contato:"
oSay27:nLeft := 17
oSay27:nTop := 75
oSay27:nWidth := 44
oSay27:nHeight := 17
oSay27:lShowHint := .F.
oSay27:lReadOnly := .F.
oSay27:Align := 0
oSay27:lVisibleControl := .T.
oSay27:lWordWrap := .F.
oSay27:lTransparent := .F.

oCONTATO := TGET():Create(oDlg1)
oCONTATO:cName := "oCONTATO"
oCONTATO:nLeft := 62
oCONTATO:nTop := 72
oCONTATO:nWidth := 277
oCONTATO:nHeight := 21
oCONTATO:lShowHint := .F.
oCONTATO:lReadOnly := .F.
oCONTATO:Align := 0
oCONTATO:cVariable := "cCONTATO"
oCONTATO:bSetGet := {|u| If(PCount()>0,cCONTATO:=u,cCONTATO) }
oCONTATO:lVisibleControl := .T.
oCONTATO:lPassword := .F.
oCONTATO:lHasButton := .F.

oSay29 := TSAY():Create(oDlg1)
oSay29:cName := "oSay29"
oSay29:cCaption := "Operador:"
oSay29:nLeft := 176
oSay29:nTop := 20
oSay29:nWidth := 56
oSay29:nHeight := 17
oSay29:lShowHint := .F.
oSay29:lReadOnly := .F.
oSay29:Align := 0
oSay29:lVisibleControl := .T.
oSay29:lWordWrap := .F.
oSay29:lTransparent := .F.

oOPERADOR := TGET():Create(oDlg1)
oOPERADOR:cF3 := "SU7"
oOPERADOR:cName := "oOPERADOR"
oOPERADOR:nLeft := 232
oOPERADOR:nTop := 17
oOPERADOR:nWidth := 60
oOPERADOR:nHeight := 21
oOPERADOR:lShowHint := .F.
oOPERADOR:lReadOnly := .F.
oOPERADOR:Align := 0
oOPERADOR:cVariable := "cOPERADOR"
oOPERADOR:bSetGet := {|u| If(PCount()>0,cOPERADOR:=u,cOPERADOR) }
oOPERADOR:lVisibleControl := .T.
oOPERADOR:lPassword := .F.
oOPERADOR:lHasButton := .F.
oOPERADOR:bValid := {|| VldOperador() }

oNOMOPER := TSAY():Create(oDlg1)
oNOMOPER:cName := "oNOMOPER"
oNOMOPER:cCaption := "_____________________________________________"
oNOMOPER:nLeft := 295
oNOMOPER:nTop := 20
oNOMOPER:nWidth := 221
oNOMOPER:nHeight := 17
oNOMOPER:lShowHint := .F.
oNOMOPER:lReadOnly := .F.
oNOMOPER:Align := 0
oNOMOPER:cVariable := "cNOMOPER"
oNOMOPER:bSetGet := {|u| If(PCount()>0,cNOMOPER:=u,cNOMOPER) }
oNOMOPER:lVisibleControl := .T.
oNOMOPER:lWordWrap := .F.
oNOMOPER:lTransparent := .F.

oHISTOR := SBUTTON():Create(oDlg1)
oHISTOR:cName := "oHISTOR"
oHISTOR:cCaption := "&Historico"
oHISTOR:nLeft := 545
oHISTOR:nTop := 43
oHISTOR:nWidth := 100
oHISTOR:nHeight := 22
oHISTOR:lShowHint := .F.
oHISTOR:lReadOnly := .F.
oHISTOR:Align := 0
oHISTOR:lVisibleControl := .T.
oHISTOR:nType := 1
oHISTOR:bAction := {|| CliHist() }

oSay34 := TSAY():Create(oDlg1)
oSay34:cName := "oSay34"
oSay34:cCaption := "Transportadora:"
oSay34:nLeft := 420
oSay34:nTop := 102
oSay34:nWidth := 81
oSay34:nHeight := 17
oSay34:lShowHint := .F.
oSay34:lReadOnly := .F.
oSay34:Align := 0
oSay34:lVisibleControl := .T.
oSay34:lWordWrap := .F.
oSay34:lTransparent := .F.

oTRANSP := TSAY():Create(oDlg1)
oTRANSP:cName := "oTRANSP"
oTRANSP:cCaption := "___________________________________________"
oTRANSP:nLeft := 502
oTRANSP:nTop := 102
oTRANSP:nWidth := 260
oTRANSP:nHeight := 17
oTRANSP:lShowHint := .F.
oTRANSP:lReadOnly := .F.
oTRANSP:Align := 0
oTRANSP:cVariable := "cTRANSP"
oTRANSP:bSetGet := {|u| If(PCount()>0,cTRANSP:=u,cTRANSP) }
oTRANSP:lVisibleControl := .T.
oTRANSP:lWordWrap := .F.
oTRANSP:lTransparent := .F.

oPOSCLI := SBUTTON():Create(oDlg1)
oPOSCLI:cName := "oPOSCLI"
oPOSCLI:cCaption := "Posicao &cliente"
oPOSCLI:nLeft := 663
oPOSCLI:nTop := 43
oPOSCLI:nWidth := 100
oPOSCLI:nHeight := 22
oPOSCLI:lShowHint := .F.
oPOSCLI:lReadOnly := .F.
oPOSCLI:Align := 0
oPOSCLI:lVisibleControl := .T.
oPOSCLI:nType := 1
oPOSCLI:bAction := {|| CliPos() }

oINCLUI := SBUTTON():Create(oDlg1)
oINCLUI:cName := "oINCLUI"
oINCLUI:cCaption := "&Incluir"
oINCLUI:nLeft := 49
oINCLUI:nTop := 420
oINCLUI:nWidth := 100
oINCLUI:nHeight := 22
oINCLUI:lShowHint := .F.
oINCLUI:lReadOnly := .F.
oINCLUI:Align := 0
oINCLUI:lVisibleControl := .T.
oINCLUI:nType := 1
oINCLUI:bAction := {|| Itinclui() }

oGrp42 := TGROUP():Create(oDlg1)
oGrp42:cName := "oGrp42"
oGrp42:cCaption := "Status do Atendimento"
oGrp42:nLeft := 5
oGrp42:nTop := 446
oGrp42:nWidth := 767
oGrp42:nHeight := 105
oGrp42:lShowHint := .F.
oGrp42:lReadOnly := .F.
oGrp42:Align := 0
oGrp42:lVisibleControl := .T.

oSay43 := TSAY():Create(oDlg1)
oSay43:cName := "oSay43"
oSay43:cCaption := "Valor do pedido:"
oSay43:nLeft := 18
oSay43:nTop := 465
oSay43:nWidth := 85
oSay43:nHeight := 17
oSay43:lShowHint := .F.
oSay43:lReadOnly := .F.
oSay43:Align := 0
oSay43:lVisibleControl := .T.
oSay43:lWordWrap := .F.
oSay43:lTransparent := .F.

oVLPED := TSAY():Create(oDlg1)
oVLPED:cName := "oVLPED"
oVLPED:cCaption := "_______________"
oVLPED:nLeft := 103
oVLPED:nTop := 465
oVLPED:nWidth := 109
oVLPED:nHeight := 17
oVLPED:lShowHint := .F.
oVLPED:lReadOnly := .F.
oVLPED:Align := 0
oVLPED:cVariable := "nVLPED"
oVLPED:bSetGet := {|u| If(PCount()>0,nVLPED:=u,nVLPED) }
oVLPED:lVisibleControl := .T.
oVLPED:lWordWrap := .F.
oVLPED:lTransparent := .F.

oSay46 := TSAY():Create(oDlg1)
oSay46:cName := "oSay46"
oSay46:cCaption := "Valor calculado produtos:"
oSay46:nLeft := 234
oSay46:nTop := 465
oSay46:nWidth := 131
oSay46:nHeight := 17
oSay46:lShowHint := .F.
oSay46:lReadOnly := .F.
oSay46:Align := 0
oSay46:lVisibleControl := .T.
oSay46:lWordWrap := .F.
oSay46:lTransparent := .F.

oSay48 := TSAY():Create(oDlg1)
oSay48:cName := "oSay48"
oSay48:cCaption := "Valor negociado atendimento:"
oSay48:nLeft := 501
oSay48:nTop := 465
oSay48:nWidth := 145
oSay48:nHeight := 17
oSay48:lShowHint := .F.
oSay48:lReadOnly := .F.
oSay48:Align := 0
oSay48:lVisibleControl := .T.
oSay48:lWordWrap := .F.
oSay48:lTransparent := .F.

oSay54 := TSAY():Create(oDlg1)
oSay54:cName := "oSay54"
oSay54:cCaption := "Respons. p/ solução:"
oSay54:nLeft := 470
oSay54:nTop := 492
oSay54:nWidth := 107
oSay54:nHeight := 17
oSay54:lShowHint := .F.
oSay54:lReadOnly := .F.
oSay54:Align := 0
oSay54:lVisibleControl := .T.
oSay54:lWordWrap := .F.
oSay54:lTransparent := .F.

oRESP := TGET():Create(oDlg1)
oRESP:cName := "oRESP"
oRESP:nLeft := 578
oRESP:nTop := 489
oRESP:nWidth := 185
oRESP:nHeight := 21
oRESP:lShowHint := .F.
oRESP:lReadOnly := .F.
oRESP:Align := 0
oRESP:cVariable := "cRESP"
oRESP:bSetGet := {|u| If(PCount()>0,cRESP:=u,cRESP) }
oRESP:lVisibleControl := .T.
oRESP:lPassword := .F.
oRESP:lHasButton := .F.

oSay56 := TSAY():Create(oDlg1)
oSay56:cName := "oSay56"
oSay56:cCaption := "Data da solução:"
oSay56:nLeft := 17
oSay56:nTop := 518
oSay56:nWidth := 86
oSay56:nHeight := 17
oSay56:lShowHint := .F.
oSay56:lReadOnly := .F.
oSay56:Align := 0
oSay56:lVisibleControl := .T.
oSay56:lWordWrap := .F.
oSay56:lTransparent := .F.

oDTSOLUC := TGET():Create(oDlg1)
oDTSOLUC:cName := "oDTSOLUC"
oDTSOLUC:nLeft := 105
oDTSOLUC:nTop := 515
oDTSOLUC:nWidth := 92
oDTSOLUC:nHeight := 21
oDTSOLUC:lShowHint := .F.
oDTSOLUC:lReadOnly := .F.
oDTSOLUC:Align := 0
oDTSOLUC:cVariable := "dDTSOLUC"
oDTSOLUC:bSetGet := {|u| If(PCount()>0,dDTSOLUC:=u,dDTSOLUC) }
oDTSOLUC:lVisibleControl := .T.
oDTSOLUC:lPassword := .F.
oDTSOLUC:Picture := "99/99/99"
oDTSOLUC:lHasButton := .F.

oSay58 := TSAY():Create(oDlg1)
oSay58:cName := "oSay58"
oSay58:cCaption := "Solução:"
oSay58:nLeft := 207
oSay58:nTop := 492
oSay58:nWidth := 48
oSay58:nHeight := 17
oSay58:lShowHint := .F.
oSay58:lReadOnly := .F.
oSay58:Align := 0
oSay58:lVisibleControl := .T.
oSay58:lWordWrap := .F.
oSay58:lTransparent := .F.

oSOLUCAO := TCOMBOBOX():Create(oDlg1)
oSOLUCAO:cName := "oSOLUCAO"
oSOLUCAO:nLeft := 254
oSOLUCAO:nTop := 489
oSOLUCAO:nWidth := 204
oSOLUCAO:nHeight := 21
oSOLUCAO:lShowHint := .F.
oSOLUCAO:lReadOnly := .F.
oSOLUCAO:Align := 0
oSOLUCAO:cVariable := "cSOLUCAO"
oSOLUCAO:bSetGet := {|u| If(PCount()>0,cSOLUCAO:=u,cSOLUCAO) }
oSOLUCAO:lVisibleControl := .T.
oSOLUCAO:aItems := { "1"}
oSOLUCAO:nAt := 0

oSay60 := TSAY():Create(oDlg1)
oSay60:cName := "oSay60"
oSay60:cCaption := "Comissão:"
oSay60:nLeft := 18
oSay60:nTop := 128
oSay60:nWidth := 58
oSay60:nHeight := 17
oSay60:lShowHint := .F.
oSay60:lReadOnly := .F.
oSay60:Align := 0
oSay60:lVisibleControl := .T.
oSay60:lWordWrap := .F.
oSay60:lTransparent := .F.

oCOMISSAO := TSAY():Create(oDlg1)
oCOMISSAO:cName := "oCOMISSAO"
oCOMISSAO:cCaption := "________________________________"
oCOMISSAO:nLeft := 78
oCOMISSAO:nTop := 128
oCOMISSAO:nWidth := 198
oCOMISSAO:nHeight := 17
oCOMISSAO:lShowHint := .F.
oCOMISSAO:lReadOnly := .F.
oCOMISSAO:Align := 0
oCOMISSAO:cVariable := "cCOMISSAO"
oCOMISSAO:bSetGet := {|u| If(PCount()>0,cCOMISSAO:=u,cCOMISSAO) }
oCOMISSAO:lVisibleControl := .T.
oCOMISSAO:lWordWrap := .F.
oCOMISSAO:lTransparent := .F.

oDTSAIMERC := TSAY():Create(oDlg1)
oDTSAIMERC:cName := "oDTSAIMERC"
oDTSAIMERC:cCaption := "___________________"
oDTSAIMERC:nLeft := 650
oDTSAIMERC:nTop := 133
oDTSAIMERC:nWidth := 109
oDTSAIMERC:nHeight := 17
oDTSAIMERC:lShowHint := .F.
oDTSAIMERC:lReadOnly := .F.
oDTSAIMERC:Align := 0
oDTSAIMERC:lVisibleControl := .T.
oDTSAIMERC:lWordWrap := .F.
oDTSAIMERC:lTransparent := .F.

oALTERA := SBUTTON():Create(oDlg1)
oALTERA:cName := "oALTERA"
oALTERA:cCaption := "&Alterar"
oALTERA:nLeft := 233
oALTERA:nTop := 420
oALTERA:nWidth := 100
oALTERA:nHeight := 22
oALTERA:lShowHint := .F.
oALTERA:lReadOnly := .F.
oALTERA:Align := 0
oALTERA:lVisibleControl := .T.
oALTERA:nType := 1
oALTERA:bAction := {|| ItAltera() }

oEXCLUI := SBUTTON():Create(oDlg1)
oEXCLUI:cName := "oEXCLUI"
oEXCLUI:cCaption := "&Excluir"
oEXCLUI:nLeft := 425
oEXCLUI:nTop := 420
oEXCLUI:nWidth := 100
oEXCLUI:nHeight := 22
oEXCLUI:lShowHint := .F.
oEXCLUI:lReadOnly := .F.
oEXCLUI:Align := 0
oEXCLUI:lVisibleControl := .T.
oEXCLUI:nType := 1
oEXCLUI:bAction := {|| ItExclui() }

oQUESTION := SBUTTON():Create(oDlg1)
oQUESTION:cName := "oQUESTION"
oQUESTION:cCaption := "&Questionario"
oQUESTION:nLeft := 547
oQUESTION:nTop := 155
oQUESTION:nWidth := 100
oQUESTION:nHeight := 22
oQUESTION:lShowHint := .F.
oQUESTION:lReadOnly := .F.
oQUESTION:Align := 0
oQUESTION:lVisibleControl := .T.
oQUESTION:nType := 1
oQUESTION:bAction := {|| Question() }

oITPARECER := SBUTTON():Create(oDlg1)
oITPARECER:cName := "oITPARECER"
oITPARECER:cCaption := "Parecer &Item"
oITPARECER:nLeft := 619
oITPARECER:nTop := 420
oITPARECER:nWidth := 100
oITPARECER:nHeight := 22
oITPARECER:lShowHint := .F.
oITPARECER:lReadOnly := .F.
oITPARECER:Align := 0
oITPARECER:lVisibleControl := .T.
oITPARECER:nType := 1
oITPARECER:bAction := {|| ItParecer() }

oVLCALC := TSAY():Create(oDlg1)
oVLCALC:cName := "oVLCALC"
oVLCALC:cCaption := "_______________"
oVLCALC:nLeft := 369
oVLCALC:nTop := 465
oVLCALC:nWidth := 114
oVLCALC:nHeight := 17
oVLCALC:lShowHint := .F.
oVLCALC:lReadOnly := .F.
oVLCALC:Align := 0
oVLCALC:cVariable := "nVLCALC"
oVLCALC:bSetGet := {|u| If(PCount()>0,nVLCALC:=u,nVLCALC) }
oVLCALC:lVisibleControl := .T.
oVLCALC:lWordWrap := .F.
oVLCALC:lTransparent := .F.

oVLNEG := TSAY():Create(oDlg1)
oVLNEG:cName := "oVLNEG"
oVLNEG:cCaption := "_______________"
oVLNEG:nLeft := 652
oVLNEG:nTop := 465
oVLNEG:nWidth := 109
oVLNEG:nHeight := 17
oVLNEG:lShowHint := .F.
oVLNEG:lReadOnly := .F.
oVLNEG:Align := 0
oVLNEG:cVariable := "nVLNEG"
oVLNEG:bSetGet := {|u| If(PCount()>0,nVLNEG:=u,nVLNEG) }
oVLNEG:lVisibleControl := .T.
oVLNEG:lWordWrap := .F.
oVLNEG:lTransparent := .F.

oSay70 := TSAY():Create(oDlg1)
oSay70:cName := "oSay70"
oSay70:cCaption := "Perc. reclamado:"
oSay70:nLeft := 17
oSay70:nTop := 492
oSay70:nWidth := 86
oSay70:nHeight := 17
oSay70:lShowHint := .F.
oSay70:lReadOnly := .F.
oSay70:Align := 0
oSay70:lVisibleControl := .T.
oSay70:lWordWrap := .F.
oSay70:lTransparent := .F.

oPERC := TSAY():Create(oDlg1)
oPERC:cName := "oPERC"
oPERC:cCaption := "___________"
oPERC:nLeft := 105
oPERC:nTop := 492
oPERC:nWidth := 82
oPERC:nHeight := 17
oPERC:lShowHint := .F.
oPERC:lReadOnly := .F.
oPERC:Align := 0
oPERC:cVariable := "cPERC"
oPERC:bSetGet := {|u| If(PCount()>0,cPERC:=u,cPERC) }
oPERC:lVisibleControl := .T.
oPERC:lWordWrap := .F.
oPERC:lTransparent := .F.

oConfirmar := SBUTTON():Create(oDlg1)
oConfirmar:cName := "oConfirmar"
oConfirmar:nLeft := 552
oConfirmar:nTop := 514
oConfirmar:nWidth := 70
oConfirmar:nHeight := 25
oConfirmar:lShowHint := .F.
oConfirmar:lReadOnly := .F.
oConfirmar:Align := 0
oConfirmar:lVisibleControl := .T.
oConfirmar:nType := 1
oConfirmar:bAction := {|| AtdConfirma() }

oSair := SBUTTON():Create(oDlg1)
oSair:cName := "oSair"
oSair:nLeft := 631
oSair:nTop := 514
oSair:nWidth := 70
oSair:nHeight := 25
oSair:lShowHint := .F.
oSair:lReadOnly := .F.
oSair:Align := 0
oSair:lVisibleControl := .T.
oSair:nType := 2
oSair:bAction := {|| Sair1() }

oTIPO := TCOMBOBOX():Create(oDlg1)
oTIPO:cName := "oTIPO"
oTIPO:nLeft := 578
oTIPO:nTop := 17
oTIPO:nWidth := 186
oTIPO:nHeight := 21
oTIPO:lShowHint := .F.
oTIPO:lReadOnly := .F.
oTIPO:Align := 0
oTIPO:cVariable := "cTIPO"
oTIPO:bSetGet := {|u| If(PCount()>0,cTIPO:=u,cTIPO) }
oTIPO:lVisibleControl := .T.
oTIPO:aItems := { "1"}
oTIPO:nAt := 0

oLOJCLI := TGET():Create(oDlg1)
oLOJCLI:cName := "oLOJCLI"
oLOJCLI:nLeft := 126
oLOJCLI:nTop := 43
oLOJCLI:nWidth := 28
oLOJCLI:nHeight := 21
oLOJCLI:lShowHint := .F.
oLOJCLI:lReadOnly := .F.
oLOJCLI:Align := 0
oLOJCLI:cVariable := "cLOJCLI"
oLOJCLI:bSetGet := {|u| If(PCount()>0,cLOJCLI:=u,cLOJCLI) }
oLOJCLI:lVisibleControl := .T.
oLOJCLI:lPassword := .F.
oLOJCLI:lHasButton := .F.
oLOJCLI:bValid := {|| VldCliente() }

oSay68 := TSAY():Create(oDlg1)
oSay68:cName := "oSay68"
oSay68:cCaption := "Número:"
oSay68:nLeft := 17
oSay68:nTop := 20
oSay68:nWidth := 46
oSay68:nHeight := 17
oSay68:lShowHint := .F.
oSay68:lReadOnly := .F.
oSay68:Align := 0
oSay68:lVisibleControl := .T.
oSay68:lWordWrap := .F.
oSay68:lTransparent := .F.

oNUMERO := TSAY():Create(oDlg1)
oNUMERO:cName := "oNUMERO"
oNUMERO:cCaption := "_______________"
oNUMERO:nLeft := 65
oNUMERO:nTop := 20
oNUMERO:nWidth := 91
oNUMERO:nHeight := 17
oNUMERO:lShowHint := .F.
oNUMERO:lReadOnly := .F.
oNUMERO:Align := 0
oNUMERO:cVariable := "cNUMERO"
oNUMERO:bSetGet := {|u| If(PCount()>0,cNUMERO:=u,cNUMERO) }
oNUMERO:lVisibleControl := .T.
oNUMERO:lWordWrap := .F.
oNUMERO:lTransparent := .F.

oATDPAREC := SBUTTON():Create(oDlg1)
oATDPAREC:cName := "oATDPAREC"
oATDPAREC:cCaption := "&Parecer Atd."
oATDPAREC:nLeft := 217
oATDPAREC:nTop := 513
oATDPAREC:nWidth := 100
oATDPAREC:nHeight := 22
oATDPAREC:lShowHint := .F.
oATDPAREC:lReadOnly := .F.
oATDPAREC:Align := 0
oATDPAREC:lVisibleControl := .T.
oATDPAREC:nType := 1
oATDPAREC:bAction := {|| AtdParec() }

oCOMENT := SBUTTON():Create(oDlg1)
oCOMENT:cName := "oCOMENT"
oCOMENT:cCaption := "C&omentario cliente"
oCOMENT:nLeft := 663
oCOMENT:nTop := 155
oCOMENT:nWidth := 100
oCOMENT:nHeight := 22
oCOMENT:lShowHint := .F.
oCOMENT:lReadOnly := .F.
oCOMENT:Align := 0
oCOMENT:lVisibleControl := .T.
oCOMENT:nType := 1
oCOMENT:bAction := {|| Coment() }

oSay72 := TSAY():Create(oDlg1)
oSay72:cName := "oSay72"
oSay72:cCaption := "Localizacao:"
oSay72:nLeft := 239
oSay72:nTop := 156
oSay72:nWidth := 65
oSay72:nHeight := 17
oSay72:lShowHint := .F.
oSay72:lReadOnly := .F.
oSay72:Align := 0
oSay72:lVisibleControl := .T.
oSay72:lWordWrap := .F.
oSay72:lTransparent := .F.

oLOCAL := TGET():Create(oDlg1)
oLOCAL:cF3 := "SQB"
oLOCAL:cName := "oLOCAL"
oLOCAL:nLeft := 306
oLOCAL:nTop := 155
oLOCAL:nWidth := 42
oLOCAL:nHeight := 21
oLOCAL:lShowHint := .F.
oLOCAL:lReadOnly := .F.
oLOCAL:Align := 0
oLOCAL:cVariable := "cLOCAL"
oLOCAL:bSetGet := {|u| If(PCount()>0,cLOCAL:=u,cLOCAL) }
oLOCAL:lVisibleControl := .T.
oLOCAL:lPassword := .F.
oLOCAL:lHasButton := .F.
oLOCAL:bValid := {|| VldLocal() }

oDESCLOC := TSAY():Create(oDlg1)
oDESCLOC:cName := "oDESCLOC"
oDESCLOC:cCaption := "______________________________"
oDESCLOC:nLeft := 350
oDESCLOC:nTop := 158
oDESCLOC:nWidth := 184
oDESCLOC:nHeight := 17
oDESCLOC:lShowHint := .F.
oDESCLOC:lReadOnly := .F.
oDESCLOC:Align := 0
oDESCLOC:cVariable := "cDESCLOC"
oDESCLOC:bSetGet := {|u| If(PCount()>0,cDESCLOC:=u,cDESCLOC) }
oDESCLOC:lVisibleControl := .T.
oDESCLOC:lWordWrap := .F.
oDESCLOC:lTransparent := .F.

oDlg1:Activate()

Return
