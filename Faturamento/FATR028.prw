#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR028
//Objetivo: Relatório 06 - Resumo da Movimentação de Clientes (por Representante)
//			
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 11/05/2011
//--------------------------------------------------------------------------
/*/


************************************
User Function FATR028()
************************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
  	//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT006" Tables "SC9"
  	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f28()	//chama a função do relatório
  
Else
  //conOut( "Programa WFFAT006 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  lDentroSiga := .T.
  f28()
  
EndIf
  

Return

**********************
Static Function f28()
**********************

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. 06 - CLIENTES REATIVADOS "
Local cPict          := ""
Local titulo         := "" 

Local Cabec1         := "" 
Local Cabec2		 :=	""
Local Texto			 := ""
Local imprime        := .T.
Local aOrd := {}

Local cCodUser		 := ""

Local dDTPar		 := Ctod("  /  /    ")
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR028" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR028" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "" //"FTR012"
Private cString := ""

Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 
Private nLinhas		:= 80


titulo := "Relatorio 06 - "
titulo += "MOVIMENTO CLIENTES"
/*
mv_par01 - coordenador
mv_par02 - Somente: 1 - todos, 2 - Novos, 3- Reativados, 4-Inativos
*/


If lDentroSiga

	Pergunte("FATR028",.T.) 	//INFORME O COORDENADOR
    If MsgYesNo("Deseja Gerar o Rel. 06 ?")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLinhas) },Titulo)      
	
	Endif

Else
	//se for pelo Schedule
	RunReport(Cabec1,Cabec2,Titulo,nLinhas)

Endif


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/10/09   º±±
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


Local cQuery:=''
Local cSuper:= ""
Local cNomeSuper:= ""
Local cMailSuper:= ""

Local cRepre	:= ""
Local cNomeRepre:= ""

Local aDados	:= {}
Local nCtaNovo  := 0
Local nCtaSubiu := 0
Local nCtaDesceu:= 0
Local nSaldo	:= 0
Local nRegTot	:= 0
Local aResult	:= {}
Local cCorpo  := ""
Local cAnexo  := ""
Local cAssun  := ""
Local frX	  := 0
Local cCopia  := ""
Local nTotNovo:= 0
Local nTotReat:= 0
Local nTotInat:= 0
Local nTotSaldo:= 0

///QUERY 

cQuery := " SELECT R.A3_COD AS REPRE, R.A3_NREDUZ AS NOMEREPRE, S.A3_COD AS SUPER, S.A3_NREDUZ AS NOMESUPER, S.A3_EMAIL AS MAILSUPER " + LF
cQuery += " FROM SA3010 R, SA3010 S  " + LF
cQuery += " WHERE R.A3_SUPER = S.A3_COD " + LF
cQuery += " AND R.A3_ATIVO <> 'N' " + LF
cQuery += " AND R.D_E_L_E_T_ = '' " + LF
cQuery += " AND S.D_E_L_E_T_ = '' " + LF
cQuery += " AND ( R.A3_SUPER <> '' ) " + LF
If lDentroSiga
	cQuery += " AND ( R.A3_SUPER = '" + Alltrim(mv_par01) + "' or R.A3_COD = '" + Alltrim(mv_par01) + "' ) " + LF  
Endif
cQuery += " ORDER BY S.A3_COD, R.A3_COD " + LF
//MemoWrite("C:\Temp\fatr023-02.sql",cQuery)
If Select("RESU") > 0
	DbSelectArea("RESU")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "RESU"			
