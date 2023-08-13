#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'



*************

User Function fVendCli()

*************

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de Variaveis do Tipo Local, Private e Public                 ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/

local lRet:=.F.
Local nOpc := 2//GD_UPDATE //GD_INSERT+GD_DELETE+GD_UPDATE

Private cVendXX      := Space(6)
Private lOK    := .F.
PRIVATE cNomeXX	:= Space(100)

// CLIENTE
Private aHoBrwC := {}
Private aCoBrwC := {}
Private noBrwC  := 0 //6
PRIVATE cFColsC:= 'DTVISI/'
Private coTbl1
// PROSPECT 
Private aHoBrwP := {}
Private aCoBrwP := {}
Private noBrwP  := 0 //6
PRIVATE cFColsP:= 'DTVISI/'
Private coTbl2
// HOSPITAL
Private aHoBrwH := {}
Private aCoBrwH := {}
Private noBrwH  := 0 //6
PRIVATE cFColsH:= 'DTVISI/'
Private coTbl3


/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de Variaveis Private dos Objetos                             ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
SetPrvt("oDlgCL","oFld1","oSay1","oGet1","oSay2","oSBtn1","oBrwC","oBrwP","oBrwH")

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ Definicao do Dialog e todos os seus componentes.                        ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
oDlgCL      := MSDialog():New( 126,254,665,1300,"Lista de Clientes",,,.F.,,,,,,.T.,,,.F. )
oFld1      := TFolder():New( 044,004,{"CLIENTE","PROSPECT","HOSPITAL"},{},oDlgCL,,,,.T.,.F.,509,191,) 
oGrp1      := TGroup():New( 000,004,039,505,"",oDlgCL,CLR_BLACK,CLR_WHITE,.T.,.F. )

// CLIENTE
oTbl1()
MHoBrwC()
oBrwC      := MsNewGetDados():New(004,002,168,500,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsC,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oFld1:aDialogs[1],aHoBrwC,aCoBrwC )
MCoBrwC()
// PROSPECT 
oTbl2()
MHoBrwP()
oBrwP      := MsNewGetDados():New(004,002,168,500,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsP,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oFld1:aDialogs[2],aHoBrwP,aCoBrwP )
MCoBrwP()
// HOSPITAL
oTbl3()
MHoBrwH()
oBrwH      := MsNewGetDados():New(004,002,168,500,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsH,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oFld1:aDialogs[3],aHoBrwH,aCoBrwH )
MCoBrwH()

