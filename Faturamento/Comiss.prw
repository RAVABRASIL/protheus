#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMISS    ºAutor  ³Eurivan Marques     º Data ³  15/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³GAtilho para atualizacao do valor da Comissao do Representanº±±
±±º          ³te 10% 1o Compra; 08% 2o Compra; 6% 3o Compra               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


// alterado em 07/12/2009 

**********************************
User Function Comiss(cEdital,nOpc)
**********************************
local nComisSup:=0
public nComisN := 0

if alltrim(upper(FunName())) == "ESTC005"
   return .T.
Endif

If M->C5_TIPO=='D'
   M->C5_VEND1:='0018'  // Rava
   nComisN:=0
   M->C5_COMIS1:=0
   return .T.
EndIF

DbselectArea("SA1")  // Clientes
DbSetoRder(1)
DbSeek(xFilial("SA1")+M->C5_CLIENTE)
	
If ALLTRIM(SA1->A1_VEND) $ '0018/0018VD' // RAVA
   M->C5_VEND1:='0018'  // Rava
   nComisN:=0
   M->C5_COMIS1:=0
   M->C5_INDIC1:=0
   //
   M->C5_COMIS2:=0  
   M->C5_INDIC2:=0      
   Return .T.
EndIf

DbselectArea("SA3") // Vendendores
DbSetoRder(1)

if  nOpc==1
	IF  DbSeek(xFilial("SA3")+SA1->A1_VEND)		
		DbSelectArea("Z17")
		DbSetOrder(1)		
	    If Z17->(DbSeek(xFilial("Z17")+cEdital))
		   nComisN:=SA3->A3_COMIS
	       M->C5_COMIS1:=SA3->A3_COMIS
	       M->C5_INDIC1:=SA3->A3_COMIS
		   AreaLicita(Z17->Z17_MODALI,Z17->Z17_CODIGO,SA1->A1_EST,SA3->A3_GERASE2,SA1->A1_COD_MUN)	 
		   //Coord. de Vendas 
	       if !empty(SA3->A3_SUPER)		    
	          nComisSup:=posicione('SA3', 1, xFilial('SA3')+ SA3->A3_SUPER , 'A3_COMIS') 
	          M->C5_VEND2:= SA3->A3_COD
	          M->C5_COMIS2:=nComisSup
	          M->C5_INDIC2:=nComisSup
           else
               Alert("Favor associar o supervisor no cadastro de Representantes.")
               return  .F.
           endif     
	    EndIf  
    Else	
	   alert("Por favor associar vendedor ao Cadastro de Cliente." )
	   Return .F.    
    EndIF
Endif

If  Nopc==2    
	IF DbSeek(xFilial("SA3")+SA1->A1_VEND)
	   M->C5_VEND1:= SA3->A3_COD  // Indica o vendedor no Pedido
	   nComisN:=SA3->A3_COMIS
	   M->C5_COMIS1:=SA3->A3_COMIS
	   M->C5_INDIC1:=SA3->A3_COMIS
	   //Coord. de Vendas 
	   if !empty(SA3->A3_SUPER)	 
	       nComisSup:=posicione('SA3', 1, xFilial('SA3')+ SA3->A3_SUPER , 'A3_COMIS')  
	       M->C5_VEND2:= SA3->A3_COD
	       M->C5_COMIS2:=nComisSup
	       M->C5_INDIC2:=nComisSup
       else
           Alert("Favor associar o supervisor no cadastro de Representantes.")
           return  .F.
       endif	
	Else
	   alert("Por favor associar vendedor ao Cadastro de Cliente." )
	   Return .F.
	EndIf 
Endif


return .T.      


****************************************************************
Static Function AreaLicita(cModali,cEdital,cUF,cGeraSE2,cCodMun)
****************************************************************

cModali:=StrZero(Val(cModali),2)


M->C5_VEND1:=SA1->A1_VEND // Indica o vendedor    

If ALLTRIM(cModali) $ '02' // pregao eletronico 
	nComisN:=2
	M->C5_COMIS1:=2
	M->C5_INDIC1:=2
endif	




Return


*****************************
static function getCoor(cCod)
*****************************
Local nCC    := 0
Local cQuery := ""

if SELECT("_TMPX") > 0
	_TMPX->(dbCloseArea())
endif

cQuery := "SELECT A3_COMIS "
cQuery += "FROM "+RetSqlName("SA3")+" "
cQuery += "WHERE A3_COD = '"+cCod+"' "
cQuery += "AND D_E_L_E_T_ <> '*' "
TCQUERY cQuery NEW ALIAS "_TMPX"
DbSelectArea("_TMPX")

