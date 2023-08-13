#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บ Autor ณ AP6 IDE            บ Data ณ  06/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*************

User Function fProLin()

*************

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Produto por Linha "
Local cPict          := ""
Local titulo         := "Produto por Linha "
Local nLin           := 80
                        //         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Codigo           Descricao                                           Prev. Venda     Venda Real      Plano Prod.     Prod. Real      Qtd OP          % Confronto"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "fProLin" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "fProLin" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")


hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)



ValidPerg("fProLin")

PERGUNTE("fProLin",.F.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"fProLin",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

cData:= SUPERGETMV("RV_PROLIN",,'20150826')
 
titulo := "Produto por Linha De:"+dtoc(MV_PAR01)+' Ate:'+dtoc(MV_PAR02)+' Producao: '+iif(MV_PAR03=1,'Pesagem','Carrinho')+'  Revisao.:'+DTOC(StoD(CDATA))

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  06/08/15   บฑฑ
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

LOCAL cQry:= " "
Local nOrdem

cQry:="SELECT  "
cQry+="LTRIM(RTRIM(B1_COD)) B1_COD,B1_DESC, "
cQry+="LINHA=CASE "
cQry+="      WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' "
cQry+="      WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' "
cQry+="      WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR'           "
cQry+="      ELSE 'X-'+B1_GRUPO "
cQry+="      END "
cQry+="FROM " + RetSqlName( "SB1" ) + " B1 "
cQry+="WHERE "
cQry+="B1.B1_SETOR<>'39' "
cQry+="AND LEN(B1_COD)<8 "
cQry+="AND B1.B1_ATIVO<>'N' "
cQry+="AND B1_TIPO='PA' "
cQry+="AND B1_GRUPO IN('A','B','C','D','E','G') "
cQry+="AND B1_MSBLQL<>'1' "
cQry+="AND B1.D_E_L_E_T_=' ' "
cQry+="order by LINHA,B1_COD "

TCQUERY cQry NEW ALIAS "TMPX"


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

nTPreVe:= 0
nTVendaR:= 0
nTPlanoP:= 0
nTProdR:= 0
nTQtdOP:= 0

TMPX->(dbGoTop())
While TMPX->(!EOF())

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   	      If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		     nLin := 8
          Endif

   
   @nLin++
   cLinha:=TMPX->LINHA 
   @nLin++,00 PSAY  "Linha: "+cLinha
   @nLin++

       
   While TMPX->(!EOF())  .AND. TMPX->LINHA ==cLinha 
   
	      If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		     nLin := 8
             @nLin++
             @nLin++,00 PSAY  "Continua Linha: "+cLinha
             @nLin++
          Endif

	   	   
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
	
	    @nLin,00 PSAY TMPX->B1_COD
	    
	    aPlanoPro:=fPlanoPro()
	    
	    @nLin,17 PSAY TMPX->B1_DESC
	    
	    nPreVe := aPlanoPro[1]
	    nTPreVe+= nPreVe
	    
	    @nLin,69 PSAY Transform(nPreVe,"@E 999,999,999.99")
	    
	    nVendaR := fvendaR(TMPX->B1_COD)
        nTVendaR+= nVendaR	    
	    
	    @nLin,85 PSAY Transform(nVendaR,"@E 999,999,999.99")   
	    
	    nPlanoP:= aPlanoPro[2]
	    nTPlanoP+= nPlanoP

	    @nLin,101 PSAY Transform(nPlanoP,"@E 999,999,999.99")              
	    
	    nProdR:= fProdR()
	    nTProdR+= nProdR
	    	    
	    @nLin,117 PSAY Transform(nProdR,"@E 999,999,999.99")              
	    
	    nQtdOP := fQtdOP()
	    nTQtdOP+= nQtdOP
	    	    
	    @nLin,133 PSAY Transform(nQtdOP,"@E 999,999,999.99")              
	    
	    nPerc:= (nProdR/ nPlanoP) *100
	    
	    @nLin,149 PSAY Transform(nPerc,"@E 999,999,999.99")              
	
	    nLin := nLin + 1 // Avanca a linha de impressao
	
	    TMPX->(dbSkip())  // Avanca o ponteiro do registro no arquivo
	
   EndDo

// totais 
@nLin++

@nLin,17 PSAY " T O T A L :"

@nLin,69 PSAY Transform(nTPreVe,"@E 999,999,999.99")

@nLin,85 PSAY Transform(nTVendaR,"@E 999,999,999.99")

@nLin,101 PSAY Transform(nTPlanoP,"@E 999,999,999.99")

@nLin,117 PSAY Transform(nTProdR,"@E 999,999,999.99")

@nLin,133 PSAY Transform(nTQtdOP,"@E 999,999,999.99")

nTPerc:= (nTProdR/nTPlanoP)*100

@nLin++,149 PSAY Transform(nTPerc,"@E 999,999,999.99")

//


   
EndDo

TMPX->(dbclosearea())


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

***************

Static Function fvendaR(cPROD1)

***************

LOCAL cQry:=Qry:=" "
LOCAL nRet:=0


if Len( AllTrim( cPROD1 ) ) <= 7
	cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
else
	cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
endif


/*
cQry:="SELECT "

cQry+="isnull(SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO)) END),0) AS FATURAMENTO "

cQry+="FROM " + RetSqlName( "SD2" ) + " SD2 WITH (NOLOCK), " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK), " + RetSqlName( "SF2" ) + " SF2 WITH (NOLOCK) , " + RetSqlName( "SC6" ) + " SC6 WITH (NOLOCK), " + RetSqlName( "SC5" ) + " SC5 WITH (NOLOCK) "
cQry+="WHERE "
cQry+="C5_NUM=C6_NUM  "
cQry+="and D2_PEDIDO=C6_NUM "
cQry+="AND D2_COD=C6_PRODUTO "
cQry+="AND D2_FILIAL=C6_FILIAL "
cQry+="and D2_COD IN( '"+cProd1+"', '"+cProd2+"' ) "
cQry+="AND C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' "
cQry+="AND D2_TIPO = 'N' "
cQry+="AND D2_TP != 'AP' "
cQry+="AND SB1.B1_SETOR <> '39' "
cQry+="AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQry+="AND D2_CLIENTE NOT IN ('031732','031733') "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQry+="AND F2_DUPL <> ' ' "
cQry+="AND SF2.D_E_L_E_T_ = '' "
cQry+="AND SC6.D_E_L_E_T_ = '' "
cQry+="AND SC5.D_E_L_E_T_ = '' "


TCQUERY cQry NEW ALIAS "AUX1"

If AUX1->(!EOF())
   
   nRet+= AUX1->FATURAMENTO

EndIf

AUX1->(dbclosearea())


Qry:="SELECT "

Qry+="isnull(SUM( (SC6.C6_QTDVEN - SC6.C6_QTDENT )*(SB1.B1_PESO) ),0) AS CARTEIRA_KG "

Qry+="FROM " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK), " + RetSqlName( "SC5" ) + " SC5 WITH (NOLOCK), " + RetSqlName( "SC6" ) + " SC6 WITH (NOLOCK), " + RetSqlName( "SC9" ) + " SC9 WITH (NOLOCK), " + RetSqlName( "SA1" ) + " SA1 WITH (NOLOCK) "

Qry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
Qry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
Qry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
Qry+="SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND "
Qry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
Qry+="SB1.B1_SETOR <> '39' and "
Qry+="SC5.C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' AND  "
Qry+="B1_COD IN( '"+cProd1+"', '"+cProd2+"' ) AND "
Qry+="SC6.C6_TES != '540' AND "
Qry+="SC6.C6_CLI NOT IN ('031732','031733') AND "
Qry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
Qry+="SC5.D_E_L_E_T_ = '' AND "
Qry+="SC6.D_E_L_E_T_ = '' AND "
Qry+="SC9.D_E_L_E_T_ = '' AND "
Qry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "

TCQUERY Qry NEW ALIAS "CARTX"

If CARTX->(!EOF())
   
   nRet+= CARTX->CARTEIRA_KG

EndIf

CARTX->(dbclosearea())
*/

/// melhorar a performace do relatorio , FACวO UM UNION NA SC9 DO JA FATURADO COM O NAO FATURADO , ao inves de pegar do sd2 o faturado e juntar com sc9 carteira.

Qry:="select "

Qry+="CARTEIRA_KG=SUM(CARTEIRA_KG) "

Qry+="FROM ( "

Qry+="SELECT "

Qry+="SITUACAO='NAO FATURADO ', "
Qry+="isnull(SUM( (SC6.C6_QTDVEN - SC6.C6_QTDENT )*(SB1.B1_PESO) ),0) AS CARTEIRA_KG "

Qry+="FROM " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK), " + RetSqlName( "SC5" ) + " SC5 WITH (NOLOCK), " + RetSqlName( "SC6" ) + " SC6 WITH (NOLOCK), " + RetSqlName( "SC9" ) + " SC9 WITH (NOLOCK), " + RetSqlName( "SA1" ) + " SA1 WITH (NOLOCK) "

