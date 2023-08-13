#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch"

/*
//Programa: TMKC-Resp.prw
//Autoria : Flávia Rocha
//Data    : 08/10/09
//Objetivo: Mostrar browse dos atendimentos relativos ao responsável pelos mesmos.
// O responsável irá interagir com os atendimentos colocando uma data de resposta 
// e observação. Após esta ação, será enviado um email ao solicitante para conhecimento.
*/

*************************
User Function TMKCRESP()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFiltraSUD    := ""
Local aIndexSUD		:= {}
Local cNomeUser     := ""
Local aUsua			:= {}
Local cUsua			:= ""
Local aCampos		:= {}

Local aCores		:= {	{  'UD_DATA != " "' ,	'DISABLE'},;	// Atendimento respondido
							{  'UD_DATA =  " "' ,	'ENABLE' } }		// NF Não Expedida

Private cCadastro	:= "Solicitações de Atendimento"
Private bFiltraBrw	:= {|| Nil}	
							

Private aRotina		:= {	{"Pesquisar" ,	"AxPesqui"		,0,1},;	    // Pesquisar
							{"Visualizar",	"AxVisual"  	,0,2},;  	// Visualizar
							{"Responder" ,	"U_TMKCRe()"	,0,4},;	    // Responder
							{"Legenda"   ,	"U_TMKCLeg()"	,0,5}}	    // Legenda
						

cCodUser := __CUSERID

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
Endif


Aadd(aCampos, { SUD->UD_FILIAL,;		//1
				SUD->UD_CODIGO,;        //2
         		SUD->UD_ITEM,;			//3
         		SUD->UD_OPERADO } )     //9


cFiltraSUD:= "UD_OPERADO = '" + cCoduser + "'"	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro, utilizando a funcao FilBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SUD")
dbSetOrder(1)
bFiltraBrw 	:= {|| FilBrowse( "SUD", @aIndexSUD, @cFiltraSUD ) }
Eval(bFiltraBrw)