RESU->( DbGoTop() )			
If !RESU->(EOF())
	While RESU->( !EOF() )
		
		cRepre    := RESU->REPRE			
		cNomeRepre:= Alltrim(RESU->NOMEREPRE)
		
		cSuper    := RESU->SUPER
		cMailSuper  := Alltrim(RESU->MAILSUPER)
		cNomeSuper := Alltrim(RESU->NOMESUPER)
	
		////Verifica QTOS CLIENTES NOVOS
		//aResult := fNovo_Reat(cRepre)     ///faz o cálculo de qtos clientes novos e reativados
		
		//nCtaNovo:= aResult[1]
			
		////verifica qtos clientes foram REATIVADOS
		//nCtaSubiu := aResult[2]
				
		////verifica qtos clientes foram INATIVADOS
		//nCtaDesceu := aResult[3] //fInativo( cRepre )
				
		//nSaldo	:= ( (nCtaNovo + nCtaSubiu) - nCtaDesceu )  
		
		/*
		Aadd(aDados, { cRepre,;		//1
					cNomeRepre,;   	//2
					nCtaNovo,;     	//3
					nCtaSubiu,;    	//4
					nCtaDesceu,;   	//5
					nSaldo,;     	//6
					cSuper,;		//7
					cNomeSuper,;	//8
					cMailSuper } )  //9
				 
		nRegTot++ 
		*/
		//////////////////////////////////////////////////////////////////////////////////////////////
		//Return ( { cCli, cLj, cNomeCli, dUltima, dPenultima, nValUltima, nValPenult, lReat } ) 
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		cQuery  := "Select A1_COD, A1_LOJA, A1_NREDUZ, A1_ULTCOM, A1_VEND " + LF 
		cQuery += " ,A3_SUPER,A3_COD " + LF
		
		cQuery += " FROM " 
		cQuery += " " + RetSqlName("SA3") + " SA3, " + LF
		cQuery += " " + RetSqlName("SA1") + " SA1 " + LF
					
		cQuery += " WHERE " + LF
				
		cQuery += " A1_VEND = A3_COD " + LF
		cQuery += " AND A3_COD = '" + Alltrim(cRepre) + "' "+LF
		cQuery += " AND A1_SATIV1 <> '000009' " + LF
		
		cQuery += " AND A1_ULTCOM >= '" + DtoS(dDatabase - 121) + "' " + LF 
		////VER A ÚLTIMA COMPRA SE FOI NO MÊS ATUAL, SE SIM, AVALIAR SE FOI A PRIMEIRA, SE SIM, É NOVO
		
		cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
		cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
						
		cQuery += " GROUP BY A1_COD, A1_LOJA, A3_COD, A3_SUPER, A1_ULTCOM, A1_VEND, A1_NREDUZ " + LF 
		cQuery += " ORDER BY A1_ULTCOM, A1_COD, A1_LOJA " + LF 
		//Memowrite("C:\Temp\novo_reatrepre.sql",cQuery)
		If Select("SF2A") > 0
			DbSelectArea("SF2A")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "SF2A"
		TcSetField("SF2A", "A1_ULTCOM", "D")
		
		SF2A->( DBGoTop() )
		While SF2A->( !EOF() )
		
			cCli := SF2A->A1_COD
			cLj	 := SF2A->A1_LOJA 
			cNomeCli := SF2A->A1_NREDUZ
			dUltima := Ctod("  /  /    ")
			dPenultima := Ctod("  /  /    ")
			nQtas:= 0
			lReat:= .F.
			nValUltima:= 0
			nValPenult:= 0
			nNovo := 0
			nInat := 0 
			nReat := 0
			
			    
			If !Empty(SF2A->A1_ULTCOM)
				    
			   	cQuery  := "Select TOP 2 F2_CLIENTE, F2_LOJA, F2_EMISSAO , F2_VALBRUT" + LF 
				cQuery += " FROM " + RetSqlName("SF2") + " SF2, " + LF
				cQuery += " "+ RetSqlName("SD2") + " SD2, " + LF
				cQuery += " "+ RetSqlName("SF4") + " SF4 " + LF		
				cQuery += " WHERE " + LF
				cQuery += " (D2_DOC+D2_SERIE) = (F2_DOC+F2_SERIE) "+ LF
				cQuery += " AND (D2_TES) = (F4_CODIGO) "+ LF 
				cQuery += " AND SD2.D2_TES NOT IN ('540' , '516') " + LF
				cQuery += " AND (F4_DUPLIC) = 'S' " + LF
				cQuery += " AND (F2_CLIENTE)  = '" + Alltrim(cCli) + "' " +LF  
				cQuery += " AND (F2_LOJA) = '" + Alltrim(cLj) + "' "+LF
				cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
				cQuery += " AND SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"+ LF
				cQuery += " AND SF4.D_E_L_E_T_ = '' AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"+ LF
				cQuery += " AND F2_TIPO = 'N' "+LF
				cQuery += " AND F2_SERIE <> '' "+LF
				cQuery += " GROUP BY F2_CLIENTE,F2_LOJA,F2_EMISSAO, F2_VALBRUT " + LF
				cQuery += " ORDER BY F2_EMISSAO DESC " + LF
				MemoWrite("C:\Temp\compras10.sql",cQuery) 
				If Select("TSF2") > 0
					DbSelectArea("TSF2")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "TSF2"
				TcSetField("TSF2", "F2_EMISSAO", "D")
				TSF2->( DBGoTop() )
			
			    If TSF2->( !EOF() )						    	    	     	    	
			    	dUltima := TSF2->F2_EMISSAO	  //dUComp2 -> última compra					                 
			    	nValUltima:= TSF2->F2_VALBRUT
				Endif 
			
				TSF2->( DBGoTop() )
				While TSF2->( !EOF() )
								    
				    dPenultima := TSF2->F2_EMISSAO	  //dUComp  -> penúltima compra
				    nValPenult := TSF2->F2_VALBRUT
					DbSelectArea("TSF2")
					nQtas++
					TSF2->(DBSKIP())
					
				Enddo		
			
				////VERIFICA SE É NOVO
				
				If nQtas = 1
					If !Empty(dUltima)
						If (dDatabase - dUltima) <= 30
							nNovo++
						Endif
					Endif
					dPenultima := Ctod("  /  /    ")
					nValPenult := 0
				////verifica se foi reativado	
				ElseIf !Empty(dUltima) .and. !Empty(dPenultima)		
					If (dUltima - dPenultima) >= 91         //se sim, verifica a diferença entre a última compra e a penúltima é maior q 3 meses?					
					    nReat++
					    lReat := .T.		
					Endif
				Endif
				
				
				If !lReat
					////VERIFICA SE FOI INATIVADO
					If !Empty(dUltima)
						If ( (dDatabase - dUltima) >= 91 .and. (dDatabase - dUltima) <= 121 )
							nInat++
						Endif
					Endif
				Endif
			
						
			Endif  //IF DO A1_ULTCOM VAZIO
					
			DbSelectArea("SF2A")
			SF2A->(DBSKIP())
			If nReat > 0
				cSituaca := "R"
				
			Elseif nNovo > 0 
				cSituaca:= "N"
				
			Elseif nInat > 0
				cSituaca := "I"
				
			Else
				If !Empty(dUltima) .or. !Empty(dPenultima)
					cSituaca := "A"
				Else
					cSituaca := "X"
				Endif
			Endif
			
			//If cSituaca != "X"
			If mv_par02 = 2 //só novos
			
				If cSituaca = "N"
					Aadd(aDados, { cRepre,;			//1
							cNomeRepre,;   		//2
							cCli,;     	//3    COD CLI
							cLj,;    	//4    LJ CLI
							cNomeCli,;   		//5    NOME CLI
							dUltima,;     	//6    DT ULTIMA COMPRA
							cSuper,;			//7    SUPER
							cNomeSuper,;		//8    NOME SUPER
							cMailSuper,;		//9    MAIL SUPER
							dPenultima,;		//10   DT PENULTIMA COMPRA
							cSituaca ,; //11     REATIVADO = SIM/NÃO
							nValUltima ,;		//12  VALOR ULT COMPRA
							nValPenult })		//13  VALOR PENULTIMA COMPRA
				Endif
			
			Elseif mv_par02 = 3 //só reativados
			
				If cSituaca = "R"
					Aadd(aDados, { cRepre,;			//1
							cNomeRepre,;   		//2
							cCli,;     	//3    COD CLI
							cLj,;    	//4    LJ CLI
							cNomeCli,;   		//5    NOME CLI
							dUltima,;     	//6    DT ULTIMA COMPRA
							cSuper,;			//7    SUPER
							cNomeSuper,;		//8    NOME SUPER
							cMailSuper,;		//9    MAIL SUPER
							dPenultima,;		//10   DT PENULTIMA COMPRA
							cSituaca ,; //11     REATIVADO = SIM/NÃO
							nValUltima ,;		//12  VALOR ULT COMPRA
							nValPenult })		//13  VALOR PENULTIMA COMPRA
				Endif
			
			Elseif mv_par02 = 4	//só inativos
			
				If cSituaca = "I"
					Aadd(aDados, { cRepre,;			//1
							cNomeRepre,;   		//2
							cCli,;     	//3    COD CLI
							cLj,;    	//4    LJ CLI
							cNomeCli,;   		//5    NOME CLI
							dUltima,;     	//6    DT ULTIMA COMPRA
							cSuper,;			//7    SUPER
							cNomeSuper,;		//8    NOME SUPER
							cMailSuper,;		//9    MAIL SUPER
							dPenultima,;		//10   DT PENULTIMA COMPRA
							cSituaca ,; //11     REATIVADO = SIM/NÃO
							nValUltima ,;		//12  VALOR ULT COMPRA
							nValPenult })		//13  VALOR PENULTIMA COMPRA
				Endif
				
			Elseif mv_par02 = 1		//todos
								
					Aadd(aDados, { cRepre,;			//1
							cNomeRepre,;   		//2
							cCli,;     	//3    COD CLI
							cLj,;    	//4    LJ CLI
							cNomeCli,;   		//5    NOME CLI
							dUltima,;     	//6    DT ULTIMA COMPRA
							cSuper,;			//7    SUPER
							cNomeSuper,;		//8    NOME SUPER
							cMailSuper,;		//9    MAIL SUPER
							dPenultima,;		//10   DT PENULTIMA COMPRA
							cSituaca ,; //11     REATIVADO = SIM/NÃO
							nValUltima ,;		//12  VALOR ULT COMPRA
							nValPenult })		//13  VALOR PENULTIMA COMPRA
				
				
			Endif
			
		Enddo
		
			//Aadd(aResultado, { nNovo, nReat } )     	
		
		//Return( { nNovo, nReat, nInat } )
		//Return ( { cCli, cLj, cNomeCli, dUltima, dPenultima, nValUltima, nValPenult, lReat } ) 
		/*
		Aadd(aDados, { cRepre,;			//1
					cNomeRepre,;   		//2
					aResult[1],;     	//3    COD CLI
					aResult[2],;    	//4    LJ CLI
					aResult[3],;   		//5    NOME CLI
					aResult[4],;     	//6    DT ULTIMA COMPRA
					cSuper,;			//7    SUPER
					cNomeSuper,;		//8    NOME SUPER
					cMailSuper,;		//9    MAIL SUPER
					aResult[5],;		//10   DT PENULTIMA COMPRA
					iif(aResult[8] = .T., 'Sim','Nao') ,; //11     REATIVADO = SIM/NÃO
					aResult[6] ,;		//12  VALOR ULT COMPRA
					aResult[7] })		//13  VALOR PENULTIMA COMPRA
		 */			

		
		RESU->(DBSKIP())
	
	Enddo
