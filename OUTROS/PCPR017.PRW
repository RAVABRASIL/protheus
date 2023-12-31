#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "MSGRAPHI.CH"

*************

user function PCPR017()

*************

Local cQuery := " "
Local nCbx := 1
Local aCbx := {"Barras"}
Local cCbx := aCbx[1]
local oDlg


local cTit:=""
if ! pergunte('PCPR017',.T.)
return
endif


cTit:="Eficiencia de Maquina  "
nVisual:=1
 
MsAguarde( {|| MontaGrafico(1,nVisual,1,cTit)  }, OemToAnsi( "Aguarde" ), OemToAnsi( "Montando Grafico ..." ) )
//[1]<---4   tipo do grafico   barras 

Return Nil

//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
//北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
//北篎uncao    矼ontaGraf 篈utor  矯laudio D. de Souza � Data �  30/08/01   罕�
//北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
//北篋esc.     � Processa os dados necessarios para montagem do grafico e   罕�
//北�          � exibe o grafico.                                           罕�
//北�          � cAlias  -> Alias do arquivo temporario que sera processado 罕�
//北�          � nCbx    -> Codigo da serie de dados que sera utilizada pelo罕�
//北�          �            objeto grafico                                  罕�
//北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
//北篣so       � TMKR004                                                    罕�
//北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
//哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�

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
Local aMaquina := {}
Local aArrEx := {}
Local aTmp   := {}
 
Local cQry   := cNome   := cMaq := ''
Local aCores   :={}
Local nTot     :=0
Local cnt      :=0
Local nPercent :=0
Local x        :=0
Local y        :=0
local aEfi:={}
Local nLeft      := 0
Local nTop       := 0
local nSomaReal:=0
local nSomaMeta:=0
Local aturno:={;
               "1� Turno"   ,;
               "2� Turno"   ,;
               "3� Turno"   ,;
               "Todos"   ,;
              }  

//Verifica se a resolu玢o de v韉eo � menor que 1024x768
If oMainWnd:nClientWidth < 1000
	lVideo := .T.
EndIf

aTabela		:= {;
                {	cTit            ,;
		 			"PROBLEMA"      ,;
		 			"QUANTIDADE"     ;
                };
               } 


DataDe:=MV_PAR01
DataAte:=MV_PAR02
cMaq:=ALLTRIM(MV_PAR03) 
turno:=MV_PAR04

Do While DataDe<=DataAte
    aEfi:=U_PCPC018(dtos(DataDe),cMaq,'','ZZZZZZZZZZZZZZ','',.F.)    
    aADD(aMaquina,{cMaq,dtos(DataDe),'A', 0})
    aADD(aMaquina,{cMaq,dtos(DataDe),'B', 0})
    aADD(aMaquina,{cMaq,dtos(DataDe),' ', 0})
	If !empty(aEfi[1][1])
		For _MZ := 1 to Len(aEfi)
			if turno==1 // 1 TURNO 
			   nSomaReal:=aEfi[_MZ][3]
			   nSomaMeta:=aEfi[_MZ][9]
		    ElseIf turno==2  // 2 TURNO
			   nSomaReal:=aEfi[_MZ][4]
			   nSomaMeta:=aEfi[_MZ][10]
		    ElseIf turno==3 // 3 TURNO 
			   nSomaReal:=aEfi[_MZ][5]
			   nSomaMeta:=aEfi[_MZ][11]				    
		    ElseIf turno==4  // TODOS 
			   nSomaReal:=aEfi[_MZ][3]+aEfi[_MZ][4]+aEfi[_MZ][5]
			   nSomaMeta:=aEfi[_MZ][9]+aEfi[_MZ][10]+aEfi[_MZ][11]				    
		    Endif
			nIdy := aScan( aMaquina, { |y| y[1]+y[2]+y[3] == cMaq+dtos(DataDe)+aEfi[_MZ][2] } )
			If nIdy>0
		       aMaquina[nIdy][4]:=iif(nSomaMeta<>0,(nSomaReal/nSomaMeta)*100,0)
		    Endif
		Next
	Endif
	DataDe+=1
Enddo

