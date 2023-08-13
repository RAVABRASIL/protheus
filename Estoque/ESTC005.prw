#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'


*************

	User Function ESTC005()

*************

Local aIndex := {}

Local aCores := {{"EMPTY(Z55_STATUS)", "BR_VERDE"   },;		   			   
				{"Z55_STATUS='M'", "BR_PINK"   },;    //entregue em mãos
                 {"Z55_STATUS='X'", "BR_AZUL"   },;    //enviado para o PCP
                 {"Z55_STATUS='B'", "BR_VERMELHO" }}   //baixado
                 
/*
aRotina := {{"Pesquisar"   , "AxPesqui"    , 0, 1},;
            {"Visualizar"  , "U_CADAMO(2)" , 0, 2},;
            {"Incluir"     , "U_CADAMO(3)" , 0, 3},;
            {"Alterar"     , "U_CADAMO(4)" , 0, 4},;
            {"Excluir"     , "U_CADAMO(5)" , 0, 5},;
            {"Baixar"      , "U_CADAMO(7)" , 0, 7},;
            {"Imprimir"    , "U_RelSoli()" , 0, 6},;    
            {"Legenda"    , "U_LegAmo"     , 0, 6}} */

//{"Alterar"     , "U_CADAMO(4)"   , 0, 4},;            

aRotina := {{"Pesquisar"   , "AxPesqui"      , 0, 1},;
            {"Visualizar"  , "U_CADAMO(2)"   , 0, 2},;
            {"Incluir"     , "U_CADAMO(3)"   , 0, 3},;
            {"Alterar"     , "U_CADAMO(4)"   , 0, 4},;
            {"Excluir"     , "U_CADAMO(5)"   , 0, 5},;
            {"PCP Produzir", "U_PCP()"       , 0, 6},;            
            {"Produzido"   , "U_Produzido()" , 0, 6},;            
            {"Em Mãos"   , "U_EMAOS()" , 0, 6},;            
            {"Pedido"      , "U_Pedido()"    , 0, 6},;                        
            {"Transferencia", "U_fTransf()"    , 0, 6},;                                    
            {"Imprimir"    , "U_RelSoli()"   , 0, 6},;    
            {"Legenda"     , "U_LegAmo"      , 0, 6}} 


cCadastro := OemToAnsi("Cadastro de Solicitacao de Amostra " )

DbSelectArea("Z55" )
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "Z55",,,,,,aCores)

Return 

*************

User Function CADAMO(nOpcX)

*************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
LOCAL nRecno:=Z55->(RecNo())
Private nOpc   := nOpcX
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private noBrw1  := 0
Private cNum  := GETSX8NUM("Z55","Z55_NUM")    
Private dDtnece    := ddatabase //CtoD(" ")
Private dDtSoli    := ddatabase
Private cSoli      :=Substr(cUsuario,7,15)
Private cClient:=space(6)
Private cLoja:=SPACE(2)
Private cLocal:=space(6)
PRIVATE cTransp:=SPACE(6)
PRIVATE nVolume:=0


if nOpc=7
   Private cQuemBa    :=Substr(cUsuario,7,15)
   Private dDtBai     := ddatabase
else
   Private cQuemBa    :=space(15)
   Private dDtBai     := CtoD(" ")
endif

IF nOpc !=2
   PRIVATE cFColsG := "Z55_PROD/Z55_DESCRI/Z55_UM/Z55_QDTSOL"
ELSE
   PRIVATE cFColsG := "Z55_ESTVIR"
ENDIF 

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
    Case nOpc = 7
		Inclui 	:= .F.
		Altera 	:= .T.
	
EndCase

if (  nOpc=4 .or. nOpc=5 )     //alterar ou excluir
    lSt:=.F.
    cNumS:=Z55->Z55_NUM
    DbSelectArea("Z55")
    DbSetOrder(1) 
    Z55->(DbSeek(xFilial("Z55")+cNumS))
      
    Do while Z55->( !Eof() .And. Z55_FILIAL == xFilial() .and. Z55_NUM == cNumS )													
	   if nOpc=5 // exclui
	      if ! empty(Z55->Z55_STATUS)
  	         lSt:=.T.
  	      ENDIF
  	   elseif nOpc=4 // altera
  	      if  Z55->Z55_STATUS='B'
  	          lSt:=.T.
  	      ENDIF
  	   endif
  	  Z55->(DbSkip())
      
    enddo
    if lSt
       alert("Solicitacao de Amostra nao pode ser "+iif(nOpc=4,"Alterada","Excluida") )
       Z55->(DbGoto(nRecno))
       RETURN
     endif
   Z55->(DbGoto(nRecno))
endif

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oGet1","oGrp2","oBrw1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 126,254,506,993,"Solicitacao de Amostra",,,.F.,,,,,,.T.,,,.F. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,{||OkEnch()},{||Fecha()},.F.,{})}

