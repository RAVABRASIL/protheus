#Include "RwMake.ch"
#INCLUDE "TOPCONN.CH"

*************
User Function PESAPARA(xxOP)
*************

Private nSay1 := 0
Private cCBox1
Private aItemsEX := {"   ","Teste","Setup","Furo de Balao","Troca de Tela","Falta/Queda de Energia"}
Private aItemsCS := {"   ","Amostras/Teste em maquina","Revisão de material","Defeito bobina","Falta/Queda de Energia","Impressão","Refile","Processo","Solda Continua","Falha no Cabecote"}
//Private aItemsCS := {"   ","Amostras/Teste em maquina","Revisão de material","Defeito bobina","Falta/Queda de Energia","Impressão"}
/*
Motivo de Apara:

Extrusao
EX02 - Teste
EX03 - Setup
EX04 - Furo de Balao
EX05 - Troca de Tela
EX06 - Falta/Queda de Energia

Corte Solda
CS02 - Amostras/Teste em maquina
CS03 - Revisao de material
CS04 - Defeito bobina
CS05 - Falta/Queda de Energia
CS06 - Impressao
*/

SetPrvt( "oBtnLer, nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cPORTA, nHandle, cNOMEO, oNOMEO, oTIPO, cTIPO, aTIPO, oOPERAD, cOPERAD, aOPERAD, aCODOPE, cNMEXT, " )

DbSelectArea("SC2")
DbSelectArea("SB1")
DbSelectArea("SB5")
DbSelectArea("SH1")
//DbSelectArea("SRA")

SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB5->( DbSetOrder( 1 ) )
SH1->( DbSetOrder( 1 ) )
//SRA->( DbSetOrder( 1 ) )

nHANDLE   := -1
cPORTABAL := "4"
cPORTAIMP := "3"

aIMP      := {}
cTIPO     := " "
cOPERAD   := Space( 6 )
cNOMEO    := Space( 30 )
nPESO     := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
nQUANT    := 1
lEXTRUSAO := .F.

@ 000,000 TO 145,430 Dialog oDLG1 Title "Pesagem de aparas"
@ 011,005 Say "OP:"
@ 010,020 Get cOP Object oOP Size 50,40 F3 "SC2" Valid PesqOp()
@ 011,080 Say "Tipo:"
@ 011,095 Say cTIPO Size 80,40 OBJECT oTIPO
@ 011,155 Say "Maquina:"
//@ 010,180 Get cMAQ Object oMAQ Size 30,40 F3 "SH1" Valid PesqMaq()
@ 010,180 Get cMAQ Object oMAQ Size 30,40 F3 "SH1B" Valid PesqMaq()

oEXTRUSAO           := TCHECKBOX():Create( oDlg1 )
oEXTRUSAO:cName     := "oEXTRUSAO"
oEXTRUSAO:cCaption  := "&Extrusao?"
oEXTRUSAO:nLeft     := 015
oEXTRUSAO:nTop      := 062
oEXTRUSAO:nWidth    := 79
oEXTRUSAO:nHeight   := 17
oEXTRUSAO:lShowHint := .F.
oEXTRUSAO:lReadOnly := .F.
oEXTRUSAO:Align     := 0
oEXTRUSAO:cVariable := "lEXTRUSAO"
oEXTRUSAO:bSetGet   := {|u| If(PCount()>0,lEXTRUSAO:=u,lEXTRUSAO) }
oEXTRUSAO:lVisibleControl := .T.
oEXTRUSAO:bChange    := {|| ValidExtru() }

@ 031,050 Say "Operador:"
//@ 030,080 Get cOPERAD Object oOPERAD Size 30,40 F3 "SRAEX" VALID lExtrusao .and. NaoVazio() .and. ExistCpo("SRA", cOperad )
@ 030,080 Get cOPERAD Object oOPERAD Size 30,40 F3 "SRAEX" VALID lExtrusao .and. NaoVazio() .and.;
iif( ExistCpo("SRA", cOperad ),  chkUser(), .F. )

oOPERAD:Disable()

