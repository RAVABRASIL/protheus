#include "protheus.ch"
#include "TbiConn.ch"
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 

User Function Conecta16(paramixb)

  Local lRet		:= .T.
  Local nXHndERP 	:= paramixb[3] //AdvConnection()
  local cDB16  	:= "MSSQL/P1216"
  Local cSrv16 	:= "10.0.0.19"
  Local nHnd16 	:= -1
  Local aSA1	:= paramixb[1]
  Local cCodLoja:= paramixb[2]
 
  PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' //TABLES "SA1"
  // Cria uma conexão com um outro banco, outro DBAcces
  nHnd16 := TcLink( cDB16, cSrv16, 7890 )

  If !TCSETCONN(nHnd16) //nHnd16 < 0
	conout("Erro ao realizar troca de conexão ativa")
    UserException( "Falha ao conectar com " + cDB16 + " em " + cSrv16 )
    lRet	:= .F.
  Else
  	conout( "Banco conectado - Handler = " + str( nHnd16, 4 ) )
  Endif
   
If lRet
	dbSelectArea("SA1") 
	dbSetOrder(1)
	MsgAlert(cCodLoja)
	If SA1->(dbSeek(xFilial("SA1") + cCodLoja))
		conout(SA1->A1_NOME)
		conout(aSA1[4][2])
		RecLock("SA1",.F.)

		For k := 1 to Len(aSA1)
				
			cCampo		:= Alltrim("SA1->" + aSA1[k][1])
			Replace &cCampo With aSA1[k][2]
		
		Next k			
		
		SA1->(MsUnlock())
	
	EndIf

  tcSetConn( nXHndERP )

  TcUnlink( nHnd16 )
  conout( "Banco 16 desconectado" )

EndIf	
   
  RESET ENVIRONMENT
  // Volta para conexão ERP
  
Return lRet


User Function VldBancoEmpresa()

Local lRet	:= .T.

conout( "Identificador da conexao no SGDB: " + GetEnvServer() )
If FWCodEmp() == "99"
 
	//TCGetDBSID()
	lRet	:= .F.

EndIf

Return lRet