oSay1      := TSay():New( 008,006,{||"Vendedor:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 020,006,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA3","cVendXX",,)
oGet1:bSetGet := {|u| If(PCount()>0,cVendXX:=u,cVendXX)}
oGet1:bValid := {||cNomeXX := POSICIONE(("SA3"),1,xFilial("SA3") + cVendXX, "A3_NOME")}

oGet1:bChange := {||cNomeXX := POSICIONE(("SA3"),1,xFilial("SA3") + cVendXX, "A3_NOME")}

oSay2      := TSay():New( 020,128,{||alltrim(cNomeXX) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,348,008)
//oSay2      := TSay():New( 020,084,{||alltrim(cNomeXX)},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,388,008)

oBtn1      := TButton():New( 018,080,"Pesquisar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||fPesq(cVendXX)}


oSBtn1     := SButton():New( 244,487,1,,oDlgCL,,"", )
oSBtn1:bAction := {||lRet:=fOk()} 

ObjectMethod( oGet1, "SetFocus()" )

oDlgCL:Activate(,,,.T.)

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

If Select("TMP2") > 0
	TMP2->(dbCloseArea())
EndIf

If Select("TMP3") > 0
	TMP3->(dbCloseArea())
EndIf

if  lRet

	If  Alltrim(M->ZZE_GESTOR) $ GetNewPar("MV_XCODCOO","0228,0315,0342,2348,2367")
	
	
	   if MsgBox( OemToAnsi( "Deseja Adicionar mas Itens(Cliente,Prospect,Hospital) a Agenda ??" ), "Escolha", "YESNO" )       
	      U_fVendCli()
	   endif
	
	Endif
	
endif


Return .T.


/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
CLIENTE
Function  Ё MHoBrwC() - Monta aHeader da MsNewGetDados para o Alias: TMP
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function MHoBrwC()

***************

Local aAux := {} 


Aadd( aHoBrwC , {"DT. Visita"	    ,"DTVISI"	    , " "                   ,08,000,"AllwaysTrue()","Ш","D"} )
Aadd( aHoBrwC , {"Codigo"			,"CODIGO"		,"@!"			       ,010,000,"AllwaysTrue()","Ш","C"} )
Aadd( aHoBrwC , {"Loja"			    ,"LOJA"		    ,"@!"			       ,002,000,"AllwaysTrue()","Ш","C"} )
Aadd( aHoBrwC , {"Descricao"		,"DESCRICAO"	,"@!"			       ,050,000,"AllwaysTrue()","Ш","C"} )

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
PROSPECT
Function  Ё MHoBrwP() - Monta aHeader da MsNewGetDados para o Alias: TMP2
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function MHoBrwP()

***************

Local aAux := {} 


Aadd( aHoBrwP , {"DT. Visita"	    ,"DTVISI"	    , " "                   ,08,000,"AllwaysTrue()","Ш","D"} )
Aadd( aHoBrwP , {"Codigo"			,"CODIGO"		,"@!"			       ,010,000,"AllwaysTrue()","Ш","C"} )
Aadd( aHoBrwP , {"Loja"			    ,"LOJA"		    ,"@!"			       ,002,000,"AllwaysTrue()","Ш","C"} )
Aadd( aHoBrwP , {"Descricao"		,"DESCRICAO"	,"@!"			       ,050,000,"AllwaysTrue()","Ш","C"} )

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
HOSPITAL
Function  Ё MHoBrwH() - Monta aHeader da MsNewGetDados para o Alias: TMP3
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function MHoBrwH()

***************

Local aAux := {} 


Aadd( aHoBrwH , {"DT. Visita"	    ,"DTVISI"	    , " "                   ,08,000,"AllwaysTrue()","Ш","D"} )
Aadd( aHoBrwH , {"Leitos"	       ,"LEITO"	        ,"@!"			        ,010,000,"AllwaysTrue()","Ш","N"} )
Aadd( aHoBrwH , {"Nome"		        ,"NOME"	        ,"@!"			        ,060,000,"AllwaysTrue()","Ш","C"} )
Aadd( aHoBrwH , {"UF"		        ,"UF"	        ,"@!"			        ,002,000,"AllwaysTrue()","Ш","C"} )
Aadd( aHoBrwH , {"Municipio"	   ,"MUN"	        ,"@!"			        ,050,000,"AllwaysTrue()","Ш","C"} )
Aadd( aHoBrwH , {"Cnes"			    ,"CODIGO"		,"@!"			        ,010,000,"AllwaysTrue()","Ш","C"} )


Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
CLIENTE
Function  Ё MCoBrwC() - Monta aCols da MsNewGetDados para o Alias: TMP
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function MCoBrwC()

***************

Local aAux 	:= {}
local nI	:= 1


nPosDtVI := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "DTVISI"})
nPosCodi := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "CODIGO"})
nPosLoja := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "LOJA"})
nPosDesc := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "DESCRICAO"})


noBrwC  :=LEN(oBrwC:AHEADER)


dbSelectArea("TMP")
TMP->(dbgoTop())

oBrwC:aCols := {}


If TMP->(!EOF()) 

	While TMP->(!EOF()) 
	
	    Aadd(oBrwC:aCols,Array(noBrwC+1))	
	 	oBrwC:aCols[Len(oBrwC:aCols)][nPosDtVI] := CtoD('  /  /  ')  
	    oBrwC:aCols[Len(oBrwC:aCols)][nPosCodi] := TMP->CODIGO
	    oBrwC:aCols[Len(oBrwC:aCols)][nPosLoja] := TMP->LOJA    	
		oBrwC:aCols[Len(oBrwC:aCols)][nPosDesc] := TMP->DESCRICAO
	
		oBrwC:aCols[Len(oBrwC:aCols)][noBrwC+1] := .F.
	    
		TMP->(dbSkip())
	EndDo
	
