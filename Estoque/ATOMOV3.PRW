#INCLUDE "rwmake.ch"

//***************************************************************************
// Programa AtoMov3.prw  / Autor Edson  / Data 12/12/02 
// Descricao -> Lancamento de separação de materia prima 
//***************************************************************************

User Function ATOMOV3

Private cCadastro := "Lançamento de Separação"
Private aRotina   := { {"Pesquisar"  ,"AxPesqui"  ,0,1},;
                       {"Visualizar" ,"AxVisual"  ,0,2},;
                       {"Legenda"    ,"U_fMov3A()",0,4},;
                       {"Lançamentos","U_fMov3B()",0,4}}

aCores := { { '!Empty(C2_DATRF)'                                                                       ,'BR_VERMELHO'},; 
            { 'Empty(SC2->C2_StaDes)'                                                                  ,'BR_VERDE'   },;
            { 'SC2->C2_StaDes="SEPARADO"'                                                              ,'BR_AZUL'    },;
            { 'SC2->(C2_Produ>0 .and. (C2_CQ=0 .and. C2_Acaba=0 .and. C2_Final=0 .and. C2_Merca=0))'   ,'BR_AMARELO' },;
            { 'SC2->(C2_CQ>0    .and. (C2_Produ=0 .and. C2_Acaba=0 .and. C2_Final=0 .and. C2_Merca=0))','BR_PINK'    },;
            { 'SC2->(C2_Acaba>0 .and. (C2_CQ=0 .and. C2_Produ=0 .and. C2_Final=0 .and. C2_Merca=0))'   ,'BR_CINZA'   },;
            { 'SC2->(C2_Final>0 .and. (C2_CQ=0 .and. C2_Acaba=0 .and. C2_Produ=0 .and. C2_Merca=0))'   ,'BR_MARROM'  },;
            { 'SC2->(C2_Merca>0 .and. (C2_CQ=0 .and. C2_Acaba=0 .and. C2_Final=0 .and. C2_Produ=0))'   ,'BR_PRETO'   },;
            { 'SC2->(C2_Merca+C2_CQ+C2_Acaba+C2_Final)>0'                                              ,'BR_LARANJA' }}

MBrowse(6,1,21,74,"SC2",,,,,,aCores) 

Return



//--------------------------------------------------------------------------------------------------
User Function fMov3A()
cCadastro := "Legenda de Cores"
aCores2 := { { 'BR_VERMELHO', "OP Encerrada"},;
             { 'BR_VERDE'   , "Estoque     "},;
             { 'BR_AZUL'    , "Separado    "},;
             { 'BR_AMARELO' , "Produção    "},;
             { 'BR_PINK'    , "C.Q.        "},;
             { 'BR_CINZA'   , "Acabamento  "},;
             { 'BR_MARROM'  , "Teste Final "},;
             { 'BR_PRETO'   , "Mercado     "},;
             { 'BR_LARANJA' , "Consulta    "}}
BrwLegenda(cCadastro,"Legenda do Browse",aCores2)

Return



//--------------------------------------------------------------------------------------------------
User Function fMov3B()  

Local aTravas   :={},;
      cProximo  := "",;
      cSemSaldo := ""

Private lmsErroAuto := .f.
Private nNumSeq     := GetMv("MV_SEPNUM")
Private nPosCProd   := 1
 

if !Empty(SC2->C2_DATRF)
 MsgBox("Esta OP esta encerrada !!!","Status da OP","ALERT")
 Return
elseif !Empty(SC2->C2_StaDes) 
 MsgBox("Esta OP já foi separada !!!","Status da OP","ALERT")
 Return
elseif SC2->C2_StaDes="PRODUCAO" 
 MsgBox("Esta OP esta na produção !!!","Status da OP","ALERT")
 Return
endif


//PRIVATE cCusMed   := GetMv("mv_CusMed")

