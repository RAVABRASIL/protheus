#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 
#include "Topconn.ch"

/*
LOCALIZAÇÃO : Function A650TudoOk() - Responsável por validar a Enchoice em relação as datas de início previsto e entrega prevista com prazo de entrega. 

DESCRIÇÃO : Permite executar a validação do usuário ao confirmar a OP.
*/

*************

User Function MA650TOK() 

*************


// NOVO

LOCAL aCab   := {}
LOCAL aItens := {}
Local cCodUser  := ""	//código do usuário que está logado
Local cNomSolic := ""
LOCAL cQry:=''
Local aArea		:= GetArea()
LOCAL lRet:=.T.
Local nSaveSX8:= GetSX8Len()
local cNumREQ:=''
local cGrupo :=" "
local nQtdM:=0
local nQtdPI:=1
Local nQtd:=0
Local nQtdCX:=0
Local nItem:=1 
LOCAL nItemCX:=1 
LOCAL nResto :=0
aPrd:={}



If !INCLUI

	If  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "01" // Filial Saco

	    IF ALLTRIM(M->C2_ITEM)='01' .AND. ALLTRIM(M->C2_SEQUEN)='001'

		    // VALIDA O CAMPO PARA INFORMAR A EXTRUSORA 
		    IF SC2->C2_EXTRUSO<>M->C2_EXTRUSO
	           ALERT("O Campo Extrusora Não pode ser Alterado.")
		       M->C2_EXTRUSO:= SC2->C2_EXTRUSO
		       RETURN .F. 
	        ENDIF
        
        ELSE
            
            ALERT("O Campo Extrusora é Obrigatório na OP.: "+ alltrim(M->C2_NUM)+'01001')
		    RETURN .F. 
	    
        endif
        
    endif



	dbSelectArea("QPK")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
	
		RecLock("QPK", .F.)
		
		QPK->QPK_DTPROD	:= M->C2_DATPRI
		
		QPK->(MsUnLock())
		
	EndIf
	
	RESTAREA(aArea)
	
	RETURN .T.

