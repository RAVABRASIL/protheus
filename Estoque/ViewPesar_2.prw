#Include "RwMake.ch"
#Include "font.ch"
#Include "colors.ch"
#Include "topconn.ch"

*********************
User Function ViewPsr_2()
*********************

SetPrvt( "nCONT, nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cLado, cPORTA, nSACOS, oSACOS, lINCOMP, nHandle, aUSUARIO, aUSUARI2, oTIPO, cTIPO, aTIPO, " )
SetPrvt( "nQTDLIB, cUSULIM, nLIMITE, cSEQ, cNOMUSUA,oChkFOP,lFinal, " )

Private cRegRed := ""

DEFINE FONT oFont NAME "Courier New" SIZE 6, 19 BOLD //6, 20//0, -128
DEFINE FONT oFontOP NAME "Arial" SIZE 17, 31 BOLD //6, 20//0, -128
DEFINE FONT oFontDes NAME "Arial" SIZE 7, 30 BOLD //6, 20//0, -128
DEFINE FONT oFontTit NAME "Arial" SIZE 0, 14 BOLD //6, 20//0, -128
DEFINE FONT oFontNum NAME "Arial" SIZE 0, 25 BOLD //6, 20//0, -128

//Local oDlg,oGrp1,oGrp2,oGrp3,oSayOP,oGetOP,oSayMaq,oGetMaq,oSayQFD,oGetQFD,oSayPKG01,oSayPKG02,oChkINC,oSayQSac,oGetQSac,oSBtnLer,oSBtnReimp,oSBtnCanc,oSayTit01,oSayReg01,oSayReg02,oSayReg03,oSayReg04,oSayReg05,oSayReg06,oSayReg07,oSayReg08,oSayReg09,oSayReg10,oSayReg11,oSayReg12,oSayReg13,oSayReg14,oSayReg15,oSayReg16,oSayReg17,oSayReg18,oSayReg19,oSayReg20,oSayReg21,oSayReg22,oSayReg23,oSayReg24,oSayReg25,oSayReg26,oSayReg27,oSayTit02,oSayReg28,oSayReg29,oSayReg30,oSayReg31,oSayReg32,oSayReg33,oSayReg34,oSayReg35,oSayReg36,oSayReg37,oSayReg38,oSayReg39,oGrp4,oSayINFO01,oSayINFO02,oSayINFO03,oSayPESADA,oSayPROCES,oSayREST,oSayINFO04,oSayINFO05,oSayINFO06

latua		:= .T.
cOP	  	:= Space( 11 )
cMAQ		:= Space( 06 )
//nQUANT	:= 1
cProduto	:= Nil
cDescric	:= Nil
//lIncomp	:= .F.
//nSACOS	:= 0

nTOLERA := Getmv( "MV_PESOTOL" )
nLIMITE := GetMv( "MV_LIMAXOP" )
SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB5->( DbSetOrder( 1 ) )
SH1->( DbSetOrder( 1 ) )
SG1->( DbSetOrder( 1 ) )
Z00->( DbSetOrder( 1 ) )
nHANDLE   := -1
//cPORTABAL := "1" //retirado para testes em 26/12/06
cPORTABAL := "4"
cPORTAIMP := "3"
aIMP      := {}
aUSUARIO  := {}
aUSUARI2  := {}
nPESO     := 0
nSACOS    := 0
nQTDLIB   := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
nQUANT    := 1
lIncomp   := .F.
lFinal    := .F.
cLado		:= Space(1)

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Ordens em Producao em Processo ate o Momento"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 800
oDlg:nHeight := 600
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 5
oGrp1:nTop := 5
oGrp1:nWidth := 390
oGrp1:nHeight := 565
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oGrp2 := TGROUP():Create(oDlg)
oGrp2:cName := "oGrp2"
oGrp2:nLeft := 400
oGrp2:nTop := 5
oGrp2:nWidth := 390
oGrp2:nHeight := 272
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oGrp3 := TGROUP():Create(oDlg)
oGrp3:cName := "oGrp3"
oGrp3:nLeft := 400
oGrp3:nTop := 433
oGrp3:nWidth := 390
oGrp3:nHeight := 136
oGrp3:lShowHint := .F.
oGrp3:lReadOnly := .F.
oGrp3:Align := 0
oGrp3:lVisibleControl := .T.

oSayOP := TSAY():Create(oDlg)
oSayOP:cName := "oSayOP"
oSayOP:cCaption := "&OP :"
oSayOP:nLeft := 406
oSayOP:nTop := 445
oSayOP:nWidth := 25
oSayOP:nHeight := 17
oSayOP:lShowHint := .F.
oSayOP:lReadOnly := .F.
oSayOP:Align := 0
oSayOP:lVisibleControl := .T.
oSayOP:lWordWrap := .F.
oSayOP:lTransparent := .F.

oGetOP := TGET():Create(oDlg)
oGetOP:cF3 := "SC2"
oGetOP:cName := "oGetOP"
oGetOP:cCaption := cOP//"01289901001"
oGetOP:nLeft := 435
oGetOP:nTop := 442
oGetOP:nWidth := 93
oGetOP:nHeight := 21
oGetOP:lShowHint := .F.
oGetOP:lReadOnly := .F.
oGetOP:Align := 0
oGetOP:lVisibleControl := .T.
oGetOP:lPassword := .F.
oGetOP:lHasButton := .F.
oGetOP:Picture := "@!"
oGetOP:bValid := {|| PesqOp( cOP )}
oGetOP:bSetGet := {|u| If(PCount()>0,cOP:=u,cOP) }

oSayMaq := TSAY():Create(oDlg)
oSayMaq:cName := "oSayMaq"
oSayMaq:cCaption := "&Maq. :"
oSayMaq:nLeft := 549
oSayMaq:nTop := 444
oSayMaq:nWidth := 37
oSayMaq:nHeight := 17
oSayMaq:lShowHint := .F.
oSayMaq:lReadOnly := .F.
oSayMaq:Align := 0
oSayMaq:lVisibleControl := .T.
oSayMaq:lWordWrap := .F.
oSayMaq:lTransparent := .F.

oGetMaq := TGET():Create(oDlg)
oGetMaq:cF3 := "SH1"
oGetMaq:cName := "oGetMaq"
oGetMaq:cCaption := "C01"
oGetMaq:nLeft := 588
oGetMaq:nTop := 442
oGetMaq:nWidth := 45
oGetMaq:nHeight := 21
oGetMaq:lShowHint := .F.
oGetMaq:lReadOnly := .F.
oGetMaq:Align := 0
oGetMaq:lVisibleControl := .T.
oGetMaq:lPassword := .F.
oGetMaq:lHasButton := .F.
oGetMaq:Picture := "@!"
oGetMaq:bValid := {|| PesqMaq( cMAQ )}
oGetMaq:bSetGet := {|u| If(PCount()>0,cMAQ:=u,cMAQ) }

oSayQFD := TSAY():Create(oDlg)
oSayQFD:cName := "oSayQFD"
oSayQFD:cCaption := "Qtd. &Fardos :"
oSayQFD:nLeft := 654
oSayQFD:nTop := 445
oSayQFD:nWidth := 66
oSayQFD:nHeight := 18
oSayQFD:lShowHint := .F.
oSayQFD:lReadOnly := .F.
oSayQFD:Align := 0
oSayQFD:lVisibleControl := .T.
oSayQFD:lWordWrap := .F.
oSayQFD:lTransparent := .F.

oGetQFD := TGET():Create(oDlg)
oGetQFD:cName := "oGetQFD"
oGetQFD:cCaption := Str(nQUANT)
oGetQFD:nLeft := 722
oGetQFD:nTop := 442
oGetQFD:nWidth := 38
oGetQFD:nHeight := 21
oGetQFD:lShowHint := .F.
oGetQFD:lReadOnly := .F.
oGetQFD:Align := 0
oGetQFD:lVisibleControl := .T.
oGetQFD:lPassword := .F.
oGetQFD:lHasButton := .F.
oGetQFD:Picture := "@E 99"
oGetQFD:bValid := {|| AtuPeso( nQUANT )}
oGetQFD:bSetGet := {|u| If(PCount()>0,nQUANT:=u,nQUANT) }

oSayPKG01 := TSAY():Create(oDlg)
oSayPKG01:cName := "oSayPKG01"
oSayPKG01:cCaption := "Peso em (KG) :"
oSayPKG01:nLeft := 650
oSayPKG01:nTop := 508  //478
oSayPKG01:nWidth := 70
oSayPKG01:nHeight := 17
oSayPKG01:lShowHint := .F.
oSayPKG01:lReadOnly := .F.
oSayPKG01:Align := 0
oSayPKG01:lVisibleControl := .T.
oSayPKG01:lWordWrap := .F.
oSayPKG01:lTransparent := .F.

oSayPKG02 := TSAY():Create(oDlg)
oSayPKG02:cName := "oSayPKG02"
oSayPKG02:cCaption := ""
oSayPKG02:nLeft := 720
oSayPKG02:nTop := 508  //478
oSayPKG02:nWidth := 47
oSayPKG02:nHeight := 17
oSayPKG02:lShowHint := .F.
oSayPKG02:lReadOnly := .F.
oSayPKG02:Align := 0
oSayPKG02:lVisibleControl := .T.
oSayPKG02:lWordWrap := .F.
oSayPKG02:lTransparent := .F.

//FR - 14/05/2011
//colocar em produção qdo Ivonei autorizar
/*
oSayLAD := TSAY():Create(oDlg)
oSayLAD:cName := "oSayLAD"
oSayLAD:cCaption := "&Lado MAQ:"
oSayLAD:nLeft := 521       //644
oSayLAD:nTop := 478        //520
oSayLAD:nWidth := 66
oSayLAD:nHeight := 18
oSayLAD:lShowHint := .F.
oSayLAD:lReadOnly := .F.
oSayLAD:Align := 0
oSayLAD:lVisibleControl := .T.
oSayLAD:lWordWrap := .F.
oSayLAD:lTransparent := .F.

oGetLAD := TGET():Create(oDlg)
oGetLAD:cF3 := "ZC"
oGetLAD:cName := "oGetLAD"
oGetLAD:cCaption := cLado
oGetLAD:nLeft := 579            //720
oGetLAD:nTop := 478             //522
oGetLAD:nWidth := 38
oGetLAD:nHeight := 21
oGetLAD:lShowHint := .F.
oGetLAD:lReadOnly := .F.
oGetLAD:Align := 0
oGetLAD:lVisibleControl := .T.
oGetLAD:lPassword := .F.
oGetLAD:lHasButton := .F.
oGetLAD:Picture := "@!"
//oGetLAD:bValid := {|| ValidLado( cLado )}
oGetLAD:bSetGet := {|u| If(PCount()>0,cLado:=u,cLado) }
*/

oChkINC := TCHECKBOX():Create(oDlg)
oChkINC:cName := "oChkINC"
oChkINC:cCaption := "&Incompleto ?"
oChkINC:nLeft := 409
oChkINC:nTop := 484
oChkINC:nWidth := 89
oChkINC:nHeight := 17
oChkINC:lShowHint := .F.
oChkINC:lReadOnly := .F.
oChkINC:Align := 0
oChkINC:lVisibleControl := .T.
oChkINC:bChange := {|| Incomp() }
oChkINC:bSetGet := {|u| If(PCount()>0,lIncomp:=u,lIncomp) }
oChkINC:cVariable := "lIncomp"

/**/
oChkFOP                 := TCHECKBOX():Create(oDlg)
oChkFOP:cName           := "oChkFOP"
oChkFOP:cCaption        := "&Finalizar OP ?"
oChkFOP:nLeft           := 409
oChkFOP:nTop            := 508
oChkFOP:nWidth          := 89
oChkFOP:nHeight         := 17
oChkFOP:lShowHint       := .F.
oChkFOP:lReadOnly       := .F.
oChkFOP:Align           :=  0
oChkFOP:lVisibleControl := .T.
oChkFOP:bChange         := { || endOP( cOP, 1 ) }
oChkFOP:bSetGet         := {|u| If(PCount()>0,lFinal:=u,lFinal) }
oChkFOP:cVariable       := "lFinal"
/**/

oSayQSac := TSAY():Create(oDlg)
oSayQSac:cName := "oSayQSac"
oSayQSac:cCaption := "Qtd. &Sacos :"
oSayQSac:nLeft := 516 //521
oSayQSac:nTop := 508  //486
oSayQSac:nWidth := 65
oSayQSac:nHeight := 17
oSayQSac:lShowHint := .F.
oSayQSac:lReadOnly := .F.
oSayQSac:Align := 0
oSayQSac:lVisibleControl := .F.
oSayQSac:lWordWrap := .F.
oSayQSac:lTransparent := .F.

