#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


************************
User function TMKC033() //Lista de Clientes BRASIL que não compraram apos 45 dias da ultima entrega
************************

Local aCab       := {}
Local aItens     := {}
Local cCliente   := ""
Local cLoja	     := ""
Local cCodContat := ""
Local cLista	  := ""
Local cU4Codlig  := ""
Local cU6Codigo  := ""
Local cU6Codlig  := ""
Local LF 		   := CHR(13) + CHR(10)


// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

cQuery := "SELECT "
cQuery += "   COD,  "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   ULT_ENTR "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      COD,  "
cQuery += "      LOJA, "
cQuery += "      NOME, "
cQuery += "      ULT_ENTR, "
cQuery += "      TEM_PED = "
cQuery += "                CASE WHEN EXISTS (SELECT "
cQuery += "                                     SC5X.C5_FILIAL "
cQuery += "                                  FROM "
cQuery += "                                     "+RetSqlName("SB1")+" SB1X, "+RetSqlName("SC5")+" SC5X, "+RetSqlName("SC6")+" SC6X, "
cQuery += "                                     "+RetSqlName("SA1")+" SA1X, "+RetSqlName("SA3")+" SA3X, "+RetSqlName("SE4")+" SE4X "
cQuery += "                                  WHERE "
cQuery += "                                     SC5X.C5_CLIENTE = COD AND SC5X.C5_LOJACLI = LOJA AND "
cQuery += "                                     SC5X.C5_FILIAL = SC6X.C6_FILIAL AND "
cQuery += "                                     SC6X.C6_BLQ <> 'R' AND SB1X.B1_TIPO = 'PA' AND "
cQuery += "                                     SC6X.C6_PRODUTO = SB1X.B1_COD AND SC5X.C5_NUM = SC6X.C6_NUM AND SC5X.C5_VEND1 = SA3X.A3_COD AND "
cQuery += "                                     SC5X.C5_CLIENTE = SA1X.A1_COD AND SC5X.C5_LOJACLI = SA1X.A1_LOJA AND "
cQuery += "                                     SC5X.C5_ENTREG >= ULT_ENTR AND "
cQuery += "                                     SC6X.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                                     SB1X.B1_SETOR <>'39' AND "
cQuery += "                                     SC5X.C5_CONDPAG = SE4X.E4_CODIGO AND "
cQuery += "                                     SB1X.D_E_L_E_T_ = ' ' AND "
cQuery += "                                     SC5X.D_E_L_E_T_ = ' ' AND "
cQuery += "                                     SC6X.D_E_L_E_T_ = ' ' AND "
cQuery += "                                     SE4X.D_E_L_E_T_ = ' ' AND "
cQuery += "                                     SA1X.D_E_L_E_T_ = ' '  ) THEN 'X' ELSE '' END "
cQuery += "   FROM "
cQuery += "   (   "
cQuery += "      SELECT "
cQuery += "              COD = A1_COD, "
cQuery += "             LOJA = A1_LOJA, "
cQuery += "             NOME = A1_NOME, "
cQuery += "         ULT_ENTR = MAX(F2_REALCHG), "
cQuery += "             DIAS = CAST(CONVERT(DATETIME,GETDATE()-CONVERT(DATETIME,MAX(F2_REALCHG))) AS INTEGER) "
cQuery += "      FROM "
cQuery += "         "+RetSqlName("SA1")+" SA1 with (nolock), "
cQuery += "         "+RetSqlName("SD2")+" SD2 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock), "+RetSqlName("SF2")+" SF2 with (nolock), "
cQuery += "         "+RetSqlName("SA3")+" SA3 with (nolock), "+RetSqlName("SE4")+" SE4 with (nolock), "+RetSqlName("SF4")+" SF4 with (nolock) "
cQuery += "      WHERE
//cQuery += "         A1_EST = 'CE' AND "
cQuery += "         F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND "
cQuery += "         F2_EMISSAO >= '20160101' AND F2_REALCHG <> '' AND "
cQuery += "         F2_VEND1 = A3_COD AND F2_COND = E4_CODIGO AND "
cQuery += "         D2_COD = B1_COD AND SB1.B1_SETOR <>'39' AND "
cQuery += "         D2_TIPO = 'N' AND D2_TP != 'AP' AND B1_TIPO = 'PA' AND "
cQuery += "         RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQuery += "         D2_DOC=F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA = F2_LOJA AND F2_DUPL <> ' ' AND "
cQuery += "         SA1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND "
cQuery += "         SB1.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SE4.D_E_L_E_T_ <> '*' AND "
cQuery += "         SF4.D_E_L_E_T_ <> '*' "
cQuery += "      GROUP BY "
cQuery += "         A1_COD, A1_LOJA, A1_NOME "
cQuery += "   ) AS FATCE "
cQuery += "   WHERE "
//cQuery += "      DIAS >= 45 "
//alterado em 27/07/16 - solicitado por marcelo
cQuery += "      DIAS = 45 "
cQuery += ") AS FATCE "
cQuery += "ORDER BY "
cQuery += "   ULT_ENTR DESC "

