#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ ÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± ±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ» ±±
±±ºPrograma  ³ GPEC005  º Autor ³ Flávia Rocha       º Data ³  04/01/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ ¹±±
±±ºDescricao ³ Planilha de controle 5S                                     º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ¹±±
±±ºUso       ³ RH - Chamado: 002147 - PLANILHA DE CONTROLE P/ O PROGRAMA 5Sº±±
±±º Solicitado por Regineide em 5/05/2011                                  º±±
±±º CONFORME REUNIÃO, ONDE DEVERÁ CONT ER OS ÍNDICES DE ACORDO COM A TABELAº±±
±±º DE PONTUAÇÃO E UMA ESTRUTURA CONFORME MODELO ENTREGUE DE PLANO DE AÇÃO:º±±
±±º - ESPAÇO PARA COLOCAR A FOTO DO PROBLEMA, DESCREVER O PROBLEMA, O GUT, º±±
±±º A DATA DE ENTRADA DA FOTO, DATA DA SOLUÇÃO, COMO FOI RESOLVIDO E A FOTOº±±
±±º DO DEPOIS . - NA FOTO QUE QUE SE REPETIR O ÍNDICE DEVERÁ CAIR OU SEJA  º±±
±±º PERDE 10 PONTOS - LEMBRANDO QUE NA PONTUAÇÃO DEVERÁ CONTER UMA         º±±
±±º FORMULAÇÃO PARA FOTO QUE FO R COMUM AOS SETORES ONDE ESTÁ DEVERÁ CONTARº±±
±±º PARA TODOS NEGATIVOS OU POSITI VO(AO RESOLVER)                         º±±
±±º                                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***********************
User Function GPEC005
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
Local aCores := {{ "Z80->Z80_TIPO == 'AI'"  , 'BR_LARANJA'    },;  // Ato Inseguro
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTSOL) "  , 'BR_VERDE'  },; //Condição Insegura não respondido 
				 { "Z80->Z80_TIPO == 'CI' .AND. !Empty(Z80_DTSOL)"  , 'BR_VERMELHO' } }	 //Condição Insegura respondido 

*/


Local aCores := {{ "Z80->Z80_TIPO == 'AI'"  , 'BR_LARANJA'    },;  // Ato Inseguro
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTPREV) "  , 'BR_CINZA'  },; //Nova Condição Insegura
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTSOL) .and. !Empty(Z80_DTPREV) .and. Z80_DTPREV >= DATE()" , 'BR_AZUL'  },; //Condição insegura respondida
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTSOL) .and. !Empty(Z80_DTPREV) .and. Z80_DTPREV < DATE()"  , 'BR_VERMELHO'  },; //Condição insegura não corrigida no prazo				 
				 { "Z80->Z80_TIPO == 'CI' .AND. !Empty(Z80_DTSOL)"                                                    , 'BR_VERDE'  } } //Condição insegura corrigida

/*
Local aCores := {{ "Z80->Z80_TIPO == 'AI'"  , 'BR_LARANJA'    },;  // Ato Inseguro
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTRESP) "  , 'BR_CINZA'  },; //Nova Condição Insegura
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTSOL) .and. !Empty(Z80_DTRESP) "  , 'BR_AZUL'  },; //Condição insegura respondida
				 { "Z80->Z80_TIPO == 'CI' .AND. (!Empty(Z80_DTSOL) .and. Z80_DTSOL > Z80_DTPREV) "  , 'BR_VERMELHO'  },; //Condição insegura não corrigida no prazo				 
				 { "Z80->Z80_TIPO == 'CI' .AND. (!Empty(Z80_DTSOL) .and. Z80_DTSOL <= Z80_DTPREV) "  , 'BR_VERDE'  } } //Condição insegura corrigida

*/
Private cCadastro := "Controle do 5S"
//Private nOpc := 0
Private nOpTipo := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("Z80")
dbSetOrder(1)

/*
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
					{"Ver Cond.Inseg","U_TELA5S",0,2} ,;
            		{"Ver Ato Inseg","Alert('Em Desenvolvimento')",0,2} ,;
            		{"Incluir"   ,"U_Inclui5s",0,3} ,;
             		{"Responder" ,"U_TELA5S",0,4} ,;
             		{"Excluir"   ,"U_TELA5S",0,5},;
             		{"ALTERAR"   ,"U_TELA5S",0,6},;
             		{"FeedBack"  ,"U_TELA5S",0,7},;
             		  {"Legenda"   ,"U_5SLeg()",0,8} }	   
*/             		  
             		  
             		  Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
					{"Visualizar","U_TELA5S",0,2} ,;
            		{"Incluir"   ,"U_Manut5s",0,3} ,;
             		{"Responder" ,"U_TELA5S",0,4} ,;
             		{"Excluir"   ,"U_Manut5S",0,5},;
             		{"ALTERAR"   ,"U_TELA5S",0,6},;
             		{"FeedBack"  ,"U_TELA5S",0,7},;
             		  {"Legenda"   ,"U_5SLeg()",0,8} }	   
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "Z80" 
Private lBoxSim   := .F.
Private lBoxNao   := .F.

Private lBox4:= .F.
Private lBox5:= .F.
Private lBox6:= .F.
Private lBox7:= .F.
Private lBox8:= .F.
Private lBox9:= .F.
Private lBox10:= .F.
Private lBox11:= .F.
Private lBox12:= .F.
Private lBox13:= .F.
Private lBox14:= .F.
Private cTurno:= ""
Private cAInome   := Space(20)
Private cAIgestor := Space(20) 
Private cMatQ  := Space(6)
Private cQuemApl := Space(40)
Private cMatF    := Space(6)
Private cMatG    := Space(6)
SetPrvt("oCBoxO1" ,"oCBoxO2", "oCBoxO3","oCBoxO4","oCBoxO5","oCBoxO6","oCBoxO7","oCBoxO8","oCBoxO9","oCBoxO10","oCBoxO11", "oCBoxO12","oCBoxO13","oCBoxO14")

dbSelectArea(cString)
//mBrowse( 6,1,22,75,cString) 
mBrowse( 6, 1,22,75, cString,,,,,,aCores)

Return



***************************
User Function TELA5S(cAlias,nReg,nOpc,lFora, cQuestion, cSector, cCODAUD )
***************************

//Local cTitle := iif( nOpc = 2," - Visualizar", iif(nOpc = 3, " - Incluir", iif( nOpc = 4, " - Responder", iif( nOpc = 5, " - Excluir", " - Alterar" ) )))
Local cTitle := iif( nOpc = 2," - Visualizar", iif(nOpc = 3, " - Incluir",;
                iif( nOpc = 4, " - Responder", iif( nOpc = 5, " - Excluir",;
                iif( nOpc = 6, " - Alterar"  , " - FeedBack do Responsável") ) )))

Local oSay_numsoL
Local oSay_problem

Local oSay_Emiss  
Local oEmissao
Local oSay_Gutot

Local oSay_fotoA  
Local oSay_dtfot
Local odatafot
Local cDatafot 
Local oSay_solant 
Local oSay_nome  
Local oSay_resp1  
Local oSay_resp2  
Local oSay_resp3
Local oSay_Justif
Local oSay_Area

Local oresp1 
Local cResp1 
Local onome1
Local cNome1  

Local oresp2  
Local cResp2
Local onome2  
Local cNome2

Local oresp3
Local cResp3  
Local onome3
Local cNome3  

Local oSay_fotod  
Local oGrp2 
Local oGrpGut
Local oSay_G 
Local oSay_U
Local oSay_T 


Local oSBtn1 
Local oSBtn2
Local oSay_datas
Local oSay_Respo
Local nIndice := 0 
Local cArq := "*.jpg"
Local aDir := Directory(cArq)
Local oSay_Reinc


Private lMostra
Private oProblema
Private oReincid
Private oSolant
Private oCBoxG
Private oCBoxU
Private oCBoxT
Private oCBoxArea
Private oArea
Private oFotoD
Private oResposta
Private oFotoA
Private cEmissao := dDatabase  
Private cPrevisao:= Ctod("  /  /    ")
Private cNumSol  := "" 
Private cProblema:= ""
Private cJustif  := ""
Private cResposta:= "" 
Private cSolant := Space(6)
Private cDataSoL:= Ctod("  /  /    ")
Private cTot := 0
Private nG := ""
Private nU := "" 
Private nT := ""
Private nArea := ""
Private cArea := ""
Private nSetor:= ""
Private cSetor:= ""
Private lMarkR
Private oSayQuem
Private oSayPrev
Private oSayOrc
Private oOrcam
Private oQuem
Private cQuemCod := Space(6) 
Private cQuem    := Space(15)
Private nOrcam   := 0 //Space(20)
    
Private oDlg1
Private oGrp1
Private cFotoA := ""
Private cFotoD := ""
Private cCaminho := ""

Private cIntegr := "" //USADO PARA GRAVAR O RESPONSÁVEL
Private cIntegr2:= "" //USADO PARA GRAVAR O GESTOR
Private aRespons:= {}
Private aRespons2:= {}
Private aRet    := {}
Private aRetUs  := {}
Private nDias   := 0 
Private nOpcA   := 0 
Private oBtnFA
Private oBtnFD 
Private oGutot
Private oBtn1 
Private oJustif
Private cLogado := __CUSERID
Private aAreas  := {}
Private aSetores:= {}

//FR
//usados na tela Ato Inseguro
Private xNumSol   := ""
Private dDtSoli   := CTOD("  /  /    ") //dDatabase


SetPrvt("oDlgz","oSayNome","oGetNome","oSayGestor","oGetGestor","oSayTurno","oCBoxTurno","oSayReinci","oCBoxSim","oCBoxNao","oGrpOcorr" )
//SetPrvt("oCBoxO1" ,"oCBoxO2", "oCBoxO3","oCBoxO4","oCBoxO5","oCBoxO6","oCBoxO7","oCBoxO8","oCBoxO9","oCBoxO10","oCBoxO11", "oCBoxO12","oCBoxO13")
SetPrvt("oSayDTSol", "oGetDTSol", "oSayCODSOL","oGetCODSOL", "oBtnAto1", "oBtnAto2")

//FR - 14/08/13 - ALINE SOLICITOU QUE OS MEMBROS DA EQUIPE 5S TAMBÉM TENHAM ACESSO A REGISTRAR O FEEDBACK
/*
If nOpc = 7
	If !Alltrim(cLogado) $ Z80->Z80_INTEGR .and. !Alltrim(cLogado) $ Z80->Z80_INTEG2
		Aviso(	cCadastro,;
						"Somente o(s) Responsável(is) por esta Solicitação Poderão Inserir Feedback. Contate o Administrador do Sistema.",;
						{"&Continua"},,;
						"Solicitação: " + Z80->Z80_NUMSOL )
						Return(Nil)	
	Endif
Endif
*/

////////////////////////////////////////////////////
If nOpc = 3
	cNumsol    := GetSxENum("Z80","Z80_NUMSOL")
	while Z80->( DbSeek( xFilial( "Z80" ) + cNumsol ) )
	   ConfirmSX8()
	   cNumsol := GetSxeNum("Z80","Z80_NUMSOL")
	end
Endif


If nOpc = 3 .or. nOpc = 6 
	//alimenta áreas
	SX5->(Dbsetorder(1))
	If SX5->(Dbseek(xFilial("SX5") + "5S" ))
		While !SX5->(EOF()) .and. SX5->X5_TABELA = '5S'
			Aadd( aAreas, SX5->X5_CHAVE + '-' + SX5->X5_DESCRI) 
			SX5->(DBSKIP())
		Enddo
	Endif 
	//alimenta setores
	SX5->(Dbsetorder(1))
	If SX5->(Dbseek(xFilial("SX5") + "ZW" ))
		While !SX5->(EOF()) .and. SX5->X5_TABELA = 'ZW'
			Aadd( aSetores, SX5->X5_CHAVE + '-' + SX5->X5_DESCRI) 
			SX5->(DBSKIP())
		Enddo
	Endif
	
Endif

If lFora
	nProc     := 0
	cProblema := cQuestion //já carrega o descritivo do problema, quando a chamada for de "fora" (programa Auditoria 5S)
	//nSetor    := cSector   //já carrega o setor
	nProc  := Ascan(aSetores, cSector)
	nSetor  := aSetores[nProc]
Endif

/*Aadd( aAreas, "1-Infra- estrutura") 
Aadd( aAreas, "2-Limpeza")
Aadd( aAreas, "3-Organização")
Aadd( aAreas, "4-Utilização")
Aadd( aAreas, "5-Saúde e Segurança")
*/

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
If ALLTRIM(Z80->Z80_TIPO) = "AI"
	If nOpc = 2
		PrepCampos(nOpc)
	Endif