//Montando aHeader
dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("SD4")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SD4")
 IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .and. ;
    AllTrim(x3_campo)$"D4_COD,D4_LOCAL,D4_QUANT,D4_REQTD1,D4_SERLOT,D4_DATVAL,D4_SEPQTD,D4_SEPDAT,D4_REQTD2,D4_REQTD3,D4_QSUSP"
  nUsado++
  if AllTrim(x3_campo)="D4_REQTD1"
   vTit := "Lançamento"
  Elseif AllTrim(x3_campo)="D4_REQTD2"
   vTit := "Saldo"
  Elseif AllTrim(x3_campo)="D4_REQTD3"
   vTit := "Num.Reg."
  Elseif AllTrim(x3_campo)="D4_QSUSP"
   vTit := "Falta"
  else
   vTit := AllTrim(x3_titulo)
  endif
  AADD(aHeader,{ vTit, x3_campo, x3_picture,;
   x3_tamanho, x3_decimal,'U_fMov3A1("'+x3_campo+'")',;
   x3_usado, x3_tipo, x3_arquivo, x3_context } )
 Endif
 dbSkip()
End 


//Trata o aHeader (ordena)            
//               1         2          3           4          5           6           7          8           9          10           11         
aOrdem   := {"D4_COD","D4_QUANT","D4_LOCAL","D4_SEPQTD","D4_QSUSP","D4_REQTD1","D4_SERLOT","D4_DATVAL","D4_SEPDAT","D4_REQTD2","D4_REQTD3"}
aHeader2 := {}
For ed1=1 to len(aOrdem)
 For ed2=1 to len(aHeader)
  If aHeader[ed2,2] = aOrdem[ed1]
   AADD(aHeader2,aHeader[ed2])
   Exit
  Endif   
 Next  
Next 
aHeader := {}
aHeader := aHeader2


&&Grava variaveis com posicao
For i=1 to Len(aHeader)
 vCampo   := AllTrim(aHeader[i][2])
 vCampo   := Substr(vCampo,01,02)+Substr(vCampo,04,07)
 p&vCampo := i
next


//Montando aCols
dbSelectArea("SD4")          
DbSetOrder(2)
If DbSeek(xFilial("SC2")+SC2->C2_Num)
 Num := 1
 aCols := {}
 While Substr(SD4->D4_OP,01,11) == SC2->(C2_Num+C2_Item+C2_Sequen)
  aadd(aCOLS,Array(len(aHeader)+1) ) 
  For _ni:=1 to (len(aHeader))
   aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
  Next 
  aCols[Len(aCols),pD4QSUSP]       := SD4->(D4_Quant-(D4_SEPQTD+D4_REQTD1+D4_REQTD2+D4_REQTD3))
  aCols[Len(aCols),len(aHeader)]   := SD4->(Recno())  
  aCols[Len(aCols),len(aHeader)+1] := .F.
  SD4->(DbSkip())
 enddo 
else
 aCols := {}
 aadd(aCOLS,Array(len(aHeader)+1)) 
 For ed1=1 to len(aHeader)
  IF     aHeader[ed1][8] = "C"
   aCOLS[1][ed1] := SPACE(aHeader[1][4])
  Elseif aHeader[ed1][8] = "N"
   aCOLS[1][ed1] := 0
  Elseif aHeader[ed1][8] = "D"
   aCOLS[1][ed1] := dDataBase
  Elseif aHeader[ed1][8] = "M"
   aCOLS[1][ed1] := ""
  Else
   aCOLS[1][ed1] := .F.
  Endif
 Next
 aCOLS[1][ed1] := .F. 
endif


// Trata aCols (Valores)
For ed1=1 to len(aCOLS)

 vSaldo := U_SaldoAto(aCOLS[ed1][pD4Cod],"01")   &&Calcula saldo real
 vLanc  := aCOLS[ed1][pD4QUANT] - aCOLS[ed1][pD4SEPQTD]  && Calcula lancamento que deve ser realizado

 If SB1->(DbSeek(xFilial("SB1")+aCOLS[ed1][pD4Cod])) .and. SB1->B1_Tipo="MP"
  aCOLS[ed1][pD4REQTD1] := vLanc  &&Grava
 else
  aCOLS[ed1][pD4REQTD1] := 0      &&Grava
 endif 

 aCOLS[ed1][pD4REQTD2] := vSaldo    &&Grava
 aCOLS[ed1][pD4LOCAL]  := "02"      &&Local destino
 aCOLS[ed1][pD4SEPDAT] := dDataBase &&Data de Separação
 
 if vLanc>0 
  aCOLS[ed1][pD4SEPDAT] :=  dDataBase
 endif 

 If SB1->(DbSeek(xFilial("SB1")+aCOLS[ed1][pD4Cod])) .and. !SB1->B1_UsaSer$"S.L"
  aCOLS[ed1][pD4SERLOT] := Space(Len(aCOLS[ed1][pD4SERLOT]))
 Endif

Next


// Variaveis do Cabecalho do Modelo 2
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+SC2->C2_Produto))
cProduto := SC2->C2_Produto+" - "+SB1->B1_Desc
cOP      := SC2->C2_Num
cSepara  := Space(2)
cSaldo   := SC2->(C2_quant-C2_QUJE)
CLocSai  := "01"

aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.
AADD(aC,{"cProduto",{15,10} ,"Produto:"    ,"@!"      , , ,.f.})
AADD(aC,{"cOP"     ,{29,10} ,"OP:"	       ,"@!"      , , ,.f.})
AADD(aC,{"cSaldo"  ,{29,100},"Saldo da OP:","@E 9,999", , ,.f.})
AADD(aC,{"cSepara" ,{29,200},"Separador:"  ,"@!"      ,"!EMPTY(cSepara)",,.t.})
AADD(aC,{"CLocSai" ,{29,300},"Local Saida:","99"      ,"!EMPTY(cLocSai) .and. U_fMov3B1(cLocSai) ",,.t.})

// Variaveis do Rodape 
nLinGetD := 0
aR       := {}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
//AADD(aR,{"nLinGetD"	,{120,10},"Linha na GetDados"	,"@E 999",,,.F.})

//Titulo da Janela
cTitulo:="Lançamentos de Separação"

// Array com coordenadas da GetDados 
//aCGD:={44,5,118,315}
aCGD := {44,5,170,370}
             
// Array com coordenadas da GetDados 
//aCodJan := {183,145,452,950} 
aCodJan := {108,026,452,769}

// Chamada 
lRetorno := Modelo2(cTitulo,aC,aR,aCGD,,,,,,,,aCodJan,,)

