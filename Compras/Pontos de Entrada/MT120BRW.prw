#INCLUDE "Rwmake.ch" 

/////////////////////////////////////////////////////////////////
//Programa: MT120BRW
//Autoria : Flávia Rocha
//Objetivo: Adicionar programa de Impressão do Pedido de Compra
//          no aRotina do Pedido de Compra
//Data    : 20/03/2012
////////////////////////////////////////////////////////////////

***************************
User Function MT120BRW()
***************************

//Define Array contendo as Rotinas a executar do programa     
// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                             
// 2. Nome da Rotina associada                                 
// 3. Usado pela rotina                                        
// 4. Tipo de Transa‡„o a ser efetuada                         
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                           
//    5 - Remove o registro corrente do Banco de Dados         
//    6 - Altera determinados campos sem incluir novos Regs    

 AAdd( aRotina, { 'Impr.PC', 'U_COMR002("SC7", SC7->(recno()), 1)', 0, 1 } )
 AAdd( aRotina, { 'Detalhe PC',"U_fDetPC(SC7->C7_NUM, iif(SC7->C7_TIPO=1,'PC','AE'))" , 0, 2 } )
 AAdd( aRotina, { 'PC s/ NF Saída', 'Processa({ || U_COMR019()})', 0, 1 } )


Return 