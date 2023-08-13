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



user function TMKR004()

Local cQuery := " "
Local nCbx := 1
Local aCbx := {"Barras"}
Local cCbx := aCbx[1]
local oDlg


local cTit:=""
if ! pergunte('TMKR004',.T.)
return
endif

aMES := { 'Janeiro', 'Fevereiro', 'Mar็o'   , 'Abril'  , 'Maio'    , 'Junho'   ,;
          'Julho'  , 'Agosto'   , 'Setembro', 'Outubro', 'Novembro', 'Dezembro' }
 
cMES := aMES[   mv_par01  ]

cTit:='Motivos de Reclama็๕es de Clientes ( '+cMES +' )
nVisual:=1
 
MsAguarde( {|| MontaGrafico(1,nVisual,1,cTit)  }, OemToAnsi( "Aguarde" ), OemToAnsi( "Montando Grafico ..." ) )
//[1]<---4   tipo do grafico   barras 

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

tempo:=ddatabase 
tempo:=dtos(tempo) 
tempo1:=substr(tempo,1,4)+alltrim(strzero(MV_PAR01,2))+'01' 
tempo2:=substr(tempo,1,4)+alltrim(strzero(MV_PAR01,2))+'31'

cQuery := " SELECT "                        +chr(10)
cQuery += "  Z46_DESCRI PROBLEMA , "        +chr(10)
cQuery += "  UC_NFISCAL "                   +chr(10)
cQuery += " FROM "                          +chr(10)
cQuery += "  "+retSqlName('Z46') + " Z46 , "+chr(10)
cQuery += "  "+retSqlName('SUD') + " SUD , "+chr(10)
cQuery += "  "+retSqlName('SUC') + " SUC , "+chr(10)
cQuery += "  "+retSqlName('SD2') + " SD2   "+chr(10)
cQuery += " WHERE   "                       +chr(10)
cQuery += "  Z46.D_E_L_E_T_=''   AND "      +chr(10)
cQuery += "  SUD.D_E_L_E_T_=''   AND "      +chr(10)
cQuery += "  SUC.D_E_L_E_T_=''   AND "      +chr(10)
cQuery += "  SD2.D_E_L_E_T_=''   AND "      +chr(10)
cQuery += "  UC_CODIGO=UD_CODIGO AND "      +chr(10)
cQuery += "  UC_NFISCAL=D2_DOC   AND "      +chr(10)
cQuery += "  UC_SERINF=D2_SERIE  AND "      +chr(10)
cQuery += "  UD_N1='0001'        AND "      +chr(10)
cQuery += "  UD_N4=Z46_CODIGO    AND "      +chr(10)
cQuery += "  Z46_DESCRI <> ''    AND "      +chr(10)
IF MV_PAR02==2
cQuery += "  D2_GRUPO='C'        AND "   +chr(10)
ENDIF
cQuery += "  UC_DATA between "+valtosql(tempo1)+" and "+valtosql(tempo2)+" " +chr(10)
cQuery += " ORDER BY  Z46_DESCRI,UC_NFISCAL "                                +chr(10)

TCQUERY cQuery NEW ALIAS 'TMPX'
  TMPX->( dbGoTop() ) 

  aAdd(aArrCt, {"",""} )
  do While ! TMPX->( EoF() ) 
     lValid:=.T.
     for x:=1 to len (aArrCt)
        If at(alltrim(TMPX->UC_NFISCAL),alltrim(aArrCt[x][2])  ) !=0 .and.  at(alltrim(TMPX->PROBLEMA),alltrim(aArrCt[x][1])  ) !=0
           lValid:=.F. 
           exit
        endif 
     next x 
     if lValid 
        aAdd(aArrCt, {alltrim(TMPX->PROBLEMA),TMPX->UC_NFISCAL,1} )
     endif

   TMPX->( dbSkip() )
  endDo 
  TMPX->( dbCloseArea() )

   aux1:={}
   y:=0
   for x:=2 to len(aArrCt)
      busca:=aArrCt[x][1] 
      while busca==aArrCt[x][1]
         y++
         x++
         if x>len(aArrCt)
            exit  
         endif
      enddo 
         aadd(aux1, {busca,y} )
         y:=0
         x--
   next x
  aArrCt:=aux1
  aSize := MSADVSIZE()

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] PIXEL TITLE "Representa็ใo grแfica dos Motivos de Reclama็๕es de clientes " 
oDlg:lMaximized := .T.

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

 
@ 05, 50 MSGRAPHIC oGraphic SIZE 450, 330  OF oDlg PIXEL

oGraphic:SetTitle("Grafico : " + cTit,"",CLR_HBLUE,3,.F.)
oGraphic:SetMargins( 2, 6, 6, 6 )
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posi็ใo x,y em rela็ใo a Dialog 

MENU oMenu POPUP
	MENUITEM "Consulta dados do grafico" Action ConsDadGraf(aTabela) //
ENDMENU

 
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
nSerie  := oGraphic:CreateSerie(nCbx,,0)

If nSerie != GRP_CREATE_ERR  
  aSort( aArrCt,,, { |x,y| x[2] > y[2] } )  
  for x:=1 to len(aArrCt)
    if x==6
      exit
    endif 
    oGraphic:Add(nSerie  ,  aArrCt[x][2]    , '• ' +lower(aArrCt[x][1]) /*+space(10)*/  ,CLR_GREEN)
 next
 
 oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_AUTO,.F.)
Else
	IW_MSGBOX("STR0124","STR0198","STOP") //"Nใo foi possํvel criar a s้rie."
Endif

oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )

oGraphic:SetTitle( "Motivo", "", CLR_GREEN, A_RIGHTJUS , GRP_FOOT  )

@ 009, 1 BUTTON o3D PROMPT "&2D" SIZE 50,14 OF oDlg PIXEL ACTION (oGraphic:l3D := !oGraphic:l3D, o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D"))
@ 023, 1 BUTTON     "&Salva BMP" SIZE 50,14 OF oDlg PIXEL ACTION GrafSavBmp( oGraphic ) //
If !__lPyme
@ 037, 1 BUTTON         "E-Mail" SIZE 50,14 OF oDlg PIXEL ACTION PmsGrafMail(oGraphic,"STR0119",{"STR0120"},aTabela,1)
Endif
@ 051, 1 BUTTON          "&Sair" SIZE 50,14 OF oDlg PIXEL ACTION oDlg:End()

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

***************
Static Function meuScan( aArr, cHave, cHave2 )
***************
Local nIdx := 0

for x := 1 to len(aArr)
 if alltrim(upper(aArr[x][2])) $ alltrim(upper(cHave))
   if alltrim(upper(aArr[x][1])) == alltrim(upper(cHave2))
     return x
   endIf
 endIf
next
return 0

user function Valid_MES(nMes)
local lValid:=.T.

if nMes < 1
     lValid:= .F.
endif
if nMes > 12
     lValid:= .F.
endif

if !lValid
alert('Periodo Invแlido')
endif 

return lValid