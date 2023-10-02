#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

*************

User Function FLOTEEXT()

*************

Local aCores := {{ "EMPTY(ZZB->ZZB_STATUS)"  , 'BR_VERDE'    },; // LOTE NAO FINALIZADO  
                 { "ZZB->ZZB_STATUS='E'"   , 'BR_AMARELO' } ,;   // LOTE ENCERRADO 	 				 
				 { "ZZB->ZZB_STATUS='F'"   , 'BR_VERMELHO' } } // LOTE FINALIZADO 	 
				 
aRotina2 := {{"Analise de OP's"      ,"U_PCPR045()"  , 0, 6},;
  		    {"Via OP "               ,"U_OPGRAF2()",0,6} }

aRotina3 := {{"Inventario"             ,"U_FTLCONTLO()", 0, 6},;
             {"Relatorio de Analise"   ,"U_FREANALOT()", 0, 6},;
             {"Rel. de Analise CS"	   ,"U_PCPR048()", 0, 6},;
  		     {"Finalzar Lote"          ,"U_FTLAJLO()",0,6} }

aRotina := {{"Pesquisar"      ,"AxPesqui"  , 0, 1},;
            {"Relatorios"     ,aRotina2, 0, 2},;
            {"Gerar Lote"     ,"U_FTLOT()", 0, 3},;
            {"Altera Lote"    ,"U_FSaiOP()", 0, 3},;
            {"Encerramento"   ,aRotina3, 0, 4},;
            {"Visualizar"     ,"U_FCdModeLo", 0, 5},;
  		    {"Legenda"        ,"U_FLegLo()",0,8} }

Private cCadastro := OemToAnsi("Cadastro de Lote ")
Private cAlias1	   := "ZZC"	    // Alias de detalhe
Private lSemItens  := .F.		// Permite a nao existencia de itens
Private cChave	   := "ZZB_LOTE"  // Chave que ligara a primeira tabela com a segunda
Private cChave1	   := "ZZC_LOTE"  // Chave que ligara a segunda tabela com a primeira
Private aChaves    := {{"ZZC_LOTE", "M->ZZB_LOTE"}}
Private cLinhaOk   := "AllwaysTrue()" //Funcao LinhaOk para a GetDados
Private cTudoOk    := "AllwaysTrue()" //Funcao TudoOk para a GetDados
Private cDelOK     :="AllwaysTrue()" //Funcao TudoOk para a GetDados


DbSelectArea("ZZB")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "ZZB",,,,,,aCores)

Return


*************

User Function FTLOT()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
local lRet:=.T.
Local nDiasLotOP	:= GetNewPar("MV_XDIALOP",6)

Private lOK    := .F.
Private cMarca := GetMark()
Private coTbl1
Private aEstru := {} 


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSay1","oBrw1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oPerg1("FLOTEEX")

if !Pergunte("FLOTEEX",.T.)
   Return
endif

oFont1     := TFont():New( "MS Sans Serif",0,-24,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 126,254,626,1032,"Cadastro de Lote ",,,.F.,,,,,,.T.,,,.F. )

