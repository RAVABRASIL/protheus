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

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração do arquivo pelo menu
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************
User Function RFATR06()
***********************
Local	lEnd	:= .F.

ValidPerg('RFATR06')
if !Pergunte('RFATR06',.T.)
   return
endif

Processa({ |lEnd| xRFATR6(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,,Alltrim(MV_PAR07)),OemToAnsi('Oportunidades Licitação...')}, OemToAnsi('Aguarde...'))

Return

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração e Envio pelo agendamento
//Diretoria 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
************************
User Function ARFATR06()
************************
Local _XX
Local nMes
Local nAno
Local nRelato := DIRET
Local cCod    := ""
Local cUF     := ""
Local nRegiao := TODAS
Local cEmail  := ""
Local aMails  := {}
Local nLinha  := TLINHAS
Local lReal  := .T. //Envia Em Reais ou KGs

if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
endif

if Day(dDataBase) = 1
   nMes := Month(dDataBase-1)
   nAno := Year(dDataBase-1)
else
   nMes := Month(dDataBase)
   nAno := Year(dDataBase)
endif

aMails := U_RVMails( nRelato )
for _XX := 1 to Len(aMails)
   cEmail += aMails[_XX,2]
next _XX

xRFATR6(nMes,nAno,nRelato,cCod,cUF,nRegiao,cEmail,,lReal,nLinha)

Return


***********************************************************************************
static function xRFATR6(dAbert1, dAbert2, cUF, cGerent, nRes, nClie, cEmail, cDirC)
***********************************************************************************

Local cDirS  := "\TEMP\"
Local cTit
Local cCorpo   := ""
Local lPreview := !(cEmail <> nil .and. !Empty(cEmail))
Local cQuery   := ""

Private nLinha := IncLinha(1)
Private cTitulo
Private nW
Private nMarE := nMarD := nMarS := nMarI := 0.5
Private wnRel := 'RFATR06'

Default cDirC := cDirS

DbSelectArea("Z99")
              
wnRel += "_"+CriaTrab( nil, .f. )

//Deleta Arquivo caso já exista
if File(cDirC+wnRel+".pdf") 
	Ferase(cDirC+wnRel+".pdf")
endif
   
Private oPrinter := FWMSPrinter():New(wnRel,IMP_PDF,.F.,cDirS,.T.,,,,,.F.)
Private m_pag    := 0
Private oFont8  := TFontEx():New(oPrinter,"Arial",06,06,.F.,.T.,.F.)// 1
Private oFont8N := TFontEx():New(oPrinter,"Arial",06,06,.T.,.T.,.F.)// 1
Private oFont10  := TFontEx():New(oPrinter,"Arial",08,08,.F.,.T.,.F.)// 1
Private oFont10N := TFontEx():New(oPrinter,"Arial",08,08,.T.,.T.,.F.)// 1
Private oFont12  := TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
Private OFONT12N := TFontEx():New(oPrinter,"Arial",11,11,.T.,.T.,.F.)// 12  
Private oFont14  := TFontEx():New(oPrinter,"Arial",13,13,.F.,.T.,.F.)// 10
Private OFONT14N := TFontEx():New(oPrinter,"Arial",13,13,.T.,.T.,.F.)// 12  
Private oFont18N := TFontEx():New(oPrinter,"Arial",17,17,.T.,.T.,.F.)// 12 

ProcRegua(0) // Regua

cTitulo := "Oportunidades Licitação - IBIZ"

oPrinter:nDevice  := IMP_PDF
oPrinter:cPathPDF := cDirC  //caminho onde vai ser salvo o pdf
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetViewPDF(.F.)
   
oPrinter:StartPage()
nVPage := 27.9
nHPage := 21

nHPage -= (nMarE+nMarD)
nVPage -= (nMarS+nMarI)

nLinha  := Cabecalho()
nLinha  += IncLinha(1) //Incremento uma linha

//Consulta Oportunidade
cQuery := "SELECT "
cQuery += "   Z57_COD   , Z57_PALAVR, "
cQuery += "   Z57_DTREC , Z57_HRREC , "
cQuery += "   Z57_ABERTU, Z57_HRABER, "
cQuery += "   Z57_CAPTUR, Z57_HRCAP , "
cQuery += "   Z57_CIDADE, Z57_UF    , "
cQuery += "   Z57_MODALI, Z57_LICITA, "
cQuery += "   Z57_GERENT, Z57_CLIENT  "

if nRes <> 1
   cQuery += "   ,                       "
   cQuery += "   Z97_COD, Z97_ITEM     , "
   cQuery += "   Z97_SITUAC, Z97_GANHAD, "
   cQuery += "   Z97_DOCGAN, Z97_VLARRE, "
   cQuery += "   Z97_MARCA               "
endif
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z57")+" Z57 "

