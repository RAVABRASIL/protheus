#Include "RwMake.ch"
#include "font.ch"
#include "colors.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

*************
User Function ESTLEITOR
*************

SetPrvt( "cCOD, ODLG1, oDLG2, " )

SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB5->( DbSetOrder( 1 ) )
cCOD   := Space( 17 )
cCOD1  := ""
cPROD  := Space( 50 )
nQUANT := 0
@ 000,000 TO 160,330 Dialog oDLG1 Title "<<Entrada de produtos SACO CAPA>>"
@ 011,005 Say "Codigo de barra:"
@ 010,050 Get cCOD Object oCOD Size 100,40 Valid PesqCod( cCOD )
@ 021,050 Get cCOD1 Size 00,00
@ 031,005 Say "Produto:"
@ 031,040 Say cPROD Object oPROD Size 120,40
@ 051,005 Say "Quantidade:"
@ 051,040 Say nQUANT Object oQUANT Size 40,40 picture "99999"
@ 065,120 BMPButton Type 2 Action Close( oDLG1 )
Activate Dialog oDLG1 Centered

Return

//Retorna a Sequencia do Produto Tipo "IS" Produto Intermediario Secundario
//20/08/08 - Eurivan Marques
*********************************
static function GetSeqOP(cCODX)
********************************

local cQuery
local cRet
local cProd

//Vejo qual é o Produto no Z00
dbSelectArea('Z00')
dbSetOrder(1)
Z00->( Dbseek( xFilial( "Z00" ) + Right( alltrim(cCODX), 6 ) ) )
cProd := Z00->Z00_CODIGO

cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO "
cQuery += "FROM "+RetSqlName("SC2")+" SC2 "
cQuery += "WHERE C2_NUM = '"+Left(cCODX,6)+"' "
cQuery += "AND C2_PRODUTO = '"+cProd+"' "
cQuery += "AND SC2.D_E_L_E_T_ = '' "
cQuery += "ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN "
TCQUERY cQuery NEW ALIAS "C2X"

C2X->( dbGoTop() )

if !C2X->(EOF())
   cRet := C2X->(C2_ITEM+C2_SEQUEN)
else
   cRet := "01001"
endif   
C2X->(DbCloseArea())

return cRet


***************
Static Function PesqCod( cCODX )
***************

Local nORD
Local cCODAUX
Local cSeq := GetSeqOP(cCODX)

If Len( AllTrim( cCODX ) ) == 12
//   cCODX   := Left( cCODX, 6 ) + "01001" + SubStr( cCODX, 7, 6 ) //Comentei em  20/08/08 estava um valor fixo (Eurivan)
   cCODX   := Left( cCODX, 6 ) + cSeq + SubStr( cCODX, 7, 6 ) //Inclui em 20/08/08 criei a funcao GetSeqOP(cOP) (Eurivan)
EndIf
If Empty( cCODX )
   Erro( "Informe o codigo de barra do produto" )
   Return .F.
EndIf
If ! Z00->( Dbseek( xFilial( "Z00" ) + SubStr( cCODX, 12, 6 ) ) )
   Erro( "Codigo de barra invalido (sequencia)" )
   Return .F.
EndIf

If Z00->Z00_OP <> Left( cCODX, 11 )
   Erro( "Codigo de barra invalido (OP)" )
   Return .F.
EndIf

If Z00->Z00_BAIXA == "S"
   Erro( "Codigo de barra ja foi lido anteriormente" )
   Return .F.
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + Left( cCODX, 11 ), .T. ) )
If BlqInvent( SC2->C2_PRODUTO, "01" )
	Help( " ", 1, "BLQINVENT",, SC2->C2_PRODUTO + OemToAnsi( " Almox: 01" ), 1, 11 )
	Return .F.
EndIf
SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
SB2->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO + "01" ) )
SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
If ! Producao( cCODX )
	 Erro( "Erro na inclusao deste fardo no estoque (" + AllTrim( cCODX ) + ")" )
	 Return .F.
EndIf
PesoReal()
nORD := SD3->( Indexord() )
SD3->( DbSetOrder( 4 ) )
SD3->( DbGobottom() )
SD3->( DbSetOrder( nORD ) )
Reclock( "Z00", .F. )
Z00->Z00_BAIXA := "S"
Z00->Z00_DOC   := SD3->D3_DOC
Z00->( MsUnlock() )
Z00->( dbCommit() )
MostraOK()
cPROD  := SB1->B1_DESC
nQUANT := Z00->Z00_QUANT
ObjectMethod( oQUANT, "SetText( Trans( nQUANT, '99999' ) )" )
ObjectMethod( oPROD, "SetText( cPROD )" )
cCOD   := Space( 17 )
ObjectMethod( oCOD, "SetFocus()" )

Return .T.



*****************************
Static Function Erro( cMENS )
*****************************

MsgAlert( cMENS )
cCOD   := Space( 17 )
cPROD  := Space( 50 )
nQUANT := 0
ObjectMethod( oQUANT, "SetText( Trans( nQUANT, '99999' ) )" )
ObjectMethod( oPROD, "SetText( cPROD )" )
ObjectMethod( oCOD, "SetFocus()" )
Return NIL



***************
Static Function Producao( cCODX )
***************

Local aMATRIZ := {}

lMsErroAuto := .F.

aMATRIZ := { { "D3_OP",      Left( cCODX, 11 ),  NIL },;
			    { "D3_COD",     SC2->C2_PRODUTO,    NIL },;
   			 { "D3_EMISSAO", Date(),          NIL },;
   			 { "D3_QUANT",   Z00->Z00_QUANT / SB5->B5_QE2, NIL },;
   			 { "D3_OBS",     "COD. BARRA " + Z00->Z00_SEQ,  NIL },;
   			 { "D3_USULIM", Z00->Z00_USULIM,                NIL },;
   			 { "D3_PARCTOT", "P",                NIL } }

Begin Transaction
	MSExecAuto( { | x | MATA250( x ) }, aMATRIZ )
	IF lMsErroAuto
		DisarmTransaction()
		Break
	Endif
End Transaction
Return ! lMSErroAuto



***************

Static Function PesoReal()

***************

If Z00->Z00_QUANT == SB5->B5_QTDFIM
	 Reclock( "SB1", .F. )
	 If ! SB2->( Eof() ) .and. SB2->B2_QATU > 0
	    SB1->B1_PESOR := ( ( SB2->B2_QATU * SB1->B1_PESO ) + Z00->Z00_PESO ) / ( SB2->B2_QATU + ( Z00->Z00_QUANT / SB5->B5_QE2 ) )
	 Else
	    SB1->B1_PESOR := Z00->Z00_PESO / ( Z00->Z00_QUANT / SB5->B5_QE2 )
	 EndIf
	 SB1->( MsUnlock() )
	 SB1->( dbCommit() )
EndIf
Return NIL



***************

Static Function MostraOK()

***************

DEFINE FONT oFont NAME "Arial" SIZE 0, -128 BOLD
DEFINE MSDIALOG oDLG2 FROM 000, 000 TO 15,50 TITLE "Leitura da etiqueta"

@ 015, 045 SAY OemToAnsi( "OK" ) Object oOBJ SIZE 130, 130
oOBJ:SetFont( oFont )
oOBJ:SetColor( CLR_GREEN )
oTimer := TTimer():New( 500, { || oTimer:End(), oDLG2:End() }, oDLG2 )
ACTIVATE TIMER oTimer
ACTIVATE MSDIALOG oDLG2 CENTERED
