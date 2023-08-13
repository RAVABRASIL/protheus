#include "rwmake.ch"        
#include "protheus.ch"

/* 
///////////////////////////////////////////////////////////////////
//Programa: ESTC008                                              //
//Objetivo: Apresenta tela para inserção das nfs saída constantes//
//          no conhecimento de frete.                            //
//          É chamada através do PE SF100I_AP7                   //
//Autoria : Flávia Rocha                                         //
//Data    : 09/03/2011.                                          //
///////////////////////////////////////////////////////////////////
*/  

//Permite a inclusão contínua de quantas notas forem necessárias,
//Tabela de notas saída por conhecimento -> ZC1

*****************************************************
User Function ESTC008( cAlias, cConheci, fr )   
*****************************************************


Local aItens	 := {}

Local cNota := ""
Local nOpcao 
Local nCta
Local x
Local xfr := fr

Private oDlg1 
Private cNF1 := Space(9)
Private cNF2 := Space(9)
Private cNF3 := Space(9) 
Private cNF4 := Space(9)
Private cNF5 := Space(9)
Private cNF6 := Space(9)  
Private cNF7 := Space(9)
Private cNF8 := Space(9)
Private cNF9 := Space(9) 
Private cNF10 := Space(9)
Private cNF11 := Space(9)
Private cNF12 := Space(9) 

aItens := {}
x := xfr - 11
While x <= xfr 
	aAdd( aItens, strzero(x,2) )     //calcula o numerador das notas de acordo com o que já foi inserido.
    x++
Enddo 

DEFINE MSDIALOG oDlg1 FROM 050,050 TO 400,520 TITLE "NF's Saída x Conhecimento de Frete" PIXEL of oDlg1
		   			
			@002,003 TO 145,230 							PIXEL of oDlg1		//RISCA
			@005,007 SAY "INSIRA a(s) NF(s) de  SAÍDA  QUE  CONSTA(M) NO CONHECIMENTO:" SIZE 228,006 COLOR CLR_HBLUE PIXEL  OF oDlg1 
			//@013,007 SAY "no CONHECIMENTO:" SIZE 228,006 COLOR CLR_HBLUE PIXEL  OF oDlg1 
		
		
			@025,025 SAY "NF Saída"	 SIZE 040,006  COLOR CLR_HBLUE PIXEL  OF oDlg1
			@025,075 SAY "NF Saída"	 SIZE 040,006  COLOR CLR_HBLUE PIXEL  OF oDlg1			
			@025,127 SAY "NF Saída"	 SIZE 040,006  COLOR CLR_HBLUE PIXEL  OF oDlg1
			    						
			@034,010 SAY aItens[1]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@034,023 MSGET cNF1		 WHEN .T.  SIZE 040,006 PIXEL OF oDlg1			
				
			@034,064 SAY aItens[2]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@034,076 MSGET cNF2	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
		
			@034,118 SAY aItens[3]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@034,129 MSGET cNF3	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
			///////////////////////////////////////////////////////////////////////////////////////			
		
			@052,010 SAY aItens[4]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@052,023 MSGET cNF4	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
		
			@052,064 SAY aItens[5]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@052,076 MSGET cNF5	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1 
		
			@052,118 SAY aItens[6]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@052,129 MSGET cNF6	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
			////////////////////////////////////////////////////////////////////////////////////////
		
			@070,010 SAY aItens[7]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@070,023 MSGET cNF7	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
		
			@070,064 SAY aItens[8]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@070,076 MSGET cNF8	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
		
			@070,118 SAY aItens[9]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@070,129 MSGET cNF9	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
			////////////////////////////////////////////////////////////////////////////////////////
		
			@088,010 SAY aItens[10]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@088,023 MSGET cNF10	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1 
		
			@088,063 SAY aItens[11]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@088,076 MSGET cNF11	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1   
		
			@088,116 SAY aItens[12]+"-"	 SIZE 010,006  COLOR CLR_HBLUE PIXEL  OF oDlg1 
			@088,129 MSGET cNF12	 WHEN .T.  SIZE 020,006 PIXEL OF oDlg1
			
			//@120,007 SAY "CASO HAJA MAIS NOTAS, CLIQUE NO BOTÃO ==>"	 SIZE 228,006  COLOR CLR_HRED PIXEL  OF oDlg1 	
			//DEFINE SBUTTON FROM 118,135 TYPE 21 ENABLE OF oDlg1 ACTION fMaisNotas(fr)	//botão "duas setas pra direita"
			
			DEFINE SBUTTON FROM 160,140 TYPE 1  ENABLE OF oDlg1 ACTION (nOpcao := 1,oDlg1:End())	//botão OK
			DEFINE SBUTTON FROM 160,180 TYPE 2  ENABLE OF oDlg1 ACTION (nOpcao := 0,oDlg1:End())	//botão Cancela
			
			ACTIVATE MSDIALOG oDlg1 //CENTERED
			
			If nOpcao = 1
						
				nCta := 1
			
			    ///1o. grava
				While nCta <= 12		// 12 notas por vez
				
					cNota := Alltrim("cNF" + Alltrim(str(nCta))  )
					
					DbselectArea("ZC1")
					ZC1->(Dbsetorder(1)) //filial + nf saida + conhecimento
					If !ZC1->(Dbseek(xFilial("ZC1") + &(cNota) + SF1->F1_DOC ))
						If !Empty(&(cNota))
													
							DbselectArea("ZC1")
							RecLock("ZC1",.T.)
							ZC1->ZC1_FILIAL := xFilial("ZC1")
							ZC1->ZC1_CONHEC := SF1->F1_DOC
							ZC1->ZC1_NFSAID := &(cNota)			
							ZC1->(MsUnlock())  
						Endif
					Endif
					
					nCta++
				Enddo
				
				If MsgYesNo("Deseja Inserir Mais Notas ? ")
					fr := fr + 12
					U_ESTC008( cAlias, cConheci,fr )
				Endif
				
			Endif
			
Return
////fim//////			
