#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "MSGRAPHI.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ    |ฏฏ|
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ    |  |
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ    |  |
//ฑฑบFuncao    ณGrafico   บAutor  ณRUBEM DUARTE OLIOTA บ Data ณ  11/08/10   บฑฑ    |  |
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ    |  |
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ  __|  |__
//ฑฑบUso       ณ                                                            บฑฑ  \      /
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ   \    /
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ    \  /
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿     \/



user function TMKR008()

Local cQuery := " "
Local nCbx := 1
Local aCbx := {"Barras"}
Local cCbx := aCbx[1]
local oDlg


local cTit:=""
if ! pergunte('TMKR008',.T.)
	return
endif



cTit:=''//Motivos de Reclama็๕es de Clientes ( '+cMES +' )
nVisual:=1

MsAguarde( {|| MontaGrafico(1,nVisual,1,cTit)  }, OemToAnsi( "Aguarde" ), OemToAnsi( "Montando Grafico ..." ) )

//[1]<---    tipo do grafico   Linhas
//[4]<---    tipo do grafico   Barras

Return Nil

//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบFuncao    ณMontaGraf บAutor  ณClaudio D. de Souza บ Data ณ  30/08/01   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ Processa os dados necessarios para montagem do grafico e   บฑฑ
//ฑฑบ          ณ exibe o grafico.                                           บฑฑ
//ฑฑบ          ณ cAlias  -> Alias do arquivo temporario que sera processado บฑฑ
//ฑฑบ          ณ nCbx    -> Codigo da serie de dados que sera utilizada peloบฑฑ
//ฑฑบ          ณ            objeto grafico                                  บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ TMKR004                                                    บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function MontaGrafico(nCbx,nVisual,nMoeda,cTit)
Local oDlg
Local obmp
Local oBold
Local oGraphic
Local nSerie := 0
Local aArea  := GetArea()
Local aTabela
local aFluxo
Local nX     := 0
Local oPanel
Local aSize
Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
Local lVideo    := .F.

Local nRes   := nOrdemn := nCol := nCol2 := nLin := x := y := nInd := nProuc := 0
Local aArrCt := {}
Local aArrEx := {}
Local aTmp   := {}

Local cQuery   := cNome   := cMaqi := ''
Local aCores   :={}
Local nTot     :=0
Local cnt      :=0
Local nPercent :=0
Local x        :=0
Local y        :=0

//Verifica se a resolu็ใo de vํdeo ้ menor que 1024x768
If oMainWnd:nClientWidth < 1000
	lVideo := .T.
EndIf

aTabela		:= {;
{	cTit            ,;
"PROBLEMA"      ,;
"QUANTIDADE"     ;
};
}


cQuery := "  SELECT            "+chr(10)
cQuery += "   COUNT(*) QNT    ,"+chr(10)

if empty(MV_PAR04)
	cQuery += " Z46_DESCRI  DESCRI "+chr(10)
else
	cQuery += " UC_DATA     DAT      "+chr(10)
endif
cQuery += " FROM                           "+chr(10)
cQuery += "  "+retSqlName('Z46') + " Z46 , "+chr(10)
cQuery += "  "+retSqlName('SUD') + " SUD , "+chr(10)
cQuery += "  "+retSqlName('SUC') + " SUC , "+chr(10)
cQuery += "  "+retSqlName('SD2') + " SD2   "+chr(10)
cQuery += " WHERE                          "+chr(10)
cQuery += "     UC_CODIGO=UD_CODIGO        "+chr(10)
cQuery += " AND UC_NFISCAL=D2_DOC          "+chr(10)
cQuery += " AND UC_SERINF=D2_SERIE         "+chr(10)
cQuery += " AND UD_N1='0001'               "+chr(10)
cQuery += " AND UD_N4=Z46_CODIGO           "+chr(10)
cQuery += " AND Z46_DESCRI <> ''           "+chr(10)
cQuery += " AND UC_DATA between            "+valtosql(MV_PAR01)+"  and  "+valtosql(MV_PAR02)+" "+chr(10)
cQuery += " AND Z46.D_E_L_E_T_=''   "+chr(10)
cQuery += " AND SUD.D_E_L_E_T_=''   "+chr(10)
cQuery += " AND SUC.D_E_L_E_T_=''   "+chr(10)
cQuery += " AND SD2.D_E_L_E_T_=''   "+chr(10)
if !empty(MV_PAR04)
	cQuery += " AND upper(Z46_DESCRI) like upper('%"+ MV_PAR04 +"%')  "+chr(10)
endif

cQuery += " AND upper(UD_USERESP) like upper('%"+U_Usu_Cod2Nome(MV_PAR03)+"%')  "+chr(10)
cQuery += " GROUP BY     "+chr(10)

if  empty(MV_PAR04)
	cQuery += "   Z46_DESCRI "+chr(10)
else
	cQuery += "   UC_DATA   "+chr(10)
endif

cQuery += " order BY     "+chr(10)
if  empty(MV_PAR04)
	cQuery += "   Z46_DESCRI "+chr(10)
else
	cQuery += "    UC_DATA   "+chr(10)
endif

TCQUERY cQuery NEW ALIAS 'TMPX'
TMPX->( dbGoTop() )
aArrCt := {}