Else

	Aadd(oBrwC:aCols,Array(noBrwC+1))	
	oBrwC:aCols[Len(oBrwC:aCols)][nPosDtVI] := CtoD('  /  /  ')  
	oBrwC:aCols[Len(oBrwC:aCols)][nPosCodi] := " "
	oBrwC:aCols[Len(oBrwC:aCols)][nPosLoja] := " "    	
	oBrwC:aCols[Len(oBrwC:aCols)][nPosDesc] := " "
		
	oBrwC:aCols[Len(oBrwC:aCols)][noBrwC+1] := .F.
	

EndIf

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
PROSPECT
Function  Ё MCoBrwP() - Monta aCols da MsNewGetDados para o Alias: TMP2
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function MCoBrwP()

***************

Local aAux 	:= {}
local nI	:= 1


nPosDtVI := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "DTVISI"})
nPosCodi := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "CODIGO"})
nPosLoja := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "LOJA"})
nPosDesc := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "DESCRICAO"})


noBrwP  :=LEN(oBrwP:AHEADER)


dbSelectArea("TMP2")
TMP2->(dbgoTop())

oBrwP:aCols := {}


If TMP2->(!EOF()) 

	While TMP2->(!EOF()) 
	
	    Aadd(oBrwP:aCols,Array(noBrwP+1))	
	 	oBrwP:aCols[Len(oBrwP:aCols)][nPosDtVI] := CtoD('  /  /  ')  
	    oBrwP:aCols[Len(oBrwP:aCols)][nPosCodi] := TMP2->CODIGO
	    oBrwP:aCols[Len(oBrwP:aCols)][nPosLoja] := TMP2->LOJA    	
		oBrwP:aCols[Len(oBrwP:aCols)][nPosDesc] := TMP2->DESCRICAO
	
		oBrwP:aCols[Len(oBrwP:aCols)][noBrwP+1] := .F.
	    
		TMP2->(dbSkip())
	EndDo
	
Else

	Aadd(oBrwP:aCols,Array(noBrwP+1))	
	oBrwP:aCols[Len(oBrwP:aCols)][nPosDtVI] := CtoD('  /  /  ')  
	oBrwP:aCols[Len(oBrwP:aCols)][nPosCodi] := " "
	oBrwP:aCols[Len(oBrwP:aCols)][nPosLoja] := " "    	
	oBrwP:aCols[Len(oBrwP:aCols)][nPosDesc] := " "
		
	oBrwP:aCols[Len(oBrwP:aCols)][noBrwP+1] := .F.
	

EndIf

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
HOSPITAL
Function  Ё MCoBrwH() - Monta aCols da MsNewGetDados para o Alias: TMP3
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function MCoBrwH()

***************

Local aAux 	:= {}
local nI	:= 1


nPosDtVI := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "DTVISI"})
nPosCodi := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "CODIGO"})
nPosNom  := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "NOME"})
nPosUf   := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "UF"})
nPosMun  := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "MUN"})
nPosLe  := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "LEITO"})

noBrwH  :=LEN(oBrwH:AHEADER)


dbSelectArea("TMP3")
TMP3->(dbgoTop())

oBrwH:aCols := {}


If TMP3->(!EOF()) 

	While TMP3->(!EOF()) 
	
	    Aadd(oBrwH:aCols,Array(noBrwH+1))	
	 	oBrwH:aCols[Len(oBrwH:aCols)][nPosDtVI] := CtoD('  /  /  ')  
	    oBrwH:aCols[Len(oBrwH:aCols)][nPosCodi] := TMP3->CODIGO
	    oBrwH:aCols[Len(oBrwH:aCols)][nPosNom] := TMP3->NOME    	
		oBrwH:aCols[Len(oBrwH:aCols)][nPosUf] := TMP3->UF
		oBrwH:aCols[Len(oBrwH:aCols)][nPosMun] := TMP3->MUN
		oBrwH:aCols[Len(oBrwH:aCols)][nPosLe] := TMP3->LEITO
					
		oBrwH:aCols[Len(oBrwH:aCols)][noBrwH+1] := .F.
	    
		TMP3->(dbSkip())
	EndDo
	
