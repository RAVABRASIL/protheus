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
±±ºPrograma  ³ GPEC009  º Autor ³ Flávia Rocha       º Data ³  15/05/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ ¹±±
±±ºDescricao ³ Programa para inserir as idéias de funcionários - 5S        º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ¹±±
±±ºUso       ³ RH - Será usado inclusive no programa de avaliação de       ¹±± 
±±º            Funcionários                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***********************
User Function GPEC009
***********************




Local aCores := {{ "Empty(ZA9->ZA9_CONCLU)"  , 'BR_VERDE'    },;  //IDEIA ABERTA
				 { "!Empty(ZA9->ZA9_CONCLU)"  , 'BR_VERMELHO'  } }  //IDEIA CONCLUÍDA
				


Private cCadastro := "Programa de Incentivo a Idéias"
//Private nOpc := 0
Private nOpTipo := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("ZA9")
dbSetOrder(1)

        		  
             		  
             		  Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
					{"Visualizar","U_TELAID",0,2} ,;
            		{"Incluir"   ,"U_TELAID",0,3} ,;
             		{"ALTERAR"   ,"U_TELAID",0,4},;
             		{"Excluir"   ,"U_TELAID",0,5},;             		
             		{"CONCLUIR"  ,"U_TELAID",0,7},;
             		  {"Legenda"   ,"U_IDLeg()",0,8} }	   
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZA9" 

dbSelectArea(cString)

mBrowse( 6, 1,22,75, cString,,,,,,aCores)

Return



***************************
User Function TELAID(cAlias,nReg,nOpc,lFora, cQuestion, cSector, cCODAUD )
***************************

//Local cTitle := iif( nOpc = 2," - Visualizar", iif(nOpc = 3, " - Incluir", iif( nOpc = 4, " - Responder", iif( nOpc = 5, " - Excluir", " - Alterar" ) )))
Local cTitle := iif( nOpc = 2," - Visualizar", iif(nOpc = 3, " - Incluir",;
                iif( nOpc = 4, " - Alterar", iif( nOpc = 5, " - Excluir",;
                iif( nOpc = 7, " - Concluir"  , "") ) )))

Private oSBtn1 
Private oSBtn2
Private cArq := "*.jpg"
Private aDir := Directory(cArq)
Private oCBoxSetor
Private nSetor:= ""
Private cSetor:= ""
Private nOrcam   := 0 //Space(20) 
Private nTipo    := ""
Private cTipoI   := ""
Private oDlg1
Private oGrp1
Private cFotoA := ""
Private cFotoD := ""
Private cCaminho := ""
Private cCaminhoA:= ""
Private cCaminhoD:= ""
Private nOpcA   := 0 
Private oSBtn1 
Private oSBtn2
Private cLogado := __CUSERID
Private aAreas  := {}
Private aSetores:= {}
Private aTipos  := {}
Private cIdeia  := Space(200)
Private cResposta:= Space(200)
Private cMatQ   := Space(6) //matrícula de quem deu a idéia
Private cMatA   := Space(6) //matrícula de quem aprovou
Private cNomeQ  := Space(50)
Private cNomeA  := Space(50)
Private cEmissao:= dDatabase  //Ctod("  /  /    ")
Private cDataSol:= Ctod("  /  /    ")  //data conclusão da idéia
Private cNumID  := Space(6) 
Private oDlg1
Private oGrp1
Private oSay_numsoL
Private oNumsoL
Private oSay_problem
Private oIDEIA
Private oSay_Emiss
Private oEmissao
Private oSay_fotoA 
Private oFotoA
Private oBtnFA
Private oSayOrc
Private oOrcam
Private oSay_Depto
Private oSayTPID
Private oTPID
Private oSayQuem
Private oQuemCod
Private oQuemNome
Private oSayPrev
Private oPrevisao
Private oSay_Respo
Private oResposta
Private oSay_datas
Private odatasoL
Private oSayAP
Private oAPVCod
Private oAPVNome
Private oSay_fotod 
Private oFotoD
Private oBtnFD			
Private oSBtn1
Private oSBtn2



////////////////////////////////////////////////////
If nOpc = 3
	cNumID    := GetSxENum("ZA9","ZA9_NUMID")
	while ZA9->( DbSeek( xFilial( "ZA9" ) + cNumID ) )
	   ConfirmSX8()
	   cNumID := GetSxeNum("ZA9","ZA9_NUMID")
	end
Else  //if nOpc = 4

//	PrepCampos(nOpc)
	//carrega campos
	   cNumID   := ZA9->ZA9_NUMID
	   cEmissao := ZA9->ZA9_DATA
	   cIdeia   := MSMM(ZA9->ZA9_CODMMI,80)        //para carregar Z80->Z80_PROBLE
	   cResposta:= MSMM(ZA9->ZA9_CODMMS,80) 	      //Z80->Z80_RESPOS
	   cDataSoL := ZA9->ZA9_CONCLU
	   cMatQ    := ZA9->ZA9_MAT
	   cMatA    := ZA9->ZA9_QAPROV
	   nOrcam   := ZA9->ZA9_VALOR
	   
	   //If nOpc <> 4
	   	cSetor   := ZA9->ZA9_SETOR
	   	nSetor   := ZA9->ZA9_SETOR
	   	cTipoI   := ZA9->ZA9_TIPOID
	   	nTipo    := ZA9->ZA9_TIPOID
	   //Endif 
	   
	   cFotoA   := Alltrim(ZA9->ZA9_FOTOA)
	   cCaminhoA := Alltrim(ZA9->ZA9_PATHA)
	   cFotoD   := Alltrim(ZA9->ZA9_FOTOD)
	   cCaminhoD := Alltrim(ZA9->ZA9_PATHD)
	   cImagemA  := Alltrim(ZA9->ZA9_PATHA) + Alltrim(ZA9->ZA9_FOTOA)
	   cImagemD  := Alltrim(ZA9->ZA9_PATHD) + Alltrim(ZA9->ZA9_FOTOD) 	   
	   
	   cMatA    := ZA9->ZA9_QAPROV
	   
	   
