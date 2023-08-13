#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO29    บ Autor ณ AP6 IDE            บ Data ณ  17/10/11   บฑฑ
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

User Function FATR031() // relatorio por loja Pedido 

*************

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aMES := { 'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',;
          'Julho', 'Agosto', 'Setembro', 'Outubro','Novembro', 'Dezembro' }

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Atacadao"
Local cPict          := ""
Local titulo         := "Pedido - Atacadao"
Local nLin           := 80
                       //          10        20        30        40        50        60        70        80        90        100       120       130
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := " "                       
Local Cabec2         := " "
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATR031" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR031" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte('FATR029',.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"FATR029",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo := "Pedido - Atacadao - Mes: "+StrZero(val(MV_PAR01),2)+' - '+aMEs[val(MV_PAR01)]
nMAnt:=val(MV_PAR01)-1
cMant:=StrZero(iif(nMAnt=0,12,nMAnt),2)
cMatu:=StrZero(val(MV_PAR01),2)
                 //          10        20        30        40        50        60        70        80        90        100       120       130
                 //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec1         := "Codigo      Descricao                                                QTD(Kg)       Valor(R$)     QTD(Kg)       Valor(R$) Evolucao"                       
Cabec2         := "                                                                     Mes "+cMant+space(7)+" Mes "+cMant+space(7)+" Mes "+cMatu+space(7)+" Mes "+cMatu+space(6)+"%"

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  17/10/11   บฑฑ
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
Local cQry:=''   
Local cCod:=''
local aMesAnt:={}
local nTotQAnt:=nTotVAnt:=nTotQ:=nTotV:=0
local nTTotQAnt:=nTTotVAnt:=nTTotQ:=nTTotV:=0


cQry:="SELECT  "
cQry+="case when len(C6_PRODUTO) >= 8 then  "
cQry+="case when ( SUBSTRING( C6_PRODUTO, 4, 1 ) = 'R') or ( SUBSTRING( C6_PRODUTO, 5, 1 ) = 'R') "
cQry+="then SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 4) + SUBSTRING( C6_PRODUTO, 8, 2) "
cQry+="else SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 3) + SUBSTRING( C6_PRODUTO, 7, 2) end  "
cQry+="else C6_PRODUTO END  as C6_PRODUTO,  "
cQry+="A1_COD,A1_END,A1_EST "
cQry+=",(sum(C6_VALOR)) VALOR, (sum(C6_QTDVEN * case when B1_SETOR!='39' then B1_PESO else 1 end )) QTD_KG "

cQry+="from " + RetSqlName("SA1") + "  SA1 WITH (NOLOCK) "

cQry+="LEFT JOIN " + RetSqlName("SC5") + "  SC5 WITH (NOLOCK)  ON  SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA  "
cQry+="AND substring(C5_EMISSAO,1,6)='"+StrZero(year(dDatabase),4)+StrZero(val(MV_PAR01),2)+"'  "
cQry+="AND C5_TIPO = 'N'  "
cQry+="and SC5.D_E_L_E_T_ != '*'  "

cQry+="LEFT JOIN " + RetSqlName("SC6") + "  SC6 WITH (NOLOCK)  ON  C6_NUM = C5_NUM  "
cQry+="AND SC6.C6_TES =(SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " SF4 WHERE SF4.F4_CODIGO=SC6.C6_TES AND UPPER(SF4.F4_DUPLIC) ='S' and SF4.D_E_L_E_T_ != '*') "
cQry+="and SC6.D_E_L_E_T_ != '*'  "

cQry+="LEFT JOIN " + RetSqlName("SB1") + "  SB1 WITH (NOLOCK)  ON  C6_PRODUTO = B1_COD "
cQry+="AND B1_TIPO != 'AP'  "
cQry+="and SB1.D_E_L_E_T_ != '*' "

cQry+="where   "

cQry+="SUBSTRING(A1_CGC,1,8)='75315333' "         // ATACADAO 
cQry+="and SA1.D_E_L_E_T_ != '*' "


cQry+="GROUP BY  "
cQry+="case when len(C6_PRODUTO) >= 8 then  "
cQry+="case when ( SUBSTRING( C6_PRODUTO, 4, 1 ) = 'R') or ( SUBSTRING( C6_PRODUTO, 5, 1 ) = 'R') "
cQry+="then SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 4) + SUBSTRING( C6_PRODUTO, 8, 2) "
cQry+="else SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 3) + SUBSTRING( C6_PRODUTO, 7, 2) end " 
cQry+="else C6_PRODUTO END  ,  "
cQry+="A1_COD,A1_END,A1_EST  "
cQry+="ORDER BY A1_COD "

TCQUERY cQry NEW ALIAS "TMPZ"



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

