#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ FATC029  ³ Rotina para mostrar browse no arquivo de notas e possibilitarº±±
±±º             ³          ³ a GERAÇÃO DE ARQUIVO TXT para PAMCARY                        º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 07.02.06 ³ Jaciara                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autora      ³ 09.05.13 ³ Flávia Rocha                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/00 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATC029()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                  								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores		:= {	{  '!Empty(F2_DTEXP)',	'BR_VERMELHO'},;	// NF Expedida
								{  'Empty(F2_DTEXP)',	'BR_VERDE'} }		// NF Não Expedida


Private aRotina		:= {	{"Pesquisar",	"AxPesqui"			,0,1},;	// Pesquisar
									{"Visualizar",	"MC090Visual"		,0,2},;	// Visualizar
									{"Gera Arquivo",		"U_Pamcary"		,0,4},;	// Gera arquivo
									{"Legenda",		"U_RFATA01Leg()"	,0,5}}	// Legenda  
									
//Private aRotina		:= {	{"Pesquisar",	"AxPesqui"			,0,1},;	// Pesquisar
//									{"Visualizar",	"MC090Visual"		,0,2},;	// Visualizar
//									{"Expedir",		"U_FATA01Exp"		,0,4}}	// Expedir
						
Private cCadastro	:= "Geração Arquivo TXT PamCary"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbSetOrder(1)

mBrowse(6,1,22,75,"SF2",,,,,,aCores)

Return(Nil)




******************************************************************************************************
User Function Pamcary()
******************************************************************************************************

//Local aAreaAtu	:= GetArea()
//Local aAreaSZ6	:= SZ6->(GetArea())
Local cNomMot	:= Space(20)  //CriaVar("Z6_NOMMOT",.F.,.F.)
Local cNomTra	:= Space(20)  //CriaVar("Z6_NOMTRA",.F.,.F.)
Local cObsTra	:= Space(50)  //CriaVar("Z6_OBSTRA",.F.,.F.)
Local cDaimler  := ""	&& por enquanto será gerado arquivo só qdo cliente for Daimler 012756/00
Local cAnexo    := ""

Private _oDlg
Private oDlg5


Pergunte("FATC029", .T.)	    
If MsgYesNo("Deseja Gerar o Arquivo Pamcary ?")
	   
	   
	   //Prepara para gravar o .TXT
	   /* 
	   Nome do arquivo: TIDXMMDD.999
		TID = Nome fixo para identificar os arquivos para importação dos dados.
		X = N para movimento “Nacional”
		I para movimento “Internacional”
		MMDD = Mês e Dia do Movimento.
		Quando o Mês ou Dia < 10 - Preencher com zero a esquerda.
		Exemplo Mês = 5 -> 05 Dia = 6 -> 06.
		999 = Seqüência do Movimento para não sobrepor os arquivos gerados no mesmo dia.
		Exemplo: TIDN0506.010 
		*/

		   nSeq       := 1
		   cSeq 	  := Strzero(nSeq,3)
		   cBodyTXT   := U_GeraTxtNF(MV_PAR01,MV_PAR02)  // Gera o TXT com dados - Daimler Chrysler
		   cDirTXT    := "\Temp\"					&&   \\Protheus\Protheus8\Protheus_Data\COM	 - letra Q:\ 	   			
		   cArqTXT    := "TIDN"+Substr(DTOS(dDatabase),5,2) + Substr(DTOS(dDatabase),7,2)+ "." + Alltrim(cSeq)
           
           nHandleTXT := fCreate(cDirTXT+cArqTXT)
           Fwrite( nHandleTXT, cBodyTXT, Len(cBodyTXT) )                             
           FClose( nHandleTXT )
           cAnexo := cDirTXT + cArqTXT  
     	//ELSE
     	//	cAnexo := ""
        //ENDIF
	    
	    
	   	    
    // pergunta se quer mandar o arquivo ou visualiza-lo
    
    //if  aviso("Confirmação de Expedição de NOTA FISCAL","Qual o destino do relatorio gerado",;
	//     {"Visualizar","E-mail"}) == 2

    	PswOrder(1)
		If PswSeek(__CUSERID)
			_cRemet	:=	padr(PswRet(1)[1][14],50)
			//AllTrim(UsrRetMail(__cUserID))
		EndIf
		
		SD2->(DBSETORDER(3))
		IF SD2->(DBSEEK(XFILIAL("SD2")+SF2->F2_DOC ) )
			cPed := SD2->D2_PEDIDO
		ENDIF
		
		SC5->(DBSETORDER(1))
		//IF SC5->(DBSEEK(XFILIAL("SC5")+cPed ) )
			//_cDest := padr(SC5->C5_EMAIL,80)
			
		//ELSE
		//	_cDest := space(80)
		//ENDIF
		cBody     := " ARQUIVO PAMCARY GERADO"
		//_cAssunto := padr("Rava Embalagens - Confirmação envio de nossa NF Nr.: "+SF2->F2_DOC,80)
		_cAssunto := padr("Rava Embalagens - Arq.Pamcary - " + cArqTXT , 80)
		_cDest := "flavia.rocha@ravaembalagens.com.br"
		_cCC := space(80)
			
		 
		 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Criacao da Interface para envio de email ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   
		
		Define MSDialog _oDlg Title "Envio de E-mail" From 0,0 To 265,480 Pixel
   		@05,03 TO 29,235 OF oDlg5 PIXEL
   		@10,10 Say "De:" Pixel Of _oDlg  COLOR CLR_HBLUE           //WHEN .F.	PICTURE PesqPict("SF2","F2_TRANSP")		OF oDlg5 SIZE 040,006 PIXEL	
		@10,35 MsGet _cRemet WHEN .F. OF _oDlg Size 190,10 Pixel 
			
		@30,03 TO 54,235 OF oDlg5 PIXEL
		@35,10 Say "Para:" Pixel Of _oDlg COLOR CLR_HBLUE
		@35,35 Get _cDest WHEN .T. Size 190,10 Pixel Of _oDlg
        
		@55,03 TO 79,235 OF oDlg5 PIXEL
		@60,10 Say "Cc:" Pixel Of _oDlg COLOR CLR_HBLUE
		@60,35 Get _cCC WHEN .T. Size 190,10 Pixel Of _oDlg
		
		@80,03 TO 104,235 OF oDlg5 PIXEL
		@85,10 Say "Assunto:" Pixel Of _oDlg COLOR CLR_HBLUE
		@85,35 MsGet _cAssunto WHEN .F. Size 190,10 Pixel Of _oDlg	
		
		//DEFINE SBUTTON FROM 106,130 TYPE 1 ENABLE OF _oDlg ACTION lEnv := u_MeuMail(_cRemet, _cDest, _cCC, _cAssunto, cBody, cAnexo)
		DEFINE SBUTTON FROM 106,130 TYPE 1 ENABLE OF _oDlg ACTION (lEnv := U_SendFatr11(_cDest, _cCC, _cAssunto, cBody, cAnexo), Close(_oDlg) )
		//U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
		DEFINE SBUTTON FROM 106,180 TYPE 2  ENABLE OF _oDlg ACTION Close(_oDlg)
		
		//@060,130 BMPBUTTON TYPE 1 ACTION (lOk := .T., Close(oDlg) )
	 	//@060,180 BMPBUTTON TYPE 2 ACTION (lOk := .F., Close(oDlg) )
			
		Activate Dialog _oDlg CENTERED
		
	   		

EndIf

//RestArea(aAreaSZ6)
//RestArea(aAreaAtu)

Return(Nil)



******************************************************************************************************
User Function RFATA01Leg()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERMELHO",	"Nota Fiscal já Expedida"} ,;
                                    {"BR_VERDE",	"Nota Fiscal a Ser Expedida"}} ) 
											
						

Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERATXTNFºAutor  ³Flávia               º Data ³  14/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera um texto TXT com os dadsos da NF expedida            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION GeraTxtNF(cNotaDE,cNotaTE)


Local nSequencia:= '000001'  //GETMV("AT_SEQTXT")
Local cSequencia:= ""

LOCAL LFTXT       := CHR(13)+CHR(10) , cAlias := ALIAS(), aAlias := {}, aAmb := {}
Local cPedido     :="" 

