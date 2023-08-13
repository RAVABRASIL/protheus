#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"


/*-----------------------------------------------------------------------------+
 * Programa REPCLI      º      Eurivan Candido    º      Data ³  13/04/2007    *
 +-----------------------------------------------------------------------------+
 *Objetivo   *Emitir e-mail com relacao de Clientes que compraram nos ultimos  *
 *           *12 meses e nao compraram no mes anterior.                        *
 *-----------------------------------------------------------------------------+
 * Uso       ³WorkFlow - RAVA Embalagens                                       *
 *-----------------------------------------------------------------------------+
 | Starting  |Schedule - SEMANALMENTE, TODO DOMINGO                            |
 +-----------------------------------------------------------------------------+*/

************************
User Function REPCLI()
************************

//if ( LastDay( Date() - 1 ) == Date() - 1 ) .or. Day(Date()) = 20 .or. Day(Date()) = 11
	conOut( " " )
  	conOut( "***************************************************************************" )
  	conOut( "Programa de envio de Lista de Clientes que não compraram no mês anterior.  " )
  	conOut( "***************************************************************************" )
  	conOut( " " )

    If Select( 'SX2' ) == 0
   	  RPCSetType( 3 )  //Nao consome licensa de uso
      PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "REPCLI" Tables "SA3", "SF2", "SA1"
   	  Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam
      ProcEmail()
    else
      ProcEmail()
    endif
//endif
Return


***************************
Static Function ProcEmail()
***************************

local cRep
local nAno
local nMes

local dDataDe
local dDataAte

private cMailRep


nAno     := Year(Date())
if Day(Date()) != 1//Day(Date()) = 20 .or. Day(Date()) = 11
   nMes     := Month(Date())-1
else
   nMes     := Month(Date())-2
endif   
dDataDe  := LastDay( Date() - 240 ) + 1  //Ultimos 6 meses
dDataAte := LastDay( StoD( StrZero(nAno,4) + StrZero(nMes,2) + StrZero(1,2) ) )

cQuery := "SELECT A3_SUPER, A3_GEREN, A3_COD, A3_EMAIL, A1_VEND, A3_NOME, A1_ULTCOM, "
cQuery += "(SELECT TOP 1 SUM(F2_VALMERC) F2_VALMERC "
cQuery += " FROM SF2020 "
cQuery += " WHERE F2_CLIENTE = A1_COD AND F2_EMISSAO BETWEEN '"+DTOS(dDataDe)+"' AND '"+DTOS(dDataAte)+"' AND D_E_L_E_T_ = '' "
cQuery += " GROUP BY F2_DOC, F2_EMISSAO "
cQuery += " ORDER BY F2_EMISSAO DESC) VALULT, "
cQuery += "(SELECT SUM(F2_VALMERC) F2_VALMERC "
cQuery += " FROM SF2020 "
cQuery += " WHERE F2_CLIENTE = A1_COD AND F2_EMISSAO BETWEEN '"+DTOS(dDataDe)+"' AND '"+DTOS(dDataAte)+"' AND D_E_L_E_T_ = '') VALACUM, "
cQuery += "A1_COD, A1_LOJA, A1_NOME, A1_TEL "
cQuery += "FROM SA1010 SA1, SA3010 SA3 "
cQuery += "WHERE A1_ULTCOM BETWEEN '"+DTOS(dDataDe)+"' AND '"+DTOS(dDataAte)+"' "
cQuery += "AND A1_VEND <> '' AND A1_ATIVO = 'S' AND A3_ATIVO = 'S' "
cQuery += "AND A1_VEND = A3_COD "

//cQuery += " AND A3_COD IN ('0096','0075','0151','0095','0183') " ///PARA TESTES, RETIRAR

cQuery += "AND SA1.D_E_L_E_T_ = ' ' "
cQuery += "AND SA3.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY A1_VEND, VALACUM DESC "
cQuery := ChangeQuery( cQuery )

TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( DbGoTop() )

