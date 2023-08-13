#INCLUDE "PROTHEUS.CH"

User Function Fmostratela()

Local oDlg, oVar, obtnok, obtnCancel
Local nVar 	:= 0
Local cNome := space(30)

Define MSDialog oDlg Title OemToAnsi("Titulo da janela") From 0,0 To 160,380 Pixel
	
   	@05,10 To 50,180 Pixel   											//Cria um box
		
   	@15,20 Say "Tela do Curso de Advpl" Pixel Of oDlg
   	@25,20 MSGet oVar Var nVar Picture "@E 99,999.99" Size 50,10 Pixel Of oDlg
		
	@25,90 MSGet oVar Var cNome valid !empty(cNome) Picture "@!" Size 50,10 Pixel Of oDlg

	@70,20 Button oBtnOk Prompt "&Ok" Size 30,15 Pixel ;
                 Action (msginfo("Nome: " + cNome + Transform(nVar, "@E 99,999.99"))) Of oDlg
   
   	@70,80 Button oBtnCancel Prompt "&Cancelar" Size 30,15 Pixel ;
                 Action(msginfo("Cliquei no Cancelar"),oDlg:End()) Of oDlg
		
Activate MSDialog oDlg Centered

Return