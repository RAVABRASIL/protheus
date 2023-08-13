#Include "RwMake.ch"
#Include "protheus.ch"
#Include "font.ch"
#Include "colors.ch"
#Include "topconn.ch"

*************

User Function ESTC011()

*************

SetPrvt( "nCONT, nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cLado, cPORTA, nSACOS, oSACOS, lINCOMP, nHandle, aUSUARIO, aUSUARI2, oTIPO, cTIPO, aTIPO, " )
cPORTABAL := "4"
cPORTAIMP := "3"

//Private cCodApa    := Space(6)

Private cCodApa    := alltrim(GETMV('MV_PRODAPA')) //200


/*
SetPrvt("oDlgSaida","oSay1","oGet1","oSBtn1","oSBtn2")

oDlgSaida  := MSDialog():New( 127,254,221,392,"Saida de Apara",,,.F.,,,,,,.T.,,,.F. )
oSay1      := TSay():New( 004,011,{||"Codigo do Produto :"},oDlgSaida,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oGet1      := TGet():New( 012,011,,oDlgSaida,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1CX","cCodApa",,)
oGet1:bSetGet := {|u| If(PCount()>0,cCodApa:=u,cCodApa)}


oSBtn1     := SButton():New( 028,003,1,{||Pegar()},oDlgSaida,,"", )
oSBtn2     := SButton():New( 028,036,2,{||oDlgSaida:end()},oDlgSaida,,"", )


oDlgSaida:Activate(,,,.T.)
*/

if MsgBox( OemToAnsi( "Deseja Realizar a Pesagem agora?" ), "Escolha", "YESNO" )      
   Pegar()
Endif



Return 


***************

Static Function Pegar()

***************

cDLL     := "toledo9091.dll"
nHandle  := ExecInDllOpen( cDLL )


if nHandle = -1
	MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	Return NIL
EndIf

// Parametro 1 = Porta serial do indicador
cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
cPESO   := Left( cRETDLL, rat( ",", cRETDLL ) - 1 )
nPESO   := Val( Strtran( cPESO, ",", "." ) )
ExecInDLLClose( nHandle ) 


If producao()
   Grava() 
Endif

//oDlgSaida:end()

Return NIL



***************

Static Function Grava()

***************
local nQUANT:=3

aIMP:={}

IF nPeso <0
   alert('O peso indicado esta abaixo ou igual a Zero')
   Return NIL
endif


cSEQ := ProxSeq()
RecLock( "Z85", .T. )
cNum:=GetSx8Num( "Z85", "Z85_NUM" )
Z85->Z85_CODBAR  := cNum+cSEQ
Z85->Z85_NUM     := cNum
Z85->Z85_PROD    := cCodApa
Z85->Z85_PESO    := nPESO
Z85->Z85_DATA    := Date()
Z85->Z85_HORA    := Left( Time(), 5 )
Z85->Z85_SEQ     := cSEQ
Z85->( MsUnlock() )
ConfirmSX8()
Z85->( DbCommit() )


For nCONT := 1 To nQUANT
    If Abre_Impress()
       Inc_Linha( "B" + "Rava Embalagens", .T. )
       Inc_Linha( "B" +"Produto: "+alltrim(cCodApa) , .F. )
       Inc_Linha( "B" + "Descricao: Apara", .F. ) 
       Inc_Linha( "B"+'Peso: '+ALLTRIM(STR(nPeso))+' Kg', .F. )
       Inc_Linha( cNum+cSEQ, .F. )
       Fecha_Impress()
    EndIf
Next
	

Return NIL

***************

Static Function PROXSEQ()

***************

cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
Do While Z00->( DbSeek( xFilial( "Z00" ) + cSEQ ) )
   ConfirmSX8()
   cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
EndDo
Return cSEQ


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

Static Function APCX()

***************
Local cQry:=''
local nRet:=0

cQry:="SELECT SUM(B2_QATU) TOTAL "
cQry+="FROM SB2020 SB2, SB1010 SB1 "
cQry+="WHERE "
cQry+="B2_COD=B1_COD "
cQry+="AND B2_FILIAL='"+xFilial('SB2')+"' "
cQry+="AND B2_LOCAL='01' "
cQry+="AND B1_TIPO='AP' "
cQry+="AND B1_COD>='268' "
cQry+="AND B1_SETOR='39'  "
cQry+="AND SB1.D_E_L_E_T_!='*'  "
cQry+="AND SB2.D_E_L_E_T_!='*' "

