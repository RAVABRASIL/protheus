#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GPER005                               º Data ³  04/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório AVISO SOBRE TÉRMINO DO PERÍODO DE EXPERIÊNCIA    º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado pelo chamado 002271 - Michele                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							

/*
Solicitado no chamado 002271 - Michele:

*/

***************************
User Function GPER005()
***************************


Private lDentroSiga := .F.


/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	fEXP()	//chama a função do relatório 
  	/*
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  	sleep( 5000 )
  
  	fEXP()	//chama a função do relatório
    */
  
Else
  lDentroSiga := .T.
  
  fEXP()

EndIf


Return   

*************************
Static Function fEXP() 
*************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Periodo Experiência a Vencer"
Local cPict          := ""
Local titulo         := "Funcionarios c/ Periodo de Experiencia a Vencer"


Local Cabec1         := "Matricula   Nome                           Funcao              Vencto. 1o.Periodo Exp.         Vencto. 2o.Periodo Exp."
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "GPER005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GPER005" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "GPER005"
Private cCodUser := "" //__CUSERID 
Private cNomeUser:= ""
Private cMailUser:= ""
Private aUsua	 := {}
Private nLin     := 80
Private nLinhas  := 80
Private nPag	 := 1

Private cString := "SRA" 

dbSelectArea("SRA")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
	Pergunte(cPerg,.T.)
	
	cCodUser := __CUSERID
	PswOrder(1)
	If PswSeek( cCodUser, .T. )
	   	aUsua := PSWRET() 						// Retorna vetor com informações do usuário
	   	//cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
	   	cNomeUser := Alltrim(aUsua[1][4])		// Nome do usuário
	   	cMailUser := Alltrim(aUsua[1][14])     // e-mail do usuário
	Endif
	 
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
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
Else
	RunReport(Cabec1,Cabec2,Titulo,nLin)

Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/09/11   º±±
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


Local cQuery	:=' '

Local eEmail	:= ""
Local cEmpresa  := ""   
Local cNomeSetor:= ""
Local cMat		:= ""
Local cCentro   := ""
Local cTurno	:= ""
Local cNome		:= "" 
Local cHtm		:= "" 
Local cDirHTM   := ""    
Local cArqHTM   := ""   
Local nHandle   := 0

Local cDir   := ""    
Local cArq   := ""   
Local nHand  := 0 
Local lDir	 := .F.
 
Local cVar		:= "" 
Local fr		:= 0 
Local cFuncao   := ""
Local aFunc     := {}
Local aFunc2    := {}
Local cEnviPara := GetMv("RV_GERRH")   //email do(a) ger. RH
Local cFilemp   := ""
Local cNomeFil  := ""

Private cCodFil	:= "" 
Private LF 		:= CHR(13) + CHR(10)

cEnviPara += ";" + GetMv("RV_GPER005")    //emails dos assist. RH

//1o. periodo da experiência a vencer
cQuery := "Select RA_FILIAL, RA_MAT, RA_NOME, RA_CODFUNC, RJ_DESC, RA_TNOTRAB, RA_VCTOEXP, RA_VCTEXP2 " + LF
cQuery += ", RA_CC " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SRA") + " SRA, " + LF
cQuery += " " + RetSqlName("SRJ") + " SRJ " + LF
//cQuery += " " + RetSqlName("SR6") + " SR6 " + LF

cQuery += "WHERE " + LF
//cQuery += "RA_FILIAL = '" + Alltrim(xFilial("SRA")) + "' " + LF
cQuery += " RA_CODFUNC = RJ_FUNCAO " + LF
cQuery += " AND RA_SITFOLH <> 'D' "  + LF
cQuery += " AND SRA.D_E_L_E_T_ = '' " + LF
cQuery += " AND SRJ.D_E_L_E_T_ = '' " + LF
//cQuery += " AND SR6.D_E_L_E_T_ = '' " + LF

//cQuery += " AND SRA.RA_MAT >= '00135'  " + LF

If lDentroSiga
	cQuery += " AND SRA.RA_MAT >= '" + Alltrim(mv_par01) + "' AND SRA.RA_MAT <= '" + Alltrim(mv_par02) + "' " + LF
Endif
cQuery += " AND ( RA_VCTOEXP <> '' OR RA_VCTEXP2 <> '') " + LF
If !lDentroSiga
	//cQuery += " AND CAST( CAST(RA_VCTOEXP AS DATETIME)  -  CAST(GETDATE() AS DATETIME) AS INTEGER ) >= 5 " + LF
	cQuery += " AND CAST( CAST(RA_VCTOEXP AS DATETIME)  -  CAST('" + Dtos(dDatabase) + "' AS DATETIME) AS INTEGER ) = 5 " + LF
Endif

//cQuery += " AND RA_TNOTRAB = R6_TURNO  " + LF
cQuery += " ORDER BY RA_FILIAL, RA_VCTOEXP, RA_MAT " + LF
MemoWrite("C:\Temp\VENC_EXP1.sql", cQuery )
		          