while ! TMPX->( EoF() )
   cRep := TMPX->A1_VEND
	cMailRep := Alltrim( TMPX->A3_EMAIL )

	if Alltrim( cMailRep ) <> ''
		EnviaMail( cRep,TMPX->A3_SUPER, TMPX->A3_GEREN )
	else
		conOut( "ATENCAO: " + TMPX->A3_NOME + " com o campo A3_EMAIL em branco." )
	   TMPX->(DbSkip())
	endif	
end
TMPX->( DbCloseArea() )
	
return


************************
Static Function EnviaMail( cVend,cSuper, cGeren )
************************
local eEmail, cNomeRep, eCopia, _user, subj
local lOk      := .F.
local cDominio := "@ravaembalagens.com.br"
Local aSZ7     := {}
Local nMeta    := 0 
Local cNomeSuper := ""
Local cMailSuper := "" 
Local nPos		:= 0
oProcess := TWFProcess():New("REPCLI","Emails para Representantes")
oProcess:NewTask('Inicio',"\workflow\http\emp01\MAILREPCLI.htm")    //voltar
//oProcess:NewTask('Inicio',"\workflow\http\teste\MAILREPCLI.htm")

oHtml   := oProcess:oHtml
eEmail  := cMailRep // Definição de e-mail padrão
eCopia  := ""



SA3->(DBSETORDER(1))
If !Empty(cSuper)
	If SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cNomeSuper := SA3->A3_NOME
		cMailSuper := SA3->A3_EMAIL
	Endif                                     
Else 
	If SA3->(Dbseek(xFilial("SA3") + cGeren ))
		cNomeSuper := SA3->A3_NOME
		cMailSuper := SA3->A3_EMAIL
	Endif

Endif
///para evitar que na assinatura apareça o caracter " ( "
nPos := At("(", cNomeSuper)
If nPos > 0
	cNomeSuper := Substr(cNomeSuper,1,(nPos - 1) )
Endif
nPos := 0
///para evitar que na assinatura de email, mostre os outros emails gravados no cadastro do coordenador
///EX: no cadastro de Marcílio, consta o email de Janaina, separado por ";"
nPos := At(";", cMailSuper)
//MSGBOX("nPos: " + str(nPos))
If nPos > 0
	cMailSuper := Substr(cMailSuper,1,(nPos - 1) )
Endif


IF cSuper ='0244  ' // SARAIVA
   cMailSuper += ';janaina'+cDominio
ELSEIF cSuper ='0245  ' // FULGENCIO
   cMailSuper += ';marcos'+cDominio
ELSEIF cSuper ='0248  ' // JANDERLEY
   cMailSuper += ';josenildo'+cDominio
   cMailSuper += ';flavia.norat'+cDominio
ENDIF



eCopia := cMailSuper
//eCopia += ";flavia.rocha@ravaembalagens.com.br" //manter apenas pra verificar se deu certo, depois vou retirar

aSZ7    := meta2(TMPX->A3_COD)
nMeta   := meta(TMPX->A3_COD)

oHtml:ValByName("cRep"     , Alltrim(TMPX->A3_NOME) )
oHtml:ValByName("nAting"   , Transform(   nMeta, "@E 9,999,999.99" ) )//Valor atingido 

if len(aSZ7) > 0
   oHtml:ValByName("nMeta"    , Transform( aSZ7[2], "@E 9,999,999.99" ) ) //Valor da meta 
   oHtml:ValByName("cData"    , Transform( aSZ7[1], "@r 99/9999") )//Mês e ano da meta
   oHtml:ValByName("cPercent" , Transform( (nMeta/aSZ7[2])*100, "@E 999,999.99 %" ) )
endIf

cNomeRep := AllTrim(TMPX->A3_NOME)

