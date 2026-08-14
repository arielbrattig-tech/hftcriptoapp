# Página estática servida por nginx.
# Imagem final ~50 MB, sem etapa de build (o projeto é HTML/CSS/JS puro).
FROM nginx:1.27-alpine

# Porta padrão. Plataformas como Cloud Run, Render e Railway injetam a
# variável PORT em tempo de execução e sobrescrevem este valor.
ENV PORT=8080

# Restringe o envsubst do entrypoint a substituir SOMENTE ${PORT}, para que
# variáveis internas do nginx ($uri, $host, ...) nunca sejam trocadas.
# O \$ é escapado para chegar ao regex como um $ literal (âncora de fim).
ENV NGINX_ENVSUBST_FILTER="^PORT\$"

# O entrypoint da imagem processa /etc/nginx/templates/*.template com envsubst
# no boot e grava o resultado em /etc/nginx/conf.d/.
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

COPY index.html /usr/share/nginx/html/index.html

# Segunda pagina, servida em /prova-social/
COPY prova-social/ /usr/share/nginx/html/prova-social/

EXPOSE 8080

# ENTRYPOINT e CMD são herdados da imagem base (nginx -g "daemon off;").
