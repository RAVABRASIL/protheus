#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "TOPCONN.ch"
#INCLUDE "tbiconn.ch" 
#include "protheus.ch"

/*
******************************************************************************
//Programa: SF1100I.PRW
//Ponto de entrada após a gravação da nota fiscal de entrada.
//Descrição: Este programa irá executar as seguintes funções:
//			 Em caso de nota de devolução, irá solicitar ao
//			 usuário que classifique a nf de acordo com um motivo
//			 especificado na tabela MO do SX5.
//
//			 Ainda em caso de devolução, irá criar uma movimentação
//			 interna com os itens da nf e enviar email com a solicitação
//			 de compra
//           FR - 06/11/13:
//           Em caso de devolução, irá gravar na tabela Z10 -> processos de
//           Devolução - controlado pelo SAC
//****************************************************************************
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SF1100I                                          ³ 13/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao de notas fiscais de entrada - RAVA                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


User Function SF1100I()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02




Local cAlias  	:= Alias() //guardar o alias sendo utilizado antes do P.E.
Local cCodMoti	:= Space(6)

Local cNFFre1	:= Space(9)
Local cSeriFre1	:= Space(3)

Local cNFFre2	:= Space(9)
Local cSeriFre2	:= Space(3) 

Local cNFFre3	:= Space(9)
Local cSeriFre3	:= Space(3)

Local cMotivo	:= ""
Local nOpcao	:= 0 

Local aAreaAtu	:= GetArea()
Local aAreaSF1	:= SF1->(GetArea()) 
Local cNota     := SF1->F1_DOC
Local cSeriNF   := SF1->F1_SERIE
Local cFornece  := SF1->F1_FORNECE
Local cLoja     := SF1->F1_LOJA 

Local cNFVENDA := ""
Local cSeriVenda:= ""
Local aNFVENDA  := {}
Local t := 0

Private oDlg1 
Private cDIRHTM := ""
Private cARQHTM := ""
Private nHandle := ""
Private cBody   := ""
Private lMsErroAuto := .F.

SetPrvt("LFLAG,CALIAS,NREGF2,CARQ,")


// INSERIDO POR ANTONIO
// VARIAVEL QUE CLASSIFICA 
// 

iF Type("l103Class") <> "U" 
	IF l103Class .AND. FunName() = "MATA103" .AND.  Alltrim(SD1->D1_TES) $ GETMV('MV_TESFRE')   
	   //digitação das nf do conhecimento do frete (caso haja)	    			
	   //colocar aqui a função para inserir as notas 
	   U_ESTC008( "SF1", SF1->F1_DOC, 12 )
	   	
		If Z86->( dbSeek( xFilial( "Z86" ) + SF1->F1_DOC + SF1->F1_SERIE +SF1->F1_FORNECE+SF1->F1_LOJA ) )
			if Z86->Z86_FRETE>Z86->Z86_FRESIS
				if Z86->Z86_GERATI='S'
				   geraTit(Z86->Z86_FRETE - Z86->Z86_FRESIS)		   
			    Endif
			Endif
		Endif	   
	    
	ENDIF
ENDIF

/////Chamado 001474 - classificar as notas de devolução
If Inclui
	////CRIA O PROCESSO WORKFLOW
	/*
	oProcess:=TWFProcess():New("PRE-NOTA","PRE-NOTA")
	oProcess:NewTask('Inclusao PRE-Nota',"\workflow\http\oficial\PRENOTA.html")
	oHtml := oProcess:oHtml
	
	
	oHtml:ValByName("cPrenf", cNota )
	oHtml:ValByName("cSerie"  , cSeriNF )
	oHtml:ValByName("cTipoNF"  , iif(cTipo = "D", "Devolução de Venda", "Normal")  )
	
	
	//conout(Replicate("*",60))
	//conout("AVISO PRE-NOTA - " + Dtoc(Date()) + "-" + Time() + " INICIO")
	//conout(Replicate("*",60))
	
	oProcess:cSubject:= "Aviso de Inclusão - Pré-Nota"
    */

	If SF1->F1_TIPO = "D"
	 	
		DEFINE MSDIALOG oDlg1 FROM 050,050 TO 225,590 TITLE "DEVOLUÇÃO - Especifique o motivo da Devolução" PIXEL of oDlg1
		@005,007 SAY "Escolha um motivo e tecle <ENTER>" SIZE 100,006 COLOR CLR_HRED PIXEL  OF oDlg1  
		@014,007 SAY "Código Motivo:"	 SIZE 040,006  COLOR CLR_HBLUE PIXEL  OF oDlg1  
		@021,003 TO 045,260 							PIXEL of oDlg1
		//@026,007 MSGET cCodMoti			 WHEN .T.  F3 "MO"	 SIZE 040,006 PIXEL OF oDlg1		
		@026,007 MSGET cCodMoti VALID( FValidaMoti(cCodMoti) )			 WHEN .T.  F3 "MO"	 SIZE 040,006 PIXEL OF oDlg1		
		//MSGET cObsResp VALID( FObsValida(cObsResp) )
		
		@ 014,075 SAY "Descrição Motivo:"  OF oDlg1 PIXEL 
		@ 025,076 MSGET GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5") + 'MO' + cCodMoti,1,0)  WHEN .F. SIZE 180,006 PIXEL OF oDlg1
							
		DEFINE SBUTTON FROM 055,177 TYPE 1  ENABLE OF oDlg1 ACTION (nOpcao := 1,oDlg1:End())	//botão OK
		//DEFINE SBUTTON FROM 208,260 TYPE 2  ENABLE OF oDlg6 ACTION (nOK2 := 0,oDlg6:End())	//botão Cancela
			
		ACTIVATE MSDIALOG oDlg1 CENTERED
		
		If nOpcao == 1
		        
				If RecLock("SF1",.F.)
					SF1->F1_CODMOTI	:= cCodMoti					
					SF1->(MsUnLock())		        	
		   		Endif
		   		
		   		//////////////////////////////////////////////////////////////////
		   		//FR - 06/11/13 - GRAVA NA TABELA DE PROCESSOS DE DEVOLUÇÃO - SAC 
		   		//////////////////////////////////////////////////////////////////
		   		cNFVENDA := ""
		   		cSeriVenda:= ""
		   		aNFVENDA  := {}
		   		t := 0 
		   		////BUSCA A NF SAÍDA ORIGINAL...
		   		SD1->(DbSetorder(1))
		   		If SD1->(Dbseek(xFilial("SD1") + cNota + cSeriNF + cFornece + cLoja ))
		   			While !SD1->(EOF()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC == cNota ; 
		   			  .and. SD1->D1_SERIE == cSeriNF
		   			 	cNFVENDA := SD1->D1_NFORI
		   			 	cSeriVenda:= SD1->D1_SERIORI
		   			 	If Ascan(aNFVENDA, (cNFVENDA + cSeriVenda) ) == 0
		   			 		Aadd(aNFVENDA ,  (cNFVENDA + cSeriVenda) )     //000039239 0
		   			 	Endif
		   			  SD1->(Dbskip())
		   			Enddo
		   		Endif
		   		
		   		////VERIFICA SE TEM REGISTRO CORRESPONDENTE NO Z10 - PROCESSOS DEVOLUÇÃO
		   		///E ATUALIZA A INFORMAÇÃO DE QUE FOI DADA ENTRADA DA DEVOLUÇÃO E ATUALIZA STATUS	
		   		If Len(aNFVENDA) > 0
		   			For t := 1 to Len(aNFVENDA)	
				   		DbselectArea("Z10")
						Z10->(DBSETORDER(1))
						If Z10->(Dbseek(xFilial("Z10") + aNFVENDA[t] ))  //se encontrar, complementa o registro com novas informações da NFD
							RecLock("Z10", .F.)
							//Z10->Z10_CODIGO := _SUDX->UD_CODIGO
							//Z10->Z10_ITEM   := _SUDX->UD_ITEM
							//Z10->Z10_NF     := cNOTACLI
							//Z10->Z10_SERINF := cSERINF
							//Z10->Z10_EMINF  := SF2->F2_EMISSAO   //DAQUI PRA CIMA JÁ ESTÃO GRAVADOS
							Z10->Z10_DTDEVO := SF1->F1_DTDIGIT  //DATA EM QUE A NF FOI DEVOLVIDA
							Z10->Z10_STATUS := '03'       //ENTRADA NF DEVOLUÇÃO -> status na X5 -> ZG
							Z10->Z10_DTSTAT := DATE()
							Z10->Z10_HRSTAT := TIME()
							Z10->Z10_USER   := __CUSERID
							Z10->Z10_NOMUSR:= SUBSTR(cUSUARIO,7,15)
							Z10->Z10_NFEDEV:= SF1->F1_DOC    //número da nf devolução
							Z10->Z10_SERDEV:= SF1->F1_SERIE  //série da nf devolução
							Z10->(MsUnlock())
							
							DbSelectArea("SE1")      //título original
							SE1->(DBSETORDER(1))             //PREFIXO                   //NÚMERO NOTA(TÍTULO)
							If SE1->(Dbseek(xFilial("SE1") + Substr(aNFVENDA[t],10,3) + Substr(aNFVENDA[t],1,9) ))  //se encontrar, complementa o registro com novas informações da NFD
								While !SE1->(EOF()) .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_PREFIXO ==Substr(aNFVENDA[t],10,3) ;
								  .and. SE1->E1_NUM == Substr(aNFVENDA[t],1,9)
										RecLock("SE1" , .F. )
										SE1->E1_NFDEV := "S"   //FR - 21/11/13: MARCA O TÍTULO COMO EM PROCESSO DE DEVOLUÇÃO, PARA EVITAR QUE SEJA ENVIADO AO BANCO
										SE1->(MsUnlock())
										
										SE1->(Dbskip())
								Enddo
							Endif          
							
							DbSelectArea("SE1")    //título ncc
							SE1->(DBSETORDER(1))             //PREFIXO                   //NÚMERO NOTA(TÍTULO)
							If SE1->(Dbseek(xFilial("SE1") + SF1->F1_SERIE + SF1->F1_DOC ))  //se encontrar, complementa o registro com novas informações da NFD
								While !SE1->(EOF()) .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_PREFIXO == SF1->F1_SERIE ;
								  .and. SE1->E1_NUM == SF1->F1_DOC
										RecLock("SE1" , .F. )
										SE1->E1_NFDEV := "S"   //FR - 21/11/13: MARCA O TÍTULO COMO EM PROCESSO DE DEVOLUÇÃO, PARA EVITAR QUE SEJA ENVIADO AO BANCO
										SE1->(MsUnlock())
										
										SE1->(Dbskip())
								Enddo
							Endif
							
							
						Endif //seek no z10
					Next
				Endif
				///EMAIL AVISO DA NF DEVOLUÇÃO
				////CRIA O HTM COM O CÓDIGO DO REPRESENTANTE
			   	cDirHTM  := "\Temp\"    
				cArqHTM  := "NFD_" + Alltrim(SF1->F1_DOC) + "_.HTM"  
				nHandle := fCreate( cDirHTM + cArqHTM, 0 )
				    
				If nHandle = -1
				     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif
				cCorpo := ""
				cBody  := ""
				Cabeca := "AVISO DE ENTRADA NF DEVOLUÇÃO"			    
			    cMsg   := "Dados da NF Devolução:" + CHR(13) + CHR(10)
			    cMsg   += "Número/Série: " + SF1->F1_DOC + '/' + SF1->F1_SERIE + CHR(13) + CHR(10)
			    cMsg   += ", Emissão: " + DTOC(SF1->F1_EMISSAO) + CHR(13) + CHR(10)			    
				
				cCorpo := cMsg + CHR(13) + CHR(10)
				cCorpo += "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."
			    
			    cMsg   += ". Abaixo, Dados da NF Saída:" + CHR(13) + CHR(10)
			    
			    cCopia := ""								
			    cNome  := ""		
				cMail  := ""     
				cDepto := ""
				PswOrder(1)
				If PswSeek( __CUSERID, .T. )
					aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
				   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
				   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
					cDepto:= aUsers[1][12]  //Depto do usuário logado	
				Endif    
				cBody := HTMDEV(CABECA,cMSG,SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE,SF1->F1_LOJA,cNFVENDA,cSeriVenda,cNome,cDepto,cMail)
				
				///GRAVA O HTML
				Fwrite( nHandle, cBody, Len(cBody) )
				FClose( nHandle )
				
				cAssun  := "NF SAÍDA DEVOLVIDA: " + Alltrim( cNFVENDA ) + '/' + cSeriVenda 
				cAnexo  := cDirHTM + cArqHTM
								
				cMailTo := cMail //email do usuário logado
				cMailTo += ";logistica@ravaembalagens.com.br" 
				cMailTo += ";contabilidade@ravaembalagens.com.br" 
				cMailTo += ";edna@ravaembalagens.com.br" 
				cMailTo += ";financeiro@ravaembalagens.com.br" 
				cMailTo += ";sac@ravaembalagens.com.br" 
			
		   		//cMailTo += ";flavia.rocha@ravaembalagens.com.br" //retirar depois
				U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
				
				
			
		Endif     //nOpcao == 1
		
    
    Elseif FunName() = "MATA103"			//se não for devolução é entrada normal
       If Alltrim(SD1->D1_TES) $ GETMV('MV_TESFRE')//"108/146"
       
	        //digitação das nf do conhecimento do frete (caso haja)	    			
			//colocar aqui a função para inserir as notas 
			U_ESTC008( "SF1", SF1->F1_DOC, 12 )
		
		Endif		//if do TES = 108 ou 146		
    
    	U_WFMP( SF1->F1_DOC, SF1->F1_SERIE, "E" )		//CASO A ENTRADA FOR DE PRODUTO TIPO = "MP" irá enviar um e-mail aos responsáveis
    
    
    Endif		//if do funname = mata103 
        
    MsgInfo("NF Entrada gravada com Sucesso!")	

Endif

///fim do chamado 001474
//***********************************************************

_nIndD1 := SD1->( IndexOrd() )
_nRecD1 := SD1->( Recno() )
_nIndB1 := SB1->( IndexOrd() )
_nRecB1 := SB1->( Recno() )
_nRecF4 := SF4->( Recno() )

If SM0->M0_CODIGO == "02" .and. SF1->F1_TIPO == "D"
	
	SD1->( DbSetOrder( 1 ) )
	SD1->( DbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA, .T. ) )
	
	Do while SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_SERIE + SD1->D1_DOC == SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC
		
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES) )
		if SF4->F4_ESTOQUE = 'S'			
			If Len( AllTrim( SD1->D1_COD ) ) >= 8
				SB1->( DbSetOrder( 1 ) )
				SB1->( DbSeek( xFilial("SB1") + SD1->D1_COD ) )
				nPESO := SB1->B1_PESOR
				//lMsErroAuto := .T.
				//Do While lMsErroAuto
					
					//lMsErroAuto := .F.
					aMATRIZ     := { { "D3_TM", "503", NIL},;
					{ "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
					{ "D3_FILIAL", xFilial( "SD3" ), NIL},;
					{ "D3_LOCAL", "01", NIL },;
					{ "D3_COD", SD1->D1_COD, NIL},;
					{ "D3_QUANT", SD1->D1_QUANT, NIL },;
					{ "D3_EMISSAO", dDATABASE, NIL} }
					
					Begin Transaction
						MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
					    IF lMsErroAuto
					    	MostraErro()
					        DisarmTransaction()
					    Endif
					End Transaction
				//EndDo
				cCODSECU := If( Len( AllTrim( SD1->D1_COD ) ) = 8, SUBS( SD1->D1_COD, 1, 1 ) + SUBS( SD1->D1_COD, 3, 3 ) +;
				SUBS( SD1->D1_COD, 7, 2 ), SUBS( SD1->D1_COD, 1, 1 ) + SUBS( SD1->D1_COD, 3, 4 ) +;
				SUBS( SD1->D1_COD, 8, 2 ) )
				
				SB1->( DbSeek( xFilial("SB1") + cCODSECU ) )
				
				//lMsErroAuto := .T.
				//Do While lMsErroAuto
					//lMsErroAuto := .F.
					aMATRIZ     := { { "D3_TM", "003", NIL},;
					{ "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
					{ "D3_FILIAL", xFilial( "SD3" ),Nil},;
					{ "D3_LOCAL", "01", NIL },;
					{ "D3_COD", cCODSECU, NIL},;
					{ "D3_QUANT", SD1->D1_QUANT, NIL },;
					{ "D3_EMISSAO", dDATABASE, NIL} }
					
					Begin Transaction
						MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
					    IF lMsErroAuto
					    	MostraErro()
					    	DisarmTransaction()
					    Endif
					End Transaction
				//EndDo
			EndIf
		endif
		SD1->( dbSkip() )
	EndDo
	
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta Livros fiscais na Rava Emb                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
SF3->( dbSetOrder( 4 ) )
If SF3->( dbSeek( xFilial( "SF3" ) + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE ) )
	RecLock( "SF3", .F. )
	SF3->F3_REPROC := "N"		
	SF3->F3_VALCONT := SF1->F1_VALBRUT 
	SF3->F3_BASIMP1 := SF1->F1_BASIMP1
	SF3->F3_VALIMP1 := SF1->F1_VALIMP1
		
	if SF3->F3_BASEICM <> SF3->F3_VALCONT
		SF3->F3_OUTRICM := SF3->F3_VALCONT - SF3->F3_BASEICM
	endIf

	if SF3->F3_BASEIPI <> SF3->F3_VALCONT
  		SF3->F3_OUTRIPI := SF3->F3_VALCONT - SF3->F3_BASEIPI
	endIf
	
	SF3->F3_VALOBSE := 0
	
	SF3->( MsUnlock() )
	SF3->( dbCommit() )
EndIf

//  EMAIL DA SOLICITACAO DE COMPRA 
//FR - 17/04/14 - CHAMADO: #53 - Solicitante: Wagner Cabral
//O email informando que há itens disponíveis da SC , estava chegando em branco em alguns casos
//Analisei, e era porque a instrução abaixo, era realizada também quando o tipo da nota era = Devolução
//o que não pode acontecer, pois este email só pode ser gerado se a NF for de compra.
If Inclui
	If SF1->F1_TIPO = "N" //entrada normal
		SD1->( DbSetOrder( 1 ) )
		SD1->( DbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA, .T. ) )
					
		DbSelectArea("SC7")
		DbSetOrder(1)
		If SC7->( DbSeek(xFilial("SC7")+SD1->D1_PEDIDO) ) 
		   DbSelectArea("SC1")
		   DbSetOrder(1)
		   If SC1->( DbSeek(xFilial("SC1")+SC7->C7_NUMSC) )
		      If UPPER(SC1->C1_SOLICIT)!='ADMINISTRA'
		         cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
		         cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml"> '
		         cMensagem += '<head> '
		         cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
		         cMensagem += '<title>Untitled Document</title> '
		         cMensagem += '<style type="text/css"> '
		         cMensagem += '<!-- '
		         cMensagem += '.style3 {color: #FFFFFF} '
		         cMensagem += '.style4 {color: #000000} '
		         cMensagem += '--> '
		         cMensagem += '</style></head> '
		         cMensagem += '<body> '
		         cMensagem += '<table width="722" border="1"> '
		         cMensagem += '<tr bgcolor="#FFFFFF"> '
		         cMensagem += '<td width="104"><span class="style4">N&ordm;: '+SC1->C1_NUM+'</span></td> '
		         cMensagem += '<td width="602" bgcolor="#FFFFFF"><span class="style4">Solicitante: '+UPPER(SC1->C1_SOLICIT)+'</span></td> '
		         cMensagem += '</tr> '
		         cMensagem += '</table> '
		         cMensagem += '<table width="722" border="1"> '
		         cMensagem += '<tr bgcolor="#00CC66"> '
		         cMensagem += '<td width="87"><span class="style3">Item</span></td> '
		         cMensagem += '<td width="107"><span class="style3">Produto</span></td> '
		         cMensagem += '<td width="258"><span class="style3">Descritivo</span></td> '
		         cMensagem += '<td width="73"><span class="style3">Dt Entrega </span></td> '
		         cMensagem += '<td width="163"><span class="style3">Situa&ccedil;&atilde;o</span></td> '
		         cMensagem += '</tr> '
		         
		         //cSolic:=SC1->C1_SOLICIT
		         cSolic := SC1->C1_USER  //mudei para o código do usuário, porque é mais seguro
		         cNumSc:=SC7->C7_NUMSC
		         do While SC1->(!EOF()) .AND. SC1->C1_NUM=cNumSc
		         
		            If SC1->C1_RESIDUO!='S'
		               If  QTDJE(SC1->C1_PEDIDO,SC1->C1_ITEMPED,SC1->C1_PRODUTO)=0
		                  //ENTREGA NAO REALIZADA 
		                  cMensagem += '<tr> '
		                  cMensagem += '<td><span class="style4">'+SC1->C1_ITEM+'</span></td> '
		                  cMensagem += '<td><span class="style4">'+SC1->C1_PRODUTO+'</span></td> '
		                  cMensagem += '<td><span class="style4">'+SC1->C1_DESCRI+'</span></td> '
		                  cMensagem += '<td><span class="style4">'+"  /  /  "+'</span></td> '
		                  cMensagem += '<td><span class="style4">'+"Entrega Não Realizada"+'</span></td> '  
		                  cMensagem += '</tr> '
		               Else
		                  If SC1->C1_QUANT> QTDJE(SC1->C1_PEDIDO,SC1->C1_ITEMPED,SC1->C1_PRODUTO)
		                     //ENTREGA PARCIAL
		                     cMensagem += '<tr> '
		                     cMensagem += '<td><span class="style4">'+SC1->C1_ITEM+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+SC1->C1_PRODUTO+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+SC1->C1_DESCRI+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+dtoc(dDataBase)+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+"Entrega Parcial: "+transform(QTDJE(SC1->C1_PEDIDO,SC1->C1_ITEMPED,SC1->C1_PRODUTO),"@E 999,999.99")+" De "+transform(SC1->C1_QUANT,"@E 999,999.99")+" ( "+transform(SC1->C1_QUANT-QTDJE(SC1->C1_PEDIDO,SC1->C1_ITEMPED,SC1->C1_PRODUTO),"@E 999,999.99") +" )"+'</span></td> '  
		                     cMensagem += '</tr> '
		                  EndIf
		                  If SC1->C1_QUANT=QTDJE(SC1->C1_PEDIDO,SC1->C1_ITEMPED,SC1->C1_PRODUTO)
		                     //ENTREGA TOTAL 
		                     cMensagem += '<tr> '
		                     cMensagem += '<td><span class="style4">'+SC1->C1_ITEM+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+SC1->C1_PRODUTO+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+SC1->C1_DESCRI+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+DTOC(GETDATA(SC1->C1_PEDIDO,SC1->C1_ITEMPED,SC1->C1_PRODUTO))+'</span></td> '
		                     cMensagem += '<td><span class="style4">'+"Entrega Total"+'</span></td> '  
		                     cMensagem += '</tr> '
		                  EndIf
		               EndIf
		            EndIf 
		            SC1->(DBSKIP())
		         Enddo   
		         cMensagem += '</table> '
		         cMensagem += '</body>  '
		         cMensagem += '</html>  '
		         		         
		         PswOrder(1)
		         if PswSeek( cSolic, .T. )  //código do usuário
		            aUsu := PSWRET() // Retorna vetor com informações do usuário
		            if !Empty(aUsu[1][14])
		                //TESTE
		                cEmail := Alltrim(aUsu[1][14]) + ';' + SupEmail(cSolic)
		                If cSolic == '000380'  //se o solicitante for Wagner, envia pra mim a cópia, temporariamente só pra verificação
		                	//cEmail += ";flavia.rocha@ravaembalagens.com.br" 
		                Endif
		                cAssunto := " Ha item(ns) disponivel(is) da solicitacao de compra"
		                U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
		                //ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
		           endif
		         endIf        
		      
		      EndIf
		   EndIf
		EndIF
	Endif //F1_TIPO = N
Endif //if inclui
// FIM DO EMAIL DA SOLICITACAO DE COMPRA 

SD1->( DbSetOrder( _nINDD1 ) )
SD1->( DbGoto( _nRECD1 ) )
SB1->( DbSetOrder( _nINDB1 ) )
SB1->( DbGoto( _nRECB1 ) )
SF4->( DbGoto( _nRECF4 ) )


RestArea(aAreaSF1)
RestArea(aAreaAtu)

Return


*************

Static Function GETDATA(cPedido,cItem,cProd)

*************

local Qry:=" "
local dData:=StoD(space(8))

Qry:=" SELECT MAX(D1_DTDIGIT)'DTULTM' FROM "+retSqlName('SD1')+" SD1 "
Qry+="WHERE D1_FILIAL='"+xFilial('SD1')+"' " 
Qry+="AND D1_PEDIDO='"+cPedido+"' "
Qry+="AND D1_ITEMPC='"+cItem+"' "
Qry+="AND D1_COD='"+cProd+"' "
Qry+="AND SD1.D_E_L_E_T_!='*' "

TCQUERY Qry NEW ALIAS 'AUUX'
TCSetField("AUUX","DTULTM","D")
   
AUUX->(dbgotop())

if AUUX->(!EOF())
   dData:=AUUX->DTULTM
EndIf

AUUX->(DbCloseArea())

Return dData



*************

Static Function QTDJE(cPedido,cItem,cProd)

*************

local Qry:=" "
local nQuJe:=0

Qry:=" SELECT SUM(D1_QUANT)'QUJE' FROM "+retSqlName('SD1')+" SD1 "
Qry+="WHERE D1_FILIAL='"+xFilial('SD1')+"' " 
Qry+="AND D1_PEDIDO='"+cPedido+"' "
Qry+="AND D1_ITEMPC='"+cItem+"' "
Qry+="AND D1_COD='"+cProd+"' "
Qry+="AND SD1.D_E_L_E_T_!='*' "

TCQUERY Qry NEW ALIAS 'AUUX'

   
AUUX->(dbgotop())

if AUUX->(!EOF())
   nQuJe:=AUUX->QUJE
EndIf

AUUX->(DbCloseArea())

Return nQuJe

*************
Static  function SupEmail(cUsu)
*************

local aUsu := {}
local aSup := {}
local cSup := ""

//PswOrder(2)
PswOrder(1)
if PswSeek( cUsu, .T. )
   aUsu := PSWRET() // Retorna vetor com informações do usuário
   PswOrder(1)
   PswSeek(aUsu[1][11],.t.)
   aSup := PswRet(NIL)
   cSup := If(!Empty(aSup),aSup[01][14],"") //Email do Superior do usuário
endif

return cSup



***************

Static Function geraTit(nValor)

***************
Local cQry:=''
local nTotPar:=1

lMsErroAuto := .F.

cQry:="SELECT * FROM SE2020 SE2 "
cQry+="WHERE "
cQry+="E2_FILIAL='"+xfilial('SE2')+"' "
cQry+="AND E2_NUM='"+SF1->F1_DOC+"' "
cQry+="AND E2_PREFIXO='"+SF1->F1_SERIE+"' "
cQry+="AND E2_FORNECE='"+SF1->F1_FORNECE+"' "
cQry+="AND E2_LOJA='"+SF1->F1_LOJA+"' "
cQry+="AND E2_TIPO='NF' "
cQry+="AND SE2.D_E_L_E_T_!='*' "
cQry+="ORDER BY E2_PARCELA DESC "

TCQUERY cQry NEW ALIAS 'SE2XX'

If SE2XX->(!EOF()) 
   If Empty(SE2XX->E2_PARCELA)
      nTotPar:=1
   Else
      nTotPar:=val(SE2XX->E2_PARCELA)   
   Endif
   Do While SE2XX->(!EOF())
	
	   aVetor :={ {"E2_PREFIXO"     ,SE2XX->E2_PREFIXO,		              Nil},;  
	              {"E2_FILIAL"	    ,xfilial('SE2'),		              Nil},;
				  {"E2_NUM"	        ,SE2XX->E2_NUM,		                  Nil},;
				  {"E2_PARCELA"     ,SE2XX->E2_PARCELA,			          Nil},;
				  {"E2_TIPO"	    ,'AB-',			                      Nil},;                                       
				  {"E2_NATUREZ"     ,SE2XX->E2_NATUREZ,		              Nil},;
	              {"E2_FORNECE"     ,SE2XX->E2_FORNECE,	                  Nil},;
				  {"E2_LOJA"	    ,SE2XX->E2_LOJA,			          Nil},;
				  {"E2_EMISSAO"     ,STOD(SE2XX->E2_EMISSAO),		      Nil},;
				  {"E2_VENCTO"	    ,STOD(SE2XX->E2_VENCTO),		      Nil},;
				  {"E2_VENCREA"	    ,STOD(SE2XX->E2_VENCREA),		      Nil},;
				  {"E2_VALOR"	    ,(nValor/nTotPar),		              Nil},;
				  {"E2_HIST"	    ,"Conhecimento de Frete Abatimento",  Nil}}
	
	
	    MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,3)
	
	   if lMsErroAuto
	      msgAlert("ERRO NA GERACAO DO TITULO DE ABATIMENTO! CONTACTE O SETOR DE T.I. !!!")
	      DisarmTransaction()
	      MostraErro()
	      exit
	   endIf
	
	   SE2XX->(dbskip())
	
   EndDo
	If ! lMsErroAuto
	   alert('titulo de Abatimento Gerado Com Sucesso')
	Endif
	
