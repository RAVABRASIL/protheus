#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

/*
///////////////////////////////////////////////////////////////////////////////
//Programa: ESTC006.PRW
//Objetivo: Validar o usu�rio que desejar alterar o campo B1_EMIN (Pto.Pedido)
//          do cadastro de produtos (SB1), atrav�s da solicita��o de senha,
//          fun��o U_Senha(cTipo), onde s� ser� valida a senha de Marcelo.
//Autoria : Fl�via Rocha
//Data    : 11/05/2010
///////////////////////////////////////////////////////////////////////////////
*/


//////////////////////////////////////////////////
////VALIDA��O NO CAMPO B1_EMIN
////SE O USU�RIO N�O ESTIVER AUTORIZADO POR SENHA
////N�O PERMITIR� A ALTERA��O DESTE CAMPO
//////////////////////////////////////////////////
****************************
User Function ESTC006()
****************************

Local lPermite := .F.

lPermite := U_Senha("15")
If !lPermite
	MsgBox("Sem acesso para alterar o campo Pto.Pedido!")
//Else
	//MsgInfo("Acesso ok - campo Pto.Pedido")
Endif

Return(lPermite)   