Else

	If  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "03" // filial caixa
	
	    if ALLTRIM( Posicione("SB1",1,xFilial("SB1") + M->C2_PRODUTO , "B1_SETOR"))<>'39'	
	        RETURN .T. 
	    ENDIF
	    
	    if ALLTRIM(M->C2_OPLIC)='S'  // OP DE AMOSTRA    
	        RETURN .T. 
	    ENDIF
	    
	    
	    cQry:="SELECT G1_QUANT,*  " 
		cQry+= "FROM   "+retSqlName("SG1")+" SG1 "
		cQry+="WHERE G1_COD='"+M->C2_PRODUTO+"' "
		//cQry+="AND G1_COMP='"+GetMV("MV_PRDFITA")+"' "
		cQry+="AND G1_COMP IN ("+GetMV("MV_PRDFITA")+") "        // AGORA E FITA(ME0101) E CAPA
		cQry+="AND D_E_L_E_T_<>'*' "
	
		If Select("_TMREQ") > 0
	        DbSelectArea("_TMREQ")
	        _TMREQ->(DbCloseArea())
	    EndIf
		
		TCQUERY cQry NEW ALIAS "_TMREQ"
		
		// USUARIO ADMINISTRADOR 
		cCodUser := '000000' // __CUSERID
		
		PswOrder(1)
		If PswSeek( cCoduser, .T. )
		   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
		   cNomeuser := Alltrim(aUsu[1][2])		// Nome do usuário 
		Endif
		
		Begin Transaction
	
			if Empty(cNumREQ)
			   cNumREQ  := GetSxeNum("SCP","CP_NUM")
			   while SCP->( DbSeek( xFilial( "SCP" )+cNumREQ ) )
				  ConfirmSX8()
				  cNumREQ  := GetSxeNum("SCP","CP_NUM")
			   end
		    endif
	  
	     	SX5->(Dbsetorder(1))
			If SX5->(Dbseek(xFilial("SX5") + "ST" + cCodUser))
				cGrupo := SX5->X5_DESCRI
			ENDIF   
				     
				     aCab := {{"CP_	PRODUTO"    , _TMREQ->G1_COMP, NIL},;
			                  {"CP_USER"      , '000000'/*cCodUser*/, NIL},;
	                          {"CP_NUM"       , cNumREQ, NIL},;	                      
		                      {"CP_SOLICIT"   , 'Administrador'/*cNomeuser*/, NIL},;
			                  {"CP_EMISSAO"     ,dDatabase       , NIL} }
	   		                 
	                 // iif(round(_TMREQ->G1_QUANT*M->C2_QUANT,0)=0,1,round(_TMREQ->G1_QUANT*M->C2_QUANT,0))
	                 
	                 Do While ! _TMREQ->(EOF())
			         
			         nQtdCx:=_TMREQ->G1_QUANT*M->C2_QUANT                
	                 If ( nQtdCx - Int( nQtdCx ) ) > .00999
	                    nQtdCx:=Int( nQtdCx )+1
	                 EndIf
	
			            Aadd(aItens, {{"CP_PRODUTO"  ,_TMREQ->G1_COMP,NIL},;                               
		                           {"CP_QUANT"    ,nQtdCx ,NIL},;                         
	                               {"CP_GRUPO"    ,cGrupo,NIL},;                         	                           
		                           {"CP_ITEM"     ,strzero(nItemCX,2),NIL} }) 
		                nItemCX+=1            
			           _TMREQ->(DBSKIP())
			        eNDdO               
			                     
			if Len(aCab) > 0 .and. Len(aItens) >0 
				
				   lMsErroAuto := .F.
				   MSExecAuto({|x,y,z| MATA105(x,y,z)},aCab,aItens,3)		
					   
				   if lMsErroAuto
				      DisarmTransaction()
				      MostraErro()
				      lRet:=.F.
		           Else       
		              while ( GetSX8Len() > nSaveSX8 )
			            ConfirmSX8()
		              Enddo	              
		                // salva a op na SCP
		                SCP->(DBSETORDER(1))
		                SCP->( DbSeek( xFilial( "SCP" )+cNumREQ ) )     
		                Do While SCP->(!EOF())  .AND. SCP->CP_NUM==cNumREQ
		                   RecLock( "SCP", .F. )
		                   SCP->CP_OP:=ALLTRIM(M->C2_NUM)+'01001'
		                   SCP->CP_USER:='000000' //cCodUser
		                   SCP->CP_SOLICIT:='Administrador'
		                   SCP->(MsUnlock())       
		                   SCP->(DBSKIP()) 
		                EndDo   
		                // ENVIA EMAIL 
		                EMAIL(cNumREQ,M->C2_NUM)
		                alert('Requisicao gerada com sucesso: '+alltrim(cNumREQ))
		           EndIf   
			Endif  
		
		End Transaction  	  
		  
	ElseIf  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "01" // Filial Saco
	        
	    // VALIDA O CAMPO PARA INFORMAR A EXTRUSORA 
	    IF EMPTY(M->C2_EXTRUSO)
           ALERT("O Campo Extrusora é Obrigatório.")
	       RETURN .F. 
        ENDIF

	    
	    if ALLTRIM(M->C2_OPLIC)='S'  // OP DE AMOSTRA    
	        RETURN .T. 
	    ENDIF
	    
	    fBuscaPrd(M->C2_PRODUTO)
	
	
		// USUARIO ADMINISTRADOR 
		cCodUser := '000000' // __CUSERID
			
		PswOrder(1)
		If PswSeek( cCoduser, .T. )
		   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
		   cNomeuser := Alltrim(aUsu[1][2])		// Nome do usuário 
		Endif
			
	  Begin Transaction
		
		if Empty(cNumREQ)
			cNumREQ  := GetSxeNum("SCP","CP_NUM")
			while SCP->( DbSeek( xFilial( "SCP" )+cNumREQ ) )
				ConfirmSX8()
				cNumREQ  := GetSxeNum("SCP","CP_NUM")
			end
		endif
			  
	    SX5->(Dbsetorder(1))
	    If SX5->(Dbseek(xFilial("SX5") + "ST" + cCodUser))
		   cGrupo := SX5->X5_DESCRI
	    ENDIF
	
	    aCab := {{"CP_USER"      , '000000'/*cCodUser*/, NIL},;
	             {"CP_NUM"       , cNumREQ, NIL},;
	             {"CP_SOLICIT"   , 'Administrador'/*cNomeuser*/, NIL},;
	             {"CP_EMISSAO"     ,dDatabase       , NIL} }
	
	    For _XT:=1 to len(aPrd)
			   
		   IF aPrd[_XT][4]='M' // MASTER
		      nQtdM:=aPrd[_XT][2]	      
		      For _XG:=1 to len(aPrd[1][5])
		          nQtdPi:=nQtdPi*(aPrd[1][5][_XG][2]/aPrd[1][5][_XG][3])
		      Next
		      nQtd:= M->C2_QUANT*nQtdPi*nQtdM
		      nResto := Mod( nQtd, 25 )
		      If nResto<>0
		         nQtd:=(int(nQtd/25)+1)*25
		      Endif	   
		   ElseIF aPrd[_XT][4]='F' // FITA
		      //nQtd:=round(aPrd[_XT][2]*M->C2_QUANT,0) 
	          nQtd:=aPrd[_XT][2]*M->C2_QUANT
		      If ( nQtd - Int( nQtd ) ) > .00999
	               nQtd:=Int( nQtd )+1
	          EndIf
	
		      If int(nQtd)=0
		         nQtd:=1
		      endif                        
	
		   Endif
		   If nQtd <= 0
		   	nQtd := aPrd[_XT][2]*M->C2_QUANT
		   Endif
		   Aadd(aItens, {{"CP_PRODUTO"  ,aPrd[_XT][1],NIL},;        
		                  {"CP_QUANT"    ,nQtd,NIL},;
		                 {"CP_GRUPO"    ,cGrupo,NIL},;
		                 {"CP_ITEM"     ,strzero(nItem,2),NIL} })
		   nItem+=1
	    Next
	
		if Len(aCab) > 0 .and. Len(aItens) >0
			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| MATA105(x,y,z)},aCab,aItens,3)
			
			if lMsErroAuto
				DisarmTransaction()
				MostraErro()
				lRet:=.F.
			Else
				while ( GetSX8Len() > nSaveSX8 )
					ConfirmSX8()
				Enddo
				// salva a op na SCP
				SCP->(DBSETORDER(1))
				SCP->( DbSeek( xFilial( "SCP" )+cNumREQ ) )
				Do While SCP->(!EOF())  .AND. SCP->CP_NUM==cNumREQ
					RecLock( "SCP", .F. )
					SCP->CP_OP:=ALLTRIM(M->C2_NUM)+'01001'
					SCP->CP_USER:='000000' //cCodUser  
					SCP->CP_SOLICIT:='Administrador'
					SCP->(MsUnlock())
					SCP->(dbskip())
				EndDo
				// ENVIA EMAIL
				EMAIL(cNumREQ,M->C2_NUM)
				alert('Requisicao gerada com sucesso'+alltrim(cNumREQ))
			EndIf
		Endif
	  End Transaction  	  
	Endif

