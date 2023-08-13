User Function SegCli()

local lOk := .T.
Local cCliente := M->C5_CLIENTE
Local cLoja    := ""

If Empty(cLoja)
   cLoja:= posicione("SA1",1, xFilial("SA1")+ cCliente, "A1_LOJA" )
    //cLoja:='01'    
Endif


if ! M->C5_TIPO $ "B/D"
   DbSelectArea("SA1")
   DbSetOrder(1)

   SA1->(DbSeek(xFilial("SA1")+ cCliente + cLoja )) //M->C5_CLIENTE))
   if Empty(SA1->A1_SATIV1)
      Alert("O Cliente não possui uma associação a um segmento. Favor atualize o cadastro de Cliente.")
      lOk := .F.
   endif
endif

return lOk