mBrowse(06,01,22,75,"SUD",,"SUD->UD_DATA",,,,)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("SUD", aIndexSUD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a condicao de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SUD")
dbSetOrder(1)
dbClearFilter()
	
Return(Nil)




******************************************************************************************************
User Function TMKCRe()
******************************************************************************************************

Local aAreaAtu	:= GetArea()
Local aAreaSUD	:= SUD->(GetArea())
Local dDataResp	:= CriaVar("UD_DATA",.F.,.F.)
Local cObsSUD	:= CriaVar("UD_OBS",.F.,.F.)
Local cFil      := ""
Local cAtend    := ""
Local cItemSUD  := ""
Local cEntidade := ""		//vai armazenar se é SA1 ou SA2
Local cSUDChave := ""		//vai armazenar o codigo+loja
Local cCliente  := ""
Local cLojaCli  := ""
Local dDtInclu
Local cHoraIni  := ""
Local cSUDResp  := SUD->UD_OPERADO
Local cNomeUser := ""


If !Empty(SUD->UD_DATA)
	Aviso(	cCadastro,;
				"O atendimento já foi respondido. Contate o Administrador.",;
				{"&Continua"},,;
				"Atendimento/Item: " + SUD->UD_CODIGO + "/" + SUD->UD_ITEM )
	Return(Nil)
EndIf

DEFINE MSDIALOG oDlg5 FROM 000,000 TO 370,590 TITLE "Resposta ao Atendimento" PIXEL

@ 005,007 SAY "Atendimento" 					OF oDlg5 PIXEL	//COLOR CLR_HBLUE
@ 012,003 TO 031,292 OF oDlg5 PIXEL
@ 017,007 MSGET SUD->UD_CODIGO					WHEN .F.	PICTURE PesqPict("SUD","UD_CODIGO")		OF oDlg5 SIZE 040,006 PIXEL

@ 005,157 SAY "Item" 							OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 017,157 MSGET SUD->UD_ITEM					WHEN .F.	PICTURE PesqPict("SUD","UD_ITEM")		OF oDlg5 SIZE 040,006 PIXEL

@ 035,007 SAY "Cliente/Loja" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 042,003 TO 061,292 OF oDlg5 PIXEL
cAtend   := SUD->UD_CODIGO
cItemSUD := SUD->UD_ITEM
cFil     := SUD->UD_FILIAL

//Esse bloco irá buscar pelo atendimento qual foi a Entidade (SA1 ou SA2) e trazer o nome
SUC->(Dbsetorder(1))
If SUC->(Dbseek(xFilial("SUC") + cAtend ))
	cEntidade := SUC->UC_ENTIDAD
	cSUDChave := SUC->UC_CHAVE
	dDtInclu  := SUC->UC_DATA
	cHoraIni  := SUC->UC_INICIO
Endif

cCliente := Substr(cSUDChave,1,6)
cLojaCli := Substr(cSUDChave,7,2)	
@ 045,007 MSGET cCliente						WHEN .F.	PICTURE PesqPict("SA1","A1_COD") 		OF oDlg5 SIZE 040,006 PIXEL
@ 045,050 MSGET cLojaCli						WHEN .F.	PICTURE PesqPict("SA1","A1_LOJA")		OF oDlg5 SIZE 010,006 PIXEL
@ 045,075 MSGET iif( cEntidade = "SA1",GetAdvFVal("SA1","A1_NOME",xFilial("SA1") + SA1->(cCliente + cLojaCli),1,0),;
					                  GetAdvFVal("SA2","A2_NOME",xFilial("SA2") + SA2->(cCliente + cLojaCli),1,0) ) ;
WHEN .F.	PICTURE PesqPict("SA1","A1_NOME")	OF oDlg5 SIZE 213,006 PIXEL

@ 065,007 SAY "Data Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 072,003 TO 091,292 OF oDlg5 PIXEL
@ 075,007 MSGET dDtInclu						WHEN .F.	PICTURE PesqPict("SUC","UC_DATA")		OF oDlg5 SIZE 040,006 PIXEL

@ 065,157 SAY "Hora Inclusão" 					OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 075,157 MSGET cHoraIni						WHEN .F.	PICTURE PesqPict("SUC","UC_INICIO")	    OF oDlg5 SIZE 040,006 PIXEL

PswOrder(1)
If PswSeek( cSUDResp, .T. )
	aUser  := PSWRET() 					 // Retorna vetor com informações do usuário
	cNomeUser  := Alltrim(aUser[1][2])   // Nome do usuário	
Endif

@ 095,007 SAY "Responsável pelo Atendimento" 	OF oDlg5 PIXEL //COLOR CLR_HBLUE
@ 102,003 TO 163,292 OF oDlg5 PIXEL
@ 105,007 MSGET cNomeUser						WHEN .F.	PICTURE "@!"					    OF oDlg5 SIZE 213,006 PIXEL

@ 120,007 SAY "Data para solução:" 				OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 126,007 MSGET dDataResp						WHEN .T.;
 VALID(!Empty( dDataResp ).And.dDataResp >= dDatabase .and. FdtValida(dDataResp)  ) PICTURE PesqPict("SUD","UD_DATA")	OF oDlg5 SIZE 040,006 PIXEL

@ 142,007 SAY "Observações: " 					OF oDlg5 PIXEL COLOR CLR_HBLUE
@ 149,007 MSGET cObsSUD							WHEN .T.	PICTURE "@S60"    				OF oDlg5 SIZE 273,006 PIXEL

DEFINE SBUTTON FROM 170,220 TYPE 1  ENABLE OF oDlg5 ACTION (nOpcA := 1,oDlg5:End())	//botão OK
DEFINE SBUTTON FROM 170,260 TYPE 2  ENABLE OF oDlg5 ACTION (nOpcA := 0,oDlg5:End())	//botão Cancela

ACTIVATE MSDIALOG oDlg5 CENTERED

If nOpca == 1
	
	dbSelectArea("SUD")
	dbSetOrder(1)
	//Procura o atendimento (itens) e grava a data de resposta		
	MsSeek(xFilial("SUD")+ cAtend + cItemSUD )
	While !Eof() .And. SUD->UD_FILIAL == xFilial("SUD") .And.;
					   SUD->UD_CODIGO == cAtend .And.;
					   SUD->UD_ITEM == cItemSUD
		
		RecLock("SUD",.F.)
		dDataResp		:= DataValida(dDataResp)
		SUD->UD_DATA	:= dDataResp
		SUD->UD_OBS  	:= cObsSUD				
		MsUnLock()

		dbSelectArea("SUD")
		dbSkip()
	EndDo
	
	U_ReagRESP( cFil, cAtend )
	U_TKRetornou( cAtend )	


EndIf

RestArea(aAreaSUD)
RestArea(aAreaAtu)

Return(Nil)



******************************************************************************************************
User Function TMKCLeg()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{	{"DISABLE",	"Atendimento já Respondido"} ,;
									{"ENABLE" ,	"Atendimento sem Resposta"}} )