oGetQSac := TGET():Create(oDlg)
oGetQSac:cName := "oGetQSac"
oGetQSac:cCaption := Str(nSACOS)
oGetQSac:nLeft := 588
oGetQSac:nTop := 506    //482
oGetQSac:nWidth := 45
oGetQSac:nHeight := 21
oGetQSac:lShowHint := .F.
oGetQSac:lReadOnly := .F.
oGetQSac:Align := 0
oGetQSac:lVisibleControl := .F.
oGetQSac:lPassword := .F.
oGetQSac:Picture := "@E 999,999"
oGetQSac:lHasButton := .F.
oGetQSac:bValid := {|| Sacos()}
oGetQSac:bSetGet := {|u| If(PCount()>0,nSACOS:=u,nSACOS) }

//@ 412,536 Button "_Ler balanca" Size 50,15 Action Pegar()
//@ 564,536 Button "_Reimp.etiq." Size 50,15 Action Reimprime()


//oSBtnLer := SBUTTON():Create(oDlg)
oSBtnLer := TBUTTON():Create(oDlg)
oSBtnLer:cName := "oSBtnLer"
oSBtnLer:cCaption := "Ler balanca"
oSBtnLer:nLeft := 412
oSBtnLer:nTop := 536
oSBtnLer:nWidth := 80//53
oSBtnLer:nHeight := 30//23
oSBtnLer:lShowHint := .F.
oSBtnLer:lReadOnly := .F.
oSBtnLer:Align := 0
oSBtnLer:lVisibleControl := .T.
//oSBtnLer:nType := 1
oSBtnLer:bLClicked := {|| Pegar() }
//oSBtnLer:bLClicked := {|| AtuRegs() }

//oSBtnReimp := SBUTTON():Create(oDlg)
oSBtnReimp := TBUTTON():Create(oDlg)
oSBtnReimp:cName := "oSBtnReimp"
oSBtnReimp:cCaption := "Reimprimir"
oSBtnReimp:nLeft := 564
oSBtnReimp:nTop := 536
oSBtnReimp:nWidth := 80//52
oSBtnReimp:nHeight := 30//22
oSBtnReimp:lShowHint := .F.
oSBtnReimp:lReadOnly := .F.
oSBtnReimp:Align := 0
oSBtnReimp:lVisibleControl := .T.
//oSBtnReimp:nType := 5
oSBtnReimp:bLClicked := {|| Reimprime() }

oSBtnCanc := SBUTTON():Create(oDlg)
oSBtnCanc:cName := "oSBtnCanc"
oSBtnCanc:cCaption := "Cancelar"
oSBtnCanc:nLeft := 703
oSBtnCanc:nTop := 536
oSBtnCanc:nWidth := 52
oSBtnCanc:nHeight := 22
oSBtnCanc:lShowHint := .F.
oSBtnCanc:lReadOnly := .F.
oSBtnCanc:Align := 0
oSBtnCanc:lVisibleControl := .T.
oSBtnCanc:nType := 2
oSBtnCanc:bLClicked := {|| Close(oDlg) }

oSayTit01 := TSAY():Create(oDlg)
oSayTit01:cName := "oSayTit01"
oSayTit01:cCaption := "Produto     Cod. OP   Maq.     Program.     Saldo    Qtd.Turno"
oSayTit01:nLeft := 13
oSayTit01:nTop := 10
oSayTit01:nWidth := 372
oSayTit01:nHeight := 17
oSayTit01:lShowHint := .F.
oSayTit01:lReadOnly := .F.
oSayTit01:Align := 0
oSayTit01:lVisibleControl := .T.
oSayTit01:lWordWrap := .F.
oSayTit01:lTransparent := .F.
oSayTit01:SetFont( oFont )

oSayReg01 := TSAY():Create(oDlg)
oSayReg01:cName := "oSayReg01"
oSayReg01:cCaption := "" // "DDAR021     012872    C01     100,00 ML   100,00 ML     99"
oSayReg01:nLeft := 13
oSayReg01:nTop := 33
oSayReg01:nWidth := 378
oSayReg01:nHeight := 17
oSayReg01:lShowHint := .F.
oSayReg01:lReadOnly := .F.
oSayReg01:Align := 0
oSayReg01:lVisibleControl := .T.
oSayReg01:lWordWrap := .F.
oSayReg01:lTransparent := .F.
oSayReg01:SetFont( oFont )

oSayReg02 := TSAY():Create(oDlg)
oSayReg02:cName := "oSayReg02"
oSayReg02:cCaption := "" //"DDAR021     013273    C01     100,00 ML   100,00 ML     99"
oSayReg02:nLeft := 13
oSayReg02:nTop := 53
oSayReg02:nWidth := 378
oSayReg02:nHeight := 17
oSayReg02:lShowHint := .F.
oSayReg02:lReadOnly := .F.
oSayReg02:Align := 0
oSayReg02:lVisibleControl := .T.
oSayReg02:lWordWrap := .F.
oSayReg02:lTransparent := .F.
oSayReg02:SetFont( oFont )

oSayReg03 := TSAY():Create(oDlg)
oSayReg03:cName := "oSayReg03"
oSayReg03:cCaption := "" //"DDAR021     012874    C01     100,00 ML   100,00 ML     99"//""
oSayReg03:nLeft := 13
oSayReg03:nTop := 73
oSayReg03:nWidth := 378
oSayReg03:nHeight := 17
oSayReg03:lShowHint := .F.
oSayReg03:lReadOnly := .F.
oSayReg03:Align := 0
oSayReg03:lVisibleControl := .T.
oSayReg03:lWordWrap := .F.
oSayReg03:lTransparent := .F.
oSayReg03:SetFont( oFont )

oSayReg04 := TSAY():Create(oDlg)
oSayReg04:cName := "oSayReg04"
oSayReg04:cCaption := "" //"DDAR021     012875    C01     100,00 ML   100,00 ML     99"
oSayReg04:nLeft := 13
oSayReg04:nTop := 93
oSayReg04:nWidth := 378
oSayReg04:nHeight := 17
oSayReg04:lShowHint := .F.
oSayReg04:lReadOnly := .F.
oSayReg04:Align := 0
oSayReg04:lVisibleControl := .T.
oSayReg04:lWordWrap := .F.
oSayReg04:lTransparent := .F.
oSayReg04:SetFont( oFont )

oSayReg05 := TSAY():Create(oDlg)
oSayReg05:cName := "oSayReg05"
oSayReg05:cCaption := "" //"DDAR021     012876    C01     100,00 ML   100,00 ML     99"
oSayReg05:nLeft := 13
oSayReg05:nTop := 113
oSayReg05:nWidth := 378
oSayReg05:nHeight := 17
oSayReg05:lShowHint := .F.
oSayReg05:lReadOnly := .F.
oSayReg05:Align := 0
oSayReg05:lVisibleControl := .T.
oSayReg05:lWordWrap := .F.
oSayReg05:lTransparent := .F.
oSayReg05:SetFont( oFont )

oSayReg06 := TSAY():Create(oDlg)
oSayReg06:cName := "oSayReg06"
oSayReg06:cCaption := "" //"DDAR021     012877    C01     100,00 ML   100,00 ML     99"
oSayReg06:nLeft := 13
oSayReg06:nTop := 133
oSayReg06:nWidth := 378
oSayReg06:nHeight := 17
oSayReg06:lShowHint := .F.
oSayReg06:lReadOnly := .F.
oSayReg06:Align := 0
oSayReg06:lVisibleControl := .T.
oSayReg06:lWordWrap := .F.
oSayReg06:lTransparent := .F.
oSayReg06:SetFont( oFont )

oSayReg07 := TSAY():Create(oDlg)
oSayReg07:cName := "oSayReg07"
oSayReg07:cCaption := "" //"DDAR021     012878    C01     100,00 ML   100,00 ML     99"
oSayReg07:nLeft := 13
oSayReg07:nTop := 153
oSayReg07:nWidth := 378
oSayReg07:nHeight := 17
oSayReg07:lShowHint := .F.
oSayReg07:lReadOnly := .F.
oSayReg07:Align := 0
oSayReg07:lVisibleControl := .T.
oSayReg07:lWordWrap := .F.
oSayReg07:lTransparent := .F.
oSayReg07:SetFont( oFont )

oSayReg08 := TSAY():Create(oDlg)
oSayReg08:cName := "oSayReg08"
oSayReg08:cCaption := "" //"DDAR021     012879    C01     100,00 ML   100,00 ML     99"
oSayReg08:nLeft := 13
oSayReg08:nTop := 173
oSayReg08:nWidth := 378
oSayReg08:nHeight := 17
oSayReg08:lShowHint := .F.
oSayReg08:lReadOnly := .F.
oSayReg08:Align := 0
oSayReg08:lVisibleControl := .T.
oSayReg08:lWordWrap := .F.
oSayReg08:lTransparent := .F.
oSayReg08:SetFont( oFont )

oSayReg09 := TSAY():Create(oDlg)
oSayReg09:cName := "oSayReg09"
oSayReg09:cCaption := "" //"DDAR021     012870    C01     100,00 ML   100,00 ML     99"
oSayReg09:nLeft := 13
oSayReg09:nTop := 193
oSayReg09:nWidth := 378
oSayReg09:nHeight := 17
oSayReg09:lShowHint := .F.
oSayReg09:lReadOnly := .F.
oSayReg09:Align := 0
oSayReg09:lVisibleControl := .T.
oSayReg09:lWordWrap := .F.
oSayReg09:lTransparent := .F.
oSayReg09:SetFont( oFont )

oSayReg10 := TSAY():Create(oDlg)
oSayReg10:cName := "oSayReg10"
oSayReg10:cCaption := "" //"DDAR021     012871    C01     100,00 ML   100,00 ML     99"
oSayReg10:nLeft := 13
oSayReg10:nTop := 213
oSayReg10:nWidth := 378
oSayReg10:nHeight := 17
oSayReg10:lShowHint := .F.
oSayReg10:lReadOnly := .F.
oSayReg10:Align := 0
oSayReg10:lVisibleControl := .T.
oSayReg10:lWordWrap := .F.
oSayReg10:lTransparent := .F.
oSayReg10:SetFont( oFont )

oSayReg11 := TSAY():Create(oDlg)
oSayReg11:cName := "oSayReg11"
oSayReg11:cCaption := "" //"DDAR021     012872    C01     100,00 ML   100,00 ML     99"
oSayReg11:nLeft := 13
oSayReg11:nTop := 233
oSayReg11:nWidth := 378
oSayReg11:nHeight := 17
oSayReg11:lShowHint := .F.
oSayReg11:lReadOnly := .F.
oSayReg11:Align := 0
oSayReg11:lVisibleControl := .T.
oSayReg11:lWordWrap := .F.
oSayReg11:lTransparent := .F.
oSayReg11:SetFont( oFont )

oSayReg12 := TSAY():Create(oDlg)
oSayReg12:cName := "oSayReg12"
oSayReg12:cCaption := "" //"DDAR021     012873    C01     100,00 ML   100,00 ML     99"
oSayReg12:nLeft := 13
oSayReg12:nTop := 253
oSayReg12:nWidth := 378
oSayReg12:nHeight := 17
oSayReg12:lShowHint := .F.
oSayReg12:lReadOnly := .F.
oSayReg12:Align := 0
oSayReg12:lVisibleControl := .T.
oSayReg12:lWordWrap := .F.
oSayReg12:lTransparent := .F.
oSayReg12:SetFont( oFont )

oSayReg13 := TSAY():Create(oDlg)
oSayReg13:cName := "oSayReg13"
oSayReg13:cCaption := "" //"DDAR021     012874    C01     100,00 ML   100,00 ML     99"
oSayReg13:nLeft := 13
oSayReg13:nTop := 273
oSayReg13:nWidth := 378
oSayReg13:nHeight := 17
oSayReg13:lShowHint := .F.
oSayReg13:lReadOnly := .F.
oSayReg13:Align := 0
oSayReg13:lVisibleControl := .T.
oSayReg13:lWordWrap := .F.
oSayReg13:lTransparent := .F.
oSayReg13:SetFont( oFont )

oSayReg14 := TSAY():Create(oDlg)
oSayReg14:cName := "oSayReg14"
oSayReg14:cCaption := "" //"DDAR021     012875    C01     100,00 ML   100,00 ML     99"
oSayReg14:nLeft := 13
oSayReg14:nTop := 293
oSayReg14:nWidth := 378
oSayReg14:nHeight := 17
oSayReg14:lShowHint := .F.
oSayReg14:lReadOnly := .F.
oSayReg14:Align := 0
oSayReg14:lVisibleControl := .T.
oSayReg14:lWordWrap := .F.
oSayReg14:lTransparent := .F.
oSayReg14:SetFont( oFont )

oSayReg15 := TSAY():Create(oDlg)
oSayReg15:cName := "oSayReg15"
oSayReg15:cCaption := "" //"DDAR021     012876    C01     100,00 ML   100,00 ML     99"
oSayReg15:nLeft := 13
oSayReg15:nTop := 313
oSayReg15:nWidth := 378
oSayReg15:nHeight := 17
oSayReg15:lShowHint := .F.
oSayReg15:lReadOnly := .F.
oSayReg15:Align := 0
oSayReg15:lVisibleControl := .T.
oSayReg15:lWordWrap := .F.
oSayReg15:lTransparent := .F.
oSayReg15:SetFont( oFont )

