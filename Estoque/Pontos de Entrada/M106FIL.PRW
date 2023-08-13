#Include "Rwmake.ch"
#Include "Protheus.ch"

**********************
User Function M106FIL 
********************** 


Local cUser:= __CUSERID  
Local cRet := ""
Local cGrupo := ""

Local aUsu := {}
Local cUsu := ""

PswOrder(1)               //SELECIONA A ORDEM DE PESQUISA DO USUÁRIO UTILIZADA PELA PSWSEEK ABAIXO
If PswSeek( cUser , .T. ) //SE USUÁRIO LOGADO ESTIVER NO SIGAPSW ENTRA  
   aUsu   := PSWRET() 	  //JOGA NA aUsu O VETOR COM INFORMAÇÕES DO USUÁRIO			
cUsu   := Rtrim(Substr(aUsu[1][2],1,10))  
//cUsu   := Alltrim( aUsu[1][2] )
Endif

SX5->(Dbsetorder(1))
If SX5->(Dbseek(xFilial("SX5") + "ST" + cUser))    //TABELA ST = SETORES DE COMPRA NA SX5
	cGrupo := Alltrim(SX5->X5_DESCRI)              //TIPO A SUA MN A CHAVE É O CÓDIGO DO USUÁRIO
Endif


//cRet += " Rtrim(SUBSTR(CP_SOLICIT,1,10)) ='" + (cUsu) + "' .OR. CP_GRUPO $ '" + (cGrupo) + "' .OR. CP_SOLICIT ='Administra' .AND. CP_PREREQU <> 'S'"
cRet += "CP_PREREQU <> 'S' .AND. Rtrim(SUBSTR(CP_SOLICIT,1,10)) ='" + (cUsu) + "' .OR. CP_PREREQU <> 'S' .AND. CP_GRUPO $ '" + (cGrupo) + "' .OR. CP_PREREQU <> 'S' .AND. CP_SOLICIT ='Administra'"

Return(cRet)