else
   msgAlert("Titulo Normal nao Encontrado! CONTACTE O SETOR DE T.I. !!!")
EndIf
SE2XX->(dbclosearea())


Return 


*****************************************************************************************************
Static Function HTMDEV(CABECA,cMSG, cNFD, cSERINFD, cFornece, cLoja,cNFVENDA,cSeriVenda,cNome,cDepto,cMail)
*****************************************************************************************************

Local cWeb := ""
Local LF   := CHR(13) + CHR(10)

cWeb := '<html>'+ LF
cWeb += '<head>'+ LF
cWeb += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+ LF
cWeb += '<title>DEVOLUÇÃO - NF SAÍDA</title>'+ LF
cWeb += '<style>'+ LF
cWeb += '<!--'+ LF
cWeb += 'div.Section1'+ LF
cWeb += '	{page:Section1;}'+ LF
cWeb += '-->'+ LF
cWeb += '</style>'+ LF
cWeb += '</head>'+ LF

cWeb += '<body>'+ LF
cWeb += '	<div align="left">'+ LF
cWeb += '		<table border="0" width="80" cellpadding="0" style="border-collapse: collapse" bordercolor="#FFFFFF">'+ LF
cWeb += '			<tr>'+ LF
cWeb += '				<td>'+ LF
cWeb += '					<a target=_blank href="http://www.ravaembalagens.com.br">'+ LF
cWeb += '					<img width="100%" border="0" id="_x0000_i1025" src="http://www.ravaembalagens.com.br/figuras/topemail.gif"></a>'+ LF
cWeb += '				</td>'+ LF
cWeb += '			</tr>'+ LF
cWeb += '		</table>'+ LF
cWeb += '	</div>'+ LF
cWeb += '	<br>'+ LF
cWeb += '	<strong>'+ LF
cWeb += '		<center>'+ LF
cWeb += '		<span style="font-size:15pt;font-family:Verdana;color:black; text-decoration:underline">'+CABECA+'</span>'+ LF
cWeb += '		</center>'+ LF
cWeb += '	</strong>'+ LF
cWeb += '<span style="font-size:8pt;font-family:Verdana;color:black; text-decoration:underline">'+ LF
cWeb += ' 	</span>	<br>'+ LF
cWeb += '	</p>'+ LF
cWeb += '	<div>'+ LF
cWeb += '		<table width="180" align=center>'+ LF
cWeb += '			<tr style="font-size:9.0pt;font-family:Verdana;color:black">'+ LF
cWeb += '				<td bgcolor="#E2E9E6"  width="660" align="center" bgcolor="#A2D7AA" colspan="9">'+ LF
cWeb += '					<p align="left">Prezado(s):<BR><BR>'+ LF
cWeb += '                     &nbsp;&nbsp;'+cMSG+'<BR><BR><BR></td></tr>'+ LF
cWeb += '   			<tr style="font-size:8.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+ LF
cWeb += '                <td align="center" bgcolor="#A2D7AA" colspan="9"><b>Dados da NF Saída</b></td>'+ LF
cWeb += '                </tr>'+ LF