oSayReg16 := TSAY():Create(oDlg)
oSayReg16:cName := "oSayReg16"
oSayReg16:cCaption := "" //"DDAR021     012877    C01     100,00 ML   100,00 ML     99"
oSayReg16:nLeft := 13
oSayReg16:nTop := 333
oSayReg16:nWidth := 378
oSayReg16:nHeight := 17
oSayReg16:lShowHint := .F.
oSayReg16:lReadOnly := .F.
oSayReg16:Align := 0
oSayReg16:lVisibleControl := .T.
oSayReg16:lWordWrap := .F.
oSayReg16:lTransparent := .F.
oSayReg16:SetFont( oFont )

oSayReg17 := TSAY():Create(oDlg)
oSayReg17:cName := "oSayReg17"
oSayReg17:cCaption := "" //"DDAR021     012878    C01     100,00 ML   100,00 ML     99"
oSayReg17:nLeft := 13
oSayReg17:nTop := 353
oSayReg17:nWidth := 378
oSayReg17:nHeight := 17
oSayReg17:lShowHint := .F.
oSayReg17:lReadOnly := .F.
oSayReg17:Align := 0
oSayReg17:lVisibleControl := .T.
oSayReg17:lWordWrap := .F.
oSayReg17:lTransparent := .F.
oSayReg17:SetFont( oFont )

oSayReg18 := TSAY():Create(oDlg)
oSayReg18:cName := "oSayReg18"
oSayReg18:cCaption := "" //"DDAR021     012879    C01     100,00 ML   100,00 ML     99"
oSayReg18:nLeft := 13
oSayReg18:nTop := 373
oSayReg18:nWidth := 378
oSayReg18:nHeight := 17
oSayReg18:lShowHint := .F.
oSayReg18:lReadOnly := .F.
oSayReg18:Align := 0
oSayReg18:lVisibleControl := .T.
oSayReg18:lWordWrap := .F.
oSayReg18:lTransparent := .F.
oSayReg18:SetFont( oFont )

oSayReg19 := TSAY():Create(oDlg)
oSayReg19:cName := "oSayReg19"
oSayReg19:cCaption := "" //"DDAR021     012880    C01     100,00 ML   100,00 ML     99"
oSayReg19:nLeft := 13
oSayReg19:nTop := 393
oSayReg19:nWidth := 378
oSayReg19:nHeight := 17
oSayReg19:lShowHint := .F.
oSayReg19:lReadOnly := .F.
oSayReg19:Align := 0
oSayReg19:lVisibleControl := .T.
oSayReg19:lWordWrap := .F.
oSayReg19:lTransparent := .F.
oSayReg19:SetFont( oFont )

oSayReg20 := TSAY():Create(oDlg)
oSayReg20:cName := "oSayReg20"
oSayReg20:cCaption := "" //"DDAR021     012881    C01     100,00 ML   100,00 ML     99"
oSayReg20:nLeft := 13
oSayReg20:nTop := 413
oSayReg20:nWidth := 378
oSayReg20:nHeight := 17
oSayReg20:lShowHint := .F.
oSayReg20:lReadOnly := .F.
oSayReg20:Align := 0
oSayReg20:lVisibleControl := .T.
oSayReg20:lWordWrap := .F.
oSayReg20:lTransparent := .F.
oSayReg20:SetFont( oFont )

oSayReg21 := TSAY():Create(oDlg)
oSayReg21:cName := "oSayReg21"
oSayReg21:cCaption := "" //"DDAR021     012882    C01     100,00 ML   100,00 ML     99"
oSayReg21:nLeft := 13
oSayReg21:nTop := 433
oSayReg21:nWidth := 378
oSayReg21:nHeight := 17
oSayReg21:lShowHint := .F.
oSayReg21:lReadOnly := .F.
oSayReg21:Align := 0
oSayReg21:lVisibleControl := .T.
oSayReg21:lWordWrap := .F.
oSayReg21:lTransparent := .F.
oSayReg21:SetFont( oFont )

oSayReg22 := TSAY():Create(oDlg)
oSayReg22:cName := "oSayReg22"
oSayReg22:cCaption := "" //"DDAR021     012883    C01     100,00 ML   100,00 ML     99"
oSayReg22:nLeft := 13
oSayReg22:nTop := 453
oSayReg22:nWidth := 378
oSayReg22:nHeight := 17
oSayReg22:lShowHint := .F.
oSayReg22:lReadOnly := .F.
oSayReg22:Align := 0
oSayReg22:lVisibleControl := .T.
oSayReg22:lWordWrap := .F.
oSayReg22:lTransparent := .F.
oSayReg22:SetFont( oFont )

oSayReg23 := TSAY():Create(oDlg)
oSayReg23:cName := "oSayReg23"
oSayReg23:cCaption := "" //"DDAR021     012884    C01     100,00 ML   100,00 ML     99"
oSayReg23:nLeft := 13
oSayReg23:nTop := 473
oSayReg23:nWidth := 378
oSayReg23:nHeight := 17
oSayReg23:lShowHint := .F.
oSayReg23:lReadOnly := .F.
oSayReg23:Align := 0
oSayReg23:lVisibleControl := .T.
oSayReg23:lWordWrap := .F.
oSayReg23:lTransparent := .F.
oSayReg23:SetFont( oFont )

oSayReg24 := TSAY():Create(oDlg)
oSayReg24:cName := "oSayReg24"
oSayReg24:cCaption := "" //"DDAR021     012885    C01     100,00 ML   100,00 ML     99"
oSayReg24:nLeft := 13
oSayReg24:nTop := 493
oSayReg24:nWidth := 378
oSayReg24:nHeight := 17
oSayReg24:lShowHint := .F.
oSayReg24:lReadOnly := .F.
oSayReg24:Align := 0
oSayReg24:lVisibleControl := .T.
oSayReg24:lWordWrap := .F.
oSayReg24:lTransparent := .F.
oSayReg24:SetFont( oFont )

oSayReg25 := TSAY():Create(oDlg)
oSayReg25:cName := "oSayReg25"
oSayReg25:cCaption := "" //"DDAR021     012886    C01     100,00 ML   100,00 ML     99"
oSayReg25:nLeft := 13
oSayReg25:nTop := 513
oSayReg25:nWidth := 378
oSayReg25:nHeight := 17
oSayReg25:lShowHint := .F.
oSayReg25:lReadOnly := .F.
oSayReg25:Align := 0
oSayReg25:lVisibleControl := .T.
oSayReg25:lWordWrap := .F.
oSayReg25:lTransparent := .F.
oSayReg25:SetFont( oFont )

oSayReg26 := TSAY():Create(oDlg)
oSayReg26:cName := "oSayReg26"
oSayReg26:cCaption := "" //"DDAR021     012887    C01     100,00 ML   100,00 ML     99"
oSayReg26:nLeft := 13
oSayReg26:nTop := 533
oSayReg26:nWidth := 378
oSayReg26:nHeight := 17
oSayReg26:lShowHint := .F.
oSayReg26:lReadOnly := .F.
oSayReg26:Align := 0
oSayReg26:lVisibleControl := .T.
oSayReg26:lWordWrap := .F.
oSayReg26:lTransparent := .F.
oSayReg26:SetFont( oFont )

oSayReg27 := TSAY():Create(oDlg)
oSayReg27:cName := "oSayReg27"
oSayReg27:cCaption := "" //"DDAR021     012888    C01     100,00 ML   100,00 ML     99"
oSayReg27:nLeft := 13
oSayReg27:nTop := 550
oSayReg27:nWidth := 378
oSayReg27:nHeight := 17
oSayReg27:lShowHint := .F.
oSayReg27:lReadOnly := .F.
oSayReg27:Align := 0
oSayReg27:lVisibleControl := .T.
oSayReg27:lWordWrap := .F.
oSayReg27:lTransparent := .F.
oSayReg27:SetFont( oFont )

oSayTit02 := TSAY():Create(oDlg)
oSayTit02:cName := "oSayTit02"
oSayTit02:cCaption := "Produto     Cod. OP   Maq.     Program.     Saldo    Qtd.Turno"
oSayTit02:nLeft := 407
oSayTit02:nTop := 10
oSayTit02:nWidth := 372
oSayTit02:nHeight := 17
oSayTit02:lShowHint := .F.
oSayTit02:lReadOnly := .F.
oSayTit02:Align := 0
oSayTit02:lVisibleControl := .T.
oSayTit02:lWordWrap := .F.
oSayTit02:lTransparent := .F.
oSayTit02:SetFont( oFont )

oSayReg28 := TSAY():Create(oDlg)
oSayReg28:cName := "oSayReg28"
oSayReg28:cCaption := "" //"DDAR021     012889    C01     100,00 ML   100,00 ML     99"
oSayReg28:nLeft := 407
oSayReg28:nTop := 33
oSayReg28:nWidth := 378
oSayReg28:nHeight := 17
oSayReg28:lShowHint := .F.
oSayReg28:lReadOnly := .F.
oSayReg28:Align := 0
oSayReg28:lVisibleControl := .T.
oSayReg28:lWordWrap := .F.
oSayReg28:lTransparent := .F.
oSayReg28:SetFont( oFont )

oSayReg29 := TSAY():Create(oDlg)
oSayReg29:cName := "oSayReg29"
oSayReg29:cCaption := "" //"DDAR021     012890    C01     100,00 ML   100,00 ML     99"
oSayReg29:nLeft := 407
oSayReg29:nTop := 53
oSayReg29:nWidth := 378
oSayReg29:nHeight := 17
oSayReg29:lShowHint := .F.
oSayReg29:lReadOnly := .F.
oSayReg29:Align := 0
oSayReg29:lVisibleControl := .T.
oSayReg29:lWordWrap := .F.
oSayReg29:lTransparent := .F.
oSayReg29:SetFont( oFont )

oSayReg30 := TSAY():Create(oDlg)
oSayReg30:cName := "oSayReg30"
oSayReg30:cCaption := "" //"DDAR021     012891    C01     100,00 ML   100,00 ML     99"
oSayReg30:nLeft := 407
oSayReg30:nTop := 73
oSayReg30:nWidth := 378
oSayReg30:nHeight := 17
oSayReg30:lShowHint := .F.
oSayReg30:lReadOnly := .F.
oSayReg30:Align := 0
oSayReg30:lVisibleControl := .T.
oSayReg30:lWordWrap := .F.
oSayReg30:lTransparent := .F.
oSayReg30:SetFont( oFont )

oSayReg31 := TSAY():Create(oDlg)
oSayReg31:cName := "oSayReg31"
oSayReg31:cCaption := "" //"DDAR021     012892    C01     100,00 ML   100,00 ML     99"
oSayReg31:nLeft := 407
oSayReg31:nTop := 93
oSayReg31:nWidth := 378
oSayReg31:nHeight := 17
oSayReg31:lShowHint := .F.
oSayReg31:lReadOnly := .F.
oSayReg31:Align := 0
oSayReg31:lVisibleControl := .T.
oSayReg31:lWordWrap := .F.
oSayReg31:lTransparent := .F.
oSayReg31:SetFont( oFont )

oSayReg32 := TSAY():Create(oDlg)
oSayReg32:cName := "oSayReg32"
oSayReg32:cCaption := "" //"DDAR021     012893    C01     100,00 ML   100,00 ML     99"
oSayReg32:nLeft := 407
oSayReg32:nTop := 113
oSayReg32:nWidth := 378
oSayReg32:nHeight := 17
oSayReg32:lShowHint := .F.
oSayReg32:lReadOnly := .F.
oSayReg32:Align := 0
oSayReg32:lVisibleControl := .T.
oSayReg32:lWordWrap := .F.
oSayReg32:lTransparent := .F.
oSayReg32:SetFont( oFont )

oSayReg33 := TSAY():Create(oDlg)
oSayReg33:cName := "oSayReg33"
oSayReg33:cCaption := "" //"DDAR021     012894    C01     100,00 ML   100,00 ML     99"
oSayReg33:nLeft := 407
oSayReg33:nTop := 133
oSayReg33:nWidth := 378
oSayReg33:nHeight := 17
oSayReg33:lShowHint := .F.
oSayReg33:lReadOnly := .F.
oSayReg33:Align := 0
oSayReg33:lVisibleControl := .T.
oSayReg33:lWordWrap := .F.
oSayReg33:lTransparent := .F.
oSayReg33:SetFont( oFont )

oSayReg34 := TSAY():Create(oDlg)
oSayReg34:cName := "oSayReg34"
oSayReg34:cCaption := "" //"DDAR021     012895    C01     100,00 ML   100,00 ML     99"
oSayReg34:nLeft := 407
oSayReg34:nTop := 153
oSayReg34:nWidth := 378
oSayReg34:nHeight := 17
oSayReg34:lShowHint := .F.
oSayReg34:lReadOnly := .F.
oSayReg34:Align := 0
oSayReg34:lVisibleControl := .T.
oSayReg34:lWordWrap := .F.
oSayReg34:lTransparent := .F.
oSayReg34:SetFont( oFont )

