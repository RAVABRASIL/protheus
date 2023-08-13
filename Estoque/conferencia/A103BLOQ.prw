#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A103BLOQ  º Autor ³ Gustavo Costa      º Data ³  25/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ O ponto se encontra no final da função logo após a         º±±
±±º          ³ verificação da tolerância de recebimento.			      º±±
±±º O ponto deve ser utilizado para interromper esta validação para atenderº±±
±±º uma determinada necessidade especifica de um cliente.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Recebimento de NOTA FISCAL ENTRADA                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

LOCALIZAÇÃO : Function A103TemBlq - responsável pela validação da tolerância de recebimento no momento da confirmação da NFE.

/*/

User Function A103BLOQ()

Local nCont    := 0											//Contador generico
Local lRet     := .F.										//Retorno para o ponto de entrada
Local aCompra  := {}										//Array com os dados das compras
Local nElem    := 0											//Indexado ro aCompra
Local cChave   := ''										//Chave de busca no SC7
Local aArea    := GetArea()									//Salva area
//
Local aAreaF8  := SC7->(GetArea())							//Salva area
local nValFret :=0
//
Local aAreaC7  := SC7->(GetArea())							//Salva area
Local aAreaB1  := SB1->(GetArea())							//Salva area
Local aAreaE4  := SE4->(GetArea())							//Salva area
Local aAreaF1  := SF1->(GetArea())							//Salva area
Local aMsg     := {}										//Mensagens para listbox
Local aMsg2    := {}										//Mensagens para listbox
Local cMsg     := ''										//Mensagem corrente
Local oMsg													//Objeto listbox
Local oDlgPCxNF												//Objeto dialogo
Local oFontList:= TFont():New("Courier New",,14,,.T.)		//Fonte para mensagens

Local nPosPC   := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_PEDIDO' })					//Posicao Pedido no acols
Local nPosItem := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_ITEMPC' })					//Posicao item pedido no acols
Local nPosQtd  := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_QUANT'  })					//Posicao quantidade no acols
Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_COD'    })					//Posicao produto no acols
Local nPosTot  := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TOTAL'  })					//Posicao total no acols
Local nPosDesc := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_VALDESC'})					// Posicao valor desconto no acols
Local nPosFRET := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_VALFRE'})						// Posicao valor FRETE no acols
Local nPosIPI  := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_VALIPI'})						// Posicao valor IPI no acols
Local cTES 	  	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'})				        	// Posicao do TES 
//Local nF1FRET := M->F1_VALFRET
Local nC7FRET	:= 0

///acrescentado por Flavia Rocha
Local nPosQSegum:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_QTSEGUM'})					// Posicao da qtde na segunda UM no acols
Local nPosNSeq	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_NUMSEQ'})					    // Posicao do campo D1_NUMSEQ no acols
Local nPosITNF	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_ITEM'})					    // Posicao do campo D1_ITEM no acols
Local nPosLoteF	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_LOTEFOR'})				    // Posicao do campo D1_LOTEFOR no acols
Local nPosLocal	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_LOCAL'})	    			    // Posicao do campo D1_LOCAL no acols
Local nPosNumCQ	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_NUMCQ'})	    			    // Posicao do campo D1_NUMCQ no acols  
Local nPosTES  	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'})						// Posicao valor desconto no acols
Local nPosCONT  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_XCONTAG"})					// Posicao do numero da contagem no acols
Local cChvQEK  	:= ""  //variável que armazenará a chave (QEK_CHAVE)
Local nTamAmo  	:= 0   //variável que armazenará o tamanho da amostra (numérico)
Local nSEQ     	:= 0  // armazena o sequencial do SD7, para impossibilitar duplicidades
Local aDados   	:= {} //array com os dados da NF para gravar no ambiente Qualidade
Local aCondPag  := {} //array para armazenar dados da função Condicao() a qual retornará vencto da parcela de acordo com a condição de pagto. da NF
Local DiaVenc   := Ctod("  /  /    ")
Local nValTot   := 0 
Local nVALIPI   := 0

////FIM FLAVIA ROCHA

Local nToler   	:= GetNewPar('MV_XTOLPRC',0)											//Tolerancia para diferenca no preco liquido
Local nVlrToler	:= GetNewPar('MV_XTOLVLR',1.0)										//Tolerancia em valor para diferenca no preco liquido

Local lDifQtd  	:= .F.																//Indica diferenca quantidade
Local lDifCond 	:= .F.																//Indica diferenca condicao de pgto
Local lDifPrc  	:= .F.																//Indica diferenca preco liquido
Local lDifConf 	:= .F.																//Indica diferenca de quantidade contada 
Local lDifFre  	:= .F.																//Indica diferença de valor frete
Local lCabec   	:= .T.
	
Local lEnvia   	:= .F.																//Indica se o envia o email
Local lEnviado 	:= .F.																//Indica se o email foi enviado
//Local cMailTo  := AllTrim(POSICIONE("SY1",3,xFilial("SY1")+SC7->C7_USER,"Y1_EMAIL"))//Email do destinatário - do digitador do pedido (Comprador)
Local cMailTo  	:= "compras@ravaembalagens.com.br"									//Email do destinatário - do digitador do pedido (Comprador)
Local cTitulo  	:= ""
Local cConteudo	:= ""
Local cConteudo2:= ""

Local cD7Num   := ""  //Armazena o número do CQ para esta NF
Local dataEmis := dDEmissao
Local cNF := cNFiscal  		//variável do sistema
Local cSeriNF := cSerie 	//variável do sistema
Local cFornece:= cA100For  	//variável do sistema
Local cLojaFor:= cLoja  	//variável do sistema
Local aAnexos	:= {}
//cTipoNF := variável do sistema

LOCAL  lFretComp:=.F.

// INSERIDO POR ANTONIO
// Retirado em 05/07/2012 - So volta depois que o chamado 002585 for resolvido 

nPosTES := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'    })					    //Posicao TES no acols
cTesFret:=GETMV("MV_TESFRE")
If Inclui
   if alltrim(aCols[1][nPosTES]) $ cTesFret
      DbselectArea("Z86")  
      Z86->( dbSetOrder( 1 ) )
      If   Z86->( dbSeek( xFilial( "Z86" ) + CNFISCAL + CSERIE +CA100FOR+CLOJA ) )           
           IF Z86->Z86_FRETE>Z86->Z86_FRESIS // DIVERGENCIA NO FRETE 
              //ALERT('ENCONTRO DIVERGENCIA')
              //EMAIL(Z86->Z86_CONHEC,Z86->Z86_SERIE,Z86->Z86_FORNEC,Z86->Z86_LOJA,Z86->Z86_FRETE,Z86->Z86_FRESIS) 
              //Restaura areas
              RestArea(aAreaF8)
              RestArea(aAreaC7)
              RestArea(aAreaB1)
              RestArea(aAreaE4)
              RestArea(aArea)
              Return .T.
           ENDIF
      Endif
   Endif
EndIF

//

if l103Class // classifica 
  SF8->(dbSetOrder(2))
  If SF8->(Dbseek(xFilial("SF8") + CNFISCAL + CSERIE +CA100FOR+CLOJA ))
     IF EMPTY(SF1->F1_APROV) // verifico se ja foi liberado, se foi nao precisa divergir mas. 
        lFretComp:=.T.
     ENDIF   
  Endif
Endif

IF ! lFretComp
	//Soh faz validacao para pedios Normais e que o TES está contido no parâmetro
	If !INCLUI .OR. cTipo <> "N" .OR. ((aCols[1][cTes]) $ Trim(GetNewPar("MV_XTESPCN","")))// .OR. Empty(cSerie)
		Return nil
	EndIf
ENDIF

//Seta ordem das tabelas
SC7->(dbSetOrder(4))
SB1->(dbSetOrder(1))
SE4->(dbSetOrder(1))


//Varre aCols, colocando as informacoes no array aCompra
//msgbox("a103bloq inicio")
For nCont := 1 to Len(aCols)
	
	//Ignora os deletados
	If aCols[nCont][Len(aHeader)+1]
		Loop
	EndIf
	
	//----------------------------------------
	//Localiza, no array, pela ocorrencia de
	//Pedido+Produto+Item
	//----------------------------------------
	
	nElem := aScan(aCompra,{ |x| x[1]+x[2]+x[3] == aCols[nCont][nPosPC]+aCols[nCont][nPosProd]+aCols[nCont][nPosItem] })
	
	If Empty(nElem)
		//   frete  		
		  SF8->(dbSetOrder(2))
		  If SF8->(Dbseek(xFilial("SF8") + CNFISCAL + CSERIE +CA100FOR+CLOJA ))
		     //                 nota frete      serie frete     fornec. frete  loja free       data digitacao   produto 
		     nValFret:=fValFret(SF8->F8_NFDIFRE,SF8->F8_SEDIFRE,SF8->F8_TRANSP,SF8->F8_LOJTRAN,SF8->F8_DTDIGIT,aCols[nCont][nPosProd])
		  Else
		     nValFret:=aCols[nCont][nPosFRET]
		  Endif 
		//
		aADD(aCompra,{aCols[nCont][nPosPC],;									//01-Pedido de Compra
		aCols[nCont][nPosProd],;												//02-Produto
		aCols[nCont][nPosItem],;												//03-Item Pedido Compra
		0,;																		//04-Qtd NFE
		0,;																		//05-Qtd PC
		0,;																		//06-Valor NFE
		0,;																		//07-Valor PC
		cCondicao,;																//08-Cond Pgto NFE
		CriaVar('C7_COND'),;													//09-Cond Pgto PC  
		nValFret,;											                 	//10-Valor Frete NF  
		0 ,;																	//11-Valor Frete PC
		aCols[nCont][nPosCont] } )												//12-Numero da contagem
		
		nElem := Len(aCompra)
	EndIf
	
	nValTot += aCols[nCont][nPosTot] 
	nVALIPI += aCols[nCont][nPosIPI] 
	
	aCompra[nElem][4] += aCols[nCont][nPosQtd]									//Acumula quantidade da NFE
	aCompra[nElem][6] += aCols[nCont][nPosTot] - aCols[nCont][nPosDesc] + aCols[nCont][nPosIPI]			//Acumula total liquido da NFE
	
	////////////////////////////////////////////////
	//TRATAMENTOS RELATIVOS À INSPEÇÃO DE QUALIDADE 
	///////////////////////////////////////////////
	
	DbselectArea("SB1")
	SB1->(Dbsetorder(1))
	If SB1->(Dbseek(xFilial("SB1") + aCols[nCont][nPosProd] ))
		If Alltrim(SB1->B1_RAVACQ) = "S"		
			 
			//SE O PRODUTO FOR SUJEITO À INSPEÇÃO, A NF JÁ ENTRA BLOQUEADA:
			lRet := .T.
            MsgInfo("A NF ficará Bloqueada até que seja feita a INSPEÇÃO DE QUALIDADE." )
			///////////////////////////////////////////////////////////////////////
			//CRIEI ESTE CAMPO NOVO, PORQUE SE DEIXARMOS PELO FLAG PADRÃO, 
			//QDO CLASSIFICAR A NOTA, IRÁ REPETIR O PROCESSO PELO DOCTO. ENTRADA
			//NÃO TEM COMO IMPEDIR O PROCESSO  
			//POR ESTE MOTIVO CRIEI ESTE NOVO CAMPO.
			///////////////////////////////////////////////////////////////////////
		  			
		    nSEQ++
						
		    Dbselectarea("SD7")
		    Dbsetorder(4)      //D7_FILIAL + D7_NUMERO  + D7_DOC + D7_SERIE + D7_FORNECE + D7_LOJA + D7_PRODUTO + D7_SEQ  //NOVO ÍNDICE
		    If !SD7->(Dbseek(xFilial("SD7") + cD7Num + cNF + cSeriNF + cFornece + cLojaFor + aCols[nCont][nPosProd] + Strzero(nSEQ , 3 )  ))
				//MSGBOX("INSERE SD7")
				
				Reclock("SD7",.T.)
				SD7->D7_FILIAL := xFilial("SD7")
				SD7->D7_PRODUTO:= aCols[nCont][nPosProd] //SD1->D1_COD
				SD7->D7_LOCAL  := '01' 
				SD7->D7_ORIGLAN:= 'NF'
				SD7->D7_CHAVE  := ''
				SD7->D7_SEQ    := Strzero(nSEQ , 3 )	
				SD7->D7_ESTORNO:= ''
				SD7->D7_TIPO   := 0
				SD7->D7_SALDO  := aCols[nCont][nPosQtd]  //SD1->D1_QUANT
				SD7->D7_QTSEGUM:= aCols[nCont][nPosQSegum] //SD1->D1_QTSEGUM
				SD7->D7_USUARIO:= Substr(cUsuario,7,15)
				SD7->D7_DATA   := dataEmis  //SD1->D1_EMISSAO
				SD7->D7_NUMSEQ := ""  //aCols[nCont][nPosNSeq] // SD1->D1_NUMSEQ
				SD7->D7_LOCDEST:= '01' 
				SD7->D7_NUMERO := cD7Num //SD1->D1_NUMCQ
				SD7->D7_LIBERA := ''
				SD7->D7_LOTECTL:= Alltrim(cNF) + Alltrim(aCols[nCont][nPosItem])  //Lote: número da nf + item do PC //SD1->D1_LOTECTL
				SD7->D7_NUMLOTE:= ''
				SD7->D7_MOTREJE:= ''
				SD7->D7_SALDO2 := aCols[nCont][nPosQtd]  //SD1->D1_QUANT
				SD7->D7_TIPOCQ := 'M'
				SD7->D7_DOC    := cNF  //SD1->D1_DOC
				SD7->D7_SERIE  := cSeriNF //SD1->D1_SERIE
				SD7->D7_FORNECE:= cFornece  //SD1->D1_FORNECE
				SD7->D7_LOJA   := cLojaFor  //SD1->D1_LOJA
				SD7->D7_LOCALIZ:= ''
				SD7->D7_NUMSERI:= ''
				SD7->D7_POTENCI:= 0
				SD7->D7_ITEMSWN:= ''
				SD7->D7_DOCSWN := ''
				SD7->D7_SERVIC := ''
				SD7->(MsUnlock())
			Endif
		
			aDados := {cNF,; //1-Numero da Nota Fiscal
						cSeriNF,;        			//2-Serie da Nota Fiscal
						cTipo,;         			//3-Tipo da Nota Fiscal
						dataEmis,;      			//4-Data de Emissao da Nota Fiscal
						Date(),;      				//5-Data de Entrada da Nota Fiscal
						"NF" ,; //Substr(cEspecie,1,2),;                 	//6-Tipo de Documento
						aCols[nCont][nPosITNF] ,;  	//7-Item da Nota Fiscal
						" ",;                  		//8-Numero do Remito (Localizacoes)
						aCols[nCont][nPosPC],;      //9-Numero do Pedido de Compra
						aCols[nCont][nPosItem],;    //10-Item do Pedido de Compra
						cFornece,;      			//11-Codigo Fornecedor/Cliente
						cLojaFor,;         			//12-Loja Fornecedor/Cliente
						"",;   //13-Numero do Lote do Fornecedor
						"00126",;             		//14-Codigo do Solicitante
						aCols[nCont][nPosProd],;    //15-Codigo do Produto
						aCols[nCont][nPosLocal],;   //16-Local Origem
						cNF,;         				//17-Numero do Lote     Lote é o número da NF + sequencial de cada item do PC
						aCols[nCont][nPosItem],;    //18-Sequencia do Sub-Lote
						Str(nSEQ) ,;  //aCols[nCont][nPosNSeq],;	//19-Numero Sequencial
						cD7Num,;		       		//20-Numero do CQ
						aCols[nCont][nPosQtd],;		//21-Quantidade
						aCols[nCont][nPosTot],;		//22-Preco
						0 ,;                   		//23-Dias de atraso
						aCols[nCont][nPosTES] ,; 		       		//24-TES
						AllTrim(FunName()),;   		//25-Origem						
						"" ,;           		//26-Origem TXT	
						 0 }  //aCols[nCont][nPosQtd]} 		//27-Quantidade do Lote Original
							
						
						//ANTES DE EFETUAR A GRAVAÇÃO DOS DADOS DA QUALIDADE, VERIFICA NO SA5, SE EXISTE AMARRAÇAO DE PRODUTO x FORNECEDOR
						SA5->(DBSETORDER(1))
						If !SA5->(DBSEEK(xFilial("SA5") + cFornece + cLojaFor + aCols[nCont][nPosProd] ))
							RecLock("SA5",.T.)
							SA5->A5_FILIAL := xFilial("SA5")
							SA5->A5_FORNECE:= cFornece
							SA5->A5_LOJA   := cLojaFor
							SA5->A5_NOMEFOR:= AllTrim(POSICIONE("SA2",1,xFilial("SA2")+ cFornece + cLojaFor,"A2_NOME"))
							SA5->A5_PRODUTO:= aCols[nCont][nPosProd]
							SA5->A5_NOMPROD:= Posicione("SB1",1,xFilial('SB1') + aCols[nCont][nPosProd] ,"B1_DESC")  
							SA5->A5_SITU   := "C"
							SA5->A5_TEMPLIM:= 1
							SA5->A5_FABREV := "F"
							SA5->(MSUNLOCK())
							
						Endif
										
						If Len(aDados) > 0
								//MSGBOX("VAI LER ARRAY PARA INCLUIR QUALIDDE")				
								U_qAtuMatQie(aDados,1,.F.,.F.)    //esta função está dentro do U_QIEXFUNA.PRW  (pasta Qualidade)
								//msgbox("incluiu qualidade: " + aDados[15] )
								nTamAmo := 0
								DbselectArea("QEK")
								QEK->(Dbsetorder(10)) //QEK_FILIAL+QEK_FORNEC+QEK_LOJFOR+QEK_NTFISC+QEK_SERINF+QEK_ITEMNF    +QEK_TIPONF+QEK_NUMSEQ                                                                         
								If QEK->(Dbseek(xFilial("QEK") + cFornece + cLojaFor + cNF + cSeriNF + aDados[7] + cTipo ))
									cChvQEK := QEK->QEK_CHAVE
									QF5->(Dbsetorder(1)) //QF5_FILIAL + QF5_CHAVE
									If QF5->(Dbseek(xFilial("QF5") + cChvQEK  ))                                                                             //PRODUTO
										While !QF5->(EOF()) .AND. QF5->QF5_FILIAL == xFilial("QF5") .AND. QF5->QF5_CHAVE == cChvQEK .AND. Alltrim(QF5->QF5_PRODUT) == Alltrim(aDados[15])
											nTamAmo := QF5->QF5_TAMA1	  //captura o tamanho da amostra que gerou no QF5 ....					
											QF5->(Dbskip())	 
										Enddo
									Endif
								
									QEK->(Dbsetorder(7))    //QEK_FILIAL + QEK_CHAVE
									If QEK->(Dbseek(xFilial("QEK") + cChvQEK ))
										While !QEK->(EOF()) .and. QEK->QEK_FILIAL == xFilial("QEK")	.and. QEK->QEK_CHAVE == cChvQEK .AND. Alltrim(QEK->QEK_PRODUT) == Alltrim(aDados[15])
											RecLock("QEK",.F.)
											QEK->QEK_TAM_AM := nTamAmo    //e grava de volta no QEK
											QEK->(MsUnlock())
											QEK->(Dbskip())			
										Enddo
									Else
										msgbox("A103BLOQ - Qualidade: não achou chave QEK: " + cChvQEK )	
									Endif
								Else
									msgbox("A103BLOQ - Qualidade: não achou QEK: " + cFornece + '/' + cLojaFor + '/' + cNF + '/' + cSeriNF )
								Endif						
						Endif	//se Len(aDados) > 0				
		Endif //se é RavaCQ
	Else
		msgbox("Produto não encontrado: " + aCols[nCont][nPosProd] + ". Favor contatar o Administrador do Sistema.")
	Endif
		
	
Next nCont



//Coloca, o array aCompras, as informacoes acumuladas do Pedido de Compras
For nCont := 1 to Len(aCompra)
	cChave := xFilial('SC7')+aCompra[nCont][2]+aCompra[nCont][1]+aCompra[nCont][3]  //Produto+Pedido+Item
	If SC7->(dbSeek(cChave))
		While SC7->(!Eof()) .and. SC7->(C7_FILIAL+C7_PRODUTO+C7_NUM+C7_ITEM) == cChave
			//aCompra[nCont][5] += SC7->(C7_QUANT-C7_QUJE) Gustavo
			aCompra[nCont][5] += SC7->C7_QUANT
			aCompra[nCont][7] += SC7->(C7_TOTAL-C7_VLDESC+C7_VALIPI)
			
			//Forca a verificacao da condicao de pagamento
			If aCompra[nCont][8] == aCompra[nCont][9] .or. Empty(aCompra[nCont][9])
				aCompra[nCont][9] := SC7->C7_COND
			EndIf
		    
//			If aCompra[nCont][10] == aCompra[nCont][11] .or. Empty(aCompra[nCont][11])
				aCompra[nCont][11] := SC7->C7_VALFRET * (SC7->(C7_TOTAL-C7_VLDESC)/fTotPc(SC7->C7_NUM))
//			Endif
			SC7->(dbSkip())
		EndDo
	EndIf
Next nCont

//Calcula o preco liquido unitario
For nCont := 1 to Len(aCompra)
	If !Empty(aCompra[nCont][4])
		aCompra[nCont][6] := Round(aCompra[nCont][6]/aCompra[nCont][4],TamSX3('D1_VUNIT')[2])
	EndIf
	If !Empty(aCompra[nCont][5])
		aCompra[nCont][7] := Round(aCompra[nCont][7]/aCompra[nCont][5],TamSX3('D1_VUNIT')[2])
	EndIf
Next nCont

//         1         2         3         4
//12345678901234567890123456789012345678901234567890
//==================================================
//Pedido Produto         Descricao                Un
//==================================================
//999999 999999999999999 AAAAAAAAAAAAAAAAAAAAAAAA AA
//                       AAAAAAAAAAAAAAAAAAAAAAAAA
//--------------------------------------------------
// => Qtd. Nota Fiscal:
// => Saldo do Pedido.:
//--------------------------------------------------
// => Condicao da Nota: AAA - AAAAAAAAAAAAAAAAAAAAAA
// => Condicao Pedido.:
//--------------------------------------------------
// => Preco Medio NFE.:
// => Preco Medio PC..:
//--------------------------------------------------
//Guia Produto         Descricao                Un
//==================================================
// => Qtd. Nota Fiscal:
// => Qtd. Guia de Conf.:
//--------------------------------------------------


//FR - chamado #160 - JORGE -> GERAR DIVERGENCIA NA ENTRADA DA NOTA QUANDO OS BOLETOS TIVEREM VENCIMENTOS NOS DIAS 05, 10 E 15
	aCondPag := Condicao(nValTot,cCondicao,nVALIPI,dataEmis) //,nVSol)
	If Len(aCondPag) > 0
		DiaVenc := aCondPag[1][1]   //pega o vencto da primeira parcela
	Endif
/*
Parametros
nValTot – Valor total a ser parcelado
cCond – Código da condição de pagamento
nVIPI – Valor do IPI, destacado para condição que obrigue o pagamento do IPI na 1ª parcela
dData – Data inicial para considerar

Retorna
aRet – Array de retorno ( { {VENCTO, VALOR} , ... } )

*/

