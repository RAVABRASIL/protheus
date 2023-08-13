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

User Function RLIBST()

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
Local Cabec1       	 := "Seq.VIP | Pedido | Faturar em | Cliente | Loja |      Nome do Cliente/Forncedor     | Vendedor |    Nome Vendedor    | Prioridade |"
Local Cabec2       	 := "   It   |  LC    |	Qtd A lib  |  Est Virtual   |  Saldo a Faturar   |  Qtd Liberada   | Qtd Rejeitada | Qtd Reservada | Qtd Pedida|"
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
Local aArray := {}
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
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          10        20        30        40        50        60        70        80        90        100       110       120       130
// 123      123456    99/99/99    123456     99   Rava Embalagens Indústria e Comércio    1234
//"Seq.VIP | Pedido | Faturar em | Cliente | Loja |      Nome do Cliente/Forncedor     | Vendedor |    Nome Vendedor    | Prioridade |"
//"   It   |  LC    |	Qtd A lib  |  Est Virtual   |  Saldo a Faturar   |  Qtd Liberada   | Qtd Rejeitada | Qtd Reservada | Qtd Pedida|"
/*
aAdd(aRet, {TMP->ITEM 1, TMP->PRODUTO 2, TMP->LOCAL 3, TMP->DESCRICAO 4, TMP->QTDPED 5, TMP->QTDFAT 6,TMP->QTDLIB 7,;
			U_SALDOEST( TMP->PRODUTO, TMP->LOCAL ) - SALDORES( TMP->PRODUTO ) 8, TMP->ALIBERAR 9, TMP->QTDREJ 10, TMP->TES 11,
			TMP->RESERVA 12} )			
{{ "ITEM"               ,, OemToAnsi( "It" ) }, ;1
 { "LOCAL"              ,, OemToAnsi( "Lc" ) }, ; 3
 { "ALIBERAR"           ,, OemToAnsi( "Q.a lib." ), "@E 99999.999" }, ;9
 { "ESTOQUE"            ,, OemToAnsi( "Est.Virt." ), "@E 99999.999" }, ;8
 { "( QTDPED - QTDFAT )",, OemToAnsi( "Sld a fat." ), "@E 99999.999" }, ; 5 - 6
 { "QTDLIB"             ,, OemToAnsi( "Q.Lib." ), "@E 99999.999" }, ; 7
 { "QTDREJ"             ,, OemToAnsi( "Q.Rej." ), "@E 99999.999" }, ; 10
 { "RESERVA"            ,, OemToAnsi( "Q.Res." ), "@E 99999.999" }, ; 12
 { "QTDPED"             ,, OemToAnsi( "Q.Ped." ), "@E 99999.999" }, ; 5
 { "( ' ' )"            ,, OemToAnsi( " " ) } },,, ;			
*/
   @nLin,00  PSAY aArray[nX][1]//s vip 1
   @nLin,10  PSAY aArray[nX][2]//nº pedido 2
   @nLin,20  PSAY aArray[nX][9]//dt entrega 3
   @nLin,32  PSAY aArray[nX][3]//cliente 4                                                           
   @nLin,43  PSAY aArray[nX][4]//loja 5
   @nLin,48  PSAY substr(aArray[nX][11],1,34)//nome cliente 6
   @nLin,88  PSAY aArray[nX][5]//cod vendedor 7
   @nLin,97  PSAY aArray[nX][6]//aArray[x][7]//
   @nLin,119 PSAY iif(!empty(aArray[nX][7]),"TOP","Normal")
   for nT := 1 to len( aArray[nX][10] )
       nLin := nLin + 1 // Avanca a linha de impressao
       If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
          Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
          nLin := 9      
	   Endif
	   @nLin,00   PSAY aArray[nX][10][nT][1]//item
	   @nLin,10   PSAY aArray[nX][10][nT][3]//Local
	   @nLin,20   PSAY aArray[nX][10][nT][9]//Qtd A lib
	   @nLin,34   PSAY aArray[nX][10][nT][8]//Est Virtual
	   @nLin,51   PSAY aArray[nX][10][nT][5] - aArray[nX][10][nT][6]//Saldo a Faturar
	   @nLin,72   PSAY aArray[nX][10][nT][7]//Qtd Liberada
	   @nLin,89   PSAY aArray[nX][10][nT][10]//Qtd Rejeitada
   	   @nLin,106 PSAY aArray[nX][10][nT][12]//Qtd Reservada
   	   @nLin,106 PSAY aArray[nX][10][nT][5]//Qtd Reservada   	   
   next
   nX++
   nLin := nLin + 2 // Avanca a linha de impressao
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