If Select("RAXX") > 0
	DbSelectArea("RAXX")
	DbCloseArea()
EndIf
		
TCQUERY cQuery NEW ALIAS "RAXX"
TCSetField( "RAXX", "RA_VCTOEXP", "D")
TCSetField( "RAXX", "RA_VCTEXP2", "D")
                                        
cCodFil	:= SM0->M0_CODFIL

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava-" + SM0->M0_FILIAL
Endif

cHtm := ""

RAXX->(DbGoTop())
If lDentroSiga
	SetRegua(RecCount())
Endif

////CRIA O HTM com todos os funcionários 
//cDirHTM  := "\Temp\"    
//cArqHTM  := "EXP_VENC.htm"  //+ Alltrim(cEmpresa) + ".HTM"   
				
//nHandle := fCreate( cDirHTM + cArqHTM, 0 )
				    
//If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
//     Return
//Endif

/*
GESTORES POR CENTRO DE CUSTO:
C/CUSTO 1010 - DIRETORIA   		HUMBERTO
C/CUSTO 2010 - ADMINISTRATIVO  	REGINEIDE 
C/CUSTO 2020 - FINANCEIRO      	REGINA
C/CUSTO 2025 - CONTABILIDADE    ANTONIO.SOUSA
C/CUSTO 2040 - COMPRAS 			RODRIGO 
C/CUSTO 2050 - SERVICOS GERAIS	CLAUDIA 
C/CUSTO 2080 - INFORMATICA 		EURIVAN 
C/CUSTO 2085 - SAC 				DANIELA 
C/CUSTO 2090 - RECURSOS HUMANOS	EDILICIA 
C/CUSTO 3010 - VENDAS 			FLAVIA LEITE 
C/CUSTO 3020 - LICITACAO		FLAVIA LEITE  
C/CUSTO 3050 - EXPEDICAO 		JACIARA 
C/CUSTO 7010 - EXTRUSAO - PEAD	ROBINSON 
C/CUSTO 7020 - CORTE / SOLDA - SACOS	ROBINSON 
C/CUSTO 7035 - CONTROLE DE QUALIDADE	JORGE 
C/CUSTO 7040 - EMBALAGEM / PESAGEM		ROBINSON 
C/CUSTO 7050 - MANUTENCAO MECANICA		JORGE 
C/CUSTO 7060 - MANUTENCAO ELETRICA		JORGE 
C/CUSTO 7080 - ALMOXARIFADO 			RODRIGO
C/CUSTO 7085 - ENGENHARIA INDUSTRIAL	JORGE  

*/
If !RAXX->(EOF())

	////CRIA O HTM 
   	//cDirHTM  := "\Temp\"    
	//cArqHTM  := "EXP_VENC.htm"  //+ Alltrim(cEmpresa) + ".HTM"   
				
	//nHandle := fCreate( cDirHTM + cArqHTM, 0 )
				    
	//If nHandle = -1
	     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	//     Return
	//Endif
				
	If lDentroSiga
		////cria o diretório local, caso não exista
		lDir := ExistDir('C:\RELTEMP') // Resultado: .F.
		cDir := "C:\RELTEMP\"
		If !lDir
			//msgbox("cria Dir")
			U_CriaDir( cDir ) 
		Endif
		////CRIA O HTM 	  
		cArq  := "EXP_VENC.htm" //+ Alltrim(cEmpresa) + ".HTM"   
		nHand := fCreate( cDir + cArq, 0 )			    
		If nHand = -1
		     //MsgAlert('o arquivo '+AllTrim(cArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
	Endif  
		
	Do while !RAXX->(EOF()) 
	
		cMat 		:= RAXX->RA_MAT 
		cNome		:= RAXX->RA_NOME
		dVCTOEXP	:= RAXX->RA_VCTOEXP
		dVCTOEXP2	:= RAXX->RA_VCTEXP2
		cFuncao     := RAXX->RJ_DESC
		cCentro     := RAXX->RA_CC
		
		cFilemp     := RAXX->RA_FILIAL
		SM0->(Dbsetorder(1))
		If SM0->(Dbseek(SM0->M0_CODIGO  + cFilemp ) )
			cNomeFil := SM0->M0_FILIAL
		Endif 
	
		Aadd( aFunc, { cMat, cNome, cFuncao, dVCTOEXP, dVCTOEXP2, cFilemp, cNomeFil, cCentro } )                   
		DbSelectArea("RAXX")
		RAXX->(DBSKIP())
	Enddo
Endif	
	
///2o. periodo experiência
cQuery := "Select RA_FILIAL, RA_MAT, RA_NOME, RA_CODFUNC, RJ_DESC, RA_TNOTRAB, RA_VCTOEXP, RA_VCTEXP2, RA_CC " + LF

cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SRA") + " SRA, " + LF
cQuery += " " + RetSqlName("SRJ") + " SRJ " + LF

