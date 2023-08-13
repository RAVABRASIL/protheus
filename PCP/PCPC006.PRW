#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

User Function PCPC006()
***********************

Local aCores := {;
{"Z60_PENDEN == 'N'", "BR_VERDE"   },;
{"Z60_PENDEN == 'S'  .and. Z60_INICIO != '*' ", "BR_AMARELO" },;
{"Z60_INICIO == '*'", "BR_VERMELHO"};
}

//public cModoProg:='teste'//'real'

public nAtraso:=0,hora:='00:00',encontrou:=0, cPeriodo:="",aTmp:={},cOperador:=space(6)
aRotina := {;
{"Pesquisar"   , "AxPesqui"     , 0, 1},;
{"Incluir"     , "U_CAD_Z60(1)" , 0, 3},;
{"Visualizar"  , "U_CAD_Z60(2)" , 0, 2},;
{"Corrigir"    , "U_CAD_Z60(3)" , 0, 4},;
{"Legenda"     , "U_LegenZ60"    , 0, 6}}

cCadastro := OemToAnsi("Inspecao")
cAlias:='Z60'
DbSelectArea(cAlias)
DbSetOrder(1)
Set filter To (  Z60_PENDEN == 'S'    )  
DbGotop()
mBrowse( 06, 01, 22, 75, cAlias,,,,,,aCores )

Return

/***********************
User Function LegenZ60()
***********************

Local aLegenda := {;
{"BR_VERDE"   ,"Inspeção Concluida" },;
{"BR_VERMELHO","Origem da Pendencia"},;
{"BR_AMARELO" ,"Inspeção Pendente"  } ;
}


BrwLegenda("Inspeções","Legenda",aLegenda)

Return .T.
*/








User Function  CAD_Z60(Funcao) 
encontrou:=0
public;
cTemp       :=;
cZona1      := cZona11   :=;
cZona2      := cZona22   :=;
cZona3      := cZona33   :=;
cZona4      := cZona44   :=;
cZona5      := cZona55   :=;
cZona6      := cZona66   :=;
cZona7      := cZona77   :=;
cMatriz1    := cMatriz11 :=;
cMatriz2    := cMatriz22 :=;
cMatriz3    := cMatriz33 :=;
cMatriz4    := cMatriz44 :=;
cSlit       :=;
cCircAgua   :=;   
cEspes      := cEspes1:=;
cLinear     := cLinear1  :=;
cGrama      := cGrama1   :=;
cAltura     := cAltura1  :=;
cLargura    := cLargura1 :=;
cAlinha     :=;
cCamera     := cGeladeira:=;
cSensor     :=;
cTratamento :=;
cBobina     :=; 
cHelic	    := cHelic1  :=;
cCalib      := cCalib1  :=;
cFlange     := cFlange1 :=;
cFiltro	    := cFiltro1 :=;
space(15)
public nSlit,nAlinha,nCamera,nGelad,nNeve,nBobi,nTrat,nEdit,nSensor,nFiltro,nFlange,nHelic,nCalib,nCircAgua

public   cSupervisor:=alltrim(substr(cUsuario,7,15))
public   cCodSup :=usu(cSupervisor)

public xFuncao:=Funcao
Public aItems:={;
"Sim",;
"Nao";
}  
 
if xFuncao==1 
    

   dbSelectArea( "SX1" )
   dbSetOrder( 1 )
	   If SX1->(dbSeek( "PCPC006   "+"04" )   )
	     
	     RecLock( "SX1", .F. )  
	        X1_CNT01:=""
	     MsUnlock()
	       
	   Endif  

while .T.
	if  !PERGUNTE ('PCPC006',.T.)
		return
	endif 
	if  alltrim(MV_PAR03)!=""
	//alert(USU_cod2Nome(MV_PAR03) )
		exit
	else
	alert("Campo Extrusor é obrigatório")
	endif
enddo
	MV_PAR01:=UPPER(MV_PAR01)
	MV_PAR02:=UPPER(MV_PAR02)
	cOperador:=Upper(MV_PAR03)
	cQry :=""
	cQry+=" select Z59_ITEM ITEM , Z59_VALOR VALOR, Z59_VALOR2 VALOR2"    + chr(10)
	cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "       + chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                       + chr(10)
	cQry+=" AND Z59_PRODUT="+valtosql(upper(MV_PAR02)) + chr(10)
	cQry+=" AND Z59_EXTRUS="+valtosql(upper(MV_PAR01)) + chr(10)
	cQry+=" order by Z59_ITEM"                         + chr(10)
	TCQUERY cQry   NEW ALIAS 'AUX1'
	aCampos1:={}
	while !AUX1->(EOF())
		aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
		AUX1->(dbskip())
	enddo
	AUX1->(DBCLOSEAREA())
	if len(aCampos1)==0
		alert('Nao ha cadastro desse produto para essa extrusora.')
		return
	endif
endif
 
SetPrvt("oDlg1","oGrp1","oSBox1","oSay1","oGet1","oGrp2","oSBox2","oSay2","oGet2","oGrp3","oSBox3","oSay3")
SetPrvt("oGrp4","oSay16","oSay17","oSay4","oSay5","oGet16","oGet17","oGet4","oGet5","oSBtn1","oSBtn2")

