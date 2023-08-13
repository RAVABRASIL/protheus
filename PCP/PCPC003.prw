#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'

// _______________________________________________________________________
//| Programa  |  PCPC003                                Data: 25/01/2010  |
//|╞╞╞╞╞╞╞╞╞╞╞|╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞|
//| Autor     |  Rubem Duarte Oliota	                                  |
//|╞╞╞╞╞╞╞╞╞╞╞|╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞|
//| Uso       | Controle de Qualidade                                     |
// ╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞╞

*************
User Function PCPC003(aCores )
*************               



aRotina := {;
            {"Pesquisar" , "AxPesqui"     , 0, 1},;
            {"Visualizar", "U_CADQLCS(2)" , 0, 2},;
            {"Incluir"   , "U_CADQLCS(3)" , 0, 3},;
            {"Alterar"   , "U_CADQLCS(4)" , 0, 4},;
            {"Imprimir"  , "U_PCPR007"    , 0, 6},;
            ;//{"Legenda", "U_LegMaq()"   , 0, 7},;
            {"Excluir"   , "U_CADQLCS(5)" , 0, 5} ;
           }
            
cCadastro := OemToAnsi("Cadastro Controle de qualidade  CORTE SOLDA  ")

DbSelectArea("Z49")
DbSetOrder(1)
                
   Set Filter To Z49->Z49_FILIAL = xFilial("Z49").AND.;
                 substr(Z49->Z49_MAQ,1,2) $ 'C0'   
mBrowse( 06, 01, 22, 75, "Z49",,,,,,aCores )



Return 


USER Function CADQLCS(nOpcX)

*************
//дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды
//╠╠ DeclaraГЦo de Variaveis do Tipo Local, Private e Public             ╠╠
//ыюддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд
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


     
//*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддд╠╠
//╠╠ DeclaraГЦo de Variaveis Private dos Objetos                           ╠╠
//ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд 
SetPrvt("oDlg1","oGrp1","oSay1","oGet1","oSay2","oGet2","oGrp2","oBrw1")

//дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
//╠╠ Definicao do Dialog e todos os seus componentes.                      ╠╠
//ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд
oDlg1      := MSDialog():New( 126,254,506,993,"Controle de Qualidade",,,.F.,,,,,,.T.,,,.F. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||U_OkEnch()},{||U_Fecha()},.F.,{})}


                                           

