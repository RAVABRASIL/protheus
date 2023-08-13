#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบDesc.     ณ Atualiza lista de clientes para Cobranca                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Embalagens - Cobranca                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COBC014a()

SetPrvt( "dDULTDATA, nNUMTIT, nALTST, nNALTST, nREG, oNUMTIT, oNUMPROC, oALTST, oNALTST, oMETER, " )
SetPrvt( "nDIAS, cSTATUS, lALTEROU, oBTOK, oBTCANCEL, ")

cPerg := "COBC14"

ValidPerg()      

Pergunte(cPerg,.T.)               // Pergunta no SX1

@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Atualizar Cobranca"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC014   บAutor  ณMicrosiga           บ Data ณ  03/31/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OkProc()

Close(oDlg1)

//VARIAVEIS USADAS
If ! SX6->( DbSeek( "  MV_DTSTCLI" ) )   // Data da ultima atualizacao de status dos titulos
	CriarSX6( "MV_DTSTCLI", "D", "Data da ultima atualizacao de status dos titulos", Dtoc( dDATABASE - 1 ) )
EndIf

dULTDATA := GetMv( "MV_DTSTCLI" )

If dULTDATA >= dDATABASE
	MsgAlert( "Esta rotina ja foi executada em " + Dtoc( dULTDATA ) )
	Return NIL
EndIf

cCond := " SELECT TOP 1 ZZ7_DIAS "
cCond += " FROM "+RETSQLNAME("ZZ7") + " ZZ7 "
cCond += "   WHERE D_E_L_E_T_ <> '*' "
cCond += "   ORDER BY ZZ7_DIAS "
TCQUERY cCond ALIAS ZZ7N NEW

nMenorDia := ZZ7N->ZZ7_DIAS

ZZ7N->(DBCLOSEAREA())

dDiaBase := dDatabase - nMenorDia

For i := 1 to 2
	If i == 1
		cCond := " SELECT COUNT(E1_FILIAL) AS NUMTIT"
	Else
		cCond := " SELECT E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NATUREZ "
	Endif
	
	cCond += " FROM "+RETSQLNAME("SE1") + " SE1 "
	cCond += " WHERE SE1.E1_SALDO > 0 "
//	cCond += "   AND SE1.E1_CLIENTE+SE1.E1_LOJA = '10558 1' "
	cCond += " AND SE1.E1_VENCREA <= '"+DTOS(dDiaBase)+"' "
	cCond += " AND SE1.E1_TIPO NOT IN  ('AB-','RA','NCC','JP') "
	CcOND += " AND NOT (LEFT(SE1.E1_NUM,1) = 'L' AND RIGHT(RTRIM(SE1.E1_NATUREZ),2)='03' AND SE1.E1_VENCREA >= '"+DTOS(DdataBase)+"') " //Mudar regras
	cCond += " AND SE1.D_E_L_E_T_ = '' "
	
	TCQUERY cCond ALIAS SE1N NEW
	
	If i == 1
		nNUMTIT := SE1N->NUMTIT
		SE1N->(DBCLOSEAREA())
	Endif
Next

******** PREPARACAO DO AMBIENTE DA BASE DE DADOS **********
ZZ6->( DbSetOrder( 1 ) )
ZZ7->( DbSetOrder( 1 ) )
SE1->( DbSetOrder( 2 ) )

Dbselectarea("SE1N")

Processa( {|| Cobranca() } )

SE1N->(DbCloseArea())

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC014   บAutor  ณMicrosiga           บ Data ณ  11/24/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca()

/*

Informa็๕es sobre o SISCOB
ZZ6_TIPRET   - Tipo do retorno do cliente
1 - Agendado manualmente pelo usuario
2 - Automatico
3 - Agendado pelo Pre-Acordo

ZZ7_STATUS   - A terceira posicao do Status do titulo
1 - Status Negativo, cliente nao teve um contato positivo, continua na fila de cobranca
2 - Status Positivo, Cliente sai da fila de cobranca

*/


nNUMPROC := 0
nALTST   := 0
nNALTST  := 0

aSequen := {} //Array com as sequencias da fila de contato

//CLIENTE+LOJA, SALDO, PRIORI

//oBTOK:lReadOnly     := .T.
//oBTCANCEL:lReadOnly := .T.

