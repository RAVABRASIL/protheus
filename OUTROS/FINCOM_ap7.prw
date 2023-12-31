#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/05/03
#INCLUDE "MATA530.CH"
//#INCLUDE "PROTHEUS.CH"

User Function FINCOM()        // incluido pelo assistente de conversao do AP5 IDE em 29/05/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CCADASTRO,NOPCA,ACA,ASAYS,ABUTTONS,AROTINA")
SetPrvt("NREGISTRO,CVENDANT,NVLRCOMIS,CPREFIXO,CNUMERO,CPARCELA")
SetPrvt("CNATUREZA,CTIPO,NHDLPRV,CARQUIVO,NTOTAL,CPADRAO")
SetPrvt("LPADRAO,LDIGITA,LMSE2530,LFILTRO,CFILTERUSER,NIRRF")
SetPrvt("NISS,NINSS,CLOTE,DVENCTO,ODLG,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � MATA530  � Autor � Eduardo Riera         � Data � 02/01/98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿔nformar e Atualizar data de pagamento da comissao dos      낢�
굇�          쿣endedores.                                                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cCadastro := OemToAnsi(STR0003) //"Atual. Pag. de Comiss꼘     "
nOpca     := 0
aCA       := { OemToAnsi(STR0001),OemToAnsi(STR0002)}  //"Confirma"###"Abandona"
aSays     := {}
aButtons  := {}

PRIVATE aRotina :={	{"","AxPesqui"	,0 , 1},;
	{"","AxVisual"	,0 , 2},;
	{"","AxInclui"	,0 , 3},;
	{"","AxAltera"	,0 , 4},;
	{"","AxDeleta"	,0 , 5} }  // Somente para contabilizacao

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                     �
//� mv_par01            // Gerar pela(Emissao/Baixa/Ambos)   �
//� mv_par02            // Considera da data                 �
//� mv_par03            // ate a data                        �
//� mv_par04            // Do Vendedor                       �
//� mv_par05            // Ate o vendedor                    �
//� mv_par06            // Data de Pagamento                 �
//� mv_par07            // Gera ctas a Pagar (Sim/Nao)       �
//� mv_par08            // Contabiliza on-line               �
//� mv_par09            // Mostra lcto Contabil              �
//� mv_par10            // Vencimento de                     �
//� mv_par11            // Vencimento Ate                    �
//� mv_par12            // Considera data (Vencto/Pagamento) �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Pergunte("MTA530",.F.)
AADD(aSays,OemToAnsi( STR0004 ) ) //"      Este programa tem como objetivo solicitar e atualizar"
AADD(aSays,OemToAnsi( STR0005 ) ) //"a data para pagamento das comiss봢s dos Vendedores.        "
AADD(aButtons, { 5,.T.,{|| Pergunte("MTA530",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, If( CA530Ok(), o:oWnd:End(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	If ( mv_par08 == 1 .And. __TTSInUse )
		Help(" ",1,"MATA530TTS")
	Else
		Processa({|lEnd| fa530Processa()})
	EndIf
Endif
Return(.T.)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿯a530Proce� Autor � Eduardo Riera         � Data � 02/01/98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿛rocessa                                                    낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

// Substituido pelo assistente de conversao do AP5 IDE em 29/05/03 ==> Function fa530Processa()
Static Function fa530Processa()

Local nRegistro := 0
Local cVendAnt  := ""
Local nVlrComis := nVlrComisUNI := 0
Local cPrefixo  := ""
Local cNumero   := ""
Local cParcela  := ""
Local cNatureza := ""
Local cTipo     := ""
Local nHdlPrv   := 0
Local cArquivo  := ""
Local nTotal    := 0
Local cPadrao   := "510"
Local lPadrao   := VerPadrao( cPadrao )
Local lDigita   := If( mv_par09==1, .T., .F. )
Local lMSE2530	 := ( existblock( "MSE2530" ) )
Local dVencto
Local lFiltro	 := .T.
Local cFilterUser := " "
Local nIrrf	 := 0
Local nIss	 := 0
Local nInss	 := 0

Private cLote := ""

LoteCont( "FIN" )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Ponto de entrada para Filtrar os vendedores conforme parame- �
//� tros dos clientes (Empresa)                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

IF EXISTBLOCK("M530FIL")
	cFilterUser	:=	EXECBLOCK("M530FIL",.f.,.f.)
ENDIF

ProcRegua(SE3->(RecCount())) // Regua

dbSelectArea("SE3")
dbSetOrder(3)
dbSeek(cFilial+mv_par04,.T.)

While ( !Eof() .And. E3_FILIAL == cFilial .AND. E3_VEND <= mv_par05 )
	cVendAnt := SE3->E3_VEND
	IncProc()
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Considera filtro do usuario                                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !Empty(cFilterUser).and.!(&cFilterUser)
		lFiltro := .F.
	Endif
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Filtrar as condicoes selecionadas                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If ( SE3->E3_EMISSAO >= mv_par02 .And. SE3->E3_EMISSAO <= mv_par03 .And.;
			If( mv_par01 == 1, SE3->E3_BAIEMI == "E" , .T. ) .And.;
			If( mv_par01 == 2, SE3->E3_BAIEMI == "B" , .T. ) .And.;
			Empty(E3_DATA) ) .and. SE3->E3_VENCTO >= mv_par10 .And.;
			SE3->E3_VENCTO <= mv_par11 .and. lFiltro

		Begin Transaction
			dVencto := If( mv_par12 == 1,SE3->E3_VENCTO, mv_par06 )
			RecLock( "SE3", .F. )
			SE3->E3_DATA := dVencto
			MsUnLock()
		End Transaction

		if SE3->E3_PREFIXO = "UNI"
		   nVlrComisUNI += ( SE3->E3_COMIS/2 )
		   nVlrComis    += ( SE3->E3_COMIS/2 )
		else
   		nVlrComis += SE3->E3_COMIS
   	endif

	EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Aqui e' gerado o Tit. a Pagar (SE2) para o Vendedor.         �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SE3")
	dbSkip()
	If ( cVendAnt != SE3->E3_VEND .And. ( nVlrComis != 0 .or. nVlrComisUNI != 0 ) .And. MV_PAR07 == 1)
		BEGIN TRANSACTION
			dbSelectArea("SA3")
			dbSetOrder(1)
			dbSeek(xFilial("SA3")+cVendAnt,.F.)
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SA3->A3_FORNECE+SA3->A3_LOJA,.F.)
			If ( !Found() )
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial()+GetMv("MV_FORNCOM"),.F.)
				If ( !Found() .And. SA3->A3_GERASE2 == "S" )
					dbSelectArea("SA2")
					RecLock("SA2",.T.)
					SA2->A2_FILIAL := xFilial()
					SA2->A2_COD    := SubStr(GetMV("MV_FORNCOM"),1,6)
					SA2->A2_LOJA	:= SubStr(GetMV("MV_FORNCOM"),7,2)
					SA2->A2_NOME	:= "VENDER"
					SA2->A2_NREDUZ := "VENDER"
					SA2->A2_BAIRRO := "."
					SA2->A2_MUN 	:= "."
					SA2->A2_EST 	:= "."
					SA2->A2_END 	:= "."
					MsUnlock()
				EndIf
				dbSeek(xFilial()+GetMv("MV_FORNCOM"),.F.)
			EndIf
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial("SED")+SA2->A2_NATUREZ,.F.)
			If ( Found() )
				cNatureza := SA2->A2_NATUREZ
			Else
				cNatureza := ""
			EndIf
			If SA3->(Found()) .And. SA2->(Found()) .and. SA3->A3_GERASE2 == "S"
				cPrefixo   := &(GetMv("MV_3DUPREF"))
				cNumero    := SubStr(Dtos(MV_PAR06),3)
				cTipo      := If ( nVlrComis > 0 .or. nVlrComisUNI > 0 , "DP " , left(MV_CPNEG,3) )
				cParcela   := GetMv("MV_1DUP")
				dbSelectArea("SE2")
				dbSetOrder(6)
				dbSeek(xFilial("SE2")+SA2->A2_COD+SA2->A2_LOJA+cPrefixo+cNumero+cParcela+cTipo,.F.)
				While ( SE2->(Found()) )
					If ( cParcela == "Z" )
						cParcela := GetMv("MV_1DUP")
						cNumero  := Soma1(cNumero,Len(SE2->E2_NUM))
					EndIf
					cParcela := Soma1(cParcela,Len(SE2->E2_PARCELA))
					dbSeek(xFilial("SE2")+SA2->A2_COD+SA2->A2_LOJA+cPrefixo+cNumero+cParcela+cTipo,.F.)
				EndDo

				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Aqui s�o calculados os impostos sobre a comiss�o do Vendedor.�
				//� Para tal, � necess쟲io que, no fornecedor utilizado para o   �
				//� titulo de comiss�o esteja cadastrada natureza que calcule    �
				//� impostos.                                                    �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

				nIrrf := 0
				nIss	:= 0
				nInss := 0

				If !Empty( cNatureza ) .and. cTipo == "DP "
					MT530NAT( @nVlrComisUNI, @nIrrf, @nIss, @nInss )
				Endif


				if nVlrComis > 0

					RecLock("SE2",.T.)
					SE2->E2_FILIAL    := xFilial()
					SE2->E2_PREFIXO   := cPrefixo
					SE2->E2_NUM       := cNumero
					SE2->E2_PARCELA   := cParcela
					SE2->E2_TIPO      := cTipo
					SE2->E2_FORNECE   := SA2->A2_COD
					SE2->E2_LOJA      := SA2->A2_LOJA
					SE2->E2_NOMFOR    := SA2->A2_NREDUZ
//					SE2->E2_VALOR     := Abs( nVlrComis )
					SE2->E2_VALOR     := nVlrComis
					SE2->E2_EMIS1     := dDataBase
					SE2->E2_EMISSAO   := dDataBase
					SE2->E2_VENCTO    := dVencto
					SE2->E2_VENCREA   := DataValida(SE2->E2_VENCTO,.T.)
					SE2->E2_VENCORI   := SE2->E2_VENCTO
					SE2->E2_SALDO     := SE2->E2_VALOR
					SE2->E2_NATUREZ   := cNatureza
					SE2->E2_VLCRUZ    := SE2->E2_VALOR
					SE2->E2_IRRF		:= 0
					SE2->E2_ISS			:= 0
					SE2->E2_INSS		:= 0
					SE2->E2_ORIGEM    := "FINA050"
					SE2->E2_MOEDA     := 1
					SE2->E2_RATEIO    := "N"
					SE2->E2_FLUXO     := "S"

				endif

            if nVlrComisUNI > 0
            	RecLock("SE2",.T.)
					SE2->E2_FILIAL    := xFilial()
					SE2->E2_PREFIXO   := "UNI"
					SE2->E2_NUM       := cNumero
					SE2->E2_PARCELA   := cParcela
					SE2->E2_TIPO      := cTipo
					SE2->E2_FORNECE   := SA2->A2_COD
					SE2->E2_LOJA      := SA2->A2_LOJA
					SE2->E2_NOMFOR    := SA2->A2_NREDUZ
//					SE2->E2_VALOR     := Abs(nVlrComisUNI)
					SE2->E2_VALOR     := nVlrComisUNI
					SE2->E2_EMIS1     := dDataBase
					SE2->E2_EMISSAO   := dDataBase
					SE2->E2_VENCTO    := dVencto
					SE2->E2_VENCREA   := DataValida(SE2->E2_VENCTO,.T.)
					SE2->E2_VENCORI   := SE2->E2_VENCTO
					SE2->E2_SALDO     := SE2->E2_VALOR
					SE2->E2_NATUREZ   := cNatureza
					SE2->E2_VLCRUZ    := SE2->E2_VALOR
					SE2->E2_IRRF		:= nIrrf
					SE2->E2_ISS			:= nIss
					SE2->E2_INSS		:= nInss
					SE2->E2_ORIGEM    := "FINA050"
					SE2->E2_MOEDA     := 1
					SE2->E2_RATEIO    := "N"
					SE2->E2_FLUXO     := "S"

            Endif

				nRegistro := Recno()
				If lMSE2530
					ExecBlock("MSE2530",.F.,.F.)
				Endif
				dbSelectArea("SE2")
				dbSetOrder(1)  // Acerto a ordem do SE2 para a grava눯o dos impostos
				a050DupPag( "FINA050",,,'REF.IR.COM.' + SA3->A3_NREDUZ )
				dbSelectArea("SE2")
				dbSetOrder(6)
				dbGoto(nRegistro)
				If ( mv_par08 == 1 .And. lPadrao ) // Contabiliza On-Line
					nHdlPrv:=HeadProva(cLote,"MATA530",Substr(cUsuario,7,6),@cArquivo)
					nTotal+=DetProva(nHdlPrv,cPadrao,"FINA050",cLote)
					RodaProva(nHdlPrv,nTotal)
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
					//� Envia para Lan놹mento Cont쟟il							  �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
					cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
					dbSelectArea("SE2")
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//� Atualiza flag de Lan놹mento Cont쟟il		  �
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					Reclock("SE2")
					Replace E2_LA With "S"
					MsUnlock()
				Endif
			EndIf
		END TRANSACTION
		nVlrComis := nVlrComisUNI := 0
	EndIf
	dbSelectArea("SE3")
	lFiltro := .T.
EndDo
dbSelectArea("SE3")
dbSetOrder(1)
Return

// Substituido pelo assistente de conversao do AP5 IDE em 29/05/03 ==> Static Function ca530Ok()
Static Function ca530Ok()
Return (MsgYesNo(OemToAnsi(STR0006),OemToAnsi(STR0007)))  //"Confirma a Atual. Pag. de Comiss꼘?"###"Aten뇙o"

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o	 쿘T530NAT	� Autor � Mauricio Pequim Jr	  � Data � 28/11/00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Calcula os impostos se a natureza assim o mandar			  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe	 � MT530Nat()																  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � MATA530																	  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 29/05/03 ==> Function MT530Nat(nVlrComis,nIrrf,nIss,nInss)
Static Function MT530Nat(nVlrComis,nIrrf,nIss,nInss)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica se Natureza pede calculo do IRRF            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If SED->ED_CALCIRF == "S" .and. !(SE2->E2_TIPO $ MV_CPNEG)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica se Pessoa Fisica ou Juridica, para fins de  �
	//� calculo do irrf                                    	�
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	IF SA2->A2_TIPO == "F"
		nIrrf:=fa050tabir(nVlrComis)
	Else
		nIrrf := Round((nVlrComis * IIF(SED->ED_PERCIRF>0,SED->ED_PERCIRF,GetMV("MV_ALIQIRF"))/100),2)
	EndIF
EndIf
If ( nIrrf <= GetMv("MV_VLRETIR") ) // Se Vlr. for Baixo nao considera
	nIrrf := 0
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica se Natureza pede calculo do ISS (FORNECEDOR N랳 RECOLHE) �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If SED->ED_CALCISS == "S" .and. SA2->A2_RECISS != "S"
	nIss := Round(((nVlrComis * GetMV("MV_ALIQISS"))/100),2)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica se Natureza pede calculo do INSS (RECOLHE INSS P/ FORNEC)�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If SED->ED_CALCINS == "S" .and. SA2->A2_RECINSS == "S"
	nInss := Round((nVlrComis * (SED->ED_PERCINS/100)),2)
	If ( nInss < GetMv("MV_VLRETIN") ) // Tratamento de Dispensa de Ret. de Inss.
		nInss := 0
	EndIf
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Desconta valores de impostos do valor total da comiss�o           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
nVlrComis -= (nIrrf + nIss + nInss)

Return .t.

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o	 쿌050DupPag쿌utor  � Wagner Xavier 	     � Data � 28.02.94 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿌tualizacao de titulos a pagar, gerando todos os dados 	  낢�
굇�			 쿬omplementares a uma implantacao de titulo.				     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe	 쿌050DupPag() 												           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛ar긩etros� cOrigem := Programa que originou o t죜ulo 				     낢�
굇�          � nTotIrrf:= Valor total do IRRF ( MATA100 ).  			     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � Generico 												              낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
Static Function A050DupPag1( cOrigem,lUpDate,nTotIrrf, cHist )

Local nValForte:=0,nIrrf:=0,nIss:=0, nInss := 0
Local cParcela,dEmissao,dVencto,dVencRea,cParcISS
Local cPrefixo,cNum,cTipoE2,nMOeda:=SE2->E2_MOEDA
Local dNextDay,nRegSe2,nRegSA2,nRegSED
Local cNatureza,lCond,lSa2:=.T.
Local cCalcImpV := GetMV("MV_GERIMPV")
Local nTamData	 := 0
Local lZeraIrrf := .F.
Local cLa := SE2->E2_LA
Local nMCusto   := 0
cOrigem := If(cOrigem==NIL,Space(8),cOrigem)
lUpDate := If( (lUpDate == NIL),.T.,lUpDate )

DbSelectArea("SA2")
nRegSA2 := RecNo()
DbSelectArea("SE2")
nRegSE2 := RecNo()
DbSelectArea("SED")
nRegSED := RecNo()

If ( Upper(cOrigem) == "MATA100" )
	lSA2:=!(cTipo$"DB")
	If !lSA2
		SA1->(DbSeek(xFilial("SA1")+Substr(a100ClIfor,1,6)+cLoja))
	EndIf
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Atualiza dados do Fornecedor 				  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SE2")
lCond := .F.

If ( SA2->A2_RECISS == "S" .And. lSA2)     // Fornecedor recolhe ISS
	If !E2_NATUREZ $ &(GetMv("MV_ISS")) .Or. !E2_NATUREZ$&(GetMv("MV_IRF")) .or.;
		!E2_NATUREZ$&(GetMv("MV_INSS"))
		lCond := .T.
	EndIf
ElseIf SA2->A2_RECINSS == "S"      // Fornecedor recolhe INSS
	If !E2_NATUREZ$&(GetMv("MV_ISS")) .Or. !E2_NATUREZ$&(GetMv("MV_IRF")) .or.;
		!E2_NATUREZ$&(GetMv("MV_INSS"))
		lCond := .T.
	EndIf
ElseIf ( !E2_NATUREZ$&(GetMv("MV_IRF")) )
	lCond := .T.
EndIf

If ( lCond )
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Atualiza dados do Cta Pagar					  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If cCalcImpV == "N"
		If ( Upper(cOrigem) == "MATA100" ) .And. nTotIrrf != Nil .And. GetMv("MV_VENCIRF") == "E"
			If nTotIrrf <= GetMv("MV_VLRETIR")
				lZeraIrrf	:= .T.
			EndIf
		Else
			If ( SE2->E2_IRRF <= GetMv("MV_VLRETIR") )
				lZeraIrrf	:= .T.
			EndIf
		EndIf
		If lZeraIrrf
			DbSelectArea("SE2")
			RecLock("SE2",.F.)
			SE2->E2_VALOR	+= SE2->E2_IRRF
			SE2->E2_SALDO	+= SE2->E2_IRRF
			SE2->E2_VLCRUZ := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
			SE2->E2_IRRF	:= 0
		EndIf
		If ( SE2->E2_INSS < GetMv("MV_VLRETIN") )
			DbSelectArea("SE2")
			RecLock("SE2",.F.)
			SE2->E2_VALOR	+= SE2->E2_INSS
			SE2->E2_SALDO	+= SE2->E2_INSS
			SE2->E2_VLCRUZ := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
			SE2->E2_INSS	:= 0
		EndIf
	Else
		DbSelectArea("SE2")
		RecLock("SE2",.F.)
		SE2->E2_VLCRUZ := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
	EndIf
	If ExistBlock("ATUDPPAG")
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Ponto de Entrada para Atualiza뇯es no SE2   �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		ExecBlock("ATUDPPAG",.f.,.f.,cOrigem)
	EndIf
	nRegSe2	:= RecNo()
	cPrefixo := SE2->E2_PREFIXO
	cNum		:= SE2->E2_NUM
	cTipoE2	:= SE2->E2_TIPO
	nValForte:= ConvMoeda(SE2->E2_EMISSAO,SE2->E2_VENCTO,SE2->E2_VALOR,GetMv("MV_MCUSTO"))
	If !SE2->E2_TIPO $ MVABATIM
		RecLock(If(lSA2,"SA2","SA1"))
		If ! ( SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG )
			If lSA2
				SA2->A2_SALDUP +=Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
				SA2->A2_SALDUPM+=Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,3),3),2)
			EndIf
		Else
			If ( !lSA2 )
				AtuSalDup("-",SE2->E2_VALOR,SE2->E2_MOEDA,SE2->E2_TIPO,,SE2->E2_EMISSAO)
			EndIf
		EndIf
		nValForte:=ConvMoeda(SE2->E2_EMISSAO,SE2->E2_VENCTO,If(lSA2,A2_SALDUP,A1_SALDUP),GetMv("mv_mcusto"))
		nMCusto:=Val(GetMV("MV_MCUSTO"))
		If ( lSA2 )
			DbSelectArea( "SA2" )
			If ( SA2->A2_SALDUPM > A2_MSALDO )
				SA2->A2_MSALDO := SA2->A2_SALDUPM
			EndIf
			SA2->A2_PRICOM  := Iif(SE2->E2_EMISSAO<A2_PRICOM .Or. Empty(SA2->A2_PRICOM),SE2->E2_EMISSAO,SA2->A2_PRICOM)
			SA2->A2_ULTCOM  := Iif(SA2->A2_ULTCOM<SE2->E2_EMISSAO,SE2->E2_EMISSAO,SA2->A2_ULTCOM)
			SA2->A2_NROCOM  := SA2->A2_NROCOM + If( lUpDate,1,0 )
			If ( SA2->A2_MCOMPRA < Round(NoRound(xMoeda(SE2->E2_VALOR,1,nMCusto,SE2->E2_EMISSAO,3),3),2) )
				SA2->A2_MCOMPRA := Round(NoRound(xMoeda(SE2->E2_VALOR,1,nMCusto,SE2->E2_EMISSAO,3),3),2)
			EndIf
		EndIf
		MsUnlock()
	EndIf
	DbSelectArea( "SE2" )
	cParcela := E2_PARCELA
	cParcISS := E2_PARCELA
	dEmissao := E2_EMISSAO
	dVencto	:= E2_VENCREA
	nIrrf 	:= E2_IRRF
	nIss		:= E2_ISS
	nInss 	:= E2_INSS
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Gera titulo de IRRF 							  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If ( nIrrf > 0 )
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria o Fornecedor, caso nao exista 		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SA2")
		DbSeek(cFilial+GetMV("MV_UNIAO")+Space(Len(A2_COD)-Len(GetMV("MV_UNIAO")))+"00")
		If ( EOF() )
			Reclock("SA2",.T.)
			SA2->A2_FILIAL := cFilial
			SA2->A2_COD 	:= GetMV("MV_UNIAO")
			SA2->A2_LOJA	:= "00"
			SA2->A2_NOME	:= "UNIAO"
			SA2->A2_NREDUZ := "UNIAO"
			SA2->A2_BAIRRO := "."
			SA2->A2_MUN 	:= "."
			SA2->A2_EST 	:= "."
			SA2->A2_End 	:= "."
			SA2->A2_TIPO	:= "."
			MsUnlock()
		EndIf
		cParcela := "1"
		While ( .T. )
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� VerIfica se ja' ha' titulo de IR com esta numera뇙o �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			DbSelectArea("SE2")
			If (DbSeek(cFilial+cPrefixo+cNum+cParcela+;
				Iif(cTipoE2 $ "PA #"+MV_CPNEG,"TXA","TX ")+PadR(GetMv("MV_UNIAO"),6)))
				cParcela := Iif(Empty( cParcela) , "0", cParcela )
				cParcela := Soma1( cParcela )
				Loop
			EndIf
			Exit
		End
		DbGoTo( nRegSe2 )
		If GetMv("MV_VENCIRF") == "E"
			dNextDay := SE2->E2_EMISSAO+1
		ElseIf GetMv("MV_VENCIRF") == "C"
			dNextDay := SE2->E2_EMIS1+1
		Else
			dNextDay := SE2->E2_VENCREA+1
		EndIf

		For nCntFor := 1 To 7
			If Dow( dNextDay ) = 1
				Exit
			EndIf
			dNextDay++
		Next nCntFor
		For n:= 1 to 3
			dNextDay := DataValida(dNextDay+1,.T.)
		Next
		dVencRea := dNextDay
		RecLock("SE2",.T.)
		SE2->E2_FILIAL  := cFilial
		SE2->E2_PREFIXO := cPrefixo
		SE2->E2_NUM 	 := cNum
		SE2->E2_PARCELA := cParcela
		SE2->E2_TIPO	 := Iif(cTipoE2 $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
		SE2->E2_EMISSAO := dEmissao
		SE2->E2_VALOR	 := nIrrf
		SE2->E2_VENCREA := dVencrea
		SE2->E2_SALDO	 := nIrrf
		SE2->E2_VENCTO  := dVencRea
		SE2->E2_VENCORI := dVencRea
		SE2->E2_MOEDA	 := 1
		SE2->E2_EMIS1	 := dDataBase
		SE2->E2_FORNECE := GetMV("MV_UNIAO")
		SE2->E2_VLCRUZ  := SE2->E2_VALOR
		SE2->E2_LOJA	 := SA2->A2_LOJA
		SE2->E2_NOMFOR  := SA2->A2_NREDUZ
		SE2->E2_HIST    := cHist
		SE2->E2_ORIGEM  := UPPER(cOrigem)
		cNatureza		 := &(GetMv("MV_IRF"))
		SE2->E2_NATUREZ := cNatureza
		SE2->E2_LA      := cLA			// Herda do principal

		cNatureza		 := SE2->E2_NATUREZ
		MsUnlock()

		If ExistBlock("F050IRF")
			Execblock("F050IRF",.F.,.F.,nRegSE2)
		EndIf

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria a natureza IRF caso nao exista		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SED")
		If ( !DbSeek(cFilial+cNatureza) )
			RecLock("SED",.T.)
			SED->ED_FILIAL  := cFilial
			SED->ED_CODIGO  := cNatureza
			SED->ED_CALCIRF := "N"
			SED->ED_CALCISS := "N"
			SED->ED_CALCINS := "N"
			SED->ED_CALCCSL := "N"
			SED->ED_CALCCOF := "N"
			SED->ED_CALCPIS := "N"
			SED->ED_DESCRIC := "IMPOSTO REndA RETIDO NA FONTE"
			MsUnlock()
		EndIf
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Grava parcela do IRF na parcela do titulo  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea( "SE2" )
		DbGoTo( nRegSe2 )
		Reclock( "SE2" , .F. )
		SE2->E2_PARCIR := cParcela
		MsUnlock()
	EndIf
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Gera titulo de INSS 							  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If nInss > 0
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria o Fornecedor, caso nao exista 		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SA2")
		If !(DbSeek(xFilial()+GetMv("MV_FORINSS")+Space(Len(A2_COD)-Len(GetMv("MV_FORINSS")))+"00"))
			Reclock("SA2",.T.)
			SA2->A2_FILIAL := cFilial
			SA2->A2_COD 	:= GetMv("MV_FORINSS")
			SA2->A2_LOJA	:= "00"
			SA2->A2_NOME	:= "Instituto Nacional de Previdencia Social"
			SA2->A2_NREDUZ := "INPS"
			SA2->A2_BAIRRO := "."
			SA2->A2_MUN 	:= "."
			SA2->A2_EST 	:= "."
			SA2->A2_End 	:= "."
			SA2->A2_TIPO	:= "."
			MsUnlock()
		EndIf
		cParcela := "1"
		While .T.
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� VerIfica se ja' ha' titulo de INSS com esta numera뇙o �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			DbSelectArea("SE2")
			If (DbSeek(cFilial+cPrefixo+cNum+cParcela+"INS"+PadR(GetMv("MV_FORINSS"),6)))
				cParcela := Iif(Empty( cParcela) , "0", cParcela )
				cParcela := Soma1( cParcela )
				Loop
			EndIf
			Exit
		End
		DbGoTo( nRegSe2 )
		dNextMes := Month(SE2->E2_EMISSAO)+1
		dNextVen := CTOD("02/"+Iif(dNextMes==13,"01",StrZero(dNextMes,2))+"/"+;
		Substr(Str(Iif(dNextMes==13,Year(SE2->E2_EMISSAO)+1,Year(SE2->E2_EMISSAO))),2))
		dVencRea := DataValida(dNextVen,.T.)
		RecLock("SE2",.T.)
		SE2->E2_FILIAL  := xFilial()
		SE2->E2_PREFIXO := cPrefixo
		SE2->E2_NUM 	 := cNum
		SE2->E2_PARCELA := cParcela
		SE2->E2_TIPO	 := MVINSS
		SE2->E2_EMISSAO := dEmissao
		SE2->E2_VALOR	 := nInss
		SE2->E2_VENCREA := dVencrea
		SE2->E2_SALDO	 := nInss
		SE2->E2_VENCTO  := dVencRea
		SE2->E2_VENCORI := dVencRea
		SE2->E2_MOEDA	 := 1
		SE2->E2_EMIS1	 := dDataBase
      SE2->E2_HIST    := cHIST
		SE2->E2_FORNECE := GetMv("MV_FORINSS")
		SE2->E2_VLCRUZ  := SE2->E2_VALOR
		SE2->E2_LOJA	 := SA2->A2_LOJA
		SE2->E2_NOMFOR  := SA2->A2_NREDUZ
		SE2->E2_ORIGEM  := UPPER(cOrigem)
		cNatureza		 := &(GetMv("MV_INSS"))
		SE2->E2_NATUREZ := cNatureza
		SE2->E2_LA      := cLA			// Herda do principal
		cNatureza		 := SE2->E2_NATUREZ
		MsUnlock()

		If ExistBlock("F050INS")
			Execblock("F050INS",.F.,.F.,nRegSE2)
		EndIf

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria a natureza INSS caso nao exista		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SED")
		If !DbSeek(cFilial+cNatureza)
			RecLock("SED",.T.)
			SED->ED_FILIAL  := cFilial
			SED->ED_CODIGO  := cNatureza
			SED->ED_CALCIRF := "N"
			SED->ED_CALCISS := "N"
			SED->ED_CALCINS := "N"
			SED->ED_CALCCSL := "N"
			SED->ED_CALCCOF := "N"
			SED->ED_CALCPIS := "N"
			SED->ED_DESCRIC := "RETENCAO P/ SEGURIDADE SOCIAL"
			MsUnlock()
		EndIf
		DbGoTo(nRegSED)
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Grava parcela do INSS na parcela do titulo �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea( "SE2" )
		DbGoTo( nRegSe2 )
		Reclock( "SE2" , .F. )
		SE2->E2_PARCINS := cParcela
		MsUnlock()
	EndIf
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Gera titulo de ISS								  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If ( nIss > 0 )
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria o fornecedor, caso nao exista 		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SA2")
		DbSeek(cFilial+GetMV("MV_MUNIC")+Space(Len(A2_COD)-Len(GetMV("MV_MUNIC")))+"00")
		If ( EOF() )
			Reclock("SA2",.T.)
			SA2->A2_FILIAL   := cFilial
			SA2->A2_COD 	  := GetMV("MV_MUNIC")
			SA2->A2_LOJA	  := "00"
			SA2->A2_NOME	  := "MUNICIPIO"
			SA2->A2_NREDUZ   := "MUNICIPIO"
			SA2->A2_BAIRRO   := "."
			SA2->A2_MUN 	  := "."
			SA2->A2_EST 	  := "."
			SA2->A2_End 	  := "."
			MsUnlock()
		EndIf
		While ( .T. )
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//� VerIfica se ja' ha' titulo de ISS com esta numera뇙o �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			DbSelectArea("SE2")
			If (DbSeek(cFilial+cPrefixo+cNum+cParcISS+"ISS"+GetMV("MV_MUNIC")))
				cParcISS := Iif(Empty( cParcISS) , "0", cParcISS )
				cParcISS := Soma1( cParcISS )
				Loop
			EndIf
			Exit
		End

		dVenISS := dEmissao + 28
		If Month(dVenISS) == Month(dEmissao)
			dVenISS := dVenISS+28
		EndIf
		nTamData := Iif(Len(Dtoc(dVenISS)) == 10, 7, 5)
		dVenISS	:= Ctod(StrZero(GetMv("mv_DiaISS"),2)+"/"+Subs(Dtoc(dVenISS),4,nTamData))
		dVencRea := DataValida(dVenISS,.T.)
		RecLock("SE2",.T.)
		SE2->E2_FILIAL  := cFilial
		SE2->E2_PREFIXO := cPrefixo
		SE2->E2_NUM 	 := cNum
		SE2->E2_PARCELA := cParcISS
		SE2->E2_NATUREZ := &(GetMv("MV_ISS"))
		SE2->E2_TIPO	 := MVISS
		SE2->E2_EMISSAO := dEmissao
		SE2->E2_EMIS1	 := dDataBase
		SE2->E2_VALOR	 := nIss
		SE2->E2_VENCTO  := dVenISS
		SE2->E2_SALDO	 := nIss
		SE2->E2_VENCREA := dVencRea
		SE2->E2_VENCORI := dVenISS
		SE2->E2_FORNECE := GetMV("MV_MUNIC")
		SE2->E2_LOJA	 := "00"
		SE2->E2_NOMFOR  := SA2->A2_NREDUZ
		SE2->E2_MOEDA	 := nMoeda
		SE2->E2_VLCRUZ  := xMoeda(SE2->E2_VALOR,nMoeda,1,SE2->E2_EMISSAO)
      SE2->E2_HIST    := cHIST
		SE2->E2_ORIGEM  := UPPER(cOrigem)
		cNatureza		 := &(GetMv("MV_ISS"))
		SE2->E2_NATUREZ := cNatureza
		SE2->E2_LA      := cLA			// Herda do principal
		cNatureza		 := SE2->E2_NATUREZA
		MsUnlock()

		If ExistBlock("F050ISS")
			Execblock("F050ISS",.F.,.F.,nRegSE2)
		EndIf

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria a natureza ISS caso nao exista		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SED")
		If ( !DbSeek( cFilial + cNatureza ) )
			RecLock("SED",.T.)
			SED->ED_FILIAL  := cFilial
			SED->ED_CODIGO  := cNatureza
			SED->ED_CALCIRF := "N"
			SED->ED_CALCISS := "N"
			SED->ED_CALCINS := "N"
			SED->ED_CALCCSL := "N"
			SED->ED_CALCCOF := "N"
			SED->ED_CALCPIS := "N"
			SED->ED_DESCRIC := "IMPOSTO SOBRE SERVICOS"
			MsUnlock()
		EndIf
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Grava parcela do IRF na parcela do titulo  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea( "SE2" )
		DbGoTo( nRegSe2 )
		Reclock( "SE2" , .F. )
		SE2->E2_PARCISS := cParcISS
		MsUnlock()
	EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Gera titulo Funrural							  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	nValFun := Iif(Type("nValFun")=="U",0,nValFun)

	If ( nValFun > 0 )
		dVenFun := dEmissao + 28
		If Month(dVenFun) == Month(dEmissao)
			dVenFun := dVenFun+28
		EndIf
		nTamData := Iif(Len(Dtoc(dVenFun)) == 10, 7, 5)
		dVenFun	:= Ctod(StrZero(GetMv("mv_DiaFun"),2)+"/"+Subs(Dtoc(dVenFun),4,nTamData))
		dVencRea := DataValida(dVenFun,.T.)
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria o Fornecedor, caso nao exista 		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SA2")
		DbSeek(cFilial+GetMV("MV_UNIAO")+Space(Len(A2_COD)-Len(GetMV("MV_UNIAO")))+"00")
		If ( EOF() )
			Reclock("SA2",.T.)
			SA2->A2_FILIAL   := cFilial
			SA2->A2_COD 	  := GetMV("MV_UNIAO")
			SA2->A2_LOJA	  := "00"
			SA2->A2_NOME	  := "UNIAO"
			SA2->A2_NREDUZ   := "UNIAO"
			SA2->A2_BAIRRO   := "."
			SA2->A2_MUN 	  := "."
			SA2->A2_EST 	  := "."
			SA2->A2_End 	  := "."
			SA2->A2_TIPO	  := "."
			MsUnlock()
		EndIf
		DbSelectArea("SE2")
		RecLock("SE2",.T.)
		SE2->E2_FILIAL 	:= cFilial
		SE2->E2_PREFIXO  := cPrefixo
		SE2->E2_NUM 	  := cNum
		SE2->E2_PARCELA  := cParcela
		SE2->E2_TIPO	  := MVTAXA
		SE2->E2_EMISSAO  := dEmissao
		SE2->E2_VALOR	  := nValFun
		SE2->E2_VENCREA  := dVencrea
		SE2->E2_SALDO	  := nValFun
		SE2->E2_VENCTO   := dVencRea
		SE2->E2_VENCORI  := dVencRea
		SE2->E2_MOEDA	  := 1
		SE2->E2_EMIS1	  := dDataBase
		SE2->E2_FORNECE  := GetMV("MV_UNIAO")
		SE2->E2_VLCRUZ   := SE2->E2_VALOR
		SE2->E2_LOJA	  := SA2->A2_LOJA
		SE2->E2_NOMFOR   := SA2->A2_NREDUZ
		SE2->E2_ORIGEM   := UPPER(cOrigem)
		cNatureza		  := GetMv("MV_CSS")
		SE2->E2_NATUREZ  := cNatureza
		SE2->E2_LA       := cLA			// Herda do principal
		cNatureza		  := SE2->E2_NATUREZ
		MsUnlock()

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Cria a natureza CSS caso nao exista		  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		DbSelectArea("SED")
		DbSeek(cFilial+cNatureza)
		If ( EOF() )
			RecLock("SED",.T.)
			SED->ED_FILIAL 	:= cFilial
			SED->ED_CODIGO 	:= cNatureza
			SED->ED_CALCIRF	:= "N"
			SED->ED_CALCISS	:= "N"
			SED->ED_CALCINS	:= "N"
			SED->ED_CALCCSL	:= "N"
			SED->ED_CALCCOF	:= "N"
			SED->ED_CALCPIS	:= "N"
			SED->ED_DESCRIC	:= "CONTRIBUICAO SEGURIDADE SOCIAL"
			MsUnlock()
		EndIf
	EndIf
EndIf
DbSelectArea("SA2")
DbGoTo( nRegSA2 )
DbSelectArea("SED")
DbGoTo( nRegSED )
DbSelectArea("SE2")
DbGoTo(nRegSE2)
RecLock("SE2")
SE2->E2_ORIGEM := UPPER(cOrigem)
MsUnlock()
Return

