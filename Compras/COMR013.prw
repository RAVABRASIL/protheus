#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMR013                               º Data ³  18/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de % Frete pago sobre Valor Compras POR NF       º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado por Marcelo em 16/07/13                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							

***************************
User Function COMR013()
***************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "% Frete Pago sobre Compras"
Local cPict          := ""
Local titulo       := "% Frete Pago sobre Compras (POR NF) - TIPO FOB"
Local nLin         := 80

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "COMR013" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "COMR013" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := 'COMR013'
Private cString := "SC7"
Private Cabec2     := ""
Private Cabec1     := "NFs Entrada de :"

dbSelectArea("SC7")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PERGUNTE(cPerg,.T.)
wnrel := SetPrint(cString,NomeProg,"COMR013",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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




******************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
******************************************************


Local nOrdem
Local cQuery	:=' '
Local LF 		:= CHR(13) + CHR(10)
Private cCodFil	:= "" 
Cabec1 += DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02)
If MV_PAR03 = 1 //SINTÉTICO
	limite       := 80
	Cabec2       := "Total Compras     Total Frete Pago     %Frete sobre Compras"
	tamanho      := 'P'
Elseif MV_PAR03 = 2 //ANALÍTICO 
	limite       := 220
	Cabec2       := "Tipo  NF / Série   Emissão     Dt.Lançto.  Valor NF      Peso      Valor Frete   %Frete sobre Compras   FORNECEDOR          LOCALIDADE            UF   PED.COMPRA   TRANSPORTADORA"
	tamanho      := 'G'
