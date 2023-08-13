#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"


***********************

User Function COMC015()

***********************


//IF Pergunte("WFCOM001",.T.)
    MsAguarde( { || fMbrowse() }, "Aguarde. . .", "Follow Up de Compras. . ." )
//ENDIF 


Return                                               

******************************************************************************************************
User Function LegFoll()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE" ,	"Follow_Up Aberto"},;
								{"BR_AMARELO",	"Follow-Up Aguardando"},;
								{"BR_LARANJA",	"LigaГЦo NЦo Completada"},;
								{"BR_VERMELHO",	"Follow-Up Concluido"},;
								{"BR_PRETO",	"Follow-Up Cancelado"}} )
								
Return .T.

***************

Static Function fMbrowse() 

***************

Local aCores := {{ "Z78->Z78_STATUS == '1'", 'BR_VERDE'    },; 
				 { "Z78->Z78_STATUS == '2'", 'BR_AMARELO'  },; 
				 { "Z78->Z78_STATUS == '4'", 'BR_LARANJA'  },;
				 { "Z78->Z78_STATUS == '3'", 'BR_VERMELHO' },; 
                 { "Z78->Z78_STATUS == '5'", 'BR_PRETO' }} 
                 
Private cCadastro := "Follow Up de Compras"   

dbSelectArea("Z78")
dbSetOrder(2)

 /*
 Set Filter To Z78->Z78_FILIAL = xFilial("Z78").AND.;
               Z78->Z78_LISTA=ALLTRIM(STR(MV_PAR01))  // LISTA
 */
 
PRIVATE aRotina     := {{"Pesquisar" , ""  ,0, 1 },;
                        {"Visualizar", "U_fZ8TELA('Z78',2,Z78->(Recno()) )"  ,0, 2 },;
                        {"Incluir"   , "ALERT('VocЙ NЦo Tem PermissЦo Para Incluir Follow-Up')"  ,0, 3 },;
                        {"Follow-Up"   , "U_fZ8TELA('Z78',4,Z78->(Recno()) )"  ,0, 4 },;
                        {"Excluir"   , "ALERT('VocЙ NЦo Tem PermissЦo Para Excluir Follow-Up')"  ,0, 7 },;
                        {"Legenda"   , "U_LegFoll()"  ,0, 6 }}

//SetKey(  VK_F12,  { || U_COMC015() } )                                                         
 

mBrowse( 6, 1,22,75, "Z78",,,,,,aCores)


/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠ЁPrograma  :NEWSOURCE Ё Autor :TEC1 - Designer       Ё Data :02/05/2014 Ё╠╠
╠╠цддддддддддеддддддддддадддддддеддддддддбддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao :                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametros:                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   :                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       :                                                            Ё╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/

User Function fZ8TELA(cAliasE,nOpcE,nRegE)

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de Variaveis do Tipo Local, Private e Public                 ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
Local aPos       := {012,008,064,501}   //{012,008,120,501}  //Vetor com coordenadas para criacao da enchoice no formato <top>, <left>, <bottom>, <right>
Local caTela     := ""  // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.  //Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.  //Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.  //Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .F.  //Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .T.  //Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nCntFor 
Local nModelo    := 3  //Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nOpc       := GD_UPDATE
//Local nOpcE      := 4  //Numero da linha do aRotina que definira o tipo de edicao (Inclusao, Alteracao, Exclucao, Visualizacao)
//Local nRegE      := 0  //Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)
Private aCoBrw1 := {}
Private aHoBrw1 := {}
//Private ALTERA   := ..F.
Private bCampo   := {|nCPO| Field(nCPO)}
//Private DELETA   := ..F.
//Private INCLUI   := ..T.
Private noBrw1  := 0
//Private VISUAL   := ..F.
//Private cAliasE    := "Z78"  //Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Private aAlterEnch := {"Z78_STATUS"}  //Vetor com nome dos campos que poderao ser editados
Private aCpoEnch   := {}// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Private EXCLUI   := .F.
PRIVATE cFColsG:= 'Z78_DTFORN/Z78_DTPRCH/Z78_REACHE/Z78_OBSERV/'

If nOpcE=2 // visualizar 
   cFColsG:= " "
endif


CPEDIDO:=Z78->Z78_PEDIDO
CFORNECE:=Z78->Z78_FORNEC
CLOJA:=Z78->Z78_LOJA


/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de Variaveis Private dos Objetos                             ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
SetPrvt("oDlg1","oBrw1")
/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ Definicao do Dialog e todos os seus componentes.                        ╠╠
ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
oDlg1      := MSDialog():New( 138,254,737,1329,"Follow Up de Compras",,,.F.,,,,,,.T.,,,.F. )

