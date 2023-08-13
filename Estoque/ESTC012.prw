#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"

/*Inventario Diario*/

*************

User Function ESTC012()

*************

Local aCores := {{"EMPTY(Z89_FINALI)", "BR_VERDE"   },;		   			                
                 {"Z89_FINALI='F'", "BR_VERMELHO" }}


aRotina := {{"Pesquisar"         ,"AxPesqui"  , 0, 1},;
            {"Gerar Lista"       ,"U_fGeraLis()" , 0, 3},;
            {"Finaliza Lista"    ,"U_fFinaLis()" , 0, 4},;
            {"Imprime Lista"     ,"U_fReList()"  , 0, 2},;
            {"Legenda"           ,"U_LegInvent()"  , 0, 6}}


cCadastro := OemToAnsi("Inventario Diario")

DbSelectArea("Z89")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "Z89",,,,,,aCores)

Return 




*************

User function fGeraLis()

*************


//ddataI:= STOD('20130819')   // marco zero 

ddataI:= GetMV( "MV_LISTAI"  )   // marco zero 
ddataF:= date() //ddatabase

while ddataI <= ddataF   
    dbSelectArea("Z89")
	dbSetOrder(1)
	IF !dbSeek( xFilial("Z89") + dtos(ddataI)  ) // NAO ENCONTROU A DATA COLOCO NA TABELA
	    if dow(ddataI)!=7 .and.  dow(ddataI)!=1  // sabado e domingo nao gera lista 
	       fLista(ddataI)                      
	    endif   
//	ELSE
  //	   ALERT('Ja existe uma lista para essa data '+dtoc(ddataI) )
	ENDIF
	ddataI:=ddataI+1
enddo

DbSelectArea("Z89")
DbSetOrder(1)

Return
                
*************

Static function fLista(ddataI)

*************
local cQry:=''
LOCAL cnt:=1
local cHrInic:=Left( Time(), 5 )
Local nQcnt:=20
LOCAL lCaixa:=.F.
	
	cQry:="      SELECT  row_number() over(ORDER BY NEWID()) NUMERO, B1_COD,B1_DESC,B1_UM FROM "+RetSqlName("SB1")+"  SB1 "
	cQry+="      WHERE B1_ATIVO='S' "
	cQry+="      AND LEN(B1_COD)<=7 "
	If  SM0->M0_CODIGO == "02" .and. SM0->M0_CODFIL == "01" // Filial Saco
	    cQry+="      AND B1_SETOR!='39' "
	ELSE
	    cQry+="      AND B1_SETOR='39' "
 	    lCaixa:=.T.
	ENDIF
	cQry+="      AND B1_MSBLQL<>'1' "// NAO CONSIDERA PRODUTO BLOQUEADO 
	cQry+="      AND B1_TIPO='PA' "
	cQry+="      AND D_E_L_E_T_='' "
	
	If Select("SB1X") > 0
		DbSelectArea("SB1X")
		DbCloseArea()	
	EndIf 
	
	TCQUERY cQry NEW ALIAS "SB1X"  
	WHILE  SB1X->(!EOF())
	  if cnt<=nQcnt // 
	 		dbSelectArea("Z89")
			dbSetOrder(2)
		    IF  dbSeek( xFilial("Z89") +SB1X->B1_COD  ) //  ENCONTROU  COLOCO NA TABELA SE NAO TIVER FINALIZADO 		        
		        IF ( ALLTRIM(Z89->Z89_FINALI)='F'	) .OR. (lCaixa) // FINALIZADO  ou  Filial CAixa  ( caixa sempre gera porque sao apenas 9 )        
		           IF ! fExiste(SB1X->B1_COD) .OR. (lCaixa)   // existente   ou  Filial CAixa  
		                fZ89(ddataI,cHrInic)
	                    cnt+=1
	               Endif   
		        EndIF		        
		    ELSE
		        fZ89(ddataI,cHrInic)
		        cnt+=1                       
		    ENDIF    	   
	  Else
	        EXIT
	  endIF
	   SB1X->(DBSKIP())
	endDO


