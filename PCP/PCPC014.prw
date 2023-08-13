#include "protheus.ch"
#include "topconn.ch"

*************

User Function PCPC014(cOP,cMaq)

*************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Public _ltudook:=.T.
Private coTbl2
Private cMarca := GetMark()
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgLe","oBrw1","oGrp1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlgLe     := MSDialog():New( 127,254,622,697,"Verificacao Extrusora",,,.F.,,,,,,.T.,,,.F. )
oTbl2()
DbSelectArea("TMP2")
oBrw1      := MsSelect():New( "TMP2","MARCA","",{{"MARCA","","",""},;
{"CODIGO","","Codigo",""},;
{"DESC","","Descricao",""}},.F.,cMarca,{006,009,221,209},,, oDlgLe ) 
oBrw1:bAval := {||TMP2Mark()}
oBrw1:oBrowse:bAllMark := {||TMP2MkAll()}
oBrw1:oBrowse:lHasMark := .T.
oBrw1:oBrowse:lCanAllmark := .T.

oGrp1      := TGroup():New( 000,004,227,214,"",oDlgLe,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 230,177,"&Ok",oDlgLe,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction:={|| OK() }
GetLegen()     		

oDlgLe:Activate(,,,.T.)

TMP2->(DBCloseArea())  
if _ltudook
   dbselectarea('Z67')
   U_PCPC014()
ENDIF 
Ferase(coTbl2) // APAGA O ARQUIVO DO DISCO

Return .T.

****************

Static Function oTbl2()

***************

Local aFds := {}
Aadd( aFds , {"MARCA"   ,"C",002,000} )
Aadd( aFds , {"CODIGO"  ,"C",006,000} )
Aadd( aFds , {"DESC"   ,"C",055,000} )

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive
Return 

***************
Static Function GetLegen()
***************

TMP2->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 
dbSelectArea("SX5")
dbSetOrder(1)
If  SX5->(DbSeek(xFilial("SX5")+'Z8'))
    While SX5->(!EOF()) .AND. SX5->X5_TABELA=='Z8'      
     RecLock("TMP2",.T.)			     
     TMP2->CODIGO:=SX5->X5_CHAVE
     TMP2->DESC:=SX5->X5_DESCRI
     TMP2->(MsUnlock())
     SX5->(DBSKIP())
    ENDDO
Endif
TMP2->(DBGOTOP())

IF SELECT ('TMP2')>0
   dbSelectArea("SX5")
ENDIF

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2Mark() - Funcao para marcar o Item MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMP2Mark()

Local lDesMarca := TMP2->(IsMark("MARCA", cMarca))

RecLock("TMP2", .F.)
if lDesmarca
   TMP2->MARCA := "  "
else
   TMP2->MARCA := cMarca
endif


TMP2->(MsUnlock())

return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2MkaLL() - Funcao para marcar todos os Itens MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMP2MkAll()

local nRecno := TMP2->(Recno())

TMP2->(DbGotop())
while ! TMP2->(EOF())
   RecLock("TMP2",.F.)
   if Empty(TMP2->MARCA)
      TMP2->MARCA := cMarca
   else
      TMP2->MARCA := "  "
   endif
   TMP2->(MsUnlock())
   TMP2->(DbSkip())
end
TMP2->(DbGoto(nRecno))

return .T.           


***************
Static Function OK()
***************
Local aRet:={}
local nCnt:=nCntOK:=0


TMP2->(DbGotop())
while ! TMP2->(EOF())
   RecLock("Z67",.T.) 
   Z67->Z67_FILIAL :="01"
   Z67->Z67_ITEM :=TMP2->CODIGO   
   Z67->Z67_OP :=cOP
   Z67->Z67_MAQ :=cMaq   
   if !Empty(TMP2->MARCA)
      Z67->Z67_MARCA := "S"
      nCntOK+=1
   else
      Z67->Z67_MARCA := "N"
      Aadd( aRet, {TMP2->CODIGO,TMP2->DESC } )
   endif
   Z67->(MsUnlock())
   ncnt+=1
   TMP2->(DbSkip())
enddo

if ncnt=nCntOK
   alert('pesa')
else
   
   oProcess:=TWFProcess():New("PCPC014","PCPC014")
   oProcess:NewTask('Inicio',"\workflow\http\emp01\PCPC014.html")
   oHtml   := oProcess:oHtml
   oHtml:ValByName("cOP",cOP  )	
   oHtml:ValByName("cMaq",cMaq )		
	
	For _X:=1 to len(aRet) 
	   aadd( oHtml:ValByName("it.cItem") ,aRet[_X][1] )    
	   aadd( oHtml:ValByName("it.cDesc") ,aRet[_X][2] )    
	Next
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 oProcess:cTo := "antonio@ravaembalagens.com.br" 	         
	 subj	:= "Itens em Desconformidade na verificacao Extrusora"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail() 

endif
_ltudook:=.F.
oDlgLe:END()

Return