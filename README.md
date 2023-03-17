
# Anbiente Docker Para Projetos PHP e Laravel


### Passo a passo
Clone Repositório
```sh
git clone https://github.com/wagnersorio/docker-php-82.git
```

```sh
cd docker-php-82/
```

Remova o versionamento
```sh
rm -rf .git/
```


Crie o Arquivo .env
```sh
cp .env.example .env
```


Atualize as variáveis de ambiente do arquivo .env
```dosini

NGINX_HTTP_PORT=8989

MYSQL_DATABASE=MYSQL_DB
MYSQL_ROOT_PASSWORD=root
MYSQL_PASSWORD=root
MYSQL_USER=root
MYSQL_PORT=33060

REDIS_PORT=6379 

MAILHOG_PORT=1025
MAILHOG_DASHBOARD_PORT=8025

```

Edite o arquivo hosts e adicione a linha
```sh
127.0.0.1 example-app.local
```


Criar o arquivo de configuração do nginx
```sh
cp nginx/app01.conf nginx/example-app.conf
```


Editar o arquivo de configuração do nginx
de:
```sh
server_name app01.local;
root /var/www/app01/public;
```


para:
```sh
server_name example-app.local;
root /var/www/example-app/public;
```


Suba os containers do projeto
```sh
docker-compose up -d
```


Acessar o container
```sh
docker-compose exec php bash
```

Criar  o projeto
```sh
composer create-project laravel/laravel example-app
```

Acessar o projeto
[http://example-app.local:8989](http://example-app.local:8989)