oSay1      := TSay():New( 024,048,{||"oSay1"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,302,020)
oSay2      := TSay():New( 024,016,{||"Lote:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,020)

oTbl1()
DbSelectArea("TMP")
oBrw1  := MsSelect():New( "TMP","OK","",{{"OK"       ,"",""            ,""},;
                                         {"OP"       ,"","Ord.Producao",""},;
                                         {"PROD"     ,"","Produto"     ,""},;
                                         {"DESCRICAO","","Descricao"   ,""},;
                                         {"QTDUM"    ,"","Qtd.UM"      ,""},;
                                         {"QTDSUM"   ,"","Qtd.Seg.UM"  ,""}},.F.,cMarca,{060,012,203,371},,, oDlg1 ) 
oBrw1:oBrowse:lHasMark    := .T.
oBrw1:oBrowse:lCanAllmark := .T.
oBrw1:oBrowse:nClrPane    := CLR_BLACK
oBrw1:oBrowse:nClrText    := CLR_BLACK
oBrw1:oBrowse:bAllMark    := {||TMPMkAll()}
oBrw1:bMark               := {||TMPMark()}

MsAguarde({|| lRet:=FiltraOPs()},"Aguarde...","Processando Dados...")

If mv_par02 - mv_par01 < nDiasLotOP

	MsgAlert("LOTE SELECIONADO COM MENOS DE " + Transform(nDiasLotOP,"99") + " DIAS. NECESSÁRIO AUTORIZAÇÃO !!!!")
	lRet	:= U_senha2( "13", 4, "AUTORIZAÇÃO PARA MANUTENÇÃO DE LOTE" )[ 1 ]
	
EndIf

IF !lRet // caso a consulta retorne em branco, sem OP para o filtro 
   return 
EndIf

oSay1:cCaption:=fComeca()

if empty(oSay1:cCaption) // valido se o lote ja foi finalizado 
   TMP->(DbCloseArea())
   return 
endif

oSBtn1     := SButton():New( 212,300,1,,oDlg1,,"", )
oSBtn1:bAction := {||fOk()}
oSBtn2     := SButton():New( 212,345,2,,oDlg1,,"", )
oSBtn2:bAction := {||ffecha()}

oDlg1:Activate(,,,.T.)


TMP->(DbCloseArea())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"OK"       ,"C",002,000} )
Aadd( aFds , {"OP"       ,"C",006,000} )
Aadd( aFds , {"PROD"     ,"C",015,000} )
Aadd( aFds , {"DESCRICAO","C",050,000} )
Aadd( aFds , {"QTDUM"    ,"N",012,002} )
Aadd( aFds , {"UM"       ,"C",002,000} )
Aadd( aFds , {"QTDSUM"   ,"N",010,002} )
Aadd( aFds , {"SEGUM"    ,"C",002,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: TMP2
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl2()

Local aFds := {}

Aadd( aFds , {"OK"       ,"C",002,000} )
Aadd( aFds , {"OP"       ,"C",006,000} )
Aadd( aFds , {"PROD"     ,"C",015,000} )
Aadd( aFds , {"DESCRICAO","C",050,000} )
Aadd( aFds , {"QTDUM"    ,"N",012,002} )
Aadd( aFds , {"UM"       ,"C",002,000} )
Aadd( aFds , {"QTDSUM"   ,"N",010,002} )
Aadd( aFds , {"SEGUM"    ,"C",002,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP2 New Exclusive

Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ FiltraOPs()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function FiltraOPs()
local cQuery

cQuery := "SELECT SC2.C2_PRODUTO, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, "
cQuery += "SC2.C2_QUANT,SC2.C2_QTSEGUM,SC2.C2_QUJE,SC2.C2_PERDA, "
cQuery += "SC2.C2_STATUS,SC2.C2_TPOP, B1_UM, B1_SEGUM, "
cQuery += "SC2.R_E_C_N_O_ SC2RECNO "
cQuery += "FROM "
cQuery += RetSqlName("SC2")+" SC2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE "
cQuery += "SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "
cQuery += "SC2.C2_DATPRI BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND "
cQuery += "SC2.C2_EXTRUSO='"+MV_PAR03+"' AND "
cQuery += "SC2.C2_SEQUEN = '001' AND SC2.C2_PRODUTO = SB1.B1_COD AND "
cQuery += "SC2.D_E_L_E_T_ = ' '  AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY SC2.C2_NUM"
cQuery := ChangeQuery(cQuery)

If Select("SC2X") > 0
	SC2X->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC2X",.T.,.T.)

if !SC2X->(EOF())

   while SC2X->(!EOF())

      RecLock('TMP',.T.)	
      TMP->OP        := SC2X->C2_NUM
      TMP->PROD      := SC2X->C2_PRODUTO
      TMP->QTDUM     := SC2X->C2_QUANT
      TMP->UM        := SC2X->B1_UM
      TMP->QTDSUM	 := SC2X->C2_QTSEGUM
      TMP->SEGUM     := SC2X->B1_SEGUM
      TMP->DESCRICAO := Substr(POSICIONE ("SB1", 1, xFilial("SB1") + SC2X->C2_PRODUTO, "B1_DESC"),1,50)
      TMP->(MsUnLock())

      SC2X->(dbSkip())
   enddo

else

 ALERT('Nao a Dados para essa Consulta!!!')
 TMP->(dbCloseArea())
 return .F.

endif

TMP->(DbGoTop())

If Select("SC2X") > 0
	SC2X->(dbCloseArea())
EndIf


Return .T.

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oPerg1() - Cria grupo de Perguntas.
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oPerg1(cperg)

Local aHelpPor := {}

PutSx1( cperg,'01','OP Inicia de  ?','','','mv_ch1','D' ,8,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cperg,'02','OP Inicia até ?','','','mv_ch2','D' ,8,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cperg,'03','Extrusora     ?' ,'','','mv_ch3','C',6,0,0,'G','','SH1A','','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,{},{} )

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMPMark() - Funcao para marcar o Item MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMPMark()

Local lDesMarca := IsMark("OK", cMarca, .F. )

RecLock("TMP", .F.)
if !lDesmarca
   TMP->OK := "  "
else
   TMP->OK := cMarca
endif


TMP->(MsUnlock())

return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMPMkaLL() - Funcao para marcar todos os Itens MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMPMkAll()

local nRecno := TMP->(Recno())

TMP->(DbGotop())
while ! TMP->(EOF())
   RecLock("TMP",.F.)
   if Empty(TMP->OK)
      TMP->OK := cMarca
   else
      TMP->OK := "  "
   endif
   TMP->(MsUnlock())
   TMP->(DbSkip())
end
TMP->(DbGoto(nRecno))

return .T.


***************
Static Function Fcomeca()
***************

Local cQry:=''
local cRet :=''
local cArmExt:=''


//cQry:="select ISNULL(MAX(ZZB_LOTE),'') LOTE ,ZZB_STATUS  "
cQry+="select top 1 ZZB_LOTE LOTE,ZZB_STATUS  "
cQry+="from "+RetSqlName("ZZB")+" ZZB "
cQry+="WHERE  "

IF ALLTRIM(MV_PAR03)='E01'

   cQry+="SUBSTRING(ZZB_LOTE,7,2)='10' "
   cArmExt:='10'

ELSEIF ALLTRIM(MV_PAR03)='E02'

   cQry+="SUBSTRING(ZZB_LOTE,7,2)='20' "
   cArmExt:='20'
   
ELSEIF ALLTRIM(MV_PAR03)='E03'

   cQry+="SUBSTRING(ZZB_LOTE,7,2)='30' "
   cArmExt:='30'
   
ELSEIF ALLTRIM(MV_PAR03)='E04'

   cQry+="SUBSTRING(ZZB_LOTE,7,2)='40' "
   cArmExt:='40'
   
ELSEIF ALLTRIM(MV_PAR03)='E05'

   cQry+="SUBSTRING(ZZB_LOTE,7,2)='50' "
   cArmExt:='50'

ENDIF

cQry+=" AND ZZB.D_E_L_E_T_='' "
//cQry+="group by ZZB_STATUS  "
cQry+="ORDER BY R_E_C_N_O_ DESC "


If Select("AUX1") > 0
  DbSelectArea("AUX1")
  AUX1->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX1"


_cDate:=SubStr(DtoS(Date()),5,2)+SubStr(DtoS(Date()),3,2)
_cDateAM:=SubStr(DtoS(Date()),3,2)+SubStr(DtoS(Date()),5,2)

iF  ! empty(AUX1->LOTE)
    
     IF AUX1->ZZB_STATUS<>'F'
     
        ALERT("Favor Finalizar o lote.: "+AUX1->LOTE+" para Gerar outro para Extrusora.: "+alltrim(MV_PAR03) )
        Return cRet
     
     ENDIF
     
//     if _cDate> SUBSTR(AUX1->LOTE,3,4)
       if _cDateAM > SUBSTR(AUX1->LOTE,5,2)+SUBSTR(AUX1->LOTE,3,2)

        // contator+MesAno+armazem da Extrusora
        cRet:='01'+_cDate+alltrim(cArmExt)

     else

	     cSeq:=VAL(SUBSTR(AUX1->LOTE,1,2))+1
	    // contator+MesAno+armazem da Extrusora
	     cRet:=strzero(cSeq,2)+SUBSTR(AUX1->LOTE,3,6)
	

     endif
    
ELSE
     
     // contator+MesAno+armazem da Extrusora
     cRet:='01'+_cDate+alltrim(cArmExt)

    
ENDIF

AUX1->(DbCloseArea())



Return cRet


***************

Static Function FOk()

***************
local cntM:=0
local cntNM:=0
local cnt:=0

Begin Transaction
		
	RecLock( "ZZB", .T. )    
    ZZB->ZZB_LOTE:= ALLTRIM(oSay1:cCaption)
    ZZB->ZZB_USER:=cUserName
    ZZB->ZZB_DATA:=DATE()
    ZZB->ZZB_HORA:=Left( Time(), 5 )
    ZZB->( MsUnlock() )
	
	
	TMP->(dbGoTop())
	while TMP->(!Eof())
		if TMP->OK == cMarca
            
            If fvldOP(TMP->OP)  // valida se Ja Existe OP em algum Lote 
			   
			   DisarmTransaction()
			   TMP->(dbGoTop())			
			   return 
			
			Endif
			
			aOPPI:=FOPPI(TMP->OP)		    
			RecLock( "ZZC", .T. )    
            ZZC->ZZC_LOTE   := ALLTRIM(oSay1:cCaption)
		    ZZC->ZZC_OP     := ALLTRIM(TMP->OP)//+'01001' 
		    ZZC->ZZC_PRODPA := TMP->PROD
		    ZZC->ZZC_OPPI   := aOPPI[1]
		    ZZC->ZZC_PRODPI := aOPPI[2]

		    ZZC->ZZC_QTDUM    :=TMP->QTDUM    
		    ZZC->ZZC_UM       :=TMP->UM        
		    ZZC->ZZC_QTDSUM   :=TMP->QTDSUM	  
		    ZZC->ZZC_SEGUM    :=TMP->SEGUM     
		
		    		    
		    ZZB->( MsUnlock() )	 

		    cntM+=1	
		    
		else
		
		    cntNM+=1
		
		endif
		
		cnt+=1
		TMP->(dbSkip())
		
	enddo
	
IF cnt=cntNM

   alert('Marque pelo menos uma OP!!!')
   DisarmTransaction()
   TMP->(dbGoTop())
   return 

endif    

End Transaction


oDlg1:End()

Return

***************

Static Function Ffecha()

***************


oDlg1:End()

Return   


***************

Static Function FOPPI(cOP)

***************

Local cQry:=''
local aRet :={}


cQry:="SELECT D4_OPORIG,D4_COD FROM "+RetSqlName("SD4")+" SD4 "
cQry+="WHERE "
cQry+="D4_FILIAL='"+xfilial('SD4')+"' "
cQry+="AND D4_OP='"+alltrim(cOP)+'01001'+"' "
cQry+="AND LEFT(D4_COD,2)='PI'  "
cQry+="AND SD4.D_E_L_E_T_='' "


If Select("AUX2") > 0
  DbSelectArea("AUX2")
  AUX2->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX2"

iF  AUX2->(!EOF())
    
     //cRet:=AUX2->D4_OPORIG
     Aadd( aRet, AUX2->D4_OPORIG )
     Aadd( aRet, AUX2->D4_COD )
ELSE         
     Aadd( aRet, "" )
     Aadd( aRet, "" )

ENDIF

AUX2->(DbCloseArea())



Return aRet


*************

User Function FLegLo()

*************

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERDE" ,	"Lote Em Aberto"},;
									{"BR_AMARELO" ,	"Lote Encerrado a Contagem"},;
									{"BR_VERMELHO", "Lote Finalizado"}	 } )

Return .T.		


*************

User Function FCdModeLo(cAlias,nReg,nOpc)

*************

Local nOpca := 0, nCnt := 0, nSavReg
Local oDlg, lModelo2 := .F., nCpoTela
Local nOrdSx3 := Sx3->(IndexOrd())
Local cCpoMod2  := ""
Local nHeader   := 0
local _nPos
Private Inclui	:= .F.
Private Altera	:= .F.
Private Exclui	:= .F.
Private Visual	:= .F.
Private cPref, cPref1
Private oGetD, cContador

nOpc:=2 // sempre visualizar 

cAlias1  := If(Type("cAlias1") = "U" .Or. cAlias1 = Nil, cAlias, cAlias1)
lModelo2 := If(cAlias1 = cAlias, .T., .F.)

//Prefixos das tabelas
cPref := (cAlias)->(FieldName(1))
_nPos := At("_",cPref)
cPref := Substr( cPref, 1, _nPos - 1 )

cPref1 := (cAlias1)->(FieldName(1))
_nPos := At("_",cPref1)
cPref1 := Substr( cPref1, 1, _nPos - 1 )


If Type("aSize") = "U" .Or. aSize = Nil
	Private aSize		:= MsAdvSize(,.F.,430)
	Private aObjects 	:= {}
	Private aPosObj  	:= {}
	Private aSizeAut 	:= MsAdvSize()
	
	If lModelo2
		AAdd( aObjects, { 315, aPosTela[1][2] + 20      , .T., .T. } )
		AAdd( aObjects, { 100, 430 - aPosTela[1][2] - 20, .T., .T. } )
	Else
		AAdd( aObjects, { 315, 100, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )
	Endif
	
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	
	aPosObj := MsObjSize( aInfo, aObjects, lModelo2 )
Endif

Do Case
	Case nOpc = 2
		Visual 	:= .T.
	Case nOpc = 3
		Inclui 	:= .T.
		Altera 	:= .F.
	Case nOpc = 4
		Inclui 	:= .F.
		Altera 	:= .T.
	Case nOpc = 5
		Exclui	:= .T.
		Visual	:= .T.
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)

IF ! INCLUI .And. LastRec() == 0
	Help(" ",1,"A000FI")
	Return (.T.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta' na filial correta                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! INCLUI .And. xFilial(cAlias) != &(cPref + "_FILIAL")
	Help(" ",1,"A000FI")
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0],aGETS[0],aHeader[0]
PRIVATE nUsado:=0,lTab   := .F.

If ! lModelo2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a integridade dos campos de Bancos de Dados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALTERA .Or. EXCLUI
		SoftLock(cAlias)
	Endif
	
	CdaMemory(cAlias)
Else
	Private aChaves	:= {}
	SX3->(DbSetOrder(2))
	For nCpoTela := 1 to Len(aPosTela)
		cCpoMod2 += aPosTela[nCpoTela][1] + ";"
		Aadd(aChaves, { aPosTela[nCpoTela][1], "M->" + aPosTela[nCpoTela][1] })
		
		// Bloco CdaMemory
		
		SX3->(DbSeek(aPosTela[nCpoTela][1]))
		
		If SX3->X3_CONTEXT = "V" 	// Campo virtual
			If ! Empty(SX3->X3_INIBRW)
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), &(AllTrim(SX3->X3_INIBRW)))
			Else
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
			Endif
		Else
			If INCLUI
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
			Else
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), (cAlias)->&(Trim(SX3->X3_CAMPO)))
			EndIf
		Endif
	Next
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta cabecalho.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek( cAlias1 )
While !Eof() .And. x3_arquivo == cAlias1
	IF X3USO(x3_usado) .And. cNivel >= x3_nivel .And. ! X3_CAMPO $ cCpoMod2
		nUsado++
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo,;
		x3_context, x3_nivel, x3_relacao, Trim(x3_inibrw) } )
	Endif
	dbSkip()