ELSE  //NÃO É ATO INSEGURO, É CONDIÇÃO INSEGURA

	If nOpc = 3 .or. nOpc = 6      //incluir ou alterar	
		//oDlg1      := MSDialog():New( 153,233,591,1107,"PROGRAMA 5S" + cTitle,,,.F.,,,,,,.T.,,,.F. ) 
		//oGrp1      := TGroup():New( 006,006,200,429,"  SOLICITAÇÃO  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		oDlg1      := MSDialog():New( 153,233,591,1025,"PROGRAMA 5S" + cTitle,,,.F.,,,,,,.T.,,,.F. ) 
		oGrp1      := TGroup():New( 006,006,200,385,"  SOLICITAÇÃO  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 	 	
	Elseif nOpc = 7	               //feedback -> qdo responsável digita a data prevista solução e coloca valor orçado (se aplicável)
		//oDlg1      := MSDialog():New( 153,233,621,1107,"PROGRAMA 5S" + cTitle,,,.F.,,,,,,.T.,,,.F. ) 
		//oGrp1      := TGroup():New( 006,006,220,429,"  SOLICITAÇÃO  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 	
		oDlg1      := MSDialog():New( 153,233,621,1025,"PROGRAMA 5S" + cTitle,,,.F.,,,,,,.T.,,,.F. ) 
		oGrp1      := TGroup():New( 006,006,220,385,"  SOLICITAÇÃO  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) 	
	Elseif nOpc = 2 .or. nOpc = 4 .or. nOpc = 5    //visualizar, responder, alterar -- responder é quando a equipe 5S digita a data de solução definitiva
	
		//oDlg1      := MSDialog():New( 031,233,571,1109,"PROGRAMA 5S"+cTitle,,,.F.,,,,,,.T.,,,.F. )	
		//oGrp1      := TGroup():New( 006,007,184,430,"  SOLICITAÇÃO  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )	
		
			oDlg1      := MSDialog():New( 031,233,571,1025,"PROGRAMA 5S"+cTitle,,,.F.,,,,,,.T.,,,.F. )	
			oGrp1      := TGroup():New( 006,007,184,385,"  SOLICITAÇÃO  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )	
	Endif

	oSay_numsoL := TSay():New( 020,015,{||"Num. Solicitação"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
	
	oNumsoL     := TGet():New( 022,070,,oGrp1,057,008,'@!',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cNumsol",,)
	oNumsoL:bSetGet := {|u| If(PCount()>0,cNumsol:=u,cNumsol)}
	oNumsoL:Disable()
	
	oSay_problem:= TSay():New( 038,015,{||"Descrição Solicitação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,009)
	oProblema  := TMultiGet():New( 049,014,,oGrp1,161,040,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	oProblema:bSetGet := {|u| If(PCount()>0,cProblema:=u,cProblema)}
	
	oSay_Emiss  := TSay():New( 020,143,{||"Data Solic."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oEmissao   := TGet():New( 019,178,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmissao",,)
	oEmissao:bSetGet := {|u| If(PCount()>0,cEmissao:=u,cEmissao)} 
	oEmissao:Disable()
	
	oSay_fotoA  := TSay():New( 012,280,{||"Foto Antes:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,031,009)
	oFotoA      := TBitmap():New( 022,270,100,070,,"",.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBtnFA      := TButton():New( 101,300,"Carrega Foto",oGrp1,{||TrazFoto( @oFotoA, "A" )},037,012,,,,.T.,,"",,,,.F. ) 
	
	oSay_Area  := TSay():New( 035,180,{||"Pertinente a Área:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,009)
	oSay_Depto := TSay():New( 102,120,{||"Setor:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
	If lFora
		oSayAUD    := TSay():New( 065,180,{||"Ref.Auditoria:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,009)
		oGetAUD    := TGet():New( 077,180,,oGrp1,072,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.T.,.F.,"","cCODAUD",,) 
		oGetAUD:bSetGet := {|u| If(PCount()>0, cCODAUD:=u,cCODAUD)}   
	Endif
	If nOpc = 3 .or. nOpc = 6  //nOpc <> 2 .and. nOpc <> 5 .and. nOpc <> 4
		oCBoxArea     := TComboBox():New( 047,180,,aAreas,081,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nArea ) 
		oCBoxArea:bSetGet := {|u| If(PCount()>0,nArea:=u,nArea)} 
		
		oCBoxSetor     := TComboBox():New( 102,145,,aSetores,120,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSetor ) 
		oCBoxSetor:bSetGet := {|u| If(PCount()>0,nSetor:=u,nSetor)} 
		
	Else        //2-visualizar, 4-responder, 5-excluir, 7-feedback
		oCBoxArea     := TComboBox():New( 047,180,,aAreas,081,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nArea ) 
		oCBoxArea:lVisibleControl:= .F.
		oArea:= TGet():New( 047,180,,oGrp1,072,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cArea",,)   
		oArea:bSetGet := {|| cArea := fQualArea( nArea , "A" ) }
		oArea:lReadOnly   := .T. 
		
		oCBoxSetor     := TComboBox():New( 102,145,,aSetores,120,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSetor ) 
		oCBoxSetor:lVisibleControl:= .F.
		oSetor:= TGet():New( 102,145,,oGrp1,120,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cSetor",,)   
		oSetor:bSetGet := {|| cSetor := fQualArea( nSetor , "D" ) }
		oSetor:lReadOnly   := .T. 
		
	Endif
	
	oGrpRe      := TGroup():New( 120,250,155,380," Reincidência ? ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oSay_solan := TSay():New( 133,257,{||"Solicit. Anterior"},oGrpRe,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
	oSolant    := TGet():New( 131,304,,oGrpRe,072,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z80","cSolant",,)
	oSolant:bSetGet := {|u| If(PCount()>0,cSolant:=u,cSolant)}
	
	//codigo
	oSayQuem := TSay():New( 123,015,{||"Quem Enviou Foto :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
	oQuemCod    := TGet():New( 121,065,,oGrp1,072,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"US2","cQuemCod",,)
	oQuemCod:bSetGet := {|u| If(PCount()>0,cQuemCod:=u,cQuemCod)}
	oQuemCod:bValid := {|| FValUSR(cQuemCod) } 
	///Z80_QUENV
	
	//nome
	oQuem       := TGet():New( 121,145,,oGrp1,072,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cQuem",,)  
	oQuem:bSetGet := {|| cQuem := fQuemEnv( cQuemCod ) }
	oQuem:lReadOnly   := .T. 
	
	If nOpc <> 3
		//data prevista de solução
		oSayPrev := TSay():New( 147,015,{||"Dt.Prevista Solução:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
		oPrevisao   := TGet():New( 145,065,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrevisao",,)
		oPrevisao:bSetGet := {|u| If(PCount()>0,cPrevisao:=u,cPrevisao)} 
	
		///previsão orçamentária para resolução
		oSayOrc := TSay():New( 138,145,{||"Orçamento Previsto:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
		//oOrcam  := TGet():New( 147,145,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nOrcam",,)
		oOrcam    := TGet():New( 145,145,{|u| If(PCount()>0,nOrcam:=u,nOrcam)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nOrcam",,)
		//oOrcam:bSetGet := {|u| If(PCount()>0,nOrcam:=u,nOrcam)}
	
		oSay_Justif:= TSay():New( 160,015,{||"Justif. Responsável:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,009)
		oJustif  := TMultiGet():New( 160,070,,oGrp1,131,020,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
		oJustif:bSetGet := {|u| If(PCount()>0,cJustif:=u,cJustif)}
	Endif
	
	///integrantes
	oBtn1      := TButton():New( 102,015,"Responsável",oGrp1,{||ListUser(nOpc)},037,012,,,,.T.,,"",,,,.F. ) 
	
	///integrantes 2 - 50% GUT
	oBtn2     := TButton():New( 102,065,"Gestor",oGrp1,{||ListUser2(nOpc)},037,012,,,,.T.,,"",,,,.F. ) 
	
	If nOpc <> 3 .and. nOpc <> 6 .and. nOpc <> 7  
	
		oGrp3      := TGroup():New( 188,007,248,385," RESOLUÇÃO ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )	
		oSay_Respo := TSay():New( 196,012,{||"Descrição Resposta"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,009)
		oResposta  := TMultiGet():New( 196,073,,oGrp3,149,025,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
		oResposta:bSetGet := {|u| If(PCount()>0,cResposta:=u,cResposta)}
		
		oSay_datas := TSay():New( 231,012,{||"Data p/ Solução:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
		odatasoL   := TGet():New( 231,073,,oGrp3,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDataSoL",,)
		odatasoL:bSetGet := {|u| If(PCount()>0,cDataSoL:=u,cDataSoL)}
		//odatasoL:bValid := {||cDataSoL >= dDatabase}
		odatasoL:bValid := {||FdtValida(cDataSoL) } 
		
		oSay_fotod  := TSay():New( 196,230,{||"Foto Depois:"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oFotoD      := TBitmap():New( 196,270,110,046,,"",.F.,oGrp3,,,.F.,.T.,,"",.T.,,.T.,,.F. )  
		oBtnFD      := TButton():New(217,230,"Carrega Foto",oGrp1,{||TrazFoto( @oFotoD, "D" )},037,012,,,,.T.,,"",,,,.F. ) 
			
	Endif
	
	If nOpc = 3 .or. nOpc = 6 .or. nOpc = 7
		//oSBtn1     := SButton():New( 184,288,1,,oDlg1,,"", )
		//oSBtn1:bAction := {|| (nOpcA := 1, VerCampos(nOpc))} 
		
		//oSBtn2     := SButton():New( 184,328,2,,oDlg1,,"", )
		//oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  
		
		oSBtn1     := SButton():New( 204,288,1,,oDlg1,,"", )
		oSBtn1:bAction := {|| (nOpcA := 1, VerCampos(nOpc , lFora ))} 
		
		oSBtn2     := SButton():New( 204,328,2,,oDlg1,,"", )
		oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  
		
	Elseif nOpc = 2 //visualizar
		oSBtn1     := SButton():New( 252,260,1,,oDlg1,,"", )
		oSBtn1:bAction := {|| ( nOpcA := 1, VerCampos(nOpc) )} 
		
		oSBtn2     := SButton():New( 252,307,2,,oDlg1,,"", )
		oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())} 
	Elseif nOpc = 4  //responder
		oSBtn1     := SButton():New( 252,260,1,,oDlg1,,"", )
		oSBtn1:bAction := {|| ( nOpcA := 1, VerCampos(nOpc) )} 
		
		oSBtn2     := SButton():New( 252,307,2,,oDlg1,,"", )
		oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())} 
	Elseif nOpc = 5     //excluir
		oSBtn1     := SButton():New( 252,260,1,,oDlg1,,"", )
		oSBtn1:bAction := {|| ( nOpcA := 1, VerCampos(nOpc) )} 
		
		oSBtn2     := SButton():New( 252,307,2,,oDlg1,,"", )
		oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  	
	Endif
	
	If nOpc = 3  //inclusão
	//	oPrevisao:lReadOnly := .T.       //data prevista solução
	//   	oOrcam:lReadOnly    := .T.		 //orçamento previsto
	//   	oJustif:lReadOnly   := .T.		 //justificativa do responsável
	Else
		PrepCampos(nOpc)
	Endif
	
	If !Empty(Z80->Z80_DTSOL) .and. nOpc = 7  
		If !Alltrim(UPPER(Substr(cUSUARIO,7,6))) $ "ALINE.FARIAS/REGINEIDE/MANOEL.NETO/ADMINI"

			Aviso(	cCadastro,;
						"Esta Solicitação Já Foi Respondida. Contate a Equipe 5S.",;
						{"&Continua"},,;
						"Solicitação: " + Z80->Z80_NUMSOL )
						Return(Nil)
			
		Endif
	Endif
	
	If !Empty(Z80->Z80_DTSOL) .and. nOpc = 6 
		If !Alltrim(UPPER(Substr(cUsuario,7,6))) $ "ALINE.FARIAS/REGINEIDE/MANOEL.NETO/ADMINI"
			Aviso(	cCadastro,;
						"Esta Solicitação Já Foi Respondida e NÃO PODERÁ SER ALTERADA.",;
						{"&Continua"},,;
						"Solicitação: " + Z80->Z80_NUMSOL )
						Return(Nil)
		Endif
	Endif

	
	oDlg1:Activate(,,,.T.)	

ENDIF




Return 

********************************
Static Function VerCampos(nOpc , lFora)
********************************
//msgbox("nopc: " + str(nOpc) )
If nOpcA = 1

	///SÓ PERMITIR GRAVAR DEPOIS QUE TODOS OS CAMPOS ESTIVEREM PREENCHIDOS:
	///DESCRIÇÃO DA SOLICIT.
	///INTEGRANTES
	///FOTO ANTES
	///DESCRIÇÃO DA SOLUÇÃO
	///DATA SOLUÇÃO
	///FOTO DEPOIS
	If nOpc = 2
		oDlg1:End()	
	ElseIf nOpc = 3   .or. nOpc = 6 //inclusão ou alteração
		If Empty(cProblema)
			Aviso(	cCadastro,;			
				'Por favor, descreva a Solicitação...' ,;
				{"&Continua"},,;
				"Solicitação: " + cNumSoL )
				//Return(Nil)
		/*ElseIf Empty(nG)
			Aviso(	cCadastro,;			
					'Por favor, Preencha o Valor GUT -> "G" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
		ElseIf Empty(nU)
			Aviso(	cCadastro,;			
					'Por favor, Preencha o Valor GUT -> "U" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
		ElseIf Empty(nT)
			Aviso(	cCadastro,;			
					'Por favor, Preencha o Valor GUT -> "T" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )*/
					
		ElseIf Empty(cIntegr)
			Aviso(	cCadastro,;			
					'Por favor, selecione o(s) Responsável(eis) no Botão "Integrantes" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
		//Return(Nil)
		Elseif Empty(cFotoA)
			Aviso(	cCadastro,;			
					'Por favor, insira uma "Foto Antes" para esta Solicitação, Clicando no Botão "Carrega Foto" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
		Elseif Empty(nArea)
			Aviso(	cCadastro,;			
					'Por favor, Preencha a Área Pertinente ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
		Elseif Empty(nSetor)
			Aviso(	cCadastro,;			
					'Por favor, Preencha o Setor Pertinente ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
					
		Else		//se estiver tudo preenchido....GRava		
	    	oDlg1:End()
	    	Grava(nOpc , lFora)
	    	//If FERASE("\IMAGENS\" + Alltrim(cFotoA) ) == -1   
			   //MsgStop('Falha na deleção do Arquivo')
			//Else   
			   //MsgStop('Arquivo deletado com sucesso.')
			//Endif
	    	
	  	Endif
	  	
  	Elseif nOpc = 4     //resposta
  		If Empty(cResposta)
			Aviso(	cCadastro,;			
				'Por favor, descreva a Solução para esta Solicitação...' ,;
				{"&Continua"},,;
				"Solicitação: " + cNumSoL )
		ElseIf Empty(cDataSoL)
			Aviso(	cCadastro,;			
					'Por favor, digite a Data para Solução ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
		Elseif Empty(cFotoD)
			Aviso(	cCadastro,;			
					'Por favor, insira uma "Foto Depois" para a Solução, Clicando no Botão "Carrega Foto" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumSoL )
		Else
			oDlg1:End()
			Grava(nOpc)
			
		Endif
		
	Elseif nOpc = 5 .or. nOpc = 7
		//msgbox("entrou no ver campos nopc = 7")
		Grava(nOpc)
		oDlg1:End()	
	Endif
		
EndIf
	 

Return .T.

**********************************
Static Function ListUser(nOpc)
**********************************

//Local oListUser, nI, lUser := .T., lOK := .F., nPos
//Local oUser, nUser := 1, aUser := {}
//Local oSUser, nSUser := 0, aSUser := {}
Local oBtn1, oBtn2, oBtn3, oBtn4
Local oDlgGrp 
Local oBtn1
Local oBtn2
Local oBtn3
Local oBtn4
Local cResponsav := ""

//Local oSUser 
Local aUsu := {}    //zerar o array, para que a variável dos integrantes NÃO venha preenchida

Private cUser := ""
//Private aUsu  := fGUsers() //AllUsers(.T.,.T.) 
Private oListUser, nI, lUser := .T., lOK := .F., nPosU
Private oUser, nUser := 1, aUser := {} 
Private oSUser, nSUser := 0, aSUser := {}

aUsu := fGUsers()
for nI := 1 To Len(aUsu)
   if ( ! Alltrim(aUsu[nI]) $ cIntegr ) //responsável
	   Aadd(aUser,aUsu[nI])
   else
	   Aadd(aSUser,aUsu[nI])
   endIf
next

DEFINE MSDIALOG oListUser TITLE "Seleciona Responsável" FROM 00,00 TO 153,450 OF oDlgGrp PIXEL

@01,05 SAY "Colaboradores" PIXEL 
@10,05 LISTBOX oUser VAR nUser ITEMS aUser PIXEL SIZE 80,65
oUser:bChange    := {|| nSUser := 0,oSUser:Refresh()}
oUser:bLostFocus := {|| lUser := .T.}

@10,95 BUTTON oBtn1 PROMPT "&Adicionar >>" SIZE 35,11 PIXEL WHEN nOpc<>2.and.nOpc<>5.and.!Empty(aUser) ;
ACTION If(lUser,MoveUser(@lUser,@aUser,@nUser,@oUser,@aSUser,@nSUser,@oSUser,.T.),)

@01,140 SAY "Colaboradores do Grupo" PIXEL 
@10,140 LISTBOX oSUser VAR nSUser ITEMS aSUser SIZE 80,65 PIXEL
oSUser:bChange    := {|| nUser := 0,oUser:Refresh()}
oSUser:bLostFocus := {|| lUser := .F.}

@23,95 BUTTON oBtn2 PROMPT "<< &Remover" SIZE 35,11 PIXEL WHEN nOpc<>2.and.nOpc<>5.and.!Empty(aSUser); 
ACTION If(!lUser,MoveUser(@lUser,@aUser,@nUser,@oUser,@aSUser,@nSUser,@oSUser,.F.),)

@36,95 BUTTON oBtn3 PROMPT "&OK" SIZE 35,11 PIXEL DEFAULT ACTION (lOK := .T.,OkUser(@aSUser, nOpc), oListUser:End())

//@49,95 BUTTON oBtn4 PROMPT "&Cancelar" SIZE 35,11 PIXEL ACTION oListUser:End() 

//@49,95 BUTTON oBtn4 PROMPT "&Pesquisar" SIZE 35,11 PIXEL ACTION (fPesqUser(oUser,nUser,oSUser,lUser))
@62,95 BUTTON oBtn4 PROMPT "&Cancelar" SIZE 35,11 PIXEL ACTION oListUser:End()  

if nOpc = 2 .or. nOpc = 5 .or. nOpc = 4
   oBtn3:Disable()
   oBtn4:Disable()
endif

ACTIVATE DIALOG oListUser CENTERED

Return NIL


**********************************
Static Function ListUser2(nOpc)
**********************************


Local oBtn1, oBtn2, oBtn3, oBtn4
Local oDlgGrp 
Local oBtn1
Local oBtn2
Local oBtn3
Local oBtn4
Local cResponsav := ""

//Local oSUser 
Local aUsu2 := {}    //zerar o array, para que a variável dos integrantes NÃO venha preenchida

Private cUser2 := ""
//Private aUsu  := fGUsers() //AllUsers(.T.,.T.) 
Private oListUser2, nI2, lUser2 := .T., lOK2 := .F., nPosU2
Private oUser2, nUser2 := 1, aUser2 := {} 
Private oSUser2, nSUser2 := 0, aSUser2 := {}

aUsu2 := fGUsers()
for nI2 := 1 To Len(aUsu2)
   if ( ! Alltrim(aUsu2[nI2]) $ cIntegr2 ) //GESTOR
	   Aadd(aUser2,aUsu2[nI2])
   else
	   Aadd(aSUser2,aUsu2[nI2])
   endIf
next

DEFINE MSDIALOG oListUser2 TITLE "Seleciona Gestor" FROM 00,00 TO 153,450 OF oDlgGrp PIXEL

@01,05 SAY "Colaboradores" PIXEL 
@10,05 LISTBOX oUser2 VAR nUser2 ITEMS aUser2 PIXEL SIZE 80,65
oUser2:bChange    := {|| nSUser2 := 0,oSUser2:Refresh()}
oUser2:bLostFocus := {|| lUser2 := .T.}

@10,95 BUTTON oBtn1 PROMPT "&Adicionar >>" SIZE 35,11 PIXEL WHEN nOpc<>2.and.nOpc<>5.and.!Empty(aUser2) ACTION If(lUser2,_MoveUser(@lUser2,@aUser2,@nUser2,@oUser2,@aSUser2,@nSUser2,@oSUser2,.T.),)

@01,140 SAY "Colaboradores do Grupo" PIXEL 
@10,140 LISTBOX oSUser2 VAR nSUser2 ITEMS aSUser2 SIZE 80,65 PIXEL
oSUser2:bChange    := {|| nUser2 := 0,oUser2:Refresh()}
oSUser2:bLostFocus := {|| lUser2 := .F.}

@23,95 BUTTON oBtn2 PROMPT "<< &Remover" SIZE 35,11 PIXEL WHEN nOpc<>2.and.nOpc<>5.and.!Empty(aSUser2); 
ACTION If(!lUser2,_MoveUser(@lUser2,@aUser2,@nUser2,@oUser2,@aSUser2,@nSUser2,@oSUser2,.F.),)

@36,95 BUTTON oBtn3 PROMPT "&OK" SIZE 35,11 PIXEL DEFAULT ACTION (lOK2 := .T.,OkUser2(@aSUser2, nOpc), oListUser2:End())

//@49,95 BUTTON oBtn4 PROMPT "&Cancelar" SIZE 35,11 PIXEL ACTION oListUser:End() 

//@49,95 BUTTON oBtn4 PROMPT "&Pesquisar" SIZE 35,11 PIXEL ACTION (fPesqUser(oUser,nUser,oSUser,lUser))
@62,95 BUTTON oBtn4 PROMPT "&Cancelar" SIZE 35,11 PIXEL ACTION oListUser2:End()  

if nOpc = 2 .or. nOpc = 5 .or. nOpc = 4
   oBtn3:Disable()
   oBtn4:Disable()
endif

ACTIVATE DIALOG oListUser2 CENTERED

Return NIL



/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ OkUser()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
********************************
Static Function OkUser(aSUser, nOpc)
********************************

local nX



aRespons:= {}

If nOpc = 3
	cIntegr := "" //responsável
	for nX := 1 to Len(aSUser)
	   cIntegr += Alltrim(aSUser[nX]) + " / "
	   Aadd(aRespons, Substr(aSUser[nX],1,6) )
	   
	next nX
	

Elseif nOpc = 6 
	cIntegr := "" //responsável
	for nX := 1 to Len(aSUser)
	   If !Alltrim(aSUser[nX]) $ cIntegr //responsável
	   		cIntegr += Alltrim(aSUser[nX]) + " / "
	   		Aadd(aRespons, Substr(aSUser[nX],1,6) )
	   Endif
	   
	next nX
	
Endif


return 

********************************
Static Function OkUser2(aSUser2, nOpc)
********************************

local nX



aRespons2:= {}

If nOpc = 3
	cIntegr2 := "" //gestor
	for nX := 1 to Len(aSUser2)
	   cIntegr2 += Alltrim(aSUser2[nX]) + " / " //gestor
	   Aadd(aRespons2, Substr(aSUser2[nX],1,6) )
	   
	next nX
	

Elseif nOpc = 6 
	cIntegr2 := "" //gestor
	for nX := 1 to Len(aSUser2)
	   If !Alltrim(aSUser2[nX]) $ cIntegr2 //gestor
	   		cIntegr2 += Alltrim(aSUser2[nX]) + " / " //gestor
	   		Aadd(aRespons2, Substr(aSUser2[nX],1,6) )
	   Endif
	   
	next nX
	
Endif


return


/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ GetUsers() Retorna array com nomes de todos os usuarios SIGA
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
**********************************
Static function fGUsers(lBranco)
**********************************
local aUsu  := AllUsers()


local nX
aRet := {}

Default lBranco := .F.
if lBranco
   Aadd(aRet," ")
endif

for nX := 1 to Len( aUsu )
   if aUsu[nX,1,1] # '000000' .and. !aUsu[nX,1,17] //Exceto Administrador
      //Aadd( aRet, aUsu[nX,1,2] )
      Aadd( aRet, (aUsu[nX,1,1] + '-' + UPPER(aUsu[nX,1,4])) )
   endif
next nX

//ASort( aRet,,, { |x,y| x < y } )
ASort( aRet,,, { |x,y| Substr(x,8,(Len(x) - 8))  < Substr(y,8,(Len(y) - 8)) } )
Return aRet


*****************************
Static Function TrazFoto( oFoto, cVar )
***************************** 

Local cFile   := ""
Local nPos    := 0
Local cFile2  := ""
Local cDir    := GetMv("RV_5SDIR")     

/*
oFotoA:cBMPFile:=@cImagem
oFotoA:Load(cImagem)
oFotoA:Refresh()
oDlg1:Refresh()
cFotoA := cImagem 

//cRetAux  	  := cGetFile(cTipoArq,STR0007,0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)  //"Escolha o arquivo de Mala Direta"
//cGetFile( '*.txt' , 'Textos (TXT)', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
//cFile  := cGetFile( '*.JPG |*.JPG|',"Escolha o arquivo da Foto",0,"C:\Temp\",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)  //"Escolha o arquivo de Mala Direta"
//cFile  := cGetFile( '*.JPG |*.JPG|',"Escolha o arquivo da Foto",0, "SERVIDOR\IMAGENS",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)  //"Escolha o arquivo de Mala Direta"

//oFotoA:cBMPFile:=@cFile
//oFotoA:Load(cFile)
//oFotoA:Refresh()
*/

//a máscara ajuda pois não mostrará outro tipo de arquivo, apenas arquivo *.JPG
cFile  := cGetFile( '*.JPG |*.JPG|',"Escolha o arquivo da Foto",0,Alltrim(cDir),.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)  //"Escolha o arquivo de Mala Direta"
oFoto:cBMPFile:=@cFile
oFoto:Load(cFile)
oFoto:Refresh()
oDlg1:Refresh()

If cVar = "A"
	cFotoA := cFile 
Elseif cVar = "D"
	cFotoD := cFile 
Endif
//MsgInfo("Foto adicionada com Sucesso !")   

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MoveUser(lUser,aUser,nUser,oUser,aSUser,nSUser,oSUser,lAdd)
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
******************************************************************************
Static Function MoveUser(lUser,aUser,nUser,oUser,aSUser,nSUser,oSUser,lAdd)
******************************************************************************
Local nMove := 0

If ( lAdd )
	if nUser > 0
	nMove := nUser
	Aadd(aSUser,aUser[nUser])
	ADel(aUser,nUser)
	ASize(aUser,Len(aUser)-1)
	oSUser:SetItems(aSUser)
	oUser:SetItems(aUser)
	If ( !Empty(aUser) )
		nUser := nMove
		If ( nUser > Len(aUser) )
			nUser := Len(aUser)
		EndIf
		oUser:Refresh()
	Else
		lUser := .F.
		nSUser := 1
		oSUser:Refresh()
	EndIf
	endif
Else
	if nSUser > 0 
	 //if cUSer == aSUSer[nSUser]
	 //   Aviso( "Aviso","O colaborador selecionado não poderá ser removido, pois é o lider do Grupo.",{"OK"})
	 //   Return
	 //endif
	
	//if ExistTrf(aSUSer[nSUser],cCodGrp)
	//    Aviso( "Aviso","O colaborador selecionado não poderá ser removido, pois já existe(m) tarefa(s) associada(s) a ele nos Projetos.",{"OK"})
	//    Return
	//endif
	
	
		Aadd(aUser,aSUser[nSUser])
		ADel(aSUser,nSUser)
		ASize(aSUser,Len(aSUser)-1)
		
		oSUser:SetItems(aSUser)
		oUser:SetItems(aUser)
		If ( !Empty(aSUser) )
			nUser := 1
			oUser:Refresh()
		Else
			lUser := .T.
			nUser := Len(aUser)
			oUser:Refresh()
		EndIf
	endif
EndIf

Return NIL 

******************************************************************************
Static Function _MoveUser(lUser2,aUser2,nUser2,oUser2,aSUser2,nSUser2,oSUser2,lAdd2)
******************************************************************************
Local nMove := 0

If ( lAdd2 )
	if nUser2 > 0
		nMove := nUser2
		Aadd(aSUser2,aUser2[nUser2])
		ADel(aUser2,nUser2)
		ASize(aUser2,Len(aUser2)-1)
		oSUser2:SetItems(aSUser2)
		oUser2:SetItems(aUser2)
		If ( !Empty(aUser2) )
			nUser2 := nMove
			If ( nUser2 > Len(aUser2) )
				nUser2 := Len(aUser2)
			EndIf
			oUser2:Refresh()
		Else
			lUser2 := .F.
			nSUser2 := 1
			oSUser2:Refresh()
		EndIf
	endif
Else
	if nSUser2 > 0 	
	
		Aadd(aUser2,aSUser2[nSUser2])
		ADel(aSUser2,nSUser2)
		ASize(aSUser2,Len(aSUser2)-1)
		
		oSUser2:SetItems(aSUser2)
		oUser2:SetItems(aUser2)
		If ( !Empty(aSUser2) )
			nUser2 := 1
			oUser2:Refresh()
		Else
			lUser2 := .T.
			nUser2 := Len(aUser2)
			oUser2:Refresh()
		EndIf
	endif
EndIf

Return NIL 


************************************
Static Function fGutot(nG, nU, nT, oGut )
************************************

Local nTota := 0
Local cTota := ""
nTota := Val(nG) + Val(nU) + Val(nT)
cTota := Alltrim(Str(nTota))
//oGut:Refresh()
//oGut:CtrlRefresh()
//ObjectMethod( oGut, "Refresh()" )

Return( cTota ) 

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ PrepCampos(nOpc)
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
************************************
Static Function PrepCampos(nOpc)
************************************

Local nTotal := 0
Local cImagemA:= "" //"C:\Temp\"
Local cImagemD:= "" //"C:\Temp\" 
Local aUsuarios := {}  
Local aUser     := {}
Local aSUser    := {}

DbSelectArea("Z80")



if nOpc <> 3         //Se for: 2 - visualiza , 4 - responder , 5 - exclui, 6 - altera , 7 - feedback
   
	IF ALLTRIM(Z80->Z80_TIPO) != 'AI'  //SE NÃO FOR ATO INSEGURO, SEGUE COM A COLETA DE DADOS PARA TELA CONDIÇÃO INSEGURA
	
	   //na alteração (6) é possível alterar:
		//GUT
		//DESCRIÇÃO DO PROBLEMA
		//INTEGRANTES
		//SOLICITAÇÃO ANTERIOR
		//ÁREA
		
		//não é possível :
		   //alterar a foto. para isto, é recomendável excluir a solicitação e criar outra.
		   //quem enviou a foto, idem acima
		
	   //carrega campos
	   cNumSol  := Z80->Z80_NUMSOL
	   cEmissao := Z80->Z80_EMISSA
	   cProblema:= MSMM(Z80->Z80_CODMP,80)        //para carregar Z80->Z80_PROBLE
	   cResposta:= MSMM(Z80->Z80_CODMR,80) 	      //Z80->Z80_RESPOS
	   cDataSoL := Z80->Z80_DTSOL
	   cSolant  := Z80->Z80_SOLANT
	   cPrevisao:= Z80->Z80_DTPREV
	   //cJustif  := MSMM(Z80->Z80_CODMJ,80) 	      //Z80->Z80_RESPOS  
	   cJustif   := Z80->Z80_JUSTIF
	   
	   cIntegr  := Z80->Z80_INTEGR //responsável
	   cIntegr2 := Z80->Z80_INTEG2 //gestor
	   cQuemCod := Z80->Z80_QUENV
	   cQuem    := fQuemEnv(cQuemCod)  
	   nOrcam   := Z80->Z80_PRVORC
	   
	   nG       := Z80->Z80_GUT_G
	   nU       := Z80->Z80_GUT_U
	   nT       := Z80->Z80_GUT_T
	   nTotal   := Val(nG) + Val(nU) + Val(nT) 
	   nArea    := Z80->Z80_AREA
	   nSetor   := Z80->Z80_SETOR
	   cTot     := Alltrim(Str(nTotal)) 
	   cFotoA   := Alltrim(Z80->Z80_FOTOA)
	   cCaminho := Alltrim(Z80->Z80_PATHA)
	   cImagemA  += Alltrim(Z80->Z80_PATHA) + Alltrim(Z80->Z80_FOTOA)
	   
	   
	   oFotoA:cBMPFile:=@cImagemA
	   oFotoA:Load(cImagemA)
	   //oFotoA:lReadOnly     := .T.
	   oFotoA:Refresh()
	   oBtnFA:Disable()   
	  
	   
	   If nOpc = 2 .or. nOpc = 5    //visualizar ou excluir
	   	oProblema:lReadOnly := .T.       //DESCRIÇÃO DO PROBLEMA 
	   	
	  // 	oCBoxG:lReadOnly    := .T.       //Combo box do Gut = G
	  // 	oCBoxU:lReadOnly    := .T.       //Combo box do Gut = U
	  // 	oCBoxT:lReadOnly    := .T.       //Combo box do Gut = T
	  //  	oGutot:lReadOnly    := .T.		 //Gut Total
	   	//oCBoxArea:lReadOnly := .T.       //Areas
	   	oBtn1:Disable()					 //botão integrantes 1
	   	oBtn2:Disable()					 //botão integrantes 2
	   	oQuemCod:lReadOnly   := .T.     //código de quem enviou a foto
	   	
	   	oSolant:lReadOnly   := .T.		 //solicitação anterior
	   	
	   	oPrevisao:lReadOnly := .T.       //data prevista solução
	   	oOrcam:lReadOnly    := .T.		 //orçamento previsto
	   	oJustif:lReadOnly   := .T.		 //justificativa do responsável
	   	
	   	oResposta:lReadOnly := .T.      //descrição da resposta
	   	odatasoL:lReadOnly  := .T.      //data solução
	   	
	   	
	   	//oBtnFA:Disable()                //botão da foto antes
	   	oBtnFD:Disable()                //botão da foto depois
	   	
	   	cFotoD   := Alltrim(Z80->Z80_FOTOD)       //foto depois
	    cImagemD  += Alltrim(Z80->Z80_PATHD) + Alltrim(Z80->Z80_FOTOD)    //ajusta caminho foto depois
	    oFotoD:cBMPFile:=@cImagemD                //objeto que mostra foto depois
	 	oFotoD:Load(cImagemD)                     
	   	oFotoD:Refresh()
	   	oFotoD:lReadOnly    := .T.      //foto depois
	       	
	   Endif
	   
	   If nOpc = 4    //responder
	   		//na resposta, o usuário só poderá interagir nos campos:
	   			//data solução
	   			//resposta
	   			//foto depois
	   			
	   		oProblema:lReadOnly := .T.       //DESCRIÇÃO DO PROBLEMA 
	   	
		//   	oCBoxG:lReadOnly    := .T.       //Combo box do Gut = G
		//   	oCBoxU:lReadOnly    := .T.       //Combo box do Gut = U
		//   	oCBoxT:lReadOnly    := .T.       //Combo box do Gut = T
		//   	oGutot:lReadOnly    := .T.		 //Gut Total
		   	//oCBoxArea:lReadOnly := .T.       //Areas
		   	oBtn1:Disable()					 //botão integrantes 1
		   	oBtn2:Disable()					 //botão integrantes 2
		   	oQuemCod:lReadOnly  := .T.     //código de quem enviou a foto
		   	oQuem:lReadOnly     := .T.
		   	oSolant:lReadOnly   := .T.		 //solicitação anterior
		   	//alert("responder usuario: " + Alltrim(UPPER(Substr(cUSUARIO,7,6))) )
		   	oPrevisao:lReadOnly := !Alltrim(UPPER(Substr(cUSUARIO,7,6))) $ "ALINE.FARIAS/REGINEIDE/MANOEL.NETO/ADMINI"  // .T.       //data prevista solução
		   	oOrcam:lReadOnly    := .T.		 //orçamento previsto
		   	oJustif:lReadOnly   := .T.       //justificativa do responsável
		   	
	   		//oBtnFA:Disable()                //botão da foto antes
		   	
		    //msgbox("integrantes : " + cIntegr)
			aUsuarios := fGUsers()
			for nI := 1 To Len(aUsuarios)
			   if ( Alltrim(aUsuarios[nI]) $ Alltrim(cIntegr) )
				 Aadd(aSUser,aUsuarios[nI])
			   endIf
			   
			   if ( Alltrim(aUsuarios[nI]) $ Alltrim(cIntegr2) )
				 Aadd(aSUser,aUsuarios[nI])
			   endIf
			next
		
			for nX := 1 to Len(aSUser)
				Aadd(aRespons, Substr(aSUser[nX],1,6) )	
			next nX
		
	   Endif  
	   
	   If nOpc = 6      //alteração
	   		//não é possível :
			   	//alterar a foto. para isto, é recomendável excluir a solicitação e criar outra.
			   	//quem enviou a foto, idem acima
			   	//orçamento colocado pelo responsável
				//data prevista colocada pelo responsável    
		   //oBtnFA:Disable()                //botão da foto antes
		   oQuemCod:lReadOnly   := .T.     //código de quem enviou a foto
		   oOrcam:lReadOnly    := .T.		 //orçamento previsto
		   //o campo "Data prevista" somente fica aberto pra edição caso sejam os usuários abaixo logados:
		   //alert("usuario alterar: " + Alltrim(UPPER(Substr(cUSUARIO,7,6))) )
		   oPrevisao:lReadOnly := !Alltrim(UPPER(Substr(cUSUARIO,7,6))) $ "ALINE.FARIAS/REGINEIDE/MANOEL.NETO/ADMINI" //.T.       //data prevista solução
		   oJustif:lReadOnly   := .T.		 //justificativa do responsável
		   
		   //na alteração (6) é possível alterar:
			//GUT
			//DESCRIÇÃO DO PROBLEMA
			//INTEGRANTES
			//SOLICITAÇÃO ANTERIOR
			//AREA PERTINENTE a SOLICITAÇÃO 
		  //somente se a data solução ainda não estiver preenchida
		  If !Empty(Z80->Z80_DTSOL)         
		  //caso já tenha data solução, os únicos itens que poderão ser alterados são: 
		  		//data solução,a descrição da resposta e foto depois.
		  		
		  	oProblema:lReadOnly := .T.       //DESCRIÇÃO DO PROBLEMA   	
		   	//oCBoxG:lReadOnly    := .T.       //Combo box do Gut = G
		   	//oCBoxU:lReadOnly    := .T.       //Combo box do Gut = U
		   	//oCBoxT:lReadOnly    := .T.       //Combo box do Gut = T
		   	//oGutot:lReadOnly    := .T.		 //Gut Total 
		   	oCBoxArea:lReadOnly := .T.       //Areas	   	
		   	oBtn1:Disable()					 //botão integrantes 1	   		   	
		   	oBtn2:Disable()					 //botão integrantes 2
		   	oSolant:lReadOnly   := .T.		 //solicitação anterior   		   	
		   	
		   	//oResposta:lReadOnly := .T.      //descrição da resposta
		   	//odatasoL:lReadOnly  := .T.      //data solução	   	
		   	//oBtnFA:Disable()                //botão da foto antes	  
		  Endif
			
	   Endif
	   
	   If nOpc = 7 
	   		//no feedback, o usuário só poderá interagir nos campos:
		   		//Dta prevista solução
		   		//Justificativa 
		   		//Orçamento previsto
	   		//o restante é desabilitado
	   		
		   	oProblema:lReadOnly := .T.       //DESCRIÇÃO DO PROBLEMA   
		   	//oCBoxG:Disable()					//Combo box do Gut = G
			//oCBoxU:Disable()					//Combo box do Gut = U
			//oCBoxT:Disable()					//Combo box do Gut = T
			//oGutot:Disable()					//GUT total
			oCBoxArea:Disable()			       //Areas	   	
			oBtnFA:Disable()					//botão carrega foto Antes
			
		   	//oBtn1:lReadOnly     := .T.		 //botão integrantes 1
		   	//oBtn2:lReadOnly     := .T.		 //botão integrantes 2
		   	oBtn1:Disable()					 //botão integrantes 1	   		   	
		   	oBtn2:Disable()					 //botão integrantes 2
		   	oSolant:lReadOnly   := .T.		 //solicitação anterior
		   	oQuemCod:lReadOnly  := .T.     //código de quem enviou a foto
		   	oQuem:lReadOnly     := .T. 
		   	
		   	aUsuarios := fGUsers()
			for nI := 1 To Len(aUsuarios)
			   if ( Alltrim(aUsuarios[nI]) $ Alltrim(cIntegr) )
				  Aadd(aSUser,aUsuarios[nI])
			   endIf
			   if ( Alltrim(aUsuarios[nI]) $ Alltrim(cIntegr2) )
				  Aadd(aSUser,aUsuarios[nI])
			   endIf
			next
		
			for nX := 1 to Len(aSUser)
			   Aadd(aRespons, Substr(aSUser[nX],1,6) )		   
			next nX
			  
	   Endif
	   oDlg1:Refresh()
    
    ELSE  //FAZ A COLETA DOS DADOS PARA TELA DE ATOS INSEGUROS
    
    	//ALERT('2a. chamada - faz prepcampos - TELA ATO INSEGURO')
    	//FR - prepara campos da tela Ato Inseguro para Visualização
    	
    	xNumSol   := Z80->Z80_NUMSOL
		dDtSoli   := Z80->Z80_EMISSA
		cMatF      := Z80->Z80_MATF   //MATRÍCULA DO FUNCIONÁRIO INFRATOR
		cMatG      := Z80->Z80_MATG   //MATRÍCULA DO GESTOR DO INFRATOR
		cMatQ      := Z80->Z80_MATQ   //MATRÍCULA DO FUNCIONÁRIO QUE APLICOU A INFRAÇÃO
		cAInome   := Z80->Z80_NOME1    //RESPONSÁVEL
		cMatG     := Z80->Z80_MATG //MATRÍCULA DO GESTOR
		cAIgestor := Z80->Z80_NOME2    //GESTOR
		lBoxSim   := !Empty(Z80->Z80_REINCD)
		lBoxNao   := Empty(Z80->Z80_REINCD) 
		cTurno    := Iif(Alltrim(Z80->Z80_TURNO) = '3', "3º Turno", IIF(Alltrim(Z80->Z80_TURNO) = '1', "1º Turno", "2º Turno"))

		/*
		Z80->Z80_NUMSOL := xNumSol
		Z80->Z80_EMISSA := dDtSoli
		Z80->Z80_TIPO   := 'AI'
		Z80->Z80_NOME1  := cAInome
		Z80->Z80_NOME2  := cAIgestor
		*/
		       
  		If !Empty(Alltrim(Z80->Z80_DESC1))
			lBox4 := .T.
  		Endif
  		
  		If !Empty(Alltrim(Z80->Z80_DESC2))
  			lBox5 := .T.                  
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC3))
  			lBox6 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC4))
  			lBox7 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC5))
  			lBox8 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC6))
  			lBox9 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC7))
  			lBox10 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC8))
  			lBox11 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC9))
  			lBox12 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC10))
  			lBox13 := .T.
  		EndIf
  		If !Empty(Alltrim(Z80->Z80_DESC11))
  			lBox14 := .T.
  		EndIf
  		
       	U_AtoInse(nOpc)
    	
    ENDIF
endif // FR do nOpc <> 3

//if nOpc = 4 
//   oCodGrp:Disable()
//elseif nOpc = 2 .OR. nOpc = 5
//   oCodGrp:lReadOnly  := .T.
//   oNomGrp:lReadOnly  := .T.
//   oCBLider:lReadOnly := .T.      
//   oCodPrj:lReadOnly  := .T.      
//   oCBox1:Disable()
//endif 



Return

	

*******************************
Static Function Grava(nOpc , lFora )    
*******************************

Local x 		:= 0
Local nIndice	:= 0
Local nPos		:= 0
Local cpath  	:= "" 
Local nIndZ81	:= 0
Local dAux  	:= Ctod("  /  /    ")
Local nDUtil	:= 0
Local aUsu      := {}
Local cNome     := ""
Local nIndiv    := 0
Local cTipoZ    := ""

If nOpc = 5         //excluir  
	cNumsol	:= Z80->Z80_NUMSOL
	cTipoZ:= iif(ALLTRIM(Z80->Z80_TIPO)= 'AI' , "Ato Inseguro" , "Condição Insegura" )
	If MsgyesNo("Deseja Excluir Definitivamente o(a) " + cTipoZ + " Selecionado(a) ??")
		Reclock("Z80",.F.)
		dbDelete()
		MsUnlock()		
	
		If Alltrim(Z80->Z80_TIPO) != "AI"
			DbselectArea("Z81")
			Dbsetorder(4)
			If Z81->( DbSeek( xFilial( "Z81" ) + cNumsol ) ) 
				While !Z81->(EOF()) .AND. Z81->Z81_FILIAL == xFilial("Z81") .And. Alltrim(Z81->Z81_NUMSOL) == Alltrim(cNumSoL)
					Reclock("Z81",.F.)
					dbDelete()
					Z81->(MsUnlock())
					Z81->(Dbskip())
				Enddo
			Endif
		
			If !Empty(cQuemCod)    //caso tenha alguém que enviou foto , exclui tb
				DbselectArea("Z81")
				Dbsetorder(1)
				If Z81->( DbSeek( xFilial( "Z81" ) + cQuemCod + "CRED" ) ) 
					//While !Z81->(EOF()) .AND. Z81->Z81_FILIAL == xFilial("Z81") .And. Alltrim(Z81->Z81_USER) == Alltrim(cQuemCod)
						Reclock("Z81",.F.)
						dbDelete()
						Z81->(MsUnlock())
						Z81->(Dbskip())
					//Enddo
				Endif	
			Endif	
		ENDIF
		MsgInfo("Exclusão Efetuada com Sucesso!")
	Endif //msgyesno
		
Elseif nOpc = 3    //incluir
	DbselectArea("Z80")
	Dbsetorder(1)
	If Z80->( DbSeek( xFilial( "Z80" ) + cNumsol ) )	
		while Z80->( DbSeek( xFilial( "Z80" ) + cNumsol ) )
		   ConfirmSX8()
		   cNumsol := GetSxeNum("Z80","Z80_NUMSOL")
		enddo
	Endif
	
	////////////////////////////////////////////////////////////////////////////		
	///VERIFICA SE É UMA REINCIDÊNCIA, POIS IRÁ AFETAR NO CÁLCULO DO ÍNDICE
	////////////////////////////////////////////////////////////////////////////
    //nIndice := ( Val(nG) + Val(nU) + Val(nT) ) * (-1)
    //nIndiv  := nIndice
   	
	DbselectArea("Z80")
	RecLock("Z80",.T.)
	Z80->Z80_FILIAL := xFilial()
	Z80->Z80_NUMSOL := cNumsol
	Z80->Z80_EMISSA := cEmissao 
	//Z80->Z80_DTPREV := cPrevisao  //SOMENTE O RESPONSÁVEL PODE INSERIR
	//Z80->Z80_DESCRI //MEMO DESCRIÇÃO DO PROBLEMA
	Z80->Z80_DTFOTO	:= cEmissao			
	Z80->Z80_TIPO   := 'CI'		
	Z80->Z80_GUT_G  := nG //Val(nG)
    Z80->Z80_GUT_U  := nU //Val(nU)
    Z80->Z80_GUT_T  := nT //Val(nT)
    Z80->Z80_AREA   := Substr(nArea,1,6)
    Z80->Z80_SETOR  := Substr(nSetor,1,6)
    
    If Alltrim(cSolant) != ''      //reincidência	
    	Z80->Z80_REINCD := 'S' //iif(lMarkR = .T. , 'S' , 'N' )
   		Z80->Z80_SOLANT := cSolant
    Endif
   
    Z80->Z80_INTEGR := cIntegr //responsável
    Z80->Z80_INTEG2 := cIntegr2  //gestor
    If lFora
    	Z80->Z80_CODAUD := cCODAUD   //grava o código da auditoria realizada que gerou esta CI.
    endif
	//Z80->Z80_INDICE := nIndiv       //GRAVA O Índice GUT TOTAL na SOLICITAÇÃO
    
    cpath := cFotoA		//caminho junto com o nome do arquivo
    nPos := RAT( '\', cpath ) 
	cFotoA := Substr( cpath, nPos + 1 , (Len(cpath) - 1) )
    Z80->Z80_PATHA  := Substr(cpath,1,nPos)  //grava o caminho do arquivo (sem o nome do arquivo)
    Z80->Z80_FOTOA  := cFotoA
    Z80->Z80_DESC_S := cproblema
    Z80->Z80_QUENV  := cQuemCod
	Z80->(MsUnlock())
	MSMM(,,,cproblema,1,,,'Z80','Z80_CODMP')   //para gravar
	
	//INTEGRANTES 1
	////grava na tabela equipe 5S
	For x := 1 to Len(aRespons)
	
		///CAPTURA O NOME DO RESPONSÁVEL
		PswOrder(1)
		If PswSeek( aRespons[x] , .T. )  
		   aUsu   := PSWRET() 				
		   //cUsu   := Alltrim( aUsu[1][2] )  
		   cNome:= Alltrim( aUsu[1][4] )  
		   //cEmailUsr:= Alltrim( aUsu[1][14] )
		   //cDepto:= Alltrim( aUsu[1][12] )
		Endif
		
		DbSelectArea("Z81")	
		RecLock("Z81",.T.)
	
		Z81->Z81_FILIAL := xFilial()
		Z81->Z81_USER   := aRespons[x]
		Z81->Z81_NOME   := cNome
		Z81->Z81_NUMSOL := cNumSoL		//GRAVA O NÚMERO DA SOLICITAÇÃO
		//If Alltrim(aRespons[x]) = Alltrim(cQuemCod)
		//	Z81->Z81_INDICE := (nIndiv + 0.5)    //GRAVA O GUT TOTAL NA TABELA DE INDICES X COLABORADOR
		//Else
		//	Z81->Z81_INDICE := nIndiv     //GRAVA O GUT TOTAL NA TABELA DE INDICES X COLABORADOR
		//Endif
		Z81->(MsUnlock())
	Next
	
	//INTEGRANTES 2 - GUT 50%
	////grava na tabela equipe 5S
	xx := 0
	For xx := 1 to Len(aRespons2)
	
		///CAPTURA O NOME DO RESPONSÁVEL
		PswOrder(1)
		If PswSeek( aRespons2[xx] , .T. )  
		   aUsu2   := PSWRET() 				
		   //cUsu   := Alltrim( aUsu[1][2] )  
		   cNome:= Alltrim( aUsu2[1][4] )  
		   //cEmailUsr:= Alltrim( aUsu[1][14] )
		   //cDepto:= Alltrim( aUsu[1][12] )
		Endif
		
		DbSelectArea("Z81")	
		RecLock("Z81",.T.)
	
		Z81->Z81_FILIAL := xFilial()
		Z81->Z81_USER   := aRespons2[xx]
		Z81->Z81_NOME   := cNome
		Z81->Z81_NUMSOL := cNumSoL		//GRAVA O NÚMERO DA SOLICITAÇÃO
		//Z81->Z81_INDICE := (nIndiv / 2 )     //GRAVA O GUT TOTAL NA TABELA DE INDICES X COLABORADOR	
		Z81->Z81_50PORC := "*"
		Z81->(MsUnlock())
	Next
	
	nIndFoto := 0
	If !Empty(cQuemCod)
		DbSelectArea("Z81")
		Z81->(DbsetOrder(1))
		If !Z81->(Dbseek( xFilial("Z81") + cQuemCod + cNumSoL ))  //código de usuário de quem enviou a foto, para adicionar créditos
			RecLock("Z81",.T.)
			//msgbox("novo - não encontrou")
		Else
			//nIndFoto := Z81->Z81_INDICE
			RecLock("Z81",.F.)
			//msgbox("já existe - altera")
		Endif	
		Z81->Z81_FILIAL := xFilial()
		Z81->Z81_USER   := cQuemCod 
		///CAPTURA O NOME DO RESPONSÁVEL
		PswOrder(1)
		If PswSeek( cQuemCod , .T. )  
		   aUsu   := PSWRET() 				
		   cNome:= Alltrim( aUsu[1][4] ) 	  
		Endif
		Z81->Z81_NOME   := cNome
		Z81->Z81_NUMSOL := "CRED"  //cNumSoL se deixar cNumSol, vai computar indevidamente créditos em outro usuário.	
		//Z81->Z81_INDICE := (nIndFoto + 0.5)
	Endif
	//oDlg1:End()	
	
	U_5SEnvio( aRespons, cpath, cFotoA, nOpc, 'CI' )
	msginfo("Dados gravados com Sucesso !!")
	
Elseif nOpc = 4 //responder
	//APURA O ÍNDICE
	
	If cDataSoL >= cEmissao
		nDUtil := 0
		dDtIni := cEmissao //CTOD("01/"+StrZero(nMes,2)+"/"+StrZero(nAno,2)
		dDtMov := dDtIni
		While dDtMov <= cDataSoL 	
			dDtMov := dDtMov + 1	
			//If Dow(dDtMov) > 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= cDataSoL
			If Dow(dDtMov) > 1 .and. dDtMov <= cDataSoL       //a contagem exclui apenas o Domingo
					nDUtil := nDUtil + 1	
			Endif	
		EndDo
	    nDias := nDUtil
	Else
		nDias := 0
	Endif
    
	//nIndice := CalcGUT( cTot, nDias, cSolant)

	///reclock do memo
	MSMM(,,,cResposta,1,,,'Z80','Z80_CODMR')   //para gravar
				
	RecLock("Z80",.F.)
	Z80->Z80_DTSOL  := cDataSoL	//data da solução
	Z80->Z80_DTRESP := Date()  //data que o responsável respondeu
	//Z80->Z80_INDICE := nIndice	    
	Z80->Z80_INTEGR := cIntegr  //responsável
	Z80->Z80_INTEG2 := cIntegr2  //gestor
	Z80->Z80_DTPREV := cPrevisao   //SOMENTE O RESPONSÁVEL PODE INSERIR
	cpath := cFotoD		//caminho junto com o nome do arquivo
    nPos := RAT( '\', cpath ) 
	cFotoD := Substr( cpath, nPos + 1 , (Len(cpath) - 1) )
    Z80->Z80_PATHD  := Substr(cpath,1,nPos)  //grava o caminho do arquivo (sem o nome do arquivo)
    Z80->Z80_FOTOD  := cFotoD
		
	Z80->(MsUnlock())
	
	nIndiv := 0

	If Alltrim(UPPER(Substr(cUSUARIO,7,6))) $ "ALINE.FARIAS/REGINEIDE/MANOEL.NETO/ADMINI" //se for Aline, Regineide ou Manoel, pergunta se quer enviar e-mail
		If MsgYesNo("Deseja Enviar o E-mail ?")
			U_5SEnvio( aRespons, cpath, cFotoD, nOpc, 'CI' )
		Endif
	Else     //se for qq outra pessoa a responder, envia o email direto
		U_5SEnvio( aRespons, cpath, cFotoD, nOpc, 'CI' )
	Endif	
	msginfo("Resposta efetuada com Sucesso !!")		
		
	//MSMM(,,,cObs,1,,,'Z56','Z56_CODOBS')   //para gravar

Elseif nOpc = 6       //ALTERAÇÃO

	//na alteração é possível alterar:
	//GUT
	//DESCRIÇÃO DO PROBLEMA
	//INTEGRANTES
	//SOLICITAÇÃO ANTERIOR
	//AREA
	//não é possível alterar a foto. para isto, é recomendável excluir a solicitação e criar outra.
	
	////////////////////////////////////////////////////////////////////////////		
	///VERIFICA SE É UMA REINCIDÊNCIA, POIS IRÁ AFETAR NO CÁLCULO DO ÍNDICE
	////////////////////////////////////////////////////////////////////////////
    //nIndice := ( Val(nG) + Val(nU) + Val(nT) ) * (-1)
    //nIndiv  := nIndice
    If Alltrim(cSolant) != ''      //reincidência	
        //FR - 30/04/13 - NO NOVO FORMATO, O GUT DEIXARÁ DE SER USADO
        /*
		For x := 1 to Len(aRespons)
			DbSelectArea("Z81")
			Z81->(DbsetOrder(4))
			If Z81->(Dbseek( xFilial("Z81") + cSolant ))  //aRespons[x] ))		
				While !Z81->(EOF()) .AND. Z81->Z81_FILIAL == xFilial("Z81") .And. Alltrim(Z81->Z81_NUMSOL) == Alltrim(cSolant)
					nIndZ81 += Z81->Z81_INDICE
					Z81->(Dbskip())
				Enddo	    	
	    		nIndice := nIndice + nIndZ81     //não será utilizado desta maneira
	    		
	   		Endif
	  	Next
	  	*/
	//Else
		//msgbox("NÃO é reincidência")
	Endif
	
	DbselectArea("Z80")
	Z80->(Dbsetorder(1))
	If Z80->(Dbseek(xFilial("Z80") + cNumSoL ))
		RecLock("Z80",.F.)
		//FR - 19/11/13 - NÃO TEM MAIS GUT		
		//Z80->Z80_GUT_G  := nG //Val(nG)
	    //Z80->Z80_GUT_U  := nU //Val(nU)
	    //Z80->Z80_GUT_T  := nT //Val(nT)
	    //Z80->Z80_AREA   := nArea  //AREA
	    If Alltrim(cSolant) != ''      //reincidência	
	    	Z80->Z80_REINCD := 'S' //iif(lMarkR = .T. , 'S' , 'N' )
	   		Z80->Z80_SOLANT := cSolant
	    Endif
		Z80->Z80_AREA   := Substr(nArea,1,6)
	    Z80->Z80_SETOR  := Substr(nSetor,1,6)
	    Z80->Z80_INTEGR := cIntegr //responsável
	    Z80->Z80_INTEG2 := cIntegr2 //gestor
		//msgbox("indice z80: " + str(nIndice)) 
		//Z80->Z80_INDICE := nIndiv       //GRAVA O Índice GUT TOTAL na SOLICITAÇÃO
       	Z80->Z80_DESC_S := cproblema
       	Z80->Z80_QUENV  := cQuemCod
       	Z80->Z80_DTPREV := cPrevisao   
		Z80->(MsUnlock())
		MSMM(,,,cproblema,1,,,'Z80','Z80_CODMP')   //para gravar
	Endif
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///ANTES DE GRAVAR OS RESPONSÁVEIS NA TABELA Z81, EU DELETO TUDO, PARA EVITAR QUE NESTA ALTERAÇÃO
	///TENHAM SIDO RETIRADOS UM OU OUTRO RESPONSÁVEL E INCLUÍDOS OUTROS, GERANDO DIVERGÊNCIA ENTRE SOLICITAÇÃO
	///E TABELA DE RESPONSÁVEIS x SOLICITAÇÃO (Z81)
	///DELETANDO TUDO E INCLUINDO DE NOVO, GARANTE QUE SEMPRE ESTARÁ ATUALIZADO
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DbselectArea("Z81")
	Dbsetorder(4)
	If Z81->( DbSeek( xFilial( "Z81" ) + cNumsol ) ) 
		While !Z81->(EOF()) .AND. Z81->Z81_FILIAL == xFilial("Z81") .And. Alltrim(Z81->Z81_NUMSOL) == Alltrim(cNumSoL)
			Reclock("Z81",.F.)
			dbDelete()
			Z81->(MsUnlock())
			Z81->(Dbskip())
		Enddo
	Endif
	
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    ///AGORA INCLUI NORMALMENTE NA TABELA Z81, ATRAVÉS DOS INTEGRANTES QUE CONSTAM NO ARRAY [aRespons]
    ///INTEGRANTES 1  //responsável                                                                    
    ///////////////////////////////////////////////////////////////////////////////////////////////////

		For x := 1 to Len(aRespons)
		
			///CAPTURA O NOME DO RESPONSÁVEL
			PswOrder(1)
			If PswSeek( aRespons[x] , .T. )  
			   aUsu   := PSWRET() 				
			   //cUsu   := Alltrim( aUsu[1][2] )  
			   cNome:= Alltrim( aUsu[1][4] )  
			   //cEmailUsr:= Alltrim( aUsu[1][14] )
			   //cDepto:= Alltrim( aUsu[1][12] )
			Endif
			
			nIndFoto := 0
			DbSelectArea("Z81")	
			Z81->(Dbsetorder(4))
			If Z81->(Dbseek(xFilial("Z81") +  cNumSoL + aRespons[x] ))
				RecLock("Z81",.F.)              //SE JÁ EXISTIR REGISTRO PARA ESTA PESSOA, APENAS ALTERA
				//nIndFoto := Z81->Z81_INDICE	
				//If Alltrim(cQuemCod) = Alltrim(aRespons[x]) 
				//	Z81->Z81_INDICE := nIndFoto      //GRAVA O GUT TOTAL NA TABELA DE INDICES X COLABORADOR
				//Endif			
			Else
				RecLock("Z81",.T.)    //SE NÃO EXISTIR, CRIA UM NOVO
				//Z81->Z81_INDICE := nIndiv     //GRAVA O GUT TOTAL NA TABELA DE INDICES X COLABORADOR
			Endif
				Z81->Z81_FILIAL := xFilial()
				Z81->Z81_USER   := aRespons[x]
				Z81->Z81_NOME   := cNome
				Z81->Z81_NUMSOL := cNumSoL		//GRAVA O NÚMERO DA SOLICITAÇÃO			
				Z81->(MsUnlock())
		Next
		
		///INTEGRANTES 2
		////grava na tabela equipe 5S
		xx := 0
		For xx := 1 to Len(aRespons2)
		
			///CAPTURA O NOME DO RESPONSÁVEL
			PswOrder(1)
			If PswSeek( aRespons[xx] , .T. )  
			   aUsu   := PSWRET() 				
			   //cUsu   := Alltrim( aUsu[1][2] )  
			   cNome:= Alltrim( aUsu[1][4] )  
			   //cEmailUsr:= Alltrim( aUsu[1][14] )
			   //cDepto:= Alltrim( aUsu[1][12] )
			Endif
			
			nIndFoto := 0
			DbSelectArea("Z81")	
			Z81->(Dbsetorder(4))
			If Z81->(Dbseek(xFilial("Z81") +  cNumSoL + aRespons[xx] ))
				RecLock("Z81",.F.)
				//nIndFoto := Z81->Z81_INDICE	
				//If Alltrim(cQuemCod) = Alltrim(aRespons[xx]) 
				//	Z81->Z81_INDICE := nIndFoto      //GRAVA O GUT TOTAL NA TABELA DE INDICES X COLABORADOR
				//Endif			
			Else
				RecLock("Z81",.T.) 
				//Z81->Z81_INDICE := (nIndiv / 2 )     //GRAVA O GUT TOTAL NA TABELA DE INDICES X COLABORADOR
			Endif
				Z81->Z81_FILIAL := xFilial()
				Z81->Z81_USER   := aRespons[xx]
				Z81->Z81_NOME   := cNome
				Z81->Z81_NUMSOL := cNumSoL		//GRAVA O NÚMERO DA SOLICITAÇÃO			
				Z81->(MsUnlock())
		Next 
		 
	//oDlg1:End()
	If Alltrim(UPPER(Substr(cUSUARIO,7,6))) $ "ALINE.FARIAS/REGINEIDE/MANOEL.NETO/ADMINI" //se for Aline, Regineide ou Manoel, pergunta se quer enviar e-mail
		If MsgYesNo("Deseja Enviar o E-mail ?")
			U_5SEnvio( aRespons, cCaminho, cFotoA, nOpc, 'CI' )
		Endif
	Else //qq outra pessoa, não irá perguntar
		U_5SEnvio( aRespons, cCaminho, cFotoA, nOpc, 'CI' )
	Endif
	msginfo("Alteração Efetuada com Sucesso !!")

Elseif nOpc = 7       //ALtera PARA INSERIR FEEDBACK
  //msgbox("grava nopc = 8")
  DbselectArea("Z80")
  Z80->(Dbsetorder(1))
  If Z80->(Dbseek(xFilial("Z80") + cNumSoL ))
  	//MSMM(,,,cJustif,1,,,'Z80','Z80_CODMJ')   //para gravar
	RecLock("Z80",.F.)
	Z80->Z80_PRVORC := nOrcam  //Val(nOrcam) 
	Z80->Z80_JUSTIF := cJustif	
	Z80->Z80_DTPREV := cPrevisao
	Z80->(MsUnlock())
  Endif
  
  If Alltrim(UPPER(Substr(cUSUARIO,7,6))) $ "ALINE.FARIAS/REGINEIDE/MANOEL.NETO/ADMINI" //se for Aline, Regineide ou Manoel, pergunta se quer enviar e-mail
		If MsgYesNo("Deseja Enviar o E-mail ?")
  			U_5SEnvio( aRespons, cCaminho, cFotoA, nOpc, 'CI' )
  		Endif
  Else
  	U_5SEnvio( aRespons, cCaminho, cFotoA, nOpc, 'CI' )
  Endif
  msginfo("Feedback Registrado com Sucesso !!")		
	
Endif

Return
		
		
******************************************************************************************************
User Function 5SLeg()
******************************************************************************************************
/*
BrwLegenda(cCadastro,"Legenda",{	{"BR_LARANJA",	"Ato Inseguro"} ,;
									{"BR_VERDE" ,	"Condição Insegura Respondida"},;
									{"BR_VERMELHO", "Condição Insegura Não Respondida"}	 } )

Local aCores := {{ "Z80->Z80_TIPO == 'AI'"  , 'BR_LARANJA'    },;  // Ato Inseguro
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTRESP) "  , 'BR_CINZA'  },; //Nova Condição Insegura
				 { "Z80->Z80_TIPO == 'CI' .AND. Empty(Z80_DTSOL) .and. !Empty(Z80_DTRESP) "  , 'BR_AZUL'  },; //Condição insegura respondida
				 { "Z80->Z80_TIPO == 'CI' .AND. (!Empty(Z80_DTSOL) .and. !Empty(Z80_DTPREV) .and. Z80_DTSOL > Z80_DTPREV) "  , 'BR_VERMELHO'  },; //Condição insegura não corrigida no prazo				 
				 { "Z80->Z80_TIPO == 'CI' .AND. (!Empty(Z80_DTSOL) .and. !Empty(Z80_DTPREV) .and. Z80_DTSOL <= Z80_DTPREV) "  , 'BR_VERDE'  } } //Condição insegura corrigida

*/
BrwLegenda(cCadastro,"Legenda",{	{"BR_LARANJA",	"Ato Inseguro"} ,;
									{"BR_CINZA" ,	"Nova Condição Insegura"},;
									{"BR_AZUL" ,	"Condição Insegura Respondida"},;
									{"BR_VERMELHO", "Condição Insegura Não Corrigida no Prazo"},;
									{"BR_VERDE", "Condição Insegura Corrigida"} } )


Return .T.		

******************************
Static Function FValUSR(cUser)
******************************

Local lTemUsr := .T.

PswOrder(1)
If PswSeek( cUser , .T. )  
   aUsu   := PSWRET() 				
   //cUsu   := Alltrim( aUsu[1][2] )  
   cNomeUsr:= Alltrim( aUsu[1][4] )  
   //cEmailUsr:= Alltrim( aUsu[1][14] )
   //cDeptoUsr:= Alltrim( aUsu[1][12] )
Else
	MsgAlert("Código Digitado não Existe !!")
	lTemUsr := .F.
Endif    




Return(lTemUsr)

*************************************************************************
Static function FdtValida( dData )   
*************************************************************************


Local lValeDT 		:= .T.
Local nDiaSemana 	:= 0
Local dPrazo	   	:= Ctod("  /  /    ") 
Local nX 
//Set Date Brit


nDiaSemana := DOW( dData )
//If dData < dDatabase
//	MsgBox("A data para Solução não pode ser menor que HOJE ! Por Favor, informe outra data!","Alerta")
//	lValeDT := .F.

//Elseif dData >= dDatabase	
	If nDiaSemana = 1
		MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
		lValeDT := .F.
	//Elseif nDiaSemana = 7
	//	MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")  //Permitir digitação de solução para Sábado
	//	lValeDT := .F.
	//Else
	//	lValeDT := .T.
	Endif 
//Endif
		
return(lValeDT)      
                     
******************************************************************
Static Function SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= cAnexo
Local cFrom		:= "" //GetMV( "MV_RELACNT" )
cFrom  := "rava@siga.ravaembalagens.com.br"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")
		//conout(Replicate("*",60))
		//conout("FATR011")
	   //	conout("Relatorio Acomp. Cliente " + Dtoc( Date() ) + ' - ' + Time() )
		conout("E-mail nao enviado")
		conout(Replicate("*",60))
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )

///usar em caso do workflow padrão não funcionar
*********************************************************************************
Static Function GeraHTM( cNumSoL, cProblema, cEmissao, cNomeUsr, cRespon , cDeptoUsr, cCaminho, cFoto )
*********************************************************************************

Local cBody   := ""
Local LF      := CHR(13)+CHR(10) 
Local nPos1    := 0
Local nPos2    := 0
Local cPatharq:= ""

cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + LF
cBody += '<html xmlns="http://www.w3.org/1999/xhtml">' + LF
cBody += '<head>' + LF
cBody += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />' + LF
cBody += '<title>Call Center</title>' + LF
cBody += '</head>'+ LF
cBody += '	<title>Call Center</title>'+ LF
cBody += '	<style type="text/css">'+ LF
cBody += '	body{'+ LF
cBody += '		/*'+ LF
cBody += '		You can remove these four options '+ LF
cBody += '		*/'+ LF
cBody += '		background-repeat:no-repeat;'+ LF
cBody += '		font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;'+ LF
cBody += '		margin:0px;'+ LF
cBody += '	}'+ LF
cBody += '	#ad{'+ LF
cBody += '		padding-top:220px;'+ LF
cBody += '		padding-left:10px;'+ LF
cBody += '	}'+ LF
cBody += '    </style>'+ LF
cBody += '<style type="text/css">'+ LF
cBody += '#calendarDiv{'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	width:205px;'+ LF
cBody += '	border:1px solid #317082;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	background-color: #FFF;'+ LF
cBody += '	font-family:arial;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '	padding-bottom:20px;'+ LF
cBody += '	visibility:hidden;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv span,#calendarDiv img{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox,#calendarDiv .selectBoxOver{'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime,#calendarDiv .selectBoxTimeOver{	'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	padding:3px;'+ LF
cBody += '	margin:0px;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox{'+ LF
cBody += '	border:1px solid #E2EBED;		'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxOver{'+ LF
cBody += '	border:1px solid #FFF;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '	color: #FFF;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime{'+ LF
cBody += '	border:1px solid #317082;		'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTimeOver{'+ LF
cBody += '	border:1px solid #216072;	'+ LF
cBody += '	color: #216072;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar{'+ LF
cBody += '	height:16px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .activeDay{	/* Active day in the calendar */'+ LF
cBody += '	color:#FF0000;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	text-align:center;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	bottom:0px;'+ LF
cBody += '	width:201px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate div{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	width:72px;'+ LF
cBody += '	color:#FFF;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	right:0px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker{'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	border:1px solid #AAAAAA;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	left:0px;'+ LF
cBody += '	top:15px;'+ LF
cBody += '	z-index:1000;'+ LF
cBody += '	display:none;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv #monthSelect{'+ LF
cBody += '	width:70px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker div{'+ LF
cBody += '	float:none;'+ LF
cBody += '	clear:both;	'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	margin:1px;	'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearActive{'+ LF
cBody += '	background-color:#317082;'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	text-align:right;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar img{'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '/style>'+ LF

	
cBody += '<style type="text/css">'+ LF
cBody += '<!--'+ LF
cBody += '.style20 {font-family: Arial, Helvetica, sans-serif; font-size: 13px; }'+ LF
cBody += '.style21 {font-family: Arial, Helvetica, sans-serif}'+ LF
cBody += '.style22 {color: #FFFFFF}'+ LF
cBody += '.style26 {font-size: 14px}'+ LF
cBody += '.style23 {font-family: Arial, Helvetica, sans-serif; font-size: 9px; }
cBody += '-->'+ LF
cBody += '    </style>'+ LF
cBody += '</head>'+ LF
cBody += '<script language="JavaScript">'+ LF
/*-----------------------------------------------------------------------
Máscara para o campo data dd/mm/aaaa hh:mm:ss
Exemplo: <input maxlength="16" name="datahora" onKeyPress="DataHora(event, this)">
-----------------------------------------------------------------------*/
cBody += 'function Data(evento, objeto){'+ LF
cBody += '	var keypress=(window.event)?event.keyCode:evento.which;'+ LF
cBody += '	campo = eval (objeto);'+ LF
cBody += '	if (campo.value == "00/00/00")'+ LF
cBody += '	{'+ LF
cBody += '		campo.value="" '+ LF
cBody += '	}'+ LF

cBody += '	caracteres = "0123456789";'+ LF
cBody += "	separacao1 = '/';"+ LF
cBody += '	conjunto1 = 2;'+ LF
cBody += '	conjunto2 = 5;'+ LF
cBody += '	conjunto3 = 8;'+ LF
cBody += '	if ((caracteres.search(String.fromCharCode (keypress))!=-1) && campo.value.length < (8))'+ LF
cBody += '	{'+ LF
cBody += '		if (campo.value.length == conjunto1 )'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '		else if (campo.value.length == conjunto2)'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '	}'+ LF
cBody += '	else'+ LF
cBody += '		event.returnValue = false;'+ LF
cBody += '}'+ LF
cBody += '</script>'+ LF
//AQUI COMEÇA MESMO O HTML DA RAVA
cBody += '<body>'+ LF
cBody += '<form action="mailto:%WFMailTo%" method="POST" name="Form1" onsubmit="return Form1_Validator(this)">'+ LF
cBody += '  <p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'+ LF
cBody += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="695"'+ LF
cBody += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'+ LF

cBody += '<p class="style20"><Strong>======================================</strong><BR>'+LF
cBody += 'Para: Equipe 5S <BR>'+LF
cBody += '<strong>======================================</strong></p>'+LF


cBody += '<p class="style20">Prezado(a)s: '+ cRespon +',</p>'+ LF

cBody += '<p class="style20"><strong>Segue abaixo uma nova solicitação do Programa 5S.<BR>'+LF
cBody += 'Por gentileza, pedimos que providencie a solução o mais breve possível.</p>'+LF //a efetiva para a&ccedil;&atilde;o.</p>'+LF

cBody += '<table width="1000" height="56" border="1">'+LF
cBody += '  <tr>
cBody += '<td width="90" height="20" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Solicitação</span></td>'+LF
cBody += '<td width="200" bgcolor="#00CC66" align="left"><span class="style9 style21 style22">Descrição</span></td>'+LF
cBody += '<td width="40" bgcolor="#00CC66" align="right"><span class="style9 style21 style22">Data Abertura</span></td>'+LF
cBody += '</tr>

cBody += '<tr>
cBody += '<td height="26"><span class="style7 style21 style26">'+ cNumSoL +'</span></td>'+LF   //cod.solicitação
cBody += '<td><span class="style26">'+ cProblema + '</span></td>'+LF                            //descrição
cBody += '<td><span class="style26">'+ Dtoc(cEmissao) + '</span></td>'+LF                            //dt abertura
cBody += '</tr>'+LF    
   
cBody += '</table>'+LF
//cBody += '<tr>'+LF
cBody += '<BR>'+LF
//cBody += '<img src="' + Alltrim(cCaminho) + '" width="324" height="168" border="0">'+LF

cBody += '<table width="324" height="56" border="1">'+LF  
cBody += '<tr>'+LF  
cBody += '    <td width="324" bgcolor="#00CC66"><span class="style9 style21 style22">Foto</span></td>'+LF  
cBody += '  </tr>'+LF  
cBody += '  <tr>'+LF  
//cBody += '  <td><span class="style7 style21 style26" align="center"><img src="' + Alltrim(cCaminho) + '" width="324" height="168" border="0"></span></td>'+LF  
//C:\Temp\
nPos1:= AT( '\', cCaminho )  //3
nPos2:= RAT( '\', cCaminho ) //8
cPatharq:= Substr( cCaminho, nPos1 + 1 , nPos2 - (nPos1 + 1) )
//cBody += '  <td><span class="style7 style21 style26" align="center"><img src="../../../' + Alltrim(cPatharq) + '" width="324" height="168" border="0"></span></td>'+LF  
//<img src="../../../Temp/Desert.jpg" width="324" height="168" border="0">
cBody += '  <td><span class="style7 style21 style26" align="center"><img src="' + Alltrim(cPatharq) + '" width="324" height="168" border="0"></span></td>'+LF  
cBody += '    </tr>'+LF  
cBody += ' </table>'+LF  
cBody += '<BR>'+LF

cBody += '<p>'+ LF
cBody += 'Atenciosamente,<br><br>' + LF
cBody += cNomeUsr + '<br>' + LF
cBody += cDeptoUsr + LF
cBody += '</p>' + LF 
cBody += '<p class="style23"><<"WF5S.html">></p>' + LF
cBody += '<div id="debug"></div>' + LF
cBody += '</form>
cBody += '</body>
cBody += '</html>
MemoWrite("C:\Temp\5Shtm.txt",cBody)


Return(cBody)	

***********************************
Static Function fQuemEnv(cUser)
***********************************

Local aUsu := {}
Local cNomeUsr := ""

///CAPTURA O EMAIL DO OPERADOR DO SISTEMA
PswOrder(1)
If PswSeek( cUser , .T. )  
   aUsu   := PSWRET() 				
   //cUsu   := Alltrim( aUsu[1][2] )  
   cNomeUsr:= Alltrim( aUsu[1][4] )  
   //cEmailUsr:= Alltrim( aUsu[1][14] )
   //cDeptoUsr:= Alltrim( aUsu[1][12] )
Endif    

Return(cNomeUsr) 

***********************************
Static Function fQualArea( nArea , cTipo )
***********************************


Local cNomeAre := ""

If Alltrim(cTipo) = "A" //area
	SX5->(DBSETORDER(1))
	If SX5->(Dbseek(xFilial("SX5") + "5S" + nArea))
		cNomeAre := SX5->X5_DESCRI
	Endif 
Elseif Alltrim(cTipo) = "D" //depto
	SX5->(DBSETORDER(1))
	If SX5->(Dbseek(xFilial("SX5") + "ZW" + nArea))
		cNomeAre := SX5->X5_DESCRI
	Endif 
Endif

Return(cNomeAre) 

///ENVIO DA SOLICITAÇÃO POR EMAIL
********************************
User Function 5SEnvio( aRespons, cCaminho, cFoto, nOpc, cAICI, cGestor, aBoxes, cTurno, xNumSol, lBoxSim, cMatG )
********************************                                                                          
//          U_5SEnvio( aRespons,         ,      , nOpTipo, 'AI', cAIgestor, aBoxes, cTurno, xNumSol, lBoxSim, cMatG )

Local cUsu
Local aUsu		:= {}
Local cNomeUsr	:= ""
Local cEmailUsr := ""
Local cDeptoUsr := ""
Local cEmailResp := ""  
Local cCorpo    := ""
Local cAssun    := ""
Local chtm      := "" 
Local cDirHtm   := ""
Local cArqHtm   := ""
Local cAnexo    := ""
Local nHandle   := 0
Local cMailTo   := ""
Local x			:= 0
Local cRespon   := ""
//Local cFoto     := cFotoA
Local aResps    := {}
Local cImgHTM   := "" 
Local cMsg		:= ""
Local nGutot    := 0 
Local lCopiou   := .F.
Local cDir    := GetMv("RV_5SDIR") 
Local nSaldoGut := 0 
Local aIndResp  := {} 
Local x         := 0
Local cNomeResp := ""
Local cNomeGestor:= ""
Local cMailGestor:= "" 
Local cMail5S   := ""  
Local cDescAto  := ""

SetPrvt("OHTML,OPROCESS")

///CAPTURA O EMAIL DO USUÁRIO LOGADO
PswOrder(1)
If PswSeek( __CUSERID , .T. )  
   aUsu   := PSWRET() 				
   cUsu   := Alltrim( aUsu[1][2] )  
   cNomeUsr:= Alltrim( aUsu[1][4] )  
   cEmailUsr:= Alltrim( aUsu[1][14] )
   cDeptoUsr:= Alltrim( aUsu[1][12] )
Endif

 

aUsu := {}

//CAPTURA OS EMAILS DOS RESPONSÁVEIS PELA AÇÃO
If Alltrim(cAICI) != 'AI' //se não for Ato Inseguro, pesquisa pelo código do responsável no cadastro de usuários
	For x := 1 to Len(aRespons)
		PswOrder(1)
		If PswSeek( aRespons[x] , .T. )  
		   aUsu   := PSWRET() 					   
		   cEmailResp += ';' + Alltrim( aUsu[1][14] ) //email do responsável pela ação
		   cNomeResp := aUsu[1][4] 
		   If x < Len(aRespons)
		   	cRespon += aUsu[1][4] + ', '
		   Elseif x = Len(aRespons)
		   	cRespon += aUsu[1][4] 
		   Endif
		   //apura o saldo final Gut para inserir no html
		   //msgbox("cnomeresp: " + cNomeResp )
		   
		   //nSaldoGut := fSaldoGut(aRespons[x])
		   Aadd( aIndResp,  { cNomeResp, nSaldoGut } )
		   //MSGBOX("SALDO: " + str(nSaldoGut) )
		   //msgbox("aIndResp : " + str(Len(aIndResp)) )
		   ////
		   
		Endif
	Next
Else    //É AI = ATO INSEGURO

	//pesquisa o responsável
	/*
	PswOrder(2)  //pesquisa pelo nome
	If PswSeek( aRespons[1] , .T. )  
	   aUsu   := PSWRET() 					   
	   cEmailResp := Alltrim( aUsu[1][14] ) //email do responsável pela ação
	   cNomeResp := aUsu[1][4]    //nome completo
	    
	Endif
	*/
	
	//pesquisa o responsável
	SRA->(Dbsetorder(1))
	If SRA->(Dbseek(xFilial("SRA") + aRespons[1] ))
		cEmailResp := SRA->RA_EMAIL //email do responsável pela ação
	   	cNomeResp  := SRA->RA_NOME    //nome completo	
	Endif
	
	//pesquisa o gestor
	/*
	PswOrder(2)  //pesquisa pelo nome
	If PswSeek( cGestor , .T. )  
	   aUsu   := PSWRET() 					   
	   cMailGestor := Alltrim( aUsu[1][14] )    //email do Gestor
	   cNomeGestor := aUsu[1][4]  //nome completo	    
	Endif 
	*/
	//pesquisa o gestor
	SRA->(Dbsetorder(1))
	If SRA->(Dbseek(xFilial("SRA") + cMatG ))
		cMailGestor:= SRA->RA_EMAIL //email do responsável pela ação
	   	cNomeGestor:= SRA->RA_NOME    //nome completo	
	Endif
	
Endif
cMail5S := GetMV("RV_EQP5S")  //email da equipe 5S 

If nOpc = 4 .or. nOpc = 7 //responder ou feedback
	cMailTo += cMail5S + ";" + cEmailUsr + ";" + cEmailResp + ";" + cMailGestor  //Aline e Equipe 5S só recebem a cópia do email qdo for "resposta" ou "feedback"
Else
	cMailTo += cEmailUsr + ";" + cEmailResp + ";" + cMailGestor //FR - 09/11/13 - Aline solicitou retirar o email dela quando for aviso de inclusão
Endif   

//cEmailUsr = email do usuário logado
//cMail5S = email(s) da equipe 5S
//cEmailResp = email do responsável pela ação
//cMailGestor = email do Gestor

////////////automático

// Inicialize a classe de processo:
oProcess:=TWFProcess():New("5S","5S")

// Crie uma nova tarefa, informando o html template a ser utilizado: 
If Alltrim(cAICI) != 'AI' //se não for Ato Inseguro, utiliza o html do 5S para Condição Insegura
	If nOpc = 3 .or. nOpc = 6             //incluir ou alterar
		oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S_Envio.htm")
		//oProcess:NewTask('Inicio',"\workflow\http\teste\WF5S_Envio.htm")
	Elseif nOpc = 4                     //responder
		oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S_Resp.htm")
		//oProcess:NewTask('Inicio',"\workflow\http\teste\WF5S_Resp.htm")
	Elseif nOpc = 7                    //feedback
		oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S_Just.htm")
		//oProcess:NewTask('Inicio',"\workflow\http\teste\WF5S_Just.htm")
	Endif
	oHtml   := oProcess:oHtml	
	oHtml:ValByName("cResp", cRespon )
	oHtml:ValByName("cOperador", cNomeUsr )
	oHtml:ValByName("cDepto", cDeptoUsr )
	oHtml:ValByName("cDESC",  cProblema )
	oHtml:ValByName("cSOL", cNumSol )
	oHtml:ValByName("dDATA" , cEmissao ) 	
	
	If nOpc = 3 .or. nOpc = 6
		If !Empty(cCaminho)
			cMsg := "Por gentileza, pedimos que providencie a resolução o mais breve possível." + CHR(13) + CHR(10)
			cMsg +=  '<br>' + CHR(13) + CHR(10)
			cMsg += "Arquivo do Processo em Anexo"
			
			If Alltrim(cSolant) != '' 
				cMsg +=  '<br>' + CHR(13) + CHR(10)
				cMsg += "Esta Solicitação é uma Reincidência da Solicitação Anterior No.: " + Alltrim(cSolant)
			Endif
		Else
			cMsg := "Por gentileza, pedimos que providencie a resolução o mais breve possível"
		Endif
	Endif


Else 
	//oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S_Envio.htm")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S_AiEnvio.htm") 
	oHtml   := oProcess:oHtml
	oHtml:ValByName("cGestor", cNomeGestor )
	oHtml:ValByName("cRespAto", aRespons[1] + '-' + cNomeResp )
	oHtml:ValByName("cOperador", cNomeUsr )
	oHtml:ValByName("cDepto", cDeptoUsr )
	oHtml:ValByName("dDATA" , DTOC(dDtSoli))
	oHtml:ValByName("cReincd", iif(lBoxSim, "Sim", "Nao") )
	oHtml:ValByName("cQuemAPL", cQuemApl )  //quem aplicou o AI.
	x:= 1
	For x:= 1 to Len(aBoxes)                           
		If x < Len(aBoxes)
			cDescAto += aBoxes[x] + ',' + '<br>'
		Endif
		
		If x = Len(aBoxes)
			cDescAto += aBoxes[x] + '.'
		Endif
		
	Next
	oHtml:ValByName("cDESC",  cDescAto )	
	oHtml:ValByName("cTurno",  cTurno )	
	oHtml:ValByName("cSOL", xNumSol )
	
	cMail5S += ";marcelo@ravaembalagens.com.br"
Endif



//registra na tabela de saldos, o saldo de cada responsável pela ação:
x:= 0 
//FR - 25/04/13 - GUT não mais usado
//	If Len(aIndResp) > 0 	
//		For x := 1  to Len(aIndResp)	
//			aadd( oHtml:ValByName("it.cRespon"), aIndResp[x,1] )
//			aadd( oHtml:ValByName("it.nSaldo") ,  Alltrim(Str(aIndResp[x,2])) )			
//		Next		
//	Endif







If Alltrim(cAICI) != "AI"
	If nOpc = 4
		oHtml:ValByName("cResposta"    , cResposta )	
		oHtml:ValByName("dDATASOL" , cDataSoL ) 
		oHtml:ValByName("nDias"    , nDias )
		oHtml:ValByName("dDTPREV" , cPrevisao )  
	Endif
	
	If nOpc = 7
		oHtml:ValByName("cJustif"    , cJustif )
		oHtml:ValByName("dDTPREV" , cPrevisao ) 
	Endif

	oHtml:ValByName("cMsg", cMsg )
	//COPIA ANTES PARA A PASTA \IMAGENS
   MsAguarde( { || lCopiou := CpyT2S( Alltrim(cCaminho) , "\IMAGENS", .T. ) }, "Aguarde. . .", "Anexando Foto ao E-Mail . . ." )
   oProcess:AttachFile( "\IMAGENS\" + Alltrim(cFoto) )    
//anexa a foto do processo, somente funciona se a imagem estiver numa pasta abaixo de PROTHEUS_DATA
//oProcess:AttachFile(alltrim("SERVIDOR\5S\TAB_GUT.PDF") )  //anexa a tabela Gut para referência 
//PARÂMETRO: MV_WFIMAGE habilita anexar imagens ao email (tem q estar .F.)


//DEPOIS DE ANEXAR, APAGA O ARQUIVO DA PASTA \IMAGENS:
//FErase ( < cArquivo> ) --> nRet

Endif

   
cMailTo += ";flavia.rocha@ravaembalagens.com.br" //retirar

oProcess:cTo	:= cMailTo //(EQUIPE 5S, USUÁRIO LOGADO, RESPONSÁVEIS)
oProcess:cCC    := ""
If Alltrim(cAICI) != "AI"
	If nOpc = 3   		//inclusão
		oProcess:cSubject := "Uma Nova Solicitação do Programa 5S - " + Alltrim(cNumSoL)
	Elseif nOpc = 4		//responder
		oProcess:cSubject := "Resolvida a Solicitação do Programa 5S - " + Alltrim(cNumSoL)	
	Elseif nOpc = 6		//alteração
		oProcess:cSubject := "Solicitação do Programa 5S - " + Alltrim(cNumSoL)	
	Elseif nOpc = 7		//feedback
		oProcess:cSubject := "FeedBack Registrado -  5S - " + Alltrim(cNumSoL)	
	Endif 
Else
	oProcess:cSubject := "Ocorrência de Ato Inseguro - " + Alltrim(xNumSoL)     
Endif
oProcess:Start()  //SE O PARÂMETRO MV_WFENVJA estiver ativado, assim que passar ler esta linha de comando, já envia o email
                  //sem precisar do comando WFSENDMAIL() - desativei o parâmetro porque estava chegando 2 emails.
WfSendMail()

/*
If FERASE("\IMAGENS\" + Alltrim(cFoto) ) == -1   
   MsgStop('Falha na deleção do Arquivo')
Else   
   MsgStop('Arquivo deletado com sucesso.')
Endif 
*/
////////////fim automático

///processo manual
////CRIA O ARQUIVO DO HTML
/*
cDirHTM  := "C:\Temp\"    
cArqHTM  := "5S_" + cNumSoL + ".html"   
nHandle := fCreate( cDirHTM + cArqHTM, 0 )
		
If nHandle = -1
     MsgAlert('O arquivo '+ AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

cAssun  := "Solicitação do Programa 5S - " + Alltrim(cNumSoL)
chtm := GeraHTM( cNumSoL, cProblema, cEmissao, cNomeUsr, cRespon, cDeptoUsr, cCaminho, cFoto )
//////GRAVA O HTML 
Fwrite( nHandle, chtm, Len(chtm) )
Fwrite( nHandle, cCorpo, Len(cCorpo) )
FClose( nHandle )
		
cCopia  := ""					
cCorpo  := cAssun  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
cAnexo  := cDirHTM + cArqHTM
SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
*/
		  
MsgInfo("Email enviado com Sucesso !")

Return
		
/*
****************************************
Static Function fSaldoGut( cResp )  
****************************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local nSaldo := 0

cQuery := "Select " + LF
cQuery += " Sum(Z81_INDICE) AS SALDO, Z81_USER, Z81_NOME " + LF
cQuery += " FROM " + RetSqlName("Z81") + " Z81 " + LF
cQuery += " where D_E_L_E_T_ = '' " + LF
cQuery += " and Z81_USER = '" + Alltrim(cResp) + "' " + LF
cQuery += " GROUP BY Z81_USER, Z81_NOME " + LF 
cQuery += " ORDER by Z81_NOME" + LF 
MemoWrite("C:\Temp\ver_saldo_gut.sql",cQuery)
If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()
EndIf
			
TCQUERY cQuery NEW ALIAS "TMPX"

dbGoTop()
If !TMPX->(EOF())
	While !TMPX->(EOF())
		nSaldo := TMPX->SALDO
	    TMPX->(DBSKIP())
	Enddo
Endif

DbSelectArea("TMPX")
DbCloseArea()

Return(nSaldo)
*/
//CÁLCULO DO GUT
/*
***************************************
Static Function CalcGUT(cTot, nDias, cSolant)
***************************************

Local nIndice:= 0
Local nPerGut:= 0
Local nTot  := Val(cTot)

/*
3 , 5 
 110% - 0 a 4 dias
 100% - 5 a 7 dias
 90% - 8 a 10 dias
 80% - acima de 11 dias
 

7 , 9
 110% - 0 a 7 dias
 100% - 8 a 12 dias
 90%  - 13 a 16 dias 
 80%  - acima de 17 dias 
 
11 , 13
  110% - 0 a 10 dias
  100% - 11 a 15 dias
  90%  - 16 a 20 dias 
  80%  - acima de 21 dias 
  
15
  110% - 0 a 20 dias
  100% - 21 a 30 dias
  90%  - 31 a 40 dias 
  80%  - acima de 41 dias 

*/
/*
If nTot = 3 .or. nTot = 5
	If Alltrim(cSolant) = ''
		If nDias <= 4 
			nPerGut := (110 / 100)		
		Elseif nDias <= 7 
			nPerGut := (100 / 100)		
		Elseif nDias <= 10 
			nPerGut := (90 / 100)		
		Elseif nDias >= 11 
			nPerGut := (80 / 100)		
		Endif
		//nIndice := (nTot * nPerGut) - nTot
	Else     //reincid.
		If nDias <= 4 
			nPerGut := (100 / 100)		
		Elseif nDias <= 7 
			nPerGut := (90 / 100)		
		Elseif nDias <= 10 
			nPerGut := (80 / 100)		
		Elseif nDias >= 11 
			nPerGut := (70 / 100)		
		Endif
	
	Endif

ElseIf nTot = 7 .or. nTot = 9
	If Alltrim(cSolant) = ''
		If nDias <= 7 
			nPerGut := (110 / 100)	
		Elseif nDias <= 12 
			nPerGut := (100 / 100)	
		Elseif nDias <= 16 
			nPerGut := (90 / 100)	
		Elseif nDias >= 17 
			nPerGut := (80 / 100)	
		Endif
	Else 
		If nDias <= 7 
		nPerGut := (100 / 100)	
		Elseif nDias <= 12 
			nPerGut := (90 / 100)	
		Elseif nDias <= 16 
			nPerGut := (80 / 100)	
		Elseif nDias >= 17 
			nPerGut := (70 / 100)	
		Endif
	Endif
	
ElseIf nTot = 11 .or. nTot = 13
	If Alltrim(cSolant) = ''
		If nDias <= 10 
			nPerGut := (110 / 100)	
		Elseif nDias <= 15 
			nPerGut := (100 / 100)	
		Elseif nDias <= 20 
			nPerGut := (90 / 100)	
		Elseif nDias >= 21 
			nPerGut := (80 / 100)	
		Endif
	Else 
		If nDias <= 10 
			nPerGut := (100 / 100)	
		Elseif nDias <= 15 
			nPerGut := (90 / 100)	
		Elseif nDias <= 20 
			nPerGut := (80 / 100)	
		Elseif nDias >= 21 
			nPerGut := (70 / 100)	
		Endif
	Endif
	//nIndice := (nTot * nPerGut) - nTot
ElseIf nTot = 15
	If Alltrim(cSolant) = ''
		If nDias <= 20 
			nPerGut := (110 / 100)	
		Elseif nDias <= 30 
			nPerGut := (100 / 100)	
		Elseif nDias <= 40 
			nPerGut := (90 / 100)	
		Elseif nDias >= 41 
			nPerGut := (80 / 100)
		Endif
	Else 
		If nDias <= 20 
			nPerGut := (100 / 100)	
		Elseif nDias <= 30 
			nPerGut := (90 / 100)	
		Elseif nDias <= 40 
			nPerGut := (80 / 100)	
		Elseif nDias >= 41 
			nPerGut := (70 / 100)
		Endif
	Endif
	
Endif
//nIndice := (nTot * nPerGut) - nTot
//MSGBOX("nTot: " + str(nTot) )
//MSGBOX("nPerGut: " + str(nPerGut) )
nIndice := (nTot * nPerGut)

Return(nIndice)
*/

//incluido
************************
User Function Manut5S(cAlias,nReg,nOpc)
************************

PRIVATE nOpcA
PRIVATE nG := ""
PRIVATE cG := ""
Private oDlx
Private oCBoxChoice

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgX","oGrp1","oSay1","oCBoxChoice","cCombo","oCombo","oBtn1","oBtn2")

If nOpc <> 5
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlgX      := MSDialog():New( 152,414,312,739,"Rava",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 004,005,051,155,"Solicitação 5S",oDlgx,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 022,012,{||"Tipo da Solicitação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	
	oCBoxChoice         := TComboBox():New( 022,064,,{"Ato Inseguro", "Cond Insegura"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,"nG" )
	oCBoxChoice:bSetGet := {|u| If(PCount()>0,nG:=u,nG)}
	oCBoxChoice:nAt := 1
	
	oBtn1      := TButton():New( 060,118,"Cancel",oDlgx,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {|| (nOpcA := 0,oDlgx:End())}
	
	oBtn2      := TButton():New( 060,076,"OK",oDlgx,,037,012,,,,.T.,,"",,,,.F. )
	If nOpc <> 2     //FR  - SE for = 3, é incluir	 
		oBtn2:bAction := {||U_fTeste(nOpc),oDlgx:End()}	
	Else				//FR - SE for = 2,  é visualizar
		oBtn2:bAction := {|| (nOpcA := 0 ,oDlgx:End() ) }	
	Endif
	oDlgx:Activate(,,,.T.)
Else  //excluir
	//IF ALLTRIM(Z80->Z80_TIPO) = 'AI'
		//fExcluiAI()
	//ELSE  //se é condição insegura
		
	//ENDIF
	Grava(nOpc, .F.)   //excluir
Endif


Return

//Esse teste vai dizer se é pra entrar na tela de ato inseguro ou condição insegura
**********************
User Function fTeste(nOpc)
**********************

IF oCBoxChoice:nAt = 1
	If nOpc = 3
		U_AtoInse(nOpc)  //FR nOpTipo aqui defino 3, pois sabemos que neste pto, é inclusão
	Elseif nOpc = 5 //Excluir
		fExcluiAI()
	Endif
else
	//oDlx:End()
	U_Tela5S(,,3,.F.)  //O .F. é se a chamada é de de fora (.T.) ou de dentro deste programa (.F.)
endif

Return

****************************
User Function AtoInse(nOpTipo)   //FR
****************************

Local cNomeoption := ""
SetPrvt("oCBoxO1" ,"oCBoxO2", "oCBoxO3","oCBoxO4","oCBoxO5","oCBoxO6","oCBoxO7","oCBoxO8","oCBoxO9","oCBoxO10","oCBoxO11", "oCBoxO12","oCBoxO13","oCBoxO14")

//Private cQuemApl := ""
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


If nOpTipo = 3
	lBoxSim  := .F.
	lBoxNao  := .F.
	lBox4:= .F.
	lBox5:= .F.
	lBox6:= .F.
	lBox7:= .F.
	lBox8:= .F.
	lBox9:= .F.
	lBox10:= .F.
	lBox11:= .F.
	lBox12:= .F.
	lBox13:= .F.
	lBox14:= .F.
	cAInome   := Space(40)
	cAIgestor := Space(40)
	cTurno    := Space(1)

Endif



cNomeOption := Iif(nOpTipo = 3 , "Incluir" , "Visualizar" )
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgz      := MSDialog():New( 048,323,590,669,"Ato Inseguro - " + cNomeOption,,,.F.,,,,,,.T.,,,.F. )
//oDlgz      := MSDialog():New( 048,323,610,669,"Ato Inseguro - " + cNomeOption,,,.F.,,,,,,.T.,,,.F. )

oSayMat      := TSay():New( 031,008,{||"Matr."},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,018,008)
oSayNomeF    := TSay():New( 031,074,{||"Nome"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,018,008)
oSayGestor   := TSay():New( 048,008,{||"Gestor"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,018,008)
oSayNomeG    := TSay():New( 048,074,{||"Nome"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,018,008)
oSayDTSol    := TSay():New( 015,078,{||"Data Solicit"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)


//FR
IF nOpTipo = 3     //incluir

	xNumSol := GetSxENum("Z80","Z80_NUMSOL")
	While Z80->( DbSeek( xFilial( "Z80" ) + xNumsol ) )
	   ConfirmSX8()
	   xNumSol := GetSxeNum("Z80","Z80_NUMSOL")
	Enddo
	dDtSoli   := dDatabase
	                                                                                   
	oGetDTSol      := TGet():New( 014,111,,oDlgz,045,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtSoli",,)
	oGetDTSol:bSetGet := {|u| If(PCount()>0,dDtSoli:=u,dDtSoli)}
    
    ///NOME DA PESSOA QUE COMETEU O AI
	//oGetNome      := TGet():New( 030,032,,oDlgz,124,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"US3","cAInome",,)
	//oGetNome:bSetGet := {|u| If(PCount()>0,cAInome:=u,cAInome)}	
	
	oGetMat      := TGet():New( 030,032,,oDlgz,035,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA04","cMatF",,)
	oGetMat:bSetGet := {|u| If(PCount()>0,cMatF:=u,cMatF)}	
	
	oGetNome      := TGet():New( 030,090,,oDlgz,084,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAInome",,)
	oGetNome:bSetGet := {|u| If(PCount()>0,cAInome:=u,cAInome)}	
	
	///GESTOR DA PESSOA QUE COMETEU O AI
	//oGetGestor      := TGet():New( 047,032,,oDlgz,124,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA","cAIgestor",,)
	//oGetGestor:bSetGet := {|u| If(PCount()>0,cAIgestor:=u,cAIgestor)} 
	
	oGetMatG      := TGet():New( 047,032,,oDlgz,035,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA04","cMatG",,)
	oGetMatG:bSetGet := {|u| If(PCount()>0,cMatG:=u,cMatG)}
	
	oGetGestor      := TGet():New( 047,090,,oDlgz,084,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAIgestor",,)
	oGetGestor:bSetGet := {|u| If(PCount()>0,cAIgestor:=u,cAIgestor)}
	
	oCBoxTurno     := TComboBox():New( 064,032,,{"1º Turno", "2º Turno", "3º Turno"},042,010,oDlgz,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cTurno )
	oCBoxTurno:bSetGet := {|u| If(PCount()>0,cTurno:=u,cTurno)}  

ELSE              //visualizar

	oGetDTSol      := TGet():New( 014,111,,oDlgz,045,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtSoli",,)
	oGetDTSol:bSetGet := {|u| If(PCount()>0,dDtSoli:=u,dDtSoli)}
	oGetDTSOL:lReadOnly   := .T. 
	
	//oGetNome      := TGet():New( 030,032,,oDlgz,124,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"US3","cAInome",,)
	//oGetNome:bSetGet := {|u| If(PCount()>0,cAInome:=u,cAInome)}
	//oGetNome:lReadOnly   := .T. 
	
	oGetMat      := TGet():New( 030,032,,oDlgz,035,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA04","cMatF",,)
	oGetMat:bSetGet := {|u| If(PCount()>0,cMatF:=u,cMatF)}
	oGetMat:lReadOnly   := .T. 	
	
	oGetNome      := TGet():New( 030,090,,oDlgz,084,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAInome",,)
	oGetNome:bSetGet := {|u| If(PCount()>0,cAInome:=u,cAInome)}	
	oGetNome:lReadOnly   := .T. 
	
	oGetMGestor      := TGet():New( 047,032,,oDlgz,035,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA04","cMatG",,)
	oGetMGestor:bSetGet := {|u| If(PCount()>0,cMatG:=u,cMatG)}	
	
	oGetGestor      := TGet():New( 047,090,,oDlgz,084,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAIgestor",,)
	oGetGestor:bSetGet := {|u| If(PCount()>0,cAIgestor:=u,cAIgestor)}	
	oGetGestor:lReadOnly   := .T. 
	
	oCBoxTurno     := TComboBox():New( 064,032,,{"1º Turno", "2º Turno", "3º Turno"},042,010,oDlgz,,,,CLR_BLACK,CLR_LIGHTGRAY,.T.,,"",,,,,,, )
	oCBoxTurno:bSetGet := {|u| If(PCount()>0,cTurno:=u,cTurno)}  
	oCBoxTurno:lReadOnly   := .T. 
ENDIF
//FR



oGetGestor:bSetGet := {|u| If(PCount()>0,cAIgestor:=u,cAIgestor)}

oSayTurno      := TSay():New( 064,008,{||"Turno"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,008)


//oSayReinci    := TSay():New( 080,008,{||"Reincidente"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayReinci    := TSay():New( 064,078,{||"Reincidente"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
//oSayQuemApl   := TSay():New( 096,008,{||"Quem Aplicou"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSayQuemApl   := TSay():New( 087,008,{||"Quem Aplicou:"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)

oGetApl1       := TGet():New( 095,008,,oDlgz,035,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA04","cMatQ",,)
oGetApl1:bSetGet := {|u| If(PCount()>0,cMatQ:=u,cMatQ)}	

oGetApl2       := TGet():New( 095,045,,oDlgz,124,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cQuemApl",,)
oGetApl2:bSetGet := {|u| If(PCount()>0,cQuemApl:=u,cQuemApl)}	

//oGrpOcorr      := TGroup():New( 096,004,240,168,"Ocorrência",oDlgz,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrpOcorr      := TGroup():New( 109,004,250,168,"Ocorrência",oDlgz,CLR_BLACK,CLR_WHITE,.T.,.F. )

IF nOpTipo = 3     //incluir
	//oCBoxSim     := TCheckBox():New( 080,052,"Sim",,oDlgz,024,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBoxSim",, )
	oCBoxSim     := TCheckBox():New( 064,115,"Sim",,oDlgz,024,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBoxSim",, )
	oCBoxSim:bSetGet := {|u| If(PCount()>0,lBoxSim:=u,lBoxSim)}

	oCBoxO1     := TCheckBox():New( 119,008,"Não usou equipamento de proteção",,oGrpOcorr,097,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox4",, )
	oCBoxO2     := TCheckBox():New( 131,008,"Usou calçado inadequado na produção",,oGrpOcorr,107,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox5",, )
	oCBoxO3     := TCheckBox():New( 143,008,"Usou adorno na produção",,oGrpOcorr,075,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox6",, )
	oCBoxO4     := TCheckBox():New( 155,008,"Usou fone de ouvido",,oGrpOcorr,064,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox7",, )
	oCBoxO5     := TCheckBox():New( 167,008,"Usou boné na produção",,oGrpOcorr,071,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox8",, )
	oCBoxO6     := TCheckBox():New( 179,008,"Cabelo solto próximo a máquinas e equipamentos",,oGrpOcorr,128,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox9",, )
	oCBoxO7    := TCheckBox():New( 191,008,"Fumou nas dependências da Empresa",,oGrpOcorr,101,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox10",, )
	oCBoxO8    := TCheckBox():New( 203,008,"Correu nas áreas da produção",,oGrpOcorr,083,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox11",, )
	oCBoxO9    := TCheckBox():New( 215,008,"Ultrapassou ou violou área isolada sem autorização",,oGrpOcorr,135,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox12",, )
	oCBoxO10    := TCheckBox():New( 227,008,"Gritou ou assoviou para chamar uma pessoa",,oGrpOcorr,129,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox13",, )
	oCBoxO11    := TCheckBox():New( 239,008,"Limpeza e organização do local de trabalho ",,oGrpOcorr,114,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"lBox14",, )
		
	oCBoxO1:bSetGet := {|u| If(PCount()>0,lBox4:=u,lBox4)}
	oCBoxO2:bSetGet := {|u| If(PCount()>0,lBox5:=u,lBox5)}
	oCBoxO3:bSetGet := {|u| If(PCount()>0,lBox6:=u,lBox6)}
	oCBoxO4:bSetGet := {|u| If(PCount()>0,lBox7:=u,lBox7)}
	oCBoxO5:bSetGet := {|u| If(PCount()>0,lBox8:=u,lBox8)}
	oCBoxO6:bSetGet := {|u| If(PCount()>0,lBox9:=u,lBox9)}
	oCBoxO7:bSetGet := {|u| If(PCount()>0,lBox10:=u,lBox10)}
	oCBoxO8:bSetGet := {|u| If(PCount()>0,lBox11:=u,lBox11)}
	oCBoxO9:bSetGet := {|u| If(PCount()>0,lBox12:=u,lBox12)}
	oCBoxO10:bSetGet := {|u| If(PCount()>0,lBox13:=u,lBox13)}
	oCBoxO11:bSetGet := {|u| If(PCount()>0,lBox14:=u,lBox14)}

ELSE


	oCBoxO1     := TCheckBox():New( 119,008,"Não usou equipamento de proteção",,oGrpOcorr,097,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox4",, )
	If lBoxSim
		oCBoxSim     := TCheckBox():New( 064,115,"Sim",,oDlgz,024,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBoxSim",, )
		oCBoxSim:bSetGet := {|u| If(PCount()>0,lBoxSim:=u,lBoxSim)}
		oCBoxSim:lReadOnly   := .T. 
	Else
		oCBoxNao     := TCheckBox():New( 064,115,"Não",,oDlgz,021,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBoxNao",, )
		oCBoxNao:bSetGet := {|u| If(PCount()>0,lBoxNao:=u,lBoxNao)}
		oCBoxNao:lReadOnly   := .T.
	Endif
	
	oCBoxO2     := TCheckBox():New( 131,008,"Usou calçado inadequado na produção",,oGrpOcorr,107,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox5",, )
	oCBoxO3     := TCheckBox():New( 143,008,"Usou adorno na produção",,oGrpOcorr,075,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox6",, )
	oCBoxO4     := TCheckBox():New( 155,008,"Usou fone de ouvido",,oGrpOcorr,064,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox7",, )
	oCBoxO5     := TCheckBox():New( 167,008,"Usou boné na produção",,oGrpOcorr,071,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox8",, )
	oCBoxO6     := TCheckBox():New( 179,008,"Cabelo solto próximo a máquinas e equipamentos",,oGrpOcorr,128,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox9",, )
	oCBoxO7    := TCheckBox():New( 191,008,"Fumou nas dependências da Empresa",,oGrpOcorr,101,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox10",, )
	oCBoxO8    := TCheckBox():New( 203,008,"Correu nas áreas da produção",,oGrpOcorr,083,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox11",, )
	oCBoxO9    := TCheckBox():New( 215,008,"Ultrapassou ou violou área isolada sem autorização",,oGrpOcorr,136,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox12",, )
	oCBoxO10    := TCheckBox():New( 227,008,"Gritou ou assoviou para chamar uma pessoa",,oGrpOcorr,129,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox13",, )
	oCBoxO11    := TCheckBox():New( 239,008,"Limpeza e organização do local de trabalho ",,oGrpOcorr,114,008,,,,,CLR_BLACK,CLR_LIGHTGRAY,,.T.,"lBox14",, ) 
	
	
	
	
	oCBoxO1:bSetGet := {|u| If(PCount()>0,lBox4:=u,lBox4)}
	oCBoxO2:bSetGet := {|u| If(PCount()>0,lBox5:=u,lBox5)}
	oCBoxO3:bSetGet := {|u| If(PCount()>0,lBox6:=u,lBox6)}
	oCBoxO4:bSetGet := {|u| If(PCount()>0,lBox7:=u,lBox7)}
	oCBoxO5:bSetGet := {|u| If(PCount()>0,lBox8:=u,lBox8)}
	oCBoxO6:bSetGet := {|u| If(PCount()>0,lBox9:=u,lBox9)}
	oCBoxO7:bSetGet := {|u| If(PCount()>0,lBox10:=u,lBox10)}
	oCBoxO8:bSetGet := {|u| If(PCount()>0,lBox11:=u,lBox11)}
	oCBoxO9:bSetGet := {|u| If(PCount()>0,lBox12:=u,lBox12)}
	oCBoxO10:bSetGet := {|u| If(PCount()>0,lBox13:=u,lBox13)}
	oCBoxO11:bSetGet := {|u| If(PCount()>0,lBox14:=u,lBox14)} 
	
	oCBoxO1:lReadOnly   := .T. 
	oCBoxO2:lReadOnly   := .T. 
	oCBoxO3:lReadOnly   := .T. 
	oCBoxO4:lReadOnly   := .T. 
	oCBoxO5:lReadOnly   := .T. 
	oCBoxO6:lReadOnly   := .T. 
	oCBoxO7:lReadOnly   := .T. 
	oCBoxO8:lReadOnly   := .T. 
	oCBoxO9:lReadOnly   := .T. 
	oCBoxO10:lReadOnly   := .T. 
	oCBoxO11:lReadOnly   := .T. 
ENDIF

oSayCODSOL      := TSay():New( 015,007,{||"Código"},oDlgz,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,019,008)
oGetCODSOL      := TGet():New( 014,032,,oDlgz,041,008,'@!',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","xNumSol",,)
oGetCODSOL:bSetGet := {|u| If(PCount()>0,xNumSol:=u,xNumSol)}
oGetCODSOL:Disable()


oBtnAto1      := TButton():New( 255,130,"&OK",oDlgz,,037,012,,,,.T.,,"",,,,.F. )
//FR
IF nOpTipo = 3
	oBtnAto1:bAction := {|| (Gravar(xNumSol, dDtSoli, cMatF , cAInome, cMatG, cAIgestor, cMatQ , cQuemApl) ) }
ELSE
	oBtnAto1:bAction := { || oDlgz:End() }
ENDIF

oBtnAto2      := TButton():New( 255,090,"&Cancelar",oDlgz,,037,012,,,,.T.,,"",,,,.F. )
oBtnAto2:bAction := { || oDlgz:End() }

oDlgz:Activate(,,,.T.)

Return

************************************************************
Static Function Gravar(xNumSol, dDtSoli, cMatF, cAInome, cMatG, cAIgestor, cMatQ, cQuemApl)
************************************************************
//Gravar(xNumSol, dDtSoli, cMatF , cAInome, cMatG, cAIgestor, cMatQ , cQuemApl

Local _X := 0 
Local aBoxes := {}
aRespons := {}
If !Empty(cAInome) .or. !Empty(cAIgestor)
	dbSelectArea("Z80")
	dbSetOrder(1)
		RecLock("Z80",.T.)
			Z80->Z80_NUMSOL := xNumSol
			Z80->Z80_EMISSA := dDtSoli
			Z80->Z80_TIPO   := 'AI'
			Z80->Z80_MATF   := cMatF
			Z80->Z80_NOME1  := cAInome
			Z80->Z80_MATG   := cMatG
			Z80->Z80_NOME2  := cAIgestor
			Z80->Z80_MATQ   := cMatQ
			Z80->Z80_QAPLIC := cQuemApl
		
			IF &("lBoxSim") 
				Z80->Z80_REINCD := '*'
			ENDIF
			Z80->Z80_TURNO  := Substr(cTurno,1,1)
			
			
			//ALERT("TURNO:" + SUBSTR(cTurno,1,1) )
        /*                  //este loop começou a dar erro, dizendo que não existia a variável oCBoxO...x 
        for _X:=4 to 14 
                IF &("lBox"+alltrim(str(_X))) 
                	//alert( "lBox"+alltrim(str(_X)) + " ->" + &("oCBoxO"+alltrim(str(_X))):cCaption )
                	Aadd(aBoxes ,&("oCBoxO"+alltrim(str(_X))):cCaption ) 
                   &("Z80_DESC"+ALLTRIM(STR(_X-3))) := &("oCBoxO"+alltrim(str(_X))):cCaption
                   //Aadd(aBoxes ,&("oCBoxO"+alltrim(str(_X))):cCaption ) 
                endif          
        Next      			
        */
        //FR - então substituí pela instrução manual abaixo (não é mto legal, mas funciona)
        If lBox4
        	Z80->Z80_DESC1 := oCBoxO1:cCaption
        	Aadd(aBoxes ,oCBoxO1:cCaption ) 
		Endif  
		If lBox5
        	Z80->Z80_DESC2 := oCBoxO2:cCaption
        	Aadd(aBoxes ,oCBoxO2:cCaption ) 
		Endif
		If lBox6
        	Z80->Z80_DESC3 := oCBoxO3:cCaption
        	Aadd(aBoxes ,oCBoxO3:cCaption ) 
		Endif
		If lBox7
        	Z80->Z80_DESC4 := oCBoxO4:cCaption
        	Aadd(aBoxes ,oCBoxO4:cCaption ) 
		Endif
		If lBox8
        	Z80->Z80_DESC5 := oCBoxO5:cCaption
        	Aadd(aBoxes ,oCBoxO5:cCaption ) 
		Endif
		If lBox9
        	Z80->Z80_DESC6 := oCBoxO6:cCaption
        	Aadd(aBoxes ,oCBoxO6:cCaption ) 
		Endif
		If lBox10
        	Z80->Z80_DESC7 := oCBoxO7:cCaption
        	Aadd(aBoxes ,oCBoxO7:cCaption ) 
		Endif
		If lBox11
        	Z80->Z80_DESC8 := oCBoxO8:cCaption
        	Aadd(aBoxes ,oCBoxO8:cCaption ) 
		Endif
		If lBox12
        	Z80->Z80_DESC9 := oCBoxO9:cCaption
        	Aadd(aBoxes ,oCBoxO9:cCaption ) 
		Endif
		If lBox13
        	Z80->Z80_DESC10 := oCBoxO10:cCaption
        	Aadd(aBoxes ,oCBoxO10:cCaption ) 
		Endif
		If lBox14
        	Z80->Z80_DESC11 := oCBoxO11:cCaption
        	Aadd(aBoxes ,oCBoxO11:cCaption ) 
		Endif
	
  		
  	
		Z80->(MsUnlock())
		
		////FR - 07/05/14 - GRAVA INFORMAÇÕES NA TABELA DE AVALIAÇÃO M.O. (MÃO DE OBRA)
		///Z14
		dbSelectArea("Z14") 
		RecLock("Z14",.T.)                                                    
		//Z14->Z14_FILIAL := compartilhado, não precisa gravar filial
		Z14->Z14_MAT := cMatF
		Z14->Z14_QTCARD := 1 //GRAVA O CARTÃO DESTA DATA, PARA MAIS TARDE FAREMOS UM SOMATÓRIO DE TODOS OS REGISTROS
		Z14->Z14_DTMOV  := dDatabase
		Z14->(MsUnlock())
		///fim gravação da Z14
		
	Alert("Ato Inseguro Gravado Com Sucesso") 
	//Adiciona o responsável pelo ato
	//Aadd(aRespons, cAInome)
	Aadd(aRespons, cMatF)
	//neste ponto envia o email para os responsáveis
	MsAguarde( { || U_5SEnvio( aRespons, , , nOpTipo, 'AI', cAIgestor, aBoxes, cTurno, xNumSol, lBoxSim, cMatG )	 }, "Aguarde. . .", "Enviando E-Mail . . ." )

	oDlgz:End()
Else
	Alert("Ato Inseguro não gravado, faltam informações")
Endif 

Return

