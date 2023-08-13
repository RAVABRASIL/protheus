#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

/*
///////////////////////////////////////////////////////////////////////////////
//Programa: ESTC006.PRW
//Objetivo: Validar o usuário que desejar alterar o campo B1_EMIN (Pto.Pedido)
//          do cadastro de produtos (SB1), através da solicitação de senha,
//          função U_Senha(cTipo), onde só será valida a senha de Marcelo.
//Autoria : Flávia Rocha
//Data    : 11/05/2010
///////////////////////////////////////////////////////////////////////////////
*/


//////////////////////////////////////////////////
////VALIDAÇÃO NO CAMPO B1_EMIN
////SE O USUÁRIO NÃO ESTIVER AUTORIZADO POR SENHA
////NÃO PERMITIRÁ A ALTERAÇÃO DESTE CAMPO
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
