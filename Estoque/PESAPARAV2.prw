#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch
*************
User Function APARAV2(xxOP)
*************

Private lAlca := .F.
Private nSay1 := 0
Private cCBox1
//Private aItemsEX := {"   ","1-Teste","2-Setup","3-Furo de Balao","4-Troca de Tela","5-Falta/Queda de Energia"}
// atualizado em 19/10/15
Private aItemsEX := {"   ","2-Teste","3-Setup","4-Furo de Balao","5-Troca de Tela","6-Falta/Queda de Energia","7-Problema mecanico","8-Problema eletrico","9-Problema Operacional","10-Ma qualidade da materia prima"}
//Private aItemsCS := {"   ","1-Amostras/Teste em maquina","2-Revisão de material","3-Defeito bobina","4-Falta/Queda de Energia","5-Impressão","6-Refile","7-Processo","8-Solda Continua","9-Falha no Cabecote","10-Setup","11-Emenda Bobinas","12-Problema de Largura","13-Problema Comprimento","14-Solda Fria","15-Solda Quente","16-Problema Teflon","17-Problema de Temperatura","18-Problema Faca","19-Problema ABA","20-Problema Slit","21-Variacao Fotocelula","22-Problema Ruga" }
Private aItemsLA := {"   ","A","B" }
Private aItemsTU := {"Turno 1","Turno 2","Turno 3" }
Private aItemsHO := {"09:00","16:00","23:00"}
Private aItemsCS := {"   ","2-Problema na homogenização","3-variação de espessura",;
                     "4-Largura Menor","5-Emendas","6-Bobinas Rasgada ( manuseio )",;
                     "7-Defeito de tonalidade","8-falha do sleet","9-Planicidade",;
                     "10-Falha na Impressão","11-Falha no tratamento","12-excesso de fita no tubete",;
                     "13-Aba","14-Ajuste Operacional","15-Setup","16-Centralização do Furo","17-Ajuste foto Célula",;
                     "18-Refile","19-Ajuste de manutenção","20-teste","21-Falta de energia","22-Apara de Extrusão"}

/*
=======

>>>>>>> .r1609
Private aItemsCS := {"   ","1-Largura menor","2-Problema na homogeneização","3-Variação de espessura","4-Acerto de material","5-Emendas",;
"6-Bobina rasgada(manuseio","7-Defeito de tonalidade","8-Falha do sleet","11-Aba","15-Excesso de fita durex no tubete",;
"18-Falha de impressão","21-Refile","22-Centralização de furo","23-Planicidade","26-Falha no tratamento",;
"29-Excesso de fita adesiva no tubete","30-Testes","31-Ajuste de manutenção","32-Ajuste Operacional","33-Ajuste fotocélula"}
/*
Private aItemsCS := {"   ","1-Largura menor","2-Problema na homogeneização","3-Variação de espessura","4-Acerto de material","5-Emendas",;
"6-Bobina rasgada(manuseio","7-Defeito de tonalidade","8-Falha do sleet","9-Falha de impressão","10-Variação de comprimento da tarja",;
"11-Aba","12-Cortes na bobina(extrusão)","13-Falha na solda(cabeçote)","14-Ajuste de velocidade da picotadeira","15-Excesso de fita durex no tubete",;
"16-Utilização de tubete fora do padrão","17-Falha no corte da bobina(corte lateral/hamper)","18-Falha de impressão","19-Problema no grampeador",;
"20-Garfo empenado","21-Refile","22-Centralização de furo","23-Planicidade","24-Solda Fria","25-Solda quente","26-Falha no tratamento",;
"27-Temperatura Alta","28-Furo de balão","29-Excesso de fita adesiva no tubete","30-Testes"}
*/


//Private dDataPes := CriaVar("Z00_DATA",.F.,.F.)

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
CS07 - "Refile"
CS08 - "Processo"
CS09 - "Solda Continua"
CS10 - "Falha no Cabecote"
CS11 - "Setup"
CS12 - "Emenda Bobinas"
CS13 - "Problema de Largura"
CS14 - "Problema Comprimento"
CS15 - "Solda Fria"
CS16 - "Solda Quente"
CS17 - "Problema Teflon"
CS18 - "Problema de Temperatura"
CS19 - "Problema Faca"
CS20 - "Problema ABA"
CS21 - "Problema Slit"
CS22 - "Variacao Fotocelula"
CS23 - "Problema Ruga" 
*/

