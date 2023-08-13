#INCLUDE "Protheus.ch"

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//PROGRAMA: F330AE5I - PONTO DE ENTRADA APÓS GRAVAÇÃO DA COMPENSAÇÃO CR
//AUTORIA : FLÁVIA ROCHA
//DATA    : 29.11.2013
//OBJETIVO: ATUALIZAR A TABELA Z10 - PROCESSOS DEVOLUÇÃO, QUANDO DA COMPENSAÇÃO CR DE TÍTULOS ENVOLVIDOS
//          EM PROCESSOS DE DEVOLUÇÃO                                                                   
//////////////////////////////////////////////////////////////////////////////////////////////////////////

************************
User Function F330AE5I()
************************

Local cMsg := ""
Local eEmail := ""
Local subj   := ""
Local LF     := CHR(13) + CHR(10)
nCm:= 30

//MsgAlert("Compensação CR - Executa Ponto de Entrada!")
If SE1->E1_NFDEV = 'S'  //se for título associado a NF Devolução irá executar gravações adicionais na tabela Z10
	DbselectArea("Z10")
	Z10->(DBSETORDER(4)) //Z10_NFEDEV + Z10_SERDEV ->ORDEM DE NÚMERO DA NOTA DE DEVOLUÇÃO (NCC)
	If Z10->(Dbseek(xFilial("Z10") + SE1->E1_NUM + SE1->E1_PREFIXO ))  //
		RecLock("Z10", .F.)
		//Z10->Z10_CODIGO := _SUDX->UD_CODIGO
		//Z10->Z10_ITEM   := _SUDX->UD_ITEM
		//Z10->Z10_NF     := cNOTACLI
		//Z10->Z10_SERINF := cSERINF
		//Z10->Z10_EMINF  := SF2->F2_EMISSAO   
		//Z10->Z10_DTDEVO := SF1->F1_DTDIGIT  //DAQUI PRA CIMA JÁ ESTÃO GRAVADOS
		Z10->Z10_STATUS := '04'       //04->BAIXA NFD pelo Financeiro
		Z10->Z10_DTSTAT := DATE()
		Z10->Z10_HRSTAT := TIME()
		Z10->Z10_USER   := __CUSERID
		Z10->Z10_NOMUSR:= SUBSTR(cUSUARIO,7,15)
		//Z10->Z10_NFEDEV:= SF1->F1_DOC    //número da nf devolução
		//Z10->Z10_SERDEV:= SF1->F1_SERIE  //série da nf devolução
		Z10->(MsUnlock())
							
		cMsg   := "Compensação CR - NF / Serie: " + SE1->E1_NUM + '/' + SE1->E1_PREFIXO + LF
		cMsg   += "Data: " + Dtoc(Date()) + LF
		cMsg   += "Hora: " + Time() + LF
		cMsg   += "Usuario: " + Substr(cUSUARIO,7,15) + LF
		eEmail := "flavia.rocha@ravaembalagens.com.br"
		subj   := "Compensação CR: "+ SE1->E1_NUM + '/' + SE1->E1_PREFIXO
		U_SendFatr11(eEmail, "", subj, cMsg, "" ) 
	Endif //seek no Z10                                          
Endif

Return