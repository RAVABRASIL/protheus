#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠ЁPrograma  :PCPR045   Ё Autor :TEC1 - Designer       Ё Data :19/06/2015 Ё╠╠
╠╠цддддддддддеддддддддддадддддддеддддддддбддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao :                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametros:                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   :                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       :                                                            Ё╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/


/*
User Function PCPR045()

Private lOK    := .F.
Private cMarca := GetMark()
Private coTbl1
Private aEstru := {} 

SetPrvt("oDlg1","oBrw1","oSBtn1","oSBtn2")

oPerg1()

if !Pergunte("PCPR45",.T.)
   Return
endif

oDlg1  := MSDialog():New( 137,254,467,899,"oDlg1",,,.F.,,,,,,.T.,,,.F. )
oTbl1()
DbSelectArea("TMP")
oBrw1  := MsSelect():New( "TMP","OK","",{{"OK"       ,"",""            ,""},;
                                         {"OP"       ,"","Ord.Producao",""},;
                                         {"PROD"     ,"","Produto"     ,""},;
                                         {"DESCRICAO","","Descricao"   ,""},;
                                         {"QTDUM"    ,"","Qtd.UM"      ,""},;
                                         {"QTDSUM"   ,"","Qtd.Seg.UM"  ,""}},.F.,cMarca,{009,008,133,269},,, oDlg1 ) 
oBrw1:oBrowse:lHasMark    := .T.
oBrw1:oBrowse:lCanAllmark := .T.
oBrw1:oBrowse:nClrPane    := CLR_BLACK
oBrw1:oBrowse:nClrText    := CLR_BLACK
oBrw1:oBrowse:bAllMark    := {||TMPMkAll()}
oBrw1:bMark               := {||TMPMark()}

oSBtn1         := SButton():New( 009,280,1,,oDlg1,,"", )
oSBtn1:bAction := {||Ok()}

oSBtn2         := SButton():New( 025,280,2,,oDlg1,,"", )
oSBtn2:bAction := {||FechaDlg()}

MsAguarde({|| FiltraOPs()},"Aguarde...","Processando Dados...")

oDlg1:Activate(,,,.T.)
cOps  := ""
aProd := {}
if lOk
   TMP->(dbGoTop())
   while TMP->(!Eof())	
      if TMP->OK == cMarca
         Aadd( aProd, {TMP->OP, SUBS(TMP->PROD,1,12), TMP->DESCRICAO,TMP->UM,TMP->QTDUM,TMP->SEGUM,TMP->QTDSUM} )
         cOps += "'"+TMP->OP+"',"         
      endif		
      TMP->(dbSkip())
   enddo
endif

TMP->(DbCloseArea())

if !Empty(cOps) .AND. lOK
   
   MsAguarde({|| DadosImp()},"Aguarde...","Processando Dados...")      
   Imprime()

   If Select("OPX") > 0
   	OPX->(dbCloseArea())
   EndIf
   
endif

Return
*/


*************
// FUNCAO ALTERADA PARA IMPRIMIR PELO LOTE 

User Function PCPR045()

*************

Private lOK    := .F.

cOps  := ""
aProd := {}
_cLote:=""

oPerg1('PCPL45')

if !Pergunte("PCPL45",.T.)
   Return
endif

_cLote:=MV_PAR01

DbSelectArea("ZZC")
DbSetOrder(1)

IF ZZC->( DbSeek( XFILIAL('ZZC') + _cLote ) )

	while ZZC->(!Eof()) .AND. ZZC->ZZC_FILIAL=XFILIAL('ZZC') .AND.ZZC->ZZC_LOTE==_cLote
            
            _cDescPA:=Substr(POSICIONE ("SB1", 1, xFilial("SB1") +ZZC->ZZC_PRODPA, "B1_DESC"),1,50)
            Aadd( aProd, {ZZC->ZZC_OP, SUBS(ZZC->ZZC_PRODPA,1,12), _cDescPA,ZZC->ZZC_UM,ZZC->ZZC_QTDUM,ZZC->ZZC_SEGUM,ZZC->ZZC_QTDSUM} )
			cOps += "'"+ZZC->ZZC_OP+"',"

		    ZZC->(dbSkip())
	enddo

