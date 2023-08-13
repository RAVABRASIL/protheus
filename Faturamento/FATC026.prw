#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"


*************

user function FATC026()

*************

Local cProd := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_CODPRO'})]				        	
local nPeso := posicione("SB1",1,xFilial('SB1') + cProd,"B1_PESO")


aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_FATOR'})]	:=M->DA1_PRCVEN/nPeso

Return  .T.




*************

user function FATC261()

*************
// RECALCULA O FATOR APOS  DIGITAR O DESCONTO 

Local nPrcBase := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_PRCBAS'})]				        	
Local nVlrDesc:=M->DA1_VLRDESC
Local cProd := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_CODPRO'})]				        	
Local nPeso := posicione("SB1",1,xFilial('SB1') + cProd,"B1_PESO")
Local nFatReaj:=0
local nPrcVend:=0

//nFatReaj:= (nPrcBase-nVlrDesc)/ nPrcBase
//nPrcVend:=nPrcBase*nFatReaj

nPrcVend:=nPrcBase-nVlrDesc


aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_FATOR'})]	:=nPrcVend/nPeso

Return  .T.


*************

user function FATC262()

*************
// RECALCULA O FATOR APOS  DIGITAR O FATOR DE REAJUSTE  

Local nPrcBase := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_PRCBAS'})]				        	
Local cProd := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_CODPRO'})]				        	
Local nPeso := posicione("SB1",1,xFilial('SB1') + cProd,"B1_PESO")
Local nFatReaj:=0
local nPrcVend:=0

nFatReaj:= M->DA1_PERDES
nPrcVend:=nPrcBase*nFatReaj


aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'DA1_FATOR'})]	:=nPrcVend/nPeso

Return  .T.



*************

user function FATC263()

*************


Local nPrcLis := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRUNIT'})]				        	

// TABELA DA REGRA DE DESCONTO 
ACO->( dbSetOrder( 2 ) )

IF ! ACO->( dbSeek( xFilial( "AC0" ) + M->C5_TABELA+M->C5_CONDPAG   ) )
     A410ReCalc()
     aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRCVEN'})]:=nPrcLis				        	

ENDIF

Return  .T.



*************

user function FATC264()

*************
LOCAL nRet:=0

nRet:=aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRUNIT'})] - aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRCVEN'})]				        					        	

IF nRet>0
	
    aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_DESCONT'})]:=((aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRUNIT'})] - aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRCVEN'})])/aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRUNIT'})])*100				        					        	

	/*
	If ExistTrigger('C6_VALDESC') // verifica se existe trigger(gatilho) para este campo      
	   RunTrigger(2,nLin,nil,,'C6_VALDESC')
	Endif
	*/	 
Else
   nRet:=0
Endif

Return  nRet


*************

user function FT210OPC()

*************

/*
Ponto-de-Entrada: FT210OPC - Permite interrupção do processo

Descrição:
Este ponto de entrada é executado apos a confirmação da liberação do pedido de venda por regra e antes do inicio da transação.
Seu objetivo é permitir a interrupção do&nbsp;processo, mesmo com a confirmação do usuário.
*/

//Local cNomUsu:=alltrim(substr(cUsuario,7,15))
//Local cCodUsu :=usu(cNomUsu)   
local cCodUsu := __CUSERID     
Local aAreaAtu	:= GetArea()
Local nPrcLim := 0
local lSoDir:=.F.
local cCodSup:=cCodA3:=''

// diertor libera qualquer situacao                        // ADMINISTRADOR 
if alltrim(cCodUsu) $ GetNewPar('MV_CODDIR','000279') .OR. alltrim(cCodUsu)='000000'
	RestArea(aAreaAtu)
	return PARAMIXB[1]
EndIf


SC6->( dbseek( xFilial("SC6") + SC5->C5_NUM, .T. ) )

Do While !SC6->(EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
    nPrcLim:=posicione("SB1",1,xFilial('SB1') + SC6->C6_PRODUTO,"B1_PRV1")*(1+GetNewPar('MV_LIMDIR',0.14))
    if SC6->C6_PRCVEN<nPrcLim
       lSoDir:=.T.
       exit
    Endif
   SC6->(dbSkip())
EndDo   
if lSoDir   
   if ! alltrim(cCodUsu) $ GetNewPar('MV_CODDIR','000279')
      alert('Esse Pedido so pode ser Liberado pela Diretoria')
      RestArea(aAreaAtu)
      Return 
   Endif   
Else   
   // ASSOCIA CODIGO DO SIGA AO CODIGO DO SUPERVISOR (A3_SUPER)
   cCodA3:=Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1 , "A3_SUPER")
   cCodSup:=Posicione("SA3",1,xFilial("SA3")+cCodA3 , "A3_CODUSR")
   if  alltrim(cCodSup)==alltrim(cCodUsu) 
       RestArea(aAreaAtu)
       return PARAMIXB[1]
   Else
       alert('Esse Pedido so pode ser Liberado pelo Supervisor( '+ UsrFullName(cCodSup)+' )'    )
       RestArea(aAreaAtu)
       return 
   Endif  
Endif

Return 

***************

Static Function Usu( cSoli )

***************

local ccod:=''

PswOrder(2)
If PswSeek( cSoli, .T. )
	aUsuarios  := PSWRET()
	ccod       := Alltrim(aUsuarios[1][1])     	// usuário
Endif

return ccod