oSayReg35 := TSAY():Create(oDlg)
oSayReg35:cName := "oSayReg35"
oSayReg35:cCaption := "" //"DDAR021     012896    C01     100,00 ML   100,00 ML     99"
oSayReg35:nLeft := 407
oSayReg35:nTop := 173
oSayReg35:nWidth := 378
oSayReg35:nHeight := 17
oSayReg35:lShowHint := .F.
oSayReg35:lReadOnly := .F.
oSayReg35:Align := 0
oSayReg35:lVisibleControl := .T.
oSayReg35:lWordWrap := .F.
oSayReg35:lTransparent := .F.
oSayReg35:SetFont( oFont )

oSayReg36 := TSAY():Create(oDlg)
oSayReg36:cName := "oSayReg36"
oSayReg36:cCaption := "" //"DDAR021     012897    C01     100,00 ML   100,00 ML     99"
oSayReg36:nLeft := 407
oSayReg36:nTop := 193
oSayReg36:nWidth := 378
oSayReg36:nHeight := 17
oSayReg36:lShowHint := .F.
oSayReg36:lReadOnly := .F.
oSayReg36:Align := 0
oSayReg36:lVisibleControl := .T.
oSayReg36:lWordWrap := .F.
oSayReg36:lTransparent := .F.
oSayReg36:SetFont( oFont )

oSayReg37 := TSAY():Create(oDlg)
oSayReg37:cName := "oSayReg37"
oSayReg37:cCaption := "" //"DDAR021     012898    C01     100,00 ML   100,00 ML     99"
oSayReg37:nLeft := 407
oSayReg37:nTop := 213
oSayReg37:nWidth := 378
oSayReg37:nHeight := 17
oSayReg37:lShowHint := .F.
oSayReg37:lReadOnly := .F.
oSayReg37:Align := 0
oSayReg37:lVisibleControl := .T.
oSayReg37:lWordWrap := .F.
oSayReg37:lTransparent := .F.
oSayReg37:SetFont( oFont )

oSayReg38 := TSAY():Create(oDlg)
oSayReg38:cName := "oSayReg38"
oSayReg38:cCaption := "" //"DDAR021     012899    C01     100,00 ML   100,00 ML     99"
oSayReg38:nLeft := 407
oSayReg38:nTop := 233
oSayReg38:nWidth := 378
oSayReg38:nHeight := 17
oSayReg38:lShowHint := .F.
oSayReg38:lReadOnly := .F.
oSayReg38:Align := 0
oSayReg38:lVisibleControl := .T.
oSayReg38:lWordWrap := .F.
oSayReg38:lTransparent := .F.
oSayReg38:SetFont( oFont )
************
*Temporario*
*********************************************************************************************************************
//oSayReg38:nClrText := CLR_WHITE
//ObjectMethod( oSayReg38, "SetColor( " +  str( CLR_WHITE ) + ", " + str( CLR_GRAY ) + ", " + str( CLR_WHITE ) +" )" )//
*********************************************************************************************************************


oSayReg39 := TSAY():Create(oDlg)
oSayReg39:cName := "oSayReg39"
oSayReg39:cCaption := ""
oSayReg39:nLeft := 407
oSayReg39:nTop := 253
oSayReg39:nWidth := 378
oSayReg39:nHeight := 17
oSayReg39:lShowHint := .F.
oSayReg39:lReadOnly := .F.
oSayReg39:Align := 0
oSayReg39:lVisibleControl := .T.
oSayReg39:lWordWrap := .F.
oSayReg39:lTransparent := .F.
oSayReg39:SetFont( oFont )

oGrp4 := TGROUP():Create(oDlg)
oGrp4:cName := "oGrp4"
oGrp4:nLeft := 400
oGrp4:nTop := 282
oGrp4:nWidth := 390
oGrp4:nHeight := 146
oGrp4:lShowHint := .F.
oGrp4:lReadOnly := .F.
oGrp4:Align := 0
oGrp4:lVisibleControl := .T.

oSayINFO01 := TSAY():Create(oDlg)
oSayINFO01:cName := "oSayINFO01"
oSayINFO01:cCaption := cOP //"OP: 012899 - DDAR021"
oSayINFO01:nLeft := 405
oSayINFO01:nTop := 290
oSayINFO01:nWidth := 382 //350
oSayINFO01:nHeight := 47
oSayINFO01:lShowHint := .F.
oSayINFO01:lReadOnly := .F.
oSayINFO01:Align := 0
oSayINFO01:lVisibleControl := .T.
oSayINFO01:lWordWrap := .F.
oSayINFO01:lTransparent := .F.
oSayINFO01:SetFont( oFontOP )
oSayINFO01:nClrText := CLR_HRED
/*
oSayINFO02 := TSAY():Create(oDlg)
oSayINFO02:cName := "oSayINFO02"
oSayINFO02:cCaption := "DDAR021"
oSayINFO02:nLeft := 407
oSayINFO02:nTop := 341
oSayINFO02:nWidth := 63
oSayINFO02:nHeight := 17
oSayINFO02:lShowHint := .F.
oSayINFO02:lReadOnly := .F.
oSayINFO02:Align := 0
oSayINFO02:lVisibleControl := .T.
oSayINFO02:lWordWrap := .F.
oSayINFO02:lTransparent := .F.
oSayINFO02:SetFont( oFontDes )
oSayINFO02:nClrText := CLR_HRED
*/
oSayINFO03 := TSAY():Create(oDlg)
oSayINFO03:cName := "oSayINFO03"
oSayINFO03:cCaption := cDescric //"SACO D. LIMPEZA AZUL 100L 75X105 MEDIO ROLO P"
oSayINFO03:nLeft := 407 //474
oSayINFO03:nTop := 330
oSayINFO03:nWidth := 381
oSayINFO03:nHeight := 25
oSayINFO03:lShowHint := .F.
oSayINFO03:lReadOnly := .F.
oSayINFO03:Align := 0
oSayINFO03:lVisibleControl := .T.
oSayINFO03:lWordWrap := .F.
oSayINFO03:lTransparent := .F.
oSayINFO03:SetFont( oFontDes )
oSayINFO03:nClrText := CLR_HRED

oSayPESADA := TSAY():Create(oDlg)
oSayPESADA:cName := "oSayPESADA"
oSayPESADA:cCaption := "QTD. PESADA :"
oSayPESADA:nLeft := 408
oSayPESADA:nTop := 377
oSayPESADA:nWidth := 82
oSayPESADA:nHeight := 17
oSayPESADA:lShowHint := .F.
oSayPESADA:lReadOnly := .F.
oSayPESADA:Align := 0
oSayPESADA:lVisibleControl := .T.
oSayPESADA:lWordWrap := .F.
oSayPESADA:lTransparent := .F.
oSayPESADA:SetFont( oFontTit )
oSayPESADA:nClrText := CLR_RED

oSayPROCES := TSAY():Create(oDlg)
oSayPROCES:cName := "oSayPROCES"
oSayPROCES:cCaption := "TOTAL PESADO :"
oSayPROCES:nLeft := 536
oSayPROCES:nTop := 377
oSayPROCES:nWidth := 96
oSayPROCES:nHeight := 17
oSayPROCES:lShowHint := .F.
oSayPROCES:lReadOnly := .F.
oSayPROCES:Align := 0
oSayPROCES:lVisibleControl := .T.
oSayPROCES:lWordWrap := .F.
oSayPROCES:lTransparent := .F.
oSayPROCES:SetFont( oFontTit )
oSayPROCES:nClrText := CLR_BLUE

oSayREST := TSAY():Create(oDlg)
oSayREST:cName := "oSayREST"
oSayREST:cCaption := "QTD. RESTANTE DA OP :"
oSayREST:nLeft := 657
oSayREST:nTop := 377
oSayREST:nWidth := 128
oSayREST:nHeight := 17
oSayREST:lShowHint := .F.
oSayREST:lReadOnly := .F.
oSayREST:Align := 0
oSayREST:lVisibleControl := .T.
oSayREST:lWordWrap := .F.
oSayREST:lTransparent := .F.
oSayREST:SetFont( oFontTit )
oSayREST:nClrText := CLR_GREEN

oSayINFO04 := TSAY():Create(oDlg)
oSayINFO04:cName := "oSayINFO04"
oSayINFO04:cCaption := "0 FDs"
oSayINFO04:nLeft := 408
oSayINFO04:nTop := 393
oSayINFO04:nWidth := 101
oSayINFO04:nHeight := 25
oSayINFO04:lShowHint := .F.
oSayINFO04:lReadOnly := .F.
oSayINFO04:Align := 0
oSayINFO04:lVisibleControl := .T.
oSayINFO04:lWordWrap := .F.
oSayINFO04:lTransparent := .F.
oSayINFO04:SetFont( oFontNum )
oSayINFO04:nClrText := CLR_RED

oSayINFO05 := TSAY():Create(oDlg)
oSayINFO05:cName := "oSayINFO05"
oSayINFO05:cCaption := "0 FDs"
oSayINFO05:nLeft := 536
oSayINFO05:nTop := 393
oSayINFO05:nWidth := 97
oSayINFO05:nHeight := 25
oSayINFO05:lShowHint := .F.
oSayINFO05:lReadOnly := .F.
oSayINFO05:Align := 0
oSayINFO05:lVisibleControl := .T.
oSayINFO05:lWordWrap := .F.
oSayINFO05:lTransparent := .F.
oSayINFO05:SetFont( oFontNum )
oSayINFO05:nClrText := CLR_BLUE

oSayINFO06 := TSAY():Create(oDlg)
oSayINFO06:cName := "oSayINFO06"
oSayINFO06:cCaption := "0,00 FDs"
oSayINFO06:nLeft := 659
oSayINFO06:nTop := 393
oSayINFO06:nWidth := 124
oSayINFO06:nHeight := 25
oSayINFO06:lShowHint := .F.
oSayINFO06:lReadOnly := .F.
oSayINFO06:Align := 0
oSayINFO06:lVisibleControl := .T.
oSayINFO06:lWordWrap := .F.
oSayINFO06:lTransparent := .F.
oSayINFO06:SetFont( oFontNum )
oSayINFO06:nClrText := CLR_GREEN

oDlg:Activate()

Return


***************

Static Function Pegar()

***************

if Empty( cMAQ )
	MsgAlert( "Maquina nao informada" )
	ObjectMethod( oSayMaq, "SetFocus()" )
	Return NIL
EndIf
aUSUARIO := U_senha3( "05", 1 )   	//VOLTAR
///voltar
//*/
If ! aUSUARIO[ 1 ]
	Return NIL
EndIf

cNOMUSUA := aUSUARIO[ 2 ]
//*/
cDLL     := "toledo9091.dll"

nHandle  := ExecInDllOpen( cDLL )
if nHandle = -1
	MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	Return NIL
EndIf

// Parametro 1 = Porta serial do indicador
cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL ) //voltar
cPESO   := Left( cRETDLL, rat( ",", cRETDLL ) - 1 )		//voltar
//cPESO := '7,00'
nPESO   := Val( Strtran( cPESO, ",", "." ) )
ExecInDLLClose( nHandle )		//VOLTAR
//ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
ObjectMethod( oSayPKG02, "SetText( Trans( nPESO, '@E 999.99' ) )" )
Grava()
Return NIL



***************

Static Function Grava()

***************

