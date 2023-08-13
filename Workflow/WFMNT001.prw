#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: WFMNT001
//Objetivo: Imprimir e enviar Relat�rio das Manuten��es Preventivas em atraso
//          ( considerar somente atrasos ap�s 7 dias)
//Autoria : Fl�via Rocha
//Empresa : RAVA
//Data    : 15/08/11
//--------------------------------------------------------------------------
/*/


************************************
User Function WFMNT001()
************************************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relat�rio est� sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	fMNT01()	//chama a fun��o do relat�rio
  
Else
  lDentroSiga := .T.
  fMNT01()
  
EndIf
  

Return

************************************
Static Function fMNT01()
************************************


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Manuten��es Preventivas em Atraso"
Local cPict          := ""


Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "WFMNT001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "WFMNT001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		 := "WFMNT01"
Private cString := ""

Private dData		:= Ctod("  /  /    ")
Private dData1		:= Ctod("  /  /    ")
Private dData2		:= Ctod("  /  /    ")

Private cDirHTM		:= ""
Private cArqHTM		:= ""
Private nPag		:= 1
Private LF      	:= CHR(13)+CHR(10) 
Private nLin		:= 80
Private Cabec1      := "Descri��o               Nome Servi�o                Dt.Prevista       Dias em" 
Private Cabec2		:= " Bem                                                Manuten��o        Atraso"
Private titulo         := "" 

titulo         := "MANUTEN��ES PREVENTIVAS EM ATRASO"


If lDentroSiga
	
	Pergunte(cPerg,.T.)    //INFORME O REPRESENTANTE
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  	
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	nTipo := If(aReturn[4] == 1,15,18)
    
	//���������������������������������������������������������������������Ŀ
	//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
	//�����������������������������������������������������������������������
    //If MsgYesNo("Deseja Gerar o Relat�rio 03 ?")
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	//Endif
Else

	RunReport(Cabec1,Cabec2,Titulo,nLin)
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  26/10/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Local cQuery:=''
Local aManut:= {} 
Local eEmail:= ""
Local nRegTot := 0
Local aManutF := {} 
Local cMsg	  := ""


//dDTMANU := PROXMANU(VCODBEM,VSERVICO,VSEQ)

cQuery := " SELECT TF_CODBEM, TF_NOMEMAN, T9_CODBEM, T9_NOME, TF_DTULTMA, TF_SEQRELA, TF_SERVICO   " +LF

cQuery += " FROM "+LF
cQuery += " " + RetSqlName("STF") + " STF WITH (NOLOCK), " + LF
cQuery += " " + RetSqlName("ST9") + " ST9 WITH (NOLOCK) " + LF

cQuery += " WHERE TF_ATIVO = 'S' " + LF
cQuery += " AND STF.TF_TIPO = '003' " + LF 	//PREVENTIVA  
cQuery += " AND STF.TF_CODBEM = ST9.T9_CODBEM " + LF                           
cQuery += " AND ST9.D_E_L_E_T_ = '' "+LF
cQuery += " AND STF.TF_DTULTMA > '20140201' "+LF  //COMO O JEAN-CARLOS S� ENTROU EM MAR�O, ELE S� QUER VER AS MANUTEN��ES POR ELE GERENCIADAS.
cQuery += " AND STF.D_E_L_E_T_ = '' "+LF   
cQuery += " AND STF.TF_FILIAL = ST9.T9_FILIAL " + LF
If lDentroSiga
	If !Empty(mv_par01) .and. !Empty(mv_par02)
		cQuery += " AND STF.TF_CODBEM >= '" + Alltrim(mv_par01) + "' AND STF.TF_CODBEM <= '" + Alltrim(mv_par02) + "' " + LF
	Endif
Endif
cQuery += " ORDER BY T9_NOME " + LF


MemoWrite("C:\Temp\WFMNT001.sql", cQuery )
          
If Select("MNTX") > 0
	DbSelectArea("MNTX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "MNTX"

TCSetField( "MNTX", "TF_DTULTMA", "D")

MNTX->( DbGoTop() )

While MNTX->( !EOF() )
	
	dDTMANU := CTOD("  /  /    ")
	nDias	:= 0
	dDTMANU := PROXMANU( MNTX->TF_CODBEM, MNTX->TF_SERVICO, MNTX->TF_SEQRELA)
	If !Empty(dDTMANU)
		If ( dDatabase - dDTMANU ) > 7
			nDias := (dDatabase - dDTMANU)
			//Aadd( aManut, {MNTX->TF_CODBEM, MNTX->TF_NOMEMAN, dDTMANU, nDias }  )
			Aadd( aManut, { Alltrim(MNTX->T9_NOME), MNTX->TF_NOMEMAN, dDTMANU, nDias, MNTX->TF_DTULTMA }  )
			nRegTot++
		Endif
	Endif
	/*
	If ( dDatabase - dDTMANU ) >= 1
		nDias := (dDatabase - dDTMANU)
		//Aadd( aManut, {MNTX->TF_CODBEM, MNTX->TF_NOMEMAN, dDTMANU, nDias }  )
		Aadd( aManutF, { Alltrim(MNTX->T9_NOME), MNTX->TF_NOMEMAN, dDTMANU, nDias, MNTX->TF_DTULTMA }  )
		nRegTot++
	Endif
	*/
    MNTX->(DBSKIP())
