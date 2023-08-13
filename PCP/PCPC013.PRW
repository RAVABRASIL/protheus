#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

User Function PCPC013()
***********************

Local aCores := {;
{"Z66_PENDEN == 'S'  .and. Z66_INICIO != '*' " , "BR_AMARELO" },;
{"Z66_INICIO == '*'"                           , "BR_VERMELHO"};
}

aRotina := {;
{"Pesquisar"   , "AxPesqui"     , 0, 1},;
{"Incluir"     , "U_CAD_Z66(1)" , 0, 3},;
{"Visualizar"  , "U_CAD_Z66(2)" , 0, 2},;
{"Corrigir"    , "U_CAD_Z66(3)" , 0, 4},;
{"Legenda"     , "U_LegenZ66"   , 0, 6} ;
}

cCadastro := OemToAnsi("Inspecao")
cAlias:='Z66'
DbSelectArea(cAlias)
DbSetOrder(1)
Set filter To (  Z66_PENDEN == 'S'  /* .and. Z66_INICIO == '*' */ )
DbGotop()
mBrowse( 06, 01, 22, 75, cAlias,,,,,,aCores )

Return

***********************
User Function LegenZ66()
***********************

Local aLegenda := {;
{"BR_VERMELHO","Origem da Pendencia"},;
{"BR_AMARELO" ,"Inspeção Pendente"  } ;
}


BrwLegenda("Inspeções","Legenda",aLegenda)

Return .T.









User Function  CAD_Z66(Funcao)
public;
cVisco1	 := cVisco11 :=; // (de ... ate)  1
"0              "
public;
cEncano  :=;             // (Sim <> Nao)  2
cImpC    :=;			 // (Sim <> Nao)  3
cImpB    :=;			 // (Sim <> Nao)  4
cFecha   :=;			 // (Sim <> Nao)  5
cTvinco  :=;			 // (Sim <> Nao)  6
cCorte   :=;			 // (Sim <> Nao)  7
"               "
public;
cPress1  := cPress11 :=; // (de ... ate)  8
cTemp1   := cTemp11  :=; // (de ... ate)  9
cTempo1  := cTempo11 :=; // (de ... ate) 10
"0              "
public;
cAplica  :=;			 // (Sim <> Nao) 11
cLimp    :=;             // (Sim <> Nao) 12
cPacote  :=;			 // (Sim <> Nao) 13
cEtiq    :=;			 // (Sim <> Nao) 14
cPesag   :=;             // (Sim <> Nao) 15
"               "


public   cSupervisor:=alltrim(substr(cUsuario,7,15))
public   cCodSup :=usu(cSupervisor)

public xFuncao:=Funcao
Public aItems:={;
"Sim",;
"Nao";
}


if xFuncao==1
	if  !PERGUNTE ('PCPC012',.T.)
		return
	endif
	MV_PAR01:= UPPER(MV_PAR01)
	MV_PAR02:= UPPER(MV_PAR02)
	cMaq    := MV_PAR01
	cProd   := MV_PAR02
	cQry:=""
	cQry+=" select Z65_ITEM ITEM , Z65_VALOR VALOR, Z65_VALOR2 VALOR2"    + chr(10)
	cQry+=" FROM "+ RetSqlName( "Z65" ) +" Z65 "       + chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                       + chr(10)
	cQry+=" AND Z65_PRODUT="+valtosql(upper(MV_PAR02)) + chr(10)
	cQry+=" AND Z65_MAQ="+valtosql(upper(MV_PAR01)) + chr(10)
	cQry+=" order by Z65_ITEM"                         + chr(10)
	TCQUERY cQry   NEW ALIAS 'AUX1'
	aCampos1:={}
	while !AUX1->(EOF())
		aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
		AUX1->(dbskip())
	enddo
	AUX1->(DBCLOSEAREA())
	if len(aCampos1)==0
		alert('Nao ha cadastro desse produto para essa maquina.')
		return
	endif
endif

