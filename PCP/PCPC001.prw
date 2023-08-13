#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :04/12/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*************

User Function PCPC001()

*************
aRotina1 :={{"Periodo","U_PCPR001", 0, 6},;
            {"Extrusor","U_PCPR003", 0, 6},;
            {"Maquina","U_PCPR004", 0, 6},;
            {"Grama Metro","U_PCPR002", 0, 6}}
           

aRotina := {{"Pesquisar" , "AxPesqui"  , 0, 1},;
            {"Visualizar", "U_CADGRAMA(2)", 0, 2},;
            {"Incluir"   , "U_CADGRAMA(3)", 0, 3},;
            {"Alterar"   , "U_CADGRAMA(4)", 0, 4},;
            {"Imprimir"   , aRotina1, 0, 6},;
            {"Excluir"   , "U_CADGRAMA(5)", 0, 5} }
            
cCadastro := OemToAnsi("Cadastro de Acompanhamento Grama metro")

DbSelectArea("Z44")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "Z44",,,,,, )



Return 

*************

User Function CADGRAMA(nOpcX)

*************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
LOCAL nRecno:=Z44->(RecNo())
Private nOpc   := nOpcX
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private noBrw1  := 0
Private cPerio  := Space(6)

Private Inclui	:= .F.
Private Altera	:= .F.
Private Exclui	:= .F.
Private Visual	:= .F.

Public cPesErr:=0 

Do Case
	Case nOpc = 2
		Visual 	:= .T.
	Case nOpc = 3
		Inclui 	:= .T.
		Altera 	:= .F.
	Case nOpc = 4
		Inclui 	:= .F.
		Altera 	:= .T.
	Case nOpc = 5
		Exclui	:= .T.
		Visual	:= .T.
EndCase



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oGet1","oGrp2","oBrw1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 126,254,506,993,"Acompanhamento Grama metro ",,,.F.,,,,,,.T.,,,.F. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||OkEnch()},{||Fecha()},.F.,{})}

