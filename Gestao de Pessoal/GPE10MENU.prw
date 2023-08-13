#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

**************************
User Function GPE10MENU() 
**************************

aAdd(aRotina, { "Imprime.Docs", "U_fRHDOCS()", 0, 7, 0, Nil })

//Alert("Passou pelo GPE10MENU")

Return(Nil)

************************
User Function fRHDOCS() 
************************

Local cNomeFun  := SRA->RA_NOME
Local dDataNasc := SRA->RA_NASC
Local cEndereco := SRA->RA_ENDEREC                
Local cBairro   := SRA->RA_BAIRRO
Local cCidade   := SRA->RA_MUNICIP
Local cUF       := SRA->RA_ESTADO
Local cCarteira := SRA->RA_NUMCP
Local cSerie    := SRA->RA_SERCP
Local nSalario  := SRA->RA_SALARIO
Local cMat      := SRA->RA_MAT 
Local cNaciona  := SRA->RA_NACIONA
Local cCPF      := SRA->RA_CIC
Local cGenero   := SRA->RA_SEXO
Local cRG       := SRA->RA_RG
Local cMae      := SRA->RA_MAE
Local cMunNat   := SRA->RA_MUNNAT  //MUNICÍPIO NASCIMENTO
Local cUFNat    := SRA->RA_NATURAL   // UF NASCIMENTO
Local cCodNAC   := SRA->RA_NACIONA // CÓDIGO DA NACIONALIDADE
Local cUFCTPS   := SRA->RA_UFCP    //UF da CTPS
Local cUFRG     := SRA->RA_RGUF      //UF DO RG
Local cTitElei  := SRA->RA_TITULOE   //TITULO DE ELEITOR 
Local cComplem  := SRA->RA_COMPLEM   //COMPLEMENTO DO ENDEREÇO
Local dDTRG     := SRA->RA_DTRGEXP   //DT EMISSÃO RG
Local cNacional := ""
Local cFuncao   := ""
Local cDataExtenso := ""
Local aDados    := {} 
Local cDataExtenso := ""
Local cMailTo   := ""
Local aUsu      := {}
Local cUsu      := "" 
Local cEmailUsr := ""
 
Private cPerg       := "GPR009" 
Private oProcess
Private oHtml

cDataExtenso := alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) )

Aadd( aDados, { cNomeFun, cNacional, cFuncao, dDataNasc, cEndereco, cBairro, cCidade, cUF, cCarteira, cSerie, nSalario, cDataExtenso,;
cMat, cCPF, cGenero, cRG, cMae, cMunNat, cUFNat, cCodNAC, cUFCTPS, cUFRG, cTitElei, cComplem, dDTRG } )

PswOrder(1)
If PswSeek( __CUSERID , .T. )  
   aUsu   := PSWRET() 				
   cUsu   := Alltrim( aUsu[1][2] )  
   //cNomeUsr:= Alltrim( aUsu[1][4] )  
   cEmailUsr:= Alltrim( aUsu[1][14] )
   //cDeptoUsr:= Alltrim( aUsu[1][12] )
Endif
cMailTo := cEmailUsr

pergunte(cPerg,.T.)
//FR - FLÁVIA ROCHA - 05/07/12 - ALTERAÇÃO REALIZADA:
//SOMENTE A OPÇÃO PIS SERÁ IMPRESSA NESTE P.E.
/*
	opções:
	1 - contrato experiência
	2 - aditivo ao contrato de trabalho
	3 - PIS
	4 - Declaração do VT
	5 - Termo responsabilidade
*/
//OS DEMAIS DOCUMENTOS ESTÃO NA INTEGRAÇÃO WORD

//If MV_PAR01 = 1 .or. MV_PAR01 = 2 .or. MV_PAR01 = 3 .or. MV_PAR01 = 4 .or. MV_PAR01 = 5
//	U_GPER009( aDados, MV_PAR01 )
//Endif	

If MV_PAR01 = 3   //PIS
	U_GPER009( aDados, MV_PAR01 )
Else
	MsgInfo("Para Este Documento, Favor Utilizar a Opção: ATUALIZAÇÕES >> INTEGRAÇÕES >> WORD - Obrigado.")
Endif	


Return