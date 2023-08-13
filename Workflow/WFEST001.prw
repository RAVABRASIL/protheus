#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "
                   

*************

User Function WFEST001()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFEST001" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFEST001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFEST001 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFEST001 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec()

***************

Local cQry:=' '


cQry:="SELECT B1_COD,B1_DESC,B1_UM FROM " + RetSqlName( "SB2" ) + " SB2," + RetSqlName( "SB1" ) + " SB1 "
cQry+="WHERE B1_COD=B2_COD  "
cQry+="AND B1_PTPRODA>0 "
cQry+="AND B2_LOCAL='03' "
cQry+="AND B2_QATU=0 "
cQry+="AND B1_ATIVO!='N'  "
cQry+="AND B1_TIPO='PA' "
cQry+="AND LEN(B1_COD)<=7  "
cQry+="AND SB1.D_E_L_E_T_!='*' "
cQry+="AND SB2.D_E_L_E_T_!='*'  "
cQry+="ORDER BY B2_COD  "
     

TCQUERY cQry NEW ALIAS 'AUUX'

AUUX->(DbGoTop())

if !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFEST001","WFEST001")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\WFEST001.html")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF())                    
	   aadd( oHtml:ValByName("it.cProd") , AUUX->B1_COD)    
	   aadd( oHtml:ValByName("it.cDesc") , AUUX->B1_DESC)    
	   aadd( oHtml:ValByName("it.cUN" ) , AUUX->B1_UM)    
	AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 oProcess:cTo := "rodrigo.pereira@ravaembalagens.com.br;marcio@ravaembalagens.com.br;alexandre@ravaembalagens.com.br" 	         
	 //oProcess:cTo := "antonio@ravaembalagens.com.br" 	         
	 subj	:= "Produtos Do Estoque 3 Zerados"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail() 
endif
AUUX->(DbCloseArea())
Return