Return .T.

//------------------------------------------------------------------------

**********************************
User Function TKRetornou(cAtendim)
**********************************



Local aAtend 	:= {}      
Local _nX    	:= 0 
Local lRespondeu:= .F.
Local cQuery	:= ""
Local aRespost	:= {}
Local cExecutor	:= ""
Local aUsuarios := {}
Local eEmail    := ""
Local cRemete   := ""
Local cDesti    := ""
Local cCC       := ""
Local cCorpoHTM := ""
Local cClihtm   := ""
Local cCodUser  := ""
Local cNomeDesti:= ""   // através de UC_OPERADO, irá armazenar o nome do operador que incluiu o atendimento,
						// para que possa ser enviado para ele, o email de resposta do atendimento


SetPrvt("OHTML,OPROCESS")


cQuery := " SELECT UD_FILIAL, UD_CODIGO, UD_ITEM, UD_OPERADO, UC_OPERADO "
cQuery += " ,UD_N1, UD_N2, UD_N3, UD_N4, UD_N5 "
cQuery += " ,UC_ENTIDAD, UC_CHAVE , UD_DATA, UD_OBS "
cQuery += " FROM "+RetSqlName("SUC")+ " SUC, " +RetSqlName("SUD") + " SUD "
cQuery += " WHERE UC_CODIGO = '" + cAtendim + "' "
cQuery += " AND UD_CODIGO = UC_CODIGO "
cQuery += " AND UC_FILIAL = '" + xFilial("SUC") + "' 
cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "
cQuery += " AND UD_DATA <> '' "
cQuery += " AND SUC.D_E_L_E_T_ = '' AND SUD.D_E_L_E_T_ = '' "
cQuery += " ORDER BY UD_CODIGO, UD_ITEM "

MemoWrite("C:\TK271B.SQL",cQuery) 
	
If Select("_SUDY") > 0
	DbSelectArea("_SUDY")
	DbCloseArea()
EndIf
	
TCQUERY cQuery NEW ALIAS "_SUDY" 

//**ATENÇÃO PARA O QUE SEGUE ABAIXO: ***
//UC_OPERADO - localizado no cabeçalho do atendimento, é o operador que incluiu