Endif 

//msgbox("Registros: " + str(nRegTot))
aDados   := Asort( aDados,,, { |X,Y| X[7] + X[1]  <  Y[7] + Y[1] } ) 

If lDentroSiga
	SetRegua( nRegTot )	
	//ProcRegua(nRegTot)
Endif


nPag   := 1
cTexto := ""
frX	   := 1
cSuper := ""
nTotNovo:= 0
nTotReat:= 0
nTotInat:= 0
nTotSaldo:= 0			


Do while frX <= Len(aDados)
	
	cSuper := aDados[frX,7]
	cNomeSuper := Alltrim(aDados[frX,8])
	cMailsuper := Alltrim(aDados[frX,9])
	cRepre		:= Alltrim(aDados[frX,1])
	cNomeRepre  := Alltrim(aDados[frX,2])
	//////////////////
	/////CRIA O HTML
	/////////////////
	cDirHTM  := "\Temp\"    
	cArqHTM  := "REL_06_"+ Alltrim(cSuper) + ".HTM"    //relatório P/ Gerentes
	nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
	nPag     := 1    
	If nHandle = -1
	     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif		
			
	nPag := 1
	nLinhas := 80
				
	cTexto := ""
	cTexto += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
	////div para quebrar página automaticamente
	cTexto += '<style type="text/css">'+LF
	cTexto += '.quebra_pagina {'+LF
	cTexto += 'page-break-after:always;'+LF
	cTexto += 'font-size:10px;'+LF
	cTexto += 'font-style:italic;'+LF
	cTexto += '	color:#F00;'+LF
	cTexto += '	padding:5px 0;'+LF
	cTexto += '	text-align:center;'+LF
	cTexto += '}'+LF
	cTexto += 'p {text-align:right;'+LF
	cTexto += '}'+LF
	cTexto += '</style>'+LF
	//////////	
									
	
		///Cabeçalho PÁGINA
		cTexto += '<html><head>'+ LF
		cTexto += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
		cTexto += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
		cTexto += '<tr>    <td>'+ LF
		cTexto += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
		///linha fina
		cTexto += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
		cTexto += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					
		cTexto += '<tr>' + LF
		cTexto += '<td>SIGA /FATR023-02/v.P10</td>'+ LF
		cTexto += '<td align="LEFT">' + titulo + '</td>'+ LF
		cTexto += '<td align="right">DT.Ref.: ' + Dtoc(dDatabase) + '</td>'+ LF
		cTexto += '</tr>'+LF
						
		cTexto += '<tr>'+ LF
		cTexto += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
		cTexto += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+LF
						
		///linha fina
		cTexto += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
		cTexto += '</table></head>'+ LF
		
		cTexto += '<table width="1300" border="0" style="font-size:15px;font-family:Arial">'+LF				
		cTexto += '<td width="500"><div align="Left"><span class="style3"><b>Coordenador: </b>'+ Alltrim(cSuper) + " - " + Alltrim(cNomeSuper) + '</span></td></tr>'+LF
		
		cTexto += '<td width="500"><div align="Left"><span class="style3"><b>E-mail: </b>'+ Alltrim(cMailSuper) + '</span></div></td></tr>'+LF 
		
		//cTexto += '<td width="500"><div align="Left"><span class="style3"><b>Representante: </b>'+ Alltrim(cRepre) + " - " + Alltrim(cNomeRepre) + '</span></td></tr>'+LF
				
		////linha em branco
		cTexto += '<table width="500" border="0" style="font-size:15px;font-family:Arial"><strong>'+ LF
		cTexto += '<tr>'+LF
		cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
		cTexto += '</tr>'+LF
		cTexto += '</table>' + LF
							     
							
		///Cabeçalho RESUMO		      
		cTexto += '<table width="1000" border="1" style="font-size:15px;font-family:Arial"><strong>'+ LF
		cTexto += '<td width="210" font-family: Arial><div align="center"><span class="style3" style="font-size:14px"><B>RESUMO DA MOVIMENTACAO</span></div></B></td>'+ LF
		cTexto += '</tr></table>'+LF
			
		cTexto += '<table width="1000" border="1" style="font-size:14px;font-family:Arial"><strong>'+ LF
		cTexto += '<td width="210"><span class="style3"><b>REPRES.</b></span></td>'+LF   
		cTexto += '<td width="210"><span class="style3"><b>CLIENTE</b></span></td>'+LF   
		
		cTexto += '<td width="210" align="center"><b>PENULTIMA COMPRA</b></span></td>'+LF   
		cTexto += '<td width="210" align="center"><b>VLR PENULT COMPRA</b></span></td>'+LF   
		cTexto += '<td width="210" align="center"><b>ULTIMA COMPRA</b></span></td>'+LF   
		cTexto += '<td width="210" align="center"><b>VLR ULTIMA COMPRA</b></span></td>'+LF 		
		cTexto += '<td width="210" align="center"><b>SITUACAO</b></span></td>'+LF 		
		cTexto += '</tr>' + LF                                                  
		
		/*
	Aadd(aDados, { cRepre,;			//1
					cNomeRepre,;   		//2
					cCli,;     	//3    COD CLI
					cLj,;    	//4    LJ CLI
					cNomeCli,;   		//5    NOME CLI
					dUltima,;     	//6    DT ULTIMA COMPRA
					cSuper,;			//7    SUPER
					cNomeSuper,;		//8    NOME SUPER
					cMailSuper,;		//9    MAIL SUPER
					dPenultima,;		//10   DT PENULTIMA COMPRA
					cSituaca ,; //11     REATIVADO = SIM/NÃO
					aResult[6] ,;		//12  VALOR ULT COMPRA
					aResult[7] })		//13  VALOR PENULTIMA COMPRA
					
		*/
		
		Do while frX <= Len(aDados) .and. Alltrim(aDados[frX,7]) == Alltrim(cSuper)
	
				cTexto += '<tr>' + LF
				cTexto += '<td width="300" align="left"><span class="style3">' + Alltrim(aDados[frX,1]) + "-" + Alltrim(aDados[frX,2])  + '</span></td>'+LF 	//nome do repre
				cTexto += '<td width="300" align="left"><span class="style3">' + Alltrim(aDados[frX,3]) + "/" + Alltrim(aDados[frX,4])  + " - "+ Alltrim(aDados[frX,5]) +'</span></td>'+LF 	//nome do repre
				cTexto += '<td width="50" align="right"><span class="style3">' + Dtoc( aDados[frX,10])  + '</span></td>'+LF 	//dt penult
				cTexto += '<td width="50" align="right"><span class="style3">' + Transform( aDados[frX,13], "@E 9,999,999.99")  + '</span></td>'+LF	//vlr penult
				cTexto += '<td width="50" align="right"><span class="style3">' + Dtoc( aDados[frX,6])  + '</span></td>'+LF    //dt ultima
				cTexto += '<td width="50" align="right"><span class="style3">' + Transform( aDados[frX,12], "@E 9,999,999.99")  + '</span></td>'+LF 	//vlr ultima
				If Alltrim( aDados[frX,11]) = "N"
					cStatus := "NOVO"
				Elseif Alltrim( aDados[frX,11]) = "R"
					cStatus := "REATIVADO"
				Elseif Alltrim( aDados[frX,11]) = "I"
					cStatus := "INATIVO"
				Elseif Alltrim( aDados[frX,11]) = "A"
					cStatus := "ATIVO"
				Endif
				
				cTexto += '<td width="50" align="right"><span class="style3">' + Alltrim( cStatus )  + '</span></td>'+LF 	//REATIVADO?
				cTexto += '</tr>'+LF
				
				///acumuladores do total geral
				//nTotReat+= aDados[frX,4]
				//nTotNovo+= aDados[frX,3] 
				//nTotInat+= aDados[frX,5]
				//nTotSaldo+= aDados[frX,6]
				
				If Alltrim( aDados[frX,11]) = "R"
					nTotReat++
				Elseif Alltrim( aDados[frX,11]) = "N"
					nTotNovo++
				ElseIf Alltrim( aDados[frX,11]) = "I"
					nTotInat++					
				Endif
				
		
			frX++
			If lDentroSiga
				IncRegua()	
			Endif
			 
		
		Enddo
		cTexto += '</table>' + LF
		
		cTexto += '<table width="300" border="1" style="font-size:14px;font-family:Arial"><strong>'+ LF
		cTexto += '<tr>' + LF
		cTexto += '<td width="100" colspan="2" align="CENTER"><span class="style3"><b>TOTAL GERAL</b></span></td></tr>'+LF
		 
		cTexto += '<tr>' + LF
		cTexto += '<td width="100" align="LEFT"><span class="style3"><b>NOVOS -></b></span></td>'+LF
		cTexto += '<td width="50" align="right"><span class="style3"><b>' + Transform( nTotNovo, "@E 9,999")  + '</b></span></td>'+LF 	//novos
		cTexto += '</tr>' + LF
		cTexto += '<td width="100" align="LEFT"><span class="style3"><b>REATIVADOS -></b></span></td>'+LF
		cTexto += '<td width="50" align="right"><span class="style3"><b>' + Transform( nTotReat, "@E 9,999")  + '</b></span></td>'+LF	//reativados
		cTexto += '</tr>' + LF
		cTexto += '<td width="100" align="LEFT"><span class="style3"><b>INATIVOS -></b></span></td>'+LF
		cTexto += '<td width="50" align="right"><span class="style3"><b>' + Transform( nTotInat, "@E 9,999")  + '</b></span></td>'+LF    //inativados
		cTexto += '</tr>' + LF
		cTexto += '<td width="100" align="LEFT"><span class="style3"><b>SALDO -></b></span></td>'+LF
		cTexto += '<td width="50" align="right"><span class="style3"><b>' + Transform( (nTotNovo + nTotReat) - nTotInat, "@E 9,999") + '</b></span></td>'+LF 	//saldo
		cTexto += '</tr>'+LF	
		
		cTexto += '</table>' + LF
		        
	////linha em branco
	cTexto += '<table width="500" border="0" style="font-size:14px;font-family:Arial"><strong>'+ LF
	cTexto += '<tr>'+LF
	cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
	cTexto += '</tr>'+LF
	cTexto += '</table>' + LF
				
	////linha em branco
	cTexto += '<table width="500" border="0" style="font-size:14px;font-family:Arial"><strong>'+ LF
	cTexto += '<tr>'+LF
	cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
	cTexto += '</tr>'+LF
	cTexto += '</table>' + LF
	
	////linha em branco
	cTexto += '<table width="500" border="0" style="font-size:14px;font-family:Arial"><strong>'+ LF
	cTexto += '<tr>'+LF
	cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
	cTexto += '</tr>'+LF
	cTexto += '</table>' + LF
	
	////linha em branco
	cTexto += '<table width="500" border="0" style="font-size:14px;font-family:Arial"><strong>'+ LF
	cTexto += '<tr>'+LF
	cTexto += '<td width="1100" colspan="14" height="12"><span class="style3"><b></span></td>'+LF
	cTexto += '</tr>'+LF
	cTexto += '</table>' + LF
							        
	///faz o rodapé
	cTexto += '<table border="0" cellspacing="0" cellpadding="0" width="95%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
	cTexto += '    <tr>'+LF
	cTexto += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
	cTexto += '    </tr>'+LF
	cTexto += '    <tr>'+LF
	cTexto += '      <td id="colArial">Microsiga&nbsp;Software&nbsp;S/A</td>'+LF
	cTexto += '      <td id="colArial">&nbsp;</td>'+LF
	cTexto += '      <td id="colArial" align="right">-&nbsp;Hora&nbsp;Termino:&nbsp;' + Time() + '</td>'+LF
	cTexto += '    </tr>'+LF
	cTexto += '    <tr>'+LF
	cTexto += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
	cTexto += '    </tr>'+LF
	cTexto += '  </table>'+LF  
				
				
	/////FECHA O HTML PARA GRAVAÇÃO E ENVIO
	cTexto += '</body> '
	cTexto += '</html> '
	/////GRAVA O HTML
	Fwrite( nHandle, cTexto, Len(cTexto) )
	FClose( nHandle )
				
					
	//////SELECIONA O EMAIL DESTINATÁRIO
	If lDentroSiga
				
		cCodUser := __CUSERID     
		//se for dentro do Siga a emissão do relatório, captura o login do usuário para enviar o relatório ao e-mail do mesmo
		PswOrder(1)
		If PswSeek( cCoduser, .T. )
		   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
		   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
		   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
		   cMailTo	 := Alltrim(aUsua[1][14])		// Email do usuário
		Endif
		cCopia := ""			
	
	Else
		//cMailTo := cMailSuper 
		cMailTo := "flavia.rocha@ravaembalagens.com.br"  
		//cCopia  := "marcos@ravaembalagens.com.br"
		//cCopia  += ";josenildo@ravaembalagens.com.br"  
		//cCopia  += ";janaina@ravaembalagens.com.br" 
		cCopia := ""
		cCopia  += ";flavia.rocha@ravaembalagens.com.br" 
	 
	Endif
				
	cCorpo  := titulo + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
	cAnexo  := cDirHTM + cArqHTM
	cAssun  := titulo
				
	//////ENVIA O HTML COMO ANEXO			
	U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo )
							
	
