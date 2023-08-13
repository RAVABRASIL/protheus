#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PFAT03   บAutor  ณ Hugo Soares        บ Data ณ  24/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para consultar pedido.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Florarte                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PFAT03(lTipo)

//Esta variavel identifica se ja esta posicionado no cadastro do cliente
If lTipo == Nil
	lTipo := .F.
Endif

Private cCadastro,aRotina,aCampos:={},cFil
Private _MV_TIPO , _MV_FILIAL
Private lResposta := .T.

Private aCores	:= {{"SUBSTR(C5_STATUS,1,1)='0' .And. Empty(C5_DTCANC)",'BR_CINZA'  },;	//Pedido em Vendas
{"!Empty(C5_DTCANC)",'BR_PINK' },;          	//Pedido Cancelado
{"SUBSTR(C5_STATUS,1,1)='1'",'BR_VERMELHO' },;	//Pedido em Credito
{"SUBSTR(C5_STATUS,1,1)='2'",'BR_AZUL'     },;  //Pedido em Materiais
{"SUBSTR(C5_STATUS,1,1)='3'",'BR_PRETO'    },;  //Pedido em Faturamento
{"SUBSTR(C5_STATUS,1,1)='4'",'BR_VERDE'    } }	//Pedido Faturado

If !lTipo
	lResposta  := PERGUNTE("PED_01",.T.)
	_MV_TIPO   := MV_PAR01
	_MV_FILIAL := MV_PAR02
Endif

IF !lResposta .OR. LASTKEY()==27
	RETURN
ENDIF


cCadastro  := "Consulta de Pedidos"

DO CASE
	CASE lTipo
		cFil   :=xFILIAL("SC5")
		aRotina := { ;
		{ "Pesquisa"      ,'Axpesqui'  ,0,1 } ,;
		{ "Consulta"      ,'U_PFAT031(1)',0,2 } }
		U_PFAT031(1)
		cFilAnt:=cFil
	CASE _MV_TIPO == 1
		cFil   :=xFILIAL("SC5")
		
		aRotina := { ;
		{ "Pesquisa"      ,'Axpesqui'  ,0,1 } ,;
		{ "Consulta"      ,'U_PFAT031(1)',0,2 },; 
		{ "Obs. Cliente"  ,'U_ObsCli()',0,2 } }
		
		mBrowse(6,1,22,75,"SA1")
		cFilAnt:=cFil
	CASE _MV_TIPO == 2 .AND. IF(_MV_FILIAL == 1 , xFILIAL("SC5")=='01' , xFILIAL("SC5")=='02')
		
		aRotina := { ;
		{ "Pesquisa"      ,'Axpesqui'   ,0,1 } ,;
		{ "Consulta"      ,'U_PFAT031(2)',0,2 } ,;
		{ "Impressao"     ,'U_FATR41()',0,3 } ,;
		{ "Legenda"       ,'U_PFAT033',0,4 }  }
		
		dbselectarea("SC5")

		mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)
		
	CASE _MV_TIPO == 2 .AND. IF(_MV_FILIAL == 1 , xFILIAL("SC5")<>'01' , xFILIAL("SC5")<>'02')
		cFil   :=xFILIAL("SC5")
		cFilAnt:=STRZERO(_MV_FILIAL,2)
		aRotina := { ;
		{ "Pesquisa"      ,'Axpesqui'  ,0,1 } ,;
		{ "Consulta"      ,'U_PFAT031(2)',0,2 } ,;
		{ "Impressao"     ,'U_FATR41()',0,3 } ,;
		{ "Legenda"       ,'U_PFAT033',0,4 }  }
		
		dbselectarea("SC5")

		mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)
		
		cFilAnt:=cFil
		
ENDCASE
RETURN

/* 
    Grava a observa็ใo para o cliente
    Alessandro Gon็alves
    24/10/2006
*/  
User Function ObsCli
local cAlias := Alias()

DBSELECTAREA("SX5")
SX5->( DBSEEK(xFILIAL("SX5")+"ZU50") )  
if !UPPER(AllTrim(Subst(cUsuario,7,15))) $ SX5->X5_DESCRI
   MSgBox("Usuแrio sem permissใo para esta opera็ใo")
   DbSelectArea(cAlias)
   return
endif

Dbselectarea("ZZ6")
Dbsetorder(1)
If Dbseek(xfilial()+SA1->A1_COD+SA1->A1_LOJA)
	mObs := ZZ6->ZZ6_NEGOCI
Else
	cMem := CriaVar("ZZ6->ZZ6_NEGOCI") //Para criar registro
	Reclock("ZZ6",.T.)
	Replace ZZ6_FILIAL With xFilial()
	Replace ZZ6_CLIENT With SA1->A1_COD
	Replace ZZ6_LOJA   With SA1->A1_LOJA
	Replace ZZ6_NEGOCI With cMem
	Replace ZZ6_RETORN With dDatabase
	Replace ZZ6_TIPRET With '2'
	Replace ZZ6_ULCONT With CTOD("")
	Replace ZZ6_PRIORI With '   '
	Replace ZZ6_SEQUEN With '    '
	msunlock()
	mObs := ZZ6->ZZ6_NEGOCI
Endif

DEFINE MSDIALOG oDlga FROM 40, 20 TO 330,600 TITLE "Observa็ใo no Cliente" PIXEL OF oMainWnd
@ 001 , 0001 GET mObs  SIZE 290,120 MEMO
			
DEFINE SBUTTON oObj FROM 126, 120 TYPE 1 ENABLE OF oDlga PIXEL ACTION {|| RegistrarObs(mObs,oDLGA)}
DEFINE SBUTTON oObj FROM 126, 170 TYPE 2 ENABLE OF oDlga PIXEL ACTION {|| oDLGA:End() }
ACTIVATE MSDIALOG oDlga CENTERED                                           
DbSelectArea(cAlias)
return

/*
   Grava a Observa็ใo para o cliente.
*/
Static Function RegistrarObs(cMemo,Odl)
Dbselectarea("ZZ6")
Dbsetorder(1)
If Dbseek(xFilial("ZZ6")+SA1->A1_COD+SA1->A1_LOJA)
	Reclock("ZZ6",.F.)
	Replace ZZ6_NEGOCI With cMemo
	msunlock()
Endif	

Odl:End()
Return



