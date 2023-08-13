#INCLUDE "TMKXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TMKDEF.CH"
#INCLUDE "COLOR.CH"

/*
ACOLS DA ROTINA DE TELEMARKETING
	1  - Assunto
	2  - Descricao do assunto
	3  - Produto
	4  - Descricao do produto
	5  - Ocorrencia
	6  - Descricao da ocorrencia
	7  - Codigo do Operador
	8  - Nome do Operador
	9  - Data da Acao
	10 - Acao
	11 - Descricao da Acao
	12 - Observacao

*/

**************************************
User Function TMKC012(cContato) 
**************************************
//IrА atualizar o campo UC_ENTIDAD - EX: "SA1"

Local aArea     := GetArea()		 				//Salva a area atual
Local aChave    := TkEntEstru()		 				//Array de estrutura da chave para demonstracao
Local aCont     := {}				 				//Array com os contatos
Local nOpcao    := 0		  						//Opcao de resposta
Local nPos		:= 0								//Posicao escolhida no array                   
Local nPosEnt   := 0			 					//Posicao da entidade dentro doa array de estrutura
Local oLbx											//Listbox
Local oDlg							 				//Tela	
Local cEnt     	:= Space(3)			 				//Alias da Entidade
Local cCodEnt  	:= Space(25)						//Codigo da Entidade	
Local cEntidade := ""				 	   			//Alias : SA1
Local cDescInd 	:= Space(40)		 				//Indice: Codigo + Loja
Local cChave    := ""				 				//Codigo: 00000101
Local cDescChave:= ""				 				//Descr : Empresa X Ltda.
Local cDescEnt 	:= Space(40)		 				//Nome  : Cadastro de Clientes
Local cDescCod 	:= Space(40)						//Nome da Empresa de acordo com a entidade         
Local cEntChave := ""    			  				//Chave da entidade para exibicao no browse
Local lShowBtn 	:= .T.				 				//Flag para exibir ou nao o botao de CANCELA e INCLUIR
Local nPosBtn	:= 225				 				//Posicao do botao de OK
Local aAreaSA1	:= {}			   					//Area do SA1
Local cStatusA1	:= ""								//Status do cliente (bloqueado ou nao)
Local nTamCon	:= TamSx3('UC_CODCONT')[1]			//Tamanho do campo UC_CODCONT  
Local lTk271Aut:= .F.

