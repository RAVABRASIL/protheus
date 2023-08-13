#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDescricao ³ Relatorio acompanhamento da fila de cobranca               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cobranca - Rava Embalagens                         		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COBR06()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Acompanhamento da Fila de Cobranca"
Local cPict          := ""
Local titulo       := "Acompanhamento Fila de Cobranca"
Local nLin         := 80
local cabec1       := "Prioridade                               Qtd      |  Qtd    | Extra | Saldo"
Local Cabec2       := "                                         Inicial  |  Atual  | Fila  |      "
//                     123 12345678901234567890123456789012345    9,999     9,999     9,999  9,999
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "COBR06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "COBR06"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "COBR06" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "ZA3"

dbSelectArea("ZA3")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//cria aqruivo de trabaho
Dbselectarea("ZA3")

cCond := " SELECT ZA3_PRIOR, ZA3_QTATEN, ZA3_QREAL, RTRIM(ZZ7_DESNAT) + ' - ' + RTRIM(ZZ7_DESSTA) DESCRI"
cCond += " FROM "+RetSqlname("ZA3")+" ZA3, "+RetSqlname("ZZ7")+" ZZ7 "
cCond += " WHERE ZA3_DATA = '"+dtos(mv_par01)+"' "
cCond += " AND ZA3_PRIOR *= ZZ7_PRIORI "
cCond += " AND LEFT(ZZ7_NATUR,3) = '101'" //Mudar para natureza usada na Rava
cCond += " AND ZZ7_TPSTAT = 'S'"
cCond += " AND ZA3_PRIOR <> '999'"
cCond += " AND ZZ7.D_E_L_E_T_ = ''"
cCond += " AND ZA3.D_E_L_E_T_ = ''"
cCond += " GROUP BY ZA3_PRIOR,ZA3_QTATEN,ZA3_QREAL,ZZ7_DESNAT,ZZ7_DESSTA"
cCond += " ORDER BY ZA3_PRIOR"

TCQUERY cCond ALIAS TMPZA3 NEW

Dbselectarea("TMPZA3")
dbgotop()
nTotIni := nTotAtu := nTotSld := nTotExt := 0
While !eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo+"-"+Dtoc(MV_PAR01),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	nQAtu     := QtdReg(TMPZA3->ZA3_PRIOR)
	
	@ nlin, 000 pSay TMPZA3->ZA3_PRIOR
	
	If TMPZA3->ZA3_PRIOR == "AGE"
		@ nlin, 004 pSay "AGENDADOS"
	ElseIf TMPZA3->ZA3_PRIOR == "CHQ"
		@ nlin, 004 pSay "CHEQUES"
	Else
		@ nlin, 004 pSay Subst(TMPZA3->DESCRI,1,35)
	Endif
	                             
	@ nlin, 043 pSay TMPZA3->ZA3_QTATEN	Picture "@E 9,999"
  	@ nlin, 053 pSay nQAtu     Picture "@E 9,999"
  	
  	if Mv_par01 = Ddatabase 
   	N_extrafila := Extra_Fila(Mv_par01,TMPZA3->ZA3_PRIOR)   	    
   else
      N_extrafila := TMPZA3->ZA3_QREAL
   endif
	
	@ nlin, 063 pSay N_extrafila Picture "@E 9,999"         
	
	N_Saldo := TMPZA3->ZA3_QTATEN-nQAtu-N_extrafila
	 
   if N_Saldo < 0
      N_Saldo := 0
   endif

  	@ nlin, 070 pSay N_Saldo 	Picture "@E 9,999"

	nlin ++

	nTotIni += TMPZA3->ZA3_QTATEN
	nTotAtu += nQAtu
	NTotExt += N_extrafila
	nTotSld += N_Saldo
	
	Dbselectarea("TMPZA3")
	dbskip()
	
End

dbclosearea()
nlin ++ 

@ nlin, 000 pSay "Totais dia "+dtoc(MV_PAR01)
@ nlin, 043 pSay nTotIni Picture "@E 9,999"
@ nlin, 053 pSay nTotAtu Picture "@E 9,999"
@ nlin, 063 pSay nTotExt Picture "@E 9,999"
@ nlin, 070 pSay nTotSld Picture "@E 9,999"

