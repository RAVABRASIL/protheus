#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//-------------------------------------------------------------------------------
// WFGPE003 - Relatório Lista de Verificação Resultado Auditoria
//Objetivo: Utilizado por: Diretoria / EQUIPE 5S
// Autoria: Flávia Rocha
// Data   : 15/01/13
//-------------------------------------------------------------------------------

****************************
User Function WFGPE005()
****************************


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "LISTA RESULTADO AUDITORIA 5S"
Local cPict          := ""
Local titulo       := "RESULTADO AUDITORIA 5S"
Local nLin         := 80
Local imprime      := .T.
Local aOrd := {}
Private Cabec1       := "DIRETORIA        SETOR                     REAL       OBJETIVO"
Private Cabec2       := ""   
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "WFGPE005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "WFGPE005" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "WFGPE005"
Private cString := "Z79"
Private PAR01   := "" //MES
Private PAR02   := "" //ANO
Private lDentroSiga := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFGPE005"
  sleep( 5000 )
  conOut( "Programa WFGPE005 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
	RunReport(Cabec1,Cabec2,Titulo,nLin)
 
  
Else

  lDentroSiga := .T.
  	PERGUNTE(cPerg, .T.)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)
    //PAR01 := MV_PAR01
    //PAR02 := MV_PAR02
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo) 
  
EndIf
                             

Return

*****************************************************                      
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin) 
*****************************************************


Local oProcess, oHtml
Local cArqHtml:= ""
Local cAssunto:= ""
Local LF        := CHR(13)+CHR(10)
Local cQuery    := ""
Local aDad      := {}
//Local cMail5S   := GetMV("RV_EQP5S") 
Local nOrdem
Local nMes      := 0
Local nMesAnt   := 0
Local nTotAB := 0   //TOTAIS POR GESTOR
Local nTotENC:= 0
Local nTotATZ:= 0
Local nTotACU:= 0
Local nTotGAB := 0 //TOTAIS GERAL DAQUI PRA BAIXO
Local nTotGENC:= 0
Local nTotGATZ:= 0
Local nTotGACU:= 0		    

nMes := Val(PAR01)
nMesAnt := nMes - 1

/////REUNE OS DADOS PARA GERAR O HTML	
cQuery := " Select " + LF
cQuery += " Z79_DIR DIR ,Z79_SETOR SETOR, X5_DESCRI NOMESETOR" + LF + LF

cQuery += " ,SENSO1 = (SELECT (CASE WHEN A.Z79_DIR = 'ADM' " + LF 
cQuery += "            THEN SUM(A.Z79_P1+ A.Z79_P2 + A.Z79_P3)  " + LF 
cQuery += "            ELSE SUM(A.Z79_P1+ A.Z79_P2 + A.Z79_P3 + A.Z79_P4 + A.Z79_P5) END) " + LF 
cQuery += "            FROM " + RetSqlName("Z79") + " A WHERE A.D_E_L_E_T_='' AND A.Z79_DIR = Z79.Z79_DIR  " + LF 
cQuery += "            AND A.Z79_SETOR = Z79.Z79_SETOR " + LF
cQuery += "            GROUP BY A.Z79_DIR, A.Z79_SETOR )  " + LF + LF 

cQuery += " ,SENSO2 = (SELECT (CASE WHEN B.Z79_DIR = 'ADM'  " + LF 
cQuery += "            THEN SUM(B.Z79_P4+ B.Z79_P5 + B.Z79_P6 + B.Z79_P7)  " + LF 
cQuery += "            ELSE SUM(B.Z79_P6+ B.Z79_P7 + B.Z79_P8 + B.Z79_P9 + B.Z79_P10 + B.Z79_P11 + B.Z79_P12) END) " + LF 
cQuery += "            FROM " + RetSqlName("Z79") + " B WHERE B.D_E_L_E_T_='' AND B.Z79_DIR = Z79.Z79_DIR  " + LF 
cQuery += "            AND B.Z79_SETOR = Z79.Z79_SETOR " + LF
cQuery += "            GROUP BY B.Z79_DIR, B.Z79_SETOR )  " + LF + LF 

