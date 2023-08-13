#include "rwmake.ch"
#include "colors.ch"

User Function TMK003_1()

oDlg1 := MSDIALOG():Create()
oDlg1:cName := "oDlg1"
oDlg1:cCaption := "SAC - Serviço de Atendimento a Clientes"
oDlg1:nLeft := 28
oDlg1:nTop := 14
oDlg1:nWidth := 785
oDlg1:nHeight := 580
oDlg1:lShowHint := .F.
oDlg1:lCentered := .T.

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
oTIPO:bValid := {|| VldTipo() }

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

oREPRES := TGET():Create(oDlg1)
oREPRES:cF3 := "SA3"
oREPRES:cName := "oREPRES"
oREPRES:nLeft := 93
oREPRES:nTop := 99
oREPRES:nWidth := 65
oREPRES:nHeight := 21
oREPRES:lShowHint := .F.
oREPRES:lReadOnly := .F.
oREPRES:Align := 0
oREPRES:cVariable := "cREPRES"
oREPRES:bSetGet := {|u| If(PCount()>0,cREPRES:=u,cREPRES) }
oREPRES:lVisibleControl := .T.
oREPRES:lPassword := .F.
oREPRES:lHasButton := .F.
oREPRES:bValid := {|| VldVend() }

oTRANSP := TGET():Create(oDlg1)
oTRANSP:cF3 := "SA4"
oTRANSP:cName := "oTRANSP"
oTRANSP:nLeft := 501
oTRANSP:nTop := 99
oTRANSP:nWidth := 65
oTRANSP:nHeight := 21
oTRANSP:lShowHint := .F.
oTRANSP:lReadOnly := .F.
oTRANSP:Align := 0
oTRANSP:cVariable := "cTRANSP"
oTRANSP:bSetGet := {|u| If(PCount()>0,cTRANSP:=u,cTRANSP) }
oTRANSP:lVisibleControl := .T.
oTRANSP:lPassword := .F.
oTRANSP:lHasButton := .F.
oTRANSP:bValid := {|| VldTransp() }

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
oNOMREP:cCaption := "______________________________________"
oNOMREP:nLeft := 159
oNOMREP:nTop := 102
oNOMREP:nWidth := 241
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

oHISTOR := TBUTTON():Create(oDlg1)
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

oNOMTRANSP := TSAY():Create(oDlg1)
oNOMTRANSP:cName := "oNOMTRANSP"
oNOMTRANSP:cCaption := "_______________________________"
oNOMTRANSP:nLeft := 566
oNOMTRANSP:nTop := 102
oNOMTRANSP:nWidth := 196
oNOMTRANSP:nHeight := 17
oNOMTRANSP:lShowHint := .F.
oNOMTRANSP:lReadOnly := .F.
oNOMTRANSP:Align := 0
oNOMTRANSP:cVariable := "cNOMTRANSP"
oNOMTRANSP:bSetGet := {|u| If(PCount()>0,cNOMTRANSP:=u,cNOMTRANSP) }
oNOMTRANSP:lVisibleControl := .T.
oNOMTRANSP:lWordWrap := .F.
oNOMTRANSP:lTransparent := .F.

oPOSCLI := TBUTTON():Create(oDlg1)
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
oPOSCLI:bAction := {|| CliPos() }

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

oSay54 := TSAY():Create(oDlg1)
oSay54:cName := "oSay54"
oSay54:cCaption := "Respons. p/ status:"
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

oSay56 := TSAY():Create(oDlg1)
oSay56:cName := "oSay56"
oSay56:cCaption := "Data do status:"
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

oSay58 := TSAY():Create(oDlg1)
oSay58:cName := "oSay58"
oSay58:cCaption := "Status:"
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

oQUESTION := TBUTTON():Create(oDlg1)
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
oQUESTION:bAction := {|| Question() }

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

oATDPAREC := TBUTTON():Create(oDlg1)
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
oATDPAREC:bAction := {|| AtdParec() }

oCOMENT := TBUTTON():Create(oDlg1)
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
oCOMENT:bAction := {|| Coment() }

oGrp70 := TGROUP():Create(oDlg1)
oGrp70:cName := "oGrp70"
oGrp70:cCaption := "Comentário do cliente"
oGrp70:nLeft := 5
oGrp70:nTop := 248
oGrp70:nWidth := 769
oGrp70:nHeight := 164
oGrp70:lShowHint := .F.
oGrp70:lReadOnly := .F.
oGrp70:Align := 0
oGrp70:lVisibleControl := .F.

oCOM1 := TGET():Create(oDlg1)
oCOM1:cName := "oCOM1"
oCOM1:nLeft := 15
oCOM1:nTop := 266
oCOM1:nWidth := 747
oCOM1:nHeight := 21
oCOM1:lShowHint := .F.
oCOM1:lReadOnly := .F.
oCOM1:Align := 0
oCOM1:cVariable := "cCOMENT1"
oCOM1:bSetGet := {|u| If(PCount()>0,cCOMENT1:=u,cCOMENT1) }
oCOM1:lVisibleControl := .F.
oCOM1:lPassword := .F.
oCOM1:lHasButton := .F.