SetPrvt( "oBtnLer, nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cPORTA, nHandle, cNOMEO, oNOMEO, oTIPO, cTIPO, aTIPO, oOPERAD, cOPERAD, aOPERAD, aCODOPE, cNMEXT, oDataPes, oBobina, cBobina " )

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


nValendo:=SuperGetMV("RV_EXTAPA",,.T.)
cAlmoPro:=" "

aIMP      := {}
cTIPO     := " "
cOPERAD   := Space( 6 )
dDataPes  := dDatabase
cNOMEO    := Space( 30 )
nPESO     := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
cBobina   := Space( 12 )
nQUANT    := 1
lEXTRUSAO := .F.
lMudou    :=.F.
//@ 000,000 TO 145,430 Dialog oDLG1 Title "Pesagem de aparas"
@ 000,000 TO 200,560 Dialog oDLG1 Title "Pesagem de aparas"
@ 011,005 Say "OP:"
@ 010,020 Get cOP Object oOP Size 50,40 F3 "SC2" Valid PesqOp()
//@ 011,080 Say "Tipo:"
//@ 011,095 Say cTIPO Size 80,40 OBJECT oTIPO

oEXTRUSAO           := TCHECKBOX():Create( oDlg1 )
oEXTRUSAO:cName     := "oEXTRUSAO"
oEXTRUSAO:cCaption  := "&Extrusao?"
oEXTRUSAO:nLeft     := 200
oEXTRUSAO:nTop      := 23
oEXTRUSAO:nWidth    := 79
oEXTRUSAO:nHeight   := 17
oEXTRUSAO:lShowHint := .F.
oEXTRUSAO:lReadOnly := .F.
oEXTRUSAO:Align     := 0
oEXTRUSAO:cVariable := "lEXTRUSAO"
oEXTRUSAO:bSetGet   := {|u| If(PCount()>0,lEXTRUSAO:=u,lEXTRUSAO) }
oEXTRUSAO:lVisibleControl := .T.
oEXTRUSAO:bChange    := {|| ValidExtru() }

@ 011,157 Say "Maquina:"
//@ 010,180 Get cMAQ Object oMAQ Size 30,40 F3 "SH1" Valid PesqMaq()
@ 010,194 Get cMAQ Object oMAQ Size 30,40 F3 "SH1B" Valid PesqMaq() 

@ 011,240 Say "Lado:"

CBox2 := TComboBox():Create(oDlg1)
CBox2:aItems := aItemsLA
CBox2:cCaption := 'CBox2'
CBox2:cName := 'CBox2'
CBox2:cVariable := 'cCBox2'
CBox2:lActive := .T.
CBox2:lShowHint := .F.
CBox2:nAt := 1
CBox2:nHeight := 011
CBox2:nLeft := 515 //posição para o lado direito e esquerdo
CBox2:nTop := 19   //Posição de baixo pra cima
CBox2:nWidth := 35 //tamanho do get
//CBox2:bSetGet := {|u| If(PCount()>0,cCBox1:=u,cCBox1) }
//CBox2:bChange  := {|| ValidCombo() }


@ 031,050 Say "Operador:"

//	@ 030,080 Get cOPERAD Object oOPERAD Size 30,40 F3 "SRAEX" VALID lExtrusao .and. NaoVazio() .and. ExistCpo("SRA", cOperad )

@ 030,080 Get cOPERAD Object oOPERAD Size 30,40 F3 "SRA" VALID NaoVazio() .and. ExistCpo("SRA", cOperad )//iif( ExistCpo("SRA", cOperad ),  chkUser(), .F. ) valiUser(cOPERAD, cOP) .and.

//@ 030,080 Get cOPERAD Object oOPERAD Size 30,40 F3 "SRAEX" VALID lExtrusao .and. NaoVazio() .and.;
//iif( ExistCpo("SRA", cOperad ),  chkUser(), .F. )

//oOPERAD:Disable()

Say1 := TSay():Create(oDlg1)
Say1:cCaption := 'Motivo Apara:'
Say1:cName := 'Say1'
Say1:cVariable := 'nSay1'
Say1:lActive := .T.
Say1:lShowHint := .F.
Say1:nHeight := 13
Say1:nLeft := 290
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
CBox1:nLeft := 387
CBox1:nTop := 57
//CBox1:nWidth := 121
CBox1:nWidth := 163
CBox1:bSetGet := {|u| If(PCount()>0,cCBox1:=u,cCBox1) }
CBox1:bChange  := {|| ValidCombo() }