ELSE

   alert('Esse Nao e um Lote Valido!!!')
   return

ENDIF	

ZZC->(DbCloseArea())

if !Empty(cOps) 
   
   MsAguarde({|| DadosImp()},"Aguarde...","Processando Dados...")      
   Imprime()

   If Select("OPX") > 0
   	OPX->(dbCloseArea())
   EndIf
   
endif

Return


**************************
static function DadosImp()
**************************

   cOps := Substr(cOps,1,Len(cOps)-1)
   cQuery := "SELECT "
   cQuery += "  OP=SC2.C2_NUM, PROD=SD4.D4_COD, DESCR=SB1.B1_DESC, QUANT=SUM(SD4.D4_QTDEORI) "
   cQuery += "FROM "
   cQuery += "   "+RetSqlName("SC2")+" SC2, "+RetSqlName("SD4")+" SD4, "+RetSqlName("SB1")+" SB1 "
   cQuery += "WHERE "
   cQuery += "   SC2.C2_NUM IN ("+cOps+") AND " //
   cQuery += "   SC2.C2_SEQPAI = '001' AND LEFT(SC2.C2_PRODUTO,2) = 'PI' AND LEFT(SC2.C2_PRODUTO,3) <> 'PII' AND "
   cQuery += "   SD4.D4_FILIAL = SC2.C2_FILIAL AND "
   cQuery += "   SD4.D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND "
   cQuery += "   SD4.D4_COD = SB1.B1_COD AND "
   cQuery += "   SB1.B1_TIPO = 'MP' AND "
   cQuery += "   SD4.D_E_L_E_T_ <> '*' AND "
   cQuery += "   SC2.D_E_L_E_T_ <> '*' AND "
   cQuery += "   SB1.D_E_L_E_T_ <> '*' "
   cQuery += "GROUP BY "
   cQuery += "   SC2.C2_NUM, SD4.D4_COD, SB1.B1_DESC "

   cQuery += "UNION "

   cQuery += "SELECT "
   cQuery += "  OP=SC2.C2_NUM, PROD=SD4.D4_COD, DESCR=SB1.B1_DESC, QUANT=SUM(SD4.D4_QTDEORI) "
   cQuery += "FROM "
   cQuery += "   "+RetSqlName("SC2")+" SC2, "+RetSqlName("SD4")+" SD4, "+RetSqlName("SB1")+" SB1 "
   cQuery += "WHERE "
   cQuery += "   SC2.C2_NUM IN ("+cOps+") AND " //
   cQuery += "   LEFT(SC2.C2_PRODUTO,2) = 'PI' AND "
   cQuery += "   ( ( SELECT LEFT(C2X.C2_PRODUTO,2) "
   cQuery += "       FROM "+RetSqlName("SC2")+" C2X " 
   cQuery += "       WHERE C2X.C2_NUM + C2X.C2_ITEM + C2X.C2_SEQUEN = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQPAI AND "
   cQuery += "       C2X.D_E_L_E_T_ <> '*' ) = 'PI' AND "
   cQuery += "     ( SELECT C2X.C2_SEQPAI "
   cQuery += "       FROM "+RetSqlName("SC2")+" C2X "
   cQuery += "       WHERE C2X.C2_NUM + C2X.C2_ITEM + C2X.C2_SEQUEN = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQPAI AND "
   cQuery += "       C2X.D_E_L_E_T_ <> '*' ) = '001' ) AND "
   cQuery += "   SD4.D4_FILIAL = SC2.C2_FILIAL AND "
   cQuery += "   SD4.D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND "
   cQuery += "   SD4.D4_COD = SB1.B1_COD AND "
   cQuery += "   SB1.B1_TIPO = 'MP' AND "
   cQuery += "   SD4.D_E_L_E_T_ <> '*' AND "
   cQuery += "   SC2.D_E_L_E_T_ <> '*' AND "
   cQuery += "   SB1.D_E_L_E_T_ <> '*' "
   cQuery += "GROUP BY "
   cQuery += "   SC2.C2_NUM, SD4.D4_COD, SB1.B1_DESC "
   cQuery += "ORDER BY "
   cQuery += "   SC2.C2_NUM "
   cQuery := ChangeQuery(cQuery)

   If Select("OPX") > 0
   	OPX->(dbCloseArea())
   EndIf

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"OPX",.T.,.T.)