cUSULIM  := ""
aIMP     := {}
aUSUARIO := {}
latua := .T.
Do While .T.
		If ! lIncomp
				If nPESO <= 0 .or. nQUANT <= 0 .or. Empty( cOP )
					 MsgAlert( "Campo(s) sem informacao ou com valor(es) incorreto(s)" )
					 latua := .F.
					 Exit
				EndIf
	 			cQuery := "SELECT Sum( Z00_QUANT ) AS QUANT "
	 			cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
				cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND Z00.Z00_BAIXA = 'N' AND "
	 			cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	 			cQuery := ChangeQuery( cQuery )
	 			TCQUERY cQuery NEW ALIAS "Z00X"
 	 			//VOLTAR
 	 			If ( ( SC2->C2_QUANT - SC2->C2_QUJE ) + ( nLIMITE * SC2->C2_QUANT / 100 ) ) * SB5->B5_QE2 < Z00X->QUANT + ( nQUANT * SB5->B5_QTDFIM )
	 				//VOLTAR
	 				///*
	 				If ! MsgBox( OemToAnsi( "Producao desta OP ja atingiu o previsto (" + AllTrim( Str( SC2->C2_QUANT * SB5->B5_QE2 ) ) + " - " + ;
   						AllTrim( Str( SC2->C2_QUJE + Z00X->QUANT + ( nQUANT * SB5->B5_QTDFIM ) ) ) + "). Confirma?" ), "Escolha", "YESNO" )
							Z00X->( DbCloseArea() )
							latua := .F.
	 				    Exit
	 			  	EndIf
	 			  	//*/
	 			  	
			   		 aUSUARIO := U_senha2( "03" )		//VOLTAR
			   		 ///*
			   		 If ! aUSUARIO[ 1 ]
								Z00X->( DbCloseArea() )
								latua := .F.
			   		  	Exit
			   		 EndIf
						 cUSULIM  := aUSUARIO[ 2 ]
						 aUSUARIO := {}
						 aUSUARI2 := {}
					//*/
						 endOP( cOP, 9 )
				EndIf		//VOLTAR
				
				Z00X->( DbCloseArea() )
				nQTDPESADA := nQUANT * SB5->B5_QTDFIM     // Unidades pesadas
				nQUANTFD   := nQTDPESADA / SB5->B5_QE2
            nPROPORCAO := nQUANTFD * SB1->B1_PESO     // Peso teorico da pesagem
            nDIFPESO   := nQUANTFD * SB5->B5_DIFPESO  // Peso da alca da sacola
				SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )
				nREG      := SB1->( Recno() )
				nPESOCAPA := 0
            nPESOMSEC := 0
				Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1->B1_COD
					SB1->( DbSeek( xFilial( "SB1" ) + SG1->G1_COMP ) )
					If SB1->B1_TIPO == 'ME'
						nPESOCAPA += nQUANTFD * SG1->G1_QUANT * SB1->B1_PESO
               ElseIf SB1->B1_TIPO == 'MS'
                  nPESOMSEC += nQUANTFD * SG1->G1_QUANT * SB1->B1_PESO
				   EndIf
					SB1->( DbGoto( nREG ) )
					SG1->( DbSkip() )
				EndDo
				SB1->( DbGoto( nREG ) )
				nQTDLIB := 0
				cSEQ    := "00"
				If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )
					 	Do While Z01->Z01_OP == cOP
					 		 nQTDLIB += Z01->Z01_RESTA
					 		 cSEQ    := Z01->Z01_SEQ
					 		 Z01->( DbSkip() )
					 	EndDo
				EndIf
					aUSUARI2 := {}
          If nPESO < Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) * 0.95   // Nao deixa pesar caso produto tenha peso ABAIXO de 5% do normal.
						Alert("O produto pesado esta MUITO ABAIXO do peso limite.  So podera ser liberado pelo Gerente de Producao.")
		   		 	///VOLTAR
		   		 	///*
		   		 	aUSUARI2 := U_senha3( "06", 1, "Margem de peso menor que o limite" )
		   		 	If ! aUSUARI2[ 1 ]
							latua := .F.
		   		 		Exit
		   		 	EndIf
		   		 	//*/
		  EndIf

          If nPESO > Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) , 3 ) * 1.05  // Nao deixa pesar caso produto tenha peso ACIMA de 5% do normal.
						Alert("O produto pesado esta MUITO ACIMA do peso limite.  So podera ser liberado pelo Gerente de Producao.")
		   		 	///VOLTAR
		   		 	///*
		   		 	aUSUARI2 := U_senha3( "06", 1, "Margem de peso maior que o limite" )
		   		 	If ! aUSUARI2[ 1 ]
							latua := .F.
		   		 		Exit
		   		 	EndIf
		   		 	//*/
		  EndIf

        If nQTDLIB < nQUANT .or. nPESO > Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) * 1.1 //;
         //.or. nPESO < Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) * 0.9   // Bloqueia mais de 10% de variacao no peso mesmo estando liberado por senha  Esmerino Neto em 06_07_06
           If nPESO < Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) .or. nPESO > Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), 3 )
              If ! MsgBox( "Produto " + AllTrim( SB1->B1_COD ) + " - " + SB1->B1_DESC + Chr( 13 ) + Chr( 13 ) + "Com peso (" + AllTrim( Trans( nPESO, '@E 999.99' ) ) + ") fora da faixa permitida (" + AllTrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), ;
                "@E 999.999" ) ) + " -- " + Alltrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), "@E 999.999" ) ) + ;
                "). Sacos capa (" + AllTrim( Trans( nPESOCAPA, "@E 999.999" ) ) + "). Material secundario (" + AllTrim( Trans( nPESOMSEC, "@E 999.999" ) ) + "), Confirma?", "Escolha", "YESNO" )
							  latua := .F.
		  					  Exit
							EndIf
		   		 	///VOLTAR
		   		 	///*
						aUSUARIO := U_senha3( "01", 3 )
		   		 		If ! aUSUARIO[ 1 ]
								latua := .F.
		   		 		   Exit
		   		 		EndIf
		   		  //*/
							If ! QuantLib()
								latua := .F.
		   		 		   		Exit
		   	  				EndIf
		  				   If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )  // Atualiza o resta quando a OP tem fardos liberados
							 		nQTDUSA := nQUANT - nQTDLIB
			 				 		Do While Z01->Z01_OP == cOP .and. nQTDUSA > 0
							 		 	 RecLock( "Z01", .F. )
							 			 nRESTA  := Z01->Z01_RESTA
			 				 		 	 Z01->Z01_RESTA -= Min( Z01->Z01_RESTA, nQTDUSA )
			  		 	 		 	    Z01->( MsUnlock() )
							 		 	 nQTDUSA        -= Min( nRESTA, nQTDUSA )
			 				 		 	 Z01->( DbSkip() )
			 				 		EndDo
		  				 		Z01->( DbCommit() )
							EndIf
							If nQTDLIB > 0   // Cria registro de quantidade de fardos liberados
								RecLock( "Z01", .T. )
								Z01->Z01_OP    := cOP
								Z01->Z01_SEQ   := StrZero( Val( cSEQ ) + 1, 2 )
								Z01->Z01_DATA  := Date()
								Z01->Z01_HORA  := Left( Time(), 5 )
								Z01->Z01_QUANT := nQTDLIB
								Z01->Z01_RESTA := nQTDLIB
								//Z01->Z01_USUAR := aUSUARIO[ 2 ]
		  						Z01->( MsUnlock() )
		  						Z01->( DbCommit() )
							EndIf
					 EndIf
				Else
						If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )  // Atualiza o resta quando a OP tem fardos liberados
							 nQTDLIB := nQUANT
			 				 Do While Z01->Z01_OP == cOP .and. nQTDLIB > 0
							  	 RecLock( "Z01", .F. )
									 nRESTA  := Z01->Z01_RESTA
			 				  	 Z01->Z01_RESTA -= Min( Z01->Z01_RESTA, nQTDLIB )
			  		 	  	 Z01->( MsUnlock() )
                   If Min( nRESTA, nQTDLIB ) > 0
                      nQTDLIB  -= Min( nRESTA, nQTDLIB )
                      aUSUARIO := { .T., Z01->Z01_USUAR }		//voltar
                   EndIf
			 				  	 Z01->( DbSkip() )
			 				 EndDo
		  				 Z01->( DbCommit() )
						EndIf
				EndIf
				For nCONT := 1 To nQUANT
            cSEQ := ProxSeq()
						RecLock( "Z00", .T. )
						Z00->Z00_SEQ    := cSEQ
						Z00->Z00_OP     := cOP
						Z00->Z00_PESO   := nPESO / nQUANT
						Z00->Z00_BAIXA  := "N"
						Z00->Z00_MAQ    := cMAQ
						//Z00->Z00_LADO   := cLado		//novo campo para registrar a qual lado da máquina: A / B / U (único)
						Z00->Z00_DATA   := Date()
						Z00->Z00_HORA   := Left( Time(), 5 )
						Z00->Z00_QUANT  := SB5->B5_QTDFIM
						Z00->Z00_PESCAP := ( nPESOCAPA / nQUANT ) * -1
						Z00->Z00_PESDIF := ( nDIFPESO / nQUANT ) * -1
						Z00->Z00_USULIM := cUSULIM
						Z00->Z00_FARDOS := nQUANT
						Z00->Z00_NOME   := cNOMUSUA       //voltar
						Z00->Z00_CODBAR := substr(cOP,1,6) + cSEQ //03/04/07		
						Z00->Z00_CODIGO := SB1->B1_COD //VOLTAR
						//Z00->Z00_CODIGO := SC2->C2_PRODUTO 
						Z00->Z00_LADO	:= cLado
						//voltar
						///*
						If Len( aUSUARIO ) > 0
							 Z00->Z00_USUAR := Iif ( Len( aUSUARI2 ) > 0, Alltrim( aUSUARIO[ 2 ] )+ " " + Alltrim( aUSUARI2[ 2 ] ), aUSUARIO[ 2 ] ) //aUSUARIO[ 2 ]
						EndIf 
						//*/
						Z00->( MsUnlock() )
						ConfirmSX8()
						Z00->( DbCommit() )

						//Aadd( aIMP, { "B" + "Rava Embalagens", "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
						Aadd( aIMP, { "B" + "Rava Embalagens", "B" + "Produto: " + AllTrim( SB1->B1_COD ), "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
						If Abre_Impress()		//VOLTAR
							 //Inc_Linha( aIMP[ nCONT, 1 ], .T. )
							 //Inc_Linha( aIMP[ nCONT, 2 ], .F. )
							 
							 Inc_Linha( aIMP[ nCONT, 2 ], .T. )		//VOLTAR
							 //Inc_Linha( aIMP[ nCONT, 3 ], .F. )
							 
							 Inc_Linha( aIMP[ nCONT, 4 ], .F. )		//VOLTAR
							 //Fecha_Impress()		//VOLTAR
							 
							 // Pausa a cada etiqueta
							 //VOLTAR
							 ///*
							 If nQUANT > 1 .and. nCONT <> nQUANT
							  	Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
							 EndIf
							 //*/
						EndIf		//VOLTAR
				Next
		Else
				If nPESO <= 0 .or. nSACOS <= 0 .or. Empty( cOP )
					MsgAlert( "Campo(s) sem informacao ou com valor(es) incorreto(s)" )
					latua := .F.
					Exit
				EndIf
	 			cQuery := "SELECT Sum( Z00_QUANT ) AS QUANT "
	 			cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
				cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND Z00.Z00_BAIXA = 'N' AND "
	 			cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	 			cQuery := ChangeQuery( cQuery )
	 			TCQUERY cQuery NEW ALIAS "Z00X"
 	 			If ( ( SC2->C2_QUANT - SC2->C2_QUJE ) + ( nLIMITE * SC2->C2_QUANT / 100 ) ) * SB5->B5_QE2 < Z00X->QUANT + nSACOS
	 				 If ! MsgBox( OemToAnsi( "Producao desta OP ja atingiu o previsto (" + AllTrim( Str( SC2->C2_QUANT * SB5->B5_QE2 ) ) + " - " + ;
              AllTrim( Str( SC2->C2_QUJE + Z00X->QUANT + nSACOS ) ) + "). Confirma?" ), "Escolha", "YESNO" )
              Z00X->( DbCloseArea() )
              latua := .F.
	 				    Exit
	 			   EndIf
		   		 ///VOLTAR
		   		 ///*
		   		 aUSUARIO := U_senha2( "03" )
		   		 If ! aUSUARIO[ 1 ]
              		Z00X->( DbCloseArea() )
              		latua := .F.
              		Exit
		   		 EndIf
		   		 
					 cUSULIM  := aUSUARIO[ 2 ]
					 aUSUARIO := {}
					 aUSUARI2 := {}
				//*/
				EndIf
				Z00X->( DbCloseArea() )

				/**/
				//nQTDPESADA := nQUANT * SB5->B5_QTDFIM     // Unidades pesadas
				nQTDPESADA := nSACOS //nao precisa multiplicar pela quantidade final, uma vez que nao temos sequer um fardo
				nQUANTFD   := nQTDPESADA / SB5->B5_QE2
        nPROPORCAO := nQUANTFD * SB1->B1_PESO     // Peso teorico da pesagem
        nDIFPESO   := nQUANTFD * SB5->B5_DIFPESO  // Peso da alca da sacola
				SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )
				nREG      := SB1->( Recno() )
				nPESOCAPA := 0
        nPESOMSEC := 0
				Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1->B1_COD
					 SB1->( DbSeek( xFilial( "SB1" ) + SG1->G1_COMP ) )
					 If SB1->B1_TIPO == 'ME'
						  nPESOCAPA += nQUANTFD * SG1->G1_QUANT * SB1->B1_PESO
           ElseIf SB1->B1_TIPO == 'MS'
              nPESOMSEC += nQUANTFD * SG1->G1_QUANT * SB1->B1_PESO
					 EndIf
					 SB1->( DbGoto( nREG ) )
					 SG1->( DbSkip() )
				EndDo
				SB1->( DbGoto( nREG ) )
				nQTDLIB := 0
				cSEQ    := "00"
				/*If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )
					 	Do While Z01->Z01_OP == cOP
					 		 nQTDLIB += Z01->Z01_RESTA
					 		 cSEQ    := Z01->Z01_SEQ
					 		 Z01->( DbSkip() )
					 	EndDo
				EndIf*/
				/**/

				/**/
				aUSUARI2 := {}

        If nPESO < Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) * 0.95   // Nao deixa pesar caso produto tenha peso ABAIXO de 5% do normal.
					Alert("O produto pesado esta MUITO ABAIXO do peso limite.  So podera ser liberado pelo Gerente de Producao.")
		   		///VOLTAR
		   		///*
		   		aUSUARI2 := U_senha3( "06", 1, "Margem de peso menor que o limite" )
		   		If ! aUSUARI2[ 1 ]
						latua := .F.
		   		 	Exit
		   		EndIf
		   		//*/
					If ! MsgBox( "Produto " + AllTrim( SB1->B1_COD ) + " - " + SB1->B1_DESC + Chr( 13 ) + Chr( 13 ) + "Com peso (" + AllTrim( Trans( nPESO, '@E 999.99' ) ) + ") fora da faixa permitida (" + AllTrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), ;
                	"@E 999.999" ) ) + " -- " + Alltrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), "@E 999.999" ) ) + ;
                	"). Sacos capa (" + AllTrim( Trans( nPESOCAPA, "@E 999.999" ) ) + "). Material secundario (" + AllTrim( Trans( nPESOMSEC, "@E 999.999" ) ) + "), Confirma?", "Escolha", "YESNO" )
						latua := .F.
		  				Exit
					EndIf
					///VOLTAR
					///*
					aUSUARIO := U_senha3( "01", 3 )
			   		If ! aUSUARIO[ 1 ]
							latua := .F.
			   		 	Exit
			   		EndIf
			   		//*/
        ElseIf nPESO > Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) , 3 ) * 1.05  // Nao deixa pesar caso produto tenha peso ACIMA de 5% do normal.
					Alert("O produto pesado esta MUITO ACIMA do peso limite.  So podera ser liberado pelo Gerente de Producao.")
		   		///VOLTAR
		   		///*
		   		aUSUARI2 := U_senha3( "06", 1, "Margem de peso maior que o limite" )
		   		If ! aUSUARI2[ 1 ]
						latua := .F.
		   		 	Exit
		   		EndIf
		   		//*/
					If ! MsgBox( "Produto " + AllTrim( SB1->B1_COD ) + " - " + SB1->B1_DESC + Chr( 13 ) + Chr( 13 ) + "Com peso (" + AllTrim( Trans( nPESO, '@E 999.99' ) ) + ") fora da faixa permitida (" + AllTrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), ;
                	"@E 999.999" ) ) + " -- " + Alltrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), "@E 999.999" ) ) + ;
                	"). Sacos capa (" + AllTrim( Trans( nPESOCAPA, "@E 999.999" ) ) + "). Material secundario (" + AllTrim( Trans( nPESOMSEC, "@E 999.999" ) ) + "), Confirma?", "Escolha", "YESNO" )
						latua := .F.
		  				Exit
					EndIf
					///VOLTAR
					///*
					aUSUARIO := U_senha3( "01", 3 )
			   		If ! aUSUARIO[ 1 ]
							latua := .F.
			   		 	Exit
			   		EndIf
			   		//*/
				Elseif  nPESO < Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 );
					  .or. nPESO > Round( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), 3 )
						If ! MsgBox( "Produto " + AllTrim( SB1->B1_COD ) + " - " + SB1->B1_DESC + Chr( 13 ) + Chr( 13 ) + "Com peso (" + AllTrim( Trans( nPESO, '@E 999.99' ) ) + ") fora da faixa permitida (" + AllTrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), ;
            			"@E 999.999" ) ) + " -- " + Alltrim( Trans( ( nPROPORCAO + nPESOCAPA + nPESOMSEC + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), "@E 999.999" ) ) + ;
              			"). Sacos capa (" + AllTrim( Trans( nPESOCAPA, "@E 999.999" ) ) + "). Material secundario (" + AllTrim( Trans( nPESOMSEC, "@E 999.999" ) ) + "), Confirma?", "Escolha", "YESNO" )
							latua := .F.
		  					Exit
						EndIf
						///VOLTAR
						///*
						aUSUARIO := U_senha3( "01", 3 )
			   		 	If ! aUSUARIO[ 1 ]
							latua := .F.
			   		 	  	Exit
			   		 	EndIf
			   		 	//*/
				EndIf
				/**/
				//nDIFPESO := nSACOS / SB5->B5_QE2 * SB5->B5_DIFPESO
				/*If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )    A tabela Z01 e usada para liberacao de quantidades de fardos
					RecLock( "Z01", .T. )
					Z01->Z01_OP    := cOP
					Z01->Z01_SEQ   := StrZero( Val( cSEQ ) + 1, 2 )
					Z01->Z01_DATA  := Date()
					Z01->Z01_HORA  := Left( Time(), 5 )
					Z01->Z01_QUANT := nQTDLIB
					//Z01->Z01_RESTA := nQTDLIB //nao atualizar o quanto resta da OP uma vez que estamos pesando um produto incompleto
					Z01->Z01_USUAR := aUSUARIO[ 2 ]
		  		Z01->( MsUnlock() )
		  		Z01->( DbCommit() )
				endIf*/

        cSEQ     := ProxSeq() //seek no Z00 feito aqui
				RecLock( "Z00", .T. )
				Z00->Z00_SEQ    := cSEQ
				Z00->Z00_OP     := cOP
				Z00->Z00_PESO   := nPESO
				Z00->Z00_BAIXA  := "N"
				Z00->Z00_MAQ    := cMAQ
				Z00->Z00_LADO   := cLado		//novo campo para registrar a qual lado da máquina: A / B / U (único)
				Z00->Z00_DATA   := Date()
				Z00->Z00_HORA   := Left( Time(), 5 )
				Z00->Z00_QUANT  := nSACOS
				Z00->Z00_PESDIF := nDIFPESO * -1
				Z00->Z00_USULIM := cUSULIM
				Z00->Z00_NOME   := cNOMUSUA		//voltar
				Z00->Z00_CODBAR := substr(cOP,1,6) + cSEQ //03/04/07
				Z00->Z00_CODIGO := SB1->B1_COD		//VOLTAR
				//Z00->Z00_CODIGO := SC2->C2_PRODUTO 
				//voltar
				///*
				If Len( aUSUARIO ) > 0
					 Z00->Z00_USUAR := Iif ( Len( aUSUARI2 ) > 0, Alltrim( aUSUARIO[ 2 ] )+ " " + Alltrim( aUSUARI2[ 2 ] ), aUSUARIO[ 2 ] ) //aUSUARIO[ 2 ]
				EndIf
				//*/
				Z00->( MsUnlock() )
				ConfirmSX8()
				Z00->( DbCommit() )

				//Aadd( aIMP, { "B" + "Rava Embalagens", "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
				Aadd( aIMP, { "B" + "Rava Embalagens", "B" + "Incompleto: " + AllTrim( SB1->B1_COD ), "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
				If Abre_Impress()		//VOLTAR
					//Inc_Linha( aIMP[ 1, 1 ], .T. )
					//Inc_Linha( aIMP[ 1, 2 ], .F. )
					
					Inc_Linha( aIMP[ 1, 2 ], .T. )		//VOLTAR
					
					//Inc_Linha( aIMP[ 1, 3 ], .F. )
					
					Inc_Linha( aIMP[ 1, 4 ], .F. ) //Esmerino Neto		//VOLTAR
					Fecha_Impress()		//VOLTAR
				EndIf		//VOLTAR
		EndIf
		If SC2->C2_RECURSO <> cMAQ
			RecLock( "SC2", .F. )
		   SC2->C2_RECURSO := cMAQ
			SC2->( MsUnlock() )
			SC2->( DbCommit() )
		EndIf
		Exit

EndDo

IF latua
	AtuRegs()
	latua := .F.
ENDIF

lIncomp := .F.

Incomp()

nSACOS  := 0
nPESO   := 0
cOP     := Space( 11 )
cMAQ    := Space( 06 )
nQUANT  := 1
ObjectMethod( oSayPKG02, "SetText( Trans( nPESO, '@E 999.99' ) )" )
//ObjectMethod( oOP, "SetFocus()" )
ObjectMethod( oGetOP, "SetFocus()" )
Return NIL



***************

Static Function PesqOp()

***************

lRET := .T.

If Len( AllTrim( cOP ) ) == 6
	 cOP := Left( cOP, 6 ) + "01001"
EndIf
If "REIMP" $ Upper( oDlg:oCtlFocus:ccaption )
	 Return lRET
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOP
	 MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	 lRET := .F.
/*
Else
	 If SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	    If ! SB1->B1_TIPO $ "PA*ME*MP"
				 MsgAlert( OemToAnsi( "Esta OP nao ‚ de produto acabado ou embalagem" ) )
				 lRET := .F.
			EndIf
			If ! SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
				 MsgAlert( OemToAnsi( "Complemento do produto nao cadastrado" ) )
				 lRET := .F.
			EndIf
			If Empty( SB5->B5_QTDFIM )
				 MsgAlert( OemToAnsi( "Quantidade por embalagem final nao informada no produto" ) )
				 lRET := .F.
			EndIf
	 Else
			MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
			lRET := .F.
	 EndIf
 	 If lRET .and. ! Empty( SC2->C2_DATRF )
			MsgAlert( OemToAnsi( "Esta OP ja foi encerrada" ) )
 			lRET := .F.
	 EndIf
*/
EndIf

If lRET
	 If ! Empty( SC2->C2_RECURSO )
			cMAQ           := SC2->C2_RECURSO
			ObjectMethod( oGetQFD, "SetFocus()" )
	 EndIf

	 Atualiza( cOP )

EndIf
Return lRET



***************

Static Function PesqMaq()

***************

lRET := .T.
If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	 MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	 lRET := .F.
EndIf
If lRET
	 If ! Empty( SC2->C2_RECURSO ) .and. cMAQ <> SC2->C2_RECURSO
		  lRET := U_senha3( "02", 1 )[ 1 ]		//VOLTAR
	 EndIf
EndIf
Return lRET



***************

Static Function Abre_Impress()

***************

cDLL    := "impressora451.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	 Return .F.
EndIf
// Parametro 1 = Porta serial da impressora
ExecInDLLRun( nHandle, 1, cPORTAIMP )
Return .T.



***************

Static Function Inc_Linha( cIMP, lPRIMLINHA )

***************

// Parametro 1 = Linha a ser impressa
// Parametro 2 = Limpa buffer
ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )
Return NIL



***************

Static Function Fecha_Impress()

***************

ExecInDLLRun( nHandle, 3, "" )
ExecInDLLClose( nHandle )
Return NIL



***************

Static Function Reimprime()

***************
//VOLTAR
///*
aUSUARIO := U_senha3( "01", 2 )
If ! aUSUARIO[ 1 ]
	Return
EndIf
//*/

For nCONT := 1 To Len( aIMP )
		If Abre_Impress()
			 //Inc_Linha( aIMP[ nCONT, 1 ], .T. )
			 //Inc_Linha( aIMP[ nCONT, 2 ], .F. )
			 Inc_Linha( aIMP[ nCONT, 2 ], .T. )
			 //Inc_Linha( aIMP[ nCONT, 3 ], .F. )
			 Inc_Linha( aIMP[ nCONT, 4 ], .F. )
			 Fecha_Impress()
			 // Pausa a cada etiqueta
			 If Len( aIMP ) > 1 .and. nCONT <> Len( aIMP )
				  Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
			 EndIf
		EndIf
Next
ObjectMethod( oGetOP, "SetFocus()" )
Return NIL



***************

Static Function Incomp()

***************

	If lINCOMP
		oSayQSac:lVisibleControl := .T.
		ObjectMethod( oSayQSac, "Refresh()" )
		oGetQSac:lVisibleControl := .T.
		ObjectMethod( oGetQSac, "Refresh()" )
		ObjectMethod( oGetQSac, "SetFocus()" )
	ElseIf ! lINCOMP
		oSayQSac:lVisibleControl := .F.
		ObjectMethod( oSayQSac, "Refresh()" )
		oGetQSac:lVisibleControl := .F.
		ObjectMethod( oGetQSac, "Refresh()" )
	EndIf

Return .T.



***************

Static Function Sacos()

***************

If nSACOS >= SB5->B5_QTDFIM
	 MsgAlert( "Quantidade de sacos maior que o fardo completo" )
	 Return .F.
EndIf
Return .T.



***************

Static Function QUANTLIB()

***************

lRET    := .T.
nQTDLIB := 0
@ 00,00 TO 60,330 Dialog oDLG2 Title "Libera fardos com problema no peso"
@ 11,010 Say "Quantidade:"
@ 10,050 Get nQTDLIB Size 20,40 Picture "9999"
@ 09,090 BMPButton Type 02 Action ( lRET := .F., Close( oDLG2 ) )
@ 09,130 BMPButton Type 01 Action Close( oDLG2 )
Activate Dialog oDLG2 Centered
Return lRET



***************

Static Function PROXSEQ()

***************

cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
Do While Z00->( DbSeek( xFilial( "Z00" ) + cSEQ ) )
   ConfirmSX8()
   cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
EndDo
Return cSEQ



***************
//Static Function Atualiza( nOpcao, cOP )
Static Function Atualiza(cOP)
***************

	Public nTotNPes := 0
	nTotaPes := nRestOP := nPrdTur1 := nPrdTur2 := nPrdTur3A := nPrdTur3B := nPrdTur3C := 0
	cHora := cQuery01 := cQuery02 := cQuery03 := Nil

	cOPtmp := cOP

	cDataAtu 	:= DtoS( Date() )
	cDataAnt 	:= DtoS( Date() - 1 )
	cHora			:= Time()

	Colora( 1 )

	If SubStr( cHora, 1, 5 ) >= "05:35" .and. SubStr( cHora, 1, 5 ) < "13:55"
		cQuery01 := "SELECT Z00.Z00_OP, Z00.Z00_HORA, Z00.Z00_DATA FROM " + RetSqlName( "Z00" ) + " Z00 "
		cQuery01 += "WHERE Z00.Z00_OP = '" + cOPtmp + "' AND Z00.Z00_QUANT > 0 AND Z00.Z00_HORA BETWEEN '05:35' AND '13:54' "
		cQuery01 += "AND Z00.Z00_DATA = '" + cDataAtu + "' "
		cQuery01 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
		cQuery01 += "ORDER BY Z00.Z00_DATA, Z00.Z00_HORA "
		cQuery01 := ChangeQuery( cQuery01 )
		TCQUERY cQuery01 NEW ALIAS "Z00W"
		Z00W->( DBGoTop() )

		While ! Z00W->( EoF() )
			nPrdTur1 ++
			Z00W->( DbSkip() )
		End

		Z00W->( DbCloseArea() )

	ElseIf SubStr( cHora, 1, 5 ) >= "13:55" .and. SubStr( cHora, 1, 5 ) < "22:00"
		cQuery02 := "SELECT Z00.Z00_OP, Z00.Z00_DATA, Z00.Z00_HORA FROM " + RetSqlName( "Z00" ) + " Z00 "
		cQuery02 += "WHERE Z00.Z00_OP = '" + cOPtmp + "'AND Z00.Z00_QUANT > 0 AND Z00.Z00_HORA BETWEEN '13:55' AND '21:59' "
		cQuery02 += "AND Z00.Z00_DATA = '" + cDataAtu + "' "
		cQuery02 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
		cQuery02 += "ORDER BY Z00.Z00_DATA, Z00.Z00_HORA "
		cQuery02 := ChangeQuery( cQuery02 )
		TCQUERY cQuery02 NEW ALIAS "Z00X"
		Z00X->( DBGoTop() )

		While ! Z00X->( EoF() )
			nPrdTur2 ++
			Z00X->( DbSkip() )
		End

		Z00X->( DbCloseArea() )

	ElseIf SubStr( cHora, 1, 5 ) >= "22:00" .and. SubStr( cHora, 1, 5 ) < "23:59"
		cQuery03 := "SELECT Z00.Z00_OP, Z00.Z00_DATA, Z00.Z00_HORA FROM " + RetSqlName( "Z00" ) + " Z00 "
		cQuery03 += "WHERE Z00.Z00_OP = '" + cOPtmp + "'AND Z00.Z00_QUANT > 0 AND Z00.Z00_HORA BETWEEN '22:00' AND '23:59' "
		cQuery03 += "AND Z00.Z00_DATA = '" + cDataAtu + "' "
		cQuery03 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
		cQuery03 += "ORDER BY Z00.Z00_DATA, Z00.Z00_HORA "
		cQuery03 := ChangeQuery( cQuery03 )
		TCQUERY cQuery03 NEW ALIAS "Z00Y"
		Z00Y->( DBGoTop() )

		While ! Z00Y->( EoF() )
			nPrdTur3A ++
			Z00Y->( DbSkip() )
		End

		Z00Y->( DbCloseArea() )

	ElseIf SubStr( cHora, 1, 5 ) >= "00:00" .and. SubStr( cHora, 1, 5 ) < "05:35"
		cQuery03 := "SELECT Z00.Z00_OP, Z00.Z00_DATA, Z00.Z00_HORA FROM " + RetSqlName( "Z00" ) + " Z00 "
		cQuery03 += "WHERE Z00.Z00_OP = '" + cOPtmp + "'AND Z00.Z00_QUANT > 0 AND Z00.Z00_HORA BETWEEN '22:00' AND '23:59' "
		cQuery03 += "AND Z00.Z00_DATA = '" + cDataAnt + "' "
		cQuery03 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
		cQuery03 += "ORDER BY Z00.Z00_DATA, Z00.Z00_HORA "
		cQuery03 := ChangeQuery( cQuery03 )
		TCQUERY cQuery03 NEW ALIAS "Z00Y"

		cQuery04 := "SELECT Z00.Z00_OP, Z00.Z00_DATA, Z00.Z00_HORA FROM " + RetSqlName( "Z00" ) + " Z00 "
		cQuery04 += "WHERE Z00.Z00_OP = '" + cOPtmp + "'AND Z00.Z00_QUANT > 0 AND Z00.Z00_HORA BETWEEN '00:00' AND '05:34' "
		cQuery04 += "AND Z00.Z00_DATA = '" + cDataAtu + "' "
		cQuery04 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
		cQuery04 += "ORDER BY Z00.Z00_DATA, Z00.Z00_HORA "
		cQuery04 := ChangeQuery( cQuery04 )
		TCQUERY cQuery04 NEW ALIAS "Z00Z"

		Z00Y->( DBGoTop() )
		Z00Z->( DBGoTop() )

		While ! Z00Y->( EoF() )
			nPrdTur3A ++
			Z00Y->( DbSkip() )
		End

		While ! Z00Z->( EoF() )
			nPrdTur3B ++
			Z00Z->( DbSkip() )
		End

		nPrdTur3C := nPrdTur3A + nPrdTur3B

		Z00Y->( DbCloseArea() )
		Z00Z->( DbCloseArea() )

	EndIf

	/*
	If nPrdTur1 > 0
		oSayINFO05:cCaption := Str( nPrdTur1 ) + " FD"
		ObjectMethod( oSayINFO05, "Refresh()" )
	ElseIf nPrdTur2 > 0
		oSayINFO05:cCaption := Str( nPrdTur2 ) + " FD"
		ObjectMethod( oSayINFO05, "Refresh()" )
	ElseIf nPrdTur3C > 0
		oSayINFO05:cCaption := Str( nPrdTur3C ) + " FD"
		ObjectMethod( oSayINFO05, "Refresh()" )
	EndIf
	*/

	cQuery05 := "SELECT * FROM " + RetSqlName( "Z00" ) + " Z00 "
	cQuery05 += "WHERE Z00.Z00_OP = '" + cOPtmp + "' AND Z00.Z00_QUANT > 0 "
	cQuery05 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery05 := ChangeQuery( cQuery05 )
	TCQUERY cQuery05 NEW ALIAS "Z00V"

	While ! Z00V->( EoF() )
		nTotaPes ++
		Z00V->( DbSkip() )
	End

	Z00V->( DbCloseArea() )

	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )

	//nTotaPes := Round( SC2->C2_QUJE / ( B5_QTDFIM / B5_QE2 ), 2 )

	oSayINFO05:cCaption :=  Alltrim( Str( nTotaPes ) + " FDs" )
	ObjectMethod( oSayINFO05, "Refresh()" )

	cQuery06 := "SELECT * FROM " + RetSqlName( "Z00" ) + " Z00 "
	cQuery06 += "WHERE Z00.Z00_OP = '" + cOPtmp + "' AND Z00.Z00_QUANT > 0 AND Z00.Z00_BAIXA = 'N' "
	cQuery06 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery06 := ChangeQuery( cQuery06 )
	TCQUERY cQuery06 NEW ALIAS "Z00U"

	While ! Z00U->( EoF() )
		nTotNPes ++
		Z00U->( DbSkip() )
	End

	Z00U->( DbCloseArea() )

	nRestOP := Iif( ( ( SC2->C2_QUANT - SC2->C2_QUJE ) / ( SB5->B5_QTDFIM / SB5->B5_QE2 ) ) - nTotNPes < 0, 0, ( ( SC2->C2_QUANT - SC2->C2_QUJE ) / ;
				  ( SB5->B5_QTDFIM / SB5->B5_QE2 ) ) - nTotNPes )
	oSayINFO06:cCaption := Alltrim( Str( Round( nRestOP, 2 ) ) + " FDs" )
	ObjectMethod( oSayINFO06, "Refresh()" )

	cProduto := SC2->C2_PRODUTO
	oSayINFO01:cCaption := "OP: " + Substr( cOP, 1, 6 ) + " - " + Alltrim( cProduto )
	ObjectMethod( oSayINFO01, "Refresh()" )

	//oSayINFO02:cCaption := Alltrim( cProduto )
	//ObjectMethod( oSayINFO02, "Refresh()" )
	cDescric := SB1->B1_DESC
	oSayINFO03:cCaption := Alltrim( cDescric )
	ObjectMethod( oSayINFO03, "Refresh()" )

