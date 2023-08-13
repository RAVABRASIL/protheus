#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

//--------------------------------------------------------------------------
//Programa: FATR002
//Objetivo: Imprime o espelho da NF de forma simples, tanto em tela como na
//			impressora.
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 26/11/09
//--------------------------------------------------------------------------


*********************************************
User Function FATR002( cAlias, nReg ) 
*********************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,NVOLUME,XBH,CPEDATU,CITEMATU,NFORI,XPED_VEND")
SetPrvt("XITEM_PED,XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO")
SetPrvt("XPRE_UNI,XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC")
SetPrvt("XVAL_MERC,XTES,XCF,XICMSOL,XICM_PROD,XUNID_PRO")
SetPrvt("XVOL_2UM,NDESCICMS,XVAL_ANT,XVOLUME,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS,XMEN_POS")
SetPrvt("XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,I")
SetPrvt("NVOL,XPESO_LIQUID,NPESOL,XPED,XPESO_BRUTO,XP_LIQ_PED")
SetPrvt("XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM,XMENSAGE1,XMENSAGE2")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XTRIB_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XBSICMFON,XVLICMFON,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,NPELEM,_CLASFIS,NPTESTE,XFAX,NOPC")
SetPrvt("CCOR,NTAMDET,XB_ICMS_SOL,XV_ICMS_SOL,LFLAG,NCONT")
SetPrvt("NCOL,NTAMOBS,NAJUSTE,BB,lcorri")
PRIVATE lAuto		:= (nReg!=Nil)
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³
//³ mv_par03             // Da Serie                             ³
//³ mv_par04             // Nota Fiscal de Entrada/Saida         ³
//³ mv_par05             // Cliente/Fornecedor De                ³
//³ mv_par06             // Cliente/Fornecedor Ate               ³
//³ mv_par07             // Loja De                              ³
//³ mv_par08             // Loja Ate                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G"
limite:=220
titulo :=PADC("Nota Fiscal - Nfiscal",74)
cDesc1 :=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 :=""
cDesc3 :=PADC("da Nfiscal",74)
cNatureza:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="nfiscal"
cPerg:="FATR002"
nLastKey:= 0
lContinua := .T.
nLin:=0
wnrel    := "FATR002"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)
wnrel:=SetPrint(cString,wnrel,If(lAuto,Nil,"FATR002"),@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,!lAuto)  
//AQUI ele verifica se é automático e não faz as perguntas

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

VerImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento da Nota Fiscal                       ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF WINDOWS
   //RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   RptStatus({|lEnd| PrtDetail(@lEnd,wnRel,cString,nReg)},titulo)
   Return

***************************************************
Static Function PrtDetail(lEnd,WnRel,cAlias,nReg)
***************************************************

#ENDIF


If lAuto
	dbSelectArea(cAlias)		//SF2
	dbGoto(nReg)
	SetRegua(1)
	mv_par01 := SF2->F2_DOC         //Nota De
	mv_par02 := SF2->F2_DOC         //Nota até
	mv_par03 := SF2->F2_SERIE       //Série
	mv_par04 := 2                   //Tipo-> 1=Entrada, 2=Saída
	mv_par05 := 1                   //Unidade de medida
	mv_par06 := SF2->F2_CLIENTE     //Cliente de
	mv_par07 := SF2->F2_CLIENTE     //Cliente até
	mv_par08 := SF2->F2_LOJA        //Loja de
	mv_par09 := SF2->F2_LOJA        //Loja até

EndIf

If mv_par04 == 2
   dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
   dbSetOrder(1)
   dbSeek(xFilial() + mv_par01 + mv_par03 )

   dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
   dbSetOrder(3)
   dbSeek(xFilial() + mv_par01 + mv_par03 )
   cPedant := SD2->D2_PEDIDO
Else
   dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
   DbSetOrder(1)
   dbSeek(xFilial()+mv_par01+mv_par03 )

   dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
   dbSetOrder(3)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Val(mv_par02)-Val(mv_par01))
