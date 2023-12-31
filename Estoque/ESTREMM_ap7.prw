#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTREMM()

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
	//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
	//� identificando as variaveis publicas do sistema utilizadas no codigo �
	//� Incluido pelo assistente de conversao do AP5 IDE                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	//SetPrvt("CVALEXT,AFIELDS,CPATH,")
	//SetPrvt( "cTam, sMsg, cOrdem, cCod, cString, nLin, cTurno, cEntSai" )

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튡rograma  쿐STREMM    � Autor � Emmanuel Lacerda  � Data �  16/05/06   볍�
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
	굇튒escricao � Exibe OP e descri豫o dos produtos                          볍�
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
	굇튧so       � Modulo Estoque                                             볍�
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
	/*/

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Define Variaveis Ambientais                                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Variaveis utilizadas para parametros                         �
	//� mv_par01        	// De Emissao                            �
	//� mv_par02        	// Ate Emissao                           �
	//� mv_par03        	// De Funcion�rio                        �
	//� mv_par04        	// Ate Funcion�rio                       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	tamanho   := "M"
	titulo    := PADC("Relatorio de  OP e descricao dos produtos", 74)
	cDesc1    := PADC("Relatorio de  OP e descricao dos produtos", 74)
	cDesc2    := PADC("", 74)
	cDesc3    := PADC("", 74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  := "ESTREMM"
	cPerg     := ""
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
	wnrel     := "ESTREMM"
	M_PAG     := 1


	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	//Pergunte( cPerg, .T. )               // Pergunta no SX1
	cString := "Z00"

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Envia controle para a funcao SETPRINT                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

	If nLastKey == 27
	   Return
	Endif

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica Posicao do Formulario na Impressora                 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	SetDefault( aReturn, cString )

	If nLastKey == 27
	   Return
	Endif


	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Inicio do Processamento do Relatorio                         �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	#IFDEF WINDOWS
	   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
	   Return
		// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
		Static Function RptDetail()
	#ENDIF


	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� DESENVOLVIMENTO DO PROGRAMA         								 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸


	cQuery := "select	SC2.C2_NUM, SC2.C2_PRODUTO, SB1.B1_DESC, sum(Z00.Z00_PESO) as Z00_TOTAL"
	cQuery += "from " + RetSqlName( "SC2" ) + " SC2," + RetSqlName( "SB1" ) + " SB1," + RetSqlName("Z00") + " Z00 "
	cQuery += "where SB1.B1_COD =  SC2.C2_PRODUTO "
	cQuery += "and SC2.C2_EMISSAO BETWEEN '20060501' and 'getdate()' " //escolher intervalo de datas
	cQuery += "and SB1.B1_TIPO = 'PA' and SB1.B1_ATIVO = 'S' " //tipo de produto e se esta ativo ou nao
	cQuery += "and substring(Z00.Z00_OP, 1, 6) = SC2.C2_NUM "
	/*cQuery += "SC2.C2_FILIAL  = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' AND "
	cQuery += "SB1.B1_FILIAL  = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
	cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' '  "*/
	cQuery += "group by SC2.C2_NUM, SC2.C2_PRODUTO, SB1.B1_DESC "
	cQuery += "order by SC2.C2_NUM"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SCBX"
	TCSetField( 'SCBX', "C2_NUM", "C" )
	TCSetField( 'SCBX', "C2_PRODUTO", "C" )
	TCSetField( 'SCBX', "B1_DESC", "C" )
  	TCSetField( 'SCBX', "Z00_TOTAL", "C" )

	//MemoWrit( "CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel

	/*
	----------------------------------------------------------------
	  LAYOUT DA IMPRESSAO DO RELATORIO
	----------------------------------------------------------------
	*/
	//cCabec_01 := "Matricula  Nome                               Data          -1a-             -2a-             -3a-         Observa寤es"
	//cCabec_02 := "           do Funcionario                              Entrada  Saida   Entrada  Saida   Entrada  Saida"
	cCabec_01 := "Numero do Produto     Codigo do Produto     Descricao do Produto                            Total Fabricado "
	//           "999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99   99:99hs 99:99hs  99:99hs 99:99hs  99:99hs 99:99hs   XXXXXXXXXXXXXXXXXXXXXXXXX
	//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//            0         1         2         3         4         5         6         7         8         9        10        11        12        13

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� DADOS IMPRESSOS NO RELATORIO    					         �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	SCBX->( DBGoTop() ) //mandar para o primeiro registro da consulta:elacerda
	nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho, esta funcao devolve a linha onde parou
	@ Prow() + 1,000 PSay cCabec_01
	@ Prow() + 1,000 pSay Repl( '*', 107 ) //replica o '*' 132 vezes

	While !SCBX-> ( EOF() )

		@ Prow() + 1,000 PSay AllTrim(SCBX->C2_NUM) //@ linha, coluna: prow() retorna a linha onde a cabeca de impressao se encontra
		@ Prow()    ,022 PSay RTrim(SCBX->C2_PRODUTO) //checar afastamento do c2_num e relacao com o cabecario
    @ Prow()    ,044 PSay RTrim(SCBX->B1_DESC)
    @ Prow()    ,093 PSay SCBX->Z00_TOTAL

		If Prow() > 58
			nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho em nova pagina
			@ Prow() + 1,000 PSay cCabec_01
			@ Prow() + 1,000 pSay Repl( '*', 107 )
		endIf

	SCBX->( dbskip() )

EndDo

@ Prow()	 + 1,000 PSay "Fim do Levantamento"

	If aReturn[5] == 1
	   Set Printer To
	   Commit
	   ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

	SCBX->( DbCloseArea() )
	MS_FLUSH()

Return Nil