SB1X->(DBCLOSEAREA())

Return 

***************

Static Function fZ89(ddataI,cHrInic)

***************

RecLock("Z89",.T.)
Z89->Z89_FILIAL:=XFILIAL('Z89')
Z89->Z89_CODIGO:=SB1X->B1_COD
Z89->Z89_DESCRI:=SB1X->B1_DESC
Z89->Z89_UM:=SB1X->B1_UM
Z89->Z89_DTINIC:=ddataI 
Z89->Z89_HRINIC:=cHrInic
Z89->Z89_IDINIC:=__cUserId
Z89->Z89_USUINI:=cUserName
Z89->Z89_DTGERA:=date()
Z89->( msUnlock() )

rETURN 

*************

User Function fFinaLis()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc := GD_UPDATE //GD_INSERT+GD_DELETE+GD_UPDATE
Private aHoBrw1 := {}
Private aCoBrw1 := {}
Private noBrw1  := 4 //5
PRIVATE cFColsG:= 'QTDDIG/'
PRIVATE dDtInic:=Z89->Z89_DTINIC   

IF ! fok(dDtInic)
   ALERT('lista toda finalizada.')
   return 
ENDIF

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgEs","oBrw1","oSBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//oDlgEs     := MSDialog():New( 144,253,460,1327,"Finaliza Lista do Dia "+dtoc(dDtInic),,,.F.,,,,,,.T.,,,.F. )
oDlgEs     := MSDialog():New( 144,253,650,1327,"Finaliza Lista do Dia "+dtoc(dDtInic),,,.F.,,,,,,.T.,,,.F. )
fgetEst()

MHoBrw1()
//oBrw1      := MsNewGetDados():New(000,000,118,524,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsG,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oDlgEs,aHoBrw1,aCoBrw1 )
oBrw1      := MsNewGetDados():New(000,000,218,524,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsG,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oDlgEs,aHoBrw1,aCoBrw1 )
MCoBrw1()
//oSBtn1     := SButton():New( 132,498,1,,oDlgEs,,"", )
oSBtn1     := SButton():New( 225,498,1,,oDlgEs,,"", )
oSBtn1:bAction := {||ok(dDtInic) }

oDlgEs:Activate(,,,.T.)
TMPX->(DBCloseArea())  
//Ferase(cTrab) // APAGA O ARQUIVO DO DISCO

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: <Inform Alias>
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

Local aAux := {}

Aadd( aHoBrw1 , {"Codigo"		,"COD"		,"@!"				      ,015,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"Descricao"	,"DESC"	    ,"@!"				      ,050,000,"AllwaysTrue()","û","C"} )
Aadd( aHoBrw1 , {"UM"	        ,"UM"	    ,"@!"				      ,002,000,"AllwaysTrue()","û","C"} )
//Aadd( aHoBrw1 , {"Qtd Estoque","QTDEST"	    ,"@E 999,999,999,999.9999",017,004,"AllwaysTrue()","û","N"} )
Aadd( aHoBrw1 , {"Qtd Contagem"	,"QTDDIG"	,"@E 999,999,999,999.9999",017,004,"AllwaysTrue()","û","N"} )


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
	oBrw1:aCols[Len(oBrw1:aCols)][03] := TMPX->UM
//	oBrw1:aCols[Len(oBrw1:aCols)][04] := TMPX->QTDEST
//  oBrw1:aCols[Len(oBrw1:aCols)][05] := CriaVar("B2_QATU")
    oBrw1:aCols[Len(oBrw1:aCols)][04] := CriaVar("B2_QATU")	
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


***************

Static Function fCriaTAB()

***************

Local aFds	:= {}
Private cTRAB	:= ""
Private cTAB	:= "TMPX"