If mv_par04 == 2
   dbSelectArea("SF2")
   //While !Eof() .and. SF2->F2_DOC >= mv_par01 .And. SF2->F2_DOC <= mv_par02 //;
   //	.AND. SF2->F2_CLIENTE >= mv_par06 .And. SF2->F2_CLIENTE <= MV_PAR07;
   //	.AND. SF2->F2_LOJA >= mv_par08 .And. SF2->F2_LOJA <= MV_PAR09 .and. lContinua
   While !Eof() .and. SF2->F2_DOC >= mv_par01 .And. SF2->F2_DOC <= mv_par02 .and. lContinua
      If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
         DbSkip()                    // do Parametro Informado !!!
         Loop
      Endif

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

      nLinIni:=nLin                         // Linha Inicial da Impressao

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      // * Cabecalho da Nota Fiscal

      xNUM_NF     :=SF2->F2_DOC             // Numero
      xSERIE      :=SF2->F2_SERIE           // Serie
      xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
      xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
      If xTOT_FAT == 0
         xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
      Endif
      xCLI        :=SF2->F2_CLIENTE            //Cliente
      xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
      xFRETE      :=SF2->F2_FRETE           // Frete
      xSEGURO     :=SF2->F2_SEGURO          // Seguro
      xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
      xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
      xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
      xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
      XBSICMFON   :=SF2->F2_BASIMP1
      XVLICMFON   :=SF2->F2_VALIMP1
      xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
      xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
      xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
      xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
      xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
      xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
      xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
      xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
      nVOLUME     :=0

      dbSelectArea("SD2")                   // * Itens de Venda da N.F.
      dbSetOrder(3)
      dbSeek(xFilial()+xNUM_NF+xSERIE+xCLI+xLOJA)
      if SD2->D2_TES == "505"   // SUFRAMA
         xVALOR_MERC := Round( xValor_Merc / 0.7875, 2)     // Valor  da Mercadoria
      endif

      SC5->( dbSetOrder(1) )
      SC5->( dbSeek(xFilial("SC5")+SD2->D2_PEDIDO) )

      xBh      := SC5->C5_BH
      cPedAtu  := SD2->D2_PEDIDO
      cItemAtu := SD2->D2_ITEMPV

      xPED_VEND:={}                         // Numero do Pedido de Venda
      xITEM_PED:={}                         // Numero do Item do Pedido de Venda
      xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
      xPREF_DV :={}                         // Serie  quando houver devolucao
      xICMS    :={}                         // Porcentagem do ICMS
      xCOD_PRO :={}                         // Codigo  do Produto
      xQTD_PRO :={}                         // Peso/Quantidade do Produto
      xPRE_UNI :={}                         // Preco Unitario de Venda
      xPRE_TAB :={}                         // Preco Unitario de Tabela
      xIPI     :={}                         // Porcentagem do IPI
      xVAL_IPI :={}                         // Valor do IPI
      xDESC    :={}                         // Desconto por Item
      xVAL_DESC:={}                         // Valor do Desconto
      xVAL_MERC:={}                         // Valor da Mercadoria
      xTES     :={}                         // TES
      xCF      :={}                         // Classificacao quanto natureza da Operacao
      xICMSOL  :={}                         // Base do ICMS Solidario
      xICM_PROD:={}                         // ICMS do Produto
      xUNID_PRO:={}                         // Unidade do Produto
      xVol_2um :={}                         // Quantidade de volumes quando impressao 2ª unidade de medida
      nDescIcms:=0
	  nDESCSUFR:=0
      while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE .AND. SD2->D2_CLIENTE==xCLI .and.;
          SD2->D2_LOJA==xLOJA    
         If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
            DbSkip()                   // do Parametro Informado !!!
            Loop
         Endif

         AADD(xPED_VEND ,SD2->D2_PEDIDO)
         AADD(xITEM_PED ,SD2->D2_ITEMPV)
         AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
         AADD(xPREF_DV  ,SD2->D2_SERIORI)
         AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
         AADD(xCOD_PRO  ,ALLTRIM( SD2->D2_COD ) )

         AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
         AADD(xVAL_IPI  ,SD2->D2_VALIPI)
         AADD(xDESC     ,SD2->D2_DESC)
         AADD(xTES      ,SD2->D2_TES)
         AADD(xCF       ,SD2->D2_CF)
         AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))

         if Empty( xBh )
            //AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
            
            //if mv_par05 == 1
               AADD(xUNID_PRO ,SD2->D2_UM)
               AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
               AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
               AADD(xVAL_MERC ,SD2->D2_TOTAL)
               AADD(xVol_2Um  ,SD2->D2_QUANT)     // Guarda as quant. da NF
            /*
            else
               AADD(xUNID_PRO ,SD2->D2_SEGUM)
               AADD(xQTD_PRO  ,SD2->D2_QTSEGUM)     // Guarda as quant. da NF
               AADD(xPRE_UNI  ,Round( SD2->D2_TOTAL/SD2->D2_QTSEGUM, 2 ) )
               AADD(xVAL_MERC ,SD2->D2_TOTAL)
               AADD(xVol_2Um  ,SD2->D2_QUANT)     // Guarda as quant. da NF
            endif
            */
         else
            AADD(xPRE_TAB  ,SD2->D2_PRUNIT*2)
            //if mv_par05 == 1
               AADD(xUNID_PRO ,SD2->D2_UM)
               AADD(xQTD_PRO  ,SD2->D2_QUANT/2)     // Guarda as quant. da NF
               AADD(xPRE_UNI  ,SD2->D2_PRCVEN*2)
               AADD(xVAL_MERC ,SD2->D2_TOTAL)
               AADD(xVol_2Um  ,SD2->D2_QUANT)     // Guarda as quant. da NF
            /*
            else
               AADD(xUNID_PRO ,SD2->D2_SEGUM)
               AADD(xQTD_PRO  ,SD2->D2_QTSEGUM/2)     // Guarda as quant. da NF
               AADD(xPRE_UNI  ,Round( SD2->D2_TOTAL/SD2->D2_QTSEGUM*2, 2 ) )
               AADD(xVAL_MERC ,SD2->D2_TOTAL)
               AADD(xVol_2Um  ,SD2->D2_QUANT)     // Guarda as quant. da NF
            endif
            */
         Endif

         if SD2->D2_TES == "505"
    				SB1->( dbSetOrder(1) )
            SB1->( dbSeek( xFilial() + SD2->D2_COD ) )
						nPERC := ( 100 - ( SB1->B1_PCOFINS + SB1->B1_PPIS + 12 ) ) / 100
            xVal_ant                      := xVal_Merc[ Len( xVal_Merc ) ]
						xprc_ant                      := xPre_uni[ Len( xPre_uni ) ]
            xIcm_Prod[ Len( xIcm_Prod ) ] := 12
            xPre_uni[ Len( xPre_uni ) ]   := xPRC_ANT / nPERC
            xVal_Merc[ Len( xVal_Merc ) ] := xVAL_ANT / nPERC
            nDescIcms                     += xVal_Merc[ Len( xVal_Merc ) ] * 0.12
						nDESCSUFR                     += xVal_Merc[ Len( xVal_Merc ) ] * ( ( SB1->B1_PCOFINS + SB1->B1_PPIS ) / 100 )
         endif
         dbskip()
      End

      dbSelectArea("SB1")                     // * Desc. Generica do Produto
      dbSetOrder(1)
      xVolume:={}                             // quantidade de volumes
      xPESO_PRO:={}                           // Peso Liquido
      xPESO_UNIT :={}                         // Peso Unitario do Produto
      xDESCRICAO :={}                         // Descricao do Produto
      xCOD_TRIB:={}                           // Codigo de Tributacao
      xMEN_TRIB:={}                           // Mensagens de Tributacao
      xCOD_FIS :={}                           // Cogigo Fiscal
      xCLAS_FIS:={}                           // Classificacao Fiscal
      xMEN_POS :={}                           // Mensagem da Posicao IPI
      xISS     :={}                           // Aliquota de ISS
      xTIPO_PRO:={}                           // Tipo do Produto
      xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL   :={}
      xPESO_LIQ := 0
      I:=1
      E:=1
      For e:=1 to Len( xCOD_PRO )

          dbSeek( xFilial() + xCOD_PRO[e] )
          SA7->( dbSeek( xFilial( "SA7" ) + xCLI + xLoja + xCod_Pro[e] ) )
					/*05/04/07*/
					if alltrim(xCOD_PRO[e]) $ '187/188/189/190' //Inclui 27/12/07 Eurivan Peso Apara NF
						AADD(xPESO_PRO, xQTD_PRO[e])                    
					elseif alltrim(xCOD_PRO[e]) = '227'
						nIdxOrd := SC5->( recNo() )
						SC5->( dbSeek( xFilial('SC5') + xPED_VEND[e] ) )
						aAdd(xPESO_PRO , SC5->C5_PESOL)
						SC5->( dbGoTo( nIdxOrd ) )
                    else
						AADD(xPESO_PRO ,SB1->B1_PESOR * xQTD_PRO[e])                    
					endIf
					/**/
          //AADD(xPESO_PRO ,SB1->B1_PESOR * xQTD_PRO[e])

          if Empty( xBH )
             xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[e]
          else
             xPeso_liq  := xPESO_LIQ + ( xPESO_PRO[e] * 2 )
          endif
          AADD(xPESO_UNIT , SB1->B1_PESOR)
          AADD(xDESCRICAO ,iif(SA7->(!Eof()),SA7->A7_DESCCLI,SB1->B1_DESC))
          AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
          If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
             AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
          Endif

          Aadd( xCod_fis, SB1->B1_POSIPI )
          If SB1->B1_ALIQISS > 0
             AADD(xISS ,SB1->B1_ALIQISS)
          Endif
          AADD(xTIPO_PRO ,SB1->B1_TIPO)
          AADD(xLUCRO    ,SB1->B1_PICMRET)

          if Empty( SC5->C5_BH )
             nVol := xQTD_PRO[ e ] * SB1->B1_QE
          else
             nVol := xQTD_PRO[ e ] * SB1->B1_QE * 2
          endif

	 				If ( nVol - Int( nVol ) ) > .00999
	 					  nVol := Int( nVol ) + 1
	 				endif
          AADD(xVolume, nVol )

          //
          // Calculo do Peso Liquido da Nota Fiscal
          //

          xPESO_LIQUID := 0                                 // Peso Liquido da Nota Fiscal
          For I:=1 to Len( xPESO_PRO )
             if Empty( xBH )
                xPESO_LIQUID:=xPESO_LIQUID+( xPESO_PRO[I] )
             else
                xPESO_LIQUID:=xPESO_LIQUID+( xPESO_PRO[I]*2 )
             endif
          Next

      Next

      dbSelectArea("SC5")                            // * Pedidos de Venda
      dbSetOrder(1)

      nPesoL      := SC5->C5_PESOL
      xPED        := {}
      xPESO_BRUTO := 0
      xP_LIQ_PED  := 0
      xBh         := SC5->C5_BH

      For I:=1 to Len(xPED_VEND)

          dbSeek(xFilial()+xPED_VEND[I])

          If ASCAN(xPED,xPED_VEND[I])==0
             dbSeek(xFilial()+xPED_VEND[I])
             xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
             xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
             xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
             xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
             xMensage1   :=SC5->C5_MENNOT1            // Mensagem para a nota fiscal 1
             xMensage2   :=SC5->C5_MENNOT2            // Mensagem para a nota fiscal 2
             xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
             xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
             xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
             xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
             xCOD_VEND:= {SC5->C5_VEND1,;             // Codigo do Vendedor 1
             SC5->C5_VEND2,;             // Codigo do Vendedor 2
             SC5->C5_VEND3,;             // Codigo do Vendedor 3
             SC5->C5_VEND4,;             // Codigo do Vendedor 4
             SC5->C5_VEND5}              // Codigo do Vendedor 5
             xDESC_NF := {SC5->C5_DESC1,;             // Desconto Global 1
             SC5->C5_DESC2,;             // Desconto Global 2
             SC5->C5_DESC3,;             // Desconto Global 3
             SC5->C5_DESC4}              // Desconto Global 4
             AADD(xPED,xPED_VEND[I])
          Endif

          If xP_LIQ_PED >0
             xPESO_LIQ := xP_LIQ_PED
          Endif

      Next

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pesquisa da Condicao de Pagto               ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      dbSelectArea("SE4")                    // Condicao de Pagamento
      dbSetOrder(1)
      dbSeek(xFilial("SE4")+xCONDPAG)
      xDESC_PAG := SE4->E4_DESCRI

      dbSelectArea("SC6")                    // * Itens de Pedido de Venda
      dbSetOrder(1)
      xPED_CLI :={}                          // Numero de Pedido
      xDESC_PRO:={}                          // Descricao aux do produto
      J:=Len(xPED_VEND)
      For I:=1 to J
          dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
          AADD(xPED_CLI ,SC6->C6_PEDCLI)
          AADD(xDESC_PRO,SC6->C6_DESCRI)
          AADD(xVAL_DESC,SC6->C6_VALDESC)
      Next

      If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'

         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         dbSeek(xFilial() + xCLI + xLOJA )
         xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         xNOME_CLI:=SA1->A1_NOME            // Nome
		 xTRIB_CLI:=SA1->A1_GRPTRIB
         xEND_CLI :=SA1->A1_END             // Endereco
         xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         xCEP_CLI :=SA1->A1_CEP             // CEP
         xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
         xMUN_CLI :=SA1->A1_MUN             // Municipio
         xEST_CLI :=SA1->A1_EST             // Estado
         xCGC_CLI :=SA1->A1_CGC             // CGC
         xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         xTEL_CLI :=SA1->A1_TEL             // Telefone
         xFAX_CLI :=SA1->A1_FAX             // Fax
         xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
         xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
         // Alteracao p/ Calculo de Suframa
         if !empty(xSUFRAMA) .and. xCALCSUF =="S"
            IF XTIPO == 'D' .OR. XTIPO == 'B'
               zFranca := .F.
            else
               zFranca := .T.
            endif
         Else
            zfranca:= .F.
         endif
      Else
         zFranca:=.F.
         dbSelectArea("SA2")                // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial()+xCLIENTE+xLOJA)
         xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
         xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
         xEND_CLI :=SA2->A2_END             // Endereco
         xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
         xCEP_CLI :=SA2->A2_CEP             // CEP
         xCOB_CLI :=""                      // Endereco de Cobranca
         xREC_CLI :=""                      // Endereco de Entrega
         xMUN_CLI :=SA2->A2_MUN             // Municipio
         xEST_CLI :=SA2->A2_EST             // Estado
         xCGC_CLI :=SA2->A2_CGC             // CGC
         xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
         xTEL_CLI :=SA2->A2_TEL             // Telefone
         xFAX_CLI :=SA2->A2_FAX             // Fax
      Endif
      dbSelectArea("SA3")                   // * Cadastro de Vendedores
      dbSetOrder(1)
      xVENDEDOR:={}                         // Nome do Vendedor
      I:=1
      J:=Len(xCOD_VEND)
      For I:=1 to J
          dbSeek(xFilial()+xCOD_VEND[I])
          Aadd(xVENDEDOR,SA3->A3_NREDUZ)
      Next

      If xICMS_RET >0                          // Apenas se ICMS Retido > 0
         dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
         dbSetOrder(4)
         dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
         If Found()
            xBSICMRET:=F3_VALOBSE
         Else
            xBSICMRET:=0
         Endif
      Else
         xBSICMRET:=0
      Endif
      dbSelectArea( "SA4" )                   // * Transportadoras
      dbSetOrder( 1 )
      dbSeek( xFilial() + SF2->F2_TRANSP )
      xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
      xEND_TRANSP  :=SA4->A4_END            // Endereco
      xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
      xEST_TRANSP  :=SA4->A4_EST            // Estado
      xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
      xCGC_TRANSP  :=SA4->A4_CGC            // CGC
      xTEL_TRANSP  :=SA4->A4_TEL            // Fone

      dbSelectArea("SE1")                   // * Contas a Receber
      dbSetOrder(1)
      xPARC_DUP   := {}                       // Parcela
      xVENC_DUP   := {}                       // Vencimento
      xVALOR_DUP  := {}                       // Valor
      xDUPLICATAS := iif(SE1->(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.)),.T.,.F.) // Flag p/Impressao de Duplicatas

      while !SE1->(eof()) .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
         If !("NF" $ SE1->E1_TIPO)
            SE1->(dbSkip())
            Loop
         Endif
         AADD(xPARC_DUP ,SE1->E1_PARCELA)
         //Clientes Atacadao
         if SE1->E1_CLIENTE $ "002293/002292/002301/002295/002296/002291/002303/002650/002302/002852/002294/002297/002943/002944/002945"
            if SE1->E1_CLIENTE $ "002293/002292/002943/002944/002945" //Cuiaba
               AADD(xVENC_DUP ,SE1->E1_VENCTO-4)
            elseif SE1->E1_CLIENTE $ "002301"//Varzea Grande
               AADD(xVENC_DUP ,SE1->E1_VENCTO-9)            
            elseif SE1->E1_CLIENTE $ "002295/002296/002294/002297"//Campo Grande /Dourados
               AADD(xVENC_DUP ,SE1->E1_VENCTO-3)            
            elseif SE1->E1_CLIENTE $ "002291"//Rondonopolis
               AADD(xVENC_DUP ,SE1->E1_VENCTO-9)            
            elseif SE1->E1_CLIENTE $ "002303"//Sao Paulo
               AADD(xVENC_DUP ,SE1->E1_VENCTO-2)            
            elseif SE1->E1_CLIENTE $ "002650/002302/002852"//Brasilia
               AADD(xVENC_DUP ,SE1->E1_VENCTO-3)            
            endif                        
            lCorri := .T.
         else        
            lCorri := .F.         
            AADD(xVENC_DUP ,SE1->E1_VENCTO)
         endif   
         AADD(xVALOR_DUP,SE1->E1_VALOR)
                
         //Testo se o vencimento esta entre 6 e 15 dias e gero o boleto automaticamente
         //if SE1->E1_PREFIXO == "UNI" .AND. ( SE1->E1_VENCTO - SE1->E1_EMISSAO ) >= 6 .AND. ( SE1->E1_VENCTO - SE1->E1_EMISSAO ) <= 15 
         if SE1->E1_PREFIXO $ "UNI/0  " .AND. ( SE1->E1_VENCTO - SE1->E1_EMISSAO ) >= 6 .AND. ( SE1->E1_VENCTO - SE1->E1_EMISSAO ) <= 15 
            nE1Ord := SE1->( IndexOrd() )
            nE1Reg := SE1->( Recno() )
            
            Alert("Como a Duplicata: "+SE1->E1_NUM+"/"+SE1->E1_PARCELA+", tem vencimento entre 6 e 15 dias, o Boleto será emitido pela Rava agora.") 
            
            U_BOLETOG(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_VENCTO,SE1->E1_EMISSAO)
            SE1->(dbCloseArea())
            ChKFile("SE1")
            SE1->( dbSetOrder( nE1Ord ) )
            SE1->( dbGoto( nE1Reg ) )
         endif
         
         SE1->(dbSkip())
      EndDo

      dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
      DbSetOrder(1)
      dbSeek(xFilial()+xTES[1])
      xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao

      Imprime()

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Termino da Impressao da Nota Fiscal                          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      IncRegua()                    // Termometro de Impressao

      nLin:=0
      dbSelectArea("SF2")
      dbSkip()                      // passa para a proxima Nota Fiscal

   EndDo
