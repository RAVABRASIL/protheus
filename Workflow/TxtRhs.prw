#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "


*************

User Function TxtRhs()

*************

If Select( 'SX2' ) == 0
  //RAVA EMB
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "TxtRhs" Tables "Z57"
  sleep( 5000 )
  conOut( "Programa TxtRhs na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa TxtRhs sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf

conOut( "Finalizando programa TxtRhs em " + Dtoc( DATE() ) + ' - ' + Time() )

Return 


*************

Static Function  Exec()

*************

//local cCaminho := 'D:\Protheus11\Protheus_Data\system\rhs\'  

local cStartPath := GetSrvProfString("Startpath","")
local aCampos:={{'','','','','','','','','','','','','','','','','','','','','','',''}}

cCaminho :=cStartPath+"rhs\"
aFiles := DIRECTORY(cCaminho+"*.txt")

For nArq := 1 To Len(aFiles)
	NomeArq:=alltrim(aFiles[nArq,1])             
	cFile := AllTrim(cCaminho+aFiles[nArq,1])	
	if ! jaLeu('RHS',NomeArq)
		cFile := AllTrim(cCaminho+aFiles[nArq,1])
		nHdl    := fOpen(cFile,0) 
		If nHdl <> -1	       
			nTamFile := fSeek(nHdl,0,2)
			fSeek(nHdl,0,0)
			cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			original:= Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			nLidos := fRead(nHdl,@cBuffer,nTamFile)  
		    @original:=@cBuffer
		    aCampos:={}
		    @cBuffer:=alltrim(@cBuffer) 
		    For _Y:=1 to len(@cBuffer)    
		       if ! empty(Substr(@cBuffer,1,at('|',@cBuffer)-1))
			       Aadd( aCampos, {'','','','','','','','','','','','','','','','','','','','','','',''} )       
			       For _X:=1 to len(acampos[_Y])     
			          acampos[_Y][_X]:=alltrim(strtran(Substr(@cBuffer,1,at('|',@cBuffer)-1),'"' ,''))
			          @cBuffer:=Substr(@cBuffer,at('|',@cBuffer)+1,len(@cBuffer))
			       Next _X
			   else
		         exit
		       endif
		    Next _Y
			fClose(nHdl) 
			xfile:=Fcreate(cCaminho+'Salvo\'+nomearq,2)
            fClose(xfile)                      	
            salvo:=fopen(cCaminho+'Salvo\'+nomearq,2)
            FWRITE(salvo,@original,len(@original))      
            fClose(salvo)     
			if FERASE(cFile)<>-1
		       fsalva(aCampos,NomeArq,'RHS')
			endif
		else
		    If Select( 'SX2' ) == 0 
		       conOut( "O arquivo de nome "+cFile+" nao pode ser aberto! " ) 
		    else
		       MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! ","Atencao!") 
		    EndIf
		    xfile:=Fcreate(cCaminho+'Erro\'+nomearq,2)
            fClose(xfile)
		EndIf
	else
	    If Select( 'SX2' ) == 0 
		   conOut( "O arquivo de nome "+cFile+" nao pode ser aberto! " ) 
	    else
	       MsgAlert("O arquivo de nome "+NomeArq+" Já Lido.","Atencao!")
	    EndIf   
        FERASE(cFile)	    
	Endif
Next

Return 

***************

Static function fsalva(aCampos,NomeArq,cEmpresa)

***************
/*                                                                                                                                                                       NOVA                   

   1       2      3       4       5         6         7          8    9    10       11   12   13    14      15      16      17        18      19       20     21   22   23
PRODNUM|VERSAO|SITUACAO|ORGAO|COMPLORGAO|ENDERECO|COMPLENDERECO|FONE|FAX|OBSORGAO|CIDADE|UF|EDITAL|TPPRAZO|DTPRAZO|HPRAZO|VLESTIMADO|OBJETO|PREDITAL|BANCOPG|OBS|OBSORG|URL|

5432424|8173|"Normal"|"Associacao Nossa Senhora da Saude"|"Hospital Regional do Jurua"|"www.publinexo.com.br"|""|"(68) 3224-3811"|""|""|"Rio Branco"|"AC"|"PE/9/2014"|"Prazo para Abertura"|"13/03/2014"|"09:20"|"0.00"|"AQUISICAO DE MATERIAL HOSPITALAR."|""|""|""|""|
*/


For _Z:=2 to len(aCampos)

	RecLock("Z57",.T.)
	Z57->Z57_FILIAL:='01' //xFilial("Z57")
    Z57->Z57_COD:=strzero(val(Alltrim(aCampos[_Z][1])),9)	
	Z57->Z57_ARQUIV:=UPPER(Alltrim(nomearq))
	Z57->Z57_NOME:=Alltrim(cEmpresa)
	Z57->Z57_END:=Alltrim(aCampos[_Z][6])+' complemento: '+Alltrim(aCampos[_Z][7])
	Z57->Z57_CIDADE:=Alltrim(aCampos[_Z][11])
	Z57->Z57_UF:=Alltrim(aCampos[_Z][12])
	Z57->Z57_ABERTU:=ctod(Alltrim(aCampos[_Z][15]))
	Z57->Z57_HRABERT:=Alltrim(aCampos[_Z][16])
	Z57->Z57_EDITAL:=Alltrim(aCampos[_Z][13])
//	Z57->Z57_INFO:='Situacao: '+Alltrim(aCampos[_Z][3])+' Tipop Prazo: '+Alltrim(aCampos[_Z][14])+' Valor Estimado: '+Alltrim(aCampos[_Z][17])+'Preco Edital:  '+Alltrim(aCampos[_Z][19])+' Banco Pagamento '+Alltrim(aCampos[_Z][20])
	Z57->Z57_LICITA:=Alltrim(aCampos[_Z][4])
	Z57->Z57_MODALI:=SUBSTR(Alltrim(aCampos[_Z][13]),1,AT('/',Alltrim(aCampos[_Z][13]))-1)
//  NOVO CAMPO 23 URL 
                                                       
    Z57->Z57_LINK1:=Alltrim(Substr(aCampos[_Z][23],1,at('*****',aCampos[_Z][23])-1))
    Z57->Z57_TIT1:=Alltrim(Substr(aCampos[_Z][23],1,at('*****',aCampos[_Z][23])-1))

    clink2:=Substr(aCampos[_Z][23],at('*****',aCampos[_Z][23])+5,len(aCampos[_Z][23])) 
    Z57->Z57_LINK2:=Alltrim(Substr(clink2,1,at('*****',clink2)-1))
    Z57->Z57_TIT2:=Alltrim(Substr(clink2,1,at('*****',clink2)-1))

    clink3:=Substr(clink2,at('*****',clink2)+5,len(clink2)) 
    Z57->Z57_LINK3:=Alltrim(Substr(clink3,1,at('*****',clink3)-1))
    Z57->Z57_TIT3:=Alltrim(Substr(clink3,1,at('*****',clink3)-1))

//
	Z57->Z57_DTREC:=ddatabase
	Z57->Z57_HRREC:=left(time(),5)
	Z57->(MsUnlock())
	// 
	MSMM(,,,lower('Objeto--> '+Alltrim(aCampos[_Z][18])),1,,,'Z57','Z57_DESCRI')     // objeto 
    MSMM(,,,lower('Obs--> '+Alltrim(aCampos[_Z][21]+' Situacao: '+Alltrim(aCampos[_Z][3])+' Tipo Prazo: '+Alltrim(aCampos[_Z][14])+' Valor Estimado: '+Alltrim(aCampos[_Z][17])+'Preco Edital:  '+Alltrim(aCampos[_Z][19])+' Banco Pagamento: '+Alltrim(aCampos[_Z][20])+' Complemento Orgao: '+Alltrim(aCampos[_Z][5])+' OBS Orgao: '+Alltrim(aCampos[_Z][10])+' - '+Alltrim(aCampos[_Z][22]))),1,,,'Z57','Z57_RESUMO')     // obs 
	
Next _Z


Return 

***************

Static Function jaLeu(empresa,nomearq)

***************
local cQry:=''
local lRet:=.F.

If Select('AUX1') > 1
	AUX1->(dbCloseArea())
EndIf

cQry:="SELECT TOP 1 Z57_ARQUIV FROM Z57020 Z57  "
cQry+="WHERE Z57_NOME='"+empresa+"'  "
cQry+="AND Z57_ARQUIV='"+nomearq+"' "                                    '
cQry+="AND Z57.D_E_L_E_T_=''  "
TCQUERY cQry   NEW ALIAS 'AUX1'

if AUX1->(!EOF())
   lRet:=.T.
EndIf

AUX1->(dbCloseArea())
	
Return lRet 