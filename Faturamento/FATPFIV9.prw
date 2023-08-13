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
//Definicao da Carteira
#DEFINE PROGR 001
#DEFINE IMEDI 002
//Definicao do tipo do relatorio
#DEFINE DIRET 001
#DEFINE COORD 002
#DEFINE REPRE 003
//Definicao das regioes do pais
#DEFINE NORTE    001
#DEFINE NORDESTE 002
#DEFINE COESTE   003
#DEFINE SUDESTE  004
#DEFINE SUL      005
#DEFINE TODAS    006
//Definicao periodo da Meta
#DEFINE ANUAL   001
#DEFINE MENSAL  002
#DEFINE PERIODO 003
//Definicao Linhas de Sacos
#DEFINE HOSPIT  001
#DEFINE DOMEST  002
#DEFINE INSTIT  003
#DEFINE TLINHAS 004

#DEFINE SACOS    002

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração do arquivo pelo menu
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*********************
User Function PSV90()
*********************
Local	lEnd	:= .F.
Local nMes
Local nAno
Local nRelato
Local cCod
Local cUF
Local nRegiao
Local cEmail
Local cDirC
Local lReal
Local nLinha

ValidPerg('PSV90')
if !Pergunte('PSV90',.T.)
   return
endif

nMes    := MV_PAR01
nAno    := MV_PAR02
nRelato := Val(MV_PAR03)
cCod    := Alltrim(MV_PAR04)
cUF     := MV_PAR05
nRegiao := Val(MV_PAR06)
cDirC   := Alltrim(MV_PAR07)
lReal   := (MV_PAR08==2)
nLinha  := MV_PAR09
Processa({ |lEnd| U_xPSV90(nMes,nAno,nRelato,cCod,cUF,nRegiao,,cDirC,lReal,nLinha),OemToAnsi('Imprimindo Posição de Vendas 9.0...')}, OemToAnsi('Aguarde...'))

Return

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração e Envio pelo agendamento
//Diretoria 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************
User Function ADPSV90()
***********************
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
Local lReal   := .T. //Envia Em Reais ou KGs

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

U_xPSV90(nMes,nAno,nRelato,cCod,cUF,nRegiao,cEmail,,lReal,nLinha)

Return


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração e Envio pelo agendamento
//Diretoria 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************
User Function ADPSV90K()
***********************
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
Local lReal   := .F. //Envia Em Reais ou KGs

if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
endif
conout("PSV90 - DIRETORIA")

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

U_xPSV90(nMes,nAno,nRelato,cCod,cUF,nRegiao,cEmail,,/*lReal*/,nLinha)

Return

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração e Envio pelo 
//agendamento Coordenação
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************
User Function ACPSV90()
***********************
Local _XX
Local nMes
Local nAno
Local cEmail := ""
Local lReal  := .T. //Envia Em Reais ou KGs

if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
endif
conout("PSV90 - COORDENADOR")

if Day(dDataBase) = 1
   nMes := Month(dDataBase-1)
   nAno := Year(dDataBase-1)
else   
   nMes := Month(dDataBase)
   nAno := Year(dDataBase)
endif   

//Envia para Coordenadores
aMails := U_RVMails( COORD )
for _XX := 1 to Len(aMails)
   cEmail := aMails[_XX,2]
   //U_xPSV90(nMes,nAno,COORD,aMails[_XX,1],,TODAS,cEmail,,lReal,TLINHAS)
   U_xPSV90(nMes,nAno,COORD,aMails[_XX,1],,IIF(aMails[_XX,1] == "2348",1,2),cEmail,,lReal,TLINHAS)
next _XX

Return


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//Função para Geração e Envio pelo 
//agendamento Representante
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
***********************
User Function ARPSV90()
***********************
Local _XX
Local nMes
Local nAno
Local cEmail := ""
Local lReal  := .T. //Envia Em Reais ou KGs

if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
endif
conout("PSV90 - REPRESENTANTE")

if Day(dDataBase) = 1
   nMes := Month(dDataBase-1)
   nAno := Year(dDataBase-1)
else   
   nMes    := Month(dDataBase)
   nAno    := Year(dDataBase)
endif   

//Envia para Representantes
aMails := U_RVMails( REPRE )
for _XX := 1 to Len(aMails)
   cEmail := aMails[_XX,2]
   conout(aMails[_XX,1] + cEmail)
   U_xPSV90(nMes,nAno,REPRE,aMails[_XX,1],,TODAS,cEmail,,lReal,TLINHAS)
   //U_xPSV90(nMes,nAno,REPRE,aMails[_XX,1],,IIF(aMails[_XX,1] == "2751",1,2),cEmail,,lReal,TLINHAS))     
next _XX

Return


***********************************************************************************
User Function xPSV90(nMes,nAno,nRelato,cCod,cUF,nRegiao,cEmail,cDirC,lReal,nLinPro)
***********************************************************************************

Local nQtPV := 999 //Numero de pedidos mais atrasados
Local _nX, _XY, _XX, _XZ, _XU
Local cCoo
Local cDirS  := "\TEMP\"
Local cTit
Local aFatA    := aFatM := {}
Local aMetA    := aMetM := {}
Local cCorpo   := ""
Local aTop10   := {}
Local lPreview := !(cEmail <> nil .and. !Empty(cEmail))
Local aMES     := { 'Janeiro','Fevereiro','Março'   ,'Abril'  ,'Maio'    ,'Junho'   ,;
                    'Julho'  ,'Agosto'   ,'Setembro','Outubro','Novembro','Dezembro' }
Local cMAnt    := aMes[Month(StoD(fMesAnt(nMes,nAno)[1]))]
Local cTitulo1
Local cTitulo2
Local cTitulo3
Local cTitulo4
Local cTitulo5
Local aAnexos	:= {}
Local aMeses120 := fMeses120(nMes,nAno)

Private nLinha := IncLinha(1)
Private cTitulo
Private nW
Private nMarE := nMarD := nMarS := nMarI := 0.5
Private wnRel := 'PSV90'

Default cDirC := cDirS
Default lReal := .F.
              
cTitulo1 := "Clientes que compraram no mês de "+cMAnt+" - Em "+if(lReal,"R$","KG")
cTitulo2 := "Clientes que compraram nos últimos 120 dias e NÃO compraram no mês de "+cMAnt+" - Em "+if(lReal,"R$","KG")
cTitulo3 := "Clientes que NÃO compram a mais de 120 dias"+" - Em "+if(lReal,"R$","KG")
cTitulo4 := "Lista de Prospecção"
cTitulo5 := "Lista dos Pedidos em aberto"

if nRelato == DIRET
   wnRel += "_DIRET"
   nQtPV := 999 //Numero de pedidos mais atrasados   
elseif nRelato == COORD
   wnRel += "_COORD_"
elseif  nRelato == REPRE
   cCoo := Posicione( "SA3", 1, xFilial("SA3") + cCod, "A3_SUPER" )
   cCoo := Alltrim(Posicione( "SA3", 1, xFilial("SA3") + cCoo, "A3_NOME" ))
   wnRel += "_REPRE"
endif

if nRelato <> DIRET
   wnRel += Alltrim(cCod)
endif

wnRel += "_"+CriaTrab( nil, .f. )

//Deleta Arquivo caso já exista
If File(cDirC+wnRel+".pdf") 
	Ferase(cDirC+wnRel+".pdf")
EndIf
   
Private oPrinter := FWMSPrinter():New(wnRel,IMP_PDF,.F.,cDirS,.T.,,,,,.F.)
Private m_pag    := 0
Private oFont10  := TFontEx():New(oPrinter,"Arial",08,08,.F.,.T.,.F.)// 1
Private oFont10N := TFontEx():New(oPrinter,"Arial",08,08,.T.,.T.,.F.)// 1
Private oFont12  := TFontEx():New(oPrinter,"Arial",11,11,.F.,.T.,.F.)// 10
Private OFONT12N := TFontEx():New(oPrinter,"Arial",11,11,.T.,.T.,.F.)// 12  
Private oFont14  := TFontEx():New(oPrinter,"Arial",13,13,.F.,.T.,.F.)// 10
Private OFONT14N := TFontEx():New(oPrinter,"Arial",13,13,.T.,.T.,.F.)// 12  
Private oFont18N := TFontEx():New(oPrinter,"Arial",17,17,.T.,.T.,.F.)// 12 

Private aLista1 := {}
Private aLista2 := {}
Private aLista3 := {}
Private aLista4 := {}
Private aLista5 := {}

ProcRegua(0) // Regua

cTitulo := "Posição de Vendas v9.0"

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
cMesAno := aMes[nMes]+"/"+AllTrim(Str(nAno))
cTit    := cMesAno+" - "+if(nRelato=DIRET,"DIRETORIA",;
                            if(nRelato=COORD,"COORD.: "+Alltrim(cCod)+"-"+Alltrim(posicione("SA3",1,xFilial('SA3') + cCod,"A3_NREDUZ")) ,;
                                 "REP.: "+Alltrim(cCod)+"-"+Alltrim(posicione("SA3",1,xFilial('SA3') + cCod,"A3_NREDUZ"))  ))+;
                                      " - Em "+if(lReal,"R$","KG")   

nLinha := TextoHorz(nLinha, 1, 1, cTit ,CENTRO, ,oFont18N:oFont )
nLinha += IncLinha(2) //Incremento duas linhas
if nRelato==REPRE
   nLinha := TextoHorz(nLinha, 1, 1, "Coordenador: "+cCoo ,CENTRO, ,oFont14N:oFont )
   nLinha += IncLinha(1.5)
endif
nLinha := LinhaHorz(nLinha, 1,1)
aRet   := Info1(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinPro,,,lReal)
nLinha := TextoHorz(nLinha, 4,1, "Dias Úteis para o fim do mês:",ESQUERDA,,oFont14:oFont)
nLinha := TextoHorz(nLinha, 4,2, Transform(aRet[3],"@E 99")     ,DIREITA)
nLinha := TextoHorz(nLinha, 4,3, "Prazo Médio:"                 ,ESQUERDA)
nLinha := TextoHorz(nLinha, 4,4, Transform(aRet[4],"@E 999.99") ,DIREITA)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 4,1, "Carteira Programada "+if(lReal,"R$:","KG:")               ,ESQUERDA)
nLinha := TextoHorz(nLinha, 4,2, Transform(aRet[5],"@E 9,999,999,999.99" ),DIREITA)
nLinha := TextoHorz(nLinha, 4,3, "Carteira Imediata "+if(lReal,"R$:","KG:")                 ,ESQUERDA,,oFont14N:oFont)
nLinha := TextoHorz(nLinha, 4,4, Transform(aRet[6],"@E 9,999,999,999.99" ),DIREITA)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
nLinha := TextoHorz(nLinha, 4,1, "Bonificação "+if(lReal,"R$:","KG:")                       ,ESQUERDA,,oFont14:oFont)
nLinha := TextoHorz(nLinha, 4,2, Transform(aRet[7],"@E 9,999,999,999.99" ),DIREITA)
if nRelato == DIRET
   nLinha := TextoHorz(nLinha, 4,3, "Margem (Vendas):"                   ,ESQUERDA)
   nLinha := TextoHorz(nLinha, 4,4, Transform(aRet[8],"@E 9,999.99" )+"%" ,DIREITA)    
endif
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
if nRelato == DIRET
   nLinha := TextoHorz(nLinha, 4,1, "Faturado:"           ,ESQUERDA,,oFont14N:oFont)
   nLinha := TextoHorz(nLinha, 4,2, Transform(if(lReal,aRet[18],aRet[17]),"@E 9,999,999,999.99" ),DIREITA)
endif

nLinha := TextoHorz(nLinha, 4,3, "Vendido no Mês para o Mês "+if(lReal,"R$:","KG:")          ,ESQUERDA,,oFont14:oFont)
nLinha := TextoHorz(nLinha, 4,4, Transform(aRet[13],"@E 9,999,999,999.99" ),DIREITA)
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

if nRelato == DIRET
   nLinha := TextoHorz(nLinha, 4,1, "Faturado + Cart. Imediata "+if(lReal,"R$:","KG:")                ,ESQUERDA,,oFont14N:oFont)
   nLinha := TextoHorz(nLinha, 4,2, Transform(if(lReal,aRet[18],aRet[17])+aRet[6],"@E 9,999,999,999.99" ),DIREITA)
   nLinha += IncLinha(1) //Incremento uma linha
   nLinha := LinhaHorz(nLinha, 1,1)
endif

nLinha += IncLinha(2) //Incremento 2 linhas
nLinha := LinhaHorz(nLinha, 1,1)
if nRelato == DIRET
   nLinha := TextoHorz(nLinha, 1,1, "Pedidos atrasados",CENTRO,,oFont14N:oFont)
elseif nRelato == COORD
   nLinha := TextoHorz(nLinha, 1,1, "Pedidos em Carteira",CENTRO,,oFont14N:oFont)
else
   nLinha := TextoHorz(nLinha, 1,1, Alltrim(Str(nQtPV))+" Pedidos mais atrasados",CENTRO,,oFont14N:oFont)
endif   
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)

nLinha := TextoHorz(nLinha, 9,1, "Pedido"  ,ESQUERDA,,oFont14N:oFont)
nLinha := TextoHorz(nLinha, 9,2, "Cliente" ,ESQUERDA)
nLinha := TextoHorz(nLinha, 9,3, "Loja"    ,ESQUERDA)
nLinha := TextoHorz(nLinha, 9,4, "UF"      ,ESQUERDA)
nLinha := TextoHorz(nLinha, 9,5, "Nome"    ,ESQUERDA)
nLinha := TextoHorz(nLinha, 9,9, "Dias"    ,DIREITA )
nLinha += IncLinha(1) //Incremento uma linha
nLinha := LinhaHorz(nLinha, 1,1)
if nRelato == COORD
   nQtPV := 999
endif
aPed := U_PVRava( nQtPV, nRelato, cCod, SACOS,,,if(nRelato==DIRET,0,0),nLinPro )
for _nX := 1 to Len(aPed)
   TextoHorz(nLinha, 9,1, aPed[_nX,5], ESQUERDA,,oFont14:oFont) //Pedido
   TextoHorz(nLinha, 9,2, aPed[_nX,1], ESQUERDA) //Cliente
   TextoHorz(nLinha, 9,3, aPed[_nX,2], ESQUERDA) //Loja
   TextoHorz(nLinha, 9,4, aPed[_nX,6], ESQUERDA) //UF
   TextoHorz(nLinha, 9,5, aPed[_nX,3], ESQUERDA,Cm2Px(11)) //Nome
   TextoHorz(nLinha, 9,9, Transform( aPed[_nX,4],"@E 999" ),DIREITA) //Dias
   nLinha += IncLinha(1) //Incremento uma linha
   LinhaHorz(nLinha, 1,1)
	IncProc("Imprimindo PSV9...")   
next _nX
nLinha += IncLinha(2) //Incremento duas linhas
nLinha := LinhaHorz(nLinha, 1,1)