oGrp1      := TGroup():New( 016,004,052,363,"Amostras de Extrusao  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 032,014,{||"Periodo (MM)/(YYYY) :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oGet1      := TGet():New( 031,076,{|u| If(PCount()>0,cPerio:=u,cPerio)},oGrp1,036,008,'@R 99/9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPerio",,)
oGet1:bValid := {||NaoVazio().AND.JaExi().AND.ValMes()}
oGrp2      := TGroup():New( 056,004,168,364,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(065,008,155,356,if(Visual.or.Exclui, Nil,GD_INSERT+GD_DELETE+GD_UPDATE),'AllwaysTrue()','AllwaysTrue()','',,0,999,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )
//Guarda as posicoes dos campos no aHeader 
nPosMaq  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_MAQ"})
nPosExt  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_EXTRUS"})
nPosMet  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_METROS"})
nPosPes  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_PESO"})
nPosDia  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_DIA"})
nPosOP   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_OP"})
nPosProd := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_PROD"})
nPosDen  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_DENSID"})
nPosLar  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_LARGUR"})
nPosEsp  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_ESPESS" })
nPosMed  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_MEDIDA"})
nPosErr  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_ERRO" })
nPosPer  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_PERCEN"})
nPosProg := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_PROG" })
nPosCalc := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_CALC"})
nPosReal := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_REAL"})
nPosPesErr := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_PESERR"})
nPosPerOK := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_PEROK"})
nPosERROK := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_ERROK"})
nPosNome := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z44_NOMEXT"})

nPosDel  := Len(aHoBrw1)+1



if nOpc <> 3 
   if nOpc = 4
      oGet1:Disable()
   else
      oGet1:lReadOnly := .T.
   endif 
   cPerio := Z44->Z44_MESANO
   
   DbSelectArea("Z44")
   DbSetOrder(1) 
   Z44->(DbSeek(xFilial("Z44")+cPerio))
      
   while Z44->( !Eof() .And. Z44_FILIAL == xFilial() .and. Z44_MESANO == cPerio )													
	   nQtdeAcols := Len(oBrw1:aCols)
 	   
 	   oBrw1:aCols[nQtdeAcols,nPosMaq]   := Z44->Z44_MAQ
 	   oBrw1:aCols[nQtdeAcols,nPosExt]   := Z44->Z44_EXTRUS
       oBrw1:aCols[nQtdeAcols,nPosMet]   := Z44->Z44_METROS
 	   oBrw1:aCols[nQtdeAcols,nPosPes]   := Z44->Z44_PESO
 	   oBrw1:aCols[nQtdeAcols,nPosDia]   := Z44->Z44_DIA
 	   oBrw1:aCols[nQtdeAcols,nPosOP ]   := Z44->Z44_OP
 	   oBrw1:aCols[nQtdeAcols,nPosProd]  := Z44->Z44_PROD
 	   oBrw1:aCols[nQtdeAcols,nPosDen]   := Z44->Z44_DENSID 	   
 	   oBrw1:aCols[nQtdeAcols,nPosLar ]  := Z44->Z44_LARGUR
 	   oBrw1:aCols[nQtdeAcols,nPosEsp ]  := Z44->Z44_ESPESS
 	   oBrw1:aCols[nQtdeAcols,nPosMed ]  := Z44->Z44_MEDIDA
 	   oBrw1:aCols[nQtdeAcols,nPosErr ]  := (Z44->Z44_LARGUR-Z44->Z44_MEDIDA)*-1
 	   oBrw1:aCols[nQtdeAcols,nPosPer ]  := ((-(Z44->Z44_LARGUR-Z44->Z44_MEDIDA)*-1)/Z44->Z44_LARGUR)*100
 	   oBrw1:aCols[nQtdeAcols,nPosProg]  := Z44->Z44_PROG
 	   oBrw1:aCols[nQtdeAcols,nPosCalc]  := Z44->Z44_LARGUR*Z44->Z44_ESPESS/10000*Z44->Z44_DENSID*100
 	   oBrw1:aCols[nQtdeAcols,nPosReal]  := Z44->Z44_PESO/Z44->Z44_METROS
 	   oBrw1:aCols[nQtdeAcols,nPosPesErr]:= ((Z44->Z44_LARGUR*Z44->Z44_ESPESS/10000*Z44->Z44_DENSID*100)-(Z44->Z44_PESO/Z44->Z44_METROS))/(Z44->Z44_LARGUR*Z44->Z44_ESPESS/10000*Z44->Z44_DENSID*100)*100
 	   oBrw1:aCols[nQtdeAcols,nPosPerOk]:=iif(((-(Z44->Z44_LARGUR-Z44->Z44_MEDIDA)*-1)/Z44->Z44_LARGUR)*100 != 0,"ATENCAO","OK" ) 
       oBrw1:aCols[nQtdeAcols,nPosErrOk]:=iif(((Z44->Z44_LARGUR*Z44->Z44_ESPESS/10000*Z44->Z44_DENSID*100)-(Z44->Z44_PESO/Z44->Z44_METROS))/(Z44->Z44_LARGUR*Z44->Z44_ESPESS/10000*Z44->Z44_DENSID*100)*100>-2;
                                             .and.((Z44->Z44_LARGUR*Z44->Z44_ESPESS/10000*Z44->Z44_DENSID*100)-(Z44->Z44_PESO/Z44->Z44_METROS))/(Z44->Z44_LARGUR*Z44->Z44_ESPESS/10000*Z44->Z44_DENSID*100)*100<2,"OK","ATENCAO")
 	   
 	   oBrw1:aCols[nQtdeAcols,nPosNome]:=Posicione('SRA',1,xFilial("SRA")+Z44->Z44_EXTRUS,"RA_NOME")
 	   
 	   oBrw1:aCols[nQtdeAcols,nPosDel ] := .F.
  	  
  	   Z44->(DbSkip())
      if Z44->( !Eof() .And. Z44_FILIAL == xFilial() .and. Z44_MESANO == cPerio )
		   AAdd(oBrw1:aCols,Array(noBrw1+1))				
	   endif
   enddo
Z44->(DbGoto(nRecno))
endif   



oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: Z44
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

Local cFCols := "Z44_MAQ/Z44_EXTRUS/Z44_METROS/Z44_PESO/Z44_DIA/Z44_OP/Z44_PROD/Z44_DENSID/Z44_LARGUR/Z44_ESPESS/Z44_MEDIDA/Z44_ERRO/Z44_PERCENT/Z44_PROG/Z44_CALC/Z44_REAL/Z44_PESERR/Z44_PEROK/Z44_ERROK/Z44_NOMEXT"

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("Z44")
While !Eof() .and. SX3->X3_ARQUIVO == "Z44"
   If cNivel >= SX3->X3_NIVEL .and. Alltrim(SX3->X3_CAMPO) $ cFCols 
      noBrw1++
      Aadd(aHoBrw1,{Trim(X3Titulo()),;
                 SX3->X3_CAMPO,;
                 SX3->X3_PICTURE,;
                 SX3->X3_TAMANHO,;
                 SX3->X3_DECIMAL,;
                 SX3->X3_VALID,;
                 "",;
                 SX3->X3_TIPO,;
                 "",;
                 "" })
   
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: Z44
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1()

Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.



Return  

***************

Static Function GravMod(cAlias,cAlias1)

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
Z44->(DbSetOrder(1))

If ! INCLUI .And. Z44->(DbSeek(xFilial("Z44")+cPerio))	
	While !Z44->(Eof()) .And. xFilial("Z44")+cPerio == xFilial("Z44")+Z44->Z44_MESANO
		Aadd(aAnterior1,Z44->(RecNo()))
		Z44->(dbSkip())
	Enddo
Endif

dbSelectArea("Z44")
nItem := 1

nMaxArray := Len(oBrw1:aCols)

For nCampos := 1 to nMaxArray
	If Len(aAnterior1) >= nCampos
		If ! INCLUI
			DbGoto(aAnterior1[nCampos])
		EndIf
		RecLock("Z44",.F.)
	Else
		RecLock("Z44",.T.)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tem marcacao para apagar.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oBrw1:aCols[nCampos][Len(oBrw1:aCols[nCampos])]
		RecLock("Z44",.F.,.T.)
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
	    Replace Z44_FILIAL with xFilial("Z44")
	    Replace Z44_MESANO with cPerio
	Endif	
	
Next nCampos  


Return 

***************

Static Function ExcArq()

***************

if nOpc == 5		
   DbSelectArea("Z44")
   DbSetOrder(1) 
   Z44->(DbSeek(xFilial("Z44")+cPerio))
      
   while Z44->( !Eof() .And. Z44_FILIAL == xFilial() .and. Z44_MESANO == cPerio )													
     RecLock("Z44",.F.)
     Z44->(DbDelete())
     Z44->(DbSkip())
   Enddo
endif   

Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ OkEnch()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
***************

Static Function OkEnch()

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

if !TudoOk(@oBrw1)
   Return .F.
endif

begin transaction
   if nOpc == 3
      GravMod()
   elseif nOpc == 4
      GravMod()
   elseif nOpc == 5		
      ExcArq()
   endif
end transaction

oDlg1:End()

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Fecha()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

***************

Static Function Fecha()

***************

if nOpc = 3
   RollBackSX8()
endif   

oDlg1:End()

Return

***************

Static Function JaExi()

***************

If nOpc==3
	DbSelectArea("Z44")
	DbSetOrder(1)
	IF Z44->(DbSeek(xFilial("Z44")+cPerio))
		alert("Ja existe Cadastro desse Periodo( "+transform(cPerio,"@E 99/9999")+" )")
		Return .F.
	Endif
endif

Return .T.

***************

Static Function ValMes()

***************

if nOpc==3
	if val(substr(cPerio,1,2))>12
		Alert("O Mes( "+substr(cPerio,1,2)+" ) nao existe!!!")
		Return .F.
	Endif
endif
Return .T.

***************

Static Function TudoOk(oBrw)

***************


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

RestArea(aArea)

Return lOk


***************

User Function DataOk(cDia)

***************

cDia:=Strzero( Val( Alltrim( cDia ) ), 2 )
oBrw1:aCols[n,nPosDia]:=cDia

if Alltrim(Dtos(StoD(substr(cPerio,3,4)+substr(cPerio,1,2)+cDia))) =''
   Alert("O Dia( "+cDia+" ) nao e valido para este mes( "+substr(cPerio,1,2)+" )")
   Return .F.
Endif

Return  .T.

***************

User Function OPOk(cOP)

***************

DbSelectArea("SC2")
DbSetOrder(1)
If SC2->(Dbseek(xFilial("SC2")+cOP))
	DbSelectArea("SB5")
	DbSetOrder(1)
	If SB5->(Dbseek(xFilial("SB5")+SC2->C2_PRODUTO))
		
		oBrw1:aCols[n,nPosProd]  := SB5->B5_COD
		oBrw1:aCols[n,nPosDen]   := round(SB5->B5_DENSIDA,3)
		oBrw1:aCols[n,nPosLar ]  := iif(alltrim(oBrw1:aCols[n,nPosMaq])$'01/02',2*LagFil(cOP),LagFil(cOP)) 
		oBrw1:aCols[n,nPosEsp ]  := SB5->B5_ESPESS*10000
		oBrw1:aCols[n,nPosErr ]  := (oBrw1:aCols[n,nPosLar]-oBrw1:aCols[n,nPosMed])*-1
		oBrw1:aCols[n,nPosPer ]  := (-oBrw1:aCols[n,nPosErr ]/oBrw1:aCols[n,nPosLar])*100
		oBrw1:aCols[n,nPosCalc]  := oBrw1:aCols[n,nPosLar]*oBrw1:aCols[n,nPosEsp ]/10000*oBrw1:aCols[n,nPosDen]*100
		oBrw1:aCols[n,nPosReal]  := oBrw1:aCols[n,nPosPes]/oBrw1:aCols[n,nPosMed]
		oBrw1:aCols[n,nPosPesErr]:= ((oBrw1:aCols[n,nPosCalc]-oBrw1:aCols[n,nPosReal])/oBrw1:aCols[n,nPosCalc])*100
		oBrw1:aCols[n,nPosPerOk]:=iif(oBrw1:aCols[n,nPosPer ]!=0,"ATENCAO","OK" )
		oBrw1:aCols[n,nPosErrOk]:=iif(oBrw1:aCols[n,nPosPesErr]>-2 .and. oBrw1:aCols[n,nPosPesErr]<2,"OK","ATENCAO" )
		
	Endif
Else
    alert("OP invalida!!!")
    Return .F.
Endif

oBrw1:oBrowse:Refresh()

dbselectarea("SB5")

Return .T.

***************

User Function CalculoOk(nOpc)

***************

if nOpc==1 //METROS
   oBrw1:aCols[n,nPosErr ]  := (oBrw1:aCols[n,nPosLar]-oBrw1:aCols[n,nPosMed])*-1
   oBrw1:aCols[n,nPosPer ]  := (-oBrw1:aCols[n,nPosErr ]/oBrw1:aCols[n,nPosLar])*100
   oBrw1:aCols[n,nPosCalc]  := oBrw1:aCols[n,nPosLar]*oBrw1:aCols[n,nPosEsp ]/10000*oBrw1:aCols[n,nPosDen]*100
   oBrw1:aCols[n,nPosReal]  := oBrw1:aCols[n,nPosPes]/M->Z44_METROS
   oBrw1:aCols[n,nPosPesErr]:= (oBrw1:aCols[n,nPosCalc]-oBrw1:aCols[n,nPosReal])/oBrw1:aCols[n,nPosCalc]*100	                                                                                                   
   oBrw1:aCols[n,nPosPerOk]:=iif(oBrw1:aCols[n,nPosPer ]!=0,"ATENCAO","OK" )
   oBrw1:aCols[n,nPosErrOk]:=iif(oBrw1:aCols[n,nPosPesErr]>-2 .and. oBrw1:aCols[n,nPosPesErr]<2,"OK","ATENCAO" )
elseif nOpc==2 //PESO
   oBrw1:aCols[n,nPosErr ]  := (oBrw1:aCols[n,nPosLar]-oBrw1:aCols[n,nPosMed])*-1
   oBrw1:aCols[n,nPosPer ]  := (-oBrw1:aCols[n,nPosErr ]/oBrw1:aCols[n,nPosLar])*100
   oBrw1:aCols[n,nPosCalc]  := oBrw1:aCols[n,nPosLar]*oBrw1:aCols[n,nPosEsp ]/10000*oBrw1:aCols[n,nPosDen]*100
   oBrw1:aCols[n,nPosReal]  := M->Z44_PESO/oBrw1:aCols[n,nPosMet]
   oBrw1:aCols[n,nPosPesErr]:= (oBrw1:aCols[n,nPosCalc]-oBrw1:aCols[n,nPosReal])/oBrw1:aCols[n,nPosCalc]*100	                                                                                                   
   oBrw1:aCols[n,nPosPerOk]:=iif(oBrw1:aCols[n,nPosPer ]!=0,"ATENCAO","OK" )
   oBrw1:aCols[n,nPosErrOk]:=iif(oBrw1:aCols[n,nPosPesErr]>-2 .and. oBrw1:aCols[n,nPosPesErr]<2,"OK","ATENCAO" )
elseif nOpc==3 //DENSIDADE 
   oBrw1:aCols[n,nPosErr ]  := (oBrw1:aCols[n,nPosLar]-oBrw1:aCols[n,nPosMed])*-1
   oBrw1:aCols[n,nPosPer ]  := (-oBrw1:aCols[n,nPosErr ]/oBrw1:aCols[n,nPosLar])*100
   oBrw1:aCols[n,nPosCalc]  := oBrw1:aCols[n,nPosLar]*oBrw1:aCols[n,nPosEsp ]/10000*M->Z44_DENSID*100
   oBrw1:aCols[n,nPosReal]  := oBrw1:aCols[n,nPosPes]/oBrw1:aCols[n,nPosMet]
   oBrw1:aCols[n,nPosPesErr]:= (oBrw1:aCols[n,nPosCalc]-oBrw1:aCols[n,nPosReal])/oBrw1:aCols[n,nPosCalc]*100	                                                                                                   
   oBrw1:aCols[n,nPosPerOk]:=iif(oBrw1:aCols[n,nPosPer ]!=0,"ATENCAO","OK" )
   oBrw1:aCols[n,nPosErrOk]:=iif(oBrw1:aCols[n,nPosPesErr]>-2 .and. oBrw1:aCols[n,nPosPesErr]<2,"OK","ATENCAO" )
elseif nOpc==4 //LARGURA
   oBrw1:aCols[n,nPosErr ]  := (M->Z44_LARGUR-oBrw1:aCols[n,nPosMed])*-1
   oBrw1:aCols[n,nPosPer ]  := (-oBrw1:aCols[n,nPosErr ]/M->Z44_LARGUR)*100
   oBrw1:aCols[n,nPosCalc]  := M->Z44_LARGUR*oBrw1:aCols[n,nPosEsp ]/10000*oBrw1:aCols[n,nPosDen]*100
   oBrw1:aCols[n,nPosReal]  := oBrw1:aCols[n,nPosPes]/oBrw1:aCols[n,nPosMet]
   oBrw1:aCols[n,nPosPesErr]:= (oBrw1:aCols[n,nPosCalc]-oBrw1:aCols[n,nPosReal])/oBrw1:aCols[n,nPosCalc]*100	                                                                                                   
   oBrw1:aCols[n,nPosPerOk]:=iif(oBrw1:aCols[n,nPosPer ]!=0,"ATENCAO","OK" )
   oBrw1:aCols[n,nPosErrOk]:=iif(oBrw1:aCols[n,nPosPesErr]>-2 .and. oBrw1:aCols[n,nPosPesErr]<2,"OK","ATENCAO" )
elseif nOpc==5 //ESPESSURA
   oBrw1:aCols[n,nPosErr ]  := (oBrw1:aCols[n,nPosLar]-oBrw1:aCols[n,nPosMed])*-1
   oBrw1:aCols[n,nPosPer ]  := (-oBrw1:aCols[n,nPosErr ]/oBrw1:aCols[n,nPosLar])*100
   oBrw1:aCols[n,nPosCalc]  := oBrw1:aCols[n,nPosLar]*M->Z44_ESPESS/10000*oBrw1:aCols[n,nPosDen]*100
   oBrw1:aCols[n,nPosReal]  := oBrw1:aCols[n,nPosPes]/oBrw1:aCols[n,nPosMet]
   oBrw1:aCols[n,nPosPesErr]:= (oBrw1:aCols[n,nPosCalc]-oBrw1:aCols[n,nPosReal])/oBrw1:aCols[n,nPosCalc]*100	                                                                                                   
   oBrw1:aCols[n,nPosPerOk]:=iif(oBrw1:aCols[n,nPosPer ]!=0,"ATENCAO","OK" )
   oBrw1:aCols[n,nPosErrOk]:=iif(oBrw1:aCols[n,nPosPesErr]>-2 .and. oBrw1:aCols[n,nPosPesErr]<2,"OK","ATENCAO" )
elseif nOpc==6 //MEDIDA
   oBrw1:aCols[n,nPosErr ]  := (oBrw1:aCols[n,nPosLar]-M->Z44_MEDIDA)*-1
   oBrw1:aCols[n,nPosPer ]  := (-oBrw1:aCols[n,nPosErr ]/oBrw1:aCols[n,nPosLar])*100
   oBrw1:aCols[n,nPosCalc]  := oBrw1:aCols[n,nPosLar]*oBrw1:aCols[n,nPosEsp ]/10000*oBrw1:aCols[n,nPosDen]*100
   oBrw1:aCols[n,nPosReal]  := oBrw1:aCols[n,nPosPes]/oBrw1:aCols[n,nPosMet]
   oBrw1:aCols[n,nPosPesErr]:= (oBrw1:aCols[n,nPosCalc]-oBrw1:aCols[n,nPosReal])/oBrw1:aCols[n,nPosCalc]*100	                                                                                                   
   oBrw1:aCols[n,nPosPerOk]:=iif(oBrw1:aCols[n,nPosPer ]!=0,"ATENCAO","OK" )
   oBrw1:aCols[n,nPosErrOk]:=iif(oBrw1:aCols[n,nPosPesErr]>-2 .and. oBrw1:aCols[n,nPosPesErr]<2,"OK","ATENCAO" )
endif
oBrw1:oBrowse:Refresh() 	   

Return .T.


***************

User Function MaqOK(cMaq)   

***************

If !empty(oBrw1:aCols[n,nPosOP ])
   oBrw1:aCols[n,nPosLar ]  := iif(alltrim(cMaq)$'01/02',2*LagFil(oBrw1:aCols[n,nPosOP ]),LagFil(oBrw1:aCols[n,nPosOP ])) 
Endif

DbselectArea("Z44")

Return .T.


***************

Static Function LagFil(cNOP)

***************

Local cQry:=''
Local nLarFil:=0

cQry:="SELECT B5_LARGFIL,C2_NUM " 
cQry+="FROM  "+RetSqlName("SC2")+" SC2, "+RetSqlName("SB5")+" SB5, "+RetSqlName("SB1")+" SB1 " 
cQry+="WHERE C2_NUM = '"+cNOP+"' " 
cQry+="AND ( ( C2_SEQPAI =('001') "
cQry+="AND SUBSTRING(C2_PRODUTO,1,2) = 'PI') ) "
cQry+="AND B5_COD = C2_PRODUTO AND B1_COD = B5_COD "
cQry+="AND SC2.D_E_L_E_T_ = '' AND SB5.D_E_L_E_T_ = '' "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="ORDER BY C2_NUM, C2_SEQPAI "

TCQUERY cQry NEW ALIAS "SB5X"

If SB5X->( !EOF() )
   nLarFil:=SB5X->B5_LARGFIL
Endif

SB5X->( dbCloseArea() )

Return nLarFil 
