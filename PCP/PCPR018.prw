#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "MSGRAPHI.CH"
        

user function PCPR018() 
   
Local aGRAFC:={;
               "Picotadeira"   ,;
               "Corte Solda" ;
              }  
Local aturno:={;
               "1º Turno"   ,;
               "2º Turno"   ,;
               "3º Turno"   ,;
               "Todos"   ,;
              }  

Local cTit:=""

IF Pergunte("PCPR018", .T.)
  cTit     :=aGRAFC[MV_PAR02]+' - '+aturno[MV_PAR03]  
  nVisual  :=1 
  
  MsAguarde( { || MontaGrafico(7,nVisual,cTit) }, "Aguarde. . .", "Montando o Gráfico ..." )  
  //[1]<---4   tipo do grafico   barras 
ENDIF 
  
Return Nil

***************
Static Function MontaGrafico(nTipo,nVisual,cTit)  
***************

Local oDlg
Local obmp
Local oBold
Local oGraphic 
Local oGroup 


Local nSerie     := 0
Local nSerie2    := 0          
Local X          := 0
Local Y          := 0
Local nTri       := 0
Local nTot       := 0
Local nLeft      := 0
Local nTop       := 0
Local nLegenda   := 0     
              
 
Local aTabela    := {}
Local aSize      := {}
Local aArea      := GetArea()

Local intervalo1 :=""
Local intervalo2 :="" 
Local cQuery     :=""
Local cmes       :=""

Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
Local lVideo    := .F.                                               
LOCAL aMaq:={}


* //Verifica se a resolução de vídeo é menor que 1024x768
If oMainWnd:nClientWidth < 1000
	lVideo := .T.
EndIf
       
aSize := MSADVSIZE()	

DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL  TITLE "Representação gráfica " 

oDlg:lMaximized := .T.
@ nTop    , nLeft    BUTTON o3D PROMPT " &Em 2D           "  SIZE 60,10  OF oDlg PIXEL ACTION (oGraphic:l3D := !oGraphic:l3D, o3d:cCaption := If(oGraphic:l3D, " &Em 2D           ", " &Em 3D           "))
@ nTop+=10, nLeft    BUTTON            "&Gráfico BMP"        SIZE 60,10  OF oDlg PIXEL ACTION GrafSavBmp( oGraphic ) 
@ nTop+=10, nLeft    BUTTON            "&Sair             "  SIZE 60,10  OF oDlg PIXEL ACTION oDlg:End()
nTop+=20
nLegenda:=nTop                                                   
 
* // -----------------
* // |   LEGENDA     |
* // -----------------

cData:=DTOC(MV_PAR01) 
@ nTop+=10, nLeft+=5    SAY "Data  : "+cData                                            OF oDlg                                    PIXEL
//@ nTop+= 5, nLeft-4     SAY replicate("_",16)                                         OF oDlg                                    PIXEL
//@ nTop+=10, nLeft       SAY "Apara %"                                                 OF oDlg   COLOR CLR_HBLUE    FONT oBold    PIXEL
//@ nTop+=10, nLeft       SAY "Apara % Total"                                           OF oDlg   COLOR CLR_RED      FONT oBold    PIXEL
oGroup:= tGroup()       :New(nLegenda,nLeft-=5,nTop+=10,50,"",oDlg,CLR_GREEN,,.T.) 


DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP    oBmp RESNAME "ProjetoAP" oF oDlg SIZE 50, 270 NOBORDER WHEN .F. PIXEL

//@ -07, 050 MSGRAPHIC oGraphic SIZE 565, 380   OF oDlg PIXEL
     
oGraphic := TMSGraphic():New( -07,050,oDlg,,,RGB(239,239,239),565,280) 
//oGraphic:SetMargins(2,6,6,6)

oGraphic:SetTitle("Grafico : Eficiencia " + cTit,"",CLR_GREEN,3,.F.)
//oGraphic:SetMargins( 0, 6, 6, 6 )
//oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posição x,y em relação a Dialog 


// Habilita a legenda, apenas se houver mais de uma serie de dados.
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
nSerie   := oGraphic:CreateSerie(nTipo,,2)
nSerie2  := oGraphic:CreateSerie(nTipo,,2)
 
cQry:="SELECT * FROM SH1020 SH1 "
If MV_PAR02=1
   cQry+="WHERE H1_CODIGO LIKE '[P][0-9][0-9]' "
ELSEIf MV_PAR02=2
   cQry+="WHERE H1_CODIGO LIKE '[C][0-9][0-9]' "
ENDIF
cQry+="AND SH1.D_E_L_E_T_!='*'  "

If Select("TMPX") > 0
  DbSelectArea("TMPX")
  TMPX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPX"

DataDe:=DTOS(MV_PAR01)
turno:=MV_PAR03
nSomaReal:=0
nSomaMeta:=0

Do While TMPX->(!EOF())
	aEfi:=U_PCPC018(DataDe,TMPX->H1_CODIGO,'','ZZZZZZZZZZZZZZ','',.F.)
	If  !empty(aEfi[1][1])
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
		    aADD(aMaq,{TMPX->H1_CODIGO,DataDe,aEfi[_MZ][2], iif(nSomaMeta<>0,(nSomaReal/nSomaMeta)*100,0)})	
		Next
	endif
	TMPX->(DBSKIP())
EndDo

If nSerie != GRP_CREATE_ERR  
	
	For _Y:=1 to len(aMaq)    
	    oGraphic:Add(nSerie    ,aMaq[_Y][4] ,  alltrim(aMaq[_Y][1])+'-'+aMaq[_Y][3]  ,CLR_HBLUE  )
    Next
    
   
    oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_AUTO,.F.)
Else
	IW_MSGBOX("STR0124","STR0198","STOP") //"Não foi possível criar a série."
Endif
  
                             
oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( "%"      ,"", CLR_GREEN  , A_LEFTJUST , GRP_TITLE )
oGraphic:SetTitle( "MAQUINAS","", CLR_GREEN  , A_CENTER , GRP_FOOT  )

 
ACTIVATE MSDIALOG oDlg //CENTER
RestArea(aArea)

Return Nil