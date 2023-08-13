#include "rwmake.ch"
#include "TbiConn.ch"
#include "topconn.ch"

************************
User Function WFTMK001()
************************

SetPrvt("OHTML,OPROCESS,")

if Select( 'SX2' ) == 0
   // A rotina abaixo tem como finalidade preparar o ambiente caso não se execute o workflow
   // através de Menu
   RPCSetType( 3 ) // Não consome licensa de uso
   PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFTMK001" Tables "SA1"
   sleep( 5000 ) // aguarda 5 segundos para que as jobs IPC subam.
endif

EnviaEmail()

Return


****************************
Static function EnviaEmail()
****************************

oProcess:=TWFProcess():New("CALLCENTER","Call center")
oProcess:NewTask('Inicio',"\workflow\http\emp01\WFTMK001.html")
oHtml   := oProcess:oHtml

eEmail := 'eurivan@ravaembalagens.com.br' // Definição de e-mail padrão


oHtml:ValByName("cResponsavel", "Eurivan" )
oHtml:ValByName("cProblema", "Problema")


/*
//Itens
oHtml:ValByName("it.cCodigo", {})
oHtml:ValByName("it.cDesc"	, {})
oHtml:ValByName("it.nEstmin", {})
oHtml:ValByName("it.nEstatu", {})
oHtml:ValByName("it.cUN"    , {})

For nCount := 1 to Len(aProds)
	aadd(oHtml:ValByName("it.cCodigo")	, aProds[ncount,1])
	aadd(oHtml:ValByName("it.cDesc")	, aProds[ncount,2])
	aadd(oHtml:ValByName("it.nEstmin")	, aProds[ncount,3] )
	aadd(oHtml:ValByName("it.nEstatu")	, aProds[ncount,4] )
	aadd(oHtml:ValByName("it.cUN")		, aProds[ncount,5])
	wvlr_tot ++
Next
oHtml:ValByName("vlrtot", wvlr_tot)
*/

// Start do WorkFlow
//_user := Subs(cUsuario,7,15)
//oProcess:ClientName(_user)
oProcess:cTo	:= eEmail
//oProcess:cCC	:= eCopia
oProcess:cSubject  := "SAC - NOVA Ocorrência"
//oProcess:Body    := Body do Processo
//oProcess:bReturn   := "U_TMK01(1)"
//oProcess:bTimeOut  := {}
//Timeout em 1 hora e um minuto
oProcess:bTimeOut := { {"U_TTTMK01(2)", 0, 0, 1 } }
oProcess:Start()
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Processo do Pedido '+cNum+' 
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,'000002','1002',"Call Center")
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,'000002','1002','Call Center' )

WfSendMail()

//oProcess:Finish()

Return

*************************
User Function TTTMK01(nOpc,oProcess)
*************************
conout("Entrou no Retorno" )

If nOpc == 1
   conout(Replicate("*",60))
   conout("Retorno CallCenter")
   conout(Replicate("*",60))
   //MemoWrite( 'RETURN.TXT', 'Retorno' )	
   oProcess:Finish()   
ElseIf nOpc == 2
   conout(Replicate("*",60))
   conout("Timeout CallCenter")
   conout(Replicate("*",60))
   //MemoWrite( 'TIMEOUT.TXT', 'Timeout' )	
   oProcess:Finish()
   Return .t.
EndIf

return .T.