//зддддддддддддддддддддддддддддддддддддд©
//ЁSe a funcao foi executada por gatilhoЁ
//юддддддддддддддддддддддддддддддддддддды
If TkSetTrigger()

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁA funcao e recurssiva se o parametro estiver preenchido mantem o valorЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cContato:= IIf(ValType(cContato) == "C" ,cContato,"")
	
	DbSelectArea("AC8")
	DbSetOrder(1)
	If ! DbSeek(xFilial("AC8") + cContato)
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁNao existe relacionamentos para o CONTATO entao executa a inclusao das entidades.Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		nOpcao := TkInsertEnt(cContato,@aCont,@oLbx)
		If nOpcao == 1
			// Se o operador ja elencou uma entidade para esse contato
			lShowBtn := .F.
			nPosBtn  := 285	
		Endif	
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁCarrega todos as ENTIDADES relacionadas do CONTATO escolhidoЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("AC8")
	DbSetOrder(1)
	If DbSeek(xFilial("AC8") + cContato , .T.)
		If nOpcao == 1
			aCont := {}
		Endif
			
		While !Eof() .AND. (xFilial("AC8") == AC8->AC8_FILIAL) .AND. (cContato == AC8->AC8_CODCON)

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁBusca a estrutura de chaves das entidades                   Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
            nPosEnt := Ascan( aChave, { |x| x[1] == ALLTRIM(AC8->AC8_ENTIDA) })
            
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁCaso encontrou utiliza para demonstrar no browse            Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
            If nPosEnt > 0
				cEntChave := Substr(AC8->AC8_CODENT,1,aChave[nPosEnt][2])

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁCaso exista filial/loja exibe concatenando com o codigo     Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If aChave[nPosEnt][3] > 0
					cEntChave += "-" + Substr(AC8->AC8_CODENT,aChave[nPosEnt][2]+1,aChave[nPosEnt][3])
				Endif   
			Else	                                                    
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁCaso nao encontrou utiliza diretamente o campo AC8_CODENT   Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cEntChave := ALLTRIM(AC8->AC8_CODENT)
			Endif		
	
			cEnt    := ALLTRIM(AC8->AC8_ENTIDA)         						//Alias : SA1
			cDescEnt:= Posicione("SX2",1,cEnt,"X2NOME()")			  			//Nome  : Cadastro de Clientes
			
			//MsgAlert("cDescEnt: ->" + cDescEnt )
			
			cCodEnt := ALLTRIM(AC8->AC8_CODENT)									//Codigo: 00000101
			cDescCod:= TkEntidade(cEnt,cCodEnt,1)								//Descr : Empresa X Ltda.
			cDescInd:= ALLTRIM(Posicione("SIX",1,cEnt + "1","SIXDescricao()"))  //Indice: Codigo + Loja
			
			//зддддддддддддддддддддддддддддддддддд©
			//ЁVerifica se ha bloqueio na entidadeЁ
			//юддддддддддддддддддддддддддддддддддды
			If cEnt = "SA1"
				If TmkBlqCont(cEnt,xFilial("SA1")+cCodEnt)
					AC8->(DbSkip())
					Loop
				EndIf
			ElseIF cEnt = "SA4"
				If TmkBlqCont(cEnt,xFilial("SA4")+cCodEnt)
					AC8->(DbSkip())
					Loop
				EndIf
			Endif
			
			Aadd(aCont,{	cEnt,;			// 1 - Alias : SA1   / SA4
						 	cDescInd,;		// 2 - Indice: Codigo + Loja / Codigo
							cCodEnt,;		// 3 - Codigo: 00000101 / Codigo da transp
							cDescEnt,;		// 4 - Nome  : Cadastro de Clientes  / Cadastro de Transportadoras
						 	cDescCod,;		// 5 - Descr : Empresa X Ltda.
						 	cEntChave})		// 6 - Chave para demonstracao no browse		
	
			DbSelectArea("AC8")
			DbSkip()
		End
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁSe existe relacionamento para esse CONTATO mostra as EntidadesЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	If Len(aCont) > 0
	
		//здддддддддддддддддддддддддддддддддддддддддд©
		//ЁSe nao estiver usando a entrada automaticaЁ
		//юдддддддддддддддддддддддддддддддддддддддддды
		//If !( Type("lTk271Auto") <> "U" .AND. lTk271Auto )
		If lTk271Aut
			DEFINE MSDIALOG oDlg FROM  300,20 TO 560,650 TITLE STR0002  PIXEL //"Relacionamento Contatos X Entidades"
				
				@01,03 TO 110,315 LABEL "" OF oDlg  PIXEL
				@05,05 LISTBOX oLbx FIELDS HEADER ;
						STR0003,;	//"Entidade" 
						"Codigo",;	//"Codigo" 						
						STR0006;	//"Descricao"
						SIZE 307,103 NOSCROLL OF oDlg PIXEL; 
					 	ON DBLCLICK(nOpcao :=1 , nPos := oLbx:nAt ,oDlg:End()) 
				oLbx:SetArray(aCont)
				oLbx:bLine:={||{aCont[oLbx:nAt,4],;
								aCont[oLbx:nAt,6],;								
								aCont[oLbx:nAt,5] }}
									
				oLbx:nAt := 1       	
				DEFINE SBUTTON FROM 115,nPosBtn TYPE 1	ENABLE OF oDlg ACTION (nOpcao:=1, nPos:=oLbx:nAt, oDlg:End())  	//OK
		
				If lShowBtn
					DEFINE SBUTTON FROM 115,255 TYPE 2 	ENABLE OF oDlg ACTION (nOpcao:=0,oDlg:End())                //CANCELA
					DEFINE SBUTTON FROM 115,285 TYPE 4 	ENABLE OF oDlg ACTION TkInsertEnt(cContato,@aCont,@oLbx)    //INCLUI
				Endif	
				
			ACTIVATE MSDIALOG oDlg CENTER
			
			//здддддддддддддддддддддддддддддддддддддддддд©
			//ЁAtiva o cronometro da tela 10- 10 SegundosЁ
			//юдддддддддддддддддддддддддддддддддддддддддды
			cTimeIni := Time()
			oTimerCro:Activate()
		
		Else
			nOpcao:=1
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁPesquisa no array aCont qual e a posicao do contato passado no  Ё
			//Ёarray aAutoCab (entrada automatica) 		                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			//nPos:= Ascan(aCont,{|x| x[1]+x[3] == aAutoCab[ProcTmk("UC_ENTIDAD"),2] + ALLTRIM(aAutoCab[ProcTmk("UC_CHAVE"),2]) })
			nPos:= Ascan(aCont,{|x| x[1]+x[3] == "UC_ENTIDAD" + "UC_CHAVE"  })
		Endif
		
		If nOpcao = 1 //.AND. nPos > 0
		
			For fr:= 1 to Len(aCont)
				cEntidade	:= aCont[fr,1]	// 1 - Alias : SA1
				cDescInd    := aCont[fr,2]	// 2 - Indice: Codigo + Loja
				cChave      := aCont[fr,3]	// 3 - Codigo: 00000101
				cDescEnt	:= aCont[fr,4]	// 4 - Nome  : Cadastro de Clientes
				cDescChave  := aCont[fr,5]	// 5 - Descr : Empresa X Ltda.
			Next
			
			If cEntidade == "SUS"
				lProspect := .T.
			Else
				lProspect := .F.
			Endif							
		
			TkCliente(cEntidade,cChave)
	
			//MsgAlert("cEntidade-> " + cEntidade )
			M->UC_ENTIDAD:= cEntidade
			M->UC_DESCENT:= cDescEnt       //Cadastro de Fornecedores			
			M->UC_DESCIND:= cDescInd       //Codigo + Loja
			M->UC_CHAVE  := cChave         //00000101
			M->UC_DESCCHA:= cDescChave 	   //Empresa X Ltda.
			If inclui
				M->UC_OBS    := U_fGetOBSU6()
			Else 
				M->UC_OBS	 := MSMM(SUC->UC_CODOBS)
			Endif
		Endif
	Else	
		//здддддддддддддддддддддддддддддддддддд©
		//ЁNenhuma entidade encontrada:        Ё
		//ЁLimpa os campos e notifica o usuarioЁ
		//юдддддддддддддддддддддддддддддддддддды
		Help(" ",1,"TK061NAC8")
		M->UC_CODCONT	:= Space(nTamCon)
		M->UC_DESCNT	:= ""
		M->UC_ENTIDAD	:= ""
		M->UC_DESCENT	:= ""
		M->UC_DESCIND	:= ""
		M->UC_CHAVE  	:= ""
		M->UC_DESCCHA	:= ""
	Endif

Else
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAtualiza a variavel de memoria caso contrario o retorno da funcao vai limpar a variavelЁ
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !Empty(M->UC_ENTIDAD) 
		cEntidade := M->UC_ENTIDAD
	Endif	

Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁAtiva novamente o flag de gatiho para TRUE - Dessa forma sera executado na proxima alteracao do campoЁ
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
TkSetTrigger(.T.)
	
RestArea(aArea)
	
Return(cEntidade) 