if xFuncao!=3
 
	aCampos1:={}
	if xFuncao==1
		cQry :=""
		cQry+=" select Z59_ITEM ITEM , 	Z59_VALOR VALOR , Z59_VALOR2 VALOR2"    + chr(10)
		cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "       + chr(10)
		cQry+=" WHERE D_E_L_E_T_=''"                       + chr(10)
		cQry+=" AND Z59_PRODUT="+valtosql(upper(MV_PAR02)) + chr(10)
		cQry+=" AND Z59_EXTRUS="+valtosql(upper(MV_PAR01)) + chr(10)
		cQry+=" order by Z59_ITEM"                         + chr(10)
		TCQUERY cQry   NEW ALIAS 'AUX1'
		aCampos1:={}
		while !AUX1->(EOF())
			aadd(aCampos1,{"",ITEM,VALOR,VALOR2})
			AUX1->(dbskip())
		enddo
		AUX1->(DBCLOSEAREA())
	else
		cQry :=""
		cQry+=" select Z59_ITEM ITEM , Z59_VALOR VALOR , Z59_VALOR2 VALOR2"    + chr(10)
		cQry+=" FROM "+ RetSqlName( "Z59" ) +" Z59 "       + chr(10)
		cQry+=" WHERE D_E_L_E_T_=''"                       + chr(10)
		cQry+=" AND Z59_PRODUT="+valtosql(Z60->Z60_PRODUT) + chr(10)
		cQry+=" AND Z59_EXTRUS="+valtosql(Z60->Z60_EXTRUS) + chr(10)
		cQry+=" order by Z59_ITEM"                         + chr(10)
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
	dDia:=dtos(ddatabase)
		cQry:="select  Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2 ,Z60_HORAI HORAI" + chr(10)           
		cQry+="  FROM "+ RetSqlName( "Z60" ) +" Z60                          " + chr(10)
		cQry+="  WHERE D_E_L_E_T_=''                                         " + chr(10)
		cQry+="  AND Z60_EXTRUS="+valtosql(upper(MV_PAR01))                    + chr(10)
		cQry+="  AND Z60_PRODUT="+valtosql(upper(MV_PAR02))                    + chr(10)
        cQry+="  AND Z60_CODIGO = (                                          " + chr(10)
        cQry+="        SELECT top 1 Z60_CODIGO                               " + chr(10)
        cQry+="        FROM "+ RetSqlName( "Z60" ) +" Z60                    " + chr(10)
        cQry+="        WHERE D_E_L_E_T_=''                                   " + chr(10)
        cQry+="		   AND Z60_EXTRUS="+valtosql(upper(MV_PAR01))              + chr(10)
		cQry+="		   AND Z60_PRODUT="+valtosql(upper(MV_PAR02))              + chr(10)
       // cQry+="        AND Z60_INICIO='*'                                    " + chr(10)
        cQry+="        and Z60_DATAI="+valtoSql(dDia)                          + chr(10)
        cQry+="        order by Z60_CODIGO desc                              " + chr(10)
		cQry+="              )                                               " + chr(10)
		cQry+=" order by Z60_ITEM"                         + chr(10)                                                                                          
		TCQUERY cQry   NEW ALIAS 'AUX2'
	                                 
		aCampos2:={} 
		lInterval:=.T.  
	   //	if cModoProg=='teste'               
	        cHrAtual:= left(TIME(),5)//substr(MV_PAR03,1,5) //"00:00:00" */TIME()
	   // else
	   //     cHrAtual:= substr(MV_PAR03,1,5) //"00:00:00" */TIME()
	   // endif     
	        hora:=substr(cHrAtual,1,5)
	     if !AUX2->(EOF())
	       	cTempo := ElapTime( HORAI+":00", cHrAtual+":00") 
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
  /*		   
	        nHr :=val(substr(cHrAtual,1,2))
	        nMin:=val(substr(cHrAtual,4,2))
	        nSeg:=val(substr(cHrAtual,7,2))
	       	cMsg:="A inspeção está atrasada em " 
	       	     
	       	nTmp:=Hms2Seg(cHrAtual)  
  cTxt:="" 
  aTmp:=;
  {;//----- anterior ----|-- Periodo atual-------|- vira dia -| ant |atu|                
  {"20:00","23:59" , "00:00","02:59" ,      .T.   , 6   , 1 },;
  {"00:00","02:59" , "03:00","08:59" ,      .F.   , 1   , 2 },;
  {"03:00","08:59" , "09:00","11:59" ,      .F.   , 2   , 3 },;
  {"09:00","11:59" , "12:00","15:59" ,      .F.   , 3   , 4 },;
  {"12:00","15:59" , "16:00","19:59" ,      .F.   , 4   , 5 },;
  {"16:00","19:59" , "20:00","23:59" ,      .F.   , 5   , 6 };
  }    
  nAtraso:=0
for x:=1 to len(aTmp)
	if nTmp>=Hms2Seg(aTmp[x][3]) .and. nTmp<=Hms2Seg(aTmp[x][4])
		latual   :=query(U_itos(aTmp[x][7]),aTmp[x][3],aTmp[x][4],ddia)	
		dDia2:=dtos(ddatabase-iif(aTmp[x][5],1,0))		
		lanterior:=query(U_itos(aTmp[x][6]),aTmp[x][1],aTmp[x][2],dDia2)
		if  lAnterior .and. lAtual  
		//	alert(" Inspecao extra (sem restrição)" +;
		//	" (nao enviar email)" ;
		//	)
			exit
		elseif !lAnterior .and. lAtual 
	   // alert(;
	   //      " a inspecao anterior("+U_itos(aTmp[x][6])+") nao foi feita <br>"+;
	   //      " Inspecao extra (sem restrição) <br>"+;
	   //      " (nao enviar email)" ;
	   //      )
			exit
		elseif lAnterior .and. !lAtual 
	    // 	alert(;
	    // 	"No prazo para inspeção "+U_itos(aTmp[x][7]) +"<br>"+;
	    // 	" (nao enviar email)";
	    // 	) 
			exit
		else
		  //	alert(;
		  //	      " a inspecao anterior("+U_itos(aTmp[x][6])+") nao foi feita <br>"+;
		  //	      " No prazo para inspeção "+U_itos(aTmp[x][7])+"<br>"+;
		  //	      "(enviar email)" ;
		  //	     ) 
			     nAtraso:=aTmp[x][6]  
			     //cPeriodo:="Periodo ( "+aTmp[x][1]+" Ate  "+aTmp[x][2]+" )"
			exit
		endif
	endif
next

 */

