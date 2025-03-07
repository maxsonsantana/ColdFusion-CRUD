<cfprocessingdirective pageEncoding="UTF-8">
<cfcontent type="text/html; charset=UTF-8">
<cfset SetEncoding("Form", "utf-8")>
<cfset SetEncoding("URL", "utf-8")>

<!--- Configuração do banco --->
<cfset DSN = "max1">

<cfparam name="form.nome" default="">

<!--- Consulta para buscar pessoas pelo nome --->
<cfquery name="resultado" datasource="#DSN#">
    SELECT p.*, pr.nome AS nome_profissao
    FROM pessoa p
    JOIN profissao pr ON p.id_profissao = pr.id
    WHERE p.nome LIKE <cfqueryparam value="%#form.nome#%" cfsqltype="cf_sql_varchar">
    ORDER BY p.nome ASC
    LIMIT 10
</cfquery>

<!--- Retornar os resultados em formato HTML --->
<cfoutput>
    <cfloop query="resultado">
        <tr>
            <td>#resultado.id#</td>
            <td>#resultado.nome#</td>
            <td>#resultado.sobrenome#</td>
            <td>#resultado.idade#</td>
            <td>#resultado.nome_profissao#</td>
            <td class="text-center">
                <a href="index.cfm?acao=editar&id=#resultado.id#" class="btn btn-warning btn-sm">✏️ Editar</a>
                <a href="index.cfm?acao=excluir&id=#resultado.id#" class="btn btn-danger btn-sm" onclick="return confirm('Tem certeza que deseja excluir?');">🗑 Excluir</a>
            </td>
        </tr>
    </cfloop>
</cfoutput>