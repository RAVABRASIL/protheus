#include "protheus.ch"
#include "topconn.ch"

*************

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} PCPR033
Grava o peso dos produtos em processo (PP) e grava na tabela ZZ2.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     18/03/2014
/*/
//------------------------------------------------------------------------------------------

User Function OPGRAF2()

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
oFont10   	:= TFont():New( "Calibri",0,-18,,.T.,0,,700,.F.,.F.,,,,,, )
oFont11   	:= TFont():New( "Calibri",0,-14,,.T.,0,,700,.F.,.F.,,,,,, )
oFont12   	:= TFont():New( "Calibri",0,-10,,.T.,0,,700,.F.,.F.,,,,,, )
oFont20   	:= TFont():New( "Calibri",0,-22,,.T.,0,,700,.F.,.F.,,,,,, )


oPerg1('OPGRAF2')

//If Pergunte("OPGRAFICO",.T.)
If Pergunte("OPGRAF2",.T.)
   MsAguarde( { || runReport() }, "Aguarde. . .", "Ordem de Producao Saco . . ." )
endif

return



***************

Static Function runReport()

***************
local cQuery

cOps :=""
_cLote:=MV_PAR01

DbSelectArea("ZZC")
DbSetOrder(1)

IF ZZC->( DbSeek( XFILIAL('ZZC') + _cLote ) )

	while ZZC->(!Eof()) .AND. ZZC->ZZC_FILIAL=XFILIAL('ZZC') .AND.ZZC->ZZC_LOTE==_cLote
            
  			cOps += "'"+ZZC->ZZC_OP+"',"
		    ZZC->(dbSkip())
	enddo

ELSE

   alert('Esse Nao e um Lote Valido!!!')
   return

ENDIF	

ZZC->(DbCloseArea())

if empty(cOps)
   
   alert('o Lote informado nao tem OPs.')
   return

endif

cOps := Substr(cOps,1,Len(cOps)-1)
cQuery := "SELECT C2_EXTRUSO,SC2.R_E_C_N_O_ SC2RECNO,C2_USAAGLI,C2_OPVIP, C2_NUM, C2_ITEM, C2_SEQUEN, C2_SEQPAI, C2_PRODUTO, C2_EMISSAO, C2_UM, C2_QUANT, C2_QTSEGUM, C2_OBS, C2_OPLIC, "
cQuery += "B5_MAQ, B5_LARG,B5_LARG2 , B5_ESPESS, B5_DESCOM, B5_COMPR,B5_COMPR2 , B5_SANLAM, B5_SOLDFL, B5_SANFFL, B5_QE1, B5_SLIT, "
cQuery += "B5_QE2, B5_CSOLDA, B5_BATPM, B5_COSTUR, B5_CEME, B5_CILIN, B5_ALTFAC, B5_CILENT, B5_POSPESO, B5_CILS1, "
cQuery += "B5_CILS2, B5_REGCORR, B5_IMPRESO, B5_VELOCID, B5_CILINDR, B5_QTDCOR, B5_LARGFIL, B5_BOBLARG, B5_TRATAM, "
cQuery += "B5_SLITEXT, B5_SANLAM2, B5_PTONEVE, B5_MATRIZ, B5_PTONEV2, B5_DENSIDA, B5_EXT1, B5_EXT2, B5_EXT3, B5_EXT4, B5_EXT5, B5_TIPO, "
cQuery += "B5_MATRIZ2, B1_DESC, SUBSTRING(B1_TITORIG,1,13) AS B1_TITORIG, B1_PESO, B5_IMPRESS "
cQuery += "FROM " + RetSqlName("SC2") + " SC2 "
cQuery += "INNER JOIN " + RetSqlName("SB5") + " SB5 "
cQuery += "ON B5_COD = C2_PRODUTO "
cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 " 
cQuery += "ON B1_COD = B5_COD "

//cQuery += "WHERE C2_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 

cQuery += "WHERE C2_NUM IN ("+cOps+") " 

//cQuery += "( C2_SEQPAI = '   ' OR ( C2_SEQPAI IN ('001','004') AND SUBSTRING(C2_PRODUTO,1,2) = 'PI') ) "
cQuery += "AND SC2.D_E_L_E_T_ = '' AND SB5.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
cQuery += "ORDER BY C2_NUM, C2_SEQUEN "
MemoWrite("C:\TEMP\PCPOP.SQL", cQuery )

If Select('SC2X') > 0
	SC2X->(dbCloseArea())
EndIf


TCQUERY cQuery NEW ALIAS "SC2X"
TCSetField( 'SC2X', "C2_EMISSAO", "D")

dbselectarea( 'Z03' )
Z03->( dbsetorder( 5 ) )
nPVarOP  := GetMv("MV_PVAROP")
cCodEtiq := ""

oPrt := TMSPrinter():new("Ordem de Producao de Saco") 
oPrt:SetLandscape() 

If Subs( SC2X->C2_PRODUTO, 4, 1 ) == "R"
	//PRN_ROL()
      PRN()	
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

PRIVATE cExtruso:= " "


While ! SC2X->( Eof() )
	lImpr := SC2X->B5_IMPRESO == "S"
	cOP   := SC2X->C2_NUM
	cExtruso:= SC2X->C2_EXTRUSO
    
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
/*
		cSeqPai := "001"
		
		while !SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI # cSeqPai
			SC2X->(DbSkip())
		end
		
		if lImpr
			if ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->B5_IMPRESS = "S"
				cImpressao := SC2X->B1_DESC							
				ViaImpr() //Imprimi Via Impressao
			endif
		EndIf
		
		if !SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI = cSeqPai
			ViaExtr() //Imprimi Via Extrusao			
			SC2X->(DbSkip())
		endif
*/
// ANTONIO 
		
		If SC2X->C2_NUM = cOP .and. SubStr(SC2X->C2_PRODUTO,1,2) == "PI" .AND. SubStr(SC2X->C2_PRODUTO,1,3) <> "PII"
				ViaExtr() //Imprimi Via Extrusao
		Endif

		If lImpr .AND. SC2X->C2_NUM = cOP .and. SubStr(SC2X->C2_PRODUTO,1,2) == "PI"  .and. ALLTRIM(SC2X->C2_SEQPAI)=='001'
			//if ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI = cSeqPai
				cImpressao := SC2X->B1_DESC			
				ViaImpr() //Imprimi Via Impressao
			//endif
		EndIf

		SC2X->(DbSkip())
