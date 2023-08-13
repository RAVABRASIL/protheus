#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
//*****************************************************************************************
// Descricao -> Ponto de entrada executado para efetuar uma analise se os itens do  
//              pedido de venda podem ser gravados  
// Usado no cadastramento do pedido de vendas / Autoria: Flávia Rocha / Data 24/01/2014 
//*****************************************************************************************


*************************
User Function  M410LIOK()
*************************

Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRODUTO'})
Local nPosCFOP   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_CF'})
Local lValido := .T.
Local LF		 := CHR(13) + CHR(10) 
Local lOK		 := .F. 

If AllTrim(Upper(FunName())) != "FATC019"    //se for pedidos internet, não faz esta validação
	If !(aCols[n,Len(aHeader)+1])   //se não estiver deletada a linha
		If Empty( aCols[n][nPosCFOP] ) 
				Aviso(	"Pedido de Venda",;
					"O Campo CFOP Está Vazio, Por Favor, Tecle <ENTER> no Campo TES Para Atualizar o CFOP.",;
					{"&Ok"},,;
					"CFOP") 
				lValido := .F.
		
		Endif  //se bloqueia
	EndiF
Endif
	
///valida o campo NCM
///retirado, pois será obrigatório na entrada da NF
//FR - 06/08/12
/*
If !(aCols[n,Len(aHeader)+1])    //se a linha não estiver deletada
	If Empty( aCols[n][nPosNCM] )
		lValido := .F.
		Aviso(	"Pedido de Compra",;
				"Falta informar a NCM para o item "+BuscAcols("C7_ITEM")+".",;
				{"&Ok"},,;
				"Classificação Fiscal")
			
	Endif
	
Endif
*/


	


Return(lValido) 