//Determina os pontos de quebra de amarracao
For nCont := 1 to Len(aCompra)
	
	aGuiaConf	:= U_FindGConf(aCompra[nCont][2], cA100For, cLoja, aCompra[nCont][1], aCompra[nCont][3], aCompra[nCont][12])
	
	lDifQtd  := aCompra[nCont][4] <> aCompra[nCont][5]
	lDifCond := aCompra[nCont][8] <> aCompra[nCont][9]
	lDifPrc  := aCompra[nCont][6] <> aCompra[nCont][7] //Round(aCompra[nCont][6],2) <> Round(aCompra[nCont][7],2)
	lDifGuia := aCompra[nCont][4] <> aGuiaConf[1][2] 
	lDifFre  := aCompra[nCont][10] <> aCompra[nCont][11]   //nC7FRET <> aCompra[nCont][10]  //nC7FRET
	
	//FR - CHAMADO #160
	lDifVenc := .F. //Substr(Dtos(DiaVenc),7,2) $ GetNewPar("MV_XDIABLQ","10/15/16/20")
	/*
	If (aCompra[nCont][7] * nToler > nVlrToler)
	lDifPrc  := aCompra[nCont][6] > aCompra[nCont][7] .and. ;
	(aCompra[nCont][6]-aCompra[nCont][7])/aCompra[nCont][7]*100 > nToler
	Else
	lDifPrc  := aCompra[nCont][6] > aCompra[nCont][7] .and. ;
	(aCompra[nCont][6]-aCompra[nCont][7]) > nVlrToler
	EndIf
	*/
	
	SB1->(dbSeek(xFilial('SB1')+aCompra[nCont][2]))

	//Monta listbox com mensagens para o usuario
	If lDifQtd .or. lDifCond .or. lDifPrc .or. lDifGuia .or. lDifFre .or. lDifVenc
		
		lRet := .T.
		lEnvia := .T.

		IF lCabec
			aADD(aMsg,'A Nota será bloqueada. Segue(m) motivo(s) abaixo: ')
			aADD(aMsg,'Pedido Produto         Descrição                Un')
			aADD(aMsg2,'A Nota será bloqueada. Segue(m) motivo(s) abaixo: ')
			aADD(aMsg2,'Pedido Produto         Descrição                Un')
			lCabec := .F.
		EndIf
		
		aADD(aMsg,'==================================================')
		aADD(aMsg,aCompra[nCont][1]+' - '+aCompra[nCont][2]+' - '+Left(SB1->B1_DESC,24)+' - '+SB1->B1_UM)
		aADD(aMsg,Space(23)+Substr(SB1->B1_DESC,25,25))
		aADD(aMsg2,'==================================================')
		aADD(aMsg2,aCompra[nCont][1]+' - '+aCompra[nCont][2]+' - '+Left(SB1->B1_DESC,24)+' - '+SB1->B1_UM)
		aADD(aMsg2,Space(23)+Substr(SB1->B1_DESC,25,25))
	EndIf
	
	If lDifQtd
		aADD(aMsg,' => Qtd. Nota Fiscal: '+Transform(aCompra[nCont][4],PesqPict('SD1','D1_QUANT')))
		aADD(aMsg,' => Saldo do Pedido.: '+Transform(aCompra[nCont][5],PesqPict('SD1','D1_QUANT')))
		aADD(aMsg,'--------------------------------------------------')
	EndIf
	
	If lDifCond
		aADD(aMsg,' => Condicao da Nota: '+Left(Posicione('SE4',1,xFilial('SE4')+aCompra[nCont][8],'E4_DESCRI'),22))
		aADD(aMsg,' => Condicao Pedido.: '+Left(Posicione('SE4',1,xFilial('SE4')+aCompra[nCont][9],'E4_DESCRI'),22))
		aADD(aMsg,'--------------------------------------------------')
	EndIf
	
	If lDifVenc
		aADD(aMsg,' => Condicao da Nota:  '+Left(Posicione('SE4',1,xFilial('SE4')+aCompra[nCont][8],'E4_DESCRI'),22))
		aADD(aMsg,' => Vencto.1a.Parcela: ' + Dtoc(DiaVenc) + ', Os Vencimentos não poderão ser nos dias 05, 15, 16 ou 20.')
		aADD(aMsg,'--------------------------------------------------')
	EndIf
	
	If lDifPrc
		aADD(aMsg,' => Preco NFE.: '+Transform(aCompra[nCont][6],PesqPict('SD1','D1_VUNIT')))
		aADD(aMsg,' => Preco PC..: '+Transform(aCompra[nCont][7],PesqPict('SD1','D1_VUNIT')))
		aADD(aMsg,'--------------------------------------------------')
	EndIf
	
	If lDifFre
		aADD(aMsg,' => Valor Frete NFE.: '+Transform(aCompra[nCont][10],PesqPict('SD1','D1_VALFRE')))
		aADD(aMsg,' => Valor Frete PC..: '+Transform(aCompra[nCont][11],PesqPict('SD1','D1_VALFRE')))
		aADD(aMsg,'--------------------------------------------------')
	EndIf
	
	If lDifGuia
		aADD(aMsg,' => Qtd. Nota Fiscal: '+Transform(aCompra[nCont][4],PesqPict('SD1','D1_QUANT')))
		aADD(aMsg,' => Qtd. Guia de Conf.: '+Transform(aGuiaConf[1][2],PesqPict('SD1','D1_QUANT')))
		aADD(aMsg,'--------------------------------------------------')
		aADD(aMsg2,' => Qtd. Guia de Conf.: '+Transform(aGuiaConf[1][2],PesqPict('SD1','D1_QUANT')))
		aADD(aMsg2,'--------------------------------------------------')
	EndIf

