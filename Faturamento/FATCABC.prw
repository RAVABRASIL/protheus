#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  28/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATCABC()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := ""
Local nLin         	 := 80
					   //          10        20        30        40        50        60        70        80        90        100       110       120      130
					   //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
					   //123456 12345678901234567890  999.999.999,99  999.999.999,99  999.99%    99/99/99   999.999.999,99
Local Cabec1       	 := "Codigo|     Cliente        |Media R$ S/IPI |   Media em KG | Margem |Dt.Ul.Compra|    Ult. Compra|             Observacoes "
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATCABC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private Key     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATCABC" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

Pergunte("FATCAB",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "Vendas de " + Posicione("SA3", 1, xFilial("SA3") + mv_par01, "A3_NREDUZ") + "no periodo de " + dtoc(mv_par02) + " ate "+ dtoc(mv_par03)
wnrel := SetPrint(cString,NomeProg,"FATCABC",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/10/08   º±±
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

Local nTotRS  := nTotKG := nLast := nCadt := nPosit := 0
Local cQuery1 := cQuery2 := ""
Local aInf := {{"TOTAL DE CLIENTES CADASTRADOS: ","TOTAL DE CLIENTES ATIVOS EM "+upper(mesExtenso(month(dDataBase)))+" DE "+alltrim(str(year(dDataBase)))+":",;
                "% DE ATIVOS: "},;
			   {"FATURAMENTO DOS ULTIMOS "+alltrim(str((month(mv_par03) - month(mv_par02)) + iif( day(mv_par03) > 1,1,0 ) ))+" MESES",;
			    "  MES            VALOR             KGS   FATOR   MARGEM     DIF%"},;
			   {"META DE: ","TOTAL ATINGIDO EM: ","PERCENTUAL ATINGIDO: "}}
Local aVal    := {}
Local aUltcom := {}
Local aultFat := {}
Local aMeta   := {}
			  //Nov-08  999.999.999,99  999.999.999,99  999,99  999,99%  999,99%
		      //          10        20        30        40        50        60        
			  //0123456789012345678901234567890123456789012345678901234567890123456789
cQuery := "select A1_COD "
cQuery += "from "+retSqlName("SA1")+" "
cQuery += "where A1_FILIAL = '"+xFilial("SA1")+"' and A1_VEND in ('"+mv_par01+"','"+alltrim(mv_par01) +"VD'"+") "
cQuery += "and D_E_L_E_T_ != '*' "
cQuery += "order by A1_COD "
TCQUERY cQuery NEW ALIAS "_TMPZ"
_TMPZ->( dbGoTop() )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

do While _TMPZ->( !EoF() )    

	cQuery2 := "select isnull(sum(D2_TOTAL),0) D2_TOTAL, "
	cQuery2 += "isnull(sum( ( CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN CAST(0 AS FLOAT) ELSE D2_QUANT END) * B1_PESOR ),0 ) VAL_KG "
	cQuery2 += "from  "+retSqlName("SF2")+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4, "+retSqlName("SB1")+" SB1 "
	cQuery2 += "where F2_FILIAL = '"+xFilial("SF2")+"' and D2_FILIAL = '"+xFilial("SD2")+"' and F4_FILIAL = '"+xFilial("SF4")+"' and B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery2 += "and F2_EMISSAO between '"+dtos(mv_par02)+"' and '"+dtos(mv_par03)+"' and D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA  and F4_CODIGO = D2_TES "
	cQuery2 += "and F2_VEND1 in ('"+mv_par01+"','"+alltrim(mv_par01) +"VD'"+") and F2_CLIENTE = '"+_TMPZ->A1_COD+"' "
	cQuery2 += "and F4_DUPLIC = 'S' and F2_TIPO = 'N' and D2_COD = B1_COD "
	cQuery2 += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
	cQuery2 += "AND RTRIM(D2_CF) IN ( '511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
	cQuery2 += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
	TCQUERY cQuery2 NEW ALIAS "_TMPY"
	_TMPY->( dbGoTop() )
	do While _TMPY->( !EoF() )
	   aUltcom := ultcom( _TMPZ->A1_COD )
	   aAdd( aVal, { _TMPZ->A1_COD,Posicione("SA1", 1, xFilial("SA1") + _TMPZ->A1_COD,    "A1_NREDUZ"),;
	                 _TMPY->D2_TOTAL/(( month(mv_par03) - month(mv_par02) ) + iif( day(mv_par03) > 1,1,0 ) ),;
	                 _TMPY->VAL_KG  /(( month(mv_par03) - month(mv_par02) ) + iif( day(mv_par03) > 1,1,0 ) ),;
	                 "999,99%", stod( aUltcom[1] ), aUltcom[2] } )
	   _TMPY->( dbSkip() )	   
	endDo
	incRegua()
    _TMPY->( dbCloseArea() )
    _TMPZ->( dbSkip() )
EndDo
_TMPZ->( dbCloseArea() )
aSort( aVal,,,{ |x,y| x[4] > y[4] } )
SetRegua( len(aVal) )
 //          10        20        30        40        50        60        70        80        90        100       110       120      130
 //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
 //123456 12345678901234567890  999.999.999,99  999.999.999,99  999.99%    99/99/99
//"Codigo|     Cliente        |   Valor S/IPI |   Valor em KG | Margem |Ult. Compra| Observacoes "
for _k := 1 to len( aVal )
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

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   @nLin,00 PSAY aVal[_k][1]
   @nLin,07 PSAY aVal[_k][2]
   @nLin,28 PSAY transform(aVal[_k][3],"@E 999,999,999.99")
   @nLin,44 PSAY transform(aVal[_k][4],"@E 999,999,999.99")
   @nLin,61 PSAY iif(aVal[_k][3] == 0 .or. aVal[_k][4] == 0, transform(0,"@E 999.99"),transform(( ( (aVal[_k][3]/aVal[_k][4])/mv_par04 ) * 100 ) - 100,"@E 999.99" ) )
   @nLin,72 PSAY aVal[_k][6]
   @nLin,83 PSAY aVal[_k][7]
   nLin := nLin + 1 // Avanca a linha de impressao
   nTotRS += aVal[_k][3]
   nTotKG += aVal[_k][4]
   incRegua()	   
Next
If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif
@nLin,00 PSAY "Totais:"
@nLin,28 PSAY transform(nTotRS,"@E 999,999,999.99")
@nLin,44 PSAY transform(nTotKG,"@E 999,999,999.99")
SetRegua(len(aInf))
nLin += 2
aUltFat := UltFat()
nPosit  := ativos()
aMeta   := meta2()
for _x := 1 to len( aInf )
  for _y := 1 to len( aInf[_x] )
    If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 8
	Endif
	@nLin,00 PSAY aInf[_x][_y]
	if _x == 1  
	   @nLin,00 PSAY iif( _y == 1, space(len(aInf[_x][_y])+1) + transform(len(aVal), "@E 9999"), iif(_y == 2 ,;
	   					           space(len(aInf[_x][_y])+1) + transform(   nPosit,"@E 9999"),;
	                               space(len(aInf[_x][_y])+1) + transform((nPosit/len(aVal))*100,"@R 999.99%") ) )
	   iif(_y == 3, nLin++,)
	elseIf _x == 2 .and. _y > 1
	   nLin++
	   for _p := 1 to len(aUltFat)
	     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	       nLin := 8
   	     Endif
   	     @nLin,00 PSAY substr(mesExtenso(aUltFat[_p][3]),1,3) +" "+alltrim(str(aUltFat[_p][4]))
   	     @nLin,08 PSAY transform( aUltFat[_p][1], "@E 999,999,999.99")
   	     @nLin,24 PSAY transform( aUltFat[_p][2], "@E 999,999,999.99")
   	     @nLin,40 PSAY transform( aUltFat[_p][1]/aUltFat[_p][2], "@E 999.99")
  	     @nLin,49 PSAY transform( ( ( ( aUltFat[_p][1]/aUltFat[_p][2])/mv_par04) * 100 ) - 100, "@E 999.99")
  	     if _p == 1
	        @nLin,60 PSAY "--"
   	     else
   	        @nLin,57 PSAY transform( (((aUltFat[_p-1][1]/aUltFat[_p][1])*100)-100) * -1, "@R 9999.99%")
   	     endIf
   	     
   	     If aUltFat[_p][3]=month(mv_par03)
   	     nLast := aUltFat[_p][1]
   	     EndIf
   	     
   	     nLin++
   	     
	   next
	elseIf _x == 3
	   @nLin,00 PSAY iif( _y == 1, space(len(aInf[_x][_y])+1) + Transform( aMeta[1], "@R 99/9999") +" "+ Transform( aMeta[2], "@E 999,999,999.99"),;
	                 iif( _y == 2, space(len(aInf[_x][_y])+1) + Transform(nLast, "@E 999,999,999.99"),;
	                 space(len(aInf[_x][_y])+1) + Transform((nLast/aMeta[2])*100, "@E 9,999.99" ) ) )
	endIf
	nLin++
  next
  incRegua()
next
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

Static Function ultcom( cCli )

***************

Local cQuery := ""
Local cData  := ""
Local nVal   := 0
cQuery += "select top 1 F2_EMISSAO, isnull(sum(D2_TOTAL),0) D2_TOTAL "
cQuery += "from   "+retSqlName('SF2')+" SF2, "+retSqlName('SD2')+" SD2, "+retSqlName('SF4')+" SF4 "
cQuery += "where  F2_FILIAL = '"+xFilial('SF2')+"' and D2_FILIAL = '"+xFilial('SD1')+"' and F4_FILIAL = '"+xFilial('SF4')+"' "
cQuery += "and F2_CLIENTE = '"+cCli+"' "
cQuery += "and D2_DOC = F2_DOC and F4_CODIGO = D2_TES and  F4_DUPLIC = 'S' and F2_TIPO = 'N' "
cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' "
cQuery += "group by F2_DOC,F2_EMISSAO "
cQuery += "order by F2_EMISSAO desc"
TCQUERY cQuery NEW ALIAS "_TMPA"

_TMPA->( dbGoTop() )
do While ! _TMPA->( EoF() )
   cData := _TMPA->F2_EMISSAO
   nVal  := _TMPA->D2_TOTAL
   _TMPA->( dbSkip() )
endDo
_TMPA->( dbCloseArea() )

return { cData, transform(nVal, "@E 999,999,999.99") }

***************

Static Function ativos()

***************

Local cQuery := ""
Local nCount := 0

cQuery := "select count( distinct F2_CLIENTE) CONT "
cQuery += "from  "+retSqlName("SF2")+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4, "+retSqlName("SB1")+" SB1 "
cQuery += "where F2_FILIAL = '"+xFilial('SF2')+"' and D2_FILIAL = '"+xFilial('SD1')+"' and F4_FILIAL = '"+xFilial('SF4')+"' "
cQuery += "and month(F2_EMISSAO) = '"+strzero(month(dDataBase),2)+"' "
cQuery += "and year(F2_EMISSAO)  = '"+alltrim(str(year(dDataBase)))+"' "
cQuery += "and D2_DOC = F2_DOC and F4_CODIGO = D2_TES and F2_VEND1 in ('"+mv_par01+"','"+alltrim(mv_par01) +"VD'"+") "
cQuery += "and F4_DUPLIC = 'S' and F2_TIPO = 'N' and D2_COD = B1_COD "
cQuery += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "_TMPA"
_TMPA->( dbGoTop() )
do While ! _TMPA->( EoF() )
   nCount += _TMPA->CONT
   _TMPA->( dbSkip() )
endDo
_TMPA->( dbCloseArea() )

Return nCount

***************

Static Function UltFat()

***************

Local cQuery := ""
Local aRet   := {}
cQuery := "select sum(D2_TOTAL) D2_TOTAL, month(F2_EMISSAO) MES, year(F2_EMISSAO) ANO, "
cQuery += "isnull(sum( ( CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN CAST(0 AS FLOAT) ELSE D2_QUANT END ) * B1_PESOR ),0 ) VAL_KG "
cQuery += "from  "+retSqlName("SF2")+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4, "+retSqlName("SB1")+" SB1 "
cQuery += "where F2_FILIAL = '"+xFilial('SF2')+"' and D2_FILIAL = '"+xFilial('SD1')+"' and F4_FILIAL = '"+xFilial('SF4')+"' "
cQuery += "and F2_VEND1 in ('"+mv_par01+"','"+alltrim(mv_par01) +"VD'"+") "
cQuery += "and F2_EMISSAO between '"+dtos(mv_par02)+"' and '"+dtos(mv_par03)+"' "
cQuery += "and D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA and F4_CODIGO = D2_TES "
cQuery += "and F4_DUPLIC = 'S' and F2_TIPO = 'N' and D2_COD = B1_COD "
cQuery += "and D2_COD = B1_COD AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "group by month(F2_EMISSAO), year(F2_EMISSAO) "
cQuery += "order by month(F2_EMISSAO), year(F2_EMISSAO) "
TCQUERY cQuery NEW ALIAS "_TMPA"
_TMPA->( dbGoTop() )
do While _TMPA->( !EoF() )
	aAdd( aRet, { _TMPA->D2_TOTAL, _TMPA->VAL_KG, _TMPA->MES, _TMPA->ANO } )
	_TMPA->( dbSkip() )
endDo
_TMPA->( dbCloseArea() )

Return aRet

***************

Static Function meta2()

***************

Local aRet   := { "", 0 }
//Local dData  := iif( day(dDataBase) > 1, dDataBase, dDataBase - 1 )
Local dData  := iif( day(mv_par03) > 1, mv_par03, mv_par03 - 1 )
Local cQuery := "select Z7_MESANO, Z7_VALOR from "+retSqlName("SZ7")+" where Z7_REPRESE = '"+mv_par01+"' "+;
				"and Z7_FILIAL = '"+xFilial('SZ7')+"' and D_E_L_E_T_ != '*' "+;
				"and substring(Z7_MESANO,1,2) = '"+strzero(month(dData),2)+"' "+;
				"and substring(Z7_MESANO,3,4) = '"+alltrim(str(year(dData)))+"'  "
TCQUERY cQuery NEW ALIAS '_TMPY'                                                	
_TMPY->( dbGoTop() )
if _TMPY->( !EoF() )
   aRet := { _TMPY->Z7_MESANO, _TMPY->Z7_VALOR }
endIf
_TMPY->( dbCloseArea() )

Return aRet