

User Function MyMata120()

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local cDoc   := ""
	Local lOk    := .T.
	Local nX     := 0
	Local nY     := 0

	PRIVATE lMsErroAuto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ConOut(Repl("-",80))
	ConOut(PadC("Rotina Automática para o Pedido de Compras",80))

	PREPARE ENVIRONMENT EMPRESA "09" FILIAL "01" MODULO "COM"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verificacao do ambiente para teste                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SB1")
	dbSetOrder(1)

	If !SB1->(MsSeek(xFilial("SB1")+"1"))

		lOk := .F.	ConOut("Cadastrar produto: 1")

	EndIf

	dbSelectArea("SF4")
	dbSetOrder(1)

	If !SF4->(MsSeek(xFilial("SF4")+"001"))

		lOk := .F.

		ConOut("Cadastrar TES: 001")

	EndIf

	dbSelectArea("SE4")
	dbSetOrder(1)

	If !SE4->(MsSeek(xFilial("SE4")+"001"))

		lOk := .F.
		ConOut("Cadastrar condicao de pagamento: 001")

	EndIf

	dbSelectArea("SA2")
	dbSetOrder(1)

	If !SA2->(MsSeek(xFilial("SA2")+"1"))

		lOk := .F.	ConOut("Cadastrar fornecedor: 1")

	EndIf


	If lOk

		ConOut("Inicio: "+Time())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Inclusao                                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dbSelectArea("SC7")
		dbSetOrder(1)

		MsSeek(xFilial("SC7")+"zzzzzz",.T.)

		dbSkip(-1)	cDoc := SC7->C7_NUM

		aCabec := {}	aItens := {}

		If Empty(cDoc)

			cDoc := StrZero(1,Len(SC7->C7_NUM))
			
		Else		
			
			cDoc := Soma1(cDoc)

		EndIf

		aadd(aCabec,{"C7_NUM"     ,cDoc})
		aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
		aadd(aCabec,{"C7_FORNECE" ,"1     "})
		aadd(aCabec,{"C7_LOJA"    ,"01"})
		aadd(aCabec,{"C7_COND"    ,"001"})
		aadd(aCabec,{"C7_CONTATO" ,"AUTO"})
		aadd(aCabec,{"C7_FILENT"  ,cFilAnt})
		aadd(aCabec,{"C7_MOEDA"   ,1})
		aadd(aCabec,{"C7_TXMOEDA" ,1})
		aadd(aCabec,{"C7_FRETE"   ,0})
		aadd(aCabec,{"C7_DESPESA" ,0})
		aadd(aCabec,{"C7_SEGURO"  ,0})
		aadd(aCabec,{"C7_DESC1"   ,0})
		aadd(aCabec,{"C7_DESC2"   ,0})
		aadd(aCabec,{"C7_DESC3"   ,0})
		aadd(aCabec,{"C7_MSG"     ,""})
		aadd(aCabec,{"C7_REAJUST" ,""})

		For nX:= 1 to 2

			aLinha := {}
			aadd(aLinha,{"C7_ITEM"   ,StrZero(nX,len(SC7->C7_ITEM)),Nil})
			aadd(aLinha,{"C7_PRODUTO"  ,"5",Nil})
			aadd(aLinha,{"C7_QUANT",1,Nil})
			aadd(aLinha,{"C7_PRECO",100,Nil})
			aadd(aLinha,{"C7_TES","001",Nil})
			aadd(aItens,aLinha)

			For nY:=1 to 2

				xRateio:= {}

				aadd(xRateio,{"CH_ITEMPD"	,StrZero(nX,len(SC7->C7_ITEM)),Nil})
				aadd(xRateio,{"CH_ITEM"		,StrZero(nY,len(SCH->CH_ITEM)),Nil})
				aadd(xRateio,{"CH_PERC"		,IIF(ny==1,30,70),Nil})
				aadd(xRateio,{"CH_CC"		,IIF(NY==2,"1","2"),Nil})
				aadd(xRateio,{"CH_CONTA"	,'',Nil})
				aadd(xRateio,{"CH_ITEMCTA"	,'',Nil})
				aadd(xRateio,{"CH_CLVL"		,'',Nil})
				aadd(aRateio,xRateio)

			Next nY

		Next nX

		MSExecAuto({|v,x,y,z,a,b| MATA120(v,x,y,z,a,b)},1,aCabec,aItens,3,,aRateio)

		If !lMsErroAuto

			ConOut("Incluido com sucesso! "+cDoc)

		Else

			ConOut("Erro na inclusao!")

		EndIf

		ConOut("Fim  : "+Time())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Alteração     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aCabec := {}  	
		aItens := {}

		aadd(aCabec,{"C7_NUM"     ,cDoc})
		aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
		aadd(aCabec,{"C7_FORNECE" ,"1     "})
		aadd(aCabec,{"C7_LOJA"    ,"01"})
		aadd(aCabec,{"C7_COND"    ,"001"})
		aadd(aCabec,{"C7_CONTATO" ,"Paula"})
		aadd(aCabec,{"C7_FILENT"  ,cFilAnt})
		aadd(aCabec,{"C7_MOEDA"   ,1})
		aadd(aCabec,{"C7_TXMOEDA" ,1})
		aadd(aCabec,{"C7_FRETE"   ,0})
		aadd(aCabec,{"C7_DESPESA" ,0})
		aadd(aCabec,{"C7_SEGURO"  ,0})
		aadd(aCabec,{"C7_DESC1"   ,0})
		aadd(aCabec,{"C7_DESC2"   ,0})
		aadd(aCabec,{"C7_DESC3"   ,0})
		aadd(aCabec,{"C7_MSG"     ,""})
		aadd(aCabec,{"C7_REAJUST" ,""})

		For nX := 1 To 2		aLinha := {}

			aadd(aLinha,{"LINPOS","C7_ITEM",StrZero(nX,len(SC7->C7_ITEM)),Nil})
			aadd(aLinha,{"AUTDELETA","N",Nil})
			aadd(aLinha,{"C7_PRODUTO"  ,"5",Nil})
			aadd(aLinha,{"C7_QUANT",5,Nil})
			aadd(aLinha,{"C7_PRECO",135,Nil})
			aadd(aLinha,{"C7_TES","001",Nil})
			aadd(aItens,aLinha)	Next nX

			MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabec,aItens,4)

			If !lMsErroAuto
				ConOut("Alterado com sucesso!" +cDoc)
			Else
				ConOut("Erro na alteração!")
			EndIf
			ConOut("Fim  : "+Time())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de exclusao                                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			ConOut(PadC("Teste de exclusao",80))
			ConOut("Inicio: "+Time())
			MATA120(1,aCabec,aItens,5)
			If !lMsErroAuto
				ConOut("Excluído com sucesso! "+cDoc)
			Else
				ConOut("Erro na exclusao!")
			EndIf	ConOut("Fim  : "+Time())
			ConOut(Repl("-",80))EndIf
			RESET ENVIRONMENT
			Return(.T.)
