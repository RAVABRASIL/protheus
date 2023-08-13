#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Programa: FATC025 - VALIDADOR DE CAMPO
//Autoria : Flávia Rocha
//Data    : 27/06/12
//Chamado : 002258 - Problema: o CADASTRO DO CLIENTE é feito pelo Comercial 
//                   que tem como foco a venda, assim registra no cadastro o nome da pessoa que compra,
//                   não da pessoa que paga. SOLCITAMOS seja campo obrigatório, também no cadastro do cliente:
//                   o nome, telefone e e-mail do contato responsável pelo pagamento do título, assim como a
//                   confirmação do endereço da cobrança que nem sempre é o mesmo da entrega. 
//                   Caso o comercial preencha os campos com dados inválidos o SIGA deve permitir ao FINANCEIRO 
//                   abrir um chamado contra o COMERCIAL, gerando um relatório das pendências acumuladas de 
//                   cadastro de clientes: Semanalmente ao gestor do FINANCEIRO e do COMERCIAL; quinzenalm ente ao CONTROLLER;
//                   e mensalmente à DIRETORIA. Obrigado.  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

User Function fValTXT(cTexto)

Local lRet := .T.
Local x    := 0  
Local n    := 0
Local cSequen := ""
Local lSequen := .F.   //para verificar se foi colocado 2 ou mais letras iguais em sequencia, ex.: AAA, BBB, CC, etc
Local cCampo  := ReadVar() 
Local lTrava  := GETMV("RV_FATC025")

//MSGBOX("CAMPO: " + cCampo)
If lTrava

	If Len(Alltrim(cTexto)) <= 1
		lRet := .F.
		Msgbox("1-Por Favor, Preencha o Campo Corretamente!")
	Elseif Alltrim(cTexto) = '.'
		lRet := .F.
		Msgbox("2-Por Favor, Preencha o Campo Corretamente!")  
	Elseif UPPER(Alltrim(cTexto)) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
		lRet := .F.
		Msgbox("3-Por Favor, Preencha o Campo Corretamente!")
	Endif
	
	If Alltrim(cCampo) $ "M->A1_ENDCOB/M->A1_CIDCOB/M->A1_CONTFIN"
		//MSGBOX("ENTROU NO FOR")
	//valida o conteúdo dos campos: Endereço de Cobrança, Cidade Cobrança, Contato Financeiro
		For x := 1 to Len(Alltrim(cTexto))
			cSequen += Substr(cTexto, x , 1 )	
			If x > 1
				If UPPER(Substr(cSequen,x,1)) = UPPER(Substr(cSequen,x - 1,1))
					n++    //se tiver 3 letras iguais seguidas, não deixará cadastrar
				Endif
				If n >= 3
					lSequen := .T.
					n := 0
				Endif
			Endif
		Next     
		
		If lSequen
			lRet := .F.
			Msgbox("4-Por Favor, Preencha o Campo Corretamente!")
		Endif 
	Endif
	
	If Alltrim(cCampo) $ "M->A1_ESTCOB"
		SX5->(DBSETORDER(1))
		If !SX5->(Dbseek(xFilial("SX5") + '12' + M->A1_ESTCOB ))
			lRet := .F.
			Msgbox("UF Inválida! - Por Favor, Preencha corretamente a UF")
		Endif
	Endif 

//Else
//	msgbox("sem trava")
Endif

Return(lRet)