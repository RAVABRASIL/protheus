#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

**************

User Function FINC001() 

*************

oProcess:=TWFProcess():New("FINC001","FINC001")
oProcess:NewTask('Inicio',"\workflow\http\emp01\FINC001.html")
oHtml   := oProcess:oHtml

aadd( oHtml:ValByName("it.Num") ,SF2->F2_DOC )
aadd( oHtml:ValByName("it.For" ) , posicione('SA2',1,xFilial('SA2')+SF2->F2_CLIENTE,'A2_NOME') )
aadd( oHtml:ValByName("it.Emi") ,Dtoc(SF2->F2_EMISSAO  ) )
aadd( oHtml:ValByName("it.Val" ) , transform(SF2->F2_VALBRUT,'@E 999,999,999.9999' ))
_user           := Subs(cUsuario,7,15)
oProcess:ClientName(_user)
oProcess:cTo    := "financeiro@ravaembalagens.com.br"
subj        	:= "Emissão das notas fiscais"
oProcess:cSubject  := subj
oProcess:Start()
WfSendMail()

Return

//=============================================================================================================
