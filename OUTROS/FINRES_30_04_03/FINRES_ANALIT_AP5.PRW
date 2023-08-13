#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FINRES()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,CTES")
SetPrvt("WREGFIN,NREGTOT,NVALTOT,NPESTOT,AEST,AREP")
SetPrvt("ACLI,NQTDKG,NEST,NCLI,NREP,M_PAG")
SetPrvt("NLIN,ACLIS,AESTS,AREPS,NPACUM,NCONTJ")
SetPrvt("nVLSALBCO, nSALDOINI")


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Autor    ³ Eurivan Marques Candido                  ³ Data ³ 10/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Relatorio de Resumo Financeiro Analitico                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso      ³ Financeiro                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cALIASANT := alias()
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis de parametrizacao da impressao.                    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "DECOM", 2, 2, 1, "", 1 }
cARQUIVO := "SE5"
aORD     := { "Por Data" }
cNOMREL  := "FINRES"
cTITULO  := "Relatorio de Resumo Financeiro Analitico"
nLASTKEY := 0

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Pergunte('FINTRC',.f.)

cNOMREL := setprint( cARQUIVO, cNOMREL, "FINRES", @cTITULO, cDESC1, cDESC2, ;
 cDESC3, .f., aORD )
If nLastKey == 27
   Return
Endif

setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif

nMIDIA := aRETURN[ 5 ]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

dbselectarea( 'SE5' )

//cFiltro := "E5_DATA>=mv_par01.and.E5_DATA<=mv_par02"
cFiltro := "E5_DTDISPO>=mv_par01.and.E5_DTDISPO<=mv_par02"
cCHAVE  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
//cChave  := "DTOS(E5_DATA)"
cIndSE5 := CriaTrab( nil, .f. )
IndRegua( "SE5", cIndSE5, cChave, , cFILTRO, "Selecionando Movimentacoes..." )
SE5->( dbGoTop() )

SetRegua( SE5->( Lastrec() ) )

nTOTSAIG  := nTOTENTG   := 0
nVLSALDOG := nVLSALFING := 0

cTPFOL := 'FER/RES/GPS/FGT/VL /FOL'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saldo de Partida                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cBanco   := '001'
cAgencia := '31658'
cConta   := '5356-2    '

dbSelectArea( "SE8" )
dbSeek( xFilial() + cBanco + cAgencia + cConta + dtos( MV_PAR01 ), .T. )
dbSkip( -1 )

if E8_BANCO != cBanco .or. E8_AGENCIA != cAgencia .or. E8_CONTA != cConta .or. BOF() .or. EOF()
   nSaldoAtu := 0
   nSaldoIni := 0
else
   nSaldoAtu := Round( NoRound( xMoeda( E8_SALATUA, 1, 1, SE8->E8_DTSALAT, 3 ), 3 ), 2 )
   nSaldoIni := Round( NoRound( xMoeda( E8_SALATUA, 1, 1, SE8->E8_DTSALAT, 3 ), 3 ), 2 )
endif

aDIA := {}

nVLSALBCO := nSaldoIni

nVLSAL4DD := 1

