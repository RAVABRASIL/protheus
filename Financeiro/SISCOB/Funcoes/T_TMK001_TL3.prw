#include "rwmake.ch"
#include "colors.ch"

User Function TMK001_3()

oDlg3 := MSDIALOG():Create()
oDlg3:cName := "oDlg3"
oDlg3:cCaption := "Questionário"
oDlg3:nLeft := 0
oDlg3:nTop := 0
oDlg3:nWidth := 704
oDlg3:nHeight := 286
oDlg3:lShowHint := .F.
oDlg3:lCentered := .T.

oSay1 := TSAY():Create(oDlg3)
oSay1:cName := "oSay1"
oSay1:cCaption := "Pergunta:"
oSay1:nLeft := 11
oSay1:nTop := 180
oSay1:nWidth := 53
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oSay4 := TSAY():Create(oDlg3)
oSay4:cName := "oSay4"
oSay4:cCaption := "Resposta:"
oSay4:nLeft := 11
oSay4:nTop := 206
oSay4:nWidth := 53
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oRESPT := TGET():Create(oDlg3)
oRESPT:cName := "oRESPT"
oRESPT:nLeft := 65
oRESPT:nTop := 203
oRESPT:nWidth := 495
oRESPT:nHeight := 21
oRESPT:lShowHint := .F.
oRESPT:lReadOnly := .F.
oRESPT:Align := 0
oRESPT:cVariable := "cRESPT"
oRESPT:bSetGet := {|u| If(PCount()>0,cRESPT:=u,cRESPT) }
oRESPT:lVisibleControl := .T.
oRESPT:lPassword := .F.
oRESPT:lHasButton := .F.

oQUESTS := TBUTTON():Create(oDlg3)
oQUESTS:cName := "oQUESTS"
oQUESTS:cCaption := "&Sim"
oQUESTS:nLeft := 566
oQUESTS:nTop := 200
oQUESTS:nWidth := 52
oQUESTS:nHeight := 25
oQUESTS:lShowHint := .F.
oQUESTS:lReadOnly := .F.
oQUESTS:Align := 0
oQUESTS:lVisibleControl := .T.
oQUESTS:bAction := {|| BotQuest( "S" ) }

oQUESTN := TBUTTON():Create(oDlg3)
oQUESTN:cName := "oQUESTN"
oQUESTN:cCaption := "&Nao"
oQUESTN:nLeft := 627
oQUESTN:nTop := 200
oQUESTN:nWidth := 52
oQUESTN:nHeight := 25
oQUESTN:lShowHint := .F.
oQUESTN:lReadOnly := .F.
oQUESTN:Align := 0
oQUESTN:lVisibleControl := .T.
oQUESTN:bAction := {|| BotQuest( "N" ) }

oQUEST := TSAY():Create(oDlg3)
oQUEST:cName := "oQUEST"
oQUEST:nLeft := 65
oQUEST:nTop := 180
oQUEST:nWidth := 620
oQUEST:nHeight := 17
oQUEST:lShowHint := .F.
oQUEST:lReadOnly := .F.
oQUEST:Align := 0
oQUEST:lVisibleControl := .T.
oQUEST:lWordWrap := .F.
oQUEST:lTransparent := .F.

oQUESTCONF := SBUTTON():Create(oDlg3)
oQUESTCONF:cName := "oQUESTCONF"
oQUESTCONF:nLeft := 293
oQUESTCONF:nTop := 233
oQUESTCONF:nWidth := 52
oQUESTCONF:nHeight := 24
oQUESTCONF:lShowHint := .F.
oQUESTCONF:lReadOnly := .F.
oQUESTCONF:Align := 0
oQUESTCONF:lVisibleControl := .T.
oQUESTCONF:nType := 1
oQUESTCONF:bAction := {|| QuestConf() }

oQUESTCANC := SBUTTON():Create(oDlg3)
oQUESTCANC:cName := "oQUESTCANC"
oQUESTCANC:nLeft := 359
oQUESTCANC:nTop := 233
oQUESTCANC:nWidth := 52
oQUESTCANC:nHeight := 24
oQUESTCANC:lShowHint := .F.
oQUESTCANC:lReadOnly := .F.
oQUESTCANC:Align := 0
oQUESTCANC:lVisibleControl := .T.
oQUESTCANC:nType := 2
oQUESTCANC:bAction := {|| Sair3() }

oGrp12 := TGROUP():Create(oDlg3)
oGrp12:cName := "oGrp12"
oGrp12:cCaption := "Questionário"
oGrp12:nLeft := 3
oGrp12:nTop := 165
oGrp12:nWidth := 690
oGrp12:nHeight := 68
oGrp12:lShowHint := .F.
oGrp12:lReadOnly := .F.
oGrp12:Align := 0
oGrp12:lVisibleControl := .T.

oGRP12:SetColor( CLR_HBLUE )

Return NIL
