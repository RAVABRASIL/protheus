#Include "Rwmake.ch"

/*
-----------------------------------------------------------------------------------------------
Programa: MT110APV - Ponto de Entrada MT110APV � executado no in�cio da fun��o A110Aprov 
Indica se a rotina de aprova��o pode ser executada.
Autoria : Fl�via Rocha
Data    : 09/10/13
Solicitado por: Orley
Objetivo      : Impedir que SCs n�o pr�-analisadas pelo Gerente de Manuten��o, 
                sejam de fato aprovadas pela Diretoria
-----------------------------------------------------------------------------------------------                
*/

**********************
User Function MT110APV
**********************  


/*
cAlias			Caracter			Alias da tabela que est� posicionada						X				
Reg			Array of Record			Registro da tabela que est� posicionada						X

Retorno:
    lRet(logico)
    .T. = Executa rotina de aprova��o.F. = N�o executa rotina de aprova��o


*/

Local cParam1:=ParamIxb[1] //guarda o Alias
Local nReg:=ParamIxb[2] //guarda o Recno
Local lRet:=.F.
Local cMsg      := ""
Local lPreOk    := .F. 
Local lPre		:= .F.
Local cMsg      := "" 
Local cMsgMail  := "" 
Local eEmail    := ""
Local subj      := ""
Local cRespManut:= GetMv("RV_110BLO1")  //Codigo usu�rio respons�vel pela Manuten��o -> 000008 - JORGE     
Local aUsu      := {}

//FR - 29/08/13 - Implementei flag de pr�-aprova��o , quando os produtos da SC forem destinados � Manuten��o
//Tipos Produtos = MH e MQ
SC1->(DbGoto(nReg))	
lPreOK := iif(Alltrim(SC1->C1_PREOK) = "S" , .T. , .F.) //pr�-aprovado ?  
 
If Empty(SC1->C1_PREAPRO)   //N�O precisa Pr�-Aprova��o (o campo C1_PREAPRO fica VAZIO )
	lRet	:= .T.  //PROSSEGUE COM A APROVA��O
	
Else  //precisa pr�-aprova��o campo C1_PREAPRO = *
	cMsg := "Gerente de Manuten��o Ainda N�o Pr�-Aprovou Esta SC. " + CHR(13) + CHR(10) + "Deseja Aprovar Mesmo Assim ?"
	If !lPreOk   //se n�o foi pre-aprovada?                         
			cMsg := cMsg
			If MsgYesNo( cMsg , "PR�-APROVA��O - MANUTEN��O") //se aceitar aprovar mesmo assim, segue o fluxo, sem pr�-aprova��o do Ger. Manuten��o
				lRet := .T.
				If RecLock("SC1", .F.)
					SC1->C1_PREOK := "D"       //APROVADO PELA DIRETORIA
					SC1->C1_NOMEPRE := Substr(cUsuario,7,15)
					SC1->C1_PREJUST := "PRE-APROVADO PELA DIRETORIA"
					SC1->(MsUnlock())
				Endif   //lret
				
			Else
				
				lRet := .F.
				//Caso Diretoria (Orley) n�o aprove mesmo assim, envia e-mail para Jorge Pr�-Aprovar
				//captura o email do usu�rio logado:
				PswOrder(1)
				If PswSeek( __cUserId, .T. )
				   aUsu := PSWRET() 						// Retorna vetor com informa��es do usu�rio				   
				   eEmail := Alltrim( aUsu[1][14] )                                                 
				Endif
				
				//captura o email do cRespManut
				PswOrder(1)
				If PswSeek( cRespManut, .T. )
				   aUsu := PSWRET() 						// Retorna vetor com informa��es do usu�rio				  
				   eEmail += ";" + Alltrim( aUsu[1][14] )                                                 
				Endif
				
				subj    := "Solicita��o Pr�-Aprova��o de SC: " + SC1->C1_NUM + CHR(13) + CHR(10) //assunto 
				cMsgMail:= "Prezado(a) Gerente Manuten��o, " //+ eEmail + CHR(13) + CHR(10)
				cMsgMail+= "Foi Requerida Pr�-Aprova��o da SC: " + SC1->C1_NUM + ", Pela Diretoria" + CHR(13) + CHR(10)+ CHR(13) + CHR(10)
                cMsgMail+= "Por Favor, Acesse M�dulo: Compras -> Atualiza��es -> Solicita��es de Compra -> A��es Relacionadas: Pr�-Aprova��o."+ CHR(13) + CHR(10)
                cMsgMail+= "Qualquer D�vida, Favor entrar em contato com Depto. TI "
								
				//eEmail := "" //retirar
				//eEmail += ";flavia.rocha@ravaembalagens.com.br" //retirar depois				
				U_SendFatr11(eEmail, "", subj, cMsgMail, "" )
				
				alert("Um E-mail Foi Enviado ao Gerente de Manuten��o") //retirar
			Endif //msg yes no	
		
		
	Else  //se j� foi pr�-aprovado...
		lRet	:= .T. //prossegue com a aprova��o				
	Endif //lPreOK

Endif     //precisa pr�-aprova��o?


Return lRet