cQuery += " ,SENSO3 = (SELECT (CASE WHEN C.Z79_DIR = 'ADM'  " + LF 
cQuery += "            THEN SUM(C.Z79_P8+ C.Z79_P9 + C.Z79_P10 + C.Z79_P11 + C.Z79_P12 + C.Z79_P13 + C.Z79_P14)  " + LF 
cQuery += "            ELSE SUM(C.Z79_P6+ C.Z79_P7 + C.Z79_P8 + C.Z79_P9 + C.Z79_P10 + C.Z79_P11 + C.Z79_P12) END) " + LF 
cQuery += "            FROM " + RetSqlName("Z79") + " C WHERE C.D_E_L_E_T_='' AND C.Z79_DIR = Z79.Z79_DIR  " + LF 
cQuery += "            AND C.Z79_SETOR = Z79.Z79_SETOR " + LF
cQuery += "            GROUP BY C.Z79_DIR, C.Z79_SETOR )  " + LF + LF 

cQuery += " ,SENSO4 = (SELECT (CASE WHEN D.Z79_DIR = 'ADM'  " + LF 
cQuery += "            THEN SUM(D.Z79_P15+ D.Z79_P16 + D.Z79_P17 + D.Z79_P18)  " + LF 
cQuery += "            ELSE SUM(D.Z79_P18+ D.Z79_P19 + D.Z79_P20 + D.Z79_P21 + D.Z79_P22 + D.Z79_P23) END) " + LF 
cQuery += "            FROM  " + RetSqlName("Z79") + " D WHERE D.D_E_L_E_T_='' AND D.Z79_DIR = Z79.Z79_DIR  " + LF 
cQuery += "            AND D.Z79_SETOR = Z79.Z79_SETOR " + LF
cQuery += "            GROUP BY D.Z79_DIR, D.Z79_SETOR )  " + LF + LF 
           
cQuery += " ,SENSO5 = (SELECT (CASE WHEN E.Z79_DIR = 'ADM'  " + LF 
cQuery += "            THEN SUM(E.Z79_P19+ E.Z79_P20)  " + LF 
cQuery += "            ELSE SUM(E.Z79_P24+ E.Z79_P25 + E.Z79_P26 + E.Z79_P27 + E.Z79_P28) END) " + LF 
cQuery += "            FROM  " + RetSqlName("Z79") + " E WHERE E.D_E_L_E_T_='' AND E.Z79_DIR = Z79.Z79_DIR  " + LF 
cQuery += "            AND E.Z79_SETOR = Z79.Z79_SETOR " + LF
cQuery += "            GROUP BY E.Z79_DIR, E.Z79_SETOR )  " + LF + LF 
                                                         
cQuery += " FROM  " + RetSqlName("Z79") + "  Z79 " + LF 
cQuery += " ,     " + RetSqlName("SX5") + " SX5 " + LF
cQuery += " WHERE Z79.D_E_L_E_T_='' " + LF 
cQuery += " AND   SX5.D_E_L_E_T_='' " + LF 
cQuery += " AND X5_TABELA = 'ZW' " + LF 
cQuery += " AND Z79.Z79_SETOR = SX5.X5_CHAVE " + LF 
cQuery += " AND Z79_DTAUD BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + LF
cQuery += " GROUP BY Z79_DIR, Z79_SETOR, X5_DESCRI " + LF 


Memowrite("C:\TEMP\WFGPE005.SQL",cQuery) 
	
	If Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP1" 
	//TCSetField( "TMP1" , "Z79_DTAUD", "D")

aSensos := { "1.Senso de Utilização" ,;
				"2.Senso de Organização e Padronização",;
				"3.Senso de Limpeza",;
				"4.Senso de Saúde e Segurança",;
				"5. Utilização, Ordenação, Limpeza, Saúde e Auto-disciplina" }