Else

   nPesoL := 0
   dbSelectArea("SF1")       // * Cabecalho da Nota Fiscal Entrada

   xBh := " "
   //dbSeek(xFilial()+mv_par01+mv_par03+mv_par06+mv_par08 )
	//While !Eof() .and. SF2->F2_DOC >= mv_par01 .And. SF2->F2_DOC <= mv_par02 ;
   	//.AND. SF2->F2_CLIENTE >= mv_par06 .And. SF2->F2_CLIENTE <= MV_PAR07;
   	//.AND. SF2->F2_LOJA >= mv_par08 .And. SF2->F2_LOJA <= MV_PAR09 .and. lContinua
   	
   While !eof() .and. SF1->F1_DOC >= mv_par01 .And. SF1->F1_DOC <= mv_par02 ;
   	.and. SF1->F1_SERIE == mv_par03 .and.  SF1->F1_FORNECE >= mv_par06 .And. SF1->F1_FORNECE <=mv_par07;
   	.and. SF1->F1_LOJA >= mv_par08 .And. SF1->F1_LOJA <= MV_PAR09 .AND. lContinua

      If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
         DbSkip()                    // do Parametro Informado !!!
         Loop
      Endif

      /*
      If SF1->F1_TIPO # "D"    // Se a Serie do Arquivo for Diferente
         DbSkip()                    // do Parametro Informado !!!
         Loop
      Endif
      */
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Inicializa  regua de impressao                            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      SetRegua(Val(mv_par02)-Val(mv_par01))

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

      nLinIni:=nLin                         // Linha Inicial da Impressao

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      xNUM_NF     :=SF1->F1_DOC             // Numero
      xSERIE      :=SF1->F1_SERIE           // Serie
      xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
      xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
      xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
      xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
      xFRETE      :=SF1->F1_FRETE           // Frete
      xSEGURO     :=SF1->F1_DESPESA         // Despesa
      xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
      xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
      xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
      xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
      xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
      xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
      xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
      xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
      xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
      xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
      xNFORI      :=SF1->F1_NFORI           // NF Original
      xPREF_DV    :=SF1->F1_SERIORI         // Serie Original

      dbSelectArea("SD1")                   // * Itens da N.F. de Compra
      dbSetOrder(1)
      dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)

      cPedAtu := SD1->D1_PEDIDO
      cItemAtu:= SD1->D1_ITEMPC
  	  cNFOri	:= SD1->D1_NFORI

      xPEDIDO  :={}                         // Numero do Pedido de Compra
      xITEM_PED:={}                         // Numero do Item do Pedido de Compra
      xNUM_NFDV:={}                         // Numero quando houver devolucao
      xPREF_DV :={}                         // Serie  quando houver devolucao
      xICMS    :={}                         // Porcentagem do ICMS
      xCOD_PRO :={}                         // Codigo  do Produto
      xQTD_PRO :={}                         // Peso/Quantidade do Produto
      xPRE_UNI :={}                         // Preco Unitario de Compra
      xIPI     :={}                         // Porcentagem do IPI
      xPESOPROD:={}                         // Peso do Produto
      xVAL_IPI :={}                         // Valor do IPI
      xDESC    :={}                         // Desconto por Item
      xVAL_DESC:={}                         // Valor do Desconto
      xVAL_MERC:={}                         // Valor da Mercadoria
      xTES     :={}                         // TES
      xCF      :={}                         // Classificacao quanto natureza da Operacao
      xICMSOL  :={}                         // Base do ICMS Solidario
      xICM_PROD:={}                         // ICMS do Produto

      while !eof() .and. SD1->D1_DOC==xNUM_NF .AND. SD1->D1_FORNECE==xFORNECE .AND. SD1->D1_LOJA==xLOJA
      
         If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
            DbSkip()                      // do Parametro Informado !!!
            Loop
         Endif

         AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
         AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
         AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
         AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
         AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         AADD(xCOD_PRO  ,ALLTRIM(SD1->D1_COD ) )            // Produto
         AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
         AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
         AADD(xIPI      ,SD1->D1_IPI)            // % IPI
         AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
         AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
         AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
         AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
         AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
         AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
         AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         dbskip()
      End

      dbSelectArea("SB1")                     // * Desc. Generica do Produto
      dbSetOrder(1)
      xVolume:={}                             // quantidade de volumes
      xUNID_PRO:={}                           // Unidade do Produto
      xDESC_PRO:={}                           // Descricao do Produto
      xMEN_POS :={}                           // Mensagem da Posicao IPI
      xDESCRICAO :={}                         // Descricao do Produto
      xCOD_TRIB:={}                           // Codigo de Tributacao
      xMEN_TRIB:={}                           // Mensagens de Tributacao
      xCOD_FIS :={}                           // Cogigo Fiscal
      xCLAS_FIS:={}                           // Classificacao Fiscal
      xISS     :={}                           // Aliquota de ISS
      xTIPO_PRO:={}                           // Tipo do Produto
      xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL   :={}
      xSUFRAMA :=""
      xCALCSUF :=""

      I:=1
			xPESO_LIQUID := 0
      For I:=1 to Len(xCOD_PRO)

          dbSeek(xFilial()+xCOD_PRO[I])
          dbSelectArea("SB1")

          AADD(xDESC_PRO ,SB1->B1_DESC)
          AADD(xUNID_PRO ,SB1->B1_UM)
          AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
          If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
             AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
          Endif
          AADD(xDESCRICAO ,SB1->B1_DESC)
          AADD(xMEN_POS  ,SB1->B1_POSIPI)
          If SB1->B1_ALIQISS > 0
             AADD(xISS,SB1->B1_ALIQISS)
          Endif
          AADD(xTIPO_PRO ,SB1->B1_TIPO)
          AADD(xLUCRO    ,SB1->B1_PICMRET)

          npElem := ascan( xCLAS_FIS, SB1->B1_POSIPI )

          if npElem == 0
             AADD( xCLAS_FIS, SB1->B1_POSIPI )
          endif
          npElem := ascan( xCLAS_FIS, SB1->B1_POSIPI )

          DO CASE
             CASE npElem == 1
                  _CLASFIS := "A"
             CASE npElem == 2
                  _CLASFIS := "B"
             CASE npElem == 3
                  _CLASFIS := "C"
             CASE npElem == 4
                  _CLASFIS := "D"
             CASE npElem == 5
                  _CLASFIS := "E"
             CASE npElem == 6
                  _CLASFIS := "F"
          EndCase
          nPteste := Ascan(xCLFISCAL,_CLASFIS)
          If nPteste == 0
             AADD(xCLFISCAL,_CLASFIS)
          Endif
          AADD(xCOD_FIS ,_CLASFIS)

          nVol := xQTD_PRO[ I ] * SB1->B1_QE
	 				If ( nVol - Int( nVol ) ) > .00999
	 					  nVol := Int( nVol ) + 1
	 				endif
          AADD(xVolume, nVol )

          //
          // Calculo do Peso Liquido da Nota Fiscal
          //

      		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      		//³ Impressao do peso na NF consultado o SB1 * Esmerino Neto ³
      		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

          if Empty( xBH )
             xPESO_LIQUID += ( xQTD_PRO[I] ) * SB1->B1_PESO
          else
             xPESO_LIQUID += ( xQTD_PRO[I]*2 ) * SB1->B1_PESO
          endif

