FROM klakegg/hugo:latest-ext as hugo
# klakegg/hugo:latest-ext 

COPY ./www /site
COPY ./_keys-to-the-castle.tf /site

WORKDIR /site
RUN hugo --config ./config.toml

#Copy static files to Nginx docker pull nginx:1-alpine3.18
FROM nginx:1-alpine3.18
COPY --from=hugo /site/public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html