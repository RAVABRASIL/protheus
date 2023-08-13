#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

*************
User Function WFFIN002()
*************

If Select( 'SX2' ) == 0
  // SACO 
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFIN002" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa WFFIN002 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec(1)
  RPCSetType( 3 )
  // CAIXA
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFFIN002" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa WFFIN002 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec(2)

ELSE

  // SACO 
  Exec(1)
  // CAIXA
  Exec(2)

EndIf
conOut( "Finalizando programa WFFIN002 em " + Dtoc( DATE() ) + ' - ' + Time() )
Return



***************

Static Function Exec(nOPc)

***************

Local cQry:=''
aCoord:=aCoordUf:=aCoordRe:={}

cQry:="SELECT A3_COD,A3_NREDUZ FROM " + RetSqlName("SA3") + " SA3 "
cQry+="WHERE A3_GEREN<>'' "
cQry+="AND A3_COD NOT IN ('0244','0245','0248','0306') "
cQry+=" AND A3_ATIVO <> 'N' "

//cQry += " AND A3_COD = '0316' "

cQry+="AND SA3.D_E_L_E_T_='' " 
memowrite("C:\TEMP\WFFIN002.SQL", cQry )
TCQUERY cQry NEW ALIAS 'AUUX'

Do While !AUUX->(EOF())    
   oProcess:=TWFProcess():New("WFFIN002","WFFIN002")
   oProcess:NewTask('Inicio',"\workflow\http\oficial\WFFIN002.html")
   oHtml   := oProcess:oHtml

   oHtml:ValByName("cNome", AUUX->A3_NREDUZ)
   oHtml:ValByName("cLocal", iif(nOpc=1,'Fabrica de Saco','Fabrica de Caixa' ))

   aCoord:=fCoord(AUUX->A3_COD,nOPc)
   aadd( oHtml:ValByName("it.nVlr" ) ,str(aCoord[1]) )
   aadd( oHtml:ValByName("it.nDia")  ,str(aCoord[2])  )		
   aadd( oHtml:ValByName("it.nMedia"),str(aCoord[3]) )
   aCoordUf:=fCoordUf(AUUX->A3_COD,nOPc)   //por UF
   FOR _X1:=1 TO LEN(aCoordUf)
      aadd( oHtml:ValByName("it1.cUF" ) , (aCoordUf[_X1][1]))
      aadd( oHtml:ValByName("it1.nVlrUf" ) ,str(aCoordUf[_X1][2]) )
      aadd( oHtml:ValByName("it1.nDiaUf") , str(aCoordUf[_X1][3]) )		
      aadd( oHtml:ValByName("it1.nMediaUf") , str(aCoordUf[_X1][4]))
   NEXT   
   aCoordRe:=fCoordRe(AUUX->A3_COD,nOPc)  //por REGIÃO
   FOR _X2:=1 TO LEN(aCoordRe)
      aadd( oHtml:ValByName("it2.cRe" ) ,(aCoordRe[_X2][1]) )
      aadd( oHtml:ValByName("it2.nVlrRe" ) ,str(aCoordRe[_X2][2]) )
      aadd( oHtml:ValByName("it2.nDiaRe" ) , str(aCoordRe[_X2][3]) )		
      aadd( oHtml:ValByName("it2.nMediaRe" ) , str(aCoordRe[_X2][4]))
   NEXT
  _user := Subs(cUsuario,7,15)
  oProcess:ClientName(_user)
  oProcess:cTo := "flavia@ravaembalagens.com.br"
  //oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br"
  //oProcess:cTo := "flavia.rocha@ravaembalagens.com.br"
  subj	:= "Titulos em Atraso por Coordenador "+AUUX->A3_COD+'-'+AUUX->A3_NREDUZ+iif(nOpc=1,' -Fabrica de Saco',' -Fabrica de Caixa') 
  oProcess:cSubject  := subj
  oProcess:Start()
  WfSendMail()

  AUUX->(DBSKIP())
enddo

AUUX->(DbCloseArea())




Return 

***************

Static Function fCoord(cCod,nOPc)

***************
Local cQry:=''
Local aRet:={}

