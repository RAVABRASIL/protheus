#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PONWORK.CH"


/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa  ³PonWork - Leitura do TXT ponto via schedule do configurador
 Autoria   : Flávia Rocha
 Data      : 22/08/2011 
 ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
*/                                                                        

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ As Instrucoes Abaixo deverao ser Incluidas no INI do Server			³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
[ONSTART]
JOBS=LEITURA_CLASSIFICACAO	//Define o Nome do Job

[LEITURA_CLASSIFICACAO]		//Configuracoes do Job
Main=u_StartJobPon			//ou Main=wfStart() se tiver apenas uma empresa
Environment=Environment		//Nome do Environment que devera ser utilizado
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ A chamada abaixo devera ser Incluida no Agendamento do WorkFlow		³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_PonScheduler(		"01"	,;	//01 -> Codigo da Empresa no SIGAMAT
				 	"01"	,;	//02 -> Codigo da Filial no SIGAMAT
				 	.F.		,;	//03 -> Utilizar os Parametros do SX1 para o Processo de Leitura / Apontamento
				 	.T.		,;	//04 -> Limitar a Data Final do Apontamento aa DataBase do Sistema
				 	.T.		,;	//05 -> Efetuar o Apontamento Por Filial
				 	.F.		,;	//06 -> Efetua Apontamento para Relogios nao Lidos
				 	.F.		,;	//07 -> Forcar o Reapontamento das Marcacoes   
				 	.F.		 ;  //08 -> Processa apenas a filial passada como parametro 
			   )
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³PonScheduler ³ Autor ³ Marinaldo de Jesus ³ Data ³21/11/2001³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Prepara o Ambiente da Empresa e Executa a  Leitura/Apontamen³
³          ³to														    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³u_PonScheduler( aUserDefParam )								³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³aUserDefParam -> Array contendo os Parametros do Usuario	³
³          ³       														³
³Conteudo  ³aUserDefParam[1]Codigo da Empresa no SIGAMAT				³
³          ³       														³
³          ³aUserDefParam[2]Codigo da Filial no SIGAMAT  				³
³          ³       														³
³          ³aUserDefParam[3]Se .T. caracterizara que o Programa   devera³
³          ³                utilizar os Parametros do Programa de  Leitu³
³          ³                ra/Apontamento, confome Definidos pelo 	Usua³
³          ³                rio. Caso Contrario Ira considerar os Parame³
³          ³                tros De/Ate de Forma Generica. 				³
³          ³       														³
³          ³aUserDefParam[4]Se a Data Fim dos Parametros deve ser Litida³
³          ³                da a Menor Data entra a DataBase e o Fim  do³
³          ³                Periodo de Apontamento						³
³          ³aUserDefParam[5]Se Deve Processar Por Filial                ³
³          ³aUserDefParam[6]Se Deve Efetuar Apontamento Quando nao Conse³
³          ³                gui Ler o Arquivo do Relogio                ³
³          ³aUserDefParam[7]Se Deve Forcar o Reapontamento 				³
³          ³aUserDefParam[8]Se Utiliza a Filial passada como a que deve-³
³          ³                ra ser processada como parametro.			³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³PonWork                                                    	³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observacao³Essa Funcao devera ser Cadastrada no Agendamento           	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

USER FUNCTION Ponto( cFili )
//cFili := '03'
U_PontoScheduler('02' , cFili,  .T. , .T. , .T. , .F. , .F. , .T. )                                                                                                                                      
//                 1      2     3     4     5     6     7     8
Return

********************************
User Function PontoScheduler(  cEmpr	,;	//01 -> Codigo da Empresa no SIGAMAT
				 	cFili	,;	//02 -> Codigo da Filial no SIGAMAT
				 	lUserDefParam		,;	//03 -> Utilizar os Parametros do SX1 para o Processo de Leitura / Apontamento
				 	lLimitaDataFim		,;	//04 -> Limitar a Data Final do Apontamento aa DataBase do Sistema
				 	lProcFilial		,;	//05 -> Efetuar o Apontamento Por Filial
				 	lApontaNaoLidas		,;	//06 -> Efetua Apontamento para Relogios nao Lidos
				 	lForceReaponta		,;	//07 -> Forcar o Reapontamento das Marcacoes   
				 	lSomentecFil		 ;  //08 -> Processa apenas a filial passada como parametro 
				 	)
