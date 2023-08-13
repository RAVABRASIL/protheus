#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

//Definicao do alinhamento
#DEFINE ESQUERDA 000
#DEFINE DIREITA  001
#DEFINE CENTRO   002
//Definicao do tipo do relatorio
#DEFINE DIRET 001
#DEFINE COORD 002
#DEFINE REPRE 003
//Definicao do tipo do informacao
#DEFINE SINTET 001
#DEFINE ANALIT 002

//Definicao do tipo de busca
#DEFINE VENCEN 001
#DEFINE VENCID 002
#DEFINE AVENCE 003
#DEFINE PROTES 004

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração do arquivo pelo menu
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
**********************
User Function FINR17()
**********************
Local	lEnd	:= .F.

ValidPerg('FINR17')
if !Pergunte('FINR17',.T.)
   return
endif

Processa({ |lEnd| U_xFINR17(MV_PAR01,MV_PAR02,,Alltrim(MV_PAR03)),OemToAnsi('Imprimindo Gestão de Contas a Pagar...')}, OemToAnsi('Aguarde...'))

Return

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração e Envio pelo agendamento
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************
User Function AFINR17()
***********************

Local cEmail := "eurivan@ravaembalagens.com.br"

if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
endif

U_xFINR17(CtoD("09/07/14"),,,"C:\")

Return


************************************************
User Function xFINR17(dDtDe,dDtAte,cEmail,cDirC)
************************************************

Local cDirS  := "\TEMP\"
Local cTit
Local lPreview := !(cEmail <> nil .and. !Empty(cEmail))
Local cFor
Local dDt
Local aTot := {0,0,0,0}

Private nLinha //:= IncLinha(10)
Private cTitulo
Private nW
Private nMarE := nMarD := nMarS := nMarI := 0.5
Private wnRel := 'FINR17'
Default cDirC := cDirS

wnRel += "_"+CriaTrab( nil, .f. )

//Deleta Arquivo caso já exista
If File(cDirC+wnRel+".pdf") 
	Ferase(cDirC+wnRel+".pdf")
EndIf
   
Private oPrinter := FWMSPrinter():New(wnRel,IMP_PDF,.F.,cDirS,.T.,,,,,.F.)
Private m_pag := 0
Private oFont08  := TFontEx():New(oPrinter,"Arial",05,05,.F.,.T.,.F.)// 1
Private oFont08N := TFontEx():New(oPrinter,"Arial",06,06,.T.,.T.,.F.)// 1
Private oFont10  := TFontEx():New(oPrinter,"Arial",08,08,.F.,.T.,.F.)// 1
Private oFont10N := TFontEx():New(oPrinter,"Arial",08,08,.T.,.T.,.F.)// 1
Private oFont12  := TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
Private OFONT12N := TFontEx():New(oPrinter,"Arial",11,11,.T.,.T.,.F.)// 12  
Private oFont14  := TFontEx():New(oPrinter,"Arial",13,13,.F.,.T.,.F.)// 10
Private OFONT14N := TFontEx():New(oPrinter,"Arial",13,13,.T.,.T.,.F.)// 12
Private oFont18N := TFontEx():New(oPrinter,"Arial",17,17,.T.,.T.,.F.)// 12

ProcRegua(0) // Regua

cTitulo := "Relatório para Gestão de Contas"

oPrinter:nDevice  := IMP_PDF
oPrinter:cPathPDF := cDirC  //caminho onde será salvo o pdf
oPrinter:SetLandscape()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetViewPDF(.F.)
   
oPrinter:StartPage()
nVPage := 21
nHPage := 29.7

nHPage -= (nMarE+nMarD)
nVPage -= (nMarS+nMarI)

nLinha := Cabecalho()
nLinha := TextoHorz(nLinha, 1, 1, "A PAGAR - Entre: "+DtoC(MV_PAR01)+" e "+DtoC(MV_PAR02),CENTRO, ,oFont18N:oFont )
nLinha += IncLinha(1.5) //Incremento duas linhas
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := CabIte(nLinha,MV_PAR01)

aVcc := CtaVcc(dDtDe,dDtAte) //Titulos vencendo no periodo informado
cFor := ""
dDt  := MV_PAR01
for _x := 1 to len(aVcc)
   if nLinha+.75 >= nVPage .or. dDt <> aVcc[_x,1]
      if dDt <> aVcc[_x,1]
         TotDia(nLinha, aTot) //Imprime o total do dia
         aTot := {0,0,0,0}    //Zera totalizadores
      endif
      
      oPrinter:EndPage()
      oPrinter:StartPage()          
      nLinha := Cabecalho()
      nLinha := TextoHorz(nLinha, 1, 1, "CONTAS A PAGAR" ,CENTRO, ,oFont18N:oFont )
      nLinha += IncLinha(1.5) //Incremento duas linhas
      nLinha := LinhaHorz(nLinha, 1,1)
      nLinha := CabIte(nLinha,aVcc[_x,1])
   endif
   
   if cFor <> aVcc[_x,2]
      nLinha := LinhaHorz(nLinha, 1,1)
      nLinha := TextoHorz(nLinha, 16,01, aVcc[_x,2], CENTRO,,oFont10:oFont) //Codigo
      nLinha := TextoHorz(nLinha, 16,02, aVcc[_x,3], ESQUERDA,Cm2Px(5.5))   //Nome
      nLinha := TextoHorz(nLinha, 16,04, aVcc[_x,4], CENTRO )               //Nivel
   endif
   nLinha := TextoHorz(nLinha, 16,05, Transform(aVcc[_x,8],"@E 9,999,999.99"), DIREITA ) //Valor vencendo
   nLinha := TextoHorz(nLinha, 16,06, aVcc[_x,5], ESQUERDA)                              //Documento  
   aTot[1] += aVcc[_x,8] //Totalizador dos titulos vencendo
   
   if cFor <> aVcc[_x,2]
      aVcr := CtaVcr( aVcc[_x,2], aVcc[_x,1] ) //Titulos a Vencer a do fornecedor e a partir da data informada
      for _y := 1 to len(aVcr)         
         nLinha := TextoHorz(nLinha, 16,07, Transform(aVcr[_y,2],"@E 9,999,999.99"), DIREITA) //Valor Proximo
         nLinha := TextoHorz(nLinha, 16,08, DtoC(aVcr[_y,1]) , CENTRO)                        //Venc. Proximo
         nLinha := TextoHorz(nLinha, 16,09, Transform(aVcr[_y,3],"@E 9,999,999.99"), DIREITA) //Total a Vencer
         aTot[2] += aVcr[_y,3] //Totalizador dos titulos a vencer         
      next _y   

      aVcd := CtaVcd( aVcc[_x,2], aVcc[_x,1] ) //Titulos vencidos do fornecedor e a anteriores a data informada
      for _z := 1 to len(aVcd)
         nLinha := TextoHorz(nLinha, 16,10, Transform(aVcd[_z,2],"@E 9,999,999.99"), DIREITA) //Vlr. mais Antigo
         nLinha := TextoHorz(nLinha, 16,11, DtoC(aVcd[_z,1]) , CENTRO)                        //Venc.mais Antigo
         nLinha := TextoHorz(nLinha, 16,12, Transform(aVcd[_z,3],"@E 9,999,999.99"), DIREITA) //Total em Atraso
         aTot[3] += aVcd[_z,3] //Totalizador dos titulos a vencidos
         
         nLinha := TextoHorz(nLinha, 16,13, Transform(aVcd[_z,4],"@E 999"), CENTRO)         
         //DESCOMENTAR APOS A CRIACAO DO CAMPO NO SE2 - E2_PROTEST
         
         aPro := CtaPro( aVcc[_x,2] ) //Titulos protestados do fornecedor
         for _w := 1 to len(aPro)
            nLinha := TextoHorz(nLinha, 16,14, "Sim"      , CENTRO)
            nLinha := TextoHorz(nLinha, 16,15, Transform(aPro[_w,1],"@E 999"), CENTRO)           //Quantidade de protestos
            nLinha := TextoHorz(nLinha, 16,16, Transform(aPro[_w,2],"@E 9,999,999.99"), DIREITA) //Valor total de protestos
            aTot[4] += aPro[_w,2] //Totalizador dos titulos protestados
         next _w         
         
      next _z   
   endif
   
   nLinha += IncLinha(.75)
   dDt  := aVcc[_x,1]   
   cFor := aVcc[_x,2]   
next _x

if _x > 1
   TotDia(nLinha, aTot) //Imprime o total do dia
   aTot := {0,0,0,0}    //Zera totalizadores
endif

oPrinter:EndPage() //Fim do arquivo
oPrinter:Print() //gera o arquivo pdf

if !lPreview
   //U_SendPSV60(cEmail, "", "Posição de Vendas 6.0 - "+cTit, "", cDirC, wnRel+".pdf" )
else
   nRet := ShellExecute("open", cDirC+wnRel+".pdf", "", "", 1)
endif

if file(cDirS+wnRel+".pdf")
	Ferase(cDirS+wnRel+".pdf")
endif

if file(cDirS+wnRel+".rel")
	Ferase(cDirS+wnRel+".rel")
endif

FreeObj(oPrinter)
oPrinter := Nil

Return


//Vencendo no periodo
************************************
Static Function CtaVcc(dDtDe,dDtAte)
************************************

local aRet   := {}
local cQuery

cQuery := "SELECT "
cQuery += "   VENC=E2_VENCREA,COD=A2_COD,NOME=A2_NREDUZ,NIVEL=A2_PRIOR,NUM=E2_NUM,PREF=E2_PREFIXO,PARC=E2_PARCELA,VALOR=E2_SALDO "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2 "
cQuery += "WHERE
cQuery += "   E2_FILIAL = '" + xFilial("SE2") + "' AND " 
cQuery += "   E2_VENCREA BETWEEN '"+DtoS(dDtDe)+"' AND '"+DtoS(dDtAte)+"' AND "
cQuery += "   A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND
cQuery += "   E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")+" AND "
cQuery += "   E2_SALDO > 0 AND "
cQuery += "   SE2.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "
cQuery += "   E2_VENCREA, A2_PRIOR, E2_FORNECE, E2_NUM,E2_PREFIXO,E2_PARCELA "