//@ 029,108 Button "..."     Size 010,012 ACTION { cOPERAD := U_BuscaFun(1), PesqOperad() }
@ 031,120 Say cNOMEO Size 100,40 OBJECT oNOMEO

@ 053,050 Say "Data:"
@ 053, 080 Get dDataPes Object oDataPes size 30,50 Picture "@D" 

@ 053,162 Say "Turno:"
CBox3 := TComboBox():Create(oDlg1)
CBox3:aItems := aItemsTU
CBox3:cCaption := 'CBox3'
CBox3:cName := 'CBox3'
CBox3:cVariable := 'cCBox3'
CBox3:lActive := .T.
CBox3:lShowHint := .F.
CBox3:nAt := 1
CBox3:nHeight := 011
CBox3:nLeft := 388 //posição para o lado direito e esquerdo
CBox3:nTop := 100  //Posição de baixo pra cima
CBox3:nWidth := 090

@ 071,050 Say "Bobina:"

//	@ 030,080 Get cOPERAD Object oOPERAD Size 30,40 F3 "SRAEX" VALID lExtrusao .and. NaoVazio() .and. ExistCpo("SRA", cOperad )


@ 070,080 Get cBobina Object oBobina Size 50,40 //VALID NaoVazio() .and. valiUser(cOPERAD, cOP) //iif( ExistCpo("SRA", cOperad ),  chkUser(), .F. )

oBtnLer := TBUTTON():Create(oDlg1)
oBtnLer:cName := "oSBtnLer"
oBtnLer:cCaption := "Ler balanca"
oBtnLer:nLeft := 397
oBtnLer:nTop := 146
oBtnLer:nWidth := 80//53
oBtnLer:nHeight := 30//23
oBtnLer:lShowHint := .F.
oBtnLer:lReadOnly := .F.
oBtnLer:Align := 0
oBtnLer:lVisibleControl := .T.
oBtnLer:bLClicked := {|| Pegar() }
oBtnLer:Disable()


//@ 055,095 Button "_Reimp.etiq." Size 50,15 Action Reimprime()
@ 075,247 BMPButton Type 2 Action Close( oDLG1 )

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
If FWCodFil() == "06"
	
	nPESO	:= PesaMan()

Else
	
	cDLL    := "toledo9091.dll"
	nHandle := ExecInDllOpen( cDLL )
	
	//Parametro 1 = Porta serial do indicador
	cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
	cPESO   := Left( cRETDLL, rat( ",", cRETDLL ) - 1 )
	nPESO   := Val( Strtran( cPESO, ",", "." ) )
	
	ExecInDLLClose( nHandle )

EndIf

//nPESO   := 10 


/* chamado 001652 e 001669 
if (CBox1:nAt = 7 .OR. CBox1:nAt = 8) .AND. !alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
   alert('Esse motivo so pode para uma maquina de Caixa') 
   oBtnLer:Disable()
   CBox1:nAt := 1
   ObjectMethod( CBox1, "SetFocus()" )  
   Return NIL
else
*/



IF SUBSTR(cMaq,1,2) $'E0' .AND. !LEXTRUSAO
  
   ALERT("A maquina e Uma Extrusora ,favor marcar como extrusao")
   ObjectMethod( oMAQ, "SetFocus()" )
   Return NIL

ENDIF


IF SUBSTR(cMaq,1,2) $'E0' .AND. !SUBSTR(SC2->C2_PRODUTO,1,2)='PI'
  
   ALERT("A maquina e Uma Extrusora ,favor escolher uma OP cujo produto seja PI!!")
   ObjectMethod( oMAQ, "SetFocus()" )
   Return NIL

ENDIF



