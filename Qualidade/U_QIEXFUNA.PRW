//#include "QIEXFUNA.CH"
#Include "RWMAKE.CH"  
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QIEXFUNA  ³ Autor ³ Paulo Emidio de Barros³ data ³23/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcoes genericas utilizadas na Integracao EST x QIE e movi-³±±
±±³			 ³tacoes referentes ao Estoque.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAQIE													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³STR 	     ³ Ultimo utilizado -> 00132                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Paulo Emídio³18/05/01³META  ³ Ordenada a ordem dos parametros nas fun- ³±±
±±³            ³        ³      ³ coes a200CoIn() e a200SkLt().            ³±±
±±³Paulo Emídio³07/06/01³META  ³ Implementada parametrizacao, para que se-³±±
±±³            ³        ³      ³ jam definidos os Tipos de Notas Fiscais  ³±±
±±³            ³        ³      ³ de Entradas a serem enviadas para Inspe- ³±±
±±³            ³        ³      ³ cao, sendo o controle atraves dos parame-³±± 
±±³            ³        ³      ³ tros: MV_QNFENOR, MV_QNFEBEN, MV_QNFEDEV ³±±
±±³Cleber Souza³02/07/03³      ³ Implementada verificacao na rotina       ³±±
±±³            ³        ³      ³ qAtuMatQie parq gerar inconsistencia     ³±±
±±³            ³        ³      ³ para podutos com especificacoes sem      ³±±
±±³            ³        ³      ³ ensaio na importacao.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QATUMATQIE³ Autor ³ Paulo Emidio de Barros³ data ³23/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³realiza a Integracao MAT x QIE, atualizando os arquivos re- ³±±
±±³			 ³ferente ao SIGAQIE.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPA1 = Array contendo os dados enviados na Integracao	  ³±±
±±³			 ³ EXPN1 = 1)Inclusao, 2)Exclusao 						 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPA1 = {EXPC1,EXPC2,EXPL1}								  ³±±
±±³			 ³ 													 		  ³±±
±±³			 ³ Onde:  EXPC1 = "C" Entrada certificada					  ³±±
±±³			 ³ 				  "D" Entrada Excluida						  ³±±
±±³			 ³ 				  "E" Erro na Integracao					  ³±±
±±³			 ³ Onde:  EXPC2 = "C" Mensagem a ser enviada na acao          ³±±
±±³			 ³        EXPL1 = .T. Realizou a Integracao 				  ³±±
±±³			 ³ 				  .F. Nao realizou a Integracao				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ qAtuMatQie()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function qAtuMatQie(aDados,nOpc,lImportacao)                                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao das  variaveis de trabalho						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreaAnt   := GetArea()
Local lGrvQEK    := .T.
Local aRetQie    := {}
Local cMsgQie    := ""
Local lDelQie    
Local cKeyQEK    := ""                                                  
Local cRevi      := ""              
Local cMsgLap    := ""
Local cFatApr    := ""
Local cFatRep    := ""
Local cSeekQEK   := ""      
Local cLotUni    := ""
Local cTamLot    := ""
Local cTamLotOri := ""
Local cCodEnt    := ""
Local cUniMed    := ""
Local cUniAmo    := ""
Local nShelf     := ""
Local cFatCon    := ""
Local cTipCon    := ""
Local nDec       := 0
Local nTam       := 0
Local cTamAmo    := ""
Local cGrupo     := ""
Local nMvDiAtr   := ""
Local cMvCoDia   := ""
Local nDiasAtr   := 0
Local nSklEnt	 := 0
Local nCntEnt	 := 0
Local nCntAte 	 := 0
Local aJustif    := {}
Local nVerifica  := 1
Local lPrimDoc   
Local lAltEsp    
Local cApNBR5426 := GetMv("MV_QNBR542") //define se a NBR5426 sera aplicada na inspecao das Entradas
Local cApSkpTest := GetMv("MV_QSKPTES") //define o tipo de Skip-Teste a ser aplicado
Local cQCerEnt   := GetMv("MV_QCERENT") // Verif. se a Entrada pode ser certificada se existir ensaio a inspecionar pelo skip-teste
Local aEnsInsp   := {}     
Local nX
Local lQtdRep    
Local lCtrSkLSkT := .T.
Local cProduto   := " "
Local cLoteQie   := " "
Local nTamLote   := TamSX3("QEK_LOTE")[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na gravacao do Plano de amostragem por ensaio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAtPlAmo   := GetMv("MV_QATUPAM") // Atualizacao automatica do Plano de Amostragem
Local cAtPlAmIQS := GetMv("MV_QPAMIQS") // Atualizcao do Plano de Amostragem vinculado ao IQS
Local nIQSRep    := GetMv("MV_QIQSREP") // Nota para o IQS reprovado
Local lEmissao   := GetMv("MV_QDTNFIM") //Indica se a Revisao do Produto sera verificada pela data de Emissao da Nota Fiscal
Local lAtuPA          
Local aModVld    := {}
Local cSeekQEP   := ""
Local cSeekSD7   := ""

Local lRetQie 
Local lQeMatIns  := ExistBlock("QEMATINS")
Local lQeMatFin  := ExistBlock("QEMATFIN") 
Local lQeMatDel  := ExistBlock("QEMATDEL")
Local lQeMatFor  := ExistBlock("QEMATFOR")

Local aAreaSD1 
Local aAreaSD7
Local aAreaSCM  
Local aAreaSA2
Local aMov       := {}    
Local aCM        := Afill(Array(5),0)  

Private lInconsistencia := .F. //Indica se houve inconsistencia na Entrada atual

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena os programas que realizam integracao com o SIGAQIE  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aModVld,"MATA100")
Aadd(aModVld,"MATA103")
Aadd(aModVld,"MATA140")
Aadd(aModVld,"MATA260")
Aadd(aModVld,"MATA261")
Aadd(aModVld,"MATA101")
Aadd(aModVld,"MATA102")
Aadd(aModVld,"MATA465")
Aadd(aModVld,"MATA466") 
                              
//Realiza uma copia do Vetor aDados, que contem o registro de Importacao
Private aDadosQIE := aClone(aDados)