//		 		xPESO_LIQUID := 0                                 // Peso Liquido da Nota Fiscal
//        For N:=1 to Len(xPESOPROD)
//        	if Empty( xBH )
//          	xPESO_LIQUID:=xPESO_LIQUID+( xPESOPROD[N] )
//          else
//          	xPESO_LIQUID:=xPESO_LIQUID+( xPESOPROD[N]*2 )
//          endif
//        Next

      Next

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pesquisa da Condicao de Pagto               ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      dbSelectArea("SE4")                    // Condicao de Pagamento
      dbSetOrder(1)
      dbSeek(xFilial("SE4")+xCOND_PAG)
      xDESC_PAG := SE4->E4_DESCRI

      If xTIPO == "D"

         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         dbSeek(xFilial()+xFORNECE)
         xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         xNOME_CLI:=SA1->A1_NOME            // Nome
			xTRIB_CLI:=SA1->A1_GRPTRIB
         xEND_CLI :=SA1->A1_END             // Endereco
         xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         xCEP_CLI :=SA1->A1_CEP             // CEP
         xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
         xMUN_CLI :=SA1->A1_MUN             // Municipio
         xEST_CLI :=SA1->A1_EST             // Estado
         xCGC_CLI :=SA1->A1_CGC             // CGC
         xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         xTEL_CLI :=SA1->A1_TEL             // Telefone
         xFAX_CLI :=SA1->A1_FAX             // Fax

      Else

         dbSelectArea("SA2")                // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial()+xFORNECE+xLOJA)
         xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
         xNOME_CLI:=SA2->A2_NOME               // Nome
         xEND_CLI :=SA2->A2_END                // Endereco
         xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
         xCEP_CLI :=SA2->A2_CEP                // CEP
         xCOB_CLI :=""                         // Endereco de Cobranca
         xREC_CLI :=""                         // Endereco de Entrega
         xMUN_CLI :=SA2->A2_MUN                // Municipio
         xEST_CLI :=SA2->A2_EST                // Estado
         xCGC_CLI :=SA2->A2_CGC                // CGC
         xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
         xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
         xTEL_CLI :=SA2->A2_TEL                // Telefone
         xFAX     :=SA2->A2_FAX                // Fax
      EndIf

      dbSelectArea("SE1")                   // * Contas a Receber
      dbSetOrder(1)
      xPARC_DUP  :={}                       // Parcela
      xVENC_DUP  :={}                       // Vencimento
      xVALOR_DUP :={}                       // Valor
      xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

      while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
         AADD(xPARC_DUP ,SE1->E1_PARCELA)
         AADD(xVENC_DUP ,SE1->E1_VENCTO)
         AADD(xVALOR_DUP,SE1->E1_VALOR)
         dbSkip()
      EndDo

      dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
      dbSetOrder(1)
      dbSeek(xFilial()+xTes[1])
      xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao

      xNOME_TRANSP :=" "           // Nome Transportadora
      xEND_TRANSP  :=" "           // Endereco
      xMUN_TRANSP  :=" "           // Municipio
      xEST_TRANSP  :=" "           // Estado
      xVIA_TRANSP  :=" "           // Via de Transporte
      xCGC_TRANSP  :=" "           // CGC
      xTEL_TRANSP  :=" "           // Fone
      xTPFRETE     :=" "           // Tipo de Frete
      nVOLUME      := 0            // Volume
      xESPECIE     :=" "           // Especie
      xPESO_LIQ    := 0            // Peso Liquido
      xPESO_BRUTO  := 0            // Peso Bruto
      xCOD_MENS    :=" "           // Codigo da Mensagem
      xMENSAGEM    :=xMENSAGE1:=xMENSAGE2:=" "           // Mensagem da Nota
      //xPESO_LIQUID :=" "      //Esmerino Neto em 17/08/06 por Regina


      Imprime()

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Termino da Impressao da Nota Fiscal                          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      IncRegua()                    // Termometro de Impressao

      nLin:=0
      dbSelectArea("SF1")
      dbSkip()                     // e passa para a proxima Nota Fiscal

   EndDo
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                      FIM DA IMPRESSAO                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa da Nota Fiscal                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Programa                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                   FUNCOES ESPECIFICAS                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica posicionamento de papel na Impressora             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2

   nOpc       := 1
   #IFNDEF WINDOWS
        cCor       := "B/BG"
   #ENDIF
   While .T.

      SetPrc(0,0)
      dbCommitAll()

      @ nLin ,000 PSAY " "
      @ nLin ,004 PSAY "*"
      @ nLin ,022 PSAY "."
      #IFNDEF WINDOWS
         Set Device to Screen
         DrawAdvWindow(" Formulario ",10,25,14,56)
         SetColor(cCor)
         @ 12,27 Say "Formulario esta posicionado?"
         nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
         Set Device to Print
      #ELSE
         IF MsgYesNo("Fomulario esta posicionado ? ")
            nOpc := 1
         ElseIF MsgYesNo("Tenta Novamente ? ")
            nOpc := 2
         Else
            nOpc := 3
         Endif
      #ENDIF

      Do Case
         Case nOpc==1
              lContinua:=.T.
              Exit
         Case nOpc==2
              Loop
         Case nOpc==3
              lContinua:=.F.
              Return
      EndCase
   End
Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPDET   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe da Nota Fiscal              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function IMPDET
Static Function IMPDET()

