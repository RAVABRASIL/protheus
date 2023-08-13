#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
//#include  "Tbiconn.ch "


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :ESTR021 ³ Autor :Gustavo Costa           ³ Data :09/07/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Rotina de controle de entrada e saida de carrinho para     ³±±
±±³            embalagem.        										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTR021()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cCodCarro  := Space(6)
Private aFila		:= {}
Private aCampos		:= {}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oFont3","oDlg1","oPanel1","oGet1","oLBox1","oPanel2","oBtn1","oSay1","oSay2","oBrw1")

//*****************************
//Cria a tabela temporaria
//*****************************
oTbl1()

AADD(aCampos,{"CODIGO" 			,"","CARRINHO"  	,""  	})					//CODIGO DO CARRINHO
AADD(aCampos,{"PRODUTO"			,"","CODIGO"		,""  	})					//CODIGO DO PRODUTO
AADD(aCampos,{"DESCRI"			,"","PRODUTO"		,""  	})					//CODIGO DO PRODUTO

// 
fDentro() 

//{"00001 - CDB154 - SACO DE LIXO AZUL","00011 - CDB154 - SACO DE LIXO BRANCO","00021 - CDB154 - SACO DE LIXO PRETO"}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-37,,.F.,0,,400,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-21,,.F.,0,,400,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )

oDlg1      := MSDialog():New( 113,255,614,998,"Controle de entrada dos carrinhos",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,366,068,.T.,.F. )

//oLBox1     := TListBox():New( 058,000,,aFila,375,139,,oDlg1,,CLR_BLACK,CLR_WHITE,.T.,,,oFont2,"",,,,,,, )

