#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF1100E   �Autor  � Fl�via Rocha       � Data �  05/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada que faz a exclusao do registro no Z10     ���
���          � ( Processos de Devolu��o )                                 ���
�������������������������������������������������������������������������͹��
���Uso       � NF Entrada - exclus�o                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

************************
USER FUNCTION SF1100E() 
************************            

LOCAL aAlias := {"SF1", "SB1", "Z10" }, aAmb := {}, cAlias := ALIAS()
Local cNFD   := SF1->F1_DOC
Local cSERINFD := SF1->F1_SERIE 
Local cCli   := SF1->F1_FORNECE
Local cLJ    := SF1->F1_LOJA
Local cQuery := ""
Local eEmail := ""
Local subj   := ""
Local LF     := CHR(13) + CHR(10)

aAmb := U_GETAMB( aAlias ) 
/*
For f := 1 to LEN( aCols )
    cCodPro := aCols[f][ aScan( aHeader, {|x| alltrim(x[2]) == "D1_COD" }) ]

	SB1->(DBSETORDER(1))
	IF SB1->(DBSEEK(XFILIAL("SB1")+cCodPro ) )
	    
	   IF SB1->B1_USASER = "S"  // SE UTILIZA CONTROLE DE RASTREABILIDADE POR NUMERO DE SERIE
	         
	         // PROCURA O SZA CORRESPONDENTE DESTA NF
	         DBSELECTAREA("SZA")
	         DBSETORDER(3) // ZA_FILIAL+ZA_MODOENT+ZA_DOCNFE+ZA_SERNFE+ZA_FORNFE+ZA_LOJNFE+ZA_COD
	         DBSEEK( XFILIAL("SZA") + "NFE" + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+cCodPro) , .T.)
	         
	         DO WHILE !EOF() .AND. SZA->(ZA_FILIAL+ZA_MODOENT+ZA_DOCNFE+ZA_SERNFE+ZA_FORNFE+ZA_LOJNFE+ZA_COD) == ;
	                                 XFILIAL("SZA")+"NFE"+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+cCodPro)
	            RECLOCK("SZA",.F.)
	            DBDELETE()
	            MSUNLOCK()
	
	            DBSELECTAREA("SZA")
	            DBSKIP()
	         ENDDO   
	         
	   EndIF
	   
	ENDIF
	
Next
*/

If SF1->F1_TIPO = 'D' //Devolu��o de Vendas

	//localiza a NF SA�DA origem (SD2)
	cQuery := " Select * from " + CHR(13) + CHR(10)
	cQuery += " " + RetSqlName("SD1") + " SD1 "+ CHR(13) + CHR(10)
	cQuery += " Where D1_FILIAL = '" + Alltrim(xFilial("SF1")) + "' " + CHR(13) + CHR(10)
	cQuery += " and D1_DOC = '" + Alltrim(cNFD) + "' " + CHR(13) + CHR(10)
	cQuery += " and D1_SERIE='" + Alltrim(cSERINFD) + "' " + CHR(13) + CHR(10)
	cQuery += " and D1_FORNECE ='" + Alltrim((cCli)) + "' " + CHR(13) + CHR(10)
	cQuery += " and D1_LOJA ='" + Alltrim((cLj)) + "' " + CHR(13) + CHR(10)
	//quando � exclus�o de NFE , n�o uso D_E_L_E_T_ = '' ,  porque se j� foi exclu�da, o delete t� = * j�
	MemoWrite("C:\SF1100E.SQL", cQuery )
	
	TCQUERY cQuery NEW ALIAS  "TMPA"
	TMPA->( dbGoTop() )
	
	if !TMPA->(Eof())
		While !TMPA->(EOF())
			cNFORI := TMPA->D1_NFORI       //NF SA�DA ORIGINAL
			cSERIORI := TMPA->D1_SERIORI   //S�RIE ORIGINAL
			TMPA->(Dbskip())
		Enddo               
		DbselectArea("Z10")
		Z10->(Dbsetorder(1))  //NF + SERIE + CODIGO OCORR. + ITEM OCORR.
		If Z10->(Dbseek(xFilial("Z10") + cNFORI + cSERIORI ))	
			RecLock("Z10" , .F. )
			Z10->Z10_DTDEVO := Ctod("  /  /    ") 
			Z10->Z10_STATUS := '02'       //volta status anterior, 02 - resposta SAC qdo cancela a NF DEVOLU��O -> status na X5 -> ZG
			Z10->Z10_DTSTAT := DATE()
			Z10->Z10_HRSTAT := TIME()
			Z10->Z10_USER   := __CUSERID
			Z10->Z10_NOMUSR:= SUBSTR(cUSUARIO,7,15)
			Z10->Z10_NFEDEV:= '' 
			Z10->Z10_SERDEV:= ''
			Z10->(MsUnlock())
	
		
		Endif
		
		//ENCONTROU O REGISTRO CORRESPONDENTE NO Z10
			cMsg   := "NF Devolu��o Cancelada - NF / Serie: " + cNFD + '/' + cSERINFD + LF
			cMsg   += "Data: " + Dtoc(Date()) + LF
			cMsg   += "Hora: " + Time() + LF
			cMsg   += "Usuario: " + Substr(cUSUARIO,7,15) + LF
			cMsg   += "Referente a Devolu��o da NF Sa�da - NF / Serie: " + cNFORI + '/' + cSERIORI + LF
			eEmail := "flavia.rocha@ravaembalagens.com.br"
			subj   := "NF Devolu��o Cancelada - NF / Serie: " + cNFD + '/' + cSERINFD
			//U_SendFatr11(eEmail, "", subj, cMsg, "" )
	
	endif
ENDIF //se for nf devolu��o


U_RESTAMB( aAmb )
DBSELECTAREA(cAlias)

RETURN .T.