//UD_OPERADO - localizado nos itens do atendimento, é o operador responsável pelo atendimento, designado pelo operador
//incluiu o atendimento.


	_SUDY->(Dbgotop())	
	DbSelectArea( _SUDY->UC_ENTIDAD )
	DbSetOrder(1)
	DbSeek( xFilial( _SUDY->UC_ENTIDAD ) + AllTrim( _SUDY->UC_CHAVE ) )
	cClihtm := iif( _SUDY->UC_ENTIDAD =="SA1", SA1->A1_NOME, iif( _SUDY->UC_ENTIDAD == "SA2", SA2->A2_NOME,"") )
	
	SU7->(Dbsetorder(1))
	SU7->(Dbseek(xFilial("SU7") + _SUDY->UC_OPERADO ))
	cCodUser := SU7->U7_CODUSU
	
	PswOrder(1)
	If PswSeek( cCodUser, .T. )
		aUsuarios  := PSWRET() 					 	// Retorna vetor com informações do usuário		
		cNomeDesti := Alltrim(aUsuarios[1][2])     	// Nome do usuário
		eEmail     := Alltrim(aUsuarios[1][14])     // e-mail 
	Endif
	
	If !_SUDY->(Eof()) .AND. Alltrim(_SUDY->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5)) # ""	   
	   
	   While !_SUDY->(Eof())	        
	      aRespost := {}	      
	      
	         Aadd(aRespost, {_SUDY->UD_CODIGO,;      	// 1
	         				 _SUDY->UD_N1,;             // 2
	         				 _SUDY->UD_N2,;             // 3
	         				 _SUDY->UD_N3,;             // 4
	         				 _SUDY->UD_N4,;             // 5
	         				 _SUDY->UD_N5,;             // 6
	         				 _SUDY->UD_OPERADO,;        // 7
	         				 _SUDY->UC_ENTIDAD,;        // 8
	         				 _SUDY->UC_CHAVE,;          // 9
	         				 _SUDY->UD_ITEM,;           //10
	         				 _SUDY->UD_DATA,;           //11
	         				 _SUDY->UD_FILIAL,;         //12
	         				 _SUDY->UD_OBS    } )       //13
	         				 
	         _SUDY->(DbSkip())	         
	      
	   Enddo
	Endif
	
	cRemete  := "rava@siga.ravaembalagens.com.br"
	cDesti   := eEmail  
	cCC      := ""
	cAssunto := "Retorno a solicitação - Call Center"	
	cCorpoHTM := U_fGeraHTM(cNomeDesti,aRespost)	//Enviar para quem incluiu o atendimento e não para o cliente final
	
	U_EnviMail( cRemete, cDesti, cCC, cAssunto, cCorpoHTM )  //Envia o email com as informações do html
	


Return .T.



//-----------------------------------
User Function fGeraHTM(cDestino,aRespost)
//-----------------------------------

Local cBody   := ""
Local LF      := CHR(13)+CHR(10) 
Local cDtResp := ""

cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + LF
cBody += '<html xmlns="http://www.w3.org/1999/xhtml">' + LF
cBody += '<head>' + LF
cBody += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />' + LF
cBody += '<title>Call Center</title>' + LF
cBody += '</head>'+ LF
cBody += '	<title>Call Center</title>'+ LF
cBody += '	<style type="text/css">'+ LF
cBody += '	body{'+ LF
cBody += '		/*'+ LF
cBody += '		You can remove these four options '+ LF
cBody += '		*/'+ LF
cBody += '		background-repeat:no-repeat;'+ LF
cBody += '		font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;'+ LF
cBody += '		margin:0px;'+ LF
cBody += '	}'+ LF
cBody += '	#ad{'+ LF
cBody += '		padding-top:220px;'+ LF
cBody += '		padding-left:10px;'+ LF
cBody += '	}'+ LF
cBody += '    </style>'+ LF
cBody += '<style type="text/css">'+ LF
cBody += '#calendarDiv{'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	width:205px;'+ LF
cBody += '	border:1px solid #317082;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	background-color: #FFF;'+ LF
cBody += '	font-family:arial;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '	padding-bottom:20px;'+ LF
cBody += '	visibility:hidden;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv span,#calendarDiv img{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox,#calendarDiv .selectBoxOver{'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime,#calendarDiv .selectBoxTimeOver{	'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	padding:3px;'+ LF
cBody += '	margin:0px;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox{'+ LF
cBody += '	border:1px solid #E2EBED;		'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxOver{'+ LF
cBody += '	border:1px solid #FFF;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '	color: #FFF;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime{'+ LF
cBody += '	border:1px solid #317082;		'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTimeOver{'+ LF
cBody += '	border:1px solid #216072;	'+ LF
cBody += '	color: #216072;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar{'+ LF
cBody += '	height:16px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .activeDay{	/* Active day in the calendar */'+ LF
cBody += '	color:#FF0000;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	text-align:center;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	bottom:0px;'+ LF
cBody += '	width:201px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate div{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	width:72px;'+ LF
cBody += '	color:#FFF;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	right:0px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker{'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	border:1px solid #AAAAAA;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	left:0px;'+ LF
cBody += '	top:15px;'+ LF
cBody += '	z-index:1000;'+ LF
cBody += '	display:none;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv #monthSelect{'+ LF
cBody += '	width:70px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker div{'+ LF
cBody += '	float:none;'+ LF
cBody += '	clear:both;	'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	margin:1px;	'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearActive{'+ LF
cBody += '	background-color:#317082;'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	text-align:right;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar img{'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '/style>'+ LF

	
cBody += '<style type="text/css">'+ LF
cBody += '<!--'+ LF
cBody += '.style20 {font-family: Arial, Helvetica, sans-serif; font-size: 13px; }'+ LF
cBody += '.style21 {font-family: Arial, Helvetica, sans-serif}'+ LF
cBody += '.style22 {color: #FFFFFF}'+ LF
cBody += '.style26 {font-size: 14px}'+ LF
cBody += '-->'+ LF
cBody += '    </style>'+ LF
cBody += '</head>'+ LF
cBody += '<script language="JavaScript">'+ LF
/*-----------------------------------------------------------------------
Máscara para o campo data dd/mm/aaaa hh:mm:ss
Exemplo: <input maxlength="16" name="datahora" onKeyPress="DataHora(event, this)">
-----------------------------------------------------------------------*/
cBody += 'function Data(evento, objeto){'+ LF
cBody += '	var keypress=(window.event)?event.keyCode:evento.which;'+ LF
cBody += '	campo = eval (objeto);'+ LF
cBody += '	if (campo.value == "00/00/00")'+ LF
cBody += '	{'+ LF
cBody += '		campo.value="" '+ LF
cBody += '	}'+ LF

cBody += '	caracteres = "0123456789";'+ LF
cBody += "	separacao1 = '/';"+ LF
cBody += '	conjunto1 = 2;'+ LF
cBody += '	conjunto2 = 5;'+ LF
cBody += '	conjunto3 = 8;'+ LF
cBody += '	if ((caracteres.search(String.fromCharCode (keypress))!=-1) && campo.value.length < (8))'+ LF
cBody += '	{'+ LF
cBody += '		if (campo.value.length == conjunto1 )'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '		else if (campo.value.length == conjunto2)'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '	}'+ LF
cBody += '	else'+ LF
cBody += '		event.returnValue = false;'+ LF
cBody += '}'+ LF
cBody += '</script>'+ LF
//AQUI COMEÇA MESMO O HTML DA RAVA
cBody += '<body>'+ LF
cBody += '<form action="mailto:%WFMailTo%" method="POST" name="Form1" onsubmit="return Form1_Validator(this)">'+ LF
cBody += '  <p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'+ LF
cBody += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="695"'+ LF
cBody += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'+ LF
cBody += '<p class="style20">Prezado '+ cDestino +',</p>'+ LF
cBody += '<p class="style20"><strong>O(s) Problema(s) abaixo foi(ram) enviado(s) ao responsável pela ação, e o mesmo<br>'+ LF
cBody += ' já registrou resposta, conforme abaixo:</strong><br />'+ LF
cBody += '      <br />  '+ LF
cBody += '<table width="863" height="56" border="1">'+ LF
cBody += '  <tr>'+ LF
cBody += '    <td width="92" height="20" bgcolor="#00CC66"><span class="style9 style21 style22">Atendimento </span></td>'+ LF
cBody += '    <td width="68" bgcolor="#00CC66"><span class="style9 style21 style22">Item</span></td>'+ LF
cBody += '    <td width="587" bgcolor="#00CC66"><span class="style9 style21 style22">Problema</span></td>'+ LF
cBody += '    <td width="88" bgcolor="#00CC66"><span class="style9 style21 style22">Previs&atilde;o (dd/mm/aa) </span></td>'+ LF
cBody += '    <td width="587" bgcolor="#00CC66"><span class="style9 style21 style22">Obs.</span></td>' + LF
cBody += '    </tr>'+ LF
cBody += '  <tr>'+ LF

For _nX := 1 to Len(aRespost)	   
	   cBody += '    <td height="26"><span class="style7 style21 style26">' + aRespost[_nX,1] + '</span></td>'+ LF    //atendimento
	   cBody += '    <td><span class="style26">' + aRespost[_nX,10] + '</span></td>'+ LF                              //item
	   cBody += '    <td><span class="style7 style21 style26">' +;                                                   //problema
	   		iif(!Empty(aRespost[_nX,2]),     Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,2],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,3]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,3],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,4]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,4],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,5]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,5],"Z46_DESCRI"),"" )+;
		    iif(!Empty(aRespost[_nX,6]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespost[_nX,6],"Z46_DESCRI"),"" )  
	   cBody += '</span></td>'+ LF
	   
	   cDtResp := StoD( aRespost[_nX,11] )	   	   	   
	   cBody += '    <td><span class="style7 style21 style26">' + DtoC( cDtResp ) + '</span></td>'+ LF	     //dt.resposta
	   //cBody += '	<input name="%it.filial%" type="hidden"/>' + aRespost[_nX,12] + LF + ' </tr>'+ LF
	   cBody += '	 <td><span class="style7 style21 style26">' + aRespost[_nX,13] + '</span></td>' + LF     //Observação   
	   cBody += '    </span></td>'+ LF		
