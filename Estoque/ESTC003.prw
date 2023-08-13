#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"


*************

User Function ESTC003()

*************

Local aIndex := {}
Local aCores := {{"Z47_STATUS == 'B'", "BR_VERMELHO" },;
                 {"Z47_STATUS == 'L'", "BR_VERDE"    },;
                 {"Z47_STATUS == 'X'", "BR_AZUL"    },;
                 {"Z47_STATUS == 'R'", "BR_PRETO"   }}		   			 

 aRotina2 :={ {"Relatorio", "U_ESTR001"  ,0 , 6},;
             {"Analise", "U_CHECK"  ,0 , 6} } 


aRotina :={	{"Pesquisar","AxPesqui"	,0 , 1},;
{"Visualizar","AxVisual"	        ,0 , 2},;
{"Incluir","AXInclui"	            ,0 , 3},;
{"Alterar","U_CADASTRA(1)"	        ,0 , 4},;
{"Excluir","U_CADASTRA(2)"	        ,0 , 5},;
{"Libera","U_CONFIRMA(1)"	        ,0 , 6},;
{"Rejeita","U_CONFIRMA(2)"	        ,0 , 6},;
{"Legenda","U_LegSolic"	            ,0 , 6},; 
{"Inclui Produto","U_PrInclui "	    , 0 , 6},;
{"Analise Produto",aRotina2	        , 0 , 6},;
{"Relatorio","U_RELSOLIC "	        ,0 , 6} } 


cCadastro := OemToAnsi("Cadastro de Solicitacao de Produto")

DbSelectArea("Z47")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "Z47",,,,,,aCores)


Return


*************

User Function IDSOLIC(cUsu)

*************
local aUsu := {}
local cIDsol := ""

PswOrder(2)
if PswSeek( cUsu, .T. )
   aUsu := PSWRET() // Retorna vetor com informações do usuário
   cIDsol:=aUsu[1][1]
endif


return cIDsol
 
*************

User Function LegSolic()

*************

Local aLegenda := {{"BR_VERMELHO" ,"Bloqueado"},;
                   {"BR_VERDE"    ,"Liberado"},;
   	   			   {"BR_AZUL"     ,"Produto Criado"},;
   	   			   {"BR_PRETO"    ,"Rejeitado"}}


BrwLegenda("Solicitacao Produto","Legenda",aLegenda)		   		

Return .T.
         
*************

