#include "protheus.ch"
#include "topconn.ch"

*************

User Function ESTR009()

*************

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

If pergunte("ESTR009",.T.)
   MsAguarde( { || runReport() }, "Aguarde. . .", "Ordem de Producao Caixa . . ." )
endif

return

***************

Static Function runReport()

***************
Local  cQry := ''
Local cOP:=cProd:=''
local nLin:=100
local nlin2:=0

cQry := "SELECT  "
cQry += "VIA=CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(SC2.C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*' AND SX5.X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "' ))) " + CHR(13) + CHR(10) 
cQry += " IN('FC01')  THEN '1'  " + CHR(13) + CHR(10)
cQry += "ELSE  CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(SC2.C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*' AND SX5.X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "' ))) " + CHR(13) + CHR(10)
cQry += " IN ('CVP','CVFEVA') THEN '2'  "+ CHR(13) + CHR(10)
//FR
//cQry += "ELSE  CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(SC2.C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*'))) IN ('DOB','ICVR') THEN '7'  "
//FR
//foi retirado pois o processo da seladora agora focu unido ao da corte e vinco 
//cQry += "ELSE  CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*')))='SEL'  THEN '3' "
cQry += "ELSE  CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*' AND SX5.X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "' ))) " + CHR(13) + CHR(10) 
cQry += " ='ICVR'  THEN '4' "+ CHR(13) + CHR(10)
cQry += "ELSE  CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*' AND SX5.X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "'))) " + CHR(13) + CHR(10) 
cQry += " ='DOB'  THEN '5'  "+ CHR(13) + CHR(10)
cQry += "ELSE  CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*' AND SX5.X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "'))) " + CHR(13) + CHR(10)
cQry += " ='MONT'  THEN '6'  " + CHR(13) + CHR(10)
cQry += "ELSE  CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*' AND SX5.X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "'))) " + CHR(13) + CHR(10)
cQry += " ='EMB'  THEN '7'  " + CHR(13) + CHR(10)

cQry += "ELSE CASE WHEN B1_TIPO='PI' AND C2_SEQUEN='001' THEN '1' ELSE 'ERRO'END END END END END END "+ CHR(13) + CHR(10)
cQry += " END " + CHR(13) + CHR(10)  //END DA EMBALAGEM
cQry += " ,MAQ=(SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(SC2.C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*' AND SX5.X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "' ) " + CHR(13) + CHR(10)

cQry += ",B1_TIPO,C2_SEQPAI, C2_PRODUTO,*  "+ CHR(13) + CHR(10)
cQry += "FROM "+retSqlName('SC2')+" SC2 "+ CHR(13) + CHR(10)
cQry += "join "+retSqlName('SB1')+" SB1 on C2_PRODUTO=B1_COD  "+ CHR(13) + CHR(10)
cQry += "left join "+retSqlName('SB5')+" SB5 on C2_PRODUTO=B5_COD AND SB5.D_E_L_E_T_!='*'  "+ CHR(13) + CHR(10)
cQry += "WHERE  "+ CHR(13) + CHR(10)
cQry += "C2_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CHR(13) + CHR(10)
//cQry += "AND C2_SEQUEN!='002' "+ CHR(13) + CHR(10) //FR
//cQry += "AND C2_SEQPAI!='002' "+ CHR(13) + CHR(10) //FR
cQry += "and C2_FILIAL='03'   "+ CHR(13) + CHR(10)
// Laminadora como item do PA 
//cQry += "AND CASE WHEN LTRIM(RTRIM((SELECT TOP 1 X5_CHAVE FROM SX5020 SX5 WHERE SX5.X5_TABELA='ZE' AND SX5.X5_DESCRI+SX5.X5_DESCSPA+SX5.X5_DESCENG LIKE '%'+LTRIM(RTRIM(SC2.C2_PRODUTO))+'%' AND SX5.D_E_L_E_T_!='*'))) IN('LA01')  THEN 'X' ELSE '' END !='X'  "
cQry += "AND SC2.D_E_L_E_T_!='*' "+ CHR(13) + CHR(10)
cQry += "AND SB1.D_E_L_E_T_!='*' "+ CHR(13) + CHR(10)
cQry += "ORDER BY C2_NUM,VIA "+ CHR(13) + CHR(10)
MemoWrite("C:\TEMP\VIACOLETOR.SQL", cQry)
TCQUERY cQry NEW ALIAS '_TMPX'
_TMPX->( dbGotop() )
oPrt := TMSPrinter():new("Ordem de Producao de Caixa") 
oPrt:SetPortrait()

