#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"

//--------------------------------
//Programa: CTBC001.PRW
//Data    : 17/06/10
//Autoria : Flávia Rocha
//Função  : U_CTBC001
//--------------------------------

//Função utilizada dentro do inicalizador padrão do campo:
/*
A2_CONTA - traz o número da conta contábil analítica de acordo com a sequência do fornecedor
Conta 2.1.1.1.01 + código do fornecedor sequencial
Exemplo: próximo código de fornecedor 001657, a conta ficará: 211101001657

*/

****************************************************
User function CTBC001()
****************************************************

Local cQuery 	:= ""
Local cConta  	:= ""
Local cContA2	:= ""
Local LF      	:= CHR(13)+CHR(10)
Local cA2Cod	:= "" 
Local nA2Cod    := 0

If Inclui
    	
	cQuery := " Select TOP 1 A2_COD " + LF
	cQuery += " FROM "+RetSqlName("SA2") +" SA2 "+LF
	cQuery += " WHERE SA2.D_E_L_E_T_ = '' " + LF
	//cQuery += " AND A2_COD NOT IN ('VENDER', 'UNIAO', 'SECRET', 'MUNIC', 'INPS','ESTADO','999999' , 'V0190V', '1181', 'V0204') " + LF
	cQuery += " AND A2_COD NOT LIKE  'V%' "+LF
	cQuery += " AND A2_COD NOT LIKE  'S%' "+LF
	cQuery += " AND A2_COD NOT LIKE  'E%' "+LF
	cQuery += " AND A2_COD NOT LIKE  '99%' "+LF
	cQuery += " AND LEN(A2_COD) >=6 " + LF
	cQuery += " ORDER BY A2_COD DESC " + LF	
	Memowrite("C:\Temp\A2COD.SQL",cQuery)
	//cQuery := ChangeQuery( cQuery )
	
	If Select("XXA2") > 0
		DbSelectArea("XXA2")
		DbCloseArea()	
	EndIf	
	TCQUERY cQuery NEW ALIAS "XXA2" 	
	XXA2->(DbGoTop())	
	While !XXA2->(EOF())
	
		cA2Cod := XXA2->A2_COD
		   
	   DbSelectArea("XXA2")
	   XXA2->(DbSkip())
	Enddo

	cContA2 := '211101' + Alltrim(cA2Cod)
	//msgbox("cConA2: " + cContA2)
	nA2Cod  := Val(cContA2) + 1
	cContA2 := Alltrim(Str( nA2Cod ))
	//msgbox("cConA2 final: " + cContA2)
	
	DbselectArea("CT1")
	CT1->(Dbsetorder(1))
	If CT1->(Dbseek(xFilial("CT1") + cContA2 ))
		
		While CT1->( DbSeek( xFilial( "CT1" ) + cContA2 ) )	   		
	   		cConta   := Alltrim(Str( Val(cContA2) + 1) )   //incrementa até não encontrar correspondente no CT1
	   		cContA2  := cConta	 
	 	Enddo	
	Endif	
	DbselectArea("XXA2")
	DbCloseArea("XXA2")

	Return(cContA2) 

Else
	DbselectArea("SA2")
	Return(SA2->A2_CONTA)
Endif
