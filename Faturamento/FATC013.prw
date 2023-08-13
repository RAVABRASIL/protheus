#include 'RWMAKE.CH'
#include 'FONT.CH'
#include 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATC013   ºAutor  ³Eurivan MArques     º Data ³  05/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravacao do Pedido Internet                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


******************************************
user function FATC013(sCab,sItens,sPedido)
******************************************
local lOk := .T.
local nSaveSX8
local i,j
local aCab    := {}
local aItens  := {}
local aItensE := {}
local aItensF := {}
local cNumPV
local cCli
local cLoj

DbSelectArea("ZC5")
DbSetORder(5)

if !ZC5->( DbSeek( xFilial( "ZC5" )+sPedido ) )

   nSaveSX8:= GetSX8Len()
   aCabX   := Str2Arr(sCab,'|')   //separa os campos do cabecalho
   aItensX := Str2Arr(sItens,'#') //separa os registros do itens

   DbSelectArea("ZC5")
   DbSetORder(1)

   cNumPV:=GetSxeNum("ZC5","ZC5_NUM")
   while ZC5->( DbSeek( xFilial( "ZC5" )+cNumPV ) )
      ConfirmSX8()
      cNumPV  := GetSxeNum("ZC5","ZC5_NUM")
   end

   aCab := {{"ZC5_NUM"    ,cNumPV              , ''},;
            {"ZC5_TIPO"   ,'N'                 , ''}}
  
   //Cabecalho do Pedido
   for _x := 1 to Len(aCabX)
      aCabE := Str2Arr(aCabX[_x],'=')
      cTipo := TipoCpo( Alltrim( aCabE[1] ) )
      //se nao encontrar o tipo eh porque o campo nao existe
      if !Empty(cTipo)
         if cTipo == 'D'
            Aadd( aCab, { aCabE[1], CtoD( aCabE[2]), '' } )
         elseif cTipo == "N"
            Aadd( aCab, { aCabE[1], Val(strtran(aCabE[2], ',', '.')), '' } )
         else
            Aadd( aCab, { aCabE[1], aCabE[2], '' } )
         endif
      endif
      if Alltrim(aCabE[1]) == "ZC5_CLIENT"
         cCli := aCabE[2]
      elseif Alltrim(aCabE[1]) == "ZC5_LOJACL"
         cLoj := aCabE[2]
      endif   
   next _X
   
   DbSelectArea("SA1")
   DbSetOrder(1)
   SA1->( DbSeek(xFilial("SA1")+cCli+cLoj) )
      
   DbSelectArea("SZZ")
   DbSetOrder(2)
   SZZ->( DbSeek( xFilial("SZZ")+SA1->A1_COD_MUN+"S" ) )
   
   Aadd( aCab, { "ZC5_LOCALI", SA1->A1_COD_MUN, "" } )
   Aadd( aCab, { "ZC5_TRANSP", SZZ->ZZ_TRANSP , "" } )
      
   //Itens do Pedido
   for _x := 1 to Len(aItensX)
      Aadd( aItens, {{ "ZC6_ITEM",StrZero(_x,2), NIL }} )  
      aItemF := Str2Arr(aItensX[_x],'|')
      for _j := 1 to Len(aItemF)
         aItensE := Str2Arr(aItemF[_j],'=')
         cTipo := TipoCpo( Alltrim( aItensE[1] ) )
         //se nao encontrar o tipo eh porque o campo nao existe
         if !empty(cTipo)
            if cTipo == 'D'
               Aadd( aItens[_x], { aItensE[1], CtoD(aItensE[2]), '' } )
            elseif cTipo == 'N'
               Aadd( aItens[_x], { aItensE[1], Val(strtran(aItensE[2], ',', '.')), '' } )
            else
               Aadd( aItens[_x], { aItensE[1], aItensE[2], '' } )
            endif
         endif
      next _j
   end;
 
   lMsErroAuto := .F.

   //DbSetORder(4)
   //ZC5->(DbSeek(xFilial("ZC5")+ ))

   MSExecAuto({|x,y,z| U_FATC019(x,y,z)}, aCab, aItens, 3)
			
   if lMsErroAuto
      lOk := .F.
      RollBackSX8()  	
   else
      while ( GetSX8Len() > nSaveSX8 )
         ConfirmSX8()
      end
   endif
endif

return lOk


//ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
//³Função    ³Str2Arr³ Autor ³ Eurivan Marques      ³ Data ³19/10/2007    ³
//ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
//³Descrição ³Converte string em Array usando um separador de elementos   ³
//ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Str2Arr(cString,cToken,lUpper)
local aRet   := {}
local nToken
local cContent
Default cToken := "/"
Default lUpper := .T.

if right(cString,1) != cToken
   cString += cToken
endif   

nToken := At(cToken,cString)
while nToken > 0
    
    cContent := Substr(cString,1,nToken-1)
	if AllTrim(lower(cContent)) == "<vazio>"
	   cContent := ""
	endif   
	
	if lUpper	
		Aadd(aRet,UPPER(cContent))
	else
		Aadd(aRet,cContent)
	endif
	cString := Substr(cString,nToken+1,Len(cString)-(nToken))
	nToken  := At(cToken,cString)
end

return aRet



*********************************
static function TipoCpo( cCampo )
*********************************

local cRes := ""

dbSelectArea("SX3")
dbSetOrder(2)
if dbSeek( cCampo )
   cRes := SX3->X3_TIPO
endif

return cRes