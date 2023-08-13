#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

***************************
User Function SACI008()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
***************************

//Após a baixa do título a receber. 
//Neste momento todos os registros já foram atualizados 
//e destravados e a contabilização já foi efetuada.	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nDias 	:= 0
Local nPrazoEnt := 0

SetPrvt("CARQ,NE5ORD,NE5REG,NLIN,NIPI,NREG")
SetPrvt("CPREFIXO,CNUM,CPARCELA,CCLIENTE,CLOJA,CNOMCLI")
SetPrvt("DEMISSAO,DVENCTO,CHIST,NPORCJUR,CPEDIDO,CEXT")
SetPrvt("CREC,NLINHAS,X,CEND,lBonus")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SACI008   ³                               ³ Data ³ 11/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Baixa dos titulo na Rava                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/* RETIRADO DO SISTEMA EM 03-09-2014 - GUSTAVO
lBonus := .F.  
nDias := 0
nPrazoEnt := 0 
cQuery := ""

if SM0->M0_CODIGO == "02"
    
	
		////gravação do bônus para títulos de órgãos públicos
		cModal := U_GetModali(SE1->E1_PEDIDO)
		
	   	If  alltrim(cModal) != "XX"
		   SA1->(DBSETORDER(1))
		   SA1->( DbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA ) )
		   	
		   if Alltrim(SA1->A1_SATIV1) = "000009" .AND. SA1->A1_EST != "SP" //Orgaos Publicos e diferentes de SP
		      //nDias := (SE5->E5_DTDISPO - SE1->E1_EMISSAO)   
		      //nDias := (dDatabase - SE1->E1_EMISSAO)
		      nDias := (SE1->E1_BAIXA - SE1->E1_EMISSAO)   //dias vencidos
		      
		      nPrazoEnt := U_fPrazoMin(SA1->A1_EST)  //qtde dias do prazo de entrega
		      
		      //User Function FINC002(cPedido, nDias, nPrzEnt)
		      //RETORNA A % DE BÔNUS
		      nPerc := U_FINC002(SE1->E1_PEDIDO, nDias, nPrazoEnt)      
		      
				
				If nPerc > 0
				  If Alltrim(SE5->E5_RECPAG) = 'R'
		      
			         //SE3->( dbSetOrder( 1 ) )
			         //SE3->( dbSeek( xFilial( "SE3" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA, .T.  ) )
			         ///LOCALIZA SE3
				    cQuery := " select top 1  * from " + RetSqlName("SE3") + " SE3 " 
				    cQuery += " where E3_PREFIXO = '" + Alltrim(SE1->E1_PREFIXO) + "' " 
				    cQuery += " and E3_NUM = '" + Alltrim(SE1->E1_NUM) + "' " 
				    cQuery += " and E3_PARCELA = '" + Alltrim(SE1->E1_PARCELA) + "' "
				    
				    cQuery += " and E3_FILIAL = '" + xFilial("SE3") + "' " 
				    cQuery += " and SE3.D_E_L_E_T_ = '' " 
				    cQuery += " Order BY R_E_C_N_O_ DESC " 
				        
				    MemoWrite("C:\Temp\LOCALSE3.sql", cQuery)
				    If Select("SE33") > 0
						DbSelectArea("SE33")
						DbCloseArea()
					EndIf
					
					TCQUERY cQuery NEW ALIAS "SE33"
					TCSetField( 'SE33', "E3_EMISSAO", "D" )
					TCSetField( 'SE33', "E3_VENCTO", "D" )
					
					SE33->( DBGoTop() )
					
					Do While !SE33->( Eof() )
						//Salvo os valores da comissao já gerada, Perc., e Vlr. Comissão
				         nBase := SE33->E3_BASE
				         cBE   := SE33->E3_BAIEMI 
				         cSeq  := SE33->E3_SEQ
				         cOrig := SE33->E3_ORIGEM  
				         dVenc := SE33->E3_VENCTO
						
						DbselectArea("SE33")
						SE33->(Dbskip())
					Enddo
				    DbselectArea("SE33")
				    DBCLOSEAREA()
			         If Alltrim(SE1->E1_VEND1) != '0220'        //Chamado 001968 - Hilton ->não precisa ter bônus pq é funcionário vendedor
				         
				         //Salvo os valores da comissao já gerada, Perc., e Vlr. Comissão
				         dEmis := SE1->E1_BAIXA
				         //nBase := SE1->E1_BASCOM1
				         //nBase := SE3->E3_BASE  //NOVO
				         //cBE   := SE3->E3_BAIEMI 
				         cPed  := SE1->E1_PEDIDO
				         //cSeq  := SE3->E3_SEQ
				         //cOrig := SE3->E3_ORIGEM  
				         //dVenc := SE3->E3_VENCTO
				           
				         RecLock("SE3", .T.)
				         SE3->E3_FILIAL  := xFilial("SE3")
				         SE3->E3_VEND    := SE1->E1_VEND1
				         SE3->E3_NUM     := SE1->E1_NUM
				         SE3->E3_EMISSAO := dEmis
				         SE3->E3_SERIE   := SE1->E1_PREFIXO
				         SE3->E3_CODCLI  := SE1->E1_CLIENTE
				         SE3->E3_LOJA    := SE1->E1_LOJA
				         SE3->E3_BASE    := nBase
				         SE3->E3_PORC    := nPerc  //Calcular com base na modalidade
				         SE3->E3_COMIS   := (nBase * nPerc)/100  //Calcular com base na modalidade
				         SE3->E3_PREFIXO := SE1->E1_PREFIXO
				         SE3->E3_PARCELA := SE1->E1_PARCELA
				         SE3->E3_TIPO    := SE1->E1_TIPO
				         If !Empty(cBE)
				         	SE3->E3_BAIEMI  := cBE
				         Else
				         	SE3->E3_BAIEMI := "B"
				         Endif
				         SE3->E3_PEDIDO  := cPed
				         SE3->E3_SEQ     := cSeq
				         SE3->E3_ORIGEM  := cOrig
				         SE3->E3_VENCTO  := dVenc
				         SE3->E3_BONUS   := "S"
				         SE3->(MsUnLock() )
				            ///envia e-mail avisando se gravou o bônus
				         	/*
				         	cMailTo := "flavia.rocha@ravaembalagens.com.br"
				         	cCopia  := ""
				         	cCorpo	:= "Rotina: SACI008 - BX MANUAL" + CHR(13) + CHR(10)					
				         	cCorpo	+= "Nesta data: " + Dtoc(SE1->E1_BAIXA) + CHR(13) + CHR(10)					
							cCorpo  += " O bonus foi gerado para o titulo: " + SE1->E1_NUM + CHR(13) + CHR(10)
							cCorpo  += " Prefixo: " + SE1->E1_PREFIXO + CHR(13) + CHR(10)
							cCorpo  += " Parcela: " + SE1->E1_PARCELA + CHR(13) + CHR(10)
							cCorpo  += " Bonus  : " + str(nPerc) + CHR(13) + CHR(10)
							cCorpo  += " Prazo Ent  : " + str(nPrazoEnt) + CHR(13) + CHR(10)
							cCorpo  += " Dias Venc  : " + str(nDias) + CHR(13) + CHR(10)
							cCorpo  += " Modal.     : " + cModal + CHR(13) + CHR(10)
							cAnexo  := "" 
							cAssun  := "BONUS GERADO TITULO/PREFIXO/PARCELA: " + SE1->E1_NUM + "/" + SE1->E1_PREFIXO + "/" + SE1->E1_PARCELA
							U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )					
							*/ /*
			         Endif  //if vendedor != 0220
			         
			      Endif		//if do e5_recpag
			      
				Endif		//if do nPerc > 0
				
		   endif		//if do orgãos públicos e diferente de SP
		   
	    Endif	//if do cModal 
        
    /////FIM DA GRAVAÇÃO DO BÔNUS

   //if SE1->E1_PREFIXO == "UNI"
   if SE1->E1_PREFIXO $ "UNI/0  "
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Baixa titulo - Rava                                          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      If Select( "XE1" ) == 0
         cArq := "SE1010"
         Use (cArq) ALIAS XE1 VIA "TOPCONN" NEW SHARED
				 U_AbreInd( cARQ )
      endif
      XE1->( DbSetOrder( 1 ) )
      if XE1->( dbSeek( xFilial( "SE1" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO ) )
         RecLock( "XE1", .F. )
         XE1->E1_MOVIMEN := SE1->E1_MOVIMEN; XE1->E1_SALDO   := SE1->E1_SALDO
         //
         XE1->E1_PORTADO := SE1->E1_PORTADO; XE1->E1_INSTR1  := SE1->E1_INSTR1
         XE1->E1_AGEDEP  := SE1->E1_AGEDEP ; XE1->E1_CONTA   := SE1->E1_CONTA
         XE1->E1_NUMBCO  := SE1->E1_NUMBCO ; XE1->E1_NUMBOR  := SE1->E1_NUMBOR
         XE1->E1_COMIS1  := SE1->E1_COMIS1 ; XE1->E1_VALJUR  := SE1->E1_VALJUR
         XE1->E1_BASCOM1 := SE1->E1_BASCOM1; XE1->E1_SERIE   := SE1->E1_SERIE
         XE1->E1_SITUACA := SE1->E1_SITUACA
         //
         XE1->E1_BAIXA   := SE1->E1_BAIXA  ; XE1->E1_OCORREN := SE1->E1_OCORREN
         XE1->E1_STATUS  := SE1->E1_STATUS ; XE1->E1_OK      := SE1->E1_OK
         XE1->E1_DESCONT := SE1->E1_DESCONT; XE1->E1_MULTA   := SE1->E1_MULTA
         XE1->E1_JUROS   := SE1->E1_JUROS  ; XE1->E1_VALLIQ  := SE1->E1_VALLIQ
         XE1->E1_CORREC  := SE1->E1_CORREC ; XE1->E1_PORCJUR := SE1->E1_PORCJUR
         XE1->( MsUnlock() )
         XE1->( dbCommit() )
      endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ SE5 - titulo - Rava                                          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      If Select( "XE5" ) == 0
         cArq := "SE5010"
         Use (cArq) ALIAS XE5 VIA "TOPCONN" NEW SHARED
				 U_AbreInd( cARQ )
      endif

      nE5Ord := SE5->( dbSetOrder() )
      nE5Reg := SE5->( Recno() )

      XE5->( dbSetOrder( 2 ) )
      SE5->( dbSetOrder( 7 ) )
      SE5->( dbSeek( xFilial( "SE5" ) + SE1->E1_PREFIXO + SE1->E1_NUM ) )

      while SE5->E5_PREFIXO + SE5->E5_NUMERO == SE1->E1_PREFIXO + SE1->E1_NUM .and. SE5->( !Eof() )
         XE5->( dbSeek( xFilial( "SE5" ) +;
                        SE5->E5_TIPODOC +;
                        SE5->E5_PREFIXO +;
                        SE5->E5_NUMERO +;
                        SE5->E5_PARCELA +;
                        SE5->E5_TIPO +;
                        Dtos( SE5->E5_DATA ) +;
                        SE5->E5_CLIFOR +;
                        SE5->E5_LOJA +;
                        SE5->E5_SEQ ) )

         if XE5->( Eof() )
            RecLock( "XE5", .t. )
            XE5->E5_FILIAL  := xFilial( "SE5" ); XE5->E5_DATA    := SE5->E5_DATA
            XE5->E5_TIPO    := SE5->E5_TIPO    ; XE5->E5_MOEDA   := SE5->E5_MOEDA
            XE5->E5_VALOR   := SE5->E5_VALOR   ; XE5->E5_NATUREZ := SE5->E5_NATUREZ
            XE5->E5_BANCO   := SE5->E5_BANCO   ; XE5->E5_AGENCIA := SE5->E5_AGENCIA
            XE5->E5_CONTA   := SE5->E5_CONTA   ; XE5->E5_NUMCHEQ := SE5->E5_NUMCHEQ
            XE5->E5_DOCUMEN := SE5->E5_DOCUMEN ; XE5->E5_VENCTO  := SE5->E5_VENCTO
            XE5->E5_RECPAG  := SE5->E5_RECPAG  ; XE5->E5_BENEF   := SE5->E5_BENEF
            XE5->E5_HISTOR  := SE5->E5_HISTOR  ; XE5->E5_TIPODOC := SE5->E5_TIPODOC
            XE5->E5_VLMOED2 := SE5->E5_VLMOED2 ; XE5->E5_LA      := SE5->E5_LA
            XE5->E5_SITUACA := SE5->E5_SITUACA ; XE5->E5_LOTE    := SE5->E5_LOTE
            XE5->E5_PREFIXO := SE5->E5_PREFIXO ; XE5->E5_NUMERO  := SE5->E5_NUMERO
            XE5->E5_PARCELA := SE5->E5_PARCELA ; XE5->E5_CLIFOR  := SE5->E5_CLIFOR
            XE5->E5_LOJA    := SE5->E5_LOJA    ; XE5->E5_DTDIGIT := SE5->E5_DTDIGIT
            XE5->E5_TIPOLAN := SE5->E5_TIPOLAN ; XE5->E5_DEBITO  := SE5->E5_DEBITO
            XE5->E5_CREDITO := SE5->E5_CREDITO ; XE5->E5_MOTBX   := SE5->E5_MOTBX
            XE5->E5_RATEIO  := SE5->E5_RATEIO  ; XE5->E5_RECONC  := SE5->E5_RECONC
            XE5->E5_SEQ     := SE5->E5_SEQ     ; XE5->E5_DTDISPO := SE5->E5_DTDISPO
            XE5->E5_CCD     := SE5->E5_CCD     ; XE5->E5_CCC     := SE5->E5_CCC
            XE5->E5_OK      := SE5->E5_OK      ; XE5->E5_ARQRAT  := SE5->E5_ARQRAT
            XE5->E5_IDENTEE := SE5->E5_IDENTEE ; XE5->E5_FLSERV  := SE5->E5_FLSERV
            XE5->( MsUnlock() )
            XE5->( dbCommit() )
         endif
         SE5->( dbSkip() )
      end
      SE5->( dbSetOrder( nE5Ord ) )
      SE5->( dbGoto( nE5Reg ) )
      dbCommitall()

      /*
      ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
      ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
      ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
      ±±³Fun‡„o    ³RECIBO    ³ Autor ³ Silvano Araujo        ³ Data ³ 13/01/00 ³±±
      ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
      ±±³Descri‡„o ³Emissao de recibo especifico para Rava Embalagens Ltda      ³±±
      ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
      ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
      ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
      /*

//      set print to LPT1
//      set device to print
//      initPrint()

      if pROW() == 0
         nLIN := 0
      else
         nLIN := pROW()+1
      endif
      if alltrim(upper(FunName())) == "WFBAIXAS"//Incluído em 13/10/08 para o WFBAIXAS
      	  return
      endif
		//Chamado 001588 - Neide - Solicitou retirar a tela de Emissão de REcibo      
		/*      
      If Select( 'SX2' ) != 0 //Incluído em 12/05/08 para o WFBAIXAS
	      @ 50,20 TO 100,320 DIALOG oDlg2 TITLE "Emissao de Recibo"
	      @ 10,040 BMPBUTTON TYPE 1 ACTION Recib()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>       @ 10,040 BMPBUTTON TYPE 1 ACTION Execute(Recib)
	      @ 10,080 BMPBUTTON TYPE 2 ACTION Close( oDlg2 )
	      ACTIVATE DIALOG oDlg2 CENTER
      endIf
      *//*
      
   endif
endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³          ³ Autor ³ Silvano Araujo        ³ Data ³ 23/02/00 ³±±
±±³Alterado por: Mauricio Barros                        ³ Data ³ 03/11/03 ³±±
±±	            : Acrescentado campo E1_TIPO no SEEK do SE3       				±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Acerto do valor base e comissao - o siga faz errado         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*
/*  Retirado por Mauricio em 12/12/2003
If ( SE1->E1_JUROS #0.00 .and. SE1->E1_SALDO == 0.00 ) .or. ( SE1->E1_DESCONT # 0.00 .and. SE1->E1_SALDO == 0.00 )
   nIpi := Round( SE1->E1_VALOR/SE1->E1_BASCOM1, 2 )
   SE3->( dbSetOrder( 1 ) )
   SE3->( dbSeek( xFilial( "SE3" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO, .T. ) )

   While SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO == SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO .AND. SE3->( !Eof() )
      SE3->( dbSkip() )
   End
   SE3->( dbSkip( -1 ) )

   If SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO == SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
      RecLock( "SE3",.f. )
      SE3->E3_BASE  := Round( ( SE1->E1_VALLIQ - SE1->E1_JUROS - SE1->E1_DESCONT ) / nIpi,2 )
      SE3->E3_COMIS := Round( SE3->E3_BASE * SE1->E1_COMIS1/100, 2 )
      SE3->( MsUnlock() )
      SE3->( dbCommit() )
   Endif

Endif
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³          ³ Autor ³ Silvano Araujo        ³ Data ³ 23/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao de ocorrencia de encargos                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis utilizadas para parametros                              ³
³ mv_par01        	// Tipo                                         ³
³ mv_par02        	// Naturez                                      ³
³ mv_par03        	// Valor                                        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

/*
if SE1->E1_BAIXA > SE1->E1_VENCREA

   nReg := SE1->( Recno() )

   While .t.

      //Pergunte( "ENCARG", .t. ) 
      //Tela parâmetros quando o título é baixado com atraso, RETIRADO POR SOLICITAÇÃO DO CHAMADO 001588 - Neide
      
      SE1->( dbGoto( nReg ) )
      
      if mv_par01 == Space(03)
         exit
      endif

      cPrefixo := SE1->E1_PREFIXO; cNum    := SE1->E1_NUM   ; cParcela := SE1->E1_PARCELA
      cCliente := SE1->E1_CLIENTE; cLoja   := SE1->E1_LOJA  ; cNomcli  := SE1->E1_NOMCLI
      dEmissao := SE1->E1_EMISSAO; dVencto := SE1->E1_VENCTO; cHist    := SE1->E1_HIST
      nPorcJur := SE1->E1_PORCJUR; cPedido := SE1->E1_PEDIDO

      RecLock( "SE1", .T. )
      SE1->E1_FILIAL  := xFilial("SE1") ;  SE1->E1_PREFIXO := cPrefixo
      SE1->E1_NUM     := cNum       ;      SE1->E1_PARCELA := cParcela
      SE1->E1_TIPO    := mv_par01;         SE1->E1_NATUREZ := mv_par02
      SE1->E1_CLIENTE := cCliente       ;  SE1->E1_LOJA    := cLoja
      SE1->E1_NOMCLI  := cNomcli     ;     SE1->E1_EMISSAO := dEmissao
      SE1->E1_VENCTO  := dVencto        ;  SE1->E1_VENCREA := DataValida( dVencto )
      SE1->E1_VALOR   := mv_par03       ;  SE1->E1_SALDO   := mv_par03
      SE1->E1_HIST    := cHist
      SE1->E1_EMIS1   := dEmissao     ;    SE1->E1_MOEDA   := 1
      SE1->E1_VLCRUZ  := mv_par03       ;  SE1->E1_ORIGEM  := "FINA040"
      SE1->E1_PEDIDO  := cPedido        ;  SE1->E1_SITUACA := "0"
      SE1->( MsUnlock() )
      SE1->( dbCommit() )

   End

Endif

*/

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Recib     ³ Autor ³ Silvano Araujo        ³ Data ³ 23/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Emissao do Recibo                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Recib
Static Function Recib()

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de parametrizacao da impressao.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "DECOM", 2, 2, 1, "", 1 }
cARQUIVO := "SE5"
aORD     := {}
cNOMREL  := "RECIBO"
cTITULO  := "Recibo"
nLASTKEY := 0

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Inicio do processamento                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cNOMREL := setprint( cARQUIVO, cNOMREL, "RECIBO", @cTITULO, cDESC1, cDESC2, ;
cDESC3, .f., aORD, .f., "P" )

