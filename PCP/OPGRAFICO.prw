#include "protheus.ch"
#include "topconn.ch"

*************

User Function OPGRAFICO()

*************
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Declaracao de variaveis utilizadas no pro§grama atraves da funcao   ³
³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
³ identificando as variaveis publicas do sistema utilizadas no codigo ³
³ Incluido pelo assistente de conversao do AP5 IDE                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NREG,NPVAROP")
SetPrvt("CCODETIQ,CPRODUTO,NOP,AMAT,NQUANT,CMAT")
SetPrvt("NCONT,NDENSIDA,LFLAG,CNUMPI,DEMISPI,CMAQPI")
SetPrvt("NQTDPI,CPRODPI,CCEMEPI,NBOBLGPI,NLFILPI,NESPPI")
SetPrvt("CSANLAMPI,CTRATAMPI,CSLITEXPI,NPTNEVEPI,CMATRIZPI,NLIN")
SetPrvt("NNUMETQ,I,CGILETE,NCTRL, cImpressao,")

cALIASANT := Alias()


Private oFont01, oFont02, oFont03, oFont04, oFont05, oFont06, oFont07, oPrint
cPRODUTO := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Objeto que controla o tipo de Fonte        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oFont01 	:= TFont():New('Courier New',22,22,.F.,.T.,5,.T.,5,.F.,.F.)
oFont02 	:= TFont():New('Courier New',20,20,.F.,.F.,5,.T.,5,.F.,.F.)
oFont03 	:= TFont():New('Courier New',18,18,.F.,.T.,5,.T.,5,.F.,.F.)
oFont04 	:= TFont():New('Courier New',18,18,.F.,.F.,5,.T.,5,.F.,.F.)
oFont05 	:= TFont():New('Courier New',14,14,.F.,.T.,5,.T.,5,.F.,.F.)
oFont06 	:= TFont():New('Courier New',16,16,.F.,.F.,5,.T.,5,.F.,.F.)
oFont07 	:= TFont():New('Courier New',16,16,.F.,.T.,5,.T.,5,.F.,.F.)
oFont08 	:= TFont():New('Courier New',14,14,.F.,.F.,5,.T.,5,.F.,.F.)

If Pergunte("OPGRAFICO",.T.)
   MsAguarde( { || runReport() }, "Aguarde. . .", "Ordem de Producao Saco . . ." )
endif

return



***************

Static Function runReport()

***************
local cQuery := ""

