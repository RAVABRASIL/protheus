#INCLUDE "rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER007   º Autor ³ Flávia Rocha       º Data ³  09/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório Extrato Índices 5S                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 5S - RH                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
Solicitado pelo Chamado:
25/05/2011- 002147   	Regineide
PLANILHA DE CONTROLE PARA O PROGRAMA 5S CONFORME REUNIÃO,
ONDE DEVERÁ CONT ER OS ÍNDICES DE ACORDO COM A TABELA 
DE PONTUAÇÃO E UMA ESTRUTURA CONFORME MODELO ENTREGUE 
DE PLANO DE AÇÃO: - ESPAÇO PARA COLOCAR A FOTO DO PROBLEMA,
DESCREVER O PROBLEMA, O GUT, A DATA DE ENTRADA DA FOTO,
DATA DA SOLUÇÃO, COMO FOI RESOLVIDO E A FOTO DO DEPOIS.
NA FOTO QUE QUE SE REPETIR O ÍNDICE DEVERÁ CAIR OU SEJA PERDE 10 PONTOS
LEMBRANDO QUE NA PONTUAÇÃO DEVERÁ CONTER UMA FORMULAÇÃO PARA FOTO QUE FOR
COMUM AOS SETORES ONDE ESTÁ DEVERÁ CONTAR PARA TODOS NEGATIVOS OU POSITIVO(AO RESOLVER)  

Alterado em 24/04/12 - Chamado:002509 - Aline Farias
Inserir parâmetro que permita escolher se deseja imprimir todos ou apenas em aberto
MV_PAR06
*/

User Function GPER007


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Extrato Índices - 5S"
Local cPict          := ""
Local titulo       := "Extrato Índices - 5S"
Local nLin         := 80

Local Cabec1       := "Nome                           Depto                      Índice"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 0
Private tamanho          := "M"
Private nomeprog         := "GPER007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GPER007" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	   := "GPER007"

Private cString := "Z80"

dbSelectArea("Z80")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)

If mv_par05 = 1 //se for sintético por responsável ou por área, o layout é o pequeno
	tamanho := "P"
	limite  := 80
	nTipo   := 18
	titulo       += " - Por Responsável"
ElseIf mv_par05 = 3 //se for sintético por responsável ou por área, o layout é o pequeno
	tamanho := "P"
	limite  := 80
	nTipo   := 18
	Cabec1       := "Área                                          Quantidade"
	Cabec2       := "" 
	titulo       += " - Por Área"
Elseif mv_par05 = 2
	tamanho := "G"
	//Cabec1       := "Sol.Num.   G  U  T =>TOTAL      Emissão         Problema               Solução             Dt. Solução    No.Dias        GUT            GUT            Saldo             Créditos         Saldo Final"
	//Cabec2       := "                   Positivo                                                                                            Negativo        pós Resposta    Responsável       Enviou Foto?     Responsável"        
	//Cabec1       := "Sol.Num.   G  U  T =>TOTAL      Emissão         Problema               Solução             Dt. Solução    No.Dias        GUT            GUT            Saldo                              Saldo Final"
	//Cabec2       := "                   Positivo                                                                                            Negativo        pós Resposta    Responsável                        Responsável"        
	Cabec1       := "Sol.Num.   G  U  T =>TOTAL      Emissão         Problema               Area       Solução             Dt.Prevista    Dt. Solução    No.Dias        GUT            GUT             Saldo Final        Reincidência?"
	Cabec2       := "                   Positivo                                                                            Solução                                   Negativo        pós Resposta     Responsável      No. da SC Anterior:"        
	titulo       += " - Detalhado " 
	limite       := 220
	nTipo        := 15
Endif
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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/01/12   º±±
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

Local nOrdem
Local cQuery := ""
Local LF	 := CHR(13) + CHR(10)
Local aUsu   := {}
Local cDepto := ""
Local cRespo := "" 
Local cRespAnt := ""
Local cProblema := ""
Local cSolucao  := ""
Local aProbl    := {}
Local aSolu     := {}
Local nIndice   := 0
Local nDias     := 0
Local nGutot    := 0
Local nGutPosRes:= 0
Local nSaldo    := 0  //saldo do responsável até o momento de acordo com a solicitação lida  
Local nCredFoto := 0
Local nSaltot   := 0
Local aCredFoto := {}
Local x         := 1
Local adados    := {}
Local cSol      := ""
Local cSolant   := ""

