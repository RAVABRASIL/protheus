#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "
                   

*************

User Function WFFAT004()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT004" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT004 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT004 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT004 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec()

***************
Local nTotal:=0 
Local cCod:=''
Local cQuery:=' '
cQuery+=" SELECT  C9_PEDIDO,A1_NOME,  CAST(CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) - CONVERT(smalldatetime,C9_DATALIB,112)AS INT)as dias   "
cQuery+=" FROM SC9020  C9,SA1010 A1  "
cQuery+=" where   "
//cQuery+=" C9_BLCRED='' AND  "
// NOVA LIBERACAO DE CRETIDO
cQuery+=" C9_BLCRED IN('','04') AND  "
cQuery+=" C9_NFISCAL=''AND  "
cQuery+=" GETDATE()-C9_DATALIB >=1 AND  "
cQuery+=" C9_CLIENTE = A1_COD AND  "
cQuery+=" C9_LOJA    =  A1_LOJA AND  "
cQuery+=" C9.D_E_L_E_T_=' 'AND  "
cQuery+=" A1.D_E_L_E_T_=' '  "
cQuery+=" GROUP BY C9_PEDIDO,A1_NOME ,CAST(CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) - CONVERT(smalldatetime,C9_DATALIB,112)AS INT) "
cQuery+="  order by dias "
TCQUERY cQuery NEW ALIAS 'AUUX'

AUUX->(DbGoTop())


if !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT004","WFFAT004")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT004.html")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF())                    
		aadd( oHtml:ValByName("it.Cli" ) , AUUX->A1_NOME )  
		aadd( oHtml:ValByName("it.Ped") ,AUUX->C9_PEDIDO  )
	    aadd( oHtml:ValByName("it.Dia" ) , AUUX->dias )
	AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 oProcess:cTo := "regina@ravaembalagens.com.br"
	 subj	:= "Liberacao de credito pendente ha mais de um Dia"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
	
endif
AUUX->(DbCloseArea())
Return