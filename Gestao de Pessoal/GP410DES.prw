/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP410DES  �Autor  �Eurivan Marques     � Data �  25/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na geracao de cnab folha, separarar Conta  ���
���          �Corrente de Conta Poupanca.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Gestao de Pessoal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GP410DES()

local cConta
local lNPula := .T.

//MV_PAR32 = 1 //Conta Corrente
//MV_PAR32 = 2 //Conta Poupanca

// apos  atualizacao 

//MV_PAR33 = 1 //Conta Corrente
//MV_PAR33 = 2 //Conta Poupanca

DbSelectArea("SRA")
cConta := Alltrim( SRA->RA_CTDEPSA )

if MV_PAR33 = 1 
   if IsPoup( cConta )
      lNPula := .F.
   endif
elseif MV_PAR33 = 2
   if ! IsPoup( cConta )
      lNPula := .F.
   endif  
endif

return lNPula


********************************
static function IsPoup( cConta )
********************************

local lPoup := SUBS( cConta, 1, 3 ) == "100" .and. Len( cConta ) > 7

return lPoup