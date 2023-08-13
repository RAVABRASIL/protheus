#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function MATR79()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CBCONT,CABEC1,CABEC2,CSTRING,LCONTINUA,LFIRST")
SetPrvt("CPEDANT,CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN")
SetPrvt("ALINHA,LI,LIMITE,LRODAPE,NTOTQTD,NTOTVAL")
SetPrvt("CBTXT,M_PAG,LFLAG,NTIPO,NVOLUME,LRET")
SetPrvt("LEND,CPEDIDO,CMASCARA,NTAMREF,NTAMLIN,NTAMCOL")
SetPrvt("CPRODREF,NREG,NTOTLIB,LFL,XBH,NVOL")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR790  ³ Autor ³ Gilson do Nascimento  ³ Data ³ 05.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Romaneio de Despacho  (Expedicao)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR790(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Rdmake   ³ Luiz Carlos Vieira           Data   Thu  19/02/98          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := ""
tamanho:="M"
titulo:="Romaneio de Despacho  (Expedicao)"
cDesc1:="Emiss„o do Romaneio de Despacho para a Expedicao, Almoxarifado"
cDesc2:="atraves de intervalo de Pedidos informado na op‡„o Parƒmetros."
cDesc3:=""
CbCont := 0
cabec1 := ""
cabec2 := ""
cString:="SC9"
lContinua := .T.
lFirst := .T.
cPedAnt:="   "

cPerg  :="MTR790"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog:="MATR790"
nLastKey := 0
nBegin:=0
aLinha:={ }
li:=80
limite:=132
lRodape:=.F.
nTotQtd:=nTotVal:=0
wnrel    := "MATR790"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR790",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01	     	  Do Pedido                                ³
//³ mv_par02	     	  Ate o Pedido                             ³
//³ mv_par03	     	  Faturamento de                           ³
//³ mv_par04	     	  Faturamento ate                          ³
//³ mv_par05	     	  Mascara                                  ³
//³ mv_par06	     	  Aglutina Pedidos de Grade                ³
//³ mv_par07	     	  De Nota                                  ³
//³ mv_par08	     	  Ate Nota Pedidos de Grade                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

#IFDEF WINDOWS
    RptStatus({|| C790Imp()},Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     RptStatus({|| Execute(C790Imp)},Titulo)
    Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>     Function C790Imp
Static Function C790Imp()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho:="M"
titulo:="ROMANEIO DE DESPACHO  (EXPEDICAO)"
cDesc1:="Emiss„o do Romaneio de Despacho para a Expedicao, Almoxarifado"
cDesc2:="atraves de intervalo de Pedidos informado na op‡„o Parƒmetros."
cDesc3:=""
lflag     := .F.
lContinua := .T.
lFirst    := .T.
cPedAnt   :="   "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
nTipo:=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "ROMANEIO DE DESPACHO"
cabec1 := "It Codigo           Desc. do Material                                   UM  Quantidade  Quant Volumes  Entrega   Almx  Nota F/Serie"
cabec2 := ""
dbSelectArea("SF2")
dbSetOrder(1)
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek( xFilial()+mv_par01,.T. )
nVolume := 0
SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. C9_PEDIDO <= mv_par02 .And. lContinua .and. xFilial() == C9_FILIAL

   dbSelectArea("SC5")
   dbSetOrder(1)
   dbSeek(xFilial()+SC9->C9_PEDIDO)
   dbSelectArea("SC9")

   if SC9->C9_SERIENF #"   "
//      If At(SC5->C5_TIPO,"DB") != 0 .Or. ( !Empty(C9_BLEST) .AND. !Empty(C9_BLCRED) .And. C9_BLEST #"10" .AND. C9_BLCRED # "10")
//      NOVA LIBERACAO DE CRETIDO        
        If At(SC5->C5_TIPO,"DB") != 0 .Or. ( !Empty(C9_BLEST) .AND. (!Empty(C9_BLCRED) .OR. C9_BLCRED #"04" ).And. C9_BLEST #"10" .AND. C9_BLCRED # "10")
         dbSkip()
         Loop
      EndIf
   endif

   if SC9->C9_NFISCAL < mv_par09 .or. SC9->C9_NFISCAL > mv_par10
      dbSkip()
      Loop
   endif

   dbSelectArea("SC6")
   dbSetOrder(1)
   dbSeek(xFilial()+SC9->C9_PEDIDO+SC9->C9_ITEM)

   dbSelectArea("SC9")
   if SC9->C9_SERIENF #"   "
      If SC6->C6_DATFAT < MV_PAR03 .OR. SC6->C6_DATFAT > MV_PAR04
         dbSkip()
         Loop
      Endif
   endif   

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Valida o produto conforme a mascara         ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   lRet := ValidMasc(SC9->C9_PRODUTO,MV_PAR05)
   If !lRet
      dbSkip()
      Loop
   Endif

   #IFNDEF WINDOWS
      If LastKey() == 286    //ALT_A
         lEnd := .t.
      End
   #ENDIF

   IF lEnd
      @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
      lContinua := .F.
      Exit
   Endif

   IncRegua()

   IF li > 55 .or. lFirst .and. !lFlag
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      lRodape := .T.
   Endif

   if lFirst

      cPedAnt:=C9_PEDIDO
      lFirst:=.F.
      nTotQtd:=0
      nTotVal:=0
      CPedido := SC5->C5_NUM
      dbSelectArea("SA4")
      dbSeek(xFilial()+SC5->C5_TRANSP)
      dbSelectArea("SA1")
      dbSeek(xFilial()+SC5->C5_CLIENTE + SC5->C5_LOJACLI)
      dbSelectArea("SF2")
      dbSeek(xFilial()+SC9->C9_NFISCAL + SC9->C9_SERIENF, .T.) //SC5->C5_NOTA + SC5->C5_SERIE, .T.)

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Impressao do Cabecalho do Pedido                             ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      @ li,000 PSAY "PEDIDO : "+SC5->C5_NUM
      @ li,020 PSAY "EMISSAO PEDIDO: "+DTOC(SC5->C5_EMISSAO)
      @ li,050 PSAY "EMISSAO NF: "+DTOC(SF2->F2_EMISSAO)
      @ li,080 PSAY iif(!lFlag," 1 - Via Rava Embalagens LTDA","2 - Via Transportadora")
      li := li +1
      @ li,000 PSAY "CLIENTE : "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+"-"+SA1->A1_NOME
      li := li +1
      @ li,000 PSAY "TRANSPORTADORA : "+SC5->C5_TRANSP+"-"+SA4->A4_NREDUZ+"  "+"VIA : "+SA4->A4_VIA
      li := li + 1
      if Empty(SC9->C9_SERIENF) //Venda VD
         aParcela := Condicao( SF2->F2_VALBRUT, SF2->F2_COND,,SF2->F2_EMISSAO )
         nAjuste := 0
         @ li,000 PSAY Replicate("-",limite); li++
         for _x := 1 to len(aParcela)
            @ li,nAjuste PSAY "Venc."+Alltrim(Str(_x))+": "+DtoC(aParcela[_x,1])+" - R$ "+Alltrim(Transform(aParcela[_x,2], "@E 99,999,999.99"))
            nAjuste += 47
            if _x > 3 
               li++
               nAjuste := 0
            endif   
         next _x
         li++
      endif
      @ li,000 PSAY Replicate("-",limite)

   Endif

   li := li + 1

   ImpItem()

   dbSelectArea("SC9")
   dbSkip()
   
   dbSelectArea("SC6")
   dbSetOrder(1)
   dbSeek(xFilial()+SC9->C9_PEDIDO+SC9->C9_ITEM)

   If SC6->C6_QTDEMP > 0  //Testa se ainda existe saldo no produto - Esmerino Neto 25/10/06
     dbSelectArea("SC9")
     dbSkip()
   Else
     dbSelectArea("SC9")
   EndIF

   If C9_PEDIDO #cPedAnt .or. Eof()

      li := li + 1
      @ li,000 PSAY Replicate("-",limite)
      li := li + 1
      @ li,000 PSAY " T O T A I S "
      @ li,076 PSAY nTotQtd   Picture "@E 999,999.9999"      //Picture PESQPICTQT("C6_QTDVEN",10)
      @ li,089 PSAY nVolume   Picture "@E 999,999"
      li := li + 3
      @ li,000 PSAY "Separado por:____________________________________________________________ Data: __/__/___"
      lFirst  := .T.
      if ! lFlag
         li     := 31
         @ li,000 PSAY Replicate("-",limite)
         li     := li + 3
         lFlag  := .t.
         lFirst := .t.
         SC9->( dbSeek( xFilial( "SC9" ) + cPedAnt, .t. ) )
      else
         li    := 80
         lFlag := .f.
      endif
      nVolume := 0
   Endif
End

If ( C9_PEDIDO #cPedAnt .or. Eof() ) .and. !lFirst

    li := li + 1
    @ li,000 PSAY Replicate("-",limite)
    li := li + 1
    @ li,000 PSAY " T O T A I S "
    @ li,076 PSAY nTotQtd   Picture "@E 999,999.9999"    // Picture PESQPICTQT("C6_QTDVEN",10)
    @ li,089 PSAY nVolume   Picture "@E 999,999"
    li := li + 3
    @ li,000 PSAY "Separado por:____________________________________________________________ Data: __/__/___"

Endif

IF lRodape
   roda(cbcont,cbtxt,"M")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC9")
Set Filter To
dbSetOrder(1)
Set Device TO Screen

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
   Set Printer TO
   dbCommitAll()
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Gilson do Nascimento  ³ Data ³ 05.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Itens do Romaneio  de Despacho                ³±±
±±³          ³ Ordem de Impressao : LOCALIZACAO NO ALMOXARIFADO           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR790                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function ImpItem
Static Function ImpItem()

cMascara := GetMv("MV_MASCGRD")
nTamRef  := Val(Substr(cMascara,1,2))
nTamLin  := Val(Substr(cMascara,4,2))
nTamCol  := Val(Substr(cMascara,7,2))

dbSelectArea("SB2")
dbSeek(xFilial()+SC9->C9_PRODUTO)

dbSelectArea("SC6")
dbSeek(xFilial()+SC9->C9_PEDIDO+SC9->C9_ITEM)

dbSelectArea("SB1")
dbSeek(xFilial()+SC6->C6_PRODUTO,.T.)

IF SC6->C6_GRADE == "S" .And. MV_PAR06 == 1
   dbSelectArea("SC9")
   cProdRef:=Substr(C9_PRODUTO,1,nTamRef)
   cPedido := SC9->C9_PEDIDO
   nReg    := 0
   nTotLib := 0

   While !Eof() .And. xFilial() == C9_FILIAL .And. Substr(C9_PRODUTO,1,nTamRef) == cProdRef .And. C9_PEDIDO == cPedido
      nReg:=Recno()
//      If !Empty(C9_BLEST) .AND. !Empty(C9_BLCRED) .And. C9_BLEST #"10" .AND. C9_BLCRED # "10"
// NOVA LIBERACAO DE CRETIDO
        If !Empty(C9_BLEST) .AND. (!Empty(C9_BLCRED).OR. C9_BLCRED# "04" ) .And. C9_BLEST #"10" .AND. C9_BLCRED # "10"
         dbSkip()
         Loop
      Endif
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Valida o produto conforme a mascara         ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      lRet:=ValidMasc(SC9->C9_PRODUTO,MV_PAR05)
      If !lRet
         dbSkip()
         Loop
      Endif
      nTotLib := nTotLib + SC9->C9_QTDLIB
      dbSkip()
   End
   If nReg > 0
      dbGoto(nReg)
      nReg:=0
   Endif
Endif

SA7->( dbSeek( xFilial( "SA7" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC9->C9_PRODUTO, .T. ) )
if SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC9->C9_PRODUTO==SA7->A7_CLIENTE+SA7->A7_LOJA+SA7->A7_PRODUTO
   lFl := .t.
else
   lFl := .f.
endif

SC5->( dbSetOrder(1) )
SC5->( dbSeek(xFilial( "SC5") +SC9->C9_PEDIDO) )
xBh  := SC5->C5_BH

nVol := SC9->C9_QTDLIB * SB1->B1_QE

If ( nVol - Int( nVol ) ) > .00999
   nVol := Int( nVol ) + 1
endif
cPROD := SC9->C9_PRODUTO
If lFLAG
   If Len( AllTrim( cPROD ) ) >= 8
      If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
         cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SC9->C9_PRODUTO ) )
      Else
	       cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SC9->C9_PRODUTO ) )
	    EndIf
   EndIf
EndIf
@li,000 PSAY SC9->C9_ITEM
@li,003 PSAY IIF(SC6->C6_GRADE == "S" .And. MV_PAR06 == 1,Substr(cPROD,1,nTamRef),cPROD)
@li,020 PSAY IIF( lFl, SA7->A7_DESCCLI, SB1->B1_DESC )
@li,072 PSAY SB1->B1_UM
@li,076 PSAY IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB)/iif(xBh==" ",1,2)  Picture "@E 999,999.9999"      //Picture PESQPICTQT("C9_QTDLIB",10)
@li,089 PSAY nVol  Picture "@E 999,999"
// @li,078 PSAY SB1->B1_IPI                Picture "99"
// @li,082 PSAY SB1->B1_PICM           Picture "99"
// @li,086 PSAY SB1->B1_ALIQISS            Picture "99"
// @li,079 PSAY (IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB)*SC9->C9_PRCVEN) Picture "@E 9999,999,999.99"
@li,103 PSAY SC6->C6_ENTREG
@li,114 PSAY SC6->C6_LOCAL
//@li,107 PSAY SUBS(SB2->B2_LOCALIZ,1,12)
@li,119 PSAY SC9->C9_NFISCAL+"/"+SC9->C9_SERIENF
nTotQtd := nTotQtd + IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB)
nTotVal := nTotVal + IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB)*SC9->C9_PRCVEN
nVolume := nVolume + nVol
Return