Aadd( aFds , {"COD"   	,"C",015,000} )
Aadd( aFds , {"DESC"  	,"C",050,000} )
Aadd( aFds , {"UM"  	,"C",002,000} )
//Aadd( aFds , {"QTDEST"  ,"N",017,004} )
Aadd( aFds , {"QTDDIGI" ,"N",017,004} )

cTRAB := CriaTrab( aFds, .T. )
Use (cTRAB) Alias &cTAB New Exclusive
IndRegua(cTAB,cTRAB,"COD",,,'Selecionando Registros...') //'Selecionando Registros...'

Return

****************

Static Function fgetEst()

****************

fCriaTAB()


TMPX->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 

dbSelectArea("Z89")
dbSetOrder(1)
dbSeek( xFilial("Z89") + DTOS(dDtInic)  ) 

Do While Z89->(!EOF()) .AND. Z89->Z89_DTINIC=dDtInic
   if Z89->Z89_FINALI!='F' // FINALIZADO 
	   RecLock("TMPX", .T.)	
	   TMPX->COD	 :=Z89->Z89_CODIGO
	   TMPX->DESC	 :=Z89->Z89_DESCRI
	   TMPX->UM	     :=Z89->Z89_UM	   
//	   TMPX->QTDEST  := fQEst(Z89->Z89_CODIGO) 
	   TMPX->(MsUnLock())
   ENDIF
       Z89->(DBSKIP())       
Enddo

Return


***************
Static Function ok()
***************

local ddataF:=date()
local cHrFina:=Left( Time(), 5 )
local lJust:=.F.
local nJust:=''

if ! MsgBox( OemToAnsi( "Deseja realmente finalizar a lista" ), "Escolha", "YESNO" )       
   oDlgEs:end()
   return 
Endif

IF dDtInic<>date()
  nJust:=justifica()
  lJust:=.T.
Endif

For _D:=1 to len(oBrw1:aCols)    
    dbSelectArea("Z89")
    dbSetOrder(3)
	IF dbSeek( xFilial("Z89") + DTOS(dDtInic) +oBrw1:aCols[_D][1] ) 
	      RecLock("Z89", .F.)
          Z89->Z89_QATU:= fQEst(oBrw1:aCols[_D][1])  //oBrw1:aCols[_D][4]
	      Z89->Z89_QDIGIT:= oBrw1:aCols[_D][4] //oBrw1:aCols[_D][5]
	      Z89->Z89_DTFINA:=ddataF
          Z89->Z89_HRFINA:=cHrFina
          Z89->Z89_IDFINA:=__cUserId
          Z89->Z89_USUFIN:=cUserName
          Z89->Z89_FINALI:='F'	   
          Z89->Z89_JUSTIF:= IIF(lJust,nJust,"")	   	      
	      Z89->(MsUnLock())
	Endif   	
Next

oDlgEs:end()


Return 

***************

Static Function fQEst(cProd)

***************
local cQry:=''
local nRet:=0

cQry:="SELECT  "
cQry+="ISNULL(SUM(SB2.B2_QATU ),0) AS ESTOQUE "
cQry+="FROM "+RetSqlName("SB2")+"  SB2 WITH (NOLOCK) "
cQry+="WHERE "
cQry+="SB2.B2_COD='"+cProd+"' "
cQry+="AND SB2.B2_LOCAL = '01' "
cQry+="AND SB2.B2_FILIAL='"+xFilial('SB2')+"'  "
cQry+="AND SB2.D_E_L_E_T_ = ''  "

If Select("TMPY") > 0
	DbSelectArea("TMPY")
	TMPY->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPY"

if TMPY->(!EOF())
   nRet:= TMPY->ESTOQUE
endif

TMPY->(dbclosearea())

Return  nRet


*************

User Function LegInvent()

*************

Local aLegenda := {{"BR_VERDE"     ,"Lista nao Finalizada" },;   	   			   
   	   			   {"BR_VERMELHO" ,"Lista Finalizada" }}


BrwLegenda("Inventario Diario ","Legenda",aLegenda)		   		

Return .T.

***************

Static Function fok(dDtInic)

