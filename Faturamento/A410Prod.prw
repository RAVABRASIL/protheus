#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'


*************

User Function A410Prod(cProduto,lCB)

*************

// Nome da funcao original: A410Produto(cProduto,lCB)

Local aDadosCfo     := {}

Local lRetorno		:= .T.
Local lContinua		:= .T.
Local lReferencia	:= .F.
Local lDescSubst	:= .F.
Local lGrade		:= MaGrade()
Local lTabCli     := (SuperGetMv("MV_TABCENT",.F.,"2") == "1")

Local nPProduto		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPGrade		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_GRADE"})
Local nPItem		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nPQtdVen		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPPrcVen		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPOpcional	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPC"})
Local nPDescon		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nPContrat     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CONTRAT"})
Local nPItemCon     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMCON"})
Local nPLoteCtl     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
Local nPNumLote     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
Local nPEstFis      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TPESTR"})
Local nPEndPad      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENDPAD"})
Local nPLocal       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPTes         := GdFieldPos("C6_TES")
Local nCntFor     := 0 

Local nPrcTab		:= 0
Local nBytes := IIf(SuperGetMv("MV_CONSBAR")>Len(SB1->B1_COD),Len(SB1->B1_COD),SuperGetMv("MV_CONSBAR") )

Local cProdRef		:= ""
Local cCFOP			:= Space(Len(SC6->C6_CF))
Local cDescricao	:= ""                                      
Local cCliTab     := ""
Local cLojaTab    := ""

Local cEstado		:= SuperGetMv("MV_ESTADO")
// Indica se o preco unitario sera arredondado em 0 casas decimais ou nao. Se .T. respeita MV_CENT (Apenas Chile).
Local lPrcDec   := SuperGetMV("MV_PRCDEC",,.F.)

If cPaisLoc == "BRA"
	lDescSubst	:= IF(mv_par02==1,.T.,.F.)  //mv_par02 parametro para deduzir ou nao a Subst. Trib.
EndIf

mv_par01 := If(ValType(mv_par01)==NIL.or.ValType(mv_par01)!="N",1,mv_par01)
mv_par02 := If(ValType(mv_par02)==NIL.or.ValType(mv_par02)!="N",1,mv_par02)

DEFAULT lCb	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Compatibiliza a Entrada Via Codigo de Barra com a Entrada via getdados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lCB )
	dbSelectArea("SB1")
	dbSetOrder(1)
	If ( MsSeek(xFilial("SB1")+Substr(aCols[Len(aCols)][nPProduto],1,nBytes),.F.) )
		cProduto := SB1->B1_COD
	Else
		Help(" ",1,"C6_PRODUTO")
		Return .F.
	EndIf
	n := Len(aCols)
Else
	cProduto := IIF(cProduto == Nil,&(ReadVar()),cProduto)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Produto foi Alterado                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !( Type("l410Auto") != "U" .And. l410Auto )
	If ( nPOpcional > 0 )
		If ( Empty(aCols[n][nPOpcional]) )
			If ( RTrim(aCols[n][nPProduto]) == RTrim(cProduto) .And. !lCB)
				lContinua := .F.
			EndIf
		EndIf
	Else
		If ( RTrim(aCols[n][nPProduto]) == RTrim(cProduto) .And. !lCB)
			lContinua := .F.
		EndIf
	EndIf