DbSelectArea('SC2')
DbSetOrder(1)

Do While ! _TMPX->( EoF() )
   cOP:=_TMPX->C2_NUM
   SC2->(dbSeek('03'+cOP+'01'+'001'))  
   nLin:=100
   oPrt:EndPage()
   oPrt:StartPage() 
   Do While ! _TMPX->( EoF() ) .AND. _TMPX->C2_NUM==cOP
      cProd:=_TMPX->C2_PRODUTO	   	   
	  Do While ! _TMPX->( EoF() ) .AND. _TMPX->C2_NUM==cOP .AND. _TMPX->C2_PRODUTO==cProd	   
		 If SUBSTR(SC2->C2_PRODUTO,1,2)!='PI'	
			If alltrim(_TMPX->VIA) $ '1/2/3'
	           VIA123(_TMPX->B1_DESC,_TMPX->C2_NUM,_TMPX->C2_EMISSAO,_TMPX->C2_QUANT,_TMPX->C2_PRODUTO,SC2->C2_PRODUTO,@nLin,@nLin2)
            elseIf alltrim(_TMPX->VIA) $ '4/5'
	           VIA45(_TMPX->B1_DESC,_TMPX->C2_NUM,_TMPX->C2_EMISSAO,_TMPX->C2_QUANT,_TMPX->C2_PRODUTO,SC2->C2_PRODUTO,@nLin,@nLin2)
            elseIf alltrim(_TMPX->VIA)='6'
	           VIA6(_TMPX->B1_DESC,_TMPX->C2_NUM,_TMPX->C2_EMISSAO,_TMPX->C2_QUANT,SC2->C2_PRODUTO,@nLin,@nLin2)
	  		elseIf alltrim(_TMPX->VIA)='7'
	           VIA7(_TMPX->B1_DESC,_TMPX->C2_NUM,_TMPX->C2_EMISSAO,_TMPX->C2_QUANT,SC2->C2_PRODUTO,@nLin,@nLin2)
            EndIf
		 Else
			VIAPI(_TMPX->B1_DESC,_TMPX->C2_NUM,_TMPX->C2_EMISSAO,_TMPX->C2_QUANT,SC2->C2_PRODUTO,@nLin,@nLin2)
		 EndIf
		 _TMPX->(Dbskip() )   
	  EndDo
	  If !SUBSTR(SC2->C2_PRODUTO,1,2)='PI'
		 If alltrim(_TMPX->VIA) $'4/6/7'
		    nLin:=100
		    oPrt:EndPage()
		    oPrt:StartPage() 
	     Else
	        If alltrim(_TMPX->VIA)='5'
	           nLin+=900
	        ELSE
	           nLin+=700          
	        ENDIF
	     EndIf
      ENDIF
   EndDo
EndDo
			
_TMPX->(DbCloseArea())
SC2->(DbCloseArea())
oPrt:EndPage()
oPrt:Preview()

Return 


**************

Static Function VIA123(cDesc,cNum,cEmissao,nQuant,cPI,cPA,nLin,nLin2)

***************

oPrt:Say(nLin,15,"Ordem de Produção:",oFont01, 300, , , 0 )
nLin+=80
if _TMPX->VIA='1'
   oPrt:Say(nLin,15,"Facão",oFont02, 300, , , 0 )
elseif _TMPX->VIA='2'
   oPrt:Say(nLin,15,"Corte e Vinco + Seladora",oFont02, 300, , , 0 )
elseif _TMPX->VIA='3'
   oPrt:Say(nLin,15,"Seladora",oFont02, 300, , , 0 )