nCC := _TMPX->A3_COMIS

_TMPX->(dbCloseArea())

return nCC

***************************
Static Function ComInsDom()
***************************

local nComis := 0
local nComp  := 0
local cQuery := ""                                    

If  Alltrim(substr(SA1->A1_CGC,1,8))=='75315333' //Atacadao
	          
    // ALTERACAO FEITA EM 11/04/2012 AS 15:40 POR ANTONIO CHAMDO 002499. sera compilado a noite portando a regra vale para os pedidos do de 12/04/2012 em diante.
    nComisN:= 0.20 //7 // Baruta
    M->C5_INDIC1:=0.20  //7
    //
    M->C5_COMIS2:= 0 //0.20 //1 // Vend. Regiao Loja
    M->C5_INDIC2:= 0 //0.20  //1      

ElseIf  Alltrim(substr(SA1->A1_CGC,1,8)) $ '09863853/11436813/07688177/11841434' //Soservi,Adlim,Liber
	         
    nComisN:=3 
    M->C5_INDIC1:=3
	     
Else 

	if SA3->A3_COD == '0227' // Marcos (Televendas)  
	   nComisN :=0.25 
	   M->C5_INDIC1:=0.25
	   Return
	endif
	
	//  1ª,2ª,3ª venda e geral 
		      	
	if SELECT("_TMPX") # 0
	   _TMPX->(dbCloseArea())
	endif


	cQuery := "SELECT TOP 3 D2_DOC, D2_EMISSAO, D2_CLIENTE,D2_LOJA "
	cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += "WHERE D2_CLIENTE = '"+SA1->A1_COD+"' "
	cQuery += "AND D2_TES!='514' "
	cQuery += "AND SD2.D_E_L_E_T_ != '*' "
	cQuery += "GROUP BY D2_DOC, D2_EMISSAO, D2_CLIENTE,D2_LOJA "
	cQuery += "ORDER BY D2_EMISSAO  "

	TCQUERY cQuery NEW ALIAS "_TMPX"
	
	DbSelectArea("_TMPX")
			
	 _TMPX->( DbGoTop() )
			
	if _TMPX->D2_EMISSAO >= '20080415'
	   while !_TMPX->(EOF())
		      nComp++
		      _TMPX->(DbSkip())
	   end
	elseif _TMPX->(EOF())
	   nComp := 0
	else   
	   nComp := 99
	endif
				
	_TMPX->(dbCloseArea())                                 
				
	if SA1->A1_SATIV1 # '000009'  //ORGAOS PUBLICOS   
	   if nComp = 0 //Primeira Compra
	      nComis := 10
		  M->C5_INDIC1:=10
		elseif nComp = 1 //Segunda Compra
	      nComis := 8
		  M->C5_INDIC1:=8
		elseif nComp = 2 //Terceiro Compra
	      nComis := 6
		  M->C5_INDIC1:=6
		else                                 		 
	      nComis := 5   // Geral  
   		  M->C5_INDIC1:=5
		endif
	   
	   /* 
	    //Coord. de Vendas 
	    if !empty(SA3->A3_SUPER)		    
		    M->C5_VEND2:= SA3->A3_SUPER		    
		    if SA1->A1_SATIV1 == '000004'  
			   M->C5_COMIS2:=0.40
			   M->C5_INDIC2:=0.40
			elseif SA1->A1_SATIV1 $ '000002/000003'  
			   M->C5_COMIS2:=0.40  //0.15
     	       M->C5_INDIC2:=0.40  //0.15
			elseif SA1->A1_SATIV1 == '000006'  
			   M->C5_COMIS2:=0.40  //0.15
			   M->C5_INDIC2:=0.40  //0.15
			elseif SA1->A1_SATIV1 == '000007'  
			   M->C5_COMIS2:=0.40  //0.15
			   M->C5_INDIC2:=0.40  //0.15
			endif    	    
	    else
          Alert("Favor associar o supervisor no cadastro de Representantes.")
          nComisN := nComis
          return 
        endif
      */  
	else
	  	nComis := M->C5_COMIS1
	endif
				
	nComisN := nComis
endIf

Return

 
*************************
Static Function AreaRep()
*************************

local nComis := 0
local nComp  := 0
local cQuery := ""