If lRetorno

 // Verifica se tem itens sem o saldo
 aLotes := {}
 For ed1=1 to len(aCOLS)
  If SB1->(DbSeek(xFilial("SB1")+aCOLS[ed1][pD4COD])) .and. SB1->B1_UsaSer$"S.L" .and. ;
    !aCols[ed1][len(aCols[pD4COD])]  &&Se nao esta apagado
   cChave := aCOLS[ed1][pD4Cod]+aCOLS[ed1][pD4SerLot]
   nPos   := aScan(aLotes,{|x| x[6]=cChave})
   if nPos=0
    AAdd(aLotes,{;
    aCOLS[ed1][pD4COD],;
    aCOLS[ed1][pD4REQTD1],;
    aCOLS[ed1][pD4REQTD2],;
    aCOLS[ed1][pD4QUANT],;
    aCOLS[ed1][pD4SEPQTD],;
    aCOLS[ed1][pD4COD]+aCOLS[ed1][pD4SerLot]})
   else 
    aLotes[nPos][2] += aCOLS[ed1][pD4REQTD1]  // Lancto
    aLotes[nPos][4] += aCOLS[ed1][pD4QUANT]   // Empenhado
    aLotes[nPos][5] += aCOLS[ed1][pD4SEPQTD]  // Separado    
   endif
  endif
 Next

 cSemSaldo := ""
 For ed1=1 to len(aLotes)
  If aLotes[ed1][2] > aLotes[ed1][3] .and. !aCols[ed1][len(aCols[1])]  &&Se nao esta apagado
   cSemSaldo += aLotes[ed1][1]+" // "
  endif
 Next

 if !Empty(cSemSaldo) 
  if MsgBox("Itens sem saldo ->"+cSemSaldo+". Deseja imprimir ?","Controle de Saldo. Deseja imprimir ?","YESNO")
   U_fMov3A5()
  endif
  Return
 endif

 // Verifica se existem itens duplicados
 aCols2 := {}
 For ed1=1 to len(aCOLS)
  If !aCols[ed1][len(aCols[pD4COD])] .and. aCols[ed1][pD4REQTD1]>0  &&Se nao esta apagado / Se tem Valor a ser Lançado
   cChave := aCOLS[ed1][pD4COD]+aCOLS[ed1][pD4SERLOT]
   nPos   := aScan(aCols2,{|x| x[11]=cChave})
   if nPos=0
    AAdd(aCols2,{;
    aCOLS[ed1][pD4COD],;
    aCOLS[ed1][pD4QUANT],;
    aCOLS[ed1][pD4LOCAL],;
    aCOLS[ed1][pD4SEPQTD],;
    aCOLS[ed1][pD4QSUSP],;
    aCOLS[ed1][pD4REQTD1],;
    aCOLS[ed1][pD4SERLOT],;
    aCOLS[ed1][pD4DATVAL],;
    aCOLS[ed1][pD4SEPDAT],;
    aCOLS[ed1][pD4REQTD2],;
    aCOLS[ed1][pD4COD]+aCOLS[ed1][pD4SERLOT]})
   else 
    aCols2[nPos][pD4REQTD1] += aCOLS[ed1][pD4REQTD1]  // Lancto
   endif
  endif
 Next

 // Começa a movimentação do estoque
 vGravaOP := .F.
 cNumSeq  := U_fMov3A3()
 aTransfer := {{cNumSeq,dDataBase}}
  
 //cProximo := ProxNum()
 For ed1=1 to len(aCols2) 
   //  If !aCols[ed1][len(aCols[1])]  &&Se nao esta apagado
  If aCols2[ed1][pD4REQTD1]>0            && Se tem Valor a ser lancado
   vGravaOP := .T.
   cProximo := ProxNum()
   SB1->(DbSeek(xFilial("SB1")+aCols[ed1][pD4COD]))
   If "6.09"$cVersao
    AADD(aTransfer,{aCols2[ed1][pD4COD],SB1->B1_Desc,SB1->B1_UM,cLocSai              ,Space(15),;
                    aCols2[ed1][pD4COD],SB1->B1_Desc,SB1->B1_UM,aCols2[ed1][pD4LOCAL],Space(15),;   
                    Space(20),Space(10),Space(06),Ctod("  /  /  "),;
                    aCols2[ed1][pD4REQTD1],0,Space(1),cProximo,Space(06),Space(06)})
   else 
   /* AADD(aTransfer,{aCols2[ed1][pD4COD],SB1->B1_Desc,SB1->B1_UM,cLocSai              ,Space(15),;
                    aCols2[ed1][pD4COD],SB1->B1_Desc,SB1->B1_UM,aCols2[ed1][pD4LOCAL],Space(15),;   
                    Space(20),Space(10),Space(06),Ctod("  /  /  "),0,;
                    aCols2[ed1][pD4REQTD1],0,Space(1),	cProximo,Space(10)})
                    //Space(6)})
     */
    AADD(aTransfer,{aCols2[ed1][pD4COD],;
    						SB1->B1_Desc,;
    						SB1->B1_UM,;
    						cLocSai,;
    						Space(15),;
                     aCols2[ed1][pD4COD],;
                     SB1->B1_Desc,;
                     SB1->B1_UM,;
                     aCols2[ed1][pD4LOCAL],;
                     Space(15),;   
                    Space(20),;
                    Space(10),;
                    Space(06),;
                    Ctod("  /  /  "),;
                    0,;
                    aCols2[ed1][pD4REQTD1],;
                    0,;
                    Space(1),	;
                    cProximo,;
                    Space(10),;
                    Ctod("  /  /  ")})