cVar := ""
aTotais := {}				
TMP1->(DbGoTop())
If !TMP1->(EOF()) 

	///SOMA OS SENSO PARA SABER A PONTUAÇÃO TOTAL POR DEPTO
	nOBJTOT := 0 //SOMA DO OBJETIVO PARA TODOS OS SENSOS, POR DIRETORIA
	TMP1->(DbGoTop())
	While TMP1->(!EOF()) 
		nTotSensos := TMP1->SENSO1 + TMP1->SENSO2 + TMP1->SENSO3 + TMP1->SENSO4 + TMP1->SENSO5
		nOBJTOT += fPeso( TMP1->DIR , 1)
		nOBJTOT += fPeso( TMP1->DIR , 2)
		nOBJTOT += fPeso( TMP1->DIR , 3)
		nOBJTOT += fPeso( TMP1->DIR , 4)
		nOBJTOT += fPeso( TMP1->DIR , 5)
		Aadd( aTotais , {TMP1->DIR, TMP1->SETOR, TMP1->NOMESETOR, nTotSensos, nOBJTOT } )
		nOBJTOT := 0 //ZERA PARA O PRÓXIMO DEPTO
		DbselectArea("TMP1")
		TMP1->(DBSKIP())
	Enddo
	//aTotais := Asort( aTotais,,, { |X,Y| X[1] + Transform(X[4] , "@E 9999.99" ) >  Y[1] + Transform(Y[4], "@E 999.99")  } ) //do maior (melhor) para o menor (pior)
	aTotais := Asort( aTotais,,, { |X,Y| X[4] >  Y[4] } ) //do maior (melhor) para o menor (pior)
	////SOMA SENSOS POR DEPTO
	nSenso := 1      
	Do While nSenso < 6
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		    nLin := 8
		Endif
		@nLin,000 PSAY Replicate('.' , limite )
		nLin++
		@nLin,000 PSAY aSensos[nSenso]
		nLin++
		nLin++
		cVar := "SENSO" + alltrim(str(nSenso))
		nConta := 1
		TMP1->(DbGoTop())
		While TMP1->(!EOF()) 
			
	        
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
						
			If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			    nLin := 8
			Endif
			nOBJETIVO := 0			
			@nLin,000 PSAY TMP1->DIR
			@nLin,007 PSAY SUBSTR(TMP1->NOMESETOR,1,30)
			//@nLin,040 PSAY Transform(TMP1->SENSO1 , "@E 9999.99")  //REAL
			@nLin,040 PSAY Transform(TMP1->&(cVar) , "@E 9999.99")  //REAL
			nOBJETIVO := fPeso( TMP1->DIR , nSenso)
			@nLin,053 PSAY Transform(nOBJETIVO, "@E 9999.99") //OBJETIVO
			nLin++
			
			//aTotais[nConta,5] := 
			DbselectArea("TMP1")
			TMP1->(DBSKIP())
			
							
				
		Enddo
		@nLin,000 PSAY Replicate('.' , limite )
		nLin++
		@nLin++ 
		nSenso++
	Enddo
	fr := 0
	/////////////////////////////
	////IMPRIME TOTAIS POR DEPTO
	/////////////////////////////
	//Aadd( aTotais , {TMP1->DIR, TMP1->SETOR, TMP1->NOMESETOR, nTotSensos} )
	@nLin,000 PSAY Replicate('*' , limite )
	nLin++
	@nLin,000 PSAY "                TOTAIS                                  "
	nLin++                                 
	@nLin,000 PSAY Replicate('*' , limite )
	nLin++
	@nLin,000 PSAY "DIRETORIA        SETOR                     PONTUAÇÃO ATENDIDA       OBJETIVO TOTAL" 
	nLin++
	For fr := 1 to Len(aTotais) 
		@nLin,000 PSAY aTotais[fr,1]  //dir 
		@nLin,012 PSAY SUBSTR(aTotais[fr,3],1,30)  //nome setor
		@nLin,050 PSAY Transform(aTotais[fr,4] , "@E 9999.99")  //pontuação atendida
		@nLin,070 PSAY Transform(aTotais[fr,5] , "@E 9999.99")  //objetivo total
		nLin++
	Next
	@nLin,000 PSAY Replicate('*' , limite )
		
	Roda( 0 , "" , tamanho )
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
		
Endif	//if eof



Return	


************************************
Static Function fPeso( cDIR, nSenso)            //atualiza o campo PESO DA PERGUNTA
************************************

