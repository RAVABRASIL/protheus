#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"

User Function SF2520E()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NHDLPRV,CARQUIVO,NTOTAL,CLOTE")
SetPrvt("CARQ,NC6ORD,NC6REG,ND2ORD,ND2REG,ADUPLIC")
SetPrvt("NC_EMIS,NC_BAIX,NE1ORD,NE1REG,NF2ORD,NREGF2")
SetPrvt("CDOC,cCODSECU,")
lMsErroAuto := .F.
lConfirm	:= .F.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SF2520E                                          ³ 03/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Exclusao de notas fiscais - RAVA                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

cNota  := SF2->F2_DOC
cSerie := SF2->F2_SERIE
cTipoNF:= SF2->F2_TIPO

//cAlias := dbSelectArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcoes para lancamento padrao                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//nHdlPrv := HeadProva( cLote, "SF2520E",Substr( cUsuario,7,6 ), @cArquivo )

///////////////////////////////////////////////////////////////
////FLAVIA ROCHA - FR - 02/06/2011
///exclui as ligações do SAC ref. a NF - se existirem  
////////////////////////////////////////////////////////////////
//-----------------------SUC
LF			:= CHR(13) + CHR(10)
cUCcodigo 	:= ""
cChave		:= ""
cFilialUC	:= ""
				
cQuery := " Select TOP 1 UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, UC_STATUS, UC_AGANTES  "+LF
cQuery += " From " + Retsqlname("SUC") + " SUC "+LF
cQuery += " Where ( SUC.UC_NFISCAL ) = '" + Alltrim( cNota ) + "' "+LF
cQuery += " and (SUC.UC_SERINF) = '" + Alltrim(cSerie) + "' "+LF
cQuery += " and SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF
cQuery += " and SUC.UC_STATUS <> '3' "+LF
cQuery += " and SUC.D_E_L_E_T_ = ''"+LF
cQuery += " Order by SUC.UC_DATA " +LF
//MemoWrite("\TempQry\VerSUC-2.sql",cQuery)
  
If Select("SUCX") > 0
	DbSelectArea("SUCX")
	DbCloseArea()	
EndIf 
	
TCQUERY cQuery NEW ALIAS "SUCX"
			
//TCSetField( 'SUCX', "UC_AGANTES", "D")
				
SUCX->(Dbgotop())
While SUCX->(!EOF())
 	cUCcodigo 	:= SUCX->UC_CODIGO
	cChave		:= SUCX->UC_CHAVE
	cFilialUC	:= SUCX->UC_FILIAL
	
	DbSelectArea("SUCX")
	SUCX->(Dbskip())
		 
Enddo
			
