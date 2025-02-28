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
        <!--- SELECT * FROM pessoa WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"> --->
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
    SELECT * FROM pessoa ORDER BY id DESC
</cfquery>

<!--- Importando o Bootstrap --->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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
                                // Captura o dropdown list e o campo id_profissao
                                const dropdown = document.getElementById("nome_id_profissao");
                                const idProfissaoInput = document.getElementById("id_profissao");

                                // Adiciona um listener para o evento de mudança no dropdown
                                dropdown.addEventListener("change", function() {
                                    // Atualiza o valor do campo id_profissao com o valor selecionado no dropdown
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

<!---BOTÕES--->
<div class="container" id="botoes">
    <!--- Botão para abrir o modal --->
    <div class="row">
        <div class="col">
            <form>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#pessoaModal">
                    <cfif form.id EQ ''>Adicionar Pessoa<cfelse>Editar Pessoa</cfif>
                </button>
            </form>
        </div>
    </div>

    <!--- Botão para gerar PDF --->
    <div class="row">
        <div class="col">
            <form action="gerarPDF.cfm" method="post" target="_blank">
                <button type="submit" class="btn btn-info">
                    📄 Gerar PDF
                </button>
            </form>
        </div>
    </div>

    <!--- Botão para gerar XLS --->
    <div class="row">
        <div class="col">
            <form action="gerarXLS.cfm" method="post" target="_blank">
                <button type="submit" class="btn btn-success">
                    📊 Gerar XLS
                </button>
            </form>
        </div>
    </div>

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
                    <table class="table table-striped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Sobrenome</th>
                                <th>Idade</th>
                                <th>profissao</th>
                                <th class="text-center">Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop query="pessoa">
                                <tr>
                                    <td>#pessoa.id#</td>
                                    <td>#pessoa.nome#</td>
                                    <td>#pessoa.sobrenome#</td>
                                    <td>#pessoa.idade#</td>
                                    <td>#pessoa.id_profissao#</td>
                                    <td class="text-center">
                                        <!-- Editar -->
                                        <a href="index.cfm?acao=editar&id=#pessoa.id#" class="btn btn-warning btn-sm">
                                         		   ✏️ Editar
                                        </a>
                                        <!-- Excluir -->
                                        <a href="index.cfm?acao=excluir&id=#pessoa.id#" class="btn btn-danger btn-sm" 
                                           onclick="return confirm('Tem certeza que deseja excluir?');">
                                        		    🗑 Excluir
                                        </a>
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