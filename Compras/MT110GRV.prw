#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'        
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110GRV  ºAutor  ³Eurivan Marques     º Data ³  13/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na gravacao da S.C.                        º±±
±±º          ³Utilizado para bloquear itens de responsabilidades de gestorº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************
User Function MT110GRV()
************************

//Rotina do Usuario para poder gravar campos especificos ou alterar campos gravados do item da SC.
/*
RecLock("SC1",.F.)
SC1->C1_APROV := 'B'
SC1->(MsUnlock())
SC1->(dbCommit())
*/

/*
If INCLUI
   // Projeto
   If _QTDProj()[1]=0      
      Projeto() 
   ELSE      
      RecLock("SC1",.F.)
      SC1->C1_PROSIGA :=_QTDProj()[2]
      SC1->(MsUnlock())
      SC1->(dbCommit())
   EndIf
   //
   /*
   // Destino do servico
   If _QTD()[1]=0
      IF posicione("SB1",1,xFilial('SB1') + SC1->C1_PRODUTO,"B1_GRUPO") $ '0001'
         Destino()
      endif
   ELSE
      IF posicione("SB1",1,xFilial('SB1') + SC1->C1_PRODUTO,"B1_GRUPO") $ '0001'
         RecLock("SC1",.F.)
         SC1->C1_SERVDES :=_QTD()[2]
         SC1->(MsUnlock())
         SC1->(dbCommit())
      endif
   EndIf
   //
   */
//Endif

Return  


***************

Static Function Destino()

***************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgServ","oGrp1","oCBox1","oSay1","oSBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgServ   := MSDialog():New( 234,625,351,803,"Destino do Serviço",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 000,000,037,083,"",oDlgServ,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCBox1     := TComboBox():New( 017,004,,{"Saco","Caixa"},073,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox1:nAt :=1   
oSay1      := TSay():New( 007,004,{||"Fabrica de :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oSBtn1     := SButton():New( 040,057,1,,oDlgServ,,"", )
oSBtn1:bAction := {||_Ok()}

  
oDlgServ:Activate(,,,.T.)

if EMPTY(_QTD()[2])
    Destino()
endif



Return  

***************

Static Function _Ok()

***************

RecLock( "SC1", .F. )

if oCBox1:nAt =1   
   SC1->C1_SERVDES:='S'
elseif oCBox1:nAt =2   
   SC1->C1_SERVDES:='C'
endif

SC1->( msUnlock() )
SC1->(dbCommit())

oDlgServ:End()

return   


***************

Static Function _QTD()

***************
LOCAL cQry:=''
local aRet:={}

cQry:="SELECT COUNT(*) QTD,C1_SERVDES FROM SC1020 SC1 "
cQry+="WHERE C1_NUM='"+CA110NUM+"' "
cQry+="AND C1_SERVDES!='' "
cQry+="AND SC1.D_E_L_E_T_!='*'  "
cQry+="GROUP BY C1_SERVDES "
TCQUERY cQry NEW ALIAS "TMP"

If TMP->(!EOF())
   Aadd(aRet,TMP->QTD)
   Aadd(aRet,TMP->C1_SERVDES)
else
   Aadd(aRet,0)
   Aadd(aRet,'')
Endif
TMP->(DBCLOSEAREA())
Return  aRet 


***************

Static Function _QTDProj()

***************
LOCAL cQry:=''
local aRet:={}

cQry:="SELECT COUNT(*) QTD,C1_PROSIGA FROM SC1020 SC1 "
cQry+="WHERE C1_NUM='"+CA110NUM+"' "
cQry+="AND C1_PROSIGA!='' "
cQry+="AND SC1.D_E_L_E_T_!='*'  "
cQry+="GROUP BY C1_PROSIGA "
TCQUERY cQry NEW ALIAS "TMPX"

If TMPX->(!EOF())
   Aadd(aRet,TMPX->QTD)
   Aadd(aRet,TMPX->C1_PROSIGA)
else
   Aadd(aRet,0)
   Aadd(aRet,'')
Endif
TMPX->(DBCLOSEAREA())
Return  aRet 

***************

Static Function Projeto()

***************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgServ","oGrp2","oCBox2","oSay2","oSBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgProj   := MSDialog():New( 234,625,351,803,"Solicitacao de Compra",,,.F.,,,,,,.T.,,,.F. )
oGrp2      := TGroup():New( 000,000,037,083,"",oDlgProj,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCBox2     := TComboBox():New( 017,004,,{"Sim","Nao"},073,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox2:nAt :=1   
oSay2      := TSay():New( 007,004,{||"E para Projetos?" },oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oSBtn2     := SButton():New( 040,057,1,,oDlgProj,,"", )
oSBtn2:bAction := {||_OkProj()}

  
oDlgProj:Activate(,,,.T.)

if EMPTY(_QTDProj()[2])
   Projeto()
endif


Return  


***************

Static Function _OkProj()

***************

RecLock( "SC1", .F. )

if oCBox2:nAt =1   
   SC1->C1_PROSIGA:='S'
elseif oCBox2:nAt =2   
   SC1->C1_PROSIGA:='N'
endif

SC1->( msUnlock() )
SC1->(dbCommit())

oDlgProj:End()

return   
