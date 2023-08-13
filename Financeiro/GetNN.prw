//Retorna o campo nosso numero do titulo
//Eurivan MArques Candido - 10/04/08
*********************
User Function GetNN()
*********************
local cNN
if SUBSTR(SE1->E1_NUMBCO,1,6) == Alltrim(GetMV("MV_CONVBB"))
   cNN := ALLTRIM(SE1->E1_NUMBCO)
else
   cNN := "00000000000"
endif

return cNN


//Retorna o Convenio
//Eurivan Marques Candido - 10/04/08
*********************
User Function GetConv()
*********************
local cNN
if SUBSTR(SE1->E1_NUMBCO,1,6) == Alltrim(GetMV("MV_CONVBB"))
   cNN := ALLTRIM(GETMV("MV_CONVBB"))
else
   cNN := "017382"
endif

return cNN


//Retorna o DV do nosso numero do titulo
//Eurivan Marques Candido - 10/04/08
*********************
User Function GetDVNN()
*********************
local cNN
if SUBSTR(SE1->E1_NUMBCO,1,6) == Alltrim(GetMV("MV_CONVBB"))
   cNN := SUBSTR(SE1->E1_NUMBCO,12,1)
else
   cNN := "0"
endif

return cNN


//Retorna a carteira
//Eurivan Marques Candido - 10/04/08
*********************
User Function GetCar()
*********************
local cNN
if SUBSTR(SE1->E1_NUMBCO,1,6) == Alltrim(GetMV("MV_CONVBB"))
   cNN := "17" //Boleto impresso e emitido na Empresa
else
   cNN := "11" //Boleto impresso e emitido pelo Banco
endif

return cNN


//Retorna o versao da carteira
//Eurivan MArques Candido - 10/04/08
*********************
User Function GetVC()
*********************
local cNN
if SUBSTR(SE1->E1_NUMBCO,1,6) == Alltrim(GetMV("MV_CONVBB"))
   cNN := "027"
else
   cNN := "019"
endif

return cNN
