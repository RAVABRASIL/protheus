#include "rwmake.ch"
#include "TopConn.ch"
#Include "AP5MAIL.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#define PAD_LEFT		0
#define PAD_RIGHT		1
#define PAD_CENTER	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GuiaConf   ºAutor  ³Gustavo Costa      º Data ³  05/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime um formulário para conferência das mercadorias     º±±
±±º          ³ contidas em um pedido de compra.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GuiaConf()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oGet1","oSBtn1","oSBtn2")
SetPrvt("CDESC1,CDESC2,CDESC3,_CSTRING,AORD,J")
SetPrvt("oFont1,oFont2,oFont3,oFont4,oFont5,oFont6,oFont7")
Private cNum       := Space(TamSx3('C7_NUM')[1])
Private nPag  	:= 1
Private nPagd 	:= 0
Private cPFornec, cEmailForn, cEmailNome, cFornece
Private lOk		:= .F.

aEmail:={}


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 126,254,250,472,"Guia de Conferência",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 002,003,058,103,"Pedido de Compra",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 012,008,{||"Número do Pedido"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,049,008)
oGet1      := TGet():New( 021,008,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC7","cNum",,)
oGet1:bSetGet := {|u| If(PCount()>0,cNum:=u,cNum)}
oGet1:bValid := {||!Empty(cNum)}

oSBtn1     := SButton():New( 040,036,1,,oGrp1,,"Ok", )
oSBtn1:bLClicked := {|| IIF(!Empty(cNum),lOk:= .T.,lOk:= .F.), oDlg1:End(), }

oSBtn2     := SButton():New( 040,072,2,,oGrp1,,"Cancela", )
oSBtn2:bLClicked := {|| lOk:= .F., oDlg1:End()}

oDlg1:Activate(,,,.T.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Chama a função que monta o relatório.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
If lOk
	RptStatus({|| Relato(cNum)})
Else
	Return
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Relato     ºAutor  ³Gustavo Costa      º Data ³  05/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o Relatório.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Relato(cNum)

Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aSavRec := {}
Local NumPed	:= cNum
Private lEnc    := .f.
Private cTitulo
Private oFont, cCode, oPrn
Private cCGCPict, cCepPict
Private lPrimPag :=.t.
Private cMsg, nLinha, nLinhaD, nLinhaO, cObs
//Private cPerg   :="MTR11G", cMsg, nLinha, nLinhaD, nLinhaO, cObs

lNao := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Define as fontes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont5 := TFont():New( "Arial",,08,,.t.,,,,,.f. )
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont7 := TFont():New( "Arial",,14,,.t.,,,,,.f. )
oFont8 := TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont11:= TFont():New( "Arial",,07,,.t.,,,,,.f. )
oFont12:= TFont():New( "Arial",,07,,.f.,,,,,.f. )
oFont72:= TFont():New( "Arial",,72,,.f.,,,,,.f. )

oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
oFont6c := TFont():New( "Courier New",,09,,.T.,,,,,.f. )
oFont11c:= TFont():New( "Courier New",,09,,.f.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,13,,.t.,,,,,.f. )
oFont8c := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
oFont10c:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )

nDescProd:= 0
nTotal   := 0
nTotMerc := 0
cCondBus := mv_par01
nOrder	 :=	1

dbSelectArea("SC7")
dbSetOrder(nOrder)
SetRegua(RecCount())
dbSeek(xFilial("SC7")+NumPed,.T.)
//dbSeek(xFilial("SC7")+cCondBus,.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria as variaveis para armazenar os valores do pedido        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := 1
nReem    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//MaFisEnd()
//MaFisIniPC(SC7->C7_NUM)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Chama a função de impressão do cabeçalho do guia.                       ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
ImpCabec()

nTotal   := 0
nTotMerc	:= 0
nDescProd:= 0
nReem    := SC7->C7_QTDREEM + 1
nSavRec  := SC7->(Recno())
NumPed   := SC7->C7_NUM
li       := 465
nTotDesc := 0
cFornece := SC7->(C7_FORNECE+C7_LOJA)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Varre a tabela de Pedido de Compra para montar o relatório.             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
While !Eof() .And. SC7->C7_FILIAL = xFilial("SC7") .And. SC7->C7_NUM == NumPed
	
	dbSelectArea("SC7")
	If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
		AADD(aSavRec,Recno())
	Endif
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se havera salto de formulario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 1550
		nOrdem++
		ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
		ImpCabec()
		li  := 465
	Endif
	
	li:=li+100
	
	oPrn:Say( li, 0050, StrZero(Val(SC7->C7_ITEM),2)  	,oFont7c,100 )
	oPrn:Say( li, 0170, UPPER(SC7->C7_PRODUTO)			,oFont7c,100 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa Descricao do Produto                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ImpProd()
	
	If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
		nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	Else
		nDescProd+=SC7->C7_VLDESC
	Endif
	
	dbSkip()
EndDo

dbGoto(nSavRec)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Imprime rodape do formulario e salta para a proxima folha.              ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
If li>1550
	nOrdem++
	ImpRodape()		
	ImpCabec()
	li  := 465
Endif

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Imprime os dados complementares do PC.                          ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
FinalPed()		

//MaFisEnd()

dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array

aSavRec := {}

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

If lEnc
	oPrn:Preview()
	MS_FLUSH()
EndIf

Return .T.

/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ImpCabec  ºAutor  ³ Gustavo Costa       º Data ³  05/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o Cabecalho do Formulário de conferencia.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCabec()

Local nOrden, cCGC
LOCAL cMoeda
Local cComprador:=""
LOcal cAlter	:=""
Local cStartPath:= GetSrvProfString("Startpath"," ")
Local cFileFaz := ""
//Default cAprova	:=""
//Default cCompr	:=""

cMoeda := "1"

If !lPrimPag
	oPrn:EndPage()
	oPrn:StartPage()
	nPag += 1
Else
	lPrimPag := .f.
	lEnc     := .t.
	oPrn  := TMSPrinter():New()
	oPrn:Setup()
EndIF

oPrn:Say( 0020, 0020, " ",oFont,100 ) // startando a impressora

//Cabecalho (Enderecos da Empresa e Fornecedor)
oPrn:Box( 0050, 0010, 0420,0450)
oPrn:Box( 0050, 0450, 0175,2450)
//oPrn:Box( 0050, 2550, 0175,3000)
//oPrn:Box( 0050, 3000, 0175,3340)

oPrn:Box( 0175, 0450, 0420,1380)
oPrn:Box( 0175, 1380, 0420,2450)
//oPrn:Box( 0175, 2550, 0420,3340)

//Cabecalho Produto do Pedido
oPrn:Box( 0420, 0010, 0480,0120)
oPrn:Box( 0420, 0120, 0480,0450)//+40
oPrn:Box( 0420, 0450, 0480,1855)
//oPrn:Box( 0420, 1600, 0480,1855)
oPrn:Box( 0420, 1855, 0480,1950)
oPrn:Box( 0420, 1950, 0480,2450)
//oPrn:Box( 0420, 2200, 0480,2450)
//oPrn:Box( 0420, 2420, 0480,2635)
//oPrn:Box( 0420, 2635, 0480,2880)
//oPrn:Box( 0420, 2880, 0480,3100)
//oPrn:Box( 0420, 3100, 0480,3340)

//Espaco dos Itens do Pedido
oPrn:Box( 0480, 0010, 2000,0120)
oPrn:Box( 0480, 0120, 2000,0450)
oPrn:Box( 0480, 0450, 2000,1855)

//oPrn:Box( 0480, 1600, 1730,1855)
oPrn:Box( 0480, 1855, 2000,1950)
oPrn:Box( 0480, 1950, 2000,2450)
//oPrn:Box( 0480, 2200, 1730,2420)
//oPrn:Box( 0480, 2420, 1730,2635)
//oPrn:Box( 0480, 2635, 1730,2880)
//oPrn:Box( 0480, 2880, 1730,3100)
//oPrn:Box( 0480, 3100, 1730,3340)


//----------------------- imagens ------------------------------
cFileFaz := cStartPath + "LGRL" + SM0->M0_CODIGO + SM0->M0_CODFIL + ".bmp" //SM0->M0_CODIGO

oPrn:SayBitmap( 0120,0040, cFileFaz, 405, 200)

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)

//Titulo
oPrn:Say( 0080, 770, "GUIA DE CONFERÊNCIA - PEDIDO Nº - " + AllTrim(SC7->C7_NUM) + " - " + DTOC(SC7->C7_EMISSAO),oFont1,100 )

//Itens das Empresas

oPrn:Say( 0185, 0480, "EMPRESA",oFont3,100 )
oPrn:Say( 0185, 1400, "FORNECEDOR",oFont3,100 )

oPrn:Say( 0230, 0480, SM0->M0_NOMECOM ,oFont6,100 )
oPrn:Say( 0230, 1400, Alltrim(Substr(SA2->A2_NOME,1,28))+" - ("+SA2->A2_COD+")" ,oFont6,100 )

oPrn:Say( 0265, 0480, UPPER(SM0->M0_ENDENT) ,oFont6,100 )
oPrn:Say( 0265, 1400, UPPER(Substr(SA2->A2_END,1,30)+ Substr(SA2->A2_BAIRRO,1,10)) ,oFont6,100 )

oPrn:Say( 0300, 0480, UPPER("CEP: " + Transform(SM0->M0_CEPENT,cCepPict)),oFont6,100 )
oPrn:Say( 0300, 1060, UPPER(Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT) ,oFont6,100 )
oPrn:Say( 0300, 1400, Upper(Trim(SA2->A2_MUN)+"   "+SA2->A2_EST+" "+"CEP: "+ Transform(SA2->A2_CEP, cCepPict)) ,oFont6,100 )
oPrn:Say( 0300, 1970, "FAX: " + "("+Substr(SA2->A2_DDD,1,3)+") "+SA2->A2_FAX ,oFont6,100 )

oPrn:Say( 0335, 0480, "TEL: " + SM0->M0_TEL ,oFont6,100 )
oPrn:Say( 0335, 1060, "FAX: " + SM0->M0_FAX ,oFont6,100 )
oPrn:Say( 0335, 1400, "VENDEDOR: " + Upper(Substr(SC7->C7_CONTATO,1,10)),oFont6,100 )
oPrn:Say( 0335, 1970, "FONE: " + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) ,oFont6,100 )

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("A2_CGC")
cCGC := Alltrim(X3TITULO())
nOrden = IndexOrd()

