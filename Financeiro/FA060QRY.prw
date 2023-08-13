#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


//Ponto de entrada que permite incluir filtro na geracao do Bordero
//Eurivan MArques Candido 10/04/2008

************************
User Function FA060QRY()
************************

//Comentei pois não estamos imprimindo boleto direto na Rava - Eurivan - 30/11/10
/*
Local cQry
Local lOK    := .F.
Local nItem  := '2'
*/
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

//SetPrvt("oDlg1","oSay1","oCBox1","oSBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*
oDlg1      := MSDialog():New( 220,247,293,732,"Gera Bordero",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 008,012,{||"Gera somente para Titulos de Boletos impressos na Rava ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,016)
oCBox1     := TComboBox():New( 012,116,{|u| If(PCount()>0,nItem:=u,nItem)},{"1=Sim","2=Nao"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,"nItem" )
oSBtn1     := SButton():New( 012,200,1,{||lOk := .T., oDlg1:End()},oDlg1,,"", )

oDlg1:Activate(,,,.T.)

if lOk .AND. nItem == '1'
   cQry := " CAST( CAST( E1_VENCTO AS DATETIME ) - CAST( E1_EMISSAO AS DATETIME ) AS INT ) <= 15 AND "
   cQry += " SUBSTRING(E1_NUMBCO,1,6) = '"+Alltrim(GetMV("MV_CONVBB"))+"' "
endif

Return cQry
*/