#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  05/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

**************

User Function FATEVN()

**************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Prioridades de liberação de estoque"
Local nLin         	 := 80
					   //00 10 25 75 100
                       //          10        20        30        40        50        60        70        80        90        100       110
                       //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       	 := "SVIP      CODIGO         DESCRICAO                                           EST. VIRTUAL                   KGs        QUANT. PEDIDO"
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RLIBST" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont     	 := 00
Private CONTFL     	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "RLIBST" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("RLIBST",.F.)              

wnrel := SetPrint(cString,NomeProg,"RLIBST",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  05/09/08   º±±
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

Local nOrdem
Local aArray:=aArray2:= {}
Local nX     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)
aArray := Cabec2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While nX <= len(aArray)

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
      nLin := 9      
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   //aAdd(aRet, { 0, TMP->PRODUTO, TMP->DESCRICAO, nTot } )
   @nLin,00  PSAY aArray[nX][1]
   @nLin,10  PSAY aArray[nX][2]
   @nLin,25  PSAY aArray[nX][3]
   @nLin,75  PSAY transform(aArray[nX][4],"@E 999,999,999.99")
   @nLin,100 PSAY transform((aArray[nX][4] * Posicione("SB1",1, xFilial("SB1") + aArray[nX][2], "B1_PESO" )) * -1, "@E 999,999,999.99" )
   @nLin,117 PSAY transform( QUANTPED(aArray[nX][2]), "@E 999,999,999") 
   
   If MV_PAR01=1
   
      nLin := nLin + 2 
      aArray2:=PEDIDO(aArray[nX][2])
      @nLin++,00  PSAY "Pedido    Dt. Producao"
      
      For nY:=1 to len(aArray2)
   
         If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 9      
         Endif
   
         @nLin,00  PSAY aArray2[nY][1]
         @nLin++,10  PSAY DTOC(aArray2[nY][2])
   
      Next
   
   EndIf
   
   nX++
   nLin := nLin + 1 // Avanca a linha de impressao
   incRegua() // Avanca o ponteiro do registro no arquivo
EndDo

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

***************
Static Function Cabec2()
***************

Local cQuery
Local nSeq 	  := 1
Local cULT 	  := maxPrio()
Local cVIP    := '0050'
Local aABC    := {}
Local cCliVip := ""
Local aRet    := {}
Local aItens  := {}
Local nPos    := 0
cQuery := "select SC5.C5_PRIORES AS SVIP, PRIOX = CAST('' AS CHAR(3) ), ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NOT NULL then '*' ELSE '  ' END ) AS MARCA, "
cQuery += "SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,( case when SC5.C5_TIPO IN ( 'D', 'B' ) then ( Select SA2.A2_NOME from " + retsqlname( "SA2" ) + " SA2 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA2.A2_COD + SA2.A2_LOJA and SA2.A2_FILIAL = '" + xfilial( "SA2" ) + "' and SA2.D_E_L_E_T_ = ' ' ) "
cQuery += "else ( Select SA1.A1_NOME from " + retsqlname( "SA1" ) + " SA1 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA and SA1.A1_FILIAL = '" + xfilial( "SA1" ) + "' and SA1.D_E_L_E_T_ = ' ' ) end ) AS NOME, "
cQuery += "SC5.C5_VEND1,SA3.A3_NREDUZ,SC5.C5_PRIOR,SC5.C5_EMISSAO,SC5.C5_ENTREG,SC5.C5_OBS "
cQuery += "from " + retsqlname("SC5") + " SC5," + retsqlname( "SA3" ) + " SA3 "
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','99' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '" + xfilial( "SC5" ) + "' and SA3.A3_FILIAL = '" + xfilial( "SA3" ) + "' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_PRIORES, SC5.C5_ENTREG "

TCQUERY cQuery NEW ALIAS "CAB"
TCSetField( 'CAB', "C5_EMISSAO", "D", 8, 0 )
TCSetField( 'CAB', "C5_ENTREG",  "D", 8, 0 )