***************
local cQry:=''
local nRet:=.T.
local ncntF:=ncnt:=0


cQry:="SELECT * FROM "+RetSqlName("Z89")+"  Z89 WHERE D_E_L_E_T_='' "
cQry+="AND  Z89_DTINIC='"+DTOS(dDtInic)+"' "
cQry+="and Z89_FILIAL='"+XFILIAL('Z89')+"' "

If Select("Z89Y") > 0
	DbSelectArea("Z89Y")
	Z89Y->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "Z89Y"

DO WHILE  Z89Y->(!EOF())
   IF Z89Y->Z89_FINALI='F'
      ncntF+=1
   ENDIF
   ncnt+=1
   Z89Y->(dbSKIP())   
ENDDO

if ncntF=ncnt
   nRet:=.F.
endif

Z89Y->(dbclosearea())   

Return nRet


*************

User Function fReList()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Lista Inventario "
Local cPict          := ""
Local titulo         := "Lista Inventario "
Local nLin           := 80
                        //          10        20        30        40        50        60        70        80
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Codigo           Descricao                                          UM          Qtd Contagem"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "fReList" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "fReList" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""


IF ! fok(Z89->Z89_DTINIC)
   ALERT('lista toda finalizada.')
   return 
ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
titulo         := "Lista Inventario do Dia "+DTOC(Z89->Z89_DTINIC)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************
local cQry:=''
Local nOrdem


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQry:="SELECT * FROM "+RetSqlName("Z89")+"  Z89 WHERE D_E_L_E_T_='' "
cQry+="AND  Z89_DTINIC='"+DTOS(Z89->Z89_DTINIC)+"' "
cQry+="and Z89_FILIAL='"+XFILIAL('Z89')+"' "

If Select("Z89R") > 0
	DbSelectArea("Z89R")
	Z89R->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "Z89R"

SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Z89R->(dbGoTop())
While Z89R->(!EOF())

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
      @nLin,00 PSAY Z89R->Z89_CODIGO
      @nLin,17 PSAY Z89R->Z89_DESCRI
      @nLin,69 PSAY Z89R->Z89_UM
      @nLin++,00 PSAY REPLICATE('_',132)
      nLin := nLin + 1 // Avanca a linha de impressao

      Z89R->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo


Z89R->(DBCLOSEAREA())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return



***************

Static Function justifica()

***************


Local oDlg1,oGrp1,oMGet1,oBtn1,oBtn2,oMGet1,oBtn1,oBtn2,oMotper
pRIVATE cMemoJ
cMemoJ  := space(200)

oDlg1  := MSDialog():New( 242,302,513,941,"Justificativa",,,.F.,,,,,,.T.,,,.T. )
oGrp1  := TGroup():New(   002,004,131,313,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMGet1 := TMultiGet():New( 012,011,{|u| If(PCount()>0,cMemoJ:=u,cMemoJ)},oGrp1,296,080,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )


oBtn1  := TButton():New( 112,150,"Salvar",  oGrp1,{ || oDlg1:end() },037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

IF empty(cMemoJ)
   alert('a justificativa nao pode ser vazia')
   justifica()
endif

Return cMemoJ
                  

***************

Static Function fExiste(cCod)

***************
local cQry:=''
local lret:=.F.

cQry:="SELECT Z89_CODIGO,COUNT(*) FROM "+RetSqlName("Z89")+" Z89 "
cQry+="WHERE D_E_L_E_T_='' "
cQry+="and Z89_FINALI!='F'  "
cQry+="AND Z89_FILIAL='"+XFILIAL('Z89')+"'  "
cQry+="AND  Z89_CODIGO='"+cCod+"' "
cQry+="GROUP BY Z89_CODIGO "
cQry+="ORDER BY Z89_CODIGO "

If Select("Z89E") > 0
	DbSelectArea("Z89E")
	Z89E->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "Z89E"

IF Z89E->(!EOF())
   lret:=.T.
ENDIF

Z89E->(DbCloseArea())

Return lRet