lImportacao := If(lImportacao==NIL,.T.,lImportacao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se analise do Skip-Lote e/ou Skip-Teste sera aplica-³
//³ da na Entrada a Inspecionar.			   					 ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (aDadosQie[03] $ "D/B") //Nao considera as Notas referentes a Devolucao e Beneficiamento  
	lCtrSkLSkT := .F.
	
ElseIf (AllTrim(aDadosQie[06]) == "TR") //Verifica se as Trabsferencias serao consideradas
	lQtdRep := If(GetMV("MV_QTRFREP")=="S",.T.,.F.)
    If lQtdRep
		lCtrSkLSkT := .F.
	EndIf	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³              Array de Integracao dos dados - (LayOut para Importacao)             ³ 
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄ´
//³                 Descricao               ³   Origem Materiais   ³ TIPO ³ TAM ³ DEC ³ 
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄ´
//³                							³                      ³	  ³		³     ³ 
//³ [01] - Numero da Nota Fiscal 	 		³ D1_DOC               ³  C   ³	06	³  0  ³  
//³ [02] - Serie da Nota Fiscal           	³ D1_SERIE   	       ³  C	  ³	03	³  0  ³ 
//³ [03] - Tipo da Nota Fiscal   		 	³ D1_TIPO              ³  C   ³	01	³  0  ³  
//³ [04] - Data de Emissao da Nota Fiscal   ³ D1_EMISSAO           ³  D	  ³	08	³  0  ³
//³ [05] - Data de Entrada da Nota Fiscal   ³ D1_DTDIGIT           ³  D	  ³	08	³  0  ³
//³ [06] - Tipo de Documento -> default "NF"³ "NF" ou "REMITO"     ³  C	  ³	06	³  0  ³ 
//³ [07] - Item da Nota Fiscal				³ D1_ITEM              ³  C	  ³	02	³  0  ³ 
//³ [08] - Numero do Remito (Localizacoes)  ³ D1_REMITO            ³  C	  ³	12	³  0  ³ 
//³ [09] - Numero do Pedido de Compra       ³ D1_PEDIDO            ³  C	  ³	06	³  0  ³
//³ [10] - Item do Pedido de Compra         ³ D1_ITEMPC            ³  C	  ³	02	³  0  ³
//³ [11] - Codigo Fornecedor/Cliente        ³ D1_FORNECE           ³  C	  ³	06	³  0  ³
//³ [12] - Loja Fornecedor/Cliente          ³ D1_LOJA     	       ³  C	  ³	02	³  0  ³
//³ [13] - Numero do Lote do Fornecedor     ³ D1_LOTEFOR     	   ³  C	  ³	18	³  0  ³
//³ [14] - Codigo do Solicitante            ³ SPACE(6)     		   ³  C   ³	06	³  0  ³
//³ [15] - Codigo do Produto                ³ D1_COD     	       ³  C	  ³	06	³  0  ³
//³ [16] - Local Origem    				    ³ D1_LOCAL   	   	   ³  C	  ³	02	³  0  ³
//³ [17] - Numero do Lote             		³ D5_LOTECTL 	       ³  C	  ³	10	³  0  ³
//³ [18] - Sequencia do Sub-Lote         	³ D5_NUMLOTE     	   ³  C	  ³	06	³  0  ³
//³ [19] - Numero Sequencial                ³ D1_NUMSEQ            ³  C	  ³	06	³  0  ³ 
//³ [20] - Numero do CQ					    ³ D1_NUMCQ		       ³  C	  ³	06	³  0  ³
//³ [21] - Quantidade             			³ D1_QUANT		       ³  N	  ³ 11	³  2  ³
//³ [22] - Preco             				³ D1_TOTAL 		       ³  N	  ³	14	³  2  ³
//³ [23] - Dias em atraso				    ³ D1_DTDIGIT-C7_DATPRF ³  N	  ³	04	³  0  ³
//³ [24] - TES (somente Materiais)			³ D1_TES		       ³  C	  ³	03	³  0  ³
//³ [25] - Origem							³ FunName()		       ³  C	  ³	08	³  0  ³
//³ [26] - Origem Importacao TXT			³ 				       ³  C	  ³	12	³  0  ³
//³ [27] - Quantidade do Lote Original      ³ 					   ³  N	  ³ 11	³  2  ³
//³ [28] - Hora da Entrada				    ³ 					   ³  C	  ³ 05	³  0  ³
//³                					  	    ³	      		       ³	  ³		³     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os Tipos de Entradas validados na Integracao, somen-³
//³ te Normal, Devolucao e Beneficiamento.						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (!(aDadosQie[03] $ " NDB") .And. cPaisLoc == "BRA") .Or.;
	(!(aDadosQie[03] $ " NBCD") .And. cPaisLoc # "BRA")
	    
	cMsgQie := "Material liberado do CQ e nao enviado para Inspecao"
	aRetQie := {"L",cMsgQie,.T.}
	Return(aRetQie)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o tratamento de/em  Poder Terceiros na TES 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRetQie := QieTipoNF(aDadosQie[03],aDadosQie[24])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o Tipo da Nota Fiscal nao foi enviado para Inspecao, o Ma-³
//³ terial devera ser liberado no CQ.							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetQie                   
	cMsgQie := "Material liberado do CQ e nao enviado para Inspecao"
	aRetQie := {"L",cMsgQie,.T.}
	RestArea(aAreaAnt)       
	Return(aRetQie)

EndIf	

//Verifica o conteudo da origem Importacao TXT	 
If aDadosQie[26] == NIL
	aDadosQie[26] := " "
EndIf                       

//Verifica a Hora da entrada
If Len(aDadosQie)>27
	aDadosQie[28] :=If(aDadosQie[28]==NIL .Or. Empty(aDadosQie[28]),SubStr(Time(),1,5),aDadosQie[28]) 		 
Else 
	Aadd(aDadosQie,SubStr(Time(),1,5))
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Compatibiliza o tamanho do Documento de Entrada (QEK_DOCENTR)³ 
//³ com o Lote de Fornecedor (D1_LOTEFOR), para que o controle de³ 
//³ Skip-Lote por Doc de Entrada, seja aplicado corretamente na  ³ 
//³ Integracao com Materiais e EIC.								 ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDadosQie[13] := SubStr(aDadosQie[13],1,TamSX3("QEK_DOCENT")[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza o tratamento do lote recebido na Entrada			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLoteQie := QieTrataLote(aDadosQie[15],@aDadosQie[17],@aDadosQie[18],nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a Exclusao da  Entrada								 ³
//³ 1 = Inclusao 												 ³
//³ 2 = Exclusao												 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 2             
                         
    //P.E. para alteracao do vetor aDadosQie na  exclusao
	If lQeMatDel 
		ExecBlock("QEMATDEL",.F.,.F.)
	EndIf	

	lDelQie := qDelMatQie(aDadosQie)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve o Status da Integracao 								   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lDelQie
		cMsgQie := "Exclusao da Entrada realizada com sucesso"
		aRetQie :=  {"D",cMsgQie,.T.} 
	Else    
		cMsgQie := "Houve ocorrencia na exclusao da Entrada do Material"
		aRetQie := {"E",cMsgQie,.F.}
	EndIf           
	  
	Return(aRetQie)

EndIf
             
//Ponto de Entrada, antes da gravacao dos dados
If lQeMatIns .And. lImportacao
	lGrvQEK := ExecBlock("QEMATINS",.F.,.F.)
	If cLoteQie <> AllTrim(aDadosQie[17])+AllTrim(aDadosQie[18])	
		cLoteQie := AllTrim(aDadosQie[17])+AllTrim(aDadosQie[18])
	EndIf
	
	cLoteQie := PadR(cLoteQie,nTamLote)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada, apos a criacao do Lote da Entrada, caso nao³
//³ haja tratamento de rastreabilidade.							 ³
//³ manipula as posicoes referentes ao Lote+SubLote (17 e 18)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQeMatFor .And. lImportacao
	lGrvQEK  := ExecBlock("QEMATFOR",.F.,.F.)
	cLoteQie := PadR(AllTrim(aDadosQie[17])+AllTrim(aDadosQie[18]),nTamLote)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os laudos com categoria Aprovado/Reprovado Total 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFatApr := Fator("1",.T.) //Aprovado Totalmente
cFatRep := Fator("3",.T.) //Reprovado Totalmente

If Empty(cFatApr)
	Help(" ",1,"A200FATAPR") //"Nao foi cadastrado nenhum Fator Aprovado Total"
	lGrvQEK  := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto possui especificacoes cadastradas		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QE6->(dbSetOrder(1))
If !QE6->(MsSeek(xFilial("QE6")+aDadosQie[15]))
	cMsgLap := "O produto nao possui especificacao cadastrada"
	qGrvIncEnt(aDadosQie,cMsgLap)
	lGrvQEK := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto possui Revisao disponivel 			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRevi := QA_UltRevEsp(aDadosQie[15],If(lEmissao,aDadosQie[04],aDadosQie[05]),.F.,,"QIE") //Produto+Data de Entrada 
If Empty(cRevi)
	cMsgLap := "O produto nao possui revisao disponivel"
	qGrvIncEnt(aDadosQie,cMsgLap)
	lGrvQEK := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Fornecedor possui amarracao Produto x Fornecedor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtrSkLSkT //Nao considera as NFs referentes a Beneficiamento, Devolucao e Transferencias

	SA5->(dbSetOrder(2))
	If !SA5->(MsSeek(xFilial("SA5")+aDadosQie[15]+aDadosQie[11]+aDadosQie[12]))
		cMsgLap := "Nao existe amarracao entre o Produto e Fornecedor"
		qGrvIncEnt(aDadosQie,cMsgLap)
		lGrvQEK := .F.
	Else
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a categoria do Fornecedor e igual a nao-recebe 	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		QEG->(dbSetOrder(1))
		QEG->(MsSeek(xFilial("QEG")+SA5->A5_SITU))
		If QEG->QEG_CATEG == "4" //Categoria Nao recebe
			///cMsgLap := OemToAnsi(STR0006) //"A Entrada para este fornecedor possui categoria (Nao-Recebe)"
			///qGrvIncEnt(aDadosQie,cMsgLap)
			///lGrvQEK := .F.

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Forca o envio do material para Inspecao no SIGAQIE, para que ³
			//³ o mesmo seja reprovado, devido a situacao de Nao-Habilitado. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lCtrSkLSkT := .F. //Forca o controle das Notas Fiscais referentes a Ben/Dev para que a mesma seja inspecionada			

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a data de validade do RIAI							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aDadosQie[05] > SA5->A5_VALRIAI .And. !Empty(SA5->A5_VALRIAI)
			cMsgLap := "A data de validade do RIAI do Fornecedor esta expirada"
			qGrvIncEnt(aDadosQie,cMsgLap)
			lGrvQEK := .F.
		EndIf

	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o Fornecedor possui amarracao Produto x Cliente   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SA7->(dbSetOrder(2))
	If !SA7->(MsSeek(xFilial("SA7")+aDadosQie[15]+aDadosQie[11]+aDadosQie[12]))
		cMsgLap := "Nao existe amarracao entre o Produto e Cliente"
		qGrvIncEnt(aDadosQie,cMsgLap)
		lGrvQEK := .F.
	EndIf

EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe ensaio para especificacao corrente        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cRevi)
	cProduto := aDadosQie[15]+cRevi

	dbSelectArea("QE7")
	dbSetOrder(1)
	If !dbSeek(xFilial("QE7")+cProduto)
		dbSelectArea("QE8")
		dbSetOrder(1)                  
		If !dbSeek(xFilial("QE8")+cProduto)
			cMsgLap := "Nao existem ensaio para ultima revisao do produto"
			qGrvIncEnt(aDadosQie,cMsgLap)
			lGrvQEK := .F.
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe Entrada com os mesmos dados cadastrados	 ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSeekQEK := aDadosQie[11]+aDadosQie[12]+aDadosQie[01]+aDadosQie[02]+aDadosQie[07]+aDadosQie[03]+cLoteQie+aDadosQie[19] 

QEK->(dbSetOrder(11))
If QEK->(MsSeek(xFilial("QEK")+cSeekQEK))
	cMsgLap := "Ja existe entrada cadastrada com os mesmos dados"
	qGrvIncEnt(aDadosQie,cMsgLap)
	lGrvQEK := .F.
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Numero do Lote se repete						 ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLotUni := GetMv("MV_QLOTUNI") 
If cLotUni == "S"
	QEK->(dbSetOrder(6))
	If QEK->(MsSeek(xFilial("QEK")+cLoteQie))
		cMsgLap := "O numero do Lote informado na Entrada ja existe"
		qGrvIncEnt(aDadosQie,cMsgLap)
		lGrvQEK := .F.
    EndIf
EndIf
                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o tamanho do Lote e valido						 ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTamLot    := PadR(aDadosQie[21],TamSX3("QEK_TAMAMO")[1]) //Quantidade           
cTamLotOri := PadR(aDadosQie[27],TamSX3("QEK_LOTORI")[1]) //Quantidade do Lote Original          
If !QA_VerNum(@cTamLot)
	cMsglap := "O tamanho do Lote informado nao e numerico"
	qGrvIncEnt(aDadosQie,cMsgLap)
	lGrvQEK := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o codigo Seq. Identificador da Entrada	no QEK           ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodEnt := QA_SEQU("QIE_IDEN",TamSX3("QEK_IDENTE")[1],"A","")
If Empty(cCodEnt)
	cMsgLap := "Nao foi possivel gerar o codigo Seq. Identificador da Entrada"
	qGrvIncEnt(aDadosQie,cMsgLap)
	lGrvQEK := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a UM cadastrada no SB1 eh diferente do QE6       ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGrvQEK
	SB1->(dbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1")+aDadosQie[15]))
	If SB1->B1_UM <> QE6->QE6_UNMED1
		cMsgLap := "Unidade de Medida esta diferente entre os cadastros de Produtos e Especificação do Produto."
		qGrvIncEnt(aDadosQie,cMsgLap)
		lGrvQEK := .F.
	EndIf
EndIf

If lGrvQEK

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Identifica as Unidades de Medida e Amostragem, assume a pri- ³	
	//³ meira unidade de Medida associada ao produto.				 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QE6->(dbSetOrder(1))
	If QE6->(MsSeek(xFilial("QE6")+aDadosQie[15]+Inverte(cRevi)))
		cUniMed	:= QE6->QE6_UNMED1
		cUniAmo	:= QE6->QE6_UNAMO1
		nShelf	:= QE6->QE6_SHLF
		cFatCon	:= QE6->QE6_FATCO1
		cTipCon	:= QE6->QE6_TIPCO1

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula o Lote de Amostragem 								 ³	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//Ponto de Entrada para formatar o Tamanho da Amostra
		If ExistBlock("QEMATAMO")
			cTamAmo := ExecBlock("QEMATAMO",.F.,.F.)		
		Else
			If cUniMed == cUniAmo
				cTamAmo	:= cTamLot
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o numero de casas decimais do Tamanho do Lote 		 ³	
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nDec := QA_NumDec(cTamLot)
				nTam := TamSX3("QEK_TAMAMO")[1]
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula o Tamanho da Amostra 								 ³	
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Val(cFatCon) > 0
					If cTipCon == "D" 
						cTamAmo := Str(Val(cTamLot)/Val(cFatCon),nTam,nDec)
					Else
						cTamAmo := Str(Val(cTamLot)*Val(cFatCon),nTam,nDec)
					EndIf
				Else
					cTamAmo := PadR(AllTrim(cTamLot),nTam)
				EndIf                                     
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inverte o formato do Valor: ponto -> virgula				 ³	
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cTamAmo := StrTran(cTamAmo,".",",")
				
			EndIf		
		EndIf
		
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Identifica o grupo do Produto								 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QEA->(dbSetOrder(2))
	If QEA->(MsSeek(xFilial("QEA")+aDadosQie[15]))
		cGrupo := QEA->QEA_GRUPO
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o numero maximo de dias em atraso					 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMvDiAtr := GetMv("MV_QDIAIPO")
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se os dias de atraso sera considerado				 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMvCoDia := GetMv("MV_QCONDIA")
                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera o menor numero de dias em atraso, entre o parame-  ³	
	//³ tro e o informado.							 				 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDiasAtr := aDadosQie[23]

	If DataValida(aDadosQie[5]-nDiasAtr+1) >= aDadosQie[5]
		nDiasAtr := 0	
	Else
		If cMvCoDia == "S"
			nDiasAtr := If(Abs(nDiasAtr)>nMvDiAtr,If(nDiasAtr<0,0-nMvDiAtr,nMvDiAtr),nDiasAtr)
		EndIf
	EndIf	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as condicoes para a Inspecao/Certificacao das Entra-³	
	//³ das.														 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSklEnt	:= GetMv("MV_QSKLENT")	// "No. Entradas iniciais p/ aplicacao skip-lote"
	nCntEnt	:= 0	// Contador Entradas
	nCntAte	:= 0	// Contador Entradas com Plano Atenuado

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o vetor de justificativas utilizado na QieSkipLote	 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aJustif := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ assume como default a Inspecao 								 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVerifica := 1	// Inspecionar
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a primeira ocorrencia do Skip Teste na Qe200SkTe		 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lPrimDoc := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia as consistencias da Inspecao da Entrada, somente para ³	
	//³ as Entradas provenientes de Notas Fiscais do tipo Normal.    ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    lAltEsp := .F. //Indica a primeira entrada apos a alteracao da especificacao
           
	If lCtrSkLSkT //Nao considera as NFs referentes a Beneficiamento, Devolucao e Transferencias
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ‚ a 1a. ocorrencia do Doc. Entrada p/ o Fornecedor/Grupo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aDadosQie[13])
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ha' skip-teste definido por grupo		 		 ³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			QEI->(dbSetOrder(1))
			If QEI->(MsSeek(xFilial("QEI")+aDadosQie[11]+aDadosQie[12]+cGrupo))
				                       
				cSeekQEK := xFilial("QEK")+aDadosQie[13]+aDadosQie[11]+aDadosQie[12]
				QEK->(dbSetOrder(4))
				QEK->(MsSeek(cSeekQEK))
				While QEK->(!Eof()) .And. (QEK->QEK_FILIAL+QEK->QEK_DOCENT+QEK->QEK_FORNEC+QEK->QEK_LOJFOR) == cSeekQEK
					If QEK->QEK_GRUPO == cGrupo
						lPrimDoc := .F.
						Exit
					EndIf
					QEK->(dbSkip())
				EndDo
			EndIf
		EndIf

		//A200COIN(aDadosQie[11],aDadosQie[12],aDadosQie[15],cRevi,aDadosQie[05],cLoteQie,aJustif,@nVerifica,@lAltEsp)
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as categorias Assegurado e qualificado 			 ³	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (QEG->QEG_CATEG == "1" .Or. QEG->QEG_CATEG == "2")
		                                                                                  
			//caso nao haja justificativa para a Inspecao nao Verifica o Skip-Lote
			If Len(aJustif) == 0
						
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Aplicacao da NBR-5426 no Skip-Lote 				 			 ³	
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cSeekQEK := xFilial("QEK")+aDadosQie[11]+aDadosQie[12]+aDadosQie[15]
				QEK->(dbSetOrder(2))
				QEK->(MsSeek(cSeekQEK))
				
				//Aplica a NBR5426
				If cApNBR5426  == "S"
				 
					// Checa se as ult. 5 Entradas foram com plano atenuado
					While QEK->(!Eof()) .And.	(QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT) ==;
						cSeekQEK .And. nCntEnt <= 5                     
						nCntEnt++

						//verifica o tipo de Plano de Amostragem
				        QF5->(dbSetOrder(1))
				        If QF5->(MsSeek(xFilial("QF5")+QEK->QEK_CHAVE))
				        	If QEK->QEK_TIPONF $ "Nß "
					        	QF4->(dbSetorder(1))                        
					        	If QF4->(MsSeek(xFilial("QF4")+QF4->QF4_FORNEC+QF4->QF4_LOJFOR+QF4->QF4_PRODUT+QF4->QF4_REVI))
	                            	While QF4->(!Eof()) .And. QF4->QF4_FILIAL == xFilial("QF4") .And.;
	    								(QF4->QF4_FORNEC+QF4->QF4_LOJFOR+QF4->QF4_PRODUT+QF4->QF4_REVI) ==;
		  								(QF5->QF5_FORNEC+QF5->QF5_LOJFOR+QF5->QF5_PRODUT+QF4->QF4_REVI)
	    					            If Right(QF4->QF4_PLAMO,1) == "A"
							                nCntAte++
							                Exit
							            EndIf
										QF4->(dbSkip())
									EndDo
					        	EndIf  
					        Else	
					        	//Futura Implementacao do Skip-Lote para Dev/Ben
					        	QF6->(dbSetorder(1))                        
					        	If QF6->(MsSeek(xFilial("QF6")+QF6->QF6_FORNEC+QF6->QF6_LOJFOR+QF6->QF6_PRODUT+QF6->QF6_REVI))
	                            	While QF6->(!Eof()) .And. QF6->QF6_FILIAL == xFilial("QF6") .And.;
	    								(QF6->QF6_FORNEC+QF6->QF6_LOJFOR+QF6->QF6_PRODUT+QF6->QF6_REVI) ==;
		  								(QF5->QF5_FORNEC+QF5->QF5_LOJFOR+QF5->QF5_PRODUT+QF4->QF4_REVI)
	    					            If Right(QF4->QF4_PLAMO,1) == "A"
							                nCntAte++
							                Exit
							            EndIf
										QF6->(dbSkip())
									EndDo
					        	EndIf  
				        	EndIf
			            EndIf       
       					If nCntEnt >= 5
							Exit
						EndIf
						QEK->(dbSkip())
						
					EndDo               
				 	 
					If nCntEnt >= 5 .And. nCntAte == 5
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica o SKIP-LOTE da Entrada                          	 ³	
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nVerifica := QieSkipLote(aDadosQie[11],aDadosQie[12],aDadosQie[15],cGrupo,aDadosQie[05],cLoteQie,aDadosQie[13],@aJustif)	
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o Skip-teste sera aplicado						 ³	
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cApSkpTest == "1")                       .Or.; //Skip-Teste individual
							(cApSkpTest == "2" .And. nVerifica == 1) .Or.; //Somente entradas inspecionadas
							(cApSkpTest == "2" .And. nVerifica == 2)       //As Certificadas em Skip-Lote que poderao ser Inspecionadas
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Calcula o Skip-Teste										 ³	
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aEnsInsp := A200SkTe(aDadosQie[11],aDadosQie[12],aDadosQie[15],lPrimDoc,;
								cFatRep,cRevi,lAltEsp)
								
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se a Entrada podera ser certificada, caso exista en-³	
							//³ saio a inspecionar pelo Skip-Teste.							 ³	
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nVerifica == 2 .And. cQCerEnt == "N"
								For nX := 1 To Len(aEnsInsp)
									If aEnsInsp[nX,2] == 1
										nVerifica := 1
									EndIf
								Next nX
							EndIf           
							
						EndIf	
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Marca para inspecao os ensaios com skip-teste definido     	 ³	
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aEnsInsp := QE200SkTe(cGrupo,lPrimDoc,aDadosQie[11],;
							aDadosQie[12],aDadosQie[15],cRevi)
					EndIf                                
						
				Else
					
					If nSklEnt > 1
					                                           
						While QEK->(!Eof()) .And. (QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT) ==;
							cSeekQEK .And. nCntEnt <= nSklEnt						
							nCntEnt++
							QEK->(dbSkip())
								
						EndDo
							
						If nCntEnt >= nSklEnt
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica o SKIP-LOTE da Entrada                         	 ³	
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nVerifica := QieSkipLote(aDadosQie[11],aDadosQie[12],aDadosQie[15],cGrupo,aDadosQie[05],cLoteQie,aDadosQie[13],@aJustif)	
								
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o Skip-teste sera aplicado						 ³	
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (cApSkpTest == "1")                       .Or.; //Skip-Teste individual
								(cApSkpTest == "2" .And. nVerifica == 1) .Or.; //Somente entradas inspecionadas
								(cApSkpTest == "2" .And. nVerifica == 2)       //As Certificadas em Skip-Lote que poderao ser Inspecionadas

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Calcula o Skip-Teste										 ³	
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aEnsInsp := A200SkTe(aDadosQie[11],aDadosQie[12],aDadosQie[15],lPrimDoc,;
									cFatRep,cRevi,lAltEsp)
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se a Entrada podera ser certificada, caso exista en-³	
								//³ saio a inspecionar pelo Skip-Teste.							 ³	
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If nVerifica == 2 .And. cQCerEnt == "N"
									For nX := 1 To Len(aEnsInsp)
										If aEnsInsp[nX,2] == 1
											nVerifica := 1
										EndIf
									Next nX
								EndIf           

							EndIf
								
						Else    
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Marca para inspecao os ensaios com skip-teste definido 		 ³	
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aEnsInsp := QE200SkTe(cGrupo,lPrimDoc,aDadosQie[11],;
								aDadosQie[12],aDadosQie[15],cRevi)
						EndIf
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica o SKIP-LOTE da Entrada                         	 ³	
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nVerifica := QieSkipLote(aDadosQie[11],aDadosQie[12],aDadosQie[15],cGrupo,aDadosQie[05],cLoteQie,aDadosQie[13],@aJustif)	
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o Skip-teste sera aplicado						 ³	
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cApSkpTest == "1")                       .Or.; //Skip-Teste individual
							(cApSkpTest == "2" .And. nVerifica == 1) .Or.; //Somente entradas inspecionadas
							(cApSkpTest == "2" .And. nVerifica == 2)       //As Certificadas em Skip-Lote que poderao ser Inspecionadas
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Calcula o Skip-Teste										 ³	
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aEnsInsp := A200SkTe(aDadosQie[11],aDadosQie[12],aDadosQie[15],lPrimDoc,;
								cFatRep,cRevi,lAltEsp)
								
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se a Entrada podera ser certificada, caso exista en-³	
							//³ saio a inspecionar pelo Skip-Teste.							 ³	
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nVerifica == 2 .And. cQCerEnt == "N"
								For nX := 1 To Len(aEnsInsp)
									If aEnsInsp[nX,2] == 1
										nVerifica := 1
									EndIf
								Next nX
							EndIf           
						EndIf						
					EndIf            
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Marca para inspecao os ensaios com skip-teste definido  	 ³	
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aEnsInsp := QE200SkTe(cGrupo,lPrimDoc,aDadosQie[11],aDadosQie[12],aDadosQie[15],cRevi)
				
			EndIf
	
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Marca para inspecao os ensaios com skip-teste definido 		 ³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aEnsInsp := QE200SkTe(cGrupo,lPrimDoc,aDadosQie[11],aDadosQie[12],aDadosQie[15],cRevi)
	
		EndIf
	    
	EndIf 
	