End

If Type('cChave') = "U" .Or. cChave = Nil
	cChave  := (cAlias)->(IndexKey(1))
	cChave  := Subs(cChave, At(cChave, "_FILIAL") + 12)
Endif
If Type('cChave1') = "U" .Or. cChave1 = Nil
	If lModelo2
		cChave1 := cChave
	Else
		cChave1 := StrTran(cChave, cAlias, cAlias1)
	Endif
Endif

If Len(cChave1) # Len(cChave) .And. ! lModelo2
	cChave := Left(cChave, Len(cChave1))
Endif

dbSelectArea(cAlias1)
dbSetOrder(1)

MsSeek(xFilial(cAlias1) + &(cChave))
nSavReg := Recno()

nCnt := 0
While ! INCLUI .And. !Eof() .And. xFilial(cAlias) + &(cChave) ==;
	xFilial(cAlias1) + &(cChave1)
	nCnt++
	dbSkip()
End

If ! INCLUI .And. ((Type("lSemItens") = "U" 	.Or.;
	lSemItens = Nil) 	.Or. ! lSemItens)	// Indica se verifica existencia dos
	If nCnt == 0                               						// itens
		cHelp := "Não existe(m) item(s) no "+cAlias1+" para este Registro no "+cAlias+"."
		
		Help( ''  , 1 , 'NVAZIO' ,OemToAnsi( "ITENS" ) ,OemToAnsi( cHelp ), 1 , 0 )
		Return .T.
	Endif
