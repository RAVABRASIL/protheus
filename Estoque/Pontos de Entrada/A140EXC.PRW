#include "Rwmake.ch"
#include "Protheus.ch"

/*
////////////////////////////////////////////////////////////////////////////////////
//Programa: A100DEL - VALIDA A EXCLUSÃO DA PRÉ-NF ENTRADA
//Autoria : Flávia Rocha
//Data    : 24/05/2011           
//Solicitado no chamado 002110 - Deise
//Descrição: 	Por favor, permitir apenas para exclusão de NF de entrada
// e pre nota os usuarios Deise,Regina,João Emanuel e Alexandre Xavier,
// e se possível deixar registrado o usuario que excluiu a mesma(NF).Obrigada 
/////////////////////////////////////////////////////////////////////////////////////
*/
************************
User Function A140EXC() 
************************


//Local lOk :=alltrim(Upper( Substr( cUsuario, 7, 15 ) ) ) $ "ADMIN/DEISE/REGINA/ALEXANDRE/JOAO EMANUEL"  
//Local lOk := .T.

//if !lOK
//   Alert("Somente Regina, Deise, Alexandre Xavier ou João Emanuel, poderão cancelar Pré-Notas.")
//endif

Return .t. //lOk
