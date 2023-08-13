#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"

User Function F200TIT()     // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
Local cCopia  := ""					
Local cCorpo  := ""
Local cAnexo  := ""
Local cAssun  := "" 
Local cMailTo := ""
Local lBonus  := .F.
Local nPerc   := 0
Local nDias	   := 0
Local nPrazoEnt:= 0 
Local cQuery := ""
Local nBase  := 0
Local cBE	 := "" 
Local cSeq   := ""
Local cOrig  := ""
Local dVenc  := Ctod("  /  /    ")

SetPrvt("CARQ,NE5ORD,NE5REG,NIPI,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �F200TIT   �                               � Data � 24/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Baixa dos titulo na Rava - CNAB                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
lBonus := .F. 
nDias := 0
nPrazoEnt := 0

if SM0->M0_CODIGO == "02"

   //inicio - 02/08/10 - Eurivan
   //Bonus na comissao para recebimento de orgaos publicos  
    /*
	SE3->(DBSETORDER(1))
	SE3->(Dbseek(xFilial("SE3") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA  ))
	While SE3->(!EOF()) .AND. Alltrim(SE3->E3_PREFIXO) == Alltrim(SE1->E1_PREFIXO) .AND. Alltrim(SE3->E3_NUM) == Alltrim(SE1->E1_NUM) ;
	 .AND. Alltrim(SE3->E3_PARCELA) == Alltrim(SE1->E1_PARCELA) 
	 
		If Alltrim(SE3->E3_BONUS) = "S"
			lBonus := .T.		//VERIFICA SE J� EXISTE B�NUS PARA O T�TULO EM QUEST�O
		Endif
		SE3->(DBSKIP())
	Enddo
	*/
   If Alltrim(SE5->E5_RECPAG) = 'R'
	   cModal := U_GetModali(SE1->E1_PEDIDO)
	   If  alltrim(cModal) != "XX"
	   
	   		
   			SA1->(DbSetOrder(1))
			SA1->( DbSeek( xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA ) )
		   if Alltrim(SA1->A1_SATIV1) = "000009" .AND. SA1->A1_EST != "SP" //Orgaos Publicos e diferentes de SP
		      
		      nDias := (SE5->E5_DTDISPO - SE1->E1_EMISSAO)   		           
		      nPrazoEnt := U_fPrazoMin(SA1->A1_EST)
		      
		      //User Function FINC002(cPedido, nDias, nPrzEnt)
		      //RETORNA A % DE B�NUS
		      nPerc := U_FINC002(SE1->E1_PEDIDO, nDias, nPrazoEnt)
		      			
				If nPerc > 0
		      
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
						//Salvo os valores da comissao j� gerada, Perc., e Vlr. Comiss�o
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
			         If Alltrim(SE1->E1_VEND1) != '0220'        //Chamado 001968 - Hilton ->n�o precisa ter b�nus pq � funcion�rio vendedor
				         //Salvo os valores da comissao j� gerada, Perc., e Vlr. Comiss�o
				         dEmis := SE5->E5_DTDISPO
				         If nBase <= 0
				         	nBase := SE1->E1_BASCOM1
				         Endif
				         
				         If Empty(cBE)
				         	cBE   := SE3->E3_BAIEMI 
				         Endif
				         
				         cPed  := SE1->E1_PEDIDO
				         
				         If Empty(cSeq)
				         	cSeq  := SE3->E3_SEQ
				         Endif
				         
				         If Empty(cOrig)
				         	cOrig := SE3->E3_ORIGEM  
				         Endif
				         
				         If Empty(dVenc)
				         	dVenc := SE3->E3_VENCTO 			         
				         Endif
				         				           
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
				            
				            ///envia e-mail avisando se gravou o b�nus
				            /*
				         	cMailTo := "flavia.rocha@ravaembalagens.com.br"
				         	cCopia  := ""
				         	cCorpo	:= " PE: F200TIT" + CHR(13) + CHR(10)
				         	cCorpo  += " Nesta data: " + Dtoc(SE5->E5_DTDISPO) + CHR(13) + CHR(10)					
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
							*/
			         Endif  
				Endif
		   endif		//if do org�os p�blicos e diferente de SP
	   endif	//if do cModal
   Endif		//if do E5_RECPAG = R
   //Fim - 02/08/10 - Eurivan




   //if SE1->E1_PREFIXO == "UNI"
   if SE1->E1_PREFIXO $ "UNI/0  "
      //��������������������������������������������������������������Ŀ
      //� Baixa titulo - Rava                                          �
      //����������������������������������������������������������������

      if Select( "XE1" ) == 0
         SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
         cArq := "SE1010"
         Use (cArq) ALIAS XE1 VIA "TOPCONN" NEW SHARED
				 U_AbreInd( cARQ )
      endif

      XE1->( dbSetOrder( 16 ) )
      XE1->( dbSeek( xFilial( "SE1" ) + SE1->E1_IDCNAB ) )
      If ! XE1->( Eof() )
         RecLock( "XE1", .f. )

         XE1->E1_MOVIMEN := SE1->E1_MOVIMEN; XE1->E1_SALDO   := SE1->E1_SALDO
         XE1->E1_BAIXA   := SE1->E1_BAIXA  ; XE1->E1_OCORREN := SE1->E1_OCORREN
         XE1->E1_STATUS  := SE1->E1_STATUS ; XE1->E1_OK      := SE1->E1_OK
         XE1->E1_DESCONT := SE1->E1_DESCONT; XE1->E1_MULTA   := SE1->E1_MULTA
         XE1->E1_JUROS   := SE1->E1_JUROS  ; XE1->E1_VALLIQ  := SE1->E1_VALLIQ
         XE1->E1_CORREC  := SE1->E1_CORREC
         XE1->( MsUnlock() )
         XE1->( dbCommit() )
//      else
//         MsgBox( SE1->E1_IDCNAB, "ERRO", "STOP" )
      endif
      //��������������������������������������������������������������Ŀ
      //� SE5 - titulo - Rava                                          �
      //����������������������������������������������������������������

      if Select( "XE5" ) == 0
         cArq := "SE5010"
         Use (cArq) ALIAS XE5 VIA "TOPCONN" NEW SHARED
				 U_AbreInd( cARQ )
      endif

      nE5Ord := SE5->( dbSetOrder() )
      nE5Reg := SE5->( Recno() )

      XE5->( dbSetOrder( 2 ) )
      SE5->( dbSetOrder( 7 ) )
      SE5->( dbSeek( xFilial( "SE5" ) + SE1->E1_PREFIXO + SE1->E1_NUM ) )
         
      while SE5->( !Eof() ) .and. SE5->E5_PREFIXO + SE5->E5_NUMERO == SE1->E1_PREFIXO + SE1->E1_NUM

         //Inclui em 16/12/09 - Gravar Segmento na baixa do titulo
         
         SA1->( DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA) )
         Reclock("SE5",.F.)        
         SE5->E5_SATIV1 := SA1->A1_SATIV1
         SE5->(MsUnLock())
         //at� aqui
         
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
            RecLock( "XE5", .T. )
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
      SE5->( dbSetOrder( 1 ) )