cARQTMP := CriaTrab( , .F. )
Copy To ( cARQTMP )
CAB->( DbCloseArea() )
DbUseArea( .T.,, cARQTMP, "CAB", .F., .F. )

CAB->(DbGotop())

DbSelectArea("SC5")
DbSetOrder(1)

//U_ABC50(@aABC,@cCliVip) 
  
ABC(aABC, cCliVip)
  
while !CAB->(EOF())
  
	_nX := Ascan(aABC, {|x| x[2] == CAB->C5_CLIENTE})
	if _nX > 0
		CAB->SVIP := StrZero(aABC[_nX,1],4)
	else
		if empty( CAB->SVIP ) .or. upper( CAB->SVIP ) == "ZZZZ"
			if val(cULT) <= 50
				CAB->SVIP := cVIP := soma1(cVIP)
			else
				CAB->SVIP := cULT := soma1(cULT)
			endIf
		/*else//Caso um dia seja necessario reordenar
			cVIP := soma1(cVIP)			
			if CAB->SVIP != cVIP
				CAB->SVIP := cVIP// := soma1(cVIP)			
			endIF*/
		endIf				
		//CAB->SVIP := cVIP := soma1(cVIP)
   endif
   
	SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
	RecLock("SC5",.F.)
	if !Empty(SC5->C5_PRIORES)
		if SC5->C5_PRIORES # CAB->SVIP
			SC5->C5_PRIORES := CAB->SVIP
		endif
	else
		SC5->C5_PRIORES := CAB->SVIP
	endif
  	MsUnlock()		
	nSeq++
	incRegua()
	CAB->( DbSkip() )
end

CAB->( DbGotop() )
do While CAB->( !EoF() )
	if len(aRet) <= 0
    	aRet := itens()
    else
    	aItens := itens()//aAdd(aRet, { 0, TMP->PRODUTO, TMP->DESCRICAO, nTot } )
    	for i := 1 to len(aItens)
    		nPos := aScan( aRet, {|x| x[2] == aItens[i][2] } )
    		if nPos > 0
    			if aItens[i][4] < aRet[nPos][4]
    				aRet[nPos][4] := aItens[i][4]
    			endIf
    			if aItens[i][1] < aRet[nPos][1]
    				aRet[nPos][1] := aItens[i][1]
    			endIf
    		else
    			aAdd(aRet, aItens[i])
    		endIf
    	next
    endIf
	/*aAdd(aRet, { CAB->SVIP, CAB->C5_NUM, CAB->C5_CLIENTE, CAB->C5_LOJACLI, CAB->C5_VEND1, CAB->A3_NREDUZ, CAB->C5_PRIOR, CAB->C5_EMISSAO,;
				 CAB->C5_ENTREG, itens(), CAB->NOME } )*/
	CAB->( dbSkip() )
	incRegua()
endDo
CAB->( DbCloseArea() )

Return aRet

***************

Static Function Itens()

***************
Local aRet := {}
Local nTot := 0
cQuery := "select SC6.C6_LOCAL AS LOCAL,SC6.C6_ITEM AS ITEM,SC6.C6_PRODUTO AS PRODUTO,SC6.C6_LOCAL AS LOCAL,SB1.B1_DESC AS DESCRICAO,SC6.C6_QTDVEN AS QTDPED,SC6.C6_QTDENT AS QTDFAT, SC6.C6_TES AS TES, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDLIB, "
cQuery += "SC6.C6_QTDRESE AS RESERVA, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED = '09' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDREJ, "
cQuery += "0 AS ESTOQUE,0 AS ALIBERAR "
cQuery += "from " + retsqlname("SC6") + " SC6," + retsqlname("SB1") + " SB1 "
cQuery += "where SC6.C6_NUM = '" + CAB->C5_NUM + "' and SC6.C6_PRODUTO = SB1.B1_COD "
//cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ','99' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC6.C6_FILIAL = '" + xfilial("SC6") + "' and SC6.D_E_L_E_T_ = ' ' "
cQuery += "and SB1.B1_FILIAL = '" + xfilial("SB1") + "' and SB1.D_E_L_E_T_ = ' ' "
cQuery += "order by SC6.C6_ITEM "
TCQUERY cQuery NEW ALIAS "TMP"