cQuery := "SELECT SC2.R_E_C_N_O_ SC2RECNO,C2_USAAGLI,C2_OPVIP, C2_NUM, C2_SEQUEN, C2_SEQPAI, C2_PRODUTO, C2_EMISSAO " + CHR(13) + CHR(10)
cQuery += " , C2_UM, C2_QUANT, C2_QTSEGUM, C2_OBS, C2_OPLIC, " + CHR(13) + CHR(10)
cQuery += "B5_MAQ, B5_LARG,B5_LARG2 , B5_ESPESS, B5_DESCOM, B5_COMPR,B5_COMPR2 , B5_SANLAM, B5_SOLDFL, B5_SANFFL, B5_QE1, B5_SLIT, " + CHR(13) + CHR(10)
cQuery += "B5_QE2, B5_CSOLDA, B5_BATPM, B5_COSTUR, B5_CEME, B5_CILIN, B5_ALTFAC, B5_CILENT, B5_POSPESO, B5_CILS1, " + CHR(13) + CHR(10)
cQuery += "B5_CILS2, B5_REGCORR, B5_IMPRESO, B5_VELOCID, B5_CILINDR, B5_QTDCOR, B5_LARGFIL, B5_BOBLARG, B5_TRATAM, " + CHR(13) + CHR(10)
cQuery += "B5_SLITEXT, B5_SANLAM2, B5_PTONEVE, B5_MATRIZ, B5_PTONEV2, B5_DENSIDA, B5_EXT1, B5_EXT2, B5_EXT3, B5_EXT4, B5_EXT5, B5_TIPO, " + CHR(13) + CHR(10)
cQuery += "B5_MATRIZ2, " + CHR(13) + CHR(10)
cQuery += "B1_DESC, SUBSTRING(B1_TITORIG,1,13) AS B1_TITORIG, B1_PESO " + CHR(13) + CHR(10)
cQuery += "FROM "+RetSqlName("SC2")+" SC2, "+RetSqlName("SB5")+" SB5, "+RetSqlName("SB1")+" SB1 " + CHR(13) + CHR(10)
cQuery += "WHERE C2_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "  + CHR(13) + CHR(10)
cQuery += "( C2_SEQPAI = '   ' OR ( C2_SEQPAI IN ('001','004') AND SUBSTRING(C2_PRODUTO,1,2) = 'PI') ) " + CHR(13) + CHR(10)
cQuery += "AND B5_COD = C2_PRODUTO AND B1_COD = B5_COD " + CHR(13) + CHR(10)
cQuery += "AND SC2.D_E_L_E_T_ = '' AND SB5.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' " + CHR(13) + CHR(10)
cQuery += "ORDER BY C2_NUM, C2_SEQPAI "
MemoWrite("C:\TEMP\PCPOP.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "SC2X"
TCSetField( 'SC2X', "C2_EMISSAO", "D")

dbselectarea( 'Z03' )
Z03->( dbsetorder( 5 ) )
nPVarOP  := GetMv("MV_PVAROP")
cCodEtiq := ""

oPrt := TMSPrinter():new("Ordem de Producao de Saco") 
oPrt:SetLandscape() 

If Subs( SC2X->C2_PRODUTO, 4, 1 ) == "R"
	PRN_ROL()
Else
	PRN()
EndIf


return 


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão das OPs - Produto Em Rolo.               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
**************************
Static Function PRN_ROL()
**************************
Local lCost
Local lImpr
Local cOP
Local cMainPrd, cSeqPai
cPRODUTO := ""
While ! SC2X->( Eof() )
	lImpr := SC2X->B5_IMPRESO == "S"
	cOP   := SC2X->C2_NUM
	While ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP
		if Empty(SC2X->C2_SEQPAI)
			//cMainPrd := SC2X->C2_PRODUTO
			cMainPrd := Left(SC2X->C2_PRODUTO,8)
			cPRODUTO := cMainPrd
			nNUM := Round( SC2X->C2_QTSEGUM / 100,0 )			
			/*
			for _V:=1 to  nNUM
			   ViaCCR(' / B O B I N A ')	 // substitui a funcao das etiquetas 		
			next
			*/
			ViaCCR('')
		endif
		cSeqPai := "001"
		
		while !SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI # cSeqPai
			SC2X->(DbSkip())
		end
		
		if lImpr
			if ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI = cSeqPai
				cImpressao := SC2X->B1_DESC							
				ViaImpr() //Imprimi Via Impressao
			endif
		EndIf
		
		if !SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI = cSeqPai
			ViaExtr() //Imprimi Via Extrusao			
			SC2X->(DbSkip())
		endif
	EndDo
EndDo

SC2X->(DbCloseArea())
oPrt:EndPage()
oPrt:Preview()

return


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão das OPs - Padrao.                        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

**********************
Static Function PRN()
**********************
Local lCost
Local lImpr
Local cOP
Local cMainPrd, cSeqPai
Local nNUM:=1

while ! SC2X->( Eof() )
	lCost := SC2X->B5_COSTUR  == "S"
	lImpr := SC2X->B5_IMPRESO == "S"
	cOP   := SC2X->C2_NUM
	cSeqPai := SC2X->C2_SEQPAI
	while ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP
		if Empty(SC2X->C2_SEQPAI)
			cMainPrd := Left(SC2X->C2_PRODUTO,8)
			cPRODUTO := cMainPrd
			nNUM := Round( SC2X->C2_QTSEGUM / 100,0 )			
			ViaCC(0,'')
			
			//if !SC2X->( Eof() ) .AND. SC2X->C2_NUM == cOP .and. Alltrim(SC2X->C2_SEQPAI) = Alltrim(cSeqPai)
				ViaExtr() //Imprimi Via Extrusao
				//SC2X->(DbSkip())
			//endif
			
			if lImpr  //imprime via impressão
				if ! SC2X->( Eof() ) .AND. SC2X->C2_NUM == cOP .and. Alltrim(SC2X->C2_SEQPAI) = Alltrim(cSeqPai)
					cImpressao := SC2X->B1_DESC			
					ViaImpr() //Imprime Via Impressao
				endif
			endIf
			
			
			
			if lCost
				SC2X->(DbSkip())//Pula para a sequencia "001"
				if SC2X->C2_SEQPAI = "001"
					//Imprimi Via Costura				
					ViaCC(1,'')	
				endif
			endif
			
		endif
//		if Left(cMainPrd,3) = "CTG"
//			cSeqPai := "004"
//		else
			//cSeqPai := "001"   //FR - 17/04/14 -> ESTAVA CHUMBADO E AÍ, NÃO IMPRIMIA A VIA EXTRUSÃO E VIA IMPRESSÃO
//		endif
		
		while !SC2X->( Eof() ) .AND. SC2X->C2_NUM == cOP .and. Alltrim(SC2X->C2_SEQPAI) != Alltrim(cSeqPai)
			SC2X->(DbSkip())
		end
		//comentado por FR - 17/04/14
		/*
		if lImpr
			if ! SC2X->( Eof() ) .AND. SC2X->C2_NUM == cOP .and. Alltrim(SC2X->C2_SEQPAI) = Alltrim(cSeqPai)
				cImpressao := SC2X->B1_DESC			
				ViaImpr() //Imprimi Via Impressao
			endif
		endIf
		
		if !SC2X->( Eof() ) .AND. SC2X->C2_NUM == cOP .and. Alltrim(SC2X->C2_SEQPAI) = Alltrim(cSeqPai)
			ViaExtr() //Imprimi Via Extrusao
			SC2X->(DbSkip())
		endif
		*/
	enddo
enddo

SC2X->(DbCloseArea())
oPrt:EndPage()
oPrt:Preview()

Return


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão da Via de Corte ou Costura               ³
³ nTipo = 0 Corte
³ nTipo = 1 Costura
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
****************************
static function ViaCC(nTipo,cBobina)
****************************
local cQuant:=" "
Local nLin:=nLin2:=100
Local aAcess := {}
cCodEtiq := Alltrim( SC2X->C2_PRODUTO )+"-"

oPrt:EndPage()
oPrt:StartPage() 

oPrt:Box(15,15 ,2450, 3500, )
oPrt:Say(nLin,100,"RAVA Embalagens Industria e Comercio Ltda.                           ",oFont03, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"ORDEM DE PRODUCAO",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Numero.: "+SC2X->C2_NUM,oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,iif(nTipo=0,"V I A   P A R A   C O R T E","V I A   P A R A   C O S T U R A")+cBobina,oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Data...:"+dtoc(SC2X->C2_EMISSAO),oFont06, 300, , , 0 )
Z03->( DbSeek( xFILIAL("Z03") + SC2X->C2_NUM ) )
nLin+=80
if SC2X->C2_OPLIC = "S"
    oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO AMOSTRA DE LICITACAO ***",oFont06, 300, , , 0 )
elseif SC2X->C2_USAAGLI = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO 100 % AGLUTINADO     ***",oFont06, 300, , , 0 )
elseIF SC2X->C2_OPVIP = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO PRIORIDADE CARTEIRA ***",oFont06, 300, , , 0 )
ENDIF
oPrt:Say(nLin,2500,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont06, 300, , , 0 )
nLin+=80
If SC2X->C2_UM == "MR"
	cQuant:=transform( Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3 ),"@E 9999999.999" ) + "  MR"