nlin := nlin ++


Private nAtend     := 0
Private nPosit     := 0
Private nAtivo     := 0
Private nLigac     := 0
Private nNegat     := 0
Private nRecep     := 0
Private nPesq      := 0

nLigac := nTotAtu

Dbselectarea("ZA2")
//Imprime totais do dia
cQUERY := " Select ATEND=COUNT(DISTINCT ZA2.ZA2_CODATE ) "
cQUERY += " From " + RetSqlName( "ZA2" ) + " ZA2, "+ RetSqlName( "ZA1" ) + " ZA1 "
cQUERY += " Where ZA2.ZA2_DTATEN = '" + DTOS(mv_par01) + "' "
cQUERY += " AND ZA2_HRFIM <> '' "
cQUERY += " AND ZA2_CODATE = ZA1_COD "
cQUERY += " AND ZA1_ATIVO = 'S' "
cQUERY += " AND ZA1.D_E_L_E_T_ = '' "
cQUERY += " AND ZA2.D_E_L_E_T_ = '' "

cQUERY := ChangeQuery( cQUERY )

TCQUERY cQUERY Alias TMPZA2 New

Dbselectarea("TMPZA2")
nAtend := TMPZA2->ATEND
DBCLOSEAREA() 

Dbselectarea("ZA2")
//Imprime totais do dia
cQUERY := " Select ZA2.ZA2_QUALI,ZA2.ZA2_TIPO "
cQUERY += " From " + RetSqlName( "ZA2" ) + " ZA2 "
cQUERY += " Where ZA2.ZA2_DTATEN = '" + DTOS(mv_par01) + "' "
cQUERY += " AND ZA2_TIPO <> 'A' "
cQUERY += " AND ZA2_HRFIM <> '' "
cQUERY += " AND ZA2.D_E_L_E_T_ = '' "

cQUERY := ChangeQuery( cQUERY )

TCQUERY cQUERY Alias TMPZA2 New


//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TMPZA2")
dbgotop()

	
While !eof() 
		
	nLigac ++
		
	If TMPZA2->ZA2_QUALI == 'P'
		nPosit ++
	Else
		nNegat ++
	Endif
		
	//		nAgendados += 0
	If TMPZA2->ZA2_TIPO == 'A'
		nAtivo ++
	ElseIf TMPZA2->ZA2_TIPO == 'R'
		nRecep ++              
	Else 
		nPesq ++
	Endif		
		
	dbskip()

End

Dbclosearea("TMPZA2")

Dbselectarea("ZA2")
//Imprime totais do dia
cQUERY := " Select POSITIVO=count(ZA2.ZA2_CODCLI) "
cQUERY += " From " + RetSqlName( "ZA2" ) + " ZA2 "
cQUERY += " Where ZA2.ZA2_DTATEN = '" + DTOS(mv_par01) + "' "
cQUERY += " AND ZA2_TIPO = 'A' "
cQUERY += " AND ZA2_QUALI = 'P' "
cQUERY += " AND ZA2_HRFIM <> '' "
cQUERY += " AND ZA2.D_E_L_E_T_ = '' "

cQUERY := ChangeQuery( cQUERY )

TCQUERY cQUERY Alias TMPZA2 New

nPosit += TMPZA2->POSITIVO
nNegat += nTotAtu - TMPZA2->POSITIVO

Dbclosearea("TMPZA2")




nlin ++
@ nlin,000 pSay Replicate("-",80)
nlin ++
@ nlin,000 pSay "Resumo do dia (Totais) - "
@ nlin,030 pSay "Atendentes: "+Transform(nAtend,"@E 9,999")
@ nlin,050 pSay "Consultas : "+Transform(nLigac,"@E 99,999")
nlin ++
@ nlin,000 pSay Replicate("-",80)
nlin ++
@ nlin,000 pSay "Qualidade - "
@ nlin,015 pSay "Positivo : "+Transform(nPosit,"@E 9,999")
@ nlin,035 pSay "Negativo : "+Transform(nNegat,"@E 9,999")
nlin ++
@ nlin,000 pSay "Tipo      - "
@ nlin,015 pSay "Ativo    : "+Transform(nTotAtu,"@E 9,999") //nAtivo
@ nlin,035 pSay "Receptivo: "+Transform(nRecep,"@E 9,999")
@ nlin,055 pSay "Consulta : "+Transform(nPesq,"@E 9,999")
nlin ++
@ nlin,000 pSay Replicate("-",80)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ValidPerg³Autor ³ Silvano da Silva Araujo   ³Data³ 25/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica perguntas, incluindo-as caso nao existam.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SX1                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

