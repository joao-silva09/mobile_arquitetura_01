# mobile_arquitetura_01

Projeto Flutter com arquitetura em camadas, Riverpod para gerenciamento de
estado e integracao com a API DummyJSON para login, produtos, detalhes e
favoritos.

## Como executar

```bash
flutter pub get
flutter run
```

## Credenciais de teste

- Usuario: `emilys`
- Senha: `emilyspass`

## API DummyJSON

- `POST https://dummyjson.com/auth/login`
- `GET https://dummyjson.com/products`
- `GET https://dummyjson.com/products/{id}`

## Organizacao da arquitetura

- `domain/entities`: entidades principais da aplicacao.
- `data/models`: modelos usados para converter dados da API.
- `data/datasources`: fontes remotas de dados.
- `data/repositories`: contratos e implementacoes de repositorios.
- `core/session`: controle de sessao autenticada.
- `presentation/viewmodels`: estados e regras de tela com Riverpod.
- `presentation/pages`: telas da aplicacao.

## Justificativa do Riverpod

O Riverpod foi usado porque sessao, autenticacao, produtos e favoritos sao
estados compartilhados entre varias telas. Com ele, a interface e reconstruida
automaticamente quando esses estados mudam, mantendo a separacao entre regras
de apresentacao e widgets.

## Checklist consolidado

- [x] Repositorio chamado mobile_arquitetura_01
- [x] Projeto Flutter executavel
- [x] Organizacao em camadas ou pastas separadas
- [x] Uso da API DummyJSON
- [x] Tela de login
- [x] Validacao de usuario e senha
- [x] POST /auth/login funcionando
- [x] Tratamento de erro no login
- [x] Sessao de usuario autenticado
- [x] Bloqueio de acesso sem login
- [x] Tela principal de produtos
- [x] Nome do usuario autenticado exibido
- [x] Botao de logout
- [x] GET /products funcionando
- [x] Modelo Product ajustado para DummyJSON
- [x] Lista com titulo, preco e imagem
- [x] Tela de detalhes do produto
- [x] GET /products/{id} ou envio do produto selecionado
- [x] Detalhes com nome, preco, descricao e imagem
- [x] Navegacao entre telas
- [x] Uso de Navigator.push ou rotas nomeadas
- [x] Uso de Navigator.pop
- [x] Controle de favoritos
- [x] Marcar produto como favorito
- [x] Remover produto dos favoritos
- [x] Atualizacao automatica da interface
- [x] Uso de Provider, Riverpod, BLoC ou setState justificado
- [x] Separacao entre modelo, servico, sessao e tela
- [x] Tratamento de carregamento
- [x] Tratamento de erro nas requisicoes