IF LEXTRUSAO

	// valida se a maquina e a mesma da extrusora da OP 
	_ExtOP:=fExtruso(substr(cOP,1,6))
	if alltrim(cMaq)<>alltrim(_ExtOP)
	
	   alert('A Maquina '+alltrim(cMaq)+' Escolhida não é a mesma da OP '+alltrim(_ExtOP))
	   ObjectMethod( oMAQ, "SetFocus()" )
	   Return NIL
	
	endif

	if alltrim(cMaq)='E01'
	
	   cAlmoPro:="10"
	
	Elseif alltrim(cMaq)='E02'
	
	   cAlmoPro:="20" 
	
	Elseif alltrim(cMaq)='E03'
	
	   cAlmoPro:= "30"   
	
	Elseif alltrim(cMaq)='E04'
	
	   cAlmoPro:="40"
	
	Elseif alltrim(cMaq)='E05'
	
	   cAlmoPro:="50"
	
	endif
	
	
	if empty(cAlmoPro)
	
	   alert("Problema no Almoxarifado da Extrusora"+alltrim(cMaq) )
		ObjectMethod( oMAQ, "SetFocus()" )
		Return NIL
	
	endif
	

	
	IF nValendo 
		
		if ! PI_SALDO(cOP,SC2->C2_PRODUTO,SC2->C2_QUANT)
			Return NIL
		endif
		
	ENDIF


ENDIF

if CBox1:nAt = 1 .and. !lAlca
   alert('Motivo Nao pode ser Vazio ' ) 
   oBtnLer:Disable()
   CBox1:nAt := 1
   ObjectMethod( CBox1, "SetFocus()" )  
   Return NIL
endif

if (CBox1:nAt != 7 .and. CBox1:nAt != 8) .AND. alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
   alert('Esse motivo so pode para uma maquina de Saco' ) 
   oBtnLer:Disable()
   CBox1:nAt := 1
   ObjectMethod( CBox1, "SetFocus()" )  
   Return NIL
EndIf


if nHandle = -1 .and. FWCodFil() <> "06"
	MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	Return NIL
EndIf


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

aArea	:= getArea()

cCodPro	:= U_fProdBob(SubStr(cBobina,7,6))

if !lEXTRUSAO

	If Alltrim(cBobina) <> ""
		
		   // valida se a OP da bobina é diferente da OP do carrinho 
      IF substr(cBobina,1,6) <>substr(cOP,1,6)		
         alert('A OP da Bobina '+substr(cBobina,1,6)+' esta Diferente da OP do Carrinho '+substr(cOP,1,6))
		 Return NIL
   	  Endif

				
		//Baixa o saldo da bobina
		dbSelectArea("ZB9")
		dbSetOrder(1)
		If ZB9->(dbSeek(xFilial("ZB9") + cCodPro + SubStr(cBobina,7,6)))
		
			If ZB9->ZB9_SALDO - nPeso > 0
			  Begin Transaction
				RecLock("ZB9",.F.)
				
				ZB9->ZB9_SALDO		:= ZB9->ZB9_SALDO - nPeso
		
				ZB9->(MsUnLock())
			
			 	//Baixa o saldo do PI
		        fBaixaPI(cBobina,nPeso) 
			    //
			  End Transaction		
			Else
			
				MsgAlert("Bobina sem Saldo: " + cCodPro + " - " + SubStr(cBobina,7,6) )
		
				aArret := u_senha2( "06", 1, "Usuário autorizado para pesar Apara sem Bobina" )
				if !aArret[1]
			    	msgAlert("Você não tem autorização para pesar aparas sem Bobina !")
			    	oBtnLer:Disable()
			    	CBox1:nAt := 1
			    	ObjectMethod( CBox1, "SetFocus()" )  
			    	Return NIL
			  	EndIf
			
			EndIf
		
		Else
		
			MsgAlert("Bobina não encontrada: " + cCodPro + " - " + SubStr(cBobina,7,6) )
		
			aArret := u_senha2( "06", 1, "Usuário autorizado para pesar Apara sem Bobina" )
			if !aArret[1]
		    	msgAlert("Você não tem autorização para pesar aparas sem Bobina !")
		    	oBtnLer:Disable()
		    	CBox1:nAt := 1
		    	ObjectMethod( CBox1, "SetFocus()" )  
		    	Return NIL
		  	EndIf
		EndIf
	
	Else
	
		aArret := u_senha2( "06", 1, "Usuário autorizado para pesar Apara sem Bobina" )
		if !aArret[1]
			msgAlert("Você não tem autorização para pesar aparas sem Bobina !")
	    	oBtnLer:Disable()
	    	CBox1:nAt := 1
	    	ObjectMethod( CBox1, "SetFocus()" )  
	    	Return NIL
	  	EndIf
	
	EndIf
	
EndIf

RestArea(aArea)

