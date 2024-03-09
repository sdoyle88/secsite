FROM klakegg/hugo as hugo

COPY ./secops /site

WORKDIR /site
RUN hugo --config ./config.toml

#Copy static files to Nginx
FROM nginx:alpine
COPY --from=hugo /site/public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html