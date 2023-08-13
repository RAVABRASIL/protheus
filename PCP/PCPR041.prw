#INCLUDE "rwmake.ch"
#Include 'Topconn.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PCPR041  บ Autor ณ AP6 IDE            บ Data ณ  25/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ VALORIZAวรO DE ESTOQUES                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPRAS / PCP                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PCPR041()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Valorizacao do Estoque"
Local cPict          := ""
Local titulo         := "Valorizacao do Estoque"
Local nLin           := 80
                       //          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200
                       //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Familia  Codigo           Descricao                                                     Um         Qtd            Custo Unit.      Valoriz.Item          Data Ult.        Qtde.Movimentada        Valoriz."
Local Cabec2         := "                                                                                                 Estoque          Ult.NF Entr.    (Qtd.Estq x Custo)     Compra                                   Movimento"
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR041" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR041" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := ""

PERGUNTE('PCPR041',.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"PCPR041",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  25/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
local cQry:=''
Local cTipo:=""
Local nValorB2:=0
Local nValorD3
Local LF    := CHR(13) + CHR(10)


cQry:="SELECT "        + LF

cQry+="TIPO,CODIGO,DESCRICAO,UM,  "  + LF
cQry+="QTDB2=ISNULL(QTDB2,0),  "  + LF
cQry+="CUSTUNI_D1=ISNULL(UNITD1,0), "  + LF 
//cQry+="VALORIZ_B2=ISNULL(QTDB2 * UNITD1,0),   "  + LF
cQry+="VALORIZ_B2= (case when QTDB2 > 0 then (QTDB2 * UNITD1) else 0 END),   "  + LF
cQry+="ULTCOMPRA=ISNULL(ULTCOMPRA,0) , "  + LF
cQry+="QTENTD3=ISNULL(QTENTD3,0), "  + LF
cQry+="QTSAID3=ISNULL(QTSAID3,0) "  + LF


cQry+="FROM (  "  + LF
cQry+="SELECT  "  + LF

cQry+=" B1_TIPO TIPO,B1_COD CODIGO,B1_DESC DESCRICAO,B1_UM UM,  "  + LF
cQry+=" ISNULL(SUM(SB2.B2_QATU),0) AS QTDB2, "  + LF

cQry+="UNITD1=(SELECT TOP 1 SD1.D1_VUNIT FROM " + RetSqlName("SD1") + " SD1 "  + LF
cQry+="       WHERE SD1.D1_COD=B1_COD AND SD1.D1_TIPO='N' AND SD1.D_E_L_E_T_='' "  + LF
cQry+="       AND SD1.D1_FILIAL = '" + Alltrim(xFilial("SD1")) + "' " + LF
If !Empty(MV_PAR04)
	cQry += " and SD1.D1_DTDIGIT BETWEEN '" + Dtos(MV_PAR03) + "'  and '" + Dtos(MV_PAR04) + "' " + LF
Endif
cQry+="       ORDER BY SD1.D1_DTDIGIT DESC), "  + LF + LF

cQry+="ULTCOMPRA=(SELECT TOP 1 SD1.D1_DTDIGIT FROM " + RetSqlName("SD1") + " SD1 "  + LF
cQry+="       WHERE SD1.D1_COD=B1_COD AND SD1.D1_TIPO='N' AND SD1.D_E_L_E_T_='' "  + LF
cQry+="       AND SD1.D1_FILIAL = '" + Alltrim(xFilial("SD1")) + "' " + LF
If !Empty(MV_PAR04)
	cQry += " and SD1.D1_DTDIGIT BETWEEN '" + Dtos(MV_PAR03) + "'  and '" + Dtos(MV_PAR04) + "' " + LF
Endif
cQry+="       ORDER BY SD1.D1_DTDIGIT DESC) , "  + LF + LF


cQry+=" QTSAID3=(SELECT SUM(SD3.D3_QUANT) FROM " + RetSqlName("SD3") + "  SD3  " + LF
cQry+="       WHERE SD3.D3_COD=B1_COD AND SD3.D_E_L_E_T_='' " + LF
cQry+="       AND SD3.D3_TM >= '500'  " + LF
cQry+="       AND SD3.D3_FILIAL = '" + Alltrim(xFilial("SD3")) + "'  " + LF
If !Empty(MV_PAR04)
	cQry += " and SD3.D3_EMISSAO BETWEEN '" + Dtos(MV_PAR03) + "'  and '" + Dtos(MV_PAR04) + "' " + LF
Endif )
cQry += " ) , " + LF
 
cQry+=" QTENTD3=(SELECT SUM(SD3.D3_QUANT) FROM " + RetSqlName("SD3") + "  SD3  " + LF
cQry+="       WHERE SD3.D3_COD=B1_COD AND SD3.D_E_L_E_T_='' " + LF
cQry+="       AND SD3.D3_TM <= '499'   " + LF
cQry+="       AND SD3.D3_FILIAL = '" + Alltrim(xFilial("SD3")) + "'  " + LF
If !Empty(MV_PAR04)
	cQry += " and SD3.D3_EMISSAO BETWEEN '" + Dtos(MV_PAR03) + "'  and '" + Dtos(MV_PAR04) + "' " + LF
