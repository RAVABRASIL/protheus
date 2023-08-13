#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATPCV     บ Autor ณ AP6 IDE            บ Data ณ  25/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Planilha de controle de faturamento e vendas.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/* Lista de Parโmetros
MV_PAR01  = ANO DA POSIวรO
MV_PAR02  = MสS DA POSIวรO
MV_PAR03  = VALOR DA MATษRIA PRIMA PARA AQUELE MสS DAQUELE ANO
MV_PAR04  = ATUALIZA VALOR DE MATษRIA PRIMA ?

MV_MP01 = VALOR DA MATษRIA PRIMA NO MสS DE JANEIRO
MV_MP02 = VALOR DA MATษRIA PRIMA NO MสS DE FEVEREIRO
MV_MP03 = VALOR DA MATษRIA PRIMA NO MสS DE MARวO
MV_MP04 = VALOR DA MATษRIA PRIMA NO MสS DE ABRIL
MV_MP05 = VALOR DA MATษRIA PRIMA NO MสS DE MAIO
MV_MP06 = VALOR DA MATษRIA PRIMA NO MสS DE JUNHO
MV_MP07 = VALOR DA MATษRIA PRIMA NO MสS DE JULHO
MV_MP08 = VALOR DA MATษRIA PRIMA NO MสS DE AGOSTO
MV_MP09 = VALOR DA MATษRIA PRIMA NO MสS DE SETEMBRO
MV_MP10 = VALOR DA MATษRIA PRIMA NO MสS DE OUTUBRO
MV_MP11 = VALOR DA MATษRIA PRIMA NO MสS DE NOVEMBRO
MV_MP12 = VALOR DA MATษRIA PRIMA NO MสS DE DEZEMBRO
*/

*************                                 

User Function FATPCV()

*************


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Planilha de Controle de Faturamento e Vendas 2007"
Local cPict          := ""
Local titulo         := "Planilha de Controle de Faturamento e Vendas 2007"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "FATPCV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATPCV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := ""