ElseIf SC2->C2_UM == "FD"
	cQuant:=transform(Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3), "@E 99999.999" )  + "  FD"
Endif
oPrt:Say(nLin,100,"Produto: "+Left( SC2X->C2_PRODUTO, 8 )+space(5)+"Quilos: "+transform( Round(SC2X->C2_QTSEGUM*100/(100+nPVarOp),0),"@E 99999.99" )+space(5)+"Qtd: "+cQuant,oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Descricao: "+Left( SC2X->B1_DESC, 50 ),oFont07, 300, , , 0 )
nLin+=100
oPrt:Say(nLin,100,"Largura p/ Corte: "+ transform(Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARG),"@E 999")   +" Espessura: "+transform(SC2X->B5_ESPESS,"@E 9.9999")+" Comprimento para corte:"+transform(SC2X->B5_COMPR,"@E 9999999.99")+" Sanf./Lamin. : "+Iif (SC2X->B5_SANLAM == 'L','Lamin.','Sanf.'),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Solda Fundo/Lateral: "+SC2X->B5_SOLDFL+" Quantid. bobinas: "+TRANSFORM(SC2X->C2_QTSEGUM / 100,"@E 999")+" Sanf. Fundo/Lateral: "+SC2X->B5_SANFFL+" Quant. p/ pacote: "+TRANSFORM(SC2X->B5_QE1,"@E 9999"),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Slit: "+IIf(SC2X->B5_SLIT=='S','SIM','NAO')+" Peso p/milheiro: "+transform(SC2X->B1_PESO / SC2X->B5_QE2 * 1000 ,"@E 9,999.999")+" Temperatura Solda: "+transform(SC2X->B5_CSOLDA,"@E 999.99")+" Batidas/Min: "+transform(SC2X->B5_BATPM,"9999"),oFont06, 300, , , 0 )
nLin+=100
if nTipo==0
	oPrt:Say(nLin,100,"Acessórios:",oFont03, 300, , , 0 )
	aAcess := acessory(SC2X->C2_PRODUTO)
	For X:=1 to Len(aAcess) 
	    nLin+=80
	    oPrt:Say(nLin,100,alltrim(aAcess[X][2])+'-'+alltrim(aAcess[X][1])+iif(X+1<=Len(aAcess), ' | '+alltrim(aAcess[X+1][2])+'-'+alltrim(aAcess[X+1][1])," ")+iif(X+2<=Len(aAcess), ' | '+alltrim(aAcess[X+2][2])+'-'+alltrim(aAcess[X+2][1])," "),oFont08, 300, , , 0 )
	    X:=X+3
	    if X=Len(aAcess)
	       nLin+=80
	       oPrt:Say(nLin,100,alltrim(aAcess[X][2])+'-'+alltrim(aAcess[X][1]),oFont08, 300, , , 0 )
	    Endif
	Next X
    nLin+=80
