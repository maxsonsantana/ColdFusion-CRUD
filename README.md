# CouldFusion-CRUD
Simples projeto em CRUD com modal em CouldFusion(versão 10)

- **BANCO DE DADOS**
	O banco de dados está em mysql, mas pode utilizar qualquer outro banco e adicionar no DataSource do painel administratido do CF
	- O banco possui 2 tabelas até o momento
	1 - pessoa(Colunas: ID, NOME, SOBRENOME, IDADE, ID_PROFISSAO)
	2 - profissao(Colunas: ID, NOME, DESC)
	(A coluna ID_PROFISSAO da tabela pessoa faz referência a coluna ID da tabela PROFISSAO)
- **APLICAÇÃO**
	A aplicação consistem em 3 arquivos:
	1 - index.cfm(Arquivo principal)
	2 - gerarXls.cfm(Arquivo para gerar o xls da tabela)
	3 - gerarPdf.cfm(Arquivo para gerar o pdf da tabela)
	
- **NOTAS**
	- Essa aplicação foi desenvolvida para rodar no CouldFusion 10, porém pode funcionar em versões superiores, e pode dar falha em versões anteriores.
	- NãO foi trabalhado muito no layout, na parte visual, mas pode ser melhorada, além de ter outras coisas para se fazer e ajustar, porém com a tabela
	em banco criada e a conexão funcionando o sistema funciona.
	- Outras implementações a serem feitas até o momento seria a troca do código da profissão pelo nome, a pesquisa do funcionário, o cadastro da profissão,
	Sessão, login e etc...
