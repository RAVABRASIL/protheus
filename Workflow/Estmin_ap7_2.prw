#include "rwmake.ch"
#include "TbiConn.ch"
//#include "TbiCode.ch"
#include "topconn.ch"

************************

User Function WFESTM_2()

************************
x := 0
cPdt := ' '
/*------------------------------------------------------------------------------
 * Declaracao de variaveis utilizadas no programa atraves da funcao            *
 * SetPrvt, que criara somente as variaveis definidas pelo usuario,            *
 * identificando as variaveis publicas do sistema utilizadas no codigo         *
 * Incluido pelo exassistente de conversao do AP5 IDE                          *
 *-----------------------------------------------------------------------------*/

conOut( "Iniciando programa WFESTM_2" + Dtoc( Date() ) + ' - ' + Time() )

If Select( 'SX2' ) == 0
  // A rotina abaixo tem como finalidade preparar o ambiente caso não se execute o workflow
  // através de Menu
  RPCSetType( 3 ) // Não consome licensa de uso
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFESTM_2" Tables "SB1", "SB2", "SC7"
  sleep( 5000 ) // aguarda 5 segundos para que as jobs IPC subam.
  conOut( "Programa WFESTM_2 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
Else
  conOut( "Programa WFESTM_2 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
EndIf

SetPrvt("OHTML,N_TERMINA,OPROCESS,CIND")
SetPrvt("CCHAVE,CFILTRO,eFaturamento,CPOVI,ACOND,AREGS_PROCESSADOS")
SetPrvt("NCOTACAO,LFORNENEW,NPOSFOR,NI,CEMAIL,AFORNEC")
SetPrvt("wvlr_tot,TMP")
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

	aArr := aProds := {}
	lSinal := Nil

	// DBSelectArea("SF2")
	// DBSETORDER(1)
	// DBSEEK(XFILIAL("SF2") + SD2->D2_DOC + SD2->D2_SERIE)
	// nNFiscal := SF2->F2_DOC

	cQuery := "SELECT SB1.B1_COD, SB1.B1_DESC, SB1.B1_ESTSEG , SB1.B1_EMIN , SB2.B2_QATU, SB1.B1_UM "
	cQuery += "FROM " +retSqlName('SB1')+ " SB1, " +retSqlName('SB2')+ " SB2 "
	cQuery += "WHERE SB1.B1_COD = SB2.B2_COD AND SB1.B1_LOCPAD = SB2.B2_LOCAL "
	cQuery += "AND SB1.B1_ATIVO = 'S' AND B1_TIPO = 'ME' " 
	// B1_TIPO = 'ME' a pedido de lindenberg chamado 448
//	cQuery += "AND SB1.B1_ESTSEG <> 0 " //Comentei Eurivan 01/07/08
	cQuery += "AND SB2.B2_QATU <= SB1.B1_ESTSEG "
	cQuery += "AND SB1.B1_EMIN > 0 "	//Inclui Eurivan 01/07/08
	cQuery += "AND LEN(SB1.B1_COD) <= 7 "
	cQuery += "AND SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "AND SB2.B2_FILIAL = '" + xFilial( "SB2" ) + "' AND SB2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SB1.B1_COD "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SB1X"

	SB1X->( DbGoTop() )

	While ! SB1X->( EOF() )

		aArr := busca_sc7(SB1X->B1_COD)
		if len(aArr) >= 1
			aadd(aProds, {SB1X->B1_COD, SB1X->B1_DESC, Transform(SB1X->B1_EMIN, "@E 999,999.99"), Transform( SB1X->B1_ESTSEG, "@E 999,999.99" ), Transform( SB1X->B2_QATU, "@E 999,999.99" ),;
									  SB1X->B1_UM, aArr[1][1], aArr[1][2]})
		else
			aadd(aProds, {SB1X->B1_COD, SB1X->B1_DESC, Transform(SB1X->B1_EMIN, "@E 999,999.99"), Transform( SB1X->B1_ESTSEG, "@E 999,999.99" ), Transform( SB1X->B2_QATU, "@E 999,999.99" ),;
									  SB1X->B1_UM, 'S/P' , ' ' })
		endif

		SB1X->( DbSkip() )

	EndDo

	SB1X->( DbCloseArea() )

	If Len( aProds ) > 0

		EnviaEmail()

	EndIf

conOut( "Finalizando programa WFESTM_2 em " + Dtoc( DATE() ) + ' - ' + Time() )

RETURN  //main



************************
Static function EnviaEmail()
************************

	wvlr_tot := 0

	oProcess:=TWFProcess():New("ESTMIN","Estoque Minimo de Produtos")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\estmin2.htm")
	oHtml   := oProcess:oHtml

	//eEmail := 'lindenberg@ravaembalagens.com.br'
    //eEmail := 'josenilton@ravaembalagens.com.br'	
    eEmail := 'rodrigo.pereira@ravaembalagens.com.br'	
	
	//Itens
	oHtml:ValByName("it.cCodigo", {})
	oHtml:ValByName("it.cDesc"	 , {})
	oHtml:ValByName("it.cQtdsol", {})
	oHtml:ValByName("it.nEstmin", {})
	oHtml:ValByName("it.nEstatu", {})
	oHtml:ValByName("it.cUN"    , {})
	oHtml:ValByName("it.cCOD"   , {})
	oHtml:ValByName("it.cDATA"  , {})

	For nCount := 1 to Len(aProds)
		aadd(oHtml:ValByName("it.cCodigo")	, aProds[ncount,1])
		aadd(oHtml:ValByName("it.cDesc")		, aProds[ncount,2])
		aadd(oHtml:ValByName("it.cQtdsol")	, aProds[ncount,3])
		aadd(oHtml:ValByName("it.nEstmin")	, aProds[ncount,4])
		aadd(oHtml:ValByName("it.nEstatu")	, aProds[ncount,5])
		aadd(oHtml:ValByName("it.cUN")			, aProds[ncount,6])
		aadd(oHtml:ValByName("it.cCOD")			, aProds[ncount,7])
		aadd(oHtml:ValByName("it.dDATA")		, stod(aProds[ncount,8]))
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


**********
Static Function busca_sc7(cProduto)
**********

Local aArr2 := {}
x++
cPdt := cProduto
cQuery2 := "SELECT TOP 1 SC7.C7_NUM, SC7.C7_DATPRF, SC7.C7_EMISSAO "
cQuery2 += "FROM   "+ RetSqlName("SC7") + " SC7 "
cQuery2 += "WHERE  SC7.C7_PRODUTO = '" + alltrim(cProduto) + "' "
//cQuery += "and SC7.C7_ENCER != 'E' "
cQuery2 += "AND (SC7.C7_QUANT - SC7.C7_QUJE > 0) "
//cQuery2 += "AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND SC7.D_E_L_E_T_ != '*' "
cQuery2 += "AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND SC7.D_E_L_E_T_ != '*' "
cQuery2 += "ORDER BY SC7.C7_DATPRF DESC"
cQuery2 := ChangeQuery(cQuery2)
TCQUERY cQuery2 NEW ALIAS "TMP"
TMP->( DbGoTop() )

Do while ! TMP->( EoF() )
							//N. Pedid   Emissao
	aAdd(aArr2, {alltrim(TMP->C7_NUM), alltrim(TMP->C7_EMISSAO) })
	//TMP->C7_DATPRF,
	TMP->( DbSkip() )
EndDo

TMP->( DbCloseArea("TMP") )

Return aArr2


//Gera Solicitacao de Comrpas
***********************************
Static Function GERASOL(aCab,aItem)
***********************************

lMsErroAuto := .F.
/*
aCab:= {{"C1_NUM",GetSxeNum("SC1","C1_NUM"),NIL}}			
Aadd(aItem, {{"C1_ITEM",   "01",NIL},; 
			 {"C1_PRODUTO","999999999999999",NIL},; 
			 {"C1_QUANT",  1,NIL}})
				
Aadd(aItem, {{"C1_ITEM",   "02",NIL},; 
			 {"C1_PRODUTO","000000000000001",NIL},; 
			 {"C1_QUANT",  1,NIL}})
*/

MSExecAuto({|x,y,z| MATA110(x,y,z)},aCab,aItem,3) //Inclusao

Return lMsErroAuto


//Gera Ordem de Producao
**************************
static Function GERAOPD(aOP) 
**************************

lMsErroAuto := .F.

/*
aVetor:={ {"C2_NUM","000001",NIL},; 
          {"C2_ITEM","01",NIL},;
          {"C2_SEQUEN","001",NIL},;
          {"C2_PRODUTO",SB1->B1_COD,NIL},;
          {"C2_QUANT",20,NIL},;
          {"C2_DATPRI",ddatabase,NIL},;
          {"C2_DATPRF",ddatabase,NIL} }
*/

MSExecAuto( {|x,y| MATA650(x,y)}, aOP, 3 ) //Inclusao

return lMsErroAuto