If Select("TLM1") > 0
	DbSelectArea("TLM1")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TLM1" 

TLM1->(DbGoTop())

DbSelectArea("AC8")
DbSetOrder(2)         //AC8_FILIAL + AC8_ENTIDA + AC8_FILENT   + AC8_CODENT   + AC8_CODCON
                                     //Entidade + Fil.Entidade + Cod.Entidade + Contato                      
cLista := GetSxENum("SU4","U4_LISTA")

while SU4->( DbSeek( xFilial( "SU4" ) + cLista ) )
   ConfirmSX8()
   cLista := GetSxeNum("SU4","U4_LISTA")
end
  
cU4Codlig := fMaxU4Lig()
cU6Codlig := cU4Codlig

Aadd(aCab, {xFilial("SU4")                    ,;//1->U4_FILIAL
			   cLista                            ,;//2->U4_LISTA
			   cU4Codlig                         ,;//3->U4_CODLIG
			   "LISTA DE CLIENTES (BRASIL): "+cLista ,;//4->U4_DESC
			   DataValida(dDatabase)             ,;//5->U4_DATA
			   "1"                               ,;//6->U4_TIPO -->  1=Marketing, 2=Cobrança, 3=Vendas, 4=TeleAtendto.
			   "1"                               ,;//7->U4_FORMA --> 1=Voz, 2=Fax, 3=Cross Posting, 4= Mala direta, 5=Pendencia 
			   "1"                               ,;//8->U4_TELE -->  1-Telemarketing/ 2-Televendas/ 3-Telecobranca/ 4-Ambos (Legado)
			   "4"                               ,;//9->U4_TIPOTEL
			   "1"                               ,;//10->U4_STATUS -->1=Ativa, 2=Encerrada, 3=Em atendimento
			   Time()                            ,;//11->U4_HORA1
			   "000006" } )					

			   //Operador em Branco -> todos os operadores visualizam as listas

cU6Codigo := fMaxU6Cod()