if Select("SE2X") > 0
	DbSelectArea("SE2X")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "SE2X"
TCSetField( "SE2X", "VENC", "D" )

while !SE2X->(EOF()) 
   Aadd(aRet, {SE2X->VENC,SE2X->COD,SE2X->NOME,SE2X->NIVEL,SE2X->NUM,SE2X->PREF,SE2X->PARC,SE2X->VALOR})
   SE2X->(DbSkip())
end

DbSelectArea("SE2X")
DbCloseArea()

return aRet


//A Vencer a partir da data
************************************
Static Function CtaVcr(cForne,dData)
************************************

local aRet   := {}
local cQuery

cQuery := "SELECT TOP 1"
cQuery += "    PROXVENC=E2_VENCREA,"
cQuery += "    PROXVALOR=E2_SALDO,"
cQuery += "    VLRTOTAL=SUM(E2_SALDO) OVER(PARTITION BY E2_FORNECE) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SE2")+" SE2 "
cQuery += "WHERE
cQuery += "   E2_FILIAL = '" + xFilial("SE2") + "' AND " 
cQuery += "   E2_VENCREA > '"+DtoS(dData)+"' AND E2_FORNECE = '"+cForne+"' AND "
cQuery += "   E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")+" AND "
cQuery += "   E2_SALDO > 0 AND "
cQuery += "   SE2.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY "
cQuery += "   E2_VENCREA "

