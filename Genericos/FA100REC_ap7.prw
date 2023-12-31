#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA100REC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CARQ,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑A100REC  �                               � Data � 20/04/01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿝eplica pagto movimento bancario emp 01                     낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

if SM0->M0_CODIGO == "02" .and. SE5->E5_BANCO $ "CX1 004 030 001"
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Movimenta na   Rava                                          �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

   If Select( "XE5" ) == 0
      cArq := "SE5010"
      Use (cArq) ALIAS XE5 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   RecLock( "XE5", .t. )
   XE5->E5_FILIAL  := SE5->E5_FILIAL  ; XE5->E5_DATA    := SE5->E5_DATA
   XE5->E5_TIPO    := SE5->E5_TIPO    ; XE5->E5_MOEDA   := SE5->E5_MOEDA
   XE5->E5_VALOR   := SE5->E5_VALOR   ; XE5->E5_NATUREZ := SE5->E5_NATUREZ
   XE5->E5_BANCO   := SE5->E5_BANCO   ; XE5->E5_AGENCIA := SE5->E5_AGENCIA
   XE5->E5_CONTA   := SE5->E5_CONTA   ; XE5->E5_NUMCHEQ := SE5->E5_NUMCHEQ
   XE5->E5_DOCUMEN := SE5->E5_DOCUMEN ; XE5->E5_VENCTO  := SE5->E5_VENCTO
   XE5->E5_RECPAG  := SE5->E5_RECPAG  ; XE5->E5_BENEF   := SE5->E5_BENEF
   XE5->E5_HISTOR  := SE5->E5_HISTOR  ; XE5->E5_TIPODOC := SE5->E5_TIPODOC
   XE5->E5_VLMOED2 := SE5->E5_VLMOED2 ; XE5->E5_LA      := SE5->E5_LA
   XE5->E5_SITUACA := SE5->E5_SITUACA ; XE5->E5_LOTE    := SE5->E5_LOTE
   XE5->E5_PREFIXO := SE5->E5_PREFIXO ; XE5->E5_NUMERO  := SE5->E5_NUMERO
   XE5->E5_PARCELA := SE5->E5_PARCELA ; XE5->E5_CLIFOR  := SE5->E5_CLIFOR
   XE5->E5_LOJA    := SE5->E5_LOJA    ; XE5->E5_DTDIGIT := SE5->E5_DTDIGIT
   XE5->E5_TIPOLAN := SE5->E5_TIPOLAN ; XE5->E5_DEBITO  := SE5->E5_DEBITO
   XE5->E5_CREDITO := SE5->E5_CREDITO ; XE5->E5_MOTBX   := SE5->E5_MOTBX
   XE5->E5_RATEIO  := SE5->E5_RATEIO  ; XE5->E5_RECONC  := SE5->E5_RECONC
   XE5->E5_SEQ     := SE5->E5_SEQ     ; XE5->E5_DTDISPO := SE5->E5_DTDISPO
   XE5->E5_CCD     := SE5->E5_CCD     ; XE5->E5_CCC     := SE5->E5_CCC
   XE5->E5_OK      := SE5->E5_OK      ; XE5->E5_ARQRAT  := SE5->E5_ARQRAT
   XE5->E5_IDENTEE := SE5->E5_IDENTEE ; XE5->E5_FLSERV  := SE5->E5_FLSERV
   XE5->E5_ORDREC  := SE5->E5_ORDREC
   XE5->( MsUnlock() )
   XE5->( dbCommit() )
Endif

Return
