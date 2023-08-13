#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//-------------------------------------------------------------------------------
// WFGPE003 - Relatório CONDIÇÕES INSEGURAS GERAL ACUMULADO - para envio à Diretoria
// Workflow: MENSAL
// Objetivo: Utilizado por: Diretoria / EQUIPE 5S
// Autoria : Flávia Rocha
// Data    : 26/11/13
//-------------------------------------------------------------------------------

****************************
User Function WFGPE003()
****************************


Private PAR01   := "" //MES
Private PAR02   := "" //ANO
Private lDentroSiga := .F.
Private titulo       := "STATUS SOLICITAÇÕES 5S - CONDIÇÕES INSEGURAS"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFGPE003"
  sleep( 5000 )
  conOut( "Programa WFGPE003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  //Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
	
	ExecRel()
 
  
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
    PAR01 := MV_PAR01
    PAR02 := MV_PAR02
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| ExecRel() },Titulo) 
  
EndIf
                             

Return

*****************************************************                      
Static Function ExecRel() 
*****************************************************


Local oProcess, oHtml
Local cArqHtml:= ""
Local cAssunto:= ""
Local LF        := CHR(13)+CHR(10)
Local cQuery    := ""
Local aDad      := {}
Local cMail5S   := GetMV("RV_WFGPE03")  //PARÂMETRO ASSOCIADO A ESTE PROGRAMA
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
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "STATUS SOLICITAÇÕES 5S - CONDIÇÕES INSEGURAS"
Local cPict          := ""

Local nLin         := 80
Local imprime      := .T.
Local aOrd := {}
Private Cabec1       := "ÁREA                                        QTDE.         QTDE.          QTDE.        ACUMULADO"
Private Cabec2       := "                                            ABERTA      ENCERRADA       ATRASO      MESES ANTERIORES"   
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "WFGPE003" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "WFGPE003" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "WFGPE003"
Private cString := "Z80"


If !lDentroSiga
	PAR01 := Strzero(Month(dDatabase),2)  //mês
	//PAR01 := '03'  //Alltrim(Str(Month(dDatabase))) //RETIRAR
	PAR02 := Alltrim(Str(Year(dDatabase)))   //ano
Endif		    

nMes := Val(PAR01)
nMesAnt := nMes - 1