/////////////////////////////////////////////////////////////
//                    Ctod("  /  /  "),;
//                    Space(6)})
   
   /*FR 05/04/06 - apos alterado para gravacao do campo D3_NUMORC, precisei acrescentar
     este ultimo Space(6) para contemplar o array com o D3_NUMORC.*/
   Endif
  Endif
   //  endif
 Next
 
 if len(aTransfer) < 2
  MsgBox("Não foram encontrados itens para efetuar a movimentação ?","Gerar Transferencia","ALERT")
 else
  MSExecAuto({|x,y| mata261(x,y)},aTransfer,3)
  if lmserroAuto 
   if MsgBox("Movimentação não foram geradas. Deseja visualizar o log ?","Gerar Transferencia","YESNO")
    MostraErro()
   endif 
  else
   For ed1=1 to len(aCols)
    If !aCols[ed1][len(aCols[1])]      && Se nao esta apagado
     If aCols[ed1][pD4REQTD1]>0        && Se tem Valor a ser lancado
      if aCols[ed1][len(aCols[1])-1]>0 && Nao esta incluindo
       SD4->(DbGoto(aCols[ed1][len(aCols[1])-1]))
       if SD4->(RecLock("SD4",.F.))
        SD4->D4_SepQtd += aCols[ed1][pD4REQTD1]
        SD4->D4_SepDat := aCols[ed1][pD4SEPDAT]
        SD4->D4_SepPes := cSepara
        SD4->D4_SerLot := aCols[ed1][pD4SerLot]
        SD4->D4_DatVal := aCols[ed1][pD4DatVal]
        SD4->(MsUnlock())
       endif 
       GravaEmp(aCols[ed1][pD4COD],;     //-- 01.Codigo do Produto
               "03",;                    //-- 02.Local
               aCols[ed1][pD4REQTD1],;   //-- 03.Quantidade
               aCols[ed1][pD4REQTD1],;   //-- 03.Quantidade 2
               Space(10),;               //-- 04.Lote
               NIL,;                     //-- 05.SubLote
 	           NIL,;                     //-- 06.Localiza‡Æo
	           NIL,;                     //-- 07.Numero de S‚rie
	           SD4->D4_OP,;              //-- 08.OP
	           "   ",;                   //-- 09.Seq. do Empenho/Libera‡Æo do PV (Pedido de Venda)
	           NIL,;                     //-- 10.PV
	           NIL,;                     //-- 11.Item do PV
	           'SC2',;                   //-- 12.Origem do Empenho
	           Nil,;                     //-- 13.OP Original
	           SD4->D4_Data,;            //-- 14.Data da Entrega do Empenho
	           @aTravas,;                //-- 15.Array para Travamento de arquivos
               .F.,;                     //-- 16.Estorna Empenho?
	           Nil,;                     //-- 17. chamada da Proje‡Æo de Estoques?
	           .F.,;                     //-- 18.Empenha no SB2?
	           .F.,;                     //-- 19.Grava SD4?
               .T.,;                     //-- 20.Considera Lotes Vencidos?
               .F.,;                     //-- 21.Empenha no SB8/SBF?
               .F.)                      //-- 22.Cria SDC?
       MaDesTrava(aTravas)
      
      else
       GravaEmp(aCols[ed1][pD4COD],;      //-- 01.Codigo do Produto
                "03",;                    //-- 02.Local
                aCols[ed1][pD4QUANT],;    //-- 03.Quantidade
                aCols[ed1][pD4QUANT],;    //-- 03.Quantidade 2
                Space(10),;               //-- 04.Lote
                NIL,;                     //-- 05.SubLote
                NIL,;                     //-- 06.Localiza‡Æo
 	            NIL,;                     //-- 07.Numero de S‚rie
 	            SC2->(C2_Num+C2_Item+C2_Sequen),; //-- 08.OP
	            "   ",;                   //-- 09.Seq. do Empenho/Libera‡Æo do PV (Pedido de Venda)
	            NIL,;                     //-- 10.PV
	            NIL,;                     //-- 11.Item do PV
                'SC2',;                   //-- 12.Origem do Empenho
                Nil,;                     //-- 13.OP Original
	            SC2->C2_DatPrF,;          //-- 14.Data da Entrega do Empenho
	            @aTravas,;                //-- 15.Array para Travamento de arquivos
	            .F.,;                     //-- 16.Estorna Empenho?
	            Nil,;                     //-- 17.chamada da Proje‡Æo de Estoques?
	            .T.,;                     //-- 18.Empenha no SB2?
	            .T.,;                     //-- 19.Grava SD4?
                .T.,;                     //-- 20.Considera Lotes Vencidos?
                .F.,;                     //-- 21.Empenha no SB8/SBF?
                .F.)                      //-- 22.Cria SDC?
       MaDesTrava(aTravas)
       if SD4->(RecLock("SD4",.F.))
        SD4->D4_SepQtd += aCols[ed1][pD4REQTD1]
        SD4->D4_SepDat := aCols[ed1][pD4SEPDAT]
        SD4->D4_SepPes := cSepara
        SD4->D4_SerLot := aCols[ed1][pD4SerLot]
        SD4->D4_DatVal := aCols[ed1][pD4DatVal]
        SD4->(MsUnlock())
       endif 
      endif
     Endif  
    else
     //if aCols[ed1][len(aCols[1])-1]>0 .and. SD4->(RecLock("SD4",.T.))  && FR 16/10/06 erro no sql duplicate key.
     if aCols[ed1][len(aCols[1])-1]>0 .and. SD4->(RecLock("SD4",.F.))
      SD4->(DbGoto(aCols[ed1][len(aCols[1])-1]))
      if SD4->(RecLock("SD4",.F.))
       GravaEmp(aCols[ed1][pD4COD],;     //-- 01.Codigo do Produto
               "03",;                    //-- 02.Local
               aCols[ed1][pD4QUANT],;    //-- 03.Quantidade
               aCols[ed1][pD4QUANT],;    //-- 03.Quantidade 2
               Space(10),;               //-- 04.Lote
               NIL,;                     //-- 05.SubLote
 	           NIL,;                     //-- 06.Localiza‡Æo
	           NIL,;                     //-- 07.Numero de S‚rie
	           SD4->D4_OP,;              //-- 08.OP
	           "   ",;                   //-- 09.Seq. do Empenho/Libera‡Æo do PV (Pedido de Venda)
	           NIL,;                     //-- 10.PV
	           NIL,;                     //-- 11.Item do PV
	           'SC2',;                   //-- 12.Origem do Empenho
	           Nil,;                     //-- 13.OP Original
	           SD4->D4_Data,;            //-- 14.Data da Entrega do Empenho
	           @aTravas,;                //-- 15.Array para Travamento de arquivos
               .T.,;                     //-- 16.Estorna Empenho?
	           Nil,;                     //-- 17. chamada da Proje‡Æo de Estoques?
	           .F.,;                     //-- 18.Empenha no SB2?
	           .F.,;                     //-- 19.Grava SD4?
               .T.,;                     //-- 20.Considera Lotes Vencidos?
               .F.,;                     //-- 21.Empenha no SB8/SBF?
               .F.)                      //-- 22.Cria SDC?
       SD4->(DbDelete())  
       MsUnlock()
      endif 
     endif 
    endif 
   Next 
   
   If vGravaOP .and. SC2->(RecLock("SC2",.F.)) .and. Empty(SC2->C2_StaDes)
    SC2->C2_StaDes := "SEPARADO" 
    SC2->C2_StaDat := dDataBase 
   endif
   
  endif 
 Endif 