Qry+="WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
Qry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
Qry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
Qry+="SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND "
Qry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
Qry+="SB1.B1_SETOR <> '39' and "

Qry+="SC5.C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' AND  "
Qry+="B1_COD IN( '"+cProd1+"', '"+cProd2+"' ) AND "

Qry+="SC6.C6_TES != '540' AND "
Qry+="SC5.C5_FILIAL = SC6.C6_FILIAL AND " 
Qry+="SC6.C6_FILIAL = SC9.C9_FILIAL AND " 
Qry+="SC6.C6_CLI NOT IN ('031732','031733','006543','007005') AND "
Qry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
Qry+="SC5.D_E_L_E_T_ = '' AND "
Qry+="SC6.D_E_L_E_T_ = '' AND "
Qry+="SC9.D_E_L_E_T_ = '' AND "
Qry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "

Qry+="UNION "

Qry+="SELECT "

Qry+="SITUACAO='JA FATURADO ', "
Qry+="isnull(SUM( (SC6.C6_QTDVEN  )*(SB1.B1_PESO) ),0) AS CARTEIRA_KG "

Qry+="FROM " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK), " + RetSqlName( "SC5" ) + " SC5 WITH (NOLOCK), " + RetSqlName( "SC6" ) + " SC6 WITH (NOLOCK), " + RetSqlName( "SC9" ) + " SC9 WITH (NOLOCK), " + RetSqlName( "SA1" ) + " SA1 WITH (NOLOCK) "