Endif 
cQry += " ) " + LF

cQry+="FROM " + RetSqlName("SB2") + " SB2 WITH (NOLOCK) " + LF
cQry+=" , " + RetSqlName("SB1") + " SB1 WITH (NOLOCK)  "  + LF
cQry+="WHERE SB2.B2_COD = SB1.B1_COD  "  + LF
cQry+="AND SB2.B2_LOCAL = '01'  "  + LF
cQry+="AND SB1.B1_ATIVO <>'N' "    + LF // ATIVO  
cQry+="AND SB1.B1_TIPO BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "   + LF //familia
cQry+="AND LEN(SB1.B1_COD) < 8   "  + LF
If Alltrim(xFilial("SB2")) = '01'
	cQry+="AND SB1.B1_SETOR <> '39'  "  + LF   //nใo pode excluir 
Endif
cQry+="AND SB2.D_E_L_E_T_ = ''   "  + LF
cQry+="AND SB1.B1_FILIAL = '  '  "  + LF
cQry+="AND SB1.D_E_L_E_T_ = ''   "  + LF 
cQry+="AND SB2.B2_FILIAL = '" + Alltrim(xFilial("SB2")) + "' " + LF

//SE O USUมRIO PREFERIR ESCOLHER PERอODO, UTILIZO O B2_USAI (ฺLTIMA SAอDA DO PRODUTO)
//If !Empty(MV_PAR04)
	//cQry += " and SB2.B2_USAI BETWEEN '" + Dtos(MV_PAR03) + "'  and '" + Dtos(MV_PAR04) + "' " + LF
//Endif

cQry+="GROUP BY B1_TIPO,B1_COD,B1_DESC,B1_UM "  + LF
cQry+=") AS TABX "  + LF
cQry+="ORDER BY TIPO,CODIGO,DESCRICAO,UM "  + LF
MemoWrite("C:\TEMP\PCPR041.SQL", cQry )

If Select("TMP") > 0
      DbSelectArea("TMP")
      DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMP"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

titulo         := "Valorizacao do Estoque - Periodo: " + Dtoc(MV_PAR03) + " A " + Dtoc(MV_PAR04)

TMP->(dbGoTop())
While TMP->(!EOF())

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    cTipo:=TMP->TIPO
    nValorB2 := 0
    nValorD3 := 0
    While TMP->(!EOF()) .AND. TMP->TIPO==cTipo
	    
	    If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
           Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
           nLin := 9
        Endif

	    nCol:=0
	    @nLin,nCol PSAY TMP->TIPO
	    nCol+=09
	    @nLin,nCol PSAY TMP->CODIGO
	    nCol+=17
	    @nLin,nCol PSAY TMP->DESCRICAO
	    nCol+=62
	    @nLin,nCol PSAY TMP->UM
	    nCol+=05
	    @nLin,nCol PSAY Transform(TMP->QTDB2, "@E 999,999,999.9999")
	    nCol+=18
	    @nLin,nCol PSAY Transform(TMP->CUSTUNI_D1, "@E 999,999,999.9999")
	    nCol+=18
	    @nLin,nCol PSAY Transform(TMP->VALORIZ_B2, "@E 999,999,999.9999")
	    nCol+=22
	    @nLin,nCol PSAY dtoc(stod(TMP->ULTCOMPRA) )
	    
	    //qtde movimentada no D3
	    nQTMOV := IIF( TMP->QTENTD3 >= TMP->QTSAID3, TMP->QTENTD3 - TMP->QTSAID3 , TMP->QTSAID3 - TMP->QTENTD3)
	    nCol+=18
	    @nLin,nCol PSAY Transform( nQTMOV, "@E 999,999,999.9999") 
	    
	    //MULTIPLICA O TOTAL MOVIMENTADO NO D3 x CUSTO DA ฺLTIMA NOTA FISCAL ENTRADA
	    nCol+=18
	    @nLin,nCol PSAY Transform( nQTMOV * TMP->CUSTUNI_D1, "@E 999,999,999.9999")
	    
	   nLin++
	   nValorB2+= TMP->VALORIZ_B2
	   nValorD3+= (nQTMOV * TMP->CUSTUNI_D1)
	   IncRegua()
	   TMP->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
	nLin++
	//nLin++
	@nLin,000 PSAY replicate(".",220)
	nLin++
    @nLin,097 PSAY "Valorizacao Estoque R$: "
	@nLin,129 PSAY Transform(nValorB2, "@E 999,999,999.9999")	    
	@nLin,157 PSAY "Valorizacao Movimentos R$: "
	@nLin,187 PSAY Transform(nValorD3, "@E 999,999,999.9999")
	nLin++
	@nLin,000 PSAY replicate(".",220)
	nLin++
EndDo
nLin++
//nLin++

TMP->(Dbclosearea())
//Roda( 0 , "" , TAMANHO )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