Endif

PutMV("MV_SEPNUM",StrZero(nNumSeq,5))

Return
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
User Function fMov3A1(pCampo)        
Local cAlias := ALIAS(),;
      aAlias := {"SZE"},;
        aAmb := U_GETAMB( aAlias ),;
        vRet := .t.

if pCampo = "D4_COD" &&Codigo do produto
 if empty(m->&pCampo) 
  MsgBox("Produto deve ser digitado !!!","ALERT")
  vRet := .F.
 else 
  if m->&pCampo # aCols[n][1] .and. !Empty(aCols[n][1])
   MsgBox("Produto não deve ser alterado !!!","ALERT")
   vRet := .F.
  else
   SB1->(DBSetOrder(1))
   if SB1->(!DbSeek(xFilial("SB1")+m->&pCampo))
    MsgBox("Produto não existe !!!","ALERT")
    vRet := .F.
   endif
  endif
 endif 
 
elseif pCampo = "D4_QUANT" &&Codigo do produto
 if aCols[ed1][len(aCols[1])-1]>0 
  MsgBox("Quantidade empenhada não deve ser alterada !!!","ALERT")
  vRet := .F.
 endif

elseif pCampo = "D4_LOCAL" &&Codigo do produto
	If Empty(m->&pCampo) 
		MsgBox("Local deve ser digitado !!!","ALERT")
		vRet := .F.
	Else
		vRet	:= U_VldAlmox(m->&pCampo)
	Endif

elseif pCampo = "D4_SEPQTD" &&Quantidade separada
 MsgBox("Quantidade que foi separada não deve ser alterada !!!","ALERT")
 vRet := .F.

elseif pCampo = "D4_REQTD1" &&Quantidade Lancamento
 if (aCOLS[n][2] - aCOLS[n][4]) < m->&pCampo 
  MsgBox("Quantidade separada Superior a quantidade disponivel !!!","ALERT")
  m->&pCampo := (aCOLS[n][2] - aCOLS[n][4]) 
  vRet := .F.
 endif

elseif pCampo = "D4_SERLOT" &&Numero do lote
 SZE->(DbSetOrder(1))
 SB1->(DbSetOrder(1))
 lExiste := .f.
 If SZE->(!DbSeek(xFilial("SZE")+"C"+m->&pCampo)) .and. ;
    SZE->(!DbSeek(xFilial("SZE")+"E"+m->&pCampo))
  MsgBox(" Não houve entrada deste lote no local 01 !!!","ALERT")
 endif
 If SB1->(!DbSeek(xFilial("SB1")+aCols[n][pD4COD])) .or. !SB1->B1_UsaSer="L"
  MsgBox("Não existe controle de lote do produto -> "+aCols[n][pD4COD],"ALERT")
 endif

