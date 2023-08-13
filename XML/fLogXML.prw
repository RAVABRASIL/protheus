// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : fLogXML
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 23/11/12 | Gustavo Costa 	 | Gera log da importação do XML
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#include "Fileio.ch"
#INCLUDE "PROTHEUS.CH"
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a geração de um arquivo formato texto usando a uma tabela como fonte de dados.

@author    TOTVS Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     23/11/2012
/*/
//------------------------------------------------------------------------------------------
User Function fLogXML(cTexto, lJob)


Local nHdl
Local cPathLog 		:= IIF(lJob,"\LOG\BKP\", "G:\Protheus10\Protheus_Data\LOG\BKP\")
Local cArqTxt 		:= cPathLog + DtoS(dDataBase) + ".log"
Local cLin				:= IIF(Empty(cTexto),"Arquivo vazio",cTexto)
Local nFinArq
Local nLinha
Local cEOL 			:= chr(13) + chr(10)
Local aFiles			:= {}
Local aSizes			:= {}
Local cFile			:= ""

//--< cria o arquivo de saida >-------------------------------------------------------------

ADir(cArqTxt, aFiles, aSizes)

If Len(aFiles) > 0

	cFile 		:= cPathLog + aFiles[1]
	nHdl    	:= fOpen(cFile,2)

	FSEEK(nHdl, 0, FS_END)

Else

	nHdl := fCreate(cArqTxt)

EndIf

if nHdl == -1
	conOut("Não foi possível criar o arquivo de saída."+chr(13)+"Favor verificar parâmetros.")
else
	
	if fWrite(nHdl, cLin) != len(cLin)
		conOut("Não gravou a linha no arquivo.")
	endif

endif
//--< encerramento >------------------------------------------------------------------------
fClose(nHdl)
//nDhl := nil

return
