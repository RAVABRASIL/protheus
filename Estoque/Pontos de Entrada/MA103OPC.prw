#Include "Rwmake.ch"

/*
//////////////////////////////////////////////////////////////
//Pto entrada: MA103OPC - Adiciona novas op�oes no aRotina
//Autoria    : Fl�via Rocha
//Data       : 12/06/12
//////////////////////////////////////////////////////////////
*/
User Function MA103OPC()

Local aRet := {}

//boletim de entrada
AAdd( aRet, { "Boletim", "U_ESTR008('SF1',SF1->(RECNO()), 4)", 2, 0 } ) 

Return aRet