#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "MSGRAPHI.CH"  
// grafico de linha dinamico
* /// *      ___________________________________________________________
* /// *     / Funcao    | Gráfico                | Data | 21/12/2009    \
* /// * 	|___________|________________________|______|_______________|
* /// *     | Autor     | RUBEM DUARTE OLIOTA                           |
* /// *     |___________|_______________________________________________|
* /// *     | Uso       | Lindenberg                                    |
* /// *     \___________|_______________________________________________/ 

User function COMR003()  

Local aGRAFC:={;
               "Extrusao"   ,;
               "Corte Solda" ;
              }  
Local cTit:=""
 public oSay1 
IF Pergunte("COMR003", .T.) 
  aTipo:={1,4}
  cTit    :="MATERIA  PRIMA "//aGRAFC[mv_par01]  
  nTipo   :=aTipo[mv_par03] 
  MsAguarde( { || MontaGrafico(nTipo,1,cTit) }, "Aguarde. . .", "Montando o Gráfico ..." )  
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
If oMainWnd:nClientWidth < 1100
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


  @ nTop+=10, nLeft+=5    SAY "De  : "          +transform(mv_par01,"@E 99/99/99")      OF oDlg    PIXEL
  @ nTop+=10, nLeft       SAY "Ate :"           +transform(mv_par02,"@E 99/99/99")      OF oDlg    PIXEL
//@ nTop+= 5, nLeft-4     SAY replicate("_",16)                                         OF oDlg    PIXEL

oGroup:= tGroup()       :New(nLegenda,nLeft-=5,nTop+=10,50,"Legenda",oDlg,CLR_GREEN,,.T.) 



DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP    oBmp RESNAME "ProjetoAP" oF oDlg SIZE 50, 270 NOBORDER WHEN .F. PIXEL
@ -07, 050 MSGRAPHIC oGraphic SIZE 465, 280   OF oDlg                                PIXEL
oGraphic:SetTitle("Grafico : " + cTit,"",CLR_GREEN,3,.F.)
//oGraphic:SetMargins( 10, 16, 16, 16 )
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posição x,y em relação a Dialog 




cQuery := " select  distinct B1_COD COD ,D1_DTDIGIT DAT  ,D1_VUNIT UNIT "
cQuery += " from SB1010,SD1010  "
cQuery += " where               "
cQuery += "  B1_COD=D1_COD and  "
cQuery += "  D1_TIPO='N'   and  "
cQuery += "  B1_TIPO='MP'  and  "
cQuery += "  D1_DTDIGIT between "
cQuery += "                   "+dtos(mv_par01)+" and "+dtos(mv_par02)+" "
cQuery += "  order by COD , DAT "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"
Z00X->( DBGoTop() )
mPag := 1
aPROD 	:= {}
cCod:=""  





// Habilita a legenda, apenas se houver mais de uma serie de dados.
  oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
//nMaior:=oGraphic:CreateSerie(nTipo,,1)

 
//If nSerie != GRP_CREATE_ERR .And. nSerie2 != GRP_CREATE_ERR
 y:=x:=1          
 cVal:=Z00X->COD 
 aVet:={}    
 
Do While ! Z00X->( Eof() ) 
  Do While  Z00X->COD== cVal
    aadd(aPROD,{Z00X->COD,Z00X->DAT,Z00X->UNIT,x})
    Z00X->( DbSkip() )
       y++
  Enddo 
  aadd(aVet,aPROD[y-1,1])
  cVal:=Z00X->COD
  x++
Enddo   
Z00X->( dbCloseArea() )
aCores :={}
      if nTipo ==1         
       TIPO1(@aCores,@oGraphic)
      else    
       TIPO2(@aCores,@oGraphic)
      // else 
      // TIPO3(@aCores,@oGraphic)    
       endif
 
 
 
 
  
  


    oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_AUTO,.F.)
 
 //	IW_MSGBOX("Extrusão","Corte Solda","STOP")  mensagem ALERT
 
                             
oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( "%"      ,"", CLR_GREEN  , A_LEFTJUST , GRP_TITLE )
oGraphic:SetTitle( "CÓDIGOS","", CLR_GREEN  , A_CENTER , GRP_FOOT  )
    

if nTipo=1
 aItems:={}
 nList:= 1  
 
                               
oList:= tListBox()  :New(nTop+10,nLeft,{|u|if(Pcount()>0,nList:=u,nList)},,50,189,,oDlg,,,,.T.)
 oSay1:= tSay()       :New(nTop,nLeft+10,,oDlg,,,,,,.T.,,,100,20)
 //oSay1:nCLRPANE:=255

 oList:bChange:={||SELECTED(oSay1,oList,aItems,aCores) } 

//cQuery :="select  distinct B1_COD COD"
//cQuery +=" from SB1010,SD1010 "
//cQuery +=" where "
//cQuery +="  B1_COD=D1_COD and  "
//cQuery +="  D1_TIPO='N'   and "
//cQuery +="  B1_TIPO='MP'  and  "
//cQuery +="  D1_DTDIGIT between "+dtos(mv_par01)+" and "+dtos(mv_par02)



cQuery :="select distinct B1_COD COD"//,min(D1_VUNIT) UNIT"           
cQuery +=" from SB1010,SD1010 "
cQuery +=" where            "
cQuery +=" B1_COD=D1_COD and "
cQuery +=" D1_TIPO='N'   and "
cQuery +=" B1_TIPO='MP'  and "
cQuery +="  D1_DTDIGIT between "+dtos(mv_par01)+" and "+dtos(mv_par02)  


//cQuery +=" group by B1_COD "
//cQuery +=" order by UNIT desc "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00A"
//TCSetField( 'Z00X', "Z00_DATA", "D" )
Z00A->( DBGoTop() ) 
Do While ! Z00A->( Eof() ) 
    Aadd(aItems,(Z00A->COD))
    oList:aItems:=aItems
    oList:nAT:=1
    Z00A->( DbSkip() )
 
  Enddo   
Z00A->( dbCloseArea() )     
endif
//@ nTop, nLeft+10    SAY "MP:  "+alltrim(str(oList:nAT))+"/"+alltrim(str(Len(aItems)))     OF oDlg  PIXEL



 
ACTIVATE MSDIALOG oDlg //CENTER
RestArea(aArea)

Return Nil     


***************
Static Function SELECTED(oSay1,oList,aItems,aCores)
***************
if oList:nAT<1
oSay1:cCaption:=""
else  
//ASORT(aCores,,,{|x,y|x>y})
 oSay1:nCLRTEXT:=aCores[oList:nAT]
 oSay1:nCLRPANE:=aCores[oList:nAT] 
oSay1:cCaption:="MP : "+AllTrim(str(oList:nAT))+"/"+alltrim(str(Len(aItems))) 

endif
Return Nil




             


***************
Static Function TIPO1(aCores,oGraphic)
***************


           z:=1
           y:=1  
           
           nCor:=0                
   	If Len(aPROD) > 0
	   FOR X := 1 TO Len(aPROD)     
	   oGraphic:CreateSerie(1,,1)
	       aadd(aCores,(0))
	        while aPROD[x,4] == y .and. x<len(aProd )
              
               oGraphic:Add(y    , aPROD[x,3] ," ",COLOR(y) )  
               aCores[y]:=COLOR(y)
                
               x++ 
               
               if(x==Len(aProd))
               oGraphic:Add(y    , aPROD[x,3] ," ",COLOR(y) )
               aCores[y]:=COLOR(y)
               endif 
              // nCor+=nMudaCor
            enddo 
            
           // z++ 
           // nCor:=255
           // z:=1 
           //  oGraphic:Add(y    , aPROD[x,3] ," ",nCor+=16320 )
          if(aPROD[x,4]!=y)
               x--
               endif
            y++ 
	    NEXT  
 endif
 
 Return Nil



    