Qry+="WHERE "

Qry+="SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
Qry+="SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
Qry+="SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
Qry+="SC9.C9_BLCRED IN( '10') and SC9.C9_BLEST = '10' AND "
Qry+="SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
Qry+="SB1.B1_SETOR <> '39' and "

Qry+="SC5.C5_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' AND  "
Qry+="B1_COD IN( '"+cProd1+"', '"+cProd2+"' ) AND "

Qry+="SC6.C6_TES != '540' AND "
Qry+="SC5.C5_FILIAL = SC6.C6_FILIAL AND " 
Qry+="SC6.C6_FILIAL = SC9.C9_FILIAL AND " 
Qry+="SC6.C6_CLI NOT IN ('031732','031733','006543','007005') AND "
Qry+="SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
Qry+="SC5.D_E_L_E_T_ = '' AND "
Qry+="SC6.D_E_L_E_T_ = '' AND "
Qry+="SC9.D_E_L_E_T_ = '' AND "
Qry+="SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "
Qry+=") AS TABX "

MemoWrite("C:\Temp\FPROLIN.sql", Qry )

TCQUERY Qry NEW ALIAS "CARTX"

If CARTX->(!EOF())
   
   nRet:= CARTX->CARTEIRA_KG

EndIf

CARTX->(dbclosearea())

///



Return nRet


***************

Static Function fProdR()

***************

LOCAL cQry:=" "
LOCAL nRet:=0



if MV_PAR03=1 // Pesagem 

	cQry:="SELECT "
	
	cQry+="ISNULL(SUM(Z00.Z00_PESO+Z00_PESCAP),0)  AS PESO "
	
	cQry+="FROM " + RetSqlName( "Z00" ) + " Z00 WITH (NOLOCK), " + RetSqlName( "SC2" ) + " SC2 WITH (NOLOCK),  " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK) "
	cQry+="WHERE Z00_FILIAL = ''  "
	cQry+="and B1_COD='"+TMPX->B1_COD+"' "
	cQry+="AND C2_PRODUTO=B1_COD "
	cQry+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN  "
	cQry+="AND Z00.Z00_DATHOR >= '"+DTOS(MV_PAR01)+hora1+"' AND Z00.Z00_DATHOR < '"+DTOS(MV_PAR02+1)+hora1+"' "
	cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2)  IN ('C0','C1','P0','S0') "
	cQry+="AND Z00.Z00_APARA = '' AND Z00.D_E_L_E_T_ = '' "
	cQry+="AND SB1.D_E_L_E_T_='' "
	
else  // carrinho 

	cQry:="SELECT "

	cQry+="PESO=ISNULL(sum(ZZ2.ZZ2_QUANT),0) "

    cQry+="FROM " + RetSqlName( "ZZ2" ) + " ZZ2 , " + RetSqlName( "SC2" ) + " SC2 WITH (NOLOCK),  " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK) "
    cQry+="WHERE "
    cQry+="B1_COD='"+TMPX->B1_COD+"' "
    cQry+="AND C2_PRODUTO=B1_COD "
    cQry+="AND ZZ2_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
    cQry+="and (ZZ2_DATA+ZZ2_HORA >= '"+DTOS(MV_PAR01)+hora1+"' AND ZZ2_DATA+ZZ2_HORA  <'"+DTOS(MV_PAR02+1)+hora1+"' ) "    
    cQry+="AND SUBSTRING(ZZ2_MAQ,1,2)  IN ('C0','C1','P0','S0')  "
    cQry+="AND ZZ2.D_E_L_E_T_ = ' '  "