//Impressão dos grupos
if nRelato == DIRET .or. nRelato == COORD
   //Rava
   aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, lReal )
   nLinha := GrupoN( nLinha, if(nRelato==DIRET,"RAVA","COORDENAÇÃO"),aInfo, lReal )

   //Vendas por Linha
   if nLinPro = TLINHAS .or. nLinPro = HOSPIT      
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, HOSPIT, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                    
         nLinha := GrupoN( nLinha,"HOSPITALAR",aInfo,lReal, .F. )
      endif         
   endif

   if nLinPro = TLINHAS .or. nLinPro = DOMEST
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, DOMEST, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                    
         nLinha := GrupoN( nLinha,"DOMESTICA",aInfo,lReal, .F. )
      endif         
   endif
      
   if nLinPro = TLINHAS .or. nLinPro = INSTIT
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, INSTIT, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0               
         nLinha := GrupoN( nLinha,"INSTITUCIONAL",aInfo,lReal, .F. )
      endif
   endif
   	nLinha += IncLinha(1)
   //FATURAMENTO

   //Vendas por Linha
   if nLinPro = TLINHAS .or. nLinPro = HOSPIT     
      //Imprimo somente se tiver valor para a meta ou realizado     
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, HOSPIT, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"HOSPITALAR",aInfo,lReal,.F. )
  	endif   
   endif
   if nLinPro = TLINHAS .or. nLinPro = DOMEST
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, DOMEST, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"DOMESTICA",aInfo,lReal,.F. )
  	endif   
   endif
   if nLinPro = TLINHAS .or. nLinPro = INSTIT       
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, INSTIT, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"INSTITUCIONAL",aInfo,lReal,.F. )
  	endif   
   endif
   	nLinha += IncLinha(1)
   	aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"TODAS",aInfo,lReal,.F. )
  	endif   
    nLinha += IncLinha(1)      
    nLinha := LinhaHorz(nLinha, 1,1) 
   	nLinha += IncLinha(1)
   	
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"JANAINA",aInfo,lReal )
      endif   
   endif
   //'PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO'
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "PE", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"PE",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "PB", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"PB",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "BA", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou Hrealizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"BA",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "RJ", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"RJ",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "SP", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"SP",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "MG", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"MG",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "ES", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"ES",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "SC", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"SC",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "RS", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"RS",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "PR", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"PR",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "DF", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"DF",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "GO", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"GO",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 1)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "CE", 1, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"CE",aInfo,lReal )
      endif   
   endif
   
   
   
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)   
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"RENATA",aInfo,lReal )
      endif   
   endif
   // 'AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS'
   //Acumulado Mensal por Regiao
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "MS", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"MS",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .and. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "MT", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"MT",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "AC", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"AC",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "AM", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"AM",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "RO", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"RO",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "RR", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"RR",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "TO", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"TO",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "AL", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"AL",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "MA", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"MA",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "PI", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"PI",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "RN", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"RN",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "SE", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"SE",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "AP", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"AP",aInfo,lReal )
      endif   
   endif
   if nRelato == DIRET .or. (nRelato == COORD .AND. nRegiao == 2)
      aInfo := Info2( nMes,nAno, nRelato, cCod, "PA", 2, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"PA",aInfo,lReal )
      endif   
   endif
   /*
   if nRegiao == TODAS .OR. nRegiao == NORTE
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, NORTE, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"NORTE",aInfo,lReal )
      endif   
   endif
   
   if nRegiao == TODAS .OR. nRegiao == NORDESTE   
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, NORDESTE, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"NORDESTE",aInfo,lReal )
      endif   
   endif
   
   if nRegiao == TODAS .OR. nRegiao == SUDESTE
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, SUDESTE, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0               
         nLinha := GrupoN( nLinha,"SUDESTE",aInfo,lReal )
      endif   
   endif
   
   if nRegiao == TODAS .OR. nRegiao == COESTE
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, COESTE, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0               
         nLinha := GrupoN( nLinha,"C.OESTE",aInfo,lReal )
      endif   
   endif
  
   if nRegiao == TODAS .OR. nRegiao == SUL
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, SUL, nLinPro, lReal )
      //Imprimo somente se tiver valor para a meta ou realizado               
      if (aInfo[1]+aInfo[4]) > 0                     
         nLinha := GrupoN( nLinha,"SUL",aInfo,lReal )
      endif   
   endif
   */   
endif

if nRelato == COORD

nLinha += IncLinha(1)
//nLinha := LinhaHorz(nLinha, 1,1)      

   //Imprime Representante por UF  
   if nRelato == COORD
      aUF := U_UFRegiao(nRegiao)
      nLinha := TextoHorz(nLinha, 1,1,"REPRESENTANTES:",ESQUERDA,,oFont14N:oFont)
      nLinha += IncLinha(1)      
      nLinha := LinhaHorz(nLinha, 1,1)            
      for _XY := 1 to Len(aUF)
         for _XZ := 1 to Len(aUF[_XY,2])           
            aRep := U_RepUF( aUF[_XY,2,_XZ], cCod ) //Busca Representantes da UF            
            if Len(aRep) > 0
               nLinha := TextoHorz(nLinha, 1,1,aUF[_XY,2,_XZ]+":" ,ESQUERDA,,oFont14N:oFont)
               nLinha += IncLinha(1)
               nLinha := LinhaHorz(nLinha, 1,1)      
            endif
            
            for _XU := 1 to Len(aRep)
            	/* ANTES
               aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), aUF[_XY,2,_XZ], nRegiao, nLinPro, lReal )
               //Imprimo somente se tiver valor para a meta ou realizado               
               if (aInfo[1]+aInfo[4]) > 0               
                  nLinha := GrupoN( nLinha, Alltrim(aRep[_XU,2]),aInfo, lReal )                           
               endif
               */
               nLinha += IncLinha(1)
               nLinha := TextoHorz(nLinha, 1,1,Alltrim(aRep[_XU,2]) ,ESQUERDA,,oFont14N:oFont)
               nLinha += IncLinha(1)
               
			   //Vendas por Linha
			   if nLinPro = TLINHAS .or. nLinPro = HOSPIT     
			      //Imprimo somente se tiver valor para a meta ou realizado     
			      aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), cUF, nRegiao, HOSPIT, lReal )
			      if (aInfo[1]+aInfo[4]) > 0               
			         nLinha := GrupoN( nLinha,"HOSPITALAR",aInfo,lReal,.F. )
			      endif   
			   endif
			   if nLinPro = TLINHAS .or. nLinPro = DOMEST
			      aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), cUF, nRegiao, DOMEST, lReal )
			      if (aInfo[1]+aInfo[4]) > 0               
			         nLinha := GrupoN( nLinha,"DOMESTICA",aInfo,lReal,.F. )
			      endif   
			   endif
			   if nLinPro = TLINHAS .or. nLinPro = INSTIT       
			      aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), cUF, nRegiao, INSTIT, lReal )
			      if (aInfo[1]+aInfo[4]) > 0               
			         nLinha := GrupoN( nLinha,"INSTITUCIONAL",aInfo,lReal,.F. )
			      endif   
			   endif
			   
			   	nLinha += IncLinha(1)
			   //FATURAMENTO
			   //Vendas por Linha
			   if nLinPro = TLINHAS .or. nLinPro = HOSPIT     
			      //Imprimo somente se tiver valor para a meta ou realizado     
			      aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), cUF, nRegiao, HOSPIT, lReal )
			   	if (aInfo[18]) > 0               
			  		nLinha := GrupoF( nLinha,"HOSPITALAR",aInfo,lReal,.F. )
			  	endif   
			   endif
			   if nLinPro = TLINHAS .or. nLinPro = DOMEST
			      aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), cUF, nRegiao, DOMEST, lReal )
			   	if (aInfo[18]) > 0               
			  		nLinha := GrupoF( nLinha,"DOMESTICA",aInfo,lReal,.F. )
			  	endif   
			   endif
			   if nLinPro = TLINHAS .or. nLinPro = INSTIT       
			      aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), cUF, nRegiao, INSTIT, lReal )
			   	if (aInfo[18]) > 0               
			  		nLinha := GrupoF( nLinha,"INSTITUCIONAL",aInfo,lReal,.F. )
			  	endif   
			   endif
			   	nLinha += IncLinha(1)
			   	aInfo := Info2( nMes,nAno, REPRE, Alltrim(aRep[_XU,1]), cUF, nRegiao, nLinPro, lReal )
			   	if (aInfo[18]) > 0               
			  		nLinha := GrupoF( nLinha,"TODAS",aInfo,lReal,.F. )
			  	endif   
               
                nLinha += IncLinha(1)
                nLinha := LinhaHorz(nLinha, 1,1)      
                nLinha += IncLinha(1)
                  
               IncProc("Imprimindo PSV9...")   
            next _XU
         next _XZ   
      next _XY
   endif   
endif

if nRelato == REPRE 

   //Representante
   aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, lReal )
   nLinha := GrupoN( nLinha, "REPRESENTANTE", aInfo, lReal )

   //Vendas por Linha
   if nLinPro = TLINHAS .or. nLinPro = HOSPIT     
      //Imprimo somente se tiver valor para a meta ou realizado     
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, HOSPIT, lReal )
      if (aInfo[1]+aInfo[4]) > 0               
         nLinha := GrupoN( nLinha,"HOSPITALAR",aInfo,lReal,.F. )
      endif   
   endif
   if nLinPro = TLINHAS .or. nLinPro = DOMEST
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, DOMEST, lReal )
      if (aInfo[1]+aInfo[4]) > 0               
         nLinha := GrupoN( nLinha,"DOMESTICA",aInfo,lReal,.F. )
      endif   
   endif
   if nLinPro = TLINHAS .or. nLinPro = INSTIT       
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, INSTIT, lReal )
      if (aInfo[1]+aInfo[4]) > 0               
         nLinha := GrupoN( nLinha,"INSTITUCIONAL",aInfo,lReal,.F. )
      endif   
   endif
   
   	nLinha += IncLinha(1)
   //FATURAMENTO
   //Vendas por Linha
   if nLinPro = TLINHAS .or. nLinPro = HOSPIT     
      //Imprimo somente se tiver valor para a meta ou realizado     
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, HOSPIT, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"HOSPITALAR",aInfo,lReal,.F. )
  	endif   
   endif
   if nLinPro = TLINHAS .or. nLinPro = DOMEST
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, DOMEST, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"DOMESTICA",aInfo,lReal,.F. )
  	endif   
   endif
   if nLinPro = TLINHAS .or. nLinPro = INSTIT       
      aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, INSTIT, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"INSTITUCIONAL",aInfo,lReal,.F. )
  	endif   
   endif
   	nLinha += IncLinha(1)
   	aInfo := Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, lReal )
   	if (aInfo[18]) > 0               
  		nLinha := GrupoF( nLinha,"TODAS",aInfo,lReal,.F. )
  	endif   

endif