oCOM2 := TGET():Create(oDlg1)
oCOM2:cName := "oCOM2"
oCOM2:nLeft := 15
oCOM2:nTop := 294
oCOM2:nWidth := 747
oCOM2:nHeight := 21
oCOM2:lShowHint := .F.
oCOM2:lReadOnly := .F.
oCOM2:Align := 0
oCOM2:cVariable := "cCOMENT2"
oCOM2:bSetGet := {|u| If(PCount()>0,cCOMENT2:=u,cCOMENT2) }
oCOM2:lVisibleControl := .F.
oCOM2:lPassword := .F.
oCOM2:lHasButton := .F.

oCOM3 := TGET():Create(oDlg1)
oCOM3:cName := "oCOM3"
oCOM3:nLeft := 15
oCOM3:nTop := 323
oCOM3:nWidth := 747
oCOM3:nHeight := 21
oCOM3:lShowHint := .F.
oCOM3:lReadOnly := .F.
oCOM3:Align := 0
oCOM3:cVariable := "cCOMENT3"
oCOM3:bSetGet := {|u| If(PCount()>0,cCOMENT3:=u,cCOMENT3) }
oCOM3:lVisibleControl := .F.
oCOM3:lPassword := .F.
oCOM3:lHasButton := .F.

oCOM4 := TGET():Create(oDlg1)
oCOM4:cName := "oCOM4"
oCOM4:nLeft := 15
oCOM4:nTop := 351
oCOM4:nWidth := 747
oCOM4:nHeight := 21
oCOM4:lShowHint := .F.
oCOM4:lReadOnly := .F.
oCOM4:Align := 0
oCOM4:cVariable := "cCOMENT4"
oCOM4:bSetGet := {|u| If(PCount()>0,cCOMENT4:=u,cCOMENT4) }
oCOM4:lVisibleControl := .F.
oCOM4:lPassword := .F.
oCOM4:lHasButton := .F.

oCOM5 := TGET():Create(oDlg1)
oCOM5:cName := "oCOM5"
oCOM5:nLeft := 15
oCOM5:nTop := 381
oCOM5:nWidth := 747
oCOM5:nHeight := 21
oCOM5:lShowHint := .F.
oCOM5:lReadOnly := .F.
oCOM5:Align := 0
oCOM5:cVariable := "cCOMENT5"
oCOM5:bSetGet := {|u| If(PCount()>0,cCOMENT5:=u,cCOMENT5) }
oCOM5:lVisibleControl := .F.
oCOM5:lPassword := .F.
oCOM5:lHasButton := .F.

oGrp76 := TGROUP():Create(oDlg1)
oGrp76:cName := "oGrp76"
oGrp76:cCaption := "Ocorrência"
oGrp76:nLeft := 5
oGrp76:nTop := 189
oGrp76:nWidth := 769
oGrp76:nHeight := 54
oGrp76:lShowHint := .F.
oGrp76:lReadOnly := .F.
oGrp76:Align := 0
oGrp76:lVisibleControl := .F.

oOCORR := TCOMBOBOX():Create(oDlg1)
oOCORR:cName := "oOCORR"
oOCORR:nLeft := 15
oOCORR:nTop := 209
oOCORR:nWidth := 376
oOCORR:nHeight := 21
oOCORR:lShowHint := .F.
oOCORR:lReadOnly := .F.
oOCORR:Align := 0
oOCORR:cVariable := "cOCORRENCIA"
oOCORR:bSetGet := {|u| If(PCount()>0,cOCORRENCIA:=u,cOCORRENCIA) }
oOCORR:lVisibleControl := .F.
oOCORR:nAt := 0

oGRP2:SetColor( CLR_HBLUE )
oGRP42:SetColor( CLR_GREEN )
oGrp70:SetColor( CLR_RED )
oGrp76:SetColor( CLR_MAGENTA )

oNUMERO:SetFont( oFNT_1 )
oNUMERO:nCLRTEXT := CLR_MAGENTA
oNOMOPER:SetFont( oFNT_2 )
oNOMOPER:nCLRTEXT := CLR_BROWN
oNOMREP:SetFont( oFNT_2 )
oNOMREP:nCLRTEXT := CLR_BROWN
oNOMTRANSP:SetFont( oFNT_2 )
oNOMTRANSP:nCLRTEXT := CLR_BROWN
oCOMISSAO:SetFont( oFNT_2 )
oCOMISSAO:nCLRTEXT := CLR_BROWN
oDTSAIMERC:SetFont( oFNT_2 )
oDTSAIMERC:nCLRTEXT := CLR_BROWN
oNOMECLI:SetFont( oFNT_2 )
oNOMECLI:nCLRTEXT := CLR_BROWN
oVLPED:SetFont( oFNT_2 )
oVLPED:nCLRTEXT := CLR_BROWN

oTIPO:aItems    := aTIPOITENS
oSOLUCAO:aItems := aSOLUITENS

Return NIL