Endif
	//cQuery:=" --ANALITICO " + LF
	
	//FR - FLÁVIA ROCHA - 17/10/13 - CONFORME CHAMADO 555 : REVISÃO DO RELATÓRIO, PARA CONSIDERAR O FRETE DO CONHECIMENTO ORIGINAL
	//E NÃO DO QUE FOI LANÇADO NO PEDIDO DE COMPRA (POIS NESTE CASO, É UMA PRÉVIA )
	//NOVA QUERY
	
	//FR - NOVA REVISÃO, EXTRATIFICANDO NOTA POR NOTA
	cQuery := " Select F8_NFORIG,F8_NFDIFRE, F8_SEDIFRE  " + LF	
	
	cQuery += " -- nf entrada compra " + LF
	cQuery += " ,F1.F1_DOC, F1.F1_SERIE,F1.F1_FORNECE, F1.F1_EMISSAO, F1.F1_DTDIGIT, F1.F1_VALMERC, F1.F1_VALBRUT VALCOMPRA " + LF	
	cQuery += " ,F1.F1_PBRUTO, F1.F1_PLIQUI, F1.F1_PESOL " + LF
	
	cQuery += " , C7.C7_NUM PEDIDO " + LF         
	
	cQuery += " -- nf entrada frete " + LF
	cQuery += " ,F1F.F1_DOC F1NFFRE , F1F.F1_SERIE F1SERIFRE, F1F.F1_VALBRUT VALFRETE " + LF	
	
	cQuery += " -- dados do fornecedor compra " + LF
	cQuery += " ,A2C.A2_NOME FORN_COMPRA, A2C.A2_MUN, A2C.A2_EST  " + LF	
	cQuery += " , F8.F8_TRANSP  " + LF
	
	cQuery += " -- dados fornecedor frete " + LF	
	cQuery += " ,A2F.A2_NREDUZ FORN_FRET  " + LF	
	
	cQuery += " ,C7.C7_NUM , B1.B1_TIPO " + LF
	//cQuery += " ,*   " + LF	
	cQuery += " from " + LF
	cQuery += " " + RetSqlname("SF1") + " F1 " + LF //nf entrada compra
	cQuery += " , " + RetSqlname("SD1") + " D1 " + LF //nf entrada compra
	cQuery += " , " + RetSqlname("SC7") + " C7 " + LF //pedido de compra
	cQuery += " , " + RetSqlname("SB1") + " B1 " + LF //produtos comprados
	cQuery += " , " + RetSqlname("SF8") + " F8 " + LF  //conhecimento frete
	cQuery += " , " + RetSqlname("SA2") + " A2C "+ LF  //fornecedor da compra
	cQuery += " , " + RetSqlname("SA2") + " A2F "+ LF  //fornecedor do frete
	cQuery += " , " + RetSqlname("SF1") + " F1F " + LF	//nf entrada frete
	cQuery += " WHERE " + LF
	
	cQuery += " F1.F1_FILIAL = '" + Alltrim(xFilial("SF1")) + "' " + LF
	cQuery += " AND F1.F1_EMISSAO BETWEEN  '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' " + LF
	cQuery += " AND B1.B1_TIPO IN ('MP','MS','ME', 'AC' ) " + LF  //VOLTAR
	
	//cQuery += " AND B1.B1_TIPO = 'ME' " + LF //retirar
	
	cQuery += " AND C7.C7_TPFRETE = 'F' " + LF //só FOB
 	
	//associa SF8 - Conhecimento frete com NF entrada compra ORIGINAL	
	cQuery += " AND F8_FILIAL = F1.F1_FILIAL " + LF
	cQuery += " AND F8_NFORIG = F1.F1_DOC  " + LF	
	cQuery += " AND F8_SERORIG = F1.F1_SERIE  " + LF	    
	//associa SF8 - Conhecimento frete com fornecedor do frete
	cQuery += " AND F8_TRANSP = A2F.A2_COD  " + LF	
	cQuery += " AND F8_LOJTRAN = A2F.A2_LOJA  " + LF	
	//associa SF1 - nf entrada compra com fornecedor da compra
	cQuery += " AND F1.F1_FORNECE = A2C.A2_COD  " + LF	
	cQuery += " AND F1.F1_LOJA = A2C.A2_LOJA  " + LF	
	//associa SF1 - entrada Frete com SF8 conhecimento frete
	cQuery += " AND F1F.F1_FILIAL = F8.F8_FILIAL " + LF
	cQuery += " AND F1F.F1_DOC = F8.F8_NFDIFRE   " + LF
	cQuery += " AND F1F.F1_SERIE = F8.F8_SEDIFRE " + LF 
	cQuery += " AND F1F.F1_FORNECE = F8.F8_TRANSP " + LF 
 	cQuery += " AND F1F.F1_LOJA = F8.F8_LOJTRAN " + LF 
	
	//associa SF1 - nf entrada compra com Sc7 pedido compra
	cQuery += " AND F1.F1_FORNECE = C7.C7_FORNECE " + LF
	cQuery += " AND F1.F1_LOJA = C7.C7_LOJA " + LF         
	//associa SF1 - Nf entrada compra com SD1 iten nf compra
	cQuery += " AND F1.F1_FILIAL = D1.D1_FILIAL " + LF
	cQuery += " AND F1.F1_DOC = D1.D1_DOC " + LF
	cQuery += " AND F1.F1_SERIE = D1.D1_SERIE " + LF
	cQuery += " AND F1.F1_FORNECE = D1.D1_FORNECE " + LF
	cQuery += " AND F1.F1_LOJA = D1.D1_LOJA " + LF
	//associa SD1 - item nf entrada com pedido compra
	cQuery += " AND D1.D1_FILIAL = C7.C7_FILIAL " + LF
	cQuery += " AND D1.D1_PEDIDO = C7.C7_NUM " + LF
	cQuery += " AND D1.D1_COD = C7.C7_PRODUTO " + LF
	cQuery += " AND D1.D1_COD = B1.B1_COD " + LF

	
	cQuery += " AND F1.D_E_L_E_T_=''  " + LF	
	cQuery += " AND D1.D_E_L_E_T_=''  " + LF	
	cQuery += " AND B1.D_E_L_E_T_=''  " + LF	
	cQuery += " AND C7.D_E_L_E_T_=''  " + LF	
	cQuery += " AND F8.D_E_L_E_T_=''  " + LF	
	cQuery += " AND A2C.D_E_L_E_T_=''  " + LF	
	cQuery += " AND A2F.D_E_L_E_T_=''  " + LF	
	cQuery += " AND F1F.D_E_L_E_T_=''  " + LF	
   	//If MV_PAR03 = 1 //SINTÉTICO                                             
   	//	cQuery += " ORDER BY (F8.F8_NFDIFRE + F8.F8_SEDIFRE)  " + LF	
   	//Else
   		cQuery += " ORDER BY B1_TIPO, (F8.F8_NFDIFRE + F8.F8_SEDIFRE)  " + LF	
   	//Endif
	

MemoWrite("C:\Temp\COMR013.SQL",cQuery)

