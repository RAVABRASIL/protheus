************************************
User Function RET_USER( cUsu, cSen )
************************************

Local aRETORNO := {}
Local lOk := .F.
Local cRetorno
Local aGrps := {}
Local cUsu
RPCSetType( 3 ) // N�o consome licensa de uso
RpcSetEnv('02','01',,,,GetEnvServer(),{"SF4"})  // atencao para esta linha.

//Pesquisa por Nome
if .T. //aConfig()[4] //Testo se utiliza Nome na validacao de usuario (Protheus 11 s� autentica com usu�rio)
   PswOrder(2)
   if PswSeek( cUsu, .T. )
      lOk := PSWNAME( cSen )
   endif
   if !lOk 
      cRetorno := 'Usu�rio e/ou Senha inv�lido !'      
   endif  
else
   PswOrder(3)
   if PswSeek( cSen )
      lOk := .T.
   else
      cRetorno := 'Senha inv�lida !'       
   endif   
endif

if lOk
   cUsu := PSWRET()[1][2]
   aGrps := GetGrupos( cUsu )
   if "CONSULTA" $ aGrps[3]
      lOk := .T.
      cRetorno := cUsu
   else
      lOk := .F.
      cRetorno := "Usu�rio sem acesso a essa Rotina !"
   endif
endif

Aadd( aRETORNO, lOk )
Aadd( aRetorno, cRetorno )	

RpcClearEnv() // Libera o Environment
DbCLoseAll()

Return aRETORNO


************************************
User Function RET_UNOME()
************************************

Local lOk := .F.

RPCSetType( 3 ) // N�o consome licensa de uso
RpcSetEnv('02','01',,,,GetEnvServer(),{"SF4"})  // atencao para esta linha.

lOk := .T. //aConfig()[4] Sempre retornara True, pois o Protheus 11 s� permite autenticacao com usuario e senha

RpcClearEnv() // Libera o Environment
DbCLoseAll()

Return lOk


/*����������������������������������������������������������������������������
Function  � GetGrupos() Retorna string com grupos que o usuario atual faz parte
����������������������������������������������������������������������������*/
Static function GetGrupos(cUsuario)

Local aUser   := {}
Local cGrupos := ""
Local cDGrps := ""
Local cGrp

aGroup	:= UsrRetGrp(cUsuario)

for k := 1 to Len( aGroup )
	cDGrps 	+= Upper(AllTrim(GrpRetName(aGroup[k]))) + "/" //Descricao dos Grupos
	cGrupos 	+= aGroup[k] + "/" //Codigos dos Grupos

	if k = 1
		cGrp := aGroup[1]//Retorna Codigo do Primeiro Grupo
	endif
next k

return { cGrupos, cGrp, cDGrps }