//dbSelectArea(cString)
//dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par05 = 1              //SINTETICO POR RESPONSAVEL
	cQuery := "Select " + LF
	cQuery += " Sum(Z81_INDICE) AS INDICE, Z81_USER, Z81_NOME " + LF
	cQuery += " FROM " + RetSqlName("Z81") + " Z81 " + LF
	cQuery += " where D_E_L_E_T_ = '' " + LF
	cQuery += " and Z81_USER BETWEEN '" + Alltrim(mv_par01) + "' and '" + Alltrim(mv_par03) + "' " + LF
	cQuery += " GROUP BY Z81_USER, Z81_NOME " + LF 
	cQuery += " ORDER by Z81_NOME" + LF 
	MemoWrite("C:\Temp\gper007.sql",cQuery)
	If Select("TMPX") > 0
		DbSelectArea("TMPX")
		DbCloseArea()
	EndIf
			
	TCQUERY cQuery NEW ALIAS "TMPX"

Elseif mv_par05 = 3  //SINTÉTICO POR ÁREA
	cQuery := " SELECT COUNT(Z80_AREA) QTAS, Z80_AREA CODAREA, X5_DESCRI DESCAREA " + LF
	cQuery += " FROM "
	cQuery += " " + RetSqlName("Z80") + " Z80 , " + LF
	cQuery += " " + RetSqlName("SX5") + " SX5   " + LF
	cQuery += " WHERE Z80.D_E_L_E_T_= '' " + LF
	cQuery += " AND SX5.D_E_L_E_T_= '' " + LF
	cQuery += " AND Z80_AREA <> '' " + LF
	cQuery += " AND X5_TABELA = '5S' " + LF
	cQuery += " AND X5_CHAVE = Z80_AREA " + LF
	If !Empty(MV_PAR07)
		cQuery += " and Z80_EMISSA >= '" + Dtos(MV_PAR07) + "' " + LF
	Endif
	If !Empty(MV_PAR08)
		cQuery += " and Z80_EMISSA <= '" + Dtos(MV_PAR08) + "' " + LF
	Endif
	If mv_par06 = 1   //em aberto
		cQuery += " and Z80_DTSOL = '' " + LF
	Endif
	cQuery += " GROUP BY Z80_AREA, X5_DESCRI " + LF
	cQuery += " ORDER BY Z80_AREA " + LF
	MemoWrite("C:\Temp\gper007.sql",cQuery)
	If Select("TMPX") > 0
		DbSelectArea("TMPX")
		DbCloseArea()
	EndIf
			
	TCQUERY cQuery NEW ALIAS "TMPX"
	