if nRelato <> DIRET 

	If nRelato <> COORD
	
		//cQuery Clientes que compraram no mes anterior
		cQuery := SqlMesAnt(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinha,lReal)
		if Select("ANT") > 0
			ANT->(DbCloseArea())
		endif
		
		TCQUERY cQuery NEW ALIAS "ANT"
		//TCSetField("ANT", "DTUPED" , "D")
		
		if !ANT->(EOF()) 
		   oPrinter:EndPage()
		   oPrinter:StartPage()
		   nLinha := Cabecalho()
		   nLinha := TextoHorz(nLinha, 1,1, "Lista número (1)", CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := TextoHorz(nLinha, 1,1, cTitulo1, CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelo Volume do mês anterior do maior para o menor -", CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := LinhaHorz(nLinha, 1,1)                  			
	
		   nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
		   nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
		   if nRelato == COORD
		      nLinha := TextoHorz(nLinha, 12,06, "Repres"    , ESQUERDA)	   
		   endif
	      for _XY := 1 to Len(aMeses120)
		      nLinha := TextoHorz(nLinha, 12,(7+_XY), Left(aMeses120[_XY,1],3)+"/"+Right(aMeses120[_XY,1],2), DIREITA)	   
		   next _XY
		   nLinha := TextoHorz(nLinha, 12,12, "Vend.Atual"  , DIREITA)   
	
		   nLinha += IncLinha(1)
		   nLinha := LinhaHorz(nLinha, 1,1)
		
		   while !ANT->(EOF()) 
		      if nLinha+1.5 >= nVPage           
		         oPrinter:EndPage()
		         oPrinter:StartPage()
				   nLinha := Cabecalho()
				   nLinha := TextoHorz(nLinha, 1,1, "Lista número (1) - Continua...", CENTRO,,oFont14N:oFont)
				   nLinha += IncLinha(1)
				   nLinha := TextoHorz(nLinha, 1,1, cTitulo1, CENTRO,,oFont14N:oFont)
				   nLinha += IncLinha(1)
				   nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelo Volume do mês anterior do maior para o menor -", CENTRO,,oFont14N:oFont)
				   nLinha += IncLinha(1)
				   nLinha := LinhaHorz(nLinha, 1,1)                  		
	
		         nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
	      	   nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
	      	   if nRelato == COORD
	      	      nLinha := TextoHorz(nLinha, 12,06, "Repres"    , ESQUERDA)	   
	      	   endif
	            for _XY := 1 to Len(aMeses120)
	      	      nLinha := TextoHorz(nLinha, 12,(7+_XY), Left(aMeses120[_XY,1],3)+"/"+Right(aMeses120[_XY,1],2), DIREITA)	   
	      	   next _XY
	      	   nLinha := TextoHorz(nLinha, 12,12, "Vend.Atual"  , DIREITA)   
	
		         nLinha += IncLinha(1)
		         nLinha := LinhaHorz(nLinha, 1,1)         
		      endif
		      nLinha := TextoHorz(nLinha, 12,01, ANT->CLIENTE+"/"+ANT->LOJA,  ESQUERDA,,oFont10:oFont)
		      nLinha := TextoHorz(nLinha, 12,02, "("+ANT->UF+") "+LEFT(ANT->NOME,34), ESQUERDA,Cm2Px(7))	      
		      if nRelato == COORD     
		         nLinha := TextoHorz(nLinha, 12,06, ANT->REP, ESQUERDA,Cm2Px(4))
		      endif   
	         for _XY := 1 to Len(aMeses120)
		         nLinha := TextoHorz(nLinha, 12,(7+_XY), Transform(&("ANT->"+aMeses120[_XY,1]),"@E 999,999.99"), DIREITA)	   
		      next _XY      
		      nLinha := TextoHorz(nLinha, 12,12, Transform(ANT->MESATUAL,"@E 999,999.99"), DIREITA)      
	
		      nLinha += IncLinha(1)      
		      ANT->(DbSkip())
		   end
		endif
		
		ANT->(DbCloseArea())
	
	
		//cQuery Clientes Ativos
		cQuery := SqlAtivo(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinha,lReal)
		if Select("ATIV") > 0
			ATIV->(DbCloseArea())
		endif
		
		MemoWrite("C:\Temp\SqlAtivo.SQL",cQuery)
		
		TCQUERY cQuery NEW ALIAS "ATIV"
		//TCSetField("ATIV" , "DTUPED" , "D")
		
		if !ATIV->(EOF()) 
		   oPrinter:EndPage()
		   oPrinter:StartPage()
		   nLinha := Cabecalho()
		   nLinha := TextoHorz(nLinha, 1,1, "Lista de número (2)", CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := TextoHorz(nLinha, 1,1, cTitulo2, CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelos Clientes que NÃO compram a mais tempo -", CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)   
		   nLinha := LinhaHorz(nLinha, 1,1)                  
		
		   nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
		   nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
		   if nRelato == COORD
		      nLinha := TextoHorz(nLinha, 12,06, "Repres"    , ESQUERDA)	   
		   endif
	
	      for _XY := 1 to Len(aMeses120)
		      nLinha := TextoHorz(nLinha, 12,(7+_XY), Left(aMeses120[_XY,1],3)+"/"+Right(aMeses120[_XY,1],2), DIREITA)	   
		   next _XY
	
		   nLinha := TextoHorz(nLinha, 12,12, "Vend.Atual"  , DIREITA)   
		   nLinha += IncLinha(1)
		   nLinha := LinhaHorz(nLinha, 1,1)
		   while !ATIV->(EOF()) 
		      if nLinha+1.5 >= nVPage           
		         oPrinter:EndPage()
		         oPrinter:StartPage()
		         nLinha  := Cabecalho()+IncLinha(1)
	   	      nLinha := TextoHorz(nLinha, 1,1, "Lista número (2) - Continua...", CENTRO,,oFont14N:oFont)
		         nLinha += IncLinha(1)
		         nLinha := TextoHorz(nLinha, 1,1, cTitulo2, CENTRO,,oFont14N:oFont)
		         nLinha += IncLinha(1)
		         nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelos Clientes que NÃO compram a mais tempo -", CENTRO,,oFont14N:oFont)
	      	   nLinha += IncLinha(1)   
		         nLinha := LinhaHorz(nLinha, 1,1)                  
	
	      	   nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
		         nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
	      	   
		         if nRelato == COORD
		            nLinha := TextoHorz(nLinha, 12,06, "Repres"    , ESQUERDA)	   
	       	   endif
	
	      		for _XY := 1 to Len(aMeses120)
	      	      nLinha := TextoHorz(nLinha, 12,(7+_XY), Left(aMeses120[_XY,1],3)+"/"+Right(aMeses120[_XY,1],2), DIREITA)	   
	      	   next _XY
		         nLinha := TextoHorz(nLinha, 12,12, "Vend.Atual"  , DIREITA)   
	
		         nLinha += IncLinha(1)
		         nLinha := LinhaHorz(nLinha, 1,1)         
		      endif
		      nLinha := TextoHorz(nLinha, 12,01, ATIV->CLIENTE+"/"+ATIV->LOJA,  ESQUERDA,,oFont10:oFont)
		      nLinha := TextoHorz(nLinha, 12,02, "("+ATIV->UF+") "+LEFT(ATIV->NOME,34), ESQUERDA,Cm2Px(7))	      
		      if nRelato == COORD     
		         nLinha := TextoHorz(nLinha, 12,06, ATIV->REP,   ESQUERDA,Cm2Px(4))
		      endif   
	         for _XY := 1 to Len(aMeses120)
		         nLinha := TextoHorz(nLinha, 12,(7+_XY), Transform(&("ATIV->"+aMeses120[_XY,1]),"@E 999,999.99"), DIREITA)	   
		      next _XY      
		      nLinha := TextoHorz(nLinha, 12,12, Transform(ATIV->MESATUAL,"@E 999,999.99"), DIREITA)      
		      nLinha += IncLinha(1)      
		      ATIV->(DbSkip())
		   end
		endif
		
		ATIV->(DbCloseArea())
		
		//cQuery Clientes Inativos
		cQuery := SqlInativo(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinha,lReal)
		if Select("INAT") > 0
			INAT->(DbCloseArea())
		endif
		TCQUERY cQuery NEW ALIAS "INAT"
		TCSetField("INAT" , "DATAUP" , "D")
		
		if !INAT->(EOF()) 
		   oPrinter:EndPage()
		   oPrinter:StartPage()
		   nLinha := Cabecalho()
		   nLinha := TextoHorz(nLinha, 1,1, "Lista número (3)", CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := TextoHorz(nLinha, 1,1, cTitulo3, CENTRO,,oFont14N:oFont)
	      nLinha += IncLinha(1)
	      nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelo campo 'Dt.Ult.Ped.' do mais recente para o mais antigo -", CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := LinhaHorz(nLinha, 1,1)                  
		
		   nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
		   nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
		   if nRelato == COORD
		      nLinha := TextoHorz(nLinha, 12,06, "Repres"  , ESQUERDA)	   
		   endif
	      nLinha := TextoHorz(nLinha, 12,08, "Penult.Ped", DIREITA)	   
	      nLinha := TextoHorz(nLinha, 12,09, "Ult.Pedido", DIREITA)	         
	      nLinha := TextoHorz(nLinha, 12,10, "Dt.Ult.Ped", CENTRO )
		   nLinha := TextoHorz(nLinha, 12,11, "Vend.Atual", DIREITA)   
	
		   nLinha += IncLinha(1)
		   nLinha := LinhaHorz(nLinha, 1,1)
		
		   while !INAT->(EOF()) 
		      if nLinha+1.5 >= nVPage           
		         oPrinter:EndPage()
		         oPrinter:StartPage()
	
				   nLinha := Cabecalho()
				   nLinha := TextoHorz(nLinha, 1,1, "Lista número (3) - Continua...", CENTRO,,oFont14N:oFont)
				   nLinha += IncLinha(1)
				   nLinha := TextoHorz(nLinha, 1,1, cTitulo3, CENTRO,,oFont14N:oFont)
			      nLinha += IncLinha(1)
			      nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelo campo 'Dt.Ult.Ped.' do mais recente para o mais antigo -", CENTRO,,oFont14N:oFont)
				   nLinha += IncLinha(1)
				   nLinha := LinhaHorz(nLinha, 1,1)                  		
	
		         nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
	      	   nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
	      	   if nRelato == COORD
	      	      nLinha := TextoHorz(nLinha, 12,06, "Repres"  , ESQUERDA)	   
	      	   endif
	            nLinha := TextoHorz(nLinha, 12,08, "Penult.Ped", DIREITA)	   
	            nLinha := TextoHorz(nLinha, 12,09, "Ult.Pedido", DIREITA)	         
	            nLinha := TextoHorz(nLinha, 12,10, "Dt.Ult.Ped", CENTRO )
	      	   nLinha := TextoHorz(nLinha, 12,11, "Vend.Atual", DIREITA)         
	
		         nLinha += IncLinha(1)
		         nLinha := LinhaHorz(nLinha, 1,1)         
		      endif
		      nLinha := TextoHorz(nLinha, 12,01, INAT->CLIENTE+"/"+INAT->LOJA,  ESQUERDA,,oFont10:oFont)
		      nLinha := TextoHorz(nLinha, 12,02, "("+INAT->UF+") "+LEFT(INAT->NOME,34), ESQUERDA,Cm2Px(7))	      
		      if nRelato == COORD     
		         nLinha := TextoHorz(nLinha, 12,06, INAT->REP,   ESQUERDA,Cm2Px(4))
		      endif   
	         nLinha := TextoHorz(nLinha, 12,08, Transform(INAT->VOLUMEPP,"@E 999,999.99"), DIREITA)	   
	         nLinha := TextoHorz(nLinha, 12,09, Transform(INAT->VOLUMEUP,"@E 999,999.99"), DIREITA)	   
	         nLinha := TextoHorz(nLinha, 12,10, DtoC(INAT->DATAUP), CENTRO)	                     
		      nLinha := TextoHorz(nLinha, 12,11, Transform(INAT->MESATUAL,"@E 999,999.99"), DIREITA)      
	
		      nLinha += IncLinha(1)      
		      INAT->(DbSkip())
		   end
		endif   
		
		INAT->(DbCloseArea())
	
	
	   //Lista de Prospecção
	   cQuery := SqlProsp(nRelato,cCod)
		if Select("PRO") > 0
			PRO->(DbCloseArea())
		endif
		
		TCQUERY cQuery NEW ALIAS "PRO"
		
		if !PRO->(EOF()) 
		   oPrinter:EndPage()
		   oPrinter:StartPage()
		   nLinha := Cabecalho()
		   nLinha := TextoHorz(nLinha, 1,1, "Lista número (4)", CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := TextoHorz(nLinha, 1,1, cTitulo4, CENTRO,,oFont14N:oFont)
		   nLinha += IncLinha(1)
		   nLinha := LinhaHorz(nLinha, 1,1)                  			
	
		   nLinha := TextoHorz(nLinha, 12,01, "Cliente", ESQUERDA,,oFont10N:oFont)
		   nLinha := TextoHorz(nLinha, 12,02, "Loja"   , ESQUERDA)
		   nLinha := TextoHorz(nLinha, 12,03, "Nome"   , ESQUERDA)
	      nLinha := TextoHorz(nLinha, 12,07, "UF"     , ESQUERDA)	   
	      nLinha := TextoHorz(nLinha, 12,08, "Segmento"     , ESQUERDA)	         
		   if nRelato == COORD
		      nLinha := TextoHorz(nLinha, 12,11, "Repres"    , ESQUERDA)	   
		   endif
	
		   nLinha += IncLinha(1)
		   nLinha := LinhaHorz(nLinha, 1,1)
		
		   while !PRO->(EOF()) 
		      if nLinha+1.5 >= nVPage           
		         oPrinter:EndPage()
		         oPrinter:StartPage()
				   nLinha := Cabecalho()
				   nLinha := TextoHorz(nLinha, 1,1, "Lista número (4) - Continua...", CENTRO,,oFont14N:oFont)
				   nLinha += IncLinha(1)
				   nLinha := TextoHorz(nLinha, 1,1, cTitulo4, CENTRO,,oFont14N:oFont)
				   nLinha += IncLinha(1)
				   nLinha := LinhaHorz(nLinha, 1,1)                  		
	
		         nLinha := TextoHorz(nLinha, 12,01, "Cliente", ESQUERDA,,oFont10N:oFont)
	      	   nLinha := TextoHorz(nLinha, 12,02, "Loja"   , ESQUERDA)
	      	   nLinha := TextoHorz(nLinha, 12,03, "Nome"   , ESQUERDA)
	            nLinha := TextoHorz(nLinha, 12,07, "UF"     , ESQUERDA)	   
	            nLinha := TextoHorz(nLinha, 12,08, "Segmento"     , ESQUERDA)	         
	      	   if nRelato == COORD
	      	      nLinha := TextoHorz(nLinha, 12,11, "Repres"    , ESQUERDA)	   
	      	   endif
		         nLinha += IncLinha(1)
		         nLinha := LinhaHorz(nLinha, 1,1)         
		      endif
		      nLinha := TextoHorz(nLinha, 12,01, PRO->CLIENTE , ESQUERDA,,oFont10:oFont)
		      nLinha := TextoHorz(nLinha, 12,02, PRO->LOJA    , ESQUERDA)
		      nLinha := TextoHorz(nLinha, 12,03, PRO->NOME    , ESQUERDA,Cm2Px(7))	      
		      nLinha := TextoHorz(nLinha, 12,07, PRO->UF      , ESQUERDA)	      
		      nLinha := TextoHorz(nLinha, 12,08, LEFT(AllTrim(PRO->SEGMENTO),28), ESQUERDA, Cm2Px(4))	      
		      if nRelato == COORD     
		         nLinha := TextoHorz(nLinha, 12,11, LEFT(PRO->REP,20), ESQUERDA,Cm2Px(4))
		      endif   
		      nLinha += IncLinha(1)      
		      PRO->(DbSkip())
		   end
		endif
		
		PRO->(DbCloseArea())
	   
		endif
	EndIf
//Lista de pedidos em aberto
///***********************
	cQuery := SqlPDAberto(nRelato,cCod)
	if Select("ABER") > 0
		ABER->(DbCloseArea())
	endif
	TCQUERY cQuery NEW ALIAS "ABER"
	TCSetField("ABER" , "C5_EMISSAO" , "D")
	
	if !ABER->(EOF()) 
	   oPrinter:EndPage()
	   oPrinter:StartPage()
	   nLinha := Cabecalho()
	   nLinha := TextoHorz(nLinha, 1,1, "Lista de número (5)", CENTRO,,oFont14N:oFont)
	   nLinha += IncLinha(1)
	   nLinha := TextoHorz(nLinha, 1,1, cTitulo5, CENTRO,,oFont14N:oFont)
	   nLinha += IncLinha(1)
	   //nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelos Clientes que NÃO compram a mais tempo -", CENTRO,,oFont14N:oFont)
	   //nLinha += IncLinha(1)   
	   nLinha := LinhaHorz(nLinha, 1,1)                  
	
	   nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
	   nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
	   nLinha := TextoHorz(nLinha, 12,06, "Repres"    	, ESQUERDA)	   
	   nLinha := TextoHorz(nLinha, 12,08, "Pedido"  	, ESQUERDA)   
	   nLinha := TextoHorz(nLinha, 12,09, "Emissão"  	, ESQUERDA)   
	   nLinha := TextoHorz(nLinha, 12,10, "Q. Dias"  	, DIREITA)   
	   nLinha := TextoHorz(nLinha, 12,11, "Valor"  		, DIREITA)   
	   /*
	   if nRelato == COORD
	      nLinha := TextoHorz(nLinha, 12,06, "Repres"    , ESQUERDA)	   
	   endif
	   */
	   /*
      for _XY := 1 to Len(aMeses120)
	      nLinha := TextoHorz(nLinha, 12,(7+_XY), Left(aMeses120[_XY,1],3)+"/"+Right(aMeses120[_XY,1],2), DIREITA)	   
	   next _XY
	   */
	   
	   nLinha += IncLinha(1)
	   nLinha := LinhaHorz(nLinha, 1,1)
	   while !ABER->(EOF()) 
	     
	      if nLinha+1.5 >= nVPage           
		 
		      oPrinter:EndPage()
		      oPrinter:StartPage()
		      nLinha  := Cabecalho()+IncLinha(1)
	   	      nLinha := TextoHorz(nLinha, 1,1, "Lista número (5) - Continua...", CENTRO,,oFont14N:oFont)
		      nLinha += IncLinha(1)
		      nLinha := TextoHorz(nLinha, 1,1, cTitulo5, CENTRO,,oFont14N:oFont)
		      nLinha += IncLinha(1)
		        // nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelos Clientes que NÃO compram a mais tempo -", CENTRO,,oFont14N:oFont)
	      	  //nLinha += IncLinha(1)   
		      nLinha := LinhaHorz(nLinha, 1,1)                  
	
			  nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj"	, ESQUERDA,,oFont10N:oFont)
			  nLinha := TextoHorz(nLinha, 12,02, "Nome"      	, ESQUERDA)
			  nLinha := TextoHorz(nLinha, 12,06, "Repres"    	, ESQUERDA)	   
			  nLinha := TextoHorz(nLinha, 12,08, "Pedido"  		, ESQUERDA)   
			  nLinha := TextoHorz(nLinha, 12,09, "Emissão"  	, ESQUERDA)   
			  nLinha := TextoHorz(nLinha, 12,10, "Q. Dias"  	, DIREITA)   
			  nLinha := TextoHorz(nLinha, 12,11, "Valor"  		, DIREITA)   
	
		      nLinha += IncLinha(1)
		      nLinha := LinhaHorz(nLinha, 1,1)         
	      
	      endif
	      
	      nLinha := TextoHorz(nLinha, 12,01, ABER->C5_CLIENTE+"/"+ABER->C5_LOJACLI,  ESQUERDA,,oFont10:oFont)
	      nLinha := TextoHorz(nLinha, 12,02, LEFT(ABER->A1_NOME,34), ESQUERDA,Cm2Px(7))	      
	      
	      nLinha := TextoHorz(nLinha, 12,06, ABER->A3_NREDUZ,   ESQUERDA,Cm2Px(4))
	      nLinha := TextoHorz(nLinha, 12,08, ABER->C5_NUM,   ESQUERDA,Cm2Px(4))
	      nLinha := TextoHorz(nLinha, 12,09, DtoC(ABER->C5_EMISSAO),   ESQUERDA,Cm2Px(4))
	      nLinha := TextoHorz(nLinha, 12,10, Transform(ABER->C5_EMISSAO - dDataBase,"@E 999,999.99"), DIREITA)      
	      nLinha := TextoHorz(nLinha, 12,11, Transform(ABER->TOTPED,"@E 999,999.99"), DIREITA)      
	      nLinha += IncLinha(1)      
	      ABER->(DbSkip())
	   end
	endif
	
	ABER->(DbCloseArea())
	
///***********************
//Lista de pedidos em Rejeitados pelo Financeiro
///***********************
	cQuery := SqlPDrej(nRelato,cCod)
	if Select("REJ") > 0
		REJ->(DbCloseArea())
	endif
	TCQUERY cQuery NEW ALIAS "REJ"
	TCSetField("REJ" , "C5_EMISSAO" , "D")
	
	if !REJ->(EOF()) 
	   //oPrinter:EndPage()
	   //oPrinter:StartPage()
	   //nLinha := Cabecalho()
	   //nLinha := TextoHorz(nLinha, 1,1, "Lista de número (5)", CENTRO,,oFont14N:oFont)
	   //nLinha += IncLinha(1)
	   //nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelos Clientes que NÃO compram a mais tempo -", CENTRO,,oFont14N:oFont)
	   //nLinha += IncLinha(1)   
	   nLinha += IncLinha(1)
	   nLinha := TextoHorz(nLinha, 1,1, "Lista de pedidos em análise pelo Financeiro", CENTRO,,oFont14N:oFont)
	   nLinha += IncLinha(1)
	   nLinha := LinhaHorz(nLinha, 1,1)                  
	
	   nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj", ESQUERDA,,oFont10N:oFont)
	   nLinha := TextoHorz(nLinha, 12,02, "Nome"      , ESQUERDA)
	   nLinha := TextoHorz(nLinha, 12,06, "Repres"    	, ESQUERDA)	   
	   nLinha := TextoHorz(nLinha, 12,08, "Pedido"  	, ESQUERDA)   
	   nLinha := TextoHorz(nLinha, 12,09, "Emissão"  	, ESQUERDA)   
	   nLinha := TextoHorz(nLinha, 12,10, "Q. Dias"  	, DIREITA)   
	   nLinha := TextoHorz(nLinha, 12,11, "Valor"  		, DIREITA)   
	   
	   nLinha += IncLinha(1)
	   nLinha := LinhaHorz(nLinha, 1,1)
	   while !REJ->(EOF()) 
	     
	      if nLinha+1.5 >= nVPage           
		 
		      oPrinter:EndPage()
		      oPrinter:StartPage()
		      nLinha  := Cabecalho()+IncLinha(1)
	   	      nLinha := TextoHorz(nLinha, 1,1, "Lista número (5) - Continua...", CENTRO,,oFont14N:oFont)
		      nLinha += IncLinha(1)
		      nLinha := TextoHorz(nLinha, 1,1, "Lista de pedidos em análise pelo Financeiro", CENTRO,,oFont14N:oFont)
		      nLinha += IncLinha(1)
		        // nLinha := TextoHorz(nLinha, 1,1, "- Ordenado pelos Clientes que NÃO compram a mais tempo -", CENTRO,,oFont14N:oFont)
	      	  //nLinha += IncLinha(1)   
		      nLinha := LinhaHorz(nLinha, 1,1)                  
	
			  nLinha := TextoHorz(nLinha, 12,01, "Cliente/Lj"	, ESQUERDA,,oFont10N:oFont)
			  nLinha := TextoHorz(nLinha, 12,02, "Nome"      	, ESQUERDA)
			  nLinha := TextoHorz(nLinha, 12,06, "Repres"    	, ESQUERDA)	   
			  nLinha := TextoHorz(nLinha, 12,08, "Pedido"  		, ESQUERDA)   
			  nLinha := TextoHorz(nLinha, 12,09, "Emissão"  	, ESQUERDA)   
			  nLinha := TextoHorz(nLinha, 12,10, "Q. Dias"  	, DIREITA)   
			  nLinha := TextoHorz(nLinha, 12,11, "Valor"  		, DIREITA)   
	
		      nLinha += IncLinha(1)
		      nLinha := LinhaHorz(nLinha, 1,1)         
	      
	      endif
	      
	      nLinha := TextoHorz(nLinha, 12,01, REJ->C9_CLIENTE+"/"+REJ->C9_LOJA,  ESQUERDA,,oFont10:oFont)
	      nLinha := TextoHorz(nLinha, 12,02, LEFT(REJ->A1_NOME,34), ESQUERDA,Cm2Px(7))	      
	      
	      nLinha := TextoHorz(nLinha, 12,06, REJ->A3_NREDUZ,   ESQUERDA,Cm2Px(4))
	      nLinha := TextoHorz(nLinha, 12,08, REJ->C9_PEDIDO,   ESQUERDA,Cm2Px(4))
	      nLinha := TextoHorz(nLinha, 12,09, DtoC(REJ->C5_EMISSAO),   ESQUERDA,Cm2Px(4))
	      nLinha := TextoHorz(nLinha, 12,10, Transform(REJ->C5_EMISSAO - dDataBase,"@E 999,999.99"), DIREITA)      
	      nLinha := TextoHorz(nLinha, 12,11, Transform(REJ->TOTAL,"@E 999,999.99"), DIREITA)      
	      nLinha += IncLinha(1)      
	      //nLinha := TextoHorz(nLinha, 12,01, REJ->C9_OBSREJ,  ESQUERDA,,oFont10:oFont)
	      If REJ->C5_CONDPAG = '001'
	      	nLinha := TextoHorz(nLinha, 12,02, "PEDIDO ANTECIPADO", ESQUERDA,Cm2Px(12))
	      	nLinha += IncLinha(1)      
	      Else
	      	If REJ->C9_BLCRED = '09'
	      		nLinha := TextoHorz(nLinha, 12,02, 'REJEIT. CREDITO - ' + REJ->C9_OBSREJ, ESQUERDA,Cm2Px(12))
	      		nLinha += IncLinha(1)
	      	EndIf      
	      EndIf
	      nLinha += IncLinha(1)
	      
	      REJ->(DbSkip())
	   end
	endif
	
	REJ->(DbCloseArea())

oPrinter:EndPage() //Fim do arquivo
oPrinter:Print()   //gera o arquivo pdf
Sleep(5000)
FreeObj(oPrinter)
oPrinter := Nil
cCopia	:= "informatica@ravaembalagens.com.br"
//aAnexo	:= 
if !lPreview
	cCorpo := "Posição de Vendas 9.0"
   //U_SendPSV(cEmail, cCopia, "Posição de Vendas 9.0 - "+cTit, cCorpo, cDirC, wnRel+".pdf" ) 
   //fEnvMail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)
   aAnexos := {}
   AADD(aAnexos, cDirC + wnRel + ".pdf")
   U_fEnvMail(cEmail, "Posição de Vendas 9.0 - "+cTit, cCorpo, aAnexos, .T., .F.)  
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

**********************************
static function fMesAnt(nMes,nAno)
**********************************

local aRet := {}
local dDtAnt  := CtoD( "01/"+StrZero(nMes,2)+"/"+Str(nAno) )-1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


**********************************
static function fMAtual(nMes,nAno)
**********************************

local aRet := {}
local cIni    := DtoS( CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno) ) )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


**********************************
static function fMAnter(nMes,nAno)
**********************************

local aRet := {}
local dDtAnt  := CtoD( "01/"+StrZero(nMes,2)+"/"+Str(nAno) )-1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


***********************************
static function f120Dias(nMes,nAno)
***********************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+StrZero(nMes,2)+"/"+Str(nAno) ) - 1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) - 90 )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


************************************
static function fMeses120(nMes,nAno)
************************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+StrZero(nMes,2)+"/"+Str(nAno) ) - 1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) - 90 )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )
Local aMES    := { 'JAN','FEV','MAR','ABR','MAI','JUN',;
                   'JUL','AGO','SET','OUT','NOV','DEZ' }
