#include "rwmake.ch"
#include "TbiConn.ch"
#include "topconn.ch"

*************
User Function WFBAIXAS()
*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFBAIXAS" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa WFBAIXAS na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  BAIXAS()
Else
  conOut( "Programa WFBAIXAS sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  BAIXAS()
EndIf
conOut( "Finalizando programa WFBAIXAS em " + Dtoc( DATE() ) + ' - ' + Time() )
//Msgbox( "Finalizando programa WFBAIXAS em " + Dtoc( DATE() ) + ' - ' + Time() )

return

***************
Static Function BAIXAS()
***************

Local   cFatura := cAnter := cQuery := ''
Local   nTotal  :=  0
Local   aVetor  := { }
Local	aTam    := { } 
Local 	nAtraso	:= 0
Private aTotal  := { }
aTam := TamSx3("E1_NUM")

begin Transaction

cQuery += " Select SEA.E1_CLIENTE, SEA.E1_NUM, SEA.E1_PREFIXO, SEA.E1_VALOR, SEA.E1_NATRASO "
cQuery += " From " + retSqlName("SE1") + " SEA "
//cQuery += "where SEA.E1_FILIAL + SEA.E1_PREFIXO + SEA.E1_PARCELA + SEA.E1_TIPO + SEA.E1_NATUREZ = '01UNI9NF 21005     ' "
cQuery += " Where Rtrim(SEA.E1_FILIAL ) = '01'  "
cQuery += " and   Rtrim(SEA.E1_PREFIXO) = 'UNI' "
cQuery += " and   Rtrim(SEA.E1_PARCELA) = '9'   "
cQuery += " and   Rtrim(SEA.E1_TIPO)    = 'NF'  "
cQuery += " and   Rtrim(SEA.E1_NATUREZ) = '21005' "
cQuery += " and ( "
cQuery += " select sum(SEB.E1_VALOR) "
cQuery += " from " + retSqlName("SE1") + " SEB "
//cQuery += "where SEB.E1_FILIAL + SEB.E1_PREFIXO + SEB.E1_PARCELA + SEB.E1_TIPO + SEB.E1_NATUREZ = '01UNI9NF 21005     ' "
cQuery += " Where Rtrim(SEB.E1_FILIAL ) = '01'  "
cQuery += " and   Rtrim(SEB.E1_PREFIXO) = 'UNI' "
cQuery += " and   Rtrim(SEB.E1_PARCELA) = '9'   "
cQuery += " and   Rtrim(SEB.E1_TIPO)    = 'NF'  "
cQuery += " and   Rtrim(SEB.E1_NATUREZ) = '21005' "
cQuery += "and   SEB.E1_CLIENTE = SEA.E1_CLIENTE "
cQuery += "and SEB.D_E_L_E_T_ != '*' and SEB.E1_SALDO > 0 "
cQuery += ") > 50 "
//cQuery += ") > 1 "
cQuery += "and SEA.D_E_L_E_T_ != '*' and SEA.E1_SALDO > 0 "
cQuery += "order by SEA.E1_CLIENTE "
//MemoWrite("\Temp\FBAIXAS.SQL", cQuery )  

If Select("_TMPX") > 0
	DbSelectArea("_TMPX")
	DbCloseArea()	
EndIf 
TCQUERY cQuery NEW ALIAS "_TMPX"

_TMPX->( dbGoTop() )
cAnter := _TMPX->E1_CLIENTE
cFatura	:= Soma1( GetMv("MV_NUMFAT"),  aTam[1])
cFatura	+= Space(aTam[1] - Len(cFatura))
Do While SE1->( dbSeek( xFilial("SE1") + "UNI" + cFatura + "0", .F. ) )
	cFatura := Soma1(cFatura)
EndDo

If _TMPX->( !EoF() )
	aAdd(aTotal, { _TMPX->E1_CLIENTE, cFatura, 0, "" } )
EndIf

Do While _TMPX->( !EoF() )
	aVetor := {}
	lMsErroAuto := .F.
	aVetor := {{"E1_PREFIXO"  ,"UNI"             ,Nil},;
	           {"E1_NUM"	  ,_TMPX->E1_NUM     ,Nil},;
	           {"E1_PARCELA"  ,"9"               ,Nil},;
	           {"E1_TIPO"	  ,"NF "             ,Nil},;
	           {"AUTMOTBX"	  ,"FAT"             ,Nil},;
	           {"AUTDTBAIXA"  ,dDataBase         ,Nil},;
	           {"AUTDTCREDITO",dDataBase         ,Nil},;
	           {"AUTHIST"	  ,'Baixa Automatica WF',Nil},;
	           {"AUTVALREC"	  ,_TMPX->E1_VALOR   ,Nil}}
	MSExecAuto({|x,y| fina070(x,y)},aVetor,3)
	If lMsErroAuto
	   conOut( "ERRO NAS BAIXAS!!! WFBAIXAS em " + Dtoc( DATE() ) + ' - ' + Time() )
	   _TMPX->( dbCloseArea() )	   
	   EnviaMail( 2 )
       DisarmTransaction()
	   return
	Else
		conOut( "BAIXAS OK!!! WFBAIXAS em " + Dtoc( DATE() ) + ' - ' + Time() )
	Endif
	if cAnter == _TMPX->E1_CLIENTE
	
	    nAtraso := _TMPX->E1_NATRASO
	    		
    	aTotal[ aScan( aTotal, { |X| X[1] == _TMPX->E1_CLIENTE } ) ][3] += _TMPX->E1_VALOR //TOTALIZA AS COBRANÇAS DE UM CLIENTE
    	//aTotal[ aScan( aTotal, { |X| X[1] == _TMPX->E1_CLIENTE } ) ][4] += "<br>Nota : " +_TMPX->E1_NUM+ " Valor :" + alltrim(str(_TMPX->E1_VALOR))//10/10/08
    	aTotal[ aScan( aTotal, { |X| X[1] == _TMPX->E1_CLIENTE } ) ][4] += "<br>Nota : " +_TMPX->E1_NUM+ " Valor :" + alltrim(str(_TMPX->E1_VALOR)) ;
    	 + IIF( nAtraso > 0 , " -> Dias Atraso : " + Str(nAtraso) , "" )
	else
	    nAtraso := _TMPX->E1_NATRASO
	    
	    putMV( "MV_NUMFAT", cFatura )
		cAnter  := _TMPX->E1_CLIENTE
		cFatura	:= Soma1( GetMv("MV_NUMFAT"),  aTam[1])
		cFatura	+= Space(aTam[1] - Len(cFatura))
		//aAdd(aTotal, { _TMPX->E1_CLIENTE, cFatura, _TMPX->E1_VALOR, "<br>Nota : " +_TMPX->E1_NUM+ " Valor : " + alltrim(str(_TMPX->E1_VALOR)) } )//10/10/08
		aAdd(aTotal, { _TMPX->E1_CLIENTE, ;
						cFatura,;
						_TMPX->E1_VALOR,;
						"<br>Nota : " +_TMPX->E1_NUM+ " Valor : " + alltrim(str(_TMPX->E1_VALOR)) ;
						+ iif( nAtraso > 0 , " -> Dias Atraso : " + Str(nAtraso) , "" ) } )
	endIf
	recLock("SE1",.F.)                                                  
	SE1->E1_FATPREF := "UNI"
	SE1->E1_FATURA  := cFatura
	SE1->E1_DTFATUR := dDataBase
	SE1->E1_FLAGFAT := "S"
	SE1->E1_TIPOFAT := "NF "
	msUnlock()
	_TMPX->( dbSkip() )
endDo
if len(aTotal) > 0
	putMV( "MV_NUMFAT", cFatura )
	INSERE( aTotal )
endIf
_TMPX->( dbCloseArea() )
end Transaction
Return

***************
Static Function INSERE( aTotal )
***************
Local aVetor  := {}
lMsErroAuto   := .F.    
for _xc := 1 to len( aTotal )
	aVetor  := {{"E1_PREFIXO" ,"UNI"           ,Nil},;
				{"E1_NUM"	  ,aTotal[_xc][2]  ,Nil},; //Nº da nota
				{"E1_PARCELA" ,"0"             ,Nil},;
				{"E1_TIPO"	  ,"NF "           ,Nil},;
				{"E1_CLIENTE" ,aTotal[_xc][1]  ,Nil},; //Código do cliente
				{"E1_NATUREZ" ,"21005"         ,Nil},;
				{"E1_LOJA"	  ,"01"            ,Nil},;
				{"E1_EMISSAO" ,dDataBase       ,Nil},;
				{"E1_VENCTO"  ,dDataBase + 20  ,Nil},;//O chamado 528 solicitou 20 dias para vencimento.
				{"E1_VALOR"	  ,aTotal[_xc][3]  ,Nil},; //Total R$
				{"E1_HIST"	  ,'Ttlz. Automatica WF',Nil},;
				{"E1_CODORCA" ,"WFBAIXAS"      ,Nil}}
	MSExecAuto({|x,y| Fina040(x,y)},aVetor,3)
	If lMsErroAuto
		conOut( "(Insere) - ERRO NAS BAIXAS!!! WFBAIXAS em " + Dtoc( DATE() ) + ' - ' + Time() )
 	    DisarmTransaction()
   	    EnviaMail( 2 )
		return
	Else
		conOut( "(Insere) - BAIXAS OK!!! WFBAIXAS em " + Dtoc( DATE() ) + ' - ' + Time() )
	Endif
next
EnviaMail( 1 )
SendMail()
Return

**********************************
Static Function EnviaMail( nOpt )
**********************************

Local cEmailTo      := iif(nOpt == 1, "financeiro@ravaembalagens.com.br","informatica@ravaembalagens.com.br")
//Local cEmailTo      := iif(nOpt == 1, "flavia.rocha@ravaembalagens.com.br", "flavia.rocha@ravaembalagens.com.br" ) 
Local aHist         := {}
Local cEmailCc      := ""
Local lResult       := .F.
Local cError        := "ERRO NO ENVIO DO EMAIL"
Local cUser
Local nAt
Local cMsg          := ""
Local cAccount      := GetMV( "MV_RELACNT" )
Local cPassword     := GetMV( "MV_RELPSW"  )
Local cServer       := GetMV( "MV_RELSERV" )
Local cAttach       := ""
Local cAssunto      := iif(nOpt == 1, "BAIXAS AUTOMÁTICAS DO PÓS-VENDAS", "ERRO NA BAIXA AUTOMÁTICA DO PÓS-VENDAS")
Local cFrom         := GetMV( "MV_RELACNT" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 cEmailCc := ""                                  
                                                                      
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

cMsg := "<b>BAIXA AUTOMÁTICA DAS "+"MULTAS"+" POR ATRASO DE ENTREGA. </b><br> <br> "

cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
cMsg += "De: WORKFLOW MICROSIGA <br> <br>"
cMsg += "Para: "+iif(nOpt == 1,"Setor Financeiro","Informática")+" <br> <br>"
cMsg += "INFORMATIVO <br> <br>"

if nOpt == 1
	cMsg += "Informamos que foi executado com sucesso a baixa automática dos títulos das multas por atraso de entrega.<br>"
	cMsg += "Confira a seguir os títulos que foram inseridos no contas a receber e que devem ser cobrados: <br> <br>"
	for e := 1 to len(aTotal)
		cMsg += "Cliente: "+aTotal[e][1]+"-"+Posicione( "SA1", 1, xFilial("SA1") + aTotal[e][1], "A1_NREDUZ" )+"  Nota Fiscal: "+aTotal[e][2]+"  Valor: "+ alltrim( str( aTotal[e][3] ) ) +" <br>"
		//cMsg += "Abaixo as notas que geraram esse débito, segundo o setor de pós-vendas:"
		//chamado 1960 - alterar de pós-vendas para SAC
		cMsg += "Abaixo as notas que geraram esse débito, segundo o setor SAC:"
        cMsg += aTotal[e][4]
        cMsg += "<br>"
	next
else
	cMsg += "ATENÇÃO!!! HOUVE ERRO NA BAIXA DOS TÍTULOS DO CONTAS A RECEBER!!!<br> "
	cMsg += "Confira os títulos que não foram baixados: <br> <br> "
	_TMPX->( dbGoTop() )
	Do while _TMPX->( !EoF() )
		cMsg += " Cliente:" + _TMPX->E1_CLIENTE + " N. Fiscal: " + _TMPX->E1_NUM + " Valor: " + transform(_TMPX->E1_VALOR,"@E 999,999.99") + " <br>"
		_TMPX->( dbSkip() )
	endDo
endIf

if lResult
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )
	SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult
	
	if !lResult
		GET MAIL ERROR cError	
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	GET MAIL ERROR cError
endif
Return(lResult)

******************************

Static Function SendMail()

******************************

Local cEmailCc  	:= ""
Local aHist         := {}
Local cEmailTo  	:= "alcineide@ravaembalagens.com.br"
//Local cEmailTo  	:= "flavia.rocha@ravaembalagens.com.br"
Local lResult   	:= .F.
Local cError    	:= "ERRO NO ENVIO DO EMAIL"
Local cUser
Local nAt
Local cMsg      	:= ""
Local cAccount		:= GetMV( "MV_RELACNT" )
Local cPassword	    := GetMV( "MV_RELPSW"  )
Local cServer		:= GetMV( "MV_RELSERV" )
Local cAttach 		:= ""
Local cAssunto		:= "Débito junto à Rava Embalagens Ind. e Com. Ltda."
Local cFrom			:= GetMV( "MV_RELACNT" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

for e := 1 to len(aTotal)
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
	cMsg := "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
	cMsg += "De: Rava Embalagens (siga) <br> <br>"
	cMsg += "Para: " + Posicione( "SA1", 1, xFilial("SA1") + aTotal[e][1], "A1_NREDUZ" ) + " <br> <br>"
	cMsg += "INFORMATIVO <br> <br>"
	cMsg += "Informamos que há um débito por atraso de entrega junto à Rava Embalagens, favor entrar em contato <br>"
	cMsg += "o mais rápido possível. <br><br>"
	cMsg += "  Nota Fiscal: "+aTotal[e][2]+"  Valor: "+ alltrim( str( aTotal[e][3] ) ) +" <br>"
	//chamado 1960 - alterar de pós-vendas para SAC
	//cMsg += "Abaixo as notas que geraram esse débito, segundo o setor de pós-vendas:"
	cMsg += "Abaixo as notas que geraram esse débito, segundo o setor SAC:"
	cMsg += aTotal[e][4]
	cEmailCc := Posicione( "SA1", 1, xFilial("SA1") + aTotal[e][1], "A1_EMAIL" )
	if lResult
		MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )
		SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult

		if !lResult
			GET MAIL ERROR cError
		endIf

		DISCONNECT SMTP SERVER

	else
		GET MAIL ERROR cError
	endif
	Sleep( 5000 )
next

Return(lResult)

***************

Static Function wordWrap( cText, nRegua )

***************

Local aRet  := {}
Local cTemp := ''
Local i	    := 1

cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( alltrim( cTemp ) ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet