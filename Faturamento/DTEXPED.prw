#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'AP5MAIL.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :31/03/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function DTEXPED()

Local cFiltraSF2    := ""
Local aIndexSF2		:= {}
Local dtApartir     := "20091117"

Local aCores := {{"Empty(F2_DTEXP)" , "BR_VERDE"   },;
                 {"!Empty(F2_DTEXP)", "BR_VERMELHO"}}

Private cCadastro	:= 'Notas Fiscais Saida'
Private aRotina:= {	{"Pesquisar" ,'AxPesqui', 0,1},;  //'Pesquisar'
                    {"Dt.Saída"  ,'U_MUDDAT()',0,3}} 
                    
Private bFiltraBrw	:= {|| Nil}	                    

//Set date brit

cFiltraSF2 := " DtoS(F2_EMISSAO) >= '" + dtApartir + "' "	 
//cFiltraSF2 += " .AND. (F2_SERIE = '0' .OR. LEN(F2_DOC) = 6) "
cFiltraSF2 += "  .AND. F2_SERIE = '0' " //.AND. Alltrim( F2_TRANSP ) <> '024' " //->05/04/10: Chamado 001551 - JOão Emanuel pediu para incluir esta transportadora (O MESMO).
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro, utilizando a funcao FilBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbSetOrder(1)
bFiltraBrw 	:= {|| FilBrowse( "SF2", @aIndexSF2, @cFiltraSF2 ) }
Eval(bFiltraBrw)