cWeb += '                <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>FILIAL</b></td>'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>NF / Série</b></td>'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>Emissão</b></td>'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>Cod.Cliente</b></td>'+ LF
cWeb += '    			<td width="492" align="center" bgcolor="#A2D7AA" ><b>Nome Cliente</b></td>'+ LF
cWeb += '    			<td width="492" align="center" bgcolor="#A2D7AA" ><b>Localidade</b></td>'+ LF
cWeb += '    			<td width="192" align="center" bgcolor="#A2D7AA" ><b>UF</b></td>'+ LF
cWeb += '    			<td width="192" align="center" bgcolor="#A2D7AA" ><b>Vlr.Total c/ IPI</b></td>'+ LF
cWeb += '                <td width="492" align="center" bgcolor="#A2D7AA" ><b>Cond.Pagamento</b></td>'+ LF
                
//DADOS DA NF SAÍDA
SF2->(DbsetOrder(1))
If SF2->(Dbseek(xFilial("SD2") + cNFVENDA + cSeriVenda + cFornece + cLoja ))
    cWeb += '			<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+ LF
	cWeb += '				<td width="142" align="left">'+SM0->M0_FILIAL+'</td>'+ LF
	cWeb += '				<td width="142" align="left">'+cNFVENDA + '/' + cSeriVenda +'</td>'+ LF
	cWeb += '    			<td width="142" align="left">'+DTOC(SF2->F2_EMISSAO)+'</td>'+ LF
	cWeb += '    			<td width="192" align="left">'+Alltrim( cFornece + '/' + cLoja )+'</td>'+ LF
	cWeb += '				<td width="492" align="left">'+POSICIONE("SA1",1,XFILIAL("SA1") + cFornece + cLoja, 'A1_NOME')+'</td>'+ LF
	cWeb += '          		<td width="492" align="left">'+POSICIONE("SZZ",1,XFILIAL("SZZ") + SF2->F2_TRANSP + SF2->F2_LOCALIZ, 'ZZ_DESC')+'</td>'+ LF
	cWeb += '          		<td width="192" align="left">'+SF2->F2_EST+'</td>'+ LF
	cWeb += '          		<td width="192" align="left">'+Transform(SF2->F2_VALBRUT , "@E 999,999,999.99" )+'</td>'+ LF
	cWeb += '          		<td width="492" align="center">'+POSICIONE("SE4",1,XFILIAL("SE4") + SF2->F2_COND, 'E4_DESCRI') +'</td>'+ LF
	cWeb += '           	</tr>'+ LF