//  1ª,2ª,3ª venda e geral 
		      	
	if SELECT("_TMPX") # 0
	   _TMPX->(dbCloseArea())
	endif
		
	cQuery := "SELECT TOP 3 F2_DOC, F2_EMISSAO, F2_CLIENTE "
	cQuery += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2 "
	cQuery += "WHERE F2_CLIENTE = '"+SA1->A1_COD+"' "
	cQuery += "AND SF2.D_E_L_E_T_ = '' "
   cQuery += "AND F2_DOC=D2_DOC "
   cQuery += "AND F2_SERIE=D2_SERIE  "
   cQuery += "AND SD2.D_E_L_E_T_ = '' "
   cQuery += "AND D2_TES!='514' "   // TES DE BONIFICACAO 
	cQuery += "GROUP BY F2_DOC, F2_EMISSAO, F2_CLIENTE "
	cQuery += "ORDER BY F2_EMISSAO "  
	TCQUERY cQuery NEW ALIAS "_TMPX"
	
	DbSelectArea("_TMPX")
			
	 _TMPX->( DbGoTop() )
			
	if _TMPX->F2_EMISSAO >= '20080415'
	   while !_TMPX->(EOF())
		      nComp++
		      _TMPX->(DbSkip())
	   end
	elseif _TMPX->(EOF())
	   nComp := 0
	else   
	 nComp := 99
	endif
				
	_TMPX->(dbCloseArea())
				
	if SA1->A1_SATIV1 # '000009'  //ORGAOS PUBLICOS
	   if nComp = 0 //Primeira Compra
	      nComis := 10
         M->C5_INDIC1:=10		
		elseif nComp = 1 //Segunda Compra
	      nComis := 8
 		   M->C5_INDIC1:=8		
		elseif nComp = 2 //Terceiro Compra
	      nComis := 6
		   M->C5_INDIC1:=6		
		else                                 		 
	      nComis := 5   // Geral  
 		   M->C5_INDIC1:=5		
		endif
	else
	  	nComis := M->C5_COMIS1
	endif
				
	nComisN := nComis
Return

 



***********************************************
Static Function AreaSp(cSuperv,cModali,cEdital)
***********************************************

If  !EMPTY(cSuperv) 
	M->C5_VEND2:= SA3->A3_SUPER  
	cModali:=StrZero(Val(cModali),2)
	
	If ALLTRIM(cModali) $ '01/03/04' 
	   M->C5_COMIS2:=0.6 
	   M->C5_INDIC2:=0.6
	ElseIf ALLTRIM(cModali) $ '02/12/07' 
	   M->C5_COMIS2:=0.3 
	   M->C5_INDIC2:=0.3
	ElseIf ALLTRIM(cModali) $ '05/06/09/10/11' 
	   M->C5_COMIS2:=0 //Vai ser por produto 
	   M->C5_INDIC2:=0
	EndIF           
	
else	
    Alert("Favor associar o supervisor no cadastro de Representantes.")
    return 
Endif

Return 


***********************
User Function  Margem()
***********************


Return .T.
                                                   


*************
                                              
User Function IndiComiss(nOPc)                                              

*************                                              

local nPosIII := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_INDIC1" })
local nPosIV := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_INDIC2" })

If nOpc==1
	If M->C5_COMIS1 > M->C5_INDIC1
	   alert('A Comissao nao pode ser Maior que o Indicado.')
	   Return .F.
	ElseIf M->C5_COMIS1 < M->C5_INDIC1
	    Just(_lCntAlt)
	    _lCntAlt:=.F.
	Endif
Elseif nOpc==2
    If M->C5_COMIS2 > M->C5_INDIC2
	   alert('A Comissao nao pode ser Maior que o Indicado.')
	   Return .F.
	ElseIf M->C5_COMIS2 < M->C5_INDIC2
	    Just(_lCntAlt)
	    _lCntAlt:=.F.
	Endif
Elseif nOpc==3
    If M->C6_COMIS1 > aCols[n][nPosIII]
	   alert('A Comissao nao pode ser Maior que o Indicado.')
	   Return .F.
	elseif M->C6_COMIS1 < aCols[n][nPosIII]
	   Just(_lCntAlt)
	   _lCntAlt:=.F.
	Endif
Elseif nOpc==4
    If M->C6_COMIS2 > aCols[n][nPosIV]
	   alert('A Comissao nao pode ser Maior que o Indicado.')
	   Return .F.
	elseif M->C6_COMIS2 < aCols[n][nPosIV]
	   Just(_lCntAlt)
	   _lCntAlt:=.F.
	Endif
Endif

Return .T.

***************

USER Function Venda() 

***************

Local cQuery :=''
Local nCnt:=0

if SELECT("_SF2XX") # 0
  _SF2XX->(dbCloseArea())
endif