Return Nil


***************
Static Function AtuPeso()
***************

	ObjectMethod( oSayINFO04, "SetText( Alltrim( Str( nQUANT, 0 ) + ' FDs' ) )" )

Return Nil 


***************
Static Function AtuRegs()
***************

	Local X := nBranco := Nil
	Local lBranco := .T.
	Local cSAY	:= cRegRed := cXTmp := cEmBranc := ""

	Colora( 2 )

	FOR X := 1 TO 39

		cXTmp := StrZero( X, 2 )
		IF oSayReg&cXTmp:cCaption == "" .AND. lBranco == .T.
			lBranco := .F.
			cEmBranc := StrZero( X, 2 )
			IF cEmBranc == "01"
				Exit
			ENDIF
		ENDIF

		IF Alltrim( Substr( oSayReg&cXTmp:cCaption, 10, 10 ) ) $ Substr( cOP, 1, 6 )
			IF oSayReg&cXTmp:nClrText == CLR_WHITE
				cSAY := cRegRed := StrZero( X, 2 )
				Exit
			Else
				cSAY := StrZero( X, 2 )
			ENDIF
		EndIf

		If oSayReg&cXTmp:nClrText == CLR_WHITE
			cRegRed := StrZero( X, 2 )
		ENDIF

	NEXT

	IF cSAY <> ""
		ModReg( cSAY, cRegRed, cOP )
	ElseIf cSAY == "" .AND. cRegRed <> "" .AND. cEmBranc <> "01" .AND. cEmBranc <> ""
		ModReg( cEmBranc, cRegRed, cOP )
	ElseIf cSAY == "" .AND. cRegRed == "" .AND. cEmBranc == "01"
		ModReg( "01", "01", cOP )
	ElseIf cSAY == "" .AND. cRegRed <> "" .AND. cEmBranc == ""
		Reorgan()
	ENDIF

	/*
	For X := 1 to 39
		cSAY := StrZero( X, 2 )
		If Alltrim( Substr( oSayReg&cSAY:cCaption, 10, 10 ) ) $ Substr( cOP, 1, 6 )

			lAchado := .T.
			If cRegRed == ""
				//oSayReg&cSAY:nClrText := CLR_HRED
				//ObjectMethod( oSayReg&cSAY, "SetColor( " +  str( CLR_HRED ) + " )" )
				ObjectMethod( oSayReg&cSAY, "SetColor( " +  str( CLR_WHITE ) + ", " + str( CLR_GRAY ) + ", " + str( CLR_WHITE ) +" )" )
			Else
				//ObjectMethod( oSayReg&cRegRed, "SetColor( " +  str( CLR_HRED ) + " )" ) //oSayReg&cRegRed:nClrText := CLR_BLACK
				ObjectMethod( oSayReg&cRegRed, "SetColor( " +  str( CLR_BLACK ) + ", " + str( CLR_WHITE ) + ", " + str( CLR_WHITE ) +" )" )
				//ObjectMethod( oSayReg&cSAY, "SetColor( " +  str( CLR_HRED ) + " )" ) //oSayReg&cSAY:nClrText := CLR_HRED
				ObjectMethod( oSayReg&cSAY, "SetColor( " +  str( CLR_WHITE ) + ", " + str( CLR_GRAY ) + ", " + str( CLR_WHITE ) +" )" )
			EndIF
			cRegRed := cSAY
			Exit
		ElseIf oSayReg&cSAY:cCaption == "" .and. lBranco == .F.
			nBranco := X
			lBranco := .T.
			ModReg( cSAY, cOP )
			cRegRed := cSAY
			Exit
		EndIf
	Next

	If lAchado == .F. .and. lBranco == .F.
		Reorgan()
	EndIf
	*/

