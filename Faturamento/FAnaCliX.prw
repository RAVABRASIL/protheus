#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
#include 'DIRECTRY.CH'

//Definicao do alinhamento
#DEFINE ESQUERDA 000
#DEFINE DIREITA  001
#DEFINE CENTRO   002

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração do arquivo pelo menu
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*************

User Function FAnaCliX(cIdAge,cOpc)

*************
/*
cOpc
1- via Agenda de viagem 
2- via relatorio 
*/

Local aArea	    := GetArea()
Local cDirS  :="\TEMP\" 
local cGestor:=" " 
local cTipo:='S' // TIPO DE RELATORIO S-SIMPLES(REPRESENTANE) ; C-COMPLETO ( COORDENADOR)

if cOPc='2' // via relatorio 
  cDirS  := "D:\TEMP\" 
endif

cDirC := cDirS
_aAnaClix:={}

NTOTABER:=0

if cOPc='1' // via agenda 

	cQuery:="SELECT DISTINCT ZZE_GESTOR,ZZF_CODCP CLIENTE,ZZF_LOJA LOJA "
	cQuery+="FROM "+RetSqlName("ZZE")+" ZZE WITH (NOLOCK) , "+RetSqlName("ZZF")+" ZZF WITH (NOLOCK) "
	cQuery+="WHERE "
	cQuery+="ZZE_CODIGO=ZZF_CODIGO "
	cQuery+="AND ZZE_CODIGO ='"+cIdAge+"' "
	cQuery+="AND ZZF_TIPO='C' " // CLIENTE 
	cQuery+="AND ZZE.D_E_L_E_T_ = ' ' "
	cQuery+="AND ZZF.D_E_L_E_T_ = ' ' "
	cQuery+="ORDER BY ZZF_CODCP,ZZF_LOJA "
	
	If Select("AGXK") > 0
		DbSelectArea("AGXK")
		AGXK->(DbCloseArea())
	EndIf
	
	TCQUERY cQuery NEW ALIAS "AGXK"
	
	AGXK->(DbGoTop()) 

  IF AGXK->(!EOF())

	While AGXK->(!EOF())

	   cGestor:=AGXK->ZZE_GESTOR // CODIGO DO GESTOR PARA O ENVIO DO EMAIL 

	   //Se for coordenador
       If Alltrim(cGestor) $ GetNewPar("MV_XCODCOO","0228,0315,0342,2348,2367")

	      cTipo:='C'
	   
	   Endif
	   
	   // funcao para gerar o pdf 
	   fGeraPdf(AGXK->CLIENTE,cDirS,cDirC,AGXK->LOJA,'1',cTipo)	
	   AGXK->(DbSkip()) 
	  
	EndDo
	
	
	cEmail:=fGestMail(cGestor) 
    //cEmail:="antonio.feitosa@ravaembalagens.com.br"	// TESTE 
    
	// funcao para enviar o email com os pdf's gerados 
	SendAnaCli(cEmail, " ", "Analise Clientes da Agenda "+alltrim(cIdAge) , "", cDirC, _aAnaClix )   
	
	
	// APAGO TODOS ARQUIVOS 
	
	for x:=1 to len(_aAnaClix)
	
	    cFile:=cDirC+_aAnaClix[x]	
		if file(cFile+".pdf") 
		   Ferase(cFile+".pdf")
	    endif
	    
	    if file(cFile+".rel") 
		   Ferase(cFile+".rel")
	    endif
	
	next
  ELSE
      ALERT("Sem Cliente na agenda "+alltrim(cIdAge)+". Sem Envio de Email." )
  ENDIF

else  // via relatorio 

   ValidPerg('FACLIX')
   if !Pergunte('FACLIX',.T.)
      RestArea(aArea)
      return
   endif


	cDirS  := Alltrim(MV_PAR01)
	cDirC := cDirS
    
    IF MV_PAR04=1   // completo( coordenador )
       cTipo:='C'
    ELSEIF MV_PAR04=2   
       cTipo:='S'
    ENDIF 
     
     MsAguarde( { || fGeraPdf(MV_PAR02,cDirS,cDirC,MV_PAR03,'2',cTipo)	 }, "Aguarde. . .", "Gerando Analise de Clientes. . ." )
	
	
endif


RestArea(aArea)
    

Return


**************

Static Function fGeraPdf(cCod,cDirS,cDirC,cLoja,cOpc,cTipo)

**************

Local _cNomeCli:=Alltrim(posicione("SA1",1,xFilial('SA1') + cCod + cLoja,"A1_NREDUZ"))
Local _nX, _XY, _XX, _XZ, _XU
Local cTit
Private nLinha := IncLinha(1)
Private cTitulo
Private nW
Private nMarE := nMarD := nMarS := nMarI := 0.5
Private wnRel := 'ANACLI_'+Alltrim(cCod)+'_'+Alltrim(cLoja)
//Private wnRel := 'ANACLI_'+_cNomeCli
Private cFil  := ""

wnRel += "_"+CriaTrab( nil, .f. )

//Deleta Arquivo caso já exista
If File(cDirC+wnRel+".pdf") 
	Ferase(cDirC+wnRel+".pdf")
EndIf
   
Private oPrinter := FWMSPrinter():New(wnRel,IMP_PDF,.F.,cDirS,.T.,,,,,.F.)
Private m_pag := 0
Private oFont06  := TFontEx():New(oPrinter,"Arial",06,06,.F.,.T.,.F.)// 1
Private oFont06N := TFontEx():New(oPrinter,"Arial",06,06,.T.,.T.,.F.)// 1
Private oFont10  := TFontEx():New(oPrinter,"Arial",08,08,.F.,.T.,.F.)// 1
Private oFont10N := TFontEx():New(oPrinter,"Arial",08,08,.T.,.T.,.F.)// 1
Private oFont12  := TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
Private oFont18N := TFontEx():New(oPrinter,"Arial",17,17,.T.,.T.,.F.)// 12 
Private oFont14  := TFontEx():New(oPrinter,"Arial",13,13,.F.,.T.,.F.)// 10
Private OFONT14N := TFontEx():New(oPrinter,"Arial",13,13,.T.,.T.,.F.)// 12  
Private OFONT12N := TFontEx():New(oPrinter,"Arial",11,11,.T.,.T.,.F.)// 12  

ProcRegua(0) // Regua

cNotas:=fNotas(cCod,cLoja)

//cTitulo := "Analise CLiente  - "+Alltrim(cCod)+'-'+Alltrim(cLoja)
cTitulo := "Analise Cliente  - "+Alltrim(_cNomeCli)
cFil:=alltrim(cTitulo)

oPrinter:nDevice := IMP_PDF
oPrinter:cPathPDF := cDirC  //caminho onde vai ser salvo o pdf
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4)

if cOpc='1' // via agenda 
   oPrinter:SetViewPDF(.F.) 
else // via relatorio 
   oPrinter:SetViewPDF(.T.)   
endif

oPrinter:StartPage()
nVPage := 27.9
nHPage := 21

nHPage -= (nMarE+nMarD)
nVPage -= (nMarS+nMarI)

nLinha  := Cabecalho(cFil)
nLinha  += IncLinha(1) //Incremento uma linha