Say1 := TSay():Create(oDlg1)
Say1:cCaption := 'Motivo Apara:'
Say1:cName := 'Say1'
Say1:cVariable := 'nSay1'
Say1:lActive := .T.
Say1:lShowHint := .F.
Say1:nHeight := 13
Say1:nLeft := 232
Say1:nTop := 60
Say1:nWidth := 68
Say1:bSetGet := {|u| If(PCount()>0,nSay1:=u,nSay1) } 

CBox1 := TComboBox():Create(oDlg1)
CBox1:aItems := aItemsCS
CBox1:cCaption := 'CBox1'
CBox1:cName := 'CBox1'
CBox1:cVariable := 'cCBox1'
CBox1:lActive := .T.
CBox1:lShowHint := .F.
CBox1:nAt := 1
CBox1:nHeight := 21
CBox1:nLeft := 304
CBox1:nTop := 57
CBox1:nWidth := 121
CBox1:bSetGet := {|u| If(PCount()>0,cCBox1:=u,cCBox1) }
CBox1:bChange  := {|| ValidCombo() }

//@ 029,108 Button "..."     Size 010,012 ACTION { cOPERAD := U_BuscaFun(1), PesqOperad() }
@ 031,120 Say cNOMEO Size 100,40 OBJECT oNOMEO

oBtnLer := TBUTTON():Create(oDlg1)
oBtnLer:cName := "oSBtnLer"
oBtnLer:cCaption := "Ler balanca"
oBtnLer:nLeft := 075
oBtnLer:nTop := 110
oBtnLer:nWidth := 80//53
oBtnLer:nHeight := 30//23
oBtnLer:lShowHint := .F.
oBtnLer:lReadOnly := .F.
oBtnLer:Align := 0
oBtnLer:lVisibleControl := .T.
oBtnLer:bLClicked := {|| Pegar() }
oBtnLer:Disable()

@ 055,095 Button "_Reimp.etiq." Size 50,15 Action Reimprime()
@ 055,165 BMPButton Type 2 Action Close( oDLG1 )

if !empty(xxOP)
	cOP	:= xxOP
	lEXTRUSAO := .T.
	oEXTRUSAO:Disable()
	ValidExtru()
endIf

Activate Dialog oDLG1 Centered

Return

***************
Static Function Pegar()
***************

cDLL    := "toledo9091.dll"
nHandle := ExecInDllOpen( cDLL )
/* chamado 001652 e 001669 
if (CBox1:nAt = 7 .OR. CBox1:nAt = 8) .AND. !alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
   alert('Esse motivo so pode para uma maquina de Caixa') 
   oBtnLer:Disable()
   CBox1:nAt := 1
   ObjectMethod( CBox1, "SetFocus()" )  
   Return NIL
else
*/
if (CBox1:nAt != 7 .and. CBox1:nAt != 8) .AND. alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
   alert('Esse motivo so pode para uma maquina de Saco' ) 
   oBtnLer:Disable()
   CBox1:nAt := 1
   ObjectMethod( CBox1, "SetFocus()" )  
   Return NIL
EndIf

if nHandle = -1
	MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	Return NIL
EndIf

//Parametro 1 = Porta serial do indicador
cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
cPESO   := Left( cRETDLL, rat( ",", cRETDLL ) - 1 )
nPESO   := Val( Strtran( cPESO, ",", "." ) )

ExecInDLLClose( nHandle )

Grava()

Return NIL

***************
Static Function Grava()
***************

Private aArret := {}     

aIMP := {}
If nPESO <= 0
	 MsgAlert( "Erro na leitura do peso" )
	 Return NIL
EndIf

/*If  ( (  Empty( cOP ) .and.  Empty( cMAQ ) ) .or.  Empty( cOPERAD ) )
	 MsgAlert( "Dados obrigatorios nao informados" )
	 Return NIL
EndIf*/

/*05/11/07*/
If  Empty( cOP ) .or.  Empty( cMAQ ) .or. iif( lEXTRUSAO, Empty( cOPERAD ), .F. )
	 MsgAlert( "Dados obrigatorios nao informados" )
	 Return NIL
EndIf
/*05/11/07*/

