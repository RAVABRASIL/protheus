#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  04/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************

User Function FATRETR

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Eficácia por Região"
Local cPict          := ""
Local titulo       	 := "Relatório de Eficácia por Região"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATRETR" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont     	 := 00
Private CONTFL     	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  04/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************

Local nLin
Local cQuery := ''
//variáveis das regiões do brasil com seus respectivos estados
Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"
//contadores de entregas por região
Local nCTNO := nCTNE := nCTCE := nCTSD := nCTSL := 0
//acumuladores de dias de entrega
Local nDIANO := nDIANE := nDIACE := nDIASD := nDIASL := 0
//variável de pico de entrega (entrega mais demorada)
Local nTOPNO := nTOPNE := nTOPCE := nTOPSD := nTOPSL := 0

cQuery += "select distinct Z04_DOC, F2_DOC, Z04_DATSAI, Z04_DATCHE, Z04_PRAZO, A1_EST, F2_EST "
cQuery += "from   " + retSqlName('Z04') + " Z04, " + retSqlName('SA1') + " SA1, " + retSqlName('SF2') + " SF2 "
cQuery += "where  Z04_FILIAL = '"+xFilial('Z04')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and F2_FILIAL = '"+xFilial('SF2')+"' "
cQuery += "and F2_DOC = Z04_DOC and F2_CLIENTE + F2_LOJA = A1_COD + A1_LOJA "
cQuery += "and F2_EMISSAO between '20070501' and '20070510' "
cQuery += "and Z04_DATCHE != '' and Z04_PRAZO != '' "
cQuery += "and Z04.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' and SF2.D_E_L_E_T_ != '*' "
cQuery += "order by A1_EST "
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
TCSetField('TMP', "Z04_DATSAI", "D")
TCSetField('TMP', "Z04_DATCHE", "D")
TCSetField('TMP', "Z04_PRAZO",  "D")


do While ! TMP->( EOF() )

  if TMP->A1_EST $ cRGNO
    nDIANO += TMP->Z04_DATCHE - TMP->Z04_DATSAI
    iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPNO, nTOPNO := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
    nCTNO++    
  elseIf TMP->A1_EST $ cRGNE
    nDIANE += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)  
    iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPNE, nTOPNE := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
    nCTNE++  
  elseIf TMP->A1_EST $ cRGCE
    nDIACE += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)    
    iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPCE, nTOPCE := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
    nCTCE++  
  elseIf TMP->A1_EST $ cRGSD
    nDIASD += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)    
    iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPSD, nTOPSD := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
    nCTSD++  
  elseIf TMP->A1_EST $ cRGSL
    nDIASL += (TMP->Z04_DATCHE - TMP->Z04_DATSAI)  
    iif(TMP->Z04_DATCHE - TMP->Z04_PRAZO > nTOPSL, nTOPSL := TMP->Z04_DATCHE - TMP->Z04_PRAZO, )
    nCTSL++
  else
  	msgAlert("O estado " + TMP->A1_EST + "nao esta cadastrado em nenhuma regiao! ")
  	return
  endIf
  TMP->( dbSkip() )
endDo

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
//Norte
@PRow() + 1, 000 PSAY "Media de entrega para a regiao NORTE : " + alltrim( str( nDIANO/nCTNO ) ) + " dias."
@PRow() + 1, 000 PSAY "Pico de atraso no periodo para a regia NORTE : " + alltrim( str( nTOPNO ) ) + " dias. "
//Nordeste
@PRow() + 1, 000 PSAY "Media de entrega para a regiao NORDESTE : " + alltrim( str( nDIANE/nCTNE ) ) + " dias."
@PRow() + 1, 000 PSAY "Pico de atraso no periodo para a regia NORDESTE : " + alltrim( str( nTOPNE ) ) + " dias."
//Centro-Oeste
@PRow() + 1, 000 PSAY "Media de entrega para a regiao Centro-Oeste : " + alltrim( str( nDIACE/nCTCE ) ) + " dias."
@PRow() + 1, 000 PSAY "Pico de atraso no periodo para a regia Centro-Oeste : " + alltrim( str( nTOPCE ) ) + " dias."
//Sudeste
@PRow() + 1, 000 PSAY "Media de entrega para a regiao Sudeste : " + alltrim( str( nDIASD/nCTSD ) ) + " dias."
@PRow() + 1, 000 PSAY "Pico de atraso no periodo para a regia Sudeste : " + alltrim( str( nTOPSD ) ) + " dias."
//Sul
@PRow() + 1, 000 PSAY "Media de entrega para a regiao Sul : " + alltrim( str( nDIASL/nCTSL ) ) + " dias."
@PRow() + 1, 000 PSAY "Pico de atraso no periodo para a regia Sul : " + alltrim( str( nTOPSL ) ) + " dias."
nLin := nLin + 1 // Avanca a linha de impressao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return