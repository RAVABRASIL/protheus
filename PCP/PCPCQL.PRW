#include "protheus.ch"
#include "topconn.ch"



*************
USER FUNCTION PCPCQL()
*************            

private oSAY1,oGrp1,oButton,oButton1  
private cStartPath := GetSrvProfString("Startpath","")
private cNameFile	 := "microsiga" 


public aCoBrw1 := {}
public aHoBrw1 := {}
public noBrw1  := 0
public nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
 cStartPath := AjuBarPath(cStartPath)
 cNameFile := cStartPath+cNameFile+".bmp"
	
DEFINE  MSDIALOG oDlg FROM 0,0 TO 690,1017 TITLE "Cadastros Controle de qualidade"         PIXEL
    @ 0,0 BITMAP  SIZE 510,50  FILE /*cNameFile*/"C:\Documents and Settings\rubem\Desktop\Templates\microsiga.bmp"
    
 // oSAY1:= tSAY()       :New(64 ,10,{||":"},oDlg,,,,,,.T.,,,100,20)
  nLin:=40 
  nDiv:=10
  nTab:=-1
  nFim:=120
                       
                @ nLin+=nDiv ,nTab    BUTTON oButton PROMPT "&Corte Solda "     OF oDlg  SIZE 50,10    PIXEL ACTION U_LegPCP(1)   
                @ nLin+2     ,252     BUTTON oButton PROMPT "&Buscar"           OF oDlg  SIZE 35,11    PIXEL ACTION NADA()      
                
                @ nLin+=nDiv ,nTab    BUTTON oButton PROMPT "&Sacoleira   "     OF oDlg  SIZE 50,10    PIXEL ACTION U_LegPCP(2)   
                @ nLin+=nDiv ,nTab    BUTTON oButton PROMPT "&Picotadeira "     OF oDlg  SIZE 50,10    PIXEL ACTION U_LegPCP(3)

                @ nLin+=nDiv ,nTab    BUTTON oButton PROMPT "&Texto       "     OF oDlg  SIZE 50,10    PIXEL ACTION U_PCPR007()
                @ nLin+=nDiv ,nTab    BUTTON oButton1 PROMPT "&Grafico     "    OF oDlg  SIZE 50,10    PIXEL ACTION U_PCPR008()
  oButton1:disable() 
  
                @ nLin+=nDiv ,nTab    BUTTON oButton PROMPT "&Sair        "     OF oDlg  SIZE 50,10    PIXEL ACTION  oDlg:END()
                
