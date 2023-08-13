#include "rwmake.ch"
#include "TbiConn.ch"
//#include "TbiCode.ch"
#include "topconn.ch"

************************

User Function WFESTMIN()

************************

/*------------------------------------------------------------------------------
 * Declaracao de variaveis utilizadas no programa atraves da funcao            *
 * SetPrvt, que criara somente as variaveis definidas pelo usuario,            *
 * identificando as variaveis publicas do sistema utilizadas no codigo         *
 * Incluido pelo exassistente de conversao do AP5 IDE                          *
 *-----------------------------------------------------------------------------*/

conOut( "Iniciando programa WFESTMIN - Esmerino Toscano de Brito Neto " + Dtoc( Date() ) + ' - ' + Time() )

If Select( 'SX2' ) == 0
  // A rotina abaixo tem como finalidade preparar o ambiente caso não se execute o workflow
  // através de Menu
  RPCSetType( 3 ) // Não consome licensa de uso
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFESTMIN" Tables "SB1", "SB2"
  sleep( 5000 ) // aguarda 5 segundos para que as jobs IPC subam.
  conOut( "Programa WFESTMIN na emp. 02 filial 01 " + Dtoc( Date() ) + ' - ' + Time() )
Else
  conOut( "Programa WFESTMIN sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
EndIf

SetPrvt("OHTML,N_TERMINA,OPROCESS,CIND")
SetPrvt("CCHAVE,CFILTRO,eFaturamento,CPOVI,ACOND,AREGS_PROCESSADOS")
SetPrvt("NCOTACAO,LFORNENEW,NPOSFOR,NI,CEMAIL,AFORNEC")
SetPrvt("wvlr_tot")
SetPrvt("_NREC_ATUAL,_NI,NNUMEMAIL,NCOUNT,ITEM,_USER")
SetPrvt("TO,CC,BCC,SUBJ,SUBJECT,BODY")
SetPrvt("CODERETURN,CODETIMEOUT,")

/*-----------------------------------------------------------------------------+
 * Programa ESTMIN      º      Esmerino Neto      º      Data ³  16/06/2006    *
 +-----------------------------------------------------------------------------+
 *Objetivo   *Emitir e-mail para o Setor de Compras quando o Estoque m¡nimo do *
 *           *produto estiver alcancado                                        *
 *-----------------------------------------------------------------------------+
 * Uso       ³WorkFlow/AP7 - RAVA Embalagens                                   *
 *-----------------------------------------------------------------------------+
 | Starting  |Schedule / Menu                                                  |
 +-----------------------------------------------------------------------------+

/*-----------------------------------------------------------------------------+
 * Constructor do Objeto Processo                                              *
 +-----------------------------------------------------------------------------*/

//novas definicoes
//oHtml:= TWFHTML:New('d:\workflow\fontes\pmoris\pmpedcom.htm')
//oHtml:SaveToFile(\\minhanet\aaaaa)
//oHtml:SendMail(server_smtp, conta, destino, cc, bcc, suib)
//oHtml:= TWFHTML:New('d:\workflow\fontes\pmoris\pmpedcom.htm')
//oHtml:SaveToFile(\\minhanet\aaaaa)
//oHtml:SendMail(server_smtp, conta, destino, cc, bcc, suib)

/*-----------------------------------------------------------------------------+
 * Primeira vez                                                                *
 +-----------------------------------------------------------------------------*/

//if _nOpcao == Nil // entrada pelo schedule ou seja inicio de toda operacao

	aProds := {}
	lSinal := Nil

	// DBSelectArea("SF2")
	// DBSETORDER(1)
	// DBSEEK(XFILIAL("SF2") + SD2->D2_DOC + SD2->D2_SERIE)
	// nNFiscal := SF2->F2_DOC

	cQuery := "SELECT SB1.B1_COD, SB1.B1_DESC, SB1.B1_ESTSEG , SB2.B2_QATU, SB1.B1_UM "
	cQuery += "FROM SB1010 SB1, SB2020 SB2 "
	cQuery += "WHERE SB1.B1_COD = SB2.B2_COD AND SB1.B1_LOCPAD = SB2.B2_LOCAL "
	cQuery += "AND SB1.B1_ATIVO = 'S' "
	cQuery += "AND SB1.B1_ESTSEG <> 0 "
	cQuery += "AND SB2.B2_QATU <= SB1.B1_ESTSEG "
	cQuery += "AND LEN(SB1.B1_COD) <= 7 "
	//cQuery += "AND SB1.B1_TIPO NOT IN ('PA', 'PI', 'ME', 'MS', 'MP', 'AP', 'AM', 'FR', 'ST', 'OT', 'AE', 'AS', 'BS') "
	cQuery += "AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "AND SB2.B2_FILIAL = '" + xFilial( "SB2" ) + "' AND SB2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SB1.B1_COD "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SB1X"

	SB1X->( DbGoTop() )

	While ! SB1X->( EOF() )

		//If SB1X->B1_EMIN > 0
			aadd(aProds, {SB1X->B1_COD, SB1X->B1_DESC, Transform( SB1X->B1_ESTSEG, "@E 9,999.99" ), Transform( SB1X->B2_QATU, "@E 9,999.99" ), SB1X->B1_UM})
		//EndIf

		SB1X->( DbSkip() )

	EndDo

	SB1X->( DbCloseArea() )

	If Len( aProds ) > 0

		EnviaEmail()

	EndIf

conOut( "Finalizando programa WFESTMIN em " + Dtoc( DATE() ) + ' - ' + Time() )

RETURN  //main



************************

Static function EnviaEmail()

************************

	wvlr_tot := 0

	oProcess:=TWFProcess():New("ESTMIN","Estoque Minimo de Produtos")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\estmin.htm")
	oHtml   := oProcess:oHtml

	//eEmail := 'neto@ravaembalagens.com.br'
	//eCopia := 'neto@ravaembalagens.com.br'
	eEmail := 'compras@ravaembalagens.com.br; producao@ravaembalagens.com.br' // Definição de e-mail padrão
	//eCopia := 'informatica@ravaembalagens.com.br'

	//Itens
	oHtml:ValByName("it.cCodigo", {})
	oHtml:ValByName("it.cDesc"	, {})
	oHtml:ValByName("it.nEstmin", {})
	oHtml:ValByName("it.nEstatu", {})
	oHtml:ValByName("it.cUN"    , {})

	For nCount := 1 to Len(aProds)
		aadd(oHtml:ValByName("it.cCodigo")	, aProds[ncount,1])
		aadd(oHtml:ValByName("it.cDesc")		, aProds[ncount,2])
		aadd(oHtml:ValByName("it.nEstmin")	, aProds[ncount,3] )
		aadd(oHtml:ValByName("it.nEstatu")	, aProds[ncount,4] )
		aadd(oHtml:ValByName("it.cUN")			, aProds[ncount,5])
		//aadd(oHtml:ValByName("it.vlrtot") , TRANSFORM( aItens[nCount,7] ,'@E 9999,999.99' ))
		wvlr_tot ++
	Next
	//oHtml:ValByName("vlrtot",TRANSFORM( wvlr_tot,'@E 9999,999.99' ))
	oHtml:ValByName("vlrtot", wvlr_tot)

	// Start do WorkFlow
	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
	oProcess:cTo	:= eEmail
	//oProcess:cCC	:= eCopia
	subj	:= "Estoque Minimo de Produtos"
	oProcess:cSubject  := subj
	//oProcess:Body    := Body do Processo
	//oProcess:bReturn := "U_WF_265A(1)"   // oProcess:CodeReturn :=
	//oProcess:bTimeOut := { { "U_WF_265A(6)", 1, 1, 0 } }
	//oProcess:CodeTimeOut := { { "FuncaoTimeOut1", ddd, hh, mm } , ;
	//						   { "FuncaoTimeOut2", ddd, hh, mm } }
 	oProcess:Start()
	//RastreiaWF("00001"+'.'+oProcess:fTaskID,"000001",'1011',"Estoque Minimo de Produtos")
	WfSendMail()

	oProcess:Finish()
	conOut( "Acesso a rotina de envio de e-mails em: " + Dtoc( DATE() ) + ' - ' + Time() )

RETURN