if nRes <> 1 //Sem resultados
   if nRes = 2 //Todos
      cQuery += "   LEFT "
   endif
   cQuery += " JOIN "+RetSqlName("Z97")+" Z97 ON Z57.Z57_COD = Z97.Z97_COD AND "
   if nRes = 3 //Rava
      cQuery += " Z97_DOCGAN <> '' AND EXISTS ( SELECT A1_CGC FROM "+RetSqlName("SA1")+" SA1 WHERE A1_CGC = Z97_DOCGAN AND SA1.D_E_L_E_T_ <> '*' ) AND "
   elseif nRes = 4 //Terceiros
      cQuery += "   Z57_DOCGAN <> '' AND "
   endif   
   cQuery += "   Z97.D_E_L_E_T_ <> '*' "   
endif

cQuery += "WHERE "
cQuery += "   Z57_STATUS = 'A' AND "
cQuery += "   Z57_ABERTU BETWEEN '"+Dtos(dAbert1)+"' AND '"+Dtos(dAbert2)+"' AND "

if !Empty(cUF)
   cQuery += "   Z57_UF = '"+cUF+"' AND "
endif

if !Empty(cGerent)
   cQuery += "   Z57_GERENT = '"+cGerent+"' AND "
endif

if nClie == 2
   cQuery += "   Z57_CLIENT <> '' AND "
elseif nClie == 3
   cQuery += "   Z57_CLIENT = '' AND "   
endif

cQuery += "   Z57.D_E_L_E_T_ <> '*'   "
cQuery += "ORDER BY "
cQuery += "   Z57_COD "
if nRes <> 1 //Sem resultados
   cQuery += ", Z97_ITEM "
endif

