#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAILORC º Autor ³ Eurivan Marques     º Data ³  22/05/07   º ±±
±±º                   º                                                  º ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera orçamento para envio de e-mail ou impressão via html. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MAILORC()

local nIpi := nTot := 0
private cPerg := "MAILOR"

ValidPerg(cPerg)

if Pergunte(cPerg, .T.)
	
	if MV_PAR01 = 1 .AND. !Empty(MV_PAR02)
		
		DbSelectArea("SCJ")
		DbSelectArea("SCK")
		
		SCK->(DbSetOrder(1))
		SCK->(DbSeek(xFilial("SCK")+SCJ->CJ_NUM, .T. ))
		
		oProcess:=TWFProcess():New( "REPCLI","Orcamento de Vendas" )
		oProcess:NewTask('Inicio',"\workflow\http\emp01\ORCAMENTO.htm")
		oHtml   := oProcess:oHtml
		eEmail  := MV_PAR02 //'eurivan@ravaembalagens.com.br'
		
		DbSelectArea("SA1")
		DbSetORder(1)
		SA1->(DbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
		oHtml:ValByName("cCli" , Alltrim( SA1->A1_NREDUZ ) )
		
		
		DbSelectArea("SE4")
		DbSetOrder(1)
		
		SE4->(DbSeek(xFilial("SE4")+SCJ->CJ_CONDPAG))
		
		oHtml:ValByName("cCond"     , SE4->E4_DESCRI )
		oHtml:ValByName("cValidade" , SCJ->CJ_VALIDA )
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		
		while !SCK->(EOF()) .AND. SCK->CK_NUM = SCJ->CJ_NUM
			SB1->(DbSeek( xFilial("SB1")+SCK->CK_PRODUTO ) )
			aadd( oHtml:ValByName("it.cod")	, SCK->CK_PRODUTO )
			aadd( oHtml:ValByName("it.desc")	, SB1->B1_DESC )
			aadd( oHtml:ValByName("it.qtd")  , Transform( SCK->CK_QTDVEN, "@E 9,999,999.99" ) )
			aadd( oHtml:ValByName("it.preco"), Transform( SCK->CK_PRCVEN, "@E 9,999,999.99" ) )
			aadd( oHtml:ValByName("it.ipi")  , Transform( SB1->B1_IPI   , "@E 99" )+"%" )
			aadd( oHtml:ValByName("it.total"), Transform( SCK->CK_VALOR , "@E 9,999,999.99" ) )
			nTot += SCK->CK_VALOR
			nIpi += ((SCK->CK_VALOR*SB1->B1_IPI)/100)
			SCK->(DbSkip())
		end
		
		oHtml:ValByName( "total" , Transform( nTot, "@E 9,999,999.99" ) )
		oHtml:ValByName( "vlripi", Transform( nIpi, "@E 9,999,999.99" ) )
		oHtml:ValByName( "totger", Transform( nTot+nIpi, "@E 9,999,999.99" ) )
		
		oHtml:ValByName( "cEmissao", Str(Day(SCJ->CJ_EMISSAO))+" de "+MESEXTENSO(SCJ->CJ_EMISSAO)+" de "+Str(Year(SCJ->CJ_EMISSAO) ) )
		
		_user := Subs(cUsuario,7,15)
		oProcess:ClientName(_user)
		oProcess:cTo := eEmail
		
		if !Empty(MV_PAR03)
			oProcess:cCC	:= AllTrim(MV_PAR03)+";"
		endif
		if !Empty(MV_PAR04)
			oProcess:cCC	+= AllTrim(MV_PAR04)+";"
		endif
		if !Empty(MV_PAR05)
			oProcess:cCC	+= AllTrim(MV_PAR05)+";"
		endif
		if !Empty(MV_PAR06)
			oProcess:cCC	+= Alltrim(MV_PAR06)
		endif
		
		oHtml:ValByName( "cUsuario" , Alltrim(_user) )
		
		subj := "Orcamento de Vendas - Rava Emabalagens Ltda "
		oProcess:cSubject := subj
		oProcess:Start()
		WfSendMail()
		Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
		oProcess:Finish()
		
	elseif MV_PAR01 = 2
		
		U_ORCFAT()
		
	endif
endif
return



Static Function ValidPerg(cPerg)

PutSx1( cperg, '01', 'Geração     ?', '', '', 'mv_ch1', 'N', 01, 0, 1, 'C', '', '', '', '', 'mv_par01', 'E-mail'       , '', '', '' , 'Impressão'             , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'E-mail      ?', '', '', 'mv_ch2', 'C', 50, 0, 0, 'G', 'IIF(MV_PAR01=1,NAOVAZIO(),.T.)', '', '', '', 'mv_par02', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '03', 'Com copia1  ?', '', '', 'mv_ch3', 'C', 50, 0, 0, 'G', '', '', '', '', 'mv_par03', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '04', 'Com copia2  ?', '', '', 'mv_ch4', 'C', 50, 0, 0, 'G', '', '', '', '', 'mv_par04', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '05', 'Com copia3  ?', '', '', 'mv_ch5', 'C', 50, 0, 0, 'G', '', '', '', '', 'mv_par05', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '06', 'Com copia4  ?', '', '', 'mv_ch6', 'C', 50, 0, 0, 'G', '', '', '', '', 'mv_par06', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )

Return NIL