oPrn:Say( 0370, 0480, (cCGC) + " "+ Transform(SM0->M0_CGC,cCgcPict) ,oFont6,100 )
oPrn:Say( 0370, 1060, "IE:" + InscrEst() ,oFont6,100 )

dbSelectArea("SA2")
dbSetOrder(nOrden)
oPrn:Say( 0370, 1400, "CNPJ: " + Alltrim(Transform(SA2->A2_CGC,cCgcPict)) ,oFont6,100 )
oPrn:Say( 0370, 1970, "IE: " + SA2->A2_INSCR ,oFont6,100 )

oPrn:Say( 0435, 0035, "Item"  ,oFont3,100 )
oPrn:Say( 0435, 0165, "Código" ,oFont3,100 )
oPrn:Say( 0435, 0470, "Descrição" ,oFont3,100 )
oPrn:Say( 0435, 1880, "UM" ,oFont3,100 )
oPrn:Say( 0435, 2095, "QUANTIDADE" ,oFont3,100 )


if lNao
	oPrn:Say( 0635, 0205, "BLOQUEADO"  ,oFont72,100 )
	oPrn:Line (100,100,2250,2250)         //X
	oPrn:Line (2250,100,100,2250)      //X
EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpProd  ºAutor  ³ Gustavo Costa       º Data ³  05/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisar e imprimir  dados Cadastrais do Produto.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpProd()