Enddo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	MsgInfo("Rel 06 - Você recebeu um e-mail deste Relatório.")
Endif

If !lDentroSiga
	// Habilitar somente para Schedule
	Reset environment
Endif


Return
        


////VER SE O CLIENTE É NOVO e se foi REATIVADO ( 2 VERIFICAÇÕES EM 1)
**********************************************
Static Function fNovo_Reat(cRepre)  
***********************************************

Local cCli := ""
Local cLj  := ""
Local nQtas:= 0
Local cCliAnt := ""
Local cLjAnt  := ""
Local cQuery  := ""
Local dUltima := Ctod("  /  /    ")
Local dPenultima := Ctod("  /  /    ") 
Local nNovo	:= 0
Local nReat := 0 
Local nInat := 0
Local aResultado := {}
Local nMes 
Local lReat	:= .F.
Local cNomeCli := ""


cQuery  := "Select A1_COD, A1_LOJA, A1_NREDUZ, A1_ULTCOM, A1_VEND " + LF 
cQuery += " ,A3_SUPER,A3_COD " + LF

cQuery += " FROM " 
cQuery += " " + RetSqlName("SA3") + " SA3, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 " + LF
			
cQuery += " WHERE " + LF
		
cQuery += " A1_VEND = A3_COD " + LF
cQuery += " AND A3_COD = '" + Alltrim(cRepre) + "' "+LF
cQuery += " AND A1_SATIV1 <> '000009' " + LF