if Select("CTAVCR") > 0
	DbSelectArea("CTAVCR")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "CTAVCR"
TCSetField( "CTAVCR", "PROXVENC", "D" )

while !CTAVCR->(EOF()) 
   Aadd(aRet, {CTAVCR->PROXVENC,CTAVCR->PROXVALOR,CTAVCR->VLRTOTAL})
   CTAVCR->(DbSkip())
end

DbSelectArea("CTAVCR")
DbCloseArea()

return aRet


//Vencidos até dia anterior
************************************
Static Function CtaVcd(cForne,dData)
************************************

local aRet   := {}
local cQuery
local nDiasProt

cQuery := "SELECT TOP 1"
cQuery += "   ANTIGVENC=E2_VENCREA, "
cQuery += "   ANTIGVALOR=E2_SALDO,"
cQuery += "   VLRTOTAL=SUM(E2_SALDO) OVER(PARTITION BY E2_FORNECE) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SE2")+" SE2 "
cQuery += "WHERE
cQuery += "   E2_FILIAL = '" + xFilial("SE2") + "' AND " 
cQuery += "   E2_VENCREA < '"+DtoS(dData)+"' AND E2_FORNECE = '"+cForne+"' AND "
cQuery += "   E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")+" AND "
cQuery += "   E2_SALDO > 0 AND "
cQuery += "   SE2.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY "
cQuery += "   E2_VENCREA "

