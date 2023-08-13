#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "MSGRAPHI.CH"
        
* /// *      ___________________________________________________________
* /// *     / Funcao    | Gráfico                | Data | 21/12/2009    \
* /// * 	|___________|________________________|______|_______________|
* /// *     | Autor     | RUBEM DUARTE OLIOTA                           |
* /// *     |___________|_______________________________________________|
* /// *     | Uso       | Lindenberg                                    |
* /// *     \___________|_______________________________________________/
user function ESTR002() 
   
Local aGRAFC:={;
               "Extrusao"   ,;
               "Corte Solda" ;
              }  
Local cTit:=""

IF Pergunte("ESTR02", .T.)
  cTit     :=aGRAFC[mv_par01]  
  nVisual  :=mv_par01 
  
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

@ nTop+=10, nLeft+=5    SAY "De  : "          +transform(mv_par02,"@E 99/99/99")      OF oDlg                                    PIXEL
@ nTop+=10, nLeft       SAY "Ate :"           +transform(mv_par03,"@E 99/99/99")      OF oDlg                                    PIXEL
@ nTop+= 5, nLeft-4     SAY replicate("_",16)                                         OF oDlg                                    PIXEL
@ nTop+=10, nLeft       SAY "Apara %"                                                 OF oDlg   COLOR CLR_HBLUE    FONT oBold    PIXEL
@ nTop+=10, nLeft       SAY "Apara % Total"                                           OF oDlg   COLOR CLR_RED      FONT oBold    PIXEL
oGroup:= tGroup()       :New(nLegenda,nLeft-=5,nTop+=10,50,"Legenda",oDlg,CLR_GREEN,,.T.) 

//@ nTop+=10, nLeft SAY alltrim(str(nTri))+"ª Trimestre %"                      OF oGroup   COLOR CLR_HRED    FONT oBold PIXEL
//@ nTop+=10, nLeft SAY "De  : "     +transform(mv_par03,"@E 31/12/99")         OF oGroup                     FONT oBold PIXEL
//@ nTop+=10, nLeft SAY "Ate : "     +transform(stod(intervalo2),"@E 31/12/99") OF oGroup                     FONT oBold PIXEL



DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP    oBmp RESNAME "ProjetoAP" oF oDlg SIZE 50, 270 NOBORDER WHEN .F. PIXEL

@ -07, 050 MSGRAPHIC oGraphic SIZE 465, 280   OF oDlg PIXEL
     
oGraphic:SetTitle("Grafico : " + cTit,"",CLR_GREEN,3,.F.)
//oGraphic:SetMargins( 0, 6, 6, 6 )
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posição x,y em relação a Dialog 


// Habilita a legenda, apenas se houver mais de uma serie de dados.
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
nSerie   := oGraphic:CreateSerie(nTipo,,2)
nSerie2  := oGraphic:CreateSerie(nTipo,,2)

cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )
 

cQuery := "SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQuery += "WHERE Z00.Z00_DATA >= '" + Dtos( mv_par02 ) + "' AND Z00.Z00_DATA <= '" + Dtos( mv_par03 + 1 ) + "' AND "
cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery += "AND Z00.Z00_MAQ!='XXX' " // COLOCADO EM 03/06/09 
cQuery += "ORDER BY Z00.Z00_MAQ "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"

TCSetField( 'Z00X', "Z00_DATA", "D" )
 
nTQTDKG1   := nTQTDKG2   := nTQTDKG3   := 0
nTQTDMR1   := nTQTDMR2   := nTQTDMR3   := 0
nTAPARA1   := nTAPARA2   := nTAPARA3   := 0

Z00X->( DBGoTop() )

mPag := 1



aResultEX 	:= {}
aResultPI 	:= {}
aResultCS	:= {}