while ! SE5->( eof() )

   if SE5->E5_SITUACA # 'C'.AND. SE5->E5_MOTBX $ 'NOR/DEB'

      dDATA     := SE5->E5_DTDISPO
      nVLENT4DD := nVLENTUNI := nTOTENT   := 0 //Variaveis de Entrada
      nVLSAI4DD := nVLSAICOM := nVLSAIUNI := nVLSAIFOL := nTOTSAI := 0 //Variaveis de Saida
      nVLSALDO  := 0

      while ! SE5->( eof() ) .and. SE5->E5_DTDISPO == dDATA

         if SE5->E5_RECPAG = 'R'
                        
            if SE5->E5_TIPODOC $ "VL/LJ/DB"
               if Empty( SE5->E5_PREFIXO ) .and. SE5->E5_BANCO # cBanco
                  nVLENT4DD := nVLENT4DD + SE5->E5_VALOR
               endif
                        
               if SE5->E5_BANCO = cBanco
                  nVLENTUNI := nVLENTUNI + SE5->E5_VALOR
               endif
               
            /*
            elseif SE5->E5_TIPODOC = 'ES'
               if Empty( SE5->E5_PREFIXO ) .and. SE5->E5_BANCO # cBanco
                  nVLENT4DD := nVLENT4DD - SE5->E5_VALOR
               endif
               if SE5->E5_BANCO = cBanco
                  nVLENTUNI := nVLENTUNI - SE5->E5_VALOR
               endif
            */   
            
            endif
            
            if SE5->E5_MOEDA = "M1" .and. SE5->E5_BANCO = cBanco
               nVLENTUNI := nVLENTUNI + SE5->E5_VALOR            
            endif
            
         elseif SE5->E5_RECPAG = 'P'
            
            if SE5->E5_BANCO = cBanco .and. ( Empty( SE5->E5_TIPODOC ) .or. Empty( SE5->E5_MOTBX ) )
               nVLSAIUNI := nVLSAIUNI + SE5->E5_VALOR
            endif
            
            if SE5->E5_TIPODOC $ "VL/LJ/DB"
              
               if Empty( SE5->E5_PREFIXO ) .AND. SE5->E5_BANCO # cBanco 
                  nVLSAI4DD := nVLSAI4DD + SE5->E5_VALOR
               endif
                       
               if SE5->E5_BANCO = cBanco .and. ! SE5->E5_TIPO $ cTPFOL
                  nVLSAIUNI := nVLSAIUNI + SE5->E5_VALOR
               endif   
               if SE5->E5_PREFIXO = 'COM'
                  nVLSAICOM := nVLSAICOM + SE5->E5_VALOR
               endif
               if SE5->E5_TIPO $ cTPFOL
                  nVLSAIFOL := nVLSAIFOL + SE5->E5_VALOR                  
               endif                
            /*   
            elseif SE5->E5_TIPODOC = 'ES'
               
               if Empty( SE5->E5_PREFIXO ) .and. SE5->E5_BANCO # cBanco
                  nVLSAI4DD := nVLSAI4DD - SE5->E5_VALOR
               endif
               if SE5->E5_BANCO = cBanco                                   
                  nVLSAIUNI := nVLSAIUNI - SE5->E5_VALOR                 
               endif   
               if SE5->E5_PREFIXO = 'COM'
                  nVLSAICOM := nVLSAICOM - SE5->E5_VALOR
               endif   
            */   
            endif
               
         endif
                            
         SE5->( dbskip() )
   
      end

      nTOTENT    := nVLENT4DD + nVLENTUNI
      nTOTSAI    := nVLSAI4DD + nVLSAICOM + nVLSAIUNI + nVLSAIFOL
      nVLSALDO   := nTOTENT - nTOTSAI
      nVLSALBCO  := nVLSALBCO + nVLENTUNI - ( nVLSAIFOL + nVLSAIUNI )
      nTOTENTG   := nTOTENTG + nTOTENT
      nTOTSAIG   := nTOTSAIG + nTOTSAI
      nVLSALDOG  := nVLSALDOG + ( nTOTENT - nTOTSAI )
      nVLSALFING := nVLSALBCO

      aadd( aDIA, { dDATA, nVLENT4DD, nVLENTUNI, nTOTENT, nVLSAI4DD,;
                    nVLSAICOM, nVLSAIUNI, nVLSAIFOL, nTOTSAI, nVLSALDO, nVLSALBCO } )
      
   endif
   
   SE5->( dbskip() )
   
   IncRegua()
   
end

