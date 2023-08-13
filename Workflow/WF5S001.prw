#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WF5S001 ºAutoria  ³ Flávia Rocha      º Data ³  23/07/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³WorkFlow para avisar ao responsável pela ocorrência 5S      º±±
±±º          ³ainda não tenha resposta, que o prazo expira nesta data     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 5S                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

**********************************
User Function WF5S001( )
**********************************

// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

Exec()

Return 

*************************
Static Function Exec()   
*************************

Local cQuery 		:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local cUsu		:= ""
Local aUsu		:= {}
Local cResp
Local cNumSol       := ""
Local cProblema     := ""
Local cNomeResp		:= ""
Local cEmailResp	:= "" 
Local cArqFoto := ""
Local cPathFA  := ""
Local cCaminho := ""
Local cMail5S   := GetMV("RV_EQP5S") 
Local lCopiou   := .F.

SetPrvt("OHTML,OPROCESS")


conout(Replicate("*",60))
conout("Aviso CallCenter - INICIO")
conout(Replicate("*",60))

oProcess:=TWFProcess():New("5S","Aviso - 5S")
oProcess:NewTask('Aviso Prazo',"\workflow\http\oficial\WF5S001.html")
oHtml := oProcess:oHtml


cQuery := " SELECT Z80_FILIAL Z80FIL,Z81_FILIAL,Z80_INTEGR, Z81_USER,Z80_DTSOL,* "+LF
cQuery += " From " + RetSqlName("Z80") + " Z80, " +LF
cQuery += " " + RetSqlName("Z81") + " Z81 " +LF
cQuery += " WHERE   "+LF
cQuery += " Z80_DTSOL = ''  "+LF     ///data para ação preenchida

cQuery += " AND Z80.D_E_L_E_T_ = '' "+LF
cQuery += " AND Z81.D_E_L_E_T_ = '' "+LF
cQuery += " AND Z80_NUMSOL = Z81_NUMSOL "+LF
cQuery += " AND Z80_DTPREV = '" + DtoS(dDatabase) + "' " + LF 
//cQuery += " AND Z80_DTPREV >= '20120801' " + LF 

cQuery += " ORDER BY Z80_FILIAL,Z80_NUMSOL " +LF
Memowrite("C:\Temp\WF5S001.sql",cQuery) 

If Select("TMPA") > 0
	DbSelectArea("TMPA")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TMPA" 
TCSetField( "TMPA" , "Z80_DTPREV", "D")
TCSetField( "TMPA" , "Z80_EMISSA", "D")

TMPA->(DbGoTop())

While TMPA->(!EOF())
	cNumSol:= TMPA->Z80_NUMSOL
	cProblema:= MSMM(TMPA->Z80_CODMP,80)        //para carregar Z80->Z80_PROBLE
	dEmissao := TMPA->Z80_EMISSA
	dPrev    := TMPA->Z80_DTPREV
	cArqFoto := TMPA->Z80_FOTOA
	cPathFA  := TMPA->Z80_PATHA
	cCaminho := Alltrim(cPathFA) + Alltrim(cArqFoto)
	
	While Alltrim(TMPA->Z80_NUMSOL) = Alltrim(cNumSol)	
		PswOrder(1)		                             
		If PswSeek( TMPA->Z81_USER, .T. )											
		   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
		   //cNomeOper   := Alltrim( aUsu[1][2] )      //Nome do usuário
		   cNomeResp += Alltrim(aUsu[1][4])  + ",  "		//Nome Completo do usuário
		   cEmailResp+= Alltrim(aUsu[1][14]) + ";" 		//Email usuário
		Endif

		TMPA->(DBSKIP())
	Enddo		
			   	
	// Inicialize a classe de processo:
	oProcess:=TWFProcess():New("CALLCENTER","Call center")
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WF5S001.html")
	oHtml   := oProcess:oHtml
	oHtml:ValByName("cMail5S", cMail5S )				
	oHtml:ValByName("cRespon", cNomeResp )
	oHtml:ValByName("cEmail", cEmailResp )
	oHtml:ValByName("cNumSol", cNumSol )
	oHtml:ValByName("cProblema", cProblema )	
	oHtml:ValByName("Demissao" , Dtoc(dEmissao) )
	oHtml:ValByName("DPrev", Dtoc(dPrev) )

	// Informe a função que deverá ser executada quando as respostas chegarem ao Workflow.
	oProcess:cTo      := cMail5S + ';' + cEmailResp
	oProcess:cTo      += ";marcelo@ravaembalagens.com.br"
	oProcess:cTo	  += ";orley@ravaembalagens.com.br"
	oProcess:cTo	  += ";rh@ravaembalagens.com.br" 	
	//oProcess:cTo      := ""
	
	//oProcess:cBCC	  := "flavia.rocha@ravaembalagens.com.br"
	oProcess:cSubject := "5S - LEMBRETE DE PRAZO A EXPIRAR"
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	//MsAguarde( { || lCopiou := CpyT2S( Alltrim(cCaminho) , "\Temp", .T. ) }, "Aguarde. . .", "Anexando Foto ao E-Mail . . ." )
	lCopiou := CpyT2S( Alltrim(cCaminho) , "\Temp", .T. ) 
	oProcess:AttachFile( "\Temp\" + Alltrim(cArqFoto) )    
	oProcess:Start()				
	WfSendMail()
	
Enddo

DbselectArea("TMPA")
TMPA->(DBCLOSEAREA()) 


// Habilitar somente para Schedule
Reset environment		

Return