EndIf
RESTAREA(aArea)

Return lRet   



***************

Static Function EMAIL(cNum,cOP)

***************

oProcess:=TWFProcess():New("SCPOP","SCPOP")
oProcess:NewTask('Inicio',"\workflow\http\emp01\SCPOP.html")
oHtml   := oProcess:oHtml
 

aadd( oHtml:ValByName("it.CNUM") , cNum )
aadd( oHtml:ValByName("it.COP" ) , cOP  )

_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)
If  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "01" // filial saco 
   //oProcess:cTo := "informatica@ravaembalagens.com.br"  
     oProcess:cTo := GetNewPar("MV_MA650TO","adalberto@ravaembalagens.com.br;diego.santos@ravaembalagens.com.br")
elseIf  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "03" // filial caixa
     oProcess:cTo := GetNewPar("MV_MA650TO","adalberto@ravaembalagens.com.br;diego.santos@ravaembalagens.com.br")
Endif
subj	:= "Requisicao ao Armazem "+cNum 
oProcess:cSubject  := subj
oProcess:Start()
WfSendMail()
oProcess:Finish()

Return 

***************

Static Function fBuscaPrd(cProd)

***************

Local cAlias
Local aArea := getArea()
cAlias := iif( substr( alias(), 1, 4 ) == 'REQX', soma1(alias()), 'REQX1')

cQry:="SELECT G1_QUANT,*  "
cQry+= "FROM   "+retSqlName("SG1")+" SG1 "
cQry+="WHERE G1_COD='"+cProd+"' "
cQry+="AND D_E_L_E_T_<>'*' "
TCQUERY cQry NEW ALIAS (cAlias)

Do While (cAlias)->(!EOF())    
   IF ALLTRIM((cAlias)->G1_COMP) $ GetMV("MV_PRDMAST")
      //Aadd(aPrd,{(cAlias)->G1_COD,(cAlias)->G1_COMP,(cAlias)->G1_QUANT,'M',} )      
      Aadd(aPrd,{(cAlias)->G1_COMP,(cAlias)->G1_QUANT,1,'M',{}}  )
      For _FT:=val(substr( alias(), 5, len(alias())-4 )	) to 2 step -1
          Aadd(aPrd[1][5],{("REQX"+ALLTRIM(STR(_FT)))->G1_COD,("REQX"+ALLTRIM(STR(_FT)))->G1_QUANT,Posicione("SB1",1,xFilial("SB1") + ("REQX"+ALLTRIM(STR(_FT)))->G1_COD , "B1_QB")} )
      Next _FT
      
   Endif
   IF ALLTRIM((cAlias)->G1_COMP) $ GetMV("MV_PRDFITA")
       Aadd(aPrd,{(cAlias)->G1_COMP,(cAlias)->G1_QUANT,1,'F',{}}  )
      //Aadd(aPrd,{(cAlias)->G1_COD,(cAlias)->G1_COMP,(cAlias)->G1_QUANT,'F'} )
   Endif
   
   fBuscaPrd((cAlias)->G1_COMP)
   (cAlias)->(dbskip())
EndDo




(cAlias)->( DbCloseArea() )
restArea( aArea )




Return 



