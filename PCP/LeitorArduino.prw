// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : LerArduino
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 28/03/14 | Gustavo Costa     | Leitura das informaÁıes dos arduinos.
// ---------+-------------------+-----------------------------------------------------------
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"
//#INCLUDE "APWEBSRV.CH"
//#INCLUDE "XMLCSVCS.CH"
//#include 'fileio.ch'

#DEFINE STR0012 "Consultando Arduino"
#DEFINE STR0013 "Aguarde..."
*************

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} LerArduino
Le as informaÁıes dos Arduinos gravando as interferencias das maquinas.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de CÛdigo
@version   1.xx
@since     28/03/2014
/*/
//------------------------------------------------------------------------------------------

User Function LerArduino()

	Private lJob		:= .F.
	Private dData1

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//N„o consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SM2" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Atualizando Arduino... '+Dtoc(DATE())+' - '+Time())
		lJob := .T.
	EndIf

	If	( ! lJob )
		LjMsgRun(OemToAnsi('AtualizaÁ„o Arduino'),,{|| U_fLerArd()} )
	Else
		dData1	:= dDataBase - 3
		Conout("Chamada da funcao U_fLerArd(dData1) - " + DtoC(dData1))  
		For i := 1 to 4 // LÍ os ultimos tres dias atÈ hoje
			//Processa({|| U_fLerArd(dData)})
			U_fLerArd(dData1)
			dData1	:= dData1 + 1
		Next
	EndIf

	If	( lJob )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Arduinos Atualizados. '+Dtoc(DATE())+' - '+Time())
	EndIf
	
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Fun??o    ≥ fLerArd ∫ Autor ≥ Gustavo Costa      ∫ Data ≥     28/03/14 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descri??o ≥ Funcao para ler os dados dos arduinos                      ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function fLerArd(_dData)

	Local bARDSearch
	Local cTexto
	Local oOcorrencia
	Local cXML				:= ""
	Local dDia				:= ddatabase
	Local nSpace			:= 1
	Local cAjHora
	Local nCont			:= 0
	
	Private oWSARD
	Private oARD
	Private cError			:= ""
	Private cWarning		:= ""
	Private cArq
	Private aFields2  	:= {}
	Private cArq2
	
	Conout("Entrou na funcao U_fLerArd(dData) - ")
	If !lJob
		dDia	:= fDiaLeitura()
	Else
		dDia	:= _dData
	EndIf
	Conout("Pegou a data - " + DtoC(dDia))

	dbselectArea("Z90")

	cQuery := " SELECT * FROM " + RetSqlName("SH1") + " SH1 "
	cQuery += " WHERE H1_IP <> '' "
	cQuery += " AND D_E_L_E_T_ <> '*' "

	//MemoWrite("C:\TEMP\ARDUINO.SQL", cQuery )
	If Select("XMP") > 0
		DbSelectArea("XMP")
		XMP->(DbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "XMP"

	Conout("Listou a tabela XMP ")
	dbselectArea("XMP")
	dbGoTop("XMP")

	While XMP->(!EOF())
						
		conout(DtoC(dDia))
		If dDia == date()
			
			cAjHora	:=   Alltrim(Str( (dDia - CtoD("01/01/1970"))*86400 + TempoLig(Time(), "00:00:00")))
			ConOut("cAjHora - " + cAjHora)		
			cComando	:= '/setdt=' + cAjHora 
			ConOut("cComando - " + cComando)		
			If lJob
			
		 		//* Web Service
				oWSARD 		:= WSU_WSARDINFO():New()
				oWSARD:cARD	:= AllTrim(XMP->H1_IP) + cComando
				oWSARD:ARDSEARCH()
			
			Else
				//* Web Service
				bARDSearch := { ||														;
									oWSARD 		:= WSU_WSARDINFO():New(),			;
									oWSARD:cARD	:= AllTrim(XMP->H1_IP) + cComando,	;
									oWSARD:ARDSEARCH()									;
								}
			EndIf
			Sleep(3000)
		EndIf

		cComando	:= '/getdb=' + DtoS(dDia)

		If lJob

			conout("eh JOB - Instacia Objeto")
	 		//* Web Service
			oWSARD 		:= WSU_WSARDINFO():New()
			conout("Objeto Criado")
			oWSARD:cARD	:= AllTrim(XMP->H1_IP) + cComando
			conout("Add Comando")
			oWSARD:ARDSEARCH()
			conout("… JOB - Executou metodo")
			sleep(6000)
		Else
			//* Web Service
			bARDSearch := { ||															;
									oWSARD 		:= WSU_WSARDINFO():New(),			;
									oWSARD:cARD	:= AllTrim(XMP->H1_IP) + cComando,	;
									oWSARD:ARDSEARCH()									;
							}
			MsgRun( STR0012 + " - " + AllTrim(XMP->H1_IP) , STR0013 , bARDSearch ) //"Aguarde"###"Consultando arduino"
		EndIf
		
		cXML		:= oWSARD:cARDSEARCHRESULT //HttpGet('http://' + AllTrim(XMP->H1_IP) + cComando, , 120)
		conout(cXML)
		If !Empty(cXML)
			
			oArd		:= XmlParser( cXML , "_" , @cError , @cWarning )
			
			If Type('oArd') == "U"
				If lJob
					conout('Erro na leitura do arduino ' + AllTrim(XMP->H1_CODIGO) + ' IP - ' + AllTrim(XMP->H1_IP))
					nCont++
				Else
					MsgAlert('Erro na leitura do arduino ' + AllTrim(XMP->H1_CODIGO) + ' IP - ' + AllTrim(XMP->H1_IP))
					nCont++
				EndIf
				If nCont > 4
					Return
				EndIf
				XMP->(dbSkip())
				Loop // volta para o comeÁo
			EndIf
			
			cOcorrencia	:= "oArd:_ocorr" + DtoS(dDia)
	
			_CampoMaq	:= cOcorrencia + ":_maq:TEXT"
			cMaquina	:= &_CampoMaq

			cOcorrencia	+= ":_ocorr"
			For _y := 1 to len(&cOcorrencia)

				_CampoFunc	:= cOcorrencia + "[" + AllTrim(Str(_y)) + "]:_funcao:TEXT"
				cFuncao		:= &_CampoFunc

				_CampoTipo	:= cOcorrencia + "[" + AllTrim(Str(_y)) + "]:_tipo:TEXT"
				cTipo		:= &_CampoTipo

				_CampoData	:= cOcorrencia + "[" + AllTrim(Str(_y)) + "]:_data:TEXT"
				cDataMaq	:= &_CampoData

				_CampoHora	:= cOcorrencia + "[" + AllTrim(Str(_y)) + "]:_hora:TEXT"
				cHoraMaq	:= &_CampoHora
				
				nSpace := 6 - Len(cMaquina)
				
				If !Z90->(dbSeek(xFilial("Z90") + cMaquina + space(nSpace) + cFuncao + cTipo + cDataMaq + cHoraMaq))

					RecLock("Z90",.T.)

					Z90->Z90_FILIAL	:= xFilial("Z90")
					Z90->Z90_RECURSO	:= cMaquina
					Z90->Z90_FUNC		:= cFuncao
					Z90->Z90_TIPO		:= cTipo
					Z90->Z90_DATA		:= StoD(cDataMaq)
					Z90->Z90_HORA		:= cHoraMaq

					MsUnlock()

				EndIf

			Next _y

		EndIf
		XMP->(dbSkip())
	EndDo
	
XMP->(DbCloseArea())

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥ fDiaLeitura ∫ Autor ≥ Gustavo Costa     ∫ Data ≥  10/04/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Funcao para lÍ o dia manual da leitura do arduino.           ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

***************
Static Function fDiaLeitura()
***************

private dDia := dDataBase 

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±± DeclaraÁ„o de Variaveis                                                 ±±
Ÿ±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Informe o dia Manual",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Informar o Dia:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,dDia:=u,dDia)},oDlg99,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","dDia",,)
oSBtn1     := SButton():New( 008,080,1,{|| oDlg99:End()},oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return dDia


**************
Static Function TempoLig( _cHora1, _cHora2, lDiaSeg)
**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

If lDiaSeg
	
	//********************************************************
	//Inverte as horas para calcular atÈ meia noite 
	//********************************************************
	cHoraDS	:= _cHora1
	_cHora1	:= "23:59:59"

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 	:= Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 	:= Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4	:= Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 	:= Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1	:= _nHr1+_nMi1+_nSg1
	_nRs2	:= _nHr2+_nMi2+_nSg2
	
	_nRs3	:= _nRs1 - _nRs2 + 1
	
	//********************************************************
	//Calcula de 00:00 atÈ a proxima hora.
	//********************************************************

	_cHora1	:= cHoraDS
	_cHora2	:= "00:00:00"

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 	:= Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 	:= Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4	:= Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 	:= Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1	:= _nHr1+_nMi1+_nSg1
	_nRs2	:= _nHr2+_nMi2+_nSg2
	
	_nRs3	+= _nRs1 - _nRs2

	lMudouDia	:= .F.
	
Else

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1:=_nHr1+_nMi1+_nSg1
	_nRs2:=_nHr2+_nMi2+_nSg2
	
	_nRs3:=_nRs1 - _nRs2

EndIf
	
if _nRs3<0
  _nRs3	:= 0  
Endif

Return(  _nRs3  )    

