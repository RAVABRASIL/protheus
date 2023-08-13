#INCLUDE "protheus.ch" 
#INCLUDE "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF  
       
User Function FATR05()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
// +---------------------------------------------------------------------+
// | Declaracao de variaveis utilizadas no programa atraves da funcao    |
// | SetPrvt, que criara somente as variaveis definidas pelo usuario,    |
// | identificando as variaveis publicas do sistema utilizadas no codigo |
// | Incluido pelo assistente de conversao do AP5 IDE                    |
// +---------------------------------------------------------------------+
SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN")
SetPrvt("WNREL,M_PAG,CSTRING,CLINHA1,CLINHA2,CLINHA3")
SetPrvt("CLINHA4,X,NTOTLIN,NTOTX,aOp,cTit,cMsg,nOp")
 
//+------------------------------------------------------+------+-----------+ 
//|  Autor  | Silvano da Silva Araujo                    | Data | 13/12/99  | 
//+------------------------------------------------------+------+-----------+ 
//|Descricao| Imprimir etiquetas clientes/empresas/Vendedores/Produtos      | 
//+-------------------------------------------------------------------------+ 
//| Usuario | Faturamento                                                   | 
//+-------------------------------------------------------------------------+ 
 


//----------------------------------------------------------------
//| Define Variaveis Ambientais                                  |
//----------------------------------------------------------------

//+----------------------------------------------------------------------------------+
//| Variaveis utilizadas para parametros                                             |
//| mv_par01 // Etiqueta 1-Empresa,2-Clientes,3-Vendedores,4-Produtos,5-Fornecedores |
//| mv_par02 // Quantidade de etiquetas                                              |
//| mv_par03 // De Cliente/Vendedor/Produto/Fornecedor                               |
//| mv_par04 // Ate Cliente/Vendedor/Produto/Fornecedor                              |
//| mv_par05 // Numero de colunas da etiqueta                                        |
//| mv_par06 // Imprime Contato(1-Sim  2-Não)                                        |
//+----------------------------------------------------------------------------------+

CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
tamanho   := "p"
limite    := 254
titulo    := PADC("Impressao de Etiquetas",74)
cDesc1    := PADC("Este programa ira emitir as etiquetas de clientes/",74)
cDesc2    := PADC("empresa/Vendedor/produtos/Fornec.em formulario de uma faixa de etiquetas",74)
cDesc3    := ""
aReturn   := { "Financeiro", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATR05"
cPerg     := "FATR05"
nLastKey  := 0
lContinua := .T.
nLin      := 5
wnrel     := "FATR05"
M_PAG     := 1

//+-------------------------------------------------------------------------+
//| Verifica as perguntas selecionadas, busca o padrao da Nfiscal           |
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

if MV_PAR01 = 2 .OR. MV_PAR01 = 4
   cString := "SA1"
elseif MV_PAR01 = 3
   cString := "SA3"
elseif MV_PAR01 = 5
   cString := "SA2"
else
   cString := "SA1"
endif

//+--------------------------------------------------------------+
//| Envia controle para a funcao SETPRINT                        |
//+--------------------------------------------------------------+

wnrel := SetPrint( cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .T. )

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//| Verifica Posicao do Formulario na Impressora                 |
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//| Inicio do Processamento do Relatorio                         |
//+--------------------------------------------------------------+

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
   Static Function RptDetail()
#ENDIF

//+--------------------------------------------------------------+
//| Inicializa  de variaveis                                     |
//+--------------------------------------------------------------+

nTotLin := mv_par02 / mv_par05
nTotx   := Int( nTotLin ) + Iif( nTotLin - Int( nTotLin ) == 0,0,1 ) 

// @ nLIN  ,000 psay CHR( 27 ) + CHR( 15 )
// @ nLIN ++ ,000 psay ""
//  @ nLIN ++ ,000 psay ""

  
                     
if mv_par01 == 1  // impressao de etiquetas para empresa

   SetRegua( mv_par02 / mv_par05 )
   cLinha1 := cLinha2 := cLinha3 := clinha4 := ""
   For x := 1 to mv_par05
       if mv_par05 == 1
          cLinha1 := cLinha1 + SM0->M0_NOMECOM
          cLinha2 := cLinha2 + SM0->M0_ENDCOB + SM0->M0_COMPENT
          cLinha3 := cLinha3 + " "
          cLinha4 := cLinha4 + "CEP: " + trans( SM0->M0_CEPCOB, "@R 99999-999" ) + "  " + SM0->M0_CIDCOB + "-" + SM0->M0_ESTCOB

       else
          cLinha1 := cLinha1 + Substr( SM0->M0_NOMECOM,1,34)+Space(01)
          cLinha2 := cLinha2 + SM0->M0_ENDCOB+Space(04)+Space(01)
                  cLinha3 := cLinha3 + " "
          cLinha4 := cLinha4 + "CEP: " + trans( SM0->M0_CEPCOB, "@R 99999-999" ) + "  " + SM0->M0_CIDCOB + Space( 14 ) + Space(01) + "-" + SM0->M0_ESTCOB + space( 17 )+Space(01)

       endif
   Next

   For x := 1 to nTotLin

       #IFNDEF WINDOWS
         IF LastKey()==286
            @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
            lContinua := .F.
            Exit
         Endif
       #ELSE
         IF lAbortPrint
            @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
            lContinua := .F.
            Exit
         Endif
       #ENDIF

       IF lAbortPrint
          @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
          lContinua := .F.
          Exit
       Endif

       @ prow()    ,000 Psay cLinha1
       @ prow() + 1,000 Psay cLinha2
       @ prow() + 1,000 Psay cLinha3
       @ prow() + 1,000 Psay cLinha4
       @ prow() + 3,000 Psay " "
       IncRegua()
   Next

elseIf mv_par01 == 2 // impressao de etiquetas para clientes geral
  
   SetRegua( SA1->( Lastrec()/mv_par05 ) )
   SA1->( DbSetOrder( 1 ) )
   SA1->( dbSeek( xFilial( "SA1" ) + Alltrim( mv_par03 ), .t. ) )

   While SA1->( !Eof() ) .and. SA1->A1_cod <= mv_par04
      If SA1->A1_IMPETQ != "S" 
         SA1->( DbSkip() )
         Loop
      EndIf
                                    
      cLinha0 := cLinha1 := cLinha2 := cLinha3 := clinha4 := ""
      For x := 1 to mv_par05
          if mv_par05 == 1
             cLinha0 :=  SA1->A1_NOME  
             cLinha1 :=  SA1->A1_CONETQ 
             cLinha2 :=  SA1->A1_END
             cLinha3 :=  SA1->A1_BAIRRO+"-"+ LEFT(SA1->A1_TEL,15)
             cLinha4 :=  "CEP: " + transform( SA1->A1_CEP, "@R 99999-999" ) + "  " + SA1->A1_MUN + "-" + SA1->A1_EST 
          endif
      Next

   	For x := 1 to nTotLin

   	    #IFNDEF WINDOWS
   	      IF LastKey()==286
   	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	         lContinua := .F.
   	         Exit
   	      Endif
   	    #ELSE
   	      IF lAbortPrint
   	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	         lContinua := .F.
   	         Exit
   	      Endif
   	    #ENDIF

   	    IF lAbortPrint
   	       @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	       lContinua := .F.
   	       Exit
   	    Endif                                         
              if mv_par06 == 1    
                      @ nLin++,0 Psay " " + cLinha0                   				// Linha 1
                      if(empty(SA1->A1_CONETQ ))
                      @ nLin++,0 Psay " " + cLinha2  		         				// Linha 2  
   	          		  @ nLin++,0 Psay " " + cLinha3  		         				// Linha 3  
   	              	  @ nLin++,0 Psay " " + cLinha4                   				// Linha 4
   	              	  @ nLin++,0 Psay " "       //( Vazio )                         // Linha 5 
   	              	  else
   	              	  @ nLin++,0 Psay " " + cLinha1  		         				// Linha 2  
                      @ nLin++,0 Psay " " + cLinha2  		         				// Linha 3  
   	          		  @ nLin++,0 Psay " " + cLinha3  		         				// Linha 4  
   	              	  @ nLin++,0 Psay " " + cLinha4                   				// Linha 5 
   	              	  endif  
   	              	  @ nLin++,0 Psay " "              					            // Divisor
   	              	    
              else
                  	  @ nLin++,0 Psay " " + cLinha0                   				// Linha 1  
   	     		  	  @ nLin++,0 Psay " " + cLinha2 		  		     			// Linha 2  
   	     		  	  @ nLin++,0 Psay " " + cLinha3 			         			// Linha 3  
   	     		  	  @ nLin++,0 Psay " " + cLinha4 				     			// Linha 4  
   	     		  	  @ nLin++,0 Psay " "       //( Vazio )                         // Linha 5  
   	     		  	  @ nLin++,0 Psay " "                                           // Divisor  
   	          endif 
   	    IncRegua() 
   	Next                               
        SA1->( dbSkip() )
        IncRegua()
   end
  If aReturn[5] == 1
     Set Printer To
     Commit
     ourspool(wnrel) //Chamada do Spool de Impressao
  Endif
  MS_FLUSH()   // Libera fila de relatorios em spool

  aOp  := { 'Sim', 'Nao' }
  cTit := ''
  cMsg := 'Etiquetas foram impressas corretamente?'
  nOp  := Aviso( cTit, cMsg, aOp )
  If nOp == 1 // Sim
     SA1->( DbGotop() )
     While SA1->( !Eof() )
       If SA1->A1_IMPETQ # 'N'
          RecLock( "SA1", .F. )
          SA1->A1_IMPETQ := 'N'
          SA1->A1_CONETQ := ''
          SA1->( MsUnlock() )
       EndIf
       SA1->( DbSkip() )
     EndDo
     SA1->( dbCommit() )
  Endif
elseIf mv_par01 == 5 // impressao de etiquetas para fornecedores geral //impressao de fornecedor

   SetRegua( SA2->( Lastrec()/mv_par05 ) )
   SA2->( DbSetOrder( 1 ) )
   SA2->( dbSeek( xFilial( "SA2" ) + Alltrim( mv_par03 ), .T. ) )

   While SA2->( !Eof() ) .and. SA2->A2_cod <= mv_par04
      If SA2->A2_IMPETQ == "N" .OR.SA2->A2_IMPETQ == " "
         SA2->( DbSkip() )
         Loop
      EndIf

      cLinha1 := cLinha2 := cLinha3 := clinha4 := ""
      For x := 1 to mv_par05
          if mv_par05 == 1
             cLinha1 := cLinha1 + SA2->A2_NOME
             cLinha2 := cLinha2 + SA2->A2_END
             cLinha3 := cLinha3 + SA2->A2_BAIRRO
             cLinha4 := cLinha4 + "CEP: " + trans( SA2->A2_CEP, "@R 99999-999" ) + "  " + SA2->A2_MUN + "-" + SA2->A2_EST
          else
             cLinha1 := cLinha1 + Substr( SA2->A2_NOME,1,34)+Space(01)
             cLinha2 := cLinha2 + Substr( SA2->A2_END,1,34)+Space(01)
             cLinha3 := cLinha3 + Substr(SA2->A2_BAIRRO,1,18)
             cLinha4 := cLinha4 + "CEP: " + trans( SA2->A2_CEP, "@R 99999-999" ) + "  " + SA2->A2_MUN+Space(01) + "-" + SA2->A2_EST + Space(17)
          endif
      Next

   	For x := 1 to nTotLin
                               
   	    #IFNDEF WINDOWS
   	      IF LastKey()==286
   	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	         lContinua := .F.
   	         Exit
   	      Endif
   	    #ELSE
   	      IF lAbortPrint
   	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	         lContinua := .F.
   	         Exit
   	      Endif
   	    #ENDIF

   	    IF lAbortPrint
   	       @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	       lContinua := .F.
   	       Exit
   	    Endif

   	    @ prow()    ,000 Psay cLinha1
   	    @ prow() + 1,000 Psay cLinha2
   	    @ prow() + 1,000 Psay cLinha3
   	    @ prow() + 1,000 Psay cLinha4
   	    @ prow() + 3,000 Psay " "
   	    IncRegua()
   	Next
        SA2->( dbSkip() )
        IncRegua()
  end
  If aReturn[5] == 1
     Set Printer To
     Commit
     ourspool(wnrel) //Chamada do Spool de Impressao
  Endif
  MS_FLUSH()   // Libera fila de relatorios em spool

  aOp  := { 'Sim', 'Nao' }
  cTit := ''
  cMsg := 'Etiquetas foram impressas corretamente?'
  nOp  := Aviso( cTit, cMsg, aOp )
  If nOp == 1 // Sim
     SA2->( DbGotop() )
     While SA2->( !Eof() )
       If SA2->A2_IMPETQ # 'N'
          RecLock( "SA2", .F. )
          SA2->A2_IMPETQ := 'N'
          SA2->( MsUnlock() )
       EndIf
       SA2->( DbSkip() )
     EndDo
     SA2->( dbCommit() )
  Endif

elseIf mv_par01 == 3 // impressao de etiquetas para Vendedores

   SetRegua( SA3->( Lastrec() / mv_par05 ) )
   SA3->( DbSetOrder( 1 ) )
   SA3->( dbSeek( xFilial( "SA3" ) + Alltrim( mv_par03 ), .t. ) )

   While SA3->( !Eof() ) .and. SA3->A3_COD <= AllTrim( mv_par04 )
      If SA3->A3_IMPETQ == "N" .OR. SA3->A3_IMPETQ == " "
         SA3->( DbSkip() )
         Loop
      EndIf

      cLinha1 := cLinha2 := cLinha3 := clinha4 := ""
      For x := 1 to mv_par05
          if mv_par05 == 1
             cLinha1 := cLinha1 + SA3->A3_NOME
             cLinha2 := cLinha2 + SA3->A3_END
             cLinha3 := cLinha3 + SA3->A3_BAIRRO + "  " + LEFT(SA3->A3_TEL,15)
             cLinha4 := cLinha4 + "CEP: " + trans( SA3->A3_CEP, "@R 99999-999" ) + "  " + SA3->A3_MUN  + "-" +  SA3->A3_EST +SPACE(02)

          else
             cLinha1 := cLinha1 + Substr( SA3->A3_NOME,1,34)+Space(01)
             cLinha2 := cLinha2 + Substr( SA3->A3_END,1,34) +Space(01)
             cLinha3 := cLinha3 + Substr( SA3->A3_BAIRRO,1,18) + "  " + LEFT(SA3->A3_TEL,15)
             cLinha4 := cLinha4 + "CEP: " + trans( SA3->A3_CEP, "@R 99999-999" ) + "  " + SA3->A3_MUN+Space(01) + "-" + SA3->A3_EST +SPACE(02)

          endif
      Next

   	For x := 1 to nTotLin

   	    #IFNDEF WINDOWS
   	      IF LastKey()==286
   	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	         lContinua := .F.
   	         Exit
   	      Endif
   	    #ELSE
   	      IF lAbortPrint
   	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	         lContinua := .F.
   	         Exit
   	      Endif
   	    #ENDIF

   	    IF lAbortPrint
   	       @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
   	       lContinua := .F.
   	       Exit
   	    Endif

   	    @ prow()    ,000 Psay cLinha1
   	    @ prow() + 1,000 Psay cLinha2
   	    @ prow() + 1,000 Psay cLinha3
   	    @ prow() + 1,000 Psay cLinha4
   	    @ prow() + 3,000 Psay " "
   	    IncRegua()
   	Next
        SA3->( dbSkip() )
        IncRegua()
   end
  If aReturn[5] == 1
     Set Printer To
     Commit
     ourspool(wnrel) //Chamada do Spool de Impressao
  Endif
  MS_FLUSH()   // Libera fila de relatorios em spool

  aOp  := { 'Sim', 'Nao' }
  cTit := ''
  cMsg := 'Etiquetas foram impressas corretamente?'
  nOp  := Aviso( cTit, cMsg, aOp )
  If nOp == 1 // Sim
     SA3->( DbGotop() )
     While SA3->( !Eof() )
       If SA3->A3_IMPETQ # 'N'
          RecLock( "SA3", .F. )
          SA3->A3_IMPETQ := 'N'
          SA3->( MsUnlock() )
       EndIf
       SA3->( DbSkip() )
     EndDo
     SA3->( dbCommit() )
  Endif

endif

//+--------------------------------------------------------------+
//| Fim do Programa                                              |
//+--------------------------------------------------------------+

Return             




