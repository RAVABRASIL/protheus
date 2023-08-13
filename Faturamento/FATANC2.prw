#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "topconn.ch"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATANC2()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,CNATUREZA")
SetPrvt("ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN")
SetPrvt("WNREL,M_PAG,NTAMNF,CSTRING,TITULO,CABEC1")
SetPrvt("CABEC2,CINDSF2,CCHAVE,CFILTRO,NTOTAL,NTOTFAT")
SetPrvt("NTOTSIPI,NTOTKG,CDOC,CTES,CNOME,APARCELAS")
SetPrvt("NQTDITEM,NQTDKG,DEMISSAO,CSERIE,NVALBRUT,NVALSIPI")
SetPrvt("NFATOR,CSIT,Y,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  FATANC  ³ Autor ³   Eurivan Marques     ³ Data ³ 27/11/02 ³±±
±±																   Atualizado em 20/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Clientes Aniversariantes                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01        	// Mes                                           ³
//³ mv_par02        	// Do Cliente                                    ³
//³ mv_par03        	// Ate Cliente                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt   := ""
CbCont  := ""
nOrdem  := 0
Alfa    := 0
Z       := 0
M       := 0
tamanho := "G"
limite  := 254

cDesc1    := "Este programa ira Emitir relacao de clientes"
cDesc2    := "aniversariando no mes selecionado nos parame-"
cDesc3    := "tros."
cNatureza := ""
aReturn   := {"Financeiro", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATANC2"
cPerg     := "FATANC"
nLastKey  := 0
lContinua := .T.
wnrel     := "FATANC2"
M_PAG     := 1

Pergunte( cPerg, .F. )               // Pergunta no SX1
        
cString := "SA1"  

titulo  := "Relacao de Aniversariantes"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE( 10 )
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FATANC",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FATANC2"            //Nome Default do relatorio em Disco

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F.,"", , Tamanho )
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1  := "Código Lj Cliente                                   Responsavel                     Telefone                   Data de Aniversario"
          //999999 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXX     99 de Janeiro
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          //         10        20        30        40        50        60        70        80        90        100       110       120       130
cabec2  := ""

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

aMES := { 'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho', 'Julho',;
          'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro' }

cMES := aMES[ Val( mv_par01 ) ]
nCLI := 0

//Filtro arquivo SA1
/*dbselectArea("SA1")
cFiltro := "A1_COD>=mv_par02.and.A1_COD<=mv_par03.and.StrZero( Month( A1_DTNASC ), 2 )==StrZero( Val( MV_PAR01 ), 2 )"
cChave  := "DTOS(A1_DTNASC)"
cIndSA1 := CriaTrab( nil, .f. )
IndRegua( "SA1", cIndSA1, cChave, , cFiltro, "Selecionando Clientes...." )
SA1->( dbGoTop() )*/

SA1->( dbCloseArea() )
cQuery := "select	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NMRESPO, SA1.A1_TEL, SA1.A1_DTNASC, SA1.A1_VEND, "
cQuery += "SA3.A3_COD, SA3.A3_NREDUZ "
cQuery += "from	SA1010 SA1 left outer join SA3010 SA3 on SA1.A1_VEND = SA3.A3_COD "
cQuery += "where	SA1.A1_COD between '"+ mv_par02 +"' and '"+ mv_par03 +"' and month(SA1.A1_DTNASC) = '"+ mv_par01 +"' "
cQuery += "and SA1.A1_DTNASC != '' "
cQuery += "and SA1.A1_FILIAL = '  ' and SA1.D_E_L_E_T_ != '*' "
cQuery += "and SA3.A3_FILIAL = '  ' and SA3.D_E_L_E_T_ != '*' "
cQuery += "order by SA3.A3_COD, SA1.A1_DTNASC "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'SA1'
SA1->( dbGoTop() )


SetRegua( 0 )

while SA1->( !Eof() )
  cVendor := SA1->A3_COD  
  cVendNm := SA1->A3_NREDUZ
  do while (cVendor == SA1->A3_COD) .and. SA1->( !Eof() )
	   if nLin > 50
	      reltit  := "Relacao de Aniversariantes - " + cMES
	      nLin := cabec( reltit, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1
	   endif
	   @ nLin, 000 pSay SA1->A1_COD
	   @ nLin, 007 pSay SA1->A1_LOJA
	   @ nLin, 010 pSay SA1->A1_NOME
	   @ nLin, 052 pSay SA1->A1_NMRESPO
	   @ nLin, 084 pSay SA1->A1_TEL
	   @ nLin, 114 pSay substr(SA1->A1_DTNASC,7,2) + " de " + cMES//StrZero( Day( ctod( SA1->A1_DTNASC ) ), 2 ) + " de " + cMES
	   nCLI := nCLI + 1   
	   nLin := nLin + 1
	
	   SA1->( dbSkip() )
	   IncRegua()    
  endDo
   @ nLin, 000	PSAY "Pertence(m) ao vendedor: " + alltrim(cVendNm) + " Codigo: " + alltrim(cVendor)
	nLin += 2
	if nLin > 50
      nLin := cabec( "Relacao de Aniversario de 1ª Compra - " + cMES , cabec1, cabec2, nomeprog, "G", 15 ) + 1
   endif
enddo

@ nLin, 000 pSay Replicate( "-", 132 )
nLin := nLin + 1
@ nLin,000 pSay "Total de Aniversariantes no Periodo ==>"
@ nLin,055 pSay nCLI Picture "@E 999999"

//Relatorio de Aniversario de Primeira Compra de Cliente

//Filtro arquivo SA1
/*dbselectArea("SA1")
cFiltro := "A1_COD>=mv_par02.and.A1_COD<=mv_par03.and.Year(Date())-Year(SA1->A1_PRICOM)>=1.and.StrZero(Month(A1_PRICOM),2)==StrZero(Val(MV_PAR01),2)"
cChave  := "DTOS(A1_PRICOM)"
cIndSA1 := CriaTrab( nil, .f. )
IndRegua( "SA1", cIndSA1, cChave, , cFiltro, "Selecionando Clientes...." )
SA1->( dbGoTop() )
*/
SetRegua( 0 )
SA1->( dbCloseArea() )
cQuery1 := "select	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NMRESPO, SA1.A1_TEL, SA3.A3_COD, SA3.A3_NREDUZ, "
cQuery1 += "SA1.A1_PRICOM, SA1.A1_NROCOM "
cQuery1 += "from	SA1010 SA1 left outer join SA3010 SA3 on SA1.A1_VEND = SA3.A3_COD "
cQuery1 += "where	SA1.A1_COD between '"+ mv_par02 +"' and '"+ mv_par03 +"' and (Year( getdate() )- Year( SA1.A1_PRICOM )) >= 1 "
cQuery1 += "and month(SA1.A1_PRICOM) = '"+ MV_PAR01 +"' and SA1.A1_NROCOM > 0 "
cQuery1 += "and SA1.A1_FILIAL = '  ' and SA1.D_E_L_E_T_ != '*' "
cQuery1 += "and SA3.A3_FILIAL = '  ' and SA3.D_E_L_E_T_ != '*' "
cQuery1 += "order by SA3.A3_COD, SA1.A1_PRICOM "
cQuery1 := changeQuery( cQuery1 )
TCQUERY cQuery1 NEW ALIAS 'SA1'
SA1->( dbGoTop() )

cabec1  := "Código Lj Cliente                                   Responsavel                     Telefone                   1ªCompra  Tempo       Nr. Compras  Prz.Med.Comp"
          //999999 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99  99 Anos(s)       999999    9999 Dia(s)
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          //         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160
cabec2  := ""

nLin := 80
nCLI := 0

while SA1->( !Eof() )
  cVendor := SA1->A3_COD  
  cVendNm := SA1->A3_NREDUZ
  do while (cVendor == SA1->A3_COD) .and. SA1->( !Eof() )
   if nLin > 50
      nLin := cabec( "Relacao de Aniversario de 1ª Compra - " + cMES , cabec1, cabec2, nomeprog, "G", 15 ) + 1
   endif

   @ nLin, 000 pSay SA1->A1_COD
   @ nLin, 007 pSay SA1->A1_LOJA
   @ nLin, 010 pSay SA1->A1_NOME
   @ nLin, 052 pSay SA1->A1_NMRESPO
   @ nLin, 084 pSay alltrim(SA1->A1_TEL)
   @ nLin, 111 pSay STOD( SA1->A1_PRICOM )
   @ nLin, 121 pSay alltrim(Str( Year( Date() ) - Year( STOD( SA1->A1_PRICOM ) ),4 )) + " Ano(s)"
   @ nLin, 133 pSay Transform( SA1->A1_NROCOM, "@E 999999" )
   @ nLin, 146 pSay Transform( Round( ( Date() - STOD(SA1->A1_PRICOM) ) / SA1->A1_NROCOM, 0 ), "@E 9999" ) + " Dias(s)"  
  
   nCLI := nCLI + 1   
   nLin := nLin + 1

   SA1->( dbSkip() )
   IncRegua()    
   endDo
   @ nLin, 000	PSAY "Pertence(m) ao vendedor: " + alltrim(cVendNm) + " Codigo: " + alltrim(cVendor)
	nLin += 2
	if nLin > 50
      nLin := cabec( "Relacao de Aniversario de 1ª Compra - " + cMES , cabec1, cabec2, nomeprog, "G", 15 ) + 1
   endif
enddo

@ nLin, 000 pSay Replicate( "-", 160 )
nLin := nLin + 1
@ nLin,000 pSay "Total de Aniversariantes de 1ª Compra no Periodo ==>"
@ nLin,055 pSay nCLI Picture "@E 999999"

SA1->( dbCloseArea() )
//roda( cbcont, cbtxt, tamanho )

//dbSelectArea( "SA1" )
//retIndex( "SA1" )

if aReturn[5] == 1
   dbCommitAll()
   ourspool( wnrel )
endif

MS_FLUSH()

Return(.T.)