endif
nLin2:=nLin+80
nColFinal:=437
nColIni:=0
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"No.Bobinas ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Data ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Inicio ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Termino ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Prod./Acum. ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Apara ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Maq. ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Oper. ",oFont07, 300, , , 0 )

for W:=1 TO 10// linhas do grid
	nLin+=80
	nLin2:=nLin+80
	nColFinal:=437
	nColIni:=0
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
Next
nLin+=80
oPrt:Say(nLin,100,"Observacoes: ",oFont06, 300, , , 0 )
nLin+=160
if empty(SC2X->C2_OBS)
   oPrt:Box(nLin,15 ,0, 3500, )
else
   oPrt:Say(nLin,100,SC2X->C2_OBS,oFont06, 300, , , 0 )
endif   
nLin+=80
oPrt:Box(nLin,15 ,0, 3500, )
nLin+=80
oPrt:Box(nLin,15 ,0, 3500, )

return

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão da Via de Impressao                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
*************************
static function ViaImpr()
*************************
local nLin:=nLin2:=100

oPrt:EndPage()
oPrt:StartPage() 

oPrt:Box(15,15 ,2450, 3500, )
oPrt:Say(nLin,100,"RAVA Embalagens Industria e Comercio Ltda.                           ",oFont03, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"ORDEM DE PRODUCAO",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Numero.: "+SC2X->C2_NUM,oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"V I A   P A R A   I M P R E S S A O ",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Data...:"+dtoc(SC2X->C2_EMISSAO),oFont06, 300, , , 0 )
Z03->( DbSeek( xFILIAL("Z03") + SC2X->C2_NUM ) )
nLin+=80
if SC2X->C2_OPLIC = "S"
    oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO AMOSTRA DE LICITACAO ***",oFont06, 300, , , 0 )
elseif SC2X->C2_USAAGLI = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO 100 % AGLUTINADO     ***",oFont06, 300, , , 0 )
elseIF SC2X->C2_OPVIP = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO PRIORIDADE CARTEIRA ***",oFont06, 300, , , 0 )
ENDIF
oPrt:Say(nLin,2500,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont06, 300, , , 0 )
nLin+=80
cXXX := SC2X->C2_NUM
if SC2X->C2_SEQUEN = '001' //P.A.
	SC2X->( dbSkip() )
	if SC2X->C2_NUM != cXXX
		SC2X->( dbSkip(-1) )
	endIf
endIf
oPrt:Say(nLin,100,"Produto: "+Left( SC2X->C2_PRODUTO, 8 ) + " / " + cPRODUTO,oFont07, 300, , , 0 )
oPrt:Say(nLin,2500,"Quilos: "+transform(Round(SC2X->C2_QUANT*100/(100+nPVarOp),0),"@E 99999.99") ,oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Descricao: "+Posicione("SB1",1,xFilial("SB1") + cPRODUTO, "B1_DESC"),oFont07, 300, , , 0 )
nLin+=100
oPrt:Say(nLin,100,"VELOCIDADE(M/MIN): "+transform(SC2X->B5_VELOCID,"@E 999")+" CILINDRO: "+transform(SC2X->B5_CILINDR,"@E 999")+" QTD. COR: "+transform(SC2X->B5_QTDCOR,"@E 9"),oFont06, 300, , , 0 )
nLin+=80
nLin2:=nLin+80
nColFinal:=500
nColIni:=0
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"No.Bobinas ",oFont07, 300, , , 0 )
nColFinal+=500
nColIni+=500
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Data ",oFont07, 300, , , 0 )
nColFinal+=500
nColIni+=500
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Inicio ",oFont07, 300, , , 0 )
nColFinal+=500
nColIni+=500
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Termino ",oFont07, 300, , , 0 )
nColFinal+=500
nColIni+=500
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Bobina Km ",oFont07, 300, , , 0 )
nColFinal+=500
nColIni+=500
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Bobina Kg ",oFont07, 300, , , 0 )
nColFinal+=500
nColIni+=500
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Operador ",oFont07, 300, , , 0 )
for W:=1 TO 17// linhas do grid
	nLin+=80
	nLin2:=nLin+80
	nColFinal:=500
	nColIni:=0
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=500
	nColIni+=500
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=500
	nColIni+=500
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=500
	nColIni+=500
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=500
	nColIni+=500
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=500
	nColIni+=500
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=500
	nColIni+=500
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=500
	nColIni+=500
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
Next
nLin+=80
nLin2:=nLin+160
oPrt:Box(nLin,15 ,nLin2, 3500, )
oPrt:Say(nLin,25,"Observacoes: ",oFont06, 300, , , 0 )
nLin:=nLin2
nLin2:=2450 
oPrt:Box(nLin,15 ,nLin2, 3500, )
nLin+=100
oPrt:Say(nLin,100,"Apara KG: _______________    Apara KG: _______________    Apara KG: _______________    " ,oFont06, 300, , , 0 )