If ! MSGBOX( "Titulos a Processar: " + Transform( nNumTit , "@E 9,999,999" ),"Aten็ใo", "YESNO" )
	Return
Endif

Dbselectarea("SE1N")
Dbgotop()
ProcRegua( nNUMTIT )

nIt := 0

While !SE1N->( Eof() )
	
	nIt ++
	
	IncProc( "1/3 Atualizando Titulos : " + Transform( nIt , "@E 99,999" )+" de "+Transform( nNUMTIT , "@E 99,999" ) )
	
	Dbselectarea("SE1")
	Dbsetorder(2)
	If Dbseek(xFilial()+SE1N->E1_CLIENTE+SE1N->E1_LOJA+SE1N->E1_PREFIXO+SE1N->E1_NUM+SE1N->E1_PARCELA+SE1N->E1_TIPO)
		
		//Cheque que nao esta em casa
		
		If TRIM(SE1N->E1_NATUREZ) $ "10103 , 10403" .And. SE1N->E1_TIPO <> "NF" //Mudar para naturezas usadas na Rava
			Dbselectarea("SE1N")
			dbskip()
			Loop
		Endif
		
		nDIAS    := dDATABASE - SE1->E1_VENCREA   // Dias de atraso
		nZZ7DIAS := 0
		cStatus  := '   '
		cPriori  := '   '
		
		Dbselectarea("ZZ7")
		Dbsetorder(1)
		If DbSeeK( XFILIAL( "ZZ7" ) + SE1N->E1_NATUREZ)
			While ZZ7->ZZ7_NATUR == SE1->E1_NATUREZ     // Le tabela de status( Time Line )
				If ( (ZZ7->ZZ7_DIAS > 0 .and. ZZ7->ZZ7_DIAS <= nDIAS .and. nDIAS > 0 ) .or. (ZZ7->ZZ7_DIAS < 0 .and. ZZ7->ZZ7_DIAS <= nDIAS .and. nDIAS < 0 ) ) ;
					.And. Subst(ZZ7->ZZ7_STATUS,3,1) == '1' //So trata status com contato negativo
//				If ZZ7->ZZ7_DIAS <= nDIAS .and. IIF(ZZ7->ZZ7_DIAS > 0, ZZ7->ZZ7_DIAS > nZZ7DIAS, ZZ7->ZZ7_DIAS < nZZ7DIAS) ;
//					.And. Subst(ZZ7->ZZ7_STATUS,3,1) == '1' //So trata status com contato negativo
					cSTATUS  := ZZ7->ZZ7_STATUS
					cPriori  :=	ZZ7->ZZ7_PRIORI
					nZZ7DIAS := ZZ7->ZZ7_DIAS
				Endif
				ZZ7->( DbSkip() )
			End
		Endif
		
		IF Empty(cPriori)
			cPriori  := '999'
		Endif
		
		If !Empty(cStatus) .And. Subst(cStatus,1,2) <> Subst(SE1->E1_STATCOB,1,2)
			Reclock( "SE1", .F. )
			SE1->E1_STATCOB := cSTATUS
			MsUnLock()
		Endif

		//Avalia se entra na fila de cobranca
		lEntraFila := .T.
		Dbselectarea("ZZ6")
		Dbsetorder(1)
		IF Dbseek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			//So entra na fila de cobranca se nao agendado
			If ZZ6->ZZ6_TIPRET <> '2' .And. ZZ6_RETORN >= dDatabase //Se for agendado
				lEntraFila := .F.
			Endif
		Endif
		//Entra na fila de cobranca se o contato do status for positivo e nao tiver agendamento
		//mas com a prioridade 999, independente do status/prioridade do titulo
		If Subst(SE1->E1_STATCOB,3,1) == '2' .Or. !lEntraFila
			cPriori := '999'
		Endif
		nPos := ASCAN(aSequen,{|X| X[1] = SE1->E1_CLIENTE+SE1->E1_LOJA })
		If nPos <> 0
			aSequen[nPos,2] := aSequen[nPos,2] + SE1->E1_SALDO
			//Se a prioridade deste titulo for menor que a que ja esta no array,
			//atualiza com a menor prioridade
			If cPriori < aSequen[nPos,3]
				aSequen[nPos,3] := cPriori
			Endif
		Else
			AADD(aSequen, { SE1->E1_CLIENTE+SE1->E1_LOJA , SE1->E1_SALDO , cPriori} )
		Endif
	Endif
	Dbselectarea("SE1N")
	Dbskip()