/////REUNE OS DADOS PARA GERAR O HTML	
	cQuery := " SELECT " + LF
	//cQuery += " Z80_SETOR , Z80_INTEG2" + LF + LF
	cQuery += " Z80_SETOR , Z80_INTEGR" + LF + LF
	
	//cQuery += " ,Z80.Z80_EMISSA " + LF
	
	//cQuery += " ,Z80.Z80_DTPREV " + LF
	
	//cQuery += " ,Z80.Z80_DTSOL " + LF
	
	cQuery += " ,QT_AB = ( select count(*) from " + RetSqlName("Z80") + " A " + LF
	cQuery += "           where A.D_E_L_E_T_ = '' and A.Z80_SETOR = Z80.Z80_SETOR " + LF 
	cQuery += "           and A.Z80_AREA = Z80.Z80_AREA " + LF 
	cQuery += "           and A.Z80_SETOR = Z80.Z80_SETOR " + LF 
	cQuery += "           and A.Z80_INTEGR = Z80.Z80_INTEGR " + LF 
	cQuery += "           and LEFT(A.Z80_EMISSA,4) = '" + Alltrim(PAR02) + "' " + LF        //ano
	cQuery += "           and SUBSTRING(A.Z80_EMISSA,5,2) = '" + Alltrim(PAR01) + "' " + LF     //mês
	cQuery += "          ) " + LF + LF
	
	///ENCERRADAS NO MÊS CORRENTE
	cQuery += " ,QT_ENC = ( select count(*) from " + RetSqlName("Z80") + " B " + LF
	cQuery += "           where B.D_E_L_E_T_ = '' and B.Z80_SETOR = Z80.Z80_SETOR " + LF 
	cQuery += "           and  B.Z80_AREA = Z80.Z80_AREA " + LF 
	cQuery += "           and  B.Z80_SETOR = Z80.Z80_SETOR " + LF 
	//cQuery += "           and B.Z80_INTEG2 = Z80.Z80_INTEG2 " + LF 
	cQuery += "           and B.Z80_INTEGR = Z80.Z80_INTEGR " + LF 
	cQuery += "           and B.Z80_DTSOL <> '' " + LF
	cQuery += "           and LEFT(B.Z80_DTSOL,4) = '" + Alltrim(PAR02) + "' " + LF        //ano
	cQuery += "           and SUBSTRING(B.Z80_DTSOL,5,2) = '" + Alltrim(PAR01) + "' " + LF     //mês
	cQuery += "          ) " + LF + LF
	
	//AS QUE TEM DATA PREVISTA DE SOLUÇÃO PARA O MÊS CORRENTE, MAS AINDA NÃO FORAM SOLUCIONADAS, ISTO É, EM ATRASO
	cQuery += " ,QT_ATZ = ( select count(*) from " + RetSqlName("Z80") + " C " + LF
	cQuery += "           where C.D_E_L_E_T_ = '' and C.Z80_SETOR = Z80.Z80_SETOR " + LF 
	cQuery += "           and C.Z80_AREA = Z80.Z80_AREA " + LF 
	cQuery += "           and C.Z80_SETOR = Z80.Z80_SETOR " + LF 
	//cQuery += "           and C.Z80_INTEG2 = Z80.Z80_INTEG2 " + LF 
	cQuery += "           and C.Z80_INTEGR = Z80.Z80_INTEGR " + LF 
	cQuery += "           and CAST(CAST(GETDATE() AS DATETIME) - CAST(Z80_DTPREV AS DATETIME)AS INTEGER) >= 1 " +LF 
	cQuery += "           and C.Z80_DTSOL = '' " + LF
	cQuery += "           and LEFT(C.Z80_DTPREV,4) = '" + Alltrim(PAR02) + "' " + LF        //ano
	cQuery += "           and SUBSTRING(C.Z80_DTPREV,5,2) = '" + Alltrim(PAR01) + "' " + LF     //mês
	cQuery += "          ) " + LF + LF
	
	//AS DO MÊS ANTERIOR A ESTE MÊS, E QUE ESTÃO SEM DATA SOLUÇÃO
	cQuery += " ,QT_ACU = ( select count(*) from " + RetSqlName("Z80") + " D " + LF
	cQuery += "           where D.D_E_L_E_T_ = '' and D.Z80_SETOR = Z80.Z80_SETOR " + LF 
	cQuery += "           and D.Z80_AREA = Z80.Z80_AREA " + LF 
	cQuery += "           and D.Z80_SETOR = Z80.Z80_SETOR " + LF 
	//cQuery += "           and D.Z80_INTEG2 = Z80.Z80_INTEG2 " + LF 
	cQuery += "           and D.Z80_INTEGR = Z80.Z80_INTEGR " + LF 
	//cQuery += "           and CAST(CAST(GETDATE() AS DATETIME) - CAST(Z80_DTPREV AS DATETIME)AS INTEGER) >= 1 " +LF
	cQuery += "           and D.Z80_DTSOL = '' " + LF 
	cQuery += "           and LEFT(D.Z80_DTPREV,4) = '" + Alltrim(PAR02) + "' " + LF        //ano
	//cQuery += "           and SUBSTRING(D.Z80_DTPREV,5,2) = '" + Alltrim(Str(nMesAnt)) + "' " + LF     //mês anterior
	cQuery += "           and SUBSTRING(D.Z80_DTPREV,5,2) <= '" + Alltrim(PAR01) + "' " + LF     //do mês corrente pra trás meses anteriores
	cQuery += "          ) " + LF + LF      
	
	
	//cQuery += " , CAST(CAST(GETDATE() AS DATETIME) - CAST(Z80_DTPREV AS DATETIME)AS INTEGER) as DIASAB " +LF
	//cQuery += " ,* " + LF
	
	cQuery += " FROM " + RetSqlName("Z80") + " Z80 " + LF
	//cQuery += " ,    " + RetSqlName("Z81") + " Z81 " + LF
	//cQuery += " ,    " + RetSqlName("SYP") + " YP " + LF
	
	cQuery += " WHERE " + LF
	cQuery += " Z80.Z80_TIPO = 'CI' " + LF
	//cQuery += " AND CAST(CAST(GETDATE() AS DATETIME) - CAST(Z80_DTPREV AS DATETIME)AS INTEGER) >= 1 " + LF
	cQuery += " AND Z80_SETOR <> '' " + LF                        
	If !Empty(MV_PAR03)
		cQuery += " AND Z80_SETOR = '" + Alltrim(MV_PAR03) + "' " + LF
	Endif
	cQuery += " AND Z80_AREA <> '' " + LF
	//cQuery += " AND Z80_NUMSOL = Z81_NUMSOL " + LF
	//cQuery += " AND YP_CHAVE = Z80_CODMP " + LF

	cQuery += " AND Z80.D_E_L_E_T_='' " + LF
	
	//cQuery += " GROUP BY Z80_INTEG2, Z80_SETOR " + LF
	//cQuery += " ORDER BY Z80_INTEG2, Z80_SETOR " + LF
	
	cQuery += " GROUP BY Z80_INTEGR, Z80_AREA, Z80_SETOR " + LF
	cQuery += " ORDER BY Z80_INTEGR " + LF
	

	Memowrite("C:\TEMP\WFGPE003.SQL",cQuery) 
	
	If Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP1" 
	//TCSetField( "TMP1" , "Z80_EMISSA", "D")
	//TCSetField( "TMP1" , "Z80_DTPREV", "D")
	//TCSetField( "TMP1" , "Z80_DTSOL", "D")

	
	If !TMP1->(EOF())
		TMP1->(DbGoTop())
		If !lDentroSiga
		
			//-------------------------------------------------------------------------------------
			// Iniciando o Processo WorkFlow de envio dos Processos Devolução x Status
			//-------------------------------------------------------------------------------------
			// Monte uma descrição para o assunto:
			cAssunto := "RELATORIO CONDIÇÕES INSEGURAS - Por Setor"
			
			// Informe o caminho e o arquivo html que será usado.
			cArqHtml := "\Workflow\http\oficial\WFGPE003.html"
			
			// Inicialize a classe de processo:
			oProcess := TWFProcess():New( "WFGPE003", cAssunto )
			
			// Crie uma nova tarefa, informando o html template a ser utilizado:
			oProcess:NewTask( "WF 5S", cArqHtml )
			
			// Informe o nome do shape correspondente a este ponto do fluxo:
			cShape := "INICIO"
		
		
			// Informe a função que deverá ser executada quando as respostas chegarem
			// ao Workflow.
			oProcess:cSubject := cAssunto
			
			oHtml := oProcess:oHTML
			cMsg     := "Abaixo, Relação Sintética Por Setor das Condições Inseguras apontadas pela Equipe 5S Referentes ao Período: "
			cMsg     += '01/' + PAR01 + '/' + substr(PAR02,3,2) 
			cMsg     += '  A  ' + Dtoc(LastDay( CTOD('01/' + PAR01 + '/' + PAR02) ) ) + CHR(13) + CHR(10) 
			cMsg     += '.'+ CHR(13) + CHR(10)
			cMsg     += "Para os e-mails: " + CHR(13) + CHR(10) 
			For x := 1 to Len(cMail5S)     
				If Substr(cMail5S,x,1) != ';'
					cMsg += Substr(cMail5S,x,1)
				Else //se é = ;
					cMsg += Substr(cMail5S,x,1) + CHR(13) + CHR(10)
				Endif
			Next
			
			oHtml:ValByName("Cabeca",cAssunto)
			oHtml:ValByName("cMesAnt",MesExtenso(nMesAnt) )
			
			oHtml:ValByName("cMSG",cMsg) 
		Else
			//Cabec2       := "                                          ABERTA        ENCERRADA       ATRASO        MES ANTERIOR"   	
			titulo       += " - MÊS REFERÊNCIA: " + MesExtenso(Val(PAR01))
			Cabec2       += ": " + "JANEIRO A " + MesExtenso(Val(PAR01))    //+ MesExtenso(nMesAnt)
			cMsg     := "Abaixo, Relação Sintética Por Setor das Condições Inseguras apontadas pela Equipe 5S Referentes ao Período: "+CHR(13) + CHR(10)
			cMsg     += '01/' + PAR01 + '/' + substr(PAR02,3,2) 
			cMsg     += '  A  ' + Dtoc(LastDay( CTOD('01/' + PAR01 + '/' + PAR02) ) )//(MesExtenso( Val(PAR01) ) + " de " + PAR02
		Endif        
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		    nLin := 8
		Endif         
		nLin++
		@nLin,000 PSAY cMsg
		nLin++
		//@nLin,000 PSAY REPLICATE("." , limite)
		//nLin++
	
		While TMP1->(!EOF()) 
			
			//cGestor := TMP1->Z80_INTEG2
			cResp := TMP1->Z80_INTEGR
			//imprime gestor como cabeça das solicitações por setor
			@nLin,000 PSAY Replicate(".",limite)
			nLin++
			nLin++
			@nLin,000 PSAY cResp //Substr(cGestor,8,16)
			nLin++
			nLin++
			
			//While TMP1->(!EOF()) .and. Alltrim(Substr(TMP1->Z80_INTEG2,1,6)) == Alltrim(Substr(cGestor,1,6))
			While TMP1->(!EOF()) .and. Alltrim(Substr(TMP1->Z80_INTEGR,1,6)) = Alltrim(Substr(cResp,1,6))
			
				cSetor    := ""
			  	SX5->(DBSETORDER(1))
				If SX5->(Dbseek(xFilial("SX5") + "ZW" + TMP1->Z80_SETOR))
					cSetor := SX5->X5_DESCRI
				Endif
				
				If lDentroSiga
					
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
					
					//@nLin,000 PSAY PAR02
					//@nLin,005 PSAY MesExtenso( Val(PAR01) )			    
					If !Empty(cSetor)
						@nLin,000 PSAY Substr(cSetor,1,40)
					Else
						@nLin,000 PSAY SPACE(40)
					Endif
				    @nLin,048 PSAY Transform(TMP1->QT_AB ,  "@E 9999")
				    @nLin,061 PSAY Transform(TMP1->QT_ENC , "@E 9999")
				    @nLin,074 PSAY Transform(TMP1->QT_ATZ , "@E 9999")
				    @nLin,085 PSAY Transform(TMP1->QT_ACU , "@E 9999")
				    nLin++
				    nTotAB += TMP1->QT_AB
				    nTotENC+= TMP1->QT_ENC
				    nTotATZ+= TMP1->QT_ATZ
				    nTotACU+= TMP1->QT_ACU
				    
				    nTotGAB += TMP1->QT_AB
				    nTotGENC+= TMP1->QT_ENC
				    nTotGATZ+= TMP1->QT_ATZ
				    nTotGACU+= TMP1->QT_ACU
				
				Else
					aadd( oHtml:ValByName("it.cGESTOR") , Substr(cResp,8,16) )        
					aadd( oHtml:ValByName("it.cArea") , cSetor )        
				    //aadd( oHtml:ValByName("it.cANO")  , PAR02 )      
				    aadd( oHtml:ValByName("it.nABERTA")  , STR(TMP1->QT_AB) )       
				    aadd( oHtml:ValByName("it.nENCERR")  , STR(TMP1->QT_ENC) )       
				    aadd( oHtml:ValByName("it.nATRASA")  , STR(TMP1->QT_ATZ) )       
				    aadd( oHtml:ValByName("it.nACUM")  , STR(TMP1->QT_ACU) )       
				    
				    nTotGAB += TMP1->QT_AB
				    nTotGENC+= TMP1->QT_ENC
				    nTotGATZ+= TMP1->QT_ATZ
				    nTotGACU+= TMP1->QT_ACU
				    
				Endif
	
				DbselectArea("TMP1")
				TMP1->(DBSKIP())
		
			Enddo //cresponsável
			
			If lDentroSiga
				//totais por gestor                 
				@nLin,000 PSAY Replicate('.',limite)
				nLin++
				@nLin,000 PSAY "TOTAL RESPONSAVEL: " //+ cResp
				//nLin++
				@nLin,048 PSAY Transform(nTotAB ,  "@E 9999")
			    @nLin,061 PSAY Transform(nTotENC , "@E 9999")
			    @nLin,074 PSAY Transform(nTotATZ , "@E 9999")
			    @nLin,085 PSAY Transform(nTotACU , "@E 9999")
			    //@nLin,000 PSAY Replicate('.',limite)
			    nLin++
			    nTotAB := 0
			    nTotENC:= 0
			    nTotATZ:= 0
			    nTotACU:= 0
			 //Else  
			 	
			 Endif
		Enddo 
		
		If lDentroSiga
			DbSelectArea("TMP1")
			DbCloseArea()	
			
			@nLin,000 PSAY Replicate('=',limite)
			nLin++
			@nLin,000 PSAY "TOTAL GERAL:"
			@nLin,048 PSAY Transform(nTotGAB ,  "@E 9999")
		    @nLin,061 PSAY Transform(nTotGENC , "@E 9999")
		    @nLin,074 PSAY Transform(nTotGATZ , "@E 9999")
		    @nLin,085 PSAY Transform(nTotGACU , "@E 9999")
	    
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
		Else
			oHtml:ValByName("TOTAB",nTotGAB) 
			oHtml:ValByName("TOTENC",nTotGENC) 
			oHtml:ValByName("TOTATZ",nTotGATZ) 
			oHtml:ValByName("TOTACUM",nTotGACU) 
			
			cNome  := ""		
			cMail  := ""     
			cDepto := ""
			PswOrder(1)
			If PswSeek( '000000', .T. )
				aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
			   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
			   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
				cDepto:= aUsers[1][12]  //Depto do usuário logado	
			Endif
			oProcess:cTo := cMail5S  //via parâmetro no Sx6
			//oProcess:cTo := "aline.farias@ravaembalagens.com.br" 
			//oProcess:cTo += ";regineide.neves@ravaembalagens.com.br" 
			//oProcess:cTo += ";marcelo@ravaembalagens.com.br" 
			oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br" 
			
			oHtml:ValByName("cUser",cNome)
			oHtml:ValByName("cDepto",cDepto)
			oHtml:ValByName("cMail",cMail)
			
			// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
			// de destinatários.
			oProcess:Start()
			WfSendMail() 
			Reset Environment
		
		Endif //lDentroSiga
		
	Endif	//if eof



Return	
