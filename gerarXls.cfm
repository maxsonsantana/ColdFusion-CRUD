<cfprocessingdirective pageEncoding="UTF-8">
<cfcontent type="application/vnd.ms-excel">
<cfheader name="Content-Disposition" value="attachment; filename=lista_pessoas.xls">

<!--- Configuração do banco --->
<cfset DSN = "max1">

<!--- Buscar dados da tabela --->
<cfquery name="pessoa" datasource="#DSN#">
    SELECT id, nome, sobrenome, idade FROM pessoa ORDER BY id DESC
</cfquery>

<!--- Início do XML do Excel --->
<cfoutput>
<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
          xmlns:o="urn:schemas-microsoft-com:office:office"
          xmlns:x="urn:schemas-microsoft-com:office:excel"
          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
          xmlns:html="http://www.w3.org/TR/REC-html40">

    <Worksheet ss:Name="Pessoas">
        <Table>

            <!--- Cabeçalhos ---> 
            <Row>
                <Cell><Data ss:Type="String">ID</Data></Cell>
                <Cell><Data ss:Type="String">Nome</Data></Cell>
                <Cell><Data ss:Type="String">Sobrenome</Data></Cell>
                <Cell><Data ss:Type="String">Idade</Data></Cell>
            </Row>

            <!--- Loop para os dados ---> 
            <cfloop query="pessoa">
                <Row>
                    <Cell><Data ss:Type="Number">#pessoa.id#</Data></Cell>
                    <Cell><Data ss:Type="String">#pessoa.nome#</Data></Cell>
                    <Cell><Data ss:Type="String">#pessoa.sobrenome#</Data></Cell>
                    <Cell><Data ss:Type="Number">#pessoa.idade#</Data></Cell>
                </Row>
            </cfloop>
        </Table>
    </Worksheet>
</Workbook>
</cfoutput>