nTamDet :=12            // Tamanho da Area de Detalhe

I:=1
J:=1

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario
lFlag := .t.

For I:=1 to nTamDet

    If I<= Len(xCOD_PRO)
       //if mv_par05 == 2
       //   xPRE_UNI[ I ] := Round( xPRE_UNI[ I ], 0 )
       //endif

       @ nLin, 003  PSAY xCOD_PRO[I]
       @ nLin, 012  PSAY xDESCRICAO[I]
       @ nLin, 067  PSAY xCOD_FIS[I]
       @ nLin, 068  PSAY xCOD_TRIB[I]
       @ nLin, 076  PSAY xUNID_PRO[I]
       @ nLin, 080  PSAY xQTD_PRO[I]               Picture "@E 999,999.999"
       @ nLin, 092  PSAY xPRE_UNI[I]               Picture "@E 99,999.999999"
       @ nLin, 111  PSAY xVAL_MERC[I]              Picture "@E 999,999.99"
       @ nLin, 126  PSAY xICM_PROD[I]              Picture "@E 99"
       @ nLin, 132  PSAY xIPI[I]                   Picture "@E 99"
       @ nLin, 136  PSAY xVAL_IPI[I]               Picture "@E 9,999.99"

       J:=J+1
       nVolume := nVolume + xVolume[ i ]