while !TMPX->(EOF()) .AND. TMPX->A1_VEND = cVend
  	if TMPX->VALULT > 0 .AND. TMPX->VALACUM > 0 
     	lOk := .T.
     	aadd( oHtml:ValByName("it.dUComp")	, StoD( TMPX->A1_ULTCOM ) )
     	aadd( oHtml:ValByName("it.nVUComp")	, Transform( TMPX->VALULT, "@E 9,999,999.99" ) )
        aadd( oHtml:ValByName("it.nVAcum")  , Transform( TMPX->VALACUM, "@E 9,999,999.99" ) )
     	aadd( oHtml:ValByName("it.cCodigo"), Alltrim(TMPX->A1_COD) )
     	aadd( oHtml:ValByName("it.cCliente"), Alltrim(TMPX->A1_NOME) )
     	aadd( oHtml:ValByName("it.cFone")	, AllTrim(TMPX->A1_TEL) )
  	endif
   TMPX->(DbSkip())
end 

///solicitado por Marcílio em 10/04/11, 
///inserir no fim, a assinatura do respectivo coordenador do representante:
oHtml:ValByName("cNomeSuper"     , Alltrim(cNomeSuper) )
oHtml:ValByName("cMailSuper"     , Alltrim(cMailSuper) )

if lOk
	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
	//oProcess:cTo	:= +eCopia     
	oProcess:cTo	:= eEmail		//para o representante
	oProcess:cCC	:= eCopia       //com cópia ao coordenador
	//oProcess:cTo := "flavia.rocha@ravaembalagens.com.br" 
	
	subj	:= "Relação de Clientes: " + cNomeRep
	oProcess:cSubject  := subj
	conOut( "Acesso a rotina de envio de e-mails para " + cNomeRep + " em: " + Dtoc( DATE() ) + ' - ' + Time() )
 	oProcess:Start()
	WfSendMail()
	Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
endif
oProcess:Finish()

return

***************

Static Function meta(cCliente)

***************
Local cQuery := ""
Local nRet   := 0
Local dData  := iif( day(dDataBase) > 1, dDataBase, dDataBase - 1 )
cQuery := "select sum(D2_TOTAL) D2_TOTAL "
cQuery += "from   "+retSqlName('SF2')+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4 "
cQuery += "where  F2_FILIAL = '"+xFilial('SF2')+"' and D2_FILIAL = '"+xFilial('SD2')+"' and F4_FILIAL = '"+xFilial('SF4')+"' "
cQuery += "and F2_VEND1 in ('"+cCliente+"','"+alltrim(cCliente) +"VD'"+") "
cQuery += "and year(F2_EMISSAO) = '"+alltrim(str(year(dData)))+"' and month(F2_EMISSAO) = '"+alltrim(str(month(dData)))+"' "
cQuery += "and D2_DOC = F2_DOC and F4_CODIGO = D2_TES and  F4_DUPLIC = 'S' and F2_TIPO = 'N' "
cQuery += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS '_TMPZ'
_TMPZ->( dbGoTop() )
if !_TMPZ->( EoF() )
	nRet := _TMPZ->D2_TOTAL 
endIf
_TMPZ->( dbCloseArea() )
Return nRet

***************

Static Function meta2(cCliente)

***************
Local aRet   := { "", 0 }
Local dData  := iif( day(dDataBase) > 1, dDataBase, dDataBase - 1 )
Local cQuery := "select Z7_MESANO, Z7_VALOR from "+retSqlName("SZ7")+" where Z7_REPRESE = '"+cCliente+"' "+;
				"and Z7_FILIAL = '"+xFilial('SZ7')+"' and D_E_L_E_T_ != '*' "+;
				"and substring(Z7_MESANO,1,2) = '"+strzero(month(dData),2)+"' "+;
				"and substring(Z7_MESANO,3,6) = '"+alltrim(str(year(dData)))+"'  "
TCQUERY cQuery NEW ALIAS '_TMPY'
_TMPY->( dbGoTop() )
if _TMPY->( !EoF() )
   aRet := { _TMPY->Z7_MESANO, _TMPY->Z7_VALOR }
endIf
_TMPY->( dbCloseArea() )
Return aRet