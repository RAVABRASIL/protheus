#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function atupes()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NPESO,CCOR,NCOMPR,NLARG,NESPESS,NBOBLARG")
SetPrvt("CEMB1,CEMB2,NQE1,NQE2,CSANLAM,CSANLAM2")
SetPrvt("CTRATAM,CSOLDFL,CSLIT,CPTONEVE,CSANFFL,CMATRIZ")
SetPrvt("CMAQ,CLARGFIL,NDENSIDADE,NPOSSB5,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³B5_DENSIDA                                       ³ 24/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizar peso no SB1,SG1 a partir do SB5                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
If SB1->( dbSeek( xFilial( "SB1" ) + M->B5_COD, .T. ) ) .and. SB1->B1_TIPO $ "PA*ME"
   //If SB1->B1_TIPO == "PA"
      If RecLock( "SB1", .F. )
         If SB1->B1_UM == 'MR'
            SB1->B1_PESO := M->B5_DENSIDA * M->B5_LARG * M->B5_COMPR * M->B5_ESPESS
            SB1->B1_CONV := 1 / ( M->B5_DENSIDA * M->B5_LARG * M->B5_COMPR * M->B5_ESPESS)
         Else
            SB1->B1_PESO := ( M->B5_DENSIDA * M->B5_LARG * M->B5_COMPR * M->B5_ESPESS / 1000 ) * M->B5_QE2
            SB1->B1_CONV := 1 / ( ( M->B5_DENSIDA * M->B5_LARG * M->B5_COMPR * M->B5_ESPESS / 1000 ) * M->B5_QE2 )
         Endif

         SB1->( DbUnlock() )
         SB1->( DbCommit() )
         nPESO    := SB1->B1_PESO
         cCOR       := M->B5_COR
         nCOMPR   := M->B5_COMPR
         nLARG    := M->B5_LARG
         nESPESS  := M->B5_ESPESS
         //nBOBLARG := M->B5_BOBLARG
         //cEMB1    := M->B5_EMB1
         //cEMB2    := M->B5_EMB2
         //nQE1     := M->B5_QE1
         //nQE2     := M->B5_QE2
         //cSANLAM  := M->B5_SANLAM
         //cSANLAM2 := M->B5_SANLAM2
         //cTRATAM  := M->B5_TRATAM
         //cSOLDFL  := M->B5_SOLDFL
         //cSLIT    := M->B5_SLIT
         //cPTONEVE := M->B5_PTONEVE
         //cSANFFL  := M->B5_SANFFL
         //cMATRIZ  := M->B5_MATRIZ
         //cMAQ     := M->B5_MAQ
         //cLARGFIL := M->B5_LARGFIL

      Endif
      nDENSIDADE :=  M->B5_DENSIDA
      SG1->( DbSetOrder( 1 ) )
      If SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )
         nPosSB5 := SB5->( Recno() )    //guardar a posicao no SB5
         Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1->B1_COD
//            If Subs(SG1->G1_COMP,1,2) == 'PI'  //*** Adenildo ***
              If Subs(SG1->G1_COMP,1,2) == 'PI'  .AND. (EMPTY(SG1->G1_TRT) .OR. alltrim(SG1->G1_TRT)='001')  // SO FAZER NA 1 REVISAO 
               If RecLock( "SG1", .F. )
                  SG1->G1_QUANT := nPESO      //SB1->B1_PESO
                  SG1->( DbUnlock() )
                  If SB5->( dbSeek( xFilial( "SB5" ) + SG1->G1_COMP ) )
                     If RecLock( "SB5", .F. )
                        SB5->B5_DENSIDA := nDENSIDADE
                        SB5->B5_COR     := cCOR
                        SB5->B5_COMPR   := nCOMPR
                        SB5->B5_LARG    := nLARG
                        SB5->B5_ESPESS  := nESPESS
                        //SB5->B5_BOBLARG := nBOBLARG
                        //SB5->B5_EMB1    := cEMB1
                        //SB5->B5_EMB2    := cEMB2
                        //SB5->B5_QE1     := nQE1
                        //SB5->B5_QE2     := nQE2
                        //SB5->B5_SANLAM  := cSANLAM
                        //SB5->B5_SANLAM2 := cSANLAM2
                        //SB5->B5_TRATAM  := cTRATAM
                        //SB5->B5_SOLDFL  := cSOLDFL
                        //SB5->B5_SLIT    := cSLIT
                        //SB5->B5_PTONEVE := cPTONEVE
                        //SB5->B5_SANFFL  := cSANFFL
                        //SB5->B5_MATRIZ  := cMATRIZ
                        //SB5->B5_MAQ     := cMAQ
                        //SB5->B5_LARGFIL := cLARGFIL
                        //SB5->( DbUnlock() )
                        //SB5->( DbCommit() )
                     Else
                        Aviso("M E N S A G E M","Codigo -> "+SB5->B5_COD+" - Registro Bloqueado", {"OK"})
                        Loop
                     Endif
                  Else
                     Aviso("M E N S A G E M","Codigo -> "+SG1->G1_COMP+" - Complemento de Produto Nao Encontrado", {"OK"})
                  Endif
               EndIf
            Endif
            SG1->( DbSkip() )
         EndDo
         SB5->( DBGoTo(nPosSB5) )    //Retornar a posicao no SB5
      Else
         Aviso("M E N S A G E M","Codigo -> "+SB1->B1_COD+" - Produto Nao Possui Estrutura", {"OK"})
      Endif

   /*
   ElseIf SB1->B1_TIPO == "ME"
      nCOMPR   := M->B5_COMPR
      nLARG    := M->B5_LARG
      nESPESS  := M->B5_ESPESS
      nBOBLARG := M->B5_BOBLARG
      cEMB1    := M->B5_EMB1
      cEMB2    := M->B5_EMB2
      nQE1     := M->B5_QE1
      nQE2     := M->B5_QE2
      nDENSIDADE :=  M->B5_DENSIDA
      SG1->( DbSetOrder( 1 ) )
      If SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )
         nPosSB5 := SB5->( Recno() )    //guardar a posicao no SB5
         Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1->B1_COD
            If Subs(SG1->G1_COMP,1,2) == 'PI'
               If SB5->( dbSeek( xFilial( "SB5" ) + SG1->G1_COMP ) )
                  If RecLock( "SB5", .F. )
                     SB5->B5_DENSIDA := nDENSIDADE
                     SB5->B5_COMPR   := nCOMPR
                     SB5->B5_LARG    := nLARG
                     SB5->B5_ESPESS  := nESPESS
                     SB5->B5_BOBLARG := nBOBLARG
                     SB5->B5_EMB1    := cEMB1
                     SB5->B5_EMB2    := cEMB2
                     SB5->B5_QE1     := nQE1
                     SB5->B5_QE2     := nQE2
                     SB5->( DbUnlock() )
                     SB5->( DbCommit() )
                  Else
                     Aviso("M E N S A G E M","Codigo -> "+SB5->B5_COD+" - Registro Bloqueado", {"OK"})
                     Loop
                  Endif
               Else
                  Aviso("M E N S A G E M","Codigo -> "+SG1->G1_COMP+" - Complemento de Produto Nao Encontrado", {"OK"})
               Endif
            EndIf
            SG1->( DbSkip() )
         Enddo
         SB5->( DBGoTo(nPosSB5) )    //Retornar a posicao no SB5
      Else
         Aviso("M E N S A G E M","Codigo -> "+SB1->B1_COD+" - Produto Nao Possui Estrutura", {"OK"})
      Endif

   EndIf
   */

EndIf
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return( .T. )
Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