cQuery += " AND A1_ULTCOM >= '" + DtoS(dDatabase - 121) + "' " + LF 
////VER A ÚLTIMA COMPRA SE FOI NO MÊS ATUAL, SE SIM, AVALIAR SE FOI A PRIMEIRA, SE SIM, É NOVO

cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
				
cQuery += " GROUP BY A1_COD, A1_LOJA, A3_COD, A3_SUPER, A1_ULTCOM, A1_VEND, A1_NREDUZ " + LF 
cQuery += " ORDER BY A1_ULTCOM, A1_COD, A1_LOJA " + LF 
//Memowrite("C:\Temp\novo_reatrepre.sql",cQuery)
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()
EndIf
TCQUERY cQuery NEW ALIAS "SF2A"
TcSetField("SF2A", "A1_ULTCOM", "D")

SF2A->( DBGoTop() )
While SF2A->( !EOF() )

	cCli := SF2A->A1_COD
	cLj	 := SF2A->A1_LOJA 
	cNomeCli := SF2A->A1_NREDUZ
	dUltima := Ctod("  /  /    ")
	dPenultima := Ctod("  /  /    ")
	nQtas:= 0
	lReat:= .F.
	nValUltima:= 0
	nValPenult:= 0
	    
	If !Empty(SF2A->A1_ULTCOM)
		    
	   	cQuery  := "Select TOP 2 F2_CLIENTE, F2_LOJA, F2_EMISSAO , F2_VALBRUT" + LF 
		cQuery += " FROM " + RetSqlName("SF2") + " SF2, " + LF
		cQuery += " "+ RetSqlName("SD2") + " SD2, " + LF
		cQuery += " "+ RetSqlName("SF4") + " SF4 " + LF		
		cQuery += " WHERE " + LF
		cQuery += " (D2_DOC+D2_SERIE) = (F2_DOC+F2_SERIE) "+ LF
		cQuery += " AND (D2_TES) = (F4_CODIGO) "+ LF 
		cQuery += " AND SD2.D2_TES NOT IN ('540' , '516') " + LF
		cQuery += " AND (F4_DUPLIC) = 'S' " + LF
		cQuery += " AND (F2_CLIENTE)  = '" + Alltrim(cCli) + "' " +LF  
		cQuery += " AND (F2_LOJA) = '" + Alltrim(cLj) + "' "+LF
		cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
		cQuery += " AND SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"+ LF
		cQuery += " AND SF4.D_E_L_E_T_ = '' AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"+ LF
		cQuery += " AND F2_TIPO = 'N' "+LF
		cQuery += " AND F2_SERIE <> '' "+LF
		cQuery += " GROUP BY F2_CLIENTE,F2_LOJA,F2_EMISSAO " + LF
		cQuery += " ORDER BY F2_EMISSAO DESC " + LF
		//MemoWrite("C:\Temp\novo_reatrepre2.sql",cQuery) 
		If Select("TSF2") > 0
			DbSelectArea("TSF2")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "TSF2"
		TcSetField("TSF2", "F2_EMISSAO", "D")
		TSF2->( DBGoTop() )
	
	    If TSF2->( !EOF() )						    	    	     	    	
	    	dUltima := TSF2->F2_EMISSAO	  //dUComp2 -> última compra					                 
	    	nValUltima:= TSF2->F2_VALBRUT
		Endif 
	
		TSF2->( DBGoTop() )
		While TSF2->( !EOF() )
						    
		    dPenultima := TSF2->F2_EMISSAO	  //dUComp  -> penúltima compra
		    nValPenult := TSF2->F2_VALBRUT
			DbSelectArea("TSF2")
			nQtas++
			TSF2->(DBSKIP())
			
		Enddo		
	
		////VERIFICA SE É NOVO
		
		If nQtas = 1
			If !Empty(dUltima)
				If (dDatabase - dUltima) <= 30
					nNovo++
				Endif
			Endif
			dPenultima := Ctod("  /  /    ")
			nValPenult := 0
		////verifica se foi reativado	
		ElseIf !Empty(dUltima) .and. !Empty(dPenultima)		
			If (dUltima - dPenultima) >= 91         //se sim, verifica a diferença entre a última compra e a penúltima é maior q 3 meses?					
			    nReat++
			    lReat := .T.		
			Endif
		Endif
		
		
		If !lReat
			////VERIFICA SE FOI INATIVADO
			If !Empty(dUltima)
				If ( (dDatabase - dUltima) >= 91 .and. (dDatabase - dUltima) <= 121 )
					nInat++
				Endif
			Endif
		Endif
	
				
	Endif  //IF DO A1_ULTCOM VAZIO
			
	DbSelectArea("SF2A")
	SF2A->(DBSKIP())
	