TMPZ->(dbGoTop())
While TMPZ->(!EOF())

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
   
   cCod:=TMPZ->A1_COD
   aMesAnt:={}
   nTotQAnt:=0
   nTotVAnt:=0
   nTotQ:=0
   nTotV:=0
       
   @nLin++,00 PSAY "Cliente: "+alltrim(cCod)+' - UF: '+TMPZ->A1_EST+' - End.: '+TMPZ->A1_END
   @nLin++
   Do While TMPZ->(!EOF()) .AND. TMPZ->A1_COD=cCod
   	  
	  If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	     nLin := 9
	  Endif
   
      aMesAnt:=MesAnt(TMPZ->C6_PRODUTO,cCod)
      // Coloque aqui a logica da impressao do seu programa...
      // Utilize PSAY para saida na impressora. Por exemplo:
      @nLin,00 PSAY TMPZ->C6_PRODUTO
      @nLin,12 PSAY posicione("SB1",1,xFilial('SB1') + TMPZ->C6_PRODUTO,"B1_DESC")
      @nLin,65 PSAY TransForm( aMesAnt[1][1], '@E 9,999,999.99' )
      @nLin,79 PSAY TransForm( aMesAnt[1][2], '@E 9,999,999.99' )
      
      @nLin,93 PSAY TransForm(  TMPZ->QTD_KG, '@E 9,999,999.99' )
      @nLin,107 PSAY TransForm( TMPZ->VALOR, '@E 9,999,999.99' )
      @nLin,121 PSAY TransForm( (TMPZ->QTD_KG/aMesAnt[1][1])*100-100, '@E 999.99' )
      
      
      // Total por Cliente 
       nTotQAnt+=aMesAnt[1][1]
       nTotVAnt+=aMesAnt[1][2]
       nTotQ+=TMPZ->QTD_KG
       nTotV+=TMPZ->VALOR
      // Total Geral 
       nTTotQAnt+=aMesAnt[1][1]
       nTTotVAnt+=aMesAnt[1][2]
       nTTotQ+=TMPZ->QTD_KG
       nTTotV+=TMPZ->VALOR
      //
      
      nLin := nLin + 1 // Avanca a linha de impressao
      Incregua()
      TMPZ->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
      @nLin,00    PSAY replicate('_',132)
      @nLin,63    PSAY "--->> "
      @nLin,65    PSAY TransForm( nTotQAnt, '@E 9,999,999.99' )
      @nLin,79    PSAY TransForm( nTotVAnt, '@E 9,999,999.99' )
      @nLin,93    PSAY TransForm( nTotQ,    '@E 9,999,999.99' )
      @nLin,107 PSAY TransForm(nTotV,    '@E 9,999,999.99' )
      @nLin++,121 PSAY TransForm( (nTotQ/nTotQAnt)*100-100, '@E 999.99' )
EndDo
      @nLin,51    PSAY "Total Geral: "
      @nLin,64    PSAY TransForm( nTTotQAnt, '@E 9,999,999.99' )
      @nLin,78    PSAY TransForm( nTTotVAnt, '@E 9,999,999.99' )
      @nLin,92    PSAY TransForm( nTTotQ,    '@E 9,999,999.99' )
      @nLin,106 PSAY TransForm(nTTotV,    '@E 9,999,999.99' )
      @nLin++,120 PSAY TransForm( (nTTotQ/nTTotQAnt)*100-100, '@E 999.99' )

TMPZ->(DBCLOSEAREA())

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

Static Function MesAnt(cPROD1,cCod)

***************

local cPeriodo:=""
local cQry:=''
local aRet:={}

// Mes Anterior 
dData := CtoD( '15'+'/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) )
cPeriodo:=substr(dtos(dData-30),1,6) 


If !Empty(cPROD1)
	If Len( AllTrim( cPROD1 ) ) <= 7 
	   cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
	Else
	   cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
	EndIf
Else
    cPROD2 :=" "
Endif

cQry:="SELECT "

cQry+="(sum(C6_VALOR)) VALOR_ANT, (sum(C6_QTDVEN * B1_PESO)) QTD_KG_ANT  "

cQry+="from SA1010 SA1, "
cQry+="SC5020 SC5,  "
cQry+="SC6020 SC6, "
cQry+="SB1010 SB1, "
cQry+="SF4010 SF4 "

cQry+="where " 

cQry+="SUBSTRING(A1_CGC,1,8)='75315333' "

cQry+="AND C6_PRODUTO IN ('"+cPROD1+"','"+cPROD2+"' )    "
cQry+="AND A1_COD='"+cCod+"'  "
 
cQry+="AND SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA "
cQry+="AND substring(C5_EMISSAO,1,6)='"+cPeriodo+"'  "
cQry+="AND C5_TIPO = 'N' "
cQry+="AND C6_NUM = C5_NUM  "
cQry+="AND C6_PRODUTO = B1_COD "
cQry+="AND B1_TIPO != 'AP' "
cQry+="AND C6_TES = F4_CODIGO  "
cQry+="and F4_DUPLIC = 'S' "
cQry+="and SF4.D_E_L_E_T_ != '*' " 
cQry+="and SB1.D_E_L_E_T_ != '*' "
cQry+="AND SC6.D_E_L_E_T_ != '*' "
cQry+="and SC6.D_E_L_E_T_ != '*' "
cQry+="and SC5.D_E_L_E_T_ != '*' "
cQry+="and SA1.D_E_L_E_T_ != '*' "


TCQUERY cQry NEW ALIAS "TMPY"

If TMPY->(!EOF())
   AADD(aRet,{TMPY->QTD_KG_ANT,TMPY->VALOR_ANT})
Else
   AADD(aRet,{0,0})
Endif

TMPY->(dbclosearea())

Return aRet