TCSetField( 'TMP', "QTDPED",   "N", 10, 3 )
TCSetField( 'TMP', "QTDFAT",   "N", 10, 3 )
TCSetField( 'TMP', "QTDLIB",   "N", 10, 3 )
TCSetField( 'TMP', "ESTOQUE",  "N", 10, 3 )
TCSetField( 'TMP', "ALIBERAR", "N", 10, 3 )
TCSetField( 'TMP', "QTDREJ",   "N", 10, 3 )
TCSetField( 'TMP', "RESERVA",  "N", 10, 3 )

While ! TMP->( Eof() )
	nTot := U_SALDOEST( TMP->PRODUTO, TMP->LOCAL ) - SALDORES( TMP->PRODUTO )
	if nTot < 0
		aAdd(aRet, { CAB->SVIP, alltrim(U_Transgen(TMP->PRODUTO)), TMP->DESCRICAO, nTot } )
	endIf
	nTot := 0
	TMP->( DbSkip() )
	incRegua()
End
TMP->( DbCloseArea() )

Return aRet

***************

Static function SALDORES( cProd1 )

***************

local nQuant := 0
local cQuery
local cProd2

cALIASANT := Alias()

if ! Empty( cPROD1 )
	if Len( AllTrim( cPROD1 ) ) <= 7
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
	else
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
	endif
	
	cQuery := "select sum( C6_QTDRESE ) AS RESERVA "
	cQuery += "from " + retsqlname("SC6") + " SC6, "+ retsqlname("SC5") + " SC5 "
	cQuery += "where C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) and "
	cQuery += "C6_NUM = C5_NUM AND C5_PRIORES <= '"+CAB->SVIP+"' AND "
	cQuery += "C6_QTDENT < C6_QTDVEN AND C6_QTDRESE > 0 AND C6_FILIAL = '" + xfilial("SC6") + "' and "
	cQuery += "C6_BLQ <> 'R' AND "
	cQuery += "SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' "	
	TCQUERY cQuery NEW ALIAS "C6X"
	DbSelectArea("C6X")
	nQuant := C6X->RESERVA
	C6X->(DbCloseArea())
endif

DbSelectArea(cALIASANT)

return nQuant

***************

Static Function maxPrio()

***************

local cMax := cQuery := ''

cQuery += "select max(SC5.C5_PRIORES) maximo "
cQuery += "from "+retSqlName('SC5')+" SC5, "+retSqlName('SA3')+" SA3 "
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from SC9020 SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '01' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from SC9020 SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '01' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' Or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '01' and SA3.A3_FILIAL = '  ' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
TCQUERY cQuery NEW ALIAS 'TMP'

TMP->( dbGoTop() )
cMax := TMP->maximo
TMP->( dbCloseArea() )

return cMax

***************

Static Function QUANTPED(cProd1)

***************

Local cQuery := ''
Local nQuant :=0
local cProd2

if ! Empty( cPROD1 )
	
   if Len( AllTrim( cPROD1 ) ) <= 7
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
   else
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
   endif
	
   cQuery := "SELECT  COUNT(DISTINCT C6_NUM)'QUANT' "
   cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9,"+retSqlName('SA1')+" SA1 "
   cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' "
   cQuery += "AND SB1.B1_TIPO = 'PA' AND "
   cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
   cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM " 
   cQuery += "and SC9.C9_PEDIDO = SC5.C5_NUM AND " 
//   cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
   cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
   cQuery += "SC5.C5_CLIENTE = SA1.A1_COD AND "
   cQuery += "SC6.C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) AND "
   cQuery += "SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' AND SC5.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND SC6.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC9.C9_FILIAL = '"+xFilial('SC9')+"' AND SC9.D_E_L_E_T_ = ' ' AND "
   cQuery += "SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = ' ' "

   TCQUERY cQuery NEW ALIAS 'AUUX'

   if AUUX->(!EOF())
      nQuant:=AUUX->QUANT
   EndIF
   
   AUUX->( dbCloseArea() )