Next nCont

//If( lRet ).AND.( INCLUI .OR. lFretComp )
If( lEnvia ).AND.( INCLUI .OR. lFretComp )
	
	If Len(aMsg) > 0
		cTitulo  := "Divergência na Nota Fiscal de Entrada - " + Alltrim(cNfiscal) + '/' + cSerie
		
		cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
		cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml' >"
		cConteudo +="<head>"
		cConteudo +="    <title>Untitled Page</title>"
		cConteudo +="</head>"
		cConteudo +="<body>"            
		dbSelectArea("SM0")
		cConteudo +="Na empresa " + SM0->M0_CODIGO + SM0->M0_CODFIL + " - " + AllTrim(SM0->M0_FILIAL) + ".<br /><br />"
		cConteudo +="A <strong>Nota Fiscal</strong> de número <strong>" + Alltrim(cNfiscal) + '/' + cSerie + "</strong> " + "<br /><br />"
		cConteudo +="<strong>Fornecedor</strong> - " + cA100For + " - " + AllTrim(POSICIONE("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_NOME")) + "<br /><br />"
		cConteudo +="Está divergindo do <strong>Pedido de Compra</strong> de número <strong>" + aCompra[1][1] + "</strong>. <br /><br />"                      
			
		cConteudo2 += cConteudo
		For i :=1 to Len(aMsg)
			cConteudo += aMsg[i] + "<br />"
		Next i
			//Comentado por Eurivan no sabado
		If lDifGuia
			For j :=1 to Len(aMsg2)
				cConteudo2 += aMsg2[j] + "<br />"
			Next j
		EndIf
		
		cConteudo +="</body>"
		cConteudo +="</html>"
		cConteudo2 +="</body>"
		cConteudo2 +="</html>"
		
		DEFINE MSDIALOG oDlgPCxNF TITLE 'Divergências entre Nota Fiscal X Pedido de Compras X Conferência' FROM 0,0 To 15,52 OF oMainWnd
		
		@ 005,005 LISTBOX oMsg VAR cMsg SIZE 200,100 ITEMS aMsg OF oDlgPCxNF PIXEL
		oMsg:oFont := oFontList
		
		ACTIVATE MSDIALOG oDlgPCxNF CENTERED  
	Endif
	
