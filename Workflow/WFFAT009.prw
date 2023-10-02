#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "
                   

*************

User Function WFFAT009()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT009" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT009 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT009 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT009 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec()

***************

LOCAL lOK:=.F.
Local cQuery:=' '
LOCAL dDataAte:=ddatabase-1

/*
cQuery:="SELECT  F2_PLIQUI,A1_MUN,A1_EST,F2_DOC, F2_VALBRUT, F2_CLIENTE,A1_NREDUZ,F2_LOJA,A4_NREDUZ,F2_EMISSAO, " + CHR(13) + CHR(10)
cQuery+="CAST( "+valtosql(ddatabase)+" - CONVERT(datetime,F2_EMISSAO,112)AS FLOAT) DIAS, F2_DTEXP DTEXP " + CHR(13) + CHR(10)
cQuery+="FROM SF2020 SF2,SA1010 SA1,SA4010 SA4 " + CHR(13) + CHR(10)
cQuery+="WHERE "  + CHR(13) + CHR(10)
cQuery+="F2_CLIENTE = A1_COD " + CHR(13) + CHR(10)
cQuery+="and F2_LOJA = A1_LOJA " + CHR(13) + CHR(10)
cQuery+="and F2_TRANSP = A4_COD " + CHR(13) + CHR(10)
//                               marco Zero
cQuery+="AND F2_EMISSAO BETWEEN '20101213' AND '"+DTOS(dDataAte)+"' " + CHR(13) + CHR(10)

//exclui notas para Rava Caixas
cQuery+="AND A1_CGC NOT LIKE ('41150160%') " + CHR(13) + CHR(10)

cQuery+="AND F2_DTEXP='' " + CHR(13) + CHR(10)
cQuery += " AND CAST( "+valtosql(ddatabase)+" - CONVERT(datetime,F2_EMISSAO,112)AS FLOAT) >= 1 " + CHR(13) + CHR(10)  //inserido por FR em 20/07/13
cQuery+="AND F2_SERIE!='' " + CHR(13) + CHR(10)
cQuery+="AND F2_TIPO='N' " + CHR(13) + CHR(10)
cQuery+="AND SF2.D_E_L_E_T_!='*' " + CHR(13) + CHR(10)
cQuery+="AND SA1.D_E_L_E_T_!='*' " + CHR(13) + CHR(10)
cQuery+="AND SA4.D_E_L_E_T_!='*' " + CHR(13) + CHR(10)
cQuery+="ORDER BY F2_DOC " + CHR(13) + CHR(10)
*/

cQuery:="SELECT F2_FILIAL,"
cQuery+="F2_SERIE, A3_NREDUZ, "
cQuery+="VOLUME=(CASE WHEN C5_VOLUME1 > 0 THEN C5_VOLUME1 ELSE F2_VOLUME1 END), "
cQuery+="F2_PLIQUI,A1_MUN,A1_EST,F2_DOC, F2_VALBRUT, F2_CLIENTE,A1_NREDUZ,F2_LOJA,A4_NREDUZ,F2_EMISSAO, "
cQuery+="DIAS,DTEXP,D2_PEDIDO "
cQuery+="FROM ( "
cQuery+="SELECT  F2_FILIAL, "
cQuery+="F2_SERIE, A3_NREDUZ, "

cQuery+="C5_VOLUME1=(SELECT SUM(C5_VOLUME1) FROM SD2020 SD2,SC5020 SC5 "
cQuery+="            WHERE D2_FILIAL = C5_FILIAL AND D2_FILIAL = F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2_PEDIDO=C5_NUM "
cQuery+="            AND SD2.D_E_L_E_T_='' AND SC5.D_E_L_E_T_=''), "

cQuery+="D2_PEDIDO=(SELECT DISTINCT D2_PEDIDO FROM SD2020 SD2 "
cQuery+="             WHERE D2_FILIAL = F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA "
cQuery+="             AND SD2.D_E_L_E_T_='' ), "