TCQUERY cQry NEW ALIAS 'TMPX'

IF TMPX->( !EOF())
   nRet:=TMPX->TOTAL
ENDIF

TMPX->(DBCLOSEAREA())

Return nRet


***************

Static Function Producao()

***************

Local aMATRIZE := {}
lMsErroAuto := .F.

nTotAp:=APCX()

If nPeso>nTotAp
   ALERT('O valor Pesado( '+alltrim(str(nPeso))+' ) e MAIOR que o Estoque de Apara( '+alltrim(str(nTotAp))+' )' )
   return .F.
Endif

/*
DbSelectArea('SB2')
SB2->( DbSetOrder( 1 ) )
if ! SB2->( DbSeek(xFilial("SB2") + cCodApa + "01", .F. ) )
     CriaSB2(cCodApa,"01")	   	  
endIf	   
*/

Begin Transaction
    // Tipo de Movimentacao 504 : ENTRADA DE APARA
    IF ConsomeApa()
	    // Tipo de Movimentacao 104 : ENTRADA DE APARA
		DbSelectArea('SD3')
		SD3->(DbSetOrder(2))
		
		aMATRIZE     := {           { "D3_TM", "104", ""},;
			                        { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
			                        { "D3_FILIAL", xFilial( "SD3" ), NIL},;
			                        { "D3_LOCAL", '01', NIL },;
			                        { "D3_COD", cCodApa, NIL},;
			                        { "D3_UM", POSICIONE("SB1", 1, xFilial("SB1") +cCodApa , "B1_UM" ), NIL },;
			                        { "D3_QUANT", nPeso, NIL },;
			                        { "D3_EMISSAO", ddatabase, NIL} } 
	
		    MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZE, 3 )
			IF lMsErroAuto
				alert('favor contactar o TI ')
				DisarmTransaction()
				MostraErro()
			Endif
    Endif

End Transaction


Return ! lMSErroAuto


***************

Static Function ConsomeApa()

***************

local nTotAp:=0
local nQTD:=0
local cQry:=''
LOCAL aMATRIZ := {}

cQry:="SELECT B1_COD,B1_UM,B2_QATU  "
cQry+="FROM SB2020 SB2, SB1010 SB1  "
cQry+="WHERE "
cQry+="B2_COD=B1_COD "
cQry+="AND B2_FILIAL='"+xFilial('SB2')+"' "
cQry+="AND B2_LOCAL='01'" 
cQry+="AND B1_TIPO='AP' "
cQry+="AND B1_COD>='268' "
cQry+="AND B2_QATU>0 " 
cQry+="AND B1_SETOR='39' " 
cQry+="AND SB1.D_E_L_E_T_!='*'  "
cQry+="AND SB2.D_E_L_E_T_!='*' "


TCQUERY cQry NEW ALIAS 'TMPY'

// Tipo de Movimentacao 504 : SAIDA DE APARA
lMsErroAuto := .F.

DbSelectArea('SD3')
SD3->(DbSetOrder(2))

nTotAp:=nPeso
If TMPY->(!EOF())
	Do while TMPY->(!EOF())	
		If nTotAp<>0		
			If nTotAp> TMPY->B2_QATU
			   nTotAp:=nTotAp-TMPY->B2_QATU
			   nQTD:=TMPY->B2_QATU
	    	Else
			   nQTD:=nTotAp
			   nTotAp:=0
			Endif			
			aMATRIZ     := {            { "D3_TM", "504", ""},;
				                        { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
				                        { "D3_FILIAL", xFilial( "SD3" ), NIL},;
				                        { "D3_LOCAL", '01', NIL },;
				                        { "D3_COD", TMPY->B1_COD, NIL},;
				                        { "D3_UM", TMPY->B1_UM, NIL },;
				                        { "D3_QUANT", nQTD, NIL },;
				                        { "D3_EMISSAO", ddatabase, NIL} } 
//			Begin Transaction
			    MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
				IF lMsErroAuto
					alert('favor contactar o TI ')
					DisarmTransaction()
					MostraErro()
				    Return .F.
				Endif
//			End Transaction			
			TMPY->(DBSKIP())		
		Else
		    Return  .T.
		EndIf		
	EndDo
Else
  Return .F.
Endif

TMPY->(DBCLOSEAREA())

Return .T.