Elseif mv_par05 = 2         //DETALHADO
	cQuery := "SELECT " + LF
	cQuery += " SUM(Z81_INDICE), Z80_INTEGR, " + LF
	cQuery += " Z80_NUMSOL, Z80_EMISSA, Z80_DTFOTO, Z80_DTSOL, Z80_CODMP, Z80_CODMR, " + LF
	cQuery += " Z80_GUT_G, Z80_GUT_U, Z80_GUT_T , Z80_SOLANT, Z80_QUENV, Z80_DTPREV, Z80_AREA " + LF
	cQuery += " FROM " + RetSqlName("Z81") + " Z81, " + LF
	cQuery += "      " + RetSqlName("Z80") + " Z80 " + LF
	cQuery += " where  " + LF
	cQuery += " Z81.D_E_L_E_T_ = '' " + LF
	cQuery += " and Z80.D_E_L_E_T_ = '' " + LF
	//cQuery += " and Z80_FILIAL = Z81_NUMSOL  " + LF
	cQuery += " and Z80_NUMSOL = Z81_NUMSOL  " + LF
	cQuery += " and SUBSTRING(Z80_INTEGR,1,6) >= '" + Alltrim(mv_par01) + "' and SUBSTRING(Z80_INTEGR,1,6) <= '" + Alltrim(mv_par03) + "' " + LF
	
	//dt inclusão
	If !Empty(MV_PAR07)
		cQuery += " and Z80_EMISSA >= '" + Dtos(MV_PAR07) + "' " + LF
	Endif
	If !Empty(MV_PAR08)
		cQuery += " and Z80_EMISSA <= '" + Dtos(MV_PAR08) + "' " + LF
	Endif
	//dt prevista solução
	If !Empty(MV_PAR09)
		cQuery += " and Z80_DTPREV >= '" + Dtos(MV_PAR09) + "' " + LF
	Endif
	If !Empty(MV_PAR10)
		cQuery += " and Z80_DTPREV <= '" + Dtos(MV_PAR10) + "' " + LF
	Endif
	//DT real solução
	If mv_par06 = 1
		cQuery += " and Z80_DTSOL = '' " + LF
	
	Else
		If !Empty(MV_PAR11)
			cQuery += " and Z80_DTSOL >= '" + Dtos(MV_PAR11) + "' " + LF
		Endif
		If !Empty(MV_PAR12)
			cQuery += " and Z80_DTSOL <= '" + Dtos(MV_PAR12) + "' " + LF
		Endif
	Endif
	
	
	cQuery += " Group BY Z80_INTEGR, " + LF
	cQuery += " Z80_NUMSOL, Z80_EMISSA, Z80_DTFOTO, Z80_DTSOL, Z80_CODMP, Z80_CODMR, " + LF
	cQuery += " Z80_GUT_G, Z80_GUT_U, Z80_GUT_T , Z80_SOLANT, Z80_QUENV, Z80_DTPREV, Z80_AREA " + LF
	//cQuery += " ORDER by Z80_NUMSOL " + LF
	cQuery += " Order BY Z80_INTEGR, " + LF
	cQuery += " Z80_NUMSOL, Z80_EMISSA, Z80_DTFOTO, Z80_DTSOL, Z80_CODMP, Z80_CODMR, " + LF
	cQuery += " Z80_GUT_G, Z80_GUT_U, Z80_GUT_T , Z80_SOLANT, Z80_QUENV, Z80_DTPREV, Z80_AREA " + LF
	MemoWrite("C:\Temp\gper007.sql",cQuery)
	If Select("TMPX") > 0
		DbSelectArea("TMPX")
		DbCloseArea()
	EndIf
			
	TCQUERY cQuery NEW ALIAS "TMPX"
	TcSetField("TMPX", "Z80_EMISSA","D") 
	TcSetField("TMPX", "Z80_DTFOTO","D")
	TcSetField("TMPX", "Z80_DTSOL","D")
	TcSetField("TMPX", "Z80_DTPREV","D")

Endif