EndIf
cProdRef := cProduto
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a grade esta ativa e se o produto digitado eh uma referencia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua .And. lGrade )
	lReferencia := MatGrdPrrf(@cProdRef)
	If ( lReferencia )
		If ( M->C5_TIPO $ "D" )
			Help(" ",1,"A410GRADEV")
			lContinua := .F.
			lRetorno	 := .T.
		EndIf
		If ( nPGrade > 0 )
			aCols[n][nPGrade] := "S"
			lReferencia := .T.
		EndIf
	Else
		If ( nPGrade > 0 )
			aCols[n][nPGrade] := "N"
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o AcolsGrade e o AheadGrade para este item     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	If FindFunction("MsMatGrade") .And. IsAtNewGrd()
		oGrade:MontaGrade(n,cProdRef,.T.,,lReferencia) 
	Else
		MatGrdMont(n,cProdRef,.T.)
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza os Opcionais                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lCB .And. !( Type("l410Auto") != "U" .And. l410Auto ) .And. nPOpcional > 0
	SeleOpc(2,,,,,aCols[n][nPOpcional])
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificar se o Produto eh valido                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
	dbSelectArea("SB1")
	dbSetOrder(1)
	If ( !MsSeek(xFilial("SB1")+cProdRef,.F.) )
		Help(" ",1,"C6_PRODUTO")
		lContinua := .F.
		lRetorno  := .F.
	Else
		If !lReferencia .And. !RegistroOk("SB1")	
			lContinua := .F.
			lRetorno  := .F.
		Endif	
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checar se este item do pedido nao foi faturado total -³
//³mente ou parcialmente                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua .And. ALTERA )
	dbSelectArea("SC6")
	dbSetOrder(1)
	If ( MsSeek(xFilial("SC6")+M->C5_NUM+aCols[n][nPItem]+aCols[n][nPProduto]) )
		If ( SC6->C6_QTDENT != 0  .And. cProduto != aCols[n][nPProduto] .And. !lCB )
			Help(" ",1,"A410ITEMFT")
			lRetorno 	:= .F.
			lContinua 	:= .F.
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checar se este item do pedido esta amarrado com       ³
//³alguma Ordem de Producao                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua .And. ALTERA )
	dbSelectArea("SC6")
	dbSetOrder(1)
	If ( MsSeek(xFilial("SC6")+M->C5_NUM+aCols[n][nPItem]+aCols[n][nPProduto]) )
		If ( SC6->C6_OP == "01" )
			If (SuperGetMV("MV_ALTPVOP") == "N")
				Help(" ",1,"A410TEMOP")
				lRetorno 	:= .F.
				lContinua 	:= .F.
			EndIf
		EndIf
		If ( SC6->C6_OP == "05" )
			If (SuperGetMV("MV_ALTPVOP") == "N")
			   //	Aviso(STR0038,STR0039,{STR0040}) //"Atencao!"###"Este item foi marcado para gerar uma Ordem de Producao mas nao gerou, pois havia saldo disponivel em estoque. Este Pedido de Venda ja comprometeu o saldo necessario."###'Ok'
			   Aviso("Atencao!","Este item foi marcado para gerar uma Ordem de Producao mas nao gerou, pois havia saldo disponivel em estoque. Este Pedido de Venda ja comprometeu o saldo necessario.",{'Ok'}) 
			EndIf
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o contrato de parceria                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPContrat > 0 .And. nPItemCon > 0
	dbSelectArea("ADB")
	dbSetOrder(1)
	If MsSeek(xFilial("ADB")+aCols[N][nPContrat]+aCols[N][nPItemCon])
		If ADB->ADB_CODPRO <> M->C6_PRODUTO
			aCols[n][nPContrat] := Space(Len(aCols[n][nPContrat]))
			aCols[n][nPItemCon] := Space(Len(aCols[n][nPItemCon]))
		EndIf		
	Else
		aCols[n][nPContrat] := Space(Len(aCols[n][nPContrat]))
		aCols[n][nPItemCon] := Space(Len(aCols[n][nPItemCon]))
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os Opcionais e a Tabela de Precos           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lContinua )
	
	dbSelectArea(IIF(M->C5_TIPO$"DB","SA2","SA1"))
	dbSetOrder(1)
	MsSeek(xFilial()+IIf(!Empty(M->C5_CLIENT),M->C5_CLIENT,M->C5_CLIENTE)+M->C5_LOJAENT)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionar o TES para calcular o CFOP                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF4")
	dbSetOrder(1)