***************
Static Function TIPO2(aCores,oGraphic)
***************


nMaior:=0
 z:=1
 y:=1
 nCor:=255
 nMudaCor:=1500
 aPOS:={} 
 nCompleta:=0  
  nTipo:=4      
   	If Len(aPROD) > 0
	 // If nSerie != GRP_CREATE_ERR  .And. nSerie2 != GRP_CREATE_ERR
	   FOR X := 1 TO Len(aPROD)
	        nCompleta:=0  
	        aadd(aCores,(0)) 
	        
	        while aPROD[x,4] == y .and. x<len(aProd )
	           nCompleta:=nCompleta+1 
	           
	           if z > nMaior
                  nMaior:=oGraphic:CreateSerie(nTipo,,1)
                  
               endif    
               nCor:=Color(z)
                 aCores[y]:=nCor
               oGraphic:Add(z    , aPROD[x,3] ,aPROD[x,1],nCor  )
               //aCores[y]:=nCor  
               //alert(; 
               //        "serie: "+alltrim(str(z))+         chr(13) +;
               //        "Vet["   +alltrim(str(x))+"]   "  +chr(13) +;
               //        "COD: "  +alltrim(aPROD[x,1])+"  "+chr(13) +;
               //        "nItens: "  +alltrim(str(nCompleta))+"  "+chr(13) +;
               //        "Val: "  +alltrim(str(aPROD[x,3])))
                  
                aadd(aPOS,(z))
                z++
                x++
                if(x==len(aProd ) ) 
                
                nCompleta:=nCompleta+1 
                   if z > nMaior
                      nMaior:=oGraphic:CreateSerie(nTipo,,1)
                    //  nCor:=Color(x)
                     // nCor+=nMudaCor 
                     nCor:=Color(z)
                 aCores[y]:=nCor
                   endif 
                  oGraphic:Add(z    , aPROD[x,3] ,aPROD[x,1],nCor  )  
                
                
                    
                //alert(; 
                //       "serie: "+alltrim(str(z))+         chr(13) +;
                //       "Vet["   +alltrim(str(x))+"]   "  +chr(13) +;
                //       "COD: "  +alltrim(aPROD[x,1])+"  "+chr(13) +;
                //       "nItens: "  +alltrim(str(nCompleta))+"  "+chr(13) +;
                //       "Val: "  +alltrim(str(aPROD[x,3])))       
                     
                 aadd(aPOS,(z))
                 
                endif
             enddo 
             while nCompleta< nMaior 
              oGraphic:Add(++nCompleta    ,  0.0  ,"", Color(nCompleta+1)  ) 
             enddo
            z:=1 
            if(aPROD[x,4]!=y)
               x--
               endif
            y++ 
        
	    NEXT  
 endif
Return Nil

******************************
User Function GrafCOLOR(cCORx)
******************************
      aCORx:={0       ,128               ,255       ,32768         ,65280        ,27000            ,65535          ,8388608      ,16711680    ,16711800,16711935,16776960    }//,16777190,16777215}
  aNameCORx:={"PRETO" ,"VERMELHO ESCURO" ,"VERMELHO","VERDE ESCURO","VERDE CLARO","AMARELO ESCURO ","AMARELO CLARO","AZUL ESCURO","AZUL CLARO","LILAS" ,"ROZA"  ,"VERDE AGUA"}//,"PRATA","BRANCO"}
  cCORx:=upper(cCORx)
  nBusca:=ASCAN(aNameCORx,cCORx)
  if nbusca<1
    return 1
  else
    return aCorx[nBusca] 
  endif
return NIL 
             

*****************************
static Function COLOR(nBusca)
*****************************
        aCORx :={0,128,255,32768,65280,27000,65535,8388608,16711680,16711800,16711935,16776960}//,16777190,16777215}
 return aCORx[nBusca%len(aCorx)+1]   