For nCONT := 1 To nQUANT
    cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
    RecLock( "Z00", .T. )
	Z00->Z00_SEQ    := cSEQ
	Z00->Z00_OP     := cOP
	Z00->Z00_PESO   := nPESO
	Z00->Z00_BAIXA  := "S"
	Z00->Z00_MAQ    := cMAQ
	Z00->Z00_DATA   := dDataPes
	Z00->Z00_LADO   := aItemsLA[CBox2:nAt]
	Z00->Z00_HORA   := aItemsHO[CBox3:nAt]
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
	elseif cTIPO == "APARA DE ALCA"
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
	elseif cTIPO == "APARA DE CAPA"
	   Z00->Z00_APARA := "Z"	  
	ELSE
       Z00->Z00_APARA := "*"	  	
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
	
	If SC2->C2_RECURSO <> cMAQ
	   RecLock( "SC2", .F. )
	   SC2->C2_RECURSO := cMAQ
	   SC2->( MsUnlock() )
	   SC2->( DbCommit() )
	EndIf
	

	Aparas(cOP)

	IF LEXTRUSAO	
	
	   IF nValendo 
	
			lMsErroAuto := .F.
			PI_CONSOME(cOP,SC2->C2_PRODUTO,SC2->C2_QUANT)
	
	   ENDIF
	
	ENDIF
	
    
    Msgbox( "APARA inserida com sucesso! ", "Mensagem", "info" )    
    
    
    /*
	Aadd( aIMP, { "B" + "Rava Embalagens", "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
	If Abre_Impress()
	   Inc_Linha( aIMP[ nCONT, 1 ], .T. )
	   Inc_Linha( aIMP[ nCONT, 2 ], .F. )
	   Inc_Linha( aIMP[ nCONT, 3 ], .F. )
	   Fecha_Impress()
	EndIf
	*/
	
Next


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
	    If MsgBox( OemToAnsi( "Esta apara e de alca?" ), "Escolha", "YESNO" )
	 	   //Solicito senha de supervisor para a pesagem de aparas de Alca
	 	   lRet := U_SENHA2( "8" )[1]
	 	   if ! lRet
	 	      Return .F.
	 	   endif
	 	   lAlca := .T.
	 	   cTIPO := "APARA DE ALCA"
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
	 	if SubStr( SC2->C2_PRODUTO, 3, 1 ) == "A" //Chamado 000393, feito em 18/02/09 a pedidos de Alexandre e Lindenberg
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
  		ElseIf Substr( SC2->C2_PRODUTO, 1, 2 ) == "ME"
   			cTipo := "APARA DE CAPA"
	 	EndIf
	 Endif
	 
	 //ObjectMethod( oTIPO, "SetText( OemToAnsi( cTIPO ) )" )
     
     
     
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
		  lRET := U_senha2( "02", 1 )[ 1 ]
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

