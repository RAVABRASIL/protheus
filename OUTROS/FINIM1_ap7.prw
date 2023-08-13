#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FINIM1()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NCONTRATO,CCONTRATO,CCGC,NPREFIXO,DDATENT,DVEN1PAR")
SetPrvt("NTXJUROS,NIND,NMULTATZ,NVALCONTR,NORIGVALCONTR,NQTDPAR")
SetPrvt("NVALOR,NVALORIG,NSALDO,COCORREN,CSTATUS,CCONTA")
SetPrvt("CDATA,NVAL,NDIAS,NJUR,CBAN,CNAT")
SetPrvt("CHIS,CPREFIXO,CHIST,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FIN001    ³ Autor ³ Silvano Araujo        ³ Data ³11/04/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Importacao de cad.clientes,contas a receber com movimentacao³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Captura e Gravacao com o Volare"
@ 10,030 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,030 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,080 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
Close(oDlg1)
Processa( {|| Import() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(Import) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Import
Static Function Import()

dbUseArea( .T., "dbfcdxax", "ASMIVM.ABD", "IND", if(.F. .OR. .T., !.T., NIL), .F. )
dbCreateIndex( "ASMIVM", "SIGMOE+Dtos( DTAREF )", {|| SIGMOE+Dtos( DTAREF )}, if( .F., .T., NIL ) )
dbUseArea( .T., "dbfcdxax", "CRCDTIT1", "TIT", if(.F. .OR. .T., !.T., NIL), .F. )
dbCreateIndex( "CRCDTTIT1", "CT_CODFOR", {|| CT_CODFOR}, if( .F., .T., NIL ) )
dbUseArea( .T., "dbfcdxax", "CRCADPAR", "PAR", if(.F. .OR. .T., !.T., NIL), .F. )
dbCreateIndex( "CRCADPAR", "CR_ARGPSQ", {|| CR_ARGPSQ}, if( .F., .T., NIL ) )
dbUseArea( .T., "dbfcdxax", "CRCADFO1", "CLI", if(.F. .OR. .T., !.T., NIL), .F. )

SEZ->( dbGoBottom() )
nContrato := Val( Substr( SEZ->EZ_NUM, 2, 5 ) )
ProcRegua( lastrec() )
while CLI->( !Eof() )

   nContrato := nContrato + 1
   cContrato := "I"+Strzero( nContrato, 5 )
   if Len( Alltrim( CLI->CF_CGCCLI ) ) == 14
      cCgc := Substr( CLI->CF_CGCCLI, 1, 3 ) + Substr( CLI->CF_CGCCLI, 5, 3 ) + Substr( CLI->CF_CGCCLI, 9, 3 ) + Substr( CLI->CF_CGCCLI, 13, 2 )
   else
      cCgc := Substr( CLI->CF_CGCCLI, 1, 2 ) + Substr( CLI->CF_CGCCLI, 4, 3 ) + Substr( CLI->CF_CGCCLI, 8, 3 ) + Substr( CLI->CF_CGCCLI, 12, 4 ) + Substr( CLI->CF_CGCCLI, 17, 2 )
   endif

   RecLock( "SA1", .T. )
   SA1->A1_FILIAL := xFilial( "SA1" ); SA1->A1_COD := "10"+StrZero( Val( Substr( CLI->CF_REFFOR, 1, 4 ) ), 4 )
   SA1->A1_LOJA   := "01"            ; SA1->A1_NOME   := CLI->CF_NOMFOR; SA1->A1_NREDUZ := CLI->CF_NOMFOR
   SA1->A1_TIPO   := "F"             ; SA1->A1_END    := CLI->CF_ENDFOR; SA1->A1_MUN    := CLI->CF_CIDFOR
   SA1->A1_EST    := CLI->CF_ESTFOR  ; SA1->A1_BAIRRO := CLI->CF_BAIFOR; SA1->A1_CEP    := CLI->CF_CEPFOR
   SA1->A1_TEL    := CLI->CF_FONFOR  ; SA1->A1_TELEX  := CLI->CF_TLXFOR; SA1->A1_ENDCOB := CLI->CF_ENDFOR
   SA1->A1_ENDENT := CLI->CF_ENDFOR  ; SA1->A1_ENDREC := CLI->CF_ENDFOR; SA1->A1_CGC    := cCgc
   SA1->A1_MULTA  := TIT->CT_MULATZ
   SA1->( MsUnlock() )

   nPrefixo  := 1
   TIT->( dbSeek( CLI->CF_REFFOR ) )
   dDatEnt   := TIT->CT_DTAENT
   dVen1Par  := TIT->CT_DTAVEN
   nTxJuros  := TIT->CT_TAXJUR
   nInd      := Iif( TIT->CT_CODMOE=="    ", 4, 3 )
   nMultAtz  := TIT->CT_MULATZ
   nValContr := nOrigValContr := nQtdPar := 0

   While TIT->CT_CODFOR == CLI->CF_REFFOR .and. TIT->( !Eof() )

      if TIT->CT_DTABAI #Ctod( "  /  /  " )  // SE BAIXADO
         nValor   := TIT->CT_VLRPAG
         nValorig := TIT->CT_VLRPAG
         nSaldo   := 0
         cOcorren := "01"
         cStatus  := "B"
         cConta   := " "
      else

         If TIT->CT_BANPOR == "8749"
            cConta := "0003282-1"
         Elseif TIT->CT_BANPOR == "0749"
            cConta := "006079-5"
         Elseif TIT->CT_BANPOR == "9999" .and. TIT->CT_AGEPOR == "0001"
            cConta := "99999999991"
         Elseif TIT->CT_BANPOR == "9999" .and. TIT->CT_AGEPOR == "0002"
            cConta := "99999999992"
         Else
            cConta := " "
         Endif

         if TIT->CT_TIPTIT $ "PS PR PV PU RT"
            nValorig := nValor   := nSaldo := TIT->CT_SLDTIT / 100
         else
            cData := Dtos( Ctod( "01/" + Strzero( Month( TIT->CT_DTAEMI ), 2 )+ "/"+Substr( Dtoc( TIT->CT_DTAEMI ), 7, 2 ) ) )
            IND->( dbSeek( TIT->CT_CODMOE+cData ) )

            nValorig := Iif( TIT->CT_VLRORI==0,TIT->CT_SLDTIT, TIT->CT_VLRORI ) / 100
            nVal     := Iif( TIT->CT_VLRORI==0,TIT->CT_SLDTIT, TIT->CT_VLRORI ) / IND->VLRDTA

            cData := Dtos( Ctod( "01/" + Strzero( Month( dDatabase ), 2 )+ "/"+Substr( Dtoc( dDatabase ), 7, 2 ) ) )
            IND->( dbSeek( TIT->CT_CODMOE+cData) )

            nValor := nVal * IND->VLRDTA / 100
            nDias  := Ctod( StrZero( Iif( Day( TIT->CT_DTAVEN)==31,30,Day( TIT->CT_DTAVEN ) ), 2 )+"/"+StrZero( Month( dDatabase ), 2 )+"/"+StrZero( Year( dDatabase ), 4 ) )  - TIT->CT_DTAEMI
            nJur   := Round( TIT->CT_TAXJUR/30 * nDias, 6 )
            nValor := nValor + Round( nValor * nJur / 100, 4 )
            nSaldo := nValor
         endif
         cOcorren  := "  "
         cStatus   := "A"
      endif

      if Substr( TIT->CT_TIPTIT, 1, 1 ) $ "1234567890"
         PAR->( dbSeek( TIT->CT_TIPTIT ) )
         cBan := PAR->CR_CRPPAR
         cNat := "RPA"
      else
         cNat := "R"+TIT->CT_TIPTIT
         cBan := " "
      endif

      if TIT->CT_HSTBAI == "71"
         cConta := "006079-5"
      elseif TIT->CT_HSTBAI == "81"
         cConta := "0003282-1"
      endif

      PAR->( dbSeek( TIT->CT_HSTENT ) )
      cHis := PAR->CR_CRPPAR

      cPrefixo := StrZero( nPrefixo, 3 )
      RecLock( "SE1", .t. )
      SE1->E1_FILIAL  := xFilial( "SE1" ); SE1->E1_PREFIXO := cPrefixo      ; SE1->E1_NUM     := cContrato
      SE1->E1_PARCELA := "0"             ; SE1->E1_TIPO    := "NP"          ; SE1->E1_NATUREZ := cNat
      SE1->E1_CLIENTE := SA1->A1_COD     ; SE1->E1_LOJA    := "01"          ; SE1->E1_NOMCLI  := SA1->A1_NREDUZ
      SE1->E1_EMISSAO := TIT->CT_DTAEMI  ; SE1->E1_VENCTO  := TIT->CT_DTAVEN; SE1->E1_VENCREA := DataValida( TIT->CT_DTAVEN )
      SE1->E1_VALOR   := nValor          ; SE1->E1_VALORIG := nValorig      ; SE1->E1_CC      := Substr( TIT->CT_CENCUS, 4, 3 )
      SE1->E1_BAIXA   := TIT->CT_DTABAI  ; SE1->E1_EMIS1   := TIT->CT_DTAEMI; SE1->E1_MOVIMEN := TIT->CT_DTABAI
      SE1->E1_SITUACA := "0"             ; SE1->E1_SALDO   := nSaldo        ; SE1->E1_VALLIQ  := nValor
      SE1->E1_VENCORI := TIT->CT_DTAVEN  ; SE1->E1_MOEDA   := 1             ; SE1->E1_OK      := "f3"
      SE1->E1_OCORREN := cOcorren        ; SE1->E1_VLCRUZ  := nValor        ; SE1->E1_STATUS  := cStatus
      SE1->E1_ORIGEM  := "IMPORT"        ; SE1->E1_FLUXO   := "S"           ; SE1->E1_SEUNUM  := TIT->CT_SEUNUM
      SE1->E1_REFTIT  := TIT->CT_REFTIT  ; SE1->E1_HISTBAN := cBan          ; SE1->E1_HIST    := cHis
      SE1->E1_AGEDEP  := TIT->CT_AGEPOR  ; SE1->E1_CONTA   := cConta        ; SE1->E1_NUMBCO  := TIT->CT_NSSNUM
      SE1->E1_PORCJUR := Round( TIT->CT_JURATZ/30, 2 )
      SE1->E1_PORTADO := Substr(TIT->CT_BANPOR, 2, 3 )
      SE1->( MsUnlock() )
      SE1->( dbCommit() )

      if TIT->CT_DTABAI #Ctod( "  /  /  " )  // SE BAIXADO

         PAR->( dbSeek( TIT->CT_HSTBAI ) )
         cHist := PAR->CR_CRPPAR

         RecLock( "SE5", .t. )
         SE5->E5_FILIAL  := xFilial( "SE5" ); SE5->E5_DATA    := SE1->E1_BAIXA
         SE5->E5_TIPO    := "NP"            ; SE5->E5_VALOR   := SE1->E1_VALOR
         SE5->E5_NATUREZ := SE1->E1_NATUREZ ; SE5->E5_BANCO   := "CXX"
         SE5->E5_AGENCIA := "00000"         ; SE5->E5_CONTA   := "0000000000"
         SE5->E5_RECPAG  := "R"             ; SE5->E5_BENEF   := "PERNAMBUCAO CONSTRUTORA"
         SE5->E5_HISTOR  := cHist
         SE5->E5_TIPODOC := "VL"            ; SE5->E5_VLMOED2 := SE1->E1_VALOR
         SE5->E5_PREFIXO := cPrefixo        ; SE5->E5_NUMERO  := cContrato
         SE5->E5_PARCELA := "0"             ; SE5->E5_CLIFOR  := SE1->E1_CLIENTE
         SE5->E5_LOJA    := SE1->E1_LOJA    ; SE5->E5_DTDIGIT := SE1->E1_BAIXA
         SE5->E5_MOTBX   := "NOR"           ; SE5->E5_SEQ     := "01"
         SE5->E5_DTDISPO := SE1->E1_BAIXA   ; SE5->E5_CCC     := SE1->E1_CC
         SE5->( MsUnlock() )
         SE5->( dbCommit() )
      endif

      nValContr     := nValContr     + SE1->E1_VALOR
      nOrigValContr := nOrigValContr + SE1->E1_VALORIG
      nQtdPar       := nQtdPar       + 1
      nPrefixo      := nPrefixo      + 1
      nMultAtz      := TIT->CT_MULATZ
      nTxJuros      := TIT->CT_TAXJUR
      nInd          := Iif( TIT->CT_CODMOE=="    ", 4, 3 )
      TIT->( dbSkip() )

   end

   RecLock( "SA1", .F. )
   SA1->A1_MULTA  := nMultAtz
   SA1->( MsUnlock() )

   RecLock( "SEZ", .t. )
   SEZ->EZ_FILIAL  := xFilial( "SEZ" ); SEZ->EZ_NUM     := cContrato
   SEZ->EZ_TIPO    := "01"            ; SEZ->EZ_CLIENTE := SE1->E1_CLIENTE
   SEZ->EZ_LOJA    := SE1->E1_LOJA    ; SEZ->EZ_OK      := "ok"
   SEZ->EZ_DATA    := SE1->E1_EMISSAO ; SEZ->EZ_VALOR   := nValContr
   SEZ->EZ_PCORANT := nTxJuros        ; SEZ->EZ_PCORPOS := nTxJuros
   SEZ->EZ_MOEDA   := nInd            ; SEZ->EZ_PERCC   := 100
   SEZ->EZ_CMINTAN := nTxJuros        ; SEZ->EZ_CMINTDP := nTxjuros
   SEZ->EZ_VEN1PAR := dVen1Par        ; SEZ->EZ_NUMPAR1 := nQtdPar
   SEZ->EZ_INTJUNT := "S"             ; SEZ->EZ_DATENT  := dDatEnt
   SEZ->EZ_PRODUTO := "IMPORT"

   CLI->( dbSkip() )
   IncProc()

end

TIT->( dbCloseArea() )
CLI->( dbCloseArea() )
IND->( dbCloseArea() )
Close( oDlg1 )
Return