Local nCta10 := 0 
Local nValbrut := 0
Local cValbrut := ""
Local nTotVal  := 0
Local cTexto   := ""
Local cF2NOTA  := ""


// salva o ambiente atual das tabelas do array abaixo
aAlias := {"SC5", "SC6", "SA1", "SA4", "SF2", "SD2","SB1" }
aAmb := U_GETAMB( aAlias )


// inicia geracao do TXT


SF2->(DBSETORDER(1))
SF2->(Dbgotop())
//IF SF2->(DBSEEK(XFILIAL("SF2")+ MV_PAR01 ) )
IF SF2->(DBSEEK(XFILIAL("SF2")+ cNotaDE ) )
	//alert("encontrou")
	While !SF2->(EOF()) .and. SF2->F2_FILIAL == xFilial("SF2") .AND. Alltrim(SF2->F2_DOC) >= Alltrim(cNotaDE) .and. Alltrim(SF2->F2_DOC) <= Alltrim(cNotaTE)
		cF2NOTA := SF2->F2_DOC
		nValbrut    := (SF2->F2_VALBRUT * 100)
		cValbrut    := TRANSFORM(nValbrut,"@X")
		nVolume     := (SF2->F2_VOLUME1 * 100)
		cVolume     := TRANSFORM(nVolume,"@X")
		nPBruto     := (SF2->F2_PBRUTO * 100)
		cPBruto     := TRANSFORM(nPBruto,"@X")
		
		//nSomaICM    := ( SF2->F2_VALICM + SF2->F2_ICMFRET + SF2->F2_ICMAUTO)*100
		//cSomaICM    := TRANSFORM(nSomaICM,"@X")
		
		//nValIPI     := (SF2->F2_VALIPI)*100
		//cValIPI     := TRANSFORM( nValIPI,"@X")
		
		//nSomaFRESEG := ( SF2->F2_FRETE + SF2->F2_SEGURO )*100
		//cSomaFRESEG := TRANSFORM( nSomaFRESEG, "@X")
		
		//nValFRETE   := (SF2->F2_FRETE * 100)
		//cValFRETE   := TRANSFORM(nVALFRETE,"@X")
		
		//nValSEG     := (SF2->F2_SEGURO * 100)
		//cValSEG     := TRANSFORM(nValSEG, "@X")
		
		//nDescNF     := (SF2->F2_DESCONT * 100)
		//cDescNF     := TRANSFORM(nDescNF, "@X")
		
		//nAliqIR		:= ( SF2->F2_VALIRRF / SF2->F2_VALBRUT ) * 100
		//cAliqIR		:= TRANSFORM(nAliqIR,"@X")
		
		//nBaseIR		:= (SF2->F2_VALBRUT)
		//cBaseIR		:= TRANSFORM(nBaseIR,"@X")
		
		//nValIR		:= (SF2->F2_VALIRRF)
		//cValIR		:= TRANSFORM(nValIR,"@X")
			
		
		
		SC6->(DBSETORDER(4))
		IF SC6->(DBSEEK(XFILIAL("SC6")+ cF2NOTA ) )
			cPedido:= SC6->C6_NUM
		ENDIF
		
		SC5->(DBSETORDER(1))
	    IF SC5->(DBSEEK(XFILIAL("SC5")+cPedido ) )	
	    	cPedCli := ALLTRIM(SC5->C5_OCCLI)
		ENDIF
		
		SD2->(DBSETORDER(3))
		SD2->(DBSEEK(XFILIAL("SD2")+cNotaDE ) )
		//	cProd := SD2->D2_COD
		//ENDIF
		
		//SB1->(DBSETORDER(1))
		//IF SB1->(DBSEEK(XFILIAL("SB1")+cProd) )
		//	cDesc := SB1->B1_DESC
		//ENDIF
		
		SA1->(DBSETORDER(1))
		SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE + SC5->C5_LOJACLI , .F. ) )
	
		
		SA4->(DBSETORDER(1))
		SA4->(DBSEEK( XFILIAL("SA4")+SF2->F2_TRANSP , .F. ) )
		
		
		//cSequencia := nSequencia
		cSequencia := TRANSFORM(nSequencia,"@X")
		cSequencia := STRZERO(VAL(cSequencia),05)
    
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//--TIPO = 10 Registro Viagem (tipo =10): Este registro informa os dados gerais da viagem e é obrigatório. 
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		cTexto := "10"           						&& 001/002 Tipo do registro Fixo = 10. Campo Obrigatório
		cTexto += "06"		                            && 003/004 Tipo do DUV Vide lista de códigos abaixo. 
		                                                /*
														Campo Obrigatório
														Código
														01-Manifesto
														02-Romaneio
														03-Plano de Viagem
														04-AWB
														05-Conhecimento
														06-Nota Fiscal
														07-Documento Próprio do Cliente
														*/
		cTexto += Repli("X",30)							&& 005/034 Número do DUV - coloquei "x" p/ teste
		cCidade := ALLTRIM(SM0->M0_CIDCOB)
		nTam    := Len(cCidade)
		cTexto += cCidade + Space( 50 - nTam)           && 035/084 Cidade Filial Emissão DUV
		cTexto += ALLTRIM(SM0->M0_ESTCOB)	            && 085/086 UF Filial Emissão
		cPais  := "BRASIL"
		nTam   := Len(cPais)
		cTexto += cPais + Space(30 - nTam)	            && 087/116 País Filial Emissão
		cTexto += "01"					                && 117/118 Tipo de documento do segurado
		cTexto += Alltrim(SM0->M0_CGC) + "0"			&& 119/133 CNPJ - prenchi com zero o espaço que faltava
	    cTexto += "01" //REVER							&& 134/135 Ramo do Seguro 
	                                                    /*
	    												Vide lista de códigos abaixo.
														Campo Obrigatório
														Código
														01-RCTRC
														03-TRNAC (antigo TTRR)
														04-TRNAC –MAR (antigo TRMAR)
														05-TRNAC –ERA (antigo TRAER)
														06-TRNAC –FLU (antigo TRFLU)
														09-RCTAC
														30-RCT-VI
														56-RCAC
														59-TRINT
														66-RCT-AMB
														67-TR-AMB
														*/
	    cTexto += " " 									&& 136 Preencher com brancos
	    cTexto += "14"						            && 137 Tipo Moeda
	    												/*
	    												Vide lista de códigos abaixo.
														Campo Obrigatório
														Código
														14-Real
														03-Dólar
	    												*/
		//cTexto += STRZERO(VAL(cValbrut),15,2)           && 139/153 Valor Total de Embarque		
		cTexto += STRZERO(VAL(cValbrut),15,0)           && 139/153 Valor Total de Embarque		
		cTexto += Substr(DtoS(SF2->F2_DTEXP),7,2) + "/" + Substr(DtoS(SF2->F2_DTEXP),5,2) + "/" + Substr(DtoS(SF2->F2_DTEXP),1,4)  && 154/163 DD/MM/AAAA Data de Saída da Viagem
		cTexto += Time() 				 				&& 164/171 - HH:MM:SS Hora de Saída da Viagem
		cTexto += Substr(DtoS(SF2->F2_PREVCHG),7,2) + "/" + Substr(DtoS(SF2->F2_PREVCHG),5,2) + "/" + Substr(DtoS(SF2->F2_PREVCHG),1,4) &&172/181 DD/MM/AAAA Data Prevista Chegada                                && Data Prevista de Chegada
		cTexto += "00:00:00"							&& 182/189 Hora Prevista de Chegada //REVER
		cTexto += Space(53)								&& 190/242 Reservado
		cTexto += Space(9)								&& 243/251 Km Total da viagem
		cTexto += "N"									&& 252/252 Rodofluvial     //REVER
														/*
														Preencher com “S” se houver trecho
														fluvial. Ex.: Viagem de Fortaleza a Manaus
														vai de balsa de Belém a Manaus. Se não
														houver preencher com “N”. Campo
														Obrigatório.
														*/
														
		nTam   := Len(cCidade)
		cTexto += cCidade + Space( 50 - nTam) 			&& 253/302 Nome da Cidade da Origem da Viagem
														/*
														
														Campo Obrigatório
														Para Averbações do ramo RCT-VI este
														campo poderá ser informado como a
														Cidade = Pais.
														Exemplo: Pais: Argentina, Cidade :
														Argentina
														*/
		cTexto += SM0->M0_ESTCOB						&& 303/304 Sigla da UF da Cidade da Origem da
														&&Viagem. Campo Obrigatório
		cPais  := "BRASIL"
		nTam   := Len(cPais)
		cTexto += cPais + Space(30 - nTam)				&& 305/334 País origem - Campo obrigatório
		cMunCli := SA1->A1_MUN
		nTam   := Len(cMunCli)
		cTexto += cMunCli + Space(50 - nTam)			&& 335/384 Nome da Cidade de Destino da Viagem - Campo Obrigatório
		cTexto += SA1->A1_EST 							&& 385/386 Sigla da UF da Cidade de Destino da Viagem. Campo Obrigatório
		nTam := Len(cPais)
		cTexto += cPais + Space(30 - nTam)				&& 387/416 País da Cidade de Destino da Viagem. Fixo em “BRASIL” para viagens nacionais.Campo Obrigatório
		cTexto += Substr(DtoS(dDatabase),7,2) + "/" + Substr(DtoS(dDatabase),5,2) + "/" + Substr(DtoS(dDatabase),1,4) && 417/426 dd/mm/aaaa Data de Emissão do DUV
		cTexto += Time() 								&& 427/434 Hora de Emissão do DUV 
		cTexto += "S"									&& 435/435 Indicador Infolog - Preencher com “S” para gerar Infolog automaticamente ou deixar em branco se não quiser.
		cTexto += Space(15)								&& 436/450 Reservado Preencher com brancos 
		cTexto +=LFTXT 
		/////////////////////
		//--Fim do TIPO = 10
		////////////////////
		                                                          
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		//Tipo = 11 - Registro de Motorista (tipo = 11): Este registro informa os dados do motorista. Obrigatório somente para ramos
		//rodoviários podendo haver um ou mais registros no caso de haver mais que um motorista para a viagem. 
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
							
		cTexto += "11"									&& 001/002 Tipo de Registro - Fixo = 11. Campo Obrigatório
		cTexto += Repli("X",30)							&& 003/032 Número do Documento Único da Viagem - Campo Obrigatório // rever
		cTexto += "02"									&& 033/034 Tipo de Documento Vide lista de códigos abaixo.Campo Obrigatório
														/*
														Código
														02-CPF
														03-CUIT
														04-CUIL
														05-CIU
														06-RUN
														07-RUC
														08-CIP
														09-CIB
														10-DNI
														11-RNE
														99-ODI (Outros Docs Internacionais)
														*/
														&& 035/049 Número do documento do Motorista.Sem edição. Ex: CPF nro. 012.345.678-90
	 	cTexto += "123456789012345"						&& 01234567890 Campo Obrigatório   //rever 
		cNomeMot := "NOME MOTORISTA"
		nTam 	 := Len(cNomeMot)
		cTexto   += cNomeMot + Space(50 - nTam) 		&& 050/099 Nome Completo do Motorista
														&& 100/100 Vide lista de códigos abaixo.
														/*
														Código
														1-Frota
														2-Agregado
														3-Autônomo/Carreteiro
														*/
		If Alltrim(DA4->DA4_TIPMOT) = '1' //1=Proprio;2=Terceiro;3=Agregado                                                                                                 
			cTexto += '1'
		ElseIf Alltrim(DA4->DA4_TIPMOT) = '2'
			cTexto += '3'
		ElseIf Alltrim(DA4->DA4_TIPMOT) = '3'
			cTexto += '2'
		Endif
		cTexto += "nroPamcard" 							&&101/110 Número do Pamcard do Motorista sem edição.
		cTexto += Space(340)							&& 111/450 Reservado Preencher com Brancos
		cTexto +=LFTXT    
		//////////////////////
		///--FIM DO TIPO = 11 
		//////////////////////
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Tipo - 12 Registro de Veículo (tipo = 12): Este registro informa os dados do veículo e é obrigatório. Caso seja informado um
		//veículo do Tipo 03 – Caminhão Trator deverá haver mais um registro deste tipo para cada carreta que fizer parte desta
		//viagem.
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		cTexto += "12"									&& 001/002 Tipo de registro - Fixo = 12. Campo Obrigatório
		cTexto += Repli("X",30)							&& 003/032 Número do Documento Único da Viagem. Campo Obrigatório
		cTexto += "01" 									&& 033/034 Vide lista de códigos abaixo.  //rever
														/*
														Campo Obrigatório
														Código
														01-Caminhão Truck
														02-Caminhão Toco
														03-Cavalo Mecânico (Caminhão Trator)
														04-Caminhão Truck Baú
														05-Caminhão Truck Aberto
														06-Caminhão Baú Furgão
														07-Automóvel (Utilitário)
														08-Automóvel (demais gêneros)
														09-Carreta (todos os gêneros)
														10-Navio (todos os gêneros)
														11-Balsa (todos os gêneros)
														12-Trem (todos os gêneros)
														13-Avião (todos os gêneros)
														14-Ônibus (todos os gêneros)
														15-Motocicleta (todos os gêneros)
														16-Caminhão Truck Graneleiro
														*/
		cTexto += "ABC1234"								&& 035/084 Identificação do Veículo. //REVER
														/*
														Ex: “ABC1234” (Ramo Rodoviário)
														Campo Obrigatório se não informar
														o RENAVAM
														*/
		cTexto += "1234567890"							&& 085/094 Renavam do Veículo
														/*
														Preencher com o número do
														RENAVAM do Veículo. Ex:
														0123456789
														Campo Obrigatório, se não informar
														a identificação do veículo
														*/
		cTexto += Space(1)								&& 095/095 - Reservado, preencher com brancos 
		cTexto += "02"									&& 096/097 Tipo Documento Proprietário  //rever
														/*Vide lista de códigos abaixo.
														Campo Obrigatório.
														Código
														01-CNPJ
														02-CPF
														03-CUILT
														04-CUIL
														05-CIU
														06-RUN
														07-RUC
														08-CIP
														09-CIB
														10-DNI
														11-RNE
														99-ODI (Outros Docs Internacionais)
														*/
		cTexto += "123456789012345"						&& 098/112 Preencher com o número documento do Proprietário sem edição.  //rever
														//Ex: 01122233344. Campo Obrigatório.											
		cTexto += Space(338)							&& 113/450 Reservado - Preencher com Brancos
		cTexto +=LFTXT 	
		//////////////////////
		///--FIM DO TIPO = 12 
		/////////////////////
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Tipo 13 - Registro de Gerenciamento de Riscos (tipo = 13): Este registro informa os dados de Gerenciamento de Risco da
		//Viagem, deverá ser gerado apenas um registro por viagem. 
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		cTexto += "13"									&& 001/002 Tipo de Registro - Fixo = 13. Campo Obrigatório
		cTexto += Repli("X",30)							&& 003/032 Número do Documento Único da Viagem - Campo Obrigatório //rever
		cTexto += "01"									&& 033/034 Tipo de Monitoramento //rever
														/*
														Vide lista de códigos abaixo
														Campo Obrigatório
														Código
														01-Não Informado
														02-Não monitorado
														03-Equipamento não informado
														04-Cartão/Transponder
														05-Telefone
														06-Via satélite – para fins logísticos
														08-Controlsat 1.15 com 5a roda
														inteligente ou imobilizador de movto
														10-Omnisat OBC3 com 5a roda
														inteligente ou imobilizador de movto
														11-Saver 2000 Avançado – Hw RI 1450
														(ou versões superiores)
														12-Ituran
														13-Outros Equipamentos
														14-Outros Equipamentos de 1ª Linha
														15-Jabursat 2.10-Hw 2.0 (ou versões
														sup)/5ª roda intelig.
														16-Rodosis GR 1.2 – HW SIS404 (ou
														versões superiores).
														17-Controlloc ControlFleet 2.0.36-HW
														2.0 (ou versões superiores)
														Obs: Caso não tenha os dados em seu sistema,
														fixar campo como “01 - Não Informado”
														*/
		cTexto += "1234567890"							&&035/044 Identificação do Equipamento de Monitoramento //rever
														//Preencher com o número de série do equipamento de Monitoramento.
														//Ex: “987W123B6”
														/*
														Obs: Se o provedor for:
														Opção 14 – Preencher os 9 dígitos
														acrescentado zeros á esquerda e o
														décimo deixar em branco.
														Ex.: “001234789”
														Opção 15 – Preencher os 10 dígitos
														e acrescentar zero á esquerda.
														Ex.: “0001234789”
														*/
		cTexto += "15"									&& 045/046 Provedor da Tecnologia //rever
														/*
														Caso não houver,informar código
														“09- Outros”
														Código
														01-Autotrac
														02-Controlsat
														03-Outros Equipamentos de 1ª Linha
														04-Omnilink
														05-Jabursat
														07-Rodosis
														08-Autotax
														09-Outros
														10-Ituran
														14-Omnidata
														15-Pamcary
														*/
		cTexto += "PAMSAT" + Space( 30 - 6 )			&& 047/076 Empresa que realiza o serviço de Monitoramento  //rever
														//Preencher o nome da empresa que irá realizar o serviço. Ex: Pamsat.
		cTexto += "01" 									&& 077/078 Tipo de Escolta //rever
														/*
														Vide lista de códigos abaixo.
														Campo Obrigatório
														Código
														01-Não Informado
														02-Não Escoltado
														03-Oficial
														04-Velada
														*/
		cTexto += "ESCOLTA" + Space( 30 - 7)			&& 079/108 Preencher o nome da empresa que irá realizar o serviço de escolta //rever
		cTexto += Space(342)							&& 109/450 Revervado - preencher com brancos
		cTexto +=LFTXT 	
		///////////////////
		//-- Fim Tipo = 13 
		//////////////////
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Tipo - 20
		//Registro Mercadoria Embarcada (tipo = 20): Este registro deverá conter todas as Mercadorias Embarcadas com a
		//identificação de Destino das mesmas. Deve ser gravado um registro para cada documento e a soma dos valores dos
		//mesmos deve ser igual ao Valor Total Embarcado, informado no Registro Tipo 10.  
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		DbselectArea("SD2")
		SD2->(DBSETORDER(3))
		SD2->(DBSEEK(XFILIAL("SD2")+cF2NOTA ) )
		While !SD2->(EOF()) .AND. SD2->D2_FILIAL == xFilial("SD2") .and. Alltrim(SD2->D2_DOC) == Alltrim(cF2NOTA)
			cTexto += "20"									&& 001/002 Tipo de Registro - Fixo = 20
			cTexto += Repli("X",30)							&& 003/032 Número do DUV //rever
			cTexto += SD2->D2_ITEM 							&& 033/036 Seqüência do item
			cTexto += Repli("X",15)							&& 037/051 Documento da Viagem, Doc. Viagem, um ou mais itens por documento. (*) //rever
			cTexto += Repli("X",6)							&& 052/057 Conhecimento  //rever
			cTexto += Substr(cF2NOTA,5,5)					&& 058/063 Número da Nota Fiscal. (*) //REVER
			cTexto += SA1->A1_MUN							&& 064/113 Cidade de Destino Nome da Cidade de Destino do Documento.Campo Obrigatório 
			cTexto += SF2->F2_EST 							&& 114/115 Sigla da UF de Destino do Documento.Campo Obrigatório
			cPais := "BRASIL"
			nTam  := Len(cPais)
			cTexto += cPais + Space(30 - nTam)				&& 116/145 Nome do País de Destino do Documento, fixo em “BRASIL” para viagens nacionais. Campo Obrigatório
			cTexto += Space(8)								&& 146/153 Reservado - Preencher com brancos
			cDescProd := SC6->C6_DESCRI
			nTam      := Len(cDescProd)
			cTexto += cDescProd + Space(50 - nTam)			&& 154/203 Descrição (nome) da Mercadoria ou Natureza da Carga. Campo Obrigatório.
			cTexto += "03"									&& 204/205 Operação de Transporte  //rever
															/*
															Vide lista de códigos abaixo.Campo
															Obrigatório
															Código
															01-Distribuição
															02-Coleta
															03-Entrega Direta
															04-Transferência
															05- Devolução
															06 - Outros
															*/
			cTexto += "06"									&& 206/207 Isenção de Seguro //rever
															/*
															Vide lista de códigos abaixo.Campo
															Obrigatório
															Código
															01-Sem Isenção
															02-Averbado Anteriormente
															03-Redespacho
															04-Tráfego Mútuo
															05-Seguro Próprio/DDR
															06-Outras Isenções
															07-Isenção RCFDC
															*/         
			//cTexto += Strzero(Val(cValbrut),15,2)			&& 208/222 Valor da Mercadoria Transportada para o documento informado.													
			cTexto += Strzero(Val(cValbrut),15,0)			&& 208/222 Valor da Mercadoria Transportada para o documento informado.													
			//cTexto += Strzero(Val(cVolume)	,15,4)			&& 223/237 Quantidade de Embalagens
			cTexto += Strzero(Val(cVolume)	,15,0)			&& 223/237 Quantidade de Embalagens
			cTexto += IIF(Alltrim(SF2->F2_ESPECI1) = "SACOS" , "SC", "CX")						&& 238/239 Tipo da Embalagem.Ex.:CX para caixas //rever
			//cTexto += Strzero(Val(cPBruto),15,4)			 && 240/254 Peso da Mercadoria
			cTexto += Strzero(Val(cPBruto),15,0)			 && 240/254 Peso da Mercadoria
			cTexto += Repli("0",19 ) //Strzero(0,15,4)		 && 255/269 Volume da Mercadoria (em metros cúbicos)//rever
			cTexto += Substr(DtoS(SF2->F2_EMISSAO),7,2) + "/" + Substr(DtoS(SF2->F2_EMISSAO),5,2) + "/" + Substr(DtoS(SF2->F2_EMISSAO),1,4) && 270/279 Data emissão da NF -Dd/mm/aaaa
			cTexto += SF2->F2_HORA + ":00"					 && 280/287 Hora da emissão - Hh:mm:ss
			cTexto += Space(1)								&& 288/288 Indicador Carga/Descarga (cobertura especial)
															//Preencher com “S” caso tenha cobertura Carga/Descarga. Deixar em //rever
															//branco caso não tenha esta cobertura 
			cTexto += Space(1)								&& 289/289 Preencher com “S” caso tenha cobertura de Içamento. Deixar em branco caso não tenha esta cobertura //rever
			cTexto += Space(1)								&& 290/290 Preencher com “S” caso tenhacobertura para Rodofluvial. Deixar em branco caso não tenha esta cobertura //rever
			cTexto += Space(1)								&& 291/291 Preencher com “S” caso a mercadoria seja Veículo
															// e realize a viagem sem estar embarcado em outro veículo.
															//Deixar em branco caso não tenha esta cobertura //rever
			cTexto += IIF(Alltrim(SF2->F2_TPFRETE) = "C" , '1', '2') && 292/292 - Tipo de frete 
																	/*Vide lista de códigos abaixo.
																	Código
																	1-CIF – Frete por conta do remetente
																	2-FOB – Frete por conta do
																	destinatário
																	3-Não Informado													
																	*/
			cCidade := SM0->M0_ESTCOB
			nTam    := Len(cCidade)															
			cTexto += cCidade + Space(50 - nTam)					&& 293/342 Nome da Cidade de Emissão do Conhecimento. //rever
			cTexto += SF2->F2_EST									&& 343/344 Sigla da UF de Emissão do Conhecimento.
			cPais := "BRASIL"
			nTam  := Len(cPais)
			cTexto += cPais + Space(30 - nTam)						&& 345/374 Nome do País de Emissão do Conhecimento. Fixo em “BRASIL” para viagens nacionais.
			cTexto += Space(76)										&& 375/450 Reservado - Preencher com Brancos
			cTexto +=LFTXT 
			SD2->(Dbskip())
		Enddo
		
		//////////////////
		//Fim - tipo = 20
		/////////////////
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Tipo - 21
		//Registro dos Transacionadores da Mercadoria e detalhe da viagem (tipo = 21): Deve ser gravado um registro para
		//cada pessoa física ou jurídica associada ao(s) documento(s) (Mercadoria Embarcada) lançado em item de destino. 
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		DbselectArea("SD2")
		SD2->(DBSETORDER(3))
		SD2->(DBSEEK(XFILIAL("SD2")+cF2NOTA ) )
		While !SD2->(EOF()) .AND. SD2->D2_FILIAL == xFilial("SD2") .and. Alltrim(SD2->D2_DOC) == Alltrim(cF2NOTA)	
		
			cTexto += "21"											&& 001/002 Tipo de registro - Fixo = 21. Campo Obrigatório
			cTexto += Repli("X",30)									&& 003/032 Número único da viagem.Campo Obrigatório  //rever
			cTexto += SD2->D2_ITEM									&& 033/036 Seqüência dos itens (0001 a 9999). (*)
			cTexto += Repli("X",15)									&& 037/051 Doc. Viagem, um ou mais itens por documento. (*) //rever
			cTexto += Repli("X",6) 									&& 052/057 Número do Conhecimento. (*)  //rever
			cTexto += Substr(SD2->D2_DOC,5,5)						&& 058/063 Número da Nota Fiscal. (*) //REVER
			cTexto += "04"											&& 064/065 Tipo de Transacionador  //rever
																	/*
																	Vide lista de códigos abaixo.
																	Campo Obrigatório
																	Código
																	01-Emitente
																	02-Remetente
																	03-Destinatário
																	04-Transportador
																	05-Consignatário
																	06-Redespachante
																	07-Local de Entrega
																	08-Local de Coleta
																	*/
			cTexto += "02"											&& 066/067 Tipo do Documento
																	/*
																	Vide lista de códigos abaixo.
																	Campo Obrigatório
																	Código
																	01-CNPJ
																	02-CPF
																	03-CUILT
																	04-CUIL
																	05-CIU
																	06-RUN
																	07-RUC
																	08-CIP
																	09-CIB
																	10-DNI
																	11-RNE
																	99-ODI (Outros Docs Internacionais)
																	*/
			cTexto += "123456789012345"								&& 068/082 Numero do Documento do Transacionador, sem edição. Ex: 084368648000135.Campo Obrigatório //rever
			cTexto += "12345678901234567890"						&& 083/102 Inscrição Estadual Numero da Inscrição Estadual do Transacionador.  //rever
			cTexto += Repli("X",50)									&& 103/152 - Nome do Transacionador //rever
			cTexto += Repli("X",50)									&& 153/202 Endereço do Transacionador //rever
			cTexto += Repli("X",30)									&& 203/232 Bairro do Transacionador //REVER
			cTexto += "00000000"									&& 233/240 CEP do Transacionador //rever
			cTexto += Repli("X", 50)								&& 241/290 Nome da Cidade do Transacionador.Campo Obrigatório //rever
			cTexto += "XX"											&& 291/292 Sigla da UF do Transacionador Campo Obrigatório //rever
			cPais := "BRASIL"
			nTam  := Len(cPais)
			cTexto += cPais + Space( 30 - nTam )					&& 293/322 Nome do País do Transacionador. Fixo em “BRASIL” para viagens nacionais.Campo Obrigatório 
			cTexto += Repli("9",30)									&& 323/352 Telefone/Fax do Transacionador //rever 
			cTexto += Substr(DTOS(SF2->F2_PREVCHG),7,2) + "/" + Substr(DTOS(SF2->F2_PREVCHG),5,2) + "/" + Substr(DTOS(SF2->F2_PREVCHG),1,4)	&& 353/362 Data Chegada no destino Dd/mm/aaaa - Somente informar no 
																	//caso de Tipo de Vinculo igual a Destinatário. //REVER
			cTexto += "00:00:00"									&& 363/370 Hh:mm:ss - Hora Chegada no destino Somente informar no caso 
																	//de Tipo de Vinculo igual a Destinatário. //rever
			cTexto += Space(80)										&& Reservado - Preencher com Brancos
			
			
			nTotVal += SF2->F2_VALBRUT
			cTexto +=LFTXT 
			SD2->(Dbskip())
		ENDDO
		DbselectArea("SD2")
		nCta10++                 //contador de registros tipo = 10 (notas)
		SF2->(Dbskip())
	Enddo
	///////////////
	//Fim - tipo 21
	///////////////

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	//Tipo 99
	//Registro de Totais (tipo = 99): Registro Obrigatório, utilizado para conferir o recebimento do arquivo na importação.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	cTexto += "99"											&& 001/002 Tipo-Reg - Fixo = 99
															//Campo Obrigatório
	cTexto += Strzero(nCta10,9)								&& 003/011 Quantidade Total de Registros Tipo 10
															//Para Conferência de Transmissão
															//Campo Obrigatório

	nTotGer := 	(nTotVal * 100)													
	cTotGer := TRANSFORM(nTotGer,"@X")
	//cTexto += Strzero(Val(cTotGer), 15,2)						&& 012/026 Somatório dos Valores Totais	Embarcados (campo 12) do Registro
	cTexto += Strzero(Val(cTotGer), 15,0)						&& 012/026 Somatório dos Valores Totais	Embarcados (campo 12) do Registro
															//Tipo 10
															//Campo Obrigatório
	cTexto += "04"                                          && 027/028 Versão do layout - Versão do Arquivo Fixo = “04” Campo Obrigatório
	cTexto += Space(422)									&& 029/450 Reservado Preencher com Brancos
	cTexto +=LFTXT 		
	///////////////
	//Fim - tipo 99
	///////////////
	
	
	
													
    /*
	
	DBSELECTAREA("SD2")
	SD2->(DBSETORDER(3))
	IF SD2->(DBSEEK(XFILIAL("SD2")+cNota , .F. ) )	
		DO WHILE !SD2->(EOF()) .AND. (SD2->D2_DOC == cNota)
			nItens ++	
		    SD2->(DBSKIP())
		ENDDO
	ENDIF
	cItens := TRANSFORM(nItens,"@X")
	cCFOP := SUBSTR(fCFOP(SF2->F2_DOC),1,4)
   
	                           
	cTexto +="AE1"                                        && 01/001 - identificação do tipo do registro ex.: "AE1"
	cTexto += SF2->F2_DOC+"000"+ALLTRIM(SF2->F2_SERIE)    && 02/80  - número da nf + série com 4 dígitos
	cTexto += ALLTRIM(SUBSTR(DTOS(SF2->F2_EMISSAO),3,6))  && 04/133 - data de emissão da nf
	cTexto += STRZERO(VAL(cItens),3,0)                    && 05/70  - qtde de itens por nf
	
	cTexto += STRZERO(VAL(cValbrut),17,0)                 && 06/71  - valor total da nf
	cTexto += "2"                                         && 07/22  - qtde. de casas decimais
	cTexto += cCFOP + Space(1)                            && 08/93  - código fiscal da operação (cfop) com 5 dígitos
	cTexto += STRZERO(VAL(cSomaICM),17,0)                 && 09/380 - valor total do icm
	
	DBSELECTAREA("SE1")
	SE1->(DBSETORDER(19))
	IF SE1->(DBSEEK(XFILIAL("SE1")+cNota , .F. ) )	
		DO WHILE !SE1->(EOF()) .AND. (SE1->E1_NUM == cNota )
		    IF SE1->E1_TIPO = 'NF'
		    	cDataVenc := SUBSTR(DTOS(SE1->E1_VENCTO),3,6)  
		    	cTexto += cDataVenc						  && 10/85  - data de vencimento da nf
		    ENDIF
		    SE1->(DBSKIP())
		ENDDO
	ENDIF
		
	//cDataVenc := fVenci(SF2->F2_DOC)
	
	//cTexto += SUBSTR(DTOS(cDataVenc),3,6)
	cTexto += "02"                                        && 11/193 - espécie da nf (02: simples ou fatura) ver lay-out
	cTexto += STRZERO(VAL(cValIPI),17,0)                  && 12/277 - valor total do ipi
	cTexto += "540"									      && 13/002 - código da fábrica para entrega
	cTexto += SUBSTR(DTOS(SF2->F2_EMISSAO),3,6)		      && 14/276 - Previsão de entrega da nf
	cTexto += "0818"			                          && 15/23  - período de entrega representado pela hora inicial/final
	DBSELECTAREA("SX5")
	SX5->(DBSETORDER(1))
	IF SX5->(DBSEEK(xFILIAL("SX5")+'13'+cCFOP))
		cDescOPER := SX5->X5_DESCRI
	ENDIF
	cTexto += SUBSTR(cDescOPER,1,15)				  	  && 16/276 - descrição da natureza da operação
	cTexto += ALLTRIM(SUBSTR(DTOS(SF2->F2_DTEXP),3,6))	  && 14/257 - dt. embarque da mercadoria (data expedição)
	cTexto += LEFT(SF2->F2_HORA,2)                        
	cTexto += RIGHT(SF2->F2_HORA,2)					  && 18/458 - Hora embarque da mercadoria (hora expedição)
	cTexto += Space(3)									  && 19/999 - espaço de 3
	cTexto +=LFTXT 
	nContaReg++
	//-- fim do AE1
	
	//--NF2 - Cabeçalho da NF - complemento	
	cTexto += "NF2"                          			  && 01/001 - identificação do tipo do registro ex.: "NF2"
	cTexto += STRZERO(VAL( cSomaFRESEG ),12,0)            && 02/94  - valor total despesas ex.: frete, seguro, etc...
	cTexto += STRZERO(VAL(cVALFRETE),12,0)                && 03/278 - valor do frete
	cTexto += STRZERO(VAL(cValSEG),12,0)				  && 04/279 - valor do seguro
	cTexto += STRZERO(VAL(cDescNF),12,0)				  && 05/280 - valor do desconto na nf
	
	DBSELECTAREA("SD2")
	SD2->(DBSETORDER(3))
	IF SD2->(DBSEEK(XFILIAL("SD2")+cNota , .F. ) )	
		SD2->(DBSETORDER(10))
		DO WHILE !SD2->(EOF()) .AND. ( SD2->D2_DOC == cNota )
			nBsICMTot += SD2->D2_BASEICM
			nDescZFR  += SD2->D2_DESCZFR
			SD2->(DBSKIP())
		ENDDO
	ENDIF
    cBsICMTot := TRANSFORM(nBsICMTot, "@X")
	cTexto += STRZERO(VAL(cBsICMTot),12,0)			  		&& 06/436 - base cálculo icms
	cDescZFR  := TRANSFORM(nDescZFR,"@X")
	cTexto += STRZERO(VAL(cDescZFR),12,0)			  		&& 07/462 - valor desc. zona franca					
	cTexto += cNota									  		&& 08/501 - número da nf venda
	cTexto += ALLTRIM(SUBSTR(DTOS(SF2->F2_EMISSAO),3,6))    && 09/502 - data da nf venda
	cTexto += "000"+ALLTRIM(SF2->F2_SERIE)					&& 10/503 - série da nf venda com 4 dígitos
	cTexto += "123"											&& 11/530 - código da fábrica transmissora
	cTexto += cCFOP + Space(1)								&& 12/9999- código fiscal da operação (cfop) com 5 dígitos	
	cTexto += LFTXT
	nContaReg++ 
	//--Fim do NF2
	
	
	//NF5 - DADOS COMPLEMENTARES DA NF
	cTexto += "NF5"											&& 01/001 - identificação do tipo do registro ex.: "NF5"
	cTexto += cCFOP + Space(6)								&& 02/518 - código da natureza da operação
	cTexto += STRZERO(VAL(cAliqIR),4,0)						&& 03/519 - alíquota do IR
	cTexto += STRZERO(VAL(cBaseIR),17,0)					&& 04/520 - valor base IR
	cTexto += STRZERO(VAL(cValIR),17,0)						&& 05/521 - valor do IR	
	
	DO WHILE !SD2->(EOF()) .AND. (SF2->F2_DOC == SD2->D2_DOC)		
		nAliqISS := SD2->D2_ALIQISS            				// A Alíquota de ISS em geral é uma só para todos itens.
		SD2->(DBSKIP())
	ENDDO
    cAliqISS := TRANSFORM(nAliqISS,"@X")
	cTexto += STRZERO(VAL(cAliqISS),4,0)						&& 06/522 - Aliq. ISS
	
	nBaseISS := SF2->F2_BASEISS
	cBaseISS := TRANSFORM(nBaseISS,"@X")
	cTexto += STRZERO(VAL(cBaseISS),17,0)						&& 07/523 - Base ISS
	
	nValISS := SF2->F2_VALISS								
	cValISS := TRANSFORM(nValISS,"@X")
	cTexto += STRZERO(VAL(cValISS),17,0)						&& 08/524 - Vlr. ISS		
	
	nValBseINS := SF2->F2_BASEINS
	cValBseINS := TRANSFORM(nValBseINS,"@X")
	cTexto += STRZERO(VAL(cValBseINS),17,0)					&& 09/525 - Vlr. base INSS
	
	nValINSS := SF2->F2_VALINSS
	cValINSS := TRANSFORM(nValINSS,"@X")
	cTexto += STRZERO(VAL(cValINSS),17,0)					&& 10/526 - Vlr. INSS
	cTexto += Space(5)
	cTexto += LFTXT
	nContaReg++	
	//--Fim do NF5
	
	
	//--AE2 - Dados do(s) item(ns)
	//cTexto +="AE2"
	DBSELECTAREA("SD2")
	SD2->(DBSETORDER(3))
	IF SD2->(DBSEEK(XFILIAL("SD2")+cNota , .F. ) )	
		SD2->(DBSETORDER(10))
		DO WHILE !SD2->(EOF()) .AND. ( SD2->D2_DOC == cNota )
			cTexto +="AE2"   									&& 01/001 - identificação do tipo do registro ex.: "AE2"
			cTexto += "0"										&& para representar o item com 3 dig. acrescentei zero à frente
			cTexto += TRANSFORM(SD2->D2_ITEM, "@X")				&& 02/73  - número do item da NF
			cTexto += STRZERO(VAL(cPedCli),12)					&& 03/09  - número do pedido do cliente
			
			cNUMPED2  := SD2->D2_PEDIDO
			cITEMD2   := SD2->D2_ITEMPV
			cCODPROD2 := SD2->D2_COD			
			
			DBSELECTAREA("SC6")
			SC6->(DBSETORDER(1))
			IF SC6->(DBSEEK(XFILIAL("SC6")+cNUMPED2+cITEMD2+cCODPROD2, .F. ) )			
				//nPosDesc1 := At("- Cod.", SC6->C6_DESC1 )
				//nPosDesc1 := At("- COD.", SC6->C6_DESC1 )
				nPosDesc1 := At("- C", SC6->C6_DESCRI )
				
				If nPosDesc1 <> 0
					nPosDesc1 := nPosDesc1 + 7
					cProdCli := SUBSTR(SC6->C6_DESCRI,nPosDesc1,30)
				Else
					cProdCli := SC6->C6_PRODUTO
				Endif
				
				//cCodProd := SD2->D2_COD                             
			ELSE
				cProdCli := SC6->C6_PRODUTO			
			ENDIF
			//cTexto += PADR(cCodProd,30)                         && com 30 dígitos, acrescentei espaços à direita
			cTexto += PADR(cProdCli,30)							  && 04/354 - código do item
			nQTNF  := SD2->D2_QUANT * 100
			cQTNF  := TRANSFORM(nQTNF, "@E")
			cTexto += STRZERO(VAL(cQTNF),9)						&& 05/122 - qtde. item na nf
			//cTexto += SD2->D2_UM
			cTexto += "01"										&& 06/126 - unidade de medida da nf (01 = unitário... etc)
			SB1->(DBSETORDER(1))
			IF SB1->(DBSEEK(XFILIAL("SB1")+SD2->D2_COD, .F.) )
				cNCM := ALLTRIM(SB1->B1_POSIPI)
			ENDIF
			If !Empty(cNCM)
				cTexto += cNCM
				cTexto += Space(2)
			Else
				cTexto += Space(10) 							&& 07/98  - class.fiscal
			Endif 
			
			nIPI   := (SD2->D2_IPI * 100)
			cIPI   := TRANSFORM(nIPI, "@X")
			cTexto += STRZERO(VAL(cIPI),4,0) 					&& 08/99  - aliq. IPI	
			
			//nVALUNINF := (SD2->D2_PRCVEN * 100)
			nVALUNINF := ((SD2->D2_TOTAL / SD2->D2_QUANT) * 100000) 
			cVALUNINF := TRANSFORM(nVALUNINF, "@X")
			cTexto    += STRZERO(VAL(cVALUNINF),12,0)			&& 09/100 - vlr. unitário item, pede 5 casas decimais
		
			cTexto    += STRZERO(VAL(cQTNF),9) 					&& 10/106 - qtd. do item na nf
		   //	cTexto    += SD2->D2_UM		
		   cTexto += '01'										&& 11/110 - unidade de medida segundo lay-out (01 = PC...etc)
		   cTexto += STRZERO(VAL(cQTNF),9)						&& 12/118 - qtd. da unid. de compra		
			
			SC6->(DBSETORDER(4))
			IF SC6->(DBSEEK(XFILIAL("SC6")+cNota, .F. ) )
				cC6UM      := ALLTRIM(SC6->C6_UM)						
				//nC6DESTOT := (SC6->C6_DESTOT * 100) 			&& não precisa pq na NF não aparece o desconto					
				//nC6VALDESC := ((SC6->C6_PRUNIT * SC6->C6_QTDVEN * (SC6->C6_PORIPI / 100 + 1) * SC6->C6_DESTOT / 100) *100)
			ENDIF
		
			cTexto += cC6UM										&& 13/121 - unidade de medida de compra
			cTexto += "X"                                       && 14/74  - código do tipo de fornecimento (X = Outros...ver lay-out)
			
			//cC6DESTOT := TRANSFORM(nC6DESTOT,"@X")            && não precisa pôr o desconto a Atos não destaca na NF
			//cC6VALDESC := TRANSFORM(nC6VALDESC,"@X")          && idem acima   
			//cTexto += STRZERO(VAL(cC6DESTOT),4,0)				&& 15/86  - % de desconto
			
			cTexto += STRZERO(0,4,0)							&& 15/86  - % de desconto - zerado
			//cTexto += STRZERO(VAL(cC6VALDESC),11,0)           && 16/283 - vlr. total desconto
			cTexto += STRZERO(0,11,0)						&& 16/283 - vlr. total desconto - zerado
			cTexto += "bbbb"									&& 17/283 -  alteração téc. do item - b=brancos
			cTexto += Space(1)									&& 18/9999- espaço de 1
			cTexto += LFTXT			
			nContaReg++
			
			// AE4 - Incluir aqui o AE4 P/ intercalar com AE2
			cTexto +="AE4"  									&& 01/001 - identificação do tipo do registro ex.: "AE4"
			nPICM   := (SD2->D2_PICM * 100)
			cPICM   := TRANSFORM(nPICM, "@X")               	
			cTexto += STRZERO(VAL(cPICM),4,0)					&& 02/95  - % DO ICM  
			
			nBASEICM := (SD2->D2_BASEICM * 100)                 
			cBASEICM := TRANSFORM(nBASEICM, "@X")
			cTexto += STRZERO(VAL(cBASEICM),17,0)				&& 03/97 - BASE DO ICM 
			
			nVALICM := (SD2->D2_VALICM * 100)                    
			cVALICM := TRANSFORM(nVALICM, "@X" )
			cTexto += STRZERO(VAL(cVALICM),17,0)                && 04/96 - vlr. ICM  
			
			nVALIPI := (SD2->D2_VALIPI * 100)                       
			cVALIPI := TRANSFORM(nVALIPI, "@X" )                
			
			cTexto += STRZERO(VAL(cVALIPI),17,0)				&& 05/369 - vlr. IPI  
			cTexto += SUBSTR(SD2->D2_CLASFIS,1,2)               && 06/381 - situação tributária com 2 díg.
			cTexto += Space(30)									&& 07/124 - número do desenho do item
			cTexto += Space(6)	   								&& 08/125 - Data validade do desenho do item
			cTexto += Space(13)									&& 09/409 - Número do pedido para revenda
			
			nPesoLiq := SD2->D2_PESO
			cPesoLiq := TRANSFORM(nPesoLiq,"@X")
			cTexto += STRZERO(VAL(cPesoLiq),5,0)                && 10/437 - Peso líquido  
			cTexto += '2'										&& 11/438 - fator de multiplicação - 2 = prç unit x 100
			
			nD2TOTAL := (SD2->D2_TOTAL * 100)
			cD2TOTAL := TRANSFORM(nD2TOTAL,"@X")
			cTexto += STRZERO(VAL(cD2TOTAL),12,0)				&& 12/439 - preço total da mercadoria
			cTexto += SUBSTR(SD2->D2_CLASFIS,1,1)				&& 13/440 - situação tributária - 1o. dígito
			//cTexto += Space(32)
			cTexto += LFTXT
			nContaReg++			
			//--Fim do AE4
		    SD2->(DBSKIP())
		ENDDO	
	ENDIF
	//--Fim do AE2  / AE4
	
	/*
	//--AE4 - Complemento dos itens da NF.
	DBSELECTAREA("SD2")
	SD2->(DBSETORDER(3))
	IF SD2->(DBSEEK(XFILIAL("SD2")+cNota , .F. ) )	
		SD2->(DBSETORDER(10))
		DO WHILE !SD2->(EOF()) .AND. ( SD2->D2_DOC == cNota )
			cTexto +="AE4"  									&& 01/001 - identificação do tipo do registro ex.: "AE4"
			nPICM   := (SD2->D2_PICM * 100)
			cPICM   := TRANSFORM(nPICM, "@X")               	
			cTexto += STRZERO(VAL(cPICM),4,0)					&& 02/95  - % DO ICM  
			
			nBASEICM := (SD2->D2_BASEICM * 100)                 
			cBASEICM := TRANSFORM(nBASEICM, "@X")
			cTexto += STRZERO(VAL(cBASEICM),17,0)				&& 03/97 - BASE DO ICM 
			
			nVALICM := (SD2->D2_VALICM * 100)                    
			cVALICM := TRANSFORM(nVALICM, "@X" )
			cTexto += STRZERO(VAL(cVALICM),17,0)                && 04/96 - vlr. ICM  
			
			nVALIPI := (SD2->D2_VALIPI * 100)                       
			cVALIPI := TRANSFORM(nVALIPI, "@X" )                
			
			cTexto += STRZERO(VAL(cVALIPI),17,0)				&& 05/369 - vlr. IPI  
			cTexto += SUBSTR(SD2->D2_CLASFIS,1,2)               && 06/381 - situação tributária com 2 díg.
			cTexto += Space(30)									&& 07/124 - número do desenho do item
			cTexto += Space(6)	   								&& 08/125 - Data validade do desenho do item
			cTexto += Space(13)									&& 09/409 - Número do pedido para revenda
			
			nPesoLiq := SD2->D2_PESO
			cPesoLiq := TRANSFORM(nPesoLiq,"@X")
			cTexto += STRZERO(VAL(cPesoLiq),5,0)                && 10/437 - Peso líquido  
			cTexto += '2'										&& 11/438 - fator de multiplicação - 2 = prç unit x 100
			
			nD2TOTAL := (SD2->D2_TOTAL * 100)
			cD2TOTAL := TRANSFORM(nD2TOTAL,"@X")
			cTexto += STRZERO(VAL(cD2TOTAL),12,0)				&& 12/439 - preço total da mercadoria
			cTexto += SUBSTR(SD2->D2_CLASFIS,1,1)				&& 13/440 - situação tributária - 1o. dígito
			//cTexto += Space(32)
			cTexto += LFTXT
			nContaReg++	
		    SD2->(DBSKIP())
		ENDDO
	ENDIF	
	//nContaReg++
	//--Fim do AE4
	*/
	
	//--AE5 - DADOS DA ETIQUETA
	//--Fim do AE5 - não temos etiqueta.
	
	//--AE7 - COMPLEMENTO DADOS ITEM
	/*											
	DBSELECTAREA("SD2")
	SD2->(DBSETORDER(3))
	IF SD2->(DBSEEK(XFILIAL("SD2")+cNota , .F. ) )	
		SD2->(DBSETORDER(10))
		DO WHILE !SD2->(EOF()) .AND. ( SD2->D2_DOC == cNota )
	    	cTexto += "AE7"									&& 01/001 - identificação do tipo do registro ex.: "AE7"					
	    	nDscZFRTot := SD2->D2_DESCZFR
	    	cDscZFRTot := TRANSFORM(nDscZFRTot,"@X")
	    	cTexto += STRZERO(VAL(cDscZFRTot),12,0)			&& 02/460 - valor desconto zona franca por item
	    	
	    	cTexto += SUBSTR(SD2->D2_CF,1,4) + Space(1)     && 03/461 - cfop item com 5 díg.
	    	
	    	nD2ICMSRET := SD2->D2_ICMSRET
	    	cD2ICMSRET := TRANSFORM(nD2ICMSRET,"@X")
	    	cTexto += STRZERO(VAL(cD2ICMSRET),17,0)			&& 04/528 - valor do icms subst. tributária
	    	
	    	cTexto += Space(16)								&& 05/529 - complemento pto. uso
	    	cTexto += Space(14)								&& 06/16  - qtde. entrega / embarque
	    	
	    	nD2PESO := SD2->D2_PESO
	    	cD2PESO := TRANSFORM(nD2PESO,"@X")
	    	cTexto += STRZERO(VAL(cD2PESO),5,0)				&& 07/592 - peso bruto do item
	    	cTexto += Space(56)
	    	cTexto += LFTXT	
	    	nContaReg++
	    	SD2->(DBSKIP())
	    ENDDO
	    //nContaReg++
	ENDIF    	
	//--Fim do AE7    	
	
	/*
	//--AE8 - COMPLEMENTO DADOS DO ITEM - OPCIONAL
	cTexto += "AE8"                  						&& 01/001 - identificação do tipo do registro ex.: "AE8"					
	*/
	/*
	//--AE3 - CUSTOS AGREGADOS / DADOS ADICIONAIS DE COMERCIALIZAÇÃO  
	SA1->(DBSETORDER(1))
	SA1->(DBSEEK(XFILIAL("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA , .F. ) )
	
	cTexto += "AE3"											&& 01/001 - identificação do tipo do registro ex.: "AE3"					
	cTexto += ALLTRIM(SA1->A1_CGC)                          && 02/355 - identificação do local de faturamento - cnpj cliente
	cTexto += ALLTRIM(SA1->A1_CGC)							&& 03/356 - identificação do local de cobrança    - cnpj cliente
	cTexto += ALLTRIM(SA1->A1_CGC)							&& 04/357 - identificação do local de entrega     - cnpj cliente
	cTexto += Space(4)										&& 05/445 - identificação do tipo de transporte
	cTexto += Space(79)
	cTexto += LFTXT
	nContaReg++
	//-- Fim do AE3
	
	//--TE1 - TEXTO LIVRE
	cTexto += "TE1"											&& 01/001 - identificação do tipo do registro ex.: "TE1"					
	cTexto += SUBSTR(ALLTRIM(SF2->F2_OBS),1,40)          && 02/29  - texto livre informático
	cTexto += SUBSTR(ALLTRIM(SF2->F2_OBS),101,40)		&& 03/29  - texto livre informático
	cTexto += SUBSTR(ALLTRIM(SF2->F2_OBS),141,40)		&& 04/29  - texto livre informático
	cTexto += Space(5)
	cTexto += LFTXT
	nContaReg++
	//--Fim do TE1
	
	//--FTP - Final da Transmissão
	cTexto +="FTP"											&& 01/001 - identificação do tipo do registro ex.: "FTP"					
	nContaReg++
	cContaReg := TRANSFORM(nContaReg,"@X")
	cTexto += cSequencia									&& 02/36  - número de controle da transmissão
	cTexto += STRZERO(VAL(cContaReg),09)					&& 03/39  - qtd. registros na transação
	cTexto += STRZERO(VAL(cValbrut),17,0)                   && 04/245 - número total de valores - coloquei o f2_valbrut q é o total da nota
	cTexto += "C"											&& 05/201 - categoria da operação D=débito / C=crédito
	cTexto += Space(93)
	cTexto += LFTXT	
	//--Fim do FTP	
	  */