nLIN := cabec( 'RESUMO FINANCEIRO - ANALITICO', '', '', 'FINRES', 'G', 15 )
@ nLIN+01,00 pSay 'De '+ DTOC( MV_PAR01 ) + ' ate ' + DTOC( MV_PAR02 )
@ nLIN+02,00 pSay repl( '*', 220 )
@ nLIN+03,00 pSay '                                                       4DD                                                                                 UNI                                                          SALDO GERAL'
@ nLIN+04,00 pSay 'Data do Movimento   --------------------------------------------------------------------------          ----------------------------------------------------------------------------          ------------------------------'
@ nLIN+05,00 pSay '                         ENTRADAS        TITULOS        COMISSAO    SLD.OPERAC.    DISPONIVEL                ENTRADAS        TITULOS           FOLHA     SLD.OPERAC.      DISPONIVEL             OPERACIONAL      DISPONIVEL'
                 //     00/00/00       99.999.999,99  99.999.999,99  999.999.999,99  99.999.999,99  99.999.999,99          99.999.999,99  99.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99          999.999.999,99  999.999.999,99
  	      		  //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  			        //          1         2         3         4         5         6         7         8         9        10        11        12        13         14       15        16        17        18        19        20        21        22
@ nLIN+06,00 pSay repl( '*', 220 )

nLIN := nLIN + 07

@ nLIN,000 pSay   'SALDO BANCOS  UNI ->         -              -               -            -              -                        -              -                -            -'
@ nLIN,206 pSay nSALDOINI Picture '@E 999,999,999.99'
nLIN += 1
@ nLIN,000 pSay   'CAIXA INICIAL 4DD ->         -              -               -            -              -                        -              -                -            -'
@ nLIN,206 pSay nVLSAL4DD Picture '@E 999,999,999.99'

nLIN += 1

