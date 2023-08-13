#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch" 
#INCLUDE "COLORS.CH"

/*-------------------------------------------------------------------------------------*/
//Programa: FINC004.prw
//Autoria : Flávia Rocha
//Data    : 18/02/11
//Objetivo: Mostrar browse do CONTAS A RECEBER e possibilitar protestar títulos específicos
//          pelo usuário
//Flag protesto: novo campo E1_PROTEST 
/*-------------------------------------------------------------------------------------*/
                                              
*************************
User Function FINC004()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local cFiltraSE1    := ""
Local aIndexSE1		:= {}
Local cNomeUser     := ""
Local aUsua			:= {}
Local cUsua			:= ""
Local aCampos		:= {}
Local LF      	:= CHR(13)+CHR(10)
Local cCodUser	:= "" 

Local aCores		:= {	{ 'E1_PROTEST = "S" ', 'BR_VERMELHO'  },;	// Título protestado
							{ 'Empty(E1_PROTEST)'  , 'BR_VERDE' } }     // Título s/ protesto
						

Private cCadastro	:= "Contas a Receber x Protesto"
Private bFiltraBrw	:= {|| Nil}	
							

Private aRotina		:= {	{"Pesquisar"    ,	"AxPesqui"		,0,1},;	    // Pesquisar
							{"Visualizar"   ,	"FA280Visua"  	,0,2},;  	// Visualizar
							{"Protestar"     ,	"U_FINProt()"	,0,4},;	    // Protestar título
							{"Ret.Protesto"     ,"U_FINProt2()"	,0,4},;	    // Des-Protestar título
								{"Legenda"   ,	"U_FINLeg()"	,0,5}}	    // Legenda							
						



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro, utilizando a funcao FilBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1)


mBrowse( 6, 1,22,75, "SE1",,,,,,aCores)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a condicao de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1)
dbClearFilter()
	
Return(Nil)




******************************************************************************************************
User Function FINProt()
******************************************************************************************************

Local cProtesta := ""

If MsgYesNo("Deseja marcar o Título Selecionado como PROTESTADO ?")

	cProtesta := "S"
	RecLock("SE1",.F.)
	SE1->E1_PROTEST := cProtesta			
	SE1->(MsUnLock())
	
Endif


Return(Nil)   

******************************************************************************************************
User Function FINProt2()
******************************************************************************************************

Local cProtesta := ""

If MsgYesNo("Deseja RETIRAR o Protesto do Título ?")

	cProtesta := ""
	RecLock("SE1",.F.)
	SE1->E1_PROTEST := cProtesta			
	SE1->(MsUnLock())
	
Endif


Return(Nil)   


******************************************************************************************************
User Function FINLeg()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"Título Protestado"} ,;
									{"BR_VERDE" ,	"Sem Protesto"}	 } )

Return .T.

