#INCLUDE "FIVEWIN.CH"
//#INCLUDE "GPEA020.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#define Confirma 1
#define Redigita 2
#define Abandona 3


***************

User Function EQUIPA(nOpcAuto)

***************

LOCAL cFiltraSRA			//Variavel para filtro
LOCAL aIndexSRA	:= {}		//Variavel Para Filtro

Private bFiltraBrw := {|| Nil}		//Variavel para Filtro

PRIVATE aRotina :=  MenuDef() // ajuste para versao 9.12 - chamada da funcao MenuDef() que contem aRotina

cCadastro := OemToAnsi("Cadastro Equipamento")//cCadastro := OemToAnsi(STR0009)  /Cadastro de Dependentes"

If nOpcAuto <> Nil
	Do Case
		Case nOpcAuto == 3
			INCLUI := .T.
			ALTERA := .F.
		Case nOpcAuto == 4
			INCLUI := .F.
			ALTERA := .T.
		OtherWise	
			INCLUI := .F.
			ALTERA := .F.
	EndCase		

	dbSelectArea('SRA')
	nPos := Ascan(aRotina,{|x| x[4]== nOpcAuto})
	If ( nPos <> 0 )
		bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPos,2 ] + "(a,b,c,d,e) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nPos)
	EndIf
Else
	//--Altera o Set Epoch para 1910
	nEpoca := SET( 5,1910)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica se o Arquivo Esta Vazio                             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !ChkVazio("SRA")
		Return
	Endif
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Inicializa o filtro utilizando a funcao FilBrowse                      �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	cFiltraRh := CHKRH("GPEA020","SRA","1")
	bFiltraBrw 	:= {|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH) }
	Eval(bFiltraBrw)
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Endereca a funcao de BROWSE                                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SRA")
	mBrowse( 6, 1,22,75,"SRA",,,,,,fCriaCor() )
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Deleta o filtro utilizando a funcao FilBrowse                     	   �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	EndFilBrw("SRA",aIndexSra)
	//--Retornar Set Epoch Padrao
	SET(5,nEpoca)
