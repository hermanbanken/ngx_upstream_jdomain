# Target latest (2019-10-02) nginx 1.17.4
FROM nginx:1.17.4-alpine AS base

FROM base AS builder

# nginx:alpine contains NGINX_VERSION environment variable, like so:
# ENV NGINX_VERSION 1.15.0

# Our module version
ENV MODULE_NAME nginx-upstream-dynamic-servers
ENV MODULE_VERSION master
ENV MODULE_REPOSLUG https://github.com/hermanbanken/ngx_upstream_jdomain

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
  wget "${MODULE_REPOSLUG}/archive/${MODULE_VERSION}.tar.gz" -O dynamic-module.tar.gz

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

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
	mkdir -p /usr/src && \
  tar -zxC /usr/src -f nginx.tar.gz && \
  tar -xzvf "dynamic-module.tar.gz" && \
  MODULEDIR="$(pwd)${MODULE_NAME}-${MODULE_VERSION}" && \
  cd /usr/src/nginx-$NGINX_VERSION && \
  sh -c "./configure --with-compat $CONFARGS --add-module=$MODULEDIR" && \
  make && make install

FROM base
LABEL version="1.0" maintainer="Herman Banken <hermanbanken@gmail.com>" repository="https://github.com/hermanbanken/ngx_upstream_jdomain"
# Replace bundled NGINX with patched NGINX
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