if Select("CTAVCD") > 0
	DbSelectArea("CTAVCD")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "CTAVCD"
TCSetField( "CTAVCD", "ANTIGVENC", "D" )
while !CTAVCD->(EOF()) 
   nDiasProt := CTAVCD->ANTIGVENC+5-dDataBase
   Aadd(aRet, { CTAVCD->ANTIGVENC,CTAVCD->ANTIGVALOR,CTAVCD->VLRTOTAL,if(nDiasProt<0,0,nDiasProt) })
   CTAVCD->(DbSkip())
end

DbSelectArea("CTAVCD")
DbCloseArea()

return aRet


******************************
Static Function CtaPro(cForne)
******************************

local aRet   := {}
local cQuery
local nDiasProt

cQuery := "SELECT "
cQuery += "   QTDPROT=COUNT(E2_NUM), "
cQuery += "   VLRPROT=SUM(E2_SALDO)"
cQuery += "FROM "
cQuery += "   "+RetSqlName("SE2")+" SE2 "
cQuery += "WHERE
cQuery += "   E2_FILIAL = '" + xFilial("SE2") + "' AND " 
cQuery += "   E2_FORNECE = '"+cForne+"' AND "
cQuery += "   E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")+" AND "
cQuery += "   E2_SALDO > 0 AND E2_PROTEST = '1' AND "
cQuery += "   SE2.D_E_L_E_T_ = ' ' "

if Select("CTAPRO") > 0
	DbSelectArea("CTAPRO")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "CTAPRO"
while !CTAPRO->(EOF()) 
   Aadd(aRet, {CTAPRO->QTDPROT,CTAPRO->VLRPROT })
   CTAPRO->(DbSkip())
end

DbSelectArea("CTAPRO")
DbCloseArea()

return aRet


************************************
Static Function CabIte(nLinha,dData)
************************************
local nLarg  := getMCol(16,1)[2]
local nLin := nLinha

TextoHorz(nLin, 16,01, "Fornecedor" , CENTRO,nLarg*4,oFont14N:oFont)
LinhaVert(nLin, getMCol(16,05)[1], .5 )
TextoHorz(nLin, 16,05, "Para dia: "+DtoC(dData), CENTRO,nLarg*2)
LinhaVert(nLin, getMCol(16,07)[1], .5 )
TextoHorz(nLin, 16,07, "A vencer"   , CENTRO,nLarg*3,oFont14N:oFont)
LinhaVert(nLin, getMCol(16,10)[1], .5 )
TextoHorz(nLin, 16,10, "Vencidos"   , CENTRO,nLarg*4)
LinhaVert(nLin, getMCol(16,14)[1], .5 )
TextoHorz(nLin, 16,14, "Protestados", CENTRO,nLarg*3)

nLin += IncLinha(1)
LinhaHorz(nLin, 1,1)

TextoHorz(nLin+.2, 16,01, "Cód."              , CENTRO,,oFont10N:oFont)
LinhaVert(nLin, getMCol(16,02)[1], .75 )
TextoHorz(nLin+.2, 16,02, "Nome"              , CENTRO)
LinhaVert(nLin, getMCol(16,04)[1], .75 )
TextoHorz(nLin+.2, 16,04, "Nivel"             , CENTRO)

LinhaVert(nLin, getMCol(16,05)[1], .75 )
TextoHorz(nLin+.2, 16,05, "Valor"             , CENTRO)
LinhaVert(nLin, getMCol(16,06)[1], .75 )
TextoHorz(nLin+.2, 16,06, "Numero"            , CENTRO)

LinhaVert(nLin, getMCol(16,07)[1], .75 )
TextoHorz(nLin   , 16,07, "Valor Próximo"     , CENTRO)
LinhaVert(nLin, getMCol(16,08)[1], .75 )
TextoHorz(nLin   , 16,08, "Venc. Próximo"     , CENTRO)
LinhaVert(nLin, getMCol(16,09)[1], .75 )
TextoHorz(nLin   , 16,09, "Total a Vencer"    , CENTRO)

