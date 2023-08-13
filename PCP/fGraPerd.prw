#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "MSGRAPHI.CH"
        

*************

user function fGraPerd() 

*************   

Local cTit:=""

IF Pergunte("FGRAPERD", .T.)  
  cTit     :="As maiores interferências %"
  nVisual  :=0  
  nTipo:=IIF(MV_PAR03=1,10,4)
  MsAguarde( { || MontaGrafico(nTipo,nVisual,cTit) }, "Aguarde. . .", "Montando o Gráfico ..." )  
  //[1]<---4   tipo do grafico   barras 
/*
1-linha 
2-area
3-ponto
4-barra
10- PIZZA
*/
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

@ nTop+=10, nLeft+=5    SAY "De  : "          +transform(mv_par01,"@E 99/99/99")      OF oDlg                                    PIXEL
@ nTop+=10, nLeft       SAY "Ate :"           +transform(mv_par02,"@E 99/99/99")      OF oDlg                                    PIXEL
@ nTop+=10, nLeft       SAY "De  : "  +   mv_par04                                    OF oDlg                                    PIXEL
@ nTop+=10, nLeft       SAY "Ate :"   +   mv_par05                                    OF oDlg                                    PIXEL

@ nTop+= 5, nLeft-4     SAY replicate("_",16)                                         OF oDlg                                    PIXEL

@ nTop+=10, nLeft       SAY "Data :"+transform(Date(),"@E 99/99/99")      OF oDlg                                    PIXEL

oGroup:= tGroup()       :New(nLegenda,nLeft-=5,nTop+=10,50,"Legenda",oDlg,CLR_GREEN,,.T.) 

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP    oBmp RESNAME "As maiores interferências %" oF oDlg SIZE 50, 270 NOBORDER WHEN .F. PIXEL

//@ -07, 050 MSGRAPHIC oGraphic SIZE 465, 280   OF oDlg PIXEL


@ -07, 050 MSGRAPHIC oGraphic SIZE 500, 350   OF oDlg PIXEL
     
oGraphic:SetTitle("Grafico :","",CLR_BLACK,3,.T.)

oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posição x,y em relação a Dialog 

// Habilita a legenda, apenas se houver mais de uma serie de dados.
if MV_PAR03=1 // PIZZA
   oGraphic:SetLegenProp( GRP_SCRRIGHT , CLR_WHITE, GRP_SERIES, .T.)
ELSEIF MV_PAR03=2   // BARRA
  oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
ENDIF
nSerie   := oGraphic:CreateSerie(nTipo,,0)


DataI:=dtos(MV_PAR01) 
DataF:=dtos(MV_PAR02)

cQuery:="SELECT  TOP 10  H6_MOTIVO MOTIVO , "
cQuery+="DESCRI=X5_DESCRI, "
//PERDA=SUM(DATEDIFF(SECOND,CONVERT(DATETIME,CONVERT(VARCHAR(8),H6_DATAINI)+' '+H6_HORAINI),CONVERT(DATETIME,CONVERT(VARCHAR(8),H6_DATAFIN)+' '+H6_HORAFIN) ))
cQuery+="PERDA=SUM(H6_QTDPERD) "
cQuery+="FROM SH6020 SH6 , SX5020 SX5 "
cQuery+="WHERE "
cQuery+="H6_DATAINI BETWEEN '"+DataI+"' AND '"+DataF+"' "
cQuery+="AND X5_FILIAL=H6_FILIAL "
cQuery+="AND X5_TABELA='44'  "
cQuery+="AND H6_RECURSO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQuery+="AND H6_MOTIVO=X5_CHAVE  "
cQuery+="AND SH6.D_E_L_E_T_ = ' ' "
cQuery+="AND SX5.D_E_L_E_T_ = ' '  "
cQuery+="GROUP BY H6_MOTIVO,X5_DESCRI "
cQuery+="ORDER BY PERDA DESC  "

TCQUERY cQuery NEW ALIAS "SH6X"


SH6X->( DBGoTop() )

nTotal:=fTotal()
nCor:=1
aCor:={CLR_HBLUE,CLR_GREEN,CLR_YELLOW,CLR_RED,CLR_MAGENTA,CLR_WHITE,CLR_BROWN,CLR_CYAN,CLR_GRAY,CLR_HMAGENTA}
If nSerie != GRP_CREATE_ERR             
	Do While ! SH6X->( Eof() )  
	   oGraphic:Add(nSerie    ,( SH6X->PERDA/ nTotal) * 100     ,substr(SH6X->DESCRI,1,20)  ,IIF(MV_PAR03=1,iif(nCor>len(aCor),CLR_HBLUE,aCor[nCor]) ,CLR_HBLUE ) )         
	   SH6X->(DBSKIP())
	   nCor+=1
	Enddo
Else
	IW_MSGBOX("Não foi possível criar a série.","Não foi possível criar a série.","STOP") 
Endif

SH6X->( dbCloseArea() )                                 

oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( "%                                                                                                                                           As maiores interferências %"      ,"", CLR_GREEN  , A_LEFTJUST , GRP_TITLE )
oGraphic:SetTitle( "Motivos","", CLR_GREEN  , A_CENTER , GRP_FOOT  )


