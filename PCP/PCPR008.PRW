#include "protheus.ch"
#include "topconn.ch"

*************
USER FUNCTION PCPR008()
*************            

private oSAY1,oGrp1,oButton  
private cStartPath := GetSrvProfString("Startpath","")
private cNameFile	 := "microsiga" 
 
 cStartPath := AjuBarPath(cStartPath)
 cNameFile := cStartPath+cNameFile+".bmp"
	
DEFINE  MSDIALOG oDlg2 FROM 1,1 TO 230,270 TITLE "Cadastros Controle de qualidade"         PIXEL
  //  @ 0,0 BITMAP  SIZE 150,18  FILE cNameFile
 
  oSAY1:= tSAY()       :New(50 ,50,{||"Falta implementar!"},oDlg2,,,,,,.T.,CLR_RED,CLR_BLUE,100,20)
  @ 60,43    BUTTON oButton PROMPT "VOLTAR"    OF oDlg2   PIXEL ACTION  oDlg2:END()
  ACTIVATE MSDIALOG oDlg2 CENTERED
RETURN NIL


RETURN 