If nSerie != GRP_CREATE_ERR .And. nSerie2 != GRP_CREATE_ERR
            
      
Do While ! Z00X->( Eof() )  
            

 If !EMPTY(Z00X->Z00_MAQ) .AND. !(alltrim(Z00X->Z00_MAQ) $ 'EXT/COST')

 	cMAQ    := Z00X->Z00_MAQ 
 	
 	nQTDKG  := 0
 	nAPARA  := 0
 	nOP     := 0
	ntop	:= 0   
	
 	aOP     := {}
 
  
 	Do While ! Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMAQ
 	
 		lOP := .F.
 		If Z00X->Z00_APARA == " " //se nao produzir apara
 		   	If Z00X->Z00_DATA <= mv_par03 .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 )  .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 ) ; 
 		   	   .OR.; 
 		       Z00X->Z00_DATA <= mv_par03 .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 );
 			   .OR. ;
 			  ( Z00X->Z00_DATA <= mv_par03 .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) );
 			   .OR. ;
 	  		  ( Z00X->Z00_DATA >= mv_par02 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
 	  		 	
 		    	nQTDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 				lOP := .T.
 			 
 			EndIf
        ElseIf Alltrim(Z00X->Z00_APARA) # "" .and. Z00X->Z00_APARA != "W" //"12" //checa se apara possui 1 ou 2, caso produza refugo
 		 	If Z00X->Z00_DATA <= mv_par03 .and. Z00X->Z00_HORA >= Left( cTURNO1_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1_A, 5 ) + ":00", SubStr( cTURNO1_A, 7, 5 ) + ":00" ), 5 ) ;
 			.or.;
 			Z00X->Z00_DATA <= mv_par03 .and. Z00X->Z00_HORA >= Left( cTURNO2_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2_A, 5 ) + ":00", SubStr( cTURNO2_A, 7, 5 ) + ":00" ), 5 );
 		  	.or.;
 		  	 ( Z00X->Z00_DATA <= mv_par03 .and. Z00X->Z00_HORA >= Left( cTURNO3_A, 5 ) );
 		  	  .or. ;
 		 	 ( Z00X->Z00_DATA >= mv_par02 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3_A, 5 ) + ":00", SubStr( cTURNO3_A, 7, 5 ) + ":00" ), 5 ) )
 		 	   
 		 	nAPARA  += Z00X->Z00_PESO
 			 
 	   		EndIf
 		EndIf
 		If lOP .and. Ascan( aOP, Z00X->Z00_OP ) == 0   //caso nao haja correspondeica no array
 		 	Aadd( aOP, Z00X->Z00_OP )
 		 	nTOP++
			nOP++
 		EndIf
 		Z00X->( DbSkip() )
 	EndDo 
 	
    if(nVisual==1) //Extrusão 
       IF Alltrim(cMAQ) $ "E01 /E02 /E03 /E04 /E05 /E06 /E07 /E08 /E09 /E10 "	
	   Aadd (aResultEX, {cMAQ,nQTDKG, nAPARA})
	   ENDIF 
	endif  
	
     if(nVisual==2) //Corte Solda , Picotadeiras e Sacoleira
	    IF Alltrim(cMAQ) $ "C01 /C02 /C03 /C04 /C05 /C06 /C07 /C08 /C09 /C10 /C11 /C12 /C13 /C14 /P01 /P02 /P03 /P04 /P05 /P06 /P07 /S01 "	
	    Aadd (aResultCS, {cMAQ,nQTDKG, nAPARA}) 
        ENDIF 
    endif
	

/*Novo a partir daqui*/
 
 Else	
   Z00X->( DbSkip() )
    
 Endif
Enddo
 
  if nVisual == 1 
   	If Len(aResultEX) > 0
      nTOTAL := nTotAPEX  := 0
	  If nSerie != GRP_CREATE_ERR  .And. nSerie2 != GRP_CREATE_ERR
	   FOR X := 1 TO Len(aResultEX)
	   oGraphic:Add(nSerie    ,(( aResultEX[X,3] ) / ( aResultEX[X,2] + aResultEX[X,3] )) * 100     ,aResultEX[X,1]  ,CLR_HBLUE  )
	 	nTotAPEX  += aResultEX[X,3]
	    NEXT  
	    nTOTAL :=nTotAPEX  
   	  for x:=1 to len(aResultEX) 
   	  oGraphic:Add(nSerie2   ,((aResultEX[X,3]) / ( nTOTAL ))*100     ,aResultEX[X,1] ,CLR_RED )
   	  next 
  endif 
 endif
EndIf
  
if nVisual == 2 
   	If Len(aResultCS) > 0
      nTOTAL := nTotAPEX  := 0
	  If nSerie != GRP_CREATE_ERR  .And. nSerie2 != GRP_CREATE_ERR
	   FOR X := 1 TO Len(aResultCS)
	   oGraphic:Add(nSerie    ,(( aResultCS[X,3] ) / ( aResultCS[X,2] + aResultCS[X,3] )) * 100     ,aResultCS[X,1]  ,CLR_HBLUE  )
	 	nTotAPEX  += aResultCS[X,3]
	    NEXT  
	    nTOTAL :=nTotAPEX 
   	  for x:=1 to len(aResultCS) 
   	  oGraphic:Add(nSerie2   ,((aResultCS[X,3]) / ( nTOTAL ))*100     ,aResultCS[X,1] ,CLR_RED )
   	  next 
  endif 
 endif
EndIf



  oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_AUTO,.F.)


Else
	IW_MSGBOX("Extrusão","Corte Solda","STOP") //"Não foi possível criar a série."
Endif
                             
oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( "%"      ,"", CLR_GREEN  , A_LEFTJUST , GRP_TITLE )
oGraphic:SetTitle( "MAQUINAS","", CLR_GREEN  , A_CENTER , GRP_FOOT  )

 
ACTIVATE MSDIALOG oDlg //CENTER
RestArea(aArea)

Return Nil