/*
if CBox1:nAt = 2
   lOk := U_SENHA2( "6" )[1]
elseif CBox1:nAt = 1
   lOk := .F.
else 
   lOk := .T.
endif  

if CBox1:nAt = 7 .AND. !alltrim(cMAQ) $ "CVP DOB ICVR MONT PLAST CX    " 
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
   //oOPERAD:Disable()
   
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

local aArray := U_senha2( "11", 1, "Pesagem de aparas" )

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

***************
Static Function Aparas( cCODX )
***************

local cProd
Local nUSADO := 0

Private aPERDA   := {}
		aHDPERDA := {}

PRIVATE cCusMed := GetMv( "MV_CUSMED" )

Pergunte( "MTA685", .F. )
PRIVATE lParam  := IIf( mv_par01 == 1, .T. , .F. )

If cCusMed == "O"
	PRIVATE nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	PRIVATE lCriaHeader := .T. 	// Para criar o header do arquivo Contra Prova
	PRIVATE cLoteEst  			// Numero do lote para lancamentos do estoque
	dbSelectArea( "SX5" )
	dbSeek( xFilial() + "09EST" )
	cLoteEst := IIF( Found(), Trim( X5Descri() ), "EST " )
	PRIVATE nTotal := 0			// Total dos lancamentos contabeis
	PRIVATE cArquivo			// Nome do arquivo contra prova
EndIf

SX3->( dbSetOrder( 1 ) )
SX3->( dbSeek( "SBC" ) )
While ! SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "SBC"
   IF SX3->( X3USO( SX3->X3_USADO ) ) .And. cNivel >= SX3->X3_NIVEL .And. !(AllTrim(SX3->x3_campo)$"BC_OP") .And. ;
	 	 !(AllTrim(SX3->x3_campo)$"BC_OPERAC") .And. !(AllTrim(SX3->x3_campo)$"BC_RECURSO/BC_QTSEGUM/BC_QTDES2/BC_QTDDES2/BC_CC/BC_CODLAN/BC_OBSERVA")  .And. ;
		 !(AllTrim(SX3->x3_campo)$"BC_NUMSEQ") .And. !(AllTrim(SX3->x3_campo) == "BC_SEQSD3")
  	  nUsado++
	    AADD( aHDPERDA,{ Trim( SX3->( X3Titulo() ) ), ;
		  							SX3->X3_CAMPO,;
			  						SX3->X3_PICTURE, ;
				  					SX3->X3_TAMANHO, ;
					  				SX3->X3_DECIMAL, ;
						  			"AllwaysTrue()" , ;
							  		SX3->X3_USADO,;
								    SX3->X3_TIPO, ;
								    SX3->X3_ARQUIVO,;
								    SX3->X3_CONTEXT } )
   EndIF
   SX3->( DbSkip() )
Enddo

if Z00->Z00_APARA == "A"
   cPROD := "190"
elseif Z00->Z00_APARA == "Y" //BRANCO HOSPITALAR
   cPROD := "195"
elseif Z00->Z00_APARA == "W" //BRANCO ALCA DE SACOLA
   cPROD := "187"
elseif Z00->Z00_APARA == "B"	  
   cPROD := "188"
elseif Z00->Z00_APARA == "C"	  
   cPROD := "189"
elseif Z00->Z00_APARA == "D"	  
   cPROD := "192"
elseif Z00->Z00_APARA == "E"	  
   cPROD := "193"
elseif Z00->Z00_APARA == "F"	  
   cPROD := "191"
elseif Z00->Z00_APARA == "G"	  
   cPROD := "194"
elseif Z00->Z00_APARA == "Z"	  
   cPROD := "350"
elseif Z00->Z00_APARA == "*"	  
   cPROD := "189"
endif   

//If( Z00->Z00_APARA == "1", "189            ", If( Z00->Z00_APARA == "2", "188            ", If( Z00->Z00_APARA == "4", "190            ", "187            " ) ) ), ;

aPERDA := { { SC2->C2_PRODUTO, ;
	        "01", ;
		    "S", ;
		    "IP", ;
			"INERENTE AO PROCESSO", ;
		    Z00->Z00_PESO, ;
		    cProd, ;
		    "01", ;
		    Z00->Z00_PESO, ;
		    Date(), ;
		    Z00->Z00_OPERAD, ;
			Space( 10 ), ;
			Space( 06 ), ;
			Ctod( "  /  /  " ), ; 
			Space( 15 ), ;
			Space( 20 ), ;
			Space( 15 ), ;
			Space( 20 ), ;
  	        Space( 15 ), ;
			Ctod( "  /  /  " ), ;
			.F. } }
//If( Z00->Z00_APARA == "1", "189            ", If( Z00->Z00_APARA == "2", "188            ", "187            " ) ), ;
GravaSBC( Left( cCODX, 11 ), "", Z00->Z00_MAQ, "MATA685" )


Return

/*Função pra validar o Operador do Processo de Apara*/
Static Function valiUser(cMatricu, cOrdProd)

Local lRet   := .F.
Local cAux   := ""
Local cQuery := ""

cQuery := "SELECT TOP 1 ZZ2_MAT FROM ZZ2020 WHERE D_E_L_E_T_ = '' AND ZZ2_OP = '"+ alltrim(cOrdProd) +"' "
//cQuery += "ZZ2_MAT = '" + alltrim(cMatricu) + "' AND ZZ2_OP = '"+ alltrim(cOrdProd) +"' "
MemoWrite("C:\Temp\valiUser.sql",cQuery)

TCQUERY cQuery NEW ALIAS "TEMP"

TEMP->(DbGoTop())

cAux := TEMP->ZZ2_MAT
 
    if (cAux = alltrim(cMatricu))
    	TEMP->(DbCloseArea())
		Return .T.
    endif
       
    if lExtrusao = .T.
		TEMP->(DbCloseArea())
		Return .T.
	Endif
    
	if empty(TEMP->ZZ2_MAT)
		TEMP->(dbclosearea())
		Return .T.
	endif

