## Setup Dev

### Docker

#### 0) Criar uma cópia do `.env.sample` para `.env`  na raiz do projeto.
```
cp .env.sample .env
```

Esse comando irá copiar as variáveis de ambiente para o arquivo `.env` que será lido pelo Rails.

#### 1) Para realizar todo o setup da imagem do projeto, utilize o script a seguir:
```
bin/docker-setup
```

Esse script realizará todo o setup inicial das dependências, como o `rails`, `postgresql` e gems.

#### 2) Após o setup inicial, o projeto pode ser inicializado com:
```
bin/docker-up
```

ou

```
bin/docker-up -d
```

Será iniciada a aplicação na porta `:3000` enquanto o terminal exibirá os diversos logs dos processos(`rails`, `postgresql`). Para conferir o container e o caminho de execução você pode consultar através do comando `docker compose ps` ou revisar o arquivo `Dockerfile`.

#### 3) Verificando os testes (opcional) - uma forma de validar todo o processo de setup é executando os testes, para isso use:
```
bin/docker-rspec
```

Obs: Para testes o docker da aplicação precisa estar inicializado.

#### 4) Atualizando o projeto (opcional)
Em casos de atualização de código é possivel realizar a atualização do docker com:
```
bin/docker-sync
```

Esse script vai remontar todos os containeres necessários e reinstalar dependências.

## Documentação da Aplicação
Para verificar os recursos disponíveis da aplicação basta acessar esse [link de documentação](http://localhost:3000/api-docs/index.html) do Swagger.

Todos os endpoint da aplicacão requerem um Basic Auth, portanto usar as credenciais abaixo:

```
username: user
password: user@clicksign.com
```

## Sugestões de uso dos containers

#### 1) Acessando container via bash
```
bin/docker-bash
```

#### 2) Acessando rails console
```
bin/docker-console
```

#### 3) Usando rails generators/tasks
```
bin/docker-rails g model User name:string
```
ou

```
bin/docker-rails db:migrate
```