Return Nil


***************
Static Function Reorgan()
***************

	local nTmpX := sSAY := ""

	For X := 39 to 2 step -1
		cSAY	:= StrZero( X, 2 )
		cTmpX := StrZero( X - 1, 2 )
		oSayReg&cSAY:cCaption := oSayReg&cTmpX:cCaption
		ObjectMethod( oSayReg&cSAY, "Refresh()" )
		IF oSayReg&cSAY:nClrText == CLR_WHITE
			cRegRed := StrZero( X, 2 )
		ENDIF
	Next
	ModReg( "01", cRegRed, cOP )
	//cRegRed := "01"

Return Nil


***************
Static Function ModReg(cSAYM, cRegRedM, cOP)
***************

	SC2->( Dbseek( xFilial( "SC2" ) + Substr( cOP, 1, 6 ) ) )
	cNewReg := Left( SC2->C2_PRODUTO, 7 ) + Space( 5 ) + Alltrim( SC2->C2_NUM ) + Space( 4 ) + Alltrim( SC2->C2_RECURSO ) + Space( 3 ) + ;
				  PADR( Transform( SC2->C2_QUANT, "@E 9,999.99" ), 8 ) + Space( 1 ) + Alltrim( SC2->C2_UM ) + ;//+ Space( 2 ) + ;
				  Iif( ( SC2->C2_QUANT - SC2->C2_QUJE ) - nTotNPes < 0, Space( 5 ) + "00,00", Space( 2 ) + PADR( Transform( ( SC2->C2_QUANT - SC2->C2_QUJE ) - nTotNPes, "@E 9,999.99" ), 8 ) ) + ;
				  Space( 1 ) + Alltrim( SC2->C2_UM ) + Space( 3 ) + CalcTurn(cOP) + Space( 1 ) + "FDs"
	ObjectMethod( oSayReg&cSAYM, "SetText( cNewReg )" )
	ObjectMethod( oSayReg&cSAYM, "SetColor( " +  str( CLR_WHITE ) + ", " + str( CLR_GRAY ) + ", " + str( CLR_WHITE ) +" )" )
	If cRegRedM <> "" .AND. cRegRedM <> cSAYM// .AND. cRegRed <> "01"// .OR. nTmpX <> ""
		ObjectMethod( oSayReg&cRegRedM, "SetColor( " +  str( CLR_BLACK ) + ", " + str( CLR_WHITE ) + ", " + str( CLR_WHITE ) +" )" )
	EndIf