//      SE5->( dbSetOrder( nE5Ord ) )
   endif		//if do prefixo uni/0
endif		//if do M0_codigo = '02'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �          � Autor � Silvano Araujo        � Data � 23/02/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Acerto do valor base e comissao - o siga faz errado         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
If ( SE1->E1_JUROS #0.00 .and. SE1->E1_SALDO == 0.00 ) .or. ( SE1->E1_DESCONT # 0.00 .and. SE1->E1_SALDO == 0.00 )

   nIpi := Round( SE1->E1_VALOR/SE1->E1_BASCOM1, 2 )
   SE3->( dbSetOrder( 1 ) )
   SE3->( dbSeek( xFilial( "SE3" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO, .T. ) )

   While SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO == SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO .AND. SE3->( !Eof() )
      SE3->( dbSkip() )
   End

   SE3->( dbSkip( -1 ) )

   If SE3->E3_PREFIXO + SE3->E3_NUM + SE3->E3_PARCELA + SE3->E3_TIPO == SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO
      RecLock( "SE3",.f. )
      SE3->E3_BASE  := Round( ( SE1->E1_VALLIQ - SE1->E1_JUROS ) / nIpi, 2 )
      SE3->E3_COMIS := Round( SE3->E3_BASE * SE1->E1_COMIS1/100, 2 )
      SE3->( MsUnlock() )
      SE3->( dbCommit() )
   Endif

Endif
*/

SAVE ALL TO F200TIT

Return