endif

TCQUERY cQry NEW ALIAS "AUX2"

If AUX2->(!EOF())
   
   nRet:=AUX2->PESO

EndIf

AUX2->(dbclosearea())

Return nRet


***************

Static Function fQtdOP()

***************

LOCAL cQry:=" "
LOCAL nRet:=0


if MV_PAR03=1 // Pesagem 

	cQry:="SELECT  "
	
	cQry+="COUNT(DISTINCT C2_NUM) QTDOP "
	
	cQry+="FROM Z00020 Z00 WITH (NOLOCK), SC2020 SC2 WITH (NOLOCK),  SB1010 SB1 WITH (NOLOCK) "
	cQry+="WHERE Z00_FILIAL = ''  "
	cQry+="and B1_COD='"+TMPX->B1_COD+"' "
	cQry+="AND C2_PRODUTO=B1_COD  "
	cQry+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN  "
	cQry+="AND Z00.Z00_DATHOR >=  '"+DTOS(MV_PAR01)+hora1+"' AND Z00.Z00_DATHOR <'"+DTOS(MV_PAR02+1)+hora1+"' "
	cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2)  IN ('C0','C1','P0','S0') "
	cQry+="AND Z00.Z00_APARA = '' AND Z00.D_E_L_E_T_ = '' "
	cQry+="AND SB1.D_E_L_E_T_='' "
	
else   // CARRINHO 

	cQry:="SELECT "

	cQry+="COUNT(DISTINCT C2_NUM) QTDOP "

    cQry+="FROM " + RetSqlName( "ZZ2" ) + " ZZ2 , " + RetSqlName( "SC2" ) + " SC2 WITH (NOLOCK),  " + RetSqlName( "SB1" ) + " SB1 WITH (NOLOCK) "
    cQry+="WHERE "
    cQry+="B1_COD='"+TMPX->B1_COD+"' "
    cQry+="AND C2_PRODUTO=B1_COD "
    cQry+="AND ZZ2_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
    cQry+="and (ZZ2_DATA+ZZ2_HORA >= '"+DTOS(MV_PAR01)+hora1+"' AND ZZ2_DATA+ZZ2_HORA  <'"+DTOS(MV_PAR02+1)+hora1+"' ) "    
    cQry+="AND SUBSTRING(ZZ2_MAQ,1,2)  IN ('C0','C1','P0','S0')  "
    cQry+="AND ZZ2.D_E_L_E_T_ = ' '  "

endif  


TCQUERY cQry NEW ALIAS "AUX3"

If AUX3->(!EOF())
   
   nRet:=AUX3->QTDOP

EndIf

AUX3->(dbclosearea())

Return nRet



***************

Static Function fPlanoPro()

***************

LOCAL cQry:=" "
LOCAL aRet:={}


cQry:="SELECT isnull(SUM(ZZ5_PREVEN),0) ZZ5_PREVEN ,isnull(SUM(ZZ5_PLAPRO),0) ZZ5_PLAPRO "
cQry+="FROM " + RetSqlName( "ZZ5" ) + " ZZ5  "
cQry+="WHERE ZZ5_FILIAL = ' '  "
cQry+="AND ZZ5_PROD='"+TMPX->B1_COD+"' "
cQry+="AND ZZ5.D_E_L_E_T_=' '  "

  
TCQUERY cQry NEW ALIAS "AUX4"

If AUX4->(!EOF())

	Aadd( aRet,AUX4->ZZ5_PREVEN )   
	Aadd( aRet,AUX4->ZZ5_PLAPRO )   
	
else

	Aadd( aRet,0 )   
	Aadd( aRet,0 )   
	
EndIf

AUX4->(dbclosearea())


Return aRet

***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Data De     ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Data Ate    ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )
putSx1(cPerg, '03','Producao    ?','','','mv_ch3','N', 1,0,0,'C','','','','','mv_par03','Pesagem','','','','Carrinho','','','','','','','','','','','',{"Escolha uma opcao"},{},{})


Return


***************************
Static Function Scheddef()
***************************
Local aParam
Local aOrd     := {}
 
aParam := { "R",;      // Tipo R para relatorio P para processo  
            "fProLin",; // Pergunte do relatorio, caso nao use passar ParamDef           
            "",;       // Alias           
            aOrd,;     // Array de ordens  
            "fProLin SchedDef"}   
Return aParam