cQry:="SELECT "
cQry+="VALOR=SUM(E1_SALDO), "
cQry+="DIA_ATRASO=MAX(CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112)- CONVERT(datetime,E1_VENCREA ,112)AS INT)) ,  "+CHR(13) + CHR(10)
cQry+="MEDIA=AVG(CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112)- CONVERT(datetime,E1_VENCREA ,112)AS INT))  "+CHR(13) + CHR(10)
cQry+="FROM " + RetSqlName("SE1") + " SE1 "+CHR(13) + CHR(10)
cQry+="WHERE "+CHR(13) + CHR(10)
cQry+="E1_TIPO='NF' "+CHR(13) + CHR(10)
if nOPc=1
   cQry+="and E1_FILIAL='01' " +CHR(13) + CHR(10)
elseif nOPc=2
   cQry+="and E1_FILIAL='03' " +CHR(13) + CHR(10)
endif
//cQry+= " AND E1_FILIAL = '" + Alltrim(xFilial("SE1") ) + "' " +CHR(13) + CHR(10)
cQry+="AND E1_SALDO>0 "+CHR(13) + CHR(10)
cQry+="AND E1_VENCREA<CONVERT(VARCHAR,GETDATE(),112) "+CHR(13) + CHR(10)
cQry+="AND E1_VEND1 IN(SELECT A3_COD FROM SA3010 SA3 "+CHR(13) + CHR(10)
cQry+="                WHERE (A3_SUPER LIKE '"+ALLTRIM(cCod)+"%' OR A3_COD LIKE '"+ALLTRIM(cCod)+"%' ) AND SA3.D_E_L_E_T_='') "+CHR(13) + CHR(10)
cQry+=" AND SE1.D_E_L_E_T_='' "+CHR(13) + CHR(10)
MemoWrite("C:\TEMP\FCOORD.SQL", cQry)
TCQUERY cQry NEW ALIAS 'AUUX1'

if AUUX1->(!EOF())
   AADD(aRet, AUUX1->VALOR)
   AADD(aRet, AUUX1->DIA_ATRASO)
   AADD(aRet, AUUX1->MEDIA)
else
   AADD(aRet, 0)
   AADD(aRet, 0)
   AADD(aRet, 0)
endif

AUUX1->(DbCloseArea())

Return  aRet


***************

Static Function fCoordUf(cCod,nOpc)

***************
Local cQry:=''
Local aRet:={}

cQry:="SELECT "
cQry+="A1_EST, "
cQry+="VALOR=SUM(E1_SALDO), "
cQry+="DIA_ATRASO=MAX(CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112)- CONVERT(datetime,E1_VENCREA ,112)AS INT)) ,  "+CHR(13) + CHR(10)
cQry+="MEDIA=AVG(CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112)- CONVERT(datetime,E1_VENCREA ,112)AS INT)) "+CHR(13) + CHR(10)
cQry+="FROM " + RetSqlName("SE1") + " SE1," + RetSqlName("SA1" ) + " SA1 "+CHR(13) + CHR(10)
cQry+="WHERE "+CHR(13) + CHR(10)
cQry+="E1_CLIENTE+E1_LOJA=A1_COD+A1_LOJA "+CHR(13) + CHR(10)
cQry+="AND E1_TIPO='NF' "+CHR(13) + CHR(10)
if nOPc=1
   cQry+="and E1_FILIAL = '01' "+CHR(13) + CHR(10)
elseif nOPc=2
   cQry+="and E1_FILIAL = '03' " +CHR(13) + CHR(10)
endif
//cQry+= " AND E1_FILIAL = '" + Alltrim(xFilial("SE1") ) + "' " +CHR(13) + CHR(10)
cQry+="AND E1_SALDO>0  "+CHR(13) + CHR(10)
cQry+="AND E1_VENCREA<CONVERT(VARCHAR,GETDATE(),112) "+CHR(13) + CHR(10)
cQry+="AND E1_VEND1 IN(SELECT A3_COD FROM SA3010 SA3  "+CHR(13) + CHR(10)
cQry+="                WHERE (A3_SUPER LIKE '"+ALLTRIM(cCod)+"%' OR A3_COD LIKE '"+ALLTRIM(cCod)+"%' ) AND SA3.D_E_L_E_T_='') "+CHR(13) + CHR(10)
cQry+=" AND SE1.D_E_L_E_T_='' "+CHR(13) + CHR(10)
cQry+="GROUP BY A1_EST  "+CHR(13) + CHR(10)
MemoWrite("C:\TEMP\FCOORDUF.SQL", cQry )
TCQUERY cQry NEW ALIAS 'AUUX2'

