#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO10    º Autor ³ AP6 IDE            º Data ³  09/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MUDA_DESC()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
local cDesc, cNewDesc
local nPosX, nPOsEsp

Private cString := "SB1"


dbSelectArea("SB5")
dbSetOrder(1)

dbSelectArea("SB1")
Set filter To ( LEN(ALLTRIM(B1_COD)) > 7  .AND. B1_GRUPO <> 'F' .AND. B1_TIPO = 'PA' ) //.AND. Alltrim(B1_COD) $ "DDGAR1615" )
dbSetOrder(1)
SB1->(DbGotop())
while ! SB1->(EOF())
   cDesc := SB1->B1_DESC
// "SC.P/ LIXO 200L 90X108X0.002 PR MED PC C/ 100        "
   nPos1    := at( "X0.0", cDesc )
   IF nPos1 > 0 
      cAux1    := Substr( cDesc, nPos1-8, nPos1+8 )
      nPos2    := at( " ", cAux1 )
      cAux1    := Alltrim( Substr( cAux1, nPos2, Len( AllTrim( cAux1 ) ) ) )
      if at( " ", cAux1) > 0 
         cAux1    := AllTrim( Substr( cAux1, 1, at( " ", cAux1) ) )
      endif   
      if At( cAux1, cDesc ) > 0
         cNewDesc := AllTrim( StrTran( cDesc, cAux1, "AQUI" ) )
         SB5->( DbSeek(xFilial("SB5")+U_TransGen(SB1->B1_COD) ) )
         if SB5->B5_LARG > 0 .and. SB5->B5_COMPR > 0 .and. SB5->B5_ESPESS > 0 
            cNewDesc := AllTrim( StrTran( cNewDesc, "AQUI", Alltrim(Str(SB5->B5_LARG))+'.'+;
                                                            Alltrim(Str(SB5->B5_COMPR))+'.'+;
                                                            Alltrim(Str(SB5->B5_ESPESS))))  
            RecLock("SB1", .F. )
            SB1->B1_DESC := cNewDesc
            SB1->(MsUnlock())
         else
            Alert( "As dimensões do Produto: "+SB1->B1_COD+", não estão corretas. " )                                               
         endif

//         Alert( SB1->B1_COD+" "+cNewDesc )
      else
         Alert( "O Sistema não conseguiu alterar o Produto: "+SB1->B1_COD)
      endif
   endif
   SB1->(DbSkip())
end

Return