//			

		
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
Local lAnvi:=.T.
Local cOP
Local cMainPrd, cSeqPai
Local nNUM:=1

PRIVATE cExtruso:=''


SC2X->( dbGoTop() )
while ! SC2X->( Eof() )
	cOP     := SC2X->C2_NUM
	cExtruso:= SC2X->C2_EXTRUSO
   lAnvi:=.T.

	while ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP
		
		lCost := SC2X->B5_COSTUR  == "S"
		lImpr := SC2X->B5_IMPRESO == "S"

		if Empty(SC2X->C2_SEQPAI)
			cMainPrd := Left(SC2X->C2_PRODUTO,8)
			cPRODUTO := cMainPrd
			nNUM := Round( SC2X->C2_QTSEGUM / 100,0 )			
			ViaCC(0,'')
			
            if lAnvi .AND. MV_PAR02=1 // IMPRIMI VIA : SIM 
             //VIA ANGEVISA
              ViaAnvi(0)
              lAnvi:=.F.
		    endif
			
			if lCost
				SC2X->(DbSkip())//Pula para a sequencia "001"
				if SC2X->C2_SEQPAI = "001"
					//Imprimi Via Costura
					ViaCC(1,'')	
				endif
			endif
		endif
/* GUSTAVO 
		If lImpr .and. !Empty(SC2X->C2_SEQPAI)
			//if ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI = cSeqPai
				cImpressao := SC2X->B1_DESC			
				ViaImpr() //Imprimi Via Impressao
			//endif
		Else
		
			If SC2X->C2_NUM = cOP .and. SubStr(SC2X->C2_PRODUTO,1,2) == "PI"
				ViaExtr() //Imprimi Via Extrusao
			Endif
			
		EndIf
*/
// ANTONIO 
		
		If SC2X->C2_NUM = cOP .and. SubStr(SC2X->C2_PRODUTO,1,2) == "PI" .AND. SubStr(SC2X->C2_PRODUTO,1,3) <> "PII" 
				ViaExtr() //Imprimi Via Extrusao
		Endif

		If lImpr .AND. SC2X->C2_NUM = cOP .and. SubStr(SC2X->C2_PRODUTO,1,2) == "PI"  .and. ALLTRIM(SC2X->C2_SEQPAI)=='001'
			//if ! SC2X->( Eof() ) .AND. SC2X->C2_NUM = cOP .and. SC2X->C2_SEQPAI = cSeqPai
				cImpressao := SC2X->B1_DESC			
				ViaImpr() //Imprimi Via Impressao
			//endif
		EndIf

		SC2X->(DbSkip())
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
Local nCol:=80
Local aAcess := {}
cCodEtiq := Alltrim( SC2X->C2_PRODUTO )+"-"

oPrt:EndPage()
oPrt:StartPage() 

cCodOP	:= SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN

oPrt:Box(15, 15 ,2450, 3500, ) 		// Box geral
oPrt:Box(15, 15 ,350, 1750, ) 		// Box Cabec Esq
oPrt:Box(15, 1750, 350, 3500, ) 	// Box Cabec Dir
oPrt:Box(15, 15 ,600, 1750, ) 		// Box Prod Esq
oPrt:Box(15, 1750, 600, 3500, ) 	// Box Prod Dir
oPrt:Box(15, 15 ,1150, 1750, ) 		// Box Especificaçoes Esq
oPrt:Box(15, 1750, 1150, 3500, ) 	// Box Especificaçoes Dir
oPrt:Box(15, 15 ,2450, 1750, ) 		// Box Acessorios Esq
oPrt:Box(15, 1750, 2450, 3500, ) 	// Box Acessorios Dir

MSBAR("CODE128",0.5,11,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)
MSBAR("CODE128",0.5,26,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)


For j := 1 To 2


	oPrt:Say(nLin,nCol,"RAVA Embalagens ",oFont10, 300, , , 0 )
	
	nLin+=85
	
	oPrt:Say(nLin,nCol,"ORDEM DE PRODUCAO",oFont10, 300, , , 0 )
	oPrt:Say(nLin,nCol+1000,cCodOP+' - '+cExtruso,oFont10, 300, , , 0 )
//	oPrt:Say(nLin,nCol+1250,cCodOP,oFont10, 300, , , 0 )
	nLin+=70
	oPrt:Say(nLin,nCol,iif(nTipo=0,"V I A   P A R A   C O R T E","V I A   P A R A   C O S T U R A")+cBobina,oFont10, 300, , , 0 )
//	oPrt:Say(nLin,nCol+1000,"Data:"+dtoc(SC2X->C2_EMISSAO),oFont10, 300, , , 0 )
    
    oPrt:Say(nLin,nCol+700,"Data:"+dtoc(SC2X->C2_EMISSAO)+' Lote.:'+alltrim(MV_PAR01),oFont10, 300, , , 0 )