If !Empty( cUCcodigo )

  	DbselectArea("SUC")
	Dbsetorder(1)
	If SUC->(Dbseek(xFilial("SUC") + cUCcodigo ))						

	  	While SUC->(!EOF()) .And. SUC->UC_FILIAL == xFilial("SUC") .And. SUC->UC_CODIGO == cUCcodigo

	  		RecLock("SUC", .F.)					  							  	
			SUC->( dbDelete() )
			SUC->(MsUnlock())
			SUC->(DBSKIP())
	  	Enddo
	  	DbselectArea("SUC")
		SUC->(DbcloseArea())			  	
				
	Endif
					
	//--------------------SU6
	cLista := ""
	cCodLig:= cUCcodigo
						
	cQuery := " Select TOP 1 U6_DATA, U6_LISTA, U6_CODLIG, U6_NFISCAL, U6_SERINF, U6_CODENT "+LF
	cQuery += " From " + Retsqlname("SU6") + " SU6 "+LF
	cQuery += " Where (SU6.U6_CODLIG) = '" + Alltrim(cCodLig) + "' "+LF
	cQuery += " and ( SU6.U6_NFISCAL ) = '" + Alltrim( cNota ) + "' "+LF
	cQuery += " and ( SU6.U6_SERINF ) = '" + Alltrim(cSerie) + "' "+LF
	cQuery += " and (SU6.U6_TIPO) = '5' " +LF
	cQuery += " and (U6_STATUS) = '1' "+LF
	cQuery += " and SU6.U6_FILIAL = '" + xFilial("SU6") + "' "+LF
	cQuery += " and SU6.D_E_L_E_T_ = ' ' "+LF
	cQuery += " Order by U6_DATA DESC "+LF
		  
	If Select("SU6X") > 0
		DbSelectArea("SU6X")
		DbCloseArea()	
	EndIf 
		
	TCQUERY cQuery NEW ALIAS "SU6X"
	SU6X->(Dbgotop())
	While SU6X->(!EOF())
	  	cLista    := SU6X->U6_LISTA
		
		DbselectArea("SU6X")
	    SU6X->(Dbskip())				
	Enddo
					
	DbselectArea("SU6")
	SU6->(DbsetOrder(1))
	If SU6->(Dbseek(xFilial("SU6") + cLista ))
		While SU6->U6_FILIAL == xFilial("SU6") .and. Alltrim(SU6->U6_LISTA) == Alltrim(cLista)
			If Alltrim(SU6->U6_CODLIG) = Alltrim(cCodLig) .AND. Alltrim(SU6->U6_NFISCAL) = Alltrim(cNota);
			.and. Alltrim(SU6->U6_SERINF) = Alltrim(cSerie) .and. Alltrim(U6_TIPO) = '5';
			.and. Alltrim(SU6->U6_STATUS) = '1'
								  				
	  			RecLock("SU6", .F.)
				SU6->( dbDelete() )
	 			SU6->(MsUnlock())
	  		Endif
			SU6->(Dbskip())
		Enddo
	Endif
	
	///SU4
	DBSELECTAREA("SU4")
	DBSETORDER(1)         // U4_FILIAL + U4_LISTA
	If SU4->(DbSeek(xFilial("SU4") + cLista ))
		While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_LISTA == cLista
			If Alltrim(SU4->U4_CODLIG) = Alltrim(cCodLig)
				RecLock("SU4",.F.)
				SU4->( dbDelete() )
				SU4->(MsUnlock())
			Endif
			SU4->(Dbskip())
		Enddo
	Endif
					
Endif
////////////////////////////////////////
///fim dos processos relativos ao SAC
//////////////////////////////////////////