While !TLM1->(EOF())    	   

   cCliente := TLM1->COD
	cLoja    := TLM1->LOJA
	cEntida  := TLM1->( cCliente + cLoja )
                 
	DbSelectArea("AC8")
	DbSetOrder(2)   
		
	If AC8->(DbSeek(xFilial("AC8")+"SA1"+"  "+ cEntida ))
		cCodContat := AC8->AC8_CODCON
	Else
		SA1->(Dbsetorder(1))
		SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja ))
			   		
		cCodContat		:= GETSX8NUM("SU5","U5_CODCONT")
		SU5->(Dbsetorder(1))
		If !SU5->(Dbseek(xFilial("SU5") + cCodContat ))
			RecLock("SU5", .T.)
		   SU5->U5_FILIAL  := xFilial("SU5")
			SU5->U5_CLIENTE := cCliente
			SU5->U5_LOJA    := cLoja
		   SU5->U5_CODCONT := cCodContat    		
		   SU5->U5_CONTAT  := iif(!Empty(SA1->A1_CONTATO), SA1->A1_CONTATO, SA1->A1_NOME )
		   SU5->U5_CELULAR := SA1->A1_CELULAR
		   SU5->U5_DDD     := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,2,2) , SA1->A1_DDD )
		   SU5->U5_EMAIL   := SA1->A1_EMAIL
		   SU5->U5_FCOM1   := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,5,11), SA1->A1_TEL )
		   SU5->U5_CPF		:= SA1->A1_CGC
		   SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
		   SU5->(MsUnlock())
		   CONFIRMSX8()
		   fCriaCont( "SA1", cCliente+cLoja , cCodContat )
		Else		      		
		   cCodContat := fMaxSU5()		      	
		   SU5->(Dbsetorder(8))		//U5_FILIAL + U5_CPF		      		
		   If !SU5->(Dbseek(xFilial("SU5") + SA1->A1_CGC ))
			   RecLock("SU5", .T.)
			   SU5->U5_FILIAL  := xFilial("SU5")
				SU5->U5_CLIENTE := cCliente
				SU5->U5_LOJA    := cLoja
			   SU5->U5_CODCONT := cCodContat    		
			   SU5->U5_CONTAT  := iif(!Empty(SA1->A1_CONTATO), SA1->A1_CONTATO, SA1->A1_NOME )
			   SU5->U5_CELULAR := SA1->A1_CELULAR
			   SU5->U5_DDD     := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,2,2) , SA1->A1_DDD )
			   SU5->U5_EMAIL   := SA1->A1_EMAIL
			   SU5->U5_FCOM1   := iif(Substr(SA1->A1_TEL,1,1) == "(" , Substr(SA1->A1_TEL,5,11), SA1->A1_TEL )
			   SU5->U5_CPF		:= SA1->A1_CGC
			   SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
			   SU5->(MsUnlock())			      				      	
			Endif	
			fCriaCont( "SA1", cCliente+cLoja , cCodContat )   
		Endif	
	Endif
		   	    
	                	    
	Aadd(aItens, {xFilial("SU6"),; //1->U6_FILIAL
	              cLista		    ,; //2->U6_LISTA
		   		  cU6Codigo	    ,; //3->U6_CODIGO
	              "SA1"         ,; //4->U6_ENTIDA
	              cEntida       ,; //5->U6_CODENT
	              "1"           ,; //6->U6_ORIGEM
	              cCodContat    ,; //7->U6_CONTATO
	              cU6Codlig  	 ,; //8->U6_CODLIG
	              dDatabase		 ,; //9->U6_DATA
	              Time() 		 ,; //10->U6_HRINI
	              "23:59"		 ,; //11->U6_HRFIM
	              "1"         	 ,; //12->U6_STATUS
	              "1"           ,; //13->U6_TIPO       // 1=Marketing
	              "000006"      }) //14->U6_OPERADOR
	                
	If Len(aItens) > 0
		lGravaPos := .T.
	Else
		ConOut( "Tmkc033- Array aItens vazio - sem itens Lista Cliente (Brasil) " + Dtoc( Date() ) + ' - ' + Time() )
   Endif	  
   cU6Codigo := Soma1(cU6Codigo)   
       
   DbSelectArea("TLM1")
   TLM1->(DbSkip())
Enddo

DbselectArea("TLM1")
DbCloseArea("TLM1")
cMsg   := ""
eEmail := ""
subj   := ""
If lGravaPos  
	For u4 := 1 to Len(aCab)
		Reclock("SU4",.T.)		
		SU4->U4_FILIAL  := aCab[u4][1]
		SU4->U4_LISTA   := aCab[u4][2]
		SU4->U4_CODLIG  := aCab[u4][3]
		SU4->U4_DESC	 := aCab[u4][4]
		SU4->U4_DATA	 := aCab[u4][5]
		SU4->U4_TIPO	 := aCab[u4][6]
		SU4->U4_FORMA	 := aCab[u4][7]
		SU4->U4_TELE	 := aCab[u4][8]
		SU4->U4_TIPOTEL := aCab[u4][9]           
		SU4->U4_STATUS	 := aCab[u4][10]
		SU4->U4_HORA1	 := aCab[u4][11]
		SU4->U4_OPERAD	 := aCab[u4][12]	   	
   	SU4->(MsUnlock())
   	CONFIRMSX8()
    Next
    
    For u6 := 1 to Len(aItens)
    	If !SU6->(Dbseek(xFilial("SU6") + aItens[u6][13] + aItens[u6][14] ))
	    	Reclock("SU6",.T.)
			SU6->U6_FILIAL	 := xFilial("SU6")
			SU6->U6_FILENT	 := aItens[u6][1]
		   SU6->U6_LISTA	 := aItens[u6][2]
		   SU6->U6_CODIGO  := aItens[u6][3]
		   SU6->U6_ENTIDA	 := aItens[u6][4]
		   SU6->U6_CODENT	 := aItens[u6][5]  
		   SU6->U6_ORIGEM	 := aItens[u6][6]            	//1=Lista 2=Manual 3=Atendimento
		   SU6->U6_CONTATO := aItens[u6][7]
		   SU6->U6_CODLIG	 := aItens[u6][8]         
		   SU6->U6_DATA	 := aItens[u6][9]
		   SU6->U6_HRINI	 := aItens[u6][10] 
		   SU6->U6_HRFIM	 := aItens[u6][11]   
		   SU6->U6_STATUS	 := aItens[u6][12]    			//1=Não Enviado, 2=Em Uso, 3=Enviado	   
		   SU6->U6_TIPO    := aItens[u6][13]
		   SU6->U6_CODOPER := aItens[u6][14]
		   SU6->(MsUnlock())
		Endif	   		   	
    Next 
    cMsg   := "Lista clientes Brasil gerada - Filial: " + xFilial() + LF
	 cMsg   += "Data: " + Dtoc(Date()) + LF
	 cMsg   += "Hora: " + Time() + LF
	 eEmail := "eurivan@ravaembalagens.com.br"
	 subj   := "Lista Clientes Brasil GERADA OK - Filial: "+ xFilial() + LF
	 //U_SendFatr11(eEmail, "", subj, cMsg, "" )