EndIf

If lEnvia
	//IF !(".com" $ cMailTo) .or. !(".gov" $ cMailTo) .or. !(".org" $ cMailTo) .or. !(".com.br" $ cMailTo) .or. !(".edu" $ cMailTo)
		//cMailTo := "informatica@ravaembalagens.com.br"
	//EndIf
	cCopia 	:=  GetNewPar('MV_XCOPBLQ',"marcelo@ravaembalagens.com.br")
	//cCopia 	:= GetNewPar('MV_XCOPBLQ',"flavia.rocha@ravaembalagens.com.br")
	cAnexo	:= ""
	cMailTo := cMailTo + ";" + cCopia
	AADD(aAnexos, cAnexo)
	lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )
	//lEnviado := U_fEnvMail(cMailTo, cTitulo, cConteudo, aAnexos, .T., .F.)
	If lDifGuia  // Se tiver problema na contagem, envia email diferenciado para Alexandre
		//Para verificar se o conteudo esta correto.
		cCopia	:= "" //"informatica@ravaembalagens.com.br"
		cMailTo := GetNewPar('MV_XMAILCP',"joao.emanuel@ravaembalagens.com.br")
		lEnviado := U_fEnvMail(cMailTo, cTitulo, cConteudo, aAnexos, .T., .F.)
		//lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo2, cAnexo ) 
    EndIf
    
	If lEnviado
		MsgAlert("E-mail com as divergências enviado com sucesso !! ")
	Else
		MsgStop("E-mail com as divergências não enviado !! Por favor, informar a Compras as divergências ocorridas.")
	EndIf
	