while Left(cIni,6) <= Left(cFim,6)
   Aadd( aRet, { aMes[Month(StoD(cIni))]+Right(Str(Year(StoD(cIni))),2) , AllTrim(Str(Year(StoD(cIni)))+StrZero(Month(StoD(cIni)),2)) } )
   cIni := DtoS( StoD( cIni ) + 31 )
end

return aRet


**************************************************************************
static function SqlMesAnt(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinha,lReal)
**************************************************************************

local cQuery
local aMesAnt   := fMAnter(nMes,nAno)
local aMesAtu   := fMAtual(nMes,nAno)
local a120Dias  := f120Dias(nMes,nAno)
local aMeses120 := fMeses120(nMes,nAno)

//Clientes COMPRARAM NO MES ANTERIOR

cQuery := "SELECT "
cQuery += "   CLIENTE, "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   REP, "
cQuery += "   UF, "
for _X := 1 to Len(aMeses120)
   cQuery += "   "+aMeses120[_X,1]+", "
next _X
cQuery += "   MESATUAL "
cQuery += "FROM "
cQuery += "( "
cQuery += "SELECT "
cQuery += "   CLIENTE, "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   REP, "
cQuery += "   UF, "
for _X := 1 to Len(aMeses120)
   cQuery += "   "+aMeses120[_X,1]+" = SUM(CASE WHEN ANOMES = '"+aMeses120[_X,2]+"' THEN VENDIDO ELSE 0 END ), "
next _X
cQuery += "MESATUAL = ISNULL((SELECT "
if !lReal
   cQuery += "                   SUM(SC9U.C9_QTDLIB*SB1U.B1_PESO) "
else   
   cQuery += "                   SUM((SC9U.C9_QTDLIB * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                   FROM "
cQuery += "                      "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "+RetSqlName("SC9")+" SC9U, "
cQuery += "                      "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                   WHERE "
cQuery += "                      SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                      SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                      SC6U.C6_FILIAL = SC9U.C9_FILIAL AND "                       
cQuery += "                      SC9U.C9_PEDIDO = SC6U.C6_NUM AND SC9U.C9_ITEM = SC6U.C6_ITEM AND SC9U.C9_PEDIDO = SC5U.C5_NUM AND "
cQuery += "                      SC9U.C9_BLCRED <> '09' AND "
cQuery += "                      SC6U.C6_BLQ <> 'R' AND "//"SB1U.B1_TIPO = 'PA' AND "
cQuery += "                      SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                      SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
                                 //Periodo que compreende o mes Atual 
cQuery += "                      SC5U.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "                      SC5U.C5_EMISSAO BETWEEN '"+aMesAtu[1]+"' AND '"+aMesAtu[2]+"' AND "
cQuery += "                      SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "                      SB1U.B1_SETOR <> '39' AND "

											if nLinha <> TLINHAS
											   if nLinha == DOMEST
											      cQuery += "             SB1U.B1_GRUPO IN('D','E') AND "
											   elseif nLinha == INSTIT
											      cQuery += "             SB1U.B1_GRUPO IN('A','B','G') AND "
											   elseif nLinha == HOSPIT
											      cQuery += "             SB1U.B1_GRUPO IN('C') AND "
											   endif   
											endif
											
											if cUF <> nil .and. !Empty(cUF)
											   cQuery += "SA1U.A1_EST = '"+cUF+"' AND "
											endif
											
											if nRegiao == NORTE
											   cQuery += "SA1U.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
											elseif nRegiao == NORDESTE
											   cQuery += "SA1U.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
											elseif nRegiao == COESTE
											   cQuery += "SA1U.A1_EST IN ('GO','MT','MS','DF') AND "
											elseif nRegiao == SUDESTE
											   cQuery += "SA1U.A1_EST IN ('MG','ES','RJ','SP') AND "
											elseif nRegiao == SUL
											   cQuery += "SA1U.A1_EST IN ('RS','PR','SC') AND "
											endif
											
											if nRelato == REPRE
											   cQuery += "SA1U.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
											elseif nRelato == COORD
											   cQuery += "( RTRIM(SA3U.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1U.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
											   cQuery += " EXISTS( SELECT A3_SUPER "
											   cQuery += "         FROM "+RetSqlName("SA3")+" "
											   cQuery += "         WHERE A3_COD = SA1U.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1U.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
											endif

cQuery += "                      SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                      SB1U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC5U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC6U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC9U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SE4U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery += "FROM "
cQuery += "(  "
cQuery += "   SELECT "
cQuery += "       ANOMES = LEFT(SC5.C5_EMISSAO,6), "
cQuery += "      CLIENTE = SA1.A1_COD, "
cQuery += "         LOJA = SA1.A1_LOJA, "
cQuery += "         NOME = RTRIM(SA1.A1_NOME), "
cQuery += "          REP = RTRIM(SA3.A3_NREDUZ), "
cQuery += "           UF = SA1.A1_EST, "
if !lReal
   cQuery += "   VENDIDO   = SUM(SC6.C6_QTDVEN*SB1.B1_PESO) "
else   
   cQuery += "   VENDIDO   = SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC) "
endif
cQuery += "   FROM "
cQuery += "      "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "      "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4 "
cQuery += "   WHERE "
cQuery += "      SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "      SC6.C6_BLQ <> 'R' AND "//"SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "      SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.A1_ATIVO <> 'N' AND "
                 //Periodo que compreende os 120 dias
cQuery += "      SC5.C5_CLIENTE  NOT IN ('006543','007005') AND "
cQuery += "      SC5.C5_EMISSAO BETWEEN '"+a120Dias[1]+"' AND '"+a120Dias[2]+"' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "      SB1.B1_SETOR <> '39' AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "SB1.B1_GRUPO IN('C') AND "
   endif   
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "SA1.A1_EST = '"+cUF+"' AND "
endif

if nRegiao == NORTE
   cQuery += "SA1.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "SA1.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "SA1.A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "SA1.A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "SA1.A1_EST IN ('RS','PR','SC') AND "
endif

if nRelato == REPRE
   cQuery += "SA1.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
elseif nRelato == COORD
   cQuery += "( RTRIM(SA3.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SA1.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "      SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "      EXISTS( SELECT "