Endif

cWeb += '</tr>'+ LF
cWeb += '<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="9"><BR><BR>'+ LF
cWeb += '</td>'+ LF
cWeb += '</tr>'+ LF
cWeb += '<tr style="font-size:8.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+ LF
cWeb += ' <td align="center" bgcolor="#A2D7AA" colspan="9"><b>ITENS DEVOLVIDOS</b></td>'+ LF
cWeb += '</tr>'+ LF

cWeb += '           	        <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>Item</b></td>'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>Produto</b></td>'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>QTde</b></td>'+ LF
cWeb += '                <td width="192" align="center" bgcolor="#A2D7AA" ><b>Vlr.Unit.</b></td>'+ LF
cWeb += '    			<td width="492" align="center" bgcolor="#A2D7AA" ><b>Vlr.Total</b></td>'+ LF
cWeb += '    			<td width="492" align="center" bgcolor="#A2D7AA" ><b></b></td>'+ LF
cWeb += '    			<td width="192" align="center" bgcolor="#A2D7AA" ><b></b></td>'+ LF
cWeb += '    			<td width="192" align="center" bgcolor="#A2D7AA" ><b></b></td>'+ LF
cWeb += '                <td width="492" align="center" bgcolor="#A2D7AA" ><b></b></td>'+ LF
cWeb += '</tr>' + LF
///ITENS DEVOLVIDOS		    
SD1->(DbsetOrder(1))
SD1->(Dbseek(xFilial("SD1") + cNFD + cSeriNFD + cFornece + cLoja ))
While !SD1->(EOF()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC == cNFD .and. SD1->D1_SERIE == cSeriNFD;
  .and. SD1->D1_FORNECE == cFornece .and. SD1->D1_LOJA == cLoja  
   
		cWeb += '			<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+ LF
		cWeb += '				<td width="142" align="left">'+SD1->D1_ITEM +'</td>'+ LF
		cWeb += '				<td width="142" align="left">'+SD1->D1_COD +'</td>'+ LF
		cWeb += '    			<td width="142" align="left">'+Transform(SD1->D1_QUANT , "@E 999,999,999.99")+'</td>'+ LF
		cWeb += '    			<td width="192" align="left">'+Transform(SD1->D1_VUNIT, "@E 999,999,999.99")+'</td>'+ LF
		cWeb += '				<td width="492" align="left">'+Transform(SD1->D1_TOTAL , "@E 999,999,999.99")+'</td>'+ LF
		cWeb += '          		<td width="492" align="left"></td>'+ LF
		cWeb += '          		<td width="192" align="left"></td>'+ LF
		cWeb += '          		<td width="192" align="left"></td>'+ LF
		cWeb += '          		<td width="492" align="center"></td>'+ LF 
		cWeb += '</tr>' + LF  
					     
   	SD1->(Dbskip()) 
Enddo

cWeb += '				<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="9"><BR><BR>'+ LF
cWeb += '				</td>'+ LF
cWeb += '				</tr>'+ LF

cWeb += '				<tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">'+ LF
cWeb += '				<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="9"><BR><BR>'+ LF
cWeb += '                Atenciosamente,<BR><BR><BR>'+ LF
cWeb += '                '+cNome+'<BR>'+ LF
cWeb += '                '+cDepto+'<BR>'+ LF
cWeb += '                '+cMail+'<BR>'+ LF
cWeb += '<p><span style="FONT-SIZE: 7pt; COLOR: black; FONT-FAMILY: Verdana">'+ LF
cWeb += '<< "SF1100I.html" >></span></p>'+ LF
cWeb += '</table>'+ LF
cWeb += '</body>'+ LF
cWeb += '</html>'+ LF

Return(cWeb)


*********************************
Static function FValidaMoti( cMoti )   
*********************************

Local lNaoVazio	:= .F.

If Empty(cMoti)
	MsgAlert("Por favor, Preencha o Motivo !!","Alerta")
	lNaoVazio := .F.
Else	
	lNaoVazio := .T.
Endif