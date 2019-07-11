# KONG Site

Este repositório contém o código fonte para a página de documentação [Kong](https://github.com/Kong/kong). Há uma página [Jekyll](https://jekyllrb.com/) hospedada no GitHub pages.

## Desenvolva localmente com o Docker

>
```bash
make develop
```

## Desenvolva localmente sem o Docker

### Pré-requisitos

- [npm](https://www.npmjs.com/)
- [Bundler](https://bundler.io/)
- [Ruby](https://www.ruby-lang.org) (>= 2.0, < 2.3)
- [Python](https://www.python.org) (>= 2.7.X, < 3)

### Instalação

>
```bash
gem install bundler
npm install
```

### Execução

>
```bash
npm start
```

## Deploy

O deploy do repositório deve ser feito manualmente para o Github pages:

>
```bash
npm run deploy
```

## Busca

Nós usamos o Algolia [docsearch](https://www.algolia.com/docsearch) para nossa documentação de busca CE.
O index do algolia é mantido pelo Algolia através do serviço de busca de documentos. O [scraper](https://github.com/algolia/docsearch-scraper)
roda a cada 24 horas. A configuração usada pelo scraper é open source para
docs.konghq.com e pode ser encontrada [aqui](https://github.com/algolia/docsearch-configs/blob/master/configs/getkong.json).
Para atualizar o scraper config, você pode enviar uma pull request para o config. Para testar uma config localmente, você precisará rodar o scraper open source
[scraper](https://github.com/algolia/docsearch-scraper) com o seu próprio scraper para efetivar as mudanças.

## Gerando o Plugin da documentação do kit de desenvolvimento

- Faça um clone local do Kong.
- Instale o Luarocks (vem com o Kong)
- Instale o `ldoc` using Luarocks: `luarocks install ldoc 1.4.6`
- No repositório do Kong, dê uma olhada em branch/tag/release
- Execute: `KONG_PATH=path/to/your/kong/folder KONG_VERSION=0.14.x gulp pdk-docs`
- Esse comando vai tentar:
  * Obtenha uma lista atualizada de módulos do seu PDK local e ponha dentro do seu arquivo nav
  * Gere a documentação para todos os módulos do seu PDK (quando possível) e
    ponha em uma pasta dentro da versão do seu docs

## Gerando a Admin API, CLI e Configurando a Documentação

- Certifique-se que os executáveis `resty` e `luajit` estão no seu `$PATH` (instalar o Kong deve instalá-los)
- Algumas Lua rocks são necessárias. O jeito mais fácil de consegui-las é executando `make dev` no diretório Kong
- Faça o clone local do kong
- No repositório do Kong, cheque pelo branch/tag/release desejado
- Para gerar os Admin API docs:
  - Execute: `KONG_PATH=path/to/your/kong/folder KONG_VERSION=0.14.x gulp admin-api-docs`
  - Este comando tentará:
    * Comparar os Kong schemas e as rotas Admin API com os conteúdos do arquivo
      `autodoc-admin-api/data.lua` se houver erros de incompatibilidade ou dados faltando.
    * Se não forem encontrados erros, um novo arquivo `admin-api.md` será gerado no caminho correspondente
      para o KONG_VERSION fornecido.
- Para gerar os CLI docs:
  - Executar: `KONG_PATH=path/to/your/kong/folder KONG_VERSION=0.14.x gulp cli-docs`
  - Esse comando irá:
    * Extrair um output do `--help` para cada `kong` CLI subcomando
    * Gerar um novo `cli.md` no caminho correspondente para a KONG_VERSION fornecida.
- Para gerar os Configuration docs:
  - Execute: `KONG_PATH=path/to/your/kong/folder KONG_VERSION=0.14.x gulp conf-docs`
  - Esse comando irá:
    * Faça o parse do arquivo Kong `kong.conf.default` e extraia seções, nomes de variáveis, descrições e valores default
    * Ponha tudo dentro do arquivo `configuration.md` em um caminho que seja igual a KONG_VERSION.
    * O comando vai sobrescrever completamente o arquivo, incluindo o texto antes e depois da lista de vars.
    * Os dados usados para as partes antes/depois podem ser encontrados em `autodoc-conf/data.lua`

## Listando a sua extensão no Kong Hub

Nós encorajamos os desenvolvedores a listar seus plugins e integrações Kong (as quais nos referimos coletivamente como "extensions") no
[Kong Hub](https://docs.konghq.com/hub), com a documentação hospedada
no site da Kong para acesso imediato.

Acesse [CONTRIBUINDO](https://github.com/Kong/docs.konghq.com/blob/master/CONTRIBUTING.md#contributing-to-kong-documentation-and-the-kong-hub) para mais informações.