aSize := MSADVSIZE()

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] PIXEL TITLE "Representa玢o gr醘ica da Eficiencia de Maquina " 
oDlg:lMaximized := .T.

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

 
@ 05, 50 MSGRAPHIC oGraphic SIZE 650,330  OF oDlg PIXEL

cTit:="Eficiencia de Maquina "+ALLTRIM(cMaq)+' - '+aturno[turno]

oGraphic:SetTitle("Grafico : " + cTit,"",CLR_HBLUE,3,.F.)
oGraphic:SetMargins( 2, 6, 6, 6 )
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posi玢o x,y em rela玢o a Dialog 
/*
MENU oMenu POPUP
	MENUITEM "Consulta dados do grafico" Action ConsDadGraf(aTabela) //
ENDMENU
*/
 
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
nSerie  := oGraphic:CreateSerie(nCbx,,2)
nSerie2  := oGraphic:CreateSerie(nCbx,,2)
nSerie3  := oGraphic:CreateSerie(nCbx,,2)

If nSerie != GRP_CREATE_ERR  
	
	For _Y:=1 to len(aMaquina) 
	   
	   If ALLTRIM(aMaquina[_Y][3])='A'
	      oGraphic:Add(nSerie  ,     aMaquina[_Y][4] ,  dtoc(STOD(aMaquina[_Y][2]))  ,CLR_GREEN)      
	   Endif
	   If ALLTRIM(aMaquina[_Y][3])='B'
	      oGraphic:Add(nSerie2  ,     aMaquina[_Y][4] , dtoc(STOD(aMaquina[_Y][2]))  ,CLR_BLUE)      
	   Endif
	   If EMPTY(aMaquina[_Y][3])
	      oGraphic:Add(nSerie3  ,     aMaquina[_Y][4] , dtoc(STOD(aMaquina[_Y][2]))  ,CLR_RED)      
	   Endif

	Next
	 
    oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_AUTO,.F.)
Else
	IW_MSGBOX("STR0124","STR0198","STOP") //"N鉶 foi poss韛el criar a s閞ie."
Endif

oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( "%"      ,"", CLR_GREEN  , A_LEFTJUST , GRP_TITLE )
oGraphic:SetTitle( "Periodo", "", CLR_GREEN, A_RIGHTJUS , GRP_FOOT  )

@ 009, 1 BUTTON o3D PROMPT "&2D" SIZE 50,14 OF oDlg PIXEL ACTION (oGraphic:l3D := !oGraphic:l3D, o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D"))
@ 023, 1 BUTTON     "&Salva BMP" SIZE 50,14 OF oDlg PIXEL ACTION GrafSavBmp( oGraphic ) //
If !__lPyme
@ 037, 1 BUTTON         "E-Mail" SIZE 50,14 OF oDlg PIXEL ACTION PmsGrafMail(oGraphic,"STR0119",{"STR0120"},aTabela,1)
Endif
@ 051, 1 BUTTON          "&Sair" SIZE 50,14 OF oDlg PIXEL ACTION oDlg:End()
nTop:=051
nTop+=20
nLegenda:=nTop                                                   
nLeft:=1 
 // -----------------
 // |   LEGENDA     |
 // -----------------

@ nTop+=10, nLeft       SAY "Lado A "                                                 OF oDlg   COLOR CLR_GREEN    FONT oBold    PIXEL
@ nTop+=10, nLeft       SAY "Lado B "                                                 OF oDlg   COLOR CLR_BLUE      FONT oBold    PIXEL
@ nTop+=10, nLeft       SAY "Sem Lado"                                                 OF oDlg   COLOR CLR_RED      FONT oBold    PIXEL
oGroup:= tGroup()       :New(nLegenda,nLeft-=5,nTop+=10,50,"Legenda",oDlg,CLR_GREEN,,.T.) 




If lVideo
	oGraphic:Align := CONTROL_ALIGN_ALLCLIENT
EndIf

ACTIVATE MSDIALOG oDlg  
RestArea(aArea)

Return Nil

//苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//北谀哪哪哪哪穆哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
//北砅rogram   � ConsDadGraf � Autor � Wagner Mobile Costa   � Data � 10.11.01 潮�
//北媚哪哪哪哪呐哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
//北矰escri噮o � Monta Browse de consulta sobre array utilizado para graficos  潮�
//北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌

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

