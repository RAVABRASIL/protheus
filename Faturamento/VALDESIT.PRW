#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALDESIT  ºAutor  ³Eurivan Marques     º Data ³  12/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula desconto no item CAMPOS CUSTOMIZADOS PARA NAO DES-  º±±
±±º          ³TACAR VALORES NA NOTA FISCAL.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************
User Function VALDESIT()
************************

Private nPDESC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PDESC"  } )
Private nVDESC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_VDESC"  } )
Private nPRUNIT := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
Private nPRCVEN := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRCVEN" } )
Private nVALOR  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_VALOR"  } )
Private nQTDVEN := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_QTDVEN" } )

If FWCodFil() == "01"
	if ReadVar()=="M->C6_PDESC"
	   //So calculo se o valor for diferente do informado anteriormente
	   if M->C6_PDESC <> aCols[n][nPDESC]
	      CalcZero()
	      //Atualizo C6_PRUNIT
	      aCols[n][nPRUNIT] := aCols[n][nPRUNIT]*(1-(M->C6_PDESC/100))
	      //Atualizo C6_VDESC
	      aCols[n][nVDESC]  := aCols[n][nPRCVEN]-aCols[n][nPRUNIT]
	      //Atualizo C6_PRCVEN
	      aCols[n][nPRCVEN] := aCols[n][nPRUNIT]
	      //Atualizo o Total
	      aCols[n][nVALOR]  := Round(aCols[n][nQTDVEN]*aCols[n][nPRUNIT],2)
	   endif
	elseif ReadVar()$"M->C6_PRUNIT/M->C6_PRCVEN"
	   CalcZero()
	   aCols[n][nPDESC] := 0 
	endif
	
EndIf

return .T.


//Funcao para zerar o desconto
**************************
static function CalcZero()
**************************

//Atualizo C6_PRUNIT
aCols[n][nPRUNIT] := aCols[n][nPRUNIT]+aCols[n][nVDESC]
if !ReadVar()$"M->C6_PRUNIT/M->C6_PRCVEN"
   //Atualizo C6_PRCVEN
   aCols[n][nPRCVEN] := aCols[n][nPRUNIT]
endif
//Atualizo C6_VDESC
aCols[n][nVDESC] := 0
//Atualizo o Total
aCols[n][nVALOR] := Round(aCols[n][nQTDVEN]*aCols[n][nPRUNIT],2)

return


//rotina para ORCAMETNO
************************
User Function VALDESOC()
************************

if ReadVar()=="M->CK_PDESC"
   //So calculo se o valor for diferente do informado anteriormente
   if M->CK_PDESC <> TMP1->CK_PDESC
      CalcZOrc()
      //Atualizo C6_PRUNIT
      M->CK_PRUNIT := M->CK_PRUNIT * (1-(M->CK_PDESC/100))
      //Atualizo C6_VDESC
      M->CK_VDESC  := M->CK_PRCVEN - M->CK_PRUNIT
      //Atualizo C6_PRCVEN
      M->CK_PRCVEN := M->CK_PRUNIT
      //Atualizo o Total
      M->CK_VALOR  := Round( M->CK_QTDVEN * M->CK_PRUNIT, 2)
   endif
elseif ReadVar()$"M->CK_PRUNIT/M->CK_PRCVEN"
   CalcZOrc()
   M->CK_PDESC := 0 
endif

return .T.


//Funcao para zerar o desconto
**************************
static function CalcZOrc()
**************************

//Atualizo C6_PRUNIT
M->CK_PRUNIT := M->CK_PRUNIT + M->CK_VDESC
if !ReadVar()$"M->CK_PRUNIT/M->CK_PRCVEN"
   //Atualizo C6_PRCVEN
   M->CK_PRCVEN := M->CK_PRUNIT
endif
//Atualizo C6_VDESC
M->CK_VDESC := 0
//Atualizo o Total
M->CK_VALOR := M->CK_QTDVEN * M->CK_PRUNIT

return