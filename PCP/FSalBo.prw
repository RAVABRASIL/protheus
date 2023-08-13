#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'


*************

User Function FSalBo()

*************

if !U_senha2( "28", 5 )[ 1 ] 
	   
   Return
   
endif

 aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
                { "Visualizar"   ,"AxVisual" , 0, 2},;
                { "Alterar"      ,"AxAltera" , 0, 4} }


cCadastro := OemToAnsi("Manutenção de Saldo de Bobina")

DbSelectArea("ZB9")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "ZB9",,,,,,)


Return