EndIf

//Restaura areas
RestArea(aAreaF8)
RestArea(aAreaC7)
RestArea(aAreaB1)
RestArea(aAreaE4)
RestArea(aArea)

//msgbox("a103bloq fim")
/* 
//FR - Flavia Rocha - não encontra o SCR pq até este momento, não gravou
SCR->(DBSETORDER(1))
If SCR->(Dbseek(xFilial("SCR") + cNF + cSeriNF + cFornece + cLojaFor ))
	msgbox("A103BLOQ - encontrou SCR")
Else
	msgbox("A103BLOQ - sem SCR")
Endif
*/
//CHAMA A IMPRESSÃO DO BOLETIM DE ENTRADA
//U_ESTR008("SF1", SF1->(RECNO()) , 3, cNF, cSeriNF, cFornece, cLojaFor )
//NÃO ESTÁ FUNCIONANDO, VER DEPOIS O QUE OCORRE - FR 12/06/12

Return lRet    //lRet := .T. bloqueia a NF, se for .F., a NF já entra classificada

******************************
Static Function fD1_numCQ()
******************************

Local cQry 		:= "" 
Local cMax 	:= ""
Local cNumCQ := ""


cQry := " SELECT MAX(D1_NUMCQ) as NUMCQ "
cQry += " FROM " + RetSqlname("SD1") + " SD1 "
cQry += " WHERE D1_FILIAL = '" + xFilial("SD1") + "' "
Memowrite("c:\Temp\MAXd1CQ.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXD1") > 0
	DbSelectArea("MAXD1")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXD1" 

