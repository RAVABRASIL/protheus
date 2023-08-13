#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FINGMC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
±±³  Autor  ³ Adenildo Macedo de Almeida               ³ Data ³ 09/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Geracao de mala direta de titulos a receber                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Rava                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Pergunte("FINGMC",.F.)               // Pergunta no SX1
@ 00,000 To 50,300 Dialog oDlg1 Title "Geracao de Mala Direta"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("FINGMC")
@ 10,060 BMPBUTTON Type 1 Action OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON Type 1 Action Execute(OkProc)
@ 10,100 BMPBUTTON Type 2 Action Close( oDlg1 )
Activate Dialog oDlg1 Center
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()
cALIASANT := Alias()
Close( oDlg1 )
If SM0->M0_CODIGO=="02"
   Processa( {|| Fin_Gmc() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Processa( {|| Execute(Fin_Gmc) } )
Else
   Aviso("M E N S A G E M", "Entre na Empresa 02 - RAVA", {"OK"})
Endif

Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Fin_Gmc
Static Function Fin_Gmc()

   DBSelectArea("SA1")
   SA1->( DBSetOrder(1) )

   aSTRUT  := {}
   aadd( aSTRUT, { "CHAVE"  , "C",  01 , 0 } )
   aadd( aSTRUT, { "CLIENTE", "C",  41 , 0 } )
   aadd( aSTRUT, { "VENCTO" , "C",  18 , 0 } )
   aadd( aSTRUT, { "NUM"    , "C",  10 , 0 } )
   aadd( aSTRUT, { "DATAE"  , "C",  18 , 0 } )
   aadd( aSTRUT, { "VALOR"  , "C",  18 , 0 } )
   aadd( aSTRUT, { "EXT"    , "C",  151, 0 } )
   aadd( aSTRUT, { "JUROS"  , "C",  15 , 0 } )
   aadd( aSTRUT, { "CONTA"  , "C",  15 , 0 } )
   aadd( aSTRUT, { "AGENCIA", "C",  10 , 0 } )
   aadd( aSTRUT, { "BANCO"  , "C",  21 , 0 } )
   aadd( aSTRUT, { "BENEF"  , "C",  31 , 0 } )

   cARQ  := criatrab( aSTRUT,.T. )
   cARQI := criatrab( .f.,.f. )
   use (cARQ) alias TIT new
   index on CHAVE+CLIENTE+VENCTO+NUM to (cARQI)

   //cEXTENSO := Padr(Extenso(522),200,"*")
   //Aviso("M E N S A G E M", cEXTENSO, {"OK"})

   cQuery := "SELECT E1_NUM,SE1.E1_VENCTO,E1_SALDO,E1_CLIENTE,E1_LOJA "
   cQuery += "FROM " + RetSqlName( "SE1" ) + " SE1 "
   cQuery += "WHERE E1_CLIENTE >= '" + mv_par01 + "' AND E1_CLIENTE <= '" + mv_par02 + "' AND "
   cQuery += "E1_PREFIXO >= '" + mv_par03 + "' AND E1_PREFIXO <= '" + mv_par04 + "' AND "
   cQuery += "E1_EMISSAO >= '" + Dtos( mv_par05 ) + "' AND E1_EMISSAO <= '" + Dtos( mv_par06 ) + "' AND "
   cQuery += "E1_VENCTO >= '" + Dtos( mv_par07 ) + "' AND E1_VENCTO <= '" + Dtos( mv_par08 ) + "' AND "
	 cQuery += "E1_SALDO > 0 AND E1_FILIAL = '" + xFilial( "SE1" ) + "' AND "
   cQuery += "D_E_L_E_T_ = ' ' "
	 cQuery += "ORDER BY E1_CLIENTE,E1_VENCTO,E1_NUM "
   cQuery := ChangeQuery( cQuery )
   TCQUERY cQuery NEW ALIAS "SE1X"
	 TCSetField( 'SE1X', "E1_VENCTO", "D" )

   SE1X->( DBGoTop() )

   //cARQ := "Malacli.txt"

   //Copy To &cARQ Fields E1_CLIENTE,DTOC(E1_VENCTO),E1_NUM  Delimited With ";"

   dVENCTO := dDATABASE
   cMES    := Space(03)
   MESEXT()

   TIT->( DBAppend() )
   TIT->CHAVE   := " "
   TIT->CLIENTE := "NOME"
   TIT->VENCTO  := ";VENCTO"
   TIT->NUM     := ";NUM"
   TIT->DATAE   := ";DATA"
   TIT->VALOR   := ";VALOR"
   TIT->EXT     := ";EXT"
   TIT->JUROS   := ";JUROS"
   TIT->CONTA   := ";CONTA"
   TIT->AGENCIA := ";AGENCIA"
   TIT->BANCO   := ";BANCO"
   TIT->BENEF   := ";BENEF"
   TIT->( DBCommit() )
   While  ! SE1X->( EOF() )
      SA1->( DBSeek( xFilial( "SA1" ) + SE1X->E1_CLIENTE + SE1X->E1_LOJA ) )
       TIT->( DBAppend() )
       TIT->CHAVE   := "*"
       TIT->CLIENTE := SA1->A1_NOME

       dVENCTO := SE1X->E1_VENCTO
       MESEXT()

       cVENCTO := Space(17)
       cVENCTO := Right( DToS(SE1X->E1_VENCTO),2 ) + " de " + cMES + " de " + ;
                  Left( DToS(SE1X->E1_VENCTO),4 )
       //TIT->VENCTO  := ";"+DToC(SE1X->E1_VENCTO)
       TIT->VENCTO  := ";"+cVENCTO
       TIT->NUM     := ";n§ "+SE1X->E1_NUM

       dVENCTO := dDATABASE
       MESEXT()
       cDATA := Space(17)
       cDATA := Right( DToS(dDATABASE),2 ) + " de " + cMES + " de " + ;
                Left( DToS(dDATABASE),4 )
       TIT->DATAE  := ";"+cDATA

       cVALEXT := Padr(Extenso(SE1X->E1_SALDO),150,"*")
       TIT->VALOR := ";R$ "+Transf(SE1X->E1_SALDO,"@R 999,999.99")
       TIT->EXT   := ";"+ cVALEXT
       TIT->JUROS := ";R$ "+Transf(SE1X->E1_SALDO*0.0023,"@R 999,999.99")
       TIT->CONTA   := ";n§ "+mv_par09
       TIT->AGENCIA := ";n§ "+mv_par10
       TIT->BANCO   := ";"+mv_par11
       TIT->BENEF   := ";"+mv_par12
       TIT->( DBCommit() )
      SE1X->( DBSkip() )
   Enddo


DBSelectArea("TIT")
cARQ := "Malacli.txt"
aFields := {"CLIENTE","VENCTO","NUM"}
cPATH := "\RELATO\" + (cARQ)
Copy Fields CLIENTE,VENCTO,NUM,DATAE,VALOR,EXT,SALDO,JUROS,CONTA,AGENCIA,BANCO,BENEF To (cPATH) SDF
TIT->( DBCloseArea() )
SE1X->( DBCloseArea() )
DbSelectArea( cALIASANT )
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


