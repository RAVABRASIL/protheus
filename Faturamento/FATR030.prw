#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "MSGRAPHI.CH"

*************

user function FATR030()

*************

Local cQuery := " "
Local nCbx := 1
Local aCbx := {"Barras"}
Local cCbx := aCbx[1]
local oDlg


local cTit:=""
if ! pergunte('FATR030',.T.)
return
endif

aMES := { 'Janeiro', 'Fevereiro', 'Mar�o'   , 'Abril'  , 'Maio'    , 'Junho'   ,;
          'Julho'  , 'Agosto'   , 'Setembro', 'Outubro', 'Novembro', 'Dezembro' }
 
cMES := aMES[   VAL(mv_par01)  ]

cTit:="Atacadao "
nVisual:=1
 
MsAguarde( {|| MontaGrafico(1,nVisual,1,cTit)  }, OemToAnsi( "Aguarde" ), OemToAnsi( "Montando Grafico ..." ) )
//[1]<---4   tipo do grafico   barras 

Return Nil

//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Funcao    �MontaGraf �Autor  �Claudio D. de Souza � Data �  30/08/01   ���
//�������������������������������������������������������������������������͹��
//���Desc.     � Processa os dados necessarios para montagem do grafico e   ���
//���          � exibe o grafico.                                           ���
//���          � cAlias  -> Alias do arquivo temporario que sera processado ���
//���          � nCbx    -> Codigo da serie de dados que sera utilizada pelo���
//���          �            objeto grafico                                  ���
//�������������������������������������������������������������������������͹��
//���Uso       � TMKR004                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

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
Local aAtacado := {}
Local aArrEx := {}
Local aTmp   := {}
 
Local cQry   := cNome   := cMaqi := ''
Local aCores   :={}
Local nTot     :=0
Local cnt      :=0
Local nPercent :=0
Local x        :=0
Local y        :=0
local aPeriodo:={}

//Verifica se a resolu��o de v�deo � menor que 1024x768
If oMainWnd:nClientWidth < 1000
	lVideo := .T.
EndIf

aTabela		:= {;
                {	cTit            ,;
		 			"PROBLEMA"      ,;
		 			"QUANTIDADE"     ;
                };
               } 



cQry:="SELECT * FROM " + RetSqlName("SA1") + " SA1 "
cQry+="WHERE SUBSTRING(A1_CGC,1,8)='75315333' "   
IF !EMPTY(MV_PAR02)
   cQry+="AND A1_COD='"+MV_PAR02+"' "   
END
cQry+="AND SA1.D_E_L_E_T_ = ''  "
cQry+="ORDER BY A1_COD "

TCQUERY cQry NEW ALIAS "TMPZ"

// ultimos 6 meses 
dData := CtoD( '15'+'/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) )
Aadd( aPeriodo, substr(dtos(dData-150),1,6) )   
Aadd( aPeriodo, substr(dtos(dData-120),1,6) )   
Aadd( aPeriodo, substr(dtos(dData-90),1,6)  )   
Aadd( aPeriodo, substr(dtos(dData-60),1,6)  )   
Aadd( aPeriodo, substr(dtos(dData-30),1,6)  )   
Aadd( aPeriodo, substr(dtos(dData),1,6)     )   


TMPZ->(dbGoTop())
If  TMPZ->(!EOF())
	Do While TMPZ->(!EOF())
	   IF !EMPTY(MV_PAR02)
	      Aadd( aAtacado, { TMPZ->A1_COD,{},TMPZ->A1_EST,TMPZ->A1_END } )
	      nIdx  := aScan(aAtacado, {|t| t[1]==TMPZ->A1_COD   } )
	   ELSE
	      Aadd( aAtacado, { 'Geral',{},'','' } )
	      nIdx  := 1
	   ENDIF
	   
	   For _X:=1 TO len(aPeriodo)
	       aFAt:=fat(TMPZ->A1_COD,aPeriodo[_X])
	       Aadd( aAtacado[nIdx][2], {aPeriodo[_X],afat[1][1],afat[1][2]}  ) 
	   Next
	   
	   IF EMPTY(MV_PAR02)
	      EXIT
	   ENDIF
	   
	   TMPZ->(dbskip())
	Enddo
Else
   ALERT(" Esse Codigo nao e um Atacadao!!" )
   TMPZ->(dbclosearea())
   Return Nil
Endif
TMPZ->(dbclosearea())

aSize := MSADVSIZE()

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] PIXEL TITLE "Representa��o gr�fica da Evolu��o Atacadao " 
oDlg:lMaximized := .T.

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

 
@ 05, 50 MSGRAPHIC oGraphic SIZE 450, 330  OF oDlg PIXEL


if !empty(MV_PAR02)
   cTit:="Faturamento - Atacadao - "+aAtacado[1][1]+' - UF:'+aAtacado[1][3]+' - End.:'+aAtacado[1][4]
