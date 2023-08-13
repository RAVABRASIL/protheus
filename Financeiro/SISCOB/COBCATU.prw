#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Atualiza observacoes da cobranca na nova base.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rava Embalagens - Cobranca                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COBCATU()

Alert("Nao use esta funcao")

Return

Dbselectarea("SZ0")
Dbgotop()

While !Eof()
	//Tenho que pesquisar o cliente, pois a tabela SZ0 so possui o codigo e o cpf
	Dbselectarea("SA1")
	Dbsetorder(3)
	If Dbseek(xFilial()+SZ0->Z0_CPF)
		Dbselectarea("ZZ6")
		Dbsetorder(1)
		If	Dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA)
			Reclock("ZZ6",.F.)
			Replace ZZ6_MEMO   With SZ0->Z0_OBS  
			If SZ0->Z0_DTRET > dDatabase
				Replace ZZ6_RETORN With SZ0->Z0_DTRET
				Replace ZZ6_TIPRET With "1"
			Else
				Replace ZZ6_RETORN With dDatabase
				Replace ZZ6_TIPRET With "2"
			Endif	
			MSUNLOCK()
		Else
			Reclock("ZZ6",.T.)
			Replace ZZ6_FILIAL With xFilial()
			Replace ZZ6_CLIENT With SA1->A1_COD
			Replace ZZ6_LOJA   With SA1->A1_LOJA
			Replace ZZ6_MEMO   With SZ0->Z0_OBS
			If SZ0->Z0_DTRET > dDatabase
				Replace ZZ6_RETORN With SZ0->Z0_DTRET
				Replace ZZ6_TIPRET With "1"
			Else
				Replace ZZ6_RETORN With dDatabase
				Replace ZZ6_TIPRET With "2"
			Endif	
			MSUNLOCK()
		Endif
	Else
		Alert("Cliente nao encontrado :"+SZ0->Z0_CPF)
	Endif
	Dbselectarea("SZ0")
	dbskip()
End

Alert("Fim do processamento")
Return