//	oPrt:Say(nLin,nCol+1200,"Data:"+dtoc(SC2X->C2_EMISSAO),oFont10, 300, , , 0 )
	
	Z03->( DbSeek( xFILIAL("Z03") + SC2X->C2_NUM ) )
	
	nLin+=80
	
	if SC2X->C2_OPLIC = "S"
	    oPrt:Say(nLin,nCol,"***ATENCAO: OP AMOSTRA DE LICITACAO ***",oFont10, 300, , , 0 )
	elseif SC2X->C2_USAAGLI = "S"
		oPrt:Say(nLin,nCol,"***ATENCAO: OP 100 % AGLUTINADO     ***",oFont10, 300, , , 0 )
	elseIF SC2X->C2_OPVIP = "S"
		oPrt:Say(nLin,nCol,"***ATENCAO: OP PRIORIDADE CARTEIRA ***",oFont10, 300, , , 0 )
	ENDIF
	
	//oPrt:Say(nLin,nCol+1100,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont10, 300, , , 0 )

	nLin+=80
	
	If SC2X->C2_UM == "MR"
		cQuant:=transform( Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3 ),"@E 9999999.999" ) + "  MR"
	ElseIf SC2->C2_UM == "FD"
		cQuant:=transform(Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3), "@E 99999.999" )  + "  FD"
	Endif
	
	oPrt:Say(nLin,nCol,"Produto: "+ AllTrim( SC2X->C2_PRODUTO) + "  -  " + Left( SC2X->B1_DESC, 50 ),oFont11, 300, , , 0 )
	nLin+=70
	oPrt:Say(nLin,nCol,"Quilos: " + Transform( Round(SC2X->C2_QTSEGUM * 100 / (100 + nPVarOp),0),"@E 99999.99" ) + space(6) + "Qtd: " + cQuant,oFont11, 300, , , 0 )
	nLin+=120
	
	oPrt:Say(nLin,nCol,"ESPECIFICAÇÕES DO PRODUTO",oFont10, 300, , , 0 )
	nLin+=100
	oPrt:Say(nLin,nCol,"Largura p/ Corte: "+ transform(Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARG),"@E 999"),oFont11, 300, , , 0 )   
	oPrt:Say(nLin,nCol+1000,"Sanf. Fundo/Lateral: "+SC2X->B5_SANFFL,oFont11, 300, , , 0 )
	nLin+=70
	oPrt:Say(nLin,nCol,"Espessura: "+transform(SC2X->B5_ESPESS,"@E 9.9999"),oFont11, 300, , , 0 )
	oPrt:Say(nLin,nCol+1000,"Quant. p/ pacote: "+TRANSFORM(SC2X->B5_QE1,"@E 9999"),oFont11, 300, , , 0 )
	nLin+=70
	oPrt:Say(nLin,nCol,"Comprimento para corte:"+transform(SC2X->B5_COMPR,"@E 9999999.99"),oFont11, 300, , , 0 )
	oPrt:Say(nLin,nCol+1000,"Slit: "+IIf(SC2X->B5_SLIT=='S','SIM','NAO'),oFont11, 300, , , 0 )
	nLin+=70
	oPrt:Say(nLin,nCol,"Sanf./Lamin. : "+Iif (SC2X->B5_SANLAM == 'L','Lamin.','Sanf.'),oFont11, 300, , , 0 )
	oPrt:Say(nLin,nCol+1000," Peso p/milheiro: "+transform(SC2X->B1_PESO / SC2X->B5_QE2 * 1000 ,"@E 9,999.999"),oFont11, 300, , , 0 )
	nLin+=70
	oPrt:Say(nLin,nCol,"Solda Fundo/Lateral: " + SC2X->B5_SOLDFL,oFont11, 300, , , 0 )
	oPrt:Say(nLin,nCol+1000," Temperatura Solda: "+transform(SC2X->B5_CSOLDA,"@E 999.99"),oFont11, 300, , , 0 )
	nLin+=70
	oPrt:Say(nLin,nCol,"Quantid. bobinas: "+TRANSFORM(SC2X->C2_QTSEGUM / 100,"@E 999"),oFont11, 300, , , 0 )
	oPrt:Say(nLin,nCol+1000," Batidas/Min: "+transform(SC2X->B5_BATPM,"9999"),oFont11, 300, , , 0 )
	nLin+=70
	nLin+=100
	if nTipo==0
		oPrt:Say(nLin,nCol,"Acessórios:",oFont10, 300, , , 0 )
		aAcess := acessory(SC2X->C2_PRODUTO)
		nLin+=30
		For X:=1 to Len(aAcess) 
		    nLin+=70
		    oPrt:Say(nLin,nCol,alltrim(aAcess[X][2]) + ' - ' + alltrim(aAcess[X][1]),oFont11, 300, , , 0 )
		    oPrt:Say(nLin,nCol+1200,aAcess[X][3],oFont11, 300, , , 0 )
		    oPrt:Say(nLin,nCol+1300,Transform(aAcess[X][4],"@E 99,999.99999"),oFont11, 300, , , 0 )
		Next X
	    nLin+=80
	endif
	

	nLin+=100
	oPrt:Say(nLin,nCol,"Observacoes: ",oFont10, 300, , , 0 )
	nLin+=150
	if empty(SC2X->C2_OBS)
	   oPrt:Box(nLin,15 ,0, 3500, )
	else
	   oPrt:Say(nLin,nCol,SubStr(SC2X->C2_OBS,1,80),oFont08, 300, , , 0 )
	   nLin+=050
	   oPrt:Say(nLin,nCol,SubStr(SC2X->C2_OBS,81,80),oFont08, 300, , , 0 )
	endif   
	
	If j = 1
		nLin := 100
		nCol := 1825
	EndIf
Next j

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

cCodOP	:= SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN
MSBAR("CODE128",0.5,11,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)
//MSBAR("CODE128",0.5,26,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)

