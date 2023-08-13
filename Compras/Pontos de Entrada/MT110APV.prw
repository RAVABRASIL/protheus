#Include "Rwmake.ch"

/*
-----------------------------------------------------------------------------------------------
Programa: MT110APV - Ponto de Entrada MT110APV é executado no início da função A110Aprov 
Indica se a rotina de aprovação pode ser executada.
Autoria : Flávia Rocha
Data    : 09/10/13
Solicitado por: Orley
Objetivo      : Impedir que SCs não pré-analisadas pelo Gerente de Manutenção, 
                sejam de fato aprovadas pela Diretoria
-----------------------------------------------------------------------------------------------                
*/

**********************
User Function MT110APV
**********************  


/*
cAlias			Caracter			Alias da tabela que está posicionada						X				
Reg			Array of Record			Registro da tabela que está posicionada						X

Retorno:
    lRet(logico)
    .T. = Executa rotina de aprovação.F. = Não executa rotina de aprovação


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
Local cRespManut:= GetMv("RV_110BLO1")  //Codigo usuário responsável pela Manutenção -> 000008 - JORGE     
Local aUsu      := {}

//FR - 29/08/13 - Implementei flag de pré-aprovação , quando os produtos da SC forem destinados à Manutenção
//Tipos Produtos = MH e MQ
SC1->(DbGoto(nReg))	
lPreOK := iif(Alltrim(SC1->C1_PREOK) = "S" , .T. , .F.) //pré-aprovado ?  
 
If Empty(SC1->C1_PREAPRO)   //NÃO precisa Pré-Aprovação (o campo C1_PREAPRO fica VAZIO )
	lRet	:= .T.  //PROSSEGUE COM A APROVAÇÃO
	
Else  //precisa pré-aprovação campo C1_PREAPRO = *
	cMsg := "Gerente de Manutenção Ainda Não Pré-Aprovou Esta SC. " + CHR(13) + CHR(10) + "Deseja Aprovar Mesmo Assim ?"
	If !lPreOk   //se não foi pre-aprovada?                         
			cMsg := cMsg
			If MsgYesNo( cMsg , "PRÉ-APROVAÇÃO - MANUTENÇÃO") //se aceitar aprovar mesmo assim, segue o fluxo, sem pré-aprovação do Ger. Manutenção
				lRet := .T.
				If RecLock("SC1", .F.)
					SC1->C1_PREOK := "D"       //APROVADO PELA DIRETORIA
					SC1->C1_NOMEPRE := Substr(cUsuario,7,15)
					SC1->C1_PREJUST := "PRE-APROVADO PELA DIRETORIA"
					SC1->(MsUnlock())
				Endif   //lret
				
			Else
				
				lRet := .F.
				//Caso Diretoria (Orley) não aprove mesmo assim, envia e-mail para Jorge Pré-Aprovar
				//captura o email do usuário logado:
				PswOrder(1)
				If PswSeek( __cUserId, .T. )
				   aUsu := PSWRET() 						// Retorna vetor com informações do usuário				   
				   eEmail := Alltrim( aUsu[1][14] )                                                 
				Endif
				
				//captura o email do cRespManut
				PswOrder(1)
				If PswSeek( cRespManut, .T. )
				   aUsu := PSWRET() 						// Retorna vetor com informações do usuário				  
				   eEmail += ";" + Alltrim( aUsu[1][14] )                                                 
				Endif
				
				subj    := "Solicitação Pré-Aprovação de SC: " + SC1->C1_NUM + CHR(13) + CHR(10) //assunto 
				cMsgMail:= "Prezado(a) Gerente Manutenção, " //+ eEmail + CHR(13) + CHR(10)
				cMsgMail+= "Foi Requerida Pré-Aprovação da SC: " + SC1->C1_NUM + ", Pela Diretoria" + CHR(13) + CHR(10)+ CHR(13) + CHR(10)
                cMsgMail+= "Por Favor, Acesse Módulo: Compras -> Atualizações -> Solicitações de Compra -> Ações Relacionadas: Pré-Aprovação."+ CHR(13) + CHR(10)
                cMsgMail+= "Qualquer Dúvida, Favor entrar em contato com Depto. TI "
								
				//eEmail := "" //retirar
				//eEmail += ";flavia.rocha@ravaembalagens.com.br" //retirar depois				
				U_SendFatr11(eEmail, "", subj, cMsgMail, "" )
				
				alert("Um E-mail Foi Enviado ao Gerente de Manutenção") //retirar
			Endif //msg yes no	
		
		
	Else  //se já foi pré-aprovado...
		lRet	:= .T. //prossegue com a aprovação				
	Endif //lPreOK

Endif     //precisa pré-aprovação?


Return lRet