if !lEXTRUSAO //.and. CBox1:nAt != 2
  aArret := u_senha2( "05", 1, "Validação de usuário pesador de apara de corte." )
  if !aArret[1]
    msgAlert("Você não tem autorização para pesar aparas !")
    oBtnLer:Disable()
    CBox1:nAt := 1
    ObjectMethod( CBox1, "SetFocus()" )  
    Return NIL
  endIf
  
endIf

For nCONT := 1 To nQUANT
    cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
    RecLock( "Z00", .T. )
	Z00->Z00_SEQ    := cSEQ
	Z00->Z00_OP     := cOP
	Z00->Z00_PESO   := nPESO
	Z00->Z00_BAIXA  := "N"
	Z00->Z00_MAQ    := cMAQ
	Z00->Z00_DATA   := Date()
	Z00->Z00_HORA   := Left( Time(), 5 )
	//Z00->Z00_APARA  := If( cTIPO == "APARA MISTA", "1", If( cTIPO == "APARA BRANCA", "2", "3" ) )

    //Comentado por Eurivan 28/01/10 - Chamado 001479 Marcelo
    //Z00->Z00_APARA  := If( cTIPO == "APARA MISTA", "1", If( cTIPO == "APARA BRANCA", "2", If( cTIPO == "APARA AZUL", "4", "3" ) ) )
    
    //Incluido para atender o chamdo 001479 - MArcelo
	if  cTIPO == "APARA AZUL"
	   Z00->Z00_APARA := "A"
	elseif cTIPO == "APARA BRANCA"
	   Z00->Z00_APARA := "B"	  
	elseif cTIPO == "APARA BRANCA HOSP"
	   Z00->Z00_APARA := "Y"
	elseif cTIPO == "APARA DE AL€A"
	   Z00->Z00_APARA := "W"
	elseif cTIPO == "APARA PRETA"
	   Z00->Z00_APARA := "C"
	elseif cTIPO == "APARA VERMELHA"
	   Z00->Z00_APARA := "D"
	elseif cTIPO == "APARA AMARELA"
	   Z00->Z00_APARA := "E"	  
	elseif cTIPO == "APARA VERDE"
	   Z00->Z00_APARA := "F"	  
	elseif cTIPO == "APARA CINZA"
	   Z00->Z00_APARA := "G"	  
	endif   


	Z00->Z00_OPERAD := cOPERAD
	Z00->Z00_NOME   := iif( lEXTRUSAO, posicione("SRA", 1, xFilial("SRA") + cOPERAD, "RA_NOME"), aArret[2] )

    if CBox1:nAt <> 1
       if lExtrusao
          Z00->Z00_MAPAR  := "EX"+StrZero( CBox1:nAt,2 )
       else
          If (CBox1:nAt = 7 .OR. CBox1:nAt = 8) .AND. alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
             Z00->Z00_MAPAR  := "CX"+StrZero( CBox1:nAt,2 )
          else   
             Z00->Z00_MAPAR  := "CS"+StrZero( CBox1:nAt,2 )
          Endif
       endif
    endif 

	Z00->( MsUnlock() )
	ConfirmSX8()
	Z00->( DbCommit() )

	Aadd( aIMP, { "B" + "Rava Embalagens", "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
	If Abre_Impress()
	   Inc_Linha( aIMP[ nCONT, 1 ], .T. )
	   Inc_Linha( aIMP[ nCONT, 2 ], .F. )
	   Inc_Linha( aIMP[ nCONT, 3 ], .F. )
	   Fecha_Impress()
	EndIf
Next

If SC2->C2_RECURSO <> cMAQ
   RecLock( "SC2", .F. )
   SC2->C2_RECURSO := cMAQ
   SC2->( MsUnlock() )
   SC2->( DbCommit() )
EndIf

nPESO     := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
cOPERAD   := Space( 06 )
cNOMEO    := Space( 30 )
cTIPO     := " "
lEXTRUSAO := .F.
ObjectMethod( oNOMEO, "SetText( OemToAnsi( cNOMEO ) )" )
ObjectMethod( oOP, "SetFocus()" )
Return NIL

***************
Static Function PesqOp()
***************

Private lAlca := .F.

lRET := .T.

oExtrusao:Enable()
CBox1:Enable() 
oBtnLer:Disable()   	   	 	   

If "REIMP" $ Upper( oDLG1:oCtlFocus:ccaption )
	 Return lRET
EndIf

If Len( AllTrim( cOP ) ) == 6
	 cOP := Left( cOP, 6 ) + "01001"
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN == cOP
	 If ! SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
			MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
			lRET := .F.
	 EndIf
Else
	 MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	 lRET := .F.
EndIf
If lRET
	 If Left( SC2->C2_PRODUTO, 3 ) == "GUB"
	    If MsgBox( OemToAnsi( "Esta apara ‚ de al‡a?" ), "Escolha", "YESNO" )
	 	   //Solicito senha de supervisor para a pesagem de aparas de Alca
	 	   lRet := U_SENHA2( "8" )[1]
	 	   if ! lRet
	 	      Return .F.
	 	   endif
	 	   lAlca := .T.
	 	   cTIPO := "APARA DE AL€A"
	 	   oExtrusao:Disable()
	 	   CBox1:Disable() 
	 	   CBox1:nAT := 1            
           oBtnLer:Enable()   	   
		Else
    	   cTIPO := "APARA BRANCA"
		EndIf
	 Else
/*
	 	if SubStr( SC2->C2_PRODUTO, 1, 1 ) == "C"//Chamado 000393, feito em 18/02/09 a pedidos de Alexandre e Lindenberg
	 		cTIPO := "APARA MISTA"
	 	ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "B"
	 		cTIPO := "APARA BRANCA"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "A"
 			cTIPO := "APARA AZUL"
	 	Else
	 		cTIPO := "APARA MISTA"
	 	EndIf
*/
	 	//Alterado por Eurivan 28/01/10 - Chamado 001479 - Marcelo
	 	if SubStr( SC2->C2_PRODUTO, 3, 1 ) == "A"//Chamado 000393, feito em 18/02/09 a pedidos de Alexandre e Lindenberg
	 		cTIPO := "APARA AZUL"
	 	ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "B"
	 		if SubStr( SC2->C2_PRODUTO, 1, 1 ) == "C"
  	 		   cTIPO := "APARA BRANCA HOSP"	 		
	 		else   
	 		   cTIPO := "APARA BRANCA"
	 		endif
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "C"
 			cTIPO := "APARA PRETA"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "D"
 			cTIPO := "APARA VERMELHA"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "E"
 			cTIPO := "APARA AMARELA"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "F"
 			cTIPO := "APARA VERDE"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "G"
 			cTIPO := "APARA CINZA"
	 	EndIf
	 Endif
	 ObjectMethod( oTIPO, "SetText( OemToAnsi( cTIPO ) )" )
	 If ! Empty( SC2->C2_RECURSO )
		cMAQ := SC2->C2_RECURSO
	 EndIf
EndIf

Return lRET

***************
Static Function PesqMaq()
***************

lRET := .T.

If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	 MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	 lRET := .F.
EndIf
If lRET
	
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	 
	If SB1->B1_SETOR=='39' .AND. !alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
       alert("Escolha uma Maquina do processo de Caixa. " )
       Return.F.
    ElseIf SB1->B1_SETOR!='39' .AND. alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
       alert("Escolha uma Maquina do processo de Saco. " )
       Return.F.
    Endif

	 If ! Empty( SC2->C2_RECURSO ) .and. cMAQ <> SC2->C2_RECURSO
		  lRET := u_senha2( "02", 1 )[ 1 ]
	 EndIf
EndIf
If !lEXTRUSAO .AND. (alltrim(cMAQ) $ "E01 E02 E03 E04 " )
	msgAlert("Por favor escolha uma máquina de corte/solda!")
    lRET := .F.
elseIf lEXTRUSAO .AND. (alltrim(cMAQ) $ "C01 C02 C03 C04 C05 C06 C07 C08 EXT I01 I02 P01 P02 CVP DOB ICVR MONT PLAST CX    " )
	msgAlert("Por favor escolha uma máquina de extrusao!")
    lRET := .F.
EndIf


Return lRET

***************
static Function ValidCombo()
***************

local lOk := .T.
//Solicito senha de gerente para pesar Aparas de testes e amostras

if lEXTRUSAO .AND. empty( cOPERAD )
   ObjectMethod( oOPERAD, "SetFocus()" )    
   CBox1:nAt := 1
   return
elseIf empty( cMaq )
   ObjectMethod( oMAQ, "SetFocus()" )    
   CBox1:nAt := 1
   return
endIf


if CBox1:nAt = 2
   lOk := U_SENHA2( "6" )[1]
elseif CBox1:nAt = 1
   lOk := .F.
else 
   lOk := .T.
endif  

/*if CBox1:nAt = 7 .AND. !alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
   alert('Esse motivo so pode para uma maquina de Caixa') 
   lOk := .F.
elseif CBox1:nAt != 7 .AND. alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
   alert('Esse motivo so pode para uma maquina de Saco' ) 
   lOk := .F.
EndIf*/

if lOk
   oBtnLer:Enable()  
else
   oBtnLer:Disable()        
endif   


return

***************
Static Function Abre_Impress()
***************

cDLL    := "impressora451.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	 Return .F.
EndIf
// Parametro 1 = Porta serial da impressora
ExecInDLLRun( nHandle, 1, cPORTAIMP )
Return .T.

***************
Static Function Inc_Linha( cIMP, lPRIMLINHA )
***************

// Parametro 1 = Linha a ser impressa
// Parametro 2 = Limpa buffer
ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )
Return NIL

***************
Static Function Fecha_Impress()
***************

ExecInDLLRun( nHandle, 3, "" )
ExecInDLLClose( nHandle )
Return NIL

***************
Static Function Reimprime()
***************

For nCONT := 1 To Len( aIMP )
		If Abre_Impress()
			 Inc_Linha( aIMP[ nCONT, 1 ], .T. )
			 Inc_Linha( aIMP[ nCONT, 2 ], .F. )
			 Inc_Linha( aIMP[ nCONT, 3 ], .F. )
			 Fecha_Impress()
		EndIf
Next
ObjectMethod( oOP, "SetFocus()" )
Return NIL

***************
Static Function ValidExtru()
***************

if lExtrusao
   CBox1:aItems := aItemsEX
   oOPERAD:Enable()

else
   CBox1:aItems := aItemsCS
   oOPERAD:Disable()
endif      
CBox1:Refresh()
oBtnLer:Disable()           

cOPERAD           := Space( 06 )
cNOMEO            := Space( 30 )
/*iif( lEXTRUSAO, oMAQ:cF3 := 'SH1A', oMAQ:cF3 := 'SH1B' ) //Esse funciona
If lEXTRUSAO //If original
   ObjectMethod( oOPERAD, "SetFocus()" )
EndIf*/
If ( lEXTRUSAO .AND. alltrim(cMAQ) $ "C01 C02 C03 C04 C05 C06 C07 C08 EXT I01 I02 P01 P02 CVP DOB ICVR MONT PLAST CX    " ) .OR. ( lEXTRUSAO .AND. empty(cMAQ) )
   oMAQ:cF3 := 'SH1A'
   cMAQ := Space( 06 )
   ObjectMethod( oMAQ, "SetFocus()" )
ElseIf (!lEXTRUSAO .AND. alltrim(cMAQ) $ "E01 E02 E03 E04 " ) .OR. (!lEXTRUSAO .AND. empty(cMAQ) )
   oMAQ:cF3 := 'SH1B'
   cMAQ := Space( 06 )
   ObjectMethod( oMAQ, "SetFocus()" )
ElseIf lEXTRUSAO
   oMAQ:cF3 := 'SH1A'
Else
   oMAQ:cF3 := 'SH1B'
EndIf

Return NIL                        

***************

Static Function chkUser()

***************

local aArray := u_senha2( "11", 1, "Pesagem de aparas" )

if ! aArray[1]
  cOPERAD := Space( 6 )
  ObjectMethod( oOPERAD, "SetFocus()" )  
  return  
endIf

if  upper(alltrim(aArray[2])) $ posicione("SRA", 1, xFilial("SRA") + cOPERAD, "RA_NOME")
  return .T.
else
  msgAlert("Senha incorreta!")
  cOPERAD := Space( 6 )
  ObjectMethod( oOPERAD, "refresh()" )    
  return .F.
endIf

return 