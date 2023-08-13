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
//Constante representante
#DEFINE REPRE 003

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração do arquivo pelo menu
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************
User Function RFATR05()
***********************
Local	lEnd	:= .F.
Local cEmail

CriaSx1('RFATR05')
if !Pergunte('RFATR05',.T.)
   return
endif

Processa({ |lEnd| xRFATR05(MV_PAR01,,Alltrim(MV_PAR02)),OemToAnsi('Imprimindo Contas a Receber por Representante...')}, OemToAnsi('Aguarde...'))

Return


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração e Envio pelo 
//agendamento Representante
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
************************
User Function ARFATR05()
************************
Local _XX
Local cEmail := ""

if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
endif

//Envia para Representantes
aMails := U_RVMails( REPRE )
for _XX := 1 to Len(aMails)
   cEmail := aMails[_XX,2]
   xRFATR05(aMails[_XX,1],cEmail)     
next _XX

Return


*******************************************
Static Function xRFATR05(cCod,cEmail,cDirC)
*******************************************

Local lPreview := !(cEmail <> nil .and. !Empty(cEmail))
Local cDirS    := "\TEMP\"
Local cQuery   := ""

Private nAltLin := 0.5
Private nLinha := IncLinha(3)
Private cTitulo
Private nW
Private nMarE := nMarD := nMarS := nMarI := 0.5
Private wnRel := 'RFATR05_'+Alltrim(cCod)


Default cDirC := cDirS

wnRel += "_"+CriaTrab( nil, .f. )

//Deleta Arquivo caso já exista
If File(cDirC+wnRel+".pdf") 
	Ferase(cDirC+wnRel+".pdf")
EndIf
   
Private oPrinter := FWMSPrinter():New(wnRel,IMP_PDF,.F.,cDirS,.T.,,,,,.F.)
Private m_pag := 0
Private oFont10  := TFontEx():New(oPrinter,"Arial",08,08,.F.,.T.,.F.)// 1
Private oFont10N := TFontEx():New(oPrinter,"Arial",08,08,.T.,.T.,.F.)// 1
Private oFont12  := TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
Private oFont18N := TFontEx():New(oPrinter,"Arial",17,17,.T.,.T.,.F.)// 12 
Private oFont14  := TFontEx():New(oPrinter,"Arial",13,13,.F.,.T.,.F.)// 10
Private OFONT14N := TFontEx():New(oPrinter,"Arial",13,13,.T.,.T.,.F.)// 12  
Private OFONT12N := TFontEx():New(oPrinter,"Arial",11,11,.T.,.T.,.F.)// 12  

ProcRegua(0) // Regua

cTitulo := "Titulos a Receber - "+Alltrim(cCod)+"-"+Alltrim(Posicione("SA3",1,xFilial("SA3")+cCod,"A3_NOME"))

oPrinter:nDevice := IMP_PDF
oPrinter:cPathPDF := cDirC  //caminho onde vai ser salvo o pdf
oPrinter:SetLandscape()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetViewPDF(.F.)
   
oPrinter:StartPage()
nHPage := 27.9
nVPage := 21

nHPage -= (nMarE+nMarD)
nVPage -= (nMarS+nMarI)

nLinha := Cabecalho()
nLinha := CabItem()

cQuery := "SELECT "
//Representante
cQuery += "   CODREP=A3_COD, NOMREP=RTRIM(A3_NREDUZ), MAILREP=RTRIM(A3_EMAIL), "
//Titulo
cQuery += "   PEDIDO=E1_PEDIDO, TIPO=E1_TIPO, NUMERO=E1_NUM, PREFIXO=E1_PREFIXO, PARCELA=E1_PARCELA,EMISSAO=E1_EMISSAO, "
cQuery += "   VENCTO=E1_VENCREA, VALOR=E1_VALOR, SALDO=E1_SALDO, "
cQuery += "   ATRASO=CAST(CONVERT(DATETIME,'"+DtoS(dDataBase)+"')-CONVERT(DATETIME,E1_VENCREA) AS INTEGER), "
//Cliente
cQuery += "   CODCLI=A1_COD, LOJACLI=A1_LOJA, NOMCLI=RTRIM(A1_NOME), NOMRED=RTRIM(A1_NREDUZ) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SA1")+" SA1 WITH (NOLOCK), "+RetSqlName("SA3")+" SA3 WITH (NOLOCK), "+RetSqlName("SE1")+" SE1 WITH (NOLOCK) "
cQuery += "WHERE "
cQuery += "   E1_EMISSAO BETWEEN '20000101' AND '20491231' AND " //Emissao
cQuery += "   E1_VEND1 = '"+cCod+"' AND " //Representante
cQuery += "   E1_VENCREA BETWEEN '20000101' AND '"+DtoS(dDataBase+7)+"' AND " //Vencimento

cQuery += "   E1_TIPO = 'NF' AND E1_SALDO > 0 AND "
 
cQuery += "   E1_CLIENTE = A1_COD  AND "
cQuery += "   E1_LOJA    = A1_LOJA AND "

cQuery += "   E1_VEND1   = A3_COD  AND "

cQuery += "   RTRIM(A3_ATIVO) <> 'N' AND "

cQuery += "   SA1.A1_FILIAL = '  ' AND SA1.D_E_L_E_T_ <> '*' AND "
cQuery += "   SA3.A3_FILIAL = '  ' AND SA3.D_E_L_E_T_ <> '*' AND "
cQuery += "   SE1.E1_FILIAL = '01' AND SE1.D_E_L_E_T_ <> '*' "

