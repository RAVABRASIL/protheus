#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Carta de cobranca.                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rava Embalagens - Cobranca                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*

******* A T E N C A O ********
Todas as Alteracoes feitas aqui deverao ser contempladas no programa COBC011(),
funcao Carta_Cobranca().

*/
User Function COBC015()

SetPrvt( "oCBox1,oSay1," )

******** VARIAVEIS USADAS **********

private oDlg1
cMARCA    := GetMark()
lINVERTE  := .F.
aCPOBRW2  := {}
lFLAG     := .F.
nVlPrinc   := 0
nTotCli    := 0
nJurosSel  := 0
nVltotal   := 0

******** INICIO DO PROCESSAMENTO ********

MsAguarde({|| lFLAG := LeClientes() }, OemToAnsi("Aguarde"), OemToAnsi("Atualizando Clientes..."))

If ! lFLAG
	Return NIL
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 550,785 Dialog oDLG1 Title OemToAnsi( "Clientes - Carta de Cobranca" )

@ 006,005 Say OemToAnsi("Clientes :") COLOR CLR_HBLUE
@ 006,050 Say nTotCli Picture "@E 999" COLOR CLR_RED object oTotCli
oCBox1     := TComboBox():New( 015,045,,{"Tom Suave","Tom Mediano","Tom Mais Forte"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,,,,,,,, )
oCBox1:nAt := 1
oSay1      := TSay():New( 016,005,{||"Nivel da Carta:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,038,008)


Dbselectarea("MARC")

oBRW2  	   	:= MsSelect():New( "MARC", "MARCA", "", aCPOBRW2, @lInverte, @cMarca, { 030, 002, 240, 393 } )
oBRW2:oBrowse:lhasMark    := .T.
oBRW2:oBrowse:lCanAllmark := .T.
oBRW2:oBrowse:bAllMark    := { || MarcaTudo() }
oBRW2:bMark               := { || Marca()}

@ 255,150 Button OemToAnsi("_Confirma") Size 40,12 Action ImpCarta() Object oCONFIRMA //ProcPreAc()
@ 255,210 Button OemToAnsi("_Sair") Size 40,12 Action oDLG1:End() Object oSAIRAc

Activate Dialog oDLG1 Centered Valid SairAc()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBC011   ºAutor  ³Microsiga           º Data ³  02/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCarta()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Carta de Cobranca"
Local cPict          := ""
Local titulo       := "Carta de Cobranca"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "CARTA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CARTA" // Coloque aqui o nome do arquivo usado para impressao em disco
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := "SE1"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  03/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cNomeCli	:= Posicione("SA1",1,xFilial("SA1") + MARC->CLIENTE + MARC->LOJA,"A1_NOME")
Local nOrdem
Local nRec
Local cTels := "(83)3048-1305, (83)3048-1322 e (83)3048-1342"

dbSelectArea("MARC")
nRec := MARC->( RecNo() )
dbgotop()

SetRegua(nTotCli)

While !EOF()
	Incregua()
	nlin	:= 4
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	IF MARC->MARCA == cMARCA //Se o clientes Estiver marcado
		Dbselectarea("SA1")
		Dbsetorder(1)
		Dbseek(xFilial()+MARC->CLIENTE+MARC->LOJA)
		
		dDia := Subst(dToc(dDatabase),1,2)
		dMes := Subst(dToc(dDatabase),4,2) //mes
		If dMes == '01'
			cMes := 'Janeiro'
		ElseIf dMes == '02'
			cMes := 'Fevereiro'
		ElseIf dMes == '03'
			cMes := 'Marco'
		ElseIf dMes == '04'
			cMes := 'Abril'
		ElseIf dMes == '05'
			cMes := 'Maio'
		ElseIf dMes == '06'
			cMes := 'Junho'
		ElseIf dMes == '07'
			cMes := 'Julho'
		ElseIf dMes == '08'
			cMes := 'Agosto'
		ElseIf dMes == '09'
			cMes := 'Setembro'
		ElseIf dMes == '10'
			cMes := 'Outubro'
		ElseIf dMes == '11'
			cMes := 'Novembro'
		ElseIf dMes == '12'
			cMes := 'Dezembro'
		Endif
		
		dAno := Trim(Str(Year(dDatabase)))
		
		@ nlin, 030 pSay AllTrim(SM0->M0_CIDCOB)+", "+dDia+" de "+cMes +" de "+AllTrim(dAno)
		nlin := nlin + 3
		
		//1-Tom Suave
		if oCBox1:nAt = 1
			@ nlin, 000 pSay cNomeCli
			nLin ++
			@ nlin, 000 pSay "At. Financeiro - Contas a Pagar"
			nLin ++
			@ nlin, 000 pSay "Prezado(s) Senhor(es),"
			nlin := nlin +2
			@ nlin,000 pSay "Não constatamos o(s) pagamento(s) do(s) título(s) abaixo relacionado(s). "
			nlin ++
			@ nlin,000 pSay "Pedimos que Vossa Senhoria entre em contato conosco através do telefones: "
			nlin ++
			@ nlin,000 pSay cTels+" e, por gentileza tome as providências necessárias para evitar "
			nlin ++
			@ nlin,000 pSay "que o fato cause problemas entre as partes."
			nlin ++
			@ nlin,000 pSay "Caso o pagamento tenha sido efetuado, favor nos enviar via Fax, pelos mesmos "
			nlin ++
			@ nlin,000 pSay "telefones acima, o comprovante de quitação, agilizando assim, nossa identificação"
			nlin ++
			@ nlin,000 pSay "e baixa."
		elseif oCBox1:nAt = 2
			//2- Tom mediano
			@ nlin, 000 pSay cNomeCli
			nLin ++
			@ nlin, 000 pSay "At. Financeiro - Contas a Pagar"
			nLin ++
			@ nlin, 000 pSay "Prezado(s) Senhor(es),"
			nlin := nlin +2
			@ nlin,000 pSay "Como não recebemos resposta a nosso primeiro comunicado, emitido em   /  /  ,"
			nlin ++
			@ nlin,000 pSay "pedimos novamente que seja regularizado o pagamento, que se encontra em atraso,"
			nlin ++
			@ nlin,000 pSay "referente ao(s) titulo(s) abaixo relacionado(s)."
			nlin ++
			@ nlin,000 pSay "Contamos com suas providências a respeito desse débito, para que medidas mais "
			nlin ++
			@ nlin,000 pSay "extremas não sejam tomadas."
		elseif oCBox1:nAt = 3
			//3-Tom mais forte
			@ nlin, 000 pSay cNomeCli
			nLin ++
			@ nlin, 000 pSay "At. Financeiro - Contas a Pagar"
			nLin ++
			@ nlin, 000 pSay "Prezado(s) Senhor(es),"
			nlin := nlin +2
			@ nlin,000 pSay "Apesar das solicitações que fizemos, até o momento não recebemos nenhuma "
			nlin ++
			@ nlin,000 pSay "resposta de Vossa Senhoria a respeito do não pagamento do(s) título(s) abaixo "
			nlin ++
			@ nlin,000 pSay "relacionado(s).Por esse motivo, enviaremos o(s) títulos em questão para a Serasa,"
			nlin ++
			@ nlin,000 pSay "no prazo de 48 horas."
			nlin ++
			@ nlin,000 pSay "Para saldarem esse debito procurem-nos antes de findarem as 48 horas, através "
			nlin ++
			@ nlin,000 pSay "dos telefones: "+cTels
		endif
		nLin ++
		
		//Seleciona os titulos do cliente que sera impresso
		cQUERY := " Select SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
		cQUERY += " SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_VENCREA, SE1.E1_VENCTO, SE1.E1_PORTADO, SE1.E1_PEDIDO, "
		cQUERY += " SE1.E1_NATUREZ, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_EMISSAO, SE1.E1_NUMDPID, SE1.E1_STATCOB "
		cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
		cQUERY += " Where SE1.E1_CLIENTE+SE1.E1_LOJA = '" + MARC->CLIENTE+MARC->LOJA + "' "
//		cQUERY += " AND (Substring(SE1.E1_STATCOB,1,2) IN( '4P', = '' OR Substring(SE1.E1_STATCOB,1,2) = '2F' OR Substring(SE1.E1_STATCOB,1,2) = '43' "
//		cQUERY += " OR Substring(SE1.E1_STATCOB,1,2) = '53' OR Substring(SE1.E1_STATCOB,1,2) = '63' OR Substring(SE1.E1_STATCOB,1,2) = '73')"
		cQuery += " AND SE1.E1_VENCREA < "+DTOS(dDataBase)+" "
		cQUERY += " AND SE1.E1_SALDO > 0	"
		cQUERY += " AND SE1.D_E_L_E_T_ = '' "
		cQUERY += " Order By SE1.E1_VENCREA"
		cQUERY := ChangeQuery( cQUERY )
		
		//Cria arquivo temporario com o alias TITSE1
		TCQUERY cQUERY Alias TITSE1 New
		
		TCSetField("TITSE1", "E1_SALDO"  ,"N",14,2)
		TCSetField("TITSE1", "E1_EMISSAO","D",08,2)
		TCSetField("TITSE1", "E1_VENCREA","D",08,2)
		
		Dbselectarea("TITSE1")
		dbgotop()
		@ nlin,000 pSay "            Emissao    Vencto           Valor"
		nlin ++
		//                           99/99/9999 99/99/9999  999,999.99
		//               012345678901234567890123456789012345678901234567890123456789
		While !Eof()
			@ nlin, 012 pSay DTOC(TITSE1->E1_EMISSAO)
			@ nlin, 023 pSay DTOC(TITSE1->E1_VENCREA)
			@ nlin, 035 pSay TITSE1->E1_SALDO picture "@E 999,999.99"
			nLin ++ // Avanca a linha de impressao
			Dbselectarea("SE1")
			Dbsetorder(2)
			If Dbseek(xFilial()+TITSE1->E1_CLIENTE+TITSE1->E1_LOJA+TITSE1->E1_PREFIXO+TITSE1->E1_NUM+TITSE1->E1_PARCELA+TITSE1->E1_TIPO )
				Reclock("SE1",.F.)
			   	Replace E1_STATCOB With Subst(E1_STATCOB,1,2)+'2' //marca que o titulo ja foi impresso
			Endif
			Dbselectarea("TITSE1")
			dbskip()
		End
		Dbclosearea("TITSE1")
//		nlin := nlin + 3
//		@ nlin, 000 pSay "Registramos que, não havendo nenhum contato, o(s) débito(s) acima será(ão)"
		//                12345678901234567890123456789012345678901234567890123456789012345678901234567890
//		nlin ++
//		@ nlin, 000 pSay "enviado(s) a Cobrança Externa."
		nlin := nlin + 2
		@ nlin, 000 pSay "Obs.: Caso tenha Quitado o(s) referido(s) débito(s), favor enviar comprovante"
		nlin ++
		@ nlin, 000 pSay "de quitação."
		nlin := nlin + 2
		@ nlin, 005 pSay "Atenciosamente,"
		nlin := nlin + 2
		@ nlin, 005 pSay "____________________"
		nlin ++
		@ nlin, 005 pSay "Rava Embalagens."
		nlin ++
		@ nlin, 005 pSay "SETOR DE COBRANÇA"
		
		@ 058, 017 pSay "FONE "+transform(SA1->A1_TEL,"@R (99)9999-999") + "  FAX "+transform(SA1->A1_FAX,"@R (99)9999-999")
		nlin ++
		@ 062, 017 pSay MARC->CLIENTE+" "+MARC->NOME
		nlin ++
		@ 063, 017 pSay "Endereco "+SA1->A1_END
		nlin ++
		@ 064, 017 pSay SA1->A1_MUN+SA1->A1_BAIRRO+SA1->A1_EST
		nlin ++
		@ 065, 017 pSay "CEP "+transform(SA1->A1_CEP,"@R 99.999-999")
		nlin := nlin + 4
		
	Endif
	Dbselectarea("MARC")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

MARC->( DbGoTo(nRec) )

//DbCloseArea("MARC")
//Close( oDLG1 )

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBC011   ºAutor  ³Microsiga           º Data ³  02/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SairAc

If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
   if Select("MARC") # 0
      	DbCloseArea("MARC")
    endif  	
	//Close( oDLG1 )
	Return .T.
EndIf

Return .F.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBC011   ºAutor  ³Microsiga           º Data ³  02/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarcaTudo()

Local nREG := MARC->( Recno() )

MARC->( DbGotop() )
While ! Eof()
	IF MARC->MARCA == cMARCA
		MARC->MARCA := "  "
		nTotCli    --
	Else
		MARC->MARCA := cMARCA
		nTotCli    ++
	Endif
	MARC->( DbSkip() )
Enddo
MARC->( dbGoto( nREG ) )

oBRW2:oBrowse:Refresh()
ObjectMethod( oTotCli , "SetText( nTotCli )" )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBC011   ºAutor  ³Microsiga           º Data ³  02/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Marca()

If MARC->MARCA == cMARCA
	MARC->MARCA := cMARCA
	nTotCli    ++
Else
	MARC->MARCA := "  "
	nTotCli    --
End

//MARC->( DbGotop() )
oBrw2:oBrowse:Refresh()
ObjectMethod( oTotCli , "SetText( nTotCli  )" )

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBC011   ºAutor  ³Microsiga           º Data ³  01/31/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LeClientes()

aCAMPOS := { { "MARCA"  , "C", 02, 0 }, ;
{ "CLIENTE", "C", 06, 0 }, ;
{ "LOJA"   , "C", 02, 0 }, ;
{ "NOME"   , "C", 30, 0 }, ;
{ "CGC"    , "C", 15, 0 }, ;
{ "GR"     , "C", 04, 0 }, ;
{ "CIDADE" , "C", 30, 0 }, ;
{ "UF"     , "C", 02, 0 }, ;
{ "STATUS" , "C", 15, 0 },;
{ "STCOB"  , "C", 03, 0 } }

if Select("MARC") > 0
	MARC->(DbCloseArea())
endif

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "MARC", .F., .F. )
Index On STATUS TO &cARQEMP

dbselectarea("SE1")

cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST, E1_STATCOB"
cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SE1" ) + " SE1 "
cQuery += "Where Substring(SE1.E1_STATCOB,1,2) IN ('4P','4Q','4R','3P','3Q','3S') "
//cQUERY += " Where (Substring(SE1.E1_STATCOB,1,2) = '26' OR Substring(SE1.E1_STATCOB,1,2) = '2F' OR Substring(SE1.E1_STATCOB,1,2) = '43' "
//cQUERY += " OR Substring(SE1.E1_STATCOB,1,2) = '53' OR Substring(SE1.E1_STATCOB,1,2) = '63' OR Substring(SE1.E1_STATCOB,1,2) = '73')"
cQUERY += " AND SE1.E1_CLIENTE+SE1.E1_LOJA = SA1.A1_COD+SA1.A1_LOJA"
cQUERY += " AND SE1.E1_SALDO > 0     "
cQUERY += " AND SE1.D_E_L_E_T_ <> '*'"
cQUERY += " AND SA1.D_E_L_E_T_ <> '*'"
cQUERY += " GROUP BY A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST, E1_STATCOB"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSA1
TCQUERY cQUERY Alias TMPSA1 New

//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TMPSA1")
dbgotop()

nTotCli    := 0
While !Eof()
	Dbselectarea("TMPSA1")
	Reclock("MARC",.T.)
	If Subst(TMPSA1->E1_STATCOB,3,1) == '2'
		Replace MARCA   With ''
		Replace STATUS  With "Re-Impressao"
	Else
		Replace MARCA   With cMarca
		Replace STATUS  With "Impressao"
		nTotCli ++
	Endif
	Replace CLIENTE With TMPSA1->A1_COD
	Replace LOJA    With TMPSA1->A1_LOJA
	Replace NOME    With TMPSA1->A1_NOME
	Replace CGC     With TMPSA1->A1_CGC
	Replace GR      With TMPSA1->A1_GPEMP
	Replace CIDADE  With TMPSA1->A1_MUN
	Replace UF      With TMPSA1->A1_EST
	Replace STCOB   With TMPSA1->E1_STATCOB	
	msunlock()
	Dbselectarea("TMPSA1")
	dbskip()
End

Dbclosearea("TMPSA1")

MARC->( DbGotop() )

aCPOBRW2  :=  { { "MARCA"    ,, OemToAnsi( "" ) }, ;
{ "CLIENTE" ,,   OemToAnsi( "Cliente" ) }, ;
{ "LOJA"    ,,   OemToAnsi( "Loja" ) }, ;
{ "NOME"    ,,   OemToAnsi( "Nome" ) }, ;
{ "CGC"     ,,   OemToAnsi( "CGC/CPF" ) }, ;
{ "GR"      ,,   OemToAnsi( "Grupo" ) }, ;
{ "CIDADE"  ,,   OemToAnsi( "Cidade" ) }, ;
{ "UF"      ,,   OemToAnsi( "UF"     ) }, ;
{ "STATUS"  ,,   OemToAnsi( "Status" ) }}

Return .T.

Return
