#Include 'Protheus.ch'

User Function COMR010()

Local cAlias := "Z61"
Local cTitulo := "Cadastro de Hoteis"
Local cVldExc := ".T."
Local cVldAlt := ".T."

dbSelectArea(cAlias)
dbSetOrder(1)

AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)


Return

