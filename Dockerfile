FROM nginx:stable-alpine

# update
RUN apk update && apk upgrade

# install packages
RUN apk -y groupinstall 'Development Tools'
RUN apk -y install epel-release \
    openssl-devel \
    pcre-devel

# install RTMP
RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git


# replace nginx.conf
COPY configs/nginx.conf /etc/nginx/nginx.conf


CMD ["service nginx start"]