nLinha := TextoHorz(nLinha, 1,1, "5 Ultimas Notas: "+cNotas,CENTRO,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha
// sac 
if cTipo='C' 
	nLinha := TextoHorz(nLinha, 1,1, "SAC ",CENTRO,,oFont14N:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	fOcorr(cNotas)
	nLinha += IncLinha(1) //Incremento uma linha
Endif
// Financeiro
nLinha := TextoHorz(nLinha, 1,1, "Financeiro ",CENTRO,,oFont14N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
fFinan(cNotas,cCod,cLoja,cTipo)
// PCP/EXPEDICAO/LOGISTICA
if cTipo='C' 
	nLinha := TextoHorz(nLinha, 1,1, "PCP/Expedicao/Logistica ",CENTRO,,oFont14N:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	fPCP(cNotas)
Endif
// TRANSPORTADORA 
nLinha := TextoHorz(nLinha, 1,1, "Transportadora que Transporta para o Municipio do Clinte ",CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
fTRANSP(cCod,cLoja)
// COMERCIAL 
nLinha := TextoHorz(nLinha, 1,1, "Comercial ",CENTRO,,oFont14N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
fCOMER(cNotas,cCod,cLoja,cTipo)
//
oPrinter:EndPage() //Fim do arquivo
oPrinter:Print()   //gera o arquivo pdf
//Sleep(5000)
FreeObj(oPrinter)
oPrinter := Nil

AADD(_aAnaClix, wnRel )


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


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime o cabecalho do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
**********************************
Static Function Cabecalho(cFiltro)
**********************************
m_pag += 1

nLinha := IncLinha(1)
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 2,1, AllTrim(SM0->M0_NOME)+"/"+AllTrim(SM0->M0_FILIAL),ESQUERDA,,oFont12:oFont)
nLinha := TextoHorz(nLinha, 2,2, RptFolha +" " + TRANSFORM(m_pag,'999999')        ,DIREITA,,oFont12:oFont)
nLinha += .3
nLinha := TextoHorz(nLinha, 1,1, cTitulo,CENTRO)
nLinha := TextoHorz(nLinha, 2,1, "SIGA /"+wnrel                                   ,ESQUERDA,,oFont06:oFont)
nLinha := TextoHorz(nLinha, 2,2, RptDtRef +" "+ DTOC(dDataBase)                   ,DIREITA,,oFont12:oFont)
nLinha += .3
nLinha := TextoHorz(nLinha, 2,1, RptHora +" "+time()                              ,ESQUERDA,,oFont12:oFont)
nLinha := TextoHorz(nLinha, 2,2, RptEmiss+" "+DToC(MsDate())                      ,DIREITA,,oFont12:oFont)
nLinha += .5
nLinha := LinhaHorz(nLinha, 1,1)

//Imprime Rodape
LinhaHorz(nVPage+1  , 1,1)
TextoHorz(nVPage+1  , 1,1, if(!Empty(cFiltro),cFiltro,""),ESQUERDA,,oFont12N:oFont)
LinhaHorz(nVPage+1.5, 1,1)

Return nLinha


**************************

Static Function SendAnaCli(cMailTo,cCopia,cAssun,cCorpo,cDir,cAnexo)

**************************

Local cEmailCc := cCopia

Local cUser	  := Alltrim(GetMV( "MV_RELACNT" ))
Local cPass   := Alltrim(GetMV( "MV_RELPSW"  ))
Local cServer := Alltrim(GetMV( "MV_RELSERV" ))
Local cFrom		:= GetMV( "MV_RELACNT" )
//Local cFrom	  := "ravasiga@ravaembalagens.com.br"


Local xRet
Local oServer, oMessage
      
oMessage := TMailMessage():New()
oMessage:Clear()
   
oMessage:cDate := cValToChar( Date() )
oMessage:cFrom := cFrom
oMessage:cTo := cMailTo
oMessage:cSubject := cAssun
oMessage:cBody := cCorpo
// varios anexos 
for x:=1 to len(cAnexo)

    cFile:=cDir+cAnexo[x]
	xRet := oMessage:AttachFile( cFile+".pdf" )
	if xRet < 0
	    cMsg := "Could not attach file " + cFile
	    conout( cMsg )
	    return
	endif  
	
next

//Sleep(5000)
oServer := tMailManager():New()

//oServer:SetUseSSL( .T. )
     
xRet := oServer:Init( "", cServer, cUser, cPass, 0, 25 )
if xRet != 0
   cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif
   
xRet := oServer:SetSMTPTimeout( 60 )
if xRet != 0
   cMsg := "Could not set " + cProtocol + " timeout to " + cValToChar( nTimeout )
   conout( cMsg )
   return
endif
   
xRet := oServer:SMTPConnect()
if xRet <> 0
   cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif
   
xRet := oServer:SmtpAuth( cUser, cPass )
if xRet <> 0
   cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   oServer:SMTPDisconnect()
   return
endif
   
xRet := oMessage:Send( oServer )
if xRet <> 0
   cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif
   
xRet := oServer:SMTPDisconnect()
if xRet <> 0
   cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif



return


*************

STATIC FUNCTION FNOTAS(cCod,cLoja)

*************
local cRet:=''

/*
cQuery:="SELECT  TOP 5  F2_DOC FROM "+RetSqlName("SF2")+" F2 WITH (NOLOCK) "
cQuery+="WHERE F2_FILIAL='"+xfilial('SF2')+"' AND F2_CLIENTE='"+cCod+"' AND F2_LOJA='"+cLoja+"' AND F2_DUPL<>'' "
cQuery+="AND F2_SERIE='0' AND F2.D_E_L_E_T_='' ORDER BY F2_EMISSAO DESC "
*/

cQuery:="SELECT "
cQuery+="TOP 5 F2_FILIAL+F2_DOC "
cQuery+="FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2 ,"+RetSqlName("SC6")+" SC6,"+RetSqlName("SC5")+" SC5 , "+RetSqlName("SB1")+" SB1 "
cQuery+="WHERE "
//cQuery+="F2_FILIAL='"+xFilial('SF2')+"' "
cQuery+="F2_FILIAL=D2_FILIAL "
cQuery+="AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE "
cQuery+="AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA "
cQuery+="AND D2_COD=B1_COD "
cQuery+="AND F2_CLIENTE='"+cCod+"' AND F2_LOJA='"+cLoja+"' "
cQuery+="AND C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV  "
cQuery+="AND C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery+="AND D2_TIPO = 'N' "
cQuery+="AND D2_TP != 'AP'  "
cQuery+="AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQuery+="AND SB1.B1_SETOR <> '39' "
cQuery+="AND SF2.D_E_L_E_T_='' "
cQuery+="AND SD2.D_E_L_E_T_='' "
cQuery+="AND SC6.D_E_L_E_T_='' "
cQuery+="AND SC5.D_E_L_E_T_='' "
cQuery+="GROUP BY F2_DOC,F2_EMISSAO "
cQuery+="ORDER BY  F2_EMISSAO DESC "


If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf
TCQUERY cQuery NEW ALIAS "XUXD"
	
XUXD->(DbGoTop())

WHILE XUXD->(!EOF())

   cRet+="'"+XUXD->F2_DOC+"',"
  
   XUXD->(DbSkip())

ENDDO		

XUXD->(DbCloseArea())

IF !EMPTY(cRet)
   cRet := Substr(cRet,1,Len(cRet)-1)
ELSE
   cRet :="'"+' '+"'"
ENDIF


RETURN cRet


***************

STATIC FUNCTION fOcorr(cNotas)

***************

/*
cQuery:="Select ZUD_DTRESO, ZUD_HRRESO, ZUD_CODIGO, UD_CODIGO, ZUD_ITEM, UD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_OBSRES, UD_OBS, UD_JUSTIFI "
cQuery+=",ZUD_OBSENC, UD_OBSENC,UD_DTINCLU, UD_HRINCLU ,ZUD_DTENV, ZUD_HRENV, ZUD_NRENV, UD_DTENVIO, UD_HRENVIO "
cQuery+=",ZUD_DTSOL, ZUD_DTRESP, ZUD_HRRESP, UD_DATA, UD_DTRESP, UD_HRRESP ,UD_OPERADO,UD_N1,UD_N2,UD_N3,UD_N4,UD_N5, "
cQuery+="UD_RESOLVI, ZUD_RESOLV, UD_STATUS, UD_OBS,UC_DATA, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, A1_COD,A1_LOJA, "
cQuery+="A1_NREDUZ, A1_END, A1_MUN, A1_TEL, A1_EST "
cQuery+="FROM  "+RetSqlName("ZUD")+" ZUD, "+RetSqlName("SUD")+" SUD, "+RetSqlName("SUC")+" SUC, "+RetSqlName("SA1")+" SA1 "
cQuery+="WHERE  UD_OPERADO <> '' " //AND UD_STATUS<>'2' "
cQuery+="AND UC_NFISCAL IN ("+cNotas+") "
cQuery+="AND UC_CODIGO = UD_CODIGO "
cQuery+="AND UC_CODIGO = ZUD_CODIGO "
cQuery+="AND UD_CODIGO = ZUD_CODIGO "
cQuery+="AND UD_ITEM = ZUD_ITEM "
cQuery+="AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "
cQuery+="AND SA1.D_E_L_E_T_ = ''   "
cQuery+="AND ZUD.D_E_L_E_T_ = ''   AND ZUD.ZUD_FILIAL = '"+XFILIAL('ZUD')+"' "
cQuery+="AND SUD.D_E_L_E_T_ = ''   AND SUD.UD_FILIAL = '"+XFILIAL('SUD')+"' " 
cQuery+="AND SUC.D_E_L_E_T_ = ''   AND SUC.UC_FILIAL = '"+XFILIAL('SUC')+"' " 
cQuery+="ORDER BY UC_NFISCAL,ZUD_CODIGO,ZUD_ITEM, ZUD.R_E_C_N_O_ , ZUD_DTENV, ZUD_NRENV "
*/

/// CABECALHO
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 11,1, "Nota"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 11,2, "Atend.-Item" ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 11,3, "Motivo" ,ESQUERDA)
nLinha := TextoHorz(nLinha, 11,7, "Envios" ,ESQUERDA)
nLinha := TextoHorz(nLinha, 11,8, "Solucao" ,ESQUERDA)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

ANotas:=Campos(cNotas,",",.T.)
FOR X:=1 TO LEN(ANotas) 

	cQuery:="Select F2_DOC,ZUD_DTRESO, ZUD_HRRESO, ZUD_CODIGO, UD_CODIGO, ZUD_ITEM, UD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_OBSRES, UD_OBS, UD_JUSTIFI "
	cQuery+=",ZUD_OBSENC, UD_OBSENC,UD_DTINCLU, UD_HRINCLU ,ZUD_DTENV, ZUD_HRENV, ZUD_NRENV, UD_DTENVIO, UD_HRENVIO "
	cQuery+=",ZUD_DTSOL, ZUD_DTRESP, ZUD_HRRESP, UD_DATA, UD_DTRESP, UD_HRRESP ,UD_OPERADO,UD_N1,UD_N2,UD_N3,UD_N4,UD_N5, "
	cQuery+="UD_RESOLVI, ZUD_RESOLV, UD_STATUS, UD_OBS,UC_DATA, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE "
	cQuery+="FROM  "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) "
	cQuery+="JOIN "+RetSqlName("SUC")+" SUC WITH (NOLOCK) ON F2_DOC+F2_SERIE=UC_NFISCAL+UC_SERINF AND  RTRIM(UC_CHAVE) = RTRIM(F2_CLIENTE+F2_LOJA)  AND SUC.D_E_L_E_T_ = ''   "
	cQuery+="JOIN "+RetSqlName("SUD")+" SUD WITH (NOLOCK) ON UC_CODIGO = UD_CODIGO AND UD_OPERADO <> ''  AND SUD.D_E_L_E_T_ = ''  "
	cQuery+="JOIN "+RetSqlName("ZUD")+" ZUD WITH (NOLOCK) ON UD_CODIGO = ZUD_CODIGO AND  UD_ITEM = ZUD_ITEM AND  ZUD.D_E_L_E_T_ = '' "
	cQuery+="WHERE  "
	cQuery+="F2_SERIE='0' "
	cQuery+="AND F2_FILIAL+F2_DOC IN ("+ANotas[X]+") "
	cQuery+="AND SF2.D_E_L_E_T_ = ''   "
	cQuery+="ORDER BY F2_DOC DESC ,ZUD_CODIGO,ZUD_ITEM, ZUD.R_E_C_N_O_ , ZUD_DTENV, ZUD_NRENV "
	
	If Select("XUXD") > 0
		DbSelectArea("XUXD")
		XUXD->(DbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "XUXD"
		
	
	XUXD->(DbGoTop())
	
    IF XUXD->(!EOF())
	
		DO WHILE XUXD->(!EOF())
		   
		   if nLinha+1.5 >= nVPage           
		      oPrinter:EndPage()
		      oPrinter:StartPage()          
		      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
		      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Ocorrencia do SAC"  ,CENTRO,,oFont10N:oFont)
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
			  nLinha := TextoHorz(nLinha, 11,1, "Nota"  ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 11,2, "Atend.-Item" ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 11,3, "Motivo" ,ESQUERDA)
			  nLinha := TextoHorz(nLinha, 11,7, "Envios" ,ESQUERDA)
			  nLinha := TextoHorz(nLinha, 11,8, "Solucao" ,ESQUERDA)
			  nLinha += IncLinha(1) //Incremento uma linha
			  nLinha := LinhaHorz(nLinha, 1,1)	
		   endif
		
			nLinha := TextoHorz(nLinha, 11,1, XUXD->UC_NFISCAL            ,ESQUERDA,,oFont10:oFont)
			nLinha := TextoHorz(nLinha, 11,2, XUXD->UD_CODIGO+'-'+XUXD->ZUD_ITEM              ,ESQUERDA,,oFont10:oFont)
			nLinha := TextoHorz(nLinha, 11,3, ALLTRIM(XUXD->ZUD_PROBLE)   ,ESQUERDA,7,oFont06:oFont)
			nLinha := TextoHorz(nLinha, 11,7, "Nr: " + Alltrim(Str(XUXD->ZUD_NRENV)) + " Dt: " + ALLTRIM(Dtoc(STOD(XUXD->ZUD_DTENV))) ,ESQUERDA,6,oFont06:oFont)
			nLinha := TextoHorz(nLinha, 11,8,"SAC: " + Alltrim(XUXD->ZUD_OBSATE) ,ESQUERDA,8,oFont06:oFont)
			IF LEN(Alltrim(XUXD->ZUD_OBSATE))>82
				nLinha += IncLinha(2) //Incremento uma linha
			ELSE
				nLinha += IncLinha(1) //Incremento uma linha
			ENDIF
			nLinha := TextoHorz(nLinha, 11,8,"Resposta: " + Alltrim(XUXD->ZUD_OBSRES) ,ESQUERDA,8,oFont06:oFont)
			IF LEN(Alltrim(XUXD->ZUD_OBSRES))>82
				nLinha += IncLinha(2) //Incremento uma linha
			ELSE
				nLinha += IncLinha(1) //Incremento uma linha
			ENDIF
			
			nLinha := TextoHorz(nLinha, 11,8, "Data p/ Solução: " + DtoC(STOD(XUXD->ZUD_DTSOL))+' - Dt.Respondeu: ' + Dtoc(STOD(XUXD->ZUD_DTRESP)) +' - Hr.Respondeu: ' + XUXD->ZUD_HRRESP ,ESQUERDA,8,oFont06:oFont)
			nLinha += IncLinha(0.5) //Incremento uma linha
			If XUXD->UD_STATUS = '2'
				nLinha := TextoHorz(nLinha, 11,8,"Encerrado pelo SAC: " + Dtoc(STOD(XUXD->ZUD_DTRESO)) + " Hr: " + XUXD->ZUD_HRRESO ,ESQUERDA,8,oFont06N:oFont)
				nLinha += IncLinha(1) //Incremento uma linha
			Endif
			  
			   XUXD->(DbSkip())
		
		ENDDO
		
	ELSE
		   
		   if nLinha+1.5 >= nVPage           
		      oPrinter:EndPage()
		      oPrinter:StartPage()          
		      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
		      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Ocorrencia do SAC"  ,CENTRO,,oFont10N:oFont)
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
			  nLinha := TextoHorz(nLinha, 11,1, "Nota"  ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 11,2, "Atend.-Item" ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 11,3, "Motivo" ,ESQUERDA)
			  nLinha := TextoHorz(nLinha, 11,7, "Envios" ,ESQUERDA)
			  nLinha := TextoHorz(nLinha, 11,8, "Solucao" ,ESQUERDA)
			  nLinha += IncLinha(1) //Incremento uma linha
			  nLinha := LinhaHorz(nLinha, 1,1)	
		   endif
           
           nLinha := TextoHorz(nLinha, 11,1, ALLTRIM(strTRan(aNotas[X],"'"," "))   ,ESQUERDA,7,oFont10:oFont)
           nLinha := TextoHorz(nLinha, 11,2, "Sem Ocorrencia"   ,ESQUERDA,7,oFont10N:oFont)
	       nLinha += IncLinha(1) //Incremento uma linha		   
		
	ENDIF

    XUXD->(DbCloseArea())

NEXT

RETURN 


***************

STATIC FUNCTION fFinan(cNotas,cCod,cLoja,cTipo)

***************
// PRAZO DE COMPRA / PRAZO MEDIO 
fPRZ(cNotas)
// TITULOS EM ABERTO 
fABERTO(cCod,cLoja)
// TITULOS recebidos
fRECEB(cNotas)
// LIMITE DE CREDITO 
if cTipo='C'
   fLC(cCod,cLoja)
Endif
// Pedidos em Analise de Credito 
if cTipo='C'
   fPedAna(cCod,cLoja)
Endif

RETURN 

***************

STATIC FUNCTION fPRZ(cNotas)

***************

cQuery:="SELECT DISTINCT F2_DOC,E4_COND,E4_PRZMED,F2_EMISSAO "
cQuery+="FROM "+RetSqlName("SF2")+" F2 WITH (NOLOCK) ,"+RetSqlName("SE4")+" E4 WITH (NOLOCK) "
cQuery+="WHERE F2_FILIAL+F2_DOC IN ("+cNotas+") "
cQuery+="AND F2_COND=E4_CODIGO "
cQuery+="AND F2.D_E_L_E_T_='' "
cQuery+="AND E4.D_E_L_E_T_='' "
cQuery+="ORDER BY F2_DOC DESC "

If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Prazo de Compra"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 4,1, "Nota"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 4,2, "Dt Emissao"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 4,3, "Prazo de Compra"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 4,4, "Prazo Medio" ,ESQUERDA,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

XUXD->(DbGoTop())

DO WHILE XUXD->(!EOF())

   if nLinha+1.5 >= nVPage           
      oPrinter:EndPage()
      oPrinter:StartPage()          
      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Prazo de Compra"  ,CENTRO,,oFont10N:oFont)
      nLinha += IncLinha(1) //Incremento uma linha
      nLinha := LinhaHorz(nLinha, 1,1)
	  nLinha := TextoHorz(nLinha, 4,1, "Nota"  ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 4,2, "Dt Emissao"  ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 4,3, "Prazo de Compra"  ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 4,4, "Prazo Medio" ,ESQUERDA,,oFont10:oFont)
	  nLinha += IncLinha(1) //Incremento uma linha
	  nLinha := LinhaHorz(nLinha, 1,1)		
   endif

   nLinha := TextoHorz(nLinha, 4,1, ALLTRIM(XUXD->F2_DOC)  ,ESQUERDA,,oFont10:oFont)   
   nLinha := TextoHorz(nLinha, 4,2, DTOC(STOD(XUXD->F2_EMISSAO))  ,ESQUERDA,,oFont10:oFont)
   nLinha := TextoHorz(nLinha, 4,3, strTRan(ALLTRIM(XUXD->E4_COND),",","/")  ,ESQUERDA,,oFont10:oFont)
   nLinha := TextoHorz(nLinha, 4,4, CVALTOCHAR(GetPrzMed(XUXD->E4_COND)) ,ESQUERDA,,oFont10:oFont)
   nLinha += IncLinha(1) //Incremento uma linha

   XUXD->(DbSkip())

ENDDO

XUXD->(DbCLOSEAREA())

 
Return  


***************

STATIC FUNCTION fABERTO(cCod,cLoja)

***************

cQuery:="SELECT "
cQuery+="E1_NUM NOTA,E1_PREFIXO SERIE,E1_PARCELA PARCELA, "
cQuery+="E1_EMISSAO,E1_VENCREA,E1_BAIXA,E1_VALOR,E1_SALDO, "
cQuery+="ATRASO=CAST(CONVERT(DATETIME,'"+DtoS(dDataBase)+"')-CONVERT(DATETIME,E1_VENCREA) AS INTEGER) "
cQuery+="FROM "+RetSqlName("SE1")+" SE1 WITH (NOLOCK) "
cQuery+="WHERE "
//cQuery+="E1_FILIAL='"+XFILIAL('SE1')+"' "
cQuery+="E1_CLIENTE='"+cCod+"' AND E1_LOJA='"+cLoja+"' "
cQuery+="AND E1_TIPO NOT IN ('NCC','RA') AND E1_SALDO>0 "
cQuery+="AND SE1.D_E_L_E_T_='' "
cQuery+="ORDER BY E1_VENCREA,E1_NUM ,E1_PARCELA,E1_PREFIXO "

If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Titulos em Aberto"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 7,1, "Titulo"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,2, "Parcela"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,3, "Dt Emissao" ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,4, "Vencto Real" ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,5, "Valor" ,DIREITA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,6, "Saldo" ,DIREITA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,7, "Atraso" ,DIREITA,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

XUXD->(DbGoTop())

NTOTABER:=0

DO WHILE XUXD->(!EOF())
   
   if nLinha+1.5 >= nVPage           
      oPrinter:EndPage()
      oPrinter:StartPage()          
      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Titulos em Aberto"  ,CENTRO,,oFont10N:oFont)
      nLinha += IncLinha(1) //Incremento uma linha
      nLinha := LinhaHorz(nLinha, 1,1)
      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
	  nLinha := TextoHorz(nLinha, 7,1, "Titulo"  ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 7,2, "Parcela"  ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 7,3, "Dt Emissao" ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 7,4, "Vencto Real" ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 7,5, "Valor" ,DIREITA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 7,6, "Saldo" ,DIREITA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 7,7, "Atraso" ,DIREITA,,oFont10:oFont)
	  nLinha += IncLinha(1) //Incremento uma linha
	  nLinha := LinhaHorz(nLinha, 1,1)		
   endif
	
	nLinha := TextoHorz(nLinha, 7,1, XUXD->NOTA+'-'+XUXD->SERIE  ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 7,2, XUXD->PARCELA  ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 7,3, DTOC(STOD(XUXD->E1_EMISSAO)) ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 7,4, DTOC(STOD(XUXD->E1_VENCREA)) ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 7,5, TRANSFORM(XUXD->E1_VALOR,PesqPict("SE1","E1_VALOR")) ,DIREITA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 7,6, TRANSFORM(XUXD->E1_SALDO,PesqPict("SE1","E1_SALDO")) ,DIREITA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 7,7, CVALTOCHAR(XUXD->ATRASO) ,DIREITA,,oFont10:oFont)
	
    nLinha += IncLinha(1) //Incremento uma linha

    NTOTABER+=XUXD->E1_SALDO
   XUXD->(DbSkip())

ENDDO

XUXD->(DbCLOSEAREA())

 
Return  



***************

STATIC FUNCTION fRECEB(cNotas)

***************

cQuery:="SELECT "
cQuery+="E1_NUM NOTA,E1_PREFIXO SERIE,E1_PARCELA PARCELA, "
cQuery+="E1_EMISSAO,E1_VENCREA,E1_BAIXA,E1_VALOR,E1_SALDO, "
cQuery+="ATRASO=CAST(CONVERT(DATETIME,E1_BAIXA)-CONVERT(DATETIME,E1_VENCREA) AS INTEGER) "
cQuery+="FROM "+RetSqlName("SE1")+" SE1 WITH (NOLOCK) "
cQuery+="WHERE "
//cQuery+="E1_FILIAL='"+XFILIAL('SE1')+"' "
cQuery+="E1_FILIAL+E1_NUM IN ("+cNotas+") "
cQuery+="AND E1_TIPO NOT IN ('NCC','RA') AND E1_SALDO=0 AND E1_BAIXA<>'' "
cQuery+="AND SE1.D_E_L_E_T_='' "
cQuery+="ORDER BY E1_VENCREA,E1_NUM,E1_PARCELA,E1_PREFIXO "

If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Titulos Recebidos"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 8,1, "Titulo"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 8,2, "Parcela"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 8,3, "Dt Emissao" ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 8,4, "Vencto Real" ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 8,5, "Dt Recebimento" ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 8,6, "Valor" ,DIREITA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 8,7, "Saldo" ,DIREITA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 8,8, "Atraso" ,DIREITA,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

XUXD->(DbGoTop())

DO WHILE XUXD->(!EOF())

	if nLinha+1.5 >= nVPage           
      oPrinter:EndPage()
      oPrinter:StartPage()          
      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
      nLinha := TextoHorz(nLinha, 1,1, "Continuacao de  Titulos Recebidos"  ,CENTRO,,oFont10N:oFont)
      nLinha += IncLinha(1) //Incremento uma linha
      nLinha := LinhaHorz(nLinha, 1,1)
	  nLinha := TextoHorz(nLinha, 8,1, "Titulo"  ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 8,2, "Parcela"  ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 8,3, "Dt Emissao" ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 8,4, "Vencto Real" ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 8,5, "Dt Recebimento" ,ESQUERDA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 8,6, "Valor" ,DIREITA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 8,7, "Saldo" ,DIREITA,,oFont10:oFont)
	  nLinha := TextoHorz(nLinha, 8,8, "Atraso" ,DIREITA,,oFont10:oFont)
	  nLinha += IncLinha(1) //Incremento uma linha
	  nLinha := LinhaHorz(nLinha, 1,1)	
    endif

	nLinha := TextoHorz(nLinha, 8,1, XUXD->NOTA+'-'+XUXD->SERIE  ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 8,2, XUXD->PARCELA  ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 8,3, DTOC(STOD(XUXD->E1_EMISSAO)) ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 8,4, DTOC(STOD(XUXD->E1_VENCREA)) ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 8,5, DTOC(STOD(XUXD->E1_BAIXA)) ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 8,6, TRANSFORM(XUXD->E1_VALOR,PesqPict("SE1","E1_VALOR")) ,DIREITA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 8,7, TRANSFORM(XUXD->E1_SALDO,PesqPict("SE1","E1_SALDO")) ,DIREITA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 8,8, CVALTOCHAR(XUXD->ATRASO) ,DIREITA,,oFont10:oFont)
	
    nLinha += IncLinha(1) //Incremento uma linha

   XUXD->(DbSkip())

ENDDO

XUXD->(DbCLOSEAREA())

 
Return  


***************

STATIC FUNCTION fLC(cCod,cLoja)

***************

/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Limite de Credito"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 3,1, "Limite de Credito( LC )"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 3,2, "Utilizacao do LC"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 3,3, "Saldo do LC"  ,ESQUERDA,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

if nLinha+1.5 >= nVPage
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLinha  := Cabecalho(cFil)+IncLinha(1)
	nLinha := TextoHorz(nLinha, 1,1, "Continuacao Limite de Credido"  ,CENTRO,,oFont10N:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
    nLinha := TextoHorz(nLinha, 3,1, "Limite de Credito( LC )"  ,ESQUERDA,,oFont10:oFont)
    nLinha := TextoHorz(nLinha, 3,2, "Utilizacao do LC"  ,ESQUERDA,,oFont10:oFont)
    nLinha := TextoHorz(nLinha, 3,3, "Saldo do LC"  ,ESQUERDA,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
endif


// limite de credito do cliente 
nLC         :=Posicione("SA1",1,xFilial("SA1")+cCod + cLoja, "A1_LC") 
// saldo Pedido Liberado 
nSaldoPL    := fSaldoPL(cCod,cLoja)
// utilizacao do limite de credito ( TITLUOS EM ABERTO + PEDIDO LIBERADO)
nUtiLC:= NTOTABER + nSaldoPL
// utilizacao do limite de credito 
nSaldoLC	:= nLC - nUtiLC

nLinha := TextoHorz(nLinha, 3,1, TRANSFORM(nLC,PesqPict("SA1","A1_LC"))  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 3,2, TRANSFORM(nUtiLC,PesqPict("SA1","A1_LC")),ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 3,3, TRANSFORM(nSaldoLC,PesqPict("SA1","A1_LC")),ESQUERDA,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha

Return 

***************

Static Function fSaldoPL(cCod,cLoja)

***************

Local cQuery	:= ''
Local nRet		:= 0

cQuery := "SELECT "
cQuery += "isnull(sum(C9_QTDLIB*C9_PRCVEN),0) VTOTAL "
cQuery += "FROM " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), "
cQuery += " " + RetSqlName("SC9") + " SC9 WITH (NOLOCK), " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SC6.C6_FILIAL = SC9.C9_FILIAL AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL AND "
cQuery += "SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED IN( ' ') and SC9.C9_BLEST != '10' AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "A1_COD='"+cCod+"' AND A1_LOJA='"+cLoja+"' AND "
cQuery += "SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
cQuery += "SC5.D_E_L_E_T_ = '' AND "
cQuery += "SC6.D_E_L_E_T_ = '' AND "
cQuery += "SC9.D_E_L_E_T_ = '' AND "
cQuery += "SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "


If Select("TMP") > 0
	DbSelectArea("TMP")
	TMP->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

nRet := TMP->VTOTAL

Return nRet

***************

STATIC FUNCTION fPedAna(cCod,cLoja)

***************

cQuery := "SELECT "
cQuery += "C5_NUM,C5_EMISSAO, "
cQuery += "isnull(sum(C9_QTDLIB*C9_PRCVEN),0) VTOTAL "
cQuery += "FROM " + RetSqlName("SB1") + " SB1 WITH (NOLOCK), " + RetSqlName("SC5") + " SC5 WITH (NOLOCK), " + RetSqlName("SC6") + " SC6 WITH (NOLOCK), "
cQuery += " " + RetSqlName("SC9") + " SC9 WITH (NOLOCK), " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SC6.C6_FILIAL = SC9.C9_FILIAL AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL AND "
cQuery += "SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED NOT IN( '','10') and SC9.C9_BLEST != '10' AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "A1_COD='"+cCod+"' AND A1_LOJA='"+cLoja+"' AND "
cQuery += "SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND "
cQuery += "SC5.D_E_L_E_T_ = '' AND "
cQuery += "SC6.D_E_L_E_T_ = '' AND "
cQuery += "SC9.D_E_L_E_T_ = '' AND "
cQuery += "SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = '' "
cQuery += "GROUP BY C5_NUM,C5_EMISSAO "


If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Pedidos em Analise de Credito"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)



XUXD->(DbGoTop())

IF XUXD->(!EOF())

	/// CABECALHO
	nLinha := TextoHorz(nLinha, 6,1, "Pedido"  ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,2, "Dt Emissao"  ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,3, "Valor " ,DIREITA,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
	
	DO WHILE XUXD->(!EOF())
	
		if nLinha+1.5 >= nVPage           
	      oPrinter:EndPage()
	      oPrinter:StartPage()          
	      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
	      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Pedidos em Analise de Credito"  ,CENTRO,,oFont10N:oFont)
	      nLinha += IncLinha(1) //Incremento uma linha
	      nLinha := LinhaHorz(nLinha, 1,1)
	      nLinha := TextoHorz(nLinha, 6,1, "Pedido"  ,ESQUERDA,,oFont10:oFont)
	      nLinha := TextoHorz(nLinha, 6,2, "Dt Emissao"  ,ESQUERDA,,oFont10:oFont)
	      nLinha := TextoHorz(nLinha, 6,3, "Valor " ,DIREITA,,oFont10:oFont)
		  nLinha += IncLinha(1) //Incremento uma linha
		  nLinha := LinhaHorz(nLinha, 1,1)	
	    endif
	
		nLinha := TextoHorz(nLinha, 6,1, XUXD->C5_NUM  ,ESQUERDA,,oFont10:oFont)
		nLinha := TextoHorz(nLinha, 6,2, DTOC(STOD(XUXD->C5_EMISSAO))  ,ESQUERDA,,oFont10:oFont)
		nLinha := TextoHorz(nLinha, 6,3, TRANSFORM(XUXD->VTOTAL,PesqPict("SC9","C9_PRCVEN")) ,DIREITA,,oFont10:oFont)
	
		
	    nLinha += IncLinha(1) //Incremento uma linha
	
	   XUXD->(DbSkip())
	
	ENDDO
ELSE

		if nLinha+1.5 >= nVPage           
	      oPrinter:EndPage()
	      oPrinter:StartPage()          
	      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
	      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Pedidos em Analise de Credito"  ,CENTRO,,oFont10N:oFont)
	      nLinha += IncLinha(1) //Incremento uma linha
	      nLinha := LinhaHorz(nLinha, 1,1)
	    endif
	
		nLinha := TextoHorz(nLinha, 1,1, "Sem Pedidos"  ,CENTRO,,oFont10N:oFont)
	    nLinha += IncLinha(1) //Incremento uma linha


ENDIF

XUXD->(DbCLOSEAREA())

 
Return  

***************

STATIC FUNCTION fPCP(cNotas)

***************

cQuery := "SELECT DISTINCT C5_NUM PEDIDO,C5_EMISSAO DTPED,F2_DOC,F2_EMISSAO DTFAT,F2_DTEXP DTEXP, "
cQuery += "F2_REALCHG REALCHG, "
cQuery += "PRZ_REAL=CASE WHEN F2_REALCHG='' THEN 0 ELSE  CAST(CONVERT(DATETIME,F2_REALCHG)-CONVERT(DATETIME,F2_DTEXP) AS INTEGER) END "
cQuery += "FROM " + RetSqlName("SF2") + " SF2, " + RetSqlName("SD2") + " SD2 ," + RetSqlName("SC6") + " SC6," + RetSqlName("SC5") + " SC5 "
cQuery += "WHERE "
cQuery += "F2_FILIAL=D2_FILIAL "
cQuery += "AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE "
cQuery += "AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA "
cQuery += "AND F2_FILIAL+F2_DOC IN ("+cNotas+") "
cQuery += "AND F2_SERIE<>'' "
cQuery += "AND C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV  "
cQuery += "AND C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "AND SF2.D_E_L_E_T_='' "
cQuery += "AND SD2.D_E_L_E_T_='' "
cQuery += "AND SC6.D_E_L_E_T_='' "
cQuery += "AND SC5.D_E_L_E_T_='' "
cQuery += "ORDER BY  F2_DOC DESC "

If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 7,1, "Pedido"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,2, "Dt Pedido"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,3, "Nota"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,4, "Dt Nota"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,5, "Dt Expedicao"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,6, "Dt Chegada"  ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 7,7, "Prazo Chegada"  ,ESQUERDA,,oFont10:oFont)
nLinha += IncLinha(0.5) //Incremento uma linha
nLinha := TextoHorz(nLinha, 7,7, "(Dias Uteis)"  ,ESQUERDA,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

XUXD->(DbGoTop())


DO WHILE XUXD->(!EOF())
	
		if nLinha+1.5 >= nVPage           
	      oPrinter:EndPage()
	      oPrinter:StartPage()          
	      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
	      nLinha := TextoHorz(nLinha, 1,1, "Continuacao PCP/Expedicao"  ,CENTRO,,oFont10N:oFont)
	      nLinha += IncLinha(1) //Incremento uma linha
	      nLinha := LinhaHorz(nLinha, 1,1)
		  nLinha := TextoHorz(nLinha, 7,1, "Pedido"  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,2, "Dt Pedido"  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,3, "Nota"  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,4, "Dt Nota"  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,5, "Dt Expedicao"  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,6, "Dt Chegada"  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,7, "Prazo Chegada"  ,ESQUERDA,,oFont10:oFont)
          nLinha += IncLinha(0.5) //Incremento uma linha
          nLinha := TextoHorz(nLinha, 7,7, "(Dias Uteis)"  ,ESQUERDA,,oFont10:oFont)
		  nLinha += IncLinha(1) //Incremento uma linha
		  nLinha := LinhaHorz(nLinha, 1,1)	
	    endif

          nLinha := TextoHorz(nLinha, 7,1, XUXD->PEDIDO  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,2, DTOC(STOD(XUXD->DTPED))  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,3, XUXD->F2_DOC  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,4, DTOC(STOD(XUXD->DTFAT))  ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 7,5, DTOC(STOD(XUXD->DTEXP))  ,ESQUERDA,,oFont10:oFont)		
          nLinha := TextoHorz(nLinha, 7,6, DTOC(STOD(XUXD->REALCHG))  ,ESQUERDA,,oFont10:oFont)
          
          nPrzU:=DiasUteis(STOD(XUXD->DTEXP),STOD(XUXD->REALCHG))
          
          nLinha := TextoHorz(nLinha, 7,7, CVALTOCHAR(nPrzU)  ,ESQUERDA,,oFont10:oFont)

 	      nLinha += IncLinha(1) //Incremento uma linha
	
	   XUXD->(DbSkip())
	
ENDDO

XUXD->(DbCLOSEAREA())

 
Return  


***************

STATIC FUNCTION fTRANSP(cCod,cLoja)

***************

cQuery := "SELECT A4_COD,A4_NOME,A1_EST,A1_MUN,ZZ_PRZENT FROM " + RetSqlName("SZZ") + " SZZ, " + RetSqlName("SA1") + " SA1," + RetSqlName("SA4") + " SA4 "
cQuery += "WHERE "
cQuery += "ZZ_FILIAL='"+xfilial('SZZ')+"' "
cQuery += "AND ZZ_LOCAL=A1_COD_MUN AND ZZ_UF=A1_EST "
cQuery += "AND A1_COD='"+cCod+"' AND A1_LOJA='"+cLoja+"' "
cQuery += "AND ZZ_ATIVO<>'N' "
cQuery += "AND A4_COD=ZZ_TRANSP AND A4_ATIVO<>'N' "
cQuery += "AND SZZ.D_E_L_E_T_='' "
cQuery += "AND SA1.D_E_L_E_T_='' "
cQuery += "AND SA4.D_E_L_E_T_='' "


If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 5,1, "Codigo"     ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 5,2, "Nome"    ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 5,3, "Municipio"     ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 5,4, "UF"     ,ESQUERDA,,oFont10:oFont)
nLinha := TextoHorz(nLinha, 5,5, "Prazo Entrega"  ,ESQUERDA,,oFont10:oFont) 	      
nLinha += IncLinha(0.5) //Incremento uma linha
nLinha := TextoHorz(nLinha, 5,5, "(Dias Uteis)"  ,ESQUERDA,,oFont10:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)


XUXD->(DbGoTop())

DO WHILE XUXD->(!EOF())
	
		if nLinha+1.5 >= nVPage           
	      oPrinter:EndPage()
	      oPrinter:StartPage()          
	      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
	      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Transportadora que Transporta para o Municipio do Clinte "  ,CENTRO,,oFont10N:oFont)
	      nLinha += IncLinha(1) //Incremento uma linha
	      nLinha := LinhaHorz(nLinha, 1,1)
          nLinha := TextoHorz(nLinha, 5,1, "Codigo"     ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,2, "Nome"    ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,3, "Municipio"     ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,4, "UF"     ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,5, "Prazo Entrega"  ,ESQUERDA,,oFont10:oFont) 	      
          nLinha += IncLinha(0.5) //Incremento uma linha
          nLinha := TextoHorz(nLinha, 5,5, "(Dias Uteis)"  ,ESQUERDA,,oFont10:oFont)
	      nLinha += IncLinha(1) //Incremento uma linha
	      nLinha := LinhaHorz(nLinha, 1,1)
	    endif

          nLinha := TextoHorz(nLinha, 5,1, XUXD->A4_COD     ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,2, XUXD->A4_NOME    ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,3, XUXD->A1_MUN     ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,4, XUXD->A1_EST     ,ESQUERDA,,oFont10:oFont)
          nLinha := TextoHorz(nLinha, 5,5, CVALTOCHAR(XUXD->ZZ_PRZENT)  ,ESQUERDA,,oFont10:oFont) 	      
 	      nLinha += IncLinha(1) //Incremento uma linha
	
	   XUXD->(DbSkip())
	
ENDDO

XUXD->(DbCLOSEAREA())

 
Return  


***************

STATIC FUNCTION fCOMER(cNotas,cCod,cLoja,cTipo)

***************
// AMOSTRA 
If cTipo='C'
   fAmostra(cCod,cLoja)
Endif
// ORCAMENTO 
If cTipo='C'
   fORCA(cCod,cLoja)
Endif
// HISTORICO DE COMPRA 
fHistCom(cNotas)
// agenda de viagem 
If cTipo='C'
   fAgeVi(cCod,cLoja)
Endif
// bonificacao 
If cTipo='C'
   fBoni(cCod,cLoja)
Endif

Return 

***************

STATIC FUNCTION fAmostra(cCod,cLoja)

***************

cQuery := "SELECT "
cQuery += "D2_COD,D2_EMISSAO EMISSAO "
cQuery += "FROM " + RetSqlName("SD2") + "  SD2, " + RetSqlName("SB1") + " SB1 "
cQuery += "WHERE "
cQuery += "D2_DOC IN(SELECT  TOP 5 D2_DOC "
cQuery += "          FROM " + RetSqlName("SD2") + "  SD2, " + RetSqlName("SB1") + " SB1 "
cQuery += "          WHERE "
cQuery += "          D2_TIPO = 'N' AND D2_COD = B1_COD "
cQuery += "          AND D2_TP != 'AP' AND D2_CLIENTE ='"+cCod+"' AND D2_LOJA='"+cLoja+"' "
cQuery += "          AND D2_TES in (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " SF4 "
cQuery += "                         WHERE  F4_TEXTO LIKE '%AMOSTRA%' "
cQuery += "                         AND F4_CODIGO>'500' AND SF4.D_E_L_E_T_='') "
cQuery += "          AND SB1.B1_SETOR <>'39' AND   "
cQuery += "          SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "          GROUP BY D2_DOC,D2_EMISSAO "
cQuery += "          ORDER BY D2_EMISSAO DESC,D2_DOC "
cQuery += ") "
cQuery += "AND D2_TIPO = 'N' AND D2_COD = B1_COD "
cQuery += "AND D2_TP != 'AP' AND D2_CLIENTE ='"+cCod+"' AND D2_LOJA='"+cLoja+"' "
cQuery += "AND D2_TES in (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " SF4 "
cQuery += "               WHERE  F4_TEXTO LIKE '%AMOSTRA%' "
cQuery += "               AND F4_CODIGO>'500' AND SF4.D_E_L_E_T_='') "
cQuery += "AND SB1.B1_SETOR <>'39' AND   "
cQuery += "SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY D2_COD,D2_EMISSAO "
cQuery += "ORDER BY EMISSAO DESC  "

If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Amostra"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)


XUXD->(DbGoTop())

IF XUXD->(!EOF())

	nLinha := TextoHorz(nLinha, 6,1, "Data"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,2, "Codigo"    ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,3, "Nome"     ,ESQUERDA,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
	
	DO WHILE XUXD->(!EOF())
		
			if nLinha+1.5 >= nVPage           
		      oPrinter:EndPage()
		      oPrinter:StartPage()          
		      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
		      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Amostra "  ,CENTRO,,oFont10N:oFont)
   		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
	          nLinha := TextoHorz(nLinha, 6,1, "Data"     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 6,2, "Codigo"    ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 6,3, "Nome"     ,ESQUERDA,,oFont10:oFont)
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
		    endif
	
	          nLinha := TextoHorz(nLinha, 6,1, DTOC(STOD(XUXD->EMISSAO))     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 6,2, XUXD->D2_COD    ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 6,3, Alltrim( Posicione( "SB1", 1, xFilial("SB1") +XUXD->D2_COD , "B1_DESC" ) )     ,ESQUERDA,10,oFont10:oFont)
	 	      nLinha += IncLinha(1) //Incremento uma linha
		
		   XUXD->(DbSkip())
		
	ENDDO
	
ELSE

	if nLinha+1.5 >= nVPage
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha  := Cabecalho(cFil)+IncLinha(1)
		nLinha := TextoHorz(nLinha, 1,1, "Continuacao Amostra "  ,CENTRO,,oFont10N:oFont)
		nLinha += IncLinha(1) //Incremento uma linha
		nLinha := LinhaHorz(nLinha, 1,1)
	endif
	
	nLinha := TextoHorz(nLinha, 1,1, "Sem Amostra"     ,CENTRO,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	

ENDIF

XUXD->(DbCLOSEAREA())

 
Return  



***************

STATIC FUNCTION fORCA(cCod,cLoja)

***************

cQuery := "SELECT TOP 5 CJ_NUM,CJ_EMISSAO,SUM(CK_VALOR) VTOTAL FROM " + RetSqlName("SCJ") + "  SCJ," + RetSqlName("SCK") + "  SCK "
cQuery += "WHERE CJ_NUM=CK_NUM "
cQuery += "AND CJ_STATUS='A' "    //  ABERTO 
cQuery += "AND CJ_CLIENTE='"+cCod+"' AND CJ_LOJA='"+cLoja+"' "
cQuery += "AND SCJ.D_E_L_E_T_ <> '*' "
cQuery += "AND SCK.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY CJ_NUM,CJ_EMISSAO "
cQuery += "ORDER BY CJ_EMISSAO DESC "


If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Orcamento"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)


XUXD->(DbGoTop())

IF XUXD->(!EOF())

	nLinha := TextoHorz(nLinha, 6,1, "Orcamento"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,2, "Dt Emissao"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,3, "Valor"    ,DIREITA,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
	
	DO WHILE XUXD->(!EOF())
		
			if nLinha+1.5 >= nVPage           
		      oPrinter:EndPage()
		      oPrinter:StartPage()          
		      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
		      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Orcamento "  ,CENTRO,,oFont10N:oFont)
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)  	          
	   		  nLinha := TextoHorz(nLinha, 6,1, "Orcamento"     ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 6,2, "Dt Emissao"     ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 6,3, "Valor"    ,DIREITA,,oFont10:oFont)
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
		    endif
	
	          nLinha := TextoHorz(nLinha, 6,1, XUXD->CJ_NUM     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 6,2, DTOC(STOD(XUXD->CJ_EMISSAO))     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 6,3, TRANSFORM(XUXD->VTOTAL,PesqPict("SCK","CK_VALOR"))    ,DIREITA,,oFont10:oFont)
	 	      nLinha += IncLinha(1) //Incremento uma linha
		
		   XUXD->(DbSkip())
		
	ENDDO
	
ELSE

	if nLinha+1.5 >= nVPage
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha  := Cabecalho(cFil)+IncLinha(1)
		nLinha := TextoHorz(nLinha, 1,1, "Continuacao Orcamento "  ,CENTRO,,oFont10N:oFont)
		nLinha += IncLinha(1) //Incremento uma linha
		nLinha := LinhaHorz(nLinha, 1,1)
	endif
	
	nLinha := TextoHorz(nLinha, 1,1, "Sem Orcamento"     ,CENTRO,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	

ENDIF

XUXD->(DbCLOSEAREA())

 
Return  

***************

STATIC FUNCTION fHistCom(cNotas)

***************

cQuery := "SELECT "
cQuery += "NOTA=F2_DOC, "
cQuery += "PROD=( case when len(D2_COD) >= 8 then  "
cQuery += "       case when ( SUBSTRING( D2_COD, 4, 1 ) = 'R') or ( SUBSTRING( D2_COD, 5, 1 ) = 'R') "
cQuery += "       then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) "
cQuery += "       else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) end "
cQuery += "       else D2_COD END  ) "
cQuery += ",UM=D2_UM, "
cQuery += "QUANT=SUM((D2_QUANT-D2_QTDEDEV)), "
cQuery += "PRECO=SUM(D2_PRCVEN), "
cQuery += "VALOR=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN), "
cQuery += "DESCONTO=SUM((D2_QUANT-D2_QTDEDEV)*C6_VDESC), "
cQuery += "PDESCONTO=C6_PDESC "
cQuery += "FROM " + RetSqlName("SF2") + " SF2, " + RetSqlName("SD2") + " SD2 ," + RetSqlName("SC6") + " SC6," + RetSqlName("SC5") + " SC5 "
cQuery += "WHERE "
cQuery += "F2_FILIAL=D2_FILIAL "
cQuery += "AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE "
cQuery += "AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA "
cQuery += "AND F2_FILIAL+F2_DOC IN ("+cNotas+") "
cQuery += "AND C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV  "
cQuery += "AND C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "AND SF2.D_E_L_E_T_='' "
cQuery += "AND SD2.D_E_L_E_T_='' "
cQuery += "AND SC6.D_E_L_E_T_='' "
cQuery += "AND SC5.D_E_L_E_T_='' "
cQuery += "GROUP BY C6_PDESC,F2_DOC,D2_UM,case when len(D2_COD) >= 8 then "
cQuery += "case when ( SUBSTRING( D2_COD, 4, 1 ) = 'R') or ( SUBSTRING( D2_COD, 5, 1 ) = 'R') "
cQuery += "then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) "
cQuery += "else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) end "
cQuery += "else D2_COD END  "
cQuery += "ORDER BY  F2_DOC DESC "

If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Historico de Compra "  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)


XUXD->(DbGoTop())

IF XUXD->(!EOF())

	nLinha := TextoHorz(nLinha, 11,1, "Nota"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 11,2, "Codigo"    ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 11,3, "Descricao"    ,ESQUERDA,,oFont10:oFont)	
	nLinha := TextoHorz(nLinha, 11,6, "UM"    ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 11,7, "Quantidade"    ,DIREITA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 11,8, "Preco"    ,DIREITA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 11,9, "Valor"    ,DIREITA,,oFont10:oFont)
    nLinha := TextoHorz(nLinha, 11,10, "Desc(%)"    ,DIREITA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 11,11, "Desc(R$)"    ,DIREITA,,oFont10:oFont)				
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
	
	DO WHILE XUXD->(!EOF())

	   _xnota:=XUXD->NOTA
       nVTotal:=0
       nVDesc:=0

	   DO WHILE XUXD->(!EOF()) .and.XUXD->NOTA==_xnota		
			if nLinha+1.5 >= nVPage           
		      oPrinter:EndPage()
		      oPrinter:StartPage()          
		      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
		      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Historico Compra "  ,CENTRO,,oFont10N:oFont)
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
	          nLinha := TextoHorz(nLinha, 11,1, "Nota"     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,2, "Codigo"    ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,3, "Descricao"    ,ESQUERDA,,oFont10:oFont)	
	          nLinha := TextoHorz(nLinha, 11,6, "UM"    ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,7, "Quantidade"    ,DIREITA,,oFont10:oFont)
       	      nLinha := TextoHorz(nLinha, 11,8, "Preco"    ,DIREITA,,oFont10:oFont)
   	          nLinha := TextoHorz(nLinha, 11,9, "Valor"    ,DIREITA,,oFont10:oFont)
              nLinha := TextoHorz(nLinha, 11,10, "Desc(%)"    ,DIREITA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,11, "Desc(R$)"    ,DIREITA,,oFont10:oFont)				
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
		    endif
	
	          nLinha := TextoHorz(nLinha, 11,1, XUXD->NOTA     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,2, XUXD->PROD    ,ESQUERDA,,oFont10:oFont)
	          _cProDes:=Alltrim( Posicione( "SB1", 1, xFilial("SB1") +XUXD->PROD , "B1_DESC" ) )
	          nLinha := TextoHorz(nLinha, 11,3, _cProDes    ,ESQUERDA,5,oFont06:oFont)
	          nLinha := TextoHorz(nLinha, 11,6, XUXD->UM    ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,7, TRANSFORM(XUXD->QUANT,PesqPict("SD2","D2_QUANT"))     ,DIREITA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,8, TRANSFORM(XUXD->PRECO,PesqPict("SD2","D2_TOTAL"))    ,DIREITA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,9, TRANSFORM(XUXD->VALOR,PesqPict("SD2","D2_TOTAL"))     ,DIREITA,,oFont10:oFont)
              nLinha := TextoHorz(nLinha, 11,10, TRANSFORM(XUXD->PDESCONTO,PesqPict("SC6","C6_PDESC")) ,DIREITA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 11,11, TRANSFORM(XUXD->DESCONTO,PesqPict("SD2","D2_TOTAL"))  ,DIREITA,,oFont10:oFont)
              nVTotal+=XUXD->VALOR
              nVDesc+=XUXD->DESCONTO              
   			  
   			  IF LEN(Alltrim(_cProDes))<48
				nLinha += IncLinha(1) //Incremento uma linha
			  ELSE
				nLinha += IncLinha(1.5) //Incremento uma linha
			  ENDIF

	 	      
	 	      //nLinha += IncLinha(1) //Incremento uma linha
		
		   XUXD->(DbSkip())
	   ENDDO	
	         //nLinha := LinhaHorz(nLinha, 1,1)
             nLinha += IncLinha(0.5) //Incremento uma linha
	         nLinha := TextoHorz(nLinha, 11,1,_xnota      ,ESQUERDA,,oFont10N:oFont)
             nLinha := TextoHorz(nLinha, 11,2,"TOTAL: "   ,ESQUERDA,,oFont10N:oFont)	         
	         nLinha := TextoHorz(nLinha, 11,9, TRANSFORM(nVTotal,PesqPict("SD2","D2_TOTAL"))     ,DIREITA,,oFont10N:oFont)
	         nLinha := TextoHorz(nLinha, 11,11, TRANSFORM(nVDesc,PesqPict("SD2","D2_TOTAL"))  ,DIREITA,,oFont10N:oFont)
             nLinha += IncLinha(1) //Incremento uma linha
             nLinha := LinhaHorz(nLinha, 1,1)
	ENDDO
	
ELSE

	if nLinha+1.5 >= nVPage
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha  := Cabecalho(cFil)+IncLinha(1)
		nLinha := TextoHorz(nLinha, 1,1, "Continuacao Historico Compra "  ,CENTRO,,oFont10N:oFont)
		nLinha += IncLinha(1) //Incremento uma linha
		nLinha := LinhaHorz(nLinha, 1,1)
	endif
	
	nLinha := TextoHorz(nLinha, 1,1, "Sem Historico Compra"     ,CENTRO,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	

ENDIF

XUXD->(DbCLOSEAREA())

 
Return  


***************

STATIC FUNCTION fAgeVi(cCod,cLoja)

***************

cQuery := "SELECT "
cQuery += "NOME_GESTOR=ISNULL((SELECT RTRIM(SA3X.A3_NREDUZ) FROM " + RetSqlName("SA3") + " SA3X WHERE SA3X.A3_COD = ZZE_GESTOR AND SA3X.D_E_L_E_T_ <> '*'),''), "
cQuery += "MOTIVO=ISNULL((SELECT X5_DESCRI FROM SX5020 X5 WHERE X5_FILIAL='01'AND X5_TABELA='AG' AND X5_CHAVE=ZZF_MOTOBJ AND X5.D_E_L_E_T_=''),''), "
cQuery += "* "
cQuery += "FROM " + RetSqlName("ZZE") + " ZZE WITH (NOLOCK) , " + RetSqlName("ZZF") + " ZZF WITH (NOLOCK) "
cQuery += "WHERE "
cQuery += "ZZF_CODIGO IN(SELECT TOP 5 ZZE_CODIGO "
cQuery += "              FROM " + RetSqlName("ZZE") + " ZZE WITH (NOLOCK) , " + RetSqlName("ZZF") + " ZZF WITH (NOLOCK) "
cQuery += "              WHERE "
cQuery += "              ZZE_CODIGO=ZZF_CODIGO AND ZZF_TIPO='C' AND ZZF_CODCP='"+cCod+"' AND ZZF_LOJA='"+cLoja+"' "
cQuery += "              AND ZZE_FECHAM='X' AND ZZE.D_E_L_E_T_ = ' ' AND ZZF.D_E_L_E_T_ = ' ' "
cQuery += "              GROUP BY ZZE_CODIGO ORDER BY ZZE_CODIGO DESC   "
cQuery += ") "
 
cQuery += "AND ZZE_CODIGO=ZZF_CODIGO "
cQuery += "AND ZZF_TIPO='C' "
cQuery += "AND ZZF_CODCP='"+cCod+"' AND ZZF_LOJA='"+cLoja+"' "
cQuery += "AND ZZE_FECHAM='X' "
cQuery += "AND ZZE.D_E_L_E_T_ = ' ' "
cQuery += "AND ZZF.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY NOME_GESTOR,ZZF_DTVISI DESC "


If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Agenda de Viagem"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)


XUXD->(DbGoTop())

IF XUXD->(!EOF())

	nLinha := TextoHorz(nLinha, 9,1, "Gestor"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 9,2, "Dt Visita"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 9,3, "Agenda"    ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 9,4, "realizado?"     ,ESQUERDA,,oFont10:oFont)
    nLinha := TextoHorz(nLinha, 9,5, "Fechamento?"     ,ESQUERDA,,oFont10:oFont)
  	nLinha := TextoHorz(nLinha, 9,6, "Motivo Objecao"     ,ESQUERDA,10,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
	
	DO WHILE XUXD->(!EOF())
		
			if nLinha+1.5 >= nVPage           
		      oPrinter:EndPage()
		      oPrinter:StartPage()          
		      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
		      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Agenda Viagem "  ,CENTRO,,oFont10N:oFont)
   		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
	          nLinha := TextoHorz(nLinha, 9,1, "Gestor"     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 9,2, "Dt Visita"     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 9,3, "Agenda"    ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 9,4, "realizado?"     ,ESQUERDA,,oFont10:oFont)
              nLinha := TextoHorz(nLinha, 9,5, "Fechamento?"     ,ESQUERDA,,oFont10:oFont)
  	          nLinha := TextoHorz(nLinha, 9,6, "Motivo Objecao"     ,ESQUERDA,10,oFont10:oFont)
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
		    endif
	
  	          nLinha := TextoHorz(nLinha, 9,1, ALLTRIM(NOME_GESTOR)     ,ESQUERDA,,oFont06:oFont)
	 	      nLinha := TextoHorz(nLinha, 9,2, DTOC(STOD(XUXD->ZZF_DTVISIT))     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 9,3, XUXD->ZZF_CODIGO    ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 9,4, IIF(XUXD->ZZF_REALIZ='S','Sim',IIF(XUXD->ZZF_REALIZ='N','Nao',''))     ,ESQUERDA,,oFont10:oFont)
              nLinha := TextoHorz(nLinha, 9,5, IIF(XUXD->ZZF_OBJECA='S','Sim',IIF(XUXD->ZZF_OBJECA='N','Nao',''))     ,ESQUERDA,,oFont10:oFont)
  	          nLinha := TextoHorz(nLinha, 9,6, XUXD->MOTIVO     ,ESQUERDA,10,oFont10:oFont)
	 	      nLinha += IncLinha(1) //Incremento uma linha
		
		   XUXD->(DbSkip())
		
	ENDDO
	
ELSE

	if nLinha+1.5 >= nVPage
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha  := Cabecalho(cFil)+IncLinha(1)
		nLinha := TextoHorz(nLinha, 1,1, "Continuacao Agenda Viagem "  ,CENTRO,,oFont10N:oFont)
		nLinha += IncLinha(1) //Incremento uma linha
		nLinha := LinhaHorz(nLinha, 1,1)
	endif
	
	nLinha := TextoHorz(nLinha, 1,1, "Sem Agenda de Viagem"     ,CENTRO,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	

ENDIF

XUXD->(DbCLOSEAREA())

 
Return  


***************

STATIC FUNCTION fBoni(cCod,cLoja)

***************


cQuery := "SELECT TOP 5 "
cQuery += "NOTA=F2_DOC,F2_EMISSAO, "
cQuery += "BONI_KG=SUM((D2_QUANT-D2_QTDEDEV)*D2_PESO), "
cQuery += "BONI_VALOR=SUM(((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN)+D2_VALIPI) "
cQuery += "FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SF2") + " SF2, " + RetSqlName("SA3") + " SA3, "
cQuery += "" + RetSqlName("SA1") + " SA1 "
cQuery += "WHERE "
cQuery += "F2_CLIENTE='"+cCod+"' AND F2_LOJA='"+cLoja+"' "
cQuery += "AND D2_TIPO = 'N' "
cQuery += "AND D2_TES in ( SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " SF4 "
cQuery += "                WHERE F4_TEXTO LIKE '%BONIFICACAO%' "
cQuery += "                AND F4_CODIGO>'500' AND SF4.D_E_L_E_T_='') "
cQuery += "AND D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC "
cQuery += "AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE "
cQuery += "AND D2_LOJA=F2_LOJA AND F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA "
cQuery += "AND D2_COD = B1_COD AND F2_VEND1 = A3_COD "
cQuery += "AND SB1.B1_SETOR <>'39' AND "
cQuery += "F2_DUPL = ' ' AND "
cQuery += "SF2.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY F2_DOC,F2_EMISSAO "
cQuery += "ORDER BY F2_EMISSAO DESC "


If Select("XUXD") > 0
	DbSelectArea("XUXD")
	XUXD->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XUXD"
	
/// CABECALHO
nLinha := TextoHorz(nLinha, 1,1, "Bonificacao"  ,CENTRO,,oFont10N:oFont)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)


XUXD->(DbGoTop())

IF XUXD->(!EOF())

	nLinha := TextoHorz(nLinha, 6,1, "Nota"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,2, "Dt Emissao"     ,ESQUERDA,,oFont10:oFont)
	nLinha := TextoHorz(nLinha, 6,3, "Valor"    ,DIREITA,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	nLinha := LinhaHorz(nLinha, 1,1)
	
	DO WHILE XUXD->(!EOF())
		
			if nLinha+1.5 >= nVPage           
		      oPrinter:EndPage()
		      oPrinter:StartPage()          
		      nLinha  := Cabecalho(cFil)+IncLinha(1)                        
		      nLinha := TextoHorz(nLinha, 1,1, "Continuacao Bonificacao "  ,CENTRO,,oFont10N:oFont)
   		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
			  nLinha := TextoHorz(nLinha, 6,1, "Nota"     ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 6,2, "Dt Emissao"     ,ESQUERDA,,oFont10:oFont)
			  nLinha := TextoHorz(nLinha, 6,3, "Valor"    ,DIREITA,,oFont10:oFont)		
		      nLinha += IncLinha(1) //Incremento uma linha
		      nLinha := LinhaHorz(nLinha, 1,1)
		    endif
	
  	          nLinha := TextoHorz(nLinha, 6,1, ALLTRIM(XUXD->NOTA)     ,ESQUERDA,,oFont10:oFont)
	 	      nLinha := TextoHorz(nLinha, 6,2, DTOC(STOD(XUXD->F2_EMISSAO))     ,ESQUERDA,,oFont10:oFont)
	          nLinha := TextoHorz(nLinha, 6,3, TRANSFORM(XUXD->BONI_VALOR,PesqPict("SD2","D2_TOTAL"))    ,DIREITA,,oFont10:oFont)
	 	      nLinha += IncLinha(1) //Incremento uma linha
		
		   XUXD->(DbSkip())
		
	ENDDO
	
ELSE

	if nLinha+1.5 >= nVPage
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha  := Cabecalho(cFil)+IncLinha(1)
		nLinha := TextoHorz(nLinha, 1,1, "Continuacao Bonificacao "  ,CENTRO,,oFont10N:oFont)
		nLinha += IncLinha(1) //Incremento uma linha
		nLinha := LinhaHorz(nLinha, 1,1)
	endif
	
	nLinha := TextoHorz(nLinha, 1,1, "Sem Bonificacao"     ,CENTRO,,oFont10:oFont)
	nLinha += IncLinha(1) //Incremento uma linha
	

ENDIF

XUXD->(DbCLOSEAREA())

 
Return  



***************

Static Function Campos( cString,;	// String a ser processada
					    cDelim,;	// Delimitador
					    lAllTrim;	// Tira espacos em brancos
				                  )
***************

Local aRetorno := {}	// Array de retorno
Local nPos				// Posicao do caracter

cDelim		:= If( cDelim = Nil, ' ', cDelim )
lAllTrim 	:= If( lAllTrim = Nil, .t., lAllTrim )
             
If lAllTrim
	cString := AllTrim( cString )
Endif

Do While .t.
	If ( nPos := At( cDelim, cString ) ) != 0
 		Aadd( aRetorno, Iif( lAllTrim, AllTrim( Substr( cString, 1, nPos - 1 ) ), Substr( cString, 1, nPos - 1 ) ) )
		cString := Substr( cString, nPos + Len( cDelim ) )
	Else
		If !Empty( cString )
			Aadd( aRetorno,  Iif( lAllTrim, AllTrim( cString ), cString ) )
		Endif
		Exit
	Endif	
Enddo

Return aRetorno


****************************************
Static Function DiasUteis(dDtIni,dDtFim)
****************************************

local nDUtil := 0
local dDtMov := dDtIni+1

while dDtMov <= dDtFim
   if DataValida(dDtMov) = dDtMov
      nDUtil += 1
   endif	
   dDtMov += 1
end                 

return(nDUtil) 


********************************
Static Function ValidPerg(cPerg)
********************************

PutSx1( cperg, '01', 'Salvar PDF em?', '', '', 'mv_ch1', 'C', 80, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '', '', '', '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Cod.Cliente ?', '', '', 'mv_ch2', 'C', 06, 0, 0, 'G', '', 'SA1', '', '', 'mv_par02', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '03', 'Loja ?', '', '', 'mv_ch3', 'C', 02, 0, 0, 'G', '', '', '', '', 'mv_par03', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
putSx1(cPerg,  '04', 'Tipo?' , '', '', 'mv_ch4', 'N', 1, 0, 0, 'C', '', ''	 , '', '', 'mv_par04','Completo','','','','Simples','','','','','','','','','','','',{},{},{})

Return NIL


***************

Static function fGestMail(cCod)

***************

Local cQuery
Local cRet :=''

cQuery := "SELECT COD=RTRIM(A3_COD), EMAIL=RTRIM(A3_EMAIL) "
cQuery += "FROM "+RetSqlName("SA3")+" SA3 "
cQuery += "WHERE A3_COD='"+cCod+"'  "
cQuery += "AND D_E_L_E_T_<>'*' "

if Select("MAILX") > 0
	DbSelectArea("MAILX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "MAILX"

IF  !MAILX->(EOF())

    cRet:=ALLTRIM(MAILX->EMAIL)

endIF 

MAILX->(DbCloseArea())

return cRet



***************

static function GetPrzMed(cCond)

***************

local aI := {}
local nX
local nRet := 0


aI := Str2Arr(Alltrim(cCond),",")
for nX := 1 to len(aI)
	nRet += Val(aI[nX])
next nX

nRet := nRet / Len(aI)

aI := {}

return nRet