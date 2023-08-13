#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"

*************
User Function VldEmpenho()
*************

Local cQry:='' 
                                    //FR - 06/06/13
If M->C5_NUMEMP = '  XINTERNET'     //coloquei esta valid, pois quando o pedido é gerado automático (função Validar em Pedidos Internet)
									//ficava pedindo o número do empenho, e vazio as vezes não funcionava também.
	Return .T.
Else
	dbSelectArea("SC5")
	SC5->(dbSetOrder(5))
	If SC5->(dbSeek(xFilial("SC5")+M->C5_NUMEMP,.T.))
	  alert("Já existe Registro com essa Informação" )
	  Return .F.
	Else
	  cQry:="SELECT TOP 5 C5_NUM,C5_NUMEMP,C5_EMISSAO FROM SC5020 SC5 "
	  cQry+="WHERE C5_CLIENTE='"+M->C5_CLIENTE+"' "
	  cQry+="AND SC5.D_E_L_E_T_!='*' "
	  cQry+="AND C5_TIPO='N' "
	  cQry+="ORDER BY  C5_EMISSAO DESC  "
	  TCQUERY cQry NEW ALIAS '_TMPX'
	  TCSetField( '_TMPX', "C5_EMISSAO", "D" )
	  _TMPX->(DbGotop())
	  
	  If _TMPX->(!EOF())
	     TelaEmp()
	  Endif
	
	_TMPX->(DbCLoseArea())
	
	Endif

Endif  //c5_numemp

Return .T. 

*************

Static Function TelaEmp()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgEmp","oBrw1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgEmp      := MSDialog():New( 181,377,361,837,"Empenho",,,.F.,,,,,,.T.,,,.F. )
oTbl1()
DbSelectArea("TMP")
oBrw1      := MsSelect():New( "TMP","","",{{"NUM","","Nº Pedido",""},;
{"EMISSAO","","Dt Emissao",""},;
{"EMPENHO","","Nº Empenho",""}},.F.,,{000,000,064,222},,, oDlgEmp ) 
oBtn1      := TButton():New( 069,184,"Ok",oDlgEmp,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||oDlgEmp:End() }
getEmp()

oDlgEmp:Activate(,,,.T.)

TMP->(DBCloseArea())  
Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

if Select("TMP") > 0 
   TMP->(DbCloseArea())
endif

Aadd( aFds , {"NUM"     ,"C",006,000} )
Aadd( aFds , {"EMISSAO" ,"D",008,000} )
Aadd( aFds , {"EMPENHO" ,"C",020,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive
Return 

***************

Static Function GetEmp()

***************

TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 

Do While  _TMPX->(!EOF()) 
    RecLock("TMP",.T.)
    TMP->NUM:=_TMPX->C5_NUM
    TMP->EMISSAO:=_TMPX->C5_EMISSAO
    TMP->EMPENHO:=_TMPX->C5_NUMEMP
    TMP->(MsUnLock())		    
    _TMPX->(DBSKIP())
Enddo

TMP->( DbGotop() )


Return 