cQuery+="F2_VOLUME1,F2_PLIQUI,A1_MUN,A1_EST,F2_DOC, F2_VALBRUT, F2_CLIENTE,A1_NREDUZ,F2_LOJA,A4_NREDUZ,F2_EMISSAO, "
cQuery+="CAST( "+valtosql(ddatabase)+" - CONVERT(datetime,F2_EMISSAO,112)AS FLOAT) DIAS, F2_DTEXP DTEXP "
cQuery+="FROM SF2020 SF2 WITH (NOLOCK),SA1010 SA1 WITH (NOLOCK),SA4010 SA4 WITH (NOLOCK), SA3010 SA3 "
cQuery+="WHERE "
cQuery+="F2_CLIENTE = A1_COD "
cQuery+="and F2_LOJA = A1_LOJA  "
cQuery+="and F2_TRANSP = A4_COD  "
cQuery+="AND F2_EMISSAO BETWEEN '20101213' AND '"+DTOS(dDataAte)+"' "
cQuery+="AND A1_CGC NOT LIKE ('28924778%') "
cQuery+="AND A1_CGC NOT LIKE ('41150160%') "
cQuery+="and F2_VEND1 = A3_COD  "
cQuery+="AND F2_DTEXP='' "
cQuery+="AND CAST( "+valtosql(ddatabase)+" - CONVERT(datetime,F2_EMISSAO,112)AS FLOAT) >= 1 "
cQuery+="AND (F2_SERIE = '0' OR LEN(F2_DOC) = 6) "
cQuery+="AND F2_TIPO='N' "
cQuery+="AND SF2.D_E_L_E_T_!='*' "
cQuery+="AND SA1.D_E_L_E_T_!='*' "
cQuery+="AND SA4.D_E_L_E_T_!='*' "
cQuery+="AND SA3.D_E_L_E_T_!='*' "
cQuery+=") AS TABX "
cQuery+="ORDER BY F2_FILIAL, F2_DOC  "


MemoWrite("C:\TEMP\WFFAT009.SQL", cQuery )
TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( 'AUUX', "F2_EMISSAO", "D")

AUUX->(DbGoTop())


if !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT009","WFFAT009")
	//oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT009.html")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WFFAT009.html")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF())                    
	   aadd( oHtml:ValByName("it.cDoc") , AUUX->F2_FILIAL+' - '+ AUUX->F2_DOC+' - '+ AUUX->D2_PEDIDO)    
	   aadd( oHtml:ValByName("it.cCli") ,  AUUX->A1_EST+' - '+AUUX->F2_CLIENTE+' - '+AUUX->A1_NREDUZ)    
	   aadd( oHtml:ValByName("it.cLoja" ) , AUUX->F2_LOJA)    
	   aadd( oHtml:ValByName("it.cTransp" ) , AUUX->A4_NREDUZ)    
	   aadd( oHtml:ValByName("it.cUF" ) , AUUX->A1_EST)     
   	   aadd( oHtml:ValByName("it.cMunicipio" ) , AUUX->A1_MUN)    
	   aadd( oHtml:ValByName("it.cEmissao" ) , AUUX->F2_EMISSAO)    
	   aadd( oHtml:ValByName("it.cDias" ) , AUUX->DIAS)    
	   aadd( oHtml:ValByName("it.nVolume" ) , Transform(AUUX->VOLUME, "@E 999,999,999.99"))    
	   aadd( oHtml:ValByName("it.cPesoLiqui" ) , Transform(AUUX->F2_PLIQUI, "@E 999,999,999.99"))   
	   aadd( oHtml:ValByName("it.nValNF" ) , Transform(AUUX->F2_VALBRUT, "@E 999,999,999.99"))    
	   aadd( oHtml:ValByName("it.cVend" ) , AUUX->A3_NREDUZ)    

	
	AUUX->( DBSKIP() )
	enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 
	 oProcess:cTo := "comercial@ravaembalagens.com.br"
	 oProcess:cTo += ";faturamento@ravaembalagens.com.br"
	 oProcess:cTo += ";wagner.querino@ravaembalagens.com.br"	         
	 //FR - Flavia Rocha - em 02/09/11 Daniela solicitou que enviasse para o email dela e não do posvendas.
	 //oProcess:cTo += ";licitacao@ravaembalagens.com.br"
	 //oProcess:cTo += ";vendas.sp@ravaembalagens.com.br"
	 //oProcess:cTo += ";joao.emanuel@ravaembalagens.com.br"
	 //oProcess:cTo += ";antonio.nascimento@ravaembalagens.com.br"
	 ///solicitado por Glennyson em 08/01/13:
	 oProcess:cTo += ";francisco.pereira@novaindustrial.com.br"
	 //oProcess:cTo += ";adriano.paz@ravaembalagens.com.br"
	 oProcess:cTo += ";marcelo@ravaembalagens.com.br"
	 oProcess:cTo += ";flavia@ravaembalagens.com.br"
	 oProcess:cTo += ";contabilidade@ravaembalagens.com.br"
	 //oProcess:cTo += ";wagner.cabral@ravaembalagens.com.br"
	 oProcess:cTo += ";joao.emanuel@ravaembalagens.com.br"
	 
	 oProcess:cTo += ";eronides.estevam@ravabrasil.com.br"
	 
 	//oProcess:cTo += ";antonio.ferreira@ravabrasil.com.br"

	 oProcess:cTo += ";jhonatan.cavalcante@ravabrasil.com.br" // adicionado por Thiago Em 30-08-2023
	 
	 oProcess:cTo += ";roberta.gomes@ravaembalagens.com.br" //
     
     //oProcess:cTo := "antonio.feitosa@ravabrasil.com.br" // teste 
     
	 subj	:= "Notas que nao foram expedidas no mesmo Dia"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail() 
endif
AUUX->(DbCloseArea())
Return
