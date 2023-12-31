#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function COMEQL()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  �  COMEQL  � Autor �   Eurivan Marques     � Data � 20/01/03 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Relatorio de Entradas de MP por QUILO                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis Ambientais                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                              �
//� mv_par01        	// De Emissao                                    �
//� mv_par02        	// Ate Emissao                                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

CbTxt   := ""
CbCont  := ""
nOrdem  := 0
Alfa    := 0
Z       := 0
M       := 0
tamanho := "P"
limite  := 254

cDesc1    := "Este programa ira emitir a quantidade de "
cDesc2    := "Materia Prima adquirida no periodo."
cDesc3    := ""
cNatureza := ""
aReturn   := {"Compras", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "COMEQL"
cPerg     := "COMEQL"
nLastKey  := 0
lContinua := .T.
wnrel     := "COMEQL"
M_PAG     := 1

Pergunte( cPerg, .F. )               // Pergunta no SX1
        
cString := "SD1"  

titulo  := "Quantidade de M.P."

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt    := SPACE( 10 )
cbcont   := 0
nLin     := 80
m_pag    := 1

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte("COMEQL",.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel := "COMEQL"            //Nome Default do relatorio em Disco

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F.,"", , Tamanho )
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Definicao dos cabecalhos                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

cabec1  := "Produtos                      Quant. em Quilos      Valor Total"
          //Materia Prima - Prod (MP)         9.999.999,99     9.999.999,99
          //012345678901234567890123456789012345678901234567890123456789012
          //         10        20        30        40        50        60
cabec2  := ""

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

//Filtro arquivo SD1
dbselectArea("SD1")
cFiltro := "D1_EMISSAO>=mv_par01.and.D1_EMISSAO<=mv_par02.and.LEFT(D1_COD,2)='MP'"
cChave  := "DTOS(D1_EMISSAO)"
cIndSD1 := CriaTrab( nil, .f. )
IndRegua( "SD1", cIndSD1, cChave, , cFiltro, "Selecionando Materiais..." )
SD1->( dbGoTop() )

SetRegua( SD1->( Lastrec() ) )

nQTDTOT := nVALTOT := 0

while SD1->( !Eof() )

   if ! Empty( D1_QUANT )
      nQTDTOT := nQTDTOT + D1_QUANT
      nVALTOT := nVALTOT + D1_TOTAL   
   endif   
   SD1->( dbSkip() )
   IncRegua()    
  
enddo

reltit  := "Quant. M.P. - De " + DTOC( MV_PAR01 ) + " ate " + DTOC( MV_PAR02 )
nLin := cabec( reltit, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1
 
@ nLin, 000 pSay "Materia Prima - Prod (MP)"
@ nLin, 034 pSay nQTDTOT Picture '@E 9,999,999.99'
@ nLin, 051 pSay nVALTOT Picture '@E 9,999,999.99'

roda( cbcont, cbtxt, tamanho )

dbSelectArea( "SD1" )
retIndex( "SD1" )

if aReturn[5] == 1
   dbCommitAll()
   ourspool( wnrel )
endif

Return(.T.)