cQuery += "WHERE " + LF
cQuery += "RA_FILIAL = '" + Alltrim(xFilial("SRA")) + "' " + LF
cQuery += " AND RA_CODFUNC = RJ_FUNCAO " + LF
cQuery += " AND RA_SITFOLH <> 'D' "  + LF
cQuery += " AND SRA.D_E_L_E_T_ = '' " + LF
cQuery += " AND SRJ.D_E_L_E_T_ = '' " + LF
If lDentroSiga
	cQuery += " AND SRA.RA_MAT >= '" + Alltrim(mv_par01) + "' AND SRA.RA_MAT <= '" + Alltrim(mv_par02) + "' " + LF
Endif
cQuery += " AND ( RA_VCTOEXP <> '' OR RA_VCTEXP2 <> '') " + LF
If !lDentrosiga
	//cQuery += " AND CAST( CAST(RA_VCTEXP2 AS DATETIME)  -  CAST(GETDATE() AS DATETIME) AS INTEGER ) >= 5 " + LF
	cQuery += " AND CAST( CAST(RA_VCTEXP2 AS DATETIME)  -  CAST('" + Dtos(dDatabase) + "' AS DATETIME) AS INTEGER ) = 5 " + LF
Endif


cQuery += " ORDER BY RA_FILIAL, RA_VCTEXP2, RA_MAT " + LF
MemoWrite("C:\Temp\VENC_EXP2.sql", cQuery )
		          
If Select("RAXX") > 0
	DbSelectArea("RAXX")
	DbCloseArea()
EndIf
		
TCQUERY cQuery NEW ALIAS "RAXX"
TCSetField( "RAXX", "RA_VCTOEXP", "D")
TCSetField( "RAXX", "RA_VCTEXP2", "D")

RAXX->(DbGoTop())
If lDentroSiga
	SetRegua(RecCount())
Endif

cMat 		:= ""
cNome		:= ""
dVCTOEXP	:= Ctod("  /  /    ")
dVCTOEXP2	:= Ctod("  /  /    ")
cFuncao     := ""
cCentro     := ""
		
If !RAXX->(EOF())
 		
	Do while !RAXX->(EOF()) 
	
		cMat 		:= RAXX->RA_MAT 
		cNome		:= RAXX->RA_NOME
		dVCTOEXP	:= RAXX->RA_VCTOEXP
		dVCTOEXP2	:= RAXX->RA_VCTEXP2
		cFuncao     := RAXX->RJ_DESC
		cFilemp     := RAXX->RA_FILIAL
		cCentro     := RAXX->RA_CC
		SM0->(Dbsetorder(1))
		If SM0->(Dbseek(SM0->M0_CODIGO  + cFilemp ) )
			cNomeFil := SM0->M0_FILIAL
		Endif  
	
		Aadd( aFunc2, { cMat, cNome, cFuncao, dVCTOEXP, dVCTOEXP2, cFilemp, cNomeFil, cCentro } )                   
		DbSelectArea("RAXX")
		RAXX->(DBSKIP())
	Enddo	
Endif	
	
	aFunc := Asort( aFunc,,, { |X,Y| X[8] + Dtoc(X[4]) + X[1]  <  Y[8] + Dtoc(Y[4]) + Y[1]  } )
	aFunc2:= Asort( aFunc2,,,{ |X,Y| X[8] + Dtoc(X[4]) + X[1]  <  Y[8] + Dtoc(Y[4]) + Y[1]  } )


//envia para cada gestor
cCentro := ""
//Aadd( aFunc, { cMat, cNome, cFuncao, dVCTOEXP, dVCTOEXP2, cFilemp, cNomeFil, cCentro } )                   
//Aadd( aFunc2, { cMat, cNome, cFuncao, dVCTOEXP, dVCTOEXP2, cFilemp, cNomeFil, cCentro } )                    

