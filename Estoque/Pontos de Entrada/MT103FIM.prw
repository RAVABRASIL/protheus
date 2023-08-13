
/*
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//PROGRAMA: M103FIM - Pto entrada após gravação da NOTA FISCAL ENTRADA
//OBJETIVO: Gravar o Centro de Custo da SD1 na SE2 -> contas a pagar
//Autoria : Flávia Rocha
//Data    : 12/08/12
//Chamado :	002603
//Solicitado por: Edna
//Boa tarde PROBLEMA: Ausência de centro de custos na importação do contas a pagar (despesas)
 para o contas a pagar da contabilidade. 
 SOLICITAMOS: O siga tornar obrigatório no ato da realização da despesa o u so do centro de custo

//Observações: ao gravar o centro de custo da NF Entrada no Contas a pagar, a solicitação acima foi atendida, pois
//o LP 530.01 orienta capturar o campo E2_CCD (Centro Custo débito) na contabilização do Contas a Pagar 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

***************************
User Function MT103FIM
***************************

Local cNF := SD1->D1_DOC
Local cSerie := SD1->D1_SERIE 
Local cFornece:= SD1->D1_FORNECE
Local cLojaFor:= SD1->D1_LOJA
Local cEspecie:= SF1->F1_ESPECIE

    //Alert("MT103FIM - " + cNF + '/' + cSerie + '/' + cEspecie)                
////////////////////////////////////////////////////////////////
////TRATAMENTO PARA GRAVAR O CENTRO DE CUSTO NO CONTAS A PAGAR
////////////////////////////////////////////////////////////////

If Inclui

	DbSelectArea("SD1")
	SD1->(Dbsetorder(1))  //D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
	SD1->(Dbgotop())
	If SD1->(Dbseek(xFilial("SD1") + cNF + cSerie ))
		While SD1->D1_FILIAL == xFilial("SD1") .And. Alltrim(SD1->D1_DOC) == Alltrim(cNF) .and. Alltrim(SD1->D1_SERIE) == Alltrim(cSerie)
			SE2->(Dbsetorder(6))     //E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
			If SE2->(Dbseek(xFilial("SE2") + cFornece + cLojaFor + cSerie + cNF ))
				If Alltrim(SE2->E2_TIPO) = Alltrim(cEspecie)
					Reclock("SE2", .F.)
					SE2->E2_CCD := SD1->D1_CC    //centro custo débito da nf para o contas a pagar
					//alert("gravou CCd no E2")
					SE2->(MsUnlock())
				Endif
			Endif
			SD1->(DBSKIP())
		Enddo
	Endif

Endif
		
Return
