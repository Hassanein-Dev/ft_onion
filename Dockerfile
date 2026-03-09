FROM debian:bullseye

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nginx \
    tor \
    openssh-server \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/www/html \
    && mkdir -p /var/lib/tor/hidden_service \
    && mkdir -p /var/run/sshd \
    && mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html/index.html
COPY torrc /etc/tor/torrc
COPY sshd_config /etc/ssh/sshd_config

RUN chown -R debian-tor:debian-tor /var/lib/tor \
    && chmod 700 /var/lib/tor/hidden_service

RUN mkdir -p /var/www && chown -R www-data:www-data /var/www

EXPOSE 80 4242

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