Endif

nCnt := If(nCnt = 0, 1, nCnt)

PRIVATE aCOLS[nCnt][nUsado + 1]

dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nSavReg)
nCnt := 0

While 	! INCLUI .And. ! Eof() .And.;
	xFilial(cAlias) + &(cChave1) == xFilial(cAlias1) + &(cChave)
	
	nUsado 	:= 0
	nCnt++
	
	For nHeader := 1 To Len(aHeader)
		If X3USO(aHeader[nHeader][7]) .And. cNivel >= aHeader[nHeader][11]
			nUsado++
			If aHeader[nHeader][10] = "V"				// Campo virtual
				If ! Empty(aHeader[nHeader][13])		// inicializador BROWSE
					aCOLS[nCnt][nUsado] := &(aHeader[nHeader][13])
				Endif
			ElseIf INCLUI
				aCOLS[nCnt][nUsado] := CriaVar(AllTrim(aHeader[nHeader][2]))
				If "_ITEM" $ aHeader[nHeader][2]
					aCOLS[nCnt][nUsado] := StrZero(nCnt, Len(aCOLS[nCnt][nUsado]))
				Endif
			Else
				aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])
			Endif
		Endif
	Next
	aCOLS[nCnt][nUsado + 1] := .F.
	
	If ALTERA .Or. EXCLUI
		SoftLock(cAlias1)
	Endif
	
	DbSkip()
Enddo

If nCnt = 0
	nCnt ++
	nUsado := 0
	For nHeader := 1 To Len(aHeader)
		If X3USO(aHeader[nHeader][7]) .And. cNivel >= aHeader[nHeader][11]
			nUsado++
			If aHeader[nHeader][10] = "V"				// Campo virtual
				If ! Empty(aHeader[nHeader][13])		// inicializador BROWSE
					aCOLS[nCnt][nUsado] := &(aHeader[nHeader][13])
				Endif
			ElseIf INCLUI
				aCOLS[nCnt][nUsado] := CriaVar(AllTrim(aHeader[nHeader][2]))
				If "_ITEM" $ aHeader[nHeader][2]
					aCOLS[nCnt][nUsado] := StrZero(nCnt, Len(aCOLS[nCnt][nUsado]))
				Endif
			Else
				aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])
			Endif
		Endif
	Next
	aCOLS[nCnt][nUsado + 1] := .F.
Endif

dbSelectArea(cAlias1)

If FieldPos(cPref1 + "_ITEM") > 0
	cContador := "+" + cPref1 + "_ITEM"
Endif

If Type("cLinhaOk") = "U" .Or. cLinhaOk = Nil
	cLinhaOk := "AllwaysTrue()"
Endif

If Type("cTudoOk") = "U" .Or. cTudoOk = Nil
	cTudoOk := "AllwaysTrue()"
Endif

dbSetOrder(1)
dbGoTo(nSavReg)