Local aADM1 := { 6.7 , 6.7, 6.7 }   //SENSO 1 -> p1, p2, p3  (números das perguntas)
Local aADM2 := { 5 , 5  , 5  , 5  }  //SENSO 2 -> p4, p5, p6, p7
Local aADM3 := { 2.9, 2.9, 2.9, 2.9, 2.8 , 2.8 , 2.8 }  //SENSO 3 -> p8, p9, p10, p11, p12, p13, p14
Local aADM4 := { 5 , 5  , 5  , 5  }   //SENSO 4  -> p15, p16, p17, p18
Local aADM5 := { 10 , 10  } //SENSO 5   -> p19, p20  				  				   				 

Local aArray := {} //array clone para auxiliar transporte dos dados				  				  				   				 
 				 
Local aSC1 := { 3.5, 3.5, 3.5, 3.5 , 3.5 }   //SENSO 1 -> p1, p2, p3, p4, p5  (números das perguntas) 				 
Local aSC2 := { 2.5 , 2.5  , 2.5  , 2.5  , 2.5, 2.5, 2.5 }  //SENSO 2 -> p6, p7, p8, p9, p10, p11, p12 				
Local aSC3 := { 3.5, 3.5, 3.5, 3.5, 3.5  }  //SENSO 3 -> p13, p14, p15, p16, p17 				
Local aSC4 := { 2.91 , 2.91 , 2.92, 2.92, 2.92, 2.92 }   //SENSO 4  -> p18, p19, p20, p21, p22, p23
Local aSC5 := {  6, 6, 6, 6, 6  } //SENSO 5   -> p24, p25, p26, p27, p28
 				 

Local aCX1 := { 3.5, 3.5, 3.5, 3.5 , 3.5 }   //SENSO 1 -> p1, p2, p3, p4, p5  (números das perguntas) 				 
Local aCX2 := { 2.5 , 2.5  , 2.5  , 2.5  , 2.5, 2.5, 2.5 }  //SENSO 2 -> p6, p7, p8, p9, p10, p11, p12 				
Local aCX3 := { 3.5, 3.5, 3.5, 3.5, 3.5  }  //SENSO 3 -> p13, p14, p15, p16, p17 				
Local aCX4 := { 2.91 , 2.91 , 2.92, 2.92, 2.92, 2.92 }   //SENSO 4  -> p18, p19, p20, p21, p22, p23
Local aCX5 := {  6, 6, 6, 6, 6  } //SENSO 5   -> p24, p25, p26, p27, p28

Local nPes := 0
Local fr   := 0


If nSenso = 1
	If Alltrim(cDIR) = "ADM"
		aArray := aADM1     
	ElseIf Alltrim(cDIR) = "SC"
		aArray := aSC1
	ElseIf Alltrim(cDIR) = "CX"
		aArray := aCX1
	Endif
ElseIf nSenso = 2
	If Alltrim(cDIR) = "ADM"
		aArray := aADM2     
	ElseIf Alltrim(cDIR) = "SC"
		aArray := aSC2
	ElseIf Alltrim(cDIR) = "CX"
		aArray := aCX2
	Endif   
ElseIf nSenso = 3
	If Alltrim(cDIR) = "ADM"
		aArray := aADM3     
	ElseIf Alltrim(cDIR) = "SC"
		aArray := aSC3
	ElseIf Alltrim(cDIR) = "CX"
		aArray := aCX3
	Endif             
ElseIf nSenso = 4
	If Alltrim(cDIR) = "ADM"
		aArray := aADM4
	ElseIf Alltrim(cDIR) = "SC"
		aArray := aSC4
	ElseIf Alltrim(cDIR) = "CX"
		aArray := aCX4
	Endif             
ElseIf nSenso = 5
	If Alltrim(cDIR) = "ADM"
		aArray := aADM5     
	ElseIf Alltrim(cDIR) = "SC"
		aArray := aSC5
	ElseIf Alltrim(cDIR) = "CX"
		aArray := aCX5
	Endif
Endif

If Len(aArray) > 0
	For fr := 1 to Len(aArray)
		nPes += aArray[fr]
	Next
Endif
	
	
Return(nPes)  
