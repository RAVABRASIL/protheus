#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "Topconn.ch"

User Function MATA106

Local lRet := .F.

If MsgYesNo("deseja validar ?" , "valida��o")

	lRet := .T.
Endif

If !lRet 

	msgbox("n�o validou hahaha")

Endif

Return(lRet)