return


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão da Via de Extrusao ou Impressao          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
************************
static function ViaExtr()
************************
local cQuery
local nLin:=nLin2:=100
local nQtdMax := 0

cQuery := "select  SB1.B1_COD, SB1.B1_DESC, SUBSTRING(B1_TITORIG,1,13) AS B1_TITORIG, SG1.G1_QUANT, SB1.B1_DENSMAT"
cQuery += "from    "+ RetSqlName("SB1") +" SB1, "+ RetSqlName("SG1") +" SG1 "
cQuery += "where   SG1.G1_COD = '"+ alltrim(Left( SC2X->C2_PRODUTO, 8 )) +"' "
cQuery += "and SG1.G1_COMP = SB1.B1_COD "
cQuery += "and SG1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "and SG1.G1_FILIAL = '" + xFilial( "SG1" ) + "' and SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' "
cQuery += "order by SB1.B1_DESC desc"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TMP->( DbGoTop() )
aProds := {}
lCond := .F.
while ! TMP->( EoF() )
	aadd(aProds, {TMP->B1_COD, TMP->B1_TITORIG, TMP->G1_QUANT, TMP->B1_DENSMAT }) //TMP->B1_DESC,
	TMP->( DbSkip() )
EndDo
TMP->( DbCloseArea() )

/*	nTot   : Soma das quantidades das MP's que compoem o produto final. (primeira coluna na formulacao)
nQtdMax: Calculo da densidade. Ultima informacao da terceira coluna.		*/
if len(aProds) == 5
	nTot := aProds[2][3]+aProds[1][3]+aProds[3][3]+aProds[4][3]+aProds[5][3] //100
	lCond := .T.
	nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
	((aProds[3][3]/nTot)/aProds[3][4]) + ((aProds[4][3]/nTot)/aProds[4][4]) + ((aProds[5][3]/nTot)/aProds[5][4]) )
elseif len(aProds) == 4
	nTot := aProds[2][3]+aProds[1][3]+aProds[3][3]+aProds[4][3] //100
	//lCond := .T.
	nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
	((aProds[3][3]/nTot)/aProds[3][4]) + ((aProds[4][3]/nTot)/aProds[4][4]) )
elseif len(aProds) == 3
	nTot := aProds[2][3]+aProds[1][3]+aProds[3][3] //100
	nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]) +;
	((aProds[3][3]/nTot)/aProds[3][4]) )
elseif len(aProds) == 2 //mínimo de produtos segundo Lindenberg
	nTot := aProds[2][3]+aProds[1][3]//100
	nQtdMax := 1 / ( ((aProds[1][3]/nTot)/aProds[1][4]) + ((aProds[2][3]/nTot)/aProds[2][4]))
elseif  len(aProds) == 1
	nTot := aProds[1][3]
	nQtdMax := 1 / ((aProds[1][3]/nTot)/aProds[1][4])
endif

oPrt:EndPage()
oPrt:StartPage() 
oPrt:Box(15,15 ,2450, 3500, )
oPrt:Say(nLin,100,"RAVA Embalagens Industria e Comercio Ltda.                           ",oFont03, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"ORDEM DE PRODUCAO",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Numero.: "+SC2X->C2_NUM,oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"V I A   D E   E X T R U S A O ",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Data...:"+dtoc(SC2X->C2_EMISSAO),oFont06, 300, , , 0 )
nLin+=80

Z03->( DbSeek( xFILIAL("Z03") + SC2X->C2_NUM ) )
cCodPI := SC2X->C2_PRODUTO //Neto 06/10/06
SB5->( DbSeek( xFilial( "SB5" ) + cPRODUTO ), .T. )//Neto 06/10/06

if SC2X->C2_OPLIC = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO AMOSTRA DE LICITACAO ***",oFont06, 300, , , 0 )
elseif SC2X->C2_USAAGLI = "S"
    oPrt:Say(nLin,100,	"***ATENCAO: ORDEM PRODUCAO 100 % AGLUTINADO     ***",oFont06, 300, , , 0 )
