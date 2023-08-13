#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'


*************

User Function FTLAJULO(_cLote)

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cMarca := GetMark()
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlgAJ","oSay1","oBrw1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


oFont1     := TFont():New( "MS Sans Serif",0,-24,,.F.,0,,400,.F.,.F.,,,,,, )
oDlgAJ      := MSDialog():New( 126,254,626,1032,"Ajuste do Lote ",,,.F.,,,,,,.T.,,,.F. )

oSay1      := TSay():New( 024,048,{||"oSay1"},oDlgAJ,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,302,020)
oSay2      := TSay():New( 024,016,{||"Lote:"},oDlgAJ,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,020)


oTbl1()
DbSelectArea("TMP")
oBrw1  := MsSelect():New( "TMP","OK","",{{"OK"        ,"",""            ,""},;
                                         {"PROD"      ,"","Produto"     ,""},;                                         
                                         {"DESCRICAO" ,"","Descricao"     ,""},;                                                                                  
                                         {"QTDFI"     ,"","Qtd. Fisica"      ,"@E 999,999,999.9999"},;
                                         {"QTDEST"    ,"","Estoque "+SUBSTR(_cLote,7,2)      ,"@E 999,999,999.9999"},;                                         
                                         {"QTDAJ"     ,"","Qtd. a Ajustar"  ,"@E 999,999,999.9999"}},.F.,cMarca,{060,012,203,371},,, oDlgAJ ) 

oBrw1:oBrowse:lHasMark    := .T.
oBrw1:oBrowse:lCanAllmark := .T.
oBrw1:oBrowse:nClrPane    := CLR_BLACK
oBrw1:oBrowse:nClrText    := CLR_BLACK
oBrw1:oBrowse:bAllMark    := {||TMPMkAll()}
oBrw1:bMark               := {||TMPMark()}


MsAguarde({|| FiltraAJ(_cLote)},"Aguarde...","Processando Dados...")



oSay1:cCaption:=_cLote


oBtn1      := TButton():New( 212,335,"Confirmar",oDlgAJ,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||fOk(_cLote)}

oDlgAJ:Activate(,,,.T.)


TMP->(DbCloseArea()) 

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"OK"       ,"C",002,000} )
Aadd( aFds , {"PROD"     ,"C",015,000} )
Aadd( aFds , {"DESCRICAO","C",030,000} )
Aadd( aFds , {"QTDFI"    ,"N",012,002} )
Aadd( aFds , {"QTDEST"   ,"N",017,004} )
Aadd( aFds , {"QTDAJ"    ,"N",017,004} )


coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 


***************

Static Function FiltraAJ(_cLote)

***************

local cQuery


cQuery := "select ZZD_PROD PROD, B1_DESC DESCRI, ZZD_QTDFI,ZZD_QTDLOT QUANT  from "+RetSqlName("ZZD")+" ZZD ,"+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE ZZD_LOTE='"+_cLote+"' "
cQuery += "AND ZZD_PROD=B1_COD "
cQuery += "AND ZZD.D_E_L_E_T_ <> '*' "
cQuery += "AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY PROD "

cQuery := ChangeQuery(cQuery)

If Select("AJUX") > 0
	AJUX->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AJUX",.T.,.T.)

if !AJUX->(EOF())

   while AJUX->(!EOF())

      RecLock('TMP',.T.)	

      TMP->PROD      := AJUX->PROD
      TMP->QTDFI     := AJUX->ZZD_QTDFI 

      _nEstExt:=fEsto(AJUX->PROD,SUBSTR(_cLote,7,2))

      TMP->QTDEST    := _nEstExt
      TMP->QTDAJ     := AJUX->ZZD_QTDFI - _nEstExt
      TMP->DESCRICAO := Substr(AJUX->DESCRI,1,50)
      TMP->(MsUnLock())

      AJUX->(dbSkip())
   enddo

endif

TMP->(DbGoTop())

If Select("AJUX") > 0
	AJUX->(dbCloseArea())
EndIf


Return .T.


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

Static Function fEsto(cCod,cLocal)

***************

local cQry:=''
local nRet:=0

cQry:="SELECT B2_COD,B2_LOCAL,B2_QATU FROM "+RetSqlName("SB2")+" SB2  "
cQry+="WHERE "
cQry+="B2_FILIAL='01' "
cQry+="AND B2_COD='"+cCod+"' "
cQry+="AND B2_LOCAL='"+cLocal+"' "
cQry+="AND SB2.D_E_L_E_T_='' "

