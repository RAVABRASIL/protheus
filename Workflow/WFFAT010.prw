#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"

//------------------------------------------------------------------------------------------------
//Programa: WFFAT010.PRW
//Data    : 01/08/2011
//Autoria : Flávia Rocha
//Objetivo: Acionado dentro dos ptos de entrada: SF2460I_AP7 (inclusão de NF Saída)
//          e SF2520E_AP7 (Exclusão de NF Saída)
//		    Toda vez que é emitida ou cancelada uma NF de transf. entre as filiais Rava
//          Enviar um email para a Logística avisando
//-------------------------------------------------------------------------------------------------

***************************
User Function WFFAT010( cNota, cSerie, nOP )
***************************  

Local cCodUser 	:=  __CUSERID 
Local aUsuarios := {} 
Local cNomeUser	:= ""
Local eEmail	:= ""
Local cMailUser := ""
Local cCargoUser:= ""
Local LF		:= CHR(13) + CHR(10)

	If Alltrim( cSerie ) != ' '

		SetPrvt("nTotNF,cQuery,eEmail,oProcess,oHtml,_user,cProd")
		SetPrvt("cVenc,nTotNF,cQuery2,nTotQt,subj")

		cQuery := "SELECT SD2.D2_TES, SD2.D2_ITEM, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_PRCVEN, SF2.F2_TRANSP, SA4.A4_NOME, SA4.A4_EMAIL, SF2.F2_DOC, SF2.F2_SERIE, SA1.A1_MUN, SF2.F2_EST, " + LF
		cQuery += " SF2.F2_PBRUTO, SF2.F2_VALBRUT, SD2.D2_COD, SD2.D2_QUANT, SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NREDUZ "+LF
		
		cQuery += "FROM " 
		cQuery += " " + RetSqlName('SF2') + " SF2, " 
		cQuery += " " + RetSqlName('SA4') + " SA4, " 
		cQuery += " " + RetSqlName('SD2') + " SD2, " 
		cQuery += " " + RetSqlName('SA1') + " SA1 "+LF
		
		cQuery += "WHERE SF2.F2_TRANSP = SA4.A4_COD "+LF
		cQuery += "AND SA1.A1_CGC LIKE ('41150160%') " + LF    //se o CLIENTE É CNPJ RAVA, A NF É DE TRANSF.
		cQuery += "AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE "+LF
		cQuery += "AND SF2.F2_CLIENTE = SA1.A1_COD "+LF
		cQuery += "AND SF2.F2_DOC = '" + cNota + "' AND SF2.F2_SERIE =  '" + cSerie + "' "    +LF
		cQuery += "AND F2_TIPO = 'N'  "+LF
		cQuery += "AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' "+LF
		cQuery += "AND SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "' AND SA4.D_E_L_E_T_ = ' ' "+LF
		cQuery += "AND SD2.D2_FILIAL = '" + xFilial( "SD2" ) + "' AND SD2.D_E_L_E_T_ = ' ' "+LF
		cQuery += "AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "+LF
		//cQuery := ChangeQuery( cQuery )
		MemoWrite("C:\Temp\WFFAT010.SQL",cQuery)
		If Select("TRAX") > 0
			DbselectArea("TRAX")
			DbcloseArea()
		Endif 
		TCQUERY cQuery NEW ALIAS "TRAX"
		TCSetField("TRAX", "F2_EMISSAO", "D")
		TRAX->( DbGoTop() )

	
		If ! TRAX->( EoF() )        

			TRAX->( DbGoTop() )
			If nOP == 1
				oProcess := TWFProcess():New("WFFAT010","Envio de e-mail para Logística")
				oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT010i.htm")
				subj	:= "NF Transferência - Entre filiais RAVA"
			ElseIf nOP == 2
				oProcess := TWFProcess():New("WFFAT010","Cancelamento de nf")
				oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT010e.htm") 
				subj	:= "NF CANCELADA - Transferência - Entre filiais RAVA"
			EndIf
			oHtml   := oProcess:oHtml
			_user := Subs(cUsuario,7,15)
			
			PswOrder(1)
			If PswSeek( cCodUser, .T. )
				aUsuarios  := PSWRET() 				 	// Retorna vetor com informações do usuário		
				//cNomeUser := Alltrim(aUsuarios[1][2])     	// Nome do usuário
				cNomeUser := Alltrim(aUsuarios[1][4])     	// Nome completo
				cMailUser:= Alltrim(aUsuarios[1][14])     // e-mail
				cCargoUser:= Alltrim(aUsuarios[1][13])     // cargo
			Endif

			
			oHtml:ValByName( "dEmissao"	  , DtoC( dDatabase ) )
			oHtml:ValByName( "cNF" 		  , Alltrim( TRAX->F2_DOC ) + "/" + Alltrim(TRAX->F2_SERIE) )
			oHtml:ValByName( "nValor"     , Transform( TRAX->F2_VALBRUT, '@E 999,999.99' ) )
			oHtml:ValByName( "cCliente"  , (TRAX->F2_CLIENTE + "/" + TRAX->F2_LOJA + " - " + TRAX->A1_NREDUZ) )
			
			TRAX->( DbGoTop() )
			
			While !TRAX->( EoF() )
				//msgbox(TRAX->D2_ITEM + ' / ' + TRAX->D2_COD + ' / ' + Str(TRAX->D2_QUANT) + ' / ' +Transform( TRAX->D2_PRCVEN , "@ 999,999,999.99" ) )
				aadd( oHtml:ValByName("it.cItem") , TRAX->D2_ITEM )                        
				aadd( oHtml:ValByName("it.cProduto") , TRAX->D2_COD )     
				aadd( oHtml:ValByName("it.nQuant") , Str(TRAX->D2_QUANT) )    
				aadd( oHtml:ValByName("it.nValUNI") , Transform( TRAX->D2_PRCVEN , "@E 999,999,999.99" ))    
						
				TRAX->(DBSKIP())
			Enddo
			
			oHtml:ValByName( "cNomeUser"  , Alltrim(cNomeUser) )
			oHtml:ValByName( "cCargoUser" , cCargoUser)
			oHtml:ValByName( "cMailUser"  , cMailUser)
			If SM0->M0_CODFIL = '01' 
				oHtml:ValByName( "cNomEmp"    , "Rava Embalagens " )
			Else 
				oHtml:ValByName( "cNomEmp"    , ( "Rava Embalagens " + Alltrim(SM0->M0_FILIAL) )  )
			Endif
			
	    	oProcess:ClientName( _user )
			eEmail := "joao.emanuel@ravaembalagens.com.br;alexandre@ravaembalagens.com.br"
			//eEmail += "flavia.rocha@ravaembalagens.com.br"
			oProcess:cTo	:= eEmail
				
			oProcess:cSubject  := subj
	 		oProcess:Start()
			WfSendMail()
			Sleep( 2000 ) //aguarda 2 seg para que o e-mail seja enviado
			oProcess:Finish()
	
				       
			WfSendMail()
			Sleep( 2000 ) //aguarda 2 seg para que o e-mail seja enviado 
			TRAX->( DbCloseArea() )
        Endif
	EndIf

Return