oBrw1      := MsSelect():New( "XMP","","",aCampos,.F.,,{068,000,251,375},,, oDlg1 ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK
oBrw1:oFont := oFont1

/*
oPanel2    := TPanel():New( 208,000,"",oDlg1,,.F.,.F.,,,366,036,.T.,.F. )
oBtn1      := TButton():New( 007,012,"ENTRAR",oPanel1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {|| fAPorta("E") }
oBtn2      := TButton():New( 007,060,"SAIR",oPanel1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {|| fAPorta("S") }
*/
oGet1      := TGet():New( 016,100,,oPanel1,164,034,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.T.,.F.,,.F.,.F.,"","cCodCarro",,)
oGet1:bSetGet := {|u| If(PCount()>0,cCodCarro:=u,cCodCarro)}
oGet1:bValid := {|| U_fAtuES()}
//oGet1:bChange := {|| U_fAtuES()}

oSay1      := TSay():New( 008,100,{||"CÓDIGO DO CARRINHO"},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,025)
//oSay2      := TSay():New( 058,048,{||"PRODUTO"},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,009)
ObjectMethod( oGet1, "SetFocus()" )

oDlg1:Activate(,,,.T.)

Return


//------------------------------------------------------------------------------------------
/*
Pega as todos os carrinhos que estao dentro da pesagem.

@author    Gustavo Costa
@version   1.xx
@since     09/07/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fDentro()

local aRet		:= {}
Local cQuery	:= ""
Local cItem		:= ""
Local cCod		:= ""

cQuery := " SELECT * FROM " + RetSqlName( "ZZ2" ) + " ZZ2 "
cQuery += " WHERE ZZ2.D_E_L_E_T_ <> '*' "
cQuery += " AND ZZ2_STATUS = 'D' "

If Select("GLO") > 0
	DbSelectArea("GLO")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "GLO"
dbselectArea("GLO")
dbGoTop("GLO")

While GLO->(!EOF())
	
If ! XMP->(dbSeek(GLO->ZZ2_TARA))

	cCod	:= SUBSTR(ZZ2_PROD,1, LEN(Alltrim(ZZ2_PROD)) -1 )
	//cItem	:= GLO->ZZ2_TARA + " - " + POSICIONE("SB1",1,xFilial("SB1") + cCod,"B1_DESC" )
	
	RecLock("XMP",.T.)
	
	XMP->CODIGO			:= GLO->ZZ2_TARA
	XMP->PRODUTO		:= cCod
	XMP->DESCRI			:= POSICIONE("SB1",1,xFilial("SB1") + cCod,"B1_DESC" )
	XMP->FILIAL			:= GLO->ZZ2_FILIAL
	XMP->DDATA			:= GLO->ZZ2_DATA
	XMP->OP				:= GLO->ZZ2_OP
	XMP->HORA			:= GLO->ZZ2_HORA
	XMP->MAQ			:= GLO->ZZ2_MAQ
	XMP->LADO			:= GLO->ZZ2_LADO
	XMP->HORAE			:= time()
	
	XMP->(MsUnLock())

ENDIF

	GLO->(dbSkip())
		
EndDo

DbSelectArea("GLO")
DbCloseArea()
	
dbselectArea("XMP")
XMP->(dbGoTop())

Return aRet

//------------------------------------------------------------------------------------------
/*
Verifica se o carro esta dentro ou fora para abrir a porta certa.

@author    Gustavo Costa
@version   1.xx
@since     10/07/2015
/*/
//------------------------------------------------------------------------------------------
User Function fAtuES()

Local lFora				:= .F.
Local cQuery			:= ""
Local nQuant			:= 0
Local lDentro			:= .F.

If Empty(AllTrim(cCodCarro))
	
	cCodCarro	:= Space(6)
	ObjectMethod( oGet1, "SetFocus()" ) //Codigo do carrinho
	oDlg1:Refresh()
	//oLBox1:Refresh()
	Return .T.
	
EndIf


lFora := fFora()

If lFora
	
	//MsgAlert("Abre a porta para ENTRAR")
	fAbrePorta("E")
	
Else
	
	lDentro	:= fSai()
	
	If lDentro
		//MsgAlert("Abre a porta para SAIR")
		fAbrePorta("S")
	Else
		MsgAlert("Carrinho não foi pesado!")
	EndIf
	 
EndIf

cCodCarro	:= Space(6)
ObjectMethod( oGet1, "SetFocus()" ) //Codigo de barras do produto
oDlg1:Refresh()
oBrw1:oBrowse:Refresh()
//oLBox1:Refresh()

Return .F.

//------------------------------------------------------------------------------------------
/*
Verifica se o carrinho está fora e já foi pesado para poder entrar.

@author    Gustavo Costa
@version   1.xx
@since     10/07/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fFora()

local lRet		:= .F.
Local cQuery	:= ""

cQuery := " SELECT * FROM " + RetSqlName( "ZZ2" ) + " ZZ2 "
cQuery += " WHERE ZZ2.D_E_L_E_T_ <> '*' "
cQuery += " AND ZZ2_STATUS = '' "
cQuery += " AND ZZ2_TARA = '" + Alltrim(cCodCarro) + "' "

If Select("FRA") > 0
	DbSelectArea("FRA")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FRA"
dbselectArea("FRA")
dbGoTop("FRA")

IF FRA->(!EOF())
	
	If ! XMP->(dbSeek(cCodCarro))
	
		cCod	:= SUBSTR(ZZ2_PROD,1, LEN(Alltrim(ZZ2_PROD)) -1 )
	
		RecLock("XMP",.T.)
		
		XMP->CODIGO			:= FRA->ZZ2_TARA
		XMP->PRODUTO		:= cCod
		XMP->DESCRI			:= POSICIONE("SB1",1,xFilial("SB1") + cCod,"B1_DESC" )
		XMP->FILIAL			:= FRA->ZZ2_FILIAL
		XMP->DDATA			:= FRA->ZZ2_DATA
		XMP->OP				:= FRA->ZZ2_OP
		XMP->HORA			:= FRA->ZZ2_HORA
		XMP->MAQ			:= FRA->ZZ2_MAQ
		XMP->LADO			:= FRA->ZZ2_LADO
		XMP->HORAE			:= time()
		
		XMP->(MsUnLock())
		
		lRet	:= .T.
	
		//FRA->(dbSkip())
	ENDIF
	
Else
	Return lRet
EndIf

DbSelectArea("FRA")
DbCloseArea()

dbselectArea("XMP")
XMP->(dbGoTop())

//cCodCarro	:= Space(6)
ObjectMethod( oGet1, "SetFocus()" ) //Codigo de barras do produto
oDlg1:Refresh()
oBrw1:oBrowse:Refresh()
//oLBox1:Refresh()

Return lRet

//------------------------------------------------------------------------------------------
/*
Verifica se o carrinho está dentro da pesagem para poder sair.

@author    Gustavo Costa
@version   1.xx
@since     10/07/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fSai()

local lRet		:= .F.
Local cQuery	:= ""
Local nPos		:= 0

//nPos	:= ASCAN(aFila, { |x| SubStr(x,1,6) == AllTrim(cCodCarro) })
dbselectArea("XMP")
	
If XMP->(dbSeek(cCodCarro))
	
/*	RecLock("XMP",.F.)
	
	dbDelete()
	
	XMP->(MsUnLock())
	//ADEL(aFila, nPos)
*/
	lRet	:= .T.
	
EndIf

dbselectArea("XMP")
XMP->(dbGoTop())

//cCodCarro	:= Space(6)
ObjectMethod( oGet1, "SetFocus()" ) //Codigo do carrinho
oBrw1:oBrowse:Refresh()
oDlg1:Refresh()
	
Return lRet


		
//------------------------------------------------------------------------------------------
/*
Rotina para abrir a porta de entrada ou saida.

@author    Gustavo Costa
@version   1.xx
@since     15/07/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fAbrePorta(_cPorta)

local cTexto 	:= SPACE(1) 
Local lRet		:= .F.
Local lConnect	:= .F.
Local nHandle
Local cBuffer
Local lOk		:= .F.
Local cElapsed
Local nTempo	:= 0
Local cRetDll	:= "1"
Local cDll 		:= "ASerial.Dll"
Local hDll
//nHandle := LoadLibrary("SERIAL.DLL") 	

lConnect	:=  .T. //MsOpenPort(@nHandle,"COM3:9600,n,8,1") 
//lConnect	:=  MsOpenPort(@nHandle,"COM3") 

If lConnect
	
	If _cPorta	== "S" //porta de saida
		
		dbselectArea("XMP")
	
		If XMP->(dbSeek(cCodCarro))

			cElapsed := ElapTime( XMP->HORAE, TIME() )
			
			nTempo	:= (Val(SubStr(cElapsed,1,2)) * 3600) + (Val(SubStr(cElapsed,4,2)) * 60) + Val(SubStr(cElapsed,7,2))
			
			If nTempo > 40 //se o tempo for maior que 60 segundos 
				/*
				Sleep(2000)
				MsWrite(nHandle,"8") 
				Sleep(2000)
				MsRead(nHandle,@cBuffer) 
				*/
				/*
				hDll := ExecInDllOpen(cDll)    			         	 
				If hDll = -1
					MsgAlert("Nao foi possivel abrir " + cDll + ".")
				Else	
					cRetDll := ExecInDLLRun(hDll, 1, "COM3,8") //abre a porta
					ExecInDllClose(hDll)
				Endif
				*/
				lOK	:= .T.//cRetDll == "8"
	
				dbselectArea("ZZ2")
				If ZZ2->(dbSeek(XMP->FILIAL + XMP->OP + XMP->DDATA + XMP->HORA + XMP->MAQ + XMP->LADO )) .AND. lOk
				
					RecLock("ZZ2",.F.)
					ZZ2->ZZ2_STATUS	:= "X"
					ZZ2->(MsUnLock())
					
				Else
				
					dbselectArea("XMP")
					XMP->(dbGoTop())
					//MsgAlert("Registro não encontrado! ZZ2 - S")
					Return
				
				EndIf
				
				If lOK
				
					RecLock("XMP",.F.)
			
					dbDelete()
			
					XMP->(MsUnLock())
				
				EndIf
				
				dbselectArea("XMP")
				XMP->(dbGoTop())
				
				oDlg1:Refresh()
				oBrw1:oBrowse:Refresh()

			Else
			
				MsgAlert("O carro tem que esperar 1 minuto para poder sair!")
				Return
			
			EndIf
		
		EndIf

		dbselectArea("XMP")
		XMP->(dbGoTop())

	Else
		/*
		Sleep(2000)
		MsWrite(nHandle,"7") 
		Sleep(2000)
		MsRead(nHandle,@cBuffer) 
		
		lOK	:= cBuffer == "7"
		*/
		/*
		hDll := ExecInDllOpen(cDll)    			         	 
		If hDll = -1
			MsgAlert("Nao foi possivel abrir " + cDll + ".")
		Else	
			cRetDll := ExecInDLLRun(hDll, 1, "COM3,7") //abre a porta
			ExecInDllClose(hDll)
		Endif
		*/
        
		lOK	:= .T.//cRetDll == "7"

		dbselectArea("XMP")

		If XMP->(dbSeek(cCodCarro))
			dbselectArea("ZZ2")
			If ZZ2->(dbSeek(XMP->FILIAL + XMP->OP + XMP->DDATA + XMP->HORA + XMP->MAQ + XMP->LADO ))
			
			       		     
				If lOk
			       
					RecLock("ZZ2",.F.)
					ZZ2->ZZ2_STATUS	:= "D"
					ZZ2->(MsUnLock())
				   
				Else

					ALERT('PROBLEMA NA COMUNICAÇÃO USB!!!')
					
					RecLock("XMP",.F.)
			
					dbDelete()
			
					XMP->(MsUnLock())
				
				EndIf
				
			Else
			
				MsgAlert("Registro não encontrado! ZZ2 - E")
				Return
			
			EndIf
		EndIf

		dbselectArea("XMP")
		XMP->(dbGoTop())

	EndIf

	MsClosePort(nHandle)

Else

	MsgAlert("Não conectou na porta!")

EndIf
	
Return lRet


***************

Static Function fLimpaTela()

***************

//Limpa as variaveis
oGet1:Enable()
oBtn3:Disable() 	//Confirmar
oBtn4:Disable()	//Limpar Tudo

cCodBarNF		:= Space(45)
cCodBarProd		:= Space(13)
cNunNF			:= Space(9)
cSerieNF		:= Space(3)
cCliente  		:= Space(50)
aProdutos		:= {}
cSeparador		:= ""

oDlg1:Refresh()
ObjectMethod( oGet1, "SetFocus()" )  // Codigo de barras NF

dbSelectArea("XMP")
XMP->(dbGoTop())

While XMP->(!EOF())

	RecLock("XMP",.F.)
	
	dbDelete()
	
	XMP->(MsUnLock())
	
	XMP->(dbSkip())

EndDo

Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: XMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"FILIAL"  ,"C",002,000} )
Aadd( aFds , {"CODIGO"  ,"C",006,000} )
Aadd( aFds , {"PRODUTO"	,"C",015,000} )
Aadd( aFds , {"DESCRI"	,"C",050,000} )
Aadd( aFds , {"OP"  	,"C",011,000} )
Aadd( aFds , {"DDATA"  	,"C",008,000} )
Aadd( aFds , {"HORA"  	,"C",005,000} )
Aadd( aFds , {"MAQ"  	,"C",006,000} )
Aadd( aFds , {"LADO"  	,"C",001,000} )
Aadd( aFds , {"HORAE"  	,"C",008,000} )

