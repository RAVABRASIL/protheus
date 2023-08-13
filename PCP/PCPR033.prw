// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPR033
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 18/03/14 | Gustavo Costa     | Tela de Pesagem do PI.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} PCPR033
Grava o peso dos produtos em processo (PP) e grava na tabela ZZ2.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     18/03/2014
/*/
//------------------------------------------------------------------------------------------
User Function PCPR033()
//--< variáveis >---------------------------------------------------------------------------

private nSaldoBob   := 0 
PRIVATE nPeso		:= 0
PRIVATE nTara		:= 0
PRIVATE cOP			:= Space(11)
PRIVATE cNomeOP		:= Space(50)
PRIVATE cCodTara	:= Space(06)
PRIVATE cNomeTara	:= Space(25)
PRIVATE cMaq		:= Space(06)
PRIVATE cSaldoBob	:= Space(14)
PRIVATE aMaq		:= fMaq()
PRIVATE cNomeMaq	:= Space(25)
//PRIVATE cLado		:= "A"
PRIVATE cLado		:= " "
PRIVATE cCodPro		:= Space(15)
PRIVATE cCodPI		:= Space(15)
PRIVATE cMat		:= Space(07)
PRIVATE cBobina		:= Space(12)
PRIVATE cNomeFun	:= Space(25)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oDlg1","oPanel1","oGet1","oGet2","oGet4","oGet5","oCBox1",,"oCBox2",,"oBtn1","oGrp1","oSay1","oSay2")
SetPrvt("oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Calibri",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Calibri",0,-21,,.T.,0,,700,.F.,.F.,,,,,, )

dbSelectArea("ZZ2")

oDlg1      := MSDialog():New( 126,254,419,938,"Pesagem do Produto em Processo",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,340,145,.T.,.F. )

oGet1      := TGet():New( 014,008,{|u| If(PCount()>0,cOP:=u,cOP)},oPanel1,067,013,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","cOP",,)
oGet1:bValid := {|| NaoVazio(), ExistCpo("SC2", cOP), fVldOP() }
oGet1:bChange := {||cCodPro := POSICIONE(("SB1"),1,xFilial("SB1") + POSICIONE(("SC2"),1,xFilial("SC2") + cOP, "C2_PRODUTO"), "B1_ALTER"),;
						cNomeOP := POSICIONE(("SB1"),1,xFilial("SB1") + cCodPro, "B1_DESC")}
oSay2      := TSay():New( 003,008,{|| "Ordem de Produção" },oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,067,010)
oSay3      := TSay():New( 014,088,{|| cNomeOP },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,239,016)

oGet2      := TGet():New( 041,008,{|u| If(PCount()>0,cCodTara:=u,cCodTara)},oPanel1,067,014,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","cCodTara",,)
oGet2:bValid := {|| NaoVazio(), ExistCpo("ZZ1", cCodTara), fVldTara() }
oGet2:bChange := {||cNomeTara := POSICIONE(("ZZ1"),1,xFilial("ZZ1") + cCodTara, "ZZ1_DESC"),;
					  nTara := POSICIONE(("ZZ1"),1,xFilial("ZZ1") + cCodTara, "ZZ1_PESOAT")}
oSay4      := TSay():New( 030,008,{||"Carrinho"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
//oSay5      := TSay():New( 041,088,{|| cNomeTara },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,142,016)
oSay5      := TSay():New( 041,088,{|| alltrim(cNomeTara)+' Tara: '+cvaltochar(nTara) },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,162,016)

oGet4      := TGet():New( 071,008,{|u| If(PCount()>0,cMat:=u,cMat)},oPanel1,067,014,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","cMat",,)
oGet4:bValid := {|| NaoVazio(), ExistCpo("SRA", SubStr(cMat,2,6)) }
oGet4:bChange := {||cNomeFun := POSICIONE(("SRA"),1,xFilial("SRA") + SubStr(cMat,2,6), "RA_NOME")}
oSay9      := TSay():New( 060,008,{||"Operador"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay10     := TSay():New( 073,088,{|| cNomeFun },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,142,016)
/* gustavo                                                                         
oGet3      := TGet():New( 102,008,{|u| If(PCount()>0,cMaq:=u,cMaq)},oPanel1,067,013,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMaq",,)
oGet3:bValid := {|| NaoVazio(), ExistCpo("SH1", cMaq) }
oGet3:bChange := {||cNomeMaq := POSICIONE(("SH1"),1,xFilial("SH1") + cMaq, "H1_DESCRI")}
oSay6      := TSay():New( 090,008,{||"Máquina"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSay7      := TSay():New( 102,088,{|| cNomeMaq },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,142,016)
*/
// antonio
oSay11      := TSay():New( 090,008,{||"Bobina"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oGet5      := TGet():New( 102,008,{|u| If(PCount()>0,cBobina:=u,cBobina)},oPanel1,067,014,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBobina",,)
//oGet5:bChange := {||cSaldoBob := "Saldo : " + Transform((fQtdBOB(SubStr(cBobina,7,6)) - fApontado(SubStr(cBobina,7,6))),"@E 9,999.99" )}
oGet5:bChange := {|| fSalBob() }
//ZB9->(dbSeek(xFilial("ZB9") + cCodPI + SubStr(cBobina,7,6)))

oSay12     := TSay():New( 102,088,{|| cSaldoBob },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,142,016)

oCBox2     := TComboBox():New( 130,008,{|u| If(PCount()>0,cMaq:=u,cMaq)},aMaq,067,013,oPanel1,,,,CLR_BLACK,CLR_WHITE,.T.,oFont2,"",,,,,,,cMaq )
oSay6      := TSay():New( 120,008,{||"Máquina"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
//oSay7      := TSay():New( 102,088,{|| fNomeMaq(cMaq) },oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,142,016)

//
oCBox1     := TComboBox():New( 130,098,{|u| If(PCount()>0,cLado:=u,cLado)},{" ","A","B"},068,017,oPanel1,,,,CLR_BLACK,CLR_WHITE,.T.,oFont2,"",,,,,,,cLado )
oSay8      := TSay():New( 120,098,{||"Lado"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGrp1      := TGroup():New( 053,243,085,336,"Peso",oPanel1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 062,252,{|| Transform(nPeso, "@E 999,999.99999")},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,014)

oBtn1      := TButton():New( 090,243,"Pesar",oPanel1,,093,025,,oFont2,,.T.,,"",,,,.F. )
oBtn1:bAction := { || Processa({ || fLeBalanca() }) }
oBtn2      := TButton():New( 120,243,"Gravar",oPanel1,,093,025,,oFont2,,.T.,,"",,,,.F. )
oBtn2:bAction := { || Processa({ || fGravaPeso() }) }

ObjectMethod( oGet1, "SetFocus()" )  //op



oDlg1:Activate(,,,.T.)

Return
//--< fim de arquivo >----------------------------------------------------------------------


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ fGravaPeso º Autor ³ Gustavo Costa      º Data ³  17/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para grava o peso do PP na tabela ZZ2.                º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGravaPeso()

If MsgNoYes ( "Confirma a gravação do peso?" , "Grava Peso" )
	
   // antonio
   IF EMPTY(cOP)
      alert('O Campo Ordem de Producao nao pode esta Vazio. Favor Pistolar o codigo de Barra da OP')
	  ObjectMethod( oGet1, "SetFocus()" ) 
      Return
   Endif
   IF EMPTY(cCodTara)	   
      alert('O Campo Carrinho nao pode esta Vazio. Favor Pistolar o codigo de Barra do Carrinho' )
	  ObjectMethod( oGet2, "SetFocus()" ) 
      Return
   Endif
   IF EMPTY(cMaq)
      alert('O campo Maquina nao pode esta Vazio. Favor Digitar a Maquina')
//	  ObjectMethod( oGet3, "SetFocus()" ) 
	  ObjectMethod( oCbox2, "SetFocus()" ) 
      Return
   Endif
   IF EMPTY(cLado) .AND. SUBSTR(cMaq,1,1) $ 'C' 
      alert('O Campo Lado nao pode esta Vazio para Corte e Solda . Favor escolher um Lado' )
	  ObjectMethod( oCbox1, "SetFocus()" ) 
      Return
   Endif

   IF !EMPTY(cLado) .AND. SUBSTR(cMaq,1,1) $ 'P' 
      alert('O Campo Lado nao pode esta preenchido para Picotadeira. Favor Deixar o lado Vazio.' )
	  ObjectMethod( oCbox1, "SetFocus()" ) 
      Return
   Endif

   IF EMPTY(cMat)		
      alert('O Campo Operador nao pode esta Vazio. Favor Pistolar o codigo de Barra do Operador')
	  ObjectMethod( oGet4, "SetFocus()" ) 
      Return
   Endif
   
   IF EMPTY(cBobina)		
      alert('O Campo Bobina nao pode esta Vazio. Favor Pistolar o codigo da Bobina')
	  ObjectMethod( oGet5, "SetFocus()" ) 
      Return
   	Endif
   
   // valida se a OP da bobina é diferente da OP do carrinho 
   IF substr(cBobina,1,6) <>substr(cOP,1,6)		
      alert('A OP da Bobina '+substr(cBobina,1,6)+' esta Diferente da OP do Carrinho '+substr(cOP,1,6))
	  ObjectMethod( oGet5, "SetFocus()" ) 
      Return
   	Endif



   If nPeso <=0
      alert('O Peso nao pode ser negativo ou zerado!!!')
	  fLimpaTela()
      Return
	Else
	
		nApontado	:= fApontado(SubStr(cBobina,7,6))
		//nSaldoBob	:= fSaldoBOB(SubStr(cBobina,7,6))
		/*
        If nPeso + nApontado > nSaldoBob
			alert('Já foi apontado ' + Transform(nApontado, "@E 999,999.99999") + ;
					'Kg para esta bobina que só tem ' + Transform(nSaldoBob, "@E 999,999.99999") + 'Kg. Impossível de continuar!' )
	  		//fLimpaTela()
      		//Return
		EndIf  
   	    */
   	    
        If nPeso  > nSaldoBob

			alert('O Peso é  ' + Transform(nPeso, "@E 999,999.99999") + ;
					'Kg maior que o Saldo da bobina ' + Transform(nSaldoBob, "@E 999,999.99999") + 'Kg. Impossível de continuar!' )

	  		fLimpaTela()
      		Return
		EndIf  



   Endif 
   If empty(cCodPro)
      alert("Favor associar o codigo do Produto do Processo de Pessagem ao PA!!!") 
	  ObjectMethod( oGet1, "SetFocus()" )  // op
      Return 
   Endif
   
   If ! MaqPP(cMaq)   
      alert('Maquina digitada errada')
//	  ObjectMethod( oGet3, "SetFocus()" ) 
	  ObjectMethod( oCbox2, "SetFocus()" ) 
      Return
   Endif

   if ! fVldOP()  // valida se a OP ja foi pesada antes de 20 minutos 
	  fLimpaTela() 
     return 
   endif

    _ProdC2:=POSICIONE(("SC2"),1,xFilial("SC2") + cOP, "C2_PRODUTO")
	cCodPI	:= fCProdBob(SubStr(cBobina,7,6))

//   If ! fPAxPI(cCodPro, cCodPI)  // valida se a bobina informada faz parte da estrutura do PA apontado 
   If ! fPAxPI(_ProdC2, cCodPI)  // valida se a bobina informada faz parte da estrutura do PA apontado 
   		MsgAlert("Esta Bobina não faz parte deste PA!")
	  fLimpaTela() 
     return 
   endif
	
 // validar Staus 
		   
   fStatus()
		
 //


	//Baixa o saldo da bobina

 Begin Transaction

	dbSelectArea("ZB9")
	dbSetOrder(1)
	If ZB9->(dbSeek(xFilial("ZB9") + cCodPI + SubStr(cBobina,7,6)))
	
		If ZB9->ZB9_SALDO - nPeso > 0
		
			RecLock("ZB9",.F.)
			
			ZB9->ZB9_SALDO		:= ZB9->ZB9_SALDO - nPeso
	
			ZB9->(MsUnLock())
		Else
		
			MsgAlert("Bobina sem Saldo: " + cCodPI + " - " + SubStr(cBobina,7,6) )
			return
		
		EndIf
	
	Else
		MsgAlert("Bobina não encontrada: " + cCodPI + " - " + SubStr(cBobina,7,6) )
		return
	EndIf

   // 
	dbSelectArea("SC2")
	dbSetOrder(1)
	If SC2->(dbSeek(xFilial("SC2") + cOP))
	
		
		RecLock("ZZ2",.T.)
		
		ZZ2->ZZ2_FILIAL	:= xFilial("ZZ2")
		ZZ2->ZZ2_OP		    := cOP
		ZZ2->ZZ2_DATA		:= Date()
		ZZ2->ZZ2_HORA		:= Time()
		ZZ2->ZZ2_PROD		:= cCodPro
		ZZ2->ZZ2_QUANT	    := nPeso
		ZZ2->ZZ2_MAQ		:= cMaq
		ZZ2->ZZ2_LADO		:= cLado
		ZZ2->ZZ2_SEQ		:= GETSXENUM("ZZ2","ZZ2_SEQ")
		ZZ2->ZZ2_SEQBOB		:= SubStr(cBobina,7,6)
		ZZ2->ZZ2_USER		:= cUserName
		ZZ2->ZZ2_MAT		:= SubStr(cMat,2,6)
		// ANTONIO
		ZZ2->ZZ2_TARA		:= cCodTara
		ZZ2->(MsUnLock())

		//Baixa o saldo do PI
		 fBaixaPI(cBobina,nPeso)
//	        Msgalert("Pesagem gravada com sucesso!")
		
		//Limpa as variaveis
		nPeso		:= 0
		nTara		:= 0
		cOP			:= Space(11)
		cNomeOP		:= Space(50)
		cCodTara	:= Space(06)
		cNomeTara	:= Space(25)
		cMaq		:= Space(06)
		cNomeMaq	:= Space(25)
		cBobina		:= Space(12)
//		cLado		:= "A" 
		cLado		:= " "
		cMat		:= Space(07)
		cNomeFun	:= Space(25)
        cSaldoBob	:= Space(14)		
		oDlg1:Refresh()
		//ObjectMethod( oSay1, "SetText( Trans( nPESO, '@E 999.99' ) )" )
		ObjectMethod( oGet1, "SetFocus()" ) //OP
		
	Else
		MsgAlert("OP não encontrada: " + cOP)
	EndIf
    
 End Transaction		



EndIf


Return

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

If Select("TMPS") > 0
  DbSelectArea("TMPS")
  TMPS->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPS"

If ! TMPS->( Eof() )  
  
    aMATRIZC     := { { "D3_TM"  , "504"                                                          , ""},;
                      { "D3_DOC"      , NextNumero( "SD3", 2, "D3_DOC", .T. )                          , NIL},;
                      { "D3_FILIAL"   , xFilial( "SD3" )                                               , NIL},;
                      { "D3_OP"       ,TMPS->Z00_OP                                                    , NIL },;
                      { "D3_LOCAL"    , '01'                                                           , NIL },;
                      { "D3_COD"      , TMPS->C2_PRODUTO                                               , NIL},;
                      { "D3_UM"       , TMPS->C2_UM                                                    , NIL },;
                      { "D3_QUANT"    ,nPESO                                                           , NIL },;
                      { "D3_OBS"      ,'BAIX. PI'                                                      , NIL },;                      
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
   return .F.

EndIf

TMPS->(DbCloseArea())


Msgalert("Pesagem gravada com sucesso!")
	        
Return  .T.



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

Local lBalanca  := GetMV("MV_BALEXTR")  
cPORTABAL := "4"

// antonio
If nTara <=0
   alert("Valor da Tara negativo ou zerado.")
   Return 
endif

If lBalanca

   cDLL     := "toledo9091.dll"
   nHandle  := ExecInDllOpen( cDLL )

   If nHandle = -1
   	   MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
       Return NIL
   EndIf
   
   // Parametro 1 = Porta serial do indicador
   cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
   //cRETDLL := '60'
   nPESO := Val( Strtran( cRETDLL, ",", "." ) ) - nTara
   ExecInDLLClose( nHandle )
else
   nPeso := PesaMan() - nTara
endif

// antonio
If nPeso <=0
   alert("Valor do Peso negativo ou zerado.")
   Return 
endif


oDlg1:Refresh()
ObjectMethod( oBtn2, "SetFocus()" ) //OP

Return

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

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ fVldTara()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function fVldTara()

Local dDataVal	:= POSICIONE(("ZZ1"),1,xFilial("ZZ1") + cCodTara, "ZZ1_DTVAL")
Local lOK			:= .F.

If date() - dDataVal <= Val(SuperGetmv("MV_XDIASTA",,"7"))

	If date() - dDataVal = Val(SuperGetmv("MV_XDIASTA",,"7")) - 1
		MsgAlert("Hoje é o último dia para aferir este carrinho. Amanhã ele estará bloqueado!")
	EndIf

	lOk		:= .T.
Else
	MsgAlert("Data da aferição da tara está desatualizada!")
EndIf

Return lOk

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ fVldOP()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function fVldOP()

Local dDataVal		:= POSICIONE(("ZZ1"),1,xFilial("ZZ1") + cCodTara, "ZZ1_DTVAL")
Local lOK			:= .T.
Local cQuery		:= ""
Local cHora		
Local nTempo

nTempo	:= Seconds() - 1200 // 20 minutos
cHora	:= StrZero(Int(((nTempo/60)/60)), 2) + ":" + StrZero((((nTempo/60)/60)%1)*60, 2)

cQuery := " SELECT * FROM " + RetSqlName("ZZ2") + " ZZ2 "
cQuery += " WHERE ZZ2_FILIAL =  '" + xFilial("ZZ2") + "'"
cQuery += " AND ZZ2_OP = '" + cOP + "' "
cQuery += " AND ZZ2_DATA = '" + DtoS(date()) + "' "
cQuery += " AND ZZ2_HORA > '" + cHora + "' "
//cQuery += " AND ZZ2_PROD = 'PPCAF024       ' "
//cQuery += " AND ZZ2_MAQ = '" +  + "' "
cQuery += " AND ZZ2_TARA = '" + cCodTara + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "

MemoWrite("C:\TEMP\FVLOP.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "TMP"

dbselectArea("TMP")
dbGoTop("TMP")

If TMP->(!EOF()) 

	lOk := .F.
	MsgAlert("Informação já inserida!")

EndIf

TMP->(dbCloseArea())

Return lOk

***************

Static Function fLimpaTela()

***************

//Limpa as variaveis
nPeso		:= 0
nTara		:= 0
cOP			:= Space(11)
cNomeOP	    := Space(50)
cCodTara	:= Space(06)
cNomeTara	:= Space(25)
cMaq		:= Space(06)
cNomeMaq	:= Space(25)
//cLado		:= " "
cLado		:= " "
cMat		:= Space(07)
cNomeFun	:= Space(25)
cSaldoBob	:= Space(14)
cBobina		:= Space(12)
oDlg1:Refresh()
ObjectMethod( oGet1, "SetFocus()" )  // op
Return 



***************

Static Function MaqPP(cMaq)

***************

local cQry:=''
local lret:=.F.
cQry:="SELECT H1_CODIGO MAQUINA FROM "+ RetSqlName( "SH1" ) +" SH1 "
cQry+="WHERE  H1_FILIAL='"+xfilial('SH1')+"' "
cQry+="AND H1_CODIGO='"+alltrim(cMaq)+"'  "
cQry+="AND H1_CODIGO LIKE '[CP][0123456789]%'  "
cQry+="AND SH1.D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "AUXX"

dbselectArea("AUXX")
dbGoTop("AUXX")

IF AUXX->(!EOF())
   lret:=.T.
ENDIF

AUXX->(DBCLOSEAREA())

Return lret 


***************

Static Function fMaq()

***************

local cQry:=''
local aret:= {}

cQry:="SELECT H1_CODIGO MAQUINA FROM "+ RetSqlName( "SH1" ) +" SH1 "
cQry+="WHERE  H1_FILIAL='"+xfilial('SH1')+"' "
cQry+="AND H1_CODIGO LIKE '[CP][0123456789]%'  "
cQry+="AND SH1.D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "AUX2"

dbselectArea("AUX2")
dbGoTop("AUX2")
Aadd( aRet, space(6) )
IF AUX2->(!EOF())
   DO WHILE AUX2->(!EOF())
      Aadd( aRet, SUBSTR(AUX2->MAQUINA,1,6) )
   AUX2->(DbSkip())
   ENDDO
ENDIF

AUX2->(DBCLOSEAREA())

Return aret 


***************

Static Function fNomeMaq(cMaq)

***************

local cQry:=''
local Cret:=" "
cQry:="SELECT H1_DESCRI NOME FROM "+ RetSqlName( "SH1" ) +" SH1 "
cQry+="WHERE  H1_FILIAL='"+xfilial('SH1')+"' "
cQry+="AND H1_CODIGO='"+alltrim(cMaq)+"'  "
cQry+="AND H1_CODIGO LIKE '[CP][0123456789]%'  "
cQry+="AND SH1.D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "AUX3"

dbselectArea("AUX3")
dbGoTop("AUX3")

IF AUX3->(!EOF())
   Cret:=AUX3->NOME
ENDIF

AUX3->(DBCLOSEAREA())

Return Cret

***************

Static Function fApontado(cBobina)

***************

local cQry:=''
local nRet:=0

cQry:="SELECT SUM(ZZ2_QUANT) QUANT FROM "+ RetSqlName( "ZZ2" ) +" Z2 "
cQry+="WHERE Z2.D_E_L_E_T_ <> '*'
cQry+="AND ZZ2_SEQBOB ='"+alltrim(cBobina)+"'  "

TCQUERY cQry NEW ALIAS "AUXX"

dbselectArea("AUXX")
dbGoTop("AUXX")

IF AUXX->(!EOF())
   nRet	:= AUXX->QUANT 
ENDIF

AUXX->(DBCLOSEAREA())

Return nRet 

***************

Static Function fQtdBOB(cBobina)

***************

local cQry:=''
local nRet:=0

cQry:=" SELECT Z00_PESO FROM Z00020 Z0 "
cQry+="WHERE Z0.D_E_L_E_T_ <> '*' 
cQry+="AND Z00_SEQ ='"+alltrim(cBobina)+"'  "

TCQUERY cQry NEW ALIAS "AUXX"

dbselectArea("AUXX")
dbGoTop("AUXX")

IF AUXX->(!EOF())
   nRet := AUXX->Z00_PESO 
ENDIF

AUXX->(DBCLOSEAREA())

Return nRet 

***************

Static Function fSaldoBOB(cBobina)

***************

local cQry:=''
local nRet:=0

cQry:=" SELECT ZB9_SALDO FROM ZB9020 ZB "
cQry+="WHERE ZB.D_E_L_E_T_ <> '*' 
cQry+="AND ZB9_SEQ = '"+alltrim(cBobina)+"'  "

TCQUERY cQry NEW ALIAS "AUXY"

dbselectArea("AUXY")
dbGoTop("AUXY")

IF AUXX->(!EOF())
   nRet := AUXY->ZB9_SALDO 
ENDIF

AUXY->(DBCLOSEAREA())

Return nRet 

***************

Static Function fPAxPI(cPA, cPI)

***************

local cQry		:= ''
local lRet		:= .F.

cQry:=" SELECT * FROM SG1020 "
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND G1_COMP = '"+ cPI +"'  "
cQry+=" AND G1_COD = '"+ cPA +"'  "

TCQUERY cQry NEW ALIAS "AUXZ"

dbselectArea("AUXZ")
dbGoTop("AUXZ")

IF AUXZ->G1_COD <> ''
   lRet := .T. 
ENDIF

AUXZ->(DBCLOSEAREA())

Return lRet 

//-----------------------------------------------
//Função pra pegar o codigo do produto da bobina*/
//-----------------------------------------------

Static Function fCProdBob(cSeq)

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

***************

Static Function fStatus()

***************
local cQuery :=" "

cQuery :="update "+ RetSqlName( "ZZ2" ) +" set ZZ2_STATUS='X' "
cQuery +="where ZZ2_FILIAL='"+xFilial("ZZ2")+"' "
cQuery +="and ZZ2_TARA='"+cCodTara+"' "
cQuery +="and ZZ2_DATA<='"+dtos(Date())+"' "
cQuery +="and ZZ2_STATUS in (' ','D') "
cQuery +="and D_E_L_E_T_=' ' "

TcSqlExec(cQuery)

Return

***************

Static Function fSalBob()

***************

cCodPI:= fCProdBob(SubStr(cBobina,7,6))
nSaldoBob:=Posicione("ZB9",1,xFilial("ZB9") + cCodPI + SubStr(cBobina,7,6), "ZB9_SALDO")
cSaldoBob := "Saldo : " + Transform(nSaldoBob,"@E 9,999.99" )

Return 