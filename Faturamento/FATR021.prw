#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO36    º Autor ³ AP6 IDE            º Data ³  09/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR021()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Pedido Cross-Docking"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR021" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR021" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

PERGUNTE("FATR021",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FATR021",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo :="Pedido Cross-Docking De "+DTOC(MV_PAR01)+" Ate "+DTOC(MV_PAR02)
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


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQry:=''
Local cNum:=''
local nValor:=0
local aPedCross:={}
LOCAL lOK:=.F.
local cUf:=''
Local nTotValor:=0
Local nTTotPes:=0

cQry:="SELECT C5_NUM,A1_NOME,C6_PRODUTO,C6_CROSSDO,C6_QTDRESE,* "
cQry+="FROM SC5020 SC5,SC6020 SC6,SA1010 SA1,SC9020 SC9  "
cQry+="WHERE C5_NUM=C6_NUM  "
cQry+="AND C5_CLIENTE+C5_LOJACLI=A1_COD+A1_LOJA  " 

cQry+= "AND C5_NUM=C9_PEDIDO "
cQry+= "AND C6_PRODUTO=C9_PRODUTO  "
//cQry+= "AND SC9.C9_BLCRED IN ( '  ' )  "
// NOVA LIBERACAO DE CRETIDO
cQry+= "AND SC9.C9_BLCRED IN ( '  ','04' )  "
cQry+= "AND SC9.C9_BLEST <> '10' "
cQry+= "AND C6_QTDENT < C6_QTDVEN  "
cQry+= "AND C6_BLQ <> 'R'  "

cQry+="AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
IF !EMPTY(MV_PAR03)
   cQry+="AND A1_EST='"+MV_PAR03+"' "
ELSE
   IF !EMPTY(MV_PAR04)
	   IF MV_PAR04 $ 'NO' //Norte
		  cQry+="AND A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') "
	   ELSEIF MV_PAR04 $ 'NE' //Nordeste
		  cQry+="AND A1_EST IN('MA','PI','CE','RN','PB','PE','AL','BA','SE') "
	   ELSEIF MV_PAR04 $ 'CO' //Centro-Oeste
		  cQry+="AND A1_EST IN('GO','MT','MS','DF') "
	   ELSEIF MV_PAR04 $ 'SL' //Sul 
		  cQry+="AND A1_EST IN('MG','ES','RJ','SP') "
	   ELSEIF MV_PAR04 $ 'SE' // Sudeste
		  cQry+="AND A1_EST IN('RS','PR','SC') "
	   ENDIF
   ENDIF
ENDIF
//
cQry+="AND C5_FILIAL='"+xFilial('SC5')+"' "
cQry+="AND C6_FILIAL='"+xFilial('SC6')+"' "
cQry+="AND C9_FILIAL='"+xFilial('SC9')+"' "
cQry+="AND A1_FILIAL='"+xFilial('SA1')+"' "
//
cQry+="AND SC5.D_E_L_E_T_!='*' "
cQry+="AND SC6.D_E_L_E_T_!='*' "
cQry+="AND SC9.D_E_L_E_T_!='*' "
cQry+="AND SA1.D_E_L_E_T_!='*' "

TCQUERY cQry NEW ALIAS "TMPX"

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
dbSelectArea("SB1")
dbSetOrder(1)

TMPX->(dbGoTop())
While TMPX->(!EOF())

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

   cNum:=TMPX->C5_NUM
   aPedCross:={}
   lOK:=.F.
   nValor:=0
   nTotPes:=0
   cUf:=TMPX->A1_EST
   Do While TMPX->(!EOF()) .AND. TMPX->C5_NUM==cNum
	  if TMPX->C6_CROSSDO='S'
	     lOK:=.T.
	  ENDIF	  
	  //Aadd( aPedCross, { cNum,TMPX->A1_NOME,TMPX->A1_LOJA,TMPX->C6_PRODUTO,posicione("SB1",1,xFilial('SB1') + TMPX->C6_PRODUTO,"B1_DESC"),TRANSFORM(TMPX->C6_QTDVEN,'@E 999,999.999'),TRANSFORM(TMPX->C6_PRCVEN,'@E 999,999.999'),TRANSFORM(TMPX->C6_VALOR,'@E 999,999.999'),TMPX->C6_CROSSDO } )
	   SB1->(DBSeek(xFilial("SB1")+TMPX->C6_PRODUTO))
	  Aadd( aPedCross, { cNum,TMPX->A1_NOME,TMPX->A1_LOJA,TMPX->C6_PRODUTO,SB1->B1_DESC,TRANSFORM(TMPX->C6_QTDVEN,'@E 999,999.999'),TRANSFORM(TMPX->C6_PRCVEN,'@E 999,999.999'),TRANSFORM(TMPX->C6_VALOR,'@E 999,999.999'),TMPX->C6_CROSSDO,TRANSFORM(TMPX->C6_QTDVEN*SB1->B1_PESOR,'@E 999,999.999')} )
	  nValor+=TMPX->C6_VALOR
	  nTotPes+=TMPX->C6_QTDVEN*SB1->B1_PESOR
	  incregua()
	  TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
      
   If lOK
      @nLin++,00 PSAY  "Pedido: "+aPedCross[1][1]+" Cliente: "+aPedCross[1][2]+" Loja: "+aPedCross[1][3]+" Volume: "+TRANSFORM(volume(aPedCross[1][1])[1][2],'@E 999,999.999')  
      @nLin++,00 PSAY  "UF: "+posicione("SX5",1,xFilial('SX5') +'12'+cUf,"X5_DESCRI")
      CabecItens(@nLin)
      For _X:=1 to len(aPedCross)
         
         If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 8
         Endif

         @nLin,00    PSAY aPedCross[_X][4] 
	     @nLin,17    PSAY aPedCross[_X][5] 
	     @nLin,77    PSAY iif(aPedCross[_X][9]='S',"Sim","Nao") 
	     @nLin,90    PSAY aPedCross[_X][6]
	     @nLin,103   PSAY aPedCross[_X][7]
	     @nLin,116   PSAY aPedCross[_X][8]
         @nLin++,131   PSAY aPedCross[_X][10]
      Next 
       
       If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 8
       Endif
       
       @nLin,89 PSAY "Total Pedido( "+aPedCross[1][1]+" ):"+TRANSFORM(nValor,'@E 999,999,999.999')
       @nLin,127 PSAY TRANSFORM(nTotPes,'@E 999,999,999.999')
       @nLin++,00 PSAY  replicate("_",142)
       nTotValor+=nValor
       nTTotPes+=nTotPes
   Endif
EndDo 

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif

@nLin++,00 PSAY "Geral " 
@nLin++,00 PSAY "Total: "+TRANSFORM(nTotValor,'@E 999,999,999.999')
@nLin,00 PSAY   "Peso: "+TRANSFORM(nTTotPes,'@E 999,999,999.999')

TMPX->(DBCLOSEAREA())

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

Static Function CabecItens(nLin)

***************

@nLin,00      PSAY  "Codigo"
@nLin,17      PSAY  "Descricao"
@nLin,77      PSAY  "Cross Docking"
@nLin,92      PSAY  "Quantidade "
@nLin,105     PSAY  "Preco "
@nLin,118     PSAY  "Total "
@nLin++,133   PSAY  "Peso "
//@nLin++,00 PSAY  replicate("_",142)
	  
Return 


***************

Static Function Volume(cPedido)

***************
Local aEspVol   := {}			

dbSelectArea("SD2")
dbSetOrder(8)
SD2->(dbSeek(xFilial("SD2")+cPedido))


dbSelectArea("SF2")
dbSetOrder(1)
If SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))

	cScan := "1"
	While ( !Empty(cScan) )
		cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
		If !Empty(cEspecie)
			nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
			If ( nScan==0 )
				aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
			Else
				aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
			EndIf
		EndIf
		cScan := Soma1(cScan,1)
		If ( FieldPos("F2_ESPECI"+cScan) == 0 )
			cScan := ""
		EndIf
	EndDo
Else
    aadd(aEspVol,{ " ", 0 , 0 , 0})
EndIF

Return aEspVol