SetKey(  VK_F12,  { || U_FGRAPERD() } )
 
ACTIVATE MSDIALOG oDlg //CENTER
RestArea(aArea)

Return Nil


***************

Static Function fTotal()

***************
LOCAL nRet:=0

cQuery:="SELECT  "
cQuery+="TOTAL=SUM(PERDA) "
//cQuery+="FROM(SELECT  top 10 H6_MOTIVO MOTIVO , "
cQuery+="FROM(SELECT  H6_MOTIVO MOTIVO , "
cQuery+="DESCRI=X5_DESCRI, "
cQuery+="PERDA=SUM(H6_QTDPERD) "
cQuery+="FROM SH6020 SH6 , SX5020 SX5 "
cQuery+="WHERE  "
cQuery+="H6_DATAINI BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' "
cQuery+="AND X5_FILIAL=H6_FILIAL "
cQuery+="AND X5_TABELA='44' "
cQuery+="AND H6_MOTIVO=X5_CHAVE  "
cQuery+="AND H6_RECURSO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQuery+="AND SH6.D_E_L_E_T_ = ' '  "   
cQuery+="AND SX5.D_E_L_E_T_ = ' '  "
cQuery+="GROUP BY H6_MOTIVO,X5_DESCRI  "
//cQuery+="ORDER BY PERDA DESC  "
cQuery+=") AS TABX  "
TCQUERY cQuery NEW ALIAS "AUUX"


If AUUX->(!EOF())
   nRet:=AUUX->TOTAL
Endif

AUUX->( dbCloseArea() )    

Return nRet
 

/*
user function fgraperd()
local lGraph3D := .t. // .F. Grafico 2 dimensoes - .T. Grafico 3 dimensoes
local lMenuGraph := .t. // .F. Nao exibe menu - .T. Exibe menu para mudar o tipo de grafico
local lMudaCor := .t.
local nTipoGraph := 2
local nCorDefault := 1
local aDados := {{"Valor 1", 100}, {"Valor 2", 500},{"Valor 3", 1000}}
local aStru := {}
local cArquivo := CriaTrab(,.f.)
local i

If MsgYesNo("Deseja exibir o grafico com os dados do array?")
   // O grafico sera montado a partir dos dados do array aDados
   MatGraph("Graficos",lGraph3D,lMenuGraph,lMudaCor,nTipoGraph,nCorDefault,aDados)
Else
 aStru := { {"EixoX", "C", 20, 0}, {"EixoY", "N", 8, 2} }
 dbCreate(cArquivo,aStru)
 dbUseArea(.T.,,cArquivo,"GRAFICO",.F.,.F.)
 For i:=1 to Len(aDados)
   ("GRAFICO")->( dbAppend() )
   ("GRAFICO")->(EixoX) := aDados[i][1]
   ("GRAFICO")->(EixoY) := aDados[i][2]
 Next i

 // O grafico sera montado a partir dos dados da area de trabalho "GRAFICO"
 MatGraph("Graficos", lGraph3D, lMenuGraph, lMudaCor, nTipoGraph, nCorDefault,,"GRAFICO",{"EixoX","EixoY"})
 ("GRAFICO")->( dbCloseArea() )
 EndIf
Return

*/
 /*
User function fgraperd()

local lGraph3D := .T. // .F. Grafico 2 dimensoes - .T. Grafico 3 dimensoes
local lMenuGraph := .T. // .F. Nao exibe menu - .T. Exibe menu para mudar o tipo de grafico
local lMudaCor := .T.
local nTipoGraph := 2
local nCorDefault := 1
local aDados:={}


DataI:= '20140401' //dtos(MV_PAR01) 
DataF:= '20140430' //dtos(MV_PAR02)

cQuery:="SELECT  TOP 10  H6_MOTIVO MOTIVO , "
cQuery+="DESCRI=X5_DESCRI, "
cQuery+="PERDA=SUM(H6_QTDPERD) "
cQuery+="FROM SH6020 SH6 , SX5020 SX5 "
cQuery+="WHERE "
cQuery+="H6_DATAINI BETWEEN '"+DataI+"' AND '"+DataF+"' "
cQuery+="AND X5_FILIAL=H6_FILIAL "
cQuery+="AND X5_TABELA='44'  "
cQuery+="AND H6_MOTIVO=X5_CHAVE  "
cQuery+="AND SH6.D_E_L_E_T_ = ' ' "
cQuery+="AND SX5.D_E_L_E_T_ = ' '  "
cQuery+="GROUP BY H6_MOTIVO,X5_DESCRI "
cQuery+="ORDER BY PERDA DESC  "

TCQUERY cQuery NEW ALIAS "SH6X"

//nTotal:=fTotal()

SH6X->( DBGoTop() )

Do While ! SH6X->( Eof() )  
    AADD(aDados, { SH6X->DESCRI, SH6X->PERDA})
    SH6X->( DBskip() )
Enddo
 SH6X->( dbCloseArea() )    

If MsgYesNo("Deseja exibir o grafico com os dados do array?") 
 // O grafico sera montado a partir dos dados da area de trabalho "GRAFICO"
   MatGraph("Graficos",lGraph3D,lMenuGraph,lMudaCor,nTipoGraph,nCorDefault,aDados)
endif

Return

   */