User Function RELSOLIC()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Solicitacao de Produto"
Local cPict          := ""
Local titulo         := "Solicitacao de Criacao de Produto"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "ESTC003" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ESTC003" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  17/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery:=''
local aUsu := {}
local cSolic := ""
Private cDir		:= "" //usado na abertura de arquivo no browse
Private cArq		:= ""  //usado na abertura de arquivo no browse
Private nHand       := 0  //usado na abertura de arquivo no browse
Private cDIRHTM     := "" //usado no envio do arquivo por email
Private cArqHTM     := "" //usado no envio do arquivo por email
Private nHandle     := 0  //usado no envio do arquivo por email


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery:=" SELECT * FROM "+retSqlName("Z47")+" Z47 " + CHR(13) + CHR(10)
cQuery+=" WHERE Z47_NUM='"+Z47->Z47_NUM+"' " + CHR(13) + CHR(10)
cQuery+=" AND Z47_FILIAL='"+xFilial('Z47')+"' " + CHR(13) + CHR(10)
cQuery+=" AND Z47.D_E_L_E_T_ ='' " + CHR(13) + CHR(10)
MemoWrite("C:\TEMP\ESTC003.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "TMPZ"

TcSetField("TMPZ", "Z47_DATA", "D")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TMPZ->( dbGoTop() )
count to nREGTOT while ! TMPZ->( EoF() )
SetRegua( nREGTOT )
TMPZ->( DBGoTop() )

////cria o diretório local, caso não exista

lDir := ExistDir('C:\TEMP') // Resultado: .F.
cDir := "C:\TEMP\"
If !lDir
	U_CriaDir( cDir ) 
Endif
////CRIA O HTM 
cArq  := "CRIAPROD_" + Alltrim(TMPZ->Z47_NUM) + "_.HTM" 	
nHand := fCreate( cDir + cArq, 0 )			    
If nHand = -1
    MsgAlert('o arquivo '+AllTrim(cArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
    Return
Endif

////CRIA O HTM para envio por email 
cArqHTM  := "CRIAPROD_" + Alltrim(TMPZ->Z47_NUM) + "_.HTM" 	
nHandle := fCreate( cDirHTM + cArqHTM, 0 )			    
If nHandle = -1
    MsgAlert('o arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
    Return
Endif

While TMPZ->( !EOF() )

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
      nLin := 6
   Endif
   	cNum  := TMPZ->Z47_NUM
    cUser := ""
    cUser := TMPZ->Z47_SOLICI
    cCoord:= ""
    //cCoord := NomeOp(cUser, "S")
    //cSuper := NomeOp(cUser , "S")
    cCli   := TMPZ->Z47_CLIENT
    dData  := TMPZ->Z47_DATA
    cAlt   := TMPZ->Z47_ALTURA
    cLarg  := TMPZ->Z47_LARGUR
    cEspess:= TMPZ->Z47_ESPESS
    cCor   := TMPZ->Z47_COR
    cImpress:= TMPZ->Z47_IMPRES
    nQTEMB  := TMPZ->Z47_QTEMB
    nPrecoMR:= TMPZ->Z47_PRECMR
    cUF     := TMPZ->Z47_UF
    nPesoMR := TMPZ->Z47_PESOMR
    nValorIMP:= 0
    nValACMR:= 0
    nQTMIN  := 0
    nMargem := 0
    cOBS    := TMPZ->Z47_OBS
    cOBSFIN := TMPZ->Z47_OBSFIN
    cOBSCOM := TMPZ->Z47_OBSCOM
    cOBSPRD := TMPZ->Z47_OBSPRD
    cDepto  := ""
    cMail   := ""
    CABECA  := "SOLICITAÇÃO DE CRIAÇÃO DE PRODUTO"  
    
    PswOrder(1)
    if PswSeek( TMPZ->Z47_SOLICI, .T. )
       aUsu := PSWRET() // Retorna vetor com informações do usuário
       cSolic := aUsu[1][4]
       cDepto := aUsu[1][12]
       cMail  := aUsu[1][14]
    Endif
    
    cQuery:=" SELECT * FROM "+retSqlName("SA3")+" SA3 "
	//cQuery+=" WHERE A3_CODUSR = '" + Alltrim(cUser)+"' "
	cQuery+=" WHERE A3_NOME LIKE '" + Alltrim(UPPER(cSolic))+"%' "
	cQuery+=" AND SA3.D_E_L_E_T_!='*' "
	MemoWrite("C:\TEMP\SA3ESTC003.SQL", cQuery )

	If Select("TMPA3") > 0
		DbselectArea("TMPA3")
		DBCloseArea()
	Endif
	TCQUERY cQuery NEW ALIAS "TMPA3"
	cGeren := ""
	TMPA3->( dbGoTop() )
	If !TMPA3->(EOF())
		cCoord := TMPA3->A3_SUPER
		cGeren := TMPA3->A3_GEREN	
	Endif
    
    //@nLin++,00 PSAY REPLICATE('-' , limite)
	If Empty(cGeren)
		@nLin++,00 PSAY "COORDENADOR DE VENDAS DO SOLICITANTE: " + iif(!Empty(cCoord), NomeOp(cCoord , "U") , "NÃO É VENDEDOR" )
	Else
		@nLin++,00 PSAY "COORDENADOR DE VENDAS DO SOLICITANTE: O Próprio Solicitante"
	Endif
	
   	@nLin++,00 PSAY "Cliente: "+TMPZ->Z47_CLIENT
   	@nLin++,00 PSAY "Data: "+ DTOC(TMPZ->Z47_DATA)
   	@nLin++,00 PSAY "Linha:" + TMPZ->Z47_LINPRO
    @nLin++,00 PSAY "Previsão Mensal: " + Z47->Z47_PREVEN
	@nLin++,00 PSAY "Previsão Unit.:" + Z47->Z47_PREVUN
   	
   	
    @nLin++,00 PSAY "Solicitante: " + cSolic
    
    @nLin++,00 PSAY REPLICATE('-' , limite)
   	//nLin++
   	
   	@nLin++,00 PSAY "1 - Informações Fornecidas pelo Coordenador de Vendas Solicitante"
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	@nLin++,00 PSAY "1.1 Medidas: 
   	@nLin++,00 PSAY "Largura  : " + Transform(TMPZ->Z47_LARGUR, "@E 9,999,999.9999") + " x Altura: " + Transform(TMPZ->Z47_ALTURA, "@E 9,999,999.9999") + " x Espessura: " + Transform(TMPZ->Z47_ESPESS, "@E 9,999,999.9999")
   	@nLin++,00 PSAY "1.2 Cor               : " + TMPZ->Z47_COR
   	@nLin++,00 PSAY "1.3 Impressão (S/N)   : " + TMPZ->Z47_IMPRESS
   	@nLin++,00 PSAY "1.4 Qtd. Por Embalagem: " + Transform(TMPZ->Z47_QTEMB , "@E 99999.99")
   	@nLin++,00 PSAY "1.5 Preço por milheiro Sem IPI"
   	@nLin++,00 PSAY " (caso o cliente já compre de um concorrente):" + Transform( Z47->Z47_PRECMR, "@E 999,999.99")
   	@nLin++,00 PSAY "1.6 Estado onde será entregue o Produto: " + TMPZ->Z47_UF
   	
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	@nLin++,00 PSAY "2 - Informações Fornecidas pela Equipe de Produção"
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	@nLin++,00 PSAY "2.1 Peso do Milheiro            : " + Transform(TMPZ->Z47_PESOMR, "@E 999,999.9999")
   	@nLin++,00 PSAY "2.2 Valor do Clichê p/ Impressão: " + Transform(TMPZ->Z47_VLRCLI, "@E 999,999.99")
   	@nLin++,00 PSAY "2.3 Valor Acrescido no Milheiro"
   	@nLin++,00 PSAY "(por uso a mais de sacos capas) : " + Transform(TMPZ->Z47_VLACMR , "@E 999,999.99")
   	@nLin++,00 PSAY "2.4 Qtd. Mínima p/ Produção     : " + Transform(TMPZ->Z47_QTMIN , "@E 999,999.9999")
   	
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	@nLin++,00 PSAY "3 - Informações Fornecidas pelo Financeiro"
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	@nLin++,00 PSAY "3.1 Margem de Lucro"
   	@nLin++,00 PSAY "(Quando houver um preço do milheiro como referência): " + Transform(TMPZ->Z47_MARGEM, "@E 999,999.99")
   	@nLin++,00 PSAY "3.2 Observações Financeiro: "
   	If !Empty(SUBSTR(TMPZ->Z47_OBSFIN,1,75))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSFIN,1,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBSFIN,76,75))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSFIN,76,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBSFIN,151,75))
  		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSFIN,151,50)
   	Endif
   	nLin++
   	nLin++
   	
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	@nLin++,00 PSAY "Parecer da Diretoria de Produção:"
   	//@nLin++,00 PSAY REPLICATE('.' , limite)
   	If !Empty(SUBSTR(TMPZ->Z47_OBSPRD,1,75))   	
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSPRD,1,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBSPRD,76,75))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSPRD,76,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBSPRD,151,50))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSPRD,151,50)
   	Endif
   	nLin++
   	nLin++   	
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	
   	@nLin++,00 PSAY "Parecer da Diretoria Comercial:"
   	//@nLin++,00 PSAY REPLICATE('.' , limite) 
   	If !Empty(SUBSTR(TMPZ->Z47_OBSCOM,1,75))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSCOM,1,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBSCOM,76,75))   		
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSCOM,76,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBSCOM,151,50))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBSCOM,151,50)
   	Endif
   	nLin++   
   	nLin++
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   	
   	@nLin++,00 PSAY "Observações Gerais:"
   	//@nLin++,00 PSAY REPLICATE('.' , limite) 
   	If !Empty(SUBSTR(TMPZ->Z47_OBS,1,75))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBS,1,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBS,76,75))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBS,76,75)
   	Endif
   	
   	If !Empty(SUBSTR(TMPZ->Z47_OBS,151,50))
   		@nLin++,00 PSAY SUBSTR(TMPZ->Z47_OBS,151,50)
   	Endif 
   	nLin++
   	@nLin++,00 PSAY REPLICATE('.' , limite)
   cWeb := SolicHTM(cSolic, cCoord, cNum, cGeren)                            
   TMPZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
   /*
   cWeb := SolicHTM(cCoord,cSolic,dData,cAlt,cLarg,cEspess,cCor,cImpress,;
                         nQTEMB,nPrecoMR,cUF,nPesoMR,nValorIMP,nValACMR,;
                         nQTMIN,nMargem,cOBS,cUser,cDepto,cMail,CABECA,cOBS,cOBSFIN,cOBSCOM,cOBSPRD)  
	*/
	