Enddo

	//Aadd(aResultado, { nNovo, nReat } )     	

//Return( { nNovo, nReat, nInat } )
Return ( { cCli, cLj, cNomeCli, dUltima, dPenultima, nValUltima, nValPenult, lReat } ) 

/*
**********************************************
Static Function fInativo(cRepre)  
***********************************************

Local cCli := ""
Local cLj  := ""
Local nQtas:= 0
Local cCliAnt := ""
Local cLjAnt  := ""
Local cQuery  := ""
Local dUltima := Ctod("  /  /    ")
Local dPenultima := Ctod("  /  /    ") 
Local nNovo	:= 0
Local nReat := 0 
Local nInat := 0
Local aResultado := {}



cQuery  := "Select count(A1_COD+A1_LOJA) AS QTINAT " + LF 

cQuery += " FROM " 
cQuery += " " + RetSqlName("SA3") + " SA3, " + LF
cQuery += " " + RetSqlName("SA1") + " SA1 " + LF
			
cQuery += " WHERE " + LF
		
cQuery += " RTRIM( A1_VEND ) = RTRIM(A3_COD) " + LF
cQuery += " AND RTRIM(A3_COD) = '" + Alltrim(cRepre) + "' "+LF
cQuery += " AND A1_ULTCOM >= '" + DtoS(dDatabase - 120) + "' and A1_ULTCOM <= '" + DtoS(dDatabase - 91) + "' "+ LF			
////VER A ÚLTIMA COMPRA SE FOI NO MÊS ATUAL, SE SIM, AVALIAR SE FOI A PRIMEIRA, SE SIM, É NOVO

cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
				
cQuery += " GROUP BY (A1_COD+A1_LOJA) " + LF
//Memowrite("C:\Temp\INATrepre.sql",cQuery)
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()
EndIf
TCQUERY cQuery NEW ALIAS "SF2A"
//TcSetField("SF2A", "A1_ULTCOM", "D")

SF2A->( DBGoTop() )
While SF2A->( !EOF() )
	///verifica se foi inativado		
	nInat += SF2A->QTINAT		
	DbSelectArea("SF2A")
	SF2A->(DBSKIP())
Enddo


Return( nInat )       
*/






