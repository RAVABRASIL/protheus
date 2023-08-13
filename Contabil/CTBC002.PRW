#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'



*************

User Function CTBC002()

*************

Local aIndex := {}
Local aCores := {}

//DbSelectArea("ZBA" )
//DbSetOrder(1)
DbSelectArea("ZBB" )
DbSetOrder(1)

aRotina := {{"Pesquisar"   , "AxPesqui"        	, 0, 1},;
            {"Visualizar"  , "AxVisual"   		, 0, 2},;
            {"Incluir"     , "AxInclui" 		, 0, 3},;
            {"Alterar"     , "AxAltera"		   	, 0, 4},;    
            {"Exclui"      , "AxExclui"        	, 0, 5},; 
            {"Copia "      , "U_fCopyZBC"      	, 0, 6}} 


cCadastro := OemToAnsi("Cadastro de Custo por Linha de Produto" )

DbSelectArea("ZBC" )
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "ZBC",,,,,,aCores)

Return        


User Function fCopyZBC()

Local nReg	:= ZBC->(Recno())

M->ZBC_SETOR 	:= ZBC->ZBC_SETOR 
M->ZBC_DATA 	:= ZBC->ZBC_DATA 
M->ZBC_UF 		:= ZBC->ZBC_UF 
M->ZBC_CUSTO 	:= ZBC->ZBC_CUSTO 

AxInclui( "ZBC", nReg, 1,,"",,,,,,,,.T.)

Return