#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "fivewin.ch"

User Function Util_C   ()
alert("Coleção de funcoes para tratamento de variaveis tipo C ")
return nil




/* U_ini_PERG
inicializa um parametro do Pergunte
1,2,3,4,5
parametros
1 pergunta valida  --- char(10)
2 nOrdem           --- int
3 cTipo            --- upper char(1) :
tipo da variavel
4 nTamanho         --- int.
limite para string :
caso seja menor incrementa espaços ate atingir o limite
caso maior reduz a String ao tamanho limite
5 Uvalor           --- tipo indeterminado mas deve ser correspondente ao valor do 3ª parametro
*/
user function ini_PERG(Pergunta,nOrdem,cTipo,nTamanho,xValor)
Local cFunName:="ini_PERG"

if U_validaTipo(1,Pergunta,"C",cFunName)
	cPergunta:=U_ajusta_TAM (Pergunta,10)
else
	return 1
endif

if U_validaTipo(2,nOrdem,"N",cFunName)
	cOrdem:=StrZero( nOrdem, 2 )
else
	return 2
endif

if U_validaTipo(3,cTipo,"C",cFunName)
else
	return 3
endif

if U_validaTipo(4,nTamanho,"N",cFunName)
else
	return 4
endif

if U_validaTipo(5,xValor,cTipo,cFunName)
else
	return 5
endif


dbSelectArea( "SX1" )
dbSetOrder( 1 )

cOrdem:=StrZero( nOrdem, 2 )
If dbSeek(cPergunta+cOrdem )
	RecLock( "SX1", .F. )
	if Valtype(xValor)!= Valtype(X1_CNT01)
		if Valtype(xValor)=='D'
			xValor:=dtos(xValor)
		elseif Valtype(xValor)=='N'
			xValor:=alltrim(str(xValor))
		elseif Valtype(xValor)=='C'
			xValor:=alltrim(xValor)
		else
			return 6
		endif
	endif
	X1_CNT01:=xValor
	MsUnlock()
Endif
return 0





/* U_ValidaTipo
valida tipo da variavel para nao ocorrer erro em tempo de execução no programa

parametros
1 nParametro   int          , qual parametro da função esta sendo analisada
2 xValor       ???          , valor informado deve ser correspondente ao 3ª parametro
3 cTipo        upper char(1), tipo esperado pela funçao
4 cPrograma    char(10)     , nome da função que recebe esses parametros

alertar caso valor informado nao seja do tipo esperado
*/
user function ValidaTipo(nParametro,xValor,cTipo,cPrograma)
if valtype(xValor) == cTipo
	return .T.
else
	//alert(;
	//"Erro no "+alltrim(str(nParametro))+;
	//"ª parametro em "+alltrim(cPrograma)+"()<br>Tipo correto  "+valtosql(cTipo)+;
	//"<br>Mas foi recebido "+valtosql(valtype(xValor)))
	return .F.
endif

return




/* U_ajusta_TAM

parametros
1 cVar char(??), string a ser formatada
2 nTamanho int, limite para string

formatar a string informada para tamanho limite
reduzindo-a   ou  incrementando espaços no fim

caso nao seja informada uma String ou tamanho nao seja valido
*/
user function ajusta_TAM (cVar,nTamanho)
Local cFunName:="ajusta_TAM"

if U_validaTipo(1,cVar,"C",)
else
	return ""
endif

if U_validaTipo(2,nTamanho,"N",cFunName)
else
	return ""
endif


cVar:=substr(cVar,1,nTamanho)
cVar:= alltrim(cVar)+space(nTamanho - len(cVar))

return cVar





user function CabecEmail()
Local cInicio:=" "

cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cInicio+='<head> '
cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cInicio+='<title></title> '
cInicio+='</head> '
cInicio+='<body> '
cInicio+='<center>'

cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> '
cInicio+='</center>'
cInicio+=' <br>'

return cInicio


User function cod2Nome(cNomeCod)

PswOrder(1)
If PswSeek( cNomeCod, .T. )
	aUsuarios  := PSWRET()
	cNomeCod := Alltrim(aUsuarios[1][2])
Endif
return cNomeCod

User function spaceVazio()
return "&nbsp;"