#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR019 - REL 05 - Relação de Prospects por representante
//Objetivo: RELATÓRIO DE PROSPECTS
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 13/09/2010
//--------------------------------------------------------------------------
/*/

********************************
User Function FATR019()
********************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	f19()		//envia para os representantes (um arquivo por vendedor)
  	f19Super()  //envia para os coordenadores (um arquivo por coordenador)
  
Else
  lDentroSiga := .T.
  f19Todos()
  
EndIf
  

Return

////um arquivo por vendedor
************************
Static Function f19() 
************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Prospects"
Local cPict          := ""
Local titulo         := "" 
Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR019" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR024" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR019"
Private cString := ""
Private nLin		 := 80

 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



titulo         := "RELATORIO 05 - CLIENTES PROSPECT'S (NUNCA COMPRARAM DA RAVA) POR REPRESENTANTE"

If lDentroSiga
	
	Pergunte("FATR019",.T.) 
	/*
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  	
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	nTipo := If(aReturn[4] == 1,15,18)
    */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar o Relatório de Prospects ? " )
		RptStatus({|| RunReportRe(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Endif
Else

	RunReportRe(Cabec1,Cabec2,Titulo,nLin)
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

Static Function RunReportRe(Cabec1,Cabec2,Titulo,nLin)        ///um arquivo por vendedor

Local nOrdem
Local cProspect	:= ""
Local cLoja   	:= ""
Local cNomeProsp:= ""
Local aProsp	:= {}
Local cVendedor := ""
Local cNomeVend := ""
Local cMailVend := ""
Local cMailSuper:= ""
Local cSegmento	:= ""
Local cNomeSeg	:= ""
Local cSegAnt	:= ""
Local cNomeSegAnt:= ""

Local nLinhas	:= 80 
Local cWeb		:= "" 
Local nPag		:= 1

Local nPag := 1   
Local nLinhas := 80
Local cWeb	:= ""
Local nCta	:= 1

Local cMailTo := ""
Local cCopia  := ""
Local cCorpo  := ""
Local cAnexo  := ""
Local cAssun  := ""
Local nHandle := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery	:=''
Local LF		:= CHR(13) + CHR(10)
Local cCopia	:= ""
Local cCorpo	:= ""
Local cAnexo	:= ""
Local cAssun	:= ""
Local cMailTo	:= ""


cQuery := " SELECT A3_COD,US_VEND, A3_NREDUZ, A3_SUPER,A3_EMAIL " + LF
cQuery += " ,US_COD, US_LOJA, US_NOME, US_NREDUZ, US_TIPO, US_END" + LF
cQuery += " ,US_MUN, US_BAIRRO, US_CEP, US_EST, US_TEL, US_EMAIL" + LF
cQuery += " ,US_SATIV, US_STATUS" + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SUS") + " SUS  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "+LF

cQuery += " WHERE US_VEND = A3_COD " + LF
cQuery += " AND US_STATUS NOT IN ('5', '6') " +LF 
cQuery += " AND US_SATIV <> '000009' " + LF  
cQuery += " AND US_VEND <> '' " + LF  

If lDentroSiga
	cQuery += " AND RTRIM(A3_COD) >= '" + Alltrim(MV_PAR01) + "' AND RTRIM(A3_COD) <= '" + Alltrim(MV_PAR02) + "' " + LF 
	//cQuery += " AND RTRIM(A3_SUPER) >= '" + Alltrim(MV_PAR03) + "' AND RTRIM(A3_SUPER) <= '" + Alltrim(MV_PAR04) + "' " + LF 
	//cQuery += " AND RTRIM(US_EST) = '" + Alltrim(MV_PAR05) + "' " + LF 
	//cQuery += " AND RTRIM(US_SATIV) = '" + Alltrim(MV_PAR06) + "' " + LF 
Endif

cQuery += " AND SUS.US_FILIAL = '" + xFilial("SUS") + "' AND SUS.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF

cQuery += "  ORDER BY A3_SUPER, US_VEND, US_MUN, US_COD, US_LOJA  " + LF

//MemoWrite("C:\Temp\FATR019.sql", cQuery )

If Select("SUSX") > 0
	DbSelectArea("SUSX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SUSX"

//TCSetField( "SUSX", "E1_EMISSAO", "D")

SUSX->( DbGoTop() )
/* 
Status do Prospect

1 = Classificado
2 = Desenvolvimento
3 = Gerente
4 = Stand by
5 = Cancelado
6 = Cliente

*/
Do While SUSX->( !EOF() )

	cVendedor := SUSX->US_VEND
	cSegmento := SUSX->US_SATIV
	cNomeVend := SUSX->A3_NREDUZ
	cMailVend := SUSX->A3_EMAIL
	cSuper	  := SUSX->A3_SUPER
	cNomeSuper := ""
	cMailSuper := ""
	
	SA3->(DBSETORDER(1))
	If SA3->(Dbseek(xFilial("SA3") + cSuper))
		cNomeSuper := Alltrim(SA3->A3_NOME)
		cMailSuper := Alltrim(SA3->A3_EMAIL)
	Endif
	
	cProspect	:= SUSX->US_COD
	cLoja   	:= SUSX->US_LOJA
	cNomeProsp	:= SUSX->US_NOME 
	cEndereco 	:= SUSX->US_END
	cUF			:= SUSX->US_EST
	cCidade		:= SUSX->US_MUN
	cMailProsp 	:= SUSX->US_EMAIL
	cTel		:= SUSX->US_TEL
	cStat		:= SUSX->US_STATUS
	
	Do Case
		Case cStat = "1"
			cStatus := "Classificado"
			
		Case cStat = "2"
			cStatus := "Em desenvolvimento"
			
		Case cStat = "3"
			cStatus := "Gerente"
			
		Case cStat = "4"
			cStatus := "Stand by"
			
		Case cStat = "5"
			cStatus := "Cancelado"
		
		Case cStat = "6"
			cStatus := "Cliente"
	Endcase

	
	Aadd(aProsp, { cVendedor,;			//1
					cNomeVend,;			//2
					cMailVend,;			//3
					 cSegmento,;       	//4
					 cProspect,;       	//5
					 cLoja,;        	//6
					 cNomeProsp,;      	//7
					 cEndereco,;       	//8
					 cCidade,;         	//9
					 cUF,;       		//10
					 cTel,;       		//11
					 cMailProsp,;       //12
					 cSuper,;         	//13
					 cNomeSuper,;      	//14
					 cStatus,; 			//15
					 cMailSuper } )		//16
	SUSX->(DBSKIP())
 
Enddo


aProsp := Asort( aProsp,,, { |X,Y| X[1] + X[9] <  Y[1] + Y[9]  } ) 

DbSelectArea("SUSX")
DbCloseArea()



nCta		:= 1
cVendedor	:= ""
cNomeVend	:= ""
cSegmento	:= ""
cDirHTM		:= ""
cArqHTM		:= ""

If Len(aProsp) > 0

                		
	Do while nCta <= Len(aProsp)						
	
			cVendedor := aProsp[nCta,1]
			cNomeVend := Alltrim(aProsp[nCta,2]) 
			cMailVend := Alltrim(aProsp[nCta,3])
			cMailSuper:= Alltrim(aProsp[nCta,16])
			
						
			////CRIA O ARQUIVO DO HTML
			cDirHTM  := "\Temp\"    
			cArqHTM  := "PROSP_" + Alltrim(cVendedor) + ".HTM"   
			nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			
			If nHandle = -1
			     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif
			
			nLinhas := 80
			nPag	:= 1
			
			cWeb := ""
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
	   	
		   	////div para quebrar página automaticamente
			cWeb += '<style type="text/css">'+LF
			cWeb += '.quebra_pagina {'+LF
			cWeb += 'page-break-after:always;'+LF
			cWeb += 'font-size:10px;'+LF
			cWeb += 'font-style:italic;'+LF
			cWeb += '	color:#F00;'+LF
			cWeb += '	padding:5px 0;'+LF
			cWeb += '	text-align:center;'+LF
			cWeb += '}'+LF
			cWeb += 'p {text-align:right;'+LF
			cWeb += '}'+LF
			cWeb += '</style>'+LF
			//////////
		//Endif	
		
		   				
		If nLinhas >= 45
				
			nLinhas := 5			
		    ///Cabeçalho PÁGINA
	      	cWeb += '<html>'+LF
			cWeb += '<head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR019/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				
			cWeb += '</table></head>'+ LF            
					
		  	cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF				
			
			//cWeb += '<td width="600"><div align="Left"><span class="style3"><strong>Data: ' + Dtoc(dDatabase) + '</strong></span></div></td>'+ LF
			//cWeb += '</tr>'+LF	//encerra a linha e dá início a uma nova
			cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(aProsp[nCta,1]) + " - " + Alltrim(aProsp[nCta,2]) + '</strong></span></div></td>'+LF
			cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
			cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,3]) + '</span></div></td>'+LF
			cWeb += '</tr>'+LF
			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
			
			cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Coordenador: ' + Alltrim(aProsp[nCta,13]) + " - " + Alltrim(aProsp[nCta,14]) + /* " -> " + aProsp[nCta,16] + */ '</strong></span></div></td>'+LF
			cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
			nLinhas++
			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
						
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
										
			cWeb += '</table>' + LF
			nLinhas++
						
		    ///Cabeçalho relatório		      
			cWeb += '<table width="1200" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
			//cWeb += '<td width="300"><div align="center"><span class="style3"><b>STATUS</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>CODIGO PROSPECT</span></div></b></td>'+LF
			cWeb += '<td width="600"><div align="center"><span class="style3"><b>NOME PROSPECT</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>SEGMENTO</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>CIDADE</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>ESTADO</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>E-MAIL</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>TELEFONE</span></div></b></td>'+LF
					
			cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
				
			nLinhas++
			nLinhas++		   
			nPag++
			
		Endif

			Do while nCta <= Len(aProsp) .and. Alltrim(aProsp[nCta,1]) = Alltrim(cVendedor)
			
				cSegmento := aProsp[nCta,4]
				cNomeSeg  := ""
				SX5->(Dbsetorder(1))
				If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
					cNomeSeg := Alltrim(SX5->X5_DESCRI)
					
				Endif 
			
								 
				////IMPRESSÃO DOS DADOS...	 		
				
				//cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(aProsp[nCta,15]) + '</span></td>'+LF      		//status
				cWeb += '<td width="300" align="left"><span class="style3">' + aProsp[nCta,5] + "/" + aProsp[nCta,6]+ '</span></td>'+LF  	//cod.cliente/loja
				cWeb += '<td width="900" align="left"><span class="style3">' + Alltrim(Substr(aProsp[nCta,7],1,20))+ ' </span></td>'+LF     //nome cliente
				cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(cNomeSeg) + '</span></td>'+LF      				//segmento
				cWeb += '<td width="100" align="left"><span class="style3">' + Alltrim(aProsp[nCta,9]) + ' </span></td>'+LF        			//cidade
				cWeb += '<td width="50" align="center"><span class="style3">' + Alltrim(aProsp[nCta,10])  + '</span></td>'+LF  	//UF
				cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(aProsp[nCta,12])+' </span></td>'+LF        	//e-mail
				cWeb += '<td width="300" align="left"><span class="style3">' + Alltrim(aProsp[nCta,11])  + '</span></td>'+LF  		//telefone
									
				cWeb += '</tr>'+LF
																	
				nLinhas++		 
							 
				nCta++			 		
			
			Enddo 		
			
			//mudou o representante
						
			cWeb += '</table>'+LF
			
			
			cWeb += '<br>'+LF
			cWeb += '<br>'+LF
			nLinhas++
			
			///faz o rodapé
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="85%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
			cWeb += '    <tr>'+LF
			cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
			cWeb += '    </tr>'+LF
			cWeb += '    <tr>'+LF
			cWeb += '      <td id="colArial">Microsiga&nbsp;Software&nbsp;S/A</td>'+LF
			cWeb += '      <td id="colArial">&nbsp;</td>'+LF
			cWeb += '      <td id="colArial" align="right">-&nbsp;Hora&nbsp;Termino:&nbsp;' + Time() + '</td>'+LF
			cWeb += '    </tr>'+LF
			cWeb += '    <tr>'+LF
			cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
			cWeb += '    </tr>'+LF
			cWeb += '  </table>'+LF
						
			///FECHA O HTML PARA ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
							
			//////GRAVA O HTML 
			Fwrite( nHandle, cWeb, Len(cWeb) )
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
					
			Else			
				//cMailTo := "flavia.rocha@ravaembalagens.com.br"
				cMailTo := Alltrim(cMailVend)
			Endif
		
					
			cCopia  := ""  //"flavia.rocha@ravaembalagens.com.br"
			cCorpo  := titulo
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo										
			U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
				
			cWeb := ""
						
		
	Enddo
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	MsgInfo("Rel 05 - PROSPECTS - Você recebeu este Relatório em seu e-mail.")
//Else
	// Habilitar somente para Schedule
	//Reset environment            //tirei daqui pois está executando na sequência o f19 e o f19super
Endif

Return 

*****************************
Static Function f19Super()
*****************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Prospects"
Local cPict          := ""
Local titulo         := "" 
Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR019" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR019" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR019"
Private cString := ""
Private nLin		 := 80

 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



titulo         := "RELATORIO 05 - CLIENTES PROSPECT'S (NUNCA COMPRARAM DA RAVA) POR REPRESENTANTE"

If lDentroSiga
	
	Pergunte("FATR019",.T.)
	/* 
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  	
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	nTipo := If(aReturn[4] == 1,15,18)
    */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar o Relatório de Prospects ? " )
		RptStatus({|| RunReportSu(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Endif
Else

	RunReportSu(Cabec1,Cabec2,Titulo,nLin)
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

Static Function RunReportSu(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cProspect	:= ""
Local cLoja   	:= ""
Local cNomeProsp:= ""
Local aProsp	:= {}
Local cVendedor := ""
Local cNomeVend := ""
Local cMailVend := ""
Local cMailSuper:= ""
Local cSegmento	:= ""
Local cNomeSeg	:= ""
Local cSegAnt	:= ""
Local cNomeSegAnt:= ""

Local nLinhas	:= 80 
Local cWeb		:= "" 
Local nPag		:= 1

Local nPag := 1   
Local nLinhas := 80
Local cWeb	:= ""
Local nCta	:= 1

Local cMailTo := ""
Local cCopia  := ""
Local cCorpo  := ""
Local cAnexo  := ""
Local cAssun  := ""
Local nHandle := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery	:=''
Local LF		:= CHR(13) + CHR(10)
Local cCopia	:= ""
Local cCorpo	:= ""
Local cAnexo	:= ""
Local cAssun	:= ""
Local cMailTo	:= ""
Local cVendAnt  := ""


cQuery := " SELECT A3_COD,US_VEND, A3_NREDUZ, A3_SUPER,A3_EMAIL " + LF
cQuery += " ,US_COD, US_LOJA, US_NOME, US_NREDUZ, US_TIPO, US_END " + LF
cQuery += " ,US_MUN, US_BAIRRO, US_CEP, US_EST, US_TEL, US_EMAIL  " + LF
cQuery += " ,US_SATIV, US_STATUS " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SUS") + " SUS  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "+LF

cQuery += " WHERE US_VEND = A3_COD " + LF
cQuery += " AND US_STATUS NOT IN ('5', '6') " +LF
cQuery += " AND US_SATIV <> '000009' " + LF  
cQuery += " AND US_VEND <> '' " + LF  
If lDentroSiga
	cQuery += " AND RTRIM(A3_COD) >= '" + Alltrim(MV_PAR01) + "' AND RTRIM(A3_COD) <= '" + Alltrim(MV_PAR02) + "' " + LF
	cQuery += " AND RTRIM(A3_SUPER) >= '" + Alltrim(MV_PAR03) + "' AND RTRIM(A3_SUPER) <= '" + Alltrim(MV_PAR04) + "' " + LF 
	
	If !Empty(MV_PAR05)
		cQuery += " AND RTRIM(US_EST) = '" + Alltrim(MV_PAR05) + "' " + LF 
	Endif
	If !Empty(MV_PAR06)
		cQuery += " AND RTRIM(US_SATIV) = '" + Alltrim(MV_PAR06) + "' " + LF  
	Endif
Endif

cQuery += " AND SUS.US_FILIAL = '" + xFilial("SUS") + "' AND SUS.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF

cQuery += "  ORDER BY A3_SUPER, US_VEND, US_COD, US_LOJA " + LF

//MemoWrite("C:\Temp\FATR019.sql", cQuery )

If Select("SUSX") > 0
	DbSelectArea("SUSX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SUSX"

//TCSetField( "SUSX", "E1_EMISSAO", "D")

SUSX->( DbGoTop() )
/* 
Status do Prospect

1 = Classificado
2 = Desenvolvimento
3 = Gerente
4 = Stand by
5 = Cancelado
6 = Cliente

*/
Do While SUSX->( !EOF() )

	cVendedor := SUSX->US_VEND
	cSegmento := SUSX->US_SATIV
	cNomeVend := SUSX->A3_NREDUZ
	cMailVend := SUSX->A3_EMAIL
	cSuper	  := SUSX->A3_SUPER
	cNomeSuper := ""
	cMailSuper := ""
	
	SA3->(DBSETORDER(1))
	If SA3->(Dbseek(xFilial("SA3") + cSuper))
		cNomeSuper := Alltrim(SA3->A3_NOME)
		cMailSuper := Alltrim(SA3->A3_EMAIL)
	Endif
	
	cProspect	:= SUSX->US_COD
	cLoja   	:= SUSX->US_LOJA
	cNomeProsp	:= SUSX->US_NOME 
	cEndereco 	:= SUSX->US_END
	cUF			:= SUSX->US_EST
	cCidade		:= SUSX->US_MUN
	cMailProsp 	:= SUSX->US_EMAIL
	cTel		:= SUSX->US_TEL
	cStat		:= SUSX->US_STATUS
	
	Do Case
		Case cStat = "1"
			cStatus := "Classificado"
			
		Case cStat = "2"
			cStatus := "Em desenvolvimento"
			
		Case cStat = "3"
			cStatus := "Gerente"
			
		Case cStat = "4"
			cStatus := "Stand by"
			
		Case cStat = "5"
			cStatus := "Cancelado"
		
		Case cStat = "6"
			cStatus := "Cliente"
	Endcase

	
	Aadd(aProsp, { cVendedor,;			//1
					cNomeVend,;			//2
					cMailVend,;			//3
					 cSegmento,;       	//4
					 cProspect,;       	//5
					 cLoja,;        	//6
					 cNomeProsp,;      	//7
					 cEndereco,;       	//8
					 cCidade,;         	//9
					 cUF,;       		//10
					 cTel,;       		//11
					 cMailProsp,;       //12
					 cSuper,;         	//13
					 cNomeSuper,;      	//14
					 cStatus,; 			//15
					 cMailSuper } )		//16
	SUSX->(DBSKIP())
 
Enddo


//aProsp := Asort( aProsp,,, { |X,Y| X[13] + X[9] + X[2] <  Y[13] + Y[9] + Y[2]  } ) 

aProsp := Asort( aProsp,,, { |X,Y| X[13] + X[9] + X[1] <  Y[13] + Y[9] + Y[1]  } ) 

DbSelectArea("SUSX")
DbCloseArea()



nCta		:= 1
cVendedor	:= ""
cNomeVend	:= ""
cSegmento	:= ""
cDirHTM		:= ""
cArqHTM		:= ""
cVendAnt	:= ""

If Len(aProsp) > 0

                		
	Do while nCta <= Len(aProsp)						
	
			cSuper	  := Alltrim(aProsp[nCta,13])			
			cMailSuper:= Alltrim(aProsp[nCta,16])
			//cVendedor := aProsp[nCta,1]
			//If nCta = 1
			//	cVendAnt := cVendedor
			//Endif
						
			////CRIA O ARQUIVO DO HTML
			cDirHTM  := "\Temp\"    
			cArqHTM  := "REL05_" + Alltrim(cSuper) + ".HTM"   
			nHandle := fCreate( cDirHTM + cArqHTM, 0 )
			
			If nHandle = -1
			     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
			     Return
			Endif
			
			//nLinhas := 80
			nPag	:= 1
			
			cWeb := ""
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
	   	
		   	////div para quebrar página automaticamente
			cWeb += '<style type="text/css">'+LF
			cWeb += '.quebra_pagina {'+LF
			cWeb += 'page-break-after:always;'+LF
			cWeb += 'font-size:10px;'+LF
			cWeb += 'font-style:italic;'+LF
			cWeb += '	color:#F00;'+LF
			cWeb += '	padding:5px 0;'+LF
			cWeb += '	text-align:center;'+LF
			cWeb += '}'+LF
			cWeb += 'p {text-align:right;'+LF
			cWeb += '}'+LF
			cWeb += '</style>'+LF
			//////////
		//Endif	
		
		   				
		If nLinhas >= 35		
				
			nLinhas := 5			
		    ///Cabeçalho PÁGINA
	      	cWeb += '<html>'+LF
			cWeb += '<head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="95%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR019/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				
			cWeb += '</table></head>'+ LF	
			
			//nPag++            
			
			If nCta = 1		
			  	cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF				
				
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(aProsp[nCta,1]) + " - " + Alltrim(aProsp[nCta,2]) + '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
				cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,3]) + '</span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++
				
				cVendAnt := aProsp[nCta,1]
				
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
				
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Coordenador: ' + Alltrim(aProsp[nCta,13]) + " - " + Alltrim(aProsp[nCta,14]) + /* " -> " + aProsp[nCta,16] + */ '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
				nLinhas++
				cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,16]) + '</span></div></td>'+LF
				cWeb += '</tr>'+LF
				nLinhas++
			
			
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
							
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
				
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
											
				cWeb += '</table>' + LF
				nLinhas++
							
			    ///Cabeçalho relatório		      
				cWeb += '<table width="1200" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
				//cWeb += '<td width="300"><div align="center"><span class="style3"><b>STATUS</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>CODIGO PROSPECT</span></div></b></td>'+LF
				cWeb += '<td width="600"><div align="center"><span class="style3"><b>NOME PROSPECT</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>SEGMENTO</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>CIDADE</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>ESTADO</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>E-MAIL</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>TELEFONE</span></div></b></td>'+LF
								
				cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
				nLinhas++
				nLinhas++			
				
			Endif
			
			
		Endif

			//Do while nCta <= Len(aProsp) .and. Alltrim(aProsp[nCta,1]) = Alltrim(cVendedor)
			Do while nCta <= Len(aProsp) .and. Alltrim(aProsp[nCta,13]) = Alltrim(cSuper)
				
				cVendedor := aProsp[nCta,1]				
				cNomeVend := Alltrim(aProsp[nCta,2]) 
				cMailVend := Alltrim(aProsp[nCta,3])	
				
			
							
				If nLinhas >= 35		
				
				
					nLinhas := 5			
				    ///Cabeçalho PÁGINA
			      	cWeb += '<html>'+LF
					cWeb += '<head>'+ LF
					cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
					cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
					cWeb += '<tr>    <td>'+ LF
					cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="95%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
					cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					cWeb += '<tr>        <td>SIGA /FATR019/v.P10</td>'+ LF
					cWeb += '<td align="center">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
					cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
					cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
						
					cWeb += '</table></head>'+ LF            
							
				  	If nCta > 1
					  	cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF				
										
						cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(aProsp[nCta,1]) + " - " + Alltrim(aProsp[nCta,2]) + '</strong></span></div></td>'+LF
						cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
						nLinhas++
						cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,3]) + '</span></div></td>'+LF
						cWeb += '</tr>'+LF
				        nLinhas++
				        
						////linha em branco
						cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
						nLinhas++
						
						cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Coordenador: ' + Alltrim(aProsp[nCta,13]) + " - " + Alltrim(aProsp[nCta,14]) + /* " -> " + aProsp[nCta,16] + */ '</strong></span></div></td>'+LF
						cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova 
						nLinhas++
						cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,16]) + '</span></div></td>'+LF
						cWeb += '</tr>'+LF
						nLinhas++
					
					
						////linha em branco
						cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
						nLinhas++
									
						////linha em branco
						cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
						nLinhas++
						
						////linha em branco
						cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
						nLinhas++
											
						cWeb += '</table>' + LF
						nLinhas++
								
					    ///Cabeçalho relatório		      
						cWeb += '<table width="1200" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
						//cWeb += '<td width="300"><div align="center"><span class="style3"><b>STATUS</span></div></b></td>'+LF
						cWeb += '<td width="300"><div align="center"><span class="style3"><b>CODIGO PROSPECT</span></div></b></td>'+LF
						cWeb += '<td width="600"><div align="center"><span class="style3"><b>NOME PROSPECT</span></div></b></td>'+LF
						cWeb += '<td width="300"><div align="center"><span class="style3"><b>SEGMENTO</span></div></b></td>'+LF
						cWeb += '<td width="300"><div align="center"><span class="style3"><b>CIDADE</span></div></b></td>'+LF
						cWeb += '<td width="300"><div align="center"><span class="style3"><b>ESTADO</span></div></b></td>'+LF
						cWeb += '<td width="300"><div align="center"><span class="style3"><b>E-MAIL</span></div></b></td>'+LF
						cWeb += '<td width="300"><div align="center"><span class="style3"><b>TELEFONE</span></div></b></td>'+LF
								
						cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
					
						nLinhas++
						nLinhas++		   
						//nPag++
						
					Endif
			
		Endif
				
				
				If nCta > 1 
				 If Alltrim(cVendedor) != Alltrim(cVendAnt)				 
				 				
					cWeb += '</table>'+LF
					
					///Quebra página
					cWeb += '<div class="quebra_pagina"></div>'+LF
					//cWeb += '<div class="quebra_pagina">A pagina quebra aqui:' + Str(nLinhas) + ' </div>'+LF
						
					//nPag++
					
					///Cabeçalho PÁGINA
			      	cWeb += '<html>'+LF
					cWeb += '<head>'+ LF
					cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
					cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
					cWeb += '<tr>    <td>'+ LF
					cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="95%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
					cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
					cWeb += '<tr>        <td>SIGA /FATR019/v.P10</td>'+ LF
					cWeb += '<td align="center">' + titulo + '</td>'+ LF
					cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
					cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
					cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
					cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
						
					cWeb += '</table></head>'+ LF            
					nLinhas := 5	
					nPag++		   
						
				   	//Endif										
					
					cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF
					////linha em branco
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
					nLinhas++
					
					////linha em branco
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
					nLinhas++
					
					////linha em branco
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
					nLinhas++					
				
					cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(aProsp[nCta,1]) + " - " + Alltrim(aProsp[nCta,2]) + '</strong></span></div></td>'+LF
					cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
					nLinhas++
					
					cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,3]) + '</span></div></td>'+LF
					cWeb += '</tr>'+LF
				    nLinhas++
					
					////linha em branco
					cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
					nLinhas++
					
					cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Coordenador: ' + Alltrim(aProsp[nCta,13]) + " - " + Alltrim(aProsp[nCta,14]) + '</strong>- E-Mail: ' + Alltrim(cMailSuper) + '</span></div></td>'+LF
					cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
					nLinhas++
					
					cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,16]) + '</span></div></td>'+LF
					cWeb += '</tr>'+LF
				    nLinhas++
																					
					cWeb += '</table>' + LF
					nLinhas++
								
				    ///Cabeçalho relatório		      
					cWeb += '<table width="1200" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
					//cWeb += '<td width="300"><div align="center"><span class="style3"><b>STATUS</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>CODIGO PROSPECT</span></div></b></td>'+LF
					cWeb += '<td width="600"><div align="center"><span class="style3"><b>NOME PROSPECT</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>SEGMENTO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>CIDADE</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>ESTADO</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>E-MAIL</span></div></b></td>'+LF
					cWeb += '<td width="300"><div align="center"><span class="style3"><b>TELEFONE</span></div></b></td>'+LF
							
					cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha					
						
					nLinhas++
					nLinhas++		   
				    
				    cVendAnt := cVendedor
				    
				    
				    
				 Endif
				Endif
			
				cSegmento := aProsp[nCta,4]
				cNomeSeg  := ""
				SX5->(Dbsetorder(1))
				If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
					cNomeSeg := Alltrim(SX5->X5_DESCRI)
					
				Endif 
			
								 
				////IMPRESSÃO DOS DADOS...	 		
				
				//cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(aProsp[nCta,15]) + '</span></td>'+LF      		//status
				cWeb += '<td width="300" align="left"><span class="style3">' + aProsp[nCta,5] + "/" + aProsp[nCta,6]+ '</span></td>'+LF  	//cod.cliente/loja
				cWeb += '<td width="900" align="left"><span class="style3">' + Alltrim(Substr(aProsp[nCta,7],1,20))+ ' </span></td>'+LF     //nome cliente
				cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(cNomeSeg) + '</span></td>'+LF      				//segmento
				cWeb += '<td width="100" align="left"><span class="style3">' + Alltrim(aProsp[nCta,9]) + ' </span></td>'+LF        			//cidade
				cWeb += '<td width="50" align="center"><span class="style3">' + Alltrim(aProsp[nCta,10])  + '</span></td>'+LF  	//UF
				cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(aProsp[nCta,12])+' </span></td>'+LF        	//e-mail
				cWeb += '<td width="300" align="left"><span class="style3">' + Alltrim(aProsp[nCta,11])  + '</span></td>'+LF  		//telefone
									
				cWeb += '</tr>'+LF
																	
				nLinhas++		 
							 
				nCta++			 		
			
			Enddo 		
			
			//mudou o representante
						
			cWeb += '</table>'+LF
			
			
			cWeb += '<br>'+LF
			cWeb += '<br>'+LF
			nLinhas++
			
			///faz o rodapé
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
			cWeb += '    <tr>'+LF
			cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
			cWeb += '    </tr>'+LF
			cWeb += '    <tr>'+LF
			cWeb += '      <td id="colArial">Microsiga&nbsp;Software&nbsp;S/A</td>'+LF
			cWeb += '      <td id="colArial">&nbsp;</td>'+LF
			cWeb += '      <td id="colArial" align="right">-&nbsp;Hora&nbsp;Termino:&nbsp;' + Time() + '</td>'+LF
			cWeb += '    </tr>'+LF
			cWeb += '    <tr>'+LF
			cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
			cWeb += '    </tr>'+LF
			cWeb += '  </table>'+LF
						
			///FECHA O HTML PARA ENVIO
			cWeb += '</body> '
			cWeb += '</html> '
							
			//////GRAVA O HTML 
			Fwrite( nHandle, cWeb, Len(cWeb) )
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
					
			Else			
				//cMailTo := "flavia.rocha@ravaembalagens.com.br"
				cMailTo := Alltrim(cMailSuper)  
			Endif
		
					
			cCopia  := ""  //"flavia.rocha@ravaembalagens.com.br"
			cCorpo  := titulo
			cAnexo  := cDirHTM + cArqHTM
			cAssun  := titulo										
			U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
				
			cWeb := ""
						
		
	Enddo
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	//Msginfo("FATR024 - Processo finalizado")
	MsgInfo("Rel 05 - Você recebeu o e-mail deste Relatório.")
