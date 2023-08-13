#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

User Function MaiDoc()

If Select( 'SX2' ) == 0
  //RAVA EMB
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MaiDoc" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa MaiDoc na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
  //RAVA CAIXAS
  
  //RPCSetType( 3 )
  //PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "MaiDoc" Tables "SE1"
  //sleep( 5000 )
  //conOut( "Programa MaiDoc na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  //Exec()
  
Else
  conOut( "Programa MaiDoc sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa MaiDoc em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

Static Function Exec() 

Local cQuery2:=" "

cQuery2:="SELECT Z20_FILIAL,Z20_DESCRI,Z20_DTVALI  "
cQuery2+="from  "+RetsqlName('Z20')+" Z20  "
cQuery2+="where "  
cQuery2+="CONVERT(VARCHAR,CAST(Z20_DTVALI AS DATETIME)-CAST(Z20_ALERTA AS INT),112)='"+Dtos( DDATABASE )+"'  "
cQuery2+="AND Z20.D_E_L_E_T_!='*' " 
cQuery2+="ORDER BY  Z20_FILIAL, Z20_DESCRI "
MemoWrite("C:\Temp\VENCDOC.SQL",cQuery2)
TCQUERY cQuery2 NEW ALIAS 'AUUX'

AUUX->(DbGoTop())

if !AUUX->(EOF())

	oProcess:=TWFProcess():New("MAILDOC","MailDoc")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\MailDoc.html")
	oHtml   := oProcess:oHtml
	
	Do while !AUUX->(EOF())  
		aadd( oHtml:ValByName("it.Doc") ,AUUX->Z20_DESCRI )
		aadd( oHtml:ValByName("it.Venc" ) , Dtoc(Stod(AUUX->Z20_DTVALI) ) )
	    aadd( oHtml:ValByName("it.filial" ) , iif(AUUX->Z20_FILIAL='01','Saco',iif(AUUX->Z20_FILIAL='03','Caixa','' )) )
	    AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 oProcess:cTo := GetNewPar("MV_XMAILDO",'licitacao@ravaembalagens.com.br;aline.farias@ravaembalagens.com.br') //"licitacao@ravaembalagens.com.br"
	 //oProcess:cTo += ";aline.farias@ravaembalagens.com.br"
	 //oProcess:cTo := " " //retirar
	 oProcess:cCC := "gustavo@ravaembalagens.com.br"
	 
	 subj	:= "Alerta de Vencimento de Documento(s)"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
	
endif

AUUX->(DBCLOSEAREA())


Return