EndDo

///GRAVA O HTML
Fwrite( nHand, cWeb, Len(cWeb) )
FClose( nHand )
		
//////////////////////////////////////
// Exibe o arquivo HTML no Navegador 
//////////////////////////////////////
fAbreHTM(cDir, cArq)



TMPZ->(DBCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda(0 , "" , TAMANHO)

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

//////GRAVA O HTML P/ ENVIO
Fwrite( nHandle, cWeb, Len(cWeb) )
FClose( nHandle )

						
//////SELECIONA O EMAIL DESTINATÁRIO 
aUsuarios := {}
PswOrder(1)
If PswSeek( __CUSERID, .T. )
   aUsuarios  := PSWRET() 					
   cMail := Alltrim(aUsuarios[1][14])     	// email do usuário
Endif  
cMailTo := ""
cMailTo += cMail
//cMailTo := "flavia.rocha@ravaembalagens.com.br"     //RETIRAR                  
cCopia  := ""
//cCopia  := "flavia.rocha@ravaembalagens.com.br"
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo + " - " + cNum
//////ENVIA O HTML COMO ANEXO 
MsAguarde( {|| U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo )   }, OemToAnsi( "Aguarde" ), OemToAnsi( "Enviando E-mail ..." ) )


Return

*************

User Function CONFIRMA(nOpc)  