Else
	// Habilitar somente para Schedule
	Reset environment
Endif

Return     

///o mesmo relatório, só que para emitir dentro do Siga

********************************
User Function FATR019A()
********************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Prospects"
Local cPict          := ""
Local titulo         := "" 
Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR019A" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR019A" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR019"
Private cString := ""
Private nLinha		 := 80 

titulo         := "RELATORIO 05 - CLIENTES PROSPECT'S (NUNCA COMPRARAM DA RAVA) POR REPRESENTANTE"

Cabec1         := "CÓDIGO/LOJA      NOME                     SEGMENTO                            CIDADE                      ESTADO       E-MAIL                                               TELEFONE"
Cabec2		   := "PROSPECT         PROSPECT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("FATR019",.T.) 
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

RptStatus({|| RunReport2(Cabec1,Cabec2,Titulo,nLinha) },Titulo)
Return
   


*******************************************************
Static Function RunReport2(Cabec1,Cabec2,Titulo,nLinha)
*******************************************************

Local nOrdem
Local cProspect	:= ""
Local cLoja   	:= ""
Local cNomeProsp:= ""
Local aProsp	:= {}
Local cVendedor := ""
Local cNomeVend := ""
Local cMailVend := ""
Local cSegmento	:= ""
Local cNomeSeg	:= ""
Local cSegAnt	:= ""
Local cNomeSegAnt:= ""

