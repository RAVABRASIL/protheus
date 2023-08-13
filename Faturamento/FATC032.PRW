#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fCargaZBB ³ Autor :Gustavo Costa       ³ Data :14/02/2017   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Função para da a carga inicial na tabela de desconto padrao³±±
±±³ 			 de clientes x produto.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FATC032()

	Processa({|| U_fCargaZBB()})

Return

User Function fCargaZBB()

Local cQuery := ""

cQuery += "SELECT RTRIM(C5_CLIENTE) CODIGO,RTRIM(C5_LOJACLI) LOJA, RTRIM(C6_PRODUTO) PRODUTO,C6_PDESC PERC_DESCONTO, C6_DATFAT "
cQuery += "FROM SC6020 SC6 "
cQuery += "INNER JOIN SC5020 SC5 "
cQuery += "ON C5_FILIAL=C6_FILIAL "
cQuery += "AND C5_NUM=C6_NUM "
cQuery += "WHERE LEFT(C6_DATFAT,6)>'201610' "
cQuery += "AND SC6.D_E_L_E_T_='' "
cQuery += "AND SC6.D_E_L_E_T_='' "
cQuery += "AND C6_PDESC > 0 " 
cQuery += "AND RTRIM(C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "  
cQuery += "ORDER BY C6_DATFAT DESC "


if Select("XTMP") > 0
	DbSelectArea("XTMP")
	DbCloseArea()
endif
TCQUERY cQuery NEW ALIAS "XTMP"
TCSetField( "XTMP", "C6_DATFAT",  "D", 8, 0 )

while !XTMP->(EOF()) 
   
	DbSelectArea("ZBB")
	dbSetOrder(1)
	
	If ZBB->(dbSeek(xFilial("ZBB") + XTMP->CODIGO + XTMP->LOJA + XTMP->PRODUTO))
	
		If XTMP->C6_DATFAT > ZBB->ZBB_DATA
			
			reclock("ZBB",.F.)
			
			ZBB->ZBB_PERC := XTMP->PERC_DESCONTO
			
			ZBB->(MsUnLock())
		
		EndIf
	
	Else

		reclock("ZBB",.T.)
		
		ZBB->ZBB_CLIENT := XTMP->CODIGO
		ZBB->ZBB_LOJA 	:= XTMP->LOJA
		ZBB->ZBB_DATA 	:= XTMP->C6_DATFAT
		ZBB->ZBB_PROD 	:= XTMP->PRODUTO
		ZBB->ZBB_PERC 	:= XTMP->PERC_DESCONTO
		
		ZBB->(MsUnLock())
	
	EndIf
   
	XTMP->(DbSkip())
end

DbSelectArea("XTMP")
XTMP->(DbCloseArea())
   
   
Return


