*************

User Function CGCLI()

*************
dbSelectArea('SA1')
dbSetOrder(1)
dbSeek( xFilial('SA1') + M->A4_CODCLIE, .T. )
if M->A4_CGC != SA1->A1_CGC
	msgAlert("CGCs diferentes ou inexistente no cadastro de cliente.")
	return .F.
else
	return .T.
endIf

return