Else

	  Aadd(oBrwH:aCols,Array(noBrwH+1))	
	  oBrwH:aCols[Len(oBrwH:aCols)][nPosDtVI] := CtoD('  /  /  ')  
	  oBrwH:aCols[Len(oBrwH:aCols)][nPosCodi] := " "
	  oBrwH:aCols[Len(oBrwH:aCols)][nPosNom] := " "
	  oBrwH:aCols[Len(oBrwH:aCols)][nPosUf] := " "
	  oBrwH:aCols[Len(oBrwH:aCols)][nPosMun] := " "
      oBrwH:aCols[Len(oBrwH:aCols)][nPosLe] := 0			
	  
	  oBrwH:aCols[Len(oBrwH:aCols)][noBrwH+1] := .F.
	

EndIf

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
CLIENTE
Function  Ё oTbl1() - Cria temporario para o Alias: TMP
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function oTbl1()

***************

Local aFds := {}


Aadd( aFds , {"DTVISI"    ,"D",008,000} )
Aadd( aFds , {"CODIGO"    ,"C",006,000} )
Aadd( aFds , {"LOJA"      ,"C",002,000} )
Aadd( aFds , {"DESCRICAO" ,"C",050,000} )


If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
PROSPECT
Function  Ё oTbl2() - Cria temporario para o Alias: TMP2
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function oTbl2()

***************

Local aFds := {}


Aadd( aFds , {"DTVISI"    ,"D",008,000} )
Aadd( aFds , {"CODIGO"    ,"C",006,000} )
Aadd( aFds , {"LOJA"      ,"C",002,000} )
Aadd( aFds , {"DESCRICAO" ,"C",050,000} )


If Select("TMP2") > 0
	TMP2->(dbCloseArea())
EndIf

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive

Return 

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
HOSPITAL
Function  Ё oTbl3() - Cria temporario para o Alias: TMP3
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function oTbl3()

***************

Local aFds := {}


Aadd( aFds , {"DTVISI"  ,"D",008,000} )
Aadd( aFds , {"CODIGO"  ,"C",009,000} )
Aadd( aFds , {"NOME"    ,"C",060,000} )
Aadd( aFds , {"UF"      ,"C",002,000} )
Aadd( aFds , {"MUN"     ,"C",050,000} )
Aadd( aFds , {"LEITO"   ,"N",010,000} )

If Select("TMP3") > 0
	TMP3->(dbCloseArea())
EndIf

coTbl3 := CriaTrab( aFds, .T. )
Use (coTbl3) Alias TMP3 New Exclusive

Return 

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
CLIENTE
Function  Ё FiltraCli()
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function FiltraCli(cVend)

***************

local cQuery



cQuery := "SELECT A1_COD,A1_LOJA,A1_NOME FROM "+RetSqlName("SA1")+"  SA1 "
cQuery += "WHERE A1_VEND='"+cVend+"' "
cQuery += "AND A1_ATIVO<>'N' "
cQuery += "AND A1_MSBLQL<>'1' "
cQuery += "AND SA1.D_E_L_E_T_=''  "
cQuery += "ORDER BY A1_COD,A1_LOJA "

cQuery := ChangeQuery(cQuery)

If Select("SA1X") > 0
	SA1X->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SA1X",.T.,.T.)


TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA  

SA1X->( DBGoTop() )

if !SA1X->(EOF())

   while SA1X->(!EOF())

      RecLock('TMP',.T.)	
      
      TMP->CODIGO    := SA1X->A1_COD
      TMP->LOJA      := SA1X->A1_LOJA
      TMP->DESCRICAO := Substr(SA1X->A1_NOME,1,50)
      TMP->(MsUnLock())

      SA1X->(dbSkip())
   enddo