Endif
//nSequencia := nSequencia + 1
//PutMV("AT_SEQTXT",StrZero(nSequencia,5)) 

U_RESTAMB( aAmb )
dbselectarea( cAlias )
 MsgInfo("Arquivo Gerado OK ! :) " )	
Return( cTexto )    


//***********************************
Static Function fCFOP(cNota)
//***********************************

Local aAreaAtu	:= GetArea()
Local cCFOP		:= Space(12)
Local cQry		:= " "
Local cCF		:= " "

cQry	:= "SELECT DISTINCT SD2.D2_CF AS CFOPS "
cQry	+= " FROM "+RetSqlName("SD2")+" SD2 (NOLOCK)"
cQry	+= " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
cQry	+= " AND SD2.D2_DOC = '"+cNota+"'"
cQry	+= " AND SD2.D_E_L_E_T_ <> '*'"

If Select("TMPCFO") > 0
	dbSelectArea("TMPCFO")
	dbCloseArea()
EndIf
TCQUERY cQry NEW ALIAS "TMPCFO"
dbSelectArea("TMPCFO")
//If TMPCFO->CFOPS > 0
	cCF	:= TMPCFO->CFOPS
//EndIf
dbSelectArea("TMPCFO")

dbCloseArea()

RestArea(aAreaAtu)

