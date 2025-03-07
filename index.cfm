<cfprocessingdirective pageEncoding="UTF-8">
<cfcontent type="text/html; charset=UTF-8">
<cfset SetEncoding("Form", "utf-8")>
<cfset SetEncoding("URL", "utf-8")>

<cfparam name="form.id" default="">
<cfparam name="form.nome" default="">
<cfparam name="form.sobrenome" default="">
<cfparam name="form.idade" default="">
<cfparam name="form.id_profissao" default="">
<cfparam name="form.nome_profissao" default="">
<cfparam name="url.acao" default="">
<cfparam name="url.id" default="">

<!--- Configuração do banco --->
<cfset DSN = "max1">

<!--- BUSCAR DADOS PARA EDIÇÃO --->
<cfif structKeyExists(url, "acao") AND url.acao EQ "editar" AND structKeyExists(url, "id")>
    <cfquery name="dados_editar" datasource="#DSN#">
        SELECT p.*, pr.nome AS nome_profissao
        FROM pessoa p
        JOIN profissao pr ON p.id_profissao = pr.id
        WHERE p.id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif dados_editar.recordcount EQ 1>
        <cfset form.id = dados_editar.id>
        <cfset form.nome = dados_editar.nome>
        <cfset form.sobrenome = dados_editar.sobrenome>
        <cfset form.idade = dados_editar.idade>
        <cfset form.nome_profissao = dados_editar.nome_profissao>
        <cfset form.id_profissao = dados_editar.id_profissao>
    </cfif>
</cfif>

<!--- INSERIR DADOS --->
<cfif structKeyExists(url, "acao") AND url.acao EQ "inserir">
    <cfquery datasource="#DSN#">
        INSERT INTO pessoa (NOME, SOBRENOME, IDADE, ID_PROFISSAO)
        VALUES (
            <cfqueryparam value="#form.nome#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.sobrenome#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.idade#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.id_profissao#" cfsqltype="cf_sql_integer">
        )
    </cfquery>
    <cflocation url="index.cfm" addtoken="false">
</cfif>

<!--- EDITAR DADOS --->
<cfif structKeyExists(url, "acao") AND url.acao EQ "salvar" AND structKeyExists(url, "id")>
    <cfquery datasource="#DSN#">
        UPDATE pessoa 
        SET nome = <cfqueryparam value="#form.nome#" cfsqltype="cf_sql_varchar">,
            sobrenome = <cfqueryparam value="#form.sobrenome#" cfsqltype="cf_sql_varchar">,
            idade = <cfqueryparam value="#form.idade#" cfsqltype="cf_sql_integer">,
            id_profissao = <cfqueryparam value="#form.id_profissao#" cfsqltype="cf_sql_integer">
        WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cflocation url="index.cfm" addtoken="false">
</cfif>

<!--- EXCLUIR DADOS --->
<cfif structKeyExists(url, "acao") AND url.acao EQ "excluir" AND structKeyExists(url, "id")>
    <cfquery datasource="#DSN#">
        DELETE FROM pessoa WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cflocation url="index.cfm" addtoken="false">
</cfif>

<!--- LISTAR TODOS OS USUÁRIOS --->
<cfquery name="pessoa" datasource="#DSN#">
    SELECT p.* , pr.nome AS nome_profissao
    FROM pessoa p
    JOIN profissao pr ON p.id_profissao = pr.id
    ORDER BY id DESC
</cfquery>

<!--- Importando o Bootstrap --->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="style.css">

