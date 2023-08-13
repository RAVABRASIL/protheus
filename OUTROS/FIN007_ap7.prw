#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FIN007()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CLOTEF07,CARQUIVO,NTOTAL,LLANC,AROTINA,NHDLPRV")
SetPrvt("CCLIENTE,LFLAG,NSALCONT,DDATAVEN,NJURINDX,NJUROS")
SetPrvt("NPERCJUR,NJUR,NVALOR,NSALDO,CDIA,CMESBASE")
SetPrvt("CANO,DDATA,CVENCREA,NSALCONTA,NISALCONT,NANOEXERC")
SetPrvt("Y,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FIN007    ³ Autor ³ Silvano Araujo        ³ Data ³ 30/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao de valores Pro-rata para o dia.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
mv_par01 - De Cliente
mv_par02 - Ate Cliente
mv_par03 - Gera Valor 1-Vencimento, 2-Data Base, 3-Bloquete, 4-Valor Fluxo
mv_par04 - De Vencimento Real
mv_par05 - Ate Vencimento Real
mv_par06 - Contabiliza Correcao 1-Nao ou 2-Sim
mv_par07 - Mostra Lancamentos Contabeis 1-Sim ou 2-Nao
/*/
Pergunte("FIN007",.F.)               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Geracao de Valores em funcao de indices"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("FIN007")
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()

Close(oDlg1)
Processa( {|| GereVal() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(GereVal) } )
Return



// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function GereVal
Static Function GereVal()
SX5->( dbSeek( xFilial( "SX5" ) + "09F07", .t. ) )
cLoteF07 := Alltrim( SX5->X5_DESCRI )
cArquivo := ""
nTotal   := 0
lLanc     := iif(mv_par07==1,.t.,.f.)
aRotina   := {    { "Pesquisar" ,"A460Pesqui", 0 , 1},;
            { "Ordem","A460Ordem", 0 , 0},;
            { "Gera Notas","A460Nota", 0 , 3},;
            { "Estornar","A460Estor", 0 , 0}    }

if mv_par06 == 2
   nHdlPrv := HeadProva( cLoteF07, "FIN007",Substr( cUsuario,7,6 ), @cArquivo )
endif

SI3->( dbSetOrder( 1 ) )
SE1->( dbSetOrder( 2 ) )
SE1->( dbSeek( xFilial( "SE1") + mv_par01, .t. ) )
ProcRegua( SE1->( Lastrec() ) )

While SE1->E1_CLIENTE <= mv_par02 .and. SE1->( !Eof() )

   cCliente := SE1->E1_CLIENTE
   lFlag    := .t.
   SEZ->( dbSetorder( 1 ) )
   SEZ->( dbSeek( xFilial( "SEZ" ) + SE1->E1_NUM, .t. ) )
   if SEZ->EZ_NUM #SE1->E1_NUM .or. SEZ->EZ_CLIENTE # SE1->E1_CLIENTE
      SEZ->( dbSetOrder( 3 ) )
      SEZ->( dbSeek( xFilial( "SEZ" ) + SE1->E1_CLIENTE + SE1->E1_LOJA, .T. ) )
      if SE1->E1_CLIENTE #SEZ->EZ_CLIENTE
         lFlag := .f.
      endif
      SEZ->( dbSetOrder( 1 ) )
   endif

   if !lFlag
      SE1->( dbSkip() )
      IncProc()
      Loop
   endif

   nSalCont := 0
   SA1->( dbSetorder( 1 ) )
   SA1->( dbSeek( xFilial( "SA1" ) + SE1->E1_CLIENTE + SE1->E1_LOJA, .t. ) )

   While SE1->E1_CLIENTE == cCliente .and. SE1->( !Eof() )

      if SE1->E1_SALDO == 0 .or. Upper( Substr( SE1->E1_NTIT, 5, 1 ) ) == "S"
         SE1->( dbSkip() )
         IncProc()
         Loop
      endif

      if SE1->E1_VENCTO < mv_par04 .or. SE1->E1_VENCTO > mv_par05
         SE1->( dbSkip() )
         IncProc()
         Loop
      endif



      if SE1->E1_ADITIVO == " "
         dDataVen := SA1->A1_DATAVEN
      elseif SE1->E1_ADITIVO == "1"
         dDataVen := SA1->A1_DATAV1
      elseif SE1->E1_ADITIVO == "2"
         dDataVen := SA1->A1_DATAV2
      elseif SE1->E1_ADITIVO == "3"
         dDataVen := SA1->A1_DATAV3
      elseif SE1->E1_ADITIVO == "4"
         dDataVen := SA1->A1_DATAV4
      elseif SE1->E1_ADITIVO == "5"
         dDataVen := SA1->A1_DATAV5
      elseif SE1->E1_ADITIVO == "6"
         dDataVen := SA1->A1_DATAV6
      elseif SE1->E1_ADITIVO == "7"
         dDataVen := SA1->A1_DATAV7
      endif

      if mv_par03 #4 // CALCULO PARA
         SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( iif(mv_par03#2,SE1->E1_VENCREA,dDataBase) ), .t. ) )
         if SEX->( Eof() )
            SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( dDataBase ), .t. ) )
         endif

         if iif(mv_par03#2,SE1->E1_VENCREA,dDataBase)  < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
            nJurIndx := Round( SE1->E1_JURP_AN * ( iif( mv_par03#2, SE1->E1_VENCREA, dDatabase ) - dDataVen ) * SEX->EX_VALOR, 2 )
         elseif iif(mv_par03#2,SE1->E1_VENCREA,dDataBase) < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT" .or. SE1->E1_PREFIXO $ "INT YNT" )
            nJurIndx := Round( SE1->E1_JURI_AN * ( iif( mv_par03#2, SE1->E1_VENCREA, dDatabase ) - dDataVen ) * SEX->EX_VALOR, 2 )
         elseif iif(mv_par03#2,SE1->E1_VENCREA,dDataBase) >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
            nJuros   := Round( SE1->E1_JURP_AN*( SEZ->EZ_DATENT - dDataVen ) * SEX->EX_VALOR, 2 )
            nJurIndx := Round( SE1->E1_JURP_DP*( Iif( mv_par03#2, SE1->E1_VENCREA, dDataBase ) - (SEZ->EZ_DATENT)  ) * SEX->EX_VALOR, 2 ) + nJuros
         elseif iif(mv_par03#2,SE1->E1_VENCREA,dDataBase) >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT" .or. SE1->E1_PREFIXO $ "INT YNT" )
            nJuros   := Round( SE1->E1_JURI_AN*( SEZ->EZ_DATENT - dDataVen ) * SEX->EX_VALOR, 2 )
            nJurIndx := Round( SE1->E1_JURI_DP*( Iif( mv_par03#2, SE1->E1_VENCREA, dDataBase ) - ( SEZ->EZ_DATENT)  ) * SEX->EX_VALOR, 2 ) + nJuros
         else
            nPercJur := nJur := nJurIndx := 0
         endif

         // nJuros := Round( SE1->E1_JURINDX * ( iif(mv_par03==1,SE1->E1_VENCREA,dDataBase) - SA1->A1_DATAVEN ) * SEX->EX_VALOR, 2 )
         nValor := SE1->E1_VALOR - SE1->E1_SALDO + Round( SE1->E1_SALINDX * SEX->EX_VALOR, 2 ) + nJurIndx
         nSaldo := Round( SE1->E1_SALINDX * SEX->EX_VALOR, 2 ) + nJurIndx
      else

         cDia     := StrZero( Day( SE1->E1_VENCREA ), 2 )
         cMesBase := StrZero( Month( dDataBase ), 2 )
         cAno     := StrZero( Year( dDatabase ), 4 )

         if cMesBase == "02" .and. cDia $ "31 30 29"
            dData := dDataBase
            While Month( dData ) == Month( dDatabase )
               dData := dData + 1
            end
            dData := dData - 1
            cDia  := StrZero( Day( dData ), 2 )
         endif

         if cMesBase $ "04 06 09 11" .and. cDia == "31"
            cDia := "30"
         endif

         cVencRea := Ctod( cDia+"/"+cMesBase+"/"+cAno )

         SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( cVencRea ), .t. ) )
         if SEX->( Eof() )
            SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( dDataBase ), .t. ) )
         endif

         if cVencRea  < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
            nJurIndx := Round( SE1->E1_JURP_AN * ( cVencRea - dDataVen ) * SEX->EX_VALOR, 2 )
         elseif cVencRea < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT IT0" .or. SE1->E1_PREFIXO $ "INT YNT IT0" )
            nJurIndx := Round( SE1->E1_JURI_AN * ( cVencRea - dDataVen ) * SEX->EX_VALOR, 2 )
         elseif cVencRea >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
            nJuros   := Round( SE1->E1_JURP_AN * ( SEZ->EZ_DATENT - dDataVen ) * SEX->EX_VALOR, 2 )
            nJurIndx := Round( SE1->E1_JURP_DP * ( cVencRea - SEZ->EZ_DATENT ) * SEX->EX_VALOR, 2 ) + nJuros
         elseif cVencRea >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT IT0" .or. SE1->E1_PREFIXO $ "INT YNT IT0" )
            nJuros   := Round( SE1->E1_JURI_AN * ( SEZ->EZ_DATENT - dDataVen ) * SEX->EX_VALOR, 2 )
            nJurIndx := Round( SE1->E1_JURI_DP * ( cVencRea - SEZ->EZ_DATENT ) * SEX->EX_VALOR, 2 ) + nJuros
         else
            nPercJur := nJur := nJurIndx := 0
         endif

         // nJuros := Round( SE1->E1_JURINDX * ( iif(mv_par03==1,cVencRea,dDataBase) - SA1->A1_DATAVEN ) * SEX->EX_VALOR, 2 )
         nValor := SE1->E1_VALOR - SE1->E1_SALDO + Round( SE1->E1_SALINDX * SEX->EX_VALOR, 2 ) + nJurIndx
         nSaldo := Round( SE1->E1_SALINDX * SEX->EX_VALOR, 2 ) + nJurIndx
      endif

      RecLock( "SE1", .f. )

      If mv_par03 == 3
         SE1->E1_VLBLOQ := nSaldo
      Elseif mv_par03 == 2 .and. mv_par06 == 2
         SE1->E1_VALANTC := SE1->E1_VALOR
         SE1->E1_SALANTC := SE1->E1_SALDO

         If DTOS(E1_EMISSAO) <= DTOS(dDataBase)    // .AND. DTOS(E1_VENCREA) > DTOS(dDataBase)
            If Month(dDataBase) == 01
               SE1->E1_SDANT01 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 02
               SE1->E1_SDANT02 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 03
               SE1->E1_SDANT03 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 04
               SE1->E1_SDANT04 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 05
               SE1->E1_SDANT05 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 06
               SE1->E1_SDANT06 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 07
               SE1->E1_SDANT07 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 08
               SE1->E1_SDANT08 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 09
               SE1->E1_SDANT09 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 10
               SE1->E1_SDANT10 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 11
               SE1->E1_SDANT11 := SE1->E1_SALDO
            ElseIf Month(dDataBase) == 12
               SE1->E1_SDANT12 := SE1->E1_SALDO
            Endif
         Endif
      Endif

      nSalCont        := nSalCont + nSaldo
      SE1->E1_VALOR   := nValor
      SE1->E1_SALDO   := nSaldo
      SE1->E1_VLCRUZ  := nValor
      SE1->( MsUnlock() )
      SE1->( dbCommit() )
      SE1->( dbSkip() )
      IncProc()

   End

   SI1->( dbSetorder( 1 ) )
   SI1->( dbSeek( xFilial( "SI1" ) + SA1->A1_CONTA, .t. ) )

   nSalConta := 0
   fSalContabil()
   /*/
   if nSalCont #0
      MSGBOX( "CLIENTE "+SA1->A1_COD+" "+Alltrim( SA1->A1_NREDUZ )+" SE1 "+STR(nSalcont,10,2)+" SI1 "+str(nSalConta,10,2)+" CONTA "+SI1->I1_CODigo+" DESC "+Alltrim( SI1->I1_DESC ),"info","stop")
   endif
   /*/
   nSalCont := Round( nSalCont - nSalConta, 2 )
   if nSalCont < 0
      nIsalCont := ( nSalCont * ( -1 ) )
   else
      nIsalcont := 0
   endif

   if mv_par06 == 2 .and. mv_par03 == 2 .and. nSalCont #0
      SA1->( dbSeek( xFilial( "SA1" ) + SE1->E1_CLIENTE + SE1->E1_LOJA ) )
      SI3->( dbSeek( xFilial( "SI3" ) + SE1->E1_CC, .t. ) )
      nTotal := nTotal + DetProva( nHdlPrv,"F07","FIN007",cLoteF07 )
   endif

end

if mv_par06 == 2
   RodaProva( nHdlPrv, nTotal )
   cA100incl( cArquivo, nHdlPrv,3,cLoteF07,lLanc,.T.)
endif

Retindex("SE1")
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSalContabilt³ Autor ³ Silvano Araujo     ³ Data ³ 02/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o saldo de uma determinada conta contabil          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSalContabilt()                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Espec¡fico para  Queiroz Galvao                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function fSalContabil
Static Function fSalContabil()
nSalConta := Abs( SI1->I1_SALANT )
SX6->( dbSeek( xFilial( "SX6" ) + "MV_EXERC1" ) )
nAnoExerc := Val( SX6->X6_CONTEUD )
if Year( dDataBase ) #nAnoExerc
   For y := 1 to 12
       if y == 1
          nSalConta := nSalConta + SI1->I1_DEBM01 - SI1->I1_CRDM01
       elseif y == 2
          nSalConta := nSalConta + SI1->I1_DEBM02 - SI1->I1_CRDM02
       elseif y == 3
          nSalConta := nSalConta + SI1->I1_DEBM03 - SI1->I1_CRDM03
       elseif y == 4
          nSalConta := nSalConta + SI1->I1_DEBM04 - SI1->I1_CRDM04
       elseif y == 5
          nSalConta := nSalConta + SI1->I1_DEBM05 - SI1->I1_CRDM05
       elseif y == 6
          nSalConta := nSalConta + SI1->I1_DEBM06 - SI1->I1_CRDM06
       elseif y == 7
          nSalConta := nSalConta + SI1->I1_DEBM07 - SI1->I1_CRDM07
       elseif y == 8
          nSalConta := nSalConta + SI1->I1_DEBM08 - SI1->I1_CRDM08
       elseif y == 9
          nSalConta := nSalConta + SI1->I1_DEBM09 - SI1->I1_CRDM09
       elseif y == 10
          nSalConta := nSalConta + SI1->I1_DEBM10 - SI1->I1_CRDM10
       elseif y == 11
          nSalConta := nSalConta + SI1->I1_DEBM11 - SI1->I1_CRDM11
       elseif y == 12
          nSalConta := nSalConta + SI1->I1_DEBM12 - SI1->I1_CRDM12
       endif
   Next
endif

For y := 1 to Month( dDatabase )
    if y == 1
       if Year( dDataBase ) == nAnoExerc
          nSalConta := nSalConta + SI1->I1_DEBM01 - SI1->I1_CRDM01
       else
          nSalConta := nSalConta + SI1->I1_DEBM13 - SI1->I1_CRDM13
       endif
    elseif y == 2
       if Year( dDataBase ) == nAnoExerc
          nSalConta := nSalConta + SI1->I1_DEBM02 - SI1->I1_CRDM02
       else
          nSalConta := nSalConta + SI1->I1_DEBM14 - SI1->I1_CRDM14
       endif
    elseif y == 3
       if Year( dDataBase ) == nAnoExerc
          nSalConta := nSalConta + SI1->I1_DEBM03 - SI1->I1_CRDM03
       else
          nSalConta := nSalConta + SI1->I1_DEBM15 - SI1->I1_CRDM15
       endif
    elseif y == 4
       if Year( dDataBase ) == nAnoExerc
          nSalConta := nSalConta + SI1->I1_DEBM04 - SI1->I1_CRDM04
       else
          nSalConta := nSalConta + SI1->I1_DEBM16 - SI1->I1_CRDM16
       endif
    elseif y == 5
       if Year( dDataBase ) == nAnoExerc
          nSalConta := nSalConta + SI1->I1_DEBM05 - SI1->I1_CRDM05
       else
          nSalConta := nSalConta + SI1->I1_DEBM17 - SI1->I1_CRDM17
       endif
    elseif y == 6
       nSalConta := nSalConta + SI1->I1_DEBM06 - SI1->I1_CRDM06
    elseif y == 7
       nSalConta := nSalConta + SI1->I1_DEBM07 - SI1->I1_CRDM07
    elseif y == 8
       nSalConta := nSalConta + SI1->I1_DEBM08 - SI1->I1_CRDM08
    elseif y == 9
       nSalConta := nSalConta + SI1->I1_DEBM09 - SI1->I1_CRDM09
    elseif y == 10
       nSalConta := nSalConta + SI1->I1_DEBM10 - SI1->I1_CRDM10
    elseif y == 11
       nSalConta := nSalConta + SI1->I1_DEBM11 - SI1->I1_CRDM11
    elseif y == 12
       nSalConta := nSalConta + SI1->I1_DEBM12 - SI1->I1_CRDM12
    endif
Next

Return Nil
