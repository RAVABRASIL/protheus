#include "Rwmake.ch"
#include "Protheus.ch"

/*  
/////////////////////////////////////////////////////////////////////////////////////////
//Programa: FATC017 - Verifica se o caracter passado no parâmetro é um número
//Objetivo: Usado no programa NFESEFAZ, onde verificamos no conteúdo do campo 
//          C5_OCCLI se a sequência de caracteres digitados é válida para considerarmos
//          como número da ordem de compra do cliente.
//Exemplo : C5_OCCLI = 'NAO TEM' -> nesse caso não vale
//          C5_OCCLI = 'N2011-222335' -> Neste caso vale porque há números 
//Autoria : Flávia Rocha
//Data    : 06/05/2011 

/////////////////////////////////////////////////////////////////////////////////////////
*/

*************************************
User Function FATC017(cString)
*************************************

Local fr := 0 
Local lValido := .F.
Local lTemNum := .F.

//lNum := IsDigit( cCaracter )
//cString:= 'N2011-222335 '

For fr:= 1 to Len(cString)			   
		
	lTemNum := IsDigit(  Substr(cString,fr, 1)  ) 
	
	If lTemNum
		lValido := .T.
		//msgbox("tem numero: " + Substr(cString,fr, 1) )
	Endif					

Next

//msgbox("Fim")

Return(lValido)