If !TMPX->(EOF())

	If mv_par05 = 1  //SINTÉTICO POR RESPONSÁVEL
	    
	    If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 9
	    Endif
		@nLin,012 PSAY "Solicitações Emitidas De: " + Dtoc(mv_par07) + " A " + Dtoc(mv_par08) + " : "
		nLin++
		nLin++
		TMPX->(dbGoTop())
		While !TMPX->(EOF())
	
			///CAPTURA O EMAIL DO OPERADOR DO SISTEMA
			PswOrder(1)
			//If PswSeek( TMPX->Z81_USER , .T. )  
			If PswSeek( substr(TMPX->Z80_INTEGR,1,6) , .T. )
			   aUsu   := PSWRET() 				
			   //cUsu   := Alltrim( aUsu[1][2] )  
			   //cNomeUsr:= Alltrim( aUsu[1][4] )  
			   //cEmailUsr:= Alltrim( aUsu[1][14] )
			   cDepto:= Alltrim( aUsu[1][12] )
			Endif
		
		   
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 9
		   Endif
		   nGutPosRes := 0
		   nCredFoto  := 0
		   	cRespo    := TMPX->Z81_USER				 
		    @nLin,000 PSAY TMPX->Z81_NOME
		    @nLin,030 PSAY cDepto
		    //@nLin,057 PSAY ( nSaldo + nCredFoto ) /*TMPX->INDICE*/ PICTURE "@E 9,999.99"
		    @nLin,057 PSAY TMPX->INDICE PICTURE "@E 9,999.99"
			
		   nLin := nLin + 1 // Avanca a linha de impressao
		   TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	    Enddo
	    DbSelectArea("TMPX")
		DbCloseArea()
		
	ElseIf mv_par05 = 3  //SINTÉTICO POR ÁREA
	
		TMPX->(dbGoTop())
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 9
		Endif
		@nLin,012 PSAY "Solicitações Emitidas De: " + Dtoc(mv_par07) + " A " + Dtoc(mv_par08) + " : "
		nLin++
		nLin++
		While !TMPX->(EOF())
		
		   
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 9
		   Endif
		  
		    @nLin,000 PSAY TMPX->CODAREA + ' - ' + TMPX->DESCAREA
		    @nLin,047 PSAY TMPX->QTAS PICTURE "@E 9,999.99"
			
		   nLin := nLin + 1 // Avanca a linha de impressao
		   TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	    Enddo
	    DbSelectArea("TMPX")
		DbCloseArea()
		
    ElseIF mv_par05 = 2  //detalhado
    	DbSelectArea("TMPX")
    	TMPX->(dbGoTop())
    	While !TMPX->(EOF())
    		cProblema := ""
    		cSolucao  := ""
    		//If Alltrim(TMPX->Z80_NUMSOL) != Alltrim(cSolant)
	    		If !Empty(TMPX->Z80_CODMP)
	    			cProblema := MSMM(TMPX->Z80_CODMP,80) 
	    		Endif
	    		
	    		If !Empty(TMPX->Z80_DTSOL)
	    			cSolucao  := MSMM(TMPX->Z80_CODMR,80) 
	    		Endif
	    		//ALERT("1 - SOLUÇÃO: " + cSolucao)
	    		
	    //		Aadd( adados, { substr(TMPX->Z80_INTEGR,1,6),;    //1
	    						Aadd( adados, { TMPX->Z80_INTEGR,;
	    						"",;    //2
	    						cProblema ,; //TMPX->Z80_CODMP,;   //3
	    						cSolucao  ,; //TMPX->Z80_CODMR,;   //4
	    						TMPX->Z80_EMISSA,;  //5
	    						TMPX->Z80_DTSOL,;   //6
	    		                TMPX->Z80_GUT_G,;   //7
	    		                TMPX->Z80_GUT_U,;   //8
	    		                TMPX->Z80_GUT_T,;   //9http://sphotos-g.ak.fbcdn.net/hphotos-ak-ash3/521705_326219960823087_35023174_n.jpg
	    		                TMPX->Z80_NUMSOL,;  //10
	    		                TMPX->Z80_SOLANT,;  //11
	    		                TMPX->Z80_DTPREV,;  //12
	    		                TMPX->Z80_AREA } )  //13
	    		                
	    		    //cSolant := TMPX->Z80_NUMSOL
	    	//Endif
			TMPX->(dbSkip())    	
    	Enddo
    	DbSelectArea("TMPX")
		DbCloseArea()
		x := 1
    	While x <= Len(adados)
    	
    		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 9
		   Endif
	   	   
	   		///CAPTURA O EMAIL DO OPERADOR DO SISTEMA
			PswOrder(1)
			//If PswSeek( TMPX->Z81_USER , .T. )  
			If PswSeek( adados[x,1] , .T. )  
			
			   aUsu   := PSWRET() 				
			   //cUsu   := Alltrim( aUsu[1][2] )  
			   //cNomeUsr:= Alltrim( aUsu[1][4] )  
			   //cEmailUsr:= Alltrim( aUsu[1][14] )
			   cDepto:= Alltrim( aUsu[1][12] )
			Endif
			
	   		cRespo := adados[x,1] //TMPX->Z81_USER
	   		
	   		//@nLin,000 PSAY cRespo + ' -> '+ TMPX->Z81_NOME + " - Depto.: " + Substr(cDepto,1,20)
	   		@nLin,000 PSAY cRespo + ' -> '+ adados[x,2] + " - Depto.: " + Substr(cDepto,1,20)
	   		nLin++
	   		@nLin,000 PSAY Replicate("-",limite)
	   		nLin++
	   		cProblema := ""
	   		cSolucao  := ""
	   		aProbl    := {}
	   		aSolu     := {}
	   		
	   		//While Alltrim(TMPX->Z81_USER) = Alltrim(cRespo)	   	
	   		While x <= Len(adados) .and. Alltrim(adados[x,1]) = Alltrim(cRespo)	   	
	   			   		
	   			//If !Empty(TMPX->Z80_CODMP)
	   			//If !Empty(adados[x,3])
	   				cProblema := adados[x,3]  //MSMM(TMPX->Z80_CODMP)
	   				aProbl    := {}
	   				iif(len( alltrim(cProblema))>= 20,aProbl := wordWrap( ALLTRIM(cProblema),20 ),aProbl := wordWrap( ALLTRIM(cProblema), LEN(ALLTRIM(cProblema)) ) )
	   			//Endif
	   			
	   			//If !Empty(TMPX->Z80_CODMR)
	   			//If !Empty(adados[x,4])
	   				cSolucao  := adados[x,4]  //MSMM(TMPX->Z80_CODMR)
	   			//msgbox("problema: " + cProblema)
	   			//msgbox("solução : " + cSolucao)
	   				aSolu     := {}
	   				iif(len( alltrim(cSolucao)) >= 20,aSolu  := wordWrap( ALLTRIM(cSolucao),20 ),aSolu   := wordWrap( ALLTRIM(cSolucao), LEN(ALLTRIM(cSolucao)) ) )
	   			//Endif
	   			
	   			nDias := fCalcDIAS( adados[x,5], adados[x,6] )    //fCalcDIAS( TMPX->Z80_EMISSA, TMPX->Z80_DTSOL )  
	   			nGutot:= Val(adados[x,7]) + Val(adados[x,8]) + Val(adados[x,9]) //Val(TMPX->Z80_GUT_G) + Val(TMPX->Z80_GUT_U) + Val(TMPX->Z80_GUT_T)
	   			
	   			@nLin,000 PSAY adados[x,10] //NUMSOL 
	   			@nLin,010 PSAY adados[x,7] 		PICTURE "@E 9"    //G
	   			@nLin,013 PSAY adados[x,8] 		PICTURE "@E 9"    //U
	   			@nLin,016 PSAY adados[x,9] 		PICTURE "@E 9"    //T
	   			@nLin,018 PSAY "=>"             PICTURE "@X"      
	   			@nLin,021 PSAY nGutot           PICTURE "@E 99"   //GUT TOTAL
	   			@nLin,031 PSAY adados[x,5] 		PICTURE "@D" //emissão      
	   			@nLin,102 PSAY adados[x,12]		PICTURE "@D"	//dt PREV. SOLUÇÃO
	   			@nLin,114 PSAY adados[x,6]		PICTURE "@D"	//dt solução
	   			If !Empty(adados[x,6])  //(TMPX->Z80_DTSOL)
	   				@nLin,129 PSAY nDias            PICTURE "@E 9,999"
	   			Endif 
	   			
	   		//Cabec1       := "Sol.Num.   G  U  T =>TOTAL      Emissão         Problema               Solução             Dt. Solução    No.Dias        GUT            GUT            Saldo             Créditos"
			//Cabec2       := "                   Positivo                                                                                            Negativo        pós Resposta    Responsável       Envio Foto?"        
	   			
	   			@nLin,142 PSAY (nGutot * (-1) ) PICTURE "@E 9,999.99"    //GUT NEGATIVO
	   			nGutPosRes := 0
	   			If !Empty(adados[x,6]) //(TMPX->Z80_DTSOL)
	   				nGutPosRes := CalcGUT( nGutot, nDias, adados[x,11] ) //TMPX->Z80_SOLANT)
	   				@nLin,157 PSAY nGutPosRes PICTURE "@E 9,999.99"      //GUT PÓS RESPOSTA
	   			Endif
	   			
	   			nCredFoto  := 0
	   			nSaldo := 0
	   			nSaldo := ( nGutot * (-1) ) + nGutPosRes
	   			///procura se o responsável já possui créditos por envio de foto
	   		
	   			nSaltot += nSaldo 
	   			@nLin,180 PSAY nSaldo PICTURE "@E 9,999.99"  ///SALDO FINAL PÓS CÁLCULO E CRÉDITOS
	   			If !Empty(adados[x,11]) //TMPX->Z80_SOLANT)
	   				@nLin,194 PSAY adados[x,11] /*TMPX->Z80_SOLANT*/ PICTURE "@!"  
	   			Endif
	   			
	   			If SX5->(Dbseek(xFilial("SX5") + "5S" + adados[x,13] ))
	   				@nLin,066 PSAY Substr(SX5->X5_DESCRI,1,12)      //ÁREA
	   			Endif
	   			
	   		   			
	   			If Len(aProbl) > Len(aSolu)
	
				    nTam := 1
					For y:=1 to len(aProbl)
						
						If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 8
						Endif
						
						@nLin,041 PSAY Alltrim(aProbl[y][1])
						
						If Len(aSolu) > 0				
							If nTam <= Len(aSolu)
								@nLin,080 PSAY Alltrim(aSolu[y][1])
								nTam++
							Endif
						Elseif(y=1)
							@nLin,080 PSAY "Sem Resposta"
						Endif
						nLin++
					Next
					if len(aProbl)=0
						nLin++
						//nLin++
					endif
				Else
					nTam := 1
					For y:=1 to len(aSolu)
						
						If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 8
						Endif
						
						If Len(aProbl) > 0			
							If nTam <= Len(aProbl)
								@nLin,041 PSAY Alltrim(aProbl[y][1])
								nTam++
							Endif
						Endif
						@nLin,080 PSAY Alltrim(aSolu[y][1])
						nLin++
					Next
					if len(aSolu)=0
						nLin++ 
						//nLin++
					endif
					
				Endif
	   			
	   			nLin++
	   			//DbSelectArea("TMPX")
	   			//TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	   		    x++
	   		Enddo
	   		//DbSelectArea("TMPX")
	   		//@nLin,000 PSAY Replicate("_",132)
	   		
	   		aCredFoto := fTemFoto( cRespo )
	   		nCredFoto := aCredFoto[1,1]
	   		nQtasFoto := aCredFoto[1,2]
	   		If nCredFoto > 0
	   			nLin++
	   			@nLin,159 PSAY "CRÉDITOS FOTO .....: " + Transform(nCredFoto , "@E 9,999.99") 
	   			//nLin++
	   			@nLin,190 PSAY "QTDE. FOTOS .: " + Transform(nQtasFoto , "@E 9,999.99")  //+ " Foto(s)."
	   			nLin++                                                                                      
	   			@nLin,159 PSAY "SALDO .............: " + Transform(nSaltot   , "@E 9,999.99")
	   			nLin++
	   			@nLin,153 PSAY   "SALDO FINAL (c/Creditos).: " + Transform( (nSaltot + nCredFoto) , "@E 9,999.99") //Transform( nIndice , "@E 9,999.99")
	   		Else
	   			@nLin,159 PSAY "SALDO FINAL .......: " + Transform( (nSaltot + nCredFoto) , "@E 9,999.99") //Transform( nIndice , "@E 9,999.99")
	   		Endif
	   		nLin++
	   		@nLin,000 PSAY Replicate("_",limite)
	   		nLin++                     
	   		nLin++
	   		nIndice := 0
	   		nSaltot := 0
	   		
	   		   	
		Enddo
		   		
	Endif