elseIF SC2X->C2_OPVIP = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO PRIORIDADE CARTEIRA ***",oFont06, 300, , , 0 )
elseIF SC2X->C2_OPVIP <> "S"
	 oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO PRIORIDADE MEDIA EST***",oFont06, 300, , , 0 )
ElseIF SC2X->B5_TIPO == '2' .AND. Substring(cPRODUTO, 1, 1 ) $ 'C'
    oPrt:Say(nLin,100,"ATENCAO: HOSPITALAR MEDIO 13% MASTER BRANCO",oFont06, 300, , , 0 )
ENDIF
oPrt:Say(nLin,2500,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Produto: "+Left( SC2X->C2_PRODUTO, 8 ) + " / " + cPRODUTO,oFont07, 300, , , 0 )
oPrt:Say(nLin,2500,"Qtd (Kg): "+transform(Round(SC2X->C2_QUANT*100/(100+nPVarOp),0),"@E 99999.99"),oFont07, 300, , , 0 )
nLin+=80

oPrt:Say(nLin,100,"Descricao: "+Left( SC2X->B1_DESC, 60) ,oFont07, 300, , , 0 )
nLin+=80
nLin2:=nLin+80
nColFinal:=1750
nColIni:=0
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Dados do Filme ",oFont07, 300, , , 0 )
nColFinal+=1750
nColIni+=1750
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Formulacao para 100Kg ",oFont07, 300, , , 0 )
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Largura Filme: "+transform(Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARGFIL),"@E 999.99"),oFont06, 300, , , 0 )
nColIni+=1750
oPrt:Say(nLin,nColIni+30,"Produto             Qtd   Qtd.%     Densid.",oFont07, 300, , , 0 )
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Largura Bobina: "+transform(SC2X->B5_BOBLARG,"@E 999.99"),oFont06, 300, , , 0 )
nColIni+=1750
if len(aProds) > 1
    oPrt:Say(nLin,nColIni+30,alltrim(aProds[2][2]),oFont06, 300, , , 0 )     
    oPrt:Say(nLin,nColIni+750,alltrim(transform(aProds[2][3],"@E 999,999.99") ),oFont06, 300, , , 0 )     
    oPrt:Say(nLin,nColIni+1280,alltrim(transform(aProds[2][4],"@E 999,999.999") ),oFont06, 300, , , 0 )     
endif
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Espessura: "+transform(SC2X->B5_ESPESS,"@E 9.9999"),oFont06, 300, , , 0 )
nColIni+=1750
if len(aProds) > 0
   oPrt:Say(nLin,nColIni+30,alltrim(aProds[1][2]),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+750,alltrim(transform(aProds[1][3],"@E 999,999.99") ),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+1280,alltrim(transform(aProds[1][4],"@E 999,999.999") ),oFont06, 300, , , 0 )     
endif 
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Tratamento: "+IIf( SC2X->B5_TRATAM = 'S', 'SIM', 'NAO' ),oFont06, 300, , , 0 )
nColIni+=1750
if len(aProds) > 2
   oPrt:Say(nLin,nColIni+30,alltrim(aProds[3][2]),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+750,alltrim(transform(aProds[3][3],"@E 999,999.99") ),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+1280,alltrim(transform(aProds[3][4],"@E 999,999.999") ),oFont06, 300, , , 0 )     
endif 
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Slit: "+IIf(SC2X->B5_SLITEXT=='S','SIM','NAO'),oFont06, 300, , , 0 )
nColIni+=1750
if len(aProds) > 3
   oPrt:Say(nLin,nColIni+30,alltrim(aProds[4][2]),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+750,alltrim(transform(aProds[4][3],"@E 999,999.99") ),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+1280,alltrim(transform(aProds[4][4],"@E 999,999.999") ),oFont06, 300, , , 0 )     
endif 
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Sanfonado: "+Iif (SC2X->B5_SANLAM2 == 'L', 'Lamin.','Sanf.'),oFont06, 300, , , 0 )
nColIni+=1750
if lCond
   oPrt:Say(nLin,nColIni+30,alltrim(aProds[5][2]),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+750,alltrim(transform(aProds[5][3],"@E 999,999.99") ),oFont06, 300, , , 0 )     
   oPrt:Say(nLin,nColIni+1280,alltrim(transform(aProds[5][4],"@E 999,999.999") ),oFont06, 300, , , 0 )     
   lCond:=.F.
endif 
nLin+=80
nColIni:=0
oPrt:Say(nLin,15,"Alt.Pesc/Mat: "+SC2X->B5_PTONEVE+' / '+alltrim(Left(SC2X->B5_MATRIZ,12)),oFont06, 300, , , 0 )
nColIni+=1750
oPrt:Say(nLin,nColIni+30,"TOTAIS: ",oFont07, 300, , , 0 )
oPrt:Say(nLin,nColIni+750,"100",oFont06, 300, , , 0 )     
oPrt:Say(nLin,nColIni+1280,alltrim(transform(nQtdMax,"@E 999,999.999")),oFont06, 300, , , 0 )     
nLin+=80
nColIni:=0
oPrt:Say(nLin,15,"Alt.Pesc/Mat: "+SC2X->B5_PTONEV2+' / '+alltrim(Left(SC2X->B5_MATRIZ2,12)),oFont06, 300, , , 0 )
nColIni+=1750
oPrt:Say(nLin,nColIni+30,"% Reciclado ______________________________________________________________________________",oFont06, 300, , , 0 )
nLin+=80
nColIni:=0
nDENSIDA := SC2X->B5_DENSIDA
oPrt:Say(nLin,15,"Peso p/ Metro: "+TRANSFORM(100/(100 / ( ( Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARGFIL) * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 )),"@E 999.999999"),oFont06, 300, , , 0 )
nColIni+=1750
oPrt:Say(nLin,nColIni+30,"Kg/h ______________________________________________________________________________",oFont06, 300, , , 0 )
nLin+=80
nLin2:=nLin+80
nColFinal:=3500
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,1550,"Producao(Kg/h)",oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,15,"Extr.1: "+alltrim(transform(SC2X->B5_EXT1,"@E 999"))+space(8)+" Extr.2: "+alltrim(transform(SC2X->B5_EXT2,"@E 999"))+space(8)+" Extr.3: "+alltrim(transform(SC2X->B5_EXT3,"@E 999"))+space(8)+" Extr.4: "+alltrim(transform(SC2X->B5_EXT4,"@E 999"))+space(8)+" Extr.5: "+alltrim(transform(SC2X->B5_EXT5,"@E 999")),oFont06, 300, , , 0 )
nLin+=80
nLin2:=nLin+80
nColFinal:=437
nColIni:=0
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Seq.Bobinas ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Ext ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Data ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Inicio ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Termino ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Qtd. Prog. ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Qtd. Real  ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Oper./Ext. ",oFont07, 300, , , 0 )

