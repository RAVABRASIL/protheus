#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
//  _______________________________________________________________________
// /Programa  |  COMR001 |                            | Data |  05/01/09   \
// |__________|__________|____________________________|______|_____________|
// |Descricao | LeadTime Compras                                           |
// |__________|____________________________________________________________|
// |Autor     | Rubem Duarte Oliota                                        |
// |__________|____________________________________________________________|
// |Uso       | Alexandre                                                  |
// \__________|____________________________________________________________/

*************
USER FUNCTION COMR001()
*************

//+---------------------------------------------------------------------+
//| Declaracao de Variaveis                                             |
//+---------------------------------------------------------------------+

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Lead Time Compras"
Local nLin           := 132
Local Cabec1         :=" "
Local Cabec2         :=" "


Local   imprime      := .T.
Local   aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "COMR001"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMR001"
Private cString      := ""
Private cPerg        := "COM001"
//dbSelectArea("SA1")
//dbSetOrder(1)
Pergunte(cPerg,.F.)


//+---------------------------------------------------------------------+
//| Monta a interface padrao com o usuario...                           |
//+---------------------------------------------------------------------+

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)


  if mv_par03 = 1
 Cabec1         := "Fornecedor"
 Cabec2         := "Solicitação   Solicitante     Dt.Solicitação    Dt.pedido   SOLxPCOMP   Nª Nota   Dt.Digitação   PCxNF   UF     Dt.Aprov   LeadTime "
 
  else

 Cabec1         := "Estado " 
 Cabec2         :="Solicitação   Solicitante      Dt.Solicitação    Dt.pedido   SOLxPCOMP   Nª Nota   Dt.Digitação   PCxNF   Fornecedor                                     Dt.Aprov   LeadTime "

endif

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

// _____________________________________________________________________
//| Processamento. RPTSTATUS monta janela com a regua de processamento. |
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

// _______________________________________________________________________
//|Funçao    |RUNREPORT | Autor | AP6 IDE            | Data |  30/10/09   |
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 
// _______________________________________________________________________
//|Descriçao | Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS |
//|          | monta a janela com a regua de processamento.               |
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// _______________________________________________________________________
//|Uso       | Programa principal                                         |
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯


***************
STATIC FUNCTION RunReport(Cabec1,Cabec2,Titulo,nLin)
***************


Local nCont      :=0
Local nSubCont   :=0
 
Local nMSolxCOMP :=0
Local nMPCxNF    :=0
Local nMLEADTIME :=0

Local nMParc_SC  :=0
Local nMParc_CNF :=0
Local nMParc_LED :=0 

Local cQuery     :=" "



cQuery+=" SELECT                   "
cQuery+=" F1_TIPO,A2_COD,          "
cQuery+=" C1_NUM NUMSOLIC        , "
cQuery+=" C1_SOLICIT SOLICITANTE , "
cQuery+=" C1_DTAPROV DATAPROV    , "
cQuery+=" C7_NUM                 , "
cQuery+=" C1_EMISSAO DTEMISSO    , "
cQuery+=" C7_EMISSAO PCOMP       ,   D1_DOC NF              ,  "
cQuery+=" A2_NOME FORNECEDOR     ,   D1_DTDIGIT DTDIGITACAO ,  "
cQuery+=" F1_EST ESTADO          ,   CAST(CONVERT(datetime  ,  "
cQuery+=" C7_EMISSAO , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT ) SOLxPCOMP                          , "
cQuery+=" CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C7_EMISSAO , 112 ) AS INT ) PCOMPxNF  , "
cQuery+=" CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT ) LEADTIME    "
cQuery+=" FROM  SC1020 SC1                       "
cQuery+=" JOIN SC7020 SC7  ON C7_NUMSC=C1_NUM    "   
cQuery+=" JOIN SD1020 SD1  ON C7_NUM=D1_PEDIDO   " 
cQuery+=" JOIN SF1020 SF1  ON F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA=D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA          "
cQuery+=" JOIN SA2010 SA2  ON A2_COD+A2_LOJA=F1_FORNECE+F1_LOJA                                              "
cQuery+=" WHERE                                                                                              "
cQuery+=" F1_TIPO='N'                                                                                        "
cQuery+="  AND C1_EMISSAO between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"'                              " 
cQuery+=" AND SC1.D_E_L_E_T_!='*'                                                                            "
cQuery+=" AND SC7.D_E_L_E_T_!='*'                                                                            "
cQuery+=" AND SF1.D_E_L_E_T_!='*'                                                                            "
cQuery+=" AND SA2.D_E_L_E_T_!='*'                                                                            "
cQuery+=" AND SD1.D_E_L_E_T_!='*'                                                                            "
cQuery+=" GROUP BY  F1_TIPO,A2_COD,C1_NUM,C1_SOLICIT,C7_NUM,C1_EMISSAO,C7_EMISSAO,D1_DOC,D1_DTDIGIT,F1_EST,A2_NOME,C1_DTAPROV "