LOCAL cDesc, nLinRef := 1, nBegin := 0, cDescri := "", nLinha:=0,;
nTamDesc := 85, aColuna := Array(8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cDescri := Trim(Posicione("SB1",1,xFilial("SB1")+Substr(SC7->C7_PRODUTO,1,35),"Substr(SB1->B1_DESC,1,60)"))
cDescri := If(Empty(cDescri),Trim(Substr(SC7->C7_DESCRI,1,60)),cDescri)  	// opcao 3
cObs := Trim(SC7->C7_OBS)

dbSelectArea("SC7")
nLinhaD:= MLCount(cDescri,nTamDesc)
nLinhaO:= MLCount(cObs,30)
nLinha := If(nLinhaD>nLInhaO,nLinhaD,nLinhaO)
oPrn:Say( li, 0470, MemoLine(cDescri,nTamDesc,1) ,oFont7c,100 )
oPrn:Say( li+50, 0470, If(nLinhaO>0,"OBS.: " + MemoLine(cObs,30,1),""),oFont6,100 )

oPrn:Say( li, 1892, SC7->C7_UM ,oFont7c,100,,, PAD_CENTER )

oPrn:Line(li+70,1950,li+70,2450)

For nBegin := 2 To nLinha
	//	li+=35
	li+=50
	If nLinhaD>=nBegin
		oPrn:Say( li, 0470, MemoLine(cDescri,nTamDesc,nBegin) ,oFont4,100 )
	EndIf
	If nLinhaO>=nBegin
		oPrn:Say( li, 1380, MemoLine(cObs,30,nBegin),oFont6,100 )
	EndIf
Next nBegin

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpRodape ºAutor  ³ Gustavo Costa       º Data ³  05/22/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o rodape do formulario e salta para a proxima folhaº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRodape()

oPrn:Say( 1730, 0070, "CONTINUA ..." ,oFont3,100 )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FinalPed  ºAutor  ³ Gustavo Costa       º Data ³  05/22/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime os dados complementares do guia.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FinalPed()

Local nk 		:= 1,nG
Local nQuebra	:= 0
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprova	:=""
Local cCompr	:=""
Local aColuna   := Array(8), nTotLinhas
Local nTotIpi	:= 0 //MaFisRet(,'NF_VALIPI')
Local nTotIcms	:= 0 //MaFisRet(,'NF_VALICM')
Local nTotDesp	:= 0 //MaFisRet(,'NF_DESPESA')
Local nTotFrete	:= 0 //MaFisRet(,'NF_FRETE')
Local nTotalNF	:= 0 //MaFisRet(,'NF_TOTAL')
Local nTotSeguro:= 0 //MaFisRet(,'NF_SEGURO')
Local aValIVA   := 0 //MaFisRet(,"NF_VALIMP")

//Rodape

oPrn:Box( 2000, 0010, 2250,2450)
oPrn:Box( 2250, 0010, 2450,2450)

PswOrder(1)
If PswSeek(SC7->C7_USER,.T.)
	aSolic := PswRet()
	cCompr := aSolic[1,4]
Else
	cCompr:= "Nao Cadastrado"
EndIF

dbSelectArea("SC7")

If C7_CONAPRO != "B"
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial()+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+SC7->C7_NUM .And. SCR->CR_TIPO == "PC"
		IF SCR->CR_STATUS=="03"
			cAprova += AllTrim(UsrFullName(SCR->CR_USER))
		EndIF
		dbSelectArea("SCR")
		dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
Else
	cAprova := "Nao Aprovado"
	lNao := .T.
EndIF

dbSelectArea("SC7")

oPrn:Say( 2030, 0050, "Observações :",oFont7,100 )
nLiOBS := 2030
/*
oPrn:Say( 2280, 0050, "COMPRADOR : ",oFont5,100 )
oPrn:Say( 2280, 0300, UPPER(Alltrim(Substr(cCompr,1,25))),oFont6,100 )
oPrn:Say( 2330, 0050, "APROVADO POR : ",oFont5,100 )
oPrn:Say( 2330, 0300, UPPER(Alltrim(Substr(cAprova,1,25))),oFont6,100 )
oPrn:Say( 2280, 1880, "CONFERIDO POR : ",oFont5,100 )
oPrn:Box( 2250, 1820, 2450,2450)
*/

oPrn:Say( 2280, 0050, "COMPRADOR : ",oFont5,100 )
oPrn:Say( 2280, 0300, UPPER(Alltrim(Substr(cCompr,1,25))),oFont6,100 )
oPrn:Say( 2330, 0050, "APROVADO POR : ",oFont5,100 )
oPrn:Say( 2330, 0300, UPPER(Alltrim(Substr(cAprova,1,25))),oFont6,100 )
oPrn:Say( 2280, 1880, "CONFERIDO POR : ",oFont5,100 )
oPrn:Say( 2330, 1880, "DATA :____/____/______",oFont5,100 )
oPrn:Say( 2380, 1880, "NC : ",oFont5,100 )
oPrn:Say( 2280, 850, "SOLICITADO POR : ",oFont5,100 )
oPrn:Say( 2280, 1350, "ENTREGUE POR : ",oFont5,100 )
oPrn:Box( 2250, 800, 2450,2450)
oPrn:Box( 2250, 1300, 2450,2450)
oPrn:Box( 2250, 1820, 2450,2450)


Return .T.
