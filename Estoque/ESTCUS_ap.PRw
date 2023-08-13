#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function ESTCUS()      // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,ACRA,M_SAV20,M_SAV7,NPOSANT,NPOSATU")
SetPrvt("NPOSCNT,CSAVSCR,CSAVCUR,CSAVCOR,ARQIMP,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,CARQUIVO,AORD,CNOMREL")
SetPrvt("CTITULO,NLASTKEY,NMIDIA,NVALDEB,NVALCRE,NVALTOT")
SetPrvt("ASTRUT,DDATA,CNUM,CFOR,CPER,NREG")
SetPrvt("NREGIST,NREGTOT,NLAN,NLIN,LFLAG,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Mauricio de Barros Silva                 ³ Data ³ 15/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Lancamentos contabeis do custo de producao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Contabilidade                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Define Todas as variaveis PRIVATE.                           ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cALIASANT := alias()

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MV_PAR01 = De Data   Tamanho 8
MV_PAR02 = Ate Data  Tamanho 8
MV_PAR03 = De Lote   Tamanho 4
MV_PAR04 = Ate Lote  Tamanho 4

*/

Pergunte( "ESTCUS", .F. )               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Apuracao do custo de producao"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte( "ESTCUS" )
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return


// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Function OkProc
Static Function OkProc()

Close(oDlg1)
Processa( {|| ApurCustProd() } )// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Processa( {|| Execute(Cap_CCP) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Function Cap_CCP
Static Function ApurCustProd()

dbselectarea( "SI2" )
SI2->( dbsetorder( 3 ) )
SI2->( dbseek( xFILIAL("SI2") + dtos( mv_par01 ), .T. ) )
count to nREGTOT while SI2->I2_DATA <= MV_PAR02
ProcRegua( nREGTOT )
SI2->( dbseek( xFILIAL("SI2") + dtos( mv_par01 ), .T. ) )

nVALDEB := nVALCRE := nVALTOT := 0
aSTRUT  := {}

aadd( aSTRUT, { "DTLAN", "D", 08, 0 } )
aadd( aSTRUT, { "CONTA", "C", 20, 0 } )
aadd( aSTRUT, { "VLDEB", "N", 17, 2 } )
aadd( aSTRUT, { "VLCRE", "N", 17, 2 } )
aadd( aSTRUT, { "V3DEB", "N", 17, 2 } )
aadd( aSTRUT, { "V3CRE", "N", 17, 2 } )

cARQ1 := CriaTrab( aSTRUT, .T. )
Use (cARQ1) Alias CT New Exclusive
Index On DTOS(DTLAN)+CONTA To (cARQ1)

cFOR := "01"
dDATA := mv_par01
while ! SI2->( eof() ) .and. dDATA <=  mv_par02
   while ! SI2->( eof() ) .and. SI2->I2_DATA == dDATA
      cNUM  := SI2->I2_NUM
      lFLAG := .F.
      while ! SI2->( eof() ) .and. SI2->I2_DATA == dDATA .and. Left( cNUM, 4 ) == Left( SI2->I2_NUM, 4 )
        If left( SI2->I2_NUM, 4 ) >= mv_par03 .and. left( SI2->I2_NUM, 4 ) <= mv_par04
          lFLAG := .T.
          if SI2->I2_DC $ "DX"
             if ! CT->( DbSeek( Dtos(SI2->I2_DATA) + SI2->I2_DEBITO ) )
                CT->( dbappend() )
                CT->CONTA := SI2->I2_DEBITO
                CT->DTLAN := SI2->I2_DATA
             endif
             CT->VLDEB += SI2->I2_VALOR
             CT->V3DEB += SI2->I2_VLMOED3
          endif
          if SI2->I2_DC $ "CX"
             if ! CT->( dbseek( dtos(SI2->I2_DATA)+SI2->I2_CREDITO ) )
                CT->( dbappend() )
                CT->CONTA := SI2->I2_CREDITO
                CT->DTLAN := SI2->I2_DATA
             endif
             CT->VLCRE += SI2->I2_VALOR
             CT->V3CRE += SI2->I2_VLMOED3
          endif
          RecLock( 'SI2', .F. )
          SI2->( DbDelete() )
          SI2->( dbcommit() )
          SI2->( dbunlock() )
        EndIf
        SI2->( dbskip() )
        /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          ³ Movimenta a regua de processamento  ³
          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        */
        IncProc()
      EndDo
      If lFLAG
        CT->( dbseek( dtos(dDATA),.T. ) )
        nLAN := Val( right( cNUM, 6 ) )
        nREG := SI2->( Recno() )
        while ! CT->( Eof() ) .and. CT->DTLAN == dDATA
           nLIN := 1

           while ! CT->( eof() ) .And. CT->DTLAN == dDATA .and. nLIN <= 99
              reclock( "SI2", .t. )
              SI2->I2_FILIAL   := xFILIAL("SI2")
              SI2->I2_NUM      := left( cNUM, 4 ) + strzero( nLAN, 6 )
              SI2->I2_LINHA    := strzero( nLIN, 2 )
              SI2->I2_DATA     := dDATA
              SI2->I2_MOEDAS   := "SNNNN"
              SI2->I2_CRITER   := "DDUD"
              SI2->I2_PERIODO  := strzero( year( dDATA ), 4 ) + strzero( month( dDATA ), 2 )
              SI2->I2_HIST     := "CONF.MOVTO.N/DATA"
      //       SI2->I2_HP       := "000"

              if ! empty( CT->VLDEB ) .and. ! empty( CT->VLCRE )
                 SI2->I2_DC      := "D"
                 SI2->I2_DEBITO  := CT->CONTA
                 SI2->I2_VALOR   := CT->VLDEB
                 SI2->I2_VLMOED3 := CT->V3DEB
                 SI2->( dbunlock() )
                 reclock( "SI2", .t. )
                 SI2->I2_FILIAL   := xFILIAL("SI2")
                 SI2->I2_NUM      := left( cNUM, 4 ) + strzero( nLAN, 6 )
                 SI2->I2_DATA     := dDATA
                 SI2->I2_MOEDAS   := "SNNNN"
                 SI2->I2_CRITER   := "DDUD"
                 SI2->I2_PERIODO  := right( strzero( year( dDATA ), 4 ), 2 ) + strzero( month( dDATA ), 2 )
                 SI2->I2_HIST     := "CONF.MOVTO.N/DATA"
      //          SI2->I2_HP       := "000"
                 nLIN := nLIN + 1
                 SI2->I2_LINHA   := strzero( nLIN, 2 )
                 SI2->I2_DC      := "C"
                 SI2->I2_CREDITO := CT->CONTA
                 SI2->I2_VALOR   := CT->VLCRE
                 SI2->I2_VLMOED3 := CT->V3CRE
              elseif ! empty( CT->VLCRE )
                 SI2->I2_DC      := "C"
                 SI2->I2_CREDITO := CT->CONTA
                 SI2->I2_VALOR   := CT->VLCRE
                 SI2->I2_VLMOED3 := CT->V3CRE
              elseif ! empty( CT->VLDEB )
                 SI2->I2_DC      := "D"
                 SI2->I2_DEBITO  := CT->CONTA
                 SI2->I2_VALOR   := CT->VLDEB
                 SI2->I2_VLMOED3 := CT->V3DEB
              endif
              SI2->( dbunlock() )
              nLIN := nLIN + 1
              SI2->( dbcommit() )
              CT->( dbskip() )
              /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                ³ Movimenta a regua de processamento  ³
                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              */
           end
           nLAN := nLAN + 1
        end
        dbselectarea( "CT" )
        CT->( dbcommit() )
        SI2->( DbGoto( nREG ) )
      EndIf
   EndDo
   dDATA := dDATA + 1
end
RETINDEX("SI2")
CT->( dbclosearea() )
dbselectarea( cALIASANT )
RETURN(.T.)