MAXD1->(DbGoTop())

While !MAXD1->(EOF())
    cMax := MAXD1->NUMCQ
	MAXD1->(DBSKIP())
Enddo

cNumCQ := Soma1(cMax,Len(cMax))

DbCloseArea("MAXD1")

Return(cNumCQ)


***************

Static Function EMAIL(cConhec,cSerie,cFornec,cLoja,nFrete,nSist)

***************

NFREPES:=0
NTXFIXA:=0
NADVALO:=0
NGRIS:=0
NADM:=0
NPEDAGI:=0
NSUFRAM:=0
NTDE:=0
NFLUVIA:=0


//
cMensagem:=' '
cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cMensagem+='<head> '
cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cMensagem+='<title>Untitled Document</title> '
cMensagem+='<style type="text/css"> '
cMensagem+='<!-- '
cMensagem+='.style7 {	font-family: Arial, Helvetica, sans-serif; '
cMensagem+='	font-size: 14px; '
cMensagem+='} '
cMensagem+='.style9 {	font-family: Arial, Helvetica, sans-serif; '
cMensagem+='	color: #FFFFFF;   '
cMensagem+='	font-size: 14px; '
cMensagem+='} '
cMensagem+='.style1 {font-family: Geneva, Arial, Helvetica, sans-serif} '
cMensagem+='.style11 {font-family: Arial, Helvetica, sans-serif; font-size: 14px; color: #FF0066; }
cMensagem+='-->  '
cMensagem+='</style> '
cMensagem+='</head>  '