cNomeArq := CriaTrab(aFds,.T.)
dbUseArea( .T.,, cNomeArq, "XMP", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("XMP",cNomeArq,"CODIGO",,,OemToAnsi("Selecionando Registros..."))  //

Return 


//**********************************************************
//TESTE
//**********************************************************

Static Function fAPorta(_cPorta)

local cTexto 	:= SPACE(1) 
Local lRet		:= .F.
Local lConnect	:= .F.
Local nHandle
Local cBuffer
Local lOk		:= .F.

//nHandle := LoadLibrary("SERIAL.DLL") 	

lConnect	:=  MsOpenPort(@nHandle,"COM3:9600,n,8,1") 
//lConnect	:=  MsOpenPort(@nHandle,"COM3") 

If lConnect
	
	If _cPorta	== "S" //porta de saida
		

		Sleep(2000)
		MsWrite(nHandle,"8") 
		Sleep(2000)
		MsRead(nHandle,@cBuffer) 
		
		lOK	:= cBuffer == "8"

		If lOk	
			MsgAlert("Recebeu retorno: " + cBuffer)
		EndIf

		dbselectArea("XMP")
		XMP->(dbGoTop())
	

	Else
		
		Sleep(2000)
		MsWrite(nHandle,"7") 
		Sleep(2000)
		MsRead(nHandle,@cBuffer) 
		
		lOK	:= cBuffer == "7"

		If lOk	
			MsgAlert("Recebeu retorno: " + cBuffer)
		EndIf
		
		dbselectArea("XMP")
		XMP->(dbGoTop())

	EndIf

	MsClosePort(nHandle)

Else

	MsgAlert("Não conectou na porta!")

EndIf
	
Return lRet