oPrt:Box(15,15 ,2450, 3500, )
oPrt:Say(nLin,100,"RAVA Embalagens",oFont03, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"ORDEM DE PRODUCAO",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Numero.: "+SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN,oFont07, 300, , , 0 )
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
//oPrt:Say(nLin,2500,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Extrusora:"+cExtruso,oFont06, 300, , , 0 )
nLin+=80
/*
cXXX := SC2X->C2_NUM
if SC2X->C2_SEQUEN = '001' //P.A.
	SC2X->( dbSkip() )
	if SC2X->C2_NUM != cXXX
		SC2X->( dbSkip(-1) )
	endIf
endIf
*/
oPrt:Say(nLin,100,"Produto: "+Left( SC2X->C2_PRODUTO, 8 ) + " / " + cPRODUTO,oFont07, 300, , , 0 )
oPrt:Say(nLin,2500,"Quilos: "+transform(Round(SC2X->C2_QUANT*100/(100+nPVarOp),0),"@E 99999.99") ,oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Descricao: "+Posicione("SB1",1,xFilial("SB1") + cPRODUTO, "B1_DESC"),oFont07, 300, , , 0 )
oPrt:Say(nLin,2500,"Lote: "+MV_PAR01,oFont07, 300, , , 0 )
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
Local nTotalG1	:= 0

cQuery := "SELECT  SB1.B1_COD, SB1.B1_DESC, SUBSTRING(B1_TITORIG,1,13) AS B1_TITORIG, SD4.D4_QUANT, SG1.G1_QUANT, SB1.B1_DENSMAT "
cQuery += "FROM " + RetSqlName("SD4") +" SD4 "
cQuery += "INNER JOIN " + RetSqlName("SC2") +" SC2 "
cQuery += "ON C2_NUM = '" + SC2X->C2_NUM + "' "
cQuery += "AND C2_ITEM = '" + SC2X->C2_ITEM + "' "
cQuery += "AND C2_SEQUEN = '" + SC2X->C2_SEQUEN + "' "
cQuery += "INNER JOIN " + RetSqlName("SG1") +" SG1 "
cQuery += "ON D4_COD = G1_COMP "
cQuery += "AND G1_COD = C2_PRODUTO "
cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "ON SD4.D4_COD = B1_COD "
cQuery += "where SD4.D4_OP = '" + SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN + "' "
cQuery += "and SD4.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SG1.D_E_L_E_T_ != '*'  and SC2.D_E_L_E_T_ != '*' 
cQuery += "and SD4.D4_FILIAL = '" + xFilial( "SD4" ) + "' and SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' and SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' "
cQuery += "order by SB1.B1_DESC desc "
MemoWrite("C:\TEMP\VIAEXTR.SQL" , cQuery )
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TMP->( DbGoTop() )
aProds := {}
lCond := .F.


oPrt:EndPage()
oPrt:StartPage() 

cCodOP	:= SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN
MSBAR("CODE128",0.5,11,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)
//MSBAR("CODE128",0.5,26,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)


oPrt:Box(15,15 ,2450, 3500, )
oPrt:Say(nLin,100,"RAVA Embalagens",oFont03, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"ORDEM DE PRODUCAO",oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Numero.: "+SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN,oFont07, 300, , , 0 )
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
//oPrt:Say(nLin,2500,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont06, 300, , , 0 )
oPrt:Say(nLin,2500,"Extrusora:"+cExtruso,oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Produto: "+Left( SC2X->C2_PRODUTO, 8 ) + " / " + cPRODUTO,oFont07, 300, , , 0 )
oPrt:Say(nLin,2500,"Qtd (Kg): "+transform(Round(SC2X->C2_QUANT*100/(100+nPVarOp),0),"@E 99999.99"),oFont07, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,100,"Descricao: "+Left( SC2X->B1_DESC, 60) ,oFont07, 300, , , 0 )
oPrt:Say(nLin,2500,"Lote: "+MV_PAR01,oFont07, 300, , , 0 )
nLin+=80
nLin2:=nLin+80
nColFinal:=1750
nColIni:=0
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Dados do Filme ",oFont07, 300, , , 0 )
nColFinal+=1750
nColIni+=1750
oPrt:Box(nLin,15 ,nLin2,nColFinal , )
oPrt:Say(nLin,nColIni+30,"Formulação ",oFont07, 300, , , 0 )
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Largura Filme: "+transform(Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARGFIL),"@E 999.99"),oFont06, 300, , , 0 )
nColIni+=1750
oPrt:Say(nLin,nColIni+30,"Produto             Qtd    Qtd.%     Densid.",oFont07, 300, , , 0 )
nLin+=80
nColIni:=0
oPrt:Say(nLin,nColIni+30,"Largura Bobina: "+transform(SC2X->B5_BOBLARG,"@E 999.99"),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,nColIni+30,"Espessura: "+transform(SC2X->B5_ESPESS,"@E 9.9999"),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,nColIni+30,"Tratamento: "+IIf( SC2X->B5_TRATAM = 'S', 'SIM', 'NAO' ),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,nColIni+30,"Slit: "+IIf(SC2X->B5_SLITEXT=='S','SIM','NAO'),oFont06, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,nColIni+30,"Sanfonado: "+Iif (SC2X->B5_SANLAM2 == 'L', 'Lamin.','Sanf.'),oFont06, 300, , , 0 )
nColIni+=1750
nLin+=80
nLinAux := nLin
nLin -= 400
nTotDe:=0
While ! TMP->( EoF() ) .and. SubStr(TMP->B1_COD,1,3) <> 'MOD'
    oPrt:Say(nLin,nColIni+30,alltrim(TMP->B1_TITORIG),oFont06, 300, , , 0 )     
    oPrt:Say(nLin,nColIni+550,Transform(TMP->D4_QUANT,"@E 999,999.99") ,oFont06, 300, , , 0 )     
    oPrt:Say(nLin,nColIni+850,Transform(TMP->G1_QUANT,"@E 999,999.99") ,oFont06, 300, , , 0 )     
    oPrt:Say(nLin,nColIni+1280,alltrim(transform(TMP->B1_DENSMAT,"@E 999,999.999") ),oFont06, 300, , , 0 )
    nTotalG1	+= G1_QUANT     
	nTotDe	    += (G1_QUANT*B1_DENSMAT)     
	TMP->( DbSkip() )
	nLin+=80
EndDo

If nLin < nLinAux
	nLin	:= nLinAux
EndIf

TMP->( DbCloseArea() )
//nLin+=80
nColIni:=0
oPrt:Say(nLin,30,"Alt.Pesc/Mat: "+SC2X->B5_PTONEVE+' / '+alltrim(Left(SC2X->B5_MATRIZ,12)),oFont06, 300, , , 0 )
nColIni+=1750
oPrt:Say(nLin,nColIni+30,"TOTAIS: ",oFont07, 300, , , 0 )
oPrt:Say(nLin,nColIni+850,alltrim(transform(nTotalG1,"@E 999.999") ),oFont06, 300, , , 0 )     
oPrt:Say(nLin,nColIni+1280,alltrim(transform(nTotDe,"@E 999,999.999")),oFont06, 300, , , 0 )     

nLin+=80
nColIni:=0
oPrt:Say(nLin,30,"Alt.Pesc/Mat: "+SC2X->B5_PTONEV2+' / '+alltrim(Left(SC2X->B5_MATRIZ2,12)),oFont06, 300, , , 0 )
nColIni+=1750
oPrt:Say(nLin,nColIni+30,"% Reciclado ______________________________________________________________________________",oFont06, 300, , , 0 )
nLin+=80
nColIni:=0
nDENSIDA := SC2X->B5_DENSIDA
oPrt:Say(nLin,30,"Peso p/ Metro: "+TRANSFORM(100/(100 / ( ( Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARGFIL) * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 )),"@E 999.999999"),oFont06, 300, , , 0 )
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
local nLin:=nLin2:=nCol:=100
local cQuant:=''
local acess:={}
local cComp:=''
cCodEtiq := Alltrim( SC2X->C2_PRODUTO )+"-"

oPrt:EndPage()
oPrt:StartPage() 

cCodOP	:= SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN

MSBAR("CODE128",0.5,11,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)

oPrt:Box(15,15 ,2450, 3500, )
oPrt:Say(nLin,nCol,"RAVA Embalagens",oFont10, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,nCol,"ORDEM DE PRODUCAO",oFont10, 300, , , 0 )
oPrt:Say(nLin,nCol+1200,"Numero.: " + SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN+'-'+ALLTRIM(cExtruso),oFont10, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,nCol,"V I A   P A R A   C O R T E"+cBobina,oFont10, 300, , , 0 )
//oPrt:Say(nLin,nCol+1200,"Data...:"+dtoc(SC2X->C2_EMISSAO),oFont10, 300, , , 0 )
oPrt:Say(nLin,nCol+700,"Data:"+dtoc(SC2X->C2_EMISSAO)+' Lote.:'+alltrim(MV_PAR01),oFont10, 300, , , 0 )
Z03->( DbSeek( xFILIAL("Z03") + SC2X->C2_NUM ) )
nLin+=80
if SC2X->C2_OPLIC = "S"
    oPrt:Say(nLin,nCol,"***ATENCAO: ORDEM PRODUCAO AMOSTRA DE LICITACAO ***",oFont06, 300, , , 0 )
elseif SC2X->C2_USAAGLI = "S"
	oPrt:Say(nLin,nCol,"***ATENCAO: ORDEM PRODUCAO 100 % AGLUTINADO     ***",oFont06, 300, , , 0 )
elseIF SC2X->C2_OPVIP = "S"
	oPrt:Say(nLin,nCol,"***ATENCAO: ORDEM PRODUCAO PRIORIDADE CARTEIRA ***",oFont06, 300, , , 0 )
ENDIF
oPrt:Say(nLin,nCol+1200,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont06, 300, , , 0 )
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
/*
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
*/
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

cQuery := "select B1_DESC, G1_COMP, G1_QUANT, B1_UM "
cQuery += "from "+retSqlName("SG1")+" SG1 join "+retSqlName("SB1")+" SB1 on G1_COMP = B1_COD and SG1.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
//cQuery += "and SB1.B1_TIPO in ('ME','AC','IS') " 
//cQuery += "and SB1.B1_ATIVO = 'S' "
cQuery += "and SG1.G1_COD = '"+cCod+"' "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )

do while _TMPK->( !EoF() )
	aAdd(aRet, { substr( _TMPK->B1_DESC, 1,35 ), substr( _TMPK->G1_COMP, 1,8 ), _TMPK->B1_UM, _TMPK->G1_QUANT } )
	_TMPK->( dbSkip() )
endDo
_TMPK->( dbCloseArea() )

Return aRet


***************

static function ViaAnvi(nTipo)

***************

local cQuant:=" "
Local nLin:=nLin2:=100
Local nCol:=80
Local _nCol2:=1825

Local aAcess := {}
cCodEtiq := Alltrim( SC2X->C2_PRODUTO )+"-"

oPrt:EndPage()
oPrt:StartPage() 

cCodOP	:= SC2X->C2_NUM + SC2X->C2_ITEM + SC2X->C2_SEQUEN

oPrt:Box(0, 0 ,2350, 3350, ) 		// Box geral
oPrt:Box(0, 0 ,350, 1750, ) 		// Box Cabec Esq
oPrt:Box(0, 0 ,600, 1750, ) 		// Box Prod Esq
oPrt:Box(0, 0 ,1150, 1750, ) 		// Box Especificaçoes Esq
oPrt:Box(0, 0 ,2350, 1750, ) 		// Box Acessorios Esq


MSBAR("CODE128",0.5,11,cCodOP,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)


oPrt:Say(nLin,nCol  ,"RAVA Embalagens ",oFont10, 300, , , 0 )
oPrt:Say(nLin,_nCol2,"Houve Anomalias de Qualidade ? ",oFont20, 300, , , 0 )

nLin+=85

oPrt:Say(nLin,nCol,"ORDEM DE PRODUCAO",oFont10, 300, , , 0 )
oPrt:Say(nLin,_nCol2,"Sim (   )        Nao (   ) ",oFont20, 300, , , 0 )

if !empty(cExtruso)
   oPrt:Say(nLin,nCol+1000,cCodOP+'-'+alltrim(cExtruso),oFont10, 300, , , 0 )
else
   oPrt:Say(nLin,nCol+1000,cCodOP,oFont10, 300, , , 0 )
endif

nLin+=70
//oPrt:Say(nLin,nCol,iif(nTipo=0,"V I A   P A R A   A N G E V I S A ",),oFont10, 300, , , 0 )


//oPrt:Say(nLin,nCol+1000,"Data:"+dtoc(SC2X->C2_EMISSAO),oFont10, 300, , , 0 )
oPrt:Say(nLin,nCol,"Data:"+dtoc(SC2X->C2_EMISSAO)+' Lote.:'+alltrim(MV_PAR01),oFont10, 300, , , 0 )
    
Z03->( DbSeek( xFILIAL("Z03") + SC2X->C2_NUM ) )


nLin+=80

oPrt:Say(nLin,_nCol2,"Histórico de Qualidade:",oFont10, 300, , , 0 )

if SC2X->C2_OPLIC = "S"
	oPrt:Say(nLin,nCol,"***ATENCAO: OP AMOSTRA DE LICITACAO ***",oFont10, 300, , , 0 )
elseif SC2X->C2_USAAGLI = "S"
	oPrt:Say(nLin,nCol,"***ATENCAO: OP 100 % AGLUTINADO     ***",oFont10, 300, , , 0 )
elseIF SC2X->C2_OPVIP = "S"
	oPrt:Say(nLin,nCol,"***ATENCAO: OP PRIORIDADE CARTEIRA ***",oFont10, 300, , , 0 )
ENDIF

//oPrt:Say(nLin,nCol+1100,"Maquina:"+Iif (! empty (SC2X->B5_MAQ),Left(SC2X->B5_MAQ,10), '******'),oFont10, 300, , , 0 )
nLin+=80

If SC2X->C2_UM == "MR"
	cQuant:=transform( Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3 ),"@E 9999999.999" ) + "  MR"
ElseIf SC2->C2_UM == "FD"
	cQuant:=transform(Round( SC2X->C2_QUANT*100/(100+nPVarOp), 3), "@E 99999.999" )  + "  FD"
Endif

oPrt:Say(nLin,nCol,"Produto: "+ AllTrim( SC2X->C2_PRODUTO) + " - " + Left( SC2X->B1_DESC, 49 ),oFont11, 300, , , 0 )

nLin+=70
oPrt:Say(nLin,nCol,"Quilos: " + Transform( Round(SC2X->C2_QTSEGUM * 100 / (100 + nPVarOp),0),"@E 99999.99" ) + space(6) + "Qtd: " + cQuant,oFont11, 300, , , 0 )

nLin2:=nLin

// linhas para o historico da qualidade 
for _X:=1 to 10
   oPrt:Box(nLin2,1750 ,nLin2, 3350, )
   nLin2+=100
next

nLin+=120

oPrt:Say(nLin,nCol,"ESPECIFICAÇÕES DO PRODUTO",oFont10, 300, , , 0 )
nLin+=100
oPrt:Say(nLin,nCol,"Largura p/ Corte: "+ transform(Iif(SC2X->C2_OPLIC = "S",SC2X->B5_LARG2 ,SC2X->B5_LARG),"@E 999"),oFont11, 300, , , 0 )
oPrt:Say(nLin,nCol+1000,"Sanf. Fundo/Lateral: "+SC2X->B5_SANFFL,oFont11, 300, , , 0 )
nLin+=70
oPrt:Say(nLin,nCol,"Espessura: "+transform(SC2X->B5_ESPESS,"@E 9.9999"),oFont11, 300, , , 0 )
oPrt:Say(nLin,nCol+1000,"Quant. p/ pacote: "+TRANSFORM(SC2X->B5_QE1,"@E 9999"),oFont11, 300, , , 0 )
nLin+=70
oPrt:Say(nLin,nCol,"Comprimento para corte:"+transform(SC2X->B5_COMPR,"@E 9999999.99"),oFont11, 300, , , 0 )
oPrt:Say(nLin,nCol+1000,"Slit: "+IIf(SC2X->B5_SLIT=='S','SIM','NAO'),oFont11, 300, , , 0 )
nLin+=70
oPrt:Say(nLin,nCol,"Sanf./Lamin. : "+Iif (SC2X->B5_SANLAM == 'L','Lamin.','Sanf.'),oFont11, 300, , , 0 )
oPrt:Say(nLin,nCol+1000," Peso p/milheiro: "+transform(SC2X->B1_PESO / SC2X->B5_QE2 * 1000 ,"@E 9,999.999"),oFont11, 300, , , 0 )
nLin+=70
oPrt:Say(nLin,nCol,"Solda Fundo/Lateral: " + SC2X->B5_SOLDFL,oFont11, 300, , , 0 )
oPrt:Say(nLin,nCol+1000," Temperatura Solda: "+transform(SC2X->B5_CSOLDA,"@E 999.99"),oFont11, 300, , , 0 )
nLin+=70
//oPrt:Say(nLin,nCol,"Quantid. bobinas: "+TRANSFORM(SC2X->C2_QTSEGUM / 100,"@E 999"),oFont11, 300, , , 0 )
//oPrt:Say(nLin,nCol+1000," Batidas/Min: "+transform(SC2X->B5_BATPM,"9999"),oFont11, 300, , , 0 )
oPrt:Say(nLin,nCol,"Qtd bobinas: "+TRANSFORM(SC2X->C2_QTSEGUM / 100,"@E 999"),oFont11, 300, , , 0 )
oPrt:Say(nLin,nCol+1000," Bat. por Minuto: "+transform(SC2X->B5_BATPM,"9999"),oFont11, 300, , , 0 )

nLin+=70
nLin+=100
nLin2:=nLin+400
if nTipo==0
	oPrt:Say(nLin,nCol,"Acessórios:",oFont10, 300, , , 0 )
	aAcess := acessory(SC2X->C2_PRODUTO)
	nLin+=30
	For X:=1 to Len(aAcess)
		nLin+=70
		oPrt:Say(nLin,nCol,alltrim(aAcess[X][2]) + ' - ' + alltrim(aAcess[X][1]),oFont11, 300, , , 0 )
		oPrt:Say(nLin,nCol+1200,aAcess[X][3],oFont11, 300, , , 0 )
		oPrt:Say(nLin,nCol+1300,Transform(aAcess[X][4],"@E 99,999.99999"),oFont11, 300, , , 0 )
	Next X
	nLin+=80
endif


oPrt:Say(nLin2,_nCol2,"ETIQUETA EXTRUSÃO ",oFont10, 300, , , 0 )
_nCol2:=2750
oPrt:Say(nLin2,_nCol2,"ETIQUETA CORTE ",oFont10, 300, , , 0 )
nLin2+=100
oPrt:Box(nLin2, 1750, 2350, 2550, ) 	
oPrt:Box(nLin2, 1750, 2350, 3350, ) 	

nLin+=100
oPrt:Say(nLin,nCol,"Observacoes: ",oFont10, 300, , , 0 )
nLin+=160

if empty(SC2X->C2_OBS)
	//oPrt:Box(nLin,0 ,0, 1750, )
else
	oPrt:Say(nLin,nCol,SC2X->C2_OBS,oFont06, 300, , , 0 )
endif



return


Static Function oPerg1(cPerg)

Local aHelpPor := {}

PutSx1( cPerg,'01','Lote          ?' ,'',''  ,'mv_ch1' ,'C', 8,0,0,'G','','ZZB','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'02', 'Via Angevisa  ?', '', '', 'mv_ch2','N',01,0,1,'C', '', ''   , '', '', 'mv_par02', 'Sim'    , '', '', '' ,'Nao', '', '', '', '', '', ''               , '', '', '', '', '', {}, {}, {} )
Return