WHILE (cAux <> alltrim(cMatricu))
	
 	If lRet = .f.
		Alert("Operador Inválido... " + "A Matrícula do Operador dessa Op é: " + cAux)
		TEMP->(DbCloseArea())
		Return lRet
	
	Endif            

EndDo

TEMP->(DbCloseArea())

Return lRet

//-----------------------------------------------
//Função pra pegar o codigo do produto da bobina*/
//-----------------------------------------------

User Function fProdBob(cSeq)

Local cRet   := ""
Local cQuery := ""

cQuery := "SELECT * FROM ZB9020 WHERE D_E_L_E_T_ <> '*' AND ZB9_SEQ = '"+ alltrim(cSeq) +"' "

TCQUERY cQuery NEW ALIAS "XB9"

XB9->(DbGoTop())

If XB9->ZB9_COD <> ''
	cRet	:= XB9->ZB9_COD 
EndIf

XB9->(dbCloseArea())

Return cRet

//fim
 
***************

Static Function fExtruso(cNumOP)

***************

local cQry:=''
local cRet:=""


cQry:="SELECT C2_EXTRUSO FROM "+ RetSqlName( "SC2" ) +" SC2  WHERE C2_NUM='"+cNumOP+"' AND C2_ITEM='01' AND C2_SEQUEN='001' AND D_E_L_E_T_=''  "

If Select("AUXX") > 0
	DbSelectArea("AUXX")
	AUXX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUXX"

IF AUXX->(!EOF())

   cret:=AUXX->C2_EXTRUSO

ENDIF

AUXX->(DBCLOSEAREA())

Return cret 


***************

Static Function PI_SALDO(cNUMOP,cCod,nQtdPi)

***************

local cQry:=''
local nSaldo:=0


cQry:="SELECT D4_OP,D4_COD,D4_QTDEORI FROM SD4020 "
cQry+="WHERE D4_OP='"+cNUMOP+"' "
cQry+="AND D_E_L_E_T_='' "

If Select("TMPS") > 0
  DbSelectArea("TMPS")
  TMPS->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPS"

If ! TMPS->( Eof() )  

   Do While ! TMPS->( Eof() )        
                                
       _nPerc:= TMPS->D4_QTDEORI/nQtdPi
       _nSaldo:=Saldo(TMPS->D4_COD)
       
       if  nPeso * _nPerc >  _nSaldo           

          alert( alltrim(cCod)+' Qtd: '+cvaltochar(nQtdPi)+chr(13)+;
                 alltrim(TMPS->D4_COD)+' Qtd: '+cvaltochar(TMPS->D4_QTDEORI)+chr(13)+;          
                 'Percentual--> '+cvaltochar(_nPerc)+chr(13)+;
                 'Peso--> '+cvaltochar(nPeso)+chr(13)+;
                 'Qtd a Consumir--> '+cvaltochar(nPeso*_nPerc)+chr(13)+;
                 'Saldo--> '+cvaltochar(_nSaldo)+chr(13)+;
                 'Extrusora--> '+alltrim(cMaq)+chr(13)+;
                 'Almoxarifado--> '+alltrim(cAlmoPro) )                                 

          return .F.

       endif
   
      TMPS->(dbskip())
   Enddo 

ELSE

   ALERT('OP '+alltrim(cNUMOP)+' não Teve Empenho' )
   return .F.

EndIf

TMPS->(DbCloseArea())
  
Return .T.


***************

Static Function SALDO(cCod)

***************

local cQry:=''
local nRet:=0


cQry:="SELECT B2_COD,B2_QATU,* "
cQry+="FROM SB2020 SB2 "
cQry+="WHERE B2_COD='"+cCod+"' "
cQry+="AND B2_FILIAL='"+xFilial('SB2')+"'  "
cQry+="AND B2_LOCAL='"+cAlmoPro+"'  "
cQry+="AND SB2.D_E_L_E_T_!='*'  "


If Select("TMPP") > 0
  DbSelectArea("TMPP")
  TMPP->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TMPP"

If ! TMPP->( Eof() )  
   nRet:=TMPP->B2_QATU
Endif

TMPP->(DbCloseArea())
                      
Return nRet



***************

Static Function PI_CONSOME(cNUMOP,cCod,nQtdPi)

***************

local cQry:=''
local nSaldo:=0
LOCAL aMATRIZC:={}

