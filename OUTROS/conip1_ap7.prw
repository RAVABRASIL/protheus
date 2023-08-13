 #include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function conip1()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,NREGTOT,NSALDO,NSALTIT,")

/*
        Esta rotina devera ser executada antes da realizacao de movimentacoes
        do ano seguinte.

*/


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Adenildo Macedo de Almeida               ³ Data ³ 03/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Implant. Saldo de contas p/ client/forneced na empresa 01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Rava                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

@ 00,000 To 50,200 Dialog oDlg1 Title "Implantacao de Saldo de Contas"
@ 10,020 BMPBUTTON Type 1 Action OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,020 BMPBUTTON Type 1 Action Execute(OkProc)
@ 10,060 BMPBUTTON Type 2 Action Close( oDlg1 )
Activate Dialog oDlg1 Center
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
cALIASANT := Alias()
Close( oDlg1 )

If SM0->M0_CODIGO=="01"
   Processa( {|| Con_Sal() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Processa( {|| Execute(Con_Sal) } )
Else
   Aviso("M E N S A G E M", "Entre na Empresa 01 - RAVA", {"OK"})
Endif

Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Con_Sal
Static Function Con_Sal()

SA1->( Dbsetorder( 1 ) )           // Cadastro de Clientes
SA2->( Dbsetorder( 1 ) )           // Cadastro de Fornecedores
SE2->( Dbsetorder( 6 ) )           // Contas a Pagar
//SE5->( Dbsetorder( 7 ) )           // Movimentacao Bancaria
SI1->( Dbsetorder( 1 ) )           // Plano de Contas

USE \DADOSTES\SE1020  ALIAS SE12  NEW SHARED        //Contas a Receber da Empresa 02
SE12->( DBSETORDER(2) )
//USE F:\DADOSTES\SE5020  ALIAS SE52  NEW SHARED        //Movimentacao Bancaria da Empresa 02
//SE52->( DBSETORDER(7) )

//PROCESSANDO CADASTRO DE CLIENTES
nREGTOT := SA1->( LastRec() )

SA1->( DbGotop() )

ProcRegua(nREGTOT)
@ 12,115 Say "-> Implantando Sld Conta de Clientes" Size 200

Do While ! SA1->( Eof() ) .And. SA1->A1_FILIAL==xFilial("SA1")
   If SA1->A1_CONTA #Space(20)
      If SI1->( DbSeek( xfilial("SI1") + SA1->A1_CONTA ) )

         If SE12->( DbSeek( "01" + SA1->A1_COD + SA1->A1_LOJA , .T. ) )
            nSALDO := 0
            While SE12->E1_FILIAL == "01" .And. SE12->E1_CLIENTE == SA1->A1_COD ;
               .And. SE12->E1_LOJA == SA1->A1_LOJA
               If SE12->E1_SALDO > 0 .And. SE12->E1_PREFIXO == "UNI"  .And.;
                  SE12->E1_EMIS1 <= CTOD("31/12/00")
                  nSALDO := nSALDO + SE12->E1_SALDO
               Endif
               SE12->( DBSkip() )
            Enddo
            //Aviso("M E N S A G E M", Left(SA1->A1_NOME,15) + " -> " + Str(nSALDO,10), {"OK"})
         Endif

         If RecLock( "SI1", .F. )
            SI1->I1_SALANT := 0
            SI1->I1_DEBM01 := 0
            SI1->I1_CRDM01 := 0
            SI1->I1_DEBM02 := 0
            SI1->I1_CRDM02 := 0
            SI1->I1_DEBM03 := 0
            SI1->I1_CRDM03 := 0
            SI1->I1_DEBM04 := 0
            SI1->I1_CRDM04 := 0
            SI1->I1_DEBM05 := 0
            SI1->I1_CRDM05 := 0
            SI1->I1_DEBM06 := 0
            SI1->I1_CRDM06 := 0
            SI1->I1_DEBM07 := 0
            SI1->I1_CRDM07 := 0
            SI1->I1_DEBM08 := 0
            SI1->I1_CRDM08 := 0
            SI1->I1_DEBM09 := 0
            SI1->I1_CRDM09 := 0
            SI1->I1_DEBM10 := 0
            SI1->I1_CRDM10 := 0
            SI1->I1_DEBM11 := 0
            SI1->I1_CRDM11 := 0
            If SA1->A1_SALDUP == 0
                SI1->I1_DEBM12 := 0
                SI1->I1_CRDM12 := 0
            Else
               If SA1->A1_SALDUP > 0
                  SI1->I1_DEBM12 := nSALDO
                  SI1->I1_CRDM12 := 0
               Else
                SI1->I1_DEBM12 := 0
                SI1->I1_CRDM12 := nSALDO * (-1)
               Endif
            Endif
            SI1->( Dbunlock() )
         EndIf

      Endif
   EndIf
   SA1->( DbSkip() )
   IncProc()
EndDo

//PROCESSANDO CADASTRO DE FORNECEDORES
nREGTOT := SA2->( LastRec() )

SA2->( DbGotop() )

ProcRegua(nREGTOT)
@ 12,115 Say "-> Implant. Sld Conta de Fornecedores" Size 200

Do While ! SA2->( Eof() ) .And. SA2->A2_FILIAL==xFilial("SA2")
   If SA2->A2_CONTA #Space(20)
      If SI1->( DbSeek( xfilial("SI1") + SA2->A2_CONTA ) )

         If SE2->( DbSeek( xFilial("SE2") + SA2->A2_COD + SA2->A2_LOJA , .T. ) )
            nSALDO := 0
            While SE2->E2_FILIAL == xFilial("SE2") .And. SE2->E2_FORNECE == SA2->A2_COD ;
               .And.  SE2->E2_LOJA == SA2->A2_LOJA
               If SE2->E2_SALDO > 0 .And. SE2->E2_EMIS1 <= CTOD("31/12/00")     // .And. SE2->E2_PREFIXO == "UNI"
                  nSALDO := nSALDO + SE2->E2_SALDO
               Endif
               SE2->( DBSkip() )
            Enddo
            //Aviso("M E N S A G E M", Left(SA2->A2_NOME,15) + " -> " + Str(nSALDO,10), {"OK"})
         Endif

         If RecLock( "SI1", .F. )
            SI1->I1_SALANT := 0
            SI1->I1_DEBM01 := 0
            SI1->I1_CRDM01 := 0
            SI1->I1_DEBM02 := 0
            SI1->I1_CRDM02 := 0
            SI1->I1_DEBM03 := 0
            SI1->I1_CRDM03 := 0
            SI1->I1_DEBM04 := 0
            SI1->I1_CRDM04 := 0
            SI1->I1_DEBM05 := 0
            SI1->I1_CRDM05 := 0
            SI1->I1_DEBM06 := 0
            SI1->I1_CRDM06 := 0
            SI1->I1_DEBM07 := 0
            SI1->I1_CRDM07 := 0
            SI1->I1_DEBM08 := 0
            SI1->I1_CRDM08 := 0
            SI1->I1_DEBM09 := 0
            SI1->I1_CRDM09 := 0
            SI1->I1_DEBM10 := 0
            SI1->I1_CRDM10 := 0
            SI1->I1_DEBM11 := 0
            SI1->I1_CRDM11 := 0
            If SA2->A2_SALDUP == 0
                SI1->I1_DEBM12 := 0
                SI1->I1_CRDM12 := 0
            Else
               If SA2->A2_SALDUP > 0
                  SI1->I1_DEBM12 := 0
                  SI1->I1_CRDM12 := nSALDO
               Else
                SI1->I1_DEBM12 := nSALDO * (-1)
                SI1->I1_CRDM12 := 0
               Endif
            Endif
            SI1->( Dbunlock() )
         EndIf
      Endif

   EndIf
   SA2->( DbSkip() )
   IncProc()
EndDo


Commit
RetIndex( 'SA1' )
RetIndex( 'SA2' )
RetIndex( 'SE2' )
//RetIndex( 'SE5' )
RetIndex( 'SI1' )
DBSelectArea("SE12")
DBCloseArea("SE12")
//DBSelectArea("SE52")
//DBCloseArea("SE52")
DbSelectArea( cALIASANT )
Return



/*
         If SE12->( DbSeek( "01" + SA1->A1_COD + SA1->A1_LOJA , .T. ) )
            nSALDO := 0

            While SE12->E1_FILIAL == "01" .And. SE12->E1_CLIENTE == SA1->A1_COD ;
               .And.  SE12->E1_LOJA == SA1->A1_LOJA
               //If SE12->E1_PREFIXO == "UNI" .And. SE12->E1_SALDO > 0
               If SE12->E1_PREFIXO == "UNI"
                  nSALTIT := SE12->E1_VALOR
                  If SE52->( DbSeek( "01" + SE12->E1_PREFIXO + SE12->E1_NUM + ;
                     SE12->E1_PARCELA + SE12->E1_TIPO + SE12->E1_CLIENTE + SE12->E1_LOJA , .T. ) )

                     Aviso("M E N S A G E M - Antes", Left(SA1->A1_NOME,15) + " -> " + Transf(nSALTIT,"@R 999,999.99") , {"OK"})
                     
                     While SE52->E5_FILIAL == "01" .And. SE52->E5_PREFIXO == SE12->E1_PREFIXO ;
                        .And. SE52->E5_NUMERO == SE12->E1_NUM .And. SE52->E5_PARCELA == SE12->E1_PARCELA ;
                        .And. SE52->E5_TIPO == SE12->E1_TIPO .And. SE52->E5_CLIFOR == SE12->E1_CLIENTE ;
                        .And. SE52->E5_LOJA == SE12->E1_LOJA
                        //If ( SE52->E5_RECPAG =="R",nSALTIT :=nSALTIT - SE52->E5_VALOR, ;
                        //    nSALTIT :=nSALTIT + SE52->E5_VALOR )
                        If SE52->E5_RECPAG =="R"
                           nSALTIT :=nSALTIT - SE52->E5_VALOR
                        Else
                           nSALTIT :=nSALTIT + SE52->E5_VALOR
                        Endif

                            Aviso("M E N S A G E M - Titulo", Left(SA1->A1_NOME,15) + " - " + ;
                            SE52->E5_NUMERO + " - " + SE52->E5_RECPAG + " -> " + ;
                            Transf(nSALTIT,"@R 999,999.99"), {"OK"})
                        SE52->( DBSkip() )
                     Enddo
                     Aviso("M E N S A G E M - Depois", Left(SA1->A1_NOME,15) + " -> " + Transf(nSALTIT,"@R 999,999.99") , {"OK"})
                     
                  Endif

                  nSALDO := nSALDO + nSALTIT
               Endif
               SE12->( DBSkip() )
            Enddo
            //Aviso("M E N S A G E M", Left(SA1->A1_NOME,15) + " -> " + Transf(nSALDO,"@R 999,999.99") , {"OK"})
            

         Endif

*/