elseif pCampo = "D4_DATVAL" &&Data validade do lote

elseif pCampo = "D4_SEPDAT"  &&Data da separação
 
elseif pCampo = "D4_REQTD2" &&Saldo em estoque
 MsgBox("Quantidade de saldo em estoque !!!","ALERT")
 vRet := .F.

endif    


DBSELECTAREA(cAlias)

U_RESTAMB( aAmb )


Return(vRet)
//--------------------------------------------------------------------------------------------------------------
User Function fMov3A3        
Local aAlias := {"SD3"},;
        aAmb := U_GETAMB( aAlias ),;
        vRet := 0,;
        nNumSeq2 := nNumSeq
        cNumSeq2 := "S"+StrZero(nNumSeq,5)

SD3->(DbSetOrder(2))
While .T.
 cNumSeq2 := "S"+StrZero(nNumSeq2,5)
 IF SD3->(DbSeek(xFilial("SD3")+cNumSeq2))
  nNumSeq2++
 ElseIF nNumSeq2>99999
  MsgBox("O numero automatico do documento superou a capacidade !!!","ALERT")
  Exit
 else
  Exit 
 endif
Enddo 

U_RESTAMB( aAmb )
Return(cNumSeq2)
//--------------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------------
User Function fMov3A5        
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "para efetuar um apontamento dos produtos sem saldo."
Local cDesc3       := "                                                   "
Local cPict        := ""
Local titulo       := "RELATORIO CONTROLE DE ESTOQUE"
Local nLin         := 80
Local Cabec1       := "Produto                                          OP    Empenhado  Separada Lançamento    Inventario"
Local Cabec2	   := "LC     Qtd    LC     Qtd    LC     Qtd    LC     Qtd    LC     Qtd    LC     Qtd    LC     Qtd     "
//                     123456789012345 123456789012345678901234567890 123456  1.345.789 1.345.789  1.345.789     1.345.789
//                     12-1.345.789  12-1.345.789  12-1.345.789  12-1.345.789  12-1.345.789  12-1.345.789  12-1.345.789

Local imprime      := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "MOV3" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := ""
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ATOMOV3" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SD1"
                     
//pergunte(cPerg,.T.)  
   

dbSelectArea("SD1")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
 Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return
//--------------------------------------------------------------------------------------------------------------

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aAlias := {"SB8"},;
        aAmb := U_GETAMB( aAlias )

SB8->(DbSetOrder(3))  //Filial+Produto+Local+LoteCtl

For ed1=1 to len(aLotes)

 If aLotes[ed1][2] > aLotes[ed1][3]

  aLotes2 := {}
  If SB2->(DbSeek(xFilial("SB2")+aCOLS[ed1][1]))
   While SB2->(!Eof()) .and. SB2->B2_Cod = aCOLS[ed1][1]
    AAdd(aLotes2,{U_SaldoAto(SB2->B2_Cod,SB2->B2_Local),SB2->B2_Local})
    SB2->(DbSkip())
   Enddo
  Endif

  If lAbortPrint
   @ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
   Exit
  Endif

  If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 9
  Endif  

  SB1->(DbSeek(xFilial("SB1")+aCOLS[ed1][1]))
  @ nLin,000 PSay aLotes[ed1][1]+"-"+SB1->B1_Desc+" "+;
                  SC2->C2_Num+"  "+;
                  Transf(aLotes[ed1][4],"@E 9,999,999")+" "+;
                  Transf(aLotes[ed1][5],"@E 9,999,999")+"  "+;
                  Transf(aLotes[ed1][2],"@E 9,999,999")+"   _____________" 
  nLin ++

  nConta := 1
  While nConta <= Len(aLotes2) 
   cLinha := ""  
   For i=1 to 5 
    if i <= Len(aLotes2)
     cLinha += aLotes2[i][2]+"-"+Transf(aLotes2[i][1],"@E 9,999,999")+"  "
     nConta++
    else
     exit
    endif
   Next
   @ nLin,000 PSay cLinha
   nLin ++
  
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    @ nLin,000 PSay aCOLS[ed1][1]+"-"+SB1->B1_Desc+" "+;
                    SC2->C2_Num+"  "+;
                    Transf(aLotes[ed1][4],"@E 9,999,999")+" "+;
                    Transf(aLotes[ed1][5],"@E 9,999,999")+"  "+;
                    Transf(aLotes[ed1][2],"@E 9,999,999")+"   _____________" 
    nLin := 8
   Endif  
  enddo  
  
  @ nLin,000 PSAY REPLICATE("=",LIMITE)
  nLin++
 Endif
 
