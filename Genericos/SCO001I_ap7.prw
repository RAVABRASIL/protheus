#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function SCO001I()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LFLAG,CBISEXTO,CARQUIVO,NTOTAL,CLOTESCO,CNATAIDF")
SetPrvt("NHDLPRV,APARCELAS,X,CPARCELA,NPARCISS,NPARCINSS")
SetPrvt("NPARCIRRF,NVALISS,NVALINSS,NVALIRRF,DVENCTO,CNATIRF")
SetPrvt("DVENCTO1,CFORNECE,NPARCELA,Y,CNATISS,CNATINSS")
SetPrvt("NVALOR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SCO001I   ³ Autor ³ Silvano Araujo        ³ Data ³ 14/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao do contas a pagar em funcao do SCO                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
lFlag := .t.
cBisexto := "2000 2004 2008 2012 2016 2020 2024 2028 2032 2036 2040 2044 2048 2052"
cArquivo := ""; nTotal := 0

SX5->( dbSeek( xFilial( "SX5" ) + "09SCO", .t. ) )
cLoteSCO := Alltrim( SX5->X5_DESCRI )

if !Empty( m->z2_cond ) .and. !Empty( m->z2_parcela )
   MsgBox( "Utilizar campo condicao nao utilizar parcela","info","stop")
   lflag := .f.
endif

cNatAidf := GetMv( "MV_NATAIDF" )
if Alltrim( m->z2_naturez ) $ cNatAidf .and. ( M->Z2_DTDIGIT - M->Z2_DTAIDF ) > 1095 .and. M->Z2_DTAIDF > Ctod("30/09/1992")
   MsgBox( "Data AIDF invalida","INFO","STOP" )
   lFlag := .f.
endif

SE2->( dbSetOrder( 1 ) )
SE2->( dbSeek( xFilial( "SE2" ) + m->z2_serie + m->z2_doc + iif(!Empty(m->z2_cond),"1",m->z2_parcela)+m->z2_tipo + m->z2_fornece + m->z2_loja ) )
// MSGBOX( " PESQ "+ m->z2_serie + m->z2_doc + iif(!Empty(m->z2_cond),"1",m->z2_parcela)+m->z2_tipo + m->z2_fornece + m->z2_loja+" SE2 "+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,"INFO","STOP")
if SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA ==;
   m->z2_serie+m->z2_doc+iif(!Empty(m->z2_cond),"1",m->z2_parcela)+m->z2_tipo+m->z2_fornece+m->z2_loja
   MsgBox( "Ocorrencia ja cadastrada","info","stop")
   lflag := .f.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcoes para lancamento padrao                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdlPrv := HeadProva( cLoteSCO, "SCO001I",Substr( cUsuario,7,6 ), @cArquivo )

if altera .and. lFlag

   SE2->( dbSeek( xFilial( "SE2" ) + M->Z2_SERIE + M->Z2_DOC, .T. ) )
   lFlag := .t.
   While SE2->E2_PREFIXO + SE2->E2_NUM == SZ2->Z2_SERIE + SZ2->Z2_NUM
      if !Empty( SE2->E2_BAIXA ) .and. SE2->E2_NUMSCO == SZ2->Z2_COD
         MsgBox( "Titulo ja baixado","info","stop")
         lFlag := .f.
      endif
      SE2->( dbSkip() )
   End

   if lFlag

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Exclusao parcelas de iss - alteracao                         ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      if SZ2->Z2_ISS #0
         SE2->( dbSeek( xFilial( "SE2" ) + SZ2->Z2_SERIE + SZ2->Z2_DOC + iif(!empty(SZ2->Z2_COND),"1",SZ2->Z2_PARCELA)+"ISS", .T. ) )
         While SE2->E2_PREFIXO + SE2->E2_NUM == SZ2->Z2_SERIE + SZ2->Z2_DOC .and. SE2->( !Eof() )
            if SE2->E2_TIPO == "ISS" .and. Empty( SE2->E2_BAIXA ) .and. SE2->E2_NUMSCO == SZ2->Z2_COD
               RecLock( "SE2", .f. )
               SE2->( dbDelete() )
               SE2->( MsUnlock() )
            endif
            SE2->( dbSkip() )
         End
      endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Exclusao parcelas de inss - alteracao                        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      if SZ2->Z2_INSS #0
         SE2->( dbSeek( xFilial( "SE2" ) + SZ2->Z2_SERIE + SZ2->Z2_DOC + iif(!empty(SZ2->Z2_COND),"1",SZ2->Z2_PARCELA)+"INS", .T. ) )
         While SE2->E2_PREFIXO + SE2->E2_NUM == SZ2->Z2_SERIE + SZ2->Z2_DOC .and. SE2->( !Eof() )
            if SE2->E2_TIPO == "INS" .and. Empty( SE2->E2_BAIXA ) .and. SE2->E2_NUMSCO == SZ2->Z2_COD
               RecLock( "SE2", .f. )
               SE2->( dbDelete() )
               SE2->( MsUnlock() )
            endif
            SE2->( dbSkip() )
         End
      endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Exclusao parcelas de irrf - alteracao                        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      if SZ2->Z2_IRRF #0
         SE2->( dbSeek( xFilial( "SE2" ) + SZ2->Z2_SERIE + SZ2->Z2_DOC +iif(!empty(SZ2->Z2_COND),"1",SZ2->Z2_PARCELA)+ "TX ", .T. ) )
         While SE2->E2_PREFIXO + SE2->E2_NUM == SZ2->Z2_SERIE + SZ2->Z2_DOC .and. SE2->( !Eof() )
            if SE2->E2_TIPO == "TX " .and. Empty( SE2->E2_BAIXA ) .and. SE2->E2_NUMSCO == SZ2->Z2_COD
               RecLock( "SE2", .f. )
               SE2->( dbDelete() )
               SE2->( MsUnlock() )
            endif
            SE2->( dbSkip() )
         End
      endif

      SE2->( dbSeek( xFilial( "SE2" ) + SZ2->Z2_SERIE + SZ2->Z2_DOC, .T. ) )
      While SE2->E2_PREFIXO + SE2->E2_NUM == SZ2->Z2_SERIE + SZ2->Z2_DOC
         if SE2->E2_NUMSCO == SZ2->Z2_COD
            SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ, .t. ) )
            SA2->( dbSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, .T. ) )
            nTotal := nTotal + DetProva( nHdlPrv, "515", "SCO001I", cLoteSCO )
            RecLock( "SE2", .f. )
            SE2->( dbDelete() )
            SE2->( MsUnlock() )
         endif
         SE2->( dbSkip() )
      End
   endif