else

 //ALERT('Nao a Dados para essa Consulta!!!')
// TMP->(dbCloseArea())
 return .F.

endif

TMP->(DbGoTop())

If Select("SA1X") > 0
	SA1X->(dbCloseArea())
EndIf

MCoBrwC()

oBrwC:oBrowse:Refresh()


Return .T.


***************

Static Function Campos( cString,;	// String a ser processada
					    cDelim,;	// Delimitador
					    lAllTrim;	// Tira espacos em brancos
				                  )
***************

Local aRetorno := {}	// Array de retorno
Local nPos				// Posicao do caracter

cDelim		:= If( cDelim = Nil, ' ', cDelim )
lAllTrim 	:= If( lAllTrim = Nil, .t., lAllTrim )
             
If lAllTrim
	cString := AllTrim( cString )
Endif

Do While .t.
	If ( nPos := At( cDelim, cString ) ) != 0
 		Aadd( aRetorno, Iif( lAllTrim, AllTrim( Substr( cString, 1, nPos - 1 ) ), Substr( cString, 1, nPos - 1 ) ) )
		cString := Substr( cString, nPos + Len( cDelim ) )
	Else
		If !Empty( cString )
			Aadd( aRetorno,  Iif( lAllTrim, AllTrim( cString ), cString ) )
		Endif
		Exit
	Endif	
Enddo

Return aRetorno


***************

Static Function fOk()

***************

/// agenda 
local nTIPO   := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_TIPO"})
local nDTVISI := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_DTVISI"})
local nCODCP  := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_CODCP"})
local nNOMECP := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_NOMECP"})
local nLOJA   := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_LOJA"})
local nNaIncl := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_NAINCL" })
// cliente
nPosDtVI := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "DTVISI"})
nPosCodi := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "CODIGO"})
nPosLoja := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "LOJA"})
nPosDesc := aScan(oBrwC:AHEADER,{|x| Alltrim(x[2]) == "DESCRICAO"})
// Prospect
nPoPDtVI := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "DTVISI"})
nPoPCodi := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "CODIGO"})
nPoPLoja := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "LOJA"})
nPoPDesc := aScan(oBrwP:AHEADER,{|x| Alltrim(x[2]) == "DESCRICAO"})
// Hospital
nPoHDtVI := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "DTVISI"})
nPoHCodi := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "CODIGO"})
nPoHNom  := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "NOME"})
nPoHUF   := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "UF"})
nPoHMUN  := aScan(oBrwH:AHEADER,{|x| Alltrim(x[2]) == "MUN"})

_CNTCL:= len(oGetd:aCols) //1

If  !Alltrim(M->ZZE_GESTOR) $ GetNewPar("MV_XCODCOO","0228,0315,0342,2348,2367")
   if Len(oGetd:aCols) > 1 
     oGetd:aCols := aSize( oGetd:aCols,1) 
     _CNTCL:= len(oGetd:aCols) //1   
   endif
Endif


/// CLIENTE
FOR X:=1 TO LEN(oBrwC:aCols)

 if !Empty(oBrwC:aCols[X][nPosDtVI])
       
    IF VLDITEM(oBrwC:aCols[X][nPosCodi]+oBrwC:aCols[X][nPosLoja],'1')       

       IF  _CNTCL>1 // Len(oGetd:aCols) >1

          Aadd(oGetd:aCols, Array(Len(oGetd:aCols[1])) )                       
          for nI := 1 To Len(oGetd:aCols[1])-1 //menos a coluna delete 
	       oGetd:aCols[Len(oGetd:aCols)][nI] := CriaVar(AllTrim(oGetd:aHeader[nI][2]))
          next
          
       ENDIF
       
       oGetd:aCols[Len(oGetd:aCols)][nTIPO]:='C'
       oGetd:aCols[Len(oGetd:aCols)][nDTVISI]:= oBrwC:aCols[X][nPosDtVI]
       oGetd:aCols[Len(oGetd:aCols)][nCODCP]:=oBrwC:aCols[X][nPosCodi]
       oGetd:aCols[Len(oGetd:aCols)][nLOJA]:=oBrwC:aCols[X][nPosLoja]
       oGetd:aCols[Len(oGetd:aCols)][nNOMECP]:=oBrwC:aCols[X][nPosDesc]
	   /*
	   IF _Fecham
	      oGetd:aCols[Len(oGetd:aCols)][10 + 1] := .F.
       ELSE
          oGetd:aCols[Len(oGetd:aCols)][5 + 1] := .F.       
       ENDIF
       */

       oGetd:aCols[Len(oGetd:aCols)][LEN(oGetd:AHEADER)+ 1] := .F.              
       
       _CNTCL+=1     
   ENDIF
   
 endif
   