if mv_par03 = 1
cQuery+=" ORDER BY A2_NOME  "//Analitico fornecedor 
else
cQuery+=" ORDER BY F1_EST   "//Sintetico
endif

TCQUERY cQuery NEW ALIAS 'AUUX'
AUUX->(DBGOTOP())

//+---------------------------------------------------------------------+
//| SETREGUA -> Indica quantos registros serao processados para a regua |
//+---------------------------------------------------------------------+

SetRegua(RecCount())
               
//+---------------------------------------------------------------------+
//| Posicionamento do primeiro registro e loop principal. Pode-se criar |
//| a logica da seguinte maneira: Posiciona-se na filial corrente e pro |
//| cessa enquanto a filial do registro for a filial corrente. Por exem |
//| plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    |
//|                                                                     |
//| dbSeek(xFilial())                                                   |
//| While !EOF() .And. xFilial() == A1_FILIAL                           |
//+---------------------------------------------------------------------+
 nTotal:=0

 if mv_par03 = 1 
   cBLOCK:=AUUX->FORNECEDOR // Analitico Fornecedor
 else
   cBLOCK:=AUUX->ESTADO     // Sintetico Estado
 endif
 nTotal:=0
  nCnt:=0
 While AUUX->(!EOF())
   if mv_par03 = 1
   cBLOCK:=AUUX->FORNECEDOR // Analitico fornecedor 
   else
     cBLOCK:=AUUX->ESTADO   // Sintetico Estado
   endif
   //+---------------------------------------------------------------------+
   //| Verifica o cancelamento pelo usuario ...                            |
   //+---------------------------------------------------------------------+
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   //+---------------------------------------------------------------------+
   //| Impressao do cabecalho do relatorio ...                             |
   //+---------------------------------------------------------------------+
    Cabecalho(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo: 
   if mv_par03 = 1   
    
   
     @nLin++,00 PSAY   AUUX->FORNECEDOR
   else
     SX5->( dbSeek( xFilial( "SX5" ) + "12" + AUUX->ESTADO, .t. ) )
     @nLin++,00 PSAY  Alltrim( SX5->X5_DESCRI )
     endif
        if mv_par03 = 1 //Analitico Fornecedor
             While AUUX->(!EOF())  .AND.  cBLOCK=AUUX->FORNECEDOR

                 Cabecalho(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

              @nLin,0      PSAY           AUUX->NUMSOLIC
              @nLin,14     PSAY           AUUX->SOLICITANTE
              @nLin,31     PSAY dtoc(stod(AUUX->DTEMISSO     ))
              @nLin,49     PSAY dtoc(stod(AUUX->PCOMP        ))
              @nLin,64     PSAY           AUUX->SOLxPCOMP
              @nLin,73     PSAY           AUUX->NF
              @nLin,84     PSAY dtoc(stod(AUUX->DTDIGITACAO  ))
              @nLin,98     PSAY           AUUX->PCOMPxNF
              @nLin,105    PSAY           AUUX->ESTADO
              @nLin,112    PSAY dtoc(stod(AUUX->DATAPROV))
              @nLin++,125  PSAY           AUUX->LEADTIME

               nMParc_SC  += AUUX->SOLxPCOMP
               nMParc_CNF += AUUX->PCOMPxNF
               nMParc_LED += AUUX->LEADTIME
               ++nCnt
               ++nSubCont
              IncRegua()
              AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
            Enddo 

            @nLin++//,00   PSAY replicate('-',220)
   			@nLin,0      PSAY "MÉDIA"
   			@nLin,62     PSAY transform(nMParc_SC     /nSubCont,"@E  999.9")
   			@nLin,96     PSAY transform(nMParc_CNF    /nSubCont,"@E  999.9")
   			@nLin++,114  PSAY transform(nMParc_LED    /nSubCont,"@E  999.9")

   		      nMSolxCOMP += nMParc_SC
              nMPCxNF    += nMParc_CNF
              nMLEADTIME += nMParc_LED
              nMParc_SC  := nMParc_CNF :=  	nMParc_LED := 	nSubCont   := 0

       else//Sintetico
             While AUUX->(!EOF())  .AND.  cBLOCK=AUUX->ESTADO
             
              Cabecalho(@nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
                
              @nLin,0      PSAY           AUUX->NUMSOLIC
              @nLin,14     PSAY           AUUX->SOLICITANTE
              @nLin,31     PSAY dtoc(stod(AUUX->DTEMISSO     ))
              @nLin,49     PSAY dtoc(stod(AUUX->PCOMP        ))
              @nLin,64     PSAY           AUUX->SOLxPCOMP
              @nLin,74     PSAY           AUUX->NF
              @nLin,84     PSAY dtoc(stod(AUUX->DTDIGITACAO  ))
              @nLin,100    PSAY           AUUX->PCOMPxNF
              @nLin,106    PSAY           AUUX->FORNECEDOR
              @nLin,153    PSAY dtoc(stod(AUUX->DATAPROV))
              @nLin++,166  PSAY           AUUX->LEADTIME

              nMParc_SC  += AUUX->SOLxPCOMP
              nMParc_CNF += AUUX->PCOMPxNF
              nMParc_LED += AUUX->LEADTIME
              ++nCnt 
              ++nSubCont

              IncRegua()
              AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
            Enddo

             @nLin++//,00   PSAY replicate('_',220)
   			 @nLin,0      PSAY "MÉDIA"
   		     @nLin,62     PSAY transform(nMParc_SC   /nSubCont,"@E  999.9")
  			 @nLin,99     PSAY transform(nMParc_CNF  /nSubCont,"@E  999.9")
  			 @nLin++,155  PSAY transform(nMParc_LED  /nSubCont,"@E  999.9")


  			  nMSolxCOMP += nMParc_SC
              nMPCxNF    += nMParc_CNF
              nMLEADTIME += nMParc_LED
              nMParc_SC  :=  nMParc_CNF :=  	nMParc_LED := 	nSubCont   := 0

       endif
 nLin++
 nLin++
 @nLin++,00   PSAY replicate('_',220)

EndDo

   @nLin,0          PSAY "Media Total"
   @nLin,62         PSAY transform(nMSolxCOMP /nCnt,"@E  999.9")
     if mv_par03 = 1 // Fornecedor
       @nLin,96     PSAY transform(nMPCxNF    /nCnt,"@E  999.9")
       @nLin++,114  PSAY transform(nMLEADTIME /nCnt,"@E  999.9")
     else            // Estado
       @nLin,98     PSAY transform(nMPCxNF    /nCnt,"@E  999.9")
       @nLin++,155  PSAY transform(nMLEADTIME /nCnt,"@E  999.9")
     endif 
   @nLin++,00       PSAY replicate('¯',220)


//+---------------------------------------------------------------------+
//| Finaliza a execucao do relatorio...                                 |
//+---------------------------------------------------------------------+
AUUX-> (dbcloseArea())
SET DEVICE TO SCREEN
//+---------------------------------------------------------------------+
//| Se impressao em disco, chama o gerenciador de impressao...          |
//+---------------------------------------------------------------------+

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

RETURN

***************
STATIC FUNCTION Cabecalho(nLin,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
***************

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
return

