#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATPMC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
±±³Programa  ³  FATPMC  ³ Autor ³   Eurivan Marques     ³ Data ³ 14/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Prazo Medio de Faturamento e Recebimento      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01        	// De Cliente                                 ³
//³ mv_par02        	// Ate Cliente                                ³
//³ mv_par03        	// De Emissao                                 ³
//³ mv_par04        	// Ate a Emissao                              ³
//³ mv_par05        	// Considera a vista 1-Sim, 2-Nao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt   := ""
CbCont  := ""
nOrdem  := 0
Alfa    := 0
Z       := 0
M       := 0
tamanho := "M"
limite  := 254

cDesc1    := "Este programa ira Emitir relacao de prazo medio"
cDesc2    := "de Faturamento e Recebimento"
cDesc3    := ""
cNatureza := ""
aReturn   := { "Financeiro", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATPMC"
cPerg     := "FATPMC"
nLastKey  := 0
lContinua := .T.
wnrel     := "FATPMC"
M_PAG     := 1

Pergunte( cPerg, .F. )               // Pergunta no SX1
        
cString := "SE1"  

titulo  := "Relat. de Prz. Med. Fat. e Rec."



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
pergunte("FATPMC",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FATPMC"            //Nome Default do relatorio em Disco

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "", , Tamanho )
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

cabec1  := "Código Lj Nome do Cliente                           Prz.Med.Fat.  Prz.Med.Rec."
          //999999 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        999999        999999
cabec2  := ""

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

dbSelectArea( "SE1" )
SE1->( dbsetorder( 2 ) )

dbSelectArea( "SE5" )
SE5->( dbsetorder( 7 ) )

SE1->( dbSeek( xFilial( "SE1" ) + AllTrim( mv_par01 ) ) )
Count To nREGTOT While SE1->E1_CLIENTE <= MV_PAR02
SetRegua( nREGTOT )

SE1->( dbSeek( xFilial( "SE1" ) + AllTrim( mv_par01 ) ) )
nTITF  := nTITR  := nPRZFAT := nPRZREC := nTOTF := nTOTR := 0  
nTITFT := nTITRT := nPRZTF  := nPRZTR  := 0      
nCLI   := 0
cCliente := SE1->E1_CLIENTE
cLoja    := SE1->E1_LOJA 

while SE1->( !Eof() ) .And. SE1->E1_CLIENTE <= mv_par02
   if nLin > 50
      if mv_par03 = 1
         reltit  := "Relat. de Prz. Med. Fat. e Rec. - C/ A VISTA"
      else
         reltit  := "Relat. de Prz. Med. Fat. e Rec. - S/ A VISTA"
      endif
      nLin := cabec( reltit, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1
   endif
   
   while SE1->( !Eof() ) .And. SE1->E1_CLIENTE = cCliente    
      if mv_par03 = 2 .and. ( SE1->E1_VENCREA - SE1->E1_EMISSAO ) <= 7
         SE1->( dbSkip() )
         IncRegua()
      else   
         if !Empty( SE1->E1_BAIXA )
            if SE5->( dbSeek( xFilial( "SE5" ) + SE1->E1_PREFIXO + SE1->E1_NUM +;
                                              SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE, .t. ) )
               dBaixa := SE5->E5_DATA
               while SE5->( !Eof() ) .And. SE5->E5_PREFIXO + SE5->E5_NUMERO == SE1->E1_PREFIXO + SE1->E1_NUM .AND.;
                     SE5->E5_CLIFOR = cCliente
                  if SE5->E5_MOTBX # "DAC"
                     dBaixa := SE5->E5_DATA
                  endif
                  SE5->( dbSkip() )
               enddo
            endif

            nPRZREC := nPRZREC + ( dBaixa - SE1->E1_EMISSAO )
            nTITR   := nTITR + 1
         endif
         nPRZFAT := nPRZFAT + ( SE1->E1_VENCREA - SE1->E1_EMISSAO )
         nTITF   := nTITF + 1
      endif
      SE1->( dbSkip() )
      IncRegua()
   enddo 
   nCLI := nCLI + 1

   SA1->( dbSeek( xFilial( "SA1" ) + cCliente, .T. ) )
   cCod    := SA1->A1_COD
   cNome   := SA1->A1_NOME

   nPRZFAT := Round( nPRZFAT / nTITF, 0 )
   nPRZREC := Round( nPRZREC / nTITR, 0 )

   nPRZTF := nPRZTF + nPRZFAT
   nPRZTR := nPRZTR + nPRZREC            

   @ nLin, 000 pSay cCod
   @ nLin, 007 pSay cLoja
   @ nLin, 010 pSay cNome
   @ nLin, 058 pSay nPRZFAT Picture "@E 999999"
   @ nLin, 072 pSay nPRZREC Picture "@E 999999"
      
   nTITF := nTITR := nPRZFAT := nPRZREC := 0  
   cCliente := SE1->E1_CLIENTE
   cLoja    := SE1->E1_LOJA
   nLin := nLin + 1
enddo

@ nLin, 000 pSay Replicate( "-", 132 )
nLin := nLin + 1
@ nLin,000 pSay "Media Geral ==>"
@ nLin,058 pSay Round( nPRZTF / nCLI, 0 )  Picture "@E 999999"
@ nLin,072 pSay Round( nPRZTR / nCLI, 0 )  Picture "@E 999999"

roda( cbcont, cbtxt, tamanho )

dbSelectArea( "SE1" )
retIndex( "SE1" )

if aReturn[5] == 1
   dbCommitAll()
   ourspool( wnrel )
endif

MS_FLUSH()

Return(.T.)