//        nVolume := nVolume + xQTD_PRO[i]  //Luciane
    elseif lFlag
       if mv_par04 == 2
          if nDescIcms #0
             nLin := nLin + 1
             @ nLin, 070 pSay "Desconto Isencao ICMS "
             @ nLin, 106 pSay nDescICms Picture "@E 999,999.99"
          endif
          if nDescsufr #0
             nLin := nLin + 1
             @ nLin, 070 pSay "Desconto Isencao PIS/COFINS "
             @ nLin, 106 pSay nDescSUFR Picture "@E 999,999.99"
          endif

          lFlag := .f.
       endif
    Endif
    nLin :=nLin+1

Next
 //  @ nLin,   03 pSay "Evite  o   protesto   automatico  do   t¡tulo   ap¢s   5  dias  do  vencimento . Caso  o  boleto  seja  extraviado,  solicitamos"
 //  @ nLin+1, 03 pSay "depositar no  Banco  do  Brasil , Agˆncia  3165-8  c/c 5356-2 , enviando  o  comprovante  via  fax  para f brica para  que  seja"
 //  @ nLin+2, 03 pSay "providenciada a baixa da cobran‡a junto ao banco. O pagamento em atraso dever  sofrer a incidencia de encargos de mora de 7% a.m"
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CLASFIS  ³ Autor ³   Marcos Simidu       ³ Data ³ 16/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Array com as Classificacoes Fiscais           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function CLASFIS
Static Function CLASFIS()