EndIf

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿲p020Atu  � Autor � Mauro Sergio          � Data � 23.04.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Programa de (Vis.,Inc.,Alt. e Del. de  dependentes         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � gp020Atu(ExpC1,ExpN1,ExpN2)                                낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros� ExpC1 = Alias do arquivo                                   낢�
굇�          � ExpN1 = Numero do registro                                 낢�
굇�          � ExpN2 = Numero da opcao selecionada                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � GPEA020                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
*************

User Function EQUIATU(cAlias,nReg,nOpcx)

*************
                       // COLOCAR Z41
Local a020Field 	:= {"Z41_FILIAL","Z41_MATRIC"}
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local bSet15		:= { || NIL }
Local bSet24		:= { || NIL }
Local cMat      	:= SRA->RA_MAT
Local nSavRec   	:= RecNo()
Local nCnt			:= 0.00
Local oDlg
Local oFont
Local oGroup
                     //COLOCAR Z41
Local aNoFields 	:= {"Z41_MATRIC"}
Local bSeekWhile	:= {|| Z41->Z41_FILIAL + Z41->Z41_MATRIC }
Local nSRBOrd		:= RetOrdem( "Z41", "Z41_FILIAL+Z41_MATRIC" )
Local nPosRec		:= 0

Private aAC      := {"Abandona","Confirma"}
Private aColsRec := {}   //--Array que contem o Recno() dos registros da aCols
Private nUsado:=0
        //COLOCAR Z41
cAlias	:= "Z41"
cCod 	:= SRA->RA_MAT

/*
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Monta as Dimensoes dos Objetos         					   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸*/
aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

While .T.

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica se existe algum dado no arquivo                     �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea( cAlias )
	dbSeek( cFilial + cMat )
  	nCnt := 0
   	While !EOF() .And. Z41_FILIAL + Z41_MATRIC == cFilial + cMat
		nCnt++
		dbSkip()
    EndDo

    If nCnt > 0  .And. nOpcx = 3    //--Quando Inclusao e existir Registro
		//Help(" ",1,"A020CDEP")
		ALERT("Ja existe Equipamento para este Funcionario!!!" )
		Exit
    Elseif nCnt = 0 .And. nOpcx # 3  //--Quando Nao for Inclusao e nao existir Registro
      	//Help(" ",1,"A020SDEP")
		ALERT("Nao existe Equipamento para este Funcionario!!!" )
		Exit
	Endif
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
    //� Gerar o array aCols com os dependentes E Monta o cabecalho   �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	FillGetDados(nOpcx					,; //1-nOpcx - n�mero correspondente � opera豫o a ser executada, exemplo: 3 - inclus�o, 4 altera豫o e etc;
				 cAlias					,; //2-cAlias - area a ser utilizada;
				 nSRBOrd				,; //3-nOrder - ordem correspondente a chave de indice para preencher o  acols;
				 xFilial(cAlias)+cCod	,; //4-cSeekKey - chave utilizada no posicionamento da area para preencher o acols;
				 bSeekWhile				,; //5-bSeekWhile - bloco contendo a express�o a ser comparada com cSeekKey na condi豫o  do While.
				 NIL					,; //6-uSeekFor - pode ser utilizados de duas maneiras:1- bloco-de-c�digo, condi豫o a ser utilizado para executar o Loop no While;2� - array bi-dimensional contendo N.. condi寤es, em que o 1� elemento � o bloco condicional, o 2� � bloco a ser executado se verdadeiro e o 3� � bloco a ser executado se falso, exemplo {{bCondicao1, bTrue1, bFalse1}, {bCondicao2, bTrue2, bFalse2}.. bCondicaoN, bTrueN, bFalseN};
				 aNoFields		   	    ,; //7-aNoFields - array contendo os campos que n�o estar�o no aHeader;
				 NIL					,; //8-aYesFields - array contendo somente os campos que estar�o no aHeader;
				 NIL					,; //9-lOnlyYes - se verdadeiro, exibe apenas os campos de usu�rio;
				 NIL					,; //10-cQuery - query a ser executada para preencher o acols(Obs. Nao pode haver MEMO);
				 NIL					,; //11-bMontCols - bloco contendo fun豫o especifica para preencher o aCols; Exmplo:{|| MontaAcols(cAlias)}
				 Iif(nOpcx==3,.t.,.f.)  ,; //12-Caso inclusao inclua um registro em branco no acols	
				 NIL			      	,; //13-aHeaderAux
				 NIL			      	,; //14-aColsAux
				 NIL			     	) //15-bAfterCols
	                   
	nPosRec:=GdfieldPos("Z41_REC_WT")
	// somente quando for inclusao, sequencia do dependente.
	If nOpcx == 3 
  	    aCols[1][1] := '01'
	EndIf

	nOpca := 0
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Equipamentos") FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL   

	@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] - 3 ),( ( aObjSize[1,4]/100*10 - 2 ) ) LABEL OemToAnsi("Matricula:") OF oDlg PIXEL				// "Matricula:"
	oGroup:oFont:= oFont
	@ aObjSize[1,1] , ( ( aObjSize[1,4]/100*10 ) ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),( aObjSize[1,4]/100*80 - 2 ) LABEL OemToAnsi("Nome") OF oDlg PIXEL	// "Nome:"
	oGroup:oFont:= oFont
	@ aObjSize[1,1] , ( aObjSize[1,4]/100*80 ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),aObjSize[1,4] LABEL OemToAnsi("Admissao") OF oDlg PIXEL						// "Admiss꼘:"
	oGroup:oFont:= oFont
	
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( aObjSize[1,2] + 5 )				SAY StrZero(Val(SRA->RA_MAT),TamSx3("RA_MAT    ")[1]) 	SIZE 050,10 OF oDlg PIXEL FONT oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*10 ) + 5 )	SAY OemToAnsi(SRA->RA_NOME) 							SIZE 146,10 OF oDlg PIXEL FONT oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*80 ) + 5 )	SAY Dtoc(SRA->RA_ADMISSA)								SIZE 050,10 OF oDlg PIXEL FONT oFont
                                                                                                                            //SEQUENCIA
	oGet	:= MSGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],nOpcx,"U_EQUILinOk",'AllwaysTrue()',"+Z41_SEQUEN",If(nOpcx=2.Or.nOpcx=5,Nil,.T.),,1)
	
   	bSet15	:= {|| nOpca:=If(nOpcx=5,2,1),If(oGet:TudoOk(),oDlg:End(),nOpca:=0)}
   	bSet24	:= {||oDlg:End()}
   
   	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 ) 

    //--Se nao for Exclusao
    If nOpcx # 5
        IF nOpcA == Redigita
            LOOP
        ELSEIF nOpcA == Confirma .And. nOpcx # 2
            Begin Transaction
                //--Gravacao
                gp020Grava(cAlias,nPosRec)
                //--Processa Gatilhos
                EvalTrigger()
            End Transaction
        Endif
    //--Se for Exclusao
    Elseif nOpca = 2 .And. nOpcx = 5
        Begin Transaction
            gp020Dele()
        End Transaction
    Endif

	Exit
