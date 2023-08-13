#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
----------------------------------------------------------------------------------------------------//
PONTO DE ENTRADA: MT010INC                                                                          //
                                                                                                    //
AUTORIA: FLÁVIA ROCHA - 24/10/2012                                                                  //
                                                                                                    //
SOLICITADO POR:                                                                                     //
CHAMADO: 00000142 - ERIKA VARELA                                                                    //
Com a finalidade de manter a atualização das contas contábeis no cadastro dos produtos,             //
solicito que seja encaminhado para o e-mail da contabilidade um aviso quando for cadastrado         //
qualquer tipo de novo produto.                                                                      //
----------------------------------------------------------------------------------------------------//
                                                                                                    //
Onde age o pto entrada:                                                                             //
Ponto de Entrada para complementar a inclusão no cadastro do Produto.                               //
                                                                                                    //
LOCALIZAÇÃO : Function A010Inclui - Função de Inclusão do Produto, após sua inclusão.               //
                                                                                                    //
EM QUE PONTO: Após incluir o Produto, este Ponto de Entrada nem confirma nem cancela a operação,    //
deve ser utilizado para gravar arquivos/campos do usuário, complementando a inclusão.               //
----------------------------------------------------------------------------------------------------//
*/

*************************
User Function MT010INC() 
*************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local cB1TIPO:= SB1->B1_TIPO 
Local cB1COD := SB1->B1_COD 
Local cB1DESC:= SB1->B1_DESC 
Local cDescTP:= ""
Local cNomeUser:= Substr(cUsuario,7,15)
Local lNOVO  := .T. 
Local cMsg   := ""
Local eEmail := GetMv("RV_010INC")   //PARÂMETRO QUE INDICA QUAL(IS) EMAILS IRÃO RECEBER O AVISO ATRAVÉS DESTE PTO ENTRADA.

	//alert("entrou no pto MT010INC !!")
If Inclui
	//alert("entrou no pto MT010INC - INCLUSAO")
	cQuery := " SELECT DISTINCT B1_TIPO FROM " + RetSqlName("SB1") + " SB1 " + LF
	cQuery += " WHERE SB1.D_E_L_E_T_ = '' AND B1_DATCAD < '" + Dtos(dDatabase) + "' " + LF
	cQuery += " ORDER BY B1_TIPO " + LF
	MemoWrite("C:\TEMP\MT010CAN.SQL", cQuery )
	If Select("B1X") > 0
		DbSelectArea("B1X")
		DbCloseArea()
	EndIf
		
	TCQUERY cQuery NEW ALIAS "B1X"
	B1X->( DbGoTop() )		
	While B1X->( !EOF() )
		If Alltrim(B1X->B1_TIPO) = Alltrim(cB1TIPO)
			lNOVO := .F.
		Endif
		B1X->(DBSKIP())
	Enddo
	
	IF lNOVO
		SX5->(Dbsetorder(1))
		If SX5->(Dbseek(xFilial("SX5") + "02" + cB1TIPO ))
			cDescTP := SX5->X5_DESCRI
		Endif
		//ALERT("O PRODUTO É NOVO")
		cMsg   := " *** NOVO TIPO de Produto Cadastrado *** " + LF + LF
		cMsg   += " Informamos que um novo tipo de produto foi cadastrado no Sistema: " + LF + LF
		cMsg   += "Produto   : " + cB1COD + LF
		cMsg   += "Tipo      : " + cB1TIPO + " - " + cDescTP + LF
		cMsg   += "Descrição : " + cB1DESC + LF
		cMsg   += "Data      : " + Dtoc(Date()) + LF
		cMsg   += "Hora      : " + Time() + LF + LF
		
		cMsg   += "Cadastrado por: " + cNomeUser + LF + LF
		
		cMsg   += "Att," + LF + LF
		cMsg   += "Administrador do Sistema" + LF + LF
		cMsg   += "(Email Automático do Sistema, Favor NÃO RESPONDER)"
		
		eEmail += ";flavia.rocha@ravaembalagens.com.br"
		
		subj   := "NOVO TIPO de Produto Cadastrado - " + Dtoc(dDatabase)
		U_SendFatr11(eEmail, "", subj, cMsg, "" )
	ELSE
		//ALERT("O PRODUTO JÁ EXISTE.")
	ENDIF
	
Endif

//  TRATAMENTOS DO USUÁRIO.


Return Nil