if AUUX2->(!EOF())
   While  AUUX2->(!EOF())
   AADD(aRet, {AUUX2->A1_EST,AUUX2->VALOR,AUUX2->DIA_ATRASO,AUUX2->MEDIA} )
   AUUX2->(DBSKIP())
   Enddo
else
   AADD(aRet, {" ",0,0,0} )
endif

AUUX2->(DbCloseArea())

Return  aRet

***************

Static Function fCoordRe(cCod,nOpc)

***************
Local cQry:=''
Local aRet:={}

cQry:="SELECT  "
cQry+="CASE WHEN A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte' ELSE CASE WHEN A1_EST  IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') THEN 'Nordeste' ELSE CASE WHEN A1_EST  IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste' ELSE CASE WHEN A1_EST  IN ('MG', 'ES', 'RJ', 'SP') THEN 'Sudeste' ELSE CASE WHEN A1_EST  IN ('RS', 'PR', 'SC') THEN 'Sul' ELSE 'Erro' END  END END END END REGIAO, "+CHR(13) + CHR(10)
cQry+="VALOR=SUM(E1_SALDO), "+CHR(13) + CHR(10)
cQry+="DIA_ATRASO=MAX(CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112)- CONVERT(datetime,E1_VENCREA ,112)AS INT)) ,  "+CHR(13) + CHR(10)
cQry+="MEDIA=AVG(CAST( CONVERT(datetime,CONVERT(VARCHAR,GETDATE(),112),112)- CONVERT(datetime,E1_VENCREA ,112)AS INT)) "+CHR(13) + CHR(10)
cQry+="FROM " + RetSqlName("SE1") + " SE1," + RetSqlName("SA1" ) + " SA1 "+CHR(13) + CHR(10)
cQry+="WHERE "+CHR(13) + CHR(10)
cQry+="E1_CLIENTE+E1_LOJA=A1_COD+A1_LOJA "+CHR(13) + CHR(10)
cQry+="AND E1_TIPO='NF' "+CHR(13) + CHR(10)
if nOPc=1
   cQry+="and E1_FILIAL='01' "+CHR(13) + CHR(10)
elseif nOPc=2
   cQry+="and E1_FILIAL='03' "+CHR(13) + CHR(10)
endif
//cQry+= " AND E1_FILIAL = '" + Alltrim(xFilial("SE1") ) + "' " +CHR(13) + CHR(10)
cQry+="AND E1_SALDO>0  "+CHR(13) + CHR(10)
cQry+="AND E1_VENCREA<CONVERT(VARCHAR,GETDATE(),112) "+CHR(13) + CHR(10)
cQry+="AND E1_VEND1 IN(SELECT A3_COD FROM SA3010 SA3 "+CHR(13) + CHR(10)
cQry+="                WHERE (A3_SUPER LIKE '"+ALLTRIM(cCod)+"%' OR A3_COD LIKE '"+ALLTRIM(cCod)+"%' ) AND SA3.D_E_L_E_T_='') "+CHR(13) + CHR(10)
cQry+="AND SE1.D_E_L_E_T_='' "+CHR(13) + CHR(10)
cQry+="GROUP BY CASE WHEN A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte' ELSE CASE WHEN A1_EST  IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE') THEN 'Nordeste' ELSE CASE WHEN A1_EST  IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste' ELSE CASE WHEN A1_EST  IN ('MG', 'ES', 'RJ', 'SP') THEN 'Sudeste' ELSE CASE WHEN A1_EST  IN ('RS', 'PR', 'SC') THEN 'Sul' ELSE 'Erro' END  END END END END   "+CHR(13) + CHR(10)
MemoWrite("C:\TEMP\FCOORDRE.SQL",cQry)
TCQUERY cQry NEW ALIAS 'AUUX3'

if AUUX3->(!EOF())
   While  AUUX3->(!EOF())
   AADD(aRet, {AUUX3->REGIAO,AUUX3->VALOR,AUUX3->DIA_ATRASO,AUUX3->MEDIA} )
   AUUX3->(DBSKIP())
   Enddo
else
   AADD(aRet, {" ",0,0,0} )
endif

AUUX3->(DbCloseArea())

Return  aRet
