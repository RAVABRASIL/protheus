#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function CTBAGL()      // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CALIASANT,ACRA,M_SAV20,M_SAV7,NPOSANT,NPOSATU")
SetPrvt("NPOSCNT,CSAVSCR,CSAVCUR,CSAVCOR,ARQIMP,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,CARQUIVO,AORD,CNOMREL")
SetPrvt("CTITULO,NLASTKEY,NMIDIA,NVALDEB,NVALCRE,NVALTOT")
SetPrvt("ASTRUT,DDATA,CNUM,CPER,NREG")
SetPrvt("NREGIST,NREGTOT,NLAN,NLIN,LFLAG,cPerg,dData")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇�  Autor  � Eurivan Marques Candido                  � Data � 15/05/03 낢�
굇쳐컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escricao� Aglutina lancamentos do contas a receber por periodo       낢�
굇쳐컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�   Uso   � Contabilidade                                              낢�
굇읕컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽

  旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  � Define Todas as variaveis PRIVATE.                           �
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/
cALIASANT := alias()

/*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  � Inicio do processamento                                      �
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

MV_PAR01 = De Data   Tamanho 8
MV_PAR02 = Ate Data  Tamanho 8
MV_PAR03 = De Lote   Tamanho 6
MV_PAR04 = Ate Lote  Tamanho 6

*/

cPerg := "CTBAGL"

AjustaSX1( cPerg )

Pergunte(cPerg,.F.)               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Aglutina Lancamentos por Dia"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return


// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Function OkProc
Static Function OkProc()

Close(oDlg1)
Processa( {|| Agluti() } )// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Processa( {|| Execute(Cap_CCP) } )
Return


// Substituido pelo assistente de conversao do AP5 IDE em 02/08/01 ==> Function Cap_CCP
Static Function Agluti()

dbselectarea( "CT2" )
CT2->( dbsetorder( 1 ) )
//CT2->( dbseek( xFILIAL("CT2") + dtos( mv_par01 ), .T. ) )
//count to nREGTOT while CT2->CT2_DATA <= MV_PAR02
ProcRegua( 0 )
CT2->( dbseek( xFILIAL("CT2") + dtos( mv_par01 )+MV_PAR03, .T. ) )

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

dDATA := mv_par01
while ! CT2->( eof() ) .and. dDATA <=  mv_par02
   while ! CT2->( eof() ) .and. CT2->CT2_DATA == dDATA
      cNUM  := CT2->( CT2_LOTE+CT2_SBLOTE+CT2_DOC )
      lFLAG := .F.
      while ! CT2->( eof() ) .and. CT2->CT2_DATA == dDATA .and. Left( cNUM, 6 ) == CT2->CT2_LOTE
        If CT2->CT2_LOTE >= mv_par03 .and. CT2->CT2_LOTE <= mv_par04
          lFLAG := .T.
          if CT2->CT2_DC $ "13" //Debito ou partida Dobrada
             if ! CT->( DbSeek( Dtos(CT2->CT2_DATA) + CT2->CT2_DEBITO ) )
                CT->( dbappend() )
                CT->CONTA := CT2->CT2_DEBITO
                CT->DTLAN := CT2->CT2_DATA
             endif
             CT->VLDEB += CT2->CT2_VALOR
             CT->V3DEB += CT2->CT2_VLR03
          endif
          if CT2->CT2_DC $ "23" //Credito ou partida dobrada
             if ! CT->( dbseek( dtos(CT2->CT2_DATA)+CT2->CT2_CREDITO ) )
                CT->( dbappend() )
                CT->CONTA := CT2->CT2_CREDITO
                CT->DTLAN := CT2->CT2_DATA
             endif
             CT->VLCRE += CT2->CT2_VALOR
             CT->V3CRE += CT2->CT2_VLR03
          endif
          RecLock( 'CT2', .F. )
          CT2->( DbDelete() )
          CT2->( dbcommit() )
          CT2->( dbunlock() )
        EndIf
        CT2->( dbskip() )
        /*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
          � Movimenta a regua de processamento  �
          읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        */
        IncProc()
      EndDo
      If lFLAG
        CT->( dbseek( dtos(dDATA),.T. ) )
        nLAN := Val( right( cNUM, 6 ) )
        
        nREG := CT2->( Recno() )
        while ! CT->( Eof() ) .and. CT->DTLAN == dDATA
           nLIN := 1

           while ! CT->( eof() ) .And. CT->DTLAN == dDATA .and. nLIN <= 999
              reclock( "CT2", .t. )
              CT2->CT2_FILIAL   := xFILIAL("CT2")
              //CT2->I2_NUM      := left( cNUM, 4 ) + strzero( nLAN, 6 )
              CT2->CT2_LOTE     := SUBSTR( cNUM, 1, 6 )
              CT2->CT2_SBLOTE   := SUBSTR( cNUM, 7, 3 )
              CT2->CT2_DOC      := strzero( nLAN, 6 )
              CT2->CT2_LINHA    := strzero( nLIN, 3 )
              CT2->CT2_DATA     := dDATA
              CT2->CT2_MOEDLC   := "01"
              CT2->CT2_TPSALD   := "1"
              CT2->CT2_MANUAL   := "1"              
              CT2->CT2_HIST     := "CONF.MOVTO.N/DATA"
              CT2->CT2_DTVENC   := dDATA
              CT2->CT2_ROTINA   := "CTBAGL"
              CT2->CT2_FILORIG  := "01"
              CT2->CT2_EMPORIG  := cEMPANT

              if ! empty( CT->VLDEB ) .and. ! empty( CT->VLCRE )
                 CT2->CT2_DC      := "1"
                 CT2->CT2_DEBITO  := CT->CONTA
                 CT2->CT2_VALOR   := CT->VLDEB
                 CT2->CT2_VLR03   := CT->V3DEB
                 CT2->( dbunlock() )
                 reclock( "CT2", .t. )
                 CT2->CT2_FILIAL   := xFILIAL("CT2")