End

//Limpa lista de contatos (ZZ6_PRIORI e ZZ6_SEQUEN) e retorno agendado (ZZ6_RETORN)

Dbselectarea("ZZ6")
Dbsetorder(1)
nNumRegis := LastRec()
Dbgotop()
ProcRegua( nNumRegis )
nL := 0
While !Eof()
	nl ++
	IncProc( "2/3 - Limpando Prioridade : " + Transform( nL , "@E 99,999" )+" de "+Transform( nNumRegis , "@E 99,999" ) )
	dRetorno := ZZ6->ZZ6_RETORN
	cTipo    := ZZ6->ZZ6_TIPRET
	If ZZ6->ZZ6_TIPRET <> '2' //Se for agendado
		If aScan( ASequen ,{|X| X[1] = ZZ6->ZZ6_CLIENT+ZZ6->ZZ6_LOJA}) == 0 //Se nao encontrar
			
			cCond := " SELECT COUNT(E1_FILIAL) AS NUMTIT "
			cCond += " FROM "+RETSQLNAME("SE1") + " SE1 "
			cCond += " WHERE SE1.E1_SALDO > 0 "
			cCond += "   AND SE1.E1_VENCREA > '"+DTOS(dDataBase)+"' "
			cCond += "   AND SE1.E1_CLIENTE + SE1.E1_LOJA = '"+ZZ6->ZZ6_CLIENT+ZZ6->ZZ6_LOJA+"' "
			cCond += "   AND ( SE1.E1_NATUREZ = '10403' OR SE1.E1_NATUREZ = '10103' ) AND SE1.E1_ORIGEM <> 'FINA460' " //Mudar para naturezas usadas na Rava
			cCond += "   AND SE1.D_E_L_E_T_ = '' "
			
			TCQUERY cCond ALIAS SE1X NEW
			
			nNUMTIT := SE1X->NUMTIT
			SE1X->(DBCLOSEAREA())
			
			If Empty(nNUMTIT)
				dRetorno := dDataBase
				cTipo    := '2'
			EndIf
		Endif
	Endif
	Reclock("ZZ6",.F.)
	Replace ZZ6_RETORN With dRetorno
	Replace ZZ6_TIPRET With cTipo
	Replace ZZ6_SEQUEN With Space(4)
	Replace ZZ6_PRIORI With Space(3)
	msunlock()
	dbskip()
End

//Atualiza sequencia dos contatos na fila de cobranca
//Ordena array por prioridade e valor
aSort(aSequen,,,{|x,y| X[3]+STR(9999999999999-X[2]) < Y[3]+STR(9999999999999-Y[2]) })

ProcRegua( len(aSequen) )

For i:= 1 To len(aSequen)
	
	IncProc( "3/3 - Atualizando Cliente : " + Transform( I , "@E 99,999" )+" de "+Transform( len(aSequen) , "@E 99,999" ) )
	
	cClient := Subst(aSequen[i,1],1,6)
	cLoja   := Subst(aSequen[i,1],7,2)
	Dbselectarea("ZZ6")
	Dbsetorder(1)
	IF Dbseek(xFilial()+cClient+cLoja)
		Reclock("ZZ6",.F.)
		Replace ZZ6_SEQUEN With StrZero(i,4)
		Replace ZZ6_PRIORI With aSequen[i,3]
		If ZZ6->ZZ6_TIPRET == '2'//Se for automatico, so atualizo a data para retorno
			Replace ZZ6_RETORN With dDatabase
		Endif
		msunlock()
	Else
		RecLock( "ZZ6", .T. )
		Replace ZZ6_FILIAL With xFilial( "ZZ6" )
		Replace ZZ6_CLIENT With cClient
		Replace ZZ6_LOJA   With cLoja
		Replace ZZ6_RETORN With dDATABASE
		Replace ZZ6_SEQUEN With StrZero(i,4)
		Replace ZZ6_PRIORI With aSequen[i,3]
		Replace ZZ6_TIPRET With "2" //Automatico
		msunlock()
	Endif
Next