@ nLin,006 PSAY "Classificacao Fiscal"
nLin := nLin + 1
For nCont := 1 to Len(xCLFISCAL) .And. nCont <= 12
    nCol := If(Mod(nCont,2) != 0, 06, 33)
    @ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
    @ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
    nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPMENP  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Mensagem Padrao da Nota Fiscal                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function IMPMENP
Static Function IMPMENP()

nCol:= 05

If !Empty(xCOD_MENS)

   @ nLin, NCol PSAY FORMULA(xCOD_MENS)

Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MENSOBS  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Mensagem no Campo Observacao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function MENSOBS
Static Function MENSOBS()

nTamObs:=220
nCol:=05
@ nLin, 010 PSAY xMENSAGEM
nlin:=nlin+1
@ nLin, 010 PSAY xMENSAGE1
nlin:=nlin+1
@ nLin, 010 PSAY xMENSAGE2
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DUPLIC   ³ Autor ³   Silvano Araujo      ³ Data ³ 22/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Parcelamento das Duplicacatas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function DUPLIC
Static Function DUPLIC()
nCol := 7
nAjuste := 0
For BB:= 1 to Len(xVALOR_DUP)
   If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
      @ nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]
      @ nLin, nCol + 14 + nAjuste PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
      @ nLin, nCol + 32 + nAjuste PSAY xVENC_DUP[BB]
      nAjuste := nAjuste + 47
   Endif
Next

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRIME  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a Nota Fiscal de Entrada e de Saida                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico RDMAKE                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Imprime
Static Function Imprime()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³              IMPRESSAO DA N.F. DA Nfiscal                    ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho da N.F.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 00, 000 PSAY Chr(15)                // Compressao de Impressao

@ 00, 131 PSAY xNUM_NF               // Numero da Nota Fiscal
@ 02, 131 pSay xSerie

If mv_par04 == 1
   @ 03, 112 PSAY "X"
Else
   @ 03, 094 PSAY "X"
Endif

@ 07, 003 PSAY xNATUREZA               // Texto da Natureza de Operacao
@ 07, 052 PSAY xCF[1] Picture "@R 9999" // Codigo da Natureza de Operacao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Dados do Cliente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 10, 003 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
   @ 10, 093 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
Else
   @ 10, 093 PSAY " "                // Caso seja vazio
Endif

@ 10, 130 PSAY xEMISSAO              // Data da Emissao do Documento

@ 12, 003 PSAY xEND_CLI                                 // Endereco
@ 12, 083 PSAY xBAIRRO                                  // Bairro
@ 12, 107 PSAY xCEP_CLI Picture "@R 99999-999"           // CEP
@ 12, 126 PSAY " "                                      // Reservado  p/Data Saida/Entrada

@ 14, 003 PSAY xMUN_CLI                               // Municipio
@ 14, 063 PSAY xTEL_CLI                               // Telefone/FAX
@ 14, 089 PSAY xEST_CLI                               // U.F.
@ 14, 095 PSAY Iif( Substr( xInsc_cli,1,4 ) == "2000","  ", xINSC_CLI )                             // Insc. Estadual
@ 14, 126 PSAY " "                                    // Reservado p/Hora da Saida

If mv_par04 == 2

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao da Fatura/Duplicata       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   nLin:=17
   BB:=1
   nCol := 3             //  duplicatas
   DUPLIC()

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados dos Produtos Vendidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := 21
ImpDet()                 // Detalhe da NF


If mv_par04 == 2 .and. Len(xISS) == 0

  nLin:=33
  MensObs()             // Imprime Mensagem de Observacao

  // nLin:=37
  // ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica a baixa parcial ou total *
//³ das NF de Entrada                   *
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//If mv_par04 == 1 .and. SF1->F1_SERIE == 'UNI' .and. SF1->F1_FORMUL == 'S'
If mv_par04 == 1 .and. SF1->F1_SERIE $ "UNI/0  " .and. SF1->F1_FORMUL == 'S'

	//DbSelectArea("SD1")
	lOK := .F.
	lOK2 := .F.
	SD1->( DbSetOrder( 1 ) )
	SD1->( DbSeek( xFilial() + SF1->F1_DOC + SF1->F1_SERIE ) )
	cNFSai := SD1->D1_DOC
	cSeriSai := SD1->D1_SERIE
	nTotQtd := 0
	cNFOri := SD1->D1_NFORI
	cSeriOri := SD1->D1_SERIORI
	While cNFSai == SD1->D1_DOC .AND. cSeriSai == SD1->D1_SERIE .AND. cNFSai != ' '
		nTotQtd += SD1->D1_QUANT
		SD1->( DbSkip() )
		lOK := .T.
	EndDo
	//SD1->( DbCloseArea() )

	//DbSelectArea("SD2")
	SD2->( DbSetOrder( 3 ) )
	SD2->( DbSeek( xFilial() + cNFOri + cSeriOri ) )
	cNFEnt := SD2->D2_DOC
	cSeriEnt := SD2->D2_SERIE
	nTotQtd2 := 0
	While cNFEnt == SD2->D2_DOC .AND. cSeriEnt == SD2->D2_SERIE .AND. cNFEnt != ' '
		nTotQtd2 += SD2->D2_QUANT
		SD2->( DbSkip() )
		lOK2 := .T.
	EndDo
	//SD2->( DbCloseArea() )

   If xTIPO == "D"	
   	If nTotQtd == nTotQtd2 .AND. lOK == .T. .AND. lOK2 == .T.
   		nLin:=32
	   	@ nLin, 011 PSAY "Devolucao TOTAL ref. a NF Original: " + Alltrim( cNFOri )  //Esmerino Neto
   	Else
   		nLin:=32
	   	@ nLin, 011 PSAY "Devolucao PARCIAL ref. a NF Original: " + Alltrim( cNFOri )  //Esmerino Neto
   	EndIf
   endif	

EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica a baixa parcial ou total *
//³ das NF de SAIDA                     *
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par04 == 2
	cNFD2 := SD2->D2_DOC
	cSerieD2 := SD2->D2_SERIE
	SD2->( DbSetOrder( 3 ) )
	SD2->( DbSeek( xFilial() + SF2->F2_DOC + SF2->F2_SERIE ) )
	//If SF2->F2_SERIE == 'UNI' .and. Alltrim(SD2->D2_CF) $ '6556'
	If SF2->F2_SERIE $ "UNI/0  " .and. Alltrim(SD2->D2_CF) $ '6556'
		lOK := .F.
		lOK2 := .F.
		SD2->( DbSetOrder( 3 ) )
		SD2->( DbSeek( xFilial() + SF2->F2_DOC + SF2->F2_SERIE ) )
		cNFSai := SD2->D2_DOC
		cSeriSai := SD2->D2_SERIE
		nTotQtd := 0
		cNFOri := SD2->D2_NFORI
		cSeriOri := SD2->D2_SERIORI
		While cNFSai == SD2->D2_DOC .AND. cSeriSai == SD2->D2_SERIE .AND. cNFSai != ' '
			nTotQtd += SD2->D2_QUANT
			SD2->( DbSkip() )
			lOK := .T.
		EndDo
		SD1->( DbSetOrder( 1 ) )
		SD1->( DbSeek( xFilial() + cNFOri + cSeriOri ) )
		cNFEnt := SD1->D1_DOC
		cSeriEnt := SD1->D1_SERIE
		nTotQtd2 := 0
		While cNFEnt == SD1->D1_DOC .AND. cSeriEnt == SD1->D1_SERIE .AND. cNFEnt != ' '
			nTotQtd2 += SD1->D1_QUANT
			SD1->( DbSkip() )
			lOK2 := .T.
		EndDo
		If nTotQtd == nTotQtd2 .AND. lOK == .T. .AND. lOK2 == .T.
			nLin:=32
			@ nLin, 011 PSAY "Devolucao TOTAL de sua Nota Fiscal n.: " + Alltrim( cNFOri )  //Esmerino Neto
		Else
			nLin:=32
			@ nLin, 011 PSAY "Devolucao PARCIAL de sua Nota Fiscal n.: " + Alltrim( cNFOri )  //Esmerino Neto
		EndIf
	EndIf
	SD2->( DbSetOrder( 3 ) )
	SD2->( DbSeek( xFilial() + cNFD2 + cSerieD2 ) )
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prestacao de Servicos Prestados     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(xISS) > 0

   nLin := 40
   Impmenp()

   nLin :=41
   MensObs()

  @ 44, 142  PSAY xTOT_FAT  Picture "@E@Z 999,999,999.99"   // Valor do Servico
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo dos Impostos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 38, 010  PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS
@ 38, 036  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
If xTRIB_CLI == "001"
   @ 38, 065  PSAY xBSICMFON   Picture "@E@Z 999,999,999.99"  // Base ICMS cliente fonte
   @ 38, 090  PSAY xVLICMFON   Picture "@E@Z 999,999,999.99"  // Valor ICMS cliente fonte
Else
   @ 38, 065  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
   @ 38, 090  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
EndIf
@ 38, 120  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.

@ 40, 010  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
@ 40, 036  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
@ 40, 090  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI
@ 40, 120  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao Dados da Transportadora  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 43, 003  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
   @ 43, 085 PSAY "1"                              // Emitente (1)
Else                                               //     ou
   @ 43, 085 PSAY "2"                              // Destinatario (2)
Endif

@ 43, 090 PSAY " "                                  // Res. p/Placa do Veiculo
@ 43, 103 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
   @ 43, 113 PSAY xCGC_TRANSP Picture "@R 99.999.999/9999-99"
Else
   @ 43, 113 PSAY " "                               // Caso seja vazio
Endif

@ 45, 003 PSAY xEND_TRANSP                          // Endereco Transp.
@ 45, 073 PSAY xMUN_TRANSP                          // Municipio
@ 45, 103 PSAY xEST_TRANSP                          // U.F.
@ 45, 113 PSAY " "                                  // Reservado p/Insc. Estad.

if Empty( nPesol )
   @ 47, 007 PSAY nVOLUME  Picture "@E@Z 999,999"             // Quant. Volumes
else
   @ 47, 007 PSAY "1"
endif
@ 47, 020 PSAY xESPECIE Picture "@!"                          // Especie
@ 47, 048 PSAY "RAVA EMBALAGENS"                             // Res para Marca
@ 47, 073 PSAY " "                                           // Res para Numero
*@ 47, 100 PSAY xPESO_BRUTO     Picture "@E@Z 999,999.99"      // Res para Peso Bruto
if Empty( nPesol )
   //@ 47, 100 PSAY xPESO_LIQUID    Picture"@E@Z 999,999.99"      // Res para Peso Bruto  //Esmerino Neto
   @ 47, 118 PSAY xPESO_LIQUID    Picture "@E@Z 999,999.99"      // Res para Peso Liquido
else
   @ 47, 100 PSAY nPESOL          Picture "@E@Z 999,999.99"      // Res para Peso Bruto
   @ 47, 118 PSAY nPesol          Picture "@E@Z 999,999.99"
endif

If mv_par04 == 2
   @ 50, 010 pSay xCliente
   @ 50, 030 pSay xPed_cli[ 1 ]
   @ 50, 048 pSay xVendedor[ 1 ] + " " + xCod_vend[ 1 ]
Endif

@ 53, 009 pSay "A - 3920.100199"
@ 54, 009 pSay "B - 3923.210100"
@ 55, 009 pSay "C - 3915.909900"
@ 56, 009 pSay "D - 3923.290100"

//If mv_par04 == 2
//   nLin := 54
//   Clasfis()               // Impressao de Classif. Fiscal
//Endif

@ 61, 134 PSAY xNUM_NF                   // Numero da Nota Fiscal

@ 63, 000 PSAY chr(18)                   // Descompressao de Impressao

// SetPrc(0,0)                              // (Zera o Formulario)
if lCorri
    msgAlert("Cliente ATACADÃO. Será gerada uma nota de correção!")
	U_FATAR01( 'S' )		
endIf

Return .t.