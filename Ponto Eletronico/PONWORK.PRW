#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PONWORK.CH"


/*
�����������������������������������������������������������������������Ŀ
�Programa  �PonWork - Leitura do TXT ponto via schedule do configurador
 Autoria   : Fl�via Rocha
 Data      : 22/08/2011 
 �����������������������������������������������������������������������Ŀ
*/                                                                        

/*
�����������������������������������������������������������������������Ŀ
� As Instrucoes Abaixo deverao ser Incluidas no INI do Server			�
�������������������������������������������������������������������������
[ONSTART]
JOBS=LEITURA_CLASSIFICACAO	//Define o Nome do Job

[LEITURA_CLASSIFICACAO]		//Configuracoes do Job
Main=u_StartJobPon			//ou Main=wfStart() se tiver apenas uma empresa
Environment=Environment		//Nome do Environment que devera ser utilizado
�����������������������������������������������������������������������Ŀ
� A chamada abaixo devera ser Incluida no Agendamento do WorkFlow		�
�������������������������������������������������������������������������
u_PonScheduler(		"01"	,;	//01 -> Codigo da Empresa no SIGAMAT
				 	"01"	,;	//02 -> Codigo da Filial no SIGAMAT
				 	.F.		,;	//03 -> Utilizar os Parametros do SX1 para o Processo de Leitura / Apontamento
				 	.T.		,;	//04 -> Limitar a Data Final do Apontamento aa DataBase do Sistema
				 	.T.		,;	//05 -> Efetuar o Apontamento Por Filial
				 	.F.		,;	//06 -> Efetua Apontamento para Relogios nao Lidos
				 	.F.		,;	//07 -> Forcar o Reapontamento das Marcacoes   
				 	.F.		 ;  //08 -> Processa apenas a filial passada como parametro 
			   )
�����������������������������������������������������������������������Ŀ
�Fun��o    �PonScheduler � Autor � Marinaldo de Jesus � Data �21/11/2001�
�����������������������������������������������������������������������Ĵ
�Descri��o �Prepara o Ambiente da Empresa e Executa a  Leitura/Apontamen�
�          �to														    �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �u_PonScheduler( aUserDefParam )								�
�����������������������������������������������������������������������Ĵ
�Parametros�aUserDefParam -> Array contendo os Parametros do Usuario	�
�          �       														�
�Conteudo  �aUserDefParam[1]Codigo da Empresa no SIGAMAT				�
�          �       														�
�          �aUserDefParam[2]Codigo da Filial no SIGAMAT  				�
�          �       														�
�          �aUserDefParam[3]Se .T. caracterizara que o Programa   devera�
�          �                utilizar os Parametros do Programa de  Leitu�
�          �                ra/Apontamento, confome Definidos pelo 	Usua�
�          �                rio. Caso Contrario Ira considerar os Parame�
�          �                tros De/Ate de Forma Generica. 				�
�          �       														�
�          �aUserDefParam[4]Se a Data Fim dos Parametros deve ser Litida�
�          �                da a Menor Data entra a DataBase e o Fim  do�
�          �                Periodo de Apontamento						�
�          �aUserDefParam[5]Se Deve Processar Por Filial                �
�          �aUserDefParam[6]Se Deve Efetuar Apontamento Quando nao Conse�
�          �                gui Ler o Arquivo do Relogio                �
�          �aUserDefParam[7]Se Deve Forcar o Reapontamento 				�
�          �aUserDefParam[8]Se Utiliza a Filial passada como a que deve-�
�          �                ra ser processada como parametro.			�
�����������������������������������������������������������������������Ĵ
�Uso       �PonWork                                                    	�
�����������������������������������������������������������������������Ĵ
�Observacao�Essa Funcao devera ser Cadastrada no Agendamento           	�
�������������������������������������������������������������������������*/

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
�����������������������������������������������������������������������Ŀ
� Enviando Mensagens para o Console do Server                 			�
�������������������������������������������������������������������������*/
ConOut("")
ConOut( STR0001  + " Data/hora: " + Dtoc(msDate()) + ' / ' + Time() + " - Filial: " + cEmp + '/' + cFil)	//"Iniciando U_PonScheduler()..."
ConOut("")


