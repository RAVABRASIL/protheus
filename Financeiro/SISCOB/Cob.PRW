User Function ICob01()

Local Cob01,SResultadoPesq,oGrp2,oGet3
Cob01 := MSDIALOG():Create()
Cob01:cName := "Cob01"
Cob01:cCaption := "CONSULTA"
Cob01:nLeft := 0
Cob01:nTop := 0
Cob01:nWidth := 800
Cob01:nHeight := 640
Cob01:lShowHint := .T.
Cob01:lCentered := .T.

SResultadoPesq := TSAY():Create(Cob01)
SResultadoPesq:cName := "SResultadoPesq"
SResultadoPesq:cCaption := "Resultado Pesquisa:"
SResultadoPesq:nLeft := 6
SResultadoPesq:nTop := 11
SResultadoPesq:nWidth := 102
SResultadoPesq:nHeight := 17
SResultadoPesq:lShowHint := .T.
SResultadoPesq:lReadOnly := .T.
SResultadoPesq:Align := 0
SResultadoPesq:lVisibleControl := .T.
SResultadoPesq:lWordWrap := .F.
SResultadoPesq:lTransparent := .T.

oGrp2 := TGROUP():Create(Cob01)
oGrp2:cName := "oGrp2"
oGrp2:cCaption := "kdnkf"
oGrp2:cMsg := "kmkkkmkm"
oGrp2:nLeft := 8
oGrp2:nTop := 473
oGrp2:nWidth := 772
oGrp2:nHeight := 83
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oGet3 := TGET():Create(Cob01)
oGet3:cName := "oGet3"
oGet3:cCaption := "oGet3"
oGet3:nLeft := 210
oGet3:nTop := 312
oGet3:nWidth := 121
oGet3:nHeight := 21
oGet3:lShowHint := .F.
oGet3:lReadOnly := .F.
oGet3:Align := 0
oGet3:lVisibleControl := .T.
oGet3:lPassword := .F.
oGet3:lHasButton := .T.

Cob01:Activate()

Return