Endif

//alimenta setores
SX5->(Dbsetorder(1))
If SX5->(Dbseek(xFilial("SX5") + "ZW" ))
	While !SX5->(EOF()) .and. SX5->X5_TABELA = 'ZW'
		Aadd( aSetores, SX5->X5_CHAVE + '-' + SX5->X5_DESCSPA) 
		SX5->(DBSKIP())
	Enddo
Endif
	
Aadd( aTipos, "1-Nova Idéia" )
Aadd( aTipos, "2-Reabertura Idéia" )
Aadd( aTipos, "3-Redução Custo" )
Aadd( aTipos, "4-Melhoria de Processo" )

///TELA DIALOG PARA MANUTENÇÃO DO REGISTRO:

	oDlg1      := MSDialog():New( 031,233,551,1025,"PROGRAMA 5S INCENTIVO A IDÉIAS"+cTitle,,,.F.,,,,,,.T.,,,.F. )	
	oGrp1      := TGroup():New( 006,007,224,385,"  DETALHES DA IDÉIA  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )	
	
	oSay_numsoL := TSay():New( 020,015,{||"Idéia Numero:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
	
	oNumsoL     := TGet():New( 019,050,,oGrp1,057,008,'@!',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cNumID",,)
	oNumsoL:bSetGet := {|u| If(PCount()>0,cNumID:=u,cNumID)}
	oNumsoL:Disable()
	
	oSay_problem:= TSay():New( 038,015,{||"Descrição Idéia:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,009)
	oIDEIA  := TMultiGet():New( 049,014,,oGrp1,161,040,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	//If nOpc <> 2 .and. nOpc <> 5
		oIDEIA:bSetGet := {|u| If(PCount()>0,cIdeia:=u,cIdeia)}
	//Else
	If nOpc = 2 .or. nOpc = 5
		oIDEIA:Disable()
		oIDEIA:lReadOnly := .T.
	Endif
	
	oSay_Emiss  := TSay():New( 020,143,{||"Data Solic.:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oEmissao   := TGet():New( 019,178,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmissao",,)
	oEmissao:bSetGet := {|u| If(PCount()>0,cEmissao:=u,cEmissao)} 
	oEmissao:Disable()
	
	oSay_fotoA  := TSay():New( 012,280,{||"Foto Antes:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,031,009)
	If nOpc <> 2 .and. nOpc <> 5
		oFotoA      := TBitmap():New( 022,270,100,070,,"",.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oBtnFA      := TButton():New( 045,215,"Carrega Foto ==>",oGrp1,{||TrazFoto( @oFotoA, "A" )},047,012,,,,.T.,,"",,,,.F. ) 
		oBtnFA:bAction := {|| MsAguarde( { || TrazFoto( @oFotoA, "A" )	 }, "Aguarde. . .", "Inserindo Foto . . ." ) }
	Else
		oFotoA      := TBitmap():New( 022,270,100,070,,cImagemA,.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	Endif
	
	
	///previsão orçamentária para resolução
	oSayOrc := TSay():New( 065,195,{||"Orçamento Previsto:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
	oOrcam    := TGet():New( 076,195,{|u| If(PCount()>0,nOrcam:=u,nOrcam)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nOrcam",,)
	If nOpc <> 2 .and. nOpc <> 5
		oOrcam:bSetGet := {|u| If(PCount()>0,nOrcam:=u,nOrcam)}
	Else
		oOrcam:Disable()
	Endif
	
	oSay_Depto := TSay():New( 098,153,{||"Setor:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,009)
	
	oSayTPID := TSay():New( 098,280,{||"Tipo da Idéia:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
	
	If nOpc = 3 
		oCBoxSetor     := TComboBox():New( 106,153,,aSetores,120,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSetor ) 
		oCBoxSetor:bSetGet := {|u| If(PCount()>0,nSetor:=u,nSetor)}
		
		oTPID:= TComboBox():New( 106,280,,aTipos,070,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nTipo ) 
		oTPID:bSetGet := {|u| If(PCount()>0,nTipo:=u,nTipo)}
		 
	ElseIf nOpc = 4  
		oCBoxSetor     := TComboBox():New( 106,153,,aSetores,120,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSetor ) 
		//oCBoxSetor:bSetGet := {|u| If(PCount()>0,nSetor:=u,nSetor)}
		oCBoxSetor:bSetGet := {|u| nSetor:= cSetor}
		
		oTPID:= TComboBox():New( 106,280,,aTipos,070,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nTipo ) 
		oTPID:bSetGet := {|u| If(PCount()>0,nTipo:=u,nTipo)}  
		
	Else        //2-visualizar, 4-responder, 5-excluir, 7-feedback
		oCBoxSetor:= TGet():New( 106,153,,oGrp1,120,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cSetor",,)   
		ocBoxSetor:bSetGet := {|| cSetor := fQualArea( nSetor , "D" ) }
		oCBoxSetor:lReadOnly   := .T. 
		
		oTPID:= TGet():New( 106,280,,oGrp1,070,010,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cTipoI",,)   
		oTPID:bSetGet := {|u| cTipoI := fQualTipo(nTipo)} 
		oTPID:lReadOnly   := .T. 
		
	Endif
	//matrícula
	oSayQuem := TSay():New( 098,015,{||"Quem Sugeriu:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
	oQuemCod    := TGet():New( 106,015,,oGrp1,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA02","cMatQ",,)	
	//If nOpc <> 2 .and. nOpc <> 5
		oQuemCod:bSetGet := {|u| If(PCount()>0,cMatQ:=u,cMatQ)} 
	//Else
	If nOpc = 2 .or. nOpc= 5
		oQuemCod:Disable()
		oQuemCod:lReadOnly   := .T. 
	Endif
	
	//nome
	oQuemNome       := TGet():New( 106,052,,oGrp1,092,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cNomeQ",,)  
	oQuemNome:bSetGet := {|u| cNomeQ:= Posicione("SRA" , 1 , xFilial("SRA") + cMatQ , "RA_NOME" )}
	oQuemNome:lReadOnly   := .T. 
	
	//oSayPrev := TSay():New( 134,015,{||"Dt.Aprovação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
	//oPrevisao   := TGet():New( 142,015,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrevisao",,)
	//oPrevisao:bSetGet := {|u| If(PCount()>0,cPrevisao:=u,cPrevisao)} 
	
	oSay_Respo := TSay():New( 130,012,{||"Descrição Resolução:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,009)
	oResposta  := TMultiGet():New( 141,012,,oGrp1,161,040,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	//If nOpc <> 2 .and. nOpc <> 5
		oResposta:bSetGet := {|u| If(PCount()>0,cResposta:=u,cResposta)}
	//Else
	If nOpc = 2 .or. nOpc = 5
		oResposta:Disable()
		oResposta:lReadOnly := .T.
	Endif	
		
	oSay_datas := TSay():New( 192,012,{||"Data Conclusão:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,049,008)
	odatasoL   := TGet():New( 201,012,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDataSoL",,)
	odatasoL:bSetGet := {|u| If(PCount()>0,cDataSoL:=u,cDataSoL)}
	odatasoL:bValid := {||FdtValida(cDataSoL) } 
	
	//matrícula
	oSayAP := TSay():New( 192,082,{||"Aprovador:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
	oAPVCod:= TGet():New( 201,082,,oGrp1,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA02","cMatA",,)
	If nOpc <> 2 .and. nOpc <> 5
		oAPVCod:bSetGet := {|u| If(PCount()>0,cMatA:=u,cMatA)}
	Else
		oAPVCod:Disable()
	Endif
	
	//nome
	oAPVNome       := TGet():New( 201,122,,oGrp1,092,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cNomeA",,)  
	oAPVNome:bSetGet := {|u| cNomeA:= Posicione("SRA" , 1 , xFilial("SRA") + cMatA , "RA_NOME" )}
	oAPVNome:lReadOnly   := .T. 	
		
	oSay_fotod  := TSay():New( 125,280,{||"Foto Depois:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	If nOpc <> 2 .and. nOpc <> 5
		oFotoD      := TBitmap():New( 134,270,100,070,,"",.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )  
		oBtnFD      := TButton():New(146,215,"Carrega Foto ==>",oGrp1,{||TrazFoto( @oFotoD, "D" )},047,012,,,,.T.,,"",,,,.F. ) 
		oBtnFD:bAction := {|| MsAguarde( { || TrazFoto( @oFotoD, "D" )	 }, "Aguarde. . .", "Inserindo Foto . . ." ) }
	Else                                                                                           
		oFotoD      := TBitmap():New( 134,270,100,070,,cImagemD,.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )  
	Endif	
			
	If nOpc = 2
		oSBtn1     := SButton():New( 234,278,1,,oDlg1,,"", )
		oSBtn1:bAction := {|| oDlg1:End()} 
		
		oSBtn2     := SButton():New( 234,318,2,,oDlg1,,"", )
		oSBtn2:bAction := {|| oDlg1:End() }
	Else	
		oSBtn1     := SButton():New( 234,278,1,,oDlg1,,"", )
		oSBtn1:bAction := {|| (nOpcA := 1, VerCampos(nOpc))} 
		
		oSBtn2     := SButton():New( 234,318,2,,oDlg1,,"", )
		oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}
		PrepCampos(nOpc)
	Endif  

			
	oDlg1:Activate(,,,.T.)	


Return 

********************************
Static Function VerCampos(nOpc)
********************************

If nOpcA = 1

	If nOpc = 2
		oDlg1:End()	
	ElseIf nOpc = 3  .or. nOpc = 4 //inclusão ou alteração
		If Empty(cIdeia)
			Aviso(	cCadastro,;			
				'Por favor, descreva a Solicitação...' ,;
				{"&Continua"},,;
				"Solicitação: " + cNumID )
				//Return(Nil)
						
		ElseIf Empty(cMatQ)
			Aviso(	cCadastro,;			
					'Por favor, selecione o Funcionário que Sugeriu a Idéia ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumID )
		
		Elseif Empty(cFotoA)
			Aviso(	cCadastro,;			
					'Por favor, insira uma "Foto Antes" para esta Solicitação, Clicando no Botão "Carrega Foto" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumID )
		Elseif Empty(nSetor)
			Aviso(	cCadastro,;			
					'Por favor, Preencha o Setor Pertinente ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumID )
		Elseif Empty(nTipo)
			Aviso(	cCadastro,;			
					'Por favor, Preencha o Tipo da Idéia ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumID )					
		Else		//se estiver tudo preenchido....GRava		
	    	oDlg1:End()
	    	Grava(nOpc)	    
	  	Endif
	  	
  	Elseif nOpc = 7     //concluir
  		If Empty(cResposta)
			Aviso(	cCadastro,;			
				'Por favor, descreva a Solução para esta Idéia...' ,;
				{"&Continua"},,;
				"Solicitação: " + cNumID )
		ElseIf Empty(cDataSoL)
			Aviso(	cCadastro,;			
					'Por favor, digite a Data Conclusão ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumID )
		Elseif Empty(cFotoD)
			Aviso(	cCadastro,;			
					'Por favor, insira uma "Foto Depois" para a Conclusão, Clicando no Botão "Carrega Foto" ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumID ) 
		Elseif Empty(cMatA)
			Aviso(	cCadastro,;			
					'Por favor, selecione o Gestor que Aprovou a Idéia ...' ,;
					{"&Continua"},,;
					"Solicitação: " + cNumID )
		Else
			oDlg1:End()
			Grava(nOpc)
			
		Endif

	Endif
		
EndIf
	 

Return .T.

*****************************
Static Function TrazFoto( oFoto, cVar )
***************************** 

Local cFile   := ""
Local nPos    := 0
Local cFile2  := ""
Local cDir    := GetMv("RV_5SDIR")     


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

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ PrepCampos(nOpc)
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
************************************
Static Function PrepCampos(nOpc)
************************************

Local cImagemA:= "" 
Local cImagemD:= "" 


DbSelectArea("ZA9")
if nOpc <> 3         //Se for: 2 - visualiza , 4 - responder , 5 - exclui, 6 - altera , 7 - feedback
   
		
	   //carrega campos
	   cNumID   := ZA9->ZA9_NUMID
	   cEmissao := ZA9->ZA9_DATA
	   cIdeia   := MSMM(ZA9->ZA9_CODMMI,80)        //para carregar Z80->Z80_PROBLE
	   cResposta:= MSMM(ZA9->ZA9_CODMMS,80) 	      //Z80->Z80_RESPOS
	   cDataSoL := ZA9->ZA9_CONCLU
	   cMatQ    := ZA9->ZA9_MAT
	   cMatA    := ZA9->ZA9_QAPROV
	   nOrcam   := ZA9->ZA9_VALOR
	   
	   //If nOpc <> 4
	   	cSetor   := ZA9->ZA9_SETOR
	   	nSetor   := ZA9->ZA9_SETOR
	   	cTipoI   := ZA9->ZA9_TIPOID
	   	nTipo    := ZA9->ZA9_TIPOID
	   //Endif
	   cFotoA   := Alltrim(ZA9->ZA9_FOTOA)
	   cCaminhoA := Alltrim(ZA9->ZA9_PATHA)
	   cFotoD   := Alltrim(ZA9->ZA9_FOTOD)
	   cCaminhoD := Alltrim(ZA9->ZA9_PATHD)
	   cImagemA  := Alltrim(ZA9->ZA9_PATHA) + Alltrim(ZA9->ZA9_FOTOA)
	   cImagemD  := Alltrim(ZA9->ZA9_PATHD) + Alltrim(ZA9->ZA9_FOTOD) 	   
	   cMatA    := ZA9->ZA9_QAPROV
	   
	   oFotoA:cBMPFile:=@cImagemA
	   oFotoA:Load(cImagemA)
	   oFotoA:Refresh() 
	   
	   oFotoD:cBMPFile:=@cImagemD
	   oFotoD:Load(cImagemD)	   
	   oFotoD:Refresh()
	   
	   
	  If nOpc = 2 .or. nOpc = 5  //visualizar ou excluir

		//oNumsoL     := TGet():New( 019,050,,oGrp1,057,008,'@!',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cNumID",,)
		//oNumsoL:bSetGet := {|u| If(PCount()>0,cNumID:=u,cNumID)}
		//oNumsoL:Disable()
	
		//oSay_problem:= TSay():New( 038,015,{||"Descrição Idéia:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,009)
		//oIDEIA  := TMultiGet():New( 049,014,,oGrp1,161,040,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
		oIDEIA:Disable()
	    oIDEIA:lReadOnly  := .T.
	    
		//oEmissao   := TGet():New( 019,178,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmissao",,)
		//oEmissao:bSetGet := {|u| If(PCount()>0,cEmissao:=u,cEmissao)} 
		oEmissao:Disable()
	
		//oFotoA      := TBitmap():New( 022,270,100,070,,"",.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		//oBtnFA      := TButton():New( 045,215,"Carrega Foto ==>",oGrp1,{||TrazFoto( @oFotoA, "A" )},047,012,,,,.T.,,"",,,,.F. ) 
		//oBtnFA:Disable()
	
		//oOrcam    := TGet():New( 076,195,{|u| If(PCount()>0,nOrcam:=u,nOrcam)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nOrcam",,)
        oOrcam:Disable()
        oOrcam:lReadOnly := .T.
        		
		//oCBoxSetor     := TComboBox():New( 106,153,,aSetores,120,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSetor ) 
		//oCBoxSetor:bSetGet := {|u| If(PCount()>0,nSetor:=u,nSetor)}
		//oCBoxSetor:lReadOnly:= .T.
		
		//oTPID:= TComboBox():New( 106,280,,aTipos,070,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nTipo ) 
		//oTPID:bSetGet := {|u| If(PCount()>0,nTipo:=u,nTipo)}  
		oTPID:Disable()
		oTPID:lReadOnly:= .T.
		
		//matrícula
		oQuemCod:Disable()
		oQuemCod:lReadOnly:= .T.
	
		//nome
		//oQuemNome       := TGet():New( 106,052,,oGrp1,092,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cNomeQ",,)  
		//oQuemNome:bSetGet := {|u| cNomeQ:= Posicione("SRA" , 1 , xFilial("SRA") + cMatQ , "RA_NOME" )}
		oQuemNome:lReadOnly   := .T. 
		oQuemNome:Disable()
	
		//oSayPrev := TSay():New( 134,015,{||"Dt.Aprovação:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
		//oPrevisao   := TGet():New( 142,015,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrevisao",,)
		//oPrevisao:bSetGet := {|u| If(PCount()>0,cPrevisao:=u,cPrevisao)} 
	
		//oSay_Respo := TSay():New( 130,012,{||"Descrição Resolução:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,009)
		//oResposta  := TMultiGet():New( 141,012,,oGrp1,161,040,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
		oResposta:Disable()
		oResposta:lReadOnly:= .T.
		
		//oSay_datas := TSay():New( 192,012,{||"Data Conclusão:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,049,008)
		//odatasoL   := TGet():New( 201,012,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDataSoL",,)
		//odatasoL:bSetGet := {|u| If(PCount()>0,cDataSoL:=u,cDataSoL)}
		odatasoL:Disable()
		odatasoL:lReadOnly:= .T.
	    
		oCBoxSetor:Disable()
		//matrícula
		//oSayAP := TSay():New( 192,082,{||"Aprovador:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,008)
		//oAPVCod:= TGet():New( 201,082,,oGrp1,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA02","cMatA",,)
		oAPVCod:Disable()
		oAPVCod:lReadOnly:= .T.
		
		//nome
		//oAPVNome       := TGet():New( 201,122,,oGrp1,092,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.T.,,.F.,.F.,"","cNomeA",,)  
		//oAPVNome:bSetGet := {|u| cNomeA:= Posicione("SRA" , 1 , xFilial("SRA") + cMatA , "RA_NOME" )}  
		oAPVNome:Disable()
		oAPVNome:lReadOnly   := .T. 
			
		//oFotoA:lReadOnly:= .T.
		//oBtnFA:Disable()   
		
		//oFotoD:lReadOnly:= .T. 		
		//oBtnFD:Disable()
				
	  Elseif nOpc = 4 //alterar
	  
		oEmissao:Disable()       //EMISSÃO
		oQuemNome:lReadOnly   := .T.      //NOME QUEM DEU IDÉIA
		oQuemNome:Disable()
		oAPVNome:Disable()          //NOME DE QUEM APROVOU IDÉIA
		oAPVNome:lReadOnly   := .T. 
				
	  Elseif nOpc = 7 //concluir  
	 
		oIDEIA:Disable()
	  	oEmissao:Disable()
		oBtnFA:Disable()	
        oOrcam:Disable()
        oOrcam:lReadOnly := .T.		
		oTPID:Disable()
		oTPID:lReadOnly:= .T.		
		oQuemCod:Disable()
		oQuemCod:lReadOnly:= .T.	
		oQuemNome:lReadOnly   := .T. 
		oQuemNome:Disable()	
		//oResposta:Disable()
		//oResposta:lReadOnly:= .T.
		//odatasoL:Disable()
		//odatasoL:lReadOnly:= .T.	    
		oCBoxSetor:Disable()	
		oAPVCod:Disable()
		oAPVCod:lReadOnly:= .T.		
		oAPVNome:Disable()
		oAPVNome:lReadOnly   := .T. 		
		oFotoA:lReadOnly:= .T.
		oBtnFA:Disable()   
		
		//oFotoD:lReadOnly:= .T. 		
		//oBtnFD:Disable()
	  Endif
  
endif // FR do nOpc <> 3


Return

	

*******************************
Static Function Grava(nOpc)    
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
//Local cCaminhoA  := ""
//Local cCaminhoD  := ""

If nOpc = 5         //excluir
	Reclock("ZA9",.F.)
	dbDelete()
	MsUnlock()
	
	DbselectArea("ZA9")
	Dbsetorder(1)
	If ZA9->( DbSeek( xFilial( "ZA9" ) + cNumID ) ) 
		While !ZA9->(EOF()) .AND. ZA9->ZA9_FILIAL == xFilial("ZA9") .And. Alltrim(ZA9->ZA9_NUMID) == Alltrim(cNumID)
			Reclock("ZA9",.F.)
			dbDelete()
			ZA9->(MsUnlock())
			ZA9->(Dbskip())
		Enddo
	Endif
	
	DbselectArea("Z14")    //cadastro de avaliação de mão de obra - excluir de lá também
	Dbsetorder(1)
	If Z14->( DbSeek( xFilial( "Z14" ) + cMatQ + Dtos(cEmissao)) ) 
		//While !Z14->(EOF()) .AND. Z14->Z14_FILIAL == xFilial("Z14") .And. Alltrim(Z14->Z14_MAT) == Alltrim(cMatQ)
		If Z14->Z14_QTIDAP = 1
			Reclock("Z14",.F.)
			dbDelete()
			Z14->(MsUnlock())
			//Z14->(Dbskip())
		//Enddo
		Endif
	Endif
	
	
Elseif nOpc = 3  .or. nOpc = 4  //incluir ou alterar
	
 	
	DbselectArea("ZA9")
	If nOpc = 3 
		DbselectArea("ZA9")
		Dbsetorder(1)
		If ZA9->( DbSeek( xFilial( "ZA9" ) + cNumID ) )	
			while ZA9->( DbSeek( xFilial( "ZA9" ) + cNumID ) )
			   ConfirmSX8()
			   cNumID := GetSxeNum("ZA9","ZA9_NUMID")
			enddo
		Endif
	
		RecLock("ZA9",.T.) 
		//ZA9->ZA9_FILIAL := xFilial()
		ZA9->ZA9_NUMID := cNumID 
		ZA9->ZA9_DATA  := cEmissao 	
	Elseif nOpc = 4
		RecLock("ZA9",.F.)
	Endif
	
	//---primeira parte da idéia: emissão, número siga, tipo, setor, matrícula de quem deu idéia, valor, foto antes
	ZA9->ZA9_TIPOID:= Substr(nTipo ,1,1)
    ZA9->ZA9_SETOR := Substr(nSetor,1,6)
    ZA9->ZA9_MAT   := cMatQ
    ZA9->ZA9_VALOR := nOrcam 
    
    If nOpc = 3
	    If !Empty(cFotoA)
		    cpath := cFotoA		//caminho junto com o nome do arquivo
		    cCaminhoA := cpath //para envio por email
		    nPos := RAT( '\', cpath ) 
			cFotoA := Substr( cpath, nPos + 1 , (Len(cpath) - 1) )
		    ZA9->ZA9_PATHA  := Substr(cpath,1,nPos)  //grava o caminho do arquivo (sem o nome do arquivo)
		    ZA9->ZA9_FOTOA := cFotoA
    	Endif
    Elseif nOpc = 4
    	nPos := 0
    	cpath := cFotoA		
	    nPos := RAT( '\', cpath ) 
	    If nPos > 0
	    	cCaminhoA := cpath //para envio por email
	    	cFotoA := Substr( cpath, nPos + 1 , (Len(cpath) - 1) )
	    	ZA9->ZA9_PATHA  := Substr(cpath,1,nPos)  //grava o caminho do arquivo (sem o nome do arquivo)
		    ZA9->ZA9_FOTOA := cFotoA         
	    //Else
		//    ZA9->ZA9_PATHA  := cCaminhoA
		//    ZA9->ZA9_FOTOA := cFotoA
		Endif
    Endif
    
    //--segunda parte: resolução da idéia , gestor aprovador idéia, foto depois, data conclusão
    ZA9->ZA9_CONCLU:= cDataSoL
    ZA9->ZA9_QAPROV:= cMatA
    If !Empty(cFotoD)
    	nPos := 0
	    cpath := cFotoD		//caminho junto com o nome do arquivo
	    nPos := RAT( '\', cpath )
	    If nPos > 0 
	    	cCaminhoD := cpath
			cFotoD := Substr( cpath, nPos + 1 , (Len(cpath) - 1) )
	    	ZA9->ZA9_PATHD  := Substr(cpath,1,nPos)  //grava o caminho do arquivo (sem o nome do arquivo)
	    	ZA9->ZA9_FOTOD := cFotoD
	  	Endif
    Endif
    ZA9->(MsUnlock())
    
    If !Empty(cIdeia)		// Inclusao
		MSMM( , TamSx3("ZA9_DESCID")[1],,upper(alltrim(cIdeia)),1,,,"ZA9","ZA9_CODMMI")  //DESCRIÇÃO DA IDÉIA
	Endif
	
	If !Empty(cResposta)		// Inclusao
		MSMM( , TamSx3("ZA9_RESID")[1],,upper(alltrim(cResposta)),1,,,"ZA9","ZA9_CODMMS")  //DESCRIÇÃO DA RESPOSTA
	Endif
	
	////FR - 20/05/14 - GRAVA INFORMAÇÕES NA TABELA DE AVALIAÇÃO M.O. (MÃO DE OBRA)
	///Z14
	dbSelectArea("Z14")
	If nOpc = 3
		RecLock("Z14",.T.) 
		//Z14->Z14_FILIAL := compartilhado, não precisa gravar filial
		Z14->Z14_MAT := cMatQ
		Z14->Z14_QTIDAP := 1 //GRAVA a idéia deste DATA, PARA MAIS TARDE FAREMOS UM SOMATÓRIO DE TODOS OS REGISTROS
		Z14->Z14_DTMOV  := dDatabase
		Z14->(MsUnlock())
		///fim gravação da Z14
		//U_IDEnvio( cMatQ, cpath, cFotoA, nOpc ) //envia email aos envolvidos , inclusão da idéia
		Msginfo("Dados gravados com Sucesso !!")
		MsAguarde( { || IDEnvio( cMatQ , cCaminhoA , cFotoA , cCaminhoD, cFotoD, nOpc )	 }, "Aguarde. . .", "Enviando E-Mail . . ." )
		
	Elseif nOpc = 4		
		DbselectArea("Z14")
		Dbsetorder(1)
		If Z14->( DbSeek( xFilial( "Z14" ) + cMatQ + Dtos(cEmissao)) )		
			If Z14->Z14_QTIDAP = 1
				Reclock("Z14",.F.)
				dbDelete()         ///exclui primeiro....
				Z14->(MsUnlock())			
			Endif
		Endif
			RecLock("Z14",.T.)
			//Z14->Z14_FILIAL := compartilhado, não precisa gravar filial
			Z14->Z14_MAT := cMatQ
			Z14->Z14_QTIDAP := 1 
			//depois, grava um registro novo, pois, vai que o usuário altera a matrícula, então é melhor excluir o antigo e incluir o novo
			Z14->Z14_DTMOV  := dDatabase
			Z14->(MsUnlock())
			///fim gravação da Z14
			
			//U_IDEnvio( cMatQ, cpath, cFotoA, nOpc ) //envia email aos envolvidos , alteração da idéia
			msginfo("Alteração Efetuada com Sucesso !!")
			MsAguarde( { || IDEnvio( cMatQ , cCaminhoA , cFotoA , cCaminhoD, cFotoD, nOpc )	 }, "Aguarde. . .", "Enviando E-Mail . . ." )	
	Endif 
	
	
	
	
Elseif nOpc = 7 //concluir

	DbselectArea("ZA9")
	RecLock("ZA9",.F.) 
    
    //--segunda parte: resolução da idéia , gestor aprovador idéia, foto depois, data conclusão
    ZA9->ZA9_CONCLU:= cDataSoL
    ZA9->ZA9_QAPROV:= cMatA
    If !Empty(cFotoD)
	    cpath := cFotoD		//caminho junto com o nome do arquivo
	    cCaminhoD := cpath
	    nPos := RAT( '\', cpath ) 
		cFotoD := Substr( cpath, nPos + 1 , (Len(cpath) - 1) )
	    ZA9->ZA9_PATHD  := Substr(cpath,1,nPos)  //grava o caminho do arquivo (sem o nome do arquivo)
	    ZA9->ZA9_FOTOD := cFotoD
    Endif
    ZA9->(MsUnlock())
    
	If !Empty(cResposta)		// Inclusao
		MSMM( , TamSx3("ZA9_RESID")[1],,upper(alltrim(cResposta)),1,,,"ZA9","ZA9_CODMMS")  //DESCRIÇÃO DA RESPOSTA
	Endif
	
	Msginfo("Idéia Concluída com Sucesso !!")
	MsAguarde( { || IDEnvio( cMatQ , cCaminhoA , cFotoA , cCaminhoD, cFotoD, nOpc )	 }, "Aguarde. . .", "Enviando E-Mail . . ." )
		
Endif

Return
		
		
******************************************************************************************************
User Function IDLeg()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERDE",	"Idéia em Aberto"} ,;
									{"BR_VERMELHO" ,"Idéia Concluída"} } )

Return .T.		


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
		cNomeAre := SX5->X5_DESCSPA
	Endif 
Endif

Return(cNomeAre) 

*********************************
Static Function fQualTipo(cTipo)
*********************************

Local nPos:= 0
Local cDesc := ""
Local x     := 0

For x :=1 to Len(aTipos)
	If substr(aTipos[x] ,1,1) == cTipo
		nPos := x
	Endif    
Next
//nPos := Ascan( aTipos , cTipo)
//nP := Ascan( aDistrato, { |aVal| aVal[1]==Substr(cCC,1,6) } )
//nPos := Ascan(aTipos , { |aTipos| Substr(aTipos[1],1,1) == cTipo } )

cDesc := aTipos[nPos]

Return(cDesc)

///ENVIO DA SOLICITAÇÃO POR EMAIL
********************************
Static Function IDEnvio( cMatQ , cCaminhoA , cFotoA , cCaminhoD, cFotoD, nOpc )
********************************                                                                          

Local cNomeUser := ""
Local cMailUser := ""
Local cDeptoUser:= ""
Local aUsu      := {}
Local cUsu      := ""
Local cMailGestor := ""
Local cNomeGestor := ""
Local cNomeQuem   := "" 
Local cMsg        := ""
Local cMailTo     := ""
Local lCopiou     := .F.


SetPrvt("OHTML,OPROCESS")

///CAPTURA O EMAIL DO USUÁRIO LOGADO
PswOrder(1)
If PswSeek( __CUSERID , .T. )  
   aUsu   := PSWRET() 				
   cUsu   := Alltrim( aUsu[1][2] )  
   cNomeUser:= Alltrim( aUsu[1][4] )  
   cMailUser:= Alltrim( aUsu[1][14] )
   cDeptoUser:= Alltrim( aUsu[1][12] )
Endif


//CAPTURA OS EMAILS DOS ENVOLVIDOS
SRA->(Dbsetorder(1))
If SRA->(Dbseek(xFilial("SRA") + cMatQ ))
	cEmailQ := SRA->RA_EMAIL //email do responsável pela ação
   	cNomeQuem  := SRA->RA_NOME    //nome completo	
Endif
	
//pesquisa o gestor
SRA->(Dbsetorder(1))
If SRA->(Dbseek(xFilial("SRA") + cMatA ))
	cMailGestor:= SRA->RA_EMAIL //email do responsável pela ação
   	cNomeGestor:= SRA->RA_NOME    //nome completo	
Endif
	

//cMail5S := GetMV("RV_EQP5S")  //email da equipe 5S 
cMail5S := ""
//If nOpc = 4 .or. nOpc = 7 //responder ou feedback
	cMailTo := cMail5S + ";" + cMailUser + ";" + cEmailQ + ";" + cMailGestor  
	//         eq.5S        usuário logado,   quem deu a idéia,  Aprovador
//Else
//	cMailTo += cEmailUsr + ";" + cEmailResp + ";" + cMailGestor //FR - 09/11/13 - Aline solicitou retirar o email dela quando for aviso de inclusão
//Endif   


// Inicialize a classe de processo:
oProcess:=TWFProcess():New("5S","5S")

// Crie uma nova tarefa, informando o html template a ser utilizado: 

	If nOpc = 3 .or. nOpc = 4             //incluir ou alterar
		oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S_IDEIAENVIO.html")

	Elseif nOpc = 7                     //concluir
		oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S_IDEIACONCLU.html")
	Endif

	oHtml   := oProcess:oHtml	
	oHtml:ValByName("cNUMID", cNumID )
	oHtml:ValByName("cFUNC", cMatQ + '-' + cNomeQuem )
	oHtml:ValByName("cDESC",  cIdeia )
	
	oHtml:ValByName("cUser", cNomeUser )  //usuário logado que digitou as informações	
	oHtml:ValByName("cDepto", cDeptoUser )  //usuário logado que digitou as informações	
	oHtml:ValByName("cMail", cMailUser )  //usuário logado que digitou as informações	
	oHtml:ValByName("dDATA" , cEmissao ) 	
	oHtml:ValByName("cTIPOID" , Substr(nTipo,3, (Len(nTipo)-2) ) ) 	
	oHtml:ValByName("cMONEY" , iif(nOrcam > 0 , "Sim ->" + Transform( nOrcam , "@E 999,999,999.99"), "Nao") ) 	
	oHtml:ValByName("cGESTOR" , cNomeGestor ) 	
	oHtml:ValByName("cSETOR" , Substr(nSetor,8,30) ) 
	

	
	If nOpc = 3    //incluir
		cMsg := "Segue Abaixo, Uma Nova Idéia Sugerida pelo Colaborador abaixo, Incluída no Programa de Idéias - 5S.<br>" 		
	Elseif nOpc = 4	  //alterar
		cMsg := "A Idéia Sugerida pelo Colaborador abaixo, foi Alterada, conforme Segue:<br>" 		
	Elseif nOpc = 7   //concluir
		cMsg := "A Idéia Sugerida pelo Colaborador abaixo, foi Implementada e Concluída, conforme Segue:<br>" 		
		oHtml:ValByName("cCONCLU", cResposta )  
		oHtml:ValByName("dCONCLU", cDataSol )  
	Endif 
	cMsg +=  '<br>' + CHR(13) + CHR(10)
	cMsg += "Arquivo do Processo em Anexo"

oHtml:ValByName("cMsg", cMsg )
//COPIA ANTES PARA A PASTA \IMAGENS
If nOpc = 3 .or. nOpc = 4  //incluir ou alterar, envia só a foto Antes
	MsAguarde( { || lCopiou := CpyT2S( Alltrim(cCaminhoA) , "\IMAGENS", .T. ) }, "Aguarde. . .", "Anexando Foto ao E-Mail . . ." )
	oProcess:AttachFile( "\IMAGENS\" + Alltrim(cFotoA) )     
ElseIf nOpc = 7
	MsAguarde( { || lCopiou := CpyT2S( Alltrim(cCaminhoD) , "\IMAGENS", .T. ) }, "Aguarde. . .", "Anexando Foto ao E-Mail . . ." )
	oProcess:AttachFile( "\IMAGENS\" + Alltrim(cFotoD) )    
Endif
//anexa a foto do processo, somente funciona se a imagem estiver numa pasta abaixo de PROTHEUS_DATA
//oProcess:AttachFile(alltrim("SERVIDOR\5S\TAB_GUT.PDF") )  //anexa a tabela Gut para referência 
//PARÂMETRO: MV_WFIMAGE habilita anexar imagens ao email (tem q estar .F.)


//DEPOIS DE ANEXAR, APAGA O ARQUIVO DA PASTA \IMAGENS:
//FErase ( < cArquivo> ) --> nRet



   
//cMailTo += ";flavia.rocha@ravaembalagens.com.br" //retirar

oProcess:cTo	:= cMailTo //(EQUIPE 5S, USUÁRIO LOGADO, RESPONSÁVEIS)
oProcess:cCC    := ""
If nOpc = 3
	oProcess:cSubject := "Uma Nova Idéia para o Programa 5S - " + Alltrim(cNumID)
Elseif nOpc = 4
	oProcess:cSubject := "<Alteração> Idéia para o Programa 5S - " + Alltrim(cNumID)
Elseif nOpc = 7
	oProcess:cSubject := "Idéia Implementada - Programa 5S - " + Alltrim(cNumID) 
Endif
oProcess:Start()  //SE O PARÂMETRO MV_WFENVJA estiver ativado, assim que passar ler esta linha de comando, já envia o email
                  //sem precisar do comando WFSENDMAIL() - desativei o parâmetro porque estava chegando 2 emails.
WfSendMail()
MsgInfo("Email enviado com Sucesso !")

Return
		