do While ! TMPX->( EoF() )
	
	cInfo:=iif(empty(MV_PAR04),DESCRI,substr(DAT,7,2)+"/"+substr(DAT,5,2))
	aAdd(aArrCt, {QNT, cInfo } )
	
	TMPX->(dbSkip())
endDo
TMPX->( dbCloseArea() )
aSize := MSADVSIZE()

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] PIXEL TITLE "Representa็ใo grแfica dos Motivos de Reclama็๕es de clientes "
oDlg:lMaximized := .T.

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD


@ 25, 50 MSGRAPHIC oGraphic SIZE 455, 320  OF oDlg PIXEL


oGraphic:SetTitle("Grafico : Responsavel  X  Problema","",CLR_HBLUE,3,.F.)
oGraphic:SetMargins( 2, 6, 6, 6 )
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posi็ใo x,y em rela็ใo a Dialog

MENU oMenu POPUP
MENUITEM "Consulta dados do grafico" Action ConsDadGraf(aTabela) //
ENDMENU


oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
if len(aArrCt)==1
	nCbx:=4
endif
if empty(MV_PAR04)
	nCbx:=4
endif
                    
nSerie  := oGraphic:CreateSerie(nCbx,,0)

aCores:={CLR_BLUE,CLR_HBLUE,CLR_RED,CLR_HRED,CLR_GREEN,CLR_HGREEN,CLR_GRAY,CLR_HGRAY,CLR_WHITE,CLR_BLACK,CLR_YELLOW}
nCor:=aCores[(val(MV_PAR03)%LEN(aCores))+1]
If nSerie != GRP_CREATE_ERR
	for x:=1 to len(aArrCt)
		oGraphic:Add(nSerie  ,  aArrCt[x][1]    , "( "+strtran(alltrim(lower(aArrCt[x][2])),"por ","p/ ")+" )"   , nCor   )
	next
	oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_AUTO,.F.)
Else
	IW_MSGBOX("STR0124","STR0198","STOP")  
Endif

oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( iif(empty(MV_PAR04),"Problema","Data"), "", CLR_GREEN, A_RIGHTJUS , GRP_FOOT  )

oGrp1      := TGroup():New( 005,001,025,100,"Responsแvel",oDlg,CLR_BLUE,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 012,05,{|| substr(upper(U_Usu_Cod2Nome(MV_PAR03)),1,14) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)

if ! empty( MV_PAR04)
	oGrp1      := TGroup():New( 005,110,025,500,"Problema",oDlg,CLR_BLUE,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 012,115,{|| substr(upper(U_Usu_Cod2Nome(MV_PAR04)),1,14) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
endif

@ 009+20, 1 BUTTON o3D PROMPT "&2D" SIZE 50,14 OF oDlg PIXEL ACTION (oGraphic:l3D := !oGraphic:l3D, o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D"))
@ 023+20, 1 BUTTON     "&Salva BMP" SIZE 50,14 OF oDlg PIXEL ACTION GrafSavBmp( oGraphic ) //
If !__lPyme
	@ 037+20, 1 BUTTON "E-Mail"     SIZE 50,14 OF oDlg PIXEL ACTION PmsGrafMail(oGraphic,"STR0119",{"STR0120"},aTabela,1)
Endif
@ 051+20, 1 BUTTON     "&Sair"      SIZE 50,14 OF oDlg PIXEL ACTION oDlg:End()
 
If lVideo
	oGraphic:Align := CONTROL_ALIGN_ALLCLIENT
EndIf

ACTIVATE MSDIALOG oDlg
RestArea(aArea)

Return Nil

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
//ฑฑณProgram   ณ ConsDadGraf ณ Autor ณ Wagner Mobile Costa   ณ Data ณ 10.11.01 ณฑฑ
//ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
//ฑฑณDescri…o ณ Monta Browse de consulta sobre array utilizado para graficos  ณฑฑ
//ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function ConsDadGraf(aDados)
Local aTit := {}, aLenCol := {}, nLenTot := 0
Local oView, oDlg, aView := {}, nView
Local nX	:= 0

For nx := 1 to Len(aDados[1])
	Aadd(aTit, aDados[1][nX])
	If Len(aDados[1][nX]) > Len(aDados[2][nX])
		Aadd(aLenCol, GetTextWidth(0,Replicate("B", Len(aDados[2][nX]))))
	Else
		Aadd(aLenCol, GetTextWidth(0,Replicate("B", Len(aDados[1][nX]))))
	Endif
	nLenTot += aLenCol[Len(aLenCol)]
Next

nLenTot := (370*nLenTot)/130

DEFINE MSDIALOG oDlg FROM 0,0 TO 285,Min(nLenTot,oMainWnd:nRight-oMainWnd:nLeft - 10)  PIXEL TITLE "Consulta dados do grafico"

oView	:= TWBrowse():New( 1,1,	((oDlg:nRight - oDlg:nLeft)  / 2) - 5,;
(oDlg:nBottom / 2) - 15,,;
aTit,aLenCol,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

For nView := 2 To Len(aDados)
	Aadd(aView, aDados[nView])
Next

oView:SetArray(aView)
oView:bLine := { || aView[oView:nAT]}

//ACTIVATE MSDIALOG oDlg CENTER

Return
 