cQuery += "ORDER BY "
cQuery += "   E1_VENCREA, E1_NUM, E1_PREFIXO, E1_PARCELA "

if Select("RECX") > 0
	DbSelectArea("RECX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "RECX"

TCSetField( "RECX", "EMISSAO", "D")
TCSetField( "RECX", "VENCTO" , "D")

while !RECX->(Eof()) 
  
   dVencto := RECX->VENCTO
   TextoHorz(nLinha, 01,01, "Vencimento: "+DtoC(dVencto), ESQUERDA,,oFont14N:oFont) //Pedido
   nLinha := LinhaHorz(nLinha, 1,1)   
   nLinha += IncLinha(1)
   nTotSal := nTotVal := 0
   while !RECX->(Eof()) .AND. dVencto == RECX->VENCTO	   
	   if nLinha+1.5 >= nVPage           
	      oPrinter:EndPage()
	      oPrinter:StartPage()          
	      nLinha := Cabecalho()
         TextoHorz(nLinha, 01,01, "Continua vencimento: "+DtoC(dVencto), ESQUERDA,,oFont14N:oFont) //Pedido
         nLinha := LinhaHorz(nLinha, 1,1)   
         nLinha += IncLinha(1)
	      
	      nLinha := CabItem()
	   endif
	
	   TextoHorz(nLinha, 13,01, RECX->NUMERO                             , ESQUERDA,,oFont14:oFont) //Pedido
	   TextoHorz(nLinha, 13,02, RECX->PREFIXO                            , CENTRO) //Cliente
	   TextoHorz(nLinha, 13,03, RECX->PARCELA                            , CENTRO) //Loja
	   TextoHorz(nLinha, 13,04, DtoC(RECX->EMISSAO)                      , CENTRO ) //UF
	   TextoHorz(nLinha, 13,05, Transform( RECX->VALOR ,"@E 999,999.99" ), DIREITA) //Nome
	   TextoHorz(nLinha, 13,06, Transform( RECX->SALDO ,"@E 999,999.99" ), DIREITA) //Nome
	   TextoHorz(nLinha, 13,07, Transform( RECX->ATRASO,"@E 9999" )      , CENTRO ) //Nome
	   TextoHorz(nLinha, 13,08, RECX->CODCLI                             , CENTRO ) //UF   
	   TextoHorz(nLinha, 13,09, RECX->LOJACLI                            , CENTRO ) //UF      
	   TextoHorz(nLinha, 13,10, RECX->NOMCLI                             , ESQUERDA,Cm2Px(7.5),oFont12:oFont  ) //UF           
	   nTotVal += RECX->VALOR
	   nTotSal += RECX->SALDO
	   nLinha  += IncLinha(1) //Incremento uma linha
		IncProc("Imprimindo...")   
	   RECX->(DbSkip())
   end
   TextoHorz(nLinha, 13,04, "Total:", DIREITA,,oFont14N:oFont) //Nome
   TextoHorz(nLinha, 13,05, Transform( nTotVal ,"@E 999,999.99" ), DIREITA) //Nome
   TextoHorz(nLinha, 13,06, Transform( nTotSal ,"@E 999,999.99" ), DIREITA) //Nome
   nLinha := LinhaHorz(nLinha, 1,1)   

   nLinha += IncLinha(1) //Incremento uma linha   
end

RECX->(DbCloseArea())

oPrinter:EndPage() //Fim do arquivo
oPrinter:Print()   //gera o arquivo pdf
Sleep(5000)
FreeObj(oPrinter)
oPrinter := Nil

if !lPreview
   U_SendPSV(cEmail, "", "Titulos a Receber por Representante", "", cDirC, wnRel+".pdf" )   
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

*************************
Static Function CabItem()
*************************

nLinha := TextoHorz(nLinha, 13,01, "Numero"  ,ESQUERDA,,oFont14N:oFont)
nLinha := TextoHorz(nLinha, 13,02, "Serie"   ,CENTRO  )
nLinha := TextoHorz(nLinha, 13,03, "Parcela" ,CENTRO  )
nLinha := TextoHorz(nLinha, 13,04, "Emissao" ,CENTRO  )
nLinha := TextoHorz(nLinha, 13,05, "Valor"   ,DIREITA )
nLinha := TextoHorz(nLinha, 13,06, "Saldo"   ,DIREITA )
nLinha := TextoHorz(nLinha, 13,07, "Atraso"  ,CENTRO  )
nLinha := TextoHorz(nLinha, 13,08, "Cliente" ,CENTRO  )
nLinha := TextoHorz(nLinha, 13,09, "Loja"    ,CENTRO  )
nLinha := TextoHorz(nLinha, 13,10, "Nome"    ,ESQUERDA)

nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

return nLinha



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
return nSalto * nAltLin


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime o cabecalho do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***************************
Static Function Cabecalho()
***************************
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
LinhaHorz(nVPage, 1,1)
TextoHorz(nVPage, 1,1, "Rava Embalagens",ESQUERDA,,oFont12N:oFont)
LinhaHorz(nVPage+IncLinha(1), 1,1)

Return nLinha


******************************
Static Function CriaSX1(cPerg)
******************************

PutSx1( cPerg, '01', 'Representante?', '', '', 'mv_ch1', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par01', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '02', 'Salvar PDF em?', '', '', 'mv_ch2', 'C', 80, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '', '', '', '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )

Return NIL