cQuery += "                     SC5X.C5_FILIAL "
cQuery += "                  FROM "
cQuery += "                     "+RetSqlName("SB1")+" SB1X, "+RetSqlName("SC5")+" SC5X, "+RetSqlName("SC6")+" SC6X, "
cQuery += "                     "+RetSqlName("SA1")+" SA1X, "+RetSqlName("SA3")+" SA3X, "+RetSqlName("SE4")+" SE4X "
cQuery += "                  WHERE "
cQuery += "                     SC5X.C5_CLIENTE = SC5.C5_CLIENTE AND SC5X.C5_LOJACLI = SC5.C5_LOJACLI AND "
cQuery += "                     SC5X.C5_FILIAL = SC6X.C6_FILIAL AND "
cQuery += "                     SC6X.C6_BLQ <> 'R' AND "//"SB1X.B1_TIPO = 'PA' AND "
cQuery += "                     SC6X.C6_PRODUTO = SB1X.B1_COD AND SC5X.C5_NUM = SC6X.C6_NUM AND SA1X.A1_VEND = SA3X.A3_COD AND "
cQuery += "                     SC5X.C5_CLIENTE = SA1X.A1_COD AND SC5X.C5_LOJACLI = SA1X.A1_LOJA AND SA1X.A1_ATIVO <> 'N' AND "
                                //Periodo que compreende o mes Anterior
cQuery += "                     SC5X.C5_CLIENTE  NOT IN ('006543','007005') AND "
cQuery += "                     SC5X.C5_EMISSAO BETWEEN '"+aMesAnt[1]+"' AND '"+aMesAnt[2]+"' AND "
cQuery += "                     SC6X.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "                     SB1X.B1_SETOR <> '39' AND "

										   if nLinha <> TLINHAS
											   if nLinha == DOMEST
											      cQuery += "             SB1X.B1_GRUPO IN('D','E') AND "
											   elseif nLinha == INSTIT
											      cQuery += "             SB1X.B1_GRUPO IN('A','B','G') AND "
											   elseif nLinha == HOSPIT
											      cQuery += "             SB1X.B1_GRUPO IN('C') AND "
											   endif   
											endif
											
											if cUF <> nil .and. !Empty(cUF)
											   cQuery += "SA1X.A1_EST = '"+cUF+"' AND "
											endif
											
											if nRegiao == NORTE
											   cQuery += "SA1X.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
											elseif nRegiao == NORDESTE
											   cQuery += "SA1X.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
											elseif nRegiao == COESTE
											   cQuery += "SA1X.A1_EST IN ('GO','MT','MS','DF') AND "
											elseif nRegiao == SUDESTE
											   cQuery += "SA1X.A1_EST IN ('MG','ES','RJ','SP') AND "
											elseif nRegiao == SUL
											   cQuery += "SA1X.A1_EST IN ('RS','PR','SC') AND "
											endif
											
											if nRelato == REPRE
											   cQuery += "SA1X.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
											elseif nRelato == COORD
											   cQuery += "( RTRIM(SA3X.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1X.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
											   cQuery += " EXISTS( SELECT A3_SUPER "
											   cQuery += "         FROM "+RetSqlName("SA3")+" "
											   cQuery += "         WHERE A3_COD = SA1X.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1X.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
											endif

cQuery += "                     SC5X.C5_CONDPAG = SE4X.E4_CODIGO AND "
cQuery += "                     SB1X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC5X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC6X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SE4X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SA1X.D_E_L_E_T_ = ' '  ) AND "
cQuery += "      SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "      SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_VEND, A1_COD, A1_LOJA, RTRIM(A1_NOME), A1_EST, LEFT(SC5.C5_EMISSAO,6), RTRIM(A3_NREDUZ) "
cQuery += ") AS MESANT "
cQuery += "GROUP BY "
cQuery += "      CLIENTE,LOJA,NOME,UF,REP "
cQuery += ") AS MESANT "
cQuery += "WHERE "
cQuery += "   "+aMeses120[Len(aMeses120),1]+" > 0 "
cQuery += "ORDER BY "
cQuery += "   "+aMeses120[Len(aMeses120),1]+" DESC "

MemoWrite("C:\Temp\SqlMesAnt.sql", cQuery )
return cQuery


***************************************************************************
static function SqlInativo(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinha,lReal)
***************************************************************************

local cQuery

local aMesAnt := fMAnter(nMes,nAno)
local aMesAtu := fMAtual(nMes,nAno)
local aMes120 := f120Dias(nMes,nAno)

//Há 120 dias ou mais sem comprar

//MOSTRAR VOLUME DOS (2)DOIS ULTIMOS PEDIDOS E A DATA DO ULTIMO
cQuery := "SELECT "
cQuery += "   CLIENTE, "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   REP, "
cQuery += "   UF, "
cQuery += "   VOLUMEUP = "
cQuery += "              ISNULL((SELECT TOP 1 "
if !lReal
   cQuery += "                      SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                      SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                      FROM "