Else
   cTit:="Faturamento - Atacadao - "+aAtacado[1][1]
endif
oGraphic:SetTitle("Grafico : " + cTit,"",CLR_HBLUE,3,.F.)
oGraphic:SetMargins( 2, 6, 6, 6 )
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posi��o x,y em rela��o a Dialog 

MENU oMenu POPUP
	MENUITEM "Consulta dados do grafico" Action ConsDadGraf(aTabela) //
ENDMENU

 
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
nSerie  := oGraphic:CreateSerie(nCbx,,0)

If nSerie != GRP_CREATE_ERR  

For _Y:=1 to len(aAtacado)    
   For _Z:=1 to len(aAtacado[_Y][2]) 
	  oGraphic:Add(nSerie  ,  (aAtacado[_Y][2][_Z][2])    , aMES[val(substr(aAtacado[_Y][2][_Z][1],5,2))]+'/'+substr(aAtacado[_Y][2][_Z][1],1,4)   ,CLR_GREEN)      
   Next
Next

 
 oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_AUTO,.F.)
Else
	IW_MSGBOX("STR0124","STR0198","STOP") //"N�o foi poss�vel criar a s�rie."
Endif

oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )

oGraphic:SetTitle( "Periodo", "", CLR_GREEN, A_RIGHTJUS , GRP_FOOT  )

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

//��������������������������������������������������������������������������������
//��������������������������������������������������������������������������������
//����������������������������������������������������������������������������Ŀ��
//���Program   � ConsDadGraf � Autor � Wagner Mobile Costa   � Data � 10.11.01 ���
//����������������������������������������������������������������������������Ĵ��
//���Descri��o � Monta Browse de consulta sobre array utilizado para graficos  ���
//�����������������������������������������������������������������������������ٱ�
//��������������������������������������������������������������������������������
//��������������������������������������������������������������������������������

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




***************

Static Function Fat(ccod,cPeriodo)

***************
local cQry:=''
local aret:={}

cQry:="SELECT "
cQry+="SUBSTRING(D2_EMISSAO,1,6) PERIODO, "
IF !EMPTY(MV_PAR02)
   cQry+="A1_COD, "
ENDIF
cQry+="QTD_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 ELSE D2_QUANT * CASE WHEN B1_SETOR='39' THEN 1 ELSE D2_PESO END  END) , "
cQry+="VALOR=SUM(D2_TOTAL) "

cQry+="FROM " + RetSqlName("SD2") + " SD2 WITH (NOLOCK), " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) ," + RetSqlName("SA1") + " SA1 "
cQry+="WHERE SUBSTRING(D2_EMISSAO,1,6) = '"+cPeriodo+"' "
IF !EMPTY(MV_PAR02)
   cQry+="AND A1_COD='"+cCod+"'  "
ENDIF
cQry+="AND D2_CLIENTE+D2_LOJA=A1_COD+A1_LOJA "
cQry+="AND SUBSTRING(A1_CGC,1,8)='75315333' "
cQry+="AND D2_TIPO = 'N' "
cQry+="AND D2_TP != 'AP'  "
cQry+="AND RTRIM(D2_CF) IN ('511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949','6949','5922','6922','5116','6116' )  "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQry+="AND F2_DUPL <> ' '  "
cQry+="AND SF2.D_E_L_E_T_ = '' " 
cQry+="AND SA1.D_E_L_E_T_ = ''  "

IF !EMPTY(MV_PAR02)
   cQry+="GROUP BY SUBSTRING(D2_EMISSAO,1,6),A1_COD  "
   cQry+="ORDER BY A1_COD,PERIODO "
ELSE
   cQry+="GROUP BY SUBSTRING(D2_EMISSAO,1,6)  "
   cQry+="ORDER BY PERIODO "
ENDIF
TCQUERY cQry NEW ALIAS "TMPY"

If TMPY->(!EOF())
   Aadd( aRet, {TMPY->QTD_KG,TMPY->VALOR}  ) 
Else
   Aadd( aRet, {0,0}  ) 
endif

TMPY->(DBCLOSEAREA())

Return aRet

*************

User Function CliAtaca(cCod)

*************
LOCAL cQry:=''

cQry:="SELECT * FROM " + RetSqlName("SA1") + " SA1 "
cQry+="WHERE SUBSTRING(A1_CGC,1,8)='75315333' "   
cQry+="AND A1_COD='"+cCod+"' "   
cQry+="AND SA1.D_E_L_E_T_ = ''  "
cQry+="ORDER BY A1_COD "
TCQUERY cQry NEW ALIAS "TMPA"

If TMPA->( EOF()) .AND. !EMPTY(MV_PAR02)
   ALERT(" Esse Codigo nao e um Atacadao!!" )
   TMPA->(dbclosearea())
   Return .F.
EndIf

TMPA->(dbclosearea())

Return .T.