cMensagem+='<body> '
cMensagem+='<p><a target="_blank" href="http://www.ravaembalagens.com.br"></a></p> '
cMensagem+='<p> '
cMensagem+='    <span class="style7">Segue abaixo informa&ccedil;&otilde;es do conhecimento de frete Bloqueado .</span></p> '
cMensagem+='<table width="941" height="48" border="1"> '
cMensagem+='  <tr> '
cMensagem+='    <td width="116" height="20" bgcolor="#00CC66"><span class="style9">N&ordm; Conchecimento </span></td> '
cMensagem+='    <td width="78" bgcolor="#00CC66"><span class="style9">Serie</span></td>  '
cMensagem+='    <td width="400" bgcolor="#00CC66"><span class="style9">Fornecedor</span></td>  '
cMensagem+='    <td width="73" bgcolor="#00CC66"><span class="style9">Loja </span></td>  '
cMensagem+='    <td width="143" bgcolor="#00CC66"><span class="style9">Valor do Frete </span></td> '
cMensagem+='    <td width="91" bgcolor="#00CC66"><span class="style9">Frete Sstema </span></td> '
cMensagem+='  </tr>  '
// 
cMensagem+='  <tr> '
cMensagem+='    <td height="20"><span class="style7">'+cConhec+'</span></td>  '
cMensagem+='    <td width="78"><span class="style7">'+cSerie+'</span></td>  '
cMensagem+='    <td width="400"><span class="style7">'+cFornec+' - '+ Posicione('SA2',1,xFilial("SA2")+cFornec,"A2_NOME" )+'</span></td>  '
cMensagem+='    <td width="73"><span class="style7">'+cloja+'</span></td> '
cMensagem+='    <td><span class="style7">'+transform(nFrete,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(nSist,'@E 999,999.99')+'</span></td> '
cMensagem+='  </tr> '
//
cMensagem+='</table> '
cMensagem+='<p>Conchecimento:</p> '
cMensagem+='<table width="946" height="48" border="1"> '
cMensagem+='  <tr> '
cMensagem+='    <td width="115" height="20" bgcolor="#00CC66"><span class="style9">Frete Peso </span></td> '
cMensagem+='    <td width="77" bgcolor="#00CC66"><span class="style9">Tx. Fixa </span></td> '
cMensagem+='    <td width="95" bgcolor="#00CC66"><span class="style9">Ad-Valoren</span></td>  '
cMensagem+='    <td width="74" bgcolor="#00CC66"><span class="style9">GRIS </span></td>  '
cMensagem+='    <td width="78" bgcolor="#00CC66"><span class="style9">Tx. Adm </span></td>  '
cMensagem+='    <td width="85" bgcolor="#00CC66"><span class="style9">Pedagio</span></td>  '
cMensagem+='    <td width="92" bgcolor="#00CC66"><span class="style9">Suframa</span></td>  '
cMensagem+='    <td width="108" bgcolor="#00CC66"><span class="style9">TDE</span></td>  '
cMensagem+='    <td width="929" bgcolor="#00CC66"><span class="style9">Fluvial</span></td> '
cMensagem+='  </tr>  '
// conche.
cMensagem+='  <tr> '
cMensagem+='    <td height="20"><span class="style7">'+transform(Z86->Z86_FREPES,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td width="77"><span class="style7">'+transform(Z86->Z86_TXFIXA,'@E 9,999.99')+'</span></td>  '
cMensagem+='    <td width="95"><span class="style7">'+transform(Z86->Z86_ADVALO,'@E 9,999,999.99')+'</span></td> '
cMensagem+='    <td width="74"><span class="style7">'+transform(Z86->Z86_GRIS,'@E 999,999.99')+'</span></td> '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_ADM,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_PEDAGI,'@E 999,999.99')+'</span></td> '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_SUFRAM,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_TDE,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_FLUVIA,'@E 9,999,999.99')+'</span></td> '
cMensagem+='  </tr>  '
//
cMensagem+='</table>  '
cMensagem+='<p>Sistema:</p> '
cMensagem+='<table width="1010" height="48" border="1"> '
cMensagem+='  <tr> '
cMensagem+='    <td width="95" bgcolor="#00CC66"><span class="style9">Nota</span></td>  '
cMensagem+='    <td width="132" height="20" bgcolor="#00CC66"><span class="style9">Frete Peso </span></td> '
cMensagem+='    <td width="76" bgcolor="#00CC66"><span class="style9">Tx. Fixa </span></td>  '
cMensagem+='    <td width="97" bgcolor="#00CC66"><span class="style9">Ad-Valoren</span></td> '
cMensagem+='    <td width="73" bgcolor="#00CC66"><span class="style9">GRIS </span></td>   '
cMensagem+='    <td width="77" bgcolor="#00CC66"><span class="style9">Tx. Adm </span></td> '
cMensagem+='    <td width="101" bgcolor="#00CC66"><span class="style9">Pedagio</span></td> '
cMensagem+='    <td width="101" bgcolor="#00CC66"><span class="style9">Suframa</span></td>  '
cMensagem+='    <td width="86" bgcolor="#00CC66"><span class="style9">TDE</span></td> '
cMensagem+='    <td width="108" bgcolor="#00CC66"><span class="style9">Fluvial</span></td> '
cMensagem+='  </tr> '
// sistema
aNotas:=Notas(cConhec)
For _x:=1 to len(aNotas)

	cMensagem+='  <tr> '
	cMensagem+='    <td><span class="style7">'+aNotas[_x][1]+'</span></td>  '
	cMensagem+='    <td height="20"><span class="style7">'+transform(aNotas[_x][4],'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td width="76"><span class="style7">'+transform(aNotas[_x][5],'@E 9,999.99')+'</span></td>  '
	cMensagem+='    <td width="97"><span class="style7">'+transform(aNotas[_x][6],'@E 9,999,999.99')+'</span></td>   '
	cMensagem+='    <td width="73"><span class="style7">'+transform(aNotas[_x][7],'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][8],'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][9],'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][10],'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][11],'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][14],'@E 9,999,999.99')+'</span></td> '
	cMensagem+='  </tr> '

	NFREPES+=aNotas[_x][4]
	NTXFIXA+=aNotas[_x][5]
	NADVALO+=aNotas[_x][6]
	NGRIS+=aNotas[_x][7]
	NADM+=aNotas[_x][8]
	NPEDAGI+=aNotas[_x][9]
	NSUFRAM+=aNotas[_x][10]
	NTDE+=aNotas[_x][11]
	NFLUVIA+=aNotas[_x][14]
	

