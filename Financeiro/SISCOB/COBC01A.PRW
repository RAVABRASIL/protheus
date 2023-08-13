#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/01

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Tela para a cobranca e a pre-cobranca                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rava Embalagens - Cobranca                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COBC01a()        // incluido pelo assistente de conversao do AP5 IDE em 26/07/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CCADASTRO,AROTINA,")

aROTINA   := {}
cCadastro := "Cobranca"

//Dbselectarea("SX5")
//Dbseek(xFilial()+"ZU26")

/*
If UPPER(Trim(Subst(cUsuario,7,15))) $ SX5->X5_DESCRI
	aRotina := { { "Pesq.Avancada"  ,'U_COBC012()',0,6 },;
				 { "Atual.Cobranca" ,'U_COBC014()',0,6 },;
				 { "Fila/Contato"   ,'U_COBC013()',0,6 },;
				 { "Prorrogar"      ,'U_COBC06()' ,0,6 },;
				 { "Cart.Cobranca"  ,'U_COBC015()',0,6 },;
				 { "Med.Atraso"     ,'U_COBC016()',0,6 },;
				 { "Atu.Lim.Cred."  ,'U_FIN004()' ,0,6 } }
Else
	aRotina := { { "Pesq.Avancada"  ,'U_COBC012()',0,6 },;
  				 { "Atual.Cobranca" ,'U_COBC014()',0,6 },;
				 { "Fila/Contato"   ,'U_COBC013()',0,6 },;
				 { "Prorrogar"      ,'U_COBC06()' ,0,6 },;
				 { "Cart.Cobranca"  ,'U_COBC015()',0,6 },;
				 { "Med.Atraso"     ,'U_COBC016()',0,6 } }
Endif
*/

aRotina := { { "Pesq.Avancada"  ,'U_COBC012()',0,6 },;
			 { "Atual.Cobranca" ,'U_COBC014()',0,6 },;
			 { "Fila/Contato"   ,'U_COBC013()',0,6 },;
			 { "Prorrogar"      ,'U_COBC06()' ,0,6 },;
			 { "Cart.Cobranca"  ,'U_COBC015()',0,6 } }

//mBrowse(6,1,22,75,"ZZ0")
mBrowse(6,1,22,75,"SA1")
//{ "Consulta"          ,'U_COBC011(SZ0->Z0_CODIGO)',0,10},;
//{ "Pesquisa"          ,'AxPesqui',0,6 },;
Return(nil) //incluido pelo assistente de conversao do AP5 IDE em 26/07/01