*************

local aUsu := {}
local cSolic := ""
              
if Z47->Z47_STATUS=='X' 
   alert("Produto ja criado,Nao pode ser mas Liberado ou Rejeitado!!! ")
   //Return
endif

if U_Senha2("15",1)[1]
   PswOrder(1)
   if PswSeek( Z47->Z47_SOLICI, .T. )
      aUsu := PSWRET() // Retorna vetor com informações do usuário
      if !Empty(aUsu[1][14])
     		
		 RecLock("Z47",.F.)
		 If nOpc==1
		    Z47->Z47_STATUS:='L'  // Liberado 
		 ElseIf nOpc==2
		    Z47->Z47_STATUS:='R'  // Rejeitado
		 Endif
		 Z47->(MsUnLock())	   
		    
		 oProcess:=TWFProcess():New("SolicProd","SolicProd")
		 oProcess:NewTask('Inicio',"\workflow\http\emp01\SolicProd.html")
		 oHtml   := oProcess:oHtml
			
		 aadd( oHtml:ValByName("it.Cod") ,Z47->Z47_NUM )
		 aadd( oHtml:ValByName("it.Status" ) ,Iif(Z47->Z47_STATUS=='L','Liberado',iif(Z47->Z47_STATUS=='R','Rejeitado','Bloqueado' )   )  )
			
		 _user := Subs(cUsuario,7,15)
		 oProcess:ClientName(_user)
		 oProcess:cTo := Alltrim(aUsu[1][14])
		 
		 //oProcess:cTo := "flavia.rocha@ravaembalagens.com.br" //retirar
		 subj	:= "Solicitação de Criação de Produto "
		 oProcess:cSubject  := subj
		 oProcess:Start()
		WfSendMail()
		MsgInfo("Email Enviado com Sucesso.")
		
				
      Endif
   Endif		
endIf

Return 


**************

User Function PrInclui()

*************

If Z47->Z47_STATUS=='L'
   A010Inclui("SB1",,3)
Else
   If Z47->Z47_STATUS=='B' 
      Alert("A solicitação Não foi Liberada. Peça autorização  ")
   ElseIf Z47->Z47_STATUS=='R' 
      Alert("A solicitação foi Rejeitada. Não Pode Incluir Produto")
   ElseIf Z47->Z47_STATUS=='X'
      Alert("Produto Ja foi Criado.")
   Endif
Endif
Return


**************

User Function CADASTRA(nOpc)

