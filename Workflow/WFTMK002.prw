#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFTMK002 บAutoria  ณ Flแvia Rocha      บ Data ณ  02/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWorkFlow para avisar ao responsแvel pela ocorr๊ncia que     บฑฑ
ฑฑบ          ณainda nใo tenha resposta (dentro do prazo 1 dia)            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CallCenter                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

**********************************
User Function WFTMK002( )
**********************************

Local aRespo 		:= {} 
Local aUser			:= {}     
Local _nX    		:= 0
Local cQuery 		:= ""
Local eEmail		:= ""
Local cNFiscal		:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local nFalta	:= 0 
Local cUsu
Local cResp
Local eEmail 		:= ""
Local cTransp		:= ""
Local cRedesp		:= "" 
Local cNomTransp 	:= "" 
Local cNomRedesp	:= ""
Local cNota			:= ""
Local cSerinf		:= ""
Local nItemUD		:= 0
Local cUCcodigo		:= ""
Local cUCcodAnt		:= ""
Local cExecut		:= ""
Local cExecutAnt	:= ""
Local cOperador		:= ""
Local cNomeOper		:= ""
Local cSup			:= ""
Local cNomeSup		:= ""  
Local cMailSup		:= ""

SetPrvt("OHTML,OPROCESS")


// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"



oProcess:=TWFProcess():New("CALLCENTER","Aviso - Call center")
oProcess:NewTask('Aviso Prazo',"\workflow\http\oficial\WFTMK002.html")
oHtml := oProcess:oHtml


cQuery := " SELECT UD_DTINCLU,UD_DATA, UD_RESOLVI, UC_FILIAL, UC_CODIGO, UC_DATA, UC_PENDENT, UC_HRPEND,  UC_INICIO, UC_NFISCAL,UC_SERINF, "+LF
cQuery += " UC_CHAVE, UC_ENTIDAD,  UD_FILIAL,UD_CODIGO, UD_ITEM, UD_FLAGAT,   "+LF
cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UC_OPERADO, UD_OPERADO  "+LF
cQuery += " FROM SUC020 SUC, "+LF
cQuery += " SUD020 SUD  "+LF
cQuery += " WHERE UC_CODIGO = UD_CODIGO  "+LF
cQuery += " AND (UD_DATA = '' ) "+LF     ///data para a็ใo preenchida
cQuery += " AND (UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) <> ''   "+LF
cQuery += " AND UD_STATUS <> '2' "+LF

cQuery += " AND UD_DTINCLU >= '" + DtoS(dDatabase - 1) + "' and UD_DTINCLU <= '" + DtoS(dDatabase - 1) + "' " + LF 

cQuery += " AND SUD.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SUC.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF
cQuery += " AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF
cQuery += " Group by UD_DTINCLU, UD_DATA, UD_RESOLVI, UC_FILIAL, UC_CODIGO, UC_DATA, UC_PENDENT, UC_HRPEND,  UC_INICIO, UC_NFISCAL,UC_SERINF, "+LF
cQuery += " UC_CHAVE, UC_ENTIDAD,  UD_FILIAL,UD_CODIGO, UD_ITEM, UD_FLAGAT,   "+LF
cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5,  UC_OPERADO, UD_OPERADO  "+LF
cQuery += " ORDER BY UD_CODIGO,UD_ITEM " +LF
//Memowrite("C:\Temp\WFTMK002.sql",cQuery) 

If Select("TMPA") > 0
	DbSelectArea("TMPA")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TMPA" 
TCSetField( "TMPA" , "UC_PENDENT", "D")
TCSetField( "TMPA" , "UD_DATA", "D")