EndIF

Return nQuant

***************

Static Function PEDIDO(cProd1)

***************

Local cQuery := ''
local cProd2
Local aRet:={}


if ! Empty( cPROD1 )
	
   if Len( AllTrim( cPROD1 ) ) <= 7
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
   else
	  cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
   endif
	
   cQuery := "SELECT C6_NUM,C6_DTPRODU  "
   cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9,"+retSqlName('SA1')+" SA1 "
   cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' "
   cQuery += "AND SB1.B1_TIPO = 'PA' AND "
   cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
   cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM " 
   cQuery += "and SC9.C9_PEDIDO = SC5.C5_NUM AND " 
//   cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
   cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "  
   cQuery += "SC5.C5_CLIENTE = SA1.A1_COD AND "
   cQuery += "SC6.C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) AND "
   cQuery += "SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' AND SC5.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND SC6.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC9.C9_FILIAL = '"+xFilial('SC9')+"' AND SC9.D_E_L_E_T_ = ' ' AND "
   cQuery += "SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = ' ' "

   TCQUERY cQuery NEW ALIAS 'AUUX'
   TCSetField("AUUX","C6_DTPRODU","D")
   
   Do While AUUX->(!EOF()) 
     aAdd(aRet, {AUUX->C6_NUM,AUUX->C6_DTPRODU  } )
     AUUX->(dbSkip())
   EndDo
   
   AUUX->( dbCloseArea() )
   
EndIF  

Return aRet    

************************
Static function ABC(aABC, cCliVip)
************************

Local nSeq
aABC    := {}
cCliVip := ""

//Curva ABC dos Clientes nos ultimos 6 meses
cQuery := "SELECT DISTINCT   CLIENTE=D2_CLIENTE,NOME=A1_NOME, "
cQuery += "       QUANT=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 "
cQuery += "                ELSE SUM(D2_QUANT) END, "
cQuery += "       PESO=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN CAST(0 AS FLOAT) "
cQuery += "                ELSE SUM(D2_QUANT*B1_PESOR) END, "
cQuery += "       CUSTO=SUM(D2_TOTAL/D2_QUANT), "
cQuery += "       VALOR=SUM(D2_TOTAL) "
cQuery += "FROM   "+RetSqlName("SD2")+" SD2 WITH (NOLOCK), "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "+RetSqlName("SA1")+" SA1 WITH (NOLOCK), "+RetSqlName("SA3")+" "
cQuery += "SA3 WITH (NOLOCK), "+RetSqlName("SF2")+" SF2 WITH (NOLOCK), "+RetSQlName("SBM")+" SBM WITH (NOLOCK) "
cQuery += "WHERE  D2_EMISSAO BETWEEN "+DtoS(dDataBase-180)+" AND "+DtoS(dDataBase)+" AND D2_FILIAL = '01' AND D2_TIPO = 'N' "
cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "AND SD2.D_E_L_E_T_ = '' AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQuery += "AND SB1.D_E_L_E_T_ = '' AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND F2_DUPL <> '' "
cQuery += "AND SF2.D_E_L_E_T_ = '' AND F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' AND SB1.B1_GRUPO = SBM.BM_GRUPO "
cQuery += "GROUP BY D2_CLIENTE,A1_NOME,A1_COD,D2_SERIE,F2_VEND1 "
cQuery += "ORDER BY PESO DESC "
TCQUERY cQuery NEW ALIAS "ABCX"

nSeq := 1
while !ABCX->(EOF())
   Aadd( aABC, { nSeq, ABCX->CLIENTE } )
   cCliVip += "'"+ABCX->CLIENTE+"'"
   nSeq++
   ABCX->(DbSkip())
   if !ABCX->(EOF())
      cCliVip += ","
   endif
end
ABCX->( DbCloseArea() )
aSort( aABC,,,{|x,y| x[2] < y[2]} ) 

return nil

