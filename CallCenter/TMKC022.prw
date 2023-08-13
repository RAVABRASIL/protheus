#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

/*
////////////////////////////////////////////////////////////////////////////////////////////
//Programa: TMKC022 - Grava diariamente o histórico dos totais de ligações do Call Center
//Objetivo: Apurar o índice de cumprimento das ligações tipo "Feedback"
//Autoria : Flávia Rocha
//Data    : 03/05/2010.
////////////////////////////////////////////////////////////////////////////////////////////
*/

**************************
User Function TMKC022F()
**************************

////////////ATUALIZA HISTORICO DE FEEDBACKS, grava diariamente no ZU8

// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"  

	Feed22()
	
// Habilitar somente para Schedule
Reset environment 
	
////TENTEI CHAMAR DE NOVO MAS NÃO DEU CERTO, TEREI Q FAZER OUTRO PROG 
/// ESPECÍFICO PARA A FILIAL 03-CAIXAS

// Habilitar somente para Schedule
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"  

//	Feed22()	

// Habilitar somente para Schedule
//Reset environment
	
Return


**************************
Static Function Feed22()
**************************


Local cQuery := "" 
Local LF      	:= CHR(13)+CHR(10) 
Local lJatem := .F. 

Local dData1 := CtoD("  /  /    ")
Local dData2 := CtoD("  /  /    ") 
Local dDatahist := CtoD("  /  /    ")
Local nTotLig := 0
Local nNaoRealiz := 0
Local nOcupado
Local nErro
Local nFalha 
Local nSemLin

////SELECIONA TODAS AS LIGAÇÕES DO SU6
/////ligações somente de feedback (U6_ORIGEM = '3')

dData1 := (dDatabase - 30)
//dData1 := dDatabase
dData2 := dDatabase