//                 CT2->CT2_NUM      := left( cNUM, 4 ) + strzero( nLAN, 6 )
                 CT2->CT2_LOTE     := SUBSTR( cNUM, 1, 6 )
                 CT2->CT2_SBLOTE   := SUBSTR( cNUM, 7, 3 )
                 CT2->CT2_DOC      := strzero( nLAN, 6 )
                 CT2->CT2_LINHA    := strzero( nLIN, 3 )
                 CT2->CT2_DATA     := dDATA
                 CT2->CT2_MOEDLC   := "01"
                 CT2->CT2_TPSALD   := "1"
                 CT2->CT2_MANUAL   := "1"
                 CT2->CT2_HIST     := "CONF.MOVTO.N/DATA"

                 nLIN := nLIN + 1
                 CT2->CT2_DC      := "2"
                 CT2->CT2_CREDITO := CT->CONTA
                 CT2->CT2_VALOR   := CT->VLCRE
                 CT2->CT2_VLR03   := CT->V3CRE
              elseif ! empty( CT->VLCRE )
                 CT2->CT2_DC      := "2"
                 CT2->CT2_CREDITO := CT->CONTA
                 CT2->CT2_VALOR   := CT->VLCRE
                 CT2->CT2_VLR03 := CT->V3CRE
              elseif ! empty( CT->VLDEB )
                 CT2->CT2_DC      := "1"
                 CT2->CT2_DEBITO  := CT->CONTA
                 CT2->CT2_VALOR   := CT->VLDEB
                 CT2->CT2_VLR03   := CT->V3DEB
              endif
              CT2->( dbunlock() )
              nLIN := nLIN + 1
              CT2->( dbcommit() )
              CT->( dbskip() )
              /*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
                � Movimenta a regua de processamento  �
                읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
              */
           end
           nLAN := nLAN + 1
        end
        dbselectarea( "CT" )
        CT->( dbcommit() )
        CT2->( DbGoto( nREG ) )
      EndIf
   EndDo
   dDATA := dDATA + 1
end
RETINDEX("CT2")
CT->( dbclosearea() )
dbselectarea( cALIASANT )
RETURN(.T.)


********************************
Static Function AjustaSx1()
********************************

PutSx1(cPerg,"01","Data de  ?"," "," ","mv_ch1" ,"D",008,0,0,"G",""        ,"",,,"mv_par01","","","","","","","")
PutSx1(cPerg,"02","Data Ate ?"," "," ","mv_ch2" ,"D",008,0,0,"G",""        ,"",,,"mv_par02","","","","","","","")
PutSx1(cPerg,"03","Lote de  ?"," "," ","mv_ch3" ,"C",006,0,0,"G",""        ,"",,,"mv_par03","","","","","","","")
PutSx1(cPerg,"04","Lote Ate ?"," "," ","mv_ch4" ,"C",006,0,0,"G",""        ,"",,,"mv_par04","","","","","","","")

Return                                                                                                             
