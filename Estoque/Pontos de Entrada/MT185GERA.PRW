#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
PARAMIXB[01] - Marca de selecao
PARAMIXB[02] - Numero da SA
PARAMIXB[03] - Item da SA
PARAMIXB[04] - Produto
PARAMIXB[05] - Descricao do Produto
PARAMIXB[06] - Armazem
PARAMIXB[07] - UM
PARAMIXB[08] - Qtd. a Requisitar (Formato Caracter)
PARAMIXB[09] - Qtd. a Requisitar
PARAMIXB[10] - Centro de Custo
PARAMIXB[11] - 2a.UM
PARAMIXB[12] - Qtd. 2a.UM
PARAMIXB[13] - Ordem de Producao
PARAMIXB[14] - Conta Contabil
PARAMIXB[15] - Item Contabil
PARAMIXB[16] - Classe Valor
PARAMIXB[17] - Projeto
PARAMIXB[18] - Nr. da OS
PARAMIXB[19] - Tarefa
Descrição:
LOCALIZAÇÃO   : Function A185GeraAut( ) função responsável pela montagem dos dados para baixa da pre-requisição.

EM QUE PONTO : O ponto se encontra antes da validação da quantidade da baixa para verificar se existe estoque disponivel para realização da baixa da pre-requisição.
 
  */

User Function MT185GERA()

Local aParam := PARAMIXB 
Local aRet  := {} 
//Local aAreaSCP	:= SCP->(GetArea())   

SB2->(Dbsetorder(1))
If SB2->(Dbseek(xFilial("SB2")+PARAMIXB[04]+PARAMIXB[06]))   
	
	RecLock("SB2", .F.)
	 	SB2->B2_QEMPN  := 0
	 	SB2->B2_QEMP2  := 0
	 	SB2->B2_QEMPN2 := 0
	 	SB2->B2_QEMP   := 0
	SB2->(MsUnlock())

Endif

	Aadd( aReT,PARAMIXB[01] )
	Aadd( aReT,PARAMIXB[02] )
	Aadd( aReT,PARAMIXB[03] )
	Aadd( aReT,PARAMIXB[04] )    
	Aadd( aReT,PARAMIXB[05] )
	Aadd( aReT,PARAMIXB[06] )
	Aadd( aReT,PARAMIXB[07] )
	Aadd( aReT,PARAMIXB[08] )
	Aadd( aReT,PARAMIXB[09] )
	Aadd( aReT,PARAMIXB[10] )
	Aadd( aReT,PARAMIXB[11] )
	Aadd( aReT,PARAMIXB[12] )    
	Aadd( aReT,PARAMIXB[13] )
	Aadd( aReT,PARAMIXB[14] )
	Aadd( aReT,PARAMIXB[15] )
	Aadd( aReT,PARAMIXB[16] )
	Aadd( aReT,PARAMIXB[17] )
	Aadd( aReT,PARAMIXB[18] )
	Aadd( aReT,PARAMIXB[19] )

//RestArea(aAreaSCP)

Return(aRet)