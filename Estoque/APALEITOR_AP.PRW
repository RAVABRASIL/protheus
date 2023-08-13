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
@ 000,000 TO 160,330 Dialog oDLG1 Title "<<Entrada de APARAS>>"
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
If ! Aparas( cCODX )
   Erro( "Erro na inclusao desta apara no estoque (" + AllTrim( cCODX ) + ")" )
   Return .F.
EndIf
Reclock( "Z00", .F. )
Z00->Z00_BAIXA := "S"
Z00->( MsUnlock() )
Z00->( dbCommit() )
MostraOK()
//cPROD  := If( Z00->Z00_APARA == "1", "APARA MISTA", If( Z00->Z00_APARA == "2", "APARA BRANCA", "APARA DE SACOLA" ) )

//Comentado por Eurivan 28/01/10 - Chamado 001479 - Marcelo
//cPROD  := If( Z00->Z00_APARA == "1", "APARA MISTA", If( Z00->Z00_APARA == "2", "APARA BRANCA", If( Z00->Z00_APARA == "4", "APARA AZUL", "APARA DE SACOLA" ) ) )

if Z00->Z00_APARA == "A"
   cPROD := "APARA AZUL"
elseif Z00->Z00_APARA == "B"	  
   cPROD := "APARA BRANCA"
elseif Z00->Z00_APARA == "Y"	  
   cPROD := "APARA BRANCA HOSP"
elseif Z00->Z00_APARA == "W"	  
   cPROD := "APARA DE AL€A"
elseif Z00->Z00_APARA == "C"	  
   cPROD := "APARA PRETA"
elseif Z00->Z00_APARA == "D"	  
   cPROD := "APARA VERMELHA"
elseif Z00->Z00_APARA == "E"	  
   cPROD := "APARA AMARELA"
elseif Z00->Z00_APARA == "F"	  
   cPROD := "APARA VERDE"
elseif Z00->Z00_APARA == "G"	  
   cPROD := "APARA CINZA"
endif   


nQUANT := Z00->Z00_PESO
ObjectMethod( oQUANT, "SetText( Trans( nQUANT, '@E 999.99' ) )" )
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
ObjectMethod( oQUANT, "SetText( Trans( nQUANT, '@E 999.99' ) )" )
ObjectMethod( oPROD, "SetText( cPROD )" )
ObjectMethod( oCOD, "SetFocus()" )

Return NIL



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
	 	 !(AllTrim(SX3->x3_campo)$"BC_OPERAC") .And. !(AllTrim(SX3->x3_campo)$"BC_RECURSO/BC_QTSEGUM/BC_QTDES2/BC_QTDDES2")  .And. ;
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
  	        .F. } }
//If( Z00->Z00_APARA == "1", "189            ", If( Z00->Z00_APARA == "2", "188            ", "187            " ) ), ;
GravaSBC( Left( cCODX, 11 ), "", Z00->Z00_MAQ, "MATA685" )

Return .T.



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