if ! Empty( aDIA )

   AADEDS   := Asort( aDIA,,, { | x, y | x[ 1 ] < y[ 1 ] } )
   nMES     := Month( aADEDS[ 1, 1 ] )

   nENTMES  := nSAIMES := nS1MES := nS2MES := nS34DD := 0
   nTOT4DDE := nTOTUNIE := nTOT4DDS := nTOTCOM := nTOTUNIS := nTOTFOL := 0

   for nCONTI := 1 To Len( aADEDS )

      if nLIN > 55

			nLIN := cabec( 'RESUMO FINANCEIRO - ANALITICO', '', '','FINTRC', 'G', 15 )
			@ nLIN+01,00 pSay 'De '+ DTOC( MV_PAR01 ) + ' ate ' + DTOC( MV_PAR02 )
			@ nLIN+02,00 pSay repl( '*', 220 )
			@ nLIN+03,00 pSay '                                                       4DD                                                                                 UNI                                                          SALDO GERAL'
			@ nLIN+04,00 pSay 'Data do Movimento   --------------------------------------------------------------------------          ----------------------------------------------------------------------------          ------------------------------'
			@ nLIN+05,00 pSay '                         ENTRADAS        TITULOS        COMISSAO  SALDO OPERAC.    DISPONIVEL                ENTRADAS        TITULOS           FOLHA   SALDO OPERAC.      DISPONIVEL             OPERACIONAL      DISPONIVEL'
			                 //     00/00/00       99.999.999,99  99.999.999,99  999.999.999,99  99.999.999,99  99.999.999,99          99.999.999,99  99.999.999,99  999.999.999,99  999.999.999,99  999.999.999,99          999.999.999,99  999.999.999,99
         	      		  //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         			        //          1         2         3         4         5         6         7         8         9        10        11        12        13         14       15        16        17        18        19        20        21        22
			@ nLIN+06,00 pSay repl( '*', 220 )
  
         nLIN := nLIN + 07

      endif   
      
      if nMES # Month( aADEDS[ nCONTI, 01 ] )

         @ nLIN,000 pSay repl( '-', 220 )
         nLIN := nLIN + 1
         @ nLIN,000 pSay 'Totais mes de ' + MesExtenso( nMES )
         @ nLIN,020 pSay nTOT4DDE  Picture '@E 99,999,999.99' 
         @ nLIN,035 pSay nTOT4DDS  Picture '@E 99,999,999.99'
         @ nLIN,050 pSay nTOTCOM   Picture '@E 999,999,999.99'
         @ nLIN,066 pSay nTOTSLOP4 Picture '@E 99,999,999.99'
         @ nLIN,081 pSay PadC( '-', 14 )
         @ nLIN,105 pSay nTOTUNIE  Picture '@E 99,999,999.99'
         @ nLIN,120 pSay nTOTUNIS  Picture '@E 99,999,999.99'
         @ nLIN,134 pSay nTOTFOL   Picture '@E 999,999,999.99'
         @ nLIN,151 pSay nTOTSLOPU Picture '@E 999,999,999.99'
         @ nLIN,167 pSay PadC( '-', 14 )

         nLIN := nLIN + 2


         nMES := Month( aADEDS[ nCONTI, 01 ] )
         nENTMES := nSAIMES := nS1MES := nS2MES := 0

         nLIN := nLIN + 1
      endif

      @ nLIN,005 pSay aADEDS[ nCONTI, 01 ]
      @ nLIN,020 pSay aADEDS[ nCONTI, 02 ] Picture '@E 99,999,999.99'
      @ nLIN,035 pSay aADEDS[ nCONTI, 05 ] Picture '@E 99,999,999.99'
      @ nLIN,050 pSay aADEDS[ nCONTI, 06 ] Picture '@E 999,999,999.99'
      @ nLIN,065 pSay aADEDS[ nCONTI, 02 ] Picture '@E 999,999,999.99'
      @ nLIN,080 pSay aADEDS[ nCONTI, 02 ] Picture '@E 999,999,999.99'                    
      @ nLIN,104 pSay aADEDS[ nCONTI, 03 ] Picture '@E 999,999,999.99'
      @ nLIN,119 pSay aADEDS[ nCONTI, 07 ] Picture '@E 999,999,999.99'
      @ nLIN,134 pSay aADEDS[ nCONTI, 08 ] Picture '@E 999,999,999.99'
      @ nLIN,150 pSay aADEDS[ nCONTI, 03 ] Picture '@E 999,999,999.99'
      @ nLIN,166 pSay aADEDS[ nCONTI, 11 ] Picture '@E 999,999,999.99'    
      @ nLIN,190 pSay aADEDS[ nCONTI, 02 ] Picture '@E 999,999,999.99'
      @ nLIN,206 pSay aADEDS[ nCONTI, 11 ] Picture '@E 999,999,999.99'

      nLIN    := nLIN + 1
      
      if nCONTI = Len( aADEDS )

         @ nLIN,000 pSay repl( '-', 220 )
         nLIN := nLIN + 1
         @ nLIN,000 pSay 'Totais mes de ' + MesExtenso( nMES )
         @ nLIN,020 pSay nTOT4DDE Picture '@E 99,999,999.99'
         @ nLIN,035 pSay nTOTUNIE Picture '@E 99,999,999.99'
         @ nLIN,050 pSay nENTMES  Picture '@E 999,999,999.99'
         @ nLIN,066 pSay nTOT4DDS Picture '@E 99,999,999.99'
         @ nLIN,081 pSay nTOTCOM  Picture '@E 99,999,999.99'
         @ nLIN,105 pSay nTOTUNIS Picture '@E 99,999,999.99'
         @ nLIN,120 pSay nTOTFOL  Picture '@E 99,999,999.99'
         @ nLIN,134 pSay nSAIMES  Picture '@E 999,999,999.99'
         @ nLIN,150 pSay nS1MES   Picture '@E 999,999,999.99'
         @ nLIN,166 pSay PadC( '-', 14 )

         nLIN := nLIN + 2

         nMES := Month( aADEDS[ nCONTI, 01 ] )
         nENTMES := nSAIMES := nS1MES := nS2MES := 0
         
      endif

   next
   
end   

Roda( 0, "", "G" )  

if aReturn[5] == 1

   set printer to
   commit
   ourspool( cNomRel ) //Chamada do Spool de Impressao

endif

MS_FLUSH() //Libera fila de relatorios em spool

retindex( "SE5" )
return