/*		
cQuery := "SELECT TOP 3 F2_DOC, F2_EMISSAO, F2_CLIENTE "
cQuery += "FROM "+RetSqlName("SF2")+" "
cQuery += "WHERE F2_CLIENTE = '"+SA1->A1_COD+"' "
cQuery += "AND D_E_L_E_T_ = '' "
cQuery += "GROUP BY F2_DOC, F2_EMISSAO, F2_CLIENTE "
cQuery += "ORDER BY F2_EMISSAO "
*/

cQuery += "SELECT TOP 3 F2_DOC, F2_EMISSAO, F2_CLIENTE "
cQuery += "FROM "+RetSqlName("SF2")+" SF2,"+RetSqlName("SD2")+" SD2,"+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE F2_CLIENTE = '"+SA1->A1_COD+"' "
cQuery += "AND F2_DOC=D2_DOC "
cQuery += "AND F2_SERIE=D2_SERIE "
cQuery += "AND F2_CLIENTE=D2_CLIENTE  "
cQuery += "AND D2_COD=B1_COD  "
cQuery += "AND B1_SETOR='39' "  // CAIXA 
cQuery += "AND SB1.D_E_L_E_T_ = '' "
cQuery += "AND SF2.D_E_L_E_T_ = '' "
cQuery += "AND SD2.D_E_L_E_T_ = '' "
cQuery += "AND D2_TES!='514' " // TES DE BONIFICACAO 
cQuery += "GROUP BY F2_DOC, F2_EMISSAO, F2_CLIENTE  "
cQuery += "ORDER BY F2_EMISSAO "
 
TCQUERY cQuery NEW ALIAS "_SF2XX"
	

DbSelectArea("_SF2XX")
			
_SF2XX->( DbGoTop() )
			
if _SF2XX->F2_EMISSAO >= '20080415'
   while !_SF2XX->(EOF())
	 nCnt++
	 _SF2XX->(DbSkip())
   end
elseif _SF2XX->(EOF())
   nCnt := 0
else
   nCnt := 99
endif
				
_SF2XX->(dbCloseArea())
		
Return nCnt 


***************

Static Function Just(_lCntAlt)

***************

IF ALTERA
   if _lCntAlt
      _cJustCom:=SC5->C5_JUSTCOM
   endif
ENDIF

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oGet1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 240,488,336,972,"Comissão",,,.F.,,,,,,.T.,,,.F. )
oSay1      := TSay():New( 006,002,{||"Justificativa:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,006)
oGet1      := TGet():New( 013,002,{|u| If(PCount()>0,_cJustCom:=u,_cJustCom)},oDlg1,229,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cJustCom",,)
oBtn1      := TButton():New( 028,194,"OK",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||getObs(_cJustCom)}

oDlg1:Activate(,,,.T.)

If EMPTY(_cJustCom)
   Just()
Endif

Return

***************

Static Function getObs(_cJustCom)

**************

If !EMPTY(_cJustCom)
	oDlg1:end()
ELSE
    ALERT("A Justificativa nao pode ser Vazia!!!")
ENDIF

Return 




***************

USER Function calcAcs(cCod)

***************

Local cQuery := ''
nTotal := 0
If substr(cCod,1,1) == 'C'
	If Len( AllTrim( cCod ) ) >= 8
		cCod := U_transgen(cCod)
	EndIf

	cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
	cQuery += "(select	top 1 SD1.D1_VUNIT "
	cQuery += " from	" + RetSqlName('SD1') + " SD1 "
	cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D_E_L_E_T_ != '*' "
	cQuery += "	order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
	cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
	cQuery += "where SG1.G1_COD = '" + alltrim(cCod) + "' and "      //fita hamper ME0807,  CAAA003, CAE003,  CAF003,  CAD003
	cQuery += "(substring(SG1.G1_COMP,1,2) in ('AC','MH','ST') or SG1.G1_COMP in ('ME0106','ME0104','ME0212','ME0213','ME0807')) "
	cQuery += "and SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
	cQuery += "and SB1.B1_SETOR != '39' " // Diferente Caixa 
	cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery := ChangeQUery(cQuery)
	TCQUERY cQUery NEW ALIAS "TMP"
	TMP->( DbGoTop() )
	
	Do while ! TMP->( EoF() )
  	   if TMP->G1_COD <> 'CTG011' .and. TMP->G1_COMP <> 'AC0003'
	 	      nTotal += TMP->G1_QUANT * TMP->D1_VUNIT 
	   endIf
      TMP->( dbSkip() )
	EndDo
Else
	Alert("Produto nao e hospitalar.")
	return Nil
EndIf

TMP->( DbCloseArea() )

return nTotal