Else
	MsgInfo("Sem dados a apresentar.")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda( 0, "", TAMANHO )

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

Return


***************

Static Function wordWrap( cText, nRegua )

***************

Local aRet  := {}
Local cTemp := ''
Local i 	:= 1
cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( cTemp ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet   

*********************************************
Static Function fCalcDIAS( dEMISSA, dDTSOL ) 
*********************************************

Local nDUtil := 0
Local nDias  := 0  
Local dDtIni := Ctod("  /  /    ")
Local dDtMov := Ctod("  /  /    ")

If dDTSOL >= dEMISSA
		nDUtil := 0
		dDtIni := dEMISSA
		dDtMov := dDtIni
		While dDtMov <= dDTSOL 	
			dDtMov := dDtMov + 1	
			If Dow(dDtMov) > 1 .and. dDtMov <= dDTSOL
					nDUtil := nDUtil + 1	
			Endif	
		EndDo
	    nDias := nDUtil
Else
	nDias := 0
Endif
    
Return(nDias)


//CÁLCULO DO GUT
***************************************
Static Function CalcGUT(nTot, nDias, cSolant)
***************************************

Local nIndice:= 0
Local nPerGut:= 0
//Local nTot  := Val(cTot)

/*
3 , 5 
 110% - 0 a 4 dias
 100% - 5 a 7 dias
 90% - 8 a 10 dias
 80% - acima de 11 dias
 

7 , 9
 110% - 0 a 7 dias
 100% - 8 a 12 dias
 90%  - 13 a 16 dias 
 80%  - acima de 17 dias 
 
11 , 13
  110% - 0 a 10 dias
  100% - 11 a 15 dias
  90%  - 16 a 20 dias 
  80%  - acima de 21 dias 
  
15
  110% - 0 a 20 dias
  100% - 21 a 30 dias
  90%  - 31 a 40 dias 
  80%  - acima de 41 dias 

*/

If nTot = 3 .or. nTot = 5
	If Alltrim(cSolant) = ''
		If nDias <= 4 
			nPerGut := (110 / 100)		
		Elseif nDias <= 7 
			nPerGut := (100 / 100)		
		Elseif nDias <= 10 
			nPerGut := (90 / 100)		
		Elseif nDias >= 11 
			nPerGut := (80 / 100)		
		Endif
		//nIndice := (nTot * nPerGut) - nTot
	Else     //reincid.
		If nDias <= 4 
			nPerGut := (100 / 100)		
		Elseif nDias <= 7 
			nPerGut := (90 / 100)		
		Elseif nDias <= 10 
			nPerGut := (80 / 100)		
		Elseif nDias >= 11 
			nPerGut := (70 / 100)		
		Endif
	
	Endif

ElseIf nTot = 7 .or. nTot = 9
	If Alltrim(cSolant) = ''
		If nDias <= 7 
			nPerGut := (110 / 100)	
		Elseif nDias <= 12 
			nPerGut := (100 / 100)	
		Elseif nDias <= 16 
			nPerGut := (90 / 100)	
		Elseif nDias >= 17 
			nPerGut := (80 / 100)	
		Endif
	Else 
		If nDias <= 7 
		nPerGut := (100 / 100)	
		Elseif nDias <= 12 
			nPerGut := (90 / 100)	
		Elseif nDias <= 16 
			nPerGut := (80 / 100)	
		Elseif nDias >= 17 
			nPerGut := (70 / 100)	
		Endif
	Endif
	
ElseIf nTot = 11 .or. nTot = 13
	If Alltrim(cSolant) = ''
		If nDias <= 10 
			nPerGut := (110 / 100)	
		Elseif nDias <= 15 
			nPerGut := (100 / 100)	
		Elseif nDias <= 20 
			nPerGut := (90 / 100)	
		Elseif nDias >= 21 
			nPerGut := (80 / 100)	
		Endif
	Else 
		If nDias <= 10 
			nPerGut := (100 / 100)	
		Elseif nDias <= 15 
			nPerGut := (90 / 100)	
		Elseif nDias <= 20 
			nPerGut := (80 / 100)	
		Elseif nDias >= 21 
			nPerGut := (70 / 100)	
		Endif
	Endif
	//nIndice := (nTot * nPerGut) - nTot
ElseIf nTot = 15
	If Alltrim(cSolant) = ''
		If nDias <= 20 
			nPerGut := (110 / 100)	
		Elseif nDias <= 30 
			nPerGut := (100 / 100)	
		Elseif nDias <= 40 
			nPerGut := (90 / 100)	
		Elseif nDias >= 41 
			nPerGut := (80 / 100)
		Endif
	Else 
		If nDias <= 20 
			nPerGut := (100 / 100)	
		Elseif nDias <= 30 
			nPerGut := (90 / 100)	
		Elseif nDias <= 40 
			nPerGut := (80 / 100)	
		Elseif nDias >= 41 
			nPerGut := (70 / 100)
		Endif
	Endif
	
Endif
//nIndice := (nTot * nPerGut) - nTot
//MSGBOX("nTot: " + str(nTot) )
//MSGBOX("nPerGut: " + str(nPerGut) )
nIndice := (nTot * nPerGut)

Return(nIndice)

**************************************
Static Function fTemFoto( cRespon )   
**************************************
Local cQuery    := ""
Local LF        := chr(13) + chr(10)
Local aRetorno  := {}
Local nCreditos := 0
Local nQtas     := 0

cQuery := "Select " + LF
cQuery += " Z80_QUENV, * " + LF
cQuery += " From " + RetSqlName("Z80") + " Z80 " + LF
cQuery += " Where D_E_L_E_T_ = '' " + LF
cQuery += " and Z80_QUENV = '" + Alltrim(cRespon) + "' " + LF
cQuery += " and Z80_QUENV <> '' " + LF
MemoWrite("C:\Temp\fTemFoto.sql",cQuery)
	If Select("FOTX") > 0
		DbSelectArea("FOTX")
		DbCloseArea()
	EndIf
			
	TCQUERY cQuery NEW ALIAS "FOTX"
dbGoTop()
If !FOTX->(EOF())
	While !FOTX->(EOF())
		
		nQtas++
		nCreditos += 0.5
		FOTX->(DBSKIP())
	Enddo
Endif
If Select("FOTX") > 0
	DbSelectArea("FOTX")
	DbCloseArea()
EndIf
Aadd(aRetorno , { nCreditos , nQtas } )

Return(aRetorno)