#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

User Function PCPC012()
***********************


aRotina := {;
{"Pesquisar"   , "AxPesqui"     , 0, 1},;
{"Incluir"     , "U_CAD_Z65(1)" , 0, 3},;
{"Visualizar"  , "U_CAD_Z65(2)" , 0, 2},;
{"Editar"      , "U_CAD_Z65(3)" , 0, 4} }

cCadastro := OemToAnsi("Valor Padrão")
cAlias:='Z65'
DbSelectArea(cAlias)
DbSetOrder(1)


            
mBrowse( 06, 01, 22, 75, cAlias,,,,,,{} )

Return




User Function CAD_Z65(Funcao)
public xFuncao:=Funcao

public;
cVisco1  := cVisco11 :=; // (de ... ate)  1
cEncano  :=;             // (Sim <> Nao)  2
cImpC    :=;			 // (Sim <> Nao)  3
cImpB    :=;			 // (Sim <> Nao)  4
cFecha   :=;			 // (Sim <> Nao)  5
cTvinco  :=;			 // (Sim <> Nao)  6
cCorte   :=;			 // (Sim <> Nao)  7
cPress1  := cPress11 :=; // (de ... ate)  8
cTemp1   := cTemp11  :=; // (de ... ate)  9
cTempo1  := cTempo11 :=; // (de ... ate) 10
cAplica  :=;			 // (Sim <> Nao) 11
cLimp    :=;             // (Sim <> Nao) 12
cPacote  :=;			 // (Sim <> Nao) 13
cEtiq    :=;			 // (Sim <> Nao) 14
cPesag   :=;             // (Sim <> Nao) 15
"0              "
//public cEncano:=cImpC:=cImpB:=cFecha:=cTvinco:=cCorte:=cAplica:=cLimp:=cPacote:=cEtiq:=cPesag:=0
public cMAQ:=space(3)
public cPROD:=space(15)
Public nList
lDisable:=.F.
Public aItems:={;
"Sim",;
"Nao";
}
//cSlit:=cAlinha:=cCamera:=cGeladeira:=cSensor:=cTratamento := cBobina:="SIM"
if xFuncao==1
	if  !PERGUNTE ('PCPC012',.T.)
		return
	endif
	MV_PAR01:=UPPER(MV_PAR01)
	MV_PAR02:=UPPER(MV_PAR02) 
	cMAQ:=MV_PAR01
    cPROD:=MV_PAR02
	cQry :=""
	cQry+=" select Z65_ITEM ITEM , Z65_VALOR VALOR, Z65_VALOR2 VALOR2"          +chr(10)
	cQry+=" FROM "+ RetSqlName( "Z65" ) +" Z65 " +chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                 +chr(10)
	cQry+=" AND Z65_PRODUT="+valtosql(upper(MV_PAR02))  +chr(10)
	cQry+=" AND Z65_MAQ="+valtosql(upper(MV_PAR01))  +chr(10)
	cQry+=" order by Z65_ITEM"                         + chr(10)
	TCQUERY cQry   NEW ALIAS 'AUX1'
	aCampos1:={}
	while !AUX1->(EOF())
		aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
		AUX1->(dbskip())
	enddo
	AUX1->(DBCLOSEAREA())
	if len(aCampos1)!=0
		alert('Ja existe prduto cadastrado para essa Maquina.')
		return
	endif
endif



