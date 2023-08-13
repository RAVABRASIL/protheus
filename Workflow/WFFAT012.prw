#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

//------------------------------------------------------------------------------------------------
//Programa: WFFAT012.PRW
//Data    : 04/08/2011
//Autoria : Flávia Rocha
//Objetivo: Emitir listagem diária para o Financeiro e Pós-Vendas
//          onde mostre todas as mercadorias com previsão de entrega até o dia anterior, 
//          e que ainda estão em aberto no sistema.
//          Solicitado por Daniela em 26/05/2011 - chamado 002148
//-------------------------------------------------------------------------------------------------
                   

****************************
User Function WFFAT012()
****************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT012" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT012 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT012 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT012 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

****************************
Static Function Exec()
****************************


Local cQuery	:= ' '
LOCAL dDataAte	:= (dDatabase - 1 )
Local LF		:= CHR(13) + CHR(10)
Local eEmail	:= ""

cQuery:= "SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE,A1_NREDUZ,F2_LOJA,A4_NREDUZ,F2_EMISSAO, F2_DTEXP, F2_PREVCHG " + LF
//cQuery+="CAST( "+valtosql(ddatabase)+" - CONVERT(datetime,F2_EMISSAO,112)AS FLOAT) DIAS "
cQuery+= "FROM " + LF
cQuery+= "" + RetSqlName("SF2") + " SF2, " + LF
cQuery+= "" + RetSqlName("SA1") + " SA1, " + LF
cQuery+= "" + RetSqlName("SA4") + " SA4  " + LF

cQuery+= "WHERE "  + LF
cQuery+= "F2_CLIENTE = A1_COD " + LF
cQuery+= "and F2_LOJA = A1_LOJA " + LF
cQuery+= "and F2_TRANSP = A4_COD " + LF
//                               marco Zero
cQuery+= "AND F2_PREVCHG <= '"+DTOS(dDataAte)+"' " + LF

//exclui notas de Rava para Rava
cQuery+= "AND A1_CGC NOT LIKE ('28924778%') " + LF

cQuery+= "AND F2_DTEXP  <> '' AND F2_DTEXP >= '20110101' " + LF
cQuery+= "AND F2_REALCHG = '' " + LF
cQuery+= "AND F2_SERIE != '' " + LF
cQuery+= "AND F2_TIPO   = 'N' " + LF
cQuery+= "AND F2_TRANSP <> '024' " + LF
cQuery+= "AND SF2.D_E_L_E_T_!='*' " + LF
cQuery+= "AND SA1.D_E_L_E_T_!='*' " + LF
cQuery+= "AND SA4.D_E_L_E_T_!='*' " + LF
cQuery+= "ORDER BY F2_FILIAL, F2_DOC,F2_SERIE, F2_PREVCHG " + LF
MemoWrite("C:\Temp\WFFAT012.SQL", cQuery )
TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( 'AUUX', "F2_EMISSAO", "D")
TCSetField( 'AUUX', "F2_PREVCHG", "D")
TCSetField( 'AUUX', "F2_DTEXP", "D")

AUUX->(DbGoTop())


if !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT012","WFFAT012")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT012.htm")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF())
		aadd( oHtml:ValByName("it.cFilial") , iif(AUUX->F2_FILIAL = '01', "RAVA EMB", iif ( AUUX->F2_FILIAL = '03', 'RAVA CAIXAS', "") ) )                                            
	   	aadd( oHtml:ValByName("it.cDoc") , AUUX->F2_DOC + "/" + AUUX->F2_SERIE )    
	   	aadd( oHtml:ValByName("it.cCli") , AUUX->F2_CLIENTE+ '/' + AUUX->F2_LOJA + ' - '+AUUX->A1_NREDUZ)    
	   	//aadd( oHtml:ValByName("it.cTransp" ) , AUUX->A4_NREDUZ)    
	   	aadd( oHtml:ValByName("it.cEmissao" ) , DtoC(AUUX->F2_EMISSAO) )    
	   	aadd( oHtml:ValByName("it.cExp" ) , DtoC(AUUX->F2_DTEXP) )   
	   	aadd( oHtml:ValByName("it.cPrev" ) , DtoC(AUUX->F2_PREVCHG) )   
	   	
	AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user) 
	 eEmail := "regina@ravaembalagens.com.br;alcineide@ravaembalagens.com.br"
	 //eEmail += ";flavia.rocha@ravaembalagens.com.br"
	 oProcess:cTo := eEmail 

	 subj	:= "Notas Fiscais em Aberto"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail() 
endif
AUUX->(DbCloseArea())
Return