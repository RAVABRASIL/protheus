#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบDesc.     ณ Fila / Contato                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Embalagens - Cobranca                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COBC013()


//Fila()
Processa( {|| U_fNewFila() } )


Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC013   บAutor  ณMicrosiga           บ Data ณ  04/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fila()

//Verifica clientes por prioridade
cQUERY := " Select TOP 1 A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST "
cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, "+ RetSqlName( "ZZ6" ) + " Z6 "
//cQUERY += " Where Z6.ZZ6_ULCONT <= Z6.ZZ6_RETORN " //Alterei pq agendando o retorno o mesmo cliente voltava  para fila
cQUERY += " Where Z6.ZZ6_RETORN <= '"+Dtos(dDataBase)+"' " 
cQuery += " AND Z6.ZZ6_HORRET <= '"+Subs(Time(),1,5)+"' "
//cQUERY += " Where Z6.ZZ6_ULCONT < '"+Dtos(dDataBase)+"' "
cQUERY += " AND Z6.ZZ6_PRIORI <> '' " //So para os clientes com prioridade de atendimento
cQUERY += " AND SA1.A1_COD+SA1.A1_LOJA = Z6.ZZ6_CLIENT+Z6.ZZ6_LOJA "
cQUERY += " AND NOT EXISTS (SELECT ZZ6_FLAG "
cQUERY += " FROM " + RetSqlName( "ZZ6" ) + " ZZ6 "
cQUERY += " WHERE SA1.A1_COD+SA1.A1_LOJA = ZZ6.ZZ6_CLIENT+ZZ6.ZZ6_LOJA "
cQUERY += " AND ZZ6.ZZ6_FLAG   <> '' "
cQUERY += " AND ZZ6.D_E_L_E_T_ <> '*' )"
CqUERY += " AND EXISTS (SELECT ZZ7.ZZ7_PRIORI FROM "+RetSqlName("ZZ7")+" ZZ7 "
cQuery += " WHERE ZZ7.ZZ7_PRIORI = Z6.ZZ6_PRIORI "
cQuery += " AND ZZ7.ZZ7_TPSTAT = 'S' AND ZZ7.D_E_L_E_T_ <> '*' ) "
cQUERY += " AND SA1.D_E_L_E_T_ <> '*'"
cQUERY += " AND Z6.D_E_L_E_T_  <> '*' "
cQUERY += " ORDER BY Z6.ZZ6_PRIORI, Z6.ZZ6_SEQUEN" //SEQUENCIA DA FILA DE CONTATO
cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSA1
TCQUERY cQUERY Alias TMPSA1 New

Dbselectarea("TMPSA1")

If !TMPSA1->(EOF())
	Dbselectarea("SA1")
	Dbsetorder(1)
	Dbseek(xFilial()+TMPSA1->A1_COD+TMPSA1->A1_LOJA)

	U_COBC011(,,,.t.)   //Chama a tela de cobranca, apos posicionamento no cadastro de clientes
else
   msgBox("A fila de Cobranca esta vazia")
Endif

Dbselectarea("TMPSA1")
Dbclosearea()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfNewFila  บAutor  ณGustavo Costa       บ Data ณ  17/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a fila dos tํtulos a serem cobrados diariamente.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fNewFila()

Local cQuery		:= ""
Local nCont		:= 1
Local cArea1		:= GetNewPar("MV_XAREA1","AL#BA#CE#RN#SE")
Local cArea2		:= GetNewPar("MV_XAREA2","AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP")

dbSelectArea("ZZ8")
dbSetOrder(2)
		
If ZZ8->(dbSeek( xFilial("ZZ8") + DtoS(dDataBase) ))

	MsgAlert("Fila jแ gerada para o dia " + DtoC(dDataBase))
	Return
	
EndIf