Local nCta	:= 1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery	:=''
Local LF		:= CHR(13) + CHR(10) 


cQuery := " SELECT A3_COD,US_VEND, A3_NREDUZ, A3_SUPER,A3_EMAIL " + LF
cQuery += " ,US_COD, US_LOJA, US_NOME, US_NREDUZ, US_TIPO, US_END" + LF
cQuery += " ,US_MUN, US_BAIRRO, US_CEP, US_EST, US_TEL, US_EMAIL" + LF
cQuery += " ,US_SATIV, US_STATUS" + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SUS") + " SUS  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "+LF

cQuery += " WHERE US_VEND = A3_COD " + LF
cQuery += " AND RTRIM(US_STATUS) NOT IN ('5', '6') " +LF

///vendedor de/até
cQuery += " AND RTRIM(A3_COD) >= '" + Alltrim(MV_PAR01) + "' AND RTRIM(A3_COD) <= '" + Alltrim(MV_PAR02) + "' " + LF
///coordenador de/até
cQuery += " AND RTRIM(A3_SUPER) >= '" + Alltrim(MV_PAR03) + "' AND RTRIM(A3_SUPER) <= '" + Alltrim(MV_PAR04) + "' " + LF 
If !Empty(MV_PAR05)
	cQuery += " AND RTRIM(US_EST) = '" + Alltrim(MV_PAR05) + "' " + LF 
