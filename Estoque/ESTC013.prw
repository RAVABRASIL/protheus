#INCLUDE "PROTHEUS.CH" 
#include "topconn.ch"
#include "TbiConn.ch"

User Function ESTC013()

Local cAlias := "Z69"
LOCAL cTitulo := "Cadastro da Media Anual de Consumo"
local cVldExc := ".T."
LOCAL cVldAlt := ".T."

dbSElectArea(cAlias)
dbSEtOrder(1)
AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)

Return

