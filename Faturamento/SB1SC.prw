#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "font.ch"
#include "colors.ch"

*************

User Function SB1SC()

************* 

if AllTrim(Upper(FunName())) $ "MATA410" 
	IF  ALLTRIM(M->C5_TIPO) $'B/D'
	   RETURN .T.
	ENDIF
ENDIF

return  ((Len(Alltrim(SB1->B1_COD))>=6.AND.SB1->B1_TIPO=='PA'.AND.SB1->B1_ATIVO=='S').OR.(Len(Alltrim(SB1->B1_COD))<8.AND.SB1->B1_ATIVO=='S')) .and.(iif(ALLTRIM(xfilial('SC5'))=='01',SB1->B1_SETOR!='39',SB1->B1_SETOR=='39') )    



*************

User Function VLDSB1SC(cProd)

************* 

//FR - 11/11/11 - Alterado por Flávia Rocha
//Chamado : 002282 - Solicitado por Marcelo em 16/08/2011
//Criar bloqueio no lancamento de Pedido de Vendas, para que o sistema nao permita 
//a indicação de Clientes e Produtos sem conferencia.  
//Foram criadas validações que são regidas pelo parâmetro RV_BLQCONF
//As validações só irão bloquear caso o parâmetro esteja habilitado
Local lBloqConf := GetMV("RV_BLQCONF")		//.T. = HABILITA BLOQUEIO / .F. = DESABILITA BLOQUEIO

Local LF		:= CHR(13) + CHR(10)
Local lGenerico := .F.


if AllTrim(Upper(FunName())) $ "PREVEN" 
   return .T. 
Endif


if AllTrim(Upper(FunName())) $ "MATA410" 
	IF  ALLTRIM(M->C5_TIPO) $'B/D'
	   RETURN .T.
	ENDIF
ENDIF

IF ALLTRIM(xfilial('SC5'))=='01' .AND. posicione("SB1",1,xFilial('SB1') +cProd,"B1_SETOR" )=='39'
   ALERT('O Produto digitado '+alltrim(cProd)+' nao e um Saco.'  )
   return .F.
ELSEIF ALLTRIM(xfilial('SC5'))=='03' .AND. posicione("SB1",1,xFilial('SB1') +cProd,"B1_SETOR" )!='39'
   ALERT('O Produto digitado '+alltrim(cProd)+' nao e um Caixa.'  )
   return .F.
ENDIF

If Inclui
	If lBloqConf
	   If M->C5_TIPO $ "N"			
			SB1->(DBSETORDER(1))
			SB1->(Dbseek(xFilial("SB1") + cProd ))
			If Len(Alltrim(SB1->B1_COD)) >= 7 
				lGenerico := .T.
			Endif
			
			If !lGenerico				
				If SB1->B1_CONFERI != "S"
				
			    	Aviso(	"CONFERÊNCIA CADASTRO" ,;
					"O Cadastro deste Produto NÃO Foi Conferido !"+ LF +;
					"Favor entrar em Contato com o Depto. Fiscal."+ LF,;
					{"&Continua"},,;
					"Produto: " + cProd + ' - ' + Alltrim(SB1->B1_DESC) )
					Return .F.   
			  	//Else
					//MsgInfo("conferência OK")
			  	Endif
			Endif		
	   Endif
	//Else
		//msginfo("o parâmetro está desativado")
	Endif

Endif

return .T.

        

*************

User Function VLDPROD()

************* 

local nPosProd := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO" })  
local cProd:=M->C6_PRODUTO

If  alltrim(upper(FunName())) == "ESTC005" //SE FOR O PROGRAMA SOLIC. AMOSTRA, NÃO FAZ CRÍTICA
	Return .T.
Endif

if n!=1
	for _x:=len(aCols)  To 1 Step -1 
		if _x!=n
			if aCols[_x][nPosProd]=cProd
				alert("O produto nao pode se repetir")
				return .F.
			endif
	    endif
	next _x
endif


If  M->C5_VOLUME1>0
	if ALLTRIM(Posicione("SB1",1,xFilial("SB1") + cProd, "B1_TIPO"))='PA'
		alert("Nao se pode alterar o volume com PA nos itens")
		return .F.
	endif
ENDIF


return .T.



*************

User Function fVlvol()

************* 

local nPosProd := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO" })  

If  alltrim(upper(FunName())) == "ESTC005" //SE FOR O PROGRAMA SOLIC. AMOSTRA, NÃO FAZ CRÍTICA
	Return .T.
Endif

If  M->C5_VOLUME1>0
	for _Y:=1 to len(aCols)
	if ALLTRIM(Posicione("SB1",1,xFilial("SB1") + aCols[_Y][nPosProd], "B1_TIPO"))='PA'
		alert("Nao se pode alterar o volume com PA nos itens")
		return .F.
	endif
	next _Y
ENDIF



return .T.

*************

User Function VLDPRODOC()

************* 
/*
//local nPosProd 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "CK_PRODUTO" })  
local cProd		:=M->CK_PRODUTO
Local aAreaTMP	:= getArea("TMP1")

If  alltrim(upper(FunName())) == "ESTC005" //SE FOR O PROGRAMA SOLIC. AMOSTRA, NÃO FAZ CRÍTICA
	Return .T.
Endif

If !TMP1->CK_FLAG .AND. ( INCLUI .OR. ALTERA )
	
	TMP1->(dbGoTop())
	
	While TMP1->(!EOF()) 
		if !TMP1->CK_FLAG
			if TMP1->CK_PRODUTO = cProd
				alert("O produto nao pode se repetir")
				//RestArea(aAreaTMP)
				return .F.
			endif
	    endif
	    TMP1->(dbSkip())
	EndDo
endif

//RestArea(aAreaTMP)
*/
return .T.


