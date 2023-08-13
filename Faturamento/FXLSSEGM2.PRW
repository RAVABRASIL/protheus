#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "


User Function FXLSSGM2()

Local oReport
Local cPerg	:= "RFATR03"


if !Pergunte(cPerg,.T.)
   Return 
endif

MsAguarde( { || U_FXLSSGM() }, "Aguarde. . .", " " )

Return

