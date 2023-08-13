#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATR040  º Autor ³ Flávia Rocha       º Data ³  29/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ HISTÓRICO DO STATUS PEDIDO VENDA                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO - TELA FATC030                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**********************
User Function FATR040 
**********************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "HISTÓRICO DO STATUS PEDIDOS DE VENDA"
Local cPict          := ""
Local titulo       := "HISTÓRICO DO STATUS PEDIDOS VENDA"
Local nLin         := 80

Local Cabec1       := "Pedido   Cliente/Loja     Nome                           Emissao    Dt.P/Faturar    Total     Total c/IPI"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "FATR040" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FATR040" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC5"                
Private cPerg   := "FATR040"

dbSelectArea("SC5")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)
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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  29/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*******************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)   
*******************************************************

Local nOrdem



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery := ""
Local LF     := CHR(13) + CHR(10) 
Local cSTant := ""

cQuery := " Select " + LF
cQuery += " ZAC_PEDIDO, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO DT_INCLUSAO, C5_ENTREG, A1_NOME " + LF

cQuery += " ,ZAC_STATUS " + LF
cQuery += " ,ZAC_DTSTAT " + LF
cQuery += " ,ZAC_HRSTAT " + LF
cQuery += " ,ZAC_USER " + LF
cquery += " ,ZAC_DESCST " + LF
//cQuery += " , * " + LF
                
cQuery += " FROM " + LF

cQuery += " " + RetSqlname("ZAC") + " ZAC " + LF
cQuery += " , " + RetSqlname("SC5") + " SC5 " + LF
cQuery += " , " + RetSqlname("SA1") + " SA1 " + LF

