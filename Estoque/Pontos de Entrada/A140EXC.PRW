#include "Rwmake.ch"
#include "Protheus.ch"

/*
////////////////////////////////////////////////////////////////////////////////////
//Programa: A100DEL - VALIDA A EXCLUS�O DA PR�-NF ENTRADA
//Autoria : Fl�via Rocha
//Data    : 24/05/2011           
//Solicitado no chamado 002110 - Deise
//Descri��o: 	Por favor, permitir apenas para exclus�o de NF de entrada
// e pre nota os usuarios Deise,Regina,Jo�o Emanuel e Alexandre Xavier,
// e se poss�vel deixar registrado o usuario que excluiu a mesma(NF).Obrigada 
/////////////////////////////////////////////////////////////////////////////////////
*/
************************
User Function A140EXC() 
************************


//Local lOk :=alltrim(Upper( Substr( cUsuario, 7, 15 ) ) ) $ "ADMIN/DEISE/REGINA/ALEXANDRE/JOAO EMANUEL"  
//Local lOk := .T.

//if !lOK
//   Alert("Somente Regina, Deise, Alexandre Xavier ou Jo�o Emanuel, poder�o cancelar Pr�-Notas.")
//endif

Return .t. //lOk