NEXT 

/// PROSPECT 

FOR X:=1 TO LEN(oBrwP:aCols)

 if !Empty(oBrwP:aCols[X][nPoPDtVI])
       
    IF VLDITEM(oBrwP:aCols[X][nPoPCodi]+oBrwP:aCols[X][nPoPLoja],'2')       

       IF  _CNTCL>1 // Len(oGetd:aCols) >1

          Aadd(oGetd:aCols, Array(Len(oGetd:aCols[1])) )                       
          for nI := 1 To Len(oGetd:aCols[1])-1 //menos a coluna delete 
	       oGetd:aCols[Len(oGetd:aCols)][nI] := CriaVar(AllTrim(oGetd:aHeader[nI][2]))
          next
          
       ENDIF
       
       oGetd:aCols[Len(oGetd:aCols)][nTIPO]:='P'
       oGetd:aCols[Len(oGetd:aCols)][nDTVISI]:= oBrwP:aCols[X][nPoPDtVI]
       oGetd:aCols[Len(oGetd:aCols)][nCODCP]:=oBrwP:aCols[X][nPoPCodi]
       oGetd:aCols[Len(oGetd:aCols)][nLOJA]:=oBrwP:aCols[X][nPoPLoja]
       oGetd:aCols[Len(oGetd:aCols)][nNOMECP]:=oBrwP:aCols[X][nPoPDesc]
	   
	   //IF _Fecham
	   //   oGetd:aCols[Len(oGetd:aCols)][10 + 1] := .F.
       //ELSE
       //   oGetd:aCols[Len(oGetd:aCols)][5 + 1] := .F.       
       //ENDIF
       
       
       oGetd:aCols[Len(oGetd:aCols)][LEN(oGetd:AHEADER)+ 1] := .F.              
                     
       _CNTCL+=1     
   ENDIF
   
 endif

next

/// HOSPITAL
/*
FOR X:=1 TO LEN(oBrwH:aCols)

 if !Empty(oBrwH:aCols[X][nPoHDtVI])
       
    IF VLDHOP(oBrwH:aCols[X][nPoHCodi])       

       IF  _CNTCL>1 // Len(oGetd:aCols) >1

          Aadd(oGetd:aCols, Array(Len(oGetd:aCols[1])) )                       
          for nI := 1 To Len(oGetd:aCols[1])-1 //menos a coluna delete 
	       oGetd:aCols[Len(oGetd:aCols)][nI] := CriaVar(AllTrim(oGetd:aHeader[nI][2]))
          next
          
       ENDIF
       
       oGetd:aCols[Len(oGetd:aCols)][nTIPO]:='H'
       oGetd:aCols[Len(oGetd:aCols)][nDTVISI]:= oBrwH:aCols[X][nPoHDtVI]
       oGetd:aCols[Len(oGetd:aCols)][nCODCP]:=oBrwH:aCols[X][nPoHCodi]
       oGetd:aCols[Len(oGetd:aCols)][nLOJA]:="01"
       oGetd:aCols[Len(oGetd:aCols)][nNOMECP]:=oBrwH:aCols[X][nPoHNOM]
	   
	   //IF _Fecham
	   //   oGetd:aCols[Len(oGetd:aCols)][10 + 1] := .F.
       //ELSE
       //   oGetd:aCols[Len(oGetd:aCols)][5 + 1] := .F.       
       //ENDIF
       
       
       oGetd:aCols[Len(oGetd:aCols)][LEN(oGetd:AHEADER)+ 1] := .F.              
                     
       _CNTCL+=1     
   ENDIF
   
 endif

next
*/