While dData1 <= dData2

	cQuery := " SELECT COUNT(*) AS TOTAL_LIG " + LF    	  
	cQuery += " FROM " + LF
	cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
	cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
	cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
	cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF
	
	cQuery += " WHERE U6_DATA = '" + Dtos(dData1) + "' " + LF
	cQuery += " and U4_DATA = '" + Dtos(dData1) + "' " + LF
	
	cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
	
	cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
	cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
	cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
	cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
	
	cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
	cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
	cQuery += " AND U6_ORIGEM = '3'"+LF	//SOMENTE FEEDBACK
	cQuery += " AND U6_TIPO = '5'"+LF
	
	cQuery += " AND U6_NFISCAL = F2_DOC " + LF
	cQuery += " AND U6_SERINF = F2_SERIE " + LF
	
	
	//cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
	
	cQuery += " AND U6_NFISCAL <> ''"+LF
	//cQuery += " AND U6_LIGPROB <> 'S'  "+LF
	//cQuery += " AND U6_RETENC <> 'S'  "+LF         //QUE NÃO SEJAM DE NOTAS COM RETENÇÃO
	//cQuery += " AND U6_DTAGCLI = '' "+LF           //QUE NÃO SEJAM DE NOTAS COM AGENDAMENTO 
	//cQuery += " AND RTRIM(F2_RETENC) <> 'S'  "+LF
	//cQuery += " AND RTRIM(F2_DTAGCLI) = '' "+LF
	//cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
	
	//MemoWrite("C:\Temp\TOT_LIG.sql", cQuery) 
	
	If Select("TOT") > 0
		DbSelectArea("TOT")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TOT"
	
	TOT->( DBGoTop() )
	
	/*
	Local nOcupado
	Local nErro
	Local nFalha 
	Local nSemLin
	Local nRealiz
	Local nTotLig
	Local nNaoRealiz
	
	*/
	
	
	Do While !TOT->( Eof() )
		nTotLig := TOT->TOTAL_LIG
		TOT->(Dbskip())
	Enddo
	
	DbSelectArea("TOT")
	DbCloseArea()
		
	//já tenho o total de ligações 
	//agora preciso capturar deste total, o que não foi realizado, 
	//e dentro do que não foi realizado, se foi por motivo normal (operador) ou fora do que o operador pudesse
	//realizar, ex.: ocupado (não entra na contagem)
	cQuery := " SELECT Count(*) AS NAOREALIZ " + LF //U6_LISTA , U6_DATA, U6_CODENT, U6_NFISCAL, A1_NOME " + LF    	  
	cQuery += " FROM " + LF
	cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
	cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
	cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
	cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF   
	
	cQuery += " WHERE U6_DATA = '" + Dtos(dData1) + "' " + LF
	cQuery += " and U4_DATA = '" + Dtos(dData1) + "' " + LF
	
	cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
	
	cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
	
	cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
	cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
	cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
	cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
	cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
	
	cQuery += " AND U6_ORIGEM = '3'"+LF	//SOMENTE FEEDBACK
	cQuery += " AND U6_TIPO = '5'"+LF
	
	cQuery += " AND U6_NFISCAL = F2_DOC " + LF
	cQuery += " AND U6_SERINF = F2_SERIE " + LF
	
	
	cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
	cQuery += " AND U4_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
	
	cQuery += " AND U6_NFISCAL <> ''"+LF
	cQuery += " AND U6_LIGPROB <> 'S'  "+LF
	cQuery += " AND U6_RETENC <> 'S'  "+LF
	cQuery += " AND U6_DTAGCLI = '' "+LF
	
	//cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
	//MemoWrite("C:\Temp\nao_lig.sql",cQuery )
	
	If Select("NAOREA") > 0
		DbSelectArea("NAOREA")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "NAOREA"
	//TCSetField( 'TKR', "U6_DATA", "D" )
	//TCSetField( 'TKR', "U8_DATA", "D" )
	
	NAOREA->( DBGoTop() )
	
	nNaoRealiz := 0 
	
	Do While !NAOREA->( Eof() )        
	
		nNaoRealiz := NAOREA->NAOREALIZ
		NAOREA->(Dbskip())	 	  
	Enddo 
	DbSelectArea("NAOREA")
	DbCloseArea()
	
	///depois de ter o TOTAL DE LIGAÇÕES, e saber quantas não realizadas, vamos agora
	///verificar se nas não realizadas, foi registrado o motivo - SU6 relaciona na SU8
	cQuery := " SELECT U6_STATUS,U8_STATUS, " + LF  
	cQuery += " CASE WHEN U8_STATUS ='1' THEN 'OCUPADO'  " + LF  
	cQuery += " ELSE   " + LF  
	cQuery += " CASE WHEN U8_STATUS ='2' THEN 'ERRO' " + LF  
	cQuery += " ELSE  " + LF  
	cQuery += " CASE WHEN U8_STATUS = '3' THEN 'FALHA' " + LF  
	cQuery += " ELSE  " + LF  
	cQuery += " CASE WHEN U8_STATUS = '4' THEN 'SEM LINHA' " + LF  
	cQuery += " ELSE " + LF  
	cQuery += " CASE WHEN U8_STATUS = '5' THEN 'EXECUTADO' " + LF  
	cQuery += " ELSE " + LF  
	cQuery += " 'NAO REALIZADO' " + LF  
	cQuery += " END " + LF  
	cQuery += " END " + LF  
	cQuery += " END " + LF  
	cQuery += " END " + LF  
	cQuery += " END AS MOTIVO " + LF 
	 
	cQuery += " ,U6_LISTA, U6_DATA, U6_NFISCAL, U8_CRONUM, U8_DATA, U8_STATUS, U6_CODENT, A1_NOME " + LF    	  
	cQuery += " FROM " + LF
	 
	cQuery += " " + RetSqlName("SF2") + " SF2, "+LF
	cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
	cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
	cQuery += " " + RetSqlName("SU6") + " SU6 "+LF
	
	cQuery += " LEFT JOIN " + RetSqlName("SU8") + " SU8 " + LF
	cQuery += " ON SU6.U6_LISTA = SU8.U8_CRONUM AND SU8.D_E_L_E_T_ = '' AND SU8.U8_FILIAL = '" + xFilial("SU8") + "' " + LF
	cQuery += " AND SU6.U6_CODIGO = SU8.U8_CONTATO"+LF
	
	cQuery += " WHERE U6_DATA = '" + Dtos(dData1) + "' " + LF
	cQuery += " and U4_DATA = '" + Dtos(dData1) + "' " + LF
	
	cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
	
	cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
	cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
	cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
	cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
	
	cQuery += " AND U6_LISTA = U4_LISTA "+LF
	cQuery += " AND U6_NFISCAL = F2_DOC"+LF
	cQuery += " AND U6_SERINF = F2_SERIE"+LF
	cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
	
	cQuery += " AND U6_ORIGEM = '3'"+LF         ///origem = '3' -> FEEDBACK
	cQuery += " AND U6_TIPO = '5'"+LF          ///TIPO = '5' -> FEEDBACK
	
	cQuery += " AND U6_STATUS = '1'"+LF
	cQuery += " AND U4_STATUS = '1'"+LF
	
	cQuery += " AND U6_NFISCAL <> ''"+LF
	cQuery += " AND U6_LIGPROB <> 'S'  "+LF
	cQuery += " AND U6_RETENC <> 'S'  "+LF
	cQuery += " AND U6_DTAGCLI = '' "+LF
	//cQuery += " AND F2_RETENC <> 'S'  "+LF
	//cQuery += " AND F2_DTAGCLI = '' "+LF
	//cQuery += " AND U8_STATUS <> '1'"+LF
	//cQuery += " AND U8_STATUS <> '2'"+LF
	//cQuery += " AND U8_STATUS <> '3'"+LF
	//cQuery += " AND U8_STATUS <> '4'"+LF
	//cQuery += " AND U8_STATUS <> '5'"+LF
	
	cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
	//MemoWrite("C:\Temp\su8_motiv.sql", cQuery )
	
	If Select("SU8XX") > 0
		DbSelectArea("SU8XX")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "SU8XX"
	TCSetField( 'SU8XX', "U6_DATA", "D" )
	TCSetField( 'SU8XX', "U8_DATA", "D" )
	
	SU8XX->( DBGoTop() )
	
	nOcupado:= 0
	nErro   := 0
	nFalha  := 0
	nSemLin := 0
	nRealiz := 0 
	
	
	Do While !SU8XX->( Eof() )  	
	 	
	 	If SU8XX->U8_STATUS = '1'
	 		cU8Status := "Ocupado"
	 		nOcupado++
	 	Elseif SU8XX->U8_STATUS = '2'
	 		cU8Status := "Erro"
	 		nErro++
	 	Elseif SU8XX->U8_STATUS = '3'
	 		cU8Status := "Falha"
	 		nFalha++
	 	Elseif SU8XX->U8_STATUS = '4'
	 		cU8Status := "Sem Linha"
	 		nSemLin++
	 	//Case SU8XX->U8_STATUS = '5'
	 		//cU8Status := "Executado"
	 		//nRealiz++
	 	//Elseif SU8XX->U8_STATUS = '6'
	 	//	cU8Status := "Excluido"
	 	//Elseif SU8XX->U8_STATUS = '7'
	 	//	cU8Status := "Enviado"
	 	//Elseif SU8XX->U8_STATUS = '8'
	 	//	cU8Status := "Impresso"
	 	Else
	 		cU8Status := "Nao Realizado"
	 	Endif
	 	
	     
	  SU8XX->( DbSkip() )
	
	Enddo
	DbSelectArea("SU8XX")
	DbCloseArea()
	
	nNaoRealiz := nNaoRealiz - (nOcupado + nErro + nSemLin)			
	// AQUI FAZ O CÁLCULO, DENTRO DO QUE NÃO FOI REALIZADO,
	// SE FOI POR MOTIVO DE LINHA OCUPADA OU QQ OUTRO PROBLEMA DE ORDEM ACIMA DO QUE O OPERADOR PODE AGIR
	// QDO ISTO OCORRE, NÃO É CONTABILIZADO NO "NÃO REALIZADO"
	
	dDatahist := Dtos(dData1)
	////LOCALIZA NO HISTÓRICO SE JÁ EXISTE A ESTATÍSTICA NA DATA EM QUESTÃO
	cQuery := ""
	cQuery += " SELECT COUNT(ZU8_FILIAL) FROM " + RetSqlName("ZU8") + " ZU8 "+LF
	cQuery += " WHERE ZU8_TIPO = 'F' AND ZU8_DATA = '" + dDatahist + "' " +LF
	cQuery += " AND ZU8.D_E_L_E_T_ = '' " +LF
	cQuery += " AND ZU8.ZU8_FILIAL = '" + xFilial("ZU8") + "' " + LF
	
	If Select("ZZU8") > 0
		DbSelectArea("ZZU8")
		DbCloseArea()
	EndIf
	TCQUERY cQuery NEW ALIAS "ZZU8" 
	lJatem := !ZZU8->(Eof())
	
	ZZU8->(DbCloseArea())         
			
	If !lJatem			
		DbselectArea("ZU8")
		Reclock("ZU8",.T.)
		ZU8->ZU8_FILIAL := xFilial()
		ZU8->ZU8_TIPO   := "F"
		ZU8->ZU8_DATA   := dData1		
		ZU8->ZU8_TOTDIA := nTotLig    //nTotligacoes
		ZU8->ZU8_NAOLIG := nNaoRealiz //nQtligfora
		ZU8->ZU8_PORCEN := Round( ( (nNaoRealiz / nTotLig) * 100),2)		 //Round( ( (nQtligfora / nTotligacoes) * 100),2)		
		ZU8->(MSUNLOCK())
			    
		//MSGBOX("OK PARTE 2")
		//Else
		//Msgbox("Este histórico já existe!")
	Endif      
	
	//Msginfo("Processo finalizado")
	
	// Habilitar somente para Schedule
	//Reset environment
	
	dData1 := dData1 + 1

