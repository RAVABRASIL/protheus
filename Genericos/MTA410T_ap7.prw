#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MTA410T()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LFLAG,CALIAS,CARQ,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTA460T                                          ³ 03/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao/Liberacao de Pedidos de vendas - RAVA               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
lFlag  := .t.
if SM0->M0_CODIGO == "02" .and. !'VD' $ SF2->F2_VEND1

   if Select( "XC5" ) == 0
      cArq := "SC5010"
      Use (cArq) ALIAS XC5 VIA "TOPCONN" NEW SHARED
	  U_AbreInd( cARQ )
   endif

   DbSelectArea("XC5")
   XC5->( DbSetOrder( 1 ) )
   XC5->( dbSeek( xFilial( "SC5" ) + SC5->C5_NUM ) )

   If XC5->( Eof() )
      RecLock( "XC5", .T. )
   else
      RecLock( "XC5", .F. )
   endif

   XC5->C5_FILIAL  := xFilial( "SC5");  XC5->C5_NUM     := SC5->C5_NUM
   XC5->C5_TIPO    := SC5->C5_TIPO;     XC5->C5_CLIENTE := SC5->C5_CLIENTE
   XC5->C5_LOJAENT := SC5->C5_LOJAENT;  XC5->C5_LOJACLI := SC5->C5_LOJACLI
   XC5->C5_TRANSP  := SC5->C5_TRANSP;   XC5->C5_TIPOCLI := SC5->C5_TIPOCLI
   XC5->C5_CONDPAG := SC5->C5_CONDPAG;  XC5->C5_TABELA  := SC5->C5_TABELA
   XC5->C5_VEND1   := SC5->C5_VEND1  ;  XC5->C5_COMIS1  := SC5->C5_COMIS1
   XC5->C5_VEND2   := SC5->C5_VEND2  ;  XC5->C5_COMIS2  := SC5->C5_COMIS2
   XC5->C5_VEND3   := SC5->C5_VEND3  ;  XC5->C5_COMIS3  := SC5->C5_COMIS3
   XC5->C5_VEND4   := SC5->C5_VEND4  ;  XC5->C5_COMIS4  := SC5->C5_COMIS4
   XC5->C5_VEND5   := SC5->C5_VEND5  ;  XC5->C5_COMIS5  := SC5->C5_COMIS5
   XC5->C5_DESC1   := 0              ;  XC5->C5_DESC2   := SC5->C5_DESC2
   XC5->C5_DESC3   := SC5->C5_DESC3  ;  XC5->C5_DESC4   := SC5->C5_DESC4
   XC5->C5_BANCO   := SC5->C5_BANCO  ;  XC5->C5_DESCFI  := SC5->C5_DESCFI
   XC5->C5_EMISSAO := SC5->C5_EMISSAO;  XC5->C5_COTACAO := SC5->C5_COTACAO
   XC5->C5_PARC1   := SC5->C5_PARC1  ;  XC5->C5_DATA1   := SC5->C5_DATA1
   XC5->C5_PARC2   := SC5->C5_PARC2  ;  XC5->C5_DATA2   := SC5->C5_DATA2
   XC5->C5_PARC3   := SC5->C5_PARC3  ;  XC5->C5_DATA3   := SC5->C5_DATA3
   XC5->C5_PARC4   := SC5->C5_PARC4  ;  XC5->C5_DATA4   := SC5->C5_DATA4
   XC5->C5_TPFRETE := SC5->C5_TPFRETE;  XC5->C5_FRETE   := SC5->C5_FRETE
   XC5->C5_SEGURO  := SC5->C5_SEGURO ;  XC5->C5_DESPESA := SC5->C5_DESPESA
   XC5->C5_FRETAUT := SC5->C5_FRETAUT;  XC5->C5_REAJUST := SC5->C5_REAJUST
   XC5->C5_MOEDA   := SC5->C5_MOEDA  ;  XC5->C5_PESOL   := SC5->C5_PESOL
   XC5->C5_PBRUTO  := SC5->C5_PBRUTO ;  XC5->C5_REIMP   := SC5->C5_REIMP
   XC5->C5_REDESP  := SC5->C5_REDESP ;  XC5->C5_VOLUME1 := SC5->C5_VOLUME1
   XC5->C5_VOLUME2 := SC5->C5_VOLUME2;  XC5->C5_VOLUME3 := SC5->C5_VOLUME3
   XC5->C5_VOLUME4 := SC5->C5_VOLUME4;  XC5->C5_ESPECI1 := SC5->C5_ESPECI1
   XC5->C5_ESPECI2 := SC5->C5_ESPECI2;  XC5->C5_ESPECI3 := SC5->C5_ESPECI3
   XC5->C5_ESPECI4 := SC5->C5_ESPECI4;  XC5->C5_ACRSFIN := SC5->C5_ACRSFIN
   XC5->C5_MENNOTA := SC5->C5_MENNOTA;  XC5->C5_MENPAD  := SC5->C5_MENPAD
   XC5->C5_INCISS  := SC5->C5_INCISS ;  XC5->C5_LIBEROK := SC5->C5_LIBEROK
   XC5->C5_OK      := SC5->C5_OK     ;  XC5->C5_NOTA    := SC5->C5_NOTA
   XC5->C5_SERIE   := SC5->C5_SERIE  ;  XC5->C5_VENDA   := SC5->C5_VENDA
   XC5->C5_KITREP  := SC5->C5_KITREP ;  XC5->C5_OS      := SC5->C5_OS
   XC5->C5_LOCALIZ := SC5->C5_LOCALIZ;  XC5->C5_LOCRED  := SC5->C5_LOCRED
   msUnlock()
   dbcommit()

   if Select( "XC6" ) == 0
      cArq := "SC6010"
      Use (cArq) ALIAS XC6 VIA "TOPCONN" NEW SHARED
	  U_AbreInd( cARQ )
   endif
   
   DbSelectArea("XC6")	 
   XC6->( DbSetOrder( 1 ) )
   XC6->( dbSeek( xFilial( "SC6" ) + SC5->C5_NUM, .t. ) )
	 SC6->( DbSetOrder( 1 ) )
   SC6->( dbSeek( xFilial( "SC6" ) + SC5->C5_NUM, .t. ) )

   while SC6->C6_NUM == SC5->C5_NUM .and. SC6->( !Eof() )

      if XC6->( Eof() ) .or. XC6->C6_NUM #SC5->C5_NUM
         RecLock( "XC6", .T. )
      else
         RecLock( "XC6", .F. )
      endif

      XC6->C6_FILIAL  := xFilial( "SC6");  XC6->C6_ITEM    := SC6->C6_ITEM
      XC6->C6_PRODUTO := SC6->C6_PRODUTO;  XC6->C6_UM      := SC6->C6_UM
      XC6->C6_QTDVEN  := SC6->C6_QTDVEN ;  XC6->C6_PRCVEN  := SC6->C6_PRCVEN
      XC6->C6_VALOR   := SC6->C6_VALOR  ;  XC6->C6_QTDLIB  := SC6->C6_QTDLIB
      XC6->C6_TES     := SC6->C6_TES    ;  XC6->C6_CF      := SC6->C6_CF
      XC6->C6_SEGUM   := SC6->C6_SEGUM  ;  XC6->C6_UNSVEN  := SC6->C6_UNSVEN
      XC6->C6_LOCAL   := SC6->C6_LOCAL  ;  XC6->C6_QTDEMP  := SC6->C6_QTDEMP
      XC6->C6_QTDENT  := SC6->C6_QTDENT ;  XC6->C6_CLI     := SC6->C6_CLI
      XC6->C6_DESCONT := SC6->C6_DESCONT;  XC6->C6_VALDESC := SC6->C6_VALDESC
      XC6->C6_ENTREG  := SC6->C6_ENTREG ;  XC6->C6_LA      := SC6->C6_LA
      XC6->C6_LOJA    := SC6->C6_LOJA   ;  XC6->C6_NUM     := SC6->C6_NUM
      XC6->C6_COMIS1  := SC6->C6_COMIS1 ;  XC6->C6_COMIS2  := SC6->C6_COMIS2
      XC6->C6_COMIS3  := SC6->C6_COMIS3 ;  XC6->C6_COMIS4  := SC6->C6_COMIS4
      XC6->C6_COMIS4  := SC6->C6_COMIS4 ;  XC6->C6_PEDCLI  := SC6->C6_PEDCLI
      XC6->C6_DESCRI  := SC6->C6_DESCRI ;  XC6->C6_PRUNIT  := SC6->C6_PRCVEN
      XC6->C6_BLOQUEI := SC6->C6_BLOQUEI;  XC6->C6_GEROUPV := SC6->C6_GEROUPV
      XC6->C6_CLASFIS := SC6->C6_CLASFIS;  XC6->C6_PRSEGUM := SC6->C6_PRSEGUM
      XC6->( msUnlock() )
      XC6->( dbcommit() )

      XC6->( dbSkip() )
      SC6->( dbSkip() )

   end

   while XC6->C6_NUM == SC5->C5_NUM .and. XC6->( !Eof() )
      RecLock( "XC6", .F. )
      XC6->( dbDelete() )
      XC6->( msUnlock() )
      XC6->( dbcommit() )
      XC6->( dbSkip() )
   end
endif

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(lFlag)
Return(lFlag)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