If ( Type("lCdaAuto") == "U" .OR. !lCdaAuto )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	If ! lModelo2
		EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1], , 3, , , , , , .T. )
	Else
		SX3->(DbSetOrder(2))
		For nCpoTela 	:= 1 to Len(aPosTela)
			cCampo		:= aPosTela[nCpoTela][1]
			SX3->(DbSeek(cCampo))
			nX			:= aPosTela[nCpoTela][2]
			nY			:= aPosTela[nCpoTela][3]
			cCaption	:= X3Titulo()
			cPict		:= If(Empty(SX3->X3_PICTURE),Nil,SX3->X3_PICTURE)
			cValid		:= If(Empty(SX3->X3_VALID),".t.",SX3->X3_VALID)
			cF3			:= If(Empty(SX3->X3_F3),NIL,SX3->X3_F3)
			cWhen		:= If(Empty(SX3->X3_WHEN),"(.t.)","(" +;
			AllTrim(SX3->X3_WHEN) + ")")
			If Len(aPosTela[nCpoTela]) > 3
				cWhen += " .And. (" + aPosTela[nCpoTela][4] + ")"
			Endif
			cBlKSay 	:= "{|| OemToAnsi('"+cCaption+"')}"
			oSay 		:= TSay():New( nX + 1, nY, &cBlkSay,oDlg,,, .F., .F., .F., .T.,,,,, .F., .F., .F., .F., .F. )
			nLargSay 	:= GetTextWidth(0,cCaption) / 1.8  // estava 2.2
			cCaption 	:= oSay:cCaption
			cBlkGet 	:= "{ | u | If( PCount() == 0, M->"+cCampo+", M->"+cCampo+":= u ) }"
			cBlKVld 	:= "{|| "+cValid+"}"
			cBlKWhen 	:= "{|| "+cWhen+"}"
			oGet 		:= TGet():New( nX, nY+nLargSay,&cBlKGet,oDlg,,,cPict, &(cBlkVld),,,, .F.,, .T.,, .F., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,(cCampo))
		Next
		
		Sx3->(DbSetOrder(nOrdSx3))
	Endif

	oGetd := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .T.)
	lTab  := .T.
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(if(!lModelo2,Obrigatorio(aGets,aTela),.T.).and.oGetd:TudoOk(),oDlg:End(),nOpca := 0) }, { || if(Inclui.AND.__lSX8,RollBackSX8(),),oDlg:End() })
else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ validando dados pela rotina automatica                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Altera
	if EnchAuto(cAlias,aAutoCab,{|| if(!lModelo2,Obrigatorio(aGets,aTela),.T.)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,cLinhaOk,{||&(cTudoOk)},aAutoCab,aRotina[nOpc][4])
		nOpcA := 1
	endif
endif

If nOpca = 1 .And. nOpc # 2
	BEGIN TRANSACTION
    	
	If nOpc = 5 .And. (Type("cPodeExcluir") = "U" .Or. Empty(cPodeExcluir) .Or.;
		&(cPodeExcluir))
		ApagMod(cAlias, cAlias1)
	ElseIf nOpc # 5
		GravMod(cAlias, cAlias1)
	Endif
	
	END TRANSACTION
Endif

dbSelectArea(cAlias)

Return nOpca

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvModelo ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 21/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para gravacao em formato Modelo 2 ou 3          	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GrvModelo(cPar1, cPar2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpC1 = Alias detalhe do arquivo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GravMod(cAlias,cAlias1)

Local nCampos, nHeader, nMaxArray, bCampo, aAnterior:={}, nItem := 1
Local lModelo2 := cAlias = cAlias1
Local nChaves := 0
Local nSaveSX8Z5:= GetSX8Len()

bCampo := {|nCPO| Field(nCPO) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se o ultimo elemento do array esta em branco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(aCols)

If ! lModelo2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava arquivo PRINCIPAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	
	RecLock(cAlias, If(INCLUI,.T.,.F.))
	
	For nCampos := 1 TO FCount()
		If "FILIAL"$Field(nCampos)
			FieldPut(nCampos,xFilial(cAlias))
		Else
			FieldPut(nCampos,M->&(EVAL(bCampo,nCampos)))
		EndIf
	Next
    //ConfirmSX8()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega ja gravados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias1)
If ! INCLUI .And. MsSeek(xFilial(cAlias1)+&(cChave))
	While !Eof() .And. xFilial(cAlias) + &(cChave1) == xFilial(cAlias1) + &(cChave)
		Aadd(aAnterior,RecNo())
		dbSkip()
	Enddo
Endif

dbSelectArea(cAlias1)
nItem := 1

For nCampos := 1 to nMaxArray
	
	If Len(aAnterior) >= nCampos
		If ! INCLUI
			DbGoto(aAnterior[nCampos])
		EndIf
		RecLock(cAlias1,.F.)
	Else
		RecLock(cAlias1,.T.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tem marcacao para apagar.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCols[nCampos][Len(aCols[nCampos])]
		RecLock(cAlias1,.F.,.T.)
		dbDelete()
	Else
		For nHeader := 1 to Len(aHeader)
			If aHeader[nHeader][10] # "V" .And. ! "_ITEM" $ AllTrim(aHeader[nHeader][2])
				Replace &(Trim(aHeader[nHeader][2])) With aCols[nCampos][nHeader]
			ElseIf "_ITEM" $ AllTrim(aHeader[nHeader][2])
				Replace &(AllTrim(aHeader[nHeader][2])) With StrZero(nItem ++,;
				Len(&(AllTrim(aHeader[nHeader][2]))))
			Endif
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza as chaves de itens ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Type("aChaves") # "U" .Or. aChaves # Nil
			Replace &(cPref1 + "_FILIAL") With xFilial(cAlias1)
			For nChaves := 1 To Len(aChaves)
				Replace &(aChaves[nChaves][1]) With &(aChaves[nChaves][2])
			Next
		Endif
		
		dbSelectArea(cAlias1)
	Endif
	
Next nCampos

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DelModelo3³ Autor ³ Wagner Mobile Costa   ³ Data ³ 21/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para delecao em formato Modelo 2 ou 3          	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DelModelo(cPar1, cPar2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpC1 = Alias detalhe do arquivo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ApagMod(cAlias,cAlias1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta os itens ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAlias1 )
MsSeek(xFilial(cAlias1) + &(cChave))
While !Eof() .And. xFilial(cAlias) + &(cChave1) == xFilial(cAlias1) + &(cChave)
	RecLock(cAlias1,.F.,.T.)
	dbDelete()
	dbSkip()
End

If cAlias # cAlias1    	// Se igual eh modelo 2, ou seja nao tem cabecalho
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deleta o cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	RecLock(cAlias,.F.,.T.)
	dbDelete()
	dbSelectArea(cAlias)
Endif

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CdaPrivate³ Autor ³ Wagner Mobile Costa   ³ Data ³ 03/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Zera as privates para uso da funcao CdaModelo         	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CdaPrivate()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CdaPrivate

aSize			:= Nil		// Objeto Bes
cChave			:= Nil		// Chave do arquivo principal
cChave1			:= Nil		// Chave do arquivo detalhe
lSemItens   	:= Nil		// Nao ter itens para aCols
aChaves 		:= Nil		// Campos CHAVES
cLinhaOk		:= Nil		// Verifica da Linha aCols
cTudoOk			:= Nil		// Verifica ao GRAVAR
cPodeExcluir	:= ""		// Verifica se pode ser excluido
cAlias1			:= Nil		// Alias de detalhe se Modelo2 = Nil
aPosTela		:= Nil		// Posicoes dos campos principais modelo 2

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³CdaMemory   ³ Autor ³ Wagner Mobile       ³ Data ³ 04/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria variaveis M-> para uso na Enchoice()					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Enchoice												  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CdaMemory(cAlias)

SX3->(DbSetOrder(1))
SX3->(MsSeek(cAlias))

While ! SX3->(Eof()) .And. SX3->x3_arquivo == cAlias
	If SX3->X3_CONTEXT = "V" 	// Campo virtual
		If ! Empty(SX3->X3_INIBRW)
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), &(AllTrim(SX3->X3_INIBRW)))
		Else
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
		Endif
	Else
		If INCLUI
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
		Else
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), (cAlias)->&(Trim(SX3->X3_CAMPO)))
		EndIf
	Endif
	SX3->(DbSkip())
EndDo

Return .T.

***************

Static Function fvldOP(cOP)

***************

Local cQry:=''
Local lRet:=.F.

cQry:="SELECT OP=left(ZZC_OP,6),LOTE=ZZC_LOTE FROM "+RetSqlName("ZZC")+" ZZC "
cQry+="where left(ZZC_OP,6)='"+cOP+"' "
cQry+="and ZZC.D_E_L_E_T_='' "

If Select("AUX3") > 0
  DbSelectArea("AUX3")
  AUX3->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUX3"

If  AUX3->(!EOF())
    
    Alert('Essa OP.: '+AUX3->OP+' Ja existe no Lote.: '+AUX3->LOTE)
    lRet:=.T.
Endif

AUX3->(DbCloseArea())


Return lRet


/////  funcao para montar a tela para contagem dos protudos por lote 

*************

User Function FTLCONTLO()

*************


Local nOpc := 2//GD_UPDATE //GD_INSERT+GD_DELETE+GD_UPDATE
Private aHoBrw1 := {}
Private aCoBrw1 := {}
Private noBrw1  := 4
PRIVATE cFColsG:= 'QTDDIG/'



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgEs","oBrw1","oSBtn1","oSayE1","oSayE2","oFont1")


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-24,,.F.,0,,400,.F.,.F.,,,,,, )
oDlgEs     := MSDialog():New( 148,273,648,1051,"Contagem Lote ",,,.F.,,,,,,.T.,,,.F. ) 
oSayE1      := TSay():New( 024,048,{||"oSay1"},oDlgEs,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,302,020)
oSayE2      := TSay():New( 024,016,{||"Lote:"},oDlgEs,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,020)