Next _nX


cBody += '</table>'+ LF
cBody += '<tr>'+ LF
cBody += '  <p>	  '+ LF
cBody += '  </p>'+ LF
cBody += '	<div id="debug"></div>'+ LF
cBody += '</form>'+ LF
cBody += '</body>'+ LF
cBody += '</html>'+ LF   



*************************************************************
User function EnviMail( cRemet, cDest, cCc, cAssunto, cBody )
*************************************************************


local cServidor		   := alltrim(GetMV("MV_RELSERV"))   //smtp.siga.ravaembalagens.com.br
local cConta   		   := alltrim(GetMV("MV_RELACNT"))   //rava@siga.ravaembalagens.com.br
local cSenhaa		   := alltrim(GetMV("MV_RELPSW"))    //admnet1311
local lEnviado		   := .F.
local lConectou	       := .F.
local cMailError	   := ""
Local lAutentica       := .T.



CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cSenhaa Result lConectou


If lConectou 

	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )

	SEND MAIL FROM cRemet ;
	To cDest ;
	Cc cCc ;
	SUBJECT	cAssunto ;
	Body cBody FORMAT TEXT;
	RESULT lEnviado
	
	
	If !( lEnviado )
		GET MAIL ERROR cMailError
		MsgBox("Nao foi possivel enviar o email."+chr(13)+chr(10)+;
		"Procure o Administrador da rede."+chr(13)+chr(10)+;
		"Erro retornado: " + cMailError )
	Else
	    MsgInfo("E-Mail enviado com sucesso!")			
	Endif
	

	DISCONNECT SMTP SERVER
Else
	// Se nao conectou ao servidor de email, avisa ao usuario
	GET MAIL ERROR _cMailError
	MsgBox("Nao foi possivel conectar ao Servidor de email."+chr(13)+chr(10)+;
	"Procure o Administrador da rede." + chr(13)+chr(10)+;
	"Erro retornado: "+ _cMailError )	

Endif

return lConectou .and. lEnviado  



*********************************
Static function FdtValida( dData )   
*********************************

Local lValeDT 		:= .F.
Local nDiaSemana 	:= 0

nDiaSemana := DOW( dData )

If nDiaSemana = 1
	MsgBox("A data informada é um Domingo, por favor, informe outra data!","Alerta")
	lValeDT := .F.
Elseif nDiaSemana = 7
	MsgBox("A data informada é um Sábado, por favor, informe outra data!","Alerta")
	lValeDT := .F.
Else
	lValeDT := .T.
Endif


return(lValeDT)