Local _sAlias  := Alias()
Local aRegs    := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Dia Base       :","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COBR06    ºAutor  ³Microsiga           º Data ³  06/28/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QtdReg(cPrior)

nRet := 0

If cPrior == "AGE"
	
	cQry := " SELECT COUNT( DISTINCT ZA2_CODCLI+ZA2_LJCLI ) AGEND"
	cQry += " FROM "+RetSqlName("ZA2")+" "
	cQry += " WHERE ZA2_DTATEN = '"+dTos(mv_par01)+"' "
	cQry += " AND ZA2_PRIOR IN ('P14','P16')"
	cQry += " AND D_E_L_E_T_ = ''"
	
	TCQUERY cQRY Alias TMP New
	
	Dbselectarea("TMP")
	
	nRet := TMP->AGEND
	
	Dbclosearea()
	
ElseIf cPrior == "CHQ"
	
	cQry := " SELECT COUNT( DISTINCT ZA2_CODCLI+ZA2_LJCLI ) CHEQUES"
	cQry += " FROM "+RetSqlName("ZA2")+" "
	cQry += " WHERE ZA2_DTATEN = '"+dTos(mv_par01)+"' "
	cQry += " AND ZA2_PRIOR = 'P17'"
	cQry += " AND D_E_L_E_T_ = ''"
	
	TCQUERY cQRY Alias TMP New
	
	Dbselectarea("TMP")
	
	nRet := TMP->CHEQUES
	
	Dbclosearea()

Else

	cQry := " SELECT COUNT( DISTINCT ZA2_CODCLI+ZA2_LJCLI ) PRIORI"
	cQry += " FROM "+RetSqlName("ZA2")+" "
	cQry += " WHERE ZA2_DTATEN = '"+dTos(mv_par01)+"' "
	cQry += " AND ZA2_PRIOR = '"+cPrior+"' "
	cQry += " AND D_E_L_E_T_ = ''"
	
	TCQUERY cQRY Alias TMP New
	
	Dbselectarea("TMP")
	
	nRet := TMP->PRIORI
	
	Dbclosearea()
	
Endif

Return(nRet)

          
//
//
//
Static Function Extra_Fila(T_Data,Prior)

cQuery := " SELECT COUNT(*) AS TOTAL "
cQuery += " FROM "+RetSqlName("ZZ6")
cQuery += " WHERE ZZ6_PRIORI = '"+Prior+"' "
cQuery += " AND ZZ6_ULCONT = '"+dtos(T_Data)+"' "
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += " AND EXISTS( SELECT ZA2_FILIAL FROM "+RetSqlName("ZA2")+" ZA2 WHERE ZZ6_CLIENT = ZA2_CODCLI AND ZA2_DTATEN = '"+dtos(T_Data)+"' "
cQuery += " AND ZA2_PRIOR <> '"+Prior+"' AND ZA2_QUALI = 'P' AND ZA2.D_E_L_E_T_ = '' ) "
cQuery += " AND NOT EXISTS( SELECT ZA2_FILIAL FROM "+RetSqlName("ZA2")+" ZA2 WHERE ZZ6_CLIENT = ZA2_CODCLI AND ZA2_DTATEN = '"+dtos(T_Data)+"' "
cQuery += " AND ZA2_PRIOR = '"+Prior+"' AND ZA2.D_E_L_E_T_ = '' ) "

TCQUERY cQuery Alias TMP2 New  
DbSelectArea("TMP2")
nretorno := Tmp2->Total
DbCloseArea()

return(nretorno)