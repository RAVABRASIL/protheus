#include "rwmake.ch"
#include "colors.ch"

User Function TMK001_5()

oDlg5 := MSDIALOG():Create()
oDlg5:cName := "oDlg5"
oDlg5:cCaption := "Comentário do cliente"
oDlg5:nLeft := 0
oDlg5:nTop := 0
oDlg5:nWidth := 621
oDlg5:nHeight := 191
oDlg5:lShowHint := .F.
oDlg5:lCentered := .T.

oCOMENT1 := TGET():Create(oDlg5)
oCOMENT1:cName := "oCOMENT1"
oCOMENT1:nLeft := 6
oCOMENT1:nTop := 6
oCOMENT1:nWidth := 603
oCOMENT1:nHeight := 21
oCOMENT1:lShowHint := .F.
oCOMENT1:lReadOnly := .F.
oCOMENT1:Align := 0
oCOMENT1:cVariable := "cCOMENT1"
oCOMENT1:bSetGet := {|u| If(PCount()>0,cCOMENT1:=u,cCOMENT1) }
oCOMENT1:lVisibleControl := .T.
oCOMENT1:lPassword := .F.
oCOMENT1:lHasButton := .F.

oCOMENT2 := TGET():Create(oDlg5)
oCOMENT2:cName := "oCOMENT2"
oCOMENT2:nLeft := 6
oCOMENT2:nTop := 30
oCOMENT2:nWidth := 603
oCOMENT2:nHeight := 21
oCOMENT2:lShowHint := .F.
oCOMENT2:lReadOnly := .F.
oCOMENT2:Align := 0
oCOMENT2:cVariable := "cCOMENT2"
oCOMENT2:bSetGet := {|u| If(PCount()>0,cCOMENT2:=u,cCOMENT2) }
oCOMENT2:lVisibleControl := .T.
oCOMENT2:lPassword := .F.
oCOMENT2:lHasButton := .F.

oCOMENT3 := TGET():Create(oDlg5)
oCOMENT3:cName := "oCOMENT3"
oCOMENT3:nLeft := 6
oCOMENT3:nTop := 54
oCOMENT3:nWidth := 603
oCOMENT3:nHeight := 21
oCOMENT3:lShowHint := .F.
oCOMENT3:lReadOnly := .F.
oCOMENT3:Align := 0
oCOMENT3:cVariable := "cCOMENT3"
oCOMENT3:bSetGet := {|u| If(PCount()>0,cCOMENT3:=u,cCOMENT3) }
oCOMENT3:lVisibleControl := .T.
oCOMENT3:lPassword := .F.
oCOMENT3:lHasButton := .F.

oCOMENT4 := TGET():Create(oDlg5)
oCOMENT4:cName := "oCOMENT4"
oCOMENT4:nLeft := 6
oCOMENT4:nTop := 78
oCOMENT4:nWidth := 603
oCOMENT4:nHeight := 21
oCOMENT4:lShowHint := .F.
oCOMENT4:lReadOnly := .F.
oCOMENT4:Align := 0
oCOMENT4:cVariable := "cCOMENT4"
oCOMENT4:bSetGet := {|u| If(PCount()>0,cCOMENT4:=u,cCOMENT4) }
oCOMENT4:lVisibleControl := .T.
oCOMENT4:lPassword := .F.
oCOMENT4:lHasButton := .F.

oCOMENT5 := TGET():Create(oDlg5)
oCOMENT5:cName := "oCOMENT5"
oCOMENT5:nLeft := 6
oCOMENT5:nTop := 105
oCOMENT5:nWidth := 603
oCOMENT5:nHeight := 21
oCOMENT5:lShowHint := .F.
oCOMENT5:lReadOnly := .F.
oCOMENT5:Align := 0
oCOMENT5:cVariable := "cCOMENT5"
oCOMENT5:bSetGet := {|u| If(PCount()>0,cCOMENT5:=u,cCOMENT5) }
oCOMENT5:lVisibleControl := .T.
oCOMENT5:lPassword := .F.
oCOMENT5:lHasButton := .F.

oSBtn7 := SBUTTON():Create(oDlg5)
oSBtn7:cName := "oSBtn7"
oSBtn7:cCaption := "oSBtn7"
oSBtn7:nLeft := 264
oSBtn7:nTop := 132
oSBtn7:nWidth := 55
oSBtn7:nHeight := 25
oSBtn7:lShowHint := .F.
oSBtn7:lReadOnly := .F.
oSBtn7:Align := 0
oSBtn7:lVisibleControl := .T.
oSBtn7:nType := 1
oSBtn7:bAction := {|| ComentCnf() }

oSBtn8 := SBUTTON():Create(oDlg5)
oSBtn8:cName := "oSBtn8"
oSBtn8:cCaption := "oSBtn8"
oSBtn8:nLeft := 331
oSBtn8:nTop := 132
oSBtn8:nWidth := 55
oSBtn8:nHeight := 25
oSBtn8:lShowHint := .F.
oSBtn8:lReadOnly := .F.
oSBtn8:Align := 0
oSBtn8:lVisibleControl := .T.
oSBtn8:nType := 2
oSBtn8:bAction := {|| Sair5() }

Return NIL