If nLastKey == 27
   Return
Endif

Setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 20/05/01 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 20/05/01 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF


cExt := Alltrim( Extenso( nValrec, .f., 1 ) )
@ pRow(),   000 pSay ". "
@ pRow(),   010 pSay "RAVA EMBALAGENS Industria e Comercio LTDA"
@ Prow()+2, 020 pSay "R E C I B O "
@ Prow(),   050 pSay "R$ "+Transform( nValrec, "999,999,999.99" )
@ Prow()+1, 020 pSay "- - - - - - "

nLin := Prow()+6
cRec := ""
SA1->( dbSeek( xFilial( "SA1" ) + SE1->E1_CLIENTE+SE1->E1_LOJA, .t. ) )

cRec := "Recebemos do(a) Sr(a) "+Alltrim( SA1->A1_NOME)+" a quantia supra de R$ "+Transform( nValrec, "@E 999,999,999.99" ) + " ( "+ cExt
cRec := cRec + " ), referente ao pagamento da duplicata N.: "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+" "+SE1->E1_PARCELA+", pelo o que passo o presente"
cRec := cRec + " recibo dando plena e total quitacao."

nLinhas := Mlcount( cRec, 56 )
for x := 1 to nLinhas
    @ nLin,010 Psay Memoline( cRec, 56, x )
    nLin := nLin + 1