// ordenar pela Data  da Visita e Tipo(cliente,prospect e hostital)
oGetd:aCols := aSort(oGetd:aCols,,, { |x, y| DTOS(x[2])+x[1] < DTOS(y[2])+y[1] })


IF oGetd:aCols[1][1]='C'    //  cliente
   oGetd:aHeader[nCODCP][9]:='SA1'

ELSEIF oGetd:aCols[1][1]='P'  // prospect 
   oGetd:aHeader[nCODCP][9]:='SUS'

ELSEIF oGetd:aCols[1][1]='H'  // hospital 
   oGetd:aHeader[nCODCP][9]:='Z99'

ENDIF	

IF _fecham // FECHAMENTO 

	IF ALLTRIM(oGetd:aCols[1][nNaIncl])='X' 
	   oGetd:aALTER[1]:="ZZF_TIPOX" 
	   oGetd:aALTER[2]:="ZZF_DTVISIX" 
	   oGetd:aALTER[3]:="ZZF_CODCPX" 
	ELSE 
	   oGetd:aALTER[1]:="ZZF_TIPO" 
	   oGetd:aALTER[2]:="ZZF_DTVISI" 
	   oGetd:aALTER[3]:="ZZF_CODCP" 
	ENDIF
	

ENDIF


DbSelectArea("ZZE")
oGetd:oBrowse:Refresh() // atualiza o grid da agenda com as informacoes marcardas pelo check list 


oDlgCL:END()


return .T.


*************

Static Function VLDITEM(cCod,nOpc)

************* 

local nCODCP  := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_CODCP"})
local nLOJA   := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_LOJA"})
local nPosDel:= len(oGetd:aHeader)+1

for _x:=1  To  len(oGetd:aCols)

If ! oGetd:aCols[_x,nPosDel]   

	if alltrim(oGetd:aCols[_x][nCODCP])+alltrim(oGetd:aCols[_x][nLOJA])=alltrim(cCod)
		If nOPc='1'
		   alert("O Cliente nao pode se repetir: "+substr(cCod,1,6)+'-'+substr(cCod,7,2) )
		elseIf nOPc='2'
           alert("O Prospect nao pode se repetir: "+substr(cCod,1,6)+'-'+substr(cCod,7,2) )		
		endif
		
		return .F.
	endif
	
Endif

next _x
                  
return .T.

***************

Static Function fItemAg(cVend)

***************

Filtracli(cVend)
FiltraPRO(cVend)     
FiltraHOP(cVend)     


Return  .T. 


/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
PROSPECT 
Function  Ё FiltraPRO()
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
***************

Static Function FiltraPRO(cVend)

***************

local cQuery




cQuery := "SELECT US_COD,US_LOJA,US_NOME FROM "+RetSqlName("SUS")+" SUS "
cQuery += "WHERE US_VEND='"+cVend+"' "
cQuery += "AND SUS.D_E_L_E_T_='' "
cQuery += "ORDER BY US_COD,US_LOJA "

cQuery := ChangeQuery(cQuery)

If Select("SUSX") > 0
	SUSX->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SUSX",.T.,.T.)


TMP2->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA  

SUSX->( DBGoTop() )

if !SUSX->(EOF())

   while SUSX->(!EOF())

      RecLock('TMP2',.T.)	
      
      TMP2->CODIGO    := SUSX->US_COD
      TMP2->LOJA      := SUSX->US_LOJA
      TMP2->DESCRICAO := Substr(SUSX->US_NOME,1,50)
      TMP2->(MsUnLock())

      SUSX->(dbSkip())
   enddo

else

 //ALERT('Nao a Dados para essa Consulta!!!')
// TMP2->(dbCloseArea())
 return .F.

endif

TMP2->(DbGoTop())