mBrowse(06,01,22,75,"SF2",,,,,,)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("SF2", aIndexSF2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a condicao de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbSetOrder(1)
dbClearFilter()
	
Return(Nil)



****************************************
User Function MUDDAT()
****************************************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private dDtExp     := CtoD("  /  /    ")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oGet1","oSay1","oSBtn1","oSBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
if !SF2->(EOF())
   dDtExp := SF2->F2_DTEXP
endif

oDlg1  := MSDialog():New( 226,432,315,718,"Nota Fiscal",,,.F.,,,,,,.T.,,,.F. )
oGrp1  := TGroup():New( 000,003,025,134,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGet1  := TGet():New( 008,064,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtExp",,)
oGet1:bSetGet := {|u| If(PCount()>0,dDtExp:=u,dDtExp)}

oSay1  := TSay():New( 009,009,{||"Data Saída:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSBtn1 := SButton():New( 028,076,1,{||MsAguarde({||Ok()},"Aguarde...","Processando Dados...")},oDlg1,,"", )

oSBtn1:bAction := {||Ok()}

oSBtn2 := SButton():New( 028,108,2,{||oDlg1:End()},oDlg1,,"", )
oSBtn2:bAction := {||oDlg1:End()}

oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ Ok()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
****************************
Static Function Ok()
****************************

local cMsg		:= ""
local cEspelho 	:= ""
local dDtEntr
Local cTransp 	:= ""
Local nRegistro := SF2->( Recno() )
Local cCodUser  := ""
Local eEmail	:= ""
Local cPedido   := "" 
Local lMostraPCli := .F.
Local cPedCLi   := ""
Local cTES      := "" 
Local cSuper    := ""
Local aAnexos	:= {}

If dDtExp == CtoD("  /  /    ")
	MsgAlert("A data será retirada!")
Else
	If dDtExp < dDatabase
		MsgBox("A Data de Saída não pode ser menor que a data de Hoje!")
		Return .F.
	Endif
EndIf

cCodUser := __CUSERID

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   eEmail := Alltrim(aUsua[1][14])  	     // e-mail 
Endif

eEmail := ""		//Chamado 001469 - João solicitou que retirasse o email dele da cópia.



//Calcula o prazo de entrega, para depois atualizar o F2_PREVCHG
dPrev	:= U_FATC005( SF2->F2_FILIAL,SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_TRANSP, SF2->F2_REDESP, SF2->F2_LOCALIZ )

//Atualiza o SF2 - F2_DTEXP
RecLock("SF2", .F.)
SF2->F2_DTEXP := dDtExp 
SF2->F2_PREVCHG := dPrev
SF2->(MsUnLock())

////////////////////////////////////////////////////////////////////////////////////////////
///SOLICITADO POR EURIVAN - ETAPAS PEDIDO VENDA
///FR - 15/10/13 - FLÁVIA ROCHA - IMPLEMENTAR HISTÓRICO DO PEDIDO A CADA ETAPA REALIZADA
///AQUI, QDO EXPEDIR A NF, IRÁ REGISTRAR NO HISTÓRICO ZAC
////////////////////////////////////////////////////////////////////////////////////////////
cPedVenda := ""
aPedVenda := {}
t := 1
DbSelectArea("SD2")
SD2->(DBSetorder(3))
If SD2->(Dbseek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ))
	While SD2->(!EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == SF2->F2_DOC ;
	 .and. SD2->D2_SERIE == SF2->F2_SERIE
	  	cPedVenda := SD2->D2_PEDIDO
	  	If Ascan(aPedVenda, cPedVenda) == 0
	  		Aadd(aPedVenda , cPedVenda)
	  	Endif
	  	SD2->(DBSKIP())
	Enddo
Endif

If Len(aPedVenda) > 0
	For t := 1 to Len(aPedVenda)	
	
		RecLock("ZAC", .T.)	             
		ZAC->ZAC_FILIAL := xFilial("SD2")	
		ZAC->ZAC_PEDIDO := aPedVenda[t]  //SD2->D2_PEDIDO
		ZAC->ZAC_STATUS := '04'  
		ZAC->ZAC_DESCST := "PRODUTO(S) EM TRANSPORTE"
		ZAC->ZAC_DTSTAT := dDtExp   //Date()
		ZAC->ZAC_HRSTAT := Time()
		ZAC->ZAC_USER   := __CUSERID //código do usuário que criou
		ZAC->(MsUnlock())
		
		SC5->(Dbsetorder(1))   
		If SC5->(Dbseek(xFilial("SC5") + aPedVenda[t] ))  //SD2->D2_PEDIDO ))
			RecLock("SC5", .F. )
			SC5->C5_STATUS := '04'  //'03'
			SC5->(MsUnlock())
		Endif
	Next	
ENDIF
//FR - 15/10/13
    
 
oDlg1:End()

If !Empty( SF2->F2_REDESP )
	cTransp := SF2->F2_REDESP
Else
	cTransp := SF2->F2_TRANSP
Endif

DbselectArea("SA3")
DbsetOrder(1)
If Alltrim(SF2->F2_VEND1) != "0255'
	If SA3->(Dbseek(xFilial("SA3") + SF2->F2_VEND1 ))
		eEmail := SA3->A3_EMAIL           //Chamado 001272 - Daniela - Solicitou incluir o email do representante/vendedor para também receber este e-mail
		cSuper := SA3->A3_SUPER
	Endif
	If Alltrim(cSuper) = '0315'       //FR - 30/04/13 - solicitado por Jacqueline
		eEmail += ";" + "vendas.sp@ravaembalagens.com.br"
	Endif 
	If Alltrim(cSuper) != '0256'
		DbsetOrder(1)
		SA3->(Dbgotop())
		If SA3->(Dbseek(xFilial("SA3") + cSuper ))
			eEmail += ";" + SA3->A3_EMAIL     //email do coordenador 			  
		Endif
	Endif                                                    
Endif

DbSelectArea("SA4")
DbSetORder(1)
SA4->(DbSeek(xFilial("SA4") + cTransp ))

DbSelectArea("SZZ")
DbSetOrder(1)
SZZ->(DbSeek(xFilial("SZZ") + cTransp + SF2->F2_LOCALIZ))

DbSelectArea("SA1")
DbsetORder(1)
SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))  

//FR - 08/05/2011
DbSelectArea("SD2")
SD2->(DBSETORDER(3))
If SD2->(Dbseek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ))
	cPedido := SD2->D2_PEDIDO
	//While !SD2->(EOF()) .AND. SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC == SF2->F2_DOC;
	//.and.  SD2->D2_SERIE == SF2->F2_SERIE
	 	cTES := SD2->D2_TES
	//Enddo
Endif

DbSelectArea("SC5")
DbsetORder(1)
If SC5->(DbSeek(xFilial("SC5")+ cPedido )) 	
	lMostraPCli := U_FATC017(  SC5->C5_OCCLI  )	
	cPedCli     := SC5->C5_OCCLI								
Endif
//FR



cMsg := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMsg += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMsg += '<head>'
cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMsg += '<title>Untitled Document</title>'
cMsg += '<style type="text/css">'
cMsg += '<!--'
cMsg += '.style1 {font-family: Arial, Helvetica, sans-serif}'
cMsg += '.style2 {font-family: Arial, Helvetica, sans-serif; font-size: 9px; }'
cMsg += '.style3 {font-size: 11px}'
cMsg += '.style4 {font-size: 16px}'
cMsg += '.style5 {font-size: 12px}'
cMsg += '.style7 {font-family: Arial, Helvetica, sans-serif; font-size: 11px; }'
cMsg += '.style9 {font-size: 12px; color: #FF0000; }'
cMsg += '.style13 {color: #009900}'
cMsg += '.style14 {font-size: 10px}'
cMsg += '.style15 {'
cMsg += '	color: #FF0000;'
cMsg += '	font-weight: bold;'
cMsg += '}'
cMsg += '.style16 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }'
cMsg += '.style17 {font-family: Arial, Helvetica, sans-serif; color: #009900;}'
cMsg += '-->'
cMsg += '</style>'
cMsg += '</head>'
cMsg += '<body>'
cMsg += '<p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'
cMsg += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="682"'
cMsg += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'
cMsg += '<p><span class="style1"><span class="style5"><strong>Cabedelo -</strong> <strong>PB,</strong> <strong>'+StrZero(Day(dDataBase),2)+' de '+MesExtenso(dDataBase)+' de '+Str(Year(dDataBase))+'</strong></span><br />'
cMsg += '</span></p>'
cMsg += '<table border="1" cellspacing="0" cellpadding="0">'
cMsg += '  <tr>'
cMsg += '    <td width="682" height="66" valign="top" class="style1"><div align="center"><strong><span class="style4">P&Oacute;S-VENDAS    / RAVA </span><br />'
cMsg += '        <span class="style5">INFORMATIVO DE FATURAMENTO DE PEDIDO DE COMPRA</span> <br />'
cMsg += '        <span class="style14">PROGRAMA&Ccedil;&Atilde;O DE ENTREGA DE ACORDO COM O PRAZO DA TRANSPORTADORA PARA SUA LOCALIDADE</span></strong> </div></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<p class="style1"><strong><span class="style5">Empresa / Cliente:&nbsp; '+SA1->A1_NREDUZ+'<br />'
cMsg += '    At.: Dep. de Compras/Sr.(a)&nbsp; '+SA1->A1_CONTATO+' <br />'
cMsg += '    <br />'
cMsg += '    <br />'
cMsg += '    Passamos dados abaixo em rela&ccedil;&atilde;o ao envio de sua mercadoria: <br />'
cMsg += '    Data do faturamento: '+StrZero(Day(SF2->F2_EMISSAO),2)+' de '+MesExtenso(SF2->F2_EMISSAO)+' de '+Str(Year(SF2->F2_EMISSAO))+'<br />'
cMsg += '    <strong>Data de  Sa&iacute;da: '+StrZero(Day(SF2->F2_DTEXP),2)+' de '+MesExtenso(SF2->F2_DTEXP)+' de '+Str(Year(SF2->F2_DTEXP))+'<br />'
cMsg += '    Transportadora:&nbsp;'+SA4->A4_NREDUZ+'<br />' //Incluir transportadora redespacho quando Cliente  Manaus / Boa Vista / Macapa
cMsg += '    Nota(s) Fiscal (is): '+SF2->F2_DOC+'<br />'
If lMostraPCli
	cMsg += '    Ordem de Compra Cliente: '+ cPedCli + '<br />'
Endif        

//colocado em 25/05/2011 por antonio

nSaldoNF:=SaldoNF(cPedido)
If nSaldoNF=0
   If QtdNF(cPedido)=1
      cMsg += '    Faturamento Total <br />'
   else
      cMsg += '    Saldo <br />'
   endif
else
   cMsg += '    Faturamento Parcial <br />'
Endif 

//

cMsg += '    Valor (es) total (is): R$ &nbsp; '+Transform(SF2->F2_VALBRUT,"@E 9,999,999,999.99")+'<br />'
//dDtEntr := U_CalcPrv(SF2->F2_DTEXP,SA4->A4_DIATRAB, SZZ->ZZ_PRZENT)
dDtEntr := U_CalPrv(SF2->F2_DTEXP,SA4->A4_DIATRAB, SZZ->ZZ_PRZENT)

cMsg += '    Previs&atilde;o de entrega: '+StrZero(Day(dDtEntr),2)+' de '+MesExtenso(dDtEntr)+' de '+Str(Year(dDtEntr))+'</strong></span><span class="style5"></span></p>'
cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="682">'
cMsg += '  <tr>'
cMsg += '    <td width="682" valign="top" class="style2"><p><br />'
cMsg += '        <span class="style5"><strong>Procuramos atender a todas as exig&ecirc;ncias, portanto    solicitamos que nos comuniquem as ocorr&ecirc;ncias de eventuais problemas como:    atraso na entrega, devolu&ccedil;&atilde;o de mercadorias, o n&atilde;o recebimento do boleto    banc&aacute;rio, o n&atilde;o recebimento de aviso de vencimento e caso haja solicita&ccedil;&atilde;o de    prorroga&ccedil;&atilde;o gentileza nos comunicar com 15 dias de anteced&ecirc;ncia ao    vencimento.</strong></span></p>'
cMsg += '      <p align="center"><span class="style5"><span class="style15"></span></span><span class="style3"><span class="style9"><strong>ATEN&Ccedil;&Atilde;O:</strong><br />'
cMsg += '        <strong><em><u>N&atilde;o aceitaremos devolu&ccedil;&atilde;o sem a pr&eacute;via    autoriza&ccedil;&atilde;o do nosso servi&ccedil;o de P&oacute;s-Vendas ao cliente.</u></em></strong> </span></span></p></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="647" valign="top" class="style1"><p>&nbsp;</p></td>'
cMsg += '  </tr>'
cMsg += '</table>' 
//FR - 25/07/12 - Solicitado por DANIELA : Aviso para não responder este informativo
cMsg += '<p align="center"><span class="style5"><span class="style15"></span></span><span class="style3"><span class="style9"><strong><em><u>ESTE É UM EMAIL AUTOMÁTICO DO SISTEMA, E NÃO DEVERÁ SER RESPONDIDO.</u></em></strong></span></span></p></td>'

//email do sac
cMsg += '<p class="style16"> Solicita&ccedil;&otilde;es de total  acompanhamento de entrega atrav&eacute;s do e-mail&nbsp; <a href="mailto:posvendas@ravaembalagens.com.br">posvendas@ravaembalagens.com.br</a> ou <a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a> ou 0800 014 2345.</p>'
//cMsg += '<p class="style16"> Solicita&ccedil;&otilde;es de total  acompanhamento de entrega atrav&eacute;s do e-mail&nbsp; <a href="mailto:posvendas@ravaembalagens.com.br">posvendas@ravaembalagens.com.br</a> ou <a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a> ou 0800 727 1915.</p>'
cMsg += '<table border="0" cellspacing="0" cellpadding="0" width="681">'
cMsg += '  <tr>'
cMsg += '    <td width="682" valign="top" class="style7"><div class="style5">'
cMsg += '      <p><strong>Obrigado por confiar em nossos servi&ccedil;os.&nbsp; Esperamos que as    mercadorias cheguem de acordo com seus desejos e nos declaramos prontos para    atender a qualquer reclama&ccedil;&atilde;o.</strong></p>'
cMsg += '    </div></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<p align="left" class="style7">&nbsp;<br />'
cMsg += '  <span class="style5"><strong>P&oacute;s-Vendas/Rava </strong></span></p>'
cMsg += '<table width="682" border="0" cellpadding="0" cellspacing="0">'
cMsg += '  <tr>'
cMsg += '    <td width="682"><div align="justify" class="style14"><span class="style17">Rua Jos&eacute; Ger&ocirc;nimo da  Silva Filho (Ded&eacute;), 66 &ndash; Renascer &ndash; Cabedelo - PB / CEP:58310-000 / Contato:(83) 30481315</span></div></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td><div align="justify" class="style14"><span class="style1"><a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a>&nbsp;<span class="style13"> -&nbsp;&nbsp;  Atendimento&nbsp; a&nbsp; Clientes&nbsp;  0800 014 2345&nbsp;&nbsp; &ndash;&nbsp;&nbsp;&nbsp; CNPJ: 41.150.160/0001-02&nbsp;&nbsp;&nbsp; -&nbsp;  Insc. Estadual:&nbsp; 16.100.765-1</span></span></div></td>'
//cMsg += '    <td><div align="justify" class="style14"><span class="style1"><a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a>&nbsp;<span class="style13"> -&nbsp;&nbsp;  Atendimento&nbsp; a&nbsp; Clientes&nbsp;  0800 727 1915&nbsp;&nbsp; &ndash;&nbsp;&nbsp;&nbsp; CNPJ: 41.150.160/0001-02&nbsp;&nbsp;&nbsp; -&nbsp;  Insc. Estadual:&nbsp; 16.100.765-1</span></span></div></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '</body>'
cMsg += '</html>'

If dDtExp == CtoD("  /  /    ")
	//se for tirar a data nao manda email.
Else
	MsgInfo("Em anexo a este E-mail para o cliente, será enviado também, o espelho da Nota Fiscal.", "INFORMAÇÃO" )
	
	cEspelho := U_FATR009( "SF2", nRegistro )
	
	//If !Empty(eEmail)
	//	eEmail += ";flavia.rocha@ravaembalagens.com.br"
	//Else
	//	eEmail := "flavia.rocha@ravaembalagens.com.br"
	//Endif
	
	//If Alltrim(cTES) $ "507/516/543/547"
		eEmail += ";comercial@ravaembalagens.com.br"
	//	eEmail += ";flavia.norat@ravaembalagens.com.br"
	//Endif
	//eEmail += ";flavia.rocha@ravaembalagens.com.br"
	
	If !Empty(SA1->A1_EMAIL)
	   //U_EnviaMail( Alltrim(SA1->A1_EMAIL),'Informativo de Faturamento',cMsg )
	   //U_Send2Mail( Alltrim(SA1->A1_EMAIL) , eEmail, 'Informativo de Faturamento',cMsg, cEspelho )
	   AADD(aAnexos,cEspelho)		
	   eEmail := eEmail + ";" + Alltrim(SA1->A1_EMAIL)	
		U_fEnvMail(eEmail, 'Informativo de Faturamento', cMsg, aAnexos, .T., .F.)
	Else
	   Alert( 'O e-mail não foi enviado ao cliente pois, o cadastro não está preenchido. Informar ao Pos-Vendas.')
	Endif
EndIf

Return

******************************************************************
User Function Send2Mail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= cAnexo
Local cFrom		:= GetMV( "MV_RELACNT" )
Local cDe		:= "rava@siga.ravaembalagens.com.br"


CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cDe;
	TO cMailTo;
	CC cEmailCc;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAttach RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	else
		MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )             



***************

Static Function SaldoNF(cNum)

***************
local cQry:=''
local nRet

cQry:="SELECT C6_NUM,SUM(C6_QTDVEN-C6_QTDENT) SALDO "
cQry+="FROM "+RetSqlName("SC6")+" SC6 "
cQry+="WHERE C6_NUM='"+cNum+"' "
cQry+= " and C6_FILIAL='"+xFilial('SC6')+"' "
cQry+="AND SC6.D_E_L_E_T_!='*' "
cQry+="GROUP BY C6_NUM     "

If Select("_TMPZ") > 0       ///FR - 24/05/11 - VERIFICAR SE O ALIAS JÁ ESTÁ ABERTO E FECHAR NA NOVA CONSULTA
	DbSelectArea("_TMPZ")    ///SENÃO, DÁ ERRO
	DbCloseArea()
Endif

TCQUERY cQry NEW ALIAS "_TMPZ" 

If ! _TMPZ->( EOF() )
   nRet:=_TMPZ->SALDO
endif 


Return nRet        


***************

Static Function QtdNF(cPedido)

***************
local cQry:=''
local nRet:=0

cQry:="SELECT COUNT(*) QTD FROM "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQry+="WHERE F2_FILIAL='"+XFILIAL('SF2')+"' AND F2_DOC IN (select D2_DOC  from "+RetSqlName("SD2")+" SD2 WITH (NOLOCK) "
cQry+="WHERE "
cQry+="F2_FILIAL='"+XFILIAL('SD2')+"' AND D2_PEDIDO='"+cPedido+"' "
cQry+="AND D2_SERIE!='' "
cQry+="AND SD2.D_E_L_E_T_!='*' "
cQry+="GROUP BY  D2_DOC,D2_SERIE) "
cQry+="AND SF2.D_E_L_E_T_!='*' "

If Select("_TMPY") > 0       
	DbSelectArea("_TMPY")    
	DbCloseArea()
Endif

TCQUERY cQry NEW ALIAS "_TMPY" 

If  _TMPY->( !Eof() )
    nRet:=_TMPY->QTD
EndIf

_TMPY->(DBCLOSEAREA())

Return nRet