next

nLin := nLin + 4
@ nLin, 010 pSay "Cabedelo, "+ StrZero( Day( SE1->E1_BAIXA ), 2 )+" de "+Mesextenso( Month( SE1->E1_BAIXA ) )+" de "+Str( Year( SE1->E1_BAIXA ) )
nLin := nLin + 3

cEnd :=        Alltrim( SM0->M0_ENDCOB ) +" "+Alltrim( SM0->M0_BAIRCOB )+" "+Alltrim( SM0->M0_CEPCOB )+" "+Alltrim( SM0->M0_CIDCOB )+" "+Alltrim( SM0->M0_ESTCOB )
cEnd := cEnd + "C.G.C. "+Alltrim( SM0->M0_CGC ) +" Insc. Estadual "+Alltrim( SM0->M0_INSC ) +" Fone "+Alltrim( SM0->M0_TEL )

@ nLin,  010 pSay Replicate( "-", 56 )
nLIn := nLin + 1

nLinhas := Mlcount( cEnd, 56 )
for x := 1 to nLinhas
    @ nLin,010 Psay Memoline( cEnd, 56, x )
    nLin := nLin + 1
next

@ nLin+1,010 pSay Replicate( "-", 56 )
close( oDlg2 )

//Roda( 0,"","M" )

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool( cNomRel ) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

                            