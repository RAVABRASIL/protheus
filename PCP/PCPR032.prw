// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPR032
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 14/03/14 | Gustavo Costa     | Tela de aferição da Tara.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} PCPR032
Permite a manutenção de dados armazenados em ZZ1 (Cadastro de tara).

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     14/03/2014
/*/
//------------------------------------------------------------------------------------------
User Function PCPR032()
//--< variáveis >---------------------------------------------------------------------------

PRIVATE nPeso		:= 0
PRIVATE cCodTara	:= Space(6)
PRIVATE cNomeTara	:= Space(20)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oDlg1","oPanel1","oSay1","oGet1","oBtn1","oSay2","oSay3","oBtn2","oBtn3")
SetPrvt("oSay4")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Arial Black",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Calibri",0,-32,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Calibri",0,-24,,.T.,0,,700,.F.,.F.,,,,,, )

oDlg1      := MSDialog():New( 126,254,377,743,"Aferir Tara",,,.F.,,,,,,.T.,,,.F. )

oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,242,124,.T.,.F. )

oSay1      := TSay():New( 004,008,{||"Código da Tara"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oGet1      := TGet():New( 016,008,{|u| If(PCount()>0,cCodTara:=u,cCodTara)},oPanel1,066,014,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","cCodTara",,)
oGet1:bValid := {|| NaoVazio(), ExistCpo("ZZ1", cCodTara) }
oGet1:bChange := {||cNomeTara := POSICIONE(("ZZ1"),1,xFilial("ZZ1") + cCodTara, "ZZ1_DESC"), nPeso := 0}

oSay4      := TSay():New( 016,080,{|| cNomeTara },oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,155,016)

oBtn1      := TButton():New( 038,160,"Ler balança",oPanel1,,056,048,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || nPeso := fLeBalanca(), oPanel1:Refresh() }

oSay2      := TSay():New( 064,008,{||"PESO:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 079,008,{|| Transform(nPeso, "@E 999,999.999") },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,032)

oBtn2      := TButton():New( 096,132,"Gravar",oPanel1,,052,016,,,,.T.,,"",,,,.F. )
oBtn2:bAction := { || Processa({ || fGravaTara( cCodTara, nPeso ) }) }
oBtn3      := TButton():New( 096,188,"Cancelar",oPanel1,,048,016,,,,.T.,,"",,,,.F. )
oBtn3:bAction := { || oDlg1:end() }

oDlg1:Activate(,,,.T.)

Return
//--< fim de arquivo >----------------------------------------------------------------------


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ fGravaTara º Autor ³ Gustavo Costa      º Data ³  17/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para grava o peso da tara no cadastro.                º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGravaTara(cCodTara, nPeso)

If nPeso <=0
   alert("Valor do Peso negativo ou zerado.")
   Return 
endif

If MsgNoYes ( "Deseja realmente atualizar esta Tara?" , "Grava Tara" )
	
	dbSelectArea("ZZ1")
	dbSetOrder(1)
	ZZ1->(dbSeek(xFilial("ZZ1") + cCodTara))
	
	RecLock("ZZ1",.F.)
	
	ZZ1->ZZ1_PESOAN	:= ZZ1->ZZ1_PESOAT
	ZZ1->ZZ1_DTANT	:= ZZ1->ZZ1_DTVAL
	
	ZZ1->ZZ1_PESOAT	:= nPeso
	ZZ1->ZZ1_DTVAL	:= Date()
	 
	
	ZZ1->(MsUnLock())

	Msgalert("Tara Autalizada!")
	nPeso		:= 0
	cCodTara	:= Space(6)
	cNomeTara	:= Space(20)
	oDlg1:Refresh()
	oPanel1:Refresh()
	ObjectMethod( oGet1, "SetFocus()" ) //Codigo

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ fLeBalanca º Autor ³ Gustavo Costa      º Data ³  17/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para lê o peso da balança.                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fLeBalanca()

Local lBalanca  	:= GetMV("MV_BALEXTR")
cPORTABAL := "4"

If lBalanca

   cDLL     := "toledo9091.dll"
   nHandle  := ExecInDllOpen( cDLL )
	
	//MsgAlert('nHandle ' + nHandle)
   
   If nHandle = -1
   	   MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
       Return NIL
   EndIf
   
   // Parametro 1 = Porta serial do indicador
   cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
   
   //MsgAlert('cRETDLL ' + cRETDLL)
   //cRETDLL := '60'
   nPESO := Val( Strtran( cRETDLL, ",", "." ) ) 
   ExecInDLLClose( nHandle )
   
   //MsgAlert('nPeso ' + Transform( nPESO, '@E 999,999.999' ))
   ObjectMethod( oSay3, "SetText( Trans( nPESO, '@E 999,999.999' ) )" )
else
   nPeso := PesaMan()
   oPanel1:Refresh()
   oDlg1:Refresh()
endif

oDlg1:Refresh()
oPanel1:Refresh()
ObjectMethod( oBtn2, "SetFocus()" ) //Codigo

Return nPESO

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ PesaMan    º Autor ³ Gustavo Costa      º Data ³  17/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para lê o peso digitando.                             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

***************
Static Function PesaMan()
***************

private nPesoMan := 0

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Peso Manual",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Informar Peso:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,nPesoMan:=u,nPesoMan)},oDlg99,060,010,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nPesoMan",,)
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

