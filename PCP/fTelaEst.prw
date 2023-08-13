#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :09/07/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fTelaEst(cProd)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc := 3//GD_UPDATE //GD_INSERT+GD_DELETE+GD_UPDATE
Private aHoBrw1 := {}
Private aCoBrw1 := {}
Private noBrw1  := 5
PRIVATE cFColsG:= 'QTDDIG/LOTE/'
PRIVATE lOK:=.F.
aPrd:={}
public aCoBrw1Est:={}
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgEs","oBrw1","oSBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgEs     := MSDialog():New( 144,253,460,1327,"Check List Estrutura",,,.F.,,,,,,.T.,,,.F. )
fgetEst(cProd)

MHoBrw1()
oBrw1      := MsNewGetDados():New(000,000,118,524,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsG,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oDlgEs,aHoBrw1,aCoBrw1 )
MCoBrw1()
oSBtn1     := SButton():New( 132,498,1,,oDlgEs,,"", )
oSBtn1:bAction := {||ok() }

oDlgEs:Activate(,,,.T.)
TMPX->(DBCloseArea())  
//Ferase(cTrab) // APAGA O ARQUIVO DO DISCO

/*
if !lok
   U_fTelaEst(cProd)
endif
*/

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: <Inform Alias>
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

Local aAux := {} 

Aadd( aHoBrw1 , {"Codigo"			,"COD"		,"@!"			,006,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"Descricao"		,"DESC"	,"@!"			,050,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"Qtd Estrutura"	,"QTDEST"	,"@E ****"	    ,012,002,"AllwaysTrue()","û","N"} ) // marcelo pediu pra na mostra o valor da quantidade da estrutura 
Aadd( aHoBrw1 , {"Qtd Inspecao"		,"QTDDIG"	,"@E 999.99"	,012,002,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Lote"	        	,"LOTE"	,"@!"			,020,000,"AllwaysTrue()","û",,"Z76_LO","C"} )

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: <Inform Alias>
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1()

Local aAux 	:= {}
local nI	:= 1

dbSelectArea("TMPX")
TMPX->(dbgoTop())

oBrw1:aCols := {}

While TMPX->(!EOF()) 

    Aadd(oBrw1:aCols,Array(noBrw1+1))	
	oBrw1:aCols[Len(oBrw1:aCols)][01] := TMPX->COD
	oBrw1:aCols[Len(oBrw1:aCols)][02] := TMPX->DESC
	oBrw1:aCols[Len(oBrw1:aCols)][03] := TMPX->QTDEST
   	oBrw1:aCols[Len(oBrw1:aCols)][04] := CriaVar("B2_QATU")
	oBrw1:aCols[Len(oBrw1:aCols)][05] := TMPX->LOTE
	oBrw1:aCols[Len(oBrw1:aCols)][noBrw1+1] := .F.
    
	TMPX->(dbSkip())
EndDo

Return
                                                                                   

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

Static Function fCriaTAB()

Local aFds	:= {}
Private cTRAB	:= ""
Private cTAB	:= "TMPX"

Aadd( aFds , {"COD"   	,"C",006,000} )
Aadd( aFds , {"DESC"  	,"C",050,000} )
Aadd( aFds , {"QTDEST"  ,"N",012,002} )
Aadd( aFds , {"QTDDIGI" ,"N",012,002} )
Aadd( aFds , {"LOTE"  	,"C",020,000} )

cTRAB := CriaTrab( aFds, .T. )
Use (cTRAB) Alias &cTAB New Exclusive
IndRegua(cTAB,cTRAB,"COD",,,'Selecionando Registros...') //'Selecionando Registros...'

Return

****************
Static Function fgetEst(cProd)
****************

fCriaTAB()

//////////seleciona os dados
fSG1(cProd)

TMPX->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 

For _X:=1 to len(aPrd)
    For _XG:=1 to len(aPrd[1][5])
	   RecLock("TMPX", .T.)	
	   TMPX->COD		:= aPrd[1][5][_XG][1]
	   TMPX->DESC		:=	Posicione("SB1",1,xFilial("SB1")+aPrd[1][5][_XG][1],"B1_DESC")
	   TMPX->QTDEST	:=	aPrd[1][5][_XG][2]
	   TMPX->(MsUnLock())
	next   
Next

Return

***************

Static Function fSG1(cProd)

***************

local cAlias := 'REQX1'

cQry:="SELECT G1_QUANT,*  "
cQry+="FROM  SG1020 SG1, SB1010 SB1 "
cQry+="WHERE G1_COD='"+cProd+"'
cQry+="AND G1_COMP=B1_COD "
cQry+="AND B1_TIPO='PI'  "
cQry+="AND SG1.D_E_L_E_T_<>'*' "
cQry+="AND SB1.D_E_L_E_T_<>'*' "

If Select((cAlias)) > 0
  DbSelectArea((cAlias))
  (cAlias)->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS (cAlias)

Do While (cAlias)->(!EOF())    
      Aadd(aPrd,{(cAlias)->G1_COMP,(cAlias)->G1_QUANT,1,'PI',{}}  )
      nAsc	:= Ascan(aPrd,{|x| x[1] == (cAlias)->G1_COMP })
      if nAsc>0
         aPrd[nAsc][5]:=FBuPi((cAlias)->G1_COMP)
      endif
      (cAlias)->(dbskip())
EndDo

(cAlias)->( DbCloseArea() )

Return 

***************

Static Function FBuPi(cProd)

***************

local cAlias := 'REQX2'
local aBuPi:={}

/*
cQry:="SELECT G1_QUANT,*  "
cQry+="FROM  SG1020 SG1 "
cQry+="WHERE G1_COD='"+cProd+"'
cQry+="AND SG1.D_E_L_E_T_<>'*' "
*/

cQry:="SELECT G1_QUANT,*  "
cQry+="FROM  SG1020 SG1, SB1010 SB1 "
cQry+="WHERE G1_COD='"+cProd+"'
cQry+="AND G1_COMP=B1_COD "
cQry+="AND B1_TIPO!='MO' AND (B1_UM!='H' OR B1_UM!='HR') "   // NAO CONSIDERA MAO DE OBRA 
cQry+="AND SG1.D_E_L_E_T_<>'*' "
cQry+="AND SB1.D_E_L_E_T_<>'*' "

If Select((cAlias)) > 0
  DbSelectArea((cAlias))
  (cAlias)->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS (cAlias)

If  (cAlias)->(!EOF())    
	Do While (cAlias)->(!EOF())    
	      Aadd(aBuPi,{(cAlias)->G1_COMP,(cAlias)->G1_QUANT,Posicione("SB1",1,xFilial("SB1") + (cAlias)->G1_COD , "B1_QB") }  )      
	      (cAlias)->(dbskip())
	EndDo
ELSE
    Aadd(aBuPi,{"",0,1 }  )      
ENDIF	
(cAlias)->( DbCloseArea() )

Return aBuPi

***************
Static Function ok()
***************

/*
For _D:=1 to len(oBrw1:aCols)    
    if oBrw1:aCols[_D][4] =0
       ALERT('O '+alltrim(str(_D))+'º item ( '+alltrim(oBrw1:aCols[_D][1])+' ) esta com a quantidade da inspecao zerada. Favor preencher' )
       Return .F.
    endif
Next
*/

aCoBrw1Est:=ACLONE(oBrw1:aCols)
lOk:=.T.
oDlgEs:end()

Return .T.   