if xFuncao!=3
	if xFuncao!=1
		cQry :=""
		cQry+=" select  Z65_VALOR VALOR,Z65_VALOR2 VALOR2 ,  Z65_ITEM ITEM" +chr(10)
		cQry+=" FROM "+ RetSqlName( "Z65" ) +" Z65 "        +chr(10)
		cQry+=" WHERE D_E_L_E_T_=''"                        +chr(10)
		cQry+=" AND Z65_PRODUT="+valtosql(Z65->Z65_PRODUT)  +chr(10)
		cQry+=" AND Z65_MAQ="+valtosql(Z65->Z65_MAQ)  +chr(10)
		cQry+=" order by Z65_ITEM"                          + chr(10)
		
		TCQUERY cQry   NEW ALIAS 'AUX2'
		aCampos2:={}
		aCampos3:={}
		while !AUX2->(EOF())
			
			aadd(aCampos2,VALOR,ITEM)
			aadd(aCampos3,VALOR2)
			
			AUX2->(dbskip())
		enddo
		AUX2->(DBCLOSEAREA())
		cVisco1  := aCampos2[ 4]
		cVisco11 := aCampos3[ 4]
		 
		cEncano  := aCampos2[ 5]
		cImpC    := aCampos2[ 6]
		cImpB    := aCampos2[ 7]
		cFecha   := aCampos2[ 1]
		cTvinco  := aCampos2[ 2]
		cCorte   := aCampos2[ 3]
	 
		
		 cPress1 := aCampos2[ 13]
		 cPress11:= aCampos3[ 13]
		 
		 cTemp1  := aCampos2[ 14]
		 cTemp11 := aCampos3[ 14]
		 
		 cTempo1  := aCampos2[ 15]
		 cTempo11 := aCampos3[ 15]
 
		 cAplica := aCampos2[ 8]
		 cLimp   := aCampos2[ 9]
		 cPacote := aCampos2[ 10]
		 cEtiq   := aCampos2[ 11]
		 cPesag  := aCampos2[ 12]
		
  
		cMAQ:=Z65->Z65_MAQ
		cPROD:=Z65->Z65_PRODUT
		lDisable:=.T.
	endif                       
	oDlg1      := MSDialog():New( 110,327,655,570,"Valor Padrão",,,.F.,,,,,,.T.,,,.F. )
	
	
	oGrp0      := TGroup():New( 004,002,038,120,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1     := TSay():New( 011,008,{||"Maquina:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
	oSay1     := TSay():New( 011,056,{||"Produto:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	
	

	if xFuncao == 2 .or. xFuncao==3
		oGetEXT := TGet():New( 019,008,{|u| If(PCount()>0,cMAQ:=u,cMAQ)          },oGrp0,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cMAQ" ,, )
		oGetEXT:bValid:={|| cMAQ:=upper(cMAQ) }
	else
		oGetEXT := TGet():New( 019,008,{|u| If(PCount()>0,MV_PAR01:=u,MV_PAR01)  },oGrp0,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","MV_PAR01" ,, )
		oGetEXT:bValid:={|| MV_PAR01:=upper(MV_PAR01) }
	endif
	oGetEXT:disable()
	
	
	
	if xFuncao == 2 .or. xFuncao==3
		oGetPROD:= TGet():New( 019,056,{|u| If(PCount()>0,cPROD:=u,cPROD)},oGrp0,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPROD",,)//continuar
		oGetPROD:bValid:={|| cPROD:=upper(cPROD) }
	else
		oGetPROD:= TGet():New( 019,056,{|u| If(PCount()>0,MV_PAR02:=u,MV_PAR02)},oGrp0,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","MV_PAR02",,)
		oGetPROD:bValid:={|| MV_PAR02:=upper(MV_PAR02) }
	endif
	oGetPROD:disable()
	
	
	
    
	IF ALLTRIM(cMAQ)==ALLTRIM('ICVR')
	 oGrp1      := TGroup():New( 042,002,255,120,"Impressora",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	 oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
	 nIni:=-20
	 aVetor:={} 
     
     oVisco1 :=Nil
     oVisco11:=Nil  
     Gera_DE_ATE(@nINI,xFuncao,'Viscosidade Tinta',@oSBox1,@oVisco1,@oVisco11,@cVisco1,@cVisco11)
	 
	 oEncano:=nil
	 nEncano:=0
	 aEncano:={}
	 Gera_Sim_NAO(@nINI,xFuncao,"Encanoamento",@oSBox1,@oEncano,nEncano,aEncano,@cEncano) 
	 
	 oImpC:=nil
	 nImpC:=0
	 aImpC:={}
	 Gera_Sim_NAO(@nINI,xFuncao,"Impressao centralizada",@oSBox1,@oImpC,nImpC,aImpC,@cImpC)
	 
	 oImpB:=nil
	 nImpB:=0
	 aImpB:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Impressao borrada",@oSBox1,@oImpB,nImpB,aImpB,@cImpB) 
	 //cFecha:=cTvinco:=cCorte:=cAplica:=cLimp:=cPacote:=cEtiq:=cPesag
	 if xFuncao ==1  
	  oSBtn1     := SButton():New( 260,5,1,{|| ;
	  TESTE({;
	 		 {cVisco1 ,@oVisco1 ,'Viscosidade Tinta (de) '} ,;
	 		 {cVisco11,@oVisco11,'Viscosidade Tinta (ate)'} ,;
	 		 {cEncano ,@oEncano ,"Encanoamento"           } ,;
	 	 	 {cImpC   ,@oImpC   ,"Impressao centralizada" } ,;
	 	     {cImpB   ,@oImpB   ,"Impressao borrada"      }  ;
	  	    },"ICVR",@oDlg1,xFuncao)},oDlg1,,"", )
	  oSBtn2     := SButton():New( 260,40,2,{|| oDlg1:end() },oDlg1,,"", )     
	  endif
	  if xFuncao == 2
	  oSBtn1     := SButton():New( 260,5,1,{|| oDlg1:end() },oDlg1,,"", )
	  endif 
    endif  
    
  
  IF ALLTRIM(cMAQ)==ALLTRIM('DOB')
	 oGrp1      := TGroup():New( 042,002,255,120,"Coladeira",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	 oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
	 nIni:=-20
	 aVetor:={} 

	 oFecha:=nil
	 nFecha:=0
	 aFecha:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Fechamento",@oSBox1,@oFecha,nFecha,aFecha,@cFecha) 
	 if xFuncao ==1  
	  oSBtn1     := SButton():New( 260,5,1,{|| ;
	  TESTE({;
	         {cFecha   ,@oFecha   ,"Fechamento" };
	        },"DOB",@oDlg1,xFuncao)},oDlg1,,"", )      
	  oSBtn2     := SButton():New( 260,40,2,{|| oDlg1:end() },oDlg1,,"", )     
	  endif
	  if xFuncao == 2
	  oSBtn1     := SButton():New( 260,5,1,{|| oDlg1:end() },oDlg1,,"", )
	  endif 
    endif 
    
    
    
    
    IF ALLTRIM(cMAQ)==ALLTRIM('CVP')
	 oGrp1      := TGroup():New( 042,002,255,120,"Corte e Vinco",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	 oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
	 nIni:=-20
	 aVetor:={} 

	 oTvinco:=nil
	 nTvinco:=0
	 aTvinco:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Tipo Vinco",@oSBox1,@oTvinco,nTvinco,aTvinco,@cTvinco)
	 
	 oCorte:=nil
	 nCorte:=0
	 aCorte:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Corte",@oSBox1,@oCorte,nCorte,aCorte,@cCorte)
	  
	 if xFuncao ==1  
	  oSBtn1     := SButton():New( 260,5,1,{|| ;
	  TESTE({;
	         {cTvinco  ,@oTvinco  ,"Tipo Vinco"},;
	         {cCorte   ,@oCorte   ,"Corte"     } ;
	        },"CVP",@oDlg1,xFuncao )},oDlg1,,"", )
	        
	  oSBtn2     := SButton():New( 260,40,2,{|| oDlg1:end() },oDlg1,,"", )     
	  endif
	  if xFuncao == 2
	  oSBtn1     := SButton():New( 260,5,1,{|| oDlg1:end() },oDlg1,,"", )
	  endif 
    endif 
   
  
	IF ALLTRIM(cMAQ)==ALLTRIM('SEL')
	 oGrp1      := TGroup():New( 042,002,255,120,"Seladora",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	 oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
	 nIni:=-20
	 aVetor:={} 
     
     oPress1 :=Nil
     oPress11:=Nil  
     Gera_DE_ATE(@nINI,xFuncao,'Pressão',@oSBox1,@oPress1,@oPress11,@cPress1,@cPress11)
     
     oTemp1 :=Nil
     oTemp11:=Nil  
     Gera_DE_ATE(@nINI,xFuncao,'Temperatura',@oSBox1,@oTemp1,@oTemp11,@cTemp1,@cTemp11)
     
     oTempo1 :=Nil
     oTempo11:=Nil  
     Gera_DE_ATE(@nINI,xFuncao,'Tempo',@oSBox1,@oTempo1,@oTempo11,@cTempo1,@cTempo11)

	 if xFuncao ==1  
	  oSBtn1     := SButton():New( 260,5,1,{|| ;
	  TESTE({;
	 		 {cPress1 ,@oPress1  ,'Pressão (de) '     } ,;
	 		 {cPress11,@oPress11 ,'Pressão (ate)'     } ,;
	 		 {cTemp1  ,@oTemp1   ,'Temperatura (de) ' } ,;
	 		 {cTemp11 ,@oTemp11  ,'Temperatura (ate)' } ,;
	 		 {cTempo1 ,@oTempo1  ,'Tempo (de) '       } ,;
	 		 {cTempo11,@oTempo11 ,'Tempo (ate)'       }  ;
	  	    },"SEL",@oDlg1,xFuncao )},oDlg1,,"",      )
	  	    
	  oSBtn2     := SButton():New( 260,40,2,{|| oDlg1:end() },oDlg1,,"", )     
	  endif
	  if xFuncao == 2
	  oSBtn1     := SButton():New( 260,5,1,{|| oDlg1:end() },oDlg1,,"", )
	  endif 
    endif  
    
    IF ALLTRIM(cMAQ)==ALLTRIM('MONT')
	 oGrp1      := TGroup():New( 042,002,255,120,"Montagem",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	 oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
	 nIni:=-20
	 aVetor:={} 

	 oAplica:=nil
	 nAplica:=0
	 aAplica:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Aplicação",@oSBox1,@oAplica,nAplica,aAplica,@cAplica) 
	 
	 oLimp:=nil
	 nLimp:=0
	 aLimp:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Limpeza"  ,@oSBox1,@oLimp  ,nLimp  ,aLimp  ,@cLimp) 
	 
	 oPacote:=nil
	 nPacote:=0
	 aPacote:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Pacote"   ,@oSBox1,@oPacote,nPacote,aPacote,@cPacote) 
	 
	 oEtiq:=nil
	 nEtiq:=0
	 aEtiq:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Etiqueta",@oSBox1,@oEtiq  ,nEtiq  ,aEtiq  ,@cEtiq) 
	 
	 oPesag:=nil
	 nPesag:=0
	 aPesag:={} 
	 Gera_Sim_NAO(@nINI,xFuncao,"Pesagem"  ,@oSBox1,@oPesag ,nPesag ,aPesag ,@cPesag) 
	 
	 if xFuncao ==1  
	  oSBtn1     := SButton():New( 260,5,1,{|| ;
	  TESTE({;
	         {cAplica ,@oAplica ,"Aplicação"},;
	         {cLimp   ,@oLimp   ,"Limpeza"  },;
	         {cPacote ,@oPacote ,"Pacote"   },;
	         {cEtiq   ,@oEtiq   ,"Etiquetas"},;
	         {cPesag  ,@oPesag  ,"Pesagem"  } ;
	        },"MONT",@oDlg1,xFuncao)},oDlg1,,"", )
	  oSBtn2     := SButton():New( 260,40,2,{|| oDlg1:end() },oDlg1,,"", )     
	  endif
	  if xFuncao == 2
	  oSBtn1     := SButton():New( 260,5,1,{|| oDlg1:end() },oDlg1,,"", )
	  endif 
    endif 
    
  
	oDlg1:Activate(,,,.T.)
else
	cMAQ:=Z65->Z65_MAQ
	cPROD:=Z65->Z65_PRODUT
	cItem:=Z65->Z65_ITEM
	
	if alltrim(cMaq)=='ICVR' .and. !(cItem $ 'IP1 IP2 IP3 IP4') 
      alert(;
        'Para essa maquina só é possivel alterar:<br>'+chr(10)+;
        '- Viscosidade Tinta                     <br>'+chr(10)+;
        '- Encanoamento                          <br>'+chr(10)+;
        '- Impressao Centralizada                <br>'+chr(10)+;
        '- Impressao Borrada                     <br>')
      return
	endif 
	
	if alltrim(cMaq)=='DOB' .and. !(cItem $ 'CO1') 
      alert(;
        'Para essa maquina só é possivel alterar:<br>'+chr(10)+;
        '- Fechamento                            <br>')
      return
	endif  
	
	if alltrim(cMaq)=='CVP' .and. !(cItem $ 'CV1 CV2') 
      alert(;
        'Para essa maquina só é possivel alterar:<br>'+chr(10)+;
        '- Tipo vinco                            <br>'+chr(10)+;
        '- Corte                                 <br>')
      return
	endif  
	
	if alltrim(cMaq)=='SEL' .and. !(cItem $ 'SL1 SL2 SL3') 
      alert(;
        'Para essa maquina só é possivel alterar:<br>'+chr(10)+;
        '- Pressão                               <br>'+chr(10)+;
        '- Temperatura                           <br>'+chr(10)+;
        '- Tempo                                 <br>')
      return
	endif
	if alltrim(cMaq)=='MONT' .and. !(cItem $ 'MT1 MT2 MT3 MT4 MT5') 
      alert(;
        'Para essa maquina só é possivel alterar:<br>'+chr(10)+;
        '- Aplicação                             <br>'+chr(10)+;
        '- Limpeza                               <br>'+chr(10)+;
        '- Pacote                                <br>'+chr(10)+;
        '- Etiquetas                             <br>'+chr(10)+;
        '- Pesagem                               <br>')
      return
	endif   
	        
	//-------------------------------------EDIT-----------------------------------------------------
	oDlg2      := MSDialog():New(110,327,600,600,"Ediçao do valor padrão",,,.F.,,,,,,.T.,,,.F. )
	nEdit:=0
 
	cQry :=""
	cQry+=" select  Z65_VALOR VALOR,Z65_VALOR2 VALOR2 ,  Z65_ITEM ITEM , Z65_MAQ MAQ, Z65_PRODUT PROD" +chr(10)
	cQry+=" FROM "+ RetSqlName( "Z65" ) +" Z65 "        +chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                        +chr(10)
	cQry+=" AND Z65_PRODUT="+valtosql(Z65->Z65_PRODUT)  +chr(10)
	cQry+=" AND Z65_MAQ="+valtosql(Z65->Z65_MAQ)  +chr(10)
	cQry+=" order by Z65_ITEM"                         + chr(10)
	TCQUERY cQry   NEW ALIAS 'AUX2'
	
	aCampos2:={}
	while !AUX2->(EOF())
		aadd(aCampos2,{MAQ,PROD,ITEM,VALOR,VALOR2})
		
		AUX2->(dbskip())
	enddo
	AUX2->(DBCLOSEAREA())
	
	
	aItens:={;
	"Fechamento"       ,;// 5    1
	;
	"Tipo Vinco"       ,;// 6    2
	"Corte"            ,;// 7    3
	;
	"Viscosidade Tinta",;// 1    4
	"Encanoamento"     ,;// 2    5
	"Imp Centralizada" ,;// 3    6
	"Imp Borrada"      ,;// 4    7
	;
	"Aplicacao"        ,;//11    8
	"Limpeza "         ,;//12    9
	"Pacote"           ,;//13   10
	"Etiqueta"         ,;//14   11
	"Pesagem"          ,;//15   12
	;
	"Pressao"          ,;// 8   13
	"Temperatura"      ,;// 9   14
	"Tempo"             ;//10   15
 	}
	
	ini:=10
	tab1:=15
	tab2:=40
	oGrp0      := TGroup():New( 0,2,020,135,"INSPEÇÃO",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay0      := TSay():New( ini,15,{|| "Maquina:"  },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,45,{|| aCampos2[1,1] },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	oSay0      := TSay():New( ini,75,{|| "Produto:"    },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,102,{|| aCampos2[1,2]},oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	
	ini:=35 
	if alltrim(cMaq)=='ICVR'
	oGrp1      := TGroup():New( 25,2,210,135,"Impressora"   ,oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	Say_de_ate(@ini,aItens[4],aCampos2[4][4],aCampos2[4][5],aCampos2[4][3]) 
	   Say_S_N(@ini,aItens[5],aCampos2[5][4]               ,aCampos2[5][3])   	              
	   Say_S_N(@ini,aItens[6],aCampos2[6][4]               ,aCampos2[6][3])
	   Say_S_N(@ini,aItens[7],aCampos2[7][4]               ,aCampos2[7][3])
	endif
	
	if alltrim(cMaq)=='DOB'  
	oGrp1      := TGroup():New( 25,2,210,135,"Coladeira",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	   Say_S_N(@ini,aItens[1],aCampos2[1][4]               ,aCampos2[1][3])
	endif
	
	
	if alltrim(cMaq)=='CVP'  
	oGrp1      := TGroup():New( 25,2,210,135,"Corte e Vinco",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	   Say_S_N(@ini,aItens[2],aCampos2[2][4]               ,aCampos2[2][3])
	   Say_S_N(@ini,aItens[3],aCampos2[3][4]               ,aCampos2[3][3])
	endif
	if alltrim(cMaq)=='SEL'
	oGrp1      := TGroup():New( 25,2,210,135,"Seladora",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	   Say_de_ate(@ini,aItens[13],aCampos2[13][4],aCampos2[13][5],aCampos2[13][3])
	   Say_de_ate(@ini,aItens[14],aCampos2[14][4],aCampos2[14][5],aCampos2[14][3])
	   Say_de_ate(@ini,aItens[15],aCampos2[15][4],aCampos2[15][5],aCampos2[15][3]) 
	endif
    
    if alltrim(cMaq)=='MONT'  
	oGrp1      := TGroup():New( 25,2,210,135,"Montagem",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	   Say_S_N(@ini,aItens[ 8],aCampos2[ 8][4]               ,aCampos2[ 8][3])
	   Say_S_N(@ini,aItens[ 9],aCampos2[ 9][4]               ,aCampos2[ 9][3])
	   Say_S_N(@ini,aItens[10],aCampos2[10][4]               ,aCampos2[10][3])
	   Say_S_N(@ini,aItens[11],aCampos2[11][4]               ,aCampos2[11][3])
	   Say_S_N(@ini,aItens[12],aCampos2[12][4]               ,aCampos2[12][3])
	endif
	
	cEdit:=cEdit2:=space(15)
	oSay1      := TSay():New( 217.5,2,{|| "Editar:"  },oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
    
   nLinhaEdit:=217 
	if cItem $ 'IP2 IP3 IP4 CO1 CV1 CV2 MT1 MT2 MT3 MT4 MT5'
		nTipo:=1  
		oGetEDIT2:=0
		oGetEDIT:=	TComboBox():New(nLinhaEdit,20,{|u| if(Pcount()>0,nEdit:=u,nEdit)},aEdit:=aItems,90,20,oDlg2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		ASize(aEdit,Len(aEdit))
		oGetEDIT:aItems:=aEdit
		oGetEDIT:nAT:=1  
		
		oGetEDIT:bValid:={|| cEdit:=upper(aItems[oGetEDIT:nAT]) }
	elseif cItem $ 'IP1 SL1 SL2 SL3'
		ntipo:=2
		oSay     := TSay():New( nLinhaEdit,20,{|| 'De:'                            } ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
		oGetEDIT := TGet():New( nLinhaEdit,30,{|u| If(PCount()>0,cEdit:=u,cEdit    )},oDlg2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEdit'   ,,)
		oGetEDIT:bValid:={|| cEdit:=upper(cEdit) }
		oSay     := TSay():New( nLinhaEdit,70, {|| 'Ate:'                          } ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
		oGetEDIT2:= TGet():New( nLinhaEdit,80,{|u| If(PCount()>0,cEdit2:=u,cEdit2 )},oDlg2,035,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'cEdit2'   ,,)
		oGetEDIT2:bValid:={|| cEdit2:=upper(cEdit2) }
	else
		nTipo:=1
		oGetEDIT  := TGet():New( nLinhaEdit,20,{|u| If(PCount()>0,cEdit:=u,cEdit)  },oDlg2,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,.F.,.F.,,'cEdit',,)
		oGetEDIT2:=0
		cEdit2:=""
	endif
	oSBtn1     := SButton():New( nLinhaEdit+12    ,2 ,1, {||  Edit(cEdit,cEdit2,@oDlg2,nTipo,@oGetEDIT,@oGetEDIT2)   },oDlg2,,"", )
	oSBtn2     := SButton():New( nLinhaEdit+0.2+12,32,2, {||  oDlg2:end()                       },oDlg2,,"", )
	
	oDlg2:Activate(,,,.T.)
	
	
endif
Return

static function TESTE(avetor,cMaq,oTela,xFuncao)
  cMsg:='Confime o campo'
     
  for x:=1 to len(avetor)
	if empty(avetor[x][1])
		alert (cMsg+" "+avetor[x][3])
		avetor[x][2]:SetFocus() 
		return
	endif 
next
if cMaq=='ICVR' 
 cFecha:=cTvinco:=cCorte:=cAplica:=cLimp:=cPacote:=cEtiq:=cPesag:='SIM'
 cPress1:=cPress11:=cTemp1:=cTemp11:=cTempo:=cTempo11:='0              '
endif 
if cMaq=='DOB'
cEncano:=cImpC:=cImpB:=cTvinco:=cCorte:=cAplica:=cLimp:=cPacote:=cEtiq:=cPesag:='SIM'
cVisco1:=cPress1:=cPress11:=cTemp1:=cTemp11:=cTempo:=cTempo11:='0              '
endif 
if cMaq=='CVP'
cEncano:=cImpC:=cImpB:=cFecha:=cAplica:=cLimp:=cPacote:=cEtiq:=cPesag:='SIM'
cVisco1:=cPress1:=cPress11:=cTemp1:=cTemp11:=cTempo:=cTempo11:='0              '
endif 
 if cMaq=='SEL'
   if val(cPress1)>val(cPress11)
      oPress1:SetFocus() 
      alert('Pressão (de) nao pode ser MAIOR que Pressão (ate)')
      return
   endif 
   if val(cTemp1)>val(cTemp11)
      oTemp1:SetFocus() 
      alert('Temperatura (de) nao pode ser MAIOR que Temperatura (ate)')
      return
   endif 
   if val(cTempo1)>val(cTempo11)
      oTempo1:SetFocus() 
      alert('Tempo (de) nao pode ser MAIOR que Tempo (ate)')
      return
   endif  
   cEncano:=cImpC:=cImpB:=cFecha:=cTvinco:=cCorte:=cAplica:=cLimp:=cPacote:=cEtiq:=cPesag:='SIM'
   cVisco1:='0              '
 endif
 if cMaq=='MONT'
    cEncano:=cImpC:=cImpB:=cFecha:=cTvinco:=cCorte:='SIM'
    cVisco1:=cPress1:=cPress11:=cTemp1:=cTemp11:=cTempo:=cTempo11:='0              '
 endif  
aValores:={;
{cVisco1 ,"IP1",cVisco11,"VISCOSIDADE TINTA " },;
{cEncano ,"IP2",""      ,"ENCANOAMENTO      " },;
{cImpC   ,"IP3",""      ,"IMP CENTRALIZADA  " },;
{cImpB   ,"IP4",""      ,"IMP BORRADA       " },;
;
{cFecha  ,"CO1",""      ,"FECHAMENTO        " },;
;
{cTvinco ,"CV1",""      ,"TIPO VINCO        " },;
{cCorte  ,"CV2",""      ,"CORTE             " },;
;
{cPress1 ,"SL1",cPress11,"PRESSAO           " },;
{cTemp1  ,"SL2",cTemp11 ,"TEMPERATURA       " },;
{cTempo1 ,"SL3",cTempo11,"TEMPO             " },;
;
{cAplica ,"MT1",""      ,"APLICACAO         " },;
{cLimp   ,"MT2",""      ,"LIMPEZA           " },;
{cPacote ,"MT3",""      ,"PACOTE            " },;
{cEtiq   ,"MT4",""      ,"ETIQUETA          " },;
{cPesag  ,"MT5",""      ,"PESAGEM           " } ;
}

FOR nCont:=1 to len(aValores)
	RecLock('Z65',.T.)
	Z65->Z65_FILIAL:=xFilial("Z65")
	Z65->Z65_MAQ:=upper(MV_PAR01)
	Z65->Z65_PRODUT:=upper(MV_PAR02)
	
	Z65->Z65_ITEM :=aValores[nCont][2]
	Z65->Z65_ITEMD:=aValores[nCont][4]
	
	Z65->Z65_VALOR :=aValores[nCont][1]
	Z65->Z65_VALOR2:=aValores[nCont][3]
	
	Z65->(MsUnlock())
 
next nCont 

nX:=1
oTela:end()
return

  
     
  



 


static function  travar(oObj)
if lDisable
	oObj:disable()
endif
return





static function Edit(cEdit,cEdit2,oObj,nTipo,oGetEDIT,oGetEDIT2)

if(empty(cEdit))
	alert("Campo de edição não foi preenchido.")
	oGetEDIT:SetFocus()
	return
endif
if nTipo == 2
	if(empty(cEdit2))
		alert("Segundo Campo de edição não foi preenchido.")
		oGetEDIT2:SetFocus()
		return
	endif
	if  val(cEdit)>val(cEdit2)
	    alert('Valor (de) nao pode ser MAIOR que Valor (ate)')
		oGetEDIT:SetFocus()
		return
	endif
endif

RecLock('Z65',.F.)
Z65->Z65_VALOR:=cEdit
Z65->Z65_VALOR2:=cEdit2
Z65->(MsUnlock())
oObj:end()


return




static function	Gera_DE_ATE(nINI,xFuncao,cDescri,oScroll,oObjCampo1,oObjCampo2,xValor1,xValor2)
     if xFuncao==2
lDisable:=.T.
else
lDisable:=.F.
endif
     oSay   := TSay():New( nIni+=20,001,    {|| cDescri                             }  ,oScroll,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,70,010 )
	   oSay   := TSay():New( nIni+=10,001,{|| 'De:'                            }  ,oScroll,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oObjCampo1 := TGet():New( nIni    ,0010,{|u| If(PCount()>0,xValor1:=u,xValor1  )}  ,oScroll,030,008, ,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'xValor1'   ,,)
	   oObjCampo1:bValid:={|| xValor1:= xValor1  }
	   travar(oObjCampo1)
	   
	   
	    
	 
	   oSay   := TSay():New( nIni,045,{|| 'Ate:'                               }  ,oScroll,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,010 )
	   oObjCampo2:= TGet():New( nIni,055,{|u| If(PCount()>0,xValor2:=u,xValor2    ) }  ,oScroll,030,008, ,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'xValor2'   ,,)
	   oObjCampo2:bValid:={|| xValor2:= xValor2  }
	   travar(oObjCampo2)


static function Gera_Sim_NAO(nINI,xFuncao,cDescri,oScroll,oObjCampo,nList,aList,xValor)
if xFuncao==2
lDisable:=.T.
else
lDisable:=.F.
endif
     
     oSay   := TSay():New( nIni+=20,001,{|| cDescri  }  ,oScroll,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
	   if xFuncao == 2 
		 oObjCampo := TGet():New( nIni+=10,001,{|u| If(PCount()>0,xValor:=u,xValor)},oScroll,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'xValor',,)
		 oObjCampo:bValid:={|| xValor:=upper(xValor) }
	   else
		 oObjCampo:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nList:=u,nList)},aList:=aItems,90,20,oScroll,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aList,Len(aList))
		 oObjCampo:aItems:=aList
		 nPos:=1
		 if (xFuncao == 3)
		  nPos:=iif(substr(xValor,1,1)=='S',1,2)
		 endif
		 oObjCampo:nAT:=nPos
		 oObjCampo:bValid:={|| xValor:=upper(aList[oObjCampo:nAT]) }
	   endif
	   travar(oObjCampo)  
	   
	   if xFuncao==2
	   xValor:=U_Z64_SIM_NAO(xValor) 
	   endif
return
 
user function Z64_SIM_NAO(cCAMPO) 
return iif(substr(cCAMPO,1,1)=='S','SIM', iif(substr(cCAMPO,1,1)=='N','NAO',' ')) 

static function SIM_NAO(cCAMPO) 
//return iif(substr(cCAMPO,1,1)=='S','CONFORME', iif(substr(cCAMPO,1,1)=='N','NÃO CONFORME',' ')) 
return iif(substr(cCAMPO,1,1)=='S','SIM', iif(substr(cCAMPO,1,1)=='N','NAO',' '))           

user function Z64_DE_ATE(nCAMPO1,nCAMPO2) 
if nCAMPO1==nCAMPO2
return ALLTRIM(STR(nCAMPO1))
else 
return ALLTRIM(STR(nCAMPO1)) + ' ATE  ' +ALLTRIM(STR(nCAMPO2))
endif      


static function Say_de_ate(ini,cDesc,cValor1,cValor2,xItem) 
local tab1:=5
local tab2:=60
local tab3:=95
	oSay1   := TSay():New( ini,tab1 , {|| cDesc          },oGrp1,,,.F.,.F.,.F.,.T.,iif(xItem!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	oSay1   := TSay():New( ini,tab2 , {|| "De: "+cValor1 },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN                           ,CLR_WHITE ,070,008)
	oSay1   := TSay():New( ini,tab3 , {|| "Ate:"+cValor2 },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN                           ,CLR_WHITE ,070,008)
	ini+=10 
return     

static function Say_S_N(ini,cDesc,cValor,xItem) 
local tab1:=5
local tab2:=60	   
	oSay1   := TSay():New( ini,tab1,{|| cDesc                 },oGrp1,,,.F.,.F.,.F.,.T.,iif(xItem!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
	oSay1   := TSay():New( ini,tab2,{|| SIM_NAO(cValor)       },oGrp1,,,.F.,.F.,.F.,.T.,CLR_GREEN                           ,CLR_WHITE ,070,008)
	ini+=10     
return     




User function Z65_Virt(cMaquina,cItVirtual,cValor_1,cValor_2)

cMsg:=''
 
 if     cItVirtual $ 'CV1 CV2 MT1 MT4 MT4 MT5'
     if substr(cValor_1,1,1)=='S'
      cMsg:= 'Sim'//'Conforme'
     else
      cMsg:= 'Não'//'Não Conforme'
     endif
 elseif cItVirtual $ 'IP2 IP3 IP4 CO1 MT3'
 if substr(cValor_1,1,1)=='S'
      cMsg:= 'Sim'//
     else
      cMsg:= 'Não'//
     endif
 elseif cItVirtual $ 'MT2'
if substr(cValor_1,1,1)=='S'
      cMsg:= 'Sim'//'Conforme'
     else
      cMsg:= 'Não'//'Excesso'
     endif
 elseif cItVirtual $ 'IP1 SL1 SL2 SL3'
   if val(cValor_1)==val(cValor_2)
      cMsg:= cValor_1
   else
   cMsg:= 'De  '+alltrim(cValor_1)+'  Ate  '+alltrim(cValor_2)
   endif
else

endif 
	if alltrim(cMaquina)=='ICVR' .and. !(cItVirtual $ 'IP1 IP2 IP3 IP4'     )
      cMsg:=' '
	endif
	if alltrim(cMaquina)=='DOB'  .and. !(cItVirtual $ 'CO1'                 )
      cMsg:=' '
	endif
	if alltrim(cMaquina)=='CVP'  .and. !(cItVirtual $ 'CV1 CV2'             )
      cMsg:=' '
	endif
	if alltrim(cMaquina)=='SEL'  .and. !(cItVirtual $ 'SL1 SL2 SL3'         )
      cMsg:=' '
	endif
	if alltrim(cMaquina)=='MONT' .and. !(cItVirtual $ 'MT1 MT2 MT3 MT4 MT5' )
      cMsg:=' '
	endif
    
return cMsg