for W:=1 TO 10// linhas do grid
	nLin+=80
	nLin2:=nLin+80
	nColFinal:=437
	nColIni:=0
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
Next

return


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Função de Impressão da Via de Corte para Rolo                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
****************************
static function ViaCCR(cBobina)
****************************
local nLin:=nLin2:=100
local cQuant:=''
local acess:={}
local cComp:=''
cCodEtiq := Alltrim( SC2X->C2_PRODUTO )+"-"

oPrt:EndPage()
oPrt:StartPage() 

oPrt:Box(15,15 ,2450, 3500, )
oPrt:Say(nLin,100,"RAVA Embalagens Industria e Comercio Ltda.                           ",oFont03, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"ORDEM DE PRODUCAO",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Numero.: "+SC2X->C2_NUM,oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"V I A   P A R A   C O R T E"+cBobina,oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Data...:"+dtoc(SC2X->C2_EMISSAO),oFont06, 300, , , 0 )
Z03->( DbSeek( xFILIAL("Z03") + SC2X->C2_NUM ) )
nLin+=80
if SC2X->C2_OPLIC = "S"
    oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO AMOSTRA DE LICITACAO ***",oFont06, 300, , , 0 )
elseif SC2X->C2_USAAGLI = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO 100 % AGLUTINADO     ***",oFont06, 300, , , 0 )
elseIF SC2X->C2_OPVIP = "S"
	oPrt:Say(nLin,100,"***ATENCAO: ORDEM PRODUCAO PRIORIDADE CARTEIRA ***",oFont06, 300, , , 0 )
ENDIF
oPrt:Say(nLin,2500,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont06, 300, , , 0 )
nLin+=80
If SC2X->C2_UM == "MR"
	cQuant:=transform( Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3 ),"@E 9999999.999" ) + "  MR"
ElseIf SC2->C2_UM == "FD"
	cQuant:=transform(Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3), "@E 99999.999" )  + "  FD"
