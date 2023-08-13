/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ COMP01 บ Autor ณ Gustavo Costa           บ Data ณ 29/10/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Leitura e Importacao Arquivo XML para gera็ใo de Pre-Nota  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//-- Ponto de Entrada para incluir botใo na Pr้-Nota de Entrada
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"


User Function COMP01()
	
Local aTipo			:={'N','B','D'}
Local cFile 			:= Space(10)
Local aFiles			:= {}
Local aSizes			:= {}
Local aCabec 			:= {}
Local aItens 			:= {}
Local aLinha			:= {}
Local aPC				:= {}
Local aArea			:= GetArea()
Local aAreaSM0		:= GetArea("SM0")
Local cEmpFil			:= ""
Local cChvNfe			:= ""
Local cXML				:= ""
Local cCodNFE			:= ""
Local cCgcO			:= ""
Local cCgcD			:= ""
Local cLog				:= ""
Local cEOL 			:= chr(13) + chr(10)
Local _lCopy			:= .F.
Local lMudaEmp		:= .F.
Local lMudouEmp		:= .F.
Local lAchouFor		:= .F.
Local lAchouProd		
Local lAchouPC		
Local lJob				:= .F.
Private CPERG   		:="NOTAXML"
Private Caminho 		:= "d:\XmlNfe\"
Private cDiretOrig	:= ""
Private cDiretDest	:= ""
//Private _cMarca   	:= GetMark()
Private aFields   	:= {}
Private cArq
Private aFields2  	:= {}
Private cArq2

SetPrvt("cDoc,cSerie,cCodFor,cLoja,cCond,dEmissao,cUF,nFrete,nDespesa,nValIPI,nValmerc,nValbru,cTipo,nDescon,cHora,cStatus,cTPCTE")
SetPrvt("cCod,cCodPro,cUm,cSegum,nFator,nQuant,nQtdFor,nVunit,nVunitf,nTotal,cTes,nValdes,nIpi,nVIpi,npIcm,cTEC,cPedido,cItemPc,cCC,cConta")
SetPrvt("cUMfor,cLocal,cGrupo,cItem,cDescri,cTP")

If Select( 'SX2' ) == 0

	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "COMP01" Tables "ZF1", "ZD1"
	sleep( 6000 )
	conOut( "Programa COMP01 na emp. 02 filial " + xFilial() + " - " + Dtoc( Date() ) + ' - ' + Time() )
	lJob	:= .T.
EndIf

//cDiretOrig	:= 'G:\Protheus10\Protheus_Data\XML\RECEBIDO\'
cDiretOrig	:= '\XML\RECEBIDO\'
 //GetNewPar("MV_XDIRXML","G:\Protheus10\Protheus_Data\XML\RECEBIDO\")
cDiretDest	:= '\XML\IMPORTADO\'
 //GetNewPar("MV_XBKPXML","\XML\IMPORTADO\")

ADir(cDiretOrig + "*.XML", aFiles, aSizes)