cQuery := "select SC5.C5_PRIORES AS SVIP, PRIOX = CAST('' AS CHAR(3) ), ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NOT NULL then '*' ELSE '  ' END ) AS MARCA, "
cQuery += "SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,( case when SC5.C5_TIPO IN ( 'D', 'B' ) then ( Select SA2.A2_NOME from " + retsqlname( "SA2" ) + " SA2 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA2.A2_COD + SA2.A2_LOJA and SA2.A2_FILIAL = '" + xfilial( "SA2" ) + "' and SA2.D_E_L_E_T_ = ' ' ) "
cQuery += "else ( Select SA1.A1_NOME from " + retsqlname( "SA1" ) + " SA1 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA and SA1.A1_FILIAL = '" + xfilial( "SA1" ) + "' and SA1.D_E_L_E_T_ = ' ' ) end ) AS NOME, "
cQuery += "SC5.C5_VEND1,SA3.A3_NREDUZ,SC5.C5_PRIOR,SC5.C5_EMISSAO,SC5.C5_ENTREG,SC5.C5_OBS "
cQuery += "from " + retsqlname("SC5") + " SC5," + retsqlname( "SA3" ) + " SA3 "
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO 
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' Or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
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

U_ABC50(@aABC,@cCliVip)

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
	nSeq ++
	incRegua()
	CAB->( DbSkip() )
end

CAB->( DbGotop() )
do While CAB->( !EoF() )
	aAdd(aRet, { CAB->SVIP, CAB->C5_NUM, CAB->C5_CLIENTE, CAB->C5_LOJACLI, CAB->C5_VEND1, CAB->A3_NREDUZ, CAB->C5_PRIOR, CAB->C5_EMISSAO,;
				 CAB->C5_ENTREG, itens(), CAB->NOME } )
	CAB->( dbSkip() )
	incRegua()
endDo
CAB->( DbCloseArea() )

Return aRet

***************

Static Function Itens()

***************
Local aRet := {}
nPeso := 0
cQuery := "select SC6.C6_LOCAL AS LOCAL,SC6.C6_ITEM AS ITEM,SC6.C6_PRODUTO AS PRODUTO,SC6.C6_LOCAL AS LOCAL,SB1.B1_DESC AS DESCRICAO,SC6.C6_QTDVEN AS QTDPED,SC6.C6_QTDENT AS QTDFAT, SC6.C6_TES AS TES, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDLIB, "
cQuery += "SC6.C6_QTDRESE AS RESERVA, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED = '09' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDREJ, "
cQuery += "0 AS ESTOQUE,0 AS ALIBERAR "
cQuery += "from " + retsqlname("SC6") + " SC6," + retsqlname("SB1") + " SB1 "
cQuery += "where SC6.C6_NUM = '" + CAB->C5_NUM + "' and SC6.C6_PRODUTO = SB1.B1_COD "
//cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
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
	aAdd(aRet, {TMP->ITEM,TMP->PRODUTO,TMP->LOCAL,TMP->DESCRICAO,TMP->QTDPED,TMP->QTDFAT,TMP->QTDLIB,;
				U_SALDOEST( TMP->PRODUTO, TMP->LOCAL ) - SALDORES( TMP->PRODUTO ),TMP->ALIBERAR,TMP->QTDREJ,TMP->TES,TMP->RESERVA} )
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
	cQuery += "C6_QTDENT < C6_QTDVEN AND C6_QTDRESE > 0 AND C6_FILIAL = '" + xfilial("SC6") + "' and C5_FILIAL = '" + xfilial("SC5") + "' and "
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
cQuery += "and ( C5_NOTA = '' or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '"+xFilial("SC5")+"' and SA3.A3_FILIAL = '"+xFilial('SA3')+"' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
TCQUERY cQuery NEW ALIAS 'TMP'

TMP->( dbGoTop() )
cMax := TMP->maximo
TMP->( dbCloseArea() )

return cMax