LinhaVert(nLin, getMCol(16,10)[1], .75 )
TextoHorz(nLin, 16,10, "Vlr. mais Antigo"  , CENTRO)
LinhaVert(nLin, getMCol(16,11)[1], .75 )
TextoHorz(nLin, 16,11, "Venc. mais Antigo" , CENTRO)
LinhaVert(nLin, getMCol(16,12)[1], .75 )
TextoHorz(nLin, 16,12, "Total em Atraso"   , CENTRO)
LinhaVert(nLin, getMCol(16,13)[1], .75 )
TextoHorz(nLin, 16,13, "Dias p/ Protesto"  , CENTRO)

LinhaVert(nLin, getMCol(16,14)[1], .75 )
TextoHorz(nLin, 16,14, "Tem Protesto"      , CENTRO)
LinhaVert(nLin, getMCol(16,15)[1], .75 )
TextoHorz(nLin, 16,15, "Qtd. Prostesto"    , CENTRO)
LinhaVert(nLin, getMCol(16,16)[1], .75 )
TextoHorz(nLin, 16,16, "Total Protesto"    , CENTRO)
nLin += IncLinha(1.5)
nLin := LinhaHorz(nLin, 1,1)                       

return nLin


*************************************
Static Function TotDia(nLinha,aTotal)
*************************************
local nLarg  := getMCol(16,1)[2]
local nLin := nLinha

LinhaHorz(nLin, 1,1)
TextoHorz(nLin+.2, 16,01, "Total do dia:", CENTRO ,nLarg*4,oFont10N:oFont)
LinhaVert(nLin, getMCol(16,05)[1], .75 )
TextoHorz(nLin+.2, 16,05, Transform(aTotal[1],"@E 9,999,999.99"), DIREITA,nLarg*2)

LinhaVert(nLin, getMCol(16,07)[1], .75 )
TextoHorz(nLin+.2, 16,07, "A Vencer:"    , CENTRO)
LinhaVert(nLin, getMCol(16,08)[1], .75 )
TextoHorz(nLin+.2, 16,08, Transform(aTotal[2],"@E 9,999,999.99"), DIREITA,nLarg*2)

LinhaVert(nLin, getMCol(16,10)[1], .75 )
TextoHorz(nLin+.2, 16,10, "Vencidos:"    , CENTRO ,)
LinhaVert(nLin, getMCol(16,11)[1], .75 )
TextoHorz(nLin+.2, 16,11, Transform(aTotal[3],"@E 9,999,999.99"), DIREITA,nLarg*2)

LinhaVert(nLin, getMCol(16,13)[1], .75 )
TextoHorz(nLin+.2, 16,13, "Protestados:" , CENTRO ,nLarg*2)
LinhaVert(nLin, getMCol(16,15)[1], .75 )
TextoHorz(nLin+.2, 16,15, Transform(aTotal[4],"@E 9,999,999.99"), DIREITA,nLarg*2)


nLin += IncLinha(1.5)
nLin := LinhaHorz(nLin, 1,1)                       

return nLin



//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Cálculo da qtd 
//de dias úteis entre um intervalod de datas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
****************************************
Static Function DiasUteis(dDtIni,dDtFim)
****************************************

local nDUtil := 0
local dDtMov := dDtIni

while dDtMov <= dDtFim
   if DataValida(dDtMov) = dDtMov
      nDUtil += 1
   endif	
   dDtMov += 1
end                 

return(nDUtil) 

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime Texto na Horizontal    
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************************************************************************
Static Function TextoHorz(nLinha, nQtdCol, nColRet, cTexto, nAlin, nLargura, oFont)
***********************************************************************************

local aCol := getMCol(nQtdCol,nColRet)
local nIni := aCol[1]
local nTam := if(nLargura<>nil,nLargura,aCol[2])

if nQtdCol > 1 
   nTam -= .25
   if ( nColRet > 1 )
      nIni += .25
   endif   
endif

oPrinter:SayAlign( Cm2Px(nLinha),Cm2Px(nIni),cTexto,oFont,Cm2Px(nTam),25,,nAlin,0 )
       //SayAlign(<nRow>,<nCol>,<cText>,[oFont],[nWidth],[nHeigth],[nClrText],[nAlignHorz],[nAlignVert] )   
return nLinha


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime Linha na Horizontal    
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***************************************************************
Static Function LinhaHorz( nLinha, nQtdCol, nColRet, nLargura )
***************************************************************