EndIf

//Forca o envio do material para Inspecao
If !lCtrSkLSkT  //Nao considera as Notas referentes a Devolucao e Beneficiamento  
	nVerifica := If(nVerifica==1,nVerifica,1)
EndIf               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a gravacao dO Item da Nota Fiscal no QEK 			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGrvQEK

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera a Chave de Ligacao para o QEK							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cKeyQEK := QA_NewChave()

	dbSelectArea("QEK")
	RecLock("QEK",.T.)
	QEK->QEK_FILIAL := xFilial("QEK") 
	QEK->QEK_NTFISC := aDadosQie[01] 				 //Numero da Nota Fiscal 	 		
	QEK->QEK_SERINF := aDadosQie[02] 				 //Serie da Nota Fiscal           	
	QEK->QEK_TIPONF := aDadosQie[03] 				 //Tipo da Nota Fiscal   		 	
	QEK->QEK_DTNFIS := aDadosQie[04] 				 //Data de Emissao da Nota Fiscal  
	QEK->QEK_DTENTR := aDadosQie[05] 				 //Data de Digitação da Nota Fiscal  
	QEK->QEK_ENTINV := Inverte(aDadosQie[05]) 	 	 //Data de Emissao da Nota Fiscal  
	QEK->QEK_HRENTR := aDadosQie[28] 				 //Hora da Entrada
	QEK->QEK_DIASAT := nDiasAtr				 	 	 //Dias de Atraso na Entrada
	QEK->QEK_TIPDOC := aDadosQie[06] 				 //Tipo de Documento -> default "NF"
	QEK->QEK_ITEMNF := aDadosQie[07] 				 //Item da Nota Fiscal				
	QEK->QEK_REMITO := aDadosQie[08] 				 //Numero do Remito (Localizacoes) 
	QEK->QEK_PEDIDO := aDadosQie[09] 				 //Numero do Pedido de Compra       
	QEK->QEK_ITEMPC := aDadosQie[10] 				 //Item do Pedido de Compra         
	QEK->QEK_FORNEC := aDadosQie[11] 				 //Codigo Fornecedor/Cliente        
	QEK->QEK_LOJFOR := aDadosQie[12] 				 //Loja Fornecedor/Cliente          
	QEK->QEK_DOCENT := aDadosQie[13] 			     //Numero do Lote do Fornecedor     
	QEK->QEK_SOLIC  := aDadosQie[14] 				 //Codigo do Solicitante            
	QEK->QEK_PRODUT := aDadosQie[15] 				 //Codigo do Produto                
	QEK->QEK_REVI   := cRevi			           	 //Revisao do Produto
	QEK->QEK_UNIMED := cUniMed                 	 	 //Unidade de Medida
	QEK->QEK_VERIFI := nVerifica                     //Inspeciona/Certifica
	QEK->QEK_GRUPO  := cGrupo                        //Grupo
	QEK->QEK_ALTESP := lAltEsp						 //indica a primeira entrada apos a alteracao da especificacao
	QEK->QEK_SKLDOC := lPrimDoc					 	 // indica a primeira ocorrencia Fornecedor x Grupo
	QEK->QEK_IDENTE := cCodEnt                       // Codigo Sequencial identificador da Entrada
	QEK->QEK_IDEINV := Inverte(cCodEnt)			     // Codigo Sequencial identificador da Entrada invertido
	QEK->QEK_LOCORI := aDadosQie[16] 				 //Local Origem    				   
	QEK->QEK_LOTE   := cLoteQie 					 //Numero do Lote+Sequencia do Sub-Lote                    	
	QEK->QEK_LOTINV := Inverte(cLoteQie) 			 //Numero do Lote invertido
	QEK->QEK_NUMSEQ := aDadosQie[19] 				 //Numero Sequencial           
	QEK->QEK_CERFOR := aDadosQie[20] 				 //Numero do CQ				
	QEK->QEK_TAMLOT := cTamLot						 //Quantidade             	
	QEK->QEK_LOTORI := cTamLotOri					 //Quantidade do Lote Original            	
	QEK->QEK_TAMAMO := cTamAmo 					     //Quantidade             	
	QEK->QEK_PRECO  := aDadosQie[22] 				 //Preco             		
	QEK->QEK_TES    := aDadosQie[24]                //TES da Nota Fiscal de Entrada
	QEK->QEK_ORIGEM := If(Empty(aDadosQie[25]),AllTrim(FunName()),aDadosQie[25]) //Origem					
	QEK->QEK_DTCAEN := dDataBase     				 //Data de Entrada
	QEK->QEK_CODENT := "C"			  				 //Importacao??? 
	QEK->QEK_MOVEST := " " 
	QEK->QEK_IMPORT := aDadosQie[26]				 //Origem Importacao TXT 
	QEK->QEK_SITENT := "1"  						 //Entrada pendente para Inspecao
	QEK->QEK_CHAVE  := cKeyQEK 
	If !Empty(aDadosQie[14]) 				
		QEK->QEK_FILMAT := xFilial('QAA')           //Filial do Usuario logado 
    EndIf
	MsUnLock()
	
	/*					
	DbselectArea("QF5")
	QF5->(Dbsetorder(1)) //QF5_FILIAL + QF5_CHAVE
	If QF5->(Dbseek(xFilial("QF5") + cKeyQEK  ))
	
		nTamAmo := QF5->QF5_TAMA1		//CAPTURA O TAMANHO DA AMOSTRA NO QF5
		DbselectArea("QEK")
		QEK->(DbSetorder(7))
		If QEK->(Dbseek(xFilial("QEK") + cKeyQEK ))
		
			RecLock("QEK",.F.)
			QEK->QEK_TAM_AM := nTamAmo
			QEK->(MsUnlock())
		Endif
		  
	Else
		msgbox("não achou QF5 chave: " + cKeyQEK)
	Endif
    */
    //não colocar aqui, pois ainda não gravou o QF5 neste ponto então não terá a qtde da amostra 
	
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a gravacao do Plano de Amostragem por Ensaio		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QAtuPlAmEn(QEK->QEK_FORNEC,QEK->QEK_LOJFOR,QEK->QEK_PRODUT,QEK->QEK_REVI,QEK->QEK_CHAVE,QEK->QEK_TAMAMO,QEK->QEK_TIPONF,1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Grava a Certificacao da Entrada, se em Regime de Skip-Lote	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nVerifica == 2		
		lGrvQEK := QieAtuLaudo(nOpc)
		If !lGrvQEK
			cMsgLap := "Nao foi possivel gerar o Codigo do Certificado de Qualidade"
			qGrvIncEnt(aDadosQie,cMsgLap)
		EndIf        
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o Controle do Skip-Teste							   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCtrSkLSkT //Nao considera as NFs referentes a Beneficiamento, Devolucao e Transferencias
		QieAtuSkpTst(1,aEnsInsp)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao Automatica do Plano de Amostragem             	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cAtPlAmo  == "S"	//Atualizacao automatica do Plano de Amostragem
		
		lAtuPA := .T.
			
		If cAtPlAmIQS == "S" //Atualizacao do Plano de Amostragem vinculado ao IQS
		    If aDadosQie[03] $ ('N ') //Verifica tipo da Nota Fiscal
	 		  	aAreaSA2 := SA2->(GetArea())
				SA2->(dbSetOrder(1))
				SA2->(MsSeek(xFilial("SA2")+aDadosQie[11]+aDadosQie[12]))
				If (SA2->A2_FATAVA == 0 .And. Empty(SA2->A2_DTAVA)) .Or.;
				   (SA2->A2_FATAVA <= nIQSRep)
					lAtuPA := .F.
				EndIf
				RestArea(aAreaSA2)
		    EndIf
		EndIf              
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o Plano de Amostragem a partir da importacao		   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAtuPA 
			A200AtPA(2)
		EndIf
			
	EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza a unidade de medida do SB1, de acordo com a informa-³
	//³ da na revisao do produto.									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SB1->(dbSetOrder(1))
	If SB1->(MsSeek(xFilial("SB1")+aDadosQie[15]))
		If SB1->B1_UM # cUniMed
			RecLock("SB1",.F.)
			SB1->B1_UM	:= cUniMed
			MsUnLock()
		EndIf
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o registro no QEP para Impressao da Ficha do Produto	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGrvQEK
	cSeekQEP := xFilial("QEP")+"2"+aDadosQie[11]+aDadosQie[12]+aDadosQie[15]+;
		DtoS(aDadosQie[05])+cLoteQie

	QEP->(dbSetOrder(1))
	If QEP->(!MsSeek(cSeekQEP))
		RecLock("QEP",.T.)
		QEP->QEP_FILIAL := xFilial("QEP")
		QEP->QEP_FORNEC := aDadosQie[11]
		QEP->QEP_LOJFOR := aDadosQie[12]
		QEP->QEP_PRODUT := aDadosQie[15]
		QEP->QEP_REVI   := cRevi
		QEP->QEP_DTENTR := aDadosQie[05]
		QEP->QEP_LOTE   := cLoteQie
	Else
		RecLock("QEP",.F.)
	EndIf
	QEP->QEP_CODTAB := "1" 
	QEP->QEP_HRENTR := QEK->QEK_HRENTR 
	QEP->QEP_TAMLOT := QEK->QEK_TAMLOT
	QEP->QEP_LOTORI := QEK->QEK_LOTORI
	QEP->QEP_TAMAMO := QEK->QEK_TAMAMO 
	QEP->QEP_DOCENT := aDadosQie[13]
	QEP->QEP_NTFISC := aDadosQie[01]
	QEP->QEP_SERINF := aDadosQie[02]
	QEP->QEP_TIPONF := aDadosQie[03] 				 
	QEP->QEP_DTNFIS := aDadosQie[04]
	QEP->QEP_TIPDOC := aDadosQie[06]
	QEP->QEP_ITEMNF := aDadosQie[07] 				 
	QEP->QEP_REMITO := aDadosQie[08] 				 
	QEP->QEP_PEDIDO := aDadosQie[09]
	QEP->QEP_ITEMPC := aDadosQie[10]
	QEP->QEP_LOCORI := aDadosQie[16] 				
	QEP->QEP_NUMSEQ := aDadosQie[19]
	QEP->QEP_CERFOR := aDadosQie[20]
	QEP->QEP_DIASAT := aDadosQie[23]
	QEP->QEP_PRECO  := aDadosQie[22]
	QEP->QEP_SOLIC  := aDadosQie[14]
	QEP->QEP_ORIGEM := aDadosQie[25]
	QEP->QEP_IMPORT := aDadosQie[26]
	QEP->QEP_ERRO   := If(nVerifica == 2,"A","")
	QEP->QEP_DTIMP  := dDataBase
	QEP->QEP_EXCLUI := "N"
	If !Empty(aDadosQie[14]) 				
		QEP->QEP_FILMAT := xFilial('QAA')        
    EndIf
	If AllTrim(QEP->QEP_ERRO) # "A" 
		QEP->QEP_INSPOB	:= "P"	
	EndIf
	MsUnLock()                                              
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve o Status da Integracao 								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGrvQEK	

	If ( Ascan(aModVld,AllTrim(aDadosQie[25])) > 0 )
		cMsgQie := ""
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realizou a Certificacao a partir do Skip-Lote				   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nVerifica == 2
			cMsgQie := "Certificado a partir da avaliacao do Skip-Lote"
			aRetQie :=  {"C",cMsgQie,.T.} //Realiza a Liberacao do Material no CQ

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o flag de movimentacao de Estoque, para movimentacao pos-³
			//³ terior quando o fornecedor for certificado.					   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("QEK",.F.)
			QEK->QEK_MOVEST := "S"
			QEK->QEK_SITENT := "2" //Entrada Aprovada (FREE-PASS)
			MsUnLock()
		Else    
			cMsgQie := "Material enviado para Inspecao no QIE"
			aRetQie := {" ",cMsgQie,.T.}
		EndIf
	Else
		cMsgQie := "Material enviado para Inspecao no QIE"
		aRetQie := {" ",cMsgQie,.T.}
	EndIf
Else                  
	cMsgQie := "Houve ocorrencia no Envio do Material para Inspecao"
	aRetQie := {"E",cMsgQie,.F.}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a liberacao do material no CQ, quando for realizada a  ³
//³ ReImportacao, apos as correcao das inconsistencias.			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGrvQEK	

	If AllTrim(FunName()) $ "QIEA180ßQIEA190ßQIEA183" .And. SubStr(QEK->QEK_ORIGEM,1,4) == "MATA" 
		
		If Empty(QEK->QEK_REMITO)
			dbSelectArea("SD1")
			dbSetOrder(1)
			If MsSeek(xFilial("SD1")+QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_FORNECE+;
				QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_ITEMNF)
				cSeekSD7 := (SD1->D1_NUMCQ+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_NUMSEQ)  
			EndIf	
		Else
			If cPaisLoc # "BRA"
				dbSelectArea("SCM")
				dbSetOrder(4)
				If MsSeek(xFilial("SCM")+QEK->QEK_REMITO+QEK->QEK_ITEM+QEK->QEK_FORNECE+;
					QEK->QEK_LOJFOR)
					cSeekSD7 :=	(SCM->CM_NUMCQ+SCM->CM_PRODUTO+SCM->CM_LOCAL+	SCM->CM_NUMSEQ)  
				EndIf	          
			EndIf
		EndIf
			
		If aRetQIE[1] == "C" .Or. aRetQie[1] == "L" .And. AllTrim(QEK->QEK_TIPDOC) # "NFEIC"
			aAreaSD1 := SD1->(GetArea())
			aAreaSD7 := SD7->(GetArea())
			If cPaisLoc # "BRA"
				aAreaSCM := SCM->(GetArea())
			EndIf	
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Realiza Automaticamente a Libera‡„o da movimenta‡Æo no SD7   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD7")
			dbSetOrder(2)
		 	If MsSeek(xFilial("SD7")+cSeekSD7)
		 	
				If SD7->D7_TIPO == 0
				
					Aadd(aMov,Array(11))
					aMov[Len(aMov),01] := 1               //Tipo da Movimentacao (1=libera/2=Rejeita)                                     
					aMov[Len(aMov),02] := SD7->D7_SALDO   //Quantidade a ser movimentada
					aMov[Len(aMov),03] := SD7->D7_LOCDEST //Local de Destino da Movimentacao
					aMov[Len(aMov),04] := SD7->D7_DATA    //Data da Movimentacao
					aMov[Len(aMov),05] := ""              //X = Estornado
					aMov[Len(aMov),06] := ""              //Motivo da Rejeicao
					aMov[Len(aMov),07] := aRetQIE[2]      //Observacao
					aMov[Len(aMov),08] := SD7->D7_QTSEGUM //Quantidade na 2a Unidade de Medida
					aMov[Len(aMov),09] := " "			   //Endereco
					aMov[Len(aMov),10] := " " 			   //Numero de Serie
					aMov[Len(aMov),11] := " " 			   //Servico
					If cPaisLoc # "BRA"                       
						//utiliza o custo proveniente do item do Remito    
						aCM := PegaCMCM()
					Else
						//utiliza o custo proveniente do item da Nota Fiscal
						aCM := PegaCMD1()
					EndIf				
					fGravaCQ(SD7->D7_PRODUTO,SD7->D7_NUMERO,.F.,aMov,aCM)
						
				EndIf
	        EndIf
			     
			RestArea(aAreaSD1)
			RestArea(aAreaSD7)
			If cPaisLoc # "BRA"
				RestArea(aAreaSCM)
			EndIf	
	    EndIf
	EndIf
	                             
	//Ponto de Entrada, apos da gravacao dos dados
	If lQeMatFin .And. lImportacao
		ExecBlock("QEMATFIN",.F.,.F.)
	EndIf	

EndIf

//P.E. apos a gravacao da Entrada no QEP (Inconsistencias) ou QEK (Entradas)
If ExistBlock("QEGRVALL")
	ExecBlock("QEGRVALL",.F.,.F.)
EndIf

//Retorna a area corrente
RestArea(aAreaAnt)

Return(aRetQie)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³qGrvIncEnt³ Autor ³Paulo Emidio de Barros ³ Data ³23/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava as inconsistencias encontradas na gravacao da Entrada³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1: Array com os dados                                  ³±±
±±³          ³ ExpC1: Mensagem de erro                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ qAtuMatQie												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function qGrvIncEnt(aDadosQie,cMsgLap)
Local cSeekQEP 
Local cTamLot    := PadR(aDadosQie[21],TamSX3("QEK_TAMAMO")[1]) //Quantidade           
Local cTamLotOri := PadR(aDadosQie[27],TamSX3("QEK_LOTORI")[1]) //Quantidade do Lote Original          
Local cTamAmo
Local cAviso     := ""
Local nTamLote   := TamSX3("QEK_LOTE")[1]
Local cLoteQie   := " "
                                                                  
cLoteQie := PadR(AllTrim(aDadosQie[17])+AllTrim(aDadosQie[18]),nTamLote)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave de pesquisa da Entrada								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSeekQEP := xFilial("QEP")+"2"+aDadosQie[11]+aDadosQie[12]+aDadosQie[15]+;
	DtoS(aDadosQie[05])+cLoteQie

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui o tamanho do Lote ao tamanho da Amostra, somente para³
//³ apontar a inconsistencia, o tamanho da amostra sera calculado³
//³ de acordo com o Plano de amostragem definido.				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Ponto de Entrada para formatar o Tamanho da Amostra na Inconsistencia
If ExistBlock("QEINCAMO")
	cTamAmo := ExecBlock("QEINCAMO",.F.,.F.)
Else
	cTamAmo := cTamLot
EndIf	

QEP->(dbSetOrder(1))
If QEP->(!MsSeek(cSeekQEP))
	RecLock("QEP",.T.)
	QEP->QEP_FILIAL := xFilial("QEP")
	QEP->QEP_CODTAB := "2" 
	QEP->QEP_FORNEC := aDadosQie[11]
	QEP->QEP_LOJFOR := aDadosQie[12]
	QEP->QEP_PRODUT := aDadosQie[15]
	QEP->QEP_DTENTR := aDadosQie[05]
	QEP->QEP_LOTE   := cLoteQie
Else
	RecLock("QEP",.F.)
EndIf

QEP->QEP_HRENTR := aDadosQie[28] 
QEP->QEP_TAMLOT := cTamLot
QEP->QEP_LOTORI := cTamLotOri
QEP->QEP_TAMAMO := cTamAmo
QEP->QEP_DOCENT := aDadosQie[13]
QEP->QEP_NTFISC := aDadosQie[01]
QEP->QEP_SERINF := aDadosQie[02]
QEP->QEP_TIPONF := aDadosQie[03] 				 
QEP->QEP_DTNFIS := aDadosQie[04]
QEP->QEP_TIPDOC := aDadosQie[06]
QEP->QEP_ITEMNF := aDadosQie[07] 				 
QEP->QEP_REMITO := aDadosQie[08] 				 
QEP->QEP_PEDIDO := aDadosQie[09]
QEP->QEP_ITEMPC := aDadosQie[10]
QEP->QEP_LOCORI := aDadosQie[16] 				
QEP->QEP_NUMSEQ := aDadosQie[19]
QEP->QEP_CERFOR := aDadosQie[20]
QEP->QEP_DIASAT := aDadosQie[23]
QEP->QEP_PRECO  := aDadosQie[22]     
QEP->QEP_SOLIC  := aDadosQie[14]
QEP->QEP_TES    := aDadosQie[24]
QEP->QEP_ORIGEM := aDadosQie[25]
QEP->QEP_IMPORT := aDadosQie[26]
QEP->QEP_ERRO   := cMsgLap
QEP->QEP_DTIMP  := dDataBase
QEP->QEP_EXCLUI := "N"
If !Empty(aDadosQie[14]) 				
	QEP->QEP_FILMAT := xFilial('QAA')          
EndIf                    
FkCommit()
MsUnLock()                                              
                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ P.E. executado apos a gravacao das Inconsistencias			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("QEGRVINC")
	ExecBlock("QEGRVINC",.F.,.F.)
EndIf
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe a Mensagem de Inconsistencias registros provenientes   ³
//³ da Integracao											 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SubStr(cModulo,1,1) # "Q"
	cAviso := "Produto : " + AllTrim(QEP->QEP_PRODUT)+ " NF/Item : "+AllTrim(QEP->QEP_NTFISC)+" / "+AllTrim(QEP->QEP_ITEMNF)  //"Produto : " ### " NF/Item : "
	Aviso("SIGAQIE - Ocorrencia na Integracao "+cAviso,AllTrim(QEP->QEP_ERRO),{"Ok"}) //"SIGAQIE - Ocorrencia na Integracao "
EndIf

//Armazena o flag que indica a inconsistencia               
lInconsistencia := If(!lInconsistencia,.T.,lInconsistencia)

Return(NIL)                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³qdelMatQie³ Autor ³Paulo Emidio de Barros ³ Data ³10/05/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza a exclusao das Entradas							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPA = Array contendo os dados enviados na Integracao	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. = Realizou a Exclusao, .F. nao Realizou				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ qAtuMatQie()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/             
Static Function qDelMatQie(aDadosQie)                                 
Local lRetDel    := .F.
Local cSeekQEP   := ""
Local cSeekQEK   := ""
Local cLoteQie   := ""
Local nTamLote   := TamSX3("QEK_LOTE")[1]
Local nOrdQEK   

cLoteQie := PadR(AllTrim(aDadosQie[17])+AllTrim(aDadosQie[18]),nTamLote)
/*
aDados := {SD1->D1_DOC,; //1-Numero da Nota Fiscal
				SD1->D1_SERIE,;        //2-Serie da Nota Fiscal
				SD1->D1_TIPO,;         //3-Tipo da Nota Fiscal
				SD1->D1_EMISSAO,;      //4-Data de Emissao da Nota Fiscal
				SD1->D1_DTDIGIT,;      //5-Data de Entrada da Nota Fiscal
				"NF",;                 //6-Tipo de Documento
				SD1->D1_ITEM,;         //7-Item da Nota Fiscal
				" ",;                  //8-Numero do Remito (Localizacoes)
				SD1->D1_PEDIDO,;       //9-Numero do Pedido de Compra
				SD1->D1_ITEMPC,;       //10-Item do Pedido de Compra
				SD1->D1_FORNECE,;      //11-Codigo Fornecedor/Cliente
				SD1->D1_LOJA,;         //12-Loja Fornecedor/Cliente
				SD1->D1_LOTEFOR,;      //13-Numero do Lote do Fornecedor
				Space(6),;             //14-Codigo do Solicitante
				SD1->D1_COD,;          //15-Codigo do Produto
				SD1->D1_LOCAL,;        //16-Local Origem
				"LOTE000" ,;           //17-Numero do Lote
				"001" ,;              //18-Sequencia do Sub-Lote
				SD1->D1_NUMSEQ,;       //20-Numero Sequencial
				SD7->D7_NUMERO,;       //21-Numero do CQ
				SD1->D1_QUANT,;        //22-Quantidade
				SD1->D1_TOTAL,;        //23-Preco
				0 ,; 	              //24-Dias de atraso
				'' ,; 		         //25-TES
				AllTrim(FunName()),;   //26-Origem						
				" ",;                  //27-Origem TXT	
				0}                     //28-Quantidade do Lote Original	

*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o registro da Entrada no QEK 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//nOrdQEK := 6
nOrdQEK  := 14 //QEK_FILIAL + QEK_FORNEC    + QEK_LOJFOR    + QEK_PRODUT    +  QEK_NTFISC + QEK_SERINF + DTOS(QEK_DTENTR) + QEK_LOTE + QEK_NUMSEQ
//cSeekQEK : cLoteQie
cSeekQEK := xFilial("QEK") + aDadosQie[11] + aDadosQie[12] + aDadosQie[15] + aDadosQie[1] + aDadosQie[2] + aDadosQie[5]//cLoteQie
/*
If !Empty(aDadosQie[24]) //TES
	If !Rastro(aDadosQie[15]) //Produto
		nOrdQEK  := 10
		cSeekQEK := aDadosQie[11]+aDadosQie[12]+aDadosQie[01]+aDadosQie[02]+aDadosQie[07]+aDadosQie[03]+aDadosQie[19] 
	EndIf
EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui a Entrada gravada no QEP	(Importada)					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If Empty(cLoteQie) 
	//cSeekQEP := xFilial("QEP")+"1"+aDadosQie[11]+aDadosQie[12]+aDadosQie[15]+DtoS(aDadosQie[05])
	cSeekQEP := xFilial("QEP")+"1"+ aDadosQie[11]+aDadosQie[12]+aDadosQie[15]+ aDadosQie[1] + aDadosQie[2] + aDadosQie[7] + aDadosQie[3] 
	QEP->(dbSetOrder(2))
	QEP->(MsSeek(cSeekQEP))
	If AllTrim(QEP->QEP_ORIGEM) == 'MATA103' .or. AllTrim(QEP->QEP_ORIGEM) == 'MATA140' //Documento de Entrada
		While QEP->(!Eof()) .And. QEP->(QEP_FILIAL+QEP_CODTAB+QEP_FORNEC+QEP_LOJFOR+QEP_PRODUT+dTos(QEP_DTENTR))==cSeekQEP
			If AllTrim(SD7->D7_NUMERO)==AllTrim(QEP->QEP_CERFOR)
				RecLock("QEP",.F.)
				dbDelete()
				MsUnLock()
			EndIf
			QEP->(dbSkip())
		EndDo
	EndIf
/*Else
	cSeekQEP := xFilial("QEP")+"1"+aDadosQie[11]+aDadosQie[12]+aDadosQie[15]+DtoS(aDadosQie[05])+cLoteQie
	QEP->(dbSetOrder(1))
	If QEP->(MsSeek(cSeekQEP))
		RecLock("QEP",.F.)
		dbDelete()
		MsUnLock()
	EndIf
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui a inconsistencia da Entrada no QEP (Inconsistencia)	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If Empty(cLoteQie) 
	cSeekQEP := xFilial("QEP")+"2"+aDadosQie[11]+aDadosQie[12]+aDadosQie[15]+DtoS(aDadosQie[05])
	QEP->(dbSetOrder(1))
	QEP->(MsSeek(cSeekQEP))
	If AllTrim(QEP->QEP_ORIGEM) == 'MATA103' .or. AllTrim(QEP->QEP_ORIGEM) == 'MATA140'//Documento de Entrada
		While QEP->(!Eof()) .And. QEP->(QEP_FILIAL+QEP_CODTAB+QEP_FORNEC+QEP_LOJFOR+QEP_PRODUT+dTos(QEP_DTENTR))==cSeekQEP
			If AllTrim(SD7->D7_NUMERO)==AllTrim(QEP->QEP_CERFOR)
				RecLock("QEP",.F.)
				dbDelete()
				MsUnLock()
			EndIf			
			QEP->(dbSkip())
		EndDo
	EndIf
Else
	cSeekQEP := xFilial("QEP")+"2"+aDadosQie[11]+aDadosQie[12]+aDadosQie[15]+DtoS(aDadosQie[05])+cLoteQie
	QEP->(dbSetOrder(1))
	If QEP->(MsSeek(cSeekQEP))
		RecLock("QEP",.F.)
		dbDelete()
		MsUnLock()
	EndIf
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a exclusao da Entrada								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QEK->(dbSetOrder(nOrdQEK))
If QEK->(MsSeek(xFilial("QEK")+cSeekQEK))
	
	If Empty(cLoteQie)
		cLoteQie := QEK->QEK_LOTE
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui as amarracoes das Entradas					   		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A200ExEn()
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclue as medicoes com todas as suas amarracoes				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QieDelMed(QEK->QEK_PRODUT,QEK->QEK_REVI,QEK->QEK_FORNEC,QEK->QEK_LOJFOR,QEK->QEK_DTENTR,QEK->QEK_LOTE)
				
	RecLock("QEK",.F.)
	QEK->(dbDelete())
	MsUnLock()      

	lRetDel := .T.
	
	DbselectArea("SD7")
	SD7->(Dbsetorder(1)) //D7_FILIAL + D7_NUMERO   + D7_PRODUTO       + D7_LOCAL        + D7_SEQ        + DTOS(D7_DATA)
	If SD7->(Dbseek(xFilial("SD7") + aDadosQie[21] +  QEK->QEK_PRODUT + QEK->QEK_LOCORI + aDadosQie[18] + Dtos(aDadosQie[4])  ))
		MSGBOX("ACHOU SD7")
		RecLock("SD7",.F.)
		SD7->(Dbdelete())
		SD7->(MsUnlock())  
	Else
		msgbox("não achou SD7 para deletar: " + aDadosQie[21] +  '/' + QEK->QEK_PRODUT + '/' + QEK->QEK_LOCORI + '/' + aDadosQie[18] + '/' + DTOS(aDadosQie[4]) )
	Endif
	
EndIf	

Return(lRetDel) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QieDelMed ³ Autor ³ Paulo Emidio de Barros³ Data ³ 05/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a exclusao das amarracoes referentes as Entradas   ³±±
±±³			 ³ inspecionadas.										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QieDelMed												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo do Produto						 	      ³±±
±±³			 ³ EXPC2 = Revicao do Produto   							  ³±±
±±³			 ³ EXPC3 = Codigo do Fornecedor								  ³±±
±±³			 ³ EXPC4 = Loja do Fornecedor                      			  ³±±
±±³			 ³ EXPD1 = Data de Entrada                                    ³±±
±±³			 ³ EXPC5 = Numero do Lote             						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAQIE													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QieDelMed(cProduto,cRevi,cFornece,cLoja,dEntrada,cLote)
Local aOldArea   := GetArea()             
Local cChvMed    := ""
Local cCarEns    := ""
Local aCpoQNC    := {}
Local cChvQEL    := ""
Local cChvQER    := ""
Local l215ExcQNC := ExistBlock("Q215QNCE") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a exclusao das medicoes associadas a Entrada Inspecionada  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChvQER    := xFilial("QER")+cProduto+cRevi+cFornece+cLoja+dTos(dEntrada)+cLote

dbSelectArea("QER")
dbSetOrder(1)
MsSeek(cChvQER,.T.)
While (QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+Dtos(QER_DTENTR)+QER_LOTE) == cChvQER
      

	cChvMed := QER->QER_CHAVE
	cCarEns := QA_CartEns(QER->QER_ENSAIO)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a exclusao das medicoes mensuraveis						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cCarEns # "TXT" 

		dbSelectArea("QES")
		dbSetOrder(1)
		If MsSeek(xFilial("QES")+cChvMed)
			While !Eof() .And. QES->QES_FILIAL+QES->QES_CODMED == xFilial("QES")+cChvMed 
				RecLock("QES",.F.)
				dbDelete()
				MsUnLock()
				dbSkip()
			EndDo
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza a exclusao das medicoes texto							   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("QEQ")
		dbSetOrder(1)
		If MsSeek(xFilial("QEQ")+cChvMed)
			While !Eof() .And. QEQ->QEQ_FILIAL+QEQ->QEQ_CODMED == xFilial("QEQ")+cChvMed
				RecLock("QEQ",.F.)
				dbDelete()
				MsUnLock()
				dbSkip()
			EndDo
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a exclusao dos Instrumentos associados as medicoes  	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QET")
	dbSetOrder(1)
	If MsSeek(xFilial("QET")+cChvMed)
		While !Eof() .And. QET->QET_FILIAL+QET->QET_CODMED == xFilial("QET")+cChvMed
			RecLock("QET",.F.)
			dbDelete()
			MsUnLock()
			dbSkip()
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a exclusao das nao-conformidades associadas as medicoes	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QEU")
	dbSetOrder(1)
	If MsSeek(xFilial("QEU")+cChvMed)
		While !Eof() .And. QEU->QEU_FILIAL+QEU->QEU_CODMED == xFilial("QEU")+cChvMed
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Integracao SIGAQIE x SIGAQNC									   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !l215ExcQNC 
				If !Empty(QEU->QEU_CODNC) .And. !Empty(QEU->QEU_REVNC)
					aCpoQNC := {}
				    Aadd(aCpoQNC,xFilial("QI2"))
					Aadd(aCpoQNC,QEU->QEU_CODNC) 
					Aadd(aCpoQNC,QEU->QEU_REVNC)
					QNCGERA(2,aCpoQNC)
				EndIf	       
			EndIf
			
			RecLock("QEU",.F.)
			dbDelete()
			MsUnLock()
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Realiza a Exclusao da Cronica das nao-conformidades				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			QA_DelTxt(QEU->QEU_CHAVE,"QIEA210C")	
	
			dbSelectArea("QEU")
			dbSkip()           
			
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a Exclusao da medicao									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QER")	
	RecLock("QER",.F.)
	dbDelete()
	MsUnLock()
    dbSkip()
    
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a Exclusao dos Laudos									   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChvQEL := xFilial("QEL")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+;
	dTos(QEK->QEK_DTENTR)+QEK->QEK_LOTE
	
dbSelectArea("QEL")
dbSetOrder(1)
If MsSeek(cChvQEL)
	While !Eof() .And. (QEL_FILIAL+QEL->QEL_FORNEC+QEL->QEL_LOJFOR+QEL->QEL_PRODUT+dTos(QEL->QEL_DTENTR)+QEL->QEL_LOTE)==cChvQEL	
	
		//Exclui o Historico do Laudo
		MsMM(QEL->QEL_CHAVEH,,,,2)
		
		RecLock("QEL",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a exclusao das NNCs vinculadas					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('QEM')
dbSetOrder(1)
MsSeek( xFilial("QEM")+QEK->QEK_NNC )
While !EOF() .And. QEM_FILIAL+QEM_NNC == xFilial("QEM")+QEK->QEK_NNC

	//Exclui as observacoes das NNCS das Entradas  
	If !Empty(QEM->QEM_CHAVE)                        
		QA_DelTxt(QEM->QEM_CHAVE,"QIEA220 ")   
	EndIf

	dbSelectArea("QEM")
	RecLock("QEM",.F.,.T.)
	dbDelete()
	MsUnLock()
	dbSkip()
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclue o Numero da Notificacao da Nao-conformidade		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("QEK",.F.)
QEK->QEK_NNC    := " "
QEK->QEK_NNCINV := " "
MsUnLock()
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui o texto da Liberacao Urgente								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QEK->QEK_SITENT $ "1467"
	QA_DelTxt(QEK->QEK_CHAVE1,"QIEA210U") 
EndIf

RestArea(aOldArea)
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QieIntEst ³ Autor ³ Paulo Emidio de Barros³ Data ³ 16/04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se a Entrada Inspecionada / a Inspecionar possui  ³±±
±±³			 ³ Integracao com o Materiais (Movimentacao de Estoque).      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QieIntEst(EXPC1,EXPC2)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo do Produto						 	      ³±±
±±³			 ³ EXPC2 = TES utilizada na Entrada Inspecionada			  ³±±
±±³			 ³ EXPC3 = Tipo do Documento								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPL1 = .T. possui integracao							  ³±±
±±³			 ³ 		   .F. nao possui integracao						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAQIE													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QieIntEst(cProduto,cTes,cTipDoc)
Local lRetorno := .F.
Local aAreaAnt := GetArea()

cTipDoc := If(cTipDoc==NIL,'',cTipDoc)

If !Empty(cTes)
	SF4->(dbSetOrder(1))
	If SF4->(MsSeek(xFilial("SF4")+cTes))
		If SF4->F4_ESTOQUE == "S"
			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(xFilial("SB1")+cProduto)) .And. SB1->B1_TIPOCQ == "Q" 
				lRetorno := .T.
			EndIf	
		EndIf
	EndIf                   
Else
	If AllTrim(cTipDoc) == "TR"
		lRetorno := .T.
	EndIf	
EndIf
                            
RestArea(aAreaAnt)

Return(lRetorno)

/*                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  QieNumLote  ³ Paulo Emidio de Barros    ³ Data ³01/10/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera um Numero Sequencial do Lote sem controle de Rastrea- ³±±
±±³          ³ bilidade													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QieNumLote()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QieNumLote(cProduto)
Local aAreaAnt := GetArea()
Local cLoteCtl := " "
Local cNumLote := " "
                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Compatibiliza a Numeracao Sequencial do Lote com Materiais		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Sequencia do Sub-Lote
cNumLote := If(cNumLote==NIL,NextLote(cProduto,"S"),If(Empty(cNumLote),NextLote(cProduto,"S"),cNumLote))

//Sequencia do Lote
cLoteCtl := If(Empty(cLoteCtl),NextLote(cProduto,"L",cNumLote),cLoteCtl)
cLoteCtl := If(Empty(cLoteCtl),"AUTO"+cNumLote,cLoteCtl)

RestArea(aAreaAnt)

Return(cLoteCtl)

/*                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³   QieTipoNF  ³ Paulo Emidio de Barros    ³ Data ³01/10/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o Tipo da Nota Fiscal sofrea Inspecao pelo	  ³±±
±±³          ³ Quality													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QieTipoNF(cTipoNf,cTES)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QieTipoNF(cTipoNf,cTES)
Local lRetorno   := .F.
Local aAreaSF4

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Verifica os Tipos das Notas Fiscais de Entradas e o tratamento de/em Poder  ³
//³ de/em Terceiros, indica se os mesmos serao enviados para Inspecao.          ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³     Tipo Nota Fiscal     ³     Normal     ³ Beneficiamento ³   Devolucao    ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ <N>ao utiliza Poder Terc ³  	SIM       ³ 	 SIM	   ³	  SIM	    ³
//³ Poder Terc <R>emessa     ³  	SIM       ³ 	 SIM	   ³	  SIM	    ³
//³ Poder Terc <D>evolucao   ³      SIM    	  ³  	 SIM       ³	  SIM	    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cIntNfeNor := GetMv("MV_QNFENOR") //Tipo da Nota Fiscal Normal a ser considerada
Local cIntNfeBen := GetMv("MV_QNFEBEN") //Tipo da Nota Fiscal Beneficiamento a ser considerada
Local cIntNfeDev := GetMv("MV_QNFEDEV") //Tipo da Nota Fiscal Devolucao a ser considerada

If !Empty(cTES)
	aAreaSF4 := SF4->(GetArea())
	SF4->(dbSetOrder(1))
	If SF4->(MsSeek(xFilial("SF4")+cTES)) 
                                               
		If cTipoNF == "N"
			If (SF4->F4_PODER3=="N" .And. SubStr(cIntNfeNor,1,1)=="N") .Or.;
				(SF4->F4_PODER3=="R" .And. SubStr(cIntNfeNor,2,1)=="N") .Or.;
				(SF4->F4_PODER3=="D" .And. SubStr(cIntNfeNor,3,1)=="N")
				lRetorno := .T.
			EndIf	           
		
		ElseIf cTipoNF == "B"
			If (SF4->F4_PODER3=="N" .And. SubStr(cIntNfeBen,1,1)=="N") .Or.;
				(SF4->F4_PODER3=="R" .And. SubStr(cIntNfeBen,2,1)=="N") .Or.;
				(SF4->F4_PODER3=="D" .And. SubStr(cIntNfeBen,3,1)=="N")
				lRetorno := .T.
			EndIf	

		ElseIf cTipoNF == "D"
			If (SF4->F4_PODER3=="N" .And. SubStr(cIntNfeDev,1,1)=="N") .Or.;
				(SF4->F4_PODER3=="R" .And. SubStr(cIntNfeDev,2,1)=="N") .Or.;
				(SF4->F4_PODER3=="D" .And. SubStr(cIntNfeDev,3,1)=="N")
				lRetorno := .T.
			EndIf	
		EndIf

	EndIf                         
	RestArea(aAreaSF4)

EndIf

Return(lRetorno)

/*                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ QieTrataLote ³ Paulo Emidio de Barros    ³ Data ³30/06/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza o tratamento do Numero do Lote enviando para a 	  ³±±
±±³          ³ Entrada a Inspecionar.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QieTrataLote(cProduto,cLote,cSubLote,nOpc)				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QieTrataLote(cProduto,cLote,cSubLote,nOpc)
Local nTamLote := TamSx3("D3_LOTECTL")[1]+TamSx3("D3_NUMLOTE")[1]
Local cRetorno := " "                                   

If AllTrim(aDadosQie[25]) <> "QIEA183" //nao consiste as importacoes

	//Trata o Numero do Lote sequencialmente, caso o produto possua Rastreabilidade
	If GetMV("MV_PRXLOTC",.T.) .And. Rastro(cProduto,"L")  
		cSubLote := " "
	EndIf

	//Gera o Numero Sequencial para o Lote sem o controle da Rastreabilidade
	If Empty(cLote) .And. Empty(cSubLote)          
	
		If nOpc <> 2 //Nao gera novo numero na exclusao            
			If !Rastro(cProduto)
				cLote := QieNumLote(cProduto)     
			EndIf
		EndIf
	EndIf                                                          

EndIf

//Retira os espacos em branco do Numero do Lote
cRetorno := PadR(AllTrim(cLote)+AllTrim(cSubLote),nTamLote) 

Return(cRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A200COIN ³ Autor ³ Quality   			³ Data ³22/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Realiza consistencias para determinar a Inspecao da entrada³±±
±±³          ³ sendo: 1a. entrada do Produto/Fornecedor         		  ³±±
±±³          ³        Tempo limite sem Entradas est  expirado     		  ³±±
±±³          ³        1a. entrada ap¢s alteracao especificacao  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A200COIN(cFornece,cLoja,cProduto,cRevisao,dEntrada,cLote,aJustif,nVerifica,lAltEsp)

Local aAreaSA5       := SA5->(GetArea())
Local aAreaQE6       := QE6->(GetArea())
Local aAreaQEK       := QEK->(GetArea())
Local lContinua      := .T.
Local lJustificativa := .F.      
Local nSklEnt        := 0
Local nEntradas      := 0     
Local dVigencia

Default nVerifica := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se for a 1a. Entrada do Fornecedor/Produto, verifica o para- ³
//³ metro MV_QSQLENT, para determinar se inspeciona direto ou se ³
//³ verifica o skip-lote (respeitando conceito do no. Entradas   ³
//³ iniciais).      											 ³
//³ Observacoes: Se for 0, aplica o skip-lote direto, desde a    ³
//³       		 primeira Entrada(Alteracao solicitada pela      ³
//³       		 Transbracal - eles usam Free-Pass e nao querem  ³
//³       		 inspecionar nem a 1a. Entrada).                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QEK")
dbSetOrder(2)		
If !dbSeek(xFilial("QEK")+cFornece+cLoja+cProduto)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inspeciona a primeira Entrada de um Produto x Fornecedor	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SuperGetMv("MV_QSKLENT") > 0 //"Numero de Entradas iniciais p/ aplicacao skip-lote"
		Aadd(aJustif,"Primeira Entrada do Fornecedor/Produto.") //"Primeira Entrada do Fornecedor/Produto."
		lJustificativa := .T.
		nVerifica      := 1
		lContinua      := .F.
		
	EndIf	
EndIf

If lContinua      

	dbSelectArea("SA5")
	dbSetOrder(2)
	dbSeek(xFilial("SA5")+cProduto+cFornece+cLoja)

	dbSelectArea("QE6")
	dbSetOrder(1)
	dbSeek(xFilial("QE6")+cProduto+Inverte(cRevisao))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a data da ultima Entrada do Fornecedor x Produto    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QEK")
	dbSetOrder(1)    
	If dbSeek(xFilial("QEK")+cFornece+cLoja+cProduto)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Verifica se o Tempo Limite est   expirado               	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SA5->A5_TEMPLIM) .And. (dEntrada-QEK->QEK_DTENTR) > (SA5->A5_TEMPLIM * 30)
			Aadd(aJustif,"Tempo Limite sem Entradas expirado.") //"Tempo Limite sem Entradas expirado."
			lJustificativa := .T.
			nVerifica      := 1
		Else                                 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define se o numero de Entradas a inspecionar, para uma nova revi- ³
			//³ sao sera igual a quantidade definida no parametro MV_QSKLENT.     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If GetMV("MV_QINSRVI",.T.,.F.) 
				nSklEnt   := 0
				nEntradas := 0     
			
				dbSelectArea("QEK")
				dbSetOrder(2)
				If dbSeek(xFilial("QEK")+cFornece+cLoja+cProduto)
					dVigencia := QE6->QE6_DTINI
					While !Eof() .And. QEK->QEK_FILIAL==xFilial("QEK") .And. (QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT==cFornece+cLoja+cProduto)
						
						nSklEnt++		
						
						If DtoS(QEK->QEK_DTENTR) < DtoS(dVigencia)
							nEntradas++         
							Exit
						EndIf	
						
						If nSklEnt >= SuperGetMv("MV_QSKLENT")  			
							Exit
	                    EndIf
						dbSkip() 
					EndDo	    
				Endif
				If nEntradas > 0
					Aadd(aJustif,"A quantidade de Entradas a Inspecionar, apos ") //"A quantidade de Entradas a Inspecionar, apos "
					Aadd(aJustif,"a definicao de uma nova Revisao, sera igual a") //"a definicao de uma nova Revisao, sera igual a"
					Aadd(aJustif,"quantidade definida no parametro MV_QSKLENT. ") //"quantidade definida no parametro MV_QSKLENT. "
					lJust     := .T.
					nVerifica := 1
				EndIf
	
			Else		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ‚ a 1a. Entrada ap¢s altera‡Æo de especifica‡Æo  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QEK->QEK_DTENTR < QE6->QE6_DTINI
					Aadd(aJustif,"Primeira Entrada após alteração da Especificação") //"Primeira Entrada ap¢s altera‡„o Especifica‡„o"
					lJustificativa := .T.
					nVerifica      := 1
					lAltEsp        := .T.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

If lJustificativa
	Aadd(aJustif,"Entrada dever  ser inspecionada.") //"Entrada dever  ser inspecionada."
EndIf
RestArea(aAreaSA5)   
RestArea(aAreaQE6)   
RestArea(aAreaQEK)   

Return(nVerifica)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A200SkTe ³ Autor ³ Quality   			³ Data ³22/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula o Skip-Teste de uma Entrada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A200SkTe(ExpC1,ExpC2,ExpC3,ExpL1,ExpC5,ExpL2)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Fornecedor                               ³±±
±±³          ³ ExpC2 = Loja do Fornecedor                                 ³±±
±±³          ³ ExpC3 = Codigo do Produto                                  ³±±
±±³          ³ ExpL1 = Ind. se ‚ a 1a. ocorr. Doc. Entr. p/ o Forn/Grupo  ³±±
±±³          ³ ExpC4 = Fator de reprovacao do laudo                       ³±±
±±³          ³ ExpC5 = Revisao do Produto                                 ³±±
±±³          ³ ExpL2 = Ind. se ‚ a 1a. ocorr. apos alteracao Especificacao³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QIEA200 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se houve Entrada anterior c/ Laudos Reprov., mostra mensagem p/ usuario  	     ³
//³ As consistencias realizadas para verificar se aplica o skip-lote valem   		 ³
//³ tambem para o skip-teste: no. Entradas iniciais, riai vencido, etc..	 		 ³
//³ Forca inspecao de todos os ensaios: 1a. Entrada apos alteracao especifi- 		 ³
//³ cao, Entrada anterior recusada (mesmas regras do skip-lote).			 		 ³
//³ Se o parametro para calcular o skip-teste somente para as Entradas inspecionadas ³
//³ estiver ligado, nao calcula o skip-teste se a Entrada for certificada pelo		 ³
//³ skip-lote. Neste caso, na impressao da ficha de uso, os ensaios aparecerao 		 ³
//³ como certificados tambem.														 ³
//³ Se o calculo para skip-teste for para todas as Entradas, verifica o				 ³
//³ skip-teste mesmo que a Entrada seja certificada pelo skip-lote,				     ³
//³ porque pode ter ensaio a inspecionar, e se o parametro MV_QCERENT = "N"			 ³
//³ (nao certifica a Entrada se tiver ensaio a insp. pelo skip-teste),				 ³
//³ forca a inspecao da Entrada.													 ³
//³ Para gravar os controles de skip-teste (atualizar os contadores),				 ³
//³ verifica o parametro MV_QSKPTES, para atualizar todas as Entradas ou			 ³
//³ somente as inspecionadas (verificacao na gravacao da Entrada).					 ³
//³ Skip-Teste Individual: controla pelo contador de cada ensaio.					 ³
//³ Skip-Teste por Grupo: somente verifica o skip-teste se for a 1a. ocorrencia		 ³
//³ do Documento de Entrada para o Fornecedor/Loja/Grupo. Para as demais repeticoes, ³
//³ os ensaios serao certificados.													 ³
//³ Na 1a. Entrada apos alteracao de especificacao de um produto, verifica se		 ³
//³ j  inspecionou o ensaio, depois do inicio vigencia da alteracao. Pode ter		 ³
//³ inspecionado para outro Produto do grupo, porque tambem teve alter. e j 		 ³
//³ teve Entrada, ou por ter estourado o contador. Neste caso, como j  inspe-		 ³
//³ cionou o ensaio do grupo, apos a alteracao, pode certifica-lo.					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function A200SkTe(cFornece,cLoja,cProduto,lPDoc,cFatRep,cRevi,lAltEsp)
Local aEnsPro  := {}
Local nI	   := 0
Local cGrupo   := Space(TamSX3("QEA_GRUPO")[1])
Local aEns	   := {}
Local nCt	   := 0
Local nCtRecu  := 0
Local nEntInsp := 0 
Local aAreaAnt := GetArea()
Local aAreaQEK := QEK->(GetArea())
Local cSeek    := ""
Local lNFQEL   := IIF(QEL->(FieldPos('QEL_NISERI')) > 0,.t.,.f.)
Local cNiseri  := ""
//Identifica no. Entradas a Inspecionar referente ao fator de Reprovacao
nEntInsp := Fator("3",.F.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega os Ensaio para aplicar o Skip-Teste Individual e por ³
//³ Grupo.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QE7")
dbSetOrder(1)
dbSeek(xFilial("QE7")+cProduto+cRevi)
While QE7_FILIAL+QE7_PRODUT+QE7_REVI == xFilial("QE7")+cProduto+cRevi .And. !Eof()
	Aadd(aEnsPro,QE7_ENSAIO)
	dbSkip()
EndDo           

dbSelectArea("QE8")
dbSetOrder(1)
dbSeek(xFilial("QE8")+cProduto+cRevi)
While QE8_FILIAL+QE8_PRODUT+QE8_REVI == xFilial("QE8")+cProduto+cRevi .And. !Eof()
	Aadd(aEnsPro,QE8_ENSAIO)
	dbSkip()
EndDo

//Identifica o Grupo do Produto
dbSelectArea("QEA")
dbSetOrder(2)
If dbSeek(xFilial("QEA")+cProduto)
	cGrupo := QEA_GRUPO
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de Entradas recusadas					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nCt     := 0
nCtRecu := 1

dbSelectArea("QEK")
dbSetOrder(2)  
dbSeek(xFilial("QEK")+cFornece+cLoja+cProduto)	//ultima entrada do Fornecedor/Produto
While QEK_FILIAL+QEK_FORNEC+QEK_LOJFOR+QEK_PRODUT == xFilial("QEK")+cFornece+cLoja+cProduto .And. !Eof()

	dbSelectArea("QEL")

	If lNFQEL	
		cNiseri := QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF
		dbSetOrder(3)          
		cSeek := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+cNiseri+QEK->QEK_TIPONF+;
			DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE
	Else
		dbSetOrder(1)          
		cSeek := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+;
			dTos(QEK->QEK_DTENTR)+QEK->QEK_LOTE
	EndIf
	If dbSeek(xFilial("QEL")+cSeek+Space(TamSX3("QEL_LABOR")[1]))
	
		// Verifica se o Fator do Laudo tem no. Entradas a inspecionar
		dbSelectArea("QED")
		dbSetOrder(1)
		dbSeek(xFilial("QED")+QEL->QEL_LAUDO)
		If QED->QED_ENTINS <> 0 .And. nCt <= QED->QED_ENTINS-1
			nCtRecu := 2
			Exit
		EndIf   
		
	EndIf

	nCt++
	If nCt > nEntInsp
		Exit
	EndIf
	
	dbSelectArea("QEK")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza o Calculo do Skip-Teste								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to Len(aEnsPro)

	//Verifica se h  skip-teste individual definido
	dbSelectArea("QEH")
	dbSetOrder(1)
	If dbSeek(xFilial("QEH")+cFornece+cLoja+cProduto+aEnsPro[nI])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houve alteracao de especificacao ou Entrada anterior com  ³
		//³ laudo reprovado, inspeciona o ensaio.						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAltEsp .Or. nCtRecu <> 1
			Aadd(aEns,{aEnsPro[nI],1})
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o ensaio dever  ser inspecionado				 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("QEN")
			dbSetOrder(1)
			If !dbSeek(xFilial("QEN")+cFornece+cLoja+cProduto+aEnsPro[nI])
				Aadd(aEns,{aEnsPro[nI],1})
			Else
				If QEN_CONTAD+1 > QEH->QEH_SKPTES
					Aadd(aEns,{aEnsPro[nI],1})
				Else
					Aadd(aEns,{aEnsPro[nI],QEN_CONTAD+1})
				EndIf
			EndIf
		EndIf

	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o Skip_teste por Grupo somente na primeira ocorren- ³
		//³ cia por Documento de Entrada para o Fornecedor x Produto	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lPDoc  
		
			//Verifica se h  skip-teste por Grupo definido
			dbSelectArea("QEI")
			dbSetOrder(1)
			If dbSeek(xFilial("QEI")+cFornece+cLoja+cGrupo+aEnsPro[nI])

				//Verifica se j  inspecionou o ensaio
				dbSelectArea("QEO")
				dbSetOrder(1)
				If !dbSeek(xFilial("QEO")+cFornece+cLoja+cGrupo+aEnsPro[nI])
					Aadd(aEns,{aEnsPro[nI],1})
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se houve alteracao de especificacao, inspeciona o ensaio, se ³
					//³ ainda nao foi inspecionado p/ o grupo, ou se Entradas anterio³
					//³ res tiveram laudo reprovado.								 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nCtRecu <> 1
						Aadd(aEns,{aEnsPro[nI],1})
					Else
						If lAltEsp

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se j  inspecionou apos a alteracao especificacao,   ³
							//³ algum produto do grupo.										 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If QEO_DTENTR < QE6->QE6_DTINI
								Aadd(aEns,{aEnsPro[nI],1})
								
							Else
								//Verifica se precisa inspecionar o ensaio pelo contador
								If QEO_CONTAD+1 > QEI->QEI_SKPTES
									Aadd(aEns,{aEnsPro[nI],1})
								Else
									Aadd(aEns,{aEnsPro[nI],QEO_CONTAD+1})
								EndIf
							EndIf
						Else
							// Verifica se precisa inspecionar o ensaio pelo contador
							If QEO_CONTAD+1 > QEI->QEI_SKPTES
								Aadd(aEns,{aEnsPro[nI],1})
							Else
								Aadd(aEns,{aEnsPro[nI],QEO_CONTAD+1})
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Next nI

RestArea(aAreaQEK)
RestArea(aAreaAnt)

Return(aEns)