********************************


Local aUserDefParam		:= {}
Local aFiliais			:= {}
Local cEmp				:= cEmpr //""
Local cFil				:= cFili //""
Local lWhorkFlow		:= .T.
/*
Local lUserDefParam		:= .T. //.F.
Local lLimitaDataFim	:= .T.
Local lProcFilial		:= .F.
Local lApontaNaoLidas	:= .F.
Local lForceReaponta	:= .F.  
Local lSomentecFil		:= .T.   // .F.
*/
Local nUserParam		:= 0.00
Local nLenParam			:= 0.00
Local nFilial			:= 0.00
Local cMsg   := ""
Local eEmail := ""
Local subj   := ""
Local nRecno := 0
Local LF	 := CHR(13) + CHR(10)

Private cPaisloc	:= "BRA"
	

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Enviando Mensagens para o Console do Server                 			³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
ConOut("")
ConOut( STR0001  + " Data/hora: " + Dtoc(msDate()) + ' / ' + Time() + " - Filial: " + cEmp + '/' + cFil)	//"Iniciando U_PonScheduler()..."
ConOut("")


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verifica se Empresa/Filial foram Passados								³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
//IF !Empty( cEmp ) .and. !Empty( cFil )

	//DbselectArea("RFE")
	//RFE->(DBZAP())
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Enviando Mensagens para o Console do Server                 			³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ConOut("")
	ConOut( STR0002 ) //"Preparando Ambiente da Empresa. Aguarde... "
	ConOut("")
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Prepara Ambiente da Empresa											³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil ) 
		
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Redefine nModulo de forma a Garantir que o Modulo seja o SIGAPON		³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	SetModulo( "SIGAPON" , "PON" )
		
    //Aadd( aFiliais , "01" )
    //Aadd( aFiliais , "03" )
    Aadd( aFiliais, cFil )        
    For nFilial := 1 To Len( aFiliais )
    			
		cMsg   := "Leitura Ponto iniciada - Filial: " + aFiliais[nFilial] + LF
		cMsg   += "Data: " + Dtoc(Date()) + LF
		cMsg   += "Hora: " + Time() + LF
		eEmail := "flavia.rocha@ravaembalagens.com.br"
		subj   := "Schedule Ponto - Inicio: "+ aFiliais[nFilial] 
		U_SendFatr11(eEmail, "", subj, cMsg, "" )
		////////////////////////////////////////////////////////////////////////
		///deleto o RFE para não ficar acumulando registros e demora na leitura
		////////////////////////////////////////////////////////////////////////		
		RFE->(DBGOTOP())
		If !RFE->(EOF())
			While !RFE->(EOF())
				Reclock("RFE", .F. )
				RFE->(Dbdelete())
				RFE->(MsUnlock())
				RFE->(DBSKIP())
			Enddo
		Endif
			
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Posiciona o SM0 na Filial a ser Processada                  			³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		//SM0->( dbGoto( aFiliais[ nFilial , 02 ] ) )
		SM0->(Dbseek(cEmp + aFiliais[ nFilial] ) )
		nRecno := SM0->(Recno())
                
        //msgbox("Empresa / Filial: " + cEmp + ' / ' + aFiliais[ nFilial] + ' - ' + str(nRecno))
				
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Enviando Mensagens para o Console do Server                 			³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		ConOut("")
		//"Inicio da Leitura/Apontamento em: "###" as "
		ConOut( STR0003  + Dtoc( MsDate() ) + STR0004 + Time() + " - INICIO LEITURA" ) //TESTE FLAVIA ROCHA " )
		ConOut("")							
		//"Empresa: "
		ConOut( STR0005 + cEmp + " - " + AllTrim( SM0->M0_NOMECOM ) )
		ConOut("")
		//"Filial:  "                                                     
		ConOut( STR0006 + aFiliais[nFilial] + " - " + AllTrim( SM0->M0_FILIAL ) )
		ConOut("")  

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Chamada a Funcao de Leitura e Apontamento das Marcacoes     			³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						
		//U_PontoScheduler('02' , cFili,  .T. , .T. , .T. , .F. , .F. , .T. )                                                                                                                                      
           //                 1      2     3     4     5     6     7     8
				
		Ponm010( lWhorkFlow					,;	//Define Que a Chamada Esta Sendo Efetuada Atraves do WorkFlow
			     lUserDefParam				,;	//Verifica Se Devera Considerar os Parametros Pre-Definidos Pelo Usuario = .T.
				 lLimitaDataFim				,;	//Verifica Se Devera Limitar a Data Fim a Menor Data entre a DataBase e o Periodo Final de Apontamento = .T.
				 aFiliais[nFilial]			,;	//Filial a ser processada
				 lProcFilial				,;	//Processo por Filial    = .T.
				 lApontaNaoLidas			,;	//Se Aponta as Marcacoes para as Filiais nao Lidas  = .F.
				 lForceReaponta				 ;	//Forcar o Reapontamento das Marcacoes = .F.
				)

				
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Enviando Mensagens para o Console do Server                 			³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		ConOut("")
		// "Final da Leitura/Apontamento em: "###" as "
		ConOut(STR0007 + Dtoc( MsDate() ) + STR0004 + Time() + " - fim Filial " )
		ConOut("")
	 	ConOut( " Fim APONTA FILIAL " + cEmp + ' / ' + aFiliais[nFilial] ) 
	 	
	 	cMsg   := "Leitura Ponto finalizada - Filial: " + aFiliais[nFilial] + LF
		cMsg   += "Data: " + Dtoc(Date()) + LF
		cMsg   += "Hora: " + Time() + LF
		eEmail := "flavia.rocha@ravaembalagens.com.br"
		subj   := "Schedule Ponto - Fim: "+ aFiliais[nFilial] 
		U_SendFatr11(eEmail, "", subj, cMsg, "" )	

     Next //nFilial
		
		
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Enviando Mensagens para o Console do Server                 			³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ConOut("")
	ConOut( STR0008 + " - FIM LEITURA" ) //TESTE FLAVIA ROCHA ")	//"Encerrando Ambiente da Empresa. Aguarde... "
	ConOut("")
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Finaliza o Ambiente da Empresa										³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	
	
	RESET ENVIRONMENT
/*
Else

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Enviando Mensagens para o Console do Server                 			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ConOut("")
	ConOut( STR0009 )	//"Nao foi possivel concluir o processo. Empresa ou Filial Invalidas."
	ConOut("")

EndIF

*/
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Enviando Mensagens para o Console do Server                 			³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
ConOut("")
ConOut("Finalizando U_PonTOScheduler()...")
ConOut("")
	
Return( NIL )

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³StartJobPon  ³ Autor ³ Marinaldo de Jesus ³ Data ³21/11/2001³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Start do Processo de WorkFlow                               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³u_StartJobPon												³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³															³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³PonWork                                                    	³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observacao³Essa Funcao devera ser Incluida no .INI do Server          	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
User Function JobPonStart()

Local aEmpFil := Array( 03 )

//aEmpFil[ 01 ] := "01"	//Codigo da Empresa confome SIGAMAT
aEmpFil[ 01 ] := "02"	//Codigo da Empresa confome SIGAMAT
aEmpFil[ 02 ] := "01"	//Codigo da Filial  confome SIGAMAT
aEmpFil[ 03 ] := "03"	//Codigo da Filial  confome SIGAMAT

Return( wfStart( aEmpFil ) )