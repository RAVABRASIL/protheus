#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#include "topconn.ch"

*************

USER FUNCTION CLITES(cCliente,cLoja) 

*************

Local nPosTES   := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"}) 
Local nPosCF    := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_CF" })       
Local nPosCLA   := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_CLASFIS" })  
Local cTes:=''
local nQtdPre:=0 
Local LF := CHR(13) + CHR(10)
Local cQuery := "" 
Local cCNPJ	:= ""
Local lBloqConf := GetMV("RV_BLQCONF")     //.T. = HABILITA BLOQUEIO / .F. = DESABILITA BLOQUEIO
Private cALERTA := ""
//FR - Alterado por Flávia Rocha em 11/11/11
//Chamado : 002282 - Solicitado por Marcelo em 16/08/2011
//Criar bloqueio no lancamento de Pedido de Vendas, para que o sistema nao permita 
//a indicação de Clientes e Produtos sem conferencia.  
//Foram criadas validações que são regidas pelo parâmetro RV_BLQCONF
//As validações só irão bloquear caso o parâmetro esteja habilitado


 
IF  ALLTRIM(M->C5_TIPO) $'B/D'
    RETURN .T.
ENDIF

If Empty(cLoja)
   cLoja:= posicione("SA1",1, xFilial("SA1")+cCliente, "A1_LOJA" )
    //cLoja:='01'    
Endif

DbselectArea("SA1") 
Dbsetorder(1)
//Dbsetorder(3)
//if SA1->(Dbseek(xFilial("SA1")+cCNPJ,.F.))
if SA1->(Dbseek(xFilial("SA1")+cCliente+cLoja,.F.))

   cTes:=SA1->A1_TES
   aDadosCfo:={}
   Aadd(aDadosCfo,{"OPERNF","S"})
   Aadd(aDadosCfo,{"TPCLIFOR",SA1->A1_TIPO})
   Aadd(aDadosCfo,{"UFDEST",SA1->A1_EST})
   Aadd(aDadosCfo,{"INSCR", SA1->A1_INSCR})
Else
   alert('Cliente e loja não cadastrados.')
   cALERTA := 'Cliente e Loja Não Cadastrados.'
   If  alltrim(upper(FunName())) == "FATC019"
   		If !Empty(cALERTA)
			MSGALERT(cALERTA)
		Endif
	Endif

   return .F.
Endif

IF cTes $ '516' 
   If  alltrim(upper(FunName())) != "FATC019"
   		alert('O Tes associado ao Cliente e de Amostra, Não pode ser lançado pelo pedido de venda.')
   Endif
   cALERTA := "O TES Associado ao Cliente é de Amostra, Não Pode Ser Lançado pelo Pedido de Venda."
   If  alltrim(upper(FunName())) == "FATC019"
   		If !Empty(cALERTA)
			MSGALERT(cALERTA)
		Endif
	Endif

   return.F.
end