If Select("SUSX") > 0
	SUSX->(dbCloseArea())
EndIf

MCoBrwP()

oBrwP:oBrowse:Refresh()


Return .T.

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
HOSPITAL 
Function  Ё FiltraPRO()
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/

***************

Static Function FiltraHOP(cVend)

***************

local cQuery

/*
cQuery := "SELECT Z99_CNES,Z99_NOME,Z99_UF,Z99_MUN FROM "+RetSqlName("Z99")+" Z99  "
cQuery += "WHERE Z99_UF IN(SELECT A3_EST FROM "+RetSqlName("SA3")+" SA3 WHERE A3_COD='"+cVend+"' AND D_E_L_E_T_='') "
cQuery += "AND Z99.D_E_L_E_T_='' "
cQuery += "ORDER BY Z99_NOME  "
*/

cQuery := "SELECT Z99_CNES,Z99_NOME,Z99_UF,Z99_MUN,Z99_LEITOS  "
cQuery += ",ORDENA =CASE "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='RIO BRANCO' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='MACEIO' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='MACAPA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='MANAUS' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='SALVADOR' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='FORTALEZA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='BRASILIA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='VITORIA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='GOIANIA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='SAO LUIS' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1)  "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='CUIABA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='CAMPO GRANDE' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='BELO HORIZONTE' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='BELEM' AND Z99_UF<>'PB' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='JOAO PESSOA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='CURITIBA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='RECIFE' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='TERESINA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='RIO DE JANEIRO' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='NATAL' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='PORTO ALEGRE' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='PORTO VELHO' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='BOA VISTA' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='FLORIANOPOLIS' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='SAO PAULO' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='ARACAJU' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "	WHEN SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) ='PALMAS' THEN 'C-'+SUBSTRING(Z99_MUN,1,PATINDEX ( '%-%' , Z99_MUN )-1) "
cQuery += "ELSE 'I' "
cQuery += "END "

cQuery += "FROM "+RetSqlName("Z99")+" Z99  "
cQuery += "WHERE Z99_UF IN(SELECT A3_EST FROM "+RetSqlName("SA3")+" SA3 WHERE A3_COD='0201' AND D_E_L_E_T_='') "
cQuery += "AND Z99.D_E_L_E_T_='' "
cQuery += "ORDER BY ORDENA,Z99_LEITOS DESC  "



cQuery := ChangeQuery(cQuery)

If Select("Z99X") > 0
	Z99X->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"Z99X",.T.,.T.)


TMP3->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA  

Z99X->( DBGoTop() )

if !Z99X->(EOF())

   while Z99X->(!EOF())

      RecLock('TMP3',.T.)	
      
      TMP3->CODIGO    := Z99X->Z99_CNES
      TMP3->NOME      := Substr(Z99X->Z99_NOME,1,60)
      TMP3->UF        := Z99X->Z99_UF
      TMP3->MUN       := Substr(Z99X->Z99_MUN,1,50)
      TMP3->LEITO     := Z99X->Z99_LEITOS
      
      TMP3->(MsUnLock())

      Z99X->(dbSkip())
   enddo

else

 //ALERT('Nao a Dados para essa Consulta!!!')
// TMP3->(dbCloseArea())
 return .F.

endif

TMP3->(DbGoTop())

If Select("Z99X") > 0
	Z99X->(dbCloseArea())
EndIf

MCoBrwH()

oBrwH:oBrowse:Refresh()


Return .T.


***************

Static Function fPesq(cVend)

***************

fItemAg(cVend)

Return 


*************

Static Function VLDHOP(cCod)

************* 

local nCODCP  := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_CODCP"})
local nPosDel:= len(oGetd:aHeader)+1

for _x:=1  To  len(oGetd:aCols)

If ! oGetd:aCols[_x,nPosDel]   

	if alltrim(oGetd:aCols[_x][nCODCP])=alltrim(cCod)

	     alert("O Hospital nao pode se repetir: "+substr(cCod,1,9) )
		
		 return .F.
		 
	endif
	
Endif

next _x
                  
return .T.