else
   cMsg   := "SEM dados para lista Clientes Brasil - Filial: " + xFilial() + LF
	cMsg   += "Data: " + Dtoc(Date()) + LF
	cMsg   += "Hora: " + Time() + LF
	eEmail := "eurivan@ravaembalagens.com.br"
	subj   := "Lista clientes Brasil NAO GERADA - Filial: "+ xFilial() + LF
	//U_SendFatr11(eEmail, "", subj, cMsg, "" )
   ROLLBACKSX8()
endif

conout(Replicate("*",60))
conout("Gera Clientes Brasil - FIM")
conout("TMKC033 - Lista Clientes Brasil - Emp. 02 filial 01 " + Dtoc( Date() ) + ' - ' + Time() )
conout(Replicate("*",60))

return 


**************************************
Static Function fMaxU6Cod()     
**************************************

Local cQry 		:= "" 
Local cMaxU6 	:= ""

cQry := " SELECT MAX(U6_CODIGO) as U6_CODIGO "
cQry += " FROM " + RetSqlname("SU6") + " SU6 "
cQry += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQry += " AND SU6.D_E_L_E_T_ <>'*' "

cQry := ChangeQuery( cQry )

If Select("MAXU6") > 0
	DbSelectArea("MAXU6")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU6" 

cMaxU6 := Soma1(MAXU6->U6_CODIGO)

DbCloseArea("MAXU6")

Return(cMaxU6)

**************************************
Static Function fMaxU4Lig()     
**************************************

Local cQry 		:= "" 
Local cMaxU4 	:= ""

cQry := " SELECT MAX(U4_CODLIG) as U4_CODLIG "
cQry += " FROM " + RetSqlname("SU4") + " SU4 "
cQry += " WHERE U4_FILIAL = '" + xFilial("SU4") + "' "
cQry += " AND SU4.D_E_L_E_T_ <>'*' "

cQry := ChangeQuery( cQry )

If Select("MAXU4") > 0
	DbSelectArea("MAXU4")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU4" 

cMaxU4 := Soma1(MAXU4->U4_CODLIG)

DbCloseArea("MAXU4")

Return(cMaxU4)



**************************************
Static Function fMaxSU5()     
**************************************

Local cQry 		:= "" 
Local cMaxU5 	:= ""


cQry := " SELECT MAX(U5_CODCONT) as U5_CODCONT "
cQry += " FROM " + RetSqlname("SU5") + " SU5 "
cQry += " WHERE U5_FILIAL = '" + xFilial("SU5") + "' "
cQry += " AND SU5.D_E_L_E_T_ <>'*' "
Memowrite("C:\MAX_U5.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXU5") > 0
	DbSelectArea("MAXU5")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU5" 

cMaxU5 := soma1(MAXU5->U5_CODCONT)

DbCloseArea("MAXU5")

Return(cMaxU5)


*******************************************************
static function fCriaCont( cEntidade, cCodEnt, cCodCon )
*******************************************************

DbselectArea("AC8")
RecLock("AC8", .T.)
AC8->AC8_ENTIDA := cEntidade
AC8->AC8_CODENT := cCodEnt
AC8->AC8_CODCON := cCodCon
AC8->(MSUnLock())

return