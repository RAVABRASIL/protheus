***********************
user function FATC012(aCab, aItens)
***********************

if Empty(cPedido)
       
   cPedido := GetSxeNum("SC5","C5_NUM")
   DbSelectArea("SC5" )
   SC5->(DbSetOrder(1))
   if SC5->( DbSeek( xFilial( "SC5" )+cPedido ) )
      ConfirmSX8()
      cPedido  := GetSxeNum("SC5","C5_NUM")
   endif	    	       	   
endif		            
            
cCli:=ALLTRIM(Z55->Z55_CLIENT)
cLoja:=ALLTRIM(Z55->Z55_LOJA)
    
DbSelectArea("SA1" )
SA1->(DbSetOrder(1))
if SA1->( DbSeek( xFilial( "SA1" )+cCli ) )
   cVend:=SA1->A1_VEND
   cTipo:=SA1->A1_TIPO
endif
aCab := {{"C5_NUM"    , cPedido        , NIL},;
         {"C5_TIPO"   , 'N'            , NIL},;
         {"C5_CLIENTE", cCli           , ''},; 
         {"C5_LOJACLI", cLoja          , ''},;
         {"C5_LOCALIZ", Z55->Z55_LOCALI, ''},;
         {"C5_TRANSP" , Z55->Z55_TRANSP, ''},;                                                                                             
         {"C5_TIPOCLI", cTipo          , NIL},;
         {"C5_CONDPAG", "001"          , ''},;
         {"C5_VEND1"  , cVend          , NIL},;    
         {"C5_ENTREG" , dDataBase      , ''} }
   
_cNum:=Z55->Z55_NUM             

for _i := 1 to Len(aCab)
   Aadd(aItens, {{"C6_ITEM",StrZero(nIt,2)            ,NIL},;
                 {"C6_PRODUTO",Z55->Z55_PROD          ,NIL},;
                 {"C6_QTDVEN" ,Z55->Z55_QDTSOL        ,''},;
                 {"C6_TES"    ,'516'                  ,NIL},;
                 {"C6_LOCAL"  ,'03'                   ,NIL},;
                 {"C6_PRUNIT" ,VALORZ55(Z55->Z55_PROD),NIL}})
   nIt++
next _i
    
//Begin Transaction
if Len(aCab)>0 .AND. LEN(aItens)>0	      	  
   if Type("cPrePed") == "U" 
      cPrePed:=space(6)
   endif
endif
if Type("nComisN") == "U" 
   nComisN := 0
endif

		  
lMsErroAuto := .F.
MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCab, aItens, 3)
			
if lMsErroAuto
   RollBackSX8()  	
   MostraErro()
   Return
else
   while ( GetSX8Len() > nSaveSX8 )
      ConfirmSX8()
   end
endIf

return (!lMsErroAuto )