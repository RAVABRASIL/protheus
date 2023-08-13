#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ AP6 IDE            º Data ³  23/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATRPQ()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Relatório de Pesquisa de Mercado"
Local nLin         	 := 80
                       //          10        20        30        40        50        60        70        80        90        100       100       120       130       140       150       160       170       180       190       200       210       220
                       //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                       //CTG160           999.999.999,99  999.999.999,99 999.999.999,99 999,99    999.999.999,99    999.999.999,99  Ascaminoflaw Coporacoes      999     Foxtrot da Silva Sauro    999.999.999,99 Foxtrot da Silva Sauro
Local Cabec1       	 := "Cod. do Produto|  Preco Minimo | Preco  Rava   |Maior Ult. Cpa| %IPI  | Preco -ipi +5% | Media de Precos |       Concorrente          | ABC |          Cliente           | Ult. Preco   |          Prospect          |"
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATRPQ" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont     	 := 00
Private CONTFL    	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "FATPQ" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := ""
Private aABC         := {}
Private cCliVip      := ""
Pergunte( "FATRPQ", .T. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FATRPQ",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/09/08   º±±
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

Local nPreco := nMedia := nCount := nPos := nIdx := 0
Local aArray := {}
Local cQuery := ""
cQuery := "select Z29_CODIGO, Z29_DATA, Z29_DESCRZ, Z30_CODCLI, Z30_PRODUT, Z30_CONCOR, Z30_VALOR, Z30_QUANTI, Z30_IPI, "
cQuery += "Z30_IPI, Z30_PROSPE, (Z30_VALOR*1000)/Z30_QUANTI VALOR "
cQuery += "from "+retSqlName("Z29")+" Z29 left join "+retSqlName("Z30")+" Z30 on Z29_FILIAL + Z29_CODIGO = Z30_FILIAL + Z30_CODPES and "
cQuery += "Z30.D_E_L_E_T_ != '*' AND Z30_CONSID = 'S' "
cQuery += "where Z29_FILIAL= '"+xFilial("Z29")+"' and Z29.D_E_L_E_T_ != '*' "
cQuery += "and Z29_CODIGO between '"+mv_par02+"' and '"+mv_par03+"' "
cQuery += "order by Z30_PRODUT,VALOR "
TCQUERY cQuery NEW ALIAS "_TMPX"
_TMPX->( dbGoTop() )
ABC500(@aABC, @cCliVip)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)
do While !_TMPX->( EoF() )
   nPos := aScan( aArray, { |x| x[5] == _TMPX->Z30_PRODUT } )
   nIdx := aScan(aABC, { |x| x[2] == _TMPX->Z30_CODCLI  } )
   if nPos <= 0
      aAdd(aArray, { _TMPX->Z29_CODIGO, _TMPX->Z29_DATA, _TMPX->Z29_DESCRZ, _TMPX->Z30_CODCLI, _TMPX->Z30_PRODUT, _TMPX->Z30_CONCOR,;
                     _TMPX->Z30_VALOR, _TMPX->Z30_QUANTI, _TMPX->Z30_IPI, _TMPX->VALOR, iif(nIdx > 0, aABC[nIdx][1], space(20) ), _TMPX->Z30_PROSPE  } )  
   endIf
   _TMPX->( dbSkip() )
   incRegua()
endDo
	_TMPX->( dbCloseArea() )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua( len( aArray ) )