/*  
nAtraso:=0
for x:=1 to len(aTmp)
	if nTmp>=Hms2Seg(aTmp[x][3]) .and. nTmp<=Hms2Seg(aTmp[x][4])
		latual   :=query(U_itos(aTmp[x][7]),aTmp[x][3],aTmp[x][4],ddia)
		
		dDia:=dtos(ddatabase-iif(aTmp[x][5],1,0))
		
		lanterior:=query(U_itos(aTmp[x][6]),aTmp[x][1],aTmp[x][2],ddia)
		if  lAnterior .and. lAtual  
			alert(" Inspecao extra (sem restrição)" )
			exit
		elseif !lAnterior .and. lAtual 
		    alert("No prazo para inspeção "+U_itos(aTmp[x][7]) )
			exit
		elseif lAnterior .and. !lAtual 
		    //alert("(y) No prazo para inspeção "+U_itos(aTmp[x][7]) )
			tempo(U_itos(aTmp[x][6]),aTmp[x][2]+":00",Seg2HMS(nTmp)+":00")
			exit
		else
			//alert(" Atrasado para inspeção "+U_itos(aTmp[x][6]) )
			alert(;
			      " a inspecao anterior("+U_itos(aTmp[x][6])+") nao foi feita <br>"+;
			      " No prazo para inspeção "+U_itos(aTmp[x][7]);
			     )
              nAtraso:=aTmp[x][6] 
			 //tempo(U_itos(aTmp[x][6]),aTmp[x][2]+":00",Seg2HMS(nTmp)+":00") 
			exit
		endif
	endif
next

*/
	       	   	
      
	  
	else
	    
		cQry:="select  Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2,Z60_CODIGO COD,Z60_EXTRUS EXT,Z60_PRODUT PROD,Z60_SUPERI SUPI,Z60_HORAI HORAI"+ chr(10)           
		cQry+="FROM "+ RetSqlName( "Z60" ) +" Z60                                        "+ chr(10)
		cQry+="WHERE D_E_L_E_T_=''                                                       "+ chr(10)
		cQry+="  AND Z60_PRODUT ="+valtosql(Z60->Z60_PRODUT)                              + chr(10)
		cQry+="  AND Z60_EXTRUS ="+valtosql(Z60->Z60_EXTRUS)                              + chr(10)
        cQry+="  AND Z60_CODIGO ="+valtosql(Z60->Z60_CODIGO)                              + chr(10)
		cQry+=" order by Z60_ITEM"                         + chr(10)
		TCQUERY cQry   NEW ALIAS 'AUX2'
		aCampos2:={}
		while !AUX2->(EOF())
			aadd(aCampos2,{PENDEN,VALOR,COD,EXT,PROD,SUPI,VALOR2})
			AUX2->(dbskip())
		enddo
		AUX2->(DBCLOSEAREA())
	endif
	
	if xFuncao!=3

		if(len(aCampos2))!=0
			if(aCampos2[12,1]) =="S" .or. xFuncao==2
				cZona1 :=    aCampos2[12,2]//[ 1,2 ]
				cZona11:=    aCampos2[12,7]//[ 1,7 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[13,1]) =="S"  .or. xFuncao==2
				cMatriz1 := aCampos2[13,2]//[ 2,2 ]
				cMatriz11:= aCampos2[13,7]//[ 2,7 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[14,1]) =="S" .or. xFuncao==2
				cSlit:=      aCampos2[14,2]//[ 3,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[6,1]) =="S"  .or. xFuncao==2
				cLinear:=    aCampos2[6,2]//[ 4,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[7,1]) =="S"  .or. xFuncao==2
				cGrama :=    aCampos2[7,2]//[ 5,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[8,1]) =="S"  .or. xFuncao==2
				cEspes:= aCampos2[8,2]//[ 6,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[9,1]) =="S"  .or. xFuncao==2
				cAltura :=    aCampos2[9,2]//[ 7,2 ]
				cAltura1:=    aCampos2[9,7]//[ 7,7 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[10,1]) =="S"  .or. xFuncao==2
				cLargura :=   aCampos2[10,2]//[ 8,2 ]
				cLargura1:=   aCampos2[10,7]//[ 8,7 ]
			endif                     
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[11,1]) =="S"  .or. xFuncao==2
				cAlinha:=     aCampos2[11,2]//[ 9,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[1,1]) =="S"  .or. xFuncao==2
				cCamera:=     aCampos2[1,2]//[10,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[2,1]) =="S"  .or. xFuncao==2
				cGeladeira:=  aCampos2[2,2]//[11,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[3,1]) =="S"  .or. xFuncao==2
				cSensor:=    aCampos2[3,2]//[12,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[4,1]) =="S"  .or. xFuncao==2
				cTratamento:=aCampos2[4,2]//[13,2 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[5,1]) =="S"  .or. xFuncao==2
				cBobina:=    aCampos2[5,2]//[14,2 ]
			endif
		endif
		//============================================
	   	if(len(aCampos2))!=0
			if(aCampos2[15,1]) =="S"  .or. xFuncao==2
				cZona2 :=    aCampos2[15,2 ]
				cZona22:=    aCampos2[15,7 ]
			endif
		endif
		if(len(aCampos2))!=0
			if(aCampos2[16,1]) =="S"  .or. xFuncao==2
				cZona3 :=    aCampos2[16,2 ]
				cZona33:=    aCampos2[16,7 ]
			endif
		endif
		if(len(aCampos2))!=0
			if(aCampos2[17,1]) =="S"  .or. xFuncao==2
				cZona4 :=    aCampos2[17,2 ] 
				cZona44:=    aCampos2[17,7 ]
			endif
		endif
		if(len(aCampos2))!=0
			if(aCampos2[18,1]) =="S"  .or. xFuncao==2
				cZona5 :=    aCampos2[18,2 ]
				cZona55:=    aCampos2[18,7 ]
			endif
		endif
		if(len(aCampos2))!=0
			if(aCampos2[19,1]) =="S"  .or. xFuncao==2
				cZona6 :=    aCampos2[19,2 ]
				cZona66:=    aCampos2[19,7 ]
			endif
		endif
		if(len(aCampos2))!=0
			if(aCampos2[20,1]) =="S"  .or. xFuncao==2
				cZona7 :=    aCampos2[20,2 ]
				cZona77:=    aCampos2[20,7 ]
			endif
		endif
		
		//============================================
		if(len(aCampos2))!=0
			if(aCampos2[21,1]) =="S"  .or. xFuncao==2
				cMatriz2 := aCampos2[21,2]//[ 2,2 ]
				cMatriz22:= aCampos2[21,7]//[ 2,7 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[22,1]) =="S"  .or. xFuncao==2
				cMatriz3 := aCampos2[22,2]//[ 2,2 ]
				cMatriz33:= aCampos2[22,7]//[ 2,7 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[23,1]) =="S"  .or. xFuncao==2
				cMatriz4 := aCampos2[23,2]//[ 2,2 ]
				cMatriz44:= aCampos2[23,7]//[ 2,7 ]
			endif
		endif
		//========================================
		if(len(aCampos2))!=0
			if(aCampos2[24,1]) =="S"  .or. xFuncao==2
				cCircAgua:=     aCampos2[24,2]//[10,2 ]
			endif
		endif
		if(len(aCampos2))!=0
			if(aCampos2[25,1]) =="S"  .or. xFuncao==2
				cFiltro :=     aCampos2[25,2]//[10,2 ]
			    cFiltro1:=     aCampos2[25,2]//[10,2 ]
			endif
		endif
		if(len(aCampos2))!=0
			if(aCampos2[26,1]) =="S"  .or. xFuncao==2
				cFlange := aCampos2[26,2]//[ 2,2 ]
				cFlange1:= aCampos2[26,7]//[ 2,7 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[27,1]) =="S"  .or. xFuncao==2
				cCalib := aCampos2[27,2]//[ 2,2 ]
				cCalib1:= aCampos2[27,7]//[ 2,7 ]
			endif
		endif
		
		if(len(aCampos2))!=0
			if(aCampos2[28,1]) =="S"  .or. xFuncao==2
				cHelic := aCampos2[28,2]//[ 2,2 ]
				cHelic1:= aCampos2[28,7]//[ 2,7 ]
			endif
		endif
		       
	endif
	oDlg1      := MSDialog():New( 152,327,712,1022,"Inspeção de Extrusora",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 042,002,255,114," Temperatura ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSBox1     := TScrollBox():New( oGrp1,052,007,199,103,.T.,.T.,.T. )
	nIni:=-20
	
	oSay   := TSay():New( nIni +=20,001,{|| 'Zona 1'                                  },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oZona1 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona1:=u,cZona1)          },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[12,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[12,1],2),.F.),.F.,,'cZona1'   ,,)
	iif(len(aCampos2)!=0,    desabilita(@oZona1,aCampos2[12,1]),)
    
     
	oSay   := TSay() :New( nIni -10,050,{|| 'Zona 2'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oZona2 := TGet():New( nIni    ,050,{|u| If(PCount()>0,cZona2:=u,cZona2)         },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[15,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[15,1],2),.F.),.F.,,'cZona2'   ,,)
	iif(len(aCampos2)!=0,  desabilita(@oZona2,aCampos2[15,1]),)
	
	oSay    := TSay():New( nIni +=20,001,{|| 'Zona 3'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oZona3 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona3:=u,cZona3)         },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[16,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[16,1],2),.F.),.F.,,'cZona3'   ,,)
	iif(len(aCampos2)!=0,  desabilita(@oZona3,aCampos2[16,1]),)
	
	oSay    := TSay():New( nIni  -10,050,{|| 'Zona 4'                                },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oZona4 := TGet():New( nIni     ,050,{|u| If(PCount()>0,cZona4:=u,cZona4)        },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[17,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[17,1],2),.F.),.F.,,'cZona4'   ,,)
	iif(len(aCampos2)!=0,  desabilita(@oZona4,aCampos2[17,1]),)
	
	oSay    := TSay():New( nIni +=20,001,{|| 'Zona 5'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oZona5 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona5:=u,cZona5)         },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[18,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[18,1],2),.F.),.F.,,'cZona5'   ,,)
	iif(len(aCampos2)!=0,  desabilita(@oZona5,aCampos2[18,1]),)
	
	oSay    := TSay():New( nIni  -10,050,{|| 'Zona 6'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oZona6 := TGet():New( nIni     ,050,{|u| If(PCount()>0,cZona6:=u,cZona6)         },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[19,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[19,1],2),.F.),.F.,,'cZona6'   ,,)
	iif(len(aCampos2)!=0,  desabilita(@oZona6,aCampos2[19,1]),)
	
	oSay    := TSay():New( nIni +=20,001,{|| 'Zona 7'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oZona7 := TGet():New( nIni +=10,001,{|u| If(PCount()>0,cZona7:=u,cZona7)         },oSBox1,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[20,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[20,1],2),.F.),.F.,,'cZona7'   ,,)
	iif(len(aCampos2)!=0,  desabilita(@oZona7,aCampos2[20,1]),) 	                
	
  
	oSay    := TSay():New( nIni+=20,001,{|| 'Matriz 1'                             },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oMatriz1:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMatriz1:=u,cMatriz1)   },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[13,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[13,1],2),.F.),.F.,,'cMatriz1',,)
	iif(len(aCampos2)!=0,    desabilita(@oMatriz1,aCampos2[13,1]),)
	
	oSay    := TSay():New( nIni  -10,050,{|| 'Matriz 2'                            },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oMatriz2:= TGet():New( nIni    ,050,{|u| If(PCount()>0,cMatriz2:=u,cMatriz2)  },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[21,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[21,1],2),.F.),.F.,,'cMatriz2',,)
	iif(len(aCampos2)!=0,    desabilita(@oMatriz2,aCampos2[21,1]),)
	
	
	oSay    := TSay():New( nIni+=20,001,{|| 'Matriz 3'                             },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oMatriz3:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cMatriz3:=u,cMatriz3)  },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[22,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[22,1],2),.F.),.F.,,'cMatriz3',,)
	iif(len(aCampos2)!=0,    desabilita(@oMatriz3,aCampos2[22,1]),)
	
	
	oSay    := TSay():New( nIni  -10,050,{|| 'Matriz 4'                            },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,30,010 )
	oMatriz4:= TGet():New( nIni    ,050,{|u| If(PCount()>0,cMatriz4:=u,cMatriz4)  },oSBox1,030,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[23,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[23,1],2),.F.),.F.,,'cMatriz4',,)
	iif(len(aCampos2)!=0,    desabilita(@oMatriz4,aCampos2[23,1]),)
	                           
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Temperatura de Filtro'                },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
	oFiltro:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cFiltro:=u,cFiltro)    },oSBox1,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[25,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[25,1],2),.F.),.F.,,'cFiltro'    ,,)
	iif(len(aCampos2)!=0,    desabilita(@oFiltro,aCampos2[25,1]),)
	                                
	oSay   := TSay():New( nIni+=20,001,{|| 'Flange'                               },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
	oFlange:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cFlange:=u,cFlange)    },oSBox1,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[26,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[26,1],2),.F.),.F.,,'cFlange'    ,,)
	iif(len(aCampos2)!=0,    desabilita(@oFlange,aCampos2[26,1]),)
	                                
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Calibrador'                                   },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
	oCalib:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCalib:=u,cCalib)            },oSBox1,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[27,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[27,1],2),.F.),.F.,,'cCalib'    ,,)
	iif(len(aCampos2)!=0,    desabilita(@oCalib,aCampos2[27,1]),)
	                                
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Helicoidal'                                   },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
	oHelic:= TGet():New( nIni+=10,001,{|u| If(PCount()>0,cHelic:=u,cHelic)            },oSBox1,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[28,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[28,1],2),.F.),.F.,,'cHelic'    ,,)
	iif(len(aCampos2)!=0,    desabilita(@oHelic,aCampos2[28,1]),)
	                                
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Conformidade do Slit'                                      },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
	if xFuncao == 2
		oSlit := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSlit:=u,cSlit)          },oSBox1,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[14,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[14,1],2),.F.),.F.,,'cSlit'  ,,)
		oSlit:bValid:={|| cSlit:=upper(cSlit) }
	else
		oSlit:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSlit:=u,nSlit)},aSlit:=aItems,90,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		ASize(aSlit,Len(aSlit))
		oSlit:aItems:=aSlit
		oSlit:nAT:=1
		oSlit:bValid:={|| cSlit:=upper(aItems[oSlit:nAT]) }
	endif 
	iif(len(aCampos2)!=0,    desabilita(@oSlit,aCampos2[14,1]),)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Circulação de Água'                                 },oSBox1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,010 )
	if xFuncao == 2
		oCircAgua := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCircAgua:=u,cCircAgua)          },oSBox1,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[24,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[24,1],2),.F.),.F.,,'cCircAgua'  ,,)
		oCircAgua:bValid:={|| cCircAgua:=upper(cCircAgua) }
	else
		oCircAgua:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCircAgua:=u,nCircAgua)    },aCircAgua:=aItems,90,20,oSBox1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		ASize(aCircAgua,Len(aCircAgua))
		oCircAgua:aItems:=aCircAgua
		oCircAgua:nAT:=1
		oCircAgua:bValid:={|| cCircAgua:=upper(aItems[oCircAgua:nAT]) }
	endif 
	iif(len(aCampos2)!=0,    desabilita(@oCircAgua,aCampos2[24,1]),)
	
	 
	
	
	oGrp2      := TGroup():New( 042,117,255,229," Gravimetro ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSBox2     := TScrollBox():New( oGrp2,052,121,199,103,.T.,.T.,.T. )
	nIni:=0
	
	oSay   := TSay():New( nIni    ,001,{|| 'Linear'                                  },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	oLinear := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cLinear:=u,cLinear)        },oSBox2,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[ 6,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[6,1],2),.F.),.F.,,'cLinear',,)
	iif(len(aCampos2)!=0,    desabilita(@oLinear,aCampos2[6,1]),)
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Grama/Metro'                             },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	oGrama := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cGrama:=u,cGrama)          },oSBox2,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[ 7,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[7,1],2),.F.),.F.,,'cGrama',,)
	iif(len(aCampos2)!=0,    desabilita(@oGrama,aCampos2[7,1]),)
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Espessura do Filme'                      },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	oEspes := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cEspes:=u,cEspes)  },oSBox2,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[ 8,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[8,1],2),.F.),.F.,,'cEspes',,)
	iif(len(aCampos2)!=0,    desabilita(@oEspes,aCampos2[8,1]),)
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Altura do Balao'                         },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	oAltura := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cAltura:=u,cAltura)        },oSBox2,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[ 9,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[9,1],2),.F.),.F.,,'cAltura',,)
	iif(len(aCampos2)!=0,    desabilita(@oAltura,aCampos2[9,1]),)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Largura bobina'                          },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	oLargura := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cLargura:=u,cLargura)      },oSBox2,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[10,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[10,1],2),.F.),.F.,,'cLargura',,)
	iif(len(aCampos2)!=0,    desabilita(@oLargura,aCampos2[10,1]),)
   
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Alinhamento bobina'                      },oSBox2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oAlinha := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cAlinha:=u,cAlinha)    },oSBox2,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[11,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[11,1],2),.F.),.F.,,'cAlinha'  ,,)
		 oAlinha:bValid:={|| cAlinha:=upper(cAlinha) }
	   else
		 oAlinha:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nAlinha:=u,nAlinha) },aAlinha:=aItems,90,20,oSBox2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aAlinha,Len(aAlinha))
		 oAlinha:aItems:=aAlinha
		 oAlinha:nAT:=1
		 oAlinha:bValid:={|| cAlinha:=upper(aItems[oAlinha:nAT]) }
	   endif 
	   iif(len(aCampos2)!=0,    desabilita(@oAlinha,aCampos2[11,1]),)
	
	
	
  oGrp3      := TGroup():New( 042,232,255,344," Ferramenta ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
  oSBox3     := TScrollBox():New( oGrp3,052,236,199,103,.T.,.T.,.T.)
  nIni:=0
	
	oSay   := TSay():New( nIni    ,001,{|| 'Câmera'                                  },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oCamera := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cCamera:=u,cCamera)    },oSBox3,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[1,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[1,1],2),.F.),.F.,,'cCamera'  ,,)
	 	 oCamera:bValid:={|| cCamera:=upper(cCamera) }
	   else
		 oCamera:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nCamera:=u,nCamera) },aCamera:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aCamera,Len(aCamera))
		 oCamera:aItems:=aCamera
		 oCamera:nAT:=1
		 oCamera:bValid:={|| cCamera:=upper(aItems[oCamera:nAT]) }
	   endif 
	   iif(len(aCampos2)!=0,    desabilita(@oCamera,aCampos2[1,1]),)
	
	
	oSay  := TSay():New( nIni+=20,001,{|| 'Geladeira'                               },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	  if xFuncao == 2
	   	oGeladeira:=TGet():New( nIni+=10,001,{|u| If(PCount()>0,cGeladeira:=u,cGeladeira)},oSBox3,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[2,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[2,1],2),.F.),.F.,,'cGeladeira'  ,,)
	 	oGeladeira:bValid:={|| cGeladeira:=upper(cGeladeira) }
	  else
	 	oGeladeira:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nGelad:=u,nGelad)   },aGelad:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	 	ASize(aGelad,Len(aGelad))
	 	oGeladeira:aItems:=aGelad
	  	oGeladeira:nAT:=1
	  	oGeladeira:bValid:={|| cGeladeira:=upper(aItems[oGeladeira:nAT]) }
	  endif 
	  iif(len(aCampos2)!=0,    desabilita(@oGeladeira,aCampos2[2,1]),)                
	
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Sensor Ponto de Neve'                    },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
		if xFuncao == 2
		  oSensor := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cSensor:=u,cSensor)    },oSBox3,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[3,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[3,1],2),.F.),.F.,,'cSensor'  ,,)
		  oSensor:bValid:={|| cSensor:=upper(cSensor) }
	    else
		  oSensor:=TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nSensor:=u,nSensor) },aSensor:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		  ASize(aSensor,Len(aSensor))
		  oSensor:aItems:=aSensor
		  oSensor:nAT:=1
		  oSensor:bValid:={|| cSensor:=upper(aItems[oSensor:nAT]) }
	    endif 
	    iif(len(aCampos2)!=0,    desabilita(@oSensor,aCampos2[3,1]),)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Tratamento'                                   },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oTrat := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cTratamento:=u,cTratamento) },oSBox3,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[4,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[4,1],2),.F.),.F.,,'cTratamento'  ,,)
		 oTrat:bValid:={|| cTratamento:=upper(cTratamento) }
       else
		 oTrat:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nTrat:=u,nTrat)      },aTrat:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aTrat,Len(aTrat))
		 oTrat:aItems:=aTrat
		 oTrat:nAT:=1
		 oTrat:bValid:={|| cTratamento:=upper(aItems[oTrat:nAT]) }
	   endif 
       iif(len(aCampos2)!=0,    desabilita(@oTrat,aCampos2[4,1]),)
	
	
	oSay   := TSay():New( nIni+=20,001,{|| 'Bobinadeira'                                  },oSBox3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,98,010 )
	   if xFuncao == 2
		 oBobina := TGet():New( nIni+=10,001,{|u| If(PCount()>0,cBobina:=u,cBobina)         },oSBox3,090,008,,,CLR_BLACK,iif(len(aCampos2)!=0,inconforme(aCampos2[5,1],1),CLR_WHITE),,,,.T.,'',,,.F.,.F.,,iif(len(aCampos2)!=0,inconforme(aCampos2[5,1],2),.F.),.F.,,'cBobina'  ,,)
		 oBobina:bValid:={|| cBobina:=upper(cBobina) }
	   else
		 oBobina:=	TComboBox():New( nIni+=10,001,{|u| if(Pcount()>0,nBobi:=u,nBobi)      },aBobi:=aItems,90,20,oSBox3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		 ASize(aBobi,Len(aBobi))
		 oBobina:aItems:=aBobi
	 	 oBobina:nAT:=1
	     oBobina:bValid:={|| cBobina:=upper(aItems[oBobina:nAT]) }
	   endif 
       iif(len(aCampos2)!=0,    desabilita(@oBobina,aCampos2[5,1]),)
	
	
	
	if xFuncao==1
		cCod:=GetSx8Num( 'Z60', "Z60_CODIGO" )
	else
		cCod:=aCampos2[1,3]
		MV_PAR01:=aCampos2[1,4]
		MV_PAR02:=aCampos2[1,5]
		PswOrder(1)
		If PswSeek( aCampos2[1,6], .T. )
			aUsua := PSWRET() 						// Retorna vetor com informações do usuário
			cSupervisor := Alltrim(aUsua[1][2])		// Nome do usuário
		Endif
	endif
	oGrp4      := TGroup():New( 004,002,038,344,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay16     := TSay():New( 011,008,{||"Código:"    },oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,008)
	oSay17     := TSay():New( 011,056,{||"Extrusora:" },oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	oSay4      := TSay():New( 011,156,{||"Supervisor:"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay5      := TSay():New( 011,091,{||"Produto:"   },oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	
	oGet1      := TGet():New( 019,008,{|u| If(PCount()>0,cCod:=u,cCod)              },oGrp4,041,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"cCod",,,         )
	oGet2      := TGet():New( 019,056,{|u| If(PCount()>0,MV_PAR01:=u,MV_PAR01)      },oGrp4,030,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","MV_PAR01",,   )
	oGet3      := TGet():New( 019,156,{|u| If(PCount()>0,cSupervisor:=u,cSupervisor)},oGrp4,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSupervisor",,)
	oGet4      := TGet():New( 019,091,{|u| If(PCount()>0,MV_PAR02:=u,MV_PAR02)      },oGrp4,060,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","MV_PAR02",,   )
	oGet1:disable()
	oGet2:disable()
	oGet3:disable()
	oGet4:disable()
	
	if xFuncao==1
	aObj:={;
		@oZona1    ,;//  1
		@oZona2    ,;//  2
		@oZona3    ,;//  3
		@oZona4    ,;//  4
		@oZona5    ,;//  5
		@oZona6    ,;//  6
		@oZona7    ,;//  7
		@oMatriz1  ,;//  8
		@oMatriz2  ,;//  9
		@oMatriz3  ,;// 10
		@oMatriz4  ,;// 11
		@oFiltro   ,;// 12
		@oFlange   ,;// 13
		@oCalib    ,;// 14
		@oHelic    ,;// 15
		@oSlit     ,;// 16
		@oCircAgua ,;// 17
		@oLinear   ,;// 18
		@oGrama    ,;// 19
		@oEspes    ,;// 20
		@oAltura   ,;// 21
		@oLargura  ,;// 22
		@oAlinha   ,;// 23
		@oCamera   ,;// 24
		@oGeladeira,;// 25
		@oSensor   ,;// 26
		@oTrat     ,;// 27
		@oBobina    ;// 28
	}
		oSBtn1     := SButton():New( 260,276,1,{|| grava(@oDlg1,aObj) },oDlg1,,"", )
		oSBtn2     := SButton():New( 260,311,2,{|| oDlg1:end(),RollBackSX8()  },oDlg1,,"", )
	else
		oSBtn2     := SButton():New( 260,311,1,{|| oDlg1:end()  },oDlg1,,"", )
	endif
	
	
	
	oDlg1:Activate(,,,.T.)
else
   //if Z60->Z60_PENDEN=='N'
   	if Z60->Z60_INICIO !='*'
		alert("A correção só está disponível para um item que ORIGINOU a pendência")
		return
	endif
	cObs:=space(100)
	oDlg1      := MSDialog():New( 152,327,620,1020,"Correção da Inspeção",,,.F.,,,,,,.T.,,,.F. )
	

	cQry :=""
	cQry+=" select  Z60_PENDEN PENDEN, Z60_VALOR VALOR, Z60_VALOR2 VALOR2, Z60_ITEM ITEM ,Z60_CODIGO COD,Z60_EXTRUS EXT,Z60_PRODUT PROD,Z60_SUPERI SUPI,Z60_HORAI HORAI" +chr(10)
	cQry+=" FROM "+ RetSqlName( "Z60" ) +" Z60 "         + chr(10)
	cQry+=" WHERE D_E_L_E_T_=''"                         + chr(10)
	cQry+=" AND Z60_PRODUT="+valtosql(Z60->Z60_PRODUT)   + chr(10)
	cQry+=" AND Z60_EXTRUS="+valtosql(Z60->Z60_EXTRUS)   + chr(10)
	cQry+="  AND Z60_CODIGO ="+valtosql(Z60->Z60_CODIGO) + chr(10)
	cQry+=" order by Z60_ITEM"                           + chr(10)

	cItem:=Z60->Z60_ITEM
	
	TCQUERY cQry   NEW ALIAS 'AUX2'
	aCampos2:={}
	while !AUX2->(EOF())
		PswOrder(1)
		aadd(aCampos2,{PENDEN,"",ITEM,VALOR,COD,EXT,PROD,SUPI,VALOR2})
		AUX2->(dbskip())
	enddo
	AUX2->(DBCLOSEAREA())
	If PswSeek( aCampos2[1,8], .T. )
		aUsua := PSWRET() 						// Retorna vetor com informações do usuário
		cSupervisor := Alltrim(aUsua[1][2])		// Nome do usuário
	Endif
	 
	 aItens:={ ;
	'Camera',;              //  1
	'Geladeira',;           //  2
	'Sensor Ponto de Neve',;//  3
	'Tratamento',;          //  4
	'Bobinadeira',;         //  5
	'Linear',;              //  6
	'Grama/Metro',;         //  7
	'Espessura Filme',;     //  8
	'Altura do Balão',;     //  9
	'Largura Bobina',;      // 10
	'Alinhamento Bobina',;  // 11
	'Zona 1',;              // 12
	'Matriz 1',;            // 13
	'Conformidade do Slit',;// 14
	'Zona 2',;              // 15
	'Zona 3',;              // 16
	'Zona 4',;              // 17
	'Zona 5',;              // 18
	'Zona 6',;              // 19
	'Zona 7',;              // 20
	'Matriz 2',;            // 21
	'Matriz 3',;            // 22
	'Matriz 4',;            // 23
	'Circ de Agua',;        // 24
	'Temp de Filtro',;      // 25
	'Flange',;              // 26
	'Calibrador',;          // 27
	'Helicoidal';          // 28
	}
	ini:=10
	tab1:=15
	tab2:=40
	oGrp0      := TGroup():New( 0,10,020,340,"INSPEÇÃO",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay0      := TSay():New( ini,15,{|| "Codigo:"      },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,35,{|| aCampos2[1,5]  },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	oSay0      := TSay():New( ini,75,{|| "Extrusora:"   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,102,{|| aCampos2[1,6] },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	oSay0      := TSay():New( ini,130,{|| "Produto:"    },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,153,{|| aCampos2[1,7] },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	oSay0      := TSay():New( ini,185,{|| "Supervisor:" },oGrp0,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE ,050,008)
	oSay0      := TSay():New( ini,215,{|| cSupervisor   },oGrp0,,,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE ,070,008)
	
	ini:=35
	tab1:=15
	tab2:=70
	oGrp1      := TGroup():New( 25,10,210,105,"TEMPERATURA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	
	  aVetT:={12,15,16,17,18,19,20,13,21,22,23,25,26,27,28,14,24} 
	//for T:=1 to len(aVetT)
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[1]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[1]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[1]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[1]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[2]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[2]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[2]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[2]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[3]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[3]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[3]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[3]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[4]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[4]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[4]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[4]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[5]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[5]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[5]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[5]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[6]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[6]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[6]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[6]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[7]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[7]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[7]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[7]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[8]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[8]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[8]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[8]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[9]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[9]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[9]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[9]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[10]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[10]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[10]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[10]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[11]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[11]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[11]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[11]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[12]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[12]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[12]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[12]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[13]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[13]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[13]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[13]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[14]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[14]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[14]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[14]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[15]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[15]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[15]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[15]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[16]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[16]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[16]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[16]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetT[17]]    },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[17]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetT[17]][4] },oGrp1,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetT[17]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10


	ini:=35
	tab1:=115
	tab2:=180
	oGrp2      := TGroup():New( 25,110,210,205,"GRAVIMETRO",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	aVetG:={6,7,8,9,10,11} 
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetG[1]]    },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[1]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetG[1]][4] },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[1]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetG[2]]    },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[2]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetG[2]][4] },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[2]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetG[3]]    },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[3]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetG[3]][4] },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[3]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetG[4]]    },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[4]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetG[4]][4] },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[4]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetG[5]]    },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[5]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetG[5]][4] },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[5]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetG[6]]    },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[6]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetG[6]][4] },oGrp2,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetG[6]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10



	ini:=35
	tab1:=215
	tab2:=290
	oGrp3      := TGroup():New( 25,210,210,340,"FERRAMENTA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	aVetF:={1,2,3,4,5} 
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[1]]    },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[1]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetF[1]][4] },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[1]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[2]]    },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[2]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetF[2]][4] },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[2]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[3]]    },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[3]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetF[3]][4] },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[3]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[4]]    },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[4]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetF[4]][4] },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[4]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	oSay1      := TSay():New( ini,tab1,{|| aItens  [aVetF[5]]    },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[5]][3]!=cItem,CLR_BLACK,CLR_HRED ),CLR_WHITE ,050,008)
	oSay1      := TSay():New( ini,tab2,{|| aCampos2[aVetF[5]][4] },oGrp3,,,.F.,.F.,.F.,.T.,iif(aCampos2[aVetF[5]][1] =='N',CLR_GREEN,CLR_RED   ),CLR_WHITE ,070,008)
	ini+=10
	
	//next
	
	
	oSay1      := TSay():New( 217.5,10,{|| "Observação:"  },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oGetObs := TGet():New( 217,43,{|u| If(PCount()>0,cObs:=u,cObs)},oDlg1,235,10,,,CLR_BLACK,CLR_WHITE,,,,.T.,'',,,.F.,.F.,,.F.,.F.,,'cObs',,)
	
	oSBtn1     := SButton():New( 217  ,283,1, {||  corrige(@oGetObs,cObs,@oDlg1,Z60->Z60_EXTRUS,Z60->Z60_PRODUT,Z60->Z60_ITEM)   },oDlg1,,"", )
	oSBtn2     := SButton():New( 217.2,313,2,{|| Z60->Z60_PENDEN:="S" ,oDlg1:end()},oDlg1,,"", )
	
	oDlg1:Activate(,,,.T.)
	
	
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

static function Grava(oObj,aObj)

Local aVetor:={;
cZona1     ,;//  1
cZona2     ,;//  2
cZona3     ,;//  3
cZona4     ,;//  4
cZona5     ,;//  5
cZona6     ,;//  6
cZona7     ,;//  7
cMatriz1   ,;//  8
cMatriz2   ,;//  9
cMatriz3   ,;// 10
cMatriz4   ,;// 11
cFiltro    ,;// 12
cFlange    ,;// 13
cCalib     ,;// 14
cHelic     ,;// 15
cSlit      ,;// 16
cCircAgua  ,;// 17
cLinear    ,;// 18
cGrama     ,;// 19
cEspes     ,;// 20
cAltura    ,;// 21
cLargura   ,;// 22
cAlinha    ,;// 23
cCamera    ,;// 24
cGeladeira ,;// 25
cSensor    ,;// 26
cTratamento,;// 27
cBobina     ;// 28
}



Local aMsg  :={;
"Zona 1"               ,;//  1
"Zona 2"               ,;//  2
"Zona 3"               ,;//  3
"Zona 4"               ,;//  4
"Zona 5"               ,;//  5
"Zona 6"               ,;//  6
"Zona 7"               ,;//  7
"Matriz 1"             ,;//  8
"Matriz 2"             ,;//  9
"Matriz 3"             ,;// 10
"Matriz 4"             ,;// 11
"Temperatura de Filtro",;// 12
"Flange"               ,;// 13
"Calibrador"           ,;// 14
"Helicoidal"           ,;// 15
"Conformidade Slit"    ,;// 16
"Circulação de Agua"   ,;// 17
"Linear"               ,;// 18
"Grama/Metro"          ,;// 19
"Espessura"            ,;// 20
"Altura"               ,;// 21
"Largura"              ,;// 22
"Alinhamento"          ,;// 23
"Camera"               ,;// 24
"Geladeira"            ,;// 25
"Sensor Ponto de Neve" ,;// 26
"Tratamento"           ,;// 27
"Bobina"                ;// 28
}
cVazio:=''
cMsg:='Confime o campo'

for x:=1 to len(avetor)
    if alltrim(aVetor[x]) == cVazio
     alert (cMsg+" "+aMsg[x])
     aObj[x]:SetFocus()
	 ObjectMethod( oObj, "Refresh()" )
	 return                          
	endif
next  

tempo:=ddatabase
tempo:=dtos(tempo)
tempo:=substr(tempo,1,8)


aValores:={;
{cCamera    ,"F01",0  ,"CAMERA"               },; // 01 24
{cGeladeira ,"F02",0  ,"GELADEIRA"            },; // 02 25
{cSensor    ,"F03",0  ,"SENSOR PONTO DE NEVE" },; // 03 26
{cTratamento,"F04",0  ,"TRATAMENTO"           },; // 04 27
{cBobina    ,"F05",0  ,"BOBINADEIRA"          },; // 05 28 
{cLinear    ,"G01",1  ,"LINEAR"               },; // 06 18
{cGrama     ,"G02",1  ,"GRAMA/METRO"          },; // 07 19
{cEspes     ,"G03",1  ,"ESPESSURA"            },; // 08 20
{cAltura    ,"G04",1  ,"ALTURA DO BALAO"      },; // 09 21
{cLargura   ,"G05",1  ,"LARGURA DA BOBINA"    },; // 10 22
{cAlinha    ,"G06",0  ,"ALINHAMENTO BOBINA"   },; // 11 23
{cZona1     ,"T01",1  ,"ZONA 1"               },; // 12 01
{cMatriz1   ,"T02",1  ,"MATRIZ 1"             },; // 13 08
{cSlit      ,"T03",0  ,"CONFORMIDADE DO SLIT" },; // 14 16
{cZona2     ,"T04",1  ,"ZONA 2"               },; // 15 02
{cZona3     ,"T05",1  ,"ZONA 3"               },; // 16 03
{cZona4     ,"T06",1  ,"ZONA 4"               },; // 17 04
{cZona5     ,"T07",1  ,"ZONA 5"               },; // 18 05
{cZona6     ,"T08",1  ,"ZONA 6"               },; // 19 06
{cZona7     ,"T09",1  ,"ZONA 7"               },; // 20 07
{cMatriz2   ,"T10",1  ,"MATRIZ 2"             },; // 21 09
{cMatriz3   ,"T11",1  ,"MATRIZ 3"             },; // 22 10
{cMatriz4   ,"T12",1  ,"MATRIZ 4"             },; // 23 11
{cCircAgua  ,"T13",0  ,"CIRCULACAO DE AGUA"   },; // 24 17
{cFiltro    ,"T14",1  ,"TEMP DE FILTRO"       },; // 25 12
{cFlange    ,"T15",1  ,"FLANGE"               },; // 26 13
{cCalib     ,"T16",1  ,"CALIBRADOR"           },; // 27 14
{cHelic     ,"T17",1  ,"HELICOIDAL"           };  // 28 15
}
  
nPenden:=0   
cDetalhe:=""
FOR nCont:=1 to len(aCampos1)
	cExtrus :=upper(MV_PAR01)
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
	cQry += " select  Z60_EXTRUS EXT ,Z60_PRODUT PROD ,Z60_ITEM ITEM ,Z60_PENDEN PENDEN "    + chr(10)
	cQry += " FROM "+ RetSqlName( "Z60" ) +" Z60 "   + chr(10)
	cQry += " WHERE D_E_L_E_T_ =''"                  + chr(10)
	cQry += " AND Z60_PRODUT   = "+valtosql(cPRODUT) + chr(10)
	cQry += " AND Z60_EXTRUS   = "+valtosql(cEXTRUS) + chr(10)
	cQry += " AND Z60_ITEM     = "+valtosql(cItem)   + chr(10)
   	cQry += " AND Z60_PENDEN   = 'S' "               + chr(10)
   	cQry += " AND Z60_INICIO   = '*' "               + chr(10)
   	cQry+=" order by Z60_ITEM"                         + chr(10)
	TCQUERY cQry NEW ALIAS 'AUX3'
	
   if (cPendente == 'S') .and. AUX3->(EOF())
		cInicio:='*'
	else
		cInicio:=''
	endif
  	
	AUX3->(DBCLOSEAREA())
	
	
	RecLock('Z60',.T.)
	Z60->Z60_FILIAL:= xFilial("Z60")
	Z60->Z60_CODIGO:= cCod
	Z60->Z60_EXTRUS:= cExtrus
	Z60->Z60_PRODUT:= cProdut
	Z60->Z60_ITEM  := cItem
	Z60->Z60_ITEMD := cItemD
	Z60->Z60_VALOR := nValor1
	Z60->Z60_VALOR2:= nValor2
	Z60->Z60_PROGRA:= nProgra
	Z60->Z60_PENDEN:= cPendente
	
	Z60->Z60_INICIO:= cInicio
	Z60->Z60_DATAI := stod(tempo)
	Z60->Z60_HORAI := hora
	Z60->Z60_SUPERI:= cCodSup
	
	Z60->Z60_OPERA:= cOperador
	 
		if cPendente == 'S'
	nPenden++ 
	
	if aValores[nCont][3]==1    

	cProg:= "De: ( "+alltrim(aCampos1[nCont][3])+" ) Ate: ( "+alltrim(aCampos1[nCont][4])+" )"
	
	else  
	 cProg:=iif(substr(nValor1,1,1)=='S','NAO','SIM')
	endif
	
	
	 cDetalhe+="<tr><td>"+cItemD+"</td> <td>"+nValor1+"</td>  <td>"+cProg+"</td></tr>" 
	endif
	
	Z60->(MsUnlock())

next nCont 
   /*
	if nAtraso>0
	eMAIL() 
	endif    
	*/
	CONFIRMSX8()
oObj:end()               

if nPenden>=1
	cInicio:=" "
	cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' 
	cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> ' 
	cInicio+='<head> '                                                                     
	cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> ' 
	cInicio+='<title>Untitled Document</title> '                                           
	cInicio+='</head> '                                                                    
	cInicio+='<body> '                                                                     
	cInicio+='<center>'                                                                    
 
	cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> ' 
	cInicio+=' <br>'                                    
 
	cInicio+='<h4>Na inspeçao abaixo fo'+iif(nPenden>1,'ram','i')+' encontrad'+iif(nPenden>1,'os','o')+' divergenci'+iif(nPenden>1,'as','a')+' </h4>'                 
	cInicio+='<table width="100%" border="1"  align="center"  >' 
	cInicio+="<tr><td bgcolor='green'><font color='white'><b> Codigo </b></font></td> <td bgcolor='green'><font color='white'><b> Maquina </b></font></td>  <td bgcolor='green'><font color='white'><b> Produto</b></font></td> </tr>"      
    cInicio+="<tr><td>"+cCod+"</td> <td>"+cExtrus+"</td>  <td>"+cProdut+"</td> </tr>"  
    cInicio+='</table>'                                                                
    cInicio+='<br>Segue abaixo os detalhes.<br>'
 
	cInicio+='<table width="100%" border="1"    align="center"  >' 
	cInicio+="<tr> "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Item     <b></font></td> "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Inspeção <b></font></td> "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Padrão   <b></font></td> "
	cInicio+="</tr>"                                  
	cInicio+=cDetalhe    
    cInicio+='</table>'  
    cInicio+='</center>' 
    cInicio+='</body>'   
    cInicio+='</html>'    
    

    //cEmail   :="rubem@ravaembalagens.com.br" 

    cEmail:="marcelo@ravaembalagens.com.br;"
   // cEmail+="josenilton@ravaembalagens.com.br;"
    cEmail+="marcio@ravaembalagens.com.br"
     
    
    cAssunto := 'Divergencia'+iif(nPenden>1,'s','')+' Check-List extrussora'
    U_SendMailSC(cEmail ,"" , cAssunto, cInicio,"" )
    //ACSendMail(,,,,cEmail,cAssunto,cInicio,)

endif
  
   
return


static function corrige(oGetObs,cObs,oObj,EXT,PROD,IT)

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

nRecno   := Z60->(RecNo())

DbSelectArea('Z60')
DbSetOrder(2) 
while(	DBSEEK(xFilial("Z60")+EXT+PROD+IT+'S') )
		RecLock('Z60',.F.)
		Z60->Z60_PENDEN :='N'
		Z60->Z60_INICIO :=''
		Z60->Z60_OBS    :=cObs
		Z60->Z60_SUPERC :=cCodSup
		Z60->Z60_DATAC  :=stod(tempo)
		Z60->Z60_HORAC  :=hora
		Z60->(MsUnlock())
enddo
DbSelectArea('Z60')
DbSetOrder(1)
Z60->(dbGoto(nRecno))
oObj:end()
return
         



   

Static Function tempo(cTurno,cLimite,cAgora)

cMsg:="Inspeção ( "+cTurno
cMsg+=" ) está atrasada em "
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

return cMsg      


STATIC FUNCTION eMAIL()

	cInicio:=" "
	cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' 
	cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> ' 
	cInicio+='<head> '                                                                     
	cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> ' 
	cInicio+='<title>Untitled Document</title> '                                           
	cInicio+='</head> '                                                                    
	cInicio+='<body> '                                                                     
	cInicio+='<center>'                                                                    
 
	cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> ' 
	cInicio+=' <br>'                                    
 
	cInicio+='<h4> A '+U_itos(nAtraso)+'ª inspeção do dia  '+dtoc(stod(ddia2))+'  não foi realizada. </h4><br>' 
	cInicio+=" Periodo ( "+ aTmp[nAtraso][3] +" ás "+ aTmp[nAtraso][4]+" )."                
   /*
   	cInicio+='<table width="100%" border="1"  align="center"  >' 
	cInicio+="<tr>"
	cInicio+=" <td bgcolor='green'><font color='white'><b> Codigo     </b></font></td> "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Maquina    </b></font></td>  "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Produto    </b></font></td> "
	cInicio+=" <td bgcolor='green'><font color='white'><b> Supervisor </b></font></td> "
	cInicio+="</tr>"      
    cInicio+="<tr>"
    cInicio+=" <td>"+cCod                          +"</td> "
    cInicio+=" <td>"+upper(MV_PAR01)               +"</td> "
    cInicio+=" <td>"+upper(MV_PAR02)               +"</td> "
    cInicio+=" <td>"+alltrim(substr(cUsuario,7,15))+"</td> "
    cInicio+="</tr>"  
    cInicio+='</table>'                                                                
    */ 
    cInicio+='</center>' 
    cInicio+='</body>'   
    cInicio+='</html>'    
    
    
   // cEmail:="marcelo@ravaembalagens.com.br;"
   
    cEmail:="marcelo@ravaembalagens.com.br;"
    cEmail+="rubem@ravaembalagens.com.br"
   
    cAssunto := 'inspecao check-list extrussora( NAO REALIZADA )'
    //ACSendMail(,,,,cEmail,cAssunto,cInicio,)
    U_SendMailSC(cEmail ,"" , cAssunto, cInicio,"" )
    return
       

static function query(cX,ant1,ant2,dDia)
//alert("periodo "+cX+"  "+ant1+"  "+ant2)
cQry:="select top 1 Z60_HORAI HORAI" + chr(10)           
cQry+="  FROM "+ RetSqlName( "Z60" ) +" Z60                          " + chr(10)
cQry+="  WHERE D_E_L_E_T_=''                                         " + chr(10)
cQry+="  AND Z60_HORAI between "+VALTOSQL(ant1)                  + chr(10)
cQry+="                    AND "+VALTOSQL(ant2)                  + chr(10)
cQry+="  AND Z60_DATAI = "+VALTOSQL(dDia)	 
TCQUERY cQry   NEW ALIAS 'AUX3'
lRet:=.F.
while !AUX3->(EOF())
 lRet:=.T.		 
 AUX3->(dbskip())
enddo 	           
 
AUX3->(DBCLOSEAREA())   

return lRet 

static function Hms2Seg(HMS)    
nHr :=val(substr(HMS,1,2))
nMin:=val(substr(HMS,4,2))
//nSeg:=val(substr(HMS,7,2)) 

return ((   (nHr*60) +nMin   )*60)//+nSeg


static function Seg2Hms(Seg)    


nSeg:=seg%60 
nMin:=seg/60
nHr :=int(nMin/60)
nMin:=nMin%60
return strzero(nHr,2)+":"+strzero(nMin,2)//+":"+strzero(nSeg,2) 




user function Itos(nInt)
return alltrim(str(nInt))   


User Function INSPEC_Z60()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "INSPEC_Z60" Tables "Z60"
  sleep( 5000 )
  conOut( "Programa INSPEC_Z60 na emp. 01 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa INSPEC_Z60 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa INSPEC_Z60 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return




static FUNCTION exec() 
PUBLIC  nAtraso:=0
PUBLIC  cHrAtual:= left(TIME(),5)//substr(MV_PAR03,1,5) //"00:00:00" */TIME() 
PUBLIC  dDia:=dtos(ddatabase)    
PUBLIC  nTmp:=Hms2Seg(cHrAtual)  
PUBLIC  aTmp:=;
 {;//----- anterior ----|-- Periodo atual-------|- vira dia -| ant |atu|                
  {"20:00","23:59"      , "00:00","02:59"       ,      .T.   , 6   , 1 },;
  {"00:00","02:59"      , "03:00","08:59"       ,      .F.   , 1   , 2 },;
  {"03:00","08:59"      , "09:00","11:59"       ,      .F.   , 2   , 3 },;
  {"09:00","11:59"      , "12:00","15:59"       ,      .F.   , 3   , 4 },;
  {"12:00","15:59"      , "16:00","19:59"       ,      .F.   , 4   , 5 },;
  {"16:00","19:59"      , "20:00","23:59"       ,      .F.   , 5   , 6 };
  }      
for x:=1 to len(aTmp)
	if nTmp>=Hms2Seg(aTmp[x][3]) .and. nTmp<=Hms2Seg(aTmp[x][4])
	   //	latual   :=query(U_itos(aTmp[x][7]),aTmp[x][3],aTmp[x][4],ddia)	
		dDia2:=dtos(ddatabase-iif(aTmp[x][5],1,0))		
		lanterior:=query(U_itos(aTmp[x][6]),aTmp[x][1],aTmp[x][2],dDia2)
		if !lAnterior //.and. !lAtual 
			     nAtraso:=aTmp[x][6]  
			     cPeriodo:="Periodo ( "+aTmp[x][1]+" Ate  "+aTmp[x][2]+" )"
			     eMAIL()
			exit
		endif
	endif
next
RETURN


user function test_inspc()
exec()

return



                  

static function USU_cod2Nome(cCod)
PswOrder(1)
	If PswSeek( cCod, .T. )
		aUsuarios  := PSWRET()
		cCod := Alltrim(aUsuarios[1][2])// usuário
	Endif
return cCod