EndIf
nLin+=80
nLin2:=nLin+700
oPrt:Box(nlin2,15 ,nlin, 2350, )
nLin+=30
oPrt:Say(nLin,25,"Descrição:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,cDesc,oFont04, 300, , , 0 )
oPrt:Say(nLin,1800,"Informações da OP:",oFont05, 300, , , 0 )
nLin+=80
If _TMPX->VIA='1' .OR. _TMPX->VIA='2'
   oPrt:Say(nLin,25,"Dimensão :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_DIMENSB,oFont04, 300, , , 0 )
/*
elseIf _TMPX->VIA='2'
   oPrt:Say(nLin,25,"Arranjo  :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_ARRANJB,oFont04, 300, , , 0 )
*/
EndIf
oPrt:Say(nLin,1800,cNum,oFont04, 300, , , 0 )
nLin+=80
If _TMPX->VIA='1' .OR. _TMPX->VIA='2' 
   oPrt:Say(nLin,25,"Arranjo  :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_ARRANJB,oFont04, 300, , , 0 )
EndIf
oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1800,ALLTRIM(cPI)+'/'+ALLTRIM(cPA),oFont04, 300, , , 0 )

Return 


**************

Static Function VIA45(cDesc,cNum,cEmissao,nQuant,cPI,cPA,nLin,nLin2)

***************

local aAcess:={}

oPrt:Say(nLin,15,"Ordem de Produção:",oFont01, 300, , , 0 )
nLin+=80
if _TMPX->VIA='4'
   oPrt:Say(nLin,15,"Impressora",oFont02, 300, , , 0 )
elseif _TMPX->VIA='5'
   oPrt:Say(nLin,15,"Dobradeira e Coladeira",oFont02, 300, , , 0 ) 
elseif _TMPX->VIA='7'
   oPrt:Say(nLin,15,"Impressora + Dobradeira e Coladeira",oFont02, 300, , , 0 )
EndIf
nLin+=80
nLin2:=nLin+1300
oPrt:Box(nlin2,15 ,nlin, 2350, )
nLin+=30
oPrt:Say(nLin,25,"Descrição:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,cDesc,oFont04, 300, , , 0 )                        
oPrt:Say(nLin,1800,"Informações da OP:",oFont05, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,1800,cNum,oFont04, 300, , , 0 )
If _TMPX->VIA='4'
   oPrt:Say(nLin,25,"Clichês  :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_CLICHE,oFont04, 300, , , 0 )
   nLin+=80
   oPrt:Say(nLin,25,"Faca     :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_FACAP,oFont04, 300, , , 0 )
   
   oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
   oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
   nLin+=80
   oPrt:Say(nLin,25,"Arranjo  :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_ARRANJP,oFont04, 300, , , 0 )
   
   oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 ) 
   oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 ) 
   nLin+=80
   oPrt:Say(nLin,25,"Dimensão :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_DIMENSP,oFont04, 300, , , 0 )
   
   oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
   oPrt:Say(nLin,1800,ALLTRIM(cPI)+'/'+ALLTRIM(cPA),oFont04, 300, , , 0 )
/*
   nLin+=80
   oPrt:Say(nLin,25,"Cor      :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,'TESTE-Cor',oFont04, 300, , , 0 )
*/
ElseIf _TMPX->VIA='5'
   nLin+=80
   oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
   oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
   nLin+=80
   oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 )
   oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 )
   nLin+=80
   oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
   oPrt:Say(nLin,1800,ALLTRIM(cPI)+'/'+ALLTRIM(cPA),oFont04, 300, , , 0 )
Elseif _TMPX->VIA = '7'
	//COPIEI DO '4'
	oPrt:Say(nLin,25,"Clichês  :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_CLICHE,oFont04, 300, , , 0 )
   nLin+=80
   oPrt:Say(nLin,25,"Faca     :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_FACAP,oFont04, 300, , , 0 )
   
   oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
   oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
   nLin+=80
   
   oPrt:Say(nLin,25,"Arranjo  :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_ARRANJP,oFont04, 300, , , 0 )
   
   oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 ) 
   oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 ) 
   nLin+=80
   
   oPrt:Say(nLin,25,"Dimensão :",oFont03, 300, , , 0 )
   oPrt:Say(nLin,420,_TMPX->B5_DIMENSP,oFont04, 300, , , 0 )
   
   oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
   oPrt:Say(nLin,1800,ALLTRIM(cPI)+'/'+ALLTRIM(cPA),oFont04, 300, , , 0 )
   //COPIEI DO '5'
   //nLin+=80
   //oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
   //oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
   //nLin+=80
   //oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 )
   //oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 )
   //nLin+=80
   //oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
   //oPrt:Say(nLin,1800,ALLTRIM(cPI)+'/'+ALLTRIM(cPA),oFont04, 300, , , 0 )
EndIf
nLin+=80
oPrt:Say(nLin,25,"Acessórios:",oFont03, 300, , , 0 )
aAcess:=Acess(cPI)
For X:=1 to Len(aAcess) 
    nLin+=80
    oPrt:Say(nLin,25,alltrim(aAcess[X][1])+'-'+alltrim(aAcess[X][2]),oFont04, 300, , , 0 )
Next

Return 

**************

Static Function VIA6(cDesc,cNum,cEmissao,nQuant,cPA,nLin,nLin2)

***************

local aAcess:={}
//alert("entrou")
oPrt:Say(nLin,15,"Ordem de Produção:",oFont01, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,15,"Montagem",oFont02, 300, , , 0 )
nLin+=80
nLin2:=nLin+1300
oPrt:Box(nlin2,15 ,nlin, 2350, )
nLin+=30
oPrt:Say(nLin,25,"Descrição:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,cDesc,oFont06, 300, , , 0 )
oPrt:Say(nLin,1800,"Informações da OP:",oFont05, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,1800,cNum,oFont04, 300, , , 0 )
oPrt:Say(nLin,25,"Qtd. Pacote:",oFont03, 300, , , 0 )
oPrt:Say(nLin,490,TRANSFORM(_TMPX->B5_QTDEMB,'@E 9999'),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Qtd. Frd:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,TRANSFORM(_TMPX->B5_QTDFIM,'@E 9999'),oFont04, 300, , , 0 )
oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Peso Pacote:",oFont03, 300, , , 0 )
oPrt:Say(nLin,490,TRANSFORM(_TMPX->B5_QTDEMB*_TMPX->B1_PESO,'@E 9999')+' Kg',oFont04, 300, , , 0 )
oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Peso Frd:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,TRANSFORM(_TMPX->B5_QTDFIM*_TMPX->B1_PESO,'@E 9999')+' Kg',oFont04, 300, , , 0 )
oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1800,ALLTRIM(cPA),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Acessórios:",oFont03, 300, , , 0 )
aAcess:=Acess(cPA)
For X:=1 to Len(aAcess) 
    nLin+=80
    oPrt:Say(nLin,25,alltrim(aAcess[X][1])+'-'+alltrim(aAcess[X][2]),oFont04, 300, , , 0 )
Next

Return


**************

Static Function VIA7(cDesc,cNum,cEmissao,nQuant,cPA,nLin,nLin2)

***************

local aAcess:={}
//alert("entrou")
oPrt:Say(nLin,15,"Ordem de Produção:",oFont01, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,15,"Embalagem",oFont02, 300, , , 0 )
nLin+=80
nLin2:=nLin+1300
oPrt:Box(nlin2,15 ,nlin, 2350, )
nLin+=30
oPrt:Say(nLin,25,"Descrição:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,cDesc,oFont06, 300, , , 0 )
oPrt:Say(nLin,1800,"Informações da OP:",oFont05, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,1800,cNum,oFont04, 300, , , 0 )
oPrt:Say(nLin,25,"Qtd. Pacote:",oFont03, 300, , , 0 )
oPrt:Say(nLin,490,TRANSFORM(_TMPX->B5_QTDEMB,'@E 9999'),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Qtd. Frd:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,TRANSFORM(_TMPX->B5_QTDFIM,'@E 9999'),oFont04, 300, , , 0 )
oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Peso Pacote:",oFont03, 300, , , 0 )
oPrt:Say(nLin,490,TRANSFORM(_TMPX->B5_QTDEMB*_TMPX->B1_PESO,'@E 9999')+' Kg',oFont04, 300, , , 0 )
oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Peso Frd:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,TRANSFORM(_TMPX->B5_QTDFIM*_TMPX->B1_PESO,'@E 9999')+' Kg',oFont04, 300, , , 0 )
oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1800,ALLTRIM(cPA),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Acessórios:",oFont03, 300, , , 0 )
aAcess:=Acess(cPA)
For X:=1 to Len(aAcess) 
    nLin+=80
    oPrt:Say(nLin,25,alltrim(aAcess[X][1])+'-'+alltrim(aAcess[X][2]),oFont04, 300, , , 0 )
Next

Return 
 


**************

Static Function VIAPI(cDesc,cNum,cEmissao,nQuant,cPA,nLin,nLin2)

***************

local aAcess:={}

oPrt:Say(nLin,15,"Ordem de Produção:",oFont01, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,15,"Laminadora",oFont02, 300, , , 0 )
nLin+=80
nLin2:=nLin+1300
oPrt:Box(nlin2,15 ,nlin, 2350, )
nLin+=30
oPrt:Say(nLin,25,"Descrição:",oFont03, 300, , , 0 )
oPrt:Say(nLin,420,cDesc,oFont06, 300, , , 0 )
oPrt:Say(nLin,1800,"Informações da OP:",oFont05, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,1800,cNum,oFont04, 300, , , 0 )
oPrt:Say(nLin,25,"Largura Bobina:",oFont07, 300, , , 0 )
oPrt:Say(nLin,550,transform(_TMPX->B5_LARBOBB, '@E 9.9999'),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Gr/M2:",oFont07, 300, , , 0 )
oPrt:Say(nLin,240,transform(_TMPX->B5_GRAMAB, '@E 999.99'),oFont04, 300, , , 0 )
oPrt:Say(nLin,1800,'Data:',oFont05, 400, , , 0 )
oPrt:Say(nLin,2030,DTOC(STOD(cEmissao)),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Largura Filme:",oFont07, 300, , , 0 )
oPrt:Say(nLin,510,transform(_TMPX->B5_LARFILB, '@E 9.9999'),oFont04, 300, , , 0 )
oPrt:Say(nLin,1800,'QTD:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1950,TRANSFORM(nQuant,'@E 999,999.99'),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Espessura Filme:",oFont07, 300, , , 0 )
oPrt:Say(nLin,580,transform(_TMPX->B5_ESPFILB, '@E 9.9999'),oFont04, 300, , , 0 )
oPrt:Say(nLin,1570,'Codigo:',oFont05, 400, , , 0 )
oPrt:Say(nLin,1800,ALLTRIM(cPA),oFont04, 300, , , 0 )
nLin+=80
oPrt:Say(nLin,25,"Acessórios:",oFont03, 300, , , 0 )
aAcess:=Acess(cPA)
For X:=1 to Len(aAcess) 
    nLin+=80
    oPrt:Say(nLin,25,alltrim(aAcess[X][1])+'-'+alltrim(aAcess[X][2]),oFont04, 300, , , 0 )
Next

Return 

***************

Static Function Acess(cCod)

***************

local cQry:=''
local aRet:={}
cQry:="SELECT G1_COMP,B1_DESC,G1_COD,* FROM "+retSqlName('SG1')+" SG1,"+retSqlName('SB1')+" SB1 "
cQry+="WHERE "
cQry+="G1_COMP=B1_COD "
cQry+="AND G1_COD='"+cCod+"' "
cQry+="AND SG1.D_E_L_E_T_!='*'  "
MemoWrite("C:\TEMP\ACESS.SQL", cQry )
TCQUERY cQry NEW ALIAS '_TMPY'
_TMPY->( dbGotop() )

IF _TMPY->(!EOF())
	Do While _TMPY->(!EOF())
	   aAdd( aRet, { _TMPY->G1_COMP, _TMPY->B1_DESC } )
	   _TMPY->(DBSKIP())
	endDo
ELSE
    aAdd( aRet, { '', '' } )
ENDIF	

_TMPY->(DBCLOSEAREA())

Return aRet 