If Select("AUUX") > 0
	DbSelectArea("AUUX")
	AUUX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'AUUX'    

IF AUUX->(!EOF())

   nRet:= AUUX->B2_QATU  

ENDIF

AUUX->(DbCloseArea())

Return nRet

***************

Static Function fOk(_cLote)

***************
// 23 , 28 
if U_senha2( "23", 5 )[ 1 ] // so confirma o ajuste com senha de Marcelo.	
	
   MsAguarde({|| fAjuste(_cLote) },"Aguarde...","Processando Dados...")

Else
   
   Return
   
endif


Return  



***************

Static Function fAjuste(_cLote)

***************

Local aMATRIZC:={}
Local cAlmoPro:=substr(_cLote,7,2)
Local _cTM:=''
Local nQtdAj:=0
local cntM:=0
local cntNM:=0
local cnt:=0
Local dDtAju:=date()
/*
DbSelectArea('SB2')
SB2->(DbsetOrder(1))	   

DbSelectArea('TMP')
*/

Begin Transaction

	TMP->(dbGoTop())
	
	while TMP->(!Eof())
	
		If TMP->OK == cMarca
		
			if TMP->QTDAJ<0
	
			   _cTM  :='504' 
			   nQtdAj:=TMP->QTDAJ*-1
	
			Elseif TMP->QTDAJ>0
	
			   _cTM  :='104' 
			   nQtdAj:=TMP->QTDAJ
			
			Else

			   _cTM  :='' 
			   nQtdAj:=0
			
			endif
			
			if empty(_cTM)
			
			   alert('O item '+alltrim(TMP->PROD)+' Nao precisa de Ajuste')

   			   DisarmTransaction()
			   TMP->(dbGoTop())			

			   Return .F.
			
			endif
			
			/*
			SB2->(DbsetOrder(1))	   
		   	if ! SB2->( DbSeek(xFilial("SB2") + TMP->PROD + cAlmoPro, .F. ) )
			  CriaSB2(TMP->PROD , cAlmoPro)		   	  
		   	endIf	   	
			*/
				
			aMATRIZC     := { { "D3_TM"  , _cTM                                           , ""},;
			{ "D3_DOC"      , NextNumero( "SD3", 2, "D3_DOC", .T. )                       , NIL},;
			{ "D3_FILIAL"   , xFilial( "SD3" )                                            , NIL},;
			{ "D3_LOCAL"    , cAlmoPro                                                    , NIL },;
			{ "D3_COD"      , TMP->PROD                                                   , NIL},;
			{ "D3_UM"       , Posicione( "SB1", 1, xFilial("SB1") + TMP->PROD, "B1_UM" )  , NIL },;
			{ "D3_QUANT"    , nQtdAj                                                      , NIL },;
			{ "D3_EMISSAO"  , dDtAju                                                      , NIL},;
		    {"D3_OBS"    ,"LOTE "+ALLTRIM(_cLote)                                         ,	Nil}}
			
            lMsErroAuto:=.F.
			
			MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZC, 3 )
			IF lMsErroAuto
				
				DisarmTransaction()
				MostraErro()
				return .T.
				
			Endif

		    cntM+=1	

		Else

            cntNM+=1

		
		Endif

	    cnt+=1		
		TMP->(dbskip())
		
	Enddo 
	
//	SB2->(DbCloseArea())
		  
	IF cnt=cntNM
	
	   alert('Marque pelo menos um Produto !!!')
	   DisarmTransaction()
	   TMP->(dbGoTop())
	   return 
	
	endif    
	
	DbSelectArea("ZZB")
	DbSetOrder(1)
	
	IF ZZB->(DbSeek(xFilial('ZZB')+_cLote))
	
		RecLock("ZZB", .F.)
		ZZB->ZZB_STATUS  := 'F' // LOTE FINAIZADO
		ZZB->ZZB_DTFINA  :=dDtAju
		ZZB->ZZB_AJUSTE  :='S'
		ZZB->(MsUnLock())
	
	Else
	
	   alert('Lote '+alltrim(_cLote)+' nao Encontrado para ser Finalizado.' )
	   Return .T.
	
	Endif

End Transaction

oDlgAJ:END()


Return .F.