/*/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSBox1","oSay1","oGet1","oGrp2","oSBox2","oSay2","oGet2","oGrp3","oSBox3","oSay3")
SetPrvt("oGrp4","oSay16","oSay17","oSay4","oSay5","oGet16","oGet17","oGet4","oGet5","oSBtn1","oSBtn2")

if xFuncao!=3
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	
	aCampos1:={}
	if xFuncao==1
		cQry :=""
		cQry+=" select Z65_ITEM ITEM , 	Z65_VALOR VALOR , Z65_VALOR2 VALOR2"    + chr(10)
		cQry+=" FROM "+ RetSqlName( "Z65" ) +" Z65 "       + chr(10)
		cQry+=" WHERE D_E_L_E_T_=''"                       + chr(10)
		cQry+=" AND Z65_PRODUT="+valtosql(upper(MV_PAR02)) + chr(10)
		cQry+=" AND Z65_MAQ="+valtosql(upper(MV_PAR01)) + chr(10)
		cQry+=" order by Z65_ITEM"                         + chr(10)
		TCQUERY cQry   NEW ALIAS 'AUX1'
		aCampos1:={}
		while !AUX1->(EOF())
			aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
			AUX1->(dbskip())
		enddo
		AUX1->(DBCLOSEAREA())
	else
		cQry :=""
		cQry+=" select Z65_ITEM ITEM , Z65_VALOR VALOR , Z65_VALOR2 VALOR2"    + chr(10)
		cQry+=" FROM "+ RetSqlName( "Z65" ) +" Z65 "       + chr(10)
		cQry+=" WHERE D_E_L_E_T_=''"                       + chr(10)
		cQry+=" AND Z65_PRODUT="+valtosql(Z66->Z66_PRODUT) + chr(10)
		cQry+=" AND Z65_MAQ="+valtosql(Z66->Z66_MAQ) + chr(10)
		cQry+=" order by Z65_ITEM"                         + chr(10)
		TCQUERY cQry   NEW ALIAS 'AUX1'
		aCampos1:={}
		while !AUX1->(EOF())
			aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
			AUX1->(dbskip())
		enddo
		AUX1->(DBCLOSEAREA())
	endif
	
	
	aCampos2:={}
	if xFuncao==1
		
		cQry:="select  Z66_PENDEN PENDEN, Z66_VALOR VALOR, Z66_VALOR2 VALOR2 ,Z66_HORAI HORAI" + chr(10)
		cQry+="  FROM "+ RetSqlName( "Z66" ) +" Z66                          " + chr(10)
		cQry+="  WHERE D_E_L_E_T_=''                                         " + chr(10)
		cQry+="  AND Z66_MAQ="+valtosql(upper(MV_PAR01))                    + chr(10)
		cQry+="  AND Z66_PRODUT="+valtosql(upper(MV_PAR02))                    + chr(10)
		cQry+="  AND Z66_CODIGO = (                                          " + chr(10)
		cQry+="        SELECT top 1 Z66_CODIGO                               " + chr(10)
		cQry+="        FROM "+ RetSqlName( "Z66" ) +" Z66                    " + chr(10)
		cQry+="        WHERE D_E_L_E_T_=''                                   " + chr(10)
		cQry+="		   AND Z66_MAQ="+valtosql(upper(MV_PAR01))              + chr(10)
		cQry+="		   AND Z66_PRODUT="+valtosql(upper(MV_PAR02))              + chr(10)
		cQry+="        AND Z66_INICIO='*'                                    " + chr(10)
		cQry+="        order by Z66_CODIGO desc                              " + chr(10)
		cQry+="              )                                               " + chr(10)
		cQry+=" order by Z66_ITEM"                         + chr(10)
		TCQUERY cQry   NEW ALIAS 'AUX2'
		
		aCampos2:={}
		lInterval:=.T.
		cHrAtual:=/*MV_PAR03*/ TIME()
		dDia:=dtos(ddatabase)
		if !AUX2->(EOF())
			cTempo := ElapTime( HORAI+":00", cHrAtual)
			if val(substr(cTempo,1,2))<2
				alert("Não é permitido incluir uma nova inspeçao no intervalo menor que 2 horas ")
				AUX2->(DBCLOSEAREA())
				return
			endif
		endif
		
		while !AUX2->(EOF())
			aadd(aCampos2,{PENDEN,VALOR,VALOR2,,,,VALOR2,HORAI})
			AUX2->(dbskip())
		enddo
		AUX2->(DBCLOSEAREA())
		
		nHr :=val(substr(cHrAtual,1,2))
		nMin:=val(substr(cHrAtual,4,2))
		nSeg:=val(substr(cHrAtual,7,2))
		cMsg:="A inspeção está atrasada em "
		
		cQry:="select  max(Z66_HORAI) HORAI" + chr(10)
		cQry+="  FROM "+ RetSqlName( "Z66" ) +" Z66                          " + chr(10)
		cQry+="  WHERE D_E_L_E_T_=''                                         " + chr(10)
		cQry+="  AND Z66_HORAI < "+VALTOSQL(substr(cHrAtual,1,5))              + chr(10)
		cQry+="  AND Z66_DATAI = "+VALTOSQL(dDia)
		TCQUERY cQry   NEW ALIAS 'AUX3'
		
		if nHr<13
			nPrz:=0
			if !AUX3->(EOF())
				nHr1:=val(substr(HORAI,1,2))
				if nHr1<=9 .and. nHr1!=0
					
					nPrz:=1
				endif
			endif
			if nHr>9
				if nHr==10 .and. nMin==0  .or. nHr<=0
					nPrz:=1
				endif
				if nPrz==0 .and. nHr>9
					tempo("primeiro Turno","10:00:00",cHrAtual)
				endif
			endif
		else
			nPrz:=0
			if !AUX3->(EOF())
				nHr1:=val(substr(HORAI,1,2))
				if nHr1<=15 .and. nHr1>12 .and. nHr1!=0
					
					nPrz:=1
				endif
			endif
			if nHr>15
				if nHr==16 .and. nMin==0 .or. nHr>23
					nPrz:=1
				endif
				if nPrz==0 .and. nHr>12 .and. nHr<23
					tempo("segundo Turno","16:00:00",cHrAtual)
				endif
			endif
		endif
		
		
		
		
		AUX3->(DBCLOSEAREA())
		
	else
		
		cMaq:=Z66->Z66_MAQ
		cProd:=Z66->Z66_PRODUT
		cQry:="select  Z66_PENDEN PENDEN, Z66_VALOR VALOR, Z66_VALOR2 VALOR2,Z66_CODIGO COD,Z66_MAQ MAQ,Z66_PRODUT PROD,Z66_SUPERI SUPI,Z66_HORAI HORAI"+ chr(10)
		cQry+="FROM "+ RetSqlName( "Z66" ) +" Z66                                        "+ chr(10)
		cQry+="WHERE D_E_L_E_T_=''                                                       "+ chr(10)
		cQry+="  AND Z66_PRODUT ="+valtosql(Z66->Z66_PRODUT)                              + chr(10)
		cQry+="  AND Z66_MAQ ="+valtosql(Z66->Z66_MAQ)                              + chr(10)
		cQry+="  AND Z66_CODIGO ="+valtosql(Z66->Z66_CODIGO)                              + chr(10)
		cQry+=" order by Z66_ITEM"                         + chr(10)
		TCQUERY cQry   NEW ALIAS 'AUX2'
		aCampos2:={}
		while !AUX2->(EOF())
			aadd(aCampos2,{PENDEN,VALOR,COD,MAQ,PROD,SUPI,VALOR2})
			AUX2->(dbskip())
		enddo
		AUX2->(DBCLOSEAREA())
	endif
	
	if xFuncao!=3
		
		
		
	endif
	
	oDlg1   :=  MSDialog():New( 110,327,655,570,"Inspeção de maquina",,,.F.,,,,,,.T.,,,.F. )
	oGrp0   :=  TGroup():New( 004,002,038,120,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1   :=  TSay():New( 011,008,{||"Maquina:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
	oSay1   :=  TSay():New( 011,056,{||"Produto:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	
	
	
	oGetMAQ := TGet():New( 019,008,{|u| If(PCount()>0,cMAQ:=u,cMAQ)  },oGrp0,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cMAQ",,)
	oGetMAQ:bValid:={|| cMAQ:=upper(cMAQ) }
	oGetMAQ:disable()
	
	oGetPROD:= TGet():New( 019,056,{|u| If(PCount()>0,cPROD:=u,cPROD)},oGrp0,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPROD",,)//continuar
	oGetPROD:bValid:={|| cPROD:=upper(cPROD) }
	oGetPROD:disable()
	
	
	
	
	//===================================================================================================
	IF ALLTRIM(cMAQ)==ALLTRIM('DOB')
		oGrp1      := TGroup():New( 042,002,255,120,"Coladeira",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
		nIni:=-20
		aVetor:={}
		
		oFecha:=nil
		nFecha:=0
		aFecha:={}
		lFecha:=.f.
		if len(acampos2)!=0
			lFecha:=acampos2[1,1]=='S'
			cFecha:=iif(lFecha,acampos2[1,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Fechamento",@oSBox1,@oFecha,nFecha,aFecha,@cFecha,lFecha)
		
		if xFuncao ==1
			oSBtn1     := SButton():New( 260,5,1,{|| ;
			TESTE({;
			{cFecha   ,@oFecha   ,"Fechamento" };
			},"DOB",@oDlg1,xFuncao)},oDlg1,,"", )
			oSBtn2     := SButton():New( 260,40,2,{|| oDlg1:end() },oDlg1,,"", )
		endif
		if xFuncao == 2
			oSBtn1     := SButton():New( 260, 5,1,{|| oDlg1:end() },oDlg1,,"", )
		endif
	endif
	
	//===================================================================================================
	IF ALLTRIM(cMAQ)==ALLTRIM('CVP')
		oGrp1      := TGroup():New( 042,002,255,120,"Corte e Vinco",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
		nIni:=-20
		aVetor:={}
		
		oTvinco:=nil
		nTvinco:=0
		aTvinco:={}
		lTvinco:=.f.
		if len(acampos2)!=0
			lTvinco:=acampos2[2,1]=='S'
			cTvinco:=iif(lTvinco,acampos2[2,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Tipo Vinco",@oSBox1,@oTvinco,nTvinco,aTvinco,@cTvinco,lTvinco)
		
		oCorte:=nil
		nCorte:=0
		aCorte:={}
		lCorte:=.f.
		if len(acampos2)!=0
			lCorte:=acampos2[3,1]=='S'
			cCorte:=iif(lCorte,acampos2[3,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Corte",@oSBox1,@oCorte,nCorte,aCorte,@cCorte,lCorte)
		
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
	//===================================================================================================
	IF ALLTRIM(cMAQ)==ALLTRIM('ICVR')
		oGrp1      := TGroup():New( 042,002,255,120,"Impressora",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
		nIni:=-20
		aVetor:={}
		
		oVisco1 :=Nil
		lVisco1:=.f.
		if len(acampos2)!=0
			lVisco1:=acampos2[4,1]=='S'
			cVisco1:=iif(lVisco1,acampos2[4,2],"0              ")
		endif
		Gera_GET(@nINI,xFuncao,'Viscosidade Tinta',@oSBox1,@oVisco1,@cVisco1,lVisco1)
		
		oEncano:=nil
		nEncano:=0
		aEncano:={}
		lEncano:=.f.
		if len(acampos2)!=0
			lEncano:=acampos2[5,1]=='S'
			cEncano:=iif(lEncano,acampos2[5,2],space(15))
		endif
		
		Gera_Sim_NAO(@nINI,xFuncao,"Encanoamento",@oSBox1,@oEncano,nEncano,aEncano,@cEncano,lEncano)
		
		oImpC:=nil
		nImpC:=0
		aImpC:={}
		lImpC:=.f.
		if len(acampos2)!=0
			lImpC:=acampos2[6,1]=='S'
			cImpC:=iif(lImpC,acampos2[6,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Impressao centralizada",@oSBox1,@oImpC,nImpC,aImpC,@cImpC,lImpC)
		
		oImpB:=nil
		nImpB:=0
		aImpB:={}
		lImpB:=.f.
		if len(acampos2)!=0
			lImpB:=acampos2[7,1]=='S'
			cImpB:=iif(lImpB,acampos2[7,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Impressao borrada",@oSBox1,@oImpB,nImpB,aImpB,@cImpB,lImpB)
		
		if xFuncao ==1
			oSBtn1     := SButton():New( 260,5,1,{|| ;
			TESTE({;
			{cVisco1 ,@oVisco1 ,'Viscosidade Tinta '     } ,;
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
	
	//===================================================================================================
	IF ALLTRIM(cMAQ)==ALLTRIM('MONT')
		oGrp1      := TGroup():New( 042,002,255,120,"Montagem",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
		nIni:=-20
		aVetor:={}
		
		oAplica:=nil
		nAplica:=0
		aAplica:={}
		lAplica:=.f.
		if len(acampos2)!=0
			lAplica:=acampos2[8,1]=='S'
			cAplica:=iif(lAplica,acampos2[8,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Aplicação",@oSBox1,@oAplica,nAplica,aAplica,@cAplica,lAplica)
		
		oLimp:=nil
		nLimp:=0
		aLimp:={}
		lLimp:=.f.
		if len(acampos2)!=0
			lLimp:=acampos2[9,1]=='S'
			cLimp:=iif(lLimp,acampos2[9,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Limpeza"  ,@oSBox1,@oLimp  ,nLimp  ,aLimp  ,@cLimp,lLimp)
		
		oPacote:=nil
		nPacote:=0
		aPacote:={}
		lPacote:=.f.
		if len(acampos2)!=0
			lPacote:=acampos2[10,1]=='S'
			cPacote:=iif(lPacote,acampos2[10,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Pacote"   ,@oSBox1,@oPacote,nPacote,aPacote,@cPacote,lPacote)
		
		oEtiq:=nil
		nEtiq:=0
		aEtiq:={}
		lEtiq:=.f.
		if len(acampos2)!=0
			lEtiq:=acampos2[11,1]=='S'
			cEtiq:=iif(lEtiq,acampos2[11,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Etiqueta",@oSBox1,@oEtiq  ,nEtiq  ,aEtiq  ,@cEtiq,lEtiq)
		
		oPesag:=nil
		nPesag:=0
		aPesag:={}
		lPesag:=.f.
		if len(acampos2)!=0
			lPesag:=acampos2[12,1]=='S'
			cPesag:=iif(lPesag,acampos2[12,2],space(15))
		endif
		Gera_Sim_NAO(@nINI,xFuncao,"Pesagem"  ,@oSBox1,@oPesag ,nPesag ,aPesag ,@cPesag,lPesag)
		
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
	
	
	//===================================================================================================
	IF ALLTRIM(cMAQ)==ALLTRIM('SEL')
		oGrp1      := TGroup():New( 042,002,255,120,"Seladora",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSBox1     := TScrollBox():New( oGrp1,052,007,199,107,.T.,.T.,.T. )
		nIni:=-20
		aVetor:={}
		
		oPress1 :=Nil
		lPress1:=.f.
		if len(acampos2)!=0
			lPress1:=acampos2[13,1]=='S'
			cPress1:=iif(lPress1,acampos2[13,2],"0              ")
		endif
		Gera_GET(@nINI,xFuncao,'Pressão',@oSBox1,@oPress1,@cPress1,lPress1)
		
		oTemp1 :=Nil
		lTemp1:=.f.
		if len(acampos2)!=0
			lTemp1:=acampos2[14,1]=='S'
			cTemp1:=iif(lTemp1,acampos2[14,2],"0              ")
		endif
		Gera_GET(@nINI,xFuncao,'Temperatura',@oSBox1,@oTemp1,@cTemp1,lTemp1)
		
		oTempo1 :=Nil
		lTempo1:=.f.
		if len(acampos2)!=0
			lTempo1:=acampos2[15,1]=='S'
			cTempo1:=iif(lTempo1,acampos2[15,2],"0              ")
		endif
		Gera_GET(@nINI,xFuncao,'Tempo',@oSBox1,@oTempo1,@cTempo1,lTempo1)
		
		if xFuncao ==1
			oSBtn1     := SButton():New( 260,5,1,{|| ;
			TESTE({;
			{cPress1 ,@oPress1  ,'Pressão (de) '     } ,;
			{cTemp1  ,@oTemp1   ,'Temperatura (de) ' } ,;
			{cTempo1 ,@oTempo1  ,'Tempo (de) '       }  ;
			},"SEL",@oDlg1,xFuncao )},oDlg1,,"",      )
			
			oSBtn2     := SButton():New( 260,40,2,{|| oDlg1:end() },oDlg1,,"", )
		endif
		if xFuncao == 2
			oSBtn1     := SButton():New( 260,5,1,{|| oDlg1:end() },oDlg1,,"", )
		endif
	endif
	
	
	
	oDlg1:Activate(,,,.T.)
else
	if Z66->Z66_INICIO !='*'
		alert("A correção só está disponível para um item que ORIGINOU a pendência")
		return
	endif
	cObs:=space(100)
	oDlg2      := MSDialog():New( 110,327,600,600,"Correção da Inspeção",,,.F.,,,,,,.T.,,,.F. )
	
	cQry :=""
	cQry+=" select  Z66_PENDEN PENDEN, Z66_VALOR VALOR, Z66_VALOR2 VALOR2, Z66_ITEM ITEM ,Z66_CODIGO COD,Z66_MAQ MAQ,Z66_PRODUT PROD,Z66_SUPERI SUPI,Z66_HORAI HORAI" +chr(10)
	cQry+=" FROM "+ RetSqlName( "Z66" ) +" Z66 "         + chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                         + chr(10)
	cQry+=" AND Z66_PRODUT="+valtosql(Z66->Z66_PRODUT)   + chr(10)
	cQry+=" AND Z66_MAQ="+valtosql(Z66->Z66_MAQ)   + chr(10)
	cQry+="  AND Z66_CODIGO ="+valtosql(Z66->Z66_CODIGO) + chr(10)
	cQry+=" order by Z66_ITEM"                           + chr(10)
	cMaq :=Z66->Z66_MAQ
	cProd:=Z66->Z66_PRODUT
	cItem:=Z66->Z66_ITEM
	
	TCQUERY cQry   NEW ALIAS 'AUX2'
	aCampos2:={}
	while !AUX2->(EOF())
		PswOrder(1)
		aadd(aCampos2,{PENDEN,"",ITEM,VALOR,COD,MAQ,PROD,SUPI,VALOR2})
		AUX2->(dbskip())
	enddo
	AUX2->(DBCLOSEAREA())
	If PswSeek( aCampos2[1,8], .T. )
		aUsua := PSWRET() 						// Retorna vetor com informações do usuário
		cSupervisor := Alltrim(aUsua[1][2])		// Nome do usuário
	Endif
	
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
	oSay0      := TSay():New( ini,45,{|| cMaq        },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	oSay0      := TSay():New( ini,75,{|| "Produto:"  },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,102,{|| cProd      },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	
	ini:=35
	
	
	if alltrim(cMaq)=='DOB'
		oGrp1      := TGroup():New( 25,2,210,135,"Coladeira"    ,oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		Say_S_N(@ini,aItens[1] ,aCampos2[1][4]               ,aCampos2[1][3],aCampos2[1][1])
	endif
	if alltrim(cMaq)=='CVP'
		oGrp1      := TGroup():New( 25,2,210,135,"Corte e Vinco",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		Say_S_N(@ini,aItens[2] ,aCampos2[2][4]               ,aCampos2[2][3],aCampos2[2][1])
		Say_S_N(@ini,aItens[3] ,aCampos2[3][4]               ,aCampos2[3][3],aCampos2[3][1])
	endif
	if alltrim(cMaq)=='ICVR'
		oGrp1      := TGroup():New( 25,2,210,135,"Impressora"   ,oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		Say_(@ini,aItens[4] ,aCampos2[4][4]               ,aCampos2[4][3],aCampos2[4][1])
		Say_S_N(@ini,aItens[5] ,aCampos2[5][4]               ,aCampos2[5][3],aCampos2[5][1])
		Say_S_N(@ini,aItens[6] ,aCampos2[6][4]               ,aCampos2[6][3],aCampos2[6][1])
		Say_S_N(@ini,aItens[7] ,aCampos2[7][4]               ,aCampos2[7][3],aCampos2[7][1])
	endif
	if alltrim(cMaq)=='MONT'
		oGrp1      := TGroup():New( 25,2,210,135,"Montagem"     ,oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		Say_S_N(@ini,aItens[ 8],aCampos2[ 8][4]              ,aCampos2[ 8][3],aCampos2[ 8][1])
		Say_S_N(@ini,aItens[ 9],aCampos2[ 9][4]              ,aCampos2[ 9][3],aCampos2[ 9][1])
		Say_S_N(@ini,aItens[10],aCampos2[10][4]              ,aCampos2[10][3],aCampos2[10][1])
		Say_S_N(@ini,aItens[11],aCampos2[11][4]              ,aCampos2[11][3],aCampos2[11][1])
		Say_S_N(@ini,aItens[12],aCampos2[12][4]              ,aCampos2[12][3],aCampos2[12][1])
	endif
	if alltrim(cMaq)=='SEL'
		oGrp1      := TGroup():New( 25,2,210,135,"Seladora"     ,oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		Say_(@ini,aItens[13]   ,aCampos2[13][4]              ,aCampos2[13][3],aCampos2[13][1])
		Say_(@ini,aItens[14]   ,aCampos2[14][4]              ,aCampos2[14][3],aCampos2[14][1])
		Say_(@ini,aItens[15]   ,aCampos2[15][4]              ,aCampos2[15][3],aCampos2[15][1])
	endif
	
	
	
	
	
	oSay1      := TSay():New( 217.5,2,{|| "Observação:"  },oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oGetObs := TGet():New( 216,32,{|u| If(PCount()>0,cObs:=u,cObs)},oDlg2,104,10,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,.F.,.F.,,'cObs',,)
	
	oSBtn1     := SButton():New( 229  ,2 ,1, {||  corrige(@oGetObs,cObs,@oDlg2,Z66->Z66_MAQ,Z66->Z66_PRODUT,Z66->Z66_ITEM)   },oDlg2,,"", )
	oSBtn2     := SButton():New( 229.2,32,2, {|| Z66->Z66_PENDEN:="S" ,oDlg2:end()},oDlg2,,"", )
	
	oDlg2:Activate(,,,.T.)
	
	
endif
Return



Static Function Usu( cSoli )

***************

local ccod:=''

PswOrder(2)
If PswSeek( cSoli, .T. )
	aUsuarios  := PSWRET()
	ccod       := Alltrim(aUsuarios[1][1])     	// usuário
Endif

return ccod


static function Inconforme(pendente,parametro)

if parametro ==1
	if pendente=="S"
		return CLR_HGRAY
	else
		return CLR_WHITE
	endif
else
	if xFuncao ==2
		return  pendente=='S' .or. !xFuncao==2
	else
		return  pendente=='S'
	endif
endif

RETURN




static function desabilita(obj,pendente)
if xFuncao==2
	obj:disable()
endif
if pendente=="S"
	obj:disable()
	return
endif
return

static function TESTE(avetor,cMaq,oTela,xFuncao)
cMsg:='Confime o campo'

for x:=1 to len(avetor)
	if empty(avetor[x][1])
		alert (cMsg+" "+avetor[x][3])
		avetor[x][2]:SetFocus()
		return
	endif
next

tempo:=ddatabase
tempo:=dtos(tempo)
tempo:=substr(tempo,1,8)
hora:=LEFT(TIME(),5)


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
	cEncano:=cImpC:=cImpB:=cFecha:=cTvinco:=cCorte:=cAplica:=cLimp:=cPacote:=cEtiq:=cPesag:='SIM'
	cVisco1:='0              '
endif

if cMaq=='MONT'
	cEncano:=cImpC:=cImpB:=cFecha:=cTvinco:=cCorte:='SIM'
	cVisco1:=cPress1:=cPress11:=cTemp1:=cTemp11:=cTempo:=cTempo11:='0              '
endif






aValores:={;
{cFecha  ,"CO1"	,0 ,"FECHAMENTO       "},;
{cTvinco ,"CV1"	,0 ,"TIPO VINCO       "},;
{cCorte  ,"CV2"	,0 ,"CORTE            "},;
{cVisco1 ,"IP1"	,1 ,"VISCOSIDADE TINTA"},;
{cEncano ,"IP2"	,0 ,"ENCANOAMENTO     "},;
{cImpC   ,"IP3"	,0 ,"IMP CENTRALIZADA "},;
{cImpB   ,"IP4"	,0 ,"IMP BORRADA      "},;
{cAplica ,"MT1"	,0 ,"APLICACAO        "},;
{cLimp   ,"MT2"	,0 ,"LIMPEZA          "},;
{cPacote ,"MT3"	,0 ,"PACOTE           "},;
{cEtiq   ,"MT4"	,0 ,"ETIQUETA         "},;
{cPesag  ,"MT5"	,0 ,"PESAGEM          "},;
{cPress1 ,"SL1" ,1 ,"PRESSAO          "},;
{cTemp1  ,"SL2"	,1 ,"TEMPERATURA      "},;
{cTempo1 ,"SL3"	,1 ,"TEMPO            "} ;
}
cCod:= GetSx8Num( "Z66", "Z66_CODIGO" ) 
 
FOR nCont:=1 to len(aCampos1)
	cMAq :=upper(MV_PAR01)
	cProdut :=upper(MV_PAR02)
	cItem   :=aValores[nCont][2]
	cItemD  :=aValores[nCont][4]
	nValor1 :=aValores[nCont][1]
	//nValor2 :=""
	nValor2 :=aCampos1[nCont][4]
	nProgra :=aCampos1[nCont][3]
	if aValores[nCont][3]==1
		cPendente:=iif( ;
		transform(val(strtran(alltrim(aValores[nCont][1]),',','.')),"@R 999,999.9")  >=;
		transform(val(strtran(alltrim(aCampos1[nCont][3]),',','.')),"@R 999,999.9");
		.and.;
		transform(val(strtran(alltrim(aValores[nCont][1]),',','.')),"@R 999,999.9")  <=;
		transform(val(strtran(alltrim(aCampos1[nCont][4]),',','.')),"@R 999,999.9");
		,"N","S")
	else
		cPendente:=iif( alltrim(aValores[nCont][1])==alltrim(aCampos1[nCont][3] ),"N","S")
	endif
	cQry := " "
	cQry += " select  Z66_MAQ MAQ ,Z66_PRODUT PROD ,Z66_ITEM ITEM ,Z66_PENDEN PENDEN "    + chr(10)
	cQry += " FROM "+ RetSqlName( "Z66" ) +" Z66 "   + chr(10)
	cQry += " WHERE D_E_L_E_T_ =''"                  + chr(10)
	cQry += " AND Z66_PRODUT   = "+valtosql(cPRODUT) + chr(10)
	cQry += " AND Z66_MAQ   = "+valtosql(cMAq) + chr(10)
	cQry += " AND Z66_ITEM     = "+valtosql(cItem)   + chr(10)
	cQry += " AND Z66_PENDEN   = 'S' "               + chr(10)
	cQry += " AND Z66_INICIO   = '*' "               + chr(10)
	cQry+=" order by Z66_ITEM"                         + chr(10)
	TCQUERY cQry NEW ALIAS 'AUX3'
	
	if (cPendente == 'S') .and. AUX3->(EOF())
		cInicio:='*'
	else
		cInicio:=''
	endif
	
	AUX3->(DBCLOSEAREA())
	
	
	RecLock('Z66',.T.)
	Z66->Z66_FILIAL := xFilial("Z66")
	Z66->Z66_CODIGO := cCod
	Z66->Z66_MAQ    := cMAq
	Z66->Z66_PRODUT := cProdut
	Z66->Z66_ITEM   := cItem
	Z66->Z66_ITEMD  := cItemD
	Z66->Z66_VALOR  := nValor1
	Z66->Z66_VALOR2 := nValor2
	Z66->Z66_PENDEN := cPendente
	
	Z66->Z66_INICIO := cInicio
	Z66->Z66_DATAI  := stod(tempo)
	Z66->Z66_HORAI  := hora
	Z66->Z66_SUPERI := cCodSup

	
	Z66->(MsUnlock())
	
next nCont
CONFIRMSX8()
oTela:end()
 

return


static function corrige(oGetObs,cObs,oObj,MAQ,PROD,IT)

if(empty(cObs))
	alert("Campo observação não foi preenchido.")
	oGetObs:SetFocus()
	return
endif
cSupervisor:=alltrim(substr(cUsuario,7,15))
cCodSup :=usu(cSupervisor)


tempo:=ddatabase
tempo:=dtos(tempo)
tempo:=substr(tempo,1,8)
hora:=LEFT(TIME(),5)

nRecno   := Z66->(RecNo())

DbSelectArea('Z66')
DbSetOrder(2)
while(	DBSEEK(xFilial("Z66")+MAQ+PROD+IT+'S') )
	RecLock('Z66',.F.)
	Z66->Z66_PENDEN :='N'
	Z66->Z66_INICIO :=''
	Z66->Z66_OBS    :=cObs
	Z66->Z66_SUPERC :=cCodSup
	Z66->Z66_DATAC  :=stod(tempo)
	Z66->Z66_HORAC  :=hora
	Z66->(MsUnlock())
enddo
DbSelectArea('Z66')
DbSetOrder(1)
Z66->(dbGoto(nRecno))
oObj:end()
return








Static Function tempo(cTurno,cLimite,cAgora)

cMsg:="Inspeção do "+cTurno
cMsg+=" está atrasada em "
cAtraso:=ElapTime( cLimite,cAgora )
nHr :=val(substr(cAtraso,1,2))
nMin:=val(substr(cAtraso,4,2))

if nHr>0
	cMsg+=alltrim(str(nHr))+" hora"+iif(nHr>1,"s "," ")
endif

if nMin>0
	cMsg+=iif(nHr>0,"e ","")+alltrim(str(nMin))+" minuto"+iif(nMin>1,"s "," ")
endif
if !((nHr==0) .and. (nMin==0))
	alert(cMsg)
endif

return

static function Gera_Sim_NAO(nINI,xFuncao,cDescri,oScroll,oObjCampo,nList,aList,xValor,lPenden)
if xFuncao==2
	lDisable:=.T.
else
	lDisable:=.F.
endif

oSay   := TSay():New( nIni+=20,001,{|| cDescri  }  ,oScroll,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,020 )
if xFuncao == 2
	oObjCampo := TGet():New( nIni+=10,001,{|u| If(PCount()>0,xValor:=u,xValor)},oScroll,090,008,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,  lDisable,.F.,,'xValor',,)
	oObjCampo:bValid:={|| xValor:=upper(xValor) }
else
	oObjCampo:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nList:=u,nList)},aList:=aItems,90,20,oScroll,,,,CLR_BLACK,iif(lPenden,CLR_GRAY,CLR_WHITE),  .T. ,,"",,,,,,, )
	ASize(aList,Len(aList))
	oObjCampo:aItems:=aList
	nPos:=1
	if !(empty(xValor))
		nPos:=iif(substr(xValor,1,1)=='S',1,2)
	endif
	oObjCampo:nAT:=nPos
	oObjCampo:bValid:={|| xValor:=upper(aList[oObjCampo:nAT]) }
	iif(lPenden,oObjCampo:disable(), )
endif
travar(oObjCampo)

if xFuncao==2
	xValor:=U_Z64_SIM_NAO(xValor)
endif
return



static function Gera_GET(nINI,xFuncao,cDescri,oScroll,oObjCampo,xValor,lPenden)
if xFuncao==2
	lDisable:=.T.
else
	lDisable:=.F.
endif

oSay      := TSay():New( nIni+=20,001,{|| cDescri                             },oScroll,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
oObjCampo := TGet():New( nIni+=10,001,{|u| If(PCount()>0,xValor:=u,xValor)    },oScroll,090,008,,,CLR_BLACK,iif(lPenden,CLR_HGRAY,CLR_WHITE),,,,.T.,'',,,.F.,.F.,,lDisable,.F.,,'xValor',,)
travar(oObjCampo)
iif(lPenden,oObjCampo:disable(), )


return



static function  travar(oObj)
if lDisable
	oObj:disable()
endif
return







static function Say_(ini,cDesc,cValor1,xItem,cPenden)
local tab1:=5
local tab2:=60
local tab3:=95
cPenden:=alltrim(cPenden)
lPenden:=iif(cPenden=='S',.T.,.F.)
oSay1   := TSay():New( ini,tab1 , {|| cDesc   } , oGrp1,,,.F.,.F.,.F.,.T.,iif(xItem!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
oSay1   := TSay():New( ini,tab2 , {|| cValor1 } , oGrp1,,,.F.,.F.,.F.,.T.,iif(lPenden,CLR_RED,CLR_GREEN)      ,CLR_WHITE ,070,008)
ini+=10
return

static function Say_S_N(ini,cDesc,cValor,xItem,cPenden)
local tab1:=5
local tab2:=60
cPenden:=alltrim(cPenden)
lPenden:=iif(cPenden=='S',.T.,.F.)
oSay1   := TSay():New( ini,tab1,{|| cDesc                 },oGrp1,,,.F.,.F.,.F.,.T.,iif(xItem!=cItem,CLR_BLACK,CLR_HRED),CLR_WHITE ,050,008)
oSay1   := TSay():New( ini,tab2,{|| SIM_NAO(cValor)       },oGrp1,,,.F.,.F.,.F.,.T.,iif(lPenden,CLR_RED,CLR_GREEN)      ,CLR_WHITE ,070,008)
ini+=10
return

static function SIM_NAO(cCAMPO)
//return iif(substr(cCAMPO,1,1)=='S','CONFORME', iif(substr(cCAMPO,1,1)=='N','NÃO CONFORME',' '))
return iif(substr(cCAMPO,1,1)=='S','SIM', iif(substr(cCAMPO,1,1)=='N','NAO',' '))        
