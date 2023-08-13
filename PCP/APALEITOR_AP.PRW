#Include "RwMake.ch"
#include "font.ch"
#include "colors.ch"

*************

User Function APALEITOR

*************

SetPrvt( "cCOD, ODLG1, oDLG2, " )

SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
cCOD   := Space( 17 )
cCOD1  := ""
cPROD  := Space( 50 )
nQUANT := 0
@ 000,000 TO 160,330 Dialog oDLG1 Title "Entrada de aparas"
@ 011,005 Say "Codigo de barra:"
@ 010,050 Get cCOD Object oCOD Size 100,40 Valid PesqCod( cCOD )
@ 021,050 Get cCOD1 Size 00,00
@ 031,005 Say "Produto:"
@ 031,040 Say cPROD Object oPROD Size 120,40
@ 051,005 Say "Peso:"
@ 051,030 Say nQUANT Object oQUANT Size 40,40 picture "@E 999.99"
@ 065,120 BMPButton Type 2 Action Close( oDLG1 )
Activate Dialog oDLG1 Centered
Return



***************

Static Function PesqCod( cCODX )

***************

If Empty( cCODX )
	 Erro( "Informe o codigo de barra do produto" )
	 Return .F.
EndIf
If ! Z00->( Dbseek( xFilial( "Z00" ) + SubStr( cCODX, 7, 6 ) ) )
	 Erro( "Codigo de barra invalido (sequencia)" )
	 Return .F.
EndIf
If Empty( Z00->Z00_APARA )
	 Erro( "Etiqueta nao e de apara" )
	 Return .F.
EndIf
cCODX := Z00->Z00_OP + SubStr( cCODX, 7, 6 )
If Z00->Z00_BAIXA == "S"
	 Erro( "Codigo de barra ja foi lido anteriormente" )
	 Return .F.
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + Left( cCODX, 11 ), .T. ) )
If BlqInvent( If( Z00->Z00_APARA == "1", "189            ", If( cTIPO == "2", "188            ", "187            " ) ), "01" )
	Help( " ", 1, "BLQINVENT",, If( Z00->Z00_APARA == "1", "189            ", If( cTIPO == "2", "188            ", "187            " ) ) + OemToAnsi( " Almox: 01" ), 1, 11 )
	Return .F.
EndIf
If ! Aparas( cCODX )
	 Erro( "Erro na inclusao desta apara no estoque (" + AllTrim( cCODX ) + ")" )
	 Return .F.
EndIf
Reclock( "Z00", .F. )
Z00->Z00_BAIXA := "S"
Z00->( MsUnlock() )
Z00->( dbCommit() )
MostraOK()
cPROD  := If( Z00->Z00_APARA == "1", "APARA MISTA", If( cTIPO == "2", "APARA BRANCA", "APARA DE SACOLA" ) )
nQUANT := Z00->Z00_PESO
ObjectMethod( oQUANT, "SetText( Trans( nQUANT, '@E 999,99' ) )" )
ObjectMethod( oPROD, "SetText( cPROD )" )
cCOD   := Space( 17 )
ObjectMethod( oCOD, "SetFocus()" )
Return .T.



***************

Static Function Erro( cMENS )

***************

MsgAlert( cMENS )
cCOD   := Space( 17 )
cPROD  := Space( 50 )
nQUANT := 0
ObjectMethod( oQUANT, "SetText( Trans( nQUANT, '@E 999,99' ) )" )
ObjectMethod( oPROD, "SetText( cPROD )" )
ObjectMethod( oCOD, "SetFocus()" )
Return NIL



***************

Static Function Aparas( cCODX )

***************

Private aCAB := {}, ;
			  aITE := {}

aCAB := { { "BC_OP",     Left( cCODX, 11 ),  NIL },;
		      { "BC_OPERAC",  "",    NIL },;
				  { "BC_RECURS", Z00->Z00_MAQ, NIL } }

aITE := { { "BC_PRODUTO", SC2->C2_PRODUTO,  NIL },;
		      { "BC_LOCORIG", "01",    NIL },;
				  { "BC_TIPO",    "S",     NIL },;
				  { "BC_MOTIVO",  "IP", NIL },;
				  { "BC_QUANT",   Z00->Z00_PESO,  NIL },;
				  { "BC_CODDEST", If( Z00->Z00_APARA == "1", "189            ", If( cTIPO == "2", "188            ", "187            " ) ),  NIL },;
				  { "BC_LOCAL",   "01",  NIL },;
				  { "BC_QTDDEST", Z00->Z00_PESO,  NIL },;
				  { "BC_DATA",    Date(),  NIL },;
				  { "BC_OPERAD",  Z00->Z00_OPERAD,  NIL } }

MATA685( aCAB, aITE, 3 )
Return .T.
/*
Private aPERDA   := { "PRODUTO", "BC_PRODUTO", }
				aHDPERDA := {}

aPERDA := { { "D3_OP",      Left( cCODX, 11 ),  NIL },;
			      { "D3_COD",     SC2->C2_PRODUTO,    NIL },;
				    { "D3_EMISSAO", Date(),          NIL },;
				    { "D3_QUANT",   Z00->Z00_PESO / SB5->B5_QE2, NIL },;
				    { "D3_OBS",     "CODIGO DE BARRA",  NIL },;
				    { "D3_PARCTOT", "P",                NIL } }

GravaSBC( cOp, cOperacao, cRecurso, "MATA685" )
Return .T.
*/


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