nCount := 1
While nCount <= len( aArray )

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
/*            1       2              3                   4                   5                 6
_TMPX->Z29_CODIGO, _TMPX->Z29_DATA, _TMPX->Z29_DESCRZ, _TMPX->Z30_CODCLI, _TMPX->Z30_PRODUT, _TMPX->Z30_CONCOR,
7                 8                  9              10    11                    12                      13
_TMPX->Z30_VALOR, _TMPX->Z30_QUANTI, _TMPX->Z30_IPI, 0, _TMPX->VALOR, iif(nIdx > 0, aABC[nIdx][1],-1), _TMPX->Z30_PROSPE
*/
/*            1       2                3                 4                  5                   6
_TMPX->Z29_CODIGO, _TMPX->Z29_DATA, _TMPX->Z29_DESCRZ, _TMPX->Z30_CODCLI, _TMPX->Z30_PRODUT, _TMPX->Z30_CONCOR,
7                   8                   9               10                     11                    12
_TMPX->Z30_VALOR, _TMPX->Z30_QUANTI, _TMPX->Z30_IPI, _TMPX->VALOR, iif(nIdx > 0, aABC[nIdx][1],-1), _TMPX->Z30_PROSPE
*/
//          10        20        30        40        50        60        70        80        90        100       100       120       130       140       150       160       170       180       190       200       210       220
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//CTG160          999.999.999,99  99,99   999.999.999,99    999.999.999,99  Ascaminoflaw Coporacoes       999     Foxtrot da Silva Sauro       Foxtrot da Silva Sauro    999.999.999,99
//Cod. do Produto| Prc Marg 50% | %IPI  |  Preco Concorr | Media de Precos |       Concorrente          | ABC |          Cliente           |          Prospect          | Ult. Preco   |"
   nMedia := Media( aArray[nCount][5], aArray[nCount][1] )
                                   // Menos o percentual pago de IPI                  // +5%
   nPreco := (aArray[nCount][10] - ( (aArray[nCount][9]/100) * aArray[nCount][10] ) ) * 1.05
   if nMedia > nPreco
      nRava := (nMedia - nPreco)/nPreco
      if nRava > 0.1
      	nRava := nPreco * ( 1 + nRava )
      else
      	nRava := nPreco
      endIf
   else
      nRava := (nPreco - nMedia)/nMedia
      if nRava > 0.1
      	nRava := nMedia * ( 1 + nRava )
      else
      	nRava := nPreco      
      endIf
   endIf
   @nLin,000 PSAY aArray[nCount][5]
   @nLin,016 PSAY transform( mv_par01 * posicione("SB1",1,xFilial("SB1")+aArray[nCount][5], "B1_PESO") *;
                  iif( substr(aArray[nCount][5],1,1) $ "/A/F", 1.6, iif( substr(aArray[nCount][5],1,1) $ "/D/E", 1.85, 1 ) ) ,"@E 999,999,999.99" )//preço rava
   @nLin,033 PSAY transform( nRava, "@E 999,999,999.99" )
   @nLin,048 PSAY transform( maior(aArray[nCount][5]), "@E 999,999,999.99" )
   @nLin,064 PSAY transform( aArray[nCount][9],  "@E 99.99"          )//ipi
   @nLin,073 PSAY transform( nPreco, "@E 999,999,999.99" )//preço concorrente
   @nLin,091 PSAY transform( nMedia, "@E 999,999,999.99" )//média
   @nLin,106 PSAY substr( Posicione( "Z16", 1, xFilial('Z16') + aArray[nCount][6], "Z16_NOME"  ),1,28 )//concorrente
   @nLin,137 PSAY aArray[nCount][11]//abc
   @nLin,142 PSAY substr( Posicione( "SA1", 1, xFilial('SA1') + aArray[nCount][4], "A1_NREDUZ" ),1,28 )//Cliente
   @nLin,170 PSAY transform( ultcom(aArray[nCount][4],aArray[nCount][5]), "@E 999,999,999.99"  )//
   @nLin,187 PSAY substr( Posicione( "SUS", 1, xFilial('SUS') + aArray[nCount][12], "US_NREDUZ"),1,28 )//cliente

   nLin := nLin + 1 // Avanca a linha de impressao
   nCount++ // Avanca o ponteiro do registro no arquivo
   incRegua()
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

Static Function Media( cProduto, cCodPes )

***************
Local nUltimo:= nCount := nMedia := 0 
Local cQuery := ""

cQuery := "select (Z30_VALOR*1000)/Z30_QUANTI VALOR, Z30_IPI "
cQuery += "from "+retSqlName('Z30')+" "
cQuery += "where Z30_PRODUT = '"+cProduto+"' and Z30_CODPES = '"+cCodPes+"' "
cQuery += "and Z30_FILIAL = '"+xFilial('Z30')+"' and D_E_L_E_T_ != '*' "
cQuery += "order by Z30_VALOR desc "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )
do while _TMPK->( !EoF() )
	_TMPK->( dbSkip() )
	nCount++
endDo
_TMPK->( dbGoTop() )
if nCount > 4
   _TMPK->( dbSkip() )
endIf
do While _TMPK->( !EoF() )
	nMedia  += ( _TMPK->VALOR - ( ( _TMPK->Z30_IPI/100 ) * _TMPK->VALOR ) ) * 1.05
	nUltimo := ( _TMPK->VALOR - ( ( _TMPK->Z30_IPI/100 ) * _TMPK->VALOR ) ) * 1.05
	_TMPK->( dbSkip() )
endDo
if nCount > 4
   nMedia -= nUltimo
   nMedia := nMedia/(nCount - 2)
else
   nMedia := nMedia/nCount
endIf
_TMPK->( dbCloseArea() )