Local aCol := getMCol(nQtdCol,nColRet)
Local nIni := aCol[1]
Local nTam := nIni+if(nLargura<>nil,nLargura+nMarE+nMarD,aCol[2])

if nQtdCol > 1 
   if nLargura = nil
      nTam -= .25
   endif   

   if ( nColRet > 1 )
      nIni += .25
   endif   
endif
//     : Line( < nTop>      , < nLeft>   , < nBottom>  , < nRight> , [ nColor], [ cPixel] ) -->
oPrinter:Line( Cm2Px(nLinha), Cm2Px(nIni),Cm2Px(nLinha),Cm2Px(nTam),, "-2" )

return nLinha

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime Linha na Vertical         //
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
**************************************************
Static Function LinhaVert( nLinha, nCol, nAltura )
**************************************************
oPrinter:Line( Cm2Px(nLinha+nAltura), Cm2Px(nCol+if(nCol>nMarE,.25,0))  ,Cm2Px(nLinha), Cm2Px(nCol+if(nCol>nMarE,.25,0)),, "-2" )

return nLinha


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Funcao que calcula as colunas em tamanhos 
//³iguais e retorna a posicao da coluna 
//³passada no parametro nPosCol
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
********************************************
Static Function getMCol( nQtdCols, nPosCol )
********************************************
Local nTamCol := nPCol := 0

nTamCol := (nHPage/nQtdCols)
nPCol   := (nTamCol*nPosCol)-nTamCol+nMarE
//Retorno a posição da coluna e o tamanho da mesma
return {nPCol,nTamCol}

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Funcao que converte Cm em Pixel
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
****************************
Static Function Cm2Px( nCM )
****************************
//Multiplico o valor em Cm pela Resolucao padrão do Protheus e depois divido pelos Cm por Polegada
return (nCM*72) / 2.54

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Funcao que converte Pixel em Cm
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
****************************
Static Function Px2Cm( nPx )
****************************
//Divido o valor em Px pela Resolucao padrão do Protheus e depois Multiplico pelos Cm por Polegada
return (nPx/72) * 2.54

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Funcao incrementa a Linha
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
**********************************
Static Function IncLinha( nSalto )
**********************************
return nSalto * .5


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime o cabecalho do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***************************
Static Function Cabecalho()
***************************
m_pag += 1

nLinha := IncLinha(2)
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 2,1, AllTrim(SM0->M0_NOME)+"/"+AllTrim(SM0->M0_FILIAL),ESQUERDA,,oFont12:oFont)
nLinha := TextoHorz(nLinha, 2,2, RptFolha +" " + TRANSFORM(m_pag,'999999')        ,DIREITA,,oFont12:oFont)
nLinha += .3
nLinha := TextoHorz(nLinha, 1,1, cTitulo,CENTRO)
nLinha := TextoHorz(nLinha, 2,1, "SIGA /"+wnrel                                   ,ESQUERDA,,oFont12:oFont)
nLinha := TextoHorz(nLinha, 2,2, RptDtRef +" "+ DTOC(dDataBase)                   ,DIREITA,,oFont12:oFont)
nLinha += .3
nLinha := TextoHorz(nLinha, 2,1, RptHora +" "+time()                              ,ESQUERDA,,oFont12:oFont)
nLinha := TextoHorz(nLinha, 2,2, RptEmiss+" "+DToC(MsDate())                      ,DIREITA,,oFont12:oFont)
nLinha += .5
nLinha := LinhaHorz(nLinha, 1,1)

//Imprime Rodape
LinhaHorz(nVPage+.5, 1,1)
TextoHorz(nVPage+.5, 1,1, "Rava Embalagens",ESQUERDA,,oFont12N:oFont)
LinhaHorz(nVPage+1 , 1,1)

Return nLinha


********************************
Static Function ValidPerg(cPerg)
********************************

PutSx1( cPerg, '01', 'Vencto De    ?', '', '', 'mv_ch1', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par01', ''         , '', '', '' ,''         , '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Vencto Ate   ?', '', '', 'mv_ch2', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par02', ''         , '', '', '' ,''         , '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '03', 'Salvar PDF em?', '', '', 'mv_ch4', 'C', 80, 0, 0, 'G', '', ''   , '', '', 'mv_par04', ''         , '', '', '' , ''        , '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )

Return NIL