conOut( "Foram encontrados - " + Str(Len(aFiles)) + " arquivos." )
If Len(aFiles) > 0

	For _x := 1 to Len(aFiles)

		conOut( "Encontrado o arquivo - " + aFiles[_x] )
		cFile := cDiretOrig + aFiles[_x]

		Private nHdl    := fOpen(cFile,0)

		aCamposPE:={}

		If nHdl == -1
			Loop
		Endif

		nTamFile 		:= fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		cBuffer  		:= Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
		nBtLidos 		:= fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
		fClose(nHdl)

		cXML			:= cBuffer
		cAviso 		:= ""
		cErro  		:= ""
		oNfe 			:= XmlParser(cBuffer,"_",@cAviso,@cErro)


		Do Case
			//----------------------------------------------------------
			//Nota fiscal de Eletronica
			//----------------------------------------------------------
			Case Type("oNFe:_NfeProc") <> "U"
				
				Private cSpecie		:= "SPED"
				Private oNF 			:= oNFe:_NFeProc:_NFe
				Private oEmitente  	:= oNF:_InfNfe:_Emit
				Private oIdent     	:= oNF:_InfNfe:_IDE
				Private oDestino   	:= oNF:_InfNfe:_Dest
				Private oTotal     	:= oNF:_InfNfe:_Total
				Private oTransp    	:= oNF:_InfNfe:_Transp
				Private oDet       	:= oNF:_InfNfe:_Det 
				If Type("oNF:_InfNfe:_ICMS")<> "U"
					Private oICM 		:= oNF:_InfNfe:_ICMS
				Else
					Private oICM		:= nil
				Endif
				Private oFatura    	:= IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
				
				cChvNfe				:= oNFe:_NFeProc:_ProtNfe:_InfProt:_ChNfe:TEXT
				cCodNFE				:= oNFe:_NFeProc:_ProtNfe:_InfProt:_NProt:TEXT
				cCgcO 					:= oEmitente:_CNPJ:TEXT
				cCgcD 					:= AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:TEXT,oDestino:_CPF:TEXT))
				cDoc					:= StrZero(Val(OIdent:_nNF:TEXT),Tamsx3("F1_DOC")[1])
				cSerie					:= AllTrim(OIdent:_serie:TEXT)
				dEmissao				:= StoD(SubStr(OIdent:_dEmi:TEXT,1,4) + SubStr(OIdent:_dEmi:TEXT,6,2) + SubStr(OIdent:_dEmi:TEXT,9,2))
				cUF						:= oEmitente:_EnderEmit:_UF:TEXT
				nFrete					:= Val(oTotal:_IcmsTot:_vFrete:TEXT)
				nDespesa				:= Val(oTotal:_IcmsTot:_vOutro:TEXT)
				nValIPI				:= Val(oTotal:_IcmsTot:_vIPI:TEXT)
				nValmerc				:= Val(oTotal:_IcmsTot:_vProd:TEXT)
				nValbru				:= Val(oTotal:_IcmsTot:_vProd:TEXT) + Val(oTotal:_IcmsTot:_vIPI:TEXT)
				cTipo					:= "N"
				nDescon				:= Val(oTotal:_IcmsTot:_vDesc:TEXT)
				cHora					:= ""
				cStatus				:= ""
				cTPCTE					:= ""
					
			//----------------------------------------------------------
			//Nota fiscal de Conhecimento de Frete Eletronico
			//----------------------------------------------------------
			Case Type("oNFe:_CteProc") <> "U"
	
				Private cSpecie		:= "CTE"
				Private oNF 			:= oNFe:_CteProc:_Cte
				Private oEmitente  	:= oNFe:_CteProc:_Cte:_InfCte:_Emit
				Private oIdent     	:= oNFe:_CteProc:_Cte:_InfCte:_IDE
				Private oDestino   	:= oNFe:_CteProc:_Cte:_InfCte:_Dest
				Private oTotal     	:= oNFe:_CteProc:_Cte:_InfCte:_VPrest
				Private oRemetente  	:= oNFe:_CteProc:_Cte:_InfCte:_REM
				//Private oDet       	:= oNF:_CteProc:_Det
				If Type("oNFe:_CteProc:_Cte:_InfCte:_IMP")<> "U"
					Private oICM       := oNFe:_CteProc:_Cte:_InfCte:_IMP:_ICMS
				Else
					Private oICM		:= nil
				Endif
	
				cChvNfe				:= oNFe:_CteProc:_ProtCte:_InfProt:_ChCte:TEXT
				cCodNFE				:= oNFe:_CteProc:_ProtCte:_InfProt:_NProt:TEXT
				cCgcO 					:= oEmitente:_CNPJ:TEXT
				cCgcD 					:= oRemetente:_CNPJ:TEXT
				cDoc					:= StrZero(Val(OIdent:_nCT:TEXT),Tamsx3("F1_DOC")[1])
				cSerie					:= AllTrim(OIdent:_serie:TEXT)
				dEmissao				:= StoD(SubStr(OIdent:_dHEmi:TEXT,1,4) + SubStr(OIdent:_dHEmi:TEXT,6,2) + SubStr(OIdent:_dHEmi:TEXT,9,2))
				cUF						:= OIdent:_UFenv:TEXT
				nFrete					:= 0
				nDespesa				:= 0
				nValIPI				:= 0
				nValmerc				:= Val(OTotal:_VTPrest:TEXT)
				nValbru				:= Val(OTotal:_VTPrest:TEXT)
				cTipo					:= "N"
				nDescon				:= 0
				cHora					:= SubStr(OIdent:_dHEmi:TEXT,12,5)
				cStatus				:= ""
				
				/*
				0 - CT-e Normal;
				1 - CT-e de Complemento de
				Valores;
				2 - CT-e de Anula็ใo de Valores;
				3 - CT-e Substituto
				*/
				Do Case 
					Case oIdent:_tpCTe:TEXT == '0'
						cTPCTE			:= "N"	
					Case oIdent:_tpCTe:TEXT == '1'
						cTPCTE			:= "C"	
					Case oIdent:_tpCTe:TEXT == '2'
						cTPCTE			:= "A"	
					Case oIdent:_tpCTe:TEXT == '3'
						cTPCTE			:= "S"	
					Otherwise
						cTPCTE			:= ""	
				EndCase
				
	
		EndCase
		
		// Prepara ambiente para outra empresa....
		dbSelectArea("SM0")
		
		cEmpFil	:= SM0->M0_CODIGO + SM0->M0_CODFIL
		
		SM0->(dbGoTop())		
		
		While SM0->(!EOF())
			
			If SM0->M0_CGC == cCgcD .AND. SM0->M0_CODIGO <> '01'
			
				If SM0->M0_CODIGO + SM0->M0_CODFIL <> cEmpFil	
					lMudaEmp	:= .T.
					cEmpFil	:= SM0->M0_CODIGO + SM0->M0_CODFIL
				EndIf
				
				EXIT
			EndIf
			
			SM0->(dbSkip())
		EndDo
	
		If lMudaEmp
			
			If lMudouEmp
				RESET ENVIRONMENT
			EndIf
			
			RPCSetType( 3 )
			_cFil	:= SubStr(cEmpFil,3,2)
			PREPARE ENVIRONMENT EMPRESA SubStr(cEmpFil,1,2) FILIAL _cFil FUNNAME "COMP01" Tables "ZF1", "ZD1"
			//sleep( 5000 )
			conOut( "Programa COMP01 na emp. " + SubStr(cEmpFil,1,2) + " filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
			lMudouEmp	:= .T.
		EndIf
		//
		
		dbSelectArea("SA2")
		SA2->(dbSetOrder(3))
		
		If dbSeek(xFilial("SA2") + cCgcO)
			lAchouFor	:= .T.
			cCodFor	:= SA2->A2_COD
			cLoja		:= SA2->A2_LOJA
		Else	
			cCodFor	:= ""
			cLoja		:= ""
		EndIf
		
		cCond := "006" // 30 dias (utilizado para frete)
	
		aCabec := {}
		aadd(aCabec,{"ZF1_FILIAL"   ,xFilial("ZF1"),Nil,Nil})
		aadd(aCabec,{"ZF1_DOC"    	,cDoc			,Nil,Nil})
		aadd(aCabec,{"ZF1_SERIE" 	,cSerie		,Nil,Nil})
		aadd(aCabec,{"ZF1_FORNEC" 	,cCodFor		,Nil,Nil})
		aadd(aCabec,{"ZF1_LOJA" 		,cLoja			,Nil,Nil})
		aadd(aCabec,{"ZF1_EMISSA" 	,dEmissao		,Nil,Nil})
		aadd(aCabec,{"ZF1_EST" 		,cUF			,Nil,Nil})
		aadd(aCabec,{"ZF1_FRETE" 	,nFrete 		,Nil,Nil})
		aadd(aCabec,{"ZF1_DESPES" 	,nDespesa		,Nil,Nil})
		aadd(aCabec,{"ZF1_VALIPI" 	,nValIPI		,Nil,Nil})
		aadd(aCabec,{"ZF1_VALMER" 	,nValmerc		,Nil,Nil})
		aadd(aCabec,{"ZF1_VALBRU" 	,nValbru		,Nil,Nil})
		aadd(aCabec,{"ZF1_TIPO" 		,cTipo			,Nil,Nil})
		aadd(aCabec,{"ZF1_DESCON" 	,nDescon		,Nil,Nil})
		aadd(aCabec,{"ZF1_DTDIGI" 	,dDataBase		,Nil,Nil})
		aadd(aCabec,{"ZF1_HORA" 		,cHora			,Nil,Nil})
		aadd(aCabec,{"ZF1_CODNFE" 	,cCodNFE		,Nil,Nil})
		aadd(aCabec,{"ZF1_CHVNFE" 	,cChvNfe		,Nil,Nil})
		aadd(aCabec,{"ZF1_XML" 		,cXML			,Nil,Nil})
		aadd(aCabec,{"ZF1_TPCTE" 	,cTPCTE		,Nil,Nil})
		aadd(aCabec,{"ZF1_ESPECI" 	,cSpecie		,Nil,Nil})
		
		If cSpecie == "CTE"
			aadd(aCabec,{"ZF1_COND" 		,cCond			,Nil,Nil})
		EndIf
		
		aItens := {}
		
		cProds 	:= ''
		aPedIte	:= {}
		
		//----------------------------------------------------------
		// ITEM - Nota fiscal de Conhecimento de Frete Eletronico
		//----------------------------------------------------------
		If cSpecie == 'CTE'
		
			dbSelectArea("SB1")
			dbsetorder(1)
			SB1->(dbSeek(xFilial("SB1")+"FR0001"))
			
			lAchouProd	:= .T.
			
			cCod 		:= SB1->B1_COD
			cUm			:= SB1->B1_UM
			cSegum 	:= SB1->B1_SEGUM
			cLocal		:= SB1->B1_LOCPAD
			cGrupo		:= SB1->B1_GRUPO
			cTP			:= SB1->B1_TIPO
			cCodPro	:= OIdent:_cCT:TEXT
			cDescri	:= Upper(OIdent:_NatOP:TEXT)
			nFator		:= 1
			nQuant		:= 1 
			nQtdFor	:= 1
			nVunit		:= Val(oTotal:_Vrec:TEXT)
			nVunitf	:= Val(oTotal:_Vrec:TEXT)
			nTotal		:= Val(oTotal:_Vrec:TEXT)
			nValdes	:= 0
			nIpi		:= 0
			nVIpi		:= 0
			npIcm		:= Val(oIcm:_Icms00:_PIcms:TEXT)
			cTEC		:= ""
			cUMfor		:= ""
			cItem		:= "001"
			
			If lAchouProd
				//aPC[1] = Numero, aPC[2] = Item, aPC[3] = Produto, aPC[4] = TES, aPC[5] = Cond. PG, aPC[6] = CC, aPC[7] = Conta Ctb 
				aPC		:= fFindPC(cCod, cCodFor, cLoja, nQuant)
				
				cPedido	:= aPC[1]
				cItemPc	:= aPC[2]
				cTes		:= aPC[4]
				If !Empty(cPedido)
					
					aadd(aCabec,{"ZF1_COND" 		,aPC[5]		,Nil,Nil})
					lAchouPC	:= IIF(lAchouPC	== .F.,.F.,.T.)
				
				Else
				
					lAchouPC	:= .F.
				
				EndIf
				cCC			:= aPC[6]
				cConta		:= aPC[7]
			Else
				cPedido	:= ""
				cItemPc	:= ""
				cTes		:= ""
				lAchouPC	:= .F.
				cCC			:= ""
				cConta		:= ""
			EndIf

		//----------------------------------------------------------
		// ITEM - Nota fiscal de Eletronica
		//----------------------------------------------------------
		Else // cSpecie == CTE

			//Se o tipo for Objeto, s๓ tem um produto
			oDet := IIf(ValType(oDet)=="O",{oDet},oDet)

			For nX := 1 To Len(oDet)
		
				cProduto	:= AllTrim(oDet[nX]:_Prod:_cProd:TEXT)
	
				dbSelectArea("SA5")
				dbsetorder(14)
				IF lAchouFor .AND. SA5->(dbSeek(xFilial("SA5") + cCodFor + cLoja + cProduto ))
	
					nFator		:= SA5->A5_XFATOR

					dbSelectArea("SB1")
					dbsetorder(1)
					SB1->(dbSeek(xFilial("SB1") + SA5->A5_PRODUTO))
	
					cCod 		:= SB1->B1_COD
					cUm			:= SB1->B1_UM
					cSegum 	:= SB1->B1_SEGUM
					cLocal		:= SB1->B1_LOCPAD
					cGrupo		:= SB1->B1_GRUPO
					cDescri	:= SB1->B1_DESC
					cTP			:= SB1->B1_TIPO
					lAchouProd	:= IIF(lAchouProd	== .F.,.F.,.T.)
				Else
					cCod 		:= ""
					cUm			:= ""
					cSegum 	:= ""
					cLocal		:= ""
					cGrupo		:= ""
					cTP			:= ""
					nFator		:= 1			
					cDescri	:= Upper(oDet[nx]:_Prod:_XProd:TEXT)
					lAchouProd	:= .F.
				EndIf
				
				cCodPro	:= cProduto
				nQuant		:= Val(oDet[nX]:_Prod:_qTrib:TEXT) * nFator
				nQtdFor	:= Val(oDet[nX]:_Prod:_qTrib:TEXT)
				nVunit		:= Val(oDet[nX]:_Prod:_vProd:TEXT) / nQuant
				nVunitf	:= Val(oDet[nX]:_Prod:_vUnTrib:TEXT)
				nTotal		:= Val(oDet[nX]:_Prod:_vProd:TEXT)
				nValdes	:= 0
				nIpi		:= IIF(Type("oDet[nX]:_Imposto:_IPI:_IpiTrib:_pIpi:TEXT")=="U",0,Val(oDet[nX]:_Imposto:_IPI:_IpiTrib:_pIpi:TEXT))
				nvIpi		:= IIF(Type("oDet[nX]:_Imposto:_IPI:_IpiTrib:_vIpi:TEXT")=="U",0,Val(oDet[nX]:_Imposto:_IPI:_IpiTrib:_vIpi:TEXT))
				npIcm		:= 0
				cTEC		:= oDet[nX]:_Prod:_ncm:TEXT
				cUMfor		:= oDet[nX]:_Prod:_UTrib:TEXT
				cItem		:= StrZero(nX,3)
							
				If lAchouProd
					//aPC[1] = Numero, aPC[2] = Item, aPC[3] = Produto, aPC[4] = TES, aPC[5] = Cond. PG 
					aPC		:= fFindPC(cCod, cCodFor, cLoja, nQuant)
					cPedido	:= aPC[1]
					cItemPc	:= aPC[2]
					cTes		:= aPC[4]
					cCond		:= aPC[5]
					
					If !Empty(cPedido)
					
						aadd(aCabec,{"ZF1_COND" 		,cCond		,Nil,Nil})
						lAchouPC	:= IIF(lAchouPC	== .F.,.F.,.T.)
					
					Else
					
						lAchouPC	:= .F.
					
					EndIf
				Else
					cPedido	:= ""
					cItemPc	:= ""
					cTes		:= ""
				EndIf

				aLinha		:= {}
				aadd(aLinha,{"ZD1_FILIAL"	,xFilial("ZD1")	,Nil,Nil})
				aadd(aLinha,{"ZD1_COD"		,cCod				,Nil,Nil})
				aadd(aLinha,{"ZD1_CODPRO"	,cCodPro			,Nil,Nil})
				aadd(aLinha,{"ZD1_UM"		,cUm				,Nil,Nil})
				aadd(aLinha,{"ZD1_SEGUM"		,cSegum			,Nil,Nil})
				aadd(aLinha,{"ZD1_QUANT"		,nQuant			,Nil,Nil})
				aadd(aLinha,{"ZD1_FATOR"		,nFator			,Nil,Nil})
				aadd(aLinha,{"ZD1_QTDFOR"	,nQtdFor			,Nil,Nil})
				aadd(aLinha,{"ZD1_VUNIT"		,nVunit			,Nil,Nil})
				aadd(aLinha,{"ZD1_VUNITF"	,nVunitF			,Nil,Nil})
				aadd(aLinha,{"ZD1_TOTAL"		,nTotal			,Nil,Nil})
				aadd(aLinha,{"ZD1_LOCAL"		,cLocal			,Nil,Nil})
				aadd(aLinha,{"ZD1_TES"		,cTes				,Nil,Nil})
				aadd(aLinha,{"ZD1_VALDES"	,nValdes			,Nil,Nil})
				aadd(aLinha,{"ZD1_IPI"		,nIpi				,Nil,Nil})
				aadd(aLinha,{"ZD1_VIPI"		,nvIpi				,Nil,Nil})
				aadd(aLinha,{"ZD1_PICM"		,npIcm				,Nil,Nil})
				aadd(aLinha,{"ZD1_TEC"		,cTEC				,Nil,Nil})
				aadd(aLinha,{"ZD1_PEDIDO"	,cPedido			,Nil,Nil})
				aadd(aLinha,{"ZD1_ITEMPC"	,cItemPc			,Nil,Nil})
				aadd(aLinha,{"ZD1_DTDIGI"	,dDataBase			,Nil,Nil})
				aadd(aLinha,{"ZD1_UMFOR"		,cUMfor			,Nil,Nil})
				aadd(aLinha,{"ZD1_FORNEC"	,cCodFor			,Nil,Nil})
				aadd(aLinha,{"ZD1_GRUPO"		,cGrupo			,Nil,Nil})
				aadd(aLinha,{"ZD1_LOJA"		,cLoja				,Nil,Nil})
				aadd(aLinha,{"ZD1_DOC"		,cDoc				,Nil,Nil})
				aadd(aLinha,{"ZD1_TIPO"		,cTipo				,Nil,Nil})
				aadd(aLinha,{"ZD1_EMISSA"	,dEmissao			,Nil,Nil})
				aadd(aLinha,{"ZD1_ITEM"		,cItem				,Nil,Nil})
				aadd(aLinha,{"ZD1_SERIE"		,cSerie			,Nil,Nil})
				aadd(aLinha,{"ZD1_DESCRI"	,cDescri			,Nil,Nil})
				aadd(aLinha,{"ZD1_CC"		,cCC				,Nil,Nil})
				aadd(aLinha,{"ZD1_CONTA"		,cConta			,Nil,Nil})
				aadd(aLinha,{"ZD1_TP"		,cTP				,Nil,Nil})

				AAdd(aPedIte,aLinha)
		
			Next nX
				
		EndIf // cSpecie == CTE

		If cSpecie == 'CTE' //.OR. Type('oDet') == "O"

			aLinha		:= {}
			aadd(aLinha,{"ZD1_FILIAL"	,xFilial("ZD1")	,Nil,Nil})
			aadd(aLinha,{"ZD1_COD"		,cCod				,Nil,Nil})
			aadd(aLinha,{"ZD1_CODPRO"	,cCodPro			,Nil,Nil})
			aadd(aLinha,{"ZD1_UM"		,cUm				,Nil,Nil})
			aadd(aLinha,{"ZD1_SEGUM"		,cSegum			,Nil,Nil})
			aadd(aLinha,{"ZD1_QUANT"		,nQuant			,Nil,Nil})
			aadd(aLinha,{"ZD1_FATOR"		,nFator			,Nil,Nil})
			aadd(aLinha,{"ZD1_QTDFOR"	,nQtdFor			,Nil,Nil})
			aadd(aLinha,{"ZD1_VUNIT"		,nVunit			,Nil,Nil})
			aadd(aLinha,{"ZD1_VUNITF"	,nVunitF			,Nil,Nil})
			aadd(aLinha,{"ZD1_TOTAL"		,nTotal			,Nil,Nil})
			aadd(aLinha,{"ZD1_LOCAL"		,cLocal			,Nil,Nil})
			aadd(aLinha,{"ZD1_TES"		,cTes				,Nil,Nil})
			aadd(aLinha,{"ZD1_VALDES"	,nValdes			,Nil,Nil})
			aadd(aLinha,{"ZD1_IPI"		,nIpi				,Nil,Nil})
			aadd(aLinha,{"ZD1_VIPI"		,nvIpi				,Nil,Nil})
			aadd(aLinha,{"ZD1_PICM"		,npIcm				,Nil,Nil})
			aadd(aLinha,{"ZD1_TEC"		,cTEC				,Nil,Nil})
			aadd(aLinha,{"ZD1_PEDIDO"	,cPedido			,Nil,Nil})
			aadd(aLinha,{"ZD1_ITEMPC"	,cItemPc			,Nil,Nil})
			aadd(aLinha,{"ZD1_DTDIGI"	,dDataBase			,Nil,Nil})
			aadd(aLinha,{"ZD1_UMFOR"		,cUMfor			,Nil,Nil})
			aadd(aLinha,{"ZD1_FORNEC"	,cCodFor			,Nil,Nil})
			aadd(aLinha,{"ZD1_GRUPO"		,cGrupo			,Nil,Nil})
			aadd(aLinha,{"ZD1_LOJA"		,cLoja				,Nil,Nil})
			aadd(aLinha,{"ZD1_DOC"		,cDoc				,Nil,Nil})
			aadd(aLinha,{"ZD1_TIPO"		,cTipo				,Nil,Nil})
			aadd(aLinha,{"ZD1_EMISSA"	,dEmissao			,Nil,Nil})
			aadd(aLinha,{"ZD1_ITEM"		,cItem				,Nil,Nil})
			aadd(aLinha,{"ZD1_SERIE"		,cSerie			,Nil,Nil})
			aadd(aLinha,{"ZD1_DESCRI"	,cDescri			,Nil,Nil})
			aadd(aLinha,{"ZD1_CC"		,cCC				,Nil,Nil})
			aadd(aLinha,{"ZD1_CONTA"		,cConta			,Nil,Nil})
			aadd(aLinha,{"ZD1_TP"		,cTP				,Nil,Nil})
		
			AAdd(aPedIte,aLinha)

		EndIf

		//*************************************
		//Atualiza STATUS
		//*************************************

		If lAchouProd
			If lAchouPC
				cStatus	:= '2'
			Else
				cStatus	:= '1'
			EndIf
		EndIf
		
		aadd(aCabec,{"ZF1_STATUS" 	,cStatus		,Nil,Nil})
				
		
		//*************************************
		//Grava dados do XML
		//*************************************

		dbSelectArea("ZF1")
		dbsetorder(2)
		
		IF ZF1->(!dbSeek(cChvNfe))
			BEGIN TRANSACTION
			
			RecLock("ZF1",.T.)
			
			For i := 1 To Len(aCabec)
				
				cCampo		:= Alltrim("ZF1->"+aCabec[i][1])
				Replace &cCampo With aCabec[i][2]
				
			Next
			
			ZF1->(MsUnlock())
			
			dbSelectArea("ZD1")
			
			For j := 1 To len(aPedIte)
			
				RecLock("ZD1",.T.)
				
				For k := 1 To Len(aPedIte[j])
					
					cCampo		:= Alltrim("ZD1->"+aPedIte[j][k][1])
					Replace &cCampo With aPedIte[j][k][2]
				
				Next k
				
				ZD1->(MsUnlock())
				
			Next j
			
			END TRANSACTION
			//MsgAlert("TERMINOU O XML - " + cFile)
		EndIf
		
		//*************************************
		//Movimenta o arquivo
		//*************************************
		
		If lJob
			conOut( " " )
			conOut( " 1 - MSCOPYTO " )
			conOut( "Origem - \XML\RECEBIDO\" + aFiles[_x] )
			conOut( "Destino - \XML\IMPORTADO\teste.txt" )
			conOut( " " )
			conOut( " " )
			_lCopy	:= FRename( "\XML\RECEBIDO\" + aFiles[_x], "\XML\IMPORTADO\" + aFiles[_x])// + SubStr(aFiles[_x],1,Len(aFiles[_x])-3) + "log" )
			If _lCopy == 0
				conOut( " COPIOU " )
				//FERASE("\XML\RECEBIDO\" + aFiles[_x])
			Else
				conOut( "************************************************************")
				conOut( "ERRO ao copiar o arquivo " + cFile )
				conOut( "************************************************************")
				FRename( "\XML\RECEBIDO\" + aFiles[_x], "\XML\ERRO\" + aFiles[_x])// + SubStr(aFiles[_x],1,Len(aFiles[_x])-3) + "log" )
			EndIf
		Else
			_lCopy	:= CpyT2S( "G:\Protheus10\Protheus_Data\XML\RECEBIDO\" + aFiles[_x] , cDiretDest, .F. )
			If _lCopy
				FERASE("G:\Protheus10\Protheus_Data\XML\RECEBIDO\" + aFiles[_x])
			Else
				conOut( "************************************************************")
				conOut( "ERRO ao copiar o arquivo " + cFile )
				conOut( "************************************************************")
				CpyT2S( "G:\Protheus10\Protheus_Data\XML\RECEBIDO\" + aFiles[_x] , "\XML\ERRO\", .F. )
			EndIf
		EndIf
		
		//*************************************
		//Monta o LOG
		//*************************************
		
		cLog	+= "ARQ = " + aFiles[_x] + ";"
		cLog	+= " NFE = " + cDoc + "/" + cSerie + ";"
		If lAchouProd 
		
			cLog	+= " PRODUTOS = OK;"
			If lAchouPC
				
				cLog	+= " PEDIDO COMPRA = OK;"
				
				If U_fGeraPN(aCabec, aPedIte)
					cLog	+= " PRE NOTA = OK;"
				Else
					cLog	+= " PRE NOTA = XX;"
				EndIf
				
			Else
				/*
				If cSpecie == "CTE"
					If U_fGeraPN(aCabec, aPedIte, cSpecie)
						cLog	+= " PRE NOTA = OK;"
					Else
						cLog	+= " PRE NOTA = XX;"
					EndIf
				Else
					cLog	+= " PEDIDO COMPRA = XX;"
					cLog	+= " PRE NOTA = XX;"
				EndIf
				*/
				cLog	+= " PEDIDO COMPRA = XX;"
				cLog	+= " PRE NOTA = XX;"
				
			EndIf
		Else
			cLog	+= " PRODUTOS = XX;"
			cLog	+= " PEDIDO COMPRA = XX;"
			cLog	+= " PRE NOTA = XX;"
		EndIf
		cLog	+= cEOL
	Next _x	//Len(afiles)

	//*************************************
	//Gera o log 
	//*************************************
	U_fLogXML(cLog,lJob)

Else
	conOut( "Nใo encontrou arquivo no diretorio - " + cDiretOrig )
EndIf 		// Len(afiles) Se tem arquivo


If lJob

	dbCloseAll()
	Reset environment //colocar no final do processamento...

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfFindPC  บAutor  ณ  Gustavo Costa       บ Data ณ 12/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLocaliza o Pedido de Compra para os produtos do XML.        บฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fFindPC(cCod, cCodFor, cLoja, nQuant)

Local cQuery 	:= ""
Local aArea	:= getArea()
Local aRet		:= {}

cQuery += " SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_TES, C7_COND, C7_CC, C7_CONTA FROM " + RETSQLNAME("SC7") + " SC7 "
cQuery += " LEFT OUTER JOIN " + RETSQLNAME("ZD1") + " ZD1 "
cQuery += " ON C7_FILIAL = ZD1_FILIAL "
cQuery += " AND C7_NUM = ZD1_PEDIDO "
cQuery += " AND C7_ITEM = ZD1_ITEMPC "
cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
cQuery += " AND SC7.D_E_L_E_T_ <> '*' " 
cQuery += " AND ZD1.D_E_L_E_T_ <> '*' " 
cQuery += " AND C7_QUANT - C7_QUJE - ISNULL(ZD1_QUANT,0) >= " + Str(nQuant) 
cQuery += " AND C7_RESIDUO = '' "
//cQuery += " AND C7_TPOP <> 'P' "
cQuery += " AND C7_CONAPRO <> 'B' "
cQuery += " AND C7_ENCER = '' "
cQuery += " AND C7_PRODUTO = '" + cCod + "' " 
cQuery += " AND C7_FORNECE = '" + cCodFor + "' "
//cQuery += " AND C7_LOJA = '" + cLoja + "' "
cQuery += " ORDER BY C7_NUM, C7_ITEM, C7_PRODUTO "

cQuery := ChangeQuery(cQuery)

If Select("XPC") > 1
	XPC->(dbCloseArea())
EndIf
	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XPC",.T.,.T.)

dbSelectArea("XPC")
dbGoTop()

If XPC->(!Eof())

	AADD(aRet, XPC->C7_NUM)
	AADD(aRet, XPC->C7_ITEM)
	AADD(aRet, XPC->C7_PRODUTO)
	AADD(aRet, XPC->C7_TES)
	AADD(aRet, XPC->C7_COND)
	AADD(aRet, XPC->C7_CC)
	AADD(aRet, XPC->C7_CONTA)

Else

	For i := 1 To 7 //quantidade de campos
		AADD(aRet, "")
	Next i

EndIf

RestArea(aArea)

Return aRet

*****************************************
Static Function MarcarTudo()
	DbSelectArea('TC9')
	dbGoTop()
	While !Eof()
		MsProcTxt('Aguarde...')
		RecLock('TC9',.F.)
		TC9->T9_OK := _cMarca
		MsUnlock()
		DbSkip()
	EndDo
	DbGoTop()
	DlgRefresh(oDlgPedidos)
	SysRefresh()
	Return(.T.)

	******************************************
Static Function DesmarcaTudo()
	DbSelectArea('TC9')
	dbGoTop()
	While !Eof()
		MsProcTxt('Aguarde...')
		RecLock('TC9',.F.)
		TC9->T9_OK := ThisMark()
		MsUnlock()
		DbSkip()
	EndDo
	DbGoTop()
	DlgRefresh(oDlgPedidos)
	SysRefresh()
	Return(.T.)


	******************************************
Static Function Marcar()
	DbSelectArea('TC9')
	RecLock('TC9',.F.)
	If Empty(TC9->T9_OK)
		TC9->T9_OK := _cMarca
	Endif
	MsUnlock()
	SysRefresh()
	Return(.T.)
