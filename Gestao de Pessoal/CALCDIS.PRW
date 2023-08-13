#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Diego Araújo                             ³ Data ³ 15/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Calculo do dissidio coletivo                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Rava                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±Parametros : MV_PAR01 - Funcao de                                       ±±
±±						 MV_PAR02 - Funcao Ate                                      ±±
±±						 MV_PAR03 - Porcentagem de aumento                          ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

User Function CALCDIS()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

SetPrvt("nLin, nTOTSAL, nTOTSALANT ")
Private aFUNC := {}

If ! Pergunte( "CALDIS" )
   Return NIL
EndIf
MsAguarde( { || Calculo() },"Calculo do dissidio coletivo","Processando..." )
Return NIL



*********************

Static Function CALCULO

********************

SRJ->( DBsetorder ( 1 ))
SRA->( DBsetorder ( 7 ))
SRJ->( DBSeek( xFilial("SRJ") + MV_PAR01, .T.) )

Do while SRJ->RJ_FUNCAO <= MV_PAR02 .AND. ! SRJ->( EOF() )
		Reclock( "SRJ", .F. )
 		SRJ->RJ_SALARIO *= ( 1 + ( MV_PAR03 / 100 ) )
		MSunlock()
  	nTOTSALANT := 0
  	SRA->( DBSeek( xFilial( "SRA" ) + SRJ->RJ_FUNCAO ) )
  	Do while SRA->RA_CODFUNC == SRJ->RJ_FUNCAO
  		 if (SRA->RA_SITFOLH == " ") .OR. (SRA->RA_SITFOLH == "A") .OR. (SRA->RA_SITFOLH == "F")
  		  	Reclock( "SRA", .F. )
  			  nTOTSALANT      += SRA->RA_SALARIO
  				SRA->RA_ANTEAUM := SRA->RA_SALARIO
	  		  SRA->RA_SALARIO := SRJ->RJ_SALARIO
  			  MSunlock()
  				Aadd( aFUNC, { SRA->RA_MAT, SRA->RA_ANTEAUM } )
  		 endif
  		 SRA->( Dbskip() )
	enddo
	DBcommitAll()
	SRJ->( dbskip() )
enddo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Variaveis usadas no relatorio       '                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±Parametros : MV_PAR01 - Funcao de                                       ±±
//±±						 MV_PAR02 - Funcao Ate                                      ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

@ 00,000 To 50,300 Dialog oDlg1 Title "DESEJA IMPRIMIR RELATORIO ?"
@ 10,030 BMPBUTTON Type 1 Action OkProc()   // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON Type 1 Action Execute(OkProc)
@ 10,070 BMPBUTTON Type 2 Action Close( oDlg1 )
Activate Dialog oDlg1 Center
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()


cDESC1   := "Apresentação do Relarorio do Dissidio Coletivo"
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "Gestao Pessoal", 2, 2, 1, "", 1 }
cARQUIVO := "SRJ"
aORD     := {}
cNOMREL  := "IMPDIS"
cTITULO  := "Dissidio Coletivo"
nLASTKEY := 0
cTAMANHO := "M"
M_PAG    := 1

/*----------------------------------------------------------------
  INÍCIO DO PROCESSAMENTO DO RELATÓRIO
  ----------------------------------------------------------------
*/

Pergunte( 'IMPDIS', .F. )

cNOMREL := setprint( cARQUIVO, cNOMREL, "IMPDIS", @cTITULO, cDESC1, cDESC2, cDESC3, .F. )
If nLastKey == 27
   Return
Endif

setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif

nMIDIA := aRETURN[ 5 ]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1  := "Matricula  Funcionario                               Salario Antigo                  Salario Novo                   (%) Aumento        "
          //999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXX        XXXXXXXXXXXXXXXXXXXXXXXXX      100%
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          //         10        20        30        40        50        60        70        80        90        100       110       120       130
cabec2  := ""

nLin := Cabec(CTITULO,cabec1,cabec2,CNOMREL,CTAMANHO,15) + 1 //Impressao do cabecalho
nTOTSAL := 0

SRA->( DBsetorder ( 3 ))
SRA-> ( DBSeek( xFilial("SRA") , .T.))
while ! SRA->( Eof() )
 	 if (SRA->RA_SITFOLH == " ") .OR. (SRA->RA_SITFOLH == "A") .OR. (SRA->RA_SITFOLH == "F")
	   	@ nLin, 000 pSay SRA->RA_MAT
		  @ nLin, 011 pSay SRA->RA_NOME
		  @ nLin, 052 pSay "R$ " + alltrim( Trans( aFUNC[ Ascan( aFUNC, {|X| X[ 1 ] == SRA->RA_MAT } ), 2 ], "@E 999,999,999.99"))
		  @ nLin, 086 pSay "R$ " + alltrim( Trans( SRA->RA_SALARIO, "@E 999,999,999.99"))
		  @ nLin, 119 pSay MV_PAR03
    	nLin    += 1
	    nTOTSAL += SRA->RA_SALARIO
	endif
	SRA->( dbskip() )
enddo

@ nLin, 000 pSay Replicate( "-", 160 )
nLin := nLin + 1
@ nLin,000 pSay "Total de Salario dos funcionarios ==>"
@ nLin,052 pSay nTOTSALANT picture "@E 999,999,999.99"
@ nLin,086 pSay nTOTSAL picture "@E 999,999,999.99"

If aReturn[ 5 ] == 1
   dbCommitAll()
   ourspool( cNOMREL )
Endif

MS_FLUSH()
Close( oDlg1 )

return
return NIL