endif

if lFlag

   if Empty( m->Z2_COND )
      aParcelas := {}
      Aadd( aParcelas, { m->Z2_VENCTO, m->Z2_VALOR } )
   else
      aParcelas := Condicao( m->Z2_VALOR, m->Z2_COND )
   endif

   SI3->( dbSeek( xFilial( "SI3" ) + m->Z2_CC, .T. ) )
   For x:= 1 to Len( aParcelas )

       if Len( aParcelas ) == 1
          cParcela := m->Z2_PARCELA
       else
          cParcela := StrZero( x, 1 )
       endif

       nParcIss := nParcInss := nParcIrrf := " "
       nValIss  := nValInss  := nValIrrf  := 0
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Geracao de titulo de irrf                                    ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

       if m->Z2_IRRF #0
          nParcIrrf := "1"
          nValIrrf := Round( m->Z2_IRRF / Len( aParcelas ), 2 )
          dVencto := DataValida( aParcelas[ x, 1 ] )
          dVencto := DataValida( dVencto + ( 7 - Dow( dVencto ) ) + 2 ) + 2

          cNatIrf := Alltrim( GetMv("MV_IRF") )
          cNatirf := If(Substr(cNatIrf,1,1)=='"',Substr(cNatIrf,2,Len(cNatIrf)-2),cNatIrf )
          dVencto1 := Ctod( "04/"+StrZero(Month(dVencto),2 )+"/"+StrZero( Year( dVencto ), 4 ) )
          cFornece := GetMv("MV_UNIAO")

          SE2->( dbSeek( xFilial( "SE2" ) + M->Z2_SERIE + M->Z2_DOC + M->Z2_PARCELA + "TX" + cFornece, .t. ) )
          nParcela := Asc( SE2->E2_PARCELA )

          For Y := nParcela to 254
              cParcela := Chr( Y + 1 )
              SE2->( dbSeek( xFilial( "SE2" ) + M->Z2_SERIE + M->Z2_DOC + cParcela + M->Z2_TIPO + cFornece, .t. ) )
              if !( SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE == ;
                 M->Z2_DOC          + M->Z2_DOC   + cParcela        + "TX"         + cFornece )
                 cParcela := Chr( Y + 1 )
                 exit
              endif
          Next

          RecLock( "SE2", .T. )
          SE2->E2_FILIAL  := xFilial( "SE2" ); SE2->E2_NUM     := M->Z2_DOC
          SE2->E2_PREFIXO := M->Z2_SERIE;      SE2->E2_PARCELA := cParcela
          SE2->E2_TIPO    := "TX";             SE2->E2_NATUREZ := cNatIrf
          SE2->E2_FORNECE := GetMv("MV_UNIAO");SE2->E2_LOJA    := "00"
          SE2->E2_NOMFOR  := GetMv("MV_UNIAO");SE2->E2_EMISSAO := M->Z2_EMISSAO
          SE2->E2_VENCTO  := dVencto;          SE2->E2_VENCREA := DataValida( dVencto )
          SE2->E2_VALOR   := nValIrrf;         SE2->E2_EMIS1   := M->Z2_EMISSAO
          SE2->E2_SALDO   := nValIrrf;         SE2->E2_VENCORI := dVencto
          SE2->E2_MOEDA   := 1;                SE2->E2_RATEIO  := "N"
          SE2->E2_ORIGEM  := "FINA050";        SE2->E2_VLCRUZ  := nValIrrf
          SE2->E2_FLUXO   := "S";              SE2->E2_DESDOBR := "N"
          SE2->E2_DATADIG := dDataBase;        SE2->E2_LA      := "S"
          SE2->E2_NUMSCO  := M->Z2_COD;        SE2->E2_OBRA    := M->Z2_OBRA
          SE2->E2_CC      := M->Z2_CC;         SE2->E2_CONTA   := "213050301"
          SE2->E2_HIST    := M->Z2_DESC //;       SE2->E2_CONCLU  := SI3->I3_CONCLU
          SE2->( MsUnlock() )
          SE2->( dbCommit() )

          SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ, .t. ) )
          SA2->( dbSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, .T. ) )

       endif

       IF X == 1
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Geracao de titulo de iss                                     ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

          if m->Z2_ISS #0
             nParcIss := "1"
             nValIss  := m->Z2_ISS
             if StrZero( Month(m->Z2_DTDIGIT), 2 ) $ "01 03 05 07 08 10 12"
                dVencto := m->Z2_DTDIGIT+31
             elseif StrZero( Month( m->Z2_DTDIGIT ), 2 ) $ "04 06 09 11"
                dVencto := m->Z2_DTDIGIT+30
             elseif StrZero( Year( m->Z2_DTDIGIT ), 4 ) $ cBisexto
                dVencto := m->Z2_DTDIGIT+29
             else
                dVencto := m->Z2_DTDIGIT+28
             endif

             cNatIss := Alltrim( GetMv("MV_ISS") )
             cNatiss := If(Substr(cNatIss,1,1)=='"',Substr(cNatIss,2,Len(cNatIss)-2),cNatIss )
             dVencto1 := Ctod( StrZero( GetMv("MV_DIAISS"),2)+"/"+StrZero(Month(dVencto),2 )+"/"+StrZero( Year( dVencto ), 4 ) )
             RecLock( "SE2", .T. )
             SE2->E2_FILIAL  := xFilial( "SE2" ); SE2->E2_NUM     := M->Z2_DOC
             SE2->E2_PREFIXO := M->Z2_SERIE;      SE2->E2_PARCELA := cParcela
             SE2->E2_TIPO    := "ISS";            SE2->E2_NATUREZ := cNatIss
             SE2->E2_FORNECE := GetMv("MV_MUNIC");SE2->E2_LOJA    := "00"
             SE2->E2_NOMFOR  := GetMv("MV_MUNIC");SE2->E2_EMISSAO := M->Z2_EMISSAO
             SE2->E2_VENCTO  := dVencto1;         SE2->E2_VENCREA := DataValida( dVencto1 )
             SE2->E2_VALOR   := nValIss;          SE2->E2_EMIS1   := M->Z2_EMISSAO
             SE2->E2_SALDO   := nValIss;          SE2->E2_VENCORI := dVencto
             SE2->E2_MOEDA   := 1;                SE2->E2_RATEIO  := "N"
             SE2->E2_ORIGEM  := "FINA050";        SE2->E2_VLCRUZ  := nValIss
             SE2->E2_FLUXO   := "S";              SE2->E2_DESDOBR := "N"
             SE2->E2_DATADIG := dDataBase;        SE2->E2_LA      := "S"
             SE2->E2_NUMSCO  := M->Z2_COD;        SE2->E2_OBRA    := M->Z2_OBRA
             SE2->E2_CC      := M->Z2_CC;         SE2->E2_CONTA   := "213050801"
             SE2->E2_HIST    := M->Z2_DESC // ;       SE2->E2_CONCLU  := SI3->I3_CONCLU
             SE2->( MsUnlock() )
             SE2->( dbCommit() )

             SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ, .t. ) )
             SA2->( dbSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, .T. ) )

          endif

          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Geracao de titulo de inss                                    ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

          if m->Z2_INSS #0

             nParcInss := "1"
             nValInss := m->Z2_INSS
             if StrZero( Month(m->Z2_DTDIGIT), 2 ) $ "01 03 05 07 08 10 12"
                dVencto := m->Z2_DTDIGIT+31
             elseif StrZero( Month( m->Z2_DTDIGIT ), 2 ) $ "04 06 09 11"
                dVencto := m->Z2_DTDIGIT+30
             elseif StrZero( Year( m->Z2_DTDIGIT ), 4 ) $ cBisexto
                dVencto := m->Z2_DTDIGIT+29
             else
                dVencto := m->Z2_DTDIGIT+28
             endif
             cNatInss := Alltrim( GetMv("MV_INSS") )
             cNatInss := If(Substr(cNatInss,1,1)=='"',Substr(cNatInss,2,Len(cNatInss)-2),cNatInss )
             dVencto1 := Ctod( "02/"+StrZero(Month(dVencto),2 )+"/"+StrZero( Year( dVencto ), 4 ) )
             RecLock( "SE2", .T. )
             SE2->E2_FILIAL  := xFilial( "SE2" ); SE2->E2_NUM     := M->Z2_DOC
             SE2->E2_PREFIXO := M->Z2_SERIE;      SE2->E2_PARCELA := cParcela
             SE2->E2_TIPO    := "INS";            SE2->E2_NATUREZ := cNatInss
             SE2->E2_FORNECE := GetMv("MV_FORINSS");SE2->E2_LOJA    := "00"
             SE2->E2_NOMFOR  := GetMv("MV_FORINSS");SE2->E2_EMISSAO := M->Z2_EMISSAO
             SE2->E2_VENCTO  := dVencto1;         SE2->E2_VENCREA := DataValida( dVencto1 )
             SE2->E2_VALOR   := nValInss;         SE2->E2_EMIS1   := M->Z2_EMISSAO
             SE2->E2_SALDO   := nValInss;         SE2->E2_VENCORI := dVencto
             SE2->E2_MOEDA   := 1;                SE2->E2_RATEIO  := "N"
             SE2->E2_ORIGEM  := "FINA050";        SE2->E2_VLCRUZ  := nValInss
             SE2->E2_FLUXO   := "S";              SE2->E2_DESDOBR := "N"
             SE2->E2_DATADIG := dDataBase;        SE2->E2_LA      := "S"
             SE2->E2_NUMSCO  := M->Z2_COD;        SE2->E2_OBRA    := M->Z2_OBRA
             SE2->E2_CC      := M->Z2_CC;         SE2->E2_CONTA   := "214010501"
             SE2->E2_HIST    := M->Z2_DESC // ;       SE2->E2_CONCLU  := SI3->I3_CONCLU
             SE2->( MsUnlock() )
             SE2->( dbCommit() )

             SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ, .t. ) )
             SA2->( dbSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, .T. ) )

          endif
          nValor := aParcelas[ x, 2 ] - nValIss - nValInss - nValIrrf
       else
          nValor := aParcelas[ x, 2 ] - nValIrrf
       endif

       SED->( dbSeek( xFilial( "SED" ) + M->Z2_NATUREZ, .T. ) )
       SA2->( dbSetOrder( 1 ) )
       SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ, .t. ) )
       SA2->( dbSeek( xFilial( "SA2" ) + M->Z2_FORNECE + M->Z2_LOJA, .T. ) )

       RecLock( "SE2", .T. )
       SE2->E2_FILIAL  := xFilial( "SE2" ); SE2->E2_NUM     := M->Z2_DOC
       SE2->E2_PREFIXO := M->Z2_SERIE;      SE2->E2_PARCELA := cParcela
       SE2->E2_TIPO    := M->Z2_TIPO;       SE2->E2_NATUREZ := M->Z2_NATUREZ
       SE2->E2_FORNECE := M->Z2_FORNECE;    SE2->E2_LOJA    := M->Z2_LOJA
       SE2->E2_NOMFOR  := SA2->A2_NREDUZ;   SE2->E2_EMISSAO := M->Z2_EMISSAO
       SE2->E2_VENCTO  := aParcelas[ x, 1 ];SE2->E2_VENCREA := DataValida( aParcelas[ x, 1 ] )
       SE2->E2_VALOR   := nValor;           SE2->E2_EMIS1   := M->Z2_EMISSAO
       SE2->E2_SALDO   := nValor;           SE2->E2_VENCORI := aParcelas[ x, 1 ]
       SE2->E2_MOEDA   := 1;                SE2->E2_RATEIO  := "N"
       SE2->E2_OCORREN := "01";             SE2->E2_ORIGEM  := "FINA050"
       SE2->E2_FLUXO   := "S";              SE2->E2_DESDOBR := "N"
       SE2->E2_CC      := M->Z2_CC;         SE2->E2_DATADIG := dDataBase
       SE2->E2_ISS     := nValIss;          SE2->E2_IRRF    := nValIrrf
       SE2->E2_PARCIR  := nParcIrrf;        SE2->E2_PARCISS := nParcIss
       SE2->E2_INSS    := nValInss;         SE2->E2_PARCINS := nParcInss
       SE2->E2_VLCRUZ  := nValor;           SE2->E2_LA      := "S"
       SE2->E2_CONTA   := SA2->A2_CONTA;    SE2->E2_HIST    := m->Z2_DESC  // "Ref. "+ Alltrim( SED->ED_DESCRIC ) + " CF. NF. " + Alltrim( M->Z2_DOC )
       SE2->E2_NUMSCO  := M->Z2_COD;        SE2->E2_OBRA    := M->Z2_OBRA
       // SE2->E2_CONCLU  := SI3->I3_CONCLU
       SE2->( MsUnlock() )
       SE2->( dbCommit() )

       SED->( dbSeek( xFilial( "SED" ) + SE2->E2_NATUREZ, .t. ) )
       SA2->( dbSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, .T. ) )
       nTotal := nTotal + DetProva( nHdlPrv,"510","SCO001I",cLoteSCO )

   Next

   RodaProva( nHdlPrv, nTotal )
   cA100incl( cArquivo, nHdlPrv,3,cLoteSCO,lLanc,.f.)

endif

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(lFlag)
Return(lFlag)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
