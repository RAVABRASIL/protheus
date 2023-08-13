#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#Include "Topconn.ch"

//--------------------------------
//Programa: TMKC0011.PRW
//Data    : 19/11/09
//Autoria : Flávia Rocha
//Função  : TMKC0011
//--------------------------------

//Funções utilizadas dentros dos inicalizadores padrões dos campos:
/*
- UC_DESCENT - Descrição da Entidade => SA1, SA2, SA4
- UC_DESCCHA - Nome da empresa correspondente à Entidade


*/

****************************************************
User function TKC0011A()
****************************************************
//Esta função alimenta o campo UC_DESCENT com o nome da entidade

Local cEntidade := ""  //Alltrim( SU6->U6_ENTIDA )
Local cChave    := ""  //Alltrim( SU6->U6_CODENT )
Local cNomEnti	:= SU6->U6_ENTIDA //""
Local cQuery	:= ""
Local cCodcont  := SU6->U6_CODENT //M->UC_CODCONT

/*
cQuery := "SELECT AC8_FILIAL, AC8_CODENT, AC8_ENTIDA, AC8_CODCON "
cQuery += " FROM "+RetSqlName("AC8") +" AC8 "
cQuery += " WHERE AC8_FILIAL = '" + xFilial("AC8") + "' "
cQuery += " AND RTRIM( AC8_CODCON ) = '" + Alltrim( cCodCont ) + "' "
cQuery += " AND AC8.D_E_L_E_T_ = '' "
Memowrite("C:\TK11A.SQL",cQuery)
cQuery := ChangeQuery( cQuery )


If Select("TK11A") > 0
	DbSelectArea("TK11A")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TK11A" 

TK11A->(DbGoTop())

While !TK11A->(EOF())
	cEntidade := TK11A->AC8_ENTIDA
	cChave	  := TK11A->AC8_CODENT
TK11A->(Dbskip())
Enddo

DbselectArea("TK11A")
DbcloseArea()


Dbselectarea("AC8")
Dbsetorder(1)
If AC8->(Dbseek(xFilial("AC8") + cCodcont ))
	cEntidade := AC8->AC8_ENTIDA
	cChave	  := AC8->AC8_CODENT
	
Endif

Dbclosearea()
*/

/*
cQuery := "SELECT U6_FILIAL, U6_ENTIDA, U6_CODENT "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND RTRIM( U6_ENTIDA ) = '" + Alltrim( cEntidade ) + "' "
cQuery += " AND RTRIM( U6_CODENT ) = '"  + Alltrim( cChave ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "
Memowrite("C:\TK11.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("TK11") > 0
	DbSelectArea("TK11")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TK11" 

TK11->(DbGoTop())

While !TK11->(EOF())

	If Alltrim(TK11->U6_ENTIDA) = "SA1"
		cNomEnti := "CLIENTES"

	Elseif Alltrim(TK11->U6_ENTIDA) = "SA4"
		cNomEnti := "TRANSPORTADORAS"

	Elseif Alltrim(TK11->U6_ENTIDA) = "SA2"
		cNomEnti := "FORNECEDORES"

	Endif
	TK11->(Dbskip())
Enddo

DbselectArea("TK11")
DbcloseArea()
*/

If Alltrim(SU6->U6_ENTIDA) = "SA1"
		cNomEnti := "CLIENTES"

Elseif Alltrim(SU6->U6_ENTIDA) = "SA4"
		cNomEnti := "TRANSPORTADORAS"

Elseif Alltrim(SU6->U6_ENTIDA) = "SA2"
		cNomEnti := "FORNECEDORES"
Endif


Return(cNomEnti) 

****************************************************
User function TKC0011B()
****************************************************
//Esta função alimenta o campo UC_DESCCHA - que corresponde à razão social da entidade

Local cEntid    := Alltrim( SU6->U6_ENTIDA )
Local cChav     := Alltrim( SU6->U6_CODENT )
Local cNome		:= ""
Local cQuery	:= ""
Local cCodcontat := SU6->U6_CODENT //M->UC_CODCONT 

/*
Dbselectarea("AC8")
Dbsetorder(1)
If AC8->(Dbseek(xFilial("AC8") + cCodcontat ))
	cEntid := AC8->AC8_ENTIDA
	cChav  := AC8->AC8_CODENT
Endif

AC8->(DbCloseArea())

cQuery := "SELECT U6_FILIAL, U6_ENTIDA, U6_CODENT "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND RTRIM( U6_ENTIDA ) = '" + Alltrim( cEntid ) + "' "
cQuery += " AND RTRIM( U6_CODENT ) = '"  + Alltrim( cChav ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "
Memowrite("C:\TK11B.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("TK11B") > 0
	DbSelectArea("TK11B")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TK11B" 

TK11B->(DbGoTop())

While !TK11B->(EOF())


	If Alltrim(TK11B->U6_ENTIDA) = "SA1"
		DbSelectArea( "SA1" )
		DbsetOrder(1)
		If SA1->(Dbseek(xFilial( "SA1" ) + Alltrim(TK11B->U6_CODENT) ) )
			cNome := SA1->A1_NOME
		Endif
	
	Elseif Alltrim(TK11B->U6_ENTIDA) = "SA4"
		DbSelectArea( "SA4" )
		DbsetOrder(1)
		If SA4->(Dbseek(xFilial( "SA4" ) + Alltrim(TK11B->U6_CODENT) ) )
			cNome := SA4->A4_NOME
		Endif
	
	Elseif Alltrim(TK11B->U6_ENTIDA) = "SA2"
		DbSelectArea( "SA2" )
		DbsetOrder(1)
		If SA2->(Dbseek(xFilial( "SA2" ) + Alltrim(TK11B->U6_CODENT) ) )
			cNome := SA2->A2_NOME
		Endif
	Endif
    TK11B->(Dbskip())
Enddo
DbselectArea("TK11B")
DbcloseArea()
*/

If Alltrim(SU6->U6_ENTIDA) = "SA1"
		DbSelectArea( "SA1" )
		DbsetOrder(1)
		If SA1->(Dbseek(xFilial( "SA1" ) + Alltrim(SU6->U6_CODENT) ) )
			cNome := SA1->A1_NOME
		Endif
	
Elseif Alltrim(SU6->U6_ENTIDA) = "SA4"
		DbSelectArea( "SA4" )
		DbsetOrder(1)
		If SA4->(Dbseek(xFilial( "SA4" ) + Alltrim(SU6->U6_CODENT) ) )
			cNome := SA4->A4_NOME
		Endif
	
Elseif Alltrim(SU6->U6_ENTIDA) = "SA2"
		DbSelectArea( "SA2" )
		DbsetOrder(1)
		If SA2->(Dbseek(xFilial( "SA2" ) + Alltrim(SU6->U6_CODENT) ) )
			cNome := SA2->A2_NOME
		Endif
Endif

Return(cNome) 



