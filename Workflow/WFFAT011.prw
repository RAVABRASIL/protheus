#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

//------------------------------------------------------------------------------------------------
//Programa: WFFAT011.PRW
//Data    : 01/08/2011
//Autoria : Flávia Rocha
//Objetivo: Emitir lista das notas que possuem agendamento interno feito pelo SAC
//          junto ao cliente e enviar esta lista à Logística diariamente
//-------------------------------------------------------------------------------------------------
                   

***************************
User Function WFFAT011()
***************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT011" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT011 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT011 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT011 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***********************
Static Function Exec()
***********************

Local cQuery	:=' '
LOCAL dDataAte	:=ddatabase-1
Local LF 		:= CHR(13) + CHR(10)
Local eEmail	:= ""

cQuery:="SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE,A1_NREDUZ,A1_TEL, F2_LOJA,A4_NREDUZ,F2_EMISSAO, F2_DTAGCLI, F2_DTAGINT "+LF		
//Agendamento interno: qdo o SAC liga para o cliente solicitando se pode entregar em determinada data,
//É uma negociação com o cliente para um agendamento solicitado pela RAVA, não é igual ao agendamento solicitado pelo
//cliente, o qual já é tratado no campo F2_DTAGCLI

cQuery+="FROM " + LF
cQuery += " " + RetSqlName("SF2") + " SF2, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1, " + LF
cQuery += " " + RetSqlName("SA4") + " SA4  " +LF

cQuery+="WHERE " +LF
cQuery+="F2_CLIENTE = A1_COD "+LF
cQuery+="and F2_LOJA = A1_LOJA "+LF
cQuery+="and F2_TRANSP = A4_COD "+LF

cQuery+="AND F2_EMISSAO <= '"+DTOS(dDataAte)+"' "+LF

//exclui notas para Rava Caixas
cQuery+="AND A1_CGC NOT LIKE ('28924778%') "+LF

cQuery+="AND F2_DTEXP <> '' "+LF
cQuery+="AND F2_DTAGINT <> '' "+LF
cQuery+="AND F2_REALCHG =  '' "+LF
cQuery+="AND F2_SERIE !='' "+LF
cQuery+="AND F2_TIPO='N' "+LF
cQuery+="AND SF2.D_E_L_E_T_!='*' "+LF
cQuery+="AND SA1.D_E_L_E_T_!='*' "+LF
cQuery+="AND SA4.D_E_L_E_T_!='*' "+LF
cQuery+="ORDER BY F2_FILIAL, F2_DOC, F2_SERIE "+LF
MemoWrite("C:\Temp\WFFAT011.SQL",cQuery )

TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( 'AUUX', "F2_EMISSAO", "D")
TCSetField( 'AUUX', "F2_DTAGCLI", "D")
TCSetField( 'AUUX', "F2_DTAGINT", "D")

AUUX->(DbGoTop())


if !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT011","WFFAT011")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT011.htm")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF())
	   aadd( oHtml:ValByName("it.cFilial") , iif(AUUX->F2_FILIAL = '01', "RAVA EMB", iif ( AUUX->F2_FILIAL = '03', 'RAVA CAIXAS', "") ) )                        
	   aadd( oHtml:ValByName("it.cDoc") , Alltrim(AUUX->F2_DOC + "/" + AUUX->F2_SERIE) )    
	   aadd( oHtml:ValByName("it.cCli") , AUUX->F2_CLIENTE+' - '+AUUX->A1_NREDUZ)    
	   aadd( oHtml:ValByName("it.cTel" ) , AUUX->A1_TEL)    
	   aadd( oHtml:ValByName("it.cTransp" ) , AUUX->A4_NREDUZ)    
	   aadd( oHtml:ValByName("it.dAgend" ) , AUUX->F2_DTAGINT)    
	   //aadd( oHtml:ValByName("it.cDias" ) , AUUX->DIAS)    
	AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 eEmail := "joao.emanuel@ravaembalagens.com.br;alexandre@ravaembalagens.com.br;sac@ravaembalagens.com.br;posvendas@ravaembalagens.com.br" 	         
	 //eEmail += ";flavia.rocha@ravaembalagens.com.br"
	 oProcess:cTo := eEmail

	 subj	:= "Notas com Agendamento Interno"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail() 
endif
AUUX->(DbCloseArea())
Return