Return(cCF)

//------------------------------------------------------------------------

//*******************************
Static Function fVenci(cNota)    
//*******************************

Local aAreaAtu	:= GetArea()
Local cCFOP		:= Space(12)
Local cQryVCT	:= " "
Local cVencto   := ""

cQryVCT	:= "SELECT SE1.E1_VENCTO AS VENCTO "
cQryVCT	+= " FROM "+RetSqlName("SE1")+" SE1 (NOLOCK)"
cQryVCT	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
cQryVCT	+= " AND SE1.E1_NUM = '"+cNota+"'"
cQryVCT	+= " AND SE1.D_E_L_E_T_ <> '*'"

If Select("TMPVCT") > 0
	dbSelectArea("TMPVCT")
	dbCloseArea()
EndIf
TCQUERY cQryVCT NEW ALIAS "TMPVCT"
dbSelectArea("TMPVCT")

//If TMPVCT->VENCTO > 0
cVencto	:= TMPVCT->VENCTO
//EndIf

dbSelectArea("TMPVCT")
dbCloseArea()

RestArea(aAreaAtu)

Return(cVencto)


//**---------------------------------------**
//       USER function MeuMail
//**---------------------------------------**
USER function MeuMail( _cRemet, _cDest, _cCC, _cAssunto, _cBody, cAnexo )


