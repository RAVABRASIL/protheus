#include "Rwmake.ch"
#include "Protheus.ch"

/*  
/////////////////////////////////////////////////////////////////////////////////////////
//Programa: FATC017 - Verifica se o caracter passado no par�metro � um n�mero
//Objetivo: Usado no programa NFESEFAZ, onde verificamos no conte�do do campo 
//          C5_OCCLI se a sequ�ncia de caracteres digitados � v�lida para considerarmos
//          como n�mero da ordem de compra do cliente.
//Exemplo : C5_OCCLI = 'NAO TEM' -> nesse caso n�o vale
//          C5_OCCLI = 'N2011-222335' -> Neste caso vale porque h� n�meros 
//Autoria : Fl�via Rocha
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