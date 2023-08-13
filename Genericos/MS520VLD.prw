
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"

//Valida se permite o cancelamento da nota fiscal
****************************
User Function MS520VLD()  
****************************

// ALTERADO POR ANTONIO EM 26/05/2011

if ! alltrim(__CUSERID) $ SUPERGETMV("MV_EXCNF",,'000192')// edna 
   Alert("Usuário Sem Permissão para Cancelar Notas.")
   return .F.
endif

/*
if !alltrim(Upper( Substr( cUsuario, 7, 15 ) ) ) $ "MARCELO/EURIVAN/ALCINEIDE/REGINA"  
   Alert("Somente Marcelo, Regina ou Alcineide, poderão cancelar Notas.")
   return .F.
endif
*/                	



if !EMPTY(SF2->F2_DTEXP)
   Alert("Nota Fiscal "+alltrim(SF2->F2_DOC)+" - "+alltrim(SF2->F2_SERIE)+" nao podera ser cancelada,pois foi expedida no dia "+ DTOC(SF2->F2_DTEXP) )
   Return U_senha2( "18", 4 )[ 1 ]
Endif


Return .T.


/*
****************************
User Function MS520VLD()  
****************************

//Alterado em 22/06/10, solicitado por Regina e Alexandre
//Local lOk :=alltrim(Upper( Substr( cUsuario, 7, 15 ) ) ) $ "MARCELO/EURIVAN/ALEXANDRE/ALCINEIDE/REGINA"   //$ "NEIDE MARCE EURIV REGIN"

if !lOK
   Alert("Somente Marcelo, Regina ou Alcineide, poderão cancelar Notas.")
endif


Return lOk

*/      
                     