cQuery += "                         "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "
cQuery += "                         "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                      WHERE "
cQuery += "                         SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                         SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                         SC6U.C6_BLQ <> 'R' AND "//"SB1U.B1_TIPO = 'PA' AND "
cQuery += "                         SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                         SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
cQuery += "                         SC5U.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "                         SC5U.C5_EMISSAO <> '' AND SC5U.C5_EMISSAO < '"+aMesAtu[1]+"' AND "
cQuery += "                         SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "                         SB1U.B1_SETOR <> '39' AND "

   											if nLinha <> TLINHAS
   											   if nLinha == DOMEST
   											      cQuery += "             SB1U.B1_GRUPO IN('D','E') AND "
   											   elseif nLinha == INSTIT
   											      cQuery += "             SB1U.B1_GRUPO IN('A','B','G') AND "
   											   elseif nLinha == HOSPIT
   											      cQuery += "             SB1U.B1_GRUPO IN('C') AND "
   											   endif   
   											endif
											
   											if cUF <> nil .and. !Empty(cUF)
   											   cQuery += "SA1U.A1_EST = '"+cUF+"' AND "
   											endif
											
   											if nRegiao == NORTE
   											   cQuery += "SA1U.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
   											elseif nRegiao == NORDESTE
   											   cQuery += "SA1U.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
   											elseif nRegiao == COESTE
   											   cQuery += "SA1U.A1_EST IN ('GO','MT','MS','DF') AND "
   											elseif nRegiao == SUDESTE
   											   cQuery += "SA1U.A1_EST IN ('MG','ES','RJ','SP') AND "
   											elseif nRegiao == SUL
   											   cQuery += "SA1U.A1_EST IN ('RS','PR','SC') AND "
   											endif
											
   											if nRelato == REPRE
   											   cQuery += "SA1U.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
   											elseif nRelato == COORD
   											   cQuery += "( RTRIM(SA3U.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1U.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   											   cQuery += " EXISTS( SELECT A3_SUPER "
   											   cQuery += "         FROM "+RetSqlName("SA3")+" "
   											   cQuery += "         WHERE A3_COD = SA1U.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1U.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
   											endif											

cQuery += "                         SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                         SB1U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SC5U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SC6U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SE4U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SA1U.D_E_L_E_T_ = ' ' "
cQuery += "                      GROUP BY "
cQuery += "                         SC5U.C5_EMISSAO "
cQuery += "                      ORDER BY SC5U.C5_EMISSAO DESC ),0), "
cQuery += "   DATAUP, "
cQuery += "   VOLUMEPP = "
cQuery += "              ISNULL(( "
cQuery += "                      SELECT "
cQuery += "                         VENDIDO "
cQuery += "                      FROM "
cQuery += "                      (   "
cQuery += "                         SELECT "
cQuery += "                            ROWNUM = ROW_NUMBER() OVER (ORDER BY C5_EMISSAO DESC), "
if !lReal
   cQuery += "                         VENDIDO=SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                         VENDIDO=SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                         FROM "
cQuery += "                            "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U,"
cQuery += "                            "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                         WHERE "
cQuery += "                            SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                            SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                            SC6U.C6_BLQ <> 'R' AND "//"SB1U.B1_TIPO = 'PA' AND "
cQuery += "                            SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                            SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
cQuery += "                            SC5U.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "                            SC5U.C5_EMISSAO <> '' AND SC5U.C5_EMISSAO < '"+aMesAtu[1]+"' AND "
cQuery += "                            SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "                            SB1U.B1_SETOR <> '39' AND "
      											if nLinha <> TLINHAS
      											   if nLinha == DOMEST
      											      cQuery += "             SB1U.B1_GRUPO IN('D','E') AND "
      											   elseif nLinha == INSTIT
      											      cQuery += "             SB1U.B1_GRUPO IN('A','B','G') AND "
      											   elseif nLinha == HOSPIT
      											      cQuery += "             SB1U.B1_GRUPO IN('C') AND "
      											   endif   
      											endif
											
      											if cUF <> nil .and. !Empty(cUF)
      											   cQuery += "SA1U.A1_EST = '"+cUF+"' AND "
      											endif
											
      											if nRegiao == NORTE
      											   cQuery += "SA1U.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
      											elseif nRegiao == NORDESTE
      											   cQuery += "SA1U.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
      											elseif nRegiao == COESTE
      											   cQuery += "SA1U.A1_EST IN ('GO','MT','MS','DF') AND "
   	   										elseif nRegiao == SUDESTE
   		   									   cQuery += "SA1U.A1_EST IN ('MG','ES','RJ','SP') AND "
   			   								elseif nRegiao == SUL
   				   							   cQuery += "SA1U.A1_EST IN ('RS','PR','SC') AND "
   					   						endif
											
      											if nRelato == REPRE
      											   cQuery += "SA1U.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
   	   										elseif nRelato == COORD
   		   									   cQuery += "( RTRIM(SA3U.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1U.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   			   								   cQuery += " EXISTS( SELECT A3_SUPER "
   				   							   cQuery += "         FROM "+RetSqlName("SA3")+" "
   					   						   cQuery += "         WHERE A3_COD = SA1U.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1U.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
   						   					endif											

cQuery += "                            SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                            SB1U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SC5U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SC6U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SE4U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SA1U.D_E_L_E_T_ = ' ' "
cQuery += "                         GROUP BY "
cQuery += "                            C5_EMISSAO "
cQuery += "                      ) AS PENULTIMO WHERE ROWNUM = 2 ) ,0), "
cQuery += "   MESATUAL = "
cQuery += "              ISNULL((SELECT "
if !lReal
   cQuery += "                      SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                      SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                      FROM "
cQuery += "                         "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, " 
cQuery += "                         "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                      WHERE "
cQuery += "                         SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                         SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                         SC6U.C6_BLQ <> 'R' AND "//"SB1U.B1_TIPO = 'PA' AND "
cQuery += "                         SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                         SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
cQuery += "                         SC5U.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "                         SC5U.C5_EMISSAO BETWEEN '"+aMesAtu[1]+"' AND '"+aMesAtu[2]+"' AND "
cQuery += "                         SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "                         SB1U.B1_SETOR <> '39' AND "
   											if nLinha <> TLINHAS
   											   if nLinha == DOMEST
   											      cQuery += "             SB1U.B1_GRUPO IN('D','E') AND "
   											   elseif nLinha == INSTIT
   											      cQuery += "             SB1U.B1_GRUPO IN('A','B','G') AND "
   											   elseif nLinha == HOSPIT
   											      cQuery += "             SB1U.B1_GRUPO IN('C') AND "
   											   endif   
   											endif
											
   											if cUF <> nil .and. !Empty(cUF)
   											   cQuery += "SA1U.A1_EST = '"+cUF+"' AND "
   											endif
											
   											if nRegiao == NORTE
   											   cQuery += "SA1U.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
   											elseif nRegiao == NORDESTE
   											   cQuery += "SA1U.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
   											elseif nRegiao == COESTE
   											   cQuery += "SA1U.A1_EST IN ('GO','MT','MS','DF') AND "
   											elseif nRegiao == SUDESTE
   											   cQuery += "SA1U.A1_EST IN ('MG','ES','RJ','SP') AND "
   											elseif nRegiao == SUL
   											   cQuery += "SA1U.A1_EST IN ('RS','PR','SC') AND "
   											endif
											
   											if nRelato == REPRE
   											   cQuery += "SA1U.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
   											elseif nRelato == COORD
   											   cQuery += "( RTRIM(SA3U.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1U.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   											   cQuery += " EXISTS( SELECT A3_SUPER "
   											   cQuery += "         FROM "+RetSqlName("SA3")+" "
   											   cQuery += "         WHERE A3_COD = SA1U.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1U.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
   											endif											

cQuery += "                         SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                         SB1U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SC5U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SC6U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SE4U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery += "FROM  "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      CLIENTE,  "
cQuery += "      LOJA, "
cQuery += "      NOME, "
cQuery += "      REP, "
cQuery += "      UF, "
cQuery += "      DATAUP=MAX(DATAUP) "
cQuery += "   FROM "
cQuery += "   ( "
cQuery += "      SELECT "
cQuery += "         CLIENTE = SA1.A1_COD, "
cQuery += "         LOJA    = SA1.A1_LOJA, "
cQuery += "         NOME    = RTRIM(SA1.A1_NOME), "
cQuery += "         REP     = RTRIM(SA3.A3_NREDUZ), "
cQuery += "         UF      = SA1.A1_EST, "
cQuery += "         DATAUP  = SC5.C5_EMISSAO "
cQuery += "      FROM "
cQuery += "         "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "         "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4  "
cQuery += "      WHERE "
cQuery += "         SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "         SC6.C6_BLQ <> 'R' AND "//"SB1.B1_TIPO = 'PA' AND "
cQuery += "         SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "         SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.A1_ATIVO <> 'N' AND "
cQuery += "         SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "         SC5.C5_EMISSAO <> '' AND SC5.C5_EMISSAO < '"+aMesAtu[1]+"' AND "
cQuery += "         SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "         SB1.B1_SETOR <>'39' AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "             SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "             SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "             SB1.B1_GRUPO IN('C') AND "
   endif
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "SA1.A1_EST = '"+cUF+"' AND "
endif

if nRegiao == NORTE
   cQuery += "SA1.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "SA1.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "SA1.A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "SA1.A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "SA1.A1_EST IN ('RS','PR','SC') AND "
endif

if nRelato == REPRE
   cQuery += "SA1.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
elseif nRelato == COORD
   cQuery += "( RTRIM(SA3.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SA1.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "         SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "         SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "         SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "         SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "         SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "         SA1.D_E_L_E_T_ = ' ' "
cQuery += "      GROUP BY "
cQuery += "         SA1.A1_VEND, A1_COD, A1_LOJA, RTRIM(A1_NOME), A1_EST, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_EMISSAO, RTRIM(A3_NREDUZ) "
cQuery += "   ) AS VENDAS "
cQuery += "   GROUP BY "
cQuery += "      CLIENTE,LOJA,NOME,UF,REP "
cQuery += ") AS VENDAS "
cQuery += "WHERE "
cQuery += "   DATAUP <= '"+aMes120[1]+"' "
cQuery += "ORDER BY "
cQuery += "   DATAUP DESC "

MemoWrite("C:\Temp\SqlInativo.sql", cQuery )

return cQuery



*************************************************************************
static function SqlAtivo(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinha,lReal)
*************************************************************************

local cQuery
local aMesAnt   := fMAnter(nMes,nAno)
local aMesAtu   := fMAtual(nMes,nAno)
local aMes120   := f120Dias(nMes,nAno)
local aMeses120 := fMeses120(nMes,nAno)

//Clientes Ativos
cQuery := "SELECT "
cQuery += "   CLIENTE, "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   REP, "
cQuery += "   UF, "
for _X := 1 to Len(aMeses120)
   cQuery += "   "+aMeses120[_X,1]+" = SUM(CASE WHEN ANOMES = '"+aMeses120[_X,2]+"' THEN VENDIDO ELSE 0 END ), "
next _X
cQuery += "MESATUAL = ISNULL((SELECT "
if !lReal
   cQuery += "                   SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                   SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                   FROM "
cQuery += "                      "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "+RetSqlName("SC9")+" SC9U, "
cQuery += "                      "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                   WHERE "
cQuery += "                      SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                      SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                      SC6U.C6_FILIAL = SC9U.C9_FILIAL AND "
cQuery += "                      SC9U.C9_PEDIDO = SC6U.C6_NUM AND SC9U.C9_ITEM = SC6U.C6_ITEM AND SC9U.C9_PEDIDO = SC5U.C5_NUM AND "
cQuery += "                      SC9U.C9_BLCRED <> '09' AND "
cQuery += "                      SC6U.C6_BLQ <> 'R' AND "//"SB1U.B1_TIPO = 'PA' AND "
cQuery += "                      SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                      SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
                                 //Periodo que compreende o mes Atual 
cQuery += "                      SC5U.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "                      SC5U.C5_EMISSAO BETWEEN '"+aMesAtu[1]+"' AND '"+aMesAtu[2]+"' AND "
cQuery += "                      SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "                      SB1U.B1_SETOR <> '39' AND "
											if nLinha <> TLINHAS
											   if nLinha == DOMEST
											      cQuery += "             SB1U.B1_GRUPO IN('D','E') AND "
											   elseif nLinha == INSTIT
											      cQuery += "             SB1U.B1_GRUPO IN('A','B','G') AND "
											   elseif nLinha == HOSPIT
											      cQuery += "             SB1U.B1_GRUPO IN('C') AND "
											   endif   
											endif
											
											if cUF <> nil .and. !Empty(cUF)
											   cQuery += "SA1U.A1_EST = '"+cUF+"' AND "
											endif
											
											if nRegiao == NORTE
											   cQuery += "SA1U.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
											elseif nRegiao == NORDESTE
											   cQuery += "SA1U.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
											elseif nRegiao == COESTE
											   cQuery += "SA1U.A1_EST IN ('GO','MT','MS','DF') AND "
											elseif nRegiao == SUDESTE
											   cQuery += "SA1U.A1_EST IN ('MG','ES','RJ','SP') AND "
											elseif nRegiao == SUL
											   cQuery += "SA1U.A1_EST IN ('RS','PR','SC') AND "
											endif
											
											if nRelato == REPRE
											   cQuery += "SA1U.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
											elseif nRelato == COORD
											   cQuery += "( RTRIM(SA3U.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1U.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
											   cQuery += " EXISTS( SELECT A3_SUPER "
											   cQuery += "         FROM "+RetSqlName("SA3")+" "
											   cQuery += "         WHERE A3_COD = SA1U.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1U.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
											endif

cQuery += "                      SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                      SB1U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC5U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC6U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC9U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SE4U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "       ANOMES = LEFT(SC5.C5_EMISSAO,6), "
cQuery += "      CLIENTE = SA1.A1_COD,  "
cQuery += "         LOJA = SA1.A1_LOJA, "
cQuery += "         NOME = RTRIM(SA1.A1_NOME), "
cQuery += "          REP = RTRIM(SA3.A3_NREDUZ), "
cQuery += "           UF = SA1.A1_EST,  "
if !lReal
   cQuery += "   VENDIDO = SUM(SC6.C6_QTDVEN*SB1.B1_PESO) "
else   
   cQuery += "   VENDIDO = SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC) "
endif
cQuery += "   FROM "
cQuery += "      "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "      "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4 "
cQuery += "   WHERE "
cQuery += "      SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "      SC6.C6_BLQ <> 'R' AND "//"SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "      SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.A1_ATIVO <> 'N' AND "
                 //Periodo que compreende os 120 dias anteriores ao mês atual
cQuery += "      SC5.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "      SC5.C5_EMISSAO BETWEEN '"+aMes120[1]+"' AND '"+aMes120[2]+"' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "      SB1.B1_SETOR <> '39' AND "

if nLinha <> TLINHAS
   if nLinha == DOMEST
      cQuery += "             SB1.B1_GRUPO IN('D','E') AND "
   elseif nLinha == INSTIT
      cQuery += "             SB1.B1_GRUPO IN('A','B','G') AND "
   elseif nLinha == HOSPIT
      cQuery += "             SB1.B1_GRUPO IN('C') AND "
   endif   
endif

if cUF <> nil .and. !Empty(cUF)
   cQuery += "SA1.A1_EST = '"+cUF+"' AND "
endif

if nRegiao == NORTE
   cQuery += "SA1.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
elseif nRegiao == NORDESTE
   cQuery += "SA1.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
elseif nRegiao == COESTE
   cQuery += "SA1.A1_EST IN ('GO','MT','MS','DF') AND "
elseif nRegiao == SUDESTE
   cQuery += "SA1.A1_EST IN ('MG','ES','RJ','SP') AND "
elseif nRegiao == SUL
   cQuery += "SA1.A1_EST IN ('RS','PR','SC') AND "
endif

if nRelato == REPRE
   cQuery += "SA1.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
elseif nRelato == COORD
   cQuery += "( RTRIM(SA3.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "         FROM "+RetSqlName("SA3")+" "
   cQuery += "         WHERE A3_COD = SA1.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
endif

cQuery += "      SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "      NOT EXISTS( SELECT "
cQuery += "                     SC5X.C5_FILIAL "
cQuery += "                  FROM "
cQuery += "                     "+RetSqlName("SB1")+" SB1X, "+RetSqlName("SC5")+" SC5X, "+RetSqlName("SC6")+" SC6X, "
cQuery += "                     "+RetSqlName("SA1")+" SA1X, "+RetSqlName("SA3")+" SA3X, "+RetSqlName("SE4")+" SE4X "
cQuery += "                  WHERE "
cQuery += "                     SC5X.C5_CLIENTE = SC5.C5_CLIENTE AND SC5X.C5_LOJACLI = SC5.C5_LOJACLI AND "
cQuery += "                     SC5X.C5_FILIAL = SC6X.C6_FILIAL AND "
cQuery += "                     SC6X.C6_BLQ <> 'R' AND "//"SB1X.B1_TIPO = 'PA' AND "
cQuery += "                     SC6X.C6_PRODUTO = SB1X.B1_COD AND SC5X.C5_NUM = SC6X.C6_NUM AND SA1X.A1_VEND = SA3X.A3_COD AND "
cQuery += "                     SC5X.C5_CLIENTE = SA1X.A1_COD AND SC5X.C5_LOJACLI = SA1X.A1_LOJA AND SA1X.A1_ATIVO <> 'N' AND "
                                //Periodo que compreende o mes Anterior ao Atual
cQuery += "                     SC5X.C5_CLIENTE NOT IN ('006543','007005') AND "
cQuery += "                     SC5X.C5_EMISSAO BETWEEN '"+aMesAnt[1]+"' AND '"+aMesAnt[2]+"' AND "
cQuery += "                     SC6X.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119') AND "
cQuery += "                     SB1X.B1_SETOR <> '39' AND "

											if nLinha <> TLINHAS
											   if nLinha == DOMEST
											      cQuery += "             SB1X.B1_GRUPO IN('D','E') AND "
											   elseif nLinha == INSTIT
											      cQuery += "             SB1X.B1_GRUPO IN('A','B','G') AND "
											   elseif nLinha == HOSPIT
											      cQuery += "             SB1X.B1_GRUPO IN('C') AND "
											   endif   
											endif
											
											if cUF <> nil .and. !Empty(cUF)
											   cQuery += "SA1X.A1_EST = '"+cUF+"' AND "
											endif
											
											if nRegiao == NORTE
											   cQuery += "SA1X.A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') AND "
											elseif nRegiao == NORDESTE
											   cQuery += "SA1X.A1_EST IN ('MA','PI','CE','RN','PB','PE','AL','BA','SE') AND "
											elseif nRegiao == COESTE
											   cQuery += "SA1X.A1_EST IN ('GO','MT','MS','DF') AND "
											elseif nRegiao == SUDESTE
											   cQuery += "SA1X.A1_EST IN ('MG','ES','RJ','SP') AND "
											elseif nRegiao == SUL
											   cQuery += "SA1X.A1_EST IN ('RS','PR','SC') AND "
											endif
											
											if nRelato == REPRE
											   cQuery += "SA1X.A1_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
											elseif nRelato == COORD
											   cQuery += "( RTRIM(SA3X.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' OR RTRIM(SA1X.A1_VEND) LIKE '"+Alltrim(cCod)+"%' ) AND "
											   cQuery += " EXISTS( SELECT A3_SUPER "
											   cQuery += "         FROM "+RetSqlName("SA3")+" "
											   cQuery += "         WHERE A3_COD = SA1X.A1_VEND AND ( A3_SUPER = '"+Alltrim(cCod)+"' OR SA1X.A1_VEND = '"+Alltrim(cCod)+"' ) AND D_E_L_E_T_ = '' ) AND "
											endif

cQuery += "                     SC5X.C5_CONDPAG = SE4X.E4_CODIGO AND "
cQuery += "                     SB1X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC5X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC6X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SE4X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SA1X.D_E_L_E_T_ = ' '  ) AND "
cQuery += "      SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "      SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_VEND, A1_COD, A1_LOJA, RTRIM(A1_NOME), A1_EST, LEFT(SC5.C5_EMISSAO,6), RTRIM(A3_NREDUZ) "
cQuery += ") AS ATIVOS "
cQuery += "GROUP BY "
cQuery += "   CLIENTE,LOJA,NOME,UF,REP "
cQuery += "ORDER BY "

for _X := Len(aMeses120) to 1 step -1
   cQuery += "   "+aMeses120[_X,1]+IF( _X > 1,", "," DESC ")
next _X

return cQuery

**************************************
static function SqlProsp(nRelato,cCod)
**************************************

local cQuery

cQuery := "SELECT "
cQuery += "   CLIENTE = US_COD, "
cQuery += "      LOJA = US_LOJA, "
cQuery += "      NOME = US_NOME, "
cQuery += "        UF = US_EST, "
cQuery += "       REP = A3_NOME, "
cQuery += "  SEGMENTO = (SELECT RTRIM(X5_DESCRI) FROM "+RetSqlName("SX5")+" SX5 WHERE X5_FILIAL = '01' AND X5_TABELA = 'T3' AND X5_CHAVE = US_SATIV AND D_E_L_E_T_ <> '*') "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SUS")+" SUS, "+RetSqlName("SA3")+" SA3 "
cQuery += "WHERE "
cQuery += "   US_STATUS = '4' AND "
cQuery += "   US_VEND = A3_COD AND "
if nRelato == REPRE
   cQuery += "SUS.US_VEND LIKE '"+Alltrim(cCod)+"%' AND " 
elseif nRelato == COORD
   cQuery += " RTRIM(SA3.A3_SUPER) LIKE '"+Alltrim(cCod)+"%' AND "
endif
cQuery += "   SUS.D_E_L_E_T_ <> '*' AND "
cQuery += "   SA3.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "
cQuery += "   US_COD "

return cQuery

**************************************
static function SqlPDAberto(nRelato,cCod)
**************************************

local cQuery


cQuery := "SELECT C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C5_VEND1, C5_VEND2, A1_NOME, A3_NREDUZ, SUM(C6_QTDVEN * C6_PRCVEN) TOTPED FROM  " + RetSqlName("SC5") + " C "
cQuery += "INNER JOIN " + RetSqlName("SC6")+ " SC6 "
cQuery += "ON C6_FILIAL = C5_FILIAL "
cQuery += "AND C6_NUM = C5_NUM "
cQuery += "INNER JOIN " + RetSqlName("SA1")+" SA1 "
cQuery += "ON C5_CLIENTE = A1_COD "
cQuery += "AND C5_LOJACLI = A1_LOJA " 
cQuery += "INNER JOIN " + RetSqlName("SA3") + " SA3 "
cQuery += "ON C5_VEND1 = A3_COD "
cQuery += "WHERE C.D_E_L_E_T_ <> '*' "
cQuery += "AND SC6.D_E_L_E_T_ <> '*' "
cQuery += "AND C5_LIBEROK = '' "
cQuery += "AND C5_NOTA = '' "
cQuery += "AND C5_BLQ	= '' "
//cQuery += "AND C5_FILIAL = '" + xFilial("SC5") + "' "
cQuery += "AND C5_EMISSAO > '2016' "
if nRelato == REPRE
   cQuery += "AND C5_VEND1 LIKE '"+Alltrim(cCod)+"%' " 
elseif nRelato == COORD
   cQuery += "AND A3_SUPER LIKE '"+Alltrim(cCod)+"%' " 
endif
cQuery += " GROUP BY C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C5_VEND1, C5_VEND2, A1_NOME, A3_NREDUZ "
cQuery += " ORDER BY C5_EMISSAO " 

return cQuery

**************************************
static function SqlPDrej(nRelato,cCod)
**************************************

local cQuery

cQuery := "SELECT C9_PEDIDO ,C5_EMISSAO, C5_CONDPAG, C9_CLIENTE, C9_LOJA, A1_NOME, C9_BLCRED, sum( C9_QTDLIB * C9_PRCVEN ) TOTAL, " 
cQuery += "C9_DATALIB, C9_OBSREJ, A3_SUPER, C5_VEND1, AVG(C5_DESC1) C5_DESC1, A3_NREDUZ "
cQuery += "FROM " + RetSqlName("SC9")+ " C9 " 
cQuery += "INNER JOIN " + RetSqlName("SC5")+ " C5 "
cQuery += "ON C5_FILIAL = C9_FILIAL "
cQuery += "AND C5_NUM = C9_PEDIDO "
cQuery += "INNER JOIN " + RetSqlName("SA1")
cQuery += " ON A1_COD = C9_CLIENTE "
cQuery += "AND A1_LOJA = C9_LOJA "
cQuery += "INNER JOIN " + RetSqlName("SA3")
cQuery += " ON A3_COD = C5_VEND1 " 
cQuery += "WHERE  C9.D_E_L_E_T_ <> '*' "
cQuery += "AND (C9_BLCRED = '01' OR C9_BLCRED = '04' OR C9_BLCRED = '09' ) "
cQuery += "AND C9_NFISCAL = '' "
cQuery += "AND C9_SEQUEN  = '01' " 
cQuery += "AND C9_FILIAL = '" + xFilial("SC9") + "' "
if nRelato == REPRE
   cQuery += "AND C5_VEND1 LIKE '"+Alltrim(cCod)+"%' " 
elseif nRelato == COORD
   cQuery += "AND C5_VEND2 LIKE '"+Alltrim(cCod)+"%' " 
endif
cQuery += "GROUP BY C9_PEDIDO ,C5_EMISSAO, C5_CONDPAG, C9_CLIENTE, C9_LOJA, A1_NOME, C9_BLCRED, C9_DATALIB, C9_OBSREJ, A3_SUPER, C5_VEND1, A3_NREDUZ "
cQuery += "ORDER BY C9_PEDIDO "

return cQuery

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

*******************************************************************************************
Static Function Info1( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, nPer, lFat, lReal )
*******************************************************************************************
local cQuery := ""
local nRet   := 0
local nDiasTot, nDiasCorr
local aRet   := Array(21)
local aCob   := {0,0}
local aMet   := {0,0,0}
local aBon   := {0,0}
local aFat   := {0,0,0,0,0}
local aDev   := {0,0,0,0,0}
local aCartI := {0,0,0}
local aCartP := {0,0,0}

Default nPer    := MENSAL
Default lFat    := .T.
Default lReal   := .F.
Default nLinPro := TLINHAS

nDiasTot  := DiasUteis( CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)), LastDay(Ctod("01/"+StrZero(nMes,2)+"/"+Str(nAno))) )
nDiasCorr := DiasUteis( CtoD("01/"+StrZero(nMes,2)+"/"+Str(nAno)), dDataBase )

if !lFat  
   aMet := U_MetaRava(Str(nAno),nRegiao,cUF,nRelato,cCod,SACOS,nPer,nLinPro) //Meta KG{1} e Fator{2}

   if lReal
      aMet[1] := aMet[1]*aMet[2] //Caso a informação seja em valor monetario (R$)
   endif

   if nPer == MENSAL
      aRet[01] := (aMet[1]/nDiasTot)*nDiasCorr   //1-Ideal Acumulado MENSAL
   else 
      aRet[01] := (aMet[1]/12)*nMes              //1-Ideal Acumulado ANUAL
   endif   
   aRet[16] := aMet //Meta KG e Fator

   aRet[19] := U_CobRava(nMes,nAno,nRelato,cCod,cUF,nRegiao,nPer,nLinPro)
   aRet[19][1] := aRet[16][3] //Meta de Cobertura de Clientes   
else
   aFat := U_FatRava(nRegiao,cUF,nMes,nAno,nRelato, cCod, SACOS, nPer,,,nLinPro )//Volume faturado em KG e R$

   aCartI := U_CartRava( IMEDI, nRelato, cCod, SACOS,cUF,nRegiao, nLinPro ) //Carteira Imediata
   aCartP := U_CartRava( PROGR, nRelato, cCod, SACOS,cUF,nRegiao, nLinPro ) //Carteira Programada
   
   aRet[17] := aFat[1] //Faturamento KG
   aRet[18] := aFat[2] //Faturamento R$
   aRet[20] := aFat[3] //Preço Faturado
   
   aDev := U_fDevFat(nRegiao,cUF,nMes,nAno,nRelato, cCod, SACOS, nPer,,,nLinPro )
   
   //aRet[20] := aDev[1] //Devolucao KG
   aRet[21] := aDev[2] //Devolucao R$

endif

aVen   := U_VendRava( nMes,nAno,nRelato,cCod,SACOS,cUF,nRegiao,,nPer,nLinPro ) //Vendido para o mes

aRet[14] := aVen[5] //Desconto R$ (Vendido)
if !lFat
   aRet[02] := ( aRet[1] - aVen[1] ) //2-kG Abaixo do Ideal Acumulado
endif   

aRet[03] := (nDiasTot-nDiasCorr)     //3-Dias Uteis para Fim Mes
aRet[04] := aVen[4]                  //4-Prz.Medio

if lFat
   aRet[05] := if(lReal,aCartP[2],aCartP[1]) //5-Cart.Programada
   aRet[06] := if(lReal,aCartI[2],aCartI[1]) //6-Cart.Imediada
   aBon     := U_BoniRava( nMes,nAno,nRelato, cCod, SACOS,cUF,nRegiao, nLinPro )   
   aRet[07] := if(lReal,aBon[2],aBon[1])     //7-Bonificacao
   nFator   := aVen[3]
   aRet[08] := U_MargRava( nFator,nMes,nAno) //8-Margem
endif

aRet[09] := if(lReal,aVen[2],aVen[1])  //9-Realizado em KG
aRet[10] := if(lFat,aFat[5],0)         //10-Desconto em R$
aRet[11] := if(lReal,aVen[2],aVen[1])  //Vendido para o mes

if !lFat
   aRet[12] := aMet[1]-if(lReal,aVen[2],aVen[1]) //Kg abaixo da Meta
   aRet[15] := aVen[3] //Fator
else
   aVen   := U_VendRava( nMes,nAno, nRelato, cCod, SACOS,cUF,nRegiao,,,nLinPro,.T. ) //Vendido no mes para o mes
   aRet[13] := if(lReal,aVen[2],aVen[1]) //Vendido no mes para o mes
endif

return aRet


*************************************************************************************
Static Function Info2( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, lReal )
*************************************************************************************

local aRet1 := Info1( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, ANUAL , .F., lReal )
local aRet2 := Info1( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, MENSAL, .F., lReal )
local aRet3 := U_SemCre(nMes,nAno,nRelato,cCod,cUF,nRegiao,nLinPro,lReal)

local aRet4 := Info1( nMes,nAno, nRelato, cCod, cUF, nRegiao, nLinPro, MENSAL, .T., lReal )

local aInfo := Array(21)

aInfo[01] := aRet1[16][1]          //Meta Anual (kg)
aInfo[02] := aRet1[01]             //Ideal Acumulado para bater meta Anual (kg)
aInfo[03] := aRet1[12]             //Abaixo da Meta Anual (Kg)
aInfo[04] := aRet1[09]             //Realizado até o momento  ANO (kg)
aInfo[05] := aRet2[16][1]          //Meta Mensal (kg)
aInfo[06] := aRet2[01]             //Ideal Acumulado para bater meta Mensal (kg)
aInfo[07] := aRet2[12]             //Abaixo da Meta Mensal (Kg)
aInfo[08] := aRet2[09]-aRet3[2]    //Realizado até o momento MêS (kg)
aInfo[09] := aRet2[16][2]          //Meta Mensal (R$/kg)
aInfo[10] := aRet2[16][2]-aRet2[15]//Abaixo da Meta Mensal (R$) //Antes estava aRet1[15] Fator Realizado Ano
aInfo[11] := aRet2[04]             //Prazo médio
aInfo[12] := aRet2[15]             //Fator Realizado Mês //Antes estava aRet1[15] Fator Realizado Ano
aInfo[13] := aRet2[12]/aRet1[03]   //Meta Dia com base no mês (KG)
aInfo[14] := aRet3[1]              //Volume em (KG) ainda não aprovado pelo credito
aInfo[15] := aRet3[2]              //Volume em (KG) rejeitado pelo credito
aInfo[16] := aRet2[19][1]          //Meta Cobertura
aInfo[17] := aRet2[19][2]          //Real Cobertura

//If nRelato == REPRE
	aInfo[18] := aRet4[17]          	//Faturado em KG
	aInfo[19] := aRet4[18]          	//Faturado em R$
	
	aInfo[20] := aRet4[20]          	//Devolucao em KG
	aInfo[21] := aRet4[21]          	//Devolucao em R$
//EndIf

return aInfo

************************************************************
Static Function GrupoN( nLinha, cGrupo, aInfo, lReal, lCob )
************************************************************

Default lCob := .T.

if nLinha+4 >= nVPage
   oPrinter:EndPage()
   oPrinter:StartPage()
   nLinha := Cabecalho()+IncLinha(1)
   nLinha := TextoHorz(nLinha, 1,1,"continua...",ESQUERDA,,oFont14N:oFont)
   nLinha += IncLinha(1)
   nLinha := LinhaHorz(nLinha, 1,1)
endif

/*
--------------------------------------------------------------
|             |           |   Meta   | Realizado | Diferença |
|             |-----------|----------|-----------|-----------|
|             |Vendas     |          |           |           |
| Coordenador |-----------|----------|-----------|-----------|
|             |Preço      |          |           |           |
|             |-----------|----------|-----------|-----------|
|             |Cobertura  |          |           |           |
--------------------------------------------------------------
*/

//Primeira Linha
TextoHorz(nLinha+if(lCob,.75,.5625), 5,1, cGrupo ,ESQUERDA,,oFont14N:oFont)
TextoHorz(nLinha, 5,3, "Meta "     +if(lReal,"(R$)","(Kg)"),DIREITA,,oFont14N:oFont)
TextoHorz(nLinha, 5,4, "Pedidos Eviados "+if(lReal,"(R$)","(Kg)"),DIREITA)
TextoHorz(nLinha, 5,5, "Diferença "+if(lReal,"(R$)","(Kg)"),DIREITA)
nLinha := LinhaHorz(nLinha+.5, 5,2, 15 )

//Segunda Linha
TextoHorz(nLinha, 5,2, "Vendas",DIREITA,,oFont14N:oFont)
//Meta
TextoHorz(nLinha, 5,3, Transform(aInfo[05],"@E 99,999,999.99"),DIREITA,,oFont14:oFont)
//Realizado
TextoHorz(nLinha, 5,4, Transform(aInfo[08],"@E 99,999,999.99"),DIREITA)
//Diferença
TextoHorz(nLinha, 5,5, Transform(aInfo[08]-aInfo[05],"@E 99,999,999.99"),DIREITA)
nLinha := LinhaHorz(nLinha+.5, 5,2, 15 )

//Terceira Linha
TextoHorz(nLinha, 5,2, "Preço",DIREITA,,oFont14N:oFont)
//Meta
TextoHorz(nLinha, 5,3, Transform(aInfo[9],"@E 99,999,999.99"),DIREITA,,oFont14:oFont)
//Realizado
TextoHorz(nLinha, 5,4, Transform(aInfo[12],"@E 99,999,999.99"),DIREITA)
//Diferença
TextoHorz(nLinha, 5,5, Transform(aInfo[12]-aInfo[9],"@E 99,999,999.99"),DIREITA)
if !lCob
   nLinha := LinhaHorz(nLinha+.5, 1,1)  
else
   nLinha := LinhaHorz(nLinha+.5, 5,2, 15 )
endif   

if lCob
   //Quarta Linha
   TextoHorz(nLinha, 5,2, "Cobertura",DIREITA,,oFont14N:oFont)
   //Meta
   TextoHorz(nLinha, 5,3, Transform(aInfo[16],"@E 99,999,999"),DIREITA,,oFont14:oFont)
   //Realizado
   TextoHorz(nLinha, 5,4, Transform(aInfo[17],"@E 99,999,999"),DIREITA)
   //Diferença
   TextoHorz(nLinha, 5,5, Transform(aInfo[17]-aInfo[16],"@E 99,999,999"),DIREITA)
   nLinha := LinhaHorz(nLinha+.5, 1,1)
endif   

return (nLinha)

************************************************************
Static Function GrupoF( nLinha, cGrupo, aInfo, lReal, lCob )
************************************************************

Default lCob := .T.

if nLinha+4 >= nVPage
   oPrinter:EndPage()
   oPrinter:StartPage()
   nLinha := Cabecalho()+IncLinha(1)
   nLinha := TextoHorz(nLinha, 1,1,"continua...",ESQUERDA,,oFont14N:oFont)
   nLinha += IncLinha(1)
   nLinha := LinhaHorz(nLinha, 1,1)
endif

/*
--------------------------------------------------------------
|             |           |   Meta   | Realizado | Diferença |
|             |-----------|----------|-----------|-----------|
|             |Vendas     |          |           |           |
| Coordenador |-----------|----------|-----------|-----------|
|             |Preço      |          |           |           |
|             |-----------|----------|-----------|-----------|
|             |Cobertura  |          |           |           |
--------------------------------------------------------------
*/

//Primeira Linha
TextoHorz(nLinha+if(lCob,.75,.5625), 5,1, cGrupo ,ESQUERDA,,oFont14N:oFont)
TextoHorz(nLinha, 5,3, "Faturadas " +if(lReal,"(R$)","(Kg)"),DIREITA,,oFont14N:oFont)
TextoHorz(nLinha, 5,4, "Preço "+if(lReal,"(R$)","(Kg)"),DIREITA)
//TextoHorz(nLinha, 5,5, "Líquido "+if(lReal,"(R$)","(Kg)"),DIREITA)
nLinha := LinhaHorz(nLinha+.5, 5,2, 15 )

//Segunda Linha
TextoHorz(nLinha, 5,2, "Notas",DIREITA,,oFont14N:oFont)
//Faturado
TextoHorz(nLinha, 5,3, Transform(if(lReal,aInfo[19],aInfo[18]),"@E 99,999,999.99"),DIREITA,,oFont14:oFont)
//Valor Faturado
TextoHorz(nLinha, 5,4, Transform(aInfo[20],"@E 99,999,999.99"),DIREITA)
//Devolvido
//TextoHorz(nLinha, 5,4, Transform(if(lReal,aInfo[21],aInfo[20]),"@E 99,999,999.99"),DIREITA)
//Diferença
//TextoHorz(nLinha, 5,5, Transform(if(lReal,aInfo[19]-aInfo[21], aInfo[18]-aInfo[20]),"@E 99,999,999.99"),DIREITA)
nLinha := LinhaHorz(nLinha+.5, 5,2, 15 )

/*
//Terceira Linha
TextoHorz(nLinha, 5,2, "Preço",DIREITA,,oFont14N:oFont)
//Meta
TextoHorz(nLinha, 5,3, Transform(aInfo[9],"@E 99,999,999.99"),DIREITA,,oFont14:oFont)
//Realizado
TextoHorz(nLinha, 5,4, Transform(aInfo[12],"@E 99,999,999.99"),DIREITA)
//Diferença
TextoHorz(nLinha, 5,5, Transform(aInfo[12]-aInfo[9],"@E 99,999,999.99"),DIREITA)
if !lCob
   nLinha := LinhaHorz(nLinha+.5, 1,1)  
else
   nLinha := LinhaHorz(nLinha+.5, 5,2, 15 )
endif   

if lCob
   //Quarta Linha
   TextoHorz(nLinha, 5,2, "Cobertura",DIREITA,,oFont14N:oFont)
   //Meta
   TextoHorz(nLinha, 5,3, Transform(aInfo[16],"@E 99,999,999"),DIREITA,,oFont14:oFont)
   //Realizado
   TextoHorz(nLinha, 5,4, Transform(aInfo[17],"@E 99,999,999"),DIREITA)
   //Diferença
   TextoHorz(nLinha, 5,5, Transform(aInfo[17]-aInfo[16],"@E 99,999,999"),DIREITA)
   nLinha := LinhaHorz(nLinha+.5, 1,1)
endif   
*/
return (nLinha)

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

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Funcao que retorna emails Coord Diret
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*****************************
Static function MailX( cCod )
*****************************

Local cQuery
Local cMail := ";"

cQuery := "SELECT COD=LEFT(X5_CHAVE,4), "
cQuery += "EMAIL=RTRIM(X5_DESCRI)+CASE WHEN X5_DESCENG=';' THEN''ELSE RTRIM(X5_DESCENG)END+"
cQuery += "                       CASE WHEN X5_DESCSPA=';' THEN''ELSE RTRIM(X5_DESCSPA)END "
cQuery += "FROM "+RetSqlName("SX5")+" "
cQuery += "WHERE X5_TABELA='ZS' AND X5_FILIAL='"+xFilial("SX5")+"' "
cQuery += "AND LEFT(X5_CHAVE,4) = '"+Alltrim(cCod)+"' "
cQuery += "AND  D_E_L_E_T_<>'*' "
cQuery += "ORDER BY COD "

if Select("MLX") > 0
	DbSelectArea("MLX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "MLX"

while !MLX->(EOF())
   cMail += Alltrim(MLX->EMAIL)
   MLX->(DbSkip())
end

MLX->(DbCloseArea())

return cMail


//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Funcao que retorna emails
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

******************************************
User function RVMails( nRelato, lCCDir )
******************************************

Local cQuery
Local aRet := {} 
Local cCoo,cCod,cCodAux,cMail,cCopia

Default lCCDir := .T.

if ( nRelato == COORD ) .OR. ( nRelato == DIRET )
   cQuery := "SELECT COD=LEFT(X5_CHAVE,4), "
   cQuery += "EMAIL=RTRIM(X5_DESCRI)+CASE WHEN X5_DESCENG=';' THEN''ELSE RTRIM(X5_DESCENG)END+"
   cQuery += "                       CASE WHEN X5_DESCSPA=';' THEN''ELSE RTRIM(X5_DESCSPA)END "
   cQuery += "FROM "+RetSqlName("SX5")+" "
   cQuery += "WHERE X5_TABELA='ZS' AND X5_FILIAL='"+xFilial("SX5")+"' "
   cQuery += "AND LEFT(X5_CHAVE,4) "+if(nRelato==DIRET,"=","<>")+" 'DIRE' "
   cQuery += "AND  D_E_L_E_T_<>'*' " //AND X5_CHAVE = '2367' "
   cQuery += "ORDER BY COD "
elseif nRelato == REPRE
   cQuery := "SELECT COD=RTRIM(A3_COD), EMAIL=RTRIM(A3_EMAIL) "
   cQuery += "FROM "+RetSqlName("SA3")+" SA3 "
   cQuery += "WHERE A3_ATIVO<>'N' AND LEN(A3_COD)=4 AND A3_EMAIL <> '' "
   cQuery += "AND A3_GERASE2='S' AND A3_SUPER<>'' AND D_E_L_E_T_<>'*' "      
endif

if Select("MAILX") > 0
	DbSelectArea("MAILX")
	DbCloseArea()
endif

TCQUERY cQuery NEW ALIAS "MAILX"

while !MAILX->(EOF())
   cCodAux  := MAILX->COD
   cMail := ""
   while !MAILX->(EOF()) .AND. cCodAux == MAILX->COD
      if !MAILX->(EOF())
         cCod := MAILX->COD
      endif   
      cCodAux  := MAILX->COD
      cMail += Alltrim(MAILX->EMAIL)
      MAILX->(DbSkip())
   end
   if nRelato == COORD
      if lCCDir
         cMail += MailX('DIRE')//Envia o de Coord com copia para Diretoria
      endif   
   elseif nRelato == REPRE
      cCoo := Posicione( "SA3", 1, xFilial("SA3") + PadR(cCod,6), "A3_SUPER" )
      cMail += MailX(Left(cCoo,4)) //Envia de Repres com copia para Coordenadores e Assistentes
   endif   
   Aadd( aRet, { cCod, cMail } )   
end

MAILX->(DbCloseArea())

return aRet
*/

********************************
Static Function ValidPerg(cPerg)
********************************

PutSx1( cPerg, '01', 'Mês          ?', '', '', 'mv_ch1', 'N', 02, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Ano          ?', '', '', 'mv_ch2', 'N', 04, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '03', 'Nivel        ?', '', '', 'mv_ch3', 'C', 06, 0, 0, 'G', '', 'KL' , '', '', 'mv_par03', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '04', 'Coord/Repres ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par04', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '05', 'UF           ?', '', '', 'mv_ch5', 'C', 02, 0, 0, 'G', '', '12' , '', '', 'mv_par05', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '06', 'Regiao       ?', '', '', 'mv_ch6', 'C', 06, 0, 0, 'G', '', 'ZK' , '', '', 'mv_par06', '', '', '', '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '07', 'Salvar PDF em?', '', '', 'mv_ch8', 'C', 80, 0, 0, 'G', '', ''   , '', '', 'mv_par08', '', '', '', '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '08', 'Valores em   ?', '', '', 'mv_ch9', 'N', 01, 0, 0, 'C', '', ''   , '', '', 'mv_par09', 'KG', '', '', '' , 'R$', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg, '09', 'Linha        ?', '', '', 'mv_cha', 'N', 01, 0, 1, 'C', '', ''   , '', '', 'mv_par10', 'Institucional', '', '', '' , 'Domestica', '', '', 'Hospitalar', '', '', 'Todas', '', '', '', '', '', {}, {}, {} )

Return

************************
User Function pddMes( dDataIni, dDataFim, lFora, dExec1, dExec2, nRSKG, cTipoA3, cCodA3, nFam, nLinha )
 
//nRSKG = indica se 1 - Real, 2 - Kg,
//cTipoA3 = SE é: G-Gerente, S-Supervisor, V-Vendedor
//cCodA3 = código do vendedor/coord./Gerente no SA3 , quando esta função é chamada de fora
//lFora  = indica se a chamada desta função é externa ( .T. = REL 02 FATR023 , ou .F. = deste mesmo relatório FATPFIV5 )
//dExec1  = data de execução do relatório (chamada de fora)
//dExec2  = data de execução do relatório (chamada de fora)
//nFam    = Família: 1 - Sacos / 2 - Caixas
//nLinha  = Linha: 1 - Doméstica / 2 - HOspitalar
************************

Local cQuery := ""
Local nVal := 0   
Local LF := CHR(13) + CHR(10)
Local nMesExec := 0
Local dVend1
Local dVend2
Local dExecucao
//cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESO) AS CARTEIRA_KG, 
// SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS
cQuery += "select " + LF
If !lFora
	cQuery += " SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) TOTALRS, SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESO) TOTALKG " + LF
Else
	If nFam = 1    //SACOS
		cQuery += " SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESO) AS TOTALKG ," + LF
	Else          //CAIXAS
		cQuery += " SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT )) AS TOTALKG ," + LF
	Endif
	cQuery += " SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS TOTALRS " + LF
Endif

cQuery += "from "+retSqlName('SC6')+" SC6, " + LF
cQuery += "" +retSqlName('SC5')+" SC5, " + LF
cQuery += "" +retSqlName('SB1')+" SB1, " + LF
cQuery += "" +retSqlName('SA1')+" SA1, "  + LF
cQuery += "" +retSqlName('SF4')+" SF4,  " + LF
cQuery += "" +retSqlName('SA3')+" SA3,  " + LF
cQuery += "" +retSqlName('SC9')+" SC9  " + LF


cQuery += " WHERE " + LF
IF !lFora
	dExecucao := Ctod(dTExec)     //dDataUso = dDatabase
	nMesExec := Month(dExecucao)
	If Substr(dTExec,1,2) = '01'  //se a execução for num dia 1o., retrocede ao mês anterior para capturar o mês cheio
		dVend1   := CtoD( '01/' + str((nMesExec - 1)) +'/'+Right(StrZero(Year(dDataUso),4),2) )
		dVend2   := LastDay(dVend1) 
		
		cQuery += " C5_EMISSAO between '" + dtos(dVend1)+"' and '" + dtos(dVend2)+ "' "
	    // SO CONSIDERAR IMEDIATA 
	    cQuery += " and C5_ENTREG between '" + dtos(dVend1)+"' and '" + dtos(dVend2)+ "' "
	    //
	Else
		cQuery += " C5_EMISSAO between '"+dtos(FirstDay(dDataUso))+"' and '"+dtos(LastDay(dDataUso))+"' " + LF
	    // SO CONSIDERAR IMEDIATA 
		cQuery += "and C5_ENTREG between '"+dtos(FirstDay(dDataUso))+"' and '"+dtos(LastDay(dDataUso))+"' " + LF
	    //
	
	Endif
ELSE
    cQuery += " C5_EMISSAO between '"+dtos(dExec1)+"' and '"+dtos(dExec2)+"' " + CHR(13) + CHR(10)
    // SO CONSIDERAR IMEDIATA 
	cQuery += " and C5_ENTREG between '"+dtos(dExec1)+"' and '"+dtos(dExec2)+"' " + LF		
ENDIF

cQuery += "AND (SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R'  "//"AND B1_TIPO='PA' "
cQuery += "AND SC6.C6_CLI NOT IN ('031732','031733','006543','007005') " 
cQuery += " and C6_PRODUTO = B1_COD and C6_NUM = C5_NUM and C5_TIPO = 'N' " + LF
If !lFora     //chamado de dentro do FATPFIV5
	If par06 = 2    //verifica parâmetro despreza apara
		cQuery += " AND B1_TIPO != 'AP' "  + LF //Despreza Apara
	Endif 
Else          //senão, já exclui direto a apara                                                  
	cQuery += " AND B1_TIPO != 'AP' "  + LF //Despreza Apara
Endif
cQuery += " and F4_DUPLIC = 'S' and C6_TES = F4_CODIGO " + LF
cQuery += " and SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA " + LF 
IF !lFora
	cQuery += " and SB1.B1_SETOR != '39' "  + LF // Diferente Caixa 
ELSE 
	If nFam = 1         //SACOS
		cQuery += " AND SB1.B1_SETOR <> '39' "+LF
	Else                //CAIXAS
		cQuery += " AND SB1.B1_SETOR = '39' "+LF
	Endif
ENDIF
// SO CONSIDERAR O QUE FOI LIBERADO
cQuery += " and SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM " + LF
//cQuery += " and SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' " + LF
// NOVA LIBERACAO DE CREDITO
cQuery += " and SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' " + LF

cQuery += " and SC5.C5_VEND1 = SA3.A3_COD " + LF
//
IF !lFora
	If !empty(par11)     //Representante
		//cQuery += " SC5.C5_VEND1 = SA3.A3_COD AND " + LF
	    cQuery += " and SC5.C5_VEND1 in ('"+ Alltrim(par11) +"','"+alltrim(par11) +"VD'"+") " + LF
	
	elseif !empty(par12)//Coordenador
	 
	   //cQuery += "SA3.A3_COD = SC5.C5_VEND1  AND " + LF
	   cQuery += " and ( A3_SUPER LIKE ('" + ALLTRIM(par12) + "%' )  OR C5_VEND1 in ('"+ Alltrim(par12)+"','"+ alltrim(par12) +"VD'"+") ) " + LF
	
	elseif !empty(par13)//Gerente
		//cQuery += " SC5.C5_VEND1 = SA3.A3_COD and " + LF
	    cQuery += " and ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(par13) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "+LF
		cQuery += " OR A3_GEREN LIKE ( '" + ALLTRIM(par13) + "%' ) ) "+LF
	/* ANTONIO
	else
		cQuery += " and ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE A3_GEREN <> ''  and SA3.D_E_L_E_T_ != '*' ) ) "+LF
	*/	
	Endif 
ELSE
	If Alltrim(cTipoA3) = "V"     	//Representante	
	    cQuery += " and SC5.C5_VEND1 in ('"+ Alltrim(cCodA3) +"','"+alltrim(cCodA3) +"VD'"+") " + LF
	
	elseif Alltrim(cTipoA3) = "S"	//Coordenador
	   cQuery += " and ( A3_SUPER LIKE ('" + ALLTRIM(cCodA3) + "%' )  OR C5_VEND1 in ('"+ Alltrim(cCodA3)+"','"+ alltrim(cCodA3) +"VD'"+") ) " + LF
	
	elseif Alltrim(cTipoA3) = "G" 	//Gerente	
	    cQuery += " and ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(cCodA3) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "+LF
		cQuery += " OR A3_GEREN LIKE ( '" + ALLTRIM(cCodA3) + "%' ) ) "+LF 
	elseif Alltrim(cTipoA3) = "C" 	//CLIENTE	
	    cQuery += " and (SC5.C5_CLIENTE + SC5.C5_LOJACLI ) = '" + ALLTRIM(cCodA3) + "' "+LF		
	Endif 
ENDIF


IF !lFora
	if par07 = 1 //Linha Hospitalar
		cQuery += " and SB1.B1_GRUPO IN ('C') " + LF
	elseif par07 = 2 //Linha Dom/Inst
		cQuery += " and SB1.B1_GRUPO IN ('D','E') " + LF
	elseif par07 = 3
		cQuery += " and SB1.B1_GRUPO IN ('A','B','F','G') " + LF
	elseif par07 = 5
		cQuery += " and SB1.B1_GRUPO IN ('A','B','D','E','F','G') " + LF
	endif

	if !empty(par08) .and. empty(par09)
		cQuery += " and SA1.A1_EST = '"+par08+"' " + LF
	
	elseIf empty(par08) .and. !empty(par09)
		cQuery += " and SA1.A1_EST != '"+par09+"' " + LF
	
	elseIf !empty(par08) .and. !empty(par09)
		cQuery += " and SA1.A1_EST = '"+par08+"' AND SA1.A1_EST != '"+par09+"' " + LF
	endIf 
ELSE
	if nLinha = 2 //Linha Hospitalar
		cQuery += " and SB1.B1_GRUPO IN ('C') " + LF
	elseif nLinha = 1 //Linha Dom/Inst
		cQuery += " and SB1.B1_GRUPO IN ('D','E') " + LF	
	endif

ENDIF
//EM 01/11/12 EURIVAN SOLICITOU (A PEDIDO DE SR. VIANA) CONSOLIDAR AS VENDAS RAVA EMB / RAVA CAIXAS 
//EXISTEM SACOS QUE SÃO VENDIDOS PELA RAVA CAIXAS 
//COMENTADO POR FR
//cQuery += " and C5_FILIAL = '"+xFilial('SC5')+"' " + LF
//cQuery += " and C6_FILIAL = '"+xFilial('SC6')+"' " + LF
//cQuery += " and B1_FILIAL = '"+xFilial('SB1')+"' " + LF
//cQuery += " and A1_FILIAL = '"+xFilial('SA1')+"' " + LF
//cQuery += " and C9_FILIAL = '"+xFilial('SC9')+"' " + LF
cQuery += " and SC5.C5_FILIAL = SC6.C6_FILIAL " + LF
cQuery += " and SC6.C6_FILIAL = SC9.C9_FILIAL " + LF

cQuery += " and SC6.D_E_L_E_T_ != '*' " + LF
cQuery += " and SC5.D_E_L_E_T_ != '*' " + LF
cQuery += " and SB1.D_E_L_E_T_ != '*' " + LF
cQuery += " and SF4.D_E_L_E_T_ != '*' " + LF
cQuery += " and SA1.D_E_L_E_T_ != '*' " + LF
cQuery += " and SA3.D_E_L_E_T_ != '*' " + LF
cQuery += " and SC9.D_E_L_E_T_ != '*' " + LF

MemoWrite("C:\Temp\Vendido.sql",cQuery)
If Select("_TMPZA") > 0
	DbSelectArea("_TMPZA")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS '_TMPZA'
_TMPZA->( dbGoTop() )
do while !_TMPZA->(EoF())
	IF !lFora
		nVal := iif( par04 == 1, _TMPZA->TOTALRS, _TMPZA->TOTALKG )
		if len(aTMPZA)=0  // VETOR USADO PARA O CALCULO DO FATOR NO VENDIDO NO MES 
		   aAdd( aTMPZA, _TMPZA->TOTALRS)
		   aAdd( aTMPZA, _TMPZA->TOTALKG )  
		ENDIF   
	ELSE 
		nVal := iif( nRSKG == 1, _TMPZA->TOTALRS, _TMPZA->TOTALKG )
	ENDIF
	_TMPZA->( dbSkip() )
endDo
_TMPZA->( dbCloseArea() )

Return nVal 
