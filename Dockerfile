##############
# base image #
##############
FROM alpine:3.14 as nginx-base

# Parameter init
ARG NGINX_FILE=nginx-1.21.3
ARG NGINX_RTMP_FILE=1.2.2

# prepare environment
RUN apk add --update \
    build-base \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    wget

# install nginx
RUN cd /tmp \
    && wget https://nginx.org/download/${NGINX_FILE}.tar.gz \
    && tar -zxvf ${NGINX_FILE}.tar.gz \
    && rm ${NGINX_FILE}.tar.gz \
    && mv ${NGINX_FILE} nginx-source


# install RTMP
RUN cd /tmp \
    && wget https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v${NGINX_RTMP_FILE}.tar.gz \
    && tar -zxvf ${NGINX_RTMP_FILE}.tar.gz \
    && rm ${NGINX_RTMP_FILE}.tar.gz \
    && mv nginx-rtmp-module-${NGINX_FILE} nginx-rtmp-module-source


# build nginx
RUN cd /tmp/nginx-source \
    && ./configure \
        --conf-path=/etc/nginx/nginx.conf \
        --add-module=/tmp/nginx-rtmp-module-source \
        --with-debug \
        --with-threads \
    && make \
    && make install



################
# deploy image #
################
FROM alpine:3.14 as nginx-deploy

# prepare env
RUN apk add --update \
  ca-certificates \
  openssl \
  pcre \
  curl \
  rtmpdump \
  x264-dev \
  x265-dev

# get ngnix
COPY --from=nginx-base /usr/local/nginx /usr/local/nginx
COPY --from=nginx-base /etc/nginx /etc/nginx

# configure structure
ENV PATH "${PATH}:/usr/local/nginx/sbin"
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# replace nginx.conf
COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx.service /usr/lib/systemd/system/

# Set default ports.
EXPOSE 1935

CMD ["nginx", "-g", "daemon off;"]