If Inclui

	//FR - 28/04/2011 - CHAMADO 002040 - Marcos
	//TRANSFERI ESTA FUNÇÃO PARA ESTE PRW, POIS ESTAVA NO X3_VALID DO SX3, DEIXANDO O SISTEMA LENTO
	//ESTA FUNÇÃO NÃO RETORNA NADA, APENAS MOSTRA MSG INFORMANDO QUE O CLIENTE POSSUI BLOQUEIO xDD,
	//SOMENTE AVISO.
	
	//*****************************
	//User Function fValidXDD(cCliente)
	//***************************** 
	//Local lValido := .T.
	  
	
	//esta função será chamada assim que digitado o código do cliente, para que
	//o usuário não tenha que completar todo o pedido e haver a validação só no fim (botão OK)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(DbSeek(xFilial("SA1")+ cCliente + cLoja ))
	If SA1->A1_BLQXDD == "S"
	   //Aviso("Bloqueio","Cliente bloqueado para venda xDD.",{"OK"})  
	   If  alltrim(upper(FunName())) != "FATC019"
	   		Alert( "Cliente bloqueado para venda xDD." )
	   Endif
	   cALERTA := "Cliente Bloqueado Para Venda xDD."     
	   If  alltrim(upper(FunName())) == "FATC019"
	   		If !Empty(cALERTA)
				MSGALERT(cALERTA)
			Endif
		Endif
		
	Endif 
	
	//Return (lValido)  
    //////////////validação qto à conferência do cadastro do Cliente
    If lBloqConf
	   IF  ALLTRIM(M->C5_TIPO) $'N'			
			SA1->(DBSETORDER(1))
			SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja ))
			If SA1->A1_CONFERI != "S"
			
		    	Aviso(	"CONFERÊNCIA CADASTRO" ,;
				"O Cadastro deste Cliente NÃO Foi Conferido !"+ LF +;
				"Favor entrar em Contato com o Depto. Fiscal."+ LF,;
				{"&Continua"},,;
				"Cliente: " + cCliente + '/' + cLoja + ' - ' + Alltrim(SA1->A1_NREDUZ) )
				Return .F.
		  	//Else
				//MsgInfo("conferência OK")
		  	Endif
		
		Endif
	//Else
		//msginfo("o parâmetro está desativado")
	Endif
	///////////////////////////////////////////////////////   
   If !empty(cTes)	  
	  DbselectArea("SF4")
	  Dbsetorder(1)
	  SF4->(Dbseek(xFilial("SF4")+cTes,.F.))
	  if Type("cPrePed") == "C" 
		  if empty(cPrePed)
			 aCols[1][nPosTES]:=cTEs                                                                                                               
	         aCols[1][nPosCF]:=MAFISCFO(,SF4->F4_CF, aDadosCFO)                                                                                                                  	      
	      Else
	          
	          nQtdPre:=QtdPre(cPrePed)      
	          
	          For nIt:=1 to nQtdPre
	              aCols[nIt][nPosTES]:=cTEs
	              aCols[nIt][nPosCF]:=MAFISCFO(,SF4->F4_CF, aDadosCFO)      
	              aCols[nIt][nPosCLA]:=substr(posicione("SB1",1, xFilial("SB1") +aCols[nIt][2], "B1_ORIGEM" ),1,1)+SF4->F4_SITTRIB
	          Next
	          
	      endif
      endif
   Else
     alert('Favor atualizar o Tes no Cadastro do Cliente: ' + alltrim(cCliente) ) 
     //cALERTA := "Favor Atualizar o TES no Cadastro do Cliente: " + alltrim(cCliente)
     
     //Return .F.
   Endif	 
Endif

If  alltrim(upper(FunName())) == "FATC019"
	If !Empty(cALERTA)
		MSGALERT(cALERTA)
	Endif
Endif

If Altera
   For _X:=1 to Len(aCols)
	   DbselectArea("SF4")
	   Dbsetorder(1)
	   SF4->(Dbseek(xFilial("SF4")+cTes,.F.))
	   aCols[_X][nPosTES]:=cTEs                                                                                                               
	   aCols[_X][nPosCF]:=MAFISCFO(,SF4->F4_CF, aDadosCFO)          
       aCols[_X][nPosCLA]:=substr(posicione("SB1",1, xFilial("SB1") +aCols[_X][2], "B1_ORIGEM" ),1,1)+SF4->F4_SITTRIB
   Next
Endif


If  alltrim(upper(FunName())) == "FATC019"
	If !Empty(cALERTA)
		MSGALERT(cALERTA)
	Endif
Endif


Return .T.      


*************

USER FUNCTION TESCLI(cCliente) 

*************
cALERTA := ""

If empty(cCliente)
   If  alltrim(upper(FunName())) != "FATC019"
   		alert('Favor Digitar o Cliente antes do TES')   		
   Endif
   cALERTA := "Favor Digitar o Cliente Antes do TES"
   
   Return .F.
endif

If  alltrim(upper(FunName())) == "FATC019"
	If !Empty(cALERTA)
		MSGALERT(cALERTA)
	Endif
Endif


Return .T.
                
***************

Static Function QtdPre(cNum)

***************
local cQry:=''
local nRet:=1

cQry:="SELECT COUNT(*) QTD FROM SZ6020 SZ6 "
cQry+="WHERE  Z6_FILIAL='"+xFilial('SZ6')+"' "
cQry+="AND Z6_NUM='"+cNum+"' "
cQry+="AND SZ6.D_E_L_E_T_!='*' "
If Select("_TMPQ") > 0       
	DbSelectArea("_TMPQ")    
	DbCloseArea()
Endif

TCQUERY cQry NEW ALIAS "_TMPQ"
_TMPQ->(DbGotop())

If _TMPQ->(!EOF())
   nRet:=_TMPQ->QTD
ENDIF
_TMPQ->(DBCLOSEAREA())

Return nRet   