next
// TOTAIS 
	cMensagem+='  <tr> '
	cMensagem+='    <td><span class="style7">'+'Total: '+'</span></td>  '	
	cMensagem+='    <td height="20"><span class='+iif(Z86->Z86_FREPES<>NFREPES,"style11","style7")+'>'+transform(NFREPES,'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td width="76"><span class='+iif(Z86->Z86_TXFIXA<>NTXFIXA,"style11","style7")+'>'+transform(NTXFIXA,'@E 9,999.99')+'</span></td>  '
	cMensagem+='    <td width="97"><span class='+iif(Z86->Z86_ADVALO<>NADVALO,"style11","style7")+'>'+transform(NADVALO,'@E 9,999,999.99')+'</span></td>   '
	cMensagem+='    <td width="73"><span class='+iif(Z86->Z86_GRIS<>NGRIS,"style11","style7")+'>'+transform(NGRIS,'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class='+iif(Z86->Z86_ADM<>NADM,"style11","style7")+'>'+transform(NADM,'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class='+iif(Z86->Z86_PEDAGI<>NPEDAGI,"style11","style7")+'>'+transform(NPEDAGI,'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class='+iif(Z86->Z86_SUFRAM<>NSUFRAM,"style11","style7")+'>'+transform(NSUFRAM,'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class='+iif(Z86->Z86_TDE<>NTDE,"style11","style7")+'>'+transform(NTDE,'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class='+iif(Z86->Z86_FLUVIA<>NFLUVIA,"style11","style7")+'>'+transform(NFLUVIA,'@E 9,999,999.99')+'</span></td> '
	cMensagem+='  </tr> '

//
//
cMensagem+='</table>  '
cMensagem+='<p></p> '
cMensagem+='<p>&nbsp;</p> '
cMensagem+='</body> '
cMensagem+='</html> '

// Teste
//cEmail   :="antonio@ravaembalagens.com.br"
cEmail   := "marcelo@ravaembalagens.com.br"
cEmail   += ";orley@ravaembalagens.com.br"
cEmail   += ";joao.emanuel@ravaembalagens.com.br"
cEmail   += ";logistica@ravaembalagens.com.br"

cAssunto := "Conhecimento de frete "+cConhec+ ' - Bloqueado.'

//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )

//
/*
oProcess:=TWFProcess():New("CONHEC","CONHEC")
oProcess:NewTask('Inicio',"\workflow\http\emp01\CONHEC.html")
oHtml   := oProcess:oHtml
 
oHtml:ValByName("cStatus",'Bloqueado' )

aadd( oHtml:ValByName("it.Conchec") ,cConhec )
aadd( oHtml:ValByName("it.Serie" ) , cSerie  )
aadd( oHtml:ValByName("it.Fornec" ) , cFornec+' - '+ Posicione('SA2',1,xFilial("SA2")+cFornec,"A2_NOME" ) )
aadd( oHtml:ValByName("it.Loja" ) , cLoja  )
aadd( oHtml:ValByName("it.Frete" ) , transform(nFrete,'@E 999,999.99')  )
aadd( oHtml:ValByName("it.Sistema" ) , transform(nSist,'@E 999,999.99')  )

_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)
oProcess:cTo := "antonio@ravaembalagens.com.br"
//oProcess:cTo := "orley.blasio@ravaembalagens.com.br;marcelo@ravaembalagens.com.br"
subj	:= "Conhecimento de frete "+cConhec+ ' - Bloqueado.'
oProcess:cSubject  := subj
oProcess:Start()
WfSendMail()
oProcess:Finish()
*/
Return 


***************

Static Function Notas(cConhe)

***************

Local cQry:=''
LOCAL aRet:={}

cQry:="SELECT *  "
cQry+="FROM  " + RetSqlName("Z87") + " Z87 "
cQry+="WHERE  Z87_CODCON='"+cConhe+"'"
cQry+="AND Z87.D_E_L_E_T_ = ''  "

TCQUERY cQry NEW ALIAS 'TMPY'

if TMPY->(!EOF())
	Do While  TMPY->(!EOF())
	Aadd( aRet, { TMPY->Z87_NOTA,TMPY->Z87_VALOR,TMPY->Z87_FRETE,TMPY->Z87_FREPES,TMPY->Z87_TXFIXA,TMPY->Z87_ADVALO,TMPY->Z87_GRIS,TMPY->Z87_ADM,TMPY->Z87_PEDAGI,TMPY->Z87_SUFRAM,TMPY->Z87_TDE,TMPY->Z87_ICMS,TMPY->Z87_FSICMS,TMPY->Z87_FLUVIA} )
	TMPY->(DBSKIP())
	EndDo
ELSE
    Aadd( aRet, { "",0,0,0,0,0,0,0,0,0,0,0,0} )
ENDIF
TMPY->(DBCLOSEAREA())

Return aRet

***************

Static Function fValFret(NFDIFRE,SEDIFRE,TRANSP,LOJTRAN,DTDIGIT,cProd)

***************
Local cQry:=''
LOCAL nRet:=0

If Select('SD1X') > 0
	DbSelectArea('SD1X')
	SD1X->(DbCloseArea())	
EndIf

cQry:="SELECT SUM(D1_TOTAL) D1_TOTAL  FROM " + RetSqlName("SD1") + " SD1 "
cQry+="WHERE "
cQry+="D1_COD='"+cProd+"' "
cQry+="AND D1_DTDIGIT ='"+DTOS(DTDIGIT)+"'  " 
cQry+="AND D1_TIPO='C'  "
cQry+="AND D1_FILIAL='"+XFILIAL('SD1')+"'  "    
cQry+="AND D1_DOC='"+NFDIFRE+"'  "    
cQry+="AND D1_SERIE='"+SEDIFRE+"'  " 
cQry+="AND D1_FORNECE='"+TRANSP+"'  "
cQry+="AND D1_LOJA='"+LOJTRAN+"' "     
cQry+="AND SD1.D_E_L_E_T_='' "

TCQUERY cQry NEW ALIAS 'SD1X'

Do While SD1X->(!eof())
   nRet+=SD1X->D1_TOTAL
   SD1X->(DbSkip())
EndDo

SD1X->(dbclosearea())

Return nRet


***************

Static Function fTotPc(cPed)

***************
Local cQry:=''
LOCAL nRet:=0

If Select('SC7X') > 0
	DbSelectArea('SC7X')
	SC7X->(DbCloseArea())	
EndIf

cQry:="SELECT "
cQry+="SUM(C7_TOTAL-C7_VLDESC)  TOTAL "
cQry+="FROM " + RetSqlName("SC7") + "  SC7 "
cQry+="WHERE C7_NUM='"+cPed+"' "
cQry+="AND C7_FILIAL='"+xfilial('SC7')+"' "
cQry+="AND SC7.D_E_L_E_T_='' "

TCQUERY cQry NEW ALIAS 'SC7X'

Do While SC7X->(!eof())
   nRet:=SC7X->TOTAL
   SC7X->(DbSkip())
EndDo

SC7X->(dbclosearea())

Return nRet