//ordena por Filial + Centro de Custo + Data Vencimento do periodo Experiência + Matrícula
aFunc := Asort( aFunc,,, { |X,Y| X[8] + X[6] + Dtoc(X[4]) + X[1]  <  Y[8] + Y[6] + Dtoc(Y[4]) + Y[1]  } )
aFunc2:= Asort( aFunc2,,,{ |X,Y| X[8] + X[6] + Dtoc(X[5]) + X[1]  <  Y[8] + Y[6] + Dtoc(Y[4]) + Y[1]  } )
nLinhas := 80 
cHtm    := "" 
cGestor := ""
fr := 1    
If Len(aFunc) > 0 
							
	While fr <= Len(aFunc)
		cCentro := Alltrim(aFunc[fr,8])
		cGestor := ""
		////CRIA O HTM 
		cDirHTM  := "\Temp\"    
		cArqHTM  := "EXP_VENC1_" + Alltrim(cCentro) + ".htm"  //+ Alltrim(cEmpresa) + ".HTM"   
						
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
						    
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		Do Case
		
			Case Alltrim(cCentro) = '1010' //C/CUSTO 1010 - DIRETORIA   		HUMBERTO 
				eEmail := "rh@ravaembalagens.com.br"
			    cGestor:= "RH"
			Case Alltrim(cCentro) = '2010' //C/CUSTO 2010 - ADMINISTRATIVO  	REGINEIDE
				eEmail := "regineide.neves@ravaembalagens.com.br" 
			    cGestor:= "Regineide Neves"
			Case Alltrim(cCentro) =	'2020' //C/CUSTO 2020 - FINANCEIRO      	REGINA
				eEmail := "regina@ravaembalagens.com.br"
		        cGestor:= "Regina Assis"
		    Case Alltrim(cCentro) = '2025' //C/CUSTO 2025 - CONTABILIDADE    ANTONIO.SOUSA
		    	eEmail := "antonio.sousa@ravaembalagens.com.br"
		        cGestor:= "Antonio Sousa"
		    Case Alltrim(cCentro) $ '2040/7080' //C/CUSTO 2040 - COMPRAS 			RODRIGO
		    	eEmail := "jorge@ravaembalagens.com.br" 
			    cGestor:= "Jorge Rodrigues"
			Case Alltrim(cCentro) = '2050' //C/CUSTO 2050 - SERVICOS GERAIS	CLAUDIA 
				eEmail := "claudia.coutinho@ravaembalagens.com.br"
			    cGestor:= "Claudia Coutinho"
			Case Alltrim(cCentro) =	'2080' //C/CUSTO 2080 - INFORMATICA 		EURIVAN 
				eEmail := "eurivan@ravaembalagens.com.br"
			    cGestor:= "Eurivan Marques"
			Case Alltrim(cCentro) =	'2085' //C/CUSTO 2085 - SAC 				DANIELA 
				eEmail := "daniela@ravaembalagens.com.br"
			    cGestor:= "Daniela Barros"
			Case Alltrim(cCentro) = '2090' //C/CUSTO 2090 - RECURSOS HUMANOS	EDILICIA 
				eEmail := "ellyciane@ravaembalagens.com.br"
			    cGestor:= "Ellyciane Maria"
			Case Alltrim(cCentro) $	'3010/3020' //C/CUSTO 3010 - VENDAS 			FLAVIA LEITE 
				eEmail := '' //"flavia@ravaembalagens.com.br" // AF
			//Case Alltrim(cCentro) =	'3020' //C/CUSTO 3020 - LICITACAO		FLAVIA LEITE  
			    cGestor:= "Flavia Viana"
			Case Alltrim(cCentro) =	'3050' //C/CUSTO 3050 - EXPEDICAO 		JACIARA 
				eEmail := "jaciara@ravaembalagens.com.br"
			    cGestor:= "Jaciara Linhares"
			Case Alltrim(cCentro) $ '7010/7020/7040' //C/CUSTO 7010 - EXTRUSAO - PEAD	ROBINSON
				eEmail := "robinson@ravaembalagens.com.br" 
			//Case Alltrim(cCentro) = '7020' //C/CUSTO 7020 - CORTE / SOLDA - SACOS	ROBINSON 
			    cGestor:= "Robinson Tavares"
			Case Alltrim(cCentro) $ '7035/7050/7060/7085' //C/CUSTO 7035 - CONTROLE DE QUALIDADE	JORGE
				eEmail := "jorge@ravaembalagens.com.br" 
			    cGestor:= "Jorge Rodrigues"
			//Case Alltrim(cCentro) = '7040' //C/CUSTO 7040 - EMBALAGEM / PESAGEM		ROBINSON 
			//Case Alltrim(cCentro) = '7050' //C/CUSTO 7050 - MANUTENCAO MECANICA		JORGE 
			//Case Alltrim(cCentro) = '7060' //C/CUSTO 7060 - MANUTENCAO ELETRICA		JORGE 
			//Case Alltrim(cCentro) =	'7080' //C/CUSTO 7080 - ALMOXARIFADO 			RODRIGO
			//Case Alltrim(cCentro) =	'7085' //C/CUSTO 7085 - ENGENHARIA INDUSTRIAL	JORGE  
		Endcase
		
		If nLinhas > 35
			//fCabeca( nPag, dEmissao, cTipo, cPeriodo, cTitulo)
			cHtm += fCabeca(nPag, dDatabase, '1', '1o.Periodo' , titulo, 1, cGestor )
			nLinhas := 5
			nPag++
		Endif
		
		
		
		
		////div para quebrar página automaticamente
		cHtm += '<style type="text/css">'+LF
		cHtm += '.quebra_pagina {'+LF
		cHtm += 'page-break-after:always;'+LF
		cHtm += 'font-size:11px;'+LF
		//cHtm += 'font-style:italic;'+LF
		cHtm += 'font-family:Arial;'+LF
		cHtm += '	color:#F00;'+LF
		cHtm += '	padding:5px 0;'+LF
		cHtm += '	text-align:center;'+LF
		cHtm += '}'+LF
		cHtm += 'p {text-align:right;'+LF
		cHtm += '}'+LF
		cHtm += '</style>'+LF 
		//cWeb += '<div class="quebra_pagina"></div>'+LF			   //comando da quebra de página
		While fr <= len(aFunc) .and. Alltrim(aFunc[fr,8]) = Alltrim(cCentro)		
			If nLinhas > 35
				cHtm += '</table>' + LF
				cHtm += '<div class="quebra_pagina"></div>'+LF			   //comando da quebra de página
				///cabeçalho html				
				cHtm += fCabeca(nPag, dDatabase, '2', '' , titulo, 1, "" )
				nLinhas := 5
				nPag++
			Endif 
			   
			cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
			cHtm += '		<td width="200" align="left">'+ aFunc[fr,6] + ' - ' + aFunc[fr,7] + '</td>' + LF   //FILIAL + NOME FILIAL
			CTT->(DBSSETORDER(1))
			CTT->(Dbseek(xFilial("CTT") + aFunc[fr,8] ))
			cHtm += '		<td width="200" align="left">'+ aFunc[fr,8] + '-' + Alltrim(CTT->CTT_DESC01) + '</td>' + LF   //CENTRO CUSTO
			cHtm += '		<td width="200" align="left">'+ aFunc[fr,1] + ' - ' + aFunc[fr,2] + '</td>' + LF   //MATRICULA + NOME FUNC
			cHtm += '		<td width="40" align="left">'+ aFunc[fr,3] + '</td>' + LF  //FUNÇÃO
			cHtm += '		<td width="40" align="left">'+ Dtoc(aFunc[fr,4]) + '</td>' + LF    //DT. VENCTO 1o. EXPERIÊNCIA
			//cHtm += '		<td width="40" align="left">'+ Dtoc(aFunc[fr,5]) + '</td>' + LF
		
			cHtm += '		</tr>' + LF
			nLinhas++  
					
			///GRAVA O HTML
			Fwrite( nHandle, cHtm, Len(cHtm) )
			cHtm := ""
		    fr++
		Enddo
		
		nLinhas := 80
		cHtm += '</table>' + LF
		///GRAVA O HTML
		Fwrite( nHandle, cHtm, Len(cHtm) )
		FClose( nHandle )
		
		cHtm := ""
		
		//cCopia := "flavia.rocha@ravaembalagens.com.br" 	      //retirar
		
		subj	:= titulo + " - " + cEmpresa
		cCorpo := "Para: " + LF
		cCorpo += cGestor + ' - Email: ' + eEmail + LF
		cCorpo += "RH - Email: " + cEnviPara +  LF + LF
		cCorpo += titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."+ LF
		
		eEmail += ";" + cEnviPara  //voltar
		//eEmail :=  ""  //retirar		
		cAnexo  := cDirHTM + cArqHTM
		cAssun  := subj
		U_SendFatr11(eEmail, cCopia, cAssun, cCorpo, cAnexo )    
	
	Enddo

