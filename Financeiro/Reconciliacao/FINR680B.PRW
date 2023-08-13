#include "FINR680A.CH"
#Include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FINR680B ³ Autor ³ Alessandro de Farias  ³ Data ³ 11.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Bancario - Via CNAB                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR680B                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FINR680B()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1 := STR0001  //"Este relat¢rio ir  emitir o extrato bancario via padr„o CNAB."
LOCAL cDesc2 := STR0002  //"Para que o mesmo seja emitido, dever  ser efetuado a configu-"
LOCAL cDesc3 := STR0003  //"ra‡„o conforme documenta‡„o do banco."
LOCAL cString:="Z15"
LOCAL Tamanho:="M"

PRIVATE titulo := OemToAnsi(STR0004)  //"Extrato Bancario - Via CNAB"
PRIVATE cabec1 := OemToAnsi(STR0005)  //"DATA      DOCUM     HISTORICO                             CREDITO              DEBITO               SALDO"
PRIVATE cabec2 := "" , wnrel
PRIVATE aReturn := { OemToAnsi(STR0006), 1,OemToAnsi(STR0007), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog := "FINR680B"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "FIN68B"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg(cPerg)

pergunte("FIN68B",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros 		³
//³ mv_par01       // Do Banco         	   ³
//³ mv_par02       // Da Agencia       	   ³
//³ mv_par03       // Da Conta       	      ³
//³ mv_par04       // Data Inicial           ³
//³ mv_par05       // Data Final             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR680B"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa680Imp(@lEnd,wnRel,cString)},Titulo)
Return

***************
Static Function ValidPerg(cPerg)
***************

PutSx1(cPerg,'01','Do Banco     ?','Do Banco     ?','Do Banco     ?','mv_ch1','C',03,0,0,'G','','SA6','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'02','Da Agencia   ?','Da Agencia   ?','Da Agencia   ?','mv_ch2','C',04,2,2,'G','',''   ,'','','mv_par02','','','','','','','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'03','Da Conta     ?','Da Conta     ?','Da Conta     ?','mv_ch3','C',10,2,2,'G','',''   ,'','','mv_par03','','','','','','','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'04','Data Inicial ?','Data Inicial ?','Data Inicial ?','mv_ch4','D',08,2,2,'G','',''   ,'','','mv_par04','','','','','','','','','','','','','','','','',{},{},{})
PutSx1(cPerg,'05','Data Final   ?','Data Final   ?','Data Final   ?','mv_ch5','D',08,2,2,'G','',''   ,'','','mv_par05','','','','','','','','','','','','','','','','',{},{},{})

Return Nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ FA680Imp ³ Autor ³ Lu¡s C. Cunha         ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Retorno do Extrato Banc rio                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA680Imp(lEnd,wnRel,cString)

LOCAL CbTxt := space(10)
LOCAL CbCont := 0
LOCAL tamanho := "M"
LOCAL nHdlConf
LOCAL nHdlBco
LOCAL cData, dData , nValor , nTotCred , nTotDeb
LOCAL nLidos := 0
LOCAL aPosicoes:={ }
LOCAL nSaldoInicial := 0
Local lFebraban := .F.
Local cSitLanc := ""
Local cCtaArq := ""
Local cAgeArq := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no cadastro de bancos.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! (SA6->(dbSeek( xFilial("SA6")+mv_par01+mv_par02+mv_par03 ) ) )
	Set Device To Screen
	Help(" ",1, "AFR680BCO" )
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ja existe movimento.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! Z15->( DbSeek( xFilial("Z15")+mv_par01+mv_par02+mv_par03+DTOS(mv_par04)+"0" ) )
	Set Device To Screen
	Help("   ",1,"Z15_DTMOV")
	Return
Endif

ProcRegua(100) // Numero de registros a processar

cSeek := Z15->Z15_FILIAL+Z15->Z15_BANCO+Z15->Z15_AGENCIA+Z15->Z15_NUMCON+DTOS(Z15->Z15_DTCNAB)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )

Do While ! Z15->( Eof() )// .and. ZA1->ZA1_FILIAL+ZA1->ZA1_BANCO+ZA1->ZA1_AGENCIA+ZA1->ZA1_NUMCON+DTOS(ZA1->ZA1_DTCNAB) == cSeek

	cSeek := Z15->Z15_FILIAL+Z15->Z15_BANCO+Z15->Z15_AGENCIA+Z15->Z15_NUMCON+DTOS(Z15->Z15_DTCNAB)
	
	Do While ! Z15->( Eof() ) .and. Z15->Z15_FILIAL+Z15->Z15_BANCO+Z15->Z15_AGENCIA+Z15->Z15_NUMCON+DTOS(Z15->Z15_DTCNAB) == cSeek
		
		If Z15->Z15_TIPO == "0"
			/*
			If Prow() + 5 > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )
			Endif
			*/
			@ Prow()+1,00 PSAY repl("*",16)
			@ Prow()+0,35 PSAY repl("*",45)
			@ Prow()+1,00 PSAY Alltrim(Z15->Z15_AGENCIA)+"/"+Alltrim(Z15->Z15_NUMCON)
			@ Prow()+0,35 PSAY Left(Z15->Z15_HIST,15)
			@ Prow()+0,52 PSAY DTOC(Z15->Z15_DATA)
			@ Prow()+0,Iif( Z15->Z15_TPDC == "C", 85,105 ) PSAY Z15->Z15_VALOR Picture "@E 9999,999,999.99"
			@ Prow()+1,00 PSAY repl("*",16)
			@ Prow()+0,35 PSAY repl("*",45)
			
		ElseIf Z15->Z15_TIPO == "1"
			
			If Prow() > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )
			Endif
			
			@ Prow()+1,00 PSAY DTOC(Z15->Z15_DATA)
			@ Prow()+0,10 PSAY Z15->Z15_DOCUMEN
			@ Prow()+0,20 PSAY Z15->Z15_HIST
			@ Prow()+0,Iif( Z15->Z15_TPDC == "C", 85,105 ) PSAY Z15->Z15_VALOR Picture "@E 9999,999,999.99"
			
		ElseIf Z15->Z15_TIPO == "2"
			
			@ Prow()+1,35 PSAY repl("*",45)
			@ Prow()+1,35 PSAY Left(Z15->Z15_HIST,15)
			@ Prow()+0,52 PSAY DTOC(Z15->Z15_DATA)
			@ Prow()+0,Iif( Z15->Z15_TPDC == "C", 85,105 ) PSAY Z15->Z15_VALOR Picture "@E 9999,999,999.99"
			
		ElseIf Z15->Z15_TIPO == "9"
			@ Prow()+1,35 PSAY OemToAnsi(STR0009)  //"TOTAL CREDITOS"
			@ Prow()+0,65 PSAY Z15->Z15_TOTCRE Picture "@E 9999,999,999.99"
			@ Prow()+1,35 PSAY OemToAnsi(STR0010)  //"TOTAL DEBITOS "
			@ Prow()+0,65 PSAY Z15->Z15_TOTDEB Picture "@E 9999,999,999.99"
			@ Prow()+1,35 PSAY repl("*",45)

			Z15->( DbSkip() )
			
         If ! Z15->( Eof() )
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )
			Endif
			
			Z15->( DbSkip(-1) )
			
		Endif
		
		Z15->( DbSkip() )
		
	Enddo
	
Enddo

Roda(cbcont,cbtxt,"M")
Set( 20, "SCREEN" )
If aReturn[5] = 1
	Set( 24, "" )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return