EndDo

Return

**************************
User Function TMKC022L()
**************************

// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"  

	List22() 
	
Reset Environment
	
// Habilitar somente para Schedule
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"  

//	List22()	
	
Return

*************************
Static Function List22() 
*************************

////////////ATUALIZA HISTORICO DE LISTA, grava diariamente no ZU8
////////////ATUALIZA HISTORICO DE FEEDBACKS, grava diariamente no ZU8

Local cQuery := "" 
Local LF      	:= CHR(13)+CHR(10) 
Local lJatem := .F. 

Local dData1 := CtoD("  /  /    ")
Local dData2 := CtoD("  /  /    ") 
Local dDatahist := CtoD("  /  /    ")
Local nTotLig := 0
Local nNaoRealiz := 0
Local nOcupado
Local nErro
Local nFalha 
Local nSemLin


////SELECIONA TODAS AS LIGAÇÕES DO SU6
/////ligações somente de feedback (U6_ORIGEM = '3')

dData1 := (dDatabase - 30)
//dData1 := dDatabase
dData2 := dDatabase

//inserido para refazer o passado.
//Solicitação do SR Viana
While dData1 <= dData2

	cQuery := " SELECT COUNT(*) AS TOTAL_LIG " + LF    	  
	cQuery += " FROM " + LF
	cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
	cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
	cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
	cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF
	
	cQuery += " WHERE U6_DATA = '" + Dtos(dData1) + "' " + LF
	cQuery += " and U4_DATA = '" + Dtos(dData1) + "' " + LF
	cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
	
	cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
	
	cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
	cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
	cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
	cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
	
	cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
	
	cQuery += " AND U6_ORIGEM = '1'"+LF	//SOMENTE LISTA
	
	cQuery += " AND U6_NFISCAL = F2_DOC " + LF
	cQuery += " AND U6_SERINF = F2_SERIE " + LF
	cQuery += " AND U6_TIPO = '1'"+LF		///SOMENTE LISTA
	
	//cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
	cQuery += " AND U6_NFISCAL <> ''"+LF
	//cQuery += " AND U6_LIGPROB <> 'S'  "+LF
	//cQuery += " AND U6_RETENC <> 'S'  "+LF         //QUE NÃO SEJAM DE NOTAS COM RETENÇÃO
	//cQuery += " AND U6_DTAGCLI = '' "+LF           //QUE NÃO SEJAM DE NOTAS COM AGENDAMENTO 
	//cQuery += " AND RTRIM(F2_RETENC) <> 'S'  "+LF
	//cQuery += " AND RTRIM(F2_DTAGCLI) = '' "+LF
	//cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
	
	//MemoWrite("C:\Temp\TOT_LIG.sql", cQuery) 
	
	If Select("TOT") > 0
		DbSelectArea("TOT")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TOT"
	
	TOT->( DBGoTop() )
	
	nTotLig := TOT->TOTAL_LIG
	
	DbSelectArea("TOT")
	DbCloseArea()
		
	//já tenho o total de ligações 
	//agora preciso capturar deste total, o que não foi realizado, 
	//e dentro do que não foi realizado, se foi por motivo normal (operador) ou fora do que o operador pudesse
	//realizar, ex.: ocupado (não entra na contagem)
	cQuery := " SELECT Count(*) AS NAOREALIZ " + LF //U6_LISTA , U6_DATA, U6_CODENT, U6_NFISCAL, A1_NOME " + LF    	  
	cQuery += " FROM " + LF
	cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
	cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
	cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
	cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF
	
	cQuery += " WHERE U6_DATA = '" + Dtos(dData1) + "' " + LF
	cQuery += " and U4_DATA = '" + Dtos(dData1) + "' " + LF
	cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
	
	cQuery += " AND SU6.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SU4.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
	
	cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
	cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
	cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
	cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
	cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
	
	cQuery += " AND U6_ORIGEM = '1'"+LF	//SOMENTE LISTA
	
	cQuery += " AND U6_NFISCAL = F2_DOC " + LF
	cQuery += " AND U6_SERINF = F2_SERIE " + LF
	cQuery += " AND U6_TIPO = '1'"+LF    ///SOMENTE LISTA
	
	cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
	cQuery += " AND U4_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
	
	cQuery += " AND U6_NFISCAL <> ''"+LF
	cQuery += " AND U6_LIGPROB <> 'S'  "+LF
	cQuery += " AND U6_RETENC <> 'S'  "+LF
	cQuery += " AND U6_DTAGCLI = '' "+LF
	
	//MemoWrite("C:\Temp\nao_lig.sql",cQuery )
	
	If Select("NAOREA") > 0
		DbSelectArea("NAOREA")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "NAOREA"
	
	nNaoRealiz := NAOREA->NAOREALIZ
	
	DbSelectArea("NAOREA")
	DbCloseArea()
	
	///depois de ter o TOTAL DE LIGAÇÕES, e saber quantas não realizadas, vamos agora
	///verificar se nas não realizadas, foi registrado o motivo - SU6 relaciona na SU8
	cQuery := " SELECT U6_STATUS,U8_STATUS, " + LF  
	cQuery += " CASE WHEN U8_STATUS ='1' THEN 'OCUPADO'  " + LF  
	cQuery += " ELSE   " + LF  
	cQuery += " CASE WHEN U8_STATUS ='2' THEN 'ERRO' " + LF  
	cQuery += " ELSE  " + LF  
	cQuery += " CASE WHEN U8_STATUS = '3' THEN 'FALHA' " + LF  
	cQuery += " ELSE  " + LF  
	cQuery += " CASE WHEN U8_STATUS = '4' THEN 'SEM LINHA' " + LF  
	cQuery += " ELSE " + LF  
	cQuery += " CASE WHEN U8_STATUS = '5' THEN 'EXECUTADO' " + LF  
	cQuery += " ELSE " + LF  
	cQuery += " 'NAO REALIZADO' " + LF  
	cQuery += " END " + LF  
	cQuery += " END " + LF  
	cQuery += " END " + LF  
	cQuery += " END " + LF  
	cQuery += " END AS MOTIVO " + LF 
	 
	cQuery += " ,U6_LISTA, U6_DATA, U6_NFISCAL, U8_CRONUM, U8_DATA, U8_STATUS, U6_CODENT, A1_NOME " + LF    	  
	cQuery += " FROM 
	cQuery += " " + RetSqlName("SF2") + " SF2, "+LF
	cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
	cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
	cQuery += " " + RetSqlName("SU6") + " SU6 "+LF
	
	cQuery += " LEFT JOIN " + RetSqlName("SU8") + " SU8 " + LF
	cQuery += " ON SU6.U6_LISTA = SU8.U8_CRONUM AND SU8.D_E_L_E_T_ = '' AND SU8.U8_FILIAL = '" + xFilial("SU8") + "' " + LF
	cQuery += " AND U6_CODIGO = U8_CONTATO"+LF
	
	cQuery += " WHERE U6_DATA = '" + Dtos(dData1) + "' " + LF
	
	cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
	cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
	cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
	
	cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
	cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
	cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
	cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
	
	cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA "+LF
	
	cQuery += " AND U6_NFISCAL = F2_DOC"+LF
	cQuery += " AND U6_SERINF = F2_SERIE"+LF
	cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
	
	cQuery += " AND U6_ORIGEM = '1'"+LF		///ORIGEM = '1' -> LISTA / ORIGEM = '3' -> FEEDBACK
	cQuery += " AND U6_TIPO = '1'"+LF		///TIPO = '1' -> LISTA  / TIPO = '5' -> FEEDBACK
	
	cQuery += " AND U6_STATUS = '1'"+LF
	cQuery += " AND U4_STATUS = '1'"+LF
	
	
	cQuery += " AND U6_NFISCAL <> ''"+LF
	cQuery += " AND U6_LIGPROB <> 'S'  "+LF
	cQuery += " AND U6_RETENC <> 'S'  "+LF
	cQuery += " AND U6_DTAGCLI = '' "+LF
	//cQuery += " AND F2_RETENC <> 'S'  "+LF
	//cQuery += " AND F2_DTAGCLI = '' "+LF
	//cQuery += " AND U8_STATUS <> '1'"+LF
	//cQuery += " AND U8_STATUS <> '2'"+LF
	//cQuery += " AND U8_STATUS <> '3'"+LF
	//cQuery += " AND U8_STATUS <> '4'"+LF
	//cQuery += " AND U8_STATUS <> '5'"+LF
	
	//cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
	//MemoWrite("C:\Temp\su8_motiv.sql", cQuery )
	
	If Select("SU8XX") > 0
		DbSelectArea("SU8XX")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "SU8XX"
	TCSetField( 'SU8XX', "U6_DATA", "D" )
	TCSetField( 'SU8XX', "U8_DATA", "D" )
	
	SU8XX->( DBGoTop() )
	
	nOcupado:= 0
	nErro   := 0
	nFalha  := 0
	nSemLin := 0
	
	
	Do While !SU8XX->( Eof() )  	
	 	
	 	If SU8XX->U8_STATUS = '1'
	 		cU8Status := "Ocupado"
	 		nOcupado++
	 	Elseif SU8XX->U8_STATUS = '2'
	 		cU8Status := "Erro"
	 		nErro++
	 	Elseif SU8XX->U8_STATUS = '3'
	 		cU8Status := "Falha"
	 		nFalha++
	 	Elseif SU8XX->U8_STATUS = '4'
	 		cU8Status := "Sem Linha"
	 		nSemLin++
	 	//Case SU8XX->U8_STATUS = '5'
	 		//cU8Status := "Executado"
	 		//nRealiz++
	 	//Elseif SU8XX->U8_STATUS = '6'
	 	//	cU8Status := "Excluido"
	 	//Elseif SU8XX->U8_STATUS = '7'
	 	//	cU8Status := "Enviado"
	 	//Elseif SU8XX->U8_STATUS = '8'
	 	//	cU8Status := "Impresso"
	 	Else
	 		cU8Status := "Nao Realizado"
	 	Endif
	 	 
	   SU8XX->( DbSkip() )
	
	Enddo
	DbSelectArea("SU8XX")
	DbCloseArea()
	
	nNaoRealiz := nNaoRealiz - (nOcupado + nErro + nSemLin)	
	dDatahist := Dtos(dData1)
			
	cQuery := ""
	cQuery += " SELECT * FROM " + RetSqlName("ZU8") + " ZU8 "+LF
	cQuery += " WHERE ZU8_TIPO = 'L' AND ZU8_DATA = '" + dDatahist + "' " +LF
	cQuery += " AND ZU8.D_E_L_E_T_ = '' " +LF
	cQuery += " AND ZU8.ZU8_FILIAL = '" + xFilial("ZU8") + "' " + LF
	//MemoWrite("C:\Temp\checkZU8L.sql", cQuery)
	If Select("ZZU8") > 0
	   DbSelectArea("ZZU8")
		DbCloseArea()
	EndIf
	TCQUERY cQuery NEW ALIAS "ZZU8" 
	
	lJatem := !ZZU8->(EOF())
	
	ZZU8->(DbCloseArea())
	
	If !lJatem
				
		DbselectArea("ZU8")
		Reclock("ZU8",.T.)
		ZU8->ZU8_FILIAL := xFilial()
		ZU8->ZU8_TIPO   := "L"
		ZU8->ZU8_DATA   := dData1		
		ZU8->ZU8_TOTDIA := nTotLig //nTotligacoes
		ZU8->ZU8_NAOLIG := nNaoRealiz //nQtligfora
		ZU8->ZU8_PORCEN := Round( ( (nNaoRealiz / nTotLig) * 100),2)		 //Round( ( (nQtligfora / nTotligacoes) * 100),2)		
	   ZU8->(MSUNLOCK())
			    
			    //MSGBOX("OK PARTE 2")
	Else
			 	//Msgbox("Este histórico já existe!")
		DbselectArea("ZU8")
		Reclock("ZU8",.F.)
		ZU8->ZU8_TOTDIA := nTotLig //nTotligacoes
		ZU8->ZU8_NAOLIG := nNaoRealiz //nQtligfora
		ZU8->ZU8_PORCEN := Round( ( (nNaoRealiz / nTotLig) * 100),2)		 //Round( ( (nQtligfora / nTotligacoes) * 100),2)		
	   ZU8->(MSUNLOCK())
	
	Endif
	       
	
	DbselectArea("ZU8")
	ZU8->(DbCloseArea())         
	
	dData1 := dData1 + 1

EndDo

Return