Endif	 //Len aFunc		
//////////////////////////////////////////////////////////////////////////////////////////////////////
If Len(aFunc2) > 0
    fr := 1
    nLinhas := 80
    nPag    := 1
    cHtm    := ""
    eEmail  := ""
    cGestor := ""								
	While fr <= Len(aFunc2)
		cCentro := Alltrim(aFunc2[fr,8])  
		cGestor := ""
		////CRIA O HTM 
		cDirHTM  := "\Temp\"    
		cArqHTM  := "EXP_VENC2_" + Alltrim(cCentro) + ".htm"  //+ Alltrim(cEmpresa) + ".HTM"   
						
		nHandle := fCreate( cDirHTM + cArqHTM, 0 )
						    
		If nHandle = -1
		     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		Do Case
		
			Case Alltrim(cCentro) = '1010' //C/CUSTO 1010 - DIRETORIA   		HUMBERTO 
				eEmail := "rh@ravaembalagens.com.br"
			    cGestor:= "RH"
			Case Alltrim(cCentro) = '2010' //C/CUSTO 2010 - ADMINISTRATIVO  	REGINEIDE
				eEmail := "regineide.neves@ravaembalagens.com.br" 
			    cGestor:= "Regineide Neves"
			Case Alltrim(cCentro) =	'2020' //C/CUSTO 2020 - FINANCEIRO      	REGINA
				eEmail := "regina@ravaembalagens.com.br"
		        cGestor:= "Regina Assis"
		    Case Alltrim(cCentro) = '2025' //C/CUSTO 2025 - CONTABILIDADE    ANTONIO.SOUSA
		    	eEmail := "antonio.sousa@ravaembalagens.com.br"
		        cGestor:= "Antonio Sousa"
		    Case Alltrim(cCentro) $ '2040/7080' //C/CUSTO 2040 - COMPRAS 			RODRIGO
		    	eEmail := "jorge@ravaembalagens.com.br" 
			    cGestor:= "Jorge Rodrigues"
			Case Alltrim(cCentro) = '2050' //C/CUSTO 2050 - SERVICOS GERAIS	CLAUDIA 
				eEmail := "claudia.coutinho@ravaembalagens.com.br"
			    cGestor:= "Claudia Coutinho"
			Case Alltrim(cCentro) =	'2080' //C/CUSTO 2080 - INFORMATICA 		EURIVAN 
				eEmail := "eurivan@ravaembalagens.com.br"
			    cGestor:= "Eurivan Marques"
			Case Alltrim(cCentro) =	'2085' //C/CUSTO 2085 - SAC 				DANIELA 
				eEmail := "daniela@ravaembalagens.com.br"
			    cGestor:= "Daniela Barros"
			Case Alltrim(cCentro) = '2090' //C/CUSTO 2090 - RECURSOS HUMANOS	EDILICIA 
				eEmail := "ellyciane@ravaembalagens.com.br"
			    cGestor:= "Ellyciane Maria"
			Case Alltrim(cCentro) $	'3010/3020' //C/CUSTO 3010 - VENDAS 			FLAVIA LEITE 
				eEmail := "flavia@ravaembalagens.com.br"
			//Case Alltrim(cCentro) =	'3020' //C/CUSTO 3020 - LICITACAO		FLAVIA LEITE  
			    cGestor:= "Flavia Viana"
			Case Alltrim(cCentro) =	'3050' //C/CUSTO 3050 - EXPEDICAO 		JACIARA 
				eEmail := "jaciara@ravaembalagens.com.br"
			    cGestor:= "Jaciara Linhares"
			Case Alltrim(cCentro) $ '7010/7020/7040' //C/CUSTO 7010 - EXTRUSAO - PEAD	ROBINSON
				eEmail := "robinson@ravaembalagens.com.br" 
			//Case Alltrim(cCentro) = '7020' //C/CUSTO 7020 - CORTE / SOLDA - SACOS	ROBINSON 
			    cGestor:= "Robinson Tavares"
			Case Alltrim(cCentro) $ '7035/7050/7060/7085' //C/CUSTO 7035 - CONTROLE DE QUALIDADE	JORGE
				eEmail := "jorge@ravaembalagens.com.br" 
			    cGestor:= "Jorge Rodrigues"
			//Case Alltrim(cCentro) = '7040' //C/CUSTO 7040 - EMBALAGEM / PESAGEM		ROBINSON 
			//Case Alltrim(cCentro) = '7050' //C/CUSTO 7050 - MANUTENCAO MECANICA		JORGE 
			//Case Alltrim(cCentro) = '7060' //C/CUSTO 7060 - MANUTENCAO ELETRICA		JORGE 
			//Case Alltrim(cCentro) =	'7080' //C/CUSTO 7080 - ALMOXARIFADO 			RODRIGO
			//Case Alltrim(cCentro) =	'7085' //C/CUSTO 7085 - ENGENHARIA INDUSTRIAL	JORGE  
		Endcase
		
		If nLinhas > 35
			//fCabeca( nPag, dEmissao, cTipo, cPeriodo, cTitulo)
			cHtm += fCabeca(nPag, dDatabase, '1', '2o.Periodo' , titulo, 2, cGestor )
			nLinhas := 5
			nPag++
		Endif
		
		
		////div para quebrar página automaticamente
		cHtm += '<style type="text/css">'+LF
		cHtm += '.quebra_pagina {'+LF
		cHtm += 'page-break-after:always;'+LF
		cHtm += 'font-size:11px;'+LF
		//cHtm += 'font-style:italic;'+LF
		cHtm += 'font-family:Arial;'+LF
		cHtm += '	color:#F00;'+LF
		cHtm += '	padding:5px 0;'+LF
		cHtm += '	text-align:center;'+LF
		cHtm += '}'+LF
		cHtm += 'p {text-align:right;'+LF
		cHtm += '}'+LF
		cHtm += '</style>'+LF 
		//cWeb += '<div class="quebra_pagina"></div>'+LF			   //comando da quebra de página
		While fr <= Len(aFunc2) .and. Alltrim(aFunc2[fr,8]) = Alltrim(cCentro)		
			If nLinhas > 35
				cHtm += '</table>' + LF
				cHtm += '<div class="quebra_pagina"></div>'+LF			   //comando da quebra de página
				///cabeçalho html				
				cHtm += fCabeca(nPag, dDatabase, '2', '' , titulo, 2 )
				nLinhas := 5
				nPag++
			Endif 
			   
			cHtm += '		<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
			cHtm += '		<td width="200" align="left">'+ aFunc2[fr,6] + ' - ' + aFunc2[fr,7] + '</td>' + LF   //FILIAL + NOME FILIAL
			CTT->(DBSSETORDER(1))
			CTT->(Dbseek(xFilial("CTT") + aFunc2[fr,8] ))
			cHtm += '		<td width="200" align="left">'+ aFunc2[fr,8] + '-' + Alltrim(CTT->CTT_DESC01) + '</td>' + LF   //CENTRO CUSTO
			cHtm += '		<td width="200" align="left">'+ aFunc2[fr,1] + ' - ' + aFunc2[fr,2] + '</td>' + LF   //MATRICULA + NOME FUNC
			cHtm += '		<td width="40" align="left">'+ aFunc2[fr,3] + '</td>' + LF  //FUNÇÃO
			//cHtm += '		<td width="40" align="left">'+ Dtoc(aFunc2[fr,4]) + '</td>' + LF    //DT. VENCTO 1o. EXPERIÊNCIA
			cHtm += '		<td width="40" align="left">'+ Dtoc(aFunc2[fr,5]) + '</td>' + LF    //DT. VENCTO 2o. EXPERIÊNCIA
		
			cHtm += '		</tr>' + LF
			nLinhas++  
					
			///GRAVA O HTML
			Fwrite( nHandle, cHtm, Len(cHtm) )
			cHtm := ""
		    fr++
		Enddo
		cHtm += '</table>' + LF
		nLinhas := 80
		///GRAVA O HTML
		Fwrite( nHandle, cHtm, Len(cHtm) )
		FClose( nHandle )
		cHtm := ""
				
		//cCopia := "flavia.rocha@ravaembalagens.com.br" 	      //retirar
		
		subj	:= titulo + " - " + cEmpresa 
		cCorpo := "Para: " + LF
		cCorpo += cGestor + ' - Email: ' + eEmail + LF
		cCorpo += "RH - Email: " + cEnviPara +  LF + LF
		cCorpo  := titulo  + "   - Este arquivo é melhor visualizado no navegador Mozilla Firefox."+ LF
		
		eEmail += ";" + cEnviPara  //voltar
		//eEmail :=  ""  //retirar
		cAnexo  := cDirHTM + cArqHTM
		cAssun  := subj
		U_SendFatr11(eEmail, cCopia, cAssun, cCorpo, cAnexo )    
	
	Enddo
	      	 