/*
�����������������������������������������������������������������������Ŀ
� Verifica se Empresa/Filial foram Passados								�
�������������������������������������������������������������������������*/
//IF !Empty( cEmp ) .and. !Empty( cFil )

	//DbselectArea("RFE")
	//RFE->(DBZAP())
	/*
	�����������������������������������������������������������������������Ŀ
	� Enviando Mensagens para o Console do Server                 			�
	�������������������������������������������������������������������������*/
	ConOut("")
	ConOut( STR0002 ) //"Preparando Ambiente da Empresa. Aguarde... "
	ConOut("")
	
	/*
	�����������������������������������������������������������������������Ŀ
	� Prepara Ambiente da Empresa											�
	�������������������������������������������������������������������������*/
	
	PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil ) 
		
	/*
	�����������������������������������������������������������������������Ŀ
	� Redefine nModulo de forma a Garantir que o Modulo seja o SIGAPON		�
	�������������������������������������������������������������������������*/
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
		///deleto o RFE para n�o ficar acumulando registros e demora na leitura
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
		�����������������������������������������������������������������������Ŀ
		� Posiciona o SM0 na Filial a ser Processada                  			�
		�������������������������������������������������������������������������*/
		//SM0->( dbGoto( aFiliais[ nFilial , 02 ] ) )
		SM0->(Dbseek(cEmp + aFiliais[ nFilial] ) )
		nRecno := SM0->(Recno())
                
        //msgbox("Empresa / Filial: " + cEmp + ' / ' + aFiliais[ nFilial] + ' - ' + str(nRecno))
				
		/*
		�����������������������������������������������������������������������Ŀ
		� Enviando Mensagens para o Console do Server                 			�
		�������������������������������������������������������������������������*/
		
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
		�����������������������������������������������������������������������Ŀ
		� Chamada a Funcao de Leitura e Apontamento das Marcacoes     			�
		�������������������������������������������������������������������������*/
						
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
		�����������������������������������������������������������������������Ŀ
		� Enviando Mensagens para o Console do Server                 			�
		�������������������������������������������������������������������������*/
		
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
	�����������������������������������������������������������������������Ŀ
	� Enviando Mensagens para o Console do Server                 			�
	�������������������������������������������������������������������������*/
	ConOut("")
	ConOut( STR0008 + " - FIM LEITURA" ) //TESTE FLAVIA ROCHA ")	//"Encerrando Ambiente da Empresa. Aguarde... "
	ConOut("")
	/*
	�����������������������������������������������������������������������Ŀ
	� Finaliza o Ambiente da Empresa										�
	�������������������������������������������������������������������������*/
	
	
	
	RESET ENVIRONMENT
/*
Else

	
	//�����������������������������������������������������������������������Ŀ
	//� Enviando Mensagens para o Console do Server                 			�
	//�������������������������������������������������������������������������
	ConOut("")
	ConOut( STR0009 )	//"Nao foi possivel concluir o processo. Empresa ou Filial Invalidas."
	ConOut("")

EndIF

*/
/*
�����������������������������������������������������������������������Ŀ
� Enviando Mensagens para o Console do Server                 			�
�������������������������������������������������������������������������*/
ConOut("")
ConOut("Finalizando U_PonTOScheduler()...")
ConOut("")
	
Return( NIL )

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    �StartJobPon  � Autor � Marinaldo de Jesus � Data �21/11/2001�
�����������������������������������������������������������������������Ĵ
�Descri��o �Start do Processo de WorkFlow                               �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �u_StartJobPon												�
�����������������������������������������������������������������������Ĵ
�Parametros�															�
�����������������������������������������������������������������������Ĵ
�Uso       �PonWork                                                    	�
�����������������������������������������������������������������������Ĵ
�Observacao�Essa Funcao devera ser Incluida no .INI do Server          	�
�������������������������������������������������������������������������*/
User Function JobPonStart()

Local aEmpFil := Array( 03 )

//aEmpFil[ 01 ] := "01"	//Codigo da Empresa confome SIGAMAT
aEmpFil[ 01 ] := "02"	//Codigo da Empresa confome SIGAMAT
aEmpFil[ 02 ] := "01"	//Codigo da Filial  confome SIGAMAT
aEmpFil[ 03 ] := "03"	//Codigo da Filial  confome SIGAMAT

Return( wfStart( aEmpFil ) )