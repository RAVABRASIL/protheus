#INCLUDE "PROTHEUS.CH" 
#include "topconn.ch"
#include "TbiConn.ch"

User Function pcpc020()

Local cAlias := "Z76"
LOCAL cTitulo := "Cadastro Fichas Tecnicas das MP's"
local cVldExc := ".T."
LOCAL cVldAlt := ".T."

dbSElectArea(cAlias)
dbSEtOrder(1)
AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)

Return