Endif
//fim do envia para cada gestor


If lDentrosiga
	
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
Endif	
   
Return





***********************************
Static Function fCabeca( nPag, dEmissao, cTipo, cPeriodo, cTitulo, nPeriodo, cGestor)
***********************************

Local cHtm := ""
Local LF 		:= CHR(13) + CHR(10)
Local cEmpresa:= ""

If SM0->M0_CODFIL = '01'
	cEmpresa := "RAVA Embalagens Sacos"
Elseif SM0->M0_CODFIL = '03' 
	cEmpresa := "RAVA Embalagens Caixas" 
Else	
	cEmpresa := SM0->M0_FILIAL
Endif


If cTipo = '1' //inicia nova página
	///Cabeçalho PÁGINA
	cHtm += '<html>'+LF
	cHtm += '<head>'+ LF
	cHtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
	cHtm += '<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="100%">'+ LF
	cHtm += '<tr>    <td>'+ LF
	cHtm += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
	cHtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
	cHtm += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
	cHtm += '<tr>        <td>SIGA /GPER005/v.P10</td>'+ LF
	cHtm += '<td align="center">' + cTitulo + '</td>'+ LF
	cHtm += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td></tr>'+ LF
	
	//cHtm += '<tr>        <td></td>'+ LF
	//cHtm += '<td align="center">' + cFiltro + '</td></tr>'+ LF
		
	cHtm += '<tr>          '+ LF
	cHtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
	cHtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
	cHtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
	cHtm += '</table></head>'+ LF            

	//cHtm += '<html>' + LF
	//cHtm += '<head>' + LF
	//cHtm += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">' + LF
	//cHtm += '<title>Func.xTurno</title>' + LF
	//cHtm += '<style>' + LF
	//cHtm += '</style>' + LF
	//cHtm += '</head>' + LF
	cHtm += '<body>' + LF	
	cHtm += '	<br>' + LF
	cHtm += '	<strong>' + LF
	cHtm += '		<center>' + LF
	cHtm += '		<span style="font-size:15pt;font-family:Verdana;color:black; text-decoration:underline">' + LF
	cHtm += '			PERIODO EXPERIENCIA A VENCER - ' + Alltrim(cEmpresa) + LF
	cHtm += '		</span>' + LF
	cHtm += '		</center>' + LF
	cHtm += '	</strong>' + LF
	cHtm += '<span style="font-size:8pt;font-family:Verdana;color:black; text-decoration:underline">' + LF
	cHtm += ' 	</span>	<br>' + LF
	cHtm += '	</p>' + LF
	cHtm += '	<div>' + LF

	cHtm += '	<table width="800" align=center>' + LF
	cHtm += '				<tr style="font-size:9.0pt;font-family:Verdana;color:black">' + LF
	cHtm += '					<td bgcolor="#E2E9E6"  width="660" align="left" bgcolor="#A2D7AA" colspan="5">' + LF
	cHtm += '					Prezado, ' + cGestor + ', RH:<br><br>' + LF
	cHtm += '					&nbsp;&nbsp;Abaixo segue(m) o(s) funcionario(s) em que o ' + cPeriodo + ' de Experiencia ira Vencer daqui a 5 Dias:<BR>' + LF
	cHtm += '					</td>' + LF
	cHtm += '			</tr>' + LF

	If nPeriodo = 1
		cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
		cHtm += '	<td width="120" align="center" bgcolor="#A2D7AA"><b>Filial</b></td>' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Centro Custo</b></td>' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Matricula / Funcionario</b></td>' + LF
		cHtm += '	<td width="100" align="center" bgcolor="#A2D7AA"><b>Funcao</b></td>' + LF
		cHtm += '	<td width="40" align="center" bgcolor="#A2D7AA"><b>1o. Vencto Experiencia</b></td>' + LF
	Elseif nPeriodo  = 2
		cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
		cHtm += '	<td width="120" align="center" bgcolor="#A2D7AA"><b>Filial</b></td>' + LF      
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Centro Custo</b></td>' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Matricula / Funcionario</b></td>' + LF
		cHtm += '	<td width="100" align="center" bgcolor="#A2D7AA"><b>Funcao</b></td>' + LF
		cHtm += '	<td width="40" align="center" bgcolor="#A2D7AA"><b>2o. Vencto Experiencia</b></td>' + LF
	Endif
	cHtm += '	</tr>' + LF