Endif

If !Empty(MV_PAR06)
	cQuery += " AND RTRIM(US_SATIV) = '" + Alltrim(MV_PAR06) + "' " + LF  
Endif

cQuery += " AND SUS.US_FILIAL = '" + xFilial("SUS") + "' AND SUS.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF


cQuery += "  ORDER BY A3_SUPER, US_VEND, US_COD, US_LOJA " + LF

//MemoWrite("C:\Temp\FATR019.sql", cQuery )

If Select("SUSX") > 0
	DbSelectArea("SUSX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SUSX"

//TCSetField( "SUSX", "E1_EMISSAO", "D")

SUSX->( DbGoTop() )
/* 
Status do Prospect

//1 = Classificado
//2 = Desenvolvimento
//3 = Gerente
//4 = Stand by
//5 = Cancelado
//6 = Cliente
*/

Do While SUSX->( !EOF() )

	cVendedor := SUSX->US_VEND
	cSegmento := SUSX->US_SATIV
	cNomeVend := SUSX->A3_NREDUZ
	cMailVend := SUSX->A3_EMAIL
	cSuper	  := SUSX->A3_SUPER
	cNomeSuper := ""
	cMailSuper := ""
	
	SA3->(DBSETORDER(1))
	If SA3->(Dbseek(xFilial("SA3") + cSuper))
		cNomeSuper := Alltrim(SA3->A3_NOME)
		cMailSuper := Alltrim(SA3->A3_EMAIL)
	Endif
	
	cProspect	:= SUSX->US_COD
	cLoja   	:= SUSX->US_LOJA
	cNomeProsp	:= SUSX->US_NOME 
	cEndereco 	:= SUSX->US_END
	cUF			:= SUSX->US_EST
	cCidade		:= SUSX->US_MUN
	cMailProsp 	:= SUSX->US_EMAIL
	cTel		:= SUSX->US_TEL
	cStat		:= SUSX->US_STATUS
	
	Do Case
		Case cStat = "1"
			cStatus := "Classificado"
			
		Case cStat = "2"
			cStatus := "Em desenvolvimento"
			
		Case cStat = "3"
			cStatus := "Gerente"
			
		Case cStat = "4"
			cStatus := "Stand by"
			
		Case cStat = "5"
			cStatus := "Cancelado"
		
		Case cStat = "6"
			cStatus := "Cliente"
	Endcase

	
	Aadd(aProsp, { cVendedor,;			//1
					cNomeVend,;			//2
					cMailVend,;			//3
					 cSegmento,;       	//4
					 cProspect,;       	//5
					 cLoja,;        	//6
					 cNomeProsp,;      	//7
					 cEndereco,;       	//8
					 cCidade,;         	//9
					 cUF,;       		//10
					 cTel,;       		//11
					 cMailProsp,;       //12
					 cSuper,;         	//13
					 cNomeSuper,;      	//14
					 cStatus,; 			//15
					 cMailSuper } ) 	//16
	SUSX->(DBSKIP())
 
Enddo


aProsp := Asort( aProsp,,, { |X,Y| X[1] + X[9] <  Y[1] + Y[9]  } ) 

DbSelectArea("SUSX")
DbCloseArea()



nCta		:= 1
cVendedor	:= ""
cNomeVend	:= ""
cSegmento	:= ""


If Len(aProsp) > 0
	//msginfo("entrou no array")
                		
	Do while nCta <= Len(aProsp) 
	
		If nLinha > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	    	nLinha := 8
	    	nLinha++
	   	Endif
		
		cVendedor := aProsp[nCta,1]
		cNomeVend := Alltrim(aProsp[nCta,2]) 
		cMailVend := Alltrim(aProsp[nCta,3])
		
		cSuper	  := Alltrim(aProsp[nCta,13])
		cNomeSuper:= Alltrim(aProsp[nCta,14])
		cMailSuper:= Alltrim(aProsp[nCta,16])
		
		@nLinha,000 PSAY "Representante: " + Alltrim(cVendedor) + " - " + cNomeVend + "  - E-mail: " + cMailVend
		nLinha++
		@nLinha,000 PSAY "Coordenador  : " + cSuper + " - " + cNomeSuper + "  - E-mail: " + cMailSuper
		nLinha++
		//@nLinha,000 PSAY Replicate("-",limite)
		nLinha++
	
		Do while nCta <= Len(aProsp) .and. Alltrim(aProsp[nCta,1]) = Alltrim(cVendedor)
			
			If nLinha > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		    	nLinha := 8
		    	nLinha++
		   	Endif
			
			cSegmento := aProsp[nCta,4]
			cNomeSeg  := ""
			SX5->(Dbsetorder(1))
			If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
				cNomeSeg := Alltrim(SX5->X5_DESCRI)
			Endif 
			
				 
				 
		//codigo      nome prospect          segmento                              cidade                           estado    e-mail                                                telefone
		//999999/99   XXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XX       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    99-9999-9999
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22	 
				
				////IMPRESSÃO DOS DADOS...	 		
				@nLinha,000 PSAY aProsp[nCta,5] + "/" + aProsp[nCta,6]  	//cod.PROSPECT/LOJA
				@nLinha,018 PSAY Alltrim(Substr(aProsp[nCta,7],1,20))     //nome cliente
				@nLinha,041 PSAY Substr(Alltrim(cNomeSeg),1,35)			//segmento
				@nLinha,079 PSAY Substr(Alltrim(aProsp[nCta,9]),1,30)		//cidade
				@nLinha,113 PSAY Alltrim(aProsp[nCta,10])					//UF
				@nLinha,122 PSAY Alltrim(aProsp[nCta,12])		        	//e-mail
				@nLinha,176 PSAY Alltrim(aProsp[nCta,11])					//telefone									
				//@nLinha,116 PSAY "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"		        	//e-mail
				//@nLinha,170 PSAY "99-9999-9999"					//telefone									
																			
				nLinha++		 
							 
				nCta++			 		
			
			Enddo 
			
			nLinha++
			@nLinha,000 PSAY Replicate("-",limite)							
			nLinha++
		
	Enddo
	Roda( 0, "", TAMANHO )
Endif

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

Return



*****************************
Static Function f19Todos()
*****************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rel. Prospects"
Local cPict          := ""
Local titulo         := "" 
Local Cabec1         := "" 
Local Cabec2		 :=	""
Local cWeb			 := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR019" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR019" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "FATR019"
Private cString := ""
Private nLin		 := 80

 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



titulo         := "RELATORIO 05 - CLIENTES PROSPECT'S (NUNCA COMPRARAM DA RAVA) POR REPRESENTANTE"

If lDentroSiga
	
	Pergunte("FATR019",.T.)
	/* 
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  	
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	nTipo := If(aReturn[4] == 1,15,18)
    */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If MsgYesNo("Deseja Gerar o Relatório de Prospects ? " )
		RptStatus({|| RunReportTo(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Endif
Else

	RunReportTo(Cabec1,Cabec2,Titulo,nLin)
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

Static Function RunReportTo(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cProspect	:= ""
Local cLoja   	:= ""
Local cNomeProsp:= ""
Local aProsp	:= {}
Local cVendedor := ""
Local cNomeVend := ""
Local cMailVend := ""
Local cMailSuper:= ""
Local cSegmento	:= ""
Local cNomeSeg	:= ""
Local cSegAnt	:= ""
Local cNomeSegAnt:= ""

Local nLinhas	:= 80 
Local cWeb		:= "" 
Local nPag		:= 1

Local nLinhas := 80
Local cWeb	:= ""
Local nCta	:= 1

Local cMailTo := ""
Local cCopia  := ""
Local cCorpo  := ""
Local cAnexo  := ""
Local cAssun  := ""
Local nHandle := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery	:=''
Local LF		:= CHR(13) + CHR(10)
Local cCopia	:= ""
Local cCorpo	:= ""
Local cAnexo	:= ""
Local cAssun	:= ""
Local cMailTo	:= ""
Local cVendAnt  := "" 
Local cDirHTM	:= ""
Local cArqHTM   := ""


cQuery := " SELECT A3_COD,US_VEND, A3_NREDUZ, A3_SUPER,A3_EMAIL " + LF
cQuery += " ,US_COD, US_LOJA, US_NOME, US_NREDUZ, US_TIPO, US_END " + LF
cQuery += " ,US_MUN, US_BAIRRO, US_CEP, US_EST, US_TEL, US_EMAIL " + LF
cQuery += " ,US_SATIV, US_STATUS " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SUS") + " SUS  WITH (NOLOCK),  "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "+LF

cQuery += " WHERE US_VEND = A3_COD " + LF
cQuery += " AND RTRIM(US_STATUS) NOT IN ('5', '6') " +LF

If lDentroSiga
	cQuery += " AND RTRIM(A3_COD) >= '" + Alltrim(MV_PAR01) + "' AND RTRIM(A3_COD) <= '" + Alltrim(MV_PAR02) + "' " + LF
	cQuery += " AND RTRIM(A3_SUPER) >= '" + Alltrim(MV_PAR03) + "' AND RTRIM(A3_SUPER) <= '" + Alltrim(MV_PAR04) + "' " + LF 
	
	If !Empty(MV_PAR05)
		cQuery += " AND RTRIM(US_EST) = '" + Alltrim(MV_PAR05) + "' " + LF 
	Endif
	If !Empty(MV_PAR06)
		cQuery += " AND RTRIM(US_SATIV) = '" + Alltrim(MV_PAR06) + "' " + LF  
	Endif
Endif

cQuery += " AND SUS.US_FILIAL = '" + xFilial("SUS") + "' AND SUS.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = ''  "+LF

cQuery += "  ORDER BY A3_SUPER, US_VEND, US_COD, US_LOJA " + LF

//MemoWrite("C:\Temp\FATR019_todos.sql", cQuery )

If Select("SUSX") > 0
	DbSelectArea("SUSX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SUSX"

//TCSetField( "SUSX", "E1_EMISSAO", "D")

SUSX->( DbGoTop() )
/* 
Status do Prospect

1 = Classificado
2 = Desenvolvimento
3 = Gerente
4 = Stand by
5 = Cancelado
6 = Cliente

*/

Do While SUSX->( !EOF() )

	cVendedor := SUSX->US_VEND
	cSegmento := SUSX->US_SATIV
	cNomeVend := SUSX->A3_NREDUZ
	cMailVend := SUSX->A3_EMAIL
	cSuper	  := SUSX->A3_SUPER
	cNomeSuper := ""
	cMailSuper := ""
	
	SA3->(DBSETORDER(1))
	If SA3->(Dbseek(xFilial("SA3") + cSuper))
		cNomeSuper := Alltrim(SA3->A3_NOME)
		cMailSuper := Alltrim(SA3->A3_EMAIL)
	Endif
	
	cProspect	:= SUSX->US_COD
	cLoja   	:= SUSX->US_LOJA
	cNomeProsp	:= SUSX->US_NOME 
	cEndereco 	:= SUSX->US_END
	cUF			:= SUSX->US_EST
	cCidade		:= SUSX->US_MUN
	cMailProsp 	:= SUSX->US_EMAIL
	cTel		:= SUSX->US_TEL
	cStat		:= SUSX->US_STATUS
	
	Do Case
		Case cStat = "1"
			cStatus := "Classificado"
			
		Case cStat = "2"
			cStatus := "Em desenvolvimento"
			
		Case cStat = "3"
			cStatus := "Gerente"
			
		Case cStat = "4"
			cStatus := "Stand by"
			
		Case cStat = "5"
			cStatus := "Cancelado"
		
		Case cStat = "6"
			cStatus := "Cliente"
	Endcase

	
	Aadd(aProsp, { cVendedor,;			//1
					cNomeVend,;			//2
					cMailVend,;			//3
					 cSegmento,;       	//4
					 cProspect,;       	//5
					 cLoja,;        	//6
					 cNomeProsp,;      	//7
					 cEndereco,;       	//8
					 cCidade,;         	//9
					 cUF,;       		//10
					 cTel,;       		//11
					 cMailProsp,;       //12
					 cSuper,;         	//13
					 cNomeSuper,;      	//14
					 cStatus,; 			//15
					 cMailSuper } )		//16
	SUSX->(DBSKIP())
 
Enddo


//aProsp := Asort( aProsp,,, { |X,Y| X[13] + X[9] + X[2] <  Y[13] + Y[9] + Y[2]  } ) 

aProsp := Asort( aProsp,,, { |X,Y| X[1] + X[9]  <  Y[1] + Y[9]  } ) 

DbSelectArea("SUSX")
DbCloseArea()



nCta		:= 1
cVendedor	:= ""
cNomeVend	:= ""
cSegmento	:= ""
cDirHTM		:= ""
cArqHTM		:= ""
nPag		:= 1

If Len(aProsp) > 0 
	////CRIA O ARQUIVO DO HTML
	cDirHTM  := "\Temp\"    
	cArqHTM  := "Prospects.HTM"   
	nHandle := fCreate( cDirHTM + cArqHTM, 0 ) 
	cWeb := ""
	If nHandle = -1
	     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
                		
	Do while nCta <= Len(aProsp)						
	
		If nCta = 1
			cVendAnt := cVendedor
		Endif
	
			cSuper	  := Alltrim(aProsp[nCta,13])			
			cMailSuper:= Alltrim(aProsp[nCta,16])
			
			cVendedor := aProsp[nCta,1]
			cNomeVend := Alltrim(aProsp[nCta,2]) 
			cMailVend := Alltrim(aProsp[nCta,3])	
				
			//nLinhas := 80
			//nPag	:= 1
			
			cWeb += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
	   	
		   	////div para quebrar página automaticamente
			cWeb += '<style type="text/css">'+LF
			cWeb += '.quebra_pagina {'+LF
			cWeb += 'page-break-after:always;'+LF
			cWeb += 'font-size:10px;'+LF
			cWeb += 'font-style:italic;'+LF
			cWeb += '	color:#F00;'+LF
			cWeb += '	padding:5px 0;'+LF
			cWeb += '	text-align:center;'+LF
			cWeb += '}'+LF
			cWeb += 'p {text-align:right;'+LF
			cWeb += '}'+LF
			cWeb += '</style>'+LF
			//////////			
		   				
		If nLinhas >= 35		
				
			nLinhas := 5			
		    ///Cabeçalho PÁGINA
	      	cWeb += '<html>'+LF
			cWeb += '<head>'+ LF
			cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
			cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
			cWeb += '<tr>    <td>'+ LF
			cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="95%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
			cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
			cWeb += '<tr>        <td>SIGA /FATR019/v.P10</td>'+ LF
			cWeb += '<td align="center">' + titulo + '</td>'+ LF
			cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
			cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
			cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
			cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
				
			cWeb += '</table></head>'+ LF		
					
		  	cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF				
				
			//cWeb += '<td width="600"><div align="Left"><span class="style3"><strong>Data: ' + Dtoc(dDatabase) + '</strong></span></div></td>'+ LF
			//cWeb += '</tr>'+LF	//encerra a linha e dá início a uma nova
			cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(aProsp[nCta,1]) + " - " + Alltrim(aProsp[nCta,2]) + '</strong></span></div></td>'+LF
			cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
			cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,3]) + '</span></div></td>'+LF
			cWeb += '</tr>'+LF
			nLinhas++
				
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
			
			cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Coordenador: ' + Alltrim(aProsp[nCta,13]) + " - " + Alltrim(aProsp[nCta,14]) + /* " -> " + aProsp[nCta,16] + */ '</strong></span></div></td>'+LF
			cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
			nLinhas++
			
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
							
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
				
			////linha em branco
			cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
			nLinhas++
										
			cWeb += '</table>' + LF
			nLinhas++
						
		    ///Cabeçalho relatório		      
			cWeb += '<table width="1200" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
			//cWeb += '<td width="300"><div align="center"><span class="style3"><b>STATUS</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>CODIGO PROSPECT</span></div></b></td>'+LF
			cWeb += '<td width="600"><div align="center"><span class="style3"><b>NOME PROSPECT</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>SEGMENTO</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>CIDADE</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>ESTADO</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>E-MAIL</span></div></b></td>'+LF
			cWeb += '<td width="300"><div align="center"><span class="style3"><b>TELEFONE</span></div></b></td>'+LF
							
			cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha			
			nLinhas++
			nLinhas++
			//nPag++
			
		Endif
				
		If nCta > 1 
			 If Alltrim(cVendedor) != Alltrim(cVendAnt)				 
			 	
			 	//mudou o representante
				cWeb += '</table>'+LF
				
				//cWeb += '<br>'+LF
				//cWeb += '<br>'+LF
				//nLinhas++
				//nLinhas++							
								

				///Quebra página
				cWeb += '<div class="quebra_pagina"></div>'+LF
				//cWeb += '<div class="quebra_pagina">A pagina quebra aqui:' + Str(nLinhas) + ' </div>'+LF
				nPag++
					
				///Cabeçalho PÁGINA
		      	cWeb += '<html>'+LF
				cWeb += '<head>'+ LF
				cWeb += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
				cWeb += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+ LF
				cWeb += '<tr>    <td>'+ LF
				cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="95%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(SM0->M0_NOMECOM)+'</td>  <td></td>'+ LF
				cWeb += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
				cWeb += '<tr>        <td>SIGA /FATR019/v.P10</td>'+ LF
				cWeb += '<td align="center">' + titulo + '</td>'+ LF
				cWeb += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td>        </tr>        <tr>          '+ LF
				cWeb += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
				cWeb += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
				cWeb += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
						
				cWeb += '</table></head>'+ LF            
				nLinhas := 5	
							   
							
				cWeb += '<table width="1200" border="0" style="font-size:11px;font-family:Arial">'+LF
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
					
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
				
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++					
				
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Representante: ' + Alltrim(aProsp[nCta,1]) + " - " + Alltrim(aProsp[nCta,2]) + '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
				cWeb += '<td width="900"><div align="Left"><span class="style3">E-Mail: '+ Alltrim(aProsp[nCta,3]) + '</span></div></td>'+LF
				cWeb += '</tr>'+LF
					
				////linha em branco
				cWeb += '<td width="150"><div align="Left"><span class="style3"><strong></strong></span></div></td></tr>'+LF
				nLinhas++
				
				cWeb += '<td width="900"><div align="Left"><span class="style3"><strong>Coordenador: ' + Alltrim(aProsp[nCta,13]) + " - " + Alltrim(aProsp[nCta,14]) + /* " -> " + aProsp[nCta,16] + */ '</strong></span></div></td>'+LF
				cWeb += '</tr>'+LF  //encerra a linha e dá início a uma nova
				nLinhas++
																					
				cWeb += '</table>' + LF
				nLinhas++
								
			    ///Cabeçalho relatório		      
				cWeb += '<table width="1200" border="1" style="font-size:11px;font-family:Arial"><strong>'+ LF
				//cWeb += '<td width="300"><div align="center"><span class="style3"><b>STATUS</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>CODIGO PROSPECT</span></div></b></td>'+LF
				cWeb += '<td width="600"><div align="center"><span class="style3"><b>NOME PROSPECT</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>SEGMENTO</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>CIDADE</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>ESTADO</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>E-MAIL</span></div></b></td>'+LF
				cWeb += '<td width="300"><div align="center"><span class="style3"><b>TELEFONE</span></div></b></td>'+LF
						
				cWeb += '</strong></tr>'+ LF   ///fecha a linha para iniciar uma próxima nova linha					
					
				nLinhas++
				nLinhas++		   
			    cVendAnt := cVendedor
				
			 Endif
		Endif
			
		cSegmento := aProsp[nCta,4]
		cNomeSeg  := ""
		SX5->(Dbsetorder(1))
		If SX5->(Dbseek(xFilial("SX5") + 'T3' + cSegmento ))
			cNomeSeg := Alltrim(SX5->X5_DESCRI)
		Endif 
			
		////IMPRESSÃO DOS DADOS...	 		
				
		//cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(aProsp[nCta,15]) + '</span></td>'+LF      		//status
		cWeb += '<td width="300" align="left"><span class="style3">' + aProsp[nCta,5] + "/" + aProsp[nCta,6]+ '</span></td>'+LF  	//cod.cliente/loja
		cWeb += '<td width="900" align="left"><span class="style3">' + Alltrim(Substr(aProsp[nCta,7],1,20))+ ' </span></td>'+LF     //nome cliente
		cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(cNomeSeg) + '</span></td>'+LF      				//segmento
		cWeb += '<td width="100" align="left"><span class="style3">' + Alltrim(aProsp[nCta,9]) + ' </span></td>'+LF        			//cidade
		cWeb += '<td width="50" align="center"><span class="style3">' + Alltrim(aProsp[nCta,10])  + '</span></td>'+LF  	//UF
		cWeb += '<td width="300" align="left"><span class="style3">'+ Alltrim(aProsp[nCta,12])+' </span></td>'+LF        	//e-mail
		cWeb += '<td width="300" align="left"><span class="style3">' + Alltrim(aProsp[nCta,11])  + '</span></td>'+LF  		//telefone
		cWeb += '</tr>'+LF
		nLinhas++		 
							 
		nCta++ 
				
	Enddo
	
	///faz o rodapé
	cWeb += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
	cWeb += '    <tr>'+LF
	cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
	cWeb += '    </tr>'+LF
	cWeb += '    <tr>'+LF
	cWeb += '      <td id="colArial">Microsiga&nbsp;Software&nbsp;S/A</td>'+LF
	cWeb += '      <td id="colArial">&nbsp;</td>'+LF
	cWeb += '      <td id="colArial" align="right">-&nbsp;Hora&nbsp;Termino:&nbsp;' + Time() + '</td>'+LF
	cWeb += '    </tr>'+LF
	cWeb += '    <tr>'+LF
	cWeb += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
	cWeb += '    </tr>'+LF
	cWeb += '  </table>'+LF
	
	///FECHA O HTML PARA ENVIO
	cWeb += '</body> '
	cWeb += '</html> '
							
	//////GRAVA O HTML 
	Fwrite( nHandle, cWeb, Len(cWeb) )
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

	Endif
		
					
	cCopia  := ""
	cCorpo  := titulo
	cAnexo  := cDirHTM + cArqHTM
	cAssun  := titulo										
	U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
				
	cWeb := ""
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	//Msginfo("FATR024 - Processo finalizado")
	MsgInfo("Rel 05 - PROSPECTS - Você recebeu este Relatório em seu e-mail.")
Else
	// Habilitar somente para Schedule
	Reset environment
Endif

Return     