Return Nil


***************
Static Function CalcTurn(cOP)
***************

	cTurno	:= Nil
	cOPtmp	:= cOP
	nQtdTurn	:= 0
	cTURNO1	:= GetMv( "MV_TURNO1" )
	cTURNO2	:= GetMv( "MV_TURNO2" )
	cTURNO3	:= GetMv( "MV_TURNO3" )

	cQueryFD := "SELECT Z00_OP, Z00_HORA, Z00_DATA FROM " + RetSqlName( "Z00" ) + " Z00020 "
	cQueryFD += "WHERE Z00_OP = '" + cOPtmp + "' AND Z00_QUANT > 0 "  //AND Z00_HORA BETWEEN '06:00' AND '12:00' "
	cQueryFD += "AND Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND D_E_L_E_T_ = ' ' "
	cQueryFD += "ORDER BY Z00_HORA "
	cQueryFD := ChangeQuery( cQueryFD )
	TCQUERY cQueryFD NEW ALIAS "Z00X"

	Z00X->( DBGoTop() )

	nTURNO1   := nTURNO2   := nTURNO3   := 0
	nPRODDKG  := nPRODDMR  := 0

	dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )

	Do While ! Z00X->( Eof() )

		If Z00X->Z00_DATA == DtoS( dDIA ) .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
			nTURNO1 := nTURNO1 + 1
		ElseIf Z00X->Z00_DATA == DtoS( dDIA ) .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			nTURNO2 := nTURNO2 + 1
		ElseIf ( Z00X->Z00_DATA == DtoS( dDIA ) .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		( Z00X->Z00_DATA == DtoS( dDIA + 1) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			nTURNO3 := nTURNO3 + 1
		EndIf
		Z00X->( DbSkip() )
	EndDo

	If Left( Time(), 5 ) >= Left( cTURNO1, 5 ) .AND. Left( Time(), 5 ) <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 ) //nTURNO1 > 0
		nQtdTurn := nTURNO1
		cTurno   := "Ordens em Producao em Processo ate o Momento - Turno 01"
		//ObjectMethod( oDlg, "SetText( cTurno )" )
		oDlg:cCaption := cTurno
		ObjectMethod( oDlg, "Refresh()" )
	ElseIf Left( Time(), 5 ) >= Left( cTURNO2, 5 ) .AND. Left( Time(), 5 ) <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 ) // nTURNO2 > 0
		nQtdTurn := nTURNO2
		cTurno   := "Ordens em Producao em Processo ate o Momento - Turno 02"
		//ObjectMethod( oDlg, "SetText( cTurno )" )
		oDlg:cCaption := cTurno
		ObjectMethod( oDlg, "Refresh()" )
	ElseIf ( DtoS( Date() ) == DtoS( dDIA ) .and. Left( Time(), 5 ) >= Left( cTURNO3, 5 ) ) .or. ;
		( DtoS( Date() ) == DtoS( dDIA + 1) .and. Left( Time(), 5 ) <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) ) //nTURNO3 > 0
		nQtdTurn := nTURNO3
		cTurno   := "Ordens em Producao em Processo ate o Momento - Turno 03"
		//ObjectMethod( oDlg, "SetText( cTurno )" )
		oDlg:cCaption := cTurno
		ObjectMethod( oDlg, "Refresh()" )
	EndIf
	Z00X->( DbCloseArea() )

Return StrZero( nQtdTurn, 2 )


***************
Static Function Colora( nOpcao )
***************

	Local nOpTmp := nOpcao

	IF nOpTmp == 1
		oSayINFO01:nClrText 	:= CLR_HRED		//OP - Produto
		ObjectMethod( oSayINFO01, "Refresh()" )
		oSayINFO03:nClrText 	:= CLR_HRED		//Descricao do Produto
		ObjectMethod( oSayINFO03, "Refresh()" )
		oSayPESADA:nClrText 	:= CLR_RED		//Qtd Pesada
		ObjectMethod( oSayPESADA, "Refresh()" )
		oSayINFO04:nClrText 	:= CLR_RED		//Valor da Qtd Pesada
		ObjectMethod( oSayINFO04, "Refresh()" )
		oSayPROCES:nClrText 	:= CLR_BLUE		//Total Pesado
		ObjectMethod( oSayPROCES, "Refresh()" )
		oSayINFO05:nClrText 	:= CLR_BLUE		//Valor do Total Pesado
		ObjectMethod( oSayINFO05, "Refresh()" )
		oSayREST:nClrText 	:= CLR_GREEN	//Rest. da OP
		ObjectMethod( oSayREST, "Refresh()" )
		oSayINFO06:nClrText 	:= CLR_GREEN	//Valor do Rest. da OP
		ObjectMethod( oSayINFO06, "Refresh()" )
	Else
		oSayINFO01:nClrText 	:= CLR_LIGHTGRAY		//OP - Produto
		ObjectMethod( oSayINFO01, "Refresh()" )
		oSayINFO03:nClrText 	:= CLR_LIGHTGRAY		//Descricao do Produto
		ObjectMethod( oSayINFO03, "Refresh()" )
		oSayPESADA:nClrText 	:= CLR_LIGHTGRAY		//Qtd Pesada
		ObjectMethod( oSayPESADA, "Refresh()" )
		oSayINFO04:nClrText 	:= CLR_LIGHTGRAY		//Valor da Qtd Pesada
		ObjectMethod( oSayINFO04, "Refresh()" )
		oSayPROCES:nClrText 	:= CLR_LIGHTGRAY		//Total Pesado
		ObjectMethod( oSayPROCES, "Refresh()" )
		oSayINFO05:nClrText 	:= CLR_LIGHTGRAY		//Valor do Total Pesado
		ObjectMethod( oSayINFO05, "Refresh()" )
		oSayREST:nClrText 	:= CLR_LIGHTGRAY	//Rest. da OP
		ObjectMethod( oSayREST, "Refresh()" )
		oSayINFO06:nClrText 	:= CLR_LIGHTGRAY	//Valor do Rest. da OP
		ObjectMethod( oSayINFO06, "Refresh()" )
	ENDIF

Return Nil

***************

Static Function endOP( cOPRD, nOpt )

***************

/*local cAlias := alias()
local nRec   := &( cAlias+"->( Recno() )"    )
local nOrd   := &( cAlias+"->( indexOrd() )" )*/
//local cQuery := ''
local aUSUARIO := {}
Local lSemINSP := .F.
Local lQPK	   := .F.

if ! empty( cOPRD )
	if ! PesqOp2( cOPRD )
		return
	endIf
	if nOpt == 1
		If ( ( ( SC2->C2_QUANT ) + ( 5 * SC2->C2_QUANT / 100 ) ) * SB5->B5_QE2 < SC2->C2_QUJE * SB5->B5_QE2 );
		.OR. ( ( ( SC2->C2_QUANT ) - ( 5 * SC2->C2_QUANT / 100 ) ) * SB5->B5_QE2 > SC2->C2_QUJE * SB5->B5_QE2 )
				if msgYesNo("Você está tentando cancelar uma OP fora dos limites. Deseja continuar ?")
					//aUSUARIO := U_senha3( "05", 1 )
					//If ! aUSUARIO[ 1 ]
				   	msgAlert("Voce não tem permissão para cancelar OPs fora dos limites!")
	  	      		//Return NIL
	  	      		
	         	EndIf
        else
         	return       	
		endIf	
	endIf	
	
	if msgYesNo("Você realmente deseja encerrar a OP " + alltrim( cOPRD ) + " ?")
		Reclock("SC2",.F.)
		SC2->C2_FINALIZ := '*'
		SC2->( msUnlock() )
		
		//FR - 06/05/2011
		////busca a OP nos registros de inspeção para verificar se já foi realizada ou não
		QPK->(Dbsetorder(1))
		If QPK->(Dbseek(xFilial("QPK") + cOPRD ))
			lQPK := .T.	      //SÓ IRÁ VERIFICAR SE EXISTE / NÃO EXISTE REGISTRO DE INSPEÇÃO SE A OP POSSUI ENTRADA PARA INSPEÇÃO (TABELA QPK)
		Endif
		
		If lQPK
			QPL->(Dbsetorder(1))
			If QPL->(Dbseek(xFilial("QPL") + cOPRD ))
				If Empty(QPL->QPL_LAUDO)     //caso encontre e o laudo esteja vazio, considero que não houve registro de inspeção
					lSemINSP := .T.
				Else
					lSemINSP := .F.
					//msgbox("TEM LAUDO")
				Endif
			Else	//se não encontrou é porque não houve nenhuma inspeção
				lSemINSP := .T.	
			Endif
			
			If lSemINSP .and. SC2->C2_EMISSAO >= CtoD("16/05/2011")
				//MSGBOX("ENVIA EMAIL DE OP NÃO INSPECIONADA")
				
				//cMailTo := "flavia.rocha@ravaembalagens.com.br"
				cMailTo := "marcelo@ravaembalagens.com.br"
				cCopia  := "flavia.rocha@ravaembalagens.com.br"
				cCorpo	:= " OP / ITEM / SEQUENCIA: " + SC2->C2_NUM + " / " + SC2->C2_ITEM + " / " + SC2->C2_SEQUEN + CHR(13) + CHR(10)
				cCorpo  += " Nesta data : " + Dtoc(dDatabase) + CHR(13) + CHR(10)					
				cCorpo  += " Produto    : " + SC2->C2_PRODUTO + CHR(13) + CHR(10)
				cCorpo  += " Qtde OP    : " + str(SC2->C2_QUANT) + CHR(13) + CHR(10)
				cCorpo  += " Qtde Produz: " + str(SC2->C2_QUJE)  + CHR(13) + CHR(10)
				cAnexo  := "" 
				cAssun  := "OP FINALIZADA sem REGISTRO DE INSPEÇÃO " 
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
					
			Endif
		Endif
		
	endIf
else
	msgAlert("Favor inserir um num. de OP !")
	return
endIf
//dbSelectArea( cAlias ); dbSetOrder( nOrd ); dbGoTo( nRec )

return

***************

Static Function PesqOp2( cOPRD )

***************

local lRETR := .T.

If Len( AllTrim( cOPRD ) ) == 6
	cOPRD := Left( cOPRD, 6 ) + "01001"
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + cOPRD, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOPRD
	 MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	 return .F.
/*
Else
	 If SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	      If ! SB1->B1_TIPO $ "PA*ME"
				 MsgAlert( OemToAnsi( "Esta OP nao e de produto acabado ou embalagem ! " ) )
				 return .F.
			EndIf
			If ! SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
				 MsgAlert( OemToAnsi( "Complemento do produto nao cadastrado ! " ) )
				 return .F.
			EndIf
			If Empty( SB5->B5_QTDFIM )
				 MsgAlert( OemToAnsi( "Quantidade por embalagem final nao informada no produto ! " ) )
				 return .F.
			EndIf
	 Else
			MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado ! " ) )
			return .F.
	 EndIf
 	 If ( lRETR .and. ! Empty( SC2->C2_DATRF ) ) .OR. ! empty( SC2->C2_FINALIZ )
			MsgAlert( OemToAnsi( "Esta OP ja foi encerrada ou marcada para encerramento!" ) )
 			return .F.
	 EndIf
*/
EndIf

Return lRETR