local _cSerMail		   := alltrim(GetMV("MV_RELSERV"))
local _cDe     		   := alltrim(GetMV("MV_RELACNT"))
local _cSenha		   := alltrim(GetMV("MV_RELPSW"))
local _lEnviado		   := .F.
local _lConectou	   := .F.
local _cMailError	   := ""
Local cAnexos          := ""
Local cPath            := "\Com\"

cAnexos := cPath + cAnexo
// Conecta ao servidor de email
CONNECT SMTP SERVER _cSerMail ACCOUNT _cDe PASSWORD _cSenha Result _lConectou

if !(_lConectou)
	// Se nao conectou ao servidor de email, avisa ao usuario
	GET MAIL ERROR _cMailError
	MsgBox("Nao foi possivel conectar ao Servidor de email."+chr(13)+chr(10)+;
	"Procure o Administrador da rede."+chr(13)+chr(10)+;
	"Erro retornado: "+_cMailError)
	
else
	
	SEND MAIL FROM _cRemet ;
	To _cDest ;
	Cc _cCc ;
	SUBJECT	_cAssunto ;
	Body _cBody FORMAT TEXT;
	ATTACHMENT cAnexos;			//ATTACHMENT aAnexos[1];	
	RESULT _lEnviado
	
	
	if !(_lEnviado)
		GET MAIL ERROR _cMailError
		MsgBox("Nao foi possivel enviar o email."+chr(13)+chr(10)+;
		"Procure o Administrador da rede."+chr(13)+chr(10)+;
		"Erro retornado: "+_cMailError)
	else
	    MsgInfo("E-Mail enviado com sucesso!")
		If Type("_oDlg") <> "U"
			Close(_oDlg)
		EndIf
	endif
	
	DISCONNECT SMTP SERVER
	
endif

return _lConectou .and. _lEnviado           
//*****************************************************************