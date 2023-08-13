#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"


User Function LIBPED()

Local aIndex := {}

Local aCores := {{"Z40_STATUS == 'B'", "BR_VERMELHO" },;
                 {"Z40_STATUS == 'L'", "BR_AMARELO"   },;
                 {"Z40_STATUS == 'J'", "BR_VERDE"   } }
                 
aRotina := {{"Pesquisar" , "AxPesqui"       , 0, 1},;
            {"Liberar"   , "U_LIBERA"       , 0, 6},;
            {"Legenda"   , "U_LegPed"       , 0, 6}}
            
            
cCadastro := OemToAnsi("Liberação de Pedido ")

DbSelectArea("Z40")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "Z40",,,,,,aCores )

Return



*************

User Function LIBERA()

*************

RecLock("Z40",.F.)
Z40->Z40_STATUS:='L'
Z40->Z40_DTLIBE:= DDATABASE
Z40->(MsUnLock())

Return 

***********************
User Function LegPed()
***********************

Local aLegenda := {{"BR_VERMELHO" ,"Bloqueado"   },;
   	   			   {"BR_AMARELO"    ,"Liberando..."},; 
   	   			   {"BR_VERDE"     ,"Liberado"   } }


BrwLegenda("Pedidos","Legenda",aLegenda)		   		

Return .T.