Pergunte('FATPCV',.T.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"FATPCV",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  25/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************
Local cQuery := ''
Local nLin   := 0
Local cMVMP    := "MV_MP"
Local cMVDT    := "MV_DATA"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//SetRegua(RecCount(8))
SetRegua( 8 )
cCabec1 := "MสS | VALOR TOTAL | VALOR S/ IPI |  KG  FAT. | FATOR | MP(Kg) | % MARGEM | PRZ MEDIO | % FRETE |  EST. KG  | % EST | EST. MษDIO |	CARTEIRA (Kg) | CARTEIRA (R$) | R$ COMISSรO | % COMISSAO | Nบ NOTAS |"
          //99     999.999,99     999.999,99  999.999,99   99.99   99.99      999.99      999        99.99   9.999,99    99.99     9.999,99        999.999.99      999.999,99    999.999,99        99.99      99999
          //         10        20        30        40        50        60        70        80        90        100       110       120       130      140       150       160       170       180       190       200     
          //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec(Titulo,cCabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8          
cQuery := "select * from " + retSqlName('Z09') + " "
cQuery += "where year(Z09_DATACT) = '" + MV_PAR01 + "' and month(Z09_DATACT) between '01' and '"+MV_PAR02+"' "
cQuery += "and D_E_L_E_T_ !='*' "
cQuery += "order by Z09_DATACT "
TCQUERY CQUERY NEW ALIAS 'CAUX1'
CAUX1->( dbGoTop() )

if ! CAUX1->( EoF() )
  if MV_PAR04 == 1
    putMV( ( cMVMP + strzero( val( MV_PAR02 ), 2 ) ), MV_PAR03 )
  endIf
endIf	

While ! CAUX1->( EoF() )
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,cCabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   /*Data de armazenamento*/
   @nLin,000 PSAY substr(CAUX1->Z09_DATACT,5,2)
   /*Valor faturado em Reais*/
   @nLin,006 PSAY transform(CAUX1->Z09_VALRS,  '@E 9,999,999.99') //(valor em reais + carteira) - acessorios
   /*Valor faturado em Reais sem IPI*/
   @nLin,021 PSAY transform(CAUX1->Z09_VLSIPI, '@E 9,999,999.99') //(valor em reais + carteira) - acessorios
   /*Valor faturados em Kilos*/
   @nLin,033 PSAY transform(CAUX1->Z09_KGFAT, '@E 9,999,999.99')
   /*Fator*/
   nFator := CAUX1->Z09_VLSIPI/CAUX1->Z09_KGFAT
   @nLin,047 PSAY transform(nFator, '@E 999.99')
   /*Valor da Mat้ria Prima*/
   if substr( CAUX1->Z09_DATACT, 5, 2 ) == strzero( val( MV_PAR02 ), 2 )
     @nLin,055 PSAY  MV_PAR03
     @nLin,065 PSAY transform( ( ( nFator/MV_PAR03 ) * 100 ) - 100, '@E 999.99' )   
   elseIf ! empty( getMV(cMVMP + substr( CAUX1->Z09_DATACT,5,2 ) ) )
     @nLin,055 PSAY getMV(cMVMP + substr( CAUX1->Z09_DATACT,5,2 ) )//MATษRIA PRIMA, FAZER MV
     @nLin,065 PSAY transform( ( ( nFator/getMV(cMVMP + substr( CAUX1->Z09_DATACT,5,2 ) ) ) * 100 ) - 100, '@E 999.99' )   
   else
     alert("Nใo hแ um valor vแlido para a mat้ria prima do m๊s "+ substr( CAUX1->Z09_DATACT, 5, 2 ) )
   endIf
   /*Prazo M้dio*/
   @nLin,077 PSAY transform(  CAUX1->Z09_PRZMED, '@E 999' )   
   /*% Frete*/
   if empty(CAUX1->Z09_PCTFRE)
     dbSelectArea('Z09')
     Z09->( dbSeek( xFilial('Z09')+CAUX1->Z09_DATACT ),.F. )
     Z09->( RecLock("Z09", .F.) )        
     
     nPCF := Z09->Z09_PCTFRE := U_percFret( dtos( dataValida( stod(substr(CAUX1->Z09_DATACT,1,4)+strzero(val(substr(CAUX1->Z09_DATACT,5,2))-1,2)+'02') ) ),;
     						    dtos( dataValida( stod(substr(CAUX1->Z09_DATACT,1,6)+'02') ) ) )
     
     /*
     nPCF := Z09->Z09_PCTFRE := U_percFret( dtos( dataValida( stod(substr('20111202',1,4)+strzero(val(substr('20111202',5,2)),2)+'02') ) ),;
     						    dtos( dataValida( stod(substr(CAUX1->Z09_DATACT,1,6)+'02') ) ) )
     */
     Z09->( MsUnlock() )
     Z09->( dbCloseArea() )
   	 @nLin,087 PSAY transform(nPCF, '@E 999.99')
   else
     @nLin,087 PSAY transform(CAUX1->Z09_PCTFRE, '@E 999.99')
   endIf
   /*Estoque Mensal*/
   @nLin,094 PSAY transform( CAUX1->Z09_ESTKG  , '@E 9,999,999.99' )
   /* % do Estoque */
   @nLin,108 PSAY transform( CAUX1->Z09_PCTEST , '@E 999.99'       )
   /*M้dia de Estoque*/
   @nLin,115 PSAY transform( CAUX1->Z09_ESTMED , '@E 9,999,999.99' )
   /*Carteira em KG*/
   @nLin,131 PSAY transform( CAUX1->Z09_KGCAT  , '@E 9,999,999.99' )
   /*Carteira em R$*/
   @nLin,146 PSAY transform( CAUX1->Z09_RSCAT  , '@E 9,999,999.99' )
   /*Comissใo em R$*/
   @nLin,162 PSAY transform( CAUX1->Z09_COMISS , '@E 9,999,999.99' )
   /* % da Comissใo*/
   @nLin,180 PSAY transform( CAUX1->Z09_PCTCOM , '@E 999.99'       )
   /*Numero de Notas*/
   @nLin,192 PSAY transform( CAUX1->Z09_NNOTAS , '@E 99999'       )
   
   nLin := nLin + 1 // Avanca a linha de impressao
   CAUX1->( dbSkip() )   
EndDo
CAUX1->( dbCloseArea() )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return