//if SM0->M0_CODIGO == "02" .and. SF2->F2_SERIE == "UNI"
if SM0->M0_CODIGO == "02" .and. SF2->F2_SERIE $ "UNI/0  "
	
	//Incluido por Eurivan
	//Exclui Movimentacao dos produtos Primario para Secundario
	SD2->( dbSetOrder( 3 ) )
	SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
	
	DbSelectArea( "SD3" )
	SD3->( dbSetOrder( 2 ) )
	
	Do while SD2->D2_DOC == SF2->F2_DOC .and. SD2->( !Eof() )
	//msgAlert("TES: "+SD2->D2_TES)
	/*15/04/09 Movimentação dos almoxarifados 09 e 10, caso TES seja 540*/
	if SD2->D2_TES == '540'
		Begin Transaction
			/*Movimentando retirando do almoxarifado 09*/
		    aMatriz :=  {{"D3_COD"    ,SD2->D2_COD,											 	Nil},;
	   	    			 {"D3_DOC"    ,SD2->D2_DOC,											 	Nil},;
		    			 {"D3_TM"     ,"503",												 	Nil},;
		    			 {"D3_LOCAL"  ,if(SF2->F2_TRANSIT == 'N',"10","09"),				 	Nil},;
		    			 {"D3_UM"     ,posicione("SB1",1,xFilial('SB1') + SD2->D2_COD,"B1_UM"), Nil},;
		    			 {"D3_QUANT"  ,SD2->D2_QUANT, 											Nil},;
		    			 {"D3_EMISSAO",dDataBase,												Nil},;
	 	    			 {"D3_OBS"    ,"Cancelamento "+if(SF2->F2_TRANSIT == 'N',"10","09"),Nil}}
	    	lMsErroAuto := .F.
	    	MSExecAuto( { | x,y | MATA240( x,y ) }, aMatriz, 3 )
		 	if lMsErroAuto
		 		msgAlert("ERRO NA TRANSFERÊNCIA! CONTACTE O SETOR DE T.I. !!!")
	 		    DisarmTransaction()
		 		Return
		 	endIf
    	End Transaction
	endIf	
	/*15/04/09*/
		
    /* // alterado em 10/02/09 chamado 000784 Incluido por Eurivan 05/05/08 Atualizacao do Pre-Pedido INICIO
    	SC6->( dbSeek( xFIlial( "SC6" ) + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD, .t.  ) )
		DbSelectArea("SZ6")
		DbSetOrder(2)
		if SZ6->(DbSeek(xFilial("SZ6")+SC6->C6_PRODUTO+SC6->C6_PREPED))
		   RecLock("SZ6", .F.)
           SZ6->Z6_QTDENT -= SD2->D2_QUANT          
           SZ6->( msUnlock() )
           SZ6->( dbCommit() )   		

           //Posiciono no cab. Pre-Pedido
           DbSelectArea("SZ5")
           DbSetOrder(1)       
           SZ5->(DbSeek(xFilial("SZ5")+SC6->C6_PREPED))
           //Posiciono no Cab. Edital
           DbSelectArea("Z17")
           DbSetOrder(1)

           if Z17->(DbSeek(xFilial("Z17")+SZ5->Z5_EDITAL))
              RecLock("Z17",.F.)
              if U_GetSldPP(SC6->C6_PREPED) <= 0
                 Z17->Z17_STATUS := '03' //Edital Concluido
            //else
                //if U_GetPartRV(SZ5->Z5_EDITAL)
                //   Z17->Z17_STATUS := '  ' //Edital em Andamento              
                //else
                   // Z17->Z17_STATUS := '01' //Edital nao participamos
                //endif Retirado em 19/06/2008 por Emmanuel Lacerda   
              endif
              Z17->(MsUnlock())
           endif
		endif	
        //Incluido por Eurivan 05/05/08 Atualizacao do Pre-Pedido FIM		*/
		
		
		
		//Exclui Secundario
		/*
		if SD3->( dbSeek( xFilial( "SD3" ) + SD2->D2_DOC + SD2->D2_COD, .T. ) )
			RecLock( "SD3", .f. )
			SD3->( dbDelete() )
			SD3->( msUnlock() )
			SD3->( dbcommit() )
			
			SB2->( dbSetOrder( 1 ) )
			DbSelectArea( "SB2" )
			If SB2->( dbSeek( xFILIAL( "SB2" ) + AllTrim( SD2->D2_COD ), .T. ) )
				If RecLock( "SB2", .F. )
					SB2->B2_QATU  := SB2->B2_QATU - SD2->D2_QUANT
					SB2->B2_VATU1 := SB2->B2_VATU1 - ( SD2->D2_QUANT * SB2->B2_CM1 )
					SB2->( msUnlock() )
					SB2->( dbCommit() )
				EndIf
			EndIf
		endif
		
		
		//Exclui Primario
		cCODSECU := SD2->D2_COD
		If Len( AllTrim( SD2->D2_COD ) ) >= 8
			cCODSECU := If( Len( AllTrim( SD2->D2_COD ) ) == 8, SUBS( SD2->D2_COD, 1, 1 ) + SUBS( SD2->D2_COD, 3, 3 ) +;
			SUBS( SD2->D2_COD, 7, 2 ), SUBS( SD2->D2_COD, 1, 1 ) + SUBS( SD2->D2_COD, 3, 4 ) +;
			SUBS( SD2->D2_COD, 8, 2 ))
		EndIf
		if SD3->( dbSeek( xFilial( "SD3" ) + SD2->D2_DOC + cCODSECU, .t. ) )
			RecLock( "SD3", .f. )
			SD3->( dbDelete() )
			SD3->( msUnlock() )
			SD3->( dbcommit() )
			
			SB2->( dbSetOrder( 1 ) )
			DbSelectArea( "SB2" )
			If SB2->( dbSeek( xFILIAL( "SB2" ) + cCODSECU, .t. ) )
				If RecLock( "SB2", .F. )
					SB2->B2_QATU  := SB2->B2_QATU + SD2->D2_QUANT
					SB2->B2_VATU1 := SB2->B2_VATU1 + ( SD2->D2_QUANT * SB2->B2_CM1 )
					SB2->( msUnlock() )
					SB2->( dbCommit() )
				Endif
			EndIf
		endif
		*/

		// inicio da customização da exclusao do secuntario e primario   
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
				    			 {"D3_TM"     ,"503",							Nil},;
				    			 {"D3_LOCAL"  ,SD2->D2_LOCAL,					Nil},;
				    			 {"D3_UM"     ,SD2->D2_UM,						Nil},;
				    			 {"D3_QUANT"  ,SD2->D2_QUANT, 					Nil},;
				    			 {"D3_EMISSAO",SD2->D2_EMISSAO,					Nil},;
			 	    			 {"D3_OBS"    ,"SEC/PRI*"+ALLTRIM(SD2->D2_DOC),  			Nil}}
			    
			    	lMsErroAuto := .F.
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
				    			 {"D3_TM"     ,"003",						 	Nil},;
				    			 {"D3_LOCAL"  ,SD2->D2_LOCAL,				 	Nil},;
				    			 {"D3_UM"     ,SD2->D2_UM,						Nil},;
				    			 {"D3_QUANT"  ,SD2->D2_QUANT, 					Nil},;
				    			 {"D3_EMISSAO",SD2->D2_EMISSAO,					Nil},;
			 	    			 {"D3_OBS"    ,"SEC/PRI*"+ALLTRIM(SD2->D2_DOC),  			Nil}}
			 	    			 
			    	lMsErroAuto := .F.
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
		
		Endif		
		// fim da customização da exclusao do secuntario e primario 
		
		SD2->( dbSkip() )
	EndDo
	
	//   cArquivo := ""
	nTotal   := 0
	//   SX5->( dbSeek( xFilial( "SX5" ) + "09FAT", .t. ) )
	//   cLote := Alltrim( SX5->X5_DESCRI )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui cabecalho de nota fiscal na Rava                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	/* Excluido por Eurivan
	
	if Select( "XF2" ) == 0
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
	cArq := Alltrim( SX6->X6_CONTEUD ) + "SF2010"
	Use (cArq) ALIAS XF2 VIA "TOPCONN" NEW SHARED
	dbSetindex( ( cArq ) )
	DbSelectArea("XF2")
	endif
	
	XF2->( dbSeek( xFilial( "SF2" ) + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
	if XF2->( !Eof() )
	RecLock( "XF2", .F. )
	XF2->( dbDelete() )
	XF2->( msUnlock() )
	XF2->( dbcommit() )
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui itens de nota fiscal na Rava                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if Select( "XD2" ) == 0
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
	cArq := Alltrim( SX6->X6_CONTEUD ) + "SD2010"
	Use (cArq) ALIAS XD2 VIA "TOPCONN" NEW SHARED
	dbSetindex( ( cArq ) )
	DbSelectArea("XD2")
	endif
	
	XD2->( dbSetOrder( 3 ) )
	XD2->( dbSeek( xFilial( "SF2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao SC5 - Rava                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Select( "XC5" ) == 0
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
	cArq := Alltrim( SX6->X6_CONTEUD ) + "SC5010"
	Use (cArq) ALIAS XC5 VIA "TOPCONN" NEW SHARED
	dbSetIndex( ( cArq ) )
	DbSelectArea("XC5")
	endif
	XC5->( dbSeek( xFilial( "SC5" ) + XD2->D2_PEDIDO ) )
	
	RecLock( "XC5", .f. )
	XC5->C5_NOTA  := Space(06)
	XC5->C5_SERIE := Space(03)
	XC5->( msUnlock() )
	XC5->( dbCommit() )
	
	while XD2->D2_DOC == SF2->F2_DOC .and. XD2->( !Eof() )
	
	nC6Ord := SC6->( dbSetOrder() )
	nC6Reg := SC6->( Recno() )
	if XD2->D2_SERIE == SF2->F2_SERIE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cancela  Preco venda - Ravitec                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SC6->( dbSetOrder( 1 ) )
	SC6->( dbSeek( xFIlial( "SC6" ) + XD2->D2_PEDIDO + XD2->D2_ITEMPV ) )
	RecLock( "SC6", .F. )
	//* SC6->C6_PRCV   := SC6->C6_PRCVEN
	SC6->C6_PRCVEN := SC6->C6_PRCV
	SC6->C6_VALOR  := SC6->C6_PRCV * SC6->C6_QTDVEN
	SC6->( msUnlock() )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao SC6 - Rava                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Select( "XC6" ) == 0
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
	cArq := Alltrim( SX6->X6_CONTEUD ) + "SC6010"
	Use (cArq) ALIAS XC6 VIA "TOPCONN" NEW SHARED
	dbSetIndex( ( cArq ) )
	DbSelectArea("XC6")
	endif
	
	XC6->( dbSeek( xFilial( "SC6" ) + XD2->D2_PEDIDO + XD2->D2_ITEMPV ) )
	RecLock( "XC6", .F. )
	XC6->C6_QTDEMP := SC6->C6_QTDEMP
	XC6->C6_NOTA   := Space(06)         ; XC6->C6_SERIE  := Space(03)
	XC6->C6_DATFAT := Ctod( "  /  /  " ); XC6->C6_QTDENT := XC6->C6_QTDENT-XD2->D2_QUANT
	XC6->C6_OP     := Space(02)         ; XC6->C6_DTVALID:= Ctod( "  /  /  " )
	XC6->( msUnlock() )
	XC6->( dbcommit() )
	
	RecLock( "XD2", .F. )
	XD2->( dbDelete() )
	XD2->( msUnlock() )
	
	endif
	
	XD2->( dbSkip() )
	
	end
	
	SC6->( dbSetOrder( nC6Ord ) )
	
	//   SC6->( dbGoto( nC6Reg ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao Duplicatas na Rava                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if Select( "XE1" ) == 0
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
	cArq := Alltrim( SX6->X6_CONTEUD ) + "SE1010"
	Use (cArq) ALIAS XE1 VIA "TOPCONN" NEW SHARED
	dbSetindex( ( cArq ) )
	DbSelectArea("XE1")
	endif
	
	XE1->( dbSeek( xFilial( "SE1" ) + SF2->F2_SERIE+SF2->F2_DOC, .T. ) )
	while SF2->F2_SERIE+SF2->F2_DOC == XE1->E1_PREFIXO+XE1->E1_NUM .and. XE1->( !Eof() )
	RecLock( "XE1", .F. )
	XE1->( dbDelete() )
	XE1->( msUnlock() )
	XE1->( dbSkip() )
	end
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui Livros fiscais na Rava                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	/*Excluido por Diego
	if Select( "XF3" ) == 0
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
	cArq := Alltrim( SX6->X6_CONTEUD ) + "SF3010"
	Use (cArq) ALIAS XF3 VIA "TOPCONN" NEW SHARED
	dbSetindex( ( cArq ) )
	DbselectArea("XF3")
	endif
	*/ //Ate aqui
	
	//Incluido por Diego
	if Select( "XF3" ) == 0
		cArq := "SF3010"
		Use (cArq) ALIAS XF3 VIA "TOPCONN" NEW SHARED
		U_AbreInd( cARQ )
	endif
	//Ate aqui!!!!
	
	XF3->( dbSetOrder( 1 ) )
	XF3->( dbSeek( xFilial( "SF3" ) + Dtos( SF2->F2_EMISSAO ) + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )
	if XF3->F3_ENTRADA == SF2->F2_EMISSAO .and. XF3->F3_NFISCAL+XF3->F3_SERIE+XF3->F3_CLIEFOR+XF3->F3_LOJA == SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		RecLock( "XF3", .F. )
		XF3->F3_OBSERV := "NF CANCELADA"
		XF3->F3_DTCANC := dDataBase
		XF3->( MsUnlock() )
		
	endif
	
	//Incluindo ate aqui
	//Eurivan tinha excluido ate aqui
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao itens nota fiscal Ravitec                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nD2Ord := SD2->( dbSetOrder() )
	nD2Reg := SD2->( Recno() )
	
	SD2->( dbSetOrder( 3 ) )
	SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + "   ", .t. ) )
	
	while SD2->D2_DOC == SF2->F2_DOC .and. SD2->( !Eof() )
		if SD2->D2_SERIE == "   "
			//nTotal := nTotal + DetProva( nHdlPrv,"630","SF2520E",cLote )
			RecLock( "SD2", .f. )
			SD2->( dbDelete() )
			SD2->( msUnlock() )
			SD2->( dbcommit() )
		endif
		
		SD2->( dbSkip() )
	end
	
	SD2->( dbSetOrder( 1 ) )
//	SD2->( dbSetOrder( nD2Ord ) )
	SD2->( dbGoto( nD2Reg ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Geracao Comissao pela emissao Ravitec                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aDuplic := Condicao( nTotal, SF2->F2_COND )
	nC_emis := SA3->A3_ALEMISS
	nC_baix := SA3->A3_ALBAIXA
	
	SE3->( dbSeek( xFilial( "SE3" ) + "   " + SF2->F2_DOC, .t. ) )
	Do while SE3->E3_PREFIXO+SE3->E3_NUM == "   "+SF2->F2_DOC .and. SE3->( !Eof() )
		if SE3->E3_PARCELA == " "
			Reclock( "SE3", .F. )
			SE3->( dbDelete() )
			SE3->( msUnlock() )
		endif
		SE3->( dbSkip() )
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao de duplicata Ravitec                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nE1Ord := SE1->( dbSetOrder() )
	nE1Reg := SE1->( Recno() )
	
	SE1->( dbSetOrder( 1 ) )
	SE1->( dbSeek( xFilial( "SF2" ) + "   " + SF2->F2_DOC, .T. ) )
	
	Do while SE1->E1_PREFIXO+SE1->E1_NUM == "   "+SF2->F2_DOC .and. SE1->( !Eof() )
		RecLock( "SE1", .F. )
		SE1->( dbDelete() )
		SE1->( msUnlock() )
		SE1->( dbSkip() )
	EndDo
	
	SE1->( dbSetOrder( 1 ) )
//	SE1->( dbSetOrder( nE1Ord ) )
	SE1->( dbGoto( nE1Reg ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui cabecalho de nota fiscal na Ravitec                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nF2Ord := SF2->( dbSetOrder() )
	nRegF2 := SF2->( Recno() )
	cDoc   := SF2->F2_DOC
	SF2->( dbSetOrder( 1 ) )
	SF2->( dbSeek( xFilial( "SF2" ) + SF2->F2_DOC + "   " + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
	If SF2->F2_DOC == cDoc .and. SF2->F2_SERIE == "   "
		RecLock( "SF2", .F. )
		SF2->( dbDelete() )
		SF2->( msUnlock() )
		SF2->( dbcommit() )
	Endif
	
	SF2->( dbSetOrder( 1 ) )
//	SF2->( dbSetOrder( nF2Ord ) )
	SF2->( dbGoto( nRegF2 ) )
	
elseif SM0->M0_CODIGO == "02" .and. SF2->F2_SERIE == "   "
	
	nD2Ord := SD2->( dbSetOrder() )
	nD2Reg := SD2->( Recno() )
	
	nC6Ord := SC6->( dbSetOrder() )
	nC6Reg := SC6->( Recno() )
	
	SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
	
	while SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE .and. SD2->( !Eof() )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancela  Preco venda - Ravitec                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		SC6->( dbSetOrder( 1 ) )
		SC6->( dbSeek( xFIlial( "SC6" ) + SD2->D2_PEDIDO + SD2->D2_ITEMPV ) )
		RecLock( "SC6", .F. )
		//* SC6->C6_PRCV   := SC6->C6_PRCVEN
		SC6->C6_PRCVEN := SC6->C6_PRCV
		SC6->C6_VALOR  := SC6->C6_PRCV * SC6->C6_QTDVEN
		SC6->( msUnlock() )
		SD2->( dbSkip() )
		
	end
	
	SC6->( dbSetOrder( 1 ) )
//	SC6->( dbSetOrder( nC6Ord ) )
	//   SC6->( dbGoto( nC6Reg ) )
	
	SD2->( dbSetOrder( 1 ) )
//	SD2->( dbSetOrder( nD2Ord ) )
	SD2->( dbGoto( nD2Reg ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao Comissao pela emissao Ravitec                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SE3->( dbSeek( xFilial( "SE3" ) + "   " + SF2->F2_DOC, .t. ) )
	while SE3->E3_PREFIXO+SE3->E3_NUM == "   "+SF2->F2_DOC .and. SE3->( !Eof() )
		if SE3->E3_PARCELA == " "
			Reclock( "SE3", .F. )
			SE3->( dbDelete() )
			SE3->( msUnlock() )
		endif
		SE3->( dbSkip() )
	end
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao de duplicata Ravitec                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nE1Ord := SE1->( dbSetOrder() )
	nE1Reg := SE1->( Recno() )
	
	SE1->( dbSetOrder( 1 ) )
	SE1->( dbSeek( xFilial( "SE1" ) + "   " + SF2->F2_DOC, .T. ) )
	
	while SE1->E1_PREFIXO + SE1->E1_NUM == "   " + SF2->F2_DOC .and. SE1->( !Eof() )
		RecLock( "SE1", .F. )
		SE1->( dbDelete() )
		SE1->( msUnlock() )
		SE1->( dbSkip() )
	end
	
	SE1->( dbSetOrder( 1 ) )
//	SE1->( dbSetOrder( nE1Ord ) )
	SE1->( dbGoto( nE1Reg ) )
	
endif

//RodaProva( nHdlPrv, nTotal )
//cA100incl( cArquivo, nHdlPrv,3,cLote,.f.,.f.)


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(lFlag)


Just() // JUSTIFICATIVA DO CANCELAMENTO DA NOTA 

If Alltrim( SF2->F2_CLIENTE ) != ' '
	U_MAILDEVNF(cNota, cSerie, cTipoNF )      	//voltar
	// testo se ja foi transmitida
	IF EMPTY( SF2->F2_CHVNFE )
	   //U_MailTransp( cNota, cSerie, 2 ) 	//voltar
	ENDIF
EndIf

If xFilial("SF2") = '03'	//SE FOR NF SAÍDA DA RAVA CAIXAS
	U_WFFAT010( cNota, cSerie, 2 )    
	//Flávia Rocha - 01/08/2011 - chamado 002140 - envio de email para Emanuel e Alexandre para toda nf transf. Rava p/ Rava
Endif
		

Return        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02



***************

Static Function Just()

***************
local _cJustNF:=space(100)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgJ","oSay1","oGet1","oBtn1")
PRIVATE lSalvou:=.F.
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgJ      := MSDialog():New( 240,488,336,972,"Nota Fisca",,,.F.,,,,,,.T.,,,.F. )
oSay1      := TSay():New( 006,002,{||"Justificativa:"},oDlgJ,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,006)
oGet1      := TGet():New( 013,002,{|u| If(PCount()>0,_cJustNF:=u,_cJustNF)},oDlgJ,229,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cJustNF",,)
oBtn1      := TButton():New( 028,194,"OK",oDlgJ,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||getObs(_cJustNF)}

oDlgJ:Activate(,,,.T.)

If EMPTY(_cJustNF) .AND. !lSalvou
   Just()
Endif

Return

***************

Static Function getObs(_cJustNF)

**************

If !EMPTY(_cJustNF)
    
    // Tabela de justificativa de cancelamento da NF
    RecLock( "Z75", .T. )
	Z75->Z75_FILIAL  :=xFilial('SF2')
	Z75->Z75_DOC     :=SF2->F2_DOC 
	Z75->Z75_SERIE   :=SF2->F2_SERIE 
	Z75->Z75_CLIENTE :=SF2->F2_CLIENTE
	Z75->Z75_LOJA    := SF2->F2_LOJA
	Z75->Z75_EMISSA  :=SF2->F2_EMISSAO
	Z75->Z75_DTCANC  :=dDataBase                  
	Z75->Z75_HORA    := Left( Time(), 5 )
	Z75->Z75_JUSTCA  :=_cJustNF 
	Z75->Z75_TIPO  :=SF2->F2_TIPO
	Z75->( MsUnlock() )
    
    lSalvou:=.T.
    oDlgJ:end()
ELSE
    ALERT("A Justificativa nao pode ser Vazia!!!")
ENDIF

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
