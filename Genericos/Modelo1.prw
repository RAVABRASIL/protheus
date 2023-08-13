#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
*************
User Function Modelo1(cTela,cAlias,nOrdem)
*************    
 
Local aIndex := {}
aRotina :={;
			{"Pesquisar" ,"AxPesqui" ,0 , 1},;
			{"Visualizar","AxVisual" ,0 , 2},;
			{"Incluir"   ,"AXInclui" ,0 , 3},;
			{"Alterar"   ,"AXAltera" ,0 , 4},;
			{"Excluir"   ,"AXDeleta" ,0 , 5};
          }  
//parametro |  se parametro nao foi enviado ou tipo nao confere | atribui o valor | reatribui mesmo valor

cTela       := iif(cTela  ==nil .or. valtype(cTela )!='C'        ,""              , alltrim(cTela )      )
cAlias      := iif(cAlias ==nil .or. valtype(cAlias)!='C'        ,""              , alltrim(cAlias)      ) 
nOrdem      := iif(nOrdem ==nil .or. valtype(nOrdem)!='N'        ,1               , nOrdem               )


if empty(cAlias)
 return
endif

 /*
if !empty(cPerg)
 if !Pergunte(cPerg,.F.)        
	return
 endif  
endif   
  */
if empty(cTela)
cTela:="Cadastro na TABELA "+RetSqlName( cAlias )
endif


cAlias:=upper(cAlias)
cCadastro := OemToAnsi(cTela)
DbSelectArea(cAlias )
DbSetOrder(nOrdem)
mBrowse( 06, 01, 22, 75,cAlias,,,,,,)
Return