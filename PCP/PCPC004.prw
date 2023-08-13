#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'

// _______________________________________________________________________
//| Programa  |  PCPC004                                Data: 25/01/2010  |
//|¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
//| Autor     |  Rubem Duarte Oliota	                                  |
//|¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
//| Uso       | Controle de Qualidade                                     |
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

*************
User Function PCPC004(aCores)
*************

  

aRotina := {;
            {"Pesquisar" , "AxPesqui"     , 0, 1},;
            {"Visualizar", "U_CADQLSA(2)" , 0, 2},;
            {"Incluir"   , "U_CADQLSA(3)" , 0, 3},;
            {"Alterar"   , "U_CADQLSA(4)" , 0, 4},;
            {"Imprimir"  , "U_PCPR007"    , 0, 6},;
            ;//{"Legenda", "U_LegMaq()"   , 0, 7},;
            {"Excluir"   , "U_CADQLSA(5)" , 0, 5} ;
           }
            
cCadastro := OemToAnsi("Cadastro Controle de qualidade  SACOLEIRA  ")

DbSelectArea("Z49")
DbSetOrder(1)
               
   Set Filter To Z49->Z49_FILIAL = xFilial("Z49").AND.;
                 substr(Z49->Z49_MAQ,1,2) $ 'S0'  
mBrowse( 06, 01, 22, 75, "Z49",,,,,,aCores )



Return 


USER Function CADQLSA(nOpcX)

*************
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//±± Declaração de Variaveis do Tipo Local, Private e Public             ±±
//ÙÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
LOCAL   nRecno  :=Z49->(RecNo())
Private nOpc    := nOpcX
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private noBrw1  := 0
Private cPerio  := Space(6)
Private cMaq    := Space(3)

Private Inclui	:= .F.
Private Altera	:= .F.
Private Exclui	:= .F.
Private Visual	:= .F.

Public cPesErr  :=0 

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


     
//*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
//±± Declaração de Variaveis Private dos Objetos                           ±±
//Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 
SetPrvt("oDlg1","oGrp1","oSay1","oGet1","oSay2","oGet2","oGrp2","oBrw1")

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±± Definicao do Dialog e todos os seus componentes.                      ±±
//Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oDlg1      := MSDialog():New( 126,254,506,993,"Controle de Qualidade",,,.F.,,,,,,.T.,,,.F. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||U_OkEnch()},{||U_Fecha()},.F.,{})}


                                           