Enddo


MNTX->( DbCloseArea() )

aManut   := Asort( aManut,,, { |X,Y| Transform(X[4],"@E 9999")  >   Transform(Y[4] ,"@E 9999") } ) 

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
If lDentroSiga
	SetRegua( nRegTot )	
	//ProcRegua(nRegTot)
Endif

nCta := 1
If !lDentroSiga    		///se estiver sendo executado via SCHEDULE...

	If Len(aManut) > 0
	
		oProcess:=TWFProcess():New("WFMNT001","WFMNT001")
		oProcess:NewTask('Inicio',"\workflow\http\emp01\WFMNT001.htm")
		oHtml   := oProcess:oHtml
	  	
	  	Do While nCta <= Len(aManut)
	  
			aadd( oHtml:ValByName("it.cBem")     , aManut[nCta,1] )                                            
		   	aadd( oHtml:ValByName("it.cServico") , aManut[nCta,2] )    
		   	aadd( oHtml:ValByName("it.dPrev")    , DtoC(aManut[nCta,3]) )    
		   	aadd( oHtml:ValByName("it.nDias" )   , Str(aManut[nCta,4]) ) 
		   	aadd( oHtml:ValByName("it.dUlt")     , DtoC(aManut[nCta,5]) )       
		   	
	        nCta++
		enddo
		
		 //_user := Subs(cUsuario,7,15)
		 //oProcess:ClientName(_user) 
		 eEmail := "marcelo@ravaembalagens.com.br"
		 //eEmail += ";orley@ravaembalagens.com.br"
		 eEmail += ";giancarlo.sousa@ravaembalagens.com.br"
		 //eEmail += ";romildo@ravaembalagens.com.br"
		 eEmail += ";jorge.luis@ravabrasil.com.br"
		 
		 oProcess:cTo := eEmail 
	
		 subj	:= "Manuten��es Preventivas Em Atraso"
		 oProcess:cSubject  := subj
		 oProcess:Start()
		 WfSendMail() 
	
	Else
	   /*
		cMsg   := "Para: Fl�via / Eurivan" + LF + LF 
		cMsg   += "----------------------------------------------" + LF + LF
		cMsg   += "N�o existem Manuten��es Preventivas em Atraso"
		eEmail := "flavia.rocha@ravaembalagens.com.br"
		subj   := "Manuten��es Preventivas Em Atraso"
		//oProcess:cTo := eEmail
		U_SendFatr11(eEmail, "", subj, cMsg, "" )					
	*/
		  
	Endif
	
	
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
Else		//////////emitindo dentro do Siga
	//msginfo("Dentro do Siga")
	
	If Len(aManut) > 0
	
		
	  	Do While nCta <= Len(aManut)

			If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
	
		   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 9
		   Endif

	 	  	@nLin,000 PSAY Alltrim(Substr(aManut[nCta,1],1,20))					//descri��o do Bem
	 	  	@nLin,023 PSAY Alltrim(Substr(aManut[nCta,2],1,30))		//nome do servi�o
	 	  	@nLin,056 PSAY DtoC(aManut[nCta,3])	   			//dt prevista da manuten��o
	 	  	@nLin,072 PSAY Alltrim(Str(aManut[nCta,4]))		//dias em atraso
		  	nLin++
		  	nCta++
	  	    IncRegua()
	
	  	Enddo
		@nLin++,00 PSAY replicate("=",limite) 
		
		Roda(0,"",Tamanho)
		
		SET DEVICE TO SCREEN

		//���������������������������������������������������������������������Ŀ
		//� Se impressao em disco, chama o gerenciador de impressao...          �
		//�����������������������������������������������������������������������
		
		If aReturn[5]==1
		   dbCommitAll()
		   SET PRINTER TO
		   OurSpool(wnrel)
		Endif
		
		MS_FLUSH()
 
  	Else
  		MsgInfo("N�o existem Manuten��es Preventivas em Atraso.")
  	Endif


Endif	//se for dentro do siga

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
If !lDentroSiga
	// Habilitar somente para Schedule
	Reset environment
Endif

Return