Next

@ nLin,000 PSAY "242424#24/A"
nLin++

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

   
U_RESTAMB( aAmb )

Return
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Recalcula o saldo e quantidade disponivel para efetuar o lancamento -----------------------------
//--------------------------------------------------------------------------------------------------
User Function fMov3B1(pLocal)

For ed1=1 to len(aCOLS)

 aCOLS[ed1][pD4REQTD2] := U_SaldoAto(aCOLS[ed1][pD4Cod],"01")   &&Calcula saldo real
 if aCOLS[ed1][pD4REQTD2]<0
  aCOLS[ed1][pD4REQTD2] := 0
 Endif

 vLanc := aCOLS[ed1][pD4QUANT] - aCOLS[ed1][pD4SEPQTD]  && Calcula lancamento que deve ser realizado
 if vLanc > aCOLS[ed1][pD4REQTD2]
  vLanc := aCOLS[ed1][pD4REQTD2]
 endif
  
 If SB1->(DbSeek(xFilial("SB1")+aCOLS[ed1][pD4Cod])) .and. SB1->B1_Tipo="MP"
  aCOLS[ed1][pD4REQTD1] := vLanc  &&Grava
 else
  aCOLS[ed1][pD4REQTD1] := 0      &&Grava
 endif 

 if vLanc>0 
  aCOLS[ed1][pD4SEPDAT] :=  dDataBase
 else
  aCOLS[ed1][pD4SEPDAT] :=  Ctod("  /  /  ")
 endif 

Next

Return(.t.)

//--------------------------------------------------------------------------------------------------------------
/*
Funcao Utilizada para efetuar a transferencia de produtos de almox -> A260Processa
Parametros  ExpC01: Codigo do Produto Origem - Obrigatorio 
            ExpC02: Almox Origem             - Obrigatorio 
            ExpN01: Quantidade 1a UM         - Obrigatorio              
            ExpC03: Documento                - Obrigatorio              
            ExpD01: Data                     - Obrigatorio              
            ExpN02: Quantidade 2a UM                                    
            ExpC04: Sub-Lote                 - Obrigatorio se Rastro "S"
            ExpC05: Lote                     - Obrigatorio se usa Rastro
            ExpD02: Validade                 - Obrigatorio se usa Rastro
            ExpC06: Numero de Serie                                     
            ExpC07: Localizacao Origem                                  
            ExpC08: Codigo do Produto Destino- Obrigatorio              
            ExpC09: Almox Destino            - Obrigatorio              
            ExpC10: Localizacao Destino                                 
            ExpL01: Indica se movimento e estorno                       
            ExpN03: Numero do registro original (utilizado estorno)     
            ExpN04: Numero do registro destino (utilizado estorno)      
            ExpC11: Indicacao do programa que originou os lancamentos   
            ExpC12: cEstFis    - Estrutura Fisica          (APDL)       
            ExpC13: cServico   - Servico                   (APDL)       
            ExpC14: cTarefa    - Tarefa                    (APDL)       
            ExpC15: cAtividade - Atividade                 (APDL)       
            ExpC16: cAnomalia  - Houve Anomalia? (S/N)     (APDL)       
            ExpC17: cEstDest   - Estrututa Fisica Destino  (APDL)       
            ExpC18: cEndDest   - Endereco Destino          (APDL)       
            ExpC19: cHrInicio  - Hora Inicio               (APDL)       
            ExpC20: cAtuEst    - Atualiza Estoque? (S/N)   (APDL)       
            ExpC21: cCarga     - Numero da Carga           (APDL)       
            ExpC22: cUnitiza   - Numero do Unitizador      (APDL)       
            ExpC23: cOrdTar    - Ordem da Tarefa           (APDL)       
            ExpC24: cOrdAti    - Ordem da Atividade        (APDL)       
            ExpC25: cRHumano   - Recurso Humano            (APDL)       
            ExpC26: cRFisico   - Recurso Fisico            (APDL)       
*/