cQry:="SELECT D4_OP,D4_COD,D4_QTDEORI FROM SD4020 "
cQry+="WHERE D4_OP='"+cNUMOP+"' "
cQry+="AND D_E_L_E_T_='' "

If Select("TMPS") > 0
  DbSelectArea("TMPS")
  TMPS->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TMPS"


If ! TMPS->( Eof() )  
   Do While ! TMPS->( Eof() )        
   
   _nPerc:= TMPS->D4_QTDEORI/nQtdPi   
   
    aMATRIZC     := { { "D3_TM"  , "504"                                                          , ""},;
                 { "D3_DOC"      , NextNumero( "SD3", 2, "D3_DOC", .T. )                          , NIL},;
                 { "D3_FILIAL"   , xFilial( "SD3" )                                               , NIL},;
                 { "D3_OP"       ,cNUMOP                                                          , NIL },;
                 { "D3_LOCAL"    , cAlmoPro                                                       , NIL },;
                 { "D3_COD"      , TMPS->D4_COD                                                   , NIL},;
                 { "D3_UM"       , Posicione( "SB1", 1, xFilial("SB1") + TMPS->D4_COD , "B1_UM" ) , NIL },;
                 { "D3_QUANT"    ,nPESO*_nPerc                                                    , NIL },;
                 { "D3_EMISSAO"  , Date()                                                         , NIL},; 
                 { "D3_OBS"      , "APARA PI_CONSOME"                                             , NIL}}


    MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZC, 3 )
	IF lMsErroAuto

		DisarmTransaction()
		MostraErro()
        return .F.

	Endif

      TMPS->(dbskip())

   Enddo 

ELSE

   ALERT('OP '+alltrim(cNUMOP)+' não Teve Empenho' )
   return .F.

EndIf

TMPS->(DbCloseArea())
  
Return .T.


***************

Static Function fBaixaPI(cBobina,nPeso)

***************

local cQry:=''
local nSaldo:=0
LOCAL aMATRIZC:={}

lMsErroAuto := .F.
	       
cQry:="SELECT Z00_SEQ,C2_PRODUTO,Z00_OP,C2_UM FROM "+ RetSqlName( "Z00" ) +" Z00 ,"+ RetSqlName( "SC2" ) +" SC2 "
cQry+="WHERE "
cQry+="Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQry+="AND Z00_SEQ='"+SubStr(cBobina,7,6)+"' "
cQry+="AND Z00.D_E_L_E_T_=''"
cQry+="AND SC2.D_E_L_E_T_=''"

If Select("TMPP") > 0
  DbSelectArea("TMPP")
  TMPP->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPP"

If ! TMPP->( Eof() )  
  
    aMATRIZC     := { { "D3_TM"  , "504"                                                          , ""},;
                      { "D3_DOC"      , NextNumero( "SD3", 2, "D3_DOC", .T. )                          , NIL},;
                      { "D3_FILIAL"   , xFilial( "SD3" )                                               , NIL},;
                      { "D3_OP"       ,TMPP->Z00_OP                                                    , NIL },;
                      { "D3_LOCAL"    , '01'                                                           , NIL },;
                      { "D3_COD"      , TMPP->C2_PRODUTO                                               , NIL},;
                      { "D3_UM"       , TMPP->C2_UM                                                    , NIL },;
                      { "D3_QUANT"    ,nPESO                                                           , NIL },;
                      { "D3_OBS"      ,'AP. BAIX. PI'                                                  , NIL },;                      
                      { "D3_EMISSAO"  , Date()                                                         , NIL} }


    MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZC, 3 )
	IF lMsErroAuto

		DisarmTransaction()
		MostraErro()
        return .F.

	Endif


ELSE

   ALERT('Bobina  '+alltrim(cBobina)+' não Encontrada' )
   DisarmTransaction()
   MostraErro()
   return 

EndIf

TMPP->(DbCloseArea())


Return 

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ PesaMan()()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
***************
Static Function PesaMan()
***************

private nPesoMan := 0

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Peso do Pallet",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Informar Peso:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,nPesoMan:=u,nPesoMan)},oDlg99,060,010,'@E 99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nPesoMan",,)
oSBtn1     := SButton():New( 008,080,1,{||OkPeso()},oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return nPesoMan

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ OkPeso()()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function OkPeso()
   oDlg99:End()
Return