*************

If Z47->Z47_STATUS=='B' // Bloqueado
   if nOpc==1
      AxAltera("Z47",Z47->(RECNO()),4)
   elseif nOpc==2
      AxDeleta("Z47",Z47->(RECNO()),5)
   endif
Else
   Alert( "Essa Solicitacao nao pode ser "+Iif(nOpc == 2,"Excluida","Alterada" )  )
Endif
Return


*************

User Function CHECK()

*************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private lChk1   := .F.
Private lChk2   := .F.

SetPrvt("oDlg1","oGrp1","oSay1","oCBox1","oCBox2","oBtn1")

If Z47_STATUS!='X'
   Alert('O Produto Hainda Nao foi Criado.' )
   Return
Endif

if !U_Senha2("15",1)[1]
   Return
Endif

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/



oDlg1      := MSDialog():New( 126,254,265,869,"Analise de Produto",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 003,003,061,303,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 015,019,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,274,008)
oSay1:cCaption:=ALLTRIM(Z47->Z47_PROD)+" - "+ALLTRIM(Posicione('SB1',1,xFilial("SB1")+Z47->Z47_PROD,"B1_DESC"))
oCBox1     := TCheckBox():New( 040,013,"Positiva ",{|u| If(PCount()>0,lChk1:=u,lChk1)},oGrp1,081,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox1:bLClicked := {||checkVal(1)}
oCBox2     := TCheckBox():New( 040,105,"Negativa",{|u| If(PCount()>0,lChk2:=u,lChk2)},oGrp1,134,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox2:bLClicked := {||checkVal(2)}
oBtn1      := TButton():New( 038,248,"OK",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||myRet(Z47->Z47_PROD)}




oDlg1:Activate(,,,.T.)

Return
         

***************

Static Function myret(cProd)

***************

Local cProdSeg:=''

If !lChk1 .AND.! lChk2
   Alert("Escolha uma Opcao.")
   Return
EndIF


DbSelectArea("SB1")
DbSetOrder(1)
If SB1->(DbSeek(xFilial("SB1")+cProd))
	
	RecLock("SB1",.F.)
	If lChk1
		SB1->B1_ATIVO:='S'
	ElseIf lChk2
		SB1->B1_ATIVO:='N'
	Endif
	SB1->B1_ANAPROD:='S'
	SB1->(MsUnLock())
	
	If LEN(ALLTRIM(cProd))<=7		
	   If Subs( SB1->B1_COD, 4, 1 ) == "R"
		  cProdSeg := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 4 ) + "6";
		  + Subs( SB1->B1_COD, 6, 2 )
	   Else
          cProdSeg := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 3 ) + "6";
		  + Subs( SB1->B1_COD, 5, 2 )
	   EndIf
          myret(cProdSeg)		
	Endif
EndIf

oDlg1:end()

Return

***************

Static Function checkVal(nOpc)

***************

if nOpc==1
   If lChk2
      lChk2:=.F.
      Return
   Endif
elseIf nOpc==2
   if lChk1
      lChk1:=.F.
      Return
   Endif
endIf

Return


**************************************
Static Function fAbreHTM(cDir, cArq)  
**************************************