oGrp1        := TGroup():New( 016,004,052,363,"CabeГalho  ",;
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
oGet2:bValid := {||NaoVazio() .AND. U_JaExi(cMaq) .AND. U_Val_MAQ(1,@cMaq) }
cMaq:=upper(cMaq)



MHoBrw1(cMaq)
MCoBrw1(cMaq)

oGrp2      := TGroup():New( 056,004,168,364,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
oBrw1      := MsNewGetDados():New(065,008,155,356,if(Visual.or.Exclui, Nil,GD_INSERT+GD_DELETE+GD_UPDATE),'AllwaysTrue()','AllwaysTrue()','',,0,999,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )    


 nDIA     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_DIA"   })//     01  
 nTURNO   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_TURNO" })//     02
 nLMAEX   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMAEX" })//     03
 nLMACS   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMACS" })//     04
 nLMEEX   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMEEX" })//     05
 nLMECS   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_LMECS" })//     06
 nESPMA   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ESPMA" })//     07
 nESPME   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ESPME" })//     08
 nCOMPMA  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_COMPMA"})//     09
 nCOMPME  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_COMPME"})//     10 

 nBCSACL  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_BCSACL"})//     11
 nBCSACT  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_BCSACT"})//     12
 nBCSADS  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_BCSADS"})//     13
 nSLDFRI  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_SLDFRI"})//     14 
 nSLDQUE  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_SLDQUE"})//     15
 nABA     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_ABA"   })//     16
 nIMPDES  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_IMPDES"})//     17
 nQNTMA   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_QNTMA" })//     18
 nQNTME   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_QNTME" })//     19 
 nSANF    := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_SANF"  })//     20
 
 nPREGA   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_PREGA" })//     21
 nTON     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_TON"   })//     22
 nMALSEL  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_MALSEL"})//     23
 nIMPERF  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_IMPERF"})//     24                  
 nEMBIMP  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_EMBIMP"})//     25 
 nEMBAMA  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_EMBAMA"})//     26
 nEMBAME  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_EMBAME"})//     27 
 nFARDO   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_FARDO" })//     28
 nAMOSTR  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_AMOSTR"})//     29
 nFARDAO  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_FARDAO"})//     30 
 
 nPACOTE  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z49_PACOTE"})//     31
                                                                      
 
                                                                     



  
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
       if substr(cMaq,1,2) $ 'P0/S0'
        alert("Somente Corte Soldas")
        oGet1:Disable()
      oGet2:Disable()
      Altera:=.F.
      Exclui:=.F.
       endif
     
   while Z49->( !Eof() .And. Z49_FILIAL == xFilial() .and. Z49_MESANO == cPerio .and.  Z49_MAQ == cMaq )													
	  nQtdeAcols := Len(oBrw1:aCols) 
	  
 	  oBrw1:aCols[nQtdeAcols,nDIA    ]   := Z49->Z49_DIA          //    1
 	  oBrw1:aCols[nQtdeAcols,nTURNO  ]   := Upper(Z49->Z49_TURNO) //    2
 	  oBrw1:aCols[nQtdeAcols,nLMAEX  ]   := Z49->Z49_LMAEX        //    3
 	  oBrw1:aCols[nQtdeAcols,nLMACS  ]   := Z49->Z49_LMACS        //    4
 	  oBrw1:aCols[nQtdeAcols,nLMEEX  ]   := Z49->Z49_LMEEX        //    5
 	  oBrw1:aCols[nQtdeAcols,nLMECS  ]   := Z49->Z49_LMECS        //    6
 	  oBrw1:aCols[nQtdeAcols,nESPMA  ]   := Z49->Z49_ESPMA        //    7
 	  oBrw1:aCols[nQtdeAcols,nESPME  ]   := Z49->Z49_ESPME        //    8
 	  oBrw1:aCols[nQtdeAcols,nCOMPMA ]   := Z49->Z49_COMPMA       //    9
 	  oBrw1:aCols[nQtdeAcols,nCOMPME ]   := Z49->Z49_COMPME       //   10 
 	  
 	  oBrw1:aCols[nQtdeAcols,nABA    ]   := Z49->Z49_ABA          //   11
 	  oBrw1:aCols[nQtdeAcols,nAMOSTR ]   := Z49->Z49_AMOSTR       //   12
 	  oBrw1:aCols[nQtdeAcols,nIMPDES ]   := Z49->Z49_IMPDES       //   13
 	  oBrw1:aCols[nQtdeAcols,nBCSACL ]   := Z49->Z49_BCSACL       //   14
 	  oBrw1:aCols[nQtdeAcols,nBCSACT ]   := Z49->Z49_BCSACT       //   15
	  oBrw1:aCols[nQtdeAcols,nBCSADS ]   := Z49->Z49_BCSADS       //   16
 	  oBrw1:aCols[nQtdeAcols,nSANF   ]   := Z49->Z49_SANF         //   17
 	  oBrw1:aCols[nQtdeAcols,nEMBIMP ]   := Z49->Z49_EMBIMP       //   18
 	  oBrw1:aCols[nQtdeAcols,nSLDFRI ]   := Z49->Z49_SLDFRI       //   19
 	  oBrw1:aCols[nQtdeAcols,nSLDQUE ]   := Z49->Z49_SLDQUE       //   20 
 	  
 	  oBrw1:aCols[nQtdeAcols,nQNTMA  ]   := Z49->Z49_QNTMA        //   21
 	  oBrw1:aCols[nQtdeAcols,nQNTME  ]   := Z49->Z49_QNTME        //   22
 	  oBrw1:aCols[nQtdeAcols,nPACOTE ]   := Z49->Z49_PACOTE       //   23
 	  oBrw1:aCols[nQtdeAcols,nTON    ]   := Z49->Z49_TON          //   24
 	  oBrw1:aCols[nQtdeAcols,nPREGA  ]   := Z49->Z49_PREGA        //   25
 	  oBrw1:aCols[nQtdeAcols,nMALSEL ]   := Z49->Z49_MALSEL       //   26
 	  oBrw1:aCols[nQtdeAcols,nIMPERF ]   := Z49->Z49_IMPERF       //   27
 	  oBrw1:aCols[nQtdeAcols,nEMBAMA ]   := Z49->Z49_EMBAMA       //   28
 	  oBrw1:aCols[nQtdeAcols,nEMBAME ]   := Z49->Z49_EMBAME       //   29
 	  oBrw1:aCols[nQtdeAcols,nFARDO  ]   := Z49->Z49_FARDO        //   30 
 	  
 	  oBrw1:aCols[nQtdeAcols,nFARDAO ]   := Z49->Z49_FARDAO       //   31                              
 	  oBrw1:aCols[nQtdeAcols,nPosDel ]   := .F. 
 	   
  	  
  	   Z49->(DbSkip())
      if Z49->( !Eof() .And. Z49_FILIAL == xFilial() .and. Z49_MESANO == cPerio  .and. Z49_MAQ == cMaq)
		   AAdd(oBrw1:aCols,Array(noBrw1+1))				
	   endif
   enddo
Z49->(DbGoto(nRecno))
endif   



oDlg1:Activate(,,,.T.)

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: Z49
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function MHoBrw1(cMAq)

Local cFCols := "" 
 

cFCols += "Z49_DIA"      //                1
cFCols += "/Z49_TURNO"   //                2
cFCols += "/Z49_LMAEX"   //                3
cFCols += "/Z49_LMACS"   //                4
cFCols += "/Z49_LMEEX"   //                5
cFCols += "/Z49_LMECS"   //                6
cFCols += "/Z49_ESPMA"   //                7
cFCols += "/Z49_ESPME"   //                8
cFCols += "/Z49_COMPMA"  //                9
cFCols += "/Z49_COMPME"  //               10
                         
cFCols += "/Z49_ABA"     //               11
cFCols += "/Z49_AMOSTR"  //               12
cFCols += "/Z49_IMPDES"  //               13
cFCols += "/Z49_BCSACL"  //               14
cFCols += "/Z49_BCSACT"  //               15
cFCols += "/Z49_BCSADS"  //               16
cFCols += "/Z49_SANF"    //               17
cFCols += "/Z49_EMBIMP"  //               18
cFCols += "/Z49_SLDFRI"  //               19
cFCols += "/Z49_SLDQUE"  //               20 

cFCols += "/Z49_QNTMA"   //               21
cFCols += "/Z49_QNTME"   //               22
cFCols += "/Z49_PACOTE"  //               23
cFCols += "/Z49_TON"     //               24
cFCols += "/Z49_PREGA"   //               25
cFCols += "/Z49_MALSEL"  //               26
cFCols += "/Z49_IMPERF"  //               27
cFCols += "/Z49_EMBAMA"  //               28
cFCols += "/Z49_EMBAME"  //               29
cFCols += "/Z49_FARDO"   //               30

cFCols += "/Z49_FARDAO"  //               31


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


/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: Z49
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function MCoBrw1(cMaq)

Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.



Return  

                