if Select("OPOX") > 0
	DbSelectArea("OPOX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "OPOX"
TCSetField("OPOX", "Z57_DTREC" , "D")
TCSetField("OPOX", "Z57_ABERTU", "D")
TCSetField("OPOX", "Z57_CAPTUR", "D")

nLinha := TextoHorz(nLinha, 13, 01, "Oportunid.",ESQUERDA, ,oFont10N:oFont )
nLinha := TextoHorz(nLinha, 13, 02, "Licitador" ,ESQUERDA,  Cm2Px(7) )
nLinha := TextoHorz(nLinha, 13, 09, "UF"        ,CENTRO )
nLinha := TextoHorz(nLinha, 13, 10, "Dt.Abert." ,CENTRO )
nLinha := TextoHorz(nLinha, 13, 11, "Hr.Abert." ,CENTRO )
nLinha += IncLinha(1)

while !OPOX->(Eof())
  
   if nLinha+1.5 >= nVPage           
	   oPrinter:EndPage()
	   oPrinter:StartPage()
	   nLinha := Cabecalho()+IncLinha(1)
      nLinha := TextoHorz(nLinha, 13, 01, "Oportunid.",ESQUERDA, ,oFont10N:oFont )
      nLinha := TextoHorz(nLinha, 13, 02, "Licitador" ,ESQUERDA)
      nLinha := TextoHorz(nLinha, 13, 09, "UF"        ,CENTRO )
      nLinha := TextoHorz(nLinha, 13, 10, "Dt.Abert." ,CENTRO )
      nLinha := TextoHorz(nLinha, 13, 11, "Hr.Abert." ,CENTRO )
      nLinha += IncLinha(1)	   
   endif

   nLinha := TextoHorz(nLinha, 13, 01, OPOX->Z57_COD            , ESQUERDA, ,oFont10:oFont )
   nLinha := TextoHorz(nLinha, 13, 02, Alltrim(OPOX->Z57_LICITA), ESQUERDA,Cm2Px(7) )
   nLinha := TextoHorz(nLinha, 13, 09, OPOX->Z57_UF             , CENTRO )
   nLinha := TextoHorz(nLinha, 13, 10, DtoC(OPOX->Z57_ABERTU)   , CENTRO )
   nLinha := TextoHorz(nLinha, 13, 11, OPOX->Z57_HRABER         , CENTRO )
   //nLinha += IncLinha(1)
   
   if nClie <> 3
      aClientes := fClientes( OPOX->Z57_CLIENT )
      if Len(aClientes) > 0
         nLinha += IncLinha(0.5)      
         nLinha := TextoHorz(nLinha, 15, 01, "Cliente", ESQUERDA, ,oFont8N:oFont )
         nLinha := TextoHorz(nLinha, 15, 02, "Loja"   , ESQUERDA, Cm2Px(3) )
         nLinha := TextoHorz(nLinha, 15, 03, "Nome"   , ESQUERDA, Cm2Px(5.5) )
         nLinha += IncLinha(0.5)

         for _nX := 1 to Len( aClientes )
            if nLinha+1.5 >= nVPage           
   	         oPrinter:EndPage()
         	   oPrinter:StartPage()
      	      nLinha := Cabecalho()+IncLinha(1)
            endif          
            nLinha := TextoHorz(nLinha, 15, 01, aClientes[_nX,1], ESQUERDA, ,oFont8:oFont )
            nLinha := TextoHorz(nLinha, 15, 02, aClientes[_nX,2], ESQUERDA, Cm2Px(3) )
            nLinha := TextoHorz(nLinha, 15, 03, aClientes[_nX,3], ESQUERDA, Cm2Px(5.5) )
            nLinha += IncLinha(0.5)
         next         
      endif
   endif

   if nRes <> 1 //Sem Resultados
      nLinha += IncLinha(0.5)      
      nLinha := TextoHorz(nLinha, 18, 01, "Lote"     , ESQUERDA, ,oFont8N:oFont )
      nLinha := TextoHorz(nLinha, 18, 02, "Situação" , ESQUERDA, Cm2Px(3) )
      nLinha := TextoHorz(nLinha, 18, 05, "Ganhador" , ESQUERDA, Cm2Px(5.5) )
      nLinha := TextoHorz(nLinha, 18, 11, "Vlr.Arre.", ESQUERDA, Cm2Px(3) )
      nLinha := TextoHorz(nLinha, 18, 16, "Marca"    , ESQUERDA )
      nLinha += IncLinha(0.5)
      
      cCodLote := OPOX->Z57_COD+OPOX->Z97_ITEM   
      while !OPOX->(Eof()) .AND. cCodLote == OPOX->Z57_COD+OPOX->Z97_ITEM
         if nLinha+1.5 >= nVPage           
   	      oPrinter:EndPage()
      	   oPrinter:StartPage()
   	      nLinha := Cabecalho()+IncLinha(1)
         endif          
         
         nLinha := TextoHorz(nLinha, 18, 01, OPOX->Z97_ITEM            , ESQUERDA, , oFont8:oFont )
         nLinha := TextoHorz(nLinha, 18, 02, Alltrim(OPOX->Z97_SITUAC) , ESQUERDA, Cm2Px(3) )
         nLinha := TextoHorz(nLinha, 18, 05, Alltrim(OPOX->Z97_GANHAD) , ESQUERDA, Cm2Px(5.5) )
         nLinha := TextoHorz(nLinha, 18, 11, Transform(OPOX->Z97_VLARRE,"@E 9,999,999.9999"), ESQUERDA, Cm2Px(3) )
         nLinha := TextoHorz(nLinha, 18, 16, Alltrim(OPOX->Z97_MARCA)  , ESQUERDA, Cm2Px(3) )
         nLinha += IncLinha(0.5)
         OPOX->(DbSkip())
      end
   else
      nLinha += IncLinha(1)   
      OPOX->(DbSkip())   
   endif   
end

if Select("OPOX") > 0
	DbSelectArea("OPOX")
	DbCloseArea()
endif

oPrinter:EndPage() //Fim do arquivo
oPrinter:Print()   //gera o arquivo pdf
Sleep(5000)
FreeObj(oPrinter)
oPrinter := Nil

if !lPreview
   U_SendPSV(cEmail, "", cTitulo, cCorpo, cDirC, wnRel+".pdf" )   
else   
   nRet := ShellExecute("open", cDirC+wnRel+".pdf", "", "", 1)
endif   

Sleep(5000)
if file(cDirS+wnRel+".pdf") 
	Ferase(cDirS+wnRel+".pdf")
endif

Sleep(5000)
if file(cDirS+wnRel+".rel") 
	Ferase(cDirS+wnRel+".rel")
endif

Return

**************************************
static function fClientes( cClientes )
**************************************
local cCliLoj
local _nX
local aCli := {}

DbSelectArea("SA1")
DbSetOrder(1)
for _nX := 1 to Len(cClientes) Step 8
  cCliLoj := Substr( cClientes, _nX, 8 )
  if !Empty( cCliLoj )
     SA1->(DbSeek( xFilial("SA1")+cCliLoj ) )
     Aadd(aCli, {SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME} )
  endif  
next _nX

return aCli


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime o cabecalho do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
**********************************
Static Function Cabecalho()
**********************************
m_pag += 1

nLinha := IncLinha(1)
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
LinhaHorz(nVPage+1  , 1,1)
TextoHorz(nVPage+1  , 1,1, "Rava Embalagens",ESQUERDA,,oFont12N:oFont)
LinhaHorz(nVPage+1.5, 1,1)

Return nLinha

********************************
Static Function ValidPerg(cPerg)
********************************

PutSx1( cPerg, '01', 'Abertura De  ?', '', '', 'mv_ch1', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Abertura Ate ?', '', '', 'mv_ch2', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '03', 'UF           ?', '', '', 'mv_ch3', 'C', 06, 0, 0, 'G', '', '12' , '', '', 'mv_par03', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '04', 'Gerente      ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par04', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '05', 'Resultados   ?', '', '', 'mv_ch5', 'N', 01, 0, 0, 'C', '', ''   , '', '', 'mv_par05', 'Sem Resultado', '', '', '' , 'Todos', '', '', 'Rava', '', '', 'Terceiros', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '06', 'Clientes     ?', '', '', 'mv_ch6', 'N', 01, 0, 0, 'C', '', ''   , '', '', 'mv_par06', 'Todos', '', '', '' , 'C/ Associação', '', '', 'S/ Associação', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '07', 'Salvar PDF em?', '', '', 'mv_ch7', 'C', 80, 0, 0, 'G', '', ''   , '', '', 'mv_par07', '', '', '', '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )

Return


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
       //SayAlign( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nHeigth], [ nClrText], [ nAlignHorz], [ nAlignVert ] )   
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