<cfoutput>
    <!-- Modal -->
    <div class="modal fade" id="pessoaModal" tabindex="-1" aria-labelledby="pessoaModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="pessoaModalLabel"><cfif form.id EQ ''>Adicionar Pessoa<cfelse>Editar Pessoa</cfif></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="index.cfm?acao=<cfif form.id EQ ''>inserir<cfelse>salvar&id=#form.id#</cfif>" method="post">
                        <input type="hidden" name="id" value="#form.id#">

                        <div class="mb-3">
                            <label class="form-label">Nome:</label>
                            <input type="text" class="form-control" name="nome" value="#form.nome#" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Sobrenome:</label>
                            <input type="text" class="form-control" name="sobrenome" value="#form.sobrenome#" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Idade:</label>
                            <input type="number" class="form-control" name="idade" value="#form.idade#" required>
                        </div>

                        <!--- Consulta ao banco para obter as profissões --->
                        <cfquery name="getProfissoes" datasource="#DSN#">
                            SELECT id, nome FROM profissao ORDER BY nome ASC
                        </cfquery>

                        <div class="mb-3">
                            <label class="form-label">Profissão:</label>
                            <select name="nome_id_profissao" id="nome_id_profissao" class="form-control">
                                <option value="">Selecione...</option>
                                <cfloop query="getProfissoes">
                                    <option value="#id#" <cfif form.id_profissao EQ id>selected</cfif>>#nome#</option>
                                </cfloop>
                            </select>
                        </div>

                        <div class="mb-3 readonly">
                            <label class="form-label">ID Profissão:</label>
                            <input type="text" class="form-control" name="id_profissao" id="id_profissao" value="#form.id_profissao#" required readonly>
                        </div>

                        <!--- Script para atualizar o campo id_profissao --->
                        <script>
                            document.addEventListener("DOMContentLoaded", function() {
                                const dropdown = document.getElementById("nome_id_profissao");
                                const idProfissaoInput = document.getElementById("id_profissao");

                                dropdown.addEventListener("change", function() {
                                    idProfissaoInput.value = dropdown.value;
                                });
                            });
                        </script>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="window.location.href='index.cfm'">Cancelar</button>
                            <button type="submit" class="btn btn-success">
                                <cfif form.id EQ ''>Adicionar<cfelse>Salvar</cfif>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</cfoutput>

<head>
    <title>Menu ColdFusion</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="style.css">
</head>

<!---MENU--->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.cfm">CRUD CouldFusion</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a href="#" class="nav-link btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#pessoaModal">
                        <cfif form.id EQ ''>Adicionar Pessoa<cfelse>Editar Pessoa</cfif>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="gerarPDF.cfm" class="nav-link btn btn-info me-2" target="_blank">📄 Gerar PDF</a>
                </li>
                <li class="nav-item">
                    <a href="gerarXLS.cfm" class="nav-link btn btn-success" target="_blank">📊 Gerar XLS</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!--- Campo de Pesquisa --->
<div class="mb-3">
    <input type="text" id="pesquisaNome" class="form-control" placeholder="🔍 Digite um nome para buscar..." onkeyup="buscarPessoa()">
</div>

<!--- LISTA DE USUÁRIOS --->
<cfoutput>
    <div class="container mt-4" id="listaUsers">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">Lista de Pessoas</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-custom">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Sobrenome</th>
                                <th>Idade</th>
                                <th>Profissão</th>
                                <th class="text-center">Ações</th>
                            </tr>
                        </thead>
                        <tbody id="resultadoPesquisa">
                            <cfloop query="pessoa">
                                <tr>
                                    <td>#pessoa.id#</td>
                                    <td>#pessoa.nome#</td>
                                    <td>#pessoa.sobrenome#</td>
                                    <td>#pessoa.idade#</td>
                                    <td>#pessoa.nome_profissao#</td>
                                    <td class="text-center">
                                        <a href="index.cfm?acao=editar&id=#pessoa.id#" class="btn btn-warning btn-sm">✏️ Editar</a>
                                        <a href="index.cfm?acao=excluir&id=#pessoa.id#" class="btn btn-danger btn-sm" onclick="return confirm('Tem certeza que deseja excluir?');">🗑 Excluir</a>
                                    </td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</cfoutput>

<!--- Script para abrir o modal automaticamente --->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('acao') === 'editar' && urlParams.get('id')) {
            const modal = new bootstrap.Modal(document.getElementById('pessoaModal'));
            modal.show();
        }
    });
</script>

<!--- Script para busca AJAX --->
<script>
function buscarPessoa() {
    const nome = document.getElementById("pesquisaNome").value;

    fetch("buscar_pessoa.cfm", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `nome=${encodeURIComponent(nome)}`
    })
    .then(response => response.text())
    .then(data => {
        document.getElementById("resultadoPesquisa").innerHTML = data;
        ajustarTabela(); // Ajusta o layout da tabela após carregar os dados
    })
    .catch(error => console.error("Erro na busca:", error));
}

function ajustarTabela() {
    const headers = document.querySelectorAll("thead th");
    const rows = document.querySelectorAll("tbody tr");

    headers.forEach((header, index) => {
        const headerWidth = header.offsetWidth; // Largura da coluna no cabeçalho
        rows.forEach(row => {
            if (row.children[index]) {
                row.children[index].style.width = `${headerWidth}px`; // Aplica a mesma largura às células
            }
        });
    });
}

// Ajusta o layout da tabela ao carregar a página
document.addEventListener("DOMContentLoaded", function() {
    ajustarTabela();
});
</script>