cQuery += " WHERE  " + LF
cQuery += " ZAC.D_E_L_E_T_ = '' " + LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " + LF
If !Empty(MV_PAR01)
	cQuery += " AND SC5.C5_EMISSAO BETWEEN '" + Dtos(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + LF
Endif               

If !Empty(MV_PAR03)  .and. !Empty(MV_PAR04)                                                                                  
	cQuery += " AND SC5.C5_NUM BETWEEN '" + Alltrim(MV_PAR03) + "' AND '" + Alltrim(MV_PAR04) + "' " + LF
Endif

cQuery += " AND ZAC_PEDIDO = SC5.C5_NUM " + LF
cQuery += " AND ZAC_FILIAL = SC5.C5_FILIAL " + LF
cQuery += " AND SC5.C5_FILIAL = '" + Alltrim(xFilial("SC5") ) + "' " + LF

cQuery += " AND SC5.C5_CLIENTE = SA1.A1_COD " + LF
cQuery += " AND SC5.C5_LOJACLI = SA1.A1_LOJA" + LF

cQuery += " GROUP BY " + LF 
cQuery += " ZAC_PEDIDO, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO , C5_ENTREG, A1_NOME " + LF
cQuery += " ,ZAC_STATUS " + LF
cQuery += " ,ZAC_DTSTAT " + LF
cQuery += " ,ZAC_HRSTAT " + LF
cQuery += " ,ZAC_USER " + LF
cquery += " ,ZAC_DESCST " + LF

cQuery += " ORDER BY SC5.C5_NUM, (ZAC.ZAC_DTSTAT + ZAC.ZAC_HRSTAT) " + LF
MemoWrite("C:\Temp\FATR040.SQL",cQuery)

If Select("ZZX") > 0
	DbSelectArea("ZZX")
	DbCloseArea()	
EndIf 
TCQUERY cQuery NEW ALIAS "ZZX" 
TCSetField( "ZZX", "ZAC_DTSTAT", "D")
TCSetField( "ZZX", "C5_EMISSAO", "D")
TCSetField( "ZZX", "DT_INCLUSAO", "D")
TCSetField( "ZZX", "C5_ENTREG", "D")


SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ZZX->(Dbgotop())
While ! ZZX->(EOF())   

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
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   cPed := ZZX->C5_NUM
   nTotPV := fGetPV(ZZX->C5_NUM, ZZX->C5_CLIENTE, ZZX->C5_LOJACLI, "T")
   nTotPI := fGetPV(ZZX->C5_NUM, ZZX->C5_CLIENTE, ZZX->C5_LOJACLI, "I")
   
   // "Pedido        Cliente/Loja     Nome      Emissao      Dt.P/Faturar    Valor"
   @nLin,000 PSAY ZZX->C5_NUM
   @nLin,009 PSAY ZZX->C5_CLIENTE + '/' + ZZX->C5_LOJACLI
   @nLin,019 PSAY ZZX->A1_NOME
   @nLin,060 PSAY ZZX->DT_INCLUSAO
   @nLin,070 PSAY ZZX->C5_ENTREG
   @nLin,079 PSAY nTotPV Picture "@E 999,999,999.99"
   @nLin,096 PSAY nTotPI Picture "@E 999,999,999.99"
   nLin++                           
   nLin++
   @nLin,000 PSAY "Historico Status:"
   nLin++
   nLin++
   cSTant := ""
   //cSTant := ZZX->ZAC_STATUS
   	Do While !ZZX->(EOF()) .and. ZZX->C5_NUM == cPed
   
		If Alltrim(ZZX->ZAC_STATUS) = Alltrim(cSTant) .and. Alltrim(ZZX->ZAC_STATUS) = '02'
				nLin++
				@nLin,000 PSAY "NOVA LIB. CRÉDITO"
				nLin++
				@nLin,000 PSAY ZZX->ZAC_STATUS
				@nLin,003 PSAY SUBSTR(ZZX->ZAC_DESCST,1,30)
				@nLin,035 PSAY DTOC(ZZX->ZAC_DTSTAT)
				@nLin,045 PSAY ZZX->ZAC_HRSTAT
				@nLin,052 PSAY NomeOp(ZZX->ZAC_USER)
				nLin++ 
				nLin++
				cSTant := ZZX->ZAC_STATUS
				ZZX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
				
			
		Endif
		
		If Alltrim(ZZX->ZAC_STATUS) = Alltrim(cSTant) .and. Alltrim(ZZX->ZAC_STATUS) = '04'	
			cSTant := ZZX->ZAC_STATUS
			ZZX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
			Loop
		Endif
			
			
		@nLin,000 PSAY ZZX->ZAC_STATUS
		@nLin,003 PSAY SUBSTR(ZZX->ZAC_DESCST,1,30)
		@nLin,035 PSAY DTOC(ZZX->ZAC_DTSTAT)
		@nLin,045 PSAY ZZX->ZAC_HRSTAT
		@nLin,052 PSAY NomeOp(ZZX->ZAC_USER)
			
		nLin++
		cSTant := ZZX->ZAC_STATUS
		ZZX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		
	Enddo
	@nLin,000 PSAY Replicate("-" , limite) 
	nLin++
EndDo

Roda(0,"",Tamanho)
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


************************************************************************************************
Static Function fGetPV( cNum, cCli, cLJ , cTipo )
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "SC5X"
Local aCols		:= {}        
Local LF 		:= CHR(13) + CHR(10)
Local nTotPV    := 0
Local nValIPI   := 0  



		cQuery := " SELECT  A1_NOME, A3_NOME,C6_ITEM C6ITEM, E4_CODIGO, E4_DESCRI, * " + LF
	    cQuery += " From " + RetSqlname("SC5") + " SC5 " + LF
	    cQuery += " ," + RetSqlname("SC6") + " SC6 " + LF
	    cQuery += " ," + RetSqlname("SB1") + " SB1 " + LF
	    cQuery += " ," + RetSqlname("SA1") + " SA1 " + LF
	    cQuery += " ," + RetSqlname("SA3") + " SA3 " + LF
	    cQuery += " ," + RetSqlname("SE4") + " SE4 " + LF
		cQuery += " WHERE " + LF
		cQuery += " C5_FILIAL  = '" + xFilial("SC5") + "' " + LF    
		
		cQuery += " AND C5_CLIENTE = A1_COD " + LF
		cQuery += " AND C5_LOJACLI = A1_LOJA " + LF
		
		cQuery += " AND C5_VEND1 = A3_COD " + LF
		
		cQuery += " AND C5_CONDPAG = E4_CODIGO " + LF
		
		cQuery += " AND C5_NUM = '"  + Alltrim(cNum)  + "' " + LF
		cQuery += " AND C5_CLIENTE = '"  + Alltrim(cCli)  + "' " + LF
		cQuery += " AND C5_LOJACLI = '"  + Alltrim(cLJ)  + "' " + LF
		cQuery += " AND C5_FILIAL = C6_FILIAL " + LF
		cQuery += " AND C5_NUM = C6_NUM " + LF
		cQuery += " AND C5_CLIENTE = C6_CLI " + LF
		cQuery += " AND C5_LOJACLI = C6_LOJA " + LF
		cQuery += " AND C6_PRODUTO = B1_COD " + LF
		
		cQuery += " AND SC5.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SC6.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SB1.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SA1.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SA3.D_E_L_E_T_ = ' '  " + LF
		cQuery += " AND SE4.D_E_L_E_T_ = ' '  " + LF
		
		cQuery += " ORDER BY C5_NUM, C6_ITEM " + LF
		MemoWrite("C:\Temp\FGETPV.SQL",cQuery)

If Select("SC5X") > 0
	DbSelectArea("SC5X")
	DbCloseArea()	
EndIf 
TCQUERY cQuery NEW ALIAS "SC5X" 

TCSetField( cAlias, "C5_EMISSAO", "D")
TCSetField( cAlias, "C5_ENTREG", "D")
TCSetField( cAlias, "C6_ENTREG", "D")


SC5X->(Dbgotop())
While ! SC5X->(EOF())
      
    nTotPV += Round(SC5X->C6_VALOR, 2)
    If Alltrim(cTipo) = "I" //TOTAL COM IPI
    	nValIPI += Round(SC5X->C6_VALOR * (SC5X->B1_IPI / 100),2)
    Endif
    cNomCli:= SC5X->A1_NOME 
    cNomeRepre := SC5X->A3_NOME
    cCondPag   := SC5X->E4_DESCRI //(SC5X->E4_CODIGO + '-' + SC5X->E4_DESCRI)
    DbselectArea("SC5X")
	SC5X->(DbSkip())
Enddo

SC5X->(DbCloseArea())

If Alltrim(cTipo) = ""
	Return
ElseIF Alltrim(cTipo) = "T" //retorna total pedido
	Return(nTotPV)
ElseIF Alltrim(cTipo) = "I" //retorna total pedido C/ IPI
	Return(nTotPV + nValIPI)
ElseIF Alltrim(cTipo) = "C" //retorna nome cliente
	Return(cNomCli)
ElseIF Alltrim(cTipo) = "V" //retorna nome vendedor
	Return(cNomeRepre)
ElseIF Alltrim(cTipo) = "P" //retorna condição pagto
	Return(cCondPag)

Endif


***************

Static Function NomeOp( cOperado )

***************
Local cNome := ""

PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
Endif 

return cNome
