#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "SHELL.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATGMC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,ASTRUT,CARQ,CARQI,CEXTENSO,CFILTRO")
SetPrvt("CCHAVE,CINDSE1,DVENCTO,CMES,CVENCTO,CDATA")
SetPrvt("CVALEXT,AFIELDS,CPATH,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Diego Araújo                             ³ Data ³ 24/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Geracao de mala direta de NF's                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Rava                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Pergunte("FATGMC",.F.)               // Pergunta no SX1
@ 00,000 To 50,300 Dialog oDlg1 Title "Geracao de Mala Direta"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("FATGMC")
@ 10,060 BMPBUTTON Type 1 Action OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON Type 1 Action Execute(OkProc)
@ 10,100 BMPBUTTON Type 2 Action Close( oDlg1 )
Activate Dialog oDlg1 Center

If Empty( Directory( "R:\" + cARQ, "D" ) )
	Alert("Caminho ou arquivo '" + cARQ + "' nao encontrado. Impossivel abrir o Word. Usuario sem acesso.")
Else
	ShellExecute( 'open', 'R:\Malafat.doc','','', SW_SHOWNORMAL )
EndIf

Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()

cALIASANT := Alias()
cORDERANT := IndexOrd()
Close( oDlg1 )
If SM0->M0_CODIGO == "02"
   Processa( {|| Fat_Gmc() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Processa( {|| Execute(Fin_Gmc) } )
Else
   Aviso("M E N S A G E M", "Entre na Empresa 02 - RAVA", {"OK"})
Endif

Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Fin_Gmc
Static Function Fat_Gmc()

   SA1->( DBSetOrder( 1 ) )

   aSTRUT  := {}
   aadd( aSTRUT, { "CHAVE"  , "C",  01 , 0 } )
   aadd( aSTRUT, { "CLIENTE", "C",  41 , 0 } )
   aadd( aSTRUT, { "NUM"    , "C",  10 , 0 } )
   aadd( aSTRUT, { "DATAE"  , "C",  18 , 0 } )
   aadd( aSTRUT, { "VALOR"  , "C",  18 , 0 } )
   aadd( aSTRUT, { "TRANS"  , "C",  35 , 0 } )
   aadd( aSTRUT, { "CONTATO", "C",  20 , 0 } )

   cARQ  := criatrab( aSTRUT, .T. )
   use ( cARQ ) alias TIT new
   Index on CHAVE + CLIENTE + NUM to ( cARQ )

//  DBSelectArea("SF2")
   cFILTRO  := "F2_CLIENTE >= mv_par01 .And. F2_CLIENTE <= mv_par02 .and. SF2->F2_PREFIXO >= mv_par03 .And. SF2->F2_PREFIXO <= mv_par04 " + ;
               ".And. SF2->F2_EMISSAO >= mv_par05 .And. SF2->F2_EMISSAO <= mv_par06"
   cCHAVE   := "F2_CLIENTE+F2_DOC"

   cIndSF2 := CriaTrab( NIL, .F. )
   IndRegua( "SF2", cIndSF2, cCHAVE,, cFILTRO, "Selecionando Notas..." )

   SF2->( DBGoTop() )

   dVENCTO := dDATABASE
   cMES    := Space( 03 )
   MESEXT()

   TIT->( DBAppend() )
   TIT->CHAVE   := " "
   TIT->CLIENTE := "NOME"
   TIT->TRANS   := ";TRANS"
   TIT->NUM     := ";NUM"
   TIT->DATAE   := ";DATA"
   TIT->VALOR   := ";VALOR"
   TIT->CONTATO := ";CONTATO"

   TIT->( DBCommit() )
   While ! SF2->( EOF() )
      SA1->( DBSeek( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA) )
      SA4->( DBSeek( xFilial("SA4") + SF2->F2_TRANSP) )
     If  !((Len( Alltrim(SA4->A4_NOME) ) <= 7))
       TIT->( DBAppend() )
       TIT->CHAVE   := "*"
       TIT->CLIENTE := SA1->A1_NOME
       TIT->CONTATO := ";" + SA1->A1_CONTATO
       TIT->TRANS   := ";" + SA4->A4_NOME


       //dVENCTO := SF2->F2_VENCTO
       //MESEXT()

       TIT->NUM     := ";n§ "+SF2->F2_DOC

       dVENCTO := dDATABASE
       MESEXT()
       cDATA := Space(17)
       cDATA := Right( DToS(dDATABASE),2 ) + " de " + cMES + " de " + ;
                Left( DToS(dDATABASE),4 )
       TIT->DATAE  := ";"+cDATA
       TIT->VALOR := ";R$ "+Transf(SF2->F2_VALFAT,"@R 999,999.99")
       TIT->( DBCommit() )
	  EndIf
      SF2->( DBSkip() )
   Enddo


DBSelectArea("TIT")
cARQ := "Malafat.txt"
aFields := { "CLIENTE", "NUM" }
//cPATH := "\RELATO\" + cARQ
aUsuario := PswRet()
cPATH := Alltrim(aUsuario[2,3]) + cARQ
Copy Fields CLIENTE,TRANS,NUM,DATAE,VALOR,CONTATO To ( cPATH ) SDF
TIT ->( DBCloseArea() )
RetIndex("SF2")
RetIndex("SA1")
DbSelectArea( cALIASANT )
Dbsetorder( cORDERANT )
Return

****************
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function MESEXT
Static Function MESEXT()
****************
      If Month(dVENCTO) == 1
         cMES := "Jan"
      ElseIf Month(dVENCTO) == 2
         cMES := "Fev"
      ElseIf Month(dVENCTO) == 3
         cMES := "Mar"
      ElseIf Month(dVENCTO) == 4
         cMES := "Abr"
      ElseIf Month(dVENCTO) == 5
         cMES := "Mai"
      ElseIf Month(dVENCTO) == 6
         cMES := "Jun"
      ElseIf Month(dVENCTO) == 7
         cMES := "Jul"
      ElseIf Month(dVENCTO) == 8
         cMES := "Ago"
      ElseIf Month(dVENCTO) == 9
         cMES := "Set"
      ElseIf Month(dVENCTO) == 10
         cMES := "Out"
      ElseIf Month(dVENCTO) == 11
         cMES := "Nov"
      ElseIf Month(dVENCTO) == 12
         cMES := "Dez"
      Endif

Return NIL