//alterado por antonio 
//	If ( MsSeek(xFilial()+RetFldProd(SB1->B1_COD,"B1_TS"),.F.) )
	If ( MsSeek(xFilial()+aCols[n][nPTes],.F.) )
		if cPaisLoc=="BRA"

		 	Aadd(aDadosCfo,{"OPERNF","S"})
		 	Aadd(aDadosCfo,{"TPCLIFOR",M->C5_TIPOCLI})
		 	Aadd(aDadosCfo,{"UFDEST",Iif(M->C5_TIPO$"DB", SA2->A2_EST,SA1->A1_EST)})
		 	Aadd(aDadosCfo,{"INSCR", If(M->C5_TIPO$"DB", SA2->A2_INSCR,SA1->A1_INSCR)})
			cCfop := MaFisCfo(,SF4->F4_CF,aDadosCfo)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza CFO de devido a nao correspondencia do CFO estadual  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Left(cCfop,4) == "6405"
				cCfop := "6404"+SubStr(cCfop,5,Len(cCfop)-4)
			Endif	

			
		Else
			cCfop:=SF4->F4_CF
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trazer descricao do Produto                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA7")
	dbSetOrder(1)
	If ( MsSeek(xFilial("SA7")+IIf(!Empty(M->C5_CLIENT),M->C5_CLIENT,M->C5_CLIENTE)+M->C5_LOJAENT+cProdRef,.F.) ) .And. !Empty(SA7->A7_DESCCLI)
		cDescricao := SA7->A7_DESCCLI
	Else
		If ( lReferencia )   
			If FindFunction("MsMatGrade") .And. IsAtNewGrd()
				cDescricao := oGrade:GetDescProd(cProdRef) 
			Else
				dbSelectArea("SB4")
				dbSetOrder(1)
				If ( MsSeek(xFilial("SB4")+cProdRef) )
					cDescricao := SB4->B4_DESC
				EndIf  
			EndIf	
		Else
			cDescricao := SB1->B1_DESC
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializar os campos a partir do produto digitado.                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
    /* comentado por antonio 
	If nPTes > 0
		aCols[n][nPTes] := RetFldProd(SB1->B1_COD,"B1_TS")
	Endif	
    */ 

	If lTabCli
		Do Case
			Case !Empty(M->C5_LOJAENT) .And. !Empty(M->C5_CLIENT)
				cCliTab   := M->C5_CLIENT
				cLojaTab  := M->C5_LOJAENT
			Case Empty(M->C5_CLIENT) 
				cCliTab   := M->C5_CLIENTE
				cLojaTab  := M->C5_LOJAENT
			OtherWise
				cCliTab   := M->C5_CLIENTE
				cLojaTab  := M->C5_LOJACLI
		EndCase					
	Else
		cCliTab   := M->C5_CLIENTE
		cLojaTab  := M->C5_LOJACLI
	Endif
	
	
	For nCntFor :=1 To Len(aHeader)
		Do Case
		Case AllTrim(aHeader[nCntFor][2]) == "C6_UM"
			aCols[n][nCntFor] := SB1->B1_UM
		Case AllTrim(aHeader[nCntFor][2]) == "C6_LOCAL"
			aCols[n][nCntFor] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
		Case AllTrim(aHeader[nCntFor][2]) == "C6_DESCRI"
			aCols[n][nCntFor] := PadR(cDescricao,TamSx3("C6_DESCRI")[1])
		Case AllTrim(aHeader[nCntFor][2]) == "C6_SEGUM"
			aCols[n][nCntFor] := SB1->B1_SEGUM
		Case AllTrim(aHeader[nCntFor][2]) == "C6_PRUNIT"
			nPrcTab:=A410Tabela(	cProdRef,;
									M->C5_TABELA,;
									n,;
									aCols[n][nPQtdVen],;
									cCliTab,;
									cLojaTab,;
									If(nPLoteCtl>0,aCols[n][nPLoteCtl],""),;
									If(nPNumLote>0,aCols[n][nPNumLote],""),;
									NIL,;
									NIL,;
									.T.)				
			aCols[n][nCntFor] := A410Arred(nPrcTab,"C6_PRUNIT")
		Case AllTrim(aHeader[nCntFor][2]) == "C6_PRCVEN"
			nPrcTab:=A410Tabela(	cProdRef,;
									M->C5_TABELA,;
									n,;
									aCols[n][nPQtdVen],;
									cCliTab,;
									cLojaTab,;
									If(nPLoteCtl>0,aCols[n][nPLoteCtl],""),;
									If(nPNumLote>0,aCols[n][nPNumLote],""),;
									NIL,;
									NIL,;
									.F.)				
			If ( !lDescSubst)
				aCols[n][nCntFor] := A410Arred(FtDescCab(nPrcTab,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN",If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
			Else
				aCols[n][nCntFor] := FtDescCab(nPrcTab,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4},If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))
			EndIf
		Case AllTrim(aHeader[nCntFor][2]) == "C6_UNSVEN"
			A410SegUm(.T.)
		Case AllTrim(aHeader[nCntFor][2]) == "C6_CF"
			aCols[n][nCntFor] := cCFOP
		Case AllTrim(aHeader[nCntFor][2]) == "C6_COMIS1"
			aCols[n][nCntFor] := SB1->B1_COMIS
		Case AllTrim(aHeader[nCntFor][2]) == "C6_QTDLIB"
			aCols[n][nCntFor] := 0
		Case AllTrim(aHeader[nCntFor][2]) == "C6_QTDVEN"
			aCols[n][nCntFor] := If(lCB,aCols[n][nPQtdVen],0)
		Case AllTrim(aHeader[nCntFor][2]) == "C6_VALOR"
			aCols[n][nCntFor] := A410Arred(aCols[n,nPPrcVen]*aCols[n,nPQtdVen],"C6_VALOR")
		Case AllTrim(aHeader[nCntFor][2]) == "C6_VALDESC"
			aCols[n][nCntFor] := 0
		Case AllTrim(aHeader[nCntFor][2]) == "C6_DESCONT"
			aCols[n][nCntFor] := 0
		Case AllTrim(aHeader[nCntFor][2]) == "C6_NUMLOTE"
			aCols[n][nCntFor] := CriaVar("C6_NUMLOTE")
		Case AllTrim(aHeader[nCntFor][2]) == "C6_LOTECTL"
			aCols[n][nCntFor] := CriaVar("C6_LOTECTL")
		Case AllTrim(aHeader[nCntFor][2]) == "C6_CODISS"
			aCols[n][nCntFor] := SB1->B1_CODISS
		Case AllTrim(aHeader[nCntFor][2]) == "C6_NFORI"
			aCols[n][nCntFor] := CriaVar("C6_NFORI")
		Case AllTrim(aHeader[nCntFor][2]) == "C6_SERIORI"
			aCols[n][nCntFor] := CriaVar("C6_SERIORI")
		Case AllTrim(aHeader[nCntFor][2]) == "C6_ITEMORI"
			aCols[n][nCntFor] := CriaVar("C6_ITEMORI")
		EndCase
	Next nCntFor
	If ( MV_PAR01 == 1 .And. lCB )
		MaIniLiber(M->C5_NUM,aCols[n][nPQtdVen],n,lCB)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializar os campos de enderecamento do WMS para uso na carga         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(M->C5_TRANSP)
		SA4->(DbSetOrder(1))
		If SA4->(MsSeek(xFilial("SA4")+M->C5_TRANSP))
			If !Empty(SA4->A4_ESTFIS) .And. !Empty(SA4->A4_ENDPAD) .And. !Empty(SA4->A4_LOCAL) .And.;
				nPEndPad > 0 .And. nPEstFis > 0 .And. nPLocal > 0			
				aCols[n][nPEstFis] := SA4->A4_ESTFIS
				aCols[n][nPEndPad] := SA4->A4_ENDPAD
				aCols[n][nPLocal]  := SA4->A4_LOCAL
			Endif
		Endif
	Endif							
	
EndIf                                                     

Return(lRetorno)