Endif
oPrt:Say(nLin,100,"Produto: "+Left( SC2X->C2_PRODUTO, 8 )+space(5)+"Peso: "+transform( Round(SC2X->C2_QTSEGUM*100/(100+nPVarOp),0),"@E 99999.99" )+space(5)+"Qtd: "+cQuant,oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Descricao: "+Left( SC2X->B5_CEME, 60 ),oFont07, 300, , , 0 )
cImpressao := SC2X->B5_CEME
nLin+=100
If SC2X->B5_DESCOM != 0
	cComp:=transform(iif(SC2X->C2_OPLIC = "S",SC2X->B5_COMPR2,SC2X->B5_COMPR) + SC2X->B5_DESCOM, "@E 9999999.99")
Else
	cComp:=transform(iif(SC2X->C2_OPLIC = "S",SC2X->B5_COMPR2,SC2X->B5_COMPR), "@E 9999999.99")
EndIf
oPrt:Say(nLin,100,"Largura: "+transform(Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARG),"@E 999")+" Comprimento: "+cComp+" Espessura: "+transform(SC2X->B5_ESPESS, "@E 99999.9999")+" Sanf./Lamin.: "+Iif (SC2X->B5_SANLAM == 'L','Lamin.','Sanf.'),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Cilindro: "+Transform(SC2X->B5_CILIN,"@E 9999.99")+" Qtd. de Bobinas: "+transform(SC2X->C2_QTSEGUM / 100 ,"999")+" Batidas/Min: "+transform(SC2X->B5_BATPM , "@E 9999")+" Qtd. p/ Pacote: "+Transform(SC2X->B5_QE1 , "99999"),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Slit:"+IIf(SC2X->B5_SLIT == 'S','SIM','NAO')+ " Altura da Faca : "+Transform( SC2X->B5_ALTFAC, '@E 999' ) + ' mm'+" Cilindro de Entrada: "+transform(SC2X->B5_CILENT,"@E 99")+" Posicao do Peso: "+IIf(SC2X->B5_POSPESO == 'E','ESQ','DIR') ,oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Cil. de Silicone 1: "+transform(SC2X->B5_CILS1, "@E 99")+" Cil. de Silicone 2: "+transform(SC2X->B5_CILS2, "@E 99")+" Temp. Solda:"+transform(SC2X->B5_CSOLDA, "@E 999.99")+" Registro de Corrente: "+transform(SC2X->B5_REGCORR, "@E 999"),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Acessórios:",oFont03, 300, , , 0 )
aAcess := acessory(SC2X->C2_PRODUTO)
For X:=1 to Len(aAcess)
	nLin+=80
	oPrt:Say(nLin,100,alltrim(aAcess[X][2])+'-'+alltrim(aAcess[X][1])+iif(X+1<=Len(aAcess), ' | '+alltrim(aAcess[X+1][2])+'-'+alltrim(aAcess[X+1][1])," ")+iif(X+2<=Len(aAcess), ' | '+alltrim(aAcess[X+2][2])+'-'+alltrim(aAcess[X+2][1])," "),oFont08, 300, , , 0 )
	X:=X+3   
	if X=Len(aAcess)
	   nLin+=80
	   oPrt:Say(nLin,100,alltrim(aAcess[X][2])+'-'+alltrim(aAcess[X][1]),oFont08, 300, , , 0 )
	Endif
Next X
nLin+=80
nLin2:=nLin+80
nColFinal:=437
nColIni:=0
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"No.Bobinas ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Data ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Inicio ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Hr.Termino ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Prod./Acum. ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Apara ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Maq. ",oFont07, 300, , , 0 )
nColFinal+=437
nColIni+=437
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Oper. ",oFont07, 300, , , 0 )

for W:=1 TO 10// linhas do grid
	nLin+=80
	nLin2:=nLin+80
	nColFinal:=437
	nColIni:=0
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
	nColFinal+=437
	nColIni+=437
	oPrt:Box(nLin,15 ,nLin2,nColFinal , )
Next
nLin+=80
oPrt:Say(nLin,100,"Observacoes: ",oFont06, 300, , , 0 )
nLin+=160
if empty(SC2X->C2_OBS)
   oPrt:Box(nLin,15 ,0, 3500, )
else
   oPrt:Say(nLin,100,SC2X->C2_OBS,oFont06, 300, , , 0 )
endif   
nLin+=80
oPrt:Box(nLin,15 ,0, 3500, )
nLin+=80
oPrt:Box(nLin,15 ,0, 3500, )


return


***************

Static Function acessory(cCod)

***************

Local cQuery := ""
Local aRet   := {}

cQuery := "select B1_DESC, G1_COMP "
cQuery += "from "+retSqlName("SG1")+" SG1 join "+retSqlName("SB1")+" SB1 on G1_COMP = B1_COD and SG1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "and SB1.B1_TIPO in ('ME','AC','IS') and SB1.B1_ATIVO = 'S' and SG1.G1_COD = '"+cCod+"' "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )

do while _TMPK->( !EoF() )
	aAdd(aRet, { substr( _TMPK->B1_DESC, 1,25 ), substr( _TMPK->G1_COMP, 1,8 ) } )
	_TMPK->( dbSkip() )
endDo
_TMPK->( dbCloseArea() )

Return aRet