CdaMemory(cAliasE,nOpcE)
Enchoice(cAliasE,nRegE,nOpcE,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlg1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
MHoBrw1()
//MCoBrw1()
CabecS(CPEDIDO,CFORNECE,CLOJA)
oBrw1      := MsNewGetDados():New(084,008,226,501,nOpc,'AllwaysTrue()','AllwaysTrue()','',Campos(cFColsG,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 ) //MsNewGetDados():New(136,008,195,501,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 )

oSBtn1     := SButton():New( 248,440,1,,oDlg1,,"", )
oSBtn1:bAction := {||FOK(nOpcE)}
oSBtn2     := SButton():New( 248,475,2,,oDlg1,,"", )
oSBtn2:bAction := {||oDlg1:END()}

oDlg1:Activate(,,,.T.)

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: Z78
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function MHoBrw1()

Local cFCols := "Z78_ITEM/Z78_PRODUT/Z78_QUANTI/Z78_NUMSC/Z78_DTENTR/Z78_DTFORN/Z78_DTPRCH/Z78_REACHE/Z78_OBSERV/"


DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("Z78")
While !Eof() .and. SX3->X3_ARQUIVO == "Z78"
   If cNivel >= SX3->X3_NIVEL .and. Alltrim(SX3->X3_CAMPO) $ cFCols 
      noBrw1++
      Aadd(aHoBrw1,{Trim(X3Titulo()),;
                 SX3->X3_CAMPO,;
                 SX3->X3_PICTURE,;
                 SX3->X3_TAMANHO,;
                 SX3->X3_DECIMAL,;
                 SX3->X3_VALID,;
                 "",;
                 SX3->X3_TIPO,;
                 "",;
                 "" })

   EndIf
   DbSkip()
End

Return


/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: Z78
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function MCoBrw1()

Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.

Return


***************

Static Function CdaMemory(cAlias,nOpcE)

***************

SX3->(DbSetOrder(1))
SX3->(MsSeek(cAlias))

While ! SX3->(Eof()) .And. SX3->x3_arquivo == cAlias
            If SX3->X3_CONTEXT = "V"     // Campo virtual
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



************************
static function CabecS(CPEDIDO,CFORNECE,CLOJA)
************************


//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta cabecalho.                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды


dbSelectArea("Z78")
dbSetOrder(2)
Z78->(DBSEEK(XFILIAL("Z78") +CPEDIDO+CFORNECE+CLOJA ))  
nSavReg := Recno()

nCnt := 0
While (! INCLUI ).And. !Eof() .And. Z78->Z78_PEDIDO==CPEDIDO .And. Z78->Z78_FORNECE==CFORNECE .And. Z78->Z78_LOJA ==CLOJA     
            nCnt++
            dbSkip()
End

If ! INCLUI //Indica se verifica existencia dos
            If nCnt == 0 // itens
                        cHelp := "NЦo existe(m) item(s) no <Z78> para este Registro no <Z78>."          
                        Help( ''  , 1 , 'NVAZIO' ,OemToAnsi( "ITENS" ) ,OemToAnsi( cHelp ), 1 , 0 )
                        Return .T.
            Endif
Endif

nCnt := If(nCnt = 0, 1, nCnt)

for nI := 1 to nCnt
   Aadd(aCoBrw1,Array(noBrw1+1))
   for nJ := 1 to noBrw1
      aCoBrw1[nI][nJ] := CriaVar(aHoBrw1[nJ][2])
   next   
   aCoBrw1[nI][noBrw1+1] := .F.   
Next

dbSelectArea("Z78")
dbSetOrder(2)
dbGoTo(nSavReg)
nCnt := 0

while !INCLUI .And. !Eof() .And.Z78->Z78_PEDIDO==CPEDIDO .And. Z78->Z78_FORNECE==CFORNECE .And. Z78->Z78_LOJA ==CLOJA   
   noBrw1 := 0
   nCnt++

   for nHeader := 1 to len(aHoBrw1)
      //if X3USO(aHoBrw1[nHeader][7]) 
         noBrw1++
         if aHoBrw1[nHeader][10] = "V"                                        // Campo virtual
            if ! empty(aHoBrw1[nHeader][13])                     // inicializador BROWSE
               aCoBrw1[nCnt][noBrw1] := &(aHoBrw1[nHeader][13])
            endif
         else
            aCoBrw1[nCnt][noBrw1] := &("Z78->" + aHoBrw1[nHeader][2])                   
         endif
      //endif
   next
   aCoBrw1[nCnt][noBrw1 + 1] := .F.


   If ALTERA .Or. EXCLUI 
      SoftLock("Z78")
   endif
   DbSkip()
enddo

if nCnt = 0
            nCnt ++
            noBrw1 := 0
            for nHeader := 1 To Len(aHoBrw1)
              //        if X3USO(aHoBrw1[nHeader][7])
                                   noBrw1++
                                   if aHoBrw1[nHeader][10] = "V"                                      // Campo virtual
                                               if ! Empty(aHoBrw1[nHeader][13])                     // inicializador BROWSE
                                                           aCoBrw1[nCnt][noBrw1] := &(aHoBrw1[nHeader][13])
                                               endif
                                   elseIf INCLUI
                                               aCoBrw1[nCnt][noBrw1] := CriaVar(AllTrim(aHoBrw1[nHeader][2]))
                                   else
                                               aCoBrw1[nCnt][noBrw1] := &("Z78->" + aHoBrw1[nHeader][2])
                                   endif
               ///      endif
            next
            aCoBrw1[nCnt][noBrw1+1] := .F.
endif


return 



***************

Static Function Campos( cString,;         // String a ser processada
                                                               cDelim,;       // Delimitador
                                                               lAllTrim;        // Tira espacos em brancos
                                                                 )
***************

Local aRetorno := {}      // Array de retorno
Local nPos                                          // Posicao do caracter

cDelim             := If( cDelim = Nil, ' ', cDelim )
lAllTrim             := If( lAllTrim = Nil, .t., lAllTrim )
             
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
Static Function FOK(nOpcE)
***************

Local nDtForn := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z78_DTFORN" })
Local nReache := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z78_REACHE" })
Local nOBS := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z78_OBSERV" }) 
Local nProd := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z78_PRODUT" }) 
Local nPreCH := aScan(aHoBrw1,{|x| Alltrim(x[2]) == "Z78_DTPRCH"})

Local cStatus:=M->Z78_STATUS

If nOpcE=4 // alterar
   for _X:=1 to len(aCoBrw1)
       dbSelectArea("Z78")
       dbSetOrder(2)
      if Z78->(DBSEEK(XFILIAL("Z78") +CPEDIDO+CFORNECE+CLOJA+oBrw1:aCols[_X][nProd] ))  
                 RecLock("Z78", .F.) 
                 Z78->Z78_DTFORN:= oBrw1:aCols[_X][nDtForn]      
         	     Z78->Z78_REACHE:= oBrw1:aCols[_X][nReache]            
         		 Z78->Z78_OBSERV:= oBrw1:aCols[_X][nOBS]      
         		 Z78->Z78_DTPRCH := oBrw1:aCols[_X][nPreCH]
         		//  STATUS
         		
         		Z78->Z78_STATUS:=cStatus         
         		//
         Z78->(MsUnLock())              
      endif   
   Next
   // alert('AlteraГЦo realizada com Sucesso.')
   
   fEmailF(CPEDIDO)
   
   oDlg1:END()
   
   
   
Else
   oDlg1:END()
endif

Return 

/*
Static Function fEmailF(cPed)

Local cUsuario := __CUSERID  
Local cUsuPedi := ""
Local cEmailSo := ""
Local aUsuPedi := {}
Local cMsg     := ""
Local cNumSoli := ""
DL := CHR(13) + CHR(10)
subj := ""

cUsuPedi := Posicione( "SC1", 6, xFilial("SC1") + cPed, ALLTRIM("C1_USER") )
cNumSoli := Posicione( "SC1", 6, xFilial("SC1") + cPed, ALLTRIM("C1_NUM") )

//DBSELECTAREA("Z78")

PswOrder(1)               					//SELECIONA A ORDEM DE PESQUISA DO USUаRIO UTILIZADA PELA PSWSEEK ABAIXO
If PswSeek( cUsuPedi , .T. ) 				//SE USUаRIO LOGADO ESTIVER NO SIGAPSW ENTRA  
   	aUsuPedi   := PSWRET() 	  				//JOGA NA aUsu O VETOR COM INFORMAгуES DO USUаRIO			
	cEmailSo   := ALLTRIM(aUsuPedi[1][14]) 
Endif
				
		  if !Empty(Z78->Z78_DTFORN)
				cMsg := "Follow Up da Compra NЗmero :" + cNumSoli
	    		cMsg += DL
	    		cMsg += "estА Previsto pra ser Faturado em: " + dtoc(Z78->Z78_DTFORN)
	    	    cMsg += DL
	    	    cMsg += "ObservaГУes: " + Z78->Z78_OBSERV
	    	    cMsg += DL	    	  	 
	    		subj := "Follow Up da SolicitaГЦo de Compra NЗmero" + cNumSoli   		
	       		U_SendFatr11(cEmailSo, "", subj, cMsg, "" )
	      		alert('Email Enviado para o Solicitante.')
	      endif 
	      
	      if !Empty(Z78->Z78_REACHE)
				cMsg += "A Data de Chegada da Mercadoria И: " + dtoc(Z78->Z78_DTFORN)
	       		cMsg += DL
	       		subj := "Follow Up da SolicitaГЦo de Compra NЗmero" + cNumSoli
	       		U_SendFatr11(cEmailSo, "", subj, cMsg, "" )
	      endif
	      		
	   
	

Return
*/

Static Function fEmailF(cPed)

local cQuery:=" "
Local cUsuPedi := ""
Local cEmailSo := ""
Local aUsuPedi := {}

cUsuPedi := Posicione( "SC1", 6, xFilial("SC1") + cPed, ALLTRIM("C1_USER") )

PswOrder(1)   
If PswSeek( cUsuPedi , .T. ) 			
   	aUsuPedi   := PSWRET() 	  			
	cEmailSo   := ALLTRIM(aUsuPedi[1][14]) 
Endif
				

If Select("TRAX") > 0
	DbSelectArea("TRAX")
	TRAX->(DbCloseArea())
EndIf

cQuery:="SELECT "
cQuery+="Z78_PEDIDO,Z78_STATUS,Z78_FORNEC,Z78_LOJA,Z78_CONTAT,Z78_NOMEFO,Z78_TELEFO, "
cQuery+="Z78_ITEM,Z78_PRODUT,Z78_QUANTI,Z78_NUMSC,Z78_DTENTR,Z78_DTFORN,Z78_DTPRCH,Z78_REACHE,Z78_OBSERV "
cQuery+="FROM Z78020 Z78 "
cQuery+="WHERE Z78_PEDIDO='"+cPed+"' AND Z78_STATUS<>'1' " // DIFIERENTE DE EM ABERTO 
cQuery+="AND Z78.D_E_L_E_T_='' "


TCQUERY cQuery NEW ALIAS "TRAX"

TCSetField( "TRAX", "Z78_DTENTR"  , "D")
TCSetField( "TRAX", "Z78_DTFORN"  , "D")
TCSetField( "TRAX", "Z78_DTPRCH"  , "D")
TCSetField( "TRAX", "Z78_REACHE"  , "D")

TRAX->( DbGoTop() )


Do While ! TRAX->( EoF() )
  
  cNum:=TRAX->Z78_PEDIDO
  
  oProcess:=TWFProcess():New("followup","followup")
  oProcess:NewTask('Inicio',"\workflow\http\emp01\followup.htm")
  oHtml   := oProcess:oHtml

  oHtml:ValByName( "cPC",cNum  )
  oHtml:ValByName( "cStatus",X3COMBO("Z78_STATUS",TRAX->Z78_STATUS)  )
  oHtml:ValByName( "cFornec",TRAX->Z78_FORNEC+'-'+TRAX->Z78_LOJA  )
  oHtml:ValByName( "cContato",TRAX->Z78_CONTAT  )
  oHtml:ValByName( "cNomefo",TRAX->Z78_NOMEFO )
  oHtml:ValByName( "cfone",TRANSFORM(TRAX->Z78_TELEFO,'@R 9999999999') )
    
  Do While ! TRAX->( EoF() ) .AND. TRAX->Z78_PEDIDO==cNum
    

    aadd( oHtml:ValByName("it.citem") ,TRAX->Z78_ITEM )
	aadd( oHtml:ValByName("it.cprod" ),TRAX->Z78_PRODUT)
    aadd( oHtml:ValByName("it.cQTD" ), TRAX->Z78_QUANTI )
    aadd( oHtml:ValByName("it.cSC" ),TRAX->Z78_NUMSC)
    aadd( oHtml:ValByName("it.CDTENT" ),DtoC(TRAX->Z78_DTENTR)  )
    aadd( oHtml:ValByName("it.CDTFAT" ),DtoC(TRAX->Z78_DTFORN) )
    aadd( oHtml:ValByName("it.CPRE" ),  DtoC(TRAX->Z78_DTPRCH) )
    aadd( oHtml:ValByName("it.CREAL" ),DtoC(TRAX->Z78_REACHE) )
    aadd( oHtml:ValByName("it.COBS" ),TRAX->Z78_OBSERV )
                                              
    TRAX->( DbSkip() )
  
  EndDo

  _user := Subs(cUsuario,7,15)
  oProcess:ClientName(_user)
  oProcess:cTo := cEmailSo
//  oProcess:cTo := "antonio.feitosa@ravabrasil.com.br" // TESTE 
  subj	:= "Follow Up  - "+cNum
  oProcess:cSubject  := subj
  oProcess:Start()
  WfSendMail()

EndDo

TRAX->( DbCloseArea() )



Return