If Select("AUUX") > 0
	DbSelectArea("AUUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUUX"

TcSetField("AUUX", "F1_DTDIGIT" , "D" )                                                       
TcSetField("AUUX", "F1_EMISSAO" , "D" )                                                       
AUUX->(DbGoTop())
/*
cCodFil	:= SM0->M0_CODFIL

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava - " + SM0->M0_FILIAL
Endif
*/

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

cNFAnt 	:= ""
nTotFre	:= 0
nTotComp:= 0
aDados 	:= {}
nCt     := 1
nTotGerF:= 0
nTotGerC:= 0
cTP     := ""
If !AUUX->(EOF())            
	AUUX->(DBGOTOP())
	While AUUX->(!EOF())
	
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
	
	   	If MV_PAR03 = 1 //SINTÉTICO
	   	  	If Alltrim(AUUX->F8_NFDIFRE + AUUX->F8_SEDIFRE) != Alltrim(cNFAnt)	
		   	   	nTotGerF += AUUX->VALFRETE //aDados[nCt,8]
				nTotGerC += AUUX->VALCOMPRA //aDados[nCt,6]
				cNFAnt := Alltrim(AUUX->F8_NFDIFRE + AUUX->F8_SEDIFRE)
			Endif
   			AUUX->(Dbskip())	  
	   	Elseif MV_PAR03 = 2 //ANALÍTICO
	   		cTP 	:= AUUX->B1_TIPO
			nTotFre := 0
			nTotComp:= 0
			cNFAnt  := ""
			If nCt > 1
				@nLin,000 PSAY Repli("-",limite)  //faz linha divisória entre os tipos
		  		nLin++   
		  	Endif
		  	
			While !AUUX->(EOF()) .and. Alltrim(AUUX->B1_TIPO) = Alltrim(cTP)
				If Alltrim(AUUX->F8_NFDIFRE + AUUX->F8_SEDIFRE) != Alltrim(cNFAnt)
				   //TIPO PROD Nº NOTA FISCAL DT EMISSÃO DT LANÇAMENTO VALOR NOTA FISCAL PESO NF VALOR FRETE % FRETE
				   	nTotFre  += AUUX->VALFRETE 
					nTotGerF += AUUX->VALFRETE //acumulador do total geral frete
					nTotComp += AUUX->VALCOMPRA//acumulador do total geral compras
					nTotGerC += AUUX->VALCOMPRA
					@nLin,000 PSAY AUUX->B1_TIPO PICTURE "@!" //tipo produto
					@nLin,003 PSAY AUUX->F1_DOC + "/"
					@nLin,013 PSAY AUUX->F1_SERIE
					@nLin,019 PSAY Dtoc(AUUX->F1_EMISSAO)
					@nLin,032 PSAY Dtoc(AUUX->F1_DTDIGIT)
					@nLin,040 PSAY Transform(AUUX->VALCOMPRA , "@E 9,999,999.99") //valor compra
					@nLin,054 PSAY Transform(AUUX->F1_PBRUTO, "@E 999,999.99") //peso
					@nLin,066 PSAY Transform(AUUX->VALFRETE, "@E 9,999,999.99") //valor frete
					@nLin,085 PSAY Transform( (AUUX->VALFRETE / AUUX->VALCOMPRA ) * 100 , "@E 999.99") + "%" //% frete sobre compras
					@nLin,100 PSAY Substr(AUUX->FORN_COMPRA,1,20)
					@nLin,123 PSAY Substr(AUUX->A2_MUN,1,20)
					@nLin,146 PSAY AUUX->A2_EST
					@nLin,152 PSAY AUUX->PEDIDO
					@nLin,163 PSAY AUUX->FORN_FRET
			   		nLin++	   		 				
		   			nCt++
		   			cNFAnt := Alltrim(AUUX->F8_NFDIFRE + AUUX->F8_SEDIFRE)
		   		Endif
		   		AUUX->(Dbskip())
		  	Enddo
		  	@nLin,000 PSAY Repli(".",limite) //passa a linha pra fazer o total por tipo
		  	nLin++
		  	//alert("ntotcompra: " + str(nTotComp) + " - ntotfrete: " + str(nTotFre) )
		  	@nLin,003 PSAY "SUBTOTAL    R$"
		  	@nLin,040 PSAY Transform(nTotComp, "@E 9,999,999.99") 
		  	@nLin,066 PSAY Transform(nTotFre, "@E 9,999,999.99")
		  	@nLin,085 PSAY Transform( (nTotFre / nTotComp ) * 100 , "@E 999.99") + "%" //% frete sobre compras
		  	nLin++
		  	nTotComp := 0
		  	nTotFre  := 0
		  	
		  	
	   Endif //tipo relatório: sintético / analítico
	   				
	
	Enddo
	///total geral	
	if MV_PAR03 = 2 //ANALÍTICO
		
		@nLin,000 PSAY Repli("=",limite)
		nLin++
		@nLin,003 PSAY "TOTAL GERAL   R$"
		@nLin,040 PSAY Transform(nTotGerC, "@E 9,999,999.99")
			
		@nLin,066 PSAY Transform(nTotGerF, "@E 9,999,999.99")
		@nLin,085 PSAY Transform( (nTotGerF / nTotGerC) * 100, "@E 999.99") + "%"	
	else
		@nLin,000 PSAY "R$"
	   	@nLin,003 PSAY Transform(nTotGerC , "@E 9,999,999.99") //total compras
		//@nLin,016 PSAY "R$"
	   	@nLin,019 PSAY Transform(nTotGerF , "@E 9,999,999.99") //total frete
	   	@nLin,038 PSAY Transform( (nTotGerF / nTotGerC ) * 100 , "@E 999.99") //% frete sobre compras
	   	nLin++
	endif
	

	AUUX->(DbCloseArea())
	Roda(0, "" , Tamanho)
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

Else
	MsgInfo("Não Existem Dados Para os Parâmetros Solicitados!")	
Endif


Return