//
oGrp1      := TGroup():New( 016,004,062,363,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New(  034,008,{||"Num: "},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 034,112,{||"Dt Solicitacao"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay4      := TSay():New( 050,105,{||"    Solicitante"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
oSay5      := TSay():New( 050,008,{||"Dt Necessidade"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)

oGet1      := TGet():New( 034,032,{|u| If(PCount()>0,cNum:=u,cNum)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNum",,)
oGet1:bValid := {||NaoVazio().And.ExistChav("Z55") }

oSay6      := TSay():New( 034,225,{||"Cliente "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,043,008)
oGet5      := TGet():New( 034,245,{|u| If(PCount()>0,cClient:=u,cClient)},oGrp1,30,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cClient",,)


oSay7      := TSay():New( 034,285,{||"Loja "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,036,008) 
oGet6      := TGet():New( 034,298,{|u| If(PCount()>0,cLoja:=u,cLoja)},oGrp1,016,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLoja",,)

oGet2      := TGet():New( 034,149,{|u| If(PCount()>0,dDtSoli:=u,dDtSoli)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtSoli",,)
oGet2:Disable()
oGet3      := TGet():New( 050,149,{|u| If(PCount()>0,cSoli:=u,cSoli)},oGrp1,101,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSoli",,)
oGet3:Disable()
oGet4      := TGet():New( 050,048,{|u| If(PCount()>0,dDtNece:=u,dDtNece)},oGrp1,051,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtNece",,)
oGet4:bValid := {||NaoVazio() }

oSay8      := TSay():New( 050,255,{||"Local "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,036,008) 
//oGet7      := TGet():New( 037,270,{|u| If(PCount()>0,cLocal:=u,cLocal)},oGrp1,30,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ","cLocal",,)
oGet7      := TGet():New( 050,270,{|u| cLocal := GetLocCli(cClient , cLoja)},oGrp1,30,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ","cLocal",,)

//oGet7:bValid := {||  /*FATC008(cLocal,cClient,cLoja) .and. */ U_ALIBTRANS(cLocal)  }
oGet7:bValid := {||   U_ALIBTRANS(cLocal) }
//GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + 'MO' + cCodMoti,1,0)

oSay9      := TSay():New( 050,305,{||"Transp. "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,036,008) 
oGet8      := TGet():New( 050,325,{|u| If(PCount()>0,cTransp:=u,cTransp)},oGrp1,30,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTransp",,)
oGet8:cF3  := "SA4ZZ"
oGet8:bValid := {|| VLDTRANSP(cLocal,cTransp) }
//
oSay10     := TSay():New( 034,315,{||"Vol."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,036,008) 
oGet9      := TGet():New( 034,331,{|u| If(PCount()>0,nVolume:=u,nVolume)},oGrp1,30,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nVolume",,)


oGrp2      := TGroup():New( 066,004,174,364,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrw1()
MCoBrw1()
//oBrw1      := MsNewGetDados():New(065,008,155,356,if(Visual.or.Exclui.OR. ALTERA, Nil,GD_INSERT+GD_DELETE+GD_UPDATE),'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsG,"/",.T.),0,999,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )
//FR - 02/10/13 - Solicitado por Renata Lopes, permitir alteração também no grid de itens:
oBrw1      := MsNewGetDados():New(070,008,160,356,if(Visual.or.Exclui, Nil,GD_INSERT+GD_DELETE+GD_UPDATE),'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsG,"/",.T.),0,999,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )
//Guarda as posicoes dos campos no aHeader 
nPosNum     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_NUM"})
nPosDtSo    := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_DTSOLI" })
nPosNomSol  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_NOMSOL" })
nPosProd    := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_PROD" })
nPosNum     := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_NUM"})
nPosdesc    := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_DESCRI"})
nPosUM      := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_UM"})
nPosQtdSo   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_QDTSOL" })
nPosDtNec   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_DTNECE" })
nPosDtBai   := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_DTBAIX" })
nPosQtdEnt  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_QTDENT" })
nPosNomBai  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_NOMBAI" })
nPosEstVir  := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z55_ESTVIR" })

nPosDel  := Len(aHoBrw1)+1



if nOpc <> 3 
   if nOpc = 4 .or. nOpc = 5 
      oGet1:Disable() 
   else
      oGet1:lReadOnly := .T.
      oGet4:lReadOnly := .T.
      oGet5:lReadOnly := .T.
      oGet6:lReadOnly := .T.
      oGet7:lReadOnly := .T.
      oGet8:lReadOnly := .T.
   endif 
   cNum := Z55->Z55_NUM
   //
   dDtnece    := Z55->Z55_DTNECE
   dDtSoli    := Z55->Z55_DTSOLI
   cSoli      := alltrim(U_NomeSoli(Z55->Z55_NOMSOL))
   cclient    :=Z55->Z55_CLIENT
   cloja      :=Z55->Z55_LOJA
   cLocal     :=Z55->Z55_LOCALI
   cTransp    :=Z55->Z55_TRANSP
   nVolume	  :=Z55->Z55_VOLUME
   //
   DbSelectArea("Z55")
   DbSetOrder(1) 
   Z55->(DbSeek(xFilial("Z55")+cNum))
      
   while Z55->( !Eof() .And. Z55_FILIAL == xFilial() .and. Z55_NUM == cNum )													
	   nQtdeAcols := Len(oBrw1:aCols)
 
		oBrw1:aCols[nQtdeAcols,nPosProd  ]     := Z55->Z55_PROD 
		oBrw1:aCols[nQtdeAcols,nPosdesc  ]     := Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_DESC") 
		oBrw1:aCols[nQtdeAcols,nPosUM  ]       := Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_UM") 
		oBrw1:aCols[nQtdeAcols,nPosQtdSo  ]    := Z55->Z55_QDTSOL 
 	   
		If  nOpc=2  
  		    oBrw1:aCols[nQtdeAcols,nPosEstVir  ] :=IIF(!EMPTY(Z55->Z55_EDITAL),ESTLICITA( Z55->Z55_PROD,'03'),U_SALDOEST( Z55->Z55_PROD, '01' ) - SALDORES( Z55->Z55_PROD) )
		endif 	     
 	   
 	   oBrw1:aCols[nQtdeAcols,nPosDel ] := .F.
  	  
  	   Z55->(DbSkip())
      if Z55->( !Eof() .And. Z55_FILIAL == xFilial() .and. Z55_NUM == cNum )
		   AAdd(oBrw1:aCols,Array(noBrw1+1))				
	   endif
   enddo
Z55->(DbGoto(nRecno))
endif   



oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: Z55
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

Local cFCols := ""

IF nOpc !=2
   cFCols := "Z55_PROD/Z55_DESCRI/Z55_UM/Z55_QDTSOL"
ELSE
   cFCols := "Z55_PROD/Z55_DESCRI/Z55_UM/Z55_QDTSOL/Z55_ESTVIR"
ENDIF 

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("Z55")
While !Eof() .and. SX3->X3_ARQUIVO == "Z55"
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
Z55->(DbSetOrder(1))

If ! INCLUI .And. Z55->(DbSeek(xFilial("Z55")+cNum))	
	While !Z55->(Eof()) .And. xFilial("Z55")+cNum == xFilial("Z55")+Z55->Z55_NUM
		Aadd(aAnterior1,Z55->(RecNo()))
		Z55->(dbSkip())
	Enddo
Endif

dbSelectArea("Z55")
nItem := 1

nMaxArray := Len(oBrw1:aCols)

For nCampos := 1 to nMaxArray
	If Len(aAnterior1) >= nCampos
		If ! INCLUI
			DbGoto(aAnterior1[nCampos])
		EndIf
		RecLock("Z55",.F.)
	Else
		RecLock("Z55",.T.)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tem marcacao para apagar.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oBrw1:aCols[nCampos][Len(oBrw1:aCols[nCampos])]
		RecLock("Z55",.F.,.T.)
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
	    Replace Z55_FILIAL with xFilial("Z55")
	    Replace Z55_NUM    with cNum
	    Replace Z55_DTSOLI with dDtSoli
	    Replace Z55_DTNECE with dDtNece
	    Replace Z55_NOMSOL with __CUSERID //Soli( substr(cUsuario,7,15) )
	    Replace Z55_CLIENT with cClient
	    Replace Z55_LOJA   with cLoja
	    Replace Z55_LOCALI with cLocal
	    Replace Z55_TRANSP with cTransp
	    Replace Z55_VOLUME with nVolume
	    
	    if nOpc=7
	       Replace Z55_NOMBAI with __CUSERID //Soli( substr(cUsuario,7,15) ) 
	       Replace Z55_DTBAIX with dDtBai
	    endif
	Endif	
	
Next nCampos  


Return 

***************

Static Function ExcArq()

***************

if nOpc == 5		
   DbSelectArea("Z55" 	)
   DbSetOrder(1) 
   Z55->(DbSeek(xFilial("Z55")+cNum))
      
   while Z55->( !Eof() .And. Z55_FILIAL == xFilial() .and. Z55_NUM == cNum )													
     RecLock("Z55",.F.)
     Z55->(DbDelete())
     Z55->(DbSkip())
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
	if Empty(cNum)
		lOk := .F.
		cCpo := 'Num'	
	elseif Empty(cClient)
		lOk := .F.
		cCpo := 'Cliente'
	elseif Empty(cLoja)
		lOk := .F.
		cCpo := 'Loja'
	elseif Empty(cLocal)
		lOk := .F.
		cCpo := 'Local'
	elseif Empty(cTransp)
		lOk := .F.
		cCpo := 'Tranp.'
	
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
      EmailSol(cNum, " - Inclusao")
   elseif nOpc == 4 
      GravMod()
      EmailSol(cNum," - Alteracao")
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

Static Function Campos( cString,;	// String a ser processada
					    cDelim,;	// Delimitador
					    lAllTrim;	// Tira espacos em brancos
				                  )
***************

Local aRetorno := {}	// Array de retorno
Local nPos				// Posicao do caracter

cDelim		:= If( cDelim = Nil, ' ', cDelim )
lAllTrim 	:= If( lAllTrim = Nil, .t., lAllTrim )
             
If lAllTrim
	cString := AllTrim( cString )
Endif

Do While .t.
	If ( nPos := At( cDelim, cString ) ) != 0
 		Aadd( aRetorno, Iif( lAllTrim, AllTrim( Substr( cString, 1, nPos - 1 ) ), Substr( cString, 1, nPos - 1 ) ) )
		cString := Substr( cString, nPos + Len( cDelim ) )
	Else
		If !Empty( cString )
			Aadd( aRetorno,  Iif( lAllTrim, AllTrim( cString ), cString ) )
		Endif
		Exit
	Endif	
Enddo

Return aRetorno


***************

User Function NomeSoli( cSoli )

***************

local cNome:=''

PswOrder(1)
If PswSeek( cSoli, .T. )
   aUsuarios  := PSWRET() 					
   if !empty(aUsuarios[1][2])
      cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
   endif
Endif 

return cNome


***************

Static Function Soli( cSoli )

***************

local ccod:=''

PswOrder(2)
If PswSeek( cSoli, .T. )
   aUsuarios  := PSWRET() 					
   ccod := Alltrim(aUsuarios[1][1])     	// usuário
Endif 

return ccod


***************

Static Function GravD3()

***************
/*
Local lMsErroAuto := .F.

Z55->(DbSetOrder(1))

If Z55->(DbSeek(xFilial("Z55")+cNum))	
	While !Z55->(Eof()) .And. xFilial("Z55")+cNum == xFilial("Z55")+Z55->Z55_NUM		
	  if Z55->Z55_QTDENT>0
		  Begin Transaction
		      aMatriz :=  {{"D3_COD"    ,Z55->Z55_PROD,						                       Nil},;
				   	       {"D3_DOC"    ,"SA"+Z55->Z55_NUM,						                   Nil},;
					       {"D3_TM"     ,"503",							                           Nil},;
					       {"D3_LOCAL"  ,'03',					                                   Nil},;
					       {"D3_UM"     ,posicione("SB1",1,xFilial('SB1') + Z55->Z55_PROD,"B1_UM"),Nil},;
					       {"D3_QUANT"  ,Z55->Z55_QTDENT, 					                       Nil},;
					       {"D3_EMISSAO",DDATABASE,					                               Nil},;
				 	       {"D3_OBS"    ,"SOLICITACAO AMOSTRA",  				                   Nil}}
			  MSExecAuto( { | x,y | MATA240( x,y ) }, aMatriz, 3 )
		
			 if lMsErroAuto
				DisarmTransaction()
				Return
			 endIf
		  
		  End Transaction
	  EndIf
	  Z55->(dbSkip())
	EndDo 
EndIf
*/
return 

***************

User Function RelSoli()

***************



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Solicitacao de Amostra"
Local cPict          := ""
Local titulo         := "Solicitacao de Amostra"
Local nLin           := 80
                         //00 08 18 40 57 70 80 90 103

                      //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160                 170                 180       190
                      //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

Local Cabec1         := "Numero Dt Solici Solicitante           Produto          Qtd Solici   Dt Nece   Dt Baixa  Qtd Entregue Baixado por  Licitacao Pedido Cliente               Loja    Local                      Transportadora           "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RelSoli" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RelSoli" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte("RELSOLI",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"RELSOLI",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQry:=''
cnt:=0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQry:="SELECT Z55_NUM,Z55_DTSOLI,Z55_NOMSOL,Z55_PROD,Z55_QDTSOL, "
cQry+="Z55_DTNECE,Z55_DTBAIX,Z55_QTDENT,Z55_NOMBAI,Z55_EDITAL,Z55_PEDIDO,Z55_LOCALI,Z55_TRANSP,Z55_CLIENT,Z55_LOJA "
cQry+="FROM Z55020 Z55 "
cQry+="WHERE "
cQry+="Z55_DTSOLI BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQry+="AND Z55_NOMSOL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "
cQry+="AND Z55_DTNECE BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'  "
cQry+="AND Z55_DTBAIX BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"'  "
cQry+="AND Z55_NUM BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"'  "
IF MV_PAR11=2
   cQry+="AND Z55_PEDIDO =''  "
ENDIF
cQry+="AND Z55.D_E_L_E_T_!='*' "
cQry+="ORDER BY Z55_NUM "

TCQUERY cQry NEW ALIAS "_TMPY" 

TCSetField( '_TMPY', "Z55_DTSOLI", "D", 08, 0 )
TCSetField( '_TMPY', "Z55_DTNECE", "D", 08, 0 )
TCSetField( '_TMPY', "Z55_DTBAIX", "D", 08, 0 )


SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_TMPY->( dbGoTop() )
While _TMPY->( !EOF() )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    
    cNumSo:=_TMPY->Z55_NUM
    cnt:=0
    @nLin,00  PSAY _TMPY->Z55_NUM
    @nLin,08  PSAY DTOC(_TMPY->Z55_DTSOLI)
	@nLin,18  PSAY iif(empty(U_NomeSoli(_TMPY->Z55_NOMSOL)),space(2),U_NomeSoli(_TMPY->Z55_NOMSOL))
	@nLin,70  PSAY DTOC(_TMPY->Z55_DTNECE)
	@nLin,120 PSAY iif(EMPTY(_TMPY->Z55_EDITAL),'Nao','Sim')
	@nLin,133 PSAY ALLTRIM(Posicione('SA1',1,xFilial("SA1")+_TMPY->Z55_CLIENT,"A1_NREDUZ" ))
    @nLin,155 PSAY _TMPY->Z55_LOJA
    @nLin,159 PSAY SUBSTR(Posicione('SX5',1,xFilial("SX5")+'ZZ'+_TMPY->Z55_LOCALI,"X5_DESCRI" ),1,30)  
    @nLin,191 PSAY ALLTRIM(Posicione('SA4',1,xFilial("SA4")+_TMPY->Z55_TRANSP,"A4_NREDUZ" ))

    
    
    While _TMPY->( !EOF() ) .AND. _TMPY->Z55_NUM==cNumSo
	     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 8
         Endif
	    if cnt=0
	       @nLin,39 PSAY _TMPY->Z55_PROD
	       @nLin,56 PSAY transform(_TMPY->Z55_QDTSOL,"@E 999999.9999")
	       @nLin,89 PSAY transform(_TMPY->Z55_QTDENT,"@E 999999.9999")
	       @nLin,80 PSAY DTOC(_TMPY->Z55_DTBAIX)
	       @nLin,103 PSAY iif(empty(U_NomeSoli(_TMPY->Z55_NOMBAI)),space(2),U_NomeSoli(_TMPY->Z55_NOMBAI))
	       @nLin,125 PSAY _TMPY->Z55_PEDIDO
	    else
	       @nLin,38 PSAY _TMPY->Z55_PROD
	       @nLin,55 PSAY transform(_TMPY->Z55_QDTSOL,"@E 999999.9999")
	       @nLin,88 PSAY transform(_TMPY->Z55_QTDENT,"@E 999999.9999")
	       @nLin,80 PSAY DTOC(_TMPY->Z55_DTBAIX)
	       @nLin,103 PSAY iif(empty(U_NomeSoli(_TMPY->Z55_NOMBAI)),space(2),U_NomeSoli(_TMPY->Z55_NOMBAI))
	       @nLin,125 PSAY _TMPY->Z55_PEDIDO
	    endif
	   
	    nLin++
	    cnt++
	    IncRegua()
	   _TMPY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
EndDo

_TMPY->(dbclosearea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


*************

User Function LegAmo()

*************

Local aLegenda := {{"BR_VERDE"     ,"Nao Baixado" },;
   	   			   {"BR_AZUL"      ,"PCP Produzir " },;
   	   			   {"BR_PINK"      ,"Entregue em Mãos" },;
   	   			   {"BR_VERMELHO" ,"Baixado" }}


BrwLegenda("Solicitacao de Amostra","Legenda",aLegenda)		   		

Return .T.



***************

Static Function EmailSol(cNum, cOper)

***************

Local cUserLog := __CUSERID
Local cNomeOper:= ""
Local cMailOper:= ""
Local aUsu	   := {}
Local cDeptOper:= ""

oProcess:=TWFProcess():New("AMOSTRA","AMOSTRA")
//oProcess:NewTask('Inicio',"\workflow\http\emp01\amostra.html")
oProcess:NewTask('Inicio',"\workflow\http\oficial\amostra.html")
oHtml   := oProcess:oHtml

DbSelectArea("Z55")
DbSetOrder(1) 
Z55->(DbSeek(xFilial("Z55")+cNum))
   

oHtml:ValByName("cNum", cNum + cOper)
oHtml:ValByName("DtSoli", Z55->Z55_DTSOLI)
oHtml:ValByName("DtNece", Z55->Z55_DTNECE)
oHtml:ValByName("cSoli",alltrim(U_NomeSoli(Z55->Z55_NOMSOL)) ) 
oHtml:ValByName("cClient", Posicione('SA1',1,xFilial("SA1")+Z55->Z55_CLIENT,"A1_COD" ) +  "/" ;
                         + (Posicione('SA1',1,xFilial("SA1")+Z55->Z55_CLIENT,"A1_LOJA" )+ " - ";
                         + Alltrim(Posicione('SA1',1,xFilial("SA1")+Z55->Z55_CLIENT,"A1_NOME" )) ) )   
//oHtml:ValByName("cLoja", Z55->Z55_LOJA)
oHtml:ValByName("cLocal", ALLTRIM(Posicione('SX5',1,xFilial("SX5")+'ZZ'+Z55->Z55_LOCALI,"X5_DESCRI" )))  
oHtml:ValByName("cTransp", ALLTRIM(Posicione('SA4',1,xFilial("SA4")+Z55->Z55_TRANSP,"A4_NREDUZ" )))  

Do While !Z55->(EOF()) .AND. Z55->Z55_NUM==cNum 	
   aadd( oHtml:ValByName("it.cProd" ) , Z55->Z55_PROD)
		
   aadd( oHtml:ValByName("it.cDesc") , Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_DESC") )
		
   aadd( oHtml:ValByName("it.cUM") , Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_UM"))

   aadd( oHtml:ValByName("it.cQtdSoli") , transform(Z55->Z55_QDTSOL,"@E 999999.9999") )
		
   Z55->( DBSKIP() )
enddo

PswOrder(1)
If PswSeek( cUserLog, .T. )      //USUÁRIO LOGADO
   
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cNomeOper := Alltrim(aUsu[1][4])		//Nome Completo
   cMailOper := Alltrim( aUsu[1][14] )     // email   
   cDeptOper := Alltrim( aUsu[1][12] )	 //departamento do usuário
Endif

//FR - 17/05/2013
//ASSINATURA NO FINAL DO EMAIL, COM OS DADOS DE QUEM INCLUIU A SOLICITAÇÃO DA AMOSTRA
oHtml:ValByName("cOperador", cNomeOper )
oHtml:ValByName("cDepto", cDeptOper )
oHtml:ValByName("cEmail", cMailOper )


_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)

oProcess:cTo := cMailOper
oProcess:cTo += ";amostra@ravaembalagens.com.br"
oProcess:cTo += ";inspecao.qualidade@ravaembalagens.com.br"
oProcess:cTo += ";renata@ravaembalagens.com.br"
oProcess:cTo += ";julia.araujo@ravaembalagens.com.br"
//oProcess:cTo := ""  //COMENTAR
//oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br"    //retirar depois

subj	:= "Solicitação de Amostra - "+cNum
oProcess:cSubject  := subj
oProcess:Start()
WfSendMail()

Return 

*************

User Function PCP()   //produzir

*************

Local cNum:=Z55->Z55_NUM
local cProd:=Z55->Z55_PROD
LOCAL nREG := Z55->( RecNo() )


if !EMPTY(Z55->Z55_STATUS)
   If Z55->Z55_STATUS='X'
      alert("O Produto "+alltrim(cProd)+" dessa Solicitação de amostra "+cNum+" ja foi enviado para o PCP. " )
   ElseIf Z55->Z55_STATUS='B'
      alert("O Produto "+alltrim(cProd)+" dessa Solicitação de amostra "+cNum+" ja foi Baixado. " )
   endif
   return 
Endif


If u_senha2("17",1)[1]        //RONALDO LISBOA, RENATA, JORGE, LUCIANA NEVES,
	//Do while Z55->( !Eof() .And. Z55_FILIAL == xFilial() .and. Z55_NUM == cNum .AND. Z55_PROD==cProd)
	RecLock("Z55",.F.)
	Z55->Z55_STATUS:='X'
	Z55->( msUnlock() )
	//Z55->( DBSKIP() )
	//EndDo
	
	EmailPCP(cNum, "")
ENDIF

Z55->( DbGoTo( nREG ) )

Return 


*************

User Function EMAOS()  //entregar em mãos

*************

Local cNum:=Z55->Z55_NUM
local cProd:=Z55->Z55_PROD
LOCAL nREG := Z55->( RecNo() )


if !EMPTY(Z55->Z55_STATUS)
   If Z55->Z55_STATUS='M'
      alert("O Produto "+alltrim(cProd)+" Desta Solicitação de Amostra "+cNum+" Já Foi Entregue Em Mãos. " )
   ElseIf Z55->Z55_STATUS='B'
      alert("O Produto "+alltrim(cProd)+" Desta Solicitação de Amostra "+cNum+" Já Foi Baixado. " )
   endif
   return 
Endif

If MsgYesNo("O Produto Será Entregue ao Solicitante Em Mãos ?")
	//If u_senha2("17",1)[1]
		RecLock("Z55",.F.)
		Z55->Z55_STATUS:='M' //entregue em mãos
		Z55->( msUnlock() )
		MsgInfo("Produto Entregue em Mãos com Sucesso.")
		EmailPCP(cNum, "M")
	//ENDIF
Endif

Z55->( DbGoTo( nREG ) )

Return




*************

USer Function Produzido()

*************

Local cNum:=Z55->Z55_NUM
local cProd:=Z55->Z55_PROD
LOCAL nREG := Z55->( RecNo() )

if Z55->Z55_STATUS!='X'
   alert("O Produto "+alltrim(cProd)+" dessa Solicitação de amostra "+cNum+" nao foi  enviado para o PCP. " )
   return 
Endif

If u_senha2("16",1)[1]
//   Do while Z55->( !Eof() .And. Z55_FILIAL == xFilial() .and. Z55_NUM == cNum .AND. Z55_PROD==cProd)
RecLock("Z55",.F.)
Z55->Z55_STATUS:=''
Z55->( msUnlock() )
//Z55->( DBSKIP() )
//   EndDo

EndIf

Z55->( DbGoTo( nREG ) )

Return  



*************

User Function  SoliPed()

*************
/*
SetPrvt("oDlg1","oSay1","oGet1","oSBtn1","oSBtn2")

oDlg1      := MSDialog():New( 240,483,357,620,"Solic. Amostra",,,.F.,,,,,,.T.,,,.F. )
oSay1      := TSay():New( 006,002,{||"Numero Solicitação:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,006)
oGet1      := TGet():New( 015,002,{|u| If(PCount()>0,cSolAmo:=u,cSolAmo)},oDlg1,063,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z55","cSolAmo",,)
oGet1:bValid := {||vldZ55() }
oSBtn1     := SButton():New( 036,002,1,,oDlg1,,"", )
oSBtn1:bAction := {||ok()}

oSBtn2     := SButton():New( 036,040,2,,oDlg1,,"", )
oSBtn2:bAction := {||oDlg1:end()}


oDlg1:Activate(,,,.T.)
*/

Return 

***************

Static Function vldZ55()

***************
/*
DbSelectArea("Z55")
DbSetOrder(1) 
if Z55->(DbSeek(xFilial("Z55")+cSolAmo))
   If EMPTY(Z55->Z55_STATUS)
      Return .T.
   Else
      alert("Essa Solicitação nao e uma Solicitação Nao Baixada" )
      Return .F.
   Endif
Else
   alert("Essa Solicitação nao e uma Solicitação Valida" )
   Return .F.
endif
*/
Return .T.


***************

Static Function Ok()

***************
/*
DbSelectArea("Z55")  
DbSetOrder(1)
Z55->(DbSeek(xFilial("Z55")+cSolAmo))
nIt := 1

if Len(aCols) > 1 
   aCols := aSize( aCols,1)
endif

while !Z55->(EOF()) .AND. Z55->Z55_NUM == cSolAmo
       aCols[nIt,1] := StrZero(nIt,2)
       aCols[nIt,2] := Z55->Z55_PROD
       aCols[nIt,3] := "01"
       aCols[nIt,4] := Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_UM") 
       aCols[nIt,5] := Z55->Z55_QDTSOL
       aCols[nIt][Len(aCols[1])] := .F.           
       nIt++  
       Z55->(DbSkip())
       if !Z55->(EOF()) .AND. Z55->Z55_NUM == cSolAmo
           Aadd(aCols, Array(Len(aCols[1])) )           
           for nI := 1 To Len(aCols[1])-3 //menos a coluna delete a alias e recno wt
	           aCols[nIt][nI] := CriaVar(aHeader[nI][2])
           next
       endif
endDO

oDlg1:end()
*/
Return 


*************

User Function VldSolProd(cProd)

*************

Local lRet:=.T.

/*
if Type("cSolAmo") == "C" 
   if !empty(cSolAmo)
      DbSelectArea("Z55" )
      DbSetOrder(2)
      lRet:=Z55->(DbSeek(xFilial("Z55")+cProd+cSolAmo))
   Else
      If ALTERA
         DbSelectArea("Z55" )
         DbSetOrder(4) 
         lRet:=Z55->(DbSeek(xFilial("Z55")+M->C5_NUM+cProd))
      EndIf
   endif
endif   
 */
Return lRet          



*************

User Function Pedido()

*************
if MsgBox( OemToAnsi( "Deseja Gerar o Pedido ?" ), "Escolha", "YESNO" )       
   MsAguarde( { || GeraPed() }, "Aguarde. . .", "Gerando Pedido . . ." )
endif
Return

***************

Static Function GeraPed()

***************

Local cCli:=cLoja:=cLoja:=cTransp:=''
Local nIt:=1
Local _cNum:=''
local cPedido:=''
local cVend:=cTipo:=''
Local nSaveSX8:= GetSX8Len()
LOCAL nREG := Z55->( RecNo() )
local cProd:=''
aCab   := {}
aItens := {}
aSaldo:={}

DbSelectArea("Z55" )
Z55->(DbSetOrder(1))


If Z55->(DbSeek(xFilial("Z55")+Z55->Z55_NUM))	
     
     if Empty(cPedido)
        
        cPedido := GetSxeNum("SC5","C5_NUM")
        DbSelectArea("SC5" )
        SC5->(DbSetOrder(1))
        if SC5->( DbSeek( xFilial( "SC5" )+cPedido ) )
              ConfirmSX8()
              cPedido  := GetSxeNum("SC5","C5_NUM")
        endif	    	       	   
	 endif		            
            
    cCli:=ALLTRIM(Z55->Z55_CLIENT)
    cLoja:=ALLTRIM(Z55->Z55_LOJA)
    cCF  := ""
    DbSelectArea("SA1" )
    SA1->(DbSetOrder(1))
    if SA1->( DbSeek( xFilial( "SA1" )+cCli ) )
       cVend:=SA1->A1_VEND
       cTipo:=SA1->A1_TIPO
       cCF := iif(Alltrim(SA1->A1_EST) = Alltrim(SM0->M0_ESTCOB) , '5911' , '6911' )
    endif     
    
    If Empty(cCF)
    	cCF := '5911'
    Endif
    
    
   	aCab := {{"C5_NUM"    , cPedido              , NIL},;
             {"C5_TIPO"   , 'N'                  , NIL},;
             {"C5_CLIENTE", cCli                 , ''},; 
             {"C5_LOJACLI", cLoja                , ''},;
             {"C5_CLIENT" , cCli                 , ''},; 
             {"C5_LOJAENT", cLoja                , ''},;
             {"C5_LOCALIZ",Z55->Z55_LOCALI       , ''},;
             {"C5_TRANSP" ,Z55->Z55_TRANSP       , ''},;                                                                                             
             {"C5_TIPOCLI", cTipo                , NIL},;
             {"C5_CONDPAG", "001"                , ''},;
             {"C5_VOLUME1", Z55->Z55_VOLUME      , NIL},;
             {"C5_ESPECI1", "VOLUME"             , NIL},;
             {"C5_VEND1"  , cVend                , NIL},;
             {"C5_OBSFIN"  ,"PEDIDO AMOSTRA"     , NIL},;  
             {"C5_INFBANC" , "."                 , NIL},;        
             {"C5_OCCLI"  ,"NAO TEM"             , NIL},;        
             {"C5_ENTREG" , dDataBase            , ''} }
   
          
     _cNum:=Z55->Z55_NUM             
	While !Z55->(Eof()) .And. xFilial("Z55")+_cNum == xFilial("Z55")+Z55->Z55_NUM
	      if EMPTY(Z55->Z55_STATUS)	
             
             IF !fSaldo(Z55->Z55_PROD,Z55->Z55_QDTSOL)
                 Aadd(asaldo,{Z55->Z55_PROD,Z55->Z55_QDTSOL,Posicione( "SB2", 1, xFilial( "SB2" )+Z55->Z55_PROD+'03',"SB2->B2_QATU" )})
             ENDIF

             Aadd(aItens, {{"C6_ITEM",StrZero(nIt,2)            ,NIL},;
                          {"C6_PRODUTO",Z55->Z55_PROD          ,NIL},;
                          {"C6_QTDVEN" ,Z55->Z55_QDTSOL        ,NIL},;
                          {"C6_TES"    ,'516'                  ,NIL},;
                          {"C6_CF"     ,cCF                    ,NIL},;
                          {"C6_LOCAL"  ,'03'                   ,NIL},;
                          {"C6_PRCVEN" ,VALORZ55(Z55->Z55_PROD),NIL},;
                          {"C6_PRUNIT" ,VALORZ55(Z55->Z55_PROD),NIL}})
          nIt++
          endif
	     Z55->(dbSkip())
	     
	EndDo 
    
    If len(aSaldo)>0  // produto sem saldo no almoxarifado 03 
       fTelaS()
       return
    Endif
    
    //Begin Transaction
	  If Len(aCab)>0 .AND. LEN(aItens)>0	      
		  
		  if Type("cPrePed") == "U" 
		      cPrePed:=space(6)
		  endif

		  if Type("nComisN") == "U" 
		      nComisN := 0
		  endif

		  
		  lMsErroAuto := .F.
	      MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCab, aItens, 3)
			
		  if lMsErroAuto
			 RollBackSX8()  	
	         MostraErro()
		     Return
		  else
		  	 while ( GetSX8Len() > nSaveSX8 )
		       ConfirmSX8()
	        end
		   // SOLICITACAO DE AMOSTRA
		    DbSelectArea("SC9")
            DbSetOrder(1)
           if SC9->( DbSeek( xFilial("SC9")+cPedido+"0101"+aItens[1][2][2] ) )
	           RecLock("SC9",.F.)
	           SC9->C9_MSGFIN :="PEDIDO AMOSTRA"
	           MsUnLock()
           endif
		   //
		  endIf
	  else
	     alert('Essa Solicitacao nao tem Itens para gerar Pedido!!!')
	     Return
	  endif	  
	//End Transaction
    
    // salva o numero do pedido na solicitacao de amostra e quem baixou 
    DbSelectArea("Z55" )
    Z55->(DbSetOrder(1))
    If Z55->(DbSeek(xFilial("Z55")+_cNum))	
       _cNum:=Z55->Z55_NUM
       Do While !Z55->(Eof()) .And. xFilial("Z55")+_cNum == xFilial("Z55")+Z55->Z55_NUM  
          if EMPTY(Z55->Z55_STATUS)		
             RecLock("Z55",.F.)
             Z55->Z55_PEDIDO:=cPedido
             Z55->Z55_DTBAIX:=DDATABASE
             Z55->Z55_QTDENT:=Z55->Z55_QDTSOL
             Z55->Z55_NOMBAI:=  __CUSERID //Soli( substr(cUsuario,7,15) )     
             Z55->Z55_STATUS:='B'
             Z55->( msUnlock() )
          endif
          Z55->(dbSkip())
       enddo
    endif

EndIf

Z55->( DbGoTo( nREG ) )

Return


*************

Static Function VALORZ55(cProd)

*************
local nMP:=0
local nValor:=0

DbSelectArea("SX5")
DbSetOrder(1)
If SX5->(DbSeek(xFilial("SX5")+'Z3'+ substr(Dtos(dDataBase),1,6) ))
   if Posicione('SB1',1,xFilial("SB1")+cProd,"B1_PESO" )=0
      alert('O Produto '+alltrim(cProd)+' esta com o Peso Zerado' )    
   else
      nMP:=VAL(SX5->X5_DESCRI) 
      nValor:=Posicione('SB1',1,xFilial("SB1")+cProd,"B1_PESO" )*nMP 
   endif
Else
   alert("Não há um valor válido para a matéria prima do Perido "+substr(Dtos(dDataBase),5,2) +"/"+substr(Dtos(dDataBase),1,4) )    
   Return nValor
Endif              

Return nValor
                      
         
***************

Static Function EmailPCP(cNum , cTipo)

***************
oProcess:=TWFProcess():New("AMOSTRA","AMOSTRA")
If Empty(Alltrim(cTipo))
	oProcess:NewTask('Inicio',"\workflow\http\emp01\amostraPCP.html")
Else 
	oProcess:NewTask('Inicio',"\workflow\http\emp01\AmostraEm_Maos.html")  //em mãos
Endif
oHtml   := oProcess:oHtml

oHtml:ValByName("cNum", cNum)
oHtml:ValByName("DtSoli", Z55->Z55_DTSOLI)
oHtml:ValByName("DtNece", Z55->Z55_DTNECE)
oHtml:ValByName("cSoli",alltrim(U_NomeSoli(Z55->Z55_NOMSOL)) ) 
oHtml:ValByName("cClient", ALLTRIM(Posicione('SA1',1,xFilial("SA1")+Z55->Z55_CLIENT,"A1_NREDUZ" )))   
oHtml:ValByName("cLoja", Z55->Z55_LOJA)
oHtml:ValByName("cLocal", ALLTRIM(Posicione('SX5',1,xFilial("SX5")+'ZZ'+Z55->Z55_LOCALI,"X5_DESCRI" )))  
oHtml:ValByName("cTransp", ALLTRIM(Posicione('SA4',1,xFilial("SA4")+Z55->Z55_TRANSP,"A4_NREDUZ" )))  

	
aadd( oHtml:ValByName("it.cProd" ) , Z55->Z55_PROD)
		
aadd( oHtml:ValByName("it.cDesc") , Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_DESC") )
		
aadd( oHtml:ValByName("it.cUM") , Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_UM"))

aadd( oHtml:ValByName("it.cQtdSoli") , transform(Z55->Z55_QDTSOL,"@E 999999.9999") )
		




_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)

If Empty(Alltrim(cTipo))
	oProcess:cTo := "pcp@ravaembalagens.com.br"
Else
	cNomeUser := ""
	cMailUser := "" //email do usuário logado
	cDepto    := "" //depto do usuário logado
	aUsuarios := {}
	PswOrder(1)
	If PswSeek( __CUSERID, .T. )
	   aUsuarios  := PSWRET() 					
	   if !empty(aUsuarios[1][2])
	   		cNomeUser := Alltrim(aUsuarios[1][4])     	// Nome completo do usuário
	   		cDepto    := Alltrim(aUsuarios[1][12])     	// Nome do usuário
	      	cMailUser := Alltrim(aUsuarios[1][14])     	// Email do usuário
	   endif
	Endif
	//assinatura no fim do Email:
	oHtml:ValByName("cNomeUser", cNomeUser) //nome
	oHtml:ValByName("cDepto", cDepto)       //depto
	oHtml:ValByName("cMailUser", cMailUser) //endereço de email
	
   	oProcess:cTo := cMailUser
   	//oProcess:cTo := ";flavia.rocha@ravaembalagens.com.br" //retirar depois

Endif
subj	:= "Solicitação de Amostra - "+cNum
oProcess:cSubject  := subj
oProcess:Start()
WfSendMail()


Return  



***************

Static Function FATC008(cLocaliz,cClient,cLoja) 

***************

Local  cUF:=''

if !empty(cLocaliz)
	DbSelectArea("SX5")
	DbSetOrder(1)
	If SX5->( dbSeek( xFilial( "SX5" ) + "ZZ"+cLocaliz , .t. ) )
	   
	   DbSelectArea("SA1")
	   DbSetOrder(1)
	   SA1->(DbSeek(xFilial("SA1")+cClient+cLoja))   
       cUF:=SA1->A1_EST
       
	   IF SUBSTR(SX5->X5_DESCRI,AT('(',SX5->X5_DESCRI)+1,2)!=ALLTRIM(cUF)
		   ALERT('O Estado( '+SUBSTR(SX5->X5_DESCRI,AT('(',SX5->X5_DESCRI)+1,2) + ' )da Localizacao nao bate com o Estado( '+ALLTRIM(cUF)+ ' )do Cliente'   )
		   Return .F. 
	   ENDIF
	endif
endif

Return .T.          


*************
User  Function ALIBTRANS(cLocal)
*************
//Private lRet:=.F. 

	//posiciona na tab. de LOCALIDADExTRANSportadora
	DbSelectArea("SZZ")
	DbSetOrder(2) 
	if SZZ->(DbSeek(xFilial("SZZ")+cLocal))     
		//local cLocal:=M->C5_LOCALIZ
		
		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		Private coTbl1
		//Private lRet:=.F.
		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Declaração de Variaveis Private dos Objetos                             ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		SetPrvt("oDlgL","oBrw2","oBtn1")
		
		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Definicao do Dialog e todos os seus componentes.                        ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		oDlgL      := MSDialog():New( 148,385,347,853,"Transportadora",,,.F.,,,,,,.T.,,,.F. )
		oTbl1()
		DbSelectArea("TMP")
		oBrw2      := MsSelect():New( "TMP","","",{{"TRANSP","","Codigo",""},;
		{"NOME","","Nome",""}},.F.,,{004,003,064,227},,, oDlgL )
		oBtn1      := TButton():New( 072,190,"Ok",oDlgL,,037,012,,,,.T.,,"",,,,.F. )
		oBtn1:bAction := {||conftrans()}
		
		TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA
		
		DbSelectArea("SA4" )
		DbSetOrder(1)
	
		while SZZ->(!EOF()) .AND. SZZ->ZZ_LOCAL = cLocal
			If SA4->(DbSeek(xFilial("SA4")+SZZ->ZZ_TRANSP,.F.))
				If A4_ATIVO!='N'
					If SZZ->ZZ_ATIVO != 'N'
						RecLock("TMP",.T.)
						TMP->TRANSP	:= SZZ->ZZ_TRANSP
						TMP->NOME	:= SA4->A4_NOME //POSICIONE("SA4", 1, xFilial("SA4") +SZZ->ZZ_TRANSP , "A4_NOME" )
						TMP->(MsUnLock())
					EndIf
				EndIf
			Endif
			SZZ->(dbskip())
			
		EndDo
		
		IF !EMPTY(cLocal)
			RecLock("TMP",.T.)
			TMP->TRANSP:='024' // O Mesmo
			TMP->NOME:=POSICIONE("SA4", 1, xFilial("SA4") +'024' , "A4_NOME" )
			TMP->(MsUnLock())
		ENDIF
		
		TMP->( DbGotop() )
		
		oBrw2:oBrowse:Refresh()
		
		oDlgL:Activate(,,,.T.)
		
		TMP->(DBCloseArea())
		Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO
	

	Else
  		alert('Escolha a Localidade para a transportadora!!!!')
  		// lRet:=.T.
	EndIF

Return  .T. //lRet      

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

If Select("TMP") > 0
  DbSelectArea("TMP" )
  TMP->(DbCloseArea())
EndIf


Aadd( aFds , {"TRANSP"  ,"C",006,000} )
Aadd( aFds , {"NOME"    ,"C",040,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 


***************

Static Function conftrans()

***************

//M->C5_TRANSP:=TMP->TRANSP
cTransp:=TMP->TRANSP 
DBSELECTAREA('Z55')
oDlgL:End()

Return         


*************

Static Function  VLDTRANSP(cLocal,cTransp) 

*************             

If alltrim(cTransp) $ "024"   
   return .T.
endIf

//If !empty(M->C5_LOCALIZ) .and. !empty(M->C5_TRANSP)
   DbSelectArea("SZZ")
   DbSetOrder(1) 
   If ! SZZ->( dbSeek( xFilial("SZZ") + cTransp + cLocal,.F.) )
       alert('A transportadora '+ALLTRIM(POSICIONE("SA4", 1, xFilial("SA4") +cTransp , "A4_NOME" ) )+' nao entrega nessa localidade '+ALLTRIM(POSICIONE("SX5", 1, xFilial("SX5") +'ZZ'+cLocal , "X5_DESCRI" ) ) )
       return .F.
   Else
       If SZZ->ZZ_ATIVO='N'  // inativa
          ALERT('Transportadora X Localidade nao esta Ativa!!!' )
          return .F.
       Endif
   endif
//endif   
   
Return .T. 



***************

Static Function ESTLICITA( cPROD1, cLOCAL)

***************

Local nQUANT:=0

nQUANT := Posicione( "SB2", 1, xFilial( "SB2" )+cPROD1+cLOCAL,"SB2->B2_QATU" )

Return nQUANT


***************

User Function PRODNOR( cPROD1)

***************

IF Len( AllTrim( cPROD1 ) ) >= 8
    Alert('O Produto Informado Nao e Valido!!!' )
    Return .F.
ENDIF

Return .T.


***************

Static function SALDORES( cProd1 )

***************

local nQuant := 0
local cQuery
local cProd2

cALIASANT := Alias()

if ! Empty( cPROD1 )
	if Len( AllTrim( cPROD1 ) ) <= 7
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
	else
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
	endif
	
	cQuery := "select sum( C6_QTDRESE ) AS RESERVA "
	cQuery += "from " + retsqlname("SC6") + " SC6, "+ retsqlname("SC5") + " SC5 ,"+ retsqlname("SC9") + " SC9 "
	cQuery += "where C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) "
    cQuery += "AND C5_NUM=C9_PEDIDO "
	cQuery += "AND C6_PRODUTO=C9_PRODUTO  "
//	cQuery += "AND SC9.C9_BLCRED IN ( '  ' )  "
// NOVA LIBERACAO DE CRETIDO
	cQuery += "AND SC9.C9_BLCRED IN ( '  ','04' )  "
	cQuery += "AND SC9.C9_BLEST <> '10' "
 	cQuery += "AND C6_QTDENT < C6_QTDVEN  "
    cQuery += "AND C6_QTDRESE > 0  "
	cQuery += "AND C6_BLQ <> 'R'  "
	cQuery += "AND SC6.D_E_L_E_T_ = ' ' "
 	cQuery += "AND SC5.D_E_L_E_T_ = ' ' "
    cQuery += "AND SC9.D_E_L_E_T_ = ' ' "
	
	TCQUERY cQuery NEW ALIAS "C6X"
	DbSelectArea("C6X")
	nQuant := C6X->RESERVA
	C6X->(DbCloseArea())
endif

DbSelectArea(cALIASANT)

return nQuant


*************

User Function VZ55PROD(cProd)

************* 

local nPosNota := aScan(aHeader,{|x| Alltrim(x[2]) == "Z55_PROD" })  

if n!=1
	for _x:=len(aCols)  To 1 Step -1 
		if _x!=n
			if aCols[_x][nPosNota]=cProd
				alert("O Produto nao pode se repetir")
				return .F.
			endif
	    endif
	next _x
endif

return .T.


*************

Static Function fSaldo(cProd,nQtdSol)

************* 

local cQry:=''


cQry:="SELECT * FROM SB2020 SB2 "
cQry+="WHERE "
cQry+="B2_COD='"+cProd+"' "
cQry+="AND B2_FILIAL='"+XFILIAL('SB2')+"' "
cQry+="AND B2_LOCAL='03'  " // AMOSTRA
cQry+="AND SB2.D_E_L_E_T_<>'*'   "

TCQUERY cQry NEW ALIAS "_SB2X" 

If _SB2X->(!EOF()) // existe no armazem de amostra 
   If nQtdSol>_SB2X->B2_QATU
      _SB2X->(dbclosearea())
      return .F.
   Endif
Else
      _SB2X->(dbclosearea())
      return .F.
Endif

_SB2X->(dbclosearea())
      
Return .T.

****************

User function fTransf()

****************

local cQry:=''
local nQtdAmo:=Posicione( "SB2", 1, xFilial( "SB2" )+Z55->Z55_PROD+'03',"SB2->B2_QATU" ) 
Local lMsErroAuto := .T.
//Local aAreaZ55	:= Z55->(GetArea())                                    
local nQtdDif:=0
local aMATRIZ:={}
local aMATRIZb:={}

if !EMPTY(Z55->Z55_STATUS)
   If Z55->Z55_STATUS='X'
      alert("O Produto "+alltrim(Z55->Z55_PROD)+" dessa Solicitação de amostra "+ALLTRIM(Z55->Z55_NUM)+" ja foi enviado para o PCP. " )
   ElseIf Z55->Z55_STATUS='B'
      alert("O Produto "+alltrim(Z55->Z55_PROD)+" dessa Solicitação de amostra "+ALLTRIM(Z55->Z55_NUM)+" ja foi Baixado. " )
   endif
   return 
Endif


If ! u_senha2("22",1)[1] // apenas a senha de Adriano Paz 
     Return 
endif

cQry:="SELECT * FROM SB2020 SB2 "
cQry+="WHERE "
cQry+="B2_COD='"+Z55->Z55_PROD+"' "
cQry+="AND B2_FILIAL='"+XFILIAL('SB2')+"' "
cQry+="AND B2_LOCAL='01'  " // padrao
cQry+="AND SB2.D_E_L_E_T_<>'*'   "

TCQUERY cQry NEW ALIAS "_SB2Y" 

If _SB2Y->(!EOF()) // existe no armazem de PADRAO
//   If Z55->Z55_QDTSOL>nQtdAmo
      nQtdDif:=Z55->Z55_QDTSOL//-nQtdAmo
      If nQtdDif <= _SB2Y->B2_QATU
	      Begin Transaction
		        lMsErroAuto:=.F.
		        aMATRIZb := {   {"D3_TM",'504',NIL},;
		                        { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
		                        { "D3_FILIAL", xFilial( "SD3" ), NIL},;
		                        { "D3_LOCAL",'01', NIL },;
		                        { "D3_COD", Z55->Z55_PROD, NIL},;
		                        { "D3_UM", Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_UM") , NIL },;
		                        { "D3_QUANT", nQtdDif, NIL },;
		                        { "D3_EMISSAO", dDataBase, NIL} } 
		        MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZb, 3 )
		        If lMsErroAuto
		           MostraErro()
		           DisarmTransaction()
		           Return 
		        ENDIF	  
		  	    //
		  	    DbSelectArea('SB2')
		  	    DbSetOrder(1)
		  	    if ! SB2->(DbSeek(xFilial("SB2")+Z55->Z55_PROD+'03' ))   
		  	         fCriaSb2()
		  	    Endif   	  	    
		  	    // CRIAR NO SB2 QUANDO O PRODUDO NAO EXISTIR 	  	   	  	    
		  	    //
		  	    lMsErroAuto:=.F.
		        aMATRIZ     := { {"D3_TM",'104',NIL},;
		                        { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
		                        { "D3_FILIAL", xFilial( "SD3" ), NIL},;
		                        { "D3_LOCAL",'03', NIL },;
		                        { "D3_COD", Z55->Z55_PROD, NIL},;
		                        { "D3_UM", Posicione('SB1',1,xFilial("SB1")+Z55->Z55_PROD,"B1_UM") , NIL },;
		                        { "D3_QUANT", nQtdDif, NIL },;
		                        { "D3_EMISSAO", dDataBase, NIL} } 
		        MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
		        If lMsErroAuto
		           MostraErro()
		           DisarmTransaction()
		           Return 
		        EndIf	  	  
		        
		        If ! lMsErroAuto
		           alert('Transferencia realizada com sucesso para o produto '+ alltrim(Z55->Z55_PROD) )
		        Endif
		  End Transaction
	  Else
	      Alert('Saldo Insuficiente( '+alltrim(str(_SB2Y->B2_QATU))+' ). Favor Solicitar para o PCP Produzir para o produto '+ alltrim(Z55->Z55_PROD) )
	  EndIf
 //  Else
 //     Alert('Nao a Necessidade de Transferencia para o produto '+ alltrim(Z55->Z55_PROD))
 //  Endif
Else
   Alert('Favor Solicitar para o PCP Produzir para o produto '+ alltrim(Z55->Z55_PROD) )
Endif

_SB2Y->(dbclosearea())

//RestArea(aAreaZ55) 

Return 


*************

Static  Function fTelaS()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private coTbl2

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgL","oBrw1","oGrp1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlgL     := MSDialog():New( 127,254,622,697,"",,,.F.,,,,,,.T.,,,.F. )
oTbl2()
DbSelectArea("TMP2")
oBrw1      := MsSelect():New( "TMP2","","",{{"CODIGO","","Codigo",""},;
{"QTDSOL","","Qtd. Solc.",""},{"QTDEST","","Qtd. Est. Amostra",""}},.F.,,{006,009,221,209},,, oDlgL ) 
oGrp1      := TGroup():New( 000,004,227,214,"",oDlgL,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 230,177,"&Ok",oDlgL,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction:={|| oDlgL:END()}

GetLegen()
oDlgL:cCaption:='Saldo Estoque Amostra'
oDlgL:Activate(,,,.T.)

TMP2->(DBCloseArea())  
Ferase(coTbl2) // APAGA O ARQUIVO DO DISCO


Return


****************

Static Function oTbl2()

***************

Local aFds := {}

Aadd( aFds , {"CODIGO"  ,"C",015,000} )
Aadd( aFds , {"QTDSOL"  ,"C",015,000} )
Aadd( aFds , {"QTDEST"  ,"C",015,000} )

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive
Return 


***************

Static Function GetLegen()

***************

TMP2->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 

for _Z:=1 to len(aSaldo)
     RecLock("TMP2",.T.)			     
     TMP2->CODIGO:=aSaldo[_Z][1]
     TMP2->QTDSOL:=transform(aSaldo[_Z][2],'@E 999999.9999')
     TMP2->QTDEST:=transform(aSaldo[_Z][3],'@E 999999.9999')
     TMP2->(MsUnlock())
Next

TMP2->(DBGOTOP())

Return


***************

Static Function fCriaSb2()

***************

RecLock("SB2",.T.)
SB2->B2_FILIAL:=XFILIAL('SB2')
SB2->B2_COD:=Z55->Z55_PROD
SB2->B2_LOCAL:='03' // AMOSTRA 
SB2->(MsUnlock())

Return 

**************************************
Static Function GetLocCli(cCli , cLj) 
**************************************

Local cLoc := ""

SA1->(Dbsetorder(1))
SA1->(Dbseek(xFilial("SA1") + cCli + cLj) )
cLoc := SA1->A1_COD_MUN  

Return(cLoc)