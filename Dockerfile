# Target latest (2019-10-02) nginx 1.17.4
FROM nginx:1.17.4-alpine AS base

FROM base AS builder

# nginx:alpine contains NGINX_VERSION environment variable, like so:
# ENV NGINX_VERSION 1.15.0

# Our module version
ENV MODULE_NAME ngx_http_upstream_jdomain_module
ENV MODULE_DIR /nginx-module

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev

# Copy module
RUN mkdir /nginx-module
COPY config ngx_http_upstream_jdomain.c /nginx-module/

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
	mkdir -p /usr/src && \
  tar -zxC /usr/src -f nginx.tar.gz && \
  cd /usr/src/nginx-$NGINX_VERSION && \
  sh -c "./configure --with-compat $CONFARGS --add-dynamic-module=$MODULE_DIR" && \
  make modules
RUN sh -c "cp /usr/src/nginx-$NGINX_VERSION/objs/ngx_http_upstream_jdomain_module.so /etc/nginx/modules/"

FROM base
LABEL version="1.0" maintainer="Herman Banken <hermanbanken@gmail.com>" repository="https://github.com/hermanbanken/ngx_upstream_jdomain"
COPY --from=builder /etc/nginx/modules/ngx_http_upstream_jdomain_module.so /etc/nginx/modules/