//Tenta com o MOZILLA COMUM
If WinExec("C:\Arquivos de programas\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
	///Se não conseguir, tenta com Mozilla (para Dell)
	If WinExec("C:\Program Files (x86)\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
		//Se não conseguir, tenta com Internet Explorer	
		If WinExec("C:\arquiv~1\intern~1\iexplore.exe " + cDir + cArq) <> 0						
				
			MsgBox("Não foi possível Abrir o Relatório Automaticamente."+Chr(13)+;
			"Por Favor, Verifique seu e-mail, o relatório estará anexado."+Chr(13)+Chr(13)+;
			"", "Atenção")	
	        ///se não conseguir abrir nenhum, irá avisar que o arquivo chegou anexado por email
		EndIf
	Endif
EndIf

Return

***************

Static Function NomeOp( cOperado , cTipo )

***************
Local cNome := ""
Local cCoord:= ""  
Local aUsuarios := {}

If cTipo = "U" //usuário
	PswOrder(1)
	If PswSeek( cOperado, .T. )
	   aUsuarios  := PSWRET() 					
	   //cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
	   cNome := Alltrim(aUsuarios[1][4])     	// Nome completo do usuário
	   cCoord:= Alltrim(aUsuarios[1][11])     	// ID DO SUPERIOR
	Endif  
Elseif cTipo = "S" //superior
	PswOrder(1)
	If PswSeek( cCoord, .T. )
	   aUsuarios  := PSWRET() 					
	   //cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
	   cNome := Alltrim(aUsuarios[1][4])     	// Nome completo do usuário
	   //cCoord:= Alltrim(aUsuarios[1][11])     	// ID DO SUPERIOR
	Endif 
Endif

return cNome


****************************
Static Function SolicHTM(cSolic , cCoord, cNum, cGeren)
/*SolicHTM(cCoord,cSolic,dData,cAlt,cLarg,cEspess,cCor,cImpress,;
                         nQTEMB,nPrecoMR,cUF,nPesoMR,nValorIMP,nValACMR,;
                         nQTMIN,nMargem,cOBS,cUser,cDepto,cMail,CABECA,cOBS,cOBSFIN,cOBSCOM,cOBSPRD)  
*/                         
****************************

Local cWeb := ""
Local LF   := CHR(13) + CHR(10)

Z47->(Dbsetorder(1))
If Z47->(Dbseek(xFilial("Z47") + cNum ))

	cWeb := '<html>' + LF
	cWeb += '<head>' + LF
	cWeb += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">' + LF
	cWeb += '<title>SOLICITAÇÃO DE CRIAÇÃO DE PRODUTO</title>' + LF
	cWeb += '<style>' + LF
	cWeb += '<!--' + LF
	cWeb += 'div.Section1' + LF
	cWeb += '	{page:Section1;}' + LF
	cWeb += '-->' + LF
	cWeb += '</style>' + LF
	cWeb += '</head>' + LF
	cWeb += '<body>' + LF
	cWeb += '	<div align="left">' + LF
	cWeb += '		<table border="0" width="80" cellpadding="0" style="border-collapse: collapse" bordercolor="#FFFFFF">' + LF
	cWeb += '			<tr>' + LF
	cWeb += '				<td>' + LF
	cWeb += '					<a target=_blank href="http://www.ravaembalagens.com.br">' + LF
	cWeb += '					<img width="100%" border="0" id="_x0000_i1025" src="http://www.ravaembalagens.com.br/figuras/topemail.gif"></a>' + LF
	cWeb += '				</td>' + LF
	cWeb += '			</tr>' + LF
	cWeb += '		</table>' + LF
	cWeb += '	</div>' + LF
	cWeb += '	<br>' + LF
	cWeb += '	<strong>' + LF
	cWeb += '		<center>' + LF
	cWeb += "		<span style='font-size:15pt;font-family:Verdana;color:black; text-decoration:underline'>" + LF
	cWeb += '			'+ CABECA 
	cWeb += '		</span>' + LF
	cWeb += '		</center>' + LF
	cWeb += '	</strong>' + LF
	cWeb += "<span style='font-size:8pt;font-family:Verdana;color:black; text-decoration:underline'>" + LF
	cWeb += ' 	</span>	<br>' + LF
	cWeb += '	</p>' + LF
	cWeb += '	<div>' + LF
	cWeb += '		<table width="800" align=center>' + LF
	cWeb += "                <tr style='font-size:9.0pt;font-family:Verdana;color:black' bgcolor='#D6EBD8'>" + LF
	cWeb += '                <td width="200" align="Left" bgcolor="#A2D7AA" ><b>Coordenador de Vendas Solicitante</b></td>' + LF
	If Empty(cGeren)
		cWeb += '                <td width="600" align="left" colspan="2">'+iif(!Empty(cCoord), NomeOp(cCoord, "U"), "NÃO É VENDEDOR")+'</td>' + LF
	Else
		cWeb += '                <td width="600" align="left" colspan="2">O próprio Solicitante</td>' + LF
	Endif
	cWeb += '                <td width="200" align="Left" bgcolor="#A2D7AA" ><b>Solicitante</b></td>' + LF
	cWeb += '                <td width="600" align="left" >'+ cSolic +'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '               <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                <td width="200" align="Left" bgcolor="#A2D7AA" ><b>Cliente</b></td>' + LF
	cWeb += '                    <td width="600" align="Left" colspan="2">'+ Z47->Z47_CLIENT+'</td>' + LF         
	cWeb += '                <td width="200" align="Left" bgcolor="#A2D7AA" ><b>UF Cliente</b></td>' + LF
	cWeb += '                    <td width="600" align="Left" >'+ Z47->Z47_UF+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '       <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '       <td width="100" align="Left" bgcolor="#A2D7AA" ><b>Data</b></td>' + LF
	cWeb += '       <td width="100" align="left" colspan="2">'+DTOC(Z47->Z47_DATA)+'</td>' + LF
	cWeb += '       <td width="100" align="Left" bgcolor="#A2D7AA" ><b>Linha</b></td>' + LF
	cWeb += '       <td width="300" align="left">'+ Z47->Z47_LINPRO+'</td>' + LF
	
	cWeb += '       </tr> ' + LF
	
	cWeb += '       <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '       <td width="200" align="Left" bgcolor="#A2D7AA" ><b>Previsão Mensal</b></td>' + LF
	cWeb += '       <td width="600" align="left" colspan="2">'+ Z47->Z47_PREVEN +'</td>' + LF
	cWeb += '       <td width="200" align="Left" bgcolor="#A2D7AA" ><b>Previsão Unit.</b></td>' + LF
	cWeb += '       <td width="600" align="left" >'+ Z47->Z47_PREVUN  +'</td>' + LF
	
	cWeb += '                    </tr>' + LF
	cWeb += '                    <BR>' + LF
	cWeb += '                    <BR>' + LF
	cWeb += '                    <BR>' + LF
	cWeb += '       <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '				<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5"><BR><BR>' + LF
	cWeb += '			</tr>' + LF
	cWeb += '		<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                <td width="800" align="center" bgcolor="#A2D7AA" colspan="5"><b>1 - Informações Fornecidas Pelo Coordenador de Vendas Solicitante</b></td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '                    <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="200" align="Left" bgcolor="#A2D7AA" colspan="2"><b>1.1 Medidas</b></td>' + LF
	cWeb += '                    <td width="200" align="left" >Largura: '+Transform(Z47->Z47_LARGUR,"@E 999,999.9999")+'</td>' + LF
	cWeb += '                    <td width="200" align="left">Altura: ' +Transform(Z47->Z47_ALTURA , "@E 999,999.9999") +'</td>' + LF
	cWeb += '                    <td width="200" align="left">Espessura: '+ Transform(Z47->Z47_ESPESS, "@E 999,999.9999")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '        <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="200" align="Left" bgcolor="#A2D7AA" colspan="2"><b>1.2 Cor</b></td>' + LF
	cWeb += '                    <td width="300" align="left" colspan="3">'+ Z47->Z47_COR+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '        <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="200" align="Left" bgcolor="#A2D7AA" colspan="2"><b>1.3 Impressão (S/N)</b></td>' + LF
	cWeb += '                    <td width="300" align="left" colspan="3">'+ iif(Z47->Z47_IMPRES = "S" , "Sim" , "Nao" )+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '        <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="300" align="Left" bgcolor="#A2D7AA" colspan="2"><b>1.4 Quantde. por Embalagem</b></td>' + LF
	cWeb += '                    <td width="200" align="left" colspan="3">'+Transform( Z47->Z47_QTEMB, "@E 999,999.99")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '        <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="400" align="Left" bgcolor="#A2D7AA" colspan="3"><b>1.5 Preço por milheiro Sem IPI<BR> (caso o cliente já compre de um concorrente)</b></td>' + LF
	cWeb += '                    <td width="200" align="left" colspan="3">'+Transform( Z47->Z47_PRECMR, "@E 999,999.99")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '        <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="400" align="Left" bgcolor="#A2D7AA" colspan="3"><b>1.6 Estado onde será entregue o Produto</b></td>' + LF
	cWeb += '                    <td width="200" align="left" colspan="3">'+ Z47->Z47_UF+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '        <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '				<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5"><BR><BR>' + LF
	cWeb += '			</tr>' + LF
	cWeb += '	<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                <td width="800" align="center" bgcolor="#A2D7AA" colspan="5"><b>2 - Informações Fornecidas Pela Equipe de Produção</b></td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '                    <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="500" align="Left" bgcolor="#A2D7AA" colspan="2"><b>2.1 Peso do Milheiro</b></td>' + LF
	cWeb += '                    <td width="300" align="left" colspan="3">'+Transform(Z47->Z47_PESOMR, "@E 999,999.99")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="500" align="Left" bgcolor="#A2D7AA" colspan="2"><b>2.2 Valor do clichê para Impressão</b></td>' + LF
	cWeb += '                    <td width="300" align="left" colspan="3">'+Transform(Z47->Z47_VLRCLI, "@E 999,999.99")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="500" align="Left" bgcolor="#A2D7AA" colspan="3"><b>2.3 Valor acrescido no milheiro<BR>(Por uso a mais de sacos capas)</b></td>' + LF
	cWeb += '                    <td width="300" align="left" colspan="3">'+Transform(Z47->Z47_VLACMR,"@E 999,999.99")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="500" align="Left" bgcolor="#A2D7AA" colspan="3"><b>2.4 Quantde. Mínima para Produção</b></td>' + LF
	cWeb += '                    <td width="300" align="left" colspan="3">'+Transform(Z47->Z47_QTEMB, "@E 999,999.99")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '				<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5"><BR><BR>' + LF
	cWeb += '			</tr>' + LF
	cWeb += '	<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                <td width="800" align="center" bgcolor="#A2D7AA" colspan="5"><b>3 - Informações Fornecidas Pelo Financeiro</b></td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '                    <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="500" align="Left" bgcolor="#A2D7AA" colspan="3"><b>3.1 Margem de Lucro<BR>(Quando houver um preço do milheiro como referência)</b></td>' + LF
	cWeb += '                    <td width="300" align="left" colspan="3">'+Transform(Z47->Z47_MARGEM, "@E 999,999.99")+'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                    <td width="400" align="Left" bgcolor="#A2D7AA" colspan="3"><b>3.2 Observações Financeiro</b></td>' + LF
	cWeb += '                    <td width="200" align="left" colspan="3">'+ Z47->Z47_OBSFIN +'</td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '			 <td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5"><BR><BR>' + LF
	cWeb += '			</tr>' + LF
	
	cWeb += '	<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                <td width="800" align="center" bgcolor="#A2D7AA" colspan="5"><b>Parecer da Diretoria de Produção</b></td>' + LF
	cWeb += '                    </tr>' + LF                                                                                                
	cWeb += '   <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '			 <td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5">'+ Z47->Z47_OBSPRD +'<BR><BR>' + LF
	cWeb += '			</tr>' + LF
	
	cWeb += '	<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                <td width="800" align="center" bgcolor="#A2D7AA" colspan="5"><b>Parecer da Diretoria Comercial</b></td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '			 <td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5">'+ Z47->Z47_OBSCOM+'<BR><BR>' + LF
	cWeb += '			</tr>' + LF
	
	
	cWeb += '	<tr style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '                <td width="800" align="center" bgcolor="#A2D7AA" colspan="5"><b>Observações Gerais</b></td>' + LF
	cWeb += '                    </tr>' + LF
	cWeb += '   <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '			 <td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5">'+ Z47->Z47_OBS+'<BR><BR>' + LF
	cWeb += '			</tr>' + LF
	
	
	cWeb += '   <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '				<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5"><BR><BR>' + LF
	cWeb += '			</tr>' + LF
	cWeb += '    <tr style="font-size:8.5pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
	cWeb += '				<td style="font-size:9.0pt;font-family:Verdana;color:black" bgcolor="#E2E9E6" width="660" colspan="5"><BR><BR>' + LF
	cWeb += '                Atenciosamente,<BR><BR><BR>' + LF
	cWeb += '                '+NomeOp(cUser,"U")+'<BR>' + LF
	cWeb += '                '+cDepto+'<BR>' + LF
	cWeb += '                '+cMail+'<br>'  + LF
	cWeb += '<p><span style="FONT-SIZE: 7pt; COLOR: black; FONT-FAMILY: Verdana">' + LF
	cWeb += '<< "ESTC003.html" >></span></p>' + LF
	cWeb += '</table>' + LF
	cWeb += '</body>' + LF
	cWeb += '</html>' + LF
	MemoWrite("c:\temp\estc003.html",cWeb) 
Endif
Return(cWeb)