return



/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё oTbl1() - Cria temporario para o Alias: TMP
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"OK"       ,"C",002,000} )
Aadd( aFds , {"OP"       ,"C",006,000} )
Aadd( aFds , {"PROD"     ,"C",015,000} )
Aadd( aFds , {"DESCRICAO","C",050,000} )
Aadd( aFds , {"QTDUM"    ,"N",012,002} )
Aadd( aFds , {"UM"       ,"C",002,000} )
Aadd( aFds , {"QTDSUM"   ,"N",010,002} )
Aadd( aFds , {"SEGUM"    ,"C",002,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё FechaDlg()
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function FechaDlg()
   oDlg1:End()
Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё Ok()
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function Ok()
   lOk := .T.
   FechaDlg()
Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё FiltraOPs()
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function FiltraOPs()
local cQuery

cQuery := "SELECT SC2.C2_PRODUTO, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, "
cQuery += "SC2.C2_QUANT,SC2.C2_QTSEGUM,SC2.C2_QUJE,SC2.C2_PERDA, "
cQuery += "SC2.C2_STATUS,SC2.C2_TPOP, B1_UM, B1_SEGUM, "
cQuery += "SC2.R_E_C_N_O_ SC2RECNO "
cQuery += "FROM "
cQuery += RetSqlName("SC2")+" SC2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE "
cQuery += "SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "
cQuery += "SC2.C2_DATPRI BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND "
cQuery += "SC2.C2_SEQUEN = '001' AND SC2.C2_PRODUTO = SB1.B1_COD AND "
cQuery += "SC2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY SC2.C2_NUM"
cQuery := ChangeQuery(cQuery)

If Select("SC2X") > 0
	SC2X->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC2X",.T.,.T.)

if !SC2X->(EOF())

   while SC2X->(!EOF())

      RecLock('TMP',.T.)	
      TMP->OP        := SC2X->C2_NUM
      TMP->PROD      := SC2X->C2_PRODUTO
      TMP->QTDUM     := SC2X->C2_QUANT
      TMP->UM        := SC2X->B1_UM
      TMP->QTDSUM	   := SC2X->C2_QTSEGUM
      TMP->SEGUM     := SC2X->B1_SEGUM
      TMP->DESCRICAO := Substr(POSICIONE ("SB1", 1, xFilial("SB1") + SC2X->C2_PRODUTO, "B1_DESC"),1,50)
      TMP->(MsUnLock())

      SC2X->(dbSkip())
   enddo

endif

TMP->(DbGoTop())

If Select("SC2X") > 0
	SC2X->(dbCloseArea())
EndIf


Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё oPerg1() - Cria grupo de Perguntas.
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
/*
Static Function oPerg1()

Local aHelpPor := {}

PutSx1( 'PCPR45','01','OP Inicia de  ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( 'PCPR45','02','OP Inicia atИ ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( 'PCPR45','03','% de Perda    ?','','','mv_ch3','N',5,2,0,'G','','','','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,{},{} )

Return
*/
Static Function oPerg1(cPerg)

Local aHelpPor := {}

PutSx1( cPerg,'01','Lote          ?','','','mv_ch1','C',8,0,0,'G','','ZZB','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'02','% de Perda    ?','','','mv_ch2','N',5,2,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё TMPMark() - Funcao para marcar o Item MsSelect
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function TMPMark()

Local lDesMarca := IsMark("OK", cMarca, .F. )

RecLock("TMP", .F.)
if !lDesmarca
   TMP->OK := "  "
else
   TMP->OK := cMarca
endif


TMP->(MsUnlock())

return


/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё TMPMkaLL() - Funcao para marcar todos os Itens MsSelect
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function TMPMkAll()

local nRecno := TMP->(Recno())

TMP->(DbGotop())
while ! TMP->(EOF())
   RecLock("TMP",.F.)
   if Empty(TMP->OK)
      TMP->OK := cMarca
   else
      TMP->OK := "  "
   endif
   TMP->(MsUnlock())
   TMP->(DbSkip())
end
TMP->(DbGoto(nRecno))

return .T.


*************************
static function imprime()
*************************

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Analise de OPs"
Local cPict          := ""
//Local titulo         := "Analise de consumo de OPs - Entre: "+DtoC(MV_PAR01)+" e "+DtoC(MV_PAR02)+;
Local titulo         := "Analise de consumo de OPs - Lote: "+alltrim(MV_PAR01)+;
                        " - Percentual de Perda: "+Transform(MV_PAR02,"@E 99.99")
//                        " - Percentual de Perda: "+Transform(MV_PAR03,"@E 99.99")

Local nLin           := 80
Local Cabec1         := "Codigo           Descricao                                               Quant."
//                       12345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                1         2         3         4         5         6         7         8
Local Cabec2         := ""                                                 
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "PCPR045" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := ""
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR045" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario...                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁRUNREPORT ╨ Autor Ё AP6 IDE            ╨ Data Ё  22/06/15   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ╨╠╠
╠╠╨          Ё monta a janela com a regua de processamento.               ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Programa principal                                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
****************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
****************************************************

Local nOrdem
Local cOP
Local aResum := {}
//Local nPerda := 1+(MV_PAR03/100)
Local nPerda := 1+(MV_PAR02/100)

dbSelectArea("OPX")

SetRegua(RecCount())

dbGoTop()
nTotG := nTotO := 0
while !EOF()
   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Impressao do cabecalho do relatorio. . .                            Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   nTotO := 0
   cOp   := OPX->OP
   nInd  := aScan(aProd,{|x| x[1] == OPX->OP })
   @nLin,00 PSAY "OP: "+cOP + " - Produto: "+ aProd[nInd,2]+" - "+aProd[nInd,3]+;
                 " - Qtd.("+aProd[nInd,4]+"): "+Transform(aProd[nInd,5],"@E 999,999.99")+" - Qtd.("+aProd[nInd,6]+"):"+Transform(aProd[nInd,7],"@E 999,999.99")
   nLin++
   @nLin,00 PSAY Replicate("-", Limite)
   nLin++
   while !EOF() .and. cOP == OPX->OP   

      //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      //Ё Verifica o cancelamento pelo usuario...                             Ё
      //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
      If lAbortPrint
         @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
         Exit
      Endif

      //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      //Ё Impressao do cabecalho do relatorio. . .                            Ё
      //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
      If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin := 8
      Endif

      @nLin,00 PSAY OPX->(PROD+"  "+DESCR+"  "+Transform(QUANT*nPerda,"@E 999,999.99") )
      nPos := aScan(aResum,{|x| Alltrim(x[1]) == Alltrim(OPX->PROD) })
      if nPos > 0
         aResum[nPos,3] += OPX->QUANT*nPerda
      else
         Aadd( aResum, {OPX->PROD, OPX->DESCR, OPX->QUANT*nPerda } )
      endif
      nTotO += OPX->QUANT*nPerda
      nLin++   //Avanca a linha de impressao
      dbSkip() //Avanca o ponteiro do registro no arquivo
   end
   @nLin,59 PSAY "Total OP: "+Transform(nTotO,"@E 999,999.99")
   nLin++
   @nLin,00 PSAY Replicate("-", Limite)     
   nLin++
end

nLin++
@nLin,00 PSAY "RESUMO:"
nLin++
@nLin,00 PSAY Replicate("-",24)
nLin++
for nY := 1 to Len(aResum)
   @nLin,00 PSAY Subs(aResum[nY,1],1,12)+"  "+Transform(aResum[nY,3],"@E 999,999.99")
   nTotG += aResum[nY,3]
   nLin++
next nY
@nLin,00 PSAY Replicate("-",24)
nLin++
@nLin,00 PSAY "Total Lote:   "+Transform(nTotG,"@E 999,999.99")


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza a execucao do relatorio...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SET DEVICE TO SCREEN

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return