Endif

If cTipo = '2'   //continua a impressão sendo do mesmo período 
	
	///Cabeçalho PÁGINA
	cHtm += '<html>'+LF
	cHtm += '<head>'+ LF
	cHtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+ LF
	cHtm += '<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="100%">'+ LF
	cHtm += '<tr>    <td>'+ LF
	cHtm += '<table border="0" cellspacing="0" cellpadding="0" width="90%" bgcolor="#FFFFFF" style="font-size:11px;font-family:Arial">'+ LF
	cHtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>'+ALLTRIM(cEmpresa)+'</td>  <td></td>'+ LF
	cHtm += '<td align="right">Folha..:'+ Str(nPag,4) + '</td></tr>      '+ LF
	cHtm += '<tr>        <td>SIGA /GPER005/v.P10</td>'+ LF
	cHtm += '<td align="center">' + cTitulo + '</td>'+ LF
	cHtm += '<td align="right">DT.Ref.: '+ Dtoc(dDatabase) + '</td></tr>'+ LF
		
	cHtm += '<tr>          '+ LF
	cHtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+ LF
	cHtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr>'+ LF
	cHtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>' + LF
	cHtm += '</table></head>'+ LF
	
	cHtm += '	<table width="800" align=center>' + LF            
	If nPeriodo = 1
		cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Filial</b></td>' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Centro Custo</b></td>' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Matricula / Funcionario</b></td>' + LF
		cHtm += '	<td width="100" align="center" bgcolor="#A2D7AA"><b>Funcao</b></td>' + LF
		cHtm += '	<td width="40" align="center" bgcolor="#A2D7AA"><b>1o. Vencto Experiencia</b></td>' + LF
	Elseif nPeriodo  = 2
		cHtm += '	<tr style="font-size:10.0pt;font-family:Verdana;color:black" bgcolor="#D6EBD8">' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Filial</b></td>' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Centro Custo</b></td>' + LF
		cHtm += '	<td width="200" align="center" bgcolor="#A2D7AA"><b>Matricula / Funcionario</b></td>' + LF
		cHtm += '	<td width="100" align="center" bgcolor="#A2D7AA"><b>Funcao</b></td>' + LF
		cHtm += '	<td width="40" align="center" bgcolor="#A2D7AA"><b>2o. Vencto Experiencia</b></td>' + LF
	Endif	
	cHtm += '	</tr>' + LF

Endif

Return(cHtm)

*****************************					
Static Function fRodape(cEmpresa) 
*****************************

Local cTexto := ""


cTexto := '<br> ' + LF
//cTexto += '<br> ' + LF
//cTexto += '<br> ' + LF
//cTexto += '<br> ' + LF
cTexto += '<table width="100%" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="0" width="100%"> ' + LF
cTexto += '<tbody><tr>    <td> ' + LF
cTexto += '<table style="font-size: 11px; font-family: Arial;" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="0" width="90%"> ' + LF
cTexto += '<tbody><tr>    <td colspan="3"><hr color="#000000" noshade="noshade" size="2"></td>        </tr> ' + LF
cTexto += '<tr>          <td>' + cEmpresa + '</td>  <td></td> ' + LF
cTexto += '<td align="right">Fim da impressao ' + Time() + '</td> ' + LF
cTexto += '</tr> ' + LF
cTexto += '<tr>    <td colspan="3"><hr color="#000000" noshade="noshade" size="2"></td>        </tr><tr> ' + LF
cTexto += '</tr></tbody></table> ' + LF


Return(cTexto)