oGrp1        := TGroup():New( 016,004,052,363,"Cabeçalho  ",;
             oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1        := TSay()  :New( 032,014,{||  "Periodo (MM)/(YYYY) :"        },;
             oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oGet1        := TGet()  :New( 031,076,{|u| If(PCount()>0,cPerio:=u,cPerio)},oGrp1,036,008,'@R 99/9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPerio"     ,,)
oGet1:bValid := {|| NaoVazio() .AND. U_JaExi() .AND. U_ValMes() }

oSay2        := TSay()  :New( 032,130,{||  "MAQUINA  :"        },;
             oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008) 
oGet2        := TGet()  :New( 031,170,{|u| If(PCount()>0,cMaq  :=u,cMaq  )},oGrp1,036,008,            ,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",upper("cMaq"),,) 
oGet2:cF3    :="SH1" 
cMaq:=upper(cMaq)
oGet2:bValid := {||NaoVazio() .AND. U_JaExi(cMaq) .AND. U_VAL_MAQ(2,@cMaq) }
cMaq:=upper(cMaq)



MHoBrw1(cMaq)
MCoBrw1(cMaq)

oGrp2      := TGroup():New( 056,004,168,364,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
oBrw1      := MsNewGetDados():New(065,008,155,356,if(Visual.or.Exclui, Nil,GD_INSERT+GD_DELETE+GD_UPDATE),'AllwaysTrue()','AllwaysTrue()','',,0,999,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )    


nDIA     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_DIA"   })// 4    1 // continuar( cMAQ escopo)...
nTURNO   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_TURNO" })// 4    2
nLMAEX   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMAEX" })// 4    3
nLMACS   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMACS" })// 4    4
nLMEEX   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMEEX" })// 4    5
nLMECS   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMECS" })// 4    6
nESPMA   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ESPMA" })// 4    7
nESPME   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ESPME" })// 4    8
nCOMPMA  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_COMPMA"})// 4    9
nCOMPME  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_COMPME"})// 4   10 

nABA     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ABA"   })//  4  11
nAMOSTR  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_AMOSTR"})//  4  12
nALCCOR  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ALCCOR"})//  2  13
nALCFIN  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ALCFIN"})//  2  14
nALCRUI  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ALCRUI"})//  2  15
nBLOCAD  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_BLOCAD"})//  2  16
nALINHA  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ALINHA"})//  2  17
nSLDFRI  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_SLDFRI"})// 12  18
nSLDQUE  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_SLDQUE"})// 12  19
nQNTMA   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_QNTMA" })// 12  20
 
nQNTME   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_QNTME" })// 12  21
nPACOTE  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_PACOTE"})// 12  22
nTON     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_TON"   })// 12  23

                                                                     



  
nPosDel  := Len(aHoBrw1)+1



if nOpc <> 3 
   if nOpc = 2 .or. nOpc = 4 .or. nOpc = 5
      oGet1:Disable()
      oGet2:Disable()
   else
      oGet1:lReadOnly := .T.
      oGet2:lReadOnly := .T.
   endif 
   cPerio := Z49->Z49_MESANO
   cMaq := upper(Z49->Z49_MAQ)
   
   DbSelectArea("Z49")
   DbSetOrder(1) 
   Z49->(DbSeek(xFilial("Z49")+cPerio+cMaq))
      
   while Z49->( !Eof() .And. Z49_FILIAL == xFilial() .and. Z49_MESANO == cPerio .and.  Z49_MAQ == cMaq )													
	   nQtdeAcols := Len(oBrw1:aCols)
 
 	   
 	   
 	  oBrw1:aCols[nQtdeAcols,nDIA    ]   := Z49->Z49_DIA     //       1
 	  oBrw1:aCols[nQtdeAcols,nTURNO  ]   := upper(Z49->Z49_TURNO)   //       2
 	  oBrw1:aCols[nQtdeAcols,nLMAEX  ]   := Z49->Z49_LMAEX   //       3
 	  oBrw1:aCols[nQtdeAcols,nLMACS  ]   := Z49->Z49_LMACS   //       4
 	  oBrw1:aCols[nQtdeAcols,nLMEEX  ]   := Z49->Z49_LMEEX   //       5
 	  oBrw1:aCols[nQtdeAcols,nLMECS  ]   := Z49->Z49_LMECS   //       6
 	  oBrw1:aCols[nQtdeAcols,nESPMA  ]   := Z49->Z49_ESPMA   //       7
 	  oBrw1:aCols[nQtdeAcols,nESPME  ]   := Z49->Z49_ESPME   //       8
 	  oBrw1:aCols[nQtdeAcols,nCOMPMA ]   := Z49->Z49_COMPMA  //       9
 	  oBrw1:aCols[nQtdeAcols,nCOMPME ]   := Z49->Z49_COMPME  //      10 
 	  
 	  oBrw1:aCols[nQtdeAcols,nABA    ]   := Z49->Z49_ABA     //      11
 	  oBrw1:aCols[nQtdeAcols,nAMOSTR ]   := Z49->Z49_AMOSTR  //      12
      oBrw1:aCols[nQtdeAcols,nALCCOR ]   := Z49->Z49_ALCCOR  //      13
      oBrw1:aCols[nQtdeAcols,nALCFIN ]   := Z49->Z49_ALCFIN  //      14
      oBrw1:aCols[nQtdeAcols,nALCRUI ]   := Z49->Z49_ALCRUI  //      15
      oBrw1:aCols[nQtdeAcols,nBLOCAD ]   := Z49->Z49_BLOCAD  //      16
      oBrw1:aCols[nQtdeAcols,nALINHA ]   := Z49->Z49_ALINHA  //      17
 	  oBrw1:aCols[nQtdeAcols,nSLDFRI ]   := Z49->Z49_SLDFRI  //      18
 	  oBrw1:aCols[nQtdeAcols,nSLDQUE ]   := Z49->Z49_SLDQUE  //      19
 	  oBrw1:aCols[nQtdeAcols,nQNTMA  ]   := Z49->Z49_QNTMA   //      20 
 	  
 	  oBrw1:aCols[nQtdeAcols,nQNTME  ]   := Z49->Z49_QNTME   //      21
 	  oBrw1:aCols[nQtdeAcols,nPACOTE ]   := Z49->Z49_PACOTE  //      22
 	  oBrw1:aCols[nQtdeAcols,nTON    ]   := Z49->Z49_TON     //      23
    
 	   oBrw1:aCols[nQtdeAcols,nPosDel ] := .F. 
 	   
  	  
  	   Z49->(DbSkip())
      if Z49->( !Eof() .And. Z49_FILIAL == xFilial() .and. Z49_MESANO == cPerio  .and. Z49_MAQ == cMaq)
		   AAdd(oBrw1:aCols,Array(noBrw1+1))				
	   endif
   enddo
Z49->(DbGoto(nRecno))
endif   



oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: Z49
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1(cMAq)

Local cFCols := "" 
 

cFCols += "Z49_DIA"    //})// 4        1
cFCols += "/Z49_TURNO" //})// 4        2
cFCols += "/Z49_LMAEX" //})// 4        3
cFCols += "/Z49_LMACS" //})// 4        4
cFCols += "/Z49_LMEEX" //})// 4        5
cFCols += "/Z49_LMECS" //})// 4        6
cFCols += "/Z49_ESPMA" //})// 4        7
cFCols += "/Z49_ESPME" //})// 4        8
cFCols += "/Z49_COMPMA"//})// 4        9
cFCols += "/Z49_COMPME"//})// 4       10  

cFCols += "/Z49_ABA"   //})// 4       11
cFCols += "/Z49_AMOSTR"//})// 4       12
cFCols += "/Z49_ALCCOR"//})// 2       13
cFCols += "/Z49_ALCFIN"//})// 2       14
cFCols += "/Z49_ALCRUI"//})//  2      15
cFCols += "/Z49_BLOCAD"//})//  2      16
cFCols += "/Z49_ALINHA"//})//  2      17
cFCols += "/Z49_SLDFRI"  //))// 12    18
cFCols += "/Z49_SLDQUE"  //})// 12    19
cFCols += "/Z49_QNTMA"   //})// 12    20  

cFCols += "/Z49_QNTME"   //})// 12    21
cFCols += "/Z49_PACOTE"  //})// 12    22
cFCols += "/Z49_TON"     //})// 12    23
                 
                 
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("Z49")
While !Eof() .and. SX3->X3_ARQUIVO == "Z49"
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
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: Z49
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1(cMaq)

Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.



Return  

                   


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
 
 