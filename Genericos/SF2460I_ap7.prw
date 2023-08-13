#include "rwmake.ch"  
#INCLUDE 'TOPCONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SF2460I                                          ³ 03/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao de notas fiscais - RAVA                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±   
// Ponto de entrada localizado após a atualização das tabelas referentes 
// à nota fiscal (SF2/SD2), mas antes da contabilização. ATENÇÃO: Este 
// ponto de entrada está dentro da transação na gravação das tabelas do 
// documento.
*/

User Function SF2460I()

Local aAreaSF3	:= GetArea("SF3")
Local aAreaSF2	:= GetArea("SF2")
Local aAreaSD2	:= GetArea("SD2")
Local aAreaSC5	:= GetArea("SC5")
Local aAreaSC6	:= GetArea("SC6")
Local aAreaSE1	:= GetArea("SE1")
local cProrr    := ""
local lAtualiza := lUpdate  := .T.
Local lConfirm	:= .F.
Local nPercent  := 0
Local aMatriz   := {}
Local lMsErroAuto := .F.
Local lRemessa := .F.
Local cEmpenho
Local cSuper   := ""
Local cVendedor := ""
local nVALEMPE := 0
local nVALBRUT := 0
Local _cDoc

SetPrvt("NQTDVOLUME,NVOL,LFLAG,CALIAS,NREGF2,CARQ")
SetPrvt("NTOTNF,NTOTDIF,ADIFE,CTESDNA,NVALJUR,NPORCJUR")
SetPrvt("CHIST,CHIST1,X,ADUPDNA,NC_EMIS,NC_BAIX")
SetPrvt("NBASE,NCOMIS,CDOC,CCLIENTE,CLOJA,CCODSECU,AESTRU,APARC,NCONT")
//begin Transaction
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SF2460I                                          ³ 03/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao de notas fiscais - RAVA                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±   
*/

cNota     := SF2->F2_DOC
cSerie    := SF2->F2_SERIE 
cVendedor := SF2->F2_VEND1

DbSelectArea("SA3")
SA3->(DBSETORDER(1))
If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
	cSuper := SA3->A3_SUPER
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao da localizacao do transportador para calculo do frete,³
//³segunda condicao de pagamento e quantidade de volumes.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("CD2")
CD2->( DbSetOrder(1) )

