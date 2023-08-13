#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "

User Function MaiDocAut()

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MaiDocAut" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa MaiDocAut na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa MaiDocAut sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa MaiDocAut em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

Static Function Exec() 

Local cQuery2:=" "

cQuery2+="SELECT Z20_COD,Z20_DESCRI,Z20_DTAUTD "
cQuery2+="from  "+RetsqlName('Z20')+" Z20 "
cQuery2+="where Z20_FILIAL = '"+xFilial('Z20')+"' "  
cQuery2+="AND CAST(Z20_DTAUTD AS DATETIME)-CAST(Z20_ALAUTD AS INT)='"+Dtos( DDATABASE )+"'   "
cQuery2+="AND Z20.D_E_L_E_T_!='*' " 
cQuery2+="ORDER BY  Z20_DESCRI "

TCQUERY cQuery2 NEW ALIAS 'AUUX'

AUUX->(DbGoTop())

if !AUUX->(EOF())

	oProcess:=TWFProcess():New("MailDocAut","MailDocAut")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\MailDocAut.html")
	oHtml   := oProcess:oHtml
	
	Do while !AUUX->(EOF())  
		aadd( oHtml:ValByName("it.Doc") ,AUUX->Z20_DESCRI )
		aadd( oHtml:ValByName("it.Autent" ) , Dtoc(Stod(AUUX->Z20_DTAUTD ) ) )
	    AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 //oProcess:cTo := "antonio@ravaembalagens.com.br"
	 //oProcess:cTo := "bel.lima@ravaembalagens.com.br;diego.rodrigues@ravaembalagens.com.br;ligia.missylani@ravaembalagens.com.brn" //"licitacao@ravaembalagens.com.br"
	 oProcess:cTo := "licitacao@ravaembalagens.com.br"
	 oProcess:cCC := "regineide@ravaembalagens.com.br"
	 
	 subj	:= "Autenticacao Digital de Documento(s)"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
	
endif

AUUX->(DBCLOSEAREA())


Return
