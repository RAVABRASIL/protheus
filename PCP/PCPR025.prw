#include "protheus.ch"
#include "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO58    บ Autor ณ AP6 IDE            บ Data ณ  05/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PCPR025()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Informacao por produto "
Local cPict          := ""
Local titulo         := "Informacao por produto "
Local nLin           := 80

                        //          10        20        30        40        50        60        70        80        90        100       110       120
                        //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         :=  "Codigo           Descricao                                           Carteira        Producao        Faturamento"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR025" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR025" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
cTURNO1   := GetMv( "MV_TURNO1" )

pergunte("PCPR025",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"PCPR025",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Informacao por produto Data: "+dtoc(MV_PAR01)
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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  05/09/13   บฑฑ
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
local cQry:=''
Local nOrdem


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQry:="SELECT  "
cQry+="LTRIM(RTRIM(B1_COD)) B1_COD,B1_DESC, "
cQry+="CARTEIRA=(SELECT ISNULL(SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV),0) "
cQry+="FROM SB1010 SB1 WITH (NOLOCK), SC5020 SC5 WITH (NOLOCK), SC6020 SC6 WITH (NOLOCK), SC9020 SC9 WITH (NOLOCK), SA1010 SA1 WITH (NOLOCK) "
cQry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQry+="SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND "
cQry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQry+="SB1.B1_SETOR != '39' AND "
cQry+="SC6.C6_PRODUTO = B1.B1_COD AND "
cQry+="SC5.C5_ENTREG <='"+dtos(MV_PAR01)+"' AND "
cQry+="SC6.C6_TES != '540' AND "
cQry+="SC6.C6_CLI NOT IN ('031732','031733') AND "
cQry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
cQry+="SC5.D_E_L_E_T_ = '' AND "
cQry+="SC6.D_E_L_E_T_ = '' AND "
cQry+="SC9.D_E_L_E_T_ = '' AND "
cQry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "
cQry+=") "
cQry+=",PRODUCAO=(SELECT ISNULL(SUM(Z00.Z00_PESO+Z00_PESCAP),0) "
cQry+="FROM Z00020 Z00 WITH (NOLOCK) "
cQry+="WHERE Z00_FILIAL = ' ' "
cQry+="AND Z00_DATHOR>='"+DtoS(FirstDay( MV_PAR01))+Left(cTURNO1,5)+"'  AND Z00_DATHOR<'"+DtoS(MV_PAR01+1)+Left(cTURNO1,5)+"' "  
cQry+="AND Z00_CODIGO=B1.B1_COD "
cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') "
cQry+="AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' "
cQry+=") "
cQry+=",FATURAMENTO=(SELECT "
///FR - incluir VD , relat๓rio para Francisco relativo a 31/12/13:
If MV_PAR02 = 2 //SEM VD
	cQry+="PESO=ISNULL(sum(CASE WHEN D2_SERIE = ' ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*D2_PESO) END),0) "
Else //COM VD
	cQry+="PESO=ISNULL(sum((D2_QUANT-D2_QTDEDEV)*D2_PESO) ,0 ) "
Endif

cQry+="FROM SD2020 SD2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK), SF2020 SF2 WITH (NOLOCK) "
cQry+="WHERE D2_EMISSAO BETWEEN '"+DtoS(FirstDay( MV_PAR01))+"' AND '"+DtoS(MV_PAR01)+"' "
cQry+="AND D2_TIPO = 'N' "
cQry+="AND D2_TP != 'AP' "
cQry+="and B1_SETOR <>'39'  "
cQry+="AND D2_COD = B1.B1_COD  "
cQry+="AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116' ) "
cQry+="AND D2_CLIENTE NOT IN ('031732','031733') "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD  "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "

///FR - incluir VD , relat๓rio para Francisco relativo a 31/12/13:
If MV_PAR02 = 2 //SEM VD
	cQry+="AND F2_DUPL <> ' ' "
//Else                           
	//cQry+="AND F2_DUPL <> ' ' "
Endif
cQry+="AND SF2.D_E_L_E_T_ = '' "
cQry+=") "
cQry+="FROM SB1010 B1 "
cQry+="WHERE "
cQry+="B1.B1_SETOR<>'39' "
cQry+="AND B1.B1_TIPO='PA' "
cQry+="AND B1.D_E_L_E_T_='' "
MemoWrite("C:\TEMP\PCPR025.SQL", cQry)
TCQUERY cQry NEW ALIAS "TMPX"

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
nTOTCAR := 0
nTOTPROD:= 0
nTOTFAT := 0
TMPX->(dbGoTop())
While TMPX->(!EOF())

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
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:

    @nLin,00 PSAY TMPX->B1_COD
    @nLin,17 PSAY TMPX->B1_DESC
    @nLin,69 PSAY Transform(TMPX->CARTEIRA, "@E 999,999,999.99")
    @nLin,85 PSAY Transform(TMPX->PRODUCAO, "@E 999,999,999.99")   
    @nLin,101 PSAY Transform(TMPX->FATURAMENTO, "@E 999,999,999.99")              

    nLin := nLin + 1 // Avanca a linha de impressao
	nTOTCAR += TMPX->CARTEIRA
	nTOTPROD+= TMPX->PRODUCAO
	nTOTFAT += TMPX->FATURAMENTO
    TMPX->(dbSkip() )  // Avanca o ponteiro do registro no arquivo
EndDo

@nLin,000 PSAY REPLICATE("-" , limite)
nLin++ 
@nLin,000 PSAY "TOTAL GERAL ==> "
@nLin,069 PSAY Transform(nTOTCAR , "@E 999,999,999.99")
@nLin,085 PSAY Transform(nTOTPROD, "@E 999,999,999.99")
@nLin,101 PSAY Transform(nTOTFAT , "@E 999,999,999.99")
nLin++
@nLin,000 PSAY REPLICATE("-" , limite)
nLin++

Roda( 0 , "", tamanho)

TMPX->(DBCLOSEAREA())

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