For x := 1 To 4 // quantidade de listas por dia

	cQuery := " SELECT E1_FILIAL, E1_CLIENTE, E1_LOJA, A1_NOME, A1_TEL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, "  
	cQuery += " E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_PORTADO, E1_CONTA, A1_VEND, A3_SUPER, A1_SATIV1, A1_EST, "
	cQuery += " (SELECT TOP 1 YP_TEXTO FROM " + RETSQLNAME("SYP") + " WHERE YP_CHAVE = UC_CODOBS AND D_E_L_E_T_ <> '*') AS OBS_SAC"
	cQuery += " FROM " + RETSQLNAME("SE1") + " E1 "
	cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " A1 "
	cQuery += " ON E1_CLIENTE = A1_COD	"
	cQuery += " AND E1_LOJA = A1_LOJA "
	cQuery += " LEFT OUTER JOIN " + RETSQLNAME("SUC") + " SU " 
	cQuery += " ON UC_FILIAL = E1_FILIAL "
	cQuery += " AND UC_NFISCAL = E1_NUM "
	cQuery += " AND UC_SERINF = E1_PREFIXO "
	cQuery += " INNER JOIN " + RETSQLNAME("SA3") + " A3 " 
	cQuery += " ON A1_VEND = A3_COD "
	cQuery += " WHERE E1_SALDO > 0 "
	cQuery += " AND E1.D_E_L_E_T_ <> '*' " 
	cQuery += " AND E1_TIPO NOT IN ('NCC','RA','XX','TBX','TCC','TP ','CF-','NP ','JP ','TX ','TCB','TD ','TSP') " 
	cQuery += " AND E1_STATUS = 'A' "
	cQuery += " AND E1_PORTADO NOT IN ('COB') "
	cQuery += " AND E1_EMIS1 >= '" + DtoS(dDataBase - 1825) + "' "
	//cQuery += " AND E1_CLIENTE = '005571' "
	
	Do case
	
		Case x = 4 // 1 a 10 dias de vencido
	
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(dDataBase - 10) + "' AND '" + DtoS(dDataBase - 1) + "' "
	
		Case x = 3 // 11 a 20 dias de Vencido
	
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(dDataBase - 20) + "' AND '" + DtoS(dDataBase - 11) + "' "
		
		Case x = 2 // 21 a 30 dias de Vencido
	
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(dDataBase - 30) + "' AND '" + DtoS(dDataBase - 21) + "' "
		 
		Case x = 1 // Maior que 30 dias

			cQuery += " AND E1_VENCREA <= '" + DtoS(dDataBase - 31) + "' "

	EndCase
	
	cQuery += " ORDER BY E1_VENCREA "
	
	conOut( cQuery )
	
	If Select("XMP") > 0
		XMP->(DbCloseArea())
	EndIf
	
	TCQUERY cQuery NEW ALIAS "XMP"
	TCSetField( 'XMP', 'E1_EMISSAO', 'D' )
	TCSetField( 'XMP', 'E1_VENCREA', 'D' )
	
	XMP->( dbGoTop() )
	
	While XMP->( !EoF() )
	
		dbSelectArea("ZZ8")
		dbSetOrder(2)
		
		If ZZ8->(dbSeek( xFilial("ZZ8") + DtoS(dDataBase) + XMP->E1_CLIENTE + XMP->E1_LOJA ))
		
			RecLock("ZZ8", .F.)
			
			ZZ8->ZZ8_QTDTIT 		:= ZZ8->ZZ8_QTDTIT + 1
			ZZ8->ZZ8_VTOTLI		:= ZZ8->ZZ8_VTOTLI + XMP->E1_SALDO
			
			ZZ8->(MsUnLock())
		
		Else
			
			RecLock("ZZ8", .T.)
			
			ZZ8->ZZ8_FILIAL 		:= xFilial("ZZ8")
			ZZ8->ZZ8_DATAF		:= dDataBase
			ZZ8->ZZ8_LISTA		:= Alltrim(Str(x))
			ZZ8->ZZ8_CLIENT		:= XMP->E1_CLIENTE
			ZZ8->ZZ8_LOJA			:= XMP->E1_LOJA
			ZZ8->ZZ8_NOME			:= XMP->A1_NOME
			ZZ8->ZZ8_TEL			:= XMP->A1_TEL
			ZZ8->ZZ8_SATIV1		:= XMP->A1_SATIV1
			ZZ8->ZZ8_VEND 		:= XMP->A1_VEND
			ZZ8->ZZ8_SUPER		:= XMP->A3_SUPER
			ZZ8->ZZ8_PREFIX		:= XMP->E1_PREFIXO
			ZZ8->ZZ8_NUMERO		:= XMP->E1_NUM
			ZZ8->ZZ8_PARCEL		:= XMP->E1_PARCELA
			ZZ8->ZZ8_TIPO	   		:= XMP->E1_TIPO
			ZZ8->ZZ8_EMISSA		:= XMP->E1_EMISSAO
			ZZ8->ZZ8_VENCRE		:= XMP->E1_VENCREA
			ZZ8->ZZ8_VALOR		:= XMP->E1_VALOR
			ZZ8->ZZ8_SALDO		:= XMP->E1_SALDO
			ZZ8->ZZ8_BANCO		:= XMP->E1_PORTADO
			ZZ8->ZZ8_CONTA		:= XMP->E1_CONTA
			ZZ8->ZZ8_OBSSAC		:= XMP->OBS_SAC
			ZZ8->ZZ8_ORDEM		:= StrZero(nCont,6)
			
			If Alltrim(XMP->E1_PREFIXO) == "0" .AND. (XMP->E1_VENCREA > (dDataBase - 31))
			
				Do Case
		
					Case Alltrim(XMP->A1_EST) $ cArea2 .AND. XMP->A1_SATIV1 <> '000009'// "AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP"
			
						ZZ8->ZZ8_COBRAD		:= "000438"
						//Luana gon็alves 
			
					Case Alltrim(XMP->A1_EST) $ cArea1 .AND. XMP->A1_SATIV1 <> '000009' // "AL#BA#CE#RN#SE"
			
						ZZ8->ZZ8_COBRAD		:= "000331"
						//Solange Mota 
			
					Case XMP->A1_SATIV1 == '000009' // Publico
			
						ZZ8->ZZ8_COBRAD		:= "000426"
						//Renata Aragao
					
					OtherWise 
			
						ZZ8->ZZ8_COBRAD		:= ""
				
				EndCase
			ElseIF Alltrim(XMP->E1_PREFIXO) == "" .AND.  XMP->A1_SATIV1 <> '000009'
		
				ZZ8->ZZ8_COBRAD		:= "000331"
				//Solange Mota 
				ElseIf XMP->A1_SATIV1 == '000009'
					ZZ8->ZZ8_COBRAD		:= "000426"
					//Renata Aragao
			EndIf
				
			ZZ8->ZZ8_QTDTIT 		:= 1
			ZZ8->ZZ8_VTOTLI		:= XMP->E1_SALDO
			
			ZZ8->(MsUnLock())
		
		EndIf
		
		nCont	:= nCont + 1
		dbSelectArea("XMP")
		XMP->( dbSkip() )

	EndDo

XMP->(DbCloseArea())

Next

Return