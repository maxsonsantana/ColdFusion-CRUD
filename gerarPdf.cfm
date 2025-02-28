<cfprocessingdirective pageEncoding="UTF-8">
<cfcontent type="text/html; charset=UTF-8">
<cfset SetEncoding("Form", "utf-8")>
<cfset SetEncoding("URL", "utf-8")>

<!--- Configuração do banco --->
<cfset DSN = "max1">

<!--- Buscar dados da tabela --->
<cfquery name="pessoa" datasource="#DSN#">
    SELECT * FROM pessoa ORDER BY id DESC
</cfquery>

<!--- Forçar o download do PDF --->
<cfheader name="Content-Disposition" value="attachment; filename=lista_pessoas.pdf">
<cfcontent type="application/pdf">

<!--- Gerar o PDF --->
<cfdocument format="pdf" pagetype="A4" orientation="portrait" margintop="0.5" marginbottom="0.5" marginleft="0.5" marginright="0.5">
    <html>
        <head>
            <style>
                body {
                    font-family: Arial, sans-serif;
                }
                h1 {
                    text-align: center;
                    color: #333;
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }
                th, td {
                    border: 1px solid #000;
                    padding: 8px;
                    text-align: left;
                }
                th {
                    background-color: #f2f2f2;
                    font-weight: bold;
                }
            </style>
        </head>
        <body>
            <h1>Lista de Pessoas</h1>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome</th>
                        <th>Sobrenome</th>
                        <th>Idade</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="pessoa">
                        <tr>
                            <td>#pessoa.id#</td>
                            <td>#pessoa.nome#</td>
                            <td>#pessoa.sobrenome#</td>
                            <td>#pessoa.idade#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </body>
    </html>
</cfdocument>