Return nMedia

***************

static function ABC500(aABC, cCliVip)

***************

Local nSeq
aABC    := {}
cCliVip := ""

//Curva ABC 300 Primeiros Clientes nos ultimos 12 meses
cQuery := "SELECT DISTINCT TOP 500  CLIENTE=D2_CLIENTE,NOME=A1_NOME, "
cQuery += "       QUANT=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 "
cQuery += "                ELSE SUM(D2_QUANT) END, "
cQuery += "       PESO=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN CAST(0 AS FLOAT) "
cQuery += "                ELSE SUM(D2_QUANT*B1_PESOR) END, "
cQuery += "       CUSTO=SUM(D2_TOTAL/D2_QUANT), "
cQuery += "       VALOR=SUM(D2_TOTAL) "
cQuery += "FROM   "+RetSqlName("SD2")+" SD2 WITH (NOLOCK), "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "+RetSqlName("SA1")+" SA1 WITH (NOLOCK), "+RetSqlName("SA3")+" "
cQuery += "SA3 WITH (NOLOCK), "+RetSqlName("SF2")+" SF2 WITH (NOLOCK), "+RetSQlName("SBM")+" SBM WITH (NOLOCK) "
//cQuery += "WHERE  D2_EMISSAO BETWEEN "+ dtos(lastday(stod(alltrim( str( year( dDataBase ) ) + mv_par01 + "01" ))) - 360) +" AND "+DtoS(dDataBase)+" AND D2_FILIAL = '01' AND D2_TIPO = 'N' "
cQuery += "WHERE  D2_FILIAL = '01' AND D2_TIPO = 'N' "
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

***************

Static Function ultcom(cCli, cProd)

***************
Local cQuery := ""
Local nTotal := 0
cQuery += "select sum(D2_TOTAL) TOTAL "
cQuery += "from   "+retSqlName('SF2')+" SF2, "+retSqlName('SD2')+" SD2, "+retSqlName('SF4')+" SF4 "
cQuery += "where  F2_FILIAL = '"+xFilial('SF2')+"' and D2_FILIAL = '01' and F4_FILIAL = '01' "
cQuery += "and F2_EMISSAO >= '"+dtos(dDataBase - 60)+"' and F2_CLIENTE = '"+cCli+"' and D2_COD = '"+cProd+"' "
cQuery += "and D2_DOC = F2_DOC and F4_CODIGO = D2_TES and  F4_DUPLIC = 'S' and F2_TIPO = 'N' "
cQuery += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' "
cQuery += "group by F2_DOC,F2_EMISSAO "
cQuery += "order by F2_EMISSAO desc"
TCQUERY cQuery NEW ALIAS "_TMPA"

_TMPA->( dbGoTop() )
do While ! _TMPA->( EoF() )
   nTotal :=  _TMPA->TOTAL
   _TMPA->( dbCloseArea() )
   return nTotal
endDo
_TMPA->( dbCloseArea() )

return nTotal

***************

Static Function maior( cProd )

***************
Local cQuery := ""
Local nTotal := 0
Local aTemp  := Asort( aAbc,,, { | x, y | x[ 1 ] < y[ 1 ] } )
for _x := 1 to len( aTemp )
	cQuery += "select sum(D2_TOTAL) TOTAL "
	cQuery += "from   "+retSqlName('SF2')+" SF2, "+retSqlName('SD2')+" SD2, "+retSqlName('SF4')+" SF4 "
	cQuery += "where  F2_FILIAL = '"+xFilial('SF2')+"' and D2_FILIAL = '01' and F4_FILIAL = '01' "
	cQuery += "and F2_EMISSAO >= '"+dtos(dDataBase - 90)+"' and F2_CLIENTE = '"+aTemp[_x][2]+"' and D2_COD = '"+cProd+"' "
	cQuery += "and D2_DOC = F2_DOC and F4_CODIGO = D2_TES and  F4_DUPLIC = 'S' and F2_TIPO = 'N' "
	cQuery += "and SF2.D_E_L_E_T_ != '*' and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' "
	cQuery += "group by F2_DOC,F2_EMISSAO "
	cQuery += "order by F2_EMISSAO desc "
	TCQUERY cQuery NEW ALIAS "_TMPA"
	_TMPA->( dbGoTop() )
	do While ! _TMPA->( EoF() )
	   nTotal :=  _TMPA->TOTAL
       _TMPA->( dbCloseArea() )
       return nTotal
	endDo
	_TMPA->( dbCloseArea() )
	cQuery := ""
next

return nTotal