EndDo
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Restaura a integridade da janela                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cAlias := "SRA"
dbSelectArea(cAlias)
Go nSavRec

If nOpcx == 3    //--Quando Inclusao
   MBrChgLoop(.F.)
EndIf
   
Return
/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿲p020Dele � Autor � Mauro                 � Data � 24.04.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Deleta os Registro de  dependentes                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � gp020Dele                                                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/
***************

Static Function gp020Dele()

****************
                //COLOCAR Z41 CADASTRO DE EQUIPAMENTO 
Local cAlias 	:= "Z41"  
Local nX		:= 1

nCnt := 0
For nX := 1 to Len(aCols)
    dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
    RecLock(cAlias,.F.,.T.)
    dbDelete( )
    MsUnlock()
    nCnt++
Next nX
WRITESX2(cAlias,nCnt)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Atualiza o Cadastro de Funcionario "SRA"                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

dbSelectArea( cAlias )

Return Nil



/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇�                   ROTINAS DE CRITICA DE CAMPOS                        낢�
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿲p020Grava� Autor � J. Ricardo            � Data � 06.08.94 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Grava no arquivo de Dependentes                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � gp020Grava                                                 낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�/*/
***************

Static Function gp020Grava(cAlias,nPosRec)

***************
Local ny		:=	0
Local nMaxArray	:=	Len(aHeader)
Local n			:= 0
Local lTravou	:= .f.

dbSelectArea(cAlias)


For n:=1 TO Len(aCols)

	Begin Transaction

    If aCols[n][nPosRec] > 0
        MSGoto(aCols[n][nPosRec])
        RecLock(cAlias,.F.,.T.)
		lTravou:=.T.
	Else
	    If !(aCols[n][Len(aCols[n])])
			RecLock(cAlias,.T.)
			lTravou:=.T.
		EndIf
    Endif
	If lTravou	     
        //--Verifica se esta deletado
        If aCols[n][Len(aCols[n])] 
            dbDelete()
        Else        //Z41
	        Replace Z41->Z41_FILIAL WITH SRA->RA_FILIAL
	        Replace Z41->Z41_MATRIC    WITH SRA->RA_MAT
        Endif
	    For ny := 1 To nMaxArray
	        cCampo    := Trim(aHeader[ny][2])
	        xConteudo := aCols[n,ny]
	        Replace &cCampo With xConteudo
	    Next ny
	Endif
	MsUnlock()
    End Transaction
Next n

Return


*************

USER Function EQUILinOk()

*************

Local lOk := .T.
Local cCpo:=""
Local nPosNome	 := aScan(aHeader,{|x| Alltrim(x[2]) == "Z41_NOME"})
Local nPosDtent	 := aScan(aHeader,{|x| Alltrim(x[2]) == "Z41_DTENTR"})
Local nPosMarca	 := aScan(aHeader,{|x| Alltrim(x[2]) == "Z41_MARCA"})
Local nPosModelo := aScan(aHeader,{|x| Alltrim(x[2]) == "Z41_MODELO"})

If EMPTY (aCols[n][nPosNome]) 
   lOk := .F.
   cCpo := 'Nome'
ElseIf EMPTY (aCols[n][nPosDtent])    
   lOk := .F.
   cCpo := 'Data Entrega'
ElseIf EMPTY (aCols[n][nPosMarca])    
   lOk := .F.
   cCpo := 'Marca'
ElseIf EMPTY (aCols[n][nPosModelo])    
   lOk := .F.
   cCpo := 'Modelo'
Endif
				
if !lOk
   Aviso( "Obrigatorio", "O campo: "+cCpo+" n�o foi preenchido.", {"Ok"})   
   Return .F.
endif
   
Return .T. 

  
Static Function MenuDef()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa뇙o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local aRotina3  := {{ "Termo de Entrega"    ,"U_TERMOENT"	,0,6,0,NIL},;
					{ "Termo de Devolucao"  ,"U_TERMODEVO"     ,0,6,0,NIL},;
					{ "Lista de Equipamento","U_LISTAEQUI"	,0,6,0,NIL}}			



 Local aRotina :=  { { "Pesquisar" , "PesqBrw"  , 0 , 1,,.F.},;    
                     { "Visualizar", "U_EQUIATU", 0 , 2},;       	 
                     { "Incluir"   , "U_EQUIATU", 0 , 3,,,.T.},;     
                     { "Alterar"   , "U_EQUIATU", 0 , 4},;      	   
                     { "Excluir"   , "U_EQUIATU", 0 , 5},;       	   
                     {"Imprimir"   , aRotina3   , 0,  6},;
                     { "Legenda"   , "GpLegend" , 0 , 5 , ,.F.}}	 
                     
 Return aRotina

