# dependências JS. Executar após docker compose build
- Instalar yarn
  docker compose run app yarn install

- Instalar BootStrap
  docker compose run app yarn add bootstrap@5.2.3
  
- Instalar Popperjs
  docker compose run app yarn add @popperjs/core

- Instalar Inputmask
  docker compose run app yarn add inputmask
  
- Instalar Toastify
  docker compose run app yarn add toastify-js

- Instalar Slim-select
  docker compose run app yarn add slim-select

- Instalar Clipboard
  docker compose run app yarn add clipboard

- Instalar Action-text
  docker compose run app bin/rails active_storage:install
  docker compose run app bin/rails action_text:install

# utils
  
  - Listar quantidade de arquivos na pasta
    find . -type f ! -name ".*" | wc -l

  - Listar arquivos na pasta por nomes
    find . -type f ! -name ".*"