oCBox1     := TComboBox():New( 052,051,,,100,012,oDlg,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oGet1      := TGet()     :New( 52,152,,oDlg,100,009,'', ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(065,049,332,512,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg,aHoBrw1,aCoBrw1 )


  ACTIVATE MSDIALOG oDlg //CENTERED
RETURN NIL




*************************
Static Function NADA()
*************************



return




*************************
Static Function MHoBrw1()
*************************

Local cFCols := "/"

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("<INFORM ALIAS>")
While !Eof() .and. SX3->X3_ARQUIVO == "<INFORM ALIAS>"
   If cNivel >= SX3->X3_NIVEL .and. Alltrim(SX3->X3_CAMPO) $ cFCols 
      noBrw1++
      Aadd(aHoBrw1,;
         { Trim(X3Titulo()),;
           X3_CAMPO,;
           X3_PICTURE,;
           X3_TAMANHO,;
           X3_DECIMAL,;
           X3_VALID,;
           X3_USADO,;
           X3_TIPO,;
           X3_ARQUIVO,;
           X3_CONTEXT,;
           X3_NIVEL,;
           X3_RELACAO,;
           Trim(X3_INIBRW) } )
   EndIf
   DbSkip()
End

Return


*************************
Static Function MCoBrw1()
*************************

Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.

Return

// pertencem aos cadastros
//PCPC(003/004/005) 
     
User Function MSG() 
                  
   messageBox(" Utilize somente as Opções :"+chr(13)+;
              " • Cadastros    "+chr(13)+;
              "    -Corte Solda"+chr(13)+;
              "    -Picotadeira"+chr(13)+;
              "    -Sacoleira  "+chr(13)+;
              " • Relatorio    "," Aviso!",1)
 return
 
 
 
*****************************
User Function TURNOOK(cTurno)
//Verifica se o Turno esta entre (  A  B  C  )
*****************************

   cTurno:=upper(cTurno)
if upper(substr(cTurno,1,1)) $ ("A/B/C")
   cTurno:=upper(cTurno)
   return .T.
   else
   
   alert("escolha entre os turnos (A/B/C)")  
   cTurno:=upper(cTurno)
   return .F.
  endif 
return nil           
   
   
   
*************************   
User function DIAOK(cDia)
//Verificar se o Dia é valido
*************************

 local lOK:=.T. 
 cDia:=Strzero( Val( Alltrim( cDia ) ), 2 )
 oBrw1:aCols[n,nDia]:=cDia
 aMES:={;
 "Janeiro" , "Fevereiro" , "Março"    ,;
 "Abril"   , "Maio"      , "Junho"    ,;
 "Julho"   , "Agosto"    , "Setembro" ,;
 "Outubro" , "Novembro"  , "Dezembro" ;
 }    

 if Alltrim(Dtos(StoD(substr(cPerio,3,4)+substr(cPerio,1,2)+cDia))) =''
  lOK:=.F.
 Endif 
  
 if val(substr(cPerio,1,2))%2==0 .and.val(substr(cPerio,1,2))<9 .and. val(cDia)>30
 lOK:=.F.
 endif   

 if(val(substr(cPerio,1,2))%2!=0 .and. val(substr(cPerio,1,2))>9 .and. val(cDia)>30);
   .OR.;
   (val(substr(cPerio,1,2))==2 .and. val(cDia)>29);
   .OR.;
   (val(cDia)<1 .or. val(cDia)>31)
  lOK:=.F.
 endif   
 
 if lOK==.F.
  Alert( "O Dia ( " + cDia + " ) nao e valido para o Mes ( " + aMes[val(substr(cPerio,1,2))] + " )" )
 endif 
return lOK
           
  
************************* 
User function LegPCP(nOp)
//importa legenda especifica para cada programa
************************* 
   

local  ATIVO  := "BR_VERDE"
local INATIVO := "BR_BRANCO"   

do case
case nOp=1  
  aCores := {;
             {"substr (Z49_MAQ,1,2)  $  'C0' "    , ATIVO  },;
	   		 {"substr (Z49_MAQ,1,2)  $  'S0/P0' " , INATIVO} ;
            }                                  
U_PCPC003(aCores) // cadastro Corte Soldas  


case nOp=2  
  aCores := {;
             {"substr (Z49_MAQ,1,2)  $  'S0' "    , ATIVO   },;
	   		 {"substr (Z49_MAQ,1,2)  $  'C0/P0' " , INATIVO} ;
            }
U_PCPC004(aCores) // cadastro Sacoleira  
             

case nOp=3
  aCores := {;
             {"substr (Z49_MAQ,1,2)  $  'P0' "    , ATIVO   },;
	   		 {"substr (Z49_MAQ,1,2)  $  'S0/C0' " , INATIVO} ;
            } 
U_PCPC005(aCores) // cadastro Picotadeiras  

endcase                   



return  


***********************
User Function LegMaq()
//Legenda Comum a todos os cadastros
***********************

Local  ATIVO  := "BR_VERDE"
Local INATIVO := "BR_BRANCO"   
Local aLegenda := {;
                   {  ATIVO ,"Pode alterar"},;
	   			   {INATIVO ,"Não pode alterar"};
	   			  }

BrwLegenda(" M A Q U I N A S ","Legenda",aLegenda)		   		

Return .T.   

                


********************************
User function VAL_MAQ(nMaq,cMaq)// valida a maquina   
********************************
cMaq:=upper(cMaq)   

do case  
  case nMaq =1// CORTE SOLDA
    if upper(substr(cMaq,1,2)) $ ("C0") .and.upper( substr(cMaq,3,1))!='0'
      cMaq:=upper(cMaq)
      return .T.
    else
     alert("Escolha uma Corte Solda")
     cMaq:=upper(cMaq)
     return .F. 
  endif
 
         
  case nMaq = 2 // SACOLEIRA 
   if upper(substr(cMaq,1,2)) $ ("S0") .and.upper( substr(cMaq,3,1))!='0'
     cMaq:=upper(cMaq)
     return .T.
   else
     alert("Somente Sacoleira")
     cMaq:=upper(cMaq)
     return .F. 
  endif
 
           
 
  case nMaq = 3 // PICOTADEIRA
   if upper(substr(cMaq,1,2)) $ ("P0") .and.upper( substr(cMaq,3,1))!='0'
    cMaq:=upper(cMaq)
    return .T.
   else
     alert("Escolha uma Picotadeira")
     cMaq:=upper(cMaq)
     return .F. 
  endif
 
endcase

return Nil             
 
 
**************************
Static Function fTudoOk(oBrw)
**************************


local nX, nY
local lOk := .T.
local aArea := GetArea()
local nItems := 0
DbSelectArea("SX3")
DbSetOrder(2)
for nX := 1 to Len(oBrw:aCols)
   if !oBrw:aCols[nX,Len(oBrw:aHeader)+1] .and. lOk
       nItems++
       for nY := 1 to Len(oBrw:aHeader)
          SX3->(DbSeek(oBrw:aHeader[nY,2]))
          if SX3->X3_OBRIGAT == "€"
             if Empty(oBrw:aCols[nX,nY])
                lOk := .F.
        			 Aviso( "Obrigatorio", "O campo: "+oBrw:aHeader[nY,1]+" não foi preenchido.", {"Ok"})
                Exit
             endif
          endif
       next nY   
   endif
   if !lOk
      Exit
   endif
next nX

if lOk
   if nItems == 0
	   Aviso( "Items", "O Cadastro deverá ter pelo menos um item.", {"Ok"})   
	   lOk := .F.
	endif   
endif

if lOk
   if !U_JaExi()
	   lOk := .F.
	endif   
endif

RestArea(aArea)

Return lOk
 
           
  
  
  
  
***************

User Function ValMes()

***************

if nOpc==3
	if val(substr(cPerio,1,2))>12 .or. val(substr(cPerio,1,2))<1
		Alert("O Mes ( "+substr(cPerio,1,2)+" ) nao existe!!!")
		Return .F.
	Endif
		if val(substr(cPerio,3,4))<1 .or. val(substr(cPerio,1,2))>2999
		Alert("O Ano ( "+substr(cPerio,3,4)+" ) nao é valido!!!")
		Return .F.
	Endif
	
endif
Return .T.
 


***************
User Function Fecha()
***************

 if nOpc = 3
   RollBackSX8()
 endif   
 oDlg1:End()
 
Return
          

***************
User Function JaExi()
***************

If nOpc==3
	DbSelectArea("Z49")
	DbSetOrder(1)
	IF Z49->(DbSeek(xFilial("Z49")+cPerio+cMaq))
		alert("Ja existe Cadastro desse Periodo( "+substr(cPerio,1,2)+"/"+substr(cPerio,3,4)+" ) para a maquina ( "+cMaq+" ) ")
		Return .F.
	Endif
endif

Return .T.  




***************
User Function OkEnch()
***************

local lOk := .T.
Local cCpo:=""

local aCab     := {}
local aItens   := {}
local lGeraPP  := .F.
local nSaveSX8 := GetSX8Len()
Local _nx
Local _ny

if nOpc = 2
   oDlg1:End()
   Return
endif

if nOpc == 3 .or. nOpc == 4
	if Empty(cPerio)
		lOk := .F.
		cCpo := 'Mes/Ano'
	endif
	
	if !lOk
		Aviso( "Obrigatorio", "O campo: "+cCpo+" não foi preenchido.", {"Ok"})
		Return .F.
	endif
	
	if nOpc = 3
		ConfirmSX8()
	endif
endif

if !fTudoOk(@oBrw1)
   Return .F.
endif

begin transaction
   if nOpc == 3
      U_GravMod()
   elseif nOpc == 4
      U_GravMod()
   elseif nOpc == 5		
      U_ExcArq()
   endif
end transaction

oDlg1:End()

Return
 


***************
User Function ExcArq()
***************

if nOpc == 5		
   DbSelectArea("Z49")
   DbSetOrder(1) 
   Z49->(DbSeek(xFilial("Z49")+cPerio+cMaq))
      
   while Z49->( !Eof() .And. Z49_FILIAL == xFilial() .and. Z49_MESANO == cPerio .and. Z49_MAQ == cMaq)													
     RecLock("Z49",.F.)
     Z49->(DbDelete())
     Z49->(DbSkip())
   Enddo
endif   

Return  




User Function GravMod(cAlias,cAlias1)

***************

local lGrava := .T.
Local nLaco
Local nItem:=0
Local lAmostra := .F.
Local cMay
Local nCampos, nHeader, nMaxArray, bCampo, aAnterior:={}, nItem := 1
local aAnterior1:={} 
local aAnterior2:={} 
local aAnterior3:={} 
local aAnterior4:={} 
local aAnterior5:={} 
Local nChaves := 0
Local nSaveSX8Z5:= GetSX8Len()
Local cItem
Local cnt
Local nSoma:=0 
Local lok:=.T.



bCampo := {|nCPO| Field(nCPO) }


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega ja gravados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Z49->(DbSetOrder(1))

If ! INCLUI .And. Z49->(DbSeek(xFilial("Z49")+cPerio+cMaq))	
	While !Z49->(Eof()) .And. xFilial("Z49")+cPerio+cMaq == xFilial("Z49")+Z49->Z49_MESANO + Z49->Z49_MAQ
		Aadd(aAnterior1,Z49->(RecNo()))
		Z49->(dbSkip())
	Enddo
Endif

dbSelectArea("Z49")
nItem := 1

nMaxArray := Len(oBrw1:aCols)

For nCampos := 1 to nMaxArray
	If Len(aAnterior1) >= nCampos
		If ! INCLUI
			DbGoto(aAnterior1[nCampos])
		EndIf
		RecLock("Z49",.F.)
	Else
		RecLock("Z49",.T.)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tem marcacao para apagar.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oBrw1:aCols[nCampos][Len(oBrw1:aCols[nCampos])]
		RecLock("Z49",.F.,.T.)
		dbDelete()
	Else
		For nHeader := 1 to Len(oBrw1:aHeader)
			If oBrw1:aHeader[nHeader][10] # "V" .And. ! "_ITEM" $ AllTrim(oBrw1:aHeader[nHeader][2])
				Replace &(Trim(oBrw1:aHeader[nHeader][2])) With oBrw1:aCols[nCampos][nHeader]
			ElseIf "_ITEM" $ AllTrim(oBrw1:aHeader[nHeader][2])
				Replace &(AllTrim(oBrw1:aHeader[nHeader][2])) With StrZero(Val(Alltrim(oBrw1:aCols[nCampos][nHeader])),;
				                                                          Len(&(AllTrim(oBrw1:aHeader[nHeader][2]))))
			Endif
			  
		Next	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza as chaves de itens ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    Replace Z49_FILIAL with xFilial("Z49")
	    Replace Z49_MESANO with cPerio
	    Replace Z49_MAQ with upper(cMaq)
	Endif	
	
Next nCampos  


Return 
 
 