TMPA->(DbGoTop())
dDataHj := dDatabase
While TMPA->(!EOF())
	
	cNomeOper := ""
	SU7->(DbSetorder(1))
	If SU7->(Dbseek(xFilial("SU7") + TMPA->UC_OPERADO ))
	  	cOperador := SU7->U7_CODUSU
	Endif
	PswOrder(1)
	                             
	If PswSeek( cOperador, .T. )         
										
	   aUsu   := PSWRET() 					// Retorna vetor com informa็๕es do usuแrio
	   //cNomeOper   := Alltrim( aUsu[1][2] )      //Nome do usuแrio
	   cNomeOper := Alltrim(aUsu[1][4])			//Nome Completo do usuแrio
	   //msgbox(cNomeOper)
	Endif
				
	cUCcodigo := TMPA->UC_CODIGO
	cExecut   := TMPA->UD_OPERADO 
	
	If cUCcodigo != cUCcodAnt       ////se o responsแvel for o mesmo, nใo farแ a passagem abaixo, evita que envie duas vezes
	      aRespo    := {} 
	      nItemUD := 0						 							
	      
	      
					      
			cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, UD_RESOLVI,UD_DTINCLU, " + LF
			cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, " + LF
			cQuery += " UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_ENTIDAD, UC_CHAVE " + LF
			
			cQuery += " FROM "+RetSqlName("SUD")+" SUD, " + LF
			cQuery += " "+RetSqlName("SUC")+" SUC " + LF
			cQuery += " WHERE UC_CODIGO = UD_CODIGO  "+LF
			cQuery += " AND UD_DTINCLU >= '" + DtoS(dDatabase - 1) + "' and UD_DTINCLU <= '" + DtoS(dDatabase - 1) + "' " + LF
			cQuery += " AND (UD_DATA = '' ) "+LF     ///data para a็ใo preenchida
			 
			cQuery += " AND SUD.D_E_L_E_T_ = ''  "+LF
			cQuery += " AND SUC.D_E_L_E_T_ = ''  "+LF
			cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF
			cQuery += " AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF
			cQuery += " AND UD_CODIGO = '" + cUCcodigo + "' " + LF
			cQuery += " AND UD_OPERADO = '"  + cExecut   + "' " + LF
			cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "			 + LF
			//Memowrite("C:\TMK002.SQL",cQuery)
			If Select("SUDX1") > 0		
				DbSelectArea("SUDX1")
				DbCloseArea()			
			EndIf
			TCQUERY cQuery NEW ALIAS "SUDX1"
			TCSetField( "SUDX1", "UD_DATA"   , "D")
			TCSetField( "SUDX1", "UD_DTINCLU"   , "D")
			SUDX1->(DbGoTop())
			While !SUDX1->(Eof())
				cNota	:= SUDX1->UC_NFISCAL
	      		cSerinf	:= SUDX1->UC_SERINF
	      		cEntidade := SUDX1->UC_ENTIDAD
	      		cChave    := SUDX1->UC_CHAVE											

				If !Empty(Alltrim( SUDX1->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
						         
						Aadd(aRespo, { SUDX1->UD_CODIGO,;       //1
										SUDX1->UD_N1,;            	//2
						       			SUDX1->UD_N2,;            	//3
						       			SUDX1->UD_N3,;            	//4
						       			SUDX1->UD_N4,;            	//5
						       			SUDX1->UD_N5,;            	//6
						       			SUDX1->UD_OPERADO,;       	//7
						       			cEntidade,;             	//8
						       			cChave,;            	    //9
						       			SUDX1->UD_ITEM,;        	//10
						       			SUDX1->UD_FILIAL,;	      	//11
						       			SUDX1->UD_OBS,;      		//12
						       			SUDX1->UD_DATA,;    		//13
						        		SUDX1->UC_NFISCAL,; 		//14
						        		SUDX1->UC_SERINF,;          //15 
						        		SUDX1->UD_DTINCLU } )		//16
						        		
						        		nItemUD++
			    Endif
			    
		      	SUDX1->(DBSKIP())
			Enddo
			cExecutAnt := cExecut
			If nItemUD > 0
			   	
			   	// Inicialize a classe de processo:
				oProcess:=TWFProcess():New("CALLCENTER","Call center")
	
				// Crie uma nova tarefa, informando o html template a ser utilizado:
				oProcess:NewTask('Inicio',"\workflow\http\oficial\WFTMK002.html")
				oHtml   := oProcess:oHtml
				
								
				PswOrder(1)                             
				If PswSeek( aRespo[1][7], .T. )         
														
				   aUsu   := PSWRET() 					// Retorna vetor com informa็๕es do usuแrio
				   cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuแrio (responsแvel pelo atendimento)
				   eEmail := Alltrim( aUsu[1][14] )     // e-mail
					cSup   := aUsu[1][11]
					
					///verifica o superior do usuแrio para enviar a ocorr๊ncia com c๓pia ao Superior dele
				   	PswOrder(1)
				   	If PswSeek(cSup, .t.)
					   aSup := PswRet()
					   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
					   cMailSup := Alltrim( aSup[1][14])                //endere็o e-mail
				   Endif
				
				Endif                                   
				
				oHtml:ValByName("cNomeSup", cNomeSup )
				oHtml:ValByName("eEmailSup", cMailSup )
				oHtml:ValByName("cResp", cUsu )
				oHtml:ValByName("cEmail", eEmail )
								
				DbSelectArea(aRespo[1,8])
				DbSetOrder(1)
				DbSeek(xFilial(aRespo[1,8])+AllTrim(aRespo[1,9]))
				
				oHtml:ValByName("cCli", iif(aRespo[1,8]=="SA1",SA1->A1_NOME,iif(aRespo[1,8]=="SA2",SA2->A2_NOME,"") ) )
				oHtml:ValByName("cNF", cNota )
				oHtml:ValByName("cSERINF", cSerinf )
				
				SF2->(Dbsetorder(1))
				If SF2->(Dbseek( xFilial("SF2") + cNota + cSerinf ))					
					cTransp:= SF2->F2_TRANSP
					cRedesp := SF2->F2_REDESP
				Endif
				SA4->(Dbsetorder(1))
				SA4->(Dbseek(xFilial("SA4") + cTransp ))
				cNomTransp := SA4->A4_NREDUZ
				
				oHtml:ValByName("cTransp", cNomTransp )
				
				SA4->(Dbsetorder(1))
				SA4->(Dbseek(xFilial("SA4") + cRedesp ))
				cNomRedesp := SA4->A4_NREDUZ
				oHtml:ValByName("cRedesp", cNomRedesp )
				
				
				For _nX := 1 to Len(aRespo)
				     
				   aadd( oHtml:ValByName("it.cAtend"), aRespo[_nX,1] )
				   aadd( oHtml:ValByName("it.cItem"),  aRespo[_nX,10] )	
				   aadd( oHtml:ValByName("it.cProb") , iif(!Empty(aRespo[_nX,2]),Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,2],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,3]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,3],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,4]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,4],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,5]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,5],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,6]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,6],"Z46_DESCRI"),"") )
				   aadd( oHtml:ValByName("it.Respon"), cUsu )
				   aadd( oHtml:ValByName("it.cObs"), aRespo[_nX,12] )
				   aadd( oHtml:ValByName("it.DtInclu"), Dtoc(aRespo[_nX,16]) )
				   aadd( oHtml:ValByName("it.Data"), Dtoc(aRespo[_nX,13]) )
				   aadd( oHtml:ValByName("it.filial"), aRespo[_nX,11] )
				Next _nX			
				
				oHtml:ValByName("cOperador", cNomeOper )
				
				// Informe a fun็ใo que deverแ ser executada quando as respostas chegarem
				// ao Workflow.
				oProcess:cTo      :=  eEmail  + ";sac@ravaembalagens.com.br"
				oProcess:cCC	  := cMailSup
				oProcess:cBCC	  := "gustavo@ravaembalagens.com.br"
				oProcess:cSubject := "LEMBRETE DE PRAZO A EXPIRAR - Ocorr๊ncia - SAC"
							
				// Neste ponto, o processo serแ criado e serแ enviada uma mensagem para a lista
				// de destinatแrios.
				oProcess:Start()				
				WfSendMail()
				
				cUCcodAnt := cUCcodigo	
				
			Endif							
		
	Endif
 
	TMPA->(DBSKIP())
Enddo

DbselectArea("TMPA")
TMPA->(DBCLOSEAREA()) 


// Habilitar somente para Schedule
Reset environment		

Return .T.