//Atualiza historico do dia
cQry := "SELECT ZZ6_PRIORI,COUNT(*) QTDATEN,"
cQry += " AGEND = (SELECT COUNT(*) "
cQry += " FROM "+RetSqlName("ZZ6")+" Z6"
cQry += " WHERE ZZ6_RETORN <= '"+dTos(dDatabase)+"' "
cQry += " AND ZZ6_TIPRET <> '2'"
cQry += " AND ZZ6_ULCONT < ZZ6_RETORN"
cQry += " AND Z6.D_E_L_E_T_ = ''"
cQry += " )"
cQry += " FROM "+RetSqlname("ZZ6")+" ZZ6,"+RetSqlname("ZZ7")+" ZZ7"
cQry += " WHERE ZZ6_PRIORI <> ''"
cQry += " AND ZZ6_PRIORI = ZZ7_PRIORI"
cQry += " AND ZZ7_TPSTAT = 'S'"
cQry += " AND SUBSTRING(ZZ7_NATUR,1,3) = '101'" //Mudar para naturezas usadas na Rava
cQry += " AND ZZ6.D_E_L_E_T_ = ''"
cQry += " AND ZZ7.D_E_L_E_T_ = ''"
cQry += " GROUP BY ZZ6_PRIORI"
cQry += " ORDER BY ZZ6_PRIORI"

TCQUERY cQry ALIAS HIST NEW

Dbselectarea("HIST")
dbgotop()

nAgend := HIST->AGEND

While !Eof()
	nAgend := HIST->AGEND
	Dbselectarea("ZA3")
	Reclock("ZA3", .T. )
	Replace ZA3_FILIAL  With xFilial()
	Replace ZA3_PRIOR   With HIST->ZZ6_PRIORI
	Replace ZA3_QTATEN  With HIST->QTDATEN
	Replace ZA3_DATA    With dDatabase
	msunlock()
	Dbselectarea("HIST")
	dbskip()
EndDo


//Cria registro para os agendados
Dbselectarea("ZA3")
Reclock("ZA3", .T. )
Replace ZA3_FILIAL  With xFilial()
Replace ZA3_PRIOR   With 'AGE'
Replace ZA3_QTATEN  With nAgend
Replace ZA3_DATA    With dDatabase
msunlock()

//Atualiza registro para cheques
cQry := "SELECT COUNT(DISTINCT E1_CLIENTE) CHEQUES"
cQry += " FROM "+RetSqlname("SE1")+" SE1 WITH(NOLOCK)"
cQry += " WHERE E1_SALDO > 0 AND E1_EMISSAO BETWEEN '"+DTOS(mv_par01-120)+"' AND '"+dTos(mv_par01)+"' "
cQry += " AND E1_NATUREZ IN ( '10103','10403' )" //Mudar para naturezas usadas na Rava
cQry += " AND E1_ORIGEM <> 'FINA460' AND SE1.D_E_L_E_T_ = '' AND ("
cQry += " EXISTS( SELECT ZZ6_FILIAL FROM "+RetSqlName("ZZ6")+" ZZ6 WITH(NOLOCK) "
cQry += " WHERE E1_CLIENTE = ZZ6_CLIENT AND ZZ6_ULCONT < E1_EMISSAO"
cQry += " AND ZZ6.D_E_L_E_T_ = '' ) OR"
cQry += " NOT EXISTS( SELECT ZZ6_FILIAL FROM "+RetSqlName("ZZ6")+" ZZ6 WITH(NOLOCK) "
cQry += " WHERE E1_CLIENTE = ZZ6_CLIENT "
cQry += " AND ZZ6.D_E_L_E_T_ = '' ) )"

TCQUERY cQry ALIAS CHQ NEW

Dbselectarea("CHQ")

//Cria registro para os agendados
Dbselectarea("ZA3")
Reclock("ZA3", .T. )
Replace ZA3_FILIAL  With xFilial()
Replace ZA3_PRIOR   With 'CHQ'
Replace ZA3_QTATEN  With CHQ->CHEQUES
Replace ZA3_DATA    With dDatabase
msunlock()

Dbselectarea("CHQ")
dbclosearea()

//Atualiza data da atualizacao da fila de cobranca
dbselectarea("SX6")
PutMv( "MV_DTSTCLI", dDATABASE )
Alert( "COBRANCA atualizada com Sucesso !!!" )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC014   บAutor  ณMicrosiga           บ Data ณ  11/24/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Sair


If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
	Return .T.
EndIf

Return .F.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  13/11/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Dt Base Fila Cheque ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return