IF !EMPTY(ZZB->ZZB_STATUS)
    
    cFColsG:= ''
    
    IF ZZB->ZZB_STATUS='E'
       oSay3      := TSay():New( 212,016,{||"Contagem Já Encerrada"},oDlgEs,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,249,020)
	ELSE
       oSay3      := TSay():New( 212,016,{||"Lote Já Finalizado"},oDlgEs,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,249,020)	
	ENDIF
	
	oBtn1      := TButton():New( 212,338,"Fechar",oDlgEs,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {|| oDlgEs:end() }
      
ELSE

	oBtn1      := TButton():New( 212,338,"Confirmar",oDlgEs,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {||fconfima()}
	
ENDIF



// funcao que alimenta o grid com os produtos do lote 
fgetCont()

MHoBrw1()
oBrw1      := MsNewGetDados():New(053,016,195,375,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsG,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oDlgEs,aHoBrw1,aCoBrw1 )
MCoBrw1()


oDlgEs:Activate(,,,.T.)


If Select("TMPX") > 0
   TMPX->(dbCloseArea())	
EndIf


Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: <Inform Alias>
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
***************

Static Function MHoBrw1()

***************

Local aAux := {} 

Aadd( aHoBrw1 , {"Codigo"			,"COD"		,"@!"			       ,006,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"Descricao"		,"DESC"	    ,"@!"			       ,050,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"Qtd Fisica"		,"QTDDIG"	,"@E 999,999,999.9999" ,017,004,"AllwaysTrue()","û","N"} )


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
   	
   	oBrw1:aCols[Len(oBrw1:aCols)][03] := iif(EMPTY(ZZB->ZZB_LOTE),CriaVar("B2_QATU"),TMPX->QTDDIG)
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
Aadd( aFds , {"QTDDIG"  ,"N",017,004} )
Aadd( aFds , {"QTDLOTE" ,"N",014,004} )

cTRAB := CriaTrab( aFds, .T. )
Use (cTRAB) Alias &cTAB New Exclusive
IndRegua(cTAB,cTRAB,"COD",,,'Selecionando Registros...') //'Selecionando Registros...'

Return

****************

Static Function fgetCont()

****************

fCriaTAB()

_cLote:=ZZB->ZZB_LOTE

oSayE1:cCaption:=_cLote

cOps:=" "

DbSelectArea("ZZC")
DbSetOrder(1)

IF ZZC->( DbSeek( XFILIAL('ZZC') + _cLote ) )

	while ZZC->(!Eof()) .AND. ZZC->ZZC_FILIAL=XFILIAL('ZZC') .AND.ZZC->ZZC_LOTE==_cLote            
			cOps += "'"+ZZC->ZZC_OP+"',"
		    ZZC->(dbSkip())
	enddo

ELSE

   alert('Esse Nao e um Lote Valido!!!')
   return

ENDIF	

ZZC->(DbCloseArea())

if !Empty(cOps) 
   
   MsAguarde({|| DadosImp()},"Aguarde...","Processando Dados...")      
   

	Do While OPX->(!EOF())
	
	   RecLock("TMPX", .T.)
	
	   TMPX->COD     :=OPX->PROD 
	   TMPX->DESC    :=OPX->DESCR	
	   TMPX->QTDLOTE :=OPX->QUANT
	   	   
	   If !EMPTY(ZZB->ZZB_STATUS)
	   
	      TMPX->QTDDIG :=OPX->ZZD_QTDFI
	   
	   Endif
	   
	   TMPX->(MsUnLock())
	
	   OPX->(dbskip())
	
	EndDO
	
    If Select("OPX") > 0
   	   
   	   OPX->(dbCloseArea())
    
    EndIf
   
else

   alert('Lote sem OP !!!')
   return


endif


Return


***************

static function DadosImp()

***************
LOCAL cQuery := ""

   IF !EMPTY(ZZB->ZZB_STATUS)
   
       cQuery := "select ZZD_PROD PROD, B1_DESC DESCR, ZZD_QTDFI,ZZD_QTDLOT QUANT  from "+RetSqlName("ZZD")+" ZZD ,"+RetSqlName("SB1")+" SB1 "
	   cQuery += "WHERE ZZD_LOTE='"+ZZB->ZZB_LOTE+"' "
	   cQuery += "AND ZZD_PROD=B1_COD "
	   cQuery += "AND ZZD.D_E_L_E_T_ <> '*' "
	   cQuery += "AND SB1.D_E_L_E_T_ <> '*' "
		
   ELSE
   
	   cOps := Substr(cOps,1,Len(cOps)-1)

	   cQuery := "SELECT PROD,DESCR, QUANT=SUM(QUANT) "
	   cQuery += "FROM( "
	   cQuery += "SELECT "
	   cQuery += "  PROD=SD4.D4_COD, DESCR=SB1.B1_DESC, QUANT=SUM(SD4.D4_QTDEORI) "
	   cQuery += "FROM "
	   cQuery += "   "+RetSqlName("SC2")+" SC2, "+RetSqlName("SD4")+" SD4, "+RetSqlName("SB1")+" SB1 "
	   cQuery += "WHERE "
	   cQuery += "   SC2.C2_NUM IN ("+cOps+") AND " //
	   cQuery += "   SC2.C2_SEQPAI = '001' AND LEFT(SC2.C2_PRODUTO,2) = 'PI' AND LEFT(SC2.C2_PRODUTO,3) <> 'PII' AND "
	   cQuery += "   SD4.D4_FILIAL = SC2.C2_FILIAL AND "
	   cQuery += "   SD4.D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND "
	   cQuery += "   SD4.D4_COD = SB1.B1_COD AND "
	   cQuery += "   SB1.B1_TIPO = 'MP' AND "
	   cQuery += "   SD4.D_E_L_E_T_ <> '*' AND "
	   cQuery += "   SC2.D_E_L_E_T_ <> '*' AND "
	   cQuery += "   SB1.D_E_L_E_T_ <> '*' "
	   cQuery += "GROUP BY "
	   cQuery += "   SD4.D4_COD, SB1.B1_DESC "
	
	   cQuery += "UNION "
	
	   cQuery += "SELECT "
	   cQuery += "  PROD=SD4.D4_COD, DESCR=SB1.B1_DESC, QUANT=SUM(SD4.D4_QTDEORI) "
	   cQuery += "FROM "
	   cQuery += "   "+RetSqlName("SC2")+" SC2, "+RetSqlName("SD4")+" SD4, "+RetSqlName("SB1")+" SB1 "
	   cQuery += "WHERE "
	   cQuery += "   SC2.C2_NUM IN ("+cOps+") AND " //
	   cQuery += "   LEFT(SC2.C2_PRODUTO,2) = 'PI' AND "
	   cQuery += "   ( ( SELECT LEFT(C2X.C2_PRODUTO,2) "
	   cQuery += "       FROM "+RetSqlName("SC2")+" C2X " 
	   cQuery += "       WHERE  C2X.C2_FILIAL + C2X.C2_NUM + C2X.C2_ITEM + C2X.C2_SEQUEN = SC2.C2_FILIAL + SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQPAI AND "
	   cQuery += "       C2X.D_E_L_E_T_ <> '*' ) = 'PI' AND "
	   cQuery += "     ( SELECT C2X.C2_SEQPAI "
	   cQuery += "       FROM "+RetSqlName("SC2")+" C2X "
	   cQuery += "       WHERE  C2X.C2_FILIAL + C2X.C2_NUM + C2X.C2_ITEM + C2X.C2_SEQUEN = SC2.C2_FILIAL + SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQPAI AND "
	   cQuery += "       C2X.D_E_L_E_T_ <> '*' ) = '001' ) AND "
	   cQuery += "   SD4.D4_FILIAL = SC2.C2_FILIAL AND "
	   cQuery += "   SD4.D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND "
	   cQuery += "   SD4.D4_COD = SB1.B1_COD AND "
	   cQuery += "   SB1.B1_TIPO = 'MP' AND "
	   cQuery += "   SD4.D_E_L_E_T_ <> '*' AND "
	   cQuery += "   SC2.D_E_L_E_T_ <> '*' AND "
	   cQuery += "   SB1.D_E_L_E_T_ <> '*' "
	   cQuery += "GROUP BY "
	   cQuery += "  SD4.D4_COD, SB1.B1_DESC "
	  // cQuery += "ORDER BY "
	  // cQuery += "   SD4.D4_COD "
	   cQuery += ") AS TABX "
	   cQuery += " GROUP BY PROD,DESCR "
	   cQuery += " ORDER BY    PROD "

ENDIF

   cQuery := ChangeQuery(cQuery)

   If Select("OPX") > 0
   	OPX->(dbCloseArea())
   EndIf

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"OPX",.T.,.T.)

return

***************

Static Function fconfima()

***************

if MsgBox( OemToAnsi( "Confirma o Encerramento Da Contagem do Lote ??" ), "Escolha", "YESNO" )       

	Begin Transaction
	
	
	RecLock("ZZB", .F.)
	
	ZZB->ZZB_STATUS  := 'E' // LOTE ENCERRADO 
	
	ZZB->(MsUnLock())
	
    DbSelectArea('TMPX')
    TMPX->(dbgoTop())
	
	For _X:=1 to len(oBrw1:aCols)
	
		RecLock("ZZD", .T.)
		
		TMPX->(DBSEEK (oBrw1:aCols[_X][1]))	
		
		ZZD->ZZD_LOTE   := alltrim(oSayE1:cCaption)
		ZZD->ZZD_PROD   := oBrw1:aCols[_X][1]
		ZZD->ZZD_QTDFI  := oBrw1:aCols[_X][3]
		ZZD->ZZD_QTDLOT := TMPX->QTDLOTE		
        ZZD->ZZD_DATAEN := DATE()
		
		ZZD->(MsUnLock())
	
	Next
	  
	End Transaction
	
	
	ALERT('Lote Encerrado com Sucesso!!!')
	oDlgEs:END()

endif

Return 

//// fim da tela da contagem 


*************
// AJUSTE DO LOTE 

User Function FTLAJLO()

*************

if ZZB->ZZB_STATUS='F' 
   alert('Lote( '+ZZB->ZZB_LOTE+' ) Já foi Finalizado')
   Return 
endif


if EMPTY(ZZB->ZZB_STATUS)
   alert('Nao Houve Inventario para esse Lote( '+ZZB->ZZB_LOTE+' ) !!!')
   Return 
endif



if MsgBox( OemToAnsi( "Lote( "+ALLTRIM(ZZB->ZZB_LOTE)+" )  vai precisar de Ajuste ??" ), "Escolha", "YESNO" )       
   

   U_FTLAJULO(ZZB->ZZB_LOTE)
   
else

   if MsgBox(OemToAnsi("Confirma a Finalização do Lote ??" ), "Escolha", "YESNO" )       
	
		RecLock("ZZB", .F.)	
		ZZB->ZZB_STATUS  := 'F' // LOTE FINALIZADO 	
		ZZB->ZZB_DTFINA  :=DATE()
		ZZB->(MsUnLock())
		 
		 ALERT('Lote Finalizado com Sucesso!! ')
	
   endif

endif


Return 


*************

User Function FSaiOP()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
local lRet:=.T.
Local lCont	:= .T.
Private lOK    := .F.
Private cMarca2 := GetMark()

If !Empty(ZZB->ZZB_STATUS)
	
	MsgAlert("Só é permitido alterar lote aberto!")
	Return .f.

Else
	
	If !U_senha2( "13", 4, "AUTORIZAÇÃO PARA MANUTENÇÃO DE LOTE" )[ 1 ]
		MsgAlert("Sem permissão para alterar lote!")
		Return .f.
	EndIf
EndIf
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg2","oSay1","oBrw2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oFont1     := TFont():New( "MS Sans Serif",0,-24,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg2      := MSDialog():New( 126,254,626,1032,"Manutenção de Lote ",,,.F.,,,,,,.T.,,,.F. )

oSay1      := TSay():New( 024,048,{||"oSay1"},oDlg2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,302,020)
oSay2      := TSay():New( 024,016,{||"Lote:"},oDlg2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,020)

oTbl2()
DbSelectArea("TMP2")

oBrw2  := MsSelect():New( "TMP2","OK","",{{"OK"       ,"",""            ,""},;
                                         {"OP"       ,"","Ord.Producao",""},;
                                         {"PROD"     ,"","Produto"     ,""},;
                                         {"DESCRICAO","","Descricao"   ,""},;
                                         {"QTDUM"    ,"","Qtd.UM"      ,""},;
                                         {"QTDSUM"   ,"","Qtd.Seg.UM"  ,""}},.F.,cMarca2,{060,012,203,371},,, oDlg2 ) 
oBrw2:oBrowse:lHasMark    := .T.
oBrw2:oBrowse:lCanAllmark := .T.
oBrw2:oBrowse:nClrPane    := CLR_BLACK
oBrw2:oBrowse:nClrText    := CLR_BLACK
//oBrw2:oBrowse:bAllMark    := {||TMPMkAll()}
oBrw2:bMark               := {||TMP2Mark()}


MsAguarde({|| lRet:=ListaOPs()},"Aguarde...","Processando Dados...")

IF !lRet // caso a consulta retorne em branco, sem OP para o filtro 
   return 
EndIf

oSay1:cCaption := ZZB->ZZB_LOTE

if empty(oSay1:cCaption) // valido se o lote ja foi finalizado 
   TMP2->(DbCloseArea())
   return 
endif

oSBtn1     := SButton():New( 212,300,1,,oDlg2,,"", )
oSBtn1:bAction := {||fAtu()}
oSBtn2     := SButton():New( 212,345,2,,oDlg2,,"", )
oSBtn2:bAction := {||ffecha2()}

oDlg2:Activate(,,,.T.)


TMP2->(DbCloseArea())

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ ListaOPs()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function ListaOPs()
local cQuery


cQuery := "SELECT * FROM " + RetSqlName("ZZC") + " ZZC "
cQuery += "WHERE ZZC_LOTE = '" + ZZB->ZZB_LOTE + "' "
cQuery += "AND ZZC.D_E_L_E_T_= '' "
cQuery += "ORDER BY ZZC_OP DESC "

If Select("XC2X") > 0
	XC2X->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XC2X",.T.,.T.)

if !XC2X->(EOF())

   while XC2X->(!EOF())

      RecLock('TMP2',.T.)	
      TMP2->OP        := XC2X->ZZC_OP
      TMP2->PROD      := XC2X->ZZC_PRODPA
      TMP2->QTDUM     := XC2X->ZZC_QTDUM
      TMP2->UM        := XC2X->ZZC_UM
      TMP2->QTDSUM	 := XC2X->ZZC_QTDSUM
      TMP2->SEGUM     := XC2X->ZZC_SEGUM
      TMP2->DESCRICAO := Substr(POSICIONE ("SB1", 1, xFilial("SB1") + XC2X->ZZC_PRODPA, "B1_DESC"),1,50)
      TMP2->(MsUnLock())

      XC2X->(dbSkip())
   enddo

else

 ALERT('Nao a Dados para essa Consulta!!!')
 TMP2->(dbCloseArea())
 return .F.

endif

TMP2->(DbGoTop())

If Select("XC2X") > 0
	XC2X->(dbCloseArea())
EndIf


Return .T.


***************

Static Function fAtu()

***************
local cntM:=0
local cntNM:=0
local cnt:=0

Begin Transaction
		
	TMP2->(dbGoTop())
	while TMP2->(!Eof())

		if TMP2->OK == cMarca2
            
			dbSelectArea("ZZC")
			If dbSeek(xFilial("ZZC") + ZZB->ZZB_LOTE + TMP2->OP )
				
				RecLock( "ZZC", .F. ) 
				dbDelete()   
				ZZC->( MsUnlock() )	 
		    
		    EndIf
		    dbSelectArea("TMP2")
		endif
		
		TMP2->(dbSkip())
		
	enddo
	
End Transaction


oDlg2:End()

Return

***************

Static Function Ffecha2()

***************


oDlg2:End()

Return   

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMPMark() - Funcao para marcar o Item MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMP2Mark()

Local lDesMarca := IsMark("OK", cMarca2, .F. )

RecLock("TMP2", .F.)
if !lDesmarca
   TMP2->OK := "  "
else
   TMP2->OK := cMarca2
endif


TMP2->(MsUnlock())

return
