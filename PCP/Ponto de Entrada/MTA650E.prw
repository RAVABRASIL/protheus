#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 
#include "Topconn.ch"

/*
LOCALIZAÇÃO: Function A650Deleta() - Responsável pela Deleção de O.PsEM QUE PONTO : É chamado antes de excluir a Op.
*/

*************

User Function MTA650E() 

*************
Local aArea		:= GetArea()
local cQry:=''
local cOP:=ALLTRIM(SC2->C2_NUM)+'01001'
local cTemp:=''

                                  // filial caixa              filial saco 
If  SM0->M0_CODIGO == "02" .and. (SM0->M0_CODFIL == "03"  .OR. SM0->M0_CODFIL == "01") 

	cQry:="SELECT CP_NUM FROM "+retSqlName("SCP")+" SCP "
	cQry+="WHERE CP_OP='"+cOP+" ' AND SCP.D_E_L_E_T_='' "
	cQry+="AND CP_FILIAL='"+xFilial('SCP')+"' GROUP BY CP_NUM "
	
	If Select("_TMSCP") > 0
        DbSelectArea("_TMSCP")
        _TMSCP->(DbCloseArea())
    EndIf
	
	TCQUERY cQry NEW ALIAS "_TMSCP"

    If ! _TMSCP->(EOF())
    
	     while ! _TMSCP->(EOF())
	        cTemp:=cTemp+_TMSCP->CP_NUM+", " 
	        _TMSCP->(DbSkip())
	     enddo
	      
	      Alert( "Essa OP tem Requisicao "+cTemp+" associada, por isso nao pode ser Excluida "  )
          Return .F.	    
	    
    Endif
_TMSCP->(DbCloseArea())
Endif
restarea(aArea)


Return .T.