SB1->( dbSetOrder( 1 ) )
SD2->( dbSetOrder( 3 ) )
SD2->( dbSeek( xFilial( "SF2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
SC5->( dbSeek( xFilial( "SC5" ) + SD2->D2_PEDIDO ) )
nDif := 0
//
nVALEMPE := SC5->C5_VALEMPE  // valor do empenho
nVALBRUT := SF2->F2_VALBRUT  // valor da nota 

//
_XDIv:=1
_nNovBase:=0
_nNovIPI:=0
_nTNovBase:=0
_nTNovIPI:=0
//
nQtdVolume := 0
nPESO      := 0

// RTIRADO EM 17/02/2012 POR ANTONIO MOTIVO: DEPOIS DA ULTIMA ATUALIZAO O ARREDONDAMENTO NAO VEM APREZENTANDO UM RESULTADO SATISFATORIO,pois a lei permite transmitir a nota com diferenca de um centavo
//lAtualiza := iif(SC5->C5_VALEMPE > 0 .and. SC5->C5_VALEMPE != SF2->F2_VALBRUT, .T., .F.)//07/04/09 LICITAÇÃO
lAtualiza :=.F.
cPedVenda := "" 
aPedVenda := {}
DbSelectArea("SD2")

While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !Eof() )
	
	DbSelectArea("SB1")
	SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
	
	nVol := SD2->D2_QUANT * SB1->B1_QE
	
	If ( nVol - Int( nVol ) ) > .00999
		nVol := Int( nVol ) + 1
	endif
	
	nQtdVolume 	+= nVol
	nPESO      	+= SD2->D2_QUANT * SB1->B1_PESOR
	_nTNovBase	+=SD2->D2_TOTAL
   _nTNovIPI 	+=SD2->D2_VALIPI
   
    
	cPedVenda := SD2->D2_PEDIDO
	If Ascan(aPedVenda , cPedVenda ) == 0
		Aadd(aPedVenda , cPedVenda)
	Endif

	DbSelectArea("SD2")
	SD2->( dbSkip() )	
Enddo
///////////////////////////////////////
///ATUALIZA STATUS PEDIDO VENDA - ZAC  
///////////////////////////////////////
t := 0
DbSelectArea("ZAC")
//	ZAC->(Dbsetorder(1))   
//	If !ZAC->(Dbseek(xFilial("ZAC") + cPedVenda )) 
If Len(aPedVenda) > 0
	For t := 1 to Len(aPedVenda)	
			RecLock("ZAC", .T.)
			ZAC->ZAC_FILIAL := xFilial("SD2")	
			ZAC->ZAC_PEDIDO := aPedVenda[t] //cPedVenda
			ZAC->ZAC_STATUS := '03'  
			ZAC->ZAC_DESCST := "PRODUCAO/FATURAMENTO"
			ZAC->ZAC_DTSTAT := Date()
			ZAC->ZAC_HRSTAT := Time()
			ZAC->ZAC_USER   := __CUSERID //código do usuário que criou
			ZAC->(MsUnlock())
						
			SC5->(Dbsetorder(1))   
			If SC5->(Dbseek(xFilial("SC5") + aPedVenda[t] ))
				RecLock("SC5", .F. )
				SC5->C5_STATUS := '03'
				SC5->(MsUnlock())
			Endif
	Next
Endif
//FR - 31/10/13


DbSelectArea("SF2")
RecLock( "SF2", .F. )

SF2->F2_LOCALIZ := SC5->C5_LOCALIZ ; SF2->F2_VOLUME1 := nQtdVolume
//SF2->F2_CONDPA1 := SC5->C5_CONDPA1 ; SF2->F2_LOCRED  := SC5->C5_LOCRED
SF2->F2_COND   := SC5->C5_CONDPAG ; SF2->F2_LOCRED  := SC5->C5_LOCRED
SF2->F2_PLIQUI := nPESO           ; SF2->F2_PBRUTO  := nPESO

SF2->( msUnlock() )

/*14/04/09 Movimentação do almoxarifado 09. Salvando produtos e quantidades.*/
If lRemessa
	SF2->F2_TRANSIT := 'S'//Nota em trânsito
endIf

If "VD" $ SF2->F2_VEND1
	SF3->( dbSetOrder( 4 ) )
	SF3->( dbSeek( xFilial( "SF3" ) + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_DOC + SF2->F2_SERIE ) )
	RecLock( "SF3", .F. )
	SF3->( DbDelete() )
	SF3->( MsUnlock() )
	Return NIL
EndIf

DbSelectArea("SD2")
SD2->( dbSetOrder( 3 ) )
SD2->( dbSeek( xFilial( "SF2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )

lFlag  := .T.

If SM0->M0_CODIGO == "02"
	
	//Incluido por Eurivan 27/05/08
	//testa se bloquea novamente clientes desbloqueados

	If SA1->A1_BKBLQ == "S"
	   RecLock("SA1",.F.)
	   SA1->A1_BLQXDD := "S"
	   SA1->A1_BKBLQ  := "N"
	   SA1->(MsUnLock())
	Endif
	//final
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava cabecalho de nota fiscal na Rava 1                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nTotnF  := SF2->F2_VALBRUT  // alterado de F2_VALFAT por Mauricio em 17/11/2003
	nTotDif := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava itens de nota fiscal na Rava 1                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SX6")
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_TESDNA", .T. ) )
	cTesDna := Alltrim( SX6->X6_CONTEUD )
	
	DbSelectArea("SC5")
	SC5->( dbSeek( xFilial( "SC5" ) + SD2->D2_PEDIDO ) )

	DbSelectArea("SD2")
	SD2->( dbSetOrder( 3 ) )
	SD2->( dbSeek( xFilial( "SF2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
	aDife := {}
	
	While SD2->D2_DOC == SF2->F2_DOC .AND. SD2->( !Eof() )
		
		If SD2->D2_SERIE == SF2->F2_SERIE

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Preco venda - Ravitec                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			dbSelectArea("SC6")
			SC6->( dbSeek( xFIlial( "SC6" ) + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD, .t.  ) )
			
			Aadd( aDife, { SD2->D2_COD, SD2->D2_QUANT, IIF( SC6->C6_VALDESC = 0 , ( SC6->C6_PRUNIT - SC6->C6_PRCVEN ), ;
				(SC6->C6_PRUNIT - SC6->C6_PRCVEN - (SC6->C6_VALDESC / SC6->C6_QTDVEN) ) - ((SC6->C6_PRUNIT - SC6->C6_PRCVEN - (SC6->C6_VALDESC / SC6->C6_QTDVEN) ) * (SC6->C6_DESCONT/100))), ;
				cTesDna, SD2->D2_CF, SC6->C6_NUM, SC6->C6_ITEM, SD2->D2_LOCAL, SD2->D2_QTSEGUM, SD2->D2_TIPO,;
				SD2->D2_COMIS1, SD2->D2_CLASFIS, SD2->D2_COMIS1 } )

			If SC6->C6_QTDVEN == SC6->C6_QTDENT
				RecLock( "SC6", .F. )
				SC6->C6_PRCV := SC6->C6_PRCVEN
				SC6->( msUnlock() )
				SC6->( dbCommit() )
			endif
			
		Endif
		
		//Incluido em 28/05/09 Atualizando para uma msexecauto o trecho abaixo comentado que faz as movimentações dos genéricos
		DbSelectArea("SD2")
		If Len( AllTrim( SD2->D2_COD ) ) >= 8		

	        // FUNCAO QUE VERIFICA SE O TES ATUALIZA ESTOQUE 
	        If fAtuEst(SD2->D2_TES)

				Begin Transaction
				DbSelectArea("SD3")
				SD3->(dbSetOrder(2))
				
				//se não achar o numero da Movimentação com o numero da NF, inclui. CC usa o proximo numero.
				If !SD3->(dbSeek(xFilial("SD3") + SD2->D2_DOC + SD2->D2_COD))
					_cDoc		:= SD2->D2_DOC
				Else    
					_cDoc		:= GetSxeNum("SD3","D3_DOC")
					lConfirm	:= .T.
				EndIf
				    aMatriz :=  {{"D3_COD"    ,SD2->D2_COD,					Nil},;
			   	    			 {"D3_DOC"    ,_cDoc,							Nil},;
				    			 {"D3_TM"     ,"003",							Nil},;
				    			 {"D3_LOCAL"  ,SD2->D2_LOCAL,					Nil},;
				    			 {"D3_UM"     ,SD2->D2_UM,						Nil},;
				    			 {"D3_QUANT"  ,SD2->D2_QUANT, 					Nil},;
				    			 {"D3_EMISSAO",SD2->D2_EMISSAO,					Nil},;
			 	    			 {"D3_OBS"    ,"PRI/SEC*"+ALLTRIM(SD2->D2_DOC),  			Nil}}
			    
			    	MSExecAuto( { | x,y | MATA240( x,y ) }, aMatriz, 3 )
				 
				 	If lMsErroAuto
				 		msgAlert("ERRO NA TRANSFERÊNCIA! CONTACTE O SETOR DE T.I. !!!")
			 			DisarmTransaction()
				 		If lConfirm
					 		RollBackSX8()
				 			lConfirm	:= .F.
				 		EndIf
				 		Break
				 	Else
				 		If lConfirm
				 			ConfirmSX8()
				 			lConfirm	:= .F.
				 		EndIf
				 	EndIf
				
					cCODSECU := If( Len( AllTrim( SD2->D2_COD ) ) = 8, SUBS( SD2->D2_COD, 1, 1 ) + SUBS( SD2->D2_COD, 3, 3 ) +;
					SUBS( SD2->D2_COD, 7, 2 ), SUBS( SD2->D2_COD, 1, 1 ) + SUBS( SD2->D2_COD, 3, 4 ) +;
					SUBS( SD2->D2_COD, 8, 2 ))
	
					If !SD3->(dbSeek(xFilial("SD3") + SD2->D2_DOC + cCODSECU))
						_cDoc		:= SD2->D2_DOC
					Else    
						_cDoc		:= GetSxeNum("SD3","D3_DOC")
						lConfirm	:= .T.
					EndIf
	
				    aMatriz :=  {{"D3_COD"    ,cCODSECU,					 	Nil},;
			   	    			 {"D3_DOC"    ,_cDoc,					 		Nil},;
				    			 {"D3_TM"     ,"503",						 	Nil},;
				    			 {"D3_LOCAL"  ,SD2->D2_LOCAL,				 	Nil},;
				    			 {"D3_UM"     ,SD2->D2_UM,						Nil},;
				    			 {"D3_QUANT"  ,SD2->D2_QUANT, 					Nil},;
				    			 {"D3_EMISSAO",SD2->D2_EMISSAO,					Nil},;
			 	    			 {"D3_OBS"    ,"PRI/SEC*"+ALLTRIM(SD2->D2_DOC),  			 	Nil}}
			    	MSExecAuto( { | x,y | MATA240( x,y ) }, aMatriz, 3 )
				 	if lMsErroAuto
				 		msgAlert("ERRO NA TRANSFERÊNCIA! CONTACTE O SETOR DE T.I. !!!")
			 			DisarmTransaction()
				 		If lConfirm
					 		RollBackSX8()
				 			lConfirm	:= .F.
				 		EndIf
				 		Break
				 	Else
				 		If lConfirm
				 			ConfirmSX8()
				 			lConfirm	:= .F.
				 		EndIf
				 	EndIf
				End Transaction		 			

			Endif

		EndIf

		//Termina aqui as movimentacoes dos Genericos
		DbSelectArea("SD2")
		SD2->( dbSkip() )
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Duplicatas na Rava                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("SX6")
	If SX6->( dbSeek( xFilial( "SX6" ) + "MV_TXPER  " ) )
		nPORCJUR := Val( SX6->X6_CONTEUD )
	EndIf
	
	DbSelectArea("SE1")
	SE1->( DbSetOrder( 1 ) )
	SE1->( dbSeek( xFilial( "SE1" ) + SF2->F2_SERIE+SF2->F2_DOC, .T. ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Historico da duplicata o telefone e o rec. de cheques  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cHist  := Alltrim( SA1->A1_TEL )
	cHIst  := cHist + iif( Substr( SC5->C5_TIPAGTO, 1, 1 )=="C"," - Ch.nao Rc",iif( Substr( SC5->C5_TIPAGTO, 1, 1 )=="R"," - Ch.Receb.","" ) )
	cHist1 := Alltrim( SA1->A1_TEL )
	cHIst1 := cHist + iif( Substr( SC5->C5_TIPAGTO, 2, 1 )=="C"," - Ch.nao Rc",iif( Substr( SC5->C5_TIPAGTO, 2, 1 )=="R"," - Ch.Receb.","" ) )
	//Aqui
//	aESTRU := XE1->( DbStruct() )
	nCONT  := 1
	If ! Empty( SF2->F2_DUPL ) .and. SF2->F2_SERIE+SF2->F2_DOC # SE1->E1_PREFIXO+SE1->E1_NUM .and. !(SC5->C5_TIPO$"DBI")
		MsgBox( "Titulo " + SF2->F2_DOC+SF2->F2_SERIE + " nao incluido na RAVA 1, avise a Informatica.","INFO","STOP")
	EndIf

	DbSelectArea("SE1")
	While SF2->F2_SERIE+SF2->F2_DOC == SE1->E1_PREFIXO+SE1->E1_NUM .AND. SE1->( !Eof() )
        //Inclui esta condicao para nao alterar outros tipos titulos com o mesmo numero (Eurivan - 22/04/09)
        If alltrim(SE1->E1_TIPO) == "NF" 
	        //Pego as datas de Vencimentos
			cProrr += Dtoc(SE1->E1_VENCREA)+","
            
            //Guardo Num. Empenho - Incluido Eurivan 21/07/09
          cEmpenho := SC5->C5_NUMEMP
	
			RecLock( "SE1", .f. )
        	SE1->E1_NATUREZ := "10101" //COBRANCA BANCARIA
			SE1->E1_HIST    := Alltrim(cHist)+iif(!Empty(cEmpenho),Alltrim("Empenh."+cEmpenho),"") //Alterado em 21/07/09 Eurivan
			SE1->E1_INSTR1  := "01"
			SE1->E1_SUPERVI := cSuper
			
			//Inclui em 16/12/09 - Gravar segmento no titulo - Eurivan
			SE1->E1_SATIV1 := SA1->A1_SATIV1
			//Até aqui
			
			SE1->( MsUnlock() )
			SE1->( dbCommit() )
	    endif

   	    SE1->( dbSkip() )	
	EndDo
    cProrr := Subs(cProrr,1,Len(cProrr)-1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Livros fiscais na Rava                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// custonRava 
	SF3->( dbSetOrder( 4 ) )
	If SF3->( dbSeek( xFilial( "SF3" ) + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_DOC + SF2->F2_SERIE ) )
		RecLock( "SF3", .F. )
		If SUBSTR(SF3->F3_CFO,1,2) $ '51/61' 
           If ! ALLTRIM(SF3->F3_CFO) $ '6107/6109' // suframa 		   
		         SF3->F3_OUTRICM := SF3->F3_VALIPI
		   EndIF   
		Endif 
		If SF3->F3_CFO='6111' // AMOSTRA
		   SF3->F3_ESTADO := SF2->F2_EST
		ENDIF
		SF3->( MsUnlock() )
		SF3->( dbCommit() )
	Endif	

	
	
	DbSelectArea("SC5")
	if SC5->C5_DESC1 > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Geracao itens nota fiscal Ravitec                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For x := 1 to Len( aDife )
			SB1->( dbSeek( xFilial( "SB1" ) + aDife[ x, 1 ], .t. ) )
			RecLock( "SD2", .T. )
			SD2->D2_FILIAL  := xFilial( "SD2" ); SD2->D2_COD     := aDife[ x, 1 ]
			SD2->D2_UM      := SB1->B1_UM   ;    SD2->D2_SEGUM   := SB1->B1_SEGUM
			SD2->D2_QUANT   := aDife[ x, 2 ]  ;  SD2->D2_PRCVEN  := aDife[ x, 3 ]
			SD2->D2_TOTAL   := Round( aDife[ x, 2 ] * aDife[ x, 3 ], 2 )
			SD2->D2_TES     := aDife[ x, 4 ]  ;  SD2->D2_CF      := aDife[ x, 5 ]
			SD2->D2_PEDIDO  := aDife[ x, 6 ]  ;  SD2->D2_ITEMPV  := aDife[ x, 7 ]
			SD2->D2_CLIENTE := SF2->F2_CLIENTE;  SD2->D2_LOJA    := SF2->F2_LOJA
			SD2->D2_LOCAL   := aDife[ x, 8 ]  ;  SD2->D2_DOC     := SF2->F2_DOC
			SD2->D2_EMISSAO := SF2->F2_EMISSAO;  SD2->D2_GRUPO   := SB1->B1_GRUPO
			SD2->D2_TP      := SB1->B1_TIPO   ;  SD2->D2_SERIE   := "   "
			SD2->D2_PRUNIT  := aDife[ x, 3 ]  ;  SD2->D2_QTSEGUM := aDife[ x, 9 ]
			SD2->D2_NUMSEQ  := " "            ;  SD2->D2_EST     := SA1->A1_EST
			SD2->D2_TIPO    := aDife[ x, 10 ] ;  SD2->D2_ITEM    := StrZero( x, 2 )
			SD2->D2_COMIS1  := aDife[ x, 11 ] ;  SD2->D2_CLASFIS := SD2->D2_CLASFIS
			SD2->( msUnlock() )
			SD2->( dbcommit() )
			nTotDif := nTotDif + SD2->D2_TOTAL
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Geracao Comissao pela emissao Rava 2                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//aDupDna := Condicao( nTotDif, SC5->C5_CONDPA1 )
		aDupDna := Condicao( nTotDif, SC5->C5_CONDPAG )
		nC_emis := SA3->A3_ALEMISS
		nC_baix := SA3->A3_ALBAIXA

		DbSelectArea("SE1")
		SE1->( dbSeek( xFilial( "SE1" ) + SF2->F2_SERIE+SF2->F2_DOC, .T. ) )
		
		nBase    := Round( nTotDif * nC_baix / 100 / Len( aDupDna ),2 )
		nComis   := Round( nBase * SC5->C5_COMIS1 / 100, 2 )
		nComis2  := Round( nBase * SC5->C5_COMIS2 / 100, 2 )
	   nComis3  := Round( nBase * SC5->C5_COMIS3 / 100, 2 )
	   nComis4  := Round( nBase * SC5->C5_COMIS4 / 100, 2 )

		nPorcjur := If( Empty( SE1->E1_PORCJUR ), nPORCJUR, SE1->E1_PORCJUR )
		//nValjur  := If( Empty( SE1->E1_VALJUR ), aDupDna[ x, 2 ] * nPORCJUR / 100, SE1->E1_VALJUR ) Retirado 31/07/08
		//nValjur  := aDupDna[ x, 2 ] * nPORCJUR / 100
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Geracao Duplicatas Rava 2                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For x := 1 to Len( aDupDna )
			RecLock( "SE1", .T. )
			SE1->E1_FILORIG  := xFilial("SE1")  // COLOCADO APOS MIGRACAO PARA O P11 
			SE1->E1_FILIAL  := xFilial("SE1") ;  SE1->E1_PREFIXO := "   "
			SE1->E1_NUM     := SF2->F2_DOC;      SE1->E1_PARCELA := Strzero( x, 1 )
         //Alterei o Tipo de "NP" para "NF", pois os titulos nao estavam sendo excluidos quando excluia a nota
         //Eurivan 15/02/2008
			SE1->E1_TIPO    := "NF"           ;  SE1->E1_NATUREZ := "10104"
			SE1->E1_CLIENTE := SF2->F2_CLIENTE;  SE1->E1_LOJA    := SF2->F2_LOJA
			SE1->E1_NOMCLI  := SA1->A1_NREDUZ ;  SE1->E1_EMISSAO := SF2->F2_EMISSAO
			SE1->E1_VENCTO  := aDupDna[ x, 1] ;  SE1->E1_VENCREA := DataValida( aDupDna[ x, 1 ] )
			SE1->E1_VALOR   := aDupDna[ x, 2 ];  SE1->E1_SITUACA := "0"
			SE1->E1_SALDO   := aDupDna[ x, 2 ];  SE1->E1_VEND1   := SF2->F2_VEND1
         
         //Inclui dia 09/09/16 - Eurivan
         SE1->E1_VEND2   := SF2->F2_VEND2  ;  SE1->E1_VEND3   := SF2->F2_VEND3 ; SE1->E1_VEND4   := SF2->F2_VEND4
			SE1->E1_FLUXO   := "S"            ;  SE1->E1_LA      := "S"
			SE1->E1_EMIS1   := aDupDna[ x, 1 ];  SE1->E1_MOEDA   := 1
			SE1->E1_VLCRUZ  := aDupDna[ x, 2 ];  SE1->E1_ORIGEM  := "MATA460" //SE1->E1_ORIGEM  := "SF2460I"
			SE1->E1_COMIS1  := SC5->C5_COMIS1 ;  SE1->E1_BASCOM1 := nBase
		   
		   //Inclui dia 09/09/16 - Eurivan
			SE1->E1_COMIS2  := SC5->C5_COMIS2 ;  SE1->E1_BASCOM2 := nBase
			SE1->E1_COMIS3  := SC5->C5_COMIS3 ;  SE1->E1_BASCOM3 := nBase
			SE1->E1_COMIS4  := SC5->C5_COMIS4 ;  SE1->E1_BASCOM4 := nBase
			
			SE1->E1_VALCOM1 := nComis         ;  SE1->E1_VENCORI := aDupDna[ x, 1 ]
		   
		   //Inclui dia 09/09/16 - Eurivan
         SE1->E1_VALCOM2 := nComis2        ;  SE1->E1_VALCOM3 := nComis3 ;  SE1->E1_VALCOM4 := nComis4
			
			SE1->E1_PEDIDO  := SC5->C5_NUM    ;  SE1->E1_VALLIQ  := aDupDna[ x, 2 ]
			SE1->E1_PORCJUR := nPorcjur       ;  SE1->E1_VALJUR  := aDupDna[ x, 2 ] * nPORCJUR / 100
			SE1->E1_HIST    := cHist1         ;  SE1->E1_STATUS  := "A"
			/*29/05/09 Chamado 1149*/
			if alltrim(SF2->F2_CLIENTE) $ "001957 001958 003071"
				SE1->E1_DESCONT := SE1->E1_VALOR * 0.03
				
			endIf
			/*29/05/09 Chamado 1149*/
			SE1->( msUnlock() )
			If aDupDna[ x, 2 ] > SA1->A1_MAIDUPL
				RecLock( "SA1", .f. )
				SA1->A1_MAIDUPL := aDupDna[ x, 2 ]
				SA1->( MsUnlock() )
			Endif
		Next
		cDoc := SF2->F2_DOC ; cCliente := SF2->F2_CLIENTE ; cLoja := SF2->F2_LOJA
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava cabecalho de nota fiscal na Rava                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		DbSelectArea("SF2")
		RecLock( "SF2", .T. )
		SF2->F2_FILIAL  := xFilial( "SF2" );  SF2->F2_DOC     := cDoc
		SF2->F2_SERIE   := "   "           ;  SF2->F2_CLIENTE := cCliente
		SF2->F2_LOJA    := cLoja           ;  SF2->F2_COND    := SC5->C5_CONDPAG //SC5->C5_CONDPA1
		SF2->F2_DUPL    := cDoc            ;  SF2->F2_EMISSAO := dDatabase
		SF2->F2_EST     := SA1->A1_EST     ;  SF2->F2_FRETE   := SC5->C5_FRETE
		SF2->F2_SEGURO  := SC5->C5_SEGURO  ;  SF2->F2_TIPOCLI := SA1->A1_TIPO
		SF2->F2_VALBRUT := nTotDif         ;  SF2->F2_VALMERC := nTotDif
		SF2->F2_TIPO    := "N"             ;  SF2->F2_ESPECI1 := SC5->C5_ESPECI1
		SF2->F2_VOLUME1 := SC5->C5_VOLUME1 ;  SF2->F2_TRANSP  := SC5->C5_TRANSP
		SF2->F2_REDESP  := SC5->C5_REDESP  ;  SF2->F2_VEND1   := SC5->C5_VEND1; 
		//Inclui dia 09/09/16 - Eurivan
		SF2->F2_VEND2   := SC5->C5_VEND2   ;  SF2->F2_VEND3   := SC5->C5_VEND3
		SF2->F2_VEND4   := SC5->C5_VEND4   
		//      SF2->F2_OK      := " "             ;  SF2->F2_FIMP    := " "
		SF2->F2_VALFAT  := nTotDif         ;  SF2->F2_ESPECIE := "NF"
		SF2->F2_DESPESA := SC5->C5_DESPESA ;  SF2->F2_PREFIXO := "   "
		SF2->( msUnlock() )
		SF2->( dbcommit() )
		
		DbSelectArea("SA1")
		RecLock( "SA1", .f. )
		if nTotNf+nTotDif > SA1->A1_MCOMPRA
			SA1->A1_MCOMPRA := nTotDif+nTotNf
		endif
		if nTotDif + SA1->A1_SALDUP > SA1->A1_MSALDO
			SA1->A1_MSALDO := SA1->A1_SALDUP + nTotDif
		endif
		if Empty( SA1->A1_PRICOM )
			SA1->A1_PRICOM := dDatabase
		endif
		SA1->A1_SALDUP := SA1->A1_SALDUP + nTotDif
		SA1->A1_VACUM  := SA1->A1_VACUM  + nTotDif
		SA1->( MsUnlock() )
		SA1->( dbCommit() )
	Endif
Endif

//U_MailTransp( cNota, cSerie, 1 ) //voltar

/*
If xFilial("SF2") = '03'	//SE FOR NF SAÍDA DA RAVA CAIXAS
	U_WFFAT010( cNota, cSerie, 1 )    
	//Flávia Rocha - 01/08/2011 - chamado 002140 - envio de email para Emanuel e Alexandre para toda nf transf. Rava p/ Rava
Endif
*/

If SF2->F2_TIPO = 'D'	//Nota de devolução
   U_FINC001()
EndIF

// novo arredondamento
If (nVALEMPE > 0 .and. nVALEMPE != nVALBRUT)
   If ABS(nVALEMPE - nVALBRUT) < 1  .and. ABS(nVALEMPE - nVALBRUT)!=0  //Valor da diferença
         // nDif               cNF 
      fDif(nVALEMPE - nVALBRUT,cNota)
   Endif
Endif

//Restaura as areas
RestArea(aAreaSF3)
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSE1)
//end Transaction

Return(lFlag)


***************

Static Function NFFat(cPedido)

***************
local cQry:=''
local nRet:=0

cQry:="SELECT ISNULL(SUM(F2_VALBRUT),0) F2_VALBRUT FROM "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQry+="WHERE F2_FILIAL='"+XFILIAL('SF2')+"' AND F2_DOC IN (select D2_DOC  from "+RetSqlName("SD2")+" SD2 WITH (NOLOCK) "
cQry+="WHERE "
cQry+="D2_FILIAL='"+XFILIAL('SD2')+"' AND D2_PEDIDO='"+cPedido+"' "
cQry+="AND D2_SERIE!='' "
cQry+="AND SD2.D_E_L_E_T_!='*' "
cQry+="GROUP BY  D2_DOC,D2_SERIE) "
cQry+="AND SF2.D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "_TMPY" 
_TMPY->( dbGotop() )

If  _TMPY->( !Eof() )
    nRet:=_TMPY->F2_VALBRUT
EndIf

_TMPY->(DBCLOSEAREA())

Return nRet


***************

Static Function ZeroIPI(cNota)

***************
Local cQry:=''
Local lRet:=.F.

If Select("IPI") > 0
  DbSelectArea("IPI")
  IPI->(DbCloseArea())
EndIf

cQry:="SELECT  D2_BASEIPI,* FROM "+RetSqlName("SD2")+" SD2 WITH (NOLOCK) "
cQry+="WHERE  D2_DOC='"+cNota+"' "
cQry+="AND D2_IPI=0 "
cQry+="AND D2_FILIAL='"+XFILIAL('SD2')+"'"
cQry+="AND D2_SERIE!='' "
cQry+="AND SD2.D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "IPI"

Do While IPI->( !Eof() )
    lRet:=.T.
    exit
    IPI->(dbseek())
EndDo

IPI->(DBCLOSEAREA())

Return lRet


***************

Static Function Atualiza()

***************

RecLock( "SD2", .F. )	

IF SD2->D2_IPI!=0
	SD2->D2_BASEIPI := round(_nNovBase,2)
ENDIF

SD2->D2_VALIPI  := _nNovIPI
SD2->D2_TOTAL   := round(_nNovBase,2)
SD2->D2_PRCVEN  := ROUND(_nNovBase/SD2->D2_QUANT,6)

SD2->D2_VALICM   += nDif
SD2->D2_BASEICM  += nDif
SD2->D2_BASIMP6  += nDif
SD2->D2_VALBRUT  += nDif
SD2->( MsUnlock() )

                                                                                                   
//Eurivan - 26/08/10
//Altera CD2, tabela de impostos por produto
//ICMS

if CD2->(DbSeek(xFilial("CD2")+"S"+SD2->(D2_SERIE+D2_DOC+D2_CLIENTE+D2_LOJA+D2_ITEM+SPACE(2)+D2_COD)+"ICM   " ))
	RecLock("CD2",.F.)
	CD2->CD2_BC     += nDif
	CD2->CD2_VLTRIB += nDif
	CD2->( MsUnlock())
endif

//IPI
if CD2->(DbSeek(xFilial("CD2")+"S"+SD2->(D2_SERIE+D2_DOC+D2_CLIENTE+D2_LOJA+D2_ITEM+SPACE(2)+D2_COD)+"IPI   " ))
	RecLock("CD2",.F.)
	CD2->CD2_BC     := round(_nNovBase,2)
	CD2->CD2_VLTRIB :=_nNovIPI
	CD2->( MsUnlock())
endif

Return


***************

Static Function NaoIpiBase(cNota)

***************
Local cQry:=''

If Select("_TMZ") > 0
  DbSelectArea("_TMZ")
  _TMZ->(DbCloseArea())
EndIf

cQry:="SELECT D2_TES,F4_INCIDE "
cQry+="FROM "+RetSqlName("SD2")+" SD2 WITH (NOLOCK) ,"+RetSqlName("SF4")+" SF4 WITH (NOLOCK) "  
cQry+="WHERE "
cQry+="D2_TES=F4_CODIGO "
cQry+="AND D2_DOC='"+cNota+"' "
cQry+="AND D2_FILIAL='"+XFILIAL('SD2')+"'"   
cQry+="AND F4_INCIDE='N' AND F4_IPI='S' "   // NAO TEM IPI NA BASE E CALCULA IPI 
cQry+="AND SD2.D_E_L_E_T_!='*' "
cQry+="AND SF4.D_E_L_E_T_!='*'  "
cQry+="GROUP BY D2_TES,F4_INCIDE   "

TCQUERY cQry NEW ALIAS "_TMZ"

iF _TMZ->( !Eof() )  
  Return .T.
EndiF

_TMZ->(DBCLOSEAREA())

Return .F.



*************

Static Function fDif(nDif,cNf)

*************


cQuery :="DECLARE @VAR1 float SET @VAR1 ="+ALLTRIM(STR(nDif))+" " 
cQuery +="DECLARE @doc varchar(9) SET @doc ='"+cNf+"' "

cQuery +="BEGIN TRANSACTION "
//SD2- ITEN DA NOTA 
cQuery +="UPDATE "+RetSqlName("SD2")+" SET D2_BASEICM=D2_BASEICM+@VAR1,D2_VALBRUT=D2_VALBRUT+@VAR1,D2_VALIPI=D2_VALIPI+@VAR1 "
cQuery +="WHERE D2_DOC=@doc AND D2_SERIE<>'' AND D2_ITEM='01' "
//SF2 - CABEÇACHO DA NOTA
cQuery +="UPDATE "+RetSqlName("SF2")+" SET F2_VALBRUT=F2_VALBRUT+@VAR1,F2_BASEICM=F2_BASEICM+@VAR1,F2_VALIPI=F2_VALIPI+@VAR1,F2_VALFAT=F2_VALFAT+@VAR1 "
cQuery +="WHERE F2_DOC=@doc AND F2_SERIE<>'' "
//SF3 - CABEÇACHO DO LIVRO
cQuery +="UPDATE "+RetSqlName("SF3")+" SET F3_VALCONT=F3_VALCONT+@VAR1,F3_BASEICM=F3_BASEICM+@VAR1,F3_VALIPI=F3_VALIPI+@VAR1 "
cQuery +="WHERE F3_NFISCAL=@doc AND F3_SERIE<>'' "
cQuery +="AND F3_CFO=(SELECT TOP 1 F3_CFO FROM SF3020 WHERE F3_NFISCAL=@doc AND F3_SERIE<>'' ORDER BY R_E_C_N_O_) "
//SFT - ITEN DO LIVRO
cQuery +="UPDATE "+RetSqlName("SFT")+" SET FT_VALCONT=FT_VALCONT+@VAR1,FT_BASEICM=FT_BASEICM+@VAR1,FT_VALIPI=FT_VALIPI+@VAR1 "
cQuery +="WHERE FT_NFISCAL=@doc AND FT_SERIE<>'' AND FT_ITEM='01' "
//CD2 - IMPOSTO ICM
cQuery +="UPDATE "+RetSqlName("CD2")+" SET CD2_BC=CD2_BC+@VAR1 "
cQuery +="WHERE CD2_DOC=@doc AND CD2_SERIE<>'' AND CD2_ITEM='01' "
cQuery +="AND CD2_IMP='ICM ' "
//CD2 - IMPOSTO IPI 
cQuery +="UPDATE "+RetSqlName("CD2")+" SET CD2_VLTRIB=CD2_VLTRIB+@VAR1 "
cQuery +="WHERE CD2_DOC=@doc AND CD2_SERIE<>'' AND CD2_ITEM='01' "
cQuery +="AND CD2_IMP='IPI ' "
//SE1 - TITULO 
cQuery +="UPDATE "+RetSqlName("SE1")+" SET E1_VALOR=E1_VALOR+@VAR1,E1_SALDO=E1_SALDO+@VAR1,E1_VLCRUZ=E1_VLCRUZ+@VAR1 "
cQuery +="WHERE E1_NUM=@doc AND E1_PREFIXO<>'' "

cQuery +="COMMIT " 

TcSqlExec(cQuery)	 

 
Return                 

***************

Static Function fAtuEst(cTes)

***************

Local lRet:=.F.
Local cQry:=" "

cQry:="SELECT "
cQry+="F4_ESTOQUE "
cQry+="FROM SF4010  SF4 "
cQry+="WHERE F4_CODIGO='"+cTes+"' "
cQry+="AND F4_ESTOQUE<>'N' " //ATUALIZA ESTOQUE 
cQry+="AND SF4.D_E_L_E_T_='' "

If Select("F4X") > 0
	DbSelectArea("F4X")
	